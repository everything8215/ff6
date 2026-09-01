; ------------------------------------------------------------------------------

; [  ]

_c2c027:
cgx_mode7_chg:
@c027:  sta     $12
        stx     $10
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@c032:  lda     #$08
        sta     $18
@c036:  longa
        ldy     #$0010
        lda     [$10]
        sta     $1c
        lda     [$10],y
        sta     $1a
        shorta0
        ldy     #$0008
@c049:  clr_a
        asl     $1b
        rol
        asl     $1a
        rol
        asl     $1d
        rol
        asl     $1c
        rol
        and     #$1f
        beq     @c05c
        ora     #$30
@c05c:  sta     $c401,x
        inx2
        dey
        bne     @c049
        ldy     $10
        iny2
        sty     $10
        dec     $18
        bne     @c036
        longa
        lda     $10
        clc
        adc     #$0010
        sta     $10
        shorta0
        dec     $14
        bne     @c032
        plb
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $c7: animation commands for battle events ]

ExecEventAnimCmd:
@c081:  lda     [zAnimScriptPtr]
        asl
        tax
        jsr     (near EventAnimCmdTbl,x)
        ldx     near wAnimThreadPtr
        rtl

; ------------------------------------------------------------------------------

EventAnimCmdTbl:
        ptr_tbl EVENT_ANIM_CMD

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$11: disable running with l+r ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::DISABLE_RUN
@c0b0:  lda     near w7e2f4b       ; disable running with l+r
        ora     #$01
        sta     near w7e2f4b
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$10: make actor visible ]

; b1: actor index

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::SHOW_CHAR
@c0b9:  ldy     #1
        lda     [zAnimScriptPtr],y
        jsr     _c2c0d2
        tax
        lda     f:BitOrTbl,x            ; bit mask
        ora     near w7e6192                   ; include in the party
        sta     near w7e6192
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2c0d2:
get_cas_chg:
@c0d2:  sta     $10
        clr_ax
        stz     $12
@c0d8:  lda     $10
        cmp     near wCharGfxDataBuf::CharID,x
        beq     @c0ed
        inc     $12
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @c0d8
        clr_a
        rts
@c0ed:  lda     $12
        and     #$03
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$0f:  ]

; unused, has no effect

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::EVENT_ANIM_CMD_15
@c0f2:  lda     #$01
        trb     near w7e2f52
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$0e: enable/disable background shaking ]

; b1: h------s
;     h = horizontal shaking only
;     s = enable screen shaking (battle bg)

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::SHAKE_BG
@c0f8:  ldy     #1
        lda     [zAnimScriptPtr],y
        beq     @c104
        sta     near w7e6285
        bra     @c10f
@c104:  stz     near w7e6285
        clr_ax
        stx     near w7e64b0       ; clear bg2 scroll position
        stx     near w7e64b2
@c10f:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$0d: change monster palette 1 ]

; b1: battle event palette index

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::TRITOCH_SPARKLE
@c115:  ldy     #1
@c118:  lda     [zAnimScriptPtr],y
        asl5
        tax
        clr_ay
@c122:  lda     f:BattleEventPal,x
        sta     near w7e7e00::_8,y     ; monster palette 1
        inx
        iny
        cpy     #$0020
        bne     @c122
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$0c: change character graphics index ]

; b1: actor index
; b2: new graphics index

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::CHANGE_CHAR_GFX
@c136:  ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $12
        clr_ax
        stz     $10
@c141:  lda     near wCharGfxDataBuf::CharID,x
        cmp     $12
        beq     @c156
        inc     $10
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @c141
        bra     @c16a
@c156:  iny
        lda     [zAnimScriptPtr],y
        sta     near wCharGfxDataBuf::GfxID,x     ; character graphics index
        lda     $10
        sta     near w7e7b78
        ldx     near wAnimThreadPtr
        phx
        jsl     UpdateStatusChangeAnim_far
        plx
