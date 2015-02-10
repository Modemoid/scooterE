
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _adc_data=R4
	.DEF _adc_data_msb=R5
	.DEF _Vol=R7
	.DEF _NewState=R8
	.DEF _NewState_msb=R9
	.DEF _OldState=R10
	.DEF _OldState_msb=R11
	.DEF _upState=R12
	.DEF _upState_msb=R13
	.DEF __lcd_x=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP _timer1_compb_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x53,0x74,0x61,0x72,0x74,0x21,0x0,0x72
	.DB  0x68,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x68,0x2D,0x25,0x32,0x75,0x6D,0x2D,0x25
	.DB  0x32,0x75,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x73,0x2D,0x25,0x32,0x75,0x20
	.DB  0x25,0x32,0x64,0x0,0x53,0x65,0x6C,0x54
	.DB  0x69,0x6D,0x65,0x72,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x54,0x69,0x6D,0x65
	.DB  0x72,0x25,0x75,0x0,0x54,0x69,0x6D,0x65
	.DB  0x72,0x4E,0x6F,0x25,0x75,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x74,0x69,0x6D
	.DB  0x65,0x3D,0x25,0x75,0x0,0x57,0x72,0x69
	.DB  0x74,0x65,0x4E,0x6F,0x25,0x75,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x74,0x6F
	.DB  0x4D,0x65,0x6D,0x6F,0x72,0x79,0x0,0x57
	.DB  0x72,0x69,0x74,0x65,0x4E,0x6F,0x25,0x75
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x4F,0x6B,0x0,0x45,0x6E,0x61,0x62,0x6C
	.DB  0x65,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x74,0x65,0x73,0x74,0x4D
	.DB  0x6F,0x64,0x65,0x0,0x45,0x6E,0x61,0x62
	.DB  0x6C,0x65,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x54,0x6D,0x6F,0x64,0x65,0x20
	.DB  0x4F,0x6B,0x0,0x50,0x4F,0x52,0x54,0x20
	.DB  0x4E,0x6F,0x25,0x75,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x53,0x77,0x69,0x74
	.DB  0x63,0x68,0x0,0x50,0x4F,0x52,0x54,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x53,0x77
	.DB  0x69,0x74,0x63,0x68,0x4F,0x6B,0x0,0x72
	.DB  0x74,0x74,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x74,0x31,0x3D,0x25,0x32,0x75,0x20,0x25
	.DB  0x75,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x74,0x32,0x3D,0x25,0x32,0x75
	.DB  0x0,0x41,0x64,0x64,0x72,0x65,0x73,0x73
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x57,0x52,0x49,0x54,0x45,0x20,0x4F
	.DB  0x6B,0x0,0x25,0x32,0x58,0x25,0x32,0x58
	.DB  0x25,0x32,0x58,0x25,0x32,0x58,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x25,0x32
	.DB  0x58,0x25,0x32,0x58,0x20,0x74,0x25,0x32
	.DB  0x75,0x0,0x73,0x65,0x6C,0x20,0x74,0x65
	.DB  0x72,0x6D,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x25,0x75,0x0,0x48,0x54,0x65
	.DB  0x6D,0x70,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x57,0x52,0x49
	.DB  0x54,0x45,0x20,0x4F,0x6B,0x0,0x48,0x4C
	.DB  0x65,0x76,0x65,0x6C,0x20,0x54,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x25,0x33
	.DB  0x75,0x20,0x20,0x25,0x33,0x75,0x0,0x53
	.DB  0x65,0x6C,0x20,0x52,0x65,0x6C,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x25
	.DB  0x75,0x54,0x49,0x4D,0x45,0x52,0x0,0x53
	.DB  0x65,0x6C,0x20,0x52,0x65,0x6C,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x25
	.DB  0x75,0x74,0x65,0x72,0x6D,0x0,0x4C,0x54
	.DB  0x65,0x6D,0x70,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x57,0x52
	.DB  0x49,0x54,0x45,0x20,0x4F,0x6B,0x0,0x4C
	.DB  0x4C,0x65,0x76,0x65,0x6C,0x20,0x54,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x25
	.DB  0x33,0x75,0x20,0x20,0x25,0x33,0x75,0x0
	.DB  0x53,0x65,0x6C,0x20,0x52,0x65,0x6C,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x31,0x75,0x20,0x4C,0x4F,0x57,0x20
	.DB  0x74,0x6D,0x0,0x53,0x65,0x6C,0x20,0x52
	.DB  0x65,0x6C,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x25,0x31,0x75,0x20,0x68
	.DB  0x69,0x20,0x20,0x74,0x6D,0x0,0x50,0x75
	.DB  0x6C,0x73,0x65,0x47,0x65,0x6E,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x4F,0x4E
	.DB  0x20,0x25,0x75,0x20,0x4F,0x42,0x0,0x50
	.DB  0x75,0x6C,0x73,0x65,0x47,0x65,0x6E,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x4F
	.DB  0x46,0x46,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x52,0x65,0x73,0x74,0x61,0x72,0x74,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x63
	.DB  0x6C,0x6F,0x63,0x6B,0x0,0x52,0x65,0x73
	.DB  0x74,0x61,0x72,0x74,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x63,0x6C,0x6F,0x63
	.DB  0x6B,0x2D,0x4F,0x6B,0x0,0x56,0x6F,0x6C
	.DB  0x74,0x6D,0x65,0x74,0x72,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x25,0x31,0x2E
	.DB  0x33,0x66,0x56,0x6F,0x6C,0x0,0x50,0x72
	.DB  0x65,0x73,0x73,0x65,0x64,0x20,0x62,0x75
	.DB  0x74,0x74,0x6F,0x6E,0x20,0x20,0x20,0x25
	.DB  0x58,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _0x30
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x30+7
	.DW  _0x0*2+7

	.DW  0x11
	.DW  _0x30+24
	.DW  _0x0*2+7

	.DW  0x11
	.DW  _0x30+41
	.DW  _0x0*2+239

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;    /*****************************************************
;    This program was produced by the
;    CodeWizardAVR V2.05.0 Professional
;    Automatic Program Generator
;    © Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;    http://www.hpinfotech.com
;
;    Project :
;    Version :
;    Date    : 18.01.2015
;    Author  :
;    Company :
;    Comments:
;
;
;    Chip type               : ATmega8
;    Program type            : Application
;    AVR Core Clock frequency: 16,000000 MHz
;    Memory model            : Small
;    External RAM size       : 0
;    Data Stack size         : 256
;    *****************************************************/
;
;    #include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;    #include <stdio.h>
;    #include <delay.h>
;
;
;    #include "MSCS_lib.h"
;
;    // Alphanumeric LCD Module functions
;    #include <alcd.h>
;
;    #define FIRST_ADC_INPUT 7
;    unsigned int adc_data;
;    #define ADC_VREF_TYPE 0x40//0xC0
;
;    // ADC interrupt service routine
;    // with auto input scanning
;    interrupt [ADC_INT] void adc_isr(void)
; 0000 0029     {

	.CSEG
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R24
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 002A     // Read the AD conversion result
; 0000 002B     adc_data=ADCW;
	__INWR 4,5,4
; 0000 002C 
; 0000 002D     ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff));
	LDI  R30,LOW(71)
	OUT  0x7,R30
; 0000 002E     // Delay needed for the stabilization of the ADC input voltage
; 0000 002F     delay_us(10);
	__DELAY_USB 53
; 0000 0030     // Start the AD conversion
; 0000 0031     ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0032     }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R24,Y+
	RETI
; .FEND
;
;    // Declare your global variables here
;    unsigned char Vol;
;    unsigned int NewState=0,OldState=0,upState=0,downState=0,Vol_int;
;
;    // Timer1 output compare A interrupt service routine
;    interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 003A     {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 003B     TCNT1=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 003C     PORTB.2=0;
	CBI  0x18,2
; 0000 003D     }
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;    // Timer1 output compare B interrupt service routine
;    interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 0041     {
_timer1_compb_isr:
; .FSTART _timer1_compb_isr
; 0000 0042     // Place your code here
; 0000 0043     PORTB.2=1;
	SBI  0x18,2
; 0000 0044     }
	RETI
