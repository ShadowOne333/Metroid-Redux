;-------------------------------------
;	   Fast Doors
;-------------------------------------
; A few 20F1E1s followed by a bunch of EAs that replace the NARPASSWORD code (this has to do with speeding up door transitions)

%org($C920,15)	; 0x3C930
	jmp Section4	; Fast Doors fix routine

; Fix palette loading from Fast Doors
%org($C92B,15)	; $3C93B
	jsr ScrollDoor
	;jsr Section4	; Originally JSR $E1F1, changed to new code for Fast Doors which fixes wrong palette loading

; Overwrite NARPASSWORD subroutine from the main Game Engine section
%org($C931,15)	; 0x3C941
	jsr ScrollDoor
	jsr ScrollDoor
	nop #14
l_C945:

%org($C9B1,15)	; 0x3C9C1
	jsr $7E18
	nop

;-------------------------------------
;		Section 4
;	(taken from Metroid Saving)
;-------------------------------------
; Fast Doors routine. Modified to fix palette loading
%org($FFD5,15)	; 0x3FFE5, Bank $0F
Section4:	;FFD5 - FFF9
CheckMinHealth:
	lda TankCount	; Exit if health (including full tanks) >= 30, supposed to be $6877 (TankCount) but it's $0107 (HealthHigh?) in the source code for some reason
	jsr Amul16	; cmp #$03
	ora #$09	;
	;bcs +
		;lda #$03
		sta HealthHigh
		lda #$99	;lda #$00, start with 99 life?
		sta HealthLow
        ;+
        rts
	nop
EndSection4:

;-------------------------------------
