; -----------------------------------------
;		Section 1
; -----------------------------------------

%org($BDCD,0)	; 0x03DDD
FileIndexList:
; Used to retrieve file index for a given save file number
; File Index 1, 2, 3
	;	$00,	   $20,		$40
	db FileIndex_1,FileIndex_2,FileIndex_3

InitFileDisplay:
; Verifies files are valid, then draws the file menu.
; Verify files
	ldy #$00
	jsr VerifyFile
	ldy #$01
	jsr VerifyFile
	ldy #$02
	jsr VerifyFile

; Render files
	ldy #$00
	jsr RenderFile
	ldy #$01
	jsr RenderFile
	ldy #$02
	jsr RenderFile

; Init menu variables
	ldy #$00
	sty MenuSelection		; MenuSelection = 0
	sty SaveFiles.DeleteMode	; DeleteMode = false
	dey
	sty SaveFiles.CursorDisplayX	; CursorDisplayX/Y are set to FF (lower-right
	sty SaveFiles.CursorDisplayY	; corner). This causes the cursor to zip into place when the menu is shown.

        ;return from hijack
	jmp ScreenOn		

VerifyFile:
; Verifies a single file, sets it to empty if the file is not valid.
; This is needed the first time the game is booted to clear garbage in RAM.
; y [in] file num
	lda FileIndexList,y	; Custom table
	tax
	stx SaveFileIndex

; If file is not in use, don't bother verifying
	lda SaveFiles.File_InUse,x
	beq Exit

; Verify checksum 
	jsr GetFileSum		; Get checksum
	ldx SaveFileIndex	; Get file index
	cmp SaveFiles.File_Checksum,x	; Compare to stored checksum
	bne ClearFile		; Mark file unused if checksum invalid

; Verify check XOR
	jsr GetFileXor		; Get checkxor
	ldx SaveFileIndex	; Get file index
	cmp SaveFiles.File_Checkxor,x	; Compare to stored checkxor
	beq Exit		; Mark file unused if checkxor invalid

ClearFile:	
	lda #$00
	sta SaveFiles.File_InUse,x

Exit:	
	rts

GetFileSum:	; $BE28
; Add all save file bytes together
; Destroys X and Y
; x [in]    File index
; a [out]   Sum
	lda #$00
	ldy #FileSize_NoChecksum
	-	clc
		adc SaveFiles.File_InUse,x
		inx
		dey
	bne -
	rts

GetFileXor:	; $BE35
	lda #$00
	ldy #FileSize_NoChecksum
	-	clc
		eor SaveFiles,x
		inx
		dey
		bne -
	rts

InitializeStats_InitHealth:	; $BE42
; Extends InitializeStats to set initial health value to 30
; (This used to be done in SamusInit which is called by GoMainRoutine)
	lda #$03
	sta HealthHigh
	lda #$00
	sta HealthLow

	; displaced code:
        ;LDA #$00			        ;A already 0
	sta SamusStat00	; $6876
	rts

FileBlankStrings:	; $BE50
; Pointers to PPU writes at $B135
	dw FileBlank_1,FileBlank_2,FileBlank_3

FileItemStrings:	; $BE56
; Pointers to PPU strings for each file's equipment display
	dw FileItems_1,FileItems_2,FileItems_3

ItemPPUAddresses:	; $BE5C
; Base address for each file's equipment display. Used for blanking items the player does not posess.
	dw $2545,$25E5,$2685

TankPPUAddresses:	; $BE62
; Base address for each file's tank display. Used for blanking tanks the player does not have.
	dw $250B,$25AB,$264B

EquipmentFlags:		; $BE68
; This is the order items appear on the file screen (corresponds to SamusGear values)
	db $10,$01,$02,$20,$08,$04,$40,$80

endSection1:

; -----------------------------------------
;		Section 2
; -----------------------------------------

%org($A960,0)	; 0x02970
LoadMapHijack:
; Push map loading routine address to stack
	lda.b #(MapLoadEntryPoint-1 >>8)	; #$8F
	pha
	lda.b #(MapLoadEntryPoint-1)		; #$FF
	pha
	ldy #$0E
	jmp ROMSwitch

RenderFile:
; Draws a save file to the file menu
; y [in] file number
        
; Usage of locals
; localVar = loop counter
; localVar2 = File number * 2 (used to load 2-byte value from tables) (in retrospect, it would be smarter to split these tables in two, one for high byte and one for low)
; localVar3 = Player's equipment

	lda FileIndexList,y	; Get and store file
	tax
	stx SaveFileIndex
	sty SaveFileNum
	;y *= 2 (pointer table index)
	tya
	asl
	tay
	sty SaveFiles.localVar2
	lda SaveFiles.File_InUse,x	; If file is empty, blank it out 
	bne RenderUsedFile
	jmp RenderEmptyFile	; Jump to new code

