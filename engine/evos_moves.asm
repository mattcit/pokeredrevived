

; try to evolve the mon in [wWhichPokemon]
TryEvolvingMon:
	ld hl, wCanEvolveFlags
	xor a
	ld [hl], a
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	call Evolution_FlagAction

; this is only called after battle
; it is supposed to do level up evolutions, though there is a bug that allows item evolutions to occur *fixed this bug*
EvolutionAfterBattle:
	ld a, [hTilesetType]
	push af
	xor a
	ld [wEvolutionOccurred], a
	dec a
	ld [wWhichPokemon], a
	push hl
	push bc
	push de
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - We keep a pointer to the current PKMN's Level at the Beginning of the Battle.
	ld hl, wStartBattleLevels
	push hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, wPartyCount
	push hl

Evolution_PartyMonLoop: ; loop over party mons
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - We store current PKMN' Level at the Beginning of the Battle
; to a chosen memory address in order to be compaired later with the evolution requirements.
	pop de
	ld a, [de]
	ld [wTempCoins1], a
	inc de
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	inc hl
	ld a, [hl]
	cp $ff ; have we reached the end of the party?
	jp z, .done
	ld [wEvoOldSpecies], a
	push de; wispnote - If we are not done we need to push the pointer for the next iteration.
	push hl
	ld a, [wWhichPokemon]
	ld c, a
	ld hl, wCanEvolveFlags
	ld b, FLAG_TEST
	call Evolution_FlagAction
	ld a, c
	and a ; is the mon's bit set?
	jp z, Evolution_PartyMonLoop ; if not, go to the next mon
	ld a, [wEvoOldSpecies]
	dec a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wcf91]
	push af
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	pop af
	ld [wcf91], a
	pop hl

.evoEntryLoop ; loop over evolution entries
	ld a, [hli]
	and a ; have we reached the end of the evolution data?
	jr z, Evolution_PartyMonLoop
	ld b, a ; evolution type
	cp EV_TRADE
	jr z, .checkTradeEvo
; not trade evolution
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	jr z, Evolution_PartyMonLoop ; if trading, go the next mon
	ld a, b
	cp EV_ITEM
	jr z, .checkItemEvo
	ld a, [wForceEvolution]
	and a
	jr nz, Evolution_PartyMonLoop
	ld a, b
	cp EV_LEVEL
	jr z, .checkLevel
.checkTradeEvo
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	jp nz, .nextEvoEntry1 ; if not trading, go to the next evolution entry
	ld a, [hli] ; level requirement
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level greater than the evolution requirement?
	jp c, Evolution_PartyMonLoop ; if so, go the next mon
	jr .doEvolution
.checkItemEvo	;joenote - .checkItemEvo updated to match pokemon yellow. this prevents erroneos stone evolutions
	ld a, [wIsInBattle] ; are we in battle?
	and a
	ld a, [hli]
	jp nz, .nextEvoEntry1 ; don't evolve if we're in a battle as wcf91 could be holding the last mon sent out
	ld b, a ; evolution item
	ld a, [wcf91] ; *fixed above* this is supposed to be the last item used, but it is also used to hold species numbers
	cp b ; was the evolution item in this entry used?
	jp nz, .nextEvoEntry1 ; if not, go to the next evolution entry

;joenote - make it so a message is printed if the level requirement for an item evolution is not met
	push hl
	ld a, [wCurEnemyLVL]
	push af
	ld a, [hl] 	; level requirement
	ld [wCurEnemyLVL], a
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level less than the evolution requirement?
	jr nc, .skip_level_req_print
	ld hl, _NeededLevelText
	call PrintText
.skip_level_req_print
	pop af
	ld [wCurEnemyLVL], a
	pop hl

	.checkLevel
	ld a, [hli] ; level requirement
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level less than the evolution requirement?
	jp c, .nextEvoEntry2 ; if so, go the next evolution entry
.doEvolution	
	ld [wCurEnemyLVL], a
	ld a, 1
	ld [wEvolutionOccurred], a
;a has 'mon current level. b has 'mon evo level requirement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - fixing an oversigt where gaining multiple levels in battle then evolving can cause 
;			learning moves of the new evolution to be skipped.
			;need to store the evo level requirement somewhere.
	;wTempCoins1 was chosen because it's used only for slot machine and gets defaulted to 1 during the mini-game
; wispnote - We compare with PKMN's level at the Beginning of the Battle and keep the highest value.
	ld a, [wTempCoins1]
	cp b
	jp nc, .evoLevelRequirementSatisfied
	ld a, b
	ld [wTempCoins1], a
