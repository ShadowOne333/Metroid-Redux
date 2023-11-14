;-------------------------------------------------------------------
;		Ending texts
;-------------------------------------------------------------------

; Include Text TBL file
incsrc "code/text/Text.tbl"

;-------------------------------------

%org($9AEA,0)	; 0x019FA
; Possible pointer for the start of the Ending graphics/Staff?
	ldx.b #l_A052
	ldy.b #l_A052>>8
	
%org($A052,0)	; 0x02062
l_A052:


;-------------------------------------
;	Staff credits
;-------------------------------------

; STAFF credits text
%org($A128,0)	; 0x02138
	db $28,$2E,$05	; PPU address and length
	db "STAFF"

	db $28,$A8,$13	; PPU address and length
	db "SCENARIO WRITTEN BY"

	db $28,$EE,$05	; PPU address and length
	db "KANOH"	; Kanoh -> Makoto Kanoh

	db $29,$68,$10	; PPU address and length
	db "CHARACTER DESIGN"

	db $29,$AC,$08	; PPU address and length
	db "HIROJI KIYOTAKE"	; Kiyotake -> Hiroji Kiyotake

	db $2A,$2B,$0C	; PPU address and length
	db "NEW MATSUOKA"	; New Matsuoka -> Hirofumi Matsuoka

	db $2A,$6C,$09	; PPU address and length
	db "SHIKAMOTO"	; Shikamoto -> Yoshio Sakamoto
	
	db $2A,$EC,$08	; PPU address and length
	db "MUSIC BY"
	
	db $2B,$2B,$0A	; PPU address and length
	db "HIP TANAKA"	; Hop Tanaka -> Hirokazu Tanaka
	
	db $2B,$A8,$0F	; PPU address and length
	db "MAIN PROGRAMMER"
	db $00		; End PPU string write.

warnpc $A1BA

;-------------------------------------
;	Ending message
;-------------------------------------
%org($A1BA,0)	; 0x021CA
	dw EndingTxt1,EndingTxt2,EndingTxt3,EndingTxt4

; Writes end message on name table 0 in row $2060 (4th row from top).
EndingTxt1:
	db $20,$6D,$08	; PPU address and length
	db "SUCCESS!"
; Writes end message on name table 0 in row $20C0 (7th row from top).
	db $20,$C3,$1A	; PPU address and length
	db "MOTHER BRAIN IS NO MORE.  "
	db $00		; End PPU string write.
; Writes end message on name table 0 in row $2100 (9th row from top).
EndingTxt2:
	db $21,$03,$17	; PPU address and length	
	db "ZEBES IS SAFE THANKS TO"
; Writes end message on name table 0 in row $2140 (11th row from top).
	db $21,$42,$06	; PPU address and length
	db "YOU.  "
	db $00		; End PPU string write.
; Writes end message on name table 0 in row $2180 (13th row from top).
EndingTxt3:
	db $21,$83,$18	; PPU address and length
	db "THE GALAXY OWES YOU ITS "
;Writes end message on name table 0 in row $21C0 (15th row from top).
	db $21,$C2,$12	; PPU address and length
	db "ETERNAL GRATITUDE."
	db $00		; End PPU string write.
;Writes end message on name table 0 in row $2200 (18th row from top).
EndingTxt4:
	db $22,$03,$18	; PPU address and length
	db "THE METROID THREAT IS   "
;Writes end message on name table 0 in row $2240 (19th row from top).
	db $22,$42,$06	; PPU address and length
	db "OVER!!"
	db $00		; End PPU string write.

	%fillto($A1BA,0,$FF)

	;db $20,$6D,$08	; PPU address and length
	;db "GREAT !!"
	;db $20,$C3,$1A	; PPU address and length
	;db "YOU FULFILED YOUR MISSION."
	;db $00		;End PPU string write.

	;db $21,$03,$17	; PPU address and length
	;db "IT WILL REVIVE PEACE IN"
	;db $21,$42,$06	; PPU address and length
	;db "SPACE."
	;db $00		; End PPU string write.

	;db $21,$83,$18	; PPU address and length
	;db "BUT, IT MAY BE INVADED BY"	; , = 00
	;db $21,$C2,$12	; PPU address and length
	;db "THE OTHER METROID.
	;db $00		; End PPU string write.

	;db $22,$03,$18	; PPU address and length
	;db "PRAY FOR A TRUE PEACE IN"
	;db $22,$42,$06	; PPU address and length
	;db "SPACE!"
	;db $00		; End PPU string write.

warnpc $A265

;-------------------------------------
;	Staff credits continuation
;-------------------------------------
; The following table is used by the LoadCredits routine to load the end credits on the screen.
%org($A291,0)	; 0x022A1
; Credits pointers
	dw Credits1,Credits2,Credits3,Credits4
	dw Credits5,Credits6,Credits7,Credits8
	dw Credits9,Credits10,Credits11,Credits12
	dw Credits13,Credits14,Credits15,Credits16
	dw Credits17,Credits18,Credits19,Credits20
	dw Credits21,Credits22,Credits23,Credits24
	dw Credits25,Credits26,Credits27,Credits28
	dw Credits29,Credits30,Credits31,Credits32
	dw Credits33,Credits34,Credits35,Credits36
	dw Credits37,Credits38,Credits39,Credits40
	dw Credits41,Credits42,Credits43,Credits44

