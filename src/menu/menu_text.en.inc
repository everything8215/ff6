.ifndef MENU_TEXT_INC
MENU_TEXT_INC = 1

; small text codec (default)
#codec s
#char_table null_terminated_en
#char_table text_en
#char_table small_symbols_en

; big text codec
#codec b
#char_table null_terminated_en
#char_table text_en
#char_table big_symbols_en

; japanese small text codec for unused carryover text
#codec j
#char_table null_terminated_jp
#char_table kana
#char_table small_symbols_jp

; ------------------------------------------------------------------------------

; misc. individual text characters
.define ZERO_CHAR                       "0"
.define ELLIPSIS_CHAR                   "_"
.define COLON_CHAR                      ":"
.define GAUGE_EMPTY_CHAR                "{gauge_empty}"
.define GAUGE_FULL_CHAR                 "{gauge_full}"
.define GAUGE_LEFT_CHAR                 "{gauge_left}"
.define GAUGE_RIGHT_CHAR                "{gauge_right}"

; ------------------------------------------------------------------------------

; field menu text strings
.define MAIN_MENU_WOUNDED               {"Wounded "}

.define CHAR_BLOCK_1_LEVEL              BG1A, {10, 5}, {"LV{0}"}
.define CHAR_BLOCK_1_HP                 BG1A, {10, 6}, {"HP{0}"}
.define CHAR_BLOCK_1_MP                 BG1A, {10, 7}, {"MP{0}"}
.define CHAR_BLOCK_1_HP_SLASH           BG1A, {17, 6}, {"/{0}"}
.define CHAR_BLOCK_1_MP_SLASH           BG1A, {17, 7}, {"/{0}"}

.define CHAR_BLOCK_2_LEVEL              BG1A, {10, 11}, {"LV{0}"}
.define CHAR_BLOCK_2_HP                 BG1A, {10, 12}, {"HP{0}"}
.define CHAR_BLOCK_2_MP                 BG1A, {10, 13}, {"MP{0}"}
.define CHAR_BLOCK_2_HP_SLASH           BG1A, {17, 12}, {"/{0}"}
.define CHAR_BLOCK_2_MP_SLASH           BG1A, {17, 13}, {"/{0}"}

.define CHAR_BLOCK_3_LEVEL              BG1A, {10, 17}, {"LV{0}"}
.define CHAR_BLOCK_3_HP                 BG1A, {10, 18}, {"HP{0}"}
.define CHAR_BLOCK_3_MP                 BG1A, {10, 19}, {"MP{0}"}
.define CHAR_BLOCK_3_HP_SLASH           BG1A, {17, 18}, {"/{0}"}
.define CHAR_BLOCK_3_MP_SLASH           BG1A, {17, 19}, {"/{0}"}

.define CHAR_BLOCK_4_LEVEL              BG1A, {10, 23}, {"LV{0}"}
.define CHAR_BLOCK_4_HP                 BG1A, {10, 24}, {"HP{0}"}
.define CHAR_BLOCK_4_MP                 BG1A, {10, 25}, {"MP{0}"}
.define CHAR_BLOCK_4_HP_SLASH           BG1A, {17, 24}, {"/{0}"}
.define CHAR_BLOCK_4_MP_SLASH           BG1A, {17, 25}, {"/{0}"}

.define MAIN_MENU_ITEM                  BG3A, {24, 3}, {"Item{0}"}
.define MAIN_MENU_SKILLS                BG3A, {24, 5}, {"Skills{0}"}
.define MAIN_MENU_EQUIP                 BG3A, {24, 7}, {"Equip{0}"}
.define MAIN_MENU_RELIC                 BG3A, {24, 9}, {"Relic{0}"}
.define MAIN_MENU_STATUS                BG3A, {24, 11}, {"Status{0}"}
.define MAIN_MENU_CONFIG                BG3A, {24, 13}, {"Config{0}"}
.define MAIN_MENU_SAVE                  BG3A, {24, 15}, {"Save{0}"}
.define MAIN_MENU_TIME                  BG3A, {25, 17}, {"Time{0}"}
.define MAIN_MENU_COLON                 BG3A, {27, 18}, {":{0}"}
.define MAIN_MENU_STEPS                 BG3A, {23, 21}, {"Steps{0}"}
.define MAIN_MENU_GIL                   BG3A, {23, 24}, {"Gp{0}"}

