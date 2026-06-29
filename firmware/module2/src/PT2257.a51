;PT2257 - Electronic Volume Controller IC
;Datasheet - http://www.princeton.com.tw/Portals/0/Product/PT2257.pdf
;Pinout
;   |-----_-----|
;1 -| Lin   Rin |- 8
;2 -| Lout Rout |- 7
;3 -| Gnd    V+ |- 6
;4 -| SDA   SCL |- 5
;   |-----------|

;FUNCTION BITS
;MSB    2    3    4    5    6    7    LSB  Function
;----------------------------------------------------------------------------------------
;  1    1    1    1    1    1    1    1    Function OFF (-79dB)
;  1    1    0    1    A3   A2   A1   A0   2-Channel, -1dB/step
;  1    1    1    0    0    B2   B1   B0   2-Channel, -10dB/step
;  1    0    1    0    A3   A2   A1   A0   Left Channel, -1dB/step
;  1    0    1    1    0    B2   B1   B0   Left Channel, -10dB/step
;  0    0    1    0    A3   A2   A1   A0   Right Channel, -1dB/step
;  0    0    1    1    0    B2   B1   B0   Right Channel, -10dB/step
;  0    1    1    1    1    0    0    M    2-Channel MUTE (M=1 -> MUTE=ON / M=0 -> MUTE=OFF);
;
;ATTENUATION UNIT BIT  
; A3   AB2  AB1  AB0  ATT(-1) ATT(-10)
;  0    0    0    0     0      0  
;  0    0    0    1    -1    -10
;  0    0    1    0    -2    -20
;  0    0    1    1    -3    -30
;  0    1    0    0    -4    -40
;  0    1    0    1    -5    -50
;  0    1    1    0    -6    -60
;  0    1    1    1    -7    -70
;  1    0    0    0    -8  
;  1    0    0    1    -9  
;  
;instructions
PT2257_ADDR EQU 10001000b  ;Chip address 88h
EVC_OFF     EQU 11111111b  ;Function OFF (-79dB)
EVC_2CH_1   EQU 11010000b  ;2-Channel, -1dB/step
EVC_2CH_10  EQU 11100000b  ;2-Channel, -10dB/step
EVC_L_1     EQU 10100000b  ;Left Channel, -1dB/step
EVC_L_10    EQU 10110000b  ;Left Channel, -10dB/step
EVC_R_1     EQU 00100000b  ;Right Channel, -1dB/step
EVC_R_10    EQU 00110000b  ;Right Channel, -10dB/step
EVC_MUTE    EQU 01111000b  ;2-Channel MUTE

PT2257_Set_Mute_On:
	mov	a,#02h				;CH2
	call	Select_I2C_PT2257
	mov	a,#0
	call	PT2257_Set_Volume
	mov	a,#01h				;CH1
	call	Select_I2C_PT2257
	mov	a,#0
	call	PT2257_Set_Volume
	mov	a,#04h				;CH3
	call	Select_I2C_PT2257
	mov	a,#0
	call	PT2257_Set_Volume
	mov	a,#08h				;CH4
	call	Select_I2C_PT2257
	mov	a,#0
	call	PT2257_Set_Volume
	ret

PT2257_Set_Mute_Off:
	setb	Volume_Changed_DCO2LVOL
	setb	Volume_Changed_DCO2VOL
	setb	Volume_Changed_DCO1RVOL
	setb	Volume_Changed_DCO1VOL
	setb	EFX_Send_Changed
	setb	EFX_Return_Changed
	ret

PT2257_Set_Volume:
	mov	r0,a
	mov	dptr,#PT2257_Tab_L_10
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	add	a,#48			;2-Channel, -10dB/step
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	mov	a,r0
	mov	dptr,#PT2257_Tab_L_1
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0	
	mov	COMMAND,#PT2257_ADDR
	add	a,#48			;2-Channel, -1dB/step	
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	ret

PT2257_Set_Volume_Right:
	mov	r0,a
	mov	dptr,#PT2257_Tab_R_10
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	mov	a,r0
	mov	dptr,#PT2257_Tab_R_1
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	ret

PT2257_Set_Volume_Left:
	mov	r0,a
	mov	dptr,#PT2257_Tab_L_10
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	mov	a,r0
	mov	dptr,#PT2257_Tab_L_1
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0	
	mov	COMMAND,#PT2257_ADDR	
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	ret

;******************************************************************
;* Volume und Pan je Voice mit einem Pot **************************
;******************************************************************

;Left
;   /----\
;  /      \
; /        \
;/          \
;0-47|48-87|88-127

;Right
;   /\   |------
;  /  \  |
; /    \ |
;/      \|
;0-47|48-87|88-127

