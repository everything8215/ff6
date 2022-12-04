
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: btlgfx_data.asm                                                      |
; |                                                                            |
; | description: data for battle graphics program                              |
; |                                                                            |
; | created: 11/26/2022                                                        |
; +----------------------------------------------------------------------------+

.export CharAI, ItemTypeName, MonsterAlign

.segment "battle_event"

        .include "data/attack_anim_script.asm"                  ; d0/0000
        .include "data/attack_anim_prop.asm"                    ; d0/7fb2
        .res $9800+AttackAnimScript-*

        .include "data/battle_event_script_ptrs.asm"            ; d0/9800
        .include "data/battle_event_script.asm"                 ; d0/9842
        .res $3800+BattleEventScriptPtrs-*

BattleDlgPtrs:
        make_ptr_tbl_abs BattleDlg, 256                         ; d0/d000
        .include "text/battle_dlg.asm"                          ; d0/d200
        .res $2d00+BattleDlgPtrs-*
        .include "data/char_ai.asm"                             ; d0/fd00

; ------------------------------------------------------------------------------

.segment "battle_anim1"

ItemAnimPtrs:
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   $ffff
        .word   402*14
        .word   337*14
        .word   338*14
        .word   339*14
        .word   340*14
        .word   341*14
        .word   342*14
        .word   343*14
        .word   344*14
        .word   345*14
        .word   346*14
        .word   347*14
        .word   348*14
        .word   349*14
        .word   350*14
        .word   351*14
        .word   352*14
        .word   353*14
        .word   354*14
        .word   355*14
        .word   356*14
        .word   357*14
        .word   358*14
        .word   358*14
        .word   $ffff

        .include "data/item_jump_throw_anim.asm"                ; d1/0040
        .include "data/attack_anim_frames.asm"                  ; d1/0141
        AttackAnimFramesEnd := *
        .res $ead8+ItemAnimPtrs-*

        .include "data/attack_anim_script_ptrs.asm"             ; d1/ead8
        .res $f000+ItemAnimPtrs-*

        .include "text/attack_msg.asm"                          ; d1/f000
        .res $07a0+AttackMsg-*
AttackMsgPtrs:
        make_ptr_tbl_rel AttackMsg, 256, .bankbyte(*)<<16       ; d1/f7a0
        .res 11

; D1F9AB-D1F9B2   Battle Background Index to change to for each Dance
; D1F9B5-D1F9CF   Esper Order for Menu

; ------------------------------------------------------------------------------

.segment "battle_anim2"

        .include "gfx/attack_tiles_3bpp.asm"                    ; d2/0000
        .include "gfx/attack_pal.asm"                           ; d2/6000
        .include "text/item_type_name_en.asm"                   ; d2/6f00

; ------------------------------------------------------------------------------

.segment "monster_gfx_prop"

        .include "data/monster_gfx_prop.asm"                    ; d2/7000
        .include "gfx/monster_pal.asm"                          ; d2/7820

MonsterStencil:
        .addr   MonsterStencilSmall
        .addr   MonsterStencilLarge
        .include "data/monster_stencil_small.asm"               ; d2/a824
        .include "data/monster_stencil_large.asm"               ; d2/ac24

; ------------------------------------------------------------------------------

.segment "battle_anim3"

        .include "gfx/attack_tiles_2bpp.asm"                    ; d2/c000
        .include "gfx/status_gfx.asm"                           ; d2/e000

; ------------------------------------------------------------------------------

.segment "slot_gfx"

        .include "gfx/slot_gfx.asm"                             ; d2/f000

; ------------------------------------------------------------------------------

.segment "attack_gfx_3bpp"

        .include "gfx/attack_gfx_3bpp.asm"                      ; d3/0000

; ------------------------------------------------------------------------------

.segment "battle_anim4"

        .include "data/attack_gfx_prop.asm"                     ; d4/d000

AttackAnimFramesPtrs:
        make_ptr_tbl_rel AttackAnimFrames, 2948, .bankbyte(*)<<16 ; d4/df3c
        .addr   AttackAnimFramesEnd

; ------------------------------------------------------------------------------

.segment "attack_gfx_2bpp"

        .include "gfx/attack_gfx_2bpp.asm"                      ; d8/7000

; ------------------------------------------------------------------------------

.segment "attack_gfx_mode7"

        .include "gfx/attack_gfx_mode7.asm"                     ; d8/d000
        .include "gfx/attack_tiles_mode7.asm"                   ; d8/daf2

; ------------------------------------------------------------------------------

.segment "battle_bg"

; define battle bg graphics that load from map graphics
.repeat 82, i
        .import .ident(.sprintf("MapGfx_%04x", i))
.endrep

BattleBGGfx_000a := MapGfx_004a
BattleBGGfx_000b := MapGfx_001c
BattleBGGfx_000c := MapGfx_0017
BattleBGGfx_000d := MapGfx_0014
BattleBGGfx_000e := MapGfx_0015
BattleBGGfx_000f := MapGfx_0026
BattleBGGfx_0010 := MapGfx_002a
BattleBGGfx_0011 := MapGfx_000e
BattleBGGfx_0015 := MapGfx_0028
BattleBGGfx_001a := MapGfx_0041
BattleBGGfx_0027 := MapGfx_0036
BattleBGGfx_0028 := MapGfx_0048
BattleBGGfx_0029 := MapGfx_0030
BattleBGGfx_002a := MapGfx_0023
BattleBGGfx_002b := MapGfx_0049
BattleBGGfx_002c := MapGfx_0025
BattleBGGfx_002e := MapGfx_0000
BattleBGGfx_0030 := MapGfx_0019
BattleBGGfx_0031 := MapGfx_0027
BattleBGGfx_0033 := MapGfx_004b
BattleBGGfx_0035 := MapGfx_002b
BattleBGGfx_0037 := MapGfx_003e
BattleBGGfx_0038 := MapGfx_004f
BattleBGGfx_003a := MapGfx_002e
BattleBGGfx_0047 := MapGfx_0039
BattleBGGfx_0048 := MapGfx_0051
BattleBGGfx_0049 := MapGfx_0031

        .include "data/battle_bg_prop.asm"                      ; e7/0000
        .include "gfx/battle_bg_pal.asm"                        ; e7/0150

BattleBGGfxPtrs:
        make_ptr_tbl_far BattleBGGfx, 75, 0                     ; e7/1650
        .res $0117, 0

BattleBGTilesPtrs:
        make_ptr_tbl_rel BattleBGTiles, 112, .bankbyte(*)<<16   ; e7/1848

        .include "gfx/battle_bg_tiles.asm"                      ; e7/1928
        .include "gfx/battle_bg_gfx.asm"                        ; e7/a9e7

; ------------------------------------------------------------------------------

.segment "monster_gfx"

        .include "gfx/monster_gfx.asm"                          ; e9/7000
        .res 3, 0

; ------------------------------------------------------------------------------

.segment "weapon_anim"

        .include "data/weapon_anim_prop.asm"                    ; ec/e400
        .include "data/monster_attack_anim_prop.asm"            ; ec/e6e8
        .include "data/monster_align.asm"                       ; ec/e800

; ------------------------------------------------------------------------------
