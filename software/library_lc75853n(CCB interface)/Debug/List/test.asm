
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x4,0x4,0x4,0x4,0x4
	.DB  0x0,0x4,0xA,0xA,0xA,0x0,0x0,0x0
	.DB  0x0,0xA,0xA,0x1F,0xA,0x1F,0xA,0xA
	.DB  0x4,0x1E,0x5,0xE,0x14,0xF,0x4,0x3
	.DB  0x13,0x8,0x4,0x2,0x19,0x18,0x6,0x9
	.DB  0x5,0x2,0x15,0x9,0x16,0x6,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x8,0x4,0x2,0x2
	.DB  0x2,0x4,0x8,0x2,0x4,0x8,0x8,0x8
	.DB  0x4,0x2,0x0,0xA,0x4,0x1F,0x4,0xA
	.DB  0x0,0x0,0x4,0x4,0x1F,0x4,0x4,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x4,0x2,0x0
	.DB  0x0,0x0,0x1F,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x6,0x0,0x0,0x10,0x8
	.DB  0x4,0x2,0x1,0x0,0xE,0x11,0x19,0x15
	.DB  0x13,0x11,0xE,0x4,0x6,0x4,0x4,0x4
	.DB  0x4,0xE,0xE,0x11,0x10,0x8,0x4,0x2
	.DB  0x1F,0x1F,0x8,0x4,0x8,0x10,0x11,0xE
	.DB  0x8,0xC,0xA,0x9,0x1F,0x8,0x8,0x1F
	.DB  0x1,0xF,0x10,0x10,0x11,0xE,0xC,0x2
	.DB  0x1,0xF,0x11,0x11,0xE,0x1F,0x10,0x8
	.DB  0x4,0x2,0x2,0x2,0xE,0x11,0x11,0xE
	.DB  0x11,0x11,0xE,0xE,0x11,0x11,0x1E,0x10
	.DB  0x8,0x6,0x0,0x6,0x6,0x0,0x6,0x6
	.DB  0x0,0x0,0x6,0x6,0x0,0x6,0x4,0x2
	.DB  0x10,0x8,0x4,0x2,0x4,0x8,0x10,0x0
	.DB  0x0,0x1F,0x0,0x1F,0x0,0x0,0x1,0x2
	.DB  0x4,0x8,0x4,0x2,0x1,0xE,0x11,0x10
	.DB  0x8,0x4,0x0,0x4,0xE,0x11,0x10,0x16
	.DB  0x15,0x15,0xE,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0xF,0x11,0x11,0xF,0x11,0x11
	.DB  0xF,0xE,0x11,0x1,0x1,0x1,0x11,0xE
	.DB  0x7,0x9,0x11,0x11,0x11,0x9,0x7,0x1F
	.DB  0x1,0x1,0xF,0x1,0x1,0x1F,0x1F,0x1
	.DB  0x1,0x7,0x1,0x1,0x1,0xE,0x11,0x1
	.DB  0x1,0x19,0x11,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0x11,0xE,0x4,0x4,0x4,0x4
	.DB  0x4,0xE,0x1C,0x8,0x8,0x8,0x8,0x9
	.DB  0x6,0x11,0x9,0x5,0x3,0x5,0x9,0x11
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1F,0x11
	.DB  0x1B,0x15,0x11,0x11,0x11,0x11,0x11,0x11
	.DB  0x13,0x15,0x19,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xE,0xF,0x11,0x11,0xF
	.DB  0x1,0x1,0x1,0xE,0x11,0x11,0x11,0x15
	.DB  0x9,0x16,0xF,0x11,0x11,0xF,0x5,0x9
	.DB  0x11,0x1E,0x1,0x1,0xE,0x10,0x10,0xF
	.DB  0x1F,0x4,0x4,0x4,0x4,0x4,0x4,0x11
	.DB  0x11,0x11,0x11,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xA,0x4,0x11,0x11,0x11
	.DB  0x15,0x15,0x1B,0x11,0x11,0x11,0xA,0x4
	.DB  0xA,0x11,0x11,0x11,0x11,0xA,0x4,0x4
	.DB  0x4,0x4,0x1F,0x10,0x8,0x4,0x2,0x1
	.DB  0x1F,0x1C,0x4,0x4,0x4,0x4,0x4,0x1C
	.DB  0x0,0x1,0x2,0x4,0x8,0x10,0x0,0x7
	.DB  0x4,0x4,0x4,0x4,0x4,0x7,0x4,0xA
	.DB  0x11,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1F,0x2,0x4,0x8,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xE,0x10,0x1E
	.DB  0x11,0x1E,0x1,0x1,0xD,0x13,0x11,0x11
	.DB  0xF,0x0,0x0,0xE,0x1,0x1,0x11,0xE
	.DB  0x10,0x10,0x16,0x19,0x11,0x11,0x1E,0x0
	.DB  0x0,0xE,0x11,0x1F,0x1,0xE,0xC,0x12
	.DB  0x2,0x7,0x2,0x2,0x2,0x0,0x0,0x1E
	.DB  0x11,0x1E,0x10,0xC,0x1,0x1,0xD,0x13
	.DB  0x11,0x11,0x11,0x4,0x0,0x6,0x4,0x4
	.DB  0x4,0xE,0x8,0x0,0xC,0x8,0x8,0x9
	.DB  0x6,0x2,0x2,0x12,0xA,0x6,0xA,0x12
	.DB  0x6,0x4,0x4,0x4,0x4,0x4,0xE,0x0
	.DB  0x0,0xB,0x15,0x15,0x11,0x11,0x0,0x0
	.DB  0xD,0x13,0x11,0x11,0x11,0x0,0x0,0xE
	.DB  0x11,0x11,0x11,0xE,0x0,0x0,0xF,0x11
	.DB  0xF,0x1,0x1,0x0,0x0,0x16,0x19,0x1E
	.DB  0x10,0x10,0x0,0x0,0xD,0x13,0x1,0x1
	.DB  0x1,0x0,0x0,0xE,0x1,0xE,0x10,0xF
	.DB  0x2,0x2,0x7,0x2,0x2,0x12,0xC,0x0
	.DB  0x0,0x11,0x11,0x11,0x19,0x16,0x0,0x0
	.DB  0x11,0x11,0x11,0xA,0x4,0x0,0x0,0x11
	.DB  0x11,0x15,0x15,0xA,0x0,0x0,0x11,0xA
	.DB  0x4,0xA,0x11,0x0,0x0,0x11,0x11,0x1E
	.DB  0x10,0xE,0x0,0x0,0x1F,0x8,0x4,0x2
	.DB  0x1F,0x8,0x4,0x4,0x2,0x4,0x4,0x8
	.DB  0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x2
	.DB  0x4,0x4,0x8,0x4,0x4,0x2,0x2,0x15
	.DB  0x8,0x0,0x0,0x0,0x0,0x1F,0x11,0x11
	.DB  0x11,0x11,0x11,0x1F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_st7920_init_4bit_G101:
	.DB  0x30,0x30,0x20,0x0,0x20,0x0
