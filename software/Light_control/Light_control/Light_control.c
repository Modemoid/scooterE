/*
 * Light_control.c
 *
 * Created: 15.12.2014 15:32:42
 *  Author: Kartsev Pavel
 */ 

#define F_CPU 1000000UL
//#define DEBUG
#define TurnControl //if turn control used //now work only blink version
#define TurnBlink //if turn signal must blink
#define HeadLightControl // if headlight control used 
//#define HeadLight_Dual_Beam //use for classic bulb with 2 separate spring
#define HeadLight_Single_Beam //Used for bi-xenon lo beam work forever, hi control beam solenoid. 
//#define adc7Use //����������� � ������������� ������� � ���������� - �� �������
//#define i2c_Comm //if present i2c communication with other device 
#define Strobe // if stroboscope present 
#define Strobe_Bink // if strobe must blink
#define DayLight // DayLight switch //now not used
#define DayLightOnStart //define if U want get daylight turned on sturtup
#define Strobe_TIME 64 //*0.015s? = strobe work time after single button press, see Strob_blink define 
#define debounce_delay //if defined present key debounce delay, but logic work not need it, it can be removed. 
#define debounce_time 50 //time in MS

#define LED1 0
#define LED2 1
#define LED3 2
#define LED4 3
#define LED_PORT PORTB
#define LED_DDR DDRB

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>
#include <util/twi.h>

//gobal VAR
unsigned char OutPort; //for output port D (use only 6 end bit, 0 and 1 bit - UART now reserved for future options)
unsigned char Strobe_on = 0; //for strobe
unsigned char Strobe_count = 0;//for strobe
unsigned char adc6;
unsigned char AdcKey = 0;
unsigned char turnOn = 0; 
unsigned char T1temp = 0;




#ifdef i2c_Comm
#define i2c_MasterAddress 	0xA2	// ����� �� ������� ����� ����������
#define i2c_i_am_slave		1	// ���� �� ��� � ������� �������� �� 1. � �� �� �������!
#define twi_port PORTC
#define twi_ddr DDRC
#define SDA_pin 4
#define SCL_pin 5
#define i2cBuffSize 2
//#define i2c_MaxPageAddrLgth	2	// ������������ �������� ������ ��������. ������ ����� �������� ��� ���� ��� ��� �����.
								// ������� �� ���� ������ ��� ������ ����������.
#define TWI_SUCCESS 0xff
#define TWI_ADR_BITS     1       // ������� ������ � �������� ������
#define TRUE             1
#define FALSE            0

//char i2c_SlaveAddress = 0xD0;// 0xD0 = ds1307; 0x90 = lm75
char i2c_Buffer[i2cBuffSize];//TX buffer
//char i2c_BufferR[i2cBuffSize];//RXbuffer
char i2c_index = 0;
char i2c_ByteCount;				// ����� ���� ������������
//char i2c_PageAddress[i2c_MaxPageAddrLgth];	// ����� ������ ������� (��� ������ � sawsarp)
//char i2c_PageAddrIndex;				// ������ ������ ������ �������
//char i2c_PageAddrCount;				// ����� ���� � ������ �������� ��� �������� Slave
char ptr = 0; //��������� ���������� ��� �������

//����� ��� ���������
volatile static uint8_t twiBuf[i2cBuffSize];

//������� ���� ����� ��������
volatile static uint8_t twiMsgSize;

//������ ������
volatile static uint8_t twiState = TW_NO_INFO;

#endif
#ifdef adc7Use
char adc7,adcstate=0; //For ADC ch6 vector
#endif

