; ------------------------------------------------------------------------------

; [ load character properties ]

LoadCharProp:
@27a8:  php
        longai
        ldy     near w7e3010,x
        lda     $1609,y
        sta     near wTargetProp2::CurrHP,x
        lda     $160d,y
        sta     near wTargetProp2::CurrMP,x
        lda     $160b,y
        jsr     CalcMaxHPMP
        cmp     #MAX_HP + 1
        bcc     @27c8
        lda     #MAX_HP
@27c8:  sta     near wTargetProp2::MaxHP,x
        lda     $160f,y
        jsr     CalcMaxHPMP
        cmp     #MAX_MP + 1
        bcc     @27d9
        lda     #MAX_MP
@27d9:  sta     near wTargetProp2::MaxMP,x
        lda     near wTargetMask,x
        bit     zb8
        beq     @27f8
        lda     near wTargetProp2::MaxHP,x
        sta     near wTargetProp2::CurrHP,x
        lda     near wTargetProp2::MaxMP,x
        sta     near wTargetProp2::CurrMP,x
        lda     $1614,y
        and     #$ff2d
        sta     $1614,y
@27f8:  lda     near wTargetProp2::EquipStatus23,x
        shorta
        sta     near wTargetProp2::w7e3dd5,x
        lsr
        bcc     @280b
        lda     near wTargetProp1::w7e3204,x
        and     #$ef
        sta     near wTargetProp1::w7e3204,x
@280b:  lda     $1614,y
        sta     near wTargetProp2::w7e3dd4,x
        bit     #STATUS1::MAGITEK
        beq     @281f
        lda     #BATTLE_CMD::MAGITEK
        sta     near w7e3f20
        lda     #ATTACK::FIRST_MAGITEK
        sta     near w7e3f21
@281f:  lda     $1615,y
        and     #$c0
        xba
        lsr
        bcc     @282c
        xba
        ora     #$80
        xba
@282c:  asl
        sta     near wTargetProp2::w7e3de8,x
        xba
        sta     near wTargetProp2::w7e3de9,x
        lda     $1608,y
        sta     near wTargetProp2::Level,x
        plp
        rts

; ------------------------------------------------------------------------------

; [ calculate boosted max hp/mp ]

CalcMaxHPMP:
_decodehp:
@283c:  .a16
        phx
        asl
        rol
        sta     $ee
        rol2
        and     #$0006
        tax
        lda     $ee
        lsr2
        sta     $ee
        jmp     (near MaxHPMPTbl,x)

; ------------------------------------------------------------------------------

; 0: no boost
MaxHPMP_00:
@2850:  clr_a

; 3: +12.5%
MaxHPMP_03:
@2851:  lsr

; 1: +25%
MaxHPMP_01:
@2852:  lsr

; 2: +50%
MaxHPMP_02:
@2853:  lsr
        clc
        adc     $ee
        plx
        rts

; ------------------------------------------------------------------------------

MaxHPMPTbl:
@2859:  .addr   MaxHPMP_00
        .addr   MaxHPMP_01
        .addr   MaxHPMP_02
        .addr   MaxHPMP_03

; ------------------------------------------------------------------------------

; [ invert evade/mblock ]

_evasionconv:
InvertEvade:
@2861:  .a8
        asl
        bcc     @2866
        lda     #$ff
@2866:  neg_a
        bne     @286c
        dec
@286c:  rts

; ------------------------------------------------------------------------------

; [ init battle equipment effects ]

UpdateEquipBattle:
; _loadcharcter2:
@286d:  phd
        pea     $1100       ; set direct page to $1100
        pld
        lda     <$11c9         ; armor
        cmp     #$9f
        bne     @2883       ; branch if not $9f (moogle suit)
        txa
        asl4
        tay
        lda     #$0a        ; use mog sprite
        sta     near wCharGfxDataBuf::GfxID,y     ; character graphics index
@2883:  txa
        lsr
        tay
        lda     <$11d8         ; genji glove
        and     #$10
        sta     near w7e2e6e,y
        clc
        lda     <$11a6         ; strength * 2 (max $ff)
        adc     <$11a6
        bcc     @2896
        lda     #$ff