.define GAME_LOAD_YES                   BG3A, {26, 9}, {"Yes{0}"}
.define GAME_LOAD_NO                    BG3A, {26, 11}, {"No{0}"}
.define GAME_LOAD_MSG_1                 BG3A, {23, 3}, {"This{0}"}
.define GAME_LOAD_MSG_2                 BG3A, {23, 5}, {"data?{0}"}

.define GAME_SAVE_MSG_1                 BG3A, {23, 3}, {"Erasing{0}"}
.define GAME_SAVE_MSG_2                 BG3A, {23, 5}, {"data.{0}"}
.define GAME_SAVE_MSG_3                 BG3A, {23, 7}, {"Okay?{0}"}

.define MAIN_MENU_ORDER                 BG3B, {26, 3}, {"Order{0}"}

; ------------------------------------------------------------------------------

; colosseum menu text strings
.define COLOSSEUM_ITEM_TITLE            BG3A, {2, 3}, {"Colosseum{0}"}
.define COLOSSEUM_ITEM_MSG              BG3A, {13, 3}, {"Select an Item{0}"}

.define COLOSSEUM_CHAR_BLANK_NAME       BG3A, {22, 16}, {"      {0}"}
.define COLOSSEUM_CHAR_MSG              BG3A, {6, 19}, {"Select the challenger{0}"}
.define COLOSSEUM_UNKNOWN_PRIZE         BG3A, {2, 3}, {"?????????????{0}"}

; ------------------------------------------------------------------------------

; skills menu strings
.define SKILLS_LIST_GENJU               BG3A, {2, 3}, {"Espers{0}"}
.define SKILLS_LIST_MAGIC               BG3A, {2, 5}, {"Magic{0}"}
.define SKILLS_LIST_BUSHIDO             BG3A, {2, 9}, {"SwdTech{0}"}
.define SKILLS_LIST_BLITZ               BG3A, {2, 11}, {"Blitz{0}"}
.define SKILLS_LIST_LORE                BG3A, {2, 13}, {"Lore{0}"}
.define SKILLS_LIST_RAGE                BG3A, {2, 15}, {"Rage{0}"}
.define SKILLS_LIST_DANCE               BG3A, {2, 17}, {"Dance{0}"}

.define SKILLS_MP_COST                  BG3B, {23, 5}, {"MP_    {0}"}
.define SKILLS_LORE_TITLE               BG3B, {23, 5}, {"Lore{0}"}
.define SKILLS_RAGE_TITLE               BG3B, {23, 5}, {"Rage{0}"}
.define SKILLS_DANCE_TITLE              BG3B, {23, 5}, {"Dance{0}"}
.define SKILLS_GENJU_TITLE              BG3B, {23, 5}, {"Espers{0}"}
.define SKILLS_BLITZ_TITLE              BG3B, {23, 5}, {"Blitz{0}"}
.define SKILLS_BUSHIDO_TITLE            BG3B, {23, 5}, {"SwdTech{0}"}

.define SKILLS_CHAR_LEVEL               BG1B, {18, 7}, {"LV{0}"}
.define SKILLS_CHAR_HP                  BG1B, {18, 9}, {"HP{0}"}
.define SKILLS_CHAR_MP                  BG1B, {18, 11}, {"MP{0}"}
.define SKILLS_CHAR_HP_SLASH            BG1B, {25, 9}, {"/{0}"}
.define SKILLS_CHAR_MP_SLASH            BG1B, {25, 11}, {"/{0}"}

.define SKILLS_MP_NEEDED                BG3A, {6, 7}, {"MP{0}"}
.define SKILLS_MP_NEEDED_2              BG3A, {2, 8}, {"Needed{0}"}

.define GENJU_EQUIP_ERROR_MSG           {" has it!{0}"}
.define GENJU_LEARN_PCT                 BG1B, {24, 15}, {"Skill{0}"}
.define GENJU_LEARN_RATE                BG1B, {13, 15}, {"Learn.Rate{0}"}
.define GENJU_AT_LEVEL_UP               {"At level up..."}

; ------------------------------------------------------------------------------

; item menu text strings
.define ITEM_TITLE                      BG3A, {2, 3}, {"Item{0}"}
.define ITEM_OPTION_USE                 BG3A, {10, 3}, {"USE{0}"}
.define ITEM_OPTION_ARRANGE             BG3A, {15, 3}, {"ARRANGE{0}"}
.define ITEM_OPTION_RARE                BG3A, {24, 3}, {"RARE{0}"}

