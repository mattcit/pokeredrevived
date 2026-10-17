;claude: Teleport/Roar/Whirlwind in trainer battles. Entered from SwitchAndTeleportEffect
;claude: (engine/battle/core.asm) via TeleportSwitchEntry; H_WHOSETURN says whose move it is.
;claude:   Teleport   -> the USER switches out; its side picks the replacement (the player from
;claude:                 the party menu, an enemy trainer with its normal AI pick)
;claude:   Roar       -> the TARGET "runs away scared"; the target's side picks the replacement
;claude:                 the same way, and the replacement skips the rest of the turn
;claude:   Whirlwind  -> the TARGET is "blown away" and replaced by a RANDOM other unfainted
;claude:                 mon, which skips the rest of the turn
;claude: Fails ("But, it failed!") if the mon that has to switch has no other unfainted mon in
;claude: its party, and in link battles (a mid-turn switch would need its own link data
;claude: exchange, which this doesn't do). Wild battles never get here: all three just end the
;claude: battle there. Priorities (Teleport low in trainer battles, Roar/Whirlwind high) are in
;claude: func_battle.asm. This lives in its own file/bank because bank $F (the battle core) is
;claude: full, so everything local to bank $F is reached with callab/jpab.
TeleportSwitchFailed:
	ld c, 50
	call DelayFrames
	jpab PrintButItFailedText_

TeleportSwitch:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, TeleportSwitchFailed
	call GetUsedMoveNum
	cp WHIRLWIND
	ld a, [H_WHOSETURN]
	jr z, .whirlwind
	ld b, a
	call GetUsedMoveNum
	cp TELEPORT
	ld a, b
	jr z, .userSideSwitches
	xor 1 ; Roar: the other side (the target's) is the one that switches
.userSideSwitches
	and a ; a = 0: the player's side switches, 1: the enemy's
	jp z, TeleportSwitchPlayer
	jp TeleportSwitchEnemy
.whirlwind
	and a
	jp z, ForcedSwitchEnemy ; the player used Whirlwind, so the enemy is the target
	; fall through: the enemy used Whirlwind, so the player is the target

ForcedSwitchPlayer:
	callab ReadPlayerMonCurHPAndStatus
	ld a, [wPartyCount]
	ld c, a
	ld hl, wPartyMon1HP
	call CountUnfaintedMons
	ld a, d
	cp 2 ; need at least one other mon besides the active one
	jp c, TeleportSwitchFailed
	call TeleportSwitchAnim
	ld a, [wPartyCount]
	ld c, a
	ld a, [wPlayerMonNumber]
	ld b, a
	ld hl, wPartyMon1HP
	call PickRandomOtherMon
	ld [wWhichPokemon], a
	ld a, $ff
	ld [wPlayerSelectedMove], a ; the replacement doesn't get the old mon's turn
	jpab SwitchPlayerMon

ForcedSwitchEnemy:
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP
	call CountUnfaintedMons
	ld a, d
	cp 2 ; need at least one other mon besides the active one
	jp c, TeleportSwitchFailed
	call TeleportSwitchAnim
	ld a, [wEnemyPartyCount]
	ld c, a
	ld a, [wEnemyMonPartyPos]
	ld b, a
	ld hl, wEnemyMon1HP
	call PickRandomOtherMon
	ld e, a
; SwitchEnemyMon picks the replacement with AISelectWhichMonSendOut, which takes the
; highest-scoring mon once bit 5 of wUnusedC000 is set. So make the random pick the only mon
; with a score, then put the score table and the flag back the way they were.
	ld a, [wUnusedC000]
	push af
	set 5, a
	ld [wUnusedC000], a
	ld hl, wAIPartyMonScores
	ld d, 4
.saveScores
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push bc
	dec d
	jr nz, .saveScores
	ld hl, wAIPartyMonScores
	xor a
	ld b, 6
.clearScores
	ld [hli], a
	dec b
	jr nz, .clearScores
	ld hl, wAIPartyMonScores
	ld d, 0
	add hl, de
	ld [hl], 1
	callab SwitchEnemyMon
	ld hl, wAIPartyMonScores + 8
	ld d, 4
.restoreScores
	pop bc
	dec hl
	ld a, b
	ld [hld], a
	ld a, c
	ld [hl], a
	dec d
	jr nz, .restoreScores
; put bit 5 back the way it was, but leave any other flag changes made by the switch alone
	pop af
	ld b, a
	ld a, [wUnusedC000]
	res 5, a
	bit 5, b
	jr z, .flagRestored
	set 5, a
.flagRestored
	ld [wUnusedC000], a
	ld a, $ff
	ld [wEnemySelectedMove], a ; the replacement doesn't get the old mon's turn
	ret

TeleportSwitchEnemy:
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP
	call CountUnfaintedMons
	ld a, d
	cp 2 ; need at least one other mon besides the one using Teleport
	jp c, TeleportSwitchFailed
	call TeleportSwitchAnim
	call RoarSkipEnemyTurn
	jpab SwitchEnemyMon

TeleportSwitchPlayer:
	callab ReadPlayerMonCurHPAndStatus
	ld a, [wPartyCount]
	ld c, a
	ld hl, wPartyMon1HP
	call CountUnfaintedMons
	ld a, d
	cp 2 ; need at least one other mon besides the one using Teleport
	jp c, TeleportSwitchFailed
	call TeleportSwitchAnim
	callab PrintEmptyString
	call SaveScreenTilesToBuffer1
	ld a, BATTLE_PARTY_MENU
	ld [wPartyMenuTypeOrMessageID], a
	call DisplayPartyMenu
.checkIfMonChosen
	jr nc, .monChosen
.goBackToPartyMenu
	call GoBackToPartyMenu
	jr .checkIfMonChosen
.monChosen
	ld a, [wPlayerMonNumber]
	ld d, a
	ld a, [wWhichPokemon]
	cp d ; is the chosen mon already out?
	jr nz, .notAlreadyOut
	ld hl, TeleportAlreadyOutText
	call PrintText
	jr .goBackToPartyMenu
.notAlreadyOut
	callab HasMonFainted
	jr z, .goBackToPartyMenu ; can't switch to a fainted mon
	call GBPalWhiteOut
	call ClearSprites
	callab LoadHudTilePatterns
	call LoadScreenTilesFromBuffer1
	call RunDefaultPaletteCommand
	call GBPalNormal
	call RoarSkipPlayerTurn
	jpab SwitchPlayerMon

; after a Roar the replacement mon doesn't get the scared-off mon's turn
RoarSkipPlayerTurn:
	call GetUsedMoveNum
	cp ROAR
	ret nz
	ld a, $ff
	ld [wPlayerSelectedMove], a
	ret

RoarSkipEnemyTurn:
	call GetUsedMoveNum
	cp ROAR
	ret nz
	ld a, $ff
	ld [wEnemySelectedMove], a
	ret

; returns a = the move the current user (per H_WHOSETURN) just used
GetUsedMoveNum:
	ld a, [H_WHOSETURN]
	and a
	ld a, [wPlayerMoveNum]
	ret z
	ld a, [wEnemyMoveNum]
	ret

; plays the used move's animation, then Roar's / Whirlwind's own message
TeleportSwitchAnim:
	xor a
	ld [wAnimationType], a
	call GetUsedMoveNum
	ld [wAnimationID], a
	callab PlayBattleAnimationGotID
	ld c, 20
	call DelayFrames
	call GetUsedMoveNum
	ld hl, RoarScaredText
	cp ROAR
	jr z, .printText
	ld hl, WhirlwindBlownAwayText
	cp WHIRLWIND
	ret nz
.printText
	jp PrintText

; counts unfainted mons in a party
; hl = HP of the first mon, c = number of mons
; returns d = number of unfainted mons
CountUnfaintedMons:
	ld d, 0
.loop
	ld a, [hli]
	or [hl]
	jr z, .fainted
	inc d
.fainted
	dec hl
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	ret

; picks a random unfainted mon other than the active one (the caller has already checked that
; one exists; not used in link battles, which need the shared battle RNG)
; hl = HP of the first mon, c = number of mons, b = party index of the active mon
; returns a = party index of the pick
PickRandomOtherMon:
.retry
	call Random
	and 7
	cp c
	jr nc, .retry ; not a valid party slot
	cp b
	jr z, .retry ; the active mon
	ld d, a
	push hl
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hli]
	or [hl]
	pop bc
	pop hl
	jr z, .retry ; fainted
	ld a, d
	ret

TeleportAlreadyOutText:
	TX_FAR _AlreadyOutText
	db "@"

RoarScaredText:
	TX_FAR _RanAwayScaredText
	db "@"

WhirlwindBlownAwayText:
	TX_FAR _WasBlownAwayText
	db "@"
