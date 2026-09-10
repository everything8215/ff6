; .include "btlgfx/blitz_code.inc"

.import BlitzCode

; ------------------------------------------------------------------------------

; [ get pointer to current character slot data (battle menu) ]

_c16d56:
get_buf_input_poi:
@6d56:  lda     near w7e7b80
        and     #$03
        asl3
        tay
        rts

; ------------------------------------------------------------------------------

; unused ???

_c16d60:
@6d60:  .lobytes   +1, 0,-1,-1
        .lobytes   -1, 0,+1,-1
        .lobytes   +1, 0,+1,-1
        .lobytes   -1, 0,+1, 0

; ------------------------------------------------------------------------------

; [ validate selected target group ]

; return clear carry if no valid targets in group

ValidateSelTargetGrp:
@6d70:  and     #%11
        pha
        tax
        and     #%1
        beq     @6d86                   ; branch if monster targets
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        bra     @6d88
@6d86:  lda     z92
@6d88:  beq     @6d8d
        pla
        sec
        rts
@6d8d:  pla
        clc
        rts

; ------------------------------------------------------------------------------

; [ update menu state $38: target select ]

        array_label MENU_INPUT, MENU_INPUT::TARGET_SELECT
@6d90:  lda     near wCloseMenu
        jne     @6f57                   ; branch if closing menu
        lda     near w7e7a84
        and     #TARGET::AUTO_CONFIRM
        jne     @6f25                   ; branch if auto-confirm
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     near w7e7b7d
        bne     @6dbd                   ; branch if any characters are valid
        lda     z92
        and     near w7e7b7e
        jeq     @6f57                   ; branch if no monsters are valid
@6dbd:  lda     near w7e7a84                   ; copy targeting flags
        sta     $36
        bpl     @6dd1                   ; branch if not roulette cursor

; roulette cursor (character attacker)
        lda     near w7e62b4
        beq     @6dd4
        dec     near w7e62b2
        bne     @6e3d
        jmp     @6f25                   ; confirm target

; not roulette
@6dd1:  jmp     @6e40

; update roulette target
@6dd4:  lda     near w7e62b1
        beq     @6df6                   ; branch if roulette is not stopping yet
        lda     z0e
        and     #%111
        bne     @6e3d                   ;  every 8 frames (after pressing A)
        dec     near w7e62b2
        bne     @6dfc
        lda     #1
        sta     near w7e62b4
        lda     #$20
        sta     near w7e62b2
        lda     #1
        sta     near w7e7b7f                 ; this causes the cursor to flash
        jmp     @6f69
@6df6:  lda     z0e                     ; every 4 frames (before pressing A)
        and     #%11
        bne     @6e3d
@6dfc:  inc     z94                     ; cursor sound effect
        inc     near w7e62b3                 ; increment roulette target
        lda     near w7e62b3
        and     #%1000
        beq     @6e29

; roulette cursor on monster
        lda     near w7e62b3
        and     #%111
        tax
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     f:BitOrTbl,x
        beq     @6dfc                   ; try next monster
        sta     near w7e7b7d                 ; show cursor on character
        stz     near w7e7b7e
        jmp     @6f05

; roulette cursor on character
@6e29:  lda     near w7e62b3
        and     #%111
        tax
        lda     f:BitOrTbl,x
        and     z92
        beq     @6dfc                   ; try next character
        sta     near w7e7b7e
        stz     near w7e7b7d                 ; show cursor on monster
@6e3d:  jmp     @6f05

; one target group (seems to be bugged)
@6e40:  lda     $36
        andflg  TARGET, {INIT_MASK, MANUAL}
        cmp     #TARGET::INIT_GROUP
        bne     @6e82
        lda     z04 + 1
        and     #>(JOY_LEFT | JOY_RIGHT)
        beq     @6e82                   ; left or right not pressed
        inc     z94                     ; play sound effect
        lda     z04 + 1
        and     #>JOY_LEFT
        bne     @6e6c

; right button
        lda     near w7e7ace
        and     #>JOY_LEFT
        bne     @6e82
        lda     near w7e7ace
        inc2
        jsr     ValidateSelTargetGrp
        bcc     @6e82                   ; branch if no valid targets
        sta     near w7e7ace
        bra     @6e9a

; left button
@6e6c:  lda     near w7e7ace
        and     #>JOY_LEFT
        beq     @6e82
        lda     near w7e7ace
        dec2
        jsr     ValidateSelTargetGrp
        bcc     @6e82                   ; branch if no valid targets
        sta     near w7e7ace
        bra     @6e9a

; check if player can move target cursor manually
@6e82:  lda     $36
        and     #TARGET::MANUAL
        beq     @6f05

; check L and R buttons
        lda     z04
        and     #JOY_L | JOY_R
        beq     @6ed3
        cmp     #JOY_L | JOY_R
        beq     @6ed3                   ; branch if running away
        inc     z94                     ; play sound effect
        lda     $36
        and     #TARGET::MULTI_TARGET
        beq     @6ed3                   ; branch if no multi-target
@6e9a:  lda     near w7e7ace
        and     #$01
        beq     @6ebf                   ; branch if targeting monsters

; select all characters in target group
        lda     near w7e7ace
        tax
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     near w7e7b79,x
        sta     near w7e7b7d                   ; set characters with cursors shown
        lda     #$01
        sta     near w7e7b7f
        jmp     @6f05

; select all monsters in target group
@6ebf:  lda     near w7e7ace
        tax
        lda     z92
        and     near w7e7b79,x
        sta     near w7e7b7e                   ; set monsters with cursors shown
        lda     #$01
        sta     near w7e7b7f
        jmp     @6f05

; check directions
@6ed3:  lda     z04 + 1
        and     #>JOY_DIR_MASK
        beq     @6edb
        inc     z94                     ; play sound effect
@6edb:  lda     z04 + 1
        cmp     #>JOY_UP
        bne     @6ee7
        jsr     TargetSelectUp
        jmp     @6f05
@6ee7:  cmp     #>JOY_DOWN
        bne     @6ef1
        jsr     TargetSelectDown
        jmp     @6f05
@6ef1:  cmp     #>JOY_LEFT
        bne     @6efb
        jsr     TargetSelectLeft
        jmp     @6f05
@6efb:  cmp     #>JOY_RIGHT
        bne     @6f05
        jsr     TargetSelectRight
        jmp     @6f05

; check A button
@6f05:  lda     z04
        bpl     @6f4c
        inc     z96                     ; play sound effect
        lda     near w7e7a84
        bpl     @6f25                   ; branch if not roulette
        lda     near w7e62b1
        bne     @6f4c
        inc     near w7e62b1
        jsr     Rand                    ; random [8..15]
        and     #$07
        clc
        adc     #$08
        sta     near w7e62b2
        bra     @6f4c

; confirm the selected target
@6f25:  jsr     _c17096
        stz     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     near w7e7a83
        sta     near wMenuInput
        lda     near w7e7ae8
        beq     @6f45
        lda     near w7e7ae9
        bne     @6f45
        inc     near w7e7ae9
        rts

;
@6f45:  inc     near wCloseMenu
        inc     near w7e7b80
        rts

; check if selection cancelled
@6f4c:  lda     z08 + 1
        bpl     @6f69                   ; check B button
        lda     near w7e62b1
        bne     @6f69
        inc     z96                     ; play sound effect

; close menu
@6f57:  stz     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     near w7e7a83
        sta     near wMenuInput
        stz     near w7e7ae9
@6f69:  rts

; ------------------------------------------------------------------------------

; blitz code button masks
BlitzButtonMaskTbl:
@6f6a:  .word   near -1                 ; BLITZ_CODE::NONE
        .word   JOY_A                   ; BLITZ_CODE::A_BUTTON
        .word   JOY_B                   ; BLITZ_CODE::B_BUTTON
        .word   JOY_X                   ; BLITZ_CODE::X_BUTTON
        .word   JOY_Y                   ; BLITZ_CODE::Y_BUTTON
        .word   JOY_L                   ; BLITZ_CODE::L_BUTTON
        .word   JOY_R                   ; BLITZ_CODE::R_BUTTON
        .word   JOY_DOWN | JOY_LEFT     ; BLITZ_CODE::DOWN_LEFT
        .word   JOY_DOWN                ; BLITZ_CODE::DOWN
        .word   JOY_DOWN | JOY_RIGHT    ; BLITZ_CODE::DOWN_RIGHT
        .word   JOY_RIGHT               ; BLITZ_CODE::RIGHT
        .word   JOY_UP | JOY_RIGHT      ; BLITZ_CODE::UP_RIGHT
        .word   JOY_UP                  ; BLITZ_CODE::UP
        .word   JOY_UP | JOY_LEFT       ; BLITZ_CODE::UP_LEFT
        .word   JOY_LEFT                ; BLITZ_CODE::LEFT

        .scope BlitzCode
                COUNT                           = 8
                ITEM_SIZE                       = 12
        .endscope

; pointers to blitz codes
BlitzCodePtrs:
@6f88:  .repeat BlitzCode::COUNT, i
        .byte   i * BlitzCode::ITEM_SIZE
        .endrep

; ------------------------------------------------------------------------------

; [ check blitz code ]

CheckBlitzCode:
@6f90:  stz     $36                     ; current blitz index being checked
@6f92:  lda     $36
        tax
        lda     f:BlitzCodePtrs,x
        tax
        lda     f:BlitzCode+11,x        ; length of code
        dec2
        longa
        sta     $38
        clr_ay
@6fa6:  lda     f:BlitzCode,x           ; blitz codes
        and     #$00ff
        asl
        phx
        tax
        lda     f:BlitzButtonMaskTbl,x
        sta     near w7eea1e,y
        plx
        iny2
        inx
        cpy     #$0014
        bne     @6fa6
        clr_ay
@6fc2:  lda     near w7eea1e,y
        sta     $2c
        lda     near w7ee9fe,y
        and     $2c
        beq     @6fea                   ; branch if button masks don't match
        iny2
        cpy     $38
        bne     @6fc2                   ; branch if this was not the last button
        lda     near w7ee9fe-2,y
        and     #JOY_A
        bne     @6fe4                   ; branch if the A button was not pressed
        lda     near w7ee9fe,y
        and     #JOY_A
        beq     @6fea
@6fe4:  clr_a                           ; success, use this blitz code
        shorta
        lda     $36
        rts
@6fea:  clr_a                           ; next blitz code
        shorta
        inc     $36
        lda     $36
        cmp     #8                      ; check 8 blitzes
        bne     @6f92
        lda     #$ff                    ; no codes matched
        rts

; ------------------------------------------------------------------------------

; [ update menu state $3d: blitz input ]

        array_label MENU_INPUT, MENU_INPUT::BLITZ_INPUT
@6ff8:  lda     near wCloseMenu
        beq     @7000
        jmp     @7083
@7000:  ldx     z0a
        beq     @702c       ; branch if no buttons are pressed
        ldx     z0a
        cpx     near w7ee9e2
        beq     @7034       ; branch if buttons didn't change from last frame
        lda     #$40
        sta     near w7ee9e4       ; reset blitz code counter to 64 frames
        lda     near w7ee9e1
        and     #$0f
        asl
        tax
        inc     near w7ee9e1       ; increment blitz button input pointer
        longa
        lda     z0a
        sta     near w7ee9e2       ; combine buttons pressed this frame and buttons pressed last frame
        ora     near w7ee9fe,x
        sta     near w7ee9fe,x     ; save button input
        shorta0
        bra     @7034
@702c:  stx     near w7ee9e2
        lda     #$01
        sta     near w7ee9e5
@7034:  dec     near w7ee9e4       ; decrement blitz code counter
        bne     @703e       ; branch if it didn't expire
        clr_ax
        stx     near w7ee9fe       ; clear the first button input to invalidate the entire combo
@703e:  lda     near w7e6268
        bpl     @707c       ; branch if a button is not pressed
        inc     z96         ; play cursor sound effect (select)
        jsr     CheckBlitzCode
        sta     near w7e6168
        jsr     _c16d56
        lda     near w7e6168
        sta     near wPlayerActionBuf::Attack,y
        lda     near w7e7b7d
        sta     near wPlayerActionBuf::Targets,y      ; character targets
        lda     near w7e7b7e
        sta     near wPlayerActionBuf::Targets + 1,y  ; monster targets
        lda     near w7e62ca
        sta     near wPlayerActionBuf::CharSlot,y
        stz     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     near w7e7a83
        sta     near wMenuInput
        inc     near wCloseMenu
        inc     near w7e7b80
        rts
@707c:  lda     near w7e6268+1
        bpl     @7095       ; branch if b button is not pressed
        inc     z96
@7083:  stz     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     near w7e7a83
        sta     near wMenuInput
        stz     near w7e7ae9
@7095:  rts

; ------------------------------------------------------------------------------

; [  ]

_c17096:
set_target_data:
@7096:  jsr     _c16d56
        lda     near w7e7ae9
        beq     @70d3
        lda     near w7e7a85
        sta     near wPlayerActionBuf::SecondAttack,y
        lda     near w7e2f47
        beq     @70c0
        lda     near w7e7b7e
        and     #$20
        beq     @70b3
        lda     near w7e2f47
@70b3:  ora     near w7e7b7d
        sta     near wPlayerActionBuf::SecondTargets,y
        lda     near w7e7b7e
        and     #$1f
        bra     @70c9
@70c0:  lda     near w7e7b7d
        sta     near wPlayerActionBuf::SecondTargets,y
        lda     near w7e7b7e
@70c9:  sta     near wPlayerActionBuf::SecondTargets + 1,y
        lda     near w7e62ca
        sta     near wPlayerActionBuf::CharSlot,y
        rts
@70d3:  lda     near w7e7a85
        sta     near wPlayerActionBuf::Attack,y
        lda     near w7e2f47
        beq     @70f5
        lda     near w7e7b7e
        and     #$20
        beq     @70e8
        lda     near w7e2f47
@70e8:  ora     near w7e7b7d
        sta     near wPlayerActionBuf::Targets,y
        lda     near w7e7b7e
        and     #$1f
        bra     @70fe
@70f5:  lda     near w7e7b7d
        sta     near wPlayerActionBuf::Targets,y
        lda     near w7e7b7e
@70fe:  sta     near wPlayerActionBuf::Targets + 1,y
        lda     near w7e7ae8
        bne     @710c
        lda     near w7e62ca
        sta     near wPlayerActionBuf::CharSlot,y
@710c:  lda     near wPlayerActionBuf::BattleCmd,y
        cmp     #BATTLE_CMD::THROW
        beq     @7117
        cmp     #BATTLE_CMD::ITEM
        bne     @7133

; throw or item
@7117:  lda     near w7e7a1e
        beq     @7167
        jsr     _c18e48
        ldy     near w7e62ca
        lda     near w7e894b,y
        and     #$01
        beq     @7148

; decrement left-hand item quantity
        lda     near wLHandItemList::Qty,x
        cmp     #2
        bcc     @7134
        dec     near wLHandItemList::Qty,x
@7133:  rts
@7134:  lda     #ITEM::UNARMED
        sta     near wLHandItemList::ItemID,x
        lda     #$80
        sta     near wLHandItemList::UsageFlags,x
        stz     near wLHandItemList::Targeting,x
        stz     near wLHandItemList::Qty,x
        stz     near wLHandItemList::EquipFlags,x
        rts

; decrement right-hand item quantity
@7148:  lda     near wRHandItemList::Qty,x
        cmp     #2
        bcc     @7153
        dec     near wRHandItemList::Qty,x
        rts
@7153:  lda     #ITEM::UNARMED
        sta     near wRHandItemList::ItemID,x
        lda     #$80
        sta     near wRHandItemList::UsageFlags,x
        stz     near wRHandItemList::Targeting,x
        stz     near wRHandItemList::Qty,x
        stz     near wRHandItemList::EquipFlags,x
        rts

; decrement inventory item quantity
@7167:  clr_ax
        lda     near wPlayerActionBuf::Attack,y
