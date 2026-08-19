.ifndef GENJU_PROP_INC
GENJU_PROP_INC = 1

_genju_prop_seq .set ATTACK::FIRST_GENJU

.mac genju_prop genju_id
        .assert _genju_prop_seq = ATTACK::genju_id, error, .sprintf("genju_prop index mismatch (%s != %d)", .string(genju_id), _genju_prop_seq)
        _genju_prop_num_spells .set 0
        _genju_prop_spell1 .set ATTACK::NONE
        _genju_prop_spell2 .set ATTACK::NONE
        _genju_prop_spell3 .set ATTACK::NONE
        _genju_prop_spell4 .set ATTACK::NONE
        _genju_prop_spell5 .set ATTACK::NONE
        _genju_prop_rate1 .set 0
        _genju_prop_rate2 .set 0
        _genju_prop_rate3 .set 0
        _genju_prop_rate4 .set 0
        _genju_prop_rate5 .set 0
        _genju_prop_bonus .set GENJU_BONUS::NONE
.endmac

.mac genju_spell spell, rate
        _genju_prop_num_spells .set _genju_prop_num_spells + 1
        .ident(.sprintf("_genju_prop_spell%d", _genju_prop_num_spells)) .set ATTACK::spell
        .ident(.sprintf("_genju_prop_rate%d", _genju_prop_num_spells)) .set rate
.endmac

.mac genju_bonus bonus
        _genju_prop_bonus .set GENJU_BONUS::bonus
.endmac

.mac end_genju_prop
        .byte _genju_prop_rate1, _genju_prop_spell1
        .byte _genju_prop_rate2, _genju_prop_spell2
        .byte _genju_prop_rate3, _genju_prop_spell3
        .byte _genju_prop_rate4, _genju_prop_spell4
        .byte _genju_prop_rate5, _genju_prop_spell5
        .byte _genju_prop_bonus
        _genju_prop_seq .set _genju_prop_seq + 1
.endmac

.else

        .delmac genju_prop
        .delmac genju_spell
        .delmac genju_bonus
        .delmac end_genju_prop

.endif
