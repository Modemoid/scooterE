/*
 * CheapController.c
 *
 * Created: 18.03.2015 15:19:55
 *  Author: kartsev
 */ 

#define name CheapController
#define DEBUG
#define ADCdip
#define ADCbuttons

#define F_CPU 8000000UL

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

int State = 1;
char AdcCh;
char dipsate = 128;
char adcdata = 0;

ISR(ADC_vect) //buttons
{
adcdata = ADCL;
adcdata = ADCH;

if (AdcCh == 6 && adcdata != 128)
{
	adcdata = dipsate;
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3);
	ADCSRA = (1<<ADEN|1<<ADSC|1<<ADFR|1<<ADIE|1<<ADPS0|1<<ADPS1|1<<ADPS2);
	AdcCh = 7;
}

}

int main(void)
{
	State = 5;
#ifdef ADCdip

	//adc setup
	ADMUX = (0<<REFS0|0<<REFS1|1<<ADLAR|0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3); //ch 6
	//1<<REFS0|1<<REFS1 = от внутренних 2.5в,
	//0<<REFS0|0<<REFS1 = AREF
	//adlar = 1 младший байт (ADCL) не нужен - там мусор, брать только ADCH
	//mux0-mux3 выбирать какой ацп 0-0<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3 1-1<<MUX0|0<<MUX1|0<<MUX2|0<<MUX3
	//0<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC6
	//1<<MUX0|1<<MUX1|1<<MUX2|0<<MUX3 = ADC7
	ADCSRA = (1<<ADEN|1<<ADSC|1<<ADFR|1<<ADIE|1<<ADPS0|1<<ADPS1|1<<ADPS2);
	AdcCh = 6;

	
#endif

sei();
    while(1)
    {
		
		/*
		if (30>adcdata && adcdata>5 )
		{
			dipsate=1;
		}

		if (100>adcdata && adcdata>60)
		{
			dipsate=2;
		}
		if (150>adcdata && adcdata>100)
		{
			dipsate=3;
		}
		if (150<adcdata)
		{
			dipsate=4;
		}
		*/
		
       State = 8;
	    //TODO:: Please write your application code 
    }
}