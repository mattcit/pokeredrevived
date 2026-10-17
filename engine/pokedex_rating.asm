DisplayDexRating:
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsSeen], a
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [hDexRatingNumMonsOwned], a
	;mc if num mons owned >= 40, give player the remaining starter pokemon
	; check if player owns 40 or more pokemon
	cp 40                     ; compare a (owned pokemon) with 40
	jr nc, .checkStarterReward ; jump if owned pokemon >= 40
.continueRating
	ld hl, DexRatingsTable
.findRating
	ld a, [hli]
	ld b, a
	ld a, [hDexRatingNumMonsOwned]
	cp b
	jr c, .foundRating
	inc hl
	inc hl
	jr .findRating
.foundRating
	ld a, [hli]
	ld h, [hl]
	ld l, a ; load text pointer into hl
	CheckAndResetEventA EVENT_HALL_OF_FAME_DEX_RATING
	jr nz, .hallOfFame
	push hl
	ld hl, PokedexRatingText_441cc
	call PrintText
	pop hl
	call PrintText
	callba PlayPokedexRatingSfx
	jp WaitForTextScrollButtonPress
.checkStarterReward:
	; check if starter reward has already been given
	CheckEvent EVENT_RECEIVED_DEX_STARTER_REWARD
	jr nz, .continueRating    ; if the reward has been given, skip to rating
	; display text before giving reward
	ld hl, StarterRewardText1
	call PrintText
	; give the player the remaining starter pokemon
	ld a, [wPlayerStarter] ; figure out the remaining starter pokemon
	cp STARTER1
	jr z, .Charmander
	cp STARTER2
	jr z, .Squirtle
	jr .Bulbasaur
.Charmander ; if player selected Charmander, Bulbasaur is the remaining starter
	ld a, HS_STARTER_BALL_3
	ld b, BULBASAUR
	jr .giveStarterReward
.Squirtle ; if player selected Squirtle, Charmander is the remaining starter
	ld a, HS_STARTER_BALL_1
	ld b, CHARMANDER
	jr .giveStarterReward
.Bulbasaur ; if player selected Bulbasaur, Squirtle is the remaining starter
	ld a, HS_STARTER_BALL_2
	ld b, SQUIRTLE
.giveStarterReward
	; give remaining starter pokemon
	push af ; push a to the stack before calling GivePokemon (it will write to a)
	ld c, 15
	call GivePokemon
	ret nc ; return if player cant take the pokemon
	pop af
	; hide the remaining pokeball
	ld [wMissableObjectIndex], a ; a contains the starter ball that should be hidden
	predef HideObject
	; set event constant to mark reward as given
	SetEvent EVENT_RECEIVED_DEX_STARTER_REWARD
	; display text after giving reward
	ld hl, StarterRewardText2
	call PrintText
	; after rewarding, continue to rate the pokedex as usual
	jr .continueRating

.hallOfFame
	ld de, wDexRatingNumMonsSeen
	ld a, [hDexRatingNumMonsSeen]
	ld [de], a
	inc de
	ld a, [hDexRatingNumMonsOwned]
	ld [de], a
	inc de
.copyRatingTextLoop
	ld a, [hli]
	cp "@"
	jr z, .doneCopying
	ld [de], a
	inc de
	jr .copyRatingTextLoop
.doneCopying
	ld [de], a
	ret

PokedexRatingText_441cc:
	TX_FAR _OaksLabText_441cc
	db "@"

DexRatingsTable:
	db 10
	dw PokedexRatingText_44201
	db 20
	dw PokedexRatingText_44206
	db 30
	dw PokedexRatingText_4420b
	db 40
	dw PokedexRatingText_44210
	db 50
	dw PokedexRatingText_44215
	db 60
	dw PokedexRatingText_4421a
	db 70
	dw PokedexRatingText_4421f
	db 80
	dw PokedexRatingText_44224
	db 90
	dw PokedexRatingText_44229
	db 100
	dw PokedexRatingText_4422e
	db 110
	dw PokedexRatingText_44233
	db 120
	dw PokedexRatingText_44238
	db 130
	dw PokedexRatingText_4423d
	db 140
	dw PokedexRatingText_44242
	db 150
	dw PokedexRatingText_44247
	db 152
	dw PokedexRatingText_4424c

PokedexRatingText_44201:
	TX_FAR _OaksLabText_44201
	db "@"

PokedexRatingText_44206:
	TX_FAR _OaksLabText_44206
	db "@"

PokedexRatingText_4420b:
	TX_FAR _OaksLabText_4420b
	db "@"

PokedexRatingText_44210:
	TX_FAR _OaksLabText_44210
	db "@"

PokedexRatingText_44215:
	TX_FAR _OaksLabText_44215
	db "@"

PokedexRatingText_4421a:
	TX_FAR _OaksLabText_4421a
	db "@"

PokedexRatingText_4421f:
	TX_FAR _OaksLabText_4421f
	db "@"

PokedexRatingText_44224:
	TX_FAR _OaksLabText_44224
	db "@"

PokedexRatingText_44229:
	TX_FAR _OaksLabText_44229
	db "@"

PokedexRatingText_4422e:
	TX_FAR _OaksLabText_4422e
	db "@"

PokedexRatingText_44233:
	TX_FAR _OaksLabText_44233
	db "@"

PokedexRatingText_44238:
	TX_FAR _OaksLabText_44238
	db "@"

PokedexRatingText_4423d:
	TX_FAR _OaksLabText_4423d
	db "@"

PokedexRatingText_44242:
	TX_FAR _OaksLabText_44242
	db "@"

PokedexRatingText_44247:
	TX_FAR _OaksLabText_44247
	db "@"

PokedexRatingText_4424c:
	TX_FAR _OaksLabText_4424c
	db "@"

StarterRewardText1:
	TX_FAR _OaksLabTextStarterRewardText1
	db "@"

StarterRewardText2:
	TX_FAR _OaksLabTextStarterRewardText2
	db "@"
