; ------------------------------------------------------------------------------

; [ remove character from party ]

; used to remove Shadow, Gau, and Ghosts

RemoveChar:
@47e3:  phx
        lda     near w7e3ed8 + 1,x     ; character number
        tax
        stz     $1850,x     ; remove character from party
        plx
_47ec:  rts

; ------------------------------------------------------------------------------

; [ check if battle is over ]

CheckBattleEnd:
@47ed:  lda     near w7e3ee0       ; branch if end of battle special events are disabled
        beq     @47fb
        lda     near w7e3a6e       ; end of battle special event
        beq     @47fb
        tax
        jmp     (near BattleEndTbl-2,x)

; no special event
@47fb:  lda     $1dd1       ; end battle if timer expires flag
        and     #$20
        beq     @4807
        tsb     near w7e3eb0 + 12       ; update battle termination flag
        bra     @4820
@4807:  lda     near w7e3a95       ; return if last monster is hidden (ai command $f5)
        bne     _47ec
        lda     near w7e3a74_L       ; branch if any characters are still alive
        bne     @4833
        lda     near w7e3a8a       ; engulfed targets
        beq     @4822       ; branch if no one was engulfed
        cmp     near w7e3a8d
        bne     @4822       ; branch if not everyone was engulfed
        lda     #$80        ; set "zone eater just ate you" flag
        tsb     near w7e3eb0 + 12
@4820:  bra     BattleEnd_04
@4822:  lda     near w7e3a39       ; branch if there are any sneezed targets
        bne     BattleEnd_01
        lda     near w7e3a97       ; branch if any characters are in colosseum mode
        bne     @482e
        lda     #ATTACK_MSG::LOSE_BATTLE
@482e:  jsr     LoseBattle
        bra     _488f
@4833:  lda     near w7e3a77       ; return if any monsters are still alive
        bne     _47ec
        lda     near w7e3ee0       ; branch if end of battle special event is enabled
        bne     @4840
        jsr     CheckFinalBattle

; check if gau joins
@4840:  ldx     .loword(array_item w7e3000, CHAR::GAU)
        bmi     @4861       ; branch if gau is not in the party
        lda     #$01
        trb     $11e4
        beq     @4861       ; branch if gau can't appear after battle
        jsr     Rand
        cmp     #$a0
        bcs     @4861       ; 5/8 chance to branch
        lda     near w7e3eb0 + 13
        bit     #$02
        bne     GauAppears       ; branch if gau has been obtained
        lda     near w7e3a76
        cmp     #2
        bcs     GauAppears       ; branch if more than 2 characters are left

; check if shadow leaves
@4861:  ldx     .loword(array_item w7e3000, CHAR::SHADOW)
        bmi     @488c       ; branch if shadow is not in the party
        jsr     Rand
        cmp     #$10
        bcs     @488c       ; 15/16 chance to branch
        lda     near w7e201f
        bne     @488c
        lda     near w7e3a76
        cmp     #2
        bcc     @488c
        lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS12, {DEAD, PETRIFY, ZOMBIE}
        bne     @488c
        lda     #CHAR_FLAG::SHADOW
        bit     near w7e3eb0 + 13       ; shadow won't leave after battle
        bne     @488c
        bit     $1ede       ; shadow is an available character
        bne     ShadowLeaves
@488c:  jsr     WinBattle
_488f:  jsr     UpdateSRAM
        pla                 ; remove return address from stack
        pla
        jmp     TerminateBattle

; ------------------------------------------------------------------------------

