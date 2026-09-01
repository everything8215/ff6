; ------------------------------------------------------------------------------

.enum LIST_TYPE
        ITEM
        MAGIC
        LORE
        RAGE
        GENJU
        EQUIP

        COUNT
.endenum

.enum SCROLL_LIST_PAGE
        COUNT = LIST_TYPE::COUNT
.endenum

.enum UPDATE_LIST_TEXT
        COUNT = LIST_TYPE::COUNT
.endenum

.enum BG1_TEXT_COLOR
        DEFAULT = $20
        TEAL = $24
        GRAY = $28
        BLUE = $2c
        COLOR_BAR = $30
        WINDOW = $3c
.endenum

.enum BG3_TEXT_COLOR
        DEFAULT = $20
        GRAY = $24
        YELLOW = $28
        TEAL = $2c
        TEAL_ALT = $30
        BLUE = $38
.endenum

.enum MENU_TYPE
        FIELD
        NAME_CHANGE
        GAME_LOAD
        SHOP
        PARTY
        ITEM_DETAILS
        BUSHIDO_NAME
        COLOSSEUM
        FINAL_ORDER

        COUNT
.endenum

.enum MENU_STATE
        FADE_OUT                        ; = $00 // 0
        FADE_IN                         ; = $01 // 1
        WAIT_FADE                       ; = $02 // 2

        FIELD_MENU_RETURN               ; = $03 // 3
        FIELD_MENU_INIT                 ; = $04 // 4
        FIELD_MENU_SELECT               ; = $05 // 5
        FIELD_MENU_CHAR                 ; = $06 // 6

        ITEM_INIT                       ; = $07 // 7
        ITEM_SELECT                     ; = $08 // 8

        SKILLS_INIT                     ; = $09 // 9
        SKILLS_SELECT                   ; = $0a // 10

        STATUS_INIT                     ; = $0b // 11
        STATUS_WAIT                     ; = $0c // 12

        CONFIG_INIT                     ; = $0d // 13
        CONFIG_SELECT                   ; = $0e // 14

        ORDER_SELECT                    ; = $0f // 15
        ORDER_MOVE                      ; = $10 // 16
        ORDER_SWAP                      ; = $11 // 17
        ORDER_ROW                       ; = $12 // 18

        SAVE_INIT                       ; = $13 // 19
        SAVE_SELECT                     ; = $14 // 20
        SAVE_CONFIRM_INIT               ; = $15 // 21
        SAVE_CONFIRM_SELECT             ; = $16 // 22

        ITEM_OPTIONS                    ; = $17 // 23
        ITEM_RARE                       ; = $18 // 24
        ITEM_MOVE                       ; = $19 // 25

        SKILLS_MAGIC                    ; = $1a // 26
        SKILLS_LORE                     ; = $1b // 27
        SKILLS_DANCE                    ; = $1c // 28
        SKILLS_RAGE                     ; = $1d // 29
        SKILLS_GENJU_SELECT             ; = $1e // 30

        UNUSED_1F                       ; = $1f // 31

        LOAD_INIT                       ; = $20 // 32
        LOAD_SELECT                     ; = $21 // 33
        LOAD_CONFIRM_INIT               ; = $22 // 34
        LOAD_CONFIRM                    ; = $23 // 35

        SHOP_INIT                       ; = $24 // 36
        SHOP_OPTIONS                    ; = $25 // 37
        SHOP_BUY_SELECT                 ; = $26 // 38
        SHOP_BUY_QTY                    ; = $27 // 39
        SHOP_BUY_RETURN                 ; = $28 // 40
        SHOP_SELL_SELECT                ; = $29 // 41
        SHOP_SELL_QTY                   ; = $2a // 42
        SHOP_SELL_RETURN                ; = $2b // 43

        PARTY_INIT                      ; = $2c // 44
        PARTY_SELECT_1                  ; = $2d // 45
        PARTY_SELECT_2                  ; = $2e // 46

        MENU_STATE_2F                   ; = $2f // 47
        MENU_STATE_30                   ; = $30 // 48
        MENU_STATE_31                   ; = $31 // 49
        MENU_STATE_32                   ; = $32 // 50

        SKILLS_BLITZ                    ; = $33 // 51
        SKILLS_GENJU_ERROR              ; = $34 // 52

        EQUIP_INIT                      ; = $35 // 53
        EQUIP_OPTIONS                   ; = $36 // 54

        FIELD_PARTY_SELECT              ; = $37 // 55
        PARTY_EQUIP_INIT                ; = $38 // 56
        PARTY_EQUIP                     ; = $39 // 57

        MAGIC_TARGET_INIT               ; = $3a // 58
        MAGIC_TARGET_SINGLE             ; = $3b // 59
        MAGIC_TARGET_RETURN             ; = $3c // 60
        MAGIC_TARGET_MULTI              ; = $3d // 61

        SKILLS_BUSHIDO                  ; = $3e // 62

        BUSHIDO_NAME_INIT               ; = $3f // 63
        BUSHIDO_NAME_2                  ; = $40 // 64
        BUSHIDO_NAME_3                  ; = $41 // 65

        PARTY_STATUS_INIT               ; = $42 // 66
        PARTY_STATUS_WAIT               ; = $43 // 67

        MENU_STATE_44                   ; = $44 // 68
        MENU_STATE_45                   ; = $45 // 69
        MENU_STATE_46                   ; = $46 // 70

        CMD_ARRANGE_INIT                ; = $47 // 71
        CMD_ARRANGE_CHAR_SELECT         ; = $48 // 72

        CTRL_CONFIG_INIT                ; = $49 // 73
        CTRL_CONFIG_SELECT              ; = $4a // 74

        CHAR_CTRL_INIT                  ; = $4b // 75
        CHAR_CTRL_SELECT                ; = $4c // 76

        SKILLS_GENJU_DETAIL             ; = $4d // 77

        BUSHIDO_NAME_SCROLL_1           ; = $4e // 78
        BUSHIDO_NAME_SCROLL_2           ; = $4f // 79

        CONFIG_SCROLL_DOWN              ; = $50 // 80
        CONFIG_SCROLL_UP                ; = $51 // 81

        SAVE_FADE_IN                    ; = $52 // 82
        SAVE_FADE_OUT                   ; = $53 // 83
        SAVE_WAIT_FADE                  ; = $54 // 84

        EQUIP_SLOT_SELECT               ; = $55 // 85
        EQUIP_REMOVE_SELECT             ; = $56 // 86
        EQUIP_ITEM_SELECT               ; = $57 // 87

        RELIC_INIT                      ; = $58 // 88
        RELIC_OPTIONS                   ; = $59 // 89
        RELIC_SLOT_SELECT               ; = $5a // 90
        RELIC_ITEM_SELECT               ; = $5b // 91
        RELIC_REMOVE_SELECT             ; = $5c // 92

        NAME_CHANGE_INIT                ; = $5d // 93

        ITEM_DETAILS_2                  ; = $5e // 94
        NAME_CHANGE_SELECT              ; = $5f // 95
        NAME_CHANGE_SCROLL_DOWN         ; = $60 // 96
        NAME_CHANGE_SCROLL_UP           ; = $61 // 97

        CMD_ARRANGE_SELECT_1            ; = $62 // 98
        CMD_ARRANGE_SELECT_2            ; = $63 // 99

        ITEM_DETAILS_1                  ; = $64 // 100
        H_SCROLL                        ; = $65 // 101

        PARTY_FADE_IN                   ; = $66 // 102
        PARTY_FADE_OUT                  ; = $67 // 103
        PARTY_WAIT_FADE                 ; = $68 // 104
        PARTY_ERROR                     ; = $69 // 105

        STATUS_GOGO                     ; = $6a // 106

        MENU_STATE_6B                   ; = $6b // 107

        EQUIP_WAIT_MSG                  ; = $6c // 108
        EQUIP_OPTIMUM_RETURN            ; = $6d // 109
        EQUIP_EMPTY_RETURN              ; = $6e // 110

        ITEM_CHAR_INIT                  ; = $6f // 111
        ITEM_CHAR_SELECT                ; = $70 // 112

        COLOSSEUM_ITEM_INIT             ; = $71 // 113
        COLOSSEUM_ITEM_SELECT           ; = $72 // 114

        FINAL_ORDER_INIT                ; = $73 // 115
        FINAL_ORDER_SELECT              ; = $74 // 116

        COLOSSEUM_CHAR_INIT             ; = $75 // 117
        COLOSSEUM_CHAR_SELECT           ; = $76 // 118

        ITEM_CHAR_RETURN                ; = $77 // 119

        MENU_STATE_78                   ; = $78 // 120

        RELIC_SLOT_CHAR_CHANGE          ; = $79 // 121
        RELIC_REMOVE_CHAR_CHANGE        ; = $7a // 122

        MENU_STATE_7B                   ; = $7b // 123
        MENU_STATE_7C                   ; = $7c // 124

        PARTY_STATUS_RETURN             ; = $7d // 125

        EQUIP_SLOT_CHAR_CHANGE          ; = $7e // 126
        EQUIP_REMOVE_CHAR_CHANGE        ; = $7f // 127

        COUNT

        TERMINATE                       = $ff
