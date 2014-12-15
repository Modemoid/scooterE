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


#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>



int main(void)
{
char butt,butt1, OutPort;

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
	OutPort |= 0b00100000;
	}else {
		OutPort &= 0b11011111;
	}

#endif
#ifdef HeadLightControl

#endif
#ifdef i2c_Comm


#endif
		
	PORTD = OutPort;		
		
        //TODO:: Please write your application code 
    }
}