$NOMOD51

$include (F120.inc)
YELLOW_LED	equ	P1.5
GREEN_LED	equ	P1.6            ; MIDI LED
RED_LED		equ	P1.7

SST25VF020_NS	equ	P2.2  
SST25VF020_WP	equ	P2.1
SST25VF020_HOLD	equ	P2.0
SST25VF020_NS_2	equ	P2.3  
MC23LCV1024_CS	equ	P2.4
arduino_busy	equ	P2.6

EFX_Select	equ	P3		; P3.0 - P3.4 für EFX Select
Modul1_Play	equ	P3.7		; P3.7 als Input, =1 wenn alle Voices des Modul1 belegt

    	CSEG
; Reset Vector
	ORG	    	0000h		; Reset 0x0000 Top			
	LJMP	    	START          	; Jump beyond interrupt vector space.
	ORG		0003h		; External Interrupt 0 (/INT0) 0x0003 0 IE0 (TCON.1)
	RETI
	ORG		000Bh		; Timer 0 Overflow 0x000B 1 TF0 (TCON.5)
	LJMP		LFO1_IRQ
	ORG		0013h		; External Interrupt 1 (/INT1) 0x0013 2 IE1 (TCON.3)
	RETI
	ORG		001Bh		; Timer 1 Overflow 0x001B 3 TF1 (TCON.7)
	LJMP		ADSR_IRQ
	ORG		0023h		; UART0 0x0023 4 RI0 (SCON0.0) TI0 (SCON0.1)
	LJMP		ARDUINO
	ORG		002Bh		; Timer 2 0x002B 5 TF2 (TMR2CN.7) EXF2 (TMR2CN.6)
	LJMP		VOICE2_IRQ
	ORG		0033h		; Serial Peripheral Interface 0x0033 6 SPIF (SPI0CN.7) WCOL (SPI0CN.6) MODF (SPI0CN.5) RXOVRN (SPI0CN.4)
	RETI
	ORG		003Bh		; SMBus Interface 0x003B 7 SI (SMB0CN.3)
	LJMP		SMBus_IRQ
	ORG		0043h		; ADC0 Window Comparator 0x0043 8 AD0WINT (ADC0CN.1)
	RETI
	ORG		004Bh		; PCA 0 0x004B 9 CF (PCA0CN.7) CCFn (PCA0CN.n)
	RETI
	ORG		0053h		; Comparator 0 Falling Edge 0x0053 10 CP0FIF (CPT0CN.4)
	RETI
	ORG		005Bh		; Comparator 0 Rising Edge 0x005B 11 CP0RIF (CPT0CN.5)
	RETI
	ORG		0063h		; Comparator 1 Falling Edge 0x0063 12 CP1FIF (CPT1CN.4)
	RETI
	ORG		006Bh		; Comparator 1 Rising Edge 0x006B 13 CP1RIF (CPT1CN.5)
	RETI
	ORG		0073h		; Timer 3 0x0073 14 TF3 (TMR3CN.7) EXF3 (TMR3CN.6)
	LJMP		DAC_IRQ
	ORG		007Bh		; ADC0 End of Conversion 0x007B 15 AD0INT (ADC0CN.5)
	RETI
	ORG		0083h		; Timer 4 0x0083 16 TF4 (TMR4CN.7) EXF4 (TMR4CN.7)
	RETI
	ORG		008Bh		; ADC2 Window Comparator 0x008B 17 AD2WINT (ADC2CN.0)
	RETI
	ORG		0093h		; ADC2 End of Conversion 0x0093 18 AD2INT (ADC2CN.5)
	RETI
	ORG		009Bh		; RESERVED 0x009B 19 N/A
	RETI
	ORG		00A3h		; UART1 0x00A3 20 RI1 (SCON1.0) TI1 (SCON1.1)
	LJMP		MIDI_IRQ   
  	ORG	    	0B3h	 	; End of interrupt vector space

;*************************************************************************************************************
;* MIDI CONTROLLERWERTE IM XRAM ******************************************************************************
;*************************************************************************************************************

	BANK		EQU	00h	;Bank
	MODULATIOSRAD	EQU	01h	;Modulationsrad

	LFO1RATE	EQU	02h	;LFO1 Geschwindigkeit 1-128(0)
	LFO1DELAY	EQU	03h	;LFO1 Einsetzverzögerung
	LFO1WAVE	EQU	04h	;LFO1 Wellenform 0-127
	LFO1RANGE	EQU	05h	;LFO1 Range low/mid/high
	LFO1KYB		EQU	06h	;LFO1 Keyboard Sync
	LFO1MIDI	EQU	07h	;LFO1 Midi Sync
	LFO2RATE	EQU	08h	;LFO2 Geschwindigkeit
	LFO2DELAY	EQU	09h	;LFO2 Einsetzverzögerung
	LFO2WAVE	EQU	0ah	;LFO2 Wellenform
	LFO2RANGE	EQU	0bh	;LFO2 Range low/mid/high
	LFO2KYB		EQU	0ch	;LFO2 Keyboard Sync
	LFO2MIDI	EQU	0dh	;LFO2 Midi Sync
	LFO1_CLK	EQU	0eh	;LFO1 Midi Clock Rate
	LFO2_CLK	EQU	0fh	;LFO2 Midi Clock Rate

	DCO1LFO1	EQU	10h	;DCO1 LFO1
	DCO1LFO2	EQU	11h	;DCO1 LFO2
	DCO1BANK	EQU	12h	;DCO1 Wavetablebank
	DCO1SCALE	EQU	13h	;DCO1 Scale
	DCO1WAVESAVE	EQU	14h	;DCO1 Wellenformen, Werte 0-127
	DCO1_WAVE_INC	EQU	15h	;DCO1 INC-Wert
	DCO1_INC_TIME	EQU	16h	;DCO1 INC Zeit
	DCO1_INC_MIDI_SYNC EQU	17h	;DCO1 INC Midi sync on/off
	DCO1_INC_TIME_2	EQU	18h	;DCO1 2.INC-Zeit 0-127 (0 für max Verzögerung der Schleife, 1 für min)
	DCO1_INC_SYNC	EQU	19h	;DCO1 INC Keyb sync on/off
	MODWHEELTAR	EQU	1Ah	;Ziel für Modulationsrad
	DCO1_INC_LOOP	EQU	1Bh	;DCO1 INC im LOOP oder ONETIME				
	DCO1_INC_MIDI_CLK EQU	1Ch	;DCO1 INC Midi Clock
        ADSR1_INV	EQU	1Dh	;ADSR1 Invers
	ADSR1_LOG	EQU	1Eh	;ADSR1 Log
	RESERVE		EQU	1Fh	;Frei

	DCO2LFO1	EQU	20h	;DCO2 LFO1
	DCO2LFO2	EQU	21h	;DCO2 LFO2
	DCO2BANK	EQU	22h	;DCO2 BANK
	DCO2SCALE	EQU	23h	;DCO2 SCALE
	DCO2WAVESAVE	EQU	24h	;DCO2 Wellenformen, Werte 0-127
	DCO2_WAVE_INC	EQU	25h	;DCO2 INC-Wert
	DCO2_INC_TIME	EQU	26h	;DCO2 INC Zeit
	DCO2NOISE	EQU	27h	;DCO1 Noise Gen
	DCO2_INC_SYNC	EQU	28h	;DCO2 INC Keyb sync on/off
	DCO2_INC_MIDI_SYNC EQU	29h	;DCO2 INC Midi sync on/off
	DCO2_INC_TIME_2	EQU	2ah	;DCO2 2.INC-Zeit
	DCO2_INC_LOOP	EQU	2Bh	;DCO2 INC im LOOP oder ONETIME				
	DCO2_INC_MIDI_CLK EQU	2Ch	;DCO2 INC Midi Clock
        DCO2FINELFO1	EQU	2Dh	;DCO2 Finetuning LFO1
	DCO2FINELFO2	EQU	2Eh	;DCO2 Finetuning LFO2
        DCO2FINE	EQU	2Fh	;DCO2 Finetuning

	DCFLFO1		EQU	30h	;DCF LFO1
	DCFLFO2		EQU	31h	;DCF LFO2
	DCFFREQ		EQU	32h	;DCF Frequenz (1-255, Step2)
	DCFRESO		EQU	33h	;DCF Resonanz
	DCFATTACK	EQU	34h	;DCF Attack
	DCFDECAY	EQU	35h	;DCF Decay
	DCFSUSTAIN	EQU	36h	;DCF Sustain
	DCFRELEASE	EQU	37h	;DCF Release
	ADSR2_INV	EQU	38h	;ADSR2 Invers
	ADSR2_LOG	EQU	39h	;ADSR2 Log			

	EFXSEND		EQU	3Ah	;Sendepegel an EFX	
	EFXRETURN	EQU	3Bh	;Empfangspegel
	EFXTYPE		EQU	3Ch	;EFX Typ
	EFX_A		EQU	3Dh	;Parameter A
	EFX_B		EQU	3Eh
	EFX_C		EQU	3Fh

	DCALFO1		EQU	40h	;DCA LFO1
	DCALFO2		EQU	41h	;DCA LFO2
	DCO1VOL		EQU	42h	;DCO1 Volume 1-255, Step2
	DCO2VOL		EQU	43h	;DCO2 Volume 1-255, Step2	
	ATTACK		EQU	44h	;1-255, Step2
	DECAY		EQU	45h	;1-255, Step2
	SUSTAIN		EQU	46h	;1-255, Step2
	RELEASE		EQU	47h	;1-255, Step2
	DCO1RVOL	EQU	48h	;DCO1 Volume Right 1-255, Step2
	DCO2LVOL	EQU	49h	;DCO2 Volume Left 1-255, Step2

	CHANNEL		EQU	4Ah	;Midi Kanal, Midi Mode und Midi CC En/Dis	
	PITCHBW		EQU	4Bh	;Pitchbend Weite (+-1 Okt oder +-2 Okt)
	VELO		EQU	4Ch	;Velocity on/off
	RINGMOD		EQU	4Dh	;Ringmodulator on/off
	VELOKURVE	EQU	4Eh	;Velocity Kurven (0-3)
	PITCHB		EQU	4Fh	;Pitchbend 0-127

	EFXLFO1		EQU	50h	;Wirkung des LFO1 auf das EFX
	EFXLFO2		EQU	51h	
	EFXLFO1TAR	EQU	52h	;Ziel des LFO1 (Off, A, B, C)
	EFXLFO2TAR	EQU	53h

        DCO1FINELFO1	EQU	54h	;DCO1 Finetuning LFO1
	DCO1FINELFO2	EQU	55h	;DCO1 Finetuning LFO2
        DCO1FINE	EQU	56h	;DCO1 Finetuning
	DCO1_INC_RESTART EQU	5Eh	;DCO1 MOD Restart
	DCO2_INC_RESTART EQU	5Fh	;DCO2 MOD Restart

;************************************************************************************************************

	DCO1LFO1VAL	EQU	80h	;=LFO1VAL*DCO1LFO1 (Multiplikatorwert)
	DCO1LFO2VAL	EQU	81h	;=LFO2VAL*DCO1LFO2 (Multiplikatorwert)
	DCFLFO1VAL	EQU	82h	;=LFO1VAL*DCFLFO1 (Multiplikatorwert)
	DCFLFO2VAL	EQU	83h	;=LFO2VAL*DCFLFO2 (Multiplikatorwert)
	DCALFO1VAL	EQU	84h	;=LFO1VAL*DCALFO1 (Multiplikatorwert)
	DCALFO2VAL	EQU	85h	;=LFO2VAL*DCALFO2 (Multiplikatorwert)
	DCO1PITCHVAL	EQU	88h	;=PITCHB+SCALE+LFO1+LFO1
	DCO1GESVOL	EQU	89h	;=DCO1VOL+LFO1+LFO2
	DCFGESFREQ	EQU	8Ah	;=DCFFREQ+LFO1
	LFO1VAL		EQU	8Dh	;LFO1 Wert steht hier 127 .... 128
	LFO2VAL		EQU	8Eh	;LFO2 Wert steht hier 127...0...255...128
	DCO2PITCHVAL	EQU	8Fh	;=PITCHB+SCALE+LFO1+LFO1
	DCO2GESVOL	EQU	90h	;=Lautstärke + LFO1 + LFO2
	RANDOM_LFO1	EQU	92h	;Random Wert für LFO1
	RANDOM_LFO2	EQU	93h	;Random Wert für LFO2
	DCO2LFO1VAL	EQU	94h	;=LFO1VAL*DCO2LFO1 (Multiplikatorwert)
	DCO2LFO2VAL	EQU	95h	;=LFO2VAL*DCO2LFO2 (Multiplikatorwert)
	DCO1Wave	EQU	96h
	DCO2Wave	EQU	97h
	DCO2FINELFO1VAL	EQU	98h	;=LFO1VAL*DCO2FINELFO1 (Multiplikatorwert)
	DCO2FINELFO2VAL	EQU	99h	;=LFO2VAL*DCO2FINELFO2 (Multiplikatorwert)
	RANDOM_NOISE	EQU	9Ah
	EFXLFO1VAL	EQU	9Bh	;=LFO1VAL*EFXLFO1
	EFXLFO2VAL	EQU	9Ch
	DCFGESRESO	EQU	9Dh	;=DCFRESO+LFO2	
	BANK1CONTENT	EQU	0A0h	;Samplenummer für Bank1
	BANK2CONTENT	EQU	0A1h	;Samplenummer für Bank2
	BANK3CONTENT	EQU	0A2h	;Samplenummer für Bank3
	BANK1BANKCONTENT EQU	0A3h	;FLASH für Bank1
	BANK2BANKCONTENT EQU	0A4h	;FLASH für Bank2
	BANK3BANKCONTENT EQU	0A5h	;FLASH für Bank3
	DCO1FINELFO1VAL	EQU	0A6h	;=LFO1VAL*DCO1FINELFO1 (Multiplikatorwert)
	DCO1FINELFO2VAL	EQU	0A7h	;=LFO2VAL*DCO1FINELFO2 (Multiplikatorwert)	
	smidibyte1	EQU	0A8h	;3 bytes für MIDI Senden
	smidibyte2	EQU	0A9h
	smidibyte3	EQU	0AAh
	smidibyte4	EQU	0ABh
	smidibyte5	EQU	0ACh
	
	ANSCHLAGDYN	EQU	0ACh	;Anschlagdynamik der 4 Tasten wird hier abgelegt
	OUT_BUFF	EQU	0B0h	;Buffer für DigiFilter Frequenz (B0-B7)
	PROGRAMMNAME	EQU	0F0h	;Name des Programms	

;*************************************************************************************************************
;* SMBus States **********************************************************************************************
;*************************************************************************************************************

   ; SMBus States
   SMB_BUS_ERROR   EQU   00h         ; (all modes) BUS ERROR
   SMB_START       EQU   08h         ; (MT & MR) START transmitted
   SMB_RP_START    EQU   10h         ; (MT & MR) repeated START
   SMB_MTADDACK    EQU   18h         ; (MT) Slave address + W transmitted;
                                     ;  ACK received
   SMB_MTADDNACK   EQU   20h         ; (MT) Slave address + W transmitted;
                                     ;  NACK received
   SMB_MTDBACK     EQU   28h         ; (MT) data byte transmitted; ACK rec'vd
   SMB_MTDBNACK    EQU   30h         ; (MT) data byte transmitted; NACK rec'vd
   SMB_MTARBLOST   EQU   38h         ; (MT) arbitration lost
   SMB_MRADDACK    EQU   40h         ; (MR) Slave address + R transmitted;
                                     ;  ACK received
   SMB_MRADDNACK   EQU   48h         ; (MR) Slave address + R transmitted;
                                     ;  NACK received
   SMB_MRDBACK     EQU   50h         ; (MR) data byte rec'vd; ACK transmitted
   SMB_MRDBNACK    EQU   58h         ; (MR) data byte rec'vd; NACK transmitted

