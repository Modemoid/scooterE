/*
 * Light_control.c
 *
 * Created: 15.12.2014 15:32:42
 *  Author: Kartsev Pavel
 */ 

#define F_CPU 8000000UL
//#define DEBUG
#define TurnControl //if turn control used //now work only blink version
#define TurnBlink //if turn signal must blink
#define TurnBlinkTime03s //aternative TurnBlinkTime025s 
#define HeadLightControl // if headlight control used 
//#define HeadLight_Dual_Beam //use for classic bulb with 2 separate spring
#define HeadLight_Single_Beam //Used for bi-xenon lo beam work forever, hi control beam solenoid. 
//#define adc7Use //разобраться с переключением каналов в прерывании - на будущее
//#define i2c_Comm //if present i2c communication with other device 
//define i2c_addres 0x40 //my i2c adress
#define Strobe // if stroboscope present 
#define Strobe_Bink // if strobe must blink
#define DayLight // DayLight switch //now not used
#define DayLightOnStart //define if U want get daylight turned on sturtup
#define Strobe_TIME 128 //strobe work time after single button press, see Strob_blink define 
#define debounce_delay //if defined present key debounce delay, but logic work not need it, it can be removed. 
#define debounce_time 30 //time in MS
//#define OutPort PORTD


#ifdef DEBUG_LEDS

#define LED1 0
#define LED2 1
#define LED3 2
#define LED4 3
#define LED_PORT PORTB
#define LED_DDR DDRB
#define SetLed1 LED_PORT|= 1<<LED1; //set
#define SetLed2 LED_PORT|= 1<<LED2; //set
#define SetLed3 LED_PORT|= 1<<LED3; //set
#define SetLed4 LED_PORT|= 1<<LED4; //set
#define ClearLed1 LED_PORT&= ~(1<<LED1);//clear
#define ClearLed2 LED_PORT&= ~(1<<LED2);//clear
#define ClearLed3 LED_PORT&= ~(1<<LED3);//clear
#define ClearLed4 LED_PORT&= ~(1<<LED4);//clear
#define SwitchLed1 LED_PORT = LED_PORT ^ (1<<LED1); //switch
#define SwitchLed2 LED_PORT = LED_PORT ^ (1<<LED2); //switch
#define SwitchLed3 LED_PORT = LED_PORT ^ (1<<LED3); //switch
#define SwitchLed4 LED_PORT = LED_PORT ^ (1<<LED4); //switch

#endif

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>
#include <util/twi.h>
#include "i2c_Slave.h"

//gobal VAR
unsigned char OutPort; //for output port D (use only 6 end bit, 0 and 1 bit - UART now reserved for future options)
unsigned char Strobe_on = 0; //for strobe
unsigned char Strobe_count = 0;//for strobe
unsigned char adc6;
unsigned char AdcKey = 0;
unsigned char turnOn = 0; 
unsigned char T1temp = 0;


