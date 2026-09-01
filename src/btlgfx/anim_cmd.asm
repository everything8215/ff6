
.include "src/sound/sfx.inc"

.enum WEAPON_ANIM_TYPE
        NORMAL
        THROWN
        BOOMERANG
        LONG_ATMA_WEAPON
        SHORT_ATMA_WEAPON

        COUNT
.endenum

; ------------------------------------------------------------------------------

; animation scripts for block animations (knife, sword, shield, zephyr cape, hand up, golem, dog)
BlockAnimScriptTbl:
@b74b:  .byte   $45,$46,$48,$47,$40,$44,$43

; palettes for block animations (see BlockPal)
BlockPalTbl:
@b752:  .byte   2,2,1,0,0,1,3

; default sound effects for block animations
BlockSfxTbl:
@b759:  .byte   SFX::SHIELD_BLOCK
        .byte   SFX::SHIELD_BLOCK
        .byte   SFX::SHIELD_BLOCK
        .byte   SFX::SHIELD_BLOCK
        .byte   SFX::SHIELD_BLOCK
        .byte   SFX::SHIELD_BLOCK
        .byte   SFX::SHIELD_BLOCK

; ------------------------------------------------------------------------------

; [ graphics script command $06: show attack animation ]

        array_label GFX_CMD, GFX_CMD::ATTACK_ANIM
; anim_command:
@b760:  jsr     ClearThreadData
        stz     near w7eecbb
        ldy     #1
        lda     (z76),y                 ; attack command
        bmi     @b772
        asl
        tax
        jsr     (near CmdAnimTbl,x)
@b772:  jmp     NextGfxCmdData

; attack command jump table
CmdAnimTbl:
        ptr_tbl GFX_BATTLE_CMD

; ------------------------------------------------------------------------------

