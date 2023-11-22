;-------------------------------------
; Miscellaneous Changes for Saving+
;-------------------------------------

; Random unused table that Deejaynerate EA'd for some reason [possibly to make IPS peek analysis easier] (0.4 had it almost like vanilla but with EAs instead of zeros, though 0.3 *does* EA this too. probably drop this edit, it's stupid)
%org($BF56,1)	; 0x07F66

	%fillto($BFB0,1,$EA)

;-------------------------------------

; Check if TitleRoutine is $17, if not then branch
%org($C1F7,15)	; 0x3C207
	cmp #$17	; #$15 -> #$17

;-------------------------------------
