; ------------------------------------------------------------------------------

.export SubBattleRate

; ------------------------------------------------------------------------------

.mac sub_battle_rate map_id, rate
        .if rate & 1
                bitlist_set map_id * 2
        .endif
        .if rate & 2
                bitlist_set map_id * 2 + 1
        .endif
.endmac

; ------------------------------------------------------------------------------

; 128 bytes total
; 2 bits per sub-map (lower map ids in lower bits)
;   0: normal
;   1: low
;   2: high
;   3: very high (never used)

; all maps have normal battle rate except those listed below

; cf/5880
SubBattleRate:
        bitlist 1024
        sub_battle_rate 41, 1           ; narshe whelk cave (intro)
        sub_battle_rate 262, 1          ; magitek factory
        sub_battle_rate 263, 1          ; magitek factory
        sub_battle_rate 264, 1          ; magitek factory
        sub_battle_rate 313, 1          ; phoenix cave
        sub_battle_rate 314, 1          ; phoenix cave
        sub_battle_rate 315, 1          ; phoenix cave
        sub_battle_rate 316, 1          ; phoenix cave
        sub_battle_rate 405, 2          ; ebot's rock (not teleporter caves)
        end_bitlist

; ------------------------------------------------------------------------------
