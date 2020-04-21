
;CodeVisionAVR C Compiler V3.39a 
;(C) Copyright 1998-2020 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 1
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF _numpasos=R3
	.DEF _numpasos_msb=R4
	.DEF _prev=R5
	.DEF _prev_msb=R6
	.DEF _curre=R7
	.DEF _curre_msb=R8
	.DEF _entry=R9
	.DEF _entry_msb=R10
	.DEF _i=R11
	.DEF _i_msb=R12
	.DEF _validation=R13
	.DEF _validation_msb=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

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
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
;/*
; * ProjectCAD.c
; *
; * Created: 10/03/2020 06:09:42 p. m.
; * Author: ALVARO AND DIEGO
; *
; * VERSION 3.1
; * version 3.1 contains the binary counter (LED) for the number of access.
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;
;
;
;unsigned int numpasos = 0;
;unsigned int prev     = 0;
;unsigned int curre    = 0;
;unsigned int entry    = 0;
;unsigned int i = 0;
;unsigned int validation = 0;
;
;unsigned int pasosLED = 0;
;
;
;//ENTRADAS
;//PIND.2 PushButton Señal de paso
;//PIND.4 DipSwitch Sentido paso derecho
;//PIND.5 Dipswitch Entrada pulso continuo
;//PIND.6 Dipswitch Bloqueo Sentido Salida
;//PIND.7 Dipswitch Autorización Multipulsos
;//PINC.2 Microswitch Posición Reposo
;//PINC.3 Microswitch Giro Derecho
;//PINC.4 Microswitch Giro Izquierdo
;
;//SALIDAS
;//PINC.5 Bloqueo electroimán (Salida para solenoide)
;
;// CONTADOR LED
;//PINC.0 - LSB
;//PINC.1
;//PIND.3 - MSB
;
;void contadorLED (unsigned int cont){
; 0000 002C void contadorLED (unsigned int cont){

	.CSEG
_contadorLED:
; .FSTART _contadorLED
; 0000 002D     switch(cont){
	ST   -Y,R27
	ST   -Y,R26
;	cont -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 002E         case 0:
	SBIW R30,0
	BREQ _0x12D
; 0000 002F              PORTD.3 = 0; PORTC.1 = 0; PORTC.0 = 0;
; 0000 0030         break;
; 0000 0031         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD
; 0000 0032              PORTD.3 = 0; PORTC.1 = 0; PORTC.0 = 1;
	CBI  0xB,3
	CBI  0x8,1
	SBI  0x8,0
; 0000 0033         break;
	RJMP _0x5
; 0000 0034         case 2:
_0xD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x14
; 0000 0035              PORTD.3 = 0; PORTC.1 = 1; PORTC.0 = 0;
	CBI  0xB,3
	SBI  0x8,1
	RJMP _0x12E
; 0000 0036         break;
; 0000 0037         case 3:
_0x14:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1B
; 0000 0038              PORTD.3 = 0; PORTC.1 = 1; PORTC.0 = 1;
	CBI  0xB,3
	SBI  0x8,1
	SBI  0x8,0
; 0000 0039         break;
	RJMP _0x5
; 0000 003A         case 4:
_0x1B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22
; 0000 003B              PORTD.3 = 1; PORTC.1 = 0; PORTC.0 = 0;
	SBI  0xB,3
	RJMP _0x12F
; 0000 003C         break;
; 0000 003D         case 5:
_0x22:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x30
; 0000 003E              PORTD.3 = 1; PORTC.1 = 0; PORTC.0 = 1;
	SBI  0xB,3
	CBI  0x8,1
	SBI  0x8,0
; 0000 003F         break;
	RJMP _0x5
; 0000 0040         default:
_0x30:
; 0000 0041              PORTD.3 = 0; PORTC.1 = 0; PORTC.0 = 0;
_0x12D:
	CBI  0xB,3
_0x12F:
	CBI  0x8,1
_0x12E:
	CBI  0x8,0
; 0000 0042         break;
; 0000 0043     }
_0x5:
; 0000 0044 }
	ADIW R28,2
	RET
; .FEND
;
;void main(void)
; 0000 0047 {
_main:
; .FSTART _main
; 0000 0048 
; 0000 0049 
; 0000 004A DDRD  = 0x08; //DipSwitch entrada y push
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 004B PORTD = 0xF4; //Pull up para dipswitches y pushbutton
	LDI  R30,LOW(244)
	OUT  0xB,R30
; 0000 004C DDRC  = 0x23; //Salida solenoide y microswitches entrada
	LDI  R30,LOW(35)
	OUT  0x7,R30
; 0000 004D PORTC = 0x1C; //Pull up en microswitches
	LDI  R30,LOW(28)
	OUT  0x8,R30
; 0000 004E 
; 0000 004F TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
	RCALL SUBOPT_0x0
; 0000 0050 TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0051 
; 0000 0052 
; 0000 0053 while (1)
_0x37:
; 0000 0054     {
; 0000 0055        while (PIND.4 == 0){  // PASO SENTIDO DERECHO
_0x3A:
	SBIC 0x9,4
	RJMP _0x3C
; 0000 0056         if (PINC.2 != 0){//Microswitch reposo //salio de reposo
	SBIS 0x6,2
	RJMP _0x3D
; 0000 0057                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0x3E
; 0000 0058                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 0059                               delay_ms (200);
; 0000 005A                               PORTC.5 = 0; //Desactiva martillo
; 0000 005B                         }
; 0000 005C                         else{
	RJMP _0x43
_0x3E:
; 0000 005D                                while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x44:
	SBIC 0x6,3
	RJMP _0x46
; 0000 005E                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 005F                                     delay_ms (200);
; 0000 0060                                     PORTC.5 = 0; //Desactiva martillo
; 0000 0061                                }
	RJMP _0x44
_0x46:
; 0000 0062 
; 0000 0063                         }
_0x43:
; 0000 0064                     }
; 0000 0065                while(PIND.5 == 1 && PIND.4 == 0){//Pulso continuo no activo y Paso sentido derecho
_0x3D:
_0x4B:
	SBIS 0x9,5
	RJMP _0x4E
	SBIS 0x9,4
	RJMP _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
; 0000 0066                     if (PINC.2 != 0){//Microswitch reposo salio de reposo
	SBIS 0x6,2
	RJMP _0x50
; 0000 0067                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0x51
; 0000 0068                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 0069                               delay_ms (200);
; 0000 006A                               PORTC.5 = 0; //Desactiva martillo
; 0000 006B                         }
; 0000 006C                         else{
	RJMP _0x56
_0x51:
; 0000 006D                                while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x57:
	SBIC 0x6,3
	RJMP _0x59
; 0000 006E                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 006F                                     delay_ms (200);
; 0000 0070                                     PORTC.5 = 0; //Desactiva martillo
; 0000 0071                                }
	RJMP _0x57
_0x59:
; 0000 0072 
; 0000 0073                         }
_0x56:
; 0000 0074                     }
; 0000 0075                      if (PIND.7 == 0){//MODO MULTIPULSO
_0x50:
	SBIC 0x9,7
	RJMP _0x5E
; 0000 0076 
; 0000 0077                         if(PIND.2 == 1)
	SBIC 0x9,2
; 0000 0078                            validation = 1;
	RCALL SUBOPT_0x2
; 0000 0079                         if(PIND.2 == 0 && validation == 1){ // Señal de paso
	SBIC 0x9,2
	RJMP _0x61
	RCALL SUBOPT_0x3
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 007A                            validation = 0;
	RCALL SUBOPT_0x4
; 0000 007B                            numpasos++;
; 0000 007C                            contadorLED(numpasos);
; 0000 007D 
; 0000 007E 
; 0000 007F 
; 0000 0080                           //DEFINICION DE RELOJ a 5s
; 0000 0081                            TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
	LDI  R30,LOW(5)
	STS  129,R30
; 0000 0082 
; 0000 0083                            while(TIFR1.TOV1==0){ //Mientras la bandera de overflow no sea 1
_0x63:
	SBIC 0x16,0
	RJMP _0x65
; 0000 0084 
; 0000 0085 
; 0000 0086                              if(numpasos == 5)
	RCALL SUBOPT_0x5
	BREQ _0x65
; 0000 0087                                 break;
; 0000 0088 
; 0000 0089                              if(PINC.2 == 1 && PINC.3 == 0){
	SBIS 0x6,2
	RJMP _0x68
	SBIS 0x6,3
	RJMP _0x69
_0x68:
	RJMP _0x67
_0x69:
; 0000 008A                                 prev = 1;
	RCALL SUBOPT_0x6
; 0000 008B                                 break;
	RJMP _0x65
; 0000 008C                              }
; 0000 008D 
; 0000 008E                              if(PIND.2 == 1) // Señal de paso
_0x67:
	SBIC 0x9,2
; 0000 008F                                 validation = 1;
	RCALL SUBOPT_0x2
; 0000 0090                              if(PIND.2 == 0 && validation == 1){ // Señal de paso
	SBIC 0x9,2
	RJMP _0x6C
	RCALL SUBOPT_0x3
	BREQ _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
; 0000 0091                                validation = 0;
	RCALL SUBOPT_0x4
; 0000 0092                                numpasos++;
; 0000 0093                                contadorLED(numpasos);
; 0000 0094                                TIFR1.TOV1=1;//Resetea la bandera de overflow
	SBI  0x16,0
; 0000 0095                                TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 s ...
	RCALL SUBOPT_0x0
; 0000 0096                                TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0097                              }
; 0000 0098                            }
_0x6B:
	RJMP _0x63
_0x65:
; 0000 0099                            TCCR1B=0;       //Apagar timer 1
	RCALL SUBOPT_0x7
; 0000 009A 
; 0000 009B                            pasosLED = numpasos;
; 0000 009C 
; 0000 009D                            for (i=0;i<numpasos;i++){
_0x71:
	__CPWRR 11,12,3,4
	BRSH _0x72
; 0000 009E                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x8
; 0000 009F                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 00A0                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
; 0000 00A1                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 00A2                                 //TIENE 10 s para pasar
; 0000 00A3                                 while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
_0x75:
	SBIC 0x16,0
	RJMP _0x77
; 0000 00A4                                     if(PINC.2 == 1 && PINC.4 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0x79
	SBIC 0x6,4
	RJMP _0x79
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BREQ _0x7A
_0x79:
	RJMP _0x78
_0x7A:
; 0000 00A5                                        while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0x7B:
	SBIC 0x6,4
	RJMP _0x7D
; 0000 00A6                                             PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 00A7                                             delay_ms (200);
; 0000 00A8                                             PORTC.5 = 0; //Desactiva martillo
; 0000 00A9                                        }
	RJMP _0x7B
_0x7D:
; 0000 00AA                                     }
; 0000 00AB 
; 0000 00AC                                     if(PINC.3 == 0)
_0x78:
	SBIS 0x6,3
; 0000 00AD                                         prev  = 1;
	RCALL SUBOPT_0x6
; 0000 00AE 
; 0000 00AF                                     if(PINC.4 == 0)
	SBIS 0x6,4
; 0000 00B0                                         curre = 1;
	RCALL SUBOPT_0x9
; 0000 00B1 
; 0000 00B2                                     if(prev == 1 && curre == 1 && PINC.2 == 0){
	RCALL SUBOPT_0xA
	BRNE _0x85
	RCALL SUBOPT_0xB
	BRNE _0x85
	SBIS 0x6,2
	RJMP _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 00B3                                        entry=1;
	RCALL SUBOPT_0xC
; 0000 00B4                                        prev = 0;
; 0000 00B5                                        curre = 0;
; 0000 00B6                                        pasosLED--;
	LDI  R26,LOW(_pasosLED)
	LDI  R27,HIGH(_pasosLED)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00B7                                        contadorLED(pasosLED);
	LDS  R26,_pasosLED
	LDS  R27,_pasosLED+1
	RCALL _contadorLED
; 0000 00B8                                        break;
	RJMP _0x77
; 0000 00B9                                     }
; 0000 00BA                                 }
_0x84:
	RJMP _0x75
_0x77:
; 0000 00BB 
; 0000 00BC                                 if(entry == 0){ //Checa la bandera de si el usuario pasó
	MOV  R0,R9
	OR   R0,R10
	BREQ _0x72
; 0000 00BD                                     break;
; 0000 00BE                                 }
; 0000 00BF                            }
	RCALL SUBOPT_0xD
	RJMP _0x71
_0x72:
; 0000 00C0                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xE
; 0000 00C1                            numpasos=0;
; 0000 00C2                            pasosLED = 0;
	RCALL SUBOPT_0xF
; 0000 00C3                            contadorLED(numpasos);
; 0000 00C4                          }
; 0000 00C5                        }
_0x60:
; 0000 00C6                     else{
	RJMP _0x88
_0x5E:
; 0000 00C7                          if(PIND.2 == 1)
	SBIC 0x9,2
; 0000 00C8                            validation = 1;
	RCALL SUBOPT_0x2
; 0000 00C9                          if(PIND.2 == 0 && validation == 1){ // Señal de paso
	SBIC 0x9,2
	RJMP _0x8B
	RCALL SUBOPT_0x3
	BREQ _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
; 0000 00CA                            validation = 0;
	RCALL SUBOPT_0x10
; 0000 00CB                            numpasos = 1;
; 0000 00CC                            contadorLED(numpasos);
; 0000 00CD 
; 0000 00CE 
; 0000 00CF                              TIFR1.TOV1=1;//Resetea la bandera de overflow
; 0000 00D0                              TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 00D1                              TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 seg ...
; 0000 00D2                              TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 00D3                             //TIENE 10 s para pasar
; 0000 00D4                              while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
_0x8F:
	SBIC 0x16,0
	RJMP _0x91
; 0000 00D5                                 if(PINC.2 == 1 && PINC.4 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0x93
	SBIC 0x6,4
	RJMP _0x93
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BREQ _0x94
_0x93:
	RJMP _0x92
_0x94:
; 0000 00D6                                    while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0x95:
	SBIC 0x6,4
	RJMP _0x97
; 0000 00D7                                         PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 00D8                                         delay_ms (200);
; 0000 00D9                                         PORTC.5 = 0; //Desactiva martillo
; 0000 00DA                                    }
	RJMP _0x95
_0x97:
; 0000 00DB                                 }
; 0000 00DC 
; 0000 00DD                                 if(PINC.3 == 0)
_0x92:
	SBIS 0x6,3
; 0000 00DE                                     prev  = 1;
	RCALL SUBOPT_0x6
; 0000 00DF 
; 0000 00E0                                 if(PINC.4 == 0)
	SBIS 0x6,4
; 0000 00E1                                     curre = 1;
	RCALL SUBOPT_0x9
; 0000 00E2 
; 0000 00E3 
; 0000 00E4                                 if(prev == 1 && curre == 1 && PINC.2 == 0){
	RCALL SUBOPT_0xA
	BRNE _0x9F
	RCALL SUBOPT_0xB
	BRNE _0x9F
	SBIS 0x6,2
	RJMP _0xA0
_0x9F:
	RJMP _0x9E
_0xA0:
; 0000 00E5                                     entry=1;
	RCALL SUBOPT_0xC
; 0000 00E6                                     prev = 0;
; 0000 00E7                                     curre = 0;
; 0000 00E8                                     break;
	RJMP _0x91
; 0000 00E9                                 }
; 0000 00EA                             }
_0x9E:
	RJMP _0x8F
_0x91:
; 0000 00EB                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xE
; 0000 00EC                            numpasos=0;
; 0000 00ED                            contadorLED(numpasos);
	__GETW2R 3,4
	RCALL _contadorLED
; 0000 00EE                         }
; 0000 00EF                     }
_0x8A:
_0x88:
; 0000 00F0 
; 0000 00F1                }
	RJMP _0x4B
_0x4D:
; 0000 00F2               while (PIND.2 == 0){ //Mientras señal de pulso activada
_0xA1:
	SBIC 0x9,2
	RJMP _0xA3
; 0000 00F3 
; 0000 00F4                    if(PINC.2 == 1 && PINC.4 == 0 && prev == 0 && PIND.6 == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0xA5
	SBIC 0x6,4
	RJMP _0xA5
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BRNE _0xA5
	SBIS 0x9,6
	RJMP _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
; 0000 00F5                             while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0xA7:
	SBIC 0x6,4
	RJMP _0xA9
; 0000 00F6                                 PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 00F7                                 delay_ms (200);
; 0000 00F8                                 PORTC.5 = 0; //Desactiva martillo
; 0000 00F9                             }
	RJMP _0xA7
_0xA9:
; 0000 00FA                    }
; 0000 00FB 
; 0000 00FC                    if(PINC.3 == 0)
_0xA4:
	SBIS 0x6,3
; 0000 00FD                       prev  = 1;
	RCALL SUBOPT_0x6
; 0000 00FE 
; 0000 00FF                    if(PINC.4 == 0)
	SBIS 0x6,4
; 0000 0100                       curre = 1;
	RCALL SUBOPT_0x9
; 0000 0101 
; 0000 0102 
; 0000 0103                    if(prev == 1 && curre == 1 && PINC.2 == 0){
	RCALL SUBOPT_0xA
	BRNE _0xB1
	RCALL SUBOPT_0xB
	BRNE _0xB1
	SBIS 0x6,2
	RJMP _0xB2
_0xB1:
	RJMP _0xB0
_0xB2:
; 0000 0104                       prev = 0;
	RCALL SUBOPT_0x11
; 0000 0105                       curre = 0;
; 0000 0106                   }
; 0000 0107               }
_0xB0:
	RJMP _0xA1
_0xA3:
; 0000 0108 
; 0000 0109         }
	RJMP _0x3A
_0x3C:
; 0000 010A 
; 0000 010B        while (PIND.4 == 1){ //PASO SENTIDO IZQUIERDO
_0xB3:
	SBIS 0x9,4
	RJMP _0xB5
; 0000 010C          if (PINC.2 != 0){//Microswitch reposo //salio de reposo
	SBIS 0x6,2
	RJMP _0xB6
; 0000 010D                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0xB7
; 0000 010E                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 010F                               delay_ms (200);
; 0000 0110                               PORTC.5 = 0; //Desactiva martillo
; 0000 0111                         }
; 0000 0112                         else{
	RJMP _0xBC
_0xB7:
; 0000 0113                                while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0xBD:
	SBIC 0x6,4
	RJMP _0xBF
; 0000 0114                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 0115                                     delay_ms (200);
; 0000 0116                                     PORTC.5 = 0; //Desactiva martillo
; 0000 0117                                }
	RJMP _0xBD
_0xBF:
; 0000 0118 
; 0000 0119                         }
_0xBC:
; 0000 011A                     }
; 0000 011B                while(PIND.5 == 1 && PIND.4 == 1){//Pulso continuo no activo y Paso sentido izquierdo
_0xB6:
_0xC4:
	SBIS 0x9,5
	RJMP _0xC7
	SBIC 0x9,4
	RJMP _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
; 0000 011C                     if (PINC.2 != 0){//Microswitch reposo salio de reposo
	SBIS 0x6,2
	RJMP _0xC9
; 0000 011D                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0xCA
; 0000 011E                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 011F                               delay_ms (200);
; 0000 0120                               PORTC.5 = 0; //Desactiva martillo
; 0000 0121                         }
; 0000 0122                         else{
	RJMP _0xCF
_0xCA:
; 0000 0123                                while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0xD0:
	SBIC 0x6,4
	RJMP _0xD2
; 0000 0124                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 0125                                     delay_ms (200);
; 0000 0126                                     PORTC.5 = 0; //Desactiva martillo
; 0000 0127                                }
	RJMP _0xD0
_0xD2:
; 0000 0128 
; 0000 0129                         }
_0xCF:
; 0000 012A                     }
; 0000 012B                      if (PIND.7 == 0){//MODO MULTIPULSO
_0xC9:
	SBIC 0x9,7
	RJMP _0xD7
; 0000 012C 
; 0000 012D                         if(PIND.2 == 1)
	SBIC 0x9,2
; 0000 012E                            validation = 1;
	RCALL SUBOPT_0x2
; 0000 012F                         if(PIND.2 == 0 && validation == 1){ // Señal de paso
	SBIC 0x9,2
	RJMP _0xDA
	RCALL SUBOPT_0x3
	BREQ _0xDB
_0xDA:
	RJMP _0xD9
_0xDB:
; 0000 0130                            validation = 0;
	RCALL SUBOPT_0x4
; 0000 0131                            numpasos++;
; 0000 0132                            contadorLED(numpasos);
; 0000 0133 
; 0000 0134 
; 0000 0135                           //DEFINICION DE RELOJ a 5s
; 0000 0136                            TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
	LDI  R30,LOW(5)
	STS  129,R30
; 0000 0137 
; 0000 0138                            while(TIFR1.TOV1==0){ //Mientras la bandera de overflow no sea 1
_0xDC:
	SBIC 0x16,0
	RJMP _0xDE
; 0000 0139                              if(PIND.2 == 1) // Señal de paso
	SBIC 0x9,2
; 0000 013A                                 validation = 1;
	RCALL SUBOPT_0x2
; 0000 013B 
; 0000 013C                              if(numpasos == 5)
	RCALL SUBOPT_0x5
	BREQ _0xDE
; 0000 013D                                 break;
; 0000 013E 
; 0000 013F                              if(PINC.2 == 1 && PINC.4 == 0){
	SBIS 0x6,2
	RJMP _0xE2
	SBIS 0x6,4
	RJMP _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
; 0000 0140                                 prev = 1;
	RCALL SUBOPT_0x6
; 0000 0141                                 break;
	RJMP _0xDE
; 0000 0142                              }
; 0000 0143 
; 0000 0144                              if(PIND.2 == 0 && validation == 1){ // Señal de paso
_0xE1:
	SBIC 0x9,2
	RJMP _0xE5
	RCALL SUBOPT_0x3
	BREQ _0xE6
_0xE5:
	RJMP _0xE4
_0xE6:
; 0000 0145                                validation = 0;
	RCALL SUBOPT_0x4
; 0000 0146                                numpasos++;
; 0000 0147                                contadorLED(numpasos);
; 0000 0148                                TIFR1.TOV1=1;//Resetea la bandera de overflow
	SBI  0x16,0
; 0000 0149                                TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 s ...
	RCALL SUBOPT_0x0
; 0000 014A                                TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 014B                              }
; 0000 014C                            }
_0xE4:
	RJMP _0xDC
_0xDE:
; 0000 014D                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0x7
; 0000 014E 
; 0000 014F                            pasosLED = numpasos;
; 0000 0150 
; 0000 0151                            for (i=0;i<numpasos;i++){
_0xEA:
	__CPWRR 11,12,3,4
	BRSH _0xEB
; 0000 0152                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x8
; 0000 0153                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 0154                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
; 0000 0155                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0156                                 //TIENE 10 s para pasar
; 0000 0157                                 while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
_0xEE:
	SBIC 0x16,0
	RJMP _0xF0
; 0000 0158                                     if(PINC.2 == 1 && PINC.3 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0xF2
	SBIC 0x6,3
	RJMP _0xF2
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BREQ _0xF3
_0xF2:
	RJMP _0xF1
_0xF3:
; 0000 0159                                        while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0xF4:
	SBIC 0x6,3
	RJMP _0xF6
; 0000 015A                                             PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 015B                                             delay_ms (200);
; 0000 015C                                             PORTC.5 = 0; //Desactiva martillo
; 0000 015D                                        }
	RJMP _0xF4
_0xF6:
; 0000 015E                                     }
; 0000 015F 
; 0000 0160                                     if(PINC.4 == 0)
_0xF1:
	SBIS 0x6,4
; 0000 0161                                         prev  = 1;
	RCALL SUBOPT_0x6
; 0000 0162 
; 0000 0163                                     if(PINC.3 == 0)
	SBIS 0x6,3
; 0000 0164                                         curre = 1;
	RCALL SUBOPT_0x9
; 0000 0165 
; 0000 0166                                     if(prev == 1 && curre == 1 && PINC.2 == 0){
	RCALL SUBOPT_0xA
	BRNE _0xFE
	RCALL SUBOPT_0xB
	BRNE _0xFE
	SBIS 0x6,2
	RJMP _0xFF
_0xFE:
	RJMP _0xFD
_0xFF:
; 0000 0167                                        entry=1;
	RCALL SUBOPT_0xC
; 0000 0168                                        prev = 0;
; 0000 0169                                        curre = 0;
; 0000 016A                                        pasosLED = numpasos;
	__PUTWMRN _pasosLED,0,3,4
; 0000 016B                                        break;
	RJMP _0xF0
; 0000 016C                                     }
; 0000 016D                                 }
_0xFD:
	RJMP _0xEE
_0xF0:
; 0000 016E 
; 0000 016F                                 if(entry == 0){ //Checa la bandera de si el usuario pasó
	MOV  R0,R9
	OR   R0,R10
	BREQ _0xEB
; 0000 0170                                     break;
; 0000 0171                                 }
; 0000 0172                            }
	RCALL SUBOPT_0xD
	RJMP _0xEA
_0xEB:
; 0000 0173                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xE
; 0000 0174                            numpasos=0;
; 0000 0175                            pasosLED = 0;
	RCALL SUBOPT_0xF
; 0000 0176                            contadorLED(numpasos);
; 0000 0177                          }
; 0000 0178                        }
_0xD9:
; 0000 0179                     else{
	RJMP _0x101
_0xD7:
; 0000 017A                          if(PIND.2 == 1)
	SBIC 0x9,2
; 0000 017B                            validation = 1;
	RCALL SUBOPT_0x2
; 0000 017C                          if(PIND.2 == 0 && validation == 1){ // Señal de paso
	SBIC 0x9,2
	RJMP _0x104
	RCALL SUBOPT_0x3
	BREQ _0x105
_0x104:
	RJMP _0x103
_0x105:
; 0000 017D                            validation = 0;
	RCALL SUBOPT_0x10
; 0000 017E                            numpasos = 1;
; 0000 017F                            contadorLED(numpasos);
; 0000 0180 
; 0000 0181                              TIFR1.TOV1=1;//Resetea la bandera de overflow
; 0000 0182                              TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 0183                              TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 seg ...
; 0000 0184                              TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0185                             //TIENE 10 s para pasar
; 0000 0186                              while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
_0x108:
	SBIC 0x16,0
	RJMP _0x10A
; 0000 0187                                 if(PINC.2 == 1 && PINC.3 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0x10C
	SBIC 0x6,3
	RJMP _0x10C
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BREQ _0x10D
_0x10C:
	RJMP _0x10B
_0x10D:
; 0000 0188                                    while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x10E:
	SBIC 0x6,3
	RJMP _0x110
; 0000 0189                                         PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 018A                                         delay_ms (200);
; 0000 018B                                         PORTC.5 = 0; //Desactiva martillo
; 0000 018C                                    }
	RJMP _0x10E
_0x110:
; 0000 018D                                 }
; 0000 018E 
; 0000 018F                                 if(PINC.4 == 0)
_0x10B:
	SBIS 0x6,4
; 0000 0190                                     prev  = 1;
	RCALL SUBOPT_0x6
; 0000 0191 
; 0000 0192                                 if(PINC.3 == 0)
	SBIS 0x6,3
; 0000 0193                                     curre = 1;
	RCALL SUBOPT_0x9
; 0000 0194 
; 0000 0195 
; 0000 0196                                 if(prev == 1 && curre == 1 && PINC.2 == 0){
	RCALL SUBOPT_0xA
	BRNE _0x118
	RCALL SUBOPT_0xB
	BRNE _0x118
	SBIS 0x6,2
	RJMP _0x119
_0x118:
	RJMP _0x117
_0x119:
; 0000 0197                                    entry=1;
	RCALL SUBOPT_0xC
; 0000 0198                                    prev = 0;
; 0000 0199                                    curre = 0;
; 0000 019A                                    break;
	RJMP _0x10A
; 0000 019B                                 }
; 0000 019C                             }
_0x117:
	RJMP _0x108
_0x10A:
; 0000 019D 
; 0000 019E                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xE
; 0000 019F                            numpasos=0;
; 0000 01A0                            contadorLED(numpasos);
	__GETW2R 3,4
	RCALL _contadorLED
; 0000 01A1                         }
; 0000 01A2                     }
_0x103:
_0x101:
; 0000 01A3 
; 0000 01A4                }
	RJMP _0xC4
_0xC6:
; 0000 01A5               while (PIND.2==0){ //Mientras señal de pulso activada
_0x11A:
	SBIC 0x9,2
	RJMP _0x11C
; 0000 01A6                     if(PINC.2 == 1 && PINC.3 == 0 && prev == 0 && PIND.6 == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0x11E
	SBIC 0x6,3
	RJMP _0x11E
	CLR  R0
	CP   R0,R5
	CPC  R0,R6
	BRNE _0x11E
	SBIS 0x9,6
	RJMP _0x11F
_0x11E:
	RJMP _0x11D
_0x11F:
; 0000 01A7                             while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x120:
	SBIC 0x6,3
	RJMP _0x122
; 0000 01A8                                 PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x1
; 0000 01A9                                 delay_ms (200);
; 0000 01AA                                 PORTC.5 = 0; //Desactiva martillo
; 0000 01AB                             }
	RJMP _0x120
_0x122:
; 0000 01AC                    }
; 0000 01AD 
; 0000 01AE                    if(PINC.4 == 0)
_0x11D:
	SBIS 0x6,4
; 0000 01AF                       prev  = 1;
	RCALL SUBOPT_0x6
; 0000 01B0 
; 0000 01B1                    if(PINC.3 == 0)
	SBIS 0x6,3
; 0000 01B2                       curre = 1;
	RCALL SUBOPT_0x9
; 0000 01B3 
; 0000 01B4 
; 0000 01B5                    if(prev == 1 && curre == 1 && PINC.2 == 0){
	RCALL SUBOPT_0xA
	BRNE _0x12A
	RCALL SUBOPT_0xB
	BRNE _0x12A
	SBIS 0x6,2
	RJMP _0x12B
_0x12A:
	RJMP _0x129
_0x12B:
; 0000 01B6                       prev = 0;
	RCALL SUBOPT_0x11
; 0000 01B7                       curre = 0;
; 0000 01B8                   }
; 0000 01B9               }
_0x129:
	RJMP _0x11A
_0x11C:
; 0000 01BA 
; 0000 01BB         }
	RJMP _0xB3
_0xB5:
; 0000 01BC    }
	RJMP _0x37
; 0000 01BD }
_0x12C:
	RJMP _0x12C
; .FEND

	.DSEG
_pasosLED:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(236)
	STS  133,R30
	LDI  R30,LOW(237)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:50 WORDS
SUBOPT_0x1:
	SBI  0x8,5
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
	CBI  0x8,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 13,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R13
	CPC  R31,R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	CLR  R13
	CLR  R14
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	__GETW2R 3,4
	RJMP _contadorLED

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 5,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  129,R30
	__PUTWMRN _pasosLED,0,3,4
	CLR  R11
	CLR  R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	SBI  0x16,0
	LDI  R30,LOW(5)
	STS  129,R30
	LDI  R30,LOW(217)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R5
	CPC  R31,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R7
	CPC  R31,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 9,10
	CLR  R5
	CLR  R6
	CLR  R7
	CLR  R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STS  129,R30
	CLR  R3
	CLR  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _pasosLED,R30
	STS  _pasosLED+1,R30
	__GETW2R 3,4
	RJMP _contadorLED

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	CLR  R13
	CLR  R14
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 3,4
	__GETW2R 3,4
	RCALL _contadorLED
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CLR  R5
	CLR  R6
	CLR  R7
	CLR  R8
	RET

;RUNTIME LIBRARY

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
