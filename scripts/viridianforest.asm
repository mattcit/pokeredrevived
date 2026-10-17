ViridianForestScript:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianForestTrainerHeader0
	ld de, ViridianForestScriptPointers
	ld a, [wViridianForestCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianForestCurScript], a
	ret

ViridianForestScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

ViridianForestTextPointers:
	dw ViridianForestText1
	dw ViridianForestText2
	dw ViridianForestText3
	dw ViridianForestText4
	dw ViridianForestText5
	dw ViridianForestText6
	dw ViridianForestText7
	dw ViridianForestText8
	dw ViridianForestText9
	dw ViridianForestText10
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw ViridianForestText14
	dw ViridianForestText15
	dw ViridianForestText16
	dw ViridianForestText17
	dw ViridianForestText18
	dw ViridianForestText19
	dw ViridianForestText20
	dw ViridianForestText21

ViridianForestTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_0
	dw ViridianForestBattleText1 ; TextBeforeBattle
	dw ViridianForestAfterBattleText1 ; TextAfterBattle
	dw ViridianForestEndBattleText1 ; TextEndBattle
	dw ViridianForestEndBattleText1 ; TextEndBattle

ViridianForestTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_1
	dw ViridianForestBattleText2 ; TextBeforeBattle
	dw ViridianForestAfterBattleText2 ; TextAfterBattle
	dw ViridianForestEndBattleText2 ; TextEndBattle
	dw ViridianForestEndBattleText2 ; TextEndBattle

ViridianForestTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_2
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_2
	dw ViridianForestBattleText3 ; TextBeforeBattle
	dw ViridianForestAfterBattleText3 ; TextAfterBattle
	dw ViridianForestEndBattleText3 ; TextEndBattle
	dw ViridianForestEndBattleText3 ; TextEndBattle

ViridianForestTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_3
	dw ViridianForestBattleText4 ; TextBeforeBattle
	dw ViridianForestAfterBattleText4 ; TextAfterBattle
	dw ViridianForestEndBattleText4 ; TextEndBattle
	dw ViridianForestEndBattleText4 ; TextEndBattle

ViridianForestTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_4
	dw ViridianForestBattleText5 ; TextBeforeBattle
	dw ViridianForestAfterBattleText5 ; TextAfterBattle
	dw ViridianForestEndBattleText5 ; TextEndBattle
	dw ViridianForestEndBattleText5 ; TextEndBattle

ViridianForestTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_5
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_5
	dw ViridianForestBattleText6 ; TextBeforeBattle
	dw ViridianForestAfterBattleText6 ; TextAfterBattle
	dw ViridianForestEndBattleText6 ; TextEndBattle
	dw ViridianForestEndBattleText6 ; TextEndBattle

ViridianForestTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_6
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_6
	dw ViridianForestBattleText7 ; TextBeforeBattle
	dw ViridianForestAfterBattleText7 ; TextAfterBattle
	dw ViridianForestEndBattleText7 ; TextEndBattle
	dw ViridianForestEndBattleText7 ; TextEndBattle

ViridianForestTrainerHeader7:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_7, 1
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_7, 1
	dw ViridianForestBattleText8 ; TextBeforeBattle
	dw ViridianForestAfterBattleText8 ; TextAfterBattle
	dw ViridianForestEndBattleText8 ; TextEndBattle
	dw ViridianForestEndBattleText8 ; TextEndBattle

ViridianForestTrainerHeader8:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_8, 1
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_8, 1
	dw ViridianForestBattleText9 ; TextBeforeBattle
	dw ViridianForestAfterBattleText9 ; TextAfterBattle
	dw ViridianForestEndBattleText9 ; TextEndBattle
	dw ViridianForestEndBattleText9 ; TextEndBattle

ViridianForestTrainerHeader9:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_9, 1
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_9, 1
	dw ViridianForestBattleText10 ; TextBeforeBattle
	dw ViridianForestAfterBattleText10 ; TextAfterBattle
	dw ViridianForestEndBattleText10 ; TextEndBattle
	dw ViridianForestEndBattleText10 ; TextEndBattle

	db $ff