@c16a:  ldy     zAnimScriptPtr
        iny2
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$0b: spc command ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::SOUND_CMD
@c171:  ldy     #1
        inc     near wSfxDisabled       ; disable sound effects
        clr_ax
@c179:  lda     [zAnimScriptPtr],y
        sta     $1300,x
        iny
        inx
        cpx     #3
        bne     @c179
        jsl     ExecSound_ext
        stz     near wSfxDisabled       ; enable sound effects
        ldy     zAnimScriptPtr
        iny3
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$0a: change battle bg ]

; unused

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::EVENT_ANIM_CMD_10
@c194:  ldy     #1
        lda     [zAnimScriptPtr],y                 ; battle bg index
        jsl     ChangeDanceBattleBG_far
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; character actions for vector directions (arms up) CHAR_ACTION enum
_c2c1a3:
        .byte   CHAR_ACTION::ARMS_RAISED_BACK
        .byte   CHAR_ACTION::ARMS_RAISED_DOWN
        .byte   CHAR_ACTION::ARMS_RAISED_DOWN
        .byte   CHAR_ACTION::ARMS_RAISED_FORWARD
        .byte   CHAR_ACTION::ARMS_RAISED_FORWARD
        .byte   CHAR_ACTION::ARMS_RAISED_UP
        .byte   CHAR_ACTION::ARMS_RAISED_UP
        .byte   CHAR_ACTION::ARMS_RAISED_BACK
        .byte   CHAR_ACTION::ARMS_RAISED_FORWARD
        .byte   CHAR_ACTION::ARMS_RAISED_DOWN
        .byte   CHAR_ACTION::ARMS_RAISED_DOWN
        .byte   CHAR_ACTION::ARMS_RAISED_BACK
        .byte   CHAR_ACTION::ARMS_RAISED_BACK
        .byte   CHAR_ACTION::ARMS_RAISED_UP
        .byte   CHAR_ACTION::ARMS_RAISED_UP
        .byte   CHAR_ACTION::ARMS_RAISED_FORWARD

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$09: update character action based on vector direction (arms up) ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::UPDATE_CHAR_VEC_DIR_JUMP
@c1b3:  jsl     _c1f999     ; calculate angle between points
        pha
        jsr     GetAttackerThreadPtr_near
        lda     near wAnimThread::w7e6f87,x
        beq     @c1c2       ; branch if not mirrored
        lda     #$08
@c1c2:  sta     $10
        pla
        lsr5
        clc
        adc     $10
        tax
        lda     f:_c2c1a3,x
        sta     near wCharGfxData::AnimAction,y
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$08: set vector target relative to attacker ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::CALC_VEC_REL
@c1d6:  stz     $11
        stz     $13
        ldy     #1
        lda     [zAnimScriptPtr],y
        bpl     @c1e3
        dec     $11
@c1e3:  sta     $10
        iny
        lda     [zAnimScriptPtr],y
        bpl     @c1ec
        dec     $13
@c1ec:  sta     $12
        longa
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f87,x
        and     #$00ff
@c1f9:  bne     @c215       ; branch if mirrored
        lda     near wAnimThread::AttackerPosX,x     ; attacker x position
        lda     near wAnimThread::TargetPosX,x     ; target x position
        clc
        adc     $10
        sta     near wAnimThread::TargetPosX,x     ; target x position
        lda     near wAnimThread::AttackerPosY,x     ; attacker y position
        lda     near wAnimThread::TargetPosY,x     ; target y position
        clc
        adc     $12
        sta     near wAnimThread::TargetPosY,x     ; target y position
        bra     @c22f
@c215:  lda     $10
        neg_a
        sta     $10
        lda     near wAnimThread::TargetPosX,x     ; target x position
        clc
        adc     $10
        sta     near wAnimThread::TargetPosX,x
        lda     near wAnimThread::TargetPosY,x
        clc
        adc     $12
        sta     near wAnimThread::TargetPosY,x
