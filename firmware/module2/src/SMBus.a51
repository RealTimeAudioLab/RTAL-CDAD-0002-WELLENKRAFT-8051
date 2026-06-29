Anzahl_Bytes	equ	92

EEPROM_Read_PROGRAM_Value:
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A1h		;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,#00h		;I2C EEPROM Speicherplatz $00ffh
	mov	LOW_ADD,#0ffh
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	PROGRAM,WORD
	ret

EEPROM_Write_PROGRAM_Value:	
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A0h		;I2C Adresse 256k EEPROM WRITE
	mov	HIGH_ADD,#00h		;I2C EEPROM Speicherplatz $00ffh
	mov	LOW_ADD,#0ffh
	mov	WORD,PROGRAM
	clr	STO	 
	setb	STA
	ret

Select_I2C_PT2257:			;ACC = 01 für CH1, 02 für CH2, 04 für CH3, 08 für CH4
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#1		;8bit Adresse
	mov	COMMAND,#11100000b	;I2C Adresse pca9548a
	mov	HIGH_ADD,a		;I2C Command
	mov	LOW_ADD,a		;I2C Command
	mov	WORD,a			;Data
	clr	STO
	setb	STA
	ret

EEPROM_Read_BANKCONTENT:	
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A1h		;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,PROGRAM	;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	a,WORD
	ret

EEPROM_Read_Value:
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A1h		;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,#0		;I2C EEPROM Speicherplatz
	mov	LOW_ADD,#0
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	a,WORD
	ret

EEPROM_Write_Value:	
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A0h		;I2C Adresse 256k EEPROM WRITE
	mov	HIGH_ADD,#0		;I2C EEPROM Speicherplatz
	mov	LOW_ADD,#0
	mov	WORD,a
	clr	STO	 
	setb	STA
	ret

EEPROM_Write_Program:
	mov	r0,#Anzahl_Bytes
EEPROM_Write_Program_Loop:
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A0h		;I2C Adresse 256k EEPROM WRITE
	mov	HIGH_ADD,PROGRAM	;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	mov	dptr,#PRG_TAB
	mov	a,r0
	movc	a,@a+dptr
	mov	r1,a
	movx	a,@r1
	mov	WORD,a
	clr	STO	 
	setb	STA
	djnz	r0,EEPROM_Write_Program_Loop

	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A0h		;I2C Adresse 256k EEPROM WRITE
	mov	HIGH_ADD,PROGRAM	;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	mov	dptr,#PRG_TAB
	mov	a,r0
	movc	a,@a+dptr
	mov	r1,a
	movx	a,@r1
	mov	WORD,a
	clr	STO	 
	setb	STA
	ret

EEPROM_Read_Program:
	mov	r0,#Anzahl_Bytes-9
