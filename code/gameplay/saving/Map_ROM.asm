
%org($9000,14)	; 0x39010, Bank $0E

MapLoadEntryPoint:
	; Pointer to map data in ROM
	lda.b #MapData
	sta $00
	lda.b #MapData>>8
	sta $01

	; Pointer to RAM it will be copied to
	lda.b #MapRAM
	sta $02
	lda.b #MapRAM>>8
	sta $03

	; Copy 6 blocks of $100 bytes
	ldx #$07	; This was changed from $06 to $07 for Redux
	--
	    ; Copy $100 bytes
	    ldy #$00
	    -
		lda ($00),y
		sta ($02),y
		iny
	    bne -

	    ; Advance each pointer by $100
	    inc $01
	    inc $03

	    dex
	bne --


; We now return you to your normal intialization routine
	ldy #$00
	jmp ROMSwitch
    
    
%org($C123,15)	; 0x3C133 Bank $0E
;.PATCH 0F:C123
; This hijack runs our map setup when start is pressed
;    LC123: cmp #$05	    ; Are we currently paused?
;    LC125: bne +
;    LC127:     lda #$03	;   Then unpause
;    LC129:     bne $C131
;	   *
;    LC12B: cmp #$05	    ; Are we currently unpaused (as opposed to "fading in", elevator, death animation, etc)
;    LC12D: bne $C13C	   ;   Then ignore start button
;    LC12F: jmp Showmap
;    LC132: ; fin

BC123:	cmp #$03
BC125:	bne +
BC127:		jmp ShowMap
	+
BC12A:	cmp #$05
BC12C:	bne +		; $C13C
BC12E:	lda #$03
BC130:	nop
	skip 12
	+
;GoMainRoutine:
;LC114:	lda GameMode			;0 if game is running, 1 if at intro screen.
;LC116:	beq +				;Branch if mode=Play.
;LC118:	jmp $8000			;Jump to $8000, where a routine similar to the one-->
;					;below is executed, only using TitleRoutine instead
;					;of MainRoutine as index into a jump table.
;LC11B:*	lda Joy1Change			;
;LC11D:	and #$10			;Has START been pressed?-->
;LC11F:	beq +++				;if not, execute current routine as normal.
;
;LC121:	lda MainRoutine			;
;LC123:	cmp #$03			;Is game engine running?-->
;LC125:	beq +				;If yes, check for routine #5 (pause game).
;LC127:	cmp #$05			;Is game paused?-->
;LC129:	bne +++				;If not routine #5 either, don't care about START being pressed.
;LC12B:	lda #$03			;Otherwise, switch to routine #3 (game engine).
;LC12D:	bne ++				;Branch always.
;LC12F:*	lda #$05		;Switch to pause routine.
;LC131:*	sta MainRoutine		;(MainRoutine = 5 if game paused, 3 if game engine running).
;LC133:	lda GamePaused		;
;LC135:	eor #$01		;Toggle game paused.
;LC137:	sta GamePaused		;
;LC139:	jsr PauseMusic		;($CB92)Silences music while game paused.

%org($C9B1,15)	; 0x3C9C1 Bank $0F
;.PATCH 0f:C9B1
; Handle map scrolling controls during pause
	jsr MapInputHandler
	nop

;PauseMode:	
;LC9B1:	lda Joy2Status		;Load buttons currently being pressed on joypad 2.
;LC9B3:	and #$88		;
;LC9B5:	eor #$88		;both A & UP pressed?-->	


; THIS CODE IS PLACED IN FileSaveLoad.asm, BUT IS PART OF THE MAP HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;.PATCH 00:A960
;
;LoadMapHijack:
;    ; Push map loading routine address to stack
;    lda #>(MapLoadEntryPoint - 1)
;    pha
;    lda #<(MapLoadEntryPoint - 1)
;    pha
;    ldy #$0E
;    jmp RomSwitch
