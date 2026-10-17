TradeMons:
; givemonster, getmonster, textstring, nickname (11 bytes), 14 bytes total
IF DEF(_ENCBLUEJP)
	db RHYDON,		KANGASKHAN,	0, "RODAN@@@@@@"
	db JIGGLYPUFF,	MR_MIME,   	0, "MASARU@@@@@"
	db BUTTERFREE,	BEEDRILL,  	2, "CHIKUCHIKU@"
	db GROWLITHE,	KRABBY,     0, "DRAK@@@@@@@"
	db PIDGEY,		FARFETCHD, 	2, "AKKA@@@@@@@"
	db PERSIAN,		TAUROS, 	0, "GYUTA@@@@@@"
	db MACHOKE,		HAUNTER,	1, "GHOSUKE@@@@"
	db KADABRA,		GRAVELER,	1, "SABURO@@@@@"
	db SEEL,		SLOWPOKE,	2, "OSCAR@@@@@@"
	db RATTATA,		POLIWAG,	2, "POLI-TAN@@@"
;unused localization names for blue-jp trades per 
;https://tcrf.net/Development:Pok%C3%A9mon_Red_and_Blue/Localization#Pok%C3%A9mon_Nicknames
;	FLUFFY
;	MYMO
;	<beedrill has no localized name>
;	VALERIE
;	SWANNY
;	JIMBO
;	MICHELLE
;	JENNY
;	SHANE
;	WAGSTER
ELIF DEF(_ENCBLUEGREEN)
	db NIDORINO,  NIDORINA, 0,"TERRY@@@@@@"
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@"
	db BUTTERFREE,BEEDRILL, 2,"PRICKLY@@@@"
	db PONYTA,    SEEL,     0,"SAILOR@@@@@"
	db SPEAROW,   FARFETCHD,2,"DUX@@@@@@@@"
	db SLOWBRO,   LICKITUNG,0,"MARC@@@@@@@"
	db POLIWHIRL, JYNX,     1,"LOLA@@@@@@@"
	db RAICHU,    ELECTRODE,1,"DORIS@@@@@@"
	db VENONAT,   TANGELA,  2,"CRINKLES@@@"
;	db NIDORAN_M, NIDORAN_F,2,"SPOT@@@@@@@"	;joenote - this was probably accidentally swapped by the localization team
	db NIDORAN_F, NIDORAN_M,2,"SPOT@@@@@@@"

;mc change trades
ELIF DEF(_ENCRED)
	db DROWZEE,   PSYDUCK,  0,"ARCHIE@@@@@" ; route 11/vermillion
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@" ; route 2
	db BEEDRILL, BUTTERFREE,2,"PIPPIN@@@@@" ; unused
	db RAPIDASH,  TAUROS,   0,"TORO@@@@@@@" ; cinnabar lab
	db NIDORAN_M, EXEGGCUTE,2,"PALMER@@@@@" ; vermillion city
	db KANGASKHAN,LICKITUNG,0,"GUS@@@@@@@@" ; route 18/fuchsia
	db VOLTORB,   PONYTA,   1,"CINDER@@@@@" ; cerulean city
	db FARFETCHD, EEVEE,    1,"VIXIE@@@@@@" ; cinnabar lab
	db POLIWRATH, JYNX,     2,"LUNA@@@@@@@" ; cinnabar lab
	db CLEFAIRY,  SEEL,     2,"PEARL@@@@@@" ; route 5/cerulean


ELSE ;default to use if there is a compiler tag issue
	db NIDORINO,  NIDORINA, 0,"TERRY@@@@@@"
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@"
	db BUTTERFREE,BEEDRILL, 2,"CHIKUCHIKU@"
	db PONYTA,    SEEL,     0,"SAILOR@@@@@"
	db SPEAROW,   FARFETCHD,2,"DUX@@@@@@@@"
	db SLOWBRO,   LICKITUNG,0,"MARC@@@@@@@"
	db POLIWHIRL, JYNX,     1,"LOLA@@@@@@@"
	db RAICHU,    ELECTRODE,1,"DORIS@@@@@@"
	db VENONAT,   TANGELA,  2,"CRINKLES@@@"
	db NIDORAN_M, NIDORAN_F,2,"SPOT@@@@@@@"
ENDC