EEPROM_Read_Program_Loop:
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A1h		;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,PROGRAM	;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	dptr,#PRG_TAB
	mov	a,r0
	movc	a,@a+dptr
	mov	r1,a
	mov	a,WORD
	movx	@r1,a	
	djnz	r0,EEPROM_Read_Program_Loop

	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2		;16bit Adresse
	mov	COMMAND,#0A1h		;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,PROGRAM	;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	dptr,#PRG_TAB
	mov	a,r0
	movc	a,@a+dptr
	mov	r1,a
	mov	a,WORD
	movx	@r1,a
	
	MOV	R0,#DCO1WaveSave
	MOVX	a,@R0
	MOV	R0,#DCO1Wave
	MOVX	@R0,a
	MOV	R0,#DCO1BANK						
	MOVX	a,@R0
	mov	c,acc.0
	mov	Voice1_Bank,c
	mov	c,acc.1
	mov	Voice1_PWM,c
	MOV	R0,#DCO1_INC_TIME
	MOVX	a,@R0
	MOV	DCO1_z1,a
	MOV	R0,#DCO1_INC_TIME_2		
	MOVX	a,@R0
	MOV	DCO1_z2,a		
	MOV	R0,#DCO1_WAVE_INC
	MOVX	a,@R0
	mov	DCO1M_Tmp,a
	MOV	r0,#DCO1_INC_MIDI_SYNC				
	MOVX	a,@r0
	mov	c,acc.0
	mov	MidiSyncDCO1MOD,c
	mov	r0,#DCO1_INC_LOOP		
	movx	a,@r0
	mov	c,acc.0
	mov	DCO1WaveInc_OneTime,c
	mov	a,#255
	mov	r0,#DCO1GESVOL		;DCO1 Gesamtlautstärke für alle DCO1 Voices
	movx	@r0,a

	MOV	R0,#DCO2WaveSave
	MOVX	a,@R0
	MOV	R0,#DCO2Wave
	MOVX	@R0,a
	MOV	R0,#DCO2BANK						
	MOVX	a,@R0
	mov	c,acc.0
	mov	Voice2_Bank,c
	mov	c,acc.1
	mov	Voice2_PWM,c
	MOV	R0,#DCO2_INC_TIME
	MOVX	a,@R0
	MOV	DCO2_z1,a
	MOV	R0,#DCO2_INC_TIME_2		
	MOVX	a,@R0
	MOV	DCO2_z2,a		
	MOV	R0,#DCO2_WAVE_INC
	MOVX	a,@R0
	mov	DCO2M_Tmp,a
	MOV	r0,#DCO2_INC_MIDI_SYNC				
	MOVX	a,@r0
	mov	c,acc.0
	mov	MidiSyncDCO2MOD,c
	mov	r0,#DCO2_INC_LOOP		
	movx	a,@r0
	mov	c,acc.0
	mov	DCO2WaveInc_OneTime,c
	mov	a,#255
	mov	r0,#DCO2GESVOL		;DCO2 Gesamtlautstärke für alle DCO2 Voices
	movx	@r0,a

	mov	r0,#ADSR1_INV
	MOVX	a,@R0
	mov	c,acc.0
	mov	ADSR1_INV_flag,c
	mov	r0,#ADSR1_LOG
	MOVX	a,@R0
	mov	c,acc.0
	mov	ADSR1_LOG_flag,c
	mov	r0,#ADSR2_INV
	MOVX	a,@R0
	mov	c,acc.0
	mov	ADSR2_INV_flag,c
	mov	r0,#ADSR2_LOG
	MOVX	a,@R0
	mov	c,acc.0
	mov	ADSR2_LOG_flag,c

	MOV	R0,#ATTACK			
	MOVX	a,@R0
	MOV	ADSR_Z3,a		
	MOV	R0,#DECAY			
	MOVX	a,@R0
	MOV	ADSR_Z5,a		
	MOV	R0,#RELEASE		
	MOVX	a,@R0			
	MOV	ADSR_Z2,a

	MOV	R0,#DCFATTACK				
	movx	a,@r0
	MOV	ADSR_DCF_Z3,a		
	MOV	R0,#DCFDECAY					
	movx	a,@r0
	MOV	ADSR_DCF_Z5,a		
	MOV	R0,#DCFRELEASE					
	movx	a,@r0
	MOV	ADSR_DCF_Z2,a	

	mov	r0,#PITCHB
	MOVX	a,@R0
	mov	c,acc.0
	mov	pitchbflag,c

	mov	r0,#VELO		
	movx	a,@R0			
	mov	c,acc.0
	mov	velocity,c

	mov	r0,#LFO1_CLK		
	movx	a,@R0
        mov	LFO1_CLK_z1,a			
	mov	r0,#LFO2_CLK		
	movx	a,@R0
        mov	LFO2_CLK_z1,a	
	mov	r0,#LFO1MIDI
	MOVX	a,@R1			
	mov	c,acc.0
	mov	MidiSyncLFO1,c
	mov	r0,#LFO2MIDI
	MOVX	a,@R1
	mov	c,acc.0
	mov	MidiSyncLFO2,c
	MOV	R0,#LFO1RATE			
	movx	a,@r0
	mov	LFO1_z1,a
	mov	r0,#LFO1RANGE
	movx	a,@r0
	mov	LFO1_z3,a
	MOV	R0,#LFO2RATE			
	movx	a,@r0
	mov	LFO2_z1,a
	mov	r0,#LFO2RANGE
	movx	a,@r0
	mov	LFO2_z3,a
	MOV	R0,#LFO1DELAY		
	MOVX	a,@R0
	MOV	LFO1_z2,a		
	MOV	R0,#LFO2DELAY				
	MOVX	a,@R0
	MOV	LFO2_z2,a

	MOV	R0,#DCALFO1					
	MOVX	a,@R0
	jz	EEPROM_Read_Program_5
	setb    Volume_LFO1_Changed	
	jmp	EEPROM_Read_Program_6