;*************************************************************************************************************
;* 128 BYTES INTERNES RAM ************************************************************************************
;*************************************************************************************************************

			;DATA	00h	;R0 wird von MAIN und DAC_IRQ genutzt 
			;DATA	01h	;R1 wird von MIDI, RS232, T0 genutzt
	Voice_Mem	DATA	02h
	Voice_Pos	DATA	03h
	LFO1_z1		DATA	04h	;Hilfsbytes für LFO1
	LFO1_z2		DATA	05h	
	LFO1_z3		DATA	06h		
	LFO1_z4		DATA	07h	
	LFO1_help	DATA	08h
	LFO1_CLK_z1	DATA	09h	;Hilfsbyte für LFO1 Midi Sync		
	LFO2_z1		DATA	0Ah	;Hilfsbytes für LFO2
	LFO2_z2		DATA	0Bh	;Zählerbyte für LFO2 Delay
	LFO2_z3		DATA	0Ch	
	LFO2_z4		DATA	0Dh	
	LFO2_help	DATA	0Eh		
	LFO2_CLK_z1	DATA	0Fh	;Hilfsbyte für LFO2 Midi Sync	

	ADSR1_DCF	DATA	10h	;ADSR1 für DCF
	ADSR2_DCF	DATA	11h
	ADSR3_DCF	DATA	12h
	ADSR4_DCF	DATA	13h
	ADSR_DCF_Z2	DATA	14h
	ADSR_DCF_Z3	DATA	15h
	ADSR_DCF_Z5	DATA	16h
	DCO2_z1		DATA	17h	;Hilfbytes für DCO2 INC
	DCO2_z2		DATA	18h
	DPH32		DATA	19h	;Adresse >> 16bit für ext FLASH
	ADSR_Z		DATA	1Ah	;ADSR Time Verlängerung
	FLASH_SOURCE	DATA	1Bh	;Quelle für Sample/Wavetable Daten
	FLASH_BANK_SOURCE DATA	1Ch	;Quelle Bank für Sample/Wavetable Daten
	BANK_TARGET	DATA	1Dh	;Ziel für Sample/Wavetable Daten (Bank 1, 2 oder 3)
	sysex_bytes_count DATA	1Eh	;Zähler für empfangene Midi Sysex Daten
	midi_send_bytes	DATA	1Fh	;Zähler für das Senden von MIDI bytes

	Voice		DATA	20h
	Voice1		BIT	20h.0	;Wenn Voice1 spielen soll dann Bit=1 setzen
	Voice2		BIT	20h.1
	Voice3		BIT	20h.2
	Voice4		BIT	20h.3
	Voice5		BIT	20h.4
	Voice6		BIT	20h.5
	Voice7		BIT	20h.6
	Voice8		BIT	20h.7
	Voice_end	DATA	21h	;Flags für DCA ADSR
	Voice1_end	BIT	21h.0
	Voice2_end	BIT	21h.1
	Voice3_end	BIT	21h.2
	Voice4_end	BIT	21h.3
	Voice5_end	BIT	21h.4
	Voice6_end	BIT	21h.5
	Voice7_end	BIT	21h.6
	Voice8_end	BIT	21h.7
	Voice_start	DATA	22h
	Voice1_start	BIT	22h.0
	Voice2_start	BIT	22h.1
	Voice3_start	BIT	22h.2
	Voice4_start	BIT	22h.3
	Voice5_start	BIT	22h.4
	Voice6_start	BIT	22h.5
	Voice7_start	BIT	22h.6
	Voice8_start	BIT	22h.7
	Voice_ds	DATA	23h
	Voice1_ds	BIT	23h.0
	Voice2_ds	BIT	23h.1
	Voice3_ds	BIT	23h.2
	Voice4_ds	BIT	23h.3
	Voice5_ds	BIT	23h.4
	Voice6_ds	BIT	23h.5
	Voice7_ds	BIT	23h.6
	Voice8_ds	BIT	23h.7

	Voice_end_DCF	DATA	24h	;Flags für DCF ADSR
	Voice1_end_DCF	BIT	24h.0
	Voice2_end_DCF	BIT	24h.1
	Voice3_end_DCF	BIT	24h.2
	Voice4_end_DCF	BIT	24h.3
	Voice5_end_DCF	BIT	24h.4
	Voice6_end_DCF	BIT	24h.5
	Voice7_end_DCF	BIT	24h.6
	Voice8_end_DCF	BIT	24h.7
	Voice_start_DCF	DATA	25h
	Voice1_start_DCF BIT	25h.0
	Voice2_start_DCF BIT	25h.1
	Voice3_start_DCF BIT	25h.2
	Voice4_start_DCF BIT	25h.3
	Voice5_start_DCF BIT	25h.4
	Voice6_start_DCF BIT	25h.5
	Voice7_start_DCF BIT	25h.6
	Voice8_start_DCF BIT	25h.7
	Voice_ds_DCF	DATA	26h
	Voice1_ds_DCF	BIT	26h.0
	Voice2_ds_DCF	BIT	26h.1
	Voice3_ds_DCF	BIT	26h.2
	Voice4_ds_DCF	BIT	26h.3
	Voice5_ds_DCF	BIT	26h.4
	Voice6_ds_DCF	BIT	26h.5
	Voice7_ds_DCF	BIT	26h.6
	Voice8_ds_DCF	BIT	26h.7

	Voice1_Bank	BIT	27h.0	;=1 wenn Bank 2, =0 wenn Bank 1
	Voice2_Bank	BIT	27h.1	;=1 wenn Bank 2, =0 wenn Bank 1
	Voice1_PWM	BIT	27h.2	;=1 wenn Bank 3 für Voice1 mit PWM Daten eingeschaltet
	Voice2_PWM	BIT	27h.3	;=1 wenn Bank 3 für Voice2 mit PWM Daten eingeschaltet
	LOAD_EN		BIT	27h.4	;=1 wenn LOAD
	SAVE_EN		BIT	27h.5	;=1 wenn SAVE
	COPY_B1_EN	BIT	27h.6	;=1 wenn Bank1 nach extFlash2 0-31 kopiert werden soll
	COPY_EN		BIT	27h.7	;=1 wenn über MIDI CC angekommen ist, dass ext FLASH nach Bank1-3 kopiert werden soll

	midicmdf       	BIT  	28h.0 	;Flags für Midi	
	midi2nd        	BIT  	28h.1 
	midishort      	BIT  	28h.2
	midisysexdata	BIT	28h.3	
	BYTE_SENT	BIT	28h.4	;Flag für I2C Bus
	SM_BUSY		BIT	28h.5	;Flag für I2C Bus
	midi_send_flag	BIT	28h.6	;Flag für MIDI Senden	
	midi_send_flag2	BIT	28h.7	;Flag für MIDI Senden

	Start_LFO1	BIT	29h.0	;Bit wird 1 nach abgelaufener LFO1 Delay-Zeit
	Start_LFO2	BIT	29h.1	;Bit wird 1 nach abgelaufener LFO2 Delay-Zeit
	MidiCLKflag	BIT	29h.2	;Bit toggelt bei empfangener Midi Clock ($F8)
	MidiCLKflag_DCO1M BIT	29h.3	;Bit toggelt bei empfangener Midi Clock ($F8)
	MidiCLKflag_DCO2M BIT	29h.4	;Bit toggelt bei empfangener Midi Clock ($F8)
	MidiSyncDCO1MOD BIT	29h.5	;=1 wenn DCO1 Mod Midi Sync
	MidiSyncDCO2MOD BIT	29h.6	;=1 wenn DCO2 Mod Midi Sync
	voice23		BIT	29h.7

	ADSR2_DCF_flag	BIT	2Ah.0	;=1 wenn ADSR2 auf DCF wirkt 
	ADSR2_LFO1_flag BIT	2Ah.1	;=1 wenn ADSR2 auf LFO1 wirkt 
	ADSR2_LFO2_flag	BIT	2Ah.2	;=1 wenn ADSR2 auf LFO2 wirkt 
	velocity	BIT	2Ah.3	;wenn =1 dann Velocity On
	pitchbflag	BIT	2Ah.4	;wenn =1 dann Pitchbend wide +-24
	DCO2FINEFLAG	BIT	2Ah.5	;=1 wenn Finetuning > 0
	DCO1WaveInc_OneTime BIT	2Ah.6	;=1 wenn DCO1Mod OneTime sonst Loop
	DCO2WaveInc_OneTime BIT	2Ah.7	;

	DCO2FINELFO1FLAG BIT	2bh.0	;=1 wenn LFO1 auf DCO2FINE wirken soll
	DCO2FINELFO2FLAG BIT	2bh.1	;=1 wenn LFO2 auf DCO2FINE wirken soll
	MidiSyncLFO1	BIT	2bh.2	;=1 wenn LFO1 übewr Midi Clk gesynct wird
	MidiSyncLFO2	BIT	2bh.3	;=1 wenn LFO2 übewr Midi Clk gesynct wird
	ADSR1_INV_flag	BIT	2bh.4	;Flag für ADSR1 Invers
	ADSR1_LOG_flag	BIT	2bh.5	;Flag für ADSR1 Log
        ADSR2_INV_flag	BIT	2bh.6	;Flag für ADSR2 Invers
	ADSR2_LOG_flag	BIT	2bh.7	;Flag für ADSR2 Log

	Volume_Changed_DCO2LVOL	BIT	2ch.0	;=1 wenn über MIDI CC Volumedaten angekommen sind
	Volume_Changed_DCO2VOL	BIT	2ch.1	;=1 wenn über MIDI CC Volumedaten angekommen sind
	Volume_Changed_DCO1RVOL	BIT	2ch.2	;=1 wenn über MIDI CC Volumedaten angekommen sind
	Volume_Changed_DCO1VOL	BIT	2ch.3	;=1 wenn über MIDI CC Volumedaten angekommen sind
	EFX_Send_Changed	BIT	2ch.4	;=1 wenn über MIDI CC EFX Send angekommen sind
	EFX_Return_Changed	BIT	2ch.5	;=1 wenn über MIDI CC EFX Return angekommen sind
	Volume_LFO1_Changed	BIT	2ch.6	;=1 wenn über LFO1 Volume und Pan geändert werden sollen
	Volume_LFO2_Changed	BIT	2ch.7	;=1 wenn über LFO2 Volume und Pan geändert werden sollen

	midi_sysex_rcv_flag BIT	2dh.0	;Flag, dass Midi Sysex Daten angekommen sind (wenn F0 = 1, wenn F7 dann 0)
	rcv_midi_cc	BIT	2dh.1	;0=Midi CC dis, 1=Midi CC en
	DCO1FINELFO1FLAG BIT	2dh.2	;=1 wenn LFO1 auf DCO1FINE wirken soll
	DCO1FINELFO2FLAG BIT	2dh.3	;=1 wenn LFO2 auf DCO1FINE wirken soll
	DCO1FINEFLAG	BIT	2dh.4	;=1 wenn Finetuning > 0
	xor_on_off	BIT	2dh.5	;wenn 1 dann wird XOR auf das Samplebyte angewendet
        COPY_SD_EN	BIT	2dh.6	;=1 wenn Daten von SDCARD nach Bank 1,2 oder 3 kopiert werden sollen
        Midi_Multi_Mode_En BIT	2dh.7	;=1 wenn Midi Multi Mode aktiv ist

	arduino_pointer_L DATA	2eh
	arduino_pointer_H DATA	2fh

	Phase1_add_high	DATA 	30H	;DDS Phase high add
	Phase1_add_mid	DATA 	31H	;DDS Phase mid add
	Phase1_add_low	DATA 	32H 	;DDS Phase low add
	Phase1_acc_high	DATA	33h	;DDS Phase high byte
	Phase1_acc_mid	DATA	34h	;DDS Phase mid byte
	Phase1_acc_low	DATA	35h   	;DDS Phase low byte
	Phase2_add_high	DATA 	36H	;DDS Phase high add
	Phase2_add_mid	DATA 	37H	;DDS Phase mid add
	Phase2_add_low	DATA 	38H 	;DDS Phase low add
	Phase2_acc_high	DATA	39h	;DDS Phase high byte
	Phase2_acc_mid	DATA	3Ah	;DDS Phase mid byte
	Phase2_acc_low	DATA	3Bh   	;DDS Phase low byte
	Phase3_add_high	DATA 	3CH	;DDS Phase high add
	Phase3_add_mid	DATA 	3DH	;DDS Phase mid add
	Phase3_add_low	DATA 	3EH 	;DDS Phase low add
	Phase3_acc_high	DATA	3Fh	;DDS Phase high byte
	Phase3_acc_mid	DATA	40h	;DDS Phase mid byte
	Phase3_acc_low	DATA	41h   	;DDS Phase low byte
	Phase4_add_high	DATA 	42H	;DDS Phase high add
	Phase4_add_mid	DATA 	43H	;DDS Phase mid add
	Phase4_add_low	DATA 	44H 	;DDS Phase low add
	Phase4_acc_high	DATA	45h	;DDS Phase high byte
	Phase4_acc_mid	DATA	46h	;DDS Phase mid byte
	Phase4_acc_low	DATA	47h   	;DDS Phase low byte

	Phase5_add_high	DATA 	48H	;DDS Phase high add
	Phase5_add_mid	DATA 	49H	;DDS Phase mid add
	Phase5_add_low	DATA 	4aH 	;DDS Phase low add
	Phase5_acc_high	DATA	4bh	;DDS Phase high byte
	Phase5_acc_mid	DATA	4ch	;DDS Phase mid byte
	Phase5_acc_low	DATA	4dh   	;DDS Phase low byte
	Phase6_add_high	DATA 	4eH	;DDS Phase high add
	Phase6_add_mid	DATA 	4fH	;DDS Phase mid add
	Phase6_add_low	DATA 	50H 	;DDS Phase low add
	Phase6_acc_high	DATA	51h	;DDS Phase high byte
	Phase6_acc_mid	DATA	52h	;DDS Phase mid byte
	Phase6_acc_low	DATA	53h   	;DDS Phase low byte
	Phase7_add_high	DATA 	54H	;DDS Phase high add
	Phase7_add_mid	DATA 	55H	;DDS Phase mid add
	Phase7_add_low	DATA 	56H 	;DDS Phase low add
	Phase7_acc_high	DATA	57h	;DDS Phase high byte
	Phase7_acc_mid	DATA	58h	;DDS Phase mid byte
	Phase7_acc_low	DATA	59h   	;DDS Phase low byte
	Phase8_add_high	DATA 	5aH	;DDS Phase high add
	Phase8_add_mid	DATA 	5bH	;DDS Phase mid add
	Phase8_add_low	DATA 	5cH 	;DDS Phase low add
	Phase8_acc_high	DATA	5dh	;DDS Phase high byte
	Phase8_acc_mid	DATA	5eh	;DDS Phase mid byte
	Phase8_acc_low	DATA	5fh   	;DDS Phase low byte
	ADSR_Z2		DATA	60h	;Hilfsvariablen für ADSR
	ADSR_Z3		DATA	61h
	ADSR_Z5		DATA	62h
	DaL		DATA	63h	;Low Wert für D/A 
	DaH		DATA	64h	;High Wert für D/A 	
	DCO1_z1		DATA	65h	;Hilfbytes für DCO1 INC
	DCO1_z2		DATA	66h
	DCO1M_CLK_z1	DATA	67h	;Hilfsbyte für DCO1Mod Midi Sync
	DCO2M_CLK_z1	DATA	68h	;Hilfsbyte für DCO2Mod Midi Sync
	DCO1M_Tmp	DATA	69h	;Hilfsbyte für DCO1Mod INC Zähler
	DCO2M_Tmp	DATA	6Ah	;Hilfsbyte für DCO2Mod INC Zähler
	COMMAND		DATA	6Bh	;I2C
	HIGH_ADD	DATA	6Ch	;I2C
	LOW_ADD		DATA	6Dh	;I2C
	WORD		DATA	6Eh	;I2C
	BYTE_NUMBER	DATA	6Fh	;I2C
	
	ADSR1		DATA	70h	;ADSR Wert für Voice1
	ADSR2		DATA	71h
	ADSR3		DATA	72h
	ADSR4		DATA	73h
	Taste1		DATA	74h	;Midi Tastenwert für Voice 1 (0-127)	
	Taste2		DATA	75h
	Taste3		DATA	76h	
	Taste4		DATA	77h
	DaL2		DATA	78h	;Low Wert für D/A Voice 2
	DaH2		DATA	79h	;High Wert für D/A Voice 2
	midicmd        	DATA 	7Ah	;Midi CommandByte
	midibyte1      	DATA 	7Bh	;Midi Byte1
	midibyte2      	DATA	7Ch	;Midi Byte2
	PROGRAM		DATA	7Dh	;Programm-Nummer
	Voice_alt	DATA	7Eh	;

