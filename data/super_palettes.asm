; palettes for overworlds, title screen, monsters
MACRO SGB_WHITE
	IF DEF(_GREEN)
		dw (29 << 10 | 31 << 5 | 30)
	ELSE
		dw (31 << 10 | 29 << 5 | 31)
	ENDC
ENDM

SuperPalettes:
	; PAL_ROUTE
	SGB_WHITE 
	RGB 21,28,11
	RGB 20,26,31
	RGB 3,2,2
	
	; PAL_PALLET
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 25,24,29
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 25,28,27
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_VIRIDIAN
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 11,31,3
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 17,26,3
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_PEWTER
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 21,20,16
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 23,25,16
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_CERULEAN
	SGB_WHITE 
	RGB 17,20,30
	RGB 20,26,31
	RGB 3,2,2
	
	; PAL_LAVENDER
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 25,19,31
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 27,20,27
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_VERMILION
	SGB_WHITE 
	RGB 30,18,0
	RGB 20,26,31
	RGB 3,2,2
	
	; PAL_CELADON
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 12,28,22
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 16,30,22
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_FUCHSIA
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 31,17,21
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 31,15,22
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_CINNABAR
	SGB_WHITE 
	RGB 26,10,6
	RGB 20,26,31
	RGB 3,2,2
	
	; PAL_INDIGO
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 18,14,31
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 22,14,24
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_SAFFRON
IF DEF(_REDGREENJP)
	SGB_WHITE 
	RGB 29,26,3
	RGB 20,26,31
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 27,27,3
	RGB 20,26,31
	RGB 3,2,2
ENDC
	
	; PAL_TOWNMAP
	SGB_WHITE 
	RGB 20,26,31
	RGB 17,23,10
	RGB 3,2,2
	
	; PAL_LOGO1
IF DEF(_REDJP)
	SGB_WHITE 	;white bg
	RGB 30,30,17	;yellow logo text
	RGB 17,23,10	;unused on title screen
	RGB 14,19,29	;version subtitle text color
ELIF DEF(_RED)
	SGB_WHITE 	;white bg
	RGB 30,30,17	;yellow logo text
	RGB 17,23,10	;unused on title screen
	RGB 21,0,4	;version subtitle text color
ENDC
IF DEF(_BLUEJP)
	SGB_WHITE	;white bg
	RGB 30,30,17	;yellow logo text
	RGB 21,0,4	;unused on title screen
	RGB 9,16,12	;version subtitle text color
ELIF DEF(_BLUE)
	SGB_WHITE	;white bg
	RGB 30,30,17	;yellow logo text
	RGB 21,0,4	;unused on title screen
	RGB 14,19,29	;version subtitle text color
ENDC
IF DEF(_GREEN)
	SGB_WHITE	;white bg
	RGB 30,30,17	;yellow logo text
	RGB 21,0,4	;unused on title screen
	RGB 14,19,29	;version subtitle text color
ENDC

	; PAL_LOGO2
IF (DEF(_RED) && DEF(_JPLOGO))
	SGB_WHITE 		;white bg
	RGB 30,30,17	;unused yellow logo text
	RGB 17,23,10	;"pocket monsters" logo text color
	RGB 21,0,4		;japanese logo text color
ELIF (DEF(_GREEN) && DEF(_JPLOGO))
	SGB_WHITE 		;white bg
	RGB 30,30,17	;unused yellow logo text
	RGB 21,0,4	;"pocket monsters" logo text color
	RGB 11,31,3		;japanese logo text color
ELIF (DEF(_BLUE) && DEF(_JPLOGO))
	SGB_WHITE 		;white bg
	RGB 30,30,17	;unused yellow logo text
	RGB 21,0,4		;"pocket monsters" logo text color
	RGB 14,19,29	;japanese logo text color
ELSE
	SGB_WHITE 	;white bg
	RGB 30,30,17	;unused on title screen
	RGB 18,18,24	;blue logo text shadow
	RGB 7,7,16	;blue logo text outline
