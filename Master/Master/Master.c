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

#define UART_RX_BUFFER_SIZE 10
#define UART_TX_BUFFER_SIZE 10



#define F_CPU 8000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/delay.h>
#include "lcd.h"

/*
** constant definitions
*/
static const PROGMEM unsigned char copyRightChar[] =
{
	0b00010111, 
	0b00011011, 
	0b00011101, 
	0b00000000, 
	0b00011101, 
	0b00011011, 
	0b00010111, 
	0b00000000, 
	
	0b00001000,
	0b00000100,
	0b00000010,
	0b00011111,
	0b00000010,
	0b00000100,
	0b00001000,
	0b00011111,

	0b00011101,
	0b00011011,
	0b00010111,
	0b00000000,
	0b00010111,
	0b00011011,
	0b00011101,
	0b00011111,
	
	0b00000010,
	0b00000100,
	0b00001000,
	0b00011111,
	0b00001000,
	0b00000100,
	0b00000010,
	0b00011111,
};

char RXBUFF[UART_RX_BUFFER_SIZE];
char TXBUFF[UART_TX_BUFFER_SIZE];
char DataRXBuff[4];
char dataOK;
char dataEnd;
char LCD_Line1[LCD_DISP_LENGTH];

uint8_t BufferTX_index = 0;
uint8_t BufferRX_index = 0;
char RXOvfflag = 0;
char i;
//char temp1 = 'd';

ISR(USART_TXC_vect)
{
	
}

ISR(USART_RXC_vect)
{
	RXBUFF[BufferRX_index] = UDR;
	BufferRX_index++;
	
	if (BufferRX_index == 8)
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

void InitUSART()
{
	//SetLed1
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
void DataEndSearch(void) 
{
	
	char lt = 0;//LocalTemp
	dataEnd = 0;

	for (lt = UART_RX_BUFFER_SIZE;lt > 0;lt--)
	{
		if (RXBUFF[lt] == 0xFF)
		{
			if (RXBUFF[lt] == RXBUFF[lt-1])
			{
				if (dataEnd < lt)
				{
				dataEnd = lt;
				}
			}
		}
	}
}
void DataCheck(void) //if (DataRXBuff[3] = 7) all 3 data byte received correct.
{
	DataRXBuff[3] = 0;
	
	if ((RXBUFF[dataEnd-7] ^ RXBUFF[dataEnd-6]) == 0xff)
	{
		DataRXBuff[0] = RXBUFF[dataEnd-7];
		DataRXBuff[3] |= 0b00000001;
	}
	else
	{
		DataRXBuff[3]|= 0b00010000;
	}
	
	if ((RXBUFF[dataEnd-5] ^ RXBUFF[dataEnd-4]) == 0xff)
	{
		DataRXBuff[1] = RXBUFF[dataEnd-5];
		DataRXBuff[3] |= 0b00000010;
	}
	else
	{
		DataRXBuff[3] |= 0b00100000;
	}
	if ((RXBUFF[dataEnd-3] ^ RXBUFF[dataEnd-2]) == 0xff)
	{
		DataRXBuff[2] = RXBUFF[dataEnd-3];
		DataRXBuff[3] |= 0b00000100;
	}
	else
	{
		DataRXBuff[3]|= 0b01000000;
	}
	
}

char LightShow(char decoded[4])
{
	lcd_gotoxy(0,0);
	if (decoded[0]==0xCC)//if into decoded array data from ight controller 
	{
	//	lcd_puts("ok data");
	if decoded[1] 
		
	switch (decoded[1])
	{
		case 0: 
		{
			turnOn |= 0b00000001;break;
		}
		default: ;
	}
	
	}
	else
	{
	//	lcd_puts("wrong data");
	}
	
	
/*
	lcd_puts("!:");
	lcd_puts(decoded[0]);
	lcd_puts(decoded[1]);
	lcd_puts(decoded[2]);
	lcd_puts(decoded[3]);
	*/
	//itoa(*decoded[0],LCD_Line1,16);
	//lcd_puts(LCD_Line1);
	_delay_ms(100);
	
} 
void DebugOut(void)
{
			
			lcd_gotoxy(0,0);
			lcd_puts(RXBUFF);
			lcd_puts(" !");
			//	 lcd_putc('@');
			//	 itoa(num, buffer, 10);
			// lcd_gotoxy(0,1);
			// lcd_putc(0);
			// lcd_putc(2);
			//_delay_ms(200);
			lcd_gotoxy(0,1);
			// lcd_putc(1);
			//lcd_putc(3);
			// lcd_puts(" DataEnd = ");
			itoa(DataRXBuff[0],LCD_Line1,16);
			lcd_puts(LCD_Line1);
			lcd_putc(' ');
			lcd_gotoxy(3,1);
			itoa(DataRXBuff[1],LCD_Line1,16);
			lcd_puts(LCD_Line1);
			lcd_putc(' ');
			lcd_gotoxy(6,1);
			itoa(DataRXBuff[2],LCD_Line1,16);
			lcd_puts(LCD_Line1);
			lcd_putc(' ');
			lcd_gotoxy(9,1);
			itoa(DataRXBuff[3],LCD_Line1,16);
			lcd_puts(LCD_Line1);
			lcd_putc(' ');
			_delay_ms(50);
			//SwitchLed3
			//_delay_ms(500);
			//SwitchLed1
}
int main(void)
{

	LED_DDR|= (1<<LED1)|(1<<LED2)|(1<<LED3);     //Led port
	LED_PORT&= ~(1<<LED1)|(1<<LED2)|(1<<LED3); //Led port
	
	lcd_init(LCD_DISP_ON);  //инициализация дисплея
	// другие опции см в lcd_init(), view lcd.h file
	
	InitUSART();
sei();

lcd_command(_BV(LCD_CGRAM));  /* set CG RAM start address 0 */
for(i=0; i<32; i++)
{
	lcd_data(pgm_read_byte_near(&copyRightChar[i]));
}


		//lcd_clrscr();             // очистить lcd

		
	while(1)
	{
		DataEndSearch();
		DataCheck();
		lcd_clrscr();
		LightShow(DataRXBuff);
		
		//DebugOut();

	}
}