.evoLevelRequirementSatisfied
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	push hl
	ld a, [hl]
	ld [wEvoNewSpecies], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	call CopyStringToCF4B
	ld hl, IsEvolvingText
	call PrintText
	ld c, 50
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 0
	lb bc, 12, 20
	call ClearScreenArea
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call ClearSprites
	callab EvolveMon
	jp c, CancelledEvolution
	ld hl, EvolvedText
	call PrintText
	pop hl
	ld a, [hl]
	ld [wd0b5], a
	ld [wLoadedMonSpecies], a
	ld [wEvoNewSpecies], a
	ld a, MONSTER_NAME
	ld [wNameListType], a
	ld a, BANK(TrainerNames) ; bank is not used for monster names
	ld [wPredefBank], a
	call GetName
	push hl
	ld hl, IntoText
	call PrintText_NoCreatingTextBox
	ld a, SFX_GET_ITEM_2
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld c, 40
	call DelayFrames
	call ClearScreen
	call RenameEvolvedMon
	ld a, [wd11e]
	push af
	ld a, [wd0b5]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld hl, BaseStats
	ld bc, MonBaseStatsEnd - MonBaseStats
	call AddNTimes
	ld de, wMonHeader
	call CopyData
	ld a, [wd0b5]
	ld [wMonHIndex], a
	pop af
	ld [wd11e], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	push bc
	ld bc, wPartyMon1MaxHP - wPartyMon1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wLoadedMonMaxHP + 1
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, wLoadedMonHP + 1
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	dec hl
	pop bc
	call CopyData
	ld a, [wd0b5]
	ld [wd11e], a
	xor a
	ld [wMonDataLocation], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;joenote - fixing skip move-learn on level-up evolution
	ld a, [wIsInBattle]
	and a
	jr z, .notinbattle
	push bc
	
	ld a, [wCurEnemyLVL]	; load the final level into a.
	ld c, a	; load the final level to over to c
	ld a, [wTempCoins1]	; load the evolution level into a
	ld b, a	; load the evolution level over to b
	dec b
.inc_level	; marker for looping back 
	inc b	;increment 	the current evolution level
	ld a, b	;put the evolution level in a
	ld [wCurEnemyLVL], a	;and reset the final level to the evolution level
	push bc	;save b & c on the stack as they hold the currently tracked evolution level a true final level
	call LearnMoveFromLevelUp
	pop bc	;get the current evolution and final level values back from the stack
	ld a, b	;load the current evolution level into a
	cp c	;compare it with the final level
	jr nz, .inc_level	;loop back again if final level has not been reached
	
	pop bc
	jr .skipfix_end
.notinbattle
	call LearnMoveFromLevelUp
