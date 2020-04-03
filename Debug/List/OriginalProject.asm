
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
	.DEF _prevS=R5
	.DEF _prevS_msb=R6
	.DEF _prev=R7
	.DEF _prev_msb=R8
	.DEF _curre=R9
	.DEF _curre_msb=R10
	.DEF _entry=R11
	.DEF _entry_msb=R12
	.DEF _i=R13
	.DEF _i_msb=R14

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
;unsigned int numpasos = 0;
;unsigned int prevS    = 0;
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
;//PINC.1 Bloqueo electroimán (Salida para solenoide)
;
;void main(void)
; 0000 0020 {

	.CSEG
_main:
; .FSTART _main
; 0000 0021 
; 0000 0022 DDRD  = 0x0B; //DipSwitch entrada y push
	LDI  R30,LOW(11)
	OUT  0xA,R30
; 0000 0023 PORTD = 0xF4; //Pull up para dipswitches y pushbutton
	LDI  R30,LOW(244)
	OUT  0xB,R30
; 0000 0024 DDRC  = 0x02; //Salida solenoide y microswitches entrada
	LDI  R30,LOW(2)
	OUT  0x7,R30
; 0000 0025 PORTC = 0x1C; //Pull up en microswitches
	LDI  R30,LOW(28)
	OUT  0x8,R30
; 0000 0026 
; 0000 0027 while (1)
_0x3:
; 0000 0028     {
; 0000 0029        while (PIND.4 == 1){  // PASO DERECHO
_0x6:
	SBIS 0x9,4
	RJMP _0x8
; 0000 002A                while(PIND.5 == 0){//Pulso continuo no activo
_0x9:
	SBIC 0x9,5
	RJMP _0xB
; 0000 002B                     if (PINC.2 != 1){//Microswitch reposo
	SBIC 0x6,2
	RJMP _0xC
; 0000 002C                         if(PIND.6 == 1){//Bloqueo de salida activado o también el de entrada
	SBIS 0x9,6
	RJMP _0xD
; 0000 002D                               PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 002E                               delay_ms (5000);
; 0000 002F                               PORTC.1 = 0; //Desactiva martillo
	RJMP _0xB3
; 0000 0030                         }
; 0000 0031                         else{
_0xD:
; 0000 0032                             if (PINC.3 == 1){//Microswitch giro derecho
	SBIS 0x6,3
	RJMP _0x13
; 0000 0033                                 if (prevS == 0){ //Switch previo, detecta que ya pasó  o no por PINC.4
	MOV  R0,R5
	OR   R0,R6
	BRNE _0x14
; 0000 0034                                     while(PINC.3 == 1){//Mientras esté intentando entrar activa martillo
_0x15:
	SBIS 0x6,3
	RJMP _0x17
; 0000 0035                                        PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0036                                        delay_ms (5000);
; 0000 0037                                        PORTC.1 = 0; //Desactiva martillo
	CBI  0x8,1
; 0000 0038                                     }
	RJMP _0x15
_0x17:
; 0000 0039                                 }
; 0000 003A 
; 0000 003B                             }
_0x14:
; 0000 003C                             if(PINC.4 == 1){ //Microswitch giro izquierdo
_0x13:
	SBIC 0x6,4
; 0000 003D                                 prevS  = 1;
	RCALL SUBOPT_0x1
; 0000 003E                         }
; 0000 003F                         PORTC.1 = 0; //Martillo desactivado
_0xB3:
	CBI  0x8,1
; 0000 0040 
; 0000 0041                     }
; 0000 0042 
; 0000 0043                      if (PIND.7 == 1){//MODO MULTIPULSO
	SBIS 0x9,7
	RJMP _0x1F
; 0000 0044 
; 0000 0045 
; 0000 0046                          if(PIND.2 == 1){//Señal de paso
	SBIS 0x9,2
	RJMP _0x20
; 0000 0047                            numpasos++;
	RCALL SUBOPT_0x2
; 0000 0048 
; 0000 0049                            //DEFINICION DE RELOJ a 5s
; 0000 004A                            TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 004B                            TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segun ...
; 0000 004C                            TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 004D                            do{
_0x22:
; 0000 004E                              if(PIND.2 == 1){ // Señal de paso
	SBIS 0x9,2
	RJMP _0x24
; 0000 004F                                if(numpasos > 5){
	RCALL SUBOPT_0x3
	BRLO _0x23
; 0000 0050                                   break;
; 0000 0051                                }
; 0000 0052                                else{
; 0000 0053                                   numpasos++;
	RCALL SUBOPT_0x4
; 0000 0054                                   TIFR1.TOV1=1;//Resetea la bandera de overflow
; 0000 0055                                   TCCR1B = 0x05; //Lo inicia de nuevo
; 0000 0056                                }
; 0000 0057 
; 0000 0058 
; 0000 0059                              }
; 0000 005A                            }while(TIFR0.TOV0==0); //Mientras la bandera de overflow no sea 1
_0x24:
	SBIS 0x15,0
	RJMP _0x22
_0x23:
; 0000 005B 
; 0000 005C                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0x5
; 0000 005D 
; 0000 005E                            for (i=0;i<numpasos;i++){
_0x2A:
	__CPWRR 13,14,3,4
	BRSH _0x2B
; 0000 005F                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x6
; 0000 0060                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 0061                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
; 0000 0062                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0063                                 //TIENE 10 s para pasar
; 0000 0064                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x2E:
	SBIC 0x15,0
	RJMP _0x30
; 0000 0065                                     if(PINC.2 == 0 && PINC.4 == 1){
	SBIC 0x6,2
	RJMP _0x32
	SBIC 0x6,4
	RJMP _0x33
_0x32:
	RJMP _0x31
_0x33:
; 0000 0066                                        while(PINC.4 == 1){//Mientras esté intentando entrar activa martillo
_0x34:
	SBIS 0x6,4
	RJMP _0x36
; 0000 0067                                             PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0068                                             delay_ms (5000);
; 0000 0069                                             PORTC.1 = 0; //Desactiva martillo
	CBI  0x8,1
; 0000 006A                                        }
	RJMP _0x34
_0x36:
; 0000 006B                                     }
; 0000 006C 
; 0000 006D                                     if(PINC.3 == 1){
_0x31:
	SBIS 0x6,3
	RJMP _0x3B
; 0000 006E                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 006F                                         if(PINC.4 == 1)
	SBIC 0x6,4
; 0000 0070                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 0071                                     }
; 0000 0072 
; 0000 0073                                     if(prev == 1 && curre == 1 && PINC.2 == 1){
_0x3B:
	RCALL SUBOPT_0x9
	BRNE _0x3E
	RCALL SUBOPT_0xA
	BRNE _0x3E
	SBIC 0x6,2
	RJMP _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
; 0000 0074                                        entry=1;
	RCALL SUBOPT_0xB
; 0000 0075                                        break;
	RJMP _0x30
; 0000 0076                                     }
; 0000 0077                                 }
_0x3D:
	RJMP _0x2E
_0x30:
; 0000 0078                                 if(entry == 0){ //Checa la bandera de si el usuario pasó
	MOV  R0,R11
	OR   R0,R12
	BREQ _0x2B
; 0000 0079                                     break;
; 0000 007A                                 }
; 0000 007B                            }
	RCALL SUBOPT_0xC
	RJMP _0x2A
_0x2B:
; 0000 007C                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xD
; 0000 007D                            numpasos=0;
; 0000 007E                          }
; 0000 007F                        }
_0x20:
; 0000 0080                     else{
	RJMP _0x41
_0x1F:
; 0000 0081                            if(PIND.2==1){ //Señal de paso
	SBIS 0x9,2
	RJMP _0x42
; 0000 0082                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x6
; 0000 0083                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 0084                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024  ...
; 0000 0085                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0086                                 //TIENE 10 s para pasar
; 0000 0087 
; 0000 0088                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x45:
	SBIC 0x15,0
	RJMP _0x47
; 0000 0089                                     if(PINC.2 == 0 && PINC.4 == 1){
	SBIC 0x6,2
	RJMP _0x49
	SBIC 0x6,4
	RJMP _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 008A                                        while(PINC.4 == 1){//Mientras esté intentando entrar activa martillo
_0x4B:
	SBIS 0x6,4
	RJMP _0x4D
; 0000 008B                                             PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 008C                                             delay_ms (5000);
; 0000 008D                                             PORTC.1 = 0; //Desactiva martillo
	CBI  0x8,1
; 0000 008E                                        }
	RJMP _0x4B
_0x4D:
; 0000 008F                                     }
; 0000 0090 
; 0000 0091                                     if(PINC.3 == 1){
_0x48:
	SBIS 0x6,3
	RJMP _0x52
; 0000 0092                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 0093                                         if(PINC.4 == 1)
	SBIC 0x6,4
; 0000 0094                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 0095                                     }
; 0000 0096 
; 0000 0097                                     if(prev == 1 && curre == 1 && PINC.2 == 1){
_0x52:
	RCALL SUBOPT_0x9
	BRNE _0x55
	RCALL SUBOPT_0xA
	BRNE _0x55
	SBIC 0x6,2
	RJMP _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 0098                                        break;
	RJMP _0x47
; 0000 0099                                     }
; 0000 009A                                 }
_0x54:
	RJMP _0x45
_0x47:
; 0000 009B                                 TCCR1B=0;       //Apagar timer
	LDI  R30,LOW(0)
	STS  129,R30
; 0000 009C                            }
; 0000 009D                            numpasos=0;
_0x42:
	CLR  R3
	CLR  R4
; 0000 009E                          }
_0x41:
; 0000 009F                     }
; 0000 00A0 
; 0000 00A1                }
_0xC:
	RJMP _0x9
_0xB:
; 0000 00A2               while (PIND.2==1){ //Mientras señal de pulso activada
_0x57:
	SBIS 0x9,2
	RJMP _0x59
; 0000 00A3                     PORTC.1 = 0; //Martillo desactivado
	CBI  0x8,1
; 0000 00A4               }
	RJMP _0x57
_0x59:
; 0000 00A5 
; 0000 00A6         }
	RJMP _0x6
