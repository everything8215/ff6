
; ------------------------------------------------------------------------------

; [ update battle time ]

UpdateBattleTime:
@111b:  php
        shortai
        jsr     GetPlayerActions
        lda     near w7e2f41       ; check if battle time is stopped by battle program
        and     near w7e3a8f       ; wait mode
        bne     @118b
        lda     near w7e3a6c       ; previous frame counter value
        ldx     #2
@112e:  cmp     $0e         ; current frame counter value
        beq     @1190       ; return if less than 2 frames have elapsed
        inc
        dex
        bne     @112e
        inc     near w7e3a3e_L       ; increment turn counter
        bne     @113e
        inc     near w7e3a3e_H
@113e:  jsr     DecCounters
        ldx     #$12
@1143:  cpx     near w7e3ee2
        bne     @114b
        jsr     DecMorphCounter
@114b:  lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @1184       ; branch if $3aa0.0 is clear (target not present)
        cpx     near wZingerAttacker
        beq     @1184
        bit     #$3a
        bne     @1184
        bit     #$04
        beq     @117c
        lda     near w7e2f45
        beq     @1179
        lda     near wTargetProp3::w7e3ee4,x
        bit     #STATUS1::ZOMBIE
        bne     @1179
        lda     near wTargetMask,x
        beq     @1179
        bit     near w7e3f2c
        bne     @1179
        bit     near w7e3a40
        beq     @117c
@1179:  jsr     _c21193
@117c:  lda     near wTargetProp1::w7e3218_H,x
        beq     @1184       ; branch if atb gauge is full
        jsr     _c211bb
@1184:  dex2                ; next target
        bpl     @1143
        jsr     UpdateCounterGfxBuf
@118b:  lda     $0e         ; current frame counter value
        sta     near w7e3a6c       ; previous frame counter value
@1190:  clr_a
        plp
        .i16
        rtl

; ------------------------------------------------------------------------------

; [ increment advance wait counter ]

_c21193:
gaugefull:
@1193:  longa
        lda     near wTargetProp2::w7e3ac8,x     ; atb gauge constant / 2
        lsr
        clc
        adc     near wTargetProp2::w7e3ab4,x     ; add to atb gauge counter
        sta     near wTargetProp2::w7e3ab4,x
        shorta
        bcs     @11aa       ; branch if it overflowed
        xba
        cmp     near wTargetProp1::AdvanceWaitDur,x
        bcc     _11ba       ; return if less than advance wait duration
@11aa:  lda     #$ff
        sta     near wTargetProp1::AdvanceWaitDur,x     ; disable advance wait
        jsr     _c24e77       ; add action to queue
        lda     #$20         ; set $3aa0.5

SetFlag0:
@11b4:  ora     near wTargetProp2::w7e3aa0,x
        sta     near wTargetProp2::w7e3aa0,x
_11ba:  rts

; ------------------------------------------------------------------------------

; [ increment atb gauge counter ]

_c211bb:
actioncounter:
        .i8
@11bb:  longa_clc
        lda     near wTargetProp1::w7e3218,x     ; atb gauge %
        adc     near wTargetProp2::w7e3ac8,x     ; add atb constant
        sta     near wTargetProp1::w7e3218,x
        shorta
        bcc     _11ba       ; return if it didn't overflow
        cpx     #$08
        bcs     @11d1       ; branch if a monster
        jsr     CreateRunAwayAction
@11d1:  stz     near wTargetProp1::w7e3218_H,x     ; clear atb gauge %
        stz     near wTargetProp2::w7e3ab4_H,x     ; clear advance wait counter
        lda     #$ff
        sta     near wTargetProp1::AdvanceWaitDur,x     ; disable advance wait
        lda     #$08
        bit     near wTargetProp2::w7e3aa0,x
        bne     @11ea       ; branch if $3aa0.3 is set
        jsr     SetFlag0     ; set $3aa0.3
        bit     #$02
        beq     _120e       ; branch if $3aa0.1 is clear (advance wait is enabled)
@11ea:  lda     #$80
        jsr     SetFlag0     ; set $3aa0.7 (allow battle menu to open)
; fall through

; ------------------------------------------------------------------------------

; [ open battle menu (character) or add action to advance wait queue (monster) ]

; adds a character to the menu queue

_c211ef:
_inputwindowopen:
@11ef:  cpx     #$08
        bcs     _120e       ; branch if a monster
        lda     near wTargetProp1::w7e3205,x
        bpl     _11ba       ; return if $3205.7 is clear
        lda     zb1
        bmi     _11ba       ; return if battle menus are disabled
        lda     #$04
        jsr     SetFlag0     ; set $3aa0.2 (ogre nix can't break)
.if LANG_EN
        lda     near wTargetProp2::ExtraStatus,x     ; set carry if using control battle menu ($3e4d.0)
        lsr
.else
        lda     near wTargetProp3::w7e3ef9,x         ; isolate control status
        asl4
.endif
        txa
        ror
        sta     $10         ; $10 = attacker, msb set if using control
        lda     #BTL_GFX::OPEN_MENU
        jmp     ExecBtlGfx

autocommand:
_120e:  jmp     _c24e66       ; add action to advance wait queue

; ------------------------------------------------------------------------------

; [ decrement morph counter ]

DecMorphCounter:
@1211:  longa
        sec
        lda     near w7e3f30       ; decrement morph counter
        sbc     near wMorphRate
        sta     near w7e3f30
        shorta
        bcs     @1234       ; branch if counter didn't expire
        stz     near w7e3f30_H       ; clear morph counter
        jsr     SaveMorphCounter
        lda     #$ff
        sta     near w7e3ee2       ; clear morphed character index
        lda     #BATTLE_CMD::REVERT
        sta     near w7e3a7a       ; command $04 (revert)
        jsr     CreateRetalAction
@1234:  lda     near w7e3f30_H
        sta     near wTargetProp2::w7e3b04,x     ; update visible morph gauge value
        rts

; ------------------------------------------------------------------------------