; .FEND
;
;
;    unsigned char encoder(unsigned char val){
; 0000 0047 unsigned char encoder(unsigned char val){
_encoder:
; .FSTART _encoder
; 0000 0048     unsigned char r;
; 0000 0049     //for (r=0;r<=16;r++)
; 0000 004A     {
	ST   -Y,R26
	RCALL SUBOPT_0x0
;	val -> Y+1
;	r -> R17
; 0000 004B     NewState=PINB & 0b00000011;
; 0000 004C     if(NewState!=OldState)
	BREQ _0x7
; 0000 004D     {
; 0000 004E 
; 0000 004F     switch(OldState)
	RCALL SUBOPT_0x1
; 0000 0050         {
; 0000 0051         case 2:
	BRNE _0xB
; 0000 0052             {
; 0000 0053             if(NewState == 3) upState++;
	RCALL SUBOPT_0x2
	BRNE _0xC
	RCALL SUBOPT_0x3
; 0000 0054             if(NewState == 0) downState++;
_0xC:
	RCALL SUBOPT_0x4
	BRNE _0xD
	RCALL SUBOPT_0x5
; 0000 0055             break;
_0xD:
	RJMP _0xA
; 0000 0056             }
; 0000 0057 
; 0000 0058         case 0:
_0xB:
	SBIW R30,0
	BRNE _0xE
; 0000 0059             {
; 0000 005A             if(NewState == 2) upState++;
	RCALL SUBOPT_0x6
	BRNE _0xF
	RCALL SUBOPT_0x3
; 0000 005B             if(NewState == 1) downState++;
_0xF:
	RCALL SUBOPT_0x7
	BRNE _0x10
	RCALL SUBOPT_0x5
; 0000 005C             break;
_0x10:
	RJMP _0xA
; 0000 005D             }
; 0000 005E         case 1:
_0xE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11
; 0000 005F             {
; 0000 0060             if(NewState == 0) upState++;
	RCALL SUBOPT_0x4
	BRNE _0x12
	RCALL SUBOPT_0x3
; 0000 0061             if(NewState == 3) downState++;
_0x12:
	RCALL SUBOPT_0x2
	BRNE _0x13
	RCALL SUBOPT_0x5
; 0000 0062             break;
_0x13:
	RJMP _0xA
; 0000 0063             }
; 0000 0064         case 3:
_0x11:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA
; 0000 0065             {
; 0000 0066             if(NewState == 1) upState++;
	RCALL SUBOPT_0x7
	BRNE _0x15
	RCALL SUBOPT_0x3
; 0000 0067             if(NewState == 2) downState++;
_0x15:
	RCALL SUBOPT_0x6
	BRNE _0x16
	RCALL SUBOPT_0x5
; 0000 0068             break;
_0x16:
; 0000 0069             }
; 0000 006A         }
_0xA:
; 0000 006B     OldState=NewState;
	MOVW R10,R8
; 0000 006C     }
; 0000 006D      if (upState >= 4)
_0x7:
	RCALL SUBOPT_0x8
	BRLO _0x17
; 0000 006E           {
; 0000 006F             val--;
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
; 0000 0070             upState = 0;
	CLR  R12
	CLR  R13
; 0000 0071           }
; 0000 0072           if (downState >= 4)
_0x17:
	RCALL SUBOPT_0x9
	BRLO _0x18
; 0000 0073           {
; 0000 0074             val++;
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	STD  Y+1,R30
; 0000 0075             downState = 0;
	RCALL SUBOPT_0xA
; 0000 0076           }
; 0000 0077     }
_0x18:
; 0000 0078      return val;
	LDD  R30,Y+1
	LDD  R17,Y+0
	RJMP _0x20C0005
; 0000 0079     }
; .FEND
;
;    unsigned int encoder_int(unsigned int val,unsigned int dec){
; 0000 007B unsigned int encoder_int(unsigned int val,unsigned int dec){
_encoder_int:
; .FSTART _encoder_int
; 0000 007C     unsigned char r;
; 0000 007D     //for (r=0;r<=16;r++)
; 0000 007E     {
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x0
;	val -> Y+3
;	dec -> Y+1
;	r -> R17
; 0000 007F     NewState=PINB & 0b00000011;
; 0000 0080     if(NewState!=OldState)
	BREQ _0x19
; 0000 0081     {
; 0000 0082 
; 0000 0083     switch(OldState)
	RCALL SUBOPT_0x1
; 0000 0084         {
; 0000 0085         case 2:
	BRNE _0x1D
; 0000 0086             {
; 0000 0087             if(NewState == 3) upState++;
	RCALL SUBOPT_0x2
	BRNE _0x1E
	RCALL SUBOPT_0x3
; 0000 0088             if(NewState == 0) downState++;
_0x1E:
	RCALL SUBOPT_0x4
	BRNE _0x1F
	RCALL SUBOPT_0x5
; 0000 0089             break;
_0x1F:
	RJMP _0x1C
; 0000 008A             }
; 0000 008B 
; 0000 008C         case 0:
_0x1D:
	SBIW R30,0
	BRNE _0x20
; 0000 008D             {
; 0000 008E             if(NewState == 2) upState++;
	RCALL SUBOPT_0x6
	BRNE _0x21
	RCALL SUBOPT_0x3
; 0000 008F             if(NewState == 1) downState++;
_0x21:
	RCALL SUBOPT_0x7
	BRNE _0x22
	RCALL SUBOPT_0x5
; 0000 0090             break;
_0x22:
	RJMP _0x1C
; 0000 0091             }
; 0000 0092         case 1:
_0x20:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x23
; 0000 0093             {
; 0000 0094             if(NewState == 0) upState++;
	RCALL SUBOPT_0x4
	BRNE _0x24
	RCALL SUBOPT_0x3
; 0000 0095             if(NewState == 3) downState++;
_0x24:
	RCALL SUBOPT_0x2
	BRNE _0x25
	RCALL SUBOPT_0x5
; 0000 0096             break;
_0x25:
	RJMP _0x1C
; 0000 0097             }
; 0000 0098         case 3:
_0x23:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1C
; 0000 0099             {
; 0000 009A             if(NewState == 1) upState++;
	RCALL SUBOPT_0x7
	BRNE _0x27
	RCALL SUBOPT_0x3
; 0000 009B             if(NewState == 2) downState++;
_0x27:
	RCALL SUBOPT_0x6
	BRNE _0x28
	RCALL SUBOPT_0x5
; 0000 009C             break;
_0x28:
; 0000 009D             }
; 0000 009E         }
_0x1C:
; 0000 009F     OldState=NewState;
	MOVW R10,R8
; 0000 00A0     }
; 0000 00A1      if (upState >= 4)
_0x19:
	RCALL SUBOPT_0x8
	BRLO _0x29
; 0000 00A2           {
; 0000 00A3             val-=dec;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 00A4             upState = 0;
	CLR  R12
	CLR  R13
; 0000 00A5           }
; 0000 00A6           if (downState >= 4)
_0x29:
	RCALL SUBOPT_0x9
	BRLO _0x2A
; 0000 00A7           {
; 0000 00A8             val+=dec;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 00A9             downState = 0;
	RCALL SUBOPT_0xA
; 0000 00AA           }
; 0000 00AB     }
_0x2A:
; 0000 00AC      return val;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LDD  R17,Y+0
	RJMP _0x20C0008
; 0000 00AD     }
; .FEND
;
;
;    void MSCS_com_veryfy(unsigned char *data,unsigned char ret[17]){
; 0000 00B0 void MSCS_com_veryfy(unsigned char *data,unsigned char ret[17]){
_MSCS_com_veryfy:
; .FSTART _MSCS_com_veryfy
; 0000 00B1     MSCS_com(data,ret);
	RCALL SUBOPT_0xB
;	*data -> Y+2
;	ret -> Y+0
	RCALL SUBOPT_0xC
; 0000 00B2     while(!((ret[12]=='g')&&(ret[13]=='e')&&(ret[14]=='r')&&(ret[15]=='b'))){
_0x2B:
	RCALL SUBOPT_0xD
	ADIW R26,12
	LD   R26,X
	CPI  R26,LOW(0x67)
	BRNE _0x2E
	RCALL SUBOPT_0xD
	ADIW R26,13
	LD   R26,X
	CPI  R26,LOW(0x65)
	BRNE _0x2E
	RCALL SUBOPT_0xD
	ADIW R26,14
	LD   R26,X
	CPI  R26,LOW(0x72)
	BRNE _0x2E
	RCALL SUBOPT_0xD
	ADIW R26,15
	LD   R26,X
	CPI  R26,LOW(0x62)
	BREQ _0x2D
_0x2E:
; 0000 00B3     MSCS_com(data,ret);
	RCALL SUBOPT_0xC
; 0000 00B4     }
	RJMP _0x2B
_0x2D:
; 0000 00B5     }
	RJMP _0x20C0003
; .FEND
;
;    void main(void)
; 0000 00B8     {
_main:
; .FSTART _main
; 0000 00B9     // Declare your local variables here
; 0000 00BA     unsigned char buf[32],buf1[17],buf2[17];
; 0000 00BB     float ft;
; 0000 00BC     unsigned char k,m1,m2=0,m3=0,m4=0; //m1-galet switcher m2 - timer for read to Vol - 1-6 m3 - port POWER m4 - pulsege ...
; 0000 00BD 
; 0000 00BE     // Input/Output Ports initialization
; 0000 00BF     // Port B initialization
; 0000 00C0     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C1     // State7=T State6=T State5=T State4=T State3=T State2=T State1=P State0=P
; 0000 00C2     PORTB=0x03;
	SBIW R28,63
	SBIW R28,7
;	buf -> Y+38
;	buf1 -> Y+21
;	buf2 -> Y+4
;	ft -> Y+0
;	k -> R17
;	m1 -> R16
;	m2 -> R19
;	m3 -> R18
;	m4 -> R21
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R30,LOW(3)
	OUT  0x18,R30
; 0000 00C3     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 00C4     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(4)
	OUT  0x17,R30
; 0000 00C5 
; 0000 00C6 
; 0000 00C7     // Port C initialization
; 0000 00C8     // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00C9     // State6=T State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 00CA     PORTC=0x3F;
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 00CB     DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00CC 
; 0000 00CD     // Port D initialization
; 0000 00CE     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00CF     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00D0     PORTD=0x00;
	OUT  0x12,R30
; 0000 00D1     DDRD=0x00;
	OUT  0x11,R30
; 0000 00D2 
; 0000 00D3     // Timer/Counter 0 initialization
; 0000 00D4     // Clock source: System Clock
; 0000 00D5     // Clock value: Timer 0 Stopped
; 0000 00D6     TCCR0=0x00;
	OUT  0x33,R30
; 0000 00D7     TCNT0=0x00;
	OUT  0x32,R30
; 0000 00D8 
; 0000 00D9     // Timer/Counter 1 initialization
; 0000 00DA     // Clock source: System Clock
; 0000 00DB     // Clock value: Timer1 Stopped
; 0000 00DC     // Mode: Normal top=0xFFFF
; 0000 00DD     // OC1A output: Discon.
; 0000 00DE     // OC1B output: Discon.
; 0000 00DF     // Noise Canceler: Off
; 0000 00E0     // Input Capture on Falling Edge
; 0000 00E1     // Timer1 Overflow Interrupt: Off
; 0000 00E2     // Input Capture Interrupt: Off
; 0000 00E3     // Compare A Match Interrupt: Off
; 0000 00E4     // Compare B Match Interrupt: Off
; 0000 00E5     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00E6     TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00E7     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00E8     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00E9     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00EA     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00EB     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00EC     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00ED     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00EE     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00EF 
; 0000 00F0 
; 0000 00F1     // Timer/Counter 2 initialization
; 0000 00F2     // Clock source: System Clock
; 0000 00F3     // Clock value: Timer2 Stopped
; 0000 00F4     // Mode: Normal top=0xFF
; 0000 00F5     // OC2 output: Disconnected
; 0000 00F6     ASSR=0x00;
	OUT  0x22,R30
; 0000 00F7     TCCR2=0x00;
	OUT  0x25,R30
; 0000 00F8     TCNT2=0x00;
	OUT  0x24,R30
; 0000 00F9     OCR2=0x00;
	OUT  0x23,R30
; 0000 00FA 
; 0000 00FB     // External Interrupt(s) initialization
; 0000 00FC     // INT0: Off
; 0000 00FD     // INT1: Off
; 0000 00FE     MCUCR=0x00;
	OUT  0x35,R30
; 0000 00FF 
; 0000 0100     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0101     TIMSK=0x00;
	OUT  0x39,R30
; 0000 0102 
; 0000 0103     // USART initialization
; 0000 0104     // USART disabled
; 0000 0105     UCSRB=0x00;
	OUT  0xA,R30
; 0000 0106 
; 0000 0107     // Analog Comparator initialization
; 0000 0108     // Analog Comparator: Off
; 0000 0109     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 010A     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 010B     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 010C 
; 0000 010D     // ADC initialization
; 0000 010E     // ADC Clock frequency: 1000,000 kHz
; 0000 010F     // ADC Voltage Reference: Int., cap. on AREF
; 0000 0110     ADMUX=0;
	OUT  0x7,R30
; 0000 0111     ADCSRA=0;
	OUT  0x6,R30
; 0000 0112 
; 0000 0113     // SPI initialization
; 0000 0114     // SPI disabled
; 0000 0115     SPCR=0x00;
	OUT  0xD,R30
; 0000 0116 
; 0000 0117     // TWI initialization
; 0000 0118     // TWI disabled
; 0000 0119     TWCR=0x00;
	OUT  0x36,R30
; 0000 011A 
; 0000 011B     // Alphanumeric LCD initialization
; 0000 011C     // Connections specified in the
; 0000 011D     // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 011E     // RS - PORTD Bit 0
; 0000 011F     // RD - PORTD Bit 1
; 0000 0120     // EN - PORTD Bit 2
; 0000 0121     // D4 - PORTD Bit 3
; 0000 0122     // D5 - PORTD Bit 4
; 0000 0123     // D6 - PORTD Bit 5
; 0000 0124     // D7 - PORTD Bit 6
; 0000 0125     // Characters/line: 8
; 0000 0126     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0127     MSCS_init();
	RCALL _MSCS_init
; 0000 0128     delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0xE
; 0000 0129 
; 0000 012A      lcd_puts("Start!");
	__POINTW2MN _0x30,0
	RCALL _lcd_puts
; 0000 012B     // delay_ms(2000);
; 0000 012C     // Global enable interrupts
; 0000 012D     #asm("sei")
	sei
; 0000 012E 
; 0000 012F     while (1)
_0x31:
; 0000 0130           {
; 0000 0131           m1=PINC;
	IN   R16,19
; 0000 0132     sprintf(buf,"");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
; 0000 0133     switch (m1&0b1111)
	MOV  R30,R16
	ANDI R30,LOW(0xF)
; 0000 0134     {
; 0000 0135         case 0xC://1
	CPI  R30,LOW(0xC)
	BRNE _0x37
; 0000 0136         MSCS_com_veryfy("rh              ",buf1);
	__POINTW1MN _0x30,7
	RCALL SUBOPT_0x12
; 0000 0137         sprintf(buf,"h-%2um-%2u        s-%2u %2d",buf1[9],buf1[10],buf1[11],buf1[8]);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,24
	RCALL SUBOPT_0x10
	LDD  R30,Y+34
	RCALL SUBOPT_0x13
	LDD  R30,Y+39
	RCALL SUBOPT_0x13
	LDD  R30,Y+44
	RCALL SUBOPT_0x13
	LDD  R30,Y+45
	RCALL SUBOPT_0x13
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
; 0000 0138         break;
	RJMP _0x36
; 0000 0139         case 0x4://2
_0x37:
	CPI  R30,LOW(0x4)
	BRNE _0x38
; 0000 013A         m2=encoder(m2);
	MOV  R26,R19
	RCALL _encoder
	MOV  R19,R30
; 0000 013B         if (m2>=250) m2=0;
	CPI  R19,250
	BRLO _0x39
	LDI  R19,LOW(0)
; 0000 013C         if (m2>7) m2=7;
_0x39:
	CPI  R19,8
	BRLO _0x3A
	LDI  R19,LOW(7)
; 0000 013D         sprintf(buf,"SelTimer        Timer%u",m2+1);
_0x3A:
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,52
	RCALL SUBOPT_0x14
	RJMP _0x85
; 0000 013E         break;
; 0000 013F         case 0x0://3
_0x38:
	CPI  R30,0
	BRNE _0x3B
; 0000 0140         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x3D
	RCALL SUBOPT_0x15
	BRNE _0x3C
_0x3D:
; 0000 0141         MSCS_com_veryfy("rh              ",buf1);
	__POINTW1MN _0x30,24
	RCALL SUBOPT_0x12
; 0000 0142         Vol=buf1[m2];
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,21
	ADD  R26,R30
	ADC  R27,R31
	LD   R7,X
; 0000 0143         }
; 0000 0144         Vol=encoder(Vol);
_0x3C:
	MOV  R26,R7
	RCALL _encoder
	MOV  R7,R30
; 0000 0145         sprintf(buf,"TimerNo%u        time=%u",m2+1,Vol);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,76
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	MOV  R30,R7
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
; 0000 0146 
; 0000 0147         break;
	RJMP _0x36
; 0000 0148 
; 0000 0149         case 0x8://4
_0x3B:
	CPI  R30,LOW(0x8)
	BRNE _0x3F
; 0000 014A         sprintf(buf,"WriteNo%u        toMemory",m2+1);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,101
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x17
; 0000 014B         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x41
	RCALL SUBOPT_0x15
	BRNE _0x40
_0x41:
; 0000 014C          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 014D          buf2[1]='r';
; 0000 014E          buf2[2]='i';
; 0000 014F          buf2[3]='t';
; 0000 0150          buf2[4]='e';
; 0000 0151          buf2[5]='t';
	LDI  R30,LOW(116)
	RCALL SUBOPT_0x19
; 0000 0152          buf2[6]=m2;
	ST   Z,R19
; 0000 0153          buf2[7]=Vol;
	MOVW R30,R28
	ADIW R30,11
	ST   Z,R7
; 0000 0154          MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x1A
; 0000 0155          sprintf(buf,"WriteNo%u        Ok",m2+1);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,127
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x17
; 0000 0156         }
; 0000 0157         break;
_0x40:
	RJMP _0x36
; 0000 0158 
; 0000 0159 
; 0000 015A         case 0xA://5
_0x3F:
	CPI  R30,LOW(0xA)
	BRNE _0x43
; 0000 015B         sprintf(buf,"Enable          testMode");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,147
	RCALL SUBOPT_0x1B
; 0000 015C         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x45
	RCALL SUBOPT_0x15
	BRNE _0x44
_0x45:
; 0000 015D          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 015E          buf2[1]='r';
; 0000 015F          buf2[2]='i';
; 0000 0160          buf2[3]='t';
; 0000 0161          buf2[4]='e';
; 0000 0162          buf2[5]='e';
	LDI  R30,LOW(101)
	STD  Y+9,R30
; 0000 0163          MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x1A
; 0000 0164          sprintf(buf,"Enable        Tmode Ok");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,172
	RCALL SUBOPT_0x1B
; 0000 0165         }
; 0000 0166         break;
_0x44:
	RJMP _0x36
; 0000 0167         case 0x2://6
_0x43:
	CPI  R30,LOW(0x2)
	BRNE _0x47
; 0000 0168         m3=encoder(m3);
	RCALL SUBOPT_0x1C
; 0000 0169         if (m3>=250) m3=0;
	BRLO _0x48
	LDI  R18,LOW(0)
; 0000 016A         if (m3>3) m3=3;
_0x48:
	CPI  R18,4
	BRLO _0x49
	LDI  R18,LOW(3)
; 0000 016B         sprintf(buf,"PORT No%u        Switch",m3+1);
_0x49:
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,195
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x17
; 0000 016C          if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x4B
	RCALL SUBOPT_0x15
	BRNE _0x4A
_0x4B:
; 0000 016D          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 016E          buf2[1]='r';
; 0000 016F          buf2[2]='i';
; 0000 0170          buf2[3]='t';
; 0000 0171          buf2[4]='e';
; 0000 0172          buf2[5]='s';
	LDI  R30,LOW(115)
	RCALL SUBOPT_0x19
; 0000 0173          buf2[6]=m3;
	RCALL SUBOPT_0x1E
; 0000 0174          MSCS_com_veryfy(buf2,buf1);
; 0000 0175          sprintf(buf,"PORT       SwitchOk");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,219
	RCALL SUBOPT_0x1B
; 0000 0176          delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0177         }
; 0000 0178         break;
_0x4A:
	RJMP _0x36
; 0000 0179         case 0x6://7
_0x47:
	CPI  R30,LOW(0x6)
	BRNE _0x4D
; 0000 017A            MSCS_com_veryfy("rtt             ",buf1);
	__POINTW1MN _0x30,41
	RCALL SUBOPT_0x12
; 0000 017B         sprintf(buf,"t1=%2u %u         t2=%2u",buf1[2],buf[1],buf1[3]);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,256
	RCALL SUBOPT_0x10
	LDD  R30,Y+27
	RCALL SUBOPT_0x13
	LDD  R30,Y+47
	RCALL SUBOPT_0x13
	LDD  R30,Y+36
	RCALL SUBOPT_0x13
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
; 0000 017C         delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _delay_ms
; 0000 017D         break;
	RJMP _0x36
; 0000 017E         case 0xE: //8
_0x4D:
	CPI  R30,LOW(0xE)
	BRNE _0x4E
; 0000 017F 
; 0000 0180         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x50
	RCALL SUBOPT_0x15
	BRNE _0x4F
_0x50:
; 0000 0181          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 0182          buf2[1]='r';
; 0000 0183          buf2[2]='i';
; 0000 0184          buf2[3]='t';
; 0000 0185          buf2[4]='e';
; 0000 0186          buf2[5]='a';
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x19
; 0000 0187          buf2[6]=m3;
	RCALL SUBOPT_0x1E
; 0000 0188          MSCS_com_veryfy(buf2,buf1);
; 0000 0189          sprintf(buf,"Address         WRITE Ok");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,281
	RCALL SUBOPT_0x1B
; 0000 018A         } else {
	RJMP _0x52
_0x4F:
; 0000 018B          buf2[0]='r';
	RCALL SUBOPT_0x1F
; 0000 018C          buf2[1]='a';
	LDI  R30,LOW(97)
	STD  Y+5,R30
; 0000 018D          buf2[2]='g';
	LDI  R30,LOW(103)
	RCALL SUBOPT_0x20
; 0000 018E          buf2[3]=m3;
	RCALL SUBOPT_0x1E
; 0000 018F          MSCS_com_veryfy(buf2,buf1);
; 0000 0190         sprintf(buf,"%2X%2X%2X%2X        %2X%2X t%2u",buf1[2],buf1[3],buf1[4],buf1[5],buf1[6],buf1[7],buf1[8]);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,306
	RCALL SUBOPT_0x10
	LDD  R30,Y+27
	RCALL SUBOPT_0x13
	LDD  R30,Y+32
	RCALL SUBOPT_0x13
	LDD  R30,Y+37
	RCALL SUBOPT_0x13
	LDD  R30,Y+42
	RCALL SUBOPT_0x13
	LDD  R30,Y+47
	RCALL SUBOPT_0x13
	LDD  R30,Y+52
	RCALL SUBOPT_0x13
	LDD  R30,Y+57
	RCALL SUBOPT_0x13
	LDI  R24,28
	RCALL _sprintf
	ADIW R28,32
; 0000 0191 
; 0000 0192         }
_0x52:
; 0000 0193         break;
	RJMP _0x36
; 0000 0194         case 0xF:  //9
_0x4E:
	CPI  R30,LOW(0xF)
	BRNE _0x53
; 0000 0195 
; 0000 0196          m3=encoder(m3);
	RCALL SUBOPT_0x1C
; 0000 0197          if (m3>=250) m3=0;
	BRLO _0x54
	LDI  R18,LOW(0)
; 0000 0198          if (m3>(buf1[1]-1)) m3=(buf1[1]-1);
_0x54:
	LDD  R30,Y+22
	SUBI R30,LOW(1)
	CP   R30,R18
	BRSH _0x55
	LDD  R30,Y+22
	SUBI R30,LOW(1)
	MOV  R18,R30
; 0000 0199 
; 0000 019A         sprintf(buf,"sel term        %u",m3);
_0x55:
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,338
	RCALL SUBOPT_0x10
	MOV  R30,R18
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x17
; 0000 019B         m4=0;
	LDI  R21,LOW(0)
; 0000 019C         break;
	RJMP _0x36
; 0000 019D         case 0xD: //10
_0x53:
	CPI  R30,LOW(0xD)
	BRNE _0x56
; 0000 019E 
; 0000 019F          buf2[0]='r';
	RCALL SUBOPT_0x1F
; 0000 01A0          buf2[1]='t';
	RCALL SUBOPT_0x21
; 0000 01A1          buf2[2]='h';
	LDI  R30,LOW(104)
	RCALL SUBOPT_0x22
; 0000 01A2 
; 0000 01A3          m3=encoder(m3);
; 0000 01A4 
; 0000 01A5         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x58
	RCALL SUBOPT_0x15
	BRNE _0x57
_0x58:
; 0000 01A6          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 01A7          buf2[1]='r';
; 0000 01A8          buf2[2]='i';
; 0000 01A9          buf2[3]='t';
; 0000 01AA          buf2[4]='e';
; 0000 01AB          buf2[5]='h';
	LDI  R30,LOW(104)
	RCALL SUBOPT_0x19
; 0000 01AC          buf2[6]=m3;
	RCALL SUBOPT_0x1E
; 0000 01AD          MSCS_com_veryfy(buf2,buf1);
; 0000 01AE          sprintf(buf,"HTemp           WRITE Ok");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,357
	RCALL SUBOPT_0x1B
; 0000 01AF 
; 0000 01B0         } else {
	RJMP _0x5A
_0x57:
; 0000 01B1 
; 0000 01B2           if (!k){
	CPI  R17,0
	BRNE _0x5B
; 0000 01B3           MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x1A
; 0000 01B4           }
; 0000 01B5           k++;
_0x5B:
	SUBI R17,-1
; 0000 01B6           if (!m4) {
	CPI  R21,0
	BRNE _0x5C
; 0000 01B7            m3=buf1[1];
	LDD  R18,Y+22
; 0000 01B8            m4=1;
	LDI  R21,LOW(1)
; 0000 01B9           }
; 0000 01BA          sprintf(buf,"HLevel T        %3u  %3u",buf1[1],m3);
_0x5C:
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,382
	RCALL SUBOPT_0x10
	LDD  R30,Y+26
	RCALL SUBOPT_0x13
	MOV  R30,R18
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
; 0000 01BB         }
_0x5A:
; 0000 01BC         break;
	RJMP _0x36
