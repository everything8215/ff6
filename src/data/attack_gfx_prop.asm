.include "src/btlgfx/attack_anim_script.inc"

.export AttackGfxProp

.include "attack_gfx_prop.mac"

; ------------------------------------------------------------------------------

; d4/d000
.segment "attack_gfx_prop"

AttackGfxProp:

; ------------------------------------------------------------------------------

; 0: THICK_DIAG_HIT_BG1
        attack_gfx_prop THICK_DIAG_HIT_BG1
        is_2bpp
        frames 13
        tile_offset 32
        frame_offset 0
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 1: THIN_DIAG_HIT_BG1
        attack_gfx_prop THIN_DIAG_HIT_BG1
        is_2bpp
        frames 8
        tile_offset 34
        frame_offset 13
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 2: STAB_HIT_1_BG1
        attack_gfx_prop STAB_HIT_1_BG1
        is_2bpp
        frames 5
        tile_offset 36
        frame_offset 21
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 3: STAB_HIT_2_BG1
        attack_gfx_prop STAB_HIT_2_BG1
        is_2bpp
        frames 6
        tile_offset 36
        frame_offset 26
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 4: STAB_HIT_3_BG1
        attack_gfx_prop STAB_HIT_3_BG1
        is_2bpp
        frames 4
        tile_offset 38
        frame_offset 32
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 5: HORZ_HIT_BG1
        attack_gfx_prop HORZ_HIT_BG1
        is_2bpp
        frames 11
        tile_offset 44
        frame_offset 36
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 6: KATANA_HIT_BG1
        attack_gfx_prop KATANA_HIT_BG1
        is_2bpp
        frames 9
        tile_offset 41
        frame_offset 47
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 7: CLAW_HIT_BG1
        attack_gfx_prop CLAW_HIT_BG1
        is_2bpp
        frames 13
        tile_offset 40
        frame_offset 56
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 8: UNARMED_HIT_BG1
        attack_gfx_prop UNARMED_HIT_BG1
        is_2bpp
        frames 15
        tile_offset 43
        frame_offset 69
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 9: ROD_HIT_BG1
        attack_gfx_prop ROD_HIT_BG1
        is_2bpp
        frames 12
        tile_offset 43
        frame_offset 84
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 10: CARDS_HIT_SPRITE
        attack_gfx_prop CARDS_HIT_SPRITE
        is_2bpp
        tile_offset 34
        frame_offset 96
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 11: DARTS_HIT_SPRITE
        attack_gfx_prop DARTS_HIT_SPRITE
        is_2bpp
        tile_offset 34
        frame_offset 97
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 12: SHURIKEN_HIT_SPRITE
        attack_gfx_prop SHURIKEN_HIT_SPRITE
        is_2bpp
        tile_offset 34
        frame_offset 98
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 13: NINJA_STAR_HIT_SPRITE
        attack_gfx_prop NINJA_STAR_HIT_SPRITE
        is_2bpp
        tile_offset 34
        frame_offset 99
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 14: ATTACK_ANIM_SCRIPT_14
        attack_gfx_prop ATTACK_ANIM_SCRIPT_14
        is_2bpp
        tile_offset 34
        frame_offset 100
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 15: BOOMERANG_SPRITE
        attack_gfx_prop BOOMERANG_SPRITE
        is_3bpp
        frames 6
        tile_offset 44
        frame_offset 101
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 16: CARDS_SPRITE
        attack_gfx_prop CARDS_SPRITE
        is_3bpp
        frames 6
        tile_offset 41
        frame_offset 107
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 17: DOOM_DARTS_SPRITE
        attack_gfx_prop DOOM_DARTS_SPRITE
        is_3bpp
        frames 6
        tile_offset 41
        frame_offset 113
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 18: DICE_SPRITE
        attack_gfx_prop DICE_SPRITE
        is_3bpp
        frames 8
        tile_offset 39
        frame_offset 119
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 19: DARTS_SPRITE
        attack_gfx_prop DARTS_SPRITE
        is_3bpp
        frames 6
        tile_offset 61
        frame_offset 127
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 20: TRUMP_SPRITE
        attack_gfx_prop TRUMP_SPRITE
        is_3bpp
        frames 6
        tile_offset 61
        frame_offset 133
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 21: FULL_MOON_SPRITE
        attack_gfx_prop FULL_MOON_SPRITE
        is_3bpp
        frames 4
        tile_offset 61
        frame_offset 139
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 22: CHOCO_BRUSH_SPRITE
        attack_gfx_prop CHOCO_BRUSH_SPRITE
        is_3bpp
        frames 4
        tile_offset 32
        frame_offset 143
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 23: SHORT_BRUSH_SPRITE
        attack_gfx_prop SHORT_BRUSH_SPRITE
        is_3bpp
        frames 4
        tile_offset 32
        frame_offset 147
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 24: DAVINCI_BRUSH_SPRITE
        attack_gfx_prop DAVINCI_BRUSH_SPRITE
        is_3bpp
        frames 4
        tile_offset 36
        frame_offset 151
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 25: FLAIL_SPRITE
        attack_gfx_prop FLAIL_SPRITE
        is_3bpp
        frames 4
        tile_offset 37
        frame_offset 155
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 26: HAWK_EYE_SPRITE
        attack_gfx_prop HAWK_EYE_SPRITE
        is_3bpp
        frames 4
        tile_offset 32
        frame_offset 159
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 27: ATTACK_ANIM_SCRIPT_27
        attack_gfx_prop ATTACK_ANIM_SCRIPT_27
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 163
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 28: SHORT_KATANA_SPRITE
        attack_gfx_prop SHORT_KATANA_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 167
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 29: LONG_KATANA_SPRITE
        attack_gfx_prop LONG_KATANA_SPRITE
        is_3bpp
        frames 4
        tile_offset 50
        frame_offset 171
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 30: MYSTIC_SWORD_SPRITE
        attack_gfx_prop MYSTIC_SWORD_SPRITE
        is_3bpp
        frames 4
        tile_offset 37
        frame_offset 175
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 31: SOUL_SABRE_SPRITE
        attack_gfx_prop SOUL_SABRE_SPRITE
        is_3bpp
        frames 4
        tile_offset 37
        frame_offset 179
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 32: BONE_CLUB_SPRITE
        attack_gfx_prop BONE_CLUB_SPRITE
        is_3bpp
        frames 4
        tile_offset 32
        frame_offset 183
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 33: NINJA_SWORD_ALT_SPRITE
        attack_gfx_prop NINJA_SWORD_ALT_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 187
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 34: NINJA_SWORD_SPRITE
        attack_gfx_prop NINJA_SWORD_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 191
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 35: MAIN_GAUCHE_SPRITE
        attack_gfx_prop MAIN_GAUCHE_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 195
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 36: UNARMED_SPRITE
        attack_gfx_prop UNARMED_SPRITE
        is_3bpp
        tile_offset 50
        frame_offset 199
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 37: ATTACK_ANIM_SCRIPT_37
        attack_gfx_prop ATTACK_ANIM_SCRIPT_37
        is_3bpp
        frames 3
        tile_offset 50
        frame_offset 200
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 38: AIR_LANCET_SPRITE
        attack_gfx_prop AIR_LANCET_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 203
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 39: KNIFE_SPRITE
        attack_gfx_prop KNIFE_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 207
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 40: ROD_SPRITE
        attack_gfx_prop ROD_SPRITE
        is_3bpp
        frames 4
        tile_offset 35
        frame_offset 211
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 41: SHORT_SWORD_SPRITE
        attack_gfx_prop SHORT_SWORD_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 215
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 42: THUNDERBLADE_SPRITE
        attack_gfx_prop THUNDERBLADE_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 219
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 43: RUNE_BLADE_SPRITE
        attack_gfx_prop RUNE_BLADE_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 223
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 44: FLAME_SABRE_SPRITE
        attack_gfx_prop FLAME_SABRE_SPRITE
        is_3bpp
        frames 4
        tile_offset 33
        frame_offset 227
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 45: SPEAR_SPRITE
        attack_gfx_prop SPEAR_SPRITE
        is_3bpp
        frames 2
        tile_offset 40
        frame_offset 231
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 46: TRIDENT_SPRITE
        attack_gfx_prop TRIDENT_SPRITE
        is_3bpp
        frames 2
        tile_offset 40
        frame_offset 233
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 47: SHURIKEN_SPRITE
        attack_gfx_prop SHURIKEN_SPRITE
        is_3bpp
        frames 5
        tile_offset 41
        frame_offset 235
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 48: NINJA_STAR_SPRITE
        attack_gfx_prop NINJA_STAR_SPRITE
        is_3bpp
        frames 5
        tile_offset 61
        frame_offset 240
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 49: CLAW_ALT_SPRITE
        attack_gfx_prop CLAW_ALT_SPRITE
        is_3bpp
        frames 4
        tile_offset 41
        frame_offset 245
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 50: CLAW_LEFT_SPRITE
        attack_gfx_prop CLAW_LEFT_SPRITE
        is_3bpp
        frames 4
        tile_offset 40
        frame_offset 249
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 51: CLAW_RIGHT_SPRITE
        attack_gfx_prop CLAW_RIGHT_SPRITE
        is_3bpp
        frames 4
        tile_offset 40
        frame_offset 253
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 52: FULL_MOON_HIT_SPRITE
        attack_gfx_prop FULL_MOON_HIT_SPRITE
        is_2bpp
        tile_offset 34
        frame_offset 257
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 53: BOOMERANG_HIT_SPRITE
        attack_gfx_prop BOOMERANG_HIT_SPRITE
        is_2bpp
        tile_offset 34
        frame_offset 258
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 54: ATMA_WEAPON_1_SPRITE
        attack_gfx_prop ATMA_WEAPON_1_SPRITE
        is_3bpp
        frames 4
        tile_offset 52
        frame_offset 259
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 55: ATMA_WEAPON_2_SPRITE
        attack_gfx_prop ATMA_WEAPON_2_SPRITE
        is_3bpp
        frames 4
        tile_offset 51
        frame_offset 263
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 56: ATMA_WEAPON_3_SPRITE
        attack_gfx_prop ATMA_WEAPON_3_SPRITE
        is_3bpp
        frames 7
        tile_offset 43
        frame_offset 267
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 57: GIL_TOSS_SPRITE
        attack_gfx_prop GIL_TOSS_SPRITE
        is_3bpp
        tile_offset 33
        frame_offset 274
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 58: GIL_TOSS_EXTRA
        attack_gfx_prop GIL_TOSS_EXTRA
        is_3bpp
        tile_offset 32
        frame_offset 275
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 59: CHAR_GFX_BG1
        attack_gfx_prop CHAR_GFX_BG1
        is_2bpp
        frames 4
        tile_offset 32
        frame_offset 276
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 60: DOOM_BG1
        attack_gfx_prop DOOM_BG1
        is_2bpp
        frames 4
        tile_offset 32
        frame_offset 280
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 61: TRIPLE_HORZ_HIT_BG1
        attack_gfx_prop TRIPLE_HORZ_HIT_BG1
        is_2bpp
        frames 7
        tile_offset 45
        frame_offset 284
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 62: THIN_HORZ_HIT_BG1
        attack_gfx_prop THIN_HORZ_HIT_BG1
        is_2bpp
        frames 7
        tile_offset 45
        frame_offset 291
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 63: JUMP_HAWK_EYE_SPRITE
        attack_gfx_prop JUMP_HAWK_EYE_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 298
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 64: UNARMED_BLOCK_SPRITE
        attack_gfx_prop UNARMED_BLOCK_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 299
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 65: MONSTER_ATTACK_SPRITE
        attack_gfx_prop MONSTER_ATTACK_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 300
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 66: ATTACK_ANIM_SCRIPT_66
        attack_gfx_prop ATTACK_ANIM_SCRIPT_66
        is_3bpp
        tile_offset 1
        frame_offset 301
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 67: DOG_BLOCK_SPRITE
        attack_gfx_prop DOG_BLOCK_SPRITE
        is_3bpp
        tile_offset 228
        frame_offset 302
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 68: GOLEM_BLOCK_SPRITE
        attack_gfx_prop GOLEM_BLOCK_SPRITE
        is_3bpp
        tile_offset 4
        frame_offset 303
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 69: KNIFE_BLOCK_SPRITE
        attack_gfx_prop KNIFE_BLOCK_SPRITE
        is_3bpp
        tile_offset 4
        frame_offset 304
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 70: SWORD_BLOCK_SPRITE
        attack_gfx_prop SWORD_BLOCK_SPRITE
        is_3bpp
        tile_offset 4
        frame_offset 305
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 71: CAPE_BLOCK_SPRITE
        attack_gfx_prop CAPE_BLOCK_SPRITE
        is_3bpp
        frames 2
        tile_offset 4
        frame_offset 306
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 72: SHIELD_BLOCK_SPRITE
        attack_gfx_prop SHIELD_BLOCK_SPRITE
        is_3bpp
        tile_offset 1
        frame_offset 308
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 73: BIO_BLASTER_SPRITE
        attack_gfx_prop BIO_BLASTER_SPRITE
        is_3bpp
        tile_offset 48
        frame_offset 309
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 74: BIO_BLASTER_BG3
        attack_gfx_prop BIO_BLASTER_BG3
        is_2bpp
        tile_offset 59
        frame_offset 310
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 75: AUTOCROSSBOW_BG1
        attack_gfx_prop AUTOCROSSBOW_BG1
        is_3bpp
        frames 2
        tile_offset 45
        frame_offset 311
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 76: AUTOCROSSBOW_SPRITE
        attack_gfx_prop AUTOCROSSBOW_SPRITE
        is_3bpp
        frames 4
        tile_offset 45
        frame_offset 313
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 77: NOISEBLASTER_SPRITE
        attack_gfx_prop NOISEBLASTER_SPRITE
        is_3bpp
        tile_offset 62
        frame_offset 317
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 78: NOISEBLASTER_EXTRA
        attack_gfx_prop NOISEBLASTER_EXTRA
        is_3bpp
        tile_offset 62
        frame_offset 318
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 79: DRILL_SPRITE
        attack_gfx_prop DRILL_SPRITE
        is_3bpp
        tile_offset 47
        frame_offset 319
        frame_size {4, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 80: CHAIN_SAW_SPRITE
        attack_gfx_prop CHAIN_SAW_SPRITE
        is_3bpp
        frames 4
        tile_offset 45
        frame_offset 320
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 81: CHAIN_SAW_ALT_SPRITE
        attack_gfx_prop CHAIN_SAW_ALT_SPRITE
        is_3bpp
        tile_offset 45
        frame_offset 324
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 82: FLASH_TOOL_SPRITE
        attack_gfx_prop FLASH_TOOL_SPRITE
        is_3bpp
        tile_offset 48
        frame_offset 325
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 83: DEBILITATOR_SPRITE
        attack_gfx_prop DEBILITATOR_SPRITE
        is_3bpp
        frames 6
        tile_offset 48
        frame_offset 326
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 84: DEBILITATOR_BG1
        attack_gfx_prop DEBILITATOR_BG1
        is_3bpp
        tile_offset 48
        frame_offset 332
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 85: DEBILITATOR_BG3
        attack_gfx_prop DEBILITATOR_BG3
        is_2bpp
        tile_offset 54
        frame_offset 333
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 86: DEBILITATOR_EXTRA
        attack_gfx_prop DEBILITATOR_EXTRA
        is_3bpp
        tile_offset 48
        frame_offset 334
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 87: AIR_ANCHOR_SPRITE
        attack_gfx_prop AIR_ANCHOR_SPRITE
        is_3bpp
        frames 2
        tile_offset 46
        frame_offset 335
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 88: AIR_ANCHOR_EXTRA
        attack_gfx_prop AIR_ANCHOR_EXTRA
        is_3bpp
        tile_offset 46
        frame_offset 337
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 89: STUNNER_BG1
        attack_gfx_prop STUNNER_BG1
        is_2bpp
        tile_offset 32
        frame_offset 338
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 90: VALIANTKNIFE_SPRITE
        attack_gfx_prop VALIANTKNIFE_SPRITE
        is_3bpp
        frames 4
        tile_offset 135
        frame_offset 339
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 91: FALCHION_SPRITE
        attack_gfx_prop FALCHION_SPRITE
        is_3bpp
        frames 4
        tile_offset 135
        frame_offset 343
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 92: ILLUMINA_SPRITE
        attack_gfx_prop ILLUMINA_SPRITE
        is_3bpp
        frames 4
        tile_offset 133
        frame_offset 347
        frame_size {3, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 93: AURA_LANCE_SPRITE
        attack_gfx_prop AURA_LANCE_SPRITE
        is_3bpp
        frames 2
        tile_offset 40
        frame_offset 351
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 94: CLAW_PUNCH_SPRITE
        attack_gfx_prop CLAW_PUNCH_SPRITE
        is_3bpp
        tile_offset 44
        frame_offset 353
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 95: PUNISHER_SPRITE
        attack_gfx_prop PUNISHER_SPRITE
        is_3bpp
        frames 4
        tile_offset 35
        frame_offset 354
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 96: IMP_HALBERD_SPRITE
        attack_gfx_prop IMP_HALBERD_SPRITE
        is_3bpp
        frames 2
        tile_offset 40
        frame_offset 358
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 97: SCIMITAR_SPRITE
        attack_gfx_prop SCIMITAR_SPRITE
        is_3bpp
        frames 4
        tile_offset 132
        frame_offset 360
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 98: ATTACK_ANIM_SCRIPT_98
        attack_gfx_prop ATTACK_ANIM_SCRIPT_98
        is_3bpp
        tile_offset 32
        frame_offset 364
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 99: JUMP_UNUSED_SPRITE
        attack_gfx_prop JUMP_UNUSED_SPRITE
        is_3bpp
        tile_offset 1
        frame_offset 365
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 100: THROW_HAWK_EYE_SPRITE
        attack_gfx_prop THROW_HAWK_EYE_SPRITE
        is_3bpp
        frames 5
        tile_offset 32
        frame_offset 366
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 101: PUMMEL_SPRITE
        attack_gfx_prop PUMMEL_SPRITE
        is_3bpp
        frames 3
        tile_offset 50
        frame_offset 371
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 102: AURABOLT_BG1
        attack_gfx_prop AURABOLT_BG1
        is_3bpp
        frames 14
        tile_offset 55
        frame_offset 374
        frame_size {16, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 103: AURABOLT_BG3
        attack_gfx_prop AURABOLT_BG3
        is_2bpp
        tile_offset 57
        frame_offset 388
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 104: AURABOLT_SPRITE
        attack_gfx_prop AURABOLT_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 389
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 105: SUPLEX_SPRITE
        attack_gfx_prop SUPLEX_SPRITE
        is_3bpp
        tile_offset 55
        frame_offset 390
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 106: FIRE_DANCE_SPRITE
        attack_gfx_prop FIRE_DANCE_SPRITE
        is_3bpp
        frames 2
        tile_offset 53
        frame_offset 391
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 107: FIRE_DANCE_BG1
        attack_gfx_prop FIRE_DANCE_BG1
        is_3bpp
        tile_offset 32
        frame_offset 393
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 108: AIR_BLADE_SPRITE
        attack_gfx_prop AIR_BLADE_SPRITE
        is_2bpp
        frames 24
        tile_offset 46
        frame_offset 394
        frame_size {4, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 109: AIR_BLADE_BG1
        attack_gfx_prop AIR_BLADE_BG1
        is_3bpp
        tile_offset 88
        frame_offset 418
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 110: MANTRA_BG1
        attack_gfx_prop MANTRA_BG1
        is_3bpp
        tile_offset 57
        frame_offset 419
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 111: BUM_RUSH_SPRITE
        attack_gfx_prop BUM_RUSH_SPRITE
        is_3bpp
        tile_offset 55
        frame_offset 420
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 112: SPIRALER_BG1
        attack_gfx_prop SPIRALER_BG1
        is_3bpp
        tile_offset 57
        frame_offset 421
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 113: ARISE_SPRITE
        attack_gfx_prop ARISE_SPRITE
        is_3bpp
        frames 16
        tile_offset 12
        frame_offset 422
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 114: SKETCH_CMD_SPRITE
        attack_gfx_prop SKETCH_CMD_SPRITE
        is_3bpp
        frames 8
        tile_offset 35
        frame_offset 438
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 115: BLACK_MAGIC_CMD_BG1
        attack_gfx_prop BLACK_MAGIC_CMD_BG1
        is_3bpp
        tile_offset 60
        frame_offset 446
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 116: WHITE_MAGIC_CMD_BG1
        attack_gfx_prop WHITE_MAGIC_CMD_BG1
        is_3bpp
        tile_offset 59
        frame_offset 447
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 117: WHITE_MAGIC_CMD_SPRITE
        attack_gfx_prop WHITE_MAGIC_CMD_SPRITE
        is_3bpp
        frames 3
        tile_offset 112
        frame_offset 448
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 118: SUMMON_CMD_SPRITE
        attack_gfx_prop SUMMON_CMD_SPRITE
        is_3bpp
        tile_offset 54
        frame_offset 451
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 119: SUMMON_CMD_BG1
        attack_gfx_prop SUMMON_CMD_BG1
        is_3bpp
        tile_offset 32
        frame_offset 452
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 120: LORE_CMD_BG1
        attack_gfx_prop LORE_CMD_BG1
        is_3bpp
        tile_offset 60
        frame_offset 453
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 121: MORPH_CMD_BG1
        attack_gfx_prop MORPH_CMD_BG1
        is_3bpp
        tile_offset 59
        frame_offset 454
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 122: REVERT_CMD_SPRITE
        attack_gfx_prop REVERT_CMD_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 455
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 123: STEAL_CMD_SPRITE
        attack_gfx_prop STEAL_CMD_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 456
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 124: BUSHIDO_CMD_BG1
        attack_gfx_prop BUSHIDO_CMD_BG1
        is_3bpp
        tile_offset 58
        frame_offset 457
        frame_size {3, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 125: BLITZ_CMD_SPRITE
        attack_gfx_prop BLITZ_CMD_SPRITE
        is_3bpp
        frames 8
        tile_offset 109
        frame_offset 458
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 126: RUNIC_CMD_SPRITE
        attack_gfx_prop RUNIC_CMD_SPRITE
        is_3bpp
        frames 6
        tile_offset 106
        frame_offset 466
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 127: DANCE_CMD_SPRITE
        attack_gfx_prop DANCE_CMD_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 472
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 128: SHOCK_CMD_SPRITE
        attack_gfx_prop SHOCK_CMD_SPRITE
        is_3bpp
        frames 11
        tile_offset 115
        frame_offset 473
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 129: SHOCK_CMD_BG1
        attack_gfx_prop SHOCK_CMD_BG1
        is_3bpp
        tile_offset 112
        frame_offset 484
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 130: JUMP_UNARMED_SPRITE
        attack_gfx_prop JUMP_UNARMED_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 485
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 131: JUMP_MONSTER_UP_BG1
        attack_gfx_prop JUMP_MONSTER_UP_BG1
        is_3bpp
        tile_offset 32
        frame_offset 486
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 132: JUMP_MONSTER_DOWN_BG1
        attack_gfx_prop JUMP_MONSTER_DOWN_BG1
        is_3bpp
        tile_offset 32
        frame_offset 487
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 133: JUMP_CHAR_MISS_SPRITE
        attack_gfx_prop JUMP_CHAR_MISS_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 488
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 134: JUMP_MONSTER_MISS_SPRITE
        attack_gfx_prop JUMP_MONSTER_MISS_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 489
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 135: JUMP_THICK_KNIFE_SPRITE
        attack_gfx_prop JUMP_THICK_KNIFE_SPRITE
        is_3bpp
        frames 5
        tile_offset 128
        frame_offset 490
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 136: JUMP_THIN_KNIFE_SPRITE
        attack_gfx_prop JUMP_THIN_KNIFE_SPRITE
        is_3bpp
        frames 5
        tile_offset 128
        frame_offset 495
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 137: JUMP_SWORD_SPRITE
        attack_gfx_prop JUMP_SWORD_SPRITE
        is_3bpp
        frames 2
        tile_offset 128
        frame_offset 500
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 138: JUMP_KATANA_SPRITE
        attack_gfx_prop JUMP_KATANA_SPRITE
        is_3bpp
        frames 2
        tile_offset 128
        frame_offset 502
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 139: JUMP_ROD_SPRITE
        attack_gfx_prop JUMP_ROD_SPRITE
        is_3bpp
        frames 2
        tile_offset 128
        frame_offset 504
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 140: JUMP_SPEAR_SPRITE
        attack_gfx_prop JUMP_SPEAR_SPRITE
        is_3bpp
        frames 2
        tile_offset 129
        frame_offset 506
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 141: THROW_THICK_KNIFE_SPRITE
        attack_gfx_prop THROW_THICK_KNIFE_SPRITE
        is_3bpp
        frames 5
        tile_offset 128
        frame_offset 508
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 142: THROW_THIN_KNIFE_SPRITE
        attack_gfx_prop THROW_THIN_KNIFE_SPRITE
        is_3bpp
        frames 5
        tile_offset 128
        frame_offset 513
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 143: THROW_SWORD_SPRITE
        attack_gfx_prop THROW_SWORD_SPRITE
        is_3bpp
        frames 2
        tile_offset 128
        frame_offset 518
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 144: THROW_KATANA_SPRITE
        attack_gfx_prop THROW_KATANA_SPRITE
        is_3bpp
        frames 2
        tile_offset 128
        frame_offset 520
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 145: THROW_ROD_SPRITE
        attack_gfx_prop THROW_ROD_SPRITE
        is_3bpp
        frames 2
        tile_offset 128
        frame_offset 522
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 146: THROW_SPEAR_SPRITE
        attack_gfx_prop THROW_SPEAR_SPRITE
        is_3bpp
        frames 2
        tile_offset 129
        frame_offset 524
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 147: ATTACK_ANIM_SCRIPT_147
        attack_gfx_prop ATTACK_ANIM_SCRIPT_147
        is_3bpp
        frames 2
        tile_offset 59
        frame_offset 526
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 148: ATTACK_ANIM_SCRIPT_148
        attack_gfx_prop ATTACK_ANIM_SCRIPT_148
        is_2bpp
        frames 5
        tile_offset 9
        frame_offset 528
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 149: ATTACK_ANIM_SCRIPT_149
        attack_gfx_prop ATTACK_ANIM_SCRIPT_149
        is_2bpp
        frames 6
        tile_offset 9
        frame_offset 533
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 150: ATTACK_ANIM_SCRIPT_150
        attack_gfx_prop ATTACK_ANIM_SCRIPT_150
        is_2bpp
        tile_offset 59
        frame_offset 539
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 151: ATTACK_ANIM_SCRIPT_151
        attack_gfx_prop ATTACK_ANIM_SCRIPT_151
        is_2bpp
        frames 5
        tile_offset 8
        frame_offset 540
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 152: ATTACK_ANIM_SCRIPT_152
        attack_gfx_prop ATTACK_ANIM_SCRIPT_152
        is_2bpp
        frames 15
        tile_offset 13
        frame_offset 545
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 153: FLARE_BG1
        attack_gfx_prop FLARE_BG1
        is_3bpp
        frames 14
        tile_offset 172
        frame_offset 560
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 154: RAISE_SPRITE
        attack_gfx_prop RAISE_SPRITE
        is_3bpp
        frames 16
        tile_offset 12
        frame_offset 574
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 155: RERAISE_SPRITE
        attack_gfx_prop RERAISE_SPRITE
        is_3bpp
        frames 13
        tile_offset 12
        frame_offset 590
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 156: POISONA_SPRITE
        attack_gfx_prop POISONA_SPRITE
        is_3bpp
        frames 8
        tile_offset 2
        frame_offset 603
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 157: REMEDY_SPRITE
        attack_gfx_prop REMEDY_SPRITE
        is_3bpp
        frames 23
        tile_offset 106
        frame_offset 611
        frame_size {4, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 158: REMEDY_BG1
        attack_gfx_prop REMEDY_BG1
        is_3bpp
        tile_offset 86
        frame_offset 634
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 159: REGEN_SPRITE
        attack_gfx_prop REGEN_SPRITE
        is_2bpp
        frames 9
        tile_offset 9
        frame_offset 635
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 160: ATTACK_ANIM_SCRIPT_160
        attack_gfx_prop ATTACK_ANIM_SCRIPT_160
        is_2bpp
        frames 8
        tile_offset 9
        frame_offset 644
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 161: ATTACK_ANIM_SCRIPT_161
        attack_gfx_prop ATTACK_ANIM_SCRIPT_161
        is_3bpp
        tile_offset 86
        frame_offset 652
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 162: SCAN_SPRITE
        attack_gfx_prop SCAN_SPRITE
        is_2bpp
        frames 8
        tile_offset 27
        frame_offset 653
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 163: SCAN_BG1
        attack_gfx_prop SCAN_BG1
        is_3bpp
        tile_offset 86
        frame_offset 661
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 164: SLOW_SPRITE
        attack_gfx_prop SLOW_SPRITE
        is_3bpp
        frames 5
        tile_offset 206
        frame_offset 662
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 165: RASP_BG3
        attack_gfx_prop RASP_BG3
        is_2bpp
        tile_offset 59
        frame_offset 667
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 166: RASP_SPRITE
        attack_gfx_prop RASP_SPRITE
        is_2bpp
        frames 5
        tile_offset 8
        frame_offset 668
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 167: STEP_MINE_BG1
        attack_gfx_prop STEP_MINE_BG1
        is_3bpp
        frames 4
        tile_offset 192
        frame_offset 673
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 168: SLEEP_SPRITE
        attack_gfx_prop SLEEP_SPRITE
        is_3bpp
        frames 8
        tile_offset 160
        frame_offset 677
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 169: SAFE_SPRITE
        attack_gfx_prop SAFE_SPRITE
        is_3bpp
        frames 6
        tile_offset 231
        frame_offset 685
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 170: CONFUSE_SPRITE
        attack_gfx_prop CONFUSE_SPRITE
        is_3bpp
        frames 4
        tile_offset 12
        frame_offset 691
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 171: CONFUSE_BG1
        attack_gfx_prop CONFUSE_BG1
        is_3bpp
        frames 4
        tile_offset 12
        frame_offset 695
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 172: HASTE_SPRITE
        attack_gfx_prop HASTE_SPRITE
        is_3bpp
        frames 19
        tile_offset 121
        frame_offset 699
        frame_size {9, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 173: HASTE_BG3
        attack_gfx_prop HASTE_BG3
        is_2bpp
        tile_offset 60
        frame_offset 718
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 174: STOP_SPRITE
        attack_gfx_prop STOP_SPRITE
        is_3bpp
        frames 20
        tile_offset 121
        frame_offset 719
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 175: CRUSADER_BG3
        attack_gfx_prop CRUSADER_BG3
        is_2bpp
        frames 9
        tile_offset 13
        frame_offset 739
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 176: BERSERK_SPRITE
        attack_gfx_prop BERSERK_SPRITE
        is_2bpp
        frames 12
        tile_offset 21
        frame_offset 748
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 177: FLOAT_SPRITE
        attack_gfx_prop FLOAT_SPRITE
        is_3bpp
        frames 9
        tile_offset 12
        frame_offset 760
        frame_size {4, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 178: IMP_SPRITE
        attack_gfx_prop IMP_SPRITE
        is_3bpp
        frames 6
        tile_offset 245
        frame_offset 769
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 179: IMP_BG1
        attack_gfx_prop IMP_BG1
        is_2bpp
        tile_offset 59
        frame_offset 775
        frame_size {7, 7}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 180: REFLECT_SPRITE
        attack_gfx_prop REFLECT_SPRITE
        is_2bpp
        frames 4
        tile_offset 0
        frame_offset 776
        frame_size {5, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 181: SHELL_BG1
        attack_gfx_prop SHELL_BG1
        is_3bpp
        tile_offset 81
        frame_offset 780
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 182: TEKBARRIER_SPRITE
        attack_gfx_prop TEKBARRIER_SPRITE
        is_2bpp
        frames 11
        tile_offset 1
        frame_offset 781
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 183: TEKBARRIER_BG1
        attack_gfx_prop TEKBARRIER_BG1
        is_3bpp
        tile_offset 81
        frame_offset 792
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 184: TEKBARRIER_BG3
        attack_gfx_prop TEKBARRIER_BG3
        is_2bpp
        tile_offset 59
        frame_offset 793
        frame_size {7, 7}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 185: VANISH_BG1
        attack_gfx_prop VANISH_BG1
        is_3bpp
        frames 15
        tile_offset 272
        frame_offset 794
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 186: DRAIN_SPRITE
        attack_gfx_prop DRAIN_SPRITE
        is_2bpp
        frames 8
        tile_offset 9
        frame_offset 809
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 187: DRAIN_BG1
        attack_gfx_prop DRAIN_BG1
        is_3bpp
        tile_offset 86
        frame_offset 817
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 188: WARP_BG1
        attack_gfx_prop WARP_BG1
        is_3bpp
        tile_offset 32
        frame_offset 818
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 189: QUICK_SPRITE
        attack_gfx_prop QUICK_SPRITE
        is_3bpp
        frames 13
        tile_offset 16
        frame_offset 819
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 190: DISPEL_SPRITE
        attack_gfx_prop DISPEL_SPRITE
        is_3bpp
        frames 4
        tile_offset 4
        frame_offset 832
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 191: DISPEL_BG1
        attack_gfx_prop DISPEL_BG1
        is_3bpp
        frames 5
        tile_offset 4
        frame_offset 836
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 192: REGEN_BG3
        attack_gfx_prop REGEN_BG3
        is_2bpp
        tile_offset 59
        frame_offset 841
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 193: FIRE_SPRITE
        attack_gfx_prop FIRE_SPRITE
        is_3bpp
        frames 5
        tile_offset 28
        frame_offset 842
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 194: FIRA_SPRITE
        attack_gfx_prop FIRA_SPRITE
        is_3bpp
        frames 5
        tile_offset 141
        frame_offset 847
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 195: FIRA_BG1
        attack_gfx_prop FIRA_BG1
        is_3bpp
        frames 5
        tile_offset 142
        frame_offset 852
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 196: FIRAGA_SPRITE
        attack_gfx_prop FIRAGA_SPRITE
        is_3bpp
        frames 4
        tile_offset 231
        frame_offset 857
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 197: FIRAGA_BG1
        attack_gfx_prop FIRAGA_BG1
        is_3bpp
        frames 7
        tile_offset 136
        frame_offset 861
        frame_size {6, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 198: THUNDER_SPRITE
        attack_gfx_prop THUNDER_SPRITE
        is_2bpp
        frames 16
        tile_offset 20
        frame_offset 868
        frame_size {10, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 199: THUNDARA_SPRITE
        attack_gfx_prop THUNDARA_SPRITE
        is_3bpp
        frames 27
        tile_offset 147
        frame_offset 884
        frame_size {6, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 200: THUNDARA_BG1
        attack_gfx_prop THUNDARA_BG1
        is_3bpp
        frames 5
        tile_offset 147
        frame_offset 916
        frame_size {6, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 201: BIO_SPRITE
        attack_gfx_prop BIO_SPRITE
        is_3bpp
        frames 7
        tile_offset 156
        frame_offset 921
        frame_size {3, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 202: BIO_BG1
        attack_gfx_prop BIO_BG1
        is_3bpp
        tile_offset 154
        frame_offset 928
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 203: GRANDTRAIN_BG1
        attack_gfx_prop GRANDTRAIN_BG1
        is_3bpp
        tile_offset 64
        frame_offset 929
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 204: POISON_SPRITE
        attack_gfx_prop POISON_SPRITE
        is_3bpp
        frames 27
        tile_offset 8
        frame_offset 930
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 205: DOOM_SPRITE
        attack_gfx_prop DOOM_SPRITE
        is_3bpp
        tile_offset 0
        frame_offset 957
        frame_size {2, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 206: METEOR_SPRITE
        attack_gfx_prop METEOR_SPRITE
        is_3bpp
        frames 9
        tile_offset 74
        frame_offset 958
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 207: METEOR_BG1
        attack_gfx_prop METEOR_BG1
        is_3bpp
        tile_offset 64
        frame_offset 967
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 208: METEOR_BG3
        attack_gfx_prop METEOR_BG3
        is_2bpp
        tile_offset 53
        frame_offset 968
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 209: QUAKE_BG1
        attack_gfx_prop QUAKE_BG1
        is_3bpp
        tile_offset 27
        frame_offset 969
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 210: DEZONE_BG3
        attack_gfx_prop DEZONE_BG3
        is_2bpp
        tile_offset 53
        frame_offset 970
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 211: DEMI_SPRITE
        attack_gfx_prop DEMI_SPRITE
        is_3bpp
        frames 8
        tile_offset 231
        frame_offset 971
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 212: GRANDTRAIN_BG3
        attack_gfx_prop GRANDTRAIN_BG3
        is_2bpp
        tile_offset 53
        frame_offset 979
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 213: SAFE_BG1
        attack_gfx_prop SAFE_BG1
        is_3bpp
        tile_offset 79
        frame_offset 980
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 214: SLOW_2_BG1
        attack_gfx_prop SLOW_2_BG1
        is_3bpp
        tile_offset 32
        frame_offset 981
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 215: FLARE_SPRITE
        attack_gfx_prop FLARE_SPRITE
        is_3bpp
        frames 15
        tile_offset 19
        frame_offset 982
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 216: DEZONE_SPRITE
        attack_gfx_prop DEZONE_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 997
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 217: MELTDOWN_BG3
        attack_gfx_prop MELTDOWN_BG3
        is_2bpp
        tile_offset 59
        frame_offset 998
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 218: MELTDOWN_SPRITE
        attack_gfx_prop MELTDOWN_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 999
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 219: SKETCH_CMD_BG1
        attack_gfx_prop SKETCH_CMD_BG1
        is_3bpp
        frames 2
        tile_offset 32
        frame_offset 1000
        frame_size {8, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 220: BLIZZARD_SPRITE
        attack_gfx_prop BLIZZARD_SPRITE
        is_3bpp
        frames 20
        tile_offset 169
        frame_offset 1002
        frame_size {6, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 221: BLIZZARD_BG1
        attack_gfx_prop BLIZZARD_BG1
        is_3bpp
        frames 6
        tile_offset 164
        frame_offset 1022
        frame_size {6, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 222: BLIZZARA_SPRITE
        attack_gfx_prop BLIZZARA_SPRITE
        is_3bpp
        frames 24
        tile_offset 175
        frame_offset 1028
        frame_size {7, 7}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 223: BLIZZARA_BG1
        attack_gfx_prop BLIZZARA_BG1
        is_3bpp
        tile_offset 177
        frame_offset 1052
        frame_size {7, 7}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 224: BLIZZAGA_SPRITE
        attack_gfx_prop BLIZZAGA_SPRITE
        is_3bpp
        frames 23
        tile_offset 101
        frame_offset 1053
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 225: BLIZZAGA_BG1
        attack_gfx_prop BLIZZAGA_BG1
        is_3bpp
        tile_offset 181
        frame_offset 1076
        frame_size {10, 11}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 226: BREAK_SPRITE
        attack_gfx_prop BREAK_SPRITE
        is_3bpp
        frames 4
        tile_offset 160
        frame_offset 1077
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 227: BREAK_BG1
        attack_gfx_prop BREAK_BG1
        is_3bpp
        tile_offset 177
        frame_offset 1081
        frame_size {7, 7}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 228: HOLY_SPRITE
        attack_gfx_prop HOLY_SPRITE
        is_3bpp
        frames 9
        tile_offset 231
        frame_offset 1082
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 229: HOLY_BG1
        attack_gfx_prop HOLY_BG1
        is_3bpp
        frames 14
        tile_offset 172
        frame_offset 1091
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 230: HOLY_BG3
        attack_gfx_prop HOLY_BG3
        is_2bpp
        tile_offset 0
        frame_offset 1105
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 231: ULTIMA_BG1
        attack_gfx_prop ULTIMA_BG1
        is_3bpp
        tile_offset 86
        frame_offset 1106
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 232: ULTIMA_BG3
        attack_gfx_prop ULTIMA_BG3
        is_2bpp
        tile_offset 25
        frame_offset 1107
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 233: TORNADO_BG1
        attack_gfx_prop TORNADO_BG1
        is_3bpp
        tile_offset 57
        frame_offset 1108
        frame_size {12, 12}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 234: THUNDAGA_SPRITE
        attack_gfx_prop THUNDAGA_SPRITE
        is_3bpp
        frames 11
        tile_offset 147
        frame_offset 1109
        frame_size {7, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 235: THUNDAGA_BG1
        attack_gfx_prop THUNDAGA_BG1
        is_3bpp
        frames 14
        tile_offset 172
        frame_offset 1120
        frame_size {8, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 236: CURE_SPRITE
        attack_gfx_prop CURE_SPRITE
        is_3bpp
        frames 26
        tile_offset 160
        frame_offset 1134
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 237: SLEEP_BG1
        attack_gfx_prop SLEEP_BG1
        is_3bpp
        tile_offset 160
        frame_offset 1160
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 238: IFRIT_SPRITE
        attack_gfx_prop IFRIT_SPRITE
        is_3bpp
        frames 6
        tile_offset 0
        frame_offset 1161
        frame_size {3, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 239: IFRIT_BG1
        attack_gfx_prop IFRIT_BG1
        is_3bpp
        frames 12
        tile_offset 186
        frame_offset 1167
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 240: IFRIT_BG3
        attack_gfx_prop IFRIT_BG3
        is_2bpp
        frames 9
        tile_offset 64
        frame_offset 1179
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 241: SPIN_EDGE_BG1
        attack_gfx_prop SPIN_EDGE_BG1
        is_3bpp
        frames 5
        tile_offset 133
        frame_offset 1188
        frame_size {3, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 242: MONSTER_FIGHT_BG1
        attack_gfx_prop MONSTER_FIGHT_BG1
        is_3bpp
        tile_offset 192
        frame_offset 1193
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 243: TERRATO_BG1
        attack_gfx_prop TERRATO_BG1
        is_3bpp
        tile_offset 27
        frame_offset 1195
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 244: TERRATO_BG3
        attack_gfx_prop TERRATO_BG3
        is_2bpp
        frames 7
        tile_offset 79
        frame_offset 1196
        frame_size {16, 15}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 245: TERRATO_SPRITE
        attack_gfx_prop TERRATO_SPRITE
        is_3bpp
        tile_offset 0
        frame_offset 1203
        frame_size {6, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 246: BISMARK_BG1
        attack_gfx_prop BISMARK_BG1
        is_3bpp
        frames 15
        tile_offset 192
        frame_offset 1204
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 247: BISMARK_EXTRA
        attack_gfx_prop BISMARK_EXTRA
        is_3bpp
        tile_offset 192
        frame_offset 1219
        frame_size {6, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 248: BISMARK_SPRITE
        attack_gfx_prop BISMARK_SPRITE
        is_3bpp
        tile_offset 192
        frame_offset 1220
        frame_size {6, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 249: WALL_SPRITE
        attack_gfx_prop WALL_SPRITE
        is_3bpp
        frames 8
        tile_offset 82
        frame_offset 1221
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 250: WALL_BG1
        attack_gfx_prop WALL_BG1
        is_3bpp
        tile_offset 69
        frame_offset 1229
        frame_size {4, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 251: RAMUH_BG3
        attack_gfx_prop RAMUH_BG3
        is_2bpp
        frames 6
        tile_offset 68
        frame_offset 1230
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 252: RAMUH_BG1
        attack_gfx_prop RAMUH_BG1
        is_2bpp
        frames 9
        tile_offset 87
        frame_offset 1236
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 253: RAMUH_SPRITE
        attack_gfx_prop RAMUH_SPRITE
        is_2bpp
        tile_offset 64
        frame_offset 1245
        frame_size {3, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 254: SHIVA_BG1
        attack_gfx_prop SHIVA_BG1
        is_3bpp
        frames 5
        tile_offset 85
        frame_offset 1246
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 255: SHIVA_BG3
        attack_gfx_prop SHIVA_BG3
        is_2bpp
        frames 7
        tile_offset 68
        frame_offset 1251
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 256: SHIVA_SPRITE
        attack_gfx_prop SHIVA_SPRITE
        is_3bpp
        tile_offset 206
        frame_offset 1258
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 257: SIREN_SPRITE
        attack_gfx_prop SIREN_SPRITE
        is_2bpp
        frames 4
        tile_offset 91
        frame_offset 1259
        frame_size {7, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 258: SIREN_BG3
        attack_gfx_prop SIREN_BG3
        is_2bpp
        tile_offset 91
        frame_offset 1263
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 259: SIREN_BG1
        attack_gfx_prop SIREN_BG1
        is_2bpp
        tile_offset 91
        frame_offset 1264
        frame_size {2, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 260: ALEXANDR_SPRITE
        attack_gfx_prop ALEXANDR_SPRITE
        is_3bpp
        frames 12
        tile_offset 196
        frame_offset 1265
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 261: ALEXANDR_BG3
        attack_gfx_prop ALEXANDR_BG3
        is_2bpp
        frames 9
        tile_offset 83
        frame_offset 1277
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 262: ALEXANDR_BG1
        attack_gfx_prop ALEXANDR_BG1
        is_3bpp
        tile_offset 0
        frame_offset 1286
        frame_size {6, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 263: ALEXANDR_EXTRA
        attack_gfx_prop ALEXANDR_EXTRA
        is_3bpp
        tile_offset 196
        frame_offset 1287
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 264: CARBUNKL_BG1
        attack_gfx_prop CARBUNKL_BG1
        is_3bpp
        frames 6
        tile_offset 196
        frame_offset 1288
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 265: CARBUNKL_SPRITE
        attack_gfx_prop CARBUNKL_SPRITE
        is_3bpp
        tile_offset 196
        frame_offset 1294
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 266: KIRIN_BG1
        attack_gfx_prop KIRIN_BG1
        is_2bpp
        tile_offset 59
        frame_offset 1295
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 267: KIRIN_SPRITE
        attack_gfx_prop KIRIN_SPRITE
        is_3bpp
        tile_offset 0
        frame_offset 1296
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 268: UNICORN_BG1
        attack_gfx_prop UNICORN_BG1
        is_3bpp
        tile_offset 85
        frame_offset 1297
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 269: UNICORN_BG3
        attack_gfx_prop UNICORN_BG3
        is_2bpp
        frames 9
        tile_offset 13
        frame_offset 1298
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 270: UNICORN_SPRITE
        attack_gfx_prop UNICORN_SPRITE
        is_2bpp
        tile_offset 13
        frame_offset 1307
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 271: PHOENIX_BG3
        attack_gfx_prop PHOENIX_BG3
        is_2bpp
        frames 4
        tile_offset 75
        frame_offset 1308
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 272: PHOENIX_BG1
        attack_gfx_prop PHOENIX_BG1
        is_3bpp
        tile_offset 209
        frame_offset 1312
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 273: PHOENIX_SPRITE
        attack_gfx_prop PHOENIX_SPRITE
        is_2bpp
        tile_offset 75
        frame_offset 1313
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 274: SRAPHIM_SPRITE
        attack_gfx_prop SRAPHIM_SPRITE
        is_2bpp
        frames 14
        tile_offset 9
        frame_offset 1314
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 275: SRAPHIM_BG3
        attack_gfx_prop SRAPHIM_BG3
        is_2bpp
        tile_offset 92
        frame_offset 1328
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 276: SRAPHIM_BG1
        attack_gfx_prop SRAPHIM_BG1
        is_2bpp
        tile_offset 91
        frame_offset 1329
        frame_size {3, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 277: STARLET_BG1
        attack_gfx_prop STARLET_BG1
        is_3bpp
        tile_offset 64
        frame_offset 1330
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 278: STARLET_SPRITE
        attack_gfx_prop STARLET_SPRITE
        is_3bpp
        tile_offset 64
        frame_offset 1331
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 279: BAHAMUT_SPRITE
        attack_gfx_prop BAHAMUT_SPRITE
        is_3bpp
        frames 8
        tile_offset 234
        frame_offset 1332
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 280: BAHAMUT_BG3
        attack_gfx_prop BAHAMUT_BG3
        is_2bpp
        tile_offset 27
        frame_offset 1340
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 281: BAHAMUT_BG1
        attack_gfx_prop BAHAMUT_BG1
        is_3bpp
        tile_offset 207
        frame_offset 1341
        frame_size {6, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 282: MADUIN_BG1
        attack_gfx_prop MADUIN_BG1
        is_3bpp
        tile_offset 69
        frame_offset 1342
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 283: MADUIN_BG3
        attack_gfx_prop MADUIN_BG3
        is_2bpp
        frames 9
        tile_offset 13
        frame_offset 1343
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 284: MADUIN_SPRITE
        attack_gfx_prop MADUIN_SPRITE
        is_3bpp
        tile_offset 69
        frame_offset 1352
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 285: PALIDOR_SPRITE
        attack_gfx_prop PALIDOR_SPRITE
        is_3bpp
        tile_offset 96
        frame_offset 1353
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 286: PALIDOR_BG1
        attack_gfx_prop PALIDOR_BG1
        is_3bpp
        tile_offset 96
        frame_offset 1354
        frame_size {6, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 287: ODIN_BG1
        attack_gfx_prop ODIN_BG1
        is_3bpp
        tile_offset 33
        frame_offset 1355
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 288: ODIN_SPRITE
        attack_gfx_prop ODIN_SPRITE
        is_3bpp
        tile_offset 33
        frame_offset 1356
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 289: FENRIR_BG1
        attack_gfx_prop FENRIR_BG1
        is_3bpp
        tile_offset 91
        frame_offset 1357
        frame_size {3, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 290: FENRIR_SPRITE
        attack_gfx_prop FENRIR_SPRITE
        is_3bpp
        tile_offset 91
        frame_offset 1358
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 291: ATTACK_ANIM_SCRIPT_291
        attack_gfx_prop ATTACK_ANIM_SCRIPT_291
        is_3bpp
        tile_offset 91
        frame_offset 1359
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 292: SUN_BATH_SPRITE
        attack_gfx_prop SUN_BATH_SPRITE
        is_3bpp
        frames 5
        tile_offset 160
        frame_offset 1360
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 293: SUN_BATH_EXTRA
        attack_gfx_prop SUN_BATH_EXTRA
        is_3bpp
        tile_offset 160
        frame_offset 1365
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 294: RAGE_BG1
        attack_gfx_prop RAGE_BG1
        is_2bpp
        frames 3
        tile_offset 92
        frame_offset 1366
        frame_size {11, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 295: RAGE_BG3
        attack_gfx_prop RAGE_BG3
        is_2bpp
        frames 3
        tile_offset 92
        frame_offset 1369
        frame_size {11, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 296: HARVESTER_SPRITE
        attack_gfx_prop HARVESTER_SPRITE
        is_3bpp
        frames 10
        tile_offset 160
        frame_offset 1372
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 297: HARVESTER_BG1
        attack_gfx_prop HARVESTER_BG1
        is_3bpp
        tile_offset 166
        frame_offset 1382
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 298: SAND_STORM_BG1
        attack_gfx_prop SAND_STORM_BG1
        is_3bpp
        tile_offset 88
        frame_offset 1383
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 299: ANTLION_BG1
        attack_gfx_prop ANTLION_BG1
        is_3bpp
        tile_offset 216
        frame_offset 1384
        frame_size {8, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 300: ELF_FIRE_SPRITE
        attack_gfx_prop ELF_FIRE_SPRITE
        is_2bpp
        frames 4
        tile_offset 92
        frame_offset 1385
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 301: HARVESTER_BG3
        attack_gfx_prop HARVESTER_BG3
        is_2bpp
        tile_offset 92
        frame_offset 1389
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 302: WIND_SLASH_SPRITE
        attack_gfx_prop WIND_SLASH_SPRITE
        is_2bpp
        frames 23
        tile_offset 44
        frame_offset 1390
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 303: WIND_SLASH_BG1
        attack_gfx_prop WIND_SLASH_BG1
        is_3bpp
        tile_offset 88
        frame_offset 1413
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 304: SPECTER_BG1
        attack_gfx_prop SPECTER_BG1
        is_2bpp
        frames 2
        tile_offset 92
        frame_offset 1414
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 305: SPECTER_SPRITE
        attack_gfx_prop SPECTER_SPRITE
        is_2bpp
        frames 8
        tile_offset 92
        frame_offset 1416
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 306: LAND_SLIDE_SPRITE
        attack_gfx_prop LAND_SLIDE_SPRITE
        is_3bpp
        frames 4
        tile_offset 24
        frame_offset 1424
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 307: WAVECANNON_BG1
        attack_gfx_prop WAVECANNON_BG1
        is_3bpp
        tile_offset 92
        frame_offset 1428
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 308: SONIC_BOOM_SPRITE
        attack_gfx_prop SONIC_BOOM_SPRITE
        is_2bpp
        frames 24
        tile_offset 46
        frame_offset 1429
        frame_size {4, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 309: EL_NINO_SPRITE
        attack_gfx_prop EL_NINO_SPRITE
        is_3bpp
        frames 6
        tile_offset 192
        frame_offset 1453
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 310: EL_NINO_BG1
        attack_gfx_prop EL_NINO_BG1
        is_3bpp
        tile_offset 192
        frame_offset 1459
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 311: PLASMA_SPRITE
        attack_gfx_prop PLASMA_SPRITE
        is_3bpp
        frames 4
        tile_offset 212
        frame_offset 1460
        frame_size {2, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 312: CAVE_IN_SPRITE
        attack_gfx_prop CAVE_IN_SPRITE
        is_3bpp
        tile_offset 216
        frame_offset 1464
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 313: SNOWBALL_SPRITE
        attack_gfx_prop SNOWBALL_SPRITE
        is_3bpp
        frames 7
        tile_offset 234
        frame_offset 1465
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 314: SURGE_BG1
        attack_gfx_prop SURGE_BG1
        is_3bpp
        tile_offset 168
        frame_offset 1472
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 315: SURGE_BG3
        attack_gfx_prop SURGE_BG3
        is_2bpp
        tile_offset 2
        frame_offset 1473
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 316: SURGE_SPRITE
        attack_gfx_prop SURGE_SPRITE
        is_2bpp
        tile_offset 3
        frame_offset 1474
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 317: COKATRICE_SPRITE
        attack_gfx_prop COKATRICE_SPRITE
        is_3bpp
        tile_offset 219
        frame_offset 1475
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 318: COKATRICE_BG1
        attack_gfx_prop COKATRICE_BG1
        is_2bpp
        frames 4
        tile_offset 43
        frame_offset 1476
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 319: WOMBAT_SPRITE
        attack_gfx_prop WOMBAT_SPRITE
        is_3bpp
        frames 2
        tile_offset 219
        frame_offset 1480
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 320: WOMBAT_BG1
        attack_gfx_prop WOMBAT_BG1
        is_2bpp
        frames 4
        tile_offset 43
        frame_offset 1482
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 321: WHUMP_SPRITE
        attack_gfx_prop WHUMP_SPRITE
        is_3bpp
        frames 2
        tile_offset 219
        frame_offset 1486
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 322: WHUMP_BG1
        attack_gfx_prop WHUMP_BG1
        is_2bpp
        frames 4
        tile_offset 43
        frame_offset 1488
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 323: LEAP_CMD_SPRITE
        attack_gfx_prop LEAP_CMD_SPRITE
        is_3bpp
        tile_offset 219
        frame_offset 1492
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 324: TAPIR_BG1
        attack_gfx_prop TAPIR_BG1
        is_3bpp
        tile_offset 219
        frame_offset 1493
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 325: TAPIR_SPRITE
        attack_gfx_prop TAPIR_SPRITE
        is_2bpp
        frames 8
        tile_offset 10
        frame_offset 1494
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 326: POIS_FROG_BG1
        attack_gfx_prop POIS_FROG_BG1
        is_3bpp
        frames 3
        tile_offset 220
        frame_offset 1502
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 327: POIS_FROG_SPRITE
        attack_gfx_prop POIS_FROG_SPRITE
        is_3bpp
        frames 27
        tile_offset 8
        frame_offset 1505
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 328: ICE_RABBIT_BG1
        attack_gfx_prop ICE_RABBIT_BG1
        is_3bpp
        frames 2
        tile_offset 220
        frame_offset 1532
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 329: ICE_RABBIT_SPRITE
        attack_gfx_prop ICE_RABBIT_SPRITE
        is_2bpp
        frames 7
        tile_offset 9
        frame_offset 1534
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 330: LAGOMORPH_BG1
        attack_gfx_prop LAGOMORPH_BG1
        is_3bpp
        frames 2
        tile_offset 220
        frame_offset 1541
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 331: FIRE_BEAM_BG1
        attack_gfx_prop FIRE_BEAM_BG1
        is_3bpp
        tile_offset 209
        frame_offset 1543
        frame_size {16, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 332: FIRE_BEAM_BG3
        attack_gfx_prop FIRE_BEAM_BG3
        is_2bpp
        frames 9
        tile_offset 17
        frame_offset 1544
        frame_size {16, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 333: FIRE_BEAM_SPRITE
        attack_gfx_prop FIRE_BEAM_SPRITE
        is_3bpp
        frames 6
        tile_offset 172
        frame_offset 1553
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 334: WILD_BEAR_SPRITE
        attack_gfx_prop WILD_BEAR_SPRITE
        is_3bpp
        frames 3
        tile_offset 218
        frame_offset 1559
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 335: WILD_BEAR_BG1
        attack_gfx_prop WILD_BEAR_BG1
        is_3bpp
        tile_offset 86
        frame_offset 1562
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 336: KITTY_SPRITE
        attack_gfx_prop KITTY_SPRITE
        is_3bpp
        frames 9
        tile_offset 206
        frame_offset 1563
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 337: KITTY_BG1
        attack_gfx_prop KITTY_BG1
        is_3bpp
        frames 5
        tile_offset 219
        frame_offset 1572
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 338: SNARE_BG1
        attack_gfx_prop SNARE_BG1
        is_3bpp
        tile_offset 187
        frame_offset 1577
        frame_size {8, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 339: CURA_SPRITE
        attack_gfx_prop CURA_SPRITE
        is_2bpp
        frames 14
        tile_offset 9
        frame_offset 1578
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 340: BOLT_BEAM_BG1
        attack_gfx_prop BOLT_BEAM_BG1
        is_3bpp
        frames 6
        tile_offset 150
        frame_offset 1592
        frame_size {16, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 341: BOLT_BEAM_BG3
        attack_gfx_prop BOLT_BEAM_BG3
        is_2bpp
        tile_offset 17
        frame_offset 1598
        frame_size {16, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 342: BOLT_BEAM_SPRITE
        attack_gfx_prop BOLT_BEAM_SPRITE
        is_3bpp
        frames 6
        tile_offset 172
        frame_offset 1599
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 343: ICE_BEAM_BG1
        attack_gfx_prop ICE_BEAM_BG1
        is_3bpp
        tile_offset 168
        frame_offset 1605
        frame_size {16, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 344: BIO_BLAST_BG1
        attack_gfx_prop BIO_BLAST_BG1
        is_3bpp
        tile_offset 79
        frame_offset 1606
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 345: ATTACK_ANIM_SCRIPT_345
        attack_gfx_prop ATTACK_ANIM_SCRIPT_345
        is_3bpp
        frames 7
        tile_offset 232
        frame_offset 1607
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 346: GRAV_BOMB_SPRITE
        attack_gfx_prop GRAV_BOMB_SPRITE
        is_3bpp
        frames 13
        tile_offset 231
        frame_offset 1614
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 347: GRAV_BOMB_BG1
        attack_gfx_prop GRAV_BOMB_BG1
        is_3bpp
        frames 12
        tile_offset 224
        frame_offset 1627
        frame_size {5, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 348: CONFUSER_BG3
        attack_gfx_prop CONFUSER_BG3
        is_2bpp
        tile_offset 28
        frame_offset 1639
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 349: CONFUSER_BG1
        attack_gfx_prop CONFUSER_BG1
        is_3bpp
        tile_offset 28
        frame_offset 1640
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 350: XFER_SPRITE
        attack_gfx_prop XFER_SPRITE
        is_3bpp
        frames 3
        tile_offset 167
        frame_offset 1641
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 351: XFER_BG3
        attack_gfx_prop XFER_BG3
        is_2bpp
        frames 3
        tile_offset 5
        frame_offset 1644
        frame_size {8, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 352: EXPLODER_SPRITE
        attack_gfx_prop EXPLODER_SPRITE
        is_3bpp
        frames 8
        tile_offset 234
        frame_offset 1647
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 353: EXPLODER_BG1
        attack_gfx_prop EXPLODER_BG1
        is_3bpp
        frames 5
        tile_offset 96
        frame_offset 1655
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 354: FIRE_BALL_SPRITE
        attack_gfx_prop FIRE_BALL_SPRITE
        is_3bpp
        frames 8
        tile_offset 16
        frame_offset 1660
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 355: ATOMIC_RAY_SPRITE
        attack_gfx_prop ATOMIC_RAY_SPRITE
        is_3bpp
        frames 9
        tile_offset 206
        frame_offset 1668
        frame_size {4, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 356: ATOMIC_RAY_BG1
        attack_gfx_prop ATOMIC_RAY_BG1
        is_3bpp
        frames 15
        tile_offset 206
        frame_offset 1677
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 357: TEK_LASER_BG1
        attack_gfx_prop TEK_LASER_BG1
        is_2bpp
        frames 10
        tile_offset 45
        frame_offset 1692
        frame_size {16, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 358: TEK_LASER_SPRITE
        attack_gfx_prop TEK_LASER_SPRITE
        is_3bpp
        frames 21
        tile_offset 206
        frame_offset 1702
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 359: DIFFUSER_SPRITE
        attack_gfx_prop DIFFUSER_SPRITE
        is_3bpp
        frames 4
        tile_offset 206
        frame_offset 1723
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 360: DIFFUSER_BG1
        attack_gfx_prop DIFFUSER_BG1
        is_3bpp
        frames 12
        tile_offset 169
        frame_offset 1727
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 361: DIFFUSER_BG3
        attack_gfx_prop DIFFUSER_BG3
        is_2bpp
        frames 3
        tile_offset 13
        frame_offset 1739
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 362: SNOWSTORM_SPRITE
        attack_gfx_prop SNOWSTORM_SPRITE
        is_3bpp
        frames 21
        tile_offset 173
        frame_offset 1742
        frame_size {7, 7}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 363: SNOWSTORM_BG1
        attack_gfx_prop SNOWSTORM_BG1
        is_3bpp
        tile_offset 85
        frame_offset 1763
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 364: FLASH_RAIN_BG1
        attack_gfx_prop FLASH_RAIN_BG1
        is_3bpp
        tile_offset 86
        frame_offset 1764
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 365: FLASH_RAIN_BG3
        attack_gfx_prop FLASH_RAIN_BG3
        is_2bpp
        frames 4
        tile_offset 88
        frame_offset 1765
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 366: WALLCHANGE_SPRITE
        attack_gfx_prop WALLCHANGE_SPRITE
        is_3bpp
        tile_offset 234
        frame_offset 1769
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 367: ESCAPE_SPRITE
        attack_gfx_prop ESCAPE_SPRITE
        is_3bpp
        tile_offset 234
        frame_offset 1770
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 368: DREAD_SPRITE
        attack_gfx_prop DREAD_SPRITE
        is_3bpp
        frames 11
        tile_offset 206
        frame_offset 1771
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 369: IMP_SONG_SPRITE
        attack_gfx_prop IMP_SONG_SPRITE
        is_3bpp
        frames 14
        tile_offset 6
        frame_offset 1782
        frame_size {6, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 370: IMP_SONG_BG1
        attack_gfx_prop IMP_SONG_BG1
        is_2bpp
        tile_offset 91
        frame_offset 1796
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 371: CLEAR_BG3
        attack_gfx_prop CLEAR_BG3
        is_2bpp
        tile_offset 92
        frame_offset 1797
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 372: VIRITE_SPRITE
        attack_gfx_prop VIRITE_SPRITE
        is_3bpp
        frames 6
        tile_offset 6
        frame_offset 1798
        frame_size {4, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 373: CHOKESMOKE_BG1
        attack_gfx_prop CHOKESMOKE_BG1
        is_3bpp
        frames 12
        tile_offset 118
        frame_offset 1804
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 374: SCHILLER_SPRITE
        attack_gfx_prop SCHILLER_SPRITE
        is_3bpp
        tile_offset 6
        frame_offset 1816
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 375: LULLABY_SPRITE
        attack_gfx_prop LULLABY_SPRITE
        is_3bpp
        tile_offset 27
        frame_offset 1817
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 376: MEGAZERK_BG1
        attack_gfx_prop MEGAZERK_BG1
        is_3bpp
        tile_offset 206
        frame_offset 1818
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 377: SLIMER_BG1
        attack_gfx_prop SLIMER_BG1
        is_3bpp
        tile_offset 57
        frame_offset 1819
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 378: DELTA_HIT_SPRITE
        attack_gfx_prop DELTA_HIT_SPRITE
        is_3bpp
        frames 5
        tile_offset 206
        frame_offset 1820
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 379: DELTA_HIT_BG1
        attack_gfx_prop DELTA_HIT_BG1
        is_3bpp
        tile_offset 209
        frame_offset 1825
        frame_size {8, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 380: RUN_AWAY_SPRITE
        attack_gfx_prop RUN_AWAY_SPRITE
        is_3bpp
        tile_offset 33
        frame_offset 1826
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 381: BLASTER_SPRITE
        attack_gfx_prop BLASTER_SPRITE
        is_3bpp
        frames 4
        tile_offset 244
        frame_offset 1827
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 382: CONDEMNED_BG1
        attack_gfx_prop CONDEMNED_BG1
        is_3bpp
        tile_offset 0
        frame_offset 1831
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 383: CONDEMNED_BG3
        attack_gfx_prop CONDEMNED_BG3
        is_2bpp
        tile_offset 28
        frame_offset 1832
        frame_size {4, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 384: CLEANSWEEP_BG1
        attack_gfx_prop CLEANSWEEP_BG1
        is_3bpp
        frames 15
        tile_offset 192
        frame_offset 1833
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 385: WAVECANNON_SPRITE
        attack_gfx_prop WAVECANNON_SPRITE
        is_3bpp
        frames 9
        tile_offset 234
        frame_offset 1848
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 386: ATTACK_ANIM_SCRIPT_386
        attack_gfx_prop ATTACK_ANIM_SCRIPT_386
        is_2bpp
        frames 11
        tile_offset 8
        frame_offset 1857
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 387: TRAIN_BG1
        attack_gfx_prop TRAIN_BG1
        is_3bpp
        tile_offset 69
        frame_offset 1868
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 388: TRAIN_BG3
        attack_gfx_prop TRAIN_BG3
        is_2bpp
        tile_offset 60
        frame_offset 1869
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 389: L5_DOOM_SPRITE
        attack_gfx_prop L5_DOOM_SPRITE
        is_3bpp
        frames 8
        tile_offset 277
        frame_offset 1870
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 390: L4_FLARE_SPRITE
        attack_gfx_prop L4_FLARE_SPRITE
        is_3bpp
        frames 27
        tile_offset 171
        frame_offset 1878
        frame_size {11, 11}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 391: L4_FLARE_BG1
        attack_gfx_prop L4_FLARE_BG1
        is_3bpp
        frames 16
        tile_offset 171
        frame_offset 1905
        frame_size {11, 11}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 392: BLOW_FISH_SPRITE
        attack_gfx_prop BLOW_FISH_SPRITE
        is_3bpp
        frames 2
        tile_offset 171
        frame_offset 1921
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 393: PEARL_LORE_SPRITE
        attack_gfx_prop PEARL_LORE_SPRITE
        is_3bpp
        frames 5
        tile_offset 231
        frame_offset 1923
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 394: PEARL_LORE_BG1
        attack_gfx_prop PEARL_LORE_BG1
        is_3bpp
        frames 14
        tile_offset 172
        frame_offset 1928
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 395: STEP_MINE_SPRITE
        attack_gfx_prop STEP_MINE_SPRITE
        is_3bpp
        frames 5
        tile_offset 244
        frame_offset 1942
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 396: TEKMISSILE_SPRITE
        attack_gfx_prop TEKMISSILE_SPRITE
        is_3bpp
        frames 5
        tile_offset 10
        frame_offset 1947
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 397: AERO_BG1
        attack_gfx_prop AERO_BG1
        is_3bpp
        tile_offset 57
        frame_offset 1952
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 398: SLOW_BG3
        attack_gfx_prop SLOW_BG3
        is_2bpp
        tile_offset 60
        frame_offset 1953
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 399: AQUA_RAKE_BG1
        attack_gfx_prop AQUA_RAKE_BG1
        is_3bpp
        frames 15
        tile_offset 192
        frame_offset 1954
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 400: L4_FLARE_EXTRA
        attack_gfx_prop L4_FLARE_EXTRA
        is_3bpp
        tile_offset 171
        frame_offset 1969
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 401: AERO_BG3
        attack_gfx_prop AERO_BG3
        is_2bpp
        tile_offset 26
        frame_offset 1970
        frame_size {8, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 402: RIPPLER_SPRITE
        attack_gfx_prop RIPPLER_SPRITE
        is_3bpp
        frames 5
        tile_offset 244
        frame_offset 1971
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 403: RIPPLER_BG1
        attack_gfx_prop RIPPLER_BG1
        is_3bpp
        tile_offset 228
        frame_offset 1976
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 404: STONE_SPRITE
        attack_gfx_prop STONE_SPRITE
        is_3bpp
        tile_offset 24
        frame_offset 1977
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 405: STONE_BG1
        attack_gfx_prop STONE_BG1
        is_2bpp
        frames 4
        tile_offset 43
        frame_offset 1978
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 406: ENTWINE_SPRITE
        attack_gfx_prop ENTWINE_SPRITE
        is_2bpp
        frames 19
        tile_offset 46
        frame_offset 1982
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 407: CYCLONIC_SPRITE
        attack_gfx_prop CYCLONIC_SPRITE
        is_3bpp
        frames 4
        tile_offset 98
        frame_offset 2001
        frame_size {2, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 408: CYCLONIC_BG1
        attack_gfx_prop CYCLONIC_BG1
        is_3bpp
        tile_offset 241
        frame_offset 2005
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 409: DISCHORD_SPRITE
        attack_gfx_prop DISCHORD_SPRITE
        is_3bpp
        tile_offset 228
        frame_offset 2006
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 410: R_POLARITY_BG1
        attack_gfx_prop R_POLARITY_BG1
        is_3bpp
        tile_offset 228
        frame_offset 2007
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 411: R_POLARITY_SPRITE
        attack_gfx_prop R_POLARITY_SPRITE
        is_3bpp
        tile_offset 228
        frame_offset 2008
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 412: PEP_UP_BG1
        attack_gfx_prop PEP_UP_BG1
        is_3bpp
        tile_offset 228
        frame_offset 2009
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 413: NET_SPRITE
        attack_gfx_prop NET_SPRITE
        is_3bpp
        frames 4
        tile_offset 241
        frame_offset 2010
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 414: WHITE_WIND_BG1
        attack_gfx_prop WHITE_WIND_BG1
        is_3bpp
        tile_offset 171
        frame_offset 2014
        frame_size {16, 16}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 415: QUASAR_SPRITE
        attack_gfx_prop QUASAR_SPRITE
        is_3bpp
        frames 29
        tile_offset 24
        frame_offset 2015
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 416: QUASAR_BG1
        attack_gfx_prop QUASAR_BG1
        is_3bpp
        tile_offset 201
        frame_offset 2044
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 417: QUASAR_BG3
        attack_gfx_prop QUASAR_BG3
        is_2bpp
        tile_offset 28
        frame_offset 2045
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 418: GONER_BG1
        attack_gfx_prop GONER_BG1
        is_3bpp
        tile_offset 92
        frame_offset 2046
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 419: GONER_BG3
        attack_gfx_prop GONER_BG3
        is_2bpp
        frames 8
        tile_offset 96
        frame_offset 2047
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 420: FLARE_STAR_SPRITE
        attack_gfx_prop FLARE_STAR_SPRITE
        is_3bpp
        frames 21
        tile_offset 206
        frame_offset 2055
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 421: FLARE_STAR_BG1
        attack_gfx_prop FLARE_STAR_BG1
        is_3bpp
        tile_offset 28
        frame_offset 2076
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 422: FLARE_STAR_BG3
        attack_gfx_prop FLARE_STAR_BG3
        is_2bpp
        tile_offset 53
        frame_offset 2077
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 423: AERO_SPRITE
        attack_gfx_prop AERO_SPRITE
        is_3bpp
        frames 4
        tile_offset 98
        frame_offset 2078
        frame_size {2, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 424: ATTACK_ANIM_SCRIPT_424
        attack_gfx_prop ATTACK_ANIM_SCRIPT_424
        is_3bpp
        tile_offset 24
        frame_offset 2082
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 425: STEP_FORWARD_MAGITEK_SPRITE
        attack_gfx_prop STEP_FORWARD_MAGITEK_SPRITE
        is_3bpp
        tile_offset 24
        frame_offset 2083
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 426: MIND_BLAST_BG1
        attack_gfx_prop MIND_BLAST_BG1
        is_3bpp
        tile_offset 154
        frame_offset 2084
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 427: MIND_BLAST_BG3
        attack_gfx_prop MIND_BLAST_BG3
        is_3bpp
        tile_offset 154
        frame_offset 2085
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 428: S_CROSS_SPRITE
        attack_gfx_prop S_CROSS_SPRITE
        is_3bpp
        frames 5
        tile_offset 234
        frame_offset 2086
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 429: S_CROSS_BG1
        attack_gfx_prop S_CROSS_BG1
        is_3bpp
        tile_offset 234
        frame_offset 2091
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 430: TERRA_TRITOCH_SPRITE
        attack_gfx_prop TERRA_TRITOCH_SPRITE
        is_3bpp
        frames 8
        tile_offset 234
        frame_offset 2092
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 431: TERRA_TRITOCH_BG1
        attack_gfx_prop TERRA_TRITOCH_BG1
        is_3bpp
        tile_offset 259
        frame_offset 2100
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 432: TERRA_TRITOCH_BG3
        attack_gfx_prop TERRA_TRITOCH_BG3
        is_2bpp
        frames 9
        tile_offset 88
        frame_offset 2101
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 433: FORCEFIELD_BG3
        attack_gfx_prop FORCEFIELD_BG3
        is_2bpp
        tile_offset 57
        frame_offset 2110
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 434: BIG_GUARD_SPRITE
        attack_gfx_prop BIG_GUARD_SPRITE
        is_2bpp
        frames 11
        tile_offset 8
        frame_offset 2111
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 435: BIG_GUARD_BG1
        attack_gfx_prop BIG_GUARD_BG1
        is_3bpp
        tile_offset 73
        frame_offset 2122
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 436: DISASTER_SPRITE
        attack_gfx_prop DISASTER_SPRITE
        is_3bpp
        tile_offset 0
        frame_offset 2123
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 437: DISASTER_BG1
        attack_gfx_prop DISASTER_BG1
        is_3bpp
        tile_offset 0
        frame_offset 2124
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 438: OVERCAST_SPRITE
        attack_gfx_prop OVERCAST_SPRITE
        is_3bpp
        frames 11
        tile_offset 12
        frame_offset 2125
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 439: OVERCAST_BG1
        attack_gfx_prop OVERCAST_BG1
        is_3bpp
        tile_offset 12
        frame_offset 2136
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 440: ABSOLUTE0_BG1
        attack_gfx_prop ABSOLUTE0_BG1
        is_3bpp
        tile_offset 177
        frame_offset 2137
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 441: FIFTY_GS_SPRITE
        attack_gfx_prop FIFTY_GS_SPRITE
        is_3bpp
        tile_offset 224
        frame_offset 2138
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 442: FIFTY_GS_BG1
        attack_gfx_prop FIFTY_GS_BG1
        is_3bpp
        tile_offset 224
        frame_offset 2139
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 443: MAGNITUDE8_SPRITE
        attack_gfx_prop MAGNITUDE8_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2140
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 444: BLIZZARD_FIST_BG1
        attack_gfx_prop BLIZZARD_FIST_BG1
        is_3bpp
        tile_offset 85
        frame_offset 2141
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 445: BLIZZARD_FIST_BG3
        attack_gfx_prop BLIZZARD_FIST_BG3
        is_2bpp
        tile_offset 28
        frame_offset 2142
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 446: MUTE_SPRITE
        attack_gfx_prop MUTE_SPRITE
        is_3bpp
        frames 5
        tile_offset 6
        frame_offset 2143
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 447: MUTE_BG1
        attack_gfx_prop MUTE_BG1
        is_3bpp
        frames 2
        tile_offset 2
        frame_offset 2148
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 448: HEART_BURN_SPRITE
        attack_gfx_prop HEART_BURN_SPRITE
        is_3bpp
        frames 11
        tile_offset 124
        frame_offset 2150
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 449: ATTACK_ANIM_SCRIPT_449
        attack_gfx_prop ATTACK_ANIM_SCRIPT_449
        is_3bpp
        tile_offset 212
        frame_offset 2161
        frame_size {5, 11}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 450: METEO_BG3
        attack_gfx_prop METEO_BG3
        is_2bpp
        tile_offset 60
        frame_offset 2162
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 451: LOVE_TOKEN_SPRITE
        attack_gfx_prop LOVE_TOKEN_SPRITE
        is_3bpp
        frames 10
        tile_offset 250
        frame_offset 2163
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 452: TENTACLE_SPRITE
        attack_gfx_prop TENTACLE_SPRITE
        is_3bpp
        tile_offset 256
        frame_offset 2173
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 453: METEO_SPRITE
        attack_gfx_prop METEO_SPRITE
        is_3bpp
        frames 6
        tile_offset 234
        frame_offset 2174
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 454: SHADOWFANG_BG1
        attack_gfx_prop SHADOWFANG_BG1
        is_2bpp
        frames 15
        tile_offset 51
        frame_offset 2180
        frame_size {6, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 455: X_METEO_BG1
        attack_gfx_prop X_METEO_BG1
        is_3bpp
        tile_offset 24
        frame_offset 2195
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 456: ATTACK_ANIM_SCRIPT_456
        attack_gfx_prop ATTACK_ANIM_SCRIPT_456
        is_3bpp
        frames 3
        tile_offset 50
        frame_offset 2196
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 457: RIOT_BLADE_SPRITE
        attack_gfx_prop RIOT_BLADE_SPRITE
        is_2bpp
        frames 6
        tile_offset 32
        frame_offset 2199
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 458: ROYALSHOCK_BG1
        attack_gfx_prop ROYALSHOCK_BG1
        is_2bpp
        frames 10
        tile_offset 54
        frame_offset 2205
        frame_size {2, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 459: STAR_PRISM_SPRITE
        attack_gfx_prop STAR_PRISM_SPRITE
        is_2bpp
        frames 5
        tile_offset 8
        frame_offset 2215
        frame_size {1, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 460: TIGERBREAK_BG1
        attack_gfx_prop TIGERBREAK_BG1
        is_3bpp
        tile_offset 59
        frame_offset 2220
        frame_size {4, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 461: BACK_BLADE_BG3
        attack_gfx_prop BACK_BLADE_BG3
        is_2bpp
        frames 8
        tile_offset 57
        frame_offset 2221
        frame_size {6, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 462: TERRA_TRITOCH_ALT_BG1
        attack_gfx_prop TERRA_TRITOCH_ALT_BG1
        is_3bpp
        tile_offset 259
        frame_offset 2229
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 463: DISPATCH_SPRITE
        attack_gfx_prop DISPATCH_SPRITE
        is_3bpp
        frames 4
        tile_offset 50
        frame_offset 2230
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 464: RETORT_SPRITE
        attack_gfx_prop RETORT_SPRITE
        is_3bpp
        frames 4
        tile_offset 50
        frame_offset 2234
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 465: SLASH_SPRITE
        attack_gfx_prop SLASH_SPRITE
        is_3bpp
        frames 4
        tile_offset 50
        frame_offset 2238
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 466: SLASH_BG3
        attack_gfx_prop SLASH_BG3
        is_2bpp
        tile_offset 59
        frame_offset 2242
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 467: QUADRA_SLAM_SPRITE
        attack_gfx_prop QUADRA_SLAM_SPRITE
        is_3bpp
        frames 8
        tile_offset 50
        frame_offset 2243
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 468: UNUSED_BUSHIDO_SPRITE
        attack_gfx_prop UNUSED_BUSHIDO_SPRITE
        is_3bpp
        frames 8
        tile_offset 50
        frame_offset 2251
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 469: UNUSED_BUSHIDO_BG1
        attack_gfx_prop UNUSED_BUSHIDO_BG1
        is_3bpp
        tile_offset 88
        frame_offset 2259
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 470: STUNNER_SPRITE
        attack_gfx_prop STUNNER_SPRITE
        is_3bpp
        frames 10
        tile_offset 50
        frame_offset 2260
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 471: EMPOWERER_BG1
        attack_gfx_prop EMPOWERER_BG1
        is_3bpp
        tile_offset 50
        frame_offset 2270
        frame_size {4, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 472: EMPOWERER_SPRITE
        attack_gfx_prop EMPOWERER_SPRITE
        is_3bpp
        frames 4
        tile_offset 50
        frame_offset 2271
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 473: CLEAVE_SPRITE
        attack_gfx_prop CLEAVE_SPRITE
        is_3bpp
        frames 7
        tile_offset 50
        frame_offset 2275
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 474: STAR_PRISM_BG1
        attack_gfx_prop STAR_PRISM_BG1
        is_2bpp
        tile_offset 8
        frame_offset 2282
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 475: TIGERBREAK_SPRITE
        attack_gfx_prop TIGERBREAK_SPRITE
        is_3bpp
        tile_offset 320
        frame_offset 2283
        frame_size {4, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 476: SABRESOUL_BG1
        attack_gfx_prop SABRESOUL_BG1
        is_3bpp
        tile_offset 32
        frame_offset 2284
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 477: SPIN_EDGE_SPRITE
        attack_gfx_prop SPIN_EDGE_SPRITE
        is_3bpp
        frames 3
        tile_offset 133
        frame_offset 2285
        frame_size {3, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 478: MIRAGER_SPRITE
        attack_gfx_prop MIRAGER_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 2288
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 479: MIRAGER_BG1
        attack_gfx_prop MIRAGER_BG1
        is_3bpp
        tile_offset 32
        frame_offset 2289
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 480: WILD_FANG_SPRITE
        attack_gfx_prop WILD_FANG_SPRITE
        is_3bpp
        frames 5
        tile_offset 215
        frame_offset 2290
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 481: JUMP_CMD_SPRITE
        attack_gfx_prop JUMP_CMD_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 2295
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 482: SHRAPNEL_SPRITE
        attack_gfx_prop SHRAPNEL_SPRITE
        is_3bpp
        frames 4
        tile_offset 153
        frame_offset 2296
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 483: SHRAPNEL_BG1
        attack_gfx_prop SHRAPNEL_BG1
        is_2bpp
        frames 13
        tile_offset 40
        frame_offset 2300
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 484: TAKEDOWN_SPRITE
        attack_gfx_prop TAKEDOWN_SPRITE
        is_3bpp
        frames 3
        tile_offset 215
        frame_offset 2313
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 485: TAKEDOWN_BG1
        attack_gfx_prop TAKEDOWN_BG1
        is_2bpp
        frames 4
        tile_offset 43
        frame_offset 2316
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 486: CHARM_SPRITE
        attack_gfx_prop CHARM_SPRITE
        is_3bpp
        frames 4
        tile_offset 164
        frame_offset 2320
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 487: EVIL_TOOT_SPRITE
        attack_gfx_prop EVIL_TOOT_SPRITE
        is_3bpp
        frames 3
        tile_offset 4
        frame_offset 2324
        frame_size {6, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 488: STRAY_SPRITE
        attack_gfx_prop STRAY_SPRITE
        is_2bpp
        frames 14
        tile_offset 9
        frame_offset 2327
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 489: STRAY_BG1
        attack_gfx_prop STRAY_BG1
        is_2bpp
        tile_offset 9
        frame_offset 2341
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 490: GOLEM_SPRITE
        attack_gfx_prop GOLEM_SPRITE
        is_3bpp
        frames 8
        tile_offset 2
        frame_offset 2342
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 491: GOLEM_BG1
        attack_gfx_prop GOLEM_BG1
        is_3bpp
        tile_offset 2
        frame_offset 2350
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 492: RAGNAROK_SPRITE
        attack_gfx_prop RAGNAROK_SPRITE
        is_3bpp
        frames 2
        tile_offset 211
        frame_offset 2351
        frame_size {1, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 493: RAGNAROK_BG3
        attack_gfx_prop RAGNAROK_BG3
        is_2bpp
        frames 9
        tile_offset 13
        frame_offset 2353
        frame_size {10, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 494: RAGNAROK_BG1
        attack_gfx_prop RAGNAROK_BG1
        is_3bpp
        tile_offset 211
        frame_offset 2362
        frame_size {5, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 495: RAIDEN_BG3
        attack_gfx_prop RAIDEN_BG3
        is_2bpp
        frames 7
        tile_offset 88
        frame_offset 2363
        frame_size {12, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 496: TRITOCH_BG1
        attack_gfx_prop TRITOCH_BG1
        is_3bpp
        frames 14
        tile_offset 172
        frame_offset 2370
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 497: TRITOCH_BG3
        attack_gfx_prop TRITOCH_BG3
        is_2bpp
        frames 9
        tile_offset 88
        frame_offset 2384
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 498: TRITOCH_SPRITE
        attack_gfx_prop TRITOCH_SPRITE
        is_3bpp
        tile_offset 172
        frame_offset 2393
        frame_size {5, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 499: PHANTOM_BG1
        attack_gfx_prop PHANTOM_BG1
        is_3bpp
        tile_offset 172
        frame_offset 2394
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 500: FIRE_SKEAN_BG1
        attack_gfx_prop FIRE_SKEAN_BG1
        is_3bpp
        frames 13
        tile_offset 3
        frame_offset 2395
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 501: WATER_EDGE_SPRITE
        attack_gfx_prop WATER_EDGE_SPRITE
        is_3bpp
        tile_offset 252
        frame_offset 2408
        frame_size {16, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 502: WATER_EDGE_BG1
        attack_gfx_prop WATER_EDGE_BG1
        is_3bpp
        tile_offset 252
        frame_offset 2409
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 503: BOLT_EDGE_BG1
        attack_gfx_prop BOLT_EDGE_BG1
        is_2bpp
        frames 9
        tile_offset 88
        frame_offset 2410
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 504: SHADOW_EDGE_SPRITE
        attack_gfx_prop SHADOW_EDGE_SPRITE
        is_2bpp
        frames 4
        tile_offset 32
        frame_offset 2419
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 505: BOLT_EDGE_BG3
        attack_gfx_prop BOLT_EDGE_BG3
        is_2bpp
        frames 9
        tile_offset 88
        frame_offset 2423
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 506: INVIZ_EDGE_BG1
        attack_gfx_prop INVIZ_EDGE_BG1
        is_2bpp
        frames 3
        tile_offset 92
        frame_offset 2432
        frame_size {11, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 507: TONIC_SPRITE
        attack_gfx_prop TONIC_SPRITE
        is_3bpp
        frames 7
        tile_offset 266
        frame_offset 2435
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 508: POTION_SPRITE
        attack_gfx_prop POTION_SPRITE
        is_3bpp
        frames 7
        tile_offset 266
        frame_offset 2442
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 509: X_POTION_SPRITE
        attack_gfx_prop X_POTION_SPRITE
        is_3bpp
        frames 8
        tile_offset 265
        frame_offset 2449
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 510: ELIXIR_SPRITE
        attack_gfx_prop ELIXIR_SPRITE
        is_3bpp
        frames 8
        tile_offset 265
        frame_offset 2457
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 511: FENIX_DOWN_SPRITE
        attack_gfx_prop FENIX_DOWN_SPRITE
        is_3bpp
        frames 9
        tile_offset 160
        frame_offset 2465
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 512: ANTIDOTE_SPRITE
        attack_gfx_prop ANTIDOTE_SPRITE
        is_3bpp
        frames 6
        tile_offset 2
        frame_offset 2474
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 513: GREEN_CHERRY_SPRITE
        attack_gfx_prop GREEN_CHERRY_SPRITE
        is_3bpp
        frames 8
        tile_offset 267
        frame_offset 2480
        frame_size {2, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 514: REMEDY_ITEM_SPRITE
        attack_gfx_prop REMEDY_ITEM_SPRITE
        is_3bpp
        frames 4
        tile_offset 167
        frame_offset 2488
        frame_size {1, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 515: EYEDROP_SPRITE
        attack_gfx_prop EYEDROP_SPRITE
        is_3bpp
        frames 4
        tile_offset 239
        frame_offset 2492
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 516: ECHO_SCREEN_SPRITE
        attack_gfx_prop ECHO_SCREEN_SPRITE
        is_3bpp
        frames 6
        tile_offset 6
        frame_offset 2496
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 517: SMOKE_BOMB_SPRITE
        attack_gfx_prop SMOKE_BOMB_SPRITE
        is_3bpp
        frames 6
        tile_offset 6
        frame_offset 2502
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 518: MEGALIXIR_SPRITE
        attack_gfx_prop MEGALIXIR_SPRITE
        is_3bpp
        frames 8
        tile_offset 265
        frame_offset 2508
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 519: X_POTION_BG3
        attack_gfx_prop X_POTION_BG3
        is_2bpp
        tile_offset 4
        frame_offset 2516
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 520: N_CROSS_BG3
        attack_gfx_prop N_CROSS_BG3
        is_2bpp
        tile_offset 4
        frame_offset 2517
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 521: SNEEZE_SPRITE
        attack_gfx_prop SNEEZE_SPRITE
        is_3bpp
        tile_offset 83
        frame_offset 2518
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 522: COLD_DUST_SPRITE
        attack_gfx_prop COLD_DUST_SPRITE
        is_3bpp
        frames 8
        tile_offset 160
        frame_offset 2519
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 523: COLD_DUST_BG1
        attack_gfx_prop COLD_DUST_BG1
        is_3bpp
        frames 6
        tile_offset 164
        frame_offset 2527
        frame_size {6, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 524: HYPERDRIVE_SPRITE
        attack_gfx_prop HYPERDRIVE_SPRITE
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2533
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 525: HYPERDRIVE_BG1
        attack_gfx_prop HYPERDRIVE_BG1
        is_2bpp
        tile_offset 13
        frame_offset 2540
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 526: SUPER_BALL_SPRITE
        attack_gfx_prop SUPER_BALL_SPRITE
        is_3bpp
        frames 3
        tile_offset 262
        frame_offset 2541
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 527: PHANTASM_SPRITE
        attack_gfx_prop PHANTASM_SPRITE
        is_3bpp
        frames 11
        tile_offset 147
        frame_offset 2544
        frame_size {7, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 528: PHANTASM_BG3
        attack_gfx_prop PHANTASM_BG3
        is_2bpp
        frames 2
        tile_offset 88
        frame_offset 2555
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 529: SHOCK_WAVE_SPRITE
        attack_gfx_prop SHOCK_WAVE_SPRITE
        is_3bpp
        frames 7
        tile_offset 140
        frame_offset 2557
        frame_size {8, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 530: SHOCK_WAVE_BG1
        attack_gfx_prop SHOCK_WAVE_BG1
        is_3bpp
        frames 8
        tile_offset 142
        frame_offset 2564
        frame_size {7, 6}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 531: SOUL_OUT_SPRITE
        attack_gfx_prop SOUL_OUT_SPRITE
        is_2bpp
        frames 4
        tile_offset 92
        frame_offset 2572
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 532: SEIZE_SPRITE
        attack_gfx_prop SEIZE_SPRITE
        is_2bpp
        frames 14
        tile_offset 45
        frame_offset 2576
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 533: ZINGER_BG1
        attack_gfx_prop ZINGER_BG1
        is_3bpp
        tile_offset 167
        frame_offset 2590
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 534: SOUL_OUT_BG1
        attack_gfx_prop SOUL_OUT_BG1
        is_2bpp
        frames 4
        tile_offset 32
        frame_offset 2591
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 535: MAGNITUDE8_BG1
        attack_gfx_prop MAGNITUDE8_BG1
        is_3bpp
        tile_offset 228
        frame_offset 2595
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 536: REVENGER_SPRITE
        attack_gfx_prop REVENGER_SPRITE
        is_3bpp
        tile_offset 228
        frame_offset 2596
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 537: CRUSADER_SPRITE
        attack_gfx_prop CRUSADER_SPRITE
        is_3bpp
        frames 3
        tile_offset 172
        frame_offset 2597
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 538: CRUSADER_BG1
        attack_gfx_prop CRUSADER_BG1
        is_3bpp
        tile_offset 172
        frame_offset 2600
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 539: CHOCOBOP_SPRITE
        attack_gfx_prop CHOCOBOP_SPRITE
        is_3bpp
        frames 3
        tile_offset 263
        frame_offset 2601
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 540: STORM_BG1
        attack_gfx_prop STORM_BG1
        is_3bpp
        tile_offset 85
        frame_offset 2604
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 541: H_BOMB_SPRITE
        attack_gfx_prop H_BOMB_SPRITE
        is_3bpp
        frames 9
        tile_offset 207
        frame_offset 2605
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 542: H_BOMB_BG1
        attack_gfx_prop H_BOMB_BG1
        is_3bpp
        tile_offset 207
        frame_offset 2614
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 543: SEVEN_FLUSH_SPRITE
        attack_gfx_prop SEVEN_FLUSH_SPRITE
        is_3bpp
        frames 12
        tile_offset 268
        frame_offset 2615
        frame_size {1, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 544: SEVEN_FLUSH_BG1
        attack_gfx_prop SEVEN_FLUSH_BG1
        is_3bpp
        tile_offset 268
        frame_offset 2627
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 545: STORM_SPRITE
        attack_gfx_prop STORM_SPRITE
        is_3bpp
        tile_offset 85
        frame_offset 2628
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 546: WATER_SPLASH_BG1
        attack_gfx_prop WATER_SPLASH_BG1
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2629
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 547: WATER_SPLASH_SPRITE
        attack_gfx_prop WATER_SPLASH_SPRITE
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2636
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 548: CURAGA_SPRITE
        attack_gfx_prop CURAGA_SPRITE
        is_3bpp
        frames 8
        tile_offset 265
        frame_offset 2643
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 549: POSSESS_BG1
        attack_gfx_prop POSSESS_BG1
        is_2bpp
        frames 4
        tile_offset 32
        frame_offset 2651
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 550: UMARO_TACKLE_SPRITE
        attack_gfx_prop UMARO_TACKLE_SPRITE
        is_3bpp
        tile_offset 44
        frame_offset 2655
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 551: UMARO_THROW_BG1
        attack_gfx_prop UMARO_THROW_BG1
        is_2bpp
        frames 4
        tile_offset 32
        frame_offset 2656
        frame_size {1, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 552: HEAL_FORCE_SPRITE
        attack_gfx_prop HEAL_FORCE_SPRITE
        is_3bpp
        frames 26
        tile_offset 160
        frame_offset 2660
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 553: SMOKE_ENTRY_SPRITE
        attack_gfx_prop SMOKE_ENTRY_SPRITE
        is_3bpp
        frames 6
        tile_offset 6
        frame_offset 2686
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 554: CEILING_ENTRY_SPRITE
        attack_gfx_prop CEILING_ENTRY_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2692
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 555: CEILING_EXIT_SPRITE
        attack_gfx_prop CEILING_EXIT_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2693
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 556: SIDE_ENTRY_SPRITE
        attack_gfx_prop SIDE_ENTRY_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2694
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 557: SIDE_EXIT_SPRITE
        attack_gfx_prop SIDE_EXIT_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2695
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 558: WATER_ENTRY_SPRITE
        attack_gfx_prop WATER_ENTRY_SPRITE
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2696
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 559: WATER_EXIT_SPRITE
        attack_gfx_prop WATER_EXIT_SPRITE
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2703
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 560: EVENT_BAHAMUT_BG1
        attack_gfx_prop EVENT_BAHAMUT_BG1
        is_3bpp
        tile_offset 207
        frame_offset 2710
        frame_size {6, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 561: EVENT_ZONESEEK_BG1
        attack_gfx_prop EVENT_ZONESEEK_BG1
        is_3bpp
        tile_offset 69
        frame_offset 2711
        frame_size {4, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 562: EVENT_FENRIR_BG1
        attack_gfx_prop EVENT_FENRIR_BG1
        is_3bpp
        tile_offset 91
        frame_offset 2712
        frame_size {3, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 563: EVENT_TERRATO_BG1
        attack_gfx_prop EVENT_TERRATO_BG1
        is_3bpp
        tile_offset 211
        frame_offset 2713
        frame_size {6, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 564: EVENT_SHIVA_BG1
        attack_gfx_prop EVENT_SHIVA_BG1
        is_3bpp
        tile_offset 206
        frame_offset 2714
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 565: EVENT_KIRIN_BG1
        attack_gfx_prop EVENT_KIRIN_BG1
        is_3bpp
        tile_offset 0
        frame_offset 2715
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 566: EVENT_BISMARK_BG1
        attack_gfx_prop EVENT_BISMARK_BG1
        is_3bpp
        tile_offset 192
        frame_offset 2716
        frame_size {6, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 567: EVENT_CARBUNKL_BG1
        attack_gfx_prop EVENT_CARBUNKL_BG1
        is_3bpp
        tile_offset 196
        frame_offset 2717
        frame_size {2, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 568: EVENT_PHANTOM_BG1
        attack_gfx_prop EVENT_PHANTOM_BG1
        is_3bpp
        tile_offset 172
        frame_offset 2718
        frame_size {5, 5}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 569: TRANSFORM_MAGICITE_SPRITE
        attack_gfx_prop TRANSFORM_MAGICITE_SPRITE
        is_3bpp
        frames 9
        tile_offset 160
        frame_offset 2719
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 570: TRANSFORM_MAGICITE_BG3
        attack_gfx_prop TRANSFORM_MAGICITE_BG3
        is_2bpp
        tile_offset 53
        frame_offset 2728
        frame_size {16, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 571: FLOAT_ENTRY_SPRITE
        attack_gfx_prop FLOAT_ENTRY_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2729
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 572: FLOAT_EXIT_SPRITE
        attack_gfx_prop FLOAT_EXIT_SPRITE
        is_2bpp
        tile_offset 60
        frame_offset 2730
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 573: SEIZE_BG1
        attack_gfx_prop SEIZE_BG1
        is_2bpp
        tile_offset 45
        frame_offset 2731
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 574: SAND_ENTRY_SPRITE
        attack_gfx_prop SAND_ENTRY_SPRITE
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2732
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 575: SAND_EXIT_SPRITE
        attack_gfx_prop SAND_EXIT_SPRITE
        is_3bpp
        frames 7
        tile_offset 275
        frame_offset 2739
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 576: CHADARNOOK_ENTRY_SPRITE
        attack_gfx_prop CHADARNOOK_ENTRY_SPRITE
        is_2bpp
        tile_offset 16
        frame_offset 2746
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 577: CHADARNOOK_EXIT_SPRITE
        attack_gfx_prop CHADARNOOK_EXIT_SPRITE
        is_2bpp
        tile_offset 16
        frame_offset 2747
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 578: RUNIC_ABSORB_SPRITE
        attack_gfx_prop RUNIC_ABSORB_SPRITE
        is_3bpp
        tile_offset 128
        frame_offset 2748
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 579: STEP_FORWARD_BG1
        attack_gfx_prop STEP_FORWARD_BG1
        is_3bpp
        tile_offset 128
        frame_offset 2749
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 580: FADE_DOWN_ENTRY_BG3
        attack_gfx_prop FADE_DOWN_ENTRY_BG3
        is_2bpp
        tile_offset 99
        frame_offset 2750
        frame_size {9, 13}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 581: FADE_DOWN_EXIT_BG3
        attack_gfx_prop FADE_DOWN_EXIT_BG3
        is_2bpp
        tile_offset 99
        frame_offset 2751
        frame_size {9, 13}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 582: LIFESHAVER_BG1
        attack_gfx_prop LIFESHAVER_BG1
        is_3bpp
        tile_offset 216
        frame_offset 2752
        frame_size {8, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 583: FADE_UP_ENTRY_BG3
        attack_gfx_prop FADE_UP_ENTRY_BG3
        is_2bpp
        tile_offset 99
        frame_offset 2753
        frame_size {9, 13}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 584: FADE_UP_EXIT_BG3
        attack_gfx_prop FADE_UP_EXIT_BG3
        is_2bpp
        tile_offset 99
        frame_offset 2754
        frame_size {9, 13}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 585: MATERIALIZE_ENTRY_BG3
        attack_gfx_prop MATERIALIZE_ENTRY_BG3
        is_2bpp
        frames 8
        tile_offset 16
        frame_offset 2755
        frame_size {9, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 586: MATERIALIZE_EXIT_BG3
        attack_gfx_prop MATERIALIZE_EXIT_BG3
        is_2bpp
        frames 8
        tile_offset 16
        frame_offset 2763
        frame_size {9, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 587: HORZ_FADE_ENTRY_BG3
        attack_gfx_prop HORZ_FADE_ENTRY_BG3
        is_2bpp
        frames 2
        tile_offset 99
        frame_offset 2771
        frame_size {16, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 588: HORZ_FADE_EXIT_BG3
        attack_gfx_prop HORZ_FADE_EXIT_BG3
        is_2bpp
        frames 2
        tile_offset 99
        frame_offset 2773
        frame_size {16, 8}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 589: FLASH_RED_BG1
        attack_gfx_prop FLASH_RED_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2775
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 590: MOVE_FORWARD_SLOW_SPRITE
        attack_gfx_prop MOVE_FORWARD_SLOW_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2776
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 591: MOVE_BACK_SLOW_SPRITE
        attack_gfx_prop MOVE_BACK_SLOW_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2777
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 592: DANCE_FAIL_SPRITE
        attack_gfx_prop DANCE_FAIL_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 2778
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 593: SHOAT_BG1
        attack_gfx_prop SHOAT_BG1
        is_3bpp
        frames 9
        tile_offset 206
        frame_offset 2779
        frame_size {9, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 594: SHOAT_SPRITE
        attack_gfx_prop SHOAT_SPRITE
        is_3bpp
        tile_offset 192
        frame_offset 2788
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 595: MOVE_FORWARD_8_SPRITE
        attack_gfx_prop MOVE_FORWARD_8_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2789
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 596: MOVE_BACK_8_SPRITE
        attack_gfx_prop MOVE_BACK_8_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2790
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 597: KEFKA_LEO_SMOKE_BG1
        attack_gfx_prop KEFKA_LEO_SMOKE_BG1
        is_3bpp
        frames 4
        tile_offset 280
        frame_offset 2791
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 598: GESTAHL_LIGHTNING_BG1
        attack_gfx_prop GESTAHL_LIGHTNING_BG1
        is_3bpp
        frames 13
        tile_offset 282
        frame_offset 2795
        frame_size {4, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 599: GESTAHL_BLACK_MAGIC_BG1
        attack_gfx_prop GESTAHL_BLACK_MAGIC_BG1
        is_3bpp
        tile_offset 60
        frame_offset 2808
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 600: CAPTURE_TO_SPRITE
        attack_gfx_prop CAPTURE_TO_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 2809
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 601: CAPTURE_FROM_SPRITE
        attack_gfx_prop CAPTURE_FROM_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 2810
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 602: UMARO_THROW_SPRITE
        attack_gfx_prop UMARO_THROW_SPRITE
        is_3bpp
        tile_offset 32
        frame_offset 2811
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 603: DISCARD_SPRITE
        attack_gfx_prop DISCARD_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2812
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 604: CHARS_RUN_LEFT_BG1
        attack_gfx_prop CHARS_RUN_LEFT_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2813
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 605: CHARS_RUN_RIGHT_BG1
        attack_gfx_prop CHARS_RUN_RIGHT_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2814
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 606: ENGULF_BG1
        attack_gfx_prop ENGULF_BG1
        is_3bpp
        tile_offset 69
        frame_offset 2815
        frame_size {8, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 607: ENGULF_BG3
        attack_gfx_prop ENGULF_BG3
        is_2bpp
        tile_offset 103
        frame_offset 2816
        frame_size {8, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 608: ENGULF_SPRITE
        attack_gfx_prop ENGULF_SPRITE
        is_3bpp
        tile_offset 69
        frame_offset 2817
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 609: CONFUSER_SPRITE
        attack_gfx_prop CONFUSER_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2818
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 610: SKETCH_CMD_BG3
        attack_gfx_prop SKETCH_CMD_BG3
        is_2bpp
        frames 2
        tile_offset 99
        frame_offset 2819
        frame_size {16, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 611: NEEDLE_HIT_BG1
        attack_gfx_prop NEEDLE_HIT_BG1
        is_3bpp
        tile_offset 171
        frame_offset 2821
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 612: INK_HIT_BG1
        attack_gfx_prop INK_HIT_BG1
        is_3bpp
        frames 6
        tile_offset 6
        frame_offset 2822
        frame_size {4, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 613: HAMMER_HIT_BG1
        attack_gfx_prop HAMMER_HIT_BG1
        is_3bpp
        frames 2
        tile_offset 256
        frame_offset 2828
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 614: BONE_HIT_BG1
        attack_gfx_prop BONE_HIT_BG1
        is_3bpp
        frames 4
        tile_offset 256
        frame_offset 2830
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 615: WRENCH_HIT_BG1
        attack_gfx_prop WRENCH_HIT_BG1
        is_3bpp
        frames 4
        tile_offset 256
        frame_offset 2834
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 616: LIGHTNING_HIT_BG1
        attack_gfx_prop LIGHTNING_HIT_BG1
        is_3bpp
        frames 6
        tile_offset 147
        frame_offset 2838
        frame_size {4, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 617: BEAM_HIT_BG1
        attack_gfx_prop BEAM_HIT_BG1
        is_3bpp
        tile_offset 212
        frame_offset 2844
        frame_size {2, 10}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 618: ROBOT_HIT_BG1
        attack_gfx_prop ROBOT_HIT_BG1
        is_3bpp
        tile_offset 45
        frame_offset 2845
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 619: SLIME_HIT_BG1
        attack_gfx_prop SLIME_HIT_BG1
        is_3bpp
        frames 11
        tile_offset 124
        frame_offset 2846
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 620: STAR_HIT_BG1
        attack_gfx_prop STAR_HIT_BG1
        is_2bpp
        frames 4
        tile_offset 43
        frame_offset 2857
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 621: VERTICAL_HIT_BG1
        attack_gfx_prop VERTICAL_HIT_BG1
        is_2bpp
        frames 5
        tile_offset 43
        frame_offset 2861
        frame_size {1, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 622: BIT_HIT_BG1
        attack_gfx_prop BIT_HIT_BG1
        is_2bpp
        frames 12
        tile_offset 43
        frame_offset 2866
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 623: BUBBLE_HIT_BG1
        attack_gfx_prop BUBBLE_HIT_BG1
        is_3bpp
        frames 5
        tile_offset 192
        frame_offset 2878
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 624: MUSIC_HIT_BG1
        attack_gfx_prop MUSIC_HIT_BG1
        is_2bpp
        frames 2
        tile_offset 92
        frame_offset 2883
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 625: HEART_HIT_BG1
        attack_gfx_prop HEART_HIT_BG1
        is_3bpp
        frames 4
        tile_offset 164
        frame_offset 2885
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 626: WHEEL_HIT_BG1
        attack_gfx_prop WHEEL_HIT_BG1
        is_3bpp
        frames 3
        tile_offset 256
        frame_offset 2889
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 627: FLOWER_HIT_BG1
        attack_gfx_prop FLOWER_HIT_BG1
        is_3bpp
        frames 10
        tile_offset 250
        frame_offset 2892
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 628: MISSILE_HIT_BG1
        attack_gfx_prop MISSILE_HIT_BG1
        is_3bpp
        frames 5
        tile_offset 10
        frame_offset 2902
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 629: NET_HIT_BG1
        attack_gfx_prop NET_HIT_BG1
        is_3bpp
        frames 4
        tile_offset 241
        frame_offset 2907
        frame_size {3, 3}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 630: DRILL_HIT_BG1
        attack_gfx_prop DRILL_HIT_BG1
        is_3bpp
        tile_offset 45
        frame_offset 2911
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 631: BALL_HIT_BG1
        attack_gfx_prop BALL_HIT_BG1
        is_3bpp
        tile_offset 232
        frame_offset 2912
        frame_size {2, 2}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 632: THROW_FULL_MOON_SPRITE
        attack_gfx_prop THROW_FULL_MOON_SPRITE
        is_3bpp
        frames 2
        tile_offset 60
        frame_offset 2913
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 633: THROW_BOOMERANG_SPRITE
        attack_gfx_prop THROW_BOOMERANG_SPRITE
        is_3bpp
        frames 6
        tile_offset 44
        frame_offset 2915
        frame_size {2, 1}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 634: SKULL_HIT_BG1
        attack_gfx_prop SKULL_HIT_BG1
        is_3bpp
        frames 9
        tile_offset 284
        frame_offset 2921
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 635: BOSS_DEATH_BG1
        attack_gfx_prop BOSS_DEATH_BG1
        is_2bpp
        tile_offset 16
        frame_offset 2930
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 636: MOVE_FORWARD_64_SPRITE
        attack_gfx_prop MOVE_FORWARD_64_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2931
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 637: MOVE_BACK_64_SPRITE
        attack_gfx_prop MOVE_BACK_64_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2932
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 638: ATTACK_ANIM_SCRIPT_638
        attack_gfx_prop ATTACK_ANIM_SCRIPT_638
        is_3bpp
        tile_offset 32
        frame_offset 2933
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 639: FLASH_BG1
        attack_gfx_prop FLASH_BG1
        is_2bpp
        frames 4
        tile_offset 35
        frame_offset 2934
        frame_size {4, 4}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 640: KEFKA_ENTRY_SPRITE
        attack_gfx_prop KEFKA_ENTRY_SPRITE
        is_2bpp
        tile_offset 16
        frame_offset 2938
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 641: KEFKA_HEAD_BG1
        attack_gfx_prop KEFKA_HEAD_BG1
        is_3bpp
        tile_offset 284
        frame_offset 2939
        frame_size {16, 9}
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 642: MONSTER_GLOW_LONG_BG1
        attack_gfx_prop MONSTER_GLOW_LONG_BG1
        is_3bpp
        tile_offset 284
        frame_offset 2940
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 643: MONSTER_GLOW_SHORT_BG1
        attack_gfx_prop MONSTER_GLOW_SHORT_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2941
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 644: KEFKA_DEATH_BG1
        attack_gfx_prop KEFKA_DEATH_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2942
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 645: SUPER_BALL_EXTRA
        attack_gfx_prop SUPER_BALL_EXTRA
        is_2bpp
        tile_offset 99
        frame_offset 2943
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 646: CONTROL_BG1
        attack_gfx_prop CONTROL_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2944
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 647: BABABREATH_SPRITE
        attack_gfx_prop BABABREATH_SPRITE
        is_2bpp
        tile_offset 99
        frame_offset 2945
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

; 648: MONSTER_STEAL_BG1
        attack_gfx_prop MONSTER_STEAL_BG1
        is_2bpp
        tile_offset 99
        frame_offset 2946
        end_attack_gfx_prop

; ------------------------------------------------------------------------------

.if LANG_EN
; 649: WATER_EDGE_ALT_BG1
        attack_gfx_prop WATER_EDGE_ALT_BG1
        is_3bpp
        tile_offset 252
        frame_offset 2947
        frame_size {16, 9}
        end_attack_gfx_prop
.endif

; ------------------------------------------------------------------------------

.include "attack_gfx_prop.mac"
