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

.enum CHAR_AI
        NONE                            = $00  ; 0
        SHADOW_COLOSSEUM                = $01  ; 1
        TERRA_FLASHBACK                 = $02  ; 2
        VARGAS                          = $03  ; 3
        KEFKA_IMP_CAMP_1                = $04  ; 4
        CYAN_IMP_CAMP_1                 = $05  ; 5
        CYAN_IMP_CAMP_2                 = $06  ; 6
        PIRANHA                         = $07  ; 7
        UNUSED_08                       = $08  ; 8
        UNUSED_09                       = $09  ; 9
        GAU_VELDT                       = $0a  ; 10
        UNUSED_0B                       = $0b  ; 11
        SEALED_GATE_1                   = $0c  ; 12
        SEALED_GATE_2                   = $0d  ; 13
        BLACKJACK_ESPERS                = $0e  ; 14
        ULTROS_RELM                     = $0f  ; 15
        ESPERS                          = $10  ; 16
        BLITZ_TUTORIAL                  = $11  ; 17
        KEFKA_ESPER                     = $12  ; 18
        KEFKA_GESTAHL                   = $13  ; 19
        KEFKA_LEO                       = $14  ; 20
        UNUSED_15                       = $15  ; 21
        UNUSED_16                       = $16  ; 22
        UNUSED_17                       = $17  ; 23
.endenum

.scope CharAI
        ARRAY_LENGTH = CHAR_AI::UNUSED_17 + 1
.endscope

; ------------------------------------------------------------------------------

.endif
.list on
