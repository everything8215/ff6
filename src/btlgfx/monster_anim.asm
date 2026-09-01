; ------------------------------------------------------------------------------

.enum MONSTER_EXIT_SCRIPT
        COUNT = 18
.endenum

.enum MONSTER_ENTRY_SCRIPT
        COUNT = 18
.endenum

.enum MONSTER_ANIM_SCRIPT
        COUNT = 14
.endenum

; ------------------------------------------------------------------------------

; pointers to monster exit animation scripts
MonsterExitScriptPtrs:
@e4eb:  ptr_tbl MONSTER_EXIT_SCRIPT

; pointers to monster entry animation scripts
MonsterEntryScriptPtrs:
@e50f:  ptr_tbl MONSTER_ENTRY_SCRIPT

; ------------------------------------------------------------------------------

; monster entry/exit animation scripts
        array_label MONSTER_ENTRY_SCRIPT, 14
@e533:  .byte   $00,$04
        .word   attack_anim_prop_offset CHARDARNOOK_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 14
@e539:  .byte   $00,$03
        .word   attack_anim_prop_offset CHARDARNOOK_EXIT
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 0
        array_label MONSTER_EXIT_SCRIPT, 13
        array_label MONSTER_EXIT_SCRIPT, 15
        array_label MONSTER_EXIT_SCRIPT, 16
        array_label MONSTER_EXIT_SCRIPT, 17
        array_label MONSTER_ENTRY_SCRIPT, 0
        array_label MONSTER_ENTRY_SCRIPT, 12
        array_label MONSTER_ENTRY_SCRIPT, 13
        array_label MONSTER_ENTRY_SCRIPT, 16
        array_label MONSTER_ENTRY_SCRIPT, 17
@e53f:  .byte   $ff

        array_label MONSTER_ENTRY_SCRIPT, 1
@e540:  .byte   $00,$04
        .word   attack_anim_prop_offset SMOKE_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 1
@e546:  .byte   $00,$03
        .word   attack_anim_prop_offset SMOKE_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 2
@e54c:  .byte   $00,$04
        .word   attack_anim_prop_offset CEILING_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 2
@e552:  .byte   $00,$03
        .word   attack_anim_prop_offset CEILING_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 3
@e558:  .byte   $00,$04
        .word   attack_anim_prop_offset SIDE_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 3
@e55e:  .byte   $00,$03
        .word   attack_anim_prop_offset SIDE_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 4
@e564:  .byte   $00,$04
        .word   attack_anim_prop_offset WATER_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 4
@e56a:  .byte   $00,$03
        .word   attack_anim_prop_offset WATER_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 5
@e570:  .byte   $00,$04
        .word   attack_anim_prop_offset FLOAT_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 5
@e576:  .byte   $00,$03
        .word   attack_anim_prop_offset FLOAT_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 6
@e57c:  .byte   $00,$04
        .word   attack_anim_prop_offset SAND_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 6
@e582:  .byte   $00,$03
        .word   attack_anim_prop_offset SAND_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 8
@e588:  .byte   $00,$04
        .word   attack_anim_prop_offset FADE_DOWN_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 8
@e58e:  .byte   $00,$03
        .word   attack_anim_prop_offset FADE_DOWN_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 9
@e594:  .byte   $00,$04
        .word   attack_anim_prop_offset FADE_UP_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 9
@e59a:  .byte   $00,$03
        .word   attack_anim_prop_offset FADE_UP_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 10
@e5a0:  .byte   $00,$04
        .word   attack_anim_prop_offset MATERIALIZE_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 10
@e5a6:  .byte   $00,$03
        .word   attack_anim_prop_offset MATERIALIZE_EXIT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 11
@e5ac:  .byte   $00,$04
        .word   attack_anim_prop_offset HORZ_FADE_ENTRY
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 11
@e5b2:  .byte   $00,$03
        .word   attack_anim_prop_offset HORZ_FADE_EXIT
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 12
@e5b8:  .byte   $00,$03
        .word   attack_anim_prop_offset BOSS_DEATH
        .byte   $01,$ff

; unused
@e5be:  .byte   $00,$e0,$ff

        array_label MONSTER_ENTRY_SCRIPT, 7
@e5c1:  .byte   $00,$04
        .word   attack_anim_prop_offset SIDE_ENTRY_INSTANT
        .byte   $01,$ff

        array_label MONSTER_EXIT_SCRIPT, 7
@e5c7:  .byte   $00,$03
        .word   attack_anim_prop_offset SIDE_EXIT_INSTANT
        .byte   $01,$ff

        array_label MONSTER_ENTRY_SCRIPT, 15
