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
//#define adc7Use
//#define i2c_Comm
#define Strobe
//#define Strobe_Bink
#define PanelLight
#define PanelLight_PWM 128

#define Strobe_TIME 100 //*0.15s = strobe output HI time after single button press
#define debounce_delay
#define debounce_time 50 //time in MS

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>

//gobal VAR
char OutPort; //for output port D (use only 6 end bit, 0 and 1 bit - UART now reserved for future options)
char Strobe_on = 0; //for strobe
char Strobe_count =0;//for strobe
char adc7,adcstate; //For ADC ch6 vector
int adc6;
//End of globa var
ISR(TIMER0_OVF_vect)
{
 #ifndef Strobe_Bink
	 if (Strobe_on)
	 {
 	 OutPort |= 0b00100000;
	  Strobe_on++;
     }else {
	 OutPort &= 0b11011111;
	}
	if (Strobe_on > Strobe_TIME)
	{
	Strobe_on = 0; 		
	}
#endif

  #ifdef Strobe_Bink //разобраться - не работает
  {
	if (Strobe_on)
	{
		if (Strobe_count%5)
		{ 
			OutPort |= 0b00100000;
		}else {
			OutPort &= 0b11011111;	
		}
	Strobe_count++;
	Strobe_on++;
	if (Strobe_on >30)
	{
		Strobe_on =0;
		OutPort &= 0b11011111;
	}
	}	  
  }
  #endif
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
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<ADIE|1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	adcstate = 1;
		
}else{
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<ADIE|1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
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
	}
#endif	
	
	
	
}



int main(void)
{
	
char butt,butt1,swadc6;
//настройка 8бит таймера 
TCCR0|=(1<<CS00)|(1<<CS01); // Тактировать с коэффициентом 64. 1 переполнение = 0.016384 сек
TIMSK|=(1<<TOIE0);

#ifdef DEBUG

	DDRB = 0b11111111;  //kb port
	PORTB = 0b00000000; //kb port
	//PORTB = 0b11111111;
#endif

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
	ADCSRA = (1<<ADEN|1<<ADSC|1<<ADFR|1<<ADIE|1<<ADPS0|1<<ADPS1|1<<ADPS2);
	adcstate = 0;

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
PORTB = 0b00000001; //kb port
	}
	
else if (100>adc6 && adc6>60)
	{
PORTB = 0b00000010; //kb port
	}
else if (150>adc6 && adc6>100)
	{
PORTB = 0b00000100; //kb port
	}	
else if (150<adc6)
{
	PORTB = 0b00001000; //kb port
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