; [ attack command $1d: magitek ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::MAGITEK
        ldy     #2
        lda     (z76),y
        cmp     #ATTACK::BIO_BLAST_MAGITEK
        bcc     @b7d7

; other magitek attacks
        lda     #BATTLE_CMD_ANIM::MAGITEK
        jsr     _c1b8a4
        jsr     MagicCmdAnim
        jmp     _c1b86b

; fire, ice, or bolt beam
@b7d7:  ldy     #4
        lda     (z78),y
        iny
        ora     (z78),y
        bne     @b7e6
        lda     #BATTLE_CMD_ANIM::MAGITEK
        jmp     _c1b8a4
@b7e6:  jmp     MagicCmdAnim

; ------------------------------------------------------------------------------

; [ attack command $22: run away ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::RUN_AWAY
        inc     near w7e62a4                 ; doing run away animation
        lda     #BATTLE_CMD_ANIM::RUN_AWAY
        jmp     _c1b8a4

; ------------------------------------------------------------------------------

; [ attack command $21: roulette (monster attacker) ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::ROULETTE
        jsr     InitMonsterRoulette
        rts

; ------------------------------------------------------------------------------

; [ execute single thread animation ]

; +X: pointer to attack animation properties (+$d07fb2)

ExecSimpleAnim:
        phx
        jsr     _c19aa2
        jsr     InitSimpleAnim
        plx
        stx     $1e
        clr_a
        jsr     LoadAnimProp
        jsr     ExecAnim
        jsr     InitSimpleAnim
        rts

; ------------------------------------------------------------------------------

; [ attack command $14: row ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::ROW
        jsr     GetAttackerNum
        lda     $10
        bmi     @b867       ; return if a monster
        asl5
        tay
        lda     near w7e201f       ; battle type
        asl2
        clc
        adc     $10
        tax
        lda     near wCharGfxDataBuf::Row,y     ; toggle row
        eor     #1
        sta     near wCharGfxDataBuf::Row,y
        and     #1
        beq     @b834       ; branch if front
        stz     $11
        lda     f:_c2a86f,x   ; horizontal movement speed (back row)
        bra     @b838
@b834:  lda     f:_c2a87f,x   ; horizontal movement speed (front row)
@b838:  sta     $10
        bpl     @b83e
        dec     $11         ; make $10 16-bit (+$10)
@b83e:  lda     #CHAR_ACTION::WALKING_FORWARD
        sta     near wCharGfxData::AnimAction,y     ; secondary graphical action = 4 (walking forward)
        lda     #6        ; 6 frames
@b845:  pha
        phy
        ldx     $10
        phx
        jsr     WaitFrame
        plx
        stx     $10         ; movement speed
        ply
        longa
        lda     near wCharGfxData::w7e61c9,y     ; add to character xy angle
        clc
        adc     $10
        sta     near wCharGfxData::w7e61c9,y
        shorta0
        pla
        dec                 ; decrement frame counter
        bne     @b845
        clr_a
        sta     near wCharGfxData::AnimAction,y
@b867:  jsr     WaitFrame
        rts

; ------------------------------------------------------------------------------

; [ step back after attack ]

_c1b86b:
inc_magic_play_start_flag:
@b86b:  jsr     GetAttackerNum
        lda     $10
        bmi     @b87f       ; branch if a monster
        and     #%11
        phx
        tax
        lda     near w7e62a4                 ; branch if doing run away animation
        bne     @b87e
        inc     near w7e61ae,x     ; need to step forward and back
@b87e:  plx
@b87f:  rts

; ------------------------------------------------------------------------------

; [ init event animation (long access) ]

; used by monster animations

InitEventAnimThreads_far:
        jsr     InitEventAnimThreads
        rtl

; ------------------------------------------------------------------------------

; [ init event animation ]

; used by event animations and monster animations

; +$1e: pointer to attack animation properties (+$d07fb2)

InitEventAnimThreads:
        stz     near w7e62c0       ; don't ignore block graphics
        ldx     $1e
        clr_a
        jsr     LoadAnimProp
        jmp     InitAnimThreads

; ------------------------------------------------------------------------------

; [ execute command animation (block graphics enabled) ]

; A: command animation number (animation data pointer at +$c2b4be)

ExecCmdAnimAllowBlock:
_c1b890:
; set_caster_animation2:
@b890:  asl
        tax
        longa
        ldy     #4
        lda     (z78),y
        pha
        lda     f:CmdAnimPropPtrs,x
        tax
        shorta0
        bra     ExecCmdAnimMain

; ------------------------------------------------------------------------------

; [ execute command animation ]

; A: command animation number (animation data pointer at +$c2b4be)

ExecCmdAnimNoMiss:
_c1b8a4:
set_caster_animation:
@b8a4:  inc     near w7e62c0       ; ignore block graphics
        asl
        tax
        longa
        ldy     #4
        lda     (z78),y     ; save targets hit
        pha
        ldy     #2
        lda     (z78),y     ; copy all targets to targets hit
        iny2
        sta     (z78),y
        lda     f:CmdAnimPropPtrs,x
        tax
        shorta0

ExecCmdAnimMain:
        phx
        jsr     PushMonsterPalID
        jsr     SetAnimTargets
        jsr     _c1ab8b       ; reset attacker graphical action
        plx
        jsr     ExecSimpleAnim
        jsr     PopMonsterPalID
        jsr     _c1ab8b       ; reset attacker graphical action
        longa
        pla
        ldy     #4
        sta     (z78),y     ; restore targets hit
        shorta0
        stz     near w7e62c0       ; don't ignore block graphics
        rts

; ------------------------------------------------------------------------------

; [ attack command $0c: lore ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::LORE
        jsr     InitCmdAnim
        lda     (z78)
        and     #$10
        bne     @b8f7
        lda     (z78)
        bmi     @b8f7
        lda     #BATTLE_CMD_ANIM::LORE
        jsr     _c1bbe1
@b8f7:  jsr     CheckNullTarget
        bcc     @b8ff
        jsr     MagicCmdAnim
@b8ff:  rts

; ------------------------------------------------------------------------------

; [ attack command $0f: slot ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::SLOT
        jsr     InitCmdAnim
        ldx     #attack_anim_prop_offset STEP_FORWARD               ; walk forward with arms up
        jsr     ExecSimpleAnim
        lda     (z78)
        bmi     @b919                   ; return if attacker is a monster
        jsr     MagicCmdAnim
        jsr     _c1ac35
        jsr     _c1b86b
        jsr     PopMonsterPalID
@b919:  rts

; ------------------------------------------------------------------------------

; [ attack command $0a: blitz ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::BLITZ
        jsr     InitCmdAnim
        lda     #BATTLE_CMD_ANIM::BLITZ
        jsr     _c1b8a4
        jsr     CheckNullTarget
        bcc     @b93a
        ldx     #attack_anim_prop_offset PUMMEL
        stx     $1e
        ldy     #2
        lda     (z76),y
        jsr     LoadAnimProp
        jsr     ExecAnim
        jsr     PopMonsterPalID
@b93a:  jsr     _c1b86b
        jsr     _c1ab8b       ; reset attacker graphical action
        rts

; ------------------------------------------------------------------------------

; [ check if there are no targets ]

; carry clear = no targets (out)

CheckNullTarget:
@b941:  ldy     #2
        clr_a
@b945:  ora     (z78),y     ; check possible targets, targets hit, targets reflected off, ...
        iny
        cpy     #12
        bne     @b945
        cmp     #0
        beq     @b953
        sec
        rts
@b953:  clc
        rts

; ------------------------------------------------------------------------------

; [ attack command $26: dice roll ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::DICE_ROLL
        jsr     InitCmdAnim
        ldy     #2
        lda     (z76),y     ; die 1
        and     #$0f
        sta     near w7eebfb
        lda     (z76),y
        and     #$f0
        sta     (z76),y
        iny
        lda     (z76),y     ; die 2
        lsr4
        sta     near w7eebfc
        lda     (z76),y     ; die 3
        and     #$0f
        sta     near w7eebfd
        lda     #ITEM::DICE
        sta     (z76),y     ; set item $51 (dice)
        lda     near w7eebfb
        cmp     #$0f
        bne     @b988       ; branch if die 1 is enabled (3 dice)
        lda     #BATTLE_CMD_ANIM::TWO_DICE
        bra     @b98a
@b988:  lda     #BATTLE_CMD_ANIM::THREE_DICE
@b98a:  jmp     _c1b8a4

; ------------------------------------------------------------------------------

; [ attack command $07: swdtech ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::BUSHIDO
        jsr     InitCmdAnim
        lda     near w7e60ae
        bne     @b9a4       ; branch if not first swdtech hit (graphics are already loaded)
        jsr     _c1ab8b       ; reset attacker graphical action
        lda     #BATTLE_CMD_ANIM::BUSHIDO
        jsr     _c1bbe1
        jsr     CheckNullTarget
        bcc     @b9c4
        bra     @b9ac
@b9a4:  jsr     CheckNullTarget
        bcc     @b9c4
        jsr     SetAnimTargets
@b9ac:  jsr     _c19aa2
        ldx     #attack_anim_prop_offset DISPATCH
        stx     $1e
        ldy     #2
        lda     (z76),y
        bmi     @b9c4
        jsr     LoadAnimProp
        jsr     ExecAnim
        jsr     PopMonsterPalID
@b9c4:  rts

; ------------------------------------------------------------------------------

; [ attack command $08: throw ]

; item jump and throw animation data (d1/0040)
;
; djjjtttt
;   d: use normal "fight" animation when thrown (ignore "t" value)
;   j: jump animation
;        0: unarmed
;        1: thick knife
;        2: thin knife
;        3: sword
;        4: katana
;        5: rod
;        6: spear
;        7: hawk eye/sniper
;   t: throw animation
;        0: thick knife
;        1: thin knife
;        2: sword
;        3: katana
;        4: rod
;        5: spear
;        6: hawk eye/sniper
;        7: ???
;        8: fire skean
;        9: water edge
;        10: bolt edge
;        11: inviz edge
;        12: shadow edge
;        13: full moon/morning star/rising sun
;        14: boomerang
;        15: ???

        array_label GFX_BATTLE_CMD, BATTLE_CMD::THROW
        jsr     InitCmdAnim
        ldy     #2
        lda     (z76),y     ; item number
        inc
        tax
        lda     f:ItemJumpThrowAnim,x
        bpl     @b9df
        clr_a
        sta     (z76),y
        txa
        iny
        sta     (z76),y
        jmp     FightCmdAnim
@b9df:  and     #$0f
        clc
        adc     #BATTLE_CMD_ANIM::THROW_THICK_KNIFE
        jsr     _c1bbe1
        rts

; ------------------------------------------------------------------------------

; [ attack command $0d: sketch ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::SKETCH
        inc     near w7eecbb
        jsr     InitCmdAnim
        lda     #BATTLE_CMD_ANIM::SKETCH
        jsr     _c1b890
        jsr     _c1b86b
        rts

; ------------------------------------------------------------------------------

; [ attack command $16: jump ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::JUMP
        lda     (z78)       ; dragon horn effect
        and     #$02
        sta     near wDragonHornActive
        jsr     _c19aa2
        lda     (z78)
        bpl     @ba18       ; branch if attacker is a character

; monster attacker
        ldy     #4
        lda     (z78),y     ; targets hit
        iny
        ora     (z78),y
        bne     @ba13       ; branch if something was hit
        lda     #BATTLE_CMD_ANIM::JUMP_MONSTER_MISS
        bra     @ba15
@ba13:  lda     #BATTLE_CMD_ANIM::JUMP_MONSTER
@ba15:  jmp     _c1bbe1

; character attacker
@ba18:  ldy     #2
        lda     (z78),y     ; targets
        iny
        ora     (z78),y
        bne     @ba27       ; branch if there are targets
        lda     #BATTLE_CMD_ANIM::JUMP_CHAR_MISS
        jmp     _c1bbe1
@ba27:  ldy     #1
        lda     (z78),y     ; attacker
        tax
        lda     f:CharEquipPtrs,x
        tax
        lda     near wRHandItemList::UsageFlags,x     ; branch if right-hand item can be used with jump
        and     #$10
        bne     @ba4a
        lda     near wLHandItemList::UsageFlags,x     ; branch if left-hand item can be used with jump
        and     #$10
        bne     @ba44
        lda     #ITEM::UNARMED
        bra     @ba4e
@ba44:  lda     near wLHandItemList::ItemID,x
        inc
        bra     @ba4e
@ba4a:  lda     near wRHandItemList::ItemID,x     ; right-hand item
        inc
@ba4e:  tax
        lda     f:ItemJumpThrowAnim,x
        and     #$7f
        lsr4
        clc
        adc     #BATTLE_CMD_ANIM::JUMP_UNARMED
        jmp     _c1bbe1

; ------------------------------------------------------------------------------

; [ attack command $24: throw (umaro) ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::UMARO_THROW
        jsr     InitCmdAnim
        jsr     CheckNullTarget
        bcs     @ba83

; find Umaro's slot
        clr_axy
@ba6a:  lda     near wCharGfxDataBuf::CharID,x
        cmp     #CHAR::UMARO
        beq     @ba7d
        iny
        txa
        clc
        adc     #wCharGfxDataBuf::ITEM_SIZE
        tax
        cpx     #wCharGfxDataBuf::SIZE
        bne     @ba6a
        rts
@ba7d:  tya
        ldy     #1
        sta     (z78),y
@ba83:  jsr     NullTargetAnim
        bcc     @ba8d
        lda     #BATTLE_CMD_ANIM::UMARO_THROW
        jmp     _c1b8a4
@ba8d:  rts

; ------------------------------------------------------------------------------

; [ attack command $23: tackle (umaro) ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::UMARO_TACKLE
        jsr     InitCmdAnim
        jsr     NullTargetAnim
        bcc     @ba9b
        lda     #BATTLE_CMD_ANIM::UMARO_TACKLE
        jsr     _c1bbe1
@ba9b:  rts

; ------------------------------------------------------------------------------

; [ attack command $1c: possess ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::POSSESS
        jsr     NullTargetAnim
        bcc     @baa9
        lda     #BATTLE_CMD_ANIM::POSSESS
        jsr     _c1b890
        jsr     _c1b86b
@baa9:  rts

; ------------------------------------------------------------------------------

; [ attack command $0b: runic ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::RUNIC
        jsr     InitCmdAnim
        lda     (z78)
        bmi     @bab6
        lda     #BATTLE_CMD_ANIM::RUNIC
        jsr     _c1bbe1
@bab6:  rts

; ------------------------------------------------------------------------------

; [ attack command $25: runic absorb ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::RUNIC_ABSORB
        jsr     InitCmdAnim
        lda     (z78)
        and     #$40
        bne     @bac5
        lda     #BATTLE_CMD_ANIM::RUNIC_ABSORB
        jsr     _c1bbe1
@bac5:  rts

; ------------------------------------------------------------------------------

; [ change battle bg for dance ]

ChangeDanceBattleBG_far:
        jsr     ChangeDanceBattleBG
        rtl

; ------------------------------------------------------------------------------

; [ change battle bg for dance ]

; A: new battle bg index

ChangeDanceBattleBG:
        pha
        jsr     CopyPal

; fade out battle bg palettes
        lda     #$00
@bad0:  pha
        sta     $14
        sta     $16
        sta     $18
        jsr     _ebe0
        jsr     WaitFrame
        pla
        inc2
        cmp     #$20
        bne     @bad0

; load new battle bg
        pla
        pha
        jsr     _c11bdc
        pla
        sta     near w7eecb8
        clr_ax
        stx     near w7e64b0
        stx     near w7e64b2

; fade in battle bg palettes
        lda     #$1e
@baf7:  pha
        sta     $14
        sta     $16
        sta     $18
        jsr     _ebe0
        jsr     WaitFrame
        pla
        dec2
        bne     @baf7
        rts

; ------------------------------------------------------------------------------

; [ attack command $20: dance fail ]

        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::DANCE_FAIL
        jsr     InitCmdAnim
        lda     #BATTLE_CMD_ANIM::DANCE_FAIL
        jmp     _c1bbe1

; ------------------------------------------------------------------------------

; [ attack command $13: dance ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::DANCE
        jsr     InitCmdAnim
        lda     near w7eecb8       ; battle bg index
        tax
        lda     f:DanceNoChangeBGTbl,x
        bne     _bb2b
        ldy     #3
        lda     (z76),y
        cmp     #$ff
        beq     _bb2b
        jsr     ChangeDanceBattleBG
; fall through

; ------------------------------------------------------------------------------

; [ attack command $10: rage ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::RAGE
_bb2b:  inc     near w7eecbb
        jsr     InitCmdAnim
        lda     (z78)
        and     #$10
        bne     @bb40
        lda     (z78)
        bmi     @bb40
        lda     #BATTLE_CMD_ANIM::RAGE
        jsr     _c1bbe1
@bb40:  jsr     CheckNullTarget
        bcc     @bb48
        jsr     MagicCmdAnim
@bb48:  rts

; ------------------------------------------------------------------------------

; [ attack command $1b: shock ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::SHOCK
        jsr     NullTargetAnim
        bcc     @bb53
        lda     #BATTLE_CMD_ANIM::SHOCK
        jsr     _c1bbe1
@bb53:  rts

; ------------------------------------------------------------------------------

; [ attack command $0e: control ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::CONTROL
        jsr     NullTargetAnim
        bcc     @bb61
        lda     #BATTLE_CMD_ANIM::CONTROL
        jsr     _c1b890
        jsr     _c1b86b
@bb61:  rts

; ------------------------------------------------------------------------------

; [ attack command $1a: health ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::HEALTH
        jsr     NullTargetAnim
        bcc     @bb75
        jsr     InitCmdAnim
        ldx     #attack_anim_prop_offset STEP_FORWARD      ; pointer to animation data $011a (walk forward with arms up)
        jsr     ExecSimpleAnim
        lda     #BATTLE_CMD_ANIM::HEALTH
        jsr     _c1bbe1
@bb75:  rts

; ------------------------------------------------------------------------------

; [ attack command $11: leap ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::LEAP
        jsr     InitCmdAnim
        jsr     NullTargetAnim
        bcc     @bb86
        lda     #BATTLE_CMD_ANIM::LEAP
        jsr     _c1b890
        jsr     _c1b86b
@bb86:  rts

; ------------------------------------------------------------------------------

; [ attack command $05: steal ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::STEAL
        jsr     InitCmdAnim
        lda     (z78)
        bmi     @bb9b
        jsr     NullTargetAnim
        bcc     @bb9b
        lda     #BATTLE_CMD_ANIM::STEAL
        jsr     _c1b8a4
        jmp     InitCmdAnim
@bb9b:  jsr     InitCmdAnim
        ldx     #attack_anim_prop_offset MONSTER_STEAL
        jsr     ExecSimpleAnim
        rts

; ------------------------------------------------------------------------------

; [ attack command $06: capture ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::CAPTURE
        jsr     InitCmdAnim
        lda     (z78)                   ; attacker
        bmi     @bbdb                   ; return if a monster
        jsr     NullTargetAnim
        bcc     @bbdb
        jsr     GetAttackerNum
        lda     $10
        and     #$03
        tax
        phx
        lda     near w7e62a4                 ; branch if doing run away animation
        bne     @bbc2
        inc     near w7e61ae,x               ; need to step forward and back
@bbc2:  lda     #BATTLE_CMD_ANIM::CAPTURE_TO
        jsr     _c1b8a4
        jsr     FightCmdAnim
        lda     #BATTLE_CMD_ANIM::CAPTURE_FROM
        jsr     _c1b8a4
        plx
        lda     near w7e62a4                 ; branch if doing run away animation
        bne     @bbd8
        stz     near w7e61ae,x               ; don't need to step forward and back
@bbd8:  jsr     InitCmdAnim
@bbdb:  rts

; ------------------------------------------------------------------------------

; [ attack command $04: revert ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::REVERT
        jsr     InitCmdAnim
        lda     #BATTLE_CMD_ANIM::REVERT
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c1bbe1:
@bbe1:  jsr     _c1b8a4
        jmp     _c1b86b

; ------------------------------------------------------------------------------

; [ attack command $03: morph ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::MORPH
        jsr     InitCmdAnim
        clr_a   ; #BATTLE_CMD_ANIM::MORPH
        bra     _c1bbe1

; ------------------------------------------------------------------------------

; [ attack command $18: gp rain ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::GIL_TOSS
        jsr     NullTargetAnim
        bcc     @bbf6
        lda     #BATTLE_CMD_ANIM::GIL_TOSS
        bra     _c1bbe1
@bbf6:  rts

; ------------------------------------------------------------------------------

; [ error animation if there are no valid targets ]

; return carry set if no error

NullTargetAnim:
@bbf7:  jsr     CheckNullTarget
        bcs     @bc11
        jsr     InitCmdAnim
        lda     (z78)
        bmi     @bc11
        ldx     #attack_anim_prop_offset STEP_FORWARD      ; pointer to animation data $011a (walk forward with arms up)
        jsr     ExecSimpleAnim
        jsr     _c1b86b
        jsr     PopMonsterPalID
        clc
        rts
@bc11:  sec
        rts

; ------------------------------------------------------------------------------

; [ attack command $09: tools ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::TOOLS
        jsr     InitCmdAnim
        jsr     NullTargetAnim
        bcc     @bc34
        jsr     InitCmdAnim
        ldx     #attack_anim_prop_offset NOISEBLASTER
        stx     $1e
        ldy     #2
        lda     (z76),y
        jsr     LoadAnimProp
        jsr     ExecAnim
        jsr     PopMonsterPalID
        jsr     _c1b86b
@bc34:  rts

; ------------------------------------------------------------------------------

; [ init command animation ]

InitCmdAnim:
@bc35:  jsr     PushMonsterPalID
        jsr     SetAnimTargets
        jsr     _c1ab8b       ; reset attacker graphical action
        jmp     _c19aa2

; ------------------------------------------------------------------------------

; [ attack command $01: item ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::ITEM
        jsr     InitCmdAnim
        lda     (z78)
        bmi     @bc51
        ldx     #attack_anim_prop_offset STEP_FORWARD      ; pointer to animation data $011a (walk forward with arms up)
        jsr     ExecSimpleAnim
        jsr     _c1b86b
@bc51:  jsr     CheckNullTarget
        bcc     @bc85
        ldy     #2
        lda     (z76),y     ; item number
        cmp     #$e0
        bcc     @bc64       ; branch if not a usable item
        sec
        sbc     #$e0
        bra     @bc66
@bc64:  lda     #$e0
@bc66:  longa
        asl
        tax
        lda     f:ItemAnimPtrs,x
        tax
        shorta0
        cpx     #$ffff      ; branch if no animation
        beq     @bc85
        phx
        jsr     InitSimpleAnim
        plx
        stx     $1e
        clr_a
        jsr     LoadAnimProp
        jsr     ExecAnim
@bc85:  jmp     PopMonsterPalID

.pushseg
.segment "item_anim"

; d1/0000
ItemAnimPtrs:
        .word   $ffff                                           ; MARVEL_SHOES
        .word   $ffff                                           ; BACK_GUARD
        .word   $ffff                                           ; GALE_HAIRPIN
        .word   $ffff                                           ; SNIPER_SIGHT
        .word   $ffff                                           ; EXP_EGG
        .word   $ffff                                           ; TINTINABAR
        .word   $ffff                                           ; SPRINT_SHOES
        .word   attack_anim_prop_offset RENAME_CARD             ; RENAME_CARD
        .word   attack_anim_prop_offset TONIC                   ; TONIC
        .word   attack_anim_prop_offset POTION                  ; POTION
        .word   attack_anim_prop_offset X_POTION                ; X_POTION
        .word   attack_anim_prop_offset TINCTURE                ; TINCTURE
        .word   attack_anim_prop_offset ETHER                   ; ETHER
        .word   attack_anim_prop_offset X_ETHER                 ; X_ETHER
        .word   attack_anim_prop_offset ELIXIR                  ; ELIXIR
        .word   attack_anim_prop_offset MEGALIXIR               ; MEGALIXIR
        .word   attack_anim_prop_offset FENIX_DOWN              ; FENIX_DOWN
        .word   attack_anim_prop_offset REVIVIFY                ; REVIVIFY
        .word   attack_anim_prop_offset ANTIDOTE                ; ANTIDOTE
        .word   attack_anim_prop_offset EYEDROP                 ; EYEDROP
        .word   attack_anim_prop_offset SOFT                    ; SOFT
        .word   attack_anim_prop_offset REMEDY_ITEM             ; REMEDY
        .word   attack_anim_prop_offset SLEEPING_BAG            ; SLEEPING_BAG
        .word   attack_anim_prop_offset TENT                    ; TENT
        .word   attack_anim_prop_offset GREEN_CHERRY            ; GREEN_CHERRY
        .word   attack_anim_prop_offset MAGICITE                ; MAGICITE
        .word   attack_anim_prop_offset SUPER_BALL_ITEM         ; SUPER_BALL
        .word   attack_anim_prop_offset ECHO_SCREEN             ; ECHO_SCREEN
        .word   attack_anim_prop_offset SMOKE_BOMB              ; SMOKE_BOMB
        .word   attack_anim_prop_offset WARP_STONE              ; WARP_STONE
        .word   attack_anim_prop_offset DRIED_MEAT              ; DRIED_MEAT
        .word   $ffff                                           ; EMPTY

.enum THROW_ANIM
        THICK_KNIFE
        THIN_KNIFE
        SWORD
        KATANA
        ROD
        SPEAR
        HAWK_EYE
        ARISE
        FIRE_SKEAN
        WATER_EDGE
        BOLT_EDGE
        INVIZ_EDGE
        SHADOW_EDGE
        FULL_MOON
        BOOMERANG
        UNUSED
.endenum

.enum JUMP_ANIM
        UNARMED
        THICK_KNIFE
        THIN_KNIFE
        SWORD
        KATANA
        ROD
        SPEAR
        HAWK_EYE
        UNUSED
.endenum

.mac item_jump_throw_anim jump, throw
        .ifnblank throw
                .byte THROW_ANIM::throw | (JUMP_ANIM::jump << 4)
        .else
                .byte JUMP_ANIM::jump << 4
        .endif
.endmac

; d1/0040
ItemJumpThrowAnim:
        item_jump_throw_anim UNARMED
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; DIRK
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; MITHRILKNIFE
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; MAIN_GAUCHE
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; AIR_LANCET
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; THIEFKNIFE
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; ASSASSIN
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; MAN_EATER
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; SWORDBREAKER
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; GRAEDUS
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; VALIANTKNIFE
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; MITHRILBLADE
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; REGAL_CUTLASS
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; RUNE_EDGE
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; FLAME_SABRE
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; BLIZZARD
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; THUNDERBLADE
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; EPEE
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; BREAK_BLADE
        item_jump_throw_anim KATANA, KATANA                     ; DRAINER
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; ENHANCER
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; CRYSTAL
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; FALCHION
        item_jump_throw_anim KATANA, KATANA                     ; SOUL_SABRE
        item_jump_throw_anim SWORD, SWORD                       ; OGRE_NIX
        item_jump_throw_anim SWORD, SWORD                       ; EXCALIBUR
        item_jump_throw_anim SWORD, SWORD                       ; SCIMITAR
        item_jump_throw_anim SWORD, SWORD                       ; ILLUMINA
        item_jump_throw_anim KATANA, KATANA                     ; RAGNAROK
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; ATMA_WEAPON
        item_jump_throw_anim SPEAR, SPEAR                       ; MITHRIL_PIKE
        item_jump_throw_anim SPEAR, SPEAR                       ; TRIDENT
        item_jump_throw_anim SPEAR, SPEAR                       ; STOUT_SPEAR
        item_jump_throw_anim SPEAR, SPEAR                       ; PARTISAN
        item_jump_throw_anim SPEAR, SPEAR                       ; HOLY_LANCE
        item_jump_throw_anim SPEAR, SPEAR                       ; GOLD_LANCE
        item_jump_throw_anim SPEAR, SPEAR                       ; AURA_LANCE
        item_jump_throw_anim SPEAR, SPEAR                       ; IMP_HALBERD
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; IMPERIAL
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; KODACHI
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; BLOSSOM
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; HARDENED
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; STRIKER
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; STUNNER
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; ASHURA
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; KOTETSU
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; FORGED
        item_jump_throw_anim THIN_KNIFE, THIN_KNIFE             ; TEMPEST
        item_jump_throw_anim KATANA, KATANA                     ; MURASAME
        item_jump_throw_anim KATANA, KATANA                     ; AURA
        item_jump_throw_anim KATANA, KATANA                     ; STRATO
        item_jump_throw_anim KATANA, KATANA                     ; SKY_RENDER
        item_jump_throw_anim ROD, ROD                           ; HEAL_ROD
        item_jump_throw_anim ROD, ROD                           ; MITHRIL_ROD
        item_jump_throw_anim ROD, ROD                           ; FIRE_ROD
        item_jump_throw_anim ROD, ROD                           ; ICE_ROD
        item_jump_throw_anim ROD, ROD                           ; THUNDER_ROD
        item_jump_throw_anim ROD, ROD                           ; POISON_ROD
        item_jump_throw_anim ROD, ROD                           ; HOLY_ROD
        item_jump_throw_anim ROD, ROD                           ; GRAVITY_ROD
        item_jump_throw_anim ROD, ROD                           ; PUNISHER
        item_jump_throw_anim ROD, ROD                           ; MAGUS_ROD
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; CHOCOBO_BRSH
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; DAVINCI_BRSH
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; MAGICAL_BRSH
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; RAINBOW_BRSH
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; SHURIKEN
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; NINJA_STAR
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; TACK_STAR
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; FLAIL
        item_jump_throw_anim UNARMED, FULL_MOON                 ; FULL_MOON
        item_jump_throw_anim UNARMED, FULL_MOON                 ; MORNING_STAR
        item_jump_throw_anim UNARMED, BOOMERANG                 ; BOOMERANG
        item_jump_throw_anim UNARMED, FULL_MOON                 ; RISING_SUN
        item_jump_throw_anim HAWK_EYE, HAWK_EYE                 ; HAWK_EYE
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; BONE_CLUB
        item_jump_throw_anim HAWK_EYE, HAWK_EYE                 ; SNIPER
        item_jump_throw_anim UNARMED, BOOMERANG                 ; WING_EDGE
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; CARDS
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; DARTS
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; DOOM_DARTS
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; TRUMP
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; DICE
        item_jump_throw_anim UNUSED, THIN_KNIFE                 ; FIXED_DICE
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; METALKNUCKLE
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; MITHRIL_CLAW
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; KAISER
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; POISON_CLAW
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; FIRE_KNUCKLE
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; DRAGON_CLAW
        item_jump_throw_anim UNARMED, THIN_KNIFE                ; TIGER_FANGS
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; BUCKLER
        item_jump_throw_anim THICK_KNIFE, THICK_KNIFE           ; HEAVY_SHLD
        .repeat 79
        item_jump_throw_anim UNARMED
        .endrep
        item_jump_throw_anim UNARMED, FIRE_SKEAN
        item_jump_throw_anim UNARMED, WATER_EDGE
        item_jump_throw_anim UNARMED, BOLT_EDGE
        item_jump_throw_anim UNARMED, INVIZ_EDGE
        item_jump_throw_anim UNARMED, SHADOW_EDGE
        .repeat 80
        item_jump_throw_anim UNARMED
        .endrep

.popseg

; ------------------------------------------------------------------------------

; [ attack command $12/$15/$1e/$1f: mimic/def./ai/random attack ]

        array_label GFX_BATTLE_CMD, BATTLE_CMD::MIMIC
        array_label GFX_BATTLE_CMD, BATTLE_CMD::DEF
        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::GFX_BATTLE_CMD_30
        array_label GFX_BATTLE_CMD, GFX_BATTLE_CMD::GFX_BATTLE_CMD_31
        rts

; ------------------------------------------------------------------------------

; [ get attacker number ]

;    A: attacker number (out)
; +$10: attacker number (out)
;  msb: set if attacker is a monster (out)

GetAttackerNum:
@bc89:  lda     near w7e62d0
        beq     @bc93
        jsr     _c1aaad
        bra     @bca1
@bc93:  ldx     #near w7e2c6e
        stx     $10
        ldy     #1
        lda     ($10)
        and     #$80
        ora     ($10),y
@bca1:  sta     $10
        stz     $11
        rts

; ------------------------------------------------------------------------------

; [ get target number ]

; $12: target number (out)
; msb: 0 for character, 1 for monster

GetTargetNum:
@bca6:  lda     near wAnimMonsterTargets
        beq     @bcb6                   ; branch if there are no monster targets
        jsr     GetBitNum
        clc
        adc     #$04
        ora     #$80
        sta     $12
        rts
@bcb6:  lda     near wAnimCharTargets
        jsr     GetBitNum
        sta     $12
        rts

; ------------------------------------------------------------------------------

; [ save character/monster positions ]

PushObjPos:
@bcbf:  clr_axy
        longa
@bcc4:  lda     near wCharGfxData::PosX,x     ; save character positions
        sta     near w7e813b,y
        lda     near wCharGfxData::PosY,x
        sta     near w7e813b+2,y
        iny4
        txa
        clc
        adc     #$0020
        tax
        cpx     #$0080
        bne     @bcc4
        clr_ax
@bce1:  lda     near w7e80c3,x     ; save monster positions
        sta     near w7e813b,y
        lda     near w7e80cf,x
        sta     near w7e813b+2,y
        iny4
        inx2
        cpx     #$000c
        bne     @bce1
        clr_ax
@bcfa:  lda     near w7e800f,x     ; save center/bottom positions
        sta     near w7e816b,x
        inx2
        cpx     #$003c
        bne     @bcfa
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ restore character/monster positions ]

PopObjPos:
@bd0b:  clr_axy
        longa
@bd10:  lda     near w7e813b,y
        sta     near wCharGfxData::PosX,x
        lda     near w7e813b+2,y
        sta     near wCharGfxData::PosY,x
        iny4
        txa
        clc
        adc     #$0020
        tax
        cpx     #$0080
        bne     @bd10
        clr_ax
@bd2d:  lda     near w7e813b,y
        sta     near w7e80c3,x
        lda     near w7e813b+2,y
        sta     near w7e80cf,x
        iny4
        inx2
        cpx     #$000c
        bne     @bd2d
        clr_ax
@bd46:  lda     near w7e816b,x
        sta     near w7e800f,x
        inx2
        cpx     #$003c
        bne     @bd46
        shorta0
        jsr     UpdateDrawOrder
        rts

; ------------------------------------------------------------------------------

; [ init cover animation ]

InitCoverAnim:
        ldy     #8
        lda     (z78),y     ; target protected by cover
        cmp     #$04
        bcs     @bd9a       ; branch if a monster

; character
        tay
        asl
        tax
        phx
        asl4
        tax
        longa
        lda     near wCharGfxData::PosX,x
        sta     $14
        lda     near wCharGfxData::PosY,x
        sta     $16
        plx
        lda     near w7e8033,x
        sta     $24
        lda     near w7e803b,x
        sta     $26
        lda     near w7e8043,x
        sta     $28
        shorta0
        lda     near w7e7b10,y
        beq     @bd95
        ldx     #$000c
        bra     @bdd1
@bd95:  ldx     #$0000
        bra     @bdd1

; monster
@bd9a:  and     #$7f
        sec
        sbc     #$04
        asl
        tax
        longa
        lda     near w7e800f,x
        sta     $14
        lda     near w7e8027,x
        sta     $16
        lda     near w7e800f,x
        sta     $24
        lda     near w7e801b,x
        sta     $26
        lda     near w7e8027,x
        sta     $28
        shorta0
        lda     near w7e80f3,x
        eor     near w7e617e,x
        and     #$01
        bne     @bdce
        ldx     #$000c
        bra     @bdd1
@bdce:  ldx     #$0000

@bdd1:  phx
        stx     $22
        ldy     #6
        lda     (z78),y                 ; cover target
        sta     $18
        stz     $1a
@bddd:  lsr     $18
        bcc     @be33
        lda     $22
        tax
        longa
        lda     f:CoverOffsetTbl,x
        sta     $10
        lda     f:CoverOffsetTbl+2,x
        sta     $12
        lda     $22
        clc
        adc     #$0004
        sta     $22
        shorta0
        lda     $1a
        asl
        tay
        asl4
        tax
        longa
        lda     $14
        clc
        adc     $10
        sta     near wCharGfxData::PosX,x
        lda     $16
        clc
        adc     $12
        sta     near wCharGfxData::PosY,x
        lda     $24
        clc
        adc     $10
        sta     near w7e8033,y
        lda     $26
        clc
        adc     $12
        sta     near w7e803b,y
        lda     $28
        clc
        adc     $12
        sta     near w7e8043,y
        shorta0
@be33:  inc     $1a
        lda     $1a
        cmp     #$04
        bne     @bddd
        plx
        stx     $22
        ldy     #7
        lda     (z78),y
        sta     $18
        stz     $1a
@be47:  lsr     $18
        bcc     @be98
        lda     $22
        tax
        longa
        lda     f:CoverOffsetTbl,x
        sta     $10
        lda     f:CoverOffsetTbl+2,x
        sta     $12
        lda     $22
        clc
        adc     #$0004
        sta     $22
        shorta0
        lda     $1a
        asl
        tax
        longa
        lda     $14
        clc
        adc     $10
        sta     near w7e80c3,x
        lda     $16
        clc
        adc     $12
        sta     near w7e80cf,x
        lda     $24
        clc
        adc     $10
        sta     near w7e800f,x
        lda     $26
        clc
        adc     $12
        sta     near w7e801b,x
        lda     $28
        clc
        adc     $12
        sta     near w7e8027,x
        shorta0
@be98:  inc     $1a
        lda     $1a
        cmp     #$06
        bne     @be47
        rts

; ------------------------------------------------------------------------------

CoverOffsetTbl:
@bea1:  .word   $fff0,$0000,$fff8,$0008,$fff8,$fff8
        .word   $0010,$0000,$0008,$0008,$0008,$fff8

; ------------------------------------------------------------------------------

; [ load block sound effect and palette ]

InitBlockAnim:
@beb9:  phx
        pha
        tax
        lda     f:BlockSfxTbl,x
        sta     near w7ee9e7
        lda     f:BlockPalTbl,x
        jsr     LoadBlockPal
        pla
        plx
        rts

; ------------------------------------------------------------------------------

; [ attack command $00: fight ]

FightCmdAnim:
        array_label GFX_BATTLE_CMD, BATTLE_CMD::FIGHT
        lda     (z78)       ; monster weapon attack
        and     #%1
        sta     near wIsMonsterAttackAnim       ; monster attack flag
        sta     near w7eecbb
        jsr     PushMonsterPalID
        jsr     SetAnimTargets
        jsr     _c19aa2
        lda     (z78)       ; flash screen (critical)
        and     #$20
        sta     near w7e6196
        ldx     #$0400      ; size = $0400
        stx     $10
        ldx     #$b400      ; source = $7fb400 (blocking graphics)
        lda     #$7f
        ldy     #$2400      ; destination = $2400 (battle animation sprite graphics)
        jsr     WaitTfrVRAM
        lda     near wIsMonsterAttackAnim       ; branch if monster attack
        bne     @beff
        jsr     _c1b86b
@beff:  ldy     #2
        lda     (z76),y     ; left-hand weapon flag
        and     #$80
        sta     near w7e7af4
        iny
        lda     (z76),y     ; weapon animation number or monster special animation index
        sta     near wWeaponAnimIndex
        jsr     GetAttackerNum
        lda     near wWeaponAnimIndex
        jsr     InitWeaponAnim
        lda     near w7e6271       ; weapon sound effect
        sta     near w7ee9e7       ; default animation sound effect
        jsr     PushObjPos
        jsr     InitCoverAnim
        jsr     GetAttackerNum
        jsr     GetTargetNum
        lda     $10
        and     #$7f        ; attacker
        asl
        tax
        longa
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        shorta0
        lda     near w7e7b2d       ; weapon graphics frame width
        sta     near wAnimThread::FrameWidth,x
        lda     near w7e7b2d+1       ; weapon graphics frame height
        sta     near wAnimThread::FrameHeight,x
        lda     #$06
        sta     near wAnimThread::SpritePal,x     ; palette 3
        lda     $10
        and     #$03        ; attacker
        tay
        lda     near w7e7af4       ; left-hand flag
        asl
        rol
        and     #1
        eor     near w7e7b10,y     ; attacker facing direction (characters only)
        and     #$01
        tay
        lda     $10         ; branch if attacker is a character
        bpl     @bf65
        lda     #$62        ; use script $62 for monsters
        bra     @bf68
@bf65:  lda     near w7e626b,y     ; weapon animation script
@bf68:  longa
        asl
        phx
        tax
        lda     f:AttackAnimScriptPtrs,x
        plx
        sta     $22
        inc2
        sta     near wAnimThread::ScriptPtr,x
        shorta0
        lda     #^AttackAnimScript
        sta     $24
        sta     near wAnimThread::ScriptPtr_B,x
        lda     [$22]       ; animation speed
        lsr4
        inc
        sta     near wAnimThread::AnimRate,x
        stz     near wAnimThread::IsBackSprite,x     ; clear sprite layer priority
        lda     #$01
        sta     near wAnimThread::AnimFrameCounter,x     ; thread frame counter
        stz     near wAnimThread::ThreadIndex,x     ; thread index
        lda     $10
        bpl     @bfad       ; branch if attacker is a character
        and     #$0f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80f3,y
        eor     near w7e617e,y
        eor     #1
        bra     @bfb1
@bfad:  tay
        lda     near w7e7b10,y
@bfb1:  asl6
        and     #$40
        sta     near wAnimThread::w7e6f87,x     ; h flip
        phx
        lda     near w7e7af4       ; left-hand flag
        asl
        rol
        and     #1
        sta     near wAnimThread::w7e6f88,x     ;
        stz     near wAnimThread::LoopFrameOffset,x     ; frame offset
        stz     near wAnimThread::w7e74d8,x     ;
        lda     #$01
        sta     near wAnimThread::LoopFrameCounter,x     ; frame offset counter
        lda     #$60
        sta     near wAnimThread::w7e6a37,x     ; sprite tile offset
        lda     $10
        sta     near wAnimThread::AttackerIndex,x     ; attacker
        lda     $12
        sta     near wAnimThread::TargetIndex,x     ; target
        jsr     CalcAttackerPos
        longa
        lda     $14                     ; x position
        sta     near wAnimThread::AttackerPosX,x
        sta     near wAnimThread::ThreadPosX,x
        lda     $16                     ; y position
        sta     near wAnimThread::AttackerPosY,x
        sta     near wAnimThread::ThreadPosY,x
        stz     near wAnimThread::ThreadOffsetX,x     ; clear xy offset
        stz     near wAnimThread::ThreadOffsetY,x
        shorta0
        jsr     CalcTargetPos
        longa
        lda     $14         ; x position
        sta     near wAnimThread::TargetPosX,x
        lda     $16         ; y position
        sta     near wAnimThread::TargetPosY,x
        shorta0
        lda     #1
        sta     near wAnimThread::ThreadIsActive,x     ; thread is active
        lda     $10
        bmi     @c01f       ; branch if ???
        lda     #$30
        sta     near wAnimThread::LayerPriority,x     ; make animation sprite high priority
@c01f:  lda     $12
        bmi     @c05c       ; branch if target is a monster ???
        clc
        adc     #$0a
        tay
        lda     (z78),y     ; target character block type
        beq     @c05c       ; branch if not blocked

; target uses block animation
        dec
        jsr     InitBlockAnim
        pha
        lda     $10
        bpl     @c037       ; branch if attacker is a character
        stz     near wAnimThread::ThreadIsActive,x     ; deactivate animation thread
@c037:  pla
        phx
        tax
        lda     f:BlockAnimScriptTbl,x
        sta     near w7e626e       ; hit animation script
        stz     near wIsMonsterAttackAnim       ; clear monster attack flag
        plx
        lda     #$40        ; tile offset $40
        sta     $14
        lda     near w7e6270
        and     #$7f
        cmp     #$01
        bne     @c065                   ; branch if not a star or gambler type
        lda     near w7e6270
        and     #$80
        sta     near w7e6270            ; use default weapon anim init function
        bra     @c065

; no block animation
@c05c:  lda     #$60        ; tile offset $60
        sta     $14
        lda     near w7e6270       ; branch if weapon was not thrown
        bpl     @c07b

; use sprite thread for hit
@c065:  lda     $12                     ; target index
        and     #$7f
        asl
        tax
        longa
        lda     f:_c2ce8b,x             ; pointer to target's animation thread data (+$7e64de)
        clc
        adc     #$0010                  ; use 2nd sprite thread for hit
        tax
        shorta0
        bra     @c084

; use bg1 thread for hit
@c07b:  lda     #$60                    ; tile offset $60
        sta     $14
        ldx     #BG1_THREAD_OFFSET
        lda     #$01

@c084:  ora     #$30
        sta     near wAnimThread::LayerPriority,x     ; tile priority = 3, thread layer is bg1
        stx     near wAnimThreadPtr
        lda     $12         ; target
        bmi     @c09c       ; branch if a monster
        lda     #$02
        sta     near wAnimThread::TargetWidth,x     ; target width = 2 (character)
        lda     #$03
        sta     near wAnimThread::TargetHeight,x     ; target height = 3 (character)
        bra     @c0af
@c09c:  and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e812f,y     ; monster width
        sta     near wAnimThread::TargetWidth,x
        lda     near w7e812f+1,y     ; monster height
        sta     near wAnimThread::TargetHeight,x
@c0af:  lda     near w7e7b2f       ; hit graphics width
        sta     near wAnimThread::FrameWidth,x     ; thread frame width
        lda     near w7e7b2f+1       ; hit graphics height
        sta     near wAnimThread::FrameHeight,x     ; thread frame height
        lda     #$06
        sta     near wAnimThread::SpritePal,x     ; palette 3
        stz     $22
        stz     $23
        lda     near wIsMonsterAttackAnim       ; branch if not monster attack
        beq     @c0d7
        lda     near w7e626e       ; hit animation script
        cmp     #$60
        bcc     @c0d7       ; branch if less than $60
        phx
        ldx     #$0200      ; add $0200 to script number
        stx     $22
        plx
@c0d7:  lda     near w7e626e
        longa
        clc
        adc     $22
        asl
        phx
        tax
        lda     f:AttackAnimScriptPtrs,x
        plx
        sta     $22
        inc2
        sta     near wAnimThread::ScriptPtr,x     ; ++$22 = script pointer
        shorta0
        lda     #^AttackAnimScript
        sta     $24
        sta     near wAnimThread::ScriptPtr_B,x
        lda     [$22]
        lsr4
        inc
        sta     near wAnimThread::AnimRate,x     ; animation speed
        stz     near wAnimThread::IsBackSprite,x     ; low sprite priority
        lda     #$01
        sta     near wAnimThread::AnimFrameCounter,x     ; animation frame counter
        stz     near wAnimThread::ThreadIndex,x     ; thread index
        lda     $14         ; tile offset ($40 or $60)
        sta     near wAnimThread::w7e6a37,x
        stx     $14
        plx
        lda     near wAnimThread::w7e6f87,x     ; weapon thread h flip
        ldx     $14
        sta     near wAnimThread::w7e6f87,x     ; hit thread h flip
        stz     near wAnimThread::w7e6f88,x     ;
        stz     near wAnimThread::LoopFrameOffset,x     ; clear frame offset
        stz     near wAnimThread::w7e74d8,x     ; movement speed
        lda     #$01
        sta     near wAnimThread::LoopFrameCounter,x     ; frame offset counter
        lda     $10
        sta     near wAnimThread::AttackerIndex,x     ; attacker
        lda     $12
        sta     near wAnimThread::TargetIndex,x     ; target
        jsr     CalcAttackerPos
        longa
        lda     $14
        sta     near wAnimThread::AttackerPosX,x     ; x position
        lda     $16
        sta     near wAnimThread::AttackerPosY,x     ; y position
        stz     near wAnimThread::ThreadOffsetX,x     ; clear thread offset
        stz     near wAnimThread::ThreadOffsetY,x
        shorta0
        jsr     CalcTargetPos
        longa
        lda     $14
        sta     near wAnimThread::TargetPosX,x     ; x position
        sta     near wAnimThread::ThreadPosX,x
        lda     $16
        sta     near wAnimThread::TargetPosY,x     ; y position
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        lda     $12         ; target
        bmi     @c176       ; branch if a monster
        and     #$03
        clc
        adc     #$0a
        tay
        lda     (z78),y     ; block type
        sta     near w7e629b,y     ;
        bne     @c188
@c176:  ldy     #4
        lda     (z78),y     ; targets hit
        iny
        ora     (z78),y     ; targets reflected off of
        bne     @c188       ; branch if something was hit or reflected off of
        lda     #SFX::MISS
        sta     near w7ee9e7       ; nothing hit, set default animation sound effect (whiff)
        clr_a                 ; deactivate hit animation thread
        bra     @c18a
@c188:  lda     #1        ; activate hit animation thread
@c18a:  sta     near wAnimThread::ThreadIsActive,x
        lda     near w7e6196       ; branch if not flashing screen (critical)
        beq     @c1c6
        stz     $10         ; attacker
        stz     near w7e613f       ; character/monster number
        lda     #$01
        sta     $22
        lda     #^AttackAnimScript
        sta     $26
        longa
        lda     f:AttackAnimScriptPtrs+$01a8*2     ; ++$22 = pointer to animation script $01a8
        sta     $24
        shorta0
        lda     #$01        ; frame delay = 1
        sta     $1c
        ldx     near wAnimThreadPtr
        phx
        ldx     #BG3_THREAD_OFFSET
        phx
        jsr     CreateStandaloneThread
        plx
        lda     near wAnimThread::LayerPriority,x     ; set thread layer to bg3
        ora     #$02
        sta     near wAnimThread::LayerPriority,x
        plx
        stx     near wAnimThreadPtr
@c1c6:  jsr     UpdateDrawOrder
        stz     near wHideBG1MonsterSprites
        jsr     WaitFrame
        lda     near w7e6167       ; bg1 palette
        jsr     LoadBG1AnimPal
        jsr     ClearBG1Tiles
        lda     near w7e896f       ; 16x16 bg1 tiles
        ora     #$10
        sta     near w7e896f
        jsr     InitWeaponType
        jsr     ResetSpritePriority
        jsr     GetTargetNum
        jsr     UpdateSpritePriority
        jsr     ExecAnimScript
        ldy     #4
        lda     (z78),y     ; targets hit
        bne     @c201       ; branch if targets were hit
        iny2
        lda     (z78),y     ; targets reflected off of
        beq     @c201       ; branch if no targets were reflected off of
        lda     #$20
@c1fe:  jsr     WaitA       ; wait 32 frames
@c201:  jsr     PopObjPos
        jsr     ClearBG1Tiles
        jsr     ResetSpritePriority
        lda     near w7e896f         ; 8x8 bg1 and bg3 tiles
        and     #$af
        sta     near w7e896f
        clr_ax
        stx     near w7e64b4
        stx     near w7e64b6
        lda     #1
        sta     near w7e7b0e       ; 1 monster thread
        sta     near w7e7b0f       ; 1 character thread
        lda     near wIsMonsterAttackAnim       ; branch if not monster attack
        beq     @c232
        jsr     _c1b86b
        bra     @c232
; *** inaccessible code ***
@c22c:  jsr     PopObjPos
        jsr     PopMonsterPalID
; *************************
@c232:  jsr     _c1ab8b       ; reset attacker graphical action
        stz     near w7e6196       ; clear flash screen flag (critical)
        stz     near wIsMonsterAttackAnim       ; clear monster attack flag
        rts

; ------------------------------------------------------------------------------

; [ set color add/sub data ]

; +$10: shbo4321 mmss--cd (+$2130)
;         s: 0 = add, 1 = subtract
;         h: 0 = full add/sub, 1 = half add/sub
;         bo4321: layers affected by add/sub
;         m: 0
;         s: 0
;         c: 0 = fixed color add/sub, 1 = subscreen add/sub
;         d: 0
;    A: ---o4321 subscreen designation ($212d)
;         o4321: layers to add/sub

SetColorMathHDMA:
@c23c:  pha
        longa
        clr_ax
        lda     $10
@c243:  sta     near w7e8993+1,x     ; set hdma data
        sta     near w7e8993+101,x
        sta     near w7e8993+201,x
        sta     near w7e8993+301,x
        sta     near w7e8993+401,x
        sta     near w7e8993+501,x
        inx4
        cpx     #100
        bne     @c243
        sta     near w7e8993+601
        shorta0
        pla
        sta     near w7e898e       ; set subscreen designation
        rts

; ------------------------------------------------------------------------------

; [ weapon animation init ]

InitWeaponType:
@c269:  lda     near w7e6270
        and     #$7f
        asl
        tax
        jmp     (near WeaponTypeTbl,x)

; jump table for weapon animation init
WeaponTypeTbl:
        ptr_tbl WEAPON_ANIM_TYPE

; ------------------------------------------------------------------------------

; 2: full moon, boomerang, rising sun, wing edge, some monster special attacks
        array_label WEAPON_ANIM_TYPE, WEAPON_ANIM_TYPE::BOOMERANG
@c27d:  lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; 0: normal
        array_label WEAPON_ANIM_TYPE, WEAPON_ANIM_TYPE::NORMAL
@c286:  ldx     #$0102      ; add bg1
        stx     $10
        lda     #$12        ; affect sprite and bg2
        jsr     SetColorMathHDMA
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; 1: all star-type weapons, all gambler-type weapons (shadow sprites)
        array_label WEAPON_ANIM_TYPE, WEAPON_ANIM_TYPE::THROWN
@c299:  ldx     near wAnimThreadPtr
        ldy     #wAnimThread::BLOCK_SIZE
        lda     near wAnimThread::AttackerIndex,x
        bmi     @c2d1
        lda     near wAnimThread::TargetIndex,x
        bmi     @c2d1
        lda     near w7e201f
        cmp     #BATTLE_TYPE::SIDE
        bne     @c2c9
@c2b0:  lda     near wAnimThread::AttackerIndex,x
@c2b3:  cmp     #$02
        bcc     @c2c0
        lda     near wAnimThread::TargetIndex,x
@c2ba:  cmp     #$02
@c2bc:  bcc     @c2d1
        bra     @c2c9
@c2c0:  lda     near wAnimThread::TargetIndex,x
        cmp     #$02
        bcc     @c2c9
        bra     @c2d1
@c2c9:  lda     near wAnimThread::w7e6f87,x
        eor     #$40
        sta     near wAnimThread::w7e6f87,x
@c2d1:  lda     near wAnimThread::_0::BLOCK_0,x
        sta     near wAnimThread::_1::BLOCK_0,x
        sta     near wAnimThread::_2::BLOCK_0,x
        lda     near wAnimThread::_0::BLOCK_1,x
        sta     near wAnimThread::_1::BLOCK_1,x
        sta     near wAnimThread::_2::BLOCK_1,x
        lda     near wAnimThread::_0::BLOCK_2,x
        sta     near wAnimThread::_1::BLOCK_2,x
        sta     near wAnimThread::_2::BLOCK_2,x
        lda     near wAnimThread::_0::BLOCK_3,x
        sta     near wAnimThread::_1::BLOCK_3,x
        sta     near wAnimThread::_2::BLOCK_3,x
        inx
        dey
        bne     @c2d1
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AnimFrameCounter,x
        inc2
        sta     near wAnimThread::_1::AnimFrameCounter,x
        inc2
        sta     near wAnimThread::_2::AnimFrameCounter,x
        lda     #5
        sta     near w7e7b0e       ; 5 monster threads
        sta     near w7e7b0f       ; 5 character threads
        rts

; ------------------------------------------------------------------------------

; 3: atma weapon 3 (shadow sprites)
        array_label WEAPON_ANIM_TYPE, WEAPON_ANIM_TYPE::LONG_ATMA_WEAPON
@c312:  jsr     GetAttackerNum
        lda     $10
        and     #$7f
        asl
        tax
        longa
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tax
        phx
        ldy     #wAnimThread::BLOCK_SIZE / 2
@c326:  lda     near wAnimThread::_0::BLOCK_0,x     ; copy thread data
        sta     near wAnimThread::_1::BLOCK_0,x
        sta     near wAnimThread::_2::BLOCK_0,x
        lda     near wAnimThread::_0::BLOCK_1,x
        sta     near wAnimThread::_1::BLOCK_1,x
        sta     near wAnimThread::_2::BLOCK_1,x
        lda     near wAnimThread::_0::BLOCK_2,x
        sta     near wAnimThread::_1::BLOCK_2,x
        sta     near wAnimThread::_2::BLOCK_2,x
        lda     near wAnimThread::_0::BLOCK_3,x
        sta     near wAnimThread::_1::BLOCK_3,x
        sta     near wAnimThread::_2::BLOCK_3,x
        inx2
        dey
        bne     @c326
        shorta0
        plx
        lda     near wAnimThread::AnimFrameCounter,x     ; frame counter
        inc2
        sta     near wAnimThread::_1::AnimFrameCounter,x
        inc2
        sta     near wAnimThread::_2::AnimFrameCounter,x
        ldx     #$0202      ; add bg2
        stx     $10
        lda     #$10        ; affect bg1
        jsr     SetColorMathHDMA
        lda     #5
        sta     near w7e7b0e       ; 5 monster threads
        sta     near w7e7b0f       ; 5 character threads
        rts

; ------------------------------------------------------------------------------

; 4: atma weapon 1 & 2
        array_label WEAPON_ANIM_TYPE, WEAPON_ANIM_TYPE::SHORT_ATMA_WEAPON
@c373:  ldx     #$0202      ; add bg2
        stx     $10
        lda     #$10        ; affect bg1
        jsr     SetColorMathHDMA
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ make all character/monster sprites priority 3 (long access) ]

ResetSpritePriority_far:
@c386:  jsr     ResetSpritePriority
        rtl

; ------------------------------------------------------------------------------

; [ make all character/monster sprites priority 3 ]

ResetSpritePriority:
@c38a:  lda     #$30
        sta     near wCharGfxData::_0::LayerPriority       ; character sprite layer priority
        sta     near wCharGfxData::_1::LayerPriority
        sta     near wCharGfxData::_2::LayerPriority
        sta     near wCharGfxData::_3::LayerPriority
        clr_ax
        lda     #$31
@c39c:  sta     near w7e80db+1,x     ; monster sprite layer priority
        inx2
        cpx     #12
        bne     @c39c
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1c3a7:
y_pri_set_long:
@c3a7:  jsr     _c1c3ab
        rtl

; ------------------------------------------------------------------------------

; [  ]

_c1c3ab:
y_pri_set:
@c3ab:  stx     $10
        clr_axy
        longa
@c3b2:  lda     near w7e8043,x
        cmp     $10
        bcs     @c3c3
        shorta
        lda     #$20
        sta     near wCharGfxData::LayerPriority,y
        clr_a
        longa
@c3c3:  tya
        clc
        adc     #$0020
        tay
        inx2
        cpx     #$0008
        bne     @c3b2
        clr_ax
@c3d2:  lda     near w7e8027,x
        cmp     $10
        bcs     @c3e2
        shorta
        lda     #$21
        sta     near w7e80db+1,x
        longa
@c3e2:  inx2
        cpx     #$000c
        bne     @c3d2
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1c3ed:
attack_pri_set_main_long:
@c3ed:  jsr     _c1c3fa
        rtl

; ------------------------------------------------------------------------------

; [ update character/monster layer priority (far) ]

UpdateSpritePriority_far:
@c3f1:  jsr     UpdateSpritePriority
        rtl

; ------------------------------------------------------------------------------

; [ update character/monster layer priority ]

; set all targets in the draw order after the specified character/monster
; as low priority (drawn behind high priority backgroud layers)

; $12: first target behind bg

UpdateSpritePriority:
@c3f5:  jsr     _c1aaa5
        lda     $12

; A: character/monster in draw order between high and low priority
_c1c3fa:
attack_pri_set_main:
@c3fa:  and     #$7f
        ldx     #0
@c3ff:  cmp     near wTargetDrawOrderBuf::TargetIndex,x
        beq     @c40e
        inx4
        cpx     #$0028
        bne     @c3ff
        rts
@c40e:  lda     near wTargetDrawOrderBuf::TargetIndex,x
        cmp     #4
        bcc     @c423       ; branch if a character
        sec
        sbc     #4
        and     #$07
        asl
        tay
        lda     #$21
        sta     near w7e80db+1,y     ; layer priority = 2
        bra     @c42e
@c423:  asl5
        tay
        lda     #$20
        sta     near wCharGfxData::LayerPriority,y     ; layer priority = 2
@c42e:  inx4
        cpx     #$0028
        bne     @c40e
        rts

; ------------------------------------------------------------------------------

; $c0: align with front of monster (far, 32 pixels away)
_c438:  ply
        lda     near w7e812f,y               ; monster width / 2 + 32
        asl2
        sta     $14
        stz     $15
        longa
        lda     $14
        clc
        adc     #32
        sta     $14
        shorta0
        phx
        lda     $10
        and     #$03
        tax
        lda     near w7e7b10,x               ; facing direction
        and     #$01
        bne     @c46e
        longa
        lda     near w7e800f,y               ; center X
        clc
        adc     $14
        sta     $14
        lda     near w7e8027,y               ; bottom Y
        sta     $16
        clr_a
        plx
        rts
@c46e:  longa
        lda     near w7e800f,y
        sec
        sbc     $14
        sta     $14
        lda     near w7e8027,y
        sta     $16
        clr_a
        plx
        rts

; ------------------------------------------------------------------------------

; [ get magitek y-offset ]

GetMagitekOffset:
        .a16
@c480:  lda     near wMagitekModeEnabled     ; branch if magitek mode is disabled
        beq     @c48a
        ldy     #near -12
        bra     @c48b
@c48a:  tay
@c48b:  sty     $18                     ; 0 or -12
        rts
        .a8

; ------------------------------------------------------------------------------

; [ calculate target position ]

;  $12: target
; +$14: x position (out)
; +$16: y position (out)

CalcTargetPos:
@c48e:  jsr     GetMagitekOffset
        lda     #$01
        sta     $14
        lda     $12         ; target
        bra     _c4a0

; ------------------------------------------------------------------------------

; [ calculate attacker position ]

;  $10: attacker
; +$14: x position (out)
; +$16: y position (out)

; animation alignment
;   $00: align with bottom of attacker/target
;   $20: align with center of attacker/target
;   $40: align with top of attacker/target
;   $60: align with center of attacker/target (unused)
;   $80: align with front of attacker/target (near, 16/24 pixels away)
;   $a0: align with center of screen
;   $c0: align with front of attacker/target (far, 32/24 pixels away)
;   $e0:

CalcAttackerPos:
@c499:  jsr     GetMagitekOffset
        stz     $14
        lda     $10         ; attacker

get_pointer_main:
_c4a0:  sta     near w7eecb1       ; characer/monster number
        jmi     @c58f       ; branch if a monster

; character
        asl
        tay
        phy
        ldy     #1
        lda     [$22],y     ; 2nd byte of animation script header
        and     #$e0
        beq     @c51b
        cmp     #$20
        beq     @c519
        cmp     #$40
        beq     @c4e6
        cmp     #$e0
        beq     @c4e1
        cmp     #$80
        beq     @c540
        cmp     #$c0
        beq     @c540
        cmp     #$a0
        bne     @c4e4

; $a0: align with center of screen
        lda     $14
        beq     @c4ee       ; branch if attacker
        longa
        lda     near w7e7b22       ; x position = bg3 animation x position
        sta     $14
        lda     near w7e7b24       ; y position = bg3 animation y position
        sta     $16
        shorta0
        ply
        rts

@c4e1:  jmp     @c573       ; $e0
@c4e4:  bra     @c4ee       ; $60

; $40: align with top of character
@c4e6:  lda     #$10        ; +$16 = 16
        sta     $16
        stz     $17
        bra     @c525

; $60: align with bottom of character
@c4ee:  stz     near w7eecb1
        stz     near w7eecb2
@c4f4:  ply
        longa
        lda     near w7e8033,y     ; character center x
        clc
        adc     near w7eecb1       ; add 0, -24, or +24
        bpl     @c503
        clr_a                   ; clamp between 0 and 252
        bra     @c50b
@c503:  cmp     #252
        bcc     @c50b
        lda     #252
@c50b:  sta     $14
        lda     near w7e8043,y
        clc
        adc     $18
        sta     $16
        shorta0
        rts

@c519:  bra     @c55f       ; $20

; $00: align to bottom of character
@c51b:  lda     near wAnimThread::FrameHeight,x     ; +$16 = frame height (in pixels)
        asl3
        sta     $16
        stz     $17
@c525:  ply
        longa
        lda     near w7e8033,y     ; x position = character center x coordinate
        sta     $14
        lda     near w7e8043,y     ; y position = character bottom y coordinate + 8 - frame height + magitek offset
        clc
        adc     #8
        sec
        sbc     $16
        clc
        adc     $18
        sta     $16
        shorta0
        rts

; $80, $c0: align to front of character
@c540:  phx
        lda     $10         ; attacker
        and     #$03
        tax
        lda     near w7e7b10,x     ; facing direction
        and     #$01
        beq     @c552       ; branch if not flipped
        ldx     #near -24
        bra     @c555
@c552:  ldx     #24
@c555:  stx     near w7eecb1
        plx
        lda     $14
        beq     @c4ee
        bra     @c4f4

; $20: align to center of character
@c55f:  ply
        longa
        lda     near w7e8033,y     ; x position = character center x coordinate
        sta     $14
        lda     near w7e803b,y     ; y position = character center y coordinate + magitek offset
        clc
        adc     $18
        sta     $16
        shorta0
        rts

; $e0: capture (also used for a lot of event animations)
@c573:  ply
        longa
        lda     near w7e8033,y     ; x position = character center x coordinate - 8
        sec
        sbc     #8
        sta     $14
        lda     near w7e803b,y     ; y position = character center y coordinate + magitek offset - 8
        clc
        adc     $18
        sec
        sbc     #8
        sta     $16
        shorta0
        rts

; monster
@c58f:  and     #$7f
        sec
        sbc     #$04
        asl
        tay
        phy
        ldy     #1
        lda     [$22],y     ; 2nd byte of animation script header
        and     #$e0
        beq     @c5cb
        cmp     #$20
        beq     @c5c8
        cmp     #$40
        beq     @c5c5
        cmp     #$80
        beq     @c5d1
        cmp     #$c0
        beq     @c5ce
        cmp     #$a0
        bne     @c5c8

; $a0: align with center of screen
        longa
        lda     near w7e7b22
        sta     $14
        lda     near w7e7b24
        sta     $16
        shorta0
        ply
        rts

@c5c5:  jmp     @c60f       ; $40
@c5c8:  jmp     @c642       ; $20, $60, $e0
@c5cb:  jmp     @c620       ; $00
@c5ce:  jmp     _c438       ; $c0

; $80: align with front of monster (close, 16 pixels away)
@c5d1:  ply
        lda     near w7e812f,y       ; monster size
        asl2
        clc
        adc     #16
        sta     $14
        stz     $15
        phx
        lda     $10
        and     #$03
        tax
        lda     near w7e7b10,x
        and     #$01
        bne     @c5fd
        longa
        lda     near w7e800f,y
        clc
        adc     $14
        sta     $14
        lda     near w7e8027,y
        sta     $16
        clr_a
        plx
        rts
@c5fd:  longa
        lda     near w7e800f,y
        sec
        sbc     $14
        sta     $14
        lda     near w7e8027,y
        sta     $16
        clr_a
        plx
        rts

; $40: align with top of monster
@c60f:  ply
        longa
        lda     near w7e800f,y
        sta     $14
        lda     near w7e80cf,y
        sta     $16
        shorta0
        rts

; $00: align with bottom of monster
@c620:  lda     near wAnimThread::FrameHeight,x
        asl3
        sta     $16
        stz     $17
        ply
        longa
        lda     near w7e800f,y               ; center X
        sta     $14
        lda     near w7e8027,y               ; bottom Y + 8 - frame height / 2
        clc
        adc     #8
        sec
        sbc     $16
        sta     $16
        shorta0
        rts

; $20, $60, $e0: align with center of monster
@c642:  ply
        longa
        lda     near w7e800f,y     ; x position = monster center x position
        sta     $14
        lda     near w7e801b,y     ; y position = monster center y position
        sta     $16
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ execute attack animation script ]

ExecAnimScript:
@c653:  clr_ax
@c655:  stz     near w7e6095,x     ; clear bg scrolling frequency/amplitude/phase
        inx
        cpx     #$0012
        bne     @c655
        jsr     UpdateDrawOrder
        stz     near w7eebfa       ;
        stz     near w7e60a7       ; enable bg1 animation graphics
        stz     near w7e60a8       ; enable bg3 animation graphics
        clr_ax
@c66c:  stz     near w7e6095,x     ; clear bg scrolling frequency/amplitude/phase (again)
        inx
        cpx     #$0012
        bne     @c66c
        clr_axy
@c678:  lda     near wCharGfxData::Pal,x     ; save character palette numbers
        sta     near w7e616e,y
        txa
        clc
        adc     #$20
        tax
        iny
        cpy     #$0004
        bne     @c678
        clr_ax
@c68b:  lda     near w7e80db,x     ; save monster palette numbers
        sta     near w7e616e,y
        inx2
        iny
        cpy     #$000a
        bne     @c68b
        clr_ax
@c69b:  stz     near w7e6085,x     ; clear palette shift counters
        inx
        cpx     #$0010
        bne     @c69b

; start of frame loop for animation execution
@c6a4:  clr_ax
        stz     near w7e7b14       ; clear the number of active threads
@c6a9:  stz     z9b         ;
        lda     near wAnimThread::ThreadIsActive,x     ; branch if thread is not active (next thread)
        beq     @c708
        lda     z99         ; branch if sprite animation threads are not paused
        beq     @c6b9
        cpx     #BG1_THREAD_OFFSET
        bcc     @c708       ; branch if not a bg or esper (next thread)
@c6b9:  inc     near w7e7b14       ; increment number of active threads
        dec     near wAnimThread::AnimFrameCounter,x     ; decrement animation frame counter
        bne     @c708       ; branch if it didn't reach 0 (next thread)
        lda     near wAnimThread::AnimRate,x     ; animation speed
        sta     near wAnimThread::AnimFrameCounter,x     ; reset frame counter
        ldy     near wAnimThread::ScriptPtr,x     ; set script pointer
        sty     zAnimScriptPtr
        lda     near wAnimThread::ScriptPtr_B,x
        sta     zAnimScriptPtr_B
@c6d1:  lda     near wAnimThread::LayerPriority,x
        and     #$03
        beq     @c6f6       ; branch if a sprite thread
        and     #$01
        bne     @c6e9       ; branch if a bg1 thread

; bg3 thread
        stz     near wAnimThread::SpriteIsActive,x     ; deactivate sprite
        lda     near w7e60ad       ; branch if bg3 animation is paused
        bne     @c760
        jsr     UpdateBG3Thread
        bra     @c758

; bg1 thread
@c6e9:  stz     near wAnimThread::SpriteIsActive,x     ; deactivate sprite
        lda     near w7e60ac       ; branch if bg1 animation is paused
        bne     @c760
        jsr     UpdateBG1Thread
        bcc     @c758       ; branch if not acting as a sprite thread

; sprite thread
@c6f6:  lda     z9b         ;
        bne     @c714
        lda     [zAnimScriptPtr]       ; animation command
        bpl     @c714       ; branch if a frame
        cmp     #$ff
        bne     @c70a       ; branch if not end of script
        stz     near wAnimThread::ThreadIsActive,x     ; deactivate attacker thread
        stz     near wAnimThread::SpriteIsActive,x     ; deactivate sprite
@c708:  bra     @c760

; animation command (sprite thread)
@c70a:  jsr     ExecAnimCmd
        ldy     zAnimScriptPtr         ; increment animation script pointer
        iny
        sty     zAnimScriptPtr
        bra     @c6d1

; show frame (sprite thread)
@c714:  stz     z9b         ;
        cmp     #$1f
        beq     @c720       ; branch if blank sprite frame ($1f)
        clc
        adc     near wAnimThread::LoopFrameOffset,x
        and     #$7f
@c720:  sta     near wAnimThread::SpriteFrame,x
        lda     near wAnimThread::w7e6a37,x     ; tile offset
        sta     near wAnimThread::SpriteTileOffset,x
        longa
        lda     near wAnimThread::ThreadPosX,x
        clc
        adc     near wAnimThread::ThreadOffsetX,x
        sta     near wAnimThread::SpritePosX,x
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     near wAnimThread::ThreadOffsetY,x
        sta     near wAnimThread::SpritePosY,x
        shorta0
        lda     near wAnimThread::w7e6f87,x     ; horizontal flip
        sta     near wAnimThread::SpriteFlags,x
        lda     near wAnimThread::LayerPriority,x     ; sprite priority
        and     #$30
        ora     near wAnimThread::SpritePal,x     ; palette
        sta     near wAnimThread::SpriteFlags+1,x
        lda     #1
        sta     near wAnimThread::SpriteIsActive,x     ; make sprite active
@c758:  longa
        lda     zAnimScriptPtr         ; increment animation script pointer
        inc
        sta     near wAnimThread::ScriptPtr,x
@c760:  longa        ; next thread
        txa
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$0550      ; 85 threads total
        jne     @c6a9
        jsr     WaitFrame
        lda     near wStaticDrawOrder       ; branch if sprite draw order is static
        bne     @c77e
        jsr     UpdateDrawOrder
@c77e:  lda     near w7e7b14       ; continue if there are no more active threads
        jne     @c6a4

; animation is done
        clr_ax
        stx     $10
        jsr     SetColorMathHDMA
        stz     near wStaticDrawOrder       ; update draw order every frame
        stz     near w7e62af       ; clear bg1 monsters
        jsr     UpdateDrawOrder
        clr_ax
@c798:  sta     near w7e7b15,x     ; disable bg1/bg3 animation update
        sta     near w7e7b21,x
        inx
        cpx     #$000c
        bne     @c798
        ldx     #$0100
        stx     near wBG1ScrollData::Horz       ; set bg1 horizontal scroll position to $0100 (hdma data)
        stx     near w7e64b4       ; set bg1 horizontal scroll position to $0100
        stx     near wBG3ScrollData::Horz       ; set bg3 horizontal scroll position to $0100 (hdma data)
        clr_ax
        stx     near w7e64b6       ; set bg1 vertical scroll position to $0100
        stx     near wBG3ScrollData::Vert       ; set bg3 vertical scroll position to $0100 (hdma data)
        rts

; ------------------------------------------------------------------------------

; [ update bg1 animation thread ]

; carry set = acting as a sprite thread, clear = acting as a bg thread

UpdateBG1Thread:
bg_main_magic_anim:
@c7b9:  lda     near wAnimThread::LayerPriority,x     ; thread type
        and     #$03
        bne     @c7c2       ; branch if not a sprite
        sec
        rts
@c7c2:  lda     [zAnimScriptPtr]       ; script byte
        cmp     #$1f
        beq     @c7da       ; branch if blank frame
        cmp     #$ff
        bne     @c7de       ; branch if not end of script
        stz     near wAnimThread::ThreadIsActive,x     ; deactivate thread
        ldy     #$0100
        sty     near wBG1ScrollData::Horz       ; set bg1 horizontal scroll position to $0100 (hdma data)
        sty     near w7e64b4       ; set bg1 horizontal scroll position to $0100
        clc
        rts
@c7da:  lda     #$0f        ; use frame $0f for blank frame
        bra     @c7e6
@c7de:  bmi     @c817       ; branch if script command
        clc
        adc     near wAnimThread::LoopFrameOffset,x     ; add frame offset
        and     #$7f
@c7e6:  longa
        xba
        asl
        clc
        adc     #$c400
        sta     near w7e7b1a       ; pointer to bg1 animation graphics buffer
        lda     near wAnimThread::ThreadPosX,x     ; x position
        clc
        adc     near wAnimThread::ThreadOffsetX,x     ; x offset
        sta     near w7e7b1d       ; bg1 animation graphics x offset
        lda     near wAnimThread::ThreadPosY,x     ; y position
        clc
        adc     near wAnimThread::ThreadOffsetY,x     ; y offset
        sta     near w7e7b1f       ; bg1 animation graphics y offset
        shorta0
        lda     #$7f
        sta     near w7e7b1a_B       ; bank byte of graphics pointer
        stz     near wAnimThread::SpriteIsActive,x     ; deactivate sprite
        lda     #1
        sta     near w7e7b15       ; enable bg1 animation tile data update
        clc
        rts
@c817:  jsr     ExecAnimCmd
        ldy     zAnimScriptPtr         ; increment script pointer
        iny
        sty     zAnimScriptPtr
        bra     @c7b9       ; next command/frame
        clc
        rts

; ------------------------------------------------------------------------------

; [ update bg3 animation thread ]

UpdateBG3Thread:
bg_main_magic_anim3:
@c823:  lda     [zAnimScriptPtr]       ; script byte
        cmp     #$ff
        bne     @c833       ; branch if not end of script
        stz     near wAnimThread::ThreadIsActive,x     ; deactivate thread
        ldy     #$0100
        sty     near wBG3ScrollData::Horz       ; set bg3 horizontal scroll position to $0100 (hdma data)
        rts
@c833:  bmi     @c868       ; branch if script command
        clc
        adc     near wAnimThread::LoopFrameOffset,x     ; add frame offset
        and     #$7f
        longa
        xba
        asl
        clc
        adc     #$e400      ; pointer to bg3 tile data buffer
        sta     near w7e7b26
        lda     near wAnimThread::ThreadPosX,x     ; x position
        clc
        adc     near wAnimThread::ThreadOffsetX,x     ; x offset
        sta     near w7e7b29       ; bg3 horizontal scroll position
        lda     near wAnimThread::ThreadPosY,x     ; y position
        clc
        adc     near wAnimThread::ThreadOffsetY,x     ; y offset
        sta     near w7e7b2b       ; bg3 vertical scroll position
        shorta0
        lda     #$7f
        sta     near w7e7b26_B       ; tile data pointer bank
        lda     #1
        sta     near w7e7b21       ; enable b3 animation tile data update
        rts
@c868:  jsr     ExecAnimCmd
        ldy     zAnimScriptPtr         ; increment script pointer
        iny
        sty     zAnimScriptPtr
        bra     @c823       ; next command/frame
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c7: animation commands for battle events ]

        array_label ANIM_CMD, $47
@c873:  jsl     ExecEventAnimCmd
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80 ]

        array_label ANIM_CMD, $00
magic_code00:
@c878:  lda     [zAnimScriptPtr]       ; next byte
        longa
        asl
        tax
        shorta0
        ldy     #1
        jsr     (near AnimCmd_00_Tbl,x)
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; battle animation command $80 jump table
AnimCmd_00_Tbl:
        ptr_tbl ANIM_CMD_00

; ------------------------------------------------------------------------------

; [ battle animation command $80/$8b: play ??? sound effect ]

; for an unused block animation ???

        array_label ANIM_CMD_00, $8b
magic_init_139:
@c9a5:  inc     near w7e6281
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$8a: set target monster sprite priority to 0 ]

; isn't this the same as command $ee with a parameter of zero? except this
; only affects monsters I guess

        array_label ANIM_CMD_00, $8a
magic_init_138:
@c9a9:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bpl     @c9c0       ; return if a character
        and     #$7f
        sec
        sbc     #$04        ; monster number
        asl
        tay
        lda     near w7e80db+1,y     ; set sprite priority to 0
        and     #$cf
        sta     near w7e80db+1,y
@c9c0:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$89:  ]

        array_label ANIM_CMD_00, $89
magic_init_137:
@c9c1:  lda     [zAnimScriptPtr],y
        sta     near w7e6285
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$88: move thread for block graphics ]

        array_label ANIM_CMD_00, $88
magic_init_136:
@c9c9:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        asl5
        tay
        longa
        lda     near wCharGfxData::PosX,y
        clc
        adc     near wCharGfxData::OffsetX,y
        clc
        adc     near wCharGfxData::AnimOffsetX,y
        clc
        adc     #8
        sta     near wAnimThread::ThreadPosX,x
        lda     near wCharGfxData::PosY,y
        clc
        adc     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$87: play sound effect (pan to attacker vertical position) ]

        array_label ANIM_CMD_00, $87
magic_init_135:
@c9f7:  lda     near w7eecbb
        beq     @ca06
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosY,x
        sta     $10
        bra     _ca17
@ca06:  jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$8c: play sound effect (pan center) ]

        array_label ANIM_CMD_00, $8c
magic_init_140:
@ca09:  lda     #$80
        sta     $10
        bra     _ca17

; ------------------------------------------------------------------------------

; [ battle animation command $80/$86: play sound effect (pan to attacker horizontal position) ]

        array_label ANIM_CMD_00, $86
magic_init_134:
@ca0f:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x
        sta     $10
_ca17:  lda     [zAnimScriptPtr],y
        bne     @ca1e
        lda     near w7ee9e7
@ca1e:  jsr     PlayAnimSfx
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$85:  ]

        array_label ANIM_CMD_00, $85
        jsl     AnimCmd_00_85_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$84: restore chadarnook position during exit ]

        array_label ANIM_CMD_00, $84
magic_init_132:
@ca29:  longa
        ldx     near w7eecb6
        lda     near w7eecb4
        sta     near w7e80cf,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$83:  ]

        array_label ANIM_CMD_00, $83
        jsl     AnimCmd_00_83_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$82: set x-offset for all monsters ]

; used to vibrate monsters for boss death

        array_label ANIM_CMD_00, $82
magic_init_130:
@ca3d:  stz     $11
        lda     [zAnimScriptPtr],y
        sta     $10
        bpl     @ca47
        dec     $11
@ca47:  longa
        clr_ax
@ca4b:  lda     near w7e80c3,x
        clc
        adc     $10
        sta     near w7e80c3,x
        inx2
        cpx     #$000c
        bne     @ca4b
        inc     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$81:  ]

; unused

        array_label ANIM_CMD_00, $81
magic_init_129:
@ca61:  stz     near w7e88bf::_4
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$80: subtract from monster color palettes ]

; used for boss death

; b1: rgbscccc
;       r: affect red components
;       g: affect green components
;       b: affect blue components
;       s: subtract if 1, add if 0
;       c: amount to subtract from each color (intensity)
; b2: number of colors (should be 16 to affect the whole palette)
; b3: sprite palette offset (+$7e7f00), should be zero to affect all monsters

        array_label ANIM_CMD_00, $80
magic_init_128:
@ca65:  ldx     zAnimScriptPtr
        inx
        stx     zAnimScriptPtr
        ldx     #near w7e88bf::_4
        jsr     _c1eabb
        clr_a   ; <array_offset w7e7e00, 8
        jsr     _c1ca85
        lda     #<array_offset w7e7e00, 9
        jsr     _c1ca85
        lda     #<array_offset w7e7e00, 10
        jsr     _c1ca85
        ldx     zAnimScriptPtr
        inx2
        stx     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ decrement monster palette for boss death ]

_c1ca85:
init_one_col_down:
@ca85:  sta     $10
        ldy     #1
        lda     [zAnimScriptPtr],y                 ; color components and intensity
        sta     $12
        iny
        lda     [zAnimScriptPtr],y                 ; sprite palette offset
        clc
        adc     $10
        sta     $10
        lda     #>array_offset w7e7e00, 8
        sta     $11
        jmp     DecPal

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7f: hide all monsters ]

; used by boss death animation

        array_label ANIM_CMD_00, $7f
magic_init_127:
@ca9d:  stz     near w7e61ab       ; hide all monsters
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7e: flip target character vertically ]

; used by suplex

        array_label ANIM_CMD_00, $7e
magic_init_126:
@caa1:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @cab7       ; return if a monster
        asl5
        tax
        lda     near wCharGfxData::Flip,x     ; flip character vertically
        eor     #$80
        sta     near wCharGfxData::Flip,x
@cab7:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$74:  ]

        array_label ANIM_CMD_00, $74
        jsl     AnimCmd_00_74_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7d: branch if dragon horn is active ]

        array_label ANIM_CMD_00, $7d
        jsl     AnimCmd_00_7d_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$79: characters run to left side of screen ]

        array_label ANIM_CMD_00, $79
        jsl     AnimCmd_00_79_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7a: characters run to right side of screen ]

        array_label ANIM_CMD_00, $7a
        jsl     AnimCmd_00_7a_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7b: flip all characters ]

        array_label ANIM_CMD_00, $7b
        jsl     AnimCmd_00_7b_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7c: swap target and attacker ]

        array_label ANIM_CMD_00, $7c
        jsl     AnimCmd_00_7c_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$76:  ]

        array_label ANIM_CMD_00, $76
        jsl     AnimCmd_00_76_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$77:  ]

        array_label ANIM_CMD_00, $77
        jsl     AnimCmd_00_77_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$78:  ]

        array_label ANIM_CMD_00, $78
        jsl     AnimCmd_00_78_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$75: update super ball graphic ]

        array_label ANIM_CMD_00, $75
