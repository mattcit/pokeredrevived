InitPlayerData:
InitPlayerData2:

	;call Random
	;ld a, [hRandomSub]
	;ld [wPlayerID], a

	;call Random
	;ld a, [hRandomAdd]
	;ld [wPlayerID + 1], a

	;joenote - changing this to be more optimal
	call Random
	ld [wPlayerID], a
	call Random
	ld [wPlayerID+1], a
	
	ld a, $ff
	ld [wUnusedD71B], a

	ld hl, wPartyCount
	call InitializeEmptyList
	ld hl, wNumInBox
	call InitializeEmptyList
	ld hl, wNumBagItems
	call InitializeEmptyList
	ld hl, wNumBoxItems
	call InitializeEmptyList

START_MONEY EQU $3000
	ld hl, wPlayerMoney + 1
	ld a, START_MONEY / $100
	ld [hld], a
	xor a
	ld [hli], a
	inc hl
	ld [hl], a

	ld [wMonDataLocation], a

	ld hl, wObtainedBadges
	ld [hli], a

	ld [hl], a

	ld hl, wPlayerCoins
	ld [hli], a
	ld [hl], a

	ld hl, wGameProgressFlags
	ld bc, wGameProgressFlagsEnd - wGameProgressFlags
	call FillMemory ; clear all game progress flags

	;;;;;;;;;;
	; TESTING
	;;;;;;;;;;
	; skip oak speech (enable debug mode)
	ld hl, wd732
	set 1, [hl]

	; debug items
	lb bc, CHANGE_DIFF, 1
	call GiveItem
	lb bc, DBG_STATXP, 1
	call GiveItem
	lb bc, TM_29, 1 ; PSYCHIC_M
	call GiveItem

;	lb bc, CLEFABLE, 5
;	call GivePokemon
;	lb bc, TM_08, 1 ; BODY SLAM
;	call GiveItem
;	lb bc, TM_13, 1 ; ICE BEAM
;	call GiveItem
;	lb bc, TM_24, 1 ; THUNDERBOLT
;	call GiveItem
;	lb bc, TM_29, 1 ; PSYCHIC
;	call GiveItem
;	lb bc, MAX_ELIXER, 99
;	call GiveItem
;	lb bc, FULL_RESTORE, 99
;	call GiveItem
;	lb bc, FULL_RESTORE, 99
;	call GiveItem
;	lb bc, FULL_RESTORE, 99
;	call GiveItem
;	lb bc, FULL_RESTORE, 99
;	call GiveItem

	lb bc, TM_39, 1 ; swift
	call GiveItem

	lb bc, PIDGEOTTO, 50
	call GivePokemon
	lb bc, MEW, 50
	call GivePokemon

; Set DVs: Atk=5, Def=4, Spd=5, Spc=4 (HP DV = 10)
; Byte 1: (Atk<<4)|Def = $54, Byte 2: (Spd<<4)|Spc = $54
;	ld a, $54
;	ld [wPartyMon1DVs], a
;	ld [wPartyMon1DVs + 1], a

; Sets all 5 stat exp values for party slot 1
; Uses DE as the value (MSB=D, LSB=E)
; Clobbers: a, hl
	ld de, 12500          ; stat exp value

	ld hl, wPartyMon1HPExp

	; HP
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a

	; Attack
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a

	; Defense
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a

	; Speed
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a

	; Special
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a

	; Recalculate stats
	ld hl, wPartyMon1HPExp - 1  ; must be one byte before HPExp (CalcStat calling convention)
	ld de, wPartyMon1Stats       ; CalcStats writes computed stats here (MaxHP, Atk, Def, Spd, Spc)
	ld b, $1	;make CalcStats take statExp into account
	call CalcStats

;	lb bc, AERODACTYL, 99
;	call GivePokemon
	lb bc, HM_02, 1
	call GiveItem
	lb bc, RARE_CANDY, 99
	call GiveItem
;	lb bc, MASTER_BALL, 20
;	call GiveItem
	lb bc, BICYCLE, 1
	call GiveItem
;	lb bc, SILPH_SCOPE, 1
;	call GiveItem
;	lb bc, GOLD_TEETH, 1
;	call GiveItem
;	lb bc, GOLD_WATCH, 1
;	call GiveItem
;	ld hl, wObtainedBadges
;	set 0, [hl]
;	set 1, [hl]
;	set 2, [hl]
;	set 3, [hl]
;	set 4, [hl]
;	set 5, [hl]
;	set 6, [hl]
;	set 7, [hl]


;	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
;	SetEvent EVENT_FOLLOWED_OAK_INTO_LAB_2
;	SetEvent EVENT_OAK_ASKED_TO_CHOOSE_MON
;	SetEvent EVENT_GOT_STARTER
;	SetEvent EVENT_BATTLED_RIVAL_IN_OAKS_LAB
;	SetEvent EVENT_OAK_GOT_PARCEL
;	SetEvent EVENT_GOT_POKEDEX

;	SetEvent EVENT_BEAT_BROCK
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_0
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_1
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_2
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_3
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_4
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_5
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_6
;	SetEvent EVENT_BEAT_ROUTE_3_TRAINER_7


	; mc Set all Pokemon as owned AND seen
;	SetEvent EVENT_GOT_POKEDEX
;	ld hl, wPokedexOwned    ; HL -> owned flags
;	ld de, wPokedexSeen     ; DE -> seen flags
;	ld bc, 18               ; 18 full bytes = Pokemon 1–144
;.full_bytes_loop:
;	ld a, $FF               ; all 8 bits set (8 mons per byte)
;	ld [hl+], a             ; set owned byte, HL++
;	ld [de], a              ; set seen byte
;	inc de                  ; DE++
;	dec bc
;	ld a, b
;	or c
;	jr nz, .full_bytes_loop
;	; Now handle last byte: Pokemon 145–150 (6 bits), still excluding Mew
;	ld a, %00111111         ; bits 0–5 = mons 145–150
;	ld a, %01111111         ; bits 0–6 = mons 145–151 for Mew
;	ld [hl], a              ; last owned byte
;	ld [de], a              ; last seen byte


	;mc Set all towns to visited (allows you to FLY to any town)
	ld hl, wTownVisitedFlag		; Point HL to the start of wTownVisitedFlag (d70b)
	; Set all 8 bits in the first byte (for towns 1–8)
	ld a, $FF					; Set A to 0xFF (11111111)
	ld [hl], a					; Store it in the first byte of wTownVisitedFlag
	; Move to the second byte
	inc hl						; Increment HL to point to the second byte
	; Set only the first 5 bits in the second byte (for towns 9–13)
	ld a, %00011111				; Set A to 0x1F (00011111)
	ld [hl], a					; Store it in the second byte of wTownVisitedFlag

	;;;;;;;;;;

	jp InitializeMissableObjectsFlags

InitializeEmptyList:
	xor a ; count
	ld [hli], a
	dec a ; terminator
	ld [hl], a
	ret