START:	MOV 	WDTCN, #0DEh
    	MOV 	WDTCN, #0ADh
	mov 	SP,#7Fh
	mov	EMI0CN,#0		;High Byte der Adresse

	MOV	Phase1_acc_low,#0	;Phase low Startwert
	MOV	Phase1_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase1_acc_high,#0	;Phase high Startwert
	MOV	Phase2_acc_low,#0	;Phase low Startwert
	MOV	Phase2_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase2_acc_high,#0	;Phase high Startwert
	MOV	Phase3_acc_low,#0	;Phase low Startwert
	MOV	Phase3_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase3_acc_high,#0	;Phase high Startwert
	MOV	Phase4_acc_low,#0	;Phase low Startwert
	MOV	Phase4_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase4_acc_high,#0	;Phase high Startwert
	MOV	Phase5_acc_low,#0	;Phase low Startwert
	MOV	Phase5_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase5_acc_high,#0	;Phase high Startwert
	MOV	Phase6_acc_low,#0	;Phase low Startwert
	MOV	Phase6_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase6_acc_high,#0	;Phase high Startwert
	MOV	Phase7_acc_low,#0	;Phase low Startwert
	MOV	Phase7_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase7_acc_high,#0	;Phase high Startwert
	MOV	Phase8_acc_low,#0	;Phase low Startwert
	MOV	Phase8_acc_mid,#0	;Phase mid Startwert	
	MOV	Phase8_acc_high,#0	;Phase high Startwert

	MOV	R0,#RESERVE
	mov	a,#0
	MOVX	@R0,a
	MOV	R0,#CHANNEL
	mov	a,#0			;Midi Kanal 1, Poly Mode default und kein XOR
	MOVX	@R0,a	
	MOV	R0,#DCO1Wave
	mov	a,#3			;DCO1Wave (0-127)
	MOVX	@R0,a
	MOV	R0,#DCO1WaveSave
	MOVX	@R0,a
	MOV	R0,#DCO1BANK		;DCO1 WAVETABLE BANK (0-2)
	MOV	A,#0			;Bank1								
	MOVX	@R0,A
	clr	Voice1_Bank
	clr	Voice1_PWM
	MOV	R0,#DCO1VOL
	mov	a,#100			;DCO1VOL (0-127)
	MOVX	@R0,a
	MOV	R0,#DCO1RVOL
	mov	a,#100			;DCO1RVOL (0-127)
	MOVX	@R0,a
	setb	Volume_Changed_DCO1RVOL
	setb	Volume_Changed_DCO1VOL
	mov	a,#255
	mov	r0,#DCO1GESVOL		;DCO1 Gesamtlautstärke für alle DCO1 Voices
	MOVX	@R0,a
	MOV	R0,#DCO1_INC_TIME	;DCO1INC TIME (1-255) 
	mov	a,#24
	MOVX	@R0,a
	MOV	DCO1_z1,a		;Zähler für DCO1_INC_TIME
	MOV	R0,#DCO1_INC_TIME_2	;DCO1 2.INC-Zeit 0-127 
	mov	a,#0			;maximale Verzögerung, 1=min
	MOVX	@R0,a
	MOV	DCO1_z2,a		;Zähler für DCO1_INC_TIME_2
	MOV	R0,#DCO1_WAVE_INC	;DCO1 INC-Wert 0-127
	mov	a,#0
	MOVX	@R0,a
	mov	DCO1M_Tmp,a
	mov	r0,#DCO1_INC_SYNC	;Keyboard Sync = OFF
	mov	a,#0
	movx	@r0,a
	mov	r0,#DCO1SCALE		;DCO1 -1, 0, +1 Oktave (244,0,12)
	mov	a,#0
	movx	@r0,a
	mov	r0,#DCO1LFO1		;DCO1 LFO1 auf 0
	mov	a,#0
	movx	@r0,a
	mov	r0,#DCO1LFO2		;DCO1 LFO2 auf 0
	mov	a,#0
	movx	@r0,a
	MOV	r0,#DCO1_INC_MIDI_SYNC	;DCO1 WAVE MOD MIDI SYNC = OFF
	MOV	a,#0					
	MOVX	@r0,a
	clr	MidiSyncDCO1MOD
	mov	r0,#DCO2NOISE		;Noise auf 0
	mov	a,#0
	movx	@r0,a
	mov	r0,#DCO1_INC_LOOP	;DCO1 INC im LOOP oder ONETIME
	movx	@r0,a
	clr 	DCO1WaveInc_OneTime	;DCO1 INC im LOOP

	mov	r0,#DCO1_INC_RESTART	;DCO1 MOD Restart off
	mov	a,#0
	movx	@r0,a

	MOV	R0,#DCO2Wave
	mov	a,#5			;DCO2Wave (0-127)
	MOVX	@R0,a
	MOV	R0,#DCO2WaveSave
	MOVX	@R0,a
	MOV	R0,#DCO2BANK		;DCO2 WAVETABLE BANK (0-2)
	MOV	A,#0			;Bank1
	movx	@R0,a
	clr	Voice2_Bank
	clr	Voice2_PWM
	MOV	R0,#DCO2VOL
	mov	a,#100			;DCO2RVOL (0-127)
	MOVX	@R0,a
	MOV	R0,#DCO2LVOL
	mov	a,#100			;DCO2LVOL (0-127)
	MOVX	@R0,a
	setb	Volume_Changed_DCO2LVOL
	setb	Volume_Changed_DCO2VOL
	mov	a,#255
	mov	r0,#DCO2GESVOL		;DCO2 Gesamtlautstärke für alle Voices
	MOVX	@R0,a
	MOV	R0,#DCO2_INC_TIME	;DCO2INC TIME (1-255)
	mov	a,#24
	MOVX	@R0,a
	MOV	DCO2_z1,a		;Zähler für DCO2_INC_TIME
	MOV	R0,#DCO2_INC_TIME_2	;DCO2 2.INC-Zeit 0-127 
	mov	a,#0			;maximale Verzögerung, 1=min
	MOVX	@R0,a
	MOV	DCO2_z2,a		;Zähler für DCO2_INC_TIME_2
	mov	r0,#DCO2SCALE		;DCO2 -1, 0, +1 Oktave (244,0,12)
	mov	a,#0
	movx	@r0,a
	MOV	R0,#DCO2_WAVE_INC	;DCO2 INC-Wert 0-127
	mov	a,#0
	MOVX	@R0,a
	mov	DCO2M_Tmp,a
	mov	r0,#DCO2_INC_SYNC	;Keyboard Sync = OFF
	mov	a,#0
	movx	@r0,a
	mov	r0,#DCO2LFO1		;DCO2 LFO1 auf 0
	mov	a,#0
	movx	@r0,a
	mov	r0,#DCO2LFO2		;DCO2 LFO2 auf 0
	mov	a,#0
	movx	@r0,a
	MOV	r0,#DCO2_INC_MIDI_SYNC	;DCO2 WAVE MOD MIDI SYNC = OFF
	MOV	a,#0					
	MOVX	@r0,a
	clr	MidiSyncDCO2MOD
	mov	r0,#DCO2_INC_LOOP	;DCO2 INC im LOOP oder ONETIME
	movx	@r0,a
	clr 	DCO2WaveInc_OneTime

	mov	r0,#DCO2_INC_RESTART	;DCO2 MOD Restart off
	mov	a,#0
	movx	@r0,a

	mov	r0,#DCO1FINE		;DCO1 Finetuning = 64 = +/-0
	mov	a,#64
	movx	@r0,a
	clr	DCO1FINEFLAG
	mov	r0,#DCO1FINELFO1	;DCO1 LFO1 auf 0
	mov	a,#0
	movx	@r0,a
	clr	DCO1FINELFO1FLAG
	mov	r0,#DCO1FINELFO2	;DCO1 LFO2 auf 0
	mov	a,#0
	movx	@r0,a
	clr	DCO1FINELFO2FLAG

	mov	r0,#DCO2FINE		;DCO2 Finetuning = 64 = +/-0
	mov	a,#64
	movx	@r0,a
	clr	DCO2FINEFLAG
	mov	r0,#DCO2FINELFO1	;DCO2 LFO1 auf 0
	mov	a,#0
	movx	@r0,a
	clr	DCO2FINELFO1FLAG
	mov	r0,#DCO2FINELFO2	;DCO2 LFO2 auf 0
	mov	a,#0
	movx	@r0,a
	clr	DCO2FINELFO2FLAG

	mov	r0,#MODWHEELTAR		;Modwheel = DCF
	mov	a,#1
	movx	@r0,a

	MOV	R0,#LFO1DELAY		;LFO1 Delay
	mov	a,#1			;1=min, 0=max			
	MOVX	@R0,a
	MOV	LFO1_z2,a		;Zähler für LFO1 Delay
	clr	Start_LFO1		;Bit wird 1 nach Delay
	mov	LFO1_z4,#0

	MOV	R0,#LFO2DELAY		;LFO2 Delay
	mov	a,#1			;1=min, 0=max			
	MOVX	@R0,a
	MOV	LFO2_z2,a		;Zähler für LFO2 Delay
	clr	Start_LFO2		;Bit wird 1 nach Delay
	mov	LFO2_z4,#0

	mov	ADSR_Z,#3		;ADSR Time Verlängerung

	MOV	R0,#ATTACK
	mov	a,#1			;DCA ATTACK (1-255)
	MOVX	@R0,a
	MOV	ADSR_Z3,a		;Zähler für Attack Wert
	MOV	R0,#DECAY
	mov	a,#45			;DCA DECAY (1-255)
	MOVX	@R0,a
	MOV	ADSR_Z5,a		;Zähler für Decay Wert
	MOV	R0,#SUSTAIN
	mov	a,#255			;DCA SUSTAIN (1-255)
	MOVX	@R0,a
	MOV	R0,#RELEASE		;DCA RELEASE (1-255)
	mov	a,#12
	MOVX	@R0,a			
	MOV	ADSR_Z2,a		;Zähler für Release Wert
	MOV	R0,#ADSR1_INV		;ADSR1 NORM/INV = NORM
	MOV	A,#0									
	MOVX	@R0,A
	clr	ADSR1_INV_flag
	MOV	R0,#ADSR1_LOG		;ADSR1 LIN/LOG = LIN
	MOV	A,#0									
	MOVX	@R0,A
	clr	ADSR1_LOG_flag

	mov	r0,#PITCHB		;PITCHBEND (0-127)
	mov	a,#0
	movx	@r0,a			

	MOV	r0,#DCFFREQ		;DigFilter mit "kein Filter" voreinstellen
	mov	a,#255
	MOvX	@r0,a					
	MOV	r0,#DCFRESO		;DigFilter mit "keine Resonanz" voreinstellen		
	mov	a,#0
	movx	@r0,a
	MOV	r0,#DCFLFO1		;Stärke des LFO1 auf DCF
	mov	a,#0
	movx	@r0,a
	MOV	r0,#DCFLFO2		;Stärke des LFO2 auf DCF
	mov	a,#0
	movx	@r0,a
	MOV	R0,#ADSR2_INV		;ADSR2 NORM/INV = NORM
	MOV	A,#0									
	MOVX	@R0,A
	clr	ADSR2_INV_flag
	MOV	R0,#ADSR2_LOG		;ADSR2 LIN/LOG = LIN
	MOV	A,#0									
	MOVX	@R0,A
	clr	ADSR2_LOG_flag

	MOV	R0,#DCFATTACK		;DCF ATTACK (1-255)
	mov	a,#1		
	movx	@r0,a	
	MOV	ADSR_DCF_Z3,a		;Zähler für DCF Attack Wert
	MOV	R0,#DCFDECAY		;DCF DECAY (1-255)
	mov	a,#1			
	movx	@r0,a	
	MOV	ADSR_DCF_Z5,a		;Zähler für DCF Decay Wert
	MOV	R0,#DCFSUSTAIN		;DCF SUSTAIN (1-255)
	mov	a,#255			
	movx	@r0,a
	MOV	R0,#DCFRELEASE		;DCF RELEASE (1-255)
	mov	a,#1			
	movx	@r0,a	
	MOV	ADSR_DCF_Z2,a		;Zähler für DCF Release Wert						

	MOV	R0,#LFO1RATE		;LFO1 RATE (1-255) = (IRQ Time / 95)
	mov	a,#95			
	movx	@r0,a
	mov	LFO1_z1,a		;Zähler für LFO1
	MOV	R0,#LFO1WAVE		;LFO1 WAVE (0-127)
	mov	a,#7			;(0-7) 7=SAW-
	movx	@r0,a
	mov	r0,#LFO1RANGE
	mov	a,#1
	movx	@r0,a
	mov	LFO1_z3,a
	mov	r0,#LFO1KYB		;Keyb Sync default = off
	mov	a,#0
	movx	@r0,a
	mov	r0,#LFO1_CLK		;LFO1 Midi Clock Rate (1/4 = default)
	mov	a,#0
	movx	@r0,a
        mov	LFO1_CLK_z1,a
	clr	MidiSyncLFO1

	MOV	R0,#LFO2RATE		;LFO2 RATE (1-255) = (IRQ Time / 95)
	mov	a,#95			
	movx	@r0,a
	mov	LFO2_z1,a		;Zähler für LFO2
	MOV	R0,#LFO2WAVE		;LFO1 WAVE (0-127)
	mov	a,#7			;(0-7) 7=SAW-
	movx	@r0,a
	mov	r0,#LFO2RANGE
	mov	a,#1
	movx	@r0,a
	mov	LFO2_z3,a
	mov	r0,#LFO2KYB		;Keyb Sync default = off
	mov	a,#0
	movx	@r0,a
	mov	r0,#LFO2_CLK		;LFO2 Midi Clock Rate (1/4 = default)
	mov	a,#0
	movx	@r0,a
        mov	LFO2_CLK_z1,a
	clr	MidiSyncLFO2

	MOV	r0,#DCALFO1		;Stärke des LFO1 auf DCA
	mov	a,#0
	movx	@r0,a
	MOV	r0,#DCALFO2		;Stärke des LFO2 auf DCA
	mov	a,#0
	movx	@r0,a

	MOV	r0,#RANDOM_LFO1		;Anfangswert für Random setzen
	mov	a,#55
	movx	@r0,a
	MOV	r0,#RANDOM_LFO2		;Anfangswert für Random setzen
	movx	@r0,a
	MOV	r0,#RANDOM_NOISE	;Anfangswert für Random setzen
	movx	@r0,a		

	mov	a,#0ffh
	mov	r0,#ANSCHLAGDYN
	movx	@r0,a
	mov	r0,#ANSCHLAGDYN+1
	movx	@r0,a
	mov	r0,#ANSCHLAGDYN+2
	movx	@r0,a
	mov	r0,#ANSCHLAGDYN+3
	mov	r0,#VELO		;Velocity = OFF (0=OFF, 1=ON)
	mov	a,#0			
	MOVX	@R0,A	
	clr	velocity		;Velocity default = OFF
	MOV	r0,#RINGMOD		;Ringmodulation (0=OFF, 1=ON)
	mov	a,#0			
	MOVX	@R0,A
	mov	r0,#VELOKURVE		;Velocity Kurven (0-3)
	mov	a,#1			;1=Log1
	MOVX	@R0,A	
	clr	pitchbflag		;Pitchbend normal

	MOV	r0,#EFXSEND
	mov	a,#0
	movx	@r0,a
	setb	EFX_Send_Changed

	MOV	r0,#EFXRETURN
	movx	@r0,a
	setb	EFX_Return_Changed
	MOV	r0,#EFXTYPE
	movx	@r0,a
	MOV	r0,#EFX_A
	movx	@r0,a
	MOV	r0,#EFX_B
	movx	@r0,a
	MOV	r0,#EFX_C
	movx	@r0,a
	MOV	r0,#EFXLFO1		;Wirkung des LFO1 auf das EFX
	mov	a,#0
	movx	@r0,a
	MOV	r0,#EFXLFO2
	movx	@r0,a
	MOV	r0,#EFXLFO1TAR		;Ziel des LFO1 (Off, A, B, C)
	movx	@r0,a
	MOV	r0,#EFXLFO2TAR
	movx	@r0,a
	
	MOV	Voice,#0
	mov	voice_start,#0		;Flags für Taste gedrückt und Start der Attack-Phase
	mov	voice_ds,#0		;Flags für Start der Sustain/Decay-Phase
	MOV	voice_end,#0		;Flags für Taste losgelassen und Start des Release-Phase	
	MOV	ADSR1,#0h		;DCA ADSR mit 0 voreinstellen
	MOV	ADSR2,#0h
	MOV	ADSR3,#0h
	MOV	ADSR4,#0h

	mov	voice_start_DCF,#0	;Flags für Taste gedrückt und Start der DCF Attack-Phase
	mov	voice_ds_DCF,#0		;Flags für Start der DCF Sustain/Decay-Phase
	MOV	voice_end_DCF,#0	;Flags für Taste losgelassen und Start der DCF Release-Phase	
	MOV	ADSR1_DCF,#02h		;DCF ADSR mit 02 voreinstellen
	MOV	ADSR2_DCF,#02h
	MOV	ADSR3_DCF,#02h
	MOV	ADSR4_DCF,#02h

	setb	ADSR2_DCF_flag		;Target für ADSR2 = DCF default
	clr	ADSR2_LFO1_flag
	clr	ADSR2_LFO2_flag

	clr 	midicmdf
	clr	midisysexdata	
	clr	MidiCLKflag		;Bit toggelt bei empfangener Midi Clock
	clr	midi_sysex_rcv_flag	;Flag für Midi Sysex (F0=1, F7=0)
	mov	sysex_bytes_count,#0	;Zähler für angekommene Sysex Daten
	;setb	rcv_midi_cc		;0=Midi CC dis, 1=Midi CC en
	clr 	rcv_midi_cc		;0=Midi CC dis, 1=Midi CC en
	clr	Midi_Multi_Mode_En	;Midi Multi Mode = dis

	clr	voice23

	LCALL	Init_Device
	clr	YELLOW_LED
	clr	GREEN_LED
	clr	RED_LED
	clr	SM_BUSY	
	clr	LOAD_EN
	clr	SAVE_EN
	mov	PROGRAM,#0

	clr	Volume_LFO1_Changed
	clr	Volume_LFO2_Changed
	clr	COPY_SD_EN
	mov	FLASH_BANK_SOURCE,#02h	;FLASH 2 (Samples/Wavetables 0-127)	
	mov	FLASH_SOURCE,#0		;Daten für Bank1 liegen hier
	mov	BANK_TARGET,#0		;Bank1
	clr	COPY_EN 
	clr	COPY_B1_EN

	mov	a,#0ffh
	mov	r0,#BANK1BANKCONTENT	
	movx	@r0,a
	mov	r0,#BANK1CONTENT	
	movx	@r0,a
	mov	r0,#BANK2BANKCONTENT	
	movx	@r0,a
	mov	r0,#BANK2CONTENT		
	movx	@r0,a
	mov	r0,#BANK3BANKCONTENT	
	movx	@r0,a
	mov	r0,#BANK3CONTENT		
	movx	@r0,a

	call	EEPROM_Read_PROGRAM_Value	;Hole letzten gewählten Programmplatz
	call	EEPROM_Read_Program		;hole letzte Einstellung aus EEPROM und speichere ins RAM	

	call	SST25VF020_Init			;FLASH1 Initialisieren und ID auslesen
	call	SST25VF020_ReadID				
	call	SST25VF020_Init_2		;FLASH2 Initialisieren und ID auslesen
	call	SST25VF020_ReadID_2

	clr	midi_send_flag		;Flag für MIDI Senden
	mov	midi_send_bytes,#0	;Anzahl der per MIDI zu sendenden Bytes

