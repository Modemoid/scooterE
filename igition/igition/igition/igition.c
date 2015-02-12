/*
 * igition.c
 *
 * Created: 14.01.2015 12:29:50
 *  Author: skota
 */ 
#define F_CPU 8000000// 3276800
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
//#define URT_EN 1
//#include "MSCS_lib.h"

float koof;
unsigned int time;
unsigned char igt=0;
unsigned int delay=0;


ISR(INT0_vect){
	asm("cli");

	TCCR1B=0x03;
	time=TCNT1;
	TCNT1=0;
	delay=time*koof;
	OCR1A=delay;
	OCR1B=time/2-OCR1A;
	#ifdef URT_EN
	unsigned char buf[10];
		 sprintf(buf,"%u - %u\r\n",time,delay);
		 USART_TransmitString(buf);
	#endif		 
	//if (time<3200) 
	//igt=64; 
	//else igt=0;
	asm("sei");
}

ISR(TIMER1_COMPA_vect){
	
	asm("cli");
	PORTB^=(1<<3);
	// Place your code here
	PORTD&=~(1<<4);
	OCR1B=OCR1A+600;
	//igt++;
	asm("sei");
	
}

ISR(TIMER1_COMPB_vect){
	
	asm("cli");
	// Place your code here
	PORTD|=(1<<4);
// 	if (igt<=2) {
// 		OCR1A=OCR1B+600;
// 	}
// 	else igt=0;

	asm("sei");
	
}

ISR(TIMER1_OVF_vect){
	PORTD|=(1<<4);
	TCCR1B=0x00;
	
}


#ifdef URT_EN
void USART_Transmit(unsigned char data)
{
	while (!(UCSRA & (1<<UDRE)));
	UDR = data;
}
void USART_TransmitString(char *data)
{
	while (*data) USART_Transmit(*data++);
}
unsigned char USART_Receive(void)
{
	while (!(UCSRA & (1<<RXC)));
	return UDR;
}

#endif

int main(void)
{
// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T
PORTB=0x10;
DDRB=0x08;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=0 State3=T State2=T State1=T State0=P
PORTD=0x01;
DDRD=0x10;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 3276,800 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: On
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
GICR|=0x40;
MCUCR=0x03;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x1C;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
//UCSRA=0x00;
//UCSRB=0x18;
//UCSRC=0x86;
//UBRRH=0x00;
//UBRRL=0x14;
	// USART settings: 9600 baud 8-n-1
	// WARNING: real baud = 9752: err = 1,58333333333334%
/*	UBRRH = 0;
	UBRRL = 20;
	UCSRB = (1<<RXCIE) | (1<<RXEN) | (1<<TXEN);
	UCSRC = (1<<URSEL) | (1<<UCSZ1) | (1<<UCSZ0);
	SREG |= (1<<7); // enable interrupts
	USART_TransmitString("dsgfgsdg\r\n");
// */


#ifdef URT_EN

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0;//(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;
	USART_TransmitString("dsgfgsdg\r\n");

#endif


// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;
	koof=0.19067;
	
	PORTD|=(1<<4);
/*MSCS_init();
unsigned char transmit_buf[17],resiv_buf[17];
unsigned int fractional;
float fractional_part;*/
asm("sei");	


	while(1)
	{
		/*transmit_buf[12]='g';
		transmit_buf[13]='e';
		transmit_buf[14]='r';
		transmit_buf[15]='b';
		transmit_buf[0]=OCR1AH;
		transmit_buf[1]=OCR1AL;
		transmit_buf[2]=koof;
		fractional_part=(koof-transmit_buf[2])*1000.0;
		fractional=fractional_part;
		transmit_buf[3]=fractional/100;
		transmit_buf[4]=fractional%100;
		MSCS_com(transmit_buf,0,resiv_buf);
		*/
		if (!( (1 << PB4) & PINB))
		{
			PORTD&=~(1<<4);
			PORTB|=(1<<3);
			_delay_ms(40);
			PORTD|=(1<<4);
			PORTB&=~(1<<3);
			_delay_ms(100);
		}
		//USART_Transmit(USART_Receive());
		

	}
}