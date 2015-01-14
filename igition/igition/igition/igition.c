/*
 * igition.c
 *
 * Created: 14.01.2015 12:29:50
 *  Author: skota
 */ 
#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

asm("sei");

float koof;
unsigned int time;
unsigned char igt=0;

int main(void)
{
	
	PORTB=0x00;
	DDRB=0x08;
	PORTC=0x00;
	DDRC=0x00;
	PORTD=0x01;
	DDRD=0x10;
	TCCR1B=0x05;
	GICR|=0x40;
	MCUCR=0x03;
	GIFR=0x40;
	TIMSK=0x1C;
	koof=360/79.3;
	
	while(1)
	{
		if (!( (1 << PD0) & PIND)){
			PORTD|=(1<<4);
			PORTB|=(1<<3);
			_delay_ms(4);
			PORTD&=~(1<<4);
			PORTB&=~(1<<3);
			_delay_ms(10);
		}
	}
}

ISR(INT0_vect){

	TCCR1B=0x05;
	time=TCNT1;
	TCNT1=0;
	OCR1A=time/koof;
	if (time<540) igt=64;
	
}

ISR(TIMER1_COMPA_vect){
	
	asm("cli");
	PORTB^=(1<<3);
	// Place your code here
	PORTD|=(1<<4);
	OCR1B=OCR1A+16;
	igt++;
	asm("sei");
	
}

ISR(TIMER1_COMPB_vect){
	
	asm("cli");
	// Place your code here
	PORTD&=~(1<<4);
	if (igt<=2) {
		OCR1A=OCR1B+16;
	}
	else igt=0;

	asm("sei");
	
}

ISR(TIMER1_OVF_vect){
	
	TCCR1B=0x00;
	
}

ISR(USART_RXC_vect){
	
}