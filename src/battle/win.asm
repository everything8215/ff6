.import BushidoLevelTbl, LevelUpExp, LevelUpHP, LevelUpMP
.import GenjuProp, NaturalMagic, MonsterItems, BattleMagicPoints

; ------------------------------------------------------------------------------

; [ update party after victory ]

WinBattle:
@5d57:  .a8
        php
        jsr     EndAction
        ldx     #$06
@5d5d:  stz     near w7e2e98 + 1,x     ; clear all status 2 for graphics
        dex2
        bpl     @5d5d
        ldx     #$0b
@5d66:  stz     near w7e2f35,x     ; zero all message variables
        dex
        bpl     @5d66
        lda     #BTL_GFX::VICTORY
        jsr     ExecBtlGfx
        jsr     _c24903       ; init graphics for end of battle
        lda     near w7e3a97
        beq     @5d91       ; branch if not a colosseum battle

; colosseum victory
        lda     #1        ; item quantity = 1
        sta     near w7e2e75
        lda     $0207       ; variable 0 = item number
        sta     near w7e2f35
        jsr     LoadItemProp
        jsr     _c26279       ; add item to inventory
        lda     #ATTACK_MSG::WIN_ITEM
        jsr     ShowMsg
        plp
        rts

; normal victory
@5d91:  longi
        clr_a
        ldx     near wBattleID
        cpx     #$0200
        bcs     @5da0       ; branch if >= $0200 (no magic points)
        lda     f:BattleMagicPoints,x   ; $fb = number of magic points gained from battle
@5da0:  sta     $fb
        stz     $f0
        lda     near w7e3eb0 + 12       ; $f1 set if morph is available
        and     #$08
        sta     $f1
        longa
        ldx     #$000a
@5db0:  lda     near wTargetProp3::_4::w7e3ee4,x     ; status 1
        bitflg  STATUS12, {DEAD, PETRIFY, ZOMBIE}
        beq     @5dde       ; skip if not zombie, petrify, or wound
        lda     $11e4
        bit     #$0002
        bne     @5dcf       ; branch if on the veldt
        clc
        lda     near wTargetProp2::_4::MonsterExp,x     ; monster experience
        adc     near w7e2f35       ; add to variable 0
        sta     near w7e2f35
        bcc     @5dcf
        inc     near w7e2f35_B       ; high byte of variable 0
@5dcf:  clc
        lda     near wTargetProp2::_4::MonsterGil,x     ; monster gold
        adc     near w7e2f3e       ; add to variable 3
        sta     near w7e2f3e
        bcc     @5dde
        inc     near w7e2f3e_B       ; high byte of variable 3
@5dde:  dex2                ; next monster
        bpl     @5db0
        lda     near w7e2f35_L       ; total experience
        sta     $e8
        lda     near w7e2f35_H
        ldx     near w7e3a76       ; number of allies alive
        phx
        jsr     Div
        sta     $ec         ; +$ec = experience per character
        stx     $e9         ;  $e9 = remainder
        lda     $e8
        plx
        jsr     Div
        sta     near w7e2f35_L
        lda     $ec
        sta     near w7e2f35_H
        ora     near w7e2f35_L
        beq     @5e0e
        lda     #ATTACK_MSG::WIN_EXP
        jsr     ShowMsg
@5e0e:  shorta
        ldy     #$0006
@5e13:  lda     near wTargetMask,y     ; character mask
        bit     near w7e3a74_L
        beq     @5e73       ; skip if character is not alive
        lda     near wTargetProp2::RelicEffect5,y
        and     #RELIC_EFFECT5::DOUBLE_GP
        beq     @5e2f       ; branch if cat hood not equipped
        tsb     $f0
        bne     @5e2f
        asl     near w7e2f3e_L       ; double gold
        rol     near w7e2f3e_H
        rol     near w7e2f3e_B
@5e2f:  lda     near w7e3ed8,y     ; actor number
        cmp     #CHAR_PROP::TERRA
        bne     @5e49       ; branch if not terra
        lda     $f1
        beq     @5e49       ; branch if morph is not available
        tsb     $f0
        lda     $fb         ; number of magic points * 2
        asl
        adc     $1cf6       ; add to morph counter (max $ff)
        bcc     @5e46
        lda     #$ff