Loop:
	jnb	Volume_Changed_DCO2LVOL,no_Volume_Changed_DCO2LVOL
	mov	a,#02h				;CH2
	call	Select_I2C_PT2257
	MOV	R0,#DCO2LVOL			;DCO2 Left Volume		
	MOVX	a,@R0
	call	PT2257_Set_Volume_Left
	clr	Volume_Changed_DCO2LVOL
no_Volume_Changed_DCO2LVOL:
	jnb	Volume_Changed_DCO2VOL,no_Volume_Changed_DCO2VOL
	mov	a,#02h				;CH2
	call	Select_I2C_PT2257
	MOV	R0,#DCO2VOL			;DCO2 Right Volume		
	MOVX	a,@R0
	call	PT2257_Set_Volume_Right
	clr	Volume_Changed_DCO2VOL
no_Volume_Changed_DCO2VOL:
	jnb	Volume_Changed_DCO1RVOL,no_Volume_Changed_DCO1RVOL
	mov	a,#01h				;CH1
	call	Select_I2C_PT2257
	MOV	R0,#DCO1RVOL			;DCO1 Right Volume			
	MOVX	a,@R0
	call	PT2257_Set_Volume_Right
	clr	Volume_Changed_DCO1RVOL
no_Volume_Changed_DCO1RVOL:
	jnb	Volume_Changed_DCO1VOL,no_Volume_Changed
	mov	a,#01h				;CH1
	call	Select_I2C_PT2257
	MOV	R0,#DCO1VOL			;DCO1 Left Volume			
	MOVX	a,@R0
	call	PT2257_Set_Volume_Left
	clr	Volume_Changed_DCO1VOL

no_Volume_Changed:
	jnb	EFX_Send_Changed,no_EFX_Send_Changed
	mov	a,#04h				;CH3
	call	Select_I2C_PT2257
	MOV	r0,#EFXSEND
	movx	a,@r0
	push	acc
	call	PT2257_Set_Volume
	mov	a,#08h				;CH4
	call	Select_I2C_PT2257
	pop	acc
	call	PT2257_Set_Volume
	clr	EFX_Send_Changed
	jmp	no_EFX_Send_Changed

no_Volume_LFO1_Changed_hlp:
	ljmp	no_Volume_LFO1_Changed

no_EFX_Send_Changed:
	jnb	Volume_LFO1_Changed,no_Volume_LFO1_Changed_hlp
	mov	a,#01h				;CH1
	call	Select_I2C_PT2257
	mov	r0,#DCALFO1VAL			;LFO1
	movx	a,@r0
	push	acc
	mov	b,a
	mov	r0,#DCALFO1			;LFO1*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO1VOL			;LFO1*(0-127) + DCO1 Left Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0				;a = 127-DCO1VOL (max Wert für LFO)
	cjne	a,01h,$+3			;a=127-DCO1VOL, r1=DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_1		;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten, Begrenzung des LFO-max-Wert auf 127-DCO1VOL
	jmp	no_EFX_Return_Changed_2
no_EFX_Return_Changed_1:
	mov	b,r1
no_EFX_Return_Changed_2:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Left
	pop	acc
	cpl	a				;LFO1 negieren
	mov	b,a
	mov	r0,#DCALFO1			;LFO1*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO1RVOL			;LFO1*(0-127) + DCO1 Right Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0	
	cjne	a,01h,$+3			;a=127-DCO1RVOL, r1=/DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_3		;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten
	jmp	no_EFX_Return_Changed_4
no_EFX_Return_Changed_3:
	mov	b,r1
no_EFX_Return_Changed_4:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Right
	mov	a,#02h				;CH2
	call	Select_I2C_PT2257
	mov	r0,#DCALFO1VAL			;LFO1
	movx	a,@r0
	push	acc
	mov	b,a
	mov	r0,#DCALFO1			;LFO1*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO2VOL			;LFO1*(0-127) + DCO2 Right Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0	
	cjne	a,01h,$+3			;a=127-DCO2VOL, r1=DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_5		;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten
	jmp	no_EFX_Return_Changed_6
no_EFX_Return_Changed_5:
	mov	b,r1
no_EFX_Return_Changed_6:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Left
	pop	acc
	cpl	a				;LFO1 negieren
	mov	b,a
	mov	r0,#DCALFO1			;LFO1*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO2LVOL			;LFO1*(0-127) + DCO2 Left Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0		
	cjne	a,01h,$+3			;a=127-DCO2LVOL, r1=/DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_7		;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten
	jmp	no_EFX_Return_Changed_8
no_EFX_Return_Changed_7:
	mov	b,r1
no_EFX_Return_Changed_8:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Right
	jmp	no_Volume_LFO1_Changed

no_Volume_LFO2_Changed_hlp:
	ljmp	no_Volume_LFO2_Changed
no_Volume_LFO1_Changed:
	jnb	Volume_LFO2_Changed,no_Volume_LFO2_Changed_hlp
	mov	a,#01h				;CH1
	call	Select_I2C_PT2257
	mov	r0,#DCALFO2VAL			;LFO2
	movx	a,@r0
	push	acc
	mov	b,a
	mov	r0,#DCALFO2			;LFO2*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO1VOL			;LFO2*(0-127) + DCO1 Left Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0				;a = 127-DCO1VOL (max Wert für LFO)
	cjne	a,01h,$+3			;a=127-DCO1VOL, r1=DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_9		;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten, Begrenzung des LFO-max-Wert auf 127-DCO1VOL
	jmp	no_EFX_Return_Changed_10
no_EFX_Return_Changed_9:
	mov	b,r1
no_EFX_Return_Changed_10:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Left
	pop	acc
	cpl	a				;LFO2 negieren
	mov	b,a
	mov	r0,#DCALFO2			;LFO2*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO1RVOL			;LFO2*(0-127) + DCO1 Right Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0	
	cjne	a,01h,$+3			;a=127-DCO1RVOL, r1=/DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_11	;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten
	jmp	no_EFX_Return_Changed_12
no_EFX_Return_Changed_11:
	mov	b,r1
no_EFX_Return_Changed_12:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Right
	mov	a,#02h				;CH2
	call	Select_I2C_PT2257
	mov	r0,#DCALFO2VAL			;LFO2
	movx	a,@r0
	push	acc
	mov	b,a
	mov	r0,#DCALFO2			;LFO2*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO2VOL			;LFO2*(0-127) + DCO2 Right Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0	
	cjne	a,01h,$+3			;a=127-DCO2VOL, r1=DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_13	;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten
	jmp	no_EFX_Return_Changed_14
no_EFX_Return_Changed_13:
	mov	b,r1
no_EFX_Return_Changed_14:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Left
	pop	acc
	cpl	a				;LFO2 negieren
	mov	b,a
	mov	r0,#DCALFO2			;LFO2*(0-127)
	movx	a,@r0
	mul	ab
	mov	r1,b
	MOV	r0,#DCO2LVOL			;LFO2*(0-127) + DCO2 Left Volume			
	MOVX	a,@r0
	mov	r0,a
	mov	a,#127
	clr	c
	subb	a,r0		
	cjne	a,01h,$+3			;a=127-DCO2LVOL, r1=/DCALFO1VAL*DCALFO1
	jnc	no_EFX_Return_Changed_15	;wenn a>=r1 dann normal weiter
	mov	b,a				;wenn a<r1 dann wurde max-Wert überschritten
	jmp	no_EFX_Return_Changed_16
no_EFX_Return_Changed_15:
	mov	b,r1
no_EFX_Return_Changed_16:
	mov	a,r0
	add	a,b
	anl	a,#01111111b
	call	PT2257_Set_Volume_Right

no_Volume_LFO2_Changed:
	jnb	LOAD_EN,no_LOAD
	mov  	SFRPAGE,#UART1_PAGE
	clr	REN1				;Midi Receive dis
	call	PT2257_Set_Mute_On
	clr	ET0
	clr	ET1
	clr	ET2
	clr	ET3
	call	EEPROM_Read_Program
	call	EEPROM_Write_PROGRAM_Value	;Speichere aktuelles PROGRAM im EEPROM ($00ffh)
	setb	midi_send_flag2			;Flag enabled setb TI1
	call	XRAM2MIDI			;Sende XRAM 02h-53h an MIDI OUT
	clr	LOAD_EN
	setb	ET0
	setb	ET1
	setb	ET2
	setb	ET3
	call	PT2257_Set_Mute_Off
	mov  	SFRPAGE,#UART1_PAGE
	setb	REN1
no_LOAD:
	jnb	SAVE_EN,no_SAVE
	call	EEPROM_Write_Program
	call	EEPROM_Write_PROGRAM_Value	;Speichere aktuelles PROGRAM im EEPROM ($00ffh)
	clr	SAVE_EN
no_SAVE:
	jnb	COPY_EN,no_COPY
	call	PT2257_Set_Mute_On
	call	Copy_Flash2Bank
	call	PT2257_Set_Mute_Off
	clr	COPY_EN
