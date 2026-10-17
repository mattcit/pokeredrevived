CeladonMansion3Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion3TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText

ProgrammerText:
	TX_FAR _ProgrammerText
	db "@"

GraphicArtistText:
	TX_FAR _GraphicArtistText
	db "@"

WriterText:
	TX_FAR _WriterText
	db "@"

DirectorText:
	TX_ASM

	; check pokédex
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 150
	jr nc, .CompletedDex
	ld hl, .GameDesigner
	jr .done
.CompletedDex
	ld hl, .CompletedDexText
.done
	call PrintText
	jp TextScriptEnd

.GameDesigner
	TX_FAR _GameDesignerText
	db "@"

.CompletedDexText
	TX_FAR _CompletedDexText
	TX_BLINK
	TX_ASM
	callab DisplayDiploma
	SetEvent EVENT_90B	;joenote - set event that diploma has been attained
	;mc give Mew as a reward for completing the pokedex
	CheckEvent EVENT_GIVEN_MEW_REWARD
	jr nz, .noMewReward
	; check if they have defeated the elite four first before giving Mew
	CheckEvent EVENT_DEFEATED_ELITE_FOUR
	jr z, .noMewReward
	ld hl, MewRewardText
	call PrintText
	lb bc, MEW, 40
	call GivePokemon
	SetEvent EVENT_GIVEN_MEW_REWARD
.noMewReward
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

GameFreakPCText1:
	TX_FAR _CeladonMansion3Text5
	db "@"

GameFreakPCText2:
	TX_FAR _CeladonMansion3Text6
	db "@"

GameFreakPCText3:
	TX_FAR _CeladonMansion3Text7
	db "@"

GameFreakSignText:
	TX_FAR _CeladonMansion3Text8
	db "@"

MewRewardText:
	TX_FAR _CompletedDexText2
	db "@"
