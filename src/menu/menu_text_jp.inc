.ifndef MENU_TEXT_INC
MENU_TEXT_INC = 1

; ------------------------------------------------------------------------------

; misc. individual text characters
.define ZERO_CHAR                       rz"0"
.define COLON_CHAR                      z":"
.define GAUGE_EMPTY_CHAR                z"{gauge_empty}"
.define GAUGE_FULL_CHAR                 z"{gauge_full}"
.define GAUGE_LEFT_CHAR                 z"{gauge_left}"
.define GAUGE_RIGHT_CHAR                z"{gauge_right}"

; ------------------------------------------------------------------------------

; field menu text strings
.define MAIN_MENU_WOUNDED               {z"せんとうふのう　"}

.define CHAR_BLOCK_1_LEVEL              BG1A, {10, 5}, {r"LV"}
.define CHAR_BLOCK_1_HP                 BG1A, {10, 6}, {r"HP"}
.define CHAR_BLOCK_1_MP                 BG1A, {10, 7}, {r"MP"}
.define CHAR_BLOCK_1_HP_SLASH           BG1A, {17, 6}, {r"/"}
.define CHAR_BLOCK_1_MP_SLASH           BG1A, {17, 7}, {r"/"}

.define CHAR_BLOCK_2_LEVEL              BG1A, {10, 11}, {r"LV"}
.define CHAR_BLOCK_2_HP                 BG1A, {10, 12}, {r"HP"}
.define CHAR_BLOCK_2_MP                 BG1A, {10, 13}, {r"MP"}
.define CHAR_BLOCK_2_HP_SLASH           BG1A, {17, 12}, {r"/"}
.define CHAR_BLOCK_2_MP_SLASH           BG1A, {17, 13}, {r"/"}

.define CHAR_BLOCK_3_LEVEL              BG1A, {10, 17}, {r"LV"}
.define CHAR_BLOCK_3_HP                 BG1A, {10, 18}, {r"HP"}
.define CHAR_BLOCK_3_MP                 BG1A, {10, 19}, {r"MP"}
.define CHAR_BLOCK_3_HP_SLASH           BG1A, {17, 18}, {r"/"}
.define CHAR_BLOCK_3_MP_SLASH           BG1A, {17, 19}, {r"/"}

.define CHAR_BLOCK_4_LEVEL              BG1A, {10, 23}, {r"LV"}
.define CHAR_BLOCK_4_HP                 BG1A, {10, 24}, {r"HP"}
.define CHAR_BLOCK_4_MP                 BG1A, {10, 25}, {r"MP"}
.define CHAR_BLOCK_4_HP_SLASH           BG1A, {17, 24}, {r"/"}
.define CHAR_BLOCK_4_MP_SLASH           BG1A, {17, 25}, {r"/"}

.define MAIN_MENU_ITEM                  BG3A, {25, 3}, {"アイテム"}
.define MAIN_MENU_SKILLS                BG3A, {25, 5}, {"とくしゅ"}
.define MAIN_MENU_EQUIP                 BG3A, {25, 6}, {"そうび"}
.define MAIN_MENU_RELIC                 BG3A, {25, 9}, {"アクセサリ"}
.define MAIN_MENU_STATUS                BG3A, {25, 11}, {"ステータス"}
.define MAIN_MENU_CONFIG                BG3A, {25, 12}, {"コンフィグ"}
.define MAIN_MENU_SAVE                  BG3A, {25, 14}, {"セーブ"}
.define MAIN_MENU_TIME                  BG3A, {25, 17}, {"ごボギブ"}
.define MAIN_MENU_COLON                 BG3A, {27, 18}, {"："}
.define MAIN_MENU_STEPS                 BG3A, {23, 21}, {"ほすう"}
.define MAIN_MENU_GIL                   BG3A, {23, 23}, {"ギル"}

.define GAME_LOAD_YES                   BG3A, {26, 8}, {"はい"}
.define GAME_LOAD_NO                    BG3A, {26, 10}, {"いいえ"}
.define GAME_LOAD_MSG_1                 BG3A, {23, 2}, {"このデータで"}
.define GAME_LOAD_MSG_2                 BG3A, {23, 4}, {"はじめますか？"}

.define GAME_SAVE_MSG_1                 BG3A, {23, 2}, {"これをけして"}
.define GAME_SAVE_MSG_2                 BG3A, {23, 4}, {"かきこみます。"}
.define GAME_SAVE_MSG_3                 BG3A, {23, 6}, {"いいですか？"}
.define GAME_SAVE_UNUSED                BG3A, {23, 16}, {"セーブしました。"}

.define MAIN_MENU_ORDER                 BG3B, {26, 3}, {"たいけい"}

; ------------------------------------------------------------------------------

; colosseum menu text strings
.define COLOSSEUM_ITEM_TITLE            BG3A, {2, 2}, {"コロシアム"}
.define COLOSSEUM_ITEM_MSG              BG3A, {9, 2}, {"アイテムを１つ　えらんでください"}

