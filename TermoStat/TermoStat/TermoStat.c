/*
.������: ������� ��������� ��� ���� � ����� ��������� ds18b20
.�����:������� �����
.E-mail:gam-raingers@mail.ru
.����:29.06.2008
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
unsigned char was_conflict=0; //������� ������� ��������� �����
unsigned char temperature=0;  //�������� t � ����� ������
int grand_temperature=0; //�������� t �� ������,���������� �� �������(16 ���)
unsigned char des_temperature=0; //�������� t � ������� �����
unsigned char cifra=0; //��������������� ���������� ��� ��������� t
unsigned char znak=0;  //���� �����������: 0 - "+";1 - "-"
unsigned char precense_ds18b20=0; //������� ����������� �������
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
	if(precense_ds18b20!=0)  //���� ������ �����������
	{
		DEbArr[0] = 'T';
		//���� ��������� ���� ������,�� was_conflict==0 => ����������
		//����������� ������ �������.� ����� ������ ������ ������� k ���
		//y ���������� ������
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
		if(znak==0) //����������� ����� �����������
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
	else                      //���� ������ �� �����������
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
	//������� �������
	PORTB &=~_BV(RS);
	PORTB=command;
	PORTB|= _BV(E);
	_delay_loop_2(100);
	PORTB&=~_BV(E);
	_delay_loop_2(100);
	//������� �������
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
	//������� �������
	PORTB&=0x0F;
	PORTB|=((data & 0xF0) |0x01);
	PORTB|= _BV(E);
	_delay_loop_2(100);
	PORTB&=~_BV(E);
	_delay_loop_2(100);
	//������� �������
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
//������� ��� ������ � DS18B20
//������� ������ DS1820
void reset_ds1820(void)
{
	cli();
	WireDDR|=_BV(WirePin);        // ����� ����� ����������� ��� �����
	_delay_loop_2(1200); //������������� 0 � ���. ����� 480 ���
	WireDDR&=~_BV(WirePin);       //����� ����� ����������� ��� ����
	_delay_loop_2(175);  //�������� ������� ����������� 70 ���
	if(PINB & (1<<PINB0))  //���� 1 - ��� ������� ��������� //todo fix defines
	{
		precense_ds18b20=0;
	}
	else
	{
		precense_ds18b20=1;   //���� ������ ��������� �������
	}
	_delay_loop_2(1025); //410 ���
	sei();
}
//������� ��������� ������

void send_ds1820_command(unsigned char command)
{
	cli();
	unsigned char data=command;
	for(i=0;i<8;i++)
	{
		data=data<<7;        //����� �� i �������� �����
		command=command>>1;  //����� ������������� �����
		if(data==0x80)       //�������� ���.1
		{
			WireDDR|=_BV(WirePin);
			_delay_loop_2(15);   //�������� �������� �� 6 ���
			WireDDR&=~_BV(WirePin);
			_delay_loop_2(160);   //�������� �������� �� 64 ���
		}
		else                 //�������� ���.0
		{
			WireDDR|=_BV(WirePin);
			_delay_loop_2(150);  //60 ���
			WireDDR&=~_BV(WirePin);
			_delay_loop_2(25);  //10 ���
		}
		data=command;        //����� �������� ��� ������
	};
	sei();
}

//������� ������ ����� �� DS18B20
void receive_ds1820(void)
{
	cli();
	znak=0;
	for(i=0;i<16;i++)     //����� 2 ���� � ������������ � ������
	{
		WireDDR|=_BV(WirePin);
		_delay_loop_2(15);  //�������� �������� �� 6 ���
		WireDDR&=~_BV(WirePin);
		_delay_loop_1(30);  //�������� �������� �� 9 ���
		if (WirePIN & (1<<WirePinN)) //�������� ��������� ������
		{
			grand_temperature|=_BV(i);      //������ ���. 1
			if(i==12)
			{
				znak=1;
			}
		}
		else
		{
			grand_temperature&=~_BV(i);    //������ ���. 0
		}
		_delay_loop_2(138);
	}
	//��������� �����������
	if(znak==1)  //�������������� �����������
	{
		grand_temperature=65536-grand_temperature;
	}

	des_temperature=grand_temperature&0b00001111;
	temperature=(grand_temperature>>4);
	sei();
}

//������� ������������ ����� ������� t
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

//������� ���������� ���� �������
void search_ds1820_ROM(void)
{
	reset_ds1820();             //����� �������
	send_ds1820_command(0xF0);  //������� ����� ���
	was_conflict=0;   //����� �������� ������� ���������
	unsigned char bit_analizer=0; //���������� ������� �������� �����
	_delay_loop_2(250);
	cli();
	for(j=0;j<8;j++) {      //��������� ��������� ������ �������
		for(i=0;i<8;i++)
		{                      //������ �� �������� ����
			WireDDR|=_BV(WirePin);
			_delay_loop_2(15);  //�������� �������� �� 6 ���
			WireDDR&=~_BV(WirePin);
			_delay_loop_1(30);  //�������� �������� �� 9 ���

			if (WirePin & (1<<WirePinN)) //����� ���� ���� �������
			{
				bit_analizer|=_BV(0);      //������ ���. 1
			}
			else
			{
				bit_analizer&=~_BV(0);    //������ ���. 0
			}
			_delay_loop_2(138);
			//������ �� �������� ���������� ����
			WireDDR|=_BV(WirePin);
			_delay_loop_2(15);  //�������� �������� �� 6 ���
			WireDDR&=~_BV(WirePin);
			_delay_loop_1(30);  //�������� �������� �� 9 ���
			if (WirePin & (1<<WirePinN)) //����� ���������� ���� ���� �������
			{
				bit_analizer|=_BV(1);      //������ ���. 1
			}
			else
			{
				bit_analizer&=~_BV(1);    //������ ���. 0
			}
			_delay_loop_2(138);
			//������ �������� ����� ����(������� � ����������)
			switch(bit_analizer)
			{
				case 0: //��������� �������� �����
				was_conflict=1;
				if(get_for_two==false) //���� ��� 1-�� ��������
				//�� ���. 0
				{
					ROM1[j]&=~_BV(i);
					//������ ���. 0 �� �����
					WireDDR|=_BV(WirePin);
					_delay_loop_2(150); //60 ���
					WireDDR&=~_BV(WirePin);
					_delay_loop_2(25);  //10 ���
				}
				else //���� ��� 2-�� �������� �� ���. 1
				{
					ROM2[j]|=_BV(i);
					//������ ���.1 �� �����
					WireDDR|=_BV(WirePin);
					_delay_loop_2(15);   //�������� �������� �� 6 ���
					WireDDR&=~_BV(WirePin);
					_delay_loop_2(160);  //�������� �������� �� 64 ���
				}
				break;
				case 1: if(get_for_two==false) //����� ���.1
				{
					ROM1[j]|=_BV(i);
				}
				else
				{
					ROM2[j]|=_BV(i);
				}
				//������ ���. 1 �� �����
				WireDDR|=_BV(WirePin);
				_delay_loop_2(15);   //�������� �������� �� 6 ���
				WireDDR&=~_BV(WirePin);
				_delay_loop_2(160);   //�������� �������� �� 64 ���
				break;
				case 2: if(get_for_two==false)//����� ���. 0
				{
					ROM1[j]&=~_BV(i);
				}
				else
				{
					ROM2[j]&=~_BV(i);
				}
				//������ ���.0 �� �����
				WireDDR|=_BV(WirePin);
				_delay_loop_2(150);  //60 ���
				WireDDR&=~_BV(WirePin);
				_delay_loop_2(25);  //10 ���
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

//������� �������� ROM ���� �������
void send_ROM_ds1820(unsigned char selector)
{
	for(j=0;j<8;j++)
	{
		//���� �� ���� ���������� �� ����=>���� ������
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
	WireDDR=0x00;           // ���� ���������� ��������
	//PORTD=0x20;
	TIMSK=0x80;
	SREG=0x80;
	TCNT1=0x48E5;
	sei();
	//ini_LCD();
	TCCR1B=0x04;
	while(1)
	{
		search_ds1820_ROM(); //��������� ���� ��� 1-��
		search_ds1820_ROM(); //��������� ���� ��� 2-��
		//��������� �� �������� �������� �����������
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
		send_ds1820_command(0x55);  //��������� ROM
		send_ROM_ds1820(z);
		send_ds1820_command(0x44);  //������� ��������� t

		for(j=0;j<80;j++)          //��������� ����� 800 ��
		{
			_delay_loop_2(25000);
		}
		reset_ds1820();
		send_ds1820_command(0x55);  //��������� ROM
		send_ROM_ds1820(z);
		send_ds1820_command(0xBE);
		receive_ds1820();
	}
};