; 0000 01BD         case 0x5: //11
_0x56:
	CPI  R30,LOW(0x5)
	BRNE _0x5D
; 0000 01BE         m4=0;
	LDI  R21,LOW(0)
; 0000 01BF 
; 0000 01C0 
; 0000 01C1 
; 0000 01C2          m3=encoder(m3);
	RCALL SUBOPT_0x23
; 0000 01C3          if (m3>250) m3=0;
	BRLO _0x5E
	LDI  R18,LOW(0)
; 0000 01C4          if (m3>3) m3=3;
_0x5E:
	CPI  R18,4
	BRLO _0x5F
	LDI  R18,LOW(3)
; 0000 01C5 
; 0000 01C6          buf2[0]='r';
_0x5F:
	RCALL SUBOPT_0x1F
; 0000 01C7          buf2[1]='t';
	RCALL SUBOPT_0x21
; 0000 01C8          buf2[2]='r';
	LDI  R30,LOW(114)
	RCALL SUBOPT_0x20
; 0000 01C9          buf2[3]=m3;
	ST   Z,R18
; 0000 01CA          if (!k) MSCS_com_veryfy(buf2,buf1);
	CPI  R17,0
	BRNE _0x60
	RCALL SUBOPT_0x1A
; 0000 01CB          k++;
_0x60:
	SUBI R17,-1
