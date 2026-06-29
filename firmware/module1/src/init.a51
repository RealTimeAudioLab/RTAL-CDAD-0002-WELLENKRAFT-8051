;*************************************************************************************************
;* INIT ******************************************************************************************
;*************************************************************************************************

Timer_Init:
    	mov  SFRPAGE,   #TIMER01_PAGE
    	mov  TCON,      #050h		; Timer 0 und 1 ON
    	mov  SFRPAGE,   #TIMER01_PAGE
    	mov  TMOD,      #022h
	mov  TH0,	#000h		; 11.059.200 Hz / (256 - X) = 43200 Hz für LFO
    	mov  TH1,       #04fh		; 31250 baud für MIDI

    	mov  SFRPAGE,   #TMR2_PAGE
    	mov  TMR2CN,    #004h		; Timer 2 EN
    	mov  SFRPAGE,   #TMR2_PAGE
    	mov  TMR2CF,    #008h
    	mov  RCAP2L,    #09eh		; 49929 Hz Abtastrate für VOICE2
    	mov  RCAP2H,    #0f5h

	mov  SFRPAGE,	#TMR3_PAGE;	; Timer 3
    	mov  TMR3CN,	#04h
    	mov  TMR3CF,    #08h		; Sysclk
	mov  RCAP3L,	#09eh		; 49929 Hz Abtastrate für VOICE1
    	mov  RCAP3H,	#0f5h		; 

	mov  SFRPAGE,	#TMR4_PAGE;	; Timer 4
    	mov  TMR4CN,	#00h		; Timer 4 DIS
	mov  TMR4CF,    #08h		; Sysclk
	;mov  RCAP4L,	#0f7h		; RCAP4 = 65536-(CLK/16*Baud) = 65536-(132.710.400/16*31.250)
    	;mov  RCAP4H,	#0feh	
	mov  RCAP4L,	#0efh		; RCAP4 = 65536-(CLK/16*Baud) = 65536-(132.710.400/16*500.000)
    	mov  RCAP4H,	#0ffh
	;mov  RCAP4L,	#0f7h		; RCAP4 = 65536-(CLK/16*Baud) = 65536-(132.710.400/16*921.600)
    	;mov  RCAP4H,	#0ff	
	mov  TMR4CN,	#04h		; Timer 4 EN

	mov  SFRPAGE,	#PCA0_PAGE
	mov  PCA0MD,	#00001001b	; Sysclk, Enable a PCA0 Counter/Timer Overflow interrupt request when CF (PCA0CN.7) is set
	mov  PCA0CN,	#00000000b	; PCA0 counter/timer DIS
	mov  PCA0L,	#0dah		; 16643 Hz für ADSR
	mov  PCA0H,	#0e0h
	;mov  PCA0CN,    #01000000b	; PCA0 counter/timer EN

    	ret

UART_Init:
	mov  SFRPAGE,   #UART0_PAGE	; Serielle Schnittstelle zum Arduino mit 500.000 baud
	mov  SCON0,     #040h		; Mode1, 8bit UART, variable Baud Rate, Receive DIS
	mov  SSTA0,     #00fh		; 1: SMOD=1, UART0 baud rate divide-by-two disabled, Timer 4 generates UART0 TX Baud Rate
	;setb TI0
    	mov  SFRPAGE,   #UART1_PAGE	; MIDI IN
    	mov  SCON1,     #050h		; Mode1, 8bit UART, variable Baud Rate, Receive EN
    	;setb TI1
    	ret

DAC_Init:
    	mov  SFRPAGE,   #DAC0_PAGE
    	mov  DAC0CN,    #098h		; D/A wird vom Timer 2 aktualisiert
    	mov  SFRPAGE,   #DAC1_PAGE
    	mov  DAC1CN,    #088h		; D/A wird vom Timer 3 aktualisiert
	mov  SFRPAGE,	#LEGACY_PAGE
	orl  REF0CN,    #03h		; Enable the internal VREF (2.4v) and the Bias Generator
    	ret

Port_IO_Init:
    	mov  SFRPAGE,   #CONFIG_PAGE
        mov  P0MDOUT,	#035h
        mov  P1MDOUT,   #0FDh
        mov  P2MDOUT,   #0BFh		; P2.6 als Input
        mov  P3MDOUT,   #0FFh
	mov  XBR0,	#037h		; wenn PWM
	;mov  XBR0,	#007h		; ohne PWM
    	mov  XBR2,      #044h
    	ret

    ; P0.0  -  TX0 (UART0), Push-Pull,  Digital
    ; P0.1  -  RX0 (UART0), Open-Drain, Digital
    ; P0.2  -  SCK  (SPI0), Push-Pull,  Digital
    ; P0.3  -  MISO (SPI0), Open-Drain, Digital
    ; P0.4  -  MOSI (SPI0), Push-Pull,  Digital
    ; P0.5  -  NSS  (SPI0), Push-Pull,  Digital
    ; P0.6  -  SDA (SMBus), Open-Drain, Digital
    ; P0.7  -  SCL (SMBus), Open-Drain, Digital

    ; P1.0  -  TX1 (UART1), Push-Pull,  Digital
    ; P1.1  -  RX1 (UART1), Open-Drain, Digital
    ; P1.2  -  CEX0 (PCA),  Push-Pull,  Digital
    ; P1.3  -  CEX1 (PCA),  Push-Pull,  Digital
    ; P1.4  -  CEX2 (PCA),  Push-Pull,  Digital
    ; P1.5  -  CEX3 (PCA),  Push-Pull,  Digital
    ; P1.6  -  CEX4 (PCA),  Push-Pull,  Digital
    ; P1.7  -  CEX5 (PCA),  Push-Pull,  Digital

    ; P2.0  -  Unassigned,  Push-Pull,  Digital
    ; P2.1  -  Unassigned,  Push-Pull,  Digital
    ; P2.2  -  Unassigned,  Push-Pull,  Digital
    ; P2.3  -  Unassigned,  Push-Pull,  Digital
    ; P2.4  -  Unassigned,  Push-Pull,  Digital
    ; P2.5  -  Unassigned,  Push-Pull,  Digital
    ; P2.6  -  Unassigned,  Open-Drain, Digital
    ; P2.7  -  Unassigned,  Push-Pull,  Digital

    ; P3.0  -  Unassigned,  Push-Pull,  Digital
    ; P3.1  -  Unassigned,  Push-Pull,  Digital
    ; P3.2  -  Unassigned,  Push-Pull,  Digital
    ; P3.3  -  Unassigned,  Push-Pull,  Digital
    ; P3.4  -  Unassigned,  Push-Pull,  Digital
    ; P3.5  -  Unassigned,  Push-Pull,  Digital
    ; P3.6  -  Unassigned,  Push-Pull,  Digital
    ; P3.7  -  Unassigned,  Push-Pull,  Digital

