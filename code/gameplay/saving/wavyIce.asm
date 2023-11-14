; SOME CODE HAD TO BE MOVED TO MapHack.asm to be included into RAM

;===========================================
; Allow weapon combining
; ----- ------ ---------
; NOPs out the code that removes one beam
; when the play aquires another.
;===========================================
%org($DBD2,$15)	; 0x00010, Bank $0F
;.PATCH 0F:DBD2

	nop #3 ; LDA $6878

	nop #2 ; AND #$3F

	nop #3 ; STA $6878
	
	
;===========================================
; New Behavior
; --- --------
; Calls the appropriate routine to update
; beam projectiles.
;===========================================

; Hijack
; ------
%org($D5C5,$15)	; 0x3D5D5, Bank $0F
;.PATCH 0F:D5C5
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
%org($F5EE,$15)	; 0x3F5F5, Bank $0F
;.PATCH 0F:F5EE
	JMP WavyIce_NewDamage

; New Code
; --- ----
; (in MapHack.asm)
