
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
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

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _timer=R4
	.DEF _cnt=R6
	.DEF _num=R8
	.DEF _dis_j=R10
	.DEF _dis_chp=R12

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

_0x411:
	.DB  0x0,0x0
_0x0:
	.DB  0x3A,0x44,0x20,0x56,0x49,0x43,0x54,0x49
	.DB  0x4D,0x20,0x6F,0x6E,0x20,0x53,0x54,0x41
	.DB  0x47,0x45,0x20,0x3A,0x44,0x0,0x23,0x20
	.DB  0x56,0x49,0x43,0x54,0x49,0x4D,0x20,0x4C
	.DB  0x49,0x46,0x54,0x20,0x23,0x0,0x5A,0x20
	.DB  0x46,0x49,0x4E,0x49,0x53,0x48,0x20,0x5A
	.DB  0x0,0x53,0x41,0x4C,0x41,0x4D,0x20,0x53
	.DB  0x41,0x42,0x5A,0x0,0x20,0x56,0x49,0x43
	.DB  0x54,0x49,0x4D,0x20,0x0,0x20,0x20,0x52
	.DB  0x45,0x44,0x20,0x52,0x4F,0x4F,0x4D,0x20
	.DB  0x20,0x0,0x20,0x39,0x30,0x20,0x72,0x61
	.DB  0x73,0x74,0x3D,0x25,0x34,0x64,0x20,0x0
	.DB  0x20,0x39,0x30,0x20,0x63,0x68,0x61,0x70
	.DB  0x3D,0x25,0x34,0x64,0x20,0x0,0x25,0x64
	.DB  0x25,0x64,0x25,0x64,0x25,0x64,0x20,0x25
	.DB  0x64,0x25,0x64,0x25,0x64,0x25,0x64,0x0
	.DB  0x56,0x69,0x63,0x74,0x69,0x6D,0x3D,0x25
	.DB  0x64,0x20,0x0,0x4C,0x55,0x20,0x4C,0x44
	.DB  0x20,0x52,0x55,0x20,0x52,0x44,0x20,0x44
	.DB  0x20,0x55,0x0,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x0,0x20,0x25,0x33
	.DB  0x64,0x20,0x25,0x33,0x64,0x20,0x25,0x33
	.DB  0x64,0x20,0x0,0x25,0x31,0x2E,0x31,0x66
	.DB  0x20,0x25,0x31,0x2E,0x31,0x66,0x20,0x25
	.DB  0x31,0x2E,0x31,0x66,0x20,0x25,0x31,0x2E
	.DB  0x31,0x66,0x20,0x25,0x31,0x2E,0x31,0x66
	.DB  0x20,0x25,0x31,0x2E,0x31,0x66,0x20,0x25
	.DB  0x31,0x2E,0x31,0x66,0x20,0x25,0x31,0x2E
	.DB  0x31,0x66,0x0
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
	.DW  0x02
	.DW  0x04
	.DW  _0x411*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#define R1 PORTB.0
;#define R2 PORTB.1
;#define L1 PORTB.5
;#define L2 PORTB.4
;#define ELB PORTB.6
;#define ELP PORTB.7
;#define KCHB PINC.0
;#define KCHP PINC.1
;#define KRB PINC.2
;#define KRP PINC.3
;#define ENR PIND.6
;#define ENCH PIND.7
;
;#define DCL PORTD.0
;#define DOP PORTD.1
;#define MASDOUM PINC.6
;#define KB PINC.4
;#define KP PINC.5
;#define LCD PORTB.3=0
;#define MOTOR PORTB.3=1
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 001B #endasm
;#include <lcd.h>
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x00
;eeprom int rast90;
;eeprom int chap90;
;     unsigned int timer=0;
;void stop (void);
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0028 {

	.CSEG
_read_adc:
; 0000 0029 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 002A // Delay needed for the stabilization of the ADC input voltage
; 0000 002B delay_us(10);
	__DELAY_USB 27
; 0000 002C // Start the AD conversion
; 0000 002D ADCSRA|=0x40;
	SBI  0x6,6
; 0000 002E // Wait for the AD conversion to complete
; 0000 002F while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0030 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0031 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0032 }
;
;// Declare your global variables here
;void bazoo (void)
; 0000 0036 {
_bazoo:
; 0000 0037 L1=0;L2=0;R1=0;R2=0;
	CBI  0x18,5
	CBI  0x18,4
	CBI  0x18,0
	CBI  0x18,1
; 0000 0038 delay_ms(2000);
	CALL SUBOPT_0x0
; 0000 0039 ELB=1;ELP=0;
	SBI  0x18,6
	CBI  0x18,7
; 0000 003A while(KB==1);
_0x12:
	SBIC 0x13,4
	RJMP _0x12
; 0000 003B ELB=0;ELP=0;
	CBI  0x18,6
	CBI  0x18,7
; 0000 003C DCL=0;DOP=1;
	CBI  0x12,0
	SBI  0x12,1
; 0000 003D delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 003E DCL=0;DOP=0;
	CBI  0x12,0
	CBI  0x12,1
; 0000 003F }
	RET
;
;int cnt,num;
;void r_90 (unsigned int i)   //in tabe be jaye encodere moteghayyere i(moteghayyere delaye) toye tabe right_90 tanzim mishe
; 0000 0043     {                        //adade rast_90 (moteghayyere eeprom tabe right_90) har chi shod be hamun andaze delay ijad mishe
_r_90:
; 0000 0044      MOTOR;
;	i -> Y+0
	SBI  0x18,3
; 0000 0045      L1=1;L2=0;R1=0;R2=1;
	CALL SUBOPT_0x2
; 0000 0046      delay_ms(i);            //in dasture delaye
	RJMP _0x20C000B
; 0000 0047     }
;
;void l_90 (unsigned int j)    //in tabe moshabehe tabe r_90 ast
; 0000 004A     {
_l_90:
; 0000 004B      MOTOR;
;	j -> Y+0
	SBI  0x18,3
; 0000 004C      L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 004D      delay_ms(j);
_0x20C000B:
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x4
; 0000 004E     }
	ADIW R28,2
	RET
;
;void rast_gard (void)
; 0000 0051     {
_rast_gard:
; 0000 0052      L1=1;L2=0;R1=0;R2=1;
	CALL SUBOPT_0x2
; 0000 0053      r_90(rast90);
	CALL SUBOPT_0x5
; 0000 0054      stop();
	RCALL _stop
; 0000 0055      for(cnt=0;cnt<=18;cnt++)
	CLR  R6
	CLR  R7
_0x3E:
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0x3F
; 0000 0056      {
; 0000 0057       L1=0;L2=0;R1=1;R2=0;
	CBI  0x18,5
	CBI  0x18,4
	SBI  0x18,0
	CBI  0x18,1
; 0000 0058       delay_ms(350);
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	CALL SUBOPT_0x4
; 0000 0059       L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 005A       delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x4
; 0000 005B       if(PINA!=0)
	IN   R30,0x19
	CPI  R30,0
	BREQ _0x50
; 0000 005C           {
; 0000 005D            L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 005E            delay_ms(250);
	CALL SUBOPT_0x7
; 0000 005F            L1=1;L2=0;R1=0;R2=1;
	CALL SUBOPT_0x2
; 0000 0060            delay_ms(400);
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0x4
; 0000 0061            break;
	RJMP _0x3F
; 0000 0062           }
; 0000 0063      }
_0x50:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x3E
_0x3F:
; 0000 0064      stop();
	RJMP _0x20C000A
; 0000 0065      //L1=1;L2=0;R1=0;R2=1;
; 0000 0066      //en_chap(rast90);
; 0000 0067     }
;
;void chap_gard (void)
; 0000 006A     {
_chap_gard:
; 0000 006B      L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 006C      l_90(chap90);
	CALL SUBOPT_0x8
; 0000 006D      stop();
; 0000 006E      for(num=0;num<=18;num++)
	CLR  R8
	CLR  R9
_0x6A:
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CP   R30,R8
	CPC  R31,R9
	BRLT _0x6B
; 0000 006F      {
; 0000 0070       L1=1;L2=0;R1=0;R2=0;
	SBI  0x18,5
	CBI  0x18,4
	CBI  0x18,0
	CBI  0x18,1
; 0000 0071       delay_ms(350);
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	CALL SUBOPT_0x4
; 0000 0072       L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0073       delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x4
; 0000 0074       if (PINA!=0)
	IN   R30,0x19
	CPI  R30,0
	BREQ _0x7C
; 0000 0075           {
; 0000 0076            L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0077            delay_ms(250);
	CALL SUBOPT_0x7
; 0000 0078            L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 0079            delay_ms(700);
	CALL SUBOPT_0x9
; 0000 007A            break;
	RJMP _0x6B
; 0000 007B           }
; 0000 007C      }
_0x7C:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x6A
_0x6B:
; 0000 007D      stop();
_0x20C000A:
	RCALL _stop
; 0000 007E      //L1=0;L2=1;R1=1;R2=0;
; 0000 007F      //en_chap(chap90);
; 0000 0080     }
	RET
