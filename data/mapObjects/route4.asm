Route4Object:
	db $2c ; border block

	db 3 ; warps
	warp 11, 5, 0, MT_MOON_POKECENTER
	warp 18, 5, 0, MT_MOON_1
	warp 24, 5, 7, MT_MOON_2

	db 3 ; signs
	sign 12, 5, 11 ; PokeCenterSignText
	sign 17, 7, 12 ; Route4Text5
	sign 27, 7, 13 ; Route4Text6

	db 10 ; objects
	object SPRITE_LASS, 9, 8, WALK, 0, 1 ; person
	object SPRITE_LASS, 38, 6, STAY, DOWN, 2, OPP_LASS, 21
	object SPRITE_BUG_CATCHER, 40, 2, STAY, DOWN, 3, OPP_YOUNGSTER, 16
	object SPRITE_HIKER, 45, 15, STAY, UP, 4, OPP_HIKER, 15
	object SPRITE_BUG_CATCHER, 57, 15, STAY, UP, 5, OPP_BUG_CATCHER, 16
	object SPRITE_BUG_CATCHER, 49, 9, STAY, LEFT, 6, OPP_YOUNGSTER, 17
	object SPRITE_LASS, 47, 2, STAY, DOWN, 7, OPP_LASS, 22
	object SPRITE_BUG_CATCHER, 48, 2, STAY, DOWN, 8, OPP_YOUNGSTER, 18
	object SPRITE_LASS, 59, 5, STAY, LEFT, 9, OPP_LASS, 4
	object SPRITE_BALL, 57, 3, STAY, NONE, 10, TM_16 ; pay day

	; warp-to
	warp_to 11, 5, ROUTE_4_WIDTH ; MT_MOON_POKECENTER
	warp_to 18, 5, ROUTE_4_WIDTH ; MT_MOON_1
	warp_to 24, 5, ROUTE_4_WIDTH ; MT_MOON_2
