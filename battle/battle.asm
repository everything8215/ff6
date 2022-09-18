
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle.asm                                                           |
; |                                                                            |
; | description: battle program                                                |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "battle_data.asm"

.import CharProp, ItemProp

.export Battle_ext, UpdateBattleTime_ext
.export UpdateEquip_ext, CalcMagicEffect_ext

; ------------------------------------------------------------------------------

.segment "battle_code"
.a8
.i16

; ------------------------------------------------------------------------------

Battle_ext:
@0000:  jmp     BattleMain

UpdateBattleTime_ext:
@0003:  jmp     UpdateBattleTime

UpdateEquip_ext:
@0006:  jmp     UpdateEquip

CalcMagicEffect_ext:
@0009:  jmp     CalcMagicEffect

; ------------------------------------------------------------------------------

BattleMain:
@000c:  rtl

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
        jsr     Mult8
        longi
        tax
        lda     $15db,x                 ; actor number
        xba
        lda     #$16
        jsr     Mult8
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
        and     #$03
        eor     #$03
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
        jsr     CalcHPBoostFlag
        ora     $ff
        sta     $15ed,x
        lda     $15e9,x                 ; high byte of hp
        and     #$3f
        sta     $ff
        lda     #$08
        jsr     CalcHPBoostFlag
        ora     $ff
        sta     $15e9,x
        ldx     #$000a                  ; get high byte of each stat
@0f18:  lda     $11a1,x
        beq     @0f26                   ; branch if 0
        asl
        tdc
        bcs     @0f23                   ; branch if negative (set to 0)
        lda     #$ff                    ; max 255
@0f23:  sta     $11a0,x
@0f26:  dex                             ; next stat
        dex
        bpl     @0f18
        ldx     $11ce                   ; weapon hands
        jsr     (.loword(UpdateEquipTbl),x)
        lda     $11d7                   ; hyper wrist effect
        bpl     @0f42
        longa
        lda     $11a6                   ; vigor *= 1.5
        lsr
        clc
        adc     $11a6
        sta     $11a6
@0f42:  plp
        plb
        ply
        plx
        rtl

.a8

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

; $01: weapon in off-hand, $04: unarmed in main hand
UpdateEquip_01:
UpdateEquip_04:
@0f61:  jsr     Disable2Hand

; $09: unarmed in main hand, weapon in off hand
UpdateEquip_09:
@0f64:  stz     $11ac       ; main hand battle power = 0 (attack with off-hand)

; $00, $05, $07, $0a, $0b: impossible combinations
UpdateEquip_00:
UpdateEquip_05:
UpdateEquip_07:
UpdateEquip_0a:
UpdateEquip_0b:
@0f67:  rts

; $02: weapon in main hand, $08: unarmed in main hand, $0c: unarmed in both hands
UpdateEquip_02:
UpdateEquip_08:
UpdateEquip_0c:
@0f68:  jsr     Disable2Hand

; $06: weapon in main hand, unarmed in off-hand
UpdateEquip_06:
@0f6b:  stz     $11ad       ; off-hand battle power = 0 (attack with main hand)
        rts

; $03: weapon in main hand and off-hand (genji glove)
UpdateEquip_03:
@0f6f:  lda     #$10
        tsb     $11cf

Disable2Hand:
@0f74:  lda     #$40
        trb     $11da
        trb     $11db
        rts

; ------------------------------------------------------------------------------

; [ update hp/mp boost flag ]

CalcHPBoostFlag:
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
@0f98:  tdc                 ; no boost
        rts

; ------------------------------------------------------------------------------

; [ update equipped item effects ]

; A: item number

CalcEquipEffect:
@0f9a:  phx
        phy
        xba
        lda     #$1e                    ; multiply by 30 to get pointer to item data
        jsr     Mult8
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
        eor     #$20                    ; toggle imp status
@1029:  bit     #$20
        bne     @1030                   ; branch if imp
        lda     #$01
        xba
@1030:  xba
        sta     $fd                     ; $fd = battle/defense power (or 0 if imp)
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
@1086:  tdc
        lda     f:ItemProp+27,x         ; block animation
        sta     $11be,y
        bit     #$0c
        beq     @10b0                   ; branch if item can't block
        pha
        and     #$03                    ; block graphic
        tax
        tdc
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
@10b2:  tdc
        inc
        tay
        inc
        sta     $ff
        lda     $01,s                   ; item slot
        cmp     #$02
        bcs     @1076                   ; branch if not in a hand
        dec
        beq     @10c4                   ; branch if off-hand
        dey
        asl     $ff
@10c4:  lda     $11c6,y                 ; weapon number
        inc
        bne     @10ce                   ; branch if not unarmed
        asl     $ff
        asl     $ff
@10ce:  lda     $ff
        tsb     $11ce                   ; set weapon hand bit
        lda     f:ItemProp+22,x         ;
        sta     $11b2,y
        lda     f:ItemProp+15,x         ; elemental properties
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
@1105:  .word   0
        .word   10
        .word   20
        .word   30
        .word   40
        .word   50
        .word   .loword(-10)
        .word   .loword(-20)
        .word   .loword(-30)
        .word   .loword(-40)
        .word   .loword(-50)

; ------------------------------------------------------------------------------

UpdateBattleTime:
@111b:  rtl

; ------------------------------------------------------------------------------

CalcMagicEffect:
@4730:  rtl

; ------------------------------------------------------------------------------

; [ multiply a * b ]

Mult8:
@4781:  php
        longa
        sta     f:$004202
        nop4
        lda     f:$004216
        plp
        rts

; ------------------------------------------------------------------------------
