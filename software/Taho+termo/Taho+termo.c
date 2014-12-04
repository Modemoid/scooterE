/*
 * Taho_termo.c
 *
 * Created: 03.12.2014 22:17:22
 *  Author: kartsev
 */ 


#define F_CPU 1000000UL
#include <avr/io.h>
#include <avr/iom8.h>
#include "interrupt.h"
#include "delay.h"

#define DEBUG_UART
#define taho
#define thermometer_RES
//#define thermometer_1wire
//#define thermometer_i2c


int main(void)
{
	//setup section
			#ifdef thermometer_RES
			//put ADC setup here
			#endif
	//end of setup section
    while(1)
    {
		
		#ifdef taho
		
		#endif 
		
		#ifdef thermometer_RES
		
		#endif
		
		#ifdef DEBUG_UART
		
		#endif
        //TODO:: Please write your application code 
    }
}