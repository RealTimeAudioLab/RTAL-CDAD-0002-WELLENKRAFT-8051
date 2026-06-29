;******************************************************************************************************
;* MIDI ***********************************************************************************************
;******************************************************************************************************

;*** Sendet alle Parameterwerte an Midi ***************************************************************

XRAM2MIDI:
	SETB	MIDI_LED
	MOV	r1,#LFO1RATE		;Zähler
LOOP_XRAM2MIDI:
	mov	a,#0B0H
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	a,r1
	mov	r0,#smidibyte2
	movx	@r0,a

	cjne	a,#LFO1RATE,LOOP_XRAM2MIDI_A
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_A:
	cjne	a,#LFO1DELAY,LOOP_XRAM2MIDI_B
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_B:
	cjne	a,#LFO1RANGE,LOOP_XRAM2MIDI_C
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_C:
	cjne	a,#LFO2RATE,LOOP_XRAM2MIDI_D
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_D:
	cjne	a,#LFO2DELAY,LOOP_XRAM2MIDI_E
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_E:
	cjne	a,#LFO2RANGE,LOOP_XRAM2MIDI_F
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_F:
	cjne	a,#DCO1LFO1,LOOP_XRAM2MIDI_G
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_G:
	cjne	a,#DCO1LFO2,LOOP_XRAM2MIDI_H
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_H:
	cjne	a,#DCO2LFO1,LOOP_XRAM2MIDI_I
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_I:
	cjne	a,#DCO2LFO2,LOOP_XRAM2MIDI_J
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_J:
	cjne	a,#DCFLFO1,LOOP_XRAM2MIDI_K
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_K:
	cjne	a,#DCFLFO2,LOOP_XRAM2MIDI_L
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_L:
	cjne	a,#DCFFREQ,LOOP_XRAM2MIDI_M
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_M:
	cjne	a,#DCFRESO,LOOP_XRAM2MIDI_N
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_N:
	cjne	a,#DCFATTACK,LOOP_XRAM2MIDI_O
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_O:
	cjne	a,#DCFDECAY,LOOP_XRAM2MIDI_P
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_P:
	cjne	a,#DCFSUSTAIN,LOOP_XRAM2MIDI_Q
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_Q:
	cjne	a,#DCFRELEASE,LOOP_XRAM2MIDI_R
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_R:
	cjne	a,#ATTACK,LOOP_XRAM2MIDI_S
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_S:
	cjne	a,#DECAY,LOOP_XRAM2MIDI_T
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_T:
	cjne	a,#SUSTAIN,LOOP_XRAM2MIDI_U
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_U:
	cjne	a,#RELEASE,LOOP_XRAM2MIDI_V
	MOVX	A,@r1			;Werte aus XRAM	(1-255)
	dec	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_V:
	cjne	a,#EFX_A,LOOP_XRAM2MIDI_W
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_W:
	cjne	a,#EFX_B,LOOP_XRAM2MIDI_X
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_X:
	cjne	a,#EFX_C,LOOP_XRAM2MIDI_Y
	MOVX	A,@r1			;Werte aus XRAM (255-1)
	cpl	a					;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_Y:
	cjne	a,#EFXLFO1,LOOP_XRAM2MIDI_Z
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_Z:
	cjne	a,#EFXLFO2,LOOP_XRAM2MIDI_A1
	MOVX	A,@r1			;Werte aus XRAM	;(0-254)
	rr	a					;(0-127)
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_A1:
	cjne	a,#DCO1_INC_TIME,LOOP_XRAM2MIDI_A2
	MOVX	A,@r1			;Werte aus XRAM	;(1-128)
	dec	a
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_A2:
	cjne	a,#DCO2_INC_TIME,LOOP_XRAM2MIDI_A3
	MOVX	A,@r1			;Werte aus XRAM	;(1-128)
	dec	a
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter

LOOP_XRAM2MIDI_A3:
	cjne	a,#DCO1_INC_MIDI_CLK,LOOP_XRAM2MIDI_A4
	jmp	LOOP_XRAM2MIDI_A6_weiter

LOOP_XRAM2MIDI_A4:
	cjne	a,#DCO2_INC_MIDI_CLK,LOOP_XRAM2MIDI_A5
	jmp	LOOP_XRAM2MIDI_A6_weiter

LOOP_XRAM2MIDI_A5:
	cjne	a,#LFO1_CLK,LOOP_XRAM2MIDI_A6
	jmp	LOOP_XRAM2MIDI_A6_weiter

LOOP_XRAM2MIDI_A6:
	cjne	a,#LFO2_CLK,LOOP_XRAM2MIDI_A7
LOOP_XRAM2MIDI_A6_weiter:
	MOVX	A,@r1			;Werte aus XRAM	;(24,12,6,3,1)
	cjne	a,#24,LOOP_XRAM2MIDI_A6_1
	mov	a,#0
	jmp	LOOP_XRAM2MIDI_A6_raus
LOOP_XRAM2MIDI_A6_1:
	cjne	a,#12,LOOP_XRAM2MIDI_A6_2
	mov	a,#1
	jmp	LOOP_XRAM2MIDI_A6_raus		
LOOP_XRAM2MIDI_A6_2:
	cjne	a,#6,LOOP_XRAM2MIDI_A6_3
	mov	a,#2
	jmp	LOOP_XRAM2MIDI_A6_raus
LOOP_XRAM2MIDI_A6_3:
	cjne	a,#3,LOOP_XRAM2MIDI_A6_4
	mov	a,#3
	jmp	LOOP_XRAM2MIDI_A6_raus
LOOP_XRAM2MIDI_A6_4:
	cjne	a,#1,LOOP_XRAM2MIDI_A6_5
	mov	a,#4
	jmp	LOOP_XRAM2MIDI_A6_raus
LOOP_XRAM2MIDI_A6_5:
	mov	a,#0
LOOP_XRAM2MIDI_A6_raus:
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter

LOOP_XRAM2MIDI_A7:
	cjne	a,#DCO1SCALE,LOOP_XRAM2MIDI_A8
	movx	a,@r1
	cjne	a,#13,$+3
	jnc	LOOP_XRAM2MIDI_A7_1
	mov	b,#5
	mul	ab
	add	a,#64
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_A7_1:
	cpl	a
	mov	b,#5
	mul	ab
	anl	a,#01111111b
	mov	r0,a
	mov	a,#59
	subb	a,r0
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter

LOOP_XRAM2MIDI_A8:
	cjne	a,#DCO2SCALE,LOOP_XRAM2MIDI_A9
	movx	a,@r1
	cjne	a,#13,$+3
	jnc	LOOP_XRAM2MIDI_A8_1
	mov	b,#5
	mul	ab
	add	a,#64
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter
LOOP_XRAM2MIDI_A8_1:
	cpl	a
	mov	b,#5
	mul	ab
	anl	a,#01111111b
	mov	r0,a
	mov	a,#59
	subb	a,r0
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	jmp	LOOP_XRAM2MIDI_Weiter

LOOP_XRAM2MIDI_A9:
	MOVX	A,@r1			;Werte aus XRAM 
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
LOOP_XRAM2MIDI_Weiter:
	mov	midi_send_bytes,#3
	setb	midi_send_flag
	jnb	midi_send_flag2,LOOP_XRAM2MIDI_1
	mov  	SFRPAGE,#UART1_PAGE
	setb	TI1
	clr	midi_send_flag2
LOOP_XRAM2MIDI_1:
	jb	midi_send_flag,$
	INC	r1
	CJNE	r1,#DCO1FINE+1,LOOP_XRAM2MIDI_hlp	;sende von LFO1RATE bis DCO1FINE (02h-56h)
	jmp	LOOP_XRAM2MIDI_3

LOOP_XRAM2MIDI_hlp:
	jmp	LOOP_XRAM2MIDI

LOOP_XRAM2MIDI_3:
	MOV	dptr,#BANK1CONTENT	;Quelle Start
	mov	r1,#057h		;Start Ziel
