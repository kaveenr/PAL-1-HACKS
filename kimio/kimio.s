; (2022) Kaveen Rodrigo / ukr.lk

;	Reference To ROM Routines In The KIM-1
	
	SCANDS 	=	$1f1f
	GETKEY 	= 	$1f6a
	
;	Reference to SCANDS values
	dig12	=	$f9
	dig34	=	$fa
	dig56	=	$fb


; 	Start program at free RAM.
	.org $0200

init:
	cld					; Clear Decimal
	lda #$00			; Initialize SCANDS Values
	sta dig12
	sta dig34
	sta dig56

main_loop:
	jsr SCANDS
	jsr GETKEY

	cmp #$15			; Return if no key pressed
	beq main_loop

	cmp #$10			; AD Key is pressed
	beq add_value
	
	cmp #$11			; DA Key is pressed
	beq sub_value
	
	cmp #$14			; PC Key is pressed
	beq clear_value

	sta dig12			; Valid Key Press

	inc $fd				; why do I have to do this?
	bne main_loop		; Tell me why :') ????

	jmp main_loop
	

add_value:
	lda dig34
	adc dig12
	sta dig34
	
	inc $fd				; why do I have to do this?
	bne main_loop		; Tell me why :') ????
	
	jmp main_loop
	
sub_value:
	lda dig34
	sbc dig12
	sta dig34
	
	inc $fd				; why do I have to do this?
	bne main_loop		; Tell me why :') ????
	
	jmp main_loop
	
clear_value:
	lda #0
	sta dig34
	sta dig56
	
	inc $fd				; why do I have to do this?
	bne main_loop		; Tell me why :') ????
	
	jmp main_loop