RenderUsedFile:
; Start by drawing all possible equipment, then blank out equipment player doesn't have
	ldx FileItemStrings,y
	lda FileItemStrings+1,y
	tay
	jsr PreparePPUProcess_

	ldy SaveFiles.localVar2
	ldx SaveFileIndex
	lda SaveFiles.File_SamusGear,x
	sta SaveFiles.localVar3

	lda #$07	; process 8 bits
	sta SaveFiles.localVar
	loop:
		lda SaveFiles.localVar3		; Get equipment
		ldx SaveFiles.localVar		; Which item are we checking?
		and EquipmentFlags,x	; Check it.
		bne skipItem		; Don't blank it out if player has it.
			ldy SaveFiles.localVar2	; Get ptr table index
			lda ItemPPUAddresses+1,y	; PPU Dest High
			sta SmallStringRam
			lda SaveFiles.localVar	; PPU Dest Low (3 * item_index + base_address)
			asl		; item index * 2
			clc
			adc SaveFiles.localVar	; + item index
			adc ItemPPUAddresses,y	; + base address
			sta SmallStringRam+1
			lda #$42	; PPU Length byte (two tiles, RLE)
			sta SmallStringRam+2
			lda #$FF	; PPU tiles: FF (blank)
			sta SmallStringRam+3
			lda #$00	; End of data
			sta SmallStringRam+4

		; Load to PPU
			ldx #SmallStringRam
			ldy #$00
			jsr PreparePPUProcess_

		; Create PPU string to clear bottom 2 tiles
		; (use same string, but add $20 to ppu dest for next row)
			lda #$20
			clc
			adc SmallStringRam+1
			sta SmallStringRam+1
			bcc ++		; Carry
				inc SmallStringRam
		; Load to PPU
		++	ldx #SmallStringRam
			ldy #$00
			jsr PreparePPUProcess_

skipItem:
		dec SaveFiles.localVar
	bpl loop
	
BlankTanks:
; 8 tanks are currently shown. Blank enough to show correct amt
	ldx SaveFileIndex	; Get tank count
	lda SaveFiles.File_Tanks,x
	sta SaveFiles.localVar

	ldy SaveFiles.localVar2		; Get PPU address of tanks
	lda TankPPUAddresses+1,y		; PPU dest high
	sta SmallStringRam
	lda TankPPUAddresses,y	; PPU dest low
	clc
	adc SaveFiles.localVar		; + tank count (leave this many tanks)
	sta SmallStringRam+1

	lda #$48		; 8 tiles, RLE
	sec
	sbc SaveFiles.localVar		; - tank count
	sta SmallStringRam+2

	lda #$FF		; FF = blank tiles
	sta SmallStringRam+3

	cmp #$40		; If player has 8 tanks, there is nothing to blank out. Move on to next thing.
	beq DontBlankTanks

	ldx #SmallStringRam
	ldy #$00
	jsr PreparePPUProcess_

DontBlankTanks:
ShowMissiles:
	ldy SaveFiles.localVar2		; Calculate PPU address of missiles (to right of tanks)
	lda TankPPUAddresses,y
	clc
	adc #$0B
	sta SmallStringRam+1

	ldx SaveFileIndex	; Get missile count, convert to decimal
	lda SaveFiles.File_Missiles,x
	jsr HexToDec

	ldx #$03		; Insert into PPU string
	jsr AddDecimalToPpuString

	lda #$F6		; Insert slash
	sta SmallStringRam,x
	inx

	txa			; Remember our place
	pha

	ldx SaveFileIndex	; Get missile capacity, convert to decimal
	lda SaveFiles.File_MissileMax,x
	jsr HexToDec

	pla			; Back to our PPU string
	tax

	jsr AddDecimalToPpuString	; Insert missile capacity into string

	lda #$00		; Add our zero terminator
	sta SmallStringRam,x

	lda #$07		; string size is 7 (two 3-digit nums + slas)
	sta SmallStringRam+2

; Load to PPU
	ldx #SmallStringRam
	ldy #$00
	jsr PreparePPUProcess_

	rts

RenderEmptyFile:	; $AA57
; Blank out energy tanks and missile count with ready-made PPU string
	ldx FileBlankStrings,y
	lda FileBlankStrings+1,y
	tay
	jsr PreparePPUProcess_
	rts