LOOP_XRAM2MIDI_2:
	mov	a,#0B0H
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	a,r1
	mov	r0,#smidibyte2		;sende 57h-5Ch
	movx	@r0,a
	MOVX	A,@dptr			;Werte aus XRAM
	anl	a,#01111111b
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#3
	setb	midi_send_flag
	jb	midi_send_flag,$
	INC	r1
	inc	dptr
	CJNE	r1,#05Dh,LOOP_XRAM2MIDI_2

	mov	a,#0B0H			;sende Programm-Nummer
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	a,#05Dh
	mov	r0,#smidibyte2		
	movx	@r0,a
	mov	a,PROGRAM
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#3
	setb	midi_send_flag
	jb	midi_send_flag,$

	mov	a,#0B0H			;sende DCO1_INC_RESTART 
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	a,#05Eh
	mov	r0,#smidibyte2		
	movx	@r0,a
	mov	r0,#DCO1_INC_RESTART
	movx	a,@r0 
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#3
	setb	midi_send_flag
	jb	midi_send_flag,$

	mov	a,#0B0H			;sende DCO2_INC_RESTART 
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	a,#05Fh
	mov	r0,#smidibyte2		
	movx	@r0,a
	mov	r0,#DCO2_INC_RESTART
	movx	a,@r0 
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#3
	setb	midi_send_flag
	jb	midi_send_flag,$

	mov	a,#0F0H			;Sende Midi Sysex für Midi Kanal
	mov	r0,#smidibyte5
	movx	@r0,a
	mov	a,#07Dh
	mov	r0,#smidibyte4
	movx	@r0,a
	mov	a,#00h
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	r1,#CHANNEL
	movx	a,@r1
	anl	a,#00001111b
	mov	r0,#smidibyte2
	movx	@r0,a
	mov	a,#0F7h
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#5
	setb	midi_send_flag
	jb	midi_send_flag,$

	mov	a,#0F0H			;Sende Midi Mode
	mov	r0,#smidibyte5
	movx	@r0,a
	mov	a,#07Dh
	mov	r0,#smidibyte4
	movx	@r0,a
	mov	a,#01h
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	r1,#CHANNEL
	movx	a,@r1
	anl	a,#00110000b
	swap	a
	inc	a
	mov	r0,#smidibyte2
	movx	@r0,a
	mov	a,#0F7h
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#5
	setb	midi_send_flag
	jb	midi_send_flag,$

	mov	a,#0F0H			;Sende XOR
	mov	r0,#smidibyte5
	movx	@r0,a
	mov	a,#07Dh
	mov	r0,#smidibyte4
	movx	@r0,a
	mov	a,#04h
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	r1,#CHANNEL
	movx	a,@r1
	anl	a,#01000000b
	swap	a
	rr	a
	rr	a
	mov	r0,#smidibyte2
	movx	@r0,a
	mov	a,#0F7h
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#5
	setb	midi_send_flag
	jb	midi_send_flag,$

	CLR	MIDI_LED

	ret

;**** Midi Sysex Empfang ***************************************************************************************

;Midi Sysex: $F0, $7D, 	$00 (Midi Kanal),			$MidiKanal,						$F7
;			$01 (Midi Mode)				$00 (Poly) /$01 (Dual) /$02 (Split) /$03 (Multi),	$F7
;			$02 (Receive Midi CC für Modul 2)	$00 (Off) /$01 (On),					$F7
;			$03 (Receive Midi CC für Modul 1)	$00 (Off) /$01 (On),					$F7
;			$04 (XOR Sample-Byte)			$00 (Off) /$01 (On),					$F7
;			$05 (LOAD_EN)				$xx,							$F7				
;			$06 (SAVE_EN)				$xx,							$F7
;			$07 (PROGRAM)				$0 - 127,						$F7
;			$08 (COPY_EN)				$xx,							$F7
;			$09 (COPY_SD_EN)			$xx,							$F7
;			$0A (COPY_B1_EN)			$xx,							$F7			

MIDI_Sysex_Data_raus_h:											
	jmp	MIDI_Sysex_Data_raus

MIDI_Sysex_Data:
	mov	r0,a							;bit0-3 für Kanal, bit4-7 für MidiMode
	mov	a,sysex_bytes_count
	cjne	a,#01h,MIDI_Sysex_Data_1
	mov	a,r0
	cjne	a,#07Dh,MIDI_Sysex_Data_raus_h				;Hersteller ID=7Dh für Entwicklungszwecke
	mov	sysex_bytes_count,#02h
	jmp	irq_end
MIDI_Sysex_Data_1:
	cjne	a,#02h,MIDI_Sysex_Data_11				;sysex_bytes_count=2?
	mov	a,r0
	cjne	a,#00h,MIDI_Sysex_Data_2				;00h für Midikanal ändern
	mov	sysex_bytes_count,#03h
	jmp	irq_end
MIDI_Sysex_Data_2:
	cjne	a,#01h,MIDI_Sysex_Data_3				;01h für MidiMode ändern
	mov	sysex_bytes_count,#04h
	jmp	irq_end
MIDI_Sysex_Data_3:
	cjne	a,#03h,MIDI_Sysex_Data_4				;03h für Receive CC en/dis
	mov	sysex_bytes_count,#05h
	jmp	irq_end
MIDI_Sysex_Data_4:
	cjne	a,#04h,MIDI_Sysex_Data_5				;04h für XOR Samplewerte on/off
	mov	sysex_bytes_count,#06h
	jmp	irq_end
MIDI_Sysex_Data_5:
	cjne	a,#05h,MIDI_Sysex_Data_6				;05h für LOAD_EN
	mov	sysex_bytes_count,#07h
	jmp	irq_end
MIDI_Sysex_Data_6:
	cjne	a,#06h,MIDI_Sysex_Data_7				;06h für SAVE_EN
	mov	sysex_bytes_count,#08h
	jmp	irq_end
MIDI_Sysex_Data_7:
	cjne	a,#07h,MIDI_Sysex_Data_8				;07h für PROGRAM
	mov	sysex_bytes_count,#09h
	jmp	irq_end
MIDI_Sysex_Data_8:
	cjne	a,#08h,MIDI_Sysex_Data_9				;08h für COPY_EN
	mov	sysex_bytes_count,#0Ah
	jmp	irq_end
MIDI_Sysex_Data_9:
	cjne	a,#09h,MIDI_Sysex_Data_10				;09h für COPY_SD_EN
	mov	sysex_bytes_count,#0Bh
	jmp	irq_end
MIDI_Sysex_Data_10:
	cjne	a,#0Ah,MIDI_Sysex_Data_raus_h				;0Ah für COPY_B1_EN
	mov	sysex_bytes_count,#0Ch
	jmp	irq_end

MIDI_Sysex_Data_11:
	cjne	a,#03h,MIDI_Sysex_Data_22				;Midikanal
	mov	r1,#CHANNEL				
	MOVX	A,@R1
	anl	a,#11110000b						;MidiMode holen
	add	a,r0							;Neuen Midikanal hinzuaddieren	
	movx	@r1,a							;bit0-3 für Kanal, bit4-7 für MidiMode speichern
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_22:
	cjne	a,#04h,MIDI_Sysex_Data_33				;MidiMode
	mov	a,r0							;00h (OFF),01h(Poly),02h(Dual),03h(Split),04h(Multi)
	jz	MIDI_Sysex_Data_22_1
	dec	a							;00h(Poly),01h(Dual),02h(Split),03h(Multi)
MIDI_Sysex_Data_22_1:
	swap	a							;00h,10h,20h,30h
	anl	a,#11110000b		
	mov	r0,a														
	mov	r1,#CHANNEL
	movx	a,@r1
	anl	a,#00001111b						;Midikanal holen
	add	a,r0							;Neuen MidiMode hinzuaddieren
	MOVX	@R1,A							;bit0-3 für Kanal, bit4-7 für MidiMode speichern
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_33:
	cjne	a,#05h,MIDI_Sysex_Data_44				;CC en/dis
	mov	a,r0
	jnz	MIDI_Sysex_Data_33_1
	clr	rcv_midi_cc
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_33_1:
	setb	rcv_midi_cc
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_44:
	cjne	a,#06h,MIDI_Sysex_Data_55				;XOR en/dis
	mov	a,r0
	jnz	MIDI_Sysex_Data_44_1
	clr	xor_on_off
	mov	r1,#CHANNEL				
	MOVX	A,@R1
	clr	acc.6							;Bit6 in CHANNEL löschen da kein XOR	
	movx	@r1,a		
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_44_1:
	setb	xor_on_off
	mov	r1,#CHANNEL				
	MOVX	A,@R1
	setb	acc.6							;Bit6 in CHANNEL setzen da XOR	
	movx	@r1,a		
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_55:
	cjne	a,#07h,MIDI_Sysex_Data_66				;LOAD_EN
	setb	LOAD_EN
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_66:
	cjne	a,#08h,MIDI_Sysex_Data_77				;SAVE_EN
	setb	SAVE_EN
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_77:
	cjne	a,#09h,MIDI_Sysex_Data_88				;PROGRAM
	mov	a,r0
	mov	PROGRAM,a
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_88:
	cjne	a,#0Ah,MIDI_Sysex_Data_99				;COPY_EN
	setb	COPY_EN
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_99:
	cjne	a,#0Bh,MIDI_Sysex_Data_AA				;COPY_SD_EN
	setb	COPY_SD_EN
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_AA:
	cjne	a,#0Ch,MIDI_Sysex_Data_raus				;COPY_B1_EN
	setb	COPY_B1_EN
	mov	sysex_bytes_count,#0ffh
	jmp	irq_end
MIDI_Sysex_Data_raus:							
	clr	midi_sysex_rcv_flag
	mov	sysex_bytes_count,#0					
	jmp	irq_end

;***** Midi Irq **********************************************************************************************************

MIDI_IRQ:
	push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push	00
	push	01				;R1 auf den Stapel

	mov  	SFRPAGE,#UART1_PAGE
	mov 	a,scon1
	jbc 	acc.1,irq_ret
	jbc 	acc.0,irq_rx
irq_ret:
	mov 	scon1,a
	jnb	midi_send_flag,irq_end
	mov	a,midi_send_bytes
	cjne	a,#05,irq_ret_1
	mov	r0,#smidibyte5
	movx	a,@r0
	mov	sbuf1,a
	dec	midi_send_bytes
	jmp	irq_end
irq_ret_1:
	cjne	a,#04,irq_ret_2
	mov	r0,#smidibyte4
	movx	a,@r0
	mov	sbuf1,a
	dec	midi_send_bytes
	jmp	irq_end
