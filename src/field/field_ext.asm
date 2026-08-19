; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

LoadMapCharGfx_ext:
@0000:  jsr     TfrObjGfxWorld
        rtl

; ------------------------------------------------------------------------------

; these don't have much effect, as long as the starting map is at least 3.
; If the starting map is less than 3 the game will load a world map when reset

StartingMapIndex:
@0004:  .word   3

StartingMapX:
@0006:  .byte   8

StartingMapY:
@0007:  .byte   8

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
