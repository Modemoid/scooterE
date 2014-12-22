/*
 * Light_control.c
 *
 * Created: 15.12.2014 15:32:42
 *  Author: kartsev
 */ 

#define F_CPU 1000000UL
//#define DEBUG
#define TurnControl
#define HeadLightControl
//#define i2c_Comm
#define Strobe
//#define Strobe_Bink
#define PanelLight

#define Strobe_TIME 100 //*0.15s = strobe output HI time after single button press
#define debounce_delay

#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>

//gobal VAR
char OutPort; //for output port D (use only 6 end bit, 0 and 1 bit - UART now reserved for future options)
char Strobe_on = 0; //for strobe
char Strobe_count =0;//for strobe
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



int main(void)
{
	sei();//разрешаем прерывания глобально
char butt,butt1;
//настройка 8бит таймера 
TCCR0|=(1<<CS00)|(1<<CS01); // Тактировать с коэффициентом 64. 1 переполнение = 0.016384 сек
TIMSK|=(1<<TOIE0);



	//настройка портов для кнопок
	DDRC = 0b00110000;  //kb port
	PORTC = 0b00001111; //kb port

	//настройка портов для кнопок
	DDRD = 0b11100000;  //kb port
	PORTD = 0b00000000; //kb port
	//PINx регистр чтения
	//PORTx 1=pullup(in)
	//DDRx 0=in 1=out
	//конец настройки портов

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
#ifdef Strobe
	butt1 = 	PINC&0b00001000;
	if (!butt1) 
	{
		Strobe_on = 1;
		}

#endif
#ifdef HeadLightControl

#endif
#ifdef i2c_Comm


#endif
		
#ifdef debounce_delay
_delay_ms(100);
#endif		
	PORTD = OutPort;		
		
        //TODO:: Please write your application code 
    }
}