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
%org($86F4,0)	; 0x00704
	%fillto($871E,0,$FF)

; Unused area!
	%fillto($8759,0,$FF)
	db "ERROR TRY AGAIN"

;-------------------------------------

%org($851B,0)	; 0x0350B
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
	db $F8 : skip 7 : db $F8
; Samus Jumpsuit
%org($9D33,0)	; 0x01D43
	db $4D : skip 15 : db $3A : skip 19 : db $3A
; Jumpsuit Samus
%org($9E59,0)	; 0x01E69
	db $F8
; Bikini Samus
%org($9E8D,0)	; 0x01E9D
	db $42,$78,$F8 : skip 8
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
%org($BD61,1)	; 0x04D71
	db $02,$02,$14,$FF


; DONE AUTOMATICALLY WITH ASAR'S EXPANSION METHOD, NOT NEEDED!!!
;%org($99A8,14)	; 0x399B8
	;%fillto($BFFF,14,$00)

%org($BFFE,14)	; 0x3C00E
	dw $C65A	; 5A C6 (?)

;-------------------------------------
;	Copy Bank 7 into Bank 15
;-------------------------------------

GameMode	= $1D	; 0 = Game is playing, 1 = At title/password screen
MMCReg0Cntrl	= $25	; Stores bits to be loaded into MMC1 Register 0
SwitchUpperBits	= $28	; Used to store bits 3 and 4 for MMC1 register 3.  Bits 3 and 4 should always be 0 under normal conditions

PPUScroll	= $2005

MMC1Reg0	= $8000	; Writing to any of these addresses or any
MMC1Reg1	= $A000	; address in between will write configuration
MMC1Reg2	= $C000	; bits to the MMC chip.
MMC1Reg3	= $E000	; 

;-------------------------------------

%org($C000,15)	; 0x3C010

; The following $1A bytes are modified by Saving -> RNG.asm
	skip $1A

Startup:
	lda #$00
	sta MMC1Reg1	; Clear bit 0. MMC1 is serial controlled
	sta MMC1Reg1	; Clear bit 1
	sta MMC1Reg1	; Clear bit 2
	sta MMC1Reg1	; Clear bit 3
	sta MMC1Reg1	; Clear bit 4
	sta MMC1Reg2	; Clear bit 0
	sta MMC1Reg2	; Clear bit 1
	sta MMC1Reg2	; Clear bit 2
	sta MMC1Reg2	; Clear bit 3
	sta MMC1Reg2	; Clear bit 4
	jsr MMCWriteReg3	; ($C4FA)Swap to PRG bank #0 at $8000
	dex		; X = $FF
	txs		; S points to end of stack page

; Clear RAM at $000-$7FF.
	ldy #$07	; High byte of start address.
	sty $01
	ldy #$00	; Low byte of start address.
	sty $00		; $0000 = #$0700
	tya		; A = 0
	-	sta ($00),y	; Clear address
		iny		;
	bne -		; Repeat for entire page.
		dec $01	; Decrement high byte of address.
		bmi +	; If $01 < 0, all pages are cleared.
		ldx $01
		cpx #$01	; Keep looping until ram is cleared.
	bne -

; Clear cartridge RAM at $6000-$7FFF
+	ldy #$7F	; High byte of start address.
	sty $01
	ldy #$00	; Low byte of start address.
	sty $00		; $0000 points to $7F00
	tya		; A = 0
	-	sta ($00),y
		iny	; Clears 256 bytes of memory before decrementing to next-->
	bne -		; 256 bytes.
		dec $01
		ldx $01	;I s address < $6000?-->
		cpx #$60	; If not, do another page.
	bcs -

	lda #%00011110	; Verticle mirroring
			; H/V mirroring (As opposed to one-screen mirroring).
			; Switch low PRGROM area during a page switch.
			; 16KB PRGROM switching enabled.
			; 8KB CHRROM switching enabled.

	sta MMCReg0Cntrl

	lda #$00	; Clear bits 3 and 4 of MMC1 register 3
	sta SwitchUpperBits

	ldy #$00
	sty ScrollX
	sty ScrollY
	sty PPUScroll
	sty PPUScroll
	iny
	sty GameMode
	;jsr ClearNameTables
	;jsr EraseAllSprites
	

%org($C4FA,15)	; 0x3C50A
MMCWriteReg3:


