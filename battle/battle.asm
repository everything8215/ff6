
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle.asm                                                           |
; |                                                                            |
; | description: battle program                                                |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "battle_data.asm"

.export Battle_ext, UpdateBattleTime_ext
.export UpdateEquip_ext, CalcMagicEffect_ext

; ------------------------------------------------------------------------------

.segment "battle_code"
.a8
.i16

; ------------------------------------------------------------------------------

Battle_ext:
@0000:  jmp     BattleMain

UpdateBattleTime_ext:
@0003:  jmp     UpdateBattleTime

UpdateEquip_ext:
@0006:  jmp     UpdateEquip

CalcMagicEffect_ext:
@0009:  jmp     CalcMagicEffect

; ------------------------------------------------------------------------------

BattleMain:
@000c:  rtl

; ------------------------------------------------------------------------------

UpdateEquip:
@0e77:  rtl

; ------------------------------------------------------------------------------

UpdateBattleTime:
@111b:  rtl

; ------------------------------------------------------------------------------

CalcMagicEffect:
@4730:  rtl

; ------------------------------------------------------------------------------
