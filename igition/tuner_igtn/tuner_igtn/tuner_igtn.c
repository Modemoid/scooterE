/*
 * tuner_igtn.c
 *
 * Created: 15.01.2015 7:50:39
 *  Author: skota
 */ 

//############################################################################################################################
//#
//#	БИБЛИОТЕКА РАБОТЫ С LCD ДИСПЛЕЯМИ WH1602 не поддерживающими кириллический шрифт.
//# Позволяет печатать кириллическим текстом (только заглавные символы), с условием, что одновременно на дисплей
//# будет выводится не более 8-ми, чисто кириллических символов, из ряда - БГДЖЗИЙЛПУФЦЧШЩЪЫЭЮЯ.
//# При попытке вывода на дисплей бОльшего количества кириллических символов, остальные будут заменятся символом "*".
//# пояснения в конце
//#
//#(programmed by SHADS)
//#
//############################################################################################################################

//3C,34,30,38,3A,32,36,3E,3F,3D,35,31,39,3B,33,37

//ВКЛЮЧАЕМЫЕ ФАЙЛЫ
#include <stdio.h>
#include <avr/io.h>
#include <string.h>
#include <avr/pgmspace.h>
#define F_CPU 16000000
#include <util/delay.h>


//НАСТРАИВАЕМЫЕ ДЕФАЙНЫ (порты и линии портов для работы с LED дисплеем)
#define LCDDataPORT 	PORTD									/*порт данных LCD*/
#define LCDDataDDR 		DDRD									/*программирование линий данных LCD*/
#define LCD_D4	3												/*линия данных D4*/
#define LCD_D5	4												/*линия данных D5*/
#define LCD_D6	5												/*линия данных D6*/
#define LCD_D7	6												/*линия данных D7*/

#define LCDControlPORT 	PORTD									/*порт линий управления LCD*/
#define LCDControlDDR 	DDRD									/*программирование линий управления LCD*/
#define LCD_RS	0 												/*линия управления RS*/
#define LCD_E	2												/*линия управления E*/


//НЕНАСТРАИВАЕМЫЕ ДЕФАЙНЫ
#define INLINE   inline __attribute__((__always_inline__))
#define NOINLINE __attribute__((__noinline__))

#define LCDCommandCurHome 			0x02						/*LCD переместить курсов в позицию 0,0*/
#define LCDCommandCurOn				0x0E						/*LCD показать курсор*/
#define LCDCommandCurBlink			0x0F						/*LCD мигающий курсор*/
#define LCDCommandCurOff			0x0C						/*LCD выключить курсор*/
#define LCDCommandCurLeft			0x10						/*LCD курсор переместить влево*/
#define LCDCommandCurRight			0x14						/*LCD курсор переместить вправо*/
#define LCDCommandDispClear 		0x01						/*LCD очистить данные дисплея*/
#define LCDCommandDispBlank			0x08						/*LCD скрыть данные (но не стирать)*/
#define LCDCommandDispVisible		0x0C						/*LCD отобразить данные*/
#define LCDCommandDispShiftLeft 	0x18						/*LCD сдвиг информации на дисплее влево*/
#define LCDCommandDispShiftRight 	0x1C						/*LCD сдвиг информации на дисплее вправо*/
#define LCDCommandDispModeProg		0x08|0x04					/*0x08 - программирование режима дисплея (присутствует всегда)*/
/*0x04 - отображение данных включено,*/
/*0x02 - курсор включен, 0x01 - курсор мерцает*/

unsigned char *buf, *rebuf;;



//ПРОТОТИПЫ ФУНКЦИЙ
static void LCDSendChar (unsigned char);					//отправить символ на LCD
static void LCDSendStr (char* );							//отправить строку на LCD
static void LCDSendCommand (unsigned char);					//отправить команду на LCD
static void LCDInit (void);									//Инициализация LCD
static void LCDCurGotoXY(unsigned char x, unsigned char y); //Перемещение курсора LCD в X,Y позицию

void LCD_cls(void){
	LCDSendCommand (LCDCommandDispClear);
}

int main( void )
{	
unsigned char m1,New;

unsigned int NewState,OldState,upState,downState;
unsigned char Vol;
DDRC=0x00;
PORTC|=1|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5);
DDRB&=~(1|(1<<1));
PORTB|=1|(1<<1);

	buf="Start!";
	LCDInit();
	LCDSendCommand (LCDCommandDispClear);						//очистить данные в самом дисплее
	LCDSendCommand (LCDCommandCurHome);