no_COPY:
	jnb	COPY_SD_EN,no_COPY_SD_EN
	call	Copy_SDCARD2Bank
	clr	COPY_SD_EN

no_COPY_SD_EN:
	jnb	COPY_B1_EN,no_COPY_B1_EN
	call	Copy_Bank1_to_extFlash
	clr	COPY_B1_EN

no_COPY_B1_EN:
	jmp	Loop


;******************************************************************************************************
; DCO 2
;******************************************************************************************************

VOICE2_IRQ:
	push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push	00
	push	01
	
	jnb	Voice2_PWM,VOICE2_IRQ_1	
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#30h			;Bank3 = PWM einschalten
	mov	PSBANK,a
	jmp	VOICE2_IRQ_3
VOICE2_IRQ_1:
	jnb	Voice2_Bank,VOICE2_IRQ_2
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#20h			;Bank2
	mov	PSBANK,a
	jmp	VOICE2_IRQ_3
VOICE2_IRQ_2:
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#10h			;Bank1
	mov	PSBANK,a	
VOICE2_IRQ_3:

	jb	DCO2FINELFO1FLAG,LFO_DCO2FINE
	jb	DCO2FINELFO2FLAG,LFO_DCO2FINE
	jb	DCO2FINEFLAG,LFO_DCO2FINE
	jmp	no_LFO_DCO2FINE

LFO_DCO2FINE:
	mov	r0,#DCO2FINELFO1VAL	;DCO2 LFO1
	movx	a,@r0
	clr	c
	rrc	a			;0-63
	mov	b,a
	mov	r0,#DCO2FINELFO2VAL	;DCO2 LFO2
	movx	a,@r0
	clr	c
	rrc	a			;0-63
	add	a,b
	mov	b,a
	mov	r0,#DCO2FINE		;DCO2 Finetuning
	movx	a,@r0
	add	a,b			;+ 0-127 (64 für kein Feintuning)
	anl	a,#01111111b

	mov	dptr,#DCO_PITCH_TAB
	movc	a,@a+dptr
	mov  	SFRPAGE,#TMR3_PAGE
    	mov  	TMR3CN,#0h		;Timer 3 DIS
    	mov  	SFRPAGE,#TMR3_PAGE
    	mov  	TMR3CF,#008h
    	mov  	RCAP3L,a		;Abtastrate für DCO2
    	mov  	RCAP3H,#0f5h
	mov  	TMR3CN,#04h		;Timer 3 EN

	clr	DCO2FINELFO1FLAG
	clr	DCO2FINELFO2FLAG
	clr	DCO2FINEFLAG

no_LFO_DCO2FINE:
	MOV	DaL2,#0			
	MOV	DaH2,#0

	mov	r0,#PITCHB		;Pitchbend Wert	
	movx	a,@r0
	mov	b,a

	mov	r0,#DCO2SCALE		;-1, 0, +1 Oktave (244,0,12)
	movx	a,@r0
	mov	r0,a
	add	a,b			;PitchbendWert+Oktave
	mov	b,a
	mov	r0,#DCO2LFO1VAL
	movx	a,@r0
	add	a,b			;PitchbendWert+Oktave+LFO1
	mov	b,a
	mov	r0,#DCO2LFO2VAL
	movx	a,@r0
	add	a,b			;PitchbendWert+Oktave+LFO1+LFO2
	mov	r0,#DCO2PITCHVAL	;=PitchbendWert+Oktave+LFO1+LFO2 für die Voices
	movx	@r0,a
	JB	Voice1,Play_Voice5
	JMP	Check_Voice6
Play_Voice5:	
        mov 	dptr,#wavetable      	;get value from table
	mov	r0,#DCO2Wave
	movx	a,@r0
	add	a,dph			;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase5_acc_high	;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice5_XOR_off
	xrl	a,#80h
Play_Voice5_XOR_off:
	push	acc
	mov	r0,#DCO2GESVOL		;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc
	mul	ab			;*Lautstärke			
	mov	a,ADSR1			;*Hüllkurve
	jnb	ADSR1_INV_flag,PV5_no_change_ADSR_1
	cpl	a			;Invers Hüllkurve
PV5_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV5_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV5_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN	        ;*Anschlagdyn
	movx	a,@r0
	mul	ab

	push	b			;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+4		
	movx	a,@r0
	mul	ab			;=DCFRESO*OUT_BUFF
	pop	acc			;IN zurück holen
	add	a,b			;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V5_no_ADSR_DCF
	mov	a,ADSR1_DCF		;DCF ADSR
	jnb	ADSR2_INV_flag,PV5_no_change_ADSR_3
	cpl	a			;Invers Hüllkurve
PV5_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV5_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV5_no_change_ADSR_4:
	mul	ab			;=DCF ADSR * Frequenz + LFO1 + LFO2
V5_no_ADSR_DCF:
	mov	r0,b			;DCFGESFREQ
	pop	acc			;IN + DCFRESO*OUT_BUFF
	mul	ab			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0			;DCFGESFREQ		
	cpl	a			;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+4		;OUT_BUFF
	movx	a,@r0			;OUT_BUFF holen
	mul	ab			;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b			;
	pop	b			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b			;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a			;neuen Wert sichern
	
	add	a,DaL2
	MOV	DaL2,a
	clr	a
	addc	a,Dah2
	MOV	DaH2,a

	mov	r0,#DCO2PITCHVAL	;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE1		;+Tastenwert hinzu addieren
	clr	acc.7			;Werte von 0-127 zulassen
	push	acc 

	MOV	DPTR,#Phase_H		;
	MOVC	A,@A+DPTR
	MOV	Phase5_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		;
	MOVC	A,@A+DPTR
	MOV	Phase5_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		;
	MOVC	A,@A+DPTR
	MOV	Phase5_add_low,A

	MOV	A,Phase5_acc_low	;speichere Phasenwerte
        ADD	A,Phase5_add_low
	MOV	Phase5_acc_low,A	;neue Phase low-byte
	MOV	A,Phase5_acc_mid
        ADDC	A,Phase5_add_mid
	MOV	Phase5_acc_mid,A	;neue Phase mid-byte
	MOV	A,Phase5_acc_high
	ADDC	A,Phase5_add_high	
	MOV	Phase5_acc_high,A	;neue Phase high-byte

Check_Voice6:
	JB	Voice2,Play_Voice6
	JMP	Check_Voice7
Play_Voice6:	
        mov 	dptr,#wavetable      	;get value from table
	mov	r0,#DCO2Wave
	movx	a,@r0
	add	a,dph			;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase6_acc_high	;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice6_XOR_off
	xrl	a,#80h
Play_Voice6_XOR_off:
	push	acc
	mov	r0,#DCO2GESVOL		;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc
	mul	ab			;*Lautstärke			
	mov	a,ADSR2			;*Hüllkurve
	jnb	ADSR1_INV_flag,PV6_no_change_ADSR_1
	cpl	a			;Invers Hüllkurve
PV6_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV6_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV6_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN+1	;*Anschlagdyn
	movx	a,@r0
	mul	ab

	push	b			;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+5		
	movx	a,@r0
	mul	ab			;=DCFRESO*OUT_BUFF
	pop	acc			;IN zurück holen
	add	a,b			;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V6_no_ADSR_DCF
	mov	a,ADSR2_DCF		;DCF ADSR
	jnb	ADSR2_INV_flag,PV6_no_change_ADSR_3
	cpl	a			;Invers Hüllkurve
PV6_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV6_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV6_no_change_ADSR_4:
	mul	ab			;=DCF ADSR * Frequenz + LFO1 + LFO2
V6_no_ADSR_DCF:
	mov	r0,b			;DCFGESFREQ
	pop	acc			;IN + DCFRESO*OUT_BUFF
	mul	ab			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0			;DCFGESFREQ		
	cpl	a			;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+5		;OUT_BUFF
	movx	a,@r0			;OUT_BUFF holen
	mul	ab			;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b			;
	pop	b			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b			;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a			;neuen Wert sichern
	
	add	a,DaL2
	MOV	DaL2,a
	clr	a
	addc	a,Dah2
	MOV	DaH2,a

	mov	r0,#DCO2PITCHVAL	;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE2		;+Tastenwert hinzu addieren
	clr	acc.7			;Werte von 0-127 zulassen
	push	acc 

	MOV	DPTR,#Phase_H		;
	MOVC	A,@A+DPTR
	MOV	Phase6_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		;
	MOVC	A,@A+DPTR
	MOV	Phase6_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		;
	MOVC	A,@A+DPTR
	MOV	Phase6_add_low,A

	MOV	A,Phase6_acc_low	;speichere Phasenwerte
        ADD	A,Phase6_add_low
	MOV	Phase6_acc_low,A	;neue Phase low-byte
	MOV	A,Phase6_acc_mid
        ADDC	A,Phase6_add_mid
	MOV	Phase6_acc_mid,A	;neue Phase mid-byte
	MOV	A,Phase6_acc_high
	ADDC	A,Phase6_add_high	
	MOV	Phase6_acc_high,A	;neue Phase high-byte

Check_Voice7:
	JB	Voice3,Play_Voice7
	JMP	Check_Voice8
Play_Voice7:	
        mov 	dptr,#wavetable      		;get value from table
	mov	r0,#DCO2Wave			;dynamischer DCO2-Wert
	movx	a,@r0
	add	a,dph				;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase7_acc_high		;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice7_XOR_off
	xrl	a,#80h
Play_Voice7_XOR_off:
	push	acc
	mov	r0,#DCO2GESVOL			;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc	
	mul	ab				;*Lautstärke
	mov	a,ADSR3
	jnb	ADSR1_INV_flag,PV7_no_change_ADSR_1
	cpl	a				;Invers Hüllkurve
PV7_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV7_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr			;Log Hüllkurve
PV7_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN+2		;*Anschlagdyn
	movx	a,@r0
	mul	ab

	push	b				;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+6		
	movx	a,@r0
	mul	ab				;=DCFRESO*OUT_BUFF
	pop	acc				;IN zurück holen
	add	a,b				;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0				;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V7_no_ADSR_DCF
	mov	a,ADSR3_DCF			;DCF ADSR
	jnb	ADSR2_INV_flag,PV7_no_change_ADSR_3
	cpl	a				;Invers Hüllkurve
PV7_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV7_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr			;Log Hüllkurve
PV7_no_change_ADSR_4:
	mul	ab				;=DCF ADSR * Frequenz + LFO1 + LFO2
V7_no_ADSR_DCF:
	mov	r0,b				;DCFGESFREQ
	pop	acc				;IN + DCFRESO*OUT_BUFF
	mul	ab				;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0				;DCFGESFREQ		
	cpl	a				;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+6			;OUT_BUFF
	movx	a,@r0				;OUT_BUFF holen
	mul	ab				;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b				;
	pop	b				;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b				;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a				;neuen Wert sicher
	
	add	a,DaL2
	MOV	DaL2,a
	clr	a
	addc	a,Dah2
	MOV	DaH2,a

	mov	r0,#DCO2PITCHVAL		;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE3			;+Tastenwert hinzu addieren
	clr	acc.7				;Werte von 0-127 zulassen
	push	acc 

	MOV	DPTR,#Phase_H		
	MOVC	A,@A+DPTR
	MOV	Phase7_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		
	MOVC	A,@A+DPTR
	MOV	Phase7_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		
	MOVC	A,@A+DPTR
	MOV	Phase7_add_low,A

	MOV	A,Phase7_acc_low		;speichere Phasenwerte
        ADD	A,Phase7_add_low
	MOV	Phase7_acc_low,A		;neue Phase low-byte
	MOV	A,Phase7_acc_mid
        ADDC	A,Phase7_add_mid
	MOV	Phase7_acc_mid,A		;neue Phase mid-byte
	MOV	A,Phase7_acc_high
	ADDC	A,Phase7_add_high	
	MOV	Phase7_acc_high,A		;neue Phase high-byte

Check_Voice8:
	JB	Voice4,Play_Voice8
	JMP	DCO2_Ende
Play_Voice8:	
        mov 	dptr,#wavetable      		;get value from table
	mov	r0,#DCO2Wave			;dynamischer DCO2-Wert
	movx	a,@r0
	add	a,dph				;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase8_acc_high		;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice8_XOR_off
	xrl	a,#80h
Play_Voice8_XOR_off:
	push	acc
	mov	r0,#DCO2GESVOL			;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc	
	mul	ab
	mov	a,ADSR4
	jnb	ADSR1_INV_flag,PV8_no_change_ADSR_1
	cpl	a				;Invers Hüllkurve
PV8_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV8_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr			;Log Hüllkurve
PV8_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN+3		;*Anschlagdyn
	movx	a,@r0
	mul	ab
V8_no_ADSR8_DCO1:
	
	push	b				;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+7		
	movx	a,@r0
	mul	ab				;=DCFRESO*OUT_BUFF
	pop	acc				;IN zurück holen
	add	a,b				;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0				;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V8_no_ADSR_DCF
	mov	a,ADSR4_DCF			;DCF ADSR
	jnb	ADSR2_INV_flag,PV8_no_change_ADSR_3
	cpl	a				;Invers Hüllkurve
PV8_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV8_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr			;Log Hüllkurve
PV8_no_change_ADSR_4:
	mul	ab				;=DCF ADSR * Frequenz + LFO1 + LFO2
V8_no_ADSR_DCF:
	mov	r0,b				;DCFGESFREQ
	pop	acc				;IN + DCFRESO*OUT_BUFF
	mul	ab				;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0				;DCFGESFREQ		
	cpl	a				;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+7			;OUT_BUFF
	movx	a,@r0				;OUT_BUFF holen
	mul	ab				;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b				;
	pop	b				;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b				;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a				;neuen Wert sicher

	add	a,DaL2
	MOV	DaL2,a
	clr	a
	addc	a,Dah2
	MOV	DaH2,a

	mov	r0,#DCO2PITCHVAL		;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE4			;+Tastenwert hinzu addieren
	clr	acc.7				;Werte von 0-127 zulassen
	push	acc 

	MOV	DPTR,#Phase_H		
	MOVC	A,@A+DPTR
	MOV	Phase8_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		
	MOVC	A,@A+DPTR
	MOV	Phase8_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		
	MOVC	A,@A+DPTR
	MOV	Phase8_add_low,A

	MOV	A,Phase8_acc_low		;speichere Phasenwerte
        ADD	A,Phase8_add_low
	MOV	Phase8_acc_low,A		;neue Phase low-byte
	MOV	A,Phase8_acc_mid
        ADDC	A,Phase8_add_mid
	MOV	Phase8_acc_mid,A		;neue Phase mid-byte
	MOV	A,Phase8_acc_high
	ADDC	A,Phase8_add_high	
	MOV	Phase8_acc_high,A		;neue Phase high-byte
DCO2_Ende:

;******************************************************************************************************
;* DCO 1 MODULATION ***********************************************************************************
;******************************************************************************************************
	
	mov	r0,#DCO1_INC_SYNC
	movx	a,@r0
	jz	moveDCO1_no_keyb_sync	;wenn kein Keyb Sync dann normal weiter
	mov	a,Voice
	jz	moveDCO1_no_voice	;wenn keine Taste gedrückt dann kein DEC, startet erst mit Taste
