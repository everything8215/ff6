.ifndef MENU_TEXT_INC
MENU_TEXT_INC = 1

; ------------------------------------------------------------------------------

; misc. individual text characters
.define ZERO_CHAR                       z"0"
.define COLON_CHAR                      z":"
.define GAUGE_EMPTY_CHAR                z"{gauge_empty}"
.define GAUGE_FULL_CHAR                 z"{gauge_full}"
.define GAUGE_LEFT_CHAR                 z"{gauge_left}"
.define GAUGE_RIGHT_CHAR                z"{gauge_right}"

; ------------------------------------------------------------------------------

; field menu text strings
.define MAIN_MENU_WOUNDED               {z"Wounded "}

.define CHAR_BLOCK_1_LEVEL              BG1A, {10, 5}, {"LV"}
.define CHAR_BLOCK_1_HP                 BG1A, {10, 6}, {"HP"}
.define CHAR_BLOCK_1_MP                 BG1A, {10, 7}, {"MP"}
.define CHAR_BLOCK_1_HP_SLASH           BG1A, {17, 6}, {"/"}
.define CHAR_BLOCK_1_MP_SLASH           BG1A, {17, 7}, {"/"}

.define CHAR_BLOCK_2_LEVEL              BG1A, {10, 11}, {"LV"}
.define CHAR_BLOCK_2_HP                 BG1A, {10, 12}, {"HP"}
.define CHAR_BLOCK_2_MP                 BG1A, {10, 13}, {"MP"}
.define CHAR_BLOCK_2_HP_SLASH           BG1A, {17, 12}, {"/"}
.define CHAR_BLOCK_2_MP_SLASH           BG1A, {17, 13}, {"/"}

.define CHAR_BLOCK_3_LEVEL              BG1A, {10, 17}, {"LV"}
.define CHAR_BLOCK_3_HP                 BG1A, {10, 18}, {"HP"}
.define CHAR_BLOCK_3_MP                 BG1A, {10, 19}, {"MP"}
.define CHAR_BLOCK_3_HP_SLASH           BG1A, {17, 18}, {"/"}
.define CHAR_BLOCK_3_MP_SLASH           BG1A, {17, 19}, {"/"}

.define CHAR_BLOCK_4_LEVEL              BG1A, {10, 23}, {"LV"}
.define CHAR_BLOCK_4_HP                 BG1A, {10, 24}, {"HP"}
.define CHAR_BLOCK_4_MP                 BG1A, {10, 25}, {"MP"}
.define CHAR_BLOCK_4_HP_SLASH           BG1A, {17, 24}, {"/"}
.define CHAR_BLOCK_4_MP_SLASH           BG1A, {17, 25}, {"/"}

.define MAIN_MENU_ITEM                  BG3A, {24, 3}, {"Item"}
.define MAIN_MENU_SKILLS                BG3A, {24, 5}, {"Skills"}
.define MAIN_MENU_EQUIP                 BG3A, {24, 7}, {"Equip"}
.define MAIN_MENU_RELIC                 BG3A, {24, 9}, {"Relic"}
.define MAIN_MENU_STATUS                BG3A, {24, 11}, {"Status"}
.define MAIN_MENU_CONFIG                BG3A, {24, 13}, {"Config"}
.define MAIN_MENU_SAVE                  BG3A, {24, 15}, {"Save"}
.define MAIN_MENU_TIME                  BG3A, {25, 17}, {"Time"}
.define MAIN_MENU_COLON                 BG3A, {27, 18}, {":"}
.define MAIN_MENU_STEPS                 BG3A, {23, 21}, {"Steps"}
.define MAIN_MENU_GIL                   BG3A, {23, 24}, {"Gp"}

.define GAME_LOAD_YES                   BG3A, {26, 9}, {"Yes"}
.define GAME_LOAD_NO                    BG3A, {26, 11}, {"No"}
.define GAME_LOAD_MSG_1                 BG3A, {23, 3}, {"This"}
.define GAME_LOAD_MSG_2                 BG3A, {23, 5}, {"data?"}