/*

#ifdef i2c_Comm
#define i2c_MasterAddress 	0xA2	// Адрес на который будем отзываться
#define i2c_i_am_slave		1	// Если мы еще и слейвом работаем то 1. А то не услышит!
#define twi_port PORTC
#define twi_ddr DDRC
#define SDA_pin 4
#define SCL_pin 5
#define i2cBuffSize 2
//#define i2c_MaxPageAddrLgth	2	// Максимальная величина адреса страницы. Обычно адрес страницы это один или два байта.
								// Зависит от типа ЕЕПРОМ или другой микросхемы.
#define TWI_SUCCESS 0xff
#define TWI_ADR_BITS     1       // позиция адреса в адресном пакете
#define TRUE             1
#define FALSE            0

//char i2c_SlaveAddress = 0xD0;// 0xD0 = ds1307; 0x90 = lm75
char i2c_Buffer[i2cBuffSize];//TX buffer
//char i2c_BufferR[i2cBuffSize];//RXbuffer
char i2c_index = 0;
char i2c_ByteCount;				// Число байт передаваемых
//char i2c_PageAddress[i2c_MaxPageAddrLgth];	// Буфер адреса страниц (для режима с sawsarp)
//char i2c_PageAddrIndex;				// Индекс буфера адреса страниц
//char i2c_PageAddrCount;				// Число байт в адресе страницы для текущего Slave
char ptr = 0; //индексная переменная для массива

//буфер для сообщения
volatile static uint8_t twiBuf[i2cBuffSize];

//сколько байт нужно передать
volatile static uint8_t twiMsgSize;

//статус модуля
volatile static uint8_t twiState = TW_NO_INFO;

#endif
*/
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
if (adcstate = 1){
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<ADIE|0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	//1<<REFS0|1<<REFS1 = от внутренних 2.5в,
	//0<<REFS0|0<<REFS1 = AREF
	//adlar = 1 младший байт (ADCL) не нужен - там мусор, брать только ADCH
	//mux0-mux3 выбирать какой ацп
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

ISR(TIMER1_OVF_vect)
{
	#ifdef TurnBlinkTime03s 
	// Reinitialize Timer1 value /0,3c
	TCNT1H=0x6D84 >> 8;
	TCNT1L=0x6D84 & 0xff;
	#endif
	#ifdef TurnBlinkTime025s 
	// Reinitialize Timer1 value /0,249c
	TCNT1H=0xB403 >> 8;
	TCNT1L=0xB403 & 0xff;
	#endif

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

int main(void)
{
	
unsigned char butt,butt1,swadc6;
//настройка 8бит таймера 
// Clock value: 31,250 kHz
TCCR0=(1<<CS02) | (0<<CS01) | (0<<CS00);// 1 переполнение = 0.08192 сек (8,192 мс)
//TCCR0|=(1<<CS00)|(1<<CS01); // Тактировать с коэффициентом 64. 1 переполнение = 0.016384 сек #####1mhz
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
//TIMSK|=(1<<TOIE0)|(1<<OCIE1A); #####1mhz
//настройка 16 бит таймера 
// Clock value: 125,000 kHz
//ovf time = 0,52429c
TCCR1A|=(0<<COM1A0)|(0<<COM1A1)|(0<<COM1B0)|(0<<COM1B1)|(0<<FOC1A)|(0<<FOC1B)|(0<<WGM11)|(0<<WGM10);
TCCR1B|=(0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(1<<CS11)|(1<<CS10);//prescalar = 64
//TCCR1B|=(0<<ICNC1)|(0<<ICES1)|(0<<WGM13)|(0<<WGM12)|(0<<CS12)|(1<<CS11)|(0<<CS10);//prescalar = 8 #####1mhz

#ifdef TurnBlinkTime03s 
TCNT1H=0x6D;//0.3c
TCNT1L=0x84;//0,3c
#endif
#ifdef TurnBlinkTime025s 
TCNT1H=0xB4;//0,249c
TCNT1L=0x03;//0,249c
#endif

Init_Slave_i2c();

//OCR1A = 0x7A11; #####1mhz


	//настройка портов для кнопок
	DDRC = 0b00110000;  //kb port
	PORTC = 0b00001111; //kb port

	//настройка портов 
	DDRD = 0b11111100;  //kb port
	PORTD = 0b00000000; //kb port
	//PINx регистр чтения
	//PORTx 1=pullup(in)
	//DDRx 0=in 1=out
	LED_DDR|= (1<<LED1)|(1<<LED2)|(1<<LED3)|(1<<LED4);     //Led port
	LED_PORT&= ~(1<<LED1)|(1<<LED2)|(1<<LED3)|(1<<LED4); //Led port
	//конец настройки портов

#ifdef HeadLightControl
	//adc setup
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	//1<<REFS0|1<<REFS1 = от внутренних 2.5в,
	//0<<REFS0|0<<REFS1 = AREF
	//adlar = 1 младший байт (ADCL) не нужен - там мусор, брать только ADCH
	//mux0-mux3 выбирать какой ацп 0-0<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 1-1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3
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

	/*подготавливаем сообщение*/
	i2c_Buffer[0] = (i2c_SlaveAddress &= 0xFE);
	i2c_Buffer[1] = 0x00;
	i2c_Buffer[2] = 0b10000101;
	i2c_Buffer[3] = 0b01000100;
	i2c_Buffer[4] = 0b00100010;

	/*отправляем его*/
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
sei();//разрешаем прерывания глобально	
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