.define ITEM_UNKNOWN_ATTACK             BG3B, {29, 23}, {"???{0}"}
.define ITEM_STRENGTH                   BG3B, {19, 15}, {"Vigor{0}"}
.define ITEM_STAMINA                    BG3B, {19, 19}, {"Stamina{0}"}
.define ITEM_MAG_PWR                    BG3B, {19, 21}, {"Mag.Pwr{0}"}
.define ITEM_EVADE                      BG3B, {19, 27}, {"Evade %{0}"}
.define ITEM_MAG_EVADE                  BG3B, {19, 31}, {"MBlock%{0}"}
.define ITEM_SPEED                      BG3B, {19, 17}, {"Speed{0}"}
.define ITEM_ATTACK_PWR                 BG3B, {19, 23}, {"Bat.Pwr{0}"}
.define ITEM_DEFENSE                    BG3B, {19, 25}, {"Defense{0}"}
.define ITEM_MAG_DEF                    BG3B, {19, 29}, {"Mag.Def{0}"}
.define ITEM_ELEMENT_HALF               BG3A, {2, 13}, {"50% Dmg{0}"}
.define ITEM_ELEMENT_ABSORB             BG3A, {16, 13}, {"Absorb HP{0}"}
.define ITEM_ELEMENT_NULL               BG3A, {2, 17}, {"No Effect{0}"}
.define ITEM_ELEMENT_WEAK               BG3A, {16, 17}, {"Weak pt{0}"}
.define ITEM_ATTACK_ELEMENT             BG3A, {2, 13}, {"Attack{0}"}

.define ITEM_STAT_SEP(yy)               BG3B, {27, yy}, {"{2dot}{0}"}
.define ITEM_USAGE_MSG                  {" can be used by:{0}"}

.define ITEM_BUSHIDO                    BG3B, {19, 7}, {"SwdTech{0}"}
.define ITEM_RUNIC                      BG3B, {19, 9}, {"Runic{0}"}
.define ITEM_2HAND                      BG3B, {19, 11}, {"2-hand{0}"}
.define ITEM_OWNED                      BG3A, {2, 7}, {"Owned:{0}"}
.define ITEM_BLANK_QTY                  BG3A, {27, 9}, {"   {0}"}

.define EVADE_MODIFIER_0                {"  0{0}"}
.define EVADE_MODIFIER_PLUS_10          {"+10{0}"}
.define EVADE_MODIFIER_PLUS_20          {"+20{0}"}
.define EVADE_MODIFIER_PLUS_30          {"+30{0}"}
.define EVADE_MODIFIER_PLUS_40          {"+40{0}"}
.define EVADE_MODIFIER_PLUS_50          {"+50{0}"}
.define EVADE_MODIFIER_MINUS_10         {"-10{0}"}
.define EVADE_MODIFIER_MINUS_20         {"-20{0}"}
.define EVADE_MODIFIER_MINUS_30         {"-30{0}"}
.define EVADE_MODIFIER_MINUS_40         {"-40{0}"}
.define EVADE_MODIFIER_MINUS_50         {"-50{0}"}

.define STAT_MODIFIER_0                 {" 0"}
.define STAT_MODIFIER_PLUS_1            {"+1"}
.define STAT_MODIFIER_PLUS_2            {"+2"}
.define STAT_MODIFIER_PLUS_3            {"+3"}
.define STAT_MODIFIER_PLUS_4            {"+4"}
.define STAT_MODIFIER_PLUS_5            {"+5"}
.define STAT_MODIFIER_PLUS_6            {"+6"}
.define STAT_MODIFIER_PLUS_7            {"+7"}
.define STAT_MODIFIER_MINUS_1           {"-1"}
.define STAT_MODIFIER_MINUS_2           {"-2"}
.define STAT_MODIFIER_MINUS_3           {"-3"}
.define STAT_MODIFIER_MINUS_4           {"-4"}
.define STAT_MODIFIER_MINUS_5           {"-5"}
.define STAT_MODIFIER_MINUS_6           {"-6"}
.define STAT_MODIFIER_MINUS_7           {"-7"}

; ------------------------------------------------------------------------------