; 0000 01CC          if (buf1[1])
	LDD  R30,Y+22
	CPI  R30,0
	BREQ _0x61
; 0000 01CD          {
; 0000 01CE          sprintf(buf,"Sel Rel         %uTIMER",m3+1);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,407
	RJMP _0x86
; 0000 01CF          } else{
_0x61:
; 0000 01D0          sprintf(buf,"Sel Rel         %uterm",m3+1);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,431
_0x86:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x17
; 0000 01D1          }
; 0000 01D2 
; 0000 01D3 
; 0000 01D4         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x64
	RCALL SUBOPT_0x15
	BRNE _0x63
_0x64:
; 0000 01D5          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 01D6          buf2[1]='r';
; 0000 01D7          buf2[2]='i';
; 0000 01D8          buf2[3]='t';
; 0000 01D9          buf2[4]='e';
; 0000 01DA          buf2[5]='r';
	LDI  R30,LOW(114)
	RCALL SUBOPT_0x19
; 0000 01DB          buf2[6]=m3;
	RCALL SUBOPT_0x1E
; 0000 01DC          MSCS_com_veryfy(buf2,buf1);
; 0000 01DD          }
; 0000 01DE         break;
_0x63:
	RJMP _0x36
; 0000 01DF         case 0x1://12
_0x5D:
	CPI  R30,LOW(0x1)
	BRNE _0x66