_st7920_base_y_G101:
	.DB  0x80,0x90,0x88,0x98

_0x0:
	.DB  0x53,0x54,0x41,0x52,0x54,0x21,0x0
_0x20003:
	.DB  0x34
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20E0060:
	.DB  0x1
_0x20E0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x01
	.DW  _lcd_control
	.DW  _0x20003*2

	.DW  0x01
	.DW  __seed_G107
	.DW  _0x20E0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12.03.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128A
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include "lc75853n.h"
;
;// Graphic Display functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 0027 {

	.CSEG
_main:
; .FSTART _main
; 0000 0028 // Declare your local variables here
; 0000 0029 // Variable used to store graphic display
; 0000 002A // controller initialization data
; 0000 002B GLCDINIT_t glcd_init_data;
; 0000 002C unsigned char t,str[10];
; 0000 002D // Input/Output Ports initialization
; 0000 002E // Port A initialization
; 0000 002F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0030 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,16
;	glcd_init_data -> Y+10
;	t -> R17
;	str -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0031 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0032 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0033 
; 0000 0034 // Port B initialization
; 0000 0035 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0036 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0037 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0038 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0039 
; 0000 003A // Port C initialization
; 0000 003B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 003C DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 003D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 003E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 003F 
; 0000 0040 // Port D initialization
; 0000 0041 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0042 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0043 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0044 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0045 
; 0000 0046 // Port E initialization
; 0000 0047 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0048 DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 0049 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 004A PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 004B 
; 0000 004C // Port F initialization
; 0000 004D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 004E DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 004F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0050 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 0051 
; 0000 0052 // Port G initialization
; 0000 0053 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0054 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 0055 // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0056 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0057 
; 0000 0058 // Timer/Counter 0 initialization
; 0000 0059 // Clock source: System Clock
; 0000 005A // Clock value: Timer 0 Stopped
; 0000 005B // Mode: Normal top=0xFF
; 0000 005C // OC0 output: Disconnected
; 0000 005D ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 005E TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 005F TCNT0=0x00;
	OUT  0x32,R30
; 0000 0060 OCR0=0x00;
	OUT  0x31,R30
; 0000 0061 
; 0000 0062 // Timer/Counter 1 initialization
; 0000 0063 // Clock source: System Clock
; 0000 0064 // Clock value: Timer1 Stopped
; 0000 0065 // Mode: Normal top=0xFFFF
; 0000 0066 // OC1A output: Disconnected
; 0000 0067 // OC1B output: Disconnected
; 0000 0068 // OC1C output: Disconnected
; 0000 0069 // Noise Canceler: Off
; 0000 006A // Input Capture on Falling Edge
; 0000 006B // Timer1 Overflow Interrupt: Off
; 0000 006C // Input Capture Interrupt: Off
; 0000 006D // Compare A Match Interrupt: Off
; 0000 006E // Compare B Match Interrupt: Off
; 0000 006F // Compare C Match Interrupt: Off
; 0000 0070 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0071 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0072 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0073 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0074 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0075 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0076 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0077 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0078 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0079 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 007A OCR1CH=0x00;
	STS  121,R30
; 0000 007B OCR1CL=0x00;
	STS  120,R30
; 0000 007C 
; 0000 007D // Timer/Counter 2 initialization
; 0000 007E // Clock source: System Clock
; 0000 007F // Clock value: Timer2 Stopped
; 0000 0080 // Mode: Normal top=0xFF
; 0000 0081 // OC2 output: Disconnected
; 0000 0082 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0083 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0084 OCR2=0x00;
	OUT  0x23,R30
; 0000 0085 
; 0000 0086 // Timer/Counter 3 initialization
; 0000 0087 // Clock source: System Clock
; 0000 0088 // Clock value: Timer3 Stopped
; 0000 0089 // Mode: Normal top=0xFFFF
; 0000 008A // OC3A output: Disconnected
; 0000 008B // OC3B output: Disconnected
; 0000 008C // OC3C output: Disconnected
; 0000 008D // Noise Canceler: Off
; 0000 008E // Input Capture on Falling Edge
; 0000 008F // Timer3 Overflow Interrupt: Off
; 0000 0090 // Input Capture Interrupt: Off
; 0000 0091 // Compare A Match Interrupt: Off
; 0000 0092 // Compare B Match Interrupt: Off
; 0000 0093 // Compare C Match Interrupt: Off
; 0000 0094 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 0095 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 0096 TCNT3H=0x00;
	STS  137,R30
; 0000 0097 TCNT3L=0x00;
	STS  136,R30
; 0000 0098 ICR3H=0x00;
	STS  129,R30
; 0000 0099 ICR3L=0x00;
	STS  128,R30
; 0000 009A OCR3AH=0x00;
	STS  135,R30
; 0000 009B OCR3AL=0x00;
	STS  134,R30
; 0000 009C OCR3BH=0x00;
	STS  133,R30
; 0000 009D OCR3BL=0x00;
	STS  132,R30
; 0000 009E OCR3CH=0x00;
	STS  131,R30
; 0000 009F OCR3CL=0x00;
	STS  130,R30