@716c:  cmp     near wItemList::ItemID,x
        beq     @717c
        inx5
        cpx     #$0500
        bne     @716c
        rts
@717c:  lda     near wItemList::Qty,x
        cmp     #2
        bcc     @7187
        dec     near wItemList::Qty,x
        rts
@7187:  lda     #ITEM::EMPTY
        sta     near wItemList::ItemID,x
        lda     #$80
        sta     near wItemList::UsageFlags,x
        stz     near wItemList::Targeting,x
        stz     near wItemList::Qty,x
        stz     near wItemList::EquipFlags,x
        rts

; ------------------------------------------------------------------------------

; [  ]

GetAttackerCursorPosition:
@719b:  lda     #$ff
        sta     z73
        sta     z74
        sta     z75
        jsr     _c17372
        asl
        tax
        longa
        lda     near w7e800f,x
        lsr3
        sta     $36
        lda     near w7e801b,x
        lsr3
        sta     $38
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

GetTargetCursorPosition:
@71be:  lda     near w7e7ace
        tax
        lda     near w7e7b79,x
        pha
        tya
        clc
        adc     f:_c17767,x
        tax
        lda     near w7e7a86,x
        tax
        pla
        and     z92
        and     f:TargetMaskTbl,x
        beq     @71ea
        lda     near w7e7ace
        tax
        tya
        clc
        adc     f:_c17767,x
        tax
        lda     near w7e7a86,x
        bpl     @71ec
@71ea:  clc
        rts
@71ec:  asl
        tax
        longa
        lda     near w7e800f,x
        lsr3
        sta     $3a
        lda     near w7e801b,x
        lsr3
        sta     $3c
        lda     $3a
        sec
        sbc     $36
        sta     $3e
        lda     $3c
        sec
        sbc     $38
        sta     $40
        shorta0
        sec
        rts

; ------------------------------------------------------------------------------

; [ get index of last monster ??? ]

_c17213:
get_mon_length:
@7213:  longa
        lda     $3e
        bpl     @721f
        neg_a
        sta     $3e
@721f:  lda     $40
        bpl     @7229
        neg_a
        sta     $40
@7229:  shorta0
        lda     $3e
        sta     $2c
        sta     $2e
        jsr     Mult8NoHW
        ldx     $30
        phx
        lda     $40
        sta     $2c
        sta     $2e
        jsr     Mult8NoHW
        longa
        pla
        clc
        adc     $30
        cmp     z73
        bcs     @7254
        sta     z73
        shorta0
        tya
        sta     z75
        rts
@7254:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ select the next monster up ]

SelectMonsterUp:
@7258:  jsr     GetAttackerCursorPosition
        clr_ay
@725d:  jsr     GetTargetCursorPosition
        bcs     @726c
@7262:  shorta0
        iny
        cpy     #6
        bne     @725d
        rts
@726c:  longa
        lda     $40
        bpl     @7262
        lda     $3e
        bpl     @7280
        lda     $40
        cmp     $3e
        beq     @7289
        bcc     @7289
        bra     @7262
@7280:  lda     $40
        clc
        adc     $3e
        beq     @7289
        bpl     @7262
@7289:  shorta0
        jsr     _c17213
        jmp     @7262

; ------------------------------------------------------------------------------

; [ select the next monster down ]

SelectMonsterDown:
@7292:  jsr     GetAttackerCursorPosition
        clr_ay
@7297:  jsr     GetTargetCursorPosition
        bcs     @72a6
@729c:  shorta0
        iny
        cpy     #6
        bne     @7297
        rts
@72a6:  longa
        lda     $40
        beq     @729c
        bmi     @729c
        lda     $3e
        bmi     @72bc
        lda     $3e
        cmp     $40
        bcc     @72c5
        beq     @72c5
        bra     @729c
@72bc:  lda     $40
        clc
        adc     $3e
        beq     @72c5
        bmi     @729c
@72c5:  shorta0
        jsr     _c17213
        jmp     @729c

; ------------------------------------------------------------------------------

; [ select the next monster to the left ]

SelectMonsterLeft:
@72ce:  jsr     GetAttackerCursorPosition
        clr_ay
@72d3:  jsr     GetTargetCursorPosition
        bcs     @72e2
@72d8:  shorta0
        iny
        cpy     #6
        bne     @72d3
        rts
@72e2:  longa
        lda     $3e
        bpl     @72d8
        lda     $40
        bpl     @72f6
        lda     $3e
        cmp     $40
        bcc     @72ff
        beq     @72ff
        bra     @72d8
@72f6:  lda     $40
        clc
        adc     $3e
        beq     @72ff
        bpl     @72d8
@72ff:  shorta0
        jsr     _c17213
        jmp     @72d8

; ------------------------------------------------------------------------------

; [ select the next monster to the right ]

SelectMonsterRight:
@7308:  jsr     GetAttackerCursorPosition
        clr_ay
@730d:  jsr     GetTargetCursorPosition
        bcs     @731c
@7312:  shorta0
        iny
        cpy     #6
        bne     @730d
        rts
@731c:  longa
        lda     $3e
        beq     @7312
        bmi     @7312
        lda     $40
        bmi     @7332
        lda     $40
        cmp     $3e
        beq     @733b
        bcc     @733b
        bra     @7312
@7332:  lda     $40
        clc
        adc     $3e
        beq     @733b
        bmi     @7312
@733b:  shorta0
        jsr     _c17213
        jmp     @7312

; ------------------------------------------------------------------------------

; [ select the next character down ]

SelectCharDown:
@7344:  lda     near w7e7acf
        inc
        and     #$03
        sta     near w7e7acf
        bne     @7359
        lda     near w7e7ace
        inc2
        and     #$03
        sta     near w7e7ace
@7359:  rts

; ------------------------------------------------------------------------------

; [ select next character up ]

SelectCharUp:
@735a:  lda     near w7e7acf
        dec
        and     #$03
        sta     near w7e7acf
        cmp     #$03
        bne     @7371
        lda     near w7e7ace
        dec2
        and     #$03
        sta     near w7e7ace
@7371:  rts

; ------------------------------------------------------------------------------

; [  ]

_c17372:
get_no:
@7372:  lda     near w7e7ace
        tay
        tax
        lda     f:_c17767,x
        clc
        adc     near w7e7acf
        tax
        lda     near w7e7a86,x
        rts

; ------------------------------------------------------------------------------

; [  ]

TargetSelectUp:
@7384:  lda     near w7e7ace
        and     #$01
        beq     @73b3
@738b:  jsr     SelectCharUp
        jsr     _c17372
        bmi     @738b
        tax
        lda     near w7e7b79,y
        and     f:TargetMaskTbl,x
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @738b
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        rts
@73b3:  jsr     SelectMonsterUp
        lda     z75
        cmp     #$ff
        beq     @73d5
        sta     near w7e7acf
        jsr     _c17372
        tax
        lda     near w7e7b79,y
        and     z92
        and     f:TargetMaskTbl,x
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
@73d5:  rts

; ------------------------------------------------------------------------------

; [  ]

TargetSelectDown:
@73d6:  lda     near w7e7ace
        and     #$01
        beq     @7405
@73dd:  jsr     SelectCharDown
        jsr     _c17372
        bmi     @73dd
        tax
        lda     near w7e7b79,y
        and     f:TargetMaskTbl,x
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @73dd
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        rts
@7405:  jsr     SelectMonsterDown
        lda     z75
        cmp     #$ff
        beq     @7427
        sta     near w7e7acf
        jsr     _c17372
        tax
        lda     near w7e7b79,y
        and     z92
        and     f:TargetMaskTbl,x
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
@7427:  rts

; ------------------------------------------------------------------------------

.enum CHAR_TARGET_SELECT_LEFT
        COUNT = BATTLE_TYPE::COUNT
.endenum

; move character target left jump table (1 per battle type)
CharTargetSelectLeftTbl:
        ptr_tbl CHAR_TARGET_SELECT_LEFT

.enum CHAR_TARGET_SELECT_RIGHT
        COUNT = BATTLE_TYPE::COUNT
.endenum

; move character target right jump table (1 per battle type)
CharTargetSelectRightTbl:
        ptr_tbl CHAR_TARGET_SELECT_RIGHT

; ------------------------------------------------------------------------------

; [ move character target right (normal battle) ]

        array_label CHAR_TARGET_SELECT_RIGHT, BATTLE_TYPE::NORMAL
@7438:  rts

; ------------------------------------------------------------------------------

; [ move character target right (back/pincer attack) ]

        array_label CHAR_TARGET_SELECT_RIGHT, BATTLE_TYPE::BACK
        array_label CHAR_TARGET_SELECT_RIGHT, BATTLE_TYPE::PINCER
@7439:  lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @745d                   ; branch if can't target opposite side
        lda     near w7e7b7b
        and     z92
        beq     @745d
        inc     near w7e7ace                   ; next target group to the right
        jsr     _c17934
        bcc     @745d
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        rts
@745d:  lda     #$01                    ; go to character target group
        sta     near w7e7ace
        rts

; ------------------------------------------------------------------------------

; [ move character target right (side attack) ]

        array_label CHAR_TARGET_SELECT_RIGHT, BATTLE_TYPE::SIDE
@7463:  lda     near w7e7ace
        cmp     #$03
        beq     @74be
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @7490
        lda     near w7e7b7b
        and     z92
        beq     @7490
        lda     #$02
        sta     near w7e7ace
        jsr     _c17934
        bcc     @74b9
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        rts
@7490:  lda     near w7e7b7c
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @74b9
        lda     #$03
        sta     near w7e7ace
        jsr     _c17958
        bcc     @74b9
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        rts
@74b9:  lda     #$01
        sta     near w7e7ace
@74be:  rts

; ------------------------------------------------------------------------------

; [ move character target left (normal/pincer attack) ]

        array_label CHAR_TARGET_SELECT_LEFT, BATTLE_TYPE::NORMAL
        array_label CHAR_TARGET_SELECT_LEFT, BATTLE_TYPE::PINCER
@74bf:  lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @74e3
        lda     near w7e7b79
        and     z92
        beq     @74e3
        dec     near w7e7ace
        jsr     _c17922
        bcc     @74e3
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        rts
@74e3:  lda     #$01
        sta     near w7e7ace
        rts

; ------------------------------------------------------------------------------

; [ move character target left (back attack) ]
        array_label CHAR_TARGET_SELECT_LEFT, BATTLE_TYPE::BACK
@74e9:  rts

; ------------------------------------------------------------------------------

; [ move character target left (side attack) ]

        array_label CHAR_TARGET_SELECT_LEFT, BATTLE_TYPE::SIDE
@74ea:  lda     near w7e7ace
        cmp     #$01
        beq     @7543                   ; return if on left side characters
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @7515
        lda     near w7e7b7b
        and     z92
        beq     @7515
        dec     near w7e7ace
        jsr     _c1793a
        bcc     @753e
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        rts
@7515:  lda     near w7e7b7a
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @753e
        lda     #$01                    ; target characters on the left
        sta     near w7e7ace
        jsr     _c17940
        bcc     @753e
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        rts
@753e:  lda     #$03                    ; target characters on the right
        sta     near w7e7ace
@7543:  rts

; ------------------------------------------------------------------------------

.enum MONSTER_TARGET_SELECT_LEFT
        COUNT = BATTLE_TYPE::COUNT
.endenum

; move monster target left jump table (1 per battle type)
MonsterTargetSelectLeftTbl:
        ptr_tbl MONSTER_TARGET_SELECT_LEFT

.enum MONSTER_TARGET_SELECT_RIGHT
        COUNT = BATTLE_TYPE::COUNT
.endenum

; move monster target right jump table (1 per battle type)
MonsterTargetSelectRightTbl:
        ptr_tbl MONSTER_TARGET_SELECT_RIGHT

; ------------------------------------------------------------------------------

; [ find next monster target to the right ]

_c17554:
get_r_mon_set:
@7554:  jsr     SelectMonsterRight
        lda     z75
        cmp     #$ff
        beq     @7578
        sta     near w7e7acf
        jsr     _c17372
        tax
        lda     near w7e7b79,y
        and     f:TargetMaskTbl,x
        and     z92
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        sec
        rts
@7578:  clc
        rts

; ------------------------------------------------------------------------------

; [ find next monster target to the left ]

_c1757a:
get_l_mon_set:
@757a:  jsr     SelectMonsterLeft
        lda     z75
        cmp     #$ff
        beq     @759e
        sta     near w7e7acf
        jsr     _c17372
        tax
        lda     near w7e7b79,y
        and     f:TargetMaskTbl,x
        and     z92
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        sec
        rts
@759e:  clc
        rts

; ------------------------------------------------------------------------------

; [ move monster target right (back attack) ]

        array_label MONSTER_TARGET_SELECT_RIGHT, BATTLE_TYPE::BACK
@75a0:  jmp     _c17554

; ------------------------------------------------------------------------------

; [ move monster target right (normal battle) ]

        array_label MONSTER_TARGET_SELECT_RIGHT, BATTLE_TYPE::NORMAL
@75a3:  jsr     _c17554
        bcs     @75d7
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @75d7                   ; branch if can't change target group
        lda     near w7e7b7a
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @75d7
        jsr     _c17940
        bcc     @75d7
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     #$01
        sta     near w7e7ace
        txa
        sta     near w7e7acf
@75d7:  rts

; ------------------------------------------------------------------------------

; [ move monster target right (pincer attack) ]

        array_label MONSTER_TARGET_SELECT_RIGHT, BATTLE_TYPE::PINCER
@75d8:  jsr     _c17554
        bcs     @7630
        lda     near w7e7ace
        bne     @7630
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @7612
        lda     near w7e7b7a
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @7612
        jsr     _c17940
        bcc     @7612
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     #$01
        sta     near w7e7ace
        txa
        sta     near w7e7acf
        rts
@7612:  lda     near w7e7b7b
        and     z92
        beq     @7630
        jsr     _c17934
        bcc     @7630
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        txa
        sta     near w7e7acf
        lda     #$02
        sta     near w7e7ace
@7630:  rts

; ------------------------------------------------------------------------------

; [ move monster target right (side attack) ]

        array_label MONSTER_TARGET_SELECT_RIGHT, BATTLE_TYPE::SIDE
@7631:  jsr     _c17554
        bcs     @7665
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @7665
        lda     near w7e7b7c
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @7665
        jsr     _c17958
        bcc     @7665
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     #$03
        sta     near w7e7ace
        txa
        sta     near w7e7acf
@7665:  rts

; ------------------------------------------------------------------------------

; [ move monster target left (normal battle) ]

        array_label MONSTER_TARGET_SELECT_LEFT, BATTLE_TYPE::NORMAL
@7666:  jmp     _c1757a

; ------------------------------------------------------------------------------

; [ move monster target left (back attack) ]

        array_label MONSTER_TARGET_SELECT_LEFT, BATTLE_TYPE::BACK
@7669:  jsr     _c1757a
        bcs     @76a1
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @76a1
        lda     near w7e7b7a
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @76a1
        dec     near w7e7ace
        jsr     _c17940
        bcc     @76a1
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     #$01
        sta     near w7e7ace
        txa
        sta     near w7e7acf
        rts
@76a1:  lda     #$02
        sta     near w7e7ace
        rts

; ------------------------------------------------------------------------------

; [ move monster target left (pincer attack) ]

        array_label MONSTER_TARGET_SELECT_LEFT, BATTLE_TYPE::PINCER
@76a7:  jsr     _c1757a
        bcs     @76fd
        lda     near w7e7ace
        beq     @76fd
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @76e1
        lda     near w7e7b7a
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @76e1
        jsr     _c17940
        bcc     @76e1
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     #$01
        sta     near w7e7ace
        txa
        sta     near w7e7acf
        rts
@76e1:  lda     near w7e7b79
        and     z92
        beq     @76fd
        jsr     _c17922
        bcc     @76fd
        sta     near w7e7b7e
        stz     near w7e7b7d
        stz     near w7e7b7f
        stz     near w7e7ace
        txa
        sta     near w7e7acf
