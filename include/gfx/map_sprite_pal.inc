.list off
.ifndef MAP_SPRITE_PAL_INC
MAP_SPRITE_PAL_INC = 1

.global MapSpritePal

.enum MAP_SPRITE_PAL
        EDGAR_SABIN_CELES               = $00  ; 0
        EDGAR                           = EDGAR_SABIN_CELES
        SABIN                           = EDGAR_SABIN_CELES
        CELES                           = EDGAR_SABIN_CELES
        IMP                             = EDGAR_SABIN_CELES
        LEO                             = EDGAR_SABIN_CELES
        GHOST                           = EDGAR_SABIN_CELES
        GREEN_SOLDIER                   = EDGAR_SABIN_CELES
        LOCKE                           = $01  ; 1
        MERCHANT                        = LOCKE
        BROWN_SOLDIER                   = LOCKE
        TERRA                           = $02  ; 2
        STRAGO_RELM_GAU_GOGO            = $03  ; 3
        STRAGO                          = STRAGO_RELM_GAU_GOGO
        RELM                            = STRAGO_RELM_GAU_GOGO
        GAU                             = STRAGO_RELM_GAU_GOGO
        GOGO                            = STRAGO_RELM_GAU_GOGO
        BANON                           = STRAGO_RELM_GAU_GOGO
        KEFKA                           = STRAGO_RELM_GAU_GOGO
        GESTAHL                         = STRAGO_RELM_GAU_GOGO
        CYAN_SHADOW_SETZER              = $04  ; 4
        CYAN                            = CYAN_SHADOW_SETZER
        SHADOW                          = CYAN_SHADOW_SETZER
        SETZER                          = CYAN_SHADOW_SETZER
        MOG_UMARO                       = $05  ; 5
        MOG                             = MOG_UMARO
        UMARO                           = MOG_UMARO
        RAINBOW                         = $06  ; 6
        VEHICLE                         = $07  ; 7
        ESPER_TERRA                     = $08  ; 8
        EDGAR_SABIN_CELES_ALT           = $09  ; 9
        MACHINERY_1                     = $0a  ; 10
        RAFT                            = $0b  ; 11
        MACHINERY_2                     = $0c  ; 12
        GUARDIAN                        = $0d  ; 13
        SEALED_GATE                     = $0e  ; 14
        VECTOR_CRANE                    = $0f  ; 15
        STATUE_SMOKE                    = $10  ; 16
        TREASURE_CHEST                  = $11  ; 17
        CHADARNOOK                      = $12  ; 18
        ROCK                            = $13  ; 19
        FALCON                          = $14  ; 20
        ODIN                            = $15  ; 21
        KEFKAS_TOWER_PARALLAX_1         = $16  ; 22
        KEFKAS_TOWER_PARALLAX_2         = $17  ; 23
        KEFKAS_TOWER_PARALLAX_3         = $18  ; 24
        DADALUMA                        = $19  ; 25
        GREEN_MAGICITE_SMOKE            = $1a  ; 26
        UNUSED_27                       = $1b  ; 27
        UNUSED_28                       = $1c  ; 28
        AIRSHIP_PARALLAX                = $1d  ; 29
        UNUSED_30                       = $1e  ; 30
        UNUSED_31                       = $1f  ; 31
.endenum

.scope MapSpritePal
        ARRAY_LENGTH = MAP_SPRITE_PAL::UNUSED_31 + 1
.endscope

.endif
.list on
