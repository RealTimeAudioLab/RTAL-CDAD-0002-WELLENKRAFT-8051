Copy_Bank1_to_extFlash:				;Kopiert Bank 1 (32k) nach extFlash2 0-31
	clr	EA
	mov	a,FLASH_Source		;0-31
	anl	a,#00011111b
	clr	c
	rrc	a
	mov	DPH32,a			;DPH32=0-15
	clr	a
	mov	acc.7,c
	mov	dph,a			;DPTR=0000h oder 8000h
	mov	dpl,#0
	lcall	SST25VF020_32kErase_2	;Lösche 32k in FLASH2
	mov	a,PSBANK
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#10h			;Bank1
	mov	PSBANK,a
	mov	dptr,#8000h
Copy_Bank1_to_extFlash_2:
	clr	a
	movc	a,@a+dptr
	mov	r0,a
	push	dph
	mov	a,FLASH_SOURCE
	jb	acc.0,Copy_Bank1_to_extFlash_1
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a
Copy_Bank1_to_extFlash_1:
	mov	a,r0
	call	_SST25VF020_WriteByte_2
	pop	dph
	inc	dptr
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM3,#042h
	mov	a,dph	
   	mov  	PCA0CPH3,a
	mov	a,dph
	orl	a,dpl
	jnz	Copy_Bank1_to_extFlash_2
	setb	ea
	ret

Copy_SDCARD2Bank:				;Kopiert Samples von der SDCARD ins intFLASH
	mov	a,Bank_Target
	cjne	a,#0,Copy_SDCARD2Bank_1
	call	Flash_Erase_Bank1		;BANK1 löschen
	jmp	Copy_SDCARD2Bank_weiter
Copy_SDCARD2Bank_1:
	cjne	a,#1,Copy_SDCARD2Bank_2
	call	Flash_Erase_Bank2		;BANK2 löschen
	jmp	Copy_SDCARD2Bank_weiter
Copy_SDCARD2Bank_2:
	cjne	a,#2,Copy_SDCARD2Bank_end
	call	Flash_Erase_Bank3		;BANK3 löschen
Copy_SDCARD2Bank_weiter:
	mov	arduino_pointer_L,#0
	mov	arduino_pointer_H,#80h		; Start bei $8000h

	mov	a,#0B0H
	mov	r0,#smidibyte1
	movx	@r0,a
	mov	a,#78h
	mov	r0,#smidibyte2
	movx	@r0,a
	mov	a,#01h
	mov	r0,#smidibyte3
	movx	@r0,a
	mov	midi_send_bytes,#3
	setb	midi_send_flag
	mov  	SFRPAGE,#UART1_PAGE
	setb	TI1
	jb	midi_send_flag,$

	mov  	SFRPAGE,#UART0_PAGE		; Datenübertragung für Arduino einschalten
	setb	ren0				; EN UART0 RX
	setb	es0				; Enable UART0 Interrupt
	mov  	SFRPAGE,#CONFIG_PAGE
	jnb	arduino_busy,$			; Warte, bis Arduino anfängt zu senden
	jb	arduino_busy,$			; Warte, bis Arduino fertig gesendet hat
	mov  	SFRPAGE,#UART0_PAGE		; Datenübertragung für Arduino ausschalten
	clr	ren0				; DIS UART0 RX
	clr	es0				; DIS UART0 Interrupt

Copy_SDCARD2Bank_end:			
	ret

Copy_FLASH2BANK_1_hlp:
	ljmp	Copy_FLASH2BANK_1
Copy_Flash2Bank:				;Kopiert 128 Samples aus FLASH1 ins intFLASH Bank1
	mov	a,Bank_Target
	cjne	a,#0,Copy_FLASH2BANK_1_hlp
	call	Flash_Erase_Bank1		;BANK1 löschen
	mov	a,FLASH_BANK_SOURCE
	jb	acc.1,Copy_FLASH2BANK_12	;wenn = 0 dann FLASH1, wenn 1 dann FLASH2
	mov	dptr,#8000h			;FLASH1 als Quelle
Copy_FLASH2BANK_LOOP11:
	push	dph
	mov	a,FLASH_SOURCE			;0-127
	clr	c
	rrc	a
	mov	DPH32,a				;DPH32 = 0-63
	jc	Copy_FLASH2BANK_LOOP11_2						
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a				;lese aus X0000h - X7FFFh
Copy_FLASH2BANK_LOOP11_2:			;oder lese aus X8000h - XFFFFh
	mov	a,FLASH_BANK_SOURCE
	jnb	acc.0,Copy_FLASH2BANK_LOOP11_1  ;wenn = 0 dann FLASH1 0-128
	mov	a,DPH32
	orl	a,#01000000b			;wenn Flag gesetzt dann 128-255 32k Samples
	mov	DPH32,a
