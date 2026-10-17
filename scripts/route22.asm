Route22Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route22ScriptPointers
	ld a, [wRoute22CurScript]
	jp CallFunctionInTable

Route22ScriptPointers:
	dw Route22Script0
	dw Route22Script1
	dw Route22Script2
	dw Route22Script3
	dw Route22Script4
	dw Route22Script5
	dw Route22Script6
	dw Route22Script7

Route22Script_50ece:
	xor a
	ld [wJoyIgnore], a
	ld [wRoute22CurScript], a
Route22Script7:
	ret

Route22Script_50ed6:
	ld a, [wRivalStarter]
	ld b, a
.asm_50eda
	ld a, [hli]
	cp b
	jr z, .asm_50ee1
	inc hl
	jr .asm_50eda
.asm_50ee1
	ld a, [hl]
	ld [wTrainerNo], a
	ret

Route22MoveRivalSprite:
	ld de, Route22RivalMovementData
	ld a, [wcf0d]
	cp $1
	jr z, .asm_50ef1
	inc de
.asm_50ef1
	call MoveSprite
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	jp SetSpriteFacingDirectionAndDelay

Route22RivalMovementData:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db $FF

Route22Script0:
	;mc make sure to hide the rival if the 'rival wants battle' event is reset
	;	we need to do this because we made it so that the first rival can't be rematched
	CheckEvent EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	jr nz, .rivalWantsBattle
	; hide rival then return as usual
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ret
.rivalWantsBattle
	ld hl, .Route22RivalBattleCoords
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wcf0d], a
	xor a
	ld [hJoyHeld], a
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	CheckEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	jr nz, .firstRivalBattle
	CheckEventReuseA EVENT_2ND_ROUTE22_RIVAL_BATTLE ; is this the rival at the end of the game?
	jp nz, Route22Script_5104e
	ret

.Route22RivalBattleCoords
	db $04, $1D
	db $05, $1D
	db $FF

.firstRivalBattle
;mc reset the events for triggering the first route 22 rival battle before the fight
;	so the player can't rematch and potentially see multiple dynamic rival parties
	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE
;joenote - play the rival music here so it begins when the rival appears
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .asm_50f4e
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
.asm_50f4e
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;wispnote - Show rival's sprite before executing the event's routine.
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef ShowObject2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $1
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, $1
	ld [H_SPRITEINDEX], a
	call Route22MoveRivalSprite
	ld a, $1
	ld [wRoute22CurScript], a
	ret

Route22Script1:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_50f78
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	jr .asm_50f7a
.asm_50f78
	ld a, SPRITE_FACING_RIGHT
.asm_50f7a
	ld [hSpriteFacingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	call SetSpriteFacingDirectionAndDelay
	xor a
	ld [wJoyIgnore], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, Route22RivalDefeatedText1
	ld de, Route22Text_511bc
	call SaveEndBattleTextPointers
	ld a, OPP_SONY1
	ld [wCurOpponent], a
	;mc make the first route 22 rival fight dynamic by having different parties
	;	based on the how many pokemon are in the player's party
	;	also, make it so the player can't rematch--otherwise they may notice that
	;	the rival's team will fluctuate a lot depending on the player's party size
	;
	; how to decide which one of OPP_SONY1’s parties to use:
	;	- For each starter there are 6 different parties the rival can use
	;		- If the player has one mon, they battle the first party--2 mons, 2nd party etc.
	;	- The dynamic parties are at the end of OPP_SONY1’s party list, so we need to skip
	;		the first 9 parties (that's why the "base" offset below is 9)
	;	- First we figure out the offset based on which starter the rival has
	;		- The first 6 parties are for STARTER2 (Squirtle), so for STARTER2 there's no offset
	;		- The next 6 are for STARTER3 so that offset needs to be 6
	;		- The last 6 are for STARTER1 so that offset needs to be 12
	;	- Then we add an offset that is the number of pokemon in the players party (1-6)
	;	- Adding all those together, we get a number between 10-27 which represents on of the
	;		18 dynamic parties for the first route 22 rival battle

	; 1) store party-size (1–6) in B
	ld 	a, [wPartyCount]
	ld 	b, a

	; 2) determine starter-group offset and store in C
	;	STARTER2 = +0, STARTER3 = +6, STARTER1 = +12
	ld 	a, [wRivalStarter]
	cp 	STARTER2
	jr 	z, .Offset0
	cp 	STARTER3
	jr 	z, .Offset6
	; else it must be STARTER1:
	ld 	c, 12
	jr 	.HaveOffset
 .Offset0:
	ld 	c, 0
	jr 	.HaveOffset
 .Offset6:
	ld 	c, 6
 .HaveOffset:
	; 3) now build your final index: Base(9) + StarterOffset(C) + PartySize(B)
	ld 	a, 9			; skip the first nine parties for OPP_SONY1
	add  a, c			; add (0, 6 or 12) for which starter
	add  a, b			; add number of pokemon in party (1–6)

	ld 	[wTrainerNo], a	; A is now 10–27 and is one of the OPP_SONY1 dynamic parties
	ld 	a, $2
	ld 	[wRoute22CurScript], a
	ret




;mc remove the old first rival battle "party -> starter" pointers

