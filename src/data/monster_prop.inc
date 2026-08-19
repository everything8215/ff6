.ifndef MONSTER_PROP_INC
MONSTER_PROP_INC = 1

; ------------------------------------------------------------------------------

_monster_prop_seq .set 0

.mac monster_prop monster_id
        .assert _monster_prop_seq = MONSTER::monster_id, error, .sprintf("monster_prop index mismatch (%s != %d)", .string(monster_id), _monster_prop_seq)
        _monster_prop_speed .set 0
        _monster_prop_attack_power .set 0
        _monster_prop_hit_rate .set 100
        _monster_prop_evade .set 0
        _monster_prop_mblock .set 0
        _monster_prop_defense .set 0
        _monster_prop_mag_def .set 0
        _monster_prop_mag_pwr .set 0
        _monster_prop_hp .set 0
        _monster_prop_mp .set 0
        _monster_prop_exp .set 0
        _monster_prop_gil .set 0
        _monster_prop_level .set 0
        _monster_prop_attack_anim .set 0
        _monster_prop_special_attack .set 0
        _monster_prop_immune_status1 .set 0
        _monster_prop_immune_status2 .set 0
        _monster_prop_immune_status3 .set 0
        _monster_prop_apply_status1 .set 0
        _monster_prop_apply_status2 .set 0
        _monster_prop_apply_status3 .set 0
        _monster_prop_elem_absorb .set 0
        _monster_prop_elem_null .set 0
        _monster_prop_elem_weak .set 0
        _monster_prop_monster_flags .set 0
        _monster_prop_monster_status .set 0
        _monster_prop_retal_flags .set 0
        _monster_prop_metamorph_items .set 0
        _monster_prop_metamorph_rate .set 0
.endmac

.mac end_monster_prop
        .byte _monster_prop_speed
        .byte _monster_prop_attack_power
        .byte _monster_prop_hit_rate
        .byte _monster_prop_evade
        .byte _monster_prop_mblock
        .byte _monster_prop_defense
        .byte _monster_prop_mag_def
        .byte _monster_prop_mag_pwr
        .word _monster_prop_hp
        .word _monster_prop_mp
        .word _monster_prop_exp
        .word _monster_prop_gil
        .byte _monster_prop_level
        .byte _monster_prop_metamorph_items | (_monster_prop_metamorph_rate << 5)
        .byte _monster_prop_monster_flags
        .byte _monster_prop_monster_status
        .byte _monster_prop_immune_status1
        .byte _monster_prop_immune_status2
        .byte _monster_prop_immune_status3
        .byte _monster_prop_elem_absorb
        .byte _monster_prop_elem_null
        .byte _monster_prop_elem_weak
        .byte _monster_prop_attack_anim
        .byte _monster_prop_apply_status1
        .byte _monster_prop_apply_status2
        .byte _monster_prop_apply_status3
        .byte _monster_prop_retal_flags
        .byte _monster_prop_special_attack
        _monster_prop_seq .set _monster_prop_seq + 1
.endmac

.mac speed val
        _monster_prop_speed .set val
.endmac

.mac attack_power val
        _monster_prop_attack_power .set val
.endmac

.mac hit_rate val
        _monster_prop_hit_rate .set val
.endmac

.mac evade val
        _monster_prop_evade .set val
.endmac

.mac mblock val
        _monster_prop_mblock .set val
.endmac

.mac defense val
        _monster_prop_defense .set val
.endmac

.mac mag_def val
        _monster_prop_mag_def .set val
.endmac

.mac mag_pwr val
        _monster_prop_mag_pwr .set val
.endmac

.mac hp val
        _monster_prop_hp .set val
.endmac

.mac mp val
        _monster_prop_mp .set val
.endmac

.mac exp val
        _monster_prop_exp .set val
.endmac

.mac gil val
        _monster_prop_gil .set val
.endmac

.mac level val
        _monster_prop_level .set val
.endmac

.mac attack_anim val
        _monster_prop_attack_anim .set ITEM::val
.endmac

.mac special_attack val, flags
        .ifnblank flags
                make_bitmask {_monster_prop_special_attack .set}, MONSTER_SPECIAL_EFFECT::val, MONSTER_SPECIAL_FLAGS, flags
        .else
                _monster_prop_special_attack .set MONSTER_SPECIAL_EFFECT::val
        .endif
.endmac

.mac immune_status1 val
        make_bitmask {_monster_prop_immune_status1 .set }, 0, STATUS1, val
.endmac

.mac immune_status2 val
        make_bitmask {_monster_prop_immune_status2 .set }, 0, STATUS2, val
.endmac

.mac immune_status3 val
        make_bitmask {_monster_prop_immune_status3 .set }, 0, STATUS3, val
.endmac

.mac apply_status1 val
        make_bitmask {_monster_prop_apply_status1 .set }, 0, STATUS1, val
.endmac

.mac apply_status2 val
        make_bitmask {_monster_prop_apply_status2 .set }, 0, STATUS2, val
.endmac

.mac apply_status3 val
        make_bitmask {_monster_prop_apply_status3 .set }, 0, STATUS3, val
.endmac

.mac elem_absorb val
        make_bitmask {_monster_prop_elem_absorb .set }, 0, ELEMENT, val
.endmac

.mac elem_null val
        make_bitmask {_monster_prop_elem_null .set }, 0, ELEMENT, val
.endmac

.mac elem_weak val
        make_bitmask {_monster_prop_elem_weak .set }, 0, ELEMENT, val
.endmac

.mac monster_flags val
        make_bitmask {_monster_prop_monster_flags .set }, 0, MONSTER_FLAG, val
.endmac

.mac monster_status val
        make_bitmask {_monster_prop_monster_status .set }, 0, MONSTER_STATUS, val
.endmac

.mac retal_flags val
        make_bitmask {_monster_prop_retal_flags .set }, 0, RETAL_FLAGS, val
.endmac

.mac metamorph items, rate
        _monster_prop_metamorph_items .set items
        _monster_prop_metamorph_rate .set rate
.endmac

; ------------------------------------------------------------------------------

.else

.delmac monster_prop
.delmac end_monster_prop
.delmac speed
.delmac attack_power
.delmac hit_rate
.delmac evade
.delmac mblock
.delmac defense
.delmac mag_def
.delmac mag_pwr
.delmac hp
.delmac mp
.delmac exp
.delmac gil
.delmac level
.delmac attack_anim
.delmac special_attack
.delmac immune_status1
.delmac immune_status2
.delmac immune_status3
.delmac apply_status1
.delmac apply_status2
.delmac apply_status3
.delmac elem_absorb
.delmac elem_null
.delmac elem_weak
.delmac monster_flags
.delmac monster_status
.delmac retal_flags
.delmac metamorph

.endif

; ------------------------------------------------------------------------------
