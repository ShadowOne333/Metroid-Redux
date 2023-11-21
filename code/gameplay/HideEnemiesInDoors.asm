;------------------------------------------------
; Hide Enemies when transitioning between doors
;------------------------------------------------

; Behavioral patch - enemies now freeze while moving through doors
; No more being hit by enemies while moving through 'em!
; This hooks into the start of UpdateEnemies in Dirty McDingus's code.
%org($F345,15)	; 0x3F355
	lda $56		; Nonzero when traveling through door
	beq +
		rts	; In door; don't update enemies
+	jsr FreezeEnemiesRestoration
	nop #4


; This section starts at AccessSavedGame and ends at the end
; of SavedDataTable
%org($CB1C,15)	; 0x3CB2C
; Restores the behavior overwritten by "freeze enemies patch"
; Moved from 0x3CA45 ($CA35) for compatibility with Saving 0.5.2, overwriting the unused "Clear screen data" routine
FreezeEnemiesRestoration:
	ldx #$50
	-	jsr $F351	; DoOneEnemy
		ldx $4B		; PageIndex
		jsr $F1F4	; Xminus16
	bne -
	rts

warnpc $CB29	; 0x3CB39