irq_ret_2:
	cjne	a,#03,irq_ret_3
	mov	r0,#smidibyte1
	movx	a,@r0
	mov	sbuf1,a
	dec	midi_send_bytes
	jmp	irq_end
irq_ret_3:
	mov	a,midi_send_bytes
	cjne	a,#02,irq_ret_4
	mov	r0,#smidibyte2
	movx	a,@r0
	mov	sbuf1,a
	dec	midi_send_bytes
	jmp	irq_end
irq_ret_4:
	mov	a,midi_send_bytes
	cjne	a,#01,irq_end
	mov	r0,#smidibyte3
	movx	a,@r0
	mov	sbuf1,a
	dec	midi_send_bytes
	clr	midi_send_flag
irq_end:
	pop	01
	pop	00
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti

MIDI_Sysex_Data_h:
	jmp	MIDI_Sysex_Data
irq_rx: mov  	SFRPAGE,#UART1_PAGE
	mov 	scon1,a
	mov 	a,sbuf1	
        jb	midi_sysex_rcv_flag,MIDI_Sysex_Data_h	;wenn F0 angekommen dann Sysex Daten Empfang		
	jb 	acc.7,irq_cmd			;wenn größer/gleich 80h dann Command Byte
	;jnb 	midicmdf,irq_end		;wenn Command Byte = Realtime (>=F0) dann raus
	jb 	midishort,irq_sto1_h		;	
	jbc 	midi2nd,irq_sto2_h
	setb 	midi2nd
	mov 	midibyte1,a
	sjmp 	irq_end
irq_sto1_h:
	jmp	irq_sto1
irq_sto2_h:
	jmp	irq_sto2
irq_cmd:
	cjne 	a,#0f0h,$+3
	jnc 	irq_realt			;wenn >= F0 dann Realtime
	mov 	midicmd,a
	clr 	midi2nd
	anl 	a,#0f0h
	cjne 	a,#0c0h,irq_c1
irq_shrt:
	setb 	midishort
	setb 	midicmdf
	jmp 	irq_end
irq_c1:
	cjne 	a,#0d0h,irq_c2
	sjmp 	irq_shrt
irq_c2: clr 	midishort
	setb 	midicmdf
	jmp 	irq_end
irq_realt:
	clr 	midicmdf
	cjne 	a,#0F0h,irq_realt_exclusiv	;Midi Exclusiv Data Start
	setb	midi_sysex_rcv_flag
	mov	sysex_bytes_count,#1
	jmp	irq_end
irq_realt_exclusiv:
	cjne 	a,#0F7h,irq_realt_clock		;Midi Exclusiv Data Ende
	clr	midi_sysex_rcv_flag
	mov	sysex_bytes_count,#0
	jmp	irq_end
irq_realt_clock:
	cjne 	a,#0F8h,irq_realt_start		;Midi Clock
	cpl	MidiCLKflag			;Bit toggelt bei jedem Clock Signal
	jnb	MidiSyncLFO1,irq_realt_sync_LFO2
	djnz	LFO1_CLK_z1,irq_realt_sync_LFO2
	mov	r1,#LFO1_CLK
	movx	a,@r1
	mov	LFO1_CLK_z1,a
	mov	LFO1_help,#0
irq_realt_sync_LFO2:
	jnb	MidiSyncLFO2,irq_realt_sync_DCO1M
	djnz	LFO2_CLK_z1,irq_realt_sync_DCO1M
	mov	r1,#LFO2_CLK
	movx	a,@r1
	mov	LFO2_CLK_z1,a
	mov	LFO2_help,#0
irq_realt_sync_DCO1M:
	jnb	MidiSyncDCO1MOD,irq_realt_sync_DCO2M
	djnz	DCO1M_CLK_z1,irq_realt_sync_DCO2M
	mov	r1,#DCO1_INC_MIDI_CLK	
	movx	a,@r1
	mov	DCO1M_CLK_z1,a
	setb	MidiCLKflag_DCO1M			;Setze Flag für MIDISync Impuls angekommen 
irq_realt_sync_DCO2M:
	jnb	MidiSyncDCO2MOD,irq_realt_start
	djnz	DCO2M_CLK_z1,irq_realt_start
	mov	r1,#DCO2_INC_MIDI_CLK	
	movx	a,@r1
	mov	DCO2M_CLK_z1,a
	setb	MidiCLKflag_DCO2M			;Setze Flag für MIDISync Impuls angekommen 			
irq_realt_start:						
	cjne 	a,#0FAh,irq_realt_cont			;Midi Start
	jmp	irq_end
irq_realt_cont:						;Midi Continue
	cjne 	a,#0FBh,irq_realt_stop
	jmp	irq_end
irq_realt_stop:						;Midi Stop
	cjne 	a,#0FCh,irq_realt_raus
irq_realt_raus:
	jmp	irq_end
irq_sto1:
	mov 	midibyte1,a
irq_sto2:
	mov 	midibyte2,a

	MOV	A,midicmd
	anl	a,#00001111b			;Empfangener Kanal einblenden
	mov	b,a
	mov	r1,#CHANNEL
	movx	a,@r1				;Kanalnummer (0-15)
	anl	a,#00001111b
	xrl	a,b				
	jz	Kanal_ok			;Wenn Kanal o.k. dann springe, sonst raus
	jmp	irq_end
Kanal_ok:					;Kanal o.k.
	mov	a,midicmd
	ANL	A,#0f0h				
	cjne	a,#80h,weiter_90h		;Note Off empfangen?
	jmp	Note_OFF			;dann weiter zu Note OFF
weiter_90h:
	CJNE	A,#90h,Weiter_B0_Hlp		;Wenn kein 90h für Note On dann weiter mit B0
	SETB	MIDI_LED
	MOV	A,midibyte2			;Anschlagdyn holen
	CJNE	A,#0h,Note_ON			;Wenn 0 dann Note OFF sonst Note ON
Note_OFF:
	mov	voice_pos,#01h			;Note Off einleiten
	mov	r1,#Taste1
Note_off_such:
	mov	a,@r1
	cjne	a,midibyte1,Note_off_Weiter
	mov	a,voice_end			
	orl	a,voice_pos			
	mov	voice_end,a			;Release Phase DCA einschalten	
	mov	a,voice_end_DCF
	orl	a,voice_pos	
	mov	voice_end_DCF,a			;Release Phase DCF einschalten
	mov	a,voice_pos			
	cpl	a
	anl	a,voice_start
	mov	voice_start,a			;Attack Phase DCA ausschalten	
	mov	a,voice_pos			
	cpl	a	
	anl	a,voice_start_DCF
	mov	voice_start_DCF,a		;Attack Phase DCF ausschalten
	mov	a,voice_pos			
	cpl	a
	anl	a,voice_ds
	mov	voice_ds,a			;Decay Phase DCA ausschalten
	mov	a,voice_pos			
	cpl	a
	anl	a,voice_ds_DCF
	mov	voice_ds_DCF,a			;Decay Phase DCF ausschalten
	clr	MIDI_LED
	jmp	irq_end
Note_off_Weiter:
	mov	a,voice_pos
	rl	a				;Position der zu löschenden voice.x bestimmen
	mov	voice_pos,a
	inc	r1
	cjne	r1,#Taste4+1,Note_off_Such
Note_off_end:
	jmp	irq_end	

Weiter_B0_Hlp:
	jmp	Weiter_B0

Note_ON:					;Note On einleiten
	mov	r1,#CHANNEL
	movx	a,@r1
	anl	a,#11110000b
	cjne	a,#00100000b,Note_ON_no_Split	;Split Mode?
	mov	a,#65h-36			;Taste F5 als Splitpunkt
	cjne	a,midibyte1,$+3
	jc	Note_off_end			;wenn gedrückte Taste größer/gleich als Splitpunkt F5 dann raus	
Note_ON_no_Split:	
	mov	r1,#LFO1KYB			;1=Keyboard Sync = off, 0=on
	movx	a,@r1
	jz	no_LFO1_KEYB_SYNC
	mov	LFO1_help,#0			;Startwert für LFO1 neu setzten bei jedem Tastendruck
no_LFO1_KEYB_SYNC:
	mov	r1,#LFO2KYB			;1=Keyboard Sync = off, 0=on
	movx	a,@r1
	jz	no_LFO2_KEYB_SYNC
	mov	LFO2_help,#0			;Startwert für LFO1 neu setzten bei jedem Tastendruck
no_LFO2_KEYB_SYNC:
				
	mov	voice_mem,#00
	mov	voice_pos,#0feh			;note on
	mov	r1,#Taste1
