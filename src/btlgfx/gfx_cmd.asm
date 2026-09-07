
.include "src/sound/sfx.inc"
.include "attack_anim_frames.inc"
.include "attack_anim_script.inc"

.include "src/text/monster_special_name.inc"
.include "src/text/attack_msg.inc"
.include "src/text/battle_dlg.inc"
.include "src/text/monster_dlg.inc"

; ------------------------------------------------------------------------------

.import AttackGfx2bpp, AttackGfx3bpp
.import AttackTiles2bpp, AttackTiles3bpp
.import AttackAnimProp, AttackGfxProp
.import WeaponAnimProp, MonsterAttackAnimProp

; ------------------------------------------------------------------------------

; [ init animation variables ]

; called at start of battle and before battle event animations

InitAnimVars:
        jsr     InitSimpleAnim
        stz     near w7e62b0
        jsr     CopyPal
        jsr     PushMonsterPalID
        stz     near w7e62d0
        stz     near w7e62d1
        rtl

; ------------------------------------------------------------------------------

; [ de-initialize animation variables ]

; called after battle event animations

DeinitAnimVars:
        jsr     CopyPal
        jsr     PopMonsterPalID
        jsr     DeinitAnimType
        stz     near w7e62d0
        stz     near w7e62d1
        rtl

; ------------------------------------------------------------------------------

; [ graphics script command $0c: ready stance/jump ]

        array_label GFX_CMD, GFX_CMD::ADVANCE_WAIT
@9147:  jsr     _c1ab58
        jsr     array_item GFX_CMD, GFX_CMD::STEP_BACK
        ldy     #1
        lda     (z78),y                 ; attacker
        pha
        lda     (z76),y                 ; command
        pha
        cmp     #BATTLE_CMD::JUMP
        bne     @9174
        ldy     #1
        lda     (z78),y                 ; attacker
        cmp     #4
        bcc     @9168
        ldx     #attack_anim_prop_offset JUMP_MONSTER_UP               ; monster jump
        bra     @916b
@9168:  ldx     #attack_anim_prop_offset JUMP_CMD               ; character jump
@916b:  stx     $1e
        clr_a
        jsr     LoadAnimProp
        jsr     ExecAnim
@9174:  pla
        tax                             ; x = command
        pla
        cmp     #4
        bcs     @918d                   ; return if a monster
        asl5
        tay
        cpx     #$00ff                  ; return if command = $ff
        beq     @918d
        lda     f:_c2e49a,x             ; set graphical action for waiting to attack
        sta     near wCharGfxData::ReadyAction,y
@918d:  rts

; ------------------------------------------------------------------------------

; pointers to pre-attack animation properties (+$d07fb2)
PreMagicAnimPropPtrs:
        .word   attack_anim_prop_offset BLACK_MAGIC      ; black magic
        .word   attack_anim_prop_offset WHITE_MAGIC      ; white/effect magic
        .word   attack_anim_prop_offset SUMMON           ; genju
        .word   attack_anim_prop_offset LORE             ; lore

; ------------------------------------------------------------------------------

; graphics script command jump table
GfxCmdTbl:
        ptr_tbl GFX_CMD

; ------------------------------------------------------------------------------

; [ graphics script command $14: misc. monster animations (ai command $fa, command $2b) ]

        array_label GFX_CMD, GFX_CMD::MONSTER_ANIM
; pran2yos_long:
@91cc:  jsl     DoMonsterAnim
        rts

; ------------------------------------------------------------------------------

; [ final kefka death animation (far) ]

KefkaDeathAnim_far:
@91d1:  jsr     _c10e86
        jsr     InitMonsterGfx
        jsl     KefkaDeathAnim
        rtl

; ------------------------------------------------------------------------------

; [  ]

_c191dc:
all_obj_col_down:
@91dc:  inc     near w7e62bf
        jsr     CopyPal
        clr_a
@91e3:  jsr     _c19256
        pha
        ora     #$e0
        tax
        sta     $14
        sta     $16
        sta     $18
        ldx     #array_offset w7e7e00, 12
        stx     $10
        lda     #16 * 4
        sta     $12
        jsr     DecPal
        pla
        inc
        cmp     #$20
        bne     @91e3
        stz     near w7e62bf
        clr_ax
        stx     $10
        jmp     SetColorMathHDMA

; ------------------------------------------------------------------------------

; [  ]

_c1920c:
all_obj_col_up:
@920c:  inc     near w7e62bf
        jsr     CopyPal
        clr_ax
@9214:  stz     near w7e7e00::_12,x
        inx
        cpx     #$0080
        bne     @9214
        jsr     WaitFrame
        lda     #$0f
        sta     near w7e61ac
        lda     #$1f
@9227:  jsr     _c19256
        pha
        ora     #$e0
        tax
        sta     $14
        sta     $16
        sta     $18
        ldx     #array_offset w7e7e00, 12
        stx     $10
        lda     #16 * 4
        sta     $12
        jsr     DecPal
        pla
        dec
        bne     @9227
        lda     #$30
        jsr     _c1925e
        jsr     _c19256
        stz     near w7e62bf
        clr_ax
        stx     $10
        jmp     SetColorMathHDMA

; ------------------------------------------------------------------------------

; [  ]

_c19256:
wait_last:
@9256:  pha
        lda     #4
        jsr     WaitA       ; wait 4 frames
        pla
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1925e:
set_obj_all_pri:
@925e:  sta     near wCharGfxData::_0::LayerPriority
        sta     near wCharGfxData::_1::LayerPriority
        sta     near wCharGfxData::_2::LayerPriority
        sta     near wCharGfxData::_3::LayerPriority
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1926b:
last_hdma_set:
@926b:  ldx     #$0202      ; add bg2
        stx     $10
        lda     #$10        ; affect bg1
        jmp     SetColorMathHDMA

; ------------------------------------------------------------------------------

; [ change battle bg for final battle ]

_c19275:
last_scene_chg:
@9275:  stz     near w7e7b80
        inc     near w7eecb8       ; increment battle bg index
        lda     #$62
        sta     near w7e8972
        stz     near w7e201d
        stz     near w7e201e
        lda     near w7eecb8
        pha
        jsr     _c11bd1
        jsr     WaitFrame
        clr_ax
        stx     near w7e64b2
        inc     z97
@9297:  lda     #$08
        jsr     WaitA       ; wait 8 frames
        lda     near w7eecb8
        cmp     #$36
        bne     @92c4
        ldx     near w7e64b2
        cpx     #$ffe0
        bne     @92c4
        inc     near wSfxDisabled       ; disable sound effects
        lda     #$10
        sta     $1300
        lda     #SONG::DANCING_MAD_4
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        stz     near wSfxDisabled       ; enable sound effects
@92c4:  ldx     near w7e64b2
        dex
        stx     near w7e64b2
        cpx     #$ff68
        bne     @9297
        stz     near w7e64b0
        pla
        sta     near w7ee9df
        pha
        jsr     _c11bdf
        jsr     WaitFrame
        jsr     WaitLine160
        clr_ax
        stx     near w7e64b2
        jsr     WaitFrame
        pla
        jsr     _c11bdc
        jsr     WaitLine160
        lda     #$61
        sta     near w7e8972
        jsr     _c10076
        jsr     _c1926b
        clr_a
        jsr     _c1925e
        jsr     _c1920c
        lda     #$17                    ; enable all layers in main screen
        sta     near w7e8991
        sta     near w7e898d
        stz     near wPauseNotAllowed       ; allow pause
        stz     near w7e629a
        stz     near w7e6285
        stz     near w7ee9ef       ; start battle time
        lda     near w7eecb8
        cmp     #BATTLE_BG::FINAL_BATTLE_4
        bne     @9328
        lda     near w7e2f44
        not_a
        sta     near w7ee9e6
        stz     near w7e6282
@9328:  rts

; ------------------------------------------------------------------------------

; [ graphics script command $12: change battle (also final battle scroll) ]

        array_label GFX_CMD, GFX_CMD::CHANGE_BATTLE
@9329:  ldy     #1
        lda     (z76),y
        bpl     @9337
        and     #$7f
        sta     (z76),y
        jsr     _c19275
@9337:  ldy     #2
        lda     near w7e201e
        sta     (z76),y
        iny
        lda     (z76),y
        pha
        clr_a
        sta     (z76),y
        jsl     DoMonsterEntryExit
        clr_ax
@934c:  stz     near w7e62c2,x
        stz     near w7e618b,x
        inx
        cpx     #$0006
        bne     @934c
        stz     near w7e201e
        stz     near w7e61ab
        stz     near w7e2f2f
        lda     #$ff
        sta     near w7e6191                 ; show all monsters
        jsr     _c10e86
        jsr     InitMonsterGfx
        jsr     LoadMonsterPal
        jsr     _c13e72
        jsr     InitMonsterPos
        jsr     WaitTfrMonsterGfx
        clr_a
        ldy     #2
        sta     (z76),y
        iny
        pla
        sta     (z76),y
        sta     near w7e2f2f
        sta     near w7e61ab
        pha
        ldy     #1
        lda     near w7e2f48
        and     #$0f
        sta     (z76),y
        jsl     DoMonsterEntryExit
        pla
        sta     near w7e201e
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $13: monster entry/exit ]

; b1: entry/exit type
; b2:
; b3:

        array_label GFX_CMD, GFX_CMD::MONSTER_ENTRY_EXIT
@939c:  ldy     #3
        lda     (z76),y
        beq     @93d0       ; branch if only current monster is affected
        sta     $10
        clr_ax
@93a7:  lsr     $10
        bcc     @93b1       ; branch if monster is not affected
        stz     near w7e62c2,x     ;
        stz     near w7e618b,x     ;
@93b1:  inx                 ; next monster
        cpx     #6
        bne     @93a7
        ldy     #1
        lda     (z76),y
        cmp     #$0e
        beq     @93cb       ; branch if entry/exit type $0e (chadarnook)
        lda     near wMagitekModeEnabled
        bne     @93cb
        jsr     InitMonsterGfx
        jsr     WaitTfrMonsterGfx
@93cb:  jsl     DoMonsterEntryExit
        rts
@93d0:  ldy     #2
        lda     near w7e201e
        and     near w7e61ab
        and     (z76),y     ; affected monsters
        beq     @93e1
        jsl     DoMonsterEntryExit
@93e1:  rts

; ------------------------------------------------------------------------------

; [ graphics script command: no effect ]

        array_label GFX_CMD, GFX_CMD::GFX_CMD_5
        array_label GFX_CMD, GFX_CMD::GFX_CMD_8
@93e2:  rts

; ------------------------------------------------------------------------------

; [ execute monster death animations ]

; called once per frame, also updates visible monsters and monster
; facing directions

MonsterDeathAnim:
@93e3:  lda     near w7e2f44                   ; invisible monsters
        not_a
        sta     near w7ee9e6
        lda     near w7e6282
        beq     @93f3
        stz     near w7ee9e6
@93f3:  lda     near w7e2f2f                   ; invert to get monsters that are dead
        not_a
        and     near w7e201e                   ; monsters that are visible
        and     near w7e61ab                 ; monsters that are shown
        jeq     @9492                   ; jump if no monsters died

; monster death animation
        pha                             ; A = monsters that are dying
        stz     near wHideBG1MonsterSprites
        jsr     WaitFrame
        jsr     ClearBG1Tiles
        jsr     ClearBG3TileBuf
        jsr     TfrBG3Tiles
        jsr     PushMonsterPalID
        clr_ax
@9418:  lda     f:MonsterDeathPal,x
        sta     near w7e7e00::_11,x
        inx
        cpx     #near w7e7e00::ITEM_SIZE
        bne     @9418
        lda     near wEnableFlashback
        beq     @9438                   ; branch if not in flashback mode
        ldx     #array_offset w7e7e00, 11
        stx     $18
        ldx     #array_offset w7e7e00, 12
        stx     $1a
        jsl     FilterColors
@9438:  ldx     #$0202                  ; add bg2
        stx     $10
        lda     #$10                    ; affect sprites
        jsr     SetColorMathHDMA
        pla
        sta     $10                     ; monsters that are dying
        sta     $12
        clr_ax
@9449:  lsr     $12
        bcc     @9461                   ; branch if this monster is not dying
        lda     near w7e80db,x               ; set palette to 3
        and     #$c1
        ora     #$06
        sta     near w7e80db,x
        lda     #$01
        sta     near w7e80db+1,x
        lda     near w7e80c3,x               ; $14 = x position
        sta     $14
@9461:  inx2                            ; next monster
        cpx     #12
        bne     @9449
        lda     $14
        sta     $10
        lda     #SFX::MONSTER_DEATH
        jsr     PlayAnimSfx
        lda     #$20                    ; animation takes 32 frames

; start of frame loop
@9473:  pha
        jsr     WaitFrame
        jsr     UpdateMonsterDeathPal
        pla
        dec                             ; next frame
        bne     @9473
        lda     near w7e2f2f                   ; monsters that are not dead
        sta     near w7e201e                   ; monsters shown
        clr_ax
        stx     $10
        jsr     SetColorMathHDMA
        jsr     PopMonsterPalID
        jsl     UpdateMonsterNames

; update visible monsters
@9492:  lda     near w7e201e                   ; monsters shown
        cmp     near w7e2f2f                   ; monsters that are not dead
        beq     @94a3
        lda     near w7e201e
        ora     near w7e2f2f                   ; monsters that are not dead
        sta     near w7e201e

; update monster facing directions (control)
@94a3:  clr_ax
        lda     near w7e2f53 + 1                   ; controlled targets (from battle module)
        sta     $10
@94aa:  lda     #$21
        sta     near w7e80db+1,x             ; set tile flags
        lda     $10
        and     #1
        sta     near w7e617e,x               ; monster h-flip
        lsr     $10
        inx2
        cpx     #12
        bne     @94aa
        rts

; ------------------------------------------------------------------------------

; [ update monster death palette ]

UpdateMonsterDeathPal:
@94c0:  clr_ay
        longa
        ldx     #16                     ; 16 colors
        lda     #$00e1                  ; subtract 1 (red, green, and blue)
        sta     $14
        sta     $16
        sta     $18
        jsr     InitColorMod
@94d3:  lda     near w7e7e00::_11,y
        jsr     DecColor
        sta     near w7e7e00::_11,y
        iny2                            ; next color
        dex
        bne     @94d3
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ copy color palettes ]

; creates a copy of the color palettes that can be used during animations

CopyPal:
@94e5:  clr_ax
@94e7:  lda     near w7e7e00,x
        sta     near w7e7c00,x
        inx
        cpx     #$0200
        bne     @94e7
        rts

; ------------------------------------------------------------------------------

; [ save monster sprite data ]

PushMonsterPalID:
@94f4:  clr_ax
@94f6:  lda     near w7e80db,x
        sta     near w7e810b,x
        inx
        cpx     #12
        bne     @94f6
        rts

; ------------------------------------------------------------------------------

; [ restore monster sprite data ]

PopMonsterPalID:
@9503:  clr_ax
@9505:  lda     near w7e810b,x
        sta     near w7e80db,x
        inx
        cpx     #12
        bne     @9505
        rts

; ------------------------------------------------------------------------------

; [ battle graphics command $04: execute battle graphics script ]

array_label BTL_GFX, BTL_GFX::GFX_SCRIPT
@9512:  jsr     CopyPal
        ldx     #near w7e2d6e      ; init pointer to battle script commands
        stx     z76
        ldx     #near w7e2c6e      ; init pointer to battle script data
        stx     z78
        stz     near w7e60ae       ; clear swdtech hit index
        stz     near w7e62a4       ; not doing run away animation
        lda     #$17
        sta     near w7e898d       ; set main screen designation ($212c)
        stz     near w7e7b3d       ;
        stz     near w7e62d0       ;
        stz     near w7e62d1       ;