//End of globa var
ISR(TIMER0_OVF_vect) //used for strobe //ok. work
{
 #ifndef Strobe_Bink//ok. work
	 if (Strobe_on)
	 {
	  Strobe_on++;
	  OutPort |= 0b00100000;
	  }else 
	  {
		  OutPort &= 0b11011111;
	  }

#endif

  #ifdef Strobe_Bink //ok. work
 	 if (Strobe_on)
	  {
		  Strobe_on++;
		  
		 if (Strobe_on < Strobe_TIME && Strobe_on > (Strobe_TIME/4+Strobe_TIME/2+Strobe_TIME/8)) //128 - 112
		 {
				 	 OutPort &= 0b11011111;
		 }
		 if (Strobe_on < (Strobe_TIME/4+Strobe_TIME/2+Strobe_TIME/8) && Strobe_on > (Strobe_TIME/2+Strobe_TIME/4)) //112-96
		 {
			 	 	 OutPort |= 0b00100000;
		 }
		 if (Strobe_on < (Strobe_TIME/2+Strobe_TIME/4) && Strobe_on > (Strobe_TIME/2) ) //96-64
		 {
			 OutPort &= 0b11011111;
		 }		
		 if (Strobe_on < Strobe_TIME/2 && Strobe_on > (Strobe_TIME/4+Strobe_TIME/8)) //64-48
		 {
			 	 	 OutPort |= 0b00100000;
		 }
		 if (Strobe_on < (Strobe_TIME/4+Strobe_TIME/8) && Strobe_on > (Strobe_TIME/4) ) //48-32
		 {
			 OutPort &= 0b11011111;
		 }		
		 if (Strobe_on < Strobe_TIME/4 && Strobe_on > (Strobe_TIME/8) )//32-16
		 {
			 	 	 OutPort |= 0b00100000;
		 }
		 if (Strobe_on < (Strobe_TIME/8) && Strobe_on > (Strobe_TIME/16) ) //16-8
		 {
			 OutPort &= 0b11011111;
		 }
		 if (Strobe_on < Strobe_TIME/16) //8-0
		 {
			 OutPort |= 0b00100000;
		 }
		 if (Strobe_on > Strobe_TIME) //strobe turn off
		 {
			
			 Strobe_on = 0;
			  OutPort &= 0b11011111;
		 }
		
	  
 	 }
  #endif
  	if (Strobe_on > Strobe_TIME)
  	{
	  	Strobe_on = 0;
  	}
} 
ISR(ADC_vect) //buttons 
{
#ifndef adc7Use	
	adc6 = ADCL;
	adc6 = ADCH;
#endif
	
#ifdef adc7Use //now not work. 
if 	(adcstate = 0)
{
	adc6 = ADCL;
	adc6 = ADCH;
	adcstate = 1;
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<ADIE|1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);

	ADCSRA = (1<<ADSC);
	
		
}
if (adcstate = 1)
{
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<ADIE|0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	//1<<REFS0|1<<REFS1 = �� ���������� 2.5�,
	//0<<REFS0|0<<REFS1 = AREF
	//adlar = 1 ������� ���� (ADCL) �� ����� - ��� �����, ����� ������ ADCH
	//mux0-mux3 �������� ����� ���
	//0<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 = ADC0
	//1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 = ADC1

	//0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC6
	//1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC7
	adc7 = ADCL;
	adc7 = ADCH;
	adcstate = 0;
	ADCSRA = (1<<ADSC);
	}
