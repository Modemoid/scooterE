#include <stdbool.h> 
#define CV 1 //����� ����������� - ���� ��� - ���������������.

#include <mega128a.h>

#include <inttypes.h>

#define u8 unsigned char
#define u16 unsigned int
#define u32 uint32_t

#define MODE_IN_ADR 0x42  //write address
#define MODE_OUT_ADR 0x43  //read address

#define LC_PORT PORTD
#define LC_PIN PIND
#define DD_LC_PORT DDRD

#define CE     0   //�����, �������                          
#define CL     1   //�����, �����                            
#define DI     3   //�����, ������������ �� �����  ������ DI 
#define DO     2   //����,  ������������ �� ������ ������ DO 

#define CL_LOW()  (LC_PORT &= ~(1<<CL))
#define CL_HIGH() (LC_PORT |=  (1<<CL))
#define CE_LOW()  (LC_PORT &= ~(1<<CE))
#define CE_HIGH() (LC_PORT |=  (1<<CE))
#define DI_LOW()  (LC_PORT &= ~(1<<DI))
#define DI_HIGH() (LC_PORT |=  (1<<DI))
#define DO_STATE() (LC_PIN & (1<<DO))

extern unsigned char lcd_buf[18];
extern unsigned char lcd_control;
extern unsigned char lcd_key[4];

void lc75853n_init(void);
void lc75853n_set_bit(unsigned char _bit);
void lc75853n_clr_bit(unsigned char _bit);
void send_lcd_bufer(void);
void lc75853n_key_scan(void);