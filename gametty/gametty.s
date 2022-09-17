; # # # # # # # # # # # # #
; # Kaveen Rodrigo, 2022  #
; # ukr.lk                #
; # # # # # # # # # # # # #

; Abirahasa Game Interpreter
; "Abirahasa" - Mystery in Sinhala

; Functionality Of Game Engine
; Scene
;   - Has Text Content
;   - Can Go Four Directions
;   - Can backtrack flag
;   - 8 Unqiue Item Pickup
;   - Reusuable scenarios

; Game State            Supported Verbs
;   - Previous Scene        - GO
;   - Current Scene         - TAKE
;   - Pickups               - USE
;

    .setcpu "6502"

;
; Constants
;

; KIM-1 Rom Routine Addresses

    kOUTCH  =   $1EA0
    kGETCH  =   $1E5A
    kRST    =   $1C22

; Zero Page Variables

    SAVEA   =   $01
    SAVEX   =   $02
    SAVEY   =   $03

    PRINTP  =   $04         ; 2 byte print pointer
    PRINTE  =   $06         ; 2 byte of print end
    CVERB   =   $08         ; 1 byte selected verb
    CNOUN   =   $09         ; 1 byte selected noun
    INWORD  =   $0A         ; String Input Buffer

    ; Game State Variables
    
    GAMEP   =   $30         ; 2 byte game pointer
    GCADD   =   $34         ; GO Adress Common High byte
    GNADD   =   $35         ; GO Adress North Low byte
    GEADD   =   $36         ; GO Adress East Low byte
    GSADD   =   $37         ; GO Adress South Low byte
    GWADD   =   $38         ; GO Adress West Low byte
    DESCR   =   $39         ; 2 byte address of description

    
; ASCII Constants

    CR      =   $0D         ; Carriage Return
    LF      =   $0A         ; Line Feed
    SP      =   $20         ; Space

;
; Program Entrypoint
;

    .org    $0200 

init:       ldx #<s_hello   ; Show Welcome Message
            ldy #>s_hello                      
            jsr PutStr
            lda #<game      ; Set Game Scene Pointer
            sta GAMEP                  
            lda #>game                    
            sta GAMEP+1 

describe:   ldy #0          ; Loading GO Pointers
@loop:      lda (GAMEP), y
            cpy #0
            bne @match_n
            sta GCADD
            jmp @next
@match_n:   cpy #1
            bne @match_e
            sta GNADD
            jmp @next
@match_e:   cpy #2
            bne @match_s
            sta GEADD
            jmp @next
@match_s:   cpy #3
            bne @match_w
            sta GSADD
            jmp @next
@match_w:   cpy #4
            bne @endloop
            sta GWADD
            jmp @endloop
@next:      iny
            jmp @loop

@endloop:   clc         ; Set String start to DESCR
            lda GAMEP
            adc #5
            sta DESCR
            lda GAMEP+1
            adc #0
            sta DESCR+1
            
            jsr PutCRLF ; Print Description
            jsr PutCRLF
            ldx DESCR
            ldy DESCR+1
            jsr PutStr
            
    
            ; Prompt Verb
            ; Store Valid Verb First Char to CVERB

prompt:     jsr PutCRLF
            ldx #<s_prompt
            ldy #>s_prompt                      
            jsr PutStr
            
            jsr GetWord     ; Get Word
            lda INWORD
            
            cmp #'G'        ; Check if valid verb
            beq @store
            cmp #'T'
            beq @store
            cmp #'U'
            beq @store
            
@failed:    jsr PutCRLF     ; Notify Bad Verb
            
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            
            ldx #<s_err1
            ldy #>s_err1                      
            jsr PutStr
            
            jmp prompt      ; Return To Prompt

@store:     lda INWORD      ; Store first char of verb
            sta CVERB

            ; Prompt Noun
            ; Store Noun First Char to CNOUN
            
prompt_n:   jsr GetWord     ; Get Word
            lda INWORD
            sta CNOUN
            
            jsr PutCRLF
                        
            ; Switch Based On Noun
            
            lda CVERB
            cmp #'G'
            beq handle_g
            cmp #'T'
            beq handle_t
            cmp #'U'
            beq @go_u

@go_u:      jmp handle_u

hault:      jsr PutCRLF
            jmp kRST
            
            ;
            ; Handle Go
            ;
            
handle_g:   ldx CNOUN
            cpx #'N'
            bne @match_e
            lda GNADD
            jmp @validnoun
@match_e:   cpx #'E'
            bne @match_s
            lda GEADD
            jmp @validnoun
@match_s:   cpx #'S'
            bne @match_w
            lda GSADD
            jmp @validnoun
@match_w:   cpx #'W'
            bne @fail
            lda GWADD
            jmp @validnoun

@fail:      ldx #<INWORD    ; Verbose Wrong Noun
            ldy #>INWORD                      
            jsr PutStr
            ldx #<s_err2
            ldy #>s_err2                      
            jsr PutStr
            jmp prompt  

@validnoun: cmp #0          ; Check if allowed
            bne @valid

            jsr PutCRLF     ; Show invalid choice
            ldx #<s_err3
            ldy #>s_err3                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt
            
@valid:     sta GAMEP+1
            lda GCADD
            sta GAMEP
            
            jsr PutCRLF
            ldx #<s_verb1   ; Verbose Decision 
            ldy #>s_verb1                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            
            jmp describe
            
            ; Handle Take
            
handle_t:   ldx #<s_verb2
            ldy #>s_verb2                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt
            
            ;
            ; Handle Use
            ;
            
handle_u:   ldx #<s_verb3
            ldy #>s_verb3                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt

;
; String/Char Constants
;

s_hello:    .byte CR,LF,"Abirahasa Game Interpreter"
            .byte CR,LF,"by Kaveen Rodrigo (2022)",0
s_prompt:   .byte CR,LF,">",0
s_err1:     .byte " is not a valid verb",0
s_err2:     .byte " is not a valid noun",0
s_verb1:    .byte "Going ",0
s_verb2:    .byte "Taking ",0
s_verb3:    .byte "Using ",0
s_err3:     .byte "Can't Go ",0

;
; TTY IO Routines
;

PutChar:    sta SAVEA
            sty SAVEY
            jsr kOUTCH
            ldy SAVEY
            lda SAVEA
            rts

PutCRLF:    sta SAVEA
            lda #CR
            jsr PutChar
            lda #LF
            jsr PutChar
            lda SAVEA
            rts
           
PutPtrSTR:  sty SAVEY
            ldy #0                        
@loop:      lda (PRINTP), y
            beq @stop                      
            jsr PutChar
            iny                          
            jmp @loop                   
@stop:      ldy SAVEY
            rts

PutStr:     txa
            sta PRINTP
            tya
            sta PRINTP+1
            jsr PutPtrSTR
            rts

GetChar:    sty SAVEY
            jsr kGETCH
            ldy SAVEY
            rts
            
GetWord:    stx SAVEX
            sta SAVEA
            ldx #0
@loop:      jsr GetChar
            cmp #SP
            beq @stop
            cmp #CR
            beq @stop
            sta INWORD,X
            inx
            jmp @loop
@stop:      lda #0
            sta INWORD,X
            ldx SAVEX
            lda SAVEA
            rts
            
;
; Game Data
; Formatted as follows,
; "ASCII" $0 %00000000 $00 $00 $00 $00 $00
;

game:       .byte <@1,>@1,0,0,0
            .byte "You're at the side of an empty road, north of you is a foot path..."
            .byte CR,LF,"There is a sign that says 'Welcome To Abirahasa' next to the path"
@1:         .byte 0,0,0,0,0
            .byte "You walk along, to find a clearing with an old house, it looks uninhabited."
            .byte CR,LF,"Shaking the door knob reveal that it's locked. Off to the left is an garage."