.define GAME_SAVE_MSG_1                 BG3A, {23, 3}, {"Erasing"}
.define GAME_SAVE_MSG_2                 BG3A, {23, 5}, {"data."}
.define GAME_SAVE_MSG_3                 BG3A, {23, 7}, {"Okay?"}

.define MAIN_MENU_ORDER                 BG3B, {26, 3}, {"Order"}

; ------------------------------------------------------------------------------

; colosseum menu text strings
.define COLOSSEUM_ITEM_TITLE            BG3A, {2, 3}, {"Colosseum"}
.define COLOSSEUM_ITEM_MSG              BG3A, {13, 3}, {"Select an Item"}

.define COLOSSEUM_CHAR_BLANK_NAME       BG3A, {22, 16}, {"      "}
.define COLOSSEUM_CHAR_MSG              BG3A, {6, 19}, {"Select the challenger"}
.define COLOSSEUM_UNKNOWN_PRIZE         BG3A, {2, 3}, {"?????????????"}

; ------------------------------------------------------------------------------

; skills menu strings
.define SKILLS_LIST_GENJU               BG3A, {2, 3}, {"Espers"}
.define SKILLS_LIST_MAGIC               BG3A, {2, 5}, {"Magic"}
.define SKILLS_LIST_BUSHIDO             BG3A, {2, 9}, {"SwdTech"}
.define SKILLS_LIST_BLITZ               BG3A, {2, 11}, {"Blitz"}
.define SKILLS_LIST_LORE                BG3A, {2, 13}, {"Lore"}
.define SKILLS_LIST_RAGE                BG3A, {2, 15}, {"Rage"}
.define SKILLS_LIST_DANCE               BG3A, {2, 17}, {"Dance"}

.define SKILLS_MP_COST                  BG3B, {23, 5}, {"MP_    "}
.define SKILLS_LORE_TITLE               BG3B, {23, 5}, {"Lore"}
.define SKILLS_RAGE_TITLE               BG3B, {23, 5}, {"Rage"}
.define SKILLS_DANCE_TITLE              BG3B, {23, 5}, {"Dance"}
.define SKILLS_GENJU_TITLE              BG3B, {23, 5}, {"Espers"}
.define SKILLS_BLITZ_TITLE              BG3B, {23, 5}, {"Blitz"}
.define SKILLS_BUSHIDO_TITLE            BG3B, {23, 5}, {"SwdTech"}

.define SKILLS_CHAR_LEVEL               BG1B, {18, 7}, {"LV"}
.define SKILLS_CHAR_HP                  BG1B, {18, 9}, {"HP"}
.define SKILLS_CHAR_MP                  BG1B, {18, 11}, {"MP"}
.define SKILLS_CHAR_HP_SLASH            BG1B, {25, 9}, {"/"}
.define SKILLS_CHAR_MP_SLASH            BG1B, {25, 11}, {"/"}

.define GENJU_EQUIP_ERROR_MSG           {" has it!"}
.define GENJU_LEARN_PCT                 BG1B, {24, 15}, {"Skill"}
.define GENJU_LEARN_RATE                BG1B, {13, 15}, {"Learn.Rate"}
.define GENJU_AT_LEVEL_UP               {z"At level up..."}

; ------------------------------------------------------------------------------

; item menu text strings
.define ITEM_TITLE                      BG3A, {2, 3}, {"Item"}
.define ITEM_OPTION_USE                 BG3A, {10, 3}, {"USE"}
.define ITEM_OPTION_ARRANGE             BG3A, {15, 3}, {"ARRANGE"}
.define ITEM_OPTION_RARE                BG3A, {24, 3}, {"RARE"}