#endif	
	
	
	
}
ISR(TIMER1_COMPA_vect)//turn signal blink 
{
if (T1temp == 0)
{
	if (turnOn == 0b00000001 )
	{
		OutPort |=0b10000000;
	}
	if (turnOn == 0b00000010)
	{
		OutPort |=0b01000000;
	}
	if (turnOn == 0b00000011)
	{
		OutPort |= 0b11000000;
	}
	if (turnOn == 0b00000000 )
	{
		 OutPort &= 0b00111111;
	}
T1temp = 1;
}
else if (T1temp == 1)
{
	if (turnOn == 0b00000001 )
	{
		OutPort &=0b01111111;
	}
	if (turnOn == 0b00000010)
	{
		OutPort &=0b10111111;
	}
	if (turnOn == 0b00000011)
	{
		OutPort &= 0b00111111;
	}
	if (turnOn == 0b00000000 )
	{
		OutPort &= 0b00111111;
	}
	T1temp = 0;
}

		
}
#ifdef i2c_Comm
ISR(TWI_vect)
{
	
//����� ��������� ��� ������
uint8_t stat = TWSR & 0xF8;
//LED_PORT|= 1<<LED1;
//������������ ���
switch (stat)
{
	/*case TW_START:
	case TW_REP_START:
	ptr = 0; //��������� ���������� ��� �������
		LED_PORT|= 1<<LED2;
	case TW_MT_SLA_ACK:
	case TW_MT_DATA_ACK:

	if (ptr < twiMsgSize)
	{ //���� �� ��� ��������
		//��������� ���� ���������
		TWDR = twiBuf[ptr];
		
		//���������� ���� TWINT
		TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT);
		
		//����������� ��������� ����������
		ptr++;
	}
	else{ //���� �������� ���

	//������������� ���������, ��� ������ ��������
	twiState = TWI_SUCCESS;

	//��������� ����, ��������� ����������
	TWCR = (1<<TWEN)|(1<<TWINT)|(1<<TWSTO)|(0<<TWIE);
	}
	break;

	case TW_MR_DATA_ACK:
	twiBuf[ptr] = TWDR; //��������� ���� ������
	ptr++;
	case TW_MR_SLA_ACK:

	if (ptr < (twiMsgSize-1)){ //��� ������������� ����?
	//���, ��������� �������������
	TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(1<<TWEA);
		}
		else {
		//��, ������������� �� ���������
		TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT);
		}
		break;
	case TW_MR_DATA_NACK:
		twiBuf[ptr] = TWDR;
		twiState = TWI_SUCCESS;
		TWCR = (1<<TWEN)|(1<<TWINT)|(1<<TWSTO);
		break;
	case TW_MT_ARB_LOST:
		TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(1<<TWSTA);
		break;
	/*������ ���� ��� ������*/
	case TW_ST_SLA_ACK: //0xA8 SLA+R received, ACK returned  ��� ����� �� ������ ������ �� ����� ���������� � ������� ��� �������� ��������.
			 //and load first data
			 LED_PORT|= 1<<LED1; //set �� ������
			 //LED_PORT&= ~(1<<LED3);//clear
				//i2c_Buffer[0] = 0xAC;
				//i2c_Buffer[1] = 0xCE;
				ptr=0;
				TWDR = 0xEE;
				//TWDR = i2c_Buffer[0];
				TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA);
				
				break;
	case TW_SR_SLA_ACK: //0x60 Receive SLA+W ����� �� ����, ������ �� �������, �� � ��� �� ��������. � ��� ��� �� ����� ������� ��������� :)	
			LED_PORT|= 1<<LED2; //�� ������
			//set				ptr=0;
			TWDR = OutPort;
			//TWDR = i2c_Buffer[0];
			TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA);
			break;
	case TW_ST_DATA_ACK: //Send Byte Receive ACK �� ���� �� ��� ����. �� ��� ACK. � �� ��� �������� ������ ����� ��� ��� ���� (���������) � �������� ���� NACK�. ��� �� � ��� ������ �� � ����� ��� ����������.	
			//TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|(0<<TWWC);
			////////��� �����    ���=�����   ����     ����.���  ����.����� ����.����  ��������
			LED_PORT|= 1<<LED4; //�� ������
			//TWCR = (1<<TWINT)|(1<<TWEN)|(0<<TWSTO);
			break;
	case TW_ST_DATA_NACK:
			LED_PORT|= 1<<LED2;
			TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA);
			break;
	/*����� ��������� �� �������*/
	case TW_MT_SLA_NACK:
	case TW_MR_SLA_NACK:
	case TW_MT_DATA_NACK:
	case TW_BUS_ERROR:
		//��������� ��������� ���
		twiState = stat;
		LED_PORT|= 1<<LED3; 
		//��������� ���������� ������
		TWCR = (1<<TWEN)|(0<<TWIE);
		break;
	default:
			//��������� ��������� ���
			twiState = stat;

	}	
}

