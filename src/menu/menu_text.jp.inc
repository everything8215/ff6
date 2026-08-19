.ifndef MENU_TEXT_INC
MENU_TEXT_INC = 1

; small text codec (default)
#codec s
#char_table null_terminated_jp
#char_table kana
#char_table small_symbols_jp

; big text codec
#codec b
#char_table null_terminated_jp
#char_table kana
#char_table big_symbols_jp
#char_table kanji

; romaji text codec
#codec r
#char_table null_terminated_jp
#char_table romaji
#char_table small_symbols_jp

; ------------------------------------------------------------------------------

; misc. individual text characters
.define ZERO_CHAR                       r"0"
.define ELLIPSIS_CHAR                   "_"
.define COLON_CHAR                      ":"
.define GAUGE_EMPTY_CHAR                "{gauge_empty}"
.define GAUGE_FULL_CHAR                 "{gauge_full}"
.define GAUGE_LEFT_CHAR                 "{gauge_left}"
.define GAUGE_RIGHT_CHAR                "{gauge_right}"

; ------------------------------------------------------------------------------

; field menu text strings
.define MAIN_MENU_WOUNDED               {"せんとうふのう　"}

.define CHAR_BLOCK_1_LEVEL              BG1A, {10, 5}, {r"LV{0}"}
.define CHAR_BLOCK_1_HP                 BG1A, {10, 6}, {r"HP{0}"}
.define CHAR_BLOCK_1_MP                 BG1A, {10, 7}, {r"MP{0}"}
.define CHAR_BLOCK_1_HP_SLASH           BG1A, {17, 6}, {r"/{0}"}
.define CHAR_BLOCK_1_MP_SLASH           BG1A, {17, 7}, {r"/{0}"}

.define CHAR_BLOCK_2_LEVEL              BG1A, {10, 11}, {r"LV{0}"}
.define CHAR_BLOCK_2_HP                 BG1A, {10, 12}, {r"HP{0}"}
.define CHAR_BLOCK_2_MP                 BG1A, {10, 13}, {r"MP{0}"}
.define CHAR_BLOCK_2_HP_SLASH           BG1A, {17, 12}, {r"/{0}"}
.define CHAR_BLOCK_2_MP_SLASH           BG1A, {17, 13}, {r"/{0}"}

.define CHAR_BLOCK_3_LEVEL              BG1A, {10, 17}, {r"LV{0}"}
.define CHAR_BLOCK_3_HP                 BG1A, {10, 18}, {r"HP{0}"}
.define CHAR_BLOCK_3_MP                 BG1A, {10, 19}, {r"MP{0}"}
.define CHAR_BLOCK_3_HP_SLASH           BG1A, {17, 18}, {r"/{0}"}
.define CHAR_BLOCK_3_MP_SLASH           BG1A, {17, 19}, {r"/{0}"}

.define CHAR_BLOCK_4_LEVEL              BG1A, {10, 23}, {r"LV{0}"}
.define CHAR_BLOCK_4_HP                 BG1A, {10, 24}, {r"HP{0}"}
.define CHAR_BLOCK_4_MP                 BG1A, {10, 25}, {r"MP{0}"}
.define CHAR_BLOCK_4_HP_SLASH           BG1A, {17, 24}, {r"/{0}"}
.define CHAR_BLOCK_4_MP_SLASH           BG1A, {17, 25}, {r"/{0}"}

.define MAIN_MENU_ITEM                  BG3A, {25, 3}, {"アイテム{0}"}
.define MAIN_MENU_SKILLS                BG3A, {25, 5}, {"とくしゅ{0}"}
.define MAIN_MENU_EQUIP                 BG3A, {25, 6}, {"そうび{0}"}
.define MAIN_MENU_RELIC                 BG3A, {25, 9}, {"アクセサリ{0}"}
.define MAIN_MENU_STATUS                BG3A, {25, 11}, {"ステータス{0}"}
.define MAIN_MENU_CONFIG                BG3A, {25, 12}, {"コンフィグ{0}"}
.define MAIN_MENU_SAVE                  BG3A, {25, 14}, {"セーブ{0}"}
.define MAIN_MENU_TIME                  BG3A, {25, 17}, {"ごボギブ{0}"}
.define MAIN_MENU_COLON                 BG3A, {27, 18}, {"：{0}"}
.define MAIN_MENU_STEPS                 BG3A, {23, 21}, {"ほすう{0}"}
.define MAIN_MENU_GIL                   BG3A, {23, 23}, {"ギル{0}"}

.define GAME_LOAD_YES                   BG3A, {26, 8}, {"はい{0}"}
.define GAME_LOAD_NO                    BG3A, {26, 10}, {"いいえ{0}"}
.define GAME_LOAD_MSG_1                 BG3A, {23, 2}, {"このデータで{0}"}
.define GAME_LOAD_MSG_2                 BG3A, {23, 4}, {"はじめますか？{0}"}

.define GAME_SAVE_MSG_1                 BG3A, {23, 2}, {"これをけして{0}"}
.define GAME_SAVE_MSG_2                 BG3A, {23, 4}, {"かきこみます。{0}"}
.define GAME_SAVE_MSG_3                 BG3A, {23, 6}, {"いいですか？{0}"}
.define GAME_SAVE_UNUSED                BG3A, {23, 16}, {"セーブしました。{0}"}