.define ITEM_UNKNOWN_ATTACK             BG3B, {29, 23}, {"???"}
.define ITEM_STRENGTH                   BG3B, {19, 15}, {"Vigor"}
.define ITEM_STAMINA                    BG3B, {19, 19}, {"Stamina"}
.define ITEM_MAG_PWR                    BG3B, {19, 21}, {"Mag.Pwr"}
.define ITEM_EVADE                      BG3B, {19, 27}, {"Evade %"}
.define ITEM_MAG_EVADE                  BG3B, {19, 31}, {"MBlock%"}
.define ITEM_SPEED                      BG3B, {19, 17}, {"Speed"}
.define ITEM_ATTACK_PWR                 BG3B, {19, 23}, {"Bat.Pwr"}
.define ITEM_DEFENSE                    BG3B, {19, 25}, {"Defense"}
.define ITEM_MAG_DEF                    BG3B, {19, 29}, {"Mag.Def"}
.define ITEM_ELEMENT_HALF               BG3A, {2, 13}, {"50% Dmg"}
.define ITEM_ELEMENT_ABSORB             BG3A, {16, 13}, {"Absorb HP"}
.define ITEM_ELEMENT_NULL               BG3A, {2, 17}, {"No Effect"}
.define ITEM_ELEMENT_WEAK               BG3A, {16, 17}, {"Weak pt"}
.define ITEM_ATTACK_ELEMENT             BG3A, {2, 13}, {"Attack"}

.define ITEM_STAT_SEP(yy)               BG3B, {27, yy}, {"{2dot}"}
.define ITEM_USAGE_MSG                  {" can be used by:"}

.define ITEM_BUSHIDO                    BG3B, {19, 7}, {"SwdTech"}
.define ITEM_RUNIC                      BG3B, {19, 9}, {"Runic"}
.define ITEM_2HAND                      BG3B, {19, 11}, {"2-hand"}
.define ITEM_OWNED                      BG3A, {2, 7}, {"Owned:"}
.define ITEM_BLANK_QTY                  BG3A, {27, 9}, {"   "}

.define EVADE_MODIFIER_0                {"  0"}
.define EVADE_MODIFIER_PLUS_10          {"+10"}
.define EVADE_MODIFIER_PLUS_20          {"+20"}
.define EVADE_MODIFIER_PLUS_30          {"+30"}
.define EVADE_MODIFIER_PLUS_40          {"+40"}
.define EVADE_MODIFIER_PLUS_50          {"+50"}
.define EVADE_MODIFIER_MINUS_10         {"-10"}
.define EVADE_MODIFIER_MINUS_20         {"-20"}
.define EVADE_MODIFIER_MINUS_30         {"-30"}
.define EVADE_MODIFIER_MINUS_40         {"-40"}
.define EVADE_MODIFIER_MINUS_50         {"-50"}

.define STAT_MODIFIER_0                 {z" 0"}
.define STAT_MODIFIER_PLUS_1            {z"+1"}
.define STAT_MODIFIER_PLUS_2            {z"+2"}
.define STAT_MODIFIER_PLUS_3            {z"+3"}
.define STAT_MODIFIER_PLUS_4            {z"+4"}
.define STAT_MODIFIER_PLUS_5            {z"+5"}
.define STAT_MODIFIER_PLUS_6            {z"+6"}
.define STAT_MODIFIER_PLUS_7            {z"+7"}
.define STAT_MODIFIER_MINUS_1           {z"-1"}
.define STAT_MODIFIER_MINUS_2           {z"-2"}
.define STAT_MODIFIER_MINUS_3           {z"-3"}
.define STAT_MODIFIER_MINUS_4           {z"-4"}
.define STAT_MODIFIER_MINUS_5           {z"-5"}
.define STAT_MODIFIER_MINUS_6           {z"-6"}
.define STAT_MODIFIER_MINUS_7           {z"-7"}

; ------------------------------------------------------------------------------

