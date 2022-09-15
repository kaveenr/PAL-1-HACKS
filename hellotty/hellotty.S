; (2022) Kaveen Rodrigo / ukr.lk

            .setcpu "6502"
    
; Constants For ASCII

CR      =     $0D                       ; Carriage Return
LF      =     $0A                       ; Line Feed

; Reference To ROM Routines In The KIM-1
            
OUTCH    =    $1EA0                     ; Print A to TTY
GETCH    =    $1E5A                     ; Load Chart A
RST      =    $1C22                     ; Reset to monitor

; Zero Page Vars
            
PRINTP   =    $00                       ; Print Text Pointer
SAVEA    =    $02                       ; Save states for registers
SAVEX    =    $03
SAVEY    =    $04

; Start program at free RAM.
            
            .org     $0200
        
init:       lda #<msg                   ; Load the msg addr to print pointer
            sta    PRINTP
            lda #>msg
            sta    PRINTP+1
            jsr print_str               ; jump to print subroutine
            
            lda #<msg1                  ; print prompt
            sta    PRINTP
            lda #>msg1
            sta    PRINTP+1
            jsr print_str
            
            jsr input_num               ; get number
            tax                         ; load to x registry

@loop:      lda #<msg3                  ; Load greeter addr to print pointer
            sta    PRINTP
            lda #>msg3
            sta    PRINTP+1
            jsr print_str               ; print msg3
            
            txa                         ; Print X 
            jsr print_num

            dex
            beq hault
            jmp @loop

hault:      jmp RST                     ; Put KIM back to monitor


;            Input Subroutines

input_num:  jsr GETCH                   ; Get Char
            sec                         ; Set Carry Flag
            sbc #$30                    ; Deduct ASCII offset
            rts

;            Print Subroutines

print_num:  sta SAVEA                   ; Retain A
            adc #$30                    ; ASCII number offset
            jsr safe_outch              ; Print A
            lda    SAVEA                ; Put A back
            rts

print_str:  ldy #0                
@loop:      lda (PRINTP), Y             ; Indirect ref print pointer with Y offset
            beq @stop
            jsr safe_outch              ; Print char
            iny
            jmp @loop
@stop:      rts


safe_outch: sta SAVEA                   ; Retain A, X, Y
            txa
            sta SAVEX
            tya
            sta SAVEY
            lda SAVEA
            jsr OUTCH            ; Print A
            lda SAVEX            ; Put A, X, Y back
            tax
            lda SAVEY
            tay
            lda SAVEA
            rts

;            Messages to be printed

msg:        .byte CR, LF,"Hello World, From The PAL-1!", 0
msg1:        .byte CR, LF,"Number : ", 0
msg3:        .byte CR, LF, "Greeting You ", 0