Voice_Such_Play:
	mov	a,@r1
	cjne	a,midibyte1,Voice_Weiter_Play
	mov	a,voice_ds			
	anl	a,voice_pos
	mov	voice_ds,a			;DCA Decay ausschalten, da gleiche Taste wiederholt gedrückt
	mov	a,voice_ds_DCF			
	anl	a,voice_pos
	mov	voice_ds_DCF,a			;DCF Decay ausschalten, da gleiche Taste wiederholt gedrückt
	mov	a,voice_end			
	anl	a,voice_pos			
	mov	voice_end,a			;DCA Release ausschalten, da gleiche Taste wiederholt gedrückt	
	mov	a,voice_end_DCF			
	anl	a,voice_pos		
	mov	voice_end_DCF,a			;DCF Release ausschalten, da gleiche Taste wiederholt gedrückt
	mov	a,voice_pos			
	cpl	a
	orl	a,voice_start
	mov	voice_start,a			;DCA Attack einschalten	
	mov	a,voice_pos			
	cpl	a
	orl	a,voice_start_DCF			
	mov	voice_start_DCF,a		;DCF Attack einschalten
	mov	a,voice				
	anl	a,voice_pos			
	mov	voice,a				;Voice ausschalten, da gleiche Taste wiederholt gedrückt
	mov	a,voice_mem			;Startwert 0h für DCA Attack wieder herstellen
	add	a,#ADSR1
	mov	r1,a			
	mov	a,#0h				;DCA Attack Reload
	mov	@r1,a	
	mov	a,voice_mem			;Startwert 0h für DCF Attack wieder herstellen
	add	a,#ADSR1_DCF
	mov	r1,a
	mov	a,#0h				;DCF Attack Reload
	mov	@r1,a			
	sjmp	Voice_Clear
Voice_Weiter_Play:
	mov	a,voice_pos
	rl	a				;Position der zu setzenden voice.x bestimmen
	mov	voice_pos,a
	inc	voice_mem
	inc	r1
	cjne	r1,#Taste4+1,Voice_Such_Play
	
Voice_Clear:		
	mov	voice_mem,#00
	mov	voice_pos,#01
	mov	a,voice
	cjne	a,#00001111b,Voice_frei		;wenn alle 4 Tasten gedrückt
	mov	r1,#CHANNEL
	movx	a,@r1
	anl	a,#11110000b
	jnz	Note_ON_Clear_1			;wenn Poly Mode (0)
	jmp	irq_end				;dann raus
Note_ON_Clear_1:				;sonst Voice 2/3 alternierend abschalten, wenn mehr als 4 Tasten gedr.
	cpl	voice23
	jnb	voice23,Voice_Clear_2
	clr	Voice2_ds
	clr	Voice2_end
	setb	Voice2_start
	clr	voice2
	mov	a,voice
	jmp	Voice_Frei
Voice_Clear_2:
	clr	Voice3_ds
	clr	Voice3_end
	setb	Voice3_start
	clr	voice3
	mov	a,voice

Voice_Frei:
	mov	r0,a
Voice_Loop:
	mov	a,r0	
	rrc	a				
	mov	r0,a
	jnc	Voice_Set
	mov	a,voice_pos
	rl	a				;zu setzende voice.x ermitteln
	mov	voice_pos,a
	inc	voice_mem
	jmp	Voice_Loop
Voice_Set:
	mov	a,voice_mem			;Startwert für DCA Attack wieder herstellen
	add	a,#ADSR1
	mov	r1,a
	mov	a,#0h				;DCA Attack Reload
	mov	@r1,a	
	mov	a,voice_mem			;Startwert für DCF Attack wieder herstellen
	add	a,#ADSR1_DCF
	mov	r1,a
	mov	a,#0h				;DCF Attack Reload
	mov	@r1,a	
	mov	a,voice_start			
	orl	a,voice_pos
	mov	voice_start,a			;DCA Attack einschalten
	mov	a,voice_start_DCF			
	orl	a,voice_pos
	mov	voice_start_DCF,a		;DCF Attack einschalten
	mov	a,voice
	orl	a,voice_pos			;voice.x einschalten
	mov	voice,a
	mov	a,voice_mem
	add	a,#Taste1
	mov	r1,a
	mov	a,midibyte1
	mov	@r1,a				;Tastenwert 1-4 speichern
	mov	a,voice_mem
	add	a,#ANSCHLAGDYN			;Speicherstelle für ersten AnschlagWert
	push	acc
	mov	dptr,#Velo_Tab			;Log Velocity Tabelle
	mov	r1,#VELOKURVE
	movx	a,@r1
	add	a,dph				;0-3 auf high byte hinzu addieren 
	mov	dph,a
	pop	acc
	mov	r1,a
	mov	a,midibyte2
	movc	a,@a+dptr
	jnb	velocity,Voice_No_Velo
	movx	@r1,a				;AnschlagDynamik im XRAM speichern
	jmp	irq_end
Voice_No_Velo:
	mov	a,#0ffh
	movx	@r1,a
Voice_Belegt:
	jmp 	irq_end

;***********************************************************************************************
;* CONTROLLER (B0) *****************************************************************************
;***********************************************************************************************

Weiter_E0_hlp:
	jmp	Weiter_E0
b0_no_wheel_hlp:
        jmp     b0_no_wheel

Weiter_B0:
	CJNE	A,#0B0h,Weiter_E0_hlp		;Wenn kein B0h dann springe zu E0h

	mov	a,midibyte1
	cjne	a,#01,b0_no_wheel_hlp		;wurde das Wheel betätigt?				
	MOV	R1,#MODWHEELTAR
	movx	a,@r1
	cjne	a,#00,b0_01_1			;Wheel = OFF
	jmp	irq_end
b0_01_1:
	cjne	a,#01,b0_01_2
	MOV	R1,#DCFFREQ			;Wheel = DCF Freq
	MOV	A,midibyte2
	rl	a
	inc	a								
	MOVX	@r1,A	
	jmp	irq_end
b0_01_2:
	cjne	a,#02,b0_01_3
	MOV	R1,#DCFRESO			;Wheel = DCF Res
	MOV	A,midibyte2
	rl	a								
	MOVX	@r1,A
	jmp	irq_end
b0_01_3:
	cjne	a,#03,b0_01_4			;Wheel = DCO1/2 LFO1
	MOV	R1,#DCO1LFO1
	MOV	A,midibyte2				
	rl	a					
	MOVX	@R1,A
	MOV	R1,#DCO2LFO1					
	MOVX	@R1,A
	jmp	irq_end
b0_01_4:
	cjne	a,#04,b0_01_5			;Wheel = DCO1/2 LFO2
	MOV	R1,#DCO1LFO2
	MOV	A,midibyte2				
	rl	a					
	MOVX	@R1,A
	MOV	R1,#DCO2LFO2					
	MOVX	@R1,A
	jmp	irq_end
b0_01_5:
	cjne	a,#05,b0_01_6			;Wheel = DCO1 WAVE
	MOV	A,midibyte2
	MOV	R1,#DCO1WAVE
	MOVX	@R1,A
	jmp	irq_end
b0_01_6:
	cjne	a,#06,b0_01_7			;Wheel = DCO2 WAVE
	MOV	A,midibyte2
	MOV	R1,#DCO2WAVE
	MOVX	@R1,A
	jmp	irq_end
b0_01_7:					;Wheel = DCO1 und DCO2
	cjne	a,#07,b0_01_8
	MOV	A,midibyte2
	MOV	R1,#DCO1WAVE
	MOVX	@R1,A
	MOV	R1,#DCO2WAVE
	MOVX	@R1,A
	jmp	irq_end
b0_01_8:					;Wheel = DCO1 WAVE INC-Wert
	cjne	a,#8,b0_01_9
	MOV	A,midibyte2
	mov	r1,#DCO1_WAVE_INC		
	movx	@r1,a
	jmp	irq_end
b0_01_9:					;Wheel = DCO2 WAVE INC-Wert
	cjne	a,#9,b0_01_10
	MOV	A,midibyte2
	mov	r1,#DCO2_WAVE_INC		
	movx	@r1,a
	jmp	irq_end
b0_01_10:
	cjne	a,#10,b0_01_11
	MOV	A,midibyte2
	mov	r1,#DCO1_WAVE_INC		;Wheel = DCO1 WAVE INC-Wert
	movx	@r1,a
	mov	r1,#DCO2_WAVE_INC		;Wheel = DCO2 WAVE INC-Wert
	movx	@r1,a
	jmp	irq_end
b0_01_11:					;Wheel = EFX Parameter A
	cjne	a,#11,b0_01_12
	MOV	R1,#EFX_A
	MOV	A,midibyte2
	rl	a
	cpl	a			
	MOVX	@R1,A
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM0,#042h	
    	mov  	PCA0CPH0,a
	jmp	irq_end
b0_01_12:					;Wheel = EFX Parameter B
	cjne	a,#12,b0_01_13
	MOV	R1,#EFX_B
	MOV	A,midibyte2
	rl	a
	cpl	a			
	MOVX	@R1,A	
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM1,#042h	
    	mov  	PCA0CPH1,a						
	jmp	irq_end
b0_01_13:					;Wheel = EFX Parameter C
	cjne	a,#13,b0_01_14
	MOV	R1,#EFX_C
	MOV	A,midibyte2
	rl	a
	cpl	a			
	MOVX	@R1,A	
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM2,#042h	
    	mov  	PCA0CPH2,a						
	jmp	irq_end
b0_01_14:
	cjne	a,#14,b0_01_15
	jmp	irq_end
b0_01_15:
	cjne	a,#15,b0_01_16
	jmp	irq_end
b0_01_16:
	jmp	irq_end

irq_end_h:
	jmp	irq_end
	
b0_no_wheel:
	jnb	rcv_midi_cc,irq_end_h		;Wenn rcv_midi_cc = 0 dann kein Midi CC Empfang
	setb	MIDI_CC_Changed
	mov	a,midibyte1			;0-127
	jbc	acc.6,b0_high			
	clr	c
	rlc	a
	clr	c
	rlc	a
	mov	dptr,#b0_Verzweigungstabelle1
	jmp	@a+dptr