; equip/relic menu text strings
.define EQUIP_RHAND                     BG3A, {2, 7}, {"R-hand"}
.define EQUIP_LHAND                     BG3A, {2, 9}, {"L-hand"}
.define EQUIP_HEAD                      BG3A, {2, 11}, {"Head"}
.define EQUIP_BODY                      BG3A, {2, 13}, {"Body"}
.define EQUIP_RELIC1                    BG3A, {2, 11}, {"Relic"}
.define EQUIP_RELIC2                    BG3A, {2, 13}, {"Relic"}
.define EQUIP_BLANK_OPTIONS             BG3A, {2, 3}, {"                            "}
.define EQUIP_TITLE_EQUIP               BG3A, {24, 3}, {"EQUIP"}
.define EQUIP_TITLE_REMOVE              BG3A, {24, 3}, {"REMOVE"}
.define EQUIP_OPTION_EQUIP              BG3A, {2, 3}, {"EQUIP"}
.define EQUIP_OPTION_OPTIMUM            BG3A, {9, 3}, {"OPTIMUM"}
.define EQUIP_OPTION_REMOVE             BG3A, {18, 3}, {"RMOVE"}
.define EQUIP_OPTION_EMPTY              BG3A, {25, 3}, {"EMPTY"}
.define RELIC_OPTION_EQUIP              BG3A, {4, 3}, {"EQUIP"}
.define RELIC_OPTION_REMOVE             BG3A, {11, 3}, {"REMOVE"}

.define EQUIP_STRENGTH                  BG3A, {16, 17}, {"Vigor"}
.define EQUIP_SPEED                     BG3A, {16, 19}, {"Speed"}
.define EQUIP_STAMINA                   BG3A, {16, 21}, {"Stamina"}
.define EQUIP_MAG_PWR                   BG3A, {16, 23}, {"Mag.Pwr"}
.define EQUIP_ATTACK_PWR                BG3A, {16, 25}, {"Bat.Pwr"}
.define EQUIP_DEFENSE                   BG3A, {16, 27}, {"Defense"}
.define EQUIP_EVADE                     BG3A, {16, 29}, {"Evade %"}
.define EQUIP_MAG_DEF                   BG3A, {16, 31}, {"Mag.Def"}
.define EQUIP_MAG_EVADE                 BG3A, {16, 33}, {"MBlock%"}
.define EQUIP_ARROW(yy)                 BG3A, {26, yy}, {"{rightarrow}"}

.define EQUIP_EMPTY_MSG                 BG3A, {13, 3}, {"Empty"}
.define EQUIP_OPTIMUM_MSG               BG3A, {12, 3}, {"Optimum"}
.define RELIC_EMPTY_MSG                 BG3A, {13, 5}, {"Empty"}
.define RELIC_OPTIMUM_MSG               BG3A, {12, 5}, {"Optimum"}
.define EQUIP_CHANGED_MSG               BG3A, {6, 7}, {"Equipment changed."}

; these are unused in the English translation
.define PARTY_EQUIP_SLOT1_RHAND         BG1A, {3, 4}, {$9f,$2d,$00}  ; みぎ
.define PARTY_EQUIP_SLOT1_LHAND         BG1A, {17, 4}, {$63,$3f,$a9,$00}  ; ひだり
.define PARTY_EQUIP_SLOT1_HEAD          BG1A, {3, 6}, {$8b,$7f,$9d,$00}  ; あたま
.define PARTY_EQUIP_SLOT1_BODY          BG1A, {17, 6}, {$6b,$a7,$3f,$00}  ; からだ
.define PARTY_EQUIP_SLOT1_RELIC1        BG1A, {3, 8}, {$8a,$6e,$54,$00}  ; アク１
.define PARTY_EQUIP_SLOT1_RELIC2        BG1A, {17, 8}, {$8a,$6e,$55,$00}  ; アク２

.define PARTY_EQUIP_SLOT2_RHAND         BG1A, {3, 12}, {$9f,$2d,$00}  ; みぎ
.define PARTY_EQUIP_SLOT2_LHAND         BG1A, {17, 12}, {$63,$3f,$a9,$00}  ; ひだり
.define PARTY_EQUIP_SLOT2_HEAD          BG1A, {3, 14}, {$8b,$7f,$9d,$00}  ; あたま
.define PARTY_EQUIP_SLOT2_BODY          BG1A, {17, 14}, {$6b,$a7,$3f,$00}  ; からだ
.define PARTY_EQUIP_SLOT2_RELIC1        BG1A, {3, 16}, {$8a,$6e,$54,$00}  ; アク１
.define PARTY_EQUIP_SLOT2_RELIC2        BG1A, {17, 16}, {$8a,$6e,$55,$00}  ; アク２

