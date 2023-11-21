;-------------------------------------------------------------------
;	Metroid + Saving (+ Map + WavyIce)
;		Version 0.5.2
; by snarfblam, updated disassembly to 0.5.2 by ShadowOne333
;-------------------------------------------------------------------
; This hack will only work on a Metroid ROM expanded by Editroid 3.0 or
; higher. If you would like to add saving to your hack, you can apply 
; this code as well as some necessary additional GFX. If you would like
; to add saving to an UNEXPANDED ROM, contact me and I can probably
; help.
;
; This code is intended to be assembled with snarfblASM. It would be
; extraordinarily inconvenient to assemble this hack with an assembler
; that does not support multiple segments.
;
; New code in this hack is divided into multiple sections. This is simply 
; done because the unused space in the ROM is fragmented.
;
; The saving system works by taking advantage of the password system.
; When a player saves, the password data is copied to the player's file.
; When a player loads, the password data is copied back, as if the player
; had entered the password and it had been decoded.
;
; Changes:
;   -The password system has been removed (from the perspective of the player)
;   -The "mission" shown during the title sequence has been removed.
;   -A file selection menu has been added.
;   -A game over menu has been added that allows the player to save.
;   -A player's health is now saved instead of resetting to 30 each time the player resumes a game.
;
; This file is divided into the following:
;   -Declarations
;   -New code and data (sections 1 - 5)
;   -Hijacks and modifications to existing code
;
; For modifications to existing code, the original code from the Metroid
; disassembly is included in the comments.

;-------------------------------------
;	Include TBL file for text
;-------------------------------------
incsrc "code/text/Text.tbl"

;-------------------------------------
;	Declarations
;-------------------------------------

