; (2022) Kaveen Rodrigo / ukr.lk

;
;	Reference To ROM Routines In The KIM-1
;
	SCANDS = $1f1f
	GETKEY = $1f6a

;
; Start program at free RAM.
;
	.org $0200

; Initialize SCANDS Values
; The contents of these adresses will be displayed
; -when SCANDS is called
;
start:
	lda #0
	sta $f9
	sta $fa
	sta $fb

loop:

	jsr SCANDS
	jsr GETKEY

	cmp #$15		; Return if no key pressed
	beq loop
	sta $f9			; Valid Key Pressed

	ldx #255		; Nested Loop Delay

	inc $fd			; why do I have to do this?
	bne loop

	jmp loop