EEPROM_Read_Program_5:
	clr	Volume_LFO1_Changed	
EEPROM_Read_Program_6:		
	MOV	R0,#DCALFO2 				
	MOVX	a,@R0
	jz	EEPROM_Read_Program_7
	setb    Volume_LFO2_Changed	
	jmp	EEPROM_Read_Program_8
EEPROM_Read_Program_7:
	clr	Volume_LFO2_Changed	
EEPROM_Read_Program_8:		

	setb	Volume_Changed_DCO2LVOL
	setb	Volume_Changed_DCO2VOL
	setb	Volume_Changed_DCO1RVOL
	setb	Volume_Changed_DCO1VOL
	setb	EFX_Send_Changed

	setb	DCO1FINEFLAG
	setb	DCO2FINEFLAG

	mov	r0,#CHANNEL			;XOR on/off lesen
	movx	a,@r0
	mov	c,acc.6
	mov	xor_on_off,c

	mov	r0,#87
	call	EEPROM_Read_BANKCONTENT		;BANK1CONTENT lesen
	mov	r1,a
	MOV	R0,#BANK1CONTENT
	MOVX	a,@R0
	cjne	a,01h,EEPROM_Read_Bank1		
	mov	r0,#84
	call	EEPROM_Read_BANKCONTENT		;BANK1BANKCONTENT lesen	
	mov	r1,a
	MOV	R0,#BANK1BANKCONTENT
	MOVX	a,@R0
	cjne	a,01h,EEPROM_Read_Bank1		;wenn gleich dann weiter sonst lade Sample nach
EEPROM_Read_Bank2_?:
	mov	r0,#88
	call	EEPROM_Read_BANKCONTENT		;BANK2CONTENT lesen
	mov	r1,a
	MOV	R0,#BANK2CONTENT
	MOVX	a,@R0
	cjne	a,01h,EEPROM_Read_Bank2
	mov	r0,#85
	call	EEPROM_Read_BANKCONTENT		;BANK2BANKCONTENT lesen	
	mov	r1,a
	MOV	R0,#BANK2BANKCONTENT
	MOVX	a,@R0
	cjne	a,01h,EEPROM_Read_Bank2		;wenn gleich dann weiter sonst lade Sample nach
EEPROM_Read_Bank3_?:
	mov	r0,#89
	call	EEPROM_Read_BANKCONTENT		;BANK3CONTENT lesen
	mov	r1,a
	MOV	R0,#BANK3CONTENT
	MOVX	a,@R0
	cjne	a,01h,EEPROM_Read_Bank3
	mov	r0,#86
	call	EEPROM_Read_BANKCONTENT		;BANK3BANKCONTENT lesen	
	mov	r1,a
	MOV	R0,#BANK3BANKCONTENT
	MOVX	a,@R0
	cjne	a,01h,EEPROM_Read_Bank3		;wenn gleich dann weiter sonst lade Sample nach
	jmp	EEPROM_Read_Program_End
EEPROM_Read_Bank1:
	mov	a,r1				;Bank1Content aus EEPROM
	MOV	R0,#BANK1CONTENT
	MOVX	@R0,a				;schreibe neuen Bank1Content
	mov	FLASH_SOURCE,a
	mov	r0,#84
	call	EEPROM_Read_BANKCONTENT		;BANK1BANKCONTENT lesen
	MOV	R0,#BANK1BANKCONTENT
	MOVX	@R0,a				;schreibe neuen Bank1BANKContent
	mov	FLASH_BANK_SOURCE,a
	mov	Bank_Target,#0			;Ziel ist Bank1
	call	Copy_Flash2Bank
	jmp	EEPROM_Read_Bank2_?
