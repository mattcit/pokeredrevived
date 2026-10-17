PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries
	dw PrizeMenuMon1Cost

	dw PrizeMenuMon2Entries
	dw PrizeMenuMon2Cost

	dw PrizeMenuTMsEntries
	dw PrizeMenuTMsCost

NoThanksText:
	db "NO THANKS@"

PrizeMenuMon1Entries:
IF DEF(_ENCRED)
	db TANGELA
	db PORYGON
	db SHELLDER
ENDC
	db "@"

PrizeMenuMon1Cost:
IF DEF(_ENCRED)
	coins 180
	coins 500
	coins 1200
ENDC
	db "@"

PrizeMenuMon2Entries:
IF DEF(_ENCRED)
	db EEVEE
	db PINSIR
	db SCYTHER
ENDC
	db "@"

PrizeMenuMon2Cost:
IF DEF(_ENCRED)
	coins 2400
	coins 3200
	coins 3200
ENDC
	db "@"

PrizeMenuTMsEntries:
	db TM_19 ; seismic toss
	db TM_08 ; body slam
	db TM_15 ; hyper beam
	db "@"

PrizeMenuTMsCost:
	coins 3300
	coins 5500
	coins 7700
	db "@"