void Init_i2c(void)							// ��������� ������ �������
{
	twi_port |= 1<<SCL_pin|1<<SDA_pin;			// ������� �������� �� ����, ����� ���� �� ��������� ����������
	twi_ddr &=~(1<<SCL_pin|1<<SDA_pin);
	TWBR = 0x50;         						// �������� ������� 8Mhz = 23809 ��
	TWSR = 0x00;
}
void TWI_SendData(uint8_t *msg, uint8_t msgSize)
{
   uint8_t i;
 
   /*���� ,����� TWI ������ �����������*/
   while(TWCR & (1<<TWIE)); 
 
   /*����. ���������� ���� ��� ��������
   � ������ ���� ���������*/
   twiMsgSize = msgSize;
   twiBuf[0] = msg[0]; 
 
   /*���� ������ ���� ���� SLA+W, �� 
   ��������� ��������� ���� ���������*/
   if (!(msg[0] & (1<<TW_READ))){ 
      for (i = 1; i < msgSize; i++){ 
         twiBuf[i] = msg[i];
      }
   }
 
   twiState = TW_NO_INFO ;
 
   /*��������� ���������� � ��������� ��������� ����� */
   TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(1<<TWSTA); 
}
/****************************************************************************
 �������� - �� ����� �� TWI ������. ������������ ������ ������
****************************************************************************/
static uint8_t TWI_TransceiverBusy(void)
{
  return (TWCR & (1<<TWIE));                 
}

/****************************************************************************
 ����� ������ TWI ������
****************************************************************************/
uint8_t TWI_GetState(void)
{
  while (TWI_TransceiverBusy());             
  return twiState;                        
}
/****************************************************************************
 ���������� ���������� ������ � ����� msg � ���������� msgSize ����. 
****************************************************************************/
uint8_t TWI_GetData(uint8_t *msg, uint8_t msgSize)
{
	uint8_t i;

	while(TWI_TransceiverBusy());    //����, ����� TWI ������ �����������

	if(twiState == TWI_SUCCESS){     //���� ��������� ������� �������,
	for(i = 0; i < msgSize; i++){  //�� ������������ ��� �� ����������� ������ � ����������
	msg[i] = twiBuf[i];
}
  }
  
  return twiState;                                   
}

void Init_Slave_i2c(int Addr)				// ��������� ������ ������ (���� �����)
{
	//LED_PORT|= 1<<LED3; //set
	TWAR = i2c_MasterAddress;					// ������ � ������� ���� �����, �� ������� ����� ����������.
	// 1 � ������� ���� ��������, ��� �� ���������� �� ����������������� ������
	//SlaveOutFunc = Addr;						// �������� ��������� ������ �� ������ ������� ������
	// TWCR = (1<<TWEN)|(1<<TWEA)|(1<<TWIE);
	
	TWCR = 	0<<TWSTA|
			0<<TWSTO|
			0<<TWINT|
			1<<TWEA|
			1<<TWEN|
			1<<TWIE;							// �������� ������� � �������� ������� ����.

}
#endif