AddDecimalToPpuString:	; $AA62
; x   [in]  position within string to output
; $00 [in]  1s place
; $01 [in]  10s place
; $02 [in]  100s place
; x   [out] position within string after output
	lda $02		; 100 place
	bne +
		lda #$FF	; Don't show digit if 0
+	sta SmallStringRam,x

	lda $01		; 10 place
	bne +		; Show if not zero
		tay		; Show if zero but 100s place is non-zero
	bne +
		lda #$FF	; Don't show digit 
+	sta SmallStringRam+1,x

	lda $00		; 1 place (always show, even if 0)
	sta SmallStringRam+2,x

; Update pointer to name table string
	inx
	inx
	inx

	rts

SaveGame:	; $AA7D
	jsr CalculatePassword	; Create save data

	ldx SaveFileIndex	; Mark file as in-use
	lda #$01
	sta SaveFiles.File_InUse,x

	lda SamusGear		; Save equipment, area, health for menu display 
	sta SaveFiles.File_SamusGear,x
	lda TankCount
	sta SaveFiles.File_Tanks,x
	lda MissileCount
	sta SaveFiles.File_Missiles,x
	lda MaxMissiles
	sta SaveFiles.File_MissileMax,x
	lda InArea
	and #$0F		; Only need lower nibble of area

	sta SaveFiles.File_Area,x
	lda HealthLow
	sta SaveFiles.File_Health,x
	lda HealthHigh
	sta SaveFiles.File_Health+1,x

	lda #$11		; Copy the $12 bytes of password data
	tay			; ($11 to $00)
	clc
	adc SaveFileIndex
	tax			; Index into corresponding save file bytes

	ldy #$11
	-	lda PasswordBytes,y
		sta SaveFiles.File_PassData,x
		dex
		dey
	bpl -

	ldx SaveFileIndex	; Calculate and save checksums
	jsr GetFileSum
	ldx SaveFileIndex	; (X overwritten by checksum routine)
	sta SaveFiles.File_Checksum,x
	jsr GetFileXor
	ldx SaveFileIndex	; (X overwritten by checkxor routine)
	sta SaveFiles.File_Checkxor,x

	rts

LoadGame:
	ldx SaveFileIndex	; If file is empty, start a new game
	lda SaveFiles.File_InUse,x
	bne +
		jmp InitializeStats

+	lda SaveFiles.File_Health,x	; Load player health
	sta HealthLow
	lda SaveFiles.File_Health+1,x
	sta HealthHigh

	txa			; Copy 12 password data bytes
	clc
	adc #$11
	tax
	ldy #$11
	-	lda SaveFiles.File_PassData,x
		sta PasswordBytes,y
		dex
		dey
	bpl -

	lda PPU2000_Cache	; Switch to nametable 0 (or else glitches)
	and #$FE
	sta PPU2000_Cache
	
	jmp InitializeGame		; Continue (initialize game with password data)

BeepSound:	; $AB0E
; Beeps
	lda TriangleSFXFlag
	ora #$08
	sta TriangleSFXFlag
	rts

GulpSound:	; $AB17
; Gulps
	lda TriangleSFXFlag
	ora #$04
	sta TriangleSFXFlag
	rts

CheckMenuUpDown:	; $AB20
; Processes menu item selection (up, down, delete mode activation/cancelation)
	lda Joy1Change
	and #$0C
	beq NoUpDown

	cmp #$04	; Down?
	bne +
	inc MenuSelection	;   Move to next selection (wrap from 3 to 0)
	jsr BeepSound
	jmp TruncateAndReturn

+			; Up
	inc MenuSelection	; Move forward 3 menu selections
	inc MenuSelection	; (Since there are 4 options, we'll have
	inc MenuSelection	; wrapped back to previous selection)
	jsr BeepSound

TruncateAndReturn:	; $AB3F
	lda #$03	; Wrap around (from last item to first or vice-versa)
	and MenuSelection
	sta MenuSelection

NoUpDown:
; Pressing A, B, or select cancels erase mode and moves cursor off "ERASE"
	lda Joy1Change
	and #$E0
	beq +
		lda #$00
		sta SaveFiles.DeleteMode

		lda MenuSelection	; If "ERASE" selected, move to irst item
		cmp #$03
		bne +
			lda #$00
			sta MenuSelection
	+

; Pressing start while "ERASE" is selected enters erase mode
	lda Joy1Change
	and #$90	; Was start or A pressed?
	beq +
	lda MenuSelection	; Was "ERASE" selected?
	cmp #$03
	bne +
		lda #$00	 ; Select File 1
		sta MenuSelection
		lda #$03
		eor SaveFiles.DeleteMode 	; Toggle Deletion mode
		sta SaveFiles.DeleteMode 
		jsr GulpSound	; Play Gulp sound

	+
	rts

