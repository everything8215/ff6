
; ------------------------------------------------------------------------------

; [ update character battle stats ]

; A: character number

UpdateEquip:
@0e77:  phx
        phy
        phb
        php
        shortai
        pha
        and     #$0f
        lda     #$7e
        pha
        plb
        pla
        ldx     #$3e
@0e87:  stz     $11a0,x                 ; clear $11a0-$11de
        dex
        bpl     @0e87
        inc                             ; increment character number
        xba
        lda     #$25
        jsr     MultAB
        longi
        tax
        lda     $15db,x                 ; actor number
        xba
        lda     #$16
        jsr     MultAB
        phx
        tax
        lda     f:CharProp+10,x         ; battle power
        sta     $11ac
        sta     $11ad
        longa
        lda     f:CharProp+11,x         ; defense & magic defense
        sta     $11ba
        lda     f:CharProp+13,x         ; evade & magic block
        shorta
        sta     $11a8
        xba
        sta     $11aa
        lda     f:CharProp+21,x         ; run factor
        and     #CHAR_RUN_FACTOR::MASK
        eor     #CHAR_RUN_FACTOR::MASK
        inc2
        sta     $11dc
        plx
        ldy     #$0006                  ; magic power, stamina, speed, and vigor
@0ed3:  lda     $15f5,x
        sta     $11a0,y
        inx
        dey2
        bpl     @0ed3
        lda     $15eb,x                 ; current status 1
        sta     $fe
        ldy     #5
@0ee6:  lda     $15fb,x                 ; equipment
        sta     $11c6,y
        jsr     CalcEquipEffect
        dex
        dey
        bpl     @0ee6                   ; next item
        lda     $15ed,x                 ; high byte of mp
        and     #$3f
        sta     $ff
        lda     #$40
        jsr     CheckHPBoost
        ora     $ff
        sta     $15ed,x
        lda     $15e9,x                 ; high byte of hp
        and     #$3f
        sta     $ff
        lda     #$08
        jsr     CheckHPBoost
        ora     $ff
        sta     $15e9,x
        ldx     #$000a                  ; get high byte of each stat
@0f18:  lda     $11a1,x
        beq     @0f26                   ; branch if 0
        asl
        clr_a
        bcs     @0f23                   ; branch if negative (set to 0)
        lda     #$ff                    ; max 255
@0f23:  sta     $11a0,x
@0f26:  dex2                            ; next stat
        bpl     @0f18
        ldx     $11ce                   ; weapon hands
        jsr     (near UpdateEquipTbl,x)
        lda     $11d7                   ; RELIC_EFFECT3::STRENGTH_PLUS_50 (hyper wrist)
        bpl     @0f42
        longa
        lda     $11a6                   ; vigor *= 1.5
        lsr
        clc
        adc     $11a6
        sta     $11a6
@0f42:  plp
        .a8
        plb
        ply
        plx
        rtl

; ------------------------------------------------------------------------------

; 2-handed weapon effects jump table
UpdateEquipTbl:
@0f47:  .addr   UpdateEquip_00
        .addr   UpdateEquip_01
        .addr   UpdateEquip_02
        .addr   UpdateEquip_03
        .addr   UpdateEquip_04
        .addr   UpdateEquip_05
        .addr   UpdateEquip_06
        .addr   UpdateEquip_07
        .addr   UpdateEquip_08
        .addr   UpdateEquip_09
        .addr   UpdateEquip_0a
        .addr   UpdateEquip_0b
        .addr   UpdateEquip_0c

; ------------------------------------------------------------------------------

; [ update 2-handed weapon effects ]

; $01: weapon in left hand, $04: unarmed in right hand
UpdateEquip_01:
UpdateEquip_04:
@0f61:  jsr     Disable2Hand
; fallthrough

; $09: unarmed in right hand, weapon in left hand
UpdateEquip_09:
@0f64:  stz     $11ac       ; right hand battle power = 0 (attack with left hand)
; fallthrough

; $00, $05, $07, $0a, $0b: impossible combinations
UpdateEquip_00:
UpdateEquip_05:
UpdateEquip_07:
UpdateEquip_0a:
UpdateEquip_0b:
@0f67:  rts

; $02: weapon in right hand, $08: unarmed in right hand, $0c: unarmed in both hands
UpdateEquip_02:
UpdateEquip_08:
UpdateEquip_0c:
@0f68:  jsr     Disable2Hand
; fallthrough

; $06: weapon in right hand, unarmed in left hand
UpdateEquip_06:
@0f6b:  stz     $11ad       ; left hand battle power = 0 (attack with right hand)
        rts

; $03: weapon in right hand and left hand (genji glove)
UpdateEquip_03:
@0f6f:  lda     #$10
        tsb     $11cf
; fallthrough

Disable2Hand:
@0f74:  lda     #$40
        trb     $11da
        trb     $11db
        rts

; ------------------------------------------------------------------------------

; [ update hp/mp boost flag ]

CheckHPBoost:
@0f7d:  bit     $11d5
        beq     @0f85
        lda     #$80        ; +50%
        rts
@0f85:  lsr
        bit     $11d5
        beq     @0f8e
        lda     #$40        ; +25%
        rts
@0f8e:  asl2
        bit     $11d5
        beq     @0f98
        lda     #$c0        ; +12.5%
        rts
@0f98:  clr_a               ; no boost
        rts

; ------------------------------------------------------------------------------

; [ update equipped item effects ]

; A: item number