@9533:  clr_ax
        stx     near w7e62a5       ;
        stx     near w7e62a5+2
        lda     (z76)       ; battle script command
        cmp     #$ff
        beq     @9553       ; branch if end of script
        jsr     ExecGfxCmd
        longa
        lda     z76         ; increment battle script command pointer
        clc
        adc     #w7e2d6e::ITEM_SIZE
        sta     z76
        shorta0
        bra     @9533       ; next command
@9553:  lda     near w7e628c       ; branch if seamless scripts are enabled
        bne     @9568
        .repeat 4
        jsl     array_item BTL_GFX, BTL_GFX::WAIT_FRAME   ; wait 4 frames
        .endrep
@9568:  rtl

; ------------------------------------------------------------------------------

; [ execute graphics script command ]

ExecGfxCmd:
@9569:  asl
        tax
        jmp     (near GfxCmdTbl,x)

; ------------------------------------------------------------------------------

; [ increment graphics command data pointer ]

NextGfxCmdData:
@956e:  longa
        lda     z78
        clc
        adc     #w7e2c6e::ITEM_SIZE
        sta     z78
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update character/monster order priority ]

UpdateDrawOrder:
sort_y_poi:
@957c:  lda     near wDrawOrderInvalid       ; return if draw order is invalid
        beq     @9582
        rts
@9582:  clr_ax
@9584:  lda     #$ff
        sta     near w7e80e7+1,x     ;
        inx2
        cpx     #12
        bne     @9584
        longa
        clr_axy
        stz     $10
@9597:  lda     near w7e8043,x     ; character y position (bottom)
        sta     near wTargetDrawOrderBuf::BottomY,y
        lda     $10
        sta     near wTargetDrawOrderBuf::TargetIndex,y
        inc     $10
        inx2
        iny4
        cpy     #array_offset wTargetDrawOrderBuf, 4
        bne     @9597
        clr_ax
@95b1:  lda     near w7e804b,x     ; monster y position (bottom)
        sta     near wTargetDrawOrderBuf::BottomY,y
        lda     $10
        sta     near wTargetDrawOrderBuf::TargetIndex,y     ; monster number
        inc     $10
        inx2
        iny4
        cpy     #near wTargetDrawOrderBuf::SIZE
        bne     @95b1

; sort draw order by bottom Y position
@95c9:  clr_ax
        stz     $10
@95cd:  lda     near wTargetDrawOrderBuf::_0::BottomY,x     ; compare y position to next character/monster
        cmp     near wTargetDrawOrderBuf::_1::BottomY,x
        beq     @95f5
        bcs     @95f5
        inc     $10
        lda     near wTargetDrawOrderBuf::_1::BottomY,x     ; shift all values (put characters/monster in order of bottom y position)
        pha
        lda     near wTargetDrawOrderBuf::_0::BottomY,x
        sta     near wTargetDrawOrderBuf::_1::BottomY,x
        pla
        sta     near wTargetDrawOrderBuf::_0::BottomY,x
        lda     near wTargetDrawOrderBuf::_1::TargetIndex,x
        pha
        lda     near wTargetDrawOrderBuf::_0::TargetIndex,x
        sta     near wTargetDrawOrderBuf::_1::TargetIndex,x
        pla
        sta     near wTargetDrawOrderBuf::_0::TargetIndex,x
@95f5:  inx4
        cpx     #array_offset wTargetDrawOrderBuf, 9
        bne     @95cd
        lda     $10
        bne     @95c9
        shorta0
        inc     near wDrawOrderInvalid       ; invalidate character/monster draw order
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $03: display damage numerals (multiple) ]

        array_label GFX_CMD, GFX_CMD::DMG_NUMERALS_MULTI
@9609:  jsr     _c1a5fa
@960c:  jsr     WaitFrame
        clr_ax
@9611:  ora     near w7e7b3f,x
        inx
        cpx     #10
        bne     @9611
        ora     near w7e631a
        ora     near w7e631a+1
        ora     near w7e631a+2
        ora     near w7e631a+3
        bne     @960c
        rts

; ------------------------------------------------------------------------------

; [  ]

InitMsgWindowHDMA:
up_window_color_hdma_set:
@9629:  clr_ax
        lda     #$e0
        sta     $10
        stz     $1a
@9631:  lda     #$02
        sta     near w7e8993+$21,x
        lda     #$81
        sta     near w7e8993+$22,x
        lda     $10
        sta     near w7e8993+$23,x
        inc     $1a
        lda     $1a
        cmp     #$02
        bne     @9652
        stz     $1a
        lda     $10
        cmp     #$ff
        beq     @9652
        inc     $10
@9652:  inx4
        cpx     #$0080
        bne     @9631
        jsr     _c19673
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1965f:
@965f:  clr_ax
        lda     #$e0
@9663:  sta     near w7e8993+3,x
        inx4
        cpx     #$00a0
        bne     @9663
        jsr     ResetSpritePriority
        rts

; ------------------------------------------------------------------------------

; [  ]

_c19673:
@9673:  lda     #$20
        sta     near wCharGfxData::_0::LayerPriority
        sta     near wCharGfxData::_1::LayerPriority
        sta     near wCharGfxData::_2::LayerPriority
        sta     near wCharGfxData::_3::LayerPriority
        clr_ax
        lda     #$21
@9685:  sta     near w7e80db+1,x
        inx2
        cpx     #$000c
        bne     @9685
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $07: increment battle script data pointer ]

; I don't think this is ever used

        array_label GFX_CMD, GFX_CMD::NEXT_SCRIPT_DATA
@9690:  jsr     NextGfxCmdData
        rts

; ------------------------------------------------------------------------------

; [ graphics script command: no effect ]

        array_label GFX_CMD, GFX_CMD::GFX_CMD_0
        array_label GFX_CMD, GFX_CMD::GFX_CMD_4
@9694:  rts

; ------------------------------------------------------------------------------

; [ init dialogue text ]

_c19695:
anim_window_put_big_init:
@9695:  lda     #$81
        sta     near w7ee9c3
        ldx     #$5800
        stx     near wLargeTextGfxVRAMAddr
        stz     near w7ee9c1
        stz     near w7ee9c2
        stz     near w7e62ac                 ; draw one dialogue letter per frame
        rts

; ------------------------------------------------------------------------------

