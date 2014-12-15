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
#define i2c_Comm


#include <avr/io.h>
#include <avr/delay.h>
#include <avr/interrupt.h>



int main(void)
{
char butt, bt1;

	//настройка портов для кнопок
	DDRC = 0b00110000;  //kb port
	PORTC = 0b00001111; //kb port

	//настройка портов для кнопок
	DDRD = 0b11000000;  //kb port
	PORTD = 0b00000000; //kb port
	//PINx регистр чтения
	//PORTx 1=pullup(in)
	//DDRx 0=in 1=out
	//конец настройки портов

    while(1)
    {	
		butt = 	PINC&0b00000111;	
		bt1 = butt;
		switch (butt)
			{
				case 0b00000110: PORTD = 0b10000000;break;
				case 0b00000101: PORTD = 0b00000000;break;
				case 0b00000011: PORTD = 0b01000000;break;					
				default: ;
			}

		
        //TODO:: Please write your application code 
    }
}