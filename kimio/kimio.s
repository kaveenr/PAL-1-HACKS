; (2022) Kaveen Rodrigo / ukr.lk

;	Reference To ROM Routines In The KIM-1
	
	SCANDS = $1f1f
	GETKEY = $1f6a

; Start program at free RAM.
	.org $0200

; Initialize SCANDS Values
	lda #0
	sta $f9
	sta $fa
	sta $fb

loop:	
	jsr SCANDS
	jsr GETKEY

	cmp #$15		; Return if no key pressed
	beq loop

	cmp #$10		; AD Key is pressed
	beq add_value
	
	cmp #$11		; DA Key is pressed
	beq sub_value

	sta $f9			; Valid Key Press

	inc $fd			; why do I have to do this?
	bne loop		; Tell me why :') ????

	jmp loop
	

add_value:
	lda $fa
	adc $f9
	sta $fa
	
	inc $fd			; why do I have to do this?
	bne loop		; Tell me why :') ????
	
	jmp loop
	
sub_value:
	lda $fa
	sbc $f9
	sta $fa
	
	inc $fd			; why do I have to do this?
	bne loop		; Tell me why :') ????
	
	jmp loop