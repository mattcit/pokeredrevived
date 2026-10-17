; Elemental types
;physical types
NORMAL   EQU $00
FIGHTING EQU $01
FLYING   EQU $02
POISON   EQU $03
GROUND   EQU $04
ROCK     EQU $05
BIRD	 EQU $06	;joenote - added-in this unused type
BUG      EQU $07
;special types
FIRE     EQU $14
WATER    EQU $15
GRASS    EQU $16
ELECTRIC EQU $17
PSYCHIC  EQU $18
ICE      EQU $19
DRAGON   EQU $1A
;mc make ghost a special type
; shadow ball is the only ghost move that does significant
; damage, and in later gens it's a special move, which
; capitalizes on gengar's high special (vs it's low attack)
; making all ghost moves special type only really affects lick
; and shadow ball, so it's a small change that makes a big
; difference for gengar and makes ghost type moves actually
; viable for ghost types--an important buff now that normal
; types will also get shadow ball access via tm
GHOST    EQU $1B