; [ battle event command $11: open dialog window ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::OPEN_DLG
; good_anim_window_put_big_open:
@96aa:  jmp     OpenDlgWindow

; ------------------------------------------------------------------------------

; [ battle event command $10: close dialog window ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::CLOSE_DLG
; good_anim_window_put_big_close:
@96ad:  jsr     ReloadSmallFontGfx
        lda     #MENU_INPUT::DLG_CLOSE
        sta     near wMenuInput+1
        lda     #MENU_INPUT::NEXT_STATE
        sta     near wMenuInput
        jsr     WaitFrame
        stz     near w7e64d5
        rts

; ------------------------------------------------------------------------------

; [ battle event command $01: display long battle dialog ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::BATTLE_DLG
; good_anim_window_put_big:
@96c1:  jsr     InitDlgTextGfx
        jsr     ClearDlgTextTileBuf
        jsr     _c19695
        jsr     GetBattleDlgPtr
        jsr     DrawLargeText
        jsr     InitDlgTextGfx
        jsr     ClearDlgTextTileBuf
        shorti
        clr_ax
        longa
        lda     #$0100      ; nonzero dp
        pha
        pld
@96e1:  lda     <$0102,x
        sta     near wBG3ScrollData::_163::Vert,x
        lda     <$0106,x
        sta     near wBG3ScrollData::_164::Vert,x
        lda     <$010a,x
        sta     near wBG3ScrollData::_165::Vert,x
        lda     <$010e,x
        sta     near wBG3ScrollData::_166::Vert,x
        txa
        clc
        adc     #$0010
        tax
        cpx     #$c0
        bne     @96e1
        lda     #BTLGFX_ZP_START
        pha
        pld
        shorta
        longi
        jsr     WaitFrame
        rts

; ------------------------------------------------------------------------------

; [ battle event command $00: display short battle dialog ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::BATTLE_MSG
; good_anim_window_put_b:
@970c:  jsr     InitWideMsgWindow
        jsr     GetBattleDlgPtr
        stz     near w7e62ac                 ; draw one dialogue letter per frame
        jsr     _c1987a
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $0a: open dialogue window ]

        array_label GFX_CMD, GFX_CMD::OPEN_DLG_WINDOW
@9719:  jsr     OpenDlgWindow
        jsr     _c19695
        jsr     GetAttackMsgPtr
        jsr     DrawLargeText
        jmp     _c143cc

; ------------------------------------------------------------------------------

; [ graphics script command $11: monster special attack ]

        array_label GFX_CMD, GFX_CMD::MONSTER_SPECIAL
@9728:  lda     #WINDOW_BUF::NARROW_MSG
        jsr     InitMsgWindow
        jsr     TfrAttackNameTiles
        lda     #$7e
        sta     near w7e88d9
        ldx     #near w7e57d5
        stx     near w7e88d7
        lda     #^MonsterSpecialName
        sta     $12
        ldy     #1
        longa
        lda     (z76),y
.if LANG_EN
        asl                             ; multiply by 10
        sta     $10
        asl2
        clc
        adc     $10
.else
        asl3                            ; multiply by 8
.endif
        clc
        adc     #near MonsterSpecialName
        sta     $10
        shorta0
        tay
@9758:  lda     [$10],y
        cmp     #$ff
        beq     @9767
        sta     near w7e57d5,y
        iny
        cpy     #MONSTER_SPECIAL_NAME::ITEM_SIZE
        bne     @9758
@9767:  clr_a
        sta     near w7e57d5,y
        lda     #1
        sta     near w7e62ac                 ; draw big text immediately
        lda     near w7e898d
        pha
        lda     #$12
        sta     near w7e898d
        jsr     DrawLargeText
        jsr     _c19887
        jsr     TfrBG1Tiles
        pla
        sta     near w7e898d
        lda     #$20
        jsr     WaitA       ; wait 32 frames
        lda     #$12
        sta     near w7e898d
        jsr     _c19917
        jsr     WaitFrame
        lda     #$17
        sta     near w7e898d
        clr_ax
        stx     near wBG3ScrollData::Horz
        rts

; ------------------------------------------------------------------------------

; text escape code for each attack name type
; if the msb is set, use a special text loader at _c2bb11

; 0: attack
; 1: item
; 2: esper
; 3: ???
; 4: swdtech
; 5: command

_c197a1:
@97a1:  .byte   $0f,$0e,$80,$00,$81,$0c

; ------------------------------------------------------------------------------

; [ graphics script command $01: show attack name ]

; b1: attack name type (see w7e3412)
; b2: attack number
; b3: unused

        array_label GFX_CMD, GFX_CMD::ATTACK_NAME
@97a7:  ldy     #1
        lda     (z76),y     ;
        tax
        lda     f:_c197a1,x
        pha
        tax
        iny
        lda     (z76),y     ; attack number
        pha
        phx
        lda     #$12
        sta     near w7e898d       ; disable bg1 and bg3 on main screen
        lda     #WINDOW_BUF::NARROW_MSG
        jsr     InitMsgWindow
        jsr     TfrAttackNameTiles
        lda     #$7e
        sta     near w7e88d9
        ldx     #near w7e57d5
        stx     near w7e88d7
        plx
        txa
        sta     near w7e57d5                 ; escape code
        pla
        sta     near w7e57d5+1               ; attack index
        stz     near w7e57d5+2               ; null terminator
        pla
        bpl     @97e3
        jsl     _c2bb11
@97e3:  lda     #1
        sta     near w7e62ac                 ; draw big text immediately
        jsr     DrawLargeText
        jsr     _c19887
        jsr     TfrBG1Tiles
        lda     #$17
        sta     near w7e898d
        jsr     _c198a7
        lda     #$12
        sta     near w7e898d
        jsr     _c19917
        jsr     WaitFrame
        lda     #$17
        sta     near w7e898d
        clr_ax
        stx     near wBG3ScrollData::Horz
        rts

; ------------------------------------------------------------------------------

; [ init message (top of screen) ]

InitWideMsgWindow:
@980f:  lda     #WINDOW_BUF::WIDE_MSG
        jsr     InitMsgWindow
        jsr     TfrBG1Tiles
        jmp     TfrMsgTextTiles

; ------------------------------------------------------------------------------

; [ get pointer to battle dialogue ]

GetBattleDlgPtr:
@981a:  lda     #^BattleDlg
        sta     near w7e88d9
        ldy     #1
        lda     [z8f],y
        longa
        asl
        tax
        lda     f:BattleDlgPtrs,x
        sta     near w7e88d7
        inc     z8f
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $10: show monster dialogue ]

        array_label GFX_CMD, GFX_CMD::MONSTER_DLG
@9835:  jsr     InitWideMsgWindow
        lda     #^MonsterDlg
        sta     near w7e88d9
        ldy     #1
        longa
        lda     (z76),y
        asl
        tax
        lda     f:MonsterDlgPtrs,x
        sta     near w7e88d7
        shorta0
        stz     near w7e62ac                 ; draw one dialogue letter per frame
        bra     _c1987a

; ------------------------------------------------------------------------------

; [ graphics script command $02: show attack message ]

        array_label GFX_CMD, GFX_CMD::ATTACK_MSG
@9855:  lda     near w7e898d
        pha
        lda     #$12
        sta     near w7e898d
        jsr     InitWideMsgWindow
        jsr     GetAttackMsgPtr
        lda     #1
        sta     near w7e62ac                 ; draw big text immediately
        pla
        sta     near w7e898d
        jsr     DrawLargeText
        bra     _c19881

; ------------------------------------------------------------------------------

; wait duration for each battle message speed
MsgSpeedTbl:
@9872:  .byte   $20,$30,$40,$50,$60,$70,$80,$90

; ------------------------------------------------------------------------------

; [  ]

_c1987a:
anim_window_put_b_main:
@987a:  jsr     DrawLargeText
        jsr     _c19881
        rts

; ------------------------------------------------------------------------------

; [  ]

_c19881:
anim_window_put_b_main2:
@9881:  jsr     _c198a7
        jmp     _c19917

; ------------------------------------------------------------------------------

; [  ]

_c19887:
chg_center:
@9887:  lda     z7a
        longa
        sta     $10
        lda     #$0068
        sec
        sbc     $10
        lsr
        clc
        adc     #$0002
        sta     $10
        lda     near wBG3ScrollData::Horz
        sec
        sbc     $10
        sta     near wBG3ScrollData::Horz
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c198a7:
mess_wait:
@98a7:  lda     near w7ee9f5
        bne     @98c3
        lda     f:$001d4d
        lsr4
        and     #$07
        tax
        lda     f:MsgSpeedTbl,x
@98bb:  pha
        jsr     WaitFrame
        pla
        dec
        bne     @98bb
@98c3:  rts

; ------------------------------------------------------------------------------

; [ init window for messages (top of screen) ]

InitMsgWindow:
@98c4:  pha
        inc     near w7e629e
        stz     near wHideBG1MonsterSprites
        lda     #$01
        sta     near w7ee9c3
        ldy     #$5000
        sty     near wLargeTextGfxVRAMAddr
        jsr     WaitFrame
        jsr     ClearBG1Tiles
        jsr     WaitFrame
        jsr     TfrMsgWindowGfx
        lda     near w7e897d
        sta     near w7e607d
        jsr     InitMsgWindowHDMA
        jsr     WaitFrame
        jsr     ClearLargeTextGfxBuf
        ldy     #$5000
        sty     near wLargeTextGfxVRAMAddr
        jsr     TfrLargeTextGfx
        pla
        jmp     DrawMsgWindow

; ------------------------------------------------------------------------------

; [ get pointer to attack message ]

GetAttackMsgPtr:
@98fe:  lda     #^AttackMsg
        sta     near w7e88d9
        ldy     #1
        lda     (z76),y
        longa
        asl
        tax
        lda     f:AttackMsgPtrs,x
        sta     near w7e88d7
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c19917:
anim_window_rset:
@9917:  lda     near w7e629e
        beq     @994a
        lda     near w7e898d
        pha
        lda     #$12
        sta     near w7e898d
        jsr     ClearLargeTextTileBuf
        jsr     TfrTopWindowTextTiles
        jsr     ClearLargeTextGfxBuf
        ldy     #$5000
        sty     near wLargeTextGfxVRAMAddr
        jsr     TfrLargeTextGfx
        jsr     ClearBG1Tiles
        jsr     WaitFrame
        jsr     _c1965f
        lda     near w7e607d
        sta     near w7e897d
        pla
        sta     near w7e898d
@994a:  rts

; unused
@994b:  .byte   $ff

; ------------------------------------------------------------------------------

; [ clear dialogue text tilemap buffer ]

.proc ClearLargeTextTileBuf
        longa
        clr_ax
        lda     #$01ff
:       sta     near wLargeTextTileBuf,x
        inx2
        cpx     #wLargeTextTileBuf::SIZE
        bne     :-
        shorta0
        rts
.endproc  ; ClearLargeTextTileBuf

; ------------------------------------------------------------------------------

; [ draw and transfer attack name text tiles to vram ]

.proc TfrAttackNameTiles
        jsr     ClearLargeTextTileBuf
        longa
        clr_ax
        lda     #$3000
:       sta     near wLargeTextTileBuf+$12,x
        inc
        sta     near wLargeTextTileBuf+$52,x
        inc
        inx2
        cpx     #$002c
        bne     :-
        shorta0
        jmp     TfrTopWindowTextTiles
.endproc  ; TfrAttackNameTiles

; ------------------------------------------------------------------------------

; [ draw and transfer wide message tiles to vram ]

.proc TfrMsgTextTiles
        jsr     ClearLargeTextTileBuf
        longa
        clr_ax
        lda     #$3000
.if ::LANG_EN
:       sta     near wLargeTextTileBuf+$04,x
        inc
        sta     near wLargeTextTileBuf+$44,x
        inc
        inx2
        cpx     #$0038
.else
:       sta     near wLargeTextTileBuf+$06,x
        inc
        sta     near wLargeTextTileBuf+$46,x
        inc
        inx2
        cpx     #$0034
.endif
        bne     :-
        shorta0

::TfrTopWindowTextTiles:
        ldx     #wLargeTextTileBuf::SIZE
        stx     $10
        ldx     #near wLargeTextTileBuf
        lda     #^wLargeTextTileBuf
        ldy     #$5440                  ; message window text tiles (vram)
        jsr     WaitTfrVRAM
.endproc  ; TfrMsgTextTiles

; ------------------------------------------------------------------------------

; [  ]

LoadDlgFontPal:
@99ac:  ldx     #$0000
        stx     near w7e7e00::_1::Color1             ; text shadow (black)
        ldx     #$001f
        stx     near w7e7e00::_1::Color2             ; alt. text color (red)
        ldx     $1d55
        stx     near w7e7e00::_1::Color3             ; player-defined text color
        jmp     FilterBG3AnimPal

; ------------------------------------------------------------------------------

; step back counter (normal and magitek mode)
_c199c1:
; wark_counter_tbl:
@99c1:  .byte   $08,$18

; ------------------------------------------------------------------------------

; [ graphics script command $0d: step back after attack animation ]

        array_label GFX_CMD, GFX_CMD::STEP_BACK
; magic_back:
@99c3:  clr_ax
        stx     near w7e618b                 ; re-enable monster flash for all monsters
        stx     near w7e618b+2
        stx     near w7e618b+4
        tay
@99cf:  lda     near w7e61ae,x
        beq     @99e4
        lda     near w7e7b10,x
        cmp     near w7e61b2,x
        bne     @99e4
        lda     near wCharGfxData::Flip,y
        eor     #$40
        sta     near wCharGfxData::Flip,y
@99e4:  tya
        clc
        adc     #$20
        tay
        inx
        cpx     #4
        bne     @99cf
        lda     near wMagitekModeEnabled
        tax
        lda     f:_c199c1,x
        sta     near w7e7af1
@99fa:  jsr     WaitFrame
        clr_ay
@99ff:  lda     near w7e61ae,y
        beq     @9a4b
        tya
        asl5
        tax
        phy
        lda     near wMagitekModeEnabled
        bne     @9a20
        lda     near w7e61b2,y
        beq     @9a1b
        ldy     #$fffd
        bra     @9a1e
@9a1b:  ldy     #$0003
@9a1e:  bra     @9a32
@9a20:  lda     #$01
        sta     near wMagitekAnimType,y     ; magitek animation type 1 (walking)
        lda     near w7e61b2,y
        beq     @9a2f
        ldy     #$ffff
        bra     @9a32
@9a2f:  ldy     #$0001
@9a32:  sty     $10
        stz     near wCharGfxData::AnimFrame,x
        lda     #CHAR_ACTION::WALKING_FORWARD
        sta     near wCharGfxData::AnimAction,x
        longa
        lda     near wCharGfxData::AnimOffsetX,x
        clc
        adc     $10
        sta     near wCharGfxData::AnimOffsetX,x
        shorta0
        ply
@9a4b:  iny
        cpy     #4
        bne     @99ff
        dec     near w7e7af1
        bne     @99fa
        clr_axy
@9a59:  lda     near w7e61ae,x
        beq     @9a7c
        stz     near wMagitekAnimType,x     ; magitek animation type 0 (standing still)
        lda     near w7e7b10,x
        cmp     near w7e61b2,x
        bne     @9a71
        lda     near wCharGfxData::Flip,y
        eor     #$40
        sta     near wCharGfxData::Flip,y
@9a71:  stz     near w7e61ae,x               ; disable stepping forward/back
        clr_a
        sta     near wCharGfxData::AnimAction,y
        dec
        sta     near w7e61b2,x
@9a7c:  clr_a
        sta     near wCharGfxData::DisableFloatOffset,y
        tya
        clc
        adc     #$20
        tay
        stz     near w7e62a0,x
        inx
        cpx     #4
        bne     @9a59
        rts

; ------------------------------------------------------------------------------

; [  ]

ToggleCharFlip:
@9a8f:  asl5
        tax
        lda     near wCharGfxData::Flip,x
        eor     #$40
        sta     near wCharGfxData::Flip,x
        rts

; ------------------------------------------------------------------------------

; [ get attacker number (long access) ]

GetAttackerNum_far:
@9a9e:  jsr     GetAttackerNum
        rtl

; ------------------------------------------------------------------------------

; [  ]

_c19aa2:
magic_front:
@9aa2:  jsr     InitSimpleAnim
        jsr     GetTargetNum
        jsr     GetAttackerNum
        lda     $10
        bmi     @9b25       ; branch if monster

; character attacker
        and     #$03
        tay
        asl5
        tax
        lda     near wAnimCharTargets
        ora     near wAnimMonsterTargets
        beq     @9b19
        lda     near w7e62a4
        bne     @9b19                   ; branch if doing run away animation
        inc
        sta     near w7e62a0,y
        sta     near wCharGfxData::DisableFloatOffset,x
        lda     $12
        bpl     @9b19
        and     #$7f
        sec
        sbc     #$04
        asl
        tax
        lda     $10
        asl
        tay
        longa
        lda     near w7e8033,y
        and     #$01ff
        sta     $24
        lda     near w7e800f,x
        and     #$01ff
        sta     $22
        shorta0
        lda     $10
        tay
        lda     near w7e7b10,y
        beq     @9b09
        ldx     $24
        cpx     $22
        bcc     @9b19
        clr_a
        sta     near w7e7b10,y
        lda     $10
        jsr     ToggleCharFlip
        bra     @9b19
@9b09:  ldx     $22
        cpx     $24
        bcc     @9b19
        lda     #$01
        sta     near w7e7b10,y
        lda     $10
        jsr     ToggleCharFlip
@9b19:  lda     near w7e61ae,y
        bne     @9b24
        lda     near w7e7b10,y
        sta     near w7e61b2,y
@9b24:  rts

; monster attacker
@9b25:  lda     $10
        and     #$7f
        sec
        sbc     #$04
        asl
        tax
        lda     near wAnimCharTargets
        ora     near wAnimMonsterTargets
        beq     @9b6a
        lda     $12
        bmi     @9b6a
        and     #$03
        asl
        tay
        longa
        lda     near w7e8033,y
        sta     $24
        lda     near w7e800f,x
        sta     $22
        shorta0
        lda     near w7e80f3,x
        and     #$01
        beq     @9b5c
        ldy     $24
        cpy     $22
        bcc     @9b6a
        bra     @9b62
@9b5c:  ldy     $22
        cpy     $24
        bcc     @9b6a
@9b62:  lda     near w7e80f3,x
        eor     #$01
        sta     near w7e80f3,x

; flash active monster before action
@9b6a:  txa
        lsr
        tax
        lda     near w7e618b,x
        bne     @9ba0
        inc     near w7e618b,x
        jsr     LoadActiveMonsterFlashPal
        ldy     #1
        lda     (z78),y
        and     #$7f
        sec
        sbc     #$04
        asl
        tax
        lda     near w7e80db,x
        sta     near w7e7af0
        lda     #$06                    ; flash monster (use sprite palette 3)
        jsr     FlashActiveMonster
        lda     near w7e7af0
        jsr     FlashActiveMonster
        lda     #$06
        jsr     FlashActiveMonster
        lda     near w7e7af0
        jsr     FlashActiveMonster
@9ba0:  rts

; ------------------------------------------------------------------------------

; [ set palette for active monster flash ]

FlashActiveMonster:
        sta     $10
        lda     near w7e80db,x
        and     #$f1
        ora     $10
        sta     near w7e80db,x
        lda     #4
        jmp     WaitA       ; wait 4 frames

; ------------------------------------------------------------------------------

; [ wait frames (long access) ]

WaitA_far:
@9bb2:  jsr     WaitA       ; wait frames
        rtl

; ------------------------------------------------------------------------------

; [ wait frames ]

; A: number of frames to wait

WaitA:
@9bb6:  cmp     #0
        beq     @9bc4
        pha
        phx
        jsr     WaitFrame
        plx
        pla
        dec
        bne     @9bb6
@9bc4:  rts

; ------------------------------------------------------------------------------

; [ load color palette for monster flash before action ]

LoadActiveMonsterFlashPal:
        clr_ax
@9bc7:  stz     near w7e7e00::_11,x          ; all colors are black
        inx
        cpx     #w7e7e00::ITEM_SIZE
        bne     @9bc7
        ldx     #$ffff                  ; should really be $7fff
        stx     near w7e7e00::_11::Color1    ; except color 1 is white
        rts

; ------------------------------------------------------------------------------

; [ load animation palette (sprite) ]

LoadSpriteAnimPal:
@9bd7:  longa
        asl4
        tax
        clr_ay
@9be0:  lda     f:AttackPal,x
        sta     near w7e7e00::_11,y
        sta     near w7e7c00::_11,y
        sta     near w7e7e00::_11::Color8,y
        sta     near w7e7c00::_11::Color8,y
        inx2
        iny2
        cpy     #$0010
        bne     @9be0
        shorta0
        lda     near wEnableFlashback
        beq     @9c0f       ; return if flashback mode is disabled
        ldx     #array_offset w7e7e00, 11
        stx     $18
        ldx     #array_offset w7e7e00, 12
        stx     $1a
        jsl     FilterColors
@9c0f:  rts

; ------------------------------------------------------------------------------

; [ load block palette ]

; A: block type

LoadBlockPal:
@9c10:  asl4
        tax
        clr_ay
@9c17:  lda     f:BlockPal,x
        sta     near w7e7e00::_11::Color8,y
        iny
        inx
        cpy     #$0010
        bne     @9c17
        rts

; ------------------------------------------------------------------------------

; [ load animation palette (bg1) ]

LoadBG1AnimPal:
@9c26:  longa
        asl4
        tax
        clr_ay
@9c2f:  lda     f:AttackPal,x
        .repeat 4, i
        sta     near w7e7e00::_3 + i * 16,y        ; copy to ram
        .endrep
        .repeat 4, i
        sta     near w7e7c00::_3 + i * 16,y        ; copy to ram
        .endrep
        inx2
        iny2
        cpy     #$0010
        bne     @9c2f
        shorta0
        lda     near wEnableFlashback       ; return if flashback mode is disabled
        beq     @9c6a
        ldx     #array_offset w7e7e00, 3
        stx     $18
        ldx     #array_offset w7e7e00, 4
        stx     $1a
        jsl     FilterColors
@9c6a:  rts

; ------------------------------------------------------------------------------

; [ load animation palette (bg3) ]

LoadBG3AnimPal:
@9c6b:  longa
        asl4
        tax
        clr_ay
@9c74:  lda     f:AttackPal,x
        sta     near w7e7e00::_1,y
        sta     near w7e7c00::_1,y
        inx2
        iny2
        cpy     #8                      ; load 4 colors
        bne     @9c74
        shorta0
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

FilterBG3AnimPal:
@9c8a:  lda     near wEnableFlashback
        beq     @9c9d       ; return if flashback mode is disabled
        ldx     #array_member_offset w7e7e00, 1, Color0
        stx     $18
        ldx     #array_member_offset w7e7e00, 1, Color4
        stx     $1a
        jsl     FilterColors
@9c9d:  rts

; ------------------------------------------------------------------------------

; [ deactivate all animation threads ]

; clears all animation thread data

ClearThreadData:
        clr_ax
:       sta     near wAnimThread::BLOCK_1,x
        sta     near wAnimThread::BLOCK_2,x
        sta     near wAnimThread::BLOCK_3,x
        sta     near wAnimThread::BLOCK_0,x
        inx
        cpx     #wAnimThread::COUNT * wAnimThread::BLOCK_SIZE
        bne     :-
        rts

; ------------------------------------------------------------------------------

; [ init battle animation properties ]

; +$1e: pointer to attack animation properties (+$d07fb2)
;    A: attack number

LoadAnimProp:
@9cb3:  sta     near w7e626a       ; set attack number
        xba
        lda     #14
        jsr     MultAB
        longa
        lda     f:hRDMPYL
        clc
        adc     $1e         ; add to animation data pointer
        tax
        clr_ay
        shorta
@9cca:  lda     f:AttackAnimProp,x
        sta     near w7e6273,y
        inx
        iny
        cpy     #14
        bne     @9cca
        lda     near w7e627c       ; default sound effect
        sta     near w7ee9e7
        jsr     ClearThreadData
        ldx     near w7e6273       ; sprite graphics
        cpx     #$ffff
        beq     @9d00       ; branch if unused
        jsr     LoadAnimGfxProp
        ldx     near w7e7aee       ; copy frame height/width
        stx     near w7e7b35
        ldx     near w7e7aea       ; graphics index
        lda     near w7e60ae       ; branch if not first swdtech hit (graphics are already loaded)
        bne     @9cfd
        jsr     LoadSpriteAnimGfx
@9cfd:  jsr     InitSpriteAnimFrames
@9d00:  jsr     _c19917
        ldx     near w7e6275       ; bg1 graphics
        cpx     #$ffff
        beq     @9d48       ; branch if unused
        jsr     LoadAnimGfxProp
        ldx     near w7e7aee       ; copy frame height/width
        stx     near w7e7b31
        ldx     near w7e7aea       ; graphics index
        lda     near w7e60ae       ; branch if not first swdtech hit (graphics are already loaded)
        bne     @9d1f
        jsr     LoadBG1AnimGfx
@9d1f:  ldx     near w7e6275       ; bg1 script number
        cpx     #$0225
        beq     @9d36       ; branch if script $0225, $003c, $0216
        cpx     #$003c
        beq     @9d36
        cpx     #$0216
        beq     @9d36
        cpx     #$003b
        bne     @9d3d       ; branch if $003b (copy attacker sprite to bg1)
@9d36:  jsr     TargetGfxToBG1
        lda     #$2e        ; tile offset = $2e
        bra     @9d42
@9d3d:  jsr     AttackerGfxToBG1
        lda     #$2c        ; tile offset = $2c
@9d42:  jsr     LoadBG1AnimFrames
        jsr     InitBG1AnimPos
@9d48:  ldx     near w7e6277       ; bg3 graphics
        cpx     #$ffff
        beq     @9d6a       ; branch if unused
        jsr     LoadAnimGfxProp
        ldx     near w7e7aee       ; copy frame height/width
        stx     near w7e7b33
        ldx     near w7e7aea
        lda     near w7e60ae
        bne     @9d64       ; branch if not first swdtech hit (graphics are already loaded)
        jsr     LoadBG3AnimGfx
@9d64:  jsr     LoadBG3AnimFrames
        jsr     _c19e80
@9d6a:  ldx     near w7e627e       ; special graphics
        cpx     #$ffff
        beq     @9d7b       ; branch if unused
        jsr     LoadAnimGfxProp
        ldx     near w7e7aee       ; copy frame height/width
        stx     near w7e7b37
@9d7b:  jsr     _c1a0ac
        lda     near w7e6279       ; sprite palette
        jsr     LoadSpriteAnimPal
        clr_a
        lda     near w7e627a       ; bg1 palette
        sta     near w7e6167
        lda     near w7e627b       ; bg3 palette
        jsr     LoadBG3AnimPal
        jsr     CheckBlock
        rts

; ------------------------------------------------------------------------------

; [ init weapon or monster attack animation data ]

; A: weapon animation number (item index, $5b/$5c for longer atma weapon graphics)

InitWeaponAnim:
@9d95:  sta     near w7e626a       ; weapon animation number
        longa
        asl3
        tax
        clr_ay
        shorta0
        lda     near wIsMonsterAttackAnim       ; branch if not a monster attack
        beq     @9db8

; monster attack animation
@9da8:  lda     f:MonsterAttackAnimProp,x   ; monster attack animation data
        sta     near w7e626b,y
        inx
        iny
        cpy     #8
        bne     @9da8
        bra     @9dc6

; weapon animation
@9db8:  lda     f:WeaponAnimProp,x
        sta     near w7e626b,y
        inx
        iny
        cpy     #8
        bne     @9db8

@9dc6:  lda     $10         ; attacker
        and     #$03            ;
        tax
        lda     near w7e7af4       ; left-hand flag
        asl
        rol
        and     #1
        eor     near w7e7b10,x       ; invert if facing right
        and     #1
        tax
        lda     near w7e626b,x     ; weapon animation script (right or left hand)
        tax
        jsr     LoadAnimGfxProp
        ldy     near w7e7aee       ; frame height/width (for weapon graphics)
        sty     near w7e7b2d
        ldx     near w7e7aea       ; weapon tile formation index
        jsr     LoadWeaponGfx
        jsr     InitSpriteAnimFrames
        lda     near wIsMonsterAttackAnim       ; branch if not monster attack
        beq     @9e06
        lda     near w7e626e       ; hit animation script
        cmp     #$60
        bcc     @9e06       ; branch if less than $60
        longa
        clc
        adc     #$0200
        tax
        shorta0
        bra     @9e0a
@9e06:  lda     near w7e626e       ; hit animation script
        tax
@9e0a:  jsr     LoadAnimGfxProp
        ldy     near w7e7aee       ; frame height/width (for hit graphics)
        sty     near w7e7b2f
        sty     near w7e7b31
        ldx     near w7e7aea       ; hit tile formation index
        jsr     LoadBG1AnimGfx
        jsr     AttackerGfxToBG1
        lda     #$2c
        jsr     LoadBG1AnimFrames
        jsr     InitBG1AnimPos
        lda     near w7e626d       ; weapon palette
        jsr     LoadSpriteAnimPal
        lda     near w7e626f       ; hit palette
        sta     near w7e6167       ; animation bg1 palette
        jsr     _c1a04b
        jsr     CheckBlock
        rts

.pushseg

        ; .include "src/data/weapon_anim_prop.asm"
        ; .incbin "assets/data/btlgfx/weapon_anim_prop.bin", 24

; .segment "weapon_anim_prop"

; ec/e400
; WeaponAnimProp:
;         .incbin "assets/data/btlgfx/weapon_anim_prop.bin"


; .segment "monster_attack_anim_prop"

; ; ec/e6e8
; MonsterAttackAnimProp:
;         .incbin "assets/data/btlgfx/monster_attack_anim_prop.bin"

.popseg

; ------------------------------------------------------------------------------

; [ init bg1 animation scroll position ]

InitBG1AnimPos:
@9e3a:  lda     $28         ;
        beq     @9e65

; flipped horizontally
        lda     near w7e7b31       ; bg1 animation frame width
        longa
        asl3
        sta     near w7e7b16       ; bg1 animation x offset = $0100 - frame width
        lda     #$0100
        sec
        sbc     near w7e7b16
        sta     near w7e7b16
        lda     near w7e7b31+1       ; bg1 animation frame height
        and     #$00ff
        asl3
        sta     near w7e7b18       ; bg1 animation y offset = frame height
        shorta0
        jmp     @9e7f

; not flipped horizontally
@9e65:  lda     near w7e7b31       ; bg1 animation frame width
        longa
        asl3
        sta     near w7e7b16       ; bg1 animation x offset = frame width
        lda     near w7e7b31+1      ; bg1 animation frame height
        and     #$00ff
        asl3
        sta     near w7e7b18       ; bg1 animation y offset = frame height
        shorta0
@9e7f:  rts

; ------------------------------------------------------------------------------

; [  ]

_c19e80:
@9e80:  lda     $28
        beq     @9eab

; flipped horizontally
        lda     near w7e7b33
        longa
        asl3
        sta     near w7e7b22
        lda     #$0100
        sec
        sbc     near w7e7b22
        sta     near w7e7b22
        lda     near w7e7b33+1
        and     #$00ff
        asl3
        sta     near w7e7b24
        shorta0
        jmp     @9ec5

; not flipped horizontally
@9eab:  lda     near w7e7b33
        longa
        asl3
        sta     near w7e7b22
        lda     near w7e7b33+1
        and     #$00ff
        asl3
        sta     near w7e7b24
        shorta0
@9ec5:  rts

; ------------------------------------------------------------------------------

; [ clear animation tile data buffer (long access) ]

ClearBGAnimFrames_far:
@9ec6:  jsr     ClearBGAnimFrames
        rtl

; ------------------------------------------------------------------------------

; [ clear animation tile data buffer ]

ClearBGAnimFrames:
@9eca:  phb
        lda     #$7f
        pha
        plb
        longa
        clr_ax
        lda     #$02ee
@9ed6:  sta     $c400,x
        sta     $cc00,x
        sta     $d400,x
        sta     $dc00,x
        inx2
        cpx     #$0800
        bne     @9ed6
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [ clear animation graphics buffer ]

ClearAnimGfxBuf:
@9eee:  phb
        lda     #$7f
        pha
        plb
        longa
        clr_ax
        lda     #$01ee
@9efa:  sta     $e400,x
        sta     $e900,x
        sta     $ee00,x
        sta     $f300,x
        inx2
        cpx     #$0500
        bne     @9efa
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [ copy target graphics to bg1 ]

TargetGfxToBG1:
@9f12:  jsr     GetAttackerNum
        jsr     GetTargetNum
        lda     $12
        bra     _9f21

; ------------------------------------------------------------------------------

; [ copy attacker graphics to bg1 ]

AttackerGfxToBG1:
@9f1c:  jsr     GetAttackerNum
        lda     $10
_9f21:  bmi     @9f37       ; branch if a monster
        tax
        lda     near w7e7b10,x     ; character facing direction
        beq     @9f32
@9f29:  lda     #$10            ; offset for x-position table (flipped)
        sta     $28
        lda     #$40
        sta     $29
        rts
@9f32:  stz     $28             ; offset for x-position table (not flipped)
        stz     $29
        rts
@9f37:  and     #$7f        ; monster number
        sec
        sbc     #$04
        asl
        tax
        lda     near w7e80f3,x     ; monster facing direction
        eor     near w7e617e,x
        and     #$01
        beq     @9f29
        bra     @9f32

; ------------------------------------------------------------------------------

; [ load bg3 animation frame data ]

LoadBG3AnimFrames:
@9f4a:  jsr     AttackerGfxToBG1
        jsr     ClearAnimGfxBuf
        lda     #^AttackAnimFrames
        sta     $12
        lda     #$7f
        sta     $16
        lda     #$30
        sta     $2a
        ldx     #$e400
        bra     LoadBGAnimFrames

; ------------------------------------------------------------------------------

; [ load bg1 animation frame data ]

LoadBG1AnimFrames:
@9f61:  pha
        jsr     ClearBGAnimFrames
        lda     #^AttackAnimFrames
        sta     $12
        lda     #$7f
        sta     $16
        pla
        sta     $2a
        ldx     #$c400
; fallthrough

; ------------------------------------------------------------------------------

; [ load bg1 or bg3 animation frame data ]

; +X: destination for tiles

LoadBGAnimFrames:
        stx     $14
        lda     near w7e7aea       ; number of frames
        and     #$3f
        sta     near w7e7aea

@FrameLoop:
@9f7d:  longa
        lda     near w7e7aec       ; animation frame data index
        asl
        tax
        lda     f:AttackAnimFramesPtrs,x
        sta     $10
        lda     f:AttackAnimFramesPtrs+2,x
        sta     $1a
        shorta0
        tay

@TileLoop:
@9f94:  ldx     $10
        cpx     $1a
        beq     @9ffa
        lda     [$10]
        cmp     #$ff
        beq     @9feb

; get tile x position
@9fa0:  and     #$f0
        lsr4
        clc
        adc     $28
        tax
        lda     f:BGAnimFrameTileXTbl,x
        sta     $22
        stz     $23

; get tile y position
        lda     [$10]
        and     #$0f
        longa
        asl5
        clc
        adc     $22
        tay

; get tile index
        inc     $10
        shorta0
        lda     [$10]
        and     #$07
        asl
        sta     $24
        lda     [$10]
        and     #$38
        asl2
        clc
        adc     $24
        sta     [$14],y         ; set tile index
        iny
        lda     [$10]           ; tile flags
        and     #$c0
        eor     $29             ; flipped because layer is flipped
        ora     $2a             ; palette, priority, msb of tile index
        sta     [$14],y
        ldx     $10
        inx
        stx     $10
        jmp     @TileLoop

; check for frame terminator (two FF in a row)
@9feb:  phy
        ldy     #1
        lda     [$10],y
        ply
        cmp     #$ff
        beq     @9ffa
        lda     #$ff
        bra     @9fa0

; done with frame
@9ffa:  longa
        lda     $14
        clc
        adc     #$0200
        sta     $14
        inc     near w7e7aec
        shorta0
        dec     near w7e7aea
        beq     @a012
        jmp     @FrameLoop
@a012:  rts

; ------------------------------------------------------------------------------

BGAnimFrameTileXTbl:
        .repeat 16, i                   ; not flipped
        .byte i * 2
        .endrep
        .repeat 16, i                   ; flipped horizontally
        .byte 30 - i * 2
        .endrep

; ------------------------------------------------------------------------------

; [ clear sprite animation frame data ]

ClearSpriteAnimFrameBuf:
@a033:  longa
        clr_ax
        lda     #$ffff
@a03a:  sta     near w7ece3f,x     ; clear all sprite animation frames
        sta     near w7ed8bf,x
        inx2
        cpx     #$0a80
        bne     @a03a
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load sprite frame data (fight) ]

; maybe this loads frames for the shield ???

InitBlockAnimFrames:
_c1a04b:
attack_def_init:
@a04b:  lda     #1
@a04d:  jsr     _c1a080
        inc
        cmp     #$07
        bne     @a04d
        rts

; ------------------------------------------------------------------------------

; fight/esper sprite frame pointers (frame $1d, $18, $19, $1a, $1b, $1c, $1e)
; graphics data id, destination address, destination address (flipped)
_c1a056:
@a056:  .addr   $0042, w7ece3f + 29 * 21 * 4, w7ed8bf + 29 * 21 * 4
        .addr   $0043, w7ece3f + 24 * 21 * 4, w7ed8bf + 24 * 21 * 4
        .addr   $0044, w7ece3f + 25 * 21 * 4, w7ed8bf + 25 * 21 * 4
        .addr   $0045, w7ece3f + 26 * 21 * 4, w7ed8bf + 26 * 21 * 4
        .addr   $0046, w7ece3f + 27 * 21 * 4, w7ed8bf + 27 * 21 * 4
        .addr   $0047, w7ece3f + 28 * 21 * 4, w7ed8bf + 28 * 21 * 4
        .addr   $0048, w7ece3f + 30 * 21 * 4, w7ed8bf + 30 * 21 * 4

; ------------------------------------------------------------------------------

; [ load sprite frame data (fight/esper) ]

InitCommonAnimFrames:
_c1a080:
magic_sp_init:
@a080:  pha
        asl
        sta     $12
        asl
        clc
        adc     $12
        tax
        longa
        lda     f:_c1a056,x
        pha
        lda     f:_c1a056+2,x
        sta     $14
        lda     f:_c1a056+4,x
        sta     $1c
        plx
        shorta0
        jsr     LoadAnimGfxProp
        lda     #^AttackAnimFrames
        sta     $12
        jsr     LoadSpriteAnimFrames
        pla
        rts

; ------------------------------------------------------------------------------

; [ load sprite frame data (extra thread) ]

_c1a0ac:
ref_init:
@a0ac:  clr_a
        jsr     _c1a080
        lda     #6
        jmp     _c1a080

; ------------------------------------------------------------------------------

; [ load sprite frame data (spell/weapon) ]

InitSpriteAnimFrames:
@a0b5:  jsr     ClearSpriteAnimFrameBuf
        lda     #^AttackAnimFrames
        sta     $12
        ldx     #near w7ece3f
        stx     $14
        ldx     #near w7ed8bf
        stx     $1c
; fall through

; ------------------------------------------------------------------------------

; [ load sprite frame data ]

;  $12: frame data bank
; +$14: destination address (+$7e0000)
; +$1c: horizontally flipped destination address (+$7e0000)

LoadSpriteAnimFrames:
obj_shape_init_main:
@a0c6:  lda     near w7e7aea       ; number of frames
        and     #$3f
        sta     near w7e7aea
        lda     near w7e7aee       ; $18 = frame width
        asl3
        sta     $18
        lda     near w7e7aef       ; $19 = frame height
        asl3
        sta     $19
@a0de:  longa
        lda     near w7e7aec       ; frame data index
        asl
        tax
        lda     f:AttackAnimFramesPtrs,x
        sta     $10
        lda     f:AttackAnimFramesPtrs+2,x
        sta     $1a
        shorta0
        tay
@a0f5:  ldx     $10
        cpx     $1a
        beq     @a164       ; branch if at end of data (beginning of next frame)
        lda     [$10]
        cmp     #$ff
        beq     @a155       ; branch if at end of data ($ff)
@a101:  and     #$f0
        sta     $22         ; $22 = x position
        sec
        sbc     $18
        sta     ($14),y     ; set x position
        lda     $22
        neg_a
        sec
        sbc     #$10
        clc
        adc     $18
        sta     ($1c),y     ; set x position (horizontally flipped)
        iny
        lda     [$10]       ; y position
        and     #$0f
        asl4
        sec
        sbc     $19
        sta     ($14),y     ; set y position
        sta     ($1c),y     ; set y position (horizontally flipped)
        iny
        ldx     $10         ; increment frame data pointer
        inx
        stx     $10
        lda     [$10]       ; tile number
        and     #$07
        asl
        sta     $16
        lda     [$10]
        and     #$38
        asl2
        clc
        adc     $16
        sta     ($14),y     ; set tile number
        sta     ($1c),y     ; set tile number (horizontally flipped)
        iny
        lda     [$10]       ; vh flip
        and     #$c0
        sta     ($14),y     ; set vh flip
        eor     #$40
        sta     ($1c),y     ; set vh flip (horizontally flipped)
        iny                 ; next tile
        ldx     $10
        inx
        stx     $10
        jmp     @a0f5
@a155:  phy
        ldy     #1
        lda     [$10],y     ; get next byte of frame data
        ply
        cmp     #$ff
        beq     @a164       ; end of frame if it's $ff
        lda     #$ff
        bra     @a101       ; if not, it's actually a tile at (15,15)
@a164:  lda     #$ff        ; end of frame
        sta     ($14),y
        sta     ($1c),y
        longa
        lda     $14         ; increment ram frame data pointers
        clc
        adc     #$0054
        sta     $14
        lda     $1c
        clc
        adc     #$0054
        sta     $1c
        inc     near w7e7aec       ; increment frame data index
        shorta0
        dec     near w7e7aea       ; decrement frame counter
        beq     @a18a
        jmp     @a0de
@a18a:  rts

; ------------------------------------------------------------------------------

; [ load animation graphics properties ]

LoadAnimGfxProp:
@a18b:  longa
        txa
        and     #$7fff
        asl
        sta     near w7e7aea                   ; multiply by 6
        asl
        clc
        adc     near w7e7aea
        tax
        clr_ay
@a19d:  lda     f:AttackGfxProp,x
        sta     near w7e7aea,y
        inx2
        iny2
        cpy     #6
        bne     @a19d
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load sprite animation graphics ]

