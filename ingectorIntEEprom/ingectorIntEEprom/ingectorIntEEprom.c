/*
 * ingectorIntEEprom.c
 *
 * Created: 26.01.2016 21:12:49
 *  Author: kartsev
 */

#define F_CPU 8000000 //8 ���

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <util/delay.h>

#define MinOperationRPM 20000 // RPM = 2400000/this define (20000 = 125RPM 15000 = 160RPM  10000 = 240RPM)


#define LED1 5 //pb5 -arduino d13 we use as "software bug"
#define LED2 5 //TODO: ��������� �� ���������� ����, ���� pb5 -arduino d13 we use as "�� ������� ������� ������ �������"
#define LED_PORT PORTB
#define LED_DDR DDRB

#define SetLed1 LED_PORT|= 1<<LED1; //set
#define ClearLed1 LED_PORT&= ~(1<<LED1);//clear
#define SwitchLed1 LED_PORT = LED_PORT ^ (1<<LED1); //switch



#define Timer2IntON TIMSK|= (1<<OCIE2|1<<TOIE2);//set bits
#define Timer2IntOFF TIMSK&= ~(1<<OCIE2|1<<TOIE2);//clear bits


#define def_ArrSize 120
uint8_t TimeArray[def_ArrSize]; //last position - current flow
uint8_t CorrectionArray[def_ArrSize] = {101,}; //
unsigned int CurrentTimer, OldTimer;
unsigned int currentRPM;

unsigned char DrocelPosition;
unsigned char Coffs[6]; //0 - open time (use as "+ingector open time -ingector close time", 
						//1 - NU, 
						//2 - min drocel position, 
						//3 - max drocel position, 
						//4-drebezg flag