magic_init_117:
@cae5:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e64e8,x  ; super ball bounce counter
        ora     #$80
        cmp     #$90
        bcc     @caf8
        cmp     #$a0
        bcc     @cafc
        clr_a                           ; frame 0 if [0..15] (normal ball)
        bra     @cafe
@caf8:  lda     #$01                    ; frame 1 if [16..31] (flat ball)
        bra     @cafe
@cafc:  lda     #$02                    ; frame 2 if [32..] (stretched ball)
@cafe:  sta     near wAnimThread::LoopFrameOffset,x
        jsr     _c1cc04                 ; calc bounce offset
        longa
        lda     near wAnimThread::ThreadOffsetY,x
        clc
        adc     $22
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        jmp     _c1cc27                 ; increment bounce angle

; ------------------------------------------------------------------------------

_c1cb15:
@cb15:  .byte   $02,$03,$04,$05,$06,$07,$1f,$1f

; ------------------------------------------------------------------------------

; [ battle animation command $80/$73:  ]

        array_label ANIM_CMD_00, $73
magic_init_115:
@cb1d:  lda     near w7eebfb
        lda     [zAnimScriptPtr],y
        tax
        lda     near w7eebfb,x
        tax
        lda     f:_c1cb15,x
        ldx     near wAnimThreadPtr
        sta     near wAnimThread::LoopFrameOffset,x
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$71: restore character palettes ]

; used by purifier and hope song

        array_label ANIM_CMD_00, $71
magic_init_113:
@cb34:  clr_ax
@cb36:  lda     near w7e7c00::_13,x
        sta     near w7e7e00::_13,x
        inx
        cpx     #32*3
        bne     @cb36
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$70:  ]

        array_label ANIM_CMD_00, $70
        jsl     AnimCmd_00_70_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$72:  ]

        array_label ANIM_CMD_00, $72
        jsl     AnimCmd_00_72_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6f: enable HDMA #5 update (window position) ]

        array_label ANIM_CMD_00, $6f
magic_init_110:
@cb4d:  inc     near w7e7b96
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6e:  ]

        array_label ANIM_CMD_00, $6e
        jsl     AnimCmd_00_6e_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6d:  ]

        array_label ANIM_CMD_00, $6d
magic_init_109:
@cb56:  inc     near w7e628b
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6c:  ]

        array_label ANIM_CMD_00, $6c
magic_init_108:
@cb5a:  jmp     ClearBGAnimFrames

; ------------------------------------------------------------------------------

; [ battle animation command $80/$1b:  ]

        array_label ANIM_CMD_00, $1b
magic_init_27:
@cb5d:  inc     near w7eebfa
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$1d: update orbit (radius 32) ]

        array_label ANIM_CMD_00, $1d
magic_init_29:
@cb61:  lda     #$20                    ; radius 32
        sta     $24
        lda     z0e                     ; frame counter
        jmp     _c1ce31

; ------------------------------------------------------------------------------

; [ battle animation command $80/$1c: decrement screen brightness ]

        array_label ANIM_CMD_00, $1c
magic_init_28:
@cb6a:  lda     near w7ee9f9
        beq     @cb73
        dec
        sta     near w7ee9f9
@cb73:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$1a: validate/invalidate monster entry ]

; 0: clear target monster bit in $6191 (monster hasn't entered, hide monster)
; 1: set target monster bit in $6191 (monster entered, show monster)

        array_label ANIM_CMD_00, $1a
magic_init_26:
@cb74:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bpl     @cbab       ; return if a character
        and     #$0f
        sec
        sbc     #4
        tax
        lda     f:BitOrTbl,x   ; $10 = bit mask
        sta     $10
        ldx     zAnimScriptPtr
        inx
        stx     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        and     #1
        beq     @cb9d
        lda     near w7e6191                 ; show monster
        ora     $10
        sta     near w7e6191
        bra     @cbab
@cb9d:  lda     $10
        not_a
        sta     $10
        lda     near w7e6191                 ; hide monster (newly entering)
        and     $10
        sta     near w7e6191
@cbab:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6a:  ]

        array_label ANIM_CMD_00, $6a
        jsl     AnimCmd_00_6a_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$6b:  ]

        array_label ANIM_CMD_00, $6b
        jsl     AnimCmd_00_6b_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$69: update sprite layer priority based on attacker ]

        array_label ANIM_CMD_00, $69
magic_init_105:
@cbb6:  jsr     ResetSpritePriority
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bra     _cbca

; ------------------------------------------------------------------------------

; [ battle animation command $80/$17: update sprite layer priority based on target ]

        array_label ANIM_CMD_00, $17
magic_init_23:
@cbc1:  jsr     ResetSpritePriority
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
_cbca:  jsr     _c1c3fa       ; update character/monster layer priority
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$68:  ]

        array_label ANIM_CMD_00, $68
        jsl     AnimCmd_00_68_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$67:  ]

        array_label ANIM_CMD_00, $67
        jsl     AnimCmd_00_67_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$66:  ]

        array_label ANIM_CMD_00, $66
        jsl     AnimCmd_00_66_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$65:  ]

        array_label ANIM_CMD_00, $65
        jsl     AnimCmd_00_65_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$64:  ]

; shadow edge, purifier

        array_label ANIM_CMD_00, $64
magic_init_100:
@cbe5:  ldx     near wAnimThreadPtr
        clr_a
        sta     near wAnimThread::w7e6a37,x
        lda     near w7e896f         ; 8x8 bg1 tiles
        and     #$ef
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$62:  ]

; evil toot, fader

        array_label ANIM_CMD_00, $62
magic_init_98:
@cbf5:  jsr     _c1cc04
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetX,x
        shorta0
        bra     _c1cc27

; ------------------------------------------------------------------------------

; [ calc bounce offset ]

_c1cc04:
magic_init_97_sub1:
@cc04:  lda     [zAnimScriptPtr],y
        sta     $24
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e64e8,x
        ldy     #3
        ora     [zAnimScriptPtr],y
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$61:  ]

; cat rain, revivify, eyedrop

        array_label ANIM_CMD_00, $61
magic_init_97:
@cc1a:  jsr     _c1cc04
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        shorta0

; increment bounce angle ???
_c1cc27:
@cc27:  ldy     #2
        lda     [zAnimScriptPtr],y
        sta     $22
        lda     near wAnimThread::w7e64e8,x          ; bounce counter
        clc
        adc     $22
        sta     near wAnimThread::w7e64e8,x
        ldy     zAnimScriptPtr
        iny3
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$60: toggle attacker status ]

        array_label ANIM_CMD_00, $60
magic_init_96:
@cc3f:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x
        bmi     @cc8a
        and     #$03
        pha
        asl5
        tax
        ldy     #1
@cc53:  lda     [zAnimScriptPtr],y
        sta     $000f,y
        iny
        cpy     #$0005
        bne     @cc53
        lda     near wCharGfxDataBuf::ActiveStatus1,x
        eor     $10
        sta     near wCharGfxDataBuf::ActiveStatus1,x
        lda     near wCharGfxDataBuf::ActiveStatus2,x
        eor     $11
        sta     near wCharGfxDataBuf::ActiveStatus2,x
        lda     near wCharGfxDataBuf::ActiveStatus3,x
        eor     $12
        sta     near wCharGfxDataBuf::ActiveStatus3,x
        lda     near wCharGfxDataBuf::ActiveStatus4,x
        eor     $13
        sta     near wCharGfxDataBuf::ActiveStatus4,x
        pla
        sta     near w7e7b78
        ldx     near wAnimThreadPtr
        phx
        jsr     UpdateStatusChangeAnim       ; update character status change animations
        plx
@cc8a:  ldy     zAnimScriptPtr
        iny4
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5f:  ]

        array_label ANIM_CMD_00, $5f
        jsl     AnimCmd_00_5f_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5e: rotate and zoom mode 7 ]

; used by overcast

        array_label ANIM_CMD_00, $5e
magic_init_94:
@cc98:  lda     z0e
        asl
        neg_a
        sta     $12
        lda     near w7ee9f0            ; init $ff when mode 7 graphics loaded
        sta     $24
        lda     $12
        jsr     CalcSine16
        longa
        lda     $28
        sta     near w7ee9c4  ; x zoom
        sta     near w7ee9ca  ; y zoom
        shorta0
        lda     near w7ee9f0
        sta     $24
        lda     $12
        clc
        adc     #$40
        jsr     CalcSine16
        longa
        lda     $28
        sta     near w7ee9c6
        neg_a
        sta     near w7ee9c8
        shorta0
        lda     near w7ee9f0
        sec
        sbc     #2
        sta     near w7ee9f0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5d:  ]

; unlike 80/31 and 80/63 which add a sine wave to the thread's y-offset,
; this command sets the thread y-offset directly

        array_label ANIM_CMD_00, $5d
magic_init_93:
@ccdf:  lda     #$18
        sta     $24
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e64e8,x
        asl2
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetY,x
        clc
        adc     $22
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        inc     near wAnimThread::w7e64e8,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5c:  ]

        array_label ANIM_CMD_00, $5c
        jsl     AnimCmd_00_5c_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5b:  ]

        array_label ANIM_CMD_00, $5b
        jsl     AnimCmd_00_5b_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$5a:  ]

        array_label ANIM_CMD_00, $5a
        jsl     AnimCmd_00_5a_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$59:  ]

        array_label ANIM_CMD_00, $59
        jsl     AnimCmd_00_59_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$58: set circle shape ]

; b1: circle shape

        array_label ANIM_CMD_00, $58
magic_init_88:
@cd17:  lda     [zAnimScriptPtr],y
        sta     near wCircleShape       ; circle shape
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$57: set bg3/bg4 window mask settings ]

; b1: ----2211
;     2: enable bg3 in window 2
;     1: enable bg3 in window 1

        array_label ANIM_CMD_00, $57
magic_init_87:
@cd1f:  lda     [zAnimScriptPtr],y
        sta     f:hW34SEL     ; bg3/bg4 window mask settings
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$56:  ]

        array_label ANIM_CMD_00, $56
magic_init_86:
@cd28:  clr_axy
        longa
        lda     z0e                     ; frame counter
        asl
        sta     $12
        asl2
        sta     $10
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f87,x  ; facing direction
        and     #$00ff
        bne     @cd51
        lda     $10
        neg_a
        sta     $10
        lda     $12
        neg_a
        sta     $12
@cd51:  clr_ax
@cd53:  lda     f:RNGTbl,x
        bmi     @cd5e
        sec
        sbc     $12
        bra     @cd61
@cd5e:  sec
        sbc     $10
@cd61:  sta     near wBG1ScrollData::Horz,y               ; bg1 h-scroll hdma data
        inx
        iny4
        cpx     #151
        bne     @cd53
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$55:  ]

; quasar

        array_label ANIM_CMD_00, $55
magic_init_85:
@cd72:  lda     [zAnimScriptPtr],y
        beq     @cdbb
        clr_ax
        longa
        lda     near w7ee9d0
        asl2
        sta     $10
        lda     near w7e64b6
@cd84:  sta     near wBG1ScrollData::Vert,x
        inx4
        cpx     $10
        bne     @cd84
@cd8f:  sta     near wBG1ScrollData::Vert,x
        dec
        inx4
        cpx     #151*4
        bne     @cd8f
        inc     near w7ee9d0
        clr_ax
        lda     near w7e64b4
@cda4:  sta     near wBG1ScrollData::_0,x
        sta     near wBG1ScrollData::_75,x
        inx4
        cpx     #75*4
        bne     @cda4
        sta     near wBG1ScrollData::_150
        shorta0
        bra     @cdc1
@cdbb:  ldy     #1
        sty     near w7ee9d0
@cdc1:  jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$54: toggle character row ]

; r.polarity

        array_label ANIM_CMD_00, $54
magic_init_84:
@cdc4:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @cdde
        asl5
        tay
        lda     near wCharGfxDataBuf::Row,y
        eor     #1
        sta     near wCharGfxDataBuf::Row,y
        clr_a
        sta     near wCharGfxData::AnimAction,y
@cdde:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$53: move character to other row ]

; used by r.polarity
; use 6 times to move to the other row

        array_label ANIM_CMD_00, $53
