; (2022) Kaveen Rodrigo / ukr.lk

	.setcpu "6502"
	
; Reference To ROM Routines In The KIM-1
	
SCANDS 	=	$1f1f
GETKEY 	= 	$1f6a
	
; Reference to SCANDS values

dig12	=	$f9
dig34	=	$fa
dig56	=	$fb


; Start program at free RAM.
		.org 	$0200

init:	cld					; Clear Decimal
		lda #$00			; Initialize SCANDS Values
		sta dig12
		sta dig34
		sta dig56

loop:	jsr SCANDS
		jsr GETKEY

		cmp #$15			; Handle no key press
		beq loop
	
		cmp #$10			; AD Key is pressed
		beq a_val
	
		cmp #$11			; DA Key is pressed
		beq s_val
	
		cmp #$14			; PC Key is pressed
		beq c_val
	
		sta dig12			; Store valid key press

		jmp loop

a_val:
		lda dig34
		adc dig12
		sta dig34
		jmp loop
	
s_val:
		lda dig34
		sbc dig12
		sta dig34
		jmp loop
	
c_val:
		lda #0
		sta dig34
		sta dig56	
		jmp loop