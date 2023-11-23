;-------------------------------------
;    	Main Map data
;-------------------------------------

; Main Map data
%org($9400,14)	; 0x39410
MapTilemap:
	incbin "MapTilemap.bin"

;-------------------------------------
;	Corner Minimap
;-------------------------------------

; Change the Display bar jump
%org($CB57,15)	; 0x3CB67
; Jump to custom Minimap (MinimapPos.asm) routine
	jsr MinimapPos	; $7EA8, Originally $E0C1 (DisplayBar)

;-------------------------------------