magic_init_83:
@cddf:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @ce28
        and     #%11
        sta     $10
        asl5
        tay
        stz     $11
        lda     near w7e201f
        asl2
        clc
        adc     $10
        tax
        lda     near wCharGfxDataBuf::Row,y
        eor     #1
        and     #1
        beq     @ce0b
        lda     f:_c2a86f,x
        bra     @ce0f
@ce0b:  lda     f:_c2a87f,x
@ce0f:  sta     $10
        bpl     @ce15
        dec     $11
@ce15:  lda     #CHAR_ACTION::WALKING_FORWARD
        sta     near wCharGfxData::AnimAction,y
        longa
        lda     near wCharGfxData::w7e61c9,y
        clc
        adc     $10
        sta     near wCharGfxData::w7e61c9,y
        shorta0
@ce28:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$52: update orbit (radius 16) ]

        array_label ANIM_CMD_00, $52
magic_init_82:
@ce29:  lda     #$10                    ; radius 16
        sta     $24
        lda     z0e                     ; frame counter
        asl2

_c1ce31:
@ce31:  asl3
        pha
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetX,x
        clc
        adc     $22
        sta     near wAnimThread::ThreadOffsetX,x
        shorta0
        pla
        clc
        adc     #$40
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetY,x
        clc
        adc     $22
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$51:  ]

        array_label ANIM_CMD_00, $51
magic_init_81:
@ce62:  lda     [zAnimScriptPtr],y
        beq     @ce6e
        stz     near w7e619c
        stz     near w7e619d
        bra     @ce80
@ce6e:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x
        jsr     _c1ce83
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        jsr     _c1ce83
@ce80:  jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [  ]

_c1ce83:
one_duble_flag_set:
@ce83:  bmi     @ce8e
        and     #%11
        jsr     GetBitMask
        sta     near w7e619c
        rts
@ce8e:  and     #$7f
        sec
        sbc     #4
        jsr     GetBitMask
        sta     near w7e619d
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$50: random bg3 h-scrolling ]

; used by aero, quasar, flare star, blizzard fist
; lines should scroll left or right depending on the parameter (0 or 1),
; but there's a bug so they always scroll the same way

        array_label ANIM_CMD_00, $50
magic_init_80:
@ce9a:  clr_ax
        ldy     #1
        lda     [zAnimScriptPtr]                   ; *** bug *** should be [$5b],y
        ; lda     [zAnimScriptPtr],y
        bne     @cea4
        dex
@cea4:  stx     $14
        clr_axy
        longa
        lda     z0e
        asl
        sta     $12
        asl2
        sta     $10
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f87,x
        and     #$00ff
        bne     @cecd
        lda     $10
        eor     $14
        inc
        sta     $10
        lda     $12
        eor     $14
        inc
        sta     $12
@cecd:  clr_ax
@cecf:  lda     f:RNGTbl,x
        bmi     @ceda
        sec
        sbc     $12
        bra     @cedd
@ceda:  sec
        sbc     $10
@cedd:  sta     near wBG3ScrollData::Horz,y
        inx
        iny4
        cpx     #151
        bne     @cecf
        shorta0
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$4f: move thread to attacking character position ]

        array_label ANIM_CMD_00, $4f
magic_init_79:
@cef0:  jsr     GetAttackerThreadPtr
        longa
        lda     near wCharGfxData::PosX,y
        clc
        adc     near wCharGfxData::OffsetX,y
        clc
        adc     near wCharGfxData::AnimOffsetX,y
        clc
        adc     #$0008
        sta     near wAnimThread::ThreadPosX,x
        lda     near wCharGfxData::PosY,y
        clc
        adc     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$4e: clear frame offset ]

        array_label ANIM_CMD_00, $4e
magic_init_78:
@cf15:  ldx     near wAnimThreadPtr
        stz     near wAnimThread::LoopFrameOffset,x     ; clear frame offset
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$4d: set vector from triangle to target ]

        array_label ANIM_CMD_00, $4d
magic_init_77:
@cf1c:  ldx     near wAnimThreadPtr
        lda     near w7e6154       ; triangle x position
        sta     z7d
        sta     near wAnimThread::AttackerPosX,x     ; attacker x position
        stz     near wAnimThread::AttackerPosX+1,x
        lda     near w7e6155       ; triangle y position
        sta     z7e
        sta     near wAnimThread::AttackerPosY,x
        stz     near wAnimThread::AttackerPosY+1,x
        lda     near wAnimThread::TargetPosX,x
        sta     z7f
        lda     near wAnimThread::TargetPosY,x
        sta     $80
        jsr     InitVec
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$4c: move triangle to thread position ]

        array_label ANIM_CMD_00, $4c
magic_init_76:
@cf45:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x     ; thread x position
        clc
        adc     near wAnimThread::ThreadOffsetX,x     ; thread x offset
        sta     $10
        lda     near wAnimThread::ThreadPosY,x     ; thread y position
        clc
        adc     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        sta     $12
        shorta0
        lda     $10
        sta     near w7e6154       ; triangle x position
        lda     $12
        sta     near w7e6155       ; triangle y position
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$4a: characters don't step back after attack ]

; used for sonic dive

        array_label ANIM_CMD_00, $4a
magic_init_74:
@cf6a:  stz     near w7e61ae                 ; make all characters step back
        stz     near w7e61ae+1
        stz     near w7e61ae+2
        stz     near w7e61ae+3
        rts

; ------------------------------------------------------------------------------

; red, gray, yellow, blue, lighter blue, brown, red, gray
RandSpriteAnimPalTbl:
@cf77:  .byte   $39,$3b,$3c,$56,$78,$65,$39,$3b

; ------------------------------------------------------------------------------

; [ battle animation command $80/$49: load a random color sprite palette ]

; ink hit, virite

        array_label ANIM_CMD_00, $49
magic_init_73:
@cf7f:  jsr     Rand
        and     #%111
        tax
        lda     f:RandSpriteAnimPalTbl,x
        jsr     LoadSpriteAnimPal
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$48: make monster invisible ]

        array_label ANIM_CMD_00, $48
magic_init_72:
@cf8d:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bpl     @cfa9
        and     #$7f
        sec
        sbc     #4
        jsr     GetBitMask
        not_a
        sta     $22
        lda     near w7ee9e6
        and     $22
        sta     near w7ee9e6
@cfa9:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$47: change bg1/bg2 graphics vram location ]

; 50 Gs, Confuser, Revenger, Shadow Edge

        array_label ANIM_CMD_00, $47
magic_init_71:
@cfaa:  lda     [zAnimScriptPtr],y
        sta     near w7e897d
        sta     near w7e607d
        and     #$0f
        sta     near w7e62a9
        bra     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$46: change bg1 tilemap vram location ]

; 50 Gs, Confuser, Revenger, Shadow Edge (battle bg on bg1)

        array_label ANIM_CMD_00, $46
magic_init_70:
@cfb9:  lda     [zAnimScriptPtr],y
        sta     near w7e8971
        bra     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$45:  ]

        array_label ANIM_CMD_00, $45
magic_init_69:
@cfc0:  lda     [zAnimScriptPtr],y
        sta     f:hW12SEL

_c1cfc6:
@cfc6:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$44: copy position from previous thread ]

; used by fire/ice/bolt beam bg3 thread

        array_label ANIM_CMD_00, $44
magic_init_68:
@cfcc:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::AttackerPosX - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::AttackerPosX,x
        lda     near wAnimThread::AttackerPosY - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::AttackerPosY,x
        lda     near wAnimThread::TargetPosX - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::TargetPosX,x
        lda     near wAnimThread::TargetPosY - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::TargetPosY,x
        lda     near wAnimThread::w7e6f87 - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::w7e6f87,x
        lda     near wAnimThread::ThreadPosX - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::ThreadPosX,x
        lda     near wAnimThread::ThreadPosY - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::ThreadPosY,x
        lda     near wAnimThread::ThreadOffsetX - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::ThreadOffsetX,x
        lda     near wAnimThread::ThreadOffsetY - wAnimThread::BLOCK_SIZE,x
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$43: moon song effect ]

; init (b1 = 0) or update (b1 = 1) fenrir entrance scroll hdma effect
; needs to be repeated 128 times to get back to normal

        array_label ANIM_CMD_00, $43
magic_init_67:
@d00b:  lda     [zAnimScriptPtr],y
        beq     @d05b
        clr_ax
        longa
        lda     near w7ee9d0
        asl2
        sta     $10
        lda     near w7e64b6
        clc
        adc     near w7ee9d0
@d021:  sta     near wBG1ScrollData::Vert,x
        dec
        inx4
        cpx     $10
        bne     @d021
        lda     near w7e64b6
@d030:  sta     near wBG1ScrollData::Vert,x
        inx4
        cpx     #151*4
        bne     @d030
        dec     near w7ee9d0
        clr_ax
        lda     near w7e64b4
@d044:  sta     near wBG1ScrollData::_0,x
        sta     near wBG1ScrollData::_75,x
        inx4
        cpx     #75*4
        bne     @d044
        sta     near wBG1ScrollData::_150
        shorta0
        bra     @d061
@d05b:  ldy     #$0080
        sty     near w7ee9d0
@d061:  jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$42: set mode7 settings register ($211a) ]

; b1 = ------vh
;      v: vertical flip
;      h: horizontal flip

        array_label ANIM_CMD_00, $42
magic_init_66:
@d064:  lda     [zAnimScriptPtr],y
        sta     f:hM7SEL
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$41: zoom/move bg1 (mode7) ]

; b1 = x zoom change
; b2 = y zoom change
; b3 = x position change
; b4 = y position change

        array_label ANIM_CMD_00, $41
magic_init_65:
@d06d:  stz     $11
        lda     [zAnimScriptPtr],y
        bpl     @d075
        dec     $11
@d075:  sta     $10
        longa
        lda     near w7ee9c4       ; x zoom
        clc
        adc     $10
        sta     near w7ee9c4
        shorta0
        iny
        stz     $11
        lda     [zAnimScriptPtr],y
        bpl     @d08e
        dec     $11
@d08e:  sta     $10
        longa
        lda     near w7ee9ca       ; y zoom size
        clc
        adc     $10
        sta     near w7ee9ca
        shorta
        iny
        stz     $11
        lda     [zAnimScriptPtr],y
        bpl     @d0a6
        dec     $11
@d0a6:  sta     $10
        iny
        stz     $13
        lda     [zAnimScriptPtr],y
        bpl     @d0b1
        dec     $13
@d0b1:  sta     $12
        longa
        lda     near w7ee9cc       ; x position
        clc
        adc     $10
        sta     near w7ee9cc
        lda     near w7ee9ce       ; y position
        clc
        adc     $12
        sta     near w7ee9ce
        lda     zAnimScriptPtr
        clc
        adc     #$0004
        sta     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$40: set screen mode ($2105) ]

; b1 = -----mmm
;      m: screen mode

        array_label ANIM_CMD_00, $40
magic_init_64:
@d0d3:  lda     near w7e896f
        and     #$f8
        ora     [zAnimScriptPtr],y
        sta     near w7e896f
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$3f: wait until bg1 thread reaches target ]

; used by sonic dive

        array_label ANIM_CMD_00, $3f
magic_init_63:
@d0e0:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x
        lsr3
        sta     $10
        lda     near wAnimThread::AttackerPosX,x
        neg_a
        lsr3
        sta     $12
        lda     near w7e201f
        and     #BATTLE_TYPE::MASK
        cmp     #BATTLE_TYPE::PINCER
        bne     @d102
        clr_a
        bra     @d104
@d102:  lda     #$08
@d104:  sta     $14
        lda     near wBG1Thread::ThreadPosX+1
        and     #$01
        bne     @d11e
        lda     near wBG1Thread::ThreadPosX
        sec
        sbc     $14
        lsr3
        cmp     $10
        beq     @d125
        cmp     $12
        beq     @d125
@d11e:  ldy     zAnimScriptPtr
        dey3
        sty     zAnimScriptPtr
@d125:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$3e: set main screen layers ]

; b1: ---s4321
;     s: enable sprites
;     4: enable bg4
;     3: enable bg3
;     2: enable bg2
;     1: enable bg1

        array_label ANIM_CMD_00, $3e
magic_init_62:
@d126:  lda     [zAnimScriptPtr],y
        sta     near w7e898d       ; main screen designation (->$212c)
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$3d:  ]

        array_label ANIM_CMD_00, $3d
magic_init_61:
@d12e:  jsr     GetAttackerThreadPtr
        lda     near wAnimThread::w7e6f87,x
        and     #$40
        bne     @d13c
        lda     #$18
        bra     @d13e
@d13c:  lda     #$e8
@d13e:  sta     $26
        lda     near wAnimThread::TargetIndex,x
        bmi     @d15c
        and     #$03
        asl
        tay
        lda     near w7e8033,y
        clc
        adc     $26
        bcc     @d154
        lda     near w7e8033,y
@d154:  sta     near wAnimThread::TargetPosX,x
        lda     near w7e8043,y
        bra     @d16d
@d15c:  sec
        sbc     #$04
        asl
        tay
        lda     near w7e800f,y
        clc
        adc     $26
        sta     near wAnimThread::TargetPosX,x
        lda     near w7e8027,y
@d16d:  sec
        sbc     #$08
        sta     near wAnimThread::TargetPosY,x
        jsr     CalcCharAttackVec
        ldx     near wAnimThreadPtr
        lda     z85
        clc
        adc     #$28
        sta     near wAnimThread::w7e74db,x
        lda     #$04
        sta     near w7e60af
        stz     near w7e60b0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$3c: return target's palette to normal ]

        array_label ANIM_CMD_00, $3c
magic_init_60:
@d18a:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @d1a1       ; branch if target is a monster
        tax
        asl5
        tay
        lda     near w7e616e,x     ; restore palette (character)
        sta     near wCharGfxData::Pal,y
        bra     @d1af
@d1a1:  and     #$0f
        tax
        sec
        sbc     #4
        asl
        tay
        lda     near w7e616e,x     ; restore palette (monster)
        sta     near w7e80db,y
@d1af:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$3b: swap target's palette w/ animation palette ]

        array_label ANIM_CMD_00, $3b
magic_init_59:
@d1b0:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @d1cb       ; branch if target is a monster
        tax
        asl5
        tay
        lda     near wCharGfxData::Pal,y     ; set palette index to 3 (character)
        and     #$f1
        ora     #$06
        sta     near wCharGfxData::Pal,y
        bra     @d1dd
@d1cb:  and     #$0f
        tax
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80db,y    ; set palette index to 3 (monster)
        and     #$f1
        ora     #$06
        sta     near w7e80db,y
@d1dd:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$3a: set gradient line intensity ]

; odin, raiden, overcast, s. cross, carbunkl

        array_label ANIM_CMD_00, $3a
magic_init_58:
@d1de:  lda     [zAnimScriptPtr],y
        sta     near w7e62ae
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$39: update narrow blue gradient lines ]

; odin, raiden, carbunkl, s. cross (similar to 80/5f used by overcast)
; this version has about 4 narrow gradients
; b1: change in color intensity (signed)

        array_label ANIM_CMD_00, $39
magic_init_57:
@d1e6:  lda     #FIXED_CLR::BLUE
        sta     $16
        ldy     #1
        lda     near w7e62ae                 ; add to gradient intensity
        clc
        adc     [zAnimScriptPtr],y
        sta     near w7e62ae
        sta     $12
        lda     #FIXED_CLR::WHITE
        sta     near w7e8993+3               ; fixed color add/sub data -> $2132
        lda     $16
        sta     $10
        lda     near w7e62ad
        and     #%11111
        tax
        ldy     #4
        phy
@d20b:  lda     f:_c1d29c,x             ; gradient ramp
        sec
        sbc     $12
        bpl     @d215
        clr_a
@d215:  ora     $10
        sta     near w7e8993+3+$0000,y
        sta     near w7e8993+3+$0080,y
        sta     near w7e8993+3+$0100,y
        sta     near w7e8993+3+$0180,y
        inx
        txa
        and     #%11111
        tax
        bne     @d22e
        lda     $16
        sta     $10
@d22e:  iny4
        cpy     #33 * 4
        bne     @d20b
        ply
@d238:  lda     near w7e8993+3+$0000,y
        sta     near w7e8993+3+$0200,y
        iny4
        cpy     #23 * 4
        bne     @d238
        inc     near w7e62ad                 ; this causes the gradient to scroll
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$38: use high priority bg3 ]

        array_label ANIM_CMD_00, $38
magic_init_56:
@d24d:  lda     near w7e896f
        ora     #$08
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$37: clear fixed color value hdma data ]

        array_label ANIM_CMD_00, $37
magic_init_55:
@d256:  clr_ax
        lda     #$e0
@d25a:  sta     near w7e8993+3,x     ; fixed color value hdma data
        inx4
        cpx     #$025c
        bne     @d25a
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$36: restore palettes for monster sprite data ]

        array_label ANIM_CMD_00, $36
magic_init_54:
@d267:  clr_ax
@d269:  lda     near w7e80db,x
        sec
        sbc     #$0a
        sta     near w7e80db,x
        inx2
        cpx     #$000c
        bne     @d269
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$35: use character palettes for monster sprites ]

; used by hope song
; this allows color math to affect monster sprites

        array_label ANIM_CMD_00, $35
magic_init_53:
@d27a:  clr_ax
@d27c:  lda     near w7e80db,x     ; monster sprite data
        clc
        adc     #$0a        ; increase palette index by 5
        sta     near w7e80db,x
        inx2
        cpx     #$000c
        bne     @d27c
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$34: copy monster palettes to character palettes ]

; used by hope song
; this allows color math to affect monster sprites

        array_label ANIM_CMD_00, $34
magic_init_52:
@d28d:  clr_ax
@d28f:  lda     near w7e7e00::_8,x     ; monster palettes 1-3
        sta     near w7e7e00::_13,x     ; character palettes 2-4
        inx
        cpx     #$0060
        bne     @d28f
        rts

; ------------------------------------------------------------------------------

; fixed color gradient ramp
_c1d29c:
        .repeat 16, i                   ; ramp up to 15
        .byte i
        .endrep
        .repeat 16, i                   ; ramp back to zero
        .byte 15 - i
        .endrep

; fixed color gradient colors
_c1d2bc:
        .byte   FIXED_CLR::BLUE         ; rainbow
        .byte   FIXED_CLR::GREEN
        .byte   FIXED_CLR::YELLOW
        .byte   FIXED_CLR::RED
        .byte   FIXED_CLR::MAGENTA
        .byte   FIXED_CLR::CYAN
        .byte   FIXED_CLR::BLUE
        .byte   FIXED_CLR::RED

        .byte   FIXED_CLR::RED          ; red/yellow
        .byte   FIXED_CLR::YELLOW
        .byte   FIXED_CLR::RED
        .byte   FIXED_CLR::YELLOW
        .byte   FIXED_CLR::RED
        .byte   FIXED_CLR::YELLOW
        .byte   FIXED_CLR::RED
        .byte   FIXED_CLR::YELLOW

; ------------------------------------------------------------------------------

; [ battle animation command $80/$4b: update red/yellow gradient lines ]

; megazerk
; b1: color intensity (0..15)

        array_label ANIM_CMD_00, $4b
magic_init_75:
@d2cc:  lda     #8                      ; offset for red/yellow
        sta     $16
        bra     _d2d4

; ------------------------------------------------------------------------------

; [ battle animation command $80/$33: update rainbow gradient lines ]

; b1: color intensity (0..15)

        array_label ANIM_CMD_00, $33
magic_init_51:
@d2d2:  stz     $16                     ; offset for rainbow
_d2d4:  lda     [zAnimScriptPtr],y
        sta     $12
        lda     #FIXED_CLR::WHITE
        sta     near w7e8993+3
        lda     near w7e62ae                 ; fixed color for gradient lines
        and     #%11100000
        lsr5
        clc
        adc     $16
        tax
        sta     $14
        lda     f:_c1d2bc,x             ; gradient color
        sta     $10
        lda     near w7e62ad
        and     #%11111
        tax
        ldy     #4
@d2fc:  lda     f:_c1d29c,x             ; gradient ramp
        sec
        sbc     $12
        bpl     @d306
        clr_a
@d306:  ora     $10
        sta     near w7e8993+3,y
        inx
        txa
        and     #%11111                 ; 32 scanlines per color
        tax
        bne     @d326
        lda     $14
        inc
        and     #%111
        sta     $14
        clc
        adc     $16
        tax
        lda     f:_c1d2bc,x             ; next gradient color
        sta     $10
        ldx     #0

; next scanline
@d326:  iny4
        cpy     #151 * 4
        bne     @d2fc
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        inc     near w7e62ad                 ; this causes the gradient to scroll
        inc     near w7e62ae                 ; increment gradient color counter
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$32:  ]

        array_label ANIM_CMD_00, $32
magic_init_50:
@d33e:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f87,x
        beq     @d34a
        lda     #$01
        bra     @d34b
@d34a:  clr_a
@d34b:  longa
        asl
        sta     $22
        lda     zAnimScriptPtr
        inc
        clc
        adc     $22
        sta     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$63: move in vertical sine wave (narrow) ]

; evil toot

; b1: speed

        array_label ANIM_CMD_00, $63
magic_init_99:
@d361:  lda     #$20
        bra     _d367

; ------------------------------------------------------------------------------

; [ battle animation command $80/$31: move in vertical sine wave (wide) ]

; hope song, sea song

; b1: speed

        array_label ANIM_CMD_00, $31
magic_init_49:
@d365:  lda     #$50
_d367:  sta     $24
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e64e8+1,x
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        shorta0
        ldy     #1
        lda     near wAnimThread::w7e64e8+1,x
        clc
        adc     [zAnimScriptPtr],y
        sta     near wAnimThread::w7e64e8+1,x
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$30: load animation palette for character 1 ]

; b1: palette index

        array_label ANIM_CMD_00, $30
magic_init_48:
@d38e:  lda     [zAnimScriptPtr],y     ; palette index
        longa
        asl4
        tax
        clr_ay
@d399:  lda     f:AttackPal,x
        sta     near w7e7e00::_12,y
        inx2
        iny2
        cpy     #$0010
        bne     @d399
        shorta0
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$2f:  ]

        array_label ANIM_CMD_00, $2f
magic_init_47:
@d3af:  ldx     near wAnimThreadPtr
        lda     #$08
        sta     near w7e60af
        stz     near w7e60b0
        jsr     Rand
        and     #$07
        sta     $22
        lda     near wAnimThread::w7e6f87,x
        bne     @d3ca       ; branch if mirrored
        lda     #$7c
        bra     @d3d2
@d3ca:  lda     #$fc
        ldy     #2
        clc
        adc     [zAnimScriptPtr],y
@d3d2:  clc
        adc     $22
        ldy     #1
        adc     [zAnimScriptPtr],y
        sta     near wAnimThread::w7e74db,x     ; vector angle
        ldy     zAnimScriptPtr
        iny2
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$2e: move thread ]

; b1: x position
; b2: y position

        array_label ANIM_CMD_00, $2e
magic_init_46:
@d3e4:  longa
        ldx     near wAnimThreadPtr
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     near wAnimThread::ThreadPosX,x     ; thread x position
        iny
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     near wAnimThread::ThreadPosY,x     ; thread y position
        inc     zAnimScriptPtr
        inc     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ check battle type ]

_c1d405:
get_mode_type:
@d405:  ldx     near wAnimThreadPtr
        lda     near w7e201f
        and     #BATTLE_TYPE::MASK
        cmp     #BATTLE_TYPE::SIDE
        bne     @d422
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @d41e       ; branch if a monster
        cmp     #$02
        bcc     @d41e
        lda     #$01
        bra     @d422
@d41e:  lda     #$02
        rts
        clr_a
@d422:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$2d: jump based on battle type ]

; +b1: jump address for normal attack
; +b3: jump address for back attack (or side attack if attacker is character 3/4)
; +b5: jump address for pincer attack (or side attack if attacker is character 1/2 or monster)

        array_label ANIM_CMD_00, $2d
magic_init_45:
@d423:  jsr     _c1d405
        longa
        asl
        sta     $22
        lda     zAnimScriptPtr
        inc
        clc
        adc     $22
        sta     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$2b: load animation palette (bg1) ]

; b1: palette index

        array_label ANIM_CMD_00, $2b
magic_init_43:
@d43c:  lda     [zAnimScriptPtr],y
        jsr     LoadBG1AnimPal
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$2c: load animation palette (bg3) ]

; b1: palette index

        array_label ANIM_CMD_00, $2c
magic_init_44:
@d444:  lda     [zAnimScriptPtr],y
        jsr     LoadBG3AnimPal
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$2a: load animation palette (sprite) ]

; b1: palette index

        array_label ANIM_CMD_00, $2a
magic_init_42:
@d44c:  lda     [zAnimScriptPtr],y
        jsr     LoadSpriteAnimPal
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$29: hide/show cursor sprites (during esper attack) ]

        array_label ANIM_CMD_00, $29
magic_init_41:
@d454:  lda     [zAnimScriptPtr],y
        sta     near w7e62be       ; hide/show cursor sprites (during esper attack)
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$28: set layer priority for all character ]

        array_label ANIM_CMD_00, $28
magic_init_40:
@d45c:  lda     [zAnimScriptPtr],y
        sta     $10
        .repeat 4, i
        lda     .loword(array_member wCharGfxData, i, LayerPriority)
        and     #$cf
        ora     $10
        sta     .loword(array_member wCharGfxData, i, LayerPriority)
        .endrep
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$27: hide/show characters for esper attack ]

; b1: 1 = hide, 0 = show

        array_label ANIM_CMD_00, $27
magic_init_39:
@d48b:  lda     [zAnimScriptPtr],y
        sta     near w7e62bd
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$26: enable/disable character palette updates ]

        array_label ANIM_CMD_00, $26
magic_init_38:
@d493:  lda     [zAnimScriptPtr],y
        sta     near w7e62bf
        jmp     _c1cfc6

; ------------------------------------------------------------------------------

; [ battle animation command $80/$24: clear bg3 scroll hdma data ]

        array_label ANIM_CMD_00, $24
magic_init_36:
@d49b:  clr_ax
        longa
@d49f:  stz     near wBG3ScrollData,x
        inx2
        cpx     #151*4
        bne     @d49f
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$25: clear bg1 scroll hdma data ]

        array_label ANIM_CMD_00, $25
magic_init_37:
@d4ad:  clr_ax
        longa
@d4b1:  stz     near wBG1ScrollData,x
        inx2
        cpx     #151*4
        bne     @d4b1
        shorta
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$23:  ]

; pearl wind

        array_label ANIM_CMD_00, $23
magic_init_35:
@d4be:  shorti
        longa
        clr_ax
        lda     near wBG1ScrollData::_151::Vert
        pha
@d4c8:  .repeat 8, i
        dec     near {array_member wBG1ScrollData, i * 19, Vert},x
        .endrep
        inx4
        cpx     #76
        bne     @d4c8
        pla
        sta     near wBG1ScrollData::_151::Vert
        shorta0
        longi
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$22:  ]

; pearl wind

        array_label ANIM_CMD_00, $22
magic_init_34:
@d4f2:  longa
        lda     near w7e7b18
        sec
        sbc     near w7e7b1f
        sta     $10
        clr_ayx
@d500:  lda     f:_c2d39f,x
        and     #$00ff
        sta     $12
        lda     $10
@d50b:  sta     near wBG1ScrollData::Vert,y
        dec
        iny4
        cpy     #$012c
        beq     @d524
        dec     $12
        bne     @d50b
        dec
        sta     $10
        inc     $14
        inx
        bra     @d500
@d524:  dec
        sta     $10
@d527:  lda     f:_c2d39f,x
        and     #$00ff
        sta     $12
        lda     $10
@d532:  sta     near wBG1ScrollData::Vert,y
        dec
        iny4
        cpy     #$025c
        beq     @d54a
        dec     $12
        bne     @d532
        dec
        sta     $10
        dec     $14
        bra     @d527
@d54a:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$21: update sprite layer priority based on polar angle ]

        array_label ANIM_CMD_00, $21
magic_init_33:
@d54e:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e74d8,x     ; vector angle
        clc
        adc     #$40
        bmi     @d562       ; branch if between 180 and 360 degrees
        lda     near wAnimThread::IsBackSprite,x     ; set sprite layer priority to low
        and     #$fe
        sta     near wAnimThread::IsBackSprite,x
        rts
@d562:  lda     near wAnimThread::IsBackSprite,x     ; set sprite layer priority to high
        ora     #$01
        sta     near wAnimThread::IsBackSprite,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$1e: scroll bg3 for pearl ]

        array_label ANIM_CMD_00, $1e
magic_init_30:
@d56b:  shorti
        longa
        clr_ax
        lda     near wBG3ScrollData::_151::Vert       ; save menu region bg3 scroll hdma data (vertical)
        pha
@d575:  .repeat 8, i
        dec     near {array_member wBG3ScrollData, 19 * i, Vert},x     ; decrement all bg3 scroll hdma values (vertical)
        .endrep
        inx4
        cpx     #19 * 4
        bne     @d575
        pla
        sta     near wBG3ScrollData::_151::Vert       ; restore menu region bg3 scroll hdma data (vertical)
        shorta0
        longi
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$20: init bg3 hdma scroll data for pearl (vertical) ]

        array_label ANIM_CMD_00, $20
magic_init_32:
@d59f:  longa
        lda     near w7e7b24       ; bg3 thread y offset
        sec
        sbc     near w7e7b2b       ; bg3 thread y position
        sta     $10
        clr_ayx
@d5ad:  lda     f:_c2d39f,x
        and     #$00ff
        sta     $12
        lda     $10
@d5b8:  sta     near wBG3ScrollData::Vert,y     ; bg3 scroll hdma data (vertical)
        dec                 ; decrement vertical scroll
        iny4
        cpy     #$012c
        beq     @d5d1
        dec     $12
        bne     @d5b8
        dec
        sta     $10
        inc     $14
        inx
        bra     @d5ad
@d5d1:  dec
        sta     $10
@d5d4:  lda     f:_c2d39f,x
        and     #$00ff
        sta     $12
        lda     $10
@d5df:  sta     near wBG3ScrollData::Vert,y     ; bg3 scroll hdma data (vertical)
        dec
        iny4
        cpy     #$025c
        beq     @d5f8
        dec     $12
        bne     @d5df
        dec
        sta     $10
        dec     $14
        dex
        bra     @d5d4
@d5f8:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$1f: init bg3 hdma scroll data for pearl (horizontal) ]

; pearl

        array_label ANIM_CMD_00, $1f
magic_init_31:
@d5fc:  lda     #$4c
        sta     near w7e9613       ; circle size
        lda     near wCircleShape       ; save circle shape
        pha
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        lda     #$4c
        sta     near w7e9615       ; circle y position
        lda     #$80
        sta     near w7e9614       ; circle x position
        jsr     UpdateCircle_near
        clr_ax
@d617:  lda     near w7e9a1f+2,x     ; window position hdma data buffer
        sta     near wBG3ScrollData::Horz_L,x     ; bg3 scroll hdma data (horizontal)
        stz     near wBG3ScrollData::Horz_H,x
        inx4
        cpx     #$025c
        bne     @d617
        pla
        sta     near wCircleShape       ; restore circle shape
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$19:  ]

        array_label ANIM_CMD_00, $19
magic_init_25:
@d62e:  ldx     #$002c
        stx     $24
        lda     #$10
        sec
        sbc     near w7e616c                         ; height of sketched monster
        bne     @d640
        ldx     #$0034
        stx     $24
@d640:  longa
        asl3
        sta     $22
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     $22
        sec
        sbc     $24
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        jsr     ResetSpritePriority
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x
        jsr     _c1c3fa
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x
        asl5
        tay
        lda     #$30
        sta     near wCharGfxData::LayerPriority,y
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$18: load sketched monster palette ]

        array_label ANIM_CMD_00, $18
magic_init_24:
@d677:  ldx     near w7e6169       ; pointer to sketched monster palette
        clr_ay
@d67c:  lda     f:MonsterPal,x
        sta     near w7e7e00::_3,y     ; bg palette 3
        sta     near w7e7c00::_3,y
        inx
        iny
        cpy     #$0020
        bne     @d67c
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$16:  ]

        array_label ANIM_CMD_00, $16
magic_init_22:
@d68e:  ldx     near wAnimThreadPtr
        stz     near wAnimThread::w7e64e8,x
        stz     near wAnimThread::w7e64e8+1,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$15: move circle to thread position ]

        array_label ANIM_CMD_00, $15
magic_init_21:
@d698:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x     ; thread x position
        clc
        adc     near wAnimThread::ThreadOffsetX,x     ; thread x offset
        sta     $22
        lda     near wAnimThread::ThreadPosY,x     ; thread y position
        clc
        adc     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        sta     $24
        shorta0
        lda     $22
        sta     near w7e9614       ;
        lda     $24
        sta     near w7e9615
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$14: make target vanish ]

        array_label ANIM_CMD_00, $14
magic_init_20:
@d6bd:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @d6e4       ; return if a monster
        and     #$03
        sta     $10
        asl5
        tax
        lda     near wCharGfxDataBuf::ActiveStatus1,x     ; set vanish status
        setflg  STATUS1, VANISH
        sta     near wCharGfxDataBuf::ActiveStatus1,x
        lda     $10
        sta     near w7e7b78
        ldx     near wAnimThreadPtr
        phx
        jsr     UpdateStatusChangeAnim       ; update character status change animations
        plx