; 0000 01E0 
; 0000 01E1          buf2[0]='r';
	RCALL SUBOPT_0x1F
; 0000 01E2          buf2[1]='t';
	RCALL SUBOPT_0x21
; 0000 01E3          buf2[2]='l';
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x22
; 0000 01E4          m3=encoder(m3);
; 0000 01E5         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x68
	RCALL SUBOPT_0x15
	BRNE _0x67
_0x68:
; 0000 01E6          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 01E7          buf2[1]='r';
; 0000 01E8          buf2[2]='i';
; 0000 01E9          buf2[3]='t';
; 0000 01EA          buf2[4]='e';
; 0000 01EB          buf2[5]='l';
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x19
; 0000 01EC          buf2[6]=m3;
	RCALL SUBOPT_0x1E
; 0000 01ED          MSCS_com_veryfy(buf2,buf1);
; 0000 01EE          sprintf(buf,"LTemp           WRITE Ok");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,454
	RCALL SUBOPT_0x1B
; 0000 01EF 
; 0000 01F0         } else {
	RJMP _0x6A
_0x67:
; 0000 01F1 
; 0000 01F2           if (!k) MSCS_com_veryfy(buf2,buf1);
	CPI  R17,0
	BRNE _0x6B
	RCALL SUBOPT_0x1A
; 0000 01F3           k++;
_0x6B:
	SUBI R17,-1
; 0000 01F4           if (!m4) {
	CPI  R21,0
	BRNE _0x6C
; 0000 01F5            m3=buf1[1];
	LDD  R18,Y+22
; 0000 01F6            m4=1;
	LDI  R21,LOW(1)
; 0000 01F7           }
; 0000 01F8          sprintf(buf,"LLevel T        %3u  %3u",buf1[1],m3);
_0x6C:
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,479
	RCALL SUBOPT_0x10
	LDD  R30,Y+26
	RCALL SUBOPT_0x13
	MOV  R30,R18
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x16
; 0000 01F9         }
_0x6A:
; 0000 01FA         break;
	RJMP _0x36
; 0000 01FB         case 0x9://13
_0x66:
	CPI  R30,LOW(0x9)
	BRNE _0x6D
; 0000 01FC         m4=0;
	LDI  R21,LOW(0)
; 0000 01FD 
; 0000 01FE 
; 0000 01FF 
; 0000 0200         m4=0;
	LDI  R21,LOW(0)
; 0000 0201 
; 0000 0202 
; 0000 0203 
; 0000 0204          m3=encoder(m3);
	RCALL SUBOPT_0x23
; 0000 0205          if (m3>250) m3=0;
	BRLO _0x6E
	LDI  R18,LOW(0)
; 0000 0206          if (m3>3) m3=3;
_0x6E:
	CPI  R18,4
	BRLO _0x6F
	LDI  R18,LOW(3)
; 0000 0207 
; 0000 0208          buf2[0]='r';
_0x6F:
	RCALL SUBOPT_0x1F
; 0000 0209          buf2[1]='t';
	RCALL SUBOPT_0x21
; 0000 020A          buf2[2]='s';
	LDI  R30,LOW(115)
	RCALL SUBOPT_0x20
; 0000 020B          buf2[3]=m3;
	ST   Z,R18
; 0000 020C          if (!k)
	CPI  R17,0
	BRNE _0x70
; 0000 020D          MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x1A
; 0000 020E          k++;
_0x70:
	SUBI R17,-1
; 0000 020F          if (buf1[1])
	LDD  R30,Y+22
	CPI  R30,0
	BREQ _0x71
; 0000 0210          {
; 0000 0211          sprintf(buf,"Sel Rel         %1u LOW tm",m3+1);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,504
	RJMP _0x87
; 0000 0212          } else{
_0x71:
; 0000 0213          sprintf(buf,"Sel Rel         %1u hi  tm",m3+1);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,531
_0x87:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x17
; 0000 0214          }
; 0000 0215 
; 0000 0216 
; 0000 0217         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x74
	RCALL SUBOPT_0x15
	BRNE _0x73
_0x74:
; 0000 0218          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 0219          buf2[1]='r';
; 0000 021A          buf2[2]='i';
; 0000 021B          buf2[3]='t';
; 0000 021C          buf2[4]='e';
; 0000 021D          buf2[5]='g';
	LDI  R30,LOW(103)
	RCALL SUBOPT_0x19