; equip/relic menu text strings
.define EQUIP_RHAND                     BG3A, {2, 7}, {"R-hand{0}"}
.define EQUIP_LHAND                     BG3A, {2, 9}, {"L-hand{0}"}
.define EQUIP_HEAD                      BG3A, {2, 11}, {"Head{0}"}
.define EQUIP_BODY                      BG3A, {2, 13}, {"Body{0}"}
.define EQUIP_RELIC1                    BG3A, {2, 11}, {"Relic{0}"}
.define EQUIP_RELIC2                    BG3A, {2, 13}, {"Relic{0}"}
.define EQUIP_BLANK_OPTIONS             BG3A, {2, 3}, {"                            {0}"}
.define EQUIP_TITLE_EQUIP               BG3A, {24, 3}, {"EQUIP{0}"}
.define EQUIP_TITLE_REMOVE              BG3A, {24, 3}, {"REMOVE{0}"}
.define EQUIP_OPTION_EQUIP              BG3A, {2, 3}, {"EQUIP{0}"}
.define EQUIP_OPTION_OPTIMUM            BG3A, {9, 3}, {"OPTIMUM{0}"}
.define EQUIP_OPTION_REMOVE             BG3A, {18, 3}, {"RMOVE{0}"}
.define EQUIP_OPTION_EMPTY              BG3A, {25, 3}, {"EMPTY{0}"}
.define RELIC_OPTION_EQUIP              BG3A, {4, 3}, {"EQUIP{0}"}
.define RELIC_OPTION_REMOVE             BG3A, {11, 3}, {"REMOVE{0}"}

.define EQUIP_STRENGTH                  BG3A, {16, 17}, {"Vigor{0}"}
.define EQUIP_SPEED                     BG3A, {16, 19}, {"Speed{0}"}
.define EQUIP_STAMINA                   BG3A, {16, 21}, {"Stamina{0}"}
.define EQUIP_MAG_PWR                   BG3A, {16, 23}, {"Mag.Pwr{0}"}
.define EQUIP_ATTACK_PWR                BG3A, {16, 25}, {"Bat.Pwr{0}"}
.define EQUIP_DEFENSE                   BG3A, {16, 27}, {"Defense{0}"}
.define EQUIP_EVADE                     BG3A, {16, 29}, {"Evade %{0}"}
.define EQUIP_MAG_DEF                   BG3A, {16, 31}, {"Mag.Def{0}"}
.define EQUIP_MAG_EVADE                 BG3A, {16, 33}, {"MBlock%{0}"}
.define EQUIP_ARROW(yy)                 BG3A, {26, yy}, {"{rightarrow}{0}"}

.define EQUIP_EMPTY_MSG                 BG3A, {13, 3}, {"Empty{0}"}
.define EQUIP_OPTIMUM_MSG               BG3A, {12, 3}, {"Optimum{0}"}
.define RELIC_EMPTY_MSG                 BG3A, {13, 5}, {"Empty{0}"}
.define RELIC_OPTIMUM_MSG               BG3A, {12, 5}, {"Optimum{0}"}
.define EQUIP_CHANGED_MSG               BG3A, {6, 7}, {"Equipment changed.{0}"}

; these are unused in the English translation
.define PARTY_EQUIP_SLOT1_RHAND         BG1A, {3, 4}, {j"みぎ{0}"}
.define PARTY_EQUIP_SLOT1_LHAND         BG1A, {17, 4}, {j"ひだり{0}"}
.define PARTY_EQUIP_SLOT1_HEAD          BG1A, {3, 6}, {j"あたま{0}"}
.define PARTY_EQUIP_SLOT1_BODY          BG1A, {17, 6}, {j"からだ{0}"}
.define PARTY_EQUIP_SLOT1_RELIC1        BG1A, {3, 8}, {j"アク１{0}"}
.define PARTY_EQUIP_SLOT1_RELIC2        BG1A, {17, 8}, {j"アク２{0}"}

.define PARTY_EQUIP_SLOT2_RHAND         BG1A, {3, 12}, {j"みぎ{0}"}
.define PARTY_EQUIP_SLOT2_LHAND         BG1A, {17, 12}, {j"ひだり{0}"}
.define PARTY_EQUIP_SLOT2_HEAD          BG1A, {3, 14}, {j"あたま{0}"}
.define PARTY_EQUIP_SLOT2_BODY          BG1A, {17, 14}, {j"からだ{0}"}
.define PARTY_EQUIP_SLOT2_RELIC1        BG1A, {3, 16}, {j"アク１{0}"}
.define PARTY_EQUIP_SLOT2_RELIC2        BG1A, {17, 16}, {j"アク２{0}"}