@2896:  sta     near wTargetProp2::Strength,x
        lda     <$11a4
        sta     near wTargetProp2::w7e3b2d,x     ; set speed (dummy)
        sta     near wTargetProp2::Speed,x
        lda     <$11a2
        sta     near wTargetProp2::Stamina,x
        lda     <$11a0
        sta     near wTargetProp2::MagicPower,x
        lda     <$11a8
        jsr     InvertEvade
        sta     near wTargetProp2::Evade,x
        lda     <$11aa
        jsr     InvertEvade
        sta     near wTargetProp2::MagicEvade,x
        lda     <$11cf         ;
        trb     <$11d8
        lda     <$11bc
        sta     near wTargetProp2::EquipStatus23_L,x
        lda     <$11d4
        sta     near wTargetProp2::EquipStatus23_H,x
        lda     <$11dc
        sta     near wTargetProp2::w7e3d71,x     ; run factor
        lda     <$11d9
        and     #MONSTER_FLAG::UNDEAD   ; RELIC_EFFECT5::RELIC_RING
        ora     #MONSTER_FLAG::HUMAN
        sta     near wTargetProp2::MonsterFlags,x
        lda     <$11d5         ; relic effects 1
        asl                 ; shift left by 1
        xba
        lda     <$11d6
        tsb     near w7e3a6d       ; set relic effects 2 (party)
        asl                 ; shift out dragon horn bit
        lda     <$11d7         ; relic effects 3
        xba
        ror                 ; shift dragon horn bit in
        longa
        sta     near wTargetProp2::RelicEffect1,x     ; relic effects 1/3
        lda     <$11ac
        sta     near wTargetProp2::RHandAttackPower,x
        lda     <$11ae
        sta     near wTargetProp2::RHandHitRate,x
        lda     <$11b4
        sta     near wTargetProp2::RHandSpellCast,x     ; weapon spell cast
        lda     <$11b0
        sta     near wTargetProp2::RHandElement,x
        lda     <$11d8
        bit     #$0008
        bne     @290a       ; branch if gauntlet equipped
        lda     #$4040
        trb     <$11da         ; clear 2-hand effect
@290a:  lda     <$11da
        sta     near wTargetProp2::RHandWeaponFlags,x     ; weapon effects
        lda     <$11ba
        sta     near wTargetProp2::Defense,x     ; defense/magic defense
        lda     #$ffff
        sta     near wTargetProp1::ImmuneStatus1,x
        eor     <$11d2
        sta     near wTargetProp1::ImmuneStatus1,x     ; blocked status 1 & 2
        lda     <$11b6
        sta     near wTargetProp2::ElemAbsorb,x     ; absorbed/nullified elements
        lda     <$11b8
        sta     near wTargetProp2::ElemWeak,x     ; weak/halved elements
        lda     <$11be
        sta     near wTargetProp2::RHandWeaponSpecial,x
        lda     <$11c6
        sta     near wTargetProp2::RHandItem,x     ; weapon/shield
        lda     <$11ca
        sta     near wTargetProp2::Relics,x     ; relic 1/relic 2
        lda     <$11d0
        sta     near wTargetProp2::BlockGfx,x     ; physical block graphic
        lda     <$11d8
        sta     near wTargetProp2::RelicEffect4,x     ; relic effects 4/5
        shorta
        asl     near w7e3a20 + 1,x     ;
        asl3
        ror     near w7e3a20 + 1,x     ;
        pld
        jmp     FixImmuneStatus

; ------------------------------------------------------------------------------

; [ update hit rate and level ]

InitAttacker:
; _loadmagic:
@2951:  lda     $11a2
        lsr
        lda     near wTargetProp2::MagicPower,x
        bcc     @295d       ; branch if magic-based attack
        lda     near wTargetProp2::Strength,x
@295d:  sta     $11ae       ; set hit rate
        stz     near wWeaponSpellCast       ; disable random weapon spellcast
        jmp     InitAttackerLevel

