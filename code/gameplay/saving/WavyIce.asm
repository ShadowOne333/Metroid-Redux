; SOME CODE HAD TO BE MOVED TO MapHack.asm to be included into RAM

;===========================================
; Allow weapon combining
; ----- ------ ---------
; NOPs out the code that removes one beam
; when the play aquires another.
;===========================================
%org($DBD2,15)	; 0x3DBE2, Bank $0F

	nop #8	; lda $6878
		; and #$3F
		; sta $6878
	
	
;===========================================
; New Behavior
; --- --------
; Calls the appropriate routine to update
; beam projectiles.
;===========================================

; Hijack
; ------
%org($D5C5,15)	; 0x3D5D5, Bank $0F
	jmp WavyIce_NewBehavior

; New code
; --- ----
; (in MapHack.asm)


;===========================================
; New Damage
; --- ------
; Specifies damage amount for wave+ice. Also
; increases damage dealt by bombs and
; vanilla ice. Heh.
;===========================================

; Hijack
; ------
%org($F5EE,15)	; 0x3F5FE, Bank $0F
	jmp WavyIce_NewDamage

; New Code
; --- ----
; (in MapHack.asm)
