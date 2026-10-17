Route4Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route4TrainerHeader0
	ld de, Route4ScriptPointers
	ld a, [wRoute4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute4CurScript], a
	ret

Route4ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route4TextPointers:
	dw Route4Text1
	dw Route4Text2
	dw Route4Text3
	dw Route4Text4
	dw Route4Text5
	dw Route4Text6
	dw Route4Text7
	dw Route4Text8
	dw Route4Text9
	dw PickUpItemText
	dw PokeCenterSignText
	dw Route4Text12
	dw Route4Text13

Route4TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_0
	dw Route4BattleText1 ; TextBeforeBattle
	dw Route4AfterBattleText1 ; TextAfterBattle
	dw Route4EndBattleText1 ; TextEndBattle
	dw Route4EndBattleText1 ; TextEndBattle

Route4TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_1
	dw Route4BattleText2 ; TextBeforeBattle
	dw Route4AfterBattleText2 ; TextAfterBattle
	dw Route4EndBattleText2 ; TextEndBattle
	dw Route4EndBattleText2 ; TextEndBattle

Route4TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_2
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_2
	dw Route4BattleText3 ; TextBeforeBattle
	dw Route4AfterBattleText3 ; TextAfterBattle
	dw Route4EndBattleText3 ; TextEndBattle
	dw Route4EndBattleText3 ; TextEndBattle

Route4TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_3
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_3
	dw Route4BattleText4 ; TextBeforeBattle
	dw Route4AfterBattleText4 ; TextAfterBattle
	dw Route4EndBattleText4 ; TextEndBattle
	dw Route4EndBattleText4 ; TextEndBattle

Route4TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_4
	dw Route4BattleText5 ; TextBeforeBattle
	dw Route4AfterBattleText5 ; TextAfterBattle
	dw Route4EndBattleText5 ; TextEndBattle
	dw Route4EndBattleText5 ; TextEndBattle

Route4TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_5
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_5
	dw Route4BattleText6 ; TextBeforeBattle
	dw Route4AfterBattleText6 ; TextAfterBattle
	dw Route4EndBattleText6 ; TextEndBattle
	dw Route4EndBattleText6 ; TextEndBattle

Route4TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_6, 1
	dw Route4BattleText7 ; TextBeforeBattle
	dw Route4AfterBattleText7 ; TextAfterBattle
	dw Route4EndBattleText7 ; TextEndBattle
	dw Route4EndBattleText7 ; TextEndBattle

Route4TrainerHeader7:
	dbEventFlagBit EVENT_BEAT_ROUTE_4_TRAINER_7, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_4_TRAINER_7, 1
	dw Route4BattleText8 ; TextBeforeBattle
	dw Route4AfterBattleText8 ; TextAfterBattle
	dw Route4EndBattleText8 ; TextEndBattle
	dw Route4EndBattleText8 ; TextEndBattle

	db $ff

Route4Text1:
	TX_FAR _Route4Text1
	db "@"

Route4Text2:
	TX_ASM
	ld hl, Route4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route4Text3:
	TX_ASM
	ld hl, Route4TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route4Text4:
	TX_ASM
	ld hl, Route4TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route4Text5:
	TX_ASM
	ld hl, Route4TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route4Text6:
	TX_ASM
	ld hl, Route4TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route4Text7:
	TX_ASM
	ld hl, Route4TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route4Text8:
	TX_ASM
	ld hl, Route4TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route4Text9:
	TX_ASM
	ld hl, Route4TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route4BattleText1:
	TX_FAR _Route4BattleText1
	db "@"

Route4EndBattleText1:
	TX_FAR _Route4EndBattleText1
	db "@"

Route4AfterBattleText1:
	TX_FAR _Route4AfterBattleText1
	db "@"

Route4BattleText2:
	TX_FAR _Route4BattleText2
	db "@"

Route4EndBattleText2:
	TX_FAR _Route4EndBattleText2
	db "@"

Route4AfterBattleText2:
	TX_FAR _Route4AfterBattleText2
	db "@"

Route4BattleText3:
	TX_FAR _Route4BattleText3
	db "@"

Route4EndBattleText3:
	TX_FAR _Route4EndBattleText3
	db "@"

Route4AfterBattleText3:
	TX_FAR _Route4AfterBattleText3
	db "@"

Route4BattleText4:
	TX_FAR _Route4BattleText4
	db "@"

Route4EndBattleText4:
	TX_FAR _Route4EndBattleText4
	db "@"

Route4AfterBattleText4:
	TX_FAR _Route4AfterBattleText4
	db "@"

Route4BattleText5:
	TX_FAR _Route4BattleText5
	db "@"

Route4EndBattleText5:
	TX_FAR _Route4EndBattleText5
	db "@"

Route4AfterBattleText5:
	TX_FAR _Route4AfterBattleText5
	db "@"

Route4BattleText6:
	TX_FAR _Route4BattleText6
	db "@"

Route4EndBattleText6:
	TX_FAR _Route4EndBattleText6
	db "@"

Route4AfterBattleText6:
	TX_FAR _Route4AfterBattleText6
	db "@"

Route4BattleText7:
	TX_FAR _Route4BattleText7
	db "@"

Route4EndBattleText7:
	TX_FAR _Route4EndBattleText7
	db "@"

Route4AfterBattleText7:
	TX_FAR _Route4AfterBattleText7
	db "@"

Route4BattleText8:
	TX_FAR _Route4BattleText8
	db "@"

Route4EndBattleText8:
	TX_FAR _Route4EndBattleText8
	db "@"

Route4AfterBattleText8:
	TX_FAR _Route4AfterBattleText8
	db "@"

Route4Text12:
	TX_FAR _Route4Text12
	db "@"

Route4Text13:
	TX_FAR _Route4Text13
	db "@"
