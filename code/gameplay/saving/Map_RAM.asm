; The map hack places the needed code and data into RAM at $7900 ($600 bytes (max))
;-------------------------------------
struct MapRAM $7D00

	.MinimapX:	skip 1
	.MinimapY:	skip 1
	.BlipX:		skip 1
	.BlipY:		skip 1	; $7D03

endstruct
;-------------------------------------
ShowMap:
; Uses $00, $01, $02
	
; Clear sprite RAM	
	ldy #$00
	lda #$00
	-	sta $0200,y
		iny
	bne -

	jsr GetMapCords
	jsr DrawMap

returnFromHijack:
	lda #$05	; Game mode - Unpaused
	jmp $C131	; (MainRoutine = 5 if game paused, 3 if game engine running)
	
DrawMap:
	; Draw samus blip
	ldy #$00

	lda MapRAM.BlipX	; Calculate blip X
	bmi skipBlip	; Hide blip if off map display
	cmp #!MapWidth
	bcs skipBlip	
	asl
	asl
	asl
	clc
	adc #!MapLeft+8	; Why is this off by one square?
	sta !OAM_X,y
	
	lda MapRAM.BlipY		; Calculate blip Y
	bmi skipBlip		; Hide blip if off map display
	cmp #!MapHeight
	bcs skipBlip 
	asl
	asl
	asl
	clc
	adc #!MapTop
	sta !OAM_Y,y

	lda #$00
	sta !OAM_Att,y
	lda #!SamusBlipTile
	sta !OAM_Tile,y

	jmp DrawMapTiles

skipBlip:	; Hide blip sprite
	lda #$F4
	sta !OAM_Y,y

DrawMapTiles:
	lda #$00
	sta $00
	ldy #$04	; OAM ptr
	; loop rows
	rowLoop:
	; Get screen Y coordinate for row
		asl	; Grid Y * 8
		asl
		asl
		clc
		adc #!MapTop	; + top of grid
		sta $01

		; Get screen X coordinate
		lda #(!MapLeft+!MapWidth*8)
		sta $02

		ldx #!MapWidth-1	; 7 screens per row
		cellLoop:
			lda $02
			sta !OAM_X,y
			lda $01
			sta !OAM_Y,y
			lda #$01
			sta !OAM_Att,y

			lda $00
			jsr GetMapTile
			sta !OAM_Tile,y

			; Next tile 8 px to the right
			lda $02
			sec
			sbc #$08
			sta $02

			iny
			iny
			iny
			iny
			dex
		bpl cellLoop

		inc $00
		lda $00
		cmp #!MapHeight	  ; 7 rows

	bne rowLoop
	
	rts

GetMapTile:
	; Gets tile number to use for the given map position
	; X MUST BE PRESERVED
	; x [in]	Cell X position
	; a [in]	Cell Y position
	; a [out]   Tile number
	;
	; Uses $03, $04, $05, $06

	stx $03		; Preserve registers
	sty $06
	ldx #$00	; Clear a variable
	stx $04

	clc
	adc MapRAM.MinimapY	; Get absolute Y
	sec
	sbc #$03
	bcc YOutOfRange	; If < 0, out of range. Use blank tile
	cmp #$20
	bcs YOutOfRange	; If >= #$20, out of range. Use blank tile.

	; Set 16-bit value at $04 to (y * #$20)
	lsr
	ror $04
	lsr
	ror $04
	lsr
	ror $04

	; Add address of map data in RAM
	clc
	adc.b #!MapRAM>>8
	sta $05

	lda $03
	clc		; Get absolute X
	adc MapRAM.MinimapX
	sec
	sbc #$03
	bcc XOutOfRange	; If < 0, its out of range, use a blank tile
	cmp #$20
	bcs XOutOfRange	; If >= #$20, it is out of range, use a blank tile
	
	tay
	lda ($04),y	; Get map tile number
	
	ldx $03		; Restore registers
	ldy $06
	rts

XOutOfRange:
YOutOfRange:
	ldx $03
	ldy $06
	lda #$FF
	rts
	
GetMapCords:
	lda !MapPosX
	sta MapRAM.MinimapX
	lda !MapPosY
	sta MapRAM.MinimapY

	lda !ScrollDir
	and #$02
	bne horiz
	
vert:	
	lda !ScrollY
	beq return
	
	lda !ScrollDir
	cmp #$01
	bne +   
		dec MapRAM.MinimapY
	+
	lda !ScrollY
	bpl +
		inc MapRAM.MinimapY
	+
	jmp return
	
horiz:
	lda !ScrollX
	beq return

	lda !ScrollDir
	cmp #$03
	bne +
		dec MapRAM.MinimapX
	+
	lda !ScrollX
	bpl +
		inc MapRAM.MinimapX
	+
	
return:
; Place blip
	lda #$03
	sta MapRAM.BlipX
	sta MapRAM.BlipY
	
	rts

MapInputHandler:
	lda !Joy1Change
	and #(!Joy_Up | !Joy_Down | !Joy_Left | !Joy_Right)
	beq return1
	
	cmp #!Joy_Up
	bne +
		ldx MapRAM.MinimapY	; Don't move up past edge of map
		beq +
		dec MapRAM.MinimapY
		inc MapRAM.BlipY
	+
	cmp #!Joy_Down
	bne +
		ldx MapRAM.MinimapY	; Don't move right past edge of map
		cpx #$1F
		beq +
		inc MapRAM.MinimapY
		dec MapRAM.BlipY
	+
	cmp #!Joy_Left
	bne +
		ldx MapRAM.MinimapX	; Don't move up past edge of map
		beq +
		dec MapRAM.MinimapX
		inc MapRAM.BlipX
	+
	cmp #!Joy_Right
	bne +
		ldx MapRAM.MinimapX	; Don't move right past edge of map
		cpx #$1F
		beq +
		inc MapRAM.MinimapX
		dec MapRAM.BlipX
	+
	
	jsr DrawMap
	
return1:
; Displaced
; Manual save button combo, change so it's in Controller 1
	lda !Joy1Status		; Load buttons currently being pressed on joypad 1
	and #$88		;
	rts

warnpc $9A56
	
