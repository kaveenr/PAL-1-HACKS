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
    CPICK   =   $32         ; 1 byte char of pickup
    
    ; Scene Defintion
    
    ZGAME   =   $33         ; Shortcut ADDR for below

    GCADD   =   ZGAME       ; GO Adress Common High byte
    GNADD   =   ZGAME+1     ; GO Adress North Low byte
    GEADD   =   ZGAME+2     ; GO Adress East Low byte
    GSADD   =   ZGAME+3     ; GO Adress South Low byte
    GWADD   =   ZGAME+4     ; GO Adress West Low byte
    GPICK   =   ZGAME+5     ; Avaiable Pickup
    GGDIR   =   ZGAME+6     ; Gated Direction
    GGPICK  =   ZGAME+7     ; Gated Direction Key Pick
    GDESC   =   ZGAME+8     ; 2 byte address of description
    GGERR   =   ZGAME+10    ; 2 byte address of error

; Constants

    GRLEN  =   11           ; len in bytes of record
    
    ; ASCII

    CR      =   $0D         ; Carriage Return
    LF      =   $0A         ; Line Feed
    SP      =   $20         ; Space

;
; Program Entrypoint
;

    .org    $0200 

init:       cld             ; Clear Decimal Mode 
            ldx #<s_hello   ; Show Welcome Message
            ldy #>s_hello                      
            jsr PutStr
            lda #<game      ; Set Game Scene Pointer
            sta GAMEP                  
            lda #>game                    
            sta GAMEP+1 
            lda #0          ; Clear Game Vars
            sta CPICK

describe:   ldy #0          ; Copy of scene to ZP
@loop:      lda (GAMEP), y
            sta ZGAME, y
            iny
            cpy #GRLEN+1
            bne @loop

@endloop:   jsr PutCRLF     ; Print Description
            ldx GDESC
            ldy GDESC+1
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
            cmp #'Q'
            beq hault
            
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
            beq @go_t
            cmp #'U'
            beq @go_u

@go_u:      jmp handle_u
@go_t:      jmp handle_t

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
            
@valid:     cpx GGDIR       ; check if direc is gated
            bne @move
            
            ldx GGPICK      ; check if gate is fullfilled
            cpx CPICK
            beq @move
            
            jsr PutCRLF     ; Show gate fail
            ldx GGERR
            ldy GGERR+1                 
            jsr PutStr
            
            jmp prompt

@move:      sta GAMEP
            lda GCADD
            sta GAMEP+1
            jmp describe
            
            ;
            ; Handle Take
            ;
            
handle_t:   lda GPICK
            cmp #0
            beq @fail
            cmp INWORD
            bne @fail
            sta CPICK
            
            ldx #<s_verb2
            ldy #>s_verb2                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt

@fail:      ldx #<s_err4
            ldy #>s_err4                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt
            
            ;
            ; Handle Use
            ;
            
handle_u:   lda CPICK       ; Check if a pickup is present
            cmp #0
            beq @empty
            cmp GGPICK      ; check if pickup is usable 
            bne @invalid
            
            lda GGDIR
            sta CNOUN
            jmp handle_g

@empty:     ldx #<s_err5
            ldy #>s_err5                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt

@invalid:   ldx #<s_err6
            ldy #>s_err6                      
            jsr PutStr
            ldx #<INWORD
            ldy #>INWORD                      
            jsr PutStr
            jmp prompt

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
            jsr ToUpper
            ldy SAVEY
            rts

ToUpper:    cmp #'a'
            bmi @skip
            cmp #'z'+1
            bpl @skip
            and #%11011111
@skip:      rts
            
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
; String/Char Constants
;

s_hello:    .byte CR,LF,"Abirahasa Game Interpreter"
            .byte CR,LF,"by Kaveen Rodrigo (2022)",CR,LF,0
s_prompt:   .byte CR,LF,">",0
s_err1:     .byte " is not a valid verb",0
s_err2:     .byte " is not a valid noun",0
s_verb2:    .byte "Taking ",0
s_err3:     .byte "Can't go ",0
s_err4:     .byte "Can't take ",0
s_err5:     .byte "You don't have a ",0
s_err6:     .byte "Can't use a ",0


;
; Game Data
;
            ;      Ca    Na    Ea    Sa    Wa    Pc    Gd    Gp     Desc ptr. 
game:       .byte (>@1),(<@1),(0  ),(0  ),(0  ),(0  ),(0  ),(0  ),  (<@t1),(>@t1)
@1:         .byte (>@1),(<@3),(0  ),(0  ),(<@2),(0  ),('N'),('K'),  (<@t2),(>@t2), (<@e1),(>@e1)
@2:         .byte (>@1),(0  ),(<@1),(0  ),(0  ),('K'),(0  ),(0  ),  (<@t3),(>@t3)
@3:         .byte (>@3),(<@5),(<@4),(0  ),(0  ),(0  ),('N'),('L'),  (<@t4),(>@t4), (<@e2),(>@e2)
@4:         .byte (>@3),(0  ),(0  ),(0  ),(<@3),('L'),(0  ),(0  ),  (<@t5),(>@t5)
@5:         .byte (0  ),(0  ),(0  ),(0  ),(0  ),(0  ),(0  ),(0  ),  (<@t6),(>@t6)

@t1:        .byte "You're at the side of an empty road, north of you is a foot path..."
            .byte CR,LF,"There is a sign that says 'Welcome To Abirahasa' next to the path.",0

@t2:        .byte "You walk along, to find a clearing with an old house, it looks uninhabited."
            .byte CR,LF,"Shaking the door knob reveal that it's locked. Off to the left is an garage.",0

@t3:        .byte "You walk into the garage to see an old Volkswagen Karmann Ghia covered in dust."
            .byte CR,LF,"At the back is a bench with broken car parts."
            .byte CR,LF,"You go closer to see a jar full of bolts... Shining in it is a key!",0
            
@t4:        .byte "With hesitation the door creaks open to a dingy and dusty living room..."
            .byte CR,LF,"It's much bigger space that anticipated, ahead is darkness."
            .byte CR,LF,"There seems to be a kitchen area to the right", 0

@t5:        .byte "You break the cobwebs and navigate to the kitchen, there is a book on the table"
            .byte CR,LF,"the cover seems familiar to you. Next to it is a lamp.",0
            
@t6:        .byte "With the light of the lamp, you navigate to an open door way which leads down."
            .byte CR,LF,"The floorboards creak as you take every step. You're shocked to see a lit candle"
            .byte CR,LF,"on the table in the corner. No one seems to be here through!",0
            
@e1:        .byte "Door is locked, you need to USE a key!",0
@e2:        .byte "It's too dark to go foward!",0