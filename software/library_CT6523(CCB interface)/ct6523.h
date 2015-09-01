#include <stdbool.h> 
#define CV 1 //выбор компилятора - если гцц - закоментировать.

#include <mega128a.h>

#include <inttypes.h>

#define u8 unsigned char
#define u16 unsigned int
#define u32 uint32_t

#define MODE_IN_ADR 0x82  //write address
#define MODE_OUT_ADR 0x43  //read address

#define LC_PORT PORTD
#define LC_PIN PIND
#define DD_LC_PORT DDRD

#define CE     0   //выход, выборка                          
#define CL     2   //выход, такты                            
#define DI     1   //выход, подключается ко входу  данных DI 
#define DO     3   //вход,  подключается ко выходу данных DO 

#define CL_LOW()  (LC_PORT &= ~(1<<CL))
#define CL_HIGH() (LC_PORT |=  (1<<CL))
#define CE_LOW()  (LC_PORT &= ~(1<<CE))
#define CE_HIGH() (LC_PORT |=  (1<<CE))
#define DI_LOW()  (LC_PORT &= ~(1<<DI))
#define DI_HIGH() (LC_PORT |=  (1<<DI))
#define DO_STATE() (LC_PIN & (1<<DO))

extern unsigned char lcd_buf[20];
//extern unsigned char lcd_control;
//extern unsigned char lcd_key[4];

void ct6523_init(void);
void ct6523_set_bit(unsigned char _bit);
void ct6523_clr_bit(unsigned char _bit);
void send_lcd_bufer(void);
//void lc75853n_key_scan(void);