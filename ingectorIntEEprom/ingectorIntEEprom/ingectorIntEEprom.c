/*
 * ingectorIntEEprom.c
 *
 * Created: 26.01.2016 21:12:49
 *  Author: kartsev
 *
 */
    
#define F_CPU 8000000 //8 мгц

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <util/delay.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define MinOperationRPM 20000 // RPM = 2400000/this define (20000 = 125RPM 15000 = 160RPM  10000 = 240RPM)

#ifndef NOLEDS
#define LED4 4 //TODO: впрыск идет pb4
#define LED1 5 //pb5 -arduino d13 we use as "software bug" 
#define LED2 6 //TODO "не хватает времени потока топлива" pb6 
#define LED3 7 //TODO: "двигатель работает. ¬прыск разрешен" pb7
#define LED_PORT PORTB
#define LED_DDR DDRB

#define SetLed1 LED_PORT|= 1<<LED1; //set
#define ClearLed1 LED_PORT&= ~(1<<LED1);//clear
#define SwitchLed1 LED_PORT = LED_PORT ^ (1<<LED1); //switch

#define SetLed2 LED_PORT|= 1<<LED2; //set
#define ClearLed2 LED_PORT&= ~(1<<LED2);//clear
#define SwitchLed2 LED_PORT = LED_PORT ^ (1<<LED2); //switch

#define SetLed3 LED_PORT|= 1<<LED3; //set
#define ClearLed3 LED_PORT&= ~(1<<LED3);//clear
#define SwitchLed3 LED_PORT = LED_PORT ^ (1<<LED3); //switch

#define SetLed4 LED_PORT|= 1<<LED4; //set
#define ClearLed4 LED_PORT&= ~(1<<LED4);//clear
#define SwitchLed4 LED_PORT = LED_PORT ^ (1<<LED4); //switch

#endif

#ifndef NOOUTPUT
#define Out1 1 //TODO: ch1
#define Out2 2 //TODO: ch1
#define Out3 3 //TODO: ch1
#define Out_PORT PORTB
#define Out_DDR DDRB

#define SetOut1 Out_PORT|= 1<<Out1; //set
#define ClearOut1 Out_PORT&= ~(1<<Out1);//clear
#define SwitchOut1 Out_PORT = Out_PORT ^ (1<<Out1); //switch

#define SetTX PORTD|= 1<<1; //set
#define ClearTX PORTD&= ~(1<<1);//clear
#define SwitchTX PORTD = PORTD ^ (1<<1); //switch

#define SetRX PORTD|= 1<<0; //set
#define ClearRX PORTD&= ~(1<<0);//clear
#define SwitchRX PORTD = PORTD ^ (1<<0); //switch

#endif

#ifdef Atmega8
#define Timer2IntON TIMSK|= (1<<OCIE2);//|1<<TOIE2);//set bits
#define Timer2IntOFF TIMSK&= ~(1<<OCIE2);//|1<<TOIE2);//clear bits
#else
#define Timer2IntON TIMSK2|= (1<<OCIE2A);//|1<<TOIE2);//set bits
#define Timer2IntOFF TIMS2K&= ~(1<<OCIE2A);//|1<<TOIE2);//clear bits
#endif

#define def_ArrSize 120
uint8_t TimeArray[def_ArrSize]; //last position - current flow
int8_t CorrectionArray[def_ArrSize] = {0,}; //
unsigned int CurrentTimer, OldTimer;
unsigned long currentRPM;
unsigned int RemainingFlowTime = 0;
char tempcount=0;

unsigned char DrocelPosition;
//Coffs define need only for start load for verbose look
#define MinDrocel 0
#define MaxDrocel 119
#define IngectorActionTime 1
#define StartDose 20 // time in 25us will added for fuelshot, when engine run on low RPM
//
unsigned char Coffs[8] = {0, StartDose, MinDrocel, MaxDrocel, 0, 0, IngectorActionTime};
/*
//0 - have BUG. anything though it
//Coffs[1] - StartDose TODO: написать процедуру старта. 
//Coffs[2] - min drocel position (fact by ADC),
//Coffs[3] - max drocel position (fact by ADC),
//4 - drebezg flag
//5 - ctc counter - now not need
//6 - Ingector action time (use as "+ingector open time -ingector close time" (must be tested by fact)
*/
unsigned char RawADC2 = 0, RawADC1 = 0, RawADC0 = 0, AdcCH = 0, ADCCorrection = 0, Adc1 = 0;
//RawADCH - channel 0, RawADC1 - channel 2, RawADC0 - channel 1

