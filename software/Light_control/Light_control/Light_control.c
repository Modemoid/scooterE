/*
 * Light_control.c
 *
 * Created: 15.12.2014 15:32:42
 *  Author: kartsev
 */ 

#define F_CPU 1000000UL
#define DEBUG
#define TurnControl
#define HeadLightControl
//#define adc7Use //разобраться с переключением каналов в прерывании - на будущее
//#define i2c_Comm
#define Strobe // if stroboscope present 
#define Strobe_Bink // strobe blink 4 2 times 
#define PanelLight //
#define PanelLight_PWM 128

#define Strobe_TIME 40 //*0.15s = strobe work time after single button press, see Strob_blink define 
#define debounce_delay
#define debounce_time 50 //time in MS

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>

//gobal VAR
unsigned char OutPort; //for output port D (use only 6 end bit, 0 and 1 bit - UART now reserved for future options)
unsigned char Strobe_on = 0; //for strobe
unsigned char Strobe_count =0;//for strobe
unsigned char adc6,AdcKey=0;

#ifdef adc7Use
char adc7,adcstate=0; //For ADC ch6 vector
#endif

//End of globa var
ISR(TIMER0_OVF_vect)
{
 #ifndef Strobe_Bink
	 if (Strobe_on)
	 {
	  Strobe_on++;
	  OutPort |= 0b00100000;
	  }else 
	  {
		  OutPort &= 0b11011111;
	  }

#endif

  #ifdef Strobe_Bink //разобраться - не работает //here
 	 if (Strobe_on)
	  {
		  Strobe_on++;
		  
		 if (Strobe_on < Strobe_TIME && Strobe_on > (Strobe_TIME/4+Strobe_TIME/2)) //128 - 96

			{
				 	 
					  OutPort &= 0b11011111;
			}
		 if (Strobe_on < (Strobe_TIME/4+Strobe_TIME/2) && Strobe_on > (Strobe_TIME/2)) //96-64
		 {
			 	 	 OutPort |= 0b00100000;
		 }
		 if (Strobe_on < (Strobe_TIME/2) && Strobe_on > (Strobe_TIME/4) ) //64-32
		 {
			 OutPort &= 0b11011111;
		 }		
		 if (Strobe_on < Strobe_TIME/4) //32-0
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
ISR(ADC_vect)
{
#ifndef adc7Use	
	adc6 = ADCL;
	adc6 = ADCH;
#endif
	
#ifdef adc7Use
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



int main(void)
{
	
unsigned char butt,butt1,swadc6;
//настройка 8бит таймера 
TCCR0|=(1<<CS00)|(1<<CS01); // Тактировать с коэффициентом 64. 1 переполнение = 0.016384 сек
TIMSK|=(1<<TOIE0);

	//настройка портов для кнопок
	DDRC = 0b00110000;  //kb port
	PORTC = 0b00001111; //kb port

	//настройка портов 
	DDRD = 0b11100000;  //kb port
	PORTD = 0b00000000; //kb port
	//PINx регистр чтения
	//PORTx 1=pullup(in)
	//DDRx 0=in 1=out
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


sei();//разрешаем прерывания глобально
    while(1)
    {	
#ifdef TurnControl
		butt = 	PINC&0b00000111;	
		switch (butt)
			{
				case 0b00000110: OutPort |= 0b10000000;break;
				case 0b00000101: OutPort &= 0b00111111;break;
				case 0b00000011: OutPort |= 0b01000000;break;					
				default: ;
			}
#endif
#ifdef Strobe //set strob_on if button pressed
	butt1 = 	PINC&0b00001000;
	if (!butt1) 
	{
		Strobe_on = 1;
	}

#endif
#ifdef PanelLight

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

#ifdef i2c_Comm


#endif
		
#ifdef debounce_delay
_delay_ms(debounce_time);
#endif	

	
	PORTD = OutPort;		
		
        //TODO:: Please write your application code 
    }
}