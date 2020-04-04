
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
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x0A
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
;
;
;void main(void)
; 0000 0023 {

	.CSEG
_main:
; .FSTART _main
; 0000 0024 
; 0000 0025 DDRD  = 0x0B; //DipSwitch entrada y push
	LDI  R30,LOW(11)
	OUT  0xA,R30
; 0000 0026 PORTD = 0xF4; //Pull up para dipswitches y pushbutton
	LDI  R30,LOW(244)
	OUT  0xB,R30
; 0000 0027 DDRC  = 0x20; //Salida solenoide y microswitches entrada
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0028 PORTC = 0x1C; //Pull up en microswitches
	LDI  R30,LOW(28)
	OUT  0x8,R30
; 0000 0029 
; 0000 002A while (1)
_0x3:
; 0000 002B     {
; 0000 002C        while (PIND.4 == 0){  // PASO SENTIDO DERECHO
_0x6:
	SBIC 0x9,4
	RJMP _0x8
; 0000 002D         if (PINC.2 != 0){//Microswitch reposo //salio de reposo
	SBIS 0x6,2
	RJMP _0x9
; 0000 002E                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0xA
; 0000 002F                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0030                               delay_ms (200);
; 0000 0031                               PORTC.5 = 0; //Desactiva martillo
; 0000 0032                         }
; 0000 0033                         else{
	RJMP _0xF
_0xA:
; 0000 0034                                while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x10:
	SBIC 0x6,3
	RJMP _0x12
; 0000 0035                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0036                                     delay_ms (200);
; 0000 0037                                     PORTC.5 = 0; //Desactiva martillo
; 0000 0038                                }
	RJMP _0x10
_0x12:
; 0000 0039 
; 0000 003A                         }
_0xF:
; 0000 003B                     }
; 0000 003C                while(PIND.5 == 1){//Pulso continuo no activo
_0x9:
_0x17:
	SBIS 0x9,5
	RJMP _0x19
; 0000 003D                     if (PINC.2 != 0){//Microswitch reposo salio de reposo
	SBIS 0x6,2
	RJMP _0x1A
; 0000 003E                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0x1B
; 0000 003F                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0040                               delay_ms (200);
; 0000 0041                               PORTC.5 = 0; //Desactiva martillo
; 0000 0042                         }
; 0000 0043                         else{
	RJMP _0x20
_0x1B:
; 0000 0044                                while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x21:
	SBIC 0x6,3
	RJMP _0x23
; 0000 0045                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0046                                     delay_ms (200);
; 0000 0047                                     PORTC.5 = 0; //Desactiva martillo
; 0000 0048                                }
	RJMP _0x21
_0x23:
; 0000 0049 
; 0000 004A                         }
_0x20:
; 0000 004B                     }
; 0000 004C                      if (PIND.7 == 0){//MODO MULTIPULSO
_0x1A:
	SBIC 0x9,7
	RJMP _0x28
; 0000 004D 
; 0000 004E 
; 0000 004F                          if(PIND.2 == 0){//Señal de paso
	SBIC 0x9,2
	RJMP _0x29
; 0000 0050                            numpasos++;
	RCALL SUBOPT_0x1
; 0000 0051 
; 0000 0052                            //DEFINICION DE RELOJ a 5s
; 0000 0053                            TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
	RCALL SUBOPT_0x2
; 0000 0054                            TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segun ...
; 0000 0055                            TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0056                            do{
_0x2B:
; 0000 0057                              if(PIND.2 == 0){ // Señal de paso
	SBIC 0x9,2
	RJMP _0x2D
; 0000 0058                                if(numpasos > 5){
	RCALL SUBOPT_0x3
	BRLO _0x2C
; 0000 0059                                   break;
; 0000 005A                                }
; 0000 005B                                else{
; 0000 005C                                   numpasos++;
	RCALL SUBOPT_0x1
; 0000 005D                                   TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x4
; 0000 005E                                   TCCR1B = 0x05; //Lo inicia de nuevo
; 0000 005F                                }
; 0000 0060 
; 0000 0061 
; 0000 0062                              }
; 0000 0063                            }while(TIFR0.TOV0==0); //Mientras la bandera de overflow no sea 1
_0x2D:
	SBIS 0x15,0
	RJMP _0x2B
_0x2C:
; 0000 0064                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0x5
; 0000 0065 
; 0000 0066 
; 0000 0067 
; 0000 0068 
; 0000 0069                            for (i=0;i<numpasos;i++){
_0x33:
	__CPWRR 11,12,3,4
	BRSH _0x34
; 0000 006A                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x4
; 0000 006B                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 006C                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
	RCALL SUBOPT_0x6
; 0000 006D                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 006E                                 //TIENE 10 s para pasar
; 0000 006F                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x37:
	SBIC 0x15,0
	RJMP _0x39
; 0000 0070                                     if(PINC.2 == 1 && PINC.4 == 0){ // Para evitar que haga sentido opuesto
	SBIS 0x6,2
	RJMP _0x3B
	SBIS 0x6,4
	RJMP _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 0071                                        while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0x3D:
	SBIC 0x6,4
	RJMP _0x3F
; 0000 0072                                             PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0073                                             delay_ms (200);
; 0000 0074                                             PORTC.5 = 0; //Desactiva martillo
; 0000 0075                                        }
	RJMP _0x3D
_0x3F:
; 0000 0076                                     }
; 0000 0077 
; 0000 0078                                     if(PINC.3 == 0){
_0x3A:
	SBIC 0x6,3
	RJMP _0x44
; 0000 0079                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 007A                                         if(PINC.4 == 0)
	SBIS 0x6,4
; 0000 007B                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 007C                                     }
; 0000 007D 
; 0000 007E                                     if(prev == 1 && curre == 1 && PINC.2 == 0){
_0x44:
	RCALL SUBOPT_0x9
	BRNE _0x47
	RCALL SUBOPT_0xA
	BRNE _0x47
	SBIS 0x6,2
	RJMP _0x48
_0x47:
	RJMP _0x46
_0x48:
; 0000 007F                                        entry=1;
	RCALL SUBOPT_0xB
; 0000 0080                                        break;
	RJMP _0x39
; 0000 0081                                     }
; 0000 0082                                 }
_0x46:
	RJMP _0x37
_0x39:
; 0000 0083                                 if(entry == 0){ //Checa la bandera de si el usuario pasó
	MOV  R0,R9
	OR   R0,R10
	BREQ _0x34
; 0000 0084                                     break;
; 0000 0085                                 }
; 0000 0086                            }
	RCALL SUBOPT_0xC
	RJMP _0x33