b0_high:clr	c
	rlc	a
	clr	c
	rlc	a
	mov	dptr,#b0_Verzweigungstabelle2
	jmp	@a+dptr

b0_Verzweigungstabelle1:
	ljmp	b0_00				;0-15
	nop
	ljmp	b0_01
	nop
	ljmp	b0_02
	nop
	ljmp	b0_03
	nop
	ljmp	b0_04
	nop
	ljmp	b0_05
	nop
	ljmp	b0_06
	nop
	ljmp	b0_07
	nop
	ljmp	b0_08
	nop
	ljmp	b0_09
	nop
	ljmp	b0_0a
	nop
	ljmp	b0_0b
	nop
	ljmp	b0_0c
	nop
	ljmp	b0_0d
	nop
	ljmp	b0_0e
	nop
	ljmp	b0_0f
	nop	
	ljmp	b0_10				;16-31
	nop
	ljmp	b0_11
	nop
	ljmp	b0_12
	nop
	ljmp	b0_13
	nop 
	ljmp	b0_14
	nop 
	ljmp	b0_15
	nop 
	ljmp	b0_16
	nop 
	ljmp	b0_17
	nop 
	ljmp	b0_18
	nop 
	ljmp	b0_19
	nop 
	ljmp	b0_1a
	nop 
	ljmp	b0_1b
	nop 
	ljmp	b0_1c
	nop 
	ljmp	b0_1d
	nop 
	ljmp	b0_1e
	nop 
	ljmp	b0_1f
	nop 
	ljmp	b0_20				;32-47
	nop 
	ljmp	b0_21
	nop 
	ljmp	b0_22
	nop 
	ljmp	b0_23
	nop 
	ljmp	b0_24
	nop 
	ljmp	b0_25
	nop 
	ljmp	b0_26
	nop 
	ljmp	b0_27
	nop 
	ljmp	b0_28
	nop 
	ljmp	b0_29
	nop 
	ljmp	b0_2a
	nop 
	ljmp	b0_2b
	nop 
	ljmp	b0_2c
	nop 
	ljmp	b0_2d
	nop 
	ljmp	b0_2e
	nop 
	ljmp	b0_2f
	nop 
	ljmp	b0_30				;48-63
	nop 
	ljmp	b0_31
	nop 
	ljmp	b0_32
	nop 
	ljmp	b0_33
	nop 
	ljmp	b0_34
	nop 
	ljmp	b0_35
	nop 
	ljmp	b0_36
	nop 
	ljmp	b0_37
	nop 
	ljmp	b0_38
	nop 
	ljmp	b0_39
	nop 
	ljmp	b0_3a
	nop 
	ljmp	b0_3b
	nop 
	ljmp	b0_3c
	nop 
	ljmp	b0_3d
	nop 
	ljmp	b0_3e
	nop 
	ljmp	b0_3f
	nop
b0_Verzweigungstabelle2: 
	ljmp	b0_40				;64-79
	nop 
	ljmp	b0_41
	nop 
	ljmp	b0_42
	nop 
	ljmp	b0_43
	nop 
	ljmp	b0_44
	nop 
	ljmp	b0_45
	nop 
	ljmp	b0_46
	nop 
	ljmp	b0_47
	nop 
	ljmp	b0_48
	nop 
	ljmp	b0_49
	nop 
	ljmp	b0_4a
	nop 
	ljmp	b0_4b
	nop 
	ljmp	b0_4c
	nop 
	ljmp	b0_4d
	nop 
	ljmp	b0_4e
	nop 
	ljmp	b0_4f	
	nop 
	ljmp	b0_50				;80-95
	nop 
	ljmp	b0_51
	nop 
	ljmp	b0_52
	nop 
	ljmp	b0_53
	nop 
	ljmp	b0_54
	nop 
	ljmp	b0_55
	nop 
	ljmp	b0_56
	nop 
	ljmp	b0_57
	nop 
	ljmp	b0_58
	nop 
	ljmp	b0_59
	nop 
	ljmp	b0_5a
	nop 
	ljmp	b0_5b
	nop 
	ljmp	b0_5c
	nop 
	ljmp	b0_5d
	nop 
	ljmp	b0_5e
	nop 
	ljmp	b0_5f
	nop 
	ljmp	b0_60				;96-111
	nop 
	ljmp	b0_61
	nop 
	ljmp	b0_62
	nop 
	ljmp	b0_63
	nop 
	ljmp	b0_64
	nop 
	ljmp	b0_65
	nop 
	ljmp	b0_66
	nop 
	ljmp	b0_67
	nop 
	ljmp	b0_68
	nop 
	ljmp	b0_69
	nop 
	ljmp	b0_6a
	nop 
	ljmp	b0_6b
	nop 
	ljmp	b0_6c
	nop 
	ljmp	b0_6d
	nop 
	ljmp	b0_6e
	nop 
	ljmp	b0_6f
	nop 
	ljmp	b0_70				;112-127
	nop 
	ljmp	b0_71
	nop 
	ljmp	b0_72
	nop 
	ljmp	b0_73
	nop 
	ljmp	b0_74
	nop 
	ljmp	b0_75
	nop 
	ljmp	b0_76
	nop 
	ljmp	b0_77
	nop 
	ljmp	b0_78
	nop 
	ljmp	b0_79
	nop 
	ljmp	b0_7a
	nop 
	ljmp	b0_7b
	nop 
	ljmp	b0_7c
	nop 
	ljmp	b0_7d
	nop 
	ljmp	b0_7e
	nop 
	ljmp	b0_7f
	nop

b0_00:						;Bank
	jmp	irq_end
b0_01:						;Wheel
        jmp	irq_end
b0_02:	
	MOV	R1,#LFO1RATE			;LFO1 RATE (255-1)
	MOV	A,midibyte2
	rl	a				;0-254
	cpl	a				;255-1
	MOVX	@R1,A
	jmp	irq_end
b0_03:	
	MOV	R1,#LFO1DELAY			;LFO1 DELAY (1-255)
	MOV	A,midibyte2
	rl	a				;0-254
	inc	a				;1-255
	MOVX	@R1,A
	jmp	irq_end
b0_04:						
	MOV	R1,#LFO1WAVE			;LFO1 WAVE ;(0-127)
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_05:						;LFO1 RANGE (1,64,127)
	MOV	R1,#LFO1RANGE		
	MOV	A,midibyte2
	rl	a				;2,128,254
	cpl	a				;253,127,1
	MOVX	@R1,A
	jmp	irq_end
b0_06:						;LFO1 KEYBOARD SYNC (0=OFF, 1= ON)
	mov	r1,#LFO1KYB
	MOV	A,midibyte2
	MOVX	@R1,a
	jmp	irq_end
b0_07:						;LFO1 MIDI SYNC (0=OFF, 1= ON)
	mov	r1,#LFO1MIDI
	MOV	A,midibyte2
	MOVX	@R1,a
	mov	c,acc.0
	mov	MidiSyncLFO1,c					
	jmp	irq_end
b0_08:						;LFO2 RATE (254-0)
	MOV	R1,#LFO2RATE			
	MOV	A,midibyte2
	rl	a				;0-254
	cpl	a				;255-1
	MOVX	@R1,A
	jmp	irq_end
b0_09:						;LFO2 DELAY (1-255)
	MOV	R1,#LFO2DELAY			
	MOV	A,midibyte2
	rl	a				;0-254
	inc	a				;1-255
	MOVX	@R1,A
	jmp	irq_end
b0_0a:						;LFO2 WAVE ;(0-127)
	MOV	R1,#LFO2WAVE			
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_0b:						;LFO2 RANGE
	MOV	R1,#LFO2RANGE		
	MOV	A,midibyte2
	rl	a				;0,126,252
	cpl	a				;255,129,3
	MOVX	@R1,A
	jmp	irq_end
b0_0c:						;LFO2 KEYBOARD SYNC (0=OFF, 1= ON)
	mov	r1,#LFO2KYB
	MOV	A,midibyte2
	MOVX	@R1,a
	jmp	irq_end
b0_0d:						;LFO2 MIDI SYNC (0=OFF, 1= ON)
	mov	r1,#LFO2MIDI
	MOV	A,midibyte2
	MOVX	@R1,a
	mov	c,acc.0
	mov	MidiSyncLFO2,c	
	jmp	irq_end
b0_0e:						;LFO1 MIDI Clock Rate
	mov	r1,#LFO1_CLK
	MOV	A,midibyte2			
	cjne 	a,#00,b0_0e_1
	mov	a,#24
	movx	@r1,a				;1/4
	mov	LFO1_CLK_z1,a
	jmp	irq_end
b0_0e_1:
	cjne	a,#01,b0_0e_2
	mov	a,#12
	movx	@r1,a				;1/8
	mov	LFO1_CLK_z1,a
	jmp	irq_end
b0_0e_2:
	cjne	a,#02,b0_0e_3
	mov	a,#6
	movx	@r1,a				;1/16
	mov	LFO1_CLK_z1,a
	jmp	irq_end
b0_0e_3:
	cjne	a,#03,b0_0e_4
	mov	a,#3
	movx	@r1,a				;1/32
	mov	LFO1_CLK_z1,a
	jmp	irq_end