@5e46:  sta     $1cf6
@5e49:  ldx     near w7e3010,y     ; character mask
        jsr     AddExp
        lda     near wTargetProp2::RelicEffect5,y
        bit     #RELIC_EFFECT5::DOUBLE_EXP
        beq     @5e59       ; branch if exp. egg not equipped
        jsr     AddExp
@5e59:  lda     near w7e3ed8,y     ; actor number
        cmp     #CHAR_PROP::GOGO
        bcs     @5e73       ; branch if >= $0c (gogo)
        jsr     GetSpellListPtr
        ldx     near w7e3010,y
        phy
        jsr     LearnItemMagic
        lda     $161e,x
        bmi     @5e72       ; branch if no esper equipped
        jsr     LearnGenjuMagic
@5e72:  ply
@5e73:  dey2                ; next character
        bpl     @5e13
        lda     $f1         ;
        and     $f0
        beq     @5e8f
        lda     $fb         ; magic points
        beq     @5e8f       ; branch if no magic points gained
        sta     near w7e2f35_L       ; set variable 0
        stz     near w7e2f35_H
        stz     near w7e2f35_B
        lda     #ATTACK_MSG::WIN_MAGIC_POINTS
        jsr     ShowMsg
@5e8f:  ldy     #$0006
@5e92:  lda     near wTargetMask,y     ; character mask
        bit     near w7e3a74_L       ; skip if character is not alive
        beq     @5eb9
        lda     near w7e3ed8,y     ; actor number
        jsr     GetSpellListPtr
        ldx     near w7e3010,y
        tya
        lsr
        sta     near w7e2f38       ; set variable 1 to character number
        lda     #ATTACK_MSG::GAIN_LEVEL
        sta     $f2
        jsr     CheckLevelUp
        lda     near w7e3ed8,y
        cmp     #CHAR_PROP::GOGO
        bcs     @5eb9       ; branch if actor >= $0c (gogo)
        jsr     ShowLearnedMagicMsg
@5eb9:  dey2                ; next character
        bpl     @5e92
        shorti
        clr_a
        sec
        ldx     #$02
        ldy     #$17
@5ec5:  ror
        bcc     @5eca
        ror
        dex
@5eca:  bit     near w7e3a84,x     ; lores learned this battle
        beq     @5ee2       ; skip if not learned
        pha
        ora     $1d29,x     ; add to known lores
        sta     $1d29,x
        tya
        adc     #ATTACK::FIRST_LORE
        sta     near w7e2f35       ; set variable 0
        lda     #ATTACK_MSG::LEARN_LORE
        jsr     ShowMsg
        pla
@5ee2:  dey                 ; next lore
        bpl     @5ec5
        lda     .loword(array_item w7e3000, CHAR::MOG)
        bmi     @5f00       ; branch if mog not present
        ldx     $11e2
        lda     f:BattleBGDance,x   ; dance index for each battle background
        bmi     @5f00
        jsr     GetBitPtr
        tsb     $1d4c       ; set in known dances
        bne     @5f00       ; branch if dance was already known
        lda     #ATTACK_MSG::LEARN_DANCE
        jsr     ShowMsg
@5f00:  lda     $f0
        lsr
        bcc     @5f0a       ; branch if cursed shield was not dispelled (see c2/6005)
        lda     #ATTACK_MSG::CURSED_SHIELD
        jsr     ShowMsg
@5f0a:  ldx     #$05
@5f0c:  clr_a
        dec
        sta     $f0,x       ; clear items dropped
        stz     $f6,x       ; zero item quantities
        dex
        bpl     @5f0c
        ldy     #$0a
@5f17:  lda     near wTargetProp3::_4::w7e3ee4,y     ; status 1
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        beq     @5f4e       ; skip if not wound, petrify, or zombie
        jsr     Rand
        cmp     #$20        ; 1/8 chance to get rare item
        longai
        clr_a
        ror
        adc     near w7e2001,y     ; monster index
        asl
        rol
        tax
        lda     f:MonsterItems+2,x   ; monster items dropped
        shortai
        cmp     #$ff
        beq     @5f4e       ; branch if empty
        ldx     #$05
@5f39:  cmp     $f0,x
        beq     @5f4c       ; branch if one or more of this item was dropped by a different monster
        xba
        lda     $f0,x       ; item number
        inc
        bne     @5f48       ; branch if not empty
        xba
        sta     $f0,x       ; set item number
        bra     @5f4c