.define PARTY_EQUIP_SLOT3_RHAND         BG1A, {3, 20}, {j"みぎ{0}"}
.define PARTY_EQUIP_SLOT3_LHAND         BG1A, {17, 20}, {j"ひだり{0}"}
.define PARTY_EQUIP_SLOT3_HEAD          BG1A, {3, 22}, {j"あたま{0}"}
.define PARTY_EQUIP_SLOT3_BODY          BG1A, {17, 22}, {j"からだ{0}"}
.define PARTY_EQUIP_SLOT3_RELIC1        BG1A, {3, 24}, {j"アク１{0}"}
.define PARTY_EQUIP_SLOT3_RELIC2        BG1A, {17, 24}, {j"アク２{0}"}

.define PARTY_EQUIP_SLOT4_RHAND         BG1A, {3, 28}, {j"みぎ{0}"}
.define PARTY_EQUIP_SLOT4_LHAND         BG1A, {17, 28}, {j"ひだり{0}"}
.define PARTY_EQUIP_SLOT4_HEAD          BG1A, {3, 30}, {j"あたま{0}"}
.define PARTY_EQUIP_SLOT4_BODY          BG1A, {17, 30}, {j"からだ{0}"}
.define PARTY_EQUIP_SLOT4_RELIC1        BG1A, {3, 32}, {j"アク１{0}"}
.define PARTY_EQUIP_SLOT4_RELIC2        BG1A, {17, 32}, {j"アク２{0}"}

; ------------------------------------------------------------------------------

; party menu text strings

.define PARTY_LEVEL                     BG1A, {18, 8}, {"LV{0}"}
.define PARTY_HP                        BG1A, {18, 10}, {"HP{0}"}
.define PARTY_MP                        BG1A, {18, 12}, {"MP{0}"}
.define PARTY_HP_SLASH                  BG1A, {25, 10}, {"/{0}"}
.define PARTY_MP_SLASH                  BG1A, {25, 12}, {"/{0}"}

.define PARTY_MSG                       BG1A, {10, 3}, {"Form   group(s).      {0}"}
.define PARTY_TITLE                     BG1A, {2, 3}, {"Lineup{0}"}
.define PARTY_ERROR_MSG1                BG1A, {10, 3}, {"You need   group(s)!{0}"}
.define PARTY_ERROR_MSG2                BG1A, {10, 3}, {"No one there!       {0}"}

; ------------------------------------------------------------------------------

; status menu text strings
.define STATUS_TITLE                    BG3A, {2, 2}, {"Status{0}"}
.define STATUS_HP_SLASH                 BG1A, {17, 8}, {"/{0}"}
.define STATUS_MP_SLASH                 BG1A, {17, 9}, {"/{0}"}
.define STATUS_EVADE_PERCENT            BG3A, {29, 28}, {"%{0}"}
.define STATUS_MAG_EVADE_PERCENT        BG3C, {29, 0}, {"%{0}"}
.define STATUS_LEVEL                    BG1A, {10, 7}, {"LV{0}"}
.define STATUS_HP                       BG1A, {10, 8}, {"HP{0}"}
.define STATUS_MP                       BG1A, {10, 9}, {"MP{0}"}
.define STATUS_STRENGTH                 BG3A, {3, 26}, {"Vigor{0}"}
.define STATUS_STAMINA                  BG3A, {3, 30}, {"Stamina{0}"}
.define STATUS_MAG_PWR                  BG3C, {3, 0}, {"Mag.Pwr{0}"}
.define STATUS_EVADE                    BG3A, {16, 28}, {"Evade %{0}"}
.define STATUS_MAG_EVADE                BG3C, {16, 0}, {"MBlock%{0}"}
.define STATUS_STRENGTH_SEP             BG3A, {10, 26}, {"{2dot}{0}"}
.define STATUS_SPEED_SEP                BG3A, {10, 28}, {"{2dot}{0}"}
.define STATUS_STAMINA_SEP              BG3A, {10, 30}, {"{2dot}{0}"}
.define STATUS_MAG_PWR_SEP              BG3C, {10, 0}, {"{2dot}{0}"}
.define STATUS_DEFENSE_SEP              BG3A, {25, 26}, {"{2dot}{0}"}
.define STATUS_EVADE_SEP                BG3A, {25, 28}, {"{2dot}{0}"}
.define STATUS_ATTACK_PWR_SEP           BG3A, {25, 24}, {"{2dot}{0}"}
.define STATUS_MAG_DEF_SEP              BG3A, {25, 30}, {"{2dot}{0}"}
.define STATUS_MAG_EVADE_SEP            BG3C, {25, 0}, {"{2dot}{0}"}
.define STATUS_SPEED                    BG3A, {3, 28}, {"Speed{0}"}
.define STATUS_ATTACK_PWR               BG3A, {16, 24}, {"Bat.Pwr{0}"}
.define STATUS_DEFENSE                  BG3A, {16, 26}, {"Defense{0}"}
.define STATUS_MAG_DEF                  BG3A, {16, 30}, {"Mag.Def{0}"}
.define STATUS_YOUR_EXP                 BG3A, {2, 16}, {"Your Exp:{0}"}
.define STATUS_LEVEL_UP_EXP             BG3A, {2, 20}, {"For level up:{0}"}