LCDSendStr(buf);
_delay_ms(3000);
LCD_cls();
LCDCurGotoXY(0,1);
LCDSendStr("Mod=    Read=   ");
	while(1){
LCDCurGotoXY(0,0);
m1=PINC;
buf="";
switch (m1)
{
	case 0x3C:
	buf="Menu 1 ";
	break;
	case 0x34:
	buf="Menu 2 ";
	break;
	case 0x30:
	buf="Menu 3 ";
	break;
	case 0x38:
	buf="Menu 4 ";	
	break;
	case 0x3A:
	buf="Menu 5 ";	
	break;
	case 0x32:
	buf="Menu 6 ";	
	break;
	case 0x36:
	buf="Menu 7 ";	
	break;
	case 0x3E:
	buf="Menu 8 ";	
	break;
	case 0x3F:
	buf="Menu 9 ";	
	break;
	case 0x3D:
	buf="Menu 10";	
	break;
	case 0x35:
	buf="Menu 11";	
	break;
	case 0x31:
	buf="Menu 12";	
	break;
	case 0x39:
	buf="Menu 13";	
	break;
	case 0x3B:
	buf="Menu 14";	
	break;
	case 0x33:
	buf="Menu 15";	
	break;
	case 0x37:
	buf="Menu 16";	
	break;
	default:
	buf="Pressed button";
}

      NewState=PINB & 0b00000011;
      //NewState=NewState>>5;  
     // sprintf(line,"vol=%d",NewState);
      //lcd_gotoxy(0,1);
      //lcd_puts(line);
if(NewState!=OldState)
{

switch(OldState)
	{
	case 2:
		{
		if(NewState == 3) upState++;
		if(NewState == 0) downState++; 
		break;
		}
 
	case 0:
		{
		if(NewState == 2) upState++;
		if(NewState == 1) downState++; 
		break;
		}
	case 1:
		{
		if(NewState == 0) upState++;
		if(NewState == 3) downState++; 
		break;
		}
	case 3:
		{
		if(NewState == 1) upState++;
		if(NewState == 2) downState++; 
		break;
		}
	}            
OldState=NewState;
}      
 if (upState >= 4) 
      {                            
        Vol--;
        upState = 0;
      }
      if (downState >= 4) 
      {                              
        Vol++;
        downState = 0;
      }
	  
itoa(Vol,rebuf,10);	  
LCDCurGotoXY(0,0);
LCDSendStr(buf);
LCDCurGotoXY(4,1);
LCDSendStr(rebuf);
	}
}


//----------------------------------------------------------------------------------------------
//задержка для строб импульса
NOINLINE void LCDStrobeDelay (void)
{
	_delay_ms (1);
}

//строб импульс
NOINLINE void LCDEStrobe (void)
{
	LCDControlPORT|= (1<<LCD_E);
	LCDStrobeDelay ();
	LCDControlPORT &= ~(1<<LCD_E);
	LCDStrobeDelay ();
}

//Функция инициализации LCD
void LCDInit (void)
{
	LCDDataPORT &= ~(1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//очистить линии данных
	LCDDataDDR |= (1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//линии данных на вывод
	LCDControlPORT &= ~(1<<LCD_E|1<<LCD_RS);					//очистить линии управления
	LCDControlDDR |= (1<<LCD_E|1<<LCD_RS); 						//линии управления на вывод

	//_delay_ms (50);		//закомментировать, если в фузах контроллера запрограммирована задержка при старте 64мс
	LCDDataPORT |= (1<<LCD_D5|1<<LCD_D4);
	LCDEStrobe ();
	_delay_ms (5);
	LCDEStrobe ();
	LCDEStrobe ();
	LCDDataPORT &= ~(1<<LCD_D4);
	LCDEStrobe ();

	LCDSendCommand (0x28);										//режим - 4 бита, 2 строки
	LCDSendCommand (LCDCommandDispModeProg);					//режим дисплея (определен в дефайнах)
}


//----------------------------------------------------------------------------------------------
//Функция установки курсора в нужную позицию

void LCDCurGotoXY (unsigned char x, unsigned char y)
{
	if (y == 1)
	x |= 0x40;
	LCDSendCommand (0x80 | x);
}


//----------------------------------------------------------------------------------------------
//Функция отправки команды на LCD
//АРГУМЕНТ - код команды

void LCDSendCommand (unsigned char byte)
{
	LCDDataPORT &= ~(1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//очистить линии данных
	LCDDataPORT |= ((byte & 0b11110000) >> (4-LCD_D4));			//вывод старшей тетрады команды
	LCDEStrobe ();												//строб импульс

	LCDDataPORT &= ~(1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//очистить линии данных
	LCDDataPORT |= ((byte & 0b00001111) << (LCD_D4));			//вывод младшей тетрады команды
	LCDEStrobe ();												//строб импульс
}


//----------------------------------------------------------------------------------------------
//функция вывода символа на LCD дисплей (в текущую позицию)
//АРГУМЕНТ - код символа

void LCDSendChar (unsigned char byte)
{
	LCDControlPORT |= 1<<LCD_RS;								//признак загрузки символа
	LCDSendCommand (byte);										//вывод символа
	LCDControlPORT &= ~(1<<LCD_RS);
}

static void LCDSendStr (char *str ){
	while (*str) {
LCDSendChar(*str++);	
LCDStrobeDelay();
}


	
}