.define MAIN_MENU_ORDER                 BG3B, {26, 3}, {"たいけい{0}"}

; ------------------------------------------------------------------------------

; colosseum menu text strings
.define COLOSSEUM_ITEM_TITLE            BG3A, {2, 2}, {"コロシアム{0}"}
.define COLOSSEUM_ITEM_MSG              BG3A, {9, 2}, {"アイテムを１つ　えらんでください{0}"}

.define COLOSSEUM_CHAR_BLANK_NAME       BG3A, {22, 15}, {"　　　　　　{0}"}
.define COLOSSEUM_CHAR_MSG              BG3A, {8, 19}, {"ちょうせんしゃをきめてください{0}"}
.define COLOSSEUM_UNKNOWN_PRIZE         BG3A, {4, 3}, {"？？？？？？？？{0}"}

; ------------------------------------------------------------------------------

; skills menu strings
.define SKILLS_LIST_GENJU               BG3A, {2, 2}, {"げんじゅう{0}"}
.define SKILLS_LIST_MAGIC               BG3A, {2, 4}, {"まほう{0}"}
.define SKILLS_LIST_BUSHIDO             BG3A, {2, 8}, {"ひっさつけん{0}"}
.define SKILLS_LIST_BLITZ               BG3A, {2, 10}, {"ひっさつわざ{0}"}
.define SKILLS_LIST_LORE                BG3A, {2, 12}, {"おぼえたわざ{0}"}
.define SKILLS_LIST_RAGE                BG3A, {2, 14}, {"あばれる{0}"}
.define SKILLS_LIST_DANCE               BG3A, {2, 16}, {"おどり{0}"}

.define SKILLS_BLANK_TITLE              BG3B, {2, 2}, {"　　　　　　{0}"}
.define SKILLS_MP_COST                  BG3B, {2, 3}, {"ギぐ＿　　　{0}"}
.define SKILLS_LORE_TITLE               BG3B, {2, 2}, {"おぼえたわざ{0}"}
.define SKILLS_RAGE_TITLE               BG3B, {2, 2}, {"あばれる　　{0}"}
.define SKILLS_DANCE_TITLE              BG3B, {2, 2}, {"おどり　　　{0}"}
.define SKILLS_GENJU_TITLE              BG3B, {2, 2}, {"げんじゅう　{0}"}
.define SKILLS_BLITZ_TITLE              BG3B, {2, 2}, {"ひっさつわざ{0}"}
.define SKILLS_BUSHIDO_TITLE            BG3B, {2, 2}, {"ひっさつけん{0}"}

.define SKILLS_CHAR_LEVEL               BG1B, {18, 7}, {"がざ{0}"}
.define SKILLS_CHAR_HP                  BG1B, {18, 9}, {"べぐ{0}"}
.define SKILLS_CHAR_MP                  BG1B, {18, 11}, {"ギぐ{0}"}
.define SKILLS_CHAR_HP_SLASH            BG1B, {25, 9}, {"／{0}"}
.define SKILLS_CHAR_MP_SLASH            BG1B, {25, 11}, {"／{0}"}

.define SKILLS_MP_NEEDED                BG3A, {2, 6}, {"しょうひ　ｍｐ{0}"}

.define GENJU_EQUIP_ERROR_MSG           {"がもっています{0}"}
.define GENJU_LEARN_PCT                 BG1B, {22, 16}, {"じゅくれんど{0}"}
.define GENJU_LEARN_RATE                BG1B, {13, 16}, {"おぼえるスピード{0}"}
.define GENJU_AT_LEVEL_UP               {"レベルアップのときに　"}

; ------------------------------------------------------------------------------