@76fd:  rts

; ------------------------------------------------------------------------------

; [ move monster target left (side attack) ]

        array_label MONSTER_TARGET_SELECT_LEFT, BATTLE_TYPE::SIDE
@76fe:  jsr     _c1757a
        bcs     @7732
        lda     near w7e7a84
        and     #TARGET::ONE_SIDE
        bne     @7732
        lda     near w7e7b7a
        and     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        beq     @7732
        jsr     _c17940
        bcc     @7732
        sta     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        lda     #$01
        sta     near w7e7ace
        txa
        sta     near w7e7acf
@7732:  rts

; ------------------------------------------------------------------------------

; [  ]

TargetSelectLeft:
key_target_left:
@7733:  lda     near w7e7ace
        and     #$01
        beq     @7742
        lda     near w7e201f       ; battle type
        asl
        tax
        jmp     (near CharTargetSelectLeftTbl,x)
@7742:  lda     near w7e201f
        asl
        tax
        jmp     (near MonsterTargetSelectLeftTbl,x)

; ------------------------------------------------------------------------------

; [  ]

TargetSelectRight:
key_target_right:
@774a:  lda     near w7e7ace
        and     #$01
        beq     @7759
        lda     near w7e201f       ; battle type
        asl
        tax
        jmp     (near CharTargetSelectRightTbl,x)
@7759:  lda     near w7e201f
        asl
        tax
        jmp     (near MonsterTargetSelectRightTbl,x)

; ------------------------------------------------------------------------------

; bit mask for each monster
TargetMaskTbl:
@7761:  .byte   $01,$02,$04,$08,$10,$20

;
_c17767:
@7767:  .byte   0,6,12,18

; ------------------------------------------------------------------------------

; [ init blitz input ]

InitBlitzInput:
@776b:  ldx     z0a
        stx     near w7ee9e2
        lda     #$ff
        sta     near w7ee9e4
        stz     near w7ee9e5
        clr_ax
@777a:  stz     near w7ee9fe,x                 ; clear blitz inputs
        inx
        cpx     #$0020
        bne     @777a
        stz     near w7ee9e1
        stz     near w7e6168
        lda     #TARGET::SELF
        sta     near w7e7a84
        lda     #MENU_INPUT::BLITZ_INPUT
        bra     _7797

; ------------------------------------------------------------------------------

; [ init target cursor select ]

InitAttackTargetSelect:
@7792:  stz     near w7e2f41       ; start battle time

InitTargetSelect:
@7795:  lda     #MENU_INPUT::TARGET_SELECT

key_target_2:
_7797:  pha
        inc     near w7e7b6b
        lda     near wMenuInput
        sta     near w7e7a83
        stz     near w7e7b7d
        stz     near w7e7b7e
        stz     near w7e7b7f
        stz     near w7e7ace
        stz     near w7e7acf
        stz     near w7e62b1
        stz     near w7e62b2
        stz     near w7e62b4
        lda     near w7e7a84
        bmi     @77c4                   ; branch if roulette cursor
        sta     $36
        cmp     #TARGET::SELF
        bne     @77d1

; self-target or roulette
@77c4:  ldx     near w7e62ca                   ; set target to active character
        lda     f:TargetMaskTbl,x
        sta     near w7e7b7d
        jmp     @7901

; init all characters or monsters
@77d1:  lda     $36
        and     #$0c
        cmp     #TARGET::INIT_HALF
        bne     @77ff
        lda     $36
        and     #TARGET::ENEMY
        beq     @77ea
        lda     z92
        sta     near w7e7b7e                   ; target all monsters
        inc     near w7e7b7f
        jmp     @7901
@77ea:  lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        sta     near w7e7b7d                   ; target all characters
        inc     near w7e7b7f
        jmp     @7901

; init all characters and all monsters
@77ff:  cmp     #TARGET::INIT_ALL
        bne     @781d
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        sta     near w7e7b7d
        lda     z92
        sta     near w7e7b7e
        inc     near w7e7b7f
        jmp     @7901

; init single target group
@781d:  lda     $36
        and     #$0c
        cmp     #TARGET::INIT_GROUP
        bne     @789b
        lda     $36
        and     #TARGET::ENEMY
        bne     @7875                   ; branch if target monsters by default
        clr_ax
        lda     near w7e62ca
@7830:  cmp     near w7e7a8c,x
        beq     @7858
        inx
        cpx     #4
        bne     @7830
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     near w7e7b7c
        sta     near w7e7b7d
        inc     near w7e7b7f
        lda     #$03
        sta     near w7e7ace
        jmp     @7901
@7858:  lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     near w7e7b7a
        sta     near w7e7b7d
        inc     near w7e7b7f
        lda     #$01
        sta     near w7e7ace
        jmp     @7901
@7875:  lda     z92
        and     near w7e7b79
        beq     @7888
        sta     near w7e7b7e
        inc     near w7e7b7f
        stz     near w7e7ace
        jmp     @7901
@7888:  lda     z92
        and     near w7e7b7b
        sta     near w7e7b7e
        inc     near w7e7b7f
        lda     #$02
        sta     near w7e7ace
        jmp     @7901

; init single target
@789b:  lda     $36
        and     #TARGET::ENEMY
        bne     @78dd
        clr_ax
        lda     near w7e62ca
@78a6:  cmp     near w7e7a8c,x                 ; find character on the left
        beq     @78c7
        inx
        cpx     #4
        bne     @78a6
        ldx     near w7e62ca
        lda     f:TargetMaskTbl,x
        sta     near w7e7b7d
        lda     #$03
        sta     near w7e7ace
        txa
        sta     near w7e7acf
        jmp     @7901
@78c7:  ldx     near w7e62ca
        lda     f:TargetMaskTbl,x
        sta     near w7e7b7d
        lda     #$01                    ; target group is characters on the left
        sta     near w7e7ace
        txa
        sta     near w7e7acf
        jmp     @7901

; single monster target
@78dd:  jsr     _c17922
        bcs     @78f4
        jsr     _c17934
        sta     near w7e7b7e
        lda     #$02
        sta     near w7e7ace
        txa
        sta     near w7e7acf
        jmp     @7901
@78f4:  sta     near w7e7b7e
        stz     near w7e7ace
        txa
        sta     near w7e7acf
        jmp     @7901

@7901:  lda     near w7e7a84
        and     #TARGET::AUTO_CONFIRM
        beq     @790b
        stz     near w7e7b7f
@790b:  pla
        sta     near wMenuInput
        rts

; ------------------------------------------------------------------------------

; unused
get_gr0_up_bit:
@7910:  ldx     #near w7e7aaa
        jmp     _c17970

; ------------------------------------------------------------------------------

; unused
get_gr0_down_bit:
@7916:  ldx     #near w7e7ab0
        jmp     _c17970

; ------------------------------------------------------------------------------

; unused
get_gr0_left_bit:
@791c:  ldx     #near w7e7a9e
        jmp     _c17970

; ------------------------------------------------------------------------------

; [ find monster target on the left, coming from the right ]

_c17922:
get_gr0_right_bit:
@7922:  ldx     #near w7e7aa4
        jmp     _c17970

; ------------------------------------------------------------------------------

; unused
get_gr2_up_bit:
@7928:  ldx     #near w7e7aaa
        jmp     _c1799c

; ------------------------------------------------------------------------------

; unused
get_gr2_down_bit:
@792e:  ldx     #near w7e7ab0
        jmp     _c1799c

; ------------------------------------------------------------------------------

; [ find monster target on the right, coming from the left ]

_c17934:
get_gr2_left_bit:
@7934:  ldx     #near w7e7a9e
        jmp     _c1799c

; ------------------------------------------------------------------------------

; [ find monster target on the right, coming from the right ]

_c1793a:
get_gr2_right_bit:
@793a:  ldx     #near w7e7aa4
        jmp     _c1799c

; ------------------------------------------------------------------------------

; [ find character target on the left ]

_c17940:
get_gr1_up_bit:
@7940:  ldx     #near w7e7ac2
        jmp     _c179c8

; ------------------------------------------------------------------------------

; unused
get_gr1_down_bit:
@7946:  ldx     #near w7e7ac8
        jmp     _c179c8

; ------------------------------------------------------------------------------

; unused
get_gr1_left_bit:
@794c:  ldx     #near w7e7ab6
        jmp     _c179c8

; ------------------------------------------------------------------------------

; unused
get_gr1_right_bit:
@7952:  ldx     #near w7e7ab6                  ; *** bug *** (this should be $7abc)
        jmp     _c179c8

; ------------------------------------------------------------------------------

; [ find character target on the right ]

_c17958:
get_gr3_up_bit:
@7958:  ldx     #near w7e7ac2
        jmp     _c17a00

; ------------------------------------------------------------------------------

; unused
get_gr3_down_bit:
@795e:  ldx     #near w7e7ac8
        jmp     _c17a00

; ------------------------------------------------------------------------------

; unused
get_gr3_left_bit:
@7964:  ldx     #near w7e7ab6
        jmp     _c17a00

; ------------------------------------------------------------------------------

; unused
get_gr3_right_bit:
@796a:  ldx     #near w7e7ab6                  ; *** bug *** (this should be $7abc)
        jmp     _c17a00

; ------------------------------------------------------------------------------

; [ find monster target on the left ]

_c17970:
get_gr0:
@7970:  stx     $3a
        clr_ay
@7974:  clr_ax
        lda     ($3a),y
        bmi     @7985
@797a:  cmp     near w7e7a86,x
        beq     @798d
@797f:  inx
        cpx     #6
        bne     @797a
@7985:  iny
        cpy     #6
        bne     @7974
        clc
        rts
@798d:  stx     $36
        tax
        lda     z92
        and     f:TargetMaskTbl,x
        beq     @797f
        ldx     $36
        sec
        rts

; ------------------------------------------------------------------------------

; [ find monster target on the right ]

_c1799c:
get_gr2:
@799c:  stx     $3a
        clr_ay
@79a0:  clr_ax
        lda     ($3a),y
        bmi     @79b1
@79a6:  cmp     near w7e7a92,x
        beq     @79b9
@79ab:  inx
        cpx     #6
        bne     @79a6
@79b1:  iny
        cpy     #6
        bne     @79a0
        clc
        rts
@79b9:  stx     $36
        tax
        lda     z92
        and     f:TargetMaskTbl,x
        beq     @79ab
        ldx     $36
        sec
        rts

; ------------------------------------------------------------------------------

; [ find character target on the left ]

_c179c8:
get_gr1:
@79c8:  stx     $3a
        clr_ay
@79cc:  clr_ax
        lda     ($3a),y
        bmi     @79df
@79d2:  cmp     near w7e7a8c,x
        beq     @79e7
@79d7:  asl     $38
        inx
        cpx     #6
        bne     @79d2
@79df:  iny
        cpy     #6
        bne     @79cc
        clc
        rts
@79e7:  stx     $36
        tax
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     f:TargetMaskTbl,x
        beq     @79d7
        ldx     $36
        sec
        rts

; ------------------------------------------------------------------------------

; [ find character target on the right ]

_c17a00:
get_gr3:
@7a00:  stx     $3a
        clr_ay
@7a04:  clr_ax
        lda     ($3a),y
        bmi     @7a15
@7a0a:  cmp     near w7e7a98,x
        beq     @7a1d
@7a0f:  inx
        cpx     #6
        bne     @7a0a
@7a15:  iny
        cpy     #6
        bne     @7a04
        clc
        rts
@7a1d:  stx     $36
        tax
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     f:TargetMaskTbl,x
        beq     @7a0f
        ldx     $36
        sec
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

; command list cursor positions (control)
CmdListCursorPosControl:
        .byte   $08,$a0,$08,$ac,$08,$b8,$08,$c4

; command list cursor positions (window)
CmdListCursorPosWindow:
        .byte   $10,$a0,$10,$ac,$10,$b8,$10,$c4

; command list cursor positions (short)
CmdListCursorPosShort:
        .byte   $30,$a0,$10,$ac,$58,$ac,$30,$b8

.else

; command list cursor positions (window and control)
CmdListCursorPosControl:
CmdListCursorPosWindow:
        .byte   $18,$a0,$18,$ac,$18,$b8,$18,$c4

; command list cursor positions (short)
CmdListCursorPosShort:
        .byte   $38,$a0,$18,$ac,$58,$ac,$38,$b8

.endif

; ------------------------------------------------------------------------------

; [  ]

_c17a4e:
check_command:
@7a4e:  phx
        lda     near w7e890f,x
        and     #$03
        sta     near w7e890f,x
        sta     $2c
        lda     #$03
        sta     $2e
        jsr     Mult8NoHW
        tya
        clc
        adc     $30
        tax
        lda     near wCmdList::Disabled,x
        bmi     @7a6d
        plx
        clc
        rts
@7a6d:  plx
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c17a70:
check_command_mon:
@7a70:  phx
        lda     near w7e890f,x
        and     #$03
        sta     near w7e890f,x
        sta     $2c
        lda     #$03
        sta     $2e
        jsr     Mult8NoHW
        tya
        clc
        adc     $30
        tax
        lda     near wControlCmdList::Disabled,x
        bmi     @7a8f
        plx
        clc
        rts
@7a8f:  plx
        sec
        rts

; ------------------------------------------------------------------------------

; [ update menu state $05: command select ]

        array_label MENU_INPUT, MENU_INPUT::CMD_SELECT
@7a92:  stz     near w7e2f41                   ; start battle time
        stz     near w7e88e3
        lda     near wCloseMenu
        beq     @7aa3
        lda     #MENU_INPUT::CMD_CLOSE
        sta     near wMenuInput
        rts
@7aa3:  stz     near w7e7ae8
        stz     near w7e7ae9

; check X button
        lda     z04
        cmp     #JOY_X
        bne     @7aba
        inc     z94
        inc     near wCloseMenu
        lda     #$01
        sta     near w7e7bcc                 ; go to next character in menu order
        rts

; check Y button
@7aba:  lda     z04 + 1
        cmp     #>JOY_Y
        bne     @7acb
        inc     z94
        inc     near wCloseMenu
        lda     #$02
        sta     near w7e7bcc                 ; go to previous character in menu order
        rts

@7acb:  lda     near w7e62ca
        tax
        lda     near w7e62cc,x
        bne     @7adf
        lda     near w7e2f2e
        jne     @7ae2                   ; command setting: short
        jmp     @7bce                   ; command setting: window
@7adf:  jmp     @7c3f                   ; relm's control menu

; command setting: short
@7ae2:  ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        tay
        jsr     _c17a4e
        bcc     @7af7
@7aef:  inc     near w7e890f,x
        jsr     _c17a4e
        bcs     @7aef
@7af7:  lda     z04 + 1
        and     #>JOY_UP
        beq     @7b1b
        lda     near w7e890f,x
        sta     $36
        clr_a
        sta     near w7e890f,x
        jsr     _c17a4e
        bcc     @7b12
        lda     $36
        sta     near w7e890f,x
        bra     @7b1b
@7b12:  lda     near w7e890f,x
        cmp     $36
        beq     @7b1b
        inc     z94
@7b1b:  lda     z04 + 1
        and     #>JOY_DOWN
        beq     @7b40
        lda     near w7e890f,x
        sta     $36
        lda     #$03
        sta     near w7e890f,x
        jsr     _c17a4e
        bcc     @7b37
        lda     $36
        sta     near w7e890f,x
        bra     @7b40
@7b37:  lda     near w7e890f,x
        cmp     $36
        beq     @7b40
        inc     z94
@7b40:  lda     z04 + 1
        and     #>JOY_LEFT
        beq     @7b65
        lda     near w7e890f,x
        sta     $36
        lda     #$01
        sta     near w7e890f,x
        jsr     _c17a4e
        bcc     @7b5c
        lda     $36
        sta     near w7e890f,x
        bra     @7b65