b0_0e_4:
	mov	a,#1
	movx	@r1,a				;1/96
	mov	LFO1_CLK_z1,a				
	jmp	irq_end
b0_0f:						;LFO2 MIDI Clock Rate
	mov	r1,#LFO2_CLK
	MOV	A,midibyte2
	cjne 	a,#00,b0_0f_1
	mov	a,#24
	movx	@r1,a				;1/4
	mov	LFO2_CLK_z1,a
	jmp	irq_end
b0_0f_1:
	cjne	a,#01,b0_0f_2
	mov	a,#12
	movx	@r1,a				;1/8
	mov	LFO2_CLK_z1,a
	jmp	irq_end
b0_0f_2:
	cjne	a,#02,b0_0f_3
	mov	a,#6
	movx	@r1,a				;1/16
	mov	LFO2_CLK_z1,a
	jmp	irq_end
b0_0f_3:
	cjne	a,#03,b0_0f_4
	mov	a,#3
	movx	@r1,a				;1/32
	mov	LFO2_CLK_z1,a
	jmp	irq_end
b0_0f_4:
	mov	a,#1
	movx	@r1,a				;1/96
	mov	LFO2_CLK_z1,a				
	jmp	irq_end
b0_10:						;DCO1 LFO1 VALUE
	MOV	R1,#DCO1LFO1
	MOV	A,midibyte2				
	rl	a					
	MOVX	@R1,A
	jmp	irq_end
b0_11:						;DCO1 LFO2 VALUE
	MOV	R1,#DCO1LFO2
	MOV	A,midibyte2				
	rl	a					
	MOVX	@R1,A
	jmp	irq_end
b0_12:
	MOV	R1,#DCO1BANK			;DCO1 WAVETABLE BANK
	MOV	A,midibyte2								
	MOVX	@R1,A
	cjne	a,#00,b0_12_1
	clr	Voice1_Bank			;Bank1
	clr	Voice1_PWM
	jmp	irq_end
b0_12_1:
	cjne	a,#01,b0_12_2
	setb	Voice1_Bank			;Bank2
	clr	Voice1_PWM
	jmp	irq_end
b0_12_2:					;Bank3 = PWM WAVETABLE BANK
	clr	Voice1_Bank
	setb	Voice1_PWM
	jmp	irq_end
b0_13:						;DCO1 SCALE
	mov	a,midibyte2
	mov	dptr,#SCALE_TAB			
	movc 	a,@a+dptr		
	MOV	R1,#DCO1SCALE
	MOVX	@R1,A
	jmp	irq_end
b0_14:						;DCO1 WAVE
	MOV	R1,#DCO1WAVE
	MOV	A,midibyte2
	jnb	Voice1_PWM,bo_14_no_pwm
	clr	acc.6
bo_14_no_pwm:
	MOVX	@R1,A
	MOV	R1,#DCO1WaveSave		;DCO1Wave sichern
	MOVX	@R1,A
	jmp	irq_end
b0_15:						;DCO1 WAVE MODULATION DEPHT ;(0-127)
	MOV	R1,#DCO1_WAVE_INC
	MOV	A,midibyte2		
	MOVX	@R1,A
	MOV	DCO1M_Tmp,a			;Hilfsbyte für DCO1MOD INC
	CJNE	A,#0,b0_15_1			;wenn INC-Wert = 0 dann alten Wert wieder hestellen
	mov	R1,#DCO1WaveSave
	movx	a,@r1
	mov	r1,#DCO1Wave			;DCO1Wave wieder herstellen
	movx	@r1,a
b0_15_1:jmp	irq_end
b0_16:						;DCO1 WAVE MODULATION TIME (1-128(0))
	MOV	R1,#DCO1_INC_TIME
	MOV	A,midibyte2		
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_17:	
	MOV	R1,#DCO1_INC_MIDI_SYNC		;DCO1 WAVE MOD MIDI SYNC
	MOV	A,midibyte2					
	MOVX	@R1,A
	mov	c,acc.0
	mov	MidiSyncDCO1MOD,c	
	jmp	irq_end
b0_18:
	MOV	R1,#DCO1_INC_TIME_2		;2. INC-Wert
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_19:
	MOV	R1,#DCO1_INC_SYNC		;DCO1WAVE INC KEYB SYNC
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_1a:						;Modwheel Target
	MOV	R1,#MODWHEELTAR
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_1b:					
	mov	r1,#DCO1_INC_LOOP		;DCO1 INC im LOOP oder ONETIME
	MOV	A,midibyte2
	movx	@r1,a
	mov	c,acc.0
	mov	DCO1WaveInc_OneTime,c
	jmp	irq_end
b0_1c:
	MOV	r1,#DCO1_INC_MIDI_CLK		;DCO1 Wave Mod Midi Clock
	MOV	A,midibyte2				
	cjne 	a,#00,b0_1c_1
	mov	a,#24
	movx	@r1,a				;1/4
	mov	DCO1M_CLK_z1,a
	jmp	irq_end
b0_1c_1:
	cjne	a,#01,b0_1c_2
	mov	a,#12
	movx	@r1,a				;1/8
	mov	DCO1M_CLK_z1,a
	jmp	irq_end
b0_1c_2:
	cjne	a,#02,b0_1c_3
	mov	a,#6
	movx	@r1,a				;1/16
	mov	DCO1M_CLK_z1,a
	jmp	irq_end
b0_1c_3:
	cjne	a,#03,b0_1c_4
	mov	a,#3
	movx	@r1,a				;1/32
	mov	DCO1M_CLK_z1,a				
	jmp	irq_end
b0_1c_4:
	mov	a,#01
	movx	@r1,a				;1/96
	mov	DCO1M_CLK_z1,a				
	jmp	irq_end
b0_1d:
	MOV	R1,#ADSR1_INV			;ADSR1 INV
	MOV	A,midibyte2									
	MOVX	@R1,A
	mov	c,acc.0
	mov	ADSR1_INV_flag,c						
	jmp	irq_end
b0_1e:
	MOV	R1,#ADSR1_LOG			;ADSR1 LOG
	MOV	A,midibyte2									
	MOVX	@R1,A
	mov	c,acc.0
	mov	ADSR1_LOG_flag,c					
	jmp	irq_end
b0_1f:
	jmp	irq_end
b0_20:	
	MOV	R1,#DCO2LFO1			;DCO2 LFO1 ;(0-254)
	MOV	A,midibyte2				
	rl	a					
	MOVX	@R1,A
	jmp	irq_end				
b0_21:	
	MOV	R1,#DCO2LFO2			;DCO2 LFO2 ;(0-254)
	MOV	A,midibyte2				
	rl	a					
	MOVX	@R1,A					
	jmp	irq_end
b0_22:
	MOV	R1,#DCO2BANK			;DCO2 WAVETABLE BANK
	MOV	A,midibyte2								
	MOVX	@R1,A
	cjne	a,#00,b0_22_1
	clr	Voice2_Bank			;Bank1
	clr	Voice2_PWM
	jmp	irq_end
b0_22_1:
	cjne	a,#01,b0_22_2
	setb	Voice2_Bank			;Bank2
	clr	Voice2_PWM
	jmp	irq_end
b0_22_2:					;Bank3 = PWM WAVETABLE BANK
	clr	Voice2_Bank
	setb	Voice2_PWM		
	jmp	irq_end
b0_23:						;DCO2 Scale
	mov	a,midibyte2
	mov	dptr,#SCALE_TAB			
	movc 	a,@a+dptr		
	MOV	R1,#DCO2SCALE
	MOVX	@R1,A
	jmp	irq_end
b0_24:						
	MOV	R1,#DCO2WAVE			;DCO2 WAVE
	MOV	A,midibyte2
	jnb	Voice2_PWM,bo_24_no_pwm
	clr	acc.6
bo_24_no_pwm:
	MOVX	@R1,A
	MOV	R1,#DCO2WaveSave		;DCO2Wave sichern
	MOVX	@R1,A
	jmp	irq_end
b0_25:						;DCO2 WAVE MODULATION DEPHT ;(0-127)
	MOV	R1,#DCO2_WAVE_INC
	MOV	A,midibyte2		
	MOVX	@R1,A
	CJNE	A,#0,b0_25_1			;wenn INC-Wert = 0 dann alten Wert wieder hestellen
	mov	R1,#DCO2WaveSave
	movx	a,@r1
	mov	r1,#DCO2Wave			;DCO2Wave wieder herstellen
	movx	@r1,a
b0_25_1:jmp	irq_end
b0_26:						;DCO2 WAVE MODULATION TIME (1-128(0))
	MOV	R1,#DCO2_INC_TIME
	MOV	A,midibyte2		
	inc	a			
	MOVX	@R1,A
	jmp	irq_end	
b0_27:	
	MOV	R1,#DCO2NOISE			;DCO2 Noise
	MOV	A,midibyte2
	rl	a					
	MOVX	@R1,A				;0-254				
	jmp	irq_end
b0_28:						;DCO2WAVE INC KEYB SYNC
	MOV	R1,#DCO2_INC_SYNC		
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_29:	
	MOV	R1,#DCO2_INC_MIDI_SYNC		;DCO2 WAVE MOD MIDI SYNC
	MOV	A,midibyte2					
	MOVX	@R1,A
	mov	c,acc.0
	mov	MidiSyncDCO2MOD,c
	jmp	irq_end