; bushido renaming menu text strings
.define BUSHIDO_GAUGE                   BG1A, {2, 3}, {"{gauge_left}{gauge_full}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define BUSHIDO_TITLE                   BG1A, {3, 1}, {"ひっさつけん{0}"}

; ------------------------------------------------------------------------------

; item menu text strings
.define ITEM_TITLE                      BG3A, {2, 2}, {"アイテム{0}"}
.define ITEM_OPTION_USE                 BG3A, {10, 2}, {"つかう{0}"}
.define ITEM_OPTION_ARRANGE             BG3A, {16, 2}, {"せいとん{0}"}
.define ITEM_OPTION_RARE                BG3A, {23, 2}, {"だいじなもの{0}"}

.define ITEM_UNKNOWN_ATTACK             BG3B, {29, 23}, {"？？？{0}"}
.define ITEM_STRENGTH                   BG3B, {19, 15}, {"ちから{0}"}
.define ITEM_STAMINA                    BG3B, {19, 19}, {"たいりょく{0}"}
.define ITEM_MAG_PWR                    BG3B, {19, 21}, {"まりょく{0}"}
.define ITEM_EVADE                      BG3B, {19, 27}, {"かいひりつ{0}"}
.define ITEM_MAG_EVADE                  BG3B, {19, 31}, {"まほうかいひりつ{0}"}
.define ITEM_SPEED                      BG3B, {19, 16}, {"すばやさ{0}"}
.define ITEM_ATTACK_PWR                 BG3B, {19, 22}, {"こうげきりょく{0}"}
.define ITEM_DEFENSE                    BG3B, {19, 24}, {"ぼうぎょ{0}"}
.define ITEM_MAG_DEF                    BG3B, {19, 28}, {"まほうぼうぎょ{0}"}
.define ITEM_ELEMENT_HALF               BG3A, {2, 12}, {"はんげん{0}"}
.define ITEM_ELEMENT_ABSORB             BG3A, {16, 12}, {"きゅうしゅう{0}"}
.define ITEM_ELEMENT_NULL               BG3A, {2, 16}, {"むこう{0}"}
.define ITEM_ELEMENT_WEAK               BG3A, {16, 16}, {"じゃくてん{0}"}
.define ITEM_ATTACK_ELEMENT             BG3A, {2, 12}, {"こうげき{0}"}

.define ITEM_STAT_SEP(yy)               BG3B, {27, yy}, {"…{0}"}
.define ITEM_USAGE_MSG                  {"を　そうびできるキャラクター{0}"}

.define ITEM_BUSHIDO                    BG3B, {19, 7}, {"ひっさつけん　グガ{0}"}
.define ITEM_RUNIC                      BG3B, {19, 9}, {"まふうけん　　グガ{0}"}
.define ITEM_2HAND                      BG3B, {19, 11}, {"りょうてもち　グガ{0}"}
.define ITEM_OWNED                      BG3A, {2, 6}, {"もっているかず{0}"}
.define ITEM_BLANK_QTY                  BG3A, {27, 9}, {"　　　{0}"}

.define EVADE_MODIFIER_0                {r"  0{0}"}
.define EVADE_MODIFIER_PLUS_10          {r"+10{0}"}
.define EVADE_MODIFIER_PLUS_20          {r"+20{0}"}
.define EVADE_MODIFIER_PLUS_30          {r"+30{0}"}
.define EVADE_MODIFIER_PLUS_40          {r"+40{0}"}
.define EVADE_MODIFIER_PLUS_50          {r"+50{0}"}
.define EVADE_MODIFIER_MINUS_10         {r"-10{0}"}
.define EVADE_MODIFIER_MINUS_20         {r"-20{0}"}
.define EVADE_MODIFIER_MINUS_30         {r"-30{0}"}
.define EVADE_MODIFIER_MINUS_40         {r"-40{0}"}
.define EVADE_MODIFIER_MINUS_50         {r"-50{0}"}

.define STAT_MODIFIER_0                 {r" 0"}
.define STAT_MODIFIER_PLUS_1            {r"+1"}
.define STAT_MODIFIER_PLUS_2            {r"+2"}
.define STAT_MODIFIER_PLUS_3            {r"+3"}
.define STAT_MODIFIER_PLUS_4            {r"+4"}
.define STAT_MODIFIER_PLUS_5            {r"+5"}
.define STAT_MODIFIER_PLUS_6            {r"+6"}
.define STAT_MODIFIER_PLUS_7            {r"+7"}
.define STAT_MODIFIER_MINUS_1           {r"-1"}
.define STAT_MODIFIER_MINUS_2           {r"-2"}
.define STAT_MODIFIER_MINUS_3           {r"-3"}
.define STAT_MODIFIER_MINUS_4           {r"-4"}
.define STAT_MODIFIER_MINUS_5           {r"-5"}
.define STAT_MODIFIER_MINUS_6           {r"-6"}
.define STAT_MODIFIER_MINUS_7           {r"-7"}

; ------------------------------------------------------------------------------

; equipment menu text strings
.define EQUIP_RHAND                     BG3A, {2, 6}, {"みぎて{0}"}
.define EQUIP_LHAND                     BG3A, {2, 8}, {"ひだりて{0}"}
.define EQUIP_HEAD                      BG3A, {2, 10}, {"あたま{0}"}
.define EQUIP_BODY                      BG3A, {2, 12}, {"からだ{0}"}
.define EQUIP_RELIC1                    BG3A, {2, 10}, {"アクセサリ{0}"}
.define EQUIP_RELIC2                    BG3A, {2, 12}, {"アクセサリ{0}"}
.define EQUIP_BLANK_OPTIONS             BG3A, {4, 2}, {"　　　　　　　　　　　　　　　　　　　　　　　　　　{0}"}
.define EQUIP_TITLE_EQUIP               BG3A, {26, 2}, {"そうび{0}"}
.define EQUIP_TITLE_REMOVE              BG3A, {26, 2}, {"はずす{0}"}
.define EQUIP_OPTION_EQUIP              BG3A, {4, 2}, {"そうび{0}"}
.define EQUIP_OPTION_OPTIMUM            BG3A, {9, 2}, {"さいきょう{0}"}
.define EQUIP_OPTION_REMOVE             BG3A, {16, 2}, {"はずす{0}"}
.define EQUIP_OPTION_EMPTY              BG3A, {22, 2}, {"すべてはずす　{0}"}
.define RELIC_OPTION_EQUIP              BG3A, {4, 2}, {"そうび{0}"}
.define RELIC_OPTION_REMOVE             BG3A, {9, 2}, {"はずす{0}"}

.define EQUIP_STRENGTH                  BG3A, {15, 17}, {"ちから{0}"}
.define EQUIP_SPEED                     BG3A, {15, 18}, {"すばやさ{0}"}
.define EQUIP_STAMINA                   BG3A, {15, 21}, {"たいりょく{0}"}
.define EQUIP_MAG_PWR                   BG3A, {15, 23}, {"まりょく{0}"}
.define EQUIP_ATTACK_PWR                BG3A, {15, 24}, {"こうげきりょく{0}"}
.define EQUIP_DEFENSE                   BG3A, {15, 26}, {"ぼうぎょ{0}"}
.define EQUIP_EVADE                     BG3A, {15, 29}, {"かいひりつ{0}"}
.define EQUIP_MAG_DEF                   BG3A, {15, 30}, {"まほうぼうぎょ{0}"}
.define EQUIP_MAG_EVADE                 BG3A, {15, 33}, {"まほうかいひりつ{0}"}
.define EQUIP_ARROW(yy)                 BG3A, {26, yy}, {"{rightarrow}{0}"}

.define EQUIP_WEAPON_FLAG_1             BG3A, {21, 6}, {"　　　　　　{0}"}
.define EQUIP_WEAPON_FLAG_2             BG3A, {21, 8}, {"　　　　　　{0}"}
.define EQUIP_WEAPON_FLAG_3             BG3A, {19, 8}, {"じゅうそうび{0}"}
.define EQUIP_WEAPON_FLAG_4             BG3A, {19, 6}, {"にとうりゅう{0}"}
.define EQUIP_WEAPON_FLAG_5             BG3A, {19, 8}, {"りょうてもち{0}"}

.define EQUIP_EMPTY_MSG                 BG3A, {12, 2}, {"「すべてはずす」{0}"}
.define EQUIP_OPTIMUM_MSG               BG3A, {12, 2}, {"「さいきょうそうび」{0}"}
.define RELIC_EMPTY_MSG                 BG3A, {12, 4}, {"「すべてはずす」{0}"}
.define RELIC_OPTIMUM_MSG               BG3A, {12, 4}, {"「さいきょうそうび」{0}"}
.define EQUIP_CHANGED_MSG               BG3A, {3, 6}, {"そうびにかかわるアクセサリーが　へんこうされました{0}"}

; item slot names for party equip menu
.define PARTY_EQUIP_SLOT1_RHAND         BG1A, {3, 4}, {"みぎ{0}"}
.define PARTY_EQUIP_SLOT1_LHAND         BG1A, {17, 4}, {"ひだり{0}"}
.define PARTY_EQUIP_SLOT1_HEAD          BG1A, {3, 6}, {"あたま{0}"}
.define PARTY_EQUIP_SLOT1_BODY          BG1A, {17, 6}, {"からだ{0}"}
.define PARTY_EQUIP_SLOT1_RELIC1        BG1A, {3, 8}, {"アク１{0}"}
.define PARTY_EQUIP_SLOT1_RELIC2        BG1A, {17, 8}, {"アク２{0}"}

.define PARTY_EQUIP_SLOT2_RHAND         BG1A, {3, 12}, {"みぎ{0}"}
.define PARTY_EQUIP_SLOT2_LHAND         BG1A, {17, 12}, {"ひだり{0}"}
.define PARTY_EQUIP_SLOT2_HEAD          BG1A, {3, 14}, {"あたま{0}"}
.define PARTY_EQUIP_SLOT2_BODY          BG1A, {17, 14}, {"からだ{0}"}
.define PARTY_EQUIP_SLOT2_RELIC1        BG1A, {3, 16}, {"アク１{0}"}
.define PARTY_EQUIP_SLOT2_RELIC2        BG1A, {17, 16}, {"アク２{0}"}

.define PARTY_EQUIP_SLOT3_RHAND         BG1A, {3, 20}, {"みぎ{0}"}
.define PARTY_EQUIP_SLOT3_LHAND         BG1A, {17, 20}, {"ひだり{0}"}
.define PARTY_EQUIP_SLOT3_HEAD          BG1A, {3, 22}, {"あたま{0}"}
.define PARTY_EQUIP_SLOT3_BODY          BG1A, {17, 22}, {"からだ{0}"}
.define PARTY_EQUIP_SLOT3_RELIC1        BG1A, {3, 24}, {"アク１{0}"}
.define PARTY_EQUIP_SLOT3_RELIC2        BG1A, {17, 24}, {"アク２{0}"}

.define PARTY_EQUIP_SLOT4_RHAND         BG1A, {3, 28}, {"みぎ{0}"}
.define PARTY_EQUIP_SLOT4_LHAND         BG1A, {17, 28}, {"ひだり{0}"}
.define PARTY_EQUIP_SLOT4_HEAD          BG1A, {3, 30}, {"あたま{0}"}
.define PARTY_EQUIP_SLOT4_BODY          BG1A, {17, 30}, {"からだ{0}"}
.define PARTY_EQUIP_SLOT4_RELIC1        BG1A, {3, 32}, {"アク１{0}"}
.define PARTY_EQUIP_SLOT4_RELIC2        BG1A, {17, 32}, {"アク２{0}"}

; ------------------------------------------------------------------------------

; party menu text strings
.define PARTY_LEVEL                     BG1A, {18, 8}, {r"LV{0}"}
.define PARTY_HP                        BG1A, {18, 10}, {r"HP{0}"}
.define PARTY_MP                        BG1A, {18, 12}, {r"MP{0}"}
.define PARTY_HP_SLASH                  BG1A, {25, 10}, {r"/{0}"}
.define PARTY_MP_SLASH                  BG1A, {25, 12}, {r"/{0}"}

.define PARTY_MSG                       BG1A, {10, 2}, {"パーティーを　つ　つくってください{0}"}
.define PARTY_TITLE                     BG1A, {3, 2}, {"へんせい{0}"}
.define PARTY_ERROR_MSG1                BG1A, {10, 2}, {"パーティーのかずが　つありません！{0}"}
.define PARTY_ERROR_MSG2                BG1A, {10, 2}, {"だれもいません！　　　　　　　　　{0}"}

; ------------------------------------------------------------------------------

; status menu text strings
.define STATUS_TITLE                    BG3A, {2, 2}, {"ステータス{0}"}
.define STATUS_HP_SLASH                 BG1A, {17, 8}, {"／{0}"}
.define STATUS_MP_SLASH                 BG1A, {17, 9}, {"／{0}"}
.define STATUS_EVADE_PERCENT            BG3A, {29, 28}, {"％{0}"}
.define STATUS_MAG_EVADE_PERCENT        BG3C, {29, 0}, {"％{0}"}
.define STATUS_LEVEL                    BG1A, {10, 7}, {r"LV{0}"}
.define STATUS_HP                       BG1A, {10, 8}, {r"HP{0}"}
.define STATUS_MP                       BG1A, {10, 9}, {r"MP{0}"}
.define STATUS_STRENGTH                 BG3A, {4, 26}, {"ちから{0}"}
.define STATUS_STAMINA                  BG3A, {4, 30}, {"たいりょく{0}"}
.define STATUS_MAG_PWR                  BG3C, {4, 0}, {"まりょく{0}"}
.define STATUS_EVADE                    BG3A, {16, 28}, {"かいひりつ{0}"}
.define STATUS_MAG_EVADE                BG3C, {16, 0}, {"まほうかいひりつ　＿{0}"}
.define STATUS_STRENGTH_SEP             BG3A, {10, 26}, {"＿{0}"}
.define STATUS_SPEED_SEP                BG3A, {10, 28}, {"＿{0}"}
.define STATUS_STAMINA_SEP              BG3A, {10, 30}, {"＿{0}"}
.define STATUS_MAG_PWR_SEP              BG3C, {10, 0}, {"＿{0}"}
.define STATUS_DEFENSE_SEP              BG3A, {25, 26}, {"＿{0}"}
.define STATUS_EVADE_SEP                BG3A, {25, 28}, {"＿{0}"}
.define STATUS_SPEED                    BG3A, {4, 27}, {"すばやさ{0}"}
.define STATUS_ATTACK_PWR               BG3A, {16, 23}, {"こうげきりょく　　＿{0}"}
.define STATUS_DEFENSE                  BG3A, {16, 25}, {"ぼうぎょ{0}"}
.define STATUS_MAG_DEF                  BG3A, {16, 29}, {"まほうぼうぎょ　　＿{0}"}
.define STATUS_YOUR_EXP                 BG3A, {4, 15}, {"げんざいのけいけんち{0}"}
.define STATUS_LEVEL_UP_EXP             BG3A, {4, 19}, {"つぎのレベルまで　あと{0}"}

; ------------------------------------------------------------------------------

; shop menu text strings
.define SHOP_TYPE_1                     BG3A, {3, 2}, {"ぶきや{0}"}
.define SHOP_TYPE_2                     BG3A, {3, 2}, {"ぼうぐや{0}"}
.define SHOP_TYPE_3                     BG3A, {3, 2}, {"どうぐや{0}"}
.define SHOP_TYPE_4                     BG3A, {2, 2}, {"アクセサリーや{0}"}
.define SHOP_TYPE_5                     BG3A, {2, 2}, {"ぎょうしょう{0}"}
.define SHOP_OPTIONS_TEXT               BG3A, {3, 6}, {"かう　　うる　　でる{0}"}
.define SHOP_GIL_1                      BG3A, {28, 6}, {"ギル{0}"}
.define SHOP_GIL_2                      BG3A, {17, 10}, {"ギル{0}"}
.define SHOP_OWNED                      BG3A, {21, 8}, {"もっているかず{0}"}
.define SHOP_EQUIPPED                   BG3A, {21, 12}, {"そうびしているかず{0}"}
.define SHOP_POWER                      BG3A, {6, 12}, {"こうげきりょく　＿{0}"}
.define SHOP_DEFENSE                    BG3A, {6, 12}, {"ぼうぎょ{0}"}
.define SHOP_DOTS                       BG3A, {14, 13}, {"＿{0}"}
.define SHOP_GREETING_MSG               BG3A, {11, 2}, {"「いらっしゃい！どんなごようけんで？」{0}"}
.define SHOP_BUY_MSG                    BG3A, {11, 2}, {"「なにが　ほしいんだいっ！？」　　　　{0}"}
.define SHOP_BUY_QTY_MSG                BG3A, {11, 2}, {"「いくつ　ほしいんだいっ！？」{0}"}
.define SHOP_SELL_MSG                   BG3A, {11, 2}, {"「なにを　うりたいんだい？」　　　　　{0}"}
.define SHOP_SELL_QTY_MSG               BG3A, {11, 2}, {"「いくつ　うりたいんだい？」{0}"}
.define SHOP_BYE_MSG                    BG3A, {11, 2}, {"「まいど　どーも！」　　　　　　　　　{0}"}
.define SHOP_NOT_ENOUGH_GIL_MSG         BG3A, {11, 2}, {"「＿＿おかねが　たりないようだね」{0}"}
.define SHOP_TOO_MANY_MSG               BG3A, {11, 2}, {"「もう　もてないよ」　　　　　{0}"}
.define SHOP_ONLY_ONE_MSG               BG3A, {11, 2}, {"「１つあれば　じゅうぶんだよ」{0}"}

; ------------------------------------------------------------------------------

; config menu text strings
.define CONFIG_COLOR_ARROW_BLANK        BG1B, {22, 18}, {"　　　　　　　{0}"}
.define CONFIG_COLOR_ARROW(xx)          BG1B, {xx, 18}, {"{uparrow}{0}"}

.define CONFIG_CONTROLLER               BG1A, {3, 21}, {"コントローラー{0}"}
.define CONFIG_WAIT                     BG1A, {22, 5}, {"ウェイト{0}"}
.define CONFIG_FAST                     BG1A, {14, 8}, {"はやい{0}"}
.define CONFIG_SLOW                     BG1A, {22, 8}, {"おそい{0}"}
.define CONFIG_CMD_SHORT                BG1A, {22, 11}, {"たんしゅく{0}"}
.define CONFIG_GAUGE_ON                 BG1A, {14, 13}, {"オン{0}"}
.define CONFIG_GAUGE_OFF                BG1A, {22, 13}, {"オフ{0}"}
.define CONFIG_STEREO                   BG1A, {14, 15}, {"ステレオ{0}"}
.define CONFIG_MONO                     BG1A, {22, 15}, {"モノラル{0}"}
.define CONFIG_MEMORY                   BG1A, {22, 17}, {"きおく{0}"}
.define CONFIG_OPTIMUM                  BG1A, {14, 19}, {"さいきょう{0}"}
.define CONFIG_CTRL_NORMAL              BG1A, {14, 21}, {"ノーマル{0}"}
.define CONFIG_CTRL_CUSTOM              BG1A, {22, 21}, {"カスタム{0}"}
.define CONFIG_CTRL_MULTI               BG1A, {22, 23}, {"マルチ{0}"}
.define CONFIG_BATTLE_SPEED_NUM         BG1A, {14, 7}, {"１　２　３　４　５　６{0}"}
.define CONFIG_MSG_SPEED_NUM            BG1A, {14, 9}, {"１　２　３　４　５　６{0}"}
.define CONFIG_CURSOR                   BG1A, {3, 17}, {"カーソルいち{0}"}

.define CONFIG_TITLE                    BG3A, {25, 1}, {"コンフィグ{0}"}
.define CONFIG_BATTLE_MODE              BG1A, {3, 4}, {"バトルモード{0}"}
.define CONFIG_BATTLE_SPEED             BG1A, {5, 6}, {"スピード{0}"}
.define CONFIG_MSG_SPEED                BG1A, {5, 8}, {"メッセージ{0}"}
.define CONFIG_CMD_SET                  BG1A, {5, 10}, {"コマンドしてい{0}"}
.define CONFIG_GAUGE                    BG1A, {5, 12}, {"ゲージ{0}"}
.define CONFIG_SOUND                    BG1A, {3, 14}, {"サウンド{0}"}
.define CONFIG_REEQUIP                  BG1A, {3, 18}, {"さいそうび{0}"}
.define CONFIG_ACTIVE                   BG1A, {14, 4}, {"アクティヴ{0}"}
.define CONFIG_CMD_WINDOW               BG1A, {14, 10}, {"ウィンドウ{0}"}
.define CONFIG_RESET                    BG1A, {14, 16}, {"もどす{0}"}
.define CONFIG_EMPTY                    BG1A, {22, 18}, {"すべてはずす{0}"}
.define CONFIG_CTRL_SINGLE              BG1A, {14, 22}, {"シングル{0}"}

.define CONFIG_MAGIC_ORDER              BG1B, {3, 4}, {"まほうのならびかた{0}"}
.define CONFIG_WINDOW_LABEL             BG1B, {3, 12}, {"ウィンドウ{0}"}
.define CONFIG_COLOR                    BG1B, {3, 14}, {"カラー{0}"}
.define CONFIG_MAGIC_ORDER_A            BG1B, {14, 7}, {"１＿{0}"}
.define CONFIG_MAGIC_ORDER_B            BG1B, {14, 9}, {"２＿{0}"}
.define CONFIG_MAGIC_ORDER_C            BG1B, {14, 11}, {"３＿{0}"}
.define CONFIG_COLOR_BAR_R              BG1B, {18, 19}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define CONFIG_COLOR_BAR_G              BG1B, {18, 21}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define CONFIG_COLOR_BAR_B              BG1B, {18, 23}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}{0}"}
.define CONFIG_COLOR_R                  BG1B, {14, 19}, {r"R{0}"}
.define CONFIG_COLOR_G                  BG1B, {14, 21}, {r"G{0}"}
.define CONFIG_COLOR_B                  BG1B, {14, 23}, {r"B{0}"}
.define CONFIG_WINDOW_NUM               BG1B, {14, 13}, {"１　２　３　４　５　６　７　８{0}"}
.define CONFIG_MAGIC_ORDER_NUM          BG1B, {14, 5}, {"１　２　３　４　５　６{0}"}
.define CONFIG_FONT                     BG1B, {14, 15}, {"フォント{0}"}
.define CONFIG_WINDOW                   BG1B, {22, 14}, {"ウィンドウ{0}"}

