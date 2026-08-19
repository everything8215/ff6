
.export WeaponAnimProp
.export MonsterAttackAnimProp

; ------------------------------------------------------------------------------

.mac weapon_anim_prop item_id
        _weapon_anim_prop_r_script .set 0
        _weapon_anim_prop_l_script .set 0
        _weapon_anim_prop_weapon_pal .set 0
        _weapon_anim_prop_hit_script .set 0
        _weapon_anim_prop_hit_pal .set 0
        _weapon_anim_prop_init_fn .set 0
        _weapon_anim_prop_hit_is_sprite .set 0
        _weapon_anim_prop_sfx .set 0
.endmac

.mac r_script val
        .assert ATTACK_ANIM_SCRIPT::val, error, .sprintf("Invalid weapon script: %s", .string(val))
        _weapon_anim_prop_r_script .set ATTACK_ANIM_SCRIPT::val
.endmac

.mac l_script val
        .assert ATTACK_ANIM_SCRIPT::val, error, .sprintf("Invalid weapon script: %s", .string(val))
        _weapon_anim_prop_l_script .set ATTACK_ANIM_SCRIPT::val
.endmac

.mac weapon_script val
        r_script val
        l_script val
.endmac

.mac weapon_pal val
        _weapon_anim_prop_weapon_pal .set val
.endmac

.mac hit_script val
        .if ATTACK_ANIM_SCRIPT::val <= $60
                _weapon_anim_prop_hit_script .set ATTACK_ANIM_SCRIPT::val
        .elseif ATTACK_ANIM_SCRIPT::val > $0260
                _weapon_anim_prop_hit_script .set ATTACK_ANIM_SCRIPT::val & $ff
        .else
                .error .sprintf("Invalid hit script: %s", .string(val))
        .endif
.endmac

.mac hit_pal val
        _weapon_anim_prop_hit_pal .set val
.endmac

.mac init_fn val
        _weapon_anim_prop_init_fn .set val
.endmac

.mac hit_is_sprite
        _weapon_anim_prop_hit_is_sprite .set $80
.endmac

.mac sfx val
        _weapon_anim_prop_sfx .set SFX::val
.endmac

.mac end_weapon_anim_prop
        .byte _weapon_anim_prop_r_script
        .byte _weapon_anim_prop_l_script
        .byte _weapon_anim_prop_weapon_pal
        .byte _weapon_anim_prop_hit_script
        .byte _weapon_anim_prop_hit_pal
        .byte _weapon_anim_prop_init_fn | _weapon_anim_prop_hit_is_sprite
        .byte _weapon_anim_prop_sfx
        .byte 0
.endmac

; ------------------------------------------------------------------------------

.segment "weapon_anim_prop"

; ec/e400
WeaponAnimProp:

; ------------------------------------------------------------------------------

