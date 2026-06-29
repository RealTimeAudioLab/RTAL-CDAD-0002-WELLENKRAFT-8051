;******************************************************************************************************
;* ARDUINO ********************************************************************************************
;******************************************************************************************************

ARDUINO:
	push	SFRPAGE
	push    ACC
	push	B
        push    PSW
        push    DPL
        push    DPH
	push	00
	push	01				
	mov  	SFRPAGE,#UART0_PAGE
	mov 	a,scon0
	jbc 	acc.1,ARDUINO_irq_ret
	jbc 	acc.0,ARDUINO_irq_rx
ARDUINO_irq_ret:
	mov  	SFRPAGE,#UART0_PAGE
	mov 	scon0,a
	jnb	midi_send_flag,ARDUINO_irq_end
	mov	a,midi_send_bytes
	cjne	a,#03,ARDUINO_irq_ret_1
	mov	r0,#smidibyte1
	movx	a,@r0
	mov	sbuf0,a
	dec	midi_send_bytes
	jmp	ARDUINO_irq_end
ARDUINO_irq_ret_1:
	mov	a,midi_send_bytes
	cjne	a,#02,ARDUINO_irq_ret_2
	mov	r0,#smidibyte2
	movx	a,@r0
	mov	sbuf0,a
	dec	midi_send_bytes
	jmp	ARDUINO_irq_end
ARDUINO_irq_ret_2:
	mov	a,midi_send_bytes
	cjne	a,#01,ARDUINO_irq_end
	mov	r0,#smidibyte3
	movx	a,@r0
	mov	sbuf0,a
	dec	midi_send_bytes
	clr	midi_send_flag
ARDUINO_irq_end:
	pop	01
	pop	00
	pop     DPH
      	pop     DPL
        pop     PSW
	pop	B
        pop     ACC
	pop	SFRPAGE
	reti

ARDUINO_irq_rx:
	mov  	SFRPAGE,#UART0_PAGE
	mov 	scon0,a
	mov 	a,sbuf0	
	mov	r0,a
	mov	dpl,arduino_pointer_L
	mov	dph,arduino_pointer_H
	mov	a,Bank_Target
	cjne	a,#0,ARDUINO_irq_rx_1
	mov	a,r0
	call	FLASH_Write_Bank1		;schreibe Daten ins Flash Bank 1
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM3,#042h
	mov	a,dph	
    	mov  	PCA0CPH3,a
	jmp	ARDUINO_irq_rx_weiter
ARDUINO_irq_rx_1:
	cjne	a,#1,ARDUINO_irq_rx_2
	mov	a,r0
	call	FLASH_Write_Bank2		;schreibe Daten ins Flash Bank 2
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM4,#042h
	mov	a,dph	
    	mov  	PCA0CPH4,a
	jmp	ARDUINO_irq_rx_weiter
ARDUINO_irq_rx_2:
	cjne	a,#2,ARDUINO_irq_end
	mov	a,r0
	call	FLASH_Write_Bank3		;schreibe Daten ins Flash Bank 3
	mov  	SFRPAGE,#PCA0_PAGE
   	mov  	PCA0CN,#040h
    	mov  	PCA0CPM5,#042h
	mov	a,dph	
    	mov  	PCA0CPH5,a
	cjne	a,#0C0h,ARDUINO_irq_rx_weiter	;wenn größer 16k dann setzte Pointer wieder auf 8000h
	mov	dptr,#7fffh
ARDUINO_irq_rx_weiter:
	inc	dptr
	mov	arduino_pointer_L,dpl
	mov	arduino_pointer_H,dph		
	jmp 	ARDUINO_irq_end