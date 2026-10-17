TrainerPicAndMoneyPointers:
; trainer pic pointers and base money.
; money received after battle = base money × level of highest-level enemy mon
;mc **CORRECTION: it's base money * level of last pokemon on team
; money is a 3 byte (6 digit) BCD number
; HOWEVER, wTrainerBaseMoney is only a 2 byte memory address
; so use 3 bytes, but the last byte will always be 00
;mc if money is 0, wAmountMoneyWon will be calculated based on level
; else, wAmountMoneyWon = wTrainerBaseMoney

	dw YoungsterPic
	money 0

	dw BugCatcherPic
	money 0

	dw LassPic
	money 0

	dw SailorPic
	money 0

	dw JrTrainerMPic
	money 0

	dw JrTrainerFPic
	money 0

	dw PokemaniacPic
	money 0

	dw SuperNerdPic
	money 0

	dw HikerPic
	money 0

	dw BikerPic
	money 0

	dw BurglarPic
	money 0

	dw EngineerPic
	money 0

	dw JugglerPic
	money 0

	dw FisherPic
	money 0

	dw SwimmerPic
	money 0

	dw CueBallPic
	money 0

	dw GamblerPic
	money 0

	dw BeautyPic
	money 0

	dw PsychicPic
	money 0

	dw RockerPic
	money 0

	dw JugglerPic
	money 0

	dw TamerPic
	money 0

	dw BirdKeeperPic
	money 0

	dw BlackbeltPic
	money 0

	dw Rival1Pic
	money 0

	dw ProfOakPic
	money 0

	dw ChiefPic
	money 0

	dw ScientistPic
	money 0

	dw GiovanniPic
	;claude: TRN-6 -- Giovanni now has 3 distinct prizes (Rocket Hideout 10000, Silph Co
	;claude: 15000, Gym 20000) instead of one flat value shared by all 3 fights. Zeroed
	;claude: like the tiered-formula classes above, but he's not one of those either --
	;claude: read_trainer_party.asm's .FinishUp special-cases GIOVANNI by wTrainerNo
	;claude: (1/2/3, already set per-encounter from the OPP_GIOVANNI map-object data) before
	;claude: it ever reaches the zero check that would otherwise route him into the
	;claude: level-tiered formula.
	money 0

	dw RocketPic
	money 0

	dw CooltrainerMPic
	money 0

	dw CooltrainerFPic
	money 0

	dw BrunoPic
	money 050000

	dw BrockPic
	money 005000

	dw MistyPic
	money 008000

	dw LtSurgePic
	money 010000

	dw ErikaPic
	money 012000

	dw KogaPic
	money 014000

	dw BlainePic
	money 018000

	dw SabrinaPic
	money 016000

	dw GentlemanPic
	money 0

	dw Rival2Pic
	money 0

	dw Rival3Pic
	money 100000

	dw LoreleiPic
	money 040000

	dw ChannelerPic
	money 0

	dw AgathaPic
	money 065000

	dw LancePic
	money 075000
