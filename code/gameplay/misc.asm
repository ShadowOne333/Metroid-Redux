;**************************************************************
;	Miscellaneous changes and fixes
;**************************************************************

; Kraid Statue layout
%org($8AA1,1)	; $04AB1
	db $1E,$00,$08
	db $F5,$F6,$F7	; F5 F6 F7 -> FE FE FE
	db $FA,$FB,$FC
	db $08,$04	; Position bytes (Y, X) -> $08,$04
	db $C5,$C6,$C7
	db $D5,$D6,$D7
	db $E5,$E6,$E7
	db $FF	; End
; Ridley Statue layout & Fix flickering when entering room
%org($8AB6,1)	; $04AC6
	db $1E,$00,$08
	db $F8,$F9,$FE	; F8 F9 FE -> FE E8 E9
	db $FA,$FB,$FC
	db $00,$04	; Position bytes (Y, X) -> $08,$0C
	db $C8,$C9,$FE
	db $D8,$D9,$EA
	db $E8,$E9,$EB
	db $FF	; End
%org($8ACD,1)	; $04ADD
	;db $00,$F8,$00,$00,$08,$F8,$08,$00
	;db $E8,$F0,$E8,$F8,$E8,$00,$F0,$F0
	;db $F0,$F8,$F0,$00,$F8,$F0,$F8,$F8
	;db $F8,$00
warnpc $8AE9

%org($9012,1)	; $05022
	db $0F,$20,$10,$00	; Change palette from Blue to Gray to statue area

; Starting room layout
%org($A441,1)	; $06451
	


%org($B135,1)	; $07145
; Unused tile patterns, up to $B200
	lda.b $4D
	cmp.b #$01
	beq left_table
	bne right_table

left_table:
	;Samus run and fire. Original $882C
	db $40,$0F,$04,$00,$01,$FD,$40
	db $46,$47,$48,$FD,$60,$20,$21
	db $FE,$FE,$31,$FF
	;Samus run and fire. Original $883E
	db $40,$0F,$04,$00,$01,$FD,$40
	db $46,$47,$48,$FD,$60,$22,$23
	db $FE,$32,$33,$34,$FF
	;Samus run and fire. Original $8851
	db $40,$0F,$04,$00,$01,$FD,$40
	db $46,$47,$48,$FD,$60,$25,$26
	db $27,$35,$36,$FF
	;Samus stand and jump. Original $8863
	db $40,$0F,$04,$00,$01,$FD,$40
	db $46,$47,$48,$FD,$60,$22,$07
	db $08,$32,$FF
	;Samus jump and fire. Original $8874
	db $40,$0F,$04,$00,$01,$FD,$40
	db $46,$47,$48,$FD,$60,$22,$07
	db $08,$32,$FF

right_table:
; Force the unused arm cannon shot sprite on Samus when jumping
	;Samus run and fire. Original $882C
	db $40,$0F,$04,$00,$01,$FD,$20
	db $4B,$4A,$49,$FD,$60,$20,$21
	db $FE,$FE,$31,$FF
	;Samus run and fire. Original $883E
	db $40,$0F,$04,$00,$01,$FD,$20
	db $4B,$4A,$49,$FD,$60,$22,$23
	db $FE,$32,$33,$34,$FF
	;Samus run and fire. Original $8851
	db $40,$0F,$04,$00,$01,$FD,$20
	db $4B,$4A,$49,$FD,$60,$25,$26
	db $27,$35,$36,$FF
	;Samus stand and jump. Original $8863
	db $40,$0F,$04,$00,$01,$FD,$20
	db $FE,$41,$40,$FD,$60,$22,$07
	db $08,$32,$FF
	;Samus jump and fire. Original $8874
	db $40,$0F,$04,$00,$01,$FD,$20
	db $4B,$4A,$49,$FD,$60,$22,$07
	db $08,$32,$FF
warnpc $B1F0


;------------------------------------------------------------------

; Change attribute table for starting area. Changes tiles so certain tiles are gray, and the others remain blue instead of sharing the gray palette
; Morph Ball pedestal
;%org($8AEE,8)	; $20AFE
	;db $54
; Starting platform
%org($88B3,8)	; $208C3
	db $54

;------------------------------------------------------------------

; Corner map position
%org($99D1,14)	; $399E1
	lda.b #$17	; Move corner map Y position
%org($99D9,14)	; $399E9
	lda.b #$D0	; Move corner map X position


;------------------------------------------------------------------

; Fix palette loading from Fast Doors
%org($C92B,15)	; $3C93B
	jsr $FFD5	; Originally JSR $E1F1, changed to new code for Fast Doors which fixes wrong palette loading

%org($CB18,15)	; $3CB28
	db $7A	; 4th ending with 37+ hours
	db $14	; 3rd ending with 6 hours
	db $0A	; 2nd ending with 3 hours
	db $05	; Make the best ending appear with ~1.5 hours (90 mins) instead of 1.2 (72 mins)

%org($CE71,15)	; $3CE81
	cmp.b #$00	; Changes low health beep to mute (originally #$08)
%org($D0F5,15)	; $3D105
	adc.b #$00	; Changes out of Morph ball sound? (originally #$08)
; D4FB -> 7E66

%org($DC03,15)	; $3DC13
	cmp #$07	; Change max tanks from $06 to $08 to accommodate for the extra 2 tanks you can get in the game
; NOTE: THIS NEEDS A FIX SO THAT OBTAINING ALL 8 ENERGY TANKS DOESN'T SCREW UP THE BOTTOM FILE SELECT OPTION 

%org($E1B9,15)	; $3E1C9
; PPU transfer for Health digits
;	db $21, $A0, $01, $38	; Tenths health digit moved to the right from $30 to $38
;	db $21, $A0, $01, $40	; Units health digit moved to the right from $38 to $40

; Make doors have unique tiles
%org($E807,15)	; $3E817
	; C9 A0 F0 06 C9 A1 D0 04
	cmp.b #$A0
	bcc $06
	cmp.b #$A7
	bcs $04

; C9 (A0 + normal doorway tiles) 90 06 C9 (A0 + normal doorway tiles + horizontal doorway tiles) B0 04

%org($E1D5,15)	; $3E1E5
; PPU transfer for "EN...", now "ENERGY"
	db $21, $76, $01, $18	; E
	db $21, $7F, $01, $20	; N
	db $21, $3F, $01, $28	; ... - Changed $00 to $01 to make "ENERGY" all blue

%org($F5F1,15)	; $3F601
	nop	; Residual $15 from a BEQ $15
%org($FFE6,15)	; $3FFF6
	db $FF	; Residual RTS (why?)
