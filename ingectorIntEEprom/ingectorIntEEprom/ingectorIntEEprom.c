/*
 * ingectorIntEEprom.c
 *
 * Created: 26.01.2016 21:12:49
 *  Author: kartsev
 */ 

#define F_CPU 8000000 //8 мгц

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
//#include <util/delay.h>


#define Timer2IntON TIMSK|= (1<<OCIE2|1<<TOIE2);//set bits
#define Timer2IntOFF TIMSK&= ~(1<<OCIE2|1<<TOIE2);//clear bits


TODO:написать зажигание диода
#define SoftBugON TIMSK|= (1<<OCIE2|1<<TOIE2);//set bits 

#define def_ArrSize 250
uint8_t TimeArray[def_ArrSize];
unsigned int CurrentTimer, OldTimer;

unsigned char Coffs[5]; //0 - open time, 1 - close time, 2 - min drocel position, 3 - max drocel position 




void eeprom_to_mem(void)
{
	uint16_t LocalCounter = 0;
	for (LocalCounter = 0;LocalCounter<def_ArrSize;LocalCounter++)
	{
		//eeprom_write_byte ((uint8_t*) LocalCounter, LocalCounter);
		TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
	}
}
void mem_to_eeprom(void)
{
	uint16_t LocalCounter = 0;
	for (LocalCounter = 0;LocalCounter<def_ArrSize;LocalCounter++)
	{
		eeprom_write_byte ((uint8_t*)LocalCounter, TimeArray[LocalCounter]);
		//TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
	}
}
void Timer2Setup(void)
{
	//запустит таймер2 на клоке1, по совпадению с 200 тогда период таймера будет равен 10^-5 = 25 микросекунд


	// LED_PORT|= 1<<LED4; //set
	// LED_PORT&= ~(1<<LED1);//clear
	// LED_PORT = LED_PORT ^ (1<<LED1); //switch
	
	OCR2 = 199; //нужно 200 тиков, счет с 0

	TCCR2|= (0<<FOC2|0<<WGM20|0<<COM21|0<<COM20|1<<WGM21|0<<CS22|0<<CS21|1<<CS20);
	/*
	//FOC2 = 0
	//WGM20 = 0 + WGM21 =1 |CTC mode
	//COM21 = 0  \
	//COM20  = 0 | port disconnected
	//WGM21 = 1
	//CS22 =0
	//CS21 =0
	//CS20=1 //CPU clock
*/
	//теперь разрешим от него прерывания
	Timer2IntON
	Timer2IntOFF

}


ISR( INT0_vect )
{	
	
	TODO: проверить пустое ли у нас оставшееся время. 
	TODO: загрузить значение из таблички "оставшиеся времея потока" в зависимости от того что у нас с АЦП(не забыть поправки начала-конца) + коэффициенты (открытие-закрытие) 
	
	/*
	//если стоит мало оборотов дернуть процедуру "стартовая порция", сбросить "мало оборотов" 
	//записать значение кюррент в ОЛД
	//записать текущее значение таймера2 в кюррент
	
	//посчитать через сколько начать брызгать
	//проверить корректность "брызга"
	//запустить таймер 1 на "брызг" (комперА и комперБ)
	*/
}


ISR( TIMER2_OVF_vect )
{
	SoftBugON
	//готово TODO: обработать эксепшен сюды я попасть не должен! 
	
}

ISR(TIMER2_COMP_vect)
{
	TODO: декримент значения "оставшиеся времея потока"
	//тут мы должны вертеть "время впрыска" 
	//обрабатывать нужно в основном цикле. ?
}



int main(void)
{
eeprom_to_mem();//load data arrays into memory
Timer2Setup(); //setup timer2 //считает отрезки по 25 микросекунд
	
	//eeprom_write_byte ((uint8_t*) 23, 64); //  write the byte 64 to location 23 of the EEPROM
	//uint8_t byteRead = eeprom_read_byte((uint8_t*)23); // read the byte in location 23
    
	while(1)
    {
		TODO: дрыгать форсункой в зависимости от того что у нас с "оставшимся временем потока"
        //TODO:: Please write your application code 
    }
}

