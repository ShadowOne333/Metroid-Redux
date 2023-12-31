;-------------------------------------------------------------------
;			Metroid mother
;			   by dACE	
;-------------------------------------------------------------------

; Metroid mother hack originally made by dACE, which combines hacks like Metroid+Saving (snarfblam), Roidz (DemickXII) and MDbtroid (Infinity's End)
; Disassembly by ShadowOne333

;-------------------------------------
;	Declarations
;-------------------------------------

	; Existing vars (names generally taken from M1 disassembly)
CurrentBank	= $23	; Current memory page in lower memory block
StructPtr	= $35	; Low byte of structure pointer address
;StructPtr+1	= $36	; High byte of structure pointer address
MacroPtr	= $3F	; Low byte of pointer into macro definitions
;MacroPtr+1	= $40	; High byte of pointer into macro definitions
PageIndex	= $4B	; Index to object data.
			; #$D0, #$E0, #$F0 = Projectile indices (including bombs)
RoomNumber	= $5A	; Room number currently being loaded

	; Existing routines
NMIVector	= $C0D9	; Non-Maskable Interrupt routine
MMCWriteReg3	= $C4FA	; Swap to PRG bank #0 at $8000
LoadGFX7	= $C601	; LoadGFX7 (THE NEW VERSION for enhanced ROMs)
IncBankLock1	= $CA35	; Increment BankLock
DecBankLock1	= $CA45	; Decrement BankLock
IncBankLock2	= $CA51	; Increment BankLock
SaveSamusData	= $CA61	; Prepare to save Samus' data
SaveSamusDataInSlot	= $CA69	; Save Samus' data in appropriate saved game slot
EraseAllGameData	= $CAA1	; Erase selected saved game data
LoopUntilErased	= $CAB4	; Loop until all saved game data is erased
BitRoomDataBanked	= $CABD	; bit RoomDataBanked
GetEnemyData	= $EB0C	; Obtain enemy data
ChooseHandlerRoutine	= $EDD6	; Choose handler routine
DrawStruct	= $EAA2	; Jump to DrawStruct routine at $EF8C
Copy4Tiles	= $EF49	; Prepare to copy 4 tile numbers
DoOneEnemy	= $F351	; 
Xminus16	= $F1F4	; 

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
	db $F5,$F6,$F7
	db $FA,$FB,$FC
	db $00,$04	; Position bytes (Y, X)
	db $C5,$C6,$C7
	db $D5,$D6,$D7
	db $E5,$E6,$E7
	db $FF	; End

; Rewrite Kraid Statue sprite entry
l_8AB6:
	db $1E,$00,$08
	db $F8,$F9,$FE
	db $FA,$FB,$FC
	db $00,$04	; Position bytes (Y, X)
	db $C8,$C9,$FE
l_8AC4:
	db $D8,$D9,$EA
	db $E8,$E9,$EB
	db $FF	; End

; Rewrite Ridley Statue sprite entry
	db $EB,$FF
l_8ACD:
	db $00,$F4
	db $00,$FC,$00,$04,$08,$F8,$08,$00
	db $E8,$F0,$E8,$F8,$E8,$00,$F0,$F0
	db $F0,$F8,$F0,$00,$F8,$F0,$F8,$F8
	db $F8,$00
	;db $1E,$00

	;db $08
	;db $F8,$F9,$FE,$FA,$FB,$FC
	;db $00,$04,$C8,$C9,$FE
	;db $D8,$D9,$EA,$E8,$E9,$EB,$FF
	;db $EB,$FF,$00,$F4,$00,$FC
	;db $00,$04,$08,$F8,$08,$00
	;db $E8,$F0,$E8,$F8,$E8,$00
	;db $F0,$F0,$F0,$F8,$F0,$00
	;db $F8,$F0,$F8,$F8,$F8,$00

;-------------------------------------
; Graphics data, partial font "THE END"
; Modified in Mother to add/change to new graphics
;-------------------------------------

%org($8D60,1)	; 0x04D70
; Copy over data from the original ROM starting at 0x05FD3
	incbin "rom/Metroid.nes":$5FD2..$6288

; Copy over palette data from the original ROM starting at 0x06288
Plts_9016:	; 0X05026
	incbin "rom/Metroid.nes":$6288..$6324

; Ridley Room definitions, starting at room #$09
l_90B2:		; 0x050C2
	incbin "rom/Metroid.nes":$63E6..$6451

; Force/change some room definition pointers from above
%org($90B3,1)	; 0x050C3
	dw $90C0
	skip 12
	dw $90CF
	skip 13
	dw $90DE
	skip 13
	dw $90EB
	skip 11
	dw $90F8
	skip 11
	dw $9106
	skip 12
	dw $9115

; Jump back where we left off
%org($911D,1)	; 0x0512D
l_911D:
; Copy over data from the original ROM starting at 0x06FA4
	incbin "rom/Metroid.nes":$6F6B..$7000

l_91B2:
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

	%fillto($94F5,1,$00)	; Blank out remaining original bytes

; Ridley Room definitions (again), starting at room #$09
l_94F5:		; 0x05504
	incbin "rom/Metroid.nes":$63E6..$6451

; Force/change some room definition pointers from above
%org($94F6,1)	; 0x05506
	dw $9503
	skip 12
	dw $9512
	skip 13
	dw $9521
	skip 13
	dw $952E
	skip 11
	dw $953B
	skip 11
	dw $9549
	skip 12
	dw $9558

; Jump back where we left off
%org($9560,1)	; 0x05570
; Some pointers for the moved data's new addresses
	dw $900F,$9033,$903F,$9039
	dw $9045,$AFBC,$906E,$906E
	dw $906E,$906E,$906E,$906E
	dw $906E,$906E,$906E,$906E
	dw $906E,$906E,$906E,$906E
	dw $9075,$907C,$9083,$908A
	dw $9092,$909A,$90A2,$90AA
	dw $90B2,$9FC2,$8400,$8000

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
	dW $870B,$8727,$8741,$8765
	dW $87A0,$87D2,$8809,$883F
	dW $886C,$889E,$88C2,$88FA
	dW $8920,$894C,$8978,$899C
	dW $89C6,$8A00,$8A27,$8A53
	dW $8A76,$8A8E,$8ABB,$8ADC
	dW $8B06,$8B46,$8B76,$8B9C
	dW $8BD2,$8C01,$8C1C,$8C5C
	dW $8C88,$8CB7,$8CE7,$8D11
	dW $8D47,$8D95,$8DD7,$8E0A
	dW $8E39,$8E62,$8E83,$8EB0
	dW $8F15,$8F44,$8F61,$FFFF

; Copy over data from the original ROM starting at 0x06453
	incbin "rom/Metroid.nes":$6453..$6C94

	%fillto($AFBC,1,$00)

l_AFBC:
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

l_AFE0:
; Could be some palette animation?
	db $2B,$2C,$28,$0B,$1C,$0A,$1A,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF


;-------------------------------------
;	   Bank 2 ($8000)
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
l_8E90:		; 0x08EA0
	incbin "rom/Metroid.nes":$9DA4..$A188

; Copy over data from the original ROM starting at 0x09DA4
l_9284:		; 0x09294
	incbin "rom/Metroid.nes":$A2E9..$A3BD

; Force/change some room definition pointers from above
%org($9275,2)	; 0x09285
	dw $9283
	skip 13
	dw $929D
	skip 24
	dw $92A6
	skip 7
	dw $92AE
	skip 6
	dw $92B7
	skip 7
	dw $92D6
	skip 29
	dw $92DF
	skip 7
	dw $9308
	skip 39
	dw $9311
	skip 7
	dw $9324
	skip 17
	dw $9332

; Jump back where we left off
%org($9346,2)	; 0x09356
l_9346:
; Copy over data from the original ROM starting at 0x0AD39
	incbin "rom/Metroid.nes":$AD39..$AEFC

l_950A:
	%fillto($9560,2,$00)

l_9560:
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

	%fillto($AF2E,2,$00)

; Copy over data from the original ROM starting at 0x0A2E9
	incbin "rom/Metroid.nes":$A2E9..$A377

; Force/change some room definition pointers from above
%org($AF2F,2)	; 0x0AF3F
	dw $AF3D
	skip 13
	dw $AF57
	skip 24
	dw $AF60
	skip 7
	dw $AF68
	skip 6
	dw $AF71
	skip 7
	dw $AF90
	skip 29
	dw $AF99
	skip 7
	dw $AFC2

; Jump back where we left off
%org($AFBC,2)	; 0x0AFCC
; Copy over palette data from the original ROM at 0x0A
	db $3F,$00,$20
	db $0F,$20,$10,$00
	db $0F,$28,$16,$04
	db $0F,$16,$11,$04
	db $0F,$35,$1B,$16
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$14,$23,$2C
	db $0F,$16,$24,$37
	db $00		; Palette PPU terminator byte
	db $10,$05,$27,$04,$0F

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF

;-------------------------------------
; 	Bank 3 ($C000)
;-------------------------------------

%org($85B5,3)	; 0x0C5C5
; Samus on Elevator animation 1
	db $03,$03,$04,$04,$03,$03,$05,$05,$FF,$FF
	skip 5
; Samus on Elevator animation 2
	db $0C,$0C,$0D,$0D,$0C,$0C,$0E,$0E,$FF
	skip 6
; Samus on Elevator animation 3
	db $40,$40,$41,$41,$40,$40,$42,$42,$FF

; Implement a bunch of new pointers for the moved data
%org($8D60,3)	; 0x0CD70
	dw $8EFC,$8F01,$8F06,$8F0B
	dw $8F18,$8F25,$8F2F,$8F34
	dw $8F3A,$8F41,$8F47,$8F4C
	dw $8F52,$8F59,$8F5F,$8F64
	dw $8F69,$8F6E,$8F75,$8F85
	dw $8F93,$8F9F,$8FAC,$8FBB
	dw $8FC5,$8FD0,$8FD7,$8FE0
	dw $8FF0,$9000,$9010,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9014,$9014
	dw $9014,$9014,$9022,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$903C,$903C,$903C
	dw $903C,$9042,$9047,$9047
	dw $9047,$9047,$9047,$9047
	dw $9047,$9047,$8E94,$8E96
	dw $8EAE,$8EC0,$8EC6,$8ED2
	dw $8ED8,$8ED8,$8ED8,$8ED8
	dw $8ED8,$8EF8,$8EF8,$8EFC
	dw $8EFC,$8EFC
	
; Import data from 0x0E570
	incbin "rom/Metroid.nes":$E570..$E728

; Implement palette data
	db $3F,$00,$20	; PPU address and length
	db $0F,$20,$10,$00
	db $0F,$20,$11,$00
	db $0F,$16,$20,$00
	db $0F,$20,$10,$00
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$27,$16,$30
	db $0F,$16,$2A,$37
	db $00

	db $3F,$12,$02	; PPU address and length
	db $19,$27,$00

	db $3F,$12,$02	; PPU address and length
	db $2C,$27,$00

	db $3F,$12,$02	; PPU address and length
	db $19,$35,$00

	db $3F,$12,$02	; PPU address and length
	db $2C,$24,$00

	db $3F,$0A,$01	; PPU address and length
	db $27,$00

	db $3F,$0A,$01	; PPU address and length
	db $20,$00

	db $3F,$00,$11	; PPU address and length
	db $0F,$20,$16,$00
	db $0F,$20,$11,$00
	db $0F,$20,$16,$00
	db $0F,$20,$10,$00
	db $0F,$00

	db $3F,$00,$11	; PPU address and length
	db $20,$02,$16,$00
	db $20,$02,$11,$00
	db $20,$02,$16,$00
	db $20,$02,$10,$00
	db $20,$00

	db $3F,$00,$60	; PPU address and length
	db $20,$00

	db $3F,$11,$03	; PPU address and length
	db $04,$09,$07,$00

	db $3F,$11,$03	; PPU address and length
	db $05,$09,$17,$00

	db $3F,$11,$03	; PPU address and length
	db $06,$0A,$26,$00

	db $3F,$11,$03	; PPU address and length
	db $16,$19,$27,$00

	db $3F,$00,$04	; PPU address and length
	db $0F,$30,$30,$21
	db $00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$17
	db $00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$19
	db $00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$28
	db $00

	db $3F,$10,$04	; PPU address and length
	db $0F,$15,$34,$29
	db $00

	db $03,$0D,$91	; PPU address and length
	db $01,$FF

; Import data from 0x0E850
	incbin "rom/Metroid.nes":$E850..$E8BF

; Force/change some room definition pointers from above
%org($910E,3)	; 0x0D11E
	dw $9115
	skip 6
	dw $9125
	skip 14
	dw $912C
	skip 5
	dw $9133
	skip 5
	dw $913A

; Jump back where we left off
%org($9179,3)	; 0x0D189
; Import data from 0xEECD
	incbin "rom/Metroid.nes":$EECD..$EF59

; Pointers for the moved data
	dw $9245,$9258,$927F,$9298
	dw $929F,$92A6,$92A9,$92BA
	dw $92D3,$92E4,$92F5,$92FF
	dw $9328,$9355,$935C,$936B
	dw $936E,$9377,$9390,$9395
	dw $939A,$93C8,$93DB,$93F7
	dw $940C,$942D,$943E,$9449
	dw $944D,$9450,$945B,$9465

; Import data from 0x0EC26
	incbin "rom/Metroid.nes":$EC26..$EE59

	%fillto($9560,3,$00)

; Even more pointers to moved areas' new addresses
	dw $904C,$9070,$907C,$9076
	dw $9082,$AFBC,$9088,$908D
	dw $9092,$90A7,$90BC,$90C1
	dw $90C1,$90C1,$90C1,$90C1
	dw $90C1,$90C1,$90C1,$90C1
	dw $90C8,$90CF,$90D6,$90DD
	dw $90E5,$90ED,$90F5,$90FD
	dw $9105

	dw $A42C,$8400,$8000
	dw $8D60,$8E60,$8E74
	
	; Clear leftover byte from original LDA $06


%org($A357,3)	; 0x0E367
; Change one byte in Ridley's Room #$07 attribute table data, room object data
	db $F8

%org($A3FC,3)	; 0x0E40C
; Change Ridley's Room #$0A attribute table data, room object data
	db $A1,$A1,$A2,$A2,$A3,$A3,$A4,$A4,$A5,$A5

%org($A42C,3)	; 0x0E43C
; Pointers for moved areas' new addresses
	dw $8697,$86A5,$86BF,$86F4
	dw $8723,$8758,$876F,$878A
	dw $87A5,$87C9,$87EC,$882D
	dw $886F,$88A8,$88DD,$890F
	dw $8947,$8979,$89A2,$89CB
	dw $89EC,$FFFF

; Import data from 0x0E8C1
	incbin "rom/Metroid.nes":$E8C1..$EC26

	%fillto($AF49,3,$00)

%org($AF8C,3)	; 0x0EF9C
; Import data from 0x0E84B
	incbin "rom/Metroid.nes":$E84B..$E87B

; Force/change some room definition pointers from above
%org($AF8D,3)	; 0x0EF9D
	dw $AF94
	skip 6
	dw $AF9C
	skip 6
	dw $AFAC
	skip 14
	dw $AFB3
	skip 5
	dw $AFBA
	skip 5
	dw $AFC1	; This one gets cut-off for some reason

; Jump back where we left off
%org($AFBC,3)	; 0x0EFCC
	db $3F,$00,$20
	db $0F,$20,$16,$00
	db $0F,$20,$11,$00
	db $0F,$16,$27,$00
	db $0F,$20,$10,$00
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$27,$16,$30
	db $0F,$16,$2A,$37
	db $00

	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

;-------------------------------------
; 	Bank 4 ($10000)
;-------------------------------------

%org($85B5,4)	; 0x0105C5
; Samus on Elevator animation 1
	db $03,$03,$04,$04,$03,$03,$05,$05,$FF,$FF
	skip 5
; Samus on Elevator animation 2
	db $0C,$0C,$0D,$0D,$0C,$0C,$0E,$0E,$FF
	skip 6
; Samus on Elevator animation 3
	db $40,$40,$41,$41,$40,$40,$42,$42,$FF

%org($8D60,4)	; 0x010D70
; Update pointers for the moved data's new addresses
	dw $8F42,$8F47,$8F4C,$8F51
	dw $8F51,$8F51,$8F51,$8F51
	dw $8F51,$8F51,$8F51,$8F51
	dw $8F51,$8F51,$8F51,$8F51
	dw $8F51,$8F51,$8F51,$8F51
	dw $8F51,$8F51,$8F51,$8F51
	dw $8F51,$8F51,$8F5F,$8F6D
	dw $8F79,$8F87,$8F95,$8FA1
	dw $8FAA,$8FB4,$8FBE,$8FC7
	dw $8FD1,$8FDB,$8FDB,$8FDB
	dw $8FE9,$8FF0,$8FF9,$8FF9
	dw $8FF9,$8FF9,$8FF9,$8FF9
	dw $8FF9,$8FF9,$8FF9,$8FF9
	dw $8FF9,$8FF9,$8FF9,$8FF9
	dw $900D,$9021,$902C,$9037
	dw $9040,$9049,$9054,$9054
	dw $9054,$9054,$9054,$9054
	dw $9054,$9054,$9054,$9054
	dw $9054,$9054,$9054,$9054
	dw $9054,$9054,$9054,$9054
	dw $9054,$9054,$9054,$9054
	dw $9054,$9054,$9054,$9054
	dw $9054,$905C,$9064,$906C
	dw $9074,$907C,$9084,$908C
	dw $9094,$909C,$90AA,$90C4
	dw $90C4,$90C4,$90C4,$90CC
	dw $90D4,$90DC,$90E4,$90EC
	dw $90F4,$90FC,$9104,$910C
	dw $9114,$911C,$9124,$912C
	dw $9134,$913C,$9144,$9144
	dw $9144,$9144,$9144,$9144
	dw $9144,$9144,$9144,$9144
	dw $9144,$914C,$9151,$9151
	dw $9151,$9151,$9151,$9151
	dw $9151,$9151,$9156,$9156
	dw $9156,$9156,$9156,$9156
	dw $9160,$916A,$917F,$9194
	dw $91A9,$9D61,$9D6B,$8EAE
	dw $8EB0,$9D3F,$8EE0,$8EE0
	dw $8EE0,$8EF0,$8EFC,$8F04
	dw $8F10,$8F10,$8F30,$8F3E
	dw $8F3E,$8F3E,$8F3E

; Import data from 0x011E55
	incbin "rom/Metroid.nes":$11E55..$12111

l_916A:		; 0x1117A
; Custom PPU transfers
	db $22,$14,$0C	; PPU address and length
	db $C9,$EA,$FA,$C5,$C6,$C7,$D5,$D6
	db $D7,$E5,$E6,$E7,$FB,$EB,$F5,$F6
	db $F7,$FF

	db $22,$14,$0C	; PPU address and length
	db $C9,$EA,$FA,$C5,$C6,$C7,$D5,$D6
	db $D7,$E5,$E6,$E7,$FB,$EB,$E8,$E9
	db $F9,$FF

	db $62,$14,$0C	; PPU address and length
	db $C9,$EA,$FA,$C5,$C6,$C7,$D5,$D6
	db $D7,$E5,$E6,$E7,$FB,$EB,$F5,$F6
	db $F7,$FF

	db $62,$14,$0C	; PPU address and length
	db $C9,$EA,$FA,$C5,$C6,$C7,$D5,$D6
	db $D7,$E5,$E6,$E7,$FB,$EB,$E8,$E9
	db $F9,$FF

	db $3F,$00,$20
	db $0F,$20,$10,$00
	db $0F,$28,$19,$1A
	db $0F,$28,$16,$04
	db $0F,$23,$11,$02
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$27,$1B,$36
	db $0F,$17,$22,$31
	db $00		; Palette PPU terminator byte

l_91E2:
; Import data from 0x12189 and 0x1227D
	incbin "rom/Metroid.nes":$12189..$121E5
	incbin "rom/Metroid.nes":$1227D..$122C1

; Force/change some room definition pointers from above
%org($923F,4)	; 0x1124F
	dw $9246
	skip 6
	dw $924E
	skip 6
	dw $925D
	skip 13
	dw $9266
	skip 7
	dw $926F
	skip 7
	dw $9278
	skip 7
	dw $927F

; Jump back where we left off
%org($9282,4)	; 0x11292
; VERIFY 
	db $08,$FF,$02,$08,$BE,$00
	dw $943F,$9448
; Import data from 0x12A7B
	incbin "rom/Metroid.nes":$12A7B..$12C42

	%fillto($9560,4,$00)

l_11560:	; 0x11570
; Update pointers for the moved data's new addresses
	dw $91BE,$91E2,$91EE,$91E8
	dw $91F4,$AFBC,$91FA,$91FA
	dw $91FA,$91FA,$91FA,$91FA
	dw $91FA,$91FA,$91FA,$91FA
	dw $91FA,$91FA,$91FA,$91FA
	dw $9201,$9208,$920F,$9216
	dw $921E,$9226,$922E,$9236
	dw $923E,$9DF7,$8400,$8000
	dw $8D60,$8E60,$8E8E


%org($9CF7,4)	; 0x11D07
; Import data from 0x12C42
	incbin "rom/Metroid.nes":$12C42..$12C8A

; Who knows
	dw $F4EC,$FCEC,$04EC,$F4F4
	dw $FCF4,$04F4,$F4FC,$FCFC
	dw $04FC,$F404,$FC04,$0404
	dw $E40C,$EC0C,$F40C,$FC0C
	dw $040C

; Import data from 0x12151
; This one has some differences!!!
	incbin "rom/Metroid.nes":$12151..$12165

; Import data from 0x12CBF
	incbin "rom/Metroid.nes":$12CBF..$12D42

	dw $8633,$8641,$865B,$8699
	dw $86D6,$8719,$8749,$8792
	dw $87D3,$880F,$883E,$8873
	dw $88A5,$88E9,$8921,$8950
	dw $8979,$89A9,$89A9,$89E5
	dw $8A17,$8A3B,$8A75,$8AA7
	dw $8AE2,$8B14,$8B58,$8BA1
	dw $8C05,$8C29,$8C85,$8CB1
	dw $8CD4,$8CF2,$8D20,$8D60
	dw $8D95,$FFFF

; Import data from 0x122C9
	incbin "rom/Metroid.nes":$122C9..$12628

; Import data from 0x12657
	incbin "rom/Metroid.nes":$12657..$12A7B

; Import data from 0x12A4C
	incbin "rom/Metroid.nes":$12A4C..$12A7B

	%fillto($AD32,4,$00)


%org($AFB6,4)	; 0x12FC6
	db $12,$BE,$AF,$07,$FF,$04

; Palette data
	db $3F,$00,$20
	db $0F,$20,$10,$00
	db $0F,$28,$19,$1A
	db $0F,$28,$16,$04
	db $0F,$23,$11,$02
	db $0F,$04,$09,$07
	db $0F,$12,$30,$21
	db $0F,$27,$1B,$36
	db $0F,$17,$22,$31
	db $00		; Palette PPU terminator byte

	%fillto($B000,4,$FF)

;-------------------------------------
; 	Bank 5 ($14000)
;-------------------------------------

%org($85B5,5)	; 0x145C5
; Samus on Elevator animation 1
	db $03,$03,$04,$04,$03,$03,$05,$05,$FF,$FF
	skip 5
; Samus on Elevator animation 2
	db $0C,$0C,$0D,$0D,$0C,$0C,$0E,$0E,$FF
	skip 6
; Samus on Elevator animation 3
	db $40,$40,$41,$41,$40,$40,$42,$42,$FF


; Updated pointers for moved data
%org($8D60,5)	; 0x14D70
	dw $8F48,$8F4D,$8F52,$8F57
	dw $8F77,$8FA7,$8FC7,$9C80
	dw $9CA0,$9CD0,$AC3D,$8FFD
	dw $9007,$900C,$9011,$9016
	dw $901B,$9020,$9025,$902A
	dw $902F,$902F,$902F,$902F
	dw $903E,$904D,$905E,$906F
	dw $9077,$9077,$9077,$9077
	dw $9077,$9077,$907F,$9087
	dw $9087,$9087,$9087,$9087
	dw $9093,$90A1,$90AF,$90BD
	dw $90C9,$90D7,$90E5,$90F3
	dw $90FE,$910C,$911A,$9126
	dw $9134,$9142,$914E,$914E
	dw $9162,$9176,$9176,$9176
	dw $9176,$9176,$9176,$9176
	dw $9176,$9176,$9176,$917B
	dw $9183,$918B,$918B,$918B
	dw $918B,$918B,$918B,$918B
	dw $918B,$918B,$918B,$918B
	dw $918B,$918B,$918B,$918B
	dw $918B,$918B,$918B,$918B
	dw $918B,$9197,$91A3,$91AF
	dw $91BB,$91C7,$91D3,$91DF
	dw $91EB,$91F3,$9201,$921B
	dw $921B,$921B,$921B,$9223
	dw $922B,$9233,$923B,$9243
	dw $924B,$924B,$924B,$924B
	dw $924B,$924B,$924B,$924B
	dw $924B,$924B,$924B,$924B
	dw $924B,$924B,$924B,$924B
	dw $924B,$924B,$924B,$924B
	dw $924B,$9251,$9256,$9256
	dw $9256,$9256,$9256,$9256
	dw $9256,$9256,$8E92,$8E94
	dw $AC6D,$8ED0,$8EE2,$8ED4
	dw $8EDE,$8EE6,$8EF2,$8EFA
	dw $8EFA,$8F1A,$8F28,$8F2C
	dw $8F3C

; Import data from 0x15D32
	incbin "rom/Metroid.nes":$15D32..$15DF7

l_1516A:		; 0x1517A
; Custom PPU transfers
	db $22,$13,$14	; PPU address and length
	db $C8,$C9,$C0,$C1,$FE,$D8,$D9,$D0
	db $D1,$E0,$FE,$C5,$C6,$C7,$E1,$FE
	db $D5,$D6,$D7,$E5,$E6,$E7,$F0,$F1
	db $EB,$F5,$F6,$F7,$FF

	db $22,$13,$14	; PPU address and length
	db $FE,$FE,$C0,$C1,$FE,$FE,$FE,$D0
	db $D1,$E0,$FD,$A2,$D8,$D9,$FD,$22
	db $C6,$C7,$E1,$FD,$A2,$C8,$C9,$FD
	db $22,$D6,$D7,$E5,$E6,$E7,$FD,$A2
	db $F0,$F1,$FD,$22,$FD,$62,$EB,$FD
	db $22,$F5,$F6,$F7,$FF

	db $22,$13,$14	; PPU address and length
	db $C8,$C9,$E8,$E9,$EA,$D8,$D9,$F8
	db $F9,$FE,$FE,$C5,$C6,$C7,$FA,$FE
	db $D5,$D6,$D7,$E5,$E6,$E7,$F0,$F1
	db $EB,$F5,$F6,$F7,$FF

	db $22,$13,$14	; PPU address and length
	db $FE,$FE,$E8,$E9,$EA,$FE,$FE,$F8
	db $F9,$FE,$FD,$A2,$D8,$D9,$FD,$22
	db $C6,$C7,$FA,$FD,$A2,$C8,$C9,$FD
	db $22,$D6,$D7,$E5,$E6,$E7,$FD,$A2
	db $F0,$F1,$FD,$22,$FD,$62,$EB,$FD
	db $22,$F5,$F6,$F7,$FF

	db $00,$00,$00,$00,$00,$00

; Import data from 0x15E9D
	incbin "rom/Metroid.nes":$15E9D..$1618E

; Import data from 0x1621C
	incbin "rom/Metroid.nes":$1621C..$16258

; Force/change some room definition pointers from above
%org($92EE,5)	; 0x152FE
	dw $1800,$92FD
	skip 12
	dw $9306
	skip 7
	dw $930F
	skip 7
	dw $9318
	skip 15
	dw $9474,$947B,$9484,$9487

; Import data from 0x169CF
	incbin "rom/Metroid.nes":$169CF..$16B33

	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

%org($952D,5)	; 0x1553D
; Import data from 0x1621C
	incbin "rom/Metroid.nes":$1621C..$16258

; Force/change some room definition pointers from above
%org($952D,5)	; 0x1553D
	dw $1800,$953C
	skip 12
	dw $9545
	skip 7
	dw $954E
	skip 7
	dw $9557
	skip 15

; Jump back where we left off
	dw $925B,$927F,$928B,$9285
	dw $9291,$AFBC,$92AB,$92AB
	dw $92AB,$92AB,$92AB,$92AB
	dw $92AB,$92AB,$92AB,$92AB
	dw $92AB,$92AB,$92AB,$92AB
	dw $92B2,$92B9,$92C0,$92C7
	dw $92CF,$92D7,$92DF,$92E7
	dw $92EF,$9CF0,$8400,$8000
	dw $8D60,$8E60,$8E74


%org($9BF0,5)	; 0x15C00
; Import data from 0x16B33
	incbin "rom/Metroid.nes":$16B33..$16B9D

	db $25,$08,$08	; PPU address and length
	db $FD,$A2,$CE,$FD,$22,$CF,$FD,$E2
	db $CE,$FD,$22,$DE,$FD,$62,$DE,$FF

	db $25,$08,$08	; PPU address and length
	db $FD,$A2,$CE,$FD,$22,$CF,$FD,$E2
	db $CE,$FD,$22,$DF,$FD,$62,$DF,$FF

	db $62,$13,$14	; PPU address and length
	db $C8,$C9,$C0,$C1,$FE,$D8,$D9,$D0
	db $D1,$E0,$FE,$C5,$C6,$C7,$E1,$FE
	db $D5,$D6,$D7,$E5,$E6,$E7,$F0,$F1
	db $EB,$F5,$F6,$F7,$FF

	db $62,$13,$14	; PPU address and length
	db $FE,$FE,$C0,$C1,$FE,$FE,$FE,$D0
	db $D1,$E0,$FD,$E2,$D8,$D9,$FD,$62
	db $C6,$C7,$E1,$FD,$E2,$C8,$C9,$FD
	db $62,$D6,$D7,$E5,$E6,$E7,$FD,$E2
	db $F0,$F1,$FD,$62,$FD,$22,$EB,$FD
	db $62,$F5,$F6,$F7,$FF

	db $62,$13,$14	; PPU address and length
	db $C8,$C9,$E8,$E9,$EA,$D8,$D9,$F8
	db $F9,$FE,$FE,$C5,$C6,$C7,$FA,$FE
	db $D5,$D6,$D7,$E5,$E6,$E7,$F0,$F1
	db $EB,$F5,$F6,$F7,$FF

; Updated pointers for moved data
	dw $8600,$8600,$861A,$864C
	dw $8677,$868B,$86BD,$86E8
	dw $8726,$875C,$8791,$87D2
	dw $8702,$882E,$8865,$889C
	dw $88CF,$88FE,$892E,$8980
	dw $89C4,$89F7,$8A32,$8A5B
	dw $8A88,$8AB5,$8ADE,$8B0B
	dw $8B4A,$8B7C,$8BAE,$8BDB
	dw $8C05,$8C28,$8C46,$8C6C
	dw $8C9E,$8CCB,$8D09,$8D3C
	dw $8D5A,$8D84,$FFFF

; Import data from 0x16251
	incbin "rom/Metroid.nes":$16251..$169CF

	%fillto($AC23,5,$00)

; Leftover PPU data?
	db $E9,$EA,$D8,$D9,$F8,$F9,$FE,$FE
	db $C5,$C6,$C7,$FA,$FE,$D5,$D6,$D7
	db $E5,$E6,$E7,$F0,$F1,$EB,$F5,$F6
	db $F7,$FF

	db $62,$13,$14	; PPU address and length
	db $FE,$FE,$E8,$E9,$EA,$FE,$FE,$F8
	db $F9,$FE,$FD,$E2,$D8,$D9,$FD,$62
	db $C6,$C7,$FA,$FD,$E2,$C8,$C9,$FD
	db $62,$D6,$D7,$E5,$E6,$E7,$FD,$E2
	db $F0,$F1,$FD,$62,$FD,$22,$EB,$FD
	db $62,$F5,$F6,$F7,$FF

	; Table?
	db $E4,$E8,$E4,$F0,$E4,$F8,$E4,$00
	db $E4,$08,$EC,$E8,$EC,$F0,$EC,$F8
	db $EC,$00,$EC,$08,$F4,$E8,$F4,$F0
	db $F4,$F8,$F4,$00,$F4,$08,$FC,$E8
	db $FC,$F0,$FC,$F8,$FC,$00,$04,$F0
	db $04,$F8,$04,$00,$0C,$D8,$0C,$E0
	db $0C,$E8,$0C,$F0,$0C,$F8,$0C,$00
	db $0C,$08

%org($AFBC,5)	; 0x16FCC
; Palette data
	db $3F,$00,$20
	db $0F,$20,$16,$04
	db $0F,$21,$14,$13
	db $0F,$27,$16,$02
	db $0F,$15,$16,$04
	db $0F,$16,$19,$27
	db $0F,$12,$30,$21
	db $0F,$14,$13,$29
	db $0F,$13,$15,$27
	db $00		; Palette PPU terminator byte

	%fillto($B000,5,$FF)

;-------------------------------------
; 	Bank 6 ($18000)
;-------------------------------------

; Blank out portions of the bank
%org($8000,6)	; 0x18010
	%fillto($8A9D,6,$00)

%org($8BE0,6)	; 0x18BF0
	%fillto($9897,6,$00)

%org($9980,6)	; 0x19990
	%fillto($99B0,6,$00)

%org($9DA0,6)	; 0x19DB0
	%fillto($B4AE,6,$00)

%org($B4C8,6)	; 0x1B4D8
	%fillto($B8BC,6,$00)

;-------------------------------------
; 	Bank 7 ($1C000)
; Graphics data (graphics.asm)
;-------------------------------------

; This bank has been implemented inside the graphics.asm file

;-------------------------------------
; 	Bank 8 ($20000)
;-------------------------------------

%org($8000,8)	; 0x20010
; Import data from 0x06F00
	incbin "rom/Metroid.nes":$06F00..$07000

; Force/change some data from imported section above
%org($8010,8)	; 0x20020
	db $F2,$FF,$F2,$FF,$FF,$F3,$FF,$F3

; Jump back where we left off
%org($8100,8)	; 0x20110
	db $A0,$A0,$A1,$A1,$A2,$A2,$A3,$A3
	db $A4,$A4,$A5,$A5,$F4,$F5,$F4,$F5
	db $F6,$F7,$F6,$F7,$A8,$A8,$A9,$A9
	db $AA,$AA,$AB,$AB,$AC,$AC,$AD,$AD
	db $F8,$F9,$FF,$FF,$FA,$FB,$FF,$FF
	db $BB,$BB,$66,$66

; New pointers for moved data
	dw $933F,$9350,$9375,$9378
	dw $937E,$938B,$939B,$93A5
	dw $93AA,$93BF,$93D4,$93DA
	dw $93DD,$93F1,$9402,$9417
	dw $9420,$9424,$9437,$9442
	dw $9445,$9450,$945A,$945D
	dw $9470,$9473,$9476,$947F

; Import data from 0x06C94
	incbin "rom/Metroid.nes":$06C94..$06F00

	%fillto($8400,8,$00)

; New pointers for moved data
	dw $8470,$8483,$849C,$84B5
	dw $84BC,$84C3,$84C7,$84D2
	dw $84DF,$84EB,$84F1,$84F6
	dw $8506,$850A,$8514,$8539
	dw $8543,$8556,$856B,$857A
	dw $8584,$858E,$8599,$85AA
	dw $85CF,$85D2,$85D8,$85E5
	dw $85F5,$85FF,$8604,$8619
	dw $862E,$8634,$8637,$864B
	dw $865C,$8671,$867A,$867E
	dw $8691,$869C,$869F,$86AA
	dw $86B4,$86B7,$86CA,$86CD
	dw $86D0,$86D9,$86DC,$86E9
	dw $86F6,$86FF,$8702,$8705

; Import data from 0x06C94
	incbin "rom/Metroid.nes":$06C94..$06F00

; Force/change some structure definitions modifications above
%org($84B6,8)	; 0x204C6
	db $40,$01,$41,$01,$42,$FF,$01,$45
	db $01,$46,$01,$47

; Jump back where we left off
%org($86DC,8)	; 0x206EC
	db $01,$43,$01,$43,$01,$43,$01,$43
	db $01,$43,$01,$43,$FF,$01,$44,$01
	db $44,$01,$44,$01,$44,$01,$44,$01
	db $44,$FF,$01,$20,$01,$20,$01,$17
	db $01,$17,$FF,$01,$33,$FF,$01,$20
	db $FF,$04,$48,$49,$48,$49,$FF,$02
	db $40,$01,$02,$48,$01,$02,$50,$03
	db $00,$5F,$03,$00,$52,$37,$02,$56
	db $37,$02,$5A,$37,$02,$FD,$02,$A1
	db $02,$B1,$FF,$02,$A9,$33,$00,$A6
	db $32,$00,$06,$32,$00,$09,$33,$00
	db $87,$02,$02,$07,$02,$02,$56,$32
	db $00,$59,$33,$00,$FF

; Import data from 0x06C94
	incbin "rom/Metroid.nes":$0646C..$06680

; Pointer fixes for the imported code above
%org($8777,8)	; 0x20787
	dw $8B00
%org($87AF,8)	; 0x207BF
	dw $5E00
%org($87DE,8)	; 0x207EE
	dw $5700
	skip 4
	dw $8000
%org($88DD,8)	; 0x208ED
	dw $6000

; Jump back where we left off
%org($88FB,8)	; 0x2090B
; Import data from 0x06C94
	incbin "rom/Metroid.nes":$06620..$068F9

; Pointer? fixes for the imported code above
%org($88FB,8)	; 0x2090B
	dw $3399,$9600
	db $32
	skip 18
	dw $8000
	skip 24
	dw $8000
%org($8958,8)	; 0x20968
	dw $8C00
%org($89D5,8)	; 0x209E5
	dw $5F00
	skip 1
	dw $8000
%org($8A2D,8)	; 0x20A3D
	dw $0A03
	skip 1
	dw $5003
	skip 1
	dw $8000
%org($8A56,8)	; 0x20A66
	dw $0703
	skip 1
	dw $0E03
	skip 1
	dw $5F03
	skip 1
	dw $8A00
%org($8A79,8)	; 0x20A89
	dw $0803
	skip 1
	dw $D003
%org($8AA0,8)	; 0x20AB0
	dw $BA03
%org($8ABE,8)	; 0x20ACE
	dw $0803
	skip 1
	dw $B003
%org($8AEE,8)	; 0x20AFE
	dw $B303
%org($8AF7,8)	; 0x20B07
	dw $C803
	skip 1
	dw $D003
%org($8B15,8)	; 0x20B25
	dw $5F00
	skip 1
	dw $6400
%org($8B82,8)	; 0x20B92
	dw $8000
	skip 5
	dw $2DD0
	dw $D802
	skip 2
	dw $3495
	dw $FD00
%org($8B9F,8)	; 0x20BAF
	dw $0403
	skip 4
	dw $0A03

; Jump back where we left off
%org($8BD2,8)	; 0x20BE2
	dw $9900,$0033,$3296
; Import data from 0x06C94
	incbin "rom/Metroid.nes":$068F7..$06C34

; Pointer? fixes for the imported code above
%org($8BDB,8)	; 0x20BEB
	dw $0103
%org($8BED,8)	; 0x20BFD
	dw $6A00
	skip 1
	dw $4D03
%org($8C37,8)	; 0x20C47
	dw $5F00
	skip 1
	dw $7400
%org($8C68,8)	; 0x20C78
	dw $8000
%org($8C97,8)	; 0x20CA7
	dw $8C00
%org($8E16,8)	; 0x20E26
	dw $8000
%org($8E45,8)	; 0x20E55
	dw $8700
	skip 5
	dw $26C3,$D001,$022D,$2DD8
	skip 1
	dw $349A,$FD00
%org($8EE1,8)	; 0x20EF1
	dw $0450,$5300
	skip 4
	dw $6400

; Continue where we left off
%org($8F15,8)	; 0x20F25
	dw $9900,$0033,$3296

; Import data from 0x06C94
	incbin "rom/Metroid.nes":$06C34..$06C94

; Pointer? fixes for the imported code above
%org($8F30,8)	; 0x20F40
	dw $8000
%org($8F6A,8)	; 0x20F7A
	dw $5E00

; Continue where we left off, unknown what this is
%org($8F7B,8)	; 0x20F8B
	db $02,$B1,$FF,$FF,$FF,$FF,$FF,$B1
	db $FF,$FF,$FF,$B1,$FF,$FF,$B1,$FF
	db $FF,$FF,$FF,$B1,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$B1,$FF,$FF
	db $FF,$FF,$B1,$FF,$FF,$FF,$FF,$FF
	db $FF,$B1,$FF,$FF,$FF,$FF,$B1,$FF
	db $B1,$FF,$FF,$FF,$FF,$FF,$B1

	%fillto($8FF0,8,$FF)
	%fillto($9000,8,$00)

; The rest of the bank has been implemented inside the graphics.asm file, since everything from 0x21010 up to 0x24010 are graphics

;-------------------------------------
; 	Bank 9 ($24000)
;-------------------------------------

; Brinstar data (?)

%org($8000,9)	; 0x24010
; Import data from 0x0AEFC
	incbin "rom/Metroid.nes":$0AEFC..$0B000

%org($8010,9)	; 0x24020
	dw $FFF2,$FFF2,$F3FF,$F3FF

; Continue where we left off
%org($8100,9)	; 0x24110
	db $A0,$A0,$A1,$A1,$A2,$A2,$A3,$A3
	db $A4,$A4,$A5,$A5,$F4,$F5,$F4,$F5
	db $F6,$F7,$F6,$F7,$A8,$A8,$A9,$A9
	db $AA,$AA,$AB,$AB,$AC,$AC,$AD,$AD
	db $F8,$F9,$FF,$FF,$FA,$FB,$FF,$FF
	db $BB,$BB,$66,$66

; New pointers for moved data
	dw $A2E3,$A30A,$A337,$A36A
	dw $A394,$A3C1,$A3FF,$A431
	dw $A463,$A48D,$A4B7,$A4F5
	dw $A527,$A55F,$A58C,$A5C5
	dw $A5EC,$A628,$A65D,$A692
	dw $A6C5,$A6FA,$A72A,$A751

; Import data from 0x0A3BB
	incbin "rom/Metroid.nes":$0A3BB..$0A65F

; New pointers for moved data
	dw $846A,$847D,$8496,$84AF
	dw $84B6,$84BD,$84C1,$84C7
	dw $84D7,$84DC,$84E2,$84EA
	dw $84FF,$8508,$8512,$851D
	dw $8529,$852C,$8536,$8539
	dw $854D,$8562,$8568,$856E
	dw $8577,$8580,$8593,$85A8
	dw $85BD,$85CE,$85D4,$85D7
	dw $85E0,$85EB,$85F1,$8606
	dw $860A,$8615,$861E,$8633
	dw $8636,$863F,$8642,$8645
	dw $864B,$8658,$8662,$8677
	dw $868A,$869D,$86AA,$86B7
	dw $86BA

; Import data from 0x0ACC9
	incbin "rom/Metroid.nes":$0ACC9..$0B000

; Pointer fixes for the imported code above
%org($84B0,9)	; 0x244C0
	dw $0140,$0141,$FF42,$4501
	dw $4601,$4701
%org($869D,9)	; 0x246AD
	db $01,$43,$01,$43,$01,$43,$01,$43
	db $01,$43,$01,$43,$FF,$01,$44,$01
	db $44,$01,$44,$01,$44,$01,$44,$01
	db $44,$FF,$01,$10
	db $FF,$04,$48,$49,$48,$49,$FF,$02
	db $40,$01,$02,$48,$01,$02,$50,$04
	db $00,$5F,$04,$00,$52,$34,$01,$56
	db $34,$01,$5A,$34,$01,$FD,$02,$A1
	db $02,$B1,$FF,$02,$09,$32,$00,$06
	db $31,$00,$A6,$31,$00,$07,$02,$02
	db $87,$02,$02,$56,$31,$00,$59,$32
	db $00,$A9,$32,$00,$FF

; Import data from 0x0A3D6
	incbin "rom/Metroid.nes":$0A3D6..$0A407
	db $07,$02,$02
; Import data from 0x0A407
	incbin "rom/Metroid.nes":$0A407..$0A483

	%fillto($902C,9,$FF)

; Fixes for the imported code above
%org($86FA,9)	; 0x2470A
	db $03
	skip 2
	db $09
%org($873A,9)	; 0x2474A
	dw $5F00
	skip 1
	dw $8000
%org($877A,9)	; 0x2478A
	dw $6300

; Continue where we left off
%org($87A6,9)	; 0x247B7
	dw $9900,$0032,$3196

; Import data from 0x0A483
	incbin "rom/Metroid.nes":$0A483..$0ACC9

; Fixes for the imported code above
%org($87C1,9)	; 0x247D1
	dw $4702
	skip 7
	dw $4F02
	skip 4
	dw $6B00
%org($8875,9)	; 0x24885
	dw $8600
%org($88E6,9)	; 0x248F6
	dw $8000
%org($8921,9)	; 0x24931
	dw $5E00
%org($8986,9)	; 0x24996
	dw $5F00
	skip 1
	dw $8000
%org($89C3,9)	; 0x249D3
	dw $5E00
%org($89F2,9)	; 0x24A02
	dw $8000
%org($8A27,9)	; 0x24A37
	dw $8C00
%org($8A56,9)	; 0x24A66
	dw $5C00
%org($8A91,9)	; 0x24AA1
	dw $8000
%org($8AC6,9)	; 0x24AD6
	dw $6900
%org($8C57,9)	; 0x24C67
	dw $8000
%org($8C92,9)	; 0x24CA2
	dw $8C00
%org($8CC4,9)	; 0x24CD4
	dw $8000
%org($8D4D,9)	; 0x24D5D
	dw $8C00
%org($8D85,9)	; 0x24D95
	dw $8000
%org($8DBD,9)	; 0x24DCD
	dw $8D00
%org($8EBB,9)	; 0x24ECB
	dw $8000
%org($8EED,9)	; 0x24EFD
	dw $8000
%org($8F55,9)	; 0x24F65
	dw $8C00

; Some $03s at the end alongside the $FFs, unknown what they are for
%org($8FF3,9)	; 0x25003
	db $03
	skip 4
	db $03
	skip 4
	db $03
	skip 7
	db $03
	skip 4
	db $03
	skip 4
	db $03
	skip 4
	db $03
	skip 4
	db $03
	skip 4
	db $03

; Blank out the rest of the bank
%org($902C,9)	; 0x2503C
	%fillto($BFFF,9,$00)

;-------------------------------------
; 	Bank 10 ($28000)
;-------------------------------------

%org($8000,10)	; 0x28010
; Import data from 0x0EE59
	incbin "rom/Metroid.nes":$0EE59..$0EF49

; Fix the some bytes from the import above
%org($8000,10)	; 0x28010
	db $F1,$F1,$F1,$F1,$FF,$FF,$F0,$F0
%org($8010,10)	; 0x28020
	dw $FFF2,$FFF2,$F3FF,$F3FF,$79FF

; Continue where we left off
%org($80F0,10)	; 0x28100
	db $A0,$A0,$A1,$A1,$A2,$A2,$A3,$A3
	db $A4,$A4,$A5,$A5,$F4,$F5,$F4,$F5
	db $F6,$F7,$F6,$F7,$A8,$A8,$A9,$A9
	db $AA,$AA,$AB,$AB,$AC,$AC,$AD,$AD
	db $F8,$F9,$FF,$FF,$FA,$FB,$FF,$FF
	db $BB,$BB,$66,$66

; New pointers for moved data
	dw $935C,$936B,$936E,$9377
	dw $9390,$9395,$939A,$93C8
	dw $93DB,$93F7,$940C,$942D
	dw $943E,$9449,$944D,$9450
	dw $945B,$9465

; Import data from 0x0EC26
	incbin "rom/Metroid.nes":$0EC26..$0EE59

; Blank out up to 0x28410
	%fillto($8400,10,$00)

; New pointers for moved data
	dw $8446,$8459,$8480,$8499
	dw $84A0,$84A7,$84AA,$84BB
	dw $84D4,$84E5,$84F6,$8500
	dw $8529,$8556,$855D,$856C
	dw $856F,$8578,$8591,$8596
	dw $859B,$85C9,$85DC,$85F8
	dw $860D,$862E,$863F,$864A
	dw $864E,$8651,$865C,$8666
	dw $8679,$8686,$8693

; Import data from 0x0EC26
	incbin "rom/Metroid.nes":$0EC26..$0EE59

; Fix data from the import above
%org($8499,10)	; 0x284A9
	dw $3C01,$3D01,$3E01
	db $FF
	dw $4101,$4201,$4301
	db $FF

; Continue where we left off
%org($8679,10)	; 0x28689
; Import data from 0x0E88F
	incbin "rom/Metroid.nes":$0E88F..$0EB21

; Fix data from the import above
; Unknown what this data is
%org($8679,10)	; 0x28689
	dw $3F01,$3F01,$3F01,$3F01,$3F01,$3F01
	db $FF
	dw $4001,$4001,$4001,$4001,$4001,$4001
	db $FF
	db $02,$19,$1B,$FF
	db $02,$40,$01,$03,$48,$01,$03,$50,$03
	db $02,$5F,$03,$02,$FF,$02,$A9,$21,$00
	db $09,$21,$00,$A6,$20,$00,$06,$20,$00
	db $07,$02,$02,$87,$02,$02,$56,$20,$00
	db $59,$21,$00
; Continue with the data fixes
%org($86CB,10)	; 0x286DB
	dw $6200
	skip 14
	db $C4,$0F,$03,$C8,$0F,$03,$D3,$10,$03
	db $DB,$0A,$03,$E0,$0A,$03,$E8,$0A,$03
	db $8F,$09,$03,$8D,$22,$01,$FF
%org($8761,10)	; 0x28771
	dw $8000
%org($87D8,10)	; 0x287E8
	dw $8C00
%org($8807,10)	; 0x28817
	dw $5E00
%org($88BD,10)	; 0x288CD
	dw $5E00
%org($88DE,10)	; 0x288EE
	dw $1809
	skip 1
	dw $1800
	skip 1
	dw $1900

; Continue where we left off
%org($890B,10)	; 0x2891B
	db $07,$02,$02
; Import data from 0x0EB22
	incbin "rom/Metroid.nes":$0EB21..$0EC26
	db $01,$6A,$FF

; Fix data from the import above
%org($892D,10)	; 0x2893D
	dw $8000
%org($898B,10)	; 0x2899B
	dw $8000
%org($89B4,10)	; 0x289C4
	dw $8700

; Blank out the rest of the bank
%org($8A16,10)	; 0x28A26
	%fillto($8000,11,$00)

;-------------------------------------
; 	Bank 11 ($2C000)
;-------------------------------------

%org($8000,11)	; 0x2C010
; Copy over data from the original ROM starting at 0x12C42
	incbin "rom/Metroid.nes":$12C42..$12D42

; Fix the some bytes from the import above
%org($8010,11)	; 0x2C020
	dw $FFF2,$FFF2,$F3FF,$F3FF

; Continue where we left off
%org($8100,11)	; 0x2C110
	db $A0,$A0,$A1,$A1,$A2,$A2,$A3,$A3
	db $A4,$A4,$A5,$A5,$F4,$F5,$F4,$F5
	db $F6,$F7,$F6,$F7,$A8,$A8,$A9,$A9
	db $AA,$AA,$AB,$AB,$AC,$AC,$AD,$AD
	db $F8,$F9,$FF,$FF,$FA,$FB,$FF,$FF
	db $BB,$BB,$66,$66

; New pointers for moved data
; This is replaced by Saving v0.5.2!
	dw $A26E,$A2A0,$A2DB,$A30D
	dw $A351,$A39A,$A3FE,$A422
	dw $A47E,$A4AA,$A4CD,$A4EB
	dw $A519,$A559,$A58E

; Copy over data from the original ROM starting at 0x122C7
	incbin "rom/Metroid.nes":$122C7..$1257D

; New pointers for moved data
	dw $8452,$8465,$847E,$8497
	dw $849E,$84A5,$84A9,$84B9
	dw $84C9,$84CE,$84D3,$84D6
	dw $84D9,$84E4,$84EA,$84EF
	dw $84F8,$850D,$8510,$8523
	dw $8538,$853C,$854F,$855C
	dw $856F,$8582,$8597,$85A1
	dw $85A4,$85AB,$85C7,$85D0
	dw $85E5,$85E8,$85F1,$85F6
	dw $85FB,$8605,$860E,$8619
	dw $8626

; Copy over data from the original ROM starting at 0x12A7B
	incbin "rom/Metroid.nes":$12A7B..$12C42

; Fix the some bytes from the import above
%org($8497,11)	; 0x2C4A7
	dw $4001,$4101,$4201
	db $FF
	dw $0701,$0701,$0701
	db $FF

; Continue where we left off
%org($8619,11)	; 0x2C629
	dw $4301,$4301,$4301,$4301,$4301,$4301
	db $FF
	dw $4401,$4401,$4401,$4401,$4401,$4401
	db $FF

; Copy over data from the original ROM starting at 0x122C7
	incbin "rom/Metroid.nes":$122C7..$122D5

	db $02,$A9,$28,$00,$A6,$27,$00,$06,$27
	db $00,$09,$28,$00

; Copy over data from the original ROM starting at 0x122C7
	incbin "rom/Metroid.nes":$122D6..$122DC

; Copy over data from the original ROM starting at 0x122C7
	incbin "rom/Metroid.nes":$122D6..$12317

; Fix the some bytes from the import above
%org($8654,11)	; 0x2C664
	dw $2756,$5900,$0028
	skip 5
	dw $1003,$0900

; Continue where we left off
%org($8695,11)	; 0x2C6A5
	db $07,$02,$02

; Copy over data from the original ROM starting at 0x122C7
	incbin "rom/Metroid.nes":$12317..$12A19

; Fix the some bytes from the import above
%org($86AE,11)	; 0x2C6BE
	dw $5F00
	skip 1
	dw $8000
%org($86EE,11)	; 0x2C6FE
	dw $5700
	skip 4
	dw $8000
%org($8767,11)	; 0x2C777
	dw $5900
	skip 4
	dw $8000
%org($87A7,11)	; 0x2C7B7
	dw $6200
%org($8821,11)	; 0x2C831
	dw $8B00
%org($884D,11)	; 0x2C85D
	dw $7200
%org($88BA,11)	; 0x2C8CA
	dw $5D00
%org($88FB,11)	; 0x2C90B
	dw $5E00
%org($895C,11)	; 0x2C96C
	dw $8C00
%org($8975,11)	; 0x2C985
	dw $8707

; Continue where we left off
%org($8D9C,11)	; 0x2CDAC
; Copy over data from the original ROM starting at 0x122C7
	incbin "rom/Metroid.nes":$12A4A..$12A7B

; Fix the some bytes from the import above
%org($8DAA,11)	; 0x2CDBA
	dw $5E00

; Blank out the rest of the bank
%org($8DCD,11)	; 0x2CDDD
	;%fillto($8000,12,$00)

;-------------------------------------
; 	Bank 12 ($30000)
;-------------------------------------

%org($8000,12)	; 0x30010
	db $FF,$FF,$F0,$F0,$F1,$F1,$F1,$F1
	db $F2,$FF,$F2,$FF,$FF,$F3,$FF,$F3
; Another modified part from Ridley's code?
	incbin "rom/Metroid.nes":$16B43..$16C33

	db $A0,$A0	; Unknown what these are

%org($8D1E,12)	; 0x30D2E
; Another modified part from Ridley's code?
	incbin "rom/Metroid.nes":$1694F..$169CF
%org($8D1F,12)	; 0x30D2F
	db $00,$00,$00,$00,$00,$00,$00	; Blanked out in Mother
%org($8D8D,12)	; 0x30D9D
	db $00

; Blank out the rest of the bank and the entirety of bank 13 too
%org($8D9E,12)	; 0x30DAE
	%fillto($8000,14,$00)

;-------------------------------------
;EDITROID data bank (Bank 14, 0x38000)
;-------------------------------------

; Editroid ACSII string
%org($8000,14)	; 0x38010
	cleartable
	db "EDITROID"
	pushtable : incsrc "code/text/Text.tbl"	; Restore our TBL

; Custom Editroid tables
; We'll import the data as a binary file to save writing space, it's just a bunch of 14s and 00s with some 08s thrown in
	incbin "EditroidData.bin"

; DONE AUTOMATICALLY WITH ASAR'S EXPANSION METHOD, NOT NEEDED!!!
%org($99A8,14)	; 0x399B8
	%fillto($BFFD,13,$00)	; Fill with 00s

%org($BFFE,14)	; 0x3C00E
	dw l_C65A	; 5A C6 (?)


;-------------------------------------
;	Bank 7 changes 
;-------------------------------------
; Bank 7 was copied to Bank 15 in main.asm, only the custom code will be implemented afterwards

; Mapper load?
%org($C06D,15)	; 0x3C07D
	lda #%00011110	; Mapper #1 (MMC1)
			; Verticle mirroring.
			; H/V mirroring (As opposed to one-screen mirroring)
			; Switch low PRGROM area during a page switch
			; 16KB PRGROM switching enabled
			; 8KB CHRROM switching enabled

; 
%org($C106,15)	; 0x3C116
	jmp l_C672
l_C109:
	skip 10
	rts

; 
%org($C4F8,15)	; 0x3C508
	;sta $28	; SwitchUpperBits
	nop #2	; NOPs in the original Mother code (why?)

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
	lda $C63B,y	; Load entry 25 in GFXInfo table

%org($CA38,15)	; 0x3CA48
	lda #$FF
	sta RoomDataBanked
	lda CurrentBank
	clc
	adc #$07
	jsr MMCWriteReg3
	dec BankLock
	beq +
	dec BankLock
	jmp BitRoomDataBanked
+	rts

	inc BankLock
	lda #$00
	sta RoomDataBanked
	lda CurrentBank
	jsr MMCWriteReg3
	jmp DecBankLock1
	jsr IncBankLock1
	ldy #$00
	lda ($33),y
	rts

	jsr IncBankLock2
	ldx #$F0
	stx RoomNumber
	rts

	pha
	jsr IncBankLock2
	pla
	jsr $EB4D	; Some enemy type related code (Initial pos)
	jmp IncBankLock1
	jsr GetEnemyData	; Get enemy data
	pha
	jsr IncBankLock2
	pla
	jmp ChooseHandlerRoutine

	lda $8400,y	; Pointer to Ridley's room definitions?
	sta StructPtr
	lda $8401,y	; Pointer to Ridley's room definitions+1
	sta StructPtr+1
	jmp DrawStruct	; Draw struct
	lda $8500,y	; Pointer to Ridley's structure defs?
	sta StructPtr
	lda $8501,y	; Pointer to Ridley's structure defs+1
	sta StructPtr+1
	jmp DrawStruct
	asl
	rol MacroPtr+1
	asl
	rol MacroPtr+1
	sta $11
	lda MacroPtr+1
	and #$03
	ora #$80
	sta MacroPtr+1
	jmp Copy4Tiles	; Copy4Tiles
	asl BankLock
	bne +
	jsr BitRoomDataBanked
+	rti
	pha
	bit RoomDataBanked
	bvc +
	lda CurrentBank
	jsr MMCWriteReg3
+	jsr NMIVector	; Non-Maskable Interrupt
	bit RoomDataBanked
	bvc +
	lda CurrentBank
	clc
	adc #$07
	jsr MMCWriteReg3
+	pla
	rts

	pla
	and #$0F
	tax
	beq +
		skip 14
	+
	
%org($CCBE,15)	; 0x3CCCE
RunAnimTbl:
	db $43,$61	; SamusRun, SamusRunPntUp

%org($E758,15)	; 0x3E768
-	cmp $AFE0,y	; Is it a special room?-->
	beq +		; If so, branch to set flag to play item room music.
	iny
	cpy #$20
	bne -		; Loop until all special room numbers are checked
		skip 8
	+

;-------------------------------------

%org($EA4C,15)	; 0x3EA5C
	jsr SaveSamusData	; Jump to prepare to save Samus' data
	nop
	
%org($EA99,15)	; 0x3EAA9
; Hijack and jump to certain Load Game data sections?
	bcs +
	jmp $CA87
+	jmp $CA94

%org($EAF4,15)	; 0x3EB04
	jsr SaveSamusDataInSlot	; Jump to save Samus' data in appropriate slot
	nop

%org($EB20,15)	; 0x3EB30
	jsr $CA71	; Jump to Load Game Data?

%org($EDE4,15)	; 0x3EDF4
; Handler routines jumped to by above code
	dw $CA7C	; Pointer to some part of Load Game Data?

; Modify the Draw structure routines
%org($EF45,15)	; 0x3EF55
DrawMacro:
	jmp EraseAllGameData

; Display of enemies routine
%org($F345,15)	; 0x3F355
UpdateEnemies:
	ldx #$50
	-	jsr DoOneEnemy
		ldx PageIndex
		jsr Xminus16	; Xminus16
	bne -

; Display of enemies routine
%org($FFFA,15)	; 0x4000A
	dw LoopUntilErased

;-------------------------------------