.define CONFIG_RETURN                   BG1B, {25, 14}, {"もどす{0}"}
.define CONFIG_COLOR_BOX                BG1B, {22, 17}, {"{1}{2}{3}{4}{5}{6}{7}{0}"}
.define CONFIG_MAGIC_TYPE_1             {"かいふく"}
.define CONFIG_MAGIC_TYPE_2             {"こうげき"}
.define CONFIG_MAGIC_TYPE_3             {"かんせつ"}

.define CMD_ARRANGE_TITLE               BG3A, {3, 1}, {"せいとん{0}"}

.define CHAR_CTRL_TITLE                 BG3A, {2, 12}, {"コントローラーのわりふり{0}"}
.define CHAR_1_CTRL_1                   BG3A, {12, 15}, {"コントローラー１{0}"}
.define CHAR_1_CTRL_2                   BG3A, {21, 15}, {"コントローラー２{0}"}
.define CHAR_2_CTRL_1                   BG3A, {12, 17}, {"コントローラー１{0}"}
.define CHAR_2_CTRL_2                   BG3A, {21, 17}, {"コントローラー２{0}"}
.define CHAR_3_CTRL_1                   BG3A, {12, 19}, {"コントローラー１{0}"}
.define CHAR_3_CTRL_2                   BG3A, {21, 19}, {"コントローラー２{0}"}
.define CHAR_4_CTRL_1                   BG3A, {12, 21}, {"コントローラー１{0}"}
.define CHAR_4_CTRL_2                   BG3A, {21, 21}, {"コントローラー２{0}"}