; ------------------------------------------------------------------------------

; shop menu text strings
.define SHOP_TYPE_1                     BG3A, {2, 3}, {"Weapon{0}"}
.define SHOP_TYPE_2                     BG3A, {3, 3}, {"Armor{0}"}
.define SHOP_TYPE_3                     BG3A, {3, 3}, {"Item{0}"}
.define SHOP_TYPE_4                     BG3A, {2, 3}, {"Relics{0}"}
.define SHOP_TYPE_5                     BG3A, {2, 3}, {"Vendor{0}"}
.define SHOP_OPTIONS_TEXT               BG3A, {3, 7}, {"BUY  SELL  EXIT{0}"}
.define SHOP_GIL_1                      BG3A, {28, 7}, {"GP{0}"}
.define SHOP_GIL_2                      BG3A, {17, 11}, {"GP{0}"}
.define SHOP_OWNED                      BG3A, {21, 9}, {"Owned:{0}"}
.define SHOP_EQUIPPED                   BG3A, {21, 13}, {"Equipped:{0}"}
.define SHOP_POWER                      BG3A, {3, 13}, {"Bat Pwr{0}"}
.define SHOP_DEFENSE                    BG3A, {3, 13}, {"Defense{0}"}
.define SHOP_DOTS                       BG3A, {14, 13}, {"_{0}"}
.define SHOP_GREETING_MSG               BG3A, {11, 3}, {"Hi! Can I help you?{0}"}
.define SHOP_BUY_MSG                    BG3A, {11, 3}, {"Help yourself!{0}"}
.define SHOP_BUY_QTY_MSG                BG3A, {11, 3}, {"How many?{0}"}
.define SHOP_SELL_MSG                   BG3A, {11, 3}, {"Whatcha got?{0}"}
.define SHOP_SELL_QTY_MSG               BG3A, {11, 3}, {"How many?{0}"}
.define SHOP_BYE_MSG                    BG3A, {11, 3}, {"Bye!          {0}"}
.define SHOP_NOT_ENOUGH_GIL_MSG         BG3A, {11, 3}, {"You need more GP!{0}"}
.define SHOP_TOO_MANY_MSG               BG3A, {11, 3}, {"Too many!       {0}"}
.define SHOP_ONLY_ONE_MSG               BG3A, {11, 3}, {"One's plenty! {0}"}

; ------------------------------------------------------------------------------

; config menu text strings
.define CONFIG_COLOR_ARROW_BLANK        BG1B, {22, 18}, {"       {0}"}
.define CONFIG_COLOR_ARROW(xx)          BG1B, {xx, 18}, {"{uparrow}{0}"}

