/*
.Проект: Простой термометр для дома с двумя датчиками ds18b20
.Автор:Гаркуша Антон
.E-mail:gam-raingers@mail.ru
.Дата:29.06.2008
*/
#include<avr/io.h>
#include<util/delay.h>
#include<avr/interrupt.h>
#include <stdbool.h>
#define RS PB0
#define E  PB1
#define WireDDR DDRB
#define WirePORT PORTB
#define WirePin 0
#define WirePIN PINB
#define WirePinN PINB0
//#define WireCheck 'PIND & (1<<PIND6)'


unsigned char i=0;
unsigned char j=0;
unsigned char z=0;
unsigned char was_conflict=0; //Признак наличия конфликта битов
unsigned char temperature=0;  //Значение t в целых числах
int grand_temperature=0; //Значение t со знаком,полученное от датчика(16 бит)
unsigned char des_temperature=0; //Значение t в десятых долях
unsigned char cifra=0; //Вспомогательная переменная для индикации t
unsigned char znak=0;  //Знак температуры: 0 - "+";1 - "-"
unsigned char precense_ds18b20=0; //Признак присутствия датчика
unsigned char buffer[8]={'S','t','a','r','t','.','.','.'};
unsigned char ROM1[8]={0,0,0,0,0,0,0,0};
unsigned char ROM2[8]={0,0,0,0,0,0,0,0};
unsigned char TermoPresent = 0;
unsigned char TermoFail = 0;
unsigned char DEbArr[8];
bool get_for_two=false;
//==========================================================
void send_command(unsigned char command);
void send_data(unsigned char data);
void ini_LCD(void);
void LCD_pause(void);
unsigned char show_cifra(unsigned char i);
void reset_ds1820(void);
void send_ds1820_command(unsigned char command);
void receive_ds1820(void);
unsigned char create_des(void);
void search_ds1820_ROM(void);
void send_ROM_ds1820(unsigned char ROM);

SIGNAL(SIG_OVERFLOW1)//todo fix timer -we have only 8 bit
{
	TCNT1=0xF3CB;
	//send_command(0x80);
	if(precense_ds18b20!=0)  //Если датчик откликнулся
	{
		DEbArr[0] = 'T';
		//Если обнаружен один датчик,то was_conflict==0 => отображаем
		//температуру одного датчика.В таком случае вместо значков k или
		//y отображаем пробел
		if(was_conflict==1)
		{
			if(PINB & (1<<PINB0)) //todo fix defines
			{
				DEbArr[1] = 'k';//termo1
			}
			else
			{
				DEbArr[1] = 'y';//termo2
			}
		}
		else
		{
			DEbArr[1] =' ';
		}
		DEbArr[2] ='=';
		if(znak==0) //Отображение знака температуры
		{
			DEbArr[3] ='+';
		}
		else
		{
			DEbArr[3] ='-';
		}
		DEbArr[4] = temperature/10;
		DEbArr[5] = temperature%10;
		DEbArr[6] = ',';
		DEbArr[7] = create_des();
		//cifra=temperature/10;
		//send_data(show_cifra(cifra));
		//cifra=temperature%10;
		//send_data(show_cifra(cifra));
		//send_data(',');
		//cifra=create_des();
		//send_data(show_cifra(cifra));
	}
	else                      //Если датчик не откликнулся
	{
		if (TermoFail > 254) //todo fix error action
		{
			TermoFail = 0;
		}
		TermoFail++;
		
	}
}
/*
void send_command(unsigned char command)
{
	//Старшая тетрада
	PORTB &=~_BV(RS);
	PORTB=command;
	PORTB|= _BV(E);
	_delay_loop_2(100);
	PORTB&=~_BV(E);
	_delay_loop_2(100);
	//Младшая тетрада
	PORTB=command;
	PORTB=PORTB<<4;
	PORTB &=~_BV(RS);
	PORTB|= _BV(E);
	_delay_loop_2(100);
	PORTB&=~_BV(E);
	_delay_loop_2(250);
}

void send_data(unsigned char data)
{
	//Старшая тетрада
	PORTB&=0x0F;
	PORTB|=((data & 0xF0) |0x01);
	PORTB|= _BV(E);
	_delay_loop_2(100);
	PORTB&=~_BV(E);
	_delay_loop_2(100);
	//Младшая тетрада
	PORTB&=0x0F;
	PORTB|=((data<<4) |0x01);
	PORTB|= _BV(E);
	_delay_loop_2(100);
	PORTB&=~_BV(E);
	_delay_loop_2(250);
}

void LCD_pause(void)
{
	_delay_loop_2(4000);
}

void ini_LCD(void)
{
	_delay_loop_2(32000);
	_delay_loop_2(32000);
	send_command(0x30);
	LCD_pause();LCD_pause();LCD_pause();
	send_command(0x30);
	LCD_pause();
	send_command(0x30);
	LCD_pause();
	send_command(0x20);
	LCD_pause();
	send_command(0x20);
	LCD_pause();
	send_command(0x08);
	LCD_pause();
	send_command(0x01);
	LCD_pause();
	send_command(0x06);
	LCD_pause();
	send_command(0x0C);
	LCD_pause();

	send_command(0x80);
	LCD_pause();
	for(i=0;i<8;i++)
	{
		send_data(buffer[i]);
		for(j=0;j<20;j++)
		{
			_delay_loop_2(25000);
		}
	}
}

unsigned char show_cifra(unsigned char i)
{
	unsigned char sym=0;
	switch(i)
	{
		case 0:sym='0';break;
		case 1:sym='1';break;
		case 2:sym='2';break;
		case 3:sym='3';break;
		case 4:sym='4';break;
		case 5:sym='5';break;
		case 6:sym='6';break;
		case 7:sym='7';break;
		case 8:sym='8';break;
		case 9:sym='9';break;
	}
	return sym;
}
*/
//Функции для работы с DS18B20
//Функция сброса DS1820
void reset_ds1820(void)
{
	cli();
	WireDDR|=_BV(WirePin);        // Вывод порта настраеваем как выход
	_delay_loop_2(1200); //Устанавливаем 0 в теч. около 480 мкс
	WireDDR&=~_BV(WirePin);       //Вывод порта настраеваем как вход
	_delay_loop_2(175);  //Ожидание сигнала присутствия 70 мкс
	if(PINB & (1<<PINB0))  //Если 1 - нет сигнала присутвия //todo fix defines
	{
		precense_ds18b20=0;
	}
	else
	{
		precense_ds18b20=1;   //Если сигнал присутвия получен
	}
	_delay_loop_2(1025); //410 мкс
	sei();
}
//Функция пересылки команд

