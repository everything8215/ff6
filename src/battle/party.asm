; ------------------------------------------------------------------------------

.enum ADD_TO_SPELL_LIST
        GOGO
        NONE
        NORMAL

        COUNT
.endenum

; ------------------------------------------------------------------------------

; [ update enabled commands ]

; X: target pointer for character

.proc UpdateCmdList

@527d:  phx
        php
        longai
        txy
        lda     f:CmdPropPtrs,x
        tax
        shorta
        lda     near wTargetMask,y
        tsb     near w7e3a58
        lda     near wTargetProp3::w7e3ee4,y
        and     #STATUS1::IMP
        sta     $ef
        lda     near wTargetProp2::RHandWeaponFlags,y
        ora     near wTargetProp2::LHandWeaponFlags,y
        not_a
        andflg  WEAPON_FLAG, {RUNIC, BUSHIDO}
        tsb     $ef
        lda     #$04
        sta     $ee
@52a6:  phx
        sec
        clr_a
        lda     a:.loword(array_member_offset wCmdList, 0, CmdID),x
        bmi     @52db
        pha
        clc
        lda     $ef
        bit     #$20
        beq     @52c3
        lda     1,s
        asl
        tax
        lda     f:BattleCmdProp,x   ; battle command data
        bit     #BATTLE_CMD_FLAG::IMP
        bne     @52c3       ; branch if command can be used as imp
        sec
@52c3:  pla
        bcs     @52db
        ldx     #sizeof_UpdateCmdIDTbl - 1
@52c9:  cmp     f:UpdateCmdIDTbl,x
        bne     @52d7
        txa
        asl
        tax
        jsr     (near UpdateCmdListTbl,x)
        bra     @52db
@52d7:  dex
        bpl     @52c9
        clc
@52db:  plx

; rotate carry into $202f MSB
        ror     a:.loword(array_member_offset wCmdList, 0, Disabled),x
        inx3
        dec     $ee
        bne     @52a6
        plp
        plx
        rts

.endproc  ; UpdateCmdList

; ------------------------------------------------------------------------------

.enum UPDATE_CMD_LIST
        MORPH
        RUNIC
        BUSHIDO
        LORE
        X_MAGIC
        MAGIC
        CAPTURE
        FIGHT

        COUNT
.endenum

UpdateCmdIDTbl:
        .byte   BATTLE_CMD::MORPH
        .byte   BATTLE_CMD::RUNIC
        .byte   BATTLE_CMD::BUSHIDO
        .byte   BATTLE_CMD::LORE
        .byte   BATTLE_CMD::X_MAGIC
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::CAPTURE
        .byte   BATTLE_CMD::FIGHT
        calc_size UpdateCmdIDTbl

UpdateCmdListTbl:
        ptr_tbl UPDATE_CMD_LIST

; ------------------------------------------------------------------------------

; [ capture, fight ]

        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::CAPTURE
        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::FIGHT
@5301:  lda     near wTargetProp2::RelicEffect4,y  ; RELIC_EFFECT4::X_FIGHT
        lsr
        bcc     @5313                   ; branch if offering not equipped
        longa_clc                       ; clc here enables the command
        lda     3,s
        tax
        shorta
        ldaflg  TARGET, {ENEMY, INIT_HALF, ONE_SIDE}
        sta     a:2,x
@5313:  rts

; ------------------------------------------------------------------------------

; [ lore, x-magic, magic ]

        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::LORE
        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::X_MAGIC
        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::MAGIC
@5314:  lda     near wTargetProp3::w7e3ee5,y
        bit     #STATUS2::SILENCE
        beq     @531c
        sec                             ; disable if silenced
@531c:  rts

; ------------------------------------------------------------------------------

; [ swdtech ]

        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::BUSHIDO
@531d:  lda     $ef
        lsr2
        rts

; ------------------------------------------------------------------------------

; [ runic ]

        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::RUNIC
@5322:  lda     $ef
        asl
        rts

; ------------------------------------------------------------------------------

; [ morph ]

        array_label UPDATE_CMD_LIST, UPDATE_CMD_LIST::MORPH
@5326:  lda     #$0f
        cmp     $1cf6
        rts

; ------------------------------------------------------------------------------