#define UART_TX
#ifdef UART_TX
//char Bufer[16]={0x49,0x52,0x49,0x52,' ','s','t','a','r','t',0x0A,' ',' ',' ',' ',' '};;
	char Bufer[32]={0x49,0x6E,0x69,0x74,' ','s','t','a','r','t',0x0D,'A','B',' ',' ',' '};//0x0D-перевод строки
	unsigned char Uart_Bufer_index=11, Uart_pointer = 0;
#define BAUD 9600
#define MYUBRR F_CPU/16/BAUD-1

void USART0_Init(unsigned int ubrr)
{
	/*Set baud rate */
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;

	/* Set frame format: 8-1-n */
   UCSR0C |= (1<<UCSZ01)|(1<<UCSZ00);
   //Enable transmitter only
   //UCSR0B |= (1<<TXEN0)|(1<<TXCIE0)|(1<<UDRIE0);
   UCSR0B |= (1<<TXEN0);

//Enable receiver and transmitter
//	UCSR0B = (1<<RXEN0)|(1<<TXEN0);

	}

/*
void USART0_Transmit( unsigned char data )
{
	// Wait for empty transmit buffer 
	while ( !( UCSR0A & (1<<UDRE0)) )
	;
	// Put data into buffer, sends the data 
	UDR0 = data;
}
*/