@7b5c:  lda     near w7e890f,x
        cmp     $36
        beq     @7b65
        inc     z94
@7b65:  lda     z04 + 1
        and     #>JOY_RIGHT
        beq     @7b8a
        lda     near w7e890f,x
        sta     $36
        lda     #$02
        sta     near w7e890f,x
        jsr     _c17a4e
        bcc     @7b81
        lda     $36
        sta     near w7e890f,x
        bra     @7b8a
@7b81:  lda     near w7e890f,x
        cmp     $36
        beq     @7b8a
        inc     z94
@7b8a:  lda     z04
        and     #JOY_L | JOY_R
        cmp     #JOY_L
        bne     @7b9a
        inc     z94
        jsr     _c17ca9
        jmp     InitRowSelect
@7b9a:  cmp     #JOY_R
        bne     @7ba6
        inc     z94
        jsr     _c17ca9
        jmp     InitDefSelect

; A button
@7ba6:  lda     z04
        bpl     @7bb2
        inc     z96
        inc     near w7e2f41                   ; stop battle time
        jmp     InitCmdSelect
@7bb2:  ldx     near w7e62ca
        lda     near w7e890f,x
        asl
        tax
        lda     f:CmdListCursorPosShort,x
        sta     near w7e88e3+1
        lda     f:CmdListCursorPosShort+1,x
        sta     near w7e88e3+2
        lda     #1
        sta     near w7e88e3
        rts

; command setting: window
@7bce:  ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        tay
        jsr     _c17a4e
        bcs     @7bf3
        lda     z04 + 1
        and     #>(JOY_UP | JOY_DOWN)
        beq     @7bfb
        inc     z94
        lda     z04 + 1
        and     #>JOY_UP
        beq     @7bf3

; up
@7be9:  dec     near w7e890f,x
        jsr     _c17a4e
        bcs     @7be9
        bra     @7bfb

; down
@7bf3:  inc     near w7e890f,x
        jsr     _c17a4e
        bcs     @7bf3

; A button
@7bfb:  lda     z04
        bpl     @7c07
        inc     z96
        inc     near w7e2f41                   ; stop battle time
        jmp     InitCmdSelect

; left
@7c07:  lda     z04 + 1
        and     #>JOY_DIR_MASK
        cmp     #>JOY_LEFT
        bne     @7c17
        inc     z94
        jsr     _c17ca9
        jmp     InitRowSelect

; right
@7c17:  cmp     #>JOY_RIGHT
        bne     @7c23
        inc     z94
        jsr     _c17ca9
        jmp     InitDefSelect
@7c23:  ldx     near w7e62ca
        lda     near w7e890f,x
        asl
        tax
        lda     f:CmdListCursorPosWindow,x
        sta     near w7e88e3+1
        lda     f:CmdListCursorPosWindow+1,x
        sta     near w7e88e3+2
        lda     #1
        sta     near w7e88e3
        rts

; relm's control
@7c3f:  ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        tay
        jsr     _c17a70
        bcs     @7c64
        lda     z04 + 1
        and     #>(JOY_UP | JOY_DOWN)
        beq     @7c6c
        inc     z94
        lda     z04 + 1
        and     #>JOY_UP
        beq     @7c64
@7c5a:  dec     near w7e890f,x
        jsr     _c17a70
        bcs     @7c5a
        bra     @7c6c
@7c64:  inc     near w7e890f,x
        jsr     _c17a70
        bcs     @7c64
@7c6c:  lda     z04
        bpl     @7c8c
        inc     z96
        jsr     _c184ab
        jsr     _c17ca9
        lda     near wControlCmdList::Flags,x                 ; copy targeting flags
        sta     near w7e7a84
        lda     #BATTLE_CMD::CONTROL
        sta     near wPlayerActionBuf::BattleCmd,y
        lda     near wControlCmdList::CmdID,x
        sta     near w7e7a85
        jmp     InitTargetSelect
@7c8c:  ldx     near w7e62ca
        lda     near w7e890f,x
        asl
        tax
        lda     f:CmdListCursorPosControl,x
        sta     near w7e88e3+1
        lda     f:CmdListCursorPosControl+1,x
        sta     near w7e88e3+2
        lda     #1
        sta     near w7e88e3
        rts
        rts

; ------------------------------------------------------------------------------

; [ init player action buffer ]

_c17ca9:
init_buf_input:
@7ca9:  jsr     _c16d56
        lda     #$ff
        sta     near w7e7a85
        sta     near wPlayerActionBuf::BattleCmd,y
        sta     near wPlayerActionBuf::Attack,y
        sta     near wPlayerActionBuf::SecondAttack,y
        clr_a
        sta     near wPlayerActionBuf::Targets,y
        sta     near wPlayerActionBuf::Targets + 1,y
        sta     near wPlayerActionBuf::SecondTargets,y
        sta     near wPlayerActionBuf::SecondTargets + 1,y
        rts

; ------------------------------------------------------------------------------

; [ open menu window for selected command (or select target) ]

InitCmdSelect:
@7cc8:  jsr     _c184ab
        jsr     _c17ca9
        lda     near wCmdList::Flags,x                 ; copy targeting flags
        sta     near w7e7a84
        lda     near wCmdList::CmdID,x
        sta     near wPlayerActionBuf::BattleCmd,y
        and     #$7f
        asl
        tax
        jmp     (near InitCmdSelectTbl,x)

; ------------------------------------------------------------------------------

; [ init menu input for x-magic ]

InitXMagicInput:
@7ce1:  lda     #1
        sta     near w7e7ae8
        jmp     InitMagicSelect

; ------------------------------------------------------------------------------

; menu state for each battle command
InitCmdSelectTbl:
@7ce9:  .addr   InitAttackTargetSelect  ; FIGHT
        .addr   InitItemSelect          ; ITEM
        .addr   InitMagicSelect         ; MAGIC
        .addr   InitTargetSelect        ; MORPH
        .addr   InitTargetSelect        ; REVERT
        .addr   InitTargetSelect        ; STEAL
        .addr   InitTargetSelect        ; CAPTURE
        .addr   InitBushidoInput        ; BUSHIDO
        .addr   InitThrowSelect         ; THROW
        .addr   InitToolsSelect         ; TOOLS
        .addr   InitBlitzInput          ; BLITZ
        .addr   InitTargetSelect        ; RUNIC
        .addr   InitLoreSelect          ; LORE
        .addr   InitTargetSelect        ; SKETCH
        .addr   InitTargetSelect        ; CONTROL
        .addr   InitSlotInput           ; SLOT
        .addr   InitRageSelect          ; RAGE
        .addr   InitTargetSelect        ; LEAP
        .addr   InitTargetSelect        ; MIMIC
        .addr   InitDanceSelect         ; DANCE
        .addr   InitRowSelect           ; ROW
        .addr   InitDefSelect           ; DEF
        .addr   InitTargetSelect        ; JUMP
        .addr   InitXMagicInput         ; X_MAGIC
        .addr   InitTargetSelect        ; GIL_TOSS
        .addr   InitTargetSelect        ; SUMMON
        .addr   InitTargetSelect        ; HEALTH
        .addr   InitTargetSelect        ; SHOCK
        .addr   InitTargetSelect        ; POSSESS
        .addr   InitMagitekSelect       ; MAGITEK

; ------------------------------------------------------------------------------

; [ update menu state $37: swdtech ]

        array_label MENU_INPUT, MENU_INPUT::BUSHIDO_SELECT
@7d25:  stz     near w7e2f41       ; start battle time
        stz     near w7e88e3
        lda     near wCloseMenu
        beq     @7d35       ; branch if menu is not closing
        lda     #MENU_INPUT::BUSHIDO_CLOSE
        sta     near wMenuInput
@7d35:  lda     z04
        bpl     @7d56       ; branch if a button is not pressed
        inc     z96         ; play cursor sound effect (select)
        jsr     _c16d56       ; get pointer to current character slot data (battle menu)
        lda     near w7e7b82       ; swdtech bar counter / 32
        lsr5
        sta     near wPlayerActionBuf::Attack,y
        lda     near w7e62ca
        sta     near wPlayerActionBuf::CharSlot,y     ; character slot
        inc     near w7e7b80       ; increment character slot
        inc     near wCloseMenu       ; close menu
        rts
@7d56:  lda     z08 + 1
        bpl     @7d5f       ; branch if b button is not pressed
        inc     z96         ; play cursor sound effect (select)
        jmp     CloseBushidoWindow
@7d5f:  ldx     near w7e62ca       ; active character
        phx
        lda     #7
        sec
        sbc     near w7e2020       ; number of swdtechs known - 1
        tax
        clr_ay
@7d6c:  lda     f:BushidoTextPalTbl,x
        sta     near w7e5dbd+$1d,y
        inx
        iny2
        cpy     #$0010
        bne     @7d6c
        plx
        clr_ay
        lda     near w7e2020
        inc
        sta     $36
        lda     z0e         ; frame counter
        and     #%11
        bne     @7d8d       ; branch every 4 frames
        inc     near w7e7b82       ; increment swdtech bar counter
@7d8d:  lda     near w7e7b82
        lsr5
        cmp     $36
        bne     @7d9d       ; branch if it hasn't reached the max value
        clr_a
        sta     near w7e7b82       ; reset the swdtech bar counter
@7d9d:  inc
        sta     $36
        clr_ax
        lda     #$29
@7da4:  sta     near w7e5dbd+$1d,x
        inx2
        dec     $36
        bne     @7da4
        lda     near w7e7b82
        bpl     @7dbf
        lda     #GAUGE_FULL_CHAR
        jsr     DrawBushidoGaugeRepeat
        lda     near w7e7b82
        jsr     DrawBushidoGauge
        bra     @7dca
@7dbf:  lda     near w7e7b82
        jsr     DrawBushidoGauge
        lda     #GAUGE_EMPTY_CHAR
        jsr     DrawBushidoGaugeRepeat
@7dca:  inc     near w7e7b81
        rts

; ------------------------------------------------------------------------------

; [ draw swdtech bar (section that is filling) ]

DrawBushidoGauge:
@7dce:  and     #$7f
        lsr2
        asl2
        tax
        lda     #$04
        sta     $36
@7dd9:  lda     f:GaugeTextTbl,x
        sta     near w7e7a73,y
        lda     #$35
        sta     near w7e7a73+1,y
        inx
        iny2
        dec     $36
        bne     @7dd9
        rts

; ------------------------------------------------------------------------------

; [ draw swdtech bar (empty or full sections) ]

; A: value to repeat 4 times

DrawBushidoGaugeRepeat:
@7ded:  sta     $36
        lda     #$04
        sta     $38
@7df3:  lda     $36
        sta     near w7e7a73,y
        lda     #$35
        sta     near w7e7a73+1,y
        inx
        iny2
        dec     $38
        bne     @7df3
        rts

; ------------------------------------------------------------------------------

; [ update menu state $27: def. ]

        array_label MENU_INPUT, MENU_INPUT::DEF_SELECT
@7e05:  stz     near w7e88e3
        lda     near wCloseMenu
        beq     @7e13
        lda     #MENU_INPUT::DEF_CLOSE
        sta     near wMenuInput
        rts
@7e13:  lda     z04
        bpl     @7e2e       ; branch if A button is not pressed
        inc     z94         ; play cursor sound effect (select)
        jsr     _c16d56       ; get pointer to current character slot data (battle menu)
        lda     #BATTLE_CMD::DEF
        sta     near wPlayerActionBuf::BattleCmd,y
        lda     near w7e62ca       ; character slot
        sta     near wPlayerActionBuf::CharSlot,y
        inc     near w7e7b80       ; increment character slot
        inc     near wCloseMenu       ; close menu
        rts
@7e2e:  lda     near w7e2f2e
        beq     @7e3d
        lda     z06
        and     #(JOY_L | JOY_R)
        cmp     #JOY_R
        bne     @7e41
        bra     @7e4a
@7e3d:  lda     z08 + 1
        bpl     @7e46       ; branch if b button is not pressed
@7e41:  inc     z94
        jmp     CloseDefendWindow
@7e46:  cmp     #>JOY_LEFT
        beq     @7e41
@7e4a:  ldx     near w7e62ca       ; character slot
        lda     near w7e890f,x     ; cursor position
        asl
        tax
        lda     near w7e2f2e
        beq     @7e63

; short mode
        lda     #112
        sta     near w7e88e3+1
        lda     #160
        sta     near w7e88e3+2
        bra     @7e6f

; window mode
@7e63:  lda     #56
        sta     near w7e88e3+1       ; main cursor x position
        lda     f:CmdListCursorPosWindow+1,x
        sta     near w7e88e3+2       ; main cursor y position
@7e6f:  inc     near w7e88e3       ; activate main cursor
        rts

; ------------------------------------------------------------------------------

; [ update menu state $24: row ]

        array_label MENU_INPUT, MENU_INPUT::ROW_SELECT
@7e73:  stz     near w7e88e3
        lda     near wCloseMenu
        beq     @7e81
        lda     #MENU_INPUT::ROW_CLOSE
        sta     near wMenuInput
        rts
@7e81:  lda     z04
        bpl     @7e9c
        inc     z94
        jsr     _c16d56       ; get pointer to current character slot data (battle menu)
        lda     #BATTLE_CMD::ROW
        sta     near wPlayerActionBuf::BattleCmd,y
        lda     near w7e62ca
        sta     near wPlayerActionBuf::CharSlot,y
        inc     near w7e7b80
        inc     near wCloseMenu
        rts
@7e9c:  lda     near w7e2f2e
        beq     @7eab
        lda     z06
        and     #(JOY_L | JOY_R)
        cmp     #JOY_L
        bne     @7eaf
        bra     @7eb8
@7eab:  lda     z08 + 1
        bpl     @7eb4
@7eaf:  inc     z94
        jmp     CloseRowWindow
@7eb4:  cmp     #>JOY_RIGHT
        beq     @7eaf
@7eb8:  ldx     near w7e62ca
        lda     near w7e890f,x
        asl
        tax
        lda     near w7e2f2e
        beq     @7ed1

; short mode
        lda     #16
        sta     near w7e88e3+1
        lda     #160
        sta     near w7e88e3+2
        bra     @7edd

; window mode
@7ed1:  lda     #8
        sta     near w7e88e3+1
        lda     f:CmdListCursorPosWindow+1,x
        sta     near w7e88e3+2
@7edd:  inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

SlotRateTbl:
@7ee1:  .byte   $1f,$03,$01,$01,$00,$00

; ------------------------------------------------------------------------------

GetSlotReel1:
@7ee7:  lsr4
        asl
        tax
        lda     f:SlotReel1Tbl,x
        rts

; ------------------------------------------------------------------------------

GetSlotReel2:
@7ef2:  lsr4
        asl
        tax
        lda     f:SlotReel2Tbl,x
        rts

; ------------------------------------------------------------------------------

GetSlotReel3:
@7efd:  lsr4
        asl
        tax
        lda     f:SlotReel3Tbl,x
        rts

; ------------------------------------------------------------------------------

; [ update menu state $08: slot  ]

        array_label MENU_INPUT, MENU_INPUT::SLOT_SELECT
@7f08:  stz     near w7e88e3
        lda     near wCloseMenu
        beq     @7f16
        lda     #MENU_INPUT::SLOT_STOP
        sta     near wMenuInput
        rts

; A button
@7f16:  lda     z04
        bpl     @7f6d       ; branch if A button is not pressed
        inc     z96         ; play cursor sound effect (select)
        lda     near w7e7b92
        bne     @7f3a
        lda     near w7e2f49
        and     #$04
        beq     @7f2f       ; branch if joker doom is enabled
        jsr     Rand
        ora     #$3c
        bra     @7f32
@7f2f:  jsr     Rand
@7f32:  sta     near w7e6179
        inc     near w7e7b92
        bra     @7f6d
@7f3a:  lda     near w7e7b93
        bne     @7f6f
        lda     near w7e7b8f
        bne     @7f47
        jmp     @7fec