; 0000 00A0 
; 0000 00A1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00A2 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 00A3 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 00A4 
; 0000 00A5 // External Interrupt(s) initialization
; 0000 00A6 // INT0: Off
; 0000 00A7 // INT1: Off
; 0000 00A8 // INT2: Off
; 0000 00A9 // INT3: Off
; 0000 00AA // INT4: Off
; 0000 00AB // INT5: Off
; 0000 00AC // INT6: Off
; 0000 00AD // INT7: Off
; 0000 00AE EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 00AF EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 00B0 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 00B1 
; 0000 00B2 // USART0 initialization
; 0000 00B3 // USART0 disabled
; 0000 00B4 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 00B5 
; 0000 00B6 // USART1 initialization
; 0000 00B7 // USART1 disabled
; 0000 00B8 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 00B9 
; 0000 00BA // Analog Comparator initialization
; 0000 00BB // Analog Comparator: Off
; 0000 00BC // The Analog Comparator's positive input is
; 0000 00BD // connected to the AIN0 pin
; 0000 00BE // The Analog Comparator's negative input is
; 0000 00BF // connected to the AIN1 pin
; 0000 00C0 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C1 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00C2 
; 0000 00C3 // ADC initialization
; 0000 00C4 // ADC disabled
; 0000 00C5 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00C6 
; 0000 00C7 // SPI initialization
; 0000 00C8 // SPI disabled
; 0000 00C9 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00CA 
; 0000 00CB // TWI initialization
; 0000 00CC // TWI disabled
; 0000 00CD TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 00CE 
; 0000 00CF // Graphic Display Controller initialization
; 0000 00D0 // The ST7920 connections are specified in the
; 0000 00D1 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00D2 // E - PORTB Bit 0
; 0000 00D3 // R /W - PORTB Bit 1
; 0000 00D4 // RS - PORTB Bit 2
; 0000 00D5 // /RST - PORTB Bit 3
; 0000 00D6 // DB4 - PORTB Bit 4
; 0000 00D7 // DB5 - PORTB Bit 5
; 0000 00D8 // DB6 - PORTB Bit 6
; 0000 00D9 // DB7 - PORTB Bit 7
; 0000 00DA //
; 0000 00DB //*
; 0000 00DC // Specify the current font for displaying text
; 0000 00DD glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 00DE // No function is used for reading
; 0000 00DF // image data from external memory
; 0000 00E0 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 00E1 // No function is used for writing
; 0000 00E2 // image data to external memory
; 0000 00E3 glcd_init_data.writexmem=NULL;
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 00E4 
; 0000 00E5 glcd_init(&glcd_init_data);
	MOVW R26,R28
	ADIW R26,10
	CALL _glcd_init
; 0000 00E6 
; 0000 00E7 if (lcd_buf[0])
	LDS  R30,_lcd_buf
	CPI  R30,0
	BREQ _0x3
; 0000 00E8 glcd_outtextxy(0,0,"START!");
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	__POINTW2MN _0x4,0
	CALL _glcd_outtextxy
; 0000 00E9 //           */
; 0000 00EA  lc75853n_init();
_0x3:
	RCALL _lc75853n_init
; 0000 00EB         send_lcd_bufer();
	RCALL _send_lcd_bufer
; 0000 00EC while (1)
_0x5:
; 0000 00ED       {
; 0000 00EE //lc75853n_key_scan();
; 0000 00EF //delay_ms(30);
; 0000 00F0 //sprintf(str,"%X -%X -%X -%X",lcd_key[0],lcd_key[1],lcd_key[2],lcd_key[3]);
; 0000 00F1 //glcd_outtextxy(0,0,str);
; 0000 00F2 for(t=0;t<126;t++) lc75853n_set_bit(t);
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,126
	BRSH _0xA
	MOV  R26,R17
	RCALL _lc75853n_set_bit
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 00F3 }
	RJMP _0x5
; 0000 00F4 }
_0xB:
	RJMP _0xB
; .FEND

	.DSEG
_0x4:
	.BYTE 0x7
;#include "lc75853n.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;#ifdef CV
;#include <delay.h>
;#define _delay_ms delay_ms
;#define _delay_us delay_us
;
;#else
;#include <avr/delay.h>
;#endif
;
;unsigned char lcd_buf[18];
;unsigned char lcd_key[4];
;unsigned char lcd_control=0b00110100;

	.DSEG
;
;void portsInit (void)
; 0001 0011 {

	.CSEG
_portsInit:
; .FSTART _portsInit
; 0001 0012 
; 0001 0013    //сконфигурируем ножки как выходы
; 0001 0014    DD_LC_PORT |= (1<<CE) | (1<<CL) | (1<<DI);
	IN   R30,0x11
	ORI  R30,LOW(0xB)
	OUT  0x11,R30
; 0001 0015    DD_LC_PORT &=~(1<<DO);
	CBI  0x11,2
; 0001 0016 
; 0001 0017    //Ставим все ножки выходов в 1. Это означает,
; 0001 0018    // что будет использоваться протокол с CL по умолчанию =1.
; 0001 0019    //На DO подключим нагрузочный резистор.
; 0001 001A    LC_PORT = (1<<CL) | (1<<DO);
	LDI  R30,LOW(6)
	OUT  0x12,R30
; 0001 001B    CE_LOW();
	CBI  0x12,0
; 0001 001C }
	RET
