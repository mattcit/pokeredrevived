RedsHouse1FScript:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse1FScriptPointers
	ld a, [wRedsHouse1CurScript]
	jp CallFunctionInTable

RedsHouse1FScriptPointers:
	dw RedsHouse1FScript0
	dw RedsHouse1FScript1

RedsHouse1FScript0:
	xor a
	ld [hJoyHeld], a
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, 3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, 1
	ld [wRedsHouse1CurScript], a
	ret

RedsHouse1FScript1:
	ret

RedsHouse1FTextPointers:
	dw RedsHouse1FText1
	dw RedsHouse1FText2
	dw RedsHouse1FText3

RedsHouse1FText1: ; Mom
	TX_ASM
	ld a, [wd72e]
	bit 3, a
	jr nz, .heal ; if player has received a Pokémon from Oak, heal team
	ld hl, MomWakeUpText
	call PrintText
	jr .done
.heal
	call MomHealPokemon
.done
	jp TextScriptEnd

MomWakeUpText:
	TX_FAR _MomWakeUpText
	db "@"

MomHealPokemon:
	ld hl, MomHealText1
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, MomHealText2
	jp PrintText

MomHealText1:
	TX_FAR _MomHealText1
	db "@"
MomHealText2:
	TX_FAR _MomHealText2
	db "@"

RedsHouse1FText2: ; TV
	TX_ASM
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ld hl, TVWrongSideText
	jr nz, .notUp
	ld hl, StandByMeText
.notUp
	call PrintText
	jp TextScriptEnd

StandByMeText:
	TX_FAR _StandByMeText
	db "@"

TVWrongSideText:
	TX_FAR _TVWrongSideText
	db "@"

RedsHouse1FText3:
	TX_FAR _MomRunningShoesText
	db "@"