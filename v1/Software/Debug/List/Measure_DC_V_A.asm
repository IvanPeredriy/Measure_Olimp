
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8L
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega8L
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
	.DEF _sample=R5
	.DEF _count=R4
	.DEF _adc_input=R7
	.DEF _A1=R8
	.DEF _A1_msb=R9
	.DEF _A2=R10
	.DEF _A2_msb=R11
	.DEF __lcd_x=R6
	.DEF __lcd_y=R13
	.DEF __lcd_maxx=R12

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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x55,0x3D,0x25,0x2E,0x31,0x66,0x42,0x0
	.DB  0x55,0x3D,0x25,0x2E,0x32,0x66,0x42,0x0
	.DB  0x49,0x3D,0x25,0x2E,0x32,0x66,0x41,0x0
	.DB  0x49,0x3D,0x25,0x2D,0x33,0x64,0x6D,0x41
	.DB  0x0,0x44,0x65,0x76,0x65,0x6C,0x6F,0x70
	.DB  0x65,0x64,0x20,0x69,0x6E,0x0,0x4E,0x4B
	.DB  0x50,0x54,0x2D,0x32,0x30,0x31,0x37,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;/*******************************************************
;This program was created by the CodeWizardAVR V3.30
;Automatic Program Generator
;© Copyright 1998-2017 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Measure_DC_V_A
;Version : 1.0
;Date    : 10.04.2017
;Author  : Nazarenko Ivan
;Company :
;Comments:
;Устройство 2-х канального измерения
;напряжения и тока.
;Диапазон измерения напряжения 0 - 30 В
;Диапазон измерения тока       0 - 2,5 А
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <io.h>         // библиотека для работы с портами ввода-вывода
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
;#include <delay.h>      // библиотека задержки
;
;// Alphanumeric LCD functions
;#include <alcd.h>       // библиотека для работы с дисплеем
;
;#include <stdio.h>      // библиотека для дисплея, sprintf не будет работать без нее
;
;// Voltage Reference: Int., cap. on AREF
;#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR)) // опорное 2,56 В
;
;// ************** Глобальные переменные **************
;unsigned char sample=0, count=0, adc_input=0;
;
;char U_channel_1[10], I_channel_1[10], U_channel_2[10], I_channel_2[10];
;
;unsigned int A1=0, A2=0;
;
;float sample_U1=0, sample_U2=0, sample_I1=0, sample_I2=0,
;averaging_U1=0, averaging_U2=0, averaging_I1=0, averaging_I2=0,
;adc_U1=0, adc_U2=0, adc_I1=0, adc_I2=0,
;U1=0, U2=0, I1=0, I2=0;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0035 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036 
; 0000 0037  TCCR0=0x00; // останавливаем таймер T0 на время выполнения кода
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0038  TCNT0=0x00; // обнуляем счетный регистр таймера T0
	OUT  0x32,R30
; 0000 0039 // ************ АЦП ************
; 0000 003A // Опрос 4 каналов
; 0000 003B while(adc_input<4) // остаемя в цикле пока не опросим все 4 канала АЦП
_0x3:
	LDI  R30,LOW(4)
	CP   R7,R30
	BRSH _0x5
; 0000 003C     {
; 0000 003D      ADMUX=((adc_input) | (ADC_VREF_TYPE & 0xFF)); // выбираем канал
	MOV  R30,R7
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 003E      // Начать преобразование АЦП
; 0000 003F      ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0040      // ждем, пока АЦП закончит преобразование (ADIF = 0)
; 0000 0041      while ((ADCSRA & (1<<ADIF))==0);
_0x6:
	SBIS 0x6,4
	RJMP _0x6
; 0000 0042      // сбрасываем ADIF, флаг прерываения окончания преобразования
; 0000 0043      ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0044 
; 0000 0045      // Чтение результата преобразования канала АЦП
; 0000 0046      switch(adc_input)
	MOV  R30,R7
; 0000 0047           {
; 0000 0048            case 0:{sample_U1+=ADCW; break;} // прибавляем к счетчику оверсемплинга
	CPI  R30,0
	BRNE _0xC
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RJMP _0xB
; 0000 0049            case 1:{sample_I1+=ADCW; break;}
_0xC:
	CPI  R30,LOW(0x1)
	BRNE _0xD
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
	RJMP _0xB
; 0000 004A            case 2:{sample_U2+=ADCW; break;}
_0xD:
	CPI  R30,LOW(0x2)
	BRNE _0xE
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
	RJMP _0xB
; 0000 004B            case 3:{sample_I2+=ADCW; break;}
_0xE:
	CPI  R30,LOW(0x3)
	BRNE _0xB
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x9
; 0000 004C           }
_0xB:
; 0000 004D      adc_input++;
	INC  R7
; 0000 004E     }
	RJMP _0x3
_0x5:
; 0000 004F 
; 0000 0050   adc_input=0;// выставляем начальный канал АЦП
	CLR  R7
; 0000 0051 
; 0000 0052 
; 0000 0053 // *** Оверсемплинг АЦП ( 4,096 мс ) *** (16 выборок * через каждые 256 мкс)
; 0000 0054    sample++;
	INC  R5
; 0000 0055 if(sample==16)
	LDI  R30,LOW(16)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x10
; 0000 0056   {
; 0000 0057    count++;
	INC  R4
; 0000 0058    sample=0;
	CLR  R5
; 0000 0059 
; 0000 005A    sample_U1=sample_U1 / 4;
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x3
; 0000 005B    averaging_U1+=sample_U1;
	LDS  R30,_sample_U1
	LDS  R31,_sample_U1+1
	LDS  R22,_sample_U1+2
	LDS  R23,_sample_U1+3
	RCALL SUBOPT_0xB
	RCALL __ADDF12
	STS  _averaging_U1,R30
	STS  _averaging_U1+1,R31
	STS  _averaging_U1+2,R22
	STS  _averaging_U1+3,R23
; 0000 005C 
; 0000 005D    sample_I1=sample_I1 / 4;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x5
; 0000 005E    averaging_I1+=sample_I1;
	LDS  R30,_sample_I1
	LDS  R31,_sample_I1+1
	LDS  R22,_sample_I1+2
	LDS  R23,_sample_I1+3
	RCALL SUBOPT_0xC
	RCALL __ADDF12
	STS  _averaging_I1,R30
	STS  _averaging_I1+1,R31
	STS  _averaging_I1+2,R22
	STS  _averaging_I1+3,R23
; 0000 005F 
; 0000 0060    sample_U2=sample_U2 / 4;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x7
; 0000 0061    averaging_U2+=sample_U2;
	LDS  R30,_sample_U2
	LDS  R31,_sample_U2+1
	LDS  R22,_sample_U2+2
	LDS  R23,_sample_U2+3
	RCALL SUBOPT_0xD
	RCALL __ADDF12
	STS  _averaging_U2,R30
	STS  _averaging_U2+1,R31
	STS  _averaging_U2+2,R22
	STS  _averaging_U2+3,R23
; 0000 0062 
; 0000 0063    sample_I2=sample_I2 / 4;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x9
; 0000 0064    averaging_I2+=sample_I2;
	LDS  R30,_sample_I2
	LDS  R31,_sample_I2+1
	LDS  R22,_sample_I2+2
	LDS  R23,_sample_I2+3
	RCALL SUBOPT_0xE
	RCALL __ADDF12
	STS  _averaging_I2,R30
	STS  _averaging_I2+1,R31
	STS  _averaging_I2+2,R22
	STS  _averaging_I2+3,R23
; 0000 0065                                                                                                                          ...
; 0000 0066    sample_U1=0;
	LDI  R30,LOW(0)
	STS  _sample_U1,R30
	STS  _sample_U1+1,R30
	STS  _sample_U1+2,R30
	STS  _sample_U1+3,R30
; 0000 0067    sample_I1=0;
	STS  _sample_I1,R30
	STS  _sample_I1+1,R30
	STS  _sample_I1+2,R30
	STS  _sample_I1+3,R30
; 0000 0068    sample_U2=0;
	STS  _sample_U2,R30
	STS  _sample_U2+1,R30
	STS  _sample_U2+2,R30
	STS  _sample_U2+3,R30
; 0000 0069    sample_I2=0;
	STS  _sample_I2,R30
	STS  _sample_I2+1,R30
	STS  _sample_I2+2,R30
	STS  _sample_I2+3,R30
; 0000 006A }
; 0000 006B 
; 0000 006C // *** Усреднение измерения оверсемплинга (обновления данных на дисплее) ( 262,144 мс )
; 0000 006D // *** (64 выборок * через каждые 4,096 мс оверсемплинга)
; 0000 006E  if(count==64)
_0x10:
	LDI  R30,LOW(64)
	CP   R30,R4
	BREQ PC+2
	RJMP _0x11
; 0000 006F    {
; 0000 0070     count=0;
	CLR  R4
; 0000 0071 
; 0000 0072     adc_U1 = averaging_U1 / 64;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xF
	STS  _adc_U1,R30
	STS  _adc_U1+1,R31
	STS  _adc_U1+2,R22
	STS  _adc_U1+3,R23
; 0000 0073     adc_I1 = averaging_I1 / 64;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xF
	STS  _adc_I1,R30
	STS  _adc_I1+1,R31
	STS  _adc_I1+2,R22
	STS  _adc_I1+3,R23
; 0000 0074     adc_U2 = averaging_U2 / 64;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	STS  _adc_U2,R30
	STS  _adc_U2+1,R31
	STS  _adc_U2+2,R22
	STS  _adc_U2+3,R23
; 0000 0075     adc_I2 = averaging_I2 / 64;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	STS  _adc_I2,R30
	STS  _adc_I2+1,R31
	STS  _adc_I2+2,R22
	STS  _adc_I2+3,R23
; 0000 0076                                                                                                                          ...
; 0000 0077     averaging_U1=0;
	LDI  R30,LOW(0)
	STS  _averaging_U1,R30
	STS  _averaging_U1+1,R30
	STS  _averaging_U1+2,R30
	STS  _averaging_U1+3,R30
; 0000 0078     averaging_I1=0;
	STS  _averaging_I1,R30
	STS  _averaging_I1+1,R30
	STS  _averaging_I1+2,R30
	STS  _averaging_I1+3,R30
; 0000 0079     averaging_U2=0;
	STS  _averaging_U2,R30
	STS  _averaging_U2+1,R30
	STS  _averaging_U2+2,R30
	STS  _averaging_U2+3,R30
; 0000 007A     averaging_I2=0;
	STS  _averaging_I2,R30
	STS  _averaging_I2+1,R30
	STS  _averaging_I2+2,R30
	STS  _averaging_I2+3,R30
; 0000 007B 
; 0000 007C      // *** Обработка измеренных данных ***
; 0000 007D 
; 0000 007E     if(I1>0.0) // если ток в канале 1 больше 0
	RCALL SUBOPT_0x10
	RCALL __CPD02
	BRGE _0x12
; 0000 007F      {
; 0000 0080       I1 = (adc_I1 * 0.000625)-0.015;        // формула для расчета тока в 1 канале
	LDS  R26,_adc_I1
	LDS  R27,_adc_I1+1
	LDS  R24,_adc_I1+2
	LDS  R25,_adc_I1+3
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
; 0000 0081                                              // 0,015 срезаем 15 мА, устанавливая этим 0 мА тока, при х.х. выхода Б.П.
; 0000 0082                                              // 0,000625 константа (2,56В/4096(12ббитное разрешение)=0,000625)
; 0000 0083 
; 0000 0084       U1 = ((adc_U1 * 0.000625)*7)-I1*0.112; // вычисляем напряжение с учетом вычета потерь на датчике тока в канале 1
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x17
	RJMP _0x24
; 0000 0085      }
; 0000 0086 
; 0000 0087     else                                     // если 0 то уста. 0 на диспле
_0x12:
; 0000 0088      {
; 0000 0089      I1=0;
	LDI  R30,LOW(0)
	STS  _I1,R30
	STS  _I1+1,R30
	STS  _I1+2,R30
	STS  _I1+3,R30
; 0000 008A      U1 = (adc_U1 * 0.000625)*7;             // напряжение холостого хода в канале 1
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
_0x24:
	STS  _U1,R30
	STS  _U1+1,R31
	STS  _U1+2,R22
	STS  _U1+3,R23
; 0000 008B      }
; 0000 008C 
; 0000 008D 
; 0000 008E 
; 0000 008F    if(I2>0.0) // если ток в канале 2 больше 0
	RCALL SUBOPT_0x18
	RCALL __CPD02
	BRGE _0x14
; 0000 0090      {
; 0000 0091       I2 = (adc_I2 * 0.000625)-0.015;        // формула для расчета тока в 2 канале
	LDS  R26,_adc_I2
	LDS  R27,_adc_I2+1
	LDS  R24,_adc_I2+2
	LDS  R25,_adc_I2+3
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x19
; 0000 0092                                              // 0,015 срезаем 15 мА, устанавливая этим 0 мА тока, при х.х. выхода Б.П.
; 0000 0093 
; 0000 0094       U2 = ((adc_U2 * 0.000625)*7)-I2*0.112; // вычисляем напряжение с учетом вычета потерь на датчике тока в канале 2
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x15
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x17
	RJMP _0x25
; 0000 0095      }
; 0000 0096 
; 0000 0097     else                                     // если 0 то уста. 0 на диспле
_0x14:
; 0000 0098      {
; 0000 0099       I2=0;
	LDI  R30,LOW(0)
	STS  _I2,R30
	STS  _I2+1,R30
	STS  _I2+2,R30
	STS  _I2+3,R30
; 0000 009A       U2 = (adc_U2 * 0.000625)*7;            // напряжение холостого хода в канале 2
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x15
_0x25:
	STS  _U2,R30
	STS  _U2+1,R31
	STS  _U2+2,R22
	STS  _U2+3,R23
; 0000 009B      }
; 0000 009C 
; 0000 009D 
; 0000 009E     if(U1<0.0) // на случай если напряжение будет отрицательно, чтобы не слетали знакоместа на дисплее
	LDS  R26,_U1+3
	TST  R26
	BRPL _0x16
; 0000 009F       {
; 0000 00A0        U1=0;
	LDI  R30,LOW(0)
	STS  _U1,R30
	STS  _U1+1,R30
	STS  _U1+2,R30
	STS  _U1+3,R30
; 0000 00A1       }
; 0000 00A2 
; 0000 00A3     if(U2<0.0) // на случай если напряжение будет отрицательно, чтобы не слетали знакоместа на дисплее
_0x16:
	LDS  R26,_U2+3
	TST  R26
	BRPL _0x17
; 0000 00A4       {
; 0000 00A5        U2=0;
	LDI  R30,LOW(0)
	STS  _U2,R30
	STS  _U2+1,R30
	STS  _U2+2,R30
	STS  _U2+3,R30
; 0000 00A6       }
; 0000 00A7 
; 0000 00A8     // Вывод на дисплей напряжения в канале 1
; 0000 00A9     lcd_gotoxy(0,0);
_0x17:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1B
; 0000 00AA 
; 0000 00AB     if (U1>9.99)
	LDS  R26,_U1
	LDS  R27,_U1+1
	LDS  R24,_U1+2
	LDS  R25,_U1+3
	RCALL SUBOPT_0x1C
	BREQ PC+2
	BRCC PC+2
	RJMP _0x18
; 0000 00AC       {
; 0000 00AD        sprintf(U_channel_1, "U=%.1fB",U1 );
	RCALL SUBOPT_0x1D
	__POINTW1FN _0x0,0
	RJMP _0x26
; 0000 00AE       }
; 0000 00AF 
; 0000 00B0     else
_0x18:
; 0000 00B1       {
; 0000 00B2        sprintf(U_channel_1, "U=%.2fB",U1 );
	RCALL SUBOPT_0x1D
	__POINTW1FN _0x0,8
_0x26:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_U1
	LDS  R31,_U1+1
	LDS  R22,_U1+2
	LDS  R23,_U1+3
	RCALL SUBOPT_0x1E
; 0000 00B3       }
; 0000 00B4 
; 0000 00B5     lcd_puts(U_channel_1);
	LDI  R26,LOW(_U_channel_1)
	LDI  R27,HIGH(_U_channel_1)
	RCALL _lcd_puts
; 0000 00B6 
; 0000 00B7     // Вывод на дисплей тока в канале 1
; 0000 00B8     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1F
; 0000 00B9     if(I1>0.999)
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x20
	BREQ PC+2
	BRCC PC+2
	RJMP _0x1A
; 0000 00BA       {
; 0000 00BB        sprintf(I_channel_1, "I=%.2fA",I1 );
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	RJMP _0x27
; 0000 00BC       }
; 0000 00BD 
; 0000 00BE     else
_0x1A:
; 0000 00BF       {
; 0000 00C0        I1=I1*1000;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x13
; 0000 00C1        A1=I1;
	RCALL SUBOPT_0x23
	RCALL __CFD1U
	MOVW R8,R30
; 0000 00C2        sprintf(I_channel_1, "I=%-3dmA",A1 );
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x25
	MOVW R30,R8
	CLR  R22
	CLR  R23
_0x27:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 00C3       }
; 0000 00C4 
; 0000 00C5     lcd_puts(I_channel_1);
	LDI  R26,LOW(_I_channel_1)
	LDI  R27,HIGH(_I_channel_1)
	RCALL _lcd_puts
; 0000 00C6 
; 0000 00C7     // Вывод на дисплей напряжения в канале 2
; 0000 00C8     lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1B
; 0000 00C9     if (U2>9.99)
	LDS  R26,_U2
	LDS  R27,_U2+1
	LDS  R24,_U2+2
	LDS  R25,_U2+3
	RCALL SUBOPT_0x1C
	BREQ PC+2
	BRCC PC+2
	RJMP _0x1C
; 0000 00CA       {
; 0000 00CB        sprintf(U_channel_2, "U=%.1fB",U2 );
	RCALL SUBOPT_0x26
	__POINTW1FN _0x0,0
	RJMP _0x28
; 0000 00CC       }
; 0000 00CD 
; 0000 00CE     else
_0x1C:
; 0000 00CF       {
; 0000 00D0        sprintf(U_channel_2, "U=%.2fB",U2 );
	RCALL SUBOPT_0x26
	__POINTW1FN _0x0,8
_0x28:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_U2
	LDS  R31,_U2+1
	LDS  R22,_U2+2
	LDS  R23,_U2+3
	RCALL SUBOPT_0x1E
; 0000 00D1       }
; 0000 00D2 
; 0000 00D3     lcd_puts(U_channel_2);
	LDI  R26,LOW(_U_channel_2)
	LDI  R27,HIGH(_U_channel_2)
	RCALL _lcd_puts
; 0000 00D4 
; 0000 00D5     // Вывод на дисплей тока в канале 2
; 0000 00D6     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1F
; 0000 00D7     if(I2>0.999)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x20
	BREQ PC+2
	BRCC PC+2
	RJMP _0x1E
; 0000 00D8       {
; 0000 00D9        sprintf(I_channel_2, "I=%.2fA",I2 );
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x28
	RJMP _0x29
; 0000 00DA       }
; 0000 00DB 
; 0000 00DC     else
_0x1E:
; 0000 00DD       {
; 0000 00DE        I2=I2*1000;
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x19
; 0000 00DF        A2=I2;
	RCALL SUBOPT_0x28
	RCALL __CFD1U
	MOVW R10,R30
; 0000 00E0        sprintf(I_channel_2, "I=%-3dmA",A2 );
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x25
	MOVW R30,R10
	CLR  R22
	CLR  R23
_0x29:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 00E1       }
; 0000 00E2 
; 0000 00E3     lcd_puts(I_channel_2);
	LDI  R26,LOW(_I_channel_2)
	LDI  R27,HIGH(_I_channel_2)
	RCALL _lcd_puts
; 0000 00E4 
; 0000 00E5    }
; 0000 00E6 
; 0000 00E7    TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);  // возобновляем работу таймера T0
_0x11:
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00E8 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;void main(void)
; 0000 00ED {
_main:
; .FSTART _main
; 0000 00EE // Declare your local variables here
; 0000 00EF 
; 0000 00F0 // Input/Output Ports initialization
; 0000 00F1 // Port C initialization
; 0000 00F2 // Function: Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00F3 DDRC=(1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(112)
	OUT  0x14,R30
; 0000 00F4 // State: Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00F5 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00F6 
; 0000 00F7 // Port D initialization
; 0000 00F8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00F9 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00FA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00FB PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00FC 
; 0000 00FD // Timer/Counter 0 initialization
; 0000 00FE // Clock source: System Clock
; 0000 00FF // Clock value: 1000,000 kHz
; 0000 0100 // Timer period: 0,256 ms
; 0000 0101 TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0102 
; 0000 0103 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0104 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0105 
; 0000 0106 // Analog Comparator initialization
; 0000 0107 // Analog Comparator: Off
; 0000 0108 // The Analog Comparator's positive input is
; 0000 0109 // connected to the AIN0 pin
; 0000 010A // The Analog Comparator's negative input is
; 0000 010B // connected to the AIN1 pin
; 0000 010C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 010D 
; 0000 010E // ADC initialization
; 0000 010F // ADC Clock frequency: 125,000 kHz
; 0000 0110 // ADC Voltage Reference: AREF pin
; 0000 0111 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 0112 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0113 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0114 
; 0000 0115 // Alphanumeric LCD initialization
; 0000 0116 // Connections are specified in the
; 0000 0117 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0118 // RS - PORTD Bit 0
; 0000 0119 // RD - PORTD Bit 1
; 0000 011A // EN - PORTD Bit 2
; 0000 011B // D4 - PORTD Bit 4
; 0000 011C // D5 - PORTD Bit 5
; 0000 011D // D6 - PORTD Bit 6
; 0000 011E // D7 - PORTD Bit 7
; 0000 011F // Characters/line: 16
; 0000 0120 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0121 
; 0000 0122 lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1B
; 0000 0123 lcd_putsf("Developed in");
	__POINTW2FN _0x0,33
	RCALL _lcd_putsf
; 0000 0124 lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1F
; 0000 0125 lcd_putsf("NKPT-2017");
	__POINTW2FN _0x0,46
	RCALL _lcd_putsf
; 0000 0126 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0127 lcd_clear();
	RCALL _lcd_clear
; 0000 0128 
; 0000 0129 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 012A // Globally enable interrupts
; 0000 012B #asm("sei")
	sei
; 0000 012C 
; 0000 012D while (1)
_0x20:
; 0000 012E       {
; 0000 012F 
; 0000 0130       }
	RJMP _0x20
; 0000 0131 }
_0x23:
	RJMP _0x23
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
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x12,R30
	RCALL SUBOPT_0x29
	SBI  0x12,2
	RCALL SUBOPT_0x29
	CBI  0x12,2
	RCALL SUBOPT_0x29
	RJMP _0x20C0006
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0006
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LDD  R13,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x2A
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R6,R12
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R13
	MOV  R26,R13
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0006
_0x2000007:
_0x2000004:
	INC  R6
	SBI  0x12,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,0
	RJMP _0x20C0006
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x20C0007
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL SUBOPT_0x2B
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20C0007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
	SBI  0x11,2
	SBI  0x11,0
	SBI  0x11,1
	CBI  0x12,2
	CBI  0x12,0
	CBI  0x12,1
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2C
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0006:
	ADIW R28,1
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

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	RCALL SUBOPT_0x2B
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x2D
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2E
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	RCALL SUBOPT_0x2D
	ADIW R26,2
	RCALL SUBOPT_0x2F
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	RCALL SUBOPT_0x2D
	RCALL __GETW1P
	TST  R31
	BRMI _0x2020014
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2F
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	RCALL SUBOPT_0x2D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__ftoe_G101:
; .FSTART __ftoe_G101
	RCALL SUBOPT_0x30
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
	BRNE _0x2020019
	RCALL SUBOPT_0x31
	__POINTW2FN _0x2020000,0
	RCALL _strcpyf
	RJMP _0x20C0005
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	RCALL SUBOPT_0x31
	__POINTW2FN _0x2020000,1
	RCALL _strcpyf
	RJMP _0x20C0005
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	RCALL SUBOPT_0x32
	BREQ _0x202001E
	RCALL SUBOPT_0x33
	RJMP _0x202001C
_0x202001E:
	RCALL SUBOPT_0x34
	RCALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	RCALL SUBOPT_0x33
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	RCALL SUBOPT_0x35
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2020021
	RCALL SUBOPT_0x33
_0x2020022:
	RCALL SUBOPT_0x35
	BRLO _0x2020024
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	RCALL SUBOPT_0x35
	BRSH _0x2020028
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	RCALL SUBOPT_0x33
_0x2020025:
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x35
	BRLO _0x2020029
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3A
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	__PUTD1S 4
	RCALL SUBOPT_0x36
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x3B
	RCALL __MULF12
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x39
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	RCALL SUBOPT_0x3D
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	RCALL SUBOPT_0x40
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2020113
_0x202002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2020113:
	ST   X,R30
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	RCALL SUBOPT_0x2B
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
	RCALL SUBOPT_0x42
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	RCALL SUBOPT_0x2F
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	RCALL SUBOPT_0x43
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	RCALL SUBOPT_0x43
	RJMP _0x2020114
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x44
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x46
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BRNE _0x202005A
_0x2020059:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x48
	RCALL __GETD1P
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	CPI  R26,LOW(0x20)
	BREQ _0x202005F
	RJMP _0x2020060
_0x202005B:
	RCALL SUBOPT_0x4B
	RCALL __ANEGF1
	RCALL SUBOPT_0x49
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x2020061
	LDD  R30,Y+21
	ST   -Y,R30
	RCALL SUBOPT_0x46
	RJMP _0x2020062
_0x2020061:
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	RCALL SUBOPT_0x4C
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020062:
_0x2020060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020064
	RCALL SUBOPT_0x4B
	RCALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _ftoa
	RJMP _0x2020065
_0x2020064:
	RCALL SUBOPT_0x4B
	RCALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G101
_0x2020065:
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x4D
	RJMP _0x2020066
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020068
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4D
	RJMP _0x2020069
_0x2020068:
	CPI  R30,LOW(0x70)
	BRNE _0x202006B
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x4C
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006D
	CP   R20,R17
	BRLO _0x202006E
_0x202006D:
	RJMP _0x202006C
_0x202006E:
	MOV  R17,R20
_0x202006C:
_0x2020066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006F
_0x202006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2020072
	CPI  R30,LOW(0x69)
	BRNE _0x2020073
_0x2020072:
	ORI  R16,LOW(4)
	RJMP _0x2020074
_0x2020073:
	CPI  R30,LOW(0x75)
	BRNE _0x2020075
_0x2020074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020076
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x4F
	LDI  R17,LOW(10)
	RJMP _0x2020077
_0x2020076:
	__GETD1N 0x2710
	RCALL SUBOPT_0x4F
	LDI  R17,LOW(5)
	RJMP _0x2020077
_0x2020075:
	CPI  R30,LOW(0x58)
	BRNE _0x2020079
	ORI  R16,LOW(8)
	RJMP _0x202007A
_0x2020079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20200B8
_0x202007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007C
	__GETD1N 0x10000000
	RCALL SUBOPT_0x4F
	LDI  R17,LOW(8)
	RJMP _0x2020077
_0x202007C:
	__GETD1N 0x1000
	RCALL SUBOPT_0x4F
	LDI  R17,LOW(4)
_0x2020077:
	CPI  R20,0
	BREQ _0x202007D
	ANDI R16,LOW(127)
	RJMP _0x202007E
_0x202007D:
	LDI  R20,LOW(1)
_0x202007E:
	SBRS R16,1
	RJMP _0x202007F
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x48
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x2020115
_0x202007F:
	SBRS R16,2
	RJMP _0x2020081
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4E
	RCALL __CWD1
	RJMP _0x2020115
_0x2020081:
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x4E
	CLR  R22
	CLR  R23
_0x2020115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020084
	RCALL SUBOPT_0x4B
	RCALL __ANEGD1
	RCALL SUBOPT_0x49
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020086
_0x2020085:
	ANDI R16,LOW(251)
_0x2020086:
_0x2020083:
	MOV  R19,R20
_0x202006F:
	SBRC R16,0
	RJMP _0x2020087
_0x2020088:
	CP   R17,R21
	BRSH _0x202008B
	CP   R19,R21
	BRLO _0x202008C
_0x202008B:
	RJMP _0x202008A
_0x202008C:
	SBRS R16,7
	RJMP _0x202008D
	SBRS R16,2
	RJMP _0x202008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008F
_0x202008E:
	LDI  R18,LOW(48)
_0x202008F:
	RJMP _0x2020090
_0x202008D:
	LDI  R18,LOW(32)
_0x2020090:
	RCALL SUBOPT_0x43
	SUBI R21,LOW(1)
	RJMP _0x2020088
_0x202008A:
_0x2020087:
_0x2020091:
	CP   R17,R20
	BRSH _0x2020093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020094
	RCALL SUBOPT_0x50
	BREQ _0x2020095
	SUBI R21,LOW(1)
_0x2020095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL SUBOPT_0x46
	CPI  R21,0
	BREQ _0x2020096
	SUBI R21,LOW(1)
_0x2020096:
	SUBI R20,LOW(1)
	RJMP _0x2020091
_0x2020093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020097
_0x2020098:
	CPI  R19,0
	BREQ _0x202009A
	SBRS R16,3
	RJMP _0x202009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	RCALL SUBOPT_0x4C
	RJMP _0x202009C
_0x202009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009C:
	RCALL SUBOPT_0x43
	CPI  R21,0
	BREQ _0x202009D
	SUBI R21,LOW(1)
_0x202009D:
	SUBI R19,LOW(1)
	RJMP _0x2020098
_0x202009A:
	RJMP _0x202009E
_0x2020097:
_0x20200A0:
	RCALL SUBOPT_0x51
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A2
	SBRS R16,3
	RJMP _0x20200A3
	SUBI R18,-LOW(55)
	RJMP _0x20200A4
_0x20200A3:
	SUBI R18,-LOW(87)
_0x20200A4:
	RJMP _0x20200A5
_0x20200A2:
	SUBI R18,-LOW(48)
_0x20200A5:
	SBRC R16,4
	RJMP _0x20200A7
	CPI  R18,49
	BRSH _0x20200A9
	RCALL SUBOPT_0x52
	__CPD2N 0x1
	BRNE _0x20200A8
_0x20200A9:
	RJMP _0x20200AB
_0x20200A8:
	CP   R20,R19
	BRSH _0x2020116
	CP   R21,R19
	BRLO _0x20200AE
	SBRS R16,0
	RJMP _0x20200AF
_0x20200AE:
	RJMP _0x20200AD
_0x20200AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200B0
_0x2020116:
	LDI  R18,LOW(48)
_0x20200AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200B1
	RCALL SUBOPT_0x50
	BREQ _0x20200B2
	SUBI R21,LOW(1)
_0x20200B2:
_0x20200B1:
_0x20200B0:
_0x20200A7:
	RCALL SUBOPT_0x43
	CPI  R21,0
	BREQ _0x20200B3
	SUBI R21,LOW(1)
_0x20200B3:
_0x20200AD:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x51
	RCALL __MODD21U
	RCALL SUBOPT_0x49
	LDD  R30,Y+20
	RCALL SUBOPT_0x52
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x4F
	__GETD1S 16
	RCALL __CPD10
	BREQ _0x20200A1
	RJMP _0x20200A0
_0x20200A1:
_0x202009E:
	SBRS R16,0
	RJMP _0x20200B4
_0x20200B5:
	CPI  R21,0
	BREQ _0x20200B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x46
	RJMP _0x20200B5
_0x20200B7:
_0x20200B4:
_0x20200B8:
_0x2020054:
_0x2020114:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	RCALL SUBOPT_0x42
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
	RCALL SUBOPT_0x53
	SBIW R30,0
	BRNE _0x20200B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x20200B9:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x53
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x54
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	RCALL SUBOPT_0x54
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	RCALL SUBOPT_0x42
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0004:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0x2B
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
	RCALL SUBOPT_0x2B
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
	RCALL SUBOPT_0x2B
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
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x55
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x55
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x30
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
	RCALL SUBOPT_0x56
	__POINTW2FN _0x20A0000,0
	RCALL _strcpyf
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0x56
	__POINTW2FN _0x20A0000,1
	RCALL _strcpyf
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	RCALL SUBOPT_0x57
	RCALL __ANEGF1
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x59
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
	RCALL SUBOPT_0x32
	BREQ _0x20A0013
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x5B
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x5C
	RCALL __ADDF12
	RCALL SUBOPT_0x58
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x5B
_0x20A0014:
	RCALL SUBOPT_0x5C
	RCALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x5B
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0x56
	__POINTW2FN _0x20A0000,5
	RCALL _strcpyf
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0x59
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	RCALL SUBOPT_0x32
	BREQ _0x20A001C
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3A
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x5C
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x3F
	RCALL __MULF12
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x58
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x59
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x58
	RCALL SUBOPT_0x57
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x58
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_U_channel_1:
	.BYTE 0xA
_I_channel_1:
	.BYTE 0xA
_U_channel_2:
	.BYTE 0xA
_I_channel_2:
	.BYTE 0xA
_sample_U1:
	.BYTE 0x4
_sample_U2:
	.BYTE 0x4
_sample_I1:
	.BYTE 0x4
_sample_I2:
	.BYTE 0x4
_averaging_U1:
	.BYTE 0x4
_averaging_U2:
	.BYTE 0x4
_averaging_I1:
	.BYTE 0x4
_averaging_I2:
	.BYTE 0x4
_adc_U1:
	.BYTE 0x4
_adc_U2:
	.BYTE 0x4
_adc_I1:
	.BYTE 0x4
_adc_I2:
	.BYTE 0x4
_U1:
	.BYTE 0x4
_U2:
	.BYTE 0x4
_I1:
	.BYTE 0x4
_I2:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	IN   R30,0x4
	IN   R31,0x4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDS  R26,_sample_U1
	LDS  R27,_sample_U1+1
	LDS  R24,_sample_U1+2
	LDS  R25,_sample_U1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	STS  _sample_U1,R30
	STS  _sample_U1+1,R31
	STS  _sample_U1+2,R22
	STS  _sample_U1+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R26,_sample_I1
	LDS  R27,_sample_I1+1
	LDS  R24,_sample_I1+2
	LDS  R25,_sample_I1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	STS  _sample_I1,R30
	STS  _sample_I1+1,R31
	STS  _sample_I1+2,R22
	STS  _sample_I1+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDS  R26,_sample_U2
	LDS  R27,_sample_U2+1
	LDS  R24,_sample_U2+2
	LDS  R25,_sample_U2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	STS  _sample_U2,R30
	STS  _sample_U2+1,R31
	STS  _sample_U2+2,R22
	STS  _sample_U2+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDS  R26,_sample_I2
	LDS  R27,_sample_I2+1
	LDS  R24,_sample_I2+2
	LDS  R25,_sample_I2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	STS  _sample_I2,R30
	STS  _sample_I2+1,R31
	STS  _sample_I2+2,R22
	STS  _sample_I2+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	__GETD1N 0x40800000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDS  R26,_averaging_U1
	LDS  R27,_averaging_U1+1
	LDS  R24,_averaging_U1+2
	LDS  R25,_averaging_U1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDS  R26,_averaging_I1
	LDS  R27,_averaging_I1+1
	LDS  R24,_averaging_I1+2
	LDS  R25,_averaging_I1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDS  R26,_averaging_U2
	LDS  R27,_averaging_U2+1
	LDS  R24,_averaging_U2+2
	LDS  R25,_averaging_U2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDS  R26,_averaging_I2
	LDS  R27,_averaging_I2+1
	LDS  R24,_averaging_I2+2
	LDS  R25,_averaging_I2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xF:
	__GETD1N 0x42800000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x10:
	LDS  R26,_I1
	LDS  R27,_I1+1
	LDS  R24,_I1+2
	LDS  R25,_I1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11:
	__GETD1N 0x3A23D70A
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3C75C28F
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	STS  _I1,R30
	STS  _I1+1,R31
	STS  _I1+2,R22
	STS  _I1+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	LDS  R26,_adc_U1
	LDS  R27,_adc_U1+1
	LDS  R24,_adc_U1+2
	LDS  R25,_adc_U1+3
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x15:
	__GETD2N 0x40E00000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	__GETD1N 0x3DE56042
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	LDS  R26,_I2
	LDS  R27,_I2+1
	LDS  R24,_I2+2
	LDS  R25,_I2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	STS  _I2,R30
	STS  _I2+1,R31
	STS  _I2+2,R22
	STS  _I2+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDS  R26,_adc_U2
	LDS  R27,_adc_U2+1
	LDS  R24,_adc_U2+2
	LDS  R25,_adc_U2+3
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	__GETD1N 0x411FD70A
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(_U_channel_1)
	LDI  R31,HIGH(_U_channel_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	__GETD1N 0x3F7FBE77
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(_I_channel_1)
	LDI  R31,HIGH(_I_channel_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__POINTW1FN _0x0,16
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDS  R30,_I1
	LDS  R31,_I1+1
	LDS  R22,_I1+2
	LDS  R23,_I1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	__GETD1N 0x447A0000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(_U_channel_2)
	LDI  R31,HIGH(_U_channel_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(_I_channel_2)
	LDI  R31,HIGH(_I_channel_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	LDS  R30,_I2
	LDS  R31,_I2+1
	LDS  R22,_I2+2
	LDS  R23,_I2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	__DELAY_USB 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x2B
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x33:
	__GETD2S 4
	__GETD1N 0x41200000
	RCALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x35:
	__GETD1S 4
	__GETD2S 12
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x36:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x38:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3E:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3F:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x40:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x43:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x44:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x45:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x46:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x48:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x49:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	RCALL SUBOPT_0x44
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x48
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4F:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x50:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x54:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x58:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x59:
	RCALL SUBOPT_0x42
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5A:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5D:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
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

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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