.endenum

.enum ENDING_STATE

        FADE_OUT                        ; = $00 // 0
        WAIT_FADE                       ; = $01 // 1
        CLOUDS_1                        ; = $02 // 2
        FADE_ENDING                     ; = $03 // 3
        CLOUDS_2                        ; = $04 // 4
        CLOUDS_3                        ; = $05 // 5
        ENDING_STATE_6                  ; = $06 // 6
        ENDING_STATE_7                  ; = $07 // 7
        ENDING_STATE_8                  ; = $08 // 8

        TINY_AIRSHIP_1                  ; = $09 // 9
        TINY_AIRSHIP_2                  ; = $0a // 10
        TINY_AIRSHIP_3                  ; = $0b // 11

        SEA_BOAT_1                      ; = $0c // 12
        SEA_BOAT_2                      ; = $0d // 13
        ENDING_STATE_14                 ; = $0e // 14
        ENDING_STATE_15                 ; = $0f // 15

        SEA_AIRSHIP_1                   ; = $10 // 16
        SEA_AIRSHIP_2                   ; = $11 // 17
        ENDING_STATE_18                 ; = $12 // 18
        ENDING_STATE_19                 ; = $13 // 19

        LAND_BIRDS_1                    ; = $14 // 20
        LAND_BIRDS_2                    ; = $15 // 21
        ENDING_STATE_22                 ; = $16 // 22
        ENDING_STATE_23                 ; = $17 // 23

        LAND_1                          ; = $18 // 24
        ENDING_STATE_25                 ; = $19 // 25
        ENDING_STATE_26                 ; = $1a // 26
        ENDING_STATE_27                 ; = $1b // 27

        BIG_AIRSHIP                     ; = $1c // 28
        ENDING_STATE_29                 ; = $1d // 29
        ENDING_STATE_30                 ; = $1e // 30
        ENDING_STATE_31                 ; = $1f // 31

        BIG_JET_1                       ; = $20 // 32
        BIG_JET_2                       ; = $21 // 33
        ENDING_STATE_34                 ; = $22 // 34
        ENDING_STATE_35                 ; = $23 // 35
        ENDING_STATE_36                 ; = $24 // 36
        ENDING_STATE_37                 ; = $25 // 37
        ENDING_STATE_38                 ; = $26 // 38
        ENDING_STATE_39                 ; = $27 // 39

        SHADOW_1                        ; = $28 // 40
        SHADOW_2                        ; = $29 // 41
        SHADOW_3                        ; = $2a // 42
        SHADOW_4                        ; = $2b // 43
        ENDING_STATE_44                 ; = $2c // 44

        BOOK_1                          ; = $2d // 45
        BOOK_2                          ; = $2e // 46
        BOOK_3                          ; = $2f // 47
        BOOK_4                          ; = $30 // 48
        ENDING_STATE_49                 ; = $31 // 49

        CYAN_1                          ; = $32 // 50
        CYAN_2                          ; = $33 // 51
        CYAN_3                          ; = $34 // 52
        CYAN_4                          ; = $35 // 53
        ENDING_STATE_54                 ; = $36 // 54
        ENDING_STATE_55                 ; = $37 // 55

        FADE_CREDITS                    ; = $38 // 56
        ENDING_STATE_57                 ; = $39 // 57
        ENDING_STATE_58                 ; = $3a // 58
        ENDING_STATE_59                 ; = $3b // 59

        MOG_1                           ; = $3c // 60
        MOG_2                           ; = $3d // 61
        MOG_3                           ; = $3e // 62
        MOG_4                           ; = $3f // 63

        EDGAR_SABIN_1                   ; = $40 // 64
        EDGAR_SABIN_2                   ; = $41 // 65
        EDGAR_SABIN_3                   ; = $42 // 66
        EDGAR_SABIN_4                   ; = $43 // 67
        EDGAR_SABIN_5                   ; = $44 // 68
        EDGAR_SABIN_6                   ; = $45 // 69

        GOGO_1                          ; = $46 // 70
        GOGO_2                          ; = $47 // 71
        GOGO_3                          ; = $48 // 72
        GOGO_4                          ; = $49 // 73

        AND_YOU_1                       ; = $4a // 74
        AND_YOU_2                       ; = $4b // 75
        AND_YOU_3                       ; = $4c // 76
        AND_YOU_4                       ; = $4d // 77
        ENDING_STATE_78                 ; = $4e // 78

        EDGAR_SABIN_7                   ; = $4f // 79

        GAU_1                           ; = $50 // 80
        GAU_2                           ; = $51 // 81
        GAU_3                           ; = $52 // 82
        GAU_4                           ; = $53 // 83
        ENDING_STATE_84                 ; = $54 // 84
        ENDING_STATE_85                 ; = $55 // 85
        ENDING_STATE_86                 ; = $56 // 86
        ENDING_STATE_87                 ; = $57 // 87
        ENDING_STATE_88                 ; = $58 // 88
        ENDING_STATE_89                 ; = $59 // 89

        TERRA_1                         ; = $5a // 90
        TERRA_2                         ; = $5b // 91
        TERRA_3                         ; = $5c // 92
        TERRA_4                         ; = $5d // 93
        ENDING_STATE_94                 ; = $5e // 94
        ENDING_STATE_95                 ; = $5f // 95
        ENDING_STATE_96                 ; = $60 // 96
        ENDING_STATE_97                 ; = $61 // 97
        ENDING_STATE_98                 ; = $62 // 98
        ENDING_STATE_99                 ; = $63 // 99

        LOCKE_CELES_1                   ; = $64 // 100
        LOCKE_CELES_2                   ; = $65 // 101
        LOCKE_CELES_3                   ; = $66 // 102
        LOCKE_CELES_4                   ; = $67 // 103
        LOCKE_CELES_5                   ; = $68 // 104
        LOCKE_CELES_6                   ; = $69 // 105
        LOCKE_CELES_7                   ; = $6a // 106
        ENDING_STATE_107                ; = $6b // 107
        ENDING_STATE_108                ; = $6c // 108
        ENDING_STATE_109                ; = $6d // 109

        RELM_1                          ; = $6e // 110
        RELM_2                          ; = $6f // 111
        RELM_3                          ; = $70 // 112
        RELM_4                          ; = $71 // 113
        ENDING_STATE_114                ; = $72 // 114
        ENDING_STATE_115                ; = $73 // 115
        ENDING_STATE_116                ; = $74 // 116
        ENDING_STATE_117                ; = $75 // 117
        ENDING_STATE_118                ; = $76 // 118
        ENDING_STATE_119                ; = $77 // 119

        STRAGO_1                        ; = $78 // 120
        STRAGO_2                        ; = $79 // 121
        STRAGO_3                        ; = $7a // 122
        STRAGO_4                        ; = $7b // 123
        ENDING_STATE_124                ; = $7c // 124
        ENDING_STATE_125                ; = $7d // 125
        ENDING_STATE_126                ; = $7e // 126
        ENDING_STATE_127                ; = $7f // 127
        ENDING_STATE_128                ; = $80 // 128
        ENDING_STATE_129                ; = $81 // 129

        SETZER_1                        ; = $82 // 130
        SETZER_2                        ; = $83 // 131
        SETZER_3                        ; = $84 // 132
        SETZER_4                        ; = $85 // 133
        SETZER_5                        ; = $86 // 134

        UMARO_1                         ; = $87 // 135
        UMARO_2                         ; = $88 // 136
        UMARO_3                         ; = $89 // 137
        UMARO_4                         ; = $8a // 138

        COUNT

        TERMINATE                       = $ff
.endenum

; ------------------------------------------------------------------------------