void send_ds1820_command(unsigned char command)
{
	cli();
	unsigned char data=command;
	for(i=0;i<8;i++)
	{
		data=data<<7;        //Сдвиг на i разрядов влево
		command=command>>1;  //Сдвиг передаваемого байта
		if(data==0x80)       //Передача лог.1
		{
			WireDDR|=_BV(WirePin);
			_delay_loop_2(15);   //Задержка примерно на 6 мкс
			WireDDR&=~_BV(WirePin);
			_delay_loop_2(160);   //Задержка примерно на 64 мкс
		}
		else                 //Передача лог.0
		{
			WireDDR|=_BV(WirePin);
			_delay_loop_2(150);  //60 мкс
			WireDDR&=~_BV(WirePin);
			_delay_loop_2(25);  //10 мкс
		}
		data=command;        //Новое значение для сдвига
	};
	sei();
}

//Функция приема битов от DS18B20
void receive_ds1820(void)
{
	cli();
	znak=0;
	for(i=0;i<16;i++)     //Прием 2 байт с температурой и знаком
	{
		WireDDR|=_BV(WirePin);
		_delay_loop_2(15);  //Задержка примерно на 6 мкс
		WireDDR&=~_BV(WirePin);
		_delay_loop_1(30);  //Задержка примерно на 9 мкс
		if (WirePIN & (1<<WirePinN)) //Проверка состояния вывода
		{
			grand_temperature|=_BV(i);      //Запись лог. 1
			if(i==12)
			{
				znak=1;
			}
		}
		else
		{
			grand_temperature&=~_BV(i);    //Запись лог. 0
		}
		_delay_loop_2(138);
	}
	//Обработка результатов
	if(znak==1)  //Отритцательная температура
	{
		grand_temperature=65536-grand_temperature;
	}

	des_temperature=grand_temperature&0b00001111;
	temperature=(grand_temperature>>4);
	sei();
}

//Функция формирования числа десятых t
unsigned char create_des(void)
{
	unsigned char des_var=0;
	if(des_temperature==0){des_var=0;}
	else if(des_temperature==1 || des_temperature==2){des_var=1;}
	else if(des_temperature==3){des_var=2;}
	else if(des_temperature==4 || des_temperature==5){des_var=3;}
	else if(des_temperature==6 || des_temperature==7){des_var=4;}
	else if(des_temperature==8){des_var=5;}
	else if(des_temperature==9 || des_temperature==10){des_var=6;}
	else if(des_temperature==11){des_var=7;}
	else if(des_temperature==12 || des_temperature==13){des_var=8;}
	else if(des_temperature==14 || des_temperature==15){des_var=9;}
	return des_var;
}