; ------------------------------------------------------------------------------

; [ load spell data ]

; A: spell index

LoadMagicProp:
@2966:  phx
        php
        xba
        lda     #$0e        ; 14 bytes each
        jsr     MultAB
        longai_clc
        adc     #near MagicProp      ; +$c46ac0
        tax
        ldy     #$11a0
        lda     #$000d      ; 14 bytes -> $11a0
        mvn     MagicProp,$7e11a0
        shorta
        asl     $11a9       ; multiply special effect by 2 to get pointer to jump tables
        bcc     @2987
        stz     $11a9       ; if special effect was $ff, disable special effect
@2987:  plp
        plx
        rts

.pushseg
.segment "magic_prop"

.export MagicProp

; c4/6ac0
MagicProp:
        .incbin "assets/data/battle/magic_prop.bin"

.popseg

; ------------------------------------------------------------------------------

; [  ]

_c2298a:
_simplemagic:
@298a:  lda     near w7e3a7c
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

_c2298d:
_simplemagic2:
@298d:  jsr     InitTarget
        lda     #$20
        tsb     $11a4
        stz     $11a9
        stz     $11af       ; clear level
        stz     $11ae       ; clear hit rate
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2299f:
_magicpunch:
@299f:  .i8
        php
        lda     near wTargetProp2::Strength,x     ; vigor * 2
        sta     $11ae
        jsr     InitAttackerLevel
        lda     near wTargetProp2::RelicEffect3,x  ; sniper sight effect
        bit     #RELIC_EFFECT3::MAX_HIT_RATE
        beq     @29b5
        lda     #$20
        tsb     $11a4
@29b5:  lda     zb6
        cmp     #ATTACK::SPECIAL
        bne     @29c7
        lda     near wTargetProp3::w7e3ee4,x
        bit     #STATUS1::IMP
        bne     @29c7
        lda     #$06                    ; attack name type = 6 (monster special)
        sta     near w7e3412

; increment X if left-hand attack
@29c7:  plp
        phx
        ror     zb6
        bpl     @29ce
        inx

@29ce:  lda     near wTargetProp2::RHandAttackPower,x
        sta     $11a6
        lda     #$62
        tsb     zb3
        lda     near wTargetProp2::RHandWeaponFlags,x
        andflg  WEAPON_FLAG, {BACK_ROW, TWO_HAND}
        eor     #WEAPON_FLAG::BACK_ROW
        trb     zb3
        lda     near wTargetProp2::RHandElement,x
        sta     $11a1
        lda     near wTargetProp2::RHandHitRate,x
        sta     $11a8
        lda     near wTargetProp2::RHandSpellCast,x
        sta     near wWeaponSpellCast
        lda     near wTargetProp2::RHandWeaponSpecial,x
        and     #$f0
        lsr3
        sta     $11a9
        lda     near wTargetProp2::RHandItem,x
        inc
        sta     zb7
        plx
        lda     near wTargetProp2::RelicEffect4,x  ; RELIC_EFFECT4::X_FIGHT
        lsr
        bcc     @2a1b
        lda     #$20
        tsb     $11a4
        lda     #$40
        tsb     zba
        lda     #$02
        tsb     zb2
        stz     near wWeaponSpellCast
@2a1b:  lda     $11a6
        beq     @2a36
        cpx     #$08
        bcc     @2a36
        lda     #STATUS1::IMP
        bit     near wTargetProp3::w7e3ee4,x
        beq     @2a36
        asl
        bit     near wTargetProp2::MonsterFlags,x  ; MONSTER_FLAG::IMP_DMG_BONUS
        bne     @2a36
        lda     #1
        sta     $11a6
@2a36:  rts

; ------------------------------------------------------------------------------

; [ calculate item effect ]

; c: 0 = normal, 1 = tools/throw

CalcItemEffect:
_magicitem:
@2a37:  phx
        php
        pha
        phx
        ldx     #$0f