_0x34:
; 0000 0087                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xD
; 0000 0088                            numpasos=0;
; 0000 0089                          }
; 0000 008A                        }
_0x29:
; 0000 008B                     else{
	RJMP _0x4A
_0x28:
; 0000 008C                            if(PIND.2==0){ //Señal de paso
	SBIC 0x9,2
	RJMP _0x4B
; 0000 008D                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x4
; 0000 008E                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 008F                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024  ...
	RCALL SUBOPT_0x6
; 0000 0090                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0091                                 //TIENE 10 s para pasar
; 0000 0092 
; 0000 0093                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x4E:
	SBIC 0x15,0
	RJMP _0x50
; 0000 0094                                     if(PINC.2 == 1 && PINC.4 == 0){
	SBIS 0x6,2
	RJMP _0x52
	SBIS 0x6,4
	RJMP _0x53
_0x52:
	RJMP _0x51
_0x53:
; 0000 0095                                        while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0x54:
	SBIC 0x6,4
	RJMP _0x56
; 0000 0096                                             PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0097                                             delay_ms (200);
; 0000 0098                                             PORTC.5 = 0; //Desactiva martillo
; 0000 0099                                        }
	RJMP _0x54
_0x56:
; 0000 009A                                     }
; 0000 009B 
; 0000 009C                                     if(PINC.3 == 0){
_0x51:
	SBIC 0x6,3
	RJMP _0x5B
; 0000 009D                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 009E                                         if(PINC.4 == 0)
	SBIS 0x6,4
; 0000 009F                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 00A0                                     }
; 0000 00A1 
; 0000 00A2                                     if(prev == 1 && curre == 1 && PINC.2 == 0){
_0x5B:
	RCALL SUBOPT_0x9
	BRNE _0x5E
	RCALL SUBOPT_0xA
	BRNE _0x5E
	SBIS 0x6,2
	RJMP _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
; 0000 00A3                                        break;
	RJMP _0x50
; 0000 00A4                                     }
; 0000 00A5                                 }
_0x5D:
	RJMP _0x4E
_0x50:
; 0000 00A6                                 TCCR1B=0;       //Apagar timer
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 00A7                            }
; 0000 00A8                          }
_0x4B:
_0x4A:
; 0000 00A9 
; 0000 00AA                }
	RJMP _0x17
_0x19:
; 0000 00AB               while (PIND.2==0){ //Mientras señal de pulso activada
_0x60:
	SBIC 0x9,2
	RJMP _0x62
; 0000 00AC                     PORTC.5 = 0; //Martillo desactivado
	CBI  0x8,5
; 0000 00AD               }
	RJMP _0x60
_0x62:
; 0000 00AE 
; 0000 00AF         }
	RJMP _0x6