.define PARTY_EQUIP_SLOT3_RHAND         BG1A, {3, 20}, {$9f,$2d,$00}  ; みぎ
.define PARTY_EQUIP_SLOT3_LHAND         BG1A, {17, 20}, {$63,$3f,$a9,$00}  ; ひだり
.define PARTY_EQUIP_SLOT3_HEAD          BG1A, {3, 22}, {$8b,$7f,$9d,$00}  ; あたま
.define PARTY_EQUIP_SLOT3_BODY          BG1A, {17, 22}, {$6b,$a7,$3f,$00}  ; からだ
.define PARTY_EQUIP_SLOT3_RELIC1        BG1A, {3, 24}, {$8a,$6e,$54,$00}  ; アク１
.define PARTY_EQUIP_SLOT3_RELIC2        BG1A, {17, 24}, {$8a,$6e,$55,$00}  ; アク２

.define PARTY_EQUIP_SLOT4_RHAND         BG1A, {3, 28}, {$9f,$2d,$00}  ; みぎ
.define PARTY_EQUIP_SLOT4_LHAND         BG1A, {17, 28}, {$63,$3f,$a9,$00}  ; ひだり
.define PARTY_EQUIP_SLOT4_HEAD          BG1A, {3, 30}, {$8b,$7f,$9d,$00}  ; あたま
.define PARTY_EQUIP_SLOT4_BODY          BG1A, {17, 30}, {$6b,$a7,$3f,$00}  ; からだ
.define PARTY_EQUIP_SLOT4_RELIC1        BG1A, {3, 32}, {$8a,$6e,$54,$00}  ; アク１
.define PARTY_EQUIP_SLOT4_RELIC2        BG1A, {17, 32}, {$8a,$6e,$55,$00}  ; アク２

; ------------------------------------------------------------------------------

; party menu text strings

.define PARTY_LEVEL                     BG1A, {18, 8}, {"LV"}
.define PARTY_HP                        BG1A, {18, 10}, {"HP"}
.define PARTY_MP                        BG1A, {18, 12}, {"MP"}
.define PARTY_HP_SLASH                  BG1A, {25, 10}, {"/"}
.define PARTY_MP_SLASH                  BG1A, {25, 12}, {"/"}

.define PARTY_MSG                       BG1A, {10, 3}, {"Form   group(s).      "}
.define PARTY_TITLE                     BG1A, {2, 3}, {"Lineup"}
.define PARTY_ERROR_MSG1                BG1A, {10, 3}, {"You need   group(s)!"}
.define PARTY_ERROR_MSG2                BG1A, {10, 3}, {"No one there!       "}

; ------------------------------------------------------------------------------

; status menu text strings
.define STATUS_TITLE                    BG3A, {2, 2}, {"Status"}
.define STATUS_HP_SLASH                 BG1A, {17, 8}, {"/"}
.define STATUS_MP_SLASH                 BG1A, {17, 9}, {"/"}
.define STATUS_EVADE_PERCENT            BG3A, {29, 28}, {"%"}
.define STATUS_MAG_EVADE_PERCENT        BG3C, {29, 0}, {"%"}
.define STATUS_LEVEL                    BG1A, {10, 7}, {"LV"}
.define STATUS_HP                       BG1A, {10, 8}, {"HP"}
.define STATUS_MP                       BG1A, {10, 9}, {"MP"}
.define STATUS_STRENGTH                 BG3A, {3, 26}, {"Vigor"}
.define STATUS_STAMINA                  BG3A, {3, 30}, {"Stamina"}
.define STATUS_MAG_PWR                  BG3C, {3, 0}, {"Mag.Pwr"}
.define STATUS_EVADE                    BG3A, {16, 28}, {"Evade %"}
.define STATUS_MAG_EVADE                BG3C, {16, 0}, {"MBlock%"}
.define STATUS_STRENGTH_SEP             BG3A, {10, 26}, {"{2dot}"}
.define STATUS_SPEED_SEP                BG3A, {10, 28}, {"{2dot}"}
.define STATUS_STAMINA_SEP              BG3A, {10, 30}, {"{2dot}"}
.define STATUS_MAG_PWR_SEP              BG3C, {10, 0}, {"{2dot}"}
.define STATUS_DEFENSE_SEP              BG3A, {25, 26}, {"{2dot}"}
.define STATUS_EVADE_SEP                BG3A, {25, 28}, {"{2dot}"}
.define STATUS_ATTACK_PWR_SEP           BG3A, {25, 24}, {"{2dot}"}
.define STATUS_MAG_DEF_SEP              BG3A, {25, 30}, {"{2dot}"}
.define STATUS_MAG_EVADE_SEP            BG3C, {25, 0}, {"{2dot}"}
.define STATUS_SPEED                    BG3A, {3, 28}, {"Speed"}
.define STATUS_ATTACK_PWR               BG3A, {16, 24}, {"Bat.Pwr"}
.define STATUS_DEFENSE                  BG3A, {16, 26}, {"Defense"}
.define STATUS_MAG_DEF                  BG3A, {16, 30}, {"Mag.Def"}
.define STATUS_YOUR_EXP                 BG3A, {2, 16}, {"Your Exp:"}
.define STATUS_LEVEL_UP_EXP             BG3A, {2, 20}, {"For level up:"}