; 0000 021E          buf2[6]=m3;
	RCALL SUBOPT_0x1E
; 0000 021F          MSCS_com_veryfy(buf2,buf1);
; 0000 0220          }
; 0000 0221 
; 0000 0222 
; 0000 0223 
; 0000 0224 
; 0000 0225         break;
_0x73:
	RJMP _0x36
; 0000 0226         case 0xB: //14
_0x6D:
	CPI  R30,LOW(0xB)
	BREQ PC+2
	RJMP _0x76
; 0000 0227         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x78
	RCALL SUBOPT_0x15
	BRNE _0x77
_0x78:
; 0000 0228         if (!m4){
	CPI  R21,0
	BRNE _0x7A
; 0000 0229         Vol=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 022A         m4=1;
	LDI  R21,LOW(1)
; 0000 022B        // TCCR1A|=(1<<COM1B0);
; 0000 022C         TCCR1B|=(1<<CS12)|(1<<CS10);
	IN   R30,0x2E
	ORI  R30,LOW(0x5)
	OUT  0x2E,R30
; 0000 022D         OCR1A=0xffff;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 022E         OCR1B=15625;
	LDI  R30,LOW(15625)
	LDI  R31,HIGH(15625)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 022F         Vol_int=OCR1B;
	IN   R30,0x28
	IN   R31,0x28+1
	RCALL SUBOPT_0x24
; 0000 0230         // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0231         TIMSK|=(1<<OCIE1A) | (1<<OCIE1B);
	IN   R30,0x39
	ORI  R30,LOW(0x18)
	RJMP _0x88
; 0000 0232         } else {
_0x7A:
; 0000 0233         m4=0;
	LDI  R21,LOW(0)
; 0000 0234         TCCR1A&=~(1<<COM1B0);
	IN   R30,0x2F
	ANDI R30,0xEF
	OUT  0x2F,R30
; 0000 0235         TCCR1B&=~((1<<CS12)|(1<<CS10));
	IN   R30,0x2E
	ANDI R30,LOW(0xFA)
	OUT  0x2E,R30
; 0000 0236         TIMSK&=~((1<<OCIE1A) | (1<<OCIE1B));
	IN   R30,0x39
	ANDI R30,LOW(0xE7)
_0x88:
	OUT  0x39,R30
; 0000 0237         }
; 0000 0238     }
; 0000 0239             Vol_int=encoder_int(Vol_int,100);
_0x77:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x10
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _encoder_int
	RCALL SUBOPT_0x24
; 0000 023A         OCR1B=Vol_int;
	RCALL SUBOPT_0x25
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 023B         OCR1A=Vol_int+4;
	RCALL SUBOPT_0x25
	ADIW R30,4
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 023C         if (m4)    sprintf(buf,"PulseGen        ON %u OB",15625/Vol_int);
	CPI  R21,0
	BREQ _0x7C
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,558
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x25
	LDI  R26,LOW(15625)
	LDI  R27,HIGH(15625)
	RCALL __DIVW21U
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RCALL SUBOPT_0x17
; 0000 023D         else sprintf(buf,"PulseGen        OFF     ");
	RJMP _0x7D
_0x7C:
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,583
	RCALL SUBOPT_0x1B
; 0000 023E         break;
_0x7D:
	RJMP _0x36
; 0000 023F         case 0x3: //15
_0x76:
	CPI  R30,LOW(0x3)
	BRNE _0x7E
; 0000 0240         sprintf(buf,"Restart        clock");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,608
	RCALL SUBOPT_0x1B
; 0000 0241         if (!((m1&0b100000)&&0b100000)){
	SBRS R16,5
	RJMP _0x80
	RCALL SUBOPT_0x15
	BRNE _0x7F
_0x80:
; 0000 0242          buf2[0]='w';
	RCALL SUBOPT_0x18
; 0000 0243          buf2[1]='r';
; 0000 0244          buf2[2]='i';
; 0000 0245          buf2[3]='t';
; 0000 0246          buf2[4]='e';
; 0000 0247          buf2[5]='c';
	LDI  R30,LOW(99)
	STD  Y+9,R30
; 0000 0248          MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x1A
; 0000 0249          sprintf(buf,"Restart        clock-Ok");
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,629
	RCALL SUBOPT_0x1B
; 0000 024A          }
; 0000 024B         break;
_0x7F:
	RJMP _0x36
; 0000 024C         case 0x7: //16
_0x7E:
	CPI  R30,LOW(0x7)
	BRNE _0x83
; 0000 024D         // ADC initialization
; 0000 024E     // ADC Clock frequency: 1000,000 kHz
; 0000 024F     // ADC Voltage Reference: Int., cap. on AREF
; 0000 0250     ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(71)
	OUT  0x7,R30
; 0000 0251     ADCSRA=0xCC;
	LDI  R30,LOW(204)
	OUT  0x6,R30
; 0000 0252         ft=0.005*adc_data;
	MOVW R30,R4
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3BA3D70A
	RCALL __MULF12
	RCALL SUBOPT_0x26
; 0000 0253         sprintf(buf,"Voltmetr        %1.3fVol",ft);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,653
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x27
	RJMP _0x89
; 0000 0254         break;
; 0000 0255         default:
_0x83:
; 0000 0256         sprintf(buf,"Pressed button   %X",PINC);
	RCALL SUBOPT_0xF
	__POINTW1FN _0x0,678
	RCALL SUBOPT_0x10
	IN   R30,0x13
_0x85:
	CLR  R31
	CLR  R22
	CLR  R23
_0x89:
	RCALL __PUTPARD1
	RCALL SUBOPT_0x17
; 0000 0257     }
_0x36:
; 0000 0258           lcd_clear();
	RCALL _lcd_clear
; 0000 0259           lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 025A           lcd_puts(buf);
	MOVW R26,R28
	ADIW R26,38
	RCALL _lcd_puts
; 0000 025B           }
	RJMP _0x31
; 0000 025C     }
_0x84:
	RJMP _0x84
; .FEND

	.DSEG
_0x30:
	.BYTE 0x3A
