; Minimap RAM
MinimapPos:	; 0x399B8 ($7EA8)
	jsr GetMapCords
	dec MinimapRAM.MinimapY
	dec MinimapRAM.MinimapX
	lda MinimapRAM.MinimapY
	pha
	jsr Adiv8
	clc
	adc #$79
	sta $01
	pla
	jsr Amul32
	clc
	adc MinimapRAM.MinimapX
	sta $00
	lda $01
	adc #$00
	sta $01
	lda #$03
	sta $02
	lda #$1F	; Corner Map Y position
	sta $03
	ldx SpritePagePos

l_7ED7:
	ldy #$00
	lda #$D8	; Corner Map X position
	sta $04
	-	lda ($00),y
		bne +
			lda #$6E
		+	sta OAM_Tile,x
		lda $03
		sta OAM_Y,x
		lda #$01
		sta OAM_Att,x
		lda $04
		sta OAM_X,x
		clc
		adc #$08
		sta $04
		inx
		inx
		inx
		inx
		iny
		cpy #$03
	bne -
	lda $03
	clc
	adc #$08
	sta $03
	dec $02
	beq +
		lda $00
		clc
		adc #$20
		sta $00
		lda $01
		adc #$00
		sta $01
		jmp l_7ED7
+	lda FrameCount
	and #$08
	bne +
		ldy $5B
		lda #$00
		sta $0212,y
+	stx $5B
	jmp DisplayBar