@e5cd:  .byte   $00,$04
        .word   attack_anim_prop_offset KEFKA_ENTRY
        .byte   $01,$ff

; ------------------------------------------------------------------------------


; pointers to misc. monster animation data
MonsterAnimScriptPtrs:
@e5d3:  ptr_tbl MONSTER_ANIM_SCRIPT

; ------------------------------------------------------------------------------

; misc. monster animation scripts (ai command $fa, command $2b)
MonsterAnimScript:

; final kefka death animation
        array_label MONSTER_ANIM_SCRIPT, 13
@e5ef:  .byte   $00,$04
        .word   attack_anim_prop_offset KEFKA_DEATH
        .byte   $01,$ff

; short atma glow
        array_label MONSTER_ANIM_SCRIPT, 12
@e5f5:  .byte   $00,$04
        .word   attack_anim_prop_offset MONSTER_GLOW_SHORT
        .byte   $01,$ff

; long atma glow
        array_label MONSTER_ANIM_SCRIPT, 11
@e5fb:  .byte   $00,$04
        .word   attack_anim_prop_offset MONSTER_GLOW_LONG
        .byte   $01,$ff

; final kefka disembodied head
        array_label MONSTER_ANIM_SCRIPT, 10
@e601:  .byte   $00,$04
        .word   attack_anim_prop_offset KEFKA_HEAD
        .byte   $01,$ff

; all characters run from left to right side of screen (unused)
        array_label MONSTER_ANIM_SCRIPT, 5
@e607:  .byte   $00,$05
        .word   attack_anim_prop_offset CHARS_RUN_RIGHT
        .byte   $01,$fe

; all characters run from right to left side of screen (SrBehemoth)
        array_label MONSTER_ANIM_SCRIPT, 6
@e60d:  .byte   $00,$05
        .word   attack_anim_prop_offset CHARS_RUN_LEFT
        .byte   $01,$fe

; play sound effect (Telstar/Chaser/Dadaluma)
; handled manually (see below)
        array_label MONSTER_ANIM_SCRIPT, 9

; flash monster red (Ultros/Umaro)
        array_label MONSTER_ANIM_SCRIPT, 0
@e613:  .byte   $00,$04
        .word   attack_anim_prop_offset FLASH_RED
        .byte   $01,$ff

; move monster back 8 pixels (slowly, Ultros)
        array_label MONSTER_ANIM_SCRIPT, 1
@e619:  .byte   $00,$04
        .word   attack_anim_prop_offset MOVE_BACK_SLOW
        .byte   $01,$ff

; move monster forward 8 pixels (slowly, Ultros)
        array_label MONSTER_ANIM_SCRIPT, 2
@e61f:  .byte   $00,$04
        .word   attack_anim_prop_offset MOVE_FORWARD_SLOW
        .byte   $01,$ff

; move monster back 8 pixels (instantly, Pugs)
        array_label MONSTER_ANIM_SCRIPT, 3
@e625:  .byte   $00,$04
        .word   attack_anim_prop_offset MOVE_BACK_8
        .byte   $01,$ff

; move monster forward 8 pixels (instantly, Pugs/Master Pug)
        array_label MONSTER_ANIM_SCRIPT, 4
@e62b:  .byte   $00,$04
        .word   attack_anim_prop_offset MOVE_FORWARD_8
        .byte   $01,$ff

; move monster back 64 pixels (instantly, Ultros/Pugs/Master Pug)
        array_label MONSTER_ANIM_SCRIPT, 7
@e631:  .byte   $00,$04
        .word   attack_anim_prop_offset MOVE_BACK_64
        .byte   $01,$ff

; move monster forward 64 pixels (instantly, unused)
        array_label MONSTER_ANIM_SCRIPT, 8
@e637:  .byte   $00,$04
        .word   attack_anim_prop_offset MOVE_FORWARD_64
        .byte   $01,$ff

; ------------------------------------------------------------------------------

; [ execute misc. monster animation (ai command $fa, command $2b) ]

DoMonsterAnim:
@e63d:  ldy     #2
        lda     (z76),y
        sta     near w7ee9fc       ; target monster
        dey
        lda     (z76),y     ; ai command $fa subcommand
        cmp     #$09
        bne     @e659       ; branch if not $09 (play sound effect)

; play sound effect
        iny
        lda     (z76),y     ; pan
        sta     $10
        iny
        lda     (z76),y     ; sfx id
        jsl     PlayAnimSfx_far
        rtl

