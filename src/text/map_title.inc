.list off
.ifndef MAP_TITLE_INC
MAP_TITLE_INC = 1

.global MapTitle, MapTitlePtrs

.scope MAP_TITLE

        .include "assets/text/map_title.ptr"

        ; BLANK                           = 0
        ; INN                             = 1
        ; WEAPON_SHOP                     = 2
        ; ARMOR_SHOP                      = 3
        ; ARSENAL                         = 4
        ; RELICS                          = 5
        ; ITEM_SHOP                       = 6
        ; CAFE                            = 7
        ; ENGINE_ROOM                     = 8
        ; BASEMENT_1                      = 9
        ; BASEMENT_2                      = 10
        ; BASEMENT_3                      = 11
        ; BASEMENT_4                      = 12
        ; FLOOR_1                         = 13
        ; FLOOR_2                         = 14
        ; FLOOR_3                         = 15
        ; FLOOR_4                         = 16
        ; FLOOR_5                         = 17
        ; FLOOR_6                         = 18
        ; FLOOR_7                         = 19
        ; FLOOR_8                         = 20
        ; FLOOR_9                         = 21
        ; FLOOR_10                        = 22
        ; CHOCOBO_STABLE                  = 23
        ; FIGARO_CASTLE                   = 24
        ; SOUTH_FIGARO                    = 25
        ; RETURNERS_HIDEOUT               = 26
        ; ELDERS_HOUSE                    = 27
        ; DUNCANS_HOUSE                   = 28
        ; MT_KOLTS                        = 29
        ; KINGS_ROOM                      = 30
        ; MOOGLES_CAVE                    = 31
        ; NARSHE                          = 32
        ; AUCTION_HOUSE                   = 33
        ; OWZERS_HOUSE                    = 34
        ; BAREN_FALLS                     = 35
        ; MOBLIZ                          = 36
        ; NIKEAH                          = 37
        ; TZEN                            = 38
        ; RETURNERS_HIDEOUT_UNUSED        = 39  ; unused
        ; LETE_RIVER                      = 40
        ; IMPERIAL_CAMP                   = 41
        ; DOMA_CASTLE                     = 42
        ; PHANTOM_FOREST                  = 43
        ; SERPENT_TRENCH                  = 44
        ; KOHLINGEN                       = 45
        ; ZOZO                            = 46
        ; JIDOOR                          = 47
        ; OPERA_HOUSE                     = 48
        ; VECTOR                          = 49
        ; IMPERIAL_CASTLE                 = 50
        ; MAGITEK_RES_FACILITY            = 51
        ; MARANDA                         = 52
        ; ALBROOK                         = 53
        ; IMPERIAL_BASE                   = 54
        ; SEALED_GATE                     = 55
        ; THAMASA                         = 56
        ; COLOSSEUM                       = 57
        ; DARILLS_TOMB_B1                 = 58
        ; THE_FLOATING_LAND               = 59
        ; ESPERVILLE                      = 60
        ; MT_ZOZO                         = 61
        ; MAGITEK_FACTORY                 = 62
        ; MT_CRESCENT                     = 63
        ; CLASSROOM                       = 64
        ; KEFKAS_TOWER                    = 65
        ; ADV_BATTLE_TACTICS              = 66
        ; BATTLE_TACTICS                  = 67
        ; ENVIRONMENTAL_SCIENCE           = 68
        ; CAVE_TO_THE_SEALED_GATE         = 69
        ; GENERAL_STORE                   = 70
        ; PHOENIX_CAVE                    = 71
        ; CAVE_IN_THE_VELDT               = 72

.endscope

.endif
.list on
