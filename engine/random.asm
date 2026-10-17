Random_::
; Generate a random 16-bit value.
;	ld a, [rDIV]
;	ld b, a
;	ld a, [hRandomAdd]
;	adc b
;	ld [hRandomAdd], a
;	ld a, [rDIV]
;	ld b, a
;	ld a, [hRandomSub]
;	sbc b
;	ld [hRandomSub], a
;	ret

;joenote - implementing Patrik Rak's Xor-Shift random number generator
;Found at https://gist.github.com/raxoft/2275716fea577b48f7f0
;Patrik Rak released this code into public domain.

; 8-bit Xor-Shift random number generator.
; Created by Patrik Rak in 2008 and revised in 2011/2012.
; See http://www.worldofspectrum.org/forums/showthread.php?t=23070

;Note about the hram locations and how they hold random values:
;hRandomAdd = x[n]
;hRandomLast = x[n-1]
;hRandomSub = x[n-2]
;hRandomLast+1 = x[n-3]
;This gives up to 4 random values to pick from so long as this function as been called at least 4 times.

	;load Seed[n] into bc
	ld hl, hRandomAdd + 1
	ld a, [hld]
	ld b, a
	ld a, [hl]
	ld c, a
	;load Seed[n-1] into de
	ld hl, hRandomLast + 1
	ld a, [hld]
	ld d, a
	ld a, [hli]
	ld e, a
	;Seed[n-1] = Seed[n] 
	ld a, b
	ld [hld], a
	ld a, c
	ld [hl], a
	
	ld  a,c         
    add a,a
    add a,a
    add a,a
    xor c
    ld  c,a
    ld  a,d         
    add a,a
    xor d
    ld  b,a
    rra             
    xor b
    xor c
    ld  b,e         
    ld  c,a    
	
	ld hl, hRandomAdd + 1
	ld a, b
	ld [hld], a
	ld a, c
	ld [hl], a
 	ret

	
;joenote - rolls 1d16-1	twice and keeps the higher result for each of the four DV values
;if boss music is playing, the minimum DVs are 8
;mc modified this routine to use different DVs based on difficulty level
; _Random_BiasDV
; Returns trainer DVs in D and E (each byte stores two stats).
; - Normal: non-boss DVs are random but clamped to 10; bosses fixed to 10s
; - Advanced: non-boss DVs are best-of-2 then clamped to 12; bosses fixed to 12s
; - Master: non-boss DVs are best-of-2 with minimum 8; bosses fixed to 15s
_Random_BiasDV::

	; First check difficulty early so Normal can use a simpler DV roll.
	ld a, [wDifficultyLevel]
	and a
	jr z, .normalDifficulty

	; ----------------------------
	; ADVANCED / MASTER:
	; best-of-2 roll per stat
	; ----------------------------

	call Random
	ld b, a
	and $F0
	ld h, a
	ld a, b
	and $0F
	ld l, a

	call Random
	ld b, a
	and $F0
	ld d, a
	ld a, b
	and $0F
	ld e, a

	call Random
	ld b, a
	and $F0
	cp h
	jr c, .next1
	ld h, a
.next1
	ld a, b
	and $0F
	cp l
	jr c, .next2
	ld l, a
.next2

	call Random
	ld b, a
	and $F0
	cp d
	jr c, .next3
	ld d, a
.next3
	ld a, b
	and $0F
	cp e
	jr c, .next4
	ld e, a
.next4

	; Combine into two DV bytes:
	; D = Atk/Def, E = Spd/Spc (each byte stores two stat DVs).
	ld a, h
	or l
	ld b, a

	ld a, d
	or e
	ld d, a
	ld e, b

	; Boss check: if boss, DVs are fixed by difficulty.
	call IsBossTrainer
	jr c, .bossDifficultyFixed

	; Not a boss: apply difficulty rules
	ld a, [wDifficultyLevel]
	cp DIFF_MASTER
	jr z, .masterNonBossMin8

	; Advanced non-boss: clamp to 12
	ld c, $0C            ; cap = 12
	ld a, d
	call .ClampDVByteToCap
	ld d, a
	ld a, e
	call .ClampDVByteToCap
	ld e, a
	ret

.masterNonBossMin8
	; Master non-boss: enforce minimum 6 (no cap)
	ld a, d
	or $66
	ld d, a
	ld a, e
	or $66
	ld e, a
	ret