.define CTRL_CONFIG_TITLE               BG3A, {22, 2}, {"ボタンのせってい{0}"}

.define CTRL_CONFIG_CONFIRM_1           BG3A, {2, 6}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_1            BG3A, {7, 6}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_1              BG3A, {12, 6}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_1             BG3A, {16, 6}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_1               BG3A, {21, 6}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_1               BG3A, {26, 6}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_CONFIRM_2           BG3A, {2, 10}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_2            BG3A, {7, 10}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_2              BG3A, {12, 10}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_2             BG3A, {16, 10}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_2               BG3A, {21, 10}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_2               BG3A, {26, 10}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_CONFIRM_3           BG3A, {2, 14}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_3            BG3A, {7, 14}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_3              BG3A, {12, 14}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_3             BG3A, {16, 14}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_3               BG3A, {21, 14}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_3               BG3A, {26, 14}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_CONFIRM_4           BG3A, {2, 18}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_4            BG3A, {7, 18}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_4              BG3A, {12, 18}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_4             BG3A, {16, 18}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_4               BG3A, {21, 18}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_4               BG3A, {26, 18}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_CONFIRM_5           BG3A, {2, 22}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_5            BG3A, {7, 22}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_5              BG3A, {12, 22}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_5             BG3A, {16, 22}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_5               BG3A, {21, 22}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_5               BG3A, {26, 22}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_CONFIRM_6           BG3A, {2, 26}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_6            BG3A, {7, 26}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_6              BG3A, {12, 26}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_6             BG3A, {16, 26}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_6               BG3A, {21, 26}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_6               BG3A, {26, 26}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_CONFIRM_7           BG3A, {2, 30}, {"けってい{0}"}
.define CTRL_CONFIG_CANCEL_7            BG3A, {7, 30}, {"ちゅうし{0}"}
.define CTRL_CONFIG_MENU_7              BG3A, {12, 30}, {"メニュー{0}"}
.define CTRL_CONFIG_PARTY_7             BG3A, {16, 30}, {"パーティー{0}"}
.define CTRL_CONFIG_ROW_7               BG3A, {21, 30}, {"チェンジ{0}"}
.define CTRL_CONFIG_DEF_7               BG3A, {26, 30}, {"ぼうぎょ{0}"}

