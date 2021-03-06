
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _Vol=R7
	.DEF _NewState=R8
	.DEF _OldState=R10
	.DEF _upState=R12
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x53:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x53,0x74,0x61,0x72,0x74,0x21,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x68,0x2D,0x25,0x32,0x75,0x6D,0x2D,0x25
	.DB  0x32,0x75,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x73,0x2D,0x25,0x32,0x75,0x0
	.DB  0x53,0x65,0x6C,0x54,0x69,0x6D,0x65,0x72
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x54,0x69,0x6D,0x65,0x72,0x25,0x75,0x0
	.DB  0x54,0x69,0x6D,0x65,0x72,0x4E,0x6F,0x25
	.DB  0x75,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x74,0x69,0x6D,0x65,0x3D,0x25,0x75
	.DB  0x0,0x57,0x72,0x69,0x74,0x65,0x4E,0x6F
	.DB  0x25,0x75,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x74,0x6F,0x4D,0x65,0x6D,0x6F
	.DB  0x72,0x79,0x0,0x57,0x72,0x69,0x74,0x65
	.DB  0x4E,0x6F,0x25,0x75,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x4F,0x6B,0x0,0x45
	.DB  0x6E,0x61,0x62,0x6C,0x65,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x74
	.DB  0x65,0x73,0x74,0x4D,0x6F,0x64,0x65,0x0
	.DB  0x45,0x6E,0x61,0x62,0x6C,0x65,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x54,0x6D
	.DB  0x6F,0x64,0x65,0x20,0x4F,0x6B,0x0,0x50
	.DB  0x4F,0x52,0x54,0x20,0x4E,0x6F,0x25,0x75
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x53,0x77,0x69,0x74,0x63,0x68,0x0,0x50
	.DB  0x4F,0x52,0x54,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x53,0x77,0x69,0x74,0x63,0x68
	.DB  0x4F,0x6B,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x37,0x20,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x38,0x20,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x39,0x20,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x31,0x30,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x31,0x31,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x31,0x32,0x0,0x4D,0x65,0x6E,0x75,0x20
	.DB  0x31,0x33,0x0,0x50,0x75,0x6C,0x73,0x65
	.DB  0x47,0x65,0x6E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x4F,0x4E,0x25,0x34,0x75
	.DB  0x4F,0x42,0x0,0x50,0x75,0x6C,0x73,0x65
	.DB  0x47,0x65,0x6E,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x4F,0x46,0x46,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x52,0x65,0x73,0x74
	.DB  0x61,0x72,0x74,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x63,0x6C,0x6F,0x63,0x6B
	.DB  0x0,0x52,0x65,0x73,0x74,0x61,0x72,0x74
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x63,0x6C,0x6F,0x63,0x6B,0x2D,0x4F,0x6B
	.DB  0x0,0x56,0x6F,0x6C,0x74,0x6D,0x65,0x74
	.DB  0x72,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x25,0x31,0x2E,0x33,0x66,0x56,0x6F
	.DB  0x6C,0x0,0x50,0x72,0x65,0x73,0x73,0x65
	.DB  0x64,0x20,0x62,0x75,0x74,0x74,0x6F,0x6E
	.DB  0x20,0x20,0x20,0x25,0x58,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _0x1E
	.DW  _0x0*2

	.DW  0x11
	.DW  _0x1E+7
	.DW  _0x0*2+7

	.DW  0x11
	.DW  _0x1E+24
	.DW  _0x0*2+7

	.DW  0x06
	.DW  0x08
	.DW  _0x53*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 18.01.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
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
;#include <stdio.h>
;#include <delay.h>
;
;
;#include "MSCS_lib.h"
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#define FIRST_ADC_INPUT 7
;unsigned int adc_data;
;#define ADC_VREF_TYPE 0x40//0xC0
;
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0029 {

	.CSEG
_adc_isr:
	ST   -Y,R24
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 002A // Read the AD conversion result
; 0000 002B adc_data=ADCW;
	__INWR 4,5,4
; 0000 002C 
; 0000 002D ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff));
	LDI  R30,LOW(71)
	OUT  0x7,R30
; 0000 002E // Delay needed for the stabilization of the ADC input voltage
; 0000 002F delay_us(10);
	__DELAY_USB 53
; 0000 0030 // Start the AD conversion
; 0000 0031 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0032 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R24,Y+
	RETI
