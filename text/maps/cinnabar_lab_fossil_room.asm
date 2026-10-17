_Lab4Text_75dc6::
	text "Hi there!"

	para "I have designed"
	line "this machine here"
	cont "to take any"
	cont "#MON fossil"
	cont "and bring that"
	cont "#MON back to"
	cont "life again!"

	para "Do you have you a"
	line "fossil that you'd"
	cont "like to revive?"
	prompt

_Lab4Text_75dcb::
	text "No? Well that's"
	line "too bad!"
	done

_Lab4Text_75dd0::
	text "This will take a"
	line "little time."

	para "How about you go"
	line "for a quick walk?"
	done

_Lab4Text_75dd5::
	text "Where were you?"

	para "Your fossil is"
	line "back to life!"

	para "It was @"
	TX_RAM wcf4b
	db $0
	line "like I thought!"
	prompt

_Lab4Text_610ae::
	text "Oh! That is"
	line "@"
	TX_RAM wcd6d
	text "!"

	para "It is a fossil of"
	line "@"
	TX_RAM wcf4b
	text ", a"
	cont "#MON that is"
	cont "already extinct!"

	para "My Resurrection"
	line "Machine will make"
	cont "that #MON live"
	cont "again!"
	done

_Lab4Text_610b3::
	text "If you give me"
	line "the fossil we can"
	cont "get started now!"

	para "<PLAYER> handed"
	line "over @"
	TX_RAM wcd6d
	text "!"
	prompt

_Lab4Text_610b8::
	text "This will take a"
	line "little time."

	para "How about you go"
	line "for a quick walk?"
	done

_Lab4Text_610bd::
	text "If you change your"
	line "mind feel free to"
	cont "come back later!"
	done