; set reel 1
@7f47:  lda     near wSlotReelPos1
        jsr     GetSlotReel1
        sta     near w7e617b
        tax
        lda     f:SlotRateTbl,x
        sta     $36
        lda     near w7e6179
        and     $36
        bne     @7f65
        lda     #$04
        sta     near w7e617d
        bra     @7f6a
@7f65:  lda     #$ff
        sta     near w7e617b
@7f6a:  inc     near w7e7b93
@7f6d:  bra     @7fec

; set reel 2
@7f6f:  lda     near w7e7b94
        bne     @7fb6
        lda     near w7e7b90
        beq     @7fec
        lda     near wSlotReelPos1
        jsr     GetSlotReel1
        sta     $38
        lda     near wSlotReelPos2
        jsr     GetSlotReel2
        sta     $3a
        cmp     $38
        bne     @7fac
        lda     $38
        tax
        lda     f:SlotRateTbl,x
        sta     $36
        lda     near w7e6179
        and     $36
        bne     @7fa6
        lda     #$04
        sta     near w7e617d
        lda     $3a
        bra     @7fae
@7fa6:  lda     $3a
        ora     #$80
        bra     @7fae
@7fac:  lda     #$ff
@7fae:  sta     near w7e617c
        inc     near w7e7b94
        bra     @7fec

; set reel 3
@7fb6:  lda     near w7e7b91
        beq     @7fec
        lda     near wSlotReelPos1
        jsr     GetSlotReel1
        sta     $36
        lda     near wSlotReelPos2
        jsr     GetSlotReel2
        sta     $37
        lda     near wSlotReelPos3
        jsr     GetSlotReel3
        sta     $38
        jsl     GetSlotAttack
        pha
        jsr     _c16d56       ; get pointer to current character slot data (battle menu)
        pla
        sta     near wPlayerActionBuf::Attack,y
        lda     near w7e62ca
        sta     near wPlayerActionBuf::CharSlot,y     ; character slot
        inc     near w7e7b80       ; increment character slot
        inc     near wCloseMenu       ; close menu
        rts

; B button
@7fec:  lda     z08 + 1
        bpl     @8000       ; branch if b button is not pressed
        lda     near w7e7b92
        ora     near w7e7b93
        ora     near w7e7b94
        bne     @8000           ; can't close if any reels are set
        inc     z96
        jmp     array_item MENU_INPUT, MENU_INPUT::SLOT_STOP

@8000:  lda     near wSlotReelPos1
        clc
        adc     #76
        sta     near wOffsetPerTile::V + 8 * 2
        sta     near wOffsetPerTile::V + 9 * 2
        sta     near wOffsetPerTile::V + 10 * 2
        sta     near wOffsetPerTile::V + 11 * 2
        lda     near wSlotReelPos2
        clc
        adc     #76
        sta     near wOffsetPerTile::V + 13 * 2
        sta     near wOffsetPerTile::V + 14 * 2
        sta     near wOffsetPerTile::V + 15 * 2
        sta     near wOffsetPerTile::V + 16 * 2
        lda     near wSlotReelPos3
        clc
        adc     #76
        sta     near wOffsetPerTile::V + 18 * 2
        sta     near wOffsetPerTile::V + 19 * 2
        sta     near wOffsetPerTile::V + 20 * 2
        sta     near wOffsetPerTile::V + 21 * 2
        lda     near w7e7b8f
        bne     @8053
        lda     near wSlotReelPos1
        sec
        sbc     #4
        sta     near wSlotReelPos1
        lda     near w7e7b92
        beq     @8053
        lda     near wSlotReelPos1
        and     #$0f
        bne     @8053
        inc     near w7e7b8f
@8053:  lda     near w7e7b90
        bne     @808c
        lda     near wSlotReelPos2
        sec
        sbc     #4
        sta     near wSlotReelPos2
        lda     near w7e7b93
        beq     @808c
        lda     near wSlotReelPos2
        and     #$0f
        bne     @808c
        lda     near w7e617b
        cmp     #$ff
        beq     @8089
        lda     near wSlotReelPos2
        jsr     GetSlotReel2
        cmp     near w7e617b
        beq     @8089
        lda     near w7e617d
        beq     @8089
        dec     near w7e617d
        bra     @808c
@8089:  inc     near w7e7b90
@808c:  lda     near w7e7b91
        bne     @80da
        lda     near wSlotReelPos3
        sec
        sbc     #4
        sta     near wSlotReelPos3
        lda     near w7e7b94
        beq     @80da
        lda     near wSlotReelPos3
        and     #$0f
        bne     @80da
        lda     near w7e617c
        cmp     #$ff
        beq     @80d7
        and     #$80
        bne     @80c6
        lda     near wSlotReelPos3
        jsr     GetSlotReel3
        cmp     near w7e617c
        beq     @80d7
        lda     near w7e617d
        beq     @80d7
        dec     near w7e617d
        bra     @80da
@80c6:  lda     near wSlotReelPos3
        jsr     GetSlotReel3
        sta     $36
        lda     near w7e617c
        and     #$7f
        cmp     $36
        beq     @80da
@80d7:  inc     near w7e7b91
@80da:  rts

; ------------------------------------------------------------------------------