; ------------------------------------------------------------------------------

; shop menu text strings
.define SHOP_TYPE_1                     BG3A, {2, 3}, {"Weapon"}
.define SHOP_TYPE_2                     BG3A, {3, 3}, {"Armor"}
.define SHOP_TYPE_3                     BG3A, {3, 3}, {"Item"}
.define SHOP_TYPE_4                     BG3A, {2, 3}, {"Relics"}
.define SHOP_TYPE_5                     BG3A, {2, 3}, {"Vendor"}
.define SHOP_OPTIONS                    BG3A, {3, 7}, {"BUY  SELL  EXIT"}
.define SHOP_GIL_1                      BG3A, {28, 7}, {"GP"}
.define SHOP_GIL_2                      BG3A, {17, 11}, {"GP"}
.define SHOP_OWNED                      BG3A, {21, 9}, {"Owned:"}
.define SHOP_EQUIPPED                   BG3A, {21, 13}, {"Equipped:"}
.define SHOP_POWER                      BG3A, {3, 13}, {"Bat Pwr"}
.define SHOP_DEFENSE                    BG3A, {3, 13}, {"Defense"}
.define SHOP_DOTS                       BG3A, {14, 13}, {"_"}
.define SHOP_GREETING_MSG               BG3A, {11, 3}, {"Hi! Can I help you?"}
.define SHOP_BUY_MSG                    BG3A, {11, 3}, {"Help yourself!"}
.define SHOP_BUY_QTY_MSG                BG3A, {11, 3}, {"How many?"}
.define SHOP_SELL_MSG                   BG3A, {11, 3}, {"Whatcha got?"}
.define SHOP_SELL_QTY_MSG               BG3A, {11, 3}, {"How many?"}
.define SHOP_BYE_MSG                    BG3A, {11, 3}, {"Bye!          "}
.define SHOP_NOT_ENOUGH_GIL_MSG         BG3A, {11, 3}, {"You need more GP!"}
.define SHOP_TOO_MANY_MSG               BG3A, {11, 3}, {"Too many!       "}
.define SHOP_ONLY_ONE_MSG               BG3A, {11, 3}, {"One's plenty! "}

; ------------------------------------------------------------------------------

; config menu text strings
.define CONFIG_COLOR_ARROW_BLANK        BG1B, {22, 18}, {"       "}
.define CONFIG_COLOR_ARROW(xx)          BG1B, {xx, 18}, {"{uparrow}"}