.define CONFIG_CONTROLLER               BG1A, {3, 21}, {"Controller{0}"}
.define CONFIG_WAIT                     BG1A, {22, 5}, {"Wait{0}"}
.define CONFIG_FAST                     BG1A, {14, 8}, {"Fast{0}"}
.define CONFIG_SLOW                     BG1A, {22, 8}, {"Slow{0}"}
.define CONFIG_CMD_SHORT                BG1A, {22, 11}, {"Short{0}"}
.define CONFIG_GAUGE_ON                 BG1A, {14, 13}, {"On{0}"}
.define CONFIG_GAUGE_OFF                BG1A, {22, 13}, {"Off{0}"}
.define CONFIG_STEREO                   BG1A, {14, 15}, {"Stereo{0}"}
.define CONFIG_MONO                     BG1A, {22, 15}, {"Mono{0}"}
.define CONFIG_MEMORY                   BG1A, {22, 17}, {"Memory{0}"}
.define CONFIG_OPTIMUM                  BG1A, {14, 19}, {"Optimum{0}"}
.define CONFIG_CTRL_MULTI               BG1A, {22, 21}, {"Multiple{0}"}
.define CONFIG_BATTLE_SPEED_NUM         BG1A, {14, 7}, {"1 2 3 4 5 6{0}"}
.define CONFIG_MSG_SPEED_NUM            BG1A, {14, 9}, {"1 2 3 4 5 6{0}"}
.define CONFIG_CURSOR                   BG1A, {3, 17}, {"Cursor{0}"}

.define CONFIG_TITLE                    BG3A, {24, 2}, {"Config{0}"}
.define CONFIG_BATTLE_MODE              BG1A, {3, 5}, {"Bat.Mode{0}"}
.define CONFIG_BATTLE_SPEED             BG1A, {3, 7}, {"Bat.Speed{0}"}
.define CONFIG_MSG_SPEED                BG1A, {3, 9}, {"Msg.Speed{0}"}
.define CONFIG_CMD_SET                  BG1A, {3, 11}, {"Cmd.Set{0}"}
.define CONFIG_GAUGE                    BG1A, {3, 13}, {"Gauge{0}"}
.define CONFIG_SOUND                    BG1A, {3, 15}, {"Sound{0}"}
.define CONFIG_REEQUIP                  BG1A, {3, 19}, {"Reequip{0}"}
.define CONFIG_ACTIVE                   BG1A, {14, 5}, {"Active{0}"}
.define CONFIG_CMD_WINDOW               BG1A, {14, 11}, {"Window{0}"}
.define CONFIG_RESET                    BG1A, {14, 17}, {"Reset{0}"}
.define CONFIG_EMPTY                    BG1A, {22, 19}, {"Empty{0}"}
.define CONFIG_CTRL_SINGLE              BG1A, {14, 21}, {"Single{0}"}

.define CONFIG_MAGIC_ORDER              BG1B, {3, 5}, {"Mag.Order{0}"}
.define CONFIG_WINDOW_LABEL             BG1B, {3, 13}, {"Window{0}"}
.define CONFIG_COLOR                    BG1B, {3, 15}, {"Color{0}"}
.define CONFIG_MAGIC_ORDER_A            BG1B, {14, 7}, {"A{2dot}{0}"}
.define CONFIG_MAGIC_ORDER_B            BG1B, {14, 9}, {"B{2dot}{0}"}
.define CONFIG_MAGIC_ORDER_C            BG1B, {14, 11}, {"C{2dot}{0}"}
.define CONFIG_COLOR_BAR_R              BG1B, {18, 19}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define CONFIG_COLOR_BAR_G              BG1B, {18, 21}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define CONFIG_COLOR_BAR_B              BG1B, {18, 23}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define CONFIG_COLOR_R                  BG1B, {14, 19}, {"R{0}"}
.define CONFIG_COLOR_G                  BG1B, {14, 21}, {"G{0}"}
.define CONFIG_COLOR_B                  BG1B, {14, 23}, {"B{0}"}
.define CONFIG_WINDOW_NUM               BG1B, {14, 13}, {"1 2 3 4 5 6 7 8{0}"}
.define CONFIG_MAGIC_ORDER_NUM          BG1B, {14, 5}, {"1 2 3 4 5 6{0}"}
.define CONFIG_FONT                     BG1B, {14, 15}, {"Font{0}"}
.define CONFIG_WINDOW                   BG1B, {22, 15}, {"Window{0}"}

.define CONFIG_RETURN                   BG1B, {25, 14}, {j"もどす{0}"}
.define CONFIG_COLOR_BOX                BG1B, {22, 17}, {"{1}{2}{3}{4}{5}{6}{7}{0}"}
.define CONFIG_MAGIC_TYPE_1             {"{white}Healing  "}
.define CONFIG_MAGIC_TYPE_2             {"{black}Attack   "}
.define CONFIG_MAGIC_TYPE_3             {"{effect}Effect   "}