; Start of credits' text
Credits1:
	db $20,$27,$0F	; PPU address and length
	db "HIROYUKI YUKAMI"	; Hai Yukami -> Hiroyuki Yukami

;Clears attribute table 0 starting at $23C0.
	db $23,$C0,$60	; PPU address and length
	db $00		; Repeat bit set. Repeats entry 32 times.
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2060 (4th row from top)
Credits2:
	db $20,$6A,$0D	; PPU address and length
	db "YASE SOBAJIMA"	; Zaru Sobajima -> Yase Sobajima

;Writes credits on name table 0 in row $20A0 (6th row from top).
	db $20,$A8,$0E	; PPU address and length
	db "TOSHIO SENGOKU"	; Gpz Sengoku -> Toshio Sengoku
	db $00		; End PPU string write.
Credits3:
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2160 (12th row from top).
Credits4:
	db $21,$68,$0E	; PPU address and length
	db "MITSUNARI TANI"	; N.Shiotani -> Mitsunari Tani

;Clears attribute table 0 starting at $23E0
	db $23,$E0,$60	; PPU address and length
	db $00		; Repeat bit set. Repeats entry 32 times.
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $21E0 (16th row from top).
Credits5:
	db $21,$EB,$0A	; PPU address and length
	db "KENJI IMAI"	; M.Houdai -> Kenji Imai
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $22A0 (22nd row from top).
Credits6:
	db $22,$A8,$11	; PPU address and length
	db "SPECIAL THANKS TO"
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $22E0 (24nd row from top).
Credits7:
	db $22,$EA,$0A	; PPU address and length
	db "KENJI ZURI"	; Ken Zuri -> Kenji Nishizawa

;Writes credits on name table 0 in row $2320 (26nd row from top).
	db $23,$2E,$04	; PPU address and length
	db "SUMI"	; Sumi Arisaka
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2360 (28nd row from top).
Credits8:
	db $23,$6C,$07	; PPU address and length
	db "INUSAWA"	; Toru Osawa

;Writes credits on name table 0 in row $23A0 (bottom row).
	db $23,$AD,$05	; PPU address and length
	db "KACHO"
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2820 (2nd row from top).
Credits9:
	db $28,$28,$4E	; PPU address and length
	db " "		;Repeat bit set. Repeats entry 14 times.

;Writes credits on name table 2 in row $2860 (4th row from top).
	db $28,$6C,$07	; PPU address and length
	db "HYAKKAN"	; 
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $28A0 (6th row from top).
Credits10:
	db $28,$AD,$06	; PPU address and length
	db "GOYAKE"	; (5)Goyake(8)

;Writes credits on name table 2 in row $28E0 (8th row from top).
	db $28,$E8,$4F	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2920 (10th row from top).
Credits11:
	db $29,$24,$0F	; PPU address and length
	db "TAKAHIRO HARADA"	; Harada(1) -> Takahiro Harada
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2960 (12th row from top).
Credits12:
	db $29,$6E,$06	; PPU address and length
	db "PENPEN"	; (7)Penpen(9)

;Writes credits on name table 2 in row $29A0 (14th row from top).
	db $29,$A8,$4F	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $29E0 (16th row from top).
Credits13:
	db $29,$EA,$0C	; PPU address and length
	db "CONVERTED BY"
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2A20 (18th row from top).
Credits14:
	db $2A,$28,$0D	; PPU address and length
	db "TORU NARIHIRO"	; (5)T.Narihiro(2) -> Toru Narihiro

;Writes credits on name table 2 in row $2A60 (20th row from top).
	db $2A,$67,$51	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2AE0 (24th row from top).
Credits15:
	db $2A,$EB,$0B	; PPU address and length
	db "ASSISTED BY"

;Writes credits on name table 2 in row $2B20 (26th row from top).
	db $2B,$2B,$0C	; PPU address and length
	db "MAKOTO KANOH"	; (3)Makoto Kanoh -> Makoto Kanoh
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2BA0 (bottom row).
Credits16:
	db $2B,$A6,$53	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2020 (2nd row from the top).
Credits17:
	db $20,$2B,$0B	; PPU address and length
	db "DIRECTED BY"
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2060 (4th row from the top).
Credits18:
	db $20,$68,$0F	; PPU address and length
	db "YOSHIO SAKAMOTO"	; (5)Yamamoto(7) -> Yoshio Sakamoto

;Writes credits on name table 0 in row $20A0 (6th row from the top).
	db $20,$AA,$4E	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2120 (10th row from the top).
Credits19:
	db $21,$29,$0E	; PPU address and length
	db "CHIEF DIRECTOR"	; (2)Chief director(1)

