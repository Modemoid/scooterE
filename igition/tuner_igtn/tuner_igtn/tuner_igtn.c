/*
 * tuner_igtn.c
 *
 * Created: 15.01.2015 7:50:39
 *  Author: skota
 */ 

//############################################################################################################################
//#
//#	���������� ������ � LCD ��������� WH1602 �� ��������������� ������������� �����.
//# ��������� �������� ������������� ������� (������ ��������� �������), � ��������, ��� ������������ �� �������
//# ����� ��������� �� ����� 8-��, ����� ������������� ��������, �� ���� - ��������������������.
//# ��� ������� ������ �� ������� �������� ���������� ������������� ��������, ��������� ����� ��������� �������� "*".
//# ��������� � �����
//#
//#(programmed by SHADS)
//#
//############################################################################################################################

//3C,34,30,38,3A,32,36,3E,3F,3D,35,31,39,3B,33,37

//���������� �����
#include <stdio.h>
#include <avr/io.h>
#include <string.h>
#include <avr/pgmspace.h>
#define F_CPU 16000000
#include <util/delay.h>


//������������� ������� (����� � ����� ������ ��� ������ � LED ��������)
#define LCDDataPORT 	PORTD									/*���� ������ LCD*/
#define LCDDataDDR 		DDRD									/*���������������� ����� ������ LCD*/
#define LCD_D4	3												/*����� ������ D4*/
#define LCD_D5	4												/*����� ������ D5*/
#define LCD_D6	5												/*����� ������ D6*/
#define LCD_D7	6												/*����� ������ D7*/

#define LCDControlPORT 	PORTD									/*���� ����� ���������� LCD*/
#define LCDControlDDR 	DDRD									/*���������������� ����� ���������� LCD*/
#define LCD_RS	0 												/*����� ���������� RS*/
#define LCD_E	2												/*����� ���������� E*/


//��������������� �������
#define INLINE   inline __attribute__((__always_inline__))
#define NOINLINE __attribute__((__noinline__))

#define LCDCommandCurHome 			0x02						/*LCD ����������� ������ � ������� 0,0*/
#define LCDCommandCurOn				0x0E						/*LCD �������� ������*/
#define LCDCommandCurBlink			0x0F						/*LCD �������� ������*/
#define LCDCommandCurOff			0x0C						/*LCD ��������� ������*/
#define LCDCommandCurLeft			0x10						/*LCD ������ ����������� �����*/
#define LCDCommandCurRight			0x14						/*LCD ������ ����������� ������*/
#define LCDCommandDispClear 		0x01						/*LCD �������� ������ �������*/
#define LCDCommandDispBlank			0x08						/*LCD ������ ������ (�� �� �������)*/
#define LCDCommandDispVisible		0x0C						/*LCD ���������� ������*/
#define LCDCommandDispShiftLeft 	0x18						/*LCD ����� ���������� �� ������� �����*/
#define LCDCommandDispShiftRight 	0x1C						/*LCD ����� ���������� �� ������� ������*/
#define LCDCommandDispModeProg		0x08|0x04					/*0x08 - ���������������� ������ ������� (������������ ������)*/
/*0x04 - ����������� ������ ��������,*/
/*0x02 - ������ �������, 0x01 - ������ �������*/

unsigned char *buf, *rebuf;;



//��������� �������
static void LCDSendChar (unsigned char);					//��������� ������ �� LCD
static void LCDSendStr (char* );							//��������� ������ �� LCD
static void LCDSendCommand (unsigned char);					//��������� ������� �� LCD
static void LCDInit (void);									//������������� LCD
static void LCDCurGotoXY(unsigned char x, unsigned char y); //����������� ������� LCD � X,Y �������

void LCD_cls(void){
	LCDSendCommand (LCDCommandDispClear);
}

int main( void )
{	
unsigned char m1,New;

unsigned int NewState,OldState,upState,downState;
unsigned char Vol;
DDRC=0x00;
PORTC|=1|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5);
DDRB&=~(1|(1<<1));
PORTB|=1|(1<<1);

	buf="Start!";
	LCDInit();
	LCDSendCommand (LCDCommandDispClear);						//�������� ������ � ����� �������
	LCDSendCommand (LCDCommandCurHome);
