/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 18.01.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <delay.h>


#include "MSCS_lib.h"

// Alphanumeric LCD Module functions
#include <alcd.h>

#define FIRST_ADC_INPUT 7
unsigned int adc_data;
#define ADC_VREF_TYPE 0x40//0xC0

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;

ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff));
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
}

// Declare your global variables here
unsigned char Vol;
unsigned int NewState=0,OldState=0,upState=0,downState=0;

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
TCNT1=0;
PORTB.2=0;
}

// Timer1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here
OCR1A=TCNT1+4;
PORTB.2=1;
}


unsigned char encoder(unsigned char val){
          NewState=PINB & 0b00000011;
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
        val--;
        upState = 0;
      }
      if (downState >= 4) 
      {                              
        val++;
        downState = 0;
      }
 return val;
}

void MSCS_com_veryfy(unsigned char *data,unsigned char ret[17]){
MSCS_com(data,ret);
while(!((ret[12]=='g')&&(ret[13]=='e')&&(ret[14]=='r')&&(ret[15]=='b'))){
MSCS_com(data,ret);
}
}

void main(void)
{
// Declare your local variables here
unsigned char buf[32],buf1[17],buf2[17];
float ft;
unsigned char m1,m2=0,m3=0,m4=0; //m1-galet switcher m2 - timer for read to Vol - 1-6 m3 - port POWER m4 - pulsegen

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=P State0=P 
PORTB=0x03;
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);


// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=P State4=P State3=P State2=P State1=P State0=P 
PORTC=0x3F;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: Int., cap. on AREF
ADMUX=0;
ADCSRA=0;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTD Bit 1
// EN - PORTD Bit 2
// D4 - PORTD Bit 3
// D5 - PORTD Bit 4
// D6 - PORTD Bit 5
// D7 - PORTD Bit 6
// Characters/line: 8
lcd_init(16);
MSCS_init();
delay_ms(10);

 lcd_puts("Start!");
// delay_ms(2000);
// Global enable interrupts
#asm("sei")

while (1)
      {


      
      m1=PINC;       
      
      m1=0x0C;
      //delay_ms (100);
      // */
sprintf(buf,"");
switch (m1&0b1111)
{
    case 0xC:   
    MSCS_com_veryfy("                ",buf1);     
    sprintf(buf,"h-%2um-%2u        s-%2u",buf1[9],buf1[10],buf1[11]);      
    break;
    case 0x4:   
    m2=encoder(m2);
    if (m2>=250) m2=0;
    if (m2>7) m2=7;
    sprintf(buf,"SelTimer        Timer%u",m2+1);
    break;
    case 0x0:        
    if (!((m1&0b100000)&&0b100000)){ 
    MSCS_com_veryfy("                ",buf1);
    Vol=buf1[m2];
    } 
    Vol=encoder(Vol);
    sprintf(buf,"TimerNo%u        time=%u",m2+1,Vol);    

    break;
    
    case 0x8:                           
    sprintf(buf,"WriteNo%u        toMemory",m2+1);
    if (!((m1&0b100000)&&0b100000)){ 
     buf2[0]='w';
     buf2[1]='r';
     buf2[2]='i';
     buf2[3]='t';
     buf2[4]='e';
     buf2[5]='t';
     buf2[6]=m2;
     buf2[7]=Vol;
     MSCS_com_veryfy(buf2,buf1);
     sprintf(buf,"WriteNo%u        Ok",m2+1);
    }        
    break;         
    
    
    case 0xA:
    sprintf(buf,"Enable          testMode");
    if (!((m1&0b100000)&&0b100000)){ 
     buf2[0]='w';
     buf2[1]='r';
     buf2[2]='i';
     buf2[3]='t';
     buf2[4]='e';
     buf2[5]='e';
     MSCS_com_veryfy(buf2,buf1);
     sprintf(buf,"Enable        Tmode Ok");
    }        
    break;
    case 0x2:
    m3=encoder(m3);
    if (m3>=250) m3=0;
    if (m3>3) m3=3;
    sprintf(buf,"PORT No%u        Switch",m3+1);
     if (!((m1&0b100000)&&0b100000)){ 
     buf2[0]='w';
     buf2[1]='r';
     buf2[2]='i';
     buf2[3]='t';
     buf2[4]='e';
     buf2[5]='s';  
     buf2[6]=m3;  
     MSCS_com_veryfy(buf2,buf1);
     sprintf(buf,"PORT       SwitchOk");
    }        
    break;
    case 0x6:
    sprintf(buf,"Menu 7 ");    
    break;
    case 0xE:
    sprintf(buf,"Menu 8 ");    
    break;
    case 0xF:
    sprintf(buf,"Menu 9 ");    
    break;
    case 0xD:
    sprintf(buf,"Menu 10");    
    break;
    case 0x5:
    sprintf(buf,"Menu 11");    
    break;
    case 0x1:
    sprintf(buf,"Menu 12");    
    break;
    case 0x9:
    sprintf(buf,"Menu 13");    
    break;
    case 0xB:  
    if (!((m1&0b100000)&&0b100000)){ 
    if (!m4){
    Vol=1;
    m4=1;             
   // TCCR1A|=(1<<COM1B0);
    TCCR1B|=(1<<CS12)|(1<<CS10);
    OCR1A=15629;
    OCR1B=15625;
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK|=(1<<OCIE1A) | (1<<OCIE1B);
    } else {
    m4=0;             
    TCCR1A&=~(1<<COM1B0);
    TCCR1B&=~((1<<CS12)|(1<<CS10));
    TIMSK&=~((1<<OCIE1A) | (1<<OCIE1B));
    }          
}    
    Vol=encoder(Vol);
    OCR1B=15625/Vol;
    if (m4)    sprintf(buf,"PulseGen        ON%4uOB",Vol*60);
    else sprintf(buf,"PulseGen        OFF     ");     
    break;
    case 0x3:
    sprintf(buf,"Restart        clock");
    if (!((m1&0b100000)&&0b100000)){ 
     buf2[0]='w';
     buf2[1]='r';
     buf2[2]='i';
     buf2[3]='t';
     buf2[4]='e';
     buf2[5]='c';
     MSCS_com_veryfy(buf2,buf1);
     sprintf(buf,"Restart        clock-Ok");    
     }
    break;
    case 0x7: 
    // ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: Int., cap. on AREF
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCC;                                   
    ft=0.005*adc_data;
    sprintf(buf,"Voltmetr        %1.3fVol",ft);    
    break;
    default:
    sprintf(buf,"Pressed button   %X",PINC);
}
      lcd_clear();
      lcd_gotoxy(0,0);
      lcd_puts(buf);
      }
}
    // */
    