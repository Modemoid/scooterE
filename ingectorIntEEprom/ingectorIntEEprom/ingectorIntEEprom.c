/*
 * ingectorIntEEprom.c
 *
 * Created: 26.01.2016 21:12:49
 *  Author: kartsev
 */ 
#define F_CPU 1000000


#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include <util/delay.h>

#define def_ArrSize 250
uint8_t TimeArray[def_ArrSize];



/*
ISR( TIMER2_OVF_vect )
{
	//остановить таймер, выставить флаг "мало оборотов"
	
}
ISR( INT0_vect )
{	
	//если стоит мало оборотов бернуть процедуру "стартовая порция", сбросить "мало оборотов" 
	//записать значение кюррент в ОЛД
	//записать текущее значение таймера2 в кюррент
	
	//посчитать через сколько начать брызгать
	//проверить корректность "брызга"
	//запустить таймер 1 на "брызг" (комперА и комперБ)

}
*/


int main(void)
{
eeprom_to_mem();// 
	
	//eeprom_write_byte ((uint8_t*) 23, 64); //  write the byte 64 to location 23 of the EEPROM
	//uint8_t byteRead = eeprom_read_byte((uint8_t*)23); // read the byte in location 23
    
	while(1)
    {
        //TODO:: Please write your application code 
    }
}

void eeprom_to_mem(void)
{
	uint8_t LocalCounter = 0;
	for (LocalCounter = 0;LocalCounter<def_ArrSize;LocalCounter++)
	{
		//eeprom_write_byte ((uint8_t*) LocalCounter, LocalCounter);
		TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
	}
}