moveDCO1_no_keyb_sync:
	mov	r0,#DCO1_INC_RESTART
	movx	a,@r0
	jz	moveDCO1_no_restart	;wenn kein Mod Restart dann normal weiter
	mov	a,Voice_alt
	cjne	a,Voice,moveDCO1_restart ;wenn Änderung bei Voice dann setzte Werte auf Start
	jmp	moveDCO1_no_restart	;wenn keine Änderung bei Voice dann normal weiter
moveDCO1_restart:
	mov	Voice_alt,Voice
	jmp	moveDCO1_no_voice	;Werte auf Start setzten wenn sich Voice geändert hat
moveDCO1_no_restart:
	jnb	MidiSyncDCO1MOD,moveDCO1_no_MIDI_sync	;Midi Sync für DCO1 Mod aktiviert?
	jnb	MIDICLKflag_DCO1M,moveDCO1MOD_End	;Bit wird bei Midi Clock gesetzt und weiter unten gelöscht
	jmp	moveDCO1_MIDI_sync

moveDCO1_no_MIDI_sync:
	djnz	DCO1_z1,moveDCO1MOD_End	;Zeitabstände grob, in denen INC-Werte hinzuaddiert werden sollen
	mov	r0,#DCO1_INC_TIME
	movx	a,@r0
	mov	DCO1_z1,a

	djnz	DCO1_z2,moveDCO1MOD_End	;Zeitabstände fein, in denen INC-Werte hinzuaddiert werden sollen
	mov	r0,#DCO1_INC_TIME_2
	movx	a,@r0
	mov	DCO1_z2,a

moveDCO1_MIDI_sync:
	mov	r0,#DCO1_WAVE_INC	;INC-Wert holen
	movx	a,@r0
	jz	moveDCO1MOD_End		;wenn der 0 ist dann kein DCO1 Mod
	mov	a,DCO1M_Tmp
	jnz	moveDCO1_yes_Mod	;wenn temporärer INC-Wert ungleich 0 dann Mod 
	jnb	DCO1WaveInc_OneTime,moveDCO1_Loop ;wenn Flag gesetzt dann OneTime, sonst Mod im Loop
	jmp	moveDCO1_no_Mod

moveDCO1_yes_Mod:
	dec	DCO1M_Tmp
	mov	r0,#DCO1WAVE		;erhöhe den DCO1WAVE Wert um 1
	movx	a,@r0
	inc	acc
	clr	acc.7			;Werte von 0-127
	jnb	Voice1_PWM,no_pwm	;Wenn BIT PWM nicht gesetzt dann springe
	clr	acc.6			;Wenn PWM dann Werte von 0-63			
no_pwm: movx	@r0,a			;neuen Wert speichern
	clr	MIDICLKflag_DCO1M
        jmp	moveDCO1MOD_End		

moveDCO1_no_voice:
	mov	r0,#DCO1_INC_TIME	;ReInit der Zeitschleifenwerte wenn keine Taste gedrückt
	movx	a,@r0
	mov	DCO1_z1,a
	mov	r0,#DCO1_INC_TIME_2
	movx	a,@r0
	mov	DCO1_z2,a
moveDCO1_Loop:
	mov	r0,#DCO1_WAVE_INC	
	movx	a,@r0
	mov	DCO1M_Tmp,a		;DCO1M_Tmp wieder herstellen
moveDCO1_no_Mod:
	mov	R1,#DCO1WaveSave
	movx	a,@r1
	mov	r1,#DCO1Wave		;DCO1Wave wieder herstellen wenn Key sync
	movx	@r1,a
moveDCO1MOD_End:

;******************************************************************************************************
;* DCO 2 MODULATION ***********************************************************************************
;******************************************************************************************************

	mov	r0,#DCO2_INC_SYNC
	movx	a,@r0
	jz	moveDCO2_no_keyb_sync	;wenn kein Keyb Sync dann normal weiter
	mov	a,Voice
	jz	moveDCO2_no_voice	;wenn keine Taste gedrückt dann kein DEC, startet erst mit Taste
moveDCO2_no_keyb_sync:
	mov	r0,#DCO2_INC_RESTART
	movx	a,@r0
	jz	moveDCO2_no_restart	;wenn kein Mod Restart dann normal weiter
	mov	a,Voice_alt
	cjne	a,Voice,moveDCO2_restart ;wenn Änderung bei Voice dann setzte Werte auf Start
	jmp	moveDCO2_no_restart	;wenn keine Änderung bei Voice dann normal weiter
moveDCO2_restart:
	mov	Voice_alt,Voice
	jmp	moveDCO2_no_voice	;Werte auf Start setzten wenn sich Voice geändert hat
moveDCO2_no_restart:
	jnb	MidiSyncDCO2MOD,moveDCO2_no_MIDI_sync	;Midi Sync für DCO2 Mod aktiviert?
	jnb	MIDICLKflag_DCO2M,moveDCO2MOD_End	;Bit toggelt ja nach Midi Clock
	jmp	moveDCO2_MIDI_sync

moveDCO2_no_MIDI_sync:
	djnz	DCO2_z1,moveDCO2MOD_End	;Zeitabstände grob, in denen INC-Werte hinzuaddiert werden sollen
	mov	r0,#DCO2_INC_TIME
	movx	a,@r0
	mov	DCO2_z1,a

	djnz	DCO2_z2,moveDCO2MOD_End	;Zeitabstände fein, in denen INC-Werte hinzuaddiert werden sollen
	mov	r0,#DCO2_INC_TIME_2
	movx	a,@r0
	mov	DCO2_z2,a

moveDCO2_MIDI_sync:
	mov	r0,#DCO2_WAVE_INC	;INC-Wert holen
	movx	a,@r0
	jz	moveDCO2MOD_End		;wenn der 0 ist dann kein DCO2 Mod
	mov	a,DCO2M_Tmp
	jnz	moveDCO2_yes_Mod	;wenn temporärer INC-Wert ungleich 0 dann
	jnb	DCO2WaveInc_OneTime,moveDCO2_Loop ;wenn Flag gesetzt dann OneTime, sonst Mod im Loop
	jmp	moveDCO2_no_Mod
moveDCO2_yes_Mod:
	dec	DCO2M_Tmp
	mov	r0,#DCO2WAVE		;erhöhe den DCO2WAVE Wert um 1
	movx	a,@r0
	inc	acc
	clr	acc.7			;Werte von 0-127
	jnb	Voice2_PWM,moveDCO2_no_pwm	;Wenn BIT PWM nicht gesetzt dann springe
	clr	acc.6			;Wenn PWM dann Werte von 0-63			
moveDCO2_no_pwm:
	movx	@r0,a			;neuen Wert speichern
	clr	MIDICLKflag_DCO2M
        jmp	moveDCO2MOD_End		;springe raus

moveDCO2_no_voice:
	mov	r0,#DCO2_INC_TIME	;ReInit der Zeitschleifenwerte wenn keine Taste gedrückt
	movx	a,@r0
	mov	DCO2_z1,a
	mov	r0,#DCO2_INC_TIME_2
	movx	a,@r0
	mov	DCO2_z2,a
moveDCO2_Loop:
	mov	r0,#DCO2_WAVE_INC	
	movx	a,@r0
	mov	DCO2M_Tmp,a		;DCO2M_Tmp wieder herstellen
moveDCO2_no_Mod:
        mov	R1,#DCO2WaveSave
	movx	a,@r1
	mov	r1,#DCO2Wave		;DCO2Wave wieder herstellen wenn Key sync
	movx	@r1,a
moveDCO2MOD_End:

	clr 	c
	MOV	a,DaL2
	RLC	A
	MOV	DaL2,a
	MOV	A,DaH2
	RLC	A
	MOV	DaH2,A

	clr 	c
	MOV	a,DaL2
	RLC	A
	MOV	DaL2,a
	MOV	A,DaH2
	RLC	A
	MOV	DaH2,A
	mov	SFRPAGE,#DAC0_PAGE
	mov	DAC0L,DaL2
	mov	DAC0H,DaH2	

	clr	TF2
	pop	01
	pop	00
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti

;******************************************************************************************************
; DCO 1
;******************************************************************************************************

DAC_IRQ:push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push	00
	push	01

	jnb	Voice1_PWM,DAC_IRQ_1	
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#30h			;Bank3 = PWM einschalten
	mov	PSBANK,a
	jmp	DAC_IRQ_3
DAC_IRQ_1:
	jnb	Voice1_Bank,DAC_IRQ_2
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#20h			;Bank2
	mov	PSBANK,a
	jmp	DAC_IRQ_3
DAC_IRQ_2:
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#10h			;Bank1
	mov	PSBANK,a				
DAC_IRQ_3:

	jb	DCO1FINELFO1FLAG,LFO_DCO1FINE
	jb	DCO1FINELFO2FLAG,LFO_DCO1FINE
	jb	DCO1FINEFLAG,LFO_DCO1FINE
	jmp	no_LFO_DCO1FINE

LFO_DCO1FINE:
	mov	r0,#DCO1FINELFO1VAL	;DCO1 LFO1
	movx	a,@r0
	clr	c
	rrc	a			;0-63
	mov	b,a
	mov	r0,#DCO1FINELFO2VAL	;DCO1 LFO2
	movx	a,@r0
	clr	c
	rrc	a			;0-63
	add	a,b
	mov	b,a
	mov	r0,#DCO1FINE		;DCO1 Finetuning
	movx	a,@r0
	add	a,b			;+ 0-127 (64 für kein Feintuning)
	anl	a,#01111111b

	mov	dptr,#DCO_PITCH_TAB
	movc	a,@a+dptr
	mov  	SFRPAGE,#TMR2_PAGE
    	mov  	TMR2CN,#0h		;Timer 2 DIS
    	mov  	SFRPAGE,#TMR2_PAGE
    	mov  	TMR2CF,#008h
    	mov  	RCAP2L,a		;Abtastrate für DCO1
    	mov  	RCAP2H,#0f5h
	mov  	TMR2CN,#04h		;Timer 2 EN

	clr	DCO1FINELFO1FLAG
	clr	DCO1FINELFO2FLAG
	clr	DCO1FINEFLAG

no_LFO_DCO1FINE:

	MOV	DaL,#0			
	MOV	DaH,#0

	mov	r0,#PITCHB		;Pitchbend Wert	
	movx	a,@r0
	mov	b,a

	mov	r0,#DCO1SCALE		;-1, 0, +1 Oktave (244,0,12)
	movx	a,@r0
	mov	r0,a
	add	a,b			;PitchbendWert+Oktave
	mov	b,a
	mov	r0,#DCO1LFO1VAL
	movx	a,@r0
	add	a,b			;PitchbendWert+Oktave+LFO1
	mov	b,a
	mov	r0,#DCO1LFO2VAL
	movx	a,@r0
	add	a,b			;PitchbendWert+Oktave+LFO1+LFO2
	mov	r0,#DCO1PITCHVAL	;=PitchbendWert+Oktave+LFO1+LFO2 für die Voices
	movx	@r0,a
	mov	r0,#DCFFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	mov	r0,#DCFLFO1VAL		
	movx	a,@r0
	add	a,b			;+LFO1
	mov	r0,#DCFGESFREQ
	movx	@r0,a

	mov	r0,#DCFRESO
	movx	a,@r0			;Resonanz
	mov	b,a
	mov	r0,#DCFLFO2VAL
	movx	a,@r0
	add	a,b			;+LFO2		
	mov	r0,#DCFGESRESO
	movx	@r0,a

Play_voices:
	JB	Voice1,Play_Voice1
	JMP	Check_Voice2
Play_Voice1:
        mov 	dptr,#wavetable      	;get value from table
	mov	r0,#DCO1Wave
	movx	a,@r0
	add	a,dph			;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase1_acc_high	;high byte der Phase gibt Position der Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice1_XOR_off
	xrl	a,#80h
Play_Voice1_XOR_off:
	push	acc
	mov	r0,#DCO1GESVOL		;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc
	mul	ab			;*Lautstärke			
	mov	a,ADSR1			;*Hüllkurve
	jnb	ADSR1_INV_flag,PV1_no_change_ADSR_1
	cpl	a			;Invers Hüllkurve
PV1_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV1_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV1_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN		;*Anschlagdyn
	movx	a,@r0
	mul	ab

	push	b			;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF		
	movx	a,@r0
	mul	ab			;=DCFRESO*OUT_BUFF
	pop	acc			;IN zurück holen
	add	a,b			;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V1_no_ADSR_DCF
	mov	a,ADSR1_DCF		;DCF ADSR
	jnb	ADSR2_INV_flag,PV1_no_change_ADSR_3
	cpl	a			;Invers Hüllkurve
PV1_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV1_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV1_no_change_ADSR_4:
	mul	ab			;=DCF ADSR * Frequenz + LFO1 + LFO2
V1_no_ADSR_DCF:
	mov	r0,b			;DCFGESFREQ
	pop	acc			;IN + DCFRESO*OUT_BUFF
	mul	ab			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0			;DCFGESFREQ		
	cpl	a			;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF		;OUT_BUFF
	movx	a,@r0			;OUT_BUFF holen
	mul	ab			;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b			;
	pop	b			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b			;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a			;neuen Wert sichern		
	
	add	a,DaL
	MOV	DaL,a
	clr	a
	addc	a,Dah
	MOV	DaH,a
		
	mov	r0,#DCO1PITCHVAL	;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE1		;+Tastenwert hinzu addieren
	clr	acc.7			;Werte von 0-127 zulassen
	push	acc 
	
	MOV	DPTR,#Phase_H		;
	MOVC	A,@A+DPTR
	MOV	Phase1_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		;
	MOVC	A,@A+DPTR
	MOV	Phase1_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		;
	MOVC	A,@A+DPTR
	MOV	Phase1_add_low,A
	
	MOV	A,Phase1_acc_low	;speichere Phasenwerte
        ADD	A,Phase1_add_low
	MOV	Phase1_acc_low,A	;neue Phase low-byte
	MOV	A,Phase1_acc_mid
        ADDC	A,Phase1_add_mid
	MOV	Phase1_acc_mid,A	;neue Phase mid-byte
	MOV	A,Phase1_acc_high
	ADDC	A,Phase1_add_high	
	MOV	Phase1_acc_high,A	;neue Phase high-byte
	
Check_Voice2:                             
	JB	Voice2,Play_Voice2
	JMP	Check_Voice3
Play_Voice2:
	mov 	dptr,#wavetable      	;get value from table
	mov	r0,#DCO1Wave
	movx	a,@r0
	add	a,dph			;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase2_acc_high	;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice2_XOR_off
	xrl	a,#80h
Play_Voice2_XOR_off:
	push	acc
	mov	r0,#DCO1GESVOL		;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc
	mul	ab			;*Lautstärke				
	mov	a,ADSR2			;*Hüllkurve
	jnb	ADSR1_INV_flag,PV2_no_change_ADSR_1
	cpl	a			;Invers Hüllkurve
PV2_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV2_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV2_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN+1	;*Anschlagdyn
	movx	a,@r0
	mul	ab

	push	b			;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+1		
	movx	a,@r0
	mul	ab			;=DCFRESO*OUT_BUFF
	pop	acc			;IN zurück holen
	add	a,b			;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V2_no_ADSR_DCF
	mov	a,ADSR2_DCF		;DCF ADSR
	jnb	ADSR2_INV_flag,PV2_no_change_ADSR_3
	cpl	a			;Invers Hüllkurve