@5f48:  xba                 ; next item slot
        dex
        bpl     @5f39
@5f4c:  inc     $f6,x       ; increment quantity
@5f4e:  dey2                ; next monster
        bpl     @5f17
        ldx     #$05
@5f54:  lda     $f0,x       ; dropped item number
        cmp     #$ff
        beq     @5f75       ; branch if empty
        sta     near w7e2f35       ; set variable 0
        jsr     LoadItemProp
        lda     $f6,x       ; quantity
        sta     near w7e2f38       ; set variable 1
        sta     near w7e2e75       ; set item quantity
        jsr     _c26279       ; add item to inventory
        lda     #ATTACK_MSG::WIN_ITEM
        dec     $f6,x
        beq     @5f72       ; branch if only 1 was obtained
        inc                 ; change to battle message $21 "got <i> x <v1>"
@5f72:  jsr     ShowMsg
@5f75:  dex                 ; next item
        bpl     @5f54
        lda     near w7e2f3e_L     ; variable 3 (gp)
        ora     near w7e2f3e_H
        ora     near w7e2f3e_B
        beq     @5fc5       ; return if no gp was gained
        lda     near w7e2f3e_L     ; move to variable 1
        sta     near w7e2f38_L
        lda     near w7e2f3e_H
        sta     near w7e2f38_H
        lda     near w7e2f3e_B
        sta     near w7e2f38_B
        lda     #ATTACK_MSG::WIN_GIL
        jsr     ShowMsg
        clc
        ldx     #<-3
@5f9d:  lda     $1860 - <-3,x     ; current gp (++$1860)
        adc     near w7e2f3e - <-3,x     ; add gained gp (max 9999999)
        sta     $1860 - <-3,x
        inx
        bne     @5f9d
        ldx     #2
@5fab:  lda     f:MaxGil,x   ; max gp
        cmp     $1860,x
        beq     @5fc2
        bcs     @5fc5
        ldx     #2
@5fb8:  lda     f:MaxGil,x   ; max gp
        sta     $1860,x
        dex
        bpl     @5fb8
@5fc2:  dex
        bpl     @5fab
@5fc5:  plp
        rts

; ------------------------------------------------------------------------------

; max gp (9999999)
MaxGil:
@5fc7:  .faraddr MAX_GIL

; ------------------------------------------------------------------------------

; [ display battle message and end battle ]

; A: battle message index ($ff = no message)

LoseBattle:
@5fca:  pha
        lda     #$01
        tsb     near w7e3eb0 + 12       ; game over after battle ends
        jsr     _c24903       ; init graphics for end of battle
        pla
; fall through

; ------------------------------------------------------------------------------

; [ display battle message ]

; A: battle message index ($ff = no message)

ShowMsg:
@5fd4:  php
        shorta
        cmp     #$ff
        beq     @5fed       ; branch if no message
        sta     near w7e2d6e + 1
        lda     #GFX_CMD::ATTACK_MSG
        sta     near w7e2d6e::_0
        lda     #GFX_CMD::TERMINATE
        sta     near w7e2d6e::_1
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
@5fed:  plp
        rts

; ------------------------------------------------------------------------------

; [ update spells taught by items ]

; X: pointer to character data (+$1600)

LearnItemMagic:
        .i16
@5fef:  phx
        ldy     #$0006      ; loop through all equipped items
@5ff3:  lda     $161f,x
        cmp     #$ff
        beq     @6024       ; skip if no item equipped
        cmp     #ITEM::CURSED_SHLD
        bne     @600c       ; branch if not cursed shield
        inc     near w7e3eb0 + 16       ; increment cursed shield battle counter
        bne     @600c
        lda     #$01
        tsb     $f0         ; cursed shield dispelled
        lda     #ITEM::PALADIN_SHLD
        sta     $161f,x     ; replace with paladin shield
@600c:  xba
        lda     #$1e        ; calculate pointer to item data
        jsr     MultAB
        phx
        phy
        tax
        clr_a
        lda     f:ItemProp+4,x   ; spell taught by item
        tay
        lda     f:ItemProp+3,x   ; spell learn rate
        jsr     IncLearnMagic
        ply
        plx
