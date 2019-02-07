PokemonTower5Object:
	db $1 ; border block

	db 2 ; warps
	warp 3, 9, 0, POKEMONTOWER_4
	warp 18, 9, 0, POKEMONTOWER_6

	db 0 ; signs

	db 6 ; objects
	object SPRITE_MEDIUM, 12, 8, STAY, NONE, 1 ; person
	object SPRITE_MEDIUM, 17, 7, STAY, LEFT, 2, OPP_CHANNELER, 7
	object SPRITE_MEDIUM, 14, 3, STAY, LEFT, 3, OPP_CHANNELER, 8
	object SPRITE_MEDIUM, 6, 10, STAY, RIGHT, 4, OPP_CHANNELER, 9
	object SPRITE_MEDIUM, 9, 16, STAY, RIGHT, 5, OPP_CHANNELER, 10
	object SPRITE_BALL, 6, 14, STAY, NONE, 6, NUGGET

	; warp-to
	warp_to 3, 9, POKEMONTOWER_5_WIDTH ; POKEMONTOWER_4
	warp_to 18, 9, POKEMONTOWER_5_WIDTH ; POKEMONTOWER_6