UpdateFileCursor:	; $AB7C
; Updates cursor display position for "gliding" effect
	ldy MenuSelection	; Get cursor position based on currently selected item
	lda CursorPositionX,y
	sta SaveFiles.CursorX
	lda CursorPositionY,y
	sta SaveFiles.CursorY

; Updates display position of cursor to glide to actual position
	lda #$00		; High byte for 16-bit math (use A for low byte)
	sta SaveFiles.localVar

	lda SaveFiles.CursorX		; Cursor X
	cmp SaveFiles.CursorDisplayX	; (add 1 extra (via carry flag) if actual pos is greater, to round up when we divide)
	adc SaveFiles.CursorDisplayX	; + display x
	bcc +
		inc SaveFiles.localVar	; Carry to high byte
+	lsr SaveFiles.localVar		; 16-bit divide by 2
	ror
	sta SaveFiles.CursorDisplayX
; Don't need to reset localVar, it was cleared when we divided
	lda SaveFiles.CursorY		; Cursor Y
	cmp SaveFiles.CursorDisplayY	; (+ 1 (via carry) if actual pos is greater, to round up when we divide)
	adc SaveFiles.CursorDisplayY	; + display Y
	bcc +
		inc SaveFiles.localVar	; Carry to high byte
+	lsr SaveFiles.localVar		; 16-bit divide by 2
	ror
	sta SaveFiles.CursorDisplayY

	rts

DrawFileCursor:		; $ABBB
; Draws the file menu cursor sprites
	ldy #$00
	ldx #$00

	lda SaveFiles.CursorDisplayX
	sta SaveFiles.localVar
	-	lda CursorTiles,y	; Get tile number
		beq DoneDrawing		; If zero, we are done
		sta $0201,x		; Sprite Y
		lda SaveFiles.CursorDisplayY
		sta $0200,x
		lda #$21		; Spr Attr (Behind text, pal 1)
		eor SaveFiles.DeleteMode		; (pal 0 if erase mode)
		sta $0202,x
		lda SaveFiles.localVar		; Sprite X 
		sta $0203,x
		clc			; Next tile 8 px to the right
		adc #$08
		sta SaveFiles.localVar

		inx			; Next sprite
		inx
		inx
		inx

		iny			; Next tile

	bne -				; Branch always

DoneDrawing:
	rts

ResetTitleAnimation:	; $ABEF
; Resets title screen animation instead of displaying your "mission"
	lda #$04
	sta TitleRoutine
	lda #$20	; Set timer delay for METROID flash effect.-->
	sta Timer3	;Delays flash by 320 frames (5.3 seconds).
	rts

endSection2:

; -----------------------------------------
;		Section 3
; -----------------------------------------

; Replace unused intro routines with custom code
%org($945F,0)	; 0x0146F
CursorTiles:
; Sprite tiles used to make the cursor
	db $D0,$D1,$D1,$D1,$D1,$D1,$D1,$D2,$00

CursorPositionX:	; $9468
; Cursor X position for each file menu item
	db $10,$10,$10,$B3

CursorPositionY:	; $946C
; Cursor y position for each file menu item
	db $3F,$67,$8F,$1F

UpdateGameOverScreen:

	lda Joy1Change
	and #$0C	; Read only inputs for D-Pad Up or Down
	beq EndUpDown	; Is the player pressing up or down?
		cmp #$08	; Check if button press is Up
		bne +		; Up:
			dec MenuSelection	; Previous item
			bpl Beep	; Wrap from first to last
			lda #$02
			sta MenuSelection
			bne Beep	; (branch always)

		+		;   Down:
		inc MenuSelection	; Next item

		lda MenuSelection

		cmp #$03	; Wrap from last to first
		bne Beep
		lda #$00
		sta MenuSelection

Beep:
	jsr BeepSound

EndUpDown:
	lda Joy1Change
	and #$90	; Pressing Start or A?
	beq ShowCursor
		dec MenuSelection	; Continue?
		bpl +
			jmp InitializeGame	; Continue. (Not sure whether I should jmp or jsr, but either one seams to leave stack balanced)
		+
		dec MenuSelection	; Save or Quit:
		bpl +			; Don't save if player selected quit
			jsr SaveGame
		+
			jmp Reset	; Soft reset if player picked save or quit

ShowCursor:
	lda #$68
	sta $0203		; X
	ldy MenuSelection
	lda GameOverCursorY,y	; Y
	sta Sprite00RAM
	lda #$6F		; Tile
	sta $0201
	lda #$03
	sta $0202		; Palette

	rts