void eeprom_to_mem(void)
{
  uint16_t LocalCounter = 0;
  for (LocalCounter = 0; LocalCounter < def_ArrSize; LocalCounter++)
  {
    //eeprom_write_byte ((uint8_t*) LocalCounter, LocalCounter);
    TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
  }
  TimeArray[def_ArrSize] = 0;
}
void mem_to_eeprom(void)
{
  uint16_t LocalCounter = 0;
  for (LocalCounter = 0; LocalCounter < def_ArrSize; LocalCounter++)
  {
    eeprom_write_byte ((uint8_t*)LocalCounter, TimeArray[LocalCounter]);
    //TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
  }
}
void Timer2Setup(void)
{
  //�������� ������2 �� �����1, �� ���������� � 200 ����� ������ ������� ����� ����� 10^-5 = 25 �����������


  // LED_PORT|= 1<<LED4; //set
  // LED_PORT&= ~(1<<LED1);//clear
  // LED_PORT = LED_PORT ^ (1<<LED1); //switch

  OCR2 = 199; //����� 200 �����, ���� � 0

  TCCR2 |= (0 << FOC2 | 0 << WGM20 | 0 << COM21 | 0 << COM20 | 1 << WGM21 | 0 << CS22 | 0 << CS21 | 1 << CS20);
  /*
  //FOC2 = 0
  //WGM20 = 0 + WGM21 =1 |CTC mode
  //COM21 = 0  \
  //COM20  = 0 | port disconnected
  //WGM21 = 1
  //CS22 =0
  //CS21 =0
  //CS20=1 //CPU clock
  */
  //������ �������� �� ���� ����������
  Timer2IntON

}
void ADCSetup(void)
{
  // LED_PORT|= 1<<LED4; //set
  // LED_PORT&= ~(1<<LED1);//clear
  // LED_PORT = LED_PORT ^ (1<<LED1); //switch


  ADMUX |= (0 << REFS1 | 0 << REFS0 | 1 << ADLAR | 0 << MUX3 | 0 << MUX2 | 0 << MUX1 | 0 << MUX0); //ADC0 chanel (see MUX)
  /*
  REFS1 \
  REFS0  | external power
  ADLAR  1 - we can read only ADCH and use 8 bit
  �
  MUX3
  MUX2
  MUX1
  MUX0
  */

  ADCSRA |= (1 << ADEN | 1 << ADFR | 1 << ADIE | 1 << ADPS2 | 1 << ADPS1 | 0 << ADPS0);

  /*
  ADEN ADC Enable
  ADSC ADC Start Conversion
  ADFR Free Running Select
  ADIF ADC Interrupt Flag
  ADIE ADC Interrupt Enable
  ADPS2 1\
  ADPS1 1 | 125 kHz@8Mhz
  ADPS0 0/
  */
  //������ �������� �� ���� ����������

}
void IntExtSetup(void)
{
  //���������� ��� ���� ISCxx
  //MCUCR &= ~( (1<<ISC11)|(1<<ISC10)|(1<<ISC01)|(1<<ISC00) )
  //����������� �� ������������ INT0 �� ��������� ������
  MCUCR |= (1 << ISC01) | (1 << ISC00); // �� �������������� ������
  GICR |= (1 << INT0);
}
void PortSetup(void)
{
		//��������� ������ ��� ������
		DDRC = 0b00110000;  //kb port
		PORTC = 0b00001111; //kb port

		//��������� ������
		DDRD = 0b11111100;  //kb port
		PORTD = 0b00000000; //kb port
		//PINx ������� ������
		//PORTx 1=pullup(in)
		//DDRx 0=in 1=out
		#ifdef DEBUG_LEDS
		LED_DDR|= (1<<LED1)|(1<<LED2)|(1<<LED3)|(1<<LED4);     //Led port
		LED_PORT&= ~(1<<LED1)|(1<<LED2)|(1<<LED3)|(1<<LED4); //Led port
		//����� ��������� ������
		#endif
}
void LoadFuelTime(void)
{
  //    Coffs[6]; //0 - open time (use as "+ingector open time -ingector close time", 1 - NU, 2 - min drocel position, 3 - max drocel position, 4-drebezg flag
  TimeArray[def_ArrSize] = Coffs[0]+TimeArray[DrocelPosition] + CorrectionArray[DrocelPosition]; //TODO: ��������� �������� �� �������� "���������� ������ ������" � ����������� �� ���� ��� � ��� � ���(�� ������ �������� ������-�����) + ������������ (��������-��������)

}
void Low_FuelFlow_Exeption (void)
{
  //todo set LowFuelFlowExeption
}
void SoftBugON(void) {
  SetLed1//set bits
}
  ISR( INT0_vect )
{

  //��������
  OldTimer = CurrentTimer;
  CurrentTimer = 0;
  //����� ��������

  if (Coffs[4] == 0) {//drebezg protection
    Coffs[4] = 1;//set drebezg protection flag

    if (TimeArray[def_ArrSize] == 0) //TODO: ��������� ������ �� � ��� ���������� �����.
    {
      LoadFuelTime();
    } else
    {
      Low_FuelFlow_Exeption();
      LoadFuelTime();
    }
	}//end drebezg protection


    /*
    //���� ����� ���� �������� ������� ��������� "��������� ������", �������� "���� ��������"
	//��������� ����� ������� ������ ��������
    //��������� ������ 1 �� "�����" (������� � �������)
    */
  }
  ISR( TIMER2_OVF_vect )
  {
    SoftBugON();
    //������ TODO: ���������� �������� ���� � ������� �� ������!
  }
  ISR(TIMER2_COMP_vect)
  {
    if (Coffs[4] == 1)
    {
      Coffs[4] = 0;
    }

    if (CurrentTimer < MinOperationRPM) //TODO: ��������� ���������� ���������
    {
      CurrentTimer++;
    } else
    {
      //todo: exeption ������ ������� ������ ���������
    }

    //TODO: ��������� �������� "���������� ������ ������"
    //��� �� ������ ������� "����� �������"
    //������������ ����� � �������� �����. ?
  }
  ISR(ADC_vect)
  {
    if (ADCH < def_ArrSize) {
      DrocelPosition = ADCH;
    } else
    {
      //TODO:Exeption - too big drocel travel
    }
  }


  int main(void)
  {

    unsigned char LocalCounter = 0;
    for (LocalCounter = 0; LocalCounter < def_ArrSize; LocalCounter++)
    {
      CorrectionArray[LocalCounter] = 1; // clear correction array
    }


    eeprom_to_mem();//load data arrays into memory
    Timer2Setup(); //setup timer2 //������� ������� �� 25 �����������
    ADCSetup();
    IntExtSetup();
PortSetup();
    while (1)
    {

      //TODO �������� �� � ������� �������� = (1000/��)*60
      //currentRPM= 60000/CurrentTimer ������������� ������ ���� � ��
      currentRPM = 2400000 / OldTimer;

      //TODO: ������� ��������� � ����������� �� ���� ��� � ��� � "���������� �������� ������"
      //TODO:: Please write your application code
    }
  }