;        // */
;
;/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;MSCS Bus - slave start read and write to bus: mosi-h, clk - h. read and write - synhro. package - 16 byte
;
;*///////////////////////////////////////////////////////////////////////////////////////////////////////////////
;#include "MSCS_lib.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#ifdef MASTER
;
;#define DDRMOSI  DDPORT( MOSIP )
;#define MOSI_PORT PPORT( MOSIP )
;
;#define DDRCLK  DDPORT( CLKP )
;#define CLK_PORT PPORT( CLKP )
;
;#define DDRMISO  DDPORT( MISOP )
;#define MISO_PORT PPIN( MISOP )
;
;void MSCS_delay(void){
; 0001 0013 void MSCS_delay(void){

	.CSEG
_MSCS_delay:
; .FSTART _MSCS_delay
; 0001 0014 #ifdef CV
; 0001 0015 delay_ms(1);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0xE
; 0001 0016 #else
; 0001 0017 _delay_ms(1);
; 0001 0018 #endif
; 0001 0019 }
	RET
; .FEND
;
;void mosi(unsigned char mos){
; 0001 001B void mosi(unsigned char mos){
_mosi:
; .FSTART _mosi
; 0001 001C  if (mos){
	ST   -Y,R26
;	mos -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20003
; 0001 001D   MOSI_PORT|=(1<<MOSI_BIT);
	SBI  0x18,3
; 0001 001E  } else {
	RJMP _0x20004
_0x20003:
; 0001 001F   MOSI_PORT&=~(1<<MOSI_BIT);
	CBI  0x18,3
; 0001 0020  }
_0x20004:
; 0001 0021 }
	RJMP _0x20C0004
; .FEND
;
;void clk(unsigned char cl){
; 0001 0023 void clk(unsigned char cl){
_clk:
; .FSTART _clk
; 0001 0024  if (cl){
	ST   -Y,R26
;	cl -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20005
; 0001 0025   CLK_PORT|=(1<<CLK_BIT);
	SBI  0x18,5
; 0001 0026  } else {
	RJMP _0x20006
_0x20005:
; 0001 0027   CLK_PORT&=~(1<<CLK_BIT);
	CBI  0x18,5
; 0001 0028  }
_0x20006:
; 0001 0029 }
	RJMP _0x20C0004
; .FEND
;
;unsigned char miso(void){
; 0001 002B unsigned char miso(void){
_miso:
; .FSTART _miso
; 0001 002C  return ((MISO_PORT&(1<<MISO_BIT))&&(1<<MISO_BIT));
	SBIS 0x16,4
	RJMP _0x20007
	LDI  R30,LOW(16)
	CPI  R30,0
	BREQ _0x20007
	LDI  R30,1
	RJMP _0x20008
_0x20007:
	LDI  R30,0
_0x20008:
	RET
; 0001 002D }
; .FEND
;
;void MSCS_com(unsigned char *data,unsigned char ret[17]){
; 0001 002F void MSCS_com(unsigned char *data,unsigned char ret[17]){
_MSCS_com:
; .FSTART _MSCS_com
; 0001 0030 
; 0001 0031 unsigned char buffer,resiver=0,i,j;
; 0001 0032 mosi(1);
	RCALL SUBOPT_0xB
	RCALL __SAVELOCR4
;	*data -> Y+6
;	ret -> Y+4
;	buffer -> R17
;	resiver -> R16
;	i -> R19
;	j -> R18
	LDI  R16,0
	LDI  R26,LOW(1)
	RCALL _mosi
; 0001 0033 for (i=0; i<16; i++){
	LDI  R19,LOW(0)
_0x2000A:
	CPI  R19,16
	BRSH _0x2000B
; 0001 0034     buffer=data[i];
	RCALL SUBOPT_0x28
	CLR  R30
	ADD  R26,R19
	ADC  R27,R30
	LD   R17,X
; 0001 0035     for (j=0; j<8; j++){
	LDI  R18,LOW(0)
_0x2000D:
	CPI  R18,8
	BRSH _0x2000E
; 0001 0036         clk(1);
	LDI  R26,LOW(1)
	RCALL _clk
; 0001 0037         MSCS_delay();
	RCALL _MSCS_delay
; 0001 0038         mosi(((buffer<<j)&0b10000000)&&0x80);
	MOV  R30,R18
	MOV  R26,R17
	RCALL __LSLB12
	ANDI R30,LOW(0x80)
	BREQ _0x2000F
	LDI  R30,LOW(128)
	CPI  R30,0
	BREQ _0x2000F
	LDI  R30,1
	RJMP _0x20010
_0x2000F:
	LDI  R30,0
_0x20010:
	MOV  R26,R30
	RCALL _mosi
; 0001 0039         MSCS_delay();
	RCALL _MSCS_delay
; 0001 003A         clk(0);
	LDI  R26,LOW(0)
	RCALL _clk
; 0001 003B         MSCS_delay();
	RCALL _MSCS_delay
; 0001 003C         resiver=(resiver<<1)|miso();
	MOV  R30,R16
	LSL  R30
	PUSH R30
	RCALL _miso
	POP  R26
	OR   R30,R26
	MOV  R16,R30
; 0001 003D     }
	SUBI R18,-1
	RJMP _0x2000D
_0x2000E:
; 0001 003E     ret[i]=resiver;
	MOV  R30,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0001 003F     resiver=0;
	LDI  R16,LOW(0)
; 0001 0040 }
	SUBI R19,-1
	RJMP _0x2000A
_0x2000B:
; 0001 0041 ret[16]=0;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,16
	RCALL SUBOPT_0x29
; 0001 0042 clk(1);
	LDI  R26,LOW(1)
	RCALL _clk
; 0001 0043 MSCS_delay();
	RCALL _MSCS_delay
; 0001 0044 clk(0);
	LDI  R26,LOW(0)
	RCALL _clk
; 0001 0045 mosi(0);
	LDI  R26,LOW(0)
	RCALL _mosi
; 0001 0046 MSCS_delay();
	RCALL _MSCS_delay
; 0001 0047 MSCS_delay();
	RCALL _MSCS_delay
; 0001 0048 MSCS_delay();
	RCALL _MSCS_delay
; 0001 0049 MSCS_delay();
	RCALL _MSCS_delay
; 0001 004A MSCS_delay();
	RCALL _MSCS_delay
; 0001 004B MSCS_delay();
	RCALL _MSCS_delay
; 0001 004C }
	RCALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
;
;void MSCS_init(void){
; 0001 004E void MSCS_init(void){
_MSCS_init:
; .FSTART _MSCS_init
; 0001 004F DDRMOSI|=(1<<MOSI_BIT);
	SBI  0x17,3
; 0001 0050 MOSI_PORT&=~(1<<MOSI_BIT);
	CBI  0x18,3
; 0001 0051 DDRMISO&=~(1<<MISO_BIT);
	CBI  0x17,4
; 0001 0052 MISO_PORT&=~(1<<MISO_BIT);
	CBI  0x16,4
; 0001 0053 DDRCLK|=(1<<CLK_BIT);
	SBI  0x17,5
; 0001 0054 CLK_PORT&=~(1<<CLK_BIT);
	CBI  0x18,5
; 0001 0055 }
	RET
; .FEND
;
;#else
;#define DDRMOSI  DDPORT(MOSIP)
;#define MOSI_PORT PPIN(MOSIP)
;
;#define DDRCLK  DDPORT(CLKP)
;#define CLK_PORT PPIN(CLKP)
;
;#define DDRMISO  DDPORT(MISOP)
;#define MISO_PORT PPORT(MISOP)
;
;void MSCS_delay_framing(void){
;#ifdef CV
;delay_us(200);
;#else
;_delay_us(200);
;#endif
;}
;
;void miso(unsigned char mis){
; if (mis){
;  MISO_PORT|=(1<<MISO_BIT);
; } else {
;  MISO_PORT&=~(1<<MISO_BIT);
; }
;}
;
;inline unsigned char clk(void){
; return ((CLK_PORT&(1<<CLK_BIT))&&(1<<CLK_BIT));
;}
;
;inline unsigned char mosi(void){
; return ((MOSI_PORT&(1<<MOSI_BIT))&&(1<<MOSI_BIT));
;}
;
;unsigned char MSCS_framing(void){
;unsigned char i;
;for(i=0;i<25;i++) {
;MSCS_delay_framing();
; if (clk()) return 1;
;
;}
;return 0;
;}
;
;unsigned char MSCS_com(unsigned char *data,unsigned char wait, unsigned char result[17]){
;unsigned char buffer_tx,buffer_rx;
;unsigned char i,j;
;unsigned int c;
;if (MSCS_framing()) {
;while(MSCS_framing()) #asm ("nop");
;wait=1;
;}
;
;if (wait){
;
; while (!(mosi()&&clk())){
; #asm ("nop")
; }
; for(i=0;i<16;i++){
;  buffer_tx=data[i];
;  buffer_rx=0;
;  for(j=0;j<8;j++){
;  c=1;
;    while(clk()){
;        if (c) c++; else return 0;
;    }
;    buffer_rx=(buffer_rx<<1)|mosi();
;    miso(((buffer_tx<<j)&0b10000000)&&0x80);
;    c=1;
;    while(!clk()){
;        if (c) c++; else return 0;
;    }
;  }
;  result[i]=buffer_rx;
; }
; result[16]=0;
;  return 1;
;} else {
;if (mosi()&&clk()) {
; for(i=0;i<16;i++){
;  buffer_tx=data[i];
;  buffer_rx=0;
;  for(j=0;j<8;j++){
;  c=1;
;    while(clk()){
;        if (c) c++; else return 0;
;    }
;    buffer_rx=(buffer_rx<<1)|mosi();
;    miso(((buffer_tx<<j)&0b10000000)&&0x80);
;    c=1;
;    while(!clk()){
;        if (c) c++; else return 0;
;    }
;  }
;  result[i]=buffer_rx;
; }
;result[16]=0;
;  return 1;
;}
;}
;return 0;
;}
;
;void MSCS_init(void){
;DDRMOSI&=~(1<<MOSI_BIT);
;MOSI_PORT&=~(1<<MOSI_BIT);
;DDRMISO|=(1<<MISO_BIT);
;MISO_PORT|=(1<<MISO_BIT);
;DDRCLK&=~(1<<CLK_BIT);
;CLK_PORT&=~(1<<CLK_BIT);
;}
;#endif
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL SUBOPT_0xB
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x2A
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x2A
	ADIW R26,2
	RCALL SUBOPT_0x2C
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	RCALL SUBOPT_0x2A
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2C
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
_0x20C0008:
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	RCALL SUBOPT_0x2D
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x10
	__POINTW2FN _0x2000000,0
	RCALL _strcpyf
	RJMP _0x20C0007
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x10
	__POINTW2FN _0x2000000,1
	RCALL _strcpyf
	RJMP _0x20C0007
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	RCALL SUBOPT_0x2F
	BREQ _0x200001E
	RCALL SUBOPT_0x30
	RJMP _0x200001C
_0x200001E:
	RCALL SUBOPT_0x31
	RCALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	RCALL SUBOPT_0x30
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	RCALL SUBOPT_0x32
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	RCALL SUBOPT_0x30
_0x2000022:
	RCALL SUBOPT_0x32
	BRLO _0x2000024
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	RCALL SUBOPT_0x32
	BRSH _0x2000028
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	RCALL SUBOPT_0x30
_0x2000025:
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x32
	BRLO _0x2000029
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x34
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x37
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	__PUTD1S 4
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x33
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x38
	RCALL __MULF12
	RCALL SUBOPT_0x33
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x36
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	RCALL SUBOPT_0x3A
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	RCALL SUBOPT_0x3D
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000113
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000113:
	ST   X,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x29
_0x20C0007:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0xB
	SBIW R28,63
	SBIW R28,17
	RCALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x28
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	RCALL SUBOPT_0x2C
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	RCALL SUBOPT_0x3F
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	RCALL SUBOPT_0x3F
	RJMP _0x2000114
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x40
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x42
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BRNE _0x200005A
_0x2000059:
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x44
	RCALL __GETD1P
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	CPI  R26,LOW(0x20)
	BREQ _0x200005F
	RJMP _0x2000060
_0x200005B:
	RCALL SUBOPT_0x47
	RCALL __ANEGF1
	RCALL SUBOPT_0x45
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	RCALL SUBOPT_0x42
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	RCALL SUBOPT_0x48
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000064
	RCALL SUBOPT_0x47
	RCALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _ftoa
	RJMP _0x2000065
_0x2000064:
	RCALL SUBOPT_0x47
	RCALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000065:
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x49
	RJMP _0x2000066
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000068
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	RJMP _0x2000069
_0x2000068:
	CPI  R30,LOW(0x70)
	BRNE _0x200006B
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x48
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006D
	CP   R20,R17
	BRLO _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2000072
	CPI  R30,LOW(0x69)
	BRNE _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BRNE _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x4B
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	RCALL SUBOPT_0x4B
	LDI  R17,LOW(5)
	RJMP _0x2000077
_0x2000075:
	CPI  R30,LOW(0x58)
	BRNE _0x2000079
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	RCALL SUBOPT_0x4B
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	RCALL SUBOPT_0x4B
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BREQ _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x44
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x2000115
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x4A
	RCALL __CWD1
	RJMP _0x2000115
_0x2000081:
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x4A
	CLR  R22
	CLR  R23
_0x2000115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000084
	RCALL SUBOPT_0x47
	RCALL __ANEGD1
	RCALL SUBOPT_0x45
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRSH _0x200008B
	CP   R19,R21
	BRLO _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	RCALL SUBOPT_0x3F
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRSH _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	RCALL SUBOPT_0x4C
	BREQ _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL SUBOPT_0x42
	CPI  R21,0
	BREQ _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000097
_0x2000098:
	CPI  R19,0
	BREQ _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	RCALL SUBOPT_0x48
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	RCALL SUBOPT_0x3F
	CPI  R21,0
	BREQ _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	RCALL SUBOPT_0x4D
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRC R16,4
	RJMP _0x20000A7
	CPI  R18,49
	BRSH _0x20000A9
	RCALL SUBOPT_0x4E
	__CPD2N 0x1
	BRNE _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH _0x2000116
	CP   R21,R19
	BRLO _0x20000AE
	SBRS R16,0
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
_0x2000116:
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	RCALL SUBOPT_0x4C
	BREQ _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	RCALL SUBOPT_0x3F
	CPI  R21,0
	BREQ _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x4D
	RCALL __MODD21U
	RCALL SUBOPT_0x45
	LDD  R30,Y+20
	RCALL SUBOPT_0x4E
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x4B
	__GETD1S 16
	RCALL __CPD10
	BREQ _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x42
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
_0x2000114:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	RCALL SUBOPT_0x28
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x4F
	SBIW R30,0
	BRNE _0x20000B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000B9:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x4F
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x10
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x10
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	MOVW R30,R18
_0x20C0006:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x12,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x12,4
	RJMP _0x2020007
_0x2020006:
	CBI  0x12,4
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x12,5
	RJMP _0x2020009
_0x2020008:
	CBI  0x12,5
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x12,6
	RJMP _0x202000B
_0x202000A:
	CBI  0x12,6
_0x202000B:
	RCALL SUBOPT_0x50
	SBI  0x12,2
	RCALL SUBOPT_0x50
	CBI  0x12,2
	RCALL SUBOPT_0x50
	RJMP _0x20C0004
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RJMP _0x20C0004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0005:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xE
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xE
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	CP   R6,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20C0004
_0x2020013:
_0x2020010:
	INC  R6
	SBI  0x12,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,0
	RJMP _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL SUBOPT_0xB
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x11,3
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x11,2
	SBI  0x11,0
	SBI  0x11,1
	CBI  0x12,2
	CBI  0x12,0
	CBI  0x12,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x51
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0004:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0xB
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0xB
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0xB
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL SUBOPT_0x26
    brne __floor1
__floor0:
	RCALL SUBOPT_0x52
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x52
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x2D
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	RCALL SUBOPT_0x53
	__POINTW2FN _0x20A0000,0
	RCALL _strcpyf
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0x53
	__POINTW2FN _0x20A0000,1
	RCALL _strcpyf
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	RCALL SUBOPT_0x54
	RCALL __ANEGF1
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x56
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	RCALL SUBOPT_0x2F
	BREQ _0x20A0013
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x58
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x59
	RCALL __ADDF12
	RCALL SUBOPT_0x55
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x58
_0x20A0014:
	RCALL SUBOPT_0x59
	RCALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x58
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0x53
	__POINTW2FN _0x20A0000,5
	RCALL _strcpyf
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0x56
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	RCALL SUBOPT_0x2F
	BREQ _0x20A001C
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x37
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x59
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x3C
	RCALL __MULF12
	RCALL SUBOPT_0x5A
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x55
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x56
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x54
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x3C
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x55
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x29
_0x20C0002:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_downState:
	.BYTE 0x2
_Vol_int:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	IN   R30,0x16
	ANDI R30,LOW(0x3)
	MOV  R8,R30
	CLR  R9
	__CPWRR 10,11,8,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOVW R30,R10
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOV  R0,R8
	OR   R0,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_downState)
	LDI  R27,HIGH(_downState)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDS  R26,_downState
	LDS  R27,_downState+1
	SBIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _downState,R30
	STS  _downState+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RJMP _MSCS_com

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xF:
	MOVW R30,R28
	ADIW R30,38
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x11:
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0x10
	MOVW R26,R28
	ADIW R26,23
	RJMP _MSCS_com_veryfy

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x13:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x10
	MOV  R30,R19
	SUBI R30,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(32)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x17:
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:70 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(119)
	STD  Y+4,R30
	LDI  R30,LOW(114)
	STD  Y+5,R30
	LDI  R30,LOW(105)
	STD  Y+6,R30
	LDI  R30,LOW(116)
	STD  Y+7,R30
	LDI  R30,LOW(101)
	STD  Y+8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x19:
	STD  Y+9,R30
	MOVW R30,R28
	ADIW R30,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1A:
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x10
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	MOV  R26,R18
	RCALL _encoder
	MOV  R18,R30
	CPI  R18,250
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	MOV  R30,R18
	SUBI R30,-LOW(1)
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	ST   Z,R18
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(114)
	STD  Y+4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	STD  Y+6,R30
	MOVW R30,R28
	ADIW R30,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(116)
	STD  Y+5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	STD  Y+6,R30
	MOV  R26,R18
	RCALL _encoder
	MOV  R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOV  R26,R18
	RCALL _encoder
	MOV  R18,R30
	CPI  R18,251
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	STS  _Vol_int,R30
	STS  _Vol_int+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LDS  R30,_Vol_int
	LDS  R31,_Vol_int+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x27:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0xB
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x30:
	__GETD2S 4
	__GETD1N 0x41200000
	RCALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x27
	__GETD2S 12
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x33:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3B:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3C:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0x2E
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3F:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x40:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x41:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x42:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x44:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x45:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	RCALL SUBOPT_0x40
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x47:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x44
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4B:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4C:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x50:
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x55:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x56:
	RCALL SUBOPT_0x28
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x57:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x58:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x59:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5A:
	__GETD2S 9
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

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
