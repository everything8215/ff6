; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

LoadMapCharGfx_ext:
@0000:  jsr     TfrObjGfxWorld
        rtl

; ------------------------------------------------------------------------------

StartingMapIndex:
@0004:  .word   3                       ; starting map

StartingMapX:
@0006:  .byte   8                       ; starting x position

StartingMapY:
@0007:  .byte   8                       ; starting y position

; ------------------------------------------------------------------------------

CheckBattleWorld_ext:
@0008:  jmp     CheckBattleWorld

; ------------------------------------------------------------------------------

DoPoisonDmg_ext:
@000b:  jmp     DoPoisonDmg
        nop7

; ------------------------------------------------------------------------------

DecTimersMenuBattle_ext:
@0015:  jsr     DecTimersMenuBattle
        rtl

; ------------------------------------------------------------------------------
