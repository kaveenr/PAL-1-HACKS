; # # # # # # # # # # # # #
; # Kaveen Rodrigo, 2022  #
; # ukr.lk                #
; # # # # # # # # # # # # #

.setcpu "6502"

; RIOT Registers

RIOT    =   $1740
DRA     =   RIOT
DDRA    =   RIOT+1
DRB     =   RIOT+2
DDRB    =   RIOT+3
        
; KIM-1 Display
; Port B Decoder LS145
; Port A 0-6 A to G
;                           
; 01000 digit 6 (L to R)     A  ---
; 01010 digit 5              F |   | B
; 01100 digit 4              G  ---
; 01110 digit 3              E |   | C
; 10000 digit 2              D  ---
; 10010 digit 1

        
A_DIR   =   %01111000
B_DIR   =   %11111110


        .org     $0200
        
init:   lda #A_DIR
        sta DDRA
        lda #B_DIR
        sta DDRB
        
draw:   ldx #100
        ldy #0
@loop:  txa
        rol A
        cmp #%10100
        beq @exit
        sta DRB
        tya
        sta DRA
        inx
        iny
        jsr @loop
@exit:  jmp draw