.define CONFIG_CONTROLLER               BG1A, {3, 21}, {"Controller"}
.define CONFIG_WAIT                     BG1A, {22, 5}, {"Wait"}
.define CONFIG_FAST                     BG1A, {14, 8}, {"Fast"}
.define CONFIG_SLOW                     BG1A, {22, 8}, {"Slow"}
.define CONFIG_CMD_SHORT                BG1A, {22, 11}, {"Short"}
.define CONFIG_GAUGE_ON                 BG1A, {14, 13}, {"On"}
.define CONFIG_GAUGE_OFF                BG1A, {22, 13}, {"Off"}
.define CONFIG_STEREO                   BG1A, {14, 15}, {"Stereo"}
.define CONFIG_MONO                     BG1A, {22, 15}, {"Mono"}
.define CONFIG_MEMORY                   BG1A, {22, 17}, {"Memory"}
.define CONFIG_OPTIMUM                  BG1A, {14, 19}, {"Optimum"}
.define CONFIG_CTRL_MULTI               BG1A, {22, 21}, {"Multiple"}
.define CONFIG_BATTLE_SPEED_NUM         BG1A, {14, 7}, {"1 2 3 4 5 6"}
.define CONFIG_MSG_SPEED_NUM            BG1A, {14, 9}, {"1 2 3 4 5 6"}
.define CONFIG_CURSOR                   BG1A, {3, 17}, {"Cursor"}

.define CONFIG_TITLE                    BG3A, {24, 2}, {"Config"}
.define CONFIG_BATTLE_MODE              BG1A, {3, 5}, {"Bat.Mode"}
.define CONFIG_BATTLE_SPEED             BG1A, {3, 7}, {"Bat.Speed"}
.define CONFIG_MSG_SPEED                BG1A, {3, 9}, {"Msg.Speed"}
.define CONFIG_CMD_SET                  BG1A, {3, 11}, {"Cmd.Set"}
.define CONFIG_GAUGE                    BG1A, {3, 13}, {"Gauge"}
.define CONFIG_SOUND                    BG1A, {3, 15}, {"Sound"}
.define CONFIG_REEQUIP                  BG1A, {3, 19}, {"Reequip"}
.define CONFIG_ACTIVE                   BG1A, {14, 5}, {"Active"}
.define CONFIG_CMD_WINDOW               BG1A, {14, 11}, {"Window"}
.define CONFIG_RESET                    BG1A, {14, 17}, {"Reset"}
.define CONFIG_EMPTY                    BG1A, {22, 19}, {"Empty"}
.define CONFIG_CTRL_SINGLE              BG1A, {14, 21}, {"Single"}

.define CONFIG_MAGIC_ORDER              BG1B, {3, 5}, {"Mag.Order"}
.define CONFIG_WINDOW_LABEL             BG1B, {3, 13}, {"Window"}
.define CONFIG_COLOR                    BG1B, {3, 15}, {"Color"}
.define CONFIG_MAGIC_ORDER_A            BG1B, {14, 7}, {"A{2dot}"}
.define CONFIG_MAGIC_ORDER_B            BG1B, {14, 9}, {"B{2dot}"}
.define CONFIG_MAGIC_ORDER_C            BG1B, {14, 11}, {"C{2dot}"}
.define CONFIG_COLOR_BAR_R              BG1B, {18, 19}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define CONFIG_COLOR_BAR_G              BG1B, {18, 21}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define CONFIG_COLOR_BAR_B              BG1B, {18, 23}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define CONFIG_COLOR_R                  BG1B, {14, 19}, {"R"}
.define CONFIG_COLOR_G                  BG1B, {14, 21}, {"G"}
.define CONFIG_COLOR_B                  BG1B, {14, 23}, {"B"}
.define CONFIG_WINDOW_NUM               BG1B, {14, 13}, {"1 2 3 4 5 6 7 8"}
.define CONFIG_MAGIC_ORDER_NUM          BG1B, {14, 5}, {"1 2 3 4 5 6"}
.define CONFIG_FONT                     BG1B, {14, 15}, {"Font"}
.define CONFIG_WINDOW                   BG1B, {22, 15}, {"Window"}

.define CONFIG_RETURN                   BG1B, {25, 14}, {$a5,$47,$79,$00}  ; もどす (Return)
.define CONFIG_COLOR_BOX                BG1B, {22, 17}, {"{1}{2}{3}{4}{5}{6}{7}"}
.define CONFIG_MAGIC_TYPE_1             {z"{white}Healing  "}
.define CONFIG_MAGIC_TYPE_2             {z"{black}Attack   "}
.define CONFIG_MAGIC_TYPE_3             {z"{effect}Effect   "}