Copy_FLASH2BANK_LOOP11_1:
	clr	EA
	call	exFLASH_Read			
	setb	EA	
	call	Flash_Write_Bank1		;schreibe immer nach 8000h - FFFFh
	pop	dph					
	inc	dptr
	mov	a,dph
	push	acc
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM3,#042h	
	cpl	a
    	mov  	PCA0CPH3,a
	pop	acc
	orl	a,dpl
	jnz	Copy_FLASH2BANK_LOOP11
	mov	r0,#BANK1CONTENT		;Samplenummer für Bank1
	mov	a,FLASH_SOURCE			;0-127
	movx	@r0,a
	mov	r0,#BANK1BANKCONTENT		;FLASH für Bank1
	mov	a,FLASH_BANK_SOURCE		;0,1,2
	movx	@r0,a
	ret	

Copy_FLASH2BANK_12:				;FLASH2 als Quelle
	mov	dptr,#8000h	
Copy_FLASH2BANK_LOOP12:
	push	dph
	mov	a,FLASH_SOURCE
	anl	a,#00011111b			;Begrenzung auf 32 Samples
	clr	c
	rrc	a
	mov	DPH32,a				;32k Blöcke für DPH32
	jc	Copy_FLASH2BANK_LOOP12_1						
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a				
Copy_FLASH2BANK_LOOP12_1:
	clr	EA
	call	exFLASH_Read_2			
	setb	EA		
	call	Flash_Write_Bank1		;schreibe immer nach 8000h - FFFFh
	pop	dph
	inc	dptr
	mov	a,dph
	push	acc
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM3,#042h
	cpl	a	
    	mov  	PCA0CPH3,a
	pop	acc
	orl	a,dpl
	jnz	Copy_FLASH2BANK_LOOP12
	mov	r0,#BANK1CONTENT		;Samplenummer für Bank1
	mov	a,FLASH_SOURCE			;0-127
	movx	@r0,a
	mov	r0,#BANK1BANKCONTENT		;FLASH für Bank1
	mov	a,FLASH_BANK_SOURCE		;0,1,2
	movx	@r0,a
	ret

Copy_FLASH2BANK_2_hlp:
	ljmp	Copy_FLASH2BANK_2
Copy_FLASH2BANK_1:				;Kopiert 128 Samples aus dem FLASH1 ins intFLASH Bank2
	cjne	a,#1,Copy_FLASH2BANK_2_hlp
	call	Flash_Erase_Bank2		;BANK2 löschen
	mov	a,FLASH_BANK_SOURCE
	jb	acc.1,Copy_FLASH2BANK_22
	mov	dptr,#8000h			;FLASH1 als Quelle
Copy_FLASH2BANK_LOOP21:	
	push	dph
	mov	a,FLASH_SOURCE
	clr	c
	rrc	a
	mov	DPH32,a				;32k Blöcke für DPH32
	jc	Copy_FLASH2BANK_LOOP21_2						
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a				
Copy_FLASH2BANK_LOOP21_2:
	mov	a,FLASH_BANK_SOURCE
	jnb	acc.0,Copy_FLASH2BANK_LOOP21_1  ;wenn = 0 dann FLASH1 0-128
	mov	a,DPH32
	orl	a,#01000000b			;wenn Flag gesetzt dann 128-255 32k Samples
	mov	DPH32,a
Copy_FLASH2BANK_LOOP21_1:
	clr	EA
	call	exFLASH_Read			
	setb	EA	
	call	Flash_Write_Bank2
	pop	dph					
	inc	dptr
	mov	a,dph
	push	acc
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM4,#042h
	cpl	a	
    	mov  	PCA0CPH4,a
	pop	acc
	orl	a,dpl
	jnz	Copy_FLASH2BANK_LOOP21
	mov	r0,#BANK2CONTENT		;Samplenummer für Bank2
	mov	a,FLASH_SOURCE			;0-127
	movx	@r0,a
	mov	r0,#BANK2BANKCONTENT		;FLASH für Bank2
	mov	a,FLASH_BANK_SOURCE		;0,1,2
	movx	@r0,a
	ret

Copy_FLASH2BANK_22:				;FLASH2 als Quelle
	mov	dptr,#8000h	
