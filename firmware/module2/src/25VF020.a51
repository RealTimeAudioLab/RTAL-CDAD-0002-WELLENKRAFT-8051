;* SSTVF020 =  2Mbit  (262.144 Bytes = 4*64k) Flash 000000h - 03ffffh
;* SSTVF064C = 64Mbit (8.388.608 Bytes = 128*64k) Flash 000000h - 7fffffh
;* SSTVF080B = 8Mbit  (1.048.576 Bytes = 16*64k) FLASH 000000h - 0fffffh  

_SST25VF020_SendByte:
	MOV  	SPI0DAT,A
	JNB  	SPIF,$
	CLR  	SPIF
	RET  	

;*****************************************
; Allow Write operations
;*****************************************

SST25VF020_WriteEnable:
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#06H			;WREN Write-Enable 
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS
	RET  

;*****************************************
; Disable Write operations
;*****************************************

SST25VF020_WriteDisable:
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#04h
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	SETB 	SST25VF020_WP
	RET 

;*****************************************

SST25VF020_WriteStatusEnable:
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#050H				;EWSR Enable Write Status Register
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	SETB 	SST25VF020_WP
	RET 

;***************************************** 

_SST25VF020_WriteStatus:			;Sendet ACC
	push	acc
	LCALL	SST25VF020_WriteStatusEnable
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#01H				;WRSR Write Status Register
	LCALL	_SST25VF020_SendByte
	pop	acc
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	SETB 	SST25VF020_WP
	RET 

;***************************************** 
; Lese StatusRegister (RDSR)
;*****************************************

SST25VF020_ReadStatus:				;Ergebnis steht in ACC
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#05H				;RDSR Lese Statusregister
	LCALL	_SST25VF020_SendByte
	MOV  	A,#00H
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	SETB 	SST25VF020_WP
	RET 

;***************************************** 
; Lese StatusRegister 1
;*****************************************

SST25VF020_ReadStatus1:				;Ergebnis steht in ACC
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#35H				;RDSR1
	LCALL	_SST25VF020_SendByte
	MOV  	A,#00H
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	SETB 	SST25VF020_WP
	RET 

;***************************************** 	

SST25VF020_ChipErase:
	LCALL	SST25VF020_WriteEnable
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#060H
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS
SST25VF020_ChipErase_1:
	CALL	SST25VF020_ReadStatus
	JB   	ACC.0,SST25VF020_ChipErase_1
	RET 

;******************************************************************************
; Adresse des 64k Block, der gelöscht werden soll, steht in DPH32, DPH und DPL
;******************************************************************************	

SST25VF020_64kErase:
	LCALL	SST25VF020_WriteEnable
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#0D8H
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS
SST25VF020_64kErase_1:
	CALL	SST25VF020_ReadStatus
	JB   	ACC.0,SST25VF020_64kErase_1
	RET 

;******************************************************************************
; Adresse des 32k Block, der gelöscht werden soll, steht in DPH32, DPH und DPL
;******************************************************************************	

SST25VF020_32kErase:
	LCALL	SST25VF020_WriteEnable
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#052H
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS
SST25VF020_32kErase_1:
	CALL	SST25VF020_ReadStatus
	JB   	ACC.0,SST25VF020_32kErase_1
	RET 

;***************************************************************************
;Adresse des Byte, welches gelesen werden soll, steht in DPH32, DPH und DPL
;*************************************************************************** 

_SST25VF020_ReadByte:				;Ergebnis steht im ACC
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#03H				;#0Bh für HighSpeedRead, #03h für LowSpeedRead
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32				;(Address >> 16)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	MOV  	A,#00h				;#0ffh für HighSpeedRead, kein Byte für LowSpeedRead
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	RET

;*******************************************************************************
;Adresse des Byte, welches geschrieben werden soll, steht in DPH32, DPH und DPL
;******************************************************************************* 	

_SST25VF020_WriteByte:				;Sendet ACC
	push	acc
	lcall	SST25VF020_WriteEnable
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#02H				;Byte Program
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte	
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	pop	acc
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	SETB 	SST25VF020_WP
_SST25VF020_WriteByte_1:
	LCALL	SST25VF020_ReadStatus
	JB   	ACC.0,_SST25VF020_WriteByte_1
	RET 

;***************************************** 
		
SST25VF020_ReadID:			
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#090H
	LCALL	_SST25VF020_SendByte
	MOV  	A,#0
	LCALL	_SST25VF020_SendByte
	LCALL	_SST25VF020_SendByte
	INC  	A
	LCALL	_SST25VF020_SendByte		;Adresse 000001h
	DEC  	A
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT			;ID steht in ACC, Device ID = 8CH for SST25VF020B, 43h for SST25VF020
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS
	RET  

;*****************************************

SST25VF020_Init:
	mov	a,#0
	LJMP 	_SST25VF020_WriteStatus