; [ process player's controller input for moving the menu cursor ]

GetCursorInput:
@80db:  ldx     $36
        stx     $3a
        stz     $3c
        lda     z04 + 1
        and     #>JOY_DIR_MASK
        beq     @8144       ; return if no direction buttons pressed

; up
        cmp     #>JOY_UP
        bne     @80f4
        lda     $37
        beq     @813e
        inc     z94
        dec     $37
        rts

; down
@80f4:  cmp     #>JOY_DOWN
        bne     @8103
        lda     $37
        cmp     #$03
        beq     @8141
        inc     z94
        inc     $37
        rts

; left
@8103:  cmp     #>JOY_LEFT
        bne     @811d
        lda     $36
        bne     @8118
        lda     $39
        sta     $36
        lda     $37
        beq     @8139
        inc     z94
        dec     $37
        rts
@8118:  inc     z94
        dec     $36
        rts

; right
@811d:  cmp     #>JOY_RIGHT
        bne     @8144
        lda     $36
        cmp     $39
        bne     @8134
        stz     $36
        lda     $37
        cmp     #$03
        beq     @8141
        inc     z94
        inc     $37
        rts
@8134:  inc     z94
        inc     $36
        rts
@8139:  lda     #$bf
        sta     $3c
        rts

; scroll up
@813e:  dec     $3c
        rts

; scroll down
@8141:  inc     $3c
        rts
@8144:  rts

; ------------------------------------------------------------------------------

; [ update menu state $0e: spell select ]

        array_label MENU_INPUT, MENU_INPUT::MAGIC_SELECT

.if LANG_EN
        @NUM_COLUMNS  = 2
        @MAX_SCROLL_POS = ATTACK::NUM_MAGIC / @NUM_COLUMNS - 4
.else
        @NUM_COLUMNS  = 3
        @MAX_SCROLL_POS = ATTACK::NUM_MAGIC / @NUM_COLUMNS - 4
.endif

@8145:  stz     near w7e88ef
        stz     near w7e88e3
        lda     near wCloseMenu
        beq     @8156
        lda     #MENU_INPUT::MAGIC_CLOSE
        sta     near wMenuInput
        rts
@8156:  ldy     near w7e62ca
        lda     near w7e8917,y
        sta     $36
        lda     near w7e891b,y
        sta     $37
        lda     near w7e8913,y
        sta     $38
        lda     #@NUM_COLUMNS - 1
        sta     $39
        jsr     GetCursorInput
        lda     $3c
        beq     @81a4
        bmi     @8187

; scroll list down
        lda     near w7e8913,y
        cmp     #@MAX_SCROLL_POS
        beq     @81ae
        inc
        sta     near w7e8913,y
        inc     z94
        jsr     ScrollMagicListDown
        bra     @81a4

; scroll list up
@8187:  lda     near w7e8913,y
        bne     @819b
        inc     z94
        lda     near w7e7ae8
        bne     @81a4
        jsr     CheckHasGenju
        bcs     @81a4
        jmp     OpenSummonWindow
@819b:  dec
        sta     near w7e8913,y
        inc     z94
        jsr     ScrollMagicListUp
@81a4:  lda     $36
        sta     near w7e8917,y
        lda     $37
        sta     near w7e891b,y

; A button
@81ae:  lda     z04
        bpl     @81ed       ; branch if A button is not pressed
        jsr     _c18414
        lda     near wSpellListMagic::Disabled,x
        bmi     @81eb
        inc     z96
        jsr     _c16d56
        lda     near w7e7ae8
        beq     @81c8       ; branch if x-magic is not enabled
        lda     #BATTLE_CMD::X_MAGIC
        bra     @81ca
@81c8:  lda     #BATTLE_CMD::MAGIC
@81ca:  sta     near wPlayerActionBuf::BattleCmd,y
        jsr     _c18414
        lda     near wSpellListMagic::AttackID,x
        sta     near w7e7a85
        lda     #$01        ; curative menu type 1 (spell)
        sta     near w7eecba
        lda     near wSpellListMagic::Flags,x                 ; copy targeting flags
        sta     near w7e7a84
        and     #TARGET::ENEMY
        jeq     array_item MENU_INPUT, MENU_INPUT::CHAR_STATUS_OPEN
        jmp     InitTargetSelect
@81eb:  inc     z95         ; play error sound effect

; B button
@81ed:  lda     z08 + 1
        bpl     @81f6       ; branch if b button is not pressed
        inc     z96
        jmp     CloseMagicWindow
@81f6:  jsr     _c18414
        lda     near wSpellListMagic::MPCost,x
        sta     near w7e6178
        lda     #@MAX_SCROLL_POS
        sta     $36
        ldx     #$2400 / @MAX_SCROLL_POS
        stx     $2e
        lda     near w7e8913,y
        jsr     UpdateMenuScrollArrows
        lda     near w7e8917,y
        tax
        lda     f:MagicCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e891b,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [  ]

ScrollMagicListDown:
@8228:  clc
        adc     #$03
        jsr     DrawMagicListText
        lda     #MENU_INPUT::SCROLL_DOWN
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        cmp     #$04
        beq     @8240
        inc
        bra     @8241
@8240:  clr_a
@8241:  sta     near w7e7afd
        bra     _825e

; ------------------------------------------------------------------------------

; [  ]

ScrollMagicListUp:
@8246:  jsr     DrawMagicListText
        lda     #MENU_INPUT::SCROLL_UP
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        beq     @8259
        dec
        bra     @825b
@8259:  lda     #$04
@825b:  sta     near w7e7afd

magic_one_scr:
_825e:  lda     #$03
        sta     near w7e7ba8
        lda     #MENU_INPUT::MAGIC_SELECT
        sta     near wMenuInput+1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18269:
set_scr_line_tfr_poi:
@8269:  lda     near w7e7afd
        asl
        tax
        lda     f:_c18291,x   ; vram destination
        sta     near w7e7baa
        lda     f:_c18291+1,x
        sta     near w7e7baa+1
        inc     near wEnableTfrMenuTextTiles
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

; magic window cursor x positions
MagicCursorXPosTbl:
@8280:  .byte   $08,$50,$70

; equip window cursor x positions
EquipCursorXPosTbl:
@8283:  .byte   $00,$78

; tools list cursor x positions
ToolsCursorXPosTbl:
@8285:  .byte   $00,$78

; dance/throw/item list cursor x positions
ItemCursorXPosTbl:
DanceCursorXPosTbl:
@8287:  .byte   $10,$80

; rage/magitek list cursor x positions
RageCursorXPosTbl:
@8289:  .byte   $10,$78

.else

; magic window cursor x positions
MagicCursorXPosTbl:
@8280:  .byte   $00,$38,$70

EquipCursorXPosTbl:
ToolsCursorXPosTbl:
ItemCursorXPosTbl:
@821c:  .byte   $10,$80

; rage/magitek list cursor x positions
DanceCursorXPosTbl:
RageCursorXPosTbl:
@8289:  .byte   $20,$80

.endif

; lore list cursor x positions
LoreCursorXPosTbl:
@828b:  .byte   $08,$58

; list cursor y positions
ListCursorYPosTbl:
@828d:  .byte   $a4,$b0,$bc,$c8

scr_line_vram_poi:
_c18291:
@8291:  .word   $7c00, $7c40, $7c80, $7cc0, $7d00

; ------------------------------------------------------------------------------

; [ check if character has an esper equipped ]

CheckHasGenju:
@829b:  lda     near w7e62ca       ; character slot
        asl
        tax
        longa
        lda     f:CharSpellListPtrs,x
        tax
        shorta0
        lda     near wSpellListGenju::Disabled,x     ; equipped esper
        bmi     @82b1
        clc
        rts
@82b1:  sec
        rts

; ------------------------------------------------------------------------------

; [ update menu state $16: esper select ]

        array_label MENU_INPUT, MENU_INPUT::SUMMON_SELECT
@82b3:  stz     near w7e88e3
        lda     near wCloseMenu
        beq     @82c1
        lda     #MENU_INPUT::SUMMON_CLOSE
        sta     near wMenuInput
        rts
@82c1:  lda     z04 + 1
        and     #>(JOY_DOWN | JOY_RIGHT)
        beq     @82d6       ; branch if down or right is not pressed
        inc     z94
        and     #>JOY_RIGHT
        beq     @82d3       ; if right was pressed, reset the cursor x position
        ldx     near w7e62ca
        stz     near w7e8917,x
@82d3:  jmp     CloseSummonWindow
@82d6:  lda     z04
        bpl     @82fa       ; branch if a button is pressed
        jsr     CheckHasGenju
        bcs     @82f8
        inc     z96
        jsr     _c16d56
        lda     #BATTLE_CMD::SUMMON
        sta     near wPlayerActionBuf::BattleCmd,y
        lda     near wSpellListGenju::AttackID,x
        sta     near w7e7a85
        lda     near wSpellListGenju::Flags,x                 ; copy targeting flags
        sta     near w7e7a84
        jmp     InitTargetSelect
@82f8:  inc     z95         ; play cursor sound effect (select)
@82fa:  lda     #$38        ; set main cursor position
        sta     near w7e88e3+1
        lda     #$a8
        sta     near w7e88e3+2
        inc     near w7e88e3       ; activate main cursor
        rts

; ------------------------------------------------------------------------------

; [ update menu state $1b: lore select ]

        array_label MENU_INPUT, MENU_INPUT::LORE_SELECT

.if LANG_EN
        @MAX_SCROLL_POS = ATTACK::NUM_LORE - 4
.else
        @MAX_SCROLL_POS = ATTACK::NUM_LORE / 2 - 4
.endif

@8308:  stz     near w7e88e3
        stz     near w7e88ef
        lda     near wCloseMenu
        beq     @8319
        lda     #MENU_INPUT::LORE_CLOSE
        sta     near wMenuInput
        rts
@8319:  ldy     near w7e62ca
.if LANG_EN
        stz     $36
        lda     near w7e8927,y
        sta     $37
        lda     near w7e891f,y
        sta     $38
        stz     $39         ; 1 column
.else
        lda     near w7e8923,y
        sta     $36
        lda     near w7e8927,y
        sta     $37
        lda     near w7e891f,y
        sta     $38
        lda     #1
        sta     $39         ; 2 columns
.endif
        jsr     GetCursorInput
        lda     $3c
        beq     @8353
        bmi     @8345
        lda     near w7e891f,y
        cmp     #@MAX_SCROLL_POS
        beq     @835d
        inc
        sta     near w7e891f,y
        inc     z94
        jsr     ScrollLoreListDown
        bra     @8353
@8345:  lda     near w7e891f,y
        beq     @835d
        dec
        sta     near w7e891f,y
        inc     z94
        jsr     ScrollLoreListUp
@8353:  lda     $36
        sta     near w7e8923,y
        lda     $37
        sta     near w7e8927,y
@835d:  lda     z04
        bpl     @837c
        jsr     _c183f7
        lda     $216b,x
        bmi     @837a
        inc     z94
        lda     near wSpellListLore::AttackID,x
        sta     near w7e7a85
        lda     near wSpellListLore::Flags,x                 ; copy targeting flags
        sta     near w7e7a84
        jmp     InitTargetSelect
@837a:  inc     z95
@837c:  lda     z08 + 1
        bpl     @8386
        inc     z96
        jsr     CloseLoreWindow
        rts
@8386:  jsr     _c183f7
        lda     near wSpellListLore::MPCost,x
        sta     near w7e6178
        lda     #ATTACK::NUM_LORE / 2 - 4       ; *** bug *** should be 20 for the english version
        sta     $36
        ldx     #$23ff / @MAX_SCROLL_POS + 1
        stx     $2e
        lda     near w7e891f,y
        jsr     UpdateMenuScrollArrows
.if LANG_EN
        clr_ax
.else
        lda     near w7e8923,y
        tax
.endif
        lda     f:LoreCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e8927,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [  ]

ScrollLoreListDown:
@83b6:  clc
        adc     #$03
        jsr     DrawLoreListText
        lda     #MENU_INPUT::SCROLL_DOWN
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        cmp     #$04
        beq     @83ce
        inc
        bra     @83cf
@83ce:  clr_a
@83cf:  sta     near w7e7afd
        bra     _83ec

; ------------------------------------------------------------------------------

; [  ]

ScrollLoreListUp:
@83d4:  jsr     DrawLoreListText
        lda     #MENU_INPUT::SCROLL_UP
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        beq     @83e7
        dec
        bra     @83e9
@83e7:  lda     #$04
@83e9:  sta     near w7e7afd

learning_one_scr:
_83ec:  lda     #$03
        sta     near w7e7ba8
        lda     #MENU_INPUT::LORE_SELECT
        sta     near wMenuInput+1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c183f7:
get_learning_poi:
@83f7:  phy
        lda     near w7e62ca
        tay
        asl
        tax
        lda     near w7e891f,y
        clc
        adc     near w7e8927,y
.if !LANG_EN
        asl
        clc
        adc     near w7e8923,y
.endif
        longa
        asl2
        clc
        adc     f:CharSpellListPtrs,x
        tax
        shorta0
        ply
        rts

; ------------------------------------------------------------------------------

; [ get point to magic in spell list ]

_c18414:
get_magic_poi:
@8414:  phy
        lda     near w7e62ca
        tay
        asl
        tax
        lda     near w7e8913,y
        clc
        adc     near w7e891b,y
        sta     $40
        asl
.if !LANG_EN
        clc
        adc     $40
.endif
        clc
        adc     near w7e8917,y
        longa
        asl2
        clc
        adc     f:CharSpellListPtrs,x
        tax
        shorta0
        ply
        rts

; ------------------------------------------------------------------------------

; [ get cursor position in rage menu ]

_c18438:
get_riot_poi:
@8438:  ldx     near w7e62ca
        lda     near w7e892f,x
        sta     $40
        stz     $41
        lda     near w7e892b,x
        clc
        adc     near w7e8933,x
        longa
        asl
        clc
        adc     $40
        tax
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18454:
get_throw_poi:
@8454:  phy
        lda     near w7e62ca
        tay
        asl
        tax
        lda     near w7e8953,y
        clc
        adc     near w7e895b,y
.if !LANG_EN
        asl
        clc
        adc     near w7e8957,y
.endif
        longa
        sta     $40
        asl
        clc
        adc     $40
        tax
        shorta0
        ply
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18470:
get_machine_poi:
@8470:  phy
        lda     near w7e62ca
        tay
        asl
        tax
        lda     near w7e895f,y       ; scroll position
        clc
        adc     near w7e8967,y       ; y position
        asl
        clc
        adc     near w7e8963,y       ; x position
        longa
        sta     $40           ; multiply by 3
        asl
        clc
        adc     $40
        tax
        shorta0
        ply
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18491:
get_madou_poi:
@8491:  ldx     near w7e62ca
        lda     near w7e8943,x
        asl
        clc
        adc     near w7e893f,x
        tax
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1849e:
@849e:  ldx     near w7e62ca
        lda     near w7e893b,x
        asl
        clc
        adc     near w7e8937,x
        tax
        rts

; ------------------------------------------------------------------------------

; [  ]

_c184ab:
get_command_poi:
@84ab:  ldx     near w7e62ca
        lda     near w7e890f,x
        sta     $2c
        lda     #$03
        sta     $2e
        jsr     Mult8NoHW
        ldx     near w7e62ca
        lda     f:CharCmdPtrs,x
        clc
        adc     $30
        tax
        rts

; ------------------------------------------------------------------------------

; [ update menu state $1e: rage ]

        array_label MENU_INPUT, MENU_INPUT::RAGE_SELECT

        @MAX_SCROLL_POS = 256 / 2 - 4

@84c6:  stz     near w7e88e3
        stz     near w7e88ef
        lda     near wCloseMenu
        beq     @84d7
        lda     #MENU_INPUT::RAGE_CLOSE
        sta     near wMenuInput
        rts
@84d7:  ldy     near w7e62ca
        lda     near w7e892f,y
        sta     $36
        lda     near w7e8933,y
        sta     $37
        lda     near w7e892b,y
        sta     $38
        lda     #$01
        sta     $39         ; 2 columns
        jsr     GetCursorInput
        lda     $3c
        beq     @8516
        bmi     @8508
        lda     near w7e892b,y
        cmp     #@MAX_SCROLL_POS
        beq     @8520
        inc
        sta     near w7e892b,y
        inc     z94
        jsr     ScrollRageListDown
        bra     @8516
@8508:  lda     near w7e892b,y
        beq     @8520
        dec
        sta     near w7e892b,y
        inc     z94
        jsr     ScrollRageListUp
@8516:  lda     $36
        sta     near w7e892f,y
        lda     $37
        sta     near w7e8933,y
@8520:  lda     z08 + 1
        bpl     @852a
        inc     z96
        jsr     CloseRageWindow
        rts
@852a:  lda     z04
        bpl     @854a
        jsr     _c18438
        lda     near wRageList,x
        cmp     #$ff
        beq     @8548
        inc     z96
        lda     near wRageList,x
        sta     near w7e7a85
        lda     #$02                    ; self-target
        sta     near w7e7a84
        jmp     InitTargetSelect
@8548:  inc     z95
@854a:  lda     #@MAX_SCROLL_POS
        sta     $36
        ldx     #$23ff / @MAX_SCROLL_POS + 1
        stx     $2e
        lda     near w7e892b,y
        jsr     UpdateMenuScrollArrows
        lda     near w7e892f,y
        tax
        lda     f:RageCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e8933,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [  ]

ScrollRageListDown:
@8573:  clc
        adc     #$03
        jsr     DrawRageListText
        lda     #MENU_INPUT::SCROLL_DOWN
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        cmp     #$04
        beq     @858b
        inc
        bra     @858c
@858b:  clr_a
@858c:  sta     near w7e7afd
        bra     _85a9

ScrollRageListUp:
@8591:  jsr     DrawRageListText
        lda     #MENU_INPUT::SCROLL_UP
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        beq     @85a4
        dec
        bra     @85a6
@85a4:  lda     #$04
@85a6:  sta     near w7e7afd

riot_one_scr:
_85a9:  lda     #$03
        sta     near w7e7ba8
        lda     #MENU_INPUT::RAGE_SELECT
        sta     near wMenuInput+1
        rts

; ------------------------------------------------------------------------------

; [ update menu state $21: dance ]

        array_label MENU_INPUT, MENU_INPUT::DANCE_SELECT
@85b4:  stz     near w7e88e3
        lda     near wCloseMenu
        beq     @85c2
        lda     #MENU_INPUT::DANCE_CLOSE
        sta     near wMenuInput
        rts
@85c2:  ldy     near w7e62ca
        lda     near w7e8937,y
        sta     $36
        lda     near w7e893b,y
        sta     $37
        stz     $38
        lda     #$01
        sta     $39         ; 2 columns
        jsr     GetCursorInput
        lda     $3c
        bne     @85e6
        lda     $36
        sta     near w7e8937,y
        lda     $37
        sta     near w7e893b,y

; B button
@85e6:  lda     z08 + 1
        bpl     @85f0
        inc     z96                     ; select sfx
        jsr     CloseDanceWindow
        rts

; A button
@85f0:  lda     z04
        bpl     @860b
        jsr     _c1849e
        lda     near wDanceList,x
        bmi     @8609
        inc     z96
        sta     near w7e7a85
        lda     #$02                    ; self-target
        sta     near w7e7a84
        jmp     InitTargetSelect
@8609:  inc     z95                     ; error sfx

; update cursor position
@860b:  lda     near w7e8937,y
        tax
        lda     f:DanceCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e893b,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [ update menu state $2a: magitek attack select ]

        array_label MENU_INPUT, MENU_INPUT::MAGITEK_SELECT
@8625:  stz     near w7e88e3
        lda     near wCloseMenu
        beq     @8633
        lda     #MENU_INPUT::MAGITEK_CLOSE
        sta     near wMenuInput
        rts
@8633:  ldy     near w7e62ca
        lda     near w7e893f,y
        sta     $36
        lda     near w7e8943,y
        sta     $37
        stz     $38
        lda     #$01
        sta     $39         ; 2 columns
        jsr     GetCursorInput
        lda     $3c
        bne     @8657
        lda     $36
        sta     near w7e893f,y
        lda     $37
        sta     near w7e8943,y
@8657:  lda     z08 + 1
        bpl     @8661
        inc     z96
        jsr     CloseMagitekWindow
        rts
@8661:  sty     $36
        lda     z04
        bpl     @8699
        jsr     _c18491
        lda     near w7e62ca
        asl5
        tay
        lda     near wCharGfxDataBuf::GfxID,y
        bne     @8680                   ; branch if not terra
        lda     f:TerraMagitekAttackTbl,x
        bmi     @8697
        bra     @8686
@8680:  lda     f:DefaultMagitekAttackTbl,x
        bmi     @8697
@8686:  inc     z96
        sta     near w7e7a85
        ldy     $36
        lda     f:MagitekAttackTargetFlags,x
        sta     near w7e7a84
        jmp     InitTargetSelect
@8697:  inc     z95
@8699:  ldy     $36
        lda     near w7e893f,y
        tax
        lda     f:RageCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e8943,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [ update menu state $2d: throw (item select) ]

        array_label MENU_INPUT, MENU_INPUT::THROW_SELECT

.if LANG_EN
        @MAX_SCROLL_POS = 255 - 4
.else
        @MAX_SCROLL_POS = 256 / 2 - 4
.endif

@86b5:  stz     near w7e88e3
        stz     near w7e88ef
        lda     near wCloseMenu
        beq     @86c6
        lda     #MENU_INPUT::THROW_CLOSE
        sta     near wMenuInput
        rts
@86c6:  ldy     near w7e62ca
.if LANG_EN
        stz     $36
.else
        lda     near w7e8957,y
        sta     $36
.endif
        lda     near w7e895b,y
        sta     $37
        lda     near w7e8953,y
        sta     $38
.if LANG_EN
        clr_a
        sta     $39         ; 1 column
.else
        lda     #1
        sta     $39         ; 2 columns
.endif
        jsr     GetCursorInput
        lda     $3c
        beq     @8701
        bmi     @86f3
        lda     near w7e8953,y
        cmp     #@MAX_SCROLL_POS
        beq     @870b
        inc
        sta     near w7e8953,y
        inc     z94
        jsr     ScrollThrowListDown
        bra     @8701
@86f3:  lda     near w7e8953,y
        beq     @870b
        dec
        sta     near w7e8953,y
        inc     z94
        jsr     ScrollThrowListUp
@8701:  lda     $36
        sta     near w7e8957,y
        lda     $37
        sta     near w7e895b,y
@870b:  lda     z04
        bpl     @872b
        inc     z96
        jsr     _c18454
        lda     near wToolsThrowItemList::ItemID,x
        cmp     #ITEM::EMPTY
        bne     @871f
        inc     z95
        bra     @872b
@871f:  sta     near w7e7a85
        lda     near wToolsThrowItemList::Targeting,x
        sta     near w7e7a84
        jmp     InitTargetSelect
@872b:  lda     z08 + 1
        bpl     @8735
        inc     z96
        jsr     CloseThrowWindow
        rts
@8735:  lda     #@MAX_SCROLL_POS
        sta     $36
        ldx     #$23ff / @MAX_SCROLL_POS + 1
        stx     $2e
        lda     near w7e8953,y
        jsr     UpdateMenuScrollArrows
.if LANG_EN
        clr_ax
.else
        lda     near w7e8957,y
        tax
.endif
        lda     f:ItemCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e895b,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [  ]

ScrollThrowListDown:
@875c:  clc
        adc     #$03
        jsr     DrawThrowListText
        lda     #MENU_INPUT::SCROLL_DOWN
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        cmp     #$04
        beq     @8774
        inc
        bra     @8775
@8774:  clr_a
@8775:  sta     near w7e7afd
        bra     _8792

; ------------------------------------------------------------------------------

ScrollThrowListUp:
@877a:  jsr     DrawThrowListText
        lda     #MENU_INPUT::SCROLL_UP
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        beq     @878d
        dec
        bra     @878f
@878d:  lda     #$04
@878f:  sta     near w7e7afd

throw_one_scr:
_8792:  lda     #$03
        sta     near w7e7ba8
        lda     #MENU_INPUT::THROW_SELECT
        sta     near wMenuInput+1
        rts

; ------------------------------------------------------------------------------

; [ update menu state $30: tools select ]

        array_label MENU_INPUT, MENU_INPUT::TOOLS_SELECT
@879d:  stz     near w7e88e3
        stz     near w7e88ef
        lda     near wCloseMenu
        beq     @87ae       ; branch if not forcing menu to close
        lda     #MENU_INPUT::TOOLS_CLOSE
        sta     near wMenuInput
        rts
@87ae:  ldy     near w7e62ca
        lda     near w7e8963,y
        sta     $36
        lda     near w7e8967,y
        sta     $37
        lda     near w7e895f,y
        sta     $38
        lda     #$01
        sta     $39         ; 2 columns
        jsr     GetCursorInput
        lda     $3c
        beq     @87eb
        bmi     @87dd

; scroll down
        lda     near w7e895f,y
        beq     @87f5       ; max scroll position is zero
        inc
        sta     near w7e895f,y
        inc     z94         ; play cursor sound effect
        jsr     ScrollToolsListDown
        bra     @87eb

; scroll up
@87dd:  lda     near w7e895f,y
        beq     @87f5       ; min scroll position is zero
        dec
        sta     near w7e895f,y
        inc     z94         ; play cursor sound effect
        jsr     ScrollToolsListUp

; no scroll
@87eb:  lda     $36
        sta     near w7e8963,y
        lda     $37
        sta     near w7e8967,y

; a button
@87f5:  lda     z04
        bpl     @8818
        inc     z96
        jsr     _c18470
        lda     near wToolsThrowItemList::ItemID,x
        cmp     #ITEM::EMPTY
        bne     @8809         ; branch if valid
        inc     z95
        bra     @8818
@8809:  lda     near wToolsThrowItemList::ItemID,x
        sta     near w7e7a85         ; set item being used
        lda     near wToolsThrowItemList::Targeting,x
        sta     near w7e7a84
        jmp     InitTargetSelect

; b button
@8818:  lda     z08 + 1
        bpl     @8822
        inc     z96
        jsr     CloseToolsWindow
        rts
@8822:  lda     near w7e8963,y
        tax
        lda     f:ToolsCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e8967,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [  ]

ScrollToolsListDown:
@883c:  clc
        adc     #$03
        jsr     DrawToolsListText
        lda     #MENU_INPUT::SCROLL_DOWN
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        cmp     #$04
        beq     @8854
        inc
        bra     @8855
@8854:  clr_a
@8855:  sta     near w7e7afd
        bra     _8872

; ------------------------------------------------------------------------------

; [  ]

ScrollToolsListUp:
@885a:  jsr     DrawToolsListText
        lda     #MENU_INPUT::SCROLL_UP
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        beq     @886d
        dec
        bra     @886f
@886d:  lda     #$04
@886f:  sta     near w7e7afd

machine_one_scr:
_8872:  lda     #$03
        sta     near w7e7ba8
        lda     #MENU_INPUT::TOOLS_SELECT
        sta     near wMenuInput+1
        rts

; ------------------------------------------------------------------------------

; [ update menu state $0a: item select ]

        array_label MENU_INPUT, MENU_INPUT::ITEM_SELECT

.if LANG_EN
        @MAX_SCROLL_POS = 255 - 4
.else
        @MAX_SCROLL_POS = 256 / 2 - 4
.endif

@887d:  stz     near w7e88e3
        stz     near w7e88ef
        lda     near wCloseMenu
        beq     @8897
        stz     near w7e7baf
        stz     near w7e7bb5
        stz     near w7e7b02
        lda     #MENU_INPUT::ITEM_CLOSE
        sta     near wMenuInput
        rts
@8897:  ldx     #$00a4                  ; don't show extra cursor above 164
        stx     near w7e7bb3
        ldy     near w7e62ca
.if LANG_EN
        clr_a
        sta     near w7e894b,y
        sta     $36
        lda     near w7e894f,y
        sta     $37
        lda     near w7e8947,y
        sta     $38
        stz     $39         ; 1 column
.else
        lda     near w7e894b,y
        sta     $36
        lda     near w7e894f,y
        sta     $37
        lda     near w7e8947,y
        sta     $38
        lda     #1
        sta     $39         ; 2 columns
.endif
        jsr     GetCursorInput
        lda     $3c
        beq     @88fb
        bmi     @88cd
        lda     near w7e8947,y
        cmp     #@MAX_SCROLL_POS
        beq     @8905
        inc
        sta     near w7e8947,y
        inc     z94
        jsr     ScrollItemListDown
        bra     @88fb
@88cd:  lda     near w7e8947,y
        bne     @88f2
        lda     $3c
        and     #$40
        bne     @88dc
.if LANG_EN
        clr_a
.else
        lda     #1
.endif
        sta     near w7e894b,y
@88dc:  lda     near w7e7b02
        beq     @88e6
        lda     near w7e7b00
        beq     @8905
@88e6:  ldx     #$00c8                  ; don't show extra cursor above 200
        stx     near w7e7bb3
        inc     z94
        jsr     OpenEquipWindow
        rts
@88f2:  dec
        sta     near w7e8947,y
        inc     z94
        jsr     ScrollItemListUp
@88fb:  lda     $36
        sta     near w7e894b,y
        lda     $37
        sta     near w7e894f,y
@8905:  lda     near w7e7ba8
        bne     @8963
        lda     z04
        bpl     @893b
        jsr     _c18a24
        bcc     @8963
        stz     near w7e7baf
        stz     near w7e7bb5
        stz     near w7e7b02
        jsr     _c189be
        lda     near wItemList::ItemID,x
        sta     near w7e7a85
        lda     near wItemList::Targeting,x                 ; copy targeting flags
        sta     near w7e7a84
        stz     near w7e7a1e
        stz     near w7eecba
        and     #$40
        jeq     array_item MENU_INPUT, MENU_INPUT::CHAR_STATUS_OPEN
        jmp     InitTargetSelect
@893b:  lda     z08 + 1
        bpl     @8963
        inc     z96
        stz     near w7e7baf
        stz     near w7e7bb5
        lda     near w7e7b02
        bne     @8955
        stz     near w7e7baf
        stz     near w7e7bb5
        jmp     CloseItemWindow
@8955:  stz     near w7e7b02
        stz     near w7e890c
        lda     #MENU_INPUT::ITEM_SELECT
        sta     near wMenuInput+1
        jsr     _c18d76
@8963:  ldy     near w7e62ca
        lda     #@MAX_SCROLL_POS
        sta     $36
        ldx     #$23ff / @MAX_SCROLL_POS + 1
        stx     $2e
        lda     near w7e8947,y
        jsr     UpdateMenuScrollArrows
        lda     near w7e894b,y
        tax
        lda     f:ItemCursorXPosTbl,x
        sta     near w7e88e3+1
        lda     near w7e894f,y
        tax
        lda     f:ListCursorYPosTbl,x
        sta     near w7e88e3+2
        inc     near w7e88e3
        rts

; ------------------------------------------------------------------------------

; [ update menu scroll arrows ]

;    A: current scroll position
; +$2e: pixels / 256 per scroll position
;  $36: max scroll position

; the y position of the scroll arrows sprite at the max scroll position is
; inconsistent for different menus, it ends up being 196 for the magic list
; and 197 for all other lists.

UpdateMenuScrollArrows:
@898f:  sta     $2c
        bne     @8997
        lda     #1                      ; 1: can scroll down
        bra     @89a0
@8997:  cmp     $36
        bne     @899f
        lda     #2                      ; 2: can scroll up
        bra     @89a0
@899f:  clr_a                           ; 0: can scroll either direction
@89a0:  sta     near w7e88ef+3
        stz     $2d
        longa
        jsr     Mult816NoHW
        shorta0
        lda     $31                     ; ignore lower 8-bits of product
        clc
        adc     #161
        sta     near w7e88ef+2               ; y position
        lda     #240
        sta     near w7e88ef+1               ; x position
        inc     near w7e88ef                 ; show scroll arrows
        rts

; ------------------------------------------------------------------------------

; [  ]

_c189be:
get_item_poi:
@89be:  phy
        lda     near w7e8947,y
        clc
        adc     near w7e894f,y
.if !LANG_EN
        asl
        clc
        adc     near w7e894b,y
.endif
        longa
        sta     $40
        asl2
        clc
        adc     $40
        tax
        shorta0
        ply
        rts

; ------------------------------------------------------------------------------

; [  ]

_c189d5:
check_equip:
@89d5:  lda     near w7e7b39
        cmp     #$ff
        beq     @8a0c
        lda     near w7e7b3b
        cmp     #$ff
        beq     @8a0c
        phx
        ldx     near w7e62ca
        lda     near w7e2e6e,x
        beq     @89fd                   ; branch if no genji glove
        plx
        lda     near w7e7b3a
        and     #$08
        beq     @8a0c
        lda     near w7e7b3c
        and     #$08
        beq     @8a0c
        bra     @8a0a
@89fd:  plx
        lda     near w7e7b3a
        ora     near w7e7b3c
        and     #$18
        cmp     #$18
        beq     @8a0c
@8a0a:  sec
        rts
@8a0c:  phx
        ldx     near w7e62ca
        lda     #$01
        sta     near w7e2f30,x
        plx
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18a18:
@8a18:  phx
        ldx     near w7e62ca
        lda     f:BitOrTbl,x
        sta     $2c
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18a24:
set_item_one:
@8a24:  inc     z96
        jsr     _c189be
        lda     near w7e7b02
        jeq     @8b23
        stx     near w7e7b05
        lda     near w7e7b00
        beq     @8a9d
        lda     near wItemList::ItemID,x
        cmp     #ITEM::EMPTY
        beq     @8a51
        jsr     _c18a18
        lda     near wItemList::UsageFlags,x
        and     #$18
        beq     @8a89
        lda     near wItemList::EquipFlags,x
        and     $2c
        bne     @8a89
@8a51:  lda     near w7e7b00
        cmp     #$01
        beq     @8a69
        ldy     near w7e7b03
        lda     near wRHandItemList::ItemID,y
        sta     near w7e7b3b
        lda     near wRHandItemList::UsageFlags,y
        sta     near w7e7b3c
        bra     @8a78
@8a69:  ldy     near w7e7b03
        lda     near wLHandItemList::ItemID,y
        sta     near w7e7b3b
        lda     near wLHandItemList::UsageFlags,y
        sta     near w7e7b3c
@8a78:  lda     near wItemList::ItemID,x
        sta     near w7e7b39
        lda     near wItemList::UsageFlags,x
        sta     near w7e7b3a
        jsr     _c189d5
        bcc     @8a90
@8a89:  inc     z95
        stz     z96
        jmp     @8b0a
@8a90:  lda     near w7e7b00
        cmp     #$01
        jne     @8c02
        jmp     @8b4d
@8a9d:  cpx     near w7e7b03
        bne     @8ace
        stz     near w7e7baf
        stz     near w7e7bb5
        lda     near wItemList::ItemID,x
        cmp     #ITEM::EMPTY
        beq     @8ab4
        lda     near wItemList::UsageFlags,x
        bpl     @8ac6
@8ab4:  inc     z95
        stz     z96
        stz     near w7e890c
        stz     near w7e7b02
        stz     near w7e7baf
        stz     near w7e7bb5
        clc
        rts
@8ac6:  lda     near wItemList::UsageFlags,x
        stz     near w7e890c
        sec
        rts
@8ace:  phy
        clr_ay
@8ad1:  lda     near wItemList,x
        sta     near w7e7b07,y
        inx
        iny
        cpy     #5
        bne     @8ad1
        ldy     near w7e7b05
        ldx     near w7e7b03
        lda     #$05
        sta     $40
@8ae8:  lda     near wItemList,x
        sta     near wItemList,y
        inx
        iny
        dec     $40
        bne     @8ae8
        clr_ax
        ldy     near w7e7b03
@8af9:  lda     near w7e7b07,x
        sta     near wItemList,y
        inx
        iny
        cpx     #5
        bne     @8af9
        stz     near w7e7b02
        ply
@8b0a:  stz     near w7e890c
        lda     #MENU_INPUT::ITEM_SELECT
        sta     near wMenuInput+1
        jsr     _c18d76
        stz     near w7e7b00
        stz     near w7e7b02
        stz     near w7e7baf
        stz     near w7e7bb5
        clc
        rts
@8b23:  stz     near w7e7b00
        stx     near w7e7b03
        inc     near w7e7b02
        lda     near w7e894b,y
        tax
        lda     f:ItemCursorXPosTbl,x
        clc
        adc     #$03
        sta     near w7e7bb0
        lda     near w7e894f,y
        tax
        lda     f:ListCursorYPosTbl,x
        tax
        stx     near w7e7bb1
        lda     #$01
        sta     near w7e7baf
        clc
        rts
@8b4d:  phy
        clr_ax
        ldy     near w7e7b03
@8b53:  lda     near wRHandItemList,y
        sta     near w7e7b07,x
        inx
        iny
        cpx     #5
        bne     @8b53
        ldx     near w7e7b05
        ldy     near w7e7b03
        lda     near wRHandItemList::ItemID,y
        cmp     near wItemList::ItemID,x
        bne     @8b85
        lda     #ITEM::EMPTY
        sta     near wRHandItemList::ItemID,y
        lda     #$80
        sta     near wRHandItemList::UsageFlags,y
        clr_a
        sta     near wRHandItemList::Targeting,y
        sta     near wRHandItemList::Qty,y
        sta     near wRHandItemList::EquipFlags,y
        jmp     @8be1
@8b85:  lda     near wItemList::ItemID,x
        sta     near wRHandItemList::ItemID,y
        lda     near wItemList::UsageFlags,x
        sta     near wRHandItemList::UsageFlags,y
        lda     near wItemList::Targeting,x
        sta     near wRHandItemList::Targeting,y
        lda     near wItemList::EquipFlags,x
        sta     near wRHandItemList::EquipFlags,y
        lda     #1
        sta     near wRHandItemList::Qty,y
        lda     near wItemList::Qty,x
        cmp     #2
        bcc     @8bae
        dec     near wItemList::Qty,x
        bra     @8bc1
@8bae:  lda     #ITEM::EMPTY
        sta     near wItemList::ItemID,x
        lda     #$80
        sta     near wItemList::UsageFlags,x
        stz     near wItemList::Targeting,x
        stz     near wItemList::Qty,x
        stz     near wItemList::EquipFlags,x
@8bc1:  lda     near w7e7b07
        sta     $40
        jsr     FindInventoryItem
        bcc     @8be1
        jsr     CheckInventoryFull
        bcs     @8beb
        clr_ay
@8bd2:  lda     near w7e7b07,y
        sta     near wItemList,x
        inx
        iny
        cpy     #5
        bne     @8bd2
        bra     @8beb
@8be1:  lda     near wItemList::Qty,x
        cmp     #99
        bcs     @8beb
        inc     near wItemList::Qty,x
@8beb:  stz     near w7e890c
        lda     #MENU_INPUT::ITEM_SELECT
        sta     near wMenuInput+1
        jsr     _c18d76
        stz     near w7e7baf
        stz     near w7e7bb5
        stz     near w7e7b02
        ply
        clc
        rts
@8c02:  phy
        clr_ax
        ldy     near w7e7b03
@8c08:  lda     near wLHandItemList,y
        sta     near w7e7b07,x
        inx
        iny
        cpx     #near wItemList::ITEM_SIZE
        bne     @8c08
        ldx     near w7e7b05
        ldy     near w7e7b03
        lda     near wLHandItemList::ItemID,y
        cmp     near wItemList::ItemID,x
        bne     @8c3a
        lda     #ITEM::EMPTY
        sta     near wLHandItemList::ItemID,y
        lda     #$80
        sta     near wLHandItemList::UsageFlags,y
        clr_a
        sta     near wLHandItemList::Targeting,y
        sta     near wLHandItemList::Qty,y
        sta     near wLHandItemList::EquipFlags,y
        jmp     @8c96
@8c3a:  lda     near wItemList::ItemID,x
        sta     near wLHandItemList::ItemID,y
        lda     near wItemList::UsageFlags,x
        sta     near wLHandItemList::UsageFlags,y
        lda     near wItemList::Targeting,x
        sta     near wLHandItemList::Targeting,y
        lda     near wItemList::EquipFlags,x
        sta     near wLHandItemList::EquipFlags,y
        lda     #1
        sta     near wLHandItemList::Qty,y
        lda     near wItemList::Qty,x
        cmp     #2
        bcc     @8c63
        dec     near wItemList::Qty,x
        bra     @8c76
@8c63:  lda     #ITEM::EMPTY
        sta     near wItemList::ItemID,x
        lda     #$80
        sta     near wItemList::UsageFlags,x
        stz     near wItemList::Targeting,x
        stz     near wItemList::Qty,x
        stz     near wItemList::EquipFlags,x
@8c76:  lda     near w7e7b07
        sta     $40
        jsr     FindInventoryItem
        bcc     @8c96
        jsr     CheckInventoryFull
        bcs     @8ca0
        clr_ay
@8c87:  lda     near w7e7b07,y
        sta     near wItemList,x
        inx
        iny
        cpy     #5
        bne     @8c87
        bra     @8ca0
@8c96:  lda     near wItemList::Qty,x
        cmp     #99
        bcs     @8ca0
        inc     near wItemList::Qty,x
@8ca0:  stz     near w7e890c
        lda     #MENU_INPUT::ITEM_SELECT
        sta     near wMenuInput+1
        jsr     _c18d76
        stz     near w7e7baf
        stz     near w7e7bb5
        stz     near w7e7b02
        ply
        clc
        rts

; ------------------------------------------------------------------------------

; [ find item in inventory ]

FindInventoryItem:
@8cb7:  clr_ax
        lda     $40
        cmp     #ITEM::EMPTY
        beq     @8cce
@8cbf:  cmp     near wItemList::ItemID,x
        beq     @8cd0
        inx5
        cpx     #$0500
        bne     @8cbf
@8cce:  sec
        rts
@8cd0:  clc
        rts

; ------------------------------------------------------------------------------

; [ check if inventory is full ]

CheckInventoryFull:
@8cd2:  clr_ax
        lda     #ITEM::EMPTY
@8cd6:  cmp     near wItemList::ItemID,x
        beq     @8ce7
        inx5
        cpx     #$0500
        bne     @8cd6
        sec
        rts
@8ce7:  clc
        rts

; ------------------------------------------------------------------------------

; [ scroll inventory list down ]

ScrollItemListDown:
@8ce9:  clc
        adc     #$03
        jsr     DrawItemListText
        ldx     near w7e7bb1
        dex4
        stx     near w7e7bb1
        lda     #MENU_INPUT::SCROLL_DOWN
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        cmp     #$04
        beq     @8d0b
        inc
        bra     @8d0c
@8d0b:  clr_a
@8d0c:  sta     near w7e7afd
        bra     _8d33

; ------------------------------------------------------------------------------

; [ scroll inventory list up ]

ScrollItemListUp:
@8d11:  jsr     DrawItemListText
        ldx     near w7e7bb1
        inx4
        stx     near w7e7bb1
        lda     #MENU_INPUT::SCROLL_UP
        sta     near wMenuInput
        jsr     _c18269
        lda     near w7e7afd
        beq     @8d2e
        dec
        bra     @8d30
@8d2e:  lda     #$04
@8d30:  sta     near w7e7afd

item_one_scr:
_8d33:  lda     #$03
        sta     near w7e7ba8
        lda     #MENU_INPUT::ITEM_SELECT
        sta     near wMenuInput+1
        rts

; ------------------------------------------------------------------------------

; [ update menu state $31:  ]

        array_label MENU_INPUT, MENU_INPUT::ITEM_REOPEN
; redrow_item:
@8d3e:  lda     near w7e7ba7
        jsr     DrawItemListText
        lda     near w7e7ba6
        asl
        tax
        lda     f:_c18291,x
        sta     near w7e7baa
        lda     f:_c18291+1,x
        sta     near w7e7baa+1
        inc     near wEnableTfrMenuTextTiles
        inc     near w7e7ba7
        lda     near w7e7ba6
        cmp     #$04
        beq     @8d67
        inc
        bra     @8d68
@8d67:  clr_a
@8d68:  sta     near w7e7ba6
        dec     near w7e7ba5
        bne     @8d75
        lda     #MENU_INPUT::NEXT_STATE
        sta     near wMenuInput
@8d75:  rts

; ------------------------------------------------------------------------------

; [  ]

_c18d76:
redrow_item_set:
@8d76:  ldy     near w7e62ca
        lda     near w7e7afd
        cmp     #$04
        bne     @8d83
        clr_a
        bra     @8d84
@8d83:  inc
@8d84:  sta     near w7e7ba6
        lda     near w7e8947,y
        sta     near w7e7ba7
        lda     #$04
        sta     near w7e7ba5
        lda     #MENU_INPUT::ITEM_REOPEN
        sta     near wMenuInput
        rts

; ------------------------------------------------------------------------------

; [ update menu state $0c: weapon/shield select ]

        array_label MENU_INPUT, MENU_INPUT::EQUIP_SELECT
@8d98:  lda     near w7e7b02
        beq     @8da3
        lda     near w7e7b00
        sta     near w7e7bb5
@8da3:  stz     near w7e88e3       ; disable cursor
        lda     near wCloseMenu
        beq     @8db1
        lda     #MENU_INPUT::EQUIP_CLOSE
        sta     near wMenuInput
        rts
@8db1:  ldx     near w7e62ca
        lda     z04 + 1

; right button
        cmp     #>JOY_RIGHT
        bne     @8dcd       ; branch if the right button is not pressed
        inc     z94         ; play move sound effect
        lda     near w7e894b,x     ; cursor x position
        cmp     #$01        ; check if on the right item slot
        bne     @8dc8       ; branch if not in the right slot
        stz     near w7e894b,x     ; set the x position to zero
        bra     @8de1       ; branch below to close the menu
@8dc8:  inc     near w7e894b,x     ; move to the right item slot
        bra     @8dec       ; branch below to check the a button

; left button
@8dcd:  cmp     #>JOY_LEFT
        bne     @8ddd       ; branch if the left button is not pressed
        lda     near w7e894b,x     ; cursor x position
        beq     @8dec       ; branch if in the left slot
        inc     z94         ; play move sound effect
        dec     near w7e894b,x     ; move the cursor to the left item slot
        bra     @8dec

; down button
@8ddd:  cmp     #>JOY_DOWN
        bne     @8dec
@8de1:
.if LANG_EN
        stz     near w7e894b,x     ; clear cursor x position
.endif
        stz     near w7e7bb5
        inc     z94         ; play move sound effect
        jmp     CloseEquipWindow

; A button
@8dec:  lda     z04
        bpl     @8e08
        ldx     near w7e62ca
        lda     near w7e6286,x
        beq     @8dfc       ; branch if can change equipment
        inc     z95         ; play error sound effect
        bra     @8e08
@8dfc:  lda     #1
        sta     near w7e2f30,x     ; set equipment change flag
        inc     z96         ; play confirm sound effect
        jsr     SelectEquipItem
        bcc     @8e08

; B button
@8e08:  lda     z08 + 1
        bpl     @8e1d
        inc     z96         ; play confirm sound effect
        stz     near w7e890c
        jsr     _c18e34
        stz     near w7e7baf
        stz     near w7e7bb5
        stz     near w7e7b02
@8e1d:  ldx     near w7e62ca
        lda     near w7e894b,x               ; cursor x position (0 or 1)
        tax
        lda     f:EquipCursorXPosTbl,x
        sta     near w7e88e3+1               ; sprite x position
        lda     #180
        sta     near w7e88e3+2               ; sprite y position
        inc     near w7e88e3                 ; enable cursor
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18e34:
set_hand_item_mess:
@8e34:  jsr     DrawEquipListText
        ldx     #$7e40
        stx     near w7e7baa
        inc     near wEnableTfrMenuTextTiles
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c18e40:
set_item_mess:
@8e40:  lda     #MENU_INPUT::EQUIP_SELECT
        sta     near wMenuInput+1
        jmp     _c18d76

; ------------------------------------------------------------------------------

; [  ]

_c18e48:
get_hand_poi:
@8e48:  ldx     near w7e62ca
        lda     f:CharEquipPtrs,x
        tax
        rts

; ------------------------------------------------------------------------------

; [ select an item in the equip menu ]

SelectEquipItem:
@8e51:  jsr     _c18e48
        ldy     near w7e62ca
        lda     near w7e7b02
        bne     @8e5f
        jmp     @8f28
@8e5f:  stx     near w7e7b05
        lda     near w7e7b00
        bne     @8e6a
        jmp     @8efe
@8e6a:  lda     near w7e894b,y
        inc
        cmp     near w7e7b00
        beq     @8ec9
        clr_ay
@8e75:  lda     near wRHandItemList,x
        sta     near w7e7b07,y
        inx
        iny
        cpy     #near wItemList::ITEM_SIZE
        bne     @8e75
        sty     $40
        ldx     near w7e7b05
@8e87:  lda     near wLHandItemList::ItemID,x
        sta     near wRHandItemList,x
        inx
        dec     $40
        bne     @8e87
        ldx     near w7e7b05
        clr_ay
@8e97:  lda     near w7e7b07,y
        sta     near wLHandItemList::ItemID,x
        inx
        iny
        cpy     #near wItemList::ITEM_SIZE
        bne     @8e97
        stz     near w7e890c
        jsr     DrawEquipListText
        ldx     #$7e40
        stx     near w7e7baa
        inc     near wEnableTfrMenuTextTiles
        stz     near w7e7b02
        stz     near w7e7baf
        stz     near w7e7bb5
        jsr     _c18e40
        ldx     near w7e62ca
        lda     #$01
        sta     near w7e2f30,x
        clc
        rts
@8ec9:  stz     near w7e7b02
        stz     near w7e7baf
        stz     near w7e7bb5
        stz     near w7e890c
        lda     near w7e894b,y
        beq     @8ee8
        lda     near wLHandItemList::ItemID,x
        cmp     #ITEM::UNARMED
        beq     @8ef9
        lda     near wLHandItemList::UsageFlags,x
        bpl     @8ef4
        bra     @8ef9
@8ee8:  lda     near wRHandItemList::ItemID,x
        cmp     #ITEM::UNARMED
        beq     @8ef9
        lda     near wRHandItemList::UsageFlags,x
        bmi     @8ef9
@8ef4:  jsr     _c18e40
        sec
        rts
@8ef9:  jsr     _c18e40
        clc
        rts
@8efe:  lda     near w7e894b,y
        beq     @8f08
        jsr     _c1903d
        bra     @8f0b
@8f08:  jsr     _c18f76
@8f0b:  stz     near w7e890c
        jsr     DrawEquipListText
        ldx     #$7e40
        stx     near w7e7baa
        inc     near wEnableTfrMenuTextTiles
        stz     near w7e7b02
        stz     near w7e7baf
        stz     near w7e7bb5
        jsr     _c18e40
        clc
        rts
@8f28:  lda     #$01
        sta     near w7e890c
        lda     near w7e894b,y
        bne     @8f40
        lda     near wLHandItemList::ItemID,x
        sta     near w7e890d
        lda     near wLHandItemList::UsageFlags,x
        sta     near w7e890e
        bra     @8f4c
@8f40:  lda     near wRHandItemList::ItemID,x
        sta     near w7e890d
        lda     near wRHandItemList::UsageFlags,x
        sta     near w7e890e
@8f4c:  lda     near w7e894b,y
        inc
        sta     near w7e7b00
        inc     near w7e7b02
        stx     near w7e7b03
        lda     near w7e894b,y
        tax
        lda     f:EquipCursorXPosTbl,x
        clc
        adc     #$03
        sta     near w7e7bb6
        lda     #$b4
        sta     near w7e7bb7
        lda     #1
        sta     near w7e7bb5
        jsr     _c18e40
        clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c18f76:
hand_r2item:
@8f76:  ldx     near w7e7b03
        ldy     near w7e7b05
        lda     near wRHandItemList::ItemID,y
        cmp     near wItemList::ItemID,x
        bne     @8f85
@8f84:  rts
@8f85:  lda     near wItemList::ItemID,x
        cmp     #ITEM::UNARMED
        beq     @8f9d
        jsr     _c18a18
        lda     near wItemList::UsageFlags,x
        and     #$18
        beq     @8f84
        lda     near wItemList::EquipFlags,x
        and     $2c
        bne     @8f84
@8f9d:  lda     near wLHandItemList::ItemID,y
        sta     near w7e7b3b
        lda     near wLHandItemList::UsageFlags,y
        sta     near w7e7b3c
        lda     near wItemList::ItemID,x
        sta     near w7e7b39
        lda     near wItemList::UsageFlags,x
        sta     near w7e7b3a
        jsr     _c189d5
        bcs     @8f84
        ldx     near w7e7b03
        ldy     near w7e7b05
        clr_ax
        ldy     near w7e7b05
@8fc5:  lda     near wRHandItemList,y
        sta     near w7e7b07,x
        inx
        iny
        cpx     #near wItemList::ITEM_SIZE
        bne     @8fc5
        ldx     near w7e7b03
        ldy     near w7e7b05
        lda     near wItemList::ItemID,x
        sta     near wRHandItemList::ItemID,y
        lda     near wItemList::UsageFlags,x
        sta     near wRHandItemList::UsageFlags,y
        lda     near wItemList::Targeting,x
        sta     near wRHandItemList::Targeting,y
        lda     near wItemList::EquipFlags,x
        sta     near wRHandItemList::EquipFlags,y
        lda     #1
        sta     near wRHandItemList::Qty,y
        lda     near wItemList::Qty,x
        cmp     #2
        bcc     @9001
        dec     near wItemList::Qty,x
        bra     @9014
@9001:  lda     #ITEM::EMPTY
        sta     near wItemList::ItemID,x
        lda     #$80
        sta     near wItemList::UsageFlags,x
        stz     near wItemList::Targeting,x
        stz     near wItemList::Qty,x
        stz     near wItemList::EquipFlags,x
@9014:  lda     near w7e7b07
        sta     $40
        jsr     FindInventoryItem
        bcc     @9032
        jsr     CheckInventoryFull
        clr_ay
@9023:  lda     near w7e7b07,y
        sta     near wItemList,x
        inx
        iny
        cpy     #near wItemList::ITEM_SIZE
        bne     @9023
        bra     @903c
@9032:  lda     near wItemList::Qty,x
        cmp     #99
        bcs     @903c
        inc     near wItemList::Qty,x
@903c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c1903d:
hand_l2item:
@903d:  ldx     near w7e7b03
        ldy     near w7e7b05
        lda     near wLHandItemList::ItemID,y
        cmp     near wItemList::ItemID,x
        bne     @904c
@904b:  rts
@904c:  lda     near wItemList::ItemID,x
        cmp     #ITEM::EMPTY
        beq     @9064
        jsr     _c18a18
        lda     near wItemList::UsageFlags,x
        and     #$18
        beq     @904b
        lda     near wItemList::EquipFlags,x
        and     $2c
        bne     @904b
@9064:  lda     near wRHandItemList::ItemID,y
        sta     near w7e7b3b
        lda     near wRHandItemList::UsageFlags,y
        sta     near w7e7b3c
        lda     near wItemList::ItemID,x
        sta     near w7e7b39
        lda     near wItemList::UsageFlags,x
        sta     near w7e7b3a
        jsr     _c189d5
        bcs     @904b
        ldx     near w7e7b03
        ldy     near w7e7b05
        clr_ax
        ldy     near w7e7b05
@908c:  lda     near wLHandItemList::ItemID,y
        sta     near w7e7b07,x
        inx
        iny
        cpx     #wItemList::ITEM_SIZE
        bne     @908c
        ldx     near w7e7b03
        ldy     near w7e7b05
        lda     near wItemList::ItemID,x
        sta     near wLHandItemList::ItemID,y
        lda     near wItemList::UsageFlags,x
        sta     near wLHandItemList::UsageFlags,y
        lda     near wItemList::Targeting,x
        sta     near wLHandItemList::Targeting,y
        lda     near wItemList::EquipFlags,x
        sta     near wLHandItemList::EquipFlags,y
        lda     #1
        sta     near wLHandItemList::Qty,y
        lda     near wItemList::Qty,x
        cmp     #2
        bcc     @90c8
        dec     near wItemList::Qty,x
        bra     @90db
@90c8:  lda     #ITEM::EMPTY
        sta     near wItemList::ItemID,x
        lda     #$80
        sta     near wItemList::UsageFlags,x
        stz     near wItemList::Targeting,x
        stz     near wItemList::Qty,x
        stz     near wItemList::EquipFlags,x
@90db:  lda     near w7e7b07
        sta     $40
        jsr     FindInventoryItem
        bcc     @90f9
        jsr     CheckInventoryFull
        clr_ay
@90ea:  lda     near w7e7b07,y
        sta     near wItemList,x
        inx
        iny
        cpy     #5
        bne     @90ea
        bra     @9103
@90f9:  lda     near wItemList::Qty,x
        cmp     #99
        bcs     @9103
        inc     near wItemList::Qty,x
@9103:  rts

; ------------------------------------------------------------------------------

; magitek attack target flags
MagitekAttackTargetFlags:
@9104:  .byte   $43, $43, $43, $6a, $03, $6a, $43, $43

; Terra's magitek attacks
TerraMagitekAttackTbl:
@910c:  .byte   $00, $01, $02, $03, $04, $05, $06, $07

; other character magitek attacks
DefaultMagitekAttackTbl:
@9114:  .byte   $00, $01, $02, $ff, $04, $ff, $ff, $ff

; ------------------------------------------------------------------------------

; [ update menu state $41: status window for character target select ]

        array_label MENU_INPUT, MENU_INPUT::CHAR_STATUS_SELECT
@911c:  lda     #MENU_INPUT::CHAR_STATUS_CLOSE
        sta     near wMenuInput
        jmp     InitTargetSelect

; ------------------------------------------------------------------------------