GameOverCursorY:	; $94CA
	; 	$67	$7F	$97
	db $0D*$08-1,$10*$08-1,$13*$08-1

GameOverMenuStrings:	; $94DD
	; Samus row 1
	db $20,$8A,$03
	db $F7,$F8,$F9

	; GAME OVER, Samus row 2
	db $20,$AA,$0D
	db $FA,$FB,$FC,$FF
	db "GAME OVER"

	; Samus row 3
	db $20,$CA,$03
	db $FD,$F4,$F5

	;Defeat the Mother Brain and the Metroid threat!
	db $21,$05,$17
	db "DEFEAT MOTHER BRAIN AND"
	db $21,$27,$13
	db "THE METROID THREAT!"

	; CONTINUE
	db $21,$AD,$0A
	db $FE,$FF
	db "CONTINUE"

	; SAVE
	db $22,$0D,$06
	db $FE,$FF
	db "SAVE"

	; QUIT
	db $22,$6D,$06
	db $FE,$FF
	db "QUIT"

	; Attributes (for Samus)
	db $23,$CA,$02
	db $55,$99

	db $23,$D0,$08
	db $55,$55,$55,$55,$55,$55,$55,$55
	;db $23,$D2,$02,$55,$F9
        
        ; END OF DATA
	db $00		; End PPU string write.

Section3End:
	nop

; -----------------------------------------
;		Section 5
; -----------------------------------------

; Replace unused tile patterns with new PPU writes for Saving
%org($B135,0)	; 0x03145
FileScreenItemStrings:

FileItems_1:
	db $25,$45,$18
	db $D0,$D1,$FF,$D2,$D3,$FF
	db $D4,$D5,$FF,$D6,$D7,$FF
	db $D8,$D9,$FF
	db $DA,$DB,$FF,$DC,$DD,$FF
	db $DE,$DF,$FF

	db $25,$65,$18
	db $E0,$E1,$FF
	db $E2,$E3,$FF
	db $E4,$E5,$FF
	db $E6,$E7,$FF
	db $E8,$E9,$FF
	db $EA,$EB,$FF
	db $EC,$ED,$FF
	db $EE,$EF,$FF
	db $00		; End PPU string write.

FileItems_2:
	db $25,$E5,$18
	db $D0,$D1,$FF
	db $D2,$D3,$FF
	db $D4,$D5,$FF
	db $D6,$D7,$FF
	db $D8,$D9,$FF
	db $DA,$DB,$FF
	db $DC,$DD,$FF
	db $DE,$DF,$FF
	
	db $26,$05,$18
	db $E0,$E1,$FF
	db $E2,$E3,$FF
	db $E4,$E5,$FF
	db $E6,$E7,$FF
	db $E8,$E9,$FF
	db $EA,$EB,$FF
	db $EC,$ED,$FF
	db $EE,$EF,$FF
	db $00		; End PPU string write.

FileItems_3:
	db $2E,$85,$18
	db $D0,$D1,$FF
	db $D2,$D3,$FF
	db $D4,$D5,$FF
	db $D6,$D7,$FF
	db $D8,$D9,$FF
	db $DA,$DB,$FF
	db $DC,$DD,$FF
	db $DE,$DF,$FF

	db $2E,$A5,$18
	db $E0,$E1,$FF
	db $E2,$E3,$FF
	db $E4,$E5,$FF
	db $E6,$E7,$FF
	db $E8,$E9,$FF
	db $EA,$EB,$FF
	db $EC,$ED,$FF
	db $EE,$EF,$FF
	db $00		; End PPU string write.

FileBlank_1:
	db $25,$0B,$52
	db " "
	db $00		; End PPU string write.

FileBlank_2:
	db $25,$AB,$52
	db " "
	db $00		; End PPU string write.

FileBlank_3:
	db $26,$4B,$52
	db " "
	db $00		; End PPU string write.

EndFileSCreenItemStrings:

; -----------------------------------------
;		Hijacks
; -----------------------------------------
;    and modifications to existing code

%org($C057,15)	; 0x3C067
; Update memory clearing routine to leave save file SRAM alone
	ldy #$74	; High byte of start address.
	sty $01		;
	ldy #$00	; Low byte of start address.
	sty $00


%org($90BA,0)	; 0x010CA
; Initialize file selection mode
; (this replaces the routine that used to clear screen and draw "START" and "CONTINUE")
	ldy #$00
	sta MenuSelection
	sta SaveFileNum
	sta SaveFileIndex
	lda #$16
	sta TitleRoutine
	rts : nop


%org($90D7,0)	; 0x010E7
; $80 = A,	$40 = B,	$20 = Select,	$10 = Start
; $08 = Up,	$04 = Down,	$02 = Left,	$01 = Right

