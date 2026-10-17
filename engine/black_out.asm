ResetStatusAndHalveMoneyOnBlackout::
; Reset player status on blackout.
	xor a
	ld [wBattleResult], a
	ld [wWalkBikeSurfState], a
	ld [wIsInBattle], a
	ld [wMapPalOffset], a
	ld [wNPCMovementScriptFunctionNum], a
	ld [hJoyHeld], a
	ld [wNPCMovementScriptPointerTableNum], a
	ld [wFlags_0xcd60], a

	ld [hMoney], a
	ld [hMoney + 1], a
	ld [hMoney + 2], a
	call HasEnoughMoney
	jr c, .lostmoney ; never happens

	;mc player only loses 5% of their money instead of half
	; Calculate 5% of the player's money
	ld a, [wPlayerMoney]
	ld [hMoney], a
	ld a, [wPlayerMoney + 1]
	ld [hMoney + 1], a
	ld a, [wPlayerMoney + 2]
	ld [hMoney + 2], a
	xor a
	ld [hDivideBCDDivisor], a
	ld [hDivideBCDDivisor + 1], a
	ld a, $20
	ld [hDivideBCDDivisor + 2], a
	predef DivideBCDPredef3
	
	; Store the 5% amount in hMoney
	ld a, [hDivideBCDQuotient]
	ld [hMoney], a
	ld a, [hDivideBCDQuotient + 1]
	ld [hMoney + 1], a
	ld a, [hDivideBCDQuotient + 2]
	ld [hMoney + 2], a
	
	; Subtract the 5% from the player's money
	ld de, wPlayerMoney + 2
	ld hl, hMoney + 2
	ld c, 3
	predef SubBCDPredef

.lostmoney
	ld hl, wd732
	set 2, [hl]
	res 3, [hl]
	set 6, [hl]
	ld a, %11111111
	ld [wJoyIgnore], a
	predef_jump HealParty
