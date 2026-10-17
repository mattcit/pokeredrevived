Lab3Script:
	jp EnableAutoTextBoxDrawing

Lab3TextPointers:
;mc change TM35 giver to be a shop for strong TMs
	dw CinnabarTMShopText
	dw Lab3Text2
	dw Lab3Text3
	dw Lab3Text4
	dw Lab3Text5

Lab3Text2:
	TX_FAR _Lab3Text2
	db "@"

Lab3Text4:
Lab3Text3:
	TX_FAR _Lab3Text3
	db "@"

Lab3Text5:
	TX_FAR _Lab3Text5
	db "@"