;
;int dis_j , dis_chp, dis_rp, dis_chb, dis_rb;
;void ultra_sonicb (void)
; 0000 0084     {
_ultra_sonicb:
; 0000 0085     DDRD.5=1;
	SBI  0x11,5
; 0000 0086     PORTD.5=1;
	SBI  0x12,5
; 0000 0087     delay_us(20);
	__DELAY_USB 53
; 0000 0088     PORTD.5=0;
	CBI  0x12,5
; 0000 0089     DDRD.5=0;
	CBI  0x11,5
; 0000 008A     while (PIND.5==0 );
_0x95:
	SBIS 0x10,5
	RJMP _0x95
; 0000 008B     TCNT1=0;
	CALL SUBOPT_0xA
; 0000 008C     while (PIND.5==1 );
_0x98:
	SBIC 0x10,5
	RJMP _0x98
; 0000 008D     dis_chb= TCNT1 /58 ;
	CALL SUBOPT_0xB
	STS  _dis_chb,R30
	STS  _dis_chb+1,R31
; 0000 008E     DDRC.7=1;
	SBI  0x14,7
; 0000 008F     PORTC.7=1;
	SBI  0x15,7
; 0000 0090     delay_us(20);
	__DELAY_USB 53
; 0000 0091     PORTC.7=0;
	CBI  0x15,7
; 0000 0092     DDRC.7=0;
	CBI  0x14,7
; 0000 0093     while (PINC.7==0 );
_0xA3:
	SBIS 0x13,7
	RJMP _0xA3
; 0000 0094     TCNT1=0;
	CALL SUBOPT_0xA
; 0000 0095     while (PINC.7==1 );
_0xA6:
	SBIC 0x13,7
	RJMP _0xA6
; 0000 0096     dis_rb= TCNT1 /58 ;
	CALL SUBOPT_0xB
	STS  _dis_rb,R30
	STS  _dis_rb+1,R31
; 0000 0097     delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RJMP _0x20C0008
; 0000 0098     }
;
;void ultra_sonic (void)
; 0000 009B     {
_ultra_sonic:
; 0000 009C      DDRD.4=1;
	CALL SUBOPT_0xC
; 0000 009D      PORTD.4=1;
; 0000 009E      delay_us(20);
; 0000 009F      PORTD.4=0;
; 0000 00A0      DDRD.4=0;
; 0000 00A1      while (PIND.4==0 );
_0xB1:
	SBIS 0x10,4
	RJMP _0xB1
; 0000 00A2      TCNT1=0;
	CALL SUBOPT_0xA
; 0000 00A3      while (PIND.4==1 );
_0xB4:
	SBIC 0x10,4
	RJMP _0xB4
; 0000 00A4      dis_j= TCNT1 /58 ;
	CALL SUBOPT_0xB
	MOVW R10,R30
; 0000 00A5 
; 0000 00A6      DDRD.3=1;
	SBI  0x11,3
; 0000 00A7      PORTD.3=1;
	SBI  0x12,3
; 0000 00A8      delay_us(20);
	__DELAY_USB 53
; 0000 00A9      PORTD.3=0;
	CBI  0x12,3
; 0000 00AA      DDRD.3=0;
	CBI  0x11,3
; 0000 00AB      while (PIND.3==0 );
_0xBF:
	SBIS 0x10,3
	RJMP _0xBF
; 0000 00AC      TCNT1=0;
	CALL SUBOPT_0xA
; 0000 00AD      while (PIND.3==1 );
_0xC2:
	SBIC 0x10,3
	RJMP _0xC2
; 0000 00AE      dis_chp= TCNT1 /58 ;
	CALL SUBOPT_0xB
	MOVW R12,R30
; 0000 00AF 
; 0000 00B0      DDRD.2=1;
	SBI  0x11,2
; 0000 00B1      PORTD.2=1;
	SBI  0x12,2
; 0000 00B2      delay_us(20);
	__DELAY_USB 53
; 0000 00B3      PORTD.2=0;
	CBI  0x12,2
; 0000 00B4      DDRD.2=0;
	CBI  0x11,2
; 0000 00B5      while (PIND.2==0 );
_0xCD:
	SBIS 0x10,2
	RJMP _0xCD
; 0000 00B6      TCNT1=0;
	CALL SUBOPT_0xA
; 0000 00B7      while (PIND.2==1 );
_0xD0:
	SBIC 0x10,2
	RJMP _0xD0
; 0000 00B8      dis_rp= TCNT1 /58 ;
	CALL SUBOPT_0xB
	STS  _dis_rp,R30
	STS  _dis_rp+1,R31
; 0000 00B9      delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RJMP _0x20C0008
; 0000 00BA     }
;
;void block (void)
; 0000 00BD     {
_block:
; 0000 00BE      DDRD.4=1;
	CALL SUBOPT_0xC
; 0000 00BF      PORTD.4=1;
; 0000 00C0      delay_us(20);
; 0000 00C1      PORTD.4=0;
; 0000 00C2      DDRD.4=0;
; 0000 00C3      while (PIND.4==0 );
_0xDB:
	SBIS 0x10,4
	RJMP _0xDB
; 0000 00C4      TCNT1=0;
	CALL SUBOPT_0xA
; 0000 00C5      while (PIND.4==1 );
_0xDE:
	SBIC 0x10,4
	RJMP _0xDE
; 0000 00C6      dis_j= TCNT1 /58 ;
	CALL SUBOPT_0xB
	MOVW R10,R30
; 0000 00C7      MOTOR;
	SBI  0x18,3
; 0000 00C8      if(dis_j<9)
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0xE3
; 0000 00C9         {
; 0000 00CA          stop();
	CALL SUBOPT_0xD
; 0000 00CB          L1=0;L2=1;R1=0;R2=1;
; 0000 00CC          delay_ms(250);
	CALL SUBOPT_0x7
; 0000 00CD 
; 0000 00CE          ultra_sonic();
	RCALL _ultra_sonic
; 0000 00CF          if(dis_chp<=dis_rp)
	CALL SUBOPT_0xE
	BRLT _0xEC
; 0000 00D0             {
; 0000 00D1             rast_gard();
	RCALL _rast_gard
; 0000 00D2             }
; 0000 00D3 
; 0000 00D4          if(dis_chp>dis_rp)
_0xEC:
	CALL SUBOPT_0xE
	BRGE _0xED
; 0000 00D5             {
; 0000 00D6             chap_gard();
	RCALL _chap_gard
; 0000 00D7             }
; 0000 00D8         }
_0xED:
; 0000 00D9     }
_0xE3:
	RET
;
;void eslah_aghab (void)
; 0000 00DC     {
_eslah_aghab:
	PUSH R15
; 0000 00DD     unsigned int timmer=0;
; 0000 00DE     bit reach=0;    // means robot reach the wall so timmer should start
; 0000 00DF     while ((KRP==1 && KRB==1) || (KCHP==1 && KCHB==1))
	ST   -Y,R17
	ST   -Y,R16
;	timmer -> R16,R17
;	reach -> R15.0
	CLR  R15
	__GETWRN 16,17,0
_0xEE:
	SBIS 0x13,3
	RJMP _0xF1
	SBIC 0x13,2
	RJMP _0xF3
_0xF1:
	SBIS 0x13,1
	RJMP _0xF4
	SBIC 0x13,0
	RJMP _0xF3
_0xF4:
	RJMP _0xF0
_0xF3:
; 0000 00E0         {
; 0000 00E1         if (KRP==1 && KCHP==1 && KRB==1 && KCHB==1)
	SBIS 0x13,3
	RJMP _0xF8
	SBIS 0x13,1
	RJMP _0xF8
	SBIS 0x13,2
	RJMP _0xF8
	SBIC 0x13,0
	RJMP _0xF9
_0xF8:
	RJMP _0xF7
_0xF9:
; 0000 00E2             {R1=0;R2=1;L1=0;L2=1;}
	CBI  0x18,0
	SBI  0x18,1
	CBI  0x18,5
	SBI  0x18,4
; 0000 00E3         else if ((KRP==0 || KRB==0) && KCHP==1 && KCHB==1)
	RJMP _0x102
_0xF7:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x104
	CALL SUBOPT_0xF
	BRNE _0x106
_0x104:
	SBIS 0x13,1
	RJMP _0x106
	SBIC 0x13,0
	RJMP _0x107
_0x106:
	RJMP _0x103
_0x107:
; 0000 00E4             {R1=1;R2=0;L1=0;L2=1;reach=1;}
	CALL SUBOPT_0x10
	RJMP _0x40B
; 0000 00E5         else if ((KCHP==0 || KCHB==0) && KRP==1 && KRB==1)
_0x103:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x112
	CALL SUBOPT_0x11
	BRNE _0x114
_0x112:
	SBIS 0x13,3
	RJMP _0x114
	SBIC 0x13,2
	RJMP _0x115
_0x114:
	RJMP _0x111
_0x115:
; 0000 00E6             {R1=0;R2=1;L1=1;L2=0;reach=1;}
	CALL SUBOPT_0x12
_0x40B:
	SET
	BLD  R15,0
; 0000 00E7         if(reach==1)
_0x111:
_0x102:
	SBRS R15,0
	RJMP _0x11E
; 0000 00E8             {
; 0000 00E9             timmer++;
	CALL SUBOPT_0x13
; 0000 00EA             delay_ms(1);
; 0000 00EB             }
; 0000 00EC         if (timmer>3000)
_0x11E:
	__CPWRN 16,17,3001
	BRSH _0xF0
; 0000 00ED             break;
; 0000 00EE         }
	RJMP _0xEE
_0xF0:
; 0000 00EF     R1=0;R2=0;L1=0;L2=0;
	RJMP _0x20C0009
; 0000 00F0     delay_ms(200);
; 0000 00F1     }
;void eslah_jelo (void)
; 0000 00F3     {
_eslah_jelo:
	PUSH R15
; 0000 00F4     unsigned int timmer=0;
; 0000 00F5     bit reach=0;    // means robot reach the wall so timmer should start
; 0000 00F6     while (KRB==1 || KCHB==1)
	ST   -Y,R17
	ST   -Y,R16
;	timmer -> R16,R17
;	reach -> R15.0
	CLR  R15
	__GETWRN 16,17,0
_0x128:
	SBIC 0x13,2
	RJMP _0x12B
	SBIS 0x13,0
	RJMP _0x12A
_0x12B:
; 0000 00F7         {
; 0000 00F8         if (KRB==1 && KCHB==1)
	SBIS 0x13,2
	RJMP _0x12E
	SBIC 0x13,0
	RJMP _0x12F
_0x12E:
	RJMP _0x12D
_0x12F:
; 0000 00F9             {R1=1;R2=0;L1=1;L2=0;}
	CALL SUBOPT_0x14
; 0000 00FA         else if (KRB==0 && KCHB==1)
	RJMP _0x138
_0x12D:
	CALL SUBOPT_0xF
	BRNE _0x13A
	SBIC 0x13,0
	RJMP _0x13B
_0x13A:
	RJMP _0x139
_0x13B:
; 0000 00FB             {R1=0;R2=1;L1=1;L2=0;reach=1;}
	CALL SUBOPT_0x12
	RJMP _0x40C
; 0000 00FC         else if (KRB==1 && KCHB==0)
_0x139:
	SBIS 0x13,2
	RJMP _0x146
	CALL SUBOPT_0x11
	BREQ _0x147
_0x146:
	RJMP _0x145
_0x147:
; 0000 00FD             {R1=1;R2=0;L1=0;L2=1;reach=1;}
	CALL SUBOPT_0x10
_0x40C:
	SET
	BLD  R15,0
; 0000 00FE         if(reach==1)
_0x145:
_0x138:
	SBRS R15,0
	RJMP _0x150
; 0000 00FF             {
; 0000 0100             timmer++;
	CALL SUBOPT_0x13
; 0000 0101             delay_ms(1);
; 0000 0102             }
; 0000 0103         if (timmer>3000)
_0x150:
	__CPWRN 16,17,3001
	BRLO _0x128
; 0000 0104             break;
; 0000 0105         }
_0x12A:
; 0000 0106     R1=0;R2=0;L1=0;L2=0;
_0x20C0009:
	CBI  0x18,0
	CBI  0x18,1
	CBI  0x18,5
	CBI  0x18,4
; 0000 0107     delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x4
; 0000 0108     }
	LD   R16,Y+
	LD   R17,Y+
	POP  R15
	RET