@d6e4:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$13: toggle imp graphics for target ]

        array_label ANIM_CMD_00, $13
magic_init_19:
@d6e5:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @d70d       ; branch if a monster
        and     #$03
        sta     $10
        asl5
        tax
        lda     near wCharGfxDataBuf::ActiveStatus1,x     ; toggle imp status
        eorflg  STATUS1, IMP
        sta     near wCharGfxDataBuf::ActiveStatus1,x
        lda     $10
        sta     near w7e7b78       ; character index for status change animations
        ldx     near wAnimThreadPtr
        phx
        jsr     UpdateStatusChangeAnim       ; update character status change animations
        plx
        rts
@d70d:  and     #$7f
        sec
        sbc     #$04
        tay
        lda     near w7e62c2,y     ; toggle imp graphics
        eor     #$01
        sta     near w7e62c2,y
        ldx     near wAnimThreadPtr
        phx
        jsr     InitMonsterGfx
        jsr     WaitTfrMonsterGfx
        plx
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$11: randomize polar angle ]

        array_label ANIM_CMD_00, $11
magic_init_17:
@d727:  jsr     Rand
        ldx     near wAnimThreadPtr
        sta     near wAnimThread::w7e74d8,x
        stz     near wAnimThread::w7e74d9,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$12: init polar movement ]

        array_label ANIM_CMD_00, $12
magic_init_18:
@d734:  ldx     near wAnimThreadPtr
        stz     near wAnimThread::w7e74d8,x     ; polar angle
        stz     near wAnimThread::w7e74d9,x     ; polar radius
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$10:  ]

        array_label ANIM_CMD_00, $10
magic_init_16:
@d73e:  longa
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetPosX,x     ; target x position
        sta     near wAnimThread::ThreadPosX,x     ; thread x position
        lda     near wAnimThread::TargetPosY,x
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$0c: move to first thread position ]

        array_label ANIM_CMD_00, $0c
magic_init_12:
@d753:  longa
        lda     near wAnimThreadPtr
        tax
        and     #$ff80      ; pointer to first sprite thread
        tay
        lda     near wAnimThread::ThreadPosX,y     ; thread x position
        sta     near wAnimThread::ThreadPosX,x
        lda     near wAnimThread::ThreadPosY,y     ; thread y position
        sta     near wAnimThread::ThreadPosY,x
        lda     near wAnimThread::ThreadOffsetX,y     ; thread x offset
        sta     near wAnimThread::ThreadOffsetX,x
        lda     near wAnimThread::ThreadOffsetY,y     ; thread y offset
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$0f: init ??? vector ]

; slightly randomizes the vector direction
; used by grav bomb, cold dust

        array_label ANIM_CMD_00, $0f
magic_init_15:
@d779:  ldx     near wAnimThreadPtr
        lda     #$08
        sta     near w7e60af       ;
        stz     near w7e60b0       ;
        jsr     Rand
        and     #$07
        sta     $22
        lda     near wAnimThread::w7e6f87,x
        bne     @d794       ; branch if mirrored
        lda     #$7c
        bra     @d796
@d794:  lda     #$fc
@d796:  clc
        adc     $22
        sta     near wAnimThread::w7e74db,x     ; vector angle
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$0e: init thread position for monster jump ]

        array_label ANIM_CMD_00, $0e
magic_init_14:
@d79d:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bpl     @d7c3       ; return if a character
        and     #$7f
        sec
        sbc     #$04
        asl
        tay
        longa
        lda     near w7e80c3,y     ; monster left x coordinate
        sta     near wAnimThread::w7e64e8,x
        lda     near w7e80cf,y     ; monster top y coordinate
        sta     near wAnimThread::w7e64ea,x
        clr_a
        sta     near w7e80b7,y     ;
        sta     near w7e80ab,y
        shorta
@d7c3:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$0d:  ]

; unused

        array_label ANIM_CMD_00, $0d
magic_init_13:
@d7c4:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::w7e74d9,x
@d7cc:  clc
        adc     #8
        cmp     near wAnimThread::w7e74dc,x
        bcc     @d7cc
        sec
        sbc     #8
        sta     near wAnimThread::w7e74d9,x
        shorta0
        jsr     CalcThreadVecPos
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$0b: update esper pre-animation balls position ]

        array_label ANIM_CMD_00, $0b
magic_init_11:
@d7e3:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e74d9,x     ;
        sta     $24
        lda     near wAnimThread::w7e74d8,x     ; direction
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetY,x     ; x position
        shorta0
        lda     near wAnimThread::w7e74d8,x     ; direction + 90 degrees
        clc
        adc     #$40
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetX,x     ; y position
        shorta0
        lda     near wAnimThread::w7e74d8,x     ; rotate 4 units counterclockwise
        sec
        sbc     #4
        sta     near wAnimThread::w7e74d8,x
        lda     near wAnimThread::w7e74d9,x     ; increase radius by 2
        clc
        adc     #2
        cmp     #$30        ; max 48
        bcs     @d82a
        sta     near wAnimThread::w7e74d9,x
@d82a:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$0a: update vector for white/effect pre-attack animation ]

; this makes a diagonal ellipse, see AnimType_11 for initialization

        array_label ANIM_CMD_00, $0a
magic_init_10:
@d82b:  ldx     near wAnimThreadPtr
        lda     #$30                    ; vector magnitude
        sta     $24
        lda     near wAnimThread::w7e74d8,x
        eor     near wAnimThread::w7e74d9,x
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        lda     near wAnimThread::w7e74d8,x
        clc
        adc     #$20
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetX,x
        shorta0
        lda     near wAnimThread::w7e74d8,x
        sec
        sbc     #$04
        sta     near wAnimThread::w7e74d8,x
        rts

; ------------------------------------------------------------------------------

; [ +$22 = $24 * sin (A) ]

CalcVecSine:
@d868:  jsr     CalcSine8
        bmi     @d872       ; branch if negative
        sta     $22
        stz     $23
        rts
@d872:  sta     $22
        lda     #$ff
        sta     $23
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$09: update character/monster sprite tile priority for tornado ]

; w wind/spiraler

        array_label ANIM_CMD_00, $09
magic_init_9:
@d879:  lda     #$30
        sta     near wCharGfxData::_0::LayerPriority       ; show all sprites in front of bg1
        sta     near wCharGfxData::_1::LayerPriority
        sta     near wCharGfxData::_2::LayerPriority
        sta     near wCharGfxData::_3::LayerPriority
        lda     #$31
        sta     near w7e80db+1
        sta     near w7e80db+3
        sta     near w7e80db+5
        sta     near w7e80db+7
        sta     near w7e80db+9
        sta     near w7e80db+11
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosY,x     ; thread y position
        clc
        adc     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        clc
        adc     #$0046
        sta     $24
        clr_axy
@d8b0:  lda     $24
        cmp     near w7e8043,y     ; character bottom y coordinate
        bcc     @d8c1
        shorta
        lda     #$20
        sta     near wCharGfxData::LayerPriority,x     ; show sprite behind bg1
        clr_a                 ; next character
        longa
@d8c1:  txa
        clc
        adc     #$0020
        tax
        iny2
        cpy     #$0008
        bne     @d8b0
        clr_ay
@d8d0:  lda     $24
        cmp     near w7e8027,y     ; monster bottom y coordinate
        bcc     @d8e0
        shorta
        lda     #$21
        sta     near w7e80db+1,y     ; show sprite behind bg1
        longa
@d8e0:  iny2
        cpy     #$000c
        bne     @d8d0
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$08: move thread to vector position ]

; w wind/spiraler

        array_label ANIM_CMD_00, $08
magic_init_8:
@d8eb:  ldx     near wAnimThreadPtr
        jsr     MoveThreadToVec
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$07: move tornado to thread position ]

; w wind/spiraler

        array_label ANIM_CMD_00, $07
magic_init_7:
@d8f2:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetX,x     ; thread x offset
        sta     near w7e5f9d+1       ; tornado x position
        lda     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        sta     near w7e5f8d+1       ; tornado y position
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$06: init tornado variables ]

; w wind/spiraler

        array_label ANIM_CMD_00, $06
magic_init_6:
@d907:  clr_ax
@d909:  stz     near w7e5f6d,x     ; clear tornado data
        inx
        cpx     #$0040
        bne     @d909
        jsr     Rand
        clr_a
        sta     near w7e5f6d
        clc
        adc     #$10
        sta     near w7e5f7d
        lda     #$08                    ; amplitude
        sta     $24
        sta     $1a
        ldx     #$0100                  ; load to $44f5-$45f4 (64 scanlines)
        stx     $1c
        ldx     #$44f5
        clr_a
        jsr     _c10d8b
        jsr     _c1e5b4
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$05: init thread position (bum rush) ]

        array_label ANIM_CMD_00, $05
magic_init_5:
@d938:  jsr     GetAttackerThreadPtr
        longa
        lda     near wCharGfxData::OffsetX,y ; copy xy offset to thread
        sta     near wAnimThread::ThreadOffsetX,x
        lda     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        lda     near wAnimThread::AttackerIndex,x
        tay
        lda     near w7e7b10,y               ; hand swap
        beq     @d958
        clr_a
        bra     @d95a
@d958:  lda     #$80
@d95a:  sta     near wAnimThread::ThreadPosX,x  ; thread x position = $0480 or $0400
        lda     #$04
        sta     near wAnimThread::ThreadPosX+1,x
        lda     near wAnimThread::TargetWidth,x
        asl2
        clc
        adc     #$08
        sta     near wAnimThread::ThreadPosY,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$04: randomize vector angle and position ]

        array_label ANIM_CMD_00, $04
magic_init_4:
@d96e:  jsr     Rand
        ldx     near wAnimThreadPtr
        sta     near wAnimThread::w7e74d8,x     ; vector angle
        jsr     Rand
        ldx     near wAnimThreadPtr
        sta     near wAnimThread::w7e74d9,x     ; vector position
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$02: save attacker facing direction ]

        array_label ANIM_CMD_00, $02
magic_init_2:
@d981:  jsr     GetAttackerThreadPtr
        lda     near wCharGfxData::Flip,y
        sta     near w7e60b2
        lda     near wAnimThread::AttackerIndex,x  ; attacker id
        tay
        lda     near w7e7b10,y               ; attacker facing direction
        sta     near w7e60b1
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$03: restore attacker facing direction ]

        array_label ANIM_CMD_00, $03
magic_init_3:
@d995:  jsr     GetAttackerThreadPtr
        lda     near w7e60b2
        sta     near wCharGfxData::Flip,y
        lda     near wAnimThread::AttackerIndex,x
        tay
        lda     near w7e60b1
        sta     near w7e7b10,y
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$01: clear attacking character and thread x/y offset ]

        array_label ANIM_CMD_00, $01
magic_init_1:
@d9a9:  jsr     GetAttackerThreadPtr
        longa
        clr_a
        sta     near wCharGfxData::OffsetX,y
        sta     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadOffsetX,x
        sta     near wAnimThread::ThreadOffsetY,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $80/$00: set target position to attacking character position ]

; used for quadra slam/slice to return cyan to his original position

        array_label ANIM_CMD_00, $00
magic_init_0:
@d9be:  jsr     GetAttackerThreadPtr
        longa
        lda     near wCharGfxData::PosX,y     ; character x position
        clc
        adc     near wCharGfxData::AnimOffsetX,y     ; character x offset
        sta     near wAnimThread::TargetPosX,x     ; target x position
        lda     near wCharGfxData::PosY,y     ; character y position
        sta     near wAnimThread::TargetPosY,x     ; target y position
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ execute battle animation command ]

ExecAnimCmd:
set_magic_code:
@d9d7:  and     #$7f
        asl
        stx     near wAnimThreadPtr
        tax
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        jmp     (near AnimCmdTbl,x)

; ------------------------------------------------------------------------------

; battle animation command jump table ($80-$fe)
AnimCmdTbl:
        ptr_tbl ANIM_CMD

; ------------------------------------------------------------------------------

; [ battle animation command $c9:  ]

        array_label ANIM_CMD, $49
magic_code49:
@dae4:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetPosX,x
        sta     $10
        lda     [zAnimScriptPtr]
        jne     PlayAnimSfx
        lda     near w7ee9e7
        jmp     PlayAnimSfx

; ------------------------------------------------------------------------------

; [ battle animation command $f9: set magitek armor action ]

; b1: magitek animation type
; b2: 0 = attacker, 1 = target
; b3: character index (used if msb set)

        array_label ANIM_CMD, $79
magic_code79:
@daf9:  ldx     near wAnimThreadPtr
        ldy     #2
        lda     [zAnimScriptPtr],y
        bmi     @db14
        dey
        lda     [zAnimScriptPtr],y
        beq     @db0f
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @db1c       ; branch if a monster
        bra     @db14
@db0f:  lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @db1c       ; branch if a monster
@db14:  and     #$03
        tay
        lda     [zAnimScriptPtr]
        sta     near wMagitekAnimType,y     ; magitek animation type
@db1c:  ldy     zAnimScriptPtr
        iny2
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $fa: jump ]

; +b1: jump address

        array_label ANIM_CMD, $7a
magic_code7a:
@db23:  ldx     near wAnimThreadPtr
        longa
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr         ; set script pointer
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $f8: jump based on magitek mode ]

; +b1: jump address
; +b3: jump address if magitek mode

        array_label ANIM_CMD, $78
magic_code78:
@db31:  ldx     near wAnimThreadPtr
        lda     near wMagitekModeEnabled
        beq     @db3b
        lda     #$01
@db3b:  longa
        asl
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr
        clr_a
@db4d:  shorta
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $f7: wait for scanline ]

; b1: scanline

        array_label ANIM_CMD, $77
magic_code77:

.if ROM_VERSION >= 1
; **** added in rev 1 ****
@db4d:  lda     f:hHVBJOY
        bmi     @db4d       ; branch if in vblank
@db53:  lda     f:hHVBJOY
        and     #$40
        beq     @db53       ; branch if not in hblank
@db5b:  lda     f:hHVBJOY
        and     #$40
        bne     @db5b       ; branch if in hblank
; ************************
.endif

@db50:  lda     f:hSTAT78
        lda     f:hSLHV
        lda     f:hOPVCT
        cmp     [zAnimScriptPtr]
        bcc     @db50
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $f3: jump based on attacker ]

; +b1 = jump address if char 1 is attacker
; +b3 = jump address if char 2 is attacker
; +b5 = jump address if char 3 is attacker
; +b7 = jump address if char 4 is attacker
; +b9 = jump address if monster is attacker (any)

        array_label ANIM_CMD, $73
magic_code73:
@db64:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker number
        bra     _db72

; ------------------------------------------------------------------------------

; [ battle animation command $f0: jump based on target ]

        array_label ANIM_CMD, $70
magic_code70:
@db6c:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target number
_db72:  bmi     @db78       ; branch if a monster
        and     #$03
        bra     @db7a
@db78:  lda     #$04
@db7a:  longa
        asl
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ed: move along ??? vector ]

; re-calculates the vector from the current position every time
; used by grav bomb, cold dust

        array_label ANIM_CMD, $6d
magic_code6d:
@db8f:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x     ; thread x position, clamped to 255
        sta     $22
        and     #$0100
        beq     @dba1
        dec
        sta     $22
@dba1:  lda     near wAnimThread::ThreadPosY,x     ; thread y position, clamped to 255
        sta     $24
        and     #$0100
        beq     @dbae
        dec
        sta     $24
@dbae:  shorta0
        lda     $22
        sta     z7d
        lda     $24
        sta     z7e
        lda     near wAnimThread::TargetPosX,x     ; target x position
        sta     z7f
        lda     near wAnimThread::TargetPosY,x     ; target y position
        sta     z80
        jsr     CalcVec
        ldx     near wAnimThreadPtr
        lda     #$07
        sta     $24
        jsr     _c1e7ba
        lda     z85
        sec
        sbc     near wAnimThread::w7e74db,x     ; vector angle
        bmi     @dbe3
        lda     near wAnimThread::w7e74db,x
        clc
        adc     $22
        sta     near wAnimThread::w7e74db,x
        bra     @dbec
@dbe3:  lda     near wAnimThread::w7e74db,x     ; vector angle
        sec
        sbc     $22
        sta     near wAnimThread::w7e74db,x
@dbec:  lda     [zAnimScriptPtr]
        clc
        adc     #$04
        sta     $24
        ldx     near wAnimThreadPtr
        lda     z86
        cmp     $24
        bcs     @dc02
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts
@dc02:  lda     [zAnimScriptPtr]
        tay
        sty     $24
        lda     near wAnimThread::w7e74db,x     ; vector angle
        clc
        adc     #$40
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x     ; thread x position += +$28
        clc
        adc     $28
        sta     near wAnimThread::ThreadPosX,x
        shorta0
        ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        tay
        sty     $24
        lda     near wAnimThread::w7e74db,x
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosY,x     ; thread y position += +$28
        clc
        adc     $28
        sta     near wAnimThread::ThreadPosY,x
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
        shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ec: change thread layer ]

; b1: thread layer (0 = sprite, 1 = bg1, 2 = bg3)

        array_label ANIM_CMD, $6c
magic_code6c:
@dc55:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::LayerPriority,x     ; thread layer
        and     #$fc
        ora     [zAnimScriptPtr]
        sta     near wAnimThread::LayerPriority,x
        stz     near wAnimThread::LoopFrameOffset,x     ; clear frame offset
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $eb: jump based on thread index ]

;  +b1: jump address for thread 0
;  +b3: jump address for thread 1
;  +b5: jump address for thread 2
;  +b7: jump address for thread 3
;  +b9: jump address for thread 4
; +b11: jump address for thread 5
; +b13: jump address for thread 6
; +b15: jump address for thread 7

        array_label ANIM_CMD, $6b
magic_code6b:
@dc66:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::ThreadIndex,x     ; thread index
        longa
        asl
        sta     $22
        lda     zAnimScriptPtr         ; animation script pointer += thread index * 2
        clc
        adc     $22
        sta     zAnimScriptPtr
        lda     [zAnimScriptPtr]       ; jump address
        dec
        sta     zAnimScriptPtr         ; set new script pointer
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ea: set bg tile data location ]

; b1: 13--xxxx
;       1: affect bg1
;       3: affect bg3
;       x: tile data location (0 = top-left, 1 = top-right, 2 = bottom-left, 3 = bottom-right)
;          for bg1 only (4 = sketch, 5 = ???, 6 = top-left of bg3, 7 = top-right of bg3)

        array_label ANIM_CMD, $6a
magic_code6a:
@dc81:  lda     [zAnimScriptPtr]
        bpl     @dc8a
        and     #$0f
        sta     near w7e62c8       ; bg1 tile data quadrant
@dc8a:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @dc97
        lda     [zAnimScriptPtr]
        and     #$0f
        sta     near w7e62c9       ; bg3 tile data quadrant
@dc97:  ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e9: move randomly ]

; b1: x distance (mask)
; b2: y distance (mask)

        array_label ANIM_CMD, $69
magic_code69:
@dc9b:  jsr     Rand
        sta     $10
        jsr     Rand
        sta     $12
        ldx     near wAnimThreadPtr
        lda     $10
        and     [zAnimScriptPtr]
        sta     near wAnimThread::ThreadOffsetX,x     ; set x offset
        stz     near wAnimThread::ThreadOffsetX+1,x
        lda     near wAnimThread::w7e6f87,x     ; h flip
        beq     @dcc6       ; branch if not flipped
        longa
        lda     near wAnimThread::ThreadOffsetX,x     ; invert x offset
        neg_a
        sta     near wAnimThread::ThreadOffsetX,x
        shorta0
@dcc6:  ldy     #1
        lda     $12
        and     [zAnimScriptPtr],y
        sta     near wAnimThread::ThreadOffsetY,x     ; set y offset
        stz     near wAnimThread::ThreadOffsetY+1,x
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ef: move in flattened polar coordinates ]

; b1: radius
; b2: angle

        array_label ANIM_CMD, $6f
magic_code6f:
@dcd9:  lda     #$01
        sta     $1a
        bra     _dce1

; ------------------------------------------------------------------------------

; [ battle animation command $e8: move in polar coordinates ]

; b1: radius
; b2: angle

        array_label ANIM_CMD, $68
magic_code68:
@dcdf:  stz     $1a
_dce1:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e74d9,x     ; current vector position
        sta     $24
        lda     near wAnimThread::w7e74d8,x     ; vector angle
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::w7e6f87,x
        and     #$00ff
        beq     @dd03       ; branch if not mirrored
        lda     $22
        not_a
        sta     $22
@dd03:  lda     $22
        sta     near wAnimThread::ThreadOffsetX,x     ; x offset
        shorta0
        lda     $1a
        beq     @dd11       ; branch if not flattened
        lsr     $24
@dd11:  lda     near wAnimThread::w7e74d8,x     ; vector angle + $40
        clc
        adc     #$40
        jsr     CalcVecSine
        ldx     near wAnimThreadPtr
        longa
        lda     $22
        sta     near wAnimThread::ThreadOffsetY,x     ; y offset
        shorta0
        lda     near wAnimThread::w7e74d9,x     ; current vector position
        clc
        adc     [zAnimScriptPtr]
        sta     near wAnimThread::w7e74d9,x     ; current vector position
        ldy     #1
        lda     near wAnimThread::w7e74d8,x     ; vector angle
        clc
        adc     [zAnimScriptPtr],y
        sta     near wAnimThread::w7e74d8,x     ; vector angle
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e3: move monster back along vector ]

; b1: speed
; b2: number of bytes to branch backwards

        array_label ANIM_CMD, $63
magic_code63:
@dd42:  clr_a
        inc
        jsr     CalcMonsterVecPos
        ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $26
        stz     $27
        longa
        lda     near wAnimThread::w7e74d7,x
        sec
        sbc     $26
        sta     near wAnimThread::w7e74d7,x
        bpl     @dd6d
        lda     near wAnimThread::w7e64e8,x
        sta     near w7e80c3,y
        lda     near wAnimThread::w7e64ea,x
        sta     near w7e80cf,y
        inc     zAnimScriptPtr
        bra     @dd86
@dd6d:  lda     $14
        clc
        adc     $28
        sta     near w7e80cf,y
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@dd86:  shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e2: move monster forward along vector ]

; b1: speed
; b2: number of bytes to branch backwards

        array_label ANIM_CMD, $62
magic_code62:
@dd8d:  clr_a
        jsr     CalcMonsterVecPos
        ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $26
        stz     $27
        longa
        lda     near wAnimThread::w7e74d7,x
        sec
        sbc     $26
        sta     near wAnimThread::w7e74d7,x
        bpl     @ddb9
        lda     $14
        sta     near w7e80cf,y
        lda     near wAnimThread::w7e74d9,x
        and     #$00ff
        sta     near wAnimThread::w7e74d7,x
        inc     zAnimScriptPtr
        bra     @ddd2
@ddb9:  lda     $14
        clc
        adc     $28
        sta     near w7e80cf,y
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@ddd2:  shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ calculate monster vector position ]

CalcMonsterVecPos:
@ddd9:  pha
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x
        and     #$7f
        sec
        sbc     #$04
        asl
        tay
        sty     near wAttackerThreadPtr
        lda     [zAnimScriptPtr]
        longa
        sta     $26
        lda     near w7e80ab,y
        sta     $10
        lda     near w7e80b7,y
        sta     $12
        shorta0
        pla
        beq     @de05
        jsr     _c2defe
        bra     @de08
@de05:  jsr     _c2dfa0
@de08:  ldx     near wAnimThreadPtr
        lda     #$ff
        sta     f:hWRDIVL
        sta     f:hWRDIVH
        lda     near wAnimThread::w7e74d9,x
        sta     f:hWRDIVB
        ldy     near wAttackerThreadPtr
        longa
        lda     $10
        sta     near w7e80ab,y
        clc
        adc     near wAnimThread::w7e64e8,x
        sta     near w7e80c3,y
        lda     $12
        sta     near w7e80b7,y
        clc
        adc     near wAnimThread::w7e64ea,x
        pha
        sta     near w7e80cf,y
        lda     near wAnimThread::w7e74d7,x
        and     #$00ff
        sta     $22
        lda     f:hRDDIVL
        sta     $24
        jsr     Mult816
        shorta0
        ldx     #$0020
        stx     $24
        lda     $27
        lsr
        clc
        adc     #$80
        jsr     CalcSine16
        plx
        stx     $14
        ldy     near wAttackerThreadPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [  ]

; unused ???

@de66:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x
        and     #$7f
        sec
        sbc     #$04
        asl
        tay
        sty     near wAttackerThreadPtr
        lda     near wAnimThread::w7e74d9,x
        sta     $24
        lda     near wAnimThread::w7e74d9+1,x
        sta     $25
        lda     near wAnimThread::w7e74db,x
        clc
        adc     #$40
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        ldy     near wAttackerThreadPtr
        longa
        lda     $28
        clc
        adc     near wAnimThread::w7e64e8,x
        sta     near w7e80c3,y
        shorta0
        lda     near wAnimThread::w7e74db,x
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        lda     #$ff
        sta     f:hWRDIVL
        sta     f:hWRDIVH
        lda     near wAnimThread::w7e74dc+1,x
        beq     @deb9
        lda     #$ff
        bra     @debc
@deb9:  lda     near wAnimThread::w7e74dc,x
@debc:  sta     f:hWRDIVB
        ldy     near wAttackerThreadPtr
        lda     near wAnimThread::w7e74d9,x
        longa
        sta     $22
        lda     $28
        pha
        lda     f:hRDDIVL
        sta     $24
        jsr     Mult816
        shorta0
        ldx     #$0020
        stx     $24
        lda     $27
        lsr
        clc
        adc     #$80
        jsr     CalcSine16
        ldy     near wAttackerThreadPtr
        ldx     near wAnimThreadPtr
        longa
        pla
        clc
        adc     $28
        clc
        adc     near wAnimThread::w7e64ea,x
        sta     near w7e80cf,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2defe:
vec_line_set:
@defe:  lda     near wAnimThread::w7e74dc,x
        sta     $22
        lda     near wAnimThread::w7e74dc+1,x
        sta     $24
        stz     $23
        stz     $25
        stz     $29
        lda     $22
        cmp     $24
        bcc     @df5a
        ldy     $12
        lda     near wAnimThread::w7e74d9+1,x
        bmi     @df29
        longa
        lda     $10
        sec
        sbc     $26
        sta     $10
        shorta0
        bra     @df35
@df29:  longa
        lda     $10
        clc
        adc     $26
        sta     $10
        shorta0
@df35:  lda     near wAnimThread::w7e74db,x
        bmi     @df4a
        lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e07c
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $12
        rts
@df4a:  lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e099
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $12
        rts
@df5a:  ldy     $10
        lda     near wAnimThread::w7e74db,x
        bmi     @df6f
        longa
        lda     $12
        sec
        sbc     $26
        sta     $12
        shorta0
        bra     @df7b
@df6f:  longa
        lda     $12
        clc
        adc     $26
        sta     $12
        shorta0
@df7b:  lda     near wAnimThread::w7e74d9+1,x
        bmi     @df90
        lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e042
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $10
        rts
@df90:  lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e05f
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $10
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2dfa0:
vec_line_set_ret:
@dfa0:  lda     near wAnimThread::w7e74dc,x
        sta     $22
        lda     near wAnimThread::w7e74dc+1,x
        sta     $24
        stz     $23
        stz     $25
        stz     $29
        lda     $22
        cmp     $24
        bcc     @dffc
        ldy     $12
        lda     near wAnimThread::w7e74d9+1,x
        bmi     @dfcb
        longa
        lda     $10
        clc
        adc     $26
        sta     $10
        shorta0
        bra     @dfd7
@dfcb:  longa
        lda     $10
        sec
        sbc     $26
        sta     $10
        shorta0
@dfd7:  lda     near wAnimThread::w7e74db,x
        bmi     @dfec
        lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e099
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $12
        rts
@dfec:  lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e07c
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $12
        rts
@dffc:  ldy     $10
        lda     near wAnimThread::w7e74db,x
        bmi     @e011
        longa
        lda     $12
        clc
        adc     $26
        sta     $12
        shorta0
        bra     @e01d
@e011:  longa
        lda     $12
        sec
        sbc     $26
        sta     $12
        shorta0
@e01d:  lda     near wAnimThread::w7e74d9+1,x
        bmi     @e032
        lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e05f
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $10
        rts
@e032:  lda     near wAnimThread::w7e74d6,x
        sta     $28
        jsr     _c2e042
        lda     $28
        sta     near wAnimThread::w7e74d6,x
        sty     $10
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2e042:
x_dec:
@e042:  lda     $22
        beq     @e05e
        longa
@e048:  lda     $28
        clc
        adc     $22
        cmp     $24
        bcc     @e055
        sec
        sbc     $24
        dey
@e055:  sta     $28
        dec     $26
        bne     @e048
        shorta0
@e05e:  rts

; ------------------------------------------------------------------------------

; [  ]

_c2e05f:
x_inc:
@e05f:  lda     $22
        beq     @e07b
        longa
@e065:  lda     $28
        clc
        adc     $22
        cmp     $24
        bcc     @e072
        sec
        sbc     $24
        iny
@e072:  sta     $28
        dec     $26
        bne     @e065
        shorta0
@e07b:  rts

; ------------------------------------------------------------------------------

; [  ]

_c2e07c:
y_dec:
@e07c:  lda     $24
        beq     @e098
        longa
@e082:  lda     $28
        clc
        adc     $24
        cmp     $22
        bcc     @e08f
        sec
        sbc     $22
        dey
@e08f:  sta     $28
        dec     $26
        bne     @e082
        shorta0
@e098:  rts

; ------------------------------------------------------------------------------

; [  ]

_c2e099:
y_inc:
@e099:  lda     $24
        beq     @e0b5
        longa
@e09f:  lda     $28
        clc
        adc     $24
        cmp     $22
        bcc     @e0ac
        sec
        sbc     $22
        iny
@e0ac:  sta     $28
        dec     $26
        bne     @e09f
        shorta0
@e0b5:  rts

; ------------------------------------------------------------------------------

; [ calculate character vector position ]

CalcCharVecPos:
@e0b6:  pha
        jsr     GetAttackerThreadPtr
        lda     [zAnimScriptPtr]
        longa
        sta     $26
        lda     near wCharGfxData::OffsetX,y
        sta     $10
        lda     near wCharGfxData::OffsetY,y
        sta     $12
        shorta0
        pla
        beq     @e0d5
        jsr     _c2defe
        bra     @e0d8
@e0d5:  jsr     _c2dfa0
@e0d8:  ldx     near wAnimThreadPtr
        lda     #$ff
        sta     f:hWRDIVL
        sta     f:hWRDIVH
        lda     near wAnimThread::w7e74d9,x
        sta     f:hWRDIVB
        ldy     near wAttackerThreadPtr
        longa
        lda     near w7eebfa
        and     #$00ff
        beq     @e105
        lda     $10
        sta     near wCharGfxData::OffsetX,y
        lda     $12
        sta     near wCharGfxData::OffsetY,y
        bra     @e115
@e105:  lda     $10
        sta     near wCharGfxData::OffsetX,y
        sta     near wAnimThread::ThreadOffsetX,x
        lda     $12
        sta     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadOffsetY,x
@e115:  lda     near wAnimThread::w7e74d7,x
        and     #$00ff
        sta     $22
        lda     f:hRDDIVL
        sta     $24
        jsr     Mult816
        shorta0
        ldy     #2
        lda     [zAnimScriptPtr],y
        sta     $24
        stz     $25
        lda     $27
        lsr
        clc
        adc     #$80
        jsr     CalcSine16
        ldy     near wAttackerThreadPtr
        ldx     near wAnimThreadPtr
        longa
        lda     near w7eebfa
        and     #$00ff
        bne     @e154
        lda     near wAnimThread::ThreadOffsetY,x
        clc
        adc     $28
        sta     near wAnimThread::ThreadOffsetY,x
@e154:  lda     $28
        sta     near wCharGfxData::JumpOffset,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e5: move character forward along vector ]

; b1: speed
; b2: number of bytes to branch backwards
; b3: jump height

        array_label ANIM_CMD, $65
magic_code65:
@e15d:  clr_a
        jsr     CalcCharVecPos
        ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $26
        stz     $27
        jsr     GetAttackerThreadPtr
        longa
        lda     near wAnimThread::w7e74d7,x
        sec
        sbc     $26
        sta     near wAnimThread::w7e74d7,x
        bpl     @e19b
        lda     near w7eebfa
        and     #$00ff
        bne     @e188
        lda     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadOffsetY,x
@e188:  lda     near wAnimThread::w7e74d9,x
        and     #$00ff
        sta     near wAnimThread::w7e74d7,x
        clr_a
        sta     near wCharGfxData::JumpOffset,y
        inc     zAnimScriptPtr
        inc     zAnimScriptPtr
        bra     @e1ac
@e19b:  ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@e1ac:  shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e6: move character backward along vector ]