b0_2a:	
	MOV	R1,#DCO2_INC_TIME_2		;2. INC-Wert
	MOV	A,midibyte2
	MOVX	@R1,A
	jmp	irq_end
b0_2b:	
	mov	r1,#DCO2_INC_LOOP		;DCO2 INC im LOOP oder ONETIME
	MOV	A,midibyte2
	movx	@r1,a
	mov	c,acc.0
	mov	DCO2WaveInc_OneTime,c
	jmp	irq_end
b0_2c:						;DCO2 Wave Mod Midi Clock
	MOV	r1,#DCO2_INC_MIDI_CLK	
	MOV	A,midibyte2
	cjne 	a,#00,b0_2c_1
	mov	a,#24
	movx	@r1,a				;1/4
	mov	DCO2M_CLK_z1,a
	jmp	irq_end
b0_2c_1:
	cjne	a,#01,b0_2c_2
	mov	a,#12
	movx	@r1,a				;1/8
	mov	DCO2M_CLK_z1,a
	jmp	irq_end
b0_2c_2:
	cjne	a,#02,b0_2c_3
	mov	a,#6
	movx	@r1,a				;1/16
	mov	DCO2M_CLK_z1,a
	jmp	irq_end
b0_2c_3:
	cjne	a,#03,b0_2c_4
	mov	a,#3
	movx	@r1,a				;1/32	
	mov	DCO2M_CLK_z1,a
	jmp	irq_end
b0_2c_4:
	mov	a,#1
	movx	@r1,a				;1/96	
	mov	DCO2M_CLK_z1,a
	jmp	irq_end
b0_2d:						
	MOV	R1,#DCO2FINELFO1		;DCO2 LFO1 Finetuning
	MOV	A,midibyte2			;0-127
	MOVX	@R1,a
	jnz	b0_2d_1	
	clr 	DCO2FINELFO1FLAG	
	jmp	irq_end
b0_2d_1:
	setb	DCO2FINELFO1FLAG	
	jmp	irq_end
b0_2e:						
	MOV	R1,#DCO2FINELFO2		;DCO2 LFO2 Finetuning
	MOV	A,midibyte2			;0-127
	MOVX	@R1,a	
	jnz	b0_2e_1	
	clr 	DCO2FINELFO2FLAG	
	jmp	irq_end
b0_2e_1:
	setb	DCO2FINELFO2FLAG	
	jmp	irq_end
b0_2f:						;DCO2 Finetuning	
	mov	r1,#DCO2FINE
	MOV	A,midibyte2					
	MOVX	@R1,A
	jnz	b0_2f_1	
	clr 	DCO2FINEFLAG			;Flag für Finetuning = OFF
	jmp	irq_end
b0_2f_1:
	setb	DCO2FINEFLAG			;Flag für Finetuning = ON
	jmp	irq_end
b0_30:						;DCF LFO1 VALUE ;(0-254)
	MOV	R1,#DCFLFO1
	MOV	A,midibyte2
	rl	a					
	MOVX	@R1,a	
	jmp	irq_end
b0_31:						;DCF LFO2 VALUE ;(0-254)
	MOV	R1,#DCFLFO2
	MOV	A,midibyte2
	rl	a					
	MOVX	@R1,a	
	jmp	irq_end
b0_32:						;DCF FREQUENCY
	MOV	R1,#DCFFREQ
	MOV	A,midibyte2
	rl	a				;1-255, Step2 -> k
	inc	a				
	MOVX	@r1,A
	jmp	irq_end
b0_33:						;DCF RESONANCE
	MOV	r1,#DCFRESO
	MOV	A,midibyte2
	rl	a				;0-254, Step2 -> k			
	MOVX	@r1,A			
	jmp	irq_end
b0_34:						;DCF ATTACK (1-255, Step2)
	MOV	R1,#DCFATTACK
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_35:						;DCF DECAY (1-255, Step2)
	MOV	R1,#DCFDECAY
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_36:						;DCF SUSTAIN (1-255, Step2)
	MOV	R1,#DCFSUSTAIN
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_37:						;DCF RELEASE (1-255, Step2)
	MOV	R1,#DCFRELEASE
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_38:
	MOV	R1,#ADSR2_INV			;ADSR2 INV
	MOV	A,midibyte2									
	MOVX	@R1,A
	mov	c,acc.0
	mov	ADSR2_INV_flag,c						
	jmp	irq_end
b0_39:
	MOV	R1,#ADSR2_LOG			;ADSR2 LOG
	MOV	A,midibyte2									
	MOVX	@R1,A
	mov	c,acc.0
	mov	ADSR2_LOG_flag,c					
	jmp	irq_end
b0_3a:						;EFX SEND
	MOV	R1,#EFXSEND
	MOV	A,midibyte2			
	MOVX	@R1,A
	setb	EFX_Send_Changed				
	jmp	irq_end
b0_3b:						;EFX RETURN		
	MOV	R1,#EFXRETURN
	MOV	A,midibyte2			
	MOVX	@R1,A
	setb	EFX_Return_Changed	
	jmp	irq_end
b0_3c:						;EFX TYPE				
	MOV	A,midibyte2			
	cjne	a,#08,$+3			;0-7 = interne Programme
	jnc	b0_3c_1				;wenn < 8 dann 
	anl	a,#00000111b			;Programmwerte 0-7
	orl	a,#01110000b			;T0=0 für interne EFX-Programme, E1-E3 = DIS
	mov	c,Modul1_Play			;Bit für >4 Tasten gedrückt
	mov	acc.7,c	
	mov	EFX_Select,a
	MOV	R1,#EFXTYPE
	MOV	A,midibyte2			
	MOVX	@R1,A
	jmp	irq_end
b0_3c_1:
	cjne	a,#16,$+3
	jnc	b0_3c_2				;wenn >7 und <16 dann 
	anl	a,#00000111b			;Programmwerte 0-7
	orl	a,#01101000b			;E1=0 für extEEPROM1
	mov	c,Modul1_Play			;Bit für >4 Tasten gedrückt
	mov	acc.7,c	
	mov	EFX_Select,a
	MOV	R1,#EFXTYPE
	MOV	A,midibyte2			
	MOVX	@R1,A
	jmp	irq_end
b0_3c_2:
	cjne	a,#24,$+3
	jnc	b0_3c_3				;wenn >15 und <24 dann 
	anl	a,#00000111b			;Programmwerte 0-7
	orl	a,#01011000b			;E2=0 für extEEPROM2
	mov	c,Modul1_Play			;Bit für >4 Tasten gedrückt
	mov	acc.7,c	
	mov	EFX_Select,a
	MOV	R1,#EFXTYPE
	MOV	A,midibyte2			
	MOVX	@R1,A
	jmp	irq_end
b0_3c_3:
	cjne	a,#32,$+3
	jnc	b0_3c_4				;wenn >23 und <32 dann 
	anl	a,#00000111b			;Programmwerte 0-7
	orl	a,#00111000b			;E3=0 für extEEPROM3
	mov	c,Modul1_Play			;Bit für >4 Tasten gedrückt
	mov	acc.7,c	
	mov	EFX_Select,a
	MOV	R1,#EFXTYPE
	MOV	A,midibyte2			
	MOVX	@R1,A
b0_3c_4:				
	jmp	irq_end
b0_3d:						;EFX Variable A				
	MOV	R1,#EFX_A
	MOV	A,midibyte2
	rl	a
	cpl	a			
	MOVX	@R1,A
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM0,#042h	
    	mov  	PCA0CPH0,a
	jmp	irq_end
b0_3e:						;EFX Variable B					
	MOV	R1,#EFX_B
	MOV	A,midibyte2
	rl	a
	cpl	a			
	MOVX	@R1,A	
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM1,#042h	
    	mov  	PCA0CPH1,a						
	jmp	irq_end
b0_3f:						;EFX Variable C				
	MOV	R1,#EFX_C
	MOV	A,midibyte2
	rl	a
	cpl	a			
	MOVX	@R1,A	
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM2,#042h	
    	mov  	PCA0CPH2,a						
	jmp	irq_end
b0_40:						;DCA LFO1 VALUE ;(0-127)
	MOV	R1,#DCALFO1
	MOV	A,midibyte2					
	MOVX	@R1,a
	jz	b0_40_1
	setb    Volume_LFO1_Changed	
	jmp	irq_end
b0_40_1:
	clr	Volume_LFO1_Changed	
	jmp	irq_end
b0_41:						;DCA LFO2 VALUE ;(0-127)
	MOV	R1,#DCALFO2 
	MOV	A,midibyte2				
	MOVX	@R1,a	
	jz	b0_41_1
	setb    Volume_LFO2_Changed	
	jmp	irq_end
b0_41_1:
	clr	Volume_LFO2_Changed	
	jmp	irq_end
b0_42:						;DCA DCO1 ;(0-127)
	MOV	R1,#DCO1VOL
	MOV	A,midibyte2			
	MOVX	@R1,A
	setb	Volume_Changed_DCO1VOL
	jmp	irq_end
b0_43:						;DCA DCO2 ;(0-127)
	MOV	R1,#DCO2VOL
	MOV	A,midibyte2			
	MOVX	@R1,A
	setb	Volume_Changed_DCO2VOL
	jmp	irq_end
