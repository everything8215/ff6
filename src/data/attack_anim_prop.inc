.list off
.ifndef ATTACK_ANIM_PROP_INC
ATTACK_ANIM_PROP_INC = 1

; ------------------------------------------------------------------------------

.mac attack_anim_prop anim_id
        _attack_anim_prop_sprite_script .set $ffff
        _attack_anim_prop_bg1_script .set $ffff
        _attack_anim_prop_bg3_script .set $ffff
        _attack_anim_prop_extra_script .set $ffff
        _attack_anim_prop_sprite_pal .set 0
        _attack_anim_prop_bg1_pal .set 0
        _attack_anim_prop_bg3_pal .set 0
        _attack_anim_prop_sfx .set 0
        _attack_anim_prop_init_fn .set 0
        _attack_anim_prop_delay .set 16
.endmac

.mac sprite_script val
        _attack_anim_prop_sprite_script .set ATTACK_ANIM_SCRIPT::val
.endmac

.mac sprite_gfx val
        _attack_anim_prop_sprite_script .set ATTACK_ANIM_SCRIPT::val | $8000
.endmac

.mac bg1_script val
        _attack_anim_prop_bg1_script .set ATTACK_ANIM_SCRIPT::val
.endmac

.mac bg1_gfx val
        _attack_anim_prop_bg1_script .set ATTACK_ANIM_SCRIPT::val | $8000
.endmac

.mac bg3_script val
        _attack_anim_prop_bg3_script .set ATTACK_ANIM_SCRIPT::val
.endmac

.mac bg3_gfx val
        _attack_anim_prop_bg3_script .set ATTACK_ANIM_SCRIPT::val | $8000
.endmac

.mac extra_script val
        _attack_anim_prop_extra_script .set ATTACK_ANIM_SCRIPT::val
.endmac

.mac extra_gfx val
        _attack_anim_prop_extra_script .set ATTACK_ANIM_SCRIPT::val | $8000
.endmac

.mac sprite_pal val
        _attack_anim_prop_sprite_pal .set val
.endmac

.mac bg1_pal val
        _attack_anim_prop_bg1_pal .set val
.endmac

.mac bg3_pal val
        _attack_anim_prop_bg3_pal .set val
.endmac

.mac sfx val
        _attack_anim_prop_sfx .set SFX::val
.endmac

.mac init_fn val
        _attack_anim_prop_init_fn .set val
.endmac

.mac delay val
        _attack_anim_prop_delay .set val
.endmac

.mac end_attack_anim_prop
        .word _attack_anim_prop_sprite_script
        .word _attack_anim_prop_bg1_script
        .word _attack_anim_prop_bg3_script
        .byte _attack_anim_prop_sprite_pal
        .byte _attack_anim_prop_bg1_pal
        .byte _attack_anim_prop_bg3_pal
        .byte _attack_anim_prop_sfx
        .byte _attack_anim_prop_init_fn
        .word _attack_anim_prop_extra_script
        .byte _attack_anim_prop_delay
.endmac

; ------------------------------------------------------------------------------

.else

.delmac attack_anim_prop
.delmac sprite_script
.delmac sprite_gfx
.delmac bg1_script
.delmac bg1_gfx
.delmac bg3_script
.delmac bg3_gfx
.delmac extra_script
.delmac extra_gfx
.delmac sfx
.delmac init_fn
.delmac delay
.delmac end_attack_anim_prop

.endif
.list on