.define COLOSSEUM_CHAR_BLANK_NAME       BG3A, {22, 15}, {"　　　　　　"}
.define COLOSSEUM_CHAR_MSG              BG3A, {8, 19}, {"ちょうせんしゃをきめてください"}
.define COLOSSEUM_UNKNOWN_PRIZE         BG3A, {4, 3}, {"？？？？？？？？"}

; ------------------------------------------------------------------------------

; skills menu strings
.define SKILLS_LIST_GENJU               BG3A, {2, 2}, {"げんじゅう"}
.define SKILLS_LIST_MAGIC               BG3A, {2, 4}, {"まほう"}
.define SKILLS_LIST_BUSHIDO             BG3A, {2, 8}, {"ひっさつけん"}
.define SKILLS_LIST_BLITZ               BG3A, {2, 10}, {"ひっさつわざ"}
.define SKILLS_LIST_LORE                BG3A, {2, 12}, {"おぼえたわざ"}
.define SKILLS_LIST_RAGE                BG3A, {2, 14}, {"あばれる"}
.define SKILLS_LIST_DANCE               BG3A, {2, 16}, {"おどり"}

.define SKILLS_BLANK_TITLE              BG3B, {2, 2}, {"　　　　　　"}
.define SKILLS_MP_COST                  BG3B, {2, 3}, {"ギぐ＿　　　"}
.define SKILLS_LORE_TITLE               BG3B, {2, 2}, {"おぼえたわざ"}
.define SKILLS_RAGE_TITLE               BG3B, {2, 2}, {"あばれる　　"}
.define SKILLS_DANCE_TITLE              BG3B, {2, 2}, {"おどり　　　"}
.define SKILLS_GENJU_TITLE              BG3B, {2, 2}, {"げんじゅう　"}
.define SKILLS_BLITZ_TITLE              BG3B, {2, 2}, {"ひっさつわざ"}
.define SKILLS_BUSHIDO_TITLE            BG3B, {2, 2}, {"ひっさつけん"}

.define SKILLS_CHAR_LEVEL               BG1B, {18, 7}, {"がざ"}
.define SKILLS_CHAR_HP                  BG1B, {18, 9}, {"べぐ"}
.define SKILLS_CHAR_MP                  BG1B, {18, 11}, {"ギぐ"}
.define SKILLS_CHAR_HP_SLASH            BG1B, {25, 9}, {"／"}
.define SKILLS_CHAR_MP_SLASH            BG1B, {25, 11}, {"／"}

.define GENJU_EQUIP_ERROR_MSG           {"がもっています"}
.define GENJU_LEARN_PCT                 BG1B, {22, 16}, {"じゅくれんど"}
.define GENJU_LEARN_RATE                BG1B, {13, 16}, {"おぼえるスピード"}
.define GENJU_AT_LEVEL_UP               {z"レベルアップのときに　"}

; ------------------------------------------------------------------------------

