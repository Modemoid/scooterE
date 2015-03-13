#include "lc75853n.h"

#ifdef CV
#include <delay.h>
#define _delay_ms delay_ms
#define _delay_us delay_us

#else
#include <avr/delay.h>
#endif

unsigned char lcd_buf[18];
unsigned char lcd_key[4];
unsigned char lcd_control=0b00110100;

void portsInit (void)
{

   //сконфигурируем ножки как выходы
   DD_LC_PORT |= (1<<CE) | (1<<CL) | (1<<DI);
   DD_LC_PORT &=~(1<<DO);

   //Ставим все ножки выходов в 1. Это означает,
   // что будет использоваться протокол с CL по умолчанию =1.
   //На DO подключим нагрузочный резистор.
   LC_PORT = (1<<CL) | (1<<DO);           
   CE_LOW();
}

///////////////////////////////
static void BusPause(void) 
{
   _delay_us(8);
   return;
}

///////////////////
static void BusStrob(void)
{
      CL_LOW();
              BusPause();
       CL_HIGH();  
   BusPause();
       //SetBit(BUS_Port,BUS_BitClc);
   
}

///////////////////////////
// Выводит байт на шину DI микросхемы LC72131, старший бит идет первым.
void BusOutH2L(u8 Bus)
{
   u8 i;

   for(i=0; i < 8; i++)
   {
   
   BusPause();
          if(Bus & 0x80)
         DI_HIGH();     //SetBit(BUS_Port,BUS_BitDat);
      else
         DI_LOW();      //ClrBit(BUS_Port,BUS_BitDat);
      CL_LOW();
              BusPause();
       CL_HIGH(); 
      Bus <<= 1;
   }               
   _delay_us(8);
   return;
}

///////////////////////////
// Выводит байт на шину DI микросхемы LC72131, младший бит идет первым.
void BusOutL2H(u8 Bus)
{
   u8 i;
      
   
   
   for(i=0; i < 8; i++)
   {
    
         BusPause();
          if(Bus & 0x01)
         DI_HIGH();     //SetBit(BUS_Port,BUS_BitDat);
      else
         DI_LOW();      //ClrBit(BUS_Port,BUS_BitDat);
      CL_LOW();
              BusPause();
       CL_HIGH(); 
      Bus >>= 1;
   }               
   _delay_us(8);
   return;
}

///////////////////////////
// Читает байт с шины DO микросхемы LC72131, старший бит идет первым.
void BusInH2L(u8* Bus)
{
   u8 i;

   for(i=0; i < 8; i++)
   {
      (*Bus) <<= 1;
      if (DO_STATE())
         (*Bus) |= 0x01;
      BusStrob();
   }
   return;
}

///////////////////////////
// Читает байт с шины DO микросхемы LC72131, младший бит идет первым.
void BusInL2H(u8* Bus)
{
   u8 i;

   for(i=0; i < 8; i++)
   {
      (*Bus) >>= 1;
      if (DO_STATE())
         (*Bus) |= 0x80;
      BusStrob();
   }
   return;
}

void lc75853n_key_scan(void){
 unsigned char i,ret;  
 BusOutL2H(MODE_OUT_ADR);
BusPause();
CE_HIGH();
BusPause();
for (i=0;i<4;i++){
 BusInH2L(&ret);   
 lcd_key[i]=ret;
 } 
CE_LOW();
BusPause();
}

void lc75853n_set_bit(unsigned char _bit){
unsigned char i,d;
if (_bit<42){
i=_bit/8;
d=_bit%8;
if (i==5) lcd_buf[i]|=(1<<(d+6));
    else lcd_buf[i]|=(1<<d);  
} else 
    {if (_bit<84){
_bit-=42;
i=_bit/8;
d=_bit%8;
if (i==5) lcd_buf[i+6]|=(1<<(d+6));
    else lcd_buf[i+6]|=(1<<d); 
    } else
    {
_bit-=84;
i=_bit/8;
d=_bit%8;
if (i==5) lcd_buf[i+12]|=(1<<(d+6));
    else lcd_buf[i+12]|=(1<<d); 
    }
}
send_lcd_bufer();
}

void lc75853n_clr_bit(unsigned char _bit){
unsigned char i,d;
if (_bit<42){
i=_bit/8;
d=_bit%8;
if (i==5) lcd_buf[i]&=~(1<<(d+6));
    else lcd_buf[i]&=~(1<<d);  
} else 
    {if (_bit<84){
_bit-=42;
i=_bit/8;
d=_bit%8;
if (i==5) lcd_buf[i+6]&=~(1<<(d+6));
    else lcd_buf[i+6]&=~(1<<d); 
    } else
    {
_bit-=84;
i=_bit/8;
d=_bit%8;
if (i==5) lcd_buf[i+12]&=~(1<<(d+6));
    else lcd_buf[i+12]&=~(1<<d); 
    }
}
send_lcd_bufer();
}


void send_lcd_bufer(void){
unsigned char i;
BusOutH2L(MODE_IN_ADR);
//_delay_us(
BusPause();
CE_HIGH();
BusPause();
 for (i=0;i<6;i++){
   BusOutH2L(lcd_buf[i]); 
 }           
 BusOutH2L(lcd_control); 
CE_LOW();
DI_LOW();
BusPause();

BusOutH2L(MODE_IN_ADR);
//_delay_us(
BusPause();
CE_HIGH();
BusPause();
 for (i=0;i<6;i++){
   BusOutH2L(lcd_buf[i+6]); 
 }           
 BusOutH2L(0b00000001); 
CE_LOW();
DI_LOW();
BusPause();

BusOutH2L(MODE_IN_ADR);
//_delay_us(
BusPause();
CE_HIGH();
BusPause();
 for (i=0;i<6;i++){
  BusOutH2L(lcd_buf[i+12]); 
  }           
 BusOutH2L(0b00000010); 
CE_LOW();
DI_LOW();
BusPause();

}

void lc75853n_init(void){
unsigned char i,j;
portsInit();
};