PV2_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV2_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV2_no_change_ADSR_4:
	mul	ab			;=DCF ADSR * Frequenz + LFO1 + LFO2
V2_no_ADSR_DCF:
	mov	r0,b			;DCFGESFREQ
	pop	acc			;IN + DCFRESO*OUT_BUFF
	mul	ab			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0			;DCFGESFREQ		
	cpl	a			;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+1		;OUT_BUFF
	movx	a,@r0			;OUT_BUFF holen
	mul	ab			;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b			;
	pop	b			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b			;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a			;neuen Wert sicher
	
	add	a,DaL
	MOV	DaL,a
	clr	a
	addc	a,Dah
	MOV	Dah,a

	mov	r0,#DCO1PITCHVAL	;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE2		;+Tastenwert hinzu addieren
	clr	acc.7			;Werte von 0-127 zulassen
	push	acc 

	MOV	DPTR,#Phase_H		;
	MOVC	A,@A+DPTR
	MOV	Phase2_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		;
	MOVC	A,@A+DPTR
	MOV	Phase2_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		;
	MOVC	A,@A+DPTR
	MOV	Phase2_add_low,A

	MOV	A,Phase2_acc_low	;speichere Phasenwerte
        ADD	A,Phase2_add_low
	MOV	Phase2_acc_low,A	;neue Phase low-byte
	MOV	A,Phase2_acc_mid
        ADDC	A,Phase2_add_mid
	MOV	Phase2_acc_mid,A	;neue Phase mid-byte
	MOV	A,Phase2_acc_high
	ADDC	A,Phase2_add_high	
	MOV	Phase2_acc_high,A	;neue Phase high-byte

Check_Voice3:			
	JB	Voice3,Play_Voice3
	JMP	Check_Voice4
Play_Voice3:	
        mov 	dptr,#wavetable      	;get value from table
	mov	r0,#DCO1Wave
	movx	a,@r0
	add	a,dph			;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase3_acc_high	;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice3_XOR_off
	xrl	a,#80h
Play_Voice3_XOR_off:
	push	acc
	mov	r0,#DCO1GESVOL		;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc
	mul	ab			;*Lautstärke			
	mov	a,ADSR3			;*Hüllkurve
	jnb	ADSR1_INV_flag,PV3_no_change_ADSR_1
	cpl	a			;Invers Hüllkurve
PV3_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV3_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV3_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN+2	;*Anschlagdyn
	movx	a,@r0
	mul	ab
	
	push	b			;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+2		
	movx	a,@r0
	mul	ab			;=DCFRESO*OUT_BUFF
	pop	acc			;IN zurück holen
	add	a,b			;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V3_no_ADSR_DCF
	mov	a,ADSR3_DCF		;DCF ADSR
	jnb	ADSR2_INV_flag,PV3_no_change_ADSR_3
	cpl	a			;Invers Hüllkurve
PV3_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV3_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV3_no_change_ADSR_4:
	mul	ab			;=DCF ADSR * Frequenz + LFO1 + LFO2
V3_no_ADSR_DCF:
	mov	r0,b			;DCFGESFREQ
	pop	acc			;IN + DCFRESO*OUT_BUFF
	mul	ab			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0			;DCFGESFREQ		
	cpl	a			;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+2		;OUT_BUFF
	movx	a,@r0			;OUT_BUFF holen
	mul	ab			;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b			;
	pop	b			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b			;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a			;neuen Wert sicher
	
	add	a,DaL
	MOV	DaL,a
	clr	a
	addc	a,Dah
	MOV	DaH,a

	mov	r0,#DCO1PITCHVAL	;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE3		;+Tastenwert hinzu addieren
	clr	acc.7			;Werte von 0-127 zulassen
	push	acc 
	
	MOV	DPTR,#Phase_H		;
	MOVC	A,@A+DPTR
	MOV	Phase3_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		;
	MOVC	A,@A+DPTR
	MOV	Phase3_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		;
	MOVC	A,@A+DPTR
	MOV	Phase3_add_low,A

	MOV	A,Phase3_acc_low	;speichere Phasenwerte
        ADD	A,Phase3_add_low
	MOV	Phase3_acc_low,A	;neue Phase low-byte
	MOV	A,Phase3_acc_mid
        ADDC	A,Phase3_add_mid
	MOV	Phase3_acc_mid,A	;neue Phase mid-byte
	MOV	A,Phase3_acc_high
	ADDC	A,Phase3_add_high	
	MOV	Phase3_acc_high,A	;neue Phase high-byte

Check_Voice4:
	JB	Voice4,Play_Voice4
	JMP	Check_Voice5
Play_Voice4:	
        mov 	dptr,#wavetable      	;get value from table
	mov	r0,#DCO1Wave
	movx	a,@r0
	add	a,dph			;Wellenformen, Werte 0-127
	mov	dph,a	
	MOV	A,Phase4_acc_high	;high byte der Phase gibt Position der Sine-Tabelle	
        movc 	a,@a+dptr
	jnb	xor_on_off,Play_Voice4_XOR_off
	xrl	a,#80h
Play_Voice4_XOR_off:
	push	acc
	mov	r0,#DCO1GESVOL		;Lautstärke
	movx	a,@r0
	mov	b,a
	pop	acc
	mul	ab			;*Lautstärke			
	mov	a,ADSR4			;*Hüllkurve
	jnb	ADSR1_INV_flag,PV4_no_change_ADSR_1
	cpl	a			;Invers Hüllkurve
PV4_no_change_ADSR_1:
	jnb	ADSR1_LOG_flag,PV4_no_change_ADSR_2
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV4_no_change_ADSR_2:
	mul	ab
	mov	r0,#ANSCHLAGDYN+3	;*Anschlagdyn
	movx	a,@r0
	mul	ab

	push	b			;IN sichern
	mov	r0,#DCFGESRESO
	movx	a,@r0
	mov	b,a
	mov	r0,#OUT_BUFF+3		
	movx	a,@r0
	mul	ab			;=DCFRESO*OUT_BUFF
	pop	acc			;IN zurück holen
	add	a,b			;=IN + DCFRESO*OUT_BUFF
	push	acc	
	mov	r0,#DCFGESFREQ
	movx	a,@r0			;Frequenz
	mov	b,a
	jnb	ADSR2_DCF_flag,V4_no_ADSR_DCF
	mov	a,ADSR4_DCF		;DCF ADSR
	jnb	ADSR2_INV_flag,PV4_no_change_ADSR_3
	cpl	a			;Invers Hüllkurve
PV4_no_change_ADSR_3:
	jnb	ADSR2_LOG_flag,PV4_no_change_ADSR_4
	mov	DPTR,#LIN2LOG
	movc	a,@a+dptr		;Log Hüllkurve
PV4_no_change_ADSR_4:
	mul	ab			;=DCF ADSR * Frequenz + LFO1 + LFO2
V4_no_ADSR_DCF:
	mov	r0,b			;DCFGESFREQ
	pop	acc			;IN + DCFRESO*OUT_BUFF
	mul	ab			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	push	b
	mov	a,r0			;DCFGESFREQ		
	cpl	a			;=1-DCFGESFREQ
	mov	b,a
	mov	r0,#OUT_BUFF+3		;OUT_BUFF
	movx	a,@r0			;OUT_BUFF holen
	mul	ab			;=1-DCFGESFREQ * OUT_BUFF
	mov	a,b			;
	pop	b			;=IN + DCFRESO*OUT_BUFF * DCFGESFREQ
	add	a,b			;=(IN + (DCFRESO*OUT_BUFF * DCFGESFREQ)) + ((1-DCFGESFREQ) * OUT_BUFF)
	movx	@r0,a			;neuen Wert sicher	
	
	add	a,DaL
	MOV	DaL,a
	clr	a
	addc	a,Dah
	MOV	DaH,a

	mov	r0,#DCO1PITCHVAL	;PitchbendWert+Oktave+LFO1+LFO2
	movx	a,@r0
	ADD	A,TASTE4		;+Tastenwert hinzu addieren
	clr	acc.7			;Werte von 0-127 zulassen
	push	acc 

	MOV	DPTR,#Phase_H		;
	MOVC	A,@A+DPTR
	MOV	Phase4_add_high,A
	pop	acc
	push	acc
	MOV	DPTR,#Phase_M		;
	MOVC	A,@A+DPTR
	MOV	Phase4_add_mid,A
	pop	acc
	MOV	DPTR,#Phase_L		;
	MOVC	A,@A+DPTR
	MOV	Phase4_add_low,A

	MOV	A,Phase4_acc_low	;speichere Phasenwerte
        ADD	A,Phase4_add_low
	MOV	Phase4_acc_low,A	;neue Phase low-byte
	MOV	A,Phase4_acc_mid
        ADDC	A,Phase4_add_mid
	MOV	Phase4_acc_mid,A	;neue Phase mid-byte
	MOV	A,Phase4_acc_high
	ADDC	A,Phase4_add_high	
	MOV	Phase4_acc_high,A	;neue Phase high-byte

Check_Voice5:

;******************************************************************************************************
;* DCO1 Volume und DAC Ausgabe ************************************************************************
;******************************************************************************************************

DCO_Volume:
	clr 	c
	MOV	a,DaL
	RLC	A
	MOV	DaL,a
	MOV	A,DaH
	RLC	A
	MOV	DaH,A

	clr 	c
	MOV	a,DaL
	RLC	A
	MOV	DaL,a
	MOV	A,DaH
	RLC	A
	MOV	DaH,A
	mov	SFRPAGE,#DAC1_PAGE
	mov	DAC1L,DaL	
	mov	DAC1H,DaH	

	clr	TF3
	pop	01
	pop	00
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti

;*************************************************************************************************
;* T1 IRQ (31250/3 Hz) für ADSR ******************************************************************
;*************************************************************************************************

LFO2_DELAY_END_2_hlp:
	jmp	LFO2_DELAY_END_2

ADSR_IRQ:
	push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push 	00		
	push	01

	djnz	ADSR_Z,LFO2_DELAY_END_2_hlp
	mov	ADSR_Z,#3			

;* ATTACK *********************************************************************************************
	
	mov	r0,#sustain
	movx	a,@r0
	mov	b,a

	djnz	adsr_z3,adsrA_end	;60us * 1-255 = 60us - 15,32ms 
	mov	r0,#attack
	movx	a,@r0
	mov	adsr_z3,a
	jnb	voice1_start,adsrA_2	;wurde Taste gedrückt?
	inc	adsr1
	mov	a,adsr1
	cjne	a,#0ffh,adsrA_2		;wenn max-Wert erreicht dann 
	clr	voice1_start		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsrA_22	;wenn Sustain = 100% dann kein Decay
	jmp	adsrA_2
adsrA_22:
	setb	voice1_ds
adsrA_2:
	jnb	voice2_start,adsrA_3	;wurde Taste gedrückt?
	inc	adsr2
	mov	a,adsr2
	cjne	a,#0ffh,adsrA_3		;wenn max-Wert erreicht dann 
	clr	voice2_start		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsrA_33	;wenn Sustain = 100% dann kein Decay
	jmp	adsrA_3
adsrA_33:
	setb	voice2_ds
adsrA_3:
	jnb	voice3_start,adsrA_4	;wurde Taste gedrückt?
	inc	adsr3
	mov	a,adsr3
	cjne	a,#0ffh,adsrA_4		;wenn max-Wert erreicht dann 
	clr	voice3_start		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsrA_44	;wenn Sustain = 100% dann kein Decay
	jmp	adsrA_4
adsrA_44:
	setb	voice3_ds
adsrA_4:
	jnb	voice4_start,adsrA_end	;wurde Taste gedrückt?
	inc	adsr4
	mov	a,adsr4
	cjne	a,#0ffh,adsrA_end	;wenn max-Wert erreicht dann 
	clr	voice4_start		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsrA_55	;wenn Sustain = 100% dann kein Decay
	jmp	adsrA_end
adsrA_55:
	setb	voice4_ds
adsrA_end:

;* DECAY / SUSTAIN ************************************************************************************

	djnz	adsr_z5,adsrDS_end	;60us * 1-255 = 60us - 15,32ms 
	mov	r0,#decay
	movx	a,@r0
	mov	adsr_z5,a

	jnb	voice1_ds,adsrDS_2	
	dec	adsr1
	mov	a,b
	cjne	a,adsr1,adsrDS_2	;wenn Sustain Wert erreicht dann
	clr	voice1_ds		;Flag löschen
adsrDS_2:
	jnb	voice2_ds,adsrDS_3	
	dec	adsr2
	mov	a,b
	cjne	a,adsr2,adsrDS_3
	clr	voice2_ds		
adsrDS_3:
	jnb	voice3_ds,adsrDS_4	
	dec	adsr3
	mov	a,b
	cjne	a,adsr3,adsrDS_4
	clr	voice3_ds		
adsrDS_4:
	jnb	voice4_ds,adsrDS_end	
	dec	adsr4
	mov	a,b
	cjne	a,adsr4,adsrDS_end
	clr	voice4_ds		
adsrDS_end:

;* RELEASE ********************************************************************************************

	djnz	adsr_z2,adsr_end	;60us * 1-255 = 60us - 15,32ms 
	mov	r0,#release
	movx	a,@r0
	mov	adsr_z2,a

	jnb	voice1_end,adsr_2	;wurde Taste 1 losgelassen?
	djnz	adsr1,adsr_2		;wenn ja dann multiplikator für Wave1 dec
	clr	voice1_end		;wenn multiplikator = 0 dann flag = 0
	clr	voice1			;Voice1 ausschalten
adsr_2:	jnb	voice2_end,adsr_3	;wurde Taste 2 losgelassen?
	djnz	adsr2,adsr_3
	clr	voice2_end
	clr	voice2
adsr_3: jnb	voice3_end,adsr_4	;wurde Taste 3 losgelassen?
	djnz	adsr3,adsr_4
	clr	voice3_end
	clr	voice3
adsr_4: jnb	voice4_end,adsr_end	;wurde Taste 4 losgelassen?
	djnz	adsr4,adsr_end
	clr	voice4_end
	clr	voice4
adsr_end:
	jmp	attack_DCF_start

;* DCF ATTACK *****************************************************************************************

attack_DCF_start:
	mov	r0,#DCFSUSTAIN
	movx	a,@r0
	mov	b,a	

	djnz	adsr_DCF_z3,adsr_DCF_end	;60us * 1-255 = 60us - 15,32ms 
	mov	r0,#DCFATTACK
	movx	a,@r0
	mov	adsr_DCF_z3,a

	jnb	voice1_start_DCF,adsr_DCF_2	;wurde Taste 1 gedrückt? 
adsr_DCF_11:
	inc	adsr1_DCF
	mov	a,adsr1_DCF
	cjne	a,#0ffh,adsr_DCF_2		;wenn max-Wert erreicht dann 
	clr	voice1_start_DCF		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsr_DCF_22		;wenn DCF Sustain = 100% dann kein Decay
	jmp	adsr_DCF_2
adsr_DCF_22:
	setb	voice1_ds_DCF			;Decay/Sustain einschalten
adsr_DCF_2:
	jnb	voice2_start_DCF,adsr_DCF_3	;wurde Taste 2 gedrückt?
	inc	adsr2_DCF
	mov	a,adsr2_DCF
	cjne	a,#0ffh,adsr_DCF_3		;wenn max-Wert erreicht dann 
	clr	voice2_start_DCF		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsr_DCF_33		;wenn DCF Sustain = 100% dann kein Decay
	jmp	adsr_DCF_3