.skipfix_end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	pop hl
	predef SetPartyMonTypes
	ld a, [wIsInBattle]
	and a
	call z, Evolution_ReloadTilesetTilePatterns
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexOwned
	push bc
	call Evolution_FlagAction
	pop bc
	ld hl, wPokedexSeen
	call Evolution_FlagAction
	pop de
	pop hl
	ld a, [wLoadedMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	jr .nextEvoEntry2

.nextEvoEntry1
	inc hl

.nextEvoEntry2
	inc hl
	jp .evoEntryLoop

.done
	pop de
	pop bc
	pop hl
	pop af
	ld [hTilesetType], a
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	ret z
	ld a, [wIsInBattle]
	and a
	ret nz
	ld a, [wEvolutionOccurred]
	and a
	call nz, PlayDefaultMusic
	ret

RenameEvolvedMon:
; Renames the mon to its new, evolved form's standard name unless it had a
; nickname, in which case the nickname is kept.
	ld a, [wd0b5]
	push af
	ld a, [wMonHIndex]
	ld [wd0b5], a
	call GetName
	pop af
	ld [wd0b5], a
	ld hl, wcd6d
	ld de, wcf4b
.compareNamesLoop
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp "@"
	jr nz, .compareNamesLoop
	ld a, [wWhichPokemon]
	ld bc, NAME_LENGTH
	ld hl, wPartyMonNicks
	call AddNTimes
	push hl
	call GetName
	ld hl, wcd6d
	pop de
	jp CopyData

CancelledEvolution:
	ld hl, StoppedEvolvingText
	call PrintText
	call ClearScreen
	pop hl
	call Evolution_ReloadTilesetTilePatterns
	jp Evolution_PartyMonLoop

EvolvedText:
	TX_FAR _EvolvedText
	db "@"

IntoText:
	TX_FAR _IntoText
	db "@"

StoppedEvolvingText:
	TX_FAR _StoppedEvolvingText
	db "@"

IsEvolvingText:
	TX_FAR _IsEvolvingText
	db "@"

Evolution_ReloadTilesetTilePatterns:
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	ret z
	jp ReloadTilesetTilePatterns

;joenote - this has been modified to allow for learning multiple moves at the same level
LearnMoveFromLevelUp:
	ld hl, EvosMovesPointerTable
	ld a, [wd11e] ; species
	ld [wcf91], a
	dec a
	ld bc, 0
	ld hl, EvosMovesPointerTable
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.skipEvolutionDataLoop ; loop to skip past the evolution data, which comes before the move data
	ld a, [hli]
	and a ; have we reached the end of the evolution data?
	jr nz, .skipEvolutionDataLoop ; if not, jump back up
.learnSetLoop ; loop over the learn set until we reach a move that is learnt at the current level or the end of the list
	ld a, [hli]
	and a ; have we reached the end of the learn set?
	jr z, .done ; if we've reached the end of the learn set, jump
	ld b, a ; level the move is learnt at
	ld a, [wCurEnemyLVL]
	cp b ; is the move learnt at the mon's current level?
	ld a, [hli] ; move ID
	jr nz, .learnSetLoop
	
;the move can indeed be learned at this level
.confirmlearnmove
	push hl	
	ld d, a ; ID of move to learn
	ld a, [wMonDataLocation]
	and a
	jr nz, .next
; If [wMonDataLocation] is 0 (PLAYER_PARTY_DATA), get the address of the mon's
; current moves in party data. Every call to this function sets
; [wMonDataLocation] to 0 because other data locations are not supported.
; If it is not 0, this function will not work properly.
	ld hl, wPartyMon1Moves
	ld a, [wWhichPokemon]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
.next
	ld b, NUM_MOVES
.checkCurrentMovesLoop ; check if the move to learn is already known
	ld a, [hli]
	cp d
	jr z, .movesloop_done ; if already known, jump
	dec b
	jr nz, .checkCurrentMovesLoop
	ld a, d
	ld [wMoveNum], a
	ld [wd11e], a
	call GetMoveName
	call CopyStringToCF4B
	predef LearnMove
.movesloop_done
	pop hl
	jr .learnSetLoop
	
	
.done
	ld a, [wcf91]
	ld [wd11e], a
	ret

;mc change WriteMonMoves routine to replace duplicate moves instead of skipping them
; Note: the new duplicate logic assumes the known moves list always has 4 unique
; moves by the time it encounters a duplicate move.
;
; If a learnset has a duplicate within the first 4 moves, it will add a blank slot 
; in the known moves list which will then cause the routine to stop adding moves
; prematurely.
;
; This shouldn't be a problem with any actual learnsets though, just a nuance that
; was discovered during testing.
WriteMonMoves:
	call GetPredefRegisters
	push hl
	push de
	push bc
	ld hl, EvosMovesPointerTable
	ld b, 0
	ld a, [wcf91]	; cur mon ID
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.skipEvoEntriesLoop
	ld a, [hli]
	and a
	jr nz, .skipEvoEntriesLoop
	jr .firstMove

.nextMove
	pop de
.nextMove2
	inc hl

.firstMove
	; HL → level byte of next [level, move] pair
	ld a, [hli]		; A = level
	and a
	jp z, .done		; 0 terminator ⇒ end of list
	ld b, a			; B = move level
	ld a, [wCurEnemyLVL]
	cp b
	jp c, .done		; stop at first move above mon level (learnset is sorted)

	; Day Care minimum level gate
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .skipMinLevelCheck
	ld a, [wDayCareStartLevel]
	cp b
	jr nc, .nextMove2	; if startLevel >= moveLevel, skip this learn

.skipMinLevelCheck
	; HL now points to the MOVE ID of this learnset entry.

	; --- Duplicate check (modified) ---
	; Save base pointer to current move list in stack copy of DE.
	; We'll scan the 4 slots, tracking the index in B'.
	push de
	ld c, NUM_MOVES
	ld b, 0
.alreadyKnowsCheckLoop
	ld a, [de]		; read slot value
	inc de
	cp [hl]			; is this the same move?
	jr z, .handleDuplicate	; new rule: remove old, append new
	inc b			; next index
	dec c
	jr nz, .alreadyKnowsCheckLoop

	; --- No duplicate found: original behavior ---
	; try to find first empty slot
	pop de
	push de
	ld c, NUM_MOVES
.findEmptySlotLoop
	ld a, [de]
	and a
	jr z, .writeMoveToSlot2	; write into first empty
	inc de
	dec c
	jr nz, .findEmptySlotLoop

	; no empty slot: shift all moves one up (delete slot 0), then write last
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	call WriteMonMoves_ShiftMoveData	; DE and HL end at last slot

	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .writeMoveToSlot

	; Day Care: shift PP one up in lock-step with moves
	push de						; preserve last-slot pointer for the write
	; Convert last move-slot pointer (base+3) → PP base using the fixed offset
	ld bc, wPartyMon1PP - (wPartyMon1Moves + 3)
	add hl, bc					; HL = PP base
	ld d, h
	ld e, l						; DE = PP base
	call WriteMonMoves_ShiftMoveData	; shift PP (all 3 copies), DE ends at PP+3
	pop de						; restore last move-slot pointer

.writeMoveToSlot
	pop hl
.writeMoveToSlot2
	; HL = learnset MOVE id pointer, DE = destination slot pointer
	ld a, [hl]
	ld [de], a

	; Day Care: write PP for the new move into its PP slot
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .nextMove

	push hl					; save learnset move-id pointer
	ld a, [hl]				; A = move id
	ld hl, wPartyMon1PP - wPartyMon1Moves
	add hl, de				; HL = PP slot address corresponding to DE
	push hl					; save PP slot pointer
	dec a
	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wBuffer + 5]		; PP byte
	pop hl
	ld [hl], a				; write PP
	pop hl
	jr .nextMove

	; -------------------------------
	; Duplicate handling (new logic)
	; -------------------------------
