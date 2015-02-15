/*
 * i2c slave basic operation
 * only interrupt way
 * Slave.h
 *
 * Created: 02.02.2015 13:42:16
 *  Author: kartsev
 */ 
#ifndef F_CPU
#warning F_CPU defined @ 1MHz by i2c slave lib

#define F_CPU 1000000UL


#endif
#define DEBUG_LEDS
#ifdef DEBUG_LEDS

#define LED1 0
#define LED2 1
#define LED3 2
#define LED4 3
#define LED_PORT PORTB
#define LED_DDR DDRB
#define SetLed1 LED_PORT|= 1<<LED1; //set 
#define SetLed2 LED_PORT|= 1<<LED2; //set 
#define SetLed3 LED_PORT|= 1<<LED3; //set 
#define SetLed4 LED_PORT|= 1<<LED4; //set 
#define ClearLed1 LED_PORT&= ~(1<<LED1);//clear
#define ClearLed2 LED_PORT&= ~(1<<LED2);//clear
#define ClearLed3 LED_PORT&= ~(1<<LED3);//clear
#define ClearLed4 LED_PORT&= ~(1<<LED4);//clear
#define SwitchLed1 LED_PORT = LED_PORT ^ (1<<LED1); //switch
#define SwitchLed2 LED_PORT = LED_PORT ^ (1<<LED2); //switch
#define SwitchLed3 LED_PORT = LED_PORT ^ (1<<LED3); //switch
#define SwitchLed4 LED_PORT = LED_PORT ^ (1<<LED4); //switch

#endif

/*
//ACK nach empfangenen Daten senden/ ACK nach gesendeten Daten erwarten
#define TWCR_ACK TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|(0<<TWWC);

//NACK nach empfangenen Daten senden/ NACK nach gesendeten Daten erwarten
#define TWCR_NACK TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|(0<<TWWC);

//switch to the non adressed slave mode...
#define TWCR_RESET TWCR = (1<<TWEN)|(1<<TWIE)|(1<<TWINT)|(1<<TWEA)|(0<<TWSTA)|(1<<TWSTO)|(0<<TWWC);
*/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/twi.h>

#define i2c_MasterAddress 	0x46	// ����� �� ������� ����� ����������
#define i2c_i_am_slave		1	// ���� �� ��� � ������� �������� �� 1. � �� �� �������!
#define twi_port PORTC
#define twi_ddr DDRC
#define SDA_pin 4
#define SCL_pin 5
#define i2cBuffSize 4

#define TWI_SUCCESS 0xFF
#define TWI_ERR 0xAA
#define TWI_ADR_BITS     1       // ������� ������ � �������� ������
#define TRUE             1
#define FALSE            0
#define TWI_Read 
#define TWI_Wright

char i2c_Buffer[i2cBuffSize];//TX buffer
uint8_t i2c_ByteCount;				// ����� ���� ������������
uint8_t i2c_Index = 0; //��������� ���������� ��� �������
char I2c_DEbug = 0, I2c_DEbug1 = 0, I2c_DEbug2 = 0;

//������ ������
volatile static uint8_t twiState = TW_NO_INFO;

ISR(TWI_vect)
{
	
//����� ��������� ��� ������
uint8_t TWIstatus = TWSR & 0xF8;
//������������ ���
switch (TWIstatus)
{
	/*������ ���� ��� ������*/
	case TW_ST_SLA_ACK: //0xA8 SLA+R received, ACK returned  ��� ����� �� ������ ������ �� ����� ���������� � ������� ��� �������� ��������.
			 //and load first data
			 
			SetLed1
			i2c_Index = 0;
				i2c_Buffer[0] = 0xAA;
				i2c_Buffer[1] = 0x55;
				i2c_Buffer[2] = 0xFF;
				i2c_Buffer[3] = 0x00;
				TWDR = i2c_Buffer[i2c_Index++];
				TWCR|= (0<<TWINT)|(1<<TWEA)|(1<<TWEN)|(1<<TWIE);
				break;
	case TW_ST_DATA_ACK: //Send Byte Receive ACK �� ���� �� ��� ����. �� ��� ACK. � �� ��� �������� ������ ����� ��� ��� ���� (���������) � �������� ���� NACK�. ��� �� � ��� ������ �� � ����� ��� ����������.	
			SetLed2
			if (i2c_Index < i2cBuffSize)
			{
			TWDR = i2c_Buffer[i2c_Index++];
			TWCR|= (0<<TWINT)|(1<<TWEA)|(1<<TWEN)|(1<<TWIE);
			//LED_PORT|= 1<<LED4; //�� ������
			}
			else 
			{
				TWCR|= (0<<TWINT);
				i2c_Index =0;
			}
			break;
	case TW_ST_DATA_NACK: //������ ���� - ��� ������ ��� �� ���������, ���� ����� ��� ���������.
			//SetLed3
			
			{
				i2c_Index =0;
			}
	case TW_ST_LAST_DATA:
			//SetLed4
			TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA);
			i2c_Index = 0;
			break;
	
	/*case TW_SR_SLA_ACK: //0x60 Receive SLA+W ����� �� ����, ������ �� �������, �� � ��� �� ��������. � ��� ��� �� ����� ������� ��������� :)

	//TWDR = OutPort;
	//TWDR = i2c_Buffer[0];
	TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWEA);
	break;
	*/
	/*����� ��������� �� �������*/
	case TW_MT_SLA_NACK:
	case TW_MR_SLA_NACK:
	case TW_MT_DATA_NACK:
	
	case TW_BUS_ERROR:
		//��������� ��������� ���
		twiState = TWIstatus;
		//��������� ���������� ������
		TWCR = (1<<TWEN)|(0<<TWIE);
		break;
	default:
			//��������� ��������� ���
			twiState = TWIstatus;

	}
}

void Init_Slave_i2c(void)				// ��������� ������ ������ (���� �����)
{
	//LED_PORT|= 1<<LED3; //set
	TWAR = i2c_MasterAddress;					// ������ � ������� ���� �����, �� ������� ����� ����������.
	// 1 � ������� ���� ��������, ��� �� ���������� �� ����������������� ������
	//SlaveOutFunc = Addr;						// �������� ��������� ������ �� ������ ������� ������
	// TWCR = (1<<TWEN)|(1<<TWEA)|(1<<TWIE);
	TWBR=32;// Bit Rate: 100,000 kHz @8MHz
	
	TWCR = 	0<<TWSTA|
			0<<TWSTO|
			0<<TWINT|
			1<<TWEA|
			1<<TWEN|
			1<<TWIE;							// �������� ������� � �������� ������� ����.

}

#ifdef DEBUG_LEDS
void (Init_Debug_Led)(void)
{
	LED_DDR|= (1<<LED1)|(1<<LED2)|(1<<LED3)|(1<<LED4);     //Led port
	LED_PORT&= ~(1<<LED1)|(1<<LED2)|(1<<LED3)|(1<<LED4); //Led port

}
#endif