b0_44:						;DCA ATTACK (1-255, Step2)
	MOV	R1,#ATTACK
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_45:						;DCA DECAY (1-255, Step2)
	MOV	R1,#DECAY
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_46:						;DCA SUSTAIN (1-255, Step2)
	MOV	R1,#SUSTAIN
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_47:						;DCA RELEASE (1-255, Step2)
	MOV	R1,#RELEASE
	MOV	A,midibyte2
	rl	a
	inc	a			
	MOVX	@R1,A
	jmp	irq_end
b0_48:
	MOV	R1,#DCO1RVOL			;DCO1 Right Volume
	MOV	A,midibyte2			
	MOVX	@R1,A
	setb	Volume_Changed_DCO1RVOL
	jmp	irq_end
b0_49:
	MOV	R1,#DCO2LVOL			;DCO2 Left Volume
	MOV	A,midibyte2			
	MOVX	@R1,A
	setb	Volume_Changed_DCO2LVOL
	jmp	irq_end
b0_4a:
	jmp	irq_end
b0_4b:						;PITCHBEND (0=NORM, 1=WIDE)
	mov	r1,#PITCHBW
	mov	a,midibyte2
	movx	@r1,a
	jz	b0_4b_1
	setb	pitchbflag
	jmp	irq_end
b0_4b_1:
	clr	pitchbflag
	jmp	irq_end
b0_4c:						;VELOCITY (0=OFF, 1=ON)
	mov	r1,#VELO
	MOV	A,midibyte2					
	MOVX	@R1,A
	jz	b0_4c_1
	setb	velocity			;wenn gesentetes Byte > 0 d
	jmp	irq_end
b0_4c_1:
	clr	velocity			;wenn Byte = 0 dann Velocity
	jmp	irq_end				
b0_4d:						;RINGMODULATION (0=OFF, 1=ON)
	mov	r1,#RINGMOD
	MOV	A,midibyte2					
	MOVX	@R1,A		
	jmp	irq_end
b0_4e:						;VELOCITY Kurve (0-3)
	mov	r1,#VELOKURVE
	MOV	A,midibyte2					
	MOVX	@R1,A
	jmp	irq_end
b0_4f:						;Reserviert
	jmp	irq_end
b0_50:						;EFXLFO1
	mov	r1,#EFXLFO1
	mov	a,midibyte2
	rl	a
	movx	@r1,a				
	jmp	irq_end
b0_51:			
	mov	r1,#EFXLFO2
	mov	a,midibyte2
	rl	a
	movx	@r1,a				
	jmp	irq_end
b0_52:						;EFXLFO1 Ziel	
	mov	r1,#EFXLFO1TAR
	mov	a,midibyte2
	anl	a,#00000011b
	movx	@r1,a				
	jmp	irq_end	
b0_53:		
	mov	r1,#EFXLFO2TAR
	mov	a,midibyte2
	anl	a,#00000011b
	movx	@r1,a				
	jmp	irq_end		
b0_54:
	MOV	R1,#DCO1FINELFO1		;DCO1 LFO1 Finetuning
	MOV	A,midibyte2			;0-127
	MOVX	@R1,a
	jnz	b0_54_1	
	clr 	DCO1FINELFO1FLAG	
	jmp	irq_end
b0_54_1:
	setb	DCO1FINELFO1FLAG	
	jmp	irq_end		
b0_55:	
	MOV	R1,#DCO1FINELFO2		;DCO1 LFO2 Finetuning
	MOV	A,midibyte2			;0-127
	MOVX	@R1,a	
	jnz	b0_55_1	
	clr 	DCO1FINELFO2FLAG	
	jmp	irq_end
b0_55_1:
	setb	DCO1FINELFO2FLAG	
	jmp	irq_end	
b0_56:						;DCO1 Finetuning	
	mov	r1,#DCO1FINE
	MOV	A,midibyte2					
	MOVX	@R1,A
	jnz	b0_56_1	
	clr 	DCO1FINEFLAG			;Flag für Finetuning = OFF
	jmp	irq_end
b0_56_1:
	setb	DCO1FINEFLAG			;Flag für Finetuning = ON
	jmp	irq_end
b0_57:						
	jmp	irq_end
b0_58:			
	jmp	irq_end
b0_59:						
	jmp	irq_end
b0_5A:						
	jmp	irq_end	
b0_5b:	
	jmp	irq_end		
b0_5c:	
	jmp	irq_end		
b0_5d:
	jmp	irq_end
b0_5e:
	mov	r1,#DCO1_INC_RESTART
	MOV	A,midibyte2					
	MOVX	@R1,A
	jmp	irq_end
b0_5f:			
	mov	r1,#DCO2_INC_RESTART
	MOV	A,midibyte2					
	MOVX	@R1,A
	jmp	irq_end
b0_60:	
	jmp	irq_end
b0_61:						
	jmp	irq_end
b0_62:						
	jmp	irq_end
b0_63:	
	jmp	irq_end
b0_64:								
	jmp	irq_end
b0_65:			
	jmp	irq_end
b0_66:							
	jmp	irq_end
b0_67:															
	jmp	irq_end
b0_68:							
	jmp	irq_end
b0_69:														
	jmp	irq_end
b0_6a:						
	jmp	irq_end
b0_6b:				
	jmp	irq_end
b0_6c:							
	jmp	irq_end
b0_6d:			
	jmp	irq_end
b0_6e:			
	jmp	irq_end
b0_6f:				
	jmp	irq_end
b0_70:					
	jmp	irq_end
b0_71:		
	jmp	irq_end
b0_72:	
	jmp	irq_end
b0_73:		
	jmp	irq_end
b0_74:		
	jmp	irq_end
b0_75:	
	jmp	irq_end
b0_76:		
	jmp	irq_end
b0_77:						
	jmp	irq_end
b0_78:										
	jmp	irq_end
b0_79:	
	MOV	A,midibyte2
	cjne	a,#01h,$+3		;wenn 0 dann FLASH1 0-127
	jnc	b0_79_1			;wenn >=1 dann weiter
	mov	FLASH_BANK_SOURCE,a
	jmp	irq_end
b0_79_1:
	cjne	a,#02h,$+3		;wenn >=1 und <2 FLASH1 128-255
	jnc	b0_79_2			;wenn >=2 dann weiter
	mov	FLASH_BANK_SOURCE,a
	jmp	irq_end
b0_79_2:
	cjne	a,#03h,$+3		;wenn >=2 und <3 FLASH2
	jnc	b0_79_end		;wenn >=3 dann raus
	mov	FLASH_BANK_SOURCE,a		
b0_79_end:
	jmp	irq_end
b0_7A:	
	mov	a,FLASH_BANK_SOURCE
	cjne	a,#02h,$+3
	jc	b0_7A_1
	MOV	A,midibyte2
	anl	a,#00011111b		;wenn FLASH2 dann nur 32 Samples/Wavetables
	mov	FLASH_SOURCE,a	
	jmp	irq_end
b0_7A_1:
	MOV	A,midibyte2
	mov	FLASH_SOURCE,a		;wenn FLASH1 dann 0-127 Samples/Wavetables						
	jmp	irq_end
b0_7B:	
	MOV	A,midibyte2
	cjne	a,#03h,$+3
	jc	b0_7B_1			;wenn <3 dann Wert nach Bank_Target
	jmp	irq_end
b0_7B_1:
	mov	Bank_Target,a		;Ziel in Bank 1,2 oder 3					
	jmp	irq_end
b0_7C:									
	jmp	irq_end
b0_7D:	
	jmp	irq_end
b0_7E:	
	jmp	irq_end	
b0_7f:			
	jmp	irq_end

;***********************************************************************************************
;* PITCH BEND (E0) *****************************************************************************
;***********************************************************************************************

Weiter_E0:
	CJNE	A,#0E0h,Weiter_E0_Raus		;Wenn kein E0h für Pitch-Bend dann raus
	MOV	A,midibyte2			;2. Byte Pitch-Bend holen
	jb	pitchbflag,Weiter_E0_PitchWide
	MOV	DPTR,#Pitch_Tab			;Werte für +-12 aus Tabelle holen
	jmp	Weiter_E0_PitchNorm
Weiter_E0_PitchWide:
	MOV	DPTR,#Pitch_Tab_Wide		;Werte für +-24 aus Tabelle "Wide" holen
Weiter_E0_PitchNorm:		
	MOVC	A,@A+dptr
	mov	r1,#PITCHB			;Pitchbend Wert	
	movx	@r1,a
Weiter_E0_Raus:
	CJNE	A,#0C0h,Weiter_C0_Raus
	MOV	A,midibyte2			;Program Change
	cjne	a,#10,$+3			;wenn <10 dann c=1
	jnc	Weiter_C0_Raus			;wenn >9 dann raus
	;mov	PROGRAM,a
	;setb 	LOAD_EN
Weiter_C0_Raus:	
	jmp 	irq_end

DCO_PITCH_TAB:
db 32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62
db 64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94
db 96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126
db 128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158
db 158,158,160,162,164,166,168,170,172,174,176,178,180,182,184,186
db 188,190,192,194,196,198,200,202,204,206,208,210,212,214,216,218
db 220,222,224,226,228,230,232,234,236,238,240,242,244,246,248,250
db 252,254,255,255,255,255,255,255,255,255,255,255,255,255,255,255