/*
//макросы вычисления скорости
#define BAUD 9600
#define UBRR_VAL F_CPU/16/BAUD-1
unsigned int timer=824;
void usart_init (unsigned int speed)
{
// устанавливаем скорость Baud Rate: 9600
UBRRH=(unsigned char)(speed»8);
UBRRL=(unsigned char) speed;
UCSRA=0x00;
// Разрешение работы передатчика
UCSRB|=(1«TXEN);

//UCSRB|=(1«RXEN);// Разрешение работы приемника
UCSRB|=(1«RXCIE);// Разрешение прерыва
*/
#endif



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

    eeprom_write_byte ((uint8_t*)LocalCounter, LocalCounter * 2 + 10 );

    //eeprom_write_byte ((uint8_t*)LocalCounter, TimeArray[LocalCounter]);
    //TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
  }
}
void Timer2Setup(void)
{
  //запустит таймер2 на клоке1, по совпадению с 200 тогда период таймера будет равен 10^-5 = 25 микросекунд


  // LED_PORT|= 1<<LED4; //set
  // LED_PORT&= ~(1<<LED1);//clear
  // LED_PORT = LED_PORT ^ (1<<LED1); //switch

#ifdef Atmega8
  OCR2 = 199; //нужно 200 тиков, счет с 0
#else
  OCR2A = 199;
#endif
  //TCCR2 |= (0 << FOC2 | 0 << WGM20 | 0 << COM21 | 0 << COM20 | 1 << WGM21 | 0 << CS22 | 0 << CS21 | 1 << CS20);
#ifdef Atmega8
  TCCR2 = 0;
  TCCR2 |= ( 0 << WGM20 | 0 << COM21 | 0 << COM20 | 1 << WGM21 | 0 << CS22 | 0 << CS21 | 1 << CS20);
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
  //теперь разрешим от него прерывания
#else

  TCCR2A = 0;
  TCCR2A |= (1 << COM2A1 | 0 << COM2A1 | 1 << WGM21 | 0 << WGM20 );
  TCCR2B = 0;
  TCCR2B |= ( 0 << CS22 | 0 << CS21 | 1 << CS20);
#endif
  Timer2IntON

}
void ADCSetup(void)
{
  // LED_PORT|= 1<<LED4; //set
  // LED_PORT&= ~(1<<LED1);//clear
  // LED_PORT = LED_PORT ^ (1<<LED1); //switch


  ADMUX |= (0 << REFS1 | 1 << REFS0 | 1 << ADLAR | 0 << MUX3 | 0 << MUX2 | 0 << MUX1 | 0 << MUX0); //ADC0 chanel (see MUX)
  /*
  REFS1 \
  REFS0  | external power
  ADLAR  1 - we can read only ADCH and use 8 bit
  Ц
  MUX3
  MUX2 TODO: правильно выбрать канал дроселя
  MUX1
  MUX0
  */

#ifdef Atmega8
  ADCSRA |= (1 << ADEN | 1 << ADSC | 1 << ADFR | 1 << ADIE | 1 << ADPS2 | 1 << ADPS1 | 0 << ADPS0);
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
#else
  ADCSRA |= (1 << ADEN | 1 << ADSC | 1 << ADATE | 1 << ADIE | 1 << ADPS2 | 1 << ADPS1 | 0 << ADPS0);
  //ADEN ADSC ADATE ADIF ADIE ADPS2 ADPS1 ADPS0
  ADCSRB |= (0 << ACME | 0 << ADTS2 | 1 << ADTS1 | 0 << ADTS0);
  // ACME Ц Ц Ц ADTS2 ADTS1 ADTS0
#endif


}
void IntExtSetup(void)
{
  //сбрасываем все биты ISCxx
  //MCUCR &= ~( (1<<ISC11)|(1<<ISC10)|(1<<ISC01)|(1<<ISC00) )
  //настраиваем на срабатывание INT0 по переднему фронту
#ifdef Atmega8
  MCUCR |= (1 << ISC01) | (1 << ISC00); // по поднимающемуся фронту
  GICR |= (1 << INT0);
#else

  EICRA |= (1 << ISC11 | 1 << ISC10 | 1 << ISC01 | 1 << ISC00);
  EIMSK |= (1 << INT0 | 1 << INT1);
#endif
  //GICR |= (1 << INT0);

}
void PortSetup(void)
{
  //настройка портов для кнопок
  DDRC = 0b00000000;  //kb port
  PORTC = 0b00000000; //kb port

  //настройка портов
  //DDRB = 0b11100110;  //kb port
  //PORTB = 0b00000000; //kb port

  DDRD = 0b00000011; //rx tx as led
  PORTD = 0b00000000;
  //PINx регистр чтения
  //PORTx 1=pullup(in)
  //DDRx 0=in 1=out

  Out_DDR |= (1 << Out1 | 1 << Out2 | 1 << Out3);

  //#ifdef DEBUG_LEDS
  LED_DDR |= (1 << LED1) | (1 << LED2) | (1 << LED3) | (1 << LED4); //Led port
  LED_PORT &= ~(1 << LED1) | (1 << LED2) | (1 << LED3) | (1 << LED4); //Led port
  //конец настройки портов
  //#endif
}
void LoadFuelTime(void)
{
  //    Coffs[6]; //0 - open time (use as "+ingector open time -ingector close time", 1 - NU, 2 - min drocel position, 3 - max drocel position, 4-drebezg flag
  RemainingFlowTime = Coffs[6] + TimeArray[DrocelPosition] + CorrectionArray[DrocelPosition] + ADCCorrection; //TODO: загрузить значение из таблички "оставшиеся времея потока" в зависимости от того что у нас с ј?ѕ(не забыть поправки начала-конца) + коэффициенты (открытие-закрытие)

}
void Low_FuelFlow_Exeption (void)
{
  #ifndef UART_TX
  SetTX
#endif
  //todo set LowFuelFlowExeption
}
void SoftBugON(void) {
  asm ("nop");
  //SetLed1//set bits
}
char charmap(char x, char in_min, char in_max, char out_min, char out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
ISR( INT1_vect)
{
}
ISR( INT0_vect )
{
  //SwitchTX
  //тахометр
  OldTimer = CurrentTimer;
  CurrentTimer = 0;
  //конец тахометр

  if (Coffs[4] == 0) {//drebezg protection
    Coffs[4] = 1;//set drebezg protection flag

    if (RemainingFlowTime == 0) //TODO: проверить пустое ли у нас оставшееся время.
    {
      LoadFuelTime();
      #ifndef UART_TX
	  ClearTX
	  #endif
    } else
    {
      Low_FuelFlow_Exeption();
      LoadFuelTime();
    }
  }//end drebezg protection


  /*
  //если стоит мало оборотов дернуть процедуру "стартовая порция", сбросить "мало оборотов"
  //посчитать через сколько начать брызгать
  //запустить таймер 1 на "брызг" (комперј и комперЅ)
  */
}
ISR( TIMER2_OVF_vect )
{
  asm ("nop"); //прерывание вызывается вслед за timer_comp - в этом режиме работы таймера бессмысленно
}

#ifdef UART_TX
ISR(USART_TX_vect)
{
	
}
ISR(USART_UDRE_vect)
{
	if (Uart_Bufer_index < Uart_pointer)
		{
		//Запретить перерывание
			Uart_Bufer_index = 0;
			Uart_pointer = 0;
		   UCSR0B &= ~(1<<UDRIE0);
		}
	else 
		{
		UDR0 = Bufer[Uart_pointer];
		Uart_pointer++;
		}
}
	

#endif
#ifdef Atmega8
ISR( TIMER2_COMP_vect )
#else
ISR( TIMER2_COMPA_vect)
#endif
{
  //SwitchRX
  //SwitchOut1
  //Coffs[5]++;
  if (Coffs[4] == 1)
  {
    Coffs[4] = 0;
  }

  if (CurrentTimer < MinOperationRPM) //TODO: инкремент переменной тахометра
  {
    CurrentTimer++;
  } else
  {
    //todo: exeption низкие обороты работы двигателя
  }
  if (RemainingFlowTime)
  {
    RemainingFlowTime--; //уменьшаем оставшееся время потока
  }
}
//#define USRTTEST
#ifndef USRTTEST
ISR(ADC_vect)
{

  switch (AdcCH)
  {
    case 0:
      {
        RawADC0 =  ADCH;
        ADMUX |= 1 << MUX1; //set (mux0 =0 mun1=1)
        AdcCH = 1;

        DrocelPosition = charmap(RawADC0, 1, 255, Coffs[2], Coffs[3]);
        break;
      }
    case 1:
      {
        RawADC2 =  ADCH;
        ADMUX |= 1 << MUX0; //set
        ADMUX &= ~(1 << MUX1); //clear (mux0=1 mun1=0)
        AdcCH = 2;
        break;
      }
    case 2:
      {
        RawADC1 =  ADCH;
        ADMUX &= ~(1 << MUX0); //clear(mux0=0 mun1=0)
        AdcCH = 0;
        break;
      }
    default: ;
  }

}

#endif
int main(void)
{
  if (eeprom_read_byte((uint8_t*)10) != 30);
  {
    mem_to_eeprom();
  }
  unsigned char LocalCounter = 0;
  for (LocalCounter = 0; LocalCounter < def_ArrSize; LocalCounter++)
  {
    CorrectionArray[LocalCounter] = 0; // clear correction array
  }

  eeprom_to_mem();//load data arrays into memory
  Timer2Setup(); //setup timer2 //считает отрезки по 25 микросекунд
  #ifndef USRTTEST
  ADCSetup();
  #endif
  IntExtSetup();
  PortSetup();
  USART0_Init(MYUBRR);
  sei();
  while (1)
  {

    //TODO пересчет мс в обороты оборотов = (1000/мс)*60
    //currentRPM= 60000/CurrentTimer керрентТаймер должен быть в мс
    if (RemainingFlowTime)
    {
      SetOut1
      SetLed4
      SetRX
    }
    else {
      ClearRX
      ClearOut1
      ClearLed4
    }
    /*SetTX

    for (LocalCounter = 0; LocalCounter < DrocelPosition; LocalCounter++)
    {
      _delay_ms(1);
    }

    ClearTX
    */
    currentRPM = (2400000 / OldTimer) / 8;
    ADCCorrection = charmap(RawADC2, 0, 255, 0, 30); //AdcCh2
    Adc1 = charmap(RawADC1, 0, 255, 0, 255); //AdcCh0
	
	if (Uart_Bufer_index == 0)
	{
		 tempcount++;
		Uart_Bufer_index = sprintf(Bufer, "0=%u 1=%u 2=%u RPM=%lu \n\r", RawADC0,RawADC1,RawADC2,currentRPM);
		//printf(RawADC1, Bufer, 10);
		Uart_pointer = 0;
		//Uart_Bufer_index = 3;
		
    }
	
if (Uart_Bufer_index != 0)
{	
	if (Uart_pointer == 0)
	{
	UDR0 = Bufer[Uart_pointer];
	Uart_pointer++;
	}
	UCSR0B |= (1<<UDRIE0);
}

    //TODO: дрыгать форсункой в зависимости от того что у нас с "оставшимся временем потока"
    //TODO:: Please write your application code

  }
}