@6024:  inx
        dey
        bne     @5ff3
        plx
        rts

; ------------------------------------------------------------------------------

; [ update spells taught by espers ]

LearnGenjuMagic:
@602a:  phx
        jsr     GetGenjuPropPtr
        ldy     #5                      ; 5 spells per esper
@6031:  clr_a
        lda     f:GenjuProp+1,x         ; spell taught by esper
        cmp     #$ff
        beq     @6044
        phy
        tay
        lda     f:GenjuProp,x           ; spell learn rate
        jsr     IncLearnMagic
        ply
@6044:  inx2
        dey
        bne     @6031
        plx
        rts

; ------------------------------------------------------------------------------

; [ increment spell learn % ]

; A: % to learn
; Y: spell index

IncLearnMagic:
@604b:  beq     _606c       ; return if 0% to learn
        xba
        lda     $fb         ;
        jsr     MultAB
        sta     $ee
        lda     ($f4),y     ; current learned %
        cmp     #$ff
        beq     _606c       ; return if spell is already fully learned
        clc
        adc     $ee         ; add amount to learn
        bcs     @6064       ; branch on overflow (should never happen)
        cmp     #100
        bcc     @6066       ; branch if total is less than 100
@6064:  lda     #$80
@6066:  sta     ($f4),y     ; set msb in learn %
        lda     $f1         ;
        tsb     $f0
_606c:  rts

; ------------------------------------------------------------------------------

; [ check for level up ]

CheckLevelUp:
@606d:  stz     $f8         ; $f8 is the high byte of the calculated experience
        clr_a
        lda     $1608,x     ; level
        cmp     #MAX_LEVEL
        bcs     _606c       ; return if >= 99
        longa
        asl
        phx
        tax
        clr_a
@607d:  clc
        adc     f:LevelUpExp-2,x   ; character experience progression data
        bcc     @6086
        inc     $f8
@6086:  dex2
        bne     @607d
        plx
        asl                 ; multiply calculated value by 8
        rol     $f8
        asl
        rol     $f8
        asl
        rol     $f8
        sta     $f6         ; ++$f6 = experience needed to level up
        lda     $1612,x     ; current experience (high word)
        cmp     $f7
        shorta
        bcc     _606c       ; return if not enough to level up
        bne     @60a8       ; branch if high word is greater than needed
        lda     $1611,x     ; check low byte
        cmp     $f6
        bcc     _606c       ; return if not enough to level up
@60a8:  lda     $f2
        beq     @60b1       ; branch if no battle message for level up
        stz     $f2
        jsr     ShowMsg
@60b1:  jsr     DoLevelUp
        phx
        lda     $1608,x     ; B: level
        xba
        lda     $1600,x     ; A: actor
        jsr     LearnAbilities
        plx
        bra     CheckLevelUp

; ------------------------------------------------------------------------------

; [ update stats at level up ]

DoLevelUp:
@60c2:  php
        inc     $1608,x     ; increment level
        stz     $fd         ; clear high byte of hp/mp increase
        stz     $ff
        phx
        clr_a
        lda     $1608,x     ; level
        tax
        lda     f:LevelUpMP-2,x   ; character mp progression data
        sta     $fe
        lda     f:LevelUpHP-2,x   ; character hp progression data
        sta     $fc
        plx
        lda     $161e,x     ; equipped esper
        bmi     @60f6       ; branch if no esper equipped
        phy
        phx
        txy
        jsr     GetGenjuPropPtr
        clr_a
        lda     f:GenjuProp+10,x   ; esper level up bonus
        bmi     @60f4       ; branch if no bonus
        asl
        tax
        jsr     (near GenjuBonusTbl,x)
@60f4:  plx
        ply
@60f6:  longa_clc
        lda     $160b,x     ; hp boost
        pha
        and     #$c000
        sta     $ee
        pla
        and     #$3fff      ; max hp
        adc     $fc         ; add increase (max 9999)
        cmp     #MAX_HP + 1
        bcc     @610f
        lda     #MAX_HP
@610f:  ora     $ee         ; combine with hp boost
        sta     $160b,x     ; set new max hp
        clc
        lda     $160f,x     ; mp boost
        pha
        and     #$c000
        sta     $ee
        pla
        and     #$3fff      ; max mp
        adc     $fe         ; add increase (max 999)
        cmp     #MAX_MP + 1
        bcc     @612c
        lda     #MAX_MP