; ----------------------------
; NORMAL (difficulty 0):
; random DVs clamped to 5 for non-boss
; bosses fixed to 7s
; ----------------------------
.normalDifficulty
	call IsBossTrainer
	jr c, .bossNormalFixed

	; Non-boss: random bytes then clamp each stat DV to 5.
	call Random
	ld d, a             ; Atk/Def candidate byte
	call Random
	ld e, a             ; Spd/Spc candidate byte

	ld c, $05           ; cap
	ld a, d
	call .ClampDVByteToCap
	ld d, a
	ld a, e
	call .ClampDVByteToCap
	ld e, a
	ret


; ----------------------------
; Boss fixed DV values
; ----------------------------

.bossNormalFixed
	; Normal bosses: all 7s
	ld de, $7777
	ret

.bossDifficultyFixed
	ld a, [wDifficultyLevel]
	cp DIFF_MASTER
	jr z, .bossMasterFixed

	; Advanced bosses: all 9s
	ld de, $9999
	ret

.bossMasterFixed
	; Master bosses: all 12s
	ld de, $CCCC
	ret


; ------------------------------------------------------------
; .ClampDVByteToCap
; A = DV byte (two stats packed into one byte)
; C = cap (0..15)
; Returns clamped DV byte in A
; - If either stat DV is above cap, it becomes cap.
; ------------------------------------------------------------
.ClampDVByteToCap
	ld b, a              ; save original

	; Clamp high stat (upper half of the byte)
	and $F0              ; A = high stat * 16
	ld h, a              ; H = high part
	ld a, c
	swap a               ; A = cap * 16  (cap moved into upper half)
	and $F0              ; ensure low half is 0
	cp h
	jr nc, .highOk
	ld h, a              ; H = cap * 16
.highOk

	; Clamp low stat (lower half of the byte)
	ld a, b
	and $0F              ; A = low stat (0..15)
	cp c
	jr c, .lowOk
	ld a, c              ; A = cap
.lowOk

	; Recombine high + low
	or h
	ret
	
_Random_DV::	;generates four 0 to 15 DVs in DE, and rerolls 1 time for each DV below the value placed in L
	ld l, 0
	
	;mc remove joe's hard mode DV adjustment
	call Random
	ld d, a
	call Random
	ld e, a
	
	ld a, l
	and a
	ret z
	
	ld bc, $FFFF
	
	;check atk dv
	ld a, d
	swap a
	and $F
	cp l
	jr nc, .atkdone
	ld a, $0F
	and b
	ld b, a
.atkdone
	
	;check def dv
	ld a, d
	and $F
	cp l
	jr nc, .defdone
	ld a, $F0
	and b
	ld b, a
.defdone

	;check spd dv
	ld a, e
	swap a
	and $F
	cp l
	jr nc, .spddone
	ld a, $0F
	and c
	ld c, a
.spddone
	
	;check spe dv
	ld a, e
	and $F
	cp l
	jr nc, .spedone
	ld a, $F0
	and c
	ld c, a
.spedone

	;mask out DVs less than L
	ld a, d
	and b
	ld d, a
	ld a, e
	and c
	ld e, a
	
	;invert the mask
	ld a, b
	xor $FF
	ld b, a
	ld a, c
	xor $FF
	ld c, a
	
	;Get replacement DVs
	call Random
	and b
	or d
	ld d, a
	call Random
	and c
	or e
	ld e, a
	
	ret

	
RNG_Correction::
	ld hl, $DEF0
	ld d, 4
.seedloop
	ld a, [hli]
	ld b, a
	push bc
	dec d
	jr nz, .seedloop
	ld d, 4
	xor a
.seedloop2
	pop bc
	or b
	dec d
	jr nz, .seedloop2
	cp $01
	ret nz
	
	ld hl, $DEF0
	
	ld a, [rDIV]
	ld b, a
	ld a, [hl]
	adc b
	call z, .inc_a
	ld [hRandomAdd], a
	ld [hli], a
	
	ld a, [rDIV]
	ld b, a
	ld a, [hl]
	sbc b
	call z, .inc_a
	ld [hRandomSub], a
	ld [hli], a

	ld a, [rDIV]
	ld b, a
	ld a, [hRandomAdd]
	adc b
	call z, .inc_a
	ld [hRandomLast], a
	ld [hli], a

	ld a, [rDIV]
	ld b, a
	ld a, [hRandomSub]
	sbc b
	call z, .inc_a
	ld [hRandomLast+1], a
	ld [hli], a
	ret	
.inc_a
	inc a
	ret
	
	
	
	
	
	