LoadSpriteAnimGfx:
@a1b1:  stx     $10
        ldx     #$0080                  ; load 4 rows of 16x16 tiles
        stx     $16
        ldx     #$2400                  ; -> vram $2400-$2BFF
        stx     $1a
        jmp     LoadAnimGfx

; ------------------------------------------------------------------------------

; [ load weapon animation graphics ]

; note: block graphics are loaded to vram $2400-$25FF

LoadWeaponGfx:
@a1c0:  stx     $10
        ldx     #$0060                  ; load 3 rows of 16x16 tiles
        stx     $16
        ldx     #$2600                  ; -> vram $2600-$2BFF
        stx     $1a
        jmp     LoadAnimGfx

; ------------------------------------------------------------------------------

; [ load bg3 animation graphics ]

LoadBG3AnimGfx:
@a1cf:  stx     $10
        ldx     #$0080                  ; load 4 rows of 16x16 tiles
        stx     $16
        ldx     #$5000                  ; -> vram $5000-$53FF
        stx     $1a
        lda     $11
        jmp     LoadBG3AnimGfx2bpp

; ------------------------------------------------------------------------------

; [ load bg1 animation graphics ]

LoadBG1AnimGfx:
@a1e0:  stx     $10
        ldx     #$00a0                  ; load 5 rows of 16x16 tiles
        stx     $16
        ldx     #$0000                  ; -> vram $0000-$09FF
        stx     $1a
        jmp     LoadAnimGfx