_0x8:
; 0000 00B0 
; 0000 00B1        while (PIND.4 == 1){ //PASO SENTIDO IZQUIERDO
_0x65:
	SBIS 0x9,4
	RJMP _0x67
; 0000 00B2         if (PINC.2 != 0){//Microswitch reposo //salio de reposo
	SBIS 0x6,2
	RJMP _0x68
; 0000 00B3                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0x69
; 0000 00B4                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00B5                               delay_ms (200);
; 0000 00B6                               PORTC.5 = 0; //Desactiva martillo
; 0000 00B7                         }
; 0000 00B8                         else{
	RJMP _0x6E
_0x69:
; 0000 00B9                                while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0x6F:
	SBIC 0x6,4
	RJMP _0x71
; 0000 00BA                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00BB                                     delay_ms (200);
; 0000 00BC                                     PORTC.5 = 0; //Desactiva martillo
; 0000 00BD                                }
	RJMP _0x6F
_0x71:
; 0000 00BE 
; 0000 00BF                         }
_0x6E:
; 0000 00C0                     }
; 0000 00C1                while(PIND.5 ==1){ //Pulso continuo no activado
_0x68:
_0x76:
	SBIS 0x9,5
	RJMP _0x78
; 0000 00C2                       if (PINC.2 != 0){//Microswitch reposo //salio de reposo
	SBIS 0x6,2
	RJMP _0x79
; 0000 00C3                         if(PIND.6 == 0){//Bloqueo de salida activado o también el de entrada
	SBIC 0x9,6
	RJMP _0x7A
; 0000 00C4                               PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00C5                               delay_ms (200);
; 0000 00C6                               PORTC.5 = 0; //Desactiva martillo
; 0000 00C7                         }
; 0000 00C8                         else{
	RJMP _0x7F
_0x7A:
; 0000 00C9                                while(PINC.4 == 0){//Mientras esté intentando entrar activa martillo
_0x80:
	SBIC 0x6,4
	RJMP _0x82
; 0000 00CA                                     PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00CB                                     delay_ms (200);
; 0000 00CC                                     PORTC.5 = 0; //Desactiva martillo
; 0000 00CD                                }
	RJMP _0x80
_0x82:
; 0000 00CE 
; 0000 00CF                         }
_0x7F:
; 0000 00D0                     }
; 0000 00D1 
; 0000 00D2                      if (PIND.7 == 0){ //MODO MULTIPULSO AUTORIZADO
_0x79:
	SBIC 0x9,7
	RJMP _0x87
; 0000 00D3 
; 0000 00D4 
; 0000 00D5                          if(PIND.2 == 0){//Señal de pulso
	SBIC 0x9,2
	RJMP _0x88
; 0000 00D6                            numpasos++;
	RCALL SUBOPT_0x1
; 0000 00D7                            //DEFINICION DE RELOJ a 5s
; 0000 00D8                            TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
	RCALL SUBOPT_0x2
; 0000 00D9                            TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segun ...
; 0000 00DA                            TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 00DB                            do{
_0x8A:
; 0000 00DC                              if(PIND.2 == 0){ // señal de paso
	SBIC 0x9,2
	RJMP _0x8C
; 0000 00DD                                if(numpasos > 5){
	RCALL SUBOPT_0x3
	BRLO _0x8B
; 0000 00DE                                   break;
; 0000 00DF                                }
; 0000 00E0                                else{
; 0000 00E1                                   numpasos++;
	RCALL SUBOPT_0x1
; 0000 00E2                                   TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x4
; 0000 00E3                                   TCCR1B = 0x05; //Lo inicia de nuevo
; 0000 00E4                                }
; 0000 00E5                              }
; 0000 00E6                            }while(TIFR0.TOV0==0); //Mientras la bandera de overflow no sea 1
_0x8C:
	SBIS 0x15,0
	RJMP _0x8A
_0x8B:
; 0000 00E7                             TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0x5
; 0000 00E8 
; 0000 00E9 
; 0000 00EA                            for (i=0;i<numpasos;i++){
_0x92:
	__CPWRR 11,12,3,4
	BRSH _0x93
; 0000 00EB                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x4
; 0000 00EC                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 00ED                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
	RCALL SUBOPT_0x6
; 0000 00EE                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 00EF                                 //TIENE 10 s para pasar
; 0000 00F0 
; 0000 00F1                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x96:
	SBIC 0x15,0
	RJMP _0x98
; 0000 00F2                                     if(PINC.2 == 1 && PINC.3 == 0){
	SBIS 0x6,2
	RJMP _0x9A
	SBIS 0x6,3
	RJMP _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
; 0000 00F3                                        while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0x9C:
	SBIC 0x6,3
	RJMP _0x9E
; 0000 00F4                                             PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0xE
; 0000 00F5                                             delay_ms (5000);
; 0000 00F6                                             PORTC.5 = 0; //Desactiva martillo
; 0000 00F7                                        }
	RJMP _0x9C
_0x9E:
; 0000 00F8                                     }
; 0000 00F9 
; 0000 00FA                                     if(PINC.4 == 0){
_0x99:
	SBIC 0x6,4
	RJMP _0xA3
; 0000 00FB                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 00FC                                         if(PINC.3 == 0)
	SBIS 0x6,3
; 0000 00FD                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 00FE                                     }
; 0000 00FF 
; 0000 0100                                     if(prev == 1 && curre == 1 && PINC.2 == 0){
_0xA3:
	RCALL SUBOPT_0x9
	BRNE _0xA6
	RCALL SUBOPT_0xA
	BRNE _0xA6
	SBIS 0x6,2
	RJMP _0xA7
_0xA6:
	RJMP _0xA5
_0xA7:
; 0000 0101                                        entry=1;
	RCALL SUBOPT_0xB
; 0000 0102                                        break;
	RJMP _0x98
; 0000 0103                                     }
; 0000 0104                                 }
_0xA5:
	RJMP _0x96
_0x98:
; 0000 0105                                 if(entry==0){
	MOV  R0,R9
	OR   R0,R10
	BREQ _0x93
; 0000 0106                                     break;
; 0000 0107                                 }
; 0000 0108                            }
	RCALL SUBOPT_0xC
	RJMP _0x92
_0x93:
; 0000 0109                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xD
; 0000 010A                            numpasos=0;
; 0000 010B                          }
; 0000 010C                        }
_0x88:
; 0000 010D                     else{
	RJMP _0xA9
_0x87:
; 0000 010E                            if(PIND.2 == 1){ //señal de paso
	SBIS 0x9,2
	RJMP _0xAA
; 0000 010F                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x4
; 0000 0110                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 0111                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
	RCALL SUBOPT_0x6
; 0000 0112                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0113                                 //TIENE 10 s para pasar
; 0000 0114 
; 0000 0115                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0xAD:
	SBIC 0x15,0
	RJMP _0xAF
; 0000 0116                                     if(PINC.2 == 1 && PINC.3 == 0){
	SBIS 0x6,2
	RJMP _0xB1
	SBIS 0x6,3
	RJMP _0xB2
_0xB1:
	RJMP _0xB0
_0xB2:
; 0000 0117                                        while(PINC.3 == 0){//Mientras esté intentando entrar activa martillo
_0xB3:
	SBIC 0x6,3
	RJMP _0xB5
; 0000 0118                                             PORTC.5 = 1; //Activa martillo
	RCALL SUBOPT_0xE
; 0000 0119                                             delay_ms (5000);
; 0000 011A                                             PORTC.5 = 0; //Desactiva martillo
; 0000 011B                                        }
	RJMP _0xB3
_0xB5:
; 0000 011C                                     }
; 0000 011D 
; 0000 011E                                     if(PINC.4 == 0){
_0xB0:
	SBIC 0x6,4
	RJMP _0xBA
; 0000 011F                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 0120                                         if(PINC.3 == 0)
	SBIS 0x6,3
; 0000 0121                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 0122                                     }
; 0000 0123 
; 0000 0124                                     if(prev == 1 && curre == 1 && PINC.2 == 0){
_0xBA:
	RCALL SUBOPT_0x9
	BRNE _0xBD
	RCALL SUBOPT_0xA
	BRNE _0xBD
	SBIS 0x6,2
	RJMP _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
; 0000 0125                                        break;
	RJMP _0xAF
; 0000 0126                                     }
; 0000 0127                                 }
_0xBC:
	RJMP _0xAD
_0xAF:
; 0000 0128                            }
; 0000 0129                            TCCR1B=0;       //Apagar timer
_0xAA:
	RCALL SUBOPT_0xD
; 0000 012A                            numpasos=0;
; 0000 012B                          }
_0xA9:
; 0000 012C 
; 0000 012D                }
	RJMP _0x76
_0x78:
; 0000 012E               while (PIND.2 == 0){ //Señal de paso
_0xBF:
	SBIC 0x9,2
	RJMP _0xC1
; 0000 012F                                 PORTC.5=0;
	CBI  0x8,5
; 0000 0130               }
	RJMP _0xBF
_0xC1:
; 0000 0131 
; 0000 0132         }
	RJMP _0x65
_0x67:
; 0000 0133 }
	RJMP _0x3
; 0000 0134 }
_0xC4:
	RJMP _0xC4
; .FEND
;
;
;
;
;

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x0:
	SBI  0x8,5
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
	CBI  0x8,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(5)
	STS  129,R30
	LDI  R30,LOW(236)
	STS  133,R30
	LDI  R30,LOW(237)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	SBI  0x16,0
	LDI  R30,LOW(5)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  129,R30
	CLR  R11
	CLR  R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(217)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 5,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R5
	CPC  R31,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R7
	CPC  R31,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  129,R30
	CLR  R3
	CLR  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	SBI  0x8,5
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _delay_ms
	CBI  0x8,5
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