; [ end of battle special event $01: ran out of time before emperor's banquet ]

; also warp/warp stone

BattleEnd_01:
@4897:  lda     #$ff
        sta     $0205
        lda     #$10        ; set "ran out of time before emperor's banquet" flag
        tsb     near w7e3eb0 + 12
; fall through

; ------------------------------------------------------------------------------

; [ end of battle special event $04: end battle immediately ]

BattleEnd_04:
@48a1:  jsr     _c24903       ; init graphics for end of battle
        bra     _488f

; ------------------------------------------------------------------------------

; shadow leaves the party
ShadowLeaves:
@48a6:  trb     $1ede       ; available characters (remove shadow)
        jsr     RemoveChar
        longi
        ldy     near w7e3010,x
        lda     #$ff
        sta     $161e,y
        shorti
        lda     #$fe
        jsr     ClearFlag0       ; clear $3aa0.0 (make target not present)
        lda     #$02
        tsb     near w7e2f49       ; disable fanfare
        ldx     #BATTLE_EVENT_SCRIPT::SHADOW_LEAVES_PARTY
_48c4:  pla
        pla
        lda     #ACTION_BATTLE_CMD::BATTLE_EVENT
        jsr     CreateImmediateAction
        jmp     BattleLoop

; gau shows up
GauAppears:
@48ce:  lda     near wTargetMask,x     ; gau's character mask
        tsb     near w7e2f4e       ; gau can be targetted
        tsb     near w7e3a40       ; gau acts like an enemy
        lda     #$04
        tsb     near w7e3a46       ; clear all pending actions ($3a46.2)
        ldx     #BATTLE_EVENT_SCRIPT::GAU_APPEARS
        bra     _48c4

; ------------------------------------------------------------------------------

; [ end of battle special event $02: gau leaped ]

BattleEnd_02:
@48e0:  ldx     .loword(array_item w7e3000, CHAR::GAU)
        jsr     RemoveChar
        lda     #>CHAR_FLAG::GAU
        trb     $1edf       ; remove from available characters
; fall through

; ------------------------------------------------------------------------------

; [ end of battle special event $05: gau learned rages ]

BattleEnd_05:
@48eb:  jsr     LearnRage
        bra     _488f

; ------------------------------------------------------------------------------

; [ end of battle special event $03: banon died ]

BattleEnd_03:
@48f0:  lda     #$36        ; battle message $36 "banon fell_"
        jsr     LoseBattle
        bra     _488f

; ------------------------------------------------------------------------------

; jump code for end of battle special events
BattleEndTbl:
@48f7:  .addr   BattleEnd_01
        .addr   BattleEnd_02
        .addr   BattleEnd_03
        .addr   BattleEnd_04
        .addr   BattleEnd_05
        .addr   BattleEnd_06

; ------------------------------------------------------------------------------

; [ init graphics for end of battle ]

_c24903:
_winallclose:
@4903:  jsr     SaveMorphCounter
        ldx     #$06
@4908:  stz     near wTargetProp2::w7e3b04,x     ; hide morph gauge
        txa
        lsr
        sta     $10
        lda     #BTL_GFX::CLOSE_MENU
        jsr     ExecBtlGfx
        dex2                ; next character
        bpl     @4908
        lda     #$80        ; disable battle menus opening
        tsb     zb1
        ldx     #$20        ; wait 32 frames
@491e:  lda     #BTL_GFX::WAIT_FRAME
        jsr     ExecBtlGfx
        dex
        bne     @491e
        lda     #$0f        ; check if any characters obtained an item
        tsb     near w7e3a8c
        jsr     _c262c7       ; add obtained items to inventory
        lda     #BTL_GFX::UPDATE_INVENTORY
        jsr     ExecBtlGfx
        jmp     UpdateCharProp

; ------------------------------------------------------------------------------

; [ update sram after battle ]

UpdateSRAM:
@4936:  ldx     #$06
@4938:  lda     near w7e3ed8,x     ; actor number
        bmi     @497b       ; skip if no character in this slot
        cmp     #CHAR_PROP::GHOST_1
        beq     @4945       ; branch if $10 (ghost #1)
        cmp     #CHAR_PROP::GHOST_2
        bne     @494c       ; branch if not $11 (ghost #2)
@4945:  lda     near wTargetProp3::w7e3ee4,x     ; status 1
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @4954       ; branch if zombie, petrify, or wound
@494c:  lda     near wTargetMask,x
        bit     near w7e3a88
        beq     @4957       ; branch if not possessed
@4954:  jsr     RemoveChar
@4957:  lda     near wTargetProp3::w7e3ef9,x     ; status 4
        andflg  STATUS4, {FLOAT, INTERCEPTOR}
        xba
        lda     near wTargetProp3::w7e3ee4,x     ; status 1
        longai
        ldy     near w7e3010,x     ; pointer to character data
        sta     $1614,y     ; set character status
        lda     near wTargetProp2::CurrHP,x     ; current hp
        sta     $1609,y
        lda     near wTargetProp2::MaxMP,x     ; branch if max mp is 0
        beq     @4979
        lda     near wTargetProp2::CurrMP,x     ; current mp
        sta     $160d,y
@4979:  shortai
@497b:  dex2                ; next character
        bpl     @4938
        longi
        ldx     #$00ff
        ldy     #$04fb
@4987:  lda     near wItemList::ItemID,y     ; copy item number
        sta     $1869,x
        inc
        beq     @4993       ; branch if item slot is empty
        lda     near wItemList::Qty,y     ; copy item quantity
@4993:  sta     $1969,x
        dey5                ; next item
        dex
        bpl     @4987
        lda     near w7e3a97
        beq     @49c4       ; branch if colosseum battle
        lda     $0205       ; item wagered
        cmp     #$ff
        beq     @49c4       ; branch if empty
        ldx     #$00ff
@49ad:  cmp     $1869,x     ; find the item in inventory
        bne     @49c1
        dec     $1969,x     ; decrement quantity
        beq     @49b9
        bpl     @49c1
@49b9:  lda     #$ff
        sta     $1869,x     ; set empty if there are none remaining
        stz     $1969,x     ; set quantity to zero
@49c1:  dex
        bpl     @49ad
@49c4:  shorti
        ldx     near wDoomGaze
        bmi     @49d5       ; branch if not present
        longa
        lda     near wTargetProp2::CurrHP,x     ; save doom gaze's hp
        sta     near w7e3eb0 + 14
        shorta
@49d5:  ldx     #$13        ; copy global battle variables
@49d7:  lda     near w7e3eb0 + 4,x
        sta     $1dc9,x
        dex
        bpl     @49d7
        lda     near w7e2f4b
        bit     #$02
        bne     @4a06       ; return if formation can't appear on the veldt
        ldx     #$0a
@49e9:  lda     near w7e2001 + 1,x     ; high byte of monster index
        bne     @4a02       ; skip if monster index >= 256 (can't appear on the veldt)
        lda     near wBattleID_H       ; high byte of battle index
        lsr
        bne     @4a06       ; branch if battle index >= 512 (can't appear on the veldt)
        lda     near wBattleID
        jsr     GetBitPtr
        ora     $1ddd,x     ; add to available veldt battles
        sta     $1ddd,x
        bra     @4a06
@4a02:  dex2                ; check next monster
        bpl     @49e9
@4a06:  rts

; ------------------------------------------------------------------------------

; [ learn rages ]

LearnRage:
@4a07:  ldx     #$0a
@4a09:  lda     near w7e2001 + 1,x     ; high bit of monster index
        bne     @4a1d       ; skip if monster index > 255 (can't learn rage)
        phx
        clc
        lda     near w7e2001,x     ; monster number
        jsr     GetBitPtr
        ora     $1d2c,x     ; add to known rages
        sta     $1d2c,x
        plx
@4a1d:  dex2                ; next monster
        bpl     @4a09
        rts

; ------------------------------------------------------------------------------

; [ end of battle special event $06: scroll background for final battle ]

BattleEnd_06:
@4a22:  jsr     EndAction
        jsr     _c24903       ; init graphics for end of battle
        jsr     UpdateSRAM
        ldx     #$12
@4a2d:  cpx     #$08
        bcs     @4a65       ; branch if a monster
        lda     near wTargetProp2::w7e3aa0,x
        lsr
        bcc     @4a54       ; $3aa0.0 branch if character is not present
        lda     near wTargetProp3::w7e3ee4,x
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @4a54
        lda     near wTargetProp1::w7e3205,x
        bit     #$04
        beq     @4a54       ; branch if character has air anchor effect ($3205.2)
        longa
        lda     near wTargetProp3::w7e3ef8,x     ; status 3 & 4
        clrflg  STATUS34, {DANCE, RAGE, CONTROL}
        sta     near wTargetProp3::w7e3ef8,x
        shorta
        bra     @4a68
@4a54:  lda     #$ff
        sta     near w7e3ed8,x     ; clear actor
        lda     near wTargetMask,x
        trb     near w7e3f2c       ; clear jump/seize characters
        trb     near w7e3f2e       ; clear characters with an esper equipped
        trb     near w7e3f2f       ; clear characters that have used a desperation attack
@4a65:  jsr     FinalBattleClearStatus
@4a68:  dex2                ; next character
        bpl     @4a2d
        lda     #BTL_GFX::FINAL_BATTLE_SCROLL
        jsr     ExecBtlGfx
        pla
        pla
        jmp     RestartBattle

; ------------------------------------------------------------------------------

; [ check final battle progression ]

CheckFinalBattle:
@4a76:  longa
        ldx     #4
@4a7a:  lda     f:FinalBattleIDTbl,x
        cmp     $11e0
        bne     @4a97
        lda     f:FinalBattleIDTbl+2,x   ; load the next battle
        sta     $11e0
        shorta
        lda     f:FinalBattleScrollTbl,x
        sta     near w7e3ee1
        pla                             ; remove return address from stack
        pla
        bra     BattleEnd_06
@4a97:  dex2
        bpl     @4a7a
        shorta
        rts

; ------------------------------------------------------------------------------

; [ clear all statuses ]

FinalBattleClearStatus:
@4a9e:  stz     near wTargetProp3::w7e3ee4,x
        stz     near wTargetProp3::w7e3ee5,x
        stz     near wTargetProp3::w7e3ef8,x
        stz     near wTargetProp3::w7e3ef9,x
        rts

; ------------------------------------------------------------------------------

; final battles
FinalBattleIDTbl:
@4aab:  .word   $01d7                   ; statue part 1
        .word   $0200                   ; statue part 2
        .word   $0201                   ; statue part 3
        .word   $0202                   ; final kefka

; ------------------------------------------------------------------------------

; [ final battle scrolling data ]

; two bytes per battle, the second byte is an unused copy of the first byte
; do the background scroll if MSB set
; lower bits seem to indicate which monster entry type to use,
; but in reality I don't think they do anything.

FinalBattleScrollTbl:
@4ab3:  .byte   $90,$90
        .byte   $90,$90
        .byte   $8f,$8f

; ------------------------------------------------------------------------------

; [ update living/dead targets ]

UpdateDead:
@4ab9:  longa
        lda     near w7e2f4c       ; characters/monsters that can't be targetted
        not_a
        and     near w7e2f4e       ; clear bits in characters/monsters that can be targetted
        sta     near w7e2f4e
        sta     near w7e3a78       ;
        stz     near w7e3a74       ; clear characters/monsters that are alive
        stz     near w7e3a42       ; clear enemy characters that are alive
        shorta

; check characters
        ldx     #$06
@4ad4:  lda     near wTargetProp2::w7e3aa0,x     ; $3aa0.0 move "target present" flag to carry
        lsr
        lda     near wTargetMask,x     ; character mask
        bit     near w7e2f4c
        bne     @4b02       ; skip if character can't be targetted
        bit     near w7e2f4e
        bne     @4af3       ; branch if character can be targetted
        bcc     @4b02       ; skip if character is not present
        tsb     near w7e3a78_L       ;
        xba
        lda     near wTargetProp3::w7e3ee4,x     ; status 1
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @4b02       ; skip if wound, petrify, or zombie
        xba
@4af3:  and     near w7e3408_L       ;
        tsb     near w7e3a74_L       ; set character as alive
        and     near w7e3a40       ; clear characters acting as enemies
        tsb     near w7e3a42       ; set enemy characters that are alive
        trb     near w7e3a74_L       ; clear characters that are alive
@4b02:  dex2                ; next character
        bpl     @4ad4

; check monsters
        ldx     #$0a
@4b08:  lda     near wTargetProp2::_4::w7e3aa0,x     ; move "target present" flag to carry
        lsr
        lda     near wTargetMask::_4 + 1,x     ; monster mask
        bit     near w7e2f4c + 1
        bne     @4b32       ; skip if monster can't be targetted
        bit     near w7e2f4e + 1
        bne     @4b2c       ; branch if monster can be targetted
        bcc     @4b32       ; skip if monster is not present
        tsb     near w7e3a78_H       ;
        bit     near w7e3a3a
        bne     @4b32       ;
        xba
        lda     near wTargetProp3::_4::w7e3ee4,x     ; status 1
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @4b32       ; skip if wound, petrify, or zombie
        xba
@4b2c:  and     near w7e3408_H       ;
        tsb     near w7e3a74_H       ; set monster as alive
@4b32:  dex2                ; next monster
        bpl     @4b08
        phx
        php
        lda     near w7e3a74_L       ; allies that are alive
        jsr     CountBits
        stx     near w7e3a76       ; set number of allies that are alive
        lda     near w7e3a74_H       ; monsters that are alive
        xba
        lda     near w7e3a42       ; enemy characters that are alive
        longa
        jsr     CountBits
        stx     near w7e3a77       ; set number of enemies that are alive
        plp
        plx
        rts

; ------------------------------------------------------------------------------