; ------------------------------------------------------------------------------

; [ load animation graphics ]

; +$10: tilemap offset
; +$16: tile count (8x8 tiles)
; +$1a: destination address (vram)

LoadAnimGfx:
@a1ef:  lda     $10
        bmi     @a1f8       ; branch if 2bpp graphics
        lda     $11
        jmp     LoadAnimGfx3bpp
@a1f8:  lda     $11
        jmp     LoadAnimGfx2bpp

; ------------------------------------------------------------------------------

; [ load 3bpp animation graphics ]

LoadAnimGfx3bpp:
@a1fd:  sta     $11
        lda     $10
        lsr6
        and     #$01
        sta     $10
        longa
        lda     $10
        xba
        asl6
        clc
        adc     #near AttackTiles3bpp
        sta     $10
        shorta0
        lda     #^AttackTiles3bpp
        sta     $12
        lda     #$7f
        sta     $28
        ldx     #$e400
        stx     $26
        longa
        lda     $16
        pha
@a231:  stz     $24
        lda     [$10]
        and     #$3fff
        asl2
        rol     $24
        asl
        sta     $22
        asl
        rol     $24
        clc
        adc     $22
        sta     $22
        lda     $24
        adc     #0
        sta     $24
        lda     $22
        clc
        adc     #near AttackGfx3bpp
        sta     $22
        lda     $24
        adc     #^AttackGfx3bpp
        sta     $24
        lda     [$10]
        and     #$4000
        sta     $14                     ; h-flip
        lda     [$10]
        and     #$8000
        bne     @a2a4

; no v-flip
        clr_ay
@a26d:  lda     [$22]
        jsr     ApplyTileHFlip
        sta     [$26],y
        lda     $22
        clc
        adc     #$0002
        sta     $22
        lda     $24
        adc     #$0000
        sta     $24
        iny2
        cpy     #$0010
        bne     @a26d
@a28a:  lda     [$22]
        jsr     ApplyTileHFlip
        and     #$00ff
        sta     [$26],y
        inc     $22
        bne     @a29a
        inc     $24
@a29a:  iny2
        cpy     #$0020
        bne     @a28a
        jmp     @a2de

; v-flip
@a2a4:  ldy     #$000e
@a2a7:  lda     [$22]
        jsr     ApplyTileHFlip
        sta     [$26],y
        lda     $22
        clc
        adc     #$0002
        sta     $22
        lda     $24
        adc     #$0000
        sta     $24
        dey2
        cpy     #$fffe
        bne     @a2a7
        ldy     #$001e
@a2c7:  lda     [$22]
        jsr     ApplyTileHFlip
        and     #$00ff
        sta     [$26],y
        inc     $22
        bne     @a2d7
        inc     $24
@a2d7:  dey2
        cpy     #$000e
        bne     @a2c7
@a2de:  lda     $26
        clc
        adc     #$0020
        sta     $26
        inc     $10
        inc     $10
        dec     $16
        jne     @a231
        pla
        asl5
        sta     $10
        shorta0
        ldx     #$e400
        lda     #$7f
        ldy     $1a
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ load 2bpp animation graphics ]

LoadAnimGfx2bpp:
@a306:  sta     $11
        lda     $10
        lsr6
        and     #$01
        sta     $10
        longa
        lda     $10
        xba
        asl6
        clc
        adc     #near AttackTiles2bpp
        sta     $10
        shorta0
        lda     #^AttackTiles2bpp
        sta     $12
        lda     #^AttackGfx2bpp
        sta     $24
        lda     #$7f
        sta     $28
        ldx     #$e400
        stx     $26
        longa
        lda     $16
        pha
@a33e:  lda     [$10]
        and     #$3fff
        asl4
        clc
        adc     #near AttackGfx2bpp
        sta     $22
        lda     [$10]
        and     #$4000
        sta     $14
        lda     [$10]
        and     #$8000
        bne     @a37c
        clr_ay
@a35d:  lda     [$22]
        jsr     ApplyTileHFlip
        sta     [$26],y
        inc     $22
        inc     $22
        iny2
        cpy     #$0010
        bne     @a35d
        clr_a
@a370:  sta     [$26],y
        iny2
        cpy     #$0020
        bne     @a370
        jmp     @a3a0
@a37c:  ldy     #$000e
@a37f:  lda     [$22]
        jsr     ApplyTileHFlip
        sta     [$26],y
        inc     $22
        inc     $22
        dey2
        cpy     #$fffe
        bne     @a37f
        ldy     #$001e
        clr_a
@a395:  sta     [$26],y
        inc     $22
        dey2
        cpy     #$000e
        bne     @a395
@a3a0:  lda     $26
        clc
        adc     #$0020
        sta     $26
        inc     $10
        inc     $10
        dec     $16
        jne     @a33e
        pla
        asl5
        sta     $10
        shorta0
        ldx     #$e400
        lda     #$7f
        ldy     $1a
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ load 2bpp animation graphics (bg3) ]

LoadBG3AnimGfx2bpp:
@a3c8:  sta     $11
        lda     $10
        lsr6
        and     #$01
        sta     $10
        longa
        lda     $10
        xba
        asl6
        clc
        adc     #near AttackTiles2bpp
        sta     $10
        shorta0
        lda     #^AttackTiles2bpp
        sta     $12
        lda     #^AttackGfx2bpp
        sta     $24
        lda     #$7f
        sta     $28
        ldx     #$e400
        stx     $26
        longa
        lda     $16
        pha
@a400:  lda     [$10]
        and     #$3fff
        asl4
        clc
        adc     #near AttackGfx2bpp
        sta     $22
        lda     [$10]
        and     #$4000
        sta     $14
        lda     [$10]
        and     #$8000
        bne     @a434
        clr_ay
@a41f:  lda     [$22]
        jsr     ApplyTileHFlip
        sta     [$26],y
        inc     $22
        inc     $22
        iny2
        cpy     #$0010
        bne     @a41f
        jmp     @a449
@a434:  ldy     #$000e
@a437:  lda     [$22]
        jsr     ApplyTileHFlip
        sta     [$26],y
        inc     $22
        inc     $22
        dey2
        cpy     #$fffe
        bne     @a437
@a449:  lda     $26
        clc
        adc     #$0010
        sta     $26
        inc     $10
        inc     $10
        dec     $16
        beq     @a45c
        jmp     @a400
@a45c:  pla
        asl4
        sta     $10
        shorta0
        ldx     #$e400
        lda     #$7f
        ldy     $1a
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ reverse a 16-bit value to flip the tile horizontally ]

.proc ApplyTileHFlip
        pha
        lda     $14
        beq     NoFlip                  ; return if not flipped horizontally
        pla
        xba
        sta     $18
        phx
        ldx     #16
:       asl     $18
        ror
        dex
        bne     :-
        plx
        rts

NoFlip: pla
        rts
.endproc

; ------------------------------------------------------------------------------

; [  ]

_c1a487:
magic_tmp_buf_clr:
@a487:  phb
        lda     #$7f
        pha
        plb
        longa
        clr_ax
@a490:  sta     $e400,x
        inx2
        cpx     #$1400
        bne     @a490
        clr_ax
@a49c:  stz     near w7e7b3f,x                 ; *** bug *** data bank is still 7f
        stz     near w7e7b49,x
        stz     near w7e7b53,x
        stz     near w7e7b5d,x
        inx2
        cpx     #$000a
        bne     @a49c
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $0b: display damage numerals (single) ]

;  b1: numeral target
; +b2: gm?vvvvvv vvvvvvvv ($ffff = hide numerals)
;        g: green numeral
;        m: display "miss"
;        v: numeral value

        array_label GFX_CMD, GFX_CMD::DMG_NUMERALS_SINGLE
@a4b3:  lda     near w7e632e       ; damage numeral counter (next available numeral thread)
        and     #$03
        sta     near w7e632e
        tax
        stz     near w7e631a,x     ; clear numeral data
        stz     near w7e6322,x
        jsr     WaitFrame
        clr_axy
        iny
@a4c9:  lda     near w7e631a,x     ; branch if numeral is not enabled
        beq     @a4dc
        lda     (z76),y     ; target
        cmp     near w7e631e,x
        bne     @a4dc       ; branch if numeral doesn't have the same target as the new numeral
        lda     #$08
        jsr     WaitA       ; wait 8 frames while the existing numeral finishes
        bra     @a4e2
@a4dc:  inx
        cpx     #$0004
        bne     @a4c9
@a4e2:  clr_ax
@a4e4:  stz     near w7e60b3,x     ; clear graphics buffer
        inx
        cpx     #$0080
        bne     @a4e4
        lda     near w7e632e       ; numeral counter
        asl
        tax
        lda     f:_c1a5cb,x   ; pointer to damage numeral graphics in vram
        sta     near w7e6317
        lda     f:_c1a5cb+1,x
        sta     near w7e6317+1
        inc     near w7e6316       ; enable damage numeral graphics update in vram
        jsr     WaitFrame
        ldy     #$0003
        lda     (z76),y     ; branch if there is a valid numeral value
        cmp     #$ff
        bne     @a510
        rts
@a510:  sta     $1e         ; $1e = hi byte of numeral value
        and     #$40
        beq     @a531       ; branch if not displaying "miss"

; miss
        longa
        clr_ax
@a51a:  lda     $7fbc00,x   ; copy "miss" graphics to buffer
        sta     near w7e60b3+$20,x
        inx2
        cpx     #$0040
        bne     @a51a
        shorta0
        lda     #$08        ; x offset
        sta     $14
        bra     @a589

; numeral
@a531:  dey
        longa
        lda     (z76),y     ; numeral value
        and     #$3fff
        tax
        shorta0
        stz     z68         ; clear hex->dec conversion constant
        jsr     HexToDec16
        longa
        ldy     #near w7e60b3      ; pointer to graphics buffer
        lda     #$0010
        sta     $14
        lda     z69         ; thousands digit
        and     #$00ff
        bne     @a572       ; branch if not zero (show digit)
        lda     #$000c
        sta     $14
        lda     z69 + 1
        and     #$00ff
        bne     @a577
        lda     #$0008
        sta     $14
        lda     z69 + 2
        and     #$00ff
        bne     @a57c
        lda     #$0004
        sta     $14
        bra     @a581
@a572:  lda     z69         ; thousands digit
        jsr     _c1a5db       ; copy damage numeral tile to buffer
@a577:  lda     z69 + 1         ; hundreds digit
        jsr     _c1a5db       ; copy damage numeral tile to buffer
@a57c:  lda     z69 + 2         ; tens digit
        jsr     _c1a5db       ; copy damage numeral tile to buffer
@a581:  lda     z69 + 3         ; ones digit
        jsr     _c1a5db       ; copy damage numeral tile to buffer
        shorta0
@a589:  lda     near w7e632e       ; numeral counter
        and     #$03
        sta     near w7e632e
        tax
        ldy     #$0001
        lda     (z76),y     ; numeral target
        sta     near w7e631e,x
        lda     $14
        sta     near w7e6326,x     ; numeral graphics x offset (width / 2)
        stz     near w7e632a,x     ;
        stz     near w7e6322,x     ;
        lda     $1e         ; green numeral flag
        and     #$80
        ora     #$01        ; enable numeral
        sta     near w7e631a,x
        lda     near w7e632e       ; numeral counter
        asl
        tax
        lda     f:_c1a5d3,x   ; pointer to damage numeral graphics in vram
        sta     near w7e6317
        lda     f:_c1a5d3+1,x
        sta     near w7e6317+1
        inc     near w7e6316       ; enable damage numeral graphics update in vram
        jsr     WaitFrame
        inc     near w7e632e       ; increment damage numeral counter
        rts

; ------------------------------------------------------------------------------

; pointers to damage numeral graphics in vram (bottom of tiles)
_c1a5cb:
@a5cb:  .word   $2d00,$2d40,$2d80,$2dc0

; pointers to damage numeral graphics in vram (top of tiles, where the numbers are)
_c1a5d3:
@a5d3:  .word   $2c00,$2c40,$2c80,$2cc0

; ------------------------------------------------------------------------------

; [ copy damage numeral tile to buffer ]

; +A: numeral (0..9)
; +Y: pointer to graphics buffer (+$7e0000)

_c1a5db:
one_num_set2_local:
        .a16
@a5db:  and     #$00ff
        asl
        tax
        lda     f:_c1a735,x   ; pointer to numeral graphics
        tax
        lda     #$0010      ; 16 bytes per tile
        sta     $12
@a5ea:  lda     $7f0000,x   ; copy tile graphics to graphics buffer
        sta     $0000,y
        inx2
        iny2
        dec     $12
        bne     @a5ea
        rts
        .a8

; ------------------------------------------------------------------------------

; [ init damage numerals (multiple) ]

_c1a5fa:
damage_set:
@a5fa:  jsr     _c1a487
        stz     near w7e7b3e
        lda     near w7e7b3d
        inc     near w7e7b3d
        xba
        lda     #20
        jsr     MultAB
        lda     f:hRDMPYL
        tay
        lda     #$0a
        sta     $10
        stz     $16
        stz     $20