Oscillator_Init:			; 132.710.400 Hz
    	mov  SFRPAGE,   #CONFIG_PAGE
    	mov  OSCXCN,    #067h
    	mov  R0,        #030        	; Wait 1ms for initialization
Osc_Wait1:
    	clr  A
    	djnz ACC,       $
    	djnz R0,        Osc_Wait1
Osc_Wait2:
    	mov  A,         OSCXCN
    	jnb  ACC.7,     Osc_Wait2
    	mov  PLL0CN,    #004h
    	anl  CCH0CN,    #0DFh
    	mov  SFRPAGE,   #LEGACY_PAGE
    	mov  FLSCL,     #0B0h
    	mov  SFRPAGE,   #CONFIG_PAGE
    	orl  CCH0CN,    #020h
    	orl  PLL0CN,    #001h
    	mov  PLL0DIV,   #001h
    	mov  PLL0FLT,   #001h
    	mov  PLL0MUL,   #006h		; 22.118.400 Hz * Faktor
    	clr  A                    	; Wait 5us for initialization
    	djnz ACC, $
    	orl  PLL0CN,    #002h
Pll_Wait:
    	mov  A,         PLL0CN
    	jnb  ACC.4,     Pll_Wait
    	mov  CLKSEL,    #022h
    	anl  OSCICN,    #07Fh
    	ret

External_Memory_Init:
	mov  EMI0CN,	#0		; 256-byte Page 0 (Mem 0x0000 - 0x00FF)
	mov  EMI0CF,	#00000011b	; Internal Mem only (0x0000 - 0FFFh)
	ret

SMBus_Init:
	mov  SFRPAGE,	#SMB0_Page
	mov  SMB0CN,	#004h		; Configure SMBus to send ACKs on acknowledge cycle
	mov  SMB0CR,	#065h		; 65h für 100 kHz, b8 für 200, d4 für 300, E2 für 400kHz
	orl  SMB0CN,	#040h		; En
	clr  SM_BUSY			; I2C Busy Flag
	ret

SPI_Init:
    	mov  SFRPAGE,   #SPI0_PAGE
    	mov  SPI0CFG,   #043h
    	mov  SPI0CN,    #00Dh
    	mov  SPI0CKR,   #001h		; 30 MHz
    	ret

Interrupts_Init:
	;mov  IE,        #0BAh		; EN All IRQs, UART0, T0, T1, T2
	mov  IE,        #0AAh		; EN All IRQs, T0, T1, T2
   	mov  IP,        #030h		; Prio UART0, T2
	;mov  IP,        #020h		; Prio T2
	;mov  IP,	#00010000b	; UART0 IRQ mit hoher Prio 
   	mov  EIE1,      #003h		; EN SPI und I2C
	;mov  EIP1,      #002h		; Prio I2C
   	mov  EIE2,      #041h		; EN UART1 und T3
    	mov  EIP2,      #041h		; Prio UART1 und T3
	;mov  EIP2,	#01000000b	; UART1 IRQ mit hoher Prio
    	ret

PCA_Init:
    mov  SFRPAGE,   #PCA0_PAGE
    mov  PCA0CN,    #040h
    mov  PCA0CPM0,  #042h		; 8 bit PWM Mode
    mov  PCA0CPM1,  #042h
    mov  PCA0CPM2,  #042h
    mov  PCA0CPM3,  #042h
    mov  PCA0CPM4,  #042h
    mov  PCA0CPM5,  #042h
    mov  PCA0CPH0,  #0ffh		
    mov  PCA0CPH1,  #0ffh
    mov  PCA0CPH2,  #0ffh
    mov  PCA0CPH3,  #0ffh		
    mov  PCA0CPH4,  #0ffh		
    mov  PCA0CPH5,  #0ffh		
    ret

Init_Device:
	call FLASH_Init
	call SPI_Init
	call PCA_Init
    	call Timer_Init
    	call UART_Init
    	call DAC_Init
    	call Port_IO_Init
	setb MIDI_LED
    	call Oscillator_Init
	call External_Memory_Init
	call SMBus_init
    	call Interrupts_Init
    	ret

SCALE_TAB:
	db 244,244,244,244,244,245,245,245,245,245,246,246,246,246,246
	db 247,247,247,247,247,248,248,248,248,248,249,249,249,249,249
	db 250,250,250,250,250,251,251,251,251,251,252,252,252,252,252
	db 253,253,253,253,253,254,254,254,254,254,255,255,255,255,255
	db 0,0,0,0,0,0,0,0
	db 1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5
	db 6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9
	db 10,10,10,10,10,11,11,11,11,11,12,12,12,12,12