Route22Script2:
	ld a, [wIsInBattle]
	cp $ff
	jp z, Route22Script_50ece
	ld a, [wSpriteStateData1 + 9]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .notDown
	ld a, SPRITE_FACING_UP
	jr .done
.notDown
	ld a, SPRITE_FACING_RIGHT
.done
	ld [hSpriteFacingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $f0
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	;mc remove joe's custom events for beating route 22 rival
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateStart
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_50fff
	call Route22Script_51008
	jr .asm_51002
.asm_50fff
	call Route22Script_5100d
.asm_51002
	ld a, $3
	ld [wRoute22CurScript], a
	ret

Route22Script_51008:
	ld de, Route22RivalExitMovementData1
	jr Route22MoveRival1

Route22Script_5100d:
	ld de, Route22RivalExitMovementData2
Route22MoveRival1:
	ld a, $1
	ld [H_SPRITEINDEX], a
	jp MoveSprite

Route22RivalExitMovementData1:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

Route22RivalExitMovementData2:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_DOWN
	db $FF

Route22Script3:
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, $0
	ld [wRoute22CurScript], a
	ret

Route22Script_5104e:
;joenote - play music here so it starts when the rival appears
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .skipYVisibilityTesta
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
.skipYVisibilityTesta
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateTempo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;wispnote - Show rival's sprite before executing the event's routine.
	ld a, HS_ROUTE_22_RIVAL_2
	ld [wMissableObjectIndex], a
	predef ShowObject2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $2
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, $2
	ld [H_SPRITEINDEX], a
	call Route22MoveRivalSprite
	ld a, $4
	ld [wRoute22CurScript], a
	ret

Route22Script4:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $2
	ld [H_SPRITEINDEX], a
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_510a1
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	jr .asm_510a8
.asm_510a1
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_RIGHT
.asm_510a8
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	xor a
	ld [wJoyIgnore], a
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, Route22RivalDefeatedText2
	ld de, Route22Text_511d0
	call SaveEndBattleTextPointers
	ld a, OPP_SONY2
	ld [wCurOpponent], a
	ld hl, StarterMons_510d9
	call Route22Script_50ed6
	ld a, $5
	ld [wRoute22CurScript], a
	ret

StarterMons_510d9:
	db STARTER2,$0a
	db STARTER3,$0b
	db STARTER1,$0c

Route22Script5:
	ld a, [wIsInBattle]
	cp $ff
	jp z, Route22Script_50ece
	ld a, $2
	ld [H_SPRITEINDEX], a
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_510fb
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_UP
	jr .asm_51102
.asm_510fb
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, SPRITE_FACING_RIGHT
.asm_51102
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $f0
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wNewSoundID], a
	call PlaySound
	callba Music_RivalAlternateStartAndTempo
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_51134
	call Route22Script_5113d
	jr .asm_51137
.asm_51134
	call Route22Script_51142
.asm_51137
	ld a, $6
	ld [wRoute22CurScript], a
	ret

Route22Script_5113d:
	ld de, MovementData_5114c
	jr Route22MoveRival2

Route22Script_51142:
	ld de, MovementData_5114d
Route22MoveRival2:
	ld a, $2
	ld [H_SPRITEINDEX], a
	jp MoveSprite

MovementData_5114c:
	db NPC_MOVEMENT_LEFT

MovementData_5114d:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_LEFT
	db $FF

Route22Script6:
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, HS_ROUTE_22_RIVAL_2
	ld [wMissableObjectIndex], a
	predef HideObject
	call PlayDefaultMusic
	ResetEvents EVENT_2ND_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, $7
	ld [wRoute22CurScript], a
	ret

Route22TextPointers:
	dw Route22Text1
	dw Route22Text2
	dw Route22FrontGateText

Route22Text1:
	TX_ASM
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	jr z, .asm_5118b
	ld hl, Route22RivalAfterBattleText1
	call PrintText
	jr .asm_51191
.asm_5118b
	ld hl, Route22RivalBeforeBattleText1
	call PrintText
.asm_51191
	jp TextScriptEnd

Route22Text2:
	TX_ASM
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
	jr z, .asm_511a4
	ld hl, Route22RivalAfterBattleText2
	call PrintText
	jr .asm_511aa
.asm_511a4
	ld hl, Route22RivalBeforeBattleText2
	call PrintText
.asm_511aa
	jp TextScriptEnd

Route22RivalBeforeBattleText1:
	TX_FAR _Route22RivalBeforeBattleText1
	db "@"

Route22RivalAfterBattleText1:
	TX_FAR _Route22RivalAfterBattleText1
	db "@"

Route22RivalDefeatedText1:
	TX_FAR _Route22RivalDefeatedText1
	db "@"

Route22Text_511bc:
	TX_FAR _Route22Text_511bc
	db "@"

Route22RivalBeforeBattleText2:
	TX_FAR _Route22RivalBeforeBattleText2
	db "@"

Route22RivalAfterBattleText2:
	TX_FAR _Route22RivalAfterBattleText2
	db "@"

Route22RivalDefeatedText2:
	TX_FAR _Route22RivalDefeatedText2
	db "@"

Route22Text_511d0:
	TX_FAR _Route22Text_511d0
	db "@"

Route22FrontGateText:
	TX_FAR _Route22FrontGateText
	db "@"