; b1: speed
; b2: number of bytes to branch backwards
; b3: jump height

        array_label ANIM_CMD, $66
magic_code66:
@e1b3:  clr_a
        inc
        jsr     CalcCharVecPos
        ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $26
        stz     $27
        jsr     GetAttackerThreadPtr
        longa
        lda     near wAnimThread::w7e74d7,x
        sec
        sbc     $26
        sta     near wAnimThread::w7e74d7,x
        bpl     @e1e4
        stz     near wAnimThread::ThreadOffsetY,x
        clr_a
        sta     near wCharGfxData::JumpOffset,y
        sta     near wCharGfxData::OffsetX,y
        sta     near wCharGfxData::OffsetY,y
        inc     zAnimScriptPtr
        inc     zAnimScriptPtr
        bra     @e1f5
@e1e4:  ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@e1f5:  shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ calculate vector from attacker to target ]

; ignore alignment from script header

_c2e1fc:
get_jmp_vect:
@e1fc:  ldx     near wAnimThreadPtr

; start at bottom-center of attacker
        lda     near wAnimThread::AttackerIndex,x
        bpl     @e219

; character attacker
        and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e800f,y
        sta     near w7e614c
        lda     near w7e8027,y
        sta     near w7e614d
        bra     @e229

; monster attacker
@e219:  and     #$03
        asl
        tay
        lda     near w7e8033,y
        sta     near w7e614c
        lda     near w7e8043,y
        sta     near w7e614d

; to bottom-center of target
@e229:  lda     near wAnimThread::TargetIndex,x
        bpl     @e246

; character target
        and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e800f,y
        sta     near w7e614e
        lda     near w7e8027,y
        clc
        adc     #$04
        sta     near w7e614f
        bra     @e259

; monster target
@e246:  and     #$03
        asl
        tay
        lda     near w7e8033,y
        sta     near w7e614e
        lda     near w7e8043,y
        clc
        adc     #$04
        sta     near w7e614f
@e259:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $e7: set vector from attacker to target ]

; use alignment from animation script header

        array_label ANIM_CMD, $67
magic_code67:
@e25a:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x     ; attacker x position
        sta     near w7e614c       ; vector x0
        lda     near wAnimThread::AttackerPosY,x     ; attacker y position
        sta     near w7e614d       ; vector y0
        lda     near wAnimThread::TargetPosX,x     ; target x position
        sta     near w7e614e       ; vector x1
        lda     near wMagitekModeEnabled
        and     #$ff
        beq     @e27e       ; branch if not in magitek mode
        lda     near wAnimThread::TargetPosY,x     ; target y position
        sec
        sbc     #$18
        bra     @e281
@e27e:  lda     near wAnimThread::TargetPosY,x     ; target y position
@e281:  sta     near w7e614f       ; vector y1
        bra     _e289

; ------------------------------------------------------------------------------

; [ battle animation command $e4: set vector from attacker to target (jump) ]

 ; ignore alignment from script header

        array_label ANIM_CMD, $64
magic_code64:
@e286:  jsr     _c2e1fc
_e289:  jsl     _c2dcc8
        ldx     near wAnimThreadPtr
        longa
        dec     zAnimScriptPtr
        lda     near w7e6150
        sta     near wAnimThread::w7e74d9+1,x
        lda     near w7e6152
        sta     near wAnimThread::w7e74dc,x
        shorta0
        lda     near w7e6152
        cmp     near w7e6153
        bcc     @e2b0
        lda     near w7e6152
        bra     @e2b3
@e2b0:  lda     near w7e6153
@e2b3:  sta     near wAnimThread::w7e74d7,x
        sta     near wAnimThread::w7e74d9,x
        stz     near wAnimThread::w7e74d6,x
        stz     near wAnimThread::w7e74d8,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $f1: show/hide target ]

; b1: m------s
;       m: 0 = characters affected, 1 = monsters affected
;       s: 0 = hide, 1 = show

        array_label ANIM_CMD, $71
magic_code71:
@e2c0:  jsr     GetAttackerThreadPtr
        lda     [zAnimScriptPtr]
        bpl     @e2f8       ;
        lda     near wAnimThread::TargetIndex,x     ; target
        bpl     @e324       ; return if a character
        and     #$0f
        sec
        sbc     #$04
        tax
        lda     f:BitOrTbl,x
        sta     $10
        lda     [zAnimScriptPtr]
        and     #$01
        beq     @e2e8
        lda     near w7e61ab
        ora     $10
        sta     near w7e61ab
        bra     @e324
@e2e8:  lda     $10
        not_a
        sta     $10
        lda     near w7e61ab
        and     $10
        sta     near w7e61ab
        bra     @e324
@e2f8:  lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @e324       ; return if a monster
        and     #$03
        tax
        lda     f:BitOrTbl,x   ; bit masks
        sta     $10
        lda     [zAnimScriptPtr]
        and     #$01
        beq     @e316       ;
        lda     near w7e61ac       ; show character
        ora     $10
        sta     near w7e61ac
        bra     @e324
@e316:  lda     $10
        not_a
        sta     $10
        lda     near w7e61ac       ; hide character
        and     $10
        sta     near w7e61ac
@e324:  ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e1: show/hide attacker ]

; b1: m------s
;     m: 0 = characters affected, 1 = monsters affected
;     s: 0 = hide, 1 = show

        array_label ANIM_CMD, $61
magic_code61:
@e328:  jsr     GetAttackerThreadPtr
        lda     [zAnimScriptPtr]
        bpl     @e360
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bpl     @e39c       ; return if a character
        and     #$0f
        sec
        sbc     #$04
        tax
        lda     f:BitOrTbl,x   ; bit mask
        sta     $10
        lda     [zAnimScriptPtr]
        and     #$01
        beq     @e350
        lda     near w7e61ab
        ora     $10
        sta     near w7e61ab
        bra     @e39c
@e350:  lda     $10
        not_a
        sta     $10
        lda     near w7e61ab
        and     $10
        sta     near w7e61ab
        bra     @e39c
@e360:  lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @e39c       ; return if a monster
        and     #$03
        tax
        lda     f:BitOrTbl,x   ; bit mask
        sta     $10
        lda     [zAnimScriptPtr]
        and     #$01
        beq     @e386       ;
        lda     near w7e61ac       ; characters shown
        ora     $10
        sta     near w7e61ac
        lda     near wCharGfxDataBuf::ActiveStatus4,y     ; status 4
        clrflg  STATUS4, HIDE
        sta     near wCharGfxDataBuf::ActiveStatus4,y
        bra     @e39c
@e386:  lda     $10
        not_a
        sta     $10
        lda     near w7e61ac
        and     $10
        sta     near w7e61ac
        lda     near wCharGfxDataBuf::ActiveStatus4,y
        setflg  STATUS4, HIDE
        sta     near wCharGfxDataBuf::ActiveStatus4,y
@e39c:  ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $e0:  ]

        array_label ANIM_CMD, $60
magic_code60:
@e3a0:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $22
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $24
        lda     near wAnimThread::w7e6f87,x
        and     #$01
        beq     @e3bc
        lda     $22
        neg_a
        sta     $22
@e3bc:  lda     near w7e6154
        clc
        adc     $22
        sta     near w7e6154
        lda     near w7e6155
        clc
        adc     $24
        sta     near w7e6155
        ldy     #2
        lda     near w7e6156
        clc
        adc     [zAnimScriptPtr],y
        sta     near w7e6156
        iny
        lda     near w7e6157
        clc
        adc     [zAnimScriptPtr],y
        sta     near w7e6157
        ldy     zAnimScriptPtr
        iny3
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $df: move triangle to target position ]

        array_label ANIM_CMD, $5f
magic_code5f:
@e3ec:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetPosX,x     ; target x position
        sta     near w7e6154       ; triangle x position
        lda     near wAnimThread::TargetPosY,x     ; target y position
        sta     near w7e6155       ; triangle y position
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $de: move triangle to attacker position ]

        array_label ANIM_CMD, $5e
magic_code5e:
@e401:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x     ; attacker x position
        sta     near w7e6154       ; triangle x position
        lda     near wAnimThread::AttackerPosY,x     ; attacker y position
        sta     near w7e6155       ; triangle y position
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $dd: init triangle ]

        array_label ANIM_CMD, $5d
magic_code5d:
@e416:  clr_ay
        lda     [zAnimScriptPtr]
        sta     near w7e6154       ; triangle x position
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e6155       ; triangle y position
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e6156       ; triangle diameter
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e6157       ; triangle rotation angle
        ldy     zAnimScriptPtr
        iny3
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $dc: update triangle (2d) ]

        array_label ANIM_CMD, $5c
magic_code5c:
@e43a:  lda     near w7e6156                   ; circle radius
        sta     $24

; set 1st vertex position
        lda     near w7e6157
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615b
        lda     near w7e6157
        clc
        adc     #64
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615c

; set 2nd vertex position
        lda     near w7e6157
        clc
        adc     #255 / 3
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615d
        lda     near w7e6157
        clc
        adc     #255 / 3 + 64
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615e

; set 3rd vertex position
        lda     near w7e6157
        clc
        adc     #255 * 2 / 3
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615f
        lda     near w7e6157
        clc
        adc     #255 * 2 / 3 + 64
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e6160

; update triangle
        jsr     UpdateTriangle_near
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $f6: update triangle (3d) ]

        array_label ANIM_CMD, $76
magic_code76:
@e4a2:  lda     near w7e6156
        sta     $24

; set 1st vertex position
        lda     near w7e6157
        not_a
        sta     $10
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615b
        lda     $10
        clc
        adc     #64
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615c


; set 2nd vertex position
        lda     $10
        clc
        adc     #80
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615d
        lda     $10
        clc
        adc     #80 + 64
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615e

; set 3rd vertex position
; note that this vertex goes backwards and it moves on an ellipse, not a circle
        lda     $10
        clc
        adc     #144
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e615f
        lda     $10
        clc
        adc     #74
        jsr     CalcSine8
        clc
        adc     #128
        sta     near w7e6160

; update triangle
        jsr     UpdateTriangle_near
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $db: branch if character needs to step back ]

; b1: number of bytes to branch forward in script

        array_label ANIM_CMD, $5b
magic_code5b:
@e509:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @e517       ; branch if a monster
        tay
        lda     near w7e61ae,y     ;
        beq     @e527
@e517:  lda     [zAnimScriptPtr]
        longa
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        shorta0
@e527:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $da:  ]

; w wind/spiraler

        array_label ANIM_CMD, $5a
magic_code5a:
@e528:  lda     near w7e5f9d
        sta     $24
        stz     $25
        lda     near w7e5f7d
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     $28
        clc
        adc     near w7e5f9d+1
        sta     near wAnimThread::ThreadOffsetX,x
        shorta0
        lda     near w7e5f8d
        sta     $24
        lda     near w7e5f6d
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     $28
        clc
        adc     near w7e5f8d+1
        sta     near wAnimThread::ThreadOffsetY,x
        lda     [zAnimScriptPtr]
        sta     $22
        inc     zAnimScriptPtr
        shorta0
        lda     near w7e5f7d
        clc
        adc     $22
        sta     near w7e5f7d
        lda     near w7e5f6d
        clc
        adc     $23
        sta     near w7e5f6d
        lda     near w7e5f9d
        clc
        adc     #$01
        cmp     #$40
        bcc     @e586
        lda     #$40
@e586:  sta     near w7e5f9d
        lsr
        sta     near w7e5f8d
        lda     near w7e5f9d+4
        inc     near w7e5f9d+4
        inc     near w7e5f9d+4
        asl2
        tay
        clr_ax
        shorti
        longa
@e59f:  lda     near wBG1ScrollData::_64,y
        sta     near w7e63b0,x
        iny2
        inx2
        bne     @e59f
        shorta0
        longi
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1e5b4:
clr_line_buf2:
@e5b4:  clr_ax
        longa
@e5b8:  sta     near w7e63b0,x
        inx2
        cpx     #$0100
        bne     @e5b8
        shorta
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ee:  ]

        array_label ANIM_CMD, $6e
magic_code6e:
@e5c5:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @e5de
        asl5
        tay
        lda     near wCharGfxData::LayerPriority,y
        and     #$cf
        ora     [zAnimScriptPtr]
        sta     near wCharGfxData::LayerPriority,y
        rts
@e5de:  and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80db+1,y
        and     #$cf
        ora     [zAnimScriptPtr]
        sta     near w7e80db+1,y
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d9: set attacker sprite tile priority ]

; b1: --oo----
;     o = sprite tile priority

        array_label ANIM_CMD, $59
magic_code59:
@e5f0:  jsr     GetAttackerThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wCharGfxData::LayerPriority,y     ; sprite tile priority
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d8:  ]

; used by bum rush

        array_label ANIM_CMD, $58
magic_code58:
@e5f9:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        tay
        stz     $10
        lda     near w7e7b10,y
        beq     @e609       ; branch if character is not facing right
        dec     $10
@e609:  lda     near wAnimThread::ThreadPosX+1,x     ; thread x position (high byte)
        sta     $24
        stz     $25
        lda     near wAnimThread::ThreadPosX,x     ; thread x position
        clc
        adc     #$40
        jsr     CalcSine16
        jsr     GetAttackerThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetX,x     ; thread x offset
        clc
        adc     $28
        sta     near wCharGfxData::OffsetX,y     ; character x offset
        lsr     $24
        shorta0
        lda     near wAnimThread::ThreadPosX,x     ; thread x position
        jsr     CalcSine16
        jsr     GetAttackerThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetY,x
        clc
        adc     $28
        sta     near wCharGfxData::OffsetY,y
        ldy     #2
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $24
        lda     [zAnimScriptPtr]
        sta     $22
        inc     zAnimScriptPtr
        inc     zAnimScriptPtr
        shorta0
        lda     near wAnimThread::ThreadPosX+1,x
        clc
        adc     $22
        bpl     @e65e
        clr_a
@e65e:  cmp     near wAnimThread::ThreadPosY,x
        bcc     @e672
        longa
        lda     zAnimScriptPtr
        clc
        adc     $24
        sta     zAnimScriptPtr
        shorta0
        lda     near wAnimThread::ThreadPosY,x
@e672:  sta     near wAnimThread::ThreadPosX+1,x
        lda     $10
        bne     @e683
        lda     near wAnimThread::ThreadPosX,x
        sec
        sbc     $23
        sta     near wAnimThread::ThreadPosX,x
        rts
@e683:  lda     near wAnimThread::ThreadPosX,x
        clc
        adc     $23
        sta     near wAnimThread::ThreadPosX,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d7: update fire dance sprites ]

; b1: movement magnitude

        array_label ANIM_CMD, $57
magic_code57:
@e68d:  lda     [zAnimScriptPtr]
        sta     $24
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e74d8,x     ; vector angle
        jsr     CalcVecSine
        longa
        ldx     near wAnimThreadPtr
        lda     $22
        sta     near wAnimThread::ThreadOffsetX,x     ; thread x offset
        shorta0
        lda     near wAnimThread::w7e74d9,x     ; current vector position
        jsr     CalcVecSine
        longa
        ldx     near wAnimThreadPtr
        lda     $22
        sta     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        shorta0
        lda     near wAnimThread::w7e74d8,x     ; add 4 to vector angle
        clc
        adc     #$04
        sta     near wAnimThread::w7e74d8,x
        lda     near wAnimThread::w7e74d9,x     ; add 6 to vector position
        clc
        adc     #$06
        sta     near wAnimThread::w7e74d9,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d6: scroll background ]

; b1: horizontal scroll
; b2: vertical scroll

        array_label ANIM_CMD, $56
magic_code56:
@e6cd:  ldx     near wAnimThreadPtr
        clr_ay
        lda     [zAnimScriptPtr]
        sta     $10
        iny
        lda     [zAnimScriptPtr],y
        sta     $12
        lda     near wAnimThread::w7e6f87,x
        beq     @e6e7       ; branch if not mirrored
        lda     $10
        neg_a
        sta     $10
@e6e7:  longa
        clr_ay
@e6eb:  lda     $10
        sta     near w7e6330::Horz,y     ; bg2 scroll hdma table buffer (horizontal)
        lda     $12
        sta     near w7e6330::Vert,y     ; bg2 scroll hdma table buffer (vertical)
        iny4
        cpy     #$0080
        bne     @e6eb
        inc     zAnimScriptPtr
        shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d5: flip target monster ]

; b1: ------vh
;       v: flip vertical
;       h: flip horizontal

        array_label ANIM_CMD, $55
magic_code55:
@e707:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bpl     @e721
        and     #$0f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80f3,y
        eor     [zAnimScriptPtr]
        eor     near w7e617e,y
        sta     near w7e80f3,y
@e721:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $d4: set color math HDMA ]

        array_label ANIM_CMD, $54
magic_code54:
@e722:  ldy     #1
        lda     [zAnimScriptPtr]
        sta     $10
        lda     [zAnimScriptPtr],y
        sta     $11
        iny
        lda     [zAnimScriptPtr],y                 ; main screen layers
        jsr     SetColorMathHDMA
        ldx     near wAnimThreadPtr
        ldy     zAnimScriptPtr
        iny2
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d1: change draw order update frequency ]

; b1: 0 = update every frame, 1 = static

        array_label ANIM_CMD, $51
magic_code51:
@e73d:  lda     [zAnimScriptPtr]
        sta     near wStaticDrawOrder
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d0: set sprite tile priority for all characters/monsters ]

; b1: --oo----
;     o = tile priority

        array_label ANIM_CMD, $50
magic_code50:
@e746:  lda     [zAnimScriptPtr]
        sta     near wCharGfxData::_0::LayerPriority
        sta     near wCharGfxData::_1::LayerPriority
        sta     near wCharGfxData::_2::LayerPriority
        sta     near wCharGfxData::_3::LayerPriority
        clr_ay
        lda     [zAnimScriptPtr]
        ora     #$01
@e75a:  sta     near w7e80db+1,y
        iny2
        cpy     #$000c
        bne     @e75a
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1e768:
clr_bunsin_buf:
@e768:  clr_ay
        longa
@e76c:  sta     near w7e62d6,y
        iny2
        cpy     #$0040
        bne     @e76c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $cb: enable/disable echo sprites ]

; b1 = eddddddd
;      e: 1 = enable, 0 = disable
;      d: frame delay between echo sprites

        array_label ANIM_CMD, $4b
magic_code4b:
@e779:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @e797       ; return if a monster
        sta     near w7e62d3       ; set echo sprite character
        lda     [zAnimScriptPtr]
        and     #$7f
        sta     near w7e62d5       ; echo sprite frame delay
        lda     [zAnimScriptPtr]
        and     #$80
        sta     near w7e62d4
        bne     @e797
        jsr     _c1e768
@e797:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $ca: set character action animation speed ]

; used by quadra-slam, quadra-slice
;   0: normal speed
;   1: double speed

        array_label ANIM_CMD, $4a
magic_code4a:
@e798:  jsr     GetAttackerThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wCharGfxData::w7e61d0,y     ;
        rts

; ------------------------------------------------------------------------------

; [ get pointer to attacker animation thread data ]

GetAttackerThreadPtr:
@e7a1:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        asl5
        tay
        sty     near wAttackerThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c8: set secondary attacker action ]

; b1: action index

        array_label ANIM_CMD, $48
magic_code48:
@e7b1:  jsr     GetAttackerThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wCharGfxData::AnimAction,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1e7ba:
get_margin_size:
@e7ba:  lda     z85         ; angle
        sec
        sbc     near wAnimThread::w7e74db,x     ; current vector angle
        bmi     @e7cc
@e7c2:  cmp     near w7e60af
        bcc     @e7d1
        lda     near w7e60af       ;
        bra     @e7d1
@e7cc:  neg_a
        bra     @e7c2
@e7d1:  sta     $22
        lda     near w7e60af
        cmp     #$10
        bcs     @e7e7
        inc     near w7e60b0
        lda     near w7e60b0
        and     $24
        bne     @e7e7
        inc     near w7e60af
@e7e7:  rts

; ------------------------------------------------------------------------------

; [ calculate vector from attacking character to target ]

CalcCharAttackVec:
@e7e8:  jsr     GetAttackerThreadPtr
        longa
        lda     near wCharGfxData::PosX,y     ; character x position
        clc
        adc     near wCharGfxData::OffsetX,y     ; character x offset
        clc
        adc     near wCharGfxData::AnimOffsetX,y     ; character x offset
        sta     $22
        lda     near wCharGfxData::PosY,y     ; character y position
        clc
        adc     near wCharGfxData::OffsetY,y     ; character y offset
        sta     $24
        shorta0
        lda     $23
        and     #$01
        beq     @e810
        lda     #$ff
        bra     @e812
@e810:  lda     $22
@e812:  sta     z7d
        lda     $25
        and     #$01
        beq     @e81e
        lda     #$ff
        bra     @e820
@e81e:  lda     $24
@e820:  sta     z7e
        lda     near wAnimThread::TargetPosX,x     ; target x position
        sta     z7f
        lda     near wAnimThread::TargetPosY,x     ; target y position
        sta     z80
        jsr     CalcVec
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c6:  ]

        array_label ANIM_CMD, $46
magic_code46:
@e830:  jsr     CalcCharAttackVec
        ldx     near wAnimThreadPtr
        lda     #$03
        sta     $24
        jsr     _c1e7ba
        lda     z85         ; angle
        sec
        sbc     near wAnimThread::w7e74db,x     ; current vector angle
        bmi     @e850
        lda     near wAnimThread::w7e74db,x
        clc
        adc     $22
        sta     near wAnimThread::w7e74db,x
        bra     @e859
@e850:  lda     near wAnimThread::w7e74db,x
        sec
        sbc     $22
        sta     near wAnimThread::w7e74db,x
@e859:  lda     [zAnimScriptPtr]
        clc
        adc     #$04
        sta     $24
        ldx     near wAnimThreadPtr
        lda     z86
        cmp     $24
        bcs     @e86f
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts
@e86f:  lda     [zAnimScriptPtr]
        tay
        sty     $24
        lda     near wAnimThread::w7e74db,x
        clc
        adc     #$40
        jsr     CalcSine16
        ldx     near wAttackerThreadPtr
        longa
        lda     near wCharGfxData::OffsetX,x
        clc
        adc     $28
        sta     near wCharGfxData::OffsetX,x
        clc
        adc     near wCharGfxData::PosX,x
        clc
        adc     near wCharGfxData::AnimOffsetX,x
        and     #$01ff
        tax
        shorta0
        cpx     #$0010
        bcc     @e8a4
        cpx     #$00f0
        bcc     @e8a9
@e8a4:  lda     #$ff
        sta     near w7e60af
@e8a9:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        tay
        sty     $24
        lda     near wAnimThread::w7e74db,x
        jsr     CalcSine16
        ldx     near wAttackerThreadPtr
        longa
        lda     near wCharGfxData::OffsetY,x
        clc
        adc     $28
        sta     near wCharGfxData::OffsetY,x
        clc
        adc     near wCharGfxData::PosY,x
        and     #$01ff
        sta     $28
        tax
        shorta0
        cpx     #$0010
        bcc     @e8dc
        cpx     #$00f0
        bcc     @e8e1
@e8dc:  lda     #$ff
        sta     near w7e60af
@e8e1:  longa
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
        shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c5: jump based on swdtech hit ]

        array_label ANIM_CMD, $45
magic_code45:
@e8fb:  ldx     near wAnimThreadPtr
        lda     near w7e60ae       ; swdtech hit index
        longa
        asl
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr
        shorta0
        inc     near w7e60ae       ; increment swdtech hit index
        rts

; ------------------------------------------------------------------------------

; [ calculate thread vector position ]

CalcThreadVecPos:
@e919:  lda     near wAnimThread::w7e74d9,x     ; +$24 = current vector position
        sta     $24
        lda     near wAnimThread::w7e74d9+1,x
        sta     $25
        lda     near wAnimThread::w7e74db,x     ; vector angle
        clc
        adc     #$40
        jsr     CalcSine16
        jsr     GetAttackerThreadPtr
        longa
        lda     $28
        sta     near wCharGfxData::OffsetX,y
        sta     near wAnimThread::ThreadOffsetX,x
        shorta0
        lda     near wAnimThread::w7e74db,x
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        lda     #$ff
        sta     f:hWRDIVL
        sta     f:hWRDIVH
        lda     near wAnimThread::w7e74dc+1,x
        beq     @e958
        lda     #$ff
        bra     @e95b
@e958:  lda     near wAnimThread::w7e74dc,x
@e95b:  sta     f:hWRDIVB
        ldy     near wAttackerThreadPtr
        lda     near wAnimThread::w7e74d9,x
        longa
        sta     $22
        lda     $28
        sta     near wCharGfxData::OffsetY,y
        sta     near wAnimThread::ThreadOffsetY,x
        lda     f:hRDDIVL
        sta     $24
        jsr     Mult816
        shorta0
        ldx     #$0020
        stx     $24
        lda     $27
        lsr
        clc
        adc     #$80
        jsr     CalcSine16
        ldy     near wAttackerThreadPtr
        ldx     near wAnimThreadPtr
        longa
        lda     $28
        sta     near wCharGfxData::JumpOffset,y
        shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c4: move bg1/bg3 thread to this thread's position ]

; b1: ab------
;       a: affect bg1
;       b: affect bg3

        array_label ANIM_CMD, $44
magic_code44:
@e99f:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        bpl     @e9c5       ; branch if not affecting bg1
        longa
        lda     near wAnimThread::ThreadPosX,x     ; thread x position
        clc
        adc     near wAnimThread::ThreadOffsetX,x     ; add thread x offset
        sta     near w7e7b1d       ; set bg1 animation x position
        sta     near w7e7b16       ; set bg1 animation x offset
        lda     near wAnimThread::ThreadPosY,x     ; thread y position
        clc
        adc     near wAnimThread::ThreadOffsetY,x     ; add thread y offset
        sta     near w7e7b1f       ; set bg1 animation y position
        sta     near w7e7b18       ; set bg1 animation y offset
        shorta0
@e9c5:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @e9ea       ; return if not affecting bg3
        longa
        lda     near wAnimThread::ThreadPosX,x
        clc
        adc     near wAnimThread::ThreadOffsetX,x
        sta     near w7e7b29
        sta     near w7e7b22
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     near wAnimThread::ThreadOffsetY,x
        sta     near w7e7b2b
        sta     near w7e7b24
        shorta0
@e9ea:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $c2: unpause animation ]

; b1 = 13s-----
;      1: unpause bg1 animation
;      3: unpause bg3 animation
;      s: unpause sprite animation

        array_label ANIM_CMD, $42
magic_code42:
@e9eb:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        bpl     @e9f5
        stz     near w7e60ac       ; unpause bg1 animation threads
@e9f5:  and     #$40
        beq     @e9fc
        stz     near w7e60ad       ; unpause bg3 animation threads
@e9fc:  lda     [zAnimScriptPtr]
        and     #$20
        beq     @ea04
        stz     z99         ; unpause sprite animation threads
@ea04:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $c1:  ]

        array_label ANIM_CMD, $41
magic_code41:
@ea05:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::w7e74d8,x     ; vector movement speed
        jsr     MoveThreadToVec
        longa
        lda     near wAnimThread::w7e74d8,x
        and     #$00ff
        sta     $22
        lda     near wAnimThread::w7e74d9,x
        clc
        adc     $22
        sta     near wAnimThread::w7e74d9,x
        cmp     #$00f0
        bcs     @ea5d
        cmp     near wAnimThread::w7e74dc,x
        bcc     @ea61
        lda     #$00f0
        sta     near wAnimThread::w7e74dc,x
        stz     near wAnimThread::w7e74d9,x
        lda     near wAnimThread::ThreadPosX,x
        clc
        adc     near wAnimThread::ThreadOffsetX,x
        sta     near wAnimThread::ThreadPosX,x
        stz     near wAnimThread::ThreadOffsetX,x
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     near wAnimThread::ThreadOffsetY,x
        sta     near wAnimThread::ThreadPosY,x
        stz     near wAnimThread::ThreadOffsetY,x
        shorta
        lda     near wAnimThread::w7e74db,x
        clc
        adc     #$18
        sta     near wAnimThread::w7e74db,x
        longa
@ea5d:  inc     zAnimScriptPtr
        bra     @ea72
@ea61:  ldy     #1
        lda     [zAnimScriptPtr],y     ; branch backwards
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@ea72:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $c0: return from subroutine ]

        array_label ANIM_CMD, $40
magic_code40:
@ea76:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::SubReturnPtr,x
        inc
        sta     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $bf: jump to subroutine ]

; +b1: subroutine address

        array_label ANIM_CMD, $3f
magic_code3f:
@ea85:  ldx     near wAnimThreadPtr
        longa
        lda     zAnimScriptPtr
        sta     near wAnimThread::SubReturnPtr,x
        lda     [zAnimScriptPtr]
        dec
        sta     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $be: set screen mosaic ]

; b1: mmmm4321 ($2106)
;       m: mosaic size
;       4321: affect bg1/2/3/4

        array_label ANIM_CMD, $3e
magic_code3e:
@ea98:  lda     [zAnimScriptPtr]
        sta     near w7e8970       ; screen mosaic register for battlefield region -> $2106
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $bd: hide/show bg1/bg3 animation thread graphics ]

; b1: abcd----
;       a: affect bg1
;       b: affect bg3
;       c: bg1 (0 = show, 1 = hide)
;       d: bg3 (0 = show, 1 = hide)

        array_label ANIM_CMD, $3d
magic_code3d:
@eaa1:  lda     [zAnimScriptPtr]
        bpl     @eaaa       ; branch if not affecting bg1
        and     #$20
        sta     near w7e60a7       ; hide/show bg1 graphics
@eaaa:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @eab7       ; branch if not affecting bg3
        lda     [zAnimScriptPtr]
        and     #$10
        sta     near w7e60a8       ; hide/show bg3 graphics
@eab7:  ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ init color inc/dec ]

;    +X: pointer to RGB color modification values
; [$5b]: rgbmcccc
;          r: affect red components
;          g: affect green components
;          b: affect blue components
;          m: add if 0, subtract if 1
;          c: amount to subtract from each color (intensity)

_c1eabb:
get_col_offset_main:
@eabb:  stx     $1a
        clr_ay
        lda     [zAnimScriptPtr]                   ; find the first affected component
@eac1:  asl
        bcs     @eaca
        iny
        cpy     #3
        bne     @eac1                   ; this will glitch if no bits are set
@eaca:  lda     ($1a),y
        and     #$1f
        sta     $10                     ; $10 holds the previous value
        lda     [zAnimScriptPtr]
        and     #$10
        beq     @eaeb

; subtract component
        lda     [zAnimScriptPtr]                   ; amount to subtract
        and     #$0f
        sta     $22
        lda     $10
        sec
        sbc     $22
        sta     $10
        and     #$e0
        beq     @eafc
        stz     $10                     ; clamp to 0
        bra     @eafc

; add component
@eaeb:  lda     [zAnimScriptPtr]                   ; amount to add
        and     #$0f
        clc
        adc     $10
        sta     $10
        and     #$e0
        beq     @eafc
        lda     #$1f                    ; clamp to 31
        sta     $10

; copy affected components
@eafc:  lda     [zAnimScriptPtr]
        and     #$e0
        sta     $12

; red component
        lda     [zAnimScriptPtr]
        bmi     @eb0a
        lda     ($1a)
        bra     @eb0e
@eb0a:  lda     $10
        sta     ($1a)
@eb0e:  sta     $14

; green component
        ldy     #1
        lda     [zAnimScriptPtr]
        and     #$40
        bne     @eb1d
        lda     ($1a),y
        bra     @eb21
@eb1d:  lda     $10
        sta     ($1a),y
@eb21:  sta     $16

; blue component
        iny
        lda     [zAnimScriptPtr]
        and     #$20
        bne     @eb2e
        lda     ($1a),y
        bra     @eb32
@eb2e:  lda     $10
        sta     ($1a),y
@eb32:  sta     $18
        rts

; ------------------------------------------------------------------------------

; [ increment color palette ]

IncPal:
@eb35:  stz     $15
        stz     $13
        longa
        ldx     $10
        jsr     InitColorMod
@eb40:  lda     near w7e7c00,x
        jsr     IncColor
        sta     near w7e7e00,x
        inx2
        dec     $12
        bne     @eb40
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ decrement color palette ]

; +$10: first color offset
; +$12: number of colors to decrement
; +$14: value to subtract from red component
; +$16: value to subtract from red component
; +$18: value to subtract from red component

DecPal:
@eb53:  stz     $15
        stz     $13
        longa
        ldx     $10
        jsr     InitColorMod
@eb5e:  lda     near w7e7c00,x
        jsr     DecColor
        sta     near w7e7e00,x
        inx2
        dec     $12
        bne     @eb5e
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init color offset ]

;    +X: pointer to RGB color modification values
; [$5b]: rgbccccc
;          r: affect red components
;          g: affect green components
;          b: affect blue components
;          c: color offset