LCDSendStr(buf);
_delay_ms(3000);
LCD_cls();
LCDCurGotoXY(0,1);
LCDSendStr("Mod=    Read=   ");
	while(1){
LCDCurGotoXY(0,0);
m1=PINC;
buf="";
switch (m1)
{
	case 0x3C:
	buf="Menu 1 ";
	break;
	case 0x34:
	buf="Menu 2 ";
	break;
	case 0x30:
	buf="Menu 3 ";
	break;
	case 0x38:
	buf="Menu 4 ";	
	break;
	case 0x3A:
	buf="Menu 5 ";	
	break;
	case 0x32:
	buf="Menu 6 ";	
	break;
	case 0x36:
	buf="Menu 7 ";	
	break;
	case 0x3E:
	buf="Menu 8 ";	
	break;
	case 0x3F:
	buf="Menu 9 ";	
	break;
	case 0x3D:
	buf="Menu 10";	
	break;
	case 0x35:
	buf="Menu 11";	
	break;
	case 0x31:
	buf="Menu 12";	
	break;
	case 0x39:
	buf="Menu 13";	
	break;
	case 0x3B:
	buf="Menu 14";	
	break;
	case 0x33:
	buf="Menu 15";	
	break;
	case 0x37:
	buf="Menu 16";	
	break;
	default:
	buf="Pressed button";
}

      NewState=PINB & 0b00000011;
      //NewState=NewState>>5;  
     // sprintf(line,"vol=%d",NewState);
      //lcd_gotoxy(0,1);
      //lcd_puts(line);
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
        Vol--;
        upState = 0;
      }
      if (downState >= 4) 
      {                              
        Vol++;
        downState = 0;
      }
	  
itoa(Vol,rebuf,10);	  
LCDCurGotoXY(0,0);
LCDSendStr(buf);
LCDCurGotoXY(4,1);
LCDSendStr(rebuf);
	}
}


//----------------------------------------------------------------------------------------------
//�������� ��� ����� ��������
NOINLINE void LCDStrobeDelay (void)
{
	_delay_ms (1);
}

//����� �������
NOINLINE void LCDEStrobe (void)
{
	LCDControlPORT|= (1<<LCD_E);
	LCDStrobeDelay ();
	LCDControlPORT &= ~(1<<LCD_E);
	LCDStrobeDelay ();
}

//������� ������������� LCD
void LCDInit (void)
{
	LCDDataPORT &= ~(1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//�������� ����� ������
	LCDDataDDR |= (1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//����� ������ �� �����
	LCDControlPORT &= ~(1<<LCD_E|1<<LCD_RS);					//�������� ����� ����������
	LCDControlDDR |= (1<<LCD_E|1<<LCD_RS); 						//����� ���������� �� �����

	//_delay_ms (50);		//����������������, ���� � ����� ����������� ����������������� �������� ��� ������ 64��
	LCDDataPORT |= (1<<LCD_D5|1<<LCD_D4);
	LCDEStrobe ();
	_delay_ms (5);
	LCDEStrobe ();
	LCDEStrobe ();
	LCDDataPORT &= ~(1<<LCD_D4);
	LCDEStrobe ();

	LCDSendCommand (0x28);										//����� - 4 ����, 2 ������
	LCDSendCommand (LCDCommandDispModeProg);					//����� ������� (��������� � ��������)
}


//----------------------------------------------------------------------------------------------
//������� ��������� ������� � ������ �������

void LCDCurGotoXY (unsigned char x, unsigned char y)
{
	if (y == 1)
	x |= 0x40;
	LCDSendCommand (0x80 | x);
}


//----------------------------------------------------------------------------------------------
//������� �������� ������� �� LCD
//�������� - ��� �������

void LCDSendCommand (unsigned char byte)
{
	LCDDataPORT &= ~(1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//�������� ����� ������
	LCDDataPORT |= ((byte & 0b11110000) >> (4-LCD_D4));			//����� ������� ������� �������
	LCDEStrobe ();												//����� �������

	LCDDataPORT &= ~(1<<LCD_D7|1<<LCD_D6|1<<LCD_D5|1<<LCD_D4);	//�������� ����� ������
	LCDDataPORT |= ((byte & 0b00001111) << (LCD_D4));			//����� ������� ������� �������
	LCDEStrobe ();												//����� �������
}


//----------------------------------------------------------------------------------------------
//������� ������ ������� �� LCD ������� (� ������� �������)
//�������� - ��� �������

void LCDSendChar (unsigned char byte)
{
	LCDControlPORT |= 1<<LCD_RS;								//������� �������� �������
	LCDSendCommand (byte);										//����� �������
	LCDControlPORT &= ~(1<<LCD_RS);
}

static void LCDSendStr (char *str ){
	while (*str) {
LCDSendChar(*str++);	
LCDStrobeDelay();
}


	
}