; monster animation
@e659:  longa
        asl
        tax
        lda     f:MonsterAnimScriptPtrs,x
        sta     z8f
        shorta0
        bra     _e6b1

; ------------------------------------------------------------------------------

; [ execute monster entry/exit animation ]

DoMonsterEntryExit:
@e668:  jsr     WaitLine160_near
        ldy     #1
        lda     (z76),y     ; entry/exit type
        cmp     #$0d
        bne     @e67a       ; branch if not $0d (flash in/out)
        jsr     _c2e806
        jmp     _c2e88e
@e67a:  cmp     #$11
        bne     @e691       ; branch if not $11 (final kefka death)

; final kefka death
        jsr     _c2e806
        jsl     KefkaDeathAnim_far
        lda     #$ff
        sta     near w7e6191                 ; show all monsters
        lda     near w7e2f2f
        sta     near w7e201e
        rtl

; all other monster entry/exit animations
@e691:  pha
        jsr     _c2e806
        pla
        longa
        asl
        tax
        lda     near w7ee9fb
        and     #$00ff
        beq     @e6a8       ; branch if no monsters are exiting
        lda     f:MonsterExitScriptPtrs,x
        bra     @e6ac
@e6a8:  lda     f:MonsterEntryScriptPtrs,x
@e6ac:  sta     z8f
        shorta0

mon_mode_chg_main:
_e6b1:  lda     #^*
        sta     z8f_B
@e6b5:  lda     [z8f]
        cmp     #$ff
        beq     @e6cb       ; branch if end of data
        cmp     #$fe
        beq     @e6d0       ;
        asl
        tax
        jsr     (near MonsterAnimCmdTbl,x)
        ldy     z8f
        iny
        sty     z8f
        bra     @e6b5
@e6cb:  lda     #$ff
        sta     near w7e6191                 ; show all monsters
@e6d0:  lda     near w7e2f2f
        sta     near w7e201e
        rtl

; ------------------------------------------------------------------------------

.enum MONSTER_ANIM_CMD
        COUNT = 6
.endenum

; monster animation script command jump table
MonsterAnimCmdTbl:
        ptr_tbl MONSTER_ANIM_CMD

; ------------------------------------------------------------------------------

; [ get index of first target ]

; A: target bitmask

TargetMaskToIndex:
@e6e3:  ldx     zZero
@e6e5:  lsr
        bcs     @e6f0
        inx
        cpx     #8
        bne     @e6e5
        clr_a
        rts
@e6f0:  txa
        and     #$07
        rts

; ------------------------------------------------------------------------------

; [ monster animation script command $03: animation for exiting monsters ]

; +b1: pointer to attack animation properties (+$d07fb2)

        array_label MONSTER_ANIM_CMD, 3
@e6f4:  jsl     _c2fe21
        ldy     #1
        longa
        lda     [z8f],y
        sta     $1e
        inc     z8f
        inc     z8f
        shorta0
        lda     near w7ee9fb
        jsr     TargetMaskToIndex
        clc
        adc     #$04
        sta     near w7e2c6e + 1
        lda     near w7ee9fb
        sta     near w7e2c6e + 3
        sta     near w7e2c6e + 5
        sta     near wAnimMonsterTargets
        stz     near wAnimCharTargets
        stz     near w7e2c6e + 2
        stz     near w7e2c6e + 4
        lda     #$c0
        sta     near w7e2c6e
        jsl     InitEventAnimThreads_far
        rts

; ------------------------------------------------------------------------------

; [ monster animation script command $04: animation for entering monsters ]

; +b1: pointer to attack animation properties (+$d07fb2)

        array_label MONSTER_ANIM_CMD, 4
@e733:  jsl     _c2fe21
        ldy     #1
        longa
        lda     [z8f],y
        sta     $1e
        inc     z8f
        inc     z8f
        shorta0
        lda     near w7ee9fc
        jsr     TargetMaskToIndex
        clc
        adc     #$04
        sta     near w7e2c6e + 1
        lda     near w7ee9fc
        sta     near w7e2c6e + 3
        sta     near w7e2c6e + 5
        sta     near wAnimMonsterTargets
        stz     near wAnimCharTargets
        stz     near w7e2c6e + 2
        stz     near w7e2c6e + 4
        lda     #$c0
        sta     near w7e2c6e
        jsl     InitEventAnimThreads_far
        rts

; ------------------------------------------------------------------------------

; [ monster animation script command $05: animation for all characters ]

; +b1: pointer to attack animation properties (+$d07fb2)

        array_label MONSTER_ANIM_CMD, 5