@a619:  stz     $14
        lda     near w7e2bce + 1,y
        sta     $1e
        cmp     #$ff
        bne     @a627
        jmp     @a6eb
@a627:  and     #$40
        beq     @a655

;
        phb
        lda     #$7f
        pha
        plb
        phy
        lda     $20
        asl
        tax
        longa
        lda     f:_c1a749,x
        tax
        clr_ay
@a63e:  lda     $bc00,y     ; "miss" graphics
        sta     a:$0020,x
        inx2
        iny2
        cpy     #$0040
        bne     @a63e
        shorta0
        ply
        plb
        jmp     @a6bd

;
@a655:  longa
        lda     near w7e2bce,y
        and     #$3fff
        tax
        shorta0
        stz     z68
        jsr     HexToDec16
        phb
        lda     #$7f
        pha
        plb
        phy
        lda     $20
        asl
        tax
        longa
        lda     f:_c1a749,x
        tax
        clr_ay
        lda     #$0010
        sta     $14
        lda     z69
        and     #$00ff
        bne     @a6a4
        lda     #$000c
        sta     $14
        lda     z69 + 1
        and     #$00ff
        bne     @a6a9
        lda     #$0008
        sta     $14
        lda     z69 + 2
        and     #$00ff
        bne     @a6ae
        lda     #$0004
        sta     $14
        bra     @a6b3
@a6a4:  lda     z69
        jsr     _c1a715
@a6a9:  lda     z69 + 1
        jsr     _c1a715
@a6ae:  lda     z69 + 2
        jsr     _c1a715
@a6b3:  lda     z69 + 3
        jsr     _c1a715
        shorta0
        ply
        plb
@a6bd:  lda     $20
        tax
        cpx     #$0004
        bcc     @a6d3
        lda     f:BitOrTbl-4,x
        and     near w7e201e
        and     near w7e61ab
        beq     @a6eb
        bra     @a6e2
@a6d3:  lda     f:BitOrTbl,x
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        beq     @a6eb
@a6e2:  lda     $1e
        and     #$80
        ora     #$01
        sta     near w7e7b3f,x
@a6eb:  lda     $20
        tax
        lda     $14
        sta     near w7e7b53,x
        stz     near w7e7b5d,x
        inc     $20         ; next character/monster
        iny2
        dec     $10
        beq     @a701
        jmp     @a619
@a701:  ldx     #$0c00
        stx     $10
        ldx     #$e400
        ldy     #$2600
        lda     #$7f
        jsr     WaitTfrVRAM
        inc     near w7e7b3e
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1a715:
one_num_set:
        .a16
@a715:  phx
        and     #$00ff
        asl
        tax
        lda     f:_c1a735,x
        tay
        plx
        lda     #$0010
        sta     $12
@a726:  lda     a:$0000,y
        sta     a:$0000,x
        inx2
        iny2
        dec     $12
        bne     @a726
        rts
        .a8

; ------------------------------------------------------------------------------

; pointers to numeral graphics (+$7f0000)
num_get_poi:
_c1a735:
@a735:  .word   $bc40,$bc60,$bc80,$bca0,$bcc0,$bce0,$bd00,$bd20
        .word   $bd40,$bd60

_c1a749:
@a749:  .word   $e400,$e480,$e500,$e580,$e800,$e880,$e900,$e980
        .word   $ec00,$ec80

ref_target_bit:
_c1a75d:
@a75d:  .word   $0001,$0002,$0004,$0008
        .word   $0100,$0200,$0400,$0800,$1000,$2000

; ------------------------------------------------------------------------------

; [ check which characters blocked the attack ]

CheckBlock:
@a771:  phy
        stz     $10
        ldy     #$000a
        lda     near w7e62c0       ; branch if block graphics are ignored
        beq     @a77f
        clr_a
        bra     @a793
@a77f:  lda     (z78),y     ; block type
        beq     @a789       ; branch if not blocked
        lda     $10
        ora     #$10
        sta     $10
@a789:  lsr     $10         ; set bit for characters that blocked
        iny
        cpy     #$000e
        bne     @a77f
        lda     $10
@a793:  sta     near w7e6082
        stz     near w7e6083
        ply
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $09: reflected attack ]

        array_label GFX_CMD, GFX_CMD::REFLECT_ANIM
@a79b:  jsr     PushMonsterPalID
        inc     near w7e62d1
        clr_ay
        sty     near wAnimCharTargets
@a7a6:  lda     (z78),y
        bmi     @a7ce
        tya
        asl
        tax
        lda     f:_c1a75d,x
        ora     near wAnimCharTargets
        sta     near wAnimCharTargets
        lda     f:_c1a75d+1,x
        ora     near wAnimMonsterTargets
        sta     near wAnimMonsterTargets
        lda     (z78),y
        cmp     #$04
        bcc     @a7cc
        sec
        sbc     #$04
        bra     @a7ce
@a7cc:  ora     #$80
@a7ce:  sta     near w7e6142,y
        iny
        cpy     #$000a
        bne     @a7a6
        jsr     InitSimpleAnim
        clr_ay
        sty     $1e
        ldy     #2
        lda     (z76),y
        jsr     LoadAnimProp
        lda     near wAnimCharTargets
        asl4
        sta     $12
        lda     near wAnimMonsterTargets
        sta     $13
        ldy     #14
        lda     (z78),y
        asl4
        sta     near w7e607e
        iny
        lda     (z78),y
        sta     near w7e607f
        sta     near w7e62af
        longa
        lda     $12
        lsr4
        sta     $12
        lda     near w7e607e
        lsr4
        sta     near w7e607e
        pha
        shorta0
        stz     near w7e890b
        lda     #$01
        sta     $1c
        sta     near w7e6084
        lda     near w7e6082
        ora     near w7e6083
        ora     near w7e6080
        ora     near w7e6081
        bne     @a83e
        ldy     near w7e6273
        bmi     _a8b3
@a83e:  lda     near w7e890b
        cmp     #$04
        bcc     @a847
        ora     #$80
@a847:  sta     near w7e6140
        lda     near w7e890b
        tay
        lda     (z78),y
        cmp     #$04
        bcc     @a856
        ora     #$80
@a856:  sta     near w7e613f
        lda     near w7e890b
        and     #$0f
        longa
        asl
        tax
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        lda     near w7e890b
        cmp     #$04
        bcs     @a87b
        clc
        adc     #$0a
        tay
        lda     (z78),y
        cmp     #$03
        beq     @a88d
@a87b:  lda     $12
        and     #$01
        beq     @a8a5
        ldy     near w7e7b35
        sty     $22
        ldy     near w7e6273
        sty     $24
        bra     @a897
@a88d:  ldy     #make_word 1, 1
        sty     $22
        ldy     #$0048
        sty     $24
@a897:  ldy     $12
        phy
        lda     #$01
        sta     near w7e607e
        jsr     CreateThread
        ply
        sty     $12
@a8a5:  ror     $13
        ror     $12
        inc     near w7e890b
        lda     near w7e890b
        cmp     #$0a
        bne     @a83e
_a8b3:  ldy     near w7e6275
        bmi     @a8df
        jsr     _c1aac3
        lda     $12
        sta     near w7e613f
        lda     #$01
        sta     $1c
        ldx     #BG1_THREAD_OFFSET
        ldy     near w7e7b31
        sty     $22
        ldy     near w7e6275
        sty     $24
        jsr     CreateThread
        ldx     #BG1_THREAD_OFFSET
        lda     near wAnimThread::LayerPriority,x
        ora     #$01
        sta     near wAnimThread::LayerPriority,x
@a8df:  ldy     near w7e6277
        bmi     @a90b
        jsr     _c1aac3
        lda     $12
        sta     near w7e613f
        lda     #$01
        sta     $1c
        ldx     #BG3_THREAD_OFFSET
        ldy     near w7e7b33
        sty     $22
        ldy     near w7e6277
        sty     $24
        jsr     CreateThread
        ldx     #BG3_THREAD_OFFSET
        lda     near wAnimThread::LayerPriority,x
        ora     #$02
        sta     near wAnimThread::LayerPriority,x

; load extra/genju thread
@a90b:  ldy     near w7e627e
        cpy     #$ffff
        beq     @a95e
        lda     #$01
        sta     $1c
        ldy     near w7e7b37
        sty     $22
        ldy     near w7e627e
        sty     $24
        clr_ay
@a923:  lda     (z78),y
        bmi     @a945
        cmp     #$04
        bcc     @a92d
        ora     #$80
@a92d:  sta     near w7e613f
        lda     near w7e62d0
        beq     @a93c
        jsr     GetAttackerNum
        lda     $10
        bra     @a94d
@a93c:  tya
        cmp     #$04
        bcc     @a943
        ora     #$80
@a943:  bra     @a94b
@a945:  iny
        cpy     #$000a
        bne     @a923
@a94b:  sta     $10
@a94d:  and     #$0f
        longa
        asl
        tax
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        jsr     CreateExtraThread
@a95e:  clr_ax
        stx     near w7e6080
        plx
        stx     near w7e607e
        phx
        stz     near w7ee9ee
        jsr     InitAnimType
        plx
        stx     near w7e607e
        clr_ax
        stx     near w7e6080
        jsr     _c1ae2f
        jsr     CopyPal
        jsr     ExecAnimScript
        jsr     PopMonsterPalID
        jsr     DeinitAnimType
        stz     near w7e62d1
        stz     near w7e62d0
        jmp     NextGfxCmdData

; ------------------------------------------------------------------------------

; [ graphics script command $15: super ball/launcher attack ]

        array_label GFX_CMD, GFX_CMD::SUPER_BALL
@a98f:  jsr     PushMonsterPalID
        inc     near w7e62d0
        inc     near w7e62d1
        clr_ay
        sty     near wAnimCharTargets
@a99d:  lda     (z78),y
        bmi     @a9c5
        tya
        asl
        tax
        lda     f:_c1a75d,x
        ora     near wAnimCharTargets
        sta     near wAnimCharTargets
        lda     f:_c1a75d+1,x
        ora     near wAnimMonsterTargets
        sta     near wAnimMonsterTargets
        lda     (z78),y
        cmp     #$04
        bcc     @a9c3
        sec
        sbc     #$04
        bra     @a9c5
@a9c3:  ora     #$80
@a9c5:  sta     near w7e6142,y
        iny
        cpy     #$000a
        bne     @a99d
        jsr     _c1aac3
        jsr     InitSimpleAnim
        clr_ay
        sty     $1e
        ldy     #2
        lda     (z76),y
        jsr     LoadAnimProp
        lda     near wAnimCharTargets
        asl4
        sta     $12
        lda     near wAnimMonsterTargets
        sta     $13
        longa
        lda     $12
        lsr4
        sta     $12
        pha
        shorta0
        jsr     _c1aac3
        stz     near w7e890b
        lda     #$01
        sta     $1c
        sta     near w7e6084
        lda     near w7e6082
        ora     near w7e6083
        ora     near w7e6080
        ora     near w7e6081
        bne     @aa1c
        ldy     near w7e6273
        bmi     @aa8d
@aa1c:  lda     near w7e890b
        tay
        lda     (z78),y
        cmp     #$04
        bcc     @aa28
        ora     #$80
@aa28:  sta     near w7e613f
        lda     near w7e890b
        and     #$0f
        longa
        asl
        tax
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        lda     near w7e890b
        tay
        lda     near w7e62c0       ; branch if block graphics are ignored
        bne     @aa55
        lda     (z78),y
        cmp     #$04
        bcs     @aa55
        clc
        adc     #$0a
        tay
        lda     (z78),y
        cmp     #$03
        beq     @aa67
@aa55:  lda     $12
        and     #$01
        beq     @aa7f
        ldy     near w7e7b35
        sty     $22
        ldy     near w7e6273
        sty     $24
        bra     @aa71
@aa67:  ldy     #make_word 1, 1
        sty     $22
        ldy     #$0048
        sty     $24
@aa71:  ldy     $12
        phy
        lda     #$01
        sta     near w7e607e
        jsr     CreateThread
        ply
        sty     $12
@aa7f:  ror     $13
        ror     $12
        inc     near w7e890b
        lda     near w7e890b
        cmp     #$0a
        bne     @aa1c
@aa8d:  jsr     GetAttackerNum
        lda     $10
        bmi     @aa9e
        asl5
        tay
        clr_a
        sta     near wCharGfxData::ReadyAction,y
@aa9e:  jmp     _a8b3

; ------------------------------------------------------------------------------

; [  ]

_c1aaa1:
get_target2_long:
@aaa1:  jsr     _c1aaa5
        rtl

; ------------------------------------------------------------------------------

; [ ??? ]

; $12: character/monster number (out) ???

_c1aaa5:
get_target2:
@aaa5:  lda     near w7e62d1       ; branch if reflect, super ball, launcher
        bne     _c1aac3
        jmp     GetTargetNum

; ------------------------------------------------------------------------------

; [ get reflected attacker ]

_c1aaad:
get_super_num:
@aaad:  ldy     #14
        lda     (z78),y                 ; reflected character attacker
        jne     GetBitNum
        iny
        lda     (z78),y                 ; reflected monster attacker
        jsr     GetBitNum
        clc
        adc     #4
        ora     #$80
        rts

; ------------------------------------------------------------------------------

; [ ??? ]

_c1aac3:
get_target_ref:
@aac3:  lda     near w7e62d0
        beq     @aacf
        jsr     _c1aaad       ; get ??? character/monster number
        sta     near w7e6140       ; set attacker number
        rts
@aacf:  clr_ay
@aad1:  lda     (z78),y     ; branch if attacker is a character
        bpl     @aadd
        iny
        cpy     #$000a
        bne     @aad1
        clr_ay
@aadd:  cmp     #$04
        bcc     @aae3
        ora     #$80
@aae3:  sta     $12
        tya
        sta     near w7e6140
        rts

; ------------------------------------------------------------------------------

; [ create bg1 & bg3 animation threads ]

CreateBGThreads:
@aaea:  ldy     near w7e6275       ; branch if bg1 script is disabled
        bmi     @ab16
        jsr     _c1aaa5
        lda     $12
        sta     near w7e613f
        lda     #$01        ; set initial frame delay to 1
        sta     $1c
        ldx     #BG1_THREAD_OFFSET
        ldy     near w7e7b31       ; bg1 frame width/height
        sty     $22
        ldy     near w7e6275       ; bg1 animation script
        sty     $24
        jsr     CreateThread
        ldx     #BG1_THREAD_OFFSET
        lda     near wAnimThread::LayerPriority,x     ; bg1 thread priority
        ora     #$01
        sta     near wAnimThread::LayerPriority,x
@ab16:  ldy     near w7e6277       ; branch if bg3 script is disabled
        bmi     @ab42
        jsr     _c1aaa5
        lda     $12
        sta     near w7e613f
        lda     #$01        ; set initial frame delay to 1
        sta     $1c
        ldx     #BG3_THREAD_OFFSET
        ldy     near w7e7b33       ; bg3 frame width/height
        sty     $22
        ldy     near w7e6277       ; bg3 animation script
        sty     $24
        jsr     CreateThread
        ldx     #BG3_THREAD_OFFSET
        lda     near wAnimThread::LayerPriority,x     ; bg3 thread priority
        ora     #$02
        sta     near wAnimThread::LayerPriority,x
@ab42:  rts

; ------------------------------------------------------------------------------

; [ init single thread animation ]

InitSimpleAnim:
        lda     #1
        sta     near w7e7b0e       ; 1 monster thread
        sta     near w7e7b0f       ; 1 character thread
        stz     near w7e60aa       ; disable shared graphics (air anchor)
        stz     near w7e60ac       ; unpause bg1 animation threads
        stz     near w7e60ad       ; unpause bg3 animation threads
        stz     a:z99       ; unpause sprite animation threads
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1ab58:
init_all_anim:
@ab58:  stz     near w7e62b0       ; esper thread shown above characters & monsters
        jsr     PushMonsterPalID
        jsr     SetAnimTargets
        jsr     _c19aa2
        jmp     InitSimpleAnim

