;-------------------------------------
;	Morph Ball changes
;-------------------------------------

; Modify the Break out of "Ball mode" routine
; How high a ceiling above morphball can exist to trigger unmorphing (Morphball ceiling fix)
%org($D0F5,15)	; 0x3D105
	adc #$00	; #$08 -> #$00
; CHANGE MORPH BALL SO IT DOESN'T MAKE THE ROLL ANIM AUTOMATICALLY, AND ONLY ROLLS WHEN MOVING LEFT/RIGHT
