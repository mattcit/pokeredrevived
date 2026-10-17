CeladonMansion5Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion5TextPointers:
	dw CeladonMansion5Text1
	dw CeladonMansion5Text2

CeladonMansion5Text1:
	TX_FAR _CeladonMansion5Text1
	db "@"

CeladonMansion5Text2:
	TX_ASM
	;mc change gift eevee level from 25 to 15 for balancing
	lb bc, EEVEE, 15
	call GivePokemon
	jr nc, .asm_24365
	ld a, HS_CELADON_MANSION_5_GIFT
	ld [wMissableObjectIndex], a
	predef HideObject
.asm_24365
	jp TextScriptEnd
