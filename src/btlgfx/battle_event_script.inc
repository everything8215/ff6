.list off
.ifndef BATTLE_EVENT_SCRIPT_INC
BATTLE_EVENT_SCRIPT_INC = 1

.global BattleEventScript, BattleEventScriptPtrs

.enum BATTLE_EVENT_SCRIPT

        CHAR_ENTRY                      ; = 0
        VICTORY_FANFARE                 ; = 1
        BATTLE_EVENT_SCRIPT_2           ; = 2
        BATTLE_EVENT_SCRIPT_3           ; = 3
        TRITOCH_INTRO                   ; = 4
        WHELK_INTRO                     ; = 5
        TERRA_MAGIC                     ; = 6
        SABIN_INTRO                     ; = 7
        BLITZ_TUTORIAL                  ; = 8
        VARGAS_DEFEATED                 ; = 9
        ULTROS_RIVER_DEFEATED           ; = 10
        SHADOW_LEAVES_PARTY             ; = 11
        CYAN_INTRO                      ; = 12
        GAU_INTRO                       ; = 13
        STEAL_GREEN_SOLDIER             ; = 14
        STEAL_MERCHANT                  ; = 15
        TUNNELARMR_INTRO                ; = 16
        KEFKA_TERRA_INTRO               ; = 17
        TRITOCH_TERRA_TRANSFORMS        ; = 18
        KEFKA_SEALED_GATE_1             ; = 19
        KEFKA_SEALED_GATE_2             ; = 20
        AIRSHIP_GENJU                   ; = 21
        RELM_ULTROS_INTRO               ; = 22
        KEFKA_KILLS_LEO                 ; = 23
        THAMASA_SEALED_GATE             ; = 24
        UNUSED_BLITZ_TUTORIAL           ; = 25
        KEFKA_GENJU_MAGICITE            ; = 26
        GAU_APPEARS                     ; = 27
        GAU_RUNS_AWAY                   ; = 28
        SABIN_KEFKA_IMPERIAL_CAMP       ; = 29
        KEFKA_KILLS_GESTAHL             ; = 30
        WREXSOUL_INTRO                  ; = 31
        FINAL_BATTLE_INTRO              ; = 32

        COUNT                           ; = 33

.endenum

.endif
.list on