; Rewrite of the start-button-handler (prev. for "START"/"CONTINUE") to
; Load/Erase a file
ChooseStartContinue:
	lda Joy1Change
	and #$90	; Read inputs for Start and A buttons only
	beq +		; Start or A pressed?
		lda MenuSelection	; Get file num and index
		tay
		sty SaveFileNum
		ldx FileIndexList,y
		stx SaveFileIndex

		cmp #$03
		beq +

		ldy SaveFiles.DeleteMode
		bne EraseFile
		jmp LoadGame

	EraseFile:
		lda #$00
		sta SaveFiles.File_InUse,x
		jmp Reset
	+

	jsr CheckMenuUpDown
	jsr UpdateFileCursor
	jsr DrawFileCursor
	rts

endChooseStartContinue:



%org($80F6,0)	; 0x00106
; Jump to our routine that draws the file screen before turning the screen on
	jmp InitFileDisplay	; BDD0


%org($815B,0)	; 0x0016B
; Loop back to the delay then flash "METROID" routine instead of proceeding to crosshair animation
	jmp ResetTitleAnimation
	nop	; NOP leftover byte from previous BNE


%org($8000,0)	; 0x00010
; Only listen for start-button BEFORE crosshair animation (a new routine handles input for file menu)
	lda TitleRoutine
; Change the branch target to include the call to RemoveIntroSprites when start is pressed. 
; This needs to be called now since the sparkle animation may be in progress when start is pressed
	cmp #$07		; If title not running, branch
	bcs notTitle


%org($801C,0)	; 0x00678
; When start is pressed, begin the crosshair animation, which will then move on to file menu
	lda #$07
	sta TitleRoutine
	nop #2
notTitle:


%org($8257,0)	; 0x00267
; Instead of fading out the story (now the file menu) after a delay, we want to go to file selection mode
MessageFadeIn:
	lda #$16		; lda #$30 -> #$16
	sta TitleRoutine	; Timer3 -> TitleRoutine
	rts			; inc #$1F -> rts : nop
	nop


%org($9359,0)	; 0x01369
DisplayPassword:	; Repurposed to draw the game over menu.
	jsr CalculatePassword	; Calculate Password
	jsr ClearAll		; ClearAll

	ldx #SmallStringRam+4	; #<GameOverMenuStrings
	ldy #MaxEnergyPickup	; #>GameOverMenuStrings
	jsr PreparePPUProcess	; PreparePpuProcess

	jsr $C601		; LoadGFX7 (THE NEW VERSION for enhanced ROMs)
	jsr NmiOn		; NmiOn
	jsr $C32C		; WaitNMIPass
	lda #$0C
	sta PalDataPending	; PalDataPending
	inc TitleRoutine

	lda #$00
	sta MenuSelection

	jmp ScreenOn

EndOfDisplayPassword:



%org($805E,0)	; 0x0006E
; Update title routine pointer from game-over password screen to game over save menu
	dw UpdateGameOverScreen	; $9470


%org($C578,15)	; 0x3C588
; Modify ClearSamusStats so that player health is not cleared. This allows the health value assigned by LoadGame to remain intact.
ClearSamusStats:
	ldy #$07
	lda #$00
	-	sta MiniBossKillDelay,y
		dey
		bpl -
	rts


%org($92D4,0)	; 0x012E4
InitializeGame:


%org($932B,0)	; 0x0133B
; Hijack - Set health to 030.0 for new game (this used to be done in SamusInit for both new game and continue)
InitializeStats:
	jsr InitializeStats_InitHealth	; Jump to custom code


; Moved to Fast Doors
;%org($C920,15)	; 0x3C930
; Hijack - Instead of initializing health to 030.0 every game, only set to 030.0 if it is less (i.e. player has died, or saved with very low health)
	;jmp CheckMinHealth


%org($939E,0)	; 0x013AE
; Nix "game over" screen, since the password screen (which is now our game over menu) already informs you the game is over
GameOver:
	lda #$19
	sta TitleRoutine
	rts


%org($8E17,0)	; 0x00E27
;%org($8E1D,0)	; 0x00E2D
; This was located at $8E17 originally for Saving v0.2
; Remove password scrambling
PasswordChecksumAndScramble:
	jsr PasswordChecksum
	sta PasswordByte11
	rts	; NO Scrambling
	nop #3
; All this is just an RTS in Saving 0.5.2, requires a check

%org($8D0C,0)	; 0x00D1C
; Remove call to LoadPasswordChar
	jmp PasswordChecksumAndScramble	; Originally jsr $8E17
	;jmp $8E17

%org($8132,0)	; 0x00142
; Doubling the speed of the METROID fade in here
	and #$08


%org($80FF,0)	; 0x0010F
; Reduce the delay before METROID fades in
	lda #$04	; lda #$08 -> #$04
	sta Timer3
	nop		 ; This NOP replaces LSR that is meant to change A from 8 to 4


%org($8172,0)	; 0x00182
; Reduce the delay before the crosshair animation
	lda #$08
	sta First4SlowCntr	; First4SlowCntr
	lda #$00
	sta Timer3


%org($8165,0)	; 0x00175
; Double the speed of the METROID fade out
	and #$03


%org($8236,0)	; 0x00246
; Reduce delay before file screen fade in
	lda #$01


%org($8249,0)	; 0x00259
; Double speed of file menu fade in
	and #$03	; and #$07 -> #$03

;-----------------------------------------

%org($8668,0)	; 0x00678
; Replaces "EMERGENCY ORDER" text with file menu
FileScreenStrings:
	db $24,$86,$0B	; PPU Address and length
	db "SELECT FILE"
	;Writes row $2480 (5th row from top).
	;db $24,$88,$0F	; PPU address and length
	;db "EMERGENCY ORDER"

	db $24,$98,$05	; PPU Address and length
	db "ERASE"
	;Writes row $2500 (9th row from top).
	;db $25,$04,$1C	; PPU address and length
	;db "DEFEAT THE METROID OF   "

	db $2D,$03,$1A	; PPU Address and length
	db "FILE 1"	; File #
	db "  " : fillbyte $F1 : fill 8 : db " " ; Energy Tank spaces
	db $F2,$F3,"111/111"	; Missile icon and missile counter
	;Writes row $2540 (11th row from top).
	;db $25,$44,$1A	; PPU address and length
	;db "THE PLANET ZEBES AND      "
	;db "THE PLANET ZEBETH AND     "

	db $2D,$45,$07	; PPU Address and length
	db "-EMPTY-"
	;Writes row $2580 (13th row from top).
	;db $25,$84,$1A	; PPU address and length
	;db "DESTROY THE MOTHER BRAIN  "

	db $2D,$A3,$1A	; PPU Address and length
	db "FILE 2"	; File #
	db "  " : fillbyte $F1 : fill 8 : db " " ; Energy Tank spaces
	db $F2,$F3,"111/111"	; Missile icon and missile counter
	;Writes row $25C0 (15th row from top).
	;db $25,$C4,$1A	; PPU address and length
	;db "THE MECHANICAL LIFE VEIN  "

	db $25,$E5,$07	; PPU Address and length
	db "-EMPTY-"
	;Writes row $2620 (18th row from top).
	;db $26,$27,$15	; PPU address and length
	;db "GALACTIC FEDERATION  "
	;db "GALAXY FEDERAL POLICE"

	db $2E,$43,$1A	; PPU Address and length
	db "FILE 3"	; File #
	db "  " : fillbyte $F1 : fill 8 : db " " ; Energy Tank spaces
	db $F2,$F3,"111/111"	; Missile icon and missile counter
	;Writes row $2660 (20th row from top).
	;db $26,$69,$12	; PPU address and length
	;db "              M510"
	

	db $2E,$85,$07	; PPU Address and length
	db "-EMPTY-"
	
	db $00		; End PPU string write.

EndFileScreenStrings:

	%fillto($871E,0,$FF)

warnpc $871E	; 0x0072E

;-----------------------------------------
;	Save File Menu layout
;-----------------------------------------
; SAVE MENU NEEDS TO BE CHANGED TO ACCOUNT FOR ALL 8 ENERGY TANKS!
; At the moment, having 7 works fine, but if you get the 8th energy tank, the save menu blanks out the next save file in the menu. This needs to be fixed


;The following data fills name table 1 with the intro screen background graphics, but for Redux, this is replaced for the Save File screen, so this one gets omitted 
%org($852D,0)	; 0x0053D
; Ground tiles for the Save File menu
; Attributes for file menu
	db $27,$C0,$20	; PPU address and length
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$5F,$5F,$5F,$5F,$5D,$5F,$5F
	db $FF,$5F,$5F,$5F,$5F,$5D,$5F,$FF
	;db $00,$00,$00,$00,$00,$00,$00,$00
	;db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	"        "
	;db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	"        "
	;db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	"        "

;Writes row $27E0 (24th row from top).
	db $27,$E0,$20	; PPU address and length
	db $FF,$F5,$F5,$F5,$F5,$D5,$F5,$FF
	db $00,$05,$05,$05,$05,$05,$05,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	;db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	;db $00,$00,$00,$00,$00,$00,$00,$00
	;db $00,$00,$00,$00,$00,$00,$00,$00
	;db $00,$00,$00,$00,$00,$00,$00,$00

;Writes row $26E0 (24th row from top).
	db $26,$E0,$20	; PPU address and length
	db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
	db $FF,$FF,$FF,$CD,$FF,$FF,$CE,$FF
	db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF
	db $FF,$FF,$FF,$CD,$FF,$FF,$CE,$FF
	;db $FF,$FF,$FF,$FF,$FF,$8C,$FF,$FF
	;db $FF,$FF,$FF,$8D,$FF,$FF,$8E,$FF
	;db $FF,$FF,$FF,$FF,$FF,$8C,$FF,$FF
	;db $FF,$FF,$FF,$8D,$FF,$FF,$8E,$FF

;Writes row $2700 (25th row from top).
	db $27,$00,$20	; PPU address and length
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	db $C0,$C1,$C0,$C1,$C0,$C1,$C0,$C1
	;db $80,$81,$80,$81,$80,$81,$80,$81
	;db $80,$81,$80,$81,$80,$81,$80,$81
	;db $80,$81,$80,$81,$80,$81,$80,$81
	;db $80,$81,$80,$81,$80,$81,$80,$81

;Writes row $2720 (26th row from top).
	db $27,$20,$20	; PPU address and length
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	db $C2,$C3,$C2,$C3,$C2,$C3,$C2,$C3
	;db $82,$83,$82,$83,$82,$83,$82,$83
	;db $82,$83,$82,$83,$82,$83,$82,$83
	;db $82,$83,$82,$83,$82,$83,$82,$83
	;db $82,$83,$82,$83,$82,$83,$82,$83

;Writes row $2740 (27th row from top).
	db $27,$40,$20	; PPU address and length
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	db $C4,$C5,$C4,$C5,$C4,$C5,$C4,$C5
	;db $84,$85,$84,$85,$84,$85,$84,$85
	;db $84,$85,$84,$85,$84,$85,$84,$85
	;db $84,$85,$84,$85,$84,$85,$84,$85
	;db $84,$85,$84,$85,$84,$85,$84,$85

;Writes row $2760 (28th row from top).
	db $27,$60,$20	; PPU address and length
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	db $C6,$C7,$C6,$C7,$C6,$C7,$C6,$C7
	;db $86,$87,$86,$87,$86,$87,$86,$87
	;db $86,$87,$86,$87,$86,$87,$86,$87
	;db $86,$87,$86,$87,$86,$87,$86,$87
	;db $86,$87,$86,$87,$86,$87,$86,$87

;Writes row $2780 (29th row from top).
	db $27,$80,$20	; PPU address and length
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	db $C8,$C9,$C8,$C9,$C8,$C9,$C8,$C9
	;db $88,$89,$88,$89,$88,$89,$88,$89
	;db $88,$89,$88,$89,$88,$89,$88,$89
	;db $88,$89,$88,$89,$88,$89,$88,$89
	;db $88,$89,$88,$89,$88,$89,$88,$89

;Writes row $27A0 (bottom row).
	db $27,$A0,$20	; PPU address and length
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B
	db $8A,$8B,$8A,$8B,$8A,$8B,$8A,$8B


;-------------------------------
;	Palette changes
;-------------------------------
; Background palettes
%org($9589,0)	; 0x01599
        db $0F,$28,$18,$08,$0F,$0F,$0F,$0F
        db $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F

; Save File Samus/Metroid palettes for Game Over Screen
%org($9715,0)	; 0x01725
	db $0F,$28,$18,$08,$0F,$16,$1A,$27
	db $0F,$31,$31,$01,$0F,$31,$11,$01

; Save File Item icons palette
%org($9739,0)	; 0x01749
	db $0F,$28,$18,$08,$0F,$06,$17,$27
	db $0F,$27,$28,$29,$0F,$31,$31,$01
        db $0F,$16,$2A,$27,$0F,$12,$30,$21
        db $0F,$27,$24,$2C,$0F,$15,$21,$38
        
; Save File screen fade-in palettes
%org($975D,0)	; 0x0176D
	db $0F,$28,$18,$08,$0F,$0F,$06,$17
	db $0F,$12,$12,$01,$0F,$12,$02,$01

%org($9781,0)	; 0x01791
	db $0F,$28,$18,$08,$0F,$0F,$07,$06
	db $0F,$02,$02,$0F,$0F,$02,$01,$0F

%org($97A5,0)	; 0x017B5
	db $0F,$28,$18,$08,$0F,$0F,$0F,$07
	db $0F,$01,$01,$0F,$0F,$01,$0F,$0F


