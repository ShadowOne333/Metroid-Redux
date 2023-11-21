;-------------------------------------
;	Japanese RNG code
;-------------------------------------
; This routine generates pseudo random numbers and updates those numbers every frame.
; The random numbers are used for several purposes including password scrambling and determinig what items, if any, an enemy leaves behind after it is killed.
%org($C000,15)	; 0x3C000
RandomNumbers:
	txa
	pha
; Modified code
	lda $2F
	beq +
	asl
	beq ++
	bcc ++
+	eor #$1D
++	sta RandomNumber2
	eor #$F0
	sta RandomNumber1
	pla
	txa
	lda RandomNumber1
	rts

; Clear cartridge RAM at $6000-$7FFF
%org($C057,15)	; 0x3C067
; Clear RAM up to $7400 only?
	ldy #$74	; High byte of start address (#$7F -> #$74)

; Random number 2 initialization
%org($C0AC,15)	; 0x3C0BC
	lda #$11
	sta RandomNumber1	; Initialize RandomNumber1 to #$11
	lda #$1D		; #$FF -> #$1D
	sta RandomNumber2	; Initialize RandomNumber2 to #$1D

;-------------------------------------
