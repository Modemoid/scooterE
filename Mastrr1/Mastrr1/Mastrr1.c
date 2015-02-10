/*
 * Mastrr1.c
 *
 * Created: 03.02.2015 13:41:30
 *  Author: kartsev
 */ 

#define F_CPU 1000000UL

#define LED1 0
#define LED2 1
#define LED3 2
#define LED4 3
#define LED_PORT PORTB
#define LED_DDR DDRB
#define OutPort PORTD

#define SetLed1 LED_PORT|= 1<<LED1; //set на чтение
#define SetLed2 LED_PORT|= 1<<LED2; //set на чтение
#define SetLed3 LED_PORT|= 1<<LED3; //set на чтение
#define SetLed4 LED_PORT|= 1<<LED4; //set на чтение
#define ClearLed1 LED_PORT&= ~(1<<LED1);//clear
#define ClearLed2 LED_PORT&= ~(1<<LED2);//clear
#define ClearLed3 LED_PORT&= ~(1<<LED3);//clear
#define ClearLed4 LED_PORT&= ~(1<<LED4);//clear

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <util/twi.h>

#define i2c_Comm_master
#ifdef i2c_Comm_master

#define i2c_SendStart()		(TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN)|(1<<TWIE)) // Send the START signal, enable interrupts and TWI, clear TWINT flag to resume transfer.
#define i2c_SendStop()		(TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN)|(1<<TWIE)) // Send the STOP signal, enable interrupts and TWI, clear TWINT flag.
#define i2c_SendTransmit()	(TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWIE)) // Used to resume a transfer, clear TWINT and ensure that TWI and interrupts are enabled.
#define i2c_SendACK()		(TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWIE)|(1<<TWEA)) // FOR MR mode. Resume a transfer, ensure that TWI and interrupts are enabled and respond with an ACK if the device is addressed as a slave or after it receives a byte.
#define i2c_SendNACK()		(TWCR = (1<<TWINT)|(1<<TWEN)|(1<<TWIE)) // FOR MR mode. Resume a transfer, ensure that TWI and interrupts are enabled but DO NOT respond with an ACK if the device is addressed as a slave or after it receives a byte.

//#define i2c_MasterAddress 	0x42	// Адрес на который будем отзываться
//#define i2c_i_am_slave		1	// Если мы еще и слейвом работаем то 1. А то не услышит!
#define i2c_port PORTC
#define i2c_ddr DDRC
#define SDA_pin 4
#define SCL_pin 5
#define i2c_BuffSize 4
//#define i2c_MaxPageAddrLgth	2	// Максимальная величина адреса страницы. Обычно адрес страницы это один или два байта.
// Зависит от типа ЕЕПРОМ или другой микросхемы.
#define i2c_SUCCESS 0xFF
//#define i2c_ERR 0xAA
#define i2c_ADR_BITS     1       // позиция адреса в адресном пакете
#define TRUE             1
#define FALSE            0
#define i2c_AddR |=0x01					// Шлем Addr+R
#define i2c_AddW &=0xFE					// Шлем Addr+W
#define i2c_write 0x01
#define i2c_read 0x00

char i2c_BufferTX[i2c_BuffSize];   //TX buffer
char i2c_BufferRX[i2c_BuffSize];   //RX buffer
char main_i2c_array[i2c_BuffSize]; //array for use into main
char i2c_ByteCount;				// Число байт
char i2c_Index = 0; //индексная переменная для массива
char i2c_msgSize = 0; //размер i2c сообщения
char i2c_Active_Save; //
char i2c_direction;
char I2c_DEbug = 0, I2c_DEbug1 = 0, I2c_DEbug2 = 0;

void i2c_init_master(void)
{
	
	i2c_port |= 1<<SCL_pin|1<<SDA_pin;			// Включим подтяжку на ноги, вдруг юзер на резисторы пожмотился
	i2c_ddr &=~(1<<SCL_pin|1<<SDA_pin);
	TWBR = 160;         						// Настроим битрейт ~7kHz
	TWSR = 0x01;
}
void i2c_TX(char *msg, char msgSize)
{
	  i2c_msgSize = msgSize;
	  while(TWCR & (1<<TWIE)); //ждем ,когда TWI модуль освободится
	  
	   i2c_BufferTX[0] = msg[0]; //и первый байт сообщения
	   
// 	    if (!(msg[0] & (0b00000001))){ //если мы планируем дальше записывать (SLA+W) то копируем сообщение в буфер полностью. 
// 		    for (LocalCounter = 1; LocalCounter < msgSize; LocalCounter++){
// 			      i2c_BufferTX[LocalCounter] = msg[LocalCounter];
// 		      }
// 	     }
	//разрешаем прерывание и формируем состояние старт
   i2c_SendStart();
}
char i2c_Rx(char *msg, char msgSize)
{
	char LocalCounterRx, LocalRecived;
	i2c_msgSize = msgSize;
	while(TWCR & (1<<TWIE)); //ждем ,когда TWI модуль освободится

		for(LocalCounterRx = 0; LocalCounterRx < msgSize; LocalCounterRx++)
		{  //то переписываем его из внутреннего буфера в переданный
			msg[LocalCounterRx] = i2c_BufferRX[LocalCounterRx];
			LocalRecived = LocalCounterRx;
		}
		return LocalRecived;
}
//буфер для сообщения
//char a;
//volatile static char i2cBuf[i2c_BuffSize];