.handleDuplicate
	; On entry:
	;   HL = learnset MOVE id pointer (points at the new move ID)
	;   DE = base + (dupIndex) + 1  (due to the earlier inc de)
	;   B  = dupIndex (0..3)
	;   [stack top] = original base pointer for move list
	dec de					; DE = address of the duplicate slot (base + dupIndex)

	; Save the learnset pointer so we can read the move id later (and continue).
	push hl

	; -------- Remove the duplicate by shifting suffix left by 1 --------
	; Prepare HL, DE to the same duplicate slot; C = (NUM_MOVES - 1 - dupIndex)
	ld h, d
	ld l, e					; HL = base + dupIndex
	ld a, NUM_MOVES - 1
	sub b
	ld c, a					; C = count to copy
	call WriteMonMoves_ShiftMoveData_FromIndex
	; Now DE = base + 3 (last slot), HL = base + 3 as well.

	; -------- If Day Care, shift PP suffix the same way --------
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .dupWriteMove

	; Preserve last-slot pointer for the write that follows
	push de

	; Compute PP base from (base+3) using fixed offset, then seek to dupIndex
	ld h, d
	ld l, e					; HL = base + 3
	ld bc, wPartyMon1PP - (wPartyMon1Moves + 3)
	add hl, bc				; HL = PP base
	ld d, h
	ld e, l					; DE = PP base

	; Advance HL/DE by dupIndex (B) to align to the PP slot we’re deleting
	ld a, b
.ppOffsetLoop
	and a
	jr z, .ppDoShift
	inc hl
	inc de
	dec a
	jr .ppOffsetLoop

.ppDoShift
	ld a, NUM_MOVES - 1
	sub b
	ld c, a					; C = count to copy for PP
	call WriteMonMoves_ShiftMoveData_FromIndex
	; DE now = PP + 3

	; Restore last move-slot pointer for the write
	pop de

.dupWriteMove
	; Append the new instance at the LAST open slot (always slot 3 after removal,
	; or slot 3 already empty if list wasn’t full).
	pop hl					; HL = learnset MOVE id pointer
	ld a, [hl]
	ld [de], a				; write move id to last slot

	; Day Care: write PP for the newly-appended move to its PP slot (slot 3)
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .dupAdvance

	push hl					; save learnset pointer again
	ld a, [hl]				; A = move id
	ld hl, wPartyMon1PP - wPartyMon1Moves
	add hl, de				; HL = PP slot addr for the last move slot
	push hl
	dec a
	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wBuffer + 5]
	pop hl
	ld [hl], a
	pop hl

.dupAdvance
	; Balance the duplicate-scan “push de”, advance HL to next [level, move], continue.
	pop de					; restore base pointer to move list
	inc hl					; HL was at MOVE id; step to next level byte
	jp .firstMove

.done
	pop bc
	pop de
	pop hl
	ret


; ---------------------------------------------------------------------
; shifts all move data one up (freeing 4th move slot) — original helper
; On entry: HL = base, DE = base
; Copies slots [1..3] → [0..2]. On return, DE and HL = base+3.
; ---------------------------------------------------------------------
WriteMonMoves_ShiftMoveData:
	ld c, NUM_MOVES - 1
