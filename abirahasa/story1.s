; ASCII Constants

CR      =   $0D         ; Carriage Return
LF      =   $0A         ; Line Feed
SP      =   $20         ; Space

;
; Game Data
;

.org $1000

; Loc   ;      Ca    Na    Ea    Sa    Wa    Pc    Gd    Gp     Desc ptr. 
game:   .byte (>@1),(<@1),(0  ),(0  ),(0  ),(0  ),(0  ),(0  ),  (<@t1),(>@t1)
@1:     .byte (>@1),(<@3),(0  ),(0  ),(<@2),(0  ),('N'),('K'),  (<@t2),(>@t2), (<@e1),(>@e1)
@2:     .byte (>@1),(0  ),(<@1),(0  ),(0  ),('K'),(0  ),(0  ),  (<@t3),(>@t3)
@3:     .byte (>@3),(<@5),(<@4),(0  ),(0  ),(0  ),('N'),('L'),  (<@t4),(>@t4), (<@e2),(>@e2)
@4:     .byte (>@3),(0  ),(0  ),(0  ),(<@3),('L'),(0  ),(0  ),  (<@t5),(>@t5)
@5:     .byte (0  ),(0  ),(0  ),(0  ),(0  ),(0  ),(0  ),(0  ),  (<@t6),(>@t6)

@t1:    .byte "You're at the side of an empty road, north of you is a foot path..."
        .byte CR,LF,"There is a sign that says 'Welcome To Abirahasa' next to the path.",0

@t2:    .byte "You walk along, to find a clearing with an old house, it looks uninhabited."
        .byte CR,LF,"Shaking the door knob reveal that it's locked. Off to the left is an garage.",0

@t3:    .byte "You walk into the garage to see an old Volkswagen Karmann Ghia covered in dust."
        .byte CR,LF,"At the back is a bench with broken car parts."
        .byte CR,LF,"You go closer to see a jar full of bolts... Shining in it is a key!",0
@t4:    .byte "With hesitation the door creaks open to a dingy and dusty living room..."
        .byte CR,LF,"It's much bigger space that anticipated, ahead is darkness."
        .byte CR,LF,"There seems to be a kitchen area to the right", 0

@t5:    .byte "You break the cobwebs and navigate to the kitchen, there is a book on the table"
        .byte CR,LF,"the cover seems familiar to you. Next to it is a lamp.",0
@t6:    .byte "With the lamp, you navigate to an open door way which leads down. You're shocked"
        .byte CR,LF,"to see a lit candle on a table in the corner. On it is a framed photo..."
        .byte CR,LF,"You're in it too!! You hear a sudden noise from behind",0

@e1:    .byte "Door is locked, you need to USE a key!",0
@e2:    .byte "It's too dark to go foward!",0