@c22f:  inc     zAnimScriptPtr
        inc     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; character actions for vector directions (walking) CHAR_ACTION enum
_c2c237:
        .byte   CHAR_ACTION::WALKING_BACK
        .byte   CHAR_ACTION::WALKING_DOWN
        .byte   CHAR_ACTION::WALKING_DOWN
        .byte   CHAR_ACTION::WALKING_FORWARD
        .byte   CHAR_ACTION::WALKING_FORWARD
        .byte   CHAR_ACTION::WALKING_UP
        .byte   CHAR_ACTION::WALKING_UP
        .byte   CHAR_ACTION::WALKING_BACK
        .byte   CHAR_ACTION::WALKING_FORWARD
        .byte   CHAR_ACTION::WALKING_DOWN
        .byte   CHAR_ACTION::WALKING_DOWN
        .byte   CHAR_ACTION::WALKING_BACK
        .byte   CHAR_ACTION::WALKING_BACK
        .byte   CHAR_ACTION::WALKING_UP
        .byte   CHAR_ACTION::WALKING_UP
        .byte   CHAR_ACTION::WALKING_FORWARD

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$07: update character action based on vector direction (walking) ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::UPDATE_CHAR_VEC_DIR_WALK
@c247:  jsl     _c1f999     ; calculate angle between points
        pha
        jsr     GetAttackerThreadPtr_near
        lda     near wAnimThread::w7e6f87,x
        beq     @c256
        lda     #$08
@c256:  sta     $10
        pla
        lsr5
        clc
        adc     $10
        tax
        lda     f:_c2c237,x
        sta     near wCharGfxData::AnimAction,y
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$06: move character ]

; b1: x position
; b2: y position

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::CHAR_POS
@c26a:  ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $10
        iny
        lda     [zAnimScriptPtr],y
        sta     $12
        stz     $11
        stz     $13
        jsr     GetAttackerThreadPtr_near
        longa
        lda     $10
        sta     near wCharGfxData::PosX,y     ; character x position
        clr_a
        sta     near wCharGfxData::OffsetX,y     ; character x offset
        sta     near wCharGfxData::AnimOffsetX,y     ; character x offset (animation)
        lda     $12
        sta     near wCharGfxData::PosY,y     ; character y position
        clr_a
        sta     near wCharGfxData::OffsetY,y
        sta     near wCharGfxData::JumpOffset,y
        inc     zAnimScriptPtr
        inc     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ get pointer to target thread data ]

GetTargetThreadPtr:
@c29f:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bra     _c2ad

; ------------------------------------------------------------------------------

; [ get pointer to attacker thread data ]

GetAttackerThreadPtr_near:
@c2a7:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
_c2ad:  asl5
        tay
        sty     near wAttackerThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$05: set vector target to actor position ]

; unused
; b1: actor index

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::EVENT_ANIM_CMD_5
@c2b7:  ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $10
        clr_ayx
@c2c1:  lda     near wCharGfxDataBuf::CharID,y
        cmp     $10
        beq     @c2d5       ; branch if it matches
        inx                 ; check next character
        tya
        clc
        adc     #$20
        tay
        cpx     #$0004
        bne     @c2c1
        clr_ax
@c2d5:  txa
        asl5
        tay
        ldx     near wAnimThreadPtr
        longa
        lda     near wCharGfxData::PosX,y     ; character x position
        clc
        adc     near wCharGfxData::OffsetX,y     ; character x offset
        clc
        adc     near wCharGfxData::AnimOffsetX,y     ; character x offset (animation)
        sta     near wAnimThread::TargetPosX,x     ; target x position
        lda     near wCharGfxData::PosY,y
        clc
        adc     near wCharGfxData::OffsetY,y
        clc
        adc     near wCharGfxData::JumpOffset,y
        sta     near wAnimThread::TargetPosY,x     ; target y position
        inc     zAnimScriptPtr