;
;//void dont_victim_hand_free (void)
;//    {
;//     DCL=0;DOP=1;
;//     delay_ms(1000);
;//     DCL=0;DOP=0;
;//     ELB=1;ELP=0;
;//     while(KB==1);
;//     ELB=0;ELP=0;
;//    }
;
;//int count;
;//void free_victim (void)
;//    {
;//     L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//     delay_ms(80);
;//     L1=0;L2=0;R1=0;R2=0;
;//     delay_ms(200);
;//
;//     ELP=1;ELB=0;
;//     delay_ms(1000);
;//     ELP=0;ELB=0;
;
;//     DOP=1;DCL=0;
;//     delay_ms(1000);
;//     DOP=0;DCL=0;
;//
;//
;//     delay_ms(2000);
;//     L1=0;L2=1;R1=0;R2=1;
;//     en_chap(80);
;//     L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//     delay_ms(80);
;//     L1=0;L2=0;R1=0;R2=0;
;//     delay_ms(200);
;//
;//     LCD;
;//     lcd_putsf("  END  ");
;//     lcd_gotoxy(0,0);
;//     lcd_gotoxy(0,1);
;//     lcd_putsf(" SALAM SABZ ");
;//
;//
;//
;//     while (1);
;//    }
;
;/*
;void find_stage (void)
;    {
;     while (1)
;         {
;          eslah_aghab();
;          if(KCHP==0 || KRP==0)
;              free_victim();
;          L1=1;L2=0;R1=1;R2=0;
;          en_rast(50);
;          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;          delay_ms(80);
;          L1=0;L2=0;R1=0;R2=0;
;          delay_ms(200);
;
;          L1=1;L2=0;R1=0;R2=1;
;          en_rast(rast90);
;
;         }
;    }*/
;
;//void find_stage (void)
;//    {
;//     while (1)
;//         {
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=0;L2=1;R1=0;R2=1;
;//          en_chap(chap90);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=1;L2=0;R1=0;R2=1;
;//          en_chap(rast90);
;//
;//          L1=1;L2=0;R1=1;R2=0;
;//          en_chap(210);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=0;L2=1;R1=1;R2=0;
;//          en_chap(chap90);
;//
;//          L1=1;L2=0;R1=1;R2=0;
;//          en_chap(150);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=1;L2=0;R1=0;R2=1;
;//          en_chap(50);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//          delay_ms(1000);
;//
;//
;//          L1=0;L2=1;R1=1;R2=0;
;//          en_chap(50);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=0;L2=1;R1=0;R2=1;
;//          en_chap(110);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=1;L2=0;R1=0;R2=1;
;//          en_chap(rast90);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(1000);
;//          L1=1;L2=0;R1=0;R2=1;
;//          en_chap(rast90);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(1000);
;//
;//          L1=1;L2=0;R1=1;R2=0;
;//          en_chap(120);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(200);
;//
;//          L1=0;L2=1;R1=1;R2=0;
;//          en_chap(40);
;//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//          delay_ms(80);
;//          L1=0;L2=0;R1=0;R2=0;
;//          delay_ms(1000);
;//
;//          eslah_jelo();
;//          free_victim();
;//
;//         }
;//    }
;
;
;
;//void block_redroom (void)
;//    {
;//     ultra_sonic();
;//     if (MASDOUM==0 && dis_j<=6)
;//         {L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//         delay_ms(80);
;//         L1=0;L2=0;R1=0;R2=0;
;//         delay_ms(200);
;//         L1=0;L2=1;R1=0;R2=1;
;//         en_rast(25);
;//         L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//         delay_ms(80);
;//         L1=0;L2=0;R1=0;R2=0;
;//         delay_ms(200);
;//         L1=1;L2=0;R1=0;R2=1;
;//         en_rast(rast90);
;//         L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//         delay_ms(80);
;//         L1=0;L2=0;R1=0;R2=0;
;//         delay_ms(200);
;//         L1=1;L2=0;R1=1;R2=0;
;//         }
;//    }
;
;//void red_room (void)
;//    {
;//    L1=1;L2=0;R1=1;R2=0;
;//    en_chap (180);
;//    stop();
;//    delay_ms(200);
;//
;//    L1=0;L2=1;R1=1;R2=0;
;//    en_chap (chap90);
;//    stop();
;//
;//    L1=1;L2=0;R1=1;R2=0;
;//    while(MASDOUM==0);
;//    L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//    delay_ms(150);
;//    L1=0;L2=0;R1=0;R2=0;
;//    delay_ms(200);
;//
;//
;//    DCL=1;DOP=0;
;//    delay_ms(500);
;//    DCL=0;DOP=0;
;//    ELP=1;ELB=0;
;//    while(KP==1);
;//    ELP=0;ELB=0;
;//
;//    DCL=1;DOP=0;
;//    ELB=1;ELP=0;
;//    while(KB==1);
;//    ELB=0;ELP=0;
;//
;//    find_stage();
;//    }
;
; void free_victim(void)
; 0000 01E6     {
_free_victim:
; 0000 01E7      stop();
	RCALL _stop
; 0000 01E8      DOP=1;
	SBI  0x12,1
; 0000 01E9      DCL=0;
	CBI  0x12,0
; 0000 01EA      delay_ms(700);
	CALL SUBOPT_0x9
; 0000 01EB      LCD;
	CALL SUBOPT_0x15
; 0000 01EC      lcd_gotoxy(0,0);
; 0000 01ED      lcd_putsf(":D VICTIM on STAGE :D");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x16
; 0000 01EE      lcd_gotoxy(0,1);
	CALL SUBOPT_0x17
; 0000 01EF      lcd_putsf("# VICTIM LIFT #");
	__POINTW1FN _0x0,22
	CALL SUBOPT_0x16
; 0000 01F0      delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x4
; 0000 01F1      lcd_clear();
	CALL _lcd_clear
; 0000 01F2 
; 0000 01F3      MOTOR;
	SBI  0x18,3
; 0000 01F4      L1=0;L2=1;R1=0;R2=1;
	CBI  0x18,5
	SBI  0x18,4
	CBI  0x18,0
	SBI  0x18,1
; 0000 01F5      delay_ms(3000);
	CALL SUBOPT_0x18
; 0000 01F6      stop();
	CALL SUBOPT_0x19
; 0000 01F7 
; 0000 01F8      LCD;
; 0000 01F9      lcd_gotoxy(0,0);
; 0000 01FA      lcd_putsf("Z FINISH Z") ;
	__POINTW1FN _0x0,38
	CALL SUBOPT_0x16
; 0000 01FB      lcd_gotoxy(0,0);
	CALL SUBOPT_0x1A
; 0000 01FC      lcd_putsf("SALAM SABZ");
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x16
; 0000 01FD      while(1);
_0x16C:
	RJMP _0x16C
; 0000 01FE     }
;
; void find_stage(void)
; 0000 0201 {
_find_stage:
; 0000 0202     while(1)
_0x16F:
; 0000 0203     {
; 0000 0204     L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0205     ultra_sonic();
	RCALL _ultra_sonic
; 0000 0206     if((dis_j>15)&&(KRB==0||KCHB==0))
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x17B
	CALL SUBOPT_0xF
	BREQ _0x17C
	CALL SUBOPT_0x11
	BRNE _0x17B
_0x17C:
	RJMP _0x17E
_0x17B:
	RJMP _0x17A
_0x17E:
; 0000 0207         {
; 0000 0208         eslah_jelo();
	RCALL _eslah_jelo
; 0000 0209         free_victim();
	RCALL _free_victim
; 0000 020A         r_90(rast90);
	CALL SUBOPT_0x5
; 0000 020B          if(dis_j<=15)
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R10
	CPC  R31,R11
	BRLT _0x17F
; 0000 020C              {
; 0000 020D               L1=1;L2=0;R1=0;R2=1;
	CALL SUBOPT_0x2
; 0000 020E               r_90(rast90);
	CALL SUBOPT_0x5
; 0000 020F              }
; 0000 0210 
; 0000 0211         }
_0x17F:
; 0000 0212     }
_0x17A:
	RJMP _0x16F
; 0000 0213 }
;
;void find_victim (void)
; 0000 0216     {
_find_victim:
; 0000 0217     ultra_sonic();
	RCALL _ultra_sonic
; 0000 0218     if((KRB==0||KCHB==0||MASDOUM==1||dis_chp<=6||dis_rp<=6)&&( dis_j>7))
	CALL SUBOPT_0xF
	BREQ _0x189
	CALL SUBOPT_0x11
	BREQ _0x189
	SBIC 0x13,6
	RJMP _0x189
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x189
	LDS  R26,_dis_rp
	LDS  R27,_dis_rp+1
	SBIW R26,7
	BRGE _0x18B
_0x189:
	CALL SUBOPT_0x1B
	BRLT _0x18C
_0x18B:
	RJMP _0x188
_0x18C:
; 0000 0219         {
; 0000 021A           if(KRB==0 && dis_j>7)
	CALL SUBOPT_0xF
	BRNE _0x18E
	CALL SUBOPT_0x1B
	BRLT _0x18F
_0x18E:
	RJMP _0x18D
_0x18F:
; 0000 021B             {
; 0000 021C             stop();
	CALL SUBOPT_0xD
; 0000 021D             L1=0;L2=1;R1=0;R2=1;
; 0000 021E             delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 021F             stop();
	CALL SUBOPT_0x1C
; 0000 0220             L1=1;L2=0;R1=0;R2=1;
; 0000 0221             delay_ms(300);
	CALL SUBOPT_0x1D
; 0000 0222             stop();
	CALL SUBOPT_0x1E
; 0000 0223             L1=1;L2=0;R1=1;R2=0;
; 0000 0224             while(MASDOUM==0);
_0x1A8:
	SBIS 0x13,6
	RJMP _0x1A8
; 0000 0225             }
; 0000 0226         else if(KCHB==0 && dis_j>7)
	RJMP _0x1AB
_0x18D:
	CALL SUBOPT_0x11
	BRNE _0x1AD
	CALL SUBOPT_0x1B
	BRLT _0x1AE
_0x1AD:
	RJMP _0x1AC
_0x1AE:
; 0000 0227             {
; 0000 0228             stop();
	CALL SUBOPT_0xD
; 0000 0229             L1=0;L2=1;R1=0;R2=1;
; 0000 022A             delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 022B             stop();
	RCALL _stop
; 0000 022C             L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 022D             delay_ms(300);
	CALL SUBOPT_0x1D
; 0000 022E             stop();
	CALL SUBOPT_0x1E
; 0000 022F             L1=1;L2=0;R1=1;R2=0;
; 0000 0230             while(MASDOUM==0);
_0x1C7:
	SBIS 0x13,6
	RJMP _0x1C7
; 0000 0231             }
; 0000 0232         else if(dis_chp<=6)
	RJMP _0x1CA
_0x1AC:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x1CB
; 0000 0233              {
; 0000 0234             stop();
	CALL SUBOPT_0xD
; 0000 0235             L1=0;L2=1;R1=0;R2=1;
; 0000 0236             delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 0237             stop();
	RCALL _stop
; 0000 0238             l_90(chap90);
	CALL SUBOPT_0x8
; 0000 0239             stop();
; 0000 023A             L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 023B             delay_ms(500);
	CALL SUBOPT_0x1F
; 0000 023C             stop();
	RCALL _stop
; 0000 023D             r_90(rast90);
	CALL SUBOPT_0x5
; 0000 023E             stop();
	CALL SUBOPT_0x1E
; 0000 023F             L1=1;L2=0;R1=1;R2=0;
; 0000 0240             while(MASDOUM==0);
_0x1E4:
	SBIS 0x13,6
	RJMP _0x1E4
; 0000 0241             }
; 0000 0242         else if(dis_rp<=6)
	RJMP _0x1E7
_0x1CB:
	CALL SUBOPT_0x20
	SBIW R26,7
	BRGE _0x1E8
; 0000 0243              {
; 0000 0244              stop();
	CALL SUBOPT_0xD
; 0000 0245              L1=0;L2=1;R1=0;R2=1;
; 0000 0246              delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 0247              stop();
	RCALL _stop
; 0000 0248              r_90(rast90);
	CALL SUBOPT_0x5
; 0000 0249              stop();
	CALL SUBOPT_0x1E
; 0000 024A              L1=1;L2=0;R1=1;R2=0;
; 0000 024B              delay_ms(500);
	CALL SUBOPT_0x1F
; 0000 024C              stop();
	RCALL _stop
; 0000 024D              l_90(chap90);
	CALL SUBOPT_0x8
; 0000 024E              stop();
; 0000 024F              L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0250              while(MASDOUM==0);
_0x201:
	SBIS 0x13,6
	RJMP _0x201
; 0000 0251              }
; 0000 0252         else if(MASDOUM==1)
	RJMP _0x204
_0x1E8:
	SBIS 0x13,6
	RJMP _0x205
; 0000 0253              {
; 0000 0254              stop();
	RCALL _stop
; 0000 0255              DOP=0;
	CBI  0x12,1
; 0000 0256              DCL=1;
	SBI  0x12,0
; 0000 0257              delay_ms(500);
	CALL SUBOPT_0x1F
; 0000 0258              DOP=0;
	CBI  0x12,1
; 0000 0259              DCL=0;
	CBI  0x12,0
; 0000 025A              ELP=1;
	SBI  0x18,7
; 0000 025B              ELB=0;
	CBI  0x18,6
; 0000 025C              while(KP==1);
_0x212:
	SBIC 0x13,5
	RJMP _0x212
; 0000 025D              ELP=0;ELB=0;
	CBI  0x18,7
	CBI  0x18,6
; 0000 025E              DCL=1;
	SBI  0x12,0
; 0000 025F              DOP=0;
	CBI  0x12,1
; 0000 0260              ELB=1;
	SBI  0x18,6
; 0000 0261              ELP=0;
	CBI  0x18,7
; 0000 0262              while(KB==1);
_0x221:
	SBIC 0x13,4
	RJMP _0x221
; 0000 0263              ELP=0;ELB=0;
	CBI  0x18,7
	CBI  0x18,6
; 0000 0264              find_stage();
	RCALL _find_stage
; 0000 0265              }
; 0000 0266         }
_0x205:
_0x204:
_0x1E7:
_0x1CA:
_0x1AB:
; 0000 0267    }
_0x188:
	RET
