;-------------------------------------
;	HUD Layout Positions
;-------------------------------------

; How many bytes from the DataDisplayTbl [3E1C9-3E1F0] to use (Each 4 bytes removed is one sprite removed from the HUD display, starting from the bottom of the table.
; If this byte is not a multiple of 4, the game WILL crash. v0.4 did this to reduce sprite count to account for the minimap but ultimately the sprite flickering is rare enough to keep it vanilla.
; If you really want to reduce sprite count through this, I'd recommend bringing it down to $14, keeping just the counter digits and one missile sprite/tile to distinguish the missile count from the energy count. It's ultimately whatever, though.)
%org($E0CF,15)	; 0x3E0DF
; 10*4. At end of DataDisplayTbl?
; If not, loop to load next byte from table
	cpy #$28	; cpy #$28, Recommended #$14


%org($E153,15)	; 0x3E163
	lda #$18	; X position of first HUD E-Tank sprite
%org($E17B,15)	; 0x3E18B
	lda #$17	; Y position of HUD E-Tank sprites


%org($E18F,15)	; 0x3E19F
; In what direction should succeeding E-Tanks should go relative to the first one (goes in tandem with 3E1A0)
	db $69
; X distance betweeen HUD E-Tank sprites relative to each other
	db $07

;-------------------------------------
;	Status bar sprite data
;-------------------------------------
%org($E1B9,15)	; 0x3E1C9
; PPU transfers for HUD
DataDisplayTbl:
	db $21,$A0,$01,$38	; Upper health digit ($30->$38)
	db $21,$A0,$01,$40	; Lower health digit ($38->$30)
	db $2B,$FF,$01,$28	; Upper missile digit.
	db $2B,$FF,$01,$30	; Middle missile digit.
	db $2B,$FF,$01,$38	; Lower missile digit.
	db $2B,$5E,$00,$18	; Left half of missile.
	db $2B,$5F,$00,$20	; Right half of missile.
	db $21,$76,$01,$18	; E
	db $21,$7F,$01,$20	; N
	db $21,$3A,$01,$28	; ... - Changed $00 to $01 to make "ENERGY" all blue

; How many missiles you get from missile drops
; NOTE: missile pickups work differently in Tourian/with Metroids, basically you get more missiles the more missile packs you have
%org($F4B7,14)	; 0x3F4C7
	lda #$05	; lda #$02

;-------------------------------