_0x8:
; 0000 00A7 
; 0000 00A8        while (PIND.4 == 0){ //PASO SENTIDO IZQUIERDO
_0x5C:
	SBIC 0x9,4
	RJMP _0x5E
; 0000 00A9                while(PIND.5 ==0){ //Pulso continuo no activado
_0x5F:
	SBIC 0x9,5
	RJMP _0x61
; 0000 00AA                     if (PINC.2 != 1){ //Microswitch no en reposo
	SBIC 0x6,2
	RJMP _0x62
; 0000 00AB                         if(PIND.6 == 1){ // Bloqueo sentido de salida
	SBIS 0x9,6
	RJMP _0x63
; 0000 00AC                             PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00AD                             delay_ms (5000);
; 0000 00AE                             PORTC.1 = 0; //Desactiva martillo
	RJMP _0xB4
; 0000 00AF                         }
; 0000 00B0                         else{
_0x63:
; 0000 00B1                             if (PINC.4 == 1){ // Microswitch giro izq.
	SBIS 0x6,4
	RJMP _0x69
; 0000 00B2                                 if (prevS == 0){
	MOV  R0,R5
	OR   R0,R6
	BRNE _0x6A
; 0000 00B3                                     while(PINC.4 == 1){
_0x6B:
	SBIS 0x6,4
	RJMP _0x6D
; 0000 00B4                                             PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00B5                                             delay_ms (5000);
; 0000 00B6                                             PORTC.1 = 0; //Desactiva martillo
	CBI  0x8,1
; 0000 00B7                                     }
	RJMP _0x6B
_0x6D:
; 0000 00B8                                 }
; 0000 00B9 
; 0000 00BA                             }
_0x6A:
; 0000 00BB                             if(PINC.3 == 1){ //Microswitch giro derecho
_0x69:
	SBIC 0x6,3
; 0000 00BC                                 prevS  = 1;
	RCALL SUBOPT_0x1
; 0000 00BD                         }
; 0000 00BE                         PORTC.1 = 0; //Martillo
_0xB4:
	CBI  0x8,1
; 0000 00BF 
; 0000 00C0                     }
; 0000 00C1 
; 0000 00C2                      if (PIND.7 == 1){ //MODO MULTIPULSO AUTORIZADO
	SBIS 0x9,7
	RJMP _0x75
; 0000 00C3 
; 0000 00C4 
; 0000 00C5                          if(PIND.2 == 1){//Señal de pulso
	SBIS 0x9,2
	RJMP _0x76
; 0000 00C6                            numpasos++;
	RCALL SUBOPT_0x2
; 0000 00C7                            //DEFINICION DE RELOJ a 5s
; 0000 00C8                            TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 00C9                            TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segun ...
; 0000 00CA                            TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 00CB                            do{
_0x78:
; 0000 00CC                              if(PIND.2 == 1){ // señal de paso
	SBIS 0x9,2
	RJMP _0x7A
; 0000 00CD                                if(numpasos > 5){
	RCALL SUBOPT_0x3
	BRLO _0x79
; 0000 00CE                                   break;
; 0000 00CF                                }
; 0000 00D0                                else{
; 0000 00D1                                   numpasos++;
	RCALL SUBOPT_0x4
; 0000 00D2                                   TIFR1.TOV1=1;//Resetea la bandera de overflow
; 0000 00D3                                   TCCR1B = 0x05; //Lo inicia de nuevo
; 0000 00D4                                }
; 0000 00D5                              }
; 0000 00D6                            }while(TIFR0.TOV0==0); //Mientras la bandera de overflow no sea 1
_0x7A:
	SBIS 0x15,0
	RJMP _0x78
_0x79:
; 0000 00D7                             TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0x5
; 0000 00D8 
; 0000 00D9 
; 0000 00DA                            for (i=0;i<numpasos;i++){
_0x80:
	__CPWRR 13,14,3,4
	BRSH _0x81
; 0000 00DB                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x6
; 0000 00DC                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 00DD                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
; 0000 00DE                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 00DF                                 //TIENE 10 s para pasar
; 0000 00E0 
; 0000 00E1                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x84:
	SBIC 0x15,0
	RJMP _0x86
; 0000 00E2                                     if(PINC.2 == 0 && PINC.3 == 1){
	SBIC 0x6,2
	RJMP _0x88
	SBIC 0x6,3
	RJMP _0x89
_0x88:
	RJMP _0x87
_0x89:
; 0000 00E3                                        while(PINC.3 == 1){//Mientras esté intentando entrar activa martillo
_0x8A:
	SBIS 0x6,3
	RJMP _0x8C
; 0000 00E4                                             PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 00E5                                             delay_ms (5000);
; 0000 00E6                                             PORTC.1 = 0; //Desactiva martillo
	CBI  0x8,1
; 0000 00E7                                        }
	RJMP _0x8A
_0x8C:
; 0000 00E8                                     }
; 0000 00E9 
; 0000 00EA                                     if(PINC.4 == 1){
_0x87:
	SBIS 0x6,4
	RJMP _0x91
; 0000 00EB                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 00EC                                         if(PINC.3 == 1)
	SBIC 0x6,3
; 0000 00ED                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 00EE                                     }
; 0000 00EF 
; 0000 00F0                                     if(prev == 1 && curre == 1 && PINC.2 == 1){
_0x91:
	RCALL SUBOPT_0x9
	BRNE _0x94
	RCALL SUBOPT_0xA
	BRNE _0x94
	SBIC 0x6,2
	RJMP _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 00F1                                        entry=1;
	RCALL SUBOPT_0xB
; 0000 00F2                                        break;
	RJMP _0x86
; 0000 00F3                                     }
; 0000 00F4                                 }
_0x93:
	RJMP _0x84
_0x86:
; 0000 00F5                                 if(entry==0){
	MOV  R0,R11
	OR   R0,R12
	BREQ _0x81
; 0000 00F6                                     break;
; 0000 00F7                                 }
; 0000 00F8                            }
	RCALL SUBOPT_0xC
	RJMP _0x80
_0x81:
; 0000 00F9                            TCCR1B=0;       //Apagar timer
	RCALL SUBOPT_0xD
; 0000 00FA                            numpasos=0;
; 0000 00FB                          }
; 0000 00FC                        }
_0x76:
; 0000 00FD                     else{
	RJMP _0x97
_0x75:
; 0000 00FE                            if(PIND.2 == 0){ //señal de paso
	SBIC 0x9,2
	RJMP _0x98
; 0000 00FF                                  TIFR1.TOV1=1;//Resetea la bandera de overflow
	RCALL SUBOPT_0x6
; 0000 0100                                  TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024
; 0000 0101                                  TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 ...
; 0000 0102                                  TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
; 0000 0103                                 //TIENE 10 s para pasar
; 0000 0104 
; 0000 0105                                 while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1
_0x9B:
	SBIC 0x15,0
	RJMP _0x9D
; 0000 0106                                     if(PINC.2 == 0 && PINC.3 == 1){
	SBIC 0x6,2
	RJMP _0x9F
	SBIC 0x6,3
	RJMP _0xA0
_0x9F:
	RJMP _0x9E
_0xA0:
; 0000 0107                                        while(PINC.3 == 1){//Mientras esté intentando entrar activa martillo
_0xA1:
	SBIS 0x6,3
	RJMP _0xA3
; 0000 0108                                             PORTC.1 = 1; //Activa martillo
	RCALL SUBOPT_0x0
; 0000 0109                                             delay_ms (5000);
; 0000 010A                                             PORTC.1 = 0; //Desactiva martillo
	CBI  0x8,1
; 0000 010B                                        }
	RJMP _0xA1
_0xA3:
; 0000 010C                                     }
; 0000 010D 
; 0000 010E                                     if(PINC.4 == 1){
_0x9E:
	SBIS 0x6,4
	RJMP _0xA8
; 0000 010F                                         prev  = 1;
	RCALL SUBOPT_0x7
; 0000 0110                                         if(PINC.3 == 1)
	SBIC 0x6,3
; 0000 0111                                             curre = 1;
	RCALL SUBOPT_0x8
; 0000 0112                                     }
; 0000 0113 
; 0000 0114                                     if(prev == 1 && curre == 1 && PINC.2 == 1){
_0xA8:
	RCALL SUBOPT_0x9
	BRNE _0xAB
	RCALL SUBOPT_0xA
	BRNE _0xAB
	SBIC 0x6,2
	RJMP _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
; 0000 0115                                        break;
	RJMP _0x9D
; 0000 0116                                     }
; 0000 0117                                 }
_0xAA:
	RJMP _0x9B
_0x9D:
; 0000 0118                            }
; 0000 0119                            TCCR1B=0;       //Apagar timer
_0x98:
	RCALL SUBOPT_0xD
; 0000 011A                            numpasos=0;
; 0000 011B                          }
_0x97:
; 0000 011C                     }
; 0000 011D                }
_0x62:
	RJMP _0x5F
_0x61:
; 0000 011E               while (PIND.2 == 1){ //Señal de paso
_0xAD:
	SBIS 0x9,2
	RJMP _0xAF
; 0000 011F                                 PORTC.1=0;
	CBI  0x8,1
; 0000 0120               }
	RJMP _0xAD
_0xAF:
; 0000 0121 
; 0000 0122         }
	RJMP _0x5C
_0x5E:
; 0000 0123 }
	RJMP _0x3
; 0000 0124 }
_0xB2:
	RJMP _0xB2
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	SBI  0x8,1
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 5,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	__GETW1R 3,4
	ADIW R30,1
	__PUTW1R 3,4
	SBIW R30,1
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	SBI  0x16,0
	LDI  R30,LOW(5)
	STS  129,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  129,R30
	CLR  R13
	CLR  R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x6:
	SBI  0x16,0
	LDI  R30,LOW(5)
	STS  129,R30
	LDI  R30,LOW(217)
	STS  133,R30
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R7
	CPC  R31,R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R9
	CPC  R31,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 11,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  129,R30
	CLR  R3
	CLR  R4
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