.define CTRL_CONFIG_BUTTON_1            BG3A, {5, 4}, {"ボタン{0}"}
.define CTRL_CONFIG_BUTTON_2            BG3A, {5, 8}, {"ボタン{0}"}
.define CTRL_CONFIG_BUTTON_3            BG3A, {5, 12}, {"ボタン{0}"}
.define CTRL_CONFIG_BUTTON_4            BG3A, {5, 16}, {"ボタン{0}"}
.define CTRL_CONFIG_BUTTON_5            BG3A, {5, 20}, {"ボタン{0}"}
.define CTRL_CONFIG_BUTTON_6            BG3A, {5, 24}, {"ボタン{0}"}
.define CTRL_CONFIG_BUTTON_7            BG3A, {7, 28}, {"ボタン{0}"}

.define CTRL_CONFIG_A                   BG3A, {4, 5}, {"バ{0}"}
.define CTRL_CONFIG_B                   BG3A, {4, 9}, {"ば{0}"}
.define CTRL_CONFIG_X                   BG3A, {4, 13}, {"じ{0}"}
.define CTRL_CONFIG_Y                   BG3A, {4, 17}, {"ズ{0}"}
.define CTRL_CONFIG_L                   BG3A, {4, 21}, {"が{0}"}
.define CTRL_CONFIG_R                   BG3A, {4, 25}, {"げ{0}"}
.define CTRL_CONFIG_SELECT_TEXT         BG3A, {4, 29}, {"ゴブが{0}"}