;Writes credits on name table 0 in row $2160 (12th row from the top).
	db $21,$6A,$0C	; PPU address and length
	db "SATORU OKADA"	; (2)Satoru Okada(2)
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $21E0 (16th row from the top).
Credits20:
	db $21,$E6,$58	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2220 (18th row from the top).
Credits21:
	db $22,$2B,$0B	; PPU address and length
	db "PRODUCED BY"	; Produced by(5)

;Writes credits on name table 0 in row $2260 (20th row from the top).
	db $22,$6A,$0C	; PPU address and length
	db "GUNPEI YOKOI"
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $22A0 (22nd row from the top).
Credits22:
	db $22,$A6,$53	; PPU address and length
	db " "

;Writes credits on name table 0 in row $22E0 (24th row from the top).
	db $22,$E8,$4F	; PPU address and length
	db " "
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2320 (26th row from the top).
Credits23:
	db $23,$29,$4D	; PPU address and length
	db " "

;Writes credits on name table 0 in row $2340 (27th row from the top).
	db $23,$4B,$09	; PPU address and length
	db "COPYRIGHT"
	db $00		; End PPU string write.

;Writes credits on name table 0 in row $2360 (28th row from the top).
Credits24:
	db $23,$6B,$4A	; PPU address and length
	db " "

;Writes credits on name table 0 in row $2380 (29th row from the top).
	db $23,$8E,$05	; PPU address and length
	db $BF,"1986"

;Writes credits on name table 0 in row $23A0 (bottom row).
	db $23,$A8,$4F	; PPU address and length
	db " "		; Repeat bit set. Repeats entry 10 times.
	db $00		; End PPU string write.

;Writes credits on name table 2 in row $2800 (top row)
Credits25:
	db $28,$0C,$08	; PPU address and length
	db "NINTENDO"

;Writes credits on name table 2 in row $2860 (4th row from top).
	db $28,$66,$51	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 17 times.
	db $00		; End PPU string write.

; Writes credits on name table 2 in row $28A0 (6th row from top).
Credits26:	; $A4CD
	db $28,$AA,$4C	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 12 times.
	db $00		; End PPU string write.

; Writes credits on name table 2 in row $2920 (10th row from top).
Credits27:	; $A4D2
	db $29,$26,$5B	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 27 times.
	db $00		; End PPU string write

; Writes credits on name table 2 in row $2960 (12th row from top).
Credits28:	; $A4D7
	db $29,$67,$52	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 18 times.
	db $00		; End PPU string write

; Writes credits on name table 2 in row $29E0 (16th row from top).
Credits29:	; $A4DC
	db $29,$E6,$54	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 20 times.
	db $00		; End PPU string write

; Writes credits on name table 2 in row $2A20 (18th row from top).
Credits30:	; $A4E1
	db $2A,$28,$55	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 21 times.
	db $00		; End PPU string write

; Writes credits on name table 2 in row $2AE0 (24th row from top).
Credits31:	; $A4E6
	db $2A,$E6,$50	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 16 times.
	db $00		; End PPU string write

; Writes credits on name table 2 in row $2B20 (26th row from top).
Credits32:	; $A4EB
	db $2B,$29,$4E	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 14 times.
Credits33:	; $A4EF
	db $00		; End PPU string write

; Writes the top half of 'The End' on name table 0 in row $2020 (2nd row from top).
Credits34:	; $A4F0
	db $20,$26,$14	; PPU address and length
	db "     "
	db $24,$25,$26,$27
	db "  "
	db $2C,$2D,$2E,$2F
	db "     "
	db $00		; End PPU string write

;Writes the bottom half of 'The End' on name table 0 in row $2040 (3rd row from top).
Credits35:	; $A508
	db $20,$4B,$0A	; PPU address and length
	db $28,$29,$2A,$2B
	db "  "
	db $02,$03,$04,$05

;Writes credits on name table 0 in row $2060 (4th row from top).
	db $20,$6A,$4C	; PPU address and length
	db " "		; Repeat bit set. Repeats entry 12 times
	db $00		; End PPU string write

; Writes credits on name table 0 in row $2120 (10th row from top).
Credits36:	; $A51A
	db $21,$26,$53	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 19 times.
	db $00		; End PPU string write

; Writes credits on name table 0 in row $2160 (12th row from top).
Credits37:	; $A51F
Credits39:
	db $21,$6A,$4C	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 12 times.
	db $00		; End PPU string write

Credits38:	; $A524
Credits40:
	db $21,$88,$11	; PPU address and length
	db "                 "

; Writes credits on name table 0 in row $2220 (18th row from top).
Credits41:	; $A538
Credits43:
	db $22,$26,$4B	; PPU address and length 
	db " "		; Repeat bit set. Repeats entry 11 times.
	db $00		; End PPU string write

Credits42:	; $A53D
Credits44:
	db $00		; End PPU block write

	%fillto($A53E,0,$FF)

warnpc $A53E

