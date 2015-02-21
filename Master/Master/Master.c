/*
* Master.c
*
* Created: 23.01.2015 16:28:53
*  Author: kartsev
*/ 


#define LED1 0
#define LED2 1
#define LED3 2
#define LED4 3
#define LED_PORT PORTC
#define LED_DDR DDRC
#define SetLed1 LED_PORT|= 1<<LED1; //set на чтение
#define SetLed2 LED_PORT|= 1<<LED2; //set на чтение
#define SetLed3 LED_PORT|= 1<<LED3; //set на чтение
#define SetLed4 LED_PORT|= 1<<LED4; //set на чтение
#define ClearLed1 LED_PORT&= ~(1<<LED1);//clear
#define ClearLed2 LED_PORT&= ~(1<<LED2);//clear
#define ClearLed3 LED_PORT&= ~(1<<LED3);//clear
#define ClearLed4 LED_PORT&= ~(1<<LED4);//clear
#define SwitchLed1 LED_PORT = LED_PORT ^ (1<<LED1); //switch
#define SwitchLed2 LED_PORT = LED_PORT ^ (1<<LED2); //switch
#define SwitchLed3 LED_PORT = LED_PORT ^ (1<<LED3); //switch
#define SwitchLed4 LED_PORT = LED_PORT ^ (1<<LED4); //switch

#define UART_RX_BUFFER_SIZE 8
#define UART_TX_BUFFER_SIZE 8



#define F_CPU 8000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/delay.h>
#include "lcd.h"


char RXBUFF[UART_RX_BUFFER_SIZE];
char TXBUFF[UART_TX_BUFFER_SIZE];

uint8_t BufferTX_index = 0;
uint8_t BufferRX_index = 0;
char RXOvfflag = 0;
char temp = 0x21;
char temp1 = 'd';
/*
ISR(USART_TXC_vect)
{
	
}
*/
ISR(USART_RXC_vect)
{
	RXBUFF[BufferRX_index] = UDR;
	BufferRX_index++;
	
	if (BufferRX_index == 6)
	{
		//RXOvfflag = 1;
		BufferRX_index = 0;
		
	}
}

// void UartTX(char count,char *arr)
// {
// 	for(int counter = 0; counter < count; counter ++)
// 	{
// 		
// 		uart_putc(RXBUFF[counter]);
// 		
// 	}
// 
// }
// void UartRX(void)
// {
// 	RXBUFF[BufferRX_index] = uart_getc();
// 	BufferRX_index++;
// 
// }
unsigned char USART_ReadUCSRC( void )
{
	unsigned char ucsrc;
	/* Read UCSRC */
	ucsrc = UBRRH;
	ucsrc = UCSRC;
	return ucsrc;
}
void InitUSART()
{
	SetLed1
	//19.2k ubrr=25 err=0.2%
	#define baudrate 9600UL
	#define bauddivider (F_CPU/(16*baudrate)-1)
	#define HI(x) ((x)>>8)
	#define LO(x) ((x)& 0xFF)

	//Init UART
	UBRRL = LO(bauddivider);
	UBRRH = HI(bauddivider);
	UCSRA = 0;
	UCSRB = 1<<RXEN|0<<TXEN|1<<RXCIE|0<<TXCIE|0<<UDRIE;
	UCSRC = 1<<URSEL|1<<UCSZ0|1<<UCSZ1;


}
int main(void)
{

	LED_DDR|= (1<<LED1)|(1<<LED2)|(1<<LED3);     //Led port
	LED_PORT&= ~(1<<LED1)|(1<<LED2)|(1<<LED3); //Led port
	lcd_init(LCD_DISP_ON);  //инициализация дисплея
	// другие опции см в lcd_init(), view lcd.h file
	
InitUSART();
sei();



		//lcd_clrscr();             // очистить lcd

		
	while(1)
	{
				lcd_gotoxy(0,0);
				//lcd_puts("Master! ");// написать начиная с текущей позиции
				lcd_puts(RXBUFF);
// 				lcd_putc(RXBUFF[1]);
// 				lcd_putc(RXBUFF[2]);
// 				lcd_putc(RXBUFF[3]);
// 				lcd_putc(RXBUFF[4]);
// 				lcd_putc(RXBUFF[5]);
 				lcd_putc(" ");
				//lcd_puts(temp1);
				_delay_ms(100);
				SwitchLed3
		//_delay_ms(500);
		//SwitchLed1
	}
}