.define CMD_ARRANGE_TITLE               BG3A, {3, 2}, {"Arrange"}

.define CHAR_CTRL_TITLE                 BG3A, {2, 12}, {"Controller"}
.define CHAR_1_CTRL_1                   BG3A, {12, 15}, {"Cntlr1"}
.define CHAR_1_CTRL_2                   BG3A, {21, 15}, {"Cntlr2"}
.define CHAR_2_CTRL_1                   BG3A, {12, 17}, {"Cntlr1"}
.define CHAR_2_CTRL_2                   BG3A, {21, 17}, {"Cntlr2"}
.define CHAR_3_CTRL_1                   BG3A, {12, 19}, {"Cntlr1"}
.define CHAR_3_CTRL_2                   BG3A, {21, 19}, {"Cntlr2"}
.define CHAR_4_CTRL_1                   BG3A, {12, 21}, {"Cntlr1"}
.define CHAR_4_CTRL_2                   BG3A, {21, 21}, {"Cntlr2"}

; ------------------------------------------------------------------------------

; save menu text strings
.define SAVE_SLOT_1_EMPTY               BG3A, {3, 8}, {"Empty"}
.define SAVE_SLOT_2_EMPTY               BG3A, {3, 15}, {"Empty"}
.define SAVE_SLOT_3_EMPTY               BG3A, {3, 22}, {"Empty"}
.define SAVE_SLOT_1_TIME                BG3A, {3, 10}, {"Time"}
.define SAVE_SLOT_2_TIME                BG3A, {3, 17}, {"Time"}
.define SAVE_SLOT_3_TIME                BG3A, {3, 24}, {"Time"}
.define SAVE_SLOT_1_TIME_COLON          BG3A, {4, 11}, {":"}
.define SAVE_SLOT_2_TIME_COLON          BG3A, {4, 18}, {":"}
.define SAVE_SLOT_3_TIME_COLON          BG3A, {4, 25}, {":"}
.define SAVE_SLOT_1_LEVEL               BG3A, {25, 8}, {"LV"}
.define SAVE_SLOT_2_LEVEL               BG3A, {25, 15}, {"LV"}
.define SAVE_SLOT_3_LEVEL               BG3A, {25, 22}, {"LV"}
.define SAVE_SLOT_1_HP_SLASH            BG3A, {25, 10}, {"/"}
.define SAVE_SLOT_2_HP_SLASH            BG3A, {25, 17}, {"/"}
.define SAVE_SLOT_3_HP_SLASH            BG3A, {25, 24}, {"/"}

.define SAVE_TITLE                      BG3A, {15, 4}, {"Save"}
.define NEW_GAME_TITLE                  BG3A, {13, 4}, {"New Game"}

; ------------------------------------------------------------------------------

; element symbols
.define ELEMENT_SYMBOLS                 {b"{water}{earth}{holy}{wind}{poison}{lightning}{ice}{fire}"}

; ------------------------------------------------------------------------------

; name change menu text
.define NAME_CHANGE_MSG                 BG1B, {9, 3}, {"Please enter a name."}

.define NAME_CHANGE_LETTERS_1           {z"ABCDEabcde"}
.define NAME_CHANGE_LETTERS_2           {z"FGHIJfghij"}
.define NAME_CHANGE_LETTERS_3           {z"KLMNOklmno"}
.define NAME_CHANGE_LETTERS_4           {z"PQRSTpqrst"}
.define NAME_CHANGE_LETTERS_5           {z"UVWXYuvwxy"}
.define NAME_CHANGE_LETTERS_6           {z"Z!?/:z”'-."}
.define NAME_CHANGE_LETTERS_7           {z"0123456789"}

; ------------------------------------------------------------------------------

; final order menu text strings
.define FINAL_ORDER_END                 BG1A, {4, 31}, {"End"}
.define FINAL_ORDER_RESET               BG1A, {4, 5}, {"Reset"}
.define FINAL_ORDER_MSG                 BG1A, {10, 3}, {"Determine order"}

; ------------------------------------------------------------------------------

.endif