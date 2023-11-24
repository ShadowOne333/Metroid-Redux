;-------------------------------------
;    Moved data from other banks
;-------------------------------------

; Pointers to Kraid's room definitions at 0x2CXXX
%org($9E1B,4)	; 0x11E2B
; Enemy frame pointer table 2
	dw $8976,$89B2,$89E4,$8A08,$8A42
; Enemy placement pointer table
	dw $8A74,$8AAF,$8AE1,$8B25,$8B6E
	dw $8BD2,$8BF6,$8C52,$8C7E,$8CA1
	dw $8CBF,$8CED,$8D2D,$8D62

;-------------------------------------

%org($A1A2,4)	; 0x121B2
l_A1A2:
; Copy Kraid's original room definitions into this area
	incbin "rom/Metroid.nes":$12657..$12A7B
; Some leftover bytes?
	db $00,$1D

;-------------------------------------
;	Ridley's room definitions
;-------------------------------------

; Pointers to Ridley's room definitions at 0x30XXX
%org($9CF0,5)	; 0x15D00
; Frame pointer table 2:	$9CF0
	dw $859E,$859E,$85A6,$85D2
	dw $85FD,$8611,$8643,$866E
	dw $86AC,$86E2
; Enemy placement pointer table:	$9CD04
	dw $8717,$8758,$8788,$87B4
	dw $87EB,$8822,$8855,$8884
	dw $88B4,$8900,$8944,$8977
	dw $89B2,$89DB,$8A08
; Enemy sprite placement data tables	$9D22
	dw $8A35,$8A5E,$8A8B,$8ACA
	dw $8AFC,$8B2E,$8B5B,$8B85
	dw $8BA8,$8BC6,$8BEC,$8C1E
	dw $8C4B,$8C89,$8CBC,$8CDA
	dw $8D04
l_9D44:
	db $FFFF
l_9D46:
; Copy Ridley's original room definitions into this area
	incbin "rom/Metroid.nes":$16251..$169CF
; Some leftover bytes?
	db $00,$00
l_A4C6:
	%fillto($A4CD,5,$00)
l_A4CD:
	%fillto($A4EB,5,$00)
l_A4EB:
	%fillto($A519,5,$00)
l_A519:
	%fillto($A559,5,$00)
l_A559:
	%fillto($A58E,5,$00)
l_A58E:
	%fillto($AC20,5,$00)

;-------------------------------------

; Pointers to Kraid's room definitions at 0x12XXX
%org($8124,11)	; 0x2C134
	dw $A1A2,$A1DE,$A210,$A234
	dw $A26E,$A2A0,$A2DB,$A30D
	dw $A351,$A39A,$A3FE,$A422
	dw $A47E,$A4AA,$A4CD,$A4EB
	dw $A519,$A559,$A58E

;-------------------------------------

%org($8976,11)	; 0x2C986
; Copy Kraid's original room definitions into this area
	incbin "rom/Metroid.nes":$12657..$12A7B

;-------------------------------------

%org($8102,12)	; 0x30112
; Pointers to Ridley's room definitions at 0x15XXX
	dw $9D44,$9D4C,$9D78,$9DA3
	dw $9DB7,$9DE9,$9E14,$9E52
	dw $9E88,$9EBD,$9EFE,$9F2E
	dw $9F5A,$9F91,$9FC8,$9FFB
	dw $A02A,$A05A,$A0A6,$A0EA
	dw $A11D,$A158,$A181,$A1AE
	dw $A1DB,$A204,$A231,$A270
	dw $A2A2,$A2D4,$A301,$A32B
	dw $A34E,$A36C,$A392,$A3C4
	dw $A3F1,$A42F,$A462,$A480
	dw $A4AA

l_8154:
; Copy Ridley's original room definitions into this area
; First part
	incbin "rom/Metroid.nes":$1624F..$164FB

; More pointers?
l_8400:
	dw $843A,$844D,$8454,$845B
	dw $8474,$8478,$847D,$8482
	dw $8492,$84A7,$84AD,$84B8
	dw $84D2,$84DF,$84E8,$84F3
	dw $84FE,$8501,$8507,$8511
	dw $8526,$8542,$854D,$8554
	dw $8569,$8585,$858C,$8595
	dw $8598

l_843B:
; Structure definitions for Ridley's
; Copy Ridley's original structure definitions into this area
	incbin "rom/Metroid.nes":$169CF..$16B34

; Overwrite certain bytes from the above Structure Definitions
; These are changed due to the Mother hack having custom tiles in Ridley's area (doors)
%org($843C,12)	; 0x3044C
l_843C:
	dw $8500,$85C3,$85C7,$85CB	; 00s in Saving 0.5.2
	dw $85DE,$85EB,$85F8,$85FC	; 00s in Saving 0.5.2
l_844C:
	db $FF
	db $01,$12,$01,$12,$01,$12,$FF
	db $01,$13,$01,$13,$01,$13,$FF
	db $02,$02,$03,$02,$02,$03

%org($8461,12)	; 0x30471
	db $01,$41,$01,$42,$FF		; 00s in Saving 0.5.2
l_8466:
	db $01,$45,$01,$46,$01,$47,$FF	; 00s in Saving 0.5.2
	db $02,$02,$03,$02,$02,$03	; 00s in Saving 0.5.2

%org($84D8,12)	; 0x304E8
	db $15,$04,$15,$15,$15,$15	; 00s in Saving 0.5.2
	db $FF	; $84DE

%org($859E,12)	; 0x305AE (16B30 in the original ROM)
l_859E:
; Copy Ridley's original room definitions into this area (again)
	incbin "rom/Metroid.nes":$1624F..$169CF	; $164FB

;-------------------------------------

%org($8440,14)	; 0x38450
	db $00,$00,$00,$00,$00,$00,$00,$00,$00

; Probably fill up to $30DA0 with 00s since it's most likely now unused space in Saving

;-------------------------------------