;
;void red_room(void)
; 0000 026A     {
_red_room:
; 0000 026B      while(1)
_0x228:
; 0000 026C         {
; 0000 026D          L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 026E          ultra_sonic();
	RCALL _ultra_sonic
; 0000 026F          while(dis_j>=8)
_0x233:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R10,R30
	CPC  R11,R31
	BRGE PC+3
	JMP _0x235
; 0000 0270              {
; 0000 0271               find_victim();
	RCALL _find_victim
; 0000 0272               ultra_sonic();
	RCALL _ultra_sonic
; 0000 0273               delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x4
; 0000 0274               ultra_sonicb();  //ba in dastour ultra sonicaye balaye fa'al mishan baraye tashkhise mane az masdoum
	RCALL _ultra_sonicb
; 0000 0275               if((dis_rp+dis_chp<65) && (dis_rb+dis_chb>=65)) //age faseleye sensoraye paein kamtar az 65 shod va faseleye balayea bishtar az 65 shod yani masdoume
	MOVW R30,R12
	CALL SUBOPT_0x20
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRGE _0x237
	LDS  R30,_dis_chb
	LDS  R31,_dis_chb+1
	LDS  R26,_dis_rb
	LDS  R27,_dis_rb+1
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRGE _0x238
_0x237:
	RJMP _0x236
_0x238:
; 0000 0276                  {
; 0000 0277                   if(dis_rp<dis_chp)
	CALL SUBOPT_0x20
	CP   R26,R12
	CPC  R27,R13
	BRGE _0x239
; 0000 0278                       {
; 0000 0279                       stop();
	CALL SUBOPT_0x19
; 0000 027A                       LCD;
; 0000 027B                       lcd_gotoxy(0,0);
; 0000 027C                       lcd_putsf(" VICTIM ");
	__POINTW1FN _0x0,60
	CALL SUBOPT_0x16
; 0000 027D                       delay_ms(2000);
	CALL SUBOPT_0x0
; 0000 027E                       lcd_clear();
	CALL _lcd_clear
; 0000 027F                       MOTOR;
	SBI  0x18,3
; 0000 0280                       L1=1;L2=0;R1=0;R2=1;
	CALL SUBOPT_0x2
; 0000 0281                       r_90(rast90);
	CALL SUBOPT_0x5
; 0000 0282                       stop();
	RJMP _0x40D
; 0000 0283                       L1=1;L2=0;R1=1;R2=0;
; 0000 0284                       find_victim();
; 0000 0285                       }
; 0000 0286                   else
_0x239:
; 0000 0287                      {
; 0000 0288                       stop();
	CALL SUBOPT_0x19
; 0000 0289                       LCD;
; 0000 028A                       lcd_gotoxy(0,0);
; 0000 028B                       lcd_putsf(" VICTIM ");
	__POINTW1FN _0x0,60
	CALL SUBOPT_0x16
; 0000 028C                       delay_ms(2000);
	CALL SUBOPT_0x0
; 0000 028D                       lcd_clear();
	CALL _lcd_clear
; 0000 028E                       MOTOR;
	SBI  0x18,3
; 0000 028F                       L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 0290                       l_90(chap90);
	CALL SUBOPT_0x21
; 0000 0291                       stop();
_0x40D:
	RCALL _stop
; 0000 0292                       L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0293                       find_victim();
	RCALL _find_victim
; 0000 0294                      }
; 0000 0295                  }
; 0000 0296              }
_0x236:
	RJMP _0x233
_0x235:
; 0000 0297          eslah_jelo();
	RCALL _eslah_jelo
; 0000 0298          stop();
	CALL SUBOPT_0xD
; 0000 0299          L1=0;L2=1;R1=0;R2=1;
; 0000 029A          delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 029B          stop();
	CALL SUBOPT_0x1C
; 0000 029C          L1=1;L2=0;R1=0;R2=1;
; 0000 029D          r_90(rast90);
	CALL SUBOPT_0x5
; 0000 029E          stop();
	CALL SUBOPT_0x1C
; 0000 029F          L1=1;L2=0;R1=0;R2=1;
; 0000 02A0          r_90(rast90);
	CALL SUBOPT_0x5
; 0000 02A1          stop();
	CALL SUBOPT_0x22
; 0000 02A2          eslah_aghab();
; 0000 02A3          L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 02A4          delay_ms(3000);
	CALL SUBOPT_0x18
; 0000 02A5          stop();
	RCALL _stop
; 0000 02A6 
; 0000 02A7          ultra_sonic();
	RCALL _ultra_sonic
; 0000 02A8          if(dis_rp+dis_chp>90)
	MOVW R30,R12
	CALL SUBOPT_0x20
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLT _0x283
; 0000 02A9              {
; 0000 02AA               if(dis_rp<dis_chp)
	CALL SUBOPT_0x20
	CP   R26,R12
	CPC  R27,R13
	BRGE _0x284
; 0000 02AB                  {
; 0000 02AC                   L1=1;L2=0;R1=0;R2=1;
	CALL SUBOPT_0x2
; 0000 02AD                   r_90(rast90);
	CALL SUBOPT_0x5
; 0000 02AE                   stop();
	RJMP _0x40E
; 0000 02AF                  }
; 0000 02B0               else
_0x284:
; 0000 02B1                  {
; 0000 02B2                   L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 02B3                   l_90(chap90);
	CALL SUBOPT_0x21
; 0000 02B4                   stop();
_0x40E:
	RCALL _stop
; 0000 02B5                  }
; 0000 02B6               L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 02B7               l_90(chap90);
	CALL SUBOPT_0x8
; 0000 02B8               stop();
; 0000 02B9              }
; 0000 02BA          L1=1;L2=0;R1=1;R2=0;
_0x283:
	CALL SUBOPT_0x6
; 0000 02BB          delay_ms(4000);
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	CALL SUBOPT_0x4
; 0000 02BC          stop();
	RCALL _stop
; 0000 02BD         }
	RJMP _0x228
; 0000 02BE     }
;
;char text[40];
;float S0,S1,S2,S3,S4,S5,S6,S7;
;//char silver;
;//void silver_lent (void)
;//    {
;//     S0=read_adc(0);
;//     S0=S0*5/1023;
;//     S1=read_adc(1);
;//     S1=S1*5/1023;
;//     S2=read_adc(2);
;//     S2=S2*5/1023;
;//     S3=read_adc(3);
;//     S3=S3*5/1023;
;//     S4=read_adc(4);
;//     S4=S4*5/1023;
;//     S5=read_adc(5);
;//     S5=S5*5/1023;
;//     S6=read_adc(6);
;//     S6=S6*5/1023;
;//     S7=read_adc(7);
;//     S7=S7*5/1023;
;//
;//     if(S0<0.3)  silver++;
;//     if(S1<0.3)  silver++;
;//     if(S2<0.3)  silver++;
;//     if(S3<0.3)  silver++;
;//     if(S4<0.3)  silver++;
;//     if(S5<0.3)  silver++;
;//     if(S6<0.3)  silver++;
;//     if(S7<0.3)  silver++;
;
;//     if(silver>3)
;//     {
;//      LCD;
;//      lcd_putsf("red_room");
;//      delay_ms(1000);
;//      lcd_clear();
;//      MOTOR;
;//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//      delay_ms(200);
;//      L1=0;L2=0;R1=0;R2=0;
;//      delay_ms(200);
;//      eslah_aghab();
;//
;//      L1=1;L2=0;R1=1;R2=0;
;//      en_rast(150);
;//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//      delay_ms(200);
;//      L1=0;L2=0;R1=0;R2=0;
;//      delay_ms(200);
;//
;//      L1=1;L2=0;R1=0;R2=1;
;//      en_rast(92);
;//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//      delay_ms(200);
;//      L1=0;L2=0;R1=0;R2=0;
;//      delay_ms(200);
;//      eslah_aghab();
;//
;//      L1=1;L2=0;R1=1;R2=0;
;//      en_rast(150);
;//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//      delay_ms(200);
;//      L1=0;L2=0;R1=0;R2=0;
;//      delay_ms(200);
;//
;//      L1=0;L2=1;R1=1;R2=0;
;//      en_rast(82);
;//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
;//      delay_ms(200);
;//      L1=0;L2=0;R1=0;R2=0;
;//      delay_ms(200);
;//      eslah_aghab();
;//      red_room();
;//     }
;//    }
;
;void stop (void)
; 0000 030E     {
_stop:
; 0000 030F      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
	SBIS 0x18,5
	RJMP _0x2A6
	CBI  0x18,5
	RJMP _0x2A7
_0x2A6:
	SBI  0x18,5
_0x2A7:
	SBIS 0x18,4
	RJMP _0x2A8
	CBI  0x18,4
	RJMP _0x2A9
_0x2A8:
	SBI  0x18,4
_0x2A9:
	SBIS 0x18,0
	RJMP _0x2AA
	CBI  0x18,0
	RJMP _0x2AB
_0x2AA:
	SBI  0x18,0
_0x2AB:
	SBIS 0x18,1
	RJMP _0x2AC
	CBI  0x18,1
	RJMP _0x2AD
_0x2AC:
	SBI  0x18,1
_0x2AD:
; 0000 0310      delay_ms(80);
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x4
; 0000 0311      L1=0;L2=0;R1=0;R2=0;
	CBI  0x18,5
	CBI  0x18,4
	CBI  0x18,0
	CBI  0x18,1
; 0000 0312      delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
_0x20C0008:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0313     }
	RET