CalcEquipEffect:
@0f9a:  phx
        phy
        xba
        lda     #$1e                    ; multiply by 30 to get pointer to item data
        jsr     MultAB
        tax
        lda     f:ItemProp+5,x          ; field effects
        tsb     $11df
        longa
        lda     f:ItemProp+6,x          ; status 1 & 2 protection
        tsb     $11d2
        lda     f:ItemProp+8,x          ; status 3 set and relic effects
        tsb     $11d4
        lda     f:ItemProp+10,x         ; relic effects
        tsb     $11d6
        lda     f:ItemProp+12,x
        tsb     $11d8
        lda     f:ItemProp+16,x         ; stat boosts
        ldy     #$0006
@0fcf:  pha
        and     #$000f
        bit     #$0008
        beq     @0fdc                   ; branch if positive boost
        eor     #$fff7
        inc
@0fdc:  clc
        adc     $11a0,y                 ; add to stat
        sta     $11a0,y
        pla
        lsr4
        dey2
        bpl     @0fcf
        lda     f:ItemProp+26,x         ; evade/mblock
        phx
        pha
        and     #$000f
        asl
        tax
        lda     f:EquipEvadeTbl,x       ; add boost value
        clc
        adc     $11a8
        sta     $11a8
        pla
        and     #$00f0
        lsr3
        tax
        lda     f:EquipEvadeTbl,x
        clc
        adc     $11aa
        sta     $11aa
        plx
        shorta
        lda     f:ItemProp+20,x         ; battle/defense power
        xba
        lda     f:ItemProp+2,x          ; imp bit
        asl2
        lda     $fe
        bcs     @1029                   ; branch if imp item
        eor     #STATUS1::IMP           ; toggle imp status
@1029:  bit     #STATUS1::IMP
        bne     @1030                   ; branch if imp
        lda     #1
        xba
@1030:  xba
        sta     $fd                     ; $fd = battle/defense power (or 1 if imp)
        lda     f:ItemProp,x            ; item type
        and     #$07
        dec
        beq     @10b2                   ; branch if weapon

; shield, helmet, armor, or relic
        lda     f:ItemProp+25,x         ; status 2 set
        tsb     $11bc
        lda     f:ItemProp+15,x         ; elements halved
        xba
        lda     f:ItemProp+24,x         ; element weak point
        longa
        tsb     $11b8
        lda     f:ItemProp+22,x         ; absorbed and nullified elements
        tsb     $11b6
        shorta
        clc
        lda     $fd
        adc     $11ba                   ; add item defense to character defense
        bcc     @1064
        lda     #$ff                    ; max 255
@1064:  sta     $11ba
        clc
        lda     f:ItemProp+21,x         ; add item magic defense to character magic defense
        adc     $11bb
        bcc     @1073
        lda     #$ff                    ; max 255
@1073:  sta     $11bb

; weapon jumps back in here
@1076:  ply
        lda     #$02                    ; clear earrings effect
        trb     $11d5                   ; clear double earring effect
        beq     @1086
        tsb     $11d7                   ; set single earring effect
        beq     @1086
        tsb     $11d5                   ; set double earring effect
@1086:  clr_a
        lda     f:ItemProp+27,x         ; block animation
        sta     $11be,y
        bit     #$0c
        beq     @10b0                   ; branch if item can't block
        pha
        and     #$03                    ; block graphic
        tax
        clr_a
        sec
@1098:  rol                             ; a = 1 << block graphic index
        dex
        bpl     @1098
        xba
        pla
        bit     #$04
        beq     @10a7                   ; branch if item doesn't block physical attacks
        xba
        tsb     $11d0                   ; set physical block graphic
        xba
@10a7:  bit     #$08
        beq     @10b0                   ; branch if item doesn't block magic attacks
        xba
        tsb     $11d1                   ; set magical block graphic
        xba
@10b0:  plx
        rts

; weapon

; $ff ---4321- indicates which hand the weapon is in
;       4: unarmed in right hand
;       3: unarmed in left hand
;       2: weapon in right hand
;       1: weapon in left hand

@10b2:  clr_a
        inc
        tay                             ; Y = 1
        inc
        sta     $ff                     ; $ff = 2
        lda     1,s                     ; item slot
        cmp     #2
        bcs     @1076                   ; branch if not in a hand
        dec
        beq     @10c4                   ; branch if left hand
        dey                             ; Y = 0
        asl     $ff                     ; $ff = 4
@10c4:  lda     $11c6,y                 ; weapon id
        inc
        bne     @10ce                   ; branch if not unarmed
        asl     $ff
        asl     $ff
@10ce:  lda     $ff
        tsb     $11ce                   ; set weapon hand bit
        lda     f:ItemProp+22,x         ; absorb elements (unused)
        sta     $11b2,y
        lda     f:ItemProp+15,x         ; elemental properties (left hand never used)
        sta     $11b0,y
        lda     $fd
        adc     $11ac,y                 ; add item battle power to character battle power
        bcc     @10ea
        lda     #$ff                    ; max 255
@10ea:  sta     $11ac,y
        lda     f:ItemProp+21,x         ; hit rate
        sta     $11ae,y
        lda     f:ItemProp+18,x         ; spell cast
        sta     $11b4,y
        lda     f:ItemProp+19,x         ; weapon special effects
        sta     $11da,y
        jmp     @1076

; ------------------------------------------------------------------------------

; evade/mblock boost values
EquipEvadeTbl:
@1105:  .addr   +0
        .addr   +10
        .addr   +20
        .addr   +30
        .addr   +40
        .addr   +50
        .addr   -10
        .addr   -20
        .addr   -30
        .addr   -40
        .addr   -50

; ------------------------------------------------------------------------------