EEPROM_Read_Bank2:
	mov	a,r1
	MOV	R0,#BANK2CONTENT
	MOVX	@R0,a
	mov	FLASH_SOURCE,a
	mov	r0,#85
	call	EEPROM_Read_BANKCONTENT		;BANK2BANKCONTENT lesen
	MOV	R0,#BANK2BANKCONTENT
	MOVX	@R0,a				;schreibe neuen Bank2BANKContent
	mov	FLASH_BANK_SOURCE,a			
	mov	Bank_Target,#1			;Ziel ist Bank2
	call	Copy_Flash2Bank
	jmp	EEPROM_Read_Bank3_?
EEPROM_Read_Bank3:
	mov	a,r1
	MOV	R0,#BANK3CONTENT
	MOVX	@R0,a
	mov	FLASH_SOURCE,a	
	mov	r0,#86
	call	EEPROM_Read_BANKCONTENT		;BANK3BANKCONTENT lesen
	MOV	R0,#BANK3BANKCONTENT
	MOVX	@R0,a				;schreibe neuen Bank3BANKContent
	mov	FLASH_BANK_SOURCE,a
	mov	Bank_Target,#2			;Ziel ist Bank3
	call	Copy_Flash2Bank
EEPROM_Read_Program_End:
	mov	r0,#90				;DCO1_INC_RESTART
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2			;16bit Adresse
	mov	COMMAND,#0A1h			;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,PROGRAM		;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	dptr,#PRG_TAB
	mov	a,r0
	movc	a,@a+dptr
	mov	r1,a
	mov	a,WORD
	movx	@r1,a

	mov	r0,#91				;DCO2_INC_RESTART
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#2			;16bit Adresse
	mov	COMMAND,#0A1h			;I2C Adresse 256k EEPROM READ
	mov	HIGH_ADD,PROGRAM		;I2C EEPROM Speicherplatz
	mov	LOW_ADD,r0
	clr	STO
	setb	STA 
	nop
	jb	SM_BUSY,$
	nop
	mov	dptr,#PRG_TAB
	mov	a,r0
	movc	a,@a+dptr
	mov	r1,a
	mov	a,WORD
	movx	@r1,a
	ret

PRG_TAB:
	db LFO1RATE, LFO1DELAY, LFO1WAVE, LFO1RANGE, LFO1KYB, LFO1MIDI, LFO2RATE, LFO2DELAY
	db LFO2WAVE, LFO2RANGE, LFO2KYB, LFO2MIDI, LFO1_CLK, LFO2_CLK
	db DCO1LFO1, DCO1LFO2, DCO1BANK, DCO1SCALE, DCO1WAVESAVE, DCO1_WAVE_INC, DCO1_INC_TIME, DCO1_INC_MIDI_SYNC
	db DCO1_INC_TIME_2, DCO1_INC_SYNC, MODWHEELTAR, DCO1_INC_MIDI_CLK, ADSR1_INV, ADSR1_LOG 
	db DCO2LFO1, DCO2LFO2, DCO2BANK, DCO2SCALE, DCO2WAVESAVE, DCO2_WAVE_INC, DCO2_INC_TIME, DCO2NOISE
	db DCO2_INC_SYNC, DCO2_INC_MIDI_SYNC, DCO2_INC_TIME_2, DCO2_INC_MIDI_CLK, ADSR2_INV, ADSR2_LOG, DCO2FINE, DCO2FINELFO1, DCO2FINELFO2
	db DCFLFO1, DCFLFO2, DCFFREQ, DCFRESO, DCFATTACK, DCFDECAY, DCFSUSTAIN, DCFRELEASE
	db DCALFO1, DCALFO2, DCO1VOL, DCO2VOL, ATTACK, DECAY, SUSTAIN, RELEASE, DCO1RVOL, DCO2LVOL
	db CHANNEL, PITCHBW, VELO, RINGMOD, VELOKURVE, PITCHB
	db EFXSEND, EFXRETURN, EFXTYPE, EFX_A, EFX_B, EFX_C, EFXLFO1, EFXLFO2, EFXLFO1TAR, EFXLFO2TAR
	db DCO1_INC_LOOP, DCO2_INC_LOOP, DCO1FINELFO1, DCO1FINELFO2, DCO1FINE
	db BANK1BANKCONTENT, BANK2BANKCONTENT, BANK3BANKCONTENT, BANK1CONTENT, BANK2CONTENT, BANK3CONTENT
	db DCO1_INC_RESTART, DCO2_INC_RESTART
