;**************************************************************
;	Graphical changes from Metroid Mother
;**************************************************************

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
