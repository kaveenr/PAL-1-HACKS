; (2022) Kaveen Rodrigo / ukr.lk

		.setcpu "6502"
	
; 		Reference To ROM Routines In The KIM-1
		OUTCH 	=	$1EA0
		OUTSP	=	$1E9E
		CRLF	=	$1E2F
		RST		=	$1C22

; 		Start program at free RAM.
		.org 	$0200
		
init:	JSR CRLF		; Send CRLF to TTY
		
		ldx #0			; Loop over msg untill end		

loop:	lda msg, X
		beq stop
		jsr OUTCH		; Put A to TTY
		inx
		jmp loop

stop:	jmp RST			; Put KIM back to monitor

;		Messages to be printed

msg:	.asciiz "Hello World, From The PAL-1"