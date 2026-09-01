; ------------------------------------------------------------------------------

; tile pointers for damage numeral sprites
_c2e394:
@e394:  .byte   $c0,$c4,$c8,$cc

_c2e398:
@e398:  .byte   $60,$64,$68,$6c,$80,$84,$88,$8c,$a0,$a4

; ------------------------------------------------------------------------------

; y offsets for float status
FloatStatusOffsetTbl:
@e3a2:  .byte   $fb,$fa,$f9,$f8,$f8,$f9,$fa,$fb

; ------------------------------------------------------------------------------

; glowing outline frame delay (1 byte per character)
StatusOutlineDelayTbl:
@e3aa:  .byte   $00,$08,$10,$18

; ------------------------------------------------------------------------------

; skin colors for poison, zombie, and berserk status
StatusSkinColorTbl:
@e3ae:  .word   $7edb,$4dd3
@e3b2:  .word   $3af5,$3210
@e3b6:  .word   $013f,$001f

; glowing outline colors for character status (reflect, safe, shell, haste, slow, vanish, unused, stop)
StatusOutlineColorTbl:
@e3ba:  .word   $6a60,$031f,$0b64,$001a,$7fff,$7fff,$001a,$7c1f

; ------------------------------------------------------------------------------

; x offsets for character status sprites (none, poison, muddle, dark, berserk/rage, mute, psyche/sleep)
StatusSpriteOffsetTbl:
@e3ca:  .word   $0000,$0000,$0000,$0002,$0000,$0010,$0020,$0000

; ------------------------------------------------------------------------------

; sprite data for character status sprites (none, poison, muddle, dark, berserk/rage, mute, psyche/sleep)
StatusSpriteData:
@e3da:  .byte   $00,$f8,$20,$0a
        .byte   $00,$f8,$22,$0a
        .byte   $ff,$fa,$24,$08
        .byte   $00,$f8,$26,$0c
        .byte   $f8,$f8,$28,$08
        .byte   $f0,$f8,$2a,$08
        .byte   $00,$10,$2c,$0c

; sprite data for character status sprites (character kneeling)
        .byte   $00,$fd,$20,$0a
        .byte   $00,$fd,$22,$0a
        .byte   $ff,$ff,$24,$08
        .byte   $00,$fd,$26,$0c
        .byte   $f8,$fd,$28,$08
        .byte   $f0,$fd,$2a,$08
        .byte   $00,$10,$2c,$0c

; ------------------------------------------------------------------------------

; pointers to character graphics frame buffers (+$7f0000)
_c2e412:
super_offset:
@e412:  .word   $8000,$6000,$4000,$2000

; ------------------------------------------------------------------------------

; pointers to character graphics vram buffers (+$7f0000)
_c2e41a:
player_pat_put_poi:
@e41a:  .word   $a000,$a080,$a100,$a180

; ------------------------------------------------------------------------------

; pointers to character sprite sheet buffers (+$7f0000)
_c2e422:
player_pat_get_poi:
@e422:  .word   $0000,$2000,$4000,$6000

; ------------------------------------------------------------------------------

; unused ???
_c2e42a:
obj_mask_tbl:
@e42a:  .word   $a000,$0000,$a000,$0000
        .word   $a000,$0000,$a000,$0000,$a000,$0000

; ------------------------------------------------------------------------------

; character h-flip for attack types (normal, back, pincer, side)
CharFlipTbl:
@e43e:  .byte   $00,$00,$00,$00
        .byte   $40,$40,$40,$40
        .byte   $40,$00,$40,$00
        .byte   $00,$00,$40,$40

; ------------------------------------------------------------------------------

; character hand swap for attack types
CharDirTbl:
@e44e:  .byte   $00,$00,$00,$00
        .byte   $01,$01,$01,$01
        .byte   $01,$00,$01,$00
        .byte   $00,$00,$01,$01

; ------------------------------------------------------------------------------

; magitek color palette locations (fills an empty character slot color palette)
MagitekPalOffsetTbl:
@e45e:  .byte   $08,$0a,$0c,$0e

; ------------------------------------------------------------------------------

; battle bgs which do not change for dance
DanceNoChangeBGTbl:
@e462:  .byte   0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1
        .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
        .byte   1,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0
        .byte   0,0,1,1,1,1,1,1

; ------------------------------------------------------------------------------

; graphical actions when waiting to attack (for each command)
command_act_tbl:
_c2e49a:
        .byte   CHAR_ACTION::READY      ; FIGHT
        .byte   CHAR_ACTION::READY      ; ITEM
        .byte   CHAR_ACTION::CASTING    ; MAGIC
        .byte   CHAR_ACTION::READY      ; MORPH
        .byte   CHAR_ACTION::READY      ; REVERT
        .byte   CHAR_ACTION::READY      ; STEAL
        .byte   CHAR_ACTION::READY      ; CAPTURE
        .byte   CHAR_ACTION::READY      ; BUSHIDO
        .byte   CHAR_ACTION::READY      ; THROW
        .byte   CHAR_ACTION::READY      ; TOOLS
        .byte   CHAR_ACTION::READY      ; BLITZ
        .byte   CHAR_ACTION::READY      ; RUNIC
        .byte   CHAR_ACTION::READY      ; LORE
        .byte   CHAR_ACTION::READY      ; SKETCH
        .byte   CHAR_ACTION::READY      ; CONTROL
        .byte   CHAR_ACTION::READY      ; SLOT
        .byte   CHAR_ACTION::READY      ; RAGE
        .byte   CHAR_ACTION::READY      ; LEAP
        .byte   CHAR_ACTION::READY      ; MIMIC
        .byte   CHAR_ACTION::READY      ; DANCE
        .byte   CHAR_ACTION::READY      ; ROW
        .byte   CHAR_ACTION::READY      ; DEF
        .byte   CHAR_ACTION::READY      ; JUMP
        .byte   CHAR_ACTION::READY      ; X_MAGIC
        .byte   CHAR_ACTION::READY      ; GP_RAIN
        .byte   CHAR_ACTION::CASTING    ; SUMMON
        .byte   CHAR_ACTION::CASTING    ; HEALTH
        .byte   CHAR_ACTION::READY      ; SHOCK
        .byte   CHAR_ACTION::READY      ; POSSESS
        .byte   CHAR_ACTION::NONE       ; MAGITEK
        .byte   CHAR_ACTION::READY      ; BATTLE_CMD_30
        .byte   CHAR_ACTION::READY      ; BATTLE_CMD_31
        .byte   CHAR_ACTION::READY      ; GFX_BATTLE_CMD_30
        .byte   CHAR_ACTION::READY      ; GFX_BATTLE_CMD_31
        .byte   CHAR_ACTION::READY      ; CHANGE_BATTLE
        .byte   CHAR_ACTION::READY      ; ROULETTE
        .byte   CHAR_ACTION::READY      ; RUN_AWAY
        .byte   CHAR_ACTION::READY      ; UMARO_TACKLE
        .byte   CHAR_ACTION::READY      ; UMARO_THROW
        .byte   CHAR_ACTION::READY      ; RUNIC_ABSORB
        .byte   CHAR_ACTION::READY      ; DICE_ROLL

; ------------------------------------------------------------------------------