;
;void sathe_shibdar (void)
; 0000 0316     {
_sathe_shibdar:
; 0000 0317      if(PINA==0)
	IN   R30,0x19
	CPI  R30,0
	BRNE _0x2B6
; 0000 0318          {
; 0000 0319           timer++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 031A           delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x4
; 0000 031B          }
; 0000 031C 
; 0000 031D      if(PINA!=0)
_0x2B6:
	IN   R30,0x19
	CPI  R30,0
	BREQ _0x2B7
; 0000 031E           timer=0;
	CLR  R4
	CLR  R5
; 0000 031F      if(timer>=3000)
_0x2B7:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CP   R4,R30
	CPC  R5,R31
	BRSH PC+3
	JMP _0x2B8
; 0000 0320         {
; 0000 0321         L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0322         ultra_sonic();
	RCALL _ultra_sonic
; 0000 0323         while ((dis_j>8) && (KRB==1 && KCHB==1))
_0x2C1:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x2C4
	SBIS 0x13,2
	RJMP _0x2C5
	SBIC 0x13,0
	RJMP _0x2C6
_0x2C5:
	RJMP _0x2C4
_0x2C6:
	RJMP _0x2C7
_0x2C4:
	RJMP _0x2C3
_0x2C7:
; 0000 0324                ultra_sonic();
	RCALL _ultra_sonic
	RJMP _0x2C1
_0x2C3:
; 0000 0326 eslah_jelo();
	RCALL _eslah_jelo
; 0000 0327         stop();
	CALL SUBOPT_0xD
; 0000 0328         L1=0;L2=1;R1=0;R2=1;
; 0000 0329         delay_ms(700);
	CALL SUBOPT_0x9
; 0000 032A         stop();
	CALL SUBOPT_0x1C
; 0000 032B         L1=1;L2=0;R1=0;R2=1;
; 0000 032C         r_90(rast90);
	CALL SUBOPT_0x5
; 0000 032D         stop();
	CALL SUBOPT_0x22
; 0000 032E         eslah_aghab();
; 0000 032F         delay_ms(500);
	CALL SUBOPT_0x1F
; 0000 0330         eslah_aghab();
	RCALL _eslah_aghab
; 0000 0331 
; 0000 0332         L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 0333         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 0334         stop();
	RCALL _stop
; 0000 0335 
; 0000 0336         LCD;
	CBI  0x18,3
; 0000 0337         lcd_putsf("  RED ROOM  ");
	__POINTW1FN _0x0,69
	CALL SUBOPT_0x16
; 0000 0338         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1A
; 0000 0339         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 033A         lcd_clear();
	CALL _lcd_clear
; 0000 033B 
; 0000 033C         MOTOR;
	SBI  0x18,3
; 0000 033D         L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 033E         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 033F         stop();
	CALL SUBOPT_0x1C
; 0000 0340 
; 0000 0341         L1=1;L2=0;R1=0;R2=1;
; 0000 0342         r_90(rast90);
	CALL SUBOPT_0x5
; 0000 0343         stop();
	CALL SUBOPT_0x22
; 0000 0344         eslah_aghab();
; 0000 0345         delay_ms(500);
	CALL SUBOPT_0x1F
; 0000 0346         eslah_aghab();
	RCALL _eslah_aghab
; 0000 0347         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 0348 
; 0000 0349         L1=1;L2=0;R1=1;R2=0;
	CALL SUBOPT_0x6
; 0000 034A         delay_ms(3000);
	CALL SUBOPT_0x18
; 0000 034B         stop();
	RCALL _stop
; 0000 034C 
; 0000 034D         L1=0;L2=1;R1=1;R2=0;
	CALL SUBOPT_0x3
; 0000 034E         l_90(chap90);
	CALL SUBOPT_0x8
; 0000 034F         stop();
; 0000 0350         eslah_aghab();
	RCALL _eslah_aghab
; 0000 0351         delay_ms(1000);
	CALL SUBOPT_0x1
; 0000 0352         red_room();
	RCALL _red_room
; 0000 0353         }
; 0000 0354 
; 0000 0355     }
_0x2B8:
	RET
;
;
;void path_finder (void)
; 0000 0359     {
_path_finder:
; 0000 035A      if (PINA==0b00010000 || PINA==0b00001000 || PINA==0b00011000 || PINA==0b00110000 || PINA==0b00001100 )
	IN   R30,0x19
	CPI  R30,LOW(0x10)
	BREQ _0x305
	IN   R30,0x19
	CPI  R30,LOW(0x8)
	BREQ _0x305
	IN   R30,0x19
	CPI  R30,LOW(0x18)
	BREQ _0x305
	IN   R30,0x19
	CPI  R30,LOW(0x30)
	BREQ _0x305
	IN   R30,0x19
	CPI  R30,LOW(0xC)
	BRNE _0x304
_0x305:
; 0000 035B         {R1=1;R2=0;L1=1;L2=0;}
	RJMP _0x40F
; 0000 035C 
; 0000 035D      else if (PINA==0b00000001 || PINA==0b00000011 || PINA==0b00000010 || PINA==0b00000110 ||
_0x304:
; 0000 035E           PINA==0b00000111 || PINA==0b00001110 || PINA==0b00011100 || PINA==0b00001111 )
	IN   R30,0x19
	CPI  R30,LOW(0x1)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0x3)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0x2)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0x6)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0x7)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0xE)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0x1C)
	BREQ _0x311
	IN   R30,0x19
	CPI  R30,LOW(0xF)
	BRNE _0x310
_0x311:
; 0000 035F         {R1=1;R2=0;L1=0;L2=1;}
	CALL SUBOPT_0x10
; 0000 0360 
; 0000 0361      else if (PINA==0b00000100)    // baraye inke avale boridegi robot dor nazane
	RJMP _0x31B
_0x310:
	IN   R30,0x19
	CPI  R30,LOW(0x4)
	BRNE _0x31C
; 0000 0362                 {
; 0000 0363                 {R1=1;R2=0;L1=0;L2=1;}
	CALL SUBOPT_0x10
; 0000 0364 //                while (PINA==0b00000100);
; 0000 0365 //                {R1=1;R2=0;L1=1;L2=0;};
; 0000 0366                 }
; 0000 0367      else if (PINA==0b00001001 || PINA==0b00001011 || PINA==0b00001010 || PINA==0b00001110 || PINA==0b00001101
	RJMP _0x325
_0x31C:
; 0000 0368           || PINA==0b00010001 || PINA==0b00010011 || PINA==0b00010010 || PINA==0b00010110
; 0000 0369           || PINA==0b00011001 || PINA==0b00011011 || PINA==0b00011010 || PINA==0b00011110
; 0000 036A           || PINA==0b00110001 || PINA==0b00110011 || PINA==0b00110010 || PINA==0b00110110 )
	IN   R30,0x19
	CPI  R30,LOW(0x9)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0xB)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0xA)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0xE)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0xD)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x11)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x13)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x12)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x16)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x19)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x1B)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x1A)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x1E)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x31)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x33)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x32)
	BREQ _0x327
	IN   R30,0x19
	CPI  R30,LOW(0x36)
	BRNE _0x326
_0x327:
; 0000 036B                 {
; 0000 036C                 stop();
	CALL SUBOPT_0x23
; 0000 036D                 LCD;
; 0000 036E                 delay_ms(10);
; 0000 036F                 MOTOR;
	SBI  0x18,3
; 0000 0370                 {R1=1;R2=0;L1=1;L2=0;};
	CALL SUBOPT_0x14
; 0000 0371                 // bayad sorat kam beshe inja
; 0000 0372                 while (PINA!=0);
_0x335:
	IN   R30,0x19
	CPI  R30,0
	BRNE _0x335
; 0000 0373                 stop();
	CALL SUBOPT_0x23
; 0000 0374                 LCD;
; 0000 0375                 delay_ms(10);
; 0000 0376                 MOTOR;
	SBI  0x18,3
; 0000 0377                 {R1=1;R2=0;L1=0;L2=1;}
	CALL SUBOPT_0x10
; 0000 0378                 while (PINA.0==0);
_0x344:
	SBIS 0x19,0
	RJMP _0x344
; 0000 0379                 }
; 0000 037A 
; 0000 037B      else if (PINA==0b01000001 || PINA==0b01100001 || PINA==0b00100001 || PINA==0b00110001
	RJMP _0x347
_0x326:
; 0000 037C           || PINA==0b00100010 || PINA==0b00110010 || PINA==0b01000110 )
	IN   R30,0x19
	CPI  R30,LOW(0x41)
	BREQ _0x349
	IN   R30,0x19
	CPI  R30,LOW(0x61)
	BREQ _0x349
	IN   R30,0x19
	CPI  R30,LOW(0x21)
	BREQ _0x349
	IN   R30,0x19
	CPI  R30,LOW(0x31)
	BREQ _0x349
	IN   R30,0x19
	CPI  R30,LOW(0x22)
	BREQ _0x349
	IN   R30,0x19
	CPI  R30,LOW(0x32)
	BREQ _0x349
	IN   R30,0x19
	CPI  R30,LOW(0x46)
	BRNE _0x348
_0x349:
; 0000 037D 
; 0000 037E         {R1=1;R2=0;L1=1;L2=0;}
	RJMP _0x40F
; 0000 037F 
; 0000 0380      else if (PINA==0b10000000 || PINA==0b11000000 || PINA==0b01000000 || PINA==0b01100000 || PINA==0b00110000
_0x348:
; 0000 0381           || PINA==0b11100000 || PINA==0b01110000 || PINA==0b00111000 || PINA==0b11110000 )
	IN   R30,0x19
	CPI  R30,LOW(0x80)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0xC0)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0x40)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0x60)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0x30)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0xE0)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0x70)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0x38)
	BREQ _0x355
	IN   R30,0x19
	CPI  R30,LOW(0xF0)
	BRNE _0x354
_0x355:
; 0000 0382         {R1=0;R2=1;L1=1;L2=0;}
	CBI  0x18,0
	SBI  0x18,1
	RJMP _0x410
; 0000 0383 
; 0000 0384      else if (PINA==0b00100000)    // baraye inke avale boridegi robot dor nazane
_0x354:
	IN   R30,0x19
	CPI  R30,LOW(0x20)
	BRNE _0x360
; 0000 0385                 {
; 0000 0386                 {R1=0;R2=1;L1=1;L2=0;}
	CBI  0x18,0
	SBI  0x18,1
	RJMP _0x410
; 0000 0387 //                while (PINA==0b00100000);
; 0000 0388 //                {R1=1;R2=0;L1=1;L2=0;};
; 0000 0389                 }
; 0000 038A 
; 0000 038B      else if (PINA==0b10010000 || PINA==0b11010000 || PINA==0b01010000 || PINA==0b01110000 || PINA==0b10110000
_0x360:
; 0000 038C           || PINA==0b10001000 || PINA==0b11001000 || PINA==0b01001000 || PINA==0b01101000
; 0000 038D           || PINA==0b10011000 || PINA==0b11011000 || PINA==0b01011000 || PINA==0b01111000
; 0000 038E           || PINA==0b10001100 || PINA==0b11001100 || PINA==0b01001100 || PINA==0b01101100 )
	IN   R30,0x19
	CPI  R30,LOW(0x90)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0xD0)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x50)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x70)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0xB0)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x88)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0xC8)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x48)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x68)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x98)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0xD8)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x58)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x78)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x8C)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0xCC)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x4C)
	BREQ _0x36B
	IN   R30,0x19
	CPI  R30,LOW(0x6C)
	BRNE _0x36A