@2a3d:  stz     $11a0,x     ; clear $11a0-$11af
        dex
        bpl     @2a3d
        plx
        lda     #$21
        sta     $11a2       ; ignore defense, physical damage
        lda     #$22
        sta     $11a3       ; re-target if target invalid, ignore reflect
        lda     #$20
        sta     $11a4       ; can't dodge
        bcc     @2a5e       ; branch if not tools/throw
        lda     near wTargetProp2::Strength,x     ; hit rate = vigor * 2
        sta     $11ae
        jsr     InitAttackerLevel
@2a5e:  lda     1,s
        jsr     GetItemPropPtr
        longi
        tax
        lda     f:ItemProp+20,x   ; battle/defense power
        sta     $11a6
        lda     f:ItemProp+15,x   ; item element
        sta     $11a1
        bcs     @2adc       ; branch if tools/throw
        lda     #$01
        trb     $11a2
        lda     f:ItemProp+27,x   ; item special effect
        asl
        bcs     @2a87
        adc     #$90        ; offset by $48 in special effect list
        sta     $11a9
@2a87:  longa
        lda     f:ItemProp+21,x   ; status 1 and 2
        sta     $11aa
        lda     f:ItemProp+23,x   ; status 3 and 4
        sta     $11ac
        shorta
        lda     f:ItemProp+19,x   ; item properties
        sta     $fe
        asl     $fe
        bcc     @2aa8       ; damage is a fraction of total hp/mp
        lda     #$80
        tsb     $11a4
@2aa8:  asl     $fe
        asl     $fe
        bcc     @2ab3       ; item removes status
        lda     #$04
        tsb     $11a4
@2ab3:  asl     $fe
        bcc     @2abe       ; restore mp
        lda     #$80
        tsb     $11a3
        tsb     $fe
@2abe:  asl     $fe
        bcc     @2ac7       ; restore hp
        lda     #$01
        tsb     $11a4
@2ac7:  asl     $fe
        asl     $fe
        bcc     @2ad2       ; invert damage to undead
        lda     #$08
        tsb     $11a2
@2ad2:  lda     $11aa
        bpl     @2adc       ; branch if item doesn't affect wound status
        lda     #$0c
        tsb     $11a2       ; invert damage to undead, resurrection targetting
@2adc:  lda     1,s
        cmp     #ITEM::INVIZ_EDGE
        bne     @2ae9       ; branch if not inviz edge
        lda     #STATUS1::VANISH
        tsb     $11aa
        bra     @2af2
@2ae9:  cmp     #ITEM::SHADOW_EDGE
        bne     @2af2       ; branch if not shadow edge
        lda     #STATUS2::IMAGE
        tsb     $11ab
@2af2:  lda     f:ItemProp,x
        and     #$07
        bne     @2b16       ; return if not a tool
        lda     #$20
        trb     $11a2
        trb     $11a4
        lda     f:ItemProp+21,x
        sta     $11a8
        clr_a
        lda     1,s
        sec
        sbc     #ITEM::FIRST_TOOL
        and     #%111
        asl
        tax
        jsr     (near ToolsEffectTbl,x)
@2b16:  pla
        plp
        plx
        rts

; ------------------------------------------------------------------------------

.enum TOOLS_EFFECT
        COUNT = TOOLS::COUNT
.endenum

; tool effect jump table
; machinetable_loadmagic:
ToolsEffectTbl:
        ptr_tbl TOOLS_EFFECT

; ------------------------------------------------------------------------------

; 0: noiseblaster
        array_label TOOLS_EFFECT, TOOLS::NOISEBLASTER
@2b2a:  lda     #STATUS2::CONFUSE
        sta     $11ab
; fallthrough

; ------------------------------------------------------------------------------

; bio blaster and flash are treated as magic attacks
        array_label TOOLS_EFFECT, TOOLS::BIO_BLASTER
        array_label TOOLS_EFFECT, TOOLS::FLASH
@2b2f:  rts

; ------------------------------------------------------------------------------

; 3: chain saw
        array_label TOOLS_EFFECT, TOOLS::CHAIN_SAW
