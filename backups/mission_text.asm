```
;Writes row $2500 (9th row from top).
IntroRow1_9:
L867A:  .byte $25, $04, $1C     ;PPU address and string length.
;              D    E    F    E    A    T    _    T    H    E    _    M    E    T    R    0
L867D:  .byte $0D, $0E, $0F, $0E, $0A, $1D, $FF, $1D, $11, $0E, $FF, $16, $0E, $1D, $1B, $18
;              I    D    _    O    F    _    _    _    _    _    _    _
L868D:  .byte $12, $0D, $FF, $18, $0F, $FF, $FF, $FF, $FF, $FF, $FF, $FF

;Writes row $2540 (11th row from top).
IntroRow1_11:
L8699:  .byte $25, $44, $1A     ;PPU address and string length.
;              T    H    E    _    P    L    A    N    E    T    _    Z    E    B    E    T
L869C:  .byte $1D, $11, $0E, $FF, $19, $15, $0A, $17, $0E, $1D, $FF, $23, $0E, $0B, $0E, $1D
;              H    _    A    N    D    _    _    _    _    _
L86AC:  .byte $11, $FF, $0A, $17, $0D, $FF, $FF, $FF, $FF, $FF

;Writes row $2580 (13th row from top).
IntroRow1_13:
L86B6:  .byte $25, $84, $1A     ;PPU address and string length.
;              D    E    S    T    R    O    Y    _    T    H    E    _    M    O    T    H
L86B9:  .byte $0D, $0E, $1C, $1D, $1B, $18, $22, $FF, $1D, $11, $0E, $FF, $16, $18, $1D, $11
;              E    R    _    B    R    A    I    N    _    _
L86C9:  .byte $0E, $1B, $FF, $0B, $1B, $0A, $12, $17, $FF, $FF

;Writes row $25C0 (15th row from top).
IntroRow1_15:
L86D3:  .byte $25, $C4, $1A     ;PPU address and string length.
;              T    H    E    _    M    E    C    H    A    N    I    C    A    L    _    L
L86D6:  .byte $1D, $11, $0E, $FF, $16, $0E, $0C, $11, $0A, $17, $12, $0C, $0A, $15, $FF, $15
;              I    F    E    _    V    E    I    N    _    _
L86E9:  .byte $12, $0F, $0E, $FF, $1F, $0E, $12, $17, $FF, $FF

;Writes row $2620 (18th row from top).
IntroRow1_18:
L86F0:  .byte $26, $27, $15     ;PPU address and string length.
;              G    A    L    A    X    Y    _    F    E    D    E    R    A    L    _    P
L86F3:  .byte $10, $0A, $15, $0A, $21, $22, $FF, $0F, $0E, $0D, $0E, $1B, $0A, $15, $FF, $19
;              O    L    I    C    E
L8703:  .byte $18, $15, $12, $0C, $0E

;Writes row $2660 (20th row from top).
IntroRow1_20:
L8708:  .byte $26, $69, $12     ;PPU address and string length.
;              _    _    _    _    _    _    _    _    _    _    _    _    _    _    M    5
L870B:  .byte $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $16, $05
;              1    0
L871B:  .byte $01, $00

L871D:  .byte $00               ;End PPU string write.
```

so essentially you'D wanna bring this back.