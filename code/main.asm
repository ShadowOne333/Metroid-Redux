;-------------------------------------------------------------------
;		Main assembly file for Metroid Redux
;	All the assembly files get linked together and compiled here
;-------------------------------------------------------------------

arch snes.cpu		; Set processor architecture (SNES)
norom			; Change to 'norom' for 6502 (NES) addresses
!headersize = $10	; NES header size
optimize dp always	; Always use optimized label values 
dpbase 0		; Set the dp base to 0 for 8bit labels

;------------------------------------------------------------------
; Metroid + Saving (v0.3) - snarfblam: http:;www.romhacking.net/hacks/1186/
;    Minimap
;    Savefiles
;    Beamstacking
;    Better icebeam and bombs

;MDbtroid - Infinity’s End: http:;www.romhacking.net/hacks/1219/
;    Nicer titlescreen
;    Nicer endings
;    Updated run animation
;    Updated player sprite (suited and suitless)
;    Updated enemy sprites
;    Enlarged and updated Kraid and Ridley
;    Updated Mother Brain
;    Various updated tiles

;‘Roidz - DemickXII: http:;www.romhacking.net/hacks/1240/
;    Nicer background tiles
;    Animated lava, doors and elevators
;    Animated corridors
;    Animated Norfair (Ridley level)
;    Animated Tourian (Mother Brain level)
;    Various updated tiles
;------------------------------------------------------------------
;***UPDATE TO UNOFFICIAL METROID+SAVING VERSION!!!
; https:;www.romhacking.net/hacks/4471/

; Apply METROID MOTHER first, and then the unofficial save patch!
; Afterwards, fix accordingly to this file's changes and/or subsequent ones

;----------------------------------------
;	Macros and iNES Header
;----------------------------------------

; Include our macros and the custom iNES header for Metroid Redux
incsrc "code/macros.asm"
incsrc "code/header.asm"

;----------------------------------------
;   Copy ROM banks into Expanded Area
;----------------------------------------

; Copy Bank 7 into Bank 15
%org($C000,15)	; 0x3C010
incbin "rom/Metroid.nes":$1C010..$20010

;----------------------------------------
;		Main code
;----------------------------------------

incsrc "code/gameplay/mother.asm"
incsrc "code/gameplay/saving.asm"	; Missing Automap
incsrc "code/gameplay/misc.asm"
incsrc "code/gameplay/HideEnemiesInDoors.asm"

;----------------------------------------
;		Messages/Text
;----------------------------------------
incsrc "code/text/Ending.asm"

;----------------------------------------
;		Graphics
;----------------------------------------
incsrc "code/gfx/graphics.asm"


