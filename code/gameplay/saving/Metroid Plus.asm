; Metroid + Saving (+ Map + WavyIce)
; Version 0.2
; by snarfblam

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


; -----------------------------------------
; Declarations
; -----------------------------------------

; Existing vars (names generally taken from M1 disassembly)
PasswordBytes       := $6988        ; un-encoded password data
Joy1Change          := $12          ; Button newly pressed on this frame
Joy2Change          := $13          ;
Joy1Status          := $14          ; Buttons held this frame
Joy2Status          := $15          ;
TitleRoutine        := $1F          ; Identifies which "mode" title screen is in (title screen uses a state machine)
Timer1              := $2A          ; Timer. Decremented every frame if > 0.
Timer2              := $2B          ; Timer. Decremented every frame if > 0.
Timer3              := $2C          ; Timer. Decremented every 10 frames if > 0.
GamePaused		        := $31
ScrollDir           := $49
MapPosY			          := $4F          ;Current y position on world map.
MapPosX			          := $50	         ;Current x position on world map.
InArea              := $74          ; The area the player is in.
ScrollY			          := $FC	         ;Y value loaded into scroll register. 
ScrollX			          := $FD	         ;X value loaded into scroll register.
PPU2000_Cache       := $FF          ; Zero-page variable that holds the value to be assigned to $2000
HealthLo            := $0106        ; Health low byte (1's place in upper nibble, tenths in lower nibble)
HealthHi            := $0107        ; Health High byte (full tanks in upper nibble, 10's place in lower nibble)
OAM_Y               := $0200
OAM_Tile            := $0201
OAM_Att             := $0202
OAM_X               := $0203
TankCount           := $6877        ; Number of energy tanks player has.
SamusGear           := $6878        ; Bit field specifying which of 8 items samus has
MissileCount        := $6879        ; Number of missiles player has.
MaxMissiles         := $687A        ; Maximum number of missiles player can carry
TriangleSFXFlag     := $0683        ; Flags which, when set, cause sound effects to play. Used to make sounds on new menus.

; Constants
PasswordDataSize    =  $12          ; Number of bytes is password data (see PasswordBytes)
Joy_Left    =   $02                 ; Controller buttons
Joy_Right   =   $01
Joy_Down    =   $04
Joy_Up      =   $08
MapLeft     =   $64                 ; Map position on screen
MapTop      =   $32
MapWidth    =   7                   ; Map size, in tiles
MapHeight   =   7
SamusBlipTile = $BF

; Existing routines
ScreenOn            := $C447
PreparePPUProcess_  := $C20E
HexToDec            := $E198
CalculatePassword   := $8C7A
InitializeStats     := $932B        ; Continue
InitializeGame      := $92D4        ; New Game
UpdateSparkleSprites := $87CF
ROMSwitch           := $C4EF
RESET               := $FFB0

; Map data and 
MapRAM      :=  $7900               ; Address of 
MapData     :=  $9400               ; Address of map data in bank $E

.if (<MapRam) != $00
    .error MapRAM must begin on a $100 byte boundary 
.endif


; -----------------------------------------
; ROM executed code
; -----------------------------------------

.include FileSaveLoad.asm
.include Map_ROM.asm
.include wavyIce.asm


; -----------------------------------------
; RAM executed code
; -----------------------------------------

; The code included below will be copied into RAM
; and run from there

.PATCH 0e:9800
.base $7D00
    
.include Map_RAM.asm
.include WavyIce_RAM.asm



    ; Free memory
    ; (This is old and crap. Ignore it)

    ; Title Bank
    ;   $BDCD - $BE76 - FileSaveLoad.asm
    ;   $945F - $955F - FileSaveLoad.asm
    ;   $B135 - $B1FF - FileScreenLayout.asm
    ;   $8668 -  ???? - FilescreenLayout.asm
    ;   $9960 - $9983 - free
    ;   $A961 - $ABFF - FileSaveLoad.asm
   