PRG_TAB_ENDE:

;*************************************************************************************************
;* I2C (SMBus) IRQ *******************************************************************************
;*************************************************************************************************

SMBus_IRQ:
	push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push	00
	push	01

   mov    SFRPAGE,#SMB0_Page               
   mov   A, SMB0STA                   
   anl   A, #7Fh                      
   mov   DPTR, #SMB_STATE_TABLE      
   jmp   @A+DPTR                      

SMB_STATE_TABLE:  

   ; SMB_BUS_ERROR
   org    SMB_STATE_TABLE + SMB_BUS_ERROR
   
      setb  STO
      clr   SM_BUSY
      jmp   SMB_ISR_END               ; Jump to exit ISR              

   ; SMB_START
   org SMB_STATE_TABLE + SMB_START
      jmp   SMB_START_2
     
   ; SMB_RP_START
   org    SMB_STATE_TABLE + SMB_RP_START

      mov   SMB0DAT, COMMAND	      ; Load slave address + R
      clr   STA                       ; Manually clear START bit
      jmp   SMB_ISR_END

   ; SMB_MTADDACK
   org   SMB_STATE_TABLE + SMB_MTADDACK

      mov   SMB0DAT, HIGH_ADD 
      jmp   SMB_ISR_END

   ; SMB_MTADDNACK
   org SMB_STATE_TABLE + SMB_MTADDNACK

      setb  STO                              
      setb  STA
      jmp   SMB_ISR_END

   ; SMB_MTDBACK
   org    SMB_STATE_TABLE + SMB_MTDBACK
      jmp   SMB_MTDBACK_2
         
   ; SMB_MTDBNACK
   org SMB_STATE_TABLE + SMB_MTDBNACK

      setb  STO
      setb  STA
      jmp   SMB_ISR_END

   ; SMB_MTARBLOST
   org SMB_STATE_TABLE + SMB_MTARBLOST

      setb  STO
      setb  STA
      jmp   SMB_ISR_END

   ; SMB_MRADDACK
   org SMB_STATE_TABLE + SMB_MRADDACK

      clr   AA                       ; NACK sent on acknowledge cycle
      jmp   SMB_ISR_END

   ; SMB_MRADDNACK
   org SMB_STATE_TABLE + SMB_MRADDNACK
      
      clr   STO
      setb  STA
      jmp   SMB_ISR_END

   ; SMB_MRDBACK
   org SMB_STATE_TABLE + SMB_MRDBACK

      setb  STO
      clr   SM_BUSY
      jmp   SMB_ISR_END

   ; SMB_MRDBNACK
   org SMB_STATE_TABLE + SMB_MRDBNACK
   
      mov   WORD, SMB0DAT
      setb  STO
      clr   SM_BUSY   
      jmp   SMB_ISR_END

SMB_START_2:
      mov   a,COMMAND
      anl   a,#11111110b
      mov   SMB0DAT,a                 ; Load slave address + W
      clr   STA                       ; Manually clear START bit
      jmp   SMB_ISR_END               ; Jump to exit ISR

SMB_MTDBACK_2:
      mov   a,BYTE_NUMBER
      cjne  a,#02h,SMB_MTDBACK_2_1
      mov   SMB0DAT,LOW_ADD
      dec   BYTE_NUMBER
      jmp   SMB_ISR_END
SMB_MTDBACK_2_1:
      mov   a,BYTE_NUMBER
      cjne  a,#01h,SMB_MTDBACK_2_0
      mov   a,COMMAND
      jnb   acc.0,NUMBER_WRITE		; If R/W=READ, sent repeated START.
      clr   STO                              
      setb  STA 
      jmp   SMB_ISR_END
NUMBER_WRITE:	
      mov   SMB0DAT, WORD		; If R/W=WRITE, load byte to write.
      dec   BYTE_NUMBER
      jmp   SMB_ISR_END
SMB_MTDBACK_2_0:			; If BYTE_NUMBER=0, transfer is finished.
      setb  STO
      clr   SM_BUSY 
  
SMB_ISR_END:
        clr     SI
        pop	01
	pop	00
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti