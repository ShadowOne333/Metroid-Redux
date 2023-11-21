;-------------------------------------
;	Item drop table
;-------------------------------------
;The following table determines what, if any, items an enemy will drop when it is killed.
; Replaced one "no item" byte with a missile byte, increasing the drop rate of missiles
%org($DE35,15)	; 0x3DE45
ItemDropTbl:
	db $80		;Missile.
	db $81		;Energy.
	db $89		;No item.
	db $80		;Missile.
	db $81		;Energy.
	db $89		;No item.
	db $81		;Energy.
	db $80		;No item. ($89->$80)

;-------------------------------
