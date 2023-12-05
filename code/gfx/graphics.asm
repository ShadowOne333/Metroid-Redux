;-------------------------------------------------------------------
;	Graphical changes from Metroid Mother
;-------------------------------------------------------------------

; Include graphics files
%org($8000,16)	; 0x40000
	incbin "code/gfx/gfx01.bin"
	
%org($8000,17)	; 0x44000
	incbin "code/gfx/gfx02.bin"

%org($8000,18)	; 0x48000
	incbin "code/gfx/gfx03.bin"

%org($8000,19)	; 0x4C000
	incbin "code/gfx/gfx04.bin"

%org($8000,20)	; 0x50000
	incbin "code/gfx/gfx05.bin"

%org($8000,21)	; 0x54000
	incbin "code/gfx/gfx06.bin"

%org($8000,22)	; 0x58000
	incbin "code/gfx/gfx07.bin"

%org($8000,23)	; 0x5C000
	incbin "code/gfx/gfx08.bin"

;-------------------------------------
; 	Original graphics
;-------------------------------------
; Include the original graphics files in different order for Mother
%org($C000,7)	; 0x1C010
	incbin "code/gfx/ogfx01.bin"
	incbin "code/gfx/ogfx02.bin"
	incbin "code/gfx/ogfx03.bin"
	incbin "code/gfx/ogfx04.bin"
	incbin "code/gfx/ogfx05.bin"
	incbin "code/gfx/ogfx06.bin"
	incbin "code/gfx/ogfx07.bin"
	incbin "code/gfx/ogfx08.bin"

%org($9000,8)	; 0x21010
	incbin "code/gfx/ogfx09.bin"
	incbin "code/gfx/ogfx10.bin"
	incbin "code/gfx/ogfx11.bin"
	incbin "code/gfx/ogfx12.bin"
	incbin "code/gfx/ogfx13.bin"
	incbin "code/gfx/ogfx14.bin"



