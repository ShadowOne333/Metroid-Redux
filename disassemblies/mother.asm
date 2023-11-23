;-------------------------------------------------------------------
;			Metroid mother
;			   by dACE	
;-------------------------------------------------------------------

; Metroid mother hack originally made by dACE, which combines hacks like Metroid+Saving (snarfblam), Roidz (DemickXII) and MDbtroid (Infinity's End)
; Disassembly by ShadowOne333

LoadGFX7	= $C601	; LoadGFX7 (THE NEW VERSION for enhanced ROMs)

;-------------------------------
;	Include Text TBL file
;-------------------------------
incsrc "code/text/Text.tbl"

;-------------------------------------------------------------------
; Attribute data for Title screen tiles
;-------------------------------------------------------------------
%org($833A,0)	; 0x0034A
; Title screen's ground tiles layout and positioning
	db $22,$E0,$20	; PPU address and length
	db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
	db $FF,$FF,$FF,$CD,$FF,$FF,$CE,$FF
	db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
	db $FF,$FF,$FF,$CD,$FF,$FF,$CE,$FF

	;Writes row $2300 (25th row from top).
	db $23,$00,$20	; PPU address and length
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1

	;Writes row $2320 (26th row from top).
	db $23,$20,$20	; PPU address and length
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3

	;Writes row $2340 (27th row from top).
	db $23,$40,$20	; PPU address and length
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5

	;Writes row $2360 (28th row from top).
	db $23,$60,$20	; PPU address and length
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7

	;Writes row $2380 (29th row from top).
	db $23,$80,$20	; PPU address and length
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9

	;Writes row $23A0 (Bottom row).
	db $23,$A0,$20	; PPU address and length
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B

	;Writes some blank spaces in row $20A0 (6th row from top).
	db $20,$A8,$4F	; PPU address and length
	db $FF		;Since RLE bit set, repeat 16 blanks starting at $20A8.

;-------------------------------
; Title Screen's "METROID" tilemap data for layout and positioning
	db $21,$03,$1C	; PPU address and length
	db $FF,$FF,$FF,$FF,$40,$41,$42,$43
	db $44,$45,$46,$47,$48,$49,$4A,$4B
	db $4C,$4D,$4E,$4F,$50,$51,$52,$1D
	db $16,$FF,$FF,$FF

	;Writes METROID graphics in row $2120 (10th row from top).
	db $21,$23,$1A	; PPU address and length
	db $FF,$FF,$FF,$53,$54,$55,$56,$57
	db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F
	db $60,$61,$62,$63,$64,$65,$66,$FF
	db $FF,$FF

	;Writes METROID graphics in row $2140 (11th row from top).
	db $21,$43,$1A	; PPU address and length
	db $FF,$FF,$FF,$67,$68,$69,$6A,$6B
	db $6C,$6D,$6E,$6F,$70,$71,$72,$73
	db $74,$75,$76,$77,$78,$79,$7A,$7B
	db $FF,$FF

	;Writes METROID graphics in row $2160 (12th row from top).
	db $21,$63,$1A	;PPU string length.
	db $FF,$FF,$7C,$7D,$7E,$7F,$80,$81
	db $82,$83,$84,$85,$86,$87,$88,$89
	db $8A,$8B,$8C,$8D,$8E,$8F,$90,$91
	db $FF,$FF

	;Writes METROID graphics in row $2180 (13th row from top).
	db $21,$83,$1A	;PPU string length.
	db $FF,$FF,$92,$93,$94,$95,$96,$97
	db $98,$99,$9A,$9B,$9C,$9D,$9E,$9F
	db $A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7
	db $FF,$FF

	;Writes METROID graphics in row $21A0 (14th row from top).
	db $21,$A3,$1A	; PPU address and length
	db $FF,$FF,$A8,$A9,$AA,$AB,$AC,$AD
	db $AE,$AF,$B0,$B1,$B2,$B3,$B4,$B5
	db $B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD
	db $FF,$FF

	;Writes "MOTHER" graphics in row $21C0 (15th row from top).
	; Removed "MOTHER" so it only reads "METROID" at title screen
	db $21,$C3,$1A	; PPU address and length
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF

;-------------------------------------------------------------------
%org($871E,0)	; 0x00704
; Unused area!
	%fillto($8759,0,$FF)
	db "ERROR TRY AGAIN"

;-------------------------------------

%org($851B,0)	; 0x0052B
	db $BF		; Change copyright symbol tile number

%org($9124,0)	; 0x01134
	jsr LoadGFX7	; LoadGFX7 (THE NEW VERSION for enhanced ROMs)

%org($9314,0)	; 0x01324
	nop #3		; Overwrite a jsr to load Samus GFX into pattern table

%org($93A8,0)	; 0x013B8
	jsr LoadGFX7	; LoadGFX7 (THE NEW VERSION for enhanced ROMs)

;-------------------------------------
;	Change Samus' sprite tables
;-------------------------------------
; Samus head sprite
%org($9D06,0)	; 0x01D16
	db $F8
	skip 7
	db $F8
; Samus Jumpsuit
%org($9D33,0)	; 0x01D43
	db $4D
	skip 15
	db $3A
	skip 19
	db $3A
; Jumpsuit Samus
%org($9E59,0)	; 0x01E69
	db $F8
; Bikini Samus
%org($9E8D,0)	; 0x01E9D
	db $42,$78,$F8
	skip 8
	db $F8,$45,$70,$BB,$46,$78,$BB,$48

;-------------------------------------
; Change palettes regarding Samus in the ending (EndGamePal00)
%org($9FB1,0)	; 0x01FC1
	db $26,$0F,$36,$16,$28

;-------------------------------------
; Change ground graphics writes in the ending
;-------------------------------------
%org($A052,0)	; 0x02062
	db $23,$00,$20	; PPU address and length
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1

	db $23,$20,$20	; PPU address and length
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3

	db $23,$40,$20	; PPU address and length
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5

	db $23,$60,$20	; PPU address and length
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7

	db $23,$80,$20	; PPU address and length
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9

	db $23,$A0,$20	; PPU address and length
	db $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB
	db $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB
	db $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB
	db $CA,$CB,$CA,$CB,$CA,$CB,$CA,$CB
	
;-------------------------------------
;	Animation changes
;-------------------------------------

%org($85B5,1)	; 0x045C5
; Samus on Elevator animation 1
	db $03,$03,$04,$04,$03,$03,$05,$05,$FF,$FF
	skip 5
; Samus on Elevator animation 2
	db $0C,$0C,$0D,$0D,$0C,$0C,$0E,$0E,$FF
	skip 6
; Samus on Elevator animation 3
	db $40,$40,$41,$41,$40,$40,$42,$42,$FF


; Pointer changes to sprite drawing stuff (Animations?)
%org($86C1,1)	; 0x046D1
	dw l_8AC4	; Kraid Statue
%org($86D5,1)	; 0x046E5
	dw l_8AA1,l_8AB6	; Pointers to unused sprite frame data
; Pointer change for placement of sprites for Samus' body and enemies
%org($86FB,1)	; 0x0470B
	dw l_8ACD	; Pointer to a later section of Kraid's statue?

;-------------------------------------
; Sprite frame data table changes
;-------------------------------------

%org($8806,1)	; 0x04816
; Samus facing forward
	db $0A,$FE,$19,$1A,$29,$2A,$FE,$39
	db $4D,$FF,$39,$FF

; Rewrite unused sprite frame entry
%org($8AA1,1)	; 0x04AB1
l_8AA1:
	db $1E,$00,$08
	db $F5,$F6,$F7,$FA,$FB,$FC
	db $08,$04,$C5,$C6,$C7
	db $D5,$D6,$D7,$E5,$E6,$E7,$FF

; Rewrite Kraid Statue sprite entry
l_8AB6:
	db $1E,$00,$08
	db $F5,$F6,$F7,$FA,$FB,$FC
	db $08,$04,$C5,$C6,$C7
l_8AC4:
	db $D5,$D6,$D7,$E5,$E6,$E7,$FF

; Rewrite Ridley Statue sprite entry

	db $1E,$00
l_8ACD:
	db $08
	db $F8,$F9,$FE,$FA,$FB,$FC
	db $00,$04,$C8,$C9,$FE
	db $D8,$D9,$EA,$E8,$E9,$EB,$FF
	db $EB,$FF,$00,$F4,$00,$FC
	db $00,$04,$08,$F8,$08,$00
	db $E8,$F0,$E8,$F8,$E8,$00
	db $F0,$F0,$F0,$F8,$F0,$00
	db $F8,$F0,$F8,$F8,$F8,$00


; Graphics data, partial font "THE END"
; Modified in mother to add/change to new graphics
%org($8D60,1)	; 0x04D70
; Copy over data from the original ROM starting at 0x05FD3
	incbin "rom/Metroid.nes":$5FD2..$6284

Plts_9016:
; Palette data
	db $0F,$20,$10,$00
	db $0F,$22,$12,$1C
	db $0F,$27,$11,$07
	db $0F,$22,$12,$1C
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$27,$2A,$3C
	db $0F,$15,$21,$38
	db $00		; Terminator

	db $3F,$12,$02
	db $19,$27,$00

	db $3F,$12,$02	; PPU address and length
	db $2C,$27,$00

	db $3F,$12,$02	; PPU address and length
	db $19,$35,$00

	db $3F,$12,$02	; PPU address and length
	db $2C,$24,$00
	
	db $3F,$00,$10	; PPU address and length
	db $0F,$20,$10,$00
	db $0F,$28,$19,$17
	db $0F,$27,$11,$07
	db $0F,$28,$16,$17

	db $3F,$14,$0C	; PPU address and length
	db $0F,$12,$30,$21
	db $0F,$26,$1A,$31
	db $0F,$15,$21,$38
	db $00

	db $3F,$11,$03	; PPU address and length
	db $04,$09,$07,$00

	db $3F,$11,$03	; PPU address and length
	db $05,$09,$17,$00

	db $3F,$11,$03	; PPU address and length
	db $06,$0A,$26,$00

	db $3F,$11,$03	; PPU address and length
	db $16,$19,$27,$00

	db $3F,$00,$04	; PPU address and length
	db $0F,$30,$30,$21,$00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$17,$00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$19,$00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$28,$00

	db $3F,$10,$04
	db $0F,$15,$34,$29,$00

; Animation stuff?
l_90B2:
	db $02,$C0,$90,$03,$05,$04,$03,$00
	db $0F,$FF

	db $02,$05,$37,$00,$03,$CF,$90
	db $18,$06,$02,$09,$67,$00,$1B,$FF
	
	db $02,$08,$87,$00,$05,$DE,$90
	db $07,$06,$02,$02,$37,$00,$19,$FF

	db $02,$00,$37,$00,$07,$EB,$90,$0C
	db $04,$0A,$00,$19,$FF

	db $02,$08,$87,$00,$09,$F8,$90,$13
	db $06,$02,$07,$37,$00,$15,$FF
	
	db $03,$00,$0B,$06,$91,$12,$06,$02
	db $09,$67,$00,$16,$FF
	
	db $04,$01,$00,$0E,$15,$91,$02,$06
	db $02,$04,$96,$00,$09,$FF
	
	db $02,$08,$12,$00,$12,$FF,$FF,$07,$FF
	db $04,$02,$00

; Copy over data from the original ROM starting at 0x06FA4
	incbin "rom/Metroid.nes":$6F6B..$7000

; Pointers for new addresses
	dw $9216,$9229,$9242,$925B
	dw $9262,$9269,$926D,$9278
	dw $9285,$9291,$9297,$929C
	dw $92AC,$92B0,$92BA,$92DF
	dw $92E9,$92FC,$9311,$9320
	dw $932A,$9334,$933F,$9350
	dw $9375,$9378,$937E,$938B
	dw $939B,$93A5,$93AA,$93BF
	dw $93D4,$93DA,$93DD,$93F1
	dw $9402,$9417,$9420,$9424
	dw $9437,$9442,$9445,$9450
	dw $945A,$945D,$9470,$9473
	dw $9476,$947F

; Copy over data from the original ROM starting at 0x06FA4
	incbin "rom/Metroid.nes":$6C94..$6F00
	%fillto($9490,1,$00)	; Blank out remaining original bytes

;-------------------------------------

; Enemy sprite drawing pointer tables
%org($9DE0,1)	; 0x05DF0
EnemyFramePtrTbl1:
	dw $8D60,$8D65,$8D6A,$8D6F
	dw $8D78,$8D81,$8D81,$8D81
	dw $8D81,$8D81,$8D81,$8D81
	dw $8D81,$8D81,$8D81,$8D81
	dw $8D81,$8D81,$8D81,$8D81
	dw $8D81,$8D81,$8D81,$8D81
	dw $8D81,$8D81,$8D8F,$8D9D
	dw $8DA9,$8DB7,$8DC5,$8DD1
	dw $8DDA,$8DE4,$8DEE,$8DF7
	dw $8E01,$8E0B,$8E0B,$8E0B
	dw $8E19,$8E20,$8E29,$8E29
	dw $8E29,$8E29,$8E29,$8E29
	dw $8E29,$8E29,$8E29,$8E29
	dw $8E29,$8E29,$8E29,$8E29
	dw $8E3D,$8E51,$8E5C,$8E67
	dw $8E70,$8E79,$8E84,$8E84
	dw $8E84,$8E84,$8E84,$8E84
	dw $8E84,$8E84,$8E84,$8E84
	dw $8E84,$8E84,$8E84,$8E84
	dw $8E84,$8E84,$8E84,$8E84
	dw $8E84,$8E84,$8E84,$8E84
	dw $8E84,$8E84,$8E84,$8E84
	dw $8E84,$8E8C,$8E94,$8E9C
	dw $8EA4,$8EAC,$8EB4,$8EBC
	dw $8EC4,$8ECC,$8EDA,$8EF4
	dw $8F00,$8F0D,$8F15,$8F1D
	dw $8F25,$8F2D,$8F35,$8F3D
	dw $8F45,$8F4D,$8F55,$8F5D
	dw $8F65,$8F6D,$8F75,$8F7D
	dw $8F85,$8F8D,$8F95,$8F95
	dw $8F95,$8F95,$8F95,$8F95
	dw $8F95,$8F95,$8F95,$8F95
	dw $8F95,$8F9D,$8FA2,$8FA2
	dw $8FA2,$8FA2,$8FA2,$8FA2
	dw $8FA2,$8FA2,$8FA7,$8FA7
	dw $8FA7,$8FA7,$8FA7,$8FA7
	dw $8FB1,$8FBB,$8FCB,$8FDB
	dw $8FEB,$8FFB,$9005

; Enemy frame drawing data (?)
; Pointers to new addresses
%org($9FC2,1)	; 0x05FD2
l_9FC2:
	db $0B,$87,$27,$87,$41,$87,$65,$87
	db $A0,$87,$D2,$87,$09,$88,$3F,$88
	db $6C,$88,$9E,$88,$C2,$88,$FA,$88
	db $20,$89,$4C,$89,$78,$89,$9C,$89
	db $C6,$89,$00,$8A,$27,$8A,$53,$8A
	db $76,$8A,$8E,$8A,$BB,$8A,$DC,$8A
	db $06,$8B,$46,$8B,$76,$8B,$9C,$8B
	db $D2,$8B,$01,$8C,$1C,$8C,$5C,$8C
	db $88,$8C,$B7,$8C,$E7,$8C,$11,$8D
	db $47,$8D,$95,$8D,$D7,$8D,$0A,$8E
	db $39,$8E,$62,$8E,$83,$8E,$B0,$8E
	db $15,$8F,$44,$8F,$61,$8F,$FF,$FF

; Copy over data from the original ROM starting at 0x06453
	incbin "rom/Metroid.nes":$6453..$6C94

	%fillto($AFBC,1,$00)

; Some palettes of sorts
	db $3F,$00,$20		; PPU address and length
	db $0F,$20,$10,$00
	db $0F,$28,$19,$17
	db $0F,$27,$11,$07
	db $0F,$28,$16,$17
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$26,$1A,$31
	db $0F,$15,$21,$38
	db $00		; Terminator byte

; Could be some palette changing for animation?
l_AFE0:
	db $2B,$2C,$28,$0B,$1C,$0A,$1A,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;-------------------------------------
;	Animation changes (2)
;-------------------------------------

%org($85B3,2)	; 0x085C3
; Samus on elevator animation 1
	db $07,$F7,$03,$03,$04,$04,$03,$03
	db $05,$05,$FF,$FF,$07,$F7,$FF
; Samus on elevator animation 2
	db $23,$F7,$0C,$0C,$0D,$0D,$0C,$0C
	db $0E,$0E,$FF,$F7,$23,$F7,$FF
; Samus on elevator animation 3
	db $07,$F7,$40,$40,$41,$41,$40,$40
	db $42,$42,$FF

;-------------------------------------

; Pointers to even more tables
%org($8D60,2)	; 0x08D70
	dw $8F06,$8F0B,$8F10,$8F15
	dw $8F28,$8F3C,$8F52,$8F68
	dw $8F7B,$8F8F,$8FA5,$8FBB
	dw $8FC5,$8FCA,$8FCF,$8FD4
	dw $8FD9,$8FDE,$8FE3,$8FE8
	dw $8FED,$8FFB,$9009,$9017
	dw $9026,$9035,$9046,$9057
	dw $905F,$9065,$906B,$9071
	dw $9077,$907D,$9085,$908D
	dw $9095,$9095,$9095,$9095
	dw $90A1,$90AF,$90BD,$90CB
	dw $90D7,$90E5,$90F3,$9101
	dw $910C,$911B,$912A,$9139
	dw $9148,$9155,$9155,$9155
	dw $9155,$9155,$9155,$9155
	dw $915D,$9165,$916D,$9175
	dw $917D,$9185,$918F,$9194
	dw $919C,$91A4,$91A4,$91A4
	dw $91A4,$91A4,$91A4,$91A4
	dw $91A4,$91A4,$91A4,$91A4
	dw $91A4,$91A4,$91A4,$91A4
	dw $91A4,$91A4,$91A4,$91A4
	dw $91A4,$91B0,$91BC,$91C8
	dw $91D4,$91E0,$91EC,$91F8
	dw $9204,$920C,$921A,$9234
	dw $9234,$9234,$9234,$923C
	dw $9244,$924C,$9254,$925C
	dw $9264,$9264,$9264,$9264
	dw $9264,$9264,$9264,$9264
	dw $9264,$9264,$9264,$9264
	dw $9264,$9264,$9264,$9264
	dw $9264,$9264,$9264,$9264
	dw $9264,$926A,$926F,$926F
	dw $926F,$926F,$926F,$926F
	dw $926F,$926F,$8E90,$8E92
	dw $8EAA,$8EAA,$8EBC,$8EAE
	dw $8EB8,$8EC0,$8ECC,$8ED4
	dw $8ED4,$8EF4,$8F02,$8F06

; Copy over data from the original ROM starting at 0x09DA4
l_8E90:	; 0x08EA0
	incbin "rom/Metroid.nes":$9DA4..$A188

; Possible animation data
l_9284:
	db $0A,$83,$92,$1B,$06,$02,$09
	db $34,$00,$1C,$FF

	db $02,$09,$34,$00,$0B,$9D,$92,$16
	db $05,$04,$81,$00,$1A,$06,$02,$09
	db $34,$00,$1B,$06,$02,$09,$34,$00
	db $1C,$FF

	db $02,$09,$34,$00,$0C,$A6,$92,$1A
	db $FF

	db $02,$07,$37,$00,$0D,$AE,$92,$16,$FF

	db $04,$81,$00,$0E,$B7,$92,$12,$FF

	db $02,$09,$34,$00,$0F,$D6,$92,$11
	db $07,$02,$09,$34,$03,$00,$13,$06
	db $02,$09,$34,$00,$14,$06,$02,$09
	db $34,$00,$15,$FF

	db $41,$8B,$E9,$51,$02,$9B,$00,$10
	db $DF,$92,$0F,$FF

	db $02,$03,$37,$00,$11,$08,$93,$16
	db $04,$0A,$00,$18,$09,$31,$0B,$E9
	db $41,$02,$9A,$00,$19,$09,$21,$8B
	db $E9,$51,$02,$9A,$00,$1B,$06,$02
	db $01,$37,$00,$1D,$05,$09,$A0,$00
	db $1E,$FF

	db $09,$B0,$00,$13,$11,$93,$1A,$FF
	db $02,$08,$42,$00,$14,$24,$93,$0D
	db $05,$09,$A0,$00,$0E,$05,$09,$B0
	db $00,$1C,$FF

	db $02,$09,$34,$00,$15,$32,$93,$12
	db $06,$02,$06,$37,$00,$17,$FF

	db $09,$A0,$00,$16,$FF,$FF,$13,$06,$02
	db $09,$34,$00,$14,$06,$02,$09,$34
	db $00,$19,$FF,$04,$04,$00,$0E,$FF

l_9348:
; Copy over data from the original ROM starting at 0x0AD3B
	incbin "rom/Metroid.nes":$AD3B..$AEFC

	%fillto($9560,2,$00)

; More pointers
	dw $9C64,$9C88,$9C94,$9C8E
	dw $9C9A,$AFBC,$9CC3,$9CC3
	dw $9CC3,$9CC3,$9CC3,$9CC3
	dw $9CC3,$9CC3,$9CC3,$9CC3
	dw $9CC3,$9CC3,$9CC3,$9CC3
	dw $9CCA,$9CD1,$9CD8,$9CDF
	dw $9CE7,$9CEF,$9CF7,$9CFF
	dw $9274,$9E07,$8400,$8000
	dw $8D60,$8E60,$8E74


%org($9C64,2)	; 0x09C74
l_9C64:
; Copy over data from the original ROM starting at 0x0A188
	incbin "rom/Metroid.nes":$A188..$A22B

; Copy over data from the original ROM starting at 0x0AEFC
	incbin "rom/Metroid.nes":$AEFC..$AFFC

; New pointers
	dw $86C0,$86DC,$86F6,$872B
	dw $8762,$87A6,$87E4,$882E
	dw $8860,$8898,$88D1,$8912
	dw $8950,$8977,$89B1,$89E3
	dw $8A18,$8A47,$8A82,$8AB7
	dw $8AEC,$8B1F,$8B64,$8B8B
	dw $8BB8,$8BEB,$8C15,$8C42
	dw $8C80,$8CB2,$8CE4,$8D0E
	dw $8D38,$8D76,$8DA8,$8DE0
	dw $8E0D,$8E46,$8E6D,$8EA9
	dw $8EDE,$8F13,$8F46,$8F7B
	dw $8FAB,$8FD2

	db $FF,$FF

; Copy over data from the original ROM starting at 0x0A3BD
	incbin "rom/Metroid.nes":$A3BD..$ACC9

	%fillto($AF3D,2,$00)

;-------------------------------------

%org($8D1E,12)	; 0x30D2E
; Another modified part from Ridley's code?
	incbin "rom/Metroid.nes":$1694F..$169CF
%org($8D1F,12)	; 0x30D2F
	db $00,$00,$00,$00,$00,$00,$00	; Blanked out in Mother
%org($8D8D,12)	; 0x30D9D
	db $00		; Blanked out in Mother
;-------------------------------------

; DONE AUTOMATICALLY WITH ASAR'S EXPANSION METHOD, NOT NEEDED!!!
;%org($99A8,14)	; 0x399B8
	;%fillto($BFFF,14,$00)

%org($BFFE,14)	; 0x3C00E
	dw l_C65A	; 5A C6 (?)

;-------------------------------------
;	Bank 7 changes 
;-------------------------------------
; Bank 7 was copied to Bank 15 through 'dd' in Linux, only the custom code will be implemented afterwards

%org($C06D,15)	; 0x3C07D
	lda #%00011110	; Mapper #1 (MMC1)
			; Verticle mirroring.
			; H/V mirroring (As opposed to one-screen mirroring)
			; Switch low PRGROM area during a page switch
			; 16KB PRGROM switching enabled
			; 8KB CHRROM switching enabled

%org($C106,15)	; 0x3C116
	jmp l_C672
l_C109:
	skip 10
	rts

%org($C4F8,15)	; 0x3C508
	sta $28	; SwitchUpperBits
	;nop #2	; NOPs in the original Mother code (why?)

%org($C54C,15)	; 0x3C55C
	jsr LoadGFX7
%org($C572,15)	; 0x3C582
	jsr l_C606
%org($C58A,15)	; 0x3C59A
	jsr l_C60B
%org($C5A2,15)	; 0x3C5B2
	jsr l_C610
%org($C5BD,15)	; 0x3C5CD
	jsr l_C615
	skip 10
	
	jsr l_C61A
	skip 7
	
	lda #$00
	jmp l_C61F
l_C5D9:
	sta $A000
	lsr
	sta $A000
	lsr
	sta $A000
	lsr
	sta $A000
	lsr
	sta $A000
	tya
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000
	lsr
	sta $C000
	rts
l_C600:
	lda #$00
	jmp l_C61F
l_C606:
	lda #$01
	jmp l_C61F
l_C60B:
	lda #$02
	jmp l_C61F
l_C610:
	lda #$03
	jmp l_C61F
l_C615:
	lda #$04
	jmp l_C61F
l_C61A:
	lda #$05
	jmp l_C61F

l_C61F:
	asl
	asl
	tax
	lda l_C65A,x
	sta $7800
	lda l_C65B,x
	sta $7801
	sta $7803
	lda l_C65C,x
	sta $7802
	lda l_C65D,x
	sta $7804
	sta $7805
	cpx #$00
	beq +
	lda $69B3
	beq +
	inc $7800
+	ldy $23
	jsr $C4EF
	ldy $7803
	lda $7800
	jmp l_C5D9

l_C65A:
	db $01
l_C65B:
	db $00
l_C65C:
	db $00
l_C65D:
	db $10,$02,$04,$07,$10,$08,$0A,$0D
	db $10,$0E,$10,$13,$10,$14,$16,$19
	db $10,$1A,$1C,$1F,$10

l_C672:
	jsr $C97E
	dec $7805
	beq +
	jmp l_C69D
+	lda $7804
	sta $7805
	lda $7803
	inc $7803
++	cmp $7802
	bne +
	lda $7801
	sta $7803
+	ldy $7803
	lda $7800
	jsr l_C5D9

l_C69D:
	jmp l_C109

l_C6A0:
	db $00,$14,$00,$05,$08,$00,$B4,$00
	db $10,$00,$04,$08,$00,$B4,$00,$0A
	db $A0,$00,$08,$00,$B8,$00,$00,$B0
	db $07
	
	nop

%org($C7B6,15)	; 0x3C7C6
	lda $C63B,y

%org($CA35,15)	; 0x3CA45