@612c:  ora     $ee         ; mp boost
        sta     $160f,x     ; set new max mp
        plp
        rts

; ------------------------------------------------------------------------------

; [ display learned spells ]

ShowLearnedMagicMsg:
        .a8
@6133:  phy
        ldy     #$0035
@6137:  lda     ($f4),y     ; spell learn %
        cmp     #$80
        bne     @6149       ; skip if not newly learned
        lda     #$ff
        sta     ($f4),y     ; make spell fully learned
        sty     near w7e2f35       ; variable 0 = spell number
        lda     #ATTACK_MSG::LEARN_MAGIC
        jsr     ShowMsg
@6149:  dey                 ; next spell
        bpl     @6137
        ply
        rts

; ------------------------------------------------------------------------------

; jump table for esper level up bonus
GenjuBonusTbl:
        ptr_tbl GENJU_BONUS

; ------------------------------------------------------------------------------

; [ esper bonus $00/$03: +10% hp/mp increase ]

        array_label GENJU_BONUS, GENJU_BONUS::HP_10
        array_label GENJU_BONUS, GENJU_BONUS::MP_10
@6170:  lda     #$1a        ; 26/256 = 10.16%
        bra     _617a

; ------------------------------------------------------------------------------

; [ esper bonus $01/$04: +30% hp/mp increase ]

        array_label GENJU_BONUS, GENJU_BONUS::HP_30
        array_label GENJU_BONUS, GENJU_BONUS::MP_30
@6174:  lda     #$4e        ; 78/256 = 30.47%
        bra     _617a

; ------------------------------------------------------------------------------

; [ esper bonus $02/$05: +50% hp/mp increase ]

        array_label GENJU_BONUS, GENJU_BONUS::HP_50
        array_label GENJU_BONUS, GENJU_BONUS::MP_50
@6178:  lda     #$80        ; 128/256 = 50.00%
_617a:  cpx     #$0006
        ldx     #$0000
        bcc     @6184       ; branch if hp increase
        inx2                ; increment pointer for mp increase
@6184:  xba
        lda     $fc,x
        jsr     MultAB
        xba
        bne     _618e       ; minimum increase is 1
        inc
_618e:  clc
        adc     $fc,x       ; add to hp/mp increase
        sta     $fc,x
        bcc     _6197
        inc     $fd,x
; fallthrough

; ------------------------------------------------------------------------------

; [ esper bonus $07, $08: no effect ]

        array_label GENJU_BONUS, GENJU_BONUS::LV_30
        array_label GENJU_BONUS, GENJU_BONUS::LV_50
_6197:  rts

; ------------------------------------------------------------------------------

; [ esper bonus $09-$10: stat bonuses ]

        array_label GENJU_BONUS, GENJU_BONUS::MAGPWR_1
        array_label GENJU_BONUS, GENJU_BONUS::MAGPWR_2
@6198:  iny                 ; mag.pwr ($161d)

        array_label GENJU_BONUS, GENJU_BONUS::STAMINA_1
        array_label GENJU_BONUS, GENJU_BONUS::STAMINA_2
@6199:  iny                 ; stamina ($161c)

        array_label GENJU_BONUS, GENJU_BONUS::SPEED_1
        array_label GENJU_BONUS, GENJU_BONUS::SPEED_2
@619a:  iny                 ; speed ($161b)

        array_label GENJU_BONUS, GENJU_BONUS::STRENGTH_1
        array_label GENJU_BONUS, GENJU_BONUS::STRENGTH_2
@619b:  txa                 ; strength ($161a)
        lsr2                ; carry cleared if stat gets +2
        tyx
        lda     $161a,x     ; increment stat (max 128)
        inc
        bcs     @61a6       ; branch if not +2
        inc
@61a6:  cmp     #$81
        bcc     @61ac
        lda     #$80
@61ac:  sta     $161a,x
        rts

; ------------------------------------------------------------------------------

; [ esper bonus $06: +100% hp increase ]

        array_label GENJU_BONUS, GENJU_BONUS::HP_100
@61b0:  clr_ax
        lda     $fc
        bra     _618e

; ------------------------------------------------------------------------------

