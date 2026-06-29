readwheel1:
	mov	a,PORTSPEICHER1
	mov	c,acc.0
	rr	a
	mov	acc.1,c
	mov	PORTSPEICHER1,p3
	xrl	a,PORTSPEICHER1
	mov	c,acc.0
	anl	c,/acc.1
	jnc	CCW1?
	djnz	COUNTER,nowheel1
	mov	a,wheel1
	cjne	a,#07fh,$+3
	jc	inc1?
	mov	wheel1,#07fh
	setb	wheel1mov
	mov	COUNTER,#4
	sjmp	nowheel1
inc1?:	inc 	wheel1
	setb	wheel1mov
	mov	COUNTER,#4	
	sjmp	nowheel1

CCW1?:	mov	c,acc.1
	anl	c,/acc.0
	jnc	nowheel1
	djnz	COUNTER,nowheel1
	mov	a,wheel1
	cjne	a,#0,CCW1?_1
	jmp	dec1?
CCW1?_1:		
	jc 	dec1?
	dec	wheel1
	setb	wheel1mov
	mov	COUNTER,#4
	sjmp	nowheel1
dec1?:	mov	wheel1,#0
	setb	wheel1mov
	mov	COUNTER,#4
nowheel1:
	ret