ENDC
	; PAL_0F
	SGB_WHITE 
	RGB 24,20,30
	RGB 11,20,30
	RGB 3,2,2
	
	; PAL_MEWMON
	SGB_WHITE 
	RGB 30,22,17
	RGB 16,14,19
	RGB 3,2,2
	
	; PAL_BLUEMON
	SGB_WHITE 
	RGB 18,20,27
	RGB 11,15,23
	RGB 3,2,2
	
	; PAL_REDMON
	SGB_WHITE 
	RGB 31,20,10
	RGB 26,10,6
	RGB 3,2,2
	
	; PAL_CYANMON
	SGB_WHITE 
	RGB 21,25,29
	RGB 14,19,25
	RGB 3,2,2
	
	; PAL_PURPLEMON
	SGB_WHITE 
	RGB 27,22,24
	RGB 21,15,23
	RGB 3,2,2
	
	; PAL_BROWNMON
	SGB_WHITE 
	RGB 28,20,15
	RGB 21,14,9
	RGB 3,2,2
	
	; PAL_GREENMON
	SGB_WHITE 
	RGB 20,26,16
	RGB 9,20,11
	RGB 3,2,2
	
	; PAL_PINKMON
	SGB_WHITE 
	RGB 30,22,24
	RGB 28,15,21
	RGB 3,2,2
	
	; PAL_YELLOWMON
	SGB_WHITE 
	RGB 31,28,14
	RGB 26,20,0
	RGB 3,2,2
	
	; PAL_GREYMON
	SGB_WHITE 
	RGB 26,21,22
	RGB 15,15,18
	RGB 3,2,2
	
	; PAL_SLOTS1
IF DEF(_GREEN)
	SGB_WHITE 
	RGB 26,21,22
	RGB 21,0,4
	RGB 3,2,2
ELSE
	SGB_WHITE 
	RGB 26,21,22
	RGB 27,20,6
	RGB 3,2,2
ENDC
	
	; PAL_SLOTS2
IF DEF(_RED)
	SGB_WHITE 
	RGB 31,31,17
	RGB 25,17,21
	RGB 3,2,2
ENDC
IF DEF(_BLUE)	
	SGB_WHITE 
	RGB 31,31,17
	RGB 16,19,29
	RGB 3,2,2
ENDC
IF DEF(_GREEN)	
	SGB_WHITE
	RGB 29,26,04
	RGB 18,23,12
	RGB 03,02,02
ENDC
	; PAL_SLOTS3
IF DEF(_RED)
	SGB_WHITE 
	RGB 22,31,16
	RGB 25,17,21
	RGB 3,2,2
ENDC
IF DEF(_BLUE)
	SGB_WHITE 
	RGB 22,31,16
	RGB 16,19,29
	RGB 3,2,2
ENDC
IF DEF(_GREEN)
	SGB_WHITE
	RGB 26,14,20
	RGB 18,23,12
	RGB 03,02,02
ENDC
	
	; PAL_SLOTS4
IF DEF(_RED)
	SGB_WHITE 
	RGB 16,19,29
	RGB 25,17,21
	RGB 3,2,2
ENDC	
IF DEF(_BLUE)
	SGB_WHITE 
	RGB 25,17,21
	RGB 16,19,29
	RGB 3,2,2
ENDC
IF DEF(_GREEN)
	RGB 31,29, 31
	RGB 16,19,29
	RGB 18,23,12
	RGB 03,02,02
ENDC
	
	; PAL_BLACK
	SGB_WHITE 
	RGB 7,7,7
	RGB 2,3,3
	RGB 3,2,2
	
	; PAL_GREENBAR
	SGB_WHITE 
	RGB 30,26,15
	RGB 9,20,11
	RGB 3,2,2
	
	; PAL_YELLOWBAR
	SGB_WHITE 
	RGB 30,26,15
	RGB 26,20,0
	RGB 3,2,2
	
	; PAL_REDBAR
	SGB_WHITE 
	RGB 30,26,15
	RGB 26,10,6
	RGB 3,2,2
	
	; PAL_BADGE
	SGB_WHITE 
	RGB 30,22,17
	RGB 11,15,23
	RGB 3,2,2
	
	; PAL_CAVE
	SGB_WHITE 
	RGB 21,14,9
	RGB 18,24,22
	RGB 3,2,2
	
	; PAL_GAMEFREAK
	SGB_WHITE 
	RGB 31,28,14
	RGB 24,20,10
	RGB 3,2,2
	
;gbcnote - added from yellow
	; PAL_25
	RGB 31, 31, 30
	RGB 31, 30, 22
	RGB 23, 27, 31
	RGB  6,  6,  6

	; PAL_26
	RGB 31, 31, 30
	RGB 28, 23,  9
	RGB 18, 14, 10
	RGB  6,  6,  6

	; PAL_27
	RGB 31, 31, 30
	RGB 16, 16, 16
	RGB 31, 25,  9
	RGB  6,  6,  6
