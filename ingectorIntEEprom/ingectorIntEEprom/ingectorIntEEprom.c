/*
 * ingectorIntEEprom.c
 *
 * Created: 26.01.2016 21:12:49
 *  Author: kartsev
 */ 

#define F_CPU 8000000 //8 ���

#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
//#include <util/delay.h>


#define Timer2IntON TIMSK|= (1<<OCIE2|1<<TOIE2);//set bits
#define Timer2IntOFF TIMSK&= ~(1<<OCIE2|1<<TOIE2);//clear bits


TODO:�������� ��������� �����
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
	//�������� ������2 �� �����1, �� ���������� � 200 ����� ������ ������� ����� ����� 10^-5 = 25 �����������


	// LED_PORT|= 1<<LED4; //set
	// LED_PORT&= ~(1<<LED1);//clear
	// LED_PORT = LED_PORT ^ (1<<LED1); //switch
	
	OCR2 = 199; //����� 200 �����, ���� � 0

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
	//������ �������� �� ���� ����������
	Timer2IntON
	Timer2IntOFF

}


ISR( INT0_vect )
{	
	
	TODO: ��������� ������ �� � ��� ���������� �����. 
	TODO: ��������� �������� �� �������� "���������� ������ ������" � ����������� �� ���� ��� � ��� � ���(�� ������ �������� ������-�����) + ������������ (��������-��������) 
	
	/*
	//���� ����� ���� �������� ������� ��������� "��������� ������", �������� "���� ��������" 
	//�������� �������� ������� � ���
	//�������� ������� �������� �������2 � �������
	
	//��������� ����� ������� ������ ��������
	//��������� ������������ "������"
	//��������� ������ 1 �� "�����" (������� � �������)
	*/
}


ISR( TIMER2_OVF_vect )
{
	SoftBugON
	//������ TODO: ���������� �������� ���� � ������� �� ������! 
	
}

ISR(TIMER2_COMP_vect)
{
	TODO: ��������� �������� "���������� ������ ������"
	//��� �� ������ ������� "����� �������" 
	//������������ ����� � �������� �����. ?
}



int main(void)
{
eeprom_to_mem();//load data arrays into memory
Timer2Setup(); //setup timer2 //������� ������� �� 25 �����������
	
	//eeprom_write_byte ((uint8_t*) 23, 64); //  write the byte 64 to location 23 of the EEPROM
	//uint8_t byteRead = eeprom_read_byte((uint8_t*)23); // read the byte in location 23
    
	while(1)
    {
		TODO: ������� ��������� � ����������� �� ���� ��� � ��� � "���������� �������� ������"
        //TODO:: Please write your application code 
    }
}