_0x36B:
; 0000 038F                 {
; 0000 0390                 stop();
	CALL SUBOPT_0x23
; 0000 0391                 LCD;
; 0000 0392                 delay_ms(10);
; 0000 0393                 MOTOR;
	SBI  0x18,3
; 0000 0394                 {R1=1;R2=0;L1=1;L2=0;};
	CALL SUBOPT_0x14
; 0000 0395                 // bayad sorat kam beshe inja
; 0000 0396                 while (PINA!=0);
_0x379:
	IN   R30,0x19
	CPI  R30,0
	BRNE _0x379
; 0000 0397                 stop();
	CALL SUBOPT_0x23
; 0000 0398                 LCD;
; 0000 0399                 delay_ms(10);
; 0000 039A                 MOTOR;
	SBI  0x18,3
; 0000 039B                 {R1=0;R2=1;L1=1;L2=0;}
	CALL SUBOPT_0x12
; 0000 039C                 while (PINA.7==0);
_0x388:
	SBIS 0x19,7
	RJMP _0x388
; 0000 039D                 }
; 0000 039E      else if (PINA==0b10000010 || PINA==0b10000110 || PINA==0b10000100 || PINA==0b10001100 || PINA==0b01000100 || PINA==0b01001100 || PINA==0b01100010 )
	RJMP _0x38B
_0x36A:
	IN   R30,0x19
	CPI  R30,LOW(0x82)
	BREQ _0x38D
	IN   R30,0x19
	CPI  R30,LOW(0x86)
	BREQ _0x38D
	IN   R30,0x19
	CPI  R30,LOW(0x84)
	BREQ _0x38D
	IN   R30,0x19
	CPI  R30,LOW(0x8C)
	BREQ _0x38D
	IN   R30,0x19
	CPI  R30,LOW(0x44)
	BREQ _0x38D
	IN   R30,0x19
	CPI  R30,LOW(0x4C)
	BREQ _0x38D
	IN   R30,0x19
	CPI  R30,LOW(0x62)
	BRNE _0x38C
_0x38D:
; 0000 039F         {R1=1;R2=0;L1=1;L2=0;}
	RJMP _0x40F
; 0000 03A0 
; 0000 03A1      else if(PINA==0);
_0x38C:
	IN   R30,0x19
	CPI  R30,0
	BREQ _0x399
; 0000 03A2      else {R1=1;R2=0;L1=1;L2=0;}
_0x40F:
	SBI  0x18,0
	CBI  0x18,1
_0x410:
	SBI  0x18,5
	CBI  0x18,4
_0x399:
_0x38B:
_0x347:
_0x325:
_0x31B:
; 0000 03A3      sathe_shibdar();
	RCALL _sathe_shibdar
; 0000 03A4 
; 0000 03A5     }
	RET
;
;void right90(void)
; 0000 03A8     {
_right90:
; 0000 03A9     lcd_clear();
	CALL _lcd_clear
; 0000 03AA     while (1)
_0x3A2:
; 0000 03AB         {
; 0000 03AC         LCD;
	CALL SUBOPT_0x24
; 0000 03AD         sprintf(text," 90 rast=%4d ",rast90);
	__POINTW1FN _0x0,82
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 03AE         lcd_gotoxy(0,0);
; 0000 03AF         lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 03B0 
; 0000 03B1         if (KRB==0)
	SBIC 0x13,2
	RJMP _0x3A7
; 0000 03B2             {
; 0000 03B3              rast90+=100;
	CALL SUBOPT_0x25
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x28
; 0000 03B4              delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03B5             }
; 0000 03B6         else if (KRP==0)
	RJMP _0x3A8
_0x3A7:
	SBIC 0x13,3
	RJMP _0x3A9
; 0000 03B7             {
; 0000 03B8             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03B9             rast90+=10;
	CALL SUBOPT_0x25
	ADIW R30,10
	CALL SUBOPT_0x28
; 0000 03BA             }
; 0000 03BB         else if (KCHB==0)
	RJMP _0x3AA
_0x3A9:
	SBIC 0x13,0
	RJMP _0x3AB
; 0000 03BC             {
; 0000 03BD             rast90-=100;
	CALL SUBOPT_0x25
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	CALL SUBOPT_0x28
; 0000 03BE             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03BF             }
; 0000 03C0         else if (KCHP==0)
	RJMP _0x3AC
_0x3AB:
	SBIC 0x13,1
	RJMP _0x3AD
; 0000 03C1             {
; 0000 03C2             rast90-=10;
	CALL SUBOPT_0x25
	SBIW R30,10
	CALL SUBOPT_0x28
; 0000 03C3             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03C4             }
; 0000 03C5         else if (MASDOUM==1)
	RJMP _0x3AE
_0x3AD:
	SBIS 0x13,6
	RJMP _0x3AF
; 0000 03C6             {
; 0000 03C7             while (MASDOUM==1);
_0x3B0:
	SBIC 0x13,6
	RJMP _0x3B0
; 0000 03C8             delay_ms(300);
	CALL SUBOPT_0x1D
; 0000 03C9             MOTOR;
	SBI  0x18,3
; 0000 03CA             //R1=0;R2=1;L1=1;L2=0;ELB=0;ELP=0;
; 0000 03CB             r_90(rast90);
	CALL SUBOPT_0x5
; 0000 03CC             stop();
	RCALL _stop
; 0000 03CD             }
; 0000 03CE 
; 0000 03CF         if (rast90<10)
_0x3AF:
_0x3AE:
_0x3AC:
_0x3AA:
_0x3A8:
	CALL SUBOPT_0x25
	SBIW R30,10
	BRGE _0x3B5
; 0000 03D0             rast90=10;
	LDI  R26,LOW(_rast90)
	LDI  R27,HIGH(_rast90)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EEPROMWRW
; 0000 03D1         }
_0x3B5:
	RJMP _0x3A2
; 0000 03D2     }
;
;void chap_90(void)
; 0000 03D5     {
_chap_90:
; 0000 03D6     lcd_clear();
	CALL _lcd_clear
; 0000 03D7     while (1)
_0x3B6:
; 0000 03D8         {
; 0000 03D9         LCD;
	CALL SUBOPT_0x24
; 0000 03DA         sprintf(text," 90 chap=%4d ",chap90);
	__POINTW1FN _0x0,96
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x26
; 0000 03DB         lcd_gotoxy(0,0);
; 0000 03DC         lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 03DD 
; 0000 03DE         if (KRB==0)
	SBIC 0x13,2
	RJMP _0x3BB
; 0000 03DF             {
; 0000 03E0             chap90+=100;
	CALL SUBOPT_0x29
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	CALL SUBOPT_0x2A
; 0000 03E1             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03E2             }
; 0000 03E3         else if (KRP==0)
	RJMP _0x3BC
_0x3BB:
	SBIC 0x13,3
	RJMP _0x3BD
; 0000 03E4             {
; 0000 03E5             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03E6             chap90+=10;
	CALL SUBOPT_0x29
	ADIW R30,10
	CALL SUBOPT_0x2A
; 0000 03E7             }
; 0000 03E8         else if (KCHB==0)
	RJMP _0x3BE
_0x3BD:
	SBIC 0x13,0
	RJMP _0x3BF
; 0000 03E9             {
; 0000 03EA             chap90-=100;
	CALL SUBOPT_0x29
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	CALL SUBOPT_0x2A
; 0000 03EB             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03EC             }
; 0000 03ED         else if (KCHP==0)
	RJMP _0x3C0
_0x3BF:
	SBIC 0x13,1
	RJMP _0x3C1
; 0000 03EE             {
; 0000 03EF             chap90-=10;
	CALL SUBOPT_0x29
	SBIW R30,10
	CALL SUBOPT_0x2A
; 0000 03F0             delay_ms(250);
	CALL SUBOPT_0x7
; 0000 03F1             }
; 0000 03F2         else if (MASDOUM==1)
	RJMP _0x3C2
_0x3C1:
	SBIS 0x13,6
	RJMP _0x3C3
; 0000 03F3             {
; 0000 03F4             while (MASDOUM==1);
_0x3C4:
	SBIC 0x13,6
	RJMP _0x3C4
; 0000 03F5             delay_ms(300);
	CALL SUBOPT_0x1D
; 0000 03F6             MOTOR;
	SBI  0x18,3
; 0000 03F7             //R1=1;R2=0;L1=0;L2=1;ELB=0;ELP=0;
; 0000 03F8             l_90(chap90);
	CALL SUBOPT_0x8
; 0000 03F9             stop();
; 0000 03FA             }
; 0000 03FB 
; 0000 03FC         if (chap90<10)
_0x3C3:
_0x3C2:
_0x3C0:
_0x3BE:
_0x3BC:
	CALL SUBOPT_0x29
	SBIW R30,10
	BRGE _0x3C9
; 0000 03FD             chap90=10;
	LDI  R26,LOW(_chap90)
	LDI  R27,HIGH(_chap90)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EEPROMWRW
; 0000 03FE         }
_0x3C9:
	RJMP _0x3B6
; 0000 03FF     }
;
;
;void tanzimat (void)
; 0000 0403   {
_tanzimat:
; 0000 0404    while (1)
_0x3CA:
; 0000 0405        {
; 0000 0406         LCD;
	CALL SUBOPT_0x15
; 0000 0407         lcd_gotoxy(0,0);
; 0000 0408         sprintf(text,"%d%d%d%d %d%d%d%d",PINA.0,PINA.1,PINA.2,PINA.3,PINA.4,PINA.5,PINA.6,PINA.7);
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,110
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,0
	SBIC 0x19,0
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,1
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,2
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,3
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,4
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,5
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,6
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x19,7
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
; 0000 0409         lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 040A         lcd_gotoxy(0,1);
	CALL SUBOPT_0x17
; 0000 040B         sprintf(text,"Victim=%d ",MASDOUM);
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,128
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,0
	SBIC 0x13,6
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 040C         lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 040D         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
; 0000 040E         if(KRP==0)
	SBIC 0x13,3
	RJMP _0x3CF
; 0000 040F             {
; 0000 0410              while(KRP==0);
_0x3D0:
	SBIS 0x13,3
	RJMP _0x3D0
; 0000 0411              break;
	RJMP _0x3CC
; 0000 0412             }
; 0000 0413        }
_0x3CF:
	RJMP _0x3CA
_0x3CC:
; 0000 0414        lcd_clear();
	CALL _lcd_clear
; 0000 0415 
; 0000 0416    while (1)
_0x3D3:
; 0000 0417        {
; 0000 0418         LCD;
	CALL SUBOPT_0x15
; 0000 0419         lcd_gotoxy(0,0);
; 0000 041A         lcd_putsf("LU LD RU RD D U");
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x16
; 0000 041B         lcd_gotoxy(0,1);
	CALL SUBOPT_0x17
; 0000 041C         sprintf(text,"%d %d %d %d %d %d",KCHB,KCHP,KRB,KRP,KP,KB);
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,155
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x13,5
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	CALL SUBOPT_0x2C
	LDI  R24,24
	CALL _sprintf
	ADIW R28,28
; 0000 041D         lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 041E         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
; 0000 041F         if(KRP==0)
	SBIC 0x13,3
	RJMP _0x3D8
; 0000 0420             {
; 0000 0421              while(KRP==0);
_0x3D9:
	SBIS 0x13,3
	RJMP _0x3D9
; 0000 0422              break;
	RJMP _0x3D5
; 0000 0423             }
; 0000 0424        }
_0x3D8:
	RJMP _0x3D3
_0x3D5:
; 0000 0425        lcd_clear();
	CALL _lcd_clear
; 0000 0426 
; 0000 0427    while (1)
_0x3DC:
; 0000 0428      {
; 0000 0429       LCD;
	CBI  0x18,3
; 0000 042A       ultra_sonic();
	RCALL _ultra_sonic
; 0000 042B       lcd_gotoxy(0,0);
	CALL SUBOPT_0x1A
; 0000 042C       sprintf(text," %3d %3d %3d ",dis_rp,dis_j,dis_chp);
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,173
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_dis_rp
	LDS  R31,_dis_rp+1
	CALL SUBOPT_0x2D
	MOVW R30,R10
	CALL SUBOPT_0x2D
	MOVW R30,R12
	CALL SUBOPT_0x2D
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 042D       lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 042E      //lcd_gotoxy(0,1);
; 0000 042F      //sprintf(text,"%3d %3d",dis_chb,dis_chp);
; 0000 0430      //lcd_puts(text);
; 0000 0431      //delay_ms(100);
; 0000 0432       if(KRP==0)
	SBIC 0x13,3
	RJMP _0x3E1
; 0000 0433           {
; 0000 0434            while(KRP==0);
_0x3E2:
	SBIS 0x13,3
	RJMP _0x3E2
; 0000 0435            break;
	RJMP _0x3DE
; 0000 0436           }
; 0000 0437      }
_0x3E1:
	RJMP _0x3DC
_0x3DE:
; 0000 0438      lcd_clear();
	CALL _lcd_clear
; 0000 0439 
; 0000 043A      while(1)   //in tabe marbut be tanzimate adc e ke faghat tanzim mishe too barname estefade nashode azash
_0x3E5:
; 0000 043B          {
; 0000 043C           S0=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S0)
	LDI  R27,HIGH(_S0)
	CALL SUBOPT_0x2E
; 0000 043D           S0=S0*5/1023;
	LDS  R26,_S0
	LDS  R27,_S0+1
	LDS  R24,_S0+2
	LDS  R25,_S0+3
	CALL SUBOPT_0x2F
	STS  _S0,R30
	STS  _S0+1,R31
	STS  _S0+2,R22
	STS  _S0+3,R23
; 0000 043E           S1=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S1)
	LDI  R27,HIGH(_S1)
	CALL SUBOPT_0x2E