_c1eb71:
color_offset_init:
@eb71:  stx     $1a
        clr_ay
        sta     ($1a)
        iny
        sta     ($1a),y
        iny
        sta     ($1a),y
        stz     $14
        stz     $16
        stz     $18
        lda     [zAnimScriptPtr]
        and     #$1f

; red component
        sta     $10
        lda     [zAnimScriptPtr]
        bpl     @eb93
        lda     $10
        sta     $14
        sta     ($1a)

; green component
@eb93:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @eba2
        lda     $10
        sta     $16
        ldy     #1
        sta     ($1a),y

; blue component
@eba2:  lda     [zAnimScriptPtr]
        and     #$20
        beq     @ebb1
        lda     $10
        sta     $18
        ldy     #2
        sta     ($1a),y
@ebb1:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $b5: set battle bg palette addition (relative) ]

        array_label ANIM_CMD, $35
magic_code35:
@ebb2:  ldx     #near w7e88bf::_1
        jsr     _c1eabb
        jmp     _ebca

; ------------------------------------------------------------------------------

; [ battle animation command $b6: set battle bg palette subtraction (relative) ]

        array_label ANIM_CMD, $36
magic_code36:
@ebbb:  ldx     #near w7e88bf::_1
        jsr     _c1eabb
        jmp     _ebe0

; ------------------------------------------------------------------------------

; [ battle animation command $b0: set battle bg palette addition (absolute) ]

        array_label ANIM_CMD, $30
magic_code30:
@ebc4:  ldx     #near w7e88bf::_1
        jsr     _c1eb71
_ebca:  ldx     #array_offset w7e7e00, 5
        stx     $10
        lda     #16 * 3                 ; affect 48 colors
        sta     $12
        jsr     IncPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $af: set battle bg palette subtraction (absolute) ]

        array_label ANIM_CMD, $2f
magic_code2f:
@ebda:  ldx     #near w7e88bf::_1
        jsr     _c1eb71

; subtract from battle bg palettes
magic_code2f_x:
_ebe0:  ldx     #array_offset w7e7e00, 5
        stx     $10
        lda     #16 * 3                 ; affect 48 colors
        sta     $12
        jsr     DecPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ce: decrement bg1 animation palette ]

        array_label ANIM_CMD, $4e
magic_code4e:
@ebf0:  ldx     #near w7e88bf::_2
        jsr     _c1eabb
        jmp     _ec08

; ------------------------------------------------------------------------------

; [ battle animation command $cf: set bg1 animation palette addition (relative) ]

        array_label ANIM_CMD, $4f
magic_code4f:
@ebf9:  ldx     #near w7e88bf::_2
        jsr     _c1eabb
        jmp     _ec2a

; ------------------------------------------------------------------------------

; [ battle animation command $cd: set bg1 animation palette addition (absolute) ]

        array_label ANIM_CMD, $4d
magic_code4d:
@ec02:  ldx     #near w7e88bf::_2
        jsr     _c1eb71
_ec08:  ldx     #array_offset w7e7e00, 3
        stx     $10
        lda     #16                     ; affect 16 colors
        sta     $12
        jsr     IncPal
        ldx     #array_offset w7e7e00, 4
        stx     $10
        lda     #8                      ; affect 8 colors
        sta     $12
        jsr     IncPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $cc: set bg1 animation palette subtraction (absolute) ]

        array_label ANIM_CMD, $4c
magic_code4c:
@ec24:  ldx     #near w7e88bf::_2
        jsr     _c1eb71
_ec2a:  ldx     #array_offset w7e7e00, 3
        stx     $10
        lda     #16                     ; affect 16 colors
        sta     $12
        jsr     DecPal
        ldx     #array_offset w7e7e00, 4
        stx     $10
        lda     #8                      ; affect 8 colors
        sta     $12
        jsr     DecPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $b4: set bg3 animation palette subtraction (relative) ]

        array_label ANIM_CMD, $34
magic_code34:
@ec46:  ldx     #near w7e88bf::_0
        jsr     _c1eabb
        jmp     _ec74

; ------------------------------------------------------------------------------

; [ battle animation command $b3: set bg3 animation palette addition (relative) ]

        array_label ANIM_CMD, $33
magic_code33:
@ec4f:  ldx     #near w7e88bf::_0
        jsr     _c1eabb
        jmp     _ec5e

; ------------------------------------------------------------------------------

; [ battle animation command $ab: set bg3 animation palette addition (absolute) ]

        array_label ANIM_CMD, $2b
magic_code2b:
@ec58:  ldx     #near w7e88bf::_0
        jsr     _c1eb71
_ec5e:  ldx     #array_offset w7e7e00, 1
        stx     $10
        lda     #4                      ; affect 4 colors
        sta     $12
        jsr     IncPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $aa: set bg3 animation palette subtraction (absolute) ]

        array_label ANIM_CMD, $2a
magic_code2a:
@ec6e:  ldx     #near w7e88bf::_0
        jsr     _c1eb71
_ec74:  ldx     #array_offset w7e7e00, 1
        stx     $10
        lda     #4                      ; affect 4 colors
        sta     $12
        jsr     DecPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $b7: set sprite animation palette addition (relative) ]

        array_label ANIM_CMD, $37
magic_code37:
@ec84:  ldx     #near w7e88bf::_3
        jsr     _c1eabb
        jmp     _ec9c

; ------------------------------------------------------------------------------

; [ battle animation command $b8: set sprite animation palette subtraction (relative) ]

        array_label ANIM_CMD, $38
magic_code38:
@ec8d:  ldx     #near w7e88bf::_3
        jsr     _c1eabb
        jmp     _ecb2

; ------------------------------------------------------------------------------

; [ battle animation command $b2: set sprite animation palette addition (absolute) ]

        array_label ANIM_CMD, $32
magic_code32:
@ec96:  ldx     #near w7e88bf::_3
        jsr     _c1eb71
_ec9c:  ldx     #array_offset w7e7e00, 11
        stx     $10
        lda     #16                     ; affect 16 colors
        sta     $12
        jsr     IncPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $b1: set sprite animation palette subtraction (absolute) ]

        array_label ANIM_CMD, $31
magic_code31:
@ecac:  ldx     #near w7e88bf::_3
        jsr     _c1eb71
_ecb2:  ldx     #array_offset w7e7e00, 11
        stx     $10
        lda     #16                     ; affect 16 colors
        sta     $12
        jsr     DecPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $bc: set monster palette subtraction (relative) ]

        array_label ANIM_CMD, $3c
magic_code3c:
@ecc2:  ldx     #near w7e88bf::_4
        jsr     _c1eabb
        jmp     _ecf0

; ------------------------------------------------------------------------------

; [ battle animation command $bb: set monster palette addition (relative) ]

        array_label ANIM_CMD, $3b
magic_code3b:
@eccb:  ldx     #near w7e88bf::_4
        jsr     _c1eabb
        jmp     _ecda

; ------------------------------------------------------------------------------

; [ battle animation command $ba: set monster palette addition (absolute) ]

        array_label ANIM_CMD, $3a
magic_code3a:
@ecd4:  ldx     #near w7e88bf::_4
        jsr     _c1eb71
_ecda:  lda     #16 * 3                 ; affect 48 colors
        sta     $12
        ldx     #array_offset w7e7e00, 8
        stx     $10
        jsr     IncPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $b9: set monster palette subtraction (absolute) ]

        array_label ANIM_CMD, $39
magic_code39:
@ecea:  ldx     #near w7e88bf::_4
        jsr     _c1eb71
_ecf0:  lda     #16 * 3                 ; affect 48 colors
        sta     $12
        ldx     #array_offset w7e7e00, 8
        stx     $10
        jsr     DecPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $fd: set character palette addition (relative) ]

        array_label ANIM_CMD, $7d
magic_code7d:
@ed00:  ldx     #near w7e88bf::_5
        jsr     _c1eabb
        jmp     _ed18

; ------------------------------------------------------------------------------

; [ battle animation command $fe: set character palette subtraction (relative) ]

        array_label ANIM_CMD, $7e
magic_code7e:
@ed09:  ldx     #near w7e88bf::_5
        jsr     _c1eabb
        jmp     _ed52

; ------------------------------------------------------------------------------

; [ battle animation command $fc: set character palette addition (absolute) ]

        array_label ANIM_CMD, $7c
magic_code7c:
@ed12:  ldx     #near w7e88bf::_5
        jsr     _c1eb71
_ed18:  lda     #16                     ; affect 16 colors
        sta     $12
        ldx     #array_offset w7e7e00, 12
        stx     $10
        jsr     IncPal
        lda     #16                     ; affect 16 colors
        sta     $12
        ldx     #array_offset w7e7e00, 13
        stx     $10
        jsr     IncPal
        lda     #16                     ; affect 16 colors
        sta     $12
        ldx     #array_offset w7e7e00, 14
        stx     $10
        jsr     IncPal
        lda     #16                     ; affect 16 colors
        sta     $12
        ldx     #array_offset w7e7e00, 15
        stx     $10
        jsr     IncPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $fb: set character palette subtraction (absolute) ]

        array_label ANIM_CMD, $7b
magic_code7b:
@ed4c:  ldx     #near w7e88bf::_5
        jsr     _c1eb71
_ed52:  lda     #12                     ; affect 12 colors
        sta     $12
        ldx     #array_offset w7e7e00, 12
        stx     $10
        jsr     DecPal
        lda     #12                     ; affect 12 colors
        sta     $12
        ldx     #array_offset w7e7e00, 13
        stx     $10
        jsr     DecPal
        lda     #12                     ; affect 12 colors
        sta     $12
        ldx     #array_offset w7e7e00, 14
        stx     $10
        jsr     DecPal
        lda     #12                     ; affect 12 colors
        sta     $12
        ldx     #array_offset w7e7e00, 15
        stx     $10
        jsr     DecPal
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ae: update bg scroll hdma ]

; b1: vh---123
;       v: affect vertical scroll hdma
;       h: affect horizontal scroll hdma
;       1: affect BG1
;       2: affect BG2
;       3: affect BG3

        array_label ANIM_CMD, $2e
magic_code2e:

; affect bg1
@ed86:  lda     [zAnimScriptPtr]
        and     #$04
        beq     @edd8

; bg1 vertical
        lda     [zAnimScriptPtr]
        bpl     @edb1
        lda     near w7e6096
        sta     $24
        lda     near w7e609a                 ; this has no effect (6 places)
        sta     $14
        lda     near w7e6098
        sta     $16
        ldx     #near w7e63b0::Vert
        stx     $10
        jsr     _c1ef34
        lda     near w7e6098
        clc
        adc     near w7e609a
        sta     near w7e6098

; bg1 horizontal
@edb1:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @edd8
        lda     near w7e6095
        sta     $24
        lda     near w7e6099
        sta     $14
        lda     near w7e6097
        sta     $16
        ldx     #near w7e63b0::Horz
        stx     $10
        jsr     _c1ef34
        lda     near w7e6097
        clc
        adc     near w7e6099
        sta     near w7e6097

; affect bg2
@edd8:  lda     [zAnimScriptPtr]
        and     #$02
        beq     @ee2a

; bg2 vertical
        lda     [zAnimScriptPtr]
        bpl     @ee03
        lda     near w7e609c
        sta     $24
        lda     near w7e60a0
        sta     $14
        lda     near w7e609e
        sta     $16
        ldx     #near w7e6330::Vert
        stx     $10
        jsr     _c1ef34
        lda     near w7e609e
        clc
        adc     near w7e60a0
        sta     near w7e609e

; bg2 horizontal
@ee03:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @ee2a
        lda     near w7e609b
        sta     $24
        lda     near w7e609f
        sta     $14
        lda     near w7e609d
        sta     $16
        ldx     #near w7e6330::Horz
        stx     $10
        jsr     _c1ef34
        lda     near w7e609d
        clc
        adc     near w7e609f
        sta     near w7e609d

; affect bg3
@ee2a:  lda     [zAnimScriptPtr]
        and     #$01
        beq     @ee98

; bg3 vertical
        lda     [zAnimScriptPtr]
        bpl     @ee63
        lda     near w7e60a2
        sta     $24
        lda     near w7e60a6
        sta     $14
        lda     near w7e60a4
        sta     $16
        ldx     #near wBG3ScrollData::Vert
        stx     $10
        longa
        lda     near w7e7b24                 ; include y position and offset
        sec
        sbc     near w7e7b2b
        sta     $18
        shorta0
        jsr     _c1ef6a
        lda     near w7e60a4
        clc
        adc     near w7e60a6
        sta     near w7e60a4

; bg3 horizontal
@ee63:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @ee98
        lda     near w7e60a1
        sta     $24
        lda     near w7e60a5
        sta     $14
        lda     near w7e60a3
        sta     $16
        ldx     #near wBG3ScrollData::Horz
        stx     $10
        longa
        lda     near w7e7b22                 ; include x position and offset
        sec
        sbc     near w7e7b29
        sta     $18
        shorta0
        jsr     _c1ef6a
        lda     near w7e60a3
        clc
        adc     near w7e60a5
        sta     near w7e60a3
@ee98:  ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ac: init bg scroll hdma ]

; b1: 123fffff
;       1: affect bg1
;       2: affect bg2
;       3: affect bg3
;       f: frequency
; b2: vhaaaaaa
;       v: affect vertical scroll hdma
;       h: affect horizontal scroll hdma
;       a: amplitude (--aaa- only these 3 bits have an effect)

        array_label ANIM_CMD, $2c
magic_code2c:
@ee9c:  ldy     #1

; bg1 vertical
        lda     [zAnimScriptPtr]
        bpl     @eec7
        lda     [zAnimScriptPtr],y
        bpl     @eeb3
        and     #$3f                    ; amplitude
        sta     near w7e6096
        lda     [zAnimScriptPtr]
        and     #$1f
        sta     near w7e609a                 ; frequency
; bg1 horizontal
@eeb3:  lda     [zAnimScriptPtr],y
        and     #$40
        beq     @eec7
        lda     [zAnimScriptPtr],y
        and     #$3f
        sta     near w7e6095
        lda     [zAnimScriptPtr]
        and     #$1f
        sta     near w7e6099
; bg2 vertical
@eec7:  lda     [zAnimScriptPtr]
        and     #$40
        beq     @eef1
        lda     [zAnimScriptPtr],y
        bpl     @eedd
        and     #$3f
        sta     near w7e609c
        lda     [zAnimScriptPtr]
        and     #$1f
        sta     near w7e60a0
; bg2 horizontal
@eedd:  lda     [zAnimScriptPtr],y
        and     #$40
        beq     @eef1
        lda     [zAnimScriptPtr],y
        and     #$3f
        sta     near w7e609b
        lda     [zAnimScriptPtr]
        and     #$1f
        sta     near w7e609f
; bg3 vertical
@eef1:  lda     [zAnimScriptPtr]
        and     #$20
        beq     @ef1b
        lda     [zAnimScriptPtr],y
        bpl     @ef07
        and     #$3f
        sta     near w7e60a2
        lda     [zAnimScriptPtr]
        and     #$1f
        sta     near w7e60a6
; bg3 horizontal
@ef07:  lda     [zAnimScriptPtr],y
        and     #$40
        beq     @ef1b
        lda     [zAnimScriptPtr],y
        and     #$3f
        sta     near w7e60a1
        lda     [zAnimScriptPtr]
        and     #$1f
        sta     near w7e60a5
@ef1b:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; pointers to pre-computed sine wave tables
get_laster_poi:
_c1ef24:
@ef24:  .addr   w7ee7bf,w7ee7ff,w7ee83f,w7ee87f,w7ee8bf,w7ee8ff,w7ee93f,w7ee97f

; ------------------------------------------------------------------------------

; [ copy sine data to bg1/bg2 hdma scroll table ]

; +$10: hdma table start offset
;  $16: phase
;  $24: amplitude

_c1ef34:
bg_laster_set:
@ef34:  lda     $24
        and     #%1110
        tax
        longa
        lda     f:_c1ef24,x             ; pointer to sine wave data
        sta     $22
        lda     $16
        and     #$00ff
        asl
        and     #$003f
        tay
        lda     #$0020                  ; 32 iterations
        sta     $12
        ldx     $10
@ef52:  lda     ($22),y
        sta     a:0,x
        inx4
        iny2
        tya
        and     #$003f
        tay
        dec     $12
        bne     @ef52
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ copy sine data to bg3 hdma scroll table ]

_c1ef6a:
bg_laster_set_bg3:
@ef6a:  lda     $24
        and     #%1110
        tax
        longa
        lda     f:_c1ef24,x
        sta     $22
        lda     $16
        and     #$00ff
        asl
        and     #$003f
        tay
        lda     #$0020
        sta     $12
        ldx     $10
@ef88:  lda     ($22),y
        clc
        adc     $18                     ; add offset
        sta     a:0,x
        inx4
        iny2
        tya
        and     #$003f
        tay
        dec     $12
        bne     @ef88
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $ad: set bg hdma scroll type ]

; b1: lltttttt
;     l: (0 = bg1, 1 = bg2, 2 = bg3)
;     t: hdma scroll type

        array_label ANIM_CMD, $2d
magic_code2d:
@efa3:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        and     #$c0
        bne     @efb4
        lda     [zAnimScriptPtr]
        and     #$3f
        sta     near w7e800c       ; bg1 hdma scroll type
        rts
@efb4:  cmp     #$40
        bne     @efc0
        lda     [zAnimScriptPtr]
        and     #$3f
        sta     near w7e800d       ; bg2 hdma scroll type
        rts
@efc0:  lda     [zAnimScriptPtr]
        and     #$3f
        sta     near w7e800e       ; bg3 hdma scroll type
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a9: move circle ]

        array_label ANIM_CMD, $29
magic_code29:
@efc8:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $22
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $24
        lda     near wAnimThread::AttackerIndex,x
        bmi     @f01d
        tay
        lda     near w7e7b10,y
@efdf:  and     #$01
        beq     @efea
        lda     $22
        neg_a
        sta     $22
@efea:  lda     $22
        bpl     @eff5
        lda     near w7e9614
        cmp     #$21
        bcc     @f003
@eff5:  lda     near w7e9614
        clc
        adc     $22
        cmp     near w7e9617
        bcc     @f003
        lda     near w7e9617
@f003:  sta     near w7e9614
        lda     near w7e9615
        clc
        adc     $24
        cmp     near w7e9618
        bcc     @f014
        lda     near w7e9618
@f014:  sta     near w7e9615
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts
@f01d:  and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80f3,y
        eor     near w7e617e,y
        eor     #$01
        jmp     @efdf

; ------------------------------------------------------------------------------

; [ battle animation command $c3: move circle to target ]

        array_label ANIM_CMD, $43
magic_code43:
@f02f:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetPosX,x     ; target x position
        sta     near w7e9614       ; circle x position
        lda     near wAnimThread::TargetPosY,x     ; target y position
        sta     near w7e9615       ; circle y position
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d3: move circle to attacking character ]

        array_label ANIM_CMD, $53
magic_code53:
@f044:  jsr     GetAttackerThreadPtr
        longa
        lda     near wCharGfxData::PosX,y    ; character x position
        clc
        adc     near wCharGfxData::OffsetX,y ; add offsets
        clc
        adc     near wCharGfxData::AnimOffsetX,y
        clc
        adc     #8                      ; add 8 to get center of sprite
        sta     $22
        lda     near wCharGfxData::PosY,y    ; character y position
        clc
        adc     near wCharGfxData::OffsetY,y ; add offset
        sta     $24
        dec     zAnimScriptPtr
        shorta0
        lda     $22                     ; set circle position
        sta     near w7e9614
        lda     $24
        sta     near w7e9615
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a8: move circle to attacker ]

        array_label ANIM_CMD, $28
magic_code28:
@f073:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x
        sta     near w7e9614
        lda     near wAnimThread::AttackerPosY,x
        sta     near w7e9615
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a7: update circle ]

        array_label ANIM_CMD, $27
magic_code27:
@f088:  jsr     UpdateCircle_near
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a6: move circle and change size ]

        array_label ANIM_CMD, $26
magic_code26:
@f094:  lda     [zAnimScriptPtr]
        sta     $22
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $24
        iny
        lda     [zAnimScriptPtr],y
        sta     $26
        ldy     zAnimScriptPtr
        iny2
        sty     zAnimScriptPtr
        lda     $22
        bpl     @f0b5
        lda     near w7e9614
        cmp     #$21
        bcc     @f0c3
@f0b5:  lda     near w7e9614
        clc
        adc     $22
        cmp     near w7e9617
        bcc     @f0c3
        lda     near w7e9617
@f0c3:  sta     near w7e9614
        lda     near w7e9615
        clc
        adc     $24
        cmp     near w7e9618
        bcc     @f0d4
        lda     near w7e9618
@f0d4:  sta     near w7e9615
        lda     near w7e9613
        clc
        adc     $26
        cmp     near w7e9616
        bcc     @f0e5
        lda     near w7e9616
@f0e5:  sta     near w7e9613
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a5: set circle parameters ]

; b1: initial x position
; b2: initial y position
; b3: initial size
; b4: final x position
; b5: final y position
; b6: final size
; b7: speed

        array_label ANIM_CMD, $25
magic_code25:
@f0ec:  lda     [zAnimScriptPtr]
        sta     near w7e9614       ; initial x position
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     near w7e9615       ; initial y position
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e9613       ; initial size
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e9617       ; final x position
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e9618       ; final y position
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e9616       ; final size
        iny
        lda     [zAnimScriptPtr],y
        sta     near w7e9619       ; circle speed
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bpl     @f130       ; branch if a character
        and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80f3,y
        eor     near w7e617e,y
        eor     #$01
        bra     @f134
@f130:  tay
        lda     near w7e7b10,y
@f134:  and     #$01
        beq     @f13c       ; branch if not mirrored
        lda     #$c0
        bra     @f13e
@f13c:  lda     #$40
@f13e:  sta     near w7e961a       ; circle vh flip
        longa
        lda     zAnimScriptPtr
        clc
        adc     #$0006
        sta     zAnimScriptPtr
        shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [  ]

CyclePalLeft:
@f152:  phx
        asl     $22
        stz     $23
        lda     $22
        tax
        stz     $25
        longa
        lda     $28
        and     #$00f0
        asl
        sta     $28
        txa
        clc
        adc     $28
        tax
        dec     $24
        lda     near w7e7e00,x
        pha
        lda     near w7e7c00,x
        pha
@f175:  lda     near w7e7e00+2,x
        sta     near w7e7e00,x
        lda     near w7e7c00+2,x
        sta     near w7e7c00,x
        inx2
        dec     $24
        bne     @f175
        pla
        sta     near w7e7c00,x
        pla
        sta     near w7e7e00,x
        shorta0
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

CyclePalRight:
@f194:  phx
        asl     $22
        stz     $23
        dec     $24
        lda     $24
        asl
        clc
        adc     $22
        tax
        stz     $25
        longa
        lda     $28
        and     #$00f0
        asl
        sta     $28
        txa
        clc
        adc     $28
        tax
        lda     near w7e7e00,x
        pha
        lda     near w7e7c00,x
        pha
@f1bb:  lda     near w7e7e00-2,x
        sta     near w7e7e00,x
        lda     near w7e7c00-2,x
        sta     near w7e7c00,x
        dex2
        dec     $24
        bne     @f1bb
        pla
        sta     near w7e7c00,x
        pla
        sta     near w7e7e00,x
        shorta0
        plx
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1f1da:
get_pal_poi:
@f1da:  ldy     #1
        lda     [zAnimScriptPtr],y
        lsr4
        tax
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a3: cycle palette right ]

; aaaabbbb ccccdddd
;   a: offset color
;   b: number of colors
;   c: palette index
;   d: speed (number of loops per shift)

        array_label ANIM_CMD, $23
magic_code23:
@f1e5:  jsr     _c1f1da
        lda     near w7e6085,x
        bne     @f211
        lda     [zAnimScriptPtr]
        and     #$f0
        lsr4
        sta     $22
        lda     [zAnimScriptPtr]
        and     #$0f
        sta     $24
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $28
        jsr     CyclePalRight
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$0f
        sta     near w7e6085,x
@f211:  dec     near w7e6085,x
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a4: cycle palette left ]

; aaaabbbb ccccdddd
;   a: offset color
;   b: number of colors
;   c: palette index
;   d: speed (number of loops per shift)

        array_label ANIM_CMD, $24
magic_code24:
@f21d:  jsr     _c1f1da
        lda     near w7e6085,x
        bne     @f249
        lda     [zAnimScriptPtr]
        and     #$f0
        lsr4
        sta     $22
        lda     [zAnimScriptPtr]
        and     #$0f
        sta     $24
        ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $28
        jsr     CyclePalLeft
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$0f
        sta     near w7e6085,x
@f249:  dec     near w7e6085,x
        ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $90: set sprite layer priority ]

; b1: --oo---- o: layer priority

        array_label ANIM_CMD, $10
magic_code10:
@f255:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::LayerPriority,x     ; sprite layer priority
        and     #$cf
        ora     [zAnimScriptPtr]
        sta     near wAnimThread::LayerPriority,x     ; sprite layer priority
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $8d & $8f: move thread if animation is flipped horizontally ]

        array_label ANIM_CMD, $0d
        array_label ANIM_CMD, $0f
magic_code0d:
magic_code0f:
@f263:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @f279       ; return if a monster
        tay
        lda     near w7e7b10,y     ; character facing direction
        eor     near wAnimThread::w7e6f88,x     ; animation direction
        and     #$01
        jeq     array_item ANIM_CMD, 3       ; move thread
@f279:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $8e:  ]

; b1 = ??-----?

        array_label ANIM_CMD, $0e
magic_code0e:
@f27a:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @f2a1       ; return if a monster
        tay
        lda     [zAnimScriptPtr]       ; $10 = sprite priority (above/below)
        and     #$01
        sta     $10
        lda     [zAnimScriptPtr]
        bmi     @f29e       ; branch if shown behind
        and     #$40
        beq     @f294       ; branch if shown in front
        clr_a
        bra     @f29e
@f294:  lda     near w7e7b10,y     ; character facing direction
        eor     near wAnimThread::w7e6f88,x     ; animation direction
        and     #$01
        eor     $10
@f29e:  sta     near wAnimThread::IsBackSprite,x     ; sprite layer priority
@f2a1:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $9c: move thread if facing left ]

        array_label ANIM_CMD, $1c
magic_code1c:
@f2a2:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @f2b5                   ; return if target is a monster
        tay
        lda     near w7e7b10,y
        and     #$01
        jeq     array_item ANIM_CMD, 3
@f2b5:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $9e:  ]

        array_label ANIM_CMD, $1e
magic_code1e:
@f2b6:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x
        bmi     @f2db
        tay
        lda     near w7e7b10,y
        and     #$01
        bne     @f2cc

; target facing left
        lda     [zAnimScriptPtr]
        sta     $10
        bra     @f2d3

; target facing right
@f2cc:  ldy     #1
        lda     [zAnimScriptPtr],y
        sta     $10

; modify animation direction
@f2d3:  lda     near wAnimThread::w7e6f87,x
        eor     $10
        sta     near wAnimThread::w7e6f87,x
@f2db:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a2: toggle horizontal flip ]

; b1: must be $40
; used by drill

        array_label ANIM_CMD, $22
magic_code22:
@f2e1:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     $10
        lda     near wAnimThread::w7e6f87,x     ; toggle horizontal flip
        eor     $10
        sta     near wAnimThread::w7e6f87,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $9d: set sprite frame ]

; unused

        array_label ANIM_CMD, $1d
magic_code1d:
@f2f1:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @f30e       ; return if a monster
        tay
        lda     near w7e7b10,y     ; character facing direction
        and     #$01
        bne     @f307       ; branch if facing right
        lda     [zAnimScriptPtr]
        sta     z9b         ; frame if facing left
        bra     @f30e
@f307:  ldy     #1
        lda     [zAnimScriptPtr],y
        sta     z9b
@f30e:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $f4: set sprite layer priority ]

        array_label ANIM_CMD, $74
magic_code74:
@f30f:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        and     #$01
        sta     near wAnimThread::IsBackSprite,x
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $9b: change thread sprite priority ]

; b0: bf-----h
;       b: back sprite
;       f: front sprite
;       h: front/back sprite based on facing direction (left/right hand)

        array_label ANIM_CMD, $1b
magic_code1b:
@f31a:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @f33e       ; return if a monster
        tay
        lda     [zAnimScriptPtr]
        and     #$01
        sta     $10
        lda     [zAnimScriptPtr]
        bmi     @f33b
        and     #$40
        beq     @f334
        clr_a
        bra     @f33b
@f334:  lda     near w7e7b10,y     ; character facing direction
        and     #$01
        eor     $10
@f33b:  sta     near wAnimThread::IsBackSprite,x     ; sprite layer priority
@f33e:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $82: set target graphical action ]

; b1 = action if facing left
; b2 = action if facing right

        array_label ANIM_CMD, $02
magic_code02:
@f33f:  ldx     near wAnimThreadPtr       ; pointer to thread data
        lda     near wAnimThread::TargetIndex,x     ; target
        bra     _f34d

; ------------------------------------------------------------------------------

; [ battle animation command $81: set attacker graphical action ]

; b1: action if facing left
; b2: action if facing right

        array_label ANIM_CMD, $01
magic_code01:
@f347:  ldx     near wAnimThreadPtr       ; pointer to thread data
        lda     near wAnimThread::AttackerIndex,x     ; attacker
_f34d:  bmi     @f371       ; return if a monster
        sta     $10
        tay
        lda     near w7e7b10,y     ; character facing direction
        eor     near wAnimThread::w7e6f88,x     ; animation direction
        and     #$01        ; isolate direction bit
        tay
        lda     [zAnimScriptPtr],y     ; graphical action number
        sta     $12
        lda     $10         ; character number
        and     #%11
        sta     near wForceCharGfxTfr        ; enable character graphical action update
        asl5
        tay
        lda     $12
        sta     near wCharGfxData::AnimFrame,y     ; set graphical action number
@f371:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $83: move thread ]

; b1 = dddxxxxx
;      d: direction (0 = down/forward, 1 = down, 2 = down/back, 3 = forward, 4 = back, 5 = up/forward, 6 = up, 7 = up/back)
;      x: distance - 1

        array_label ANIM_CMD, $03
magic_code03:
@f377:  lda     [zAnimScriptPtr]
        sta     $12
        and     #$1f
        inc
        sta     $10
        stz     $11
; fall through

; ------------------------------------------------------------------------------

; [ move animation thread ]

;  $12: direction
; +$10: distance

MoveAnim:
magic_code03_a:
@f382:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f87,x     ; animation direction
        beq     @f396       ; branch if horizontally flipped
        lda     $12
        and     #$e0
        lsr4
        tax
        jmp     (near MoveAnimTbl+16,x)
@f396:  lda     $12
        and     #$e0
        lsr4
        tax
        jmp     (near MoveAnimTbl,x)

; ------------------------------------------------------------------------------

; move thread jump table (normal)
vect_chg:
MoveAnimTbl:
@f3a2:  .addr   MoveAnimDownLeft
        .addr   MoveAnimDown
        .addr   MoveAnimDownRight
        .addr   MoveAnimLeft
        .addr   MoveAnimRight
        .addr   MoveAnimUpLeft
        .addr   MoveAnimUp
        .addr   MoveAnimUpRight

; horizontally flipped
        .addr   MoveAnimDownRight
        .addr   MoveAnimDown
        .addr   MoveAnimDownLeft
        .addr   MoveAnimRight
        .addr   MoveAnimLeft
        .addr   MoveAnimUpRight
        .addr   MoveAnimUp
        .addr   MoveAnimUpLeft

; ------------------------------------------------------------------------------

; [ move thread down/forward ]

MoveAnimDownLeft:
@f3c2:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x     ; thread x position
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosX,x
        lda     near wAnimThread::ThreadPosY,x     ; thread y position
        clc
        adc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread down ]

MoveAnimDown:
@f3dd:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread down/back ]

MoveAnimDownRight:
@f3ef:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x
        clc
        adc     $10
        sta     near wAnimThread::ThreadPosX,x
        lda     near wAnimThread::ThreadPosY,x
        clc
        adc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread forward ]

MoveAnimLeft:
@f40a:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosX,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread back ]

MoveAnimRight:
@f41c:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x
        clc
        adc     $10
        sta     near wAnimThread::ThreadPosX,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread up/forward ]

MoveAnimUpLeft:
@f42e:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosX,x
        lda     near wAnimThread::ThreadPosY,x
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread up ]

MoveAnimUp:
@f449:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosY,x
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move thread up/back ]

MoveAnimUpRight:
@f45b:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadPosX,x
        clc
        adc     $10
        sta     near wAnimThread::ThreadPosX,x
        lda     near wAnimThread::ThreadPosY,x
        sec
        sbc     $10
        sta     near wAnimThread::ThreadPosY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $87: move target ]

; b1: dddxxxxx
;       d: direction (0 = down/forward, 1 = down, 2 = down/back, 3 = forward, 4 = back, 5 = up/forward, 6 = up, 7 = up/back)
;       x: distance - 1

        array_label ANIM_CMD, $07
