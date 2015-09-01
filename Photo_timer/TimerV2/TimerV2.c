/*
 * UV_lighter.c
 *
 * Created: 21.03.2012 16:46:53
 *  Author: kartsev
Описание ЛЦД-библиотеки смотеть http://maxembedded.wordpress.com/2011/06/16/lcd-interfacing-with-avr/ и http://homepage.hispeed.ch/peterfleury/avr-lcd44780.html
 */ 

#define simulation
#define DEBUG
#define ShowKey

#define F_CPU 1000000UL
#include <avr/io.h>
#include <avr/delay.h>



//#define ADCHI 
//#define ADCLO
#define InPort DDRD
#define InPull PORTD
#define InPin PIND



#define Vadc1 1 //строка в которой показывать ADC
#define VLine 0 //строка в которой показывать Volts
#define KBDebugL 0
#define KBDebugP 0

//Когда ножка настроена на вход, то если PORTxy=0, то вывод в режиме Hi-Z. Если PORTxy=1 то вывод в режиме PullUp с подтяжкой резистором в 100к до питания.



//#include "MatrixKB.h"
#include "lcd.h"
int main(void) 
{
	//int n,n1,n2,n3; //счетчик
	char swadc7,swadc6, buffer[15]; //для дисплея - чтоб переводить в строковую переменную
	char KBstate[4];

	
	//настройка портов
	DDRD = 0b00001111;  //kb port
	PORTD = 0b11110000; //kb port
	#define KBL1mask 0b00001110;
	#define KBL2mask 0b00001101;
	#define KBL3mask 0b00001011;
	#define KBL4mask 0b00000111;

	//PINx регистр чтения
	//PORTx 1=pullup(in)
	//DDRx 0=in 1=out
	//конец настройки портов
	
	
	//adc setup
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);	
											//1<<REFS0|1<<REFS1 = от внутренних 2.5в, 
											//0<<REFS0|0<<REFS1 = AREF
											//adlar = 1 младший байт (ADCL) не нужен - там мусор, брать только ADCH 
											//mux0-mux3 выбирать какой ацп 0-0<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 1-1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3
											//0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC6
											//1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC7 
	ADCSRA = (1<<ADEN|1<<ADSC|0<<ADFR|1<<ADPS0|0<<ADPS1|1<<ADPS2);
	  _delay_ms(5);				//задержка
	  swadc6 = ADCL;
	  swadc6 = ADCH;
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	//1<<REFS0|1<<REFS1 = от внутренних 2.5в,
	//0<<REFS0|0<<REFS1 = AREF
	//adlar = 1 младший байт (ADCL) не нужен - там мусор, брать только ADCH
	//mux0-mux3 выбирать какой ацп 
	//0<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 = ADC0
	//1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 = ADC1
	
	//0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC6
	//1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC7
	ADCSRA = (1<<ADEN|1<<ADSC|0<<ADFR|1<<ADPS0|0<<ADPS1|1<<ADPS2);
	_delay_ms(5);				//задержка
	swadc7 = ADCL;
	swadc7 = ADCH;	
											
	//end adc setup
	//инициализация usart`a
	//конец инициализация usart`a
	
	lcd_init(LCD_DISP_ON);  //потом вЫключить //инициализация дисплея, курсора не видно 
								 // другие опции см в lcd_init(), view lcd.h file
	
//reading static switch mode

