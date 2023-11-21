WavyIce_NewBehavior:	; 0x399

	lda SamusGear	; Check equipment
	and #$40	; Has wave?
	beq NoWave
	jmp $D52C	; Yes - UpdateWaveBullet
	; (normally UpdateWaveBullet isn't called when you have ice, even if you do have wave)

NoWave:
	jmp $D4EB	; No - UpdateBullet

WavyIce_NewDamage:
; Y: Weapon type
;   1 = Normal
;   2 = Wave
;   3 = Ice or Wavy-ice
;   A = Bomb
;   B = Missile (I think)
; X: Enemy index
; 40B,X: enemy health

	ldy $040E,X	; Get projectile that hit enemy
	lda $6878	; Get current equipment

	cpy #$03	; If Ice...
	bne NotIce

Ice:
	and #$C0	; Does the player have wave and ice beams?
	bne Damage4	; If so, 4 damage
	beq Damage2	; Else, 2 damage

NotIce:
; Includes vanilla-beam, bomb, wave, and missile
	cpy #$0A	; Bomb = 2 Damage (was 4 Damage in original wavy ice, but this is a bit much)
	beq Damage2
	cpy #$02	; Wave = 2 Damage
	beq Damage2

	bit $0A		; Not-a-boss = 1 Damage
	bvc Damage1

IsABoss:
	cpy #$0B	; Vanilla-beam = 1 damage
	bne Damage1	; (missile will fall thru and do 4 damage)

Damage4:
	dec $040B,X
	beq exitRoutine
Damage3:
	dec $040B,X
	beq exitRoutine
Damage2:
	dec $040B,X
	beq exitRoutine
Damage1:
	dec $040B,X

exitRoutine:
; Return to F60F (this is the code that checks if enemies has
; 0 HP and if so, kills him)
	jmp $F60F	
	
endOfRAMCode:
;.if endOfRAMCode > $7F00
	;.error Too much code in RAMp9\
;.endif
	