ViridianForestText1:
	TX_ASM
	ld hl, ViridianForestTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText2:
	TX_ASM
	ld hl, ViridianForestTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText3:
	TX_ASM
	ld hl, ViridianForestTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText4:
	TX_ASM
	ld hl, ViridianForestTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText5:
	TX_ASM
	ld hl, ViridianForestTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText6:
	TX_ASM
	ld hl, ViridianForestTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText7:
	TX_ASM
	ld hl, ViridianForestTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText8:
	TX_ASM
	ld hl, ViridianForestTrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText9:
	TX_ASM
	ld hl, ViridianForestTrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText10:
	TX_ASM
	ld hl, ViridianForestTrainerHeader9
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestBattleText1:
	TX_FAR _ViridianForestBattleText1
	db "@"

ViridianForestEndBattleText1:
	TX_FAR _ViridianForestEndBattleText1
	db "@"

ViridianForestAfterBattleText1:
	TX_FAR _ViridianFrstAfterBattleText1
	db "@"

ViridianForestBattleText2:
	TX_FAR _ViridianForestBattleText2
	db "@"

ViridianForestEndBattleText2:
	TX_FAR _ViridianForestEndBattleText2
	db "@"

ViridianForestAfterBattleText2:
	TX_FAR _ViridianFrstAfterBattleText2
	db "@"

ViridianForestBattleText3:
	TX_FAR _ViridianForestBattleText3
	db "@"

ViridianForestEndBattleText3:
	TX_FAR _ViridianForestEndBattleText3
	db "@"

ViridianForestAfterBattleText3:
	TX_FAR _ViridianFrstAfterBattleText3
	db "@"

ViridianForestBattleText4:
	TX_FAR _ViridianForestBattleText4
	db "@"

ViridianForestEndBattleText4:
	TX_FAR _ViridianForestEndBattleText4
	db "@"

ViridianForestAfterBattleText4:
	TX_FAR _ViridianFrstAfterBattleText4
	db "@"

ViridianForestBattleText5:
	TX_FAR _ViridianForestBattleText5
	db "@"

ViridianForestEndBattleText5:
	TX_FAR _ViridianForestEndBattleText5
	db "@"

ViridianForestAfterBattleText5:
	TX_FAR _ViridianFrstAfterBattleText5
	db "@"

ViridianForestBattleText6:
	TX_FAR _ViridianForestBattleText6
	db "@"

ViridianForestEndBattleText6:
	TX_FAR _ViridianForestEndBattleText6
	db "@"

ViridianForestAfterBattleText6:
	TX_FAR _ViridianFrstAfterBattleText6
	db "@"

ViridianForestBattleText7:
	TX_FAR _ViridianForestBattleText7
	db "@"

ViridianForestEndBattleText7:
	TX_FAR _ViridianForestEndBattleText7
	db "@"

ViridianForestAfterBattleText7:
	TX_FAR _ViridianFrstAfterBattleText7
	db "@"

ViridianForestBattleText8:
	TX_FAR _ViridianForestBattleText8
	db "@"

ViridianForestEndBattleText8:
	TX_FAR _ViridianForestEndBattleText8
	db "@"

ViridianForestAfterBattleText8:
	TX_FAR _ViridianFrstAfterBattleText8
	db "@"

ViridianForestBattleText9:
	TX_FAR _ViridianForestBattleText9
	db "@"

ViridianForestEndBattleText9:
	TX_FAR _ViridianForestEndBattleText9
	db "@"

ViridianForestAfterBattleText9:
	TX_FAR _ViridianFrstAfterBattleText9
	db "@"

ViridianForestBattleText10:
	TX_FAR _ViridianForestBattleText10
	db "@"

ViridianForestEndBattleText10:
	TX_FAR _ViridianForestEndBattleText10
	db "@"

ViridianForestAfterBattleText10:
	TX_FAR _ViridianFrtAfterBattleText10
	db "@"

ViridianForestText14:
	TX_FAR _ViridianForestText14
	db "@"

ViridianForestText15:
	TX_FAR _ViridianForestText15
	db "@"

ViridianForestText16:
	TX_FAR _ViridianForestText16
	db "@"

ViridianForestText17:
	TX_FAR _ViridianForestText17
	db "@"

ViridianForestText18:
	TX_FAR _ViridianForestText18
	db "@"

ViridianForestText19:
	TX_FAR _ViridianForestText19
	db "@"

ViridianForestText20:
	TX_FAR _ViridianForestText20
	db "@"

ViridianForestText21:
	TX_FAR _ViridianForestText21
	db "@"
