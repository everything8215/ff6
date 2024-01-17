.list off
.ifndef CHAR_AI_INC
CHAR_AI_INC = 1

.global CharAI

; ------------------------------------------------------------------------------

CHAR_AI_FLAG_NONE                       = 0
CHAR_AI_FLAG_HIDE_NAMES                 = $01
CHAR_AI_FLAG_HIDE_PARTY                 = $80

CHAR_AI_FLAG_NOT_IN_PARTY               = $80
CHAR_AI_FLAG_ENEMY_CHAR                 = $40

; ------------------------------------------------------------------------------

CHAR_AI_NONE                            = $00  ; 0
CHAR_AI_SHADOW_COLOSSEUM                = $01  ; 1
CHAR_AI_TERRA_FLASHBACK                 = $02  ; 2
CHAR_AI_VARGAS                          = $03  ; 3
CHAR_AI_KEFKA_IMP_CAMP_1                = $04  ; 4
CHAR_AI_CYAN_IMP_CAMP_1                 = $05  ; 5
CHAR_AI_CYAN_IMP_CAMP_2                 = $06  ; 6
CHAR_AI_PIRANHA                         = $07  ; 7
CHAR_AI_UNUSED_08                       = $08  ; 8
CHAR_AI_UNUSED_09                       = $09  ; 9
CHAR_AI_GAU_VELDT                       = $0a  ; 10
CHAR_AI_UNUSED_0B                       = $0b  ; 11
CHAR_AI_SEALED_GATE_1                   = $0c  ; 12
CHAR_AI_SEALED_GATE_2                   = $0d  ; 13
CHAR_AI_BLACKJACK_ESPERS                = $0e  ; 14
CHAR_AI_ULTROS_RELM                     = $0f  ; 15
CHAR_AI_ESPERS                          = $10  ; 16
CHAR_AI_BLITZ_TUTORIAL                  = $11  ; 17
CHAR_AI_KEFKA_ESPER                     = $12  ; 18
CHAR_AI_KEFKA_GESTAHL                   = $13  ; 19
CHAR_AI_KEFKA_LEO                       = $14  ; 20
CHAR_AI_UNUSED_15                       = $15  ; 21
CHAR_AI_UNUSED_16                       = $16  ; 22
CHAR_AI_UNUSED_17                       = $17  ; 23

CHAR_AI_ARRAY_LENGTH                    = $18

; ------------------------------------------------------------------------------

.endif
.list on
