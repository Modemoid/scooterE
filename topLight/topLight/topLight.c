/*
 * topLight.c
 *
 * Created: 04.02.2016 7:57:07
 *  Author: kartsev
 */ 

#define F_CPU 9600000 
#include <avr/io.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>

#define EepromSize 63 
char GlobalState = 111;
char WorkState = 111;
char ShowSelector = 111;
char Test = 111;

char SearchState(void)
{
	uint16_t LocalCounter;
	char SearchStateTemp = 0;
	char FirstNonFF = 70;
	for(LocalCounter = EepromSize;LocalCounter>0;LocalCounter--)
	{
		SearchStateTemp = eeprom_read_byte((uint8_t*)LocalCounter);
		
		if (SearchStateTemp != 0xff)
		{
			FirstNonFF = LocalCounter;
		}
	}
	if (FirstNonFF == 70)
	{
			ClearEEprom();
		return 0;
	}else
		{
		 return FirstNonFF;	
		}
		
			
}
void eeprom_to_mem(void)
{
	uint16_t LocalCounter = 0;
	for (LocalCounter = 0; LocalCounter < EepromSize; LocalCounter++)
	{
		//eeprom_write_byte ((uint8_t*) LocalCounter, LocalCounter);
		//Array[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
	}
	//TimeArray[def_ArrSize] = 0;
}
void ClearEEprom(void)
{
	uint16_t LocalCounter = 0;
	for (LocalCounter = 0; LocalCounter < EepromSize; LocalCounter++)
	{
		eeprom_write_byte ((uint8_t*)LocalCounter, 0);
		//TimeArray[LocalCounter] = eeprom_read_byte((uint8_t*)LocalCounter); // read the byte in location 23
	}
}

int main(void)
{
	GlobalState = SearchState();
	WorkState = eeprom_read_byte((uint8_t*)GlobalState); // read the byte in location
	ShowSelector = WorkState%3;
	
	WorkState++;
	if (WorkState<255){
	eeprom_write_byte ((uint8_t*)GlobalState, WorkState);
	}else {
	eeprom_write_byte ((uint8_t*)GlobalState, 255)	;
	eeprom_write_byte ((uint8_t*)GlobalState+1, 0);
	}
	
    while(1)
    {
        //TODO:: Please write your application code 
    }
}