Copy_FLASH2BANK_LOOP22:
	push	dph
	mov	a,FLASH_SOURCE
	anl	a,#00011111b			;Begrenzung auf 32 Samples
	clr	c
	rrc	a
	mov	DPH32,a				;32k Blöcke für DPH32
	jc	Copy_FLASH2BANK_LOOP22_1						
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a				
Copy_FLASH2BANK_LOOP22_1:
	clr	EA
	call	exFLASH_Read_2			
	setb	EA	
	call	Flash_Write_Bank2
	pop	dph					
	inc	dptr
	mov	a,dph
	push	acc
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM4,#042h	
	cpl	a
    	mov  	PCA0CPH4,a
	pop	acc
	orl	a,dpl
	jnz	Copy_FLASH2BANK_LOOP22
	mov	r0,#BANK2CONTENT		;Samplenummer für Bank2
	mov	a,FLASH_SOURCE			;0-127
	movx	@r0,a
	mov	r0,#BANK2BANKCONTENT		;FLASH für Bank2
	mov	a,FLASH_BANK_SOURCE		;0,1,2
	movx	@r0,a
	ret

Copy_FLASH2BANK_Ende_hlp:
	ljmp	Copy_FLASH2BANK_Ende
Copy_FLASH2BANK_2:				;Kopiert 128 Samples aus dem FLASH1 ins intFLASH Bank3 (nur 16kByte!)
	cjne	a,#2,Copy_FLASH2BANK_Ende_hlp
	call	Flash_Erase_Bank3		;BANK3 (16 kByte) löschen
	mov	a,FLASH_BANK_SOURCE
	jb	acc.1,Copy_FLASH2BANK_32
	mov	dptr,#8000h			;FLASH1 als Quelle
Copy_FLASH2BANK_LOOP31:
	push	dph
	mov	a,FLASH_SOURCE
	clr	c
	rrc	a
	mov	DPH32,a				;32k Blöcke für DPH32
	jc	Copy_FLASH2BANK_LOOP31_2						
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a				
Copy_FLASH2BANK_LOOP31_2:
	mov	a,FLASH_BANK_SOURCE
	jnb	acc.0,Copy_FLASH2BANK_LOOP31_1
	mov	a,DPH32
	orl	a,#01000000b			;wenn Flag gesetzt dann 128-255 32k Samples
	mov	DPH32,a
Copy_FLASH2BANK_LOOP31_1:
	clr	EA
	call	exFLASH_Read			
	setb	EA	
	call	Flash_Write_Bank3
	pop	dph					
	inc	dptr
	mov	a,dph
	push	acc
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM5,#042h	
	add	a,#40h
	cpl	a
    	mov  	PCA0CPH5,a
	pop	acc
	cjne	a,#0C0h,Copy_FLASH2BANK_LOOP31
	mov	r0,#BANK3CONTENT		;Samplenummer für Bank3
	mov	a,FLASH_SOURCE			;0-127
	movx	@r0,a
	mov	r0,#BANK3BANKCONTENT		;FLASH für Bank3
	mov	a,FLASH_BANK_SOURCE		;0,1,2
	movx	@r0,a
	ret

Copy_FLASH2BANK_32:				;FLASH2 als Quelle
	mov	dptr,#8000h	
Copy_FLASH2BANK_LOOP32:
	push	dph
	mov	a,FLASH_SOURCE
	anl	a,#00011111b			;Begrenzung auf 32 Samples
	clr	c
	rrc	a
	mov	DPH32,a				;32k Blöcke für DPH32
	jc	Copy_FLASH2BANK_LOOP32_1						
	mov	a,dph
	anl	a,#01111111b
	mov	dph,a				
Copy_FLASH2BANK_LOOP32_1:
	clr	EA
	call	exFLASH_Read_2			
	setb	EA	
	call	Flash_Write_Bank3
	pop	dph					
	inc	dptr
	mov	a,dph
	push	acc
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM5,#042h
	add	a,#40h	
	cpl	a
    	mov  	PCA0CPH5,a
	pop	acc
	cjne	a,#0C0h,Copy_FLASH2BANK_LOOP32
	mov	r0,#BANK3CONTENT		;Samplenummer für Bank3
	mov	a,FLASH_SOURCE			;0-127
	movx	@r0,a
	mov	r0,#BANK3BANKCONTENT		;FLASH für Bank3
	mov	a,FLASH_BANK_SOURCE		;0,1,2
	movx	@r0,a
Copy_FLASH2BANK_Ende:
	ret	

;********************************************************************************

exFLASH_Read:
	call	_SST25VF020_ReadByte
	ret

exFLASH_Write:
	call	_SST25VF020_WriteByte
	ret

exFLASH_Read_2:
	call	_SST25VF020_ReadByte_2
	ret

exFLASH_Write_2:
	call	_SST25VF020_WriteByte_2
	ret

Flash_Init:
	mov  	SFRPAGE,#CONFIG_PAGE
	mov	CCH0CN,#00000001b	;only Block Write Enable
	ret

; **** INTERNES FLASH ***************************************************************