@2b30:  jsr     Rand
        and     #%11
        bne     _2b4d       ; 3/4 chance to branch
        lda     #8
        sta     zb6         ; spell $08 (alternate chainsaw)
        stz     $11a6
        lda     #STATUS1::DEAD
        tsb     $11aa
        lda     #$10
        sta     $11a4
        lda     #$02
        tsb     $11a2
; fall through

; ------------------------------------------------------------------------------

; 5: drill
        array_label TOOLS_EFFECT, TOOLS::DRILL
_2b4d:  lda     #$20
        tsb     $11a2       ; ignore defense
        rts

; ------------------------------------------------------------------------------

; 4: debilitator
        array_label TOOLS_EFFECT, TOOLS::DEBILITATOR
@2b53:  lda     #$ac        ; special effect $56 (debilitator)
        bra     _2b59

; ------------------------------------------------------------------------------

; 6: air anchor
        array_label TOOLS_EFFECT, TOOLS::AIR_ANCHOR
@2b57:  lda     #$ae        ; special effect $57 (air anchor)
_2b59:  sta     $11a9
        rts

; ------------------------------------------------------------------------------

; 7: autocrossbow
        array_label TOOLS_EFFECT, TOOLS::AUTOCROSSBOW
@2b5d:  lda     #$40
        tsb     $11a2       ; don't split damage
        rts

; ------------------------------------------------------------------------------

; [ get pointer to item data ]

_itemindex:
GetItemPropPtr:
@2b63:  xba
        lda     #$1e
        jmp     MultAB

; ------------------------------------------------------------------------------

; [ magical damage ]

CalcMagicDmg:
_initdamage:
@2b69:  lda     $11af       ; level
        sta     $e8
        cmp     #$01
        clr_a
        lda     $11a6
        longa
        bcc     @2b7a
        asl2
@2b7a:  sta     $11b0
        shorta
        lda     $11ae       ; hit rate
        xba
        lda     $11a6
        jsr     MultAB
        jsr     Mult24
        lda     #$04
        longa
        jsr     LsrA
        clc
        adc     $11b0
        sta     $11b0
        shorta
        rts

; ------------------------------------------------------------------------------

; [ calculate base damage ]

_initdamage2:
CalcDmg:
@2b9d:  .i8
        lda     $11a2
        lsr
        jcc     CalcMagicDmg

; physical damage
@2ba6:  php
        lda     $11af       ; level
        pha
        sta     $e8
        clr_a
        lda     $11a6
        longa
        cpx     #$08
        bcc     @2bb9
        asl2
@2bb9:  pha
        lda     zb2
        bit     #$4000
        bne     @2bcd
        lda     1,s
        lsr
        clc
        adc     1,s
        lsr
        clc
        adc     1,s
        sta     1,s
@2bcd:  pla
        shorta
        adc     $11ae       ; hit rate
        xba
        adc     #$00
        xba
        jsr     Mult24
        lda     $e8
        sta     $ea
        pla
        sta     $e8
        longa
        lda     $e9
        xba
        jsr     Mult24
        sta     $11b0
        cpx     #$08
        bcs     @2c1f
        lda     $11a6
        and     #$00ff
        asl
        adc     $11b0
        lsr
        clc
        adc     $11b0
        sta     $11b0
        lda     near wTargetProp2::RelicEffect4,x  ; RELIC_EFFECT4::X_FIGHT
        lsr
        bcc     @2c0b
        lsr     $11b0
@2c0b:  bit     #$0008
        beq     @2c1f
        lda     $11b0
        lsr2
        not_a
        sec
        adc     $11b0
        sta     $11b0
@2c1f:  plp
        rts

; ------------------------------------------------------------------------------

; [ update attacker level ]

InitAttackerLevel:
@2c21:  phx
        lda     near w7e3417       ; character using sketch
        bmi     @2c28       ; branch if invalid
        tax
@2c28:  lda     near wTargetProp2::Level,x     ; level
        sta     $11af       ; set attacker level
        plx
        rts

; ------------------------------------------------------------------------------