; 0: UNARMED
        weapon_anim_prop UNARMED
        weapon_script UNARMED_SPRITE
        weapon_pal 35
        hit_script UNARMED_HIT_BG1
        hit_pal 54
        sfx PUNCH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 1: DIRK
        weapon_anim_prop DIRK
        weapon_script KNIFE_SPRITE
        weapon_pal 24
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 2: MITHRILKNIFE
        weapon_anim_prop MITHRILKNIFE
        weapon_script KNIFE_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 3: MAIN_GAUCHE
        weapon_anim_prop MAIN_GAUCHE
        weapon_script MAIN_GAUCHE_SPRITE
        weapon_pal 25
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 4: AIR_LANCET
        weapon_anim_prop AIR_LANCET
        weapon_script AIR_LANCET_SPRITE
        weapon_pal 25
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 5: THIEFKNIFE
        weapon_anim_prop THIEFKNIFE
        weapon_script KNIFE_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 6: ASSASSIN
        weapon_anim_prop ASSASSIN
        weapon_script KNIFE_SPRITE
        weapon_pal 33
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 55
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 7: MAN_EATER
        weapon_anim_prop MAN_EATER
        weapon_script MAIN_GAUCHE_SPRITE
        weapon_pal 40
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 53
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 8: SWORDBREAKER
        weapon_anim_prop SWORDBREAKER
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 50
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 9: GRAEDUS
        weapon_anim_prop GRAEDUS
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 25
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 49
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 10: VALIANTKNIFE
        weapon_anim_prop VALIANTKNIFE
        weapon_script VALIANTKNIFE_SPRITE
        weapon_pal 24
        hit_script HORZ_HIT_BG1
        hit_pal 51
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 11: MITHRILBLADE
        weapon_anim_prop MITHRILBLADE
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 12: REGAL_CUTLASS
        weapon_anim_prop REGAL_CUTLASS
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 13: RUNE_EDGE
        weapon_anim_prop RUNE_EDGE
        weapon_script RUNE_BLADE_SPRITE
        weapon_pal 32
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 55
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 14: FLAME_SABRE
        weapon_anim_prop FLAME_SABRE
        weapon_script FLAME_SABRE_SPRITE
        weapon_pal 41
        hit_script STAB_HIT_1_BG1
        hit_pal 52
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 15: BLIZZARD
        weapon_anim_prop BLIZZARD
        weapon_script FLAME_SABRE_SPRITE
        weapon_pal 34
        hit_script STAB_HIT_2_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 16: THUNDERBLADE
        weapon_anim_prop THUNDERBLADE
        weapon_script THUNDERBLADE_SPRITE
        weapon_pal 32
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 55
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 17: EPEE
        weapon_anim_prop EPEE
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 18: BREAK_BLADE
        weapon_anim_prop BREAK_BLADE
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 42
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 19: DRAINER
        weapon_anim_prop DRAINER
        weapon_script MYSTIC_SWORD_SPRITE
        weapon_pal 41
        hit_script STAB_HIT_3_BG1
        hit_pal 53
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 20: ENHANCER
        weapon_anim_prop ENHANCER
        weapon_script RUNE_BLADE_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 21: CRYSTAL
        weapon_anim_prop CRYSTAL
        weapon_script SHORT_SWORD_SPRITE
        weapon_pal 25
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 22: FALCHION
        weapon_anim_prop FALCHION
        weapon_script FALCHION_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 23: SOUL_SABRE
        weapon_anim_prop SOUL_SABRE
        weapon_script SOUL_SABRE_SPRITE
        weapon_pal 42
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 24: OGRE_NIX
        weapon_anim_prop OGRE_NIX
        weapon_script SOUL_SABRE_SPRITE
        weapon_pal 29
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 25: EXCALIBUR
        weapon_anim_prop EXCALIBUR
        weapon_script MYSTIC_SWORD_SPRITE
        weapon_pal 32
        hit_script STAB_HIT_1_BG1
        hit_pal 55
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 26: SCIMITAR
        weapon_anim_prop SCIMITAR
        weapon_script SCIMITAR_SPRITE
        weapon_pal 42
        hit_script HORZ_HIT_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 27: ILLUMINA
        weapon_anim_prop ILLUMINA
        weapon_script ILLUMINA_SPRITE
        weapon_pal 32
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 55
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 28: RAGNAROK
        weapon_anim_prop RAGNAROK
        weapon_script MYSTIC_SWORD_SPRITE
        weapon_pal 32
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 55
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 29: ATMA_WEAPON_1
        weapon_anim_prop ATMA_WEAPON_1
        weapon_script ATMA_WEAPON_1_SPRITE
        weapon_pal 31
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 120
        sfx SWORD_SLASH
        init_fn 4
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 30: MITHRIL_PIKE
        weapon_anim_prop MITHRIL_PIKE
        weapon_script SPEAR_SPRITE
        weapon_pal 42
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 31: TRIDENT
        weapon_anim_prop TRIDENT
        weapon_script TRIDENT_SPRITE
        weapon_pal 42
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 32: STOUT_SPEAR
        weapon_anim_prop STOUT_SPEAR
        weapon_script SPEAR_SPRITE
        weapon_pal 24
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 33: PARTISAN
        weapon_anim_prop PARTISAN
        weapon_script TRIDENT_SPRITE
        weapon_pal 41
        hit_script TRIPLE_HORZ_HIT_BG1
        hit_pal 52
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 34: PEARL_LANCE
        weapon_anim_prop PEARL_LANCE
        weapon_script TRIDENT_SPRITE
        weapon_pal 34
        hit_script TRIPLE_HORZ_HIT_BG1
        hit_pal 50
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 35: GOLD_LANCE
        weapon_anim_prop GOLD_LANCE
        weapon_script SPEAR_SPRITE
        weapon_pal 32
        hit_script HORZ_HIT_BG1
        hit_pal 55
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 36: AURA_LANCE
        weapon_anim_prop AURA_LANCE
        weapon_script AURA_LANCE_SPRITE
        weapon_pal 43
        hit_script HORZ_HIT_BG1
        hit_pal 51
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 37: IMP_HALBERD
        weapon_anim_prop IMP_HALBERD
        weapon_script IMP_HALBERD_SPRITE
        weapon_pal 29
        hit_script HORZ_HIT_BG1
        hit_pal 50
        sfx SPEAR
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 38: IMPERIAL
        weapon_anim_prop IMPERIAL
        r_script NINJA_SWORD_SPRITE
        l_script NINJA_SWORD_ALT_SPRITE
        weapon_pal 24
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 39: KODACHI
        weapon_anim_prop KODACHI
        r_script NINJA_SWORD_SPRITE
        l_script NINJA_SWORD_ALT_SPRITE
        weapon_pal 24
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 40: BLOSSOM
        weapon_anim_prop BLOSSOM
        r_script NINJA_SWORD_SPRITE
        l_script NINJA_SWORD_ALT_SPRITE
        weapon_pal 41
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 53
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 41: HARDENED
        weapon_anim_prop HARDENED
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 24
        hit_script STAB_HIT_2_BG1
        hit_pal 51
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 42: STRIKER
        weapon_anim_prop STRIKER
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 34
        hit_script STAB_HIT_2_BG1
        hit_pal 50
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 43: STUNNER
        weapon_anim_prop STUNNER
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 32
        hit_script STAB_HIT_2_BG1
        hit_pal 55
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 44: ASHURA
        weapon_anim_prop ASHURA
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 25
        hit_script KATANA_HIT_BG1
        hit_pal 54
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 45: KOTETSU
        weapon_anim_prop KOTETSU
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 24
        hit_script KATANA_HIT_BG1
        hit_pal 54
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 46: FORGED
        weapon_anim_prop FORGED
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 24
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 47: TEMPEST
        weapon_anim_prop TEMPEST
        weapon_script SHORT_KATANA_SPRITE
        weapon_pal 34
        hit_script HORZ_HIT_BG1
        hit_pal 50
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 48: MURASAME
        weapon_anim_prop MURASAME
        weapon_script LONG_KATANA_SPRITE
        weapon_pal 24
        hit_script KATANA_HIT_BG1
        hit_pal 54
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 49: AURA
        weapon_anim_prop AURA
        weapon_script LONG_KATANA_SPRITE
        weapon_pal 29
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 51
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 50: STRATO
        weapon_anim_prop STRATO
        weapon_script LONG_KATANA_SPRITE
        weapon_pal 34
        hit_script STAB_HIT_3_BG1
        hit_pal 50
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 51: SKY_RENDER
        weapon_anim_prop SKY_RENDER
        weapon_script LONG_KATANA_SPRITE
        weapon_pal 32
        hit_script STAB_HIT_2_BG1
        hit_pal 55
        sfx SWORD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 52: HEAL_ROD
        weapon_anim_prop HEAL_ROD
        weapon_script ROD_SPRITE
        weapon_pal 25
        hit_script ROD_HIT_BG1
        hit_pal 48
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 53: MITHRIL_ROD
        weapon_anim_prop MITHRIL_ROD
        weapon_script ROD_SPRITE
        weapon_pal 42
        hit_script ROD_HIT_BG1
        hit_pal 54
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 54: FIRE_ROD
        weapon_anim_prop FIRE_ROD
        weapon_script ROD_SPRITE
        weapon_pal 45
        hit_script ROD_HIT_BG1
        hit_pal 52
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 55: ICE_ROD
        weapon_anim_prop ICE_ROD
        weapon_script ROD_SPRITE
        weapon_pal 44
        hit_script ROD_HIT_BG1
        hit_pal 50
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 56: THUNDER_ROD
        weapon_anim_prop THUNDER_ROD
        weapon_script ROD_SPRITE
        weapon_pal 37
        hit_script ROD_HIT_BG1
        hit_pal 55
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 57: POISON_ROD
        weapon_anim_prop POISON_ROD
        weapon_script ROD_SPRITE
        weapon_pal 42
        hit_script ROD_HIT_BG1
        hit_pal 54
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 58: PEARL_ROD
        weapon_anim_prop PEARL_ROD
        weapon_script ROD_SPRITE
        weapon_pal 44
        hit_script UNARMED_HIT_BG1
        hit_pal 51
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 59: GRAVITY_ROD
        weapon_anim_prop GRAVITY_ROD
        weapon_script ROD_SPRITE
        weapon_pal 42
        hit_script UNARMED_HIT_BG1
        hit_pal 54
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 60: PUNISHER
        weapon_anim_prop PUNISHER
        weapon_script PUNISHER_SPRITE
        weapon_pal 32
        hit_script UNARMED_HIT_BG1
        hit_pal 54
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 61: MAGUS_ROD
        weapon_anim_prop MAGUS_ROD
        weapon_script ROD_SPRITE
        weapon_pal 41
        hit_script UNARMED_HIT_BG1
        hit_pal 53
        sfx ROD
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 62: CHOCOBO_BRSH
        weapon_anim_prop CHOCOBO_BRSH
        weapon_script CHOCO_BRUSH_SPRITE
        weapon_pal 37
        hit_script STAB_HIT_3_BG1
        hit_pal 55
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 63: DAVINCI_BRSH
        weapon_anim_prop DAVINCI_BRSH
        weapon_script DAVINCI_BRUSH_SPRITE
        weapon_pal 25
        hit_script STAB_HIT_3_BG1
        hit_pal 50
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 64: MAGICAL_BRSH
        weapon_anim_prop MAGICAL_BRSH
        weapon_script SHORT_BRUSH_SPRITE
        weapon_pal 37
        hit_script STAB_HIT_3_BG1
        hit_pal 53
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 65: RAINBOW_BRSH
        weapon_anim_prop RAINBOW_BRSH
        weapon_script SHORT_BRUSH_SPRITE
        weapon_pal 25
        hit_script STAB_HIT_3_BG1
        hit_pal 48
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 66: SHURIKEN
        weapon_anim_prop SHURIKEN
        weapon_script SHURIKEN_SPRITE
        weapon_pal 24
        hit_script SHURIKEN_HIT_SPRITE
        hit_pal 24
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 67: NINJA_STAR
        weapon_anim_prop NINJA_STAR
        weapon_script NINJA_STAR_SPRITE
        weapon_pal 24
        hit_script NINJA_STAR_HIT_SPRITE
        hit_pal 24
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 68: TACK_STAR
        weapon_anim_prop TACK_STAR
        weapon_script SHURIKEN_SPRITE
        weapon_pal 46
        hit_script SHURIKEN_HIT_SPRITE
        hit_pal 24
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 69: FLAIL
        weapon_anim_prop FLAIL
        weapon_script FLAIL_SPRITE
        weapon_pal 25
        hit_script UNARMED_HIT_BG1
        hit_pal 25
        sfx FLAIL
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 70: FULL_MOON
        weapon_anim_prop FULL_MOON
        weapon_script FULL_MOON_SPRITE
        weapon_pal 28
        hit_script FULL_MOON_HIT_SPRITE
        hit_pal 28
        hit_is_sprite
        sfx EVENT_JUMP
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 71: MORNING_STAR
        weapon_anim_prop MORNING_STAR
        weapon_script FLAIL_SPRITE
        weapon_pal 25
        hit_script UNARMED_HIT_BG1
        hit_pal 54
        sfx FLAIL
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 72: BOOMERANG
        weapon_anim_prop BOOMERANG
        weapon_script BOOMERANG_SPRITE
        weapon_pal 24
        hit_script BOOMERANG_HIT_SPRITE
        hit_pal 24
        hit_is_sprite
        sfx SHRAPNEL
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 73: RISING_SUN
        weapon_anim_prop RISING_SUN
        weapon_script FULL_MOON_SPRITE
        weapon_pal 36
        hit_script FULL_MOON_HIT_SPRITE
        hit_pal 36
        hit_is_sprite
        sfx EVENT_JUMP
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 74: HAWK_EYE
        weapon_anim_prop HAWK_EYE
        weapon_script HAWK_EYE_SPRITE
        weapon_pal 29
        hit_script KATANA_HIT_BG1
        hit_pal 50
        sfx PUNCH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 75: BONE_CLUB
        weapon_anim_prop BONE_CLUB
        weapon_script BONE_CLUB_SPRITE
        weapon_pal 38
        hit_script UNARMED_HIT_BG1
        hit_pal 54
        sfx PUNCH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 76: SNIPER
        weapon_anim_prop SNIPER
        weapon_script HAWK_EYE_SPRITE
        weapon_pal 37
        hit_script KATANA_HIT_BG1
        hit_pal 52
        sfx PUNCH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 77: WING_EDGE
        weapon_anim_prop WING_EDGE
        weapon_script BOOMERANG_SPRITE
        weapon_pal 34
        hit_script BOOMERANG_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 78: CARDS
        weapon_anim_prop CARDS
        weapon_script CARDS_SPRITE
        weapon_pal 24
        hit_script CARDS_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 79: DARTS
        weapon_anim_prop DARTS
        weapon_script DARTS_SPRITE
        weapon_pal 24
        hit_script DARTS_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 80: DOOM_DARTS
        weapon_anim_prop DOOM_DARTS
        weapon_script DOOM_DARTS_SPRITE
        weapon_pal 25
        hit_script CARDS_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 81: TRUMP
        weapon_anim_prop TRUMP
        weapon_script TRUMP_SPRITE
        weapon_pal 25
        hit_script DARTS_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 82: DICE
        weapon_anim_prop DICE
        weapon_script DICE_SPRITE
        weapon_pal 30
        hit_script DARTS_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 83: FIXED_DICE
        weapon_anim_prop FIXED_DICE
        weapon_script DICE_SPRITE
        weapon_pal 30
        hit_script DARTS_HIT_SPRITE
        hit_pal 54
        hit_is_sprite
        sfx STEAL
        init_fn 1
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 84: METALKNUCKLE
        weapon_anim_prop METALKNUCKLE
        weapon_script CLAW_PUNCH_SPRITE
        weapon_pal 24
        hit_script TRIPLE_HORZ_HIT_BG1
        hit_pal 54
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 85: MITHRIL_CLAW
        weapon_anim_prop MITHRIL_CLAW
        r_script CLAW_RIGHT_SPRITE
        l_script CLAW_LEFT_SPRITE
        weapon_pal 25
        hit_script CLAW_HIT_BG1
        hit_pal 54
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 86: KAISER
        weapon_anim_prop KAISER
        weapon_script CLAW_ALT_SPRITE
        weapon_pal 25
        hit_script CLAW_HIT_BG1
        hit_pal 49
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 87: POISON_CLAW
        weapon_anim_prop POISON_CLAW
        weapon_script CLAW_PUNCH_SPRITE
        weapon_pal 42
        hit_script TRIPLE_HORZ_HIT_BG1
        hit_pal 54
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 88: FIRE_KNUCKLE
        weapon_anim_prop FIRE_KNUCKLE
        r_script CLAW_RIGHT_SPRITE
        l_script CLAW_LEFT_SPRITE
        weapon_pal 24
        hit_script TRIPLE_HORZ_HIT_BG1
        hit_pal 51
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 89: DRAGON_CLAW
        weapon_anim_prop DRAGON_CLAW
        r_script CLAW_RIGHT_SPRITE
        l_script CLAW_LEFT_SPRITE
        weapon_pal 40
        hit_script CLAW_HIT_BG1
        hit_pal 52
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 90: TIGER_FANGS
        weapon_anim_prop TIGER_FANGS
        weapon_script CLAW_ALT_SPRITE
        weapon_pal 32
        hit_script CLAW_HIT_BG1
        hit_pal 55
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 91: ATMA_WEAPON_2
        weapon_anim_prop ATMA_WEAPON_2
        weapon_script ATMA_WEAPON_2_SPRITE
        weapon_pal 31
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 120
        sfx SWORD_SLASH
        init_fn 4
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 92: ATMA_WEAPON_3
        weapon_anim_prop ATMA_WEAPON_3
        weapon_script ATMA_WEAPON_3_SPRITE
        weapon_pal 31
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 120
        sfx SWORD_SLASH
        init_fn 3
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; ec/e6e8
MonsterAttackAnimProp:

; ------------------------------------------------------------------------------

; 93: MULTI_PUNCH
        weapon_anim_prop MULTI_PUNCH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script UNARMED_HIT_BG1
        hit_pal 54
        sfx PUNCH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 94: THICK_DIAG_SLASH
        weapon_anim_prop THICK_DIAG_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 95: THIN_DIAG_SLASH
        weapon_anim_prop THIN_DIAG_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script THIN_DIAG_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 96: RED_STAB
        weapon_anim_prop RED_STAB
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script STAB_HIT_1_BG1
        hit_pal 52
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 97: BLUE_STAB_1
        weapon_anim_prop BLUE_STAB_1
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script STAB_HIT_2_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 98: BLUE_STAB_2
        weapon_anim_prop BLUE_STAB_2
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script STAB_HIT_3_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 99: THICK_HORZ_SLASH
        weapon_anim_prop THICK_HORZ_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script HORZ_HIT_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 100: ARC_SLASH
        weapon_anim_prop ARC_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script KATANA_HIT_BG1
        hit_pal 50
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 101: DIAG_CLAW
        weapon_anim_prop DIAG_CLAW
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script CLAW_HIT_BG1
        hit_pal 52
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 102: LARGE_PIERCE
        weapon_anim_prop LARGE_PIERCE
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script ROD_HIT_BG1
        hit_pal 48
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 103: HORZ_CLAW
        weapon_anim_prop HORZ_CLAW
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script TRIPLE_HORZ_HIT_BG1
        hit_pal 54
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 104: THIN_HORZ_SLASH
        weapon_anim_prop THIN_HORZ_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script THIN_HORZ_HIT_BG1
        hit_pal 54
        sfx CLAW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 105: SINGLE_PUNCH
        weapon_anim_prop SINGLE_PUNCH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script STAR_HIT_BG1
        hit_pal 54
        sfx PUNCH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 106: VERT_SLASH
        weapon_anim_prop VERT_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script VERTICAL_HIT_BG1
        hit_pal 54
        sfx SWORD_SLASH
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 107: SMALL_PIERCE
        weapon_anim_prop SMALL_PIERCE
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script BIT_HIT_BG1
        hit_pal 54
        sfx THROW
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 108: STING
        weapon_anim_prop STING
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script NEEDLE_HIT_BG1
        hit_pal 58
        sfx NEEDLES
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 109: BLACK_CLOUD
        weapon_anim_prop BLACK_CLOUD
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script INK_HIT_BG1
        hit_pal 171
        sfx SMOKE_BOMB
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 110: HAMMER
        weapon_anim_prop HAMMER
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script HAMMER_HIT_BG1
        hit_pal 24
        sfx TREASURE_POT
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 111: BONE
        weapon_anim_prop BONE
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script BONE_HIT_BG1
        hit_pal 24
        sfx WRENCH
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 112: WRENCH
        weapon_anim_prop WRENCH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script WRENCH_HIT_BG1
        hit_pal 24
        sfx WRENCH
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 113: LIGHTNING
        weapon_anim_prop LIGHTNING
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script LIGHTNING_HIT_BG1
        hit_pal 201
        sfx THUNDARA
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 114: LIGHT_BEAM
        weapon_anim_prop LIGHT_BEAM
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script BEAM_HIT_BG1
        hit_pal 120
        sfx CALMNESS
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 115: AIR_ANCHOR
        weapon_anim_prop AIR_ANCHOR
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script ROBOT_HIT_BG1
        hit_pal 1
        sfx AIR_ANCHOR
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 116: BLOB_MAN
        weapon_anim_prop BLOB_MAN
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script SLIME_HIT_BG1
        hit_pal 120
        sfx BLUE_MAN
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 117: BUBBLE
        weapon_anim_prop BUBBLE
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script BUBBLE_HIT_BG1
        hit_pal 120
        sfx AQUA_RAKE
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 118: MUSIC_NOTE
        weapon_anim_prop MUSIC_NOTE
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script MUSIC_HIT_BG1
        hit_pal 60
        sfx SHELL
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 119: HEART
        weapon_anim_prop HEART
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script HEART_HIT_BG1
        hit_pal 187
        sfx SHELL
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 120: WHEEL
        weapon_anim_prop WHEEL
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script WHEEL_HIT_BG1
        hit_pal 24
        sfx WRENCH
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 121: FLOWER
        weapon_anim_prop FLOWER
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script FLOWER_HIT_BG1
        hit_pal 57
        sfx BLASTER
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 122: MISSILE
        weapon_anim_prop MISSILE
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script MISSILE_HIT_BG1
        hit_pal 162
        sfx AIR_ANCHOR
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 123: NET
        weapon_anim_prop NET
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script NET_HIT_BG1
        hit_pal 120
        sfx BLASTER
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 124: DRILL
        weapon_anim_prop DRILL
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script DRILL_HIT_BG1
        hit_pal 1
        sfx DRILL
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 125: BLACK_BALL
        weapon_anim_prop BLACK_BALL
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script BALL_HIT_BG1
        hit_pal 225
        sfx CAVE_IN
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 126: SKULL_SLASH
        weapon_anim_prop SKULL_SLASH
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script SKULL_HIT_BG1
        hit_pal 231
        sfx PUNCH
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

; 127: WEAPON_ANIM_127
        weapon_anim_prop WEAPON_ANIM_127
        weapon_script MONSTER_ATTACK_SPRITE
        weapon_pal 0
        hit_script THICK_DIAG_HIT_BG1
        hit_pal 0
        init_fn 2
        end_weapon_anim_prop

; ------------------------------------------------------------------------------

.delmac weapon_anim_prop
.delmac weapon_script
.delmac r_script
.delmac l_script
.delmac weapon_pal
.delmac hit_script
.delmac hit_pal
.delmac init_fn
.delmac sfx
.delmac end_weapon_anim_prop

; ------------------------------------------------------------------------------