int main(void)
{
	
unsigned char butt,butt1,swadc6;
//��������� 8��� ������� 
TCCR0|=(1<<CS00)|(1<<CS01); // ����������� � ������������� 64. 1 ������������ = 0.016384 ���
TIMSK|=(1<<TOIE0)|(1<<OCIE1A);
//��������� 16 ��� �������
TCCR1A|=(0<<COM1A0)|(0<<COM1A1)|(0<<COM1B0)|(0<<COM1B1)|(0<<FOC1A)|(0<<FOC1B)|(0<<WGM11)|(0<<WGM10);
TCCR1B|=(0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(1<<CS11)|(0<<CS10);//prescalar = 8
OCR1A = 0x7A11;


	//��������� ������ ��� ������
	DDRC = 0b00110000;  //kb port
	PORTC = 0b00001111; //kb port

	//��������� ������ 
	DDRD = 0b11111100;  //kb port
	PORTD = 0b00000000; //kb port
	//PINx ������� ������
	//PORTx 1=pullup(in)
	//DDRx 0=in 1=out
	//��������� ������
	DDRB = 0b00001111;  //TestLed port
	PORTB = 0b00000000; //TestLed port
	//����� ��������� ������

#ifdef HeadLightControl
	//adc setup
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	//1<<REFS0|1<<REFS1 = �� ���������� 2.5�,
	//0<<REFS0|0<<REFS1 = AREF
	//adlar = 1 ������� ���� (ADCL) �� ����� - ��� �����, ����� ������ ADCH
	//mux0-mux3 �������� ����� ��� 0-0<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 1-1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3
	//0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC6
	//1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC7
#ifndef adc7Use

	ADCSRA = (1<<ADEN|1<<ADSC|1<<ADFR|1<<ADIE|1<<ADPS0|1<<ADPS1|1<<ADPS2);
#endif
#ifdef adc7Use
	ADCSRA = (1<<ADEN|1<<ADSC|0<<ADFR|1<<ADIE|1<<ADPS0|1<<ADPS1|1<<ADPS2);
#endif
	//adcstate = 0;

#endif
#ifdef DayLightOnStart
OutPort |=0b00000100;
OutPort &=0b11100111;
#endif




#ifdef i2c_Comm_master
{
	Init_i2c();

	/*�������������� ���������*/
	i2c_Buffer[0] = (i2c_SlaveAddress &= 0xFE);
	i2c_Buffer[1] = 0x00;
	i2c_Buffer[2] = 0b10000101;
	i2c_Buffer[3] = 0b01000100;
	i2c_Buffer[4] = 0b00100010;

	/*���������� ���*/
	TWI_SendData(i2c_Buffer, 6);
	i2c_Buffer[0] = (i2c_SlaveAddress &= 0xFE);
	i2c_Buffer[1] = 0x07;
	i2c_Buffer[2] = 0b10010000;
	TWI_SendData(i2c_Buffer, 3);
}
#endif
#ifdef i2c_Comm
//{
//LED_PORT|= 1<<LED4; //set
Init_Slave_i2c(i2c_MasterAddress);
	
//}
#endif
_delay_ms(50);
sei();//��������� ���������� ���������	
    while(1)
    {	
#ifdef TurnControl
		butt = 	PINC&0b00000111;
		
#ifdef TurnBlink
{
	switch (butt)
	{
		case 0b00000110: turnOn |= 0b00000001;break;
		case 0b00000101: turnOn = 0;break;
		case 0b00000011: turnOn |= 0b00000010;break;
		default: ;
	}
}
#endif	

/*#ifndef TurnBlink
{ 
		switch (butt)
			{
				case 0b00000110: OutPort |= 0b10000000;break;
				case 0b00000101: OutPort &= 0b00111111;break;
				case 0b00000011: OutPort |= 0b01000000;break;					
				default: ;
			}
}
#endif*/
#endif
#ifdef Strobe //set strob_on if button pressed
	butt1 = 	PINC&0b00001000;
	if (!butt1) 
	{
		Strobe_on = 1;
	}

#endif
#ifdef DayLight
{
	
}
#endif
#ifdef HeadLightControl
if (30>adc6 && adc6>5 )
{
	AdcKey=1;
}

if (100>adc6 && adc6>60)
{
	AdcKey=2;
}
if (150>adc6 && adc6>100)
{
	AdcKey=3;
}
if (150<adc6)
{
	AdcKey=0;
}

#endif

#ifdef HeadLight_Single_Beam
{
	switch (AdcKey)
	{
		case 1:
		{

			OutPort |=0b00011000;
			OutPort &=0b11111011;			
			break;
		}
		case 2:
		{
			OutPort |=0b00001000;
			OutPort &=0b11101011;

			break;
		}
		case 3:
		{
			OutPort |=0b00000100;
			OutPort &=0b11100111;
			break;
		}

		case 0:
		{
			
			break;
		}
		default: ;
	}
}

#endif

#ifdef HeadLight_Dual_Beam
{
switch (AdcKey)
{
	case 1: 
	{ 
		OutPort |=0b00001000;
		OutPort &=0b11101011;
		
		break;
	}
	case 2:
	{
		OutPort |=0b00010000;
		OutPort &=0b11110011;
		break;
	}
	case 3:
	{
		OutPort |=0b00000100;
		OutPort &=0b11100111;
		break;
	}

	case 0:
	{
		
		break;
	}			
	default: ;
}
}
#endif
		
#ifdef debounce_delay
_delay_ms(debounce_time);
#endif	

	
	PORTD = OutPort;	
	//PORTB = turnOn;	
		
        //TODO:: Please write your application code 
    }
}