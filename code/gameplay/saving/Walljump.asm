;-------------------------------
;	Other banks
;-------------------------------

; Hijack the Samus Run animation pointer
%org($CC24,15)	; 0x3CC34
	dw Walljump	; $7F30, Originally $CCC2 (SamusRun)

%org($9A30,14)	; 0x39A40

base $7F30
Walljump:
	lda Joy1Change
	bpl +
		lda #$01	; DPad Right
		bit Joy1Status	; Is DPad Right held?
		bne ++
			asl
			bit Joy1Status	; Is DPad Left held?
			beq +

		;Check if able to wall jump to the left
			jsr CheckMoveRight	; WallToRight
			bcs +
			bcc +++

		; Check if able to wall jump to the right
		++	jsr CheckMoveLeft
			bcs +

		+++	lda ObjVertSpeed	; Is Samus in a slow decent?
		bne +

		jsr DoJump	; DoJump, Samus Horz Speed Max

+	jmp SamusRun

base off