; 0000 043F           S1=S1*5/1023;
	LDS  R26,_S1
	LDS  R27,_S1+1
	LDS  R24,_S1+2
	LDS  R25,_S1+3
	CALL SUBOPT_0x2F
	STS  _S1,R30
	STS  _S1+1,R31
	STS  _S1+2,R22
	STS  _S1+3,R23
; 0000 0440           S2=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S2)
	LDI  R27,HIGH(_S2)
	CALL SUBOPT_0x2E
; 0000 0441           S2=S2*5/1023;
	LDS  R26,_S2
	LDS  R27,_S2+1
	LDS  R24,_S2+2
	LDS  R25,_S2+3
	CALL SUBOPT_0x2F
	STS  _S2,R30
	STS  _S2+1,R31
	STS  _S2+2,R22
	STS  _S2+3,R23
; 0000 0442           S3=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S3)
	LDI  R27,HIGH(_S3)
	CALL SUBOPT_0x2E
; 0000 0443           S3=S3*5/1023;
	LDS  R26,_S3
	LDS  R27,_S3+1
	LDS  R24,_S3+2
	LDS  R25,_S3+3
	CALL SUBOPT_0x2F
	STS  _S3,R30
	STS  _S3+1,R31
	STS  _S3+2,R22
	STS  _S3+3,R23
; 0000 0444           S4=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S4)
	LDI  R27,HIGH(_S4)
	CALL SUBOPT_0x2E
; 0000 0445           S4=S4*5/1023;
	LDS  R26,_S4
	LDS  R27,_S4+1
	LDS  R24,_S4+2
	LDS  R25,_S4+3
	CALL SUBOPT_0x2F
	STS  _S4,R30
	STS  _S4+1,R31
	STS  _S4+2,R22
	STS  _S4+3,R23
; 0000 0446           S5=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S5)
	LDI  R27,HIGH(_S5)
	CALL SUBOPT_0x2E
; 0000 0447           S5=S5*5/1023;
	LDS  R26,_S5
	LDS  R27,_S5+1
	LDS  R24,_S5+2
	LDS  R25,_S5+3
	CALL SUBOPT_0x2F
	STS  _S5,R30
	STS  _S5+1,R31
	STS  _S5+2,R22
	STS  _S5+3,R23
; 0000 0448           S6=read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S6)
	LDI  R27,HIGH(_S6)
	CALL SUBOPT_0x2E
; 0000 0449           S6=S6*5/1023;
	LDS  R26,_S6
	LDS  R27,_S6+1
	LDS  R24,_S6+2
	LDS  R25,_S6+3
	CALL SUBOPT_0x2F
	STS  _S6,R30
	STS  _S6+1,R31
	STS  _S6+2,R22
	STS  _S6+3,R23
; 0000 044A           S7=read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_S7)
	LDI  R27,HIGH(_S7)
	CALL SUBOPT_0x2E
; 0000 044B           S7=S7*5/1023;
	LDS  R26,_S7
	LDS  R27,_S7+1
	LDS  R24,_S7+2
	LDS  R25,_S7+3
	CALL SUBOPT_0x2F
	STS  _S7,R30
	STS  _S7+1,R31
	STS  _S7+2,R22
	STS  _S7+3,R23
; 0000 044C           LCD;
	CALL SUBOPT_0x24
; 0000 044D           sprintf(text,"%1.1f %1.1f %1.1f %1.1f %1.1f %1.1f %1.1f %1.1f",S0,S1,S2,S3,S4,S5,S6,S7);
	__POINTW1FN _0x0,187
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_S0
	LDS  R31,_S0+1
	LDS  R22,_S0+2
	LDS  R23,_S0+3
	CALL __PUTPARD1
	LDS  R30,_S1
	LDS  R31,_S1+1
	LDS  R22,_S1+2
	LDS  R23,_S1+3
	CALL __PUTPARD1
	LDS  R30,_S2
	LDS  R31,_S2+1
	LDS  R22,_S2+2
	LDS  R23,_S2+3
	CALL __PUTPARD1
	LDS  R30,_S3
	LDS  R31,_S3+1
	LDS  R22,_S3+2
	LDS  R23,_S3+3
	CALL __PUTPARD1
	LDS  R30,_S4
	LDS  R31,_S4+1
	LDS  R22,_S4+2
	LDS  R23,_S4+3
	CALL __PUTPARD1
	LDS  R30,_S5
	LDS  R31,_S5+1
	LDS  R22,_S5+2
	LDS  R23,_S5+3
	CALL __PUTPARD1
	LDS  R30,_S6
	LDS  R31,_S6+1
	LDS  R22,_S6+2
	LDS  R23,_S6+3
	CALL __PUTPARD1
	LDS  R30,_S7
	LDS  R31,_S7+1
	LDS  R22,_S7+2
	LDS  R23,_S7+3
	CALL __PUTPARD1
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
; 0000 044E           lcd_gotoxy(0,0);
	CALL SUBOPT_0x1A
; 0000 044F           lcd_puts(text);
	CALL SUBOPT_0x27
; 0000 0450           if(KRP==0)
	SBIC 0x13,3
	RJMP _0x3EA
; 0000 0451               {
; 0000 0452                while(KRP==0);
_0x3EB:
	SBIS 0x13,3
	RJMP _0x3EB
; 0000 0453                break;
	RJMP _0x3E7
; 0000 0454               }
; 0000 0455          }
_0x3EA:
	RJMP _0x3E5
_0x3E7:
; 0000 0456      lcd_clear();
	CALL _lcd_clear
; 0000 0457   }
	RET
;
;int cntr=0;
;
;void main(void)
; 0000 045C {
_main:
; 0000 045D // Declare your local variables here
; 0000 045E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 045F DDRA=0x00;
	OUT  0x1A,R30
; 0000 0460 
; 0000 0461 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0462 DDRB=0xFF;
	OUT  0x17,R30
; 0000 0463 
; 0000 0464 PORTC=0xFF;
	OUT  0x15,R30
; 0000 0465 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0466 
; 0000 0467 PORTD=0x00;
	OUT  0x12,R30
; 0000 0468 DDRD=0x00;
	OUT  0x11,R30
; 0000 0469 
; 0000 046A TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 046B TCCR1B=0x02;
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 046C TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 046D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 046E ICR1H=0x00;
	OUT  0x27,R30
; 0000 046F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0470 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0471 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0472 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0473 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0474 
; 0000 0475 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0476 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0477 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0478 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 0479 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 047A 
; 0000 047B LCD;
	CBI  0x18,3
; 0000 047C lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 047D PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 047E MOTOR;
	SBI  0x18,3
; 0000 047F 
; 0000 0480 if(chap90==-1)
	CALL SUBOPT_0x29
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x3F2
; 0000 0481    chap90=580;
	LDI  R26,LOW(_chap90)
	LDI  R27,HIGH(_chap90)
	LDI  R30,LOW(580)
	LDI  R31,HIGH(580)
	CALL __EEPROMWRW
; 0000 0482 
; 0000 0483 if (rast90==-1)
_0x3F2:
	CALL SUBOPT_0x25
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x3F3
; 0000 0484     rast90=570;
	LDI  R26,LOW(_rast90)
	LDI  R27,HIGH(_rast90)
	LDI  R30,LOW(570)
	LDI  R31,HIGH(570)
	CALL __EEPROMWRW
; 0000 0485 
; 0000 0486 if (KCHB==0)
_0x3F3:
	SBIC 0x13,0
	RJMP _0x3F4
; 0000 0487     {
; 0000 0488      while(KCHB==0);
_0x3F5:
	SBIS 0x13,0
	RJMP _0x3F5
; 0000 0489      tanzimat();
	RCALL _tanzimat
; 0000 048A     }
; 0000 048B 
; 0000 048C if (KRP==0)
_0x3F4:
	SBIC 0x13,3
	RJMP _0x3F8
; 0000 048D     {
; 0000 048E      while(KRP==0);
_0x3F9:
	SBIS 0x13,3
	RJMP _0x3F9
; 0000 048F      right90();
	RCALL _right90
; 0000 0490     }
; 0000 0491 
; 0000 0492 if (KRB==0)
_0x3F8:
	SBIC 0x13,2
	RJMP _0x3FC
; 0000 0493     {
; 0000 0494      while(KRB==0);
_0x3FD:
	SBIS 0x13,2
	RJMP _0x3FD
; 0000 0495      bazoo();
	RCALL _bazoo
; 0000 0496     }
; 0000 0497 
; 0000 0498 if (KCHP==0)
_0x3FC:
	SBIC 0x13,1
	RJMP _0x400
; 0000 0499     {
; 0000 049A      while(KCHP==0);
_0x401:
	SBIS 0x13,1
	RJMP _0x401
; 0000 049B      chap_90();
	RCALL _chap_90
; 0000 049C     }
; 0000 049D 
; 0000 049E //MOTOR;
; 0000 049F //r_90(10000);
; 0000 04A0 //bazoo();
; 0000 04A1 //red_room();
; 0000 04A2 
; 0000 04A3 while (1)
_0x400:
_0x404:
; 0000 04A4       {
; 0000 04A5        for(cntr=0;cntr<8000;cntr++)
	LDI  R30,LOW(0)
	STS  _cntr,R30
	STS  _cntr+1,R30
_0x408:
	LDS  R26,_cntr
	LDS  R27,_cntr+1
	CPI  R26,LOW(0x1F40)
	LDI  R30,HIGH(0x1F40)
	CPC  R27,R30
	BRGE _0x409
; 0000 04A6             {
; 0000 04A7             path_finder();
	RCALL _path_finder
; 0000 04A8             }
	LDI  R26,LOW(_cntr)
	LDI  R27,HIGH(_cntr)
	CALL SUBOPT_0x30
	RJMP _0x408
_0x409:
; 0000 04A9        block();
	RCALL _block
; 0000 04AA 
; 0000 04AB 
; 0000 04AC 
; 0000 04AD       };
	RJMP _0x404
; 0000 04AE }
_0x40A:
	RJMP _0x40A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
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
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G100:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,0
	CALL SUBOPT_0x31
	RJMP _0x20C0007
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2000000,1
	CALL SUBOPT_0x31
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
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x32
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x32
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x33
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2000021
	CALL SUBOPT_0x32
