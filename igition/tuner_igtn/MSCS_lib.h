#ifndef F_CPU
#define F_CPU 16000000
#endif

#include <stdio.h>

#define MOSI_BIT 3
#define MOSIP    B
#define MISO_BIT 4
#define MISOP    B
#define CLK_BIT  5
#define CLKP     B

#define CV 1 //CodeVisionAVR

#ifdef CV
#include <delay.h>
#include <mega8.h>
#else
#include <avr/delay.h>
#include <avr/io.h>
#endif

#define _concatuate(a,b )      (a##b )
#define con(a,b )              _concatuate(a,b )

#define DDPORT(a) con(DDR,a) 
#define PPORT(a) con(PORT,a)
#define PPIN(a) con(PIN,a)

#define MASTER 1
#ifdef MASTER
void MSCS_com(unsigned char*,unsigned char [17]);
#else
unsigned char MSCS_com(unsigned char *,unsigned char, unsigned char [17]);
#endif
void MSCS_init(void);