; ------------------------------------------------------------------------------

; [ set animation targets ]

SetAnimTargets:
@ab67:  ldy     #2
        lda     (z78),y     ; animation targets
        sta     near wAnimCharTargets
        iny
        lda     (z78),y
        sta     near wAnimMonsterTargets
        rts

; ------------------------------------------------------------------------------

; [ graphics script command $0e, $16-$1a: reset graphical action ]

; b1: character number

        array_label GFX_CMD, GFX_CMD::RESET_CHAR_ACTION
        array_label GFX_CMD, GFX_CMD::GFX_CMD_22
        array_label GFX_CMD, GFX_CMD::GFX_CMD_23
        array_label GFX_CMD, GFX_CMD::GFX_CMD_24
        array_label GFX_CMD, GFX_CMD::GFX_CMD_25
        array_label GFX_CMD, GFX_CMD::GFX_CMD_26
@ab76:  ldy     #1
        lda     (z76),y     ; character/monster number
        cmp     #4
        bcs     @ab8a       ; return if not a character
        and     #%11
        asl5
        tax
        stz     near wCharGfxData::ReadyAction,x
@ab8a:  rts

; ------------------------------------------------------------------------------

; [ reset attacker graphical action ]

_c1ab8b:
clr_player_pat:
@ab8b:  ldy     #1
        lda     (z78),y     ; character/monster number
        cmp     #4
        bcs     @ab9e       ; branch if not a character
        asl5
        tay
        clr_a
        sta     near wCharGfxData::ReadyAction,y
@ab9e:  rts

; ------------------------------------------------------------------------------

; [ do pre-attack animation ]

; for magic and summon only

PreMagicAnim:
@ab9f:  ldy     #2
        clr_ax
        lda     (z76),y     ; attack number
        cmp     #$18
        bcc     @abbb       ; branch if black magic (x = 0)
        inx2
        cmp     #$36
        bcc     @abbb       ; branch if white or effect magic (x = 2)
        inx2
        cmp     #$51
        bcc     @abbb       ; branch if esper (x = 4)
        stz     near w7e62c0       ; don't ignore block graphics
        bra     @abe7
@abbb:  inc     near w7e62c0       ; ignore block graphics
        longa
        lda     f:PreMagicAnimPropPtrs,x
        sta     $1e
        shorta0
        jsr     LoadAnimProp
        jsr     ExecAnim
        jsr     GetAttackerNum
        lda     $10
        bmi     @abe1       ; branch if monster
        and     #$03
        tax
        lda     near w7e62a4                 ; branch if doing run away animation
        bne     @abe1
        inc     near w7e61ae,x               ; need to step forward and back
@abe1:  stz     near w7e62c0       ; don't ignore block graphics
        jsr     InitSimpleAnim
@abe7:  jsr     _c1ab8b       ; reset attacker graphical action
        rts

; ------------------------------------------------------------------------------

; [ attack command $02/$17/$19: magic/x-magic/summon ]

MagicCmdAnim:
        array_label GFX_BATTLE_CMD, BATTLE_CMD::MAGIC
        array_label GFX_BATTLE_CMD, BATTLE_CMD::X_MAGIC
        array_label GFX_BATTLE_CMD, BATTLE_CMD::SUMMON
        ldy     #2
        lda     (z76),y     ; branch if not $f9 ("red card", setzer's desperation attack)
        cmp     #ATTACK::RED_CARD
        bne     @ac06
        clr_a
        sta     (z76),y
        iny
        lda     #ITEM::DARTS        ; do darts animation 3 times
        sta     (z76),y
        jsr     FightCmdAnim
        jsr     FightCmdAnim
        jsr     FightCmdAnim
        rts
@ac06:  jsr     _c1ab58
        jsr     _c1ab8b       ; reset attacker graphical action
        ldy     #1
        lda     (z78),y     ; attacker number
        cmp     #$04
        bcs     @ac1e       ; branch if a monster
        lda     (z78)       ; branch if skipping pre-attack animation
        and     #$10
        bne     @ac1e
        jsr     PreMagicAnim
@ac1e:  jsr     CheckNullTarget
        bcc     @ac31
        clr_ay
        sty     $1e
        iny2
        lda     (z76),y
        jsr     LoadAnimProp
        jsr     ExecAnim
@ac31:  jsr     _c1ac35
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1ac35:
screen_all_clr_tfr:
@ac35:  jsr     ClearBGAnimFrames
        ldx     #$0800
        stx     $10
        ldx     #$c400
        lda     #$7f
        ldy     #$0c00
        jsr     WaitTfrVRAM
        jsr     ClearAnimGfxBuf
        ldx     #$0800
        stx     $10
        ldx     #$e400
        lda     #$7f
        ldy     #$5400
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ execute battle animation ]

ExecAnim:
@ac5b:  jsr     InitAnimThreads
        jsr     ExecAnimScript
        jsr     PopMonsterPalID
        jmp     DeinitAnimType

; ------------------------------------------------------------------------------

; [ init battle animation threads (long access) ]

; unused

InitAnimThreads_far:
@ac67:  jsr     InitAnimThreads
        rtl

; ------------------------------------------------------------------------------

; [ init attack animation threads ]

InitAnimThreads:
@ac6b:  ldy     #2
        lda     (z78),y     ; $12 = possible character targets
        asl4
        sta     $12
        iny
        lda     (z78),y     ; $13 = possible monster targets
        sta     $13
        iny
        lda     (z78),y     ; character targets hit
        asl4
        sta     near w7e607e
        iny
        lda     (z78),y     ; monster targets hit
        sta     near w7e607f
        sta     near w7e62af       ;
        iny
        lda     (z78),y     ; character reflected targets
        asl4
        sta     near w7e6080
        iny
        lda     (z78),y     ; monster reflected targets
        sta     near w7e6081
        longa
        lda     $12
        lsr4
        sta     $12
        lda     near w7e607e
        lsr4
        sta     near w7e607e
        lda     near w7e6080
        lsr4
        sta     near w7e6080
        lda     near w7e62c0       ; branch if block graphics are ignored
        and     #$00ff
        beq     @accc
        stz     near w7e6080
        clr_a
        dec
        sta     near w7e607e
@accc:  shorta0
        ldx     near w7e6080
        phx
        ldx     near w7e607e
        phx
        jsr     GetAttackerNum
        sta     near w7e6140
        stz     near w7e890b       ; clear character/monster counter
        lda     #$01        ; set initial frame delay to 1
        sta     $1c
        sta     near w7e6084       ; 1 active thread
        lda     near w7e6082       ; targets blocked
        ora     near w7e6083
        ora     near w7e6080
        ora     near w7e6081
        bne     @acfa
        ldy     near w7e6273       ; branch if sprite thread is disabled
        bmi     @ad76
@acfa:  lda     near w7e890b       ; current character/monster
        sta     near w7e613f
        and     #$0f
        longa
        asl
        tax
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        lda     near w7e62c0       ; branch if block graphics are disabled
        bne     @ad24
        lda     near w7e890b       ; branch if a monster
        cmp     #$04
        bcs     @ad24
        clc
        adc     #$0a
        tay
        lda     (z78),y     ; branch if character blocked with a shield
        cmp     #$03
        beq     @ad49
@ad24:  lda     near w7e6080       ; branch if target reflected
        and     #$01
        bne     @ad3d
        lda     $12         ; branch if target was not hit
        and     #$01
        beq     @ad5c
        ldy     near w7e7b35       ; animation frame height/width
        sty     $22
        ldy     near w7e6273       ; sprite script number
        sty     $24
        bra     @ad53
@ad3d:  ldy     #make_word 2, 2      ; 2x2 frame height/width
        sty     $22
        ldy     #$0042      ; script $0042 (reflect)
        sty     $24
        bra     @ad53
@ad49:  ldy     #make_word 1, 1      ; 1x1 frame height/width
        sty     $22
        ldy     #$0063      ; script $0063 (shield)
        sty     $24
@ad53:  ldy     $12         ; possible targets
        phy
        jsr     CreateThread
        ply
        sty     $12
@ad5c:  ror     $13         ; next target
        ror     $12
        ror     near w7e607f
        ror     near w7e607e
        ror     near w7e6081
        ror     near w7e6080
        inc     near w7e890b       ; increment character/monster counter
        lda     near w7e890b
        cmp     #$0a
        bne     @acfa
@ad76:  jsr     CreateBGThreads

; load extra/genju thread
        ldy     near w7e627e       ; esper thread
        cpy     #$ffff
        beq     @adda       ; branch if disabled
        bmi     @addc       ; branch if esper thread
        lda     #$01        ; set initial frame delay to 1
        sta     $1c
        ldy     near w7e7b37       ; esper frame height/width
        sty     $22
        ldy     near w7e627e       ; esper script number
        sty     $24
        jsr     GetAttackerNum
        lda     $10
        and     #$0f
        longa
        asl
        tax
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        lda     near w7e627d       ; special animation function
        and     #$7f
        cmp     #$12        ; branch if not esper pre-attack animation
        bne     @adb1
        lda     #3        ; create 3 threads
        bra     @adbb
@adb1:  cmp     #$11        ; branch if not white/gray pre-attack animation
        bne     @adb9
        lda     #6        ; create 6 threads
        bra     @adbb
@adb9:  lda     #1        ; create 1 thread
@adbb:  pha
        phx
        jsr     _c1aaa5
        lda     $12
        sta     near w7e613f       ; character/monster number
        plx
        phx
        jsr     CreateExtraThread
        plx
        longa
        txa                 ; next thread
        clc
        adc     #$0010
        tax
        shorta0
        pla
        dec
        bne     @adbb
@adda:  bra     @ae03
@addc:  jsr     GetAttackerNum
        jsr     _c1aaa5
        lda     $12
        sta     near w7e613f       ; character/monster number
        lda     #$01        ; set initial frame delay to 1
        sta     $1c
        ldx     #GENJU_THREAD_1_OFFSET
        ldy     near w7e7b37
        sty     $22         ; esper frame width/height
        longa
        lda     near w7e627e       ; esper script number
        and     #$7fff
        sta     $24
        shorta0
        jsr     CreateThread
@ae03:  ldy     #6
        lda     (z78),y                 ; targets reflected off of
        asl4
        sta     near w7e6080
        iny
        lda     (z78),y
        sta     near w7e6081
        plx
        stx     near w7e607e
        phx
        stz     near w7ee9ee       ;
        jsr     InitAnimType
        plx
        stx     near w7e607e       ;
        plx
        stx     near w7e6080       ;
        jsr     _c1ae2f
        jsr     CopyPal
        rts

; ------------------------------------------------------------------------------

; [ disable threads for blocked targets ]

; disabled for umaro's throw and mode 7 animations

_c1ae2f:
clr_success_flag:
@ae2f:  jsr     GetAttackerNum
        lda     near w7ee9ee
        beq     @ae38
        rts
@ae38:  ldx     near w7e6082
        phx
        longa
        ldy     #10
        lda     (z78),y         ; character 1/2 block type
        sta     near w7e62a5
        iny2
        lda     (z78),y         ; character 3/4 block type
        sta     near w7e62a5+2
        lda     near w7e6082
        not_a
        sta     $16
        lda     near w7e6080
        not_a
        sta     $14
        lda     near w7e607e
        and     $14
        and     $16
        sta     $2a
        shorta0
        lda     $2a
        ora     $2b
        bne     @aec3
        lda     near w7e6080
        ora     near w7e6081
        ora     near w7e6082
        ora     near w7e6083
        ora     near w7e607e
        ora     near w7e607f
        beq     @ae9b
        stz     near wBG1Thread::ThreadIsActive
        stz     near wBG3Thread::ThreadIsActive
        stz     near wGenjuThread1::ThreadIsActive
        stz     near wGenjuThread2::ThreadIsActive
        stz     near wGenjuThread3::ThreadIsActive
        stz     a:z99       ; unpause sprite animation threads
        stz     near w7e60ad       ; unpause bg3 animation threads
        stz     near w7e60ac       ; unpause bg1 animation threads
@ae9b:  lda     near wBG1Thread::w7e6f88
        ora     #$80
        sta     near wBG1Thread::w7e6f88
        lda     near wBG3Thread::w7e6f88
        ora     #$80
        sta     near wBG3Thread::w7e6f88
        lda     near wGenjuThread1::w7e6f88
        ora     #$80
        sta     near wGenjuThread1::w7e6f88
        lda     near wGenjuThread2::w7e6f88
        ora     #$80
        sta     near wGenjuThread2::w7e6f88
        lda     near wGenjuThread3::w7e6f88
        ora     #$80
        sta     near wGenjuThread3::w7e6f88
@aec3:  clr_ax
@aec5:  lda     near w7e6082
        and     #$01
        bne     @aef9
        lda     near w7e6080
        and     #$01
        bne     @aef9
        lda     near w7e607e
        and     #$01
        bne     @af31
        phx
        lda     #$08
        sta     $18
@aedf:  lda     near wAnimThread::w7e6f88,x
        ora     #$80
        sta     near wAnimThread::w7e6f88,x
        longa
        txa
        clc
        adc     #$0010
        tax
        shorta0
        dec     $18
        bne     @aedf
        plx
        bra     @af31
@aef9:  .repeat 7, i
        lda     .loword(array_member wAnimThread, i + 1, ThreadIsActive),x
        and     #$02
        sta     .loword(array_member wAnimThread, i + 1, ThreadIsActive),x
        .endrep
@af31:  longa
        txa
        clc
        adc     #$0080
        tax
        shorta
        ror     near w7e6083
        ror     near w7e6082
        ror     near w7e607f
        ror     near w7e607e
        ror     near w7e6081
        ror     near w7e6080
        cpx     #BG1_THREAD_OFFSET
        jne     @aec5
        plx
        stx     near w7e6082
        rts

; ------------------------------------------------------------------------------

; [ odin/raiden/cleave death animation ]

.proc OdinDeathAnim
        jsl     AnimType_09_far
        lda     #BG_SCROLL_HDMA::WAVE_32_BG1
        sta     near w7e800c                 ; bg1 scroll hdma type
        ldy     #5
        lda     (z78),y
        sta     near w7e607f
        stz     near w7e607e
        stz     near wHideBG1MonsterSprites
        jsr     WaitFrame

; start of monster loop
MonsterLoop:
        jsr     WaitFrame
        lda     near w7e607e
        tax
        lda     near w7e607f
        and     f:BitOrTbl,x
        beq     SkipMonster
        pha
        jsr     MonstersToBG1
        jsr     AttackerTopLayerPriority
        jsr     TfrBG1Tiles
        jsr     WaitFrame
        pla
        not_a
        sta     near w7e60ab
        stz     near w7e5f6d
        lda     #$80
        sta     $10
        lda     #SFX::ODIN_DEATH
        jsr     PlayAnimSfx

; start of frame loop
FrameLoop:
        jsr     WaitFrame
        lda     near w7e5f6d
        ldx     #$0010
        stx     $24
        lda     near w7e5f6d
        jsr     CalcSine16
        jsr     UpdateOdinDeathHDMA
        jsr     UpdateOdinDeathPal
        lda     near w7e5f6d
        clc
        adc     #$02
        sta     near w7e5f6d
        cmp     #$40
        bne     FrameLoop
        clr_ax
        stx     $28
        jsr     UpdateOdinDeathHDMA
        lda     near w7e201e
        and     near w7e61ab
        and     near w7e60ab
        sta     near w7e201e
        jsr     ClearBG1Tiles

SkipMonster:
        inc     near w7e607e
        lda     near w7e607e
        cmp     #6
        bne     MonsterLoop

        jsr     WaitFrame
        jsr     ClearBG1Tiles
        clr_ax
        stx     $10
        stx     near w7e64b4
        stx     near w7e64b6
        jsr     SetColorMathHDMA
        lda     #BG_SCROLL_HDMA::DEFAULT_BG1
        sta     near w7e800c
        rts