; .FEND
;
;///////////////////////////////
;static void BusPause(void)
; 0001 0020 {
_BusPause_G001:
; .FSTART _BusPause_G001
; 0001 0021    _delay_us(8);
	__DELAY_USB 43
; 0001 0022    return;
	RET
; 0001 0023 }
; .FEND
;
;///////////////////
;static void BusStrob(void)
; 0001 0027 {
; 0001 0028       CL_LOW();
; 0001 0029               BusPause();
; 0001 002A        CL_HIGH();
; 0001 002B    BusPause();
; 0001 002C        //SetBit(BUS_Port,BUS_BitClc);
; 0001 002D 
; 0001 002E }
;
;///////////////////////////
;// Выводит байт на шину DI микросхемы LC72131, старший бит идет первым.
;void BusOutH2L(u8 Bus)
; 0001 0033 {
_BusOutH2L:
; .FSTART _BusOutH2L
; 0001 0034    u8 i;
; 0001 0035 
; 0001 0036    for(i=0; i < 8; i++)
	ST   -Y,R26
	ST   -Y,R17
;	Bus -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x20005:
	CPI  R17,8
	BRSH _0x20006
; 0001 0037    {
; 0001 0038 
; 0001 0039    BusPause();
	RCALL _BusPause_G001
; 0001 003A           if(Bus & 0x80)
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x20007
; 0001 003B          DI_HIGH();     //SetBit(BUS_Port,BUS_BitDat);
	SBI  0x12,3
; 0001 003C       else
	RJMP _0x20008
_0x20007:
; 0001 003D          DI_LOW();      //ClrBit(BUS_Port,BUS_BitDat);
	CBI  0x12,3
; 0001 003E       CL_LOW();
_0x20008:
	CBI  0x12,1
; 0001 003F               BusPause();
	RCALL _BusPause_G001
; 0001 0040        CL_HIGH();
	SBI  0x12,1
; 0001 0041       Bus <<= 1;
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0001 0042    }
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0043    _delay_us(8);
	__DELAY_USB 43
; 0001 0044    return;
	LDD  R17,Y+0
	JMP  _0x2120003
; 0001 0045 }
; .FEND
;
;///////////////////////////
;// Выводит байт на шину DI микросхемы LC72131, младший бит идет первым.
;void BusOutL2H(u8 Bus)
; 0001 004A {
; 0001 004B    u8 i;
; 0001 004C 
; 0001 004D 
; 0001 004E 
; 0001 004F    for(i=0; i < 8; i++)
;	Bus -> Y+1
;	i -> R17
; 0001 0050    {
; 0001 0051 
; 0001 0052          BusPause();
; 0001 0053           if(Bus & 0x01)
; 0001 0054          DI_HIGH();     //SetBit(BUS_Port,BUS_BitDat);
; 0001 0055       else
; 0001 0056          DI_LOW();      //ClrBit(BUS_Port,BUS_BitDat);
; 0001 0057       CL_LOW();
; 0001 0058               BusPause();
; 0001 0059        CL_HIGH();
; 0001 005A       Bus >>= 1;
; 0001 005B    }
; 0001 005C    _delay_us(8);
; 0001 005D    return;
; 0001 005E }
;
;///////////////////////////
;// Читает байт с шины DO микросхемы LC72131, старший бит идет первым.
;void BusInH2L(u8* Bus)
; 0001 0063 {
; 0001 0064    u8 i;
; 0001 0065 
; 0001 0066    for(i=0; i < 8; i++)
;	*Bus -> Y+1
;	i -> R17
; 0001 0067    {
; 0001 0068       (*Bus) <<= 1;
; 0001 0069       if (DO_STATE())
; 0001 006A          (*Bus) |= 0x01;
; 0001 006B       BusStrob();
; 0001 006C    }
; 0001 006D    return;
; 0001 006E }
;
;///////////////////////////
;// Читает байт с шины DO микросхемы LC72131, младший бит идет первым.
;void BusInL2H(u8* Bus)
; 0001 0073 {
; 0001 0074    u8 i;
; 0001 0075 
; 0001 0076    for(i=0; i < 8; i++)
;	*Bus -> Y+1
;	i -> R17
; 0001 0077    {
; 0001 0078       (*Bus) >>= 1;
; 0001 0079       if (DO_STATE())
; 0001 007A          (*Bus) |= 0x80;
; 0001 007B       BusStrob();
; 0001 007C    }
; 0001 007D    return;
; 0001 007E }
;
;void lc75853n_key_scan(void){
; 0001 0080 void lc75853n_key_scan(void){
; 0001 0081  unsigned char i,ret;
; 0001 0082  BusOutL2H(MODE_OUT_ADR);
;	i -> R17
;	ret -> R16
; 0001 0083 BusPause();
; 0001 0084 CE_HIGH();
; 0001 0085 BusPause();
; 0001 0086 for (i=0;i<4;i++){
; 0001 0087  BusInH2L(&ret);
; 0001 0088  lcd_key[i]=ret;
; 0001 0089  }
; 0001 008A CE_LOW();
; 0001 008B BusPause();
; 0001 008C }
;
;void lc75853n_set_bit(unsigned char _bit){
; 0001 008E void lc75853n_set_bit(unsigned char _bit){
_lc75853n_set_bit:
; .FSTART _lc75853n_set_bit
; 0001 008F unsigned char i,d;
; 0001 0090 if (_bit<42){
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	_bit -> Y+2
;	i -> R17
;	d -> R16
	LDD  R26,Y+2
	CPI  R26,LOW(0x2A)
	BRSH _0x20019
; 0001 0091 i=_bit/8;
	CALL SUBOPT_0x0
; 0001 0092 d=_bit%8;
; 0001 0093 if (i==5) lcd_buf[i]|=(1<<(d+6));
	BRNE _0x2001A
	CALL SUBOPT_0x1
	SUBI R30,-LOW(6)
	RJMP _0x20036
; 0001 0094     else lcd_buf[i]|=(1<<d);
_0x2001A:
	CALL SUBOPT_0x1
_0x20036:
	LDI  R26,LOW(1)
	CALL SUBOPT_0x2
; 0001 0095 } else
	RJMP _0x2001C
_0x20019:
; 0001 0096     {if (_bit<84){
	LDD  R26,Y+2
	CPI  R26,LOW(0x54)
	BRSH _0x2001D
; 0001 0097 _bit-=42;
	LDD  R30,Y+2
	SUBI R30,LOW(42)
	STD  Y+2,R30
; 0001 0098 i=_bit/8;
	CALL SUBOPT_0x0
; 0001 0099 d=_bit%8;
; 0001 009A if (i==5) lcd_buf[i+6]|=(1<<(d+6));
	BRNE _0x2001E
	CALL SUBOPT_0x3
	SUBI R30,-LOW(6)
	RJMP _0x20037
; 0001 009B     else lcd_buf[i+6]|=(1<<d);
_0x2001E:
	CALL SUBOPT_0x3
_0x20037:
	LDI  R26,LOW(1)
	CALL SUBOPT_0x2
; 0001 009C     } else
	RJMP _0x20020
_0x2001D:
; 0001 009D     {
; 0001 009E _bit-=84;
	LDD  R30,Y+2
	SUBI R30,LOW(84)
	STD  Y+2,R30
; 0001 009F i=_bit/8;
	CALL SUBOPT_0x0
; 0001 00A0 d=_bit%8;
; 0001 00A1 if (i==5) lcd_buf[i+12]|=(1<<(d+6));
	BRNE _0x20021
	CALL SUBOPT_0x4
	SUBI R30,-LOW(6)
	RJMP _0x20038
; 0001 00A2     else lcd_buf[i+12]|=(1<<d);
_0x20021:
	CALL SUBOPT_0x4
_0x20038:
	LDI  R26,LOW(1)
	CALL SUBOPT_0x2
; 0001 00A3     }
_0x20020:
; 0001 00A4 }
_0x2001C:
; 0001 00A5 send_lcd_bufer();
	RCALL _send_lcd_bufer
; 0001 00A6 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120002
; .FEND
;
;void lc75853n_clr_bit(unsigned char _bit){
; 0001 00A8 void lc75853n_clr_bit(unsigned char _bit){
; 0001 00A9 unsigned char i,d;
; 0001 00AA if (_bit<42){
;	_bit -> Y+2
;	i -> R17
;	d -> R16
; 0001 00AB i=_bit/8;
; 0001 00AC d=_bit%8;
; 0001 00AD if (i==5) lcd_buf[i]&=~(1<<(d+6));
; 0001 00AE     else lcd_buf[i]&=~(1<<d);
; 0001 00AF } else
; 0001 00B0     {if (_bit<84){
; 0001 00B1 _bit-=42;
; 0001 00B2 i=_bit/8;
; 0001 00B3 d=_bit%8;
; 0001 00B4 if (i==5) lcd_buf[i+6]&=~(1<<(d+6));
; 0001 00B5     else lcd_buf[i+6]&=~(1<<d);
; 0001 00B6     } else
; 0001 00B7     {
; 0001 00B8 _bit-=84;
; 0001 00B9 i=_bit/8;
; 0001 00BA d=_bit%8;
; 0001 00BB if (i==5) lcd_buf[i+12]&=~(1<<(d+6));
; 0001 00BC     else lcd_buf[i+12]&=~(1<<d);
; 0001 00BD     }
; 0001 00BE }
; 0001 00BF send_lcd_bufer();
; 0001 00C0 }
;
;
;void send_lcd_bufer(void){
; 0001 00C3 void send_lcd_bufer(void){
_send_lcd_bufer:
; .FSTART _send_lcd_bufer
; 0001 00C4 unsigned char i;
; 0001 00C5 BusOutH2L(MODE_IN_ADR);
	ST   -Y,R17
;	i -> R17
	CALL SUBOPT_0x5
; 0001 00C6 //_delay_us(
; 0001 00C7 BusPause();
; 0001 00C8 CE_HIGH();
; 0001 00C9 BusPause();
; 0001 00CA  for (i=0;i<6;i++){
_0x2002E:
	CPI  R17,6
	BRSH _0x2002F
; 0001 00CB    BusOutH2L(lcd_buf[i]);
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	LD   R26,Z
	RCALL _BusOutH2L
; 0001 00CC  }
	SUBI R17,-1
	RJMP _0x2002E
_0x2002F:
; 0001 00CD  BusOutH2L(lcd_control);
	LDS  R26,_lcd_control
	CALL SUBOPT_0x6
; 0001 00CE CE_LOW();
; 0001 00CF DI_LOW();
; 0001 00D0 BusPause();
; 0001 00D1 
; 0001 00D2 BusOutH2L(MODE_IN_ADR);
; 0001 00D3 //_delay_us(
; 0001 00D4 BusPause();
; 0001 00D5 CE_HIGH();
; 0001 00D6 BusPause();
; 0001 00D7  for (i=0;i<6;i++){
_0x20031:
	CPI  R17,6
	BRSH _0x20032
; 0001 00D8    BusOutH2L(lcd_buf[i+6]);
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _lcd_buf,6
	LD   R26,Z
	RCALL _BusOutH2L
; 0001 00D9  }
	SUBI R17,-1
	RJMP _0x20031
_0x20032:
; 0001 00DA  BusOutH2L(0b00000001);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
; 0001 00DB CE_LOW();
; 0001 00DC DI_LOW();
; 0001 00DD BusPause();
; 0001 00DE 
; 0001 00DF BusOutH2L(MODE_IN_ADR);
; 0001 00E0 //_delay_us(
; 0001 00E1 BusPause();
; 0001 00E2 CE_HIGH();
; 0001 00E3 BusPause();
; 0001 00E4  for (i=0;i<6;i++){
_0x20034:
	CPI  R17,6
	BRSH _0x20035
; 0001 00E5   BusOutH2L(lcd_buf[i+12]);
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _lcd_buf,12
	LD   R26,Z
	RCALL _BusOutH2L
; 0001 00E6   }
	SUBI R17,-1
	RJMP _0x20034
_0x20035:
; 0001 00E7  BusOutH2L(0b00000010);
	LDI  R26,LOW(2)
	RCALL _BusOutH2L
; 0001 00E8 CE_LOW();
	CBI  0x12,0
; 0001 00E9 DI_LOW();
	CBI  0x12,3
; 0001 00EA BusPause();
	RCALL _BusPause_G001
; 0001 00EB 
; 0001 00EC }
	JMP  _0x2120009
; .FEND
;
;void lc75853n_init(void){
; 0001 00EE void lc75853n_init(void){
_lc75853n_init:
; .FSTART _lc75853n_init
; 0001 00EF unsigned char i,j;
; 0001 00F0 portsInit();
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	RCALL _portsInit
; 0001 00F1 };
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_st7920_delay_G101:
; .FSTART _st7920_delay_G101
    nop
    nop
    nop
	RET
; .FEND
_st7920_wrbus_G101:
; .FSTART _st7920_wrbus_G101
	ST   -Y,R26
	CBI  0x18,1
	SBI  0x18,0
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	RCALL _st7920_delay_G101
	CBI  0x18,0
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x18,R30
	CALL SUBOPT_0x7
	CBI  0x18,0
	RJMP _0x2120008
; .FEND
_st7920_rdbus_G101:
; .FSTART _st7920_rdbus_G101
	ST   -Y,R17
	SBI  0x18,1
	IN   R30,0x17
	ANDI R30,LOW(0xF)
	OUT  0x17,R30
	SBI  0x18,0
	RCALL _st7920_delay_G101
	IN   R30,0x16
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	CBI  0x18,0
	CALL SUBOPT_0x7
	IN   R30,0x16
	SWAP R30
	ANDI R30,0xF
	OR   R17,R30
	CBI  0x18,0
	MOV  R30,R17
	RJMP _0x2120009
; .FEND
_st7920_busy_G101:
; .FSTART _st7920_busy_G101
	ST   -Y,R17
	CBI  0x18,2
	SBI  0x18,1
	IN   R30,0x17
	ANDI R30,LOW(0xF)
	OUT  0x17,R30
_0x2020004:
	SBI  0x18,0
	RCALL _st7920_delay_G101
	IN   R30,0x16
	ANDI R30,LOW(0x80)
	LDI  R26,LOW(0)
	CALL __NEB12
	MOV  R17,R30
	CBI  0x18,0
	CALL SUBOPT_0x7
	CBI  0x18,0
	RCALL _st7920_delay_G101
	CPI  R17,0
	BRNE _0x2020004
	__DELAY_USB 5
_0x2120009:
	LD   R17,Y+
	RET
; .FEND
_st7920_wrdata:
; .FSTART _st7920_wrdata
	ST   -Y,R26
	RCALL _st7920_busy_G101
	SBI  0x18,2
	LD   R26,Y
	RCALL _st7920_wrbus_G101
	RJMP _0x2120008
; .FEND
_st7920_rddata:
; .FSTART _st7920_rddata
	RCALL _st7920_busy_G101
	SBI  0x18,2
	RCALL _st7920_rdbus_G101
	RET
; .FEND
_st7920_wrcmd:
; .FSTART _st7920_wrcmd
	ST   -Y,R26
	RCALL _st7920_busy_G101
	LD   R26,Y
	RCALL _st7920_wrbus_G101
	RJMP _0x2120008
; .FEND
_st7920_setxy_G101:
; .FSTART _st7920_setxy_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x1F)
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRLO _0x2020006
	LDD  R30,Y+1
	ORI  R30,0x80
	STD  Y+1,R30
_0x2020006:
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _st7920_wrcmd
	JMP  _0x2120003
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	CALL SUBOPT_0x8
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020007
	LDI  R30,LOW(12)
	RJMP _0x2020008
_0x2020007:
	LDI  R30,LOW(8)
_0x2020008:
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LD   R30,Y
	CPI  R30,0
	BREQ _0x202000A
	LDI  R30,LOW(2)
	RJMP _0x202000B
_0x202000A:
	LDI  R30,LOW(0)
_0x202000B:
	STS  _st7920_graphics_on_G101,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
_0x2120008:
	ADIW R28,1
	RET
; .FEND
_glcd_cleargraphics:
; .FSTART _glcd_cleargraphics
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x202000D
	LDI  R19,LOW(255)
_0x202000D:
	CALL SUBOPT_0x9
	LDI  R16,LOW(0)
_0x202000E:
	CPI  R16,64
	BRSH _0x2020010
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R16
	SUBI R16,-1
	RCALL _st7920_setxy_G101
	LDI  R17,LOW(16)
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	MOV  R26,R19
	RCALL _st7920_wrdata
	__DELAY_USB 5
	RJMP _0x2020011
_0x2020013:
	RJMP _0x202000E
_0x2020010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2120001
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x17,0
	CBI  0x18,0
	SBI  0x17,1
	SBI  0x18,1
	SBI  0x17,2
	CBI  0x18,2
	SBI  0x17,3
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x18,3
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,3
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x18,1
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	LDI  R17,LOW(0)
_0x2020015:
	CPI  R17,6
	BRSH _0x2020016
	SBI  0x18,0
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_st7920_init_4bit_G101*2)
	SBCI R31,HIGH(-_st7920_init_4bit_G101*2)
	LPM  R30,Z
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 27
	CBI  0x18,0
	__DELAY_USW 800
	SUBI R17,-1
	RJMP _0x2020015
_0x2020016:
	LDI  R26,LOW(8)
	RCALL _st7920_wrbus_G101
	__DELAY_USW 800
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _yt_G101,R30
	STS  _xt_G101,R30
	LDI  R26,LOW(6)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(36)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(64)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(2)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _st7920_graphics_on_G101,R30
	RCALL _glcd_cleargraphics
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2020017
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20200A6
_0x2020017:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20200A6:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	JMP  _0x2120002
; .FEND
_st7920_rdbyte_G101:
; .FSTART _st7920_rdbyte_G101
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _st7920_setxy_G101
	RCALL _st7920_rddata
	LDD  R30,Y+1
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRLO _0x2020019
	RCALL _st7920_rddata
	STS  _st7920_bits8_15_G101,R30
_0x2020019:
	RCALL _st7920_rddata
	JMP  _0x2120003
; .FEND
_st7920_wrbyte_G101:
; .FSTART _st7920_wrbyte_G101
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _st7920_setxy_G101
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0x8)
	BRLO _0x202001A
	LDS  R26,_st7920_bits8_15_G101
	RCALL _st7920_wrdata
_0x202001A:
	LD   R26,Y
	RCALL _st7920_wrdata
	JMP  _0x2120002
; .FEND
_st7920_wrmasked_G101:
; .FSTART _st7920_wrmasked_G101
	ST   -Y,R26
	ST   -Y,R17
	CALL SUBOPT_0x9
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	CALL SUBOPT_0xA
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x202002A
	CPI  R30,LOW(0x8)
	BRNE _0x202002B
_0x202002A:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x202002C
_0x202002B:
	CPI  R30,LOW(0x3)
	BRNE _0x202002E
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x202002F
_0x202002E:
	CPI  R30,0
	BRNE _0x2020030
_0x202002F:
	RJMP _0x2020031
_0x2020030:
	CPI  R30,LOW(0x9)
	BRNE _0x2020032
_0x2020031:
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0xA)
	BRNE _0x2020034
_0x2020033:
_0x202002C:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2020035
_0x2020034:
	CPI  R30,LOW(0x2)
	BRNE _0x2020036
_0x2020035:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2020028
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020037
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2020028
_0x2020037:
	CPI  R30,LOW(0x4)
	BRNE _0x2020028
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2020028:
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	MOV  R26,R17
	CALL _glcd_revbits
	MOV  R26,R30
	RCALL _st7920_wrbyte_G101
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,7
	CALL __SAVELOCR6
	LDD  R26,Y+20
	CPI  R26,LOW(0x80)
	BRSH _0x202003A
	LDD  R26,Y+19
	CPI  R26,LOW(0x40)
	BRSH _0x202003A
	LDD  R26,Y+18
	CPI  R26,LOW(0x0)
	BREQ _0x202003A
	LDD  R26,Y+17
	CPI  R26,LOW(0x0)
	BRNE _0x2020039
_0x202003A:
	RJMP _0x2120007
_0x2020039:
	LDD  R30,Y+18
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R18,R30
	__PUTBSR 18,8
	LDD  R30,Y+18
	ANDI R30,LOW(0x7)
	STD  Y+11,R30
	CPI  R30,0
	BREQ _0x202003C
	LDD  R30,Y+8
	SUBI R30,-LOW(1)
	STD  Y+8,R30
_0x202003C:
	LDD  R16,Y+18
	LDD  R26,Y+20
	CLR  R27
	LDD  R30,Y+18
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x202003D
	LDD  R26,Y+20
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+18,R30
_0x202003D:
	LDD  R30,Y+17
	STD  Y+10,R30
	LDD  R26,Y+19
	CLR  R27
	LDD  R30,Y+17
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x202003E
	LDD  R26,Y+19
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+17,R30
_0x202003E:
	LDD  R30,Y+13
	CPI  R30,LOW(0x6)
	BREQ PC+2
	RJMP _0x2020042
	LDD  R30,Y+16
	CPI  R30,LOW(0x1)
	BRNE _0x2020046
	RJMP _0x2120007
_0x2020046:
	CPI  R30,LOW(0x3)
	BRNE _0x2020049
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2020048
	RJMP _0x2120007
_0x2020048:
_0x2020049:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x202004B
	LDD  R26,Y+18
	CP   R16,R26
	BREQ _0x202004A
_0x202004B:
	MOV  R30,R18
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R31,0
	CALL SUBOPT_0xB
	LDD  R17,Y+17
_0x202004D:
	CPI  R17,0
	BREQ _0x202004F
	MOV  R19,R18
_0x2020050:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2020052
	CALL SUBOPT_0xC
	RJMP _0x2020050
_0x2020052:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0xB
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004F:
_0x202004A:
	LDD  R18,Y+17
	LDD  R30,Y+10
	CP   R30,R18
	BREQ _0x2020053
	MOV  R26,R18
	CLR  R27
	LDD  R30,Y+8
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0xB
_0x2020054:
	PUSH R18
	SUBI R18,-1
	LDD  R30,Y+10
	POP  R26
	CP   R26,R30
	BRSH _0x2020056
	LDI  R19,LOW(0)
_0x2020057:
	PUSH R19
	SUBI R19,-1
	LDD  R30,Y+8
	POP  R26
	CP   R26,R30
	BRSH _0x2020059
	CALL SUBOPT_0xC
	RJMP _0x2020057
_0x2020059:
	RJMP _0x2020054
_0x2020056:
_0x2020053:
	RJMP _0x2020041
_0x2020042:
	CPI  R30,LOW(0x9)
	BRNE _0x202005A
	LDI  R30,LOW(0)
	RJMP _0x20200A7
_0x202005A:
	CPI  R30,LOW(0xA)
	BRNE _0x2020041
	LDI  R30,LOW(255)
_0x20200A7:
	STD  Y+10,R30
	ST   -Y,R30
	LDD  R26,Y+14
	CALL _glcd_mappixcolor1bit
	STD  Y+10,R30
_0x2020041:
	LDD  R30,Y+20
	ANDI R30,LOW(0x7)
	MOV  R19,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	MOV  R21,R18
	LDD  R26,Y+18
	CP   R18,R26
	BRLO _0x202005E
	LDD  R21,Y+18
	RJMP _0x202005F
_0x202005E:
	CPI  R19,0
	BREQ _0x2020060
	MOV  R20,R19
	LDD  R26,Y+18
	CPI  R26,LOW(0x9)
	BRSH _0x2020061
	LDD  R30,Y+18
	SUB  R30,R18
	MOV  R20,R30
_0x2020061:
	MOV  R30,R20
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
_0x2020060:
_0x202005F:
	ST   -Y,R19
	MOV  R26,R21
	CALL _glcd_getmask
	MOV  R21,R30
	LDD  R26,Y+11
	CP   R18,R26
	BRSH _0x2020062
	LDD  R30,Y+11
	SUB  R30,R18
	STD  Y+11,R30
_0x2020062:
	LDD  R30,Y+11
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R0,Z
	STD  Y+12,R0
	CALL SUBOPT_0x9
_0x2020063:
	LDD  R30,Y+17
	SUBI R30,LOW(1)
	STD  Y+17,R30
	SUBI R30,-LOW(1)
	BRNE PC+2
	RJMP _0x2020065
	LDI  R17,LOW(0)
	LDD  R16,Y+20
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	CPI  R19,0
	BRNE PC+2
	RJMP _0x2020066
	__PUTBSR 20,11
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2020067
_0x2020068:
	LDD  R30,Y+18
	CP   R17,R30
	BRLO PC+2
	RJMP _0x202006A
	ST   -Y,R16
	LDD  R26,Y+20
	CALL SUBOPT_0xA
	AND  R30,R21
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	STD  Y+9,R30
	CALL SUBOPT_0xD
	MOV  R1,R30
	MOV  R30,R19
	MOV  R26,R21
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	LDD  R26,Y+9
	OR   R30,R26
	STD  Y+9,R30
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x202006C
	MOV  R30,R16
	LSR  R30
	LSR  R30
	LSR  R30
	CPI  R30,LOW(0xF)
	BRLO _0x202006B
_0x202006C:
	CALL SUBOPT_0xE
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+12
	CALL _glcd_writemem
	RJMP _0x202006A
_0x202006B:
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	BRSH _0x202006E
	LDD  R30,Y+12
	STD  Y+11,R30
_0x202006E:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R26,Y+20
	CALL SUBOPT_0xA
	LDD  R26,Y+11
	AND  R30,R26
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	STD  Y+10,R30
	MOV  R30,R18
	LDD  R26,Y+11
	CALL __LSLB12
	COM  R30
	LDD  R26,Y+9
	AND  R30,R26
	LDD  R26,Y+10
	OR   R30,R26
	STD  Y+10,R30
	CALL SUBOPT_0xE
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+13
	CALL _glcd_writemem
	SUBI R17,-LOW(8)
	RJMP _0x2020068
_0x202006A:
	RJMP _0x202006F
_0x2020067:
_0x2020070:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2020072
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x2020077
	CPI  R30,LOW(0xA)
	BRNE _0x2020079
_0x2020077:
	RJMP _0x2020075
_0x2020079:
	CALL SUBOPT_0xE
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	CALL _glcd_readmem
	STD  Y+10,R30
_0x2020075:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	MOV  R30,R19
	LDD  R26,Y+12
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R21
	LDD  R26,Y+17
	RCALL _st7920_wrmasked_G101
	LDD  R26,Y+18
	CP   R18,R26
	BRSH _0x2020072
	MOV  R30,R16
	LSR  R30
	LSR  R30
	LSR  R30
	CPI  R30,LOW(0xF)
	BRSH _0x2020072
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	BRSH _0x202007C
	LDD  R30,Y+12
	STD  Y+11,R30
_0x202007C:
	SUBI R16,-LOW(8)
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	MOV  R30,R18
	LDD  R26,Y+12
	CALL __LSRB12
	CALL SUBOPT_0xF
	SUBI R17,-LOW(8)
	RJMP _0x2020070
_0x2020072:
_0x202006F:
	RJMP _0x202007D
_0x2020066:
	__PUTBSR 21,11
_0x202007E:
	LDD  R30,Y+18
	CP   R17,R30
	BRSH _0x2020080
	LDD  R26,Y+18
	SUB  R26,R17
	CPI  R26,LOW(0x8)
	BRSH _0x2020081
	LDD  R30,Y+12
	STD  Y+11,R30
_0x2020081:
	LDD  R30,Y+13
	CPI  R30,LOW(0x9)
	BREQ _0x2020086
	CPI  R30,LOW(0xA)
	BRNE _0x2020088
_0x2020086:
	RJMP _0x2020084
_0x2020088:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x202008A
	LDD  R26,Y+11
	CPI  R26,LOW(0xFF)
	BREQ _0x2020089
_0x202008A:
	CALL SUBOPT_0xD
	STD  Y+10,R30
_0x2020089:
_0x2020084:
	LDD  R26,Y+13
	CPI  R26,LOW(0x6)
	BRNE _0x202008C
	CALL SUBOPT_0xE
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R16
	LDD  R26,Y+23
	CALL SUBOPT_0xA
	LDD  R26,Y+14
	AND  R30,R26
	MOV  R0,R30
	LDD  R30,Y+14
	COM  R30
	LDD  R26,Y+13
	AND  R30,R26
	OR   R30,R0
	MOV  R26,R30
	CALL _glcd_writemem
	RJMP _0x202008D
_0x202008C:
	ST   -Y,R16
	LDD  R30,Y+20
	ST   -Y,R30
	LDD  R30,Y+12
	CALL SUBOPT_0xF
_0x202008D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SUBI R16,-LOW(8)
	SUBI R17,-LOW(8)
	RJMP _0x202007E
_0x2020080:
_0x202007D:
	LDD  R30,Y+19
	SUBI R30,-LOW(1)
	STD  Y+19,R30
	LDD  R30,Y+8
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x2020063
_0x2020065:
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,21
	RET
; .FEND
_glcd_putcharcg:
; .FSTART _glcd_putcharcg
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRLO _0x2020090
	LDI  R30,LOW(15)
	STD  Y+4,R30
_0x2020090:
	LDD  R26,Y+3
	CPI  R26,LOW(0x4)
	BRLO _0x2020091
	LDI  R30,LOW(3)
	STD  Y+3,R30
_0x2020091:
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G101*2)
	SBCI R31,HIGH(-_st7920_base_y_G101*2)
	LPM  R26,Z
	LDD  R30,Y+4
	LSR  R30
	OR   R30,R26
	MOV  R17,R30
	CALL SUBOPT_0x8
	MOV  R26,R17
	RCALL _st7920_wrcmd
	RCALL _st7920_rddata
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2020092
	RCALL _st7920_rddata
	MOV  R16,R30
_0x2020092:
	MOV  R26,R17
	RCALL _st7920_wrcmd
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2020093
	MOV  R26,R16
	RCALL _st7920_wrdata
_0x2020093:
	LDD  R26,Y+2
	RCALL _st7920_wrdata
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120004
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x10
	BRLT _0x2040003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120003
_0x2040003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2040004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2120003
_0x2040004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x10
	BRLT _0x2040005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120003
_0x2040005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2040006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2120003
_0x2040006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2120003
; .FEND
_glcd_getcharw_G102:
; .FSTART _glcd_getcharw_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x11
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x204000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x204000B:
	CALL SUBOPT_0x12
	STD  Y+7,R0
	CALL SUBOPT_0x12
	STD  Y+6,R0
	CALL SUBOPT_0x12
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x204000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x204000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x204000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120006
_0x204000D:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x204000E
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+7
	ANDI R30,LOW(0x7)
	BREQ _0x204000F
	SUBI R20,-LOW(1)
_0x204000F:
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+6
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2120006
_0x204000E:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2040010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2040012
	MOVW R30,R18
	LPM  R30,Z
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	ANDI R30,LOW(0x7)
	BREQ _0x2040013
	SUBI R20,-LOW(1)
_0x2040013:
	LDD  R26,Y+6
	CLR  R27
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2040010
_0x2040012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2120006:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G102:
; .FSTART _glcd_new_line_G102
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x14
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x11
	SBIW R30,0
	BRNE PC+2
	RJMP _0x2040020
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2040021
	RJMP _0x2040022
_0x2040021:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G102
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2040023
	RJMP _0x2120005
_0x2040023:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2040024
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G102
_0x2040024:
	CALL SUBOPT_0x15
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x13
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	CALL SUBOPT_0x16
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x13
	CALL SUBOPT_0x17
	CALL SUBOPT_0x16
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x13
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x17
	RCALL _glcd_block
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2040025
_0x2040022:
	RCALL _glcd_new_line_G102
	RJMP _0x2120005
_0x2040025:
	RJMP _0x2040026
_0x2040020:
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BREQ _0x2040028
	__GETB1MN _glcd_state,2
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	__GETB1MN _glcd_state,3
	SWAP R30
	ANDI R30,0xF
	MOV  R18,R30
	ST   -Y,R19
	ST   -Y,R18
	LDD  R26,Y+9
	RCALL _glcd_putcharcg
	MOV  R30,R19
	LSL  R30
	LSL  R30
	LSL  R30
	__PUTB1MN _glcd_state,2
	LDI  R26,LOW(16)
	MUL  R18,R26
	MOVW R30,R0
	__PUTB1MN _glcd_state,3
	CALL SUBOPT_0x15
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(16)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x16
	LDI  R31,0
	ADIW R30,8
	MOVW R16,R30
	__CPWRN 16,17,128
	BRLO _0x2040029
_0x2040028:
	__GETWRN 16,17,0
	__GETB1MN _glcd_state,3
	LDI  R31,0
	ADIW R30,16
	MOVW R26,R30
	CALL SUBOPT_0x14
_0x2040029:
_0x2040026:
	__PUTBMRN _glcd_state,2,16
_0x2120005:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x204002A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204002C
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x204002A
_0x204002C:
	LDD  R17,Y+0
	RJMP _0x2120004
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	CALL SUBOPT_0x14
	RJMP _0x2120003
; .FEND

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120004:
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x2100018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND
_glcd_revbits:
; .FSTART _glcd_revbits
	ST   -Y,R26
    ld  r26,y+
    bst r26,0
    bld r30,7

    bst r26,1
    bld r30,6

    bst r26,2
    bld r30,5

    bst r26,3
    bld r30,4

    bst r26,4
    bld r30,3

    bst r26,5
    bld r30,2

    bst r26,6
    bld r30,1

    bst r26,7
    bld r30,0
    ret
; .FEND

	.DSEG
_lcd_buf:
	.BYTE 0x12
_lcd_control:
	.BYTE 0x1
_lcd_key:
	.BYTE 0x4
_glcd_state:
	.BYTE 0x1D
_st7920_graphics_on_G101:
	.BYTE 0x1
_st7920_bits8_15_G101:
	.BYTE 0x1
_xt_G101:
	.BYTE 0x1
_yt_G101:
	.BYTE 0x1
__seed_G107:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	LDD  R30,Y+2
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R17,R30
	LDD  R30,Y+2
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	CPI  R17,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buf)
	SBCI R31,HIGH(-_lcd_buf)
	MOVW R22,R30
	LD   R1,Z
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CALL __LSLB12
	OR   R30,R1
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _lcd_buf,6
	MOVW R22,R30
	LD   R1,Z
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _lcd_buf,12
	MOVW R22,R30
	LD   R1,Z
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(66)
	CALL _BusOutH2L
	CALL _BusPause_G001
	SBI  0x12,0
	CALL _BusPause_G001
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	CALL _BusOutH2L
	CBI  0x12,0
	CBI  0x12,3
	CALL _BusPause_G001
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	CALL _st7920_delay_G101
	SBI  0x18,0
	JMP  _st7920_delay_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDS  R30,_st7920_graphics_on_G101
	ORI  R30,0x20
	MOV  R26,R30
	JMP  _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDS  R30,_st7920_graphics_on_G101
	ORI  R30,LOW(0x24)
	MOV  R26,R30
	JMP  _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	CALL _st7920_rdbyte_G101
	MOV  R26,R30
	JMP  _glcd_revbits

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xC:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R26,Y+17
	JMP  _st7920_wrmasked_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL _glcd_block
	__GETB1MN _glcd_state,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
