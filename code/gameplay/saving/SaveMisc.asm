;-------------------------------------
; Miscellaneous Changes for Saving+
;-------------------------------------

; Random unused table that Deejaynerate EA'd for some reason [possibly to make IPS peek analysis easier] (0.4 had it almost like vanilla but with EAs instead of zeros, though 0.3 *does* EA this too. probably drop this edit, it's stupid)
%org($BF56,1)	; 0x07F66

	%fillto($BFB0,1,$EA)

;-------------------------------------
; Main routine changes
%org($C121,15)	; 0x3C131
	lda $1E		; Load MainRoutine(?), NoChecksum in our variables
	cmp #$03	; Is game engine running?
	bne +		; If not, then check for routine #5 (Pause)
	jmp ShowMap	; If game is running, jump to $7D04
+	cmp #$05	; Is game paused?
	bne +		; If not routine #5 either, don't care about START being pressed
	lda #$03	; Otherwise, switch to routine #3 (game engine)
	nop		; NOP leftover byte from LDA #$05
	skip 11
+

%org($C1F7,15)	; 0x3C207
; Check if TitleRoutine is $17, if not then branch
	cmp #$17	; #$15 -> #$17

;-------------------------------------
; Changes to a modified AccessSavedGame routine from the original game. From $CA35 up to $CADA
; Following changes are dependant on the Metroid Mother hack
%org($CA35,15)	; 0x3CA45
l_CA35:
	inc $6FF0
	lda #$FF
	sta $6FF1

%org($CA45,15)	; 0x3CA55
l_CA45:
	dec $6FF0
	beq +
	dec $6FF0
	jmp $CABD
+	rts

	inc $6FF0
	lda #$00
	sta $6FF1

%org($CAB4,15)	; 0x3CAC4
	asl $6FF0
%org($CABE,15)	; 0x3CACE
	bit $6FF1	
%org($CACB,15)	; 0x3CADB
	bit $6FF1	; Originally $CAEF (SavedDataTable)

;-------------------------------------