//сколько байт нужно передать
//volatile static char i2c_MsgSize;

//статус модуля
//volatile static char i2c_State = TW_NO_INFO;

#endif
ISR(TWI_vect)
{
	switch(TWSR & 0xF8)				// Отсекаем биты прескалера
	{
		case TW_BUS_ERROR:				// Bus Fail 
		{
			
			break;
		}
		case TW_START:	// Старт был, а затем мы:
		case TW_REP_START:	// Повторный старт был, а затем мы:
			{
				if (i2c_direction == i2c_write)
				{
					TWDR = i2c_Active_Save i2c_AddW ;					// Шлем Addr+W
				}else
				{
					TWDR = i2c_Active_Save i2c_AddR ;					// Шлем Addr+W
				}
				
				/*		TWDR = i2c_BufferTX[0];				// Адрес слейва*/
				TWCR = 	0<<TWSTA|
				0<<TWSTO|
				1<<TWINT|
				1<<TWEN|
				1<<TWIE;  								// Go!

				break;
			}
// Master Transmitter Mode
	
	case TW_MT_SLA_ACK:  // 0x18 // SLA+W sent and ACK received
		{
			break;
		}
	case TW_MT_SLA_NACK: // 0x20 // SLA+W sent and NACK received
		{
			break;
		}
	case TW_MT_DATA_ACK: // 0x28 // DATA sent and ACK received
		{
					i2c_BufferRX[i2c_Index] = TWDR; //сохраняем байт данных
					i2c_Index++;
			break;
		}
	case TW_MT_DATA_NACK: // 0x30 // DATA sent and NACK received
		{
			break;
		}
	// Master Receiver Mode
	case TW_MR_SLA_ACK: // 0x40 // SLA+R sent, ACK received
		{
			if (i2c_Index < i2c_msgSize){ //это последний байт?
			i2c_SendACK();
			SetLed1
			//нет, формируем подтверждение
			}
			else {
			i2c_SendNACK();
			SetLed2
			}
			break;
		}
	case TW_MR_SLA_NACK: // 0x48 // SLA+R sent, NACK received
		{

			break;
		}
	case TW_MR_DATA_ACK: // 0x50 // Data received, ACK returned
		{
			if (i2c_Index < (i2c_msgSize))//это предпоследний байт? //нет, формируем подтверждение
			{ 
				SetLed3
				i2c_SendACK();
			}
			else {
				SetLed4
				i2c_SendNACK();
			}
			break;
		}
	case TW_MR_DATA_NACK: // 0x58 // Data received, NACK returned
		{
			break;
		}
		
		// Miscellaneous States
	case TW_MT_ARB_LOST:			// 0x38 // Arbitration has been lost
	//case TW_MR_ARB_LOST:			// 0x38 // Arbitration has been lost

	case TW_NO_INFO:				// 0xF8 // No relevant information available
	
	// TWI_SUCCESS				0xFF // Successful transfer, this state is impossible from TWSR as bit2 is 0 and read only
	break;
	}

}			
#define TestLed
int main(void)
{
	#ifdef TestLed
			//настройка портов
			LED_DDR|= 1<<LED1|1<<LED2|1<<LED3|1<<LED4;     //Led port
			LED_PORT&= ~(1<<LED1)|1<<LED2|1<<LED3|1<<LED4; //Led port
			//конец настройки портов
   #endif
   
 
i2c_init_master();

sei();
i2c_Active_Save = 0x42;
i2c_direction = i2c_read;

i2c_TX(main_i2c_array,2);
//i2c_direction = i2c_read;
i2c_Rx(main_i2c_array,4);

    while(1)
    {
		
        //TODO:: Please write your application code 
    }
}