.endproc  ; OdinDeathAnim

; ------------------------------------------------------------------------------

; [ set color add/sub data ]

SetColorMathHDMA_far:
@b000:  jsr     WaitLine160
        jsr     SetColorMathHDMA
        rtl

; ------------------------------------------------------------------------------

; [ wait for scanline 160 ]

; waits until the ppu reaches the end of the battlefield area

WaitLine160:
@b007:  pha
@b008:  lda     f:hSTAT78
        lda     f:hSLHV
        lda     f:hOPVCT
        cmp     #$a0
        bcc     @b008
        pla
        rts

; ------------------------------------------------------------------------------

; [ set attacker character layer priority to highest ]

AttackerTopLayerPriority:
        jsr     GetAttackerNum
        lda     $10
        bmi     @b02c
        asl5
        tay
        lda     #$30
        sta     near wCharGfxData::LayerPriority,y
@b02c:  rts

; ------------------------------------------------------------------------------

; [ fade target palette out for cleave death ]

UpdateOdinDeathPal:
        clr_ay
        longa
        ldx     #$0010
        lda     #$00e1
        sta     $14
        sta     $16
        sta     $18
        jsr     InitColorMod
@b040:  lda     near w7e7e00::_3,y
        jsr     DecColor
        sta     near w7e7e00::_3,y
        iny2
        dex
        bne     @b040
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ wait for line 160 ]

; only used for odin/raiden/cleave death animation, not sure why it doesn't
; read hSTAT78 here, it seems like it should

OdinDeathWaitLine160:
:       lda     f:hSLHV
        lda     f:hOPVCT
        cmp     #$a0
        bcc     :-
        rts

; ------------------------------------------------------------------------------

; [ update hdma data for odin death animation ]

UpdateOdinDeathHDMA:
        jsr     OdinDeathWaitLine160
        clr_ax
        longa
:       lda     $28
        sta     near w7e63b0::_0::Horz,x
        not_a
        sta     near w7e63b0::_16::Horz,x
        inx4
        cpx     #$0040
        bne     :-
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ clear bg3 tile data in vram (long access) ]

ClearBG3Tiles_far:
@b07e:  jsr     ClearBG3TileBuf
        jsr     TfrBG3Tiles
        rtl

; ------------------------------------------------------------------------------

; [ de-initialize animation type ]

; called after animations are finished to reset variables to normal

DeinitAnimType:
        lda     #$ff
        sta     near w7e60ab
        jsr     ResetSpritePriority
        stz     near wHideBG1MonsterSprites
        jsr     WaitFrame
        jsr     ClearBG1Tiles
        jsr     ClearBG3TileBuf
        jsr     TfrBG3Tiles
        clr_ax
        stx     near w7e64b4
        stx     near w7e64b6
        lda     #$17
        sta     near w7e898d
        lda     near w7e896f         ; 8x8 bg1 and bg3 tiles, high priority bg3
        and     #$af
        ora     #$08
        sta     near w7e896f
        jsr     WaitFrame
        clr_ax
        stx     $10
        stx     near w7e64b4
        stx     near w7e64b6
        stx     near wBG3ScrollData::Horz
        stx     near wBG3ScrollData::Vert
        jsr     SetColorMathHDMA
        lda     #$33
        sta     f:hW12SEL
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jsl     InitCircle_far
        lda     #$ff
        sta     near w7e60ab
        lda     near w7e627d       ; animation init function
        bmi     @b0f3       ; branch if bg1 target
        cmp     #$6b
        beq     @b0f0       ; branch if raiden
        cmp     #$45
        beq     @b0f0       ; branch if odin
        cmp     #$0b
        bne     @b0f3       ; branch if not cleave
@b0f0:  jsr     OdinDeathAnim
@b0f3:  lda     #$17
        sta     near w7e898d       ; main screen designation -> $212c (battlefield region)
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 tile data to vram ]

TfrBG3Tiles:
@b0f9:  ldx     #$0400      ; size = $0400
        stx     $10
        ldx     #near w7ea97f      ; source = $7ea97f (bg tile data buffer)
        lda     #^w7ea97f
        ldy     #$5400      ; destination = $5400 (vram)
        jmp     WaitTfrVRAM

; ------------------------------------------------------------------------------

; [ clear bg tile data in vram (long access) ]

ClearBG1TargetTiles_far:
@b109:  jsr     ClearBG1TargetTiles
        rtl

; ------------------------------------------------------------------------------

; [ clear bg tile data in vram ]

; +Y: vram destination

ClearBG1TargetTiles:
summon_clr_screen_tfr:
@b10d:  jsr     _c1b11e       ; clear vram buffer (bg tile data)
        ldx     #$0800      ; size = $0800
        stx     $10
        ldx     #near w7eae3f      ; source = $7eae3f (vram buffer)
        lda     #^w7eae3f
        jsr     WaitTfrVRAM
        rts

; ------------------------------------------------------------------------------

; [ clear vram buffer (bg tile data) ]

_c1b11e:
@b11e:  longa
        clr_ax
        lda     #$02ee
@b125:  sta     near w7eae3f,x
        sta     near w7eae3f+$0200,x
        sta     near w7eae3f+$0400,x
        sta     near w7eae3f+$0600,x
        inx2
        cpx     #$0200
        bne     @b125
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init bg tile data and execute init function ]

InitAnimType:
@b13c:  lda     near w7e627d       ; init function
        bpl     @b191       ; branch if using bg1 animation graphics

; bg1 target
        pha
        jsr     ResetSpritePriority
        stz     near wHideBG1MonsterSprites
        lda     near w7e896f       ; 8x8 bg1 tiles and 16x16 bg3 tiles ($2105)
        and     #$ef
        ora     #$40
        sta     near w7e896f
        lda     #$ff        ;
        sta     near w7e60ab
        ldy     #$0c00      ; vram destination = $0c00 (bg1 tile data)
        jsr     ClearBG1TargetTiles
        jsr     WaitFrame
        lda     #$0c
        sta     near w7e8971       ; bg1 tile data vram location = $0c00
        jsr     ClearBG1Tiles
        jsr     TfrBG3Tiles
        clr_ax
        stx     near w7e64b4       ;
        stx     near w7e64b6
        stx     near wBG3ScrollData::Horz       ; clear bg3 scroll hdma data
        stx     near wBG3ScrollData::Vert
        jsr     WaitFrame
.if ROM_VERSION >= 1
        jsr     _c11e6d
.else
        jsr     _c11e79
.endif
        jsr     TfrBG1Tiles
        lda     #1
        sta     near wHideBG1MonsterSprites
        sta     near w7e7b0e       ; 1 monster thread
        sta     near w7e7b0f       ; 1 character thread
        pla
        jmp     @b1bb       ; execute init function

; bg1 animation graphics
@b191:  pha
        lda     near w7e6167       ; bg1 palette index
        jsr     LoadBG1AnimPal
        jsr     ClearBG1Tiles
        jsr     ClearBG3TileBuf
        jsr     TfrBG3Tiles
        clr_ax
        stx     near w7e64b4       ;
        stx     near w7e64b6
        stx     near wBG3ScrollData::Horz       ; clear bg3 scroll hdma data
        stx     near wBG3ScrollData::Vert
        lda     near w7e896f       ; 16x16 bg1 and bg3 tiles ($2105)
        ora     #$50
        sta     near w7e896f
        jsr     UpdateSpritePriority
        pla
@b1bb:  jsl     ExecAnimType
        rts

; ------------------------------------------------------------------------------

; [ create standalone thread (far) ]

; from monster animation script command 2 (unused)

CreateStandaloneThread_far:
        jsr     CreateStandaloneThread
        rtl

; ------------------------------------------------------------------------------

; [ create standalone thread ]

; a secret third type of animation thread, used for single-thread,
; standalone animations (i.e. battle event animations, critical hit flash)

; +X: pointer to thread data (id * $80 for character/monster threads)

CreateStandaloneThread:
@b1c4:  stx     near wAnimThreadPtr
        lda     #$ff
        sta     near w7e607e
        sta     near w7e607f
        stz     near w7e6082
        stz     near w7e6083
        lda     near w7e613f
        sta     $12
        stz     near w7e60a9
        lda     #1
        sta     $1a
        sta     $1c
        ldx     $22
        phx
        ldx     $24
        phx
        jsr     ResetThreadData
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::FrameWidth,x
        lda     $24
        sta     $22
        inc2
        ldx     near wAnimThreadPtr
        sta     near wAnimThread::ScriptPtr,x
        shorta0
        jmp     InitStandaloneThread

; ------------------------------------------------------------------------------

; [ create extra sprite thread ]

CreateExtraThread:
@b208:  lda     near w7e627d                 ; special function
        cmp     #$18                    ; branch if not drain, osmose, raid, cold dust
        bne     @b218
        longa                           ; skip 6 threads
        txa
        clc
        adc     #$0060
        bra     @b21f
@b218:  longa                           ; skip 1 thread
        txa
        clc
        adc     #$0010
@b21f:  tax
        shorta0
        stx     near wAnimThreadPtr
        lda     #$ff
        sta     near w7e607e                 ; clear all targets ???
        sta     near w7e607f
        lda     near w7e613f                 ; character/monster (attacker)
        sta     $12                     ; target number
        lda     #$08                    ; multi-target delay
        sta     near w7e60a9
        lda     #3                      ; set 3 in active thread flag
        sta     $1a                     ; seems to have no effect vs setting to 1
        bra     InitExtraThread

; ------------------------------------------------------------------------------

; [ create animation thread ]

;   +X: thread data pointer
;  $1c: initial frame delay
; +$22: frame width/height
; +$24: animation script number

CreateThread:
@b23e:  lda     near w7e6280
        sta     near w7e60a9
        lda     near w7e627d       ; animation init function
        and     #$7f
        cmp     #$05
        bne     @b24f
        bra     @b253
@b24f:  cmp     #$02
        bne     InitThread

; init function $02 and $05 (air anchor ???)
@b253:  phx
        phx
        jsr     InitThread
        longa
        pla
        clc
        adc     #$0040
        tax
        shorta0
        phx
        jsr     InitThread
        longa
        pla
        clc
        adc     #$0010
        tax
        shorta0
        jsr     InitThread
        plx
        stx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ init animation thread ]

InitThread:
        stx     near wAnimThreadPtr          ; thread data pointer
        lda     near w7e6084                 ; add 8 to number of active threads
        clc
        adc     #8
        sta     near w7e6084
        lda     near w7e6140                 ; $10 = attacker number
        sta     $10
        lda     near w7e62d1
        beq     @b295
        lda     near w7e613f
        bra     @b29e
@b295:  lda     near w7e613f
        cmp     #$04
        bcc     @b29e
        ora     #$80
@b29e:  sta     $12                     ; $12 = target number
        lda     #1
        sta     $1a                     ; $1a = 1 (active thread flag)

InitExtraThread:
        lda     #^AttackAnimScript
        sta     $26                     ; $26 = #$d0 (script pointer bank)
        ldx     $22
        phx
        ldx     $24
        phx
        jsr     ResetThreadData
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::FrameWidth,x  ; frame width/height
        lda     $24
        asl
        tax
        lda     f:AttackAnimScriptPtrs,x
        sta     $22
        inc2
        ldx     near wAnimThreadPtr
        sta     near wAnimThread::ScriptPtr,x  ; set thread script pointer
        shorta0

InitStandaloneThread:
        lda     near w7e607e
        and     #$01
        sta     near wAnimThread::w7e74d4,x  ; seems unused
        lda     #$06
        sta     near wAnimThread::SpritePal,x  ; use sprite palette 3
        lda     $26
        sta     $24
        sta     near wAnimThread::ScriptPtr_B,x     ; set script pointer bank
        lda     [$22]                   ; animation speed (first byte, high nybble)
        lsr4
        inc
        sta     near wAnimThread::AnimRate,x
        lda     $1c
        sta     near wAnimThread::AnimFrameCounter,x  ; initial frame delay
        lda     $1c
        clc
        adc     near w7e60a9                 ; add multi-target delay to next thread's initial frame delay
        sta     $1c
        stz     near wAnimThread::ThreadIndex,x  ; clear thread index
        lda     #$40
        sta     near wAnimThread::w7e6a37,x  ; tile offset
        lda     $10
        sta     near wAnimThread::AttackerIndex,x  ; attacker number
        lda     $12
        sta     near wAnimThread::TargetIndex,x  ; target number
        jsr     CalcTargetPos
        longa
        lda     $14                     ; x position (target)
        sta     near wAnimThread::TargetPosX,x
        sta     near wAnimThread::ThreadPosX,x
        lda     $16                     ; y position (target)
        sta     near wAnimThread::TargetPosY,x
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        jsr     CalcAttackerPos
        longa
        lda     $14                     ; x position (attacker)
        sta     near wAnimThread::AttackerPosX,x
        lda     $16                     ; y position (attacker)
        sta     near wAnimThread::AttackerPosY,x
        shorta0
        lda     #$30
        sta     near wAnimThread::LayerPriority,x  ; layer priority 3
        phx
        jsr     GetAttackerNum
        plx
        lda     $10                     ; branch if attacker is a character
        bpl     @b356

; monster attacker
        and     #$0f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80f3,y               ; attacker facing direction (monster)
        eor     near w7e617e,y
        eor     #$01
        bra     @b35a

; character attacker
@b356:  tay
        lda     near w7e7b10,y               ; attacker facing direction (character)
@b35a:  asl6
        and     #$40
        sta     near wAnimThread::w7e6f87,x  ; animation direction
        lda     $12                     ; branch if target is a monster
        bmi     @b375

; character target
        lda     #$02
        sta     near wAnimThread::TargetWidth,x  ; target width = 2 (character)
        lda     #$03
        sta     near wAnimThread::TargetHeight,x  ; target height = 3 (character)
        bra     @b388

; monster target
@b375:  and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e812f,y               ; target width (monster)
        sta     near wAnimThread::TargetWidth,x
        lda     near w7e812f+1,y             ; target height (monster)
        sta     near wAnimThread::TargetHeight,x
@b388:  lda     #1
        sta     near wAnimThread::LoopFrameCounter,x  ; set counter for graphic index offset to 1
        lda     $1a
        sta     near wAnimThread::ThreadIsActive,x  ; thread is active
        plx
        stx     $24
        plx
        stx     $22
        rts

; ------------------------------------------------------------------------------

; [ clear current thread data ]

ResetThreadData:
        ldx     near wAnimThreadPtr       ; thread pointer
        ldy     #wAnimThread::BLOCK_SIZE
:       stz     near wAnimThread::BLOCK_1,x     ; clear thread data
        stz     near wAnimThread::BLOCK_2,x
        stz     near wAnimThread::BLOCK_3,x
        stz     near wAnimThread::BLOCK_0,x
        inx
        dey
        bne     :-
        rts

; ------------------------------------------------------------------------------

.pushseg

.segment "attack_anim_frames"

; d1/0141
AttackAnimFrames:
        fixed_block $e997
        .incbin "assets/data/btlgfx/attack_anim_frames.bin"
        ATTACK_ANIM_FRAMES::END := * - AttackAnimFrames
        end_fixed_block

; ------------------------------------------------------------------------------

.segment "attack_anim_frames_ptrs"

; d4/df3c
AttackAnimFramesPtrs:
        ptr_tbl ATTACK_ANIM_FRAMES
        end_ptr ATTACK_ANIM_FRAMES

; ------------------------------------------------------------------------------

.segment "attack_anim_script"

; d0/0000
AttackAnimScript:
        .include "attack_anim_script.asm"

; ------------------------------------------------------------------------------

.segment "attack_anim_script_ptrs"

; d1/ead8
AttackAnimScriptPtrs:
        ptr_tbl ATTACK_ANIM_SCRIPT

.popseg

; ------------------------------------------------------------------------------