;
;// Declare your global variables here
;unsigned char Vol;
;unsigned int NewState=0,OldState=0,upState=0,downState=0;
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 003A {
_timer1_compa_isr:
	ST   -Y,R30
	ST   -Y,R31
; 0000 003B // Place your code here
; 0000 003C TCNT1=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 003D PORTB.2=0;
	CBI  0x18,2
; 0000 003E }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Timer1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 0042 {
_timer1_compb_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0043 // Place your code here
; 0000 0044 OCR1A=TCNT1+4;
	IN   R30,0x2C
	IN   R31,0x2C+1
	ADIW R30,4
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0045 PORTB.2=1;
	SBI  0x18,2
; 0000 0046 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;unsigned char encoder(unsigned char val){
; 0000 0049 unsigned char encoder(unsigned char val){
_encoder:
; 0000 004A           NewState=PINB & 0b00000011;
;	val -> Y+0
	IN   R30,0x16
	ANDI R30,LOW(0x3)
	MOV  R8,R30
	CLR  R9
; 0000 004B if(NewState!=OldState)
	__CPWRR 10,11,8,9
	BREQ _0x7
; 0000 004C {
; 0000 004D 
; 0000 004E switch(OldState)
	MOVW R30,R10
; 0000 004F 	{
; 0000 0050 	case 2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB
; 0000 0051 		{
; 0000 0052 		if(NewState == 3) upState++;
	RCALL SUBOPT_0x0
	BRNE _0xC
	RCALL SUBOPT_0x1
; 0000 0053 		if(NewState == 0) downState++;
_0xC:
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xD
	RCALL SUBOPT_0x2
; 0000 0054 		break;
_0xD:
	RJMP _0xA
; 0000 0055 		}
; 0000 0056 
; 0000 0057 	case 0:
_0xB:
	SBIW R30,0
	BRNE _0xE
; 0000 0058 		{
; 0000 0059 		if(NewState == 2) upState++;
	RCALL SUBOPT_0x3
	BRNE _0xF
	RCALL SUBOPT_0x1
; 0000 005A 		if(NewState == 1) downState++;
_0xF:
	RCALL SUBOPT_0x4
	BRNE _0x10
	RCALL SUBOPT_0x2
; 0000 005B 		break;
_0x10:
	RJMP _0xA
; 0000 005C 		}
; 0000 005D 	case 1:
_0xE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11
; 0000 005E 		{
; 0000 005F 		if(NewState == 0) upState++;
	MOV  R0,R8
	OR   R0,R9
	BRNE _0x12
	RCALL SUBOPT_0x1
; 0000 0060 		if(NewState == 3) downState++;
_0x12:
	RCALL SUBOPT_0x0
	BRNE _0x13
	RCALL SUBOPT_0x2
; 0000 0061 		break;
_0x13:
	RJMP _0xA
; 0000 0062 		}
; 0000 0063 	case 3:
_0x11:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xA
; 0000 0064 		{
; 0000 0065 		if(NewState == 1) upState++;
	RCALL SUBOPT_0x4
	BRNE _0x15
	RCALL SUBOPT_0x1
; 0000 0066 		if(NewState == 2) downState++;
_0x15:
	RCALL SUBOPT_0x3
	BRNE _0x16
	RCALL SUBOPT_0x2
; 0000 0067 		break;
_0x16:
; 0000 0068 		}
; 0000 0069 	}
_0xA:
; 0000 006A OldState=NewState;
	MOVW R10,R8
; 0000 006B }
; 0000 006C  if (upState >= 4)
_0x7:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0x17
; 0000 006D       {
; 0000 006E         val--;
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
; 0000 006F         upState = 0;
	CLR  R12
	CLR  R13
; 0000 0070       }
; 0000 0071       if (downState >= 4)
_0x17:
	LDS  R26,_downState
	LDS  R27,_downState+1
	SBIW R26,4
	BRLO _0x18
; 0000 0072       {
; 0000 0073         val++;
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
; 0000 0074         downState = 0;
	LDI  R30,LOW(0)
	STS  _downState,R30
	STS  _downState+1,R30
; 0000 0075       }
; 0000 0076  return val;
_0x18:
	LD   R30,Y
	RJMP _0x2080001
; 0000 0077 }
;
;void MSCS_com_veryfy(unsigned char *data,unsigned char ret[17]){
; 0000 0079 void MSCS_com_veryfy(unsigned char *data,unsigned char ret[17]){
_MSCS_com_veryfy:
; 0000 007A MSCS_com(data,ret);
;	*data -> Y+2
;	ret -> Y+0
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL _MSCS_com
; 0000 007B while(!((ret[12]=='g')&&(ret[13]=='e')&&(ret[14]=='r')&&(ret[15]=='b'))){
_0x19:
	RCALL SUBOPT_0x6
	ADIW R26,12
	LD   R26,X
	CPI  R26,LOW(0x67)
	BRNE _0x1C
	RCALL SUBOPT_0x6
	ADIW R26,13
	LD   R26,X
	CPI  R26,LOW(0x65)
	BRNE _0x1C
	RCALL SUBOPT_0x6
	ADIW R26,14
	LD   R26,X
	CPI  R26,LOW(0x72)
	BRNE _0x1C
	RCALL SUBOPT_0x6
	ADIW R26,15
	LD   R26,X
	CPI  R26,LOW(0x62)
	BREQ _0x1B
_0x1C:
; 0000 007C MSCS_com(data,ret);
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL _MSCS_com
; 0000 007D }
	RJMP _0x19
_0x1B:
; 0000 007E }
	ADIW R28,4
	RET
;
;void main(void)
; 0000 0081 {
_main:
; 0000 0082 // Declare your local variables here
; 0000 0083 unsigned char buf[32],buf1[17],buf2[17];
; 0000 0084 float ft;
; 0000 0085 unsigned char m1,m2=0,m3=0,m4=0; //m1-galet switcher m2 - timer for read to Vol - 1-6 m3 - port POWER m4 - pulsegen
; 0000 0086 
; 0000 0087 // Input/Output Ports initialization
; 0000 0088 // Port B initialization
; 0000 0089 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 008A // State7=T State6=T State5=T State4=T State3=T State2=T State1=P State0=P
; 0000 008B PORTB=0x03;
	SBIW R28,63
	SBIW R28,7
;	buf -> Y+38
;	buf1 -> Y+21
;	buf2 -> Y+4
;	ft -> Y+0
;	m1 -> R17
;	m2 -> R16
;	m3 -> R19
;	m4 -> R18
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R30,LOW(3)
	OUT  0x18,R30
; 0000 008C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 008D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(4)
	OUT  0x17,R30
; 0000 008E 
; 0000 008F 
; 0000 0090 // Port C initialization
; 0000 0091 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0092 // State6=T State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 0093 PORTC=0x3F;
	LDI  R30,LOW(63)
	OUT  0x15,R30
; 0000 0094 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0095 
; 0000 0096 // Port D initialization
; 0000 0097 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0098 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0099 PORTD=0x00;
	OUT  0x12,R30
; 0000 009A DDRD=0x00;
	OUT  0x11,R30
; 0000 009B 
; 0000 009C // Timer/Counter 0 initialization
; 0000 009D // Clock source: System Clock
; 0000 009E // Clock value: Timer 0 Stopped
; 0000 009F TCCR0=0x00;
	OUT  0x33,R30
; 0000 00A0 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00A1 
; 0000 00A2 // Timer/Counter 1 initialization
; 0000 00A3 // Clock source: System Clock
; 0000 00A4 // Clock value: Timer1 Stopped
; 0000 00A5 // Mode: Normal top=0xFFFF
; 0000 00A6 // OC1A output: Discon.
; 0000 00A7 // OC1B output: Discon.
; 0000 00A8 // Noise Canceler: Off
; 0000 00A9 // Input Capture on Falling Edge
; 0000 00AA // Timer1 Overflow Interrupt: Off
; 0000 00AB // Input Capture Interrupt: Off
; 0000 00AC // Compare A Match Interrupt: Off
; 0000 00AD // Compare B Match Interrupt: Off
; 0000 00AE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00AF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00B0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00B3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00B4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00B5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00B6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00B7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00B8 
; 0000 00B9 
; 0000 00BA // Timer/Counter 2 initialization
; 0000 00BB // Clock source: System Clock
; 0000 00BC // Clock value: Timer2 Stopped
; 0000 00BD // Mode: Normal top=0xFF
; 0000 00BE // OC2 output: Disconnected
; 0000 00BF ASSR=0x00;
	OUT  0x22,R30
; 0000 00C0 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00C1 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00C2 OCR2=0x00;
	OUT  0x23,R30
; 0000 00C3 
; 0000 00C4 // External Interrupt(s) initialization
; 0000 00C5 // INT0: Off
; 0000 00C6 // INT1: Off
; 0000 00C7 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00C8 
; 0000 00C9 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00CA TIMSK=0x00;
	OUT  0x39,R30
; 0000 00CB 
; 0000 00CC // USART initialization
; 0000 00CD // USART disabled
; 0000 00CE UCSRB=0x00;
	OUT  0xA,R30
; 0000 00CF 
; 0000 00D0 // Analog Comparator initialization
; 0000 00D1 // Analog Comparator: Off
; 0000 00D2 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D3 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D4 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00D5 
; 0000 00D6 // ADC initialization
; 0000 00D7 // ADC Clock frequency: 1000,000 kHz
; 0000 00D8 // ADC Voltage Reference: Int., cap. on AREF
; 0000 00D9 ADMUX=0;
	OUT  0x7,R30
; 0000 00DA ADCSRA=0;
	OUT  0x6,R30
; 0000 00DB 
; 0000 00DC // SPI initialization
; 0000 00DD // SPI disabled
; 0000 00DE SPCR=0x00;
	OUT  0xD,R30
; 0000 00DF 
; 0000 00E0 // TWI initialization
; 0000 00E1 // TWI disabled
; 0000 00E2 TWCR=0x00;
	OUT  0x36,R30
; 0000 00E3 
; 0000 00E4 // Alphanumeric LCD initialization
; 0000 00E5 // Connections specified in the
; 0000 00E6 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00E7 // RS - PORTD Bit 0
; 0000 00E8 // RD - PORTD Bit 1
; 0000 00E9 // EN - PORTD Bit 2
; 0000 00EA // D4 - PORTD Bit 3
; 0000 00EB // D5 - PORTD Bit 4
; 0000 00EC // D6 - PORTD Bit 5
; 0000 00ED // D7 - PORTD Bit 6
; 0000 00EE // Characters/line: 8
; 0000 00EF lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 00F0 MSCS_init();
	RCALL _MSCS_init
; 0000 00F1 delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x7
	RCALL _delay_ms
; 0000 00F2 
; 0000 00F3  lcd_puts("Start!");
	__POINTW1MN _0x1E,0
	RCALL SUBOPT_0x7
	RCALL _lcd_puts
; 0000 00F4 // delay_ms(2000);
; 0000 00F5 // Global enable interrupts
; 0000 00F6 #asm("sei")
	sei
; 0000 00F7 
; 0000 00F8 while (1)
_0x1F:
; 0000 00F9       {
; 0000 00FA 
; 0000 00FB 
; 0000 00FC 
; 0000 00FD       m1=PINC;
	IN   R17,19
; 0000 00FE       /*
; 0000 00FF       m1=0x00;
; 0000 0100       delay_ms (100);
; 0000 0101       // */
; 0000 0102 sprintf(buf,"");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,6
	RCALL SUBOPT_0x9
; 0000 0103 switch (m1&0b1111)
	MOV  R30,R17
	RCALL SUBOPT_0xA
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
; 0000 0104 {
; 0000 0105     case 0xC:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x25
; 0000 0106     MSCS_com_veryfy("                ",buf1);
	__POINTW1MN _0x1E,7
	RCALL SUBOPT_0xB
; 0000 0107     sprintf(buf,"h-%2um-%2u        s-%2u",buf1[9],buf1[10],buf1[11]);
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,24
	RCALL SUBOPT_0x7
	LDD  R30,Y+34
	RCALL SUBOPT_0xC
	LDD  R30,Y+39
	RCALL SUBOPT_0xC
	LDD  R30,Y+44
	RCALL SUBOPT_0xC
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
; 0000 0108     break;
	RJMP _0x24
; 0000 0109     case 0x4:
_0x25:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x26
; 0000 010A     m2=encoder(m2);
	ST   -Y,R16
	RCALL _encoder
	MOV  R16,R30
; 0000 010B     if (m2>=250) m2=0;
	CPI  R16,250
	BRLO _0x27
	LDI  R16,LOW(0)
; 0000 010C     if (m2>7) m2=7;
_0x27:
	CPI  R16,8
	BRLO _0x28
	LDI  R16,LOW(7)
; 0000 010D     sprintf(buf,"SelTimer        Timer%u",m2+1);
_0x28:
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,48
	RCALL SUBOPT_0xD
	RJMP _0x51
; 0000 010E     break;
; 0000 010F     case 0x0:
_0x26:
	SBIW R30,0
	BRNE _0x29
; 0000 0110     if (!((m1&0b100000)&&0b100000)){
	SBRS R17,5
	RJMP _0x2B
	RCALL SUBOPT_0xE
	BRNE _0x2A
_0x2B:
; 0000 0111     MSCS_com_veryfy("                ",buf1);
	__POINTW1MN _0x1E,24
	RCALL SUBOPT_0xB
; 0000 0112     Vol=buf1[m2];
	MOV  R30,R16
	RCALL SUBOPT_0xA
	MOVW R26,R28
	ADIW R26,21
	ADD  R26,R30
	ADC  R27,R31
	LD   R7,X
; 0000 0113     }
; 0000 0114     Vol=encoder(Vol);
_0x2A:
	ST   -Y,R7
	RCALL _encoder
	MOV  R7,R30
; 0000 0115     sprintf(buf,"TimerNo%u        time=%u",m2+1,Vol);
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,72
	RCALL SUBOPT_0xD
	RCALL __PUTPARD1
	MOV  R30,R7
	RCALL SUBOPT_0xC
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 0116 
; 0000 0117     break;
	RJMP _0x24
; 0000 0118 
; 0000 0119     case 0x8:
_0x29:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x2D
; 0000 011A     sprintf(buf,"WriteNo%u        toMemory",m2+1);
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,97
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
; 0000 011B     if (!((m1&0b100000)&&0b100000)){
	SBRS R17,5
	RJMP _0x2F
	RCALL SUBOPT_0xE
	BRNE _0x2E
_0x2F:
; 0000 011C      buf2[0]='w';
	RCALL SUBOPT_0x10
; 0000 011D      buf2[1]='r';
; 0000 011E      buf2[2]='i';
; 0000 011F      buf2[3]='t';
; 0000 0120      buf2[4]='e';
; 0000 0121      buf2[5]='t';
	LDI  R30,LOW(116)
	STD  Y+9,R30
; 0000 0122      buf2[6]=m2;
	MOVW R30,R28
	ADIW R30,10
	ST   Z,R16
; 0000 0123      buf2[7]=Vol;
	MOVW R30,R28
	ADIW R30,11
	ST   Z,R7
; 0000 0124      MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x11
; 0000 0125      sprintf(buf,"WriteNo%u        Ok",m2+1);
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,123
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
; 0000 0126     }
; 0000 0127     break;
_0x2E:
	RJMP _0x24
; 0000 0128 
; 0000 0129 
; 0000 012A     case 0xA:
_0x2D:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x31
; 0000 012B     sprintf(buf,"Enable          testMode");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,143
	RCALL SUBOPT_0x9
; 0000 012C     if (!((m1&0b100000)&&0b100000)){
	SBRS R17,5
	RJMP _0x33
	RCALL SUBOPT_0xE
	BRNE _0x32
_0x33:
; 0000 012D      buf2[0]='w';
	RCALL SUBOPT_0x10
; 0000 012E      buf2[1]='r';
; 0000 012F      buf2[2]='i';
; 0000 0130      buf2[3]='t';
; 0000 0131      buf2[4]='e';
; 0000 0132      buf2[5]='e';
	LDI  R30,LOW(101)
	STD  Y+9,R30
; 0000 0133      MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x11
; 0000 0134      sprintf(buf,"Enable        Tmode Ok");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,168
	RCALL SUBOPT_0x9
; 0000 0135     }
; 0000 0136     break;
_0x32:
	RJMP _0x24
; 0000 0137     case 0x2:
_0x31:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x35
; 0000 0138     m3=encoder(m3);
	ST   -Y,R19
	RCALL _encoder
	MOV  R19,R30
; 0000 0139     if (m3>=250) m3=0;
	CPI  R19,250
	BRLO _0x36
	LDI  R19,LOW(0)
; 0000 013A     if (m3>3) m3=3;
_0x36:
	CPI  R19,4
	BRLO _0x37
	LDI  R19,LOW(3)
; 0000 013B     sprintf(buf,"PORT No%u        Switch",m3+1);
_0x37:
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,191
	RCALL SUBOPT_0x7
	MOV  R30,R19
	RCALL SUBOPT_0xA
	ADIW R30,1
	RCALL __CWD1
	RCALL SUBOPT_0xF
; 0000 013C      if (!((m1&0b100000)&&0b100000)){
	SBRS R17,5
	RJMP _0x39
	RCALL SUBOPT_0xE
	BRNE _0x38
_0x39:
; 0000 013D      buf2[0]='w';
	RCALL SUBOPT_0x10
; 0000 013E      buf2[1]='r';
; 0000 013F      buf2[2]='i';
; 0000 0140      buf2[3]='t';
; 0000 0141      buf2[4]='e';
; 0000 0142      buf2[5]='s';
	LDI  R30,LOW(115)
	STD  Y+9,R30
; 0000 0143      buf2[6]=m3;
	MOVW R30,R28
	ADIW R30,10
	ST   Z,R19
; 0000 0144      MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x11
; 0000 0145      sprintf(buf,"PORT       SwitchOk");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,215
	RCALL SUBOPT_0x9
; 0000 0146     }
; 0000 0147     break;
_0x38:
	RJMP _0x24
; 0000 0148     case 0x6:
_0x35:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x3B
; 0000 0149     sprintf(buf,"Menu 7 ");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,235
	RCALL SUBOPT_0x9
; 0000 014A     break;
	RJMP _0x24
; 0000 014B     case 0xE:
_0x3B:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x3C
; 0000 014C     sprintf(buf,"Menu 8 ");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,243
	RCALL SUBOPT_0x9
; 0000 014D     break;
	RJMP _0x24
; 0000 014E     case 0xF:
_0x3C:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x3D
; 0000 014F     sprintf(buf,"Menu 9 ");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,251
	RCALL SUBOPT_0x9
; 0000 0150     break;
	RJMP _0x24
; 0000 0151     case 0xD:
_0x3D:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x3E
; 0000 0152     sprintf(buf,"Menu 10");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,259
	RCALL SUBOPT_0x9
; 0000 0153     break;
	RJMP _0x24
; 0000 0154     case 0x5:
_0x3E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x3F
; 0000 0155     sprintf(buf,"Menu 11");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,267
	RCALL SUBOPT_0x9
; 0000 0156     break;
	RJMP _0x24
; 0000 0157     case 0x1:
_0x3F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x40
; 0000 0158     sprintf(buf,"Menu 12");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,275
	RCALL SUBOPT_0x9
; 0000 0159     break;
	RJMP _0x24
; 0000 015A     case 0x9:
_0x40:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x41
; 0000 015B     sprintf(buf,"Menu 13");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,283
	RCALL SUBOPT_0x9
; 0000 015C     break;
	RJMP _0x24
; 0000 015D     case 0xB:
_0x41:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x42
; 0000 015E     if (!((m1&0b100000)&&0b100000)){
	SBRS R17,5
	RJMP _0x44
	RCALL SUBOPT_0xE
	BRNE _0x43
_0x44:
; 0000 015F     if (!m4){
	CPI  R18,0
	BRNE _0x46
; 0000 0160     Vol=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0161     m4=1;
	LDI  R18,LOW(1)
; 0000 0162    // TCCR1A|=(1<<COM1B0);
; 0000 0163     TCCR1B|=(1<<CS12)|(1<<CS10);
	IN   R30,0x2E
	ORI  R30,LOW(0x5)
	OUT  0x2E,R30
; 0000 0164     OCR1A=15629;
	LDI  R30,LOW(15629)
	LDI  R31,HIGH(15629)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0165     OCR1B=15625;
	LDI  R30,LOW(15625)
	LDI  R31,HIGH(15625)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0166     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0167     TIMSK|=(1<<OCIE1A) | (1<<OCIE1B);
	IN   R30,0x39
	ORI  R30,LOW(0x18)
	RJMP _0x52
; 0000 0168     } else {
_0x46:
; 0000 0169     m4=0;
	LDI  R18,LOW(0)
; 0000 016A     TCCR1A&=~(1<<COM1B0);
	IN   R30,0x2F
	ANDI R30,0xEF
	OUT  0x2F,R30
; 0000 016B     TCCR1B&=~((1<<CS12)|(1<<CS10));
	IN   R30,0x2E
	ANDI R30,LOW(0xFA)
	OUT  0x2E,R30
; 0000 016C     TIMSK&=~((1<<OCIE1A) | (1<<OCIE1B));
	IN   R30,0x39
	ANDI R30,LOW(0xE7)
_0x52:
	OUT  0x39,R30
; 0000 016D     }
; 0000 016E }
; 0000 016F     Vol=encoder(Vol);
_0x43:
	ST   -Y,R7
	RCALL _encoder
	MOV  R7,R30
; 0000 0170     OCR1B=15625/Vol;
	MOV  R30,R7
	RCALL SUBOPT_0xA
	LDI  R26,LOW(15625)
	LDI  R27,HIGH(15625)
	RCALL __DIVW21
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0171     if (m4)    sprintf(buf,"PulseGen        ON%4uOB",Vol*60);
	CPI  R18,0
	BREQ _0x48
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,291
	RCALL SUBOPT_0x7
	MOV  R26,R7
	LDI  R30,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	RCALL __CWD1
	RCALL SUBOPT_0xF
; 0000 0172     else sprintf(buf,"PulseGen        OFF     ");
	RJMP _0x49
_0x48:
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,315
	RCALL SUBOPT_0x9
; 0000 0173     break;
_0x49:
	RJMP _0x24
; 0000 0174     case 0x3:
_0x42:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4A
; 0000 0175     sprintf(buf,"Restart        clock");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,340
	RCALL SUBOPT_0x9
; 0000 0176     if (!((m1&0b100000)&&0b100000)){
	SBRS R17,5
	RJMP _0x4C
	RCALL SUBOPT_0xE
	BRNE _0x4B
_0x4C:
; 0000 0177      buf2[0]='w';
	RCALL SUBOPT_0x10
; 0000 0178      buf2[1]='r';
; 0000 0179      buf2[2]='i';
; 0000 017A      buf2[3]='t';
; 0000 017B      buf2[4]='e';
; 0000 017C      buf2[5]='c';
	LDI  R30,LOW(99)
	STD  Y+9,R30
; 0000 017D      MSCS_com_veryfy(buf2,buf1);
	RCALL SUBOPT_0x11
; 0000 017E      sprintf(buf,"Restart        clock-Ok");
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,361
	RCALL SUBOPT_0x9
; 0000 017F      }
; 0000 0180     break;
_0x4B:
	RJMP _0x24
; 0000 0181     case 0x7:
_0x4A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x4F
; 0000 0182     // ADC initialization
; 0000 0183 // ADC Clock frequency: 1000,000 kHz
; 0000 0184 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0185 ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(71)
	OUT  0x7,R30
; 0000 0186 ADCSRA=0xCC;
	LDI  R30,LOW(204)
	OUT  0x6,R30
; 0000 0187     ft=0.005*adc_data;
	MOVW R30,R4
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3BA3D70A
	RCALL __MULF12
	RCALL __PUTD1S0
; 0000 0188     sprintf(buf,"Voltmetr        %1.3fVol",ft);
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,385
	RCALL SUBOPT_0x7
	__GETD1S 4
	RJMP _0x51
; 0000 0189     break;
; 0000 018A     default:
_0x4F:
; 0000 018B     sprintf(buf,"Pressed button   %X",PINC);
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,410
	RCALL SUBOPT_0x7
	IN   R30,0x13
	CLR  R31
	CLR  R22
	CLR  R23
_0x51:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 018C }
_0x24:
; 0000 018D       lcd_clear();
	RCALL _lcd_clear
; 0000 018E       lcd_gotoxy(0,0);
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x12
	RCALL _lcd_gotoxy
; 0000 018F       lcd_puts(buf);
	RCALL SUBOPT_0x8
	RCALL _lcd_puts
; 0000 0190       }
	RJMP _0x1F
; 0000 0191 }
_0x50:
	RJMP _0x50

	.DSEG
_0x1E:
	.BYTE 0x29
;    // */
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
; 0001 0014 #ifdef CV
; 0001 0015 delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x13
; 0001 0016 #else
; 0001 0017 _delay_ms(1);
; 0001 0018 #endif
; 0001 0019 }
	RET
;
;void mosi(unsigned char mos){
; 0001 001B void mosi(unsigned char mos){
_mosi:
; 0001 001C  if (mos){
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
	RJMP _0x2080001
;
;void clk(unsigned char cl){
; 0001 0023 void clk(unsigned char cl){
_clk:
; 0001 0024  if (cl){
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
	RJMP _0x2080001
;
;unsigned char miso(void){
; 0001 002B unsigned char miso(void){
_miso:
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
;
;void MSCS_com(unsigned char *data,unsigned char ret[17]){
; 0001 002F void MSCS_com(unsigned char *data,unsigned char ret[17]){
_MSCS_com:
; 0001 0030 
; 0001 0031 unsigned char buffer,resiver=0,i,j;
; 0001 0032 mosi(1);
	RCALL __SAVELOCR4
;	*data -> Y+6
;	ret -> Y+4
;	buffer -> R17
;	resiver -> R16
;	i -> R19
;	j -> R18
	LDI  R16,0
	RCALL SUBOPT_0x14
	RCALL _mosi
; 0001 0033 for (i=0; i<16; i++){
	LDI  R19,LOW(0)
_0x2000A:
	CPI  R19,16
	BRSH _0x2000B
; 0001 0034     buffer=data[i];
	LDD  R26,Y+6
	LDD  R27,Y+6+1
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
	RCALL SUBOPT_0x14
	RCALL _clk
; 0001 0037         MSCS_delay();
	RCALL _MSCS_delay
; 0001 0038         mosi(((buffer<<j)&0b10000000)&&0x80);
	MOV  R26,R17
	LDI  R27,0
	MOV  R30,R18
	RCALL __LSLW12
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
	ST   -Y,R30
	RCALL _mosi
; 0001 0039         MSCS_delay();
	RCALL _MSCS_delay
; 0001 003A         clk(0);
	RCALL SUBOPT_0x12
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
	RCALL SUBOPT_0xA
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
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 0042 clk(1);
	RCALL SUBOPT_0x14
	RCALL _clk
; 0001 0043 MSCS_delay();
	RCALL _MSCS_delay
; 0001 0044 clk(0);
	RCALL SUBOPT_0x12
	RCALL _clk
; 0001 0045 mosi(0);
	RCALL SUBOPT_0x12
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
; 0001 004B }
	RCALL __LOADLOCR4
	ADIW R28,8
	RET
;
;void MSCS_init(void){
; 0001 004D void MSCS_init(void){
_MSCS_init:
; 0001 004E DDRMOSI|=(1<<MOSI_BIT);
	SBI  0x17,3
; 0001 004F MOSI_PORT&=~(1<<MOSI_BIT);
	CBI  0x18,3
; 0001 0050 DDRMISO&=~(1<<MISO_BIT);
	CBI  0x17,4
; 0001 0051 MISO_PORT&=~(1<<MISO_BIT);
	CBI  0x16,4
; 0001 0052 DDRCLK|=(1<<CLK_BIT);
	SBI  0x17,5
; 0001 0053 CLK_PORT&=~(1<<CLK_BIT);
	CBI  0x18,5
; 0001 0054 }
	RET
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
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x15
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x15
	ADIW R26,2
	RCALL SUBOPT_0x17
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x15
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x15
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x18
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x18
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x19
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1B
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x1F
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x1F
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x20
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x20
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x20
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x18
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x1F
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x1F
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x20
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1B
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x21
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080002
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1F
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x7
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x7
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x7
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080002:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x12,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x12,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x12,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x12,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x12,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x12,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x12,7
_0x202000B:
	__DELAY_USB 11
	SBI  0x12,2
	__DELAY_USB 27
	CBI  0x12,2
	__DELAY_USB 27
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x22
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x22
	__DELAY_USW 200
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	RCALL SUBOPT_0xA
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x23
	LDD  R6,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x23
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x14
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R6,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	CP   R6,R30
	BRLO _0x2020010
_0x2020011:
	RCALL SUBOPT_0x12
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080001
_0x2020010:
	INC  R6
	SBI  0x12,0
	LD   R30,Y
	RCALL SUBOPT_0x23
	CBI  0x12,0
	RJMP _0x2080001
_lcd_puts:
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
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x11,7
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
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x13
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x25
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x23
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x23
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x23
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x23
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
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
_strlenf:
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

	.DSEG
_downState:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_downState)
	LDI  R27,HIGH(_downState)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 78 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:44 WORDS
SUBOPT_0x8:
	MOVW R30,R28
	ADIW R30,38
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x7
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xA:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x7
	MOVW R30,R28
	ADIW R30,23
	RCALL SUBOPT_0x7
	RJMP _MSCS_com_veryfy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x7
	MOV  R30,R16
	RCALL SUBOPT_0xA
	ADIW R30,1
	RCALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(32)
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x10:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x7
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x18:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x7
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x7
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x19
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	__DELAY_USW 400
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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
