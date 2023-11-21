;-------------------------------------
;	Missile Doors Consumption
;-------------------------------------
; Missiles required for opening Red and Purple/Orange doors
; Normal Missile Door - Red
; Strong Missile Door - Purple/Orange in Ridley/Tourian, but found in the data for other areas as well, even if they don't have such doors

; Brinstar Normal and Strong Missile Door Consumption
%org($8BD1,1)	; 0x04BE1
	db $01,$01,$05

; Norfair Missile Door Consumption
%org($8BD1,2)	; 0x08BE1
	db $01,$01,$05

; Tourian Missile Door Consumption
%org($8BD1,3)	; 0x0CBE1
	db $01,$01,$05

; Kraid Missile Door Consumption
%org($8BD1,4)	; 0x10BE1
	db $01,$01,$05

; Ridley Missile Door Consumption
%org($8BD1,5)	; 0x14BE1
	db $01,$01,$05

;-------------------------------
