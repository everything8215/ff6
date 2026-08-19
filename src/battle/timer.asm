; ------------------------------------------------------------------------------

; [ decrement status counters ]

DecCounters:
@5a83:  .a8
        lda     near w7e3a91       ; increment counter for checking status counters
        inc     near w7e3a91
        and     #$0f
        cmp     #$0a
        bcs     @5ae1       ; branch if greater than 10

; frame 0-9 (status counters for each character/monster)
        asl
        tax                             ; otherwise, use it as a character/monster index
        lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     _5ae9                   ; return if $3aa0.0 is clear (target is not present)
        clc
        lda     near wTargetProp2::w7e3adc,x ; slow/normal/haste counter
        adc     near wTargetProp2::w7e3add,x ; add constant (+32/+64/+84)
        sta     near wTargetProp2::w7e3adc,x
        bcc     _5ae9                   ; return if it didn't overflow
        lda     near wTargetProp2::w7e3af1,x
        beq     @5ab1                   ; branch if stop counter is 0
        dec     near wTargetProp2::w7e3af1,x ; decrement stop counter
        bne     _5ae9
        lda     #$01                    ; stop just wore off
        bra     _c25b06                 ; decrement reflect, freeze, sleep counters
@5ab1:  lda     near wTargetProp2::w7e3aa0,x
        bit     #$10
        bne     _5ae9                   ; return if $3aa0.4 is set
        lda     near wTargetProp2::w7e3b05,x
        cmp     #$02
        bcc     @5ac9                   ; branch if the condemned number is less than 2
        dec
        sta     near wTargetProp2::w7e3b05,x ; decrement the condemned number
        dec
        bne     @5ac9
        jsr     CondemnDeath
@5ac9:  jsr     CheckRunAway
        jsr     _c25b4f
        clr_a                           ; stop did not just wear off
        jsr     _c25b06                 ; decrement reflect, freeze, sleep counters
        inc     near wTargetProp2::w7e3af0,x                 ; increment dot counter
        lda     near wTargetProp2::w7e3af0,x
        txy
        and     #$07
        asl
        tax
        jmp     (near StatusCounterTbl,x)

; frame 10-15 (global counters)
@5ae1:  sbc     #$0a
        asl
        tax
        jmp     (near GlobalCounterTbl,x)

; ------------------------------------------------------------------------------

StatusCounter_01:
StatusCounter_03:
StatusCounter_05:
StatusCounter_06:
StatusCounter_07:
@5ae8:  tyx

GlobalCounter_02:
GlobalCounter_03:
GlobalCounter_04:
_5ae9:  rts

; ------------------------------------------------------------------------------

; jump table for damage over time counters
StatusCounterTbl:
@5aea:  .addr   StatusCounter_00
        .addr   StatusCounter_01
        .addr   StatusCounter_02
        .addr   StatusCounter_03
        .addr   StatusCounter_04
        .addr   StatusCounter_05
        .addr   StatusCounter_06
        .addr   StatusCounter_07

; jump table for frame 10-15 (enemy roulette, run away, increment battle/character/monster counters)
GlobalCounterTbl:
@5afa:  .addr   GlobalCounter_00
        .addr   GlobalCounter_01
        .addr   GlobalCounter_02
        .addr   GlobalCounter_03
        .addr   GlobalCounter_04
        .addr   GlobalCounter_05

; ------------------------------------------------------------------------------

; [ decrement reflect, freeze, sleep counters ]

; $b8: ----pfrs (out)
;      p: psyche (sleep) just wore off
;      f: freeze just wore off
;      r: reflect just wore off
;      s: stop just wore off

_c25b06:
timer:

; decrement reflect counter
@5b06:  sta     zb8_L
        lda     near wTargetProp3::ReflectCounter,x
        beq     @5b16
        dec     near wTargetProp3::ReflectCounter,x
        bne     @5b16
        lda     #$02
        tsb     zb8_L

; decrement freeze counter
@5b16:  lda     near wTargetProp3::FreezeCounter,x
        beq     @5b24
        dec     near wTargetProp3::FreezeCounter,x
        bne     @5b24
        lda     #$04
        tsb     zb8_L

; decrement psyche (sleep) counter
@5b24:  lda     near wTargetProp2::SleepCounter,x
        beq     @5b32
        dec     near wTargetProp2::SleepCounter,x
        bne     @5b32
        lda     #$08
        tsb     zb8_L

; return if no counters hit zero
@5b32:  lda     zb8_L
        beq     _5ae9
        lda     #ACTION_BATTLE_CMD::STATUS_TIMER_EXPIRED
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; 2: trigger poison damage (once every 8 frames)
StatusCounter_02:
@5b3b:  tyx
        lda     near wTargetProp2::RetalFlags,x     ; set $3e4c.4 (poison counter triggered)
        ora     #RETAL_FLAGS::POISON_TRIGGER
        sta     near wTargetProp2::RetalFlags,x
        rts

; ------------------------------------------------------------------------------

; 0,4: trigger regen, sap, phantasm damage (twice every 8 frames)
StatusCounter_00:
StatusCounter_04:
@5b45:  tyx
        lda     near wTargetProp2::RetalFlags,x     ; set $3e4c.3 (regen/seize/phantasm counter triggered)
        ora     #RETAL_FLAGS::REGEN_TRIGGER
        sta     near wTargetProp2::RetalFlags,x
_5b4e:  rts

; ------------------------------------------------------------------------------

; [ create dot action (poison/regen/seize/phantasm) ]

