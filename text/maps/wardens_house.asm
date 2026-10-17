_WardenGibberishText1::
	text "WARDEN: Hif fuff"
	line "hefifoo!"

	para "Ha lof ha feef ee"
	line "hafahi ho. Heff"
	cont "hee fwee!"
	done

_WardenGibberishText2::
	text "Ah howhee ho hoo!"
	line "Eef ee hafahi ho!"
	done

_WardenGibberishText3::
	text "Ha? He ohay heh"
	line "ha hoo ee haheh!"
	done

_WardenTeethText1::
	text "<PLAYER> gave the"
	line "GOLD TEETH to the"
	cont "WARDEN!@@"

_WardenTeethText2::
	db $0
	para "The WARDEN popped"
	line "in his teeth!"
	prompt

_WardenThankYouText::
	text "WARDEN: Thanks,"
	line "kid! No one could"
	cont "understand a word"
	cont "that I said."

	para "I couldn't work"
	line "that way."
	cont "Let me give you"
	cont "something for"
	cont "your trouble."
	prompt

_ReceivedHM04Text::
	text "<PLAYER> received"
	line "@"
	TX_RAM wcf4b
	text "!@@"
	prompt

_HM04ExplanationText::
	text "WARDEN: HM04"
	line "teaches STRENGTH!"

	para "It lets #MON"
	line "move boulders"
	cont "when you're out-"
	cont "side of battle."

	para "Oh yes, did you"
	line "find SECRET HOUSE"
	cont "in SAFARI ZONE?"

	para "If you do, you"
	line "win another HM!"

	para "I hear it's the"
	line "rare SURF HM."

	para "Also, I still have"
	line "another item that"
	cont "is lost in the"
	cont "SAFARI ZONE."

	para "If you can find my"
	line "GOLD WATCH, I"
	cont "could give you a"
	cont "RARE #MON."
	done

_HM04NoRoomText::
	text "Your pack is"
	line "stuffed full!"
	done

_WardenWatchThankYouText::
	text "Oh, you found"
	line "my GOLD WATCH!"

	para "It may not be"
	line "worth much, but"
	cont "it has a lot of"
	cont "sentimental value"
	cont "to me."

	para "As a reward I"
	line "want to give you"
	cont "one of my RARE"
	cont "#MON. Please"
	cont "take good care"
	cont "of it for me!"
	prompt

_WardenFinalText::
	text "Take good care of"
	line "that #MON!"
	done

_FuchsiaHouse2Text_75176::
	text "#MON photos"
	line "and fossils."
	done

_FuchsiaHouse2Text_7517b::
	text "Old #MON"
	line "merchandise."
	done