//Функция считывания кода датчика
void search_ds1820_ROM(void)
{
	reset_ds1820();             //Сброс датчика
	send_ds1820_command(0xF0);  //Команда поиск ПЗУ
	was_conflict=0;   //Сброс признака наличия конфликта
	unsigned char bit_analizer=0; //Переменная анализа принятых битов
	_delay_loop_2(250);
	cli();
	for(j=0;j<8;j++) {      //Процедура получения номера датчика
		for(i=0;i<8;i++)
		{                      //Запрос на передачу бита
			WireDDR|=_BV(WirePin);
			_delay_loop_2(15);  //Задержка примерно на 6 мкс
			WireDDR&=~_BV(WirePin);
			_delay_loop_1(30);  //Задержка примерно на 9 мкс

			if (WirePin & (1<<WirePinN)) //Прием бита кода датчика
			{
				bit_analizer|=_BV(0);      //Запись лог. 1
			}
			else
			{
				bit_analizer&=~_BV(0);    //Запись лог. 0
			}
			_delay_loop_2(138);
			//Запрос на передачу инверсного бита
			WireDDR|=_BV(WirePin);
			_delay_loop_2(15);  //Задержка примерно на 6 мкс
			WireDDR&=~_BV(WirePin);
			_delay_loop_1(30);  //Задержка примерно на 9 мкс
			if (WirePin & (1<<WirePinN)) //Прием инверсного бита кода датчика
			{
				bit_analizer|=_BV(1);      //Запись лог. 1
			}
			else
			{
				bit_analizer&=~_BV(1);    //Запись лог. 0
			}
			_delay_loop_2(138);
			//Анализ принятых битов кода(прямого и инверсного)
			switch(bit_analizer)
			{
				case 0: //Произошел конфликт битов
				was_conflict=1;
				if(get_for_two==false) //Если для 1-го получаем
				//по лог. 0
				{
					ROM1[j]&=~_BV(i);
					//Выдача лог. 0 на линию
					WireDDR|=_BV(WirePin);
					_delay_loop_2(150); //60 мкс
					WireDDR&=~_BV(WirePin);
					_delay_loop_2(25);  //10 мкс
				}
				else //Если для 2-го получаем по лог. 1
				{
					ROM2[j]|=_BV(i);
					//Выдача лог.1 на линию
					WireDDR|=_BV(WirePin);
					_delay_loop_2(15);   //Задержка примерно на 6 мкс
					WireDDR&=~_BV(WirePin);
					_delay_loop_2(160);  //Задержка примерно на 64 мкс
				}
				break;
				case 1: if(get_for_two==false) //Прием лог.1
				{
					ROM1[j]|=_BV(i);
				}
				else
				{
					ROM2[j]|=_BV(i);
				}
				//Выдача лог. 1 на линию
				WireDDR|=_BV(WirePin);
				_delay_loop_2(15);   //Задержка примерно на 6 мкс
				WireDDR&=~_BV(WirePin);
				_delay_loop_2(160);   //Задержка примерно на 64 мкс
				break;
				case 2: if(get_for_two==false)//Прием лог. 0
				{
					ROM1[j]&=~_BV(i);
				}
				else
				{
					ROM2[j]&=~_BV(i);
				}
				//Выдача лог.0 на линию
				WireDDR|=_BV(WirePin);
				_delay_loop_2(150);  //60 мкс
				WireDDR&=~_BV(WirePin);
				_delay_loop_2(25);  //10 мкс
				break;
				case 3:break;
			};
		}
	}
	if(get_for_two==false && was_conflict==1)
	{
		get_for_two=true;
	}
	else
	{
		get_for_two=false;
	}
	sei();
}

//Функция передачи ROM кода датчику
void send_ROM_ds1820(unsigned char selector)
{
	for(j=0;j<8;j++)
	{
		//Если не было конфликтов на шине=>один датчик
		if(selector==0 || (selector==1 && was_conflict==0))
		{
			send_ds1820_command(ROM1[j]);
		}
		else if(selector==1)
		{
			send_ds1820_command(ROM2[j]);
		}
	};
}
int main(void)
{
	//DDRB=0xFF;
	WireDDR=0x00;           // Шина изначально свободна
	//PORTD=0x20;
	TIMSK=0x80;
	SREG=0x80;
	TCNT1=0x48E5;
	sei();
	//ini_LCD();
	TCCR1B=0x04;
	while(1)
	{
		search_ds1820_ROM(); //получение кода для 1-го
		search_ds1820_ROM(); //получение кода для 2-го
		//Получение от датчиков значений температуры
		/*
		if(PIND & (1<<PIND5))
		{
			z=0;
		}
		else
		{
			z=1;
		}
		*/
		z=0;
		reset_ds1820();
		send_ds1820_command(0x55);  //Адресация ROM
		send_ROM_ds1820(z);
		send_ds1820_command(0x44);  //Команда измерения t

		for(j=0;j<80;j++)          //Временная пауза 800 мс
		{
			_delay_loop_2(25000);
		}
		reset_ds1820();
		send_ds1820_command(0x55);  //Адресация ROM
		send_ROM_ds1820(z);
		send_ds1820_command(0xBE);
		receive_ds1820();
	}
};