_c25b4f:
rigenetimer:
@5b4f:  lda     #$10
        bit     near wTargetProp2::w7e3aa1,x
        bne     _5b4e       ; return if $3aa1.4 is set (character already has a pending dot action)
        lda     near wTargetProp2::RetalFlags,x
        bit     #RETAL_FLAGS::POISON_TRIGGER
        beq     @5b6b       ; branch if poison counter didn't just trigger ($3e4c.4)
        and     #<~RETAL_FLAGS::POISON_TRIGGER
        sta     near wTargetProp2::RetalFlags,x     ; clear poison trigger ($3e4c.4)
        lda     near wTargetProp3::w7e3ee4,x
        and     #STATUS1::POISON
        beq     _5b4e       ; return if target does not have poison status
        bra     @5b85
@5b6b:  bit     #RETAL_FLAGS::REGEN_TRIGGER
        beq     @5b92       ; branch if regen/sap/phantasm counter didn't just trigger ($3e4c.3)
        and     #<~RETAL_FLAGS::REGEN_TRIGGER
        sta     near wTargetProp2::RetalFlags,x     ; clear regen/sap/phantasm trigger ($3e4c.3)
        lda     near wTargetProp3::w7e3ee5,x         ; STATUS2::SAP
        ora     near wTargetProp2::ExtraStatus,x     ; isolate phantasm and sap status
        and     #STATUS2::SAP
        bne     @5b85       ; branch if target has phantasm or sap status
        lda     near wTargetProp3::w7e3ef8,x
        and     #STATUS3::REGEN
        beq     _5b4e       ; return if target doesn't have regen status
@5b85:  sta     near w7e3a7b
        lda     #ACTION_BATTLE_CMD::POISON_REGEN
        sta     near w7e3a7a
        jsr     CreateRetalAction
        bra     @5ba9
@5b92:  ldy     near wTargetProp1::SeizeTarget,x
        bmi     _5b4e       ; return if seize target is invalid
        longa
        lda     near wTargetMask,y     ; bitmask of target
        sta     zb8
        lda     #ACTION_BATTLE_CMD::SEIZE_DMG
        sta     near w7e3a7a
        shorta
        jsr     CreateRetalAction
@5ba9:  lda     #$10
; fallthrough

SetFlag1:
@5bab:  ora     near wTargetProp2::w7e3aa1,x     ; set $3aa1.4 (character has a pending dot action)
        sta     near wTargetProp2::w7e3aa1,x
        rts

; ------------------------------------------------------------------------------

; 10: roulette (monster attacker)
GlobalCounter_00:
@5bb2:  lda     near w7e2f42 + 1           ; selected roulette target (from btlgfx)
        bmi     _5b4e           ; return if target is invalid
        longa
        lda     near w7e2f42
        jsr     BitToTargetID
        clr_a
        dec
        sta     near w7e2f42           ; invalidate roulette target
        shorta
        tyx
; fallthrough

; ------------------------------------------------------------------------------

; [ condemned effect (cast doom) ]

CondemnDeath:
@5bc7:  lda     #ATTACK::DOOM
        sta     zb8_L
        lda     #ACTION_BATTLE_CMD::IMMEDIATE_ACTION
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; 15: run away
GlobalCounter_05:
@5bd0:  lda     near w7e2f45
        beq     _5c1a       ; return if characters are not trying to run away
        lda     zb1
        bit     #$02
        bne     _5bf1       ; branch if can't run away
        lda     near w7e3a91
        and     #$70
        bne     _5c1a       ; return if ... (status counter)
; fallthrough

; ------------------------------------------------------------------------------

; [ create immediate action to run away ]

; create run away action
CreateRunAwayAction:
@5be2:  lda     near w7e2f45
        beq     _5c1a
        lda     near w7e3a38
        beq     _5c1a       ; return if no characters just escaped
        lda     near w7e3a97
        bne     _5c1a       ; return if in colosseum mode
_5bf1:  lda     #$04
        tsb     zb0
        bne     _5c1a       ;
        lda     #ACTION_BATTLE_CMD::RUN_AWAY
        jmp     CreateImmediateAction

; ------------------------------------------------------------------------------

; 11: increment battle counter and character/monster timers (every 16 frames)
GlobalCounter_01:
@5bfc:  php
        longa
        inc     near w7e3a44       ; increment battle counter
        ldx     #$12
@5c04:  lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @5c15       ; branch if $3aa0.0 is clear (target is not present)
        lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS12, {PETRIFY, DEAD}
        bne     @5c15
        inc     near wTargetProp2::MonsterTimer,x     ; increment character/monster timer
@5c15:  dex2
        bpl     @5c04
        plp
_5c1a:  rts

; ------------------------------------------------------------------------------

; [ try to run away ]

CheckRunAway:
@5c1b:  cpx     #$08
        bcs     @5c53        ; return if a monster
        lda     near w7e2f45
        beq     @5c53
        lda     near w7e3a39
        ora     near w7e3a40
        bit     near wTargetMask,x
        bne     @5c53
        lda     near w7e3a3b
        bne     @5c3a
        jsr     @5c4d
        jmp     CreateRunAwayAction
@5c3a:  lda     near wTargetProp2::w7e3d71,x     ; run probability
        jsr     RandA
        inc
        clc
        adc     near wTargetProp2::w7e3d70,x     ; add to run counter
        sta     near wTargetProp2::w7e3d70,x
        cmp     near w7e3a3b       ; compare to run difficulty
        bcc     @5c53
@5c4d:  lda     near wTargetMask,x
        tsb     near w7e3a38       ; character just ran away
@5c53:  rts

; ------------------------------------------------------------------------------