; ------------------------------------------------------------------------------

; save menu text strings
.define SAVE_SLOT_1_EMPTY               BG3A, {3, 8}, {r"EMPTY{0}"}
.define SAVE_SLOT_2_EMPTY               BG3A, {3, 15}, {r"EMPTY{0}"}
.define SAVE_SLOT_3_EMPTY               BG3A, {3, 22}, {r"EMPTY{0}"}
.define SAVE_SLOT_1_TIME                BG3A, {3, 10}, {r"TIME{0}"}
.define SAVE_SLOT_2_TIME                BG3A, {3, 17}, {r"TIME{0}"}
.define SAVE_SLOT_3_TIME                BG3A, {3, 24}, {r"TIME{0}"}
.define SAVE_SLOT_1_TIME_COLON          BG3A, {4, 11}, {r":{0}"}
.define SAVE_SLOT_2_TIME_COLON          BG3A, {4, 18}, {r":{0}"}
.define SAVE_SLOT_3_TIME_COLON          BG3A, {4, 25}, {r":{0}"}
.define SAVE_SLOT_1_LEVEL               BG3A, {25, 8}, {r"LV{0}"}
.define SAVE_SLOT_2_LEVEL               BG3A, {25, 15}, {r"LV{0}"}
.define SAVE_SLOT_3_LEVEL               BG3A, {25, 22}, {r"LV{0}"}
.define SAVE_SLOT_1_HP_SLASH            BG3A, {25, 10}, {r"/{0}"}
.define SAVE_SLOT_2_HP_SLASH            BG3A, {25, 17}, {r"/{0}"}
.define SAVE_SLOT_3_HP_SLASH            BG3A, {25, 24}, {r"/{0}"}