@c2ff:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$04: set saved attacking character position as target position ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::VEC_TO_ATTACKER_CHAR_POS
@c303:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        asl2
        tay
        longa
        lda     near w7e6236,y
        sta     near wAnimThread::TargetPosX,x
        lda     near w7e6236+2,y
        sta     near wAnimThread::TargetPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$02: save attacking character position ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::SAVE_ATTACKER_CHAR_POS
@c31e:  jsr     GetAttackerThreadPtr_near
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        asl2
        tax
        longa
        lda     near wCharGfxData::PosX,y     ; character x position
        sta     near w7e6236,x     ;
        lda     near wCharGfxData::PosY,y
        sta     near w7e6236+2,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$03: restore attacking character position and reset offsets ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::RESTORE_ATTACKER_CHAR_POS
@c339:  jsr     GetAttackerThreadPtr_near
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        asl2
        tax
        longa
        lda     near w7e6236,x
        sta     near wCharGfxData::PosX,y
        clr_a
        sta     near wCharGfxData::OffsetX,y     ; character x offset
        sta     near wCharGfxData::AnimOffsetX,y
        lda     near w7e6236+2,x
        sta     near wCharGfxData::PosY,y
        clr_a
        sta     near wCharGfxData::OffsetY,y
        sta     near wCharGfxData::JumpOffset,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$01: reset attacking character position offsets ]

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::RESET_CHAR_VEC_OFFSET
@c362:  jsr     GetAttackerThreadPtr_near
        longa
        lda     near wCharGfxData::PosX,y     ; character x position
        clc
        adc     near wCharGfxData::OffsetX,y     ; character x offset
        clc
        adc     near wCharGfxData::AnimOffsetX,y     ; character x offset (animation)
        sta     near wCharGfxData::PosX,y     ; character x position
        sta     near wAnimThread::AttackerPosX,x     ; attacker x position
        clr_a
        sta     near wCharGfxData::OffsetX,y     ; character x offset
        sta     near wCharGfxData::AnimOffsetX,y     ; character x offset (animation)
        lda     near wCharGfxData::PosY,y     ; character y position
        clc
        adc     near wCharGfxData::OffsetY,y     ; character y offset (animation)
        clc
        adc     near wCharGfxData::JumpOffset,y     ; character y offset (jumping)
        sta     near wCharGfxData::PosY,y     ; character y position
        sta     near wAnimThread::AttackerPosY,x     ; attacker y position
        clr_a
        sta     near wCharGfxData::OffsetY,y     ; character y offset (animation)
        sta     near wCharGfxData::JumpOffset,y     ; character y offset (jumping)
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7/$00: change attacking character facing direction ]

; b1: 0 = face left, 1 = face right

        array_label EVENT_ANIM_CMD, EVENT_ANIM_CMD::ATTACKER_CHAR_DIR
@c39b:  ldx     near wAnimThreadPtr
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        tay
        lda     [zAnimScriptPtr]
        beq     @c3bf
        lda     near w7e7b10,y     ; facing direction
        bne     @c3d1       ; branch if facing right
        inc
        sta     near w7e7b10,y     ; reverse direction
        sta     near wAnimThread::w7e6f87,x
        lda     near wAnimThread::AttackerIndex,x
        jsr     ToggleCharFlip_near
        bra     @c3d1
@c3bf:  lda     near w7e7b10,y
        beq     @c3d1
        clr_a
        sta     near w7e7b10,y
        sta     near wAnimThread::w7e6f87,x
        lda     near wAnimThread::AttackerIndex,x
        jsr     ToggleCharFlip_near
@c3d1:  ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ toggle horizontal flip ]

ToggleCharFlip_near:
@c3d5:  asl5
        tax
        lda     near wCharGfxData::Flip,x     ; toggle horizontal flip
        eor     #$40
        sta     near wCharGfxData::Flip,x
        rts

; ------------------------------------------------------------------------------
