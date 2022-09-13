; (2022) Kaveen Rodrigo / ukr.lk

	.setcpu "6502"
	
; Reference To ROM Routines In The KIM-1
	
SCANDS 	=	$1f1f
GETKEY 	= 	$1f6a
	
; Reference to SCANDS values

dig12	=	$f9
dig34	=	$fa
dig56	=	$fb

;		Zero page variables
selkey	=	$00

; 		Start program at free RAM.
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
		
		sta selkey			; Save Selected Valid Key

bounce:	jsr SCANDS			; Keep display lit when debouncing
		jsr GETKEY			; Wait till key is released
		cmp selkey
		beq bounce
		
		lda selkey
		
		cmp #$10			; AD Key is pressed
		beq a_val
	
		cmp #$11			; DA Key is pressed
		beq s_val
	
		cmp #$14			; PC Key is pressed
		beq m_val
			
		cmp #$12			; + Key is pressed
		beq c_val
	
		sta dig12			; Store valid key press

		jmp loop

a_val:	jsr r_add
		jmp loop
	
s_val:	sec
		lda dig34			; Load current low
		sbc dig12			; Deduct Selected number
		sta dig34			; Store low
		
		lda dig56			; Load current high
		sbc #$00			; Deduct 0 with carry
		sta dig56			; Store high
		jmp loop
	
c_val:	lda #0				; Clear Display
		sta dig34
		sta dig56	
		jmp loop

m_val:	ldx dig12			; Load X with multiplier
		dex					; Multiple X-1 times
m_rep:	jsr r_add			; Call Add Subroutine
		dex
		bne m_rep			; Keep adding till X zero
		jmp loop
		
r_add:	clc					; Clear carry flag
		lda dig34			; Load current low
		adc dig12			; Add Selected number
		sta dig34			; Store low
		
		lda dig56			; Load current high
		adc #$00			; Add 0 with carry
		sta dig56			; Store high
		rts