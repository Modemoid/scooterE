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

unsigned char *buf;

//ПРОТОТИПЫ ФУНКЦИЙ
static void LCDSendChar (unsigned char);					//отправить символ на LCD
static void LCDSendStr (char* );							//отправить строку на LCD
static void LCDSendCommand (unsigned char);					//отправить команду на LCD
static void LCDInit (void);									//Инициализация LCD
static void LCDCurGotoXY(unsigned char x, unsigned char y); //Перемещение курсора LCD в X,Y позицию

int main( void )
{	
unsigned char m1;
DDRC=0x00;
PORTC|=1|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5);

	buf="Start!";
	LCDInit();
	LCDSendCommand (LCDCommandDispClear);						//очистить данные в самом дисплее
	LCDSendCommand (LCDCommandCurHome);
LCDSendStr(buf);
	while(1){
LCDCurGotoXY(0,0);
m1=PINC;
sprintf(buf,"%X",m1);
LCDSendStr(buf);
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
register char c;

while ( (c = *str++) ) {
LCDSendChar(c);	
}


	
}