; bushido renaming menu text strings
.define BUSHIDO_GAUGE                   BG1A, {2, 3}, {"{gauge_left}{gauge_full}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define BUSHIDO_TITLE                   BG1A, {3, 1}, {"ひっさつけん"}

; ------------------------------------------------------------------------------

; item menu text strings
.define ITEM_TITLE                      BG3A, {2, 2}, {"アイテム"}
.define ITEM_OPTION_USE                 BG3A, {10, 2}, {"つかう"}
.define ITEM_OPTION_ARRANGE             BG3A, {16, 2}, {"せいとん"}
.define ITEM_OPTION_RARE                BG3A, {23, 2}, {"だいじなもの"}

.define ITEM_UNKNOWN_ATTACK             BG3B, {29, 23}, {"？？？"}
.define ITEM_STRENGTH                   BG3B, {19, 15}, {"ちから"}
.define ITEM_STAMINA                    BG3B, {19, 19}, {"たいりょく"}
.define ITEM_MAG_PWR                    BG3B, {19, 21}, {"まりょく"}
.define ITEM_EVADE                      BG3B, {19, 27}, {"かいひりつ"}
.define ITEM_MAG_EVADE                  BG3B, {19, 31}, {"まほうかいひりつ"}
.define ITEM_SPEED                      BG3B, {19, 16}, {"すばやさ"}
.define ITEM_ATTACK_PWR                 BG3B, {19, 22}, {"こうげきりょく"}
.define ITEM_DEFENSE                    BG3B, {19, 24}, {"ぼうぎょ"}
.define ITEM_MAG_DEF                    BG3B, {19, 28}, {"まほうぼうぎょ"}
.define ITEM_ELEMENT_HALF               BG3A, {2, 12}, {"はんげん"}
.define ITEM_ELEMENT_ABSORB             BG3A, {16, 12}, {"きゅうしゅう"}
.define ITEM_ELEMENT_NULL               BG3A, {2, 16}, {"むこう"}
.define ITEM_ELEMENT_WEAK               BG3A, {16, 16}, {"じゃくてん"}
.define ITEM_ATTACK_ELEMENT             BG3A, {2, 12}, {"こうげき"}

.define ITEM_STAT_SEP(yy)               BG3B, {27, yy}, {"…"}
.define ITEM_USAGE_MSG                  {"を　そうびできるキャラクター"}

.define ITEM_BUSHIDO                    BG3B, {19, 7}, {"ひっさつけん　グガ"}
.define ITEM_RUNIC                      BG3B, {19, 9}, {"まふうけん　　グガ"}
.define ITEM_2HAND                      BG3B, {19, 11}, {"りょうてもち　グガ"}
.define ITEM_OWNED                      BG3A, {2, 6}, {"もっているかず"}
.define ITEM_BLANK_QTY                  BG3A, {27, 9}, {"　　　"}

.define EVADE_MODIFIER_0                {r"  0"}
.define EVADE_MODIFIER_PLUS_10          {r"+10"}
.define EVADE_MODIFIER_PLUS_20          {r"+20"}
.define EVADE_MODIFIER_PLUS_30          {r"+30"}
.define EVADE_MODIFIER_PLUS_40          {r"+40"}
.define EVADE_MODIFIER_PLUS_50          {r"+50"}
.define EVADE_MODIFIER_MINUS_10         {r"-10"}
.define EVADE_MODIFIER_MINUS_20         {r"-20"}
.define EVADE_MODIFIER_MINUS_30         {r"-30"}
.define EVADE_MODIFIER_MINUS_40         {r"-40"}
.define EVADE_MODIFIER_MINUS_50         {r"-50"}

.define STAT_MODIFIER_0                 {rz" 0"}
.define STAT_MODIFIER_PLUS_1            {rz"+1"}
.define STAT_MODIFIER_PLUS_2            {rz"+2"}
.define STAT_MODIFIER_PLUS_3            {rz"+3"}
.define STAT_MODIFIER_PLUS_4            {rz"+4"}
.define STAT_MODIFIER_PLUS_5            {rz"+5"}
.define STAT_MODIFIER_PLUS_6            {rz"+6"}
.define STAT_MODIFIER_PLUS_7            {rz"+7"}
.define STAT_MODIFIER_MINUS_1           {rz"-1"}
.define STAT_MODIFIER_MINUS_2           {rz"-2"}
.define STAT_MODIFIER_MINUS_3           {rz"-3"}
.define STAT_MODIFIER_MINUS_4           {rz"-4"}
.define STAT_MODIFIER_MINUS_5           {rz"-5"}
.define STAT_MODIFIER_MINUS_6           {rz"-6"}
.define STAT_MODIFIER_MINUS_7           {rz"-7"}

; ------------------------------------------------------------------------------

; equipment menu text strings
.define EQUIP_RHAND                     BG3A, {2, 6}, {"みぎて"}
.define EQUIP_LHAND                     BG3A, {2, 8}, {"ひだりて"}
.define EQUIP_HEAD                      BG3A, {2, 10}, {"あたま"}
.define EQUIP_BODY                      BG3A, {2, 12}, {"からだ"}
.define EQUIP_RELIC1                    BG3A, {2, 10}, {"アクセサリ"}
.define EQUIP_RELIC2                    BG3A, {2, 12}, {"アクセサリ"}
.define EQUIP_BLANK_OPTIONS             BG3A, {4, 2}, {"　　　　　　　　　　　　　　　　　　　　　　　　　　"}
.define EQUIP_TITLE_EQUIP               BG3A, {26, 2}, {"そうび"}
.define EQUIP_TITLE_REMOVE              BG3A, {26, 2}, {"はずす"}
.define EQUIP_OPTION_EQUIP              BG3A, {4, 2}, {"そうび"}
.define EQUIP_OPTION_OPTIMUM            BG3A, {9, 2}, {"さいきょう"}
.define EQUIP_OPTION_REMOVE             BG3A, {16, 2}, {"はずす"}
.define EQUIP_OPTION_EMPTY              BG3A, {22, 2}, {"すべてはずす　"}
.define RELIC_OPTION_EQUIP              BG3A, {4, 2}, {"そうび"}
.define RELIC_OPTION_REMOVE             BG3A, {9, 2}, {"はずす"}

.define EQUIP_STRENGTH                  BG3A, {15, 17}, {"ちから"}
.define EQUIP_SPEED                     BG3A, {15, 18}, {"すばやさ"}
.define EQUIP_STAMINA                   BG3A, {15, 21}, {"たいりょく"}
.define EQUIP_MAG_PWR                   BG3A, {15, 23}, {"まりょく"}
.define EQUIP_ATTACK_PWR                BG3A, {15, 24}, {"こうげきりょく"}
.define EQUIP_DEFENSE                   BG3A, {15, 26}, {"ぼうぎょ"}
.define EQUIP_EVADE                     BG3A, {15, 29}, {"かいひりつ"}
.define EQUIP_MAG_DEF                   BG3A, {15, 30}, {"まほうぼうぎょ"}
.define EQUIP_MAG_EVADE                 BG3A, {15, 33}, {"まほうかいひりつ"}
.define EQUIP_ARROW(yy)                 BG3A, {26, yy}, {"{rightarrow}"}

.define EQUIP_WEAPON_FLAG_1             BG3A, {21, 6}, {"　　　　　　"}
.define EQUIP_WEAPON_FLAG_2             BG3A, {21, 8}, {"　　　　　　"}
.define EQUIP_WEAPON_FLAG_3             BG3A, {19, 8}, {"じゅうそうび"}
.define EQUIP_WEAPON_FLAG_4             BG3A, {19, 6}, {"にとうりゅう"}
.define EQUIP_WEAPON_FLAG_5             BG3A, {19, 8}, {"りょうてもち"}

.define EQUIP_EMPTY_MSG                 BG3A, {12, 2}, {"「すべてはずす」"}
.define EQUIP_OPTIMUM_MSG               BG3A, {12, 2}, {"「さいきょうそうび」"}
.define RELIC_EMPTY_MSG                 BG3A, {12, 4}, {"「すべてはずす」"}
.define RELIC_OPTIMUM_MSG               BG3A, {12, 4}, {"「さいきょうそうび」"}
.define EQUIP_CHANGED_MSG               BG3A, {3, 6}, {"そうびにかかわるアクセサリーが　へんこうされました"}

; item slot names for party equip menu
.define PARTY_EQUIP_SLOT1_RHAND         BG1A, {3, 4}, {"みぎ"}
.define PARTY_EQUIP_SLOT1_LHAND         BG1A, {17, 4}, {"ひだり"}
.define PARTY_EQUIP_SLOT1_HEAD          BG1A, {3, 6}, {"あたま"}
.define PARTY_EQUIP_SLOT1_BODY          BG1A, {17, 6}, {"からだ"}
.define PARTY_EQUIP_SLOT1_RELIC1        BG1A, {3, 8}, {"アク１"}
.define PARTY_EQUIP_SLOT1_RELIC2        BG1A, {17, 8}, {"アク２"}

.define PARTY_EQUIP_SLOT2_RHAND         BG1A, {3, 12}, {"みぎ"}
.define PARTY_EQUIP_SLOT2_LHAND         BG1A, {17, 12}, {"ひだり"}
.define PARTY_EQUIP_SLOT2_HEAD          BG1A, {3, 14}, {"あたま"}
.define PARTY_EQUIP_SLOT2_BODY          BG1A, {17, 14}, {"からだ"}
.define PARTY_EQUIP_SLOT2_RELIC1        BG1A, {3, 16}, {"アク１"}
.define PARTY_EQUIP_SLOT2_RELIC2        BG1A, {17, 16}, {"アク２"}

.define PARTY_EQUIP_SLOT3_RHAND         BG1A, {3, 20}, {"みぎ"}
.define PARTY_EQUIP_SLOT3_LHAND         BG1A, {17, 20}, {"ひだり"}
.define PARTY_EQUIP_SLOT3_HEAD          BG1A, {3, 22}, {"あたま"}
.define PARTY_EQUIP_SLOT3_BODY          BG1A, {17, 22}, {"からだ"}
.define PARTY_EQUIP_SLOT3_RELIC1        BG1A, {3, 24}, {"アク１"}
.define PARTY_EQUIP_SLOT3_RELIC2        BG1A, {17, 24}, {"アク２"}

.define PARTY_EQUIP_SLOT4_RHAND         BG1A, {3, 28}, {"みぎ"}
.define PARTY_EQUIP_SLOT4_LHAND         BG1A, {17, 28}, {"ひだり"}
.define PARTY_EQUIP_SLOT4_HEAD          BG1A, {3, 30}, {"あたま"}
.define PARTY_EQUIP_SLOT4_BODY          BG1A, {17, 30}, {"からだ"}
.define PARTY_EQUIP_SLOT4_RELIC1        BG1A, {3, 32}, {"アク１"}
.define PARTY_EQUIP_SLOT4_RELIC2        BG1A, {17, 32}, {"アク２"}

; ------------------------------------------------------------------------------

; party menu text strings
.define PARTY_LEVEL                     BG1A, {18, 8}, {r"LV"}
.define PARTY_HP                        BG1A, {18, 10}, {r"HP"}
.define PARTY_MP                        BG1A, {18, 12}, {r"MP"}
.define PARTY_HP_SLASH                  BG1A, {25, 10}, {r"/"}
.define PARTY_MP_SLASH                  BG1A, {25, 12}, {r"/"}

.define PARTY_MSG                       BG1A, {10, 2}, {"パーティーを　つ　つくってください"}
.define PARTY_TITLE                     BG1A, {3, 2}, {"へんせい"}
.define PARTY_ERROR_MSG1                BG1A, {10, 2}, {"パーティーのかずが　つありません！"}
.define PARTY_ERROR_MSG2                BG1A, {10, 2}, {"だれもいません！　　　　　　　　　"}

; ------------------------------------------------------------------------------

; status menu text strings
.define STATUS_TITLE                    BG3A, {2, 2}, {"ステータス"}
.define STATUS_HP_SLASH                 BG1A, {17, 8}, {"／"}
.define STATUS_MP_SLASH                 BG1A, {17, 9}, {"／"}
.define STATUS_EVADE_PERCENT            BG3A, {29, 28}, {"％"}
.define STATUS_MAG_EVADE_PERCENT        BG3C, {29, 0}, {"％"}
.define STATUS_LEVEL                    BG1A, {10, 7}, {r"LV"}
.define STATUS_HP                       BG1A, {10, 8}, {r"HP"}
.define STATUS_MP                       BG1A, {10, 9}, {r"MP"}
.define STATUS_STRENGTH                 BG3A, {4, 26}, {"ちから"}
.define STATUS_STAMINA                  BG3A, {4, 30}, {"たいりょく"}
.define STATUS_MAG_PWR                  BG3C, {4, 0}, {"まりょく"}
.define STATUS_EVADE                    BG3A, {16, 28}, {"かいひりつ"}
.define STATUS_MAG_EVADE                BG3C, {16, 0}, {"まほうかいひりつ　＿"}
.define STATUS_STRENGTH_SEP             BG3A, {10, 26}, {"＿"}
.define STATUS_SPEED_SEP                BG3A, {10, 28}, {"＿"}
.define STATUS_STAMINA_SEP              BG3A, {10, 30}, {"＿"}
.define STATUS_MAG_PWR_SEP              BG3C, {10, 0}, {"＿"}
.define STATUS_DEFENSE_SEP              BG3A, {25, 26}, {"＿"}
.define STATUS_EVADE_SEP                BG3A, {25, 28}, {"＿"}
.define STATUS_SPEED                    BG3A, {4, 27}, {"すばやさ"}
.define STATUS_ATTACK_PWR               BG3A, {16, 23}, {"こうげきりょく　　＿"}
.define STATUS_DEFENSE                  BG3A, {16, 25}, {"ぼうぎょ"}
.define STATUS_MAG_DEF                  BG3A, {16, 29}, {"まほうぼうぎょ　　＿"}
.define STATUS_YOUR_EXP                 BG3A, {4, 15}, {"げんざいのけいけんち"}
.define STATUS_LEVEL_UP_EXP             BG3A, {4, 19}, {"つぎのレベルまで　あと"}

; ------------------------------------------------------------------------------

; shop menu text strings
.define SHOP_TYPE_1                     BG3A, {3, 2}, {"ぶきや"}
.define SHOP_TYPE_2                     BG3A, {3, 2}, {"ぼうぐや"}
.define SHOP_TYPE_3                     BG3A, {3, 2}, {"どうぐや"}
.define SHOP_TYPE_4                     BG3A, {2, 2}, {"アクセサリーや"}
.define SHOP_TYPE_5                     BG3A, {2, 2}, {"ぎょうしょう"}
.define SHOP_OPTIONS                    BG3A, {3, 6}, {"かう　　うる　　でる"}
.define SHOP_GIL_1                      BG3A, {28, 6}, {"ギル"}
.define SHOP_GIL_2                      BG3A, {17, 10}, {"ギル"}
.define SHOP_OWNED                      BG3A, {21, 8}, {"もっているかず"}
.define SHOP_EQUIPPED                   BG3A, {21, 12}, {"そうびしているかず"}
.define SHOP_POWER                      BG3A, {6, 12}, {"こうげきりょく　＿"}
.define SHOP_DEFENSE                    BG3A, {6, 12}, {"ぼうぎょ"}
.define SHOP_DOTS                       BG3A, {14, 13}, {"＿"}
.define SHOP_GREETING_MSG               BG3A, {11, 2}, {"「いらっしゃい！どんなごようけんで？」"}
.define SHOP_BUY_MSG                    BG3A, {11, 2}, {"「なにが　ほしいんだいっ！？」　　　　"}
.define SHOP_BUY_QTY_MSG                BG3A, {11, 2}, {"「いくつ　ほしいんだいっ！？」"}
.define SHOP_SELL_MSG                   BG3A, {11, 2}, {"「なにを　うりたいんだい？」　　　　　"}
.define SHOP_SELL_QTY_MSG               BG3A, {11, 2}, {"「いくつ　うりたいんだい？」"}
.define SHOP_BYE_MSG                    BG3A, {11, 2}, {"「まいど　どーも！」　　　　　　　　　"}
.define SHOP_NOT_ENOUGH_GIL_MSG         BG3A, {11, 2}, {"「＿＿おかねが　たりないようだね」"}
.define SHOP_TOO_MANY_MSG               BG3A, {11, 2}, {"「もう　もてないよ」　　　　　"}
.define SHOP_ONLY_ONE_MSG               BG3A, {11, 2}, {"「１つあれば　じゅうぶんだよ」"}

; ------------------------------------------------------------------------------

; config menu text strings
.define CONFIG_COLOR_ARROW_BLANK        BG1B, {22, 18}, {"　　　　　　　"}
.define CONFIG_COLOR_ARROW(xx)          BG1B, {xx, 18}, {"{uparrow}"}

.define CONFIG_CONTROLLER               BG1A, {3, 21}, {"コントローラー"}
.define CONFIG_WAIT                     BG1A, {22, 5}, {"ウェイト"}
.define CONFIG_FAST                     BG1A, {14, 8}, {"はやい"}
.define CONFIG_SLOW                     BG1A, {22, 8}, {"おそい"}
.define CONFIG_CMD_SHORT                BG1A, {22, 11}, {"たんしゅく"}
.define CONFIG_GAUGE_ON                 BG1A, {14, 13}, {"オン"}
.define CONFIG_GAUGE_OFF                BG1A, {22, 13}, {"オフ"}
.define CONFIG_STEREO                   BG1A, {14, 15}, {"ステレオ"}
.define CONFIG_MONO                     BG1A, {22, 15}, {"モノラル"}
.define CONFIG_MEMORY                   BG1A, {22, 17}, {"きおく"}
.define CONFIG_OPTIMUM                  BG1A, {14, 19}, {"さいきょう"}
.define CONFIG_CTRL_NORMAL              BG1A, {14, 21}, {"ノーマル"}
.define CONFIG_CTRL_CUSTOM              BG1A, {22, 21}, {"カスタム"}
.define CONFIG_CTRL_MULTI               BG1A, {22, 23}, {"マルチ"}
.define CONFIG_BATTLE_SPEED_NUM         BG1A, {14, 7}, {"１　２　３　４　５　６"}
.define CONFIG_MSG_SPEED_NUM            BG1A, {14, 9}, {"１　２　３　４　５　６"}
.define CONFIG_CURSOR                   BG1A, {3, 17}, {"カーソルいち"}

.define CONFIG_TITLE                    BG3A, {25, 1}, {"コンフィグ"}
.define CONFIG_BATTLE_MODE              BG1A, {3, 4}, {"バトルモード"}
.define CONFIG_BATTLE_SPEED             BG1A, {5, 6}, {"スピード"}
.define CONFIG_MSG_SPEED                BG1A, {5, 8}, {"メッセージ"}
.define CONFIG_CMD_SET                  BG1A, {5, 10}, {"コマンドしてい"}
.define CONFIG_GAUGE                    BG1A, {5, 12}, {"ゲージ"}
.define CONFIG_SOUND                    BG1A, {3, 14}, {"サウンド"}
.define CONFIG_REEQUIP                  BG1A, {3, 18}, {"さいそうび"}
.define CONFIG_ACTIVE                   BG1A, {14, 4}, {"アクティヴ"}
.define CONFIG_CMD_WINDOW               BG1A, {14, 10}, {"ウィンドウ"}
.define CONFIG_RESET                    BG1A, {14, 16}, {"もどす"}
.define CONFIG_EMPTY                    BG1A, {22, 18}, {"すべてはずす"}
.define CONFIG_CTRL_SINGLE              BG1A, {14, 22}, {"シングル"}

.define CONFIG_MAGIC_ORDER              BG1B, {3, 4}, {"まほうのならびかた"}
.define CONFIG_WINDOW_LABEL             BG1B, {3, 12}, {"ウィンドウ"}
.define CONFIG_COLOR                    BG1B, {3, 14}, {"カラー"}
.define CONFIG_MAGIC_ORDER_A            BG1B, {14, 7}, {"１＿"}
.define CONFIG_MAGIC_ORDER_B            BG1B, {14, 9}, {"２＿"}
.define CONFIG_MAGIC_ORDER_C            BG1B, {14, 11}, {"３＿"}
.define CONFIG_COLOR_BAR_R              BG1B, {18, 19}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define CONFIG_COLOR_BAR_G              BG1B, {18, 21}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define CONFIG_COLOR_BAR_B              BG1B, {18, 23}, {"{gauge_left}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_empty}{gauge_right}"}
.define CONFIG_COLOR_R                  BG1B, {14, 19}, {r"R"}
.define CONFIG_COLOR_G                  BG1B, {14, 21}, {r"G"}
.define CONFIG_COLOR_B                  BG1B, {14, 23}, {r"B"}
.define CONFIG_WINDOW_NUM               BG1B, {14, 13}, {"１　２　３　４　５　６　７　８"}
.define CONFIG_MAGIC_ORDER_NUM          BG1B, {14, 5}, {"１　２　３　４　５　６"}
.define CONFIG_FONT                     BG1B, {14, 15}, {"フォント"}
.define CONFIG_WINDOW                   BG1B, {22, 14}, {"ウィンドウ"}

.define CONFIG_RETURN                   BG1B, {25, 14}, {"もどす"}
.define CONFIG_COLOR_BOX                BG1B, {22, 17}, {"{1}{2}{3}{4}{5}{6}{7}"}
.define CONFIG_MAGIC_TYPE_1             {z"かいふく"}
.define CONFIG_MAGIC_TYPE_2             {z"こうげき"}
.define CONFIG_MAGIC_TYPE_3             {z"かんせつ"}

.define CMD_ARRANGE_TITLE               BG3A, {3, 1}, {"せいとん"}

.define CHAR_CTRL_TITLE                 BG3A, {2, 12}, {"コントローラーのわりふり"}
.define CHAR_1_CTRL_1                   BG3A, {12, 15}, {"コントローラー１"}
.define CHAR_1_CTRL_2                   BG3A, {21, 15}, {"コントローラー２"}
.define CHAR_2_CTRL_1                   BG3A, {12, 17}, {"コントローラー１"}
.define CHAR_2_CTRL_2                   BG3A, {21, 17}, {"コントローラー２"}
.define CHAR_3_CTRL_1                   BG3A, {12, 19}, {"コントローラー１"}
.define CHAR_3_CTRL_2                   BG3A, {21, 19}, {"コントローラー２"}
.define CHAR_4_CTRL_1                   BG3A, {12, 21}, {"コントローラー１"}
.define CHAR_4_CTRL_2                   BG3A, {21, 21}, {"コントローラー２"}

.define CTRL_CONFIG_TITLE               BG3A, {22, 2}, {"ボタンのせってい"}

.define CTRL_CONFIG_CONFIRM_1           BG3A, {2, 6}, {"けってい"}
.define CTRL_CONFIG_CANCEL_1            BG3A, {7, 6}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_1              BG3A, {12, 6}, {"メニュー"}
.define CTRL_CONFIG_PARTY_1             BG3A, {16, 6}, {"パーティー"}
.define CTRL_CONFIG_ROW_1               BG3A, {21, 6}, {"チェンジ"}
.define CTRL_CONFIG_DEF_1               BG3A, {26, 6}, {"ぼうぎょ"}

.define CTRL_CONFIG_CONFIRM_2           BG3A, {2, 10}, {"けってい"}
.define CTRL_CONFIG_CANCEL_2            BG3A, {7, 10}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_2              BG3A, {12, 10}, {"メニュー"}
.define CTRL_CONFIG_PARTY_2             BG3A, {16, 10}, {"パーティー"}
.define CTRL_CONFIG_ROW_2               BG3A, {21, 10}, {"チェンジ"}
.define CTRL_CONFIG_DEF_2               BG3A, {26, 10}, {"ぼうぎょ"}

.define CTRL_CONFIG_CONFIRM_3           BG3A, {2, 14}, {"けってい"}
.define CTRL_CONFIG_CANCEL_3            BG3A, {7, 14}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_3              BG3A, {12, 14}, {"メニュー"}
.define CTRL_CONFIG_PARTY_3             BG3A, {16, 14}, {"パーティー"}
.define CTRL_CONFIG_ROW_3               BG3A, {21, 14}, {"チェンジ"}
.define CTRL_CONFIG_DEF_3               BG3A, {26, 14}, {"ぼうぎょ"}

.define CTRL_CONFIG_CONFIRM_4           BG3A, {2, 18}, {"けってい"}
.define CTRL_CONFIG_CANCEL_4            BG3A, {7, 18}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_4              BG3A, {12, 18}, {"メニュー"}
.define CTRL_CONFIG_PARTY_4             BG3A, {16, 18}, {"パーティー"}
.define CTRL_CONFIG_ROW_4               BG3A, {21, 18}, {"チェンジ"}
.define CTRL_CONFIG_DEF_4               BG3A, {26, 18}, {"ぼうぎょ"}

.define CTRL_CONFIG_CONFIRM_5           BG3A, {2, 22}, {"けってい"}
.define CTRL_CONFIG_CANCEL_5            BG3A, {7, 22}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_5              BG3A, {12, 22}, {"メニュー"}
.define CTRL_CONFIG_PARTY_5             BG3A, {16, 22}, {"パーティー"}
.define CTRL_CONFIG_ROW_5               BG3A, {21, 22}, {"チェンジ"}
.define CTRL_CONFIG_DEF_5               BG3A, {26, 22}, {"ぼうぎょ"}

.define CTRL_CONFIG_CONFIRM_6           BG3A, {2, 26}, {"けってい"}
.define CTRL_CONFIG_CANCEL_6            BG3A, {7, 26}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_6              BG3A, {12, 26}, {"メニュー"}
.define CTRL_CONFIG_PARTY_6             BG3A, {16, 26}, {"パーティー"}
.define CTRL_CONFIG_ROW_6               BG3A, {21, 26}, {"チェンジ"}
.define CTRL_CONFIG_DEF_6               BG3A, {26, 26}, {"ぼうぎょ"}

.define CTRL_CONFIG_CONFIRM_7           BG3A, {2, 30}, {"けってい"}
.define CTRL_CONFIG_CANCEL_7            BG3A, {7, 30}, {"ちゅうし"}
.define CTRL_CONFIG_MENU_7              BG3A, {12, 30}, {"メニュー"}
.define CTRL_CONFIG_PARTY_7             BG3A, {16, 30}, {"パーティー"}
.define CTRL_CONFIG_ROW_7               BG3A, {21, 30}, {"チェンジ"}
.define CTRL_CONFIG_DEF_7               BG3A, {26, 30}, {"ぼうぎょ"}

.define CTRL_CONFIG_BUTTON_1            BG3A, {5, 4}, {"ボタン"}
.define CTRL_CONFIG_BUTTON_2            BG3A, {5, 8}, {"ボタン"}
.define CTRL_CONFIG_BUTTON_3            BG3A, {5, 12}, {"ボタン"}
.define CTRL_CONFIG_BUTTON_4            BG3A, {5, 16}, {"ボタン"}
.define CTRL_CONFIG_BUTTON_5            BG3A, {5, 20}, {"ボタン"}
.define CTRL_CONFIG_BUTTON_6            BG3A, {5, 24}, {"ボタン"}
.define CTRL_CONFIG_BUTTON_7            BG3A, {7, 28}, {"ボタン"}

.define CTRL_CONFIG_A                   BG3A, {4, 5}, {"バ"}
.define CTRL_CONFIG_B                   BG3A, {4, 9}, {"ば"}
.define CTRL_CONFIG_X                   BG3A, {4, 13}, {"じ"}
.define CTRL_CONFIG_Y                   BG3A, {4, 17}, {"ズ"}
.define CTRL_CONFIG_L                   BG3A, {4, 21}, {"が"}
.define CTRL_CONFIG_R                   BG3A, {4, 25}, {"げ"}
.define CTRL_CONFIG_SELECT              BG3A, {4, 29}, {"ゴブが"}

; ------------------------------------------------------------------------------

; save menu text strings
.define SAVE_SLOT_1_EMPTY               BG3A, {3, 8}, {r"EMPTY"}
.define SAVE_SLOT_2_EMPTY               BG3A, {3, 15}, {r"EMPTY"}
.define SAVE_SLOT_3_EMPTY               BG3A, {3, 22}, {r"EMPTY"}
.define SAVE_SLOT_1_TIME                BG3A, {3, 10}, {r"TIME"}
.define SAVE_SLOT_2_TIME                BG3A, {3, 17}, {r"TIME"}
.define SAVE_SLOT_3_TIME                BG3A, {3, 24}, {r"TIME"}
.define SAVE_SLOT_1_TIME_COLON          BG3A, {4, 11}, {r":"}
.define SAVE_SLOT_2_TIME_COLON          BG3A, {4, 18}, {r":"}
.define SAVE_SLOT_3_TIME_COLON          BG3A, {4, 25}, {r":"}
.define SAVE_SLOT_1_LEVEL               BG3A, {25, 8}, {r"LV"}
.define SAVE_SLOT_2_LEVEL               BG3A, {25, 15}, {r"LV"}
.define SAVE_SLOT_3_LEVEL               BG3A, {25, 22}, {r"LV"}
.define SAVE_SLOT_1_HP_SLASH            BG3A, {25, 10}, {r"/"}
.define SAVE_SLOT_2_HP_SLASH            BG3A, {25, 17}, {r"/"}
.define SAVE_SLOT_3_HP_SLASH            BG3A, {25, 24}, {r"/"}

.define SAVE_TITLE                      BG3A, {14, 3}, {"セーブ"}
.define NEW_GAME_TITLE                  BG3A, {13, 3}, {"ニューゲーム"}

; ------------------------------------------------------------------------------

; element symbols
.define ELEMENT_SYMBOLS                 {b"水地聖風毒雷氷炎"}

; ------------------------------------------------------------------------------

; name change menu text strings
.define NAME_CHANGE_LETTERS_1           {z"あいうえおざじずぜぞ"}
.define NAME_CHANGE_LETTERS_2           {z"かきくけこだぢづでど"}
.define NAME_CHANGE_LETTERS_3           {z"さしすせそばびぶべぼ"}
.define NAME_CHANGE_LETTERS_4           {z"たちつてとぱぴぷぺぽ"}
.define NAME_CHANGE_LETTERS_5           {z"なにぬねのっゃゅょを"}
.define NAME_CHANGE_LETTERS_6           {z"はひふへほァィゥェォ"}
.define NAME_CHANGE_LETTERS_7           {z"まみむめもーヴ！？＿"}
.define NAME_CHANGE_LETTERS_8           {z"やゆよわん０１２３４"}
.define NAME_CHANGE_LETTERS_9           {z"らりるれろ５６７８９"}
.define NAME_CHANGE_LETTERS_10          {z"がぎぐげご／「」：＋"}
.define NAME_CHANGE_LETTERS_11          {z"アイウエオザジズゼゾ"}
.define NAME_CHANGE_LETTERS_12          {z"カキクケコダヂヅデド"}
.define NAME_CHANGE_LETTERS_13          {z"サシスセソバビブベボ"}
.define NAME_CHANGE_LETTERS_14          {z"タチツテトパピプペポ"}
.define NAME_CHANGE_LETTERS_15          {z"ナニヌネノッャュョヲ"}
.define NAME_CHANGE_LETTERS_16          {z"ハヒフヘホァィゥェォ"}
.define NAME_CHANGE_LETTERS_17          {z"マミムメモーヴ！？＿"}
.define NAME_CHANGE_LETTERS_18          {z"ヤユヨワン０１２３４"}
.define NAME_CHANGE_LETTERS_19          {z"ラリルレロ５６７８９"}
.define NAME_CHANGE_LETTERS_20          {z"ガギグゲゴ／「」：＋"}

; ------------------------------------------------------------------------------

; final order menu text strings
.define FINAL_ORDER_END                 BG1A, {4, 30}, {"おわり"}
.define FINAL_ORDER_RESET               BG1A, {4, 4}, {"やりなおし"}
.define FINAL_ORDER_MSG                 BG1A, {10, 2}, {"じゅんばんを　きめてください"}

; ------------------------------------------------------------------------------

.endif