.define SAVE_TITLE                      BG3A, {14, 3}, {"セーブ{0}"}
.define NEW_GAME_TITLE                  BG3A, {13, 3}, {"ニューゲーム{0}"}

; ------------------------------------------------------------------------------

; element symbols
.define ELEMENT_SYMBOLS                 {b"水地聖風毒雷氷炎{0}"}

; ------------------------------------------------------------------------------

; name change menu text strings
.define NAME_CHANGE_LETTERS_1           {"あいうえおざじずぜぞ"}
.define NAME_CHANGE_LETTERS_2           {"かきくけこだぢづでど"}
.define NAME_CHANGE_LETTERS_3           {"さしすせそばびぶべぼ"}
.define NAME_CHANGE_LETTERS_4           {"たちつてとぱぴぷぺぽ"}
.define NAME_CHANGE_LETTERS_5           {"なにぬねのっゃゅょを"}
.define NAME_CHANGE_LETTERS_6           {"はひふへほァィゥェォ"}
.define NAME_CHANGE_LETTERS_7           {"まみむめもーヴ！？＿"}
.define NAME_CHANGE_LETTERS_8           {"やゆよわん０１２３４"}
.define NAME_CHANGE_LETTERS_9           {"らりるれろ５６７８９"}
.define NAME_CHANGE_LETTERS_10          {"がぎぐげご／「」：＋"}
.define NAME_CHANGE_LETTERS_11          {"アイウエオザジズゼゾ"}
.define NAME_CHANGE_LETTERS_12          {"カキクケコダヂヅデド"}
.define NAME_CHANGE_LETTERS_13          {"サシスセソバビブベボ"}
.define NAME_CHANGE_LETTERS_14          {"タチツテトパピプペポ"}
.define NAME_CHANGE_LETTERS_15          {"ナニヌネノッャュョヲ"}
.define NAME_CHANGE_LETTERS_16          {"ハヒフヘホァィゥェォ"}
.define NAME_CHANGE_LETTERS_17          {"マミムメモーヴ！？＿"}
.define NAME_CHANGE_LETTERS_18          {"ヤユヨワン０１２３４"}
.define NAME_CHANGE_LETTERS_19          {"ラリルレロ５６７８９"}
.define NAME_CHANGE_LETTERS_20          {"ガギグゲゴ／「」：＋"}

; ------------------------------------------------------------------------------

; final order menu text strings
.define FINAL_ORDER_END                 BG1A, {4, 30}, {"おわり{0}"}
.define FINAL_ORDER_RESET               BG1A, {4, 4}, {"やりなおし{0}"}
.define FINAL_ORDER_MSG                 BG1A, {10, 2}, {"じゅんばんを　きめてください{0}"}

; ------------------------------------------------------------------------------

.endif