magic_code07:
@f476:  lda     [zAnimScriptPtr]
        sta     $12
        and     #$1f
        inc
        sta     $10
        stz     $11
        lda     #$04
        sta     near w7e64dc     ; select target
        stz     near w7e64dc+1
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x   ; attacker index
        bra     _f4a8     ; branch if a monster

; ------------------------------------------------------------------------------

; [ battle animation command $86: move attacker ]

; b1: dddxxxxx
;       d: direction
;            0: down/forward
;            1: down
;            2: down/back
;            3: forward
;            4: back
;            5: up/forward
;            6: up
;            7: up/back
;       x: distance - 1

        array_label ANIM_CMD, $06
magic_code06:
@f491:  lda     [zAnimScriptPtr]
        sta     $12
        and     #$1f
        inc
        sta     $10                     ; +$10 = distance
        stz     $11

MoveAttacker:
@f49c:  stz     near w7e64dc                   ; select attacker
        stz     near w7e64dc+1
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x                 ; attacker index

magic_code06_b:
_f4a8:  bmi     @f4d5                   ; branch if a monster

; character
        asl5
        tay
        lda     near wAnimThread::w7e6f87,x
        beq     @f4c5                   ; branch if not flipped horizontally

; move character, horizontally flipped
        lda     $12
        and     #$e0                    ; direction
        lsr4
        tax
        jsr     (near MoveCharTbl+$10,x)
        ldx     near wAnimThreadPtr
        rts

; move character, not flipped
@f4c5:  lda     $12
        and     #$e0                    ; direction
        lsr4
        tax
        jsr     (near MoveCharTbl,x)
        ldx     near wAnimThreadPtr
        rts

; monster
@f4d5:  and     #$7f
        sec
        sbc     #$04
        asl
        tay
        lda     near wAnimThread::w7e6f87,x
        beq     @f4f1                   ; branch if not flipped horizontally

; move monster, horizontally flipped
        lda     $12
        and     #$e0                    ; direction
        lsr4
        tax
        jsr     (near MoveMonsterTbl+$10,x)
        ldx     near wAnimThreadPtr
        rts

; move monster, not flipped
@f4f1:  lda     $12
        and     #$e0                    ; direction
        lsr4
        tax
        jsr     (near MoveMonsterTbl,x)
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; character movement jump table (8 movement directions, normal then horizontally flipped)
pmvect_chg_tbl:
MoveCharTbl:
@f501:  .addr   MoveCharDownLeft
        .addr   MoveCharDown
        .addr   MoveCharDownRight
        .addr   MoveCharLeft
        .addr   MoveCharRight
        .addr   MoveCharUpLeft
        .addr   MoveCharUp
        .addr   MoveCharUpRight

; horizontally flipped
        .addr   MoveCharDownRight
        .addr   MoveCharDown
        .addr   MoveCharDownLeft
        .addr   MoveCharRight
        .addr   MoveCharLeft
        .addr   MoveCharUpRight
        .addr   MoveCharUp
        .addr   MoveCharUpLeft

; monster movement jump table (8 movement directions, normal then horizontally flipped)
MoveMonsterTbl:
@f521:  .addr   MoveMonsterDownLeft
        .addr   MoveMonsterDown
        .addr   MoveMonsterDownRight
        .addr   MoveMonsterLeft
        .addr   MoveMonsterRight
        .addr   MoveMonsterUpLeft
        .addr   MoveMonsterUp
        .addr   MoveMonsterUpRight

; horizontally flipped
        .addr   MoveMonsterDownRight
        .addr   MoveMonsterDown
        .addr   MoveMonsterDownLeft
        .addr   MoveMonsterRight
        .addr   MoveMonsterLeft
        .addr   MoveMonsterUpRight
        .addr   MoveMonsterUp
        .addr   MoveMonsterUpLeft

; ------------------------------------------------------------------------------

; [ move monster down/forward ]

MoveMonsterDownLeft:
@f541:  longa
        lda     near w7e80c3,y     ; monster x position
        sec
        sbc     $10
        sta     near w7e80c3,y
        lda     near w7e80cf,y     ; monster y position
        clc
        adc     $10
        sta     near w7e80cf,y
_f555:  lda     near wAnimThreadPtr       ; thread data pointer
        clc
        adc     near w7e64dc       ; attacker/target select (0 or 4)
        tay
        lda     near wAnimThread::AttackerPosX,y     ; attacker/target x position
        sec
        sbc     $10
        sta     near wAnimThread::AttackerPosX,y
        lda     near wAnimThread::AttackerPosY,y     ; attacker/target y position
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosY,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster down ]

MoveMonsterDown:
@f573:  longa
        lda     near w7e80cf,y
        clc
        adc     $10
        sta     near w7e80cf,y
_f57e:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosY,y
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosY,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster down/back ]

MoveMonsterDownRight:
@f593:  longa
        lda     near w7e80c3,y
        clc
        adc     $10
        sta     near w7e80c3,y
        lda     near w7e80cf,y
        clc
        adc     $10
        sta     near w7e80cf,y
_f5a7:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosX,y
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosX,y
        lda     near wAnimThread::AttackerPosY,y
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosY,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster forward ]

MoveMonsterLeft:
@f5c5:  longa
        lda     near w7e80c3,y
        sec
        sbc     $10
        sta     near w7e80c3,y
_f5d0:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosX,y
        sec
        sbc     $10
        sta     near wAnimThread::AttackerPosX,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster back ]

MoveMonsterRight:
@f5e5:  longa
        lda     near w7e80c3,y
        clc
        adc     $10
        sta     near w7e80c3,y
_f5f0:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosX,y
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosX,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster up/forward ]

MoveMonsterUpLeft:
@f605:  longa
        lda     near w7e80c3,y
        sec
        sbc     $10
        sta     near w7e80c3,y
        lda     near w7e80cf,y
        sec
        sbc     $10
        sta     near w7e80cf,y
_f619:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosX,y
        sec
        sbc     $10
        sta     near wAnimThread::AttackerPosX,y
        lda     near wAnimThread::AttackerPosY,y
        sec
        sbc     $10
        sta     near wAnimThread::AttackerPosY,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster up ]

MoveMonsterUp:
@f637:  longa
        lda     near w7e80cf,y
        sec
        sbc     $10
        sta     near w7e80cf,y
_f642:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosY,y
        sec
        sbc     $10
        sta     near wAnimThread::AttackerPosY,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move monster up/back ]

MoveMonsterUpRight:
@f657:  longa
        lda     near w7e80c3,y
        clc
        adc     $10
        sta     near w7e80c3,y
        lda     near w7e80cf,y
        sec
        sbc     $10
        sta     near w7e80cf,y
_f66b:  lda     near wAnimThreadPtr
        clc
        adc     near w7e64dc
        tay
        lda     near wAnimThread::AttackerPosX,y
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosX,y
        lda     near wAnimThread::AttackerPosY,y
        clc
        adc     $10
        sta     near wAnimThread::AttackerPosY,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move character down/forward ]

MoveCharDownLeft:
@f689:  longa
        lda     near wCharGfxData::AnimOffsetX,y     ; character x offset
        sec
        sbc     $10
        sta     near wCharGfxData::AnimOffsetX,y
        lda     near wCharGfxData::OffsetY,y     ; character y offset
        clc
        adc     $10
        sta     near wCharGfxData::OffsetY,y
        jmp     _f555

; ------------------------------------------------------------------------------

; [ move character down ]

MoveCharDown:
@f6a0:  longa
        lda     near wCharGfxData::OffsetY,y
        clc
        adc     $10
        sta     near wCharGfxData::OffsetY,y
        jmp     _f57e

; ------------------------------------------------------------------------------

; [ move character down/back ]

MoveCharDownRight:
@f6ae:  longa
        lda     near wCharGfxData::AnimOffsetX,y
        clc
        adc     $10
        sta     near wCharGfxData::AnimOffsetX,y
        lda     near wCharGfxData::OffsetY,y
        clc
        adc     $10
        sta     near wCharGfxData::OffsetY,y
        jmp     _f5a7

; ------------------------------------------------------------------------------

; [ move character forward ]

MoveCharLeft:
@f6c5:  longa
        lda     near wCharGfxData::AnimOffsetX,y
        sec
        sbc     $10
        sta     near wCharGfxData::AnimOffsetX,y
        jmp     _f5d0

; ------------------------------------------------------------------------------

; [ move character back ]

MoveCharRight:
@f6d3:  longa
        lda     near wCharGfxData::AnimOffsetX,y
        clc
        adc     $10
        sta     near wCharGfxData::AnimOffsetX,y
        jmp     _f5f0

; ------------------------------------------------------------------------------

; [ move character up/forward ]

MoveCharUpLeft:
@f6e1:  longa
        lda     near wCharGfxData::AnimOffsetX,y
        sec
        sbc     $10
        sta     near wCharGfxData::AnimOffsetX,y
        lda     near wCharGfxData::OffsetY,y
        sec
        sbc     $10
        sta     near wCharGfxData::OffsetY,y
        jmp     _f619

; ------------------------------------------------------------------------------

; [ move character up ]

MoveCharUp:
@f6f8:  longa
        lda     near wCharGfxData::OffsetY,y
        sec
        sbc     $10
        sta     near wCharGfxData::OffsetY,y
        jmp     _f642

; ------------------------------------------------------------------------------

; [ move character up/back ]

MoveCharUpRight:
@f706:  longa
        lda     near wCharGfxData::AnimOffsetX,y
        clc
        adc     $10
        sta     near wCharGfxData::AnimOffsetX,y
        lda     near wCharGfxData::OffsetY,y
        sec
        sbc     $10
        sta     near wCharGfxData::OffsetY,y
        jmp     _f66b
        .a8

; ------------------------------------------------------------------------------

; [ battle animation command $88: move attacker forward (fight) ]

; b1: frame index (0..7), ignored for magitek mode

        array_label ANIM_CMD, $08
magic_code08:
@f71d:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        bmi     @f730       ; return if monster
        tay
        lda     near w7e61ae,y     ;
        cmp     #1
        beq     @f731
        ldx     near wAnimThreadPtr
@f730:  rts
@f731:  lda     near wAnimThreadPtr       ; pointer to animation thread data
        and     #$70
        beq     @f769       ; branch if ???
        lda     near wMagitekModeEnabled
        beq     @f749       ; branch if not in magitek mode
        ldy     #1      ; move 1 pixel
        sty     $10
        lda     #$60        ; move forward
        sta     $12
        jmp     MoveAnim
@f749:  lda     [zAnimScriptPtr]       ; frame number
        tax
        lda     f:_c1f7a3,x
        sta     $10         ; set movement distance
        stz     $11
        lda     f:_c1f7ab,x
        sta     $12         ; set movement direction
        jsr     MoveAnim
        ldy     #3      ; move 3 pixels
        sty     $10
        lda     #$60        ; move forward
        sta     $12
        jmp     MoveAnim
@f769:  lda     near wMagitekModeEnabled
        beq     @f77d       ; branch if not in magitek mode
        ldy     #1
        sty     $10
        lda     #$60
        sta     $12
        jsr     MoveAttacker
        jmp     MoveAnim
@f77d:  lda     [zAnimScriptPtr]       ; frame number
        tax
        lda     f:_c1f7a3,x
        sta     $10         ; set movement distance
        stz     $11
        lda     f:_c1f7ab,x
        sta     $12         ; set movement direction
        jsr     MoveAttacker
        jsr     MoveAnim
        ldy     #3      ; move 3 pixels
        sty     $10
        lda     #$60        ; move forward
        sta     $12
        jsr     MoveAttacker
        jmp     MoveAnim

; ------------------------------------------------------------------------------

; vertical movement distance for jump
_c1f7a3:
@f7a3:  .byte   $03,$03,$02,$01,$00,$02,$03,$04

; vertical movement direction for jump
_c1f7ab:
@f7ab:  .byte   $c0,$c0,$c0,$c0,$c0,$20,$20,$20

; ------------------------------------------------------------------------------

; [ battle animation command $84: set animation speed ]

; b1: speed (frames per update)

        array_label ANIM_CMD, $04
magic_code04:
@f7b3:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::AnimRate,x     ; animation speed
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $89: loop start ]

; b1: loop count

        array_label ANIM_CMD, $09
magic_code09:
@f7bc:  ldx     near wAnimThreadPtr
        longa
        lda     zAnimScriptPtr
        sta     near wAnimThread::LoopPtr,x     ; loop start address
        shorta0
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::LoopCounter,x     ; loop count
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $9f: animated loop start (loop count = number of active threads) ]

; b1: 0
; used by autocrossbow

        array_label ANIM_CMD, $1f
magic_code1f:
@f7cf:  ldx     near wAnimThreadPtr
        longa
        lda     zAnimScriptPtr
        sta     near wAnimThread::LoopPtr,x     ; loop start address
        shorta0
        lda     near w7e6084       ; number of active threads
        sta     near wAnimThread::LoopCounter,x     ; loop count
        stz     near wAnimThread::LoopFrameOffset,x     ; clear frame offset
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $8b: animated loop start ]

; b1: loop count

        array_label ANIM_CMD, $0b
magic_code0b:
@f7e6:  ldx     near wAnimThreadPtr
        longa
        lda     zAnimScriptPtr
        sta     near wAnimThread::LoopPtr,x     ; loop start address
        shorta0
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::LoopCounter,x     ; loop count
        stz     near wAnimThread::LoopFrameOffset,x     ; clear frame offset
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $f5: loop end (loop until no sprite/bg1 threads are active) ]

; never used, this can only be used on bg3 threads

        array_label ANIM_CMD, $75
magic_code75:
@f7fc:  clr_ax
        stz     $22
@f800:  lda     $22
        ora     near wAnimThread::ThreadIsActive,x     ; thread active flag
        sta     $22
        longa
        txa                 ; next thread
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #BG3_THREAD_OFFSET
        bne     @f800
        ldx     near wAnimThreadPtr
        lda     $22
        beq     @f829       ; branch if none were active
        longa
        lda     near wAnimThread::LoopPtr,x     ; loop start address
        sta     zAnimScriptPtr
        shorta0
        rts
@f829:  ldy     zAnimScriptPtr         ; end of loop
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $8a: loop end ]

        array_label ANIM_CMD, $0a
magic_code0a:
@f82f:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::LoopCounter,x     ; branch if loop counter = 0
        beq     @f845
        longa
        lda     near wAnimThread::LoopPtr,x     ; loop start address
        sta     zAnimScriptPtr
        shorta0
        dec     near wAnimThread::LoopCounter,x     ; decrement loop counter
        rts
@f845:  ldy     zAnimScriptPtr         ; end of loop
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $8c: animated loop end ]

        array_label ANIM_CMD, $0c
magic_code0c:
@f84b:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::LoopCounter,x     ; branch if loop counter = 0
        beq     @f864
        longa
        lda     near wAnimThread::LoopPtr,x     ; loop start address
        sta     zAnimScriptPtr
        shorta0
        dec     near wAnimThread::LoopCounter,x     ; decrement loop counter
        inc     near wAnimThread::LoopFrameOffset,x     ; increment frame offset
        rts
@f864:  ldy     zAnimScriptPtr         ; end of loop
        dey
        sty     zAnimScriptPtr
        stz     near wAnimThread::LoopFrameOffset,x     ; clear frame offset
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $d2: set target position ]

; b1: x position
; b2: y position

        array_label ANIM_CMD, $52
magic_code52:
@f86d:  longa
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f87,x     ; branch if thread is flipped horizontally
        and     #$00ff
        bne     @f884
        lda     [zAnimScriptPtr]
        and     #$00ff
        sta     near wAnimThread::TargetPosX,x     ; target x position
        bra     @f88f
@f884:  lda     [zAnimScriptPtr]
        and     #$00ff
        eor     #$00ff
        sta     near wAnimThread::TargetPosX,x     ; target x position
@f88f:  inc     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        and     #$00ff
        sta     near wAnimThread::TargetPosY,x     ; target y position
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $85: move to attacker position ]

        array_label ANIM_CMD, $05
magic_code05:
@f89d:  longa
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x     ; attacker x position
        sta     near wAnimThread::ThreadPosX,x     ; thread x position
        lda     near wAnimThread::AttackerPosY,x     ; attacker y position
        sta     near wAnimThread::ThreadPosY,x     ; thread y position
        dec     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $91: move to weapon attacker position ]

        array_label ANIM_CMD, $11
magic_code11:
@f8b4:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerIndex,x     ; attacker
        and     #$7f
        asl
        tax
        longa
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        tay
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,y     ; attacker x position (attacker thread)
        sta     near wAnimThread::AttackerPosX,x     ; attacker x position (this thread)
        sta     near wAnimThread::ThreadPosX,x     ; thread x position (this thread)
        lda     near wAnimThread::AttackerPosY,y     ; attacker y position (attacker thread)
        sta     near wAnimThread::AttackerPosY,x     ; attacker y position (this thread)
        sta     near wAnimThread::ThreadPosY,x     ; thread x position (this thread)
        dec     zAnimScriptPtr
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $94: set vector from attacker to target (random location on target) ]

        array_label ANIM_CMD, $14
magic_code14:
@f8e0:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x     ; attacker x position
        sta     z7d
        lda     near wAnimThread::AttackerPosY,x     ; attacker y position
        sta     z7e
        jsr     Rand
        xba
        lda     near wAnimThread::TargetWidth,x     ; target width
        lsr
        asl2
        sta     $10
        asl
        jsr     MultAB
        lda     f:hRDMPYH
        sec
        sbc     $10
        sta     $10
        lda     near wAnimThread::TargetPosX,x
        sta     $12
        jsr     _c1f94e
        sta     z7f
        jsr     Rand
        xba
        lda     near wAnimThread::TargetHeight,x
        lsr
        asl2
        sta     $10
        asl
        jsr     MultAB
        lda     f:hRDMPYH
        sec
        sbc     $10
        sta     $10
        lda     near wAnimThread::TargetPosY,x
        sta     $12
        jsr     _c1f94e
        sta     z80
        jsr     CalcVec
        ldx     near wAnimThreadPtr
        lda     z85
        sta     near wAnimThread::w7e74db,x
        longa
        lda     z86
        sta     near wAnimThread::w7e74dc,x
        dec     zAnimScriptPtr
        stz     near wAnimThread::w7e74d9,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1f94e:
get_mon_size_vect:
@f94e:  lda     $10
        bpl     @f95f
        lda     $12
        clc
        adc     $10
        sta     $14
        lda     #$00
        adc     #$01
        bra     @f96a
@f95f:  lda     $12
        clc
        adc     $10
        sta     $14
        lda     #$00
        adc     #$00
@f96a:  and     #$01
        beq     @f977
        lda     $14
        cmp     #$f8
        bcs     @f97f
        jmp     @f97d
@f977:  lda     $14
        cmp     #$f8
        bcc     @f97f
@f97d:  lda     #$f8
@f97f:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $f2: set vector from target to attacker ]

        array_label ANIM_CMD, $72
magic_code72:
@f980:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x     ; x_2 = attacker x position
        sta     z7f
        lda     near wAnimThread::AttackerPosY,x     ; y_2 = attacker y position
        sta     z80
        lda     near wAnimThread::TargetPosX,x     ; x_1 = target x position
        sta     z7d
        lda     near wAnimThread::TargetPosY,x     ; y_1 = target y position
        sta     z7e
        bra     InitVec

; ------------------------------------------------------------------------------

; [ calculate angle between points ]

; $85/A: angle (out)

_c1f999:
good_get_vect_long:
@f999:  jsr     InitAttackerVec
        jsr     CalcVec
        lda     z85
        rtl

; ------------------------------------------------------------------------------

; [ set vector from attacker to target ]

InitAttackerVec:
@f9a2:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::AttackerPosX,x     ; x_1 = attacker x position (max 255)
        sta     z7d
        lda     near wAnimThread::AttackerPosX+1,x
        and     #$01
        beq     @f9b5
        lda     #$ff
        sta     z7d
@f9b5:  lda     near wAnimThread::AttackerPosY,x     ; y_1 = attacker y position (max 255)
        sta     z7e
        lda     near wAnimThread::AttackerPosY+1,x
        and     #$01
        beq     @f9c5
        lda     #$ff
        sta     z7e
@f9c5:  lda     near wAnimThread::TargetPosX,x     ; x_2 = target x position (max 255)
        sta     z7f
        lda     near wAnimThread::TargetPosX+1,x
        and     #$01
        beq     @f9d5
        lda     #$ff
        sta     z7f
@f9d5:  lda     near wAnimThread::TargetPosY,x     ; y_2 = target y position (max 255)
        sta     z80
        lda     near wAnimThread::TargetPosY+1,x
        and     #$01
        beq     @f9e5
        lda     #$ff
        sta     z80
@f9e5:  rts

; ------------------------------------------------------------------------------

; [ battle animation command $95: set vector from attacker to target ]

        array_label ANIM_CMD, $15
magic_code15:
@f9e6:  jsr     InitAttackerVec
; fallthrough

InitVec:
@f9e9:  jsr     CalcVec
        ldx     near wAnimThreadPtr
        lda     z88         ; dx
        sta     near wAnimThread::w7e74d7,x
        lda     z85
        sta     near wAnimThread::w7e74db,x     ; angle
        longa
        lda     z86         ; hypotenuse
        sta     near wAnimThread::w7e74dc,x     ; calculated magnitude
        dec     zAnimScriptPtr
        stz     near wAnimThread::w7e74d9,x     ; clear current vector position
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ move animation thread to current vector position ]

MoveThreadToVec:
        lda     near wAnimThread::w7e74d9,x     ; current vector position
        sta     $24
        lda     near wAnimThread::w7e74d9+1,x
        sta     $25
        lda     near wAnimThread::w7e74db,x     ; vector angle + 90 degrees
        clc
        adc     #$40
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     $28
        sta     near wAnimThread::ThreadOffsetX,x     ; thread x offset
        shorta0
        lda     near wAnimThread::w7e74db,x     ; vector angle
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     $28
        sta     near wAnimThread::ThreadOffsetY,x     ; thread y offset
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $93: set position on vector ]

        array_label ANIM_CMD, $13
magic_code13:
@fa3d:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::w7e74d9,x     ; current vector position
        stz     near wAnimThread::w7e74d9+1,x
        jmp     MoveThreadToVec

; ------------------------------------------------------------------------------

; [ battle animation command $a0: jump forward along vector ]

; b1: speed
; b2: number of bytes to branch backwards

        array_label ANIM_CMD, $20
magic_code20:
@fa4b:  ldx     near wAnimThreadPtr
        jsr     CalcThreadVecPos
        lda     [zAnimScriptPtr]       ; +$22 = b1
        sta     $22
        stz     $23
        longa
        lda     near wAnimThread::w7e74d9,x     ; current vector position
        cmp     near wAnimThread::w7e74dc,x     ; calculated vector magnitude
        bcc     @fa69       ; branch if thread hasn't reached target
        inc     zAnimScriptPtr
        clr_a
        sta     near wCharGfxData::JumpOffset,y     ; clear character y offset
        bra     @fa89
@fa69:  clc
        adc     $22
        sta     near wAnimThread::w7e74d9,x     ; add b1 to vector position
        lda     near wAnimThread::ThreadOffsetY,x     ; add value to y offset (for jumping)
        clc
        adc     $28
        sta     near wAnimThread::ThreadOffsetY,x
        ldy     #1
        lda     [zAnimScriptPtr],y     ; branch backwards
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@fa89:  shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $a1: jump backward along vector ]

; b1: speed
; b2: number of bytes to branch backwards

        array_label ANIM_CMD, $21
magic_code21:
@fa90:  ldx     near wAnimThreadPtr
        jsr     CalcThreadVecPos
        lda     [zAnimScriptPtr]
        sta     $22
        stz     $23
        longa
        lda     near wAnimThread::w7e74d9,x     ; polar radius
        sec
        sbc     $22
        sta     near wAnimThread::w7e74d9,x     ;
        bpl     @faba
        inc     zAnimScriptPtr
        ldy     near wAttackerThreadPtr
        clr_a
        sta     near wCharGfxData::OffsetX,y
        sta     near wCharGfxData::OffsetY,y
        sta     near wCharGfxData::JumpOffset,y
        bra     @fad4
@faba:  lda     near wAnimThread::ThreadOffsetY,x
        clc
        adc     $28
        sta     near wAnimThread::ThreadOffsetY,x
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@fad4:  shorta0
        ldx     near wAnimThreadPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $92: move thread along vector ]

; b1: speed (diagonal pixels/frame)
; b2: script branch for looping (number of bytes backwards, 0 for no loop)

        array_label ANIM_CMD, $12
magic_code12:
@fadb:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::w7e74d8,x
        jsr     MoveThreadToVec
        longa
        lda     near wAnimThread::w7e74d8,x     ; movement speed
        and     #$00ff
        sta     $22
        lda     near wAnimThread::w7e74d9,x     ; add to vector position
        clc
        adc     $22
        sta     near wAnimThread::w7e74d9,x     ; current vector position
        cmp     near wAnimThread::w7e74dc,x     ; branch if less than calculated vector position
        bcc     @fb02
        inc     zAnimScriptPtr
        bra     @fb19
@fb02:  ldy     #1
        lda     [zAnimScriptPtr],y     ; script branch
        and     #$00ff
        sta     $22
        bne     @fb12
        inc     zAnimScriptPtr
        bra     @fb19
@fb12:  lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@fb19:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ calculate boomerang vector position ]

CalcBoomerangVecPos:
@fb1d:  ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::w7e74dc,x     ; +$24 = vector magnitude
        sta     $24
        shorta0
        lda     near wAnimThread::w7e74d8,x     ; a = vector angle
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     $28
        sta     near wAnimThread::w7e74d9,x     ; current vector position
        shorta
        jsr     MoveThreadToVec
        ldy     #$0018
        sty     $24
        lda     near wAnimThread::w7e74d8,x     ; vector angle
        clc
        adc     #$40
        asl
        clc
        adc     #$90
        jsr     CalcSine16
        ldx     near wAnimThreadPtr
        longa
        lda     near wAnimThread::ThreadOffsetY,x     ; add to thread y offset
        clc
        adc     $28
        sta     near wAnimThread::ThreadOffsetY,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $96: move thread along vector (boomerang) ]

        array_label ANIM_CMD, $16
magic_code16:
@fb63:  jsr     CalcBoomerangVecPos
        lda     near wAnimThread::w7e74d7,x     ; x component of vector * 128
        lsr7
        sta     $22
        lda     #$03        ;
        sec
        sbc     $22
        clc
        adc     near wAnimThread::w7e74d8,x     ; add to vector angle
        sta     near wAnimThread::w7e74d8,x
        cmp     #$80
        bcc     @fb88
        longa
        inc     zAnimScriptPtr
        bra     @fba4
        .a8
@fb88:  cmp     #$40
        bcc     @fb91
        lda     #$01
        sta     near wAnimThread::IsBackSprite,x     ; sprite layer priority
@fb91:  longa
        ldy     #1
        lda     [zAnimScriptPtr],y
        and     #$00ff
        sta     $22
        lda     zAnimScriptPtr
        sec
        sbc     $22
        sta     zAnimScriptPtr
@fba4:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $98: update frame offset auto-increment ]

; b1: frame counter
; b2: bbbbeeee
;       b: starting frame
;       e: ending frame

        array_label ANIM_CMD, $18
magic_code18:
@fba8:  ldx     near wAnimThreadPtr
        dec     near wAnimThread::LoopFrameCounter,x     ; decrement frame offset counter
        bne     @fbd1
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::LoopFrameCounter,x     ; set frame offset counter
        ldy     #1
        lda     [zAnimScriptPtr],y     ; maximum frame
        and     #$0f
        sta     $22
        inc     near wAnimThread::LoopFrameOffset,x     ; increment frame offset
        lda     near wAnimThread::LoopFrameOffset,x
        cmp     $22
        bne     @fbd1       ; branch if not equal to maximum frame
        lda     [zAnimScriptPtr],y
        lsr4
        sta     near wAnimThread::LoopFrameOffset,x     ; set starting frame
@fbd1:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $97: set vector from attacker to target (boomerang) ]

        array_label ANIM_CMD, $17
magic_code17:
@fbd7:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetWidth,x
        asl2
        sta     $22
        lda     near wAnimThread::AttackerPosX,x
        sta     z7d
        lda     near wAnimThread::AttackerPosY,x
        sta     z7e
        lda     near wAnimThread::TargetPosX,x
        sta     z7f
        lda     near wAnimThread::TargetPosY,x
        sta     z80
        lda     z7f
        cmp     z7d
        bcc     @fc0a
        lda     z7f
        clc
        adc     $22
        sta     z7f
        bcc     @fc11
        lda     #$f8
        sta     z7f
        bra     @fc11
@fc0a:  lda     z7f
        sec
        sbc     $22
        sta     z7f
@fc11:  jsr     CalcVec
        ldx     near wAnimThreadPtr
        lda     z88
        sta     near wAnimThread::w7e74d7,x
        lda     z85
        sta     near wAnimThread::w7e74db,x
        longa
        lda     z86
        sta     near wAnimThread::w7e74dc,x
        stz     near wAnimThread::w7e74d9,x
        shorta0
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::w7e74d8,x
        jsr     CalcBoomerangVecPos
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $99: set thread sprite palette ]

; b1: ----ppp-

        array_label ANIM_CMD, $19
magic_code19:
@fc37:  ldx     near wAnimThreadPtr
        lda     [zAnimScriptPtr]
        sta     near wAnimThread::SpritePal,x     ; thread palette
        rts

; ------------------------------------------------------------------------------

; [ battle animation command $9a: set thread facing direction to match target ]

        array_label ANIM_CMD, $1a
magic_code1a:
@fc40:  ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bpl     @fc59       ; branch if a character
        and     #$0f
        sec
        sbc     #$04
        asl
        tay
        lda     near w7e80f3,y     ; monster facing direction
        eor     near w7e617e,y
        eor     #$01
        bra     @fc5d
@fc59:  tay
        lda     near w7e7b10,y     ; character facing direction
@fc5d:  asl6
        and     #$40
        sta     near wAnimThread::w7e6f87,x     ; thread facing direction
        ldy     zAnimScriptPtr
        dey
        sty     zAnimScriptPtr
        rts

; ------------------------------------------------------------------------------

; [ init palette color modification (not hardware color math) ]

; +$14: red value
; +$16: green value
; +$18: blue value

InitColorMod:
        .a16
@fc6e:  stz     $22
        stz     $24
        stz     $26
        lda     $14
        and     #$001f
        sta     $22
        lda     $16
        and     #$001f
        asl5
        sta     $24
        lda     $18
        and     #$001f
        asl5
        asl5
        sta     $26
        rts
        .a8

; ------------------------------------------------------------------------------

; [ subtract from color ]

;   +A: original color
; +$22: red value
; +$24: green value
; +$26: blue value

DecColor:
        .a16
@fc99:  and     #$7fff
        sta     $2a         ; +$2a = original color
        and     #$001f
        sec
        sbc     $22         ; +$28 = resulting red value
        sta     $28
        and     #$7fe0
        bne     @fcb6       ; branch if the red value was less than zero
        lda     $2a
        and     #$7fe0
        ora     $28
        sta     $2a         ; resulting color
        bra     @fcbd
@fcb6:  lda     $2a
        and     #$7fe0
        sta     $2a
@fcbd:  lda     $2a         ; green
        and     #$03e0
        sec
        sbc     $24
        sta     $28
        and     #$7c1f
        bne     @fcd7
        lda     $2a
        and     #$7c1f
        ora     $28
        sta     $2a
        bra     @fcde
@fcd7:  lda     $2a
        and     #$7c1f
        sta     $2a
@fcde:  lda     $2a
        and     #$7c00
        sec
        sbc     $26
        sta     $28
        and     #$83ff
        bne     @fcf8
        lda     $2a
        and     #$03ff
        ora     $28
        sta     $2a
        bra     @fcff
@fcf8:  lda     $2a
        and     #$03ff
        sta     $2a
@fcff:  rts
        .a8

; ------------------------------------------------------------------------------

; [ add to color ]

;   +A: original color
; +$22: red value
; +$24: green value
; +$26: blue value

IncColor:
        .a16
@fd00:  and     #$7fff
        sta     $2a
        and     #$001f
        clc
        adc     $22
        sta     $28
        and     #$7fe0
        bne     @fd1d
        lda     $2a
        and     #$7fe0
        ora     $28
        sta     $2a
        bra     @fd24
@fd1d:  lda     $2a
        ora     #$001f
        sta     $2a
@fd24:  lda     $2a
        and     #$03e0
        clc
        adc     $24
        sta     $28
        and     #$7c1f
        bne     @fd3e
        lda     $2a
        and     #$7c1f
        ora     $28
        sta     $2a
        bra     @fd45
@fd3e:  lda     $2a
        ora     #$03e0
        sta     $2a
@fd45:  lda     $2a
        and     #$7c00
        clc
        adc     $26
        sta     $28
        and     #$83ff
        bne     @fd5f
        lda     $2a
        and     #$03ff
        ora     $28
        sta     $2a
        bra     @fd66
@fd5f:  lda     $2a
        ora     #$7c00
        sta     $2a
@fd66:  rts
        .a8

; ------------------------------------------------------------------------------