Flash_Erase_Bank1:
	mov  	SFRPAGE,#LEGACY_PAGE
	clr	EA
	mov	PSCTL,#00000011b
	mov	FLSCL,#00110001b
	mov	RSTSRC,#00000010b	;Select the VDD monitor as a reset source
	mov	a,PSBANK		;Bank1
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#10h
	mov	PSBANK,a	
	mov	dptr,#8000h
Flash_Erase_Bank1_1:
	mov	a,#0ffh
	movx	@dptr,a
	inc	dph			
	inc	dph
	inc	dph			
	inc	dph
	mov	a,dph
	cjne	a,#0,Flash_Erase_Bank1_1
	mov  	SFRPAGE, #LEGACY_PAGE
	mov	FLSCL,#00110000b
	mov	PSCTL,#00000000b
	setb	EA
	ret

Flash_Erase_Bank2:
	mov  	SFRPAGE,#LEGACY_PAGE
	clr	EA
	mov	PSCTL,#00000011b
	mov	FLSCL,#00110001b
	mov	RSTSRC,#00000010b	;Select the VDD monitor as a reset source
	mov	a,PSBANK		;Bank2
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#20h
	mov	PSBANK,a	
	mov	dptr,#8000h
Flash_Erase_Bank2_1:
	mov	a,#0ffh
	movx	@dptr,a
	inc	dph			
	inc	dph
	inc	dph			
	inc	dph
	mov	a,dph
	cjne	a,#0,Flash_Erase_Bank2_1
	mov  	SFRPAGE, #LEGACY_PAGE
	mov	FLSCL,#00110000b
	mov	PSCTL,#00000000b
	setb	EA
	ret

Flash_Erase_Bank3:
	mov  	SFRPAGE,#LEGACY_PAGE
	clr	EA
	mov	PSCTL,#00000011b
	mov	FLSCL,#00110001b
	mov	RSTSRC,#00000010b	;Select the VDD monitor as a reset source
	mov	a,PSBANK		;Bank3
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#30h
	mov	PSBANK,a
	mov	dptr,#8000h
Flash_Erase_Bank3_1:
	mov	a,#0ffh
	movx	@dptr,a
	inc	dph			
	inc	dph
	inc	dph			
	inc	dph
	mov	a,dph
	cjne	a,#0C0h,Flash_Erase_Bank3_1	;Lösche Bank 3 $8000 bis $BFFF (16k)
	mov  	SFRPAGE, #LEGACY_PAGE
	mov	FLSCL,#00110000b
	mov	PSCTL,#00000000b
	setb	EA
	ret

;*** ACC=Byte, DPTR für Adresse *****************************************

Flash_Write_Bank1:			;$8000 bis $FFFF
	mov  	SFRPAGE,#LEGACY_PAGE
	clr	EA
	push	DPH
	push	ACC
	mov	PSCTL,#01h
	mov	FLSCL,#00110001b
	mov	a,PSBANK		;Bank 1
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#10h			
	mov	PSBANK,a
	mov	a,dph
	orl	a,#10000000b		;DPTR immer ab $8000h
	mov	dph,a
	pop	acc
	movx	@dptr,a
	mov  	SFRPAGE, #LEGACY_PAGE
	mov	FLSCL,#00110000b
	mov	PSCTL,#0h
	pop     DPH
	setb	EA
	ret

Flash_Write_Bank2:			;$8000 bis $FFFF (32k)
	mov  	SFRPAGE,#LEGACY_PAGE
	clr	EA
	push	DPH
	push	ACC
	mov	PSCTL,#01h
	mov	FLSCL,#00110001b
	mov	a,PSBANK		;Bank 2
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#20h			
	mov	PSBANK,a
	mov	a,dph
	orl	a,#10000000b		;DPTR immer ab $8000h
	mov	dph,a
	pop	acc
	movx	@dptr,a
	mov  	SFRPAGE, #LEGACY_PAGE
	mov	FLSCL,#00110000b
	mov	PSCTL,#0h
	pop     DPH
	setb	EA
	ret

Flash_Write_Bank3:			;$8000 bis $BFFF (16k)
	mov  	SFRPAGE,#LEGACY_PAGE
	clr	EA
	push	DPH
	push	ACC
	mov	PSCTL,#01h
	mov	FLSCL,#00110001b
	mov	a,PSBANK		;Bank 3
	anl	a,#0fh
	mov	PSBANK,a
	mov 	a,PSBANK
	orl	a,#30h			
	mov	PSBANK,a
	mov	a,dph
	orl	a,#10000000b		;DPTR immer ab $8000h
	mov	dph,a
	pop	acc
	movx	@dptr,a
	mov  	SFRPAGE, #LEGACY_PAGE
	mov	FLSCL,#00110000b
	mov	PSCTL,#0h
	pop     DPH
	setb	EA
	ret