adsr_DCF_33:
	setb	voice2_ds_DCF
adsr_DCF_3:
	jnb	voice3_start_DCF,adsr_DCF_4	;wurde Taste gedrückt?
	inc	adsr3_DCF
	mov	a,adsr3_DCF
	cjne	a,#0ffh,adsr_DCF_4		;wenn max-Wert erreicht dann 
	clr	voice3_start_DCF		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsr_DCF_44		;wenn DCF Sustain = 100% dann kein Decay
	jmp	adsr_DCF_4
adsr_DCF_44:
	setb	voice3_ds_DCF
adsr_DCF_4:
	jnb	voice4_start_DCF,adsr_DCF_end	;wurde Taste gedrückt?
	inc	adsr4_DCF
	mov	a,adsr4_DCF
	cjne	a,#0ffh,adsr_DCF_end		;wenn max-Wert erreicht dann 
	clr	voice4_start_DCF		;flag löschen
	mov	a,b
	cjne	a,#0ffh,adsr_DCF_55		;wenn DCF Sustain = 100% dann kein Decay
	jmp	adsr_DCF_end
adsr_DCF_55:
	setb	voice4_ds_DCF
adsr_DCF_end:

;* DCF DECAY / SUSTAIN ********************************************************************************
	
	djnz	adsr_DCF_z5,adsrDS_DCF_end	;60us * 1-255 = 60us - 15,32ms 
	mov	r0,#DCFDECAY
	movx	a,@r0
	mov	adsr_DCF_z5,a

	jnb	voice1_ds_DCF,adsrDS_DCF_2
	dec	adsr1_DCF
	mov	a,b
	cjne	a,adsr1_DCF,adsrDS_DCF_2	;wenn DCF Sustain Wert erreicht dann
	clr	voice1_ds_DCF			;Flag löschen
adsrDS_DCF_2:
	jnb	voice2_ds_DCF,adsrDS_DCF_3	
	dec	adsr2_DCF
	mov	a,b
	cjne	a,adsr2_DCF,adsrDS_DCF_3
	clr	voice2_ds_DCF		
adsrDS_DCF_3:
	jnb	voice3_ds_DCF,adsrDS_DCF_4	
	dec	adsr3_DCF
	mov	a,b
	cjne	a,adsr3_DCF,adsrDS_DCF_4
	clr	voice3_ds_DCF		
adsrDS_DCF_4:
	jnb	voice4_ds_DCF,adsrDS_DCF_end	
	dec	adsr4_DCF
	mov	a,b
	cjne	a,adsr4_DCF,adsrDS_DCF_end
	clr	voice4_ds_DCF		
adsrDS_DCF_end:


;* DCF RELEASE ****************************************************************************************
	
	mov	r0,#DCFRELEASE
	movx	a,@r0
	cjne	a,#01,adsrR_DCF
	mov	voice_end_DCF,#0
	jmp	adsrR_DCF_end			;wenn DCFRELEASE=1 dann ohne Release raus

adsrR_DCF:	
	djnz	adsr_DCF_z2,adsrR_DCF_end	;60us * 1-255 = 60us - 15,32ms 
	mov	r0,#DCFRELEASE
	movx	a,@r0
	mov	adsr_DCF_z2,a

	jnb	voice1_end_DCF,adsrR_DCF_2	;wurde Taste 1 losgelassen?
adsrR_DCF_11:
	djnz	adsr1_DCF,adsrR_DCF_2		;wenn ja dann multiplikator für DCF
	mov	adsr1_DCF,#4
	clr	voice1_end_DCF			;wenn multiplikator = 0 dann flag = 0
adsrR_DCF_2:
	jnb	voice2_end_DCF,adsrR_DCF_3	;wurde Taste 2 losgelassen?
	djnz	adsr2_DCF,adsrR_DCF_3
	mov	adsr2_DCF,#4
	clr	voice2_end_DCF
adsrR_DCF_3:
	jnb	voice3_end_DCF,adsrR_DCF_4	;wurde Taste 3 losgelassen?
	djnz	adsr3_DCF,adsrR_DCF_4
	mov	adsr3_DCF,#4
	clr	voice3_end_DCF
adsrR_DCF_4:
	jnb	voice4_end_DCF,adsrR_DCF_end	;wurde Taste 4 losgelassen?
	djnz	adsr4_DCF,adsrR_DCF_end
	mov	adsr4_DCF,#4
	clr	voice4_end_DCF
adsrR_DCF_end:

;************************************************************************************************
;* LFO1 Delay ***********************************************************************************
;************************************************************************************************
	mov	a,voice
	jz	LFO1_DELAY_END_1		;Eine Taste gedrückt?
	jb	Start_LFO1,LFO1_DELAY_END_2	;Delay-Wert bereits erreicht?
	djnz	LFO1_z2,LFO1_DELAY_END_1	;Delay-Zeit (15ms bis max 4s)
	mov	r0,#LFO1DELAY
	movx	a,@r0
	mov	LFO1_z2,a			;ReInit Delay-Wert
	djnz	LFO1_z4,LFO1_DELAY_END_1	;16643 Hz /256 = 65Hz => 15ms
	setb	Start_LFO1			;LFO1 Start bit nach Delay-Zeit setzen
	jz	no_LFO1_KEYB_SYNC_2		;Wenn Keyb Sync dann
	mov	LFO1_help,#0			;Startwert für LFO1 neu setzten
no_LFO1_KEYB_SYNC_2:
	jmp	LFO1_DELAY_END_2
LFO1_DELAY_END_1:	
	clr	Start_LFO1
	mov	r0,#LFO1DELAY
	movx	a,@r0
	cjne	a,#1,LFO1_DELAY_END_2
	setb	Start_LFO1
LFO1_DELAY_END_2:

;************************************************************************************************
;* LFO2 Delay ***********************************************************************************
;************************************************************************************************
	mov	a,voice
	jz	LFO2_DELAY_END_1		;Eine Taste gedrückt?
	jb	Start_LFO2,LFO2_DELAY_END_2	;Delay-Wert bereits erreicht?
	djnz	LFO2_z2,LFO2_DELAY_END_1	;Delay-Zeit (15ms bis max 4s)
	mov	r0,#LFO2DELAY
	movx	a,@r0
	mov	LFO2_z2,a			;ReInit Delay-Wert
	djnz	LFO2_z4,LFO2_DELAY_END_1	;16643 Hz /256 = 65Hz => 15ms
	setb	Start_LFO2			;LFO2 Start bit nach Delay-Zeit setzen
	jz	no_LFO2_KEYB_SYNC_2		;Wenn Keyb Sync dann
	mov	LFO2_help,#0			;Startwert für LFO2 neu setzten
no_LFO2_KEYB_SYNC_2:
	jmp	LFO2_DELAY_END_2
LFO2_DELAY_END_1:	
	clr	Start_LFO2
	mov	r0,#LFO2DELAY
	movx	a,@r0
	cjne	a,#1,LFO2_DELAY_END_2
	setb	Start_LFO2
LFO2_DELAY_END_2:
	;clr	CF				;PCA0MD.7	
	pop	01				
	pop	00				
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti

;*************************************************************************************************
;* Timer 0 IRQ (43200 Hz) für LFO1/2 *************************************************************
;*************************************************************************************************

LFO1_end_hlp:
	jmp	LFO1_end

LFO1_IRQ:					;43200 Hz
	push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push	00
	push	01				

	djnz	LFO1_z1,LFO1_end_hlp		;LFO Geschwindigkeit
	mov	r1,#LFO1RATE
	movx	a,@r1
	mov	LFO1_z1,a	
	djnz	LFO1_z3,LFO1_end_hlp		;LFO RANGE LOW/MID/HIGH 
	mov	r1,#LFO1RANGE
	movx	a,@r1
	mov	LFO1_z3,a	
	mov	dptr,#lfo_tab
	mov	r1,#LFO1WAVE			;LFO Wellenform
	movx	a,@r1
	cjne	a,#08,LFO1_no_Random		;wenn 0-7 dann Wellenformen aus Tabelle
	mov	r1,#RANDOM_LFO1			;wenn 8 dann LFO1 Random
	movx	a,@r1		
        MOV     B,#37				
        MUL     AB
        ADD     A,#53
        MOVx    @r1,A				;=x(n+1) = (a*x(n)+c) mod 256	
	JMP	LFO1_Random
LFO1_no_Random:	
	add	a,dph
	mov	dph,a				;Wellenform auf Tabellenstart addieren
	mov	a,LFO1_help
	inc	a
	mov	LFO1_help,a
	movc	a,@a+dptr			;0-255 Werte aus Tabelle holen
	mov	r1,#LFO1VAL
	movx	@r1,a				;(0-FFh)
LFO1_Random:
	mov	r0,a
	jnb	ADSR2_LFO1_flag,LFO1_no_ADSR	;wenn Flag gesetzt dann ADSR2
	mov	b,ADSR1_DCF
	mul	ab				;LFO1VAL * ADSR2
	mov	r0,b
LFO1_no_ADSR:	
	jb	Start_LFO1,LFO1_Start		;Bit wird nach abgelaufener Delay-Time gesetzt
	mov	r0,#0
LFO1_Start:
	mov	b,r0
	mov	r1,#DCFLFO1			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO1 Wert * DCF LFO1 Stärke
	mov	a,b
	mov	r1,#DCFLFO1VAL
	movx	@r1,a				;wegspeichern als Multiplikatorwert
				
	mov	b,r0
	mov	r1,#DCO1LFO1			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO1 Wert * DCO1 LFO1 Stärke
	mov	a,b
	mov	r1,#DCO1LFO1VAL
	movx	@r1,a

	mov	b,r0
	mov	r1,#DCO2LFO1			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO1 Wert * DCO2 LFO1 Stärke
	mov	a,b
	mov	r1,#DCO2LFO1VAL
	movx	@r1,a

	mov	b,r0
	mov	r1,#EFXLFO1			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO1 Wert * EFXLFO1
	mov	a,b
	mov	r1,#EFXLFO1VAL
	movx	@r1,a

	mov	b,r0
	mov	r1,#DCO2FINELFO1		;*(0-127)
	movx	a,@r1
	mul	ab				;LFO1 Wert * DCO2 LFO1 FINETUNING Stärke
	mov	a,b
	mov	r1,#DCO2FINELFO1VAL
	movx	@r1,a
	jz	LFO1_Start_1
	setb	DCO2FINELFO1FLAG
LFO1_Start_1:

	mov	a,r0	
	mov	r1,#DCALFO1VAL			;LFO1
	movx	@r1,a

	mov	b,r0
	mov	r1,#DCO1FINELFO1		;*(0-127)
	movx	a,@r1
	mul	ab				;LFO1 Wert * DCO1 LFO1 FINETUNING Stärke
	mov	a,b
	mov	r1,#DCO1FINELFO1VAL
	movx	@r1,a
	jz	LFO1_Start_2
	setb	DCO1FINELFO1FLAG
LFO1_Start_2:
	jmp	LFO1_end

LFO2_end_hlp:
	jmp	LFO2_end

LFO1_end:
	djnz	LFO2_z1,LFO2_end_hlp		;LFO2 Geschwindigkeit
	mov	r1,#LFO2RATE
	movx	a,@r1
	mov	LFO2_z1,a	
	djnz	LFO2_z3,LFO2_end_hlp		;LFO2 RANGE LOW/MID/HIGH 
	mov	r1,#LFO2RANGE
	movx	a,@r1
	mov	LFO2_z3,a	
	mov	dptr,#lfo_tab
	mov	r1,#LFO2WAVE			;LFO Wellenform
	movx	a,@r1
	cjne	a,#08,LFO2_no_Random		;wenn 0-7 dann Wellenformen aus Tabelle
	mov	r1,#RANDOM_LFO2
	MOVX    A,@r1				;wenn 8 dann LFO2 Random
        MOV     B,#37
        MUL     AB
        ADD     A,#53
        MOVX    @r1,a				;=x(n+1) = (a*x(n)+c) mod 256		
	JMP	LFO2_Random
LFO2_no_Random:	
	add	a,dph
	mov	dph,a				;Wellenform auf Tabellenstart addieren
	mov	a,LFO2_help
	inc	a
	mov	LFO2_help,a
	movc	a,@a+dptr			;0-255 Werte aus Tabelle holen
	mov	r1,#LFO2VAL
	movx	@r1,a				;(0-FFh)
LFO2_Random:
	mov	r0,a
	jnb	ADSR2_LFO2_flag,LFO2_no_ADSR	;wenn Flag gesetzt dann ADSR2
	mov	b,ADSR1_DCF
	mul	ab				;LFO2VAL * ADSR2
	mov	r0,b
LFO2_no_ADSR:		
	jb	Start_LFO2,LFO2_Start		;Bit wird nach Delay-Time gesetzt
	mov	r0,#0
LFO2_Start:
	mov	b,r0
	mov	r1,#DCFLFO2			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO2 Wert * DCF LFO2 Stärke
	mov	a,b
	mov	r1,#DCFLFO2VAL
	movx	@r1,a				;wegspeichern als Multiplikatorwert
				
	mov	b,r0
	mov	r1,#DCO1LFO2			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO2 Wert * DCO1 LFO2 Stärke
	mov	a,b
	mov	r1,#DCO1LFO2VAL
	movx	@r1,a

	mov	b,r0
	mov	r1,#DCO2LFO2			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO2 Wert * DCO2 LFO2 Stärke
	mov	a,b
	mov	r1,#DCO2LFO2VAL
	movx	@r1,a

	mov	b,r0
	mov	r1,#EFXLFO2			;*(0-254)
	movx	a,@r1
	mul	ab				;LFO2 Wert * EFXLFO2
	mov	a,b
	mov	r1,#EFXLFO2VAL
	movx	@r1,a

	mov	b,r0
	mov	r1,#DCO2FINELFO2		;*(0-127)
	movx	a,@r1
	mul	ab				;LFO2 Wert * DCO2 LFO2 FINETUNING Stärke
	mov	a,b
	mov	r1,#DCO2FINELFO2VAL
	movx	@r1,a
	jz	LFO2_Start_1
	setb	DCO2FINELFO2FLAG
LFO2_Start_1:

	mov	a,r0	
	mov	r1,#DCALFO2VAL			;LFO2
	movx	@r1,a

	mov	b,r0
	mov	r1,#DCO1FINELFO2		;*(0-127)
	movx	a,@r1
	mul	ab				;LFO2 Wert * DCO1 LFO2 FINETUNING Stärke
	mov	a,b
	mov	r1,#DCO1FINELFO2VAL
	movx	@r1,a
	jz	LFO2_end
	setb	DCO1FINELFO2FLAG

LFO2_end:	
	pop	01				
	pop	00
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti

;********************************************************************************************************

$include (SMBus.a51)		;I2C
$include (init.a51)		;Initialisierungen
$include (phases.inc)		;Phasen
$include (lfo.inc)		;LFO Waves
$include (velo.inc)		;Velocity Kurven
$include (midi.a51)
$include (log.a51)
$include (25VF020.a51)
$include (arduino.a51)
$include (PT2257.a51)
$include (exRAM.a51)

ORG	    	8000h		;Start der Wavetables
wavetable:
;$include (waves_1.inc)
;$include (waves_2.inc)
end