//end of reading static switch mode
    while(1)                     // бесконечный цикл 
    {

        lcd_clrscr();             // очистить lcd 
	
        //lcd_home();             //поставить курсор в home
        lcd_gotoxy(0,0);		  //поставть курсор а позицию,строку
#ifdef DEBUG		
		lcd_puts(__DATE__);
		lcd_gotoxy(2,1);
		lcd_puts(__TIME__);
		_delay_ms(200);	 
#endif 
		//lcd_puts("UV-Lamp rev.01");// написать начиная с текущей позиции 

		
		KBstate[4]=0;
		PORTD = KBL1mask;
		switch (PIND)
		{
			case 0b11101110: KBstate[4]=1;break;
			case 0b11011110: KBstate[4]=2;break;
			case 0b10111110: KBstate[4]=3;break;
			case 0b01111110: KBstate[4]=4;break;
		default: ;
		}
		PORTD = KBL2mask;	
		switch (PIND)
		{
			case 0b11101101: KBstate[4]=5;break;
			case 0b11011101: KBstate[4]=6;break;
			case 0b10111101: KBstate[4]=7;break;
			case 0b01111101: KBstate[4]=8;break;
			default: ;
		}
		PORTD = KBL3mask;
		KBstate[2] = PIND;	
		switch (PIND)
		{
			case 0b11101011: KBstate[4]=9;break;
			case 0b11011011: KBstate[4]=10;break;
			case 0b10111011: KBstate[4]=11;break;
			case 0b01111011: KBstate[4]=12;break;
			default: ;
		}
		PORTD = KBL4mask;
		KBstate[3] = PIND;	
		switch (PIND)
		{
			case 0b11100111: KBstate[4]=13;break;
			case 0b11010111: KBstate[4]=14;break;
			case 0b10110111: KBstate[4]=15;break;
			case 0b01110111: KBstate[4]=16;break;
			default: ;
		}	
		
		//KBstate[0] = PIND;	
		//PORTD = KBL2mask;
		//KBstate[1] = PIND;
		//PORTD = KBL3mask;
		//KBstate[2] = PIND;
		//PORTD = KBL4mask;
		//KBstate[3] = PIND;
		
/*		itoa(KBstate[0],buffer, 2);           //обновить буфер
		lcd_gotoxy(KBDebugP,KBDebugL);          //поставить курсор
		lcd_puts(buffer);
				itoa(KBstate[2],buffer, 2);           //обновить буфер
				lcd_gotoxy(KBDebugP+3,KBDebugL);          //поставить курсор
				lcd_puts(buffer);
				itoa(KBstate[3],buffer, 2);           //обновить буфер
				lcd_gotoxy(KBDebugP+3,KBDebugL+1);          //поставить курсор
				lcd_puts(buffer);
		
	*/	
#ifdef ShowKey
				itoa(KBstate[4],buffer, 10);           //обновить буфер
				lcd_gotoxy(KBDebugP,KBDebugL+1);          //поставить курсор
				lcd_puts(buffer);
#endif	

#ifdef DEBUG	
itoa(swadc6,buffer, 10);           //обновить буфер
lcd_gotoxy(12,0);          //поставить курсор
lcd_puts(buffer);
itoa(swadc7,buffer, 10);           //обновить буфер
lcd_gotoxy(12,1);          //поставить курсор
lcd_puts(buffer);	
#endif	
#ifdef simulation
	    _delay_ms(300);				/*задержка 0.3 секунда*/
#endif


#ifdef DEBUG
# warning "builded debug mode"
#endif
#ifdef simulation
# warning "builded for simulation"
#endif

    }


    
    
    
}		
		
		
		
		//lcd_gotoxy(5,0);
		//lcd_gotoxy(8,Vadc1);	
		//lcd_puts(".a0h");
		//n1=n*94/1000;
		//itoa(n1,buffer, 10);          //обновить буфер
		//lcd_gotoxy(0,VLine);          //поставить курсор 2 строку 1 поз.
    	//lcd_puts(buffer);
		//n1=n*94%1000;
		//itoa(n1,buffer, 10);           //обновить буфер
    	//lcd_puts(",");
		//lcd_puts(buffer);
		//lcd_puts(" V;");
		
		//n2 = InPin;
		//lcd_gotoxy(0,Vadc1); 
		//itoa(n1,buffer, 2); 
		//lcd_puts(n2);
		
		//n3++;
		//lcd_gotoxy(14,Vadc1); 
		//itoa(n3,buffer, 10); 
		//lcd_puts(buffer);
				

		//itoa(n,buffer, 2); /*обновить буфер*/
		//lcd_gotoxy(0,0);          /*поставить курсор 2 строку 1 поз.*/
    	//lcd_puts(buffer);
		//lcd_gotoxy(8,0);
		//lcd_puts(".a0H");
		//ADMUX = (1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3|1<<REFS0|1<<REFS1|1<<ADLAR);
		//ADCSRA = (1<<ADEN|1<<ADSC|0<<ADPS0|1<<ADPS1|0<<ADPS2);
	    //_delay_ms(5);				/*задержка*/
		//n = 0;
		//n1 = 0;
		//n = ADCL;
		//n = ADCH;
		//itoa(n,buffer, 10); /*обновить буфер*/
		//lcd_gotoxy(0,1);           /*поставить курсор 2 строку 0 поз.*/
    	//lcd_puts(buffer);
		//lcd_gotoxy(8,1);
		//lcd_puts(".a1H");
		//lcd_gotoxy(9,0);          /*поставить курсор 2 строку 1 поз.*/
		//itoa(1,buffer, 5); /*обновить буфер*/
    	//lcd_puts(buffer);
		//lcd_gotoxy(13,0);
		//lcd_puts("a1H");
        
		    //lcd_init(LCD_DISP_OFF);//потом включить
		    //_delay_ms(2000);//потом включить
		    //lcd_puts(buffer);			/*затолкать в строчку то что у нас в массиве buffer*/
		    //n = n+1;
		    //itoa(n, buffer, 10); /*обновить буфер*/
		    /*попользуем АЦП на самой маленькой скорости*/

				