.shiftAllLoop
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .shiftAllLoop
	ret


; ---------------------------------------------------------------------
; shifts a suffix of move/PP data one up, starting at an arbitrary index
; Inputs:
;   HL = base + index_to_delete
;   DE = base + index_to_delete
;   C  = (NUM_MOVES - 1 - index_to_delete)   ; #items to copy left
; Effect:
;   Copies bytes [index+1 .. 3] → [index .. 2].
;   On return, DE and HL = base + 3 (last slot).
; Clobbers: A, flags. Preserves: B.
; ---------------------------------------------------------------------
WriteMonMoves_ShiftMoveData_FromIndex:
	; if C == 0 nothing to shift
	ld a, c
	and a
	ret z
.shiftIdxLoop
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .shiftIdxLoop
	ret

Evolution_FlagAction:
	predef_jump FlagActionPredef

;joenote - custom function by Mateo for move relearner
IF DEF(_MOVENPCS)
PrepareRelearnableMoveList:	
; Loads relearnable move list to wRelearnableMoves.
; Input: party mon index = [wWhichPokemon]
	; Get mon id.
	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl] ; a = mon id
	ld [wd0b5], a	;joenote - put mon id into wram for potential later usage of GetMonHeader
	; Get pointer to evos moves data.
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a  ; hl = pointer to evos moves data for our mon
	push hl
	; Get pointer to mon's currently-known moves.
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	ld b, a
	push bc
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	pop hl
	; Skip over evolution data.
.skipEvoEntriesLoop
	ld a, [hli]
	and a
	jr nz, .skipEvoEntriesLoop
	; Write list of relearnable moves, while keeping count along the way.
	; de = pointer to mon's currently-known moves
	; hl = pointer to moves data for our mon
	;  b = mon's level
	ld c, 0 ; c = count of relearnable moves
.loop
	ld a, [hli]
	and a
	jr z, .done
	cp b
	jr c, .addMove
	jr nz, .done
.addMove
	push bc
	ld a, [hli] ; move id
	ld b, a
	; Check if move is already known by our mon.
	push de
	ld a, [de]
	cp b
	jr z, .knowsMove
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove
.relearnableMove
	pop de
	push hl
	; Add move to the list, and update the running count.
	ld a, b
	ld b, 0
	ld hl, wMoveBuffer + 1
	add hl, bc
	ld [hl], a
	pop hl
	pop bc
	inc c
	jr .loop
.knowsMove
	pop de
	pop bc
	jr .loop
.done	
;joenote - start checking for level-0 moves
	xor a
	ld b, a	;b will act as a counter, as there can only be up to 4 level-0 moves
	call GetMonHeader ;mon id already stored earlier in wd0b5
	ld hl, wMonHMoves
.loop2
	ld a, b	;get the current loop counter into a
	cp $4
	jr nc, .done2	;if gone through 4 moves already, reached the end of the list. move to done2.
	ld a, [hl]	;load move
	and a
	jr z, .done2	;if move has id 0, list has reached the end early. move to done2.
	
	;check if the move is already in the learnable move list
	push bc
	push hl
	;c = buffer length
.buffer_loop
	ld hl, wMoveBuffer
	ld b, 0
	add hl, bc	;move to buffer at current c value
	ld b, a	;b = move id
	ld a, [hl] ; move id at buffer point
	cp b
	ld a, b	;a = move id
	jr z, .move_in_buffer
	inc c
	dec c
	jr z, .end_buffer_loop	;jump out if start of buffer is reached
	dec c	;else decrement c and loop again
	jr .buffer_loop
.move_in_buffer
	pop hl
	pop bc
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
.end_buffer_loop
	pop hl
	pop bc
	
	;Check if move is already known by our mon.
	push bc
	ld a, [hl] ; move id
	ld b, a
	push de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	;if the move is not already known, add it to the learnable move list
	pop de
	push hl
	; Add move to the list, and update the running count.
	ld a, b
	ld b, 0
	ld hl, wMoveBuffer + 1
	add hl, bc
	ld [hl], a
	pop hl
	pop bc
	inc c
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
	
.knowsMove2
	pop de
	pop bc
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
	
.done2
	ld b, 0
	ld hl, wMoveBuffer + 1
	add hl, bc
	ld a, $ff
	ld [hl], a
	ld hl, wMoveBuffer
	ld [hl], c
	ret
ENDC
	
;joenote - make it so a message is printed if the level requirement for an item evolution is not met
_NeededLevelText:
	text "Level @"
	TX_NUM wCurEnemyLVL, 1, 3
	text " needed!"
	prompt

INCLUDE "data/evos_moves.asm"
