/*
 * tuner_igtn.c
 *
 * Created: 15.01.2015 7:50:39
 *  Author: skota
 */ 

#define F_CPU	1600000
#include <avr/io.h>
#include <avr/pgmspace.h>
#include "lcd-library.h"



char Char10[]  = {0b00000000,
	0b00000111,
	0b00011111,
	0b00011110,
	0b00001100,
	0b00001100,
	0b00011111,
0b00000000};

char Char11[]  = {0b00000000,
	0b00011100,
	0b00011111,
	0b00001111,
	0b00000110,
	0b00000110,
	0b00011111,
0b00000000};

char Char12[]  = {0b00001010,
	0b00001110,
	0b00000010,
	0b00000000,
	0b00001100,
	0b00000010,
	0b00000100,
0b00001110};

char stringOne[]  = "\10 So long, and thanks \11\0";
char stringTwo[]  = "\12 for all the fish! \12\0";

int main(void)
{
	char i = 1;
	char dir = LCD_SCROLL_LEFT;
	
	lcdInit();/*
	_delay_ms(100);
	lcdLoadCharacterf(0, Char10);
	lcdLoadCharacterf(1, Char11);
	lcdLoadCharacterf(2, Char12);
	

	
	DDRB |= (1<<7);
	*/	lcdGotoXY(0,2);
	lcdPutsf(stringOne);
	
	lcdGotoXY(1,3);
	lcdPutsf(stringTwo);
	while(1)
	{
		
		PORTB |= (1<<7);
		_delay_ms(200);
		
		PORTB &= ~(1<<7);
		_delay_ms(100);
		lcdDisplayScroll(1, dir);
		if (i == 11){
			if (dir == LCD_SCROLL_LEFT){
				dir = LCD_SCROLL_RIGHT;
			}
			else{
				dir = LCD_SCROLL_LEFT;
			}
			i = 0;
		}
		i++;

	}
}