; [ update natural magic/skills at level up ]

; A: character id
; B: level

LearnAbilities:
@61b6:  ldx     #0
        cmp     #CHAR::TERRA
        beq     @61fc                   ; branch if character is terra
        ldx     #32
        cmp     #CHAR::CELES
        beq     @61fc                   ; branch if character is celes

; learn swdtech
        ldx     #0
        cmp     #CHAR::CYAN
        bne     @61e0                   ; branch if character is not cyan
        jsr     GetAbilityBit
        beq     @6221
        tsb     $1cf7
        bne     @6221
        lda     #$40
        tsb     $f0
        bne     @6221
        lda     #ATTACK_MSG::LEARN_BUSHIDO
        jmp     ShowMsg

; learn blitz
@61e0:  ldx     #8
        cmp     #CHAR::SABIN
        bne     @6221                   ; return if character is not sabin
        jsr     GetAbilityBit
        beq     @6221
        tsb     $1d28
        bne     @6221
        lda     #$80
        tsb     $f0
        bne     @6221
        lda     #ATTACK_MSG::LEARN_BLITZ
        jmp     ShowMsg

; learn spell
@61fc:  phy
        xba                             ; A: level
        ldy     #$0010                  ; 16 spells for each character
@6201:  cmp     f:NaturalMagic+1,x      ; natural magic data (level)
        bne     @621b
        pha
        phy
        clr_a
        lda     f:NaturalMagic,x        ; natural magic data (spell)
        tay
        lda     ($f4),y
        cmp     #$ff
        beq     @6219                   ; branch if spell is already known
        lda     #$80
        sta     ($f4),y                 ; learn spell
@6219:  ply
        pla
@621b:  inx2                            ; next spell
        dey
        bne     @6201
        ply
@6221:  rts

; ------------------------------------------------------------------------------

; [ check if blitz/swdtech was learned ]

; B: new level
; A: bitmask of learned blitz (out)

GetAbilityBit:
@6222:  lda     #1
        sta     $ee
        xba
@6227:  cmp     f:BushidoLevelTbl,x   ; blitz/swdtech learn data (level)
        beq     @6232
        inx
        asl     $ee
        bcc     @6227
@6232:  lda     $ee
        rts

; ------------------------------------------------------------------------------

; [ add experience ]

; X: pointer to character data (+$1600)

AddExp:
@6235:  php
        longa_clc
        lda     near w7e2f35       ; experience gained (low word)
        adc     $1611,x     ; add to experience
        sta     $f6
        shorta
        lda     near w7e2f35_B       ; experience gained (high byte)
        adc     $1613,x     ; add to experience
        sta     $f8
        phx
        ldx     #2
@624e:  lda     f:MaxExp,x
        cmp     $f6,x
        beq     @6264       ; branch if equal to max experience
        bcs     @6267       ; branch if less than max experience
        ldx     #2
@625b:  lda     f:MaxExp,x
        sta     $f6,x
        dex                 ; check next digit
        bpl     @625b
@6264:  dex
        bpl     @624e
@6267:  plx
        lda     $f8
        sta     $1613,x     ; set new experience (3 bytes)
        longa
        lda     $f6
        sta     $1611,x
        plp
        rts

; ------------------------------------------------------------------------------

; max experience (15,000,000)
MaxExp:
@6276:  .faraddr MAX_EXPERIENCE

; ------------------------------------------------------------------------------

; [ add item to inventory ]

_c26279:
writeitem:
        .a8
@6279:  lda     #BTL_GFX::GIVE_ITEM
        jsr     ExecBtlGfx
        lda     #BTL_GFX::UPDATE_INVENTORY
        jmp     ExecBtlGfx

; ------------------------------------------------------------------------------

; [ calculate pointer to character's spells in SRAM ]

; +$f4 = pointer to spells known (out)

GetSpellListPtr:
@6283:  php
        xba
        lda     #$36
        jsr     MultAB
        longa_clc
        adc     #$1a6e
        sta     $f4
        plp
        rts

; ------------------------------------------------------------------------------

; [ calculate pointer to esper data ]

; A: esper index

GetGenjuPropPtr:
        .a8
@6293:  xba
        lda     #$0b
        jsr     MultAB
        tax
        rts

; ------------------------------------------------------------------------------