; [ init character command list ]

; +X: character number x 2

.enum INIT_CMD_LIST
        MORPH
        LEAP
        DANCE
        MAGIC
        X_MAGIC
        LORE

        COUNT
.endenum

.proc InitCmdList

@532c:  phx
        php
        longai
        ldy     near w7e3010,x     ; pointer to character data (+$001600)
        lda     f:CmdPropPtrs,x   ; pointer to character command list data (+$7e0000)
        sta     f:hWMADDL
        lda     $1616,y     ; +++$fc = battle commands
        sta     $fc
        lda     $1618,y
        sta     $fe
        lda     $1614,y     ; status 1
        shortai
        bit     #STATUS1::MAGITEK
        bne     @5354       ; branch if magitek status
        lda     near w7e3eb0 + 11
        lsr
        bcc     @539d       ; branch if not magic only (fanatic's tower)
@5354:  lda     near w7e3ed8,x     ; b = actor number
        xba
        ldx     #$03
@535a:  lda     $fc,x       ; a = battle command
        cmp     #BATTLE_CMD::ITEM
        beq     @539a       ; branch if item
        cmp     #BATTLE_CMD::MIMIC
        beq     @539a       ; branch if mimic
        xba
        cmp     #CHAR_PROP::GAU
        bne     @5371       ; branch if not gau
        xba
        cmp     #BATTLE_CMD::RAGE
        bne     @5370       ; branch if not rage
        lda     #BATTLE_CMD::FIGHT
@5370:  xba
@5371:  xba
        cmp     #BATTLE_CMD::FIGHT
        bne     @537a       ; branch if command is not fight
        lda     #BATTLE_CMD::MAGITEK
        bra     @5380
@537a:  cmp     #BATTLE_CMD::MAGIC
        beq     @5380       ; branch if command is magic
        lda     #BATTLE_CMD::NONE
@5380:  sta     $fc,x       ; remove command
        lda     near w7e3eb0 + 11
        lsr
        bcc     @539a       ; branch if not magic only
        lda     $fc,x
        cmp     #BATTLE_CMD::MAGIC
        beq     @5396       ; branch if command is magic
        cmp     #BATTLE_CMD::MAGITEK
        bne     @5398       ; branch if command is not magitek
        lda     #BATTLE_CMD::MAGIC
        bra     @5398       ; change command to magic
@5396:  lda     #BATTLE_CMD::NONE
@5398:  sta     $fc,x
@539a:  dex                 ; next command
        bpl     @535a
@539d:  clr_a
        sta     $f8
        sta     f:hWMADDH     ; clear wram bank
        tay
@53a5:  lda     $fc,y
        ldx     #$04        ; 5 commands with possible relic updates
        pha
        lda     #$04        ; relic command update flag
        sta     $ee
@53af:  lda     f:RelicCmdTbl1,x   ; commands with relic updates
        cmp     1,s
        bne     @53c4       ; branch if not that command
        lda     $11d6
        bit     $ee
        beq     @53c4       ; branch if relic not equipped
        lda     f:RelicCmdTbl2,x   ; update command
        sta     1,s
@53c4:  asl     $ee         ; next command
        dex
        bpl     @53af
        lda     1,s       ; command number
        ldx     #$05        ; 6 commands with init functions
@53cd:  cmp     f:InitCmdIDTbl,x   ; commands with init functions
        bne     @53db
        txa
        asl
        tax
        jsr     (near InitCmdListTbl,x)   ; execute init function
        bra     @53de
@53db:  dex                 ; check next command with an init function
        bpl     @53cd
@53de:  pla
        sta     f:hWMDATA     ; set command number ($202e, CmdIndex)
        sta     f:hWMDATA     ; set command number ($202f, CmdDisabled)
        asl
        tax
        clr_a
        bcs     @53f0       ; branch if command was removed
        lda     f:BattleCmdProp+1,x   ; battle command data, targetting byte
@53f0:  sta     f:hWMDATA     ; set command targetting flags ($2030, CmdFlags)
        iny                 ; next command
        cpy     #$04
        bne     @53a5
        lsr     $f8         ; branch if $f8 was set (character has mp)
        bcs     @5408
        lda     2,s       ; pointer to character data
        tax
        longa
        stz     near wTargetProp2::CurrMP,x     ; clear current mp
        stz     near wTargetProp2::MaxMP,x     ; clear max mp
@5408:  plp
        .a8
        plx
        rts

.endproc  ; InitCmdList

; ------------------------------------------------------------------------------

; [ init morph command ]

        array_label INIT_CMD_LIST, INIT_CMD_LIST::MORPH
@540b:  lda     #$04
        bit     near w7e3eb0 + 12       ; remove command if morph is not available
        beq     _5434
        bit     near w7e3eb0 + 11       ; return if morph is not permanent
        beq     _5438
        lda     5,s       ; pointer to character data
        tax
        lda     near wTargetProp2::w7e3de9,x     ; set morph status
        ora     #STATUS4::MORPH
        sta     near wTargetProp2::w7e3de9,x
        lda     #$ff
        sta     $1cf6       ; set morph gauge to max
        bra     _5434       ; remove command

; ------------------------------------------------------------------------------

; [ init magic/x-magic command ]

        array_label INIT_CMD_LIST, INIT_CMD_LIST::MAGIC
        array_label INIT_CMD_LIST, INIT_CMD_LIST::X_MAGIC
@5429:  lda     $f6
        bne     array_item INIT_CMD_LIST, INIT_CMD_LIST::LORE
        lda     $f7
        inc
        bne     array_item INIT_CMD_LIST, INIT_CMD_LIST::LORE
_5432:  bne     _5438
_5434:  lda     #$ff
        sta     3,s       ; remove command
_5438:  rts

; ------------------------------------------------------------------------------

; [ init dance command ]

        array_label INIT_CMD_LIST, INIT_CMD_LIST::DANCE
@5439:  lda     $1d4c       ; dances known
        bra     _5432

; ------------------------------------------------------------------------------

; [ init leap command ]

        array_label INIT_CMD_LIST, INIT_CMD_LIST::LEAP
@543e:  lda     $11e4       ; on the veldt flag
        bit     #$02
        bra     _5432

; ------------------------------------------------------------------------------

; [ init lore command ]

        array_label INIT_CMD_LIST, INIT_CMD_LIST::LORE
@5445:  lda     #$01        ; character has mp
        tsb     $f8
        rts

; ------------------------------------------------------------------------------

; pointers to character command list data (+$7e0000)
CmdPropPtrs:
        ptr_tbl wCmdList

; ------------------------------------------------------------------------------

; commands with possible relic updates (steal, slot, sketch, magic, fight)
RelicCmdTbl1:
        .byte   BATTLE_CMD::STEAL
        .byte   BATTLE_CMD::SLOT
        .byte   BATTLE_CMD::SKETCH
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::FIGHT

; ------------------------------------------------------------------------------

; relic updated commands (capture, gp rain, control, x-magic, jump)
RelicCmdTbl2:
        .byte   BATTLE_CMD::CAPTURE
        .byte   BATTLE_CMD::GIL_TOSS
        .byte   BATTLE_CMD::CONTROL
        .byte   BATTLE_CMD::X_MAGIC
        .byte   BATTLE_CMD::JUMP

; ------------------------------------------------------------------------------

; command init function jump table
InitCmdListTbl:
        ptr_tbl INIT_CMD_LIST

; ------------------------------------------------------------------------------

; commands with init functions (morph, leap, dance, magic, x-magic, lore)
InitCmdIDTbl:
        .byte   BATTLE_CMD::MORPH
        .byte   BATTLE_CMD::LEAP
        .byte   BATTLE_CMD::DANCE
        .byte   BATTLE_CMD::MAGIC
        .byte   BATTLE_CMD::X_MAGIC
        .byte   BATTLE_CMD::LORE

; ------------------------------------------------------------------------------

; [ init battle inventory ]

InitInventory:

; start at the end of the item data and go backwards
@546e:  php
        longai
        ldy     #near wItemList + wItemList::SIZE - 1

; load left-hand equipped items
        lda     #1                      ; item quantity = 1 for equipped items
        sta     near w7e2e75
        ldx     #6                      ; start with character slot 4
@547d:  phy
        ldy     near w7e3010,x               ; pointer to character data
        lda     $1620,y                 ; equipped shield
        ply
        jsr     CopyItemProp
        dex2                            ; next character
        bpl     @547d

; load right-hand equipped items
        ldx     #6
@548f:  phy
        ldy     near w7e3010,x               ; pointer to character data
        lda     $161f,y                 ; equipped weapon
        ply
        jsr     CopyItemProp
        dex2                            ; next character
        bpl     @548f

; load inventory items
        ldx     #255                    ; loop through 255 items
@54a1:  lda     $1969,x     ; item quantity
        sta     near w7e2e75
        lda     $1869,x     ; item number
        jsr     CopyItemProp
        dex                 ; next item
        bpl     @54a1

; check available tools
        shortai
        clr_ay
@54b4:  lda     $1869,y     ; item number
        cmp     #ITEM::FIRST_TOOL
        bcc     @54c8       ; branch if less than tools
        sbc     #ITEM::FIRST_TOOL
        cmp     #8
        bcs     @54c8       ; branch if not a tool
        tax
        jsr     _c21e57       ; get bit mask
        tsb     near wOwnedTools
@54c8:  iny                 ; next item
        bne     @54b4
        plp
        rts

; ------------------------------------------------------------------------------

; [ add item to battle inventory ]

; +Y = pointer to battle inventory (last byte of item)

CopyItemProp:
@54cd:  .a16
        .i16
        phx
        jsr     LoadItemProp
        ldx     #near wItemPropBuf + sizeof_wItemPropBuf - 1
        lda     #sizeof_wItemPropBuf - 1
        mvp     wItemList,wItemPropBuf
        plx
        rts

; ------------------------------------------------------------------------------

; [ load item properties ]

; A: item number

LoadItemProp:
@54dc:  phx
        php
        longi
        shorta
        pha
        lda     #$80        ; make item unusable
        sta     near w7e2e73
        lda     #$ff
        sta     near w7e2e76       ; clear all equippability flags
        pla
        sta     near w7e2e72       ; item number
        cmp     #ITEM::EMPTY
        beq     @5546
        xba
        lda     #$1e
        jsr     MultAB
        tax
        lda     f:ItemProp+14,x   ; targetting
        sta     near w7e2e74
        lda     f:ItemProp,x
        pha
        pha
        asl2
        and     #$80        ; item useable in battle
        trb     near w7e2e73
        pla
        asl
        and     #$20        ; item can be thrown
        tsb     near w7e2e73
        clr_a
        pla
        and     #$07        ; item type
        phx
        tax
        lda     f:ItemTypeMaskTbl,x   ; flags for item type
        plx
        asl
        tsb     near w7e2e73
        bcs     @5546
        longa_clc
        stz     $ee
        lda     f:ItemProp+1,x   ; equippable characters
        ldx     #$0006
@5533:  bit     near w7e3a20,x     ; actor mask
        bne     @5539       ; branch if character can equip this item
        sec
@5539:  rol     $ee         ; set bit in $ee
        dex2                ; next character
        bpl     @5533
        shorta
        lda     $ee
        sta     near w7e2e76       ; set item equippability
@5546:  plp
        .i8
        plx
        rts

; ------------------------------------------------------------------------------

; flags for item types (tool, weapon, armor, shield, helm, relic, item)
ItemTypeMaskTbl:
@5549:  .byte   $a0,$08,$80,$04,$80,$80,$00,$00

; ------------------------------------------------------------------------------

; [ init spells/lores ]

; genju is the first item in the list, then 54 magic spells, then 24 lores

InitSpellList:
        php

; clear espers in master spell list pointer table
        ldx     #ATTACK::NUM_GENJU - 1
@5554:  stz     near w7e3084 + ATTACK::NUM_MAGIC,x
        dex
        bpl     @5554

; clear spell data
        lda     #$ff
        ldx     #$35
@555e:  sta     $11a0,x
        dex
        bpl     @555e

; check known lores
        ldy     #ATTACK::NUM_LORE - 1
        ldx     #2                      ; loop over 3 bytes of lores (24 bits)
        clr_a
        sec
@556a:  ror
        bcc     @556f
        ror
        dex
@556f:  bit     $1d29,x
        beq     @5584
        inc     near wNumKnownLores
        pha
        tya
        adc     #ATTACK::NUM_MAGIC + 1
        sta     near w7e3084 + ATTACK::FIRST_LORE,y
        adc     #ATTACK::FIRST_LORE - (ATTACK::NUM_MAGIC + 1)
        sta     near w7e306a,y                 ; add to master lore list
        pla
@5584:  dey
        bpl     @556a

; check each character's spell list
        ldx     #6
@5589:  lda     near w7e3ed8,x                 ; actor index
        cmp     #CHAR_PROP::GOGO
        bcs     @55ae                   ; skip if character has no spell list
        xba
        lda     #ATTACK::NUM_MAGIC
        jsr     MultAB
        longa_clc
        adc     #$1a6e
        sta     $f0                     ; pointer to spell list
        shorta
        ldy     #ATTACK::NUM_MAGIC - 1
@55a1:  lda     ($f0),y
        cmp     #$ff
        bne     @55ab
        tya
        sta     near w7e3034,y                 ; add to master spell list
@55ab:  dey
        bpl     @55a1
@55ae:  dex2
        bpl     @5589

;
        lda     $1d54       ; spell order
        and     #$07
        tax
        ldy     #ATTACK::NUM_MAGIC - 1
@55ba:  lda     near w7e3034,y
        cmp     #ATTACK::FIRST_EFFECT_MAGIC
        bcs     @55c7
        adc     f:BlackMagicOrderTbl,x
        bra     @55d9
@55c7:  cmp     #ATTACK::FIRST_WHITE_MAGIC
        bcs     @55d1
        adc     f:EffectMagicOrderTbl,x
        bra     @55d9
@55d1:  cmp     #ATTACK::FIRST_GENJU
        bcs     @55e0
        adc     f:WhiteMagicOrderTbl,x
@55d9:  phx
        tax
        tya
        sta     $11a0,x
        plx
@55e0:  dey
        bpl     @55ba
        lda     #$ff
        ldx     #ATTACK::NUM_MAGIC - 1
@55e7:  sta     near w7e3034,x
        dex
        bpl     @55e7
        clr_axy
@55f0:  lda     $11a0,x
        inc
        bne     @5602
        lda     $11a1,x
        inc
        bne     @5602
        lda     $11a2,x
        inc
        beq     @5617
@5602:  lda     $11a0,x
        sta     near w7e3034,y
        lda     $11a1,x
        sta     near w7e3034 + 1,y
        lda     $11a2,x
        sta     near w7e3034 + 2,y
        iny3
@5617:  inx3
        cpx     #ATTACK::NUM_MAGIC
        bcc     @55f0
        ldx     #ATTACK::NUM_MAGIC - 1  ; loop through all spells
@5620:  lda     near w7e3034,x     ; branch if no characters know the spell
        cmp     #$ff
        beq     @562d
        tay                 ; y = spell number
        txa                 ; a = position in master spell list + 1
        inc
        sta     near w7e3084,y     ; set pointer to master spell list
@562d:  dex
        bpl     @5620
        longi
        ldx     #ATTACK::NUM_MAGIC + ATTACK::NUM_LORE - 1
@5635:  clr_a
        lda     near w7e3034,x     ; branch if no characters know the spell
        cmp     #$ff
        beq     @5688
        pha
        tay
        lda     near w7e3084,y     ; get pointer to master spell list
        longa
        asl2
        shorta
        tay
        lda     1,s
        cmp     #ATTACK::FIRST_LORE
        bcc     @5651       ; subtract $8b if a lore
        sbc     #ATTACK::FIRST_LORE
@5651:  sta     near wSpellList::_0::AttackID,y     ; add to character spell/lore lists
        sta     near wSpellList::_1::AttackID,y
        sta     near wSpellList::_2::AttackID,y
        sta     near wSpellList::_3::AttackID,y
        pla
        jsr     LoadMagicTargetFlags
        sta     near wSpellList::_0::Flags,y     ; targetting data
        sta     near wSpellList::_1::Flags,y
        sta     near wSpellList::_2::Flags,y
        sta     near wSpellList::_3::Flags,y
        xba

; calculate step mine mp cost
        cpx     #ATTACK::NUM_MAGIC + (ATTACK::STEP_MINE - ATTACK::FIRST_LORE)
        bne     @567c
        lda     $1864       ; game time / 30 (maxes out at 199 mp)
        cmp     #30
        lda     $1863
        rol
@567c:  sta     near wSpellList::_0::MPCost,y     ; set mp cost
        sta     near wSpellList::_1::MPCost,y
        sta     near wSpellList::_2::MPCost,y
        sta     near wSpellList::_3::MPCost,y
@5688:  dex
        bpl     @5635
        plp
        rts

; ------------------------------------------------------------------------------

; [ validate esper and spell list for a character ]

ValidateSpellList:
@568d:  phx
        php
        longi
        lda     near wTargetProp2::RelicEffect3,x  ; economizer/gold hairpin effect
        sta     $f8
        stz     $f6         ; clear total number of spells
        ldy     near w7e302c,x     ; pointer to spell list
        sty     $f2
        iny3
        sty     $f4         ; pointer to mp cost
        ldy     near w7e3010,x
        lda     $161e,y     ; equipped esper
        sta     $f7
        bmi     @56c7       ; branch if no esper is equipped
        sta     near wTargetProp1::w7e3344,x
        ldy     $f2
        sta     0,y
        clc
        adc     #ATTACK::NUM_MAGIC
        jsr     LoadMagicTargetFlags
        sta     2,y
        sta     near wTargetProp1::w7e3345,x ; never used
        xba
        jsr     CalcMPCost
        sta     3,y
@56c7:  clr_ay
        lda     near w7e3ed8,x
        cmp     #CHAR_PROP::GOGO
        beq     @56e5       ; branch if character is gogo
        iny2
        bcs     @56e5       ; branch if character doesn't have a spell list
        iny2
        xba
        lda     #ATTACK::NUM_MAGIC
        jsr     MultAB
        longa_clc
        adc     #$1a6e
        sta     $f0
        shorta
@56e5:  tyx
        ldy     #(ATTACK::NUM_MAGIC + ATTACK::NUM_LORE) * 4
_56e9:  clr_a
        lda     ($f2),y
        cmp     #$ff
        beq     array_item ADD_TO_SPELL_LIST, ADD_TO_SPELL_LIST::NONE
        cpy     #(ATTACK::NUM_MAGIC + 1) * 4
        jmp     (near AddToSpellListTbl,x)

_56f6:  dey4
        bne     _56e9
        plp
        plx
        lda     $f6
        sta     near wTargetProp2::NumKnownSpells,x
        rts

; ------------------------------------------------------------------------------

; 2: normal character
        array_label ADD_TO_SPELL_LIST, ADD_TO_SPELL_LIST::NORMAL
@5704:  bcs     array_item ADD_TO_SPELL_LIST, ADD_TO_SPELL_LIST::GOGO
        phy
        tay
        lda     ($f0),y
        ply
        inc
        beq     array_item ADD_TO_SPELL_LIST, ADD_TO_SPELL_LIST::GOGO
; fall through

; ------------------------------------------------------------------------------

; 1: character with no spell list
        array_label ADD_TO_SPELL_LIST, ADD_TO_SPELL_LIST::NONE
@570e:  clr_a
        sta     ($f4),y
        dec
        sta     ($f2),y
        bra     _56f6

; ------------------------------------------------------------------------------

; 0: gogo
        array_label ADD_TO_SPELL_LIST, ADD_TO_SPELL_LIST::GOGO
@5716:  bcs     @571a
        inc     $f6
@571a:  lda     ($f4),y
        jsr     CalcMPCost
        sta     ($f4),y
        bra     _56f6

; ------------------------------------------------------------------------------

; [ get mp cost and targetting data ]

LoadMagicTargetFlags:
        phx
        xba
        lda     #14
        jsr     MultAB
        tax
        lda     f:MagicProp+5,x         ; spell mp cost
        xba
        lda     f:MagicProp,x           ; spell targetting
        plx
        rts

; ------------------------------------------------------------------------------

; [ calculate mp cost ]

; $f8: relic effects 2
;   A: original mp cost

CalcMPCost:
@5736:  xba
        lda     $f8
        bit     #RELIC_EFFECT3::MP_COST_HALF
        beq     @5741                   ; branch if no gold hairpin
        xba
        inc                             ; add one and divide by 2
        lsr
        xba
@5741:  bit     #RELIC_EFFECT3::MP_COST_1
        beq     @5749                   ; branch if no economizer
        xba
        lda     #1                      ; set mp cost to 1
        xba
@5749:  xba
        rts

; ------------------------------------------------------------------------------

; spell list offsets for each magic order

BlackMagicOrderTbl:
        .lobytes ATTACK::NUM_WHITE_MAGIC
        .lobytes ATTACK::NUM_WHITE_MAGIC + ATTACK::NUM_EFFECT_MAGIC
        .lobytes 0
        .lobytes 0
        .lobytes ATTACK::NUM_WHITE_MAGIC + ATTACK::NUM_EFFECT_MAGIC
        .lobytes ATTACK::NUM_EFFECT_MAGIC

EffectMagicOrderTbl:
        .lobytes ATTACK::NUM_WHITE_MAGIC
        .lobytes ATTACK::NUM_WHITE_MAGIC - ATTACK::NUM_BLACK_MAGIC
        .lobytes 0
        .lobytes ATTACK::NUM_WHITE_MAGIC
        .lobytes -ATTACK::NUM_BLACK_MAGIC
        .lobytes -ATTACK::NUM_BLACK_MAGIC

WhiteMagicOrderTbl:
        .lobytes -(ATTACK::NUM_BLACK_MAGIC + ATTACK::NUM_EFFECT_MAGIC)
        .lobytes -(ATTACK::NUM_BLACK_MAGIC + ATTACK::NUM_EFFECT_MAGIC)
        .lobytes 0
        .lobytes -ATTACK::NUM_EFFECT_MAGIC
        .lobytes -ATTACK::NUM_BLACK_MAGIC
        .lobytes 0

; ------------------------------------------------------------------------------

AddToSpellListTbl:
        ptr_tbl ADD_TO_SPELL_LIST

; ------------------------------------------------------------------------------

; [ update enabled spells/espers ]

UpdateEnabledMagic:
        .i8
@5763:  cpx     #$08
        bcs     @57a9       ; return if a monster
        phx
        phy
        php
        lda     near wTargetProp2::CurrMP_H,x     ; current mp (high byte)
        bne     @5775       ; branch if not zero
        lda     near wTargetProp2::CurrMP_L,x
        inc
        bne     @5777       ; branch if character has less than 255 mp left
@5775:  lda     #$ff
@5777:  sta     near w7e3a4c       ; max mp cost
        lda     near wTargetProp3::w7e3ee4,x     ; status 1
        asl2
        sta     $ef
        longi
        lda     near wTargetMask,x     ; character mask
        ldy     near w7e302c,x     ; pointer to character spell list ($208e)
        tyx
        sec
        bit     near w7e3f2e
        bne     @5793       ; branch if character has already used an esper attack
        jsr     CheckMagicEnabled
@5793:  ror     a:.loword(array_member_offset wSpellList, 0, Disabled),x
        ldy     #ATTACK::NUM_MAGIC + ATTACK::NUM_LORE - 1
@5799:  inx4
        jsr     CheckMagicEnabled
        ror     a:.loword(array_member_offset wSpellList, 0, Disabled),x
        dey
        bpl     @5799
        plp
        ply
        plx
@57a9:  rts

; ------------------------------------------------------------------------------

; [ check if spell is enabled ]

;  A: spell index
; +X: pointer to spell in spell list
;  C: set = disabled, clear = enabled (out)

CheckMagicEnabled:
@57aa:  lda     a:0,x                   ; first spell in spell list
        bmi     @57b9                   ; branch if spell list is empty
        xba
        lda     $ef
        bpl     @57bb                   ; branch if character is not an imp
        xba
        cmp     #ATTACK::IMP
        beq     @57bb                   ; branch if spell is imp (all other spells will be disabled)
@57b9:  sec
        rts
@57bb:  lda     a:3,x                   ; compare spell's mp cost to character's current mp
        cmp     near w7e3a4c
        rts

; ------------------------------------------------------------------------------