@e772:  jsl     _c2fe21
        ldy     #1
        longa
        lda     [z8f],y
        sta     $1e
        inc     z8f
        inc     z8f
        shorta0
        stz     near w7e2c6e + 1
        lda     #$0f                    ; target all characters
        sta     near w7e2c6e + 2
        sta     near w7e2c6e + 4
        sta     near wAnimCharTargets
        stz     near wAnimMonsterTargets
        stz     near w7e2c6e + 3
        stz     near w7e2c6e + 5
        lda     #$00
        sta     near w7e2c6e
        jsl     InitEventAnimThreads_far
        rts

; ------------------------------------------------------------------------------

; [ monster animation script command $02: execute animation script ]

; unused, this command executes a single animation thread, unlike
; commands 3, 4, and 5 which execute a full multi-thread animation

; +b1: pointer to animation script (this bank)

        array_label MONSTER_ANIM_CMD, 2
@e7a7:  lda     near w7ee9fb
        sta     near w7e2c6e + 3
        sta     near w7e2c6e + 5
        sta     near wAnimMonsterTargets
        stz     near wAnimCharTargets
        stz     near w7e2c6e + 2
        stz     near w7e2c6e + 4
        jsr     TargetMaskToIndex
        pha
        clc
        adc     #$04
        sta     $10
        ora     #$80
        sta     near w7e2c6e + 1
        sta     near w7e613f
        lda     #$c0
        sta     near w7e2c6e
        pla
        longa
        asl7
        tax
        lda     #make_word 1, 1         ; 1x1 frame size
        sta     $22
        inc     z8f
        lda     [z8f]
        sta     $24
        inc     z8f
        shorta0
        lda     $10
        ora     #$80
        sta     $10
        lda     #^MonsterAnimScript
        sta     $26
        jsl     CreateStandaloneThread_far
        rts

; ------------------------------------------------------------------------------

; [ monster animation script command $00: clear animations ]

        array_label MONSTER_ANIM_CMD, 0
@e7fc:  jsl     InitEventAnim_far
        rts

; ------------------------------------------------------------------------------

; [ monster animation script command $01: execute animations ]

        array_label MONSTER_ANIM_CMD, 1
@e801:  jsl     ExecEventAnim_far
        rts

; ------------------------------------------------------------------------------

; [ init monster entry/exit animation ]

_c2e806:
get_mode_bit:
@e806:  lda     near w7e201e                   ; monsters shown
        sta     near w7ee9fa
        ldy     #2
        lda     (z76),y
        sta     near w7ee9fb                 ; monsters to hide/exit
        not_a
        sta     $10                     ; monsters not exiting
        iny
        lda     (z76),y
        sta     near w7ee9fc                 ; monsters to show/enter
        lda     near w7e201e
        and     $10
        ora     near w7ee9fc
        sta     near w7ee9fd
        lda     near w7ee9fb
        bne     @e84b                   ; return if no monsters are exiting
        lda     near w7ee9fa
        not_a
        sta     $10
        lda     near w7ee9fc                 ; monsters being shown
        and     $10                     ; remove monsters that are already shown
        sta     near w7ee9fc
        not_a
        sta     near w7e6191                 ; hide monsters that are newly entering
        lda     near w7ee9fd
        sta     near w7e201e
        sta     near w7e61ab
@e84b:  rts

; ------------------------------------------------------------------------------

; number of frames to wait to show monsters flashing out
_c2e84c:
@e84c:  .byte   12,11,10,9,8,7,6,7,4,3,2,2,2,2,2,2
        .byte   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2

; number of frames to wait to show monsters flashing in
_c2e86c:
@e86c:  .byte   2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        .byte   2,2,2,2,2,2,2,2,3,4,5,6,7,8,9,10
        .byte   11,12

; ------------------------------------------------------------------------------

; [ monster flash in/out animation ]

_c2e88e:
mode_chg_00:
@e88e:  stz     near w7eecb3
        lda     #$ff
        sta     near w7e6191                 ; show all monsters
@e896:  lda     near w7ee9fa                 ; monsters leaving
        sta     near w7e201e
        lda     near w7eecb3
        tax
        lda     f:_c2e84c,x
        jsl     WaitA_far
        lda     near w7ee9fc                 ; monsters entering
        sta     near w7e201e
        lda     near w7eecb3
        tax
        lda     f:_c2e86c,x
        jsl     WaitA_far
        inc     near w7eecb3
        lda     near w7eecb3
        cmp     #$20
        bne     @e896
        lda     #$ff
        sta     near w7e6191                 ; show all monsters
        lda     near w7e2f2f
        sta     near w7e201e
        rtl

; ------------------------------------------------------------------------------