PT2257_Set_Volume_OnePot:
	mov	r0,a
	mov	dptr,#PT2257_Tab_L_10_OnePot
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	mov	a,r0
	mov	dptr,#PT2257_Tab_L_1_OnePot
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0	
	mov	COMMAND,#PT2257_ADDR	
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	mov	a,r0
	mov	dptr,#PT2257_Tab_R_10_OnePot
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	mov	a,r0
	mov	dptr,#PT2257_Tab_R_1_OnePot
	movc	a,@a+dptr
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,a
	clr	STO	 
	setb	STA

	ret

PT2257_Mute:
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,#EVC_MUTE
	clr	STO	 
	setb	STA
	ret

PT2257_Off:
	mov  	SFRPAGE,#SMB0_PAGE
	nop
	jb	SM_BUSY,$
	nop
	setb	SM_BUSY
	nop
	mov  	SMB0CN,#44h
	mov	BYTE_NUMBER,#0		
	mov	COMMAND,#PT2257_ADDR
	mov	HIGH_ADD,#EVC_OFF
	clr	STO	 
	setb	STA
	ret

PT2257_Tab_L_1:
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160
db 169,169,168,167,166,166,165,164,164,163,162,162,161,161,160,160

PT2257_Tab_L_10:
db 183,183,183,183,183,183,183,183,183,183,183,183,183,183,183,183
db 182,182,182,182,182,182,182,182,182,182,182,182,182,182,182,182
db 181,181,181,181,181,181,181,181,181,181,181,181,181,181,181,181
db 180,180,180,180,180,180,180,180,180,180,180,180,180,180,180,180
db 179,179,179,179,179,179,179,179,179,179,179,179,179,179,179,179
db 178,178,178,178,178,178,178,178,178,178,178,178,178,178,178,178
db 177,177,177,177,177,177,177,177,177,177,177,177,177,177,177,177
db 176,176,176,176,176,176,176,176,176,176,176,176,176,176,176,176

PT2257_Tab_R_1:
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32
db 41,41,40,39,38,38,37,36,36,35,34,34,33,33,32,32

PT2257_Tab_R_10:
db 55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
db 54,54,54,54,54,54,54,54,54,54,54,54,54,54,54,54
db 53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53
db 52,52,52,52,52,52,52,52,52,52,52,52,52,52,52,52
db 51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51
db 50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50
db 49,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49
db 48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48

;******************************************************************
;* Volume und Pan je Voice mit einem Pot **************************
;******************************************************************

;Left
;   /----\
;  /      \
; /        \
;/          \
;0-47|48-87|88-127

;Right
;   /\   |------
;  /  \  |
; /    \ |
;/      \|
;0-47|48-87|88-127

PT2257_Tab_L_10_OnePot:
db 183,183,183,183,183,183,182,182,182,182,182,182,181,181,181,181
db 181,181,180,180,180,180,180,180,179,179,179,179,179,179,178,178
db 178,178,178,178,177,177,177,177,177,177,176,176,176,176,176,176
db 176,176,176,176,176,176,176,176,176,176,176,176,176,176,176,176
db 176,176,176,176,176,176,176,176,176,176,176,176,176,176,176,176
db 176,176,176,176,176,176,176,176,176,176,176,176,176,177,177,177
db 177,177,178,178,178,178,178,179,179,179,179,179,180,180,180,180
db 180,181,181,181,181,181,182,182,182,182,182,183,183,183,183,183

PT2257_Tab_L_1_OnePot:
db 169,167,165,163,161,160,169,167,165,163,161,160,169,167,165,163
db 161,160,169,167,165,163,161,160,169,167,165,163,161,160,169,167
db 165,163,161,160,169,167,165,163,161,160,169,167,165,163,161,160
db 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
db 160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160
db 160,160,160,160,160,160,160,160,160,162,164,166,169,160,162,164
db 166,169,160,162,164,166,169,160,162,164,166,169,160,162,164,166
db 169,160,162,164,166,169,160,162,164,166,169,160,162,164,166,169

PT2257_Tab_R_10_OnePot:
db 55,55,55,55,55,55,54,54,54,54,54,54,53,53,53,53
db 53,53,52,52,52,52,52,52,51,51,51,51,51,51,50,50
db 50,50,50,50,49,49,49,49,49,49,48,48,48,48,48,48
db 49,49,49,49,49,49,50,50,50,50,50,50,51,51,51,51
db 51,51,52,52,52,52,52,52,53,53,53,53,53,53,54,54
db 54,54,54,55,55,55,55,55,48,48,48,48,48,48,48,48
db 48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48
db 48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48

PT2257_Tab_R_1_OnePot:
db 41,39,37,35,33,32,41,39,37,35,33,32,41,39,37,35
db 33,32,41,39,37,35,33,32,41,39,37,35,33,32,41,39
db 37,35,33,32,41,39,37,35,33,32,41,39,37,35,33,32
db 32,33,35,37,39,41,32,33,35,37,39,41,32,33,35,37
db 39,41,32,33,35,37,39,41,32,33,35,37,39,41,32,35
db 37,39,41,32,35,37,39,41,32,32,32,32,32,32,32,32
db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32