_0x2000022:
	CALL SUBOPT_0x33
	BRLO _0x2000024
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x33
	BRSH _0x2000028
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x32
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	CALL SUBOPT_0x33
	BRLO _0x2000029
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x34
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x34
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x37
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x3A
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x3D
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x200010E
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x200010E:
	ST   X,R30
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3D
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x3D
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0007:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G100:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x30
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x3E
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x3E
	RJMP _0x200010F
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
	BREQ PC+3
	JMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3F
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x41
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
	BREQ PC+3
	JMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x42
	CALL __GETD1P
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	RJMP _0x200005E
_0x200005B:
	CALL SUBOPT_0x45
	CALL __ANEGF1
	CALL SUBOPT_0x43
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x200005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x41
	RJMP _0x2000060
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000060:
_0x200005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000062
	CALL SUBOPT_0x45
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2000063
_0x2000062:
	CALL SUBOPT_0x45
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G100
_0x2000063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x46
	RJMP _0x2000064
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000066
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	CALL SUBOPT_0x46
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0x70)
	BRNE _0x2000069
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006B
	CP   R20,R17
	BRLO _0x200006C
_0x200006B:
	RJMP _0x200006A
_0x200006C:
	MOV  R17,R20
_0x200006A:
_0x2000064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006D
_0x2000069:
	CPI  R30,LOW(0x64)
	BREQ _0x2000070
	CPI  R30,LOW(0x69)
	BRNE _0x2000071
_0x2000070:
	ORI  R16,LOW(4)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0x75)
	BRNE _0x2000073
_0x2000072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x48
	LDI  R17,LOW(10)
	RJMP _0x2000075
_0x2000074:
	__GETD1N 0x2710
	CALL SUBOPT_0x48
	LDI  R17,LOW(5)
	RJMP _0x2000075
_0x2000073:
	CPI  R30,LOW(0x58)
	BRNE _0x2000077
	ORI  R16,LOW(8)
	RJMP _0x2000078
_0x2000077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20000B6
_0x2000078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x48
	LDI  R17,LOW(8)
	RJMP _0x2000075
_0x200007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x48
	LDI  R17,LOW(4)
_0x2000075:
	CPI  R20,0
	BREQ _0x200007B
	ANDI R16,LOW(127)
	RJMP _0x200007C
_0x200007B:
	LDI  R20,LOW(1)
_0x200007C:
	SBRS R16,1
	RJMP _0x200007D
	CALL SUBOPT_0x44
	CALL SUBOPT_0x42
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000110
_0x200007D:
	SBRS R16,2
	RJMP _0x200007F
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	CALL __CWD1
	RJMP _0x2000110
_0x200007F:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
	CLR  R22
	CLR  R23
_0x2000110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000082
	CALL SUBOPT_0x45
	CALL __ANEGD1
	CALL SUBOPT_0x43
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000084
_0x2000083:
	ANDI R16,LOW(251)
_0x2000084:
_0x2000081:
	MOV  R19,R20
_0x200006D:
	SBRC R16,0
	RJMP _0x2000085
_0x2000086:
	CP   R17,R21
	BRSH _0x2000089
	CP   R19,R21
	BRLO _0x200008A
_0x2000089:
	RJMP _0x2000088
_0x200008A:
	SBRS R16,7
	RJMP _0x200008B
	SBRS R16,2
	RJMP _0x200008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008D
_0x200008C:
	LDI  R18,LOW(48)
_0x200008D:
	RJMP _0x200008E
_0x200008B:
	LDI  R18,LOW(32)
_0x200008E:
	CALL SUBOPT_0x3E
	SUBI R21,LOW(1)
	RJMP _0x2000086
_0x2000088:
_0x2000085:
_0x200008F:
	CP   R17,R20
	BRSH _0x2000091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000092
	CALL SUBOPT_0x49
	BREQ _0x2000093
	SUBI R21,LOW(1)
_0x2000093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x41
	CPI  R21,0
	BREQ _0x2000094
	SUBI R21,LOW(1)
_0x2000094:
	SUBI R20,LOW(1)
	RJMP _0x200008F
_0x2000091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000095
_0x2000096:
	CPI  R19,0
	BREQ _0x2000098
	SBRS R16,3
	RJMP _0x2000099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009A
_0x2000099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009A:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R19,LOW(1)
	RJMP _0x2000096
_0x2000098:
	RJMP _0x200009C
_0x2000095:
_0x200009E:
	CALL SUBOPT_0x4A
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	SUBI R18,-LOW(55)
	RJMP _0x20000A2
_0x20000A1:
	SUBI R18,-LOW(87)
_0x20000A2:
	RJMP _0x20000A3
_0x20000A0:
	SUBI R18,-LOW(48)
_0x20000A3:
	SBRC R16,4
	RJMP _0x20000A5
	CPI  R18,49
	BRSH _0x20000A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A6
_0x20000A7:
	RJMP _0x20000A9
_0x20000A6:
	CP   R20,R19
	BRSH _0x2000111
	CP   R21,R19
	BRLO _0x20000AC
	SBRS R16,0
	RJMP _0x20000AD
_0x20000AC:
	RJMP _0x20000AB
_0x20000AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000AE
_0x2000111:
	LDI  R18,LOW(48)
_0x20000A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000AF
	CALL SUBOPT_0x49
	BREQ _0x20000B0
	SUBI R21,LOW(1)
_0x20000B0:
_0x20000AF:
_0x20000AE:
_0x20000A5:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x20000B1
	SUBI R21,LOW(1)
_0x20000B1:
_0x20000AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x4A
	CALL __MODD21U
	CALL SUBOPT_0x43
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x48
	__GETD1S 16
	CALL __CPD10
	BREQ _0x200009F
	RJMP _0x200009E
_0x200009F:
_0x200009C:
	SBRS R16,0
	RJMP _0x20000B2
_0x20000B3:
	CPI  R21,0
	BREQ _0x20000B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x41
	RJMP _0x20000B3
_0x20000B5:
_0x20000B2:
_0x20000B6:
_0x2000054:
_0x200010F:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x4B
	SBIW R30,0
	BRNE _0x20000B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x20000B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x4B
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0004
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0004
_lcd_puts:
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x20C0005
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0004
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4C
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x4D
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4D
	LDI  R30,LOW(133)
	CALL SUBOPT_0x4D
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0004:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strcpyf:
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

	.CSEG
_ftrunc:
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
_floor:
	CALL SUBOPT_0x4E
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x4E
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x4E
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0003:
	ADIW R28,4
	RET

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	RCALL SUBOPT_0x4F
	__POINTW1FN _0x20A0000,0
	RCALL SUBOPT_0x31
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	RCALL SUBOPT_0x4F
	__POINTW1FN _0x20A0000,1
	RCALL SUBOPT_0x31
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x51
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
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x53
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x54
	CALL __ADDF12
	RCALL SUBOPT_0x50
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x53
_0x20A0014:
	RCALL SUBOPT_0x54
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x53
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20A0017
	RCALL SUBOPT_0x4F
	__POINTW1FN _0x20A0000,5
	RCALL SUBOPT_0x31
	RJMP _0x20C0002
_0x20A0017:
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0018
	RCALL SUBOPT_0x51
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0019
_0x20A0018:
_0x20A001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001C
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x38
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x3B
	LDI  R31,0
	RCALL SUBOPT_0x52
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x50
	RJMP _0x20A001A
_0x20A001C:
_0x20A0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x51
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A0020
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x50
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x3B
	LDI  R31,0
	RCALL SUBOPT_0x55
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x50
	RJMP _0x20A001E
_0x20A0020:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.ESEG
_rast90:
	.BYTE 0x2
_chap90:
	.BYTE 0x2

	.DSEG
_dis_rp:
	.BYTE 0x2
_dis_chb:
	.BYTE 0x2
_dis_rb:
	.BYTE 0x2
_text:
	.BYTE 0x28
_S0:
	.BYTE 0x4
_S1:
	.BYTE 0x4
_S2:
	.BYTE 0x4
_S3:
	.BYTE 0x4
_S4:
	.BYTE 0x4
_S5:
	.BYTE 0x4
_S6:
	.BYTE 0x4
_S7:
	.BYTE 0x4
_cntr:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	SBI  0x18,5
	CBI  0x18,4
	CBI  0x18,0
	SBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	CBI  0x18,5
	SBI  0x18,4
	SBI  0x18,0
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 46 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_rast90)
	LDI  R27,HIGH(_rast90)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	JMP  _r_90

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x6:
	SBI  0x18,5
	CBI  0x18,4
	SBI  0x18,0
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_chap90)
	LDI  R27,HIGH(_chap90)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	CALL _l_90
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	IN   R30,0x2C
	IN   R31,0x2C+1
	MOVW R26,R30
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	SBI  0x11,4
	SBI  0x12,4
	__DELAY_USB 53
	CBI  0x12,4
	CBI  0x11,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD:
	CALL _stop
	CBI  0x18,5
	SBI  0x18,4
	CBI  0x18,0
	SBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDS  R30,_dis_rp
	LDS  R31,_dis_rp+1
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	SBI  0x18,0
	CBI  0x18,1
	CBI  0x18,5
	SBI  0x18,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CBI  0x18,0
	SBI  0x18,1
	SBI  0x18,5
	CBI  0x18,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__ADDWRN 16,17,1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	SBI  0x18,0
	CBI  0x18,1
	SBI  0x18,5
	CBI  0x18,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x15:
	CBI  0x18,3
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL _stop
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	CALL _stop
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	CALL _stop
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDS  R26,_dis_rp
	LDS  R27,_dis_rp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_chap90)
	LDI  R27,HIGH(_chap90)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	JMP  _l_90

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CALL _stop
	JMP  _eslah_aghab

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x23:
	CALL _stop
	CBI  0x18,3
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	CBI  0x18,3
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(_rast90)
	LDI  R27,HIGH(_rast90)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_rast90)
	LDI  R27,HIGH(_rast90)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_chap90)
	LDI  R27,HIGH(_chap90)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_chap90)
	LDI  R27,HIGH(_chap90)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2C:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2E:
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x2F:
	__GETD1N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447FC000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x32:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x33:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3E:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3F:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x40:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x41:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x42:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x3F
	RJMP SUBOPT_0x40

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x46:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x47:
	RCALL SUBOPT_0x42
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x49:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4C:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x50:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x51:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x54:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
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

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
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

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

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

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
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