;****************** FLASH 2 *******************************
;**********************************************************
;**********************************************************

;*****************************************
; Allow Write operations
;*****************************************

SST25VF020_WriteEnable_2:
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#06H
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS_2
	RET  

;*****************************************
; Disable Write operations
;*****************************************

SST25VF020_WriteDisable_2:
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#04h
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	SETB 	SST25VF020_WP
	RET 

;*****************************************

SST25VF020_WriteStatusEnable_2:
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#050H
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	SETB 	SST25VF020_WP
	RET 

;***************************************** 

_SST25VF020_WriteStatus_2:			;Sendet ACC
	push	acc
	LCALL	SST25VF020_WriteStatusEnable_2
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#01H
	LCALL	_SST25VF020_SendByte
	pop	acc
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	SETB 	SST25VF020_WP
	RET 

;***************************************** 
; Lese StatusRegister (RDSR)
;*****************************************

SST25VF020_ReadStatus_2:			;Ergebnis steht in ACC
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#05H
	LCALL	_SST25VF020_SendByte
	MOV  	A,#00H
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	SETB 	SST25VF020_WP
	RET 

;***************************************** 
; Lese StatusRegister 1
;*****************************************

SST25VF020_ReadStatus1_2:				;Ergebnis steht im ACC
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#35H
	LCALL	_SST25VF020_SendByte
	MOV  	A,#00H
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	SETB 	SST25VF020_WP
	RET 

;***************************************** 	

SST25VF020_ChipErase_2:
	LCALL	SST25VF020_WriteEnable_2
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#060H
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS_2
SST25VF020_ChipErase_21:
	CALL	SST25VF020_ReadStatus_2
	JB   	ACC.0,SST25VF020_ChipErase_21
	RET 

;******************************************************************************
; Adresse des 64k Block, der gelöscht werden soll, steht in DPH32, DPH und DPL
;******************************************************************************	

SST25VF020_64kErase_2:
	LCALL	SST25VF020_WriteEnable_2
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#0D8H
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS_2
SST25VF020_64kErase_21:
	CALL	SST25VF020_ReadStatus_2
	JB   	ACC.0,SST25VF020_64kErase_21
	RET 

;******************************************************************************
; Adresse des 32k Block, der gelöscht werden soll, steht in DPH32, DPH und DPL
;******************************************************************************	

SST25VF020_32kErase_2:
	LCALL	SST25VF020_WriteEnable_2
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#052H
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_WP
	SETB 	SST25VF020_NS_2
SST25VF020_32kErase_21:
	CALL	SST25VF020_ReadStatus_2
	JB   	ACC.0,SST25VF020_32kErase_21
	RET 

;***************************************************************************
;Adresse des Byte, welches gelesen werden soll, steht in DPH32, DPH und DPL
;*************************************************************************** 

_SST25VF020_ReadByte_2:				;Ergebnis steht im ACC
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	SPI0CFG,#043H
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#03H
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	MOV  	A,#00h
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	RET

;*******************************************************************************
;Adresse des Byte, welches geschrieben werden soll, steht in DPH32, DPH und DPL
;******************************************************************************* 	

_SST25VF020_WriteByte_2:			;Sendet ACC
	push	acc
	lcall	SST25VF020_WriteEnable_2
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	CLR  	SST25VF020_WP
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#02H
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPH32
	LCALL	_SST25VF020_SendByte	
	MOV  	A,DPH				;(Address >> 8)
	LCALL	_SST25VF020_SendByte
	MOV  	A,DPL				;(Address & 0xff)
	LCALL	_SST25VF020_SendByte
	pop	acc
	LCALL	_SST25VF020_SendByte
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	SETB 	SST25VF020_WP
_SST25VF020_WriteByte_21:
	LCALL	SST25VF020_ReadStatus_2
	JB   	ACC.0,_SST25VF020_WriteByte_21
	RET 

;***************************************** 
		
SST25VF020_ReadID_2:			
	MOV  	SFRPAGE,#CONFIG_PAGE
	CLR  	SST25VF020_NS_2
	MOV  	SFRPAGE,#SPI0_PAGE
	MOV  	A,#090H
	LCALL	_SST25VF020_SendByte
	MOV  	A,#0
	LCALL	_SST25VF020_SendByte
	LCALL	_SST25VF020_SendByte
	INC  	A
	LCALL	_SST25VF020_SendByte		;Adresse 000001h
	DEC  	A
	LCALL	_SST25VF020_SendByte
	MOV  	A,SPI0DAT			;ID steht in ACC, Device ID = 8CH for SST25VF020B, 43h for SST25VF020
	MOV  	SFRPAGE,#CONFIG_PAGE
	SETB 	SST25VF020_NS_2
	RET  

;*****************************************

SST25VF020_Init_2:
	mov	a,#0
	LJMP 	_SST25VF020_WriteStatus_2

	