; Existing vars (names generally taken from M1 disassembly)
Joy1Change	= $12	; Button newly pressed on this frame
Joy2Change	= $13	;
Joy1Status	= $14	; Buttons held this frame
Joy2Status	= $15	;
PalDataPending	= $1C	; Pending palette data. Palette # = PalDataPending - 1
TitleRoutine	= $1F	; Identifies which "mode" title screen is in (title screen uses a state machine)
Timer1		= $2A	; Timer. Decremented every frame if > 0.
Timer2		= $2B	; Timer. Decremented every frame if > 0.
Timer3		= $2C	; Timer. Decremented every 10 frames if > 0.
FrameCount	= $2D	; Increments every frame(overflows every 256 frames)
RandomNumber1	= $2E	; Random numbers used--> 
RandomNumber2	= $2F	; throughout the game.
GamePaused	= $31
ScrollDir	= $49
MapPosY	= $4F	; Current y position on world map.
MapPosX	= $50	; Current x position on world map.
SpritePagePos	= $5B	; Index into sprite RAM used to load object sprite data
InArea		= $74	; The area the player is in.
MaxEnergyPickup	= $94	; Maximum energy power-ups that can be picked up. Randomly recalculated whenever Samus goes through a door.
First4SlowCntr	= $BC	; This address holds an 8 frame delay. When the delay is up, the crosshair sprites double their speed.
SmallStringRam	= $C9	; Written to in title routine, but never accessed.
ScrollY	= $FC	; Y value loaded into scroll register. 
ScrollX	= $FD	; X value loaded into scroll register.
PPU2000_Cache	= $FF	; Zero-page variable that holds the value to be assigned to $2000
HealthLow	= $0106	; Health low byte (1's place in upper nibble, tenths in lower nibble)
HealthHigh	= $0107	; Health High byte (full tanks in upper nibble, 10's place in lower nibble)
MiniBossKillDelay	= $0108
Sprite00RAM	= $0200
OAM_Y		= $0200
OAM_Tile	= $0201
OAM_Att	= $0202
OAM_X		= $0203
ObjVertSpeed	= $0308
ObjHorzSpeed	= $0309
StartContinue	= $0325	; 0=START selected, 1=CONTINUE selected.
MenuSelection	= $0325
TriangleSFXFlag	= $0683	; Flags which, when set, cause sound effects to play. Used to make sounds on new menus.
SaveFileIndex	= $6875	; $00, $20, or $40, "pointer" to selected save file
SaveFileNum	= $6876	; $00, $01, or $02, index of selected save file
SamusStat00	= $6876	; Unused memory address for storing Samus info.
TankCount	= $6877	; Number of energy tanks player has.
SamusGear	= $6878	; Bit field specifying which of 8 items samus has
MissileCount	= $6879	; Number of missiles player has.
MaxMissiles	= $687A	; Maximum number of missiles player can carry
PasswordBytes	= $6988	; Un-encoded password data
BankLock	= $6FF0
RoomDataBanked	= $6FF1

;-------------------------------------
; Save memory + some vars

struct SaveFiles $7500
; Note that File_PassData hold all of the actual save data (except for health). This variable holds the password, which is handed off the the already-present password system to resume gameplay. Other variables present in the file are either there (A) to manage the file or (B) as an easily-accesible variable used to render the file menu since it is difficult to extract this info from the password.
	.File1:
	.File_InUse:	skip 1	; 0 = empty, 1 = in use
	.File_PassData	skip $12	; Password data (see PasswordBytes). This holds all the important save data. 
	.File_UnusedBytes	skip 4	; Not currently used. (Feel free to use this to save extra data if you're making a hack!)
	.File_Health	skip 2	; Health (from HealthHi and HealthLo)
	.File_SamusGear	skip 1	; Equipment (from SamusGear) (for File Menu drawing only)
	.File_Missiles	skip 1	; Missiles (for File Menu drawing only)
	.File_MissileMax	skip 1	; Missile Capacity (for File Menu drawing only)
	.File_Area	skip 1	; The area the player saved in. This value is written upon save, but never used anywhere else. Displaying the area the player saved in was considered.
	.File_Tanks	skip 1	; The number of tanks the player has. (for File Menu drawing only)
	.File_Checksum	skip 1	; The sum (truncated) of all previous file variables, used to verify the file.
	.File_Checkxor	skip 1	; The value produced by xoring all file bytes together, excluding Checksum and Checkxor, used to verify the file.
	.EndFile1:

	.File2:	skip $20	; FileSize

	.File3:	skip $20	; FileSize

; General purpose vars
	.localVar:	skip 1	; $7560, General use
	.localVar2:	skip 1	; General use
	.localVar3:	skip 1	; General use
; Menu Cursor
	.CursorDisplayX:	skip 1	; Shown cursor position (cursor will 'slide' toward actual position)
	.CursorDisplayY:	skip 1
	.CursorX:	skip 1	; Actual cursor position
	.CursorY:	skip 1
	.DeleteMode:	skip 1	; 0 = no, 1 = yes

endstruct

FileSize	= (SaveFiles.EndFile1-SaveFiles.File1)	; $20
FileSize_NoChecksum	= FileSize-2	; $1E
FileIndex_1	= $00
FileIndex_2	= FileSize
FileIndex_3	= FileSize*2


;-------------------------------------

	; Constants
PasswordDataSize	=  $12	; Number of bytes is password data (see PasswordBytes)
Joy_Left	= $02	; Controller buttons
Joy_Right	= $01
Joy_Down	= $04
Joy_Up		= $08
MapLeft	= $64	; Map position on screen
MapTop		= $32
MapWidth	= 7	; Map size, in tiles
MapHeight	= 7
SamusBlipTile	= $BF

	; Existing routines
UpdateSparkleSprites	= $87CF
CalculatePassword	= $8C7A	; Calculates the password
PasswordChecksum	= $8E21	; Store combined added value of -->
PasswordByte11		= $8E2D	; addresses $6988 thu $6998 in $6999.
ClearAll		= $909F	; Turn off screen, erase sprites and nametables
PreparePPUProcess	= $9449	; Clears screen and writes "START CONTINUE".
PreparePPUProcess_	= $C20E
Adiv8			= $C2C0	; Divide by 8
Amul32			= $C2C4	; Multiply by 32
Amul16			= $C2C5	; Multiply by 16
ScreenOn		= $C447
NmiOn			= $C487	; Turn on VBlank interrupts
ROMSwitch		= $C4EF
SamusRun		= $CCC2
DoJump			= $CD40	; Perform a Jump (Walljump)
DisplayBar		= $E0C1
CheckMoveLeft		= $E880
CheckMoveRight		= $E88B
HexToDec		= $E198
Reset			= $FFB0

; Map data and 
MapRAM			= $7900	; Address of 
MapData		= $9400	; Address of map data in bank $E

;if (<MapRam) != $00
	;.error MapRAM must begin on a $100 byte boundary 
;endif

;-------------------------------------
;	ROM executed code
;-------------------------------------

incsrc "saving/FastDoors.asm"
incsrc "saving/FileSaveLoad.asm"
incsrc "saving/HUD.asm"
incsrc "saving/ItemDrops.asm"
incsrc "saving/Map_ROM.asm"
; Additional code added for Saving Unofficial v0.4 - v0.5.2
incsrc "saving/Minimap.asm"
incsrc "saving/MissileDoors.asm"
incsrc "saving/MorphBall.asm"
incsrc "saving/RNG.asm"
incsrc "saving/Walljump.asm"
incsrc "saving/WavyIce.asm"

;-------------------------------------
;	RAM executed code
;-------------------------------------

; The code included below will be copied into RAM
; and run from there

%org($9800,14)	; 0x39810, Bank $0E

base $7D00	; Modify base address so the jmp/jsr properly point to the right place in RAM address instead of ROM
	db $00,$00,$00,$00
	incsrc "saving/Map_RAM.asm"
	incsrc "saving/WavyIce_RAM.asm"
	incsrc "saving/MinimapPos.asm"

base off

;-------------------------------------------------------------------
; Free memory
; (This is old and crap. Ignore it)

; Title Bank
;   $BDCD - $BE76 - FileSaveLoad.asm
;   $945F - $955F - FileSaveLoad.asm
;   $B135 - $B1FF - FileScreenLayout.asm
;   $8668 -  ???? - FilescreenLayout.asm
;   $9960 - $9983 - free
;   $A961 - $ABFF - FileSaveLoad.asm

; ================================
; Bank Lock Fix
; ================================
; All of the code from here forward fixes a bug in older versions of the hack.
; The bank lock variables used to be stored in the same region of WRAM as the save files, so it wasn't cleared on RESET. This means, if there is garbage in the RAM, the lock may be set on boot, which causes a deadlock!

; Here we just update all references to said variable to use memory locations that will be cleared on RESET
;-------------------------------------
%org($CA36,15)	; $3CA46
	dw BankLock
%org($CA46,15)	; $3CA56
	dw BankLock
%org($CA4B,15)	; $3CA5B
	dw BankLock
%org($CA52,15)	; $3CA62
	dw BankLock
%org($CAB5,15)	; $3CAC5
	dw BankLock
;-------------------------------------
%org($CA3B,15)	; $3CA4B
	dw RoomDataBanked
%org($CA57,15)	; $3CA67
	dw RoomDataBanked
%org($CABF,15)	; $3CACF
	dw RoomDataBanked
%org($CACC,15)	; $3CADC
	dw RoomDataBanked
;-------------------------------------