.define CMD_ARRANGE_TITLE               BG3A, {3, 2}, {"Arrange{0}"}

.define CHAR_CTRL_TITLE                 BG3A, {2, 12}, {"Controller{0}"}
.define CHAR_1_CTRL_1                   BG3A, {12, 15}, {"Cntlr1{0}"}
.define CHAR_1_CTRL_2                   BG3A, {21, 15}, {"Cntlr2{0}"}
.define CHAR_2_CTRL_1                   BG3A, {12, 17}, {"Cntlr1{0}"}
.define CHAR_2_CTRL_2                   BG3A, {21, 17}, {"Cntlr2{0}"}
.define CHAR_3_CTRL_1                   BG3A, {12, 19}, {"Cntlr1{0}"}
.define CHAR_3_CTRL_2                   BG3A, {21, 19}, {"Cntlr2{0}"}
.define CHAR_4_CTRL_1                   BG3A, {12, 21}, {"Cntlr1{0}"}
.define CHAR_4_CTRL_2                   BG3A, {21, 21}, {"Cntlr2{0}"}

; ------------------------------------------------------------------------------

; save menu text strings
.define SAVE_SLOT_1_EMPTY               BG3A, {3, 8}, {"Empty{0}"}
.define SAVE_SLOT_2_EMPTY               BG3A, {3, 15}, {"Empty{0}"}
.define SAVE_SLOT_3_EMPTY               BG3A, {3, 22}, {"Empty{0}"}
.define SAVE_SLOT_1_TIME                BG3A, {3, 10}, {"Time{0}"}
.define SAVE_SLOT_2_TIME                BG3A, {3, 17}, {"Time{0}"}
.define SAVE_SLOT_3_TIME                BG3A, {3, 24}, {"Time{0}"}
.define SAVE_SLOT_1_TIME_COLON          BG3A, {4, 11}, {":{0}"}
.define SAVE_SLOT_2_TIME_COLON          BG3A, {4, 18}, {":{0}"}
.define SAVE_SLOT_3_TIME_COLON          BG3A, {4, 25}, {":{0}"}
.define SAVE_SLOT_1_LEVEL               BG3A, {25, 8}, {"LV{0}"}
.define SAVE_SLOT_2_LEVEL               BG3A, {25, 15}, {"LV{0}"}
.define SAVE_SLOT_3_LEVEL               BG3A, {25, 22}, {"LV{0}"}
.define SAVE_SLOT_1_HP_SLASH            BG3A, {25, 10}, {"/{0}"}
.define SAVE_SLOT_2_HP_SLASH            BG3A, {25, 17}, {"/{0}"}
.define SAVE_SLOT_3_HP_SLASH            BG3A, {25, 24}, {"/{0}"}

.define SAVE_TITLE                      BG3A, {15, 4}, {"Save{0}"}
.define NEW_GAME_TITLE                  BG3A, {13, 4}, {"New Game{0}"}

; ------------------------------------------------------------------------------

; element symbols
.define ELEMENT_SYMBOLS                 {b"{water}{earth}{holy}{wind}{poison}{lightning}{ice}{fire}{0}"}

; ------------------------------------------------------------------------------

; name change menu text
.define NAME_CHANGE_MSG                 BG1B, {9, 3}, {"Please enter a name.{0}"}

.define NAME_CHANGE_LETTERS_1           {"ABCDEabcde"}
.define NAME_CHANGE_LETTERS_2           {"FGHIJfghij"}
.define NAME_CHANGE_LETTERS_3           {"KLMNOklmno"}
.define NAME_CHANGE_LETTERS_4           {"PQRSTpqrst"}
.define NAME_CHANGE_LETTERS_5           {"UVWXYuvwxy"}
.define NAME_CHANGE_LETTERS_6           {"Z!?/:z”'-."}
.define NAME_CHANGE_LETTERS_7           {"0123456789"}

; ------------------------------------------------------------------------------

; final order menu text strings
.define FINAL_ORDER_END                 BG1A, {4, 31}, {"End{0}"}
.define FINAL_ORDER_RESET               BG1A, {4, 5}, {"Reset{0}"}
.define FINAL_ORDER_MSG                 BG1A, {10, 3}, {"Determine order{0}"}

; ------------------------------------------------------------------------------

.endif