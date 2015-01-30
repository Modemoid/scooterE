/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////

MSCS Bus - slave start read and write to bus: mosi-h, clk - h. read and write - synhro. package - 16 byte

*///////////////////////////////////////////////////////////////////////////////////////////////////////////////
#include "MSCS_lib.h"

#ifdef MASTER
 
#define DDRMOSI  DDPORT( MOSIP )
#define MOSI_PORT PPORT( MOSIP )

#define DDRCLK  DDPORT( CLKP )
#define CLK_PORT PPORT( CLKP )

#define DDRMISO  DDPORT( MISOP )
#define MISO_PORT PPIN( MISOP )

void MSCS_delay(void){
#ifdef CV
delay_ms(1);
#else
_delay_ms(1);
#endif
}

void mosi(unsigned char mos){
 if (mos){
  MOSI_PORT|=(1<<MOSI_BIT);
 } else {
  MOSI_PORT&=~(1<<MOSI_BIT); 
 }
}

void clk(unsigned char cl){
 if (cl){
  CLK_PORT|=(1<<CLK_BIT);
 } else {
  CLK_PORT&=~(1<<CLK_BIT); 
 }
}

unsigned char miso(void){
 return ((MISO_PORT&(1<<MISO_BIT))&&(1<<MISO_BIT));
}

void MSCS_com(unsigned char *data,unsigned char ret[17]){

unsigned char buffer,resiver=0,i,j;
mosi(1);
for (i=0; i<16; i++){
    buffer=data[i];
    for (j=0; j<8; j++){                     
        clk(1);
        MSCS_delay();    
        mosi(((buffer<<j)&0b10000000)&&0x80);  
        MSCS_delay();
        clk(0);
        MSCS_delay();
        resiver=(resiver<<1)|miso();
    }
    ret[i]=resiver;
    resiver=0;
}
ret[16]=0;
clk(1);
MSCS_delay();
clk(0);
mosi(0);
MSCS_delay();
MSCS_delay();
MSCS_delay();
MSCS_delay();
MSCS_delay();
MSCS_delay();
}

void MSCS_init(void){
DDRMOSI|=(1<<MOSI_BIT);
MOSI_PORT&=~(1<<MOSI_BIT);
DDRMISO&=~(1<<MISO_BIT);
MISO_PORT&=~(1<<MISO_BIT);
DDRCLK|=(1<<CLK_BIT);
CLK_PORT&=~(1<<CLK_BIT);
}

#else 
#define DDRMOSI  DDPORT(MOSIP)
#define MOSI_PORT PPIN(MOSIP)

#define DDRCLK  DDPORT(CLKP)
#define CLK_PORT PPIN(CLKP)

#define DDRMISO  DDPORT(MISOP)
#define MISO_PORT PPORT(MISOP)

void MSCS_delay_framing(void){
#ifdef CV
delay_us(200);
#else
_delay_us(200);
#endif
}

void miso(unsigned char mis){
 if (mis){
  MISO_PORT|=(1<<MISO_BIT);
 } else {
  MISO_PORT&=~(1<<MISO_BIT); 
 }
}

inline unsigned char clk(void){
 return ((CLK_PORT&(1<<CLK_BIT))&&(1<<CLK_BIT));
}

inline unsigned char mosi(void){
 return ((MOSI_PORT&(1<<MOSI_BIT))&&(1<<MOSI_BIT));
}

unsigned char MSCS_framing(void){
unsigned char i;
for(i=0;i<25;i++) {
MSCS_delay_framing();
 if (clk()) return 1;
 
}
return 0;
}

unsigned char MSCS_com(unsigned char *data,unsigned char wait, unsigned char result[17]){
unsigned char buffer_tx,buffer_rx;
unsigned char i,j;
unsigned int c;
if (MSCS_framing()) {
while(MSCS_framing()) asm ("nop");;
wait=1;
}

if (wait){

 while (!(mosi()&&clk())){
 asm ("nop");
 }  
 for(i=0;i<16;i++){
  buffer_tx=data[i];
  buffer_rx=0;
  for(j=0;j<8;j++){
  c=1;
    while(clk()){
        if (c) c++; else return 0;    
    }    
    buffer_rx=(buffer_rx<<1)|mosi(); 
    miso(((buffer_tx<<j)&0b10000000)&&0x80);   
    c=1;
    while(!clk()){
        if (c) c++; else return 0;   
    }         
  }
  result[i]=buffer_rx; 
 } 
 result[16]=0;
  return 1;
} else {
if (mosi()&&clk()) {
 for(i=0;i<16;i++){
  buffer_tx=data[i];
  buffer_rx=0;
  for(j=0;j<8;j++){
  c=1;
    while(clk()){
        if (c) c++; else return 0;    
    }    
    buffer_rx=(buffer_rx<<1)|mosi(); 
    miso(((buffer_tx<<j)&0b10000000)&&0x80);   
    c=1;
    while(!clk()){
        if (c) c++; else return 0;   
    }             
  }           
  result[i]=buffer_rx;
 }
result[16]=0;
  return 1;
}
}
return 0;
}

void MSCS_init(void){
DDRMOSI&=~(1<<MOSI_BIT);
MOSI_PORT&=~(1<<MOSI_BIT);
DDRMISO|=(1<<MISO_BIT);
MISO_PORT|=(1<<MISO_BIT);
DDRCLK&=~(1<<CLK_BIT);
CLK_PORT&=~(1<<CLK_BIT);
}
#endif
