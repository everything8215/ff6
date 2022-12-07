
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: equip.asm                                                            |
; |                                                                            |
; | description: equip/relic menu, and party equip menu                        |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import ImpItem

; ------------------------------------------------------------------------------

; [ init cursor (equip, optimum, rmove, empty) ]

LoadEquipOptionCursor:
@8e50:  ldy     #.loword(EquipOptionCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip, optimum, rmove, empty) ]

UpdateEquipOptionCursor:
@8e56:  jsr     MoveCursor

InitEquipOptionCursor:
@8e59:  ldy     #.loword(EquipOptionCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipOptionCursorProp:
@8e5f:  .byte   $01,$00,$00,$04,$01

EquipOptionCursorPos:
@8e64:  .byte   $00,$10
        .byte   $38,$10
        .byte   $80,$10
        .byte   $b8,$10

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic slot select) ]

LoadEquipSlotCursor:
@8e6c:  ldy     #.loword(EquipSlotCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic slot select) ]

UpdateEquipSlotCursor:
@8e72:  jsr     MoveCursor

InitEquipSlotCursor:
@8e75:  ldy     #.loword(EquipSlotCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipSlotCursorProp:
@8e7b:  .byte   $80,$00,$00,$01,$04

EquipSlotCursorPos:
@8e80:  .byte   $00,$2c
        .byte   $00,$38
        .byte   $00,$44
        .byte   $00,$50

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic item select, scrolling page) ]

LoadEquipLongListCursor:
@8e88:  ldy     #.loword(EquipListCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic item select, scrolling page) ]

UpdateEquipLongListCursor:
@8e8e:  jsr     MoveListCursor

InitEquipLongListCursor:
@8e91:  ldy     #.loword(EquipListCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; [ init cursor (equip/relic item select, single page) ]

LoadEquipShortListCursor:
@8e97:  ldy     #.loword(EquipListCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (equip/relic item select, single page) ]

UpdateEquipShortListCursor:
@8e9d:  jsr     MoveCursor

InitEquipShortListCursor:
@8ea0:  ldy     #.loword(EquipListCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

EquipListCursorProp:
@8ea6:  .byte   $81,$00,$00,$01,$09

EquipListCursorPos:
@8eab:  .byte   $00,$68
        .byte   $00,$74
        .byte   $00,$80
        .byte   $00,$8c
        .byte   $00,$98
        .byte   $00,$a4
        .byte   $00,$b0
        .byte   $00,$bc
        .byte   $00,$c8

; ------------------------------------------------------------------------------

; [ load cursor for relic options (equip/remove) ]

LoadRelicOptionCursor:
@8ebd:  ldy     #.loword(RelicOptionCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for relic options (equip/remove) ]

UpdateRelicOptionCursor:
@8ec3:  jsr     MoveCursor

InitRelicOptionCursor:
@8ec6:  ldy     #.loword(RelicOptionCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RelicOptionCursorProp:
@8ecc:  .byte   $01,$00,$00,$02,$01

RelicOptionCursorPos:
@8ed1:  .byte   $10,$10
        .byte   $48,$10

; ------------------------------------------------------------------------------

; [ load cursor for relic slot select ]

LoadRelicSlotCursor:
@8ed5:  ldy     #.loword(RelicSlotCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor for relic slot select ]

UpdateRelicSlotCursor:
@8edb:  jsr     MoveCursor

InitRelicSlotCursor:
@8ede:  ldy     #.loword(RelicSlotCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

RelicSlotCursorProp:
@8ee4:  .byte   $80,$00,$00,$01,$02

RelicSlotCursorPos:
@8ee9:  .byte   $00,$44
        .byte   $00,$50

; ------------------------------------------------------------------------------

; [ draw party equipment overview menu ]

DrawPartyEquipMenu:
@8eed:  lda     #$02
        sta     hBG1SC
        jsr     ClearBG2ScreenA
        ldy     #.loword(PartyEquipWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     _c38f1c
        jsr     _c38f36
        jsr     _c38f52
        jsr     _c38f6e
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     ClearBG3ScreenA
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c38f1c:
@8f1c:  lda     $69
        bmi     @8f35
        ldx     $6d
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$390d
        jsr     DrawCharName
        stz     $28
        lda     #$04
        jsr     _c38f8a
@8f35:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f36:
@8f36:  lda     $6a
        bmi     @8f51
        ldx     $6f
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$3b0d
        jsr     DrawCharName
        lda     #$01
        sta     $28
        lda     #$0c
        jsr     _c38f8a
@8f51:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f52:
@8f52:  lda     $6b
        bmi     @8f6d
        ldx     $71
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$3d0d
        jsr     DrawCharName
        lda     #$02
        sta     $28
        lda     #$14
        jsr     _c38f8a
@8f6d:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f6e:
@8f6e:  lda     $6c
        bmi     @8f89
        ldx     $73
        stx     $67
        lda     #$20
        sta     $29
        ldy     #$3f0d
        jsr     DrawCharName
        lda     #$03
        sta     $28
        lda     #$1c
        jsr     _c38f8a
@8f89:  rts

; ------------------------------------------------------------------------------

; [  ]

_c38f8a:
@8f8a:  sta     $e2
        stz     $e0
        ldy     $67
        clr_ax
@8f92:  phx
        phy
        phy
        phx
        stz     $e5
        lda     f:_c38fd5,x
        sta     $e4
        lda     f:_c38fdb,x
        clc
        adc     $e2
        ldx     $e4
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        plx
        cpx     #$0002
        bcs     @8fbe
        jsr     _c3941d
        bra     @8fc0
@8fbe:  stz     $e0
@8fc0:  ply
        clr_a
        lda     $001f,y
        jsr     _c38fe1
        jsr     DrawPosTextBuf
        ply
        iny
        plx
        inx
        cpx     #6
        bne     @8f92
        rts

; ------------------------------------------------------------------------------

_c38fd5:
@8fd5:  .byte   $02,$11,$02,$11,$02,$11

_c38fdb:
@8fdb:  .byte   $01,$01,$03,$03,$05,$05

; ------------------------------------------------------------------------------

; [  ]

_c38fe1:
@8fe1:  pha
        ldx     #$9e8b
        stx     hWMADDL
@8fe8:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @8fe8
        clr_a
        lda     $e0
        beq     @8ff7
        pla
        bra     @8ffc
@8ff7:  pla
        cmp     #$ff
        beq     @901f
@8ffc:  sta     hM7A
        stz     hM7A
        lda     #13
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #13
@9010:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @9010
        stz     hWMDATA
        rts
@901f:  ldy     #$000d
        lda     #$ff
@9024:  sta     hWMDATA
        dey
        bne     @9024
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

PartyEquipWindow:
@902e:  .byte   $8b,$58,$1c,$18

; ------------------------------------------------------------------------------

; [ draw equip menu ]

DrawEquipMenu:
@9032:  jsr     DrawEquipRelicCommon
        jsr     _c3911b
        lda     #$2c
        sta     $29
        ldx     #.loword(EquipSlotTextList)
        ldy     #$0004
        jsr     DrawPosList
        jsr     DrawEquipOptions
        jsr     TfrBG3ScreenAB
        jmp     _c39e0f

; ------------------------------------------------------------------------------

; [ draw equip options (equip, optimum, remove, empty) ]

DrawEquipOptions:
@904e:  lda     #$20
        sta     $29
        ldx     #.loword(EquipOptionTextList)
        ldy     #$0008
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw relic options (equip, remove) ]

DrawRelicOptions:
@905c:  lda     #$20
        sta     $29
        ldx     #.loword(RelicOptionTextList)
        ldy     #$0004
        jsr     DrawPosList
        rts

; ------------------------------------------------------------------------------

; [ draw relic menu ]

DrawRelicMenu:
@906a:  jsr     DrawEquipRelicCommon
        jsr     GetSelCharPropPtr
        lda     $0023,y
        sta     $b0
        lda     $0024,y
        sta     $b1
        jsr     _c39131
        lda     #$2c
        sta     $29
        ldx     #.loword(RelicSlotTextList)
        ldy     #$0004
        jsr     DrawPosList
        jsr     DrawRelicOptions
        jsr     _c3a6ab
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ draw common parts of equip/relic menu ]

DrawEquipRelicCommon:
@9093:  jsr     UpdateEquipStats
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$01
        sta     hBG1SC
        lda     #$42
        sta     hBG3SC
        jsr     _c3960c
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        ldy     #.loword(EquipBtmWindow1)
        jsr     DrawWindow
        ldy     #.loword(EquipTopWindow1)
        jsr     DrawWindow
        ldy     #.loword(EquipOptionsWindow)
        jsr     DrawWindow
        ldy     #.loword(EquipBtmWindow2)
        jsr     DrawWindow
        ldy     #.loword(EquipTopWindow2)
        jsr     DrawWindow
        ldy     #.loword(EquipTitleWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        jsr     TfrBG1ScreenAB
        jsr     TfrBG1ScreenBC
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     _c393e5
        jsr     CreateEquipPortraitTask
        lda     #$2c
        sta     $29
        ldx     #.loword(EquipStatTextList1)
        ldy     #$001c
        jsr     DrawPosList
        lda     #$2c
        sta     $29
        ldx     #.loword(EquipStatTextList2)
        ldy     #$0008
        jsr     DrawPosList
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [ update character battle stats ]

UpdateEquipStats:
@9110:  clr_a
        lda     $28                     ; character slot
        tax
        lda     $69,x                   ; character number
        jsl     UpdateEquip_ext
        rts

; ------------------------------------------------------------------------------

; [ redraw items in equip menu ]

_c3911b:
@911b:  jsr     _c39975
        lda     #$20
        sta     $29
        jsr     _c3913e
        jsr     _c3922d
        jsr     _c393fc
        jsr     _c39435
        jmp     _c39443

; ------------------------------------------------------------------------------

; [  ]

_c39131:
@9131:  lda     #$20
        sta     $29
        jsr     _c3913e
        jsr     _c39451
        jmp     _c3945f

; ------------------------------------------------------------------------------

; [  ]

_c3913e:
@913e:  jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        jsr     CheckHandEffects
        jsr     _c39207
        phb
        lda     #$7e
        pha
        plb
        jsr     _c391c4
        lda     $3006
        jsr     HexToDec3
        ldx     #$7cb7
        jsr     DrawNum3
        lda     $3004
        jsr     HexToDec3
        ldx     #$7d37
        jsr     DrawNum3
        lda     $3002
        jsr     HexToDec3
        ldx     #$7db7
        jsr     DrawNum3
        lda     $3000
        jsr     HexToDec3
        ldx     #$7e37
        jsr     DrawNum3
        jsr     _c393ab
        ldx     $f1
        stx     $f3
        jsr     HexToDec5
        ldx     #$7eb7
        jsr     Draw16BitNum
        lda     $301a
        jsr     HexToDec3
        ldx     #$7f37
        jsr     DrawNum3
        lda     $3008
        jsr     HexToDec3
        ldx     #$7fb7
        jsr     DrawNum3
        lda     $301b
        jsr     HexToDec3
        ldx     #$8037
        jsr     DrawNum3
        lda     $300a
        jsr     HexToDec3
        ldx     #$80b7
        jsr     DrawNum3
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c391c4:
@91c4:  jsr     GetSelCharPropPtr
        lda     $7e3032
        jsr     _c391ec
        lda     $3034
        and     #$01
        bne     @91dc
        lda     $0015,y
        and     #$01
        beq     @91eb
@91dc:  lda     $3034
        clc
        and     #$01
        sta     $e0
        ror2
        ora     $e0
        sta     $0015,y
@91eb:  rts

; ------------------------------------------------------------------------------

; [  ]

_c391ec:
@91ec:  and     #$25
        eor     #$ff
        sta     $e1
        lda     $0014,y
        and     $e1
        sta     $0014,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c391fb:
@91fb:  clc
        and     #$01
        ror2
        ora     $0015,y
        sta     $0015,y
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39207:
@9207:  ldx     $00
        longa
@920b:  lda     $11a0,x
        sta     $7e3000,x
        inx2
        lda     $11a0,x
        sta     $7e3000,x
        inx2
        cpx     #$0040
        bne     @920b
        shorta
        lda     $a1
        sta     $a0
        lda     $cd
        sta     $ce
        rts

; ------------------------------------------------------------------------------

; [ no effect ]

_c3922d:
@922d:  rts

; ------------------------------------------------------------------------------

; [ unused ??? ]

_c3922e:
@922e:  lda     #$2c
        sta     $29
        rts

; ------------------------------------------------------------------------------

; [ update modified stats text ]

_c39233:
@9233:  lda     $7e9d89     ; length of item list
        beq     @923e       ; branch if list is empty
        jsr     CheckCanEquipSelItem
        bcs     @9241       ; branch if item can be equipped
@923e:  jmp     _c39c87
@9241:  jsr     GetSelCharPropPtr
        lda     $25         ; main menu position
        cmp     #$02
        beq     @924e       ; branch if equip
        iny4                ; add 4 to character data pointer (relic)
@924e:  longac
        tya
        shorta
        adc     $5f         ; add item slot
        tay
        clr_a
        lda     $4b         ; selected item
        tax
        lda     $7e9d8a,x   ; item number
        tax
        lda     $001f,y     ; $64 = character's equipped item
        sta     $64
        lda     $1869,x     ; selected item
        sta     $001f,y     ; equip on character
        phy
        jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        jsr     CheckHandEffects
        jsr     _c39320
        lda     $11a6       ; vigor
        jsr     HexToDec3
        ldx     #$7cbf      ; (27,17)
        lda     $7e3040     ; vigor text color
        sta     $29
        jsr     DrawNum3
        lda     $11a4
        jsr     HexToDec3
        ldx     #$7d3f      ; (27,19)
        lda     $7e3041
        sta     $29
        jsr     DrawNum3
        lda     $11a2
        jsr     HexToDec3
        ldx     #$7dbf      ; (27,21)
        lda     $7e3042
        sta     $29
        jsr     DrawNum3
        lda     $11a0
        jsr     HexToDec3
        ldx     #$7e3f      ; (27,23)
        lda     $7e3043
        sta     $29
        jsr     DrawNum3
        jsr     _c39371
        jsr     HexToDec5
        ldx     #$7ebf      ; (27,25)
        lda     $7e3048
        sta     $29
        jsr     Draw16BitNum
        lda     $11ba
        jsr     HexToDec3
        ldx     #$7f3f      ; (27,27)
        lda     $7e3044
        sta     $29
        jsr     DrawNum3
        lda     $11a8
        jsr     HexToDec3
        ldx     #$7fbf      ; (27,29)
        lda     $7e3045
        sta     $29
        jsr     DrawNum3
        lda     $11bb
        jsr     HexToDec3
        ldx     #$803f      ; (27,31)
        lda     $7e3046
        sta     $29
        jsr     DrawNum3
        lda     $11aa
        jsr     HexToDec3
        ldx     #$80bf      ; (27,33)
        lda     $7e3047
        sta     $29
        jsr     DrawNum3
        ply
        lda     $64         ; restore equipped item
        sta     $001f,y
        rts

; ------------------------------------------------------------------------------

; [ update stat text colors ]

_c39320:
@9320:  phb
        lda     #$7e
        pha
        plb
        clr_ax
@9327:  lda     f:_c39369,x   ; pointer to battle stat
        phx
        tax
        lda     f:$0011a0,x   ; stat with item equipped
        cmp     $3000,x     ; compare with saved stat
        beq     @933c       ; branch if no change
        bcc     @9340       ; branch if less
        lda     #$28        ; yellow text
        bra     @9342
@933c:  lda     #$20        ; white text
        bra     @9342
@9340:  lda     #$24        ; gray text
@9342:  plx
        sta     $3040,x     ; set high byte of bg data
        inx                 ; next stat
        cpx     #8
        bne     @9327
        jsr     _c39371
        jsr     _c393ab
        ldy     $f3
        cpy     $f1
        beq     @935e
        bcc     @9362
        lda     #$28        ; yellow text
        bra     @9364
@935e:  lda     #$20        ; white text
        bra     @9364
@9362:  lda     #$24        ; gray text
@9364:  sta     $3048       ; set high byte of bg data for bat.pwr
        plb
        rts

; ------------------------------------------------------------------------------

; pointers to battle stats (+$11a0) vigor, speed, stamina, mag.pwr, defense, evade, magic defense, mblock
_c39369:
@9369:  .byte   $06,$04,$02,$00,$1a,$08,$1b,$0a

; ------------------------------------------------------------------------------

; [ calculate battle power (equipped weapons) ]

; +$f3 = battle power (out)

_c39371:
@9371:  lda     $a1         ; branch if no gauntlet bonus
        beq     @938b
        lda     f:$0011ac     ; right hand battle power
        beq     @9381       ; branch if right hand empty
        sta     f:$0011ad     ; save as left hand battle power
        bra     @939a
@9381:  lda     f:$0011ad     ; copy left hand battle power to right hand (double battle power)
        sta     f:$0011ac
        bra     @939a
@938b:  lda     $cd         ; branch if wearing genji glove
        bne     @939a
        lda     f:$0011ac
        beq     @939a
        clr_a
        sta     f:$0011ad
@939a:  lda     f:$0011ac
        clc
        adc     f:$0011ad
        sta     $f3
        clr_a
        adc     #$00
        sta     $f4
        rts

; ------------------------------------------------------------------------------

; [ calculate battle power (saved weapons) ]

; +$f1 = battle power (out)

_c393ab:
@93ab:  lda     $a0
        beq     @93c5
        lda     $7e300c
        beq     @93bb
        sta     $7e300d
        bra     @93d4
@93bb:  lda     $7e300d
        sta     $7e300c
        bra     @93d4
@93c5:  lda     $ce
        bne     @93d4
        lda     $7e300c
        beq     @93d4
        clr_a
        sta     $7e300d
@93d4:  lda     $7e300c
        clc
        adc     $7e300d
        sta     $f1
        clr_a
        adc     #$00
        sta     $f2
        rts

; ------------------------------------------------------------------------------

; [  ]

_c393e5:
@93e5:  jsr     GetSelCharPropPtr
        lda     #$20
        sta     $29
        ldy     #$7bb7
        jmp     DrawCharName

; ------------------------------------------------------------------------------

; [ update pointer to current character data ]

GetSelCharPropPtr:
@93f2:  clr_a
        lda     $28         ; character slot
        asl
        tax
        ldy     $6d,x       ; pointer to character data
        sty     $67
        rts

; ------------------------------------------------------------------------------

; [  ]

_c393fc:
@93fc:  jsr     _c3941d
        ldx     #$7a1b
        jsr     _c3946d
        lda     $001f,y
        jsr     _c38fe1
        jsr     DrawPosTextBuf
        jsr     _c3941d
        ldx     #$7a9b
        jsr     _c3946d
        lda     $0020,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3941d:
@941d:  jsr     GetSelCharPropPtr
        lda     $001f,y
        cmp     #$ff
        bne     @9432
        lda     $0020,y
        cmp     #$ff
        bne     @9432
        sta     $e0
        bra     @9434
@9432:  stz     $e0
@9434:  rts

; ------------------------------------------------------------------------------

; [  ]

_c39435:
@9435:  ldx     #$7b1b
        jsr     _c3946d
        stz     $e0
        lda     $0021,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c39443:
@9443:  ldx     #$7b9b
        jsr     _c3946d
        stz     $e0
        lda     $0022,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c39451:
@9451:  ldx     #$7b1b
        jsr     _c3946d
        stz     $e0
        lda     $0023,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3945f:
@945f:  ldx     #$7b9b
        jsr     _c3946d
        stz     $e0
        lda     $0024,y
        jmp     _c39479

; ------------------------------------------------------------------------------

; [  ]

_c3946d:
@946d:  longa
        txa
        sta     $7e9e89
        shorta
        jmp     GetSelCharPropPtr

; ------------------------------------------------------------------------------

; [  ]

_c39479:
@9479:  jsr     _c38fe1
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; inventory/stats window
EquipBtmWindow1:
@947f:  .byte   $4b,$5b,$1c,$0d

; current equipped items window
EquipTopWindow1:
@9483:  .byte   $0b,$59,$1c,$07

; equip options window (equip, optimum, remove, empty)
EquipOptionsWindow:
@9487:  .byte   $8b,$58,$1c,$02

; inventory/stats window
EquipBtmWindow2:
@948b:  .byte   $4b,$63,$1c,$0d

; current equipped items window
EquipTopWindow2:
@948f:  .byte   $0b,$61,$1c,$07

; equip title window
EquipTitleWindow:
@9493:  .byte   $b7,$60,$06,$02

; ------------------------------------------------------------------------------

; [ init BG scroll HDMA for party equipment overview ]

; also used for final battle order

InitPartyEquipScrollHDMA:
@9497:  lda     #$02
        sta     $4350
        lda     #$0e
        sta     $4351
        ldy     #.loword(_c395d8)
        sty     $4352
        lda     #^_c395d8
        sta     $4354
        lda     #^_c395d8
        sta     $4357
        lda     #$20
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ init BG scroll HDMA for equip/relic menu ]

InitEquipScrollHDMA:
@94b6:  lda     #$02
        sta     $4350
        lda     #$12
        sta     $4351
        ldy     #.loword(_c395d8)
        sty     $4352
        lda     #^_c395d8
        sta     $4354
        lda     #^_c395d8
        sta     $4357
        lda     #$20
        tsb     $43
        jsr     LoadEquipBG1VScrollHDMATbl
        ldx     $00
@94d9:  lda     f:_c39564,x
        sta     $7e9bc9,x
        inx
        cpx     #$000d
        bne     @94d9
        lda     #$02
        sta     $4360
        lda     #$0d
        sta     $4361
        ldy     #$9bc9
        sty     $4362
        lda     #$7e
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$02
        sta     $4370
        lda     #$0e
        sta     $4371
        ldy     #$9849
        sty     $4372
        lda     #$7e
        sta     $4374
        lda     #$7e
        sta     $4377
        lda     #$c0
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll HDMA table for equip/relic item list ]

LoadEquipBG1VScrollHDMATbl:
@9520:  ldx     $00
@9522:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @9522
@9530:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        clr_a
        lda     $49
        asl4
        and     #$ff
        longac
        adc     f:_c39571,x
        sta     $7e9849,x
        shorta
        inx2
        cpx     #$0063
        bne     @9530
@9555:  lda     f:_c39571,x
        sta     $7e9849,x
        inx
        cpx     #$0067
        bne     @9555
        rts

; ------------------------------------------------------------------------------

_c39564:
@9564:  .byte   $27,$00,$01
        .byte   $3c,$00,$01
        .byte   $6c,$00,$00
        .byte   $1e,$00,$01
        .byte   $00

; ------------------------------------------------------------------------------

_c39571:
@9571:  .byte   $3f,$00,$00
        .byte   $0c,$04,$00
        .byte   $0c,$08,$00
        .byte   $0a,$0c,$00
        .byte   $01,$0c,$00
        .byte   $01,$0c,$00
        .byte   $04,$a0,$ff
        .byte   $04,$a0,$ff
        .byte   $04,$a0,$ff
        .byte   $04,$a4,$ff
        .byte   $04,$a4,$ff
        .byte   $04,$a4,$ff
        .byte   $04,$a8,$ff
        .byte   $04,$a8,$ff
        .byte   $04,$a8,$ff
        .byte   $04,$ac,$ff
        .byte   $04,$ac,$ff
        .byte   $04,$ac,$ff
        .byte   $04,$b0,$ff
        .byte   $04,$b0,$ff
        .byte   $04,$b0,$ff
        .byte   $04,$b4,$ff
        .byte   $04,$b4,$ff
        .byte   $04,$b4,$ff
        .byte   $04,$b8,$ff
        .byte   $04,$b8,$ff
        .byte   $04,$b8,$ff
        .byte   $04,$bc,$ff
        .byte   $04,$bc,$ff
        .byte   $04,$bc,$ff
        .byte   $04,$c0,$ff
        .byte   $04,$c0,$ff
        .byte   $04,$c0,$ff
        .byte   $1e,$10,$00
        .byte   $00

; ------------------------------------------------------------------------------

_c395d8:
@95d8:  .byte   $0f,$00,$00
        .byte   $0c,$04,$00
        .byte   $0c,$08,$00
        .byte   $0c,$0c,$00
        .byte   $0c,$10,$00
        .byte   $0c,$14,$00
        .byte   $0c,$18,$00
        .byte   $0c,$1c,$00
        .byte   $0c,$20,$00
        .byte   $0c,$24,$00
        .byte   $0c,$28,$00
        .byte   $0c,$2c,$00
        .byte   $0c,$30,$00
        .byte   $0c,$34,$00
        .byte   $0c,$38,$00
        .byte   $0c,$3c,$00
        .byte   $0c,$40,$00
        .byte   $00

; ------------------------------------------------------------------------------

; [  ]

_c3960c:
@960c:  jsr     ClearEquipOptionText
        ldy     $00
        sty     $39
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39614:
@9614:  jsr     ClearEquipOptionText
        ldy     #$0100
        sty     $39
        lda     #$2c
        sta     $29
        rts

; ------------------------------------------------------------------------------

; [ menu state $36: equip menu options (equip, optimum, remove, empty) ]

MenuState_36:
@9621:  jsr     _c3960c
        jsr     DrawEquipOptions
        jsr     UpdateEquipOptionCursor
        lda     $08
        bit     #$80
        beq     @9635
        jsr     PlaySelectSfx
        bra     SelectEquipOption
@9635:  lda     $09
        bit     #$80
        beq     @9648
        jsr     PlayCancelSfx
        jsr     UpdateEquipStats
        lda     #$04
        sta     $27
        stz     $26
        rts
@9648:  lda     #$35
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ draw "EQUIP" title in equip/relic menu ]

DrawEquipTitleEquip:
@964f:  ldy     #.loword(EquipTitleEquipText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ draw "REMOVE" title in equip/relic menu ]

DrawEquipTitleRemove:
@9656:  ldy     #.loword(EquipTitleRemoveText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ clear equip options ]

ClearEquipOptionText:
@965d:  ldy     #.loword(EquipBlankOptionsText)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [ select equip option (equip, optimum, remove, empty) ]

SelectEquipOption:
@9664:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectEquipOptionTbl),x)

SelectEquipOptionTbl:
@966c:  .addr   SelectEquipOption_00
        .addr   SelectEquipOption_01
        .addr   SelectEquipOption_02
        .addr   SelectEquipOption_03

; ------------------------------------------------------------------------------

; [ 0: equip ]

SelectEquipOption_00:
@9674:  jsr     _c39614
        jsr     DrawEquipTitleEquip
        jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$55
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ 1: optimum ]

SelectEquipOption_01:
@9685:  jsr     EquipOptimum
        jsr     _c3911b
        stz     $4d
        rts

; ------------------------------------------------------------------------------

; [ 2: remove ]

SelectEquipOption_02:
@968e:  jsr     _c39614
        jsr     DrawEquipTitleRemove
        jsr     LoadEquipSlotCursor
        jsr     InitEquipSlotCursor
        lda     #$56
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ 3: empty ]

SelectEquipOption_03:
@969f:  jsr     EquipRemoveAll
        jsr     _c3911b
        stz     $4d
        rts

; ------------------------------------------------------------------------------

; [ remove character's equipment ]

EquipRemoveAll:
@96a8:  jsr     GetSelCharPropPtr
        lda     $001f,y                 ; add weapon to inventory
        jsr     IncItemQty
        lda     $0020,y                 ; add shield to inventory
        jsr     IncItemQty
        lda     $0021,y                 ; add helmet to inventory
        jsr     IncItemQty
        lda     $0022,y                 ; add armor to inventory
        jsr     IncItemQty
        lda     #$ff
        sta     $001f,y                 ; remove weapon
        sta     $0020,y                 ; remove shield
        sta     $0021,y                 ; remove helmet
        sta     $0022,y                 ; remove armor
        rts

; ------------------------------------------------------------------------------

; [ optimize a character's equipment (from field) ]

; $0201 = character number

OptimizeCharEquip:
@96d2:  jsr     InitCharProp
        clr_ax
        lda     $0201                   ; character number
@96da:  cmp     $69,x                   ; look for character in party
        beq     @96e6
        inx
        cpx     #4
        bne     @96da
@96e4:  bra     @96e4                   ; infinite loop
@96e6:  txa
        sta     $28                     ; $28 = character slot
        jsr     UpdateEquipStats
        jsr     EquipOptimum
        rtl

; ------------------------------------------------------------------------------

; [ set optimum equipment ]

EquipOptimum:
@96f0:  jsr     UpdateEquipStats
        jsr     EquipRemoveAll
        jsr     GetSelCharPropPtr
        sty     $f3                     ; +$f3 = pointer to character data
        lda     $11d8                   ; gauntlet effect
        and     #$08
        beq     @971a                   ; branch if not set

; select optimum 2-handed weapon
        stz     $4b
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        jsr     GetBest2Hand
        ldy     $f3
        sta     $001f,y                 ; set main-hand
        jsr     DecItemQty
        bra     @976b

; select optimum one-handed weapon
@971a:  stz     $4b                     ; cursor position = 0 (main hand)
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $001f,y                 ; set main hand
        jsr     DecItemQty
        lda     $11d8                   ; genji glove effect
        and     #$10
        bne     @9751                   ; branch if second hand can use a weapon

; select optimum shield
        lda     #$01                    ; cursor position = 1 (off-hand)
        sta     $4b
        jsr     GetValidEquip
        jsr     GetValidShields
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0020,y                 ; set off-hand
        jsr     DecItemQty
        bra     @976b

; genji glove (equip a weapon in off-hand)
@9751:  lda     #$01                    ; cursor position = 1 (off-hand)
        sta     $4b
        jsr     GetValidEquip
        jsr     GetValidWeapons
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0020,y                 ; set off-hand
        jsr     DecItemQty
        bra     @976b

; select optimum helmet & armor
@976b:  lda     #$02                    ; cursor position = 2 (helmet)
        sta     $4b
        jsr     GetValidEquip
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0021,y                 ; set helmet
        jsr     DecItemQty
        lda     #$03                    ; cursor position = 3 (armor)
        sta     $4b
        jsr     GetValidEquip
        jsr     SortValidEquip
        ldy     $f3
        jsr     GetBestEquip
        sta     $0022,y                 ; set armor
        jmp     DecItemQty

; ------------------------------------------------------------------------------

; [ update list of equippable weapons ]

GetValidWeapons:
@9795:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        ldx     $00
        txy
@979e:  clr_a
        lda     $1869,y     ; item in inventory
        cmp     #$ff
        beq     @97c8       ; branch if slot is empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$01
        bne     @97c8       ; branch if not a weapon
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @97c8       ; branch if not equippable
        shorta
        tya
        sta     hWMDATA       ; add to list of weapons
        inc     $e0
@97c8:  shorta        ; next item
        iny
        cpy     #$00ff
        bne     @979e
        lda     $e0         ; set length of list
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ update list of equippable shields ]

GetValidShields:
@97d7:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        ldx     $00
        txy
@97e0:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @980a
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$03
        bne     @980a
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @980a
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@980a:  shorta
        iny
        cpy     #$00ff
        bne     @97e0
        lda     $e0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ select the best item in the list ]

GetBestEquip:
@9819:  phy
        phb
        lda     #$7e
        pha
        plb
        clr_ay
@9821:  clr_ax
@9823:  phx
        clr_a
        lda     $9d8a,y     ; position in inventory
        tax
        lda     $1869,x     ; item number
        plx
        cmp     f:ImpItem,x
        beq     @983c       ; branch if this is an imp item
        inx
        cpx     #$000a
        bne     @9823
        plb
        ply
        rts

; imp item
@983c:  iny
        bra     @9821

; ------------------------------------------------------------------------------

; [ select the best 2-handed weapon in the list ]

GetBest2Hand:
@983f:  lda     $7e9d89     ; branch if there are items in the list
        beq     @9881
        sta     $cb         ; +$cb = number of items in list
        stz     $cc
        clr_ay
@984b:  clr_ax
@984d:  phx
        clr_a
        tyx
        lda     $7e9d8a,x   ; position in inventory
        tax
        lda     $1869,x     ; item number
        plx
        cmp     f:ImpItem,x
        beq     @9878       ; branch if this is an imp item
        inx
        cpx     #$000a      ; number of imp items
        bne     @984d
        sta     $c9         ; $c9 = item number
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; 2-handed weapon
        and     #$40
        beq     @9878       ; branch if not 2-handed
        lda     $c9
        rts

; imp item
@9878:  iny
        cpy     $cb
        bne     @984b       ; branch if this is not the last item in the list
        jsr     GetBestEquip
        rts

; no suitable items
@9881:  lda     #$ff        ; empty
        rts

; ------------------------------------------------------------------------------

; [ menu state $55: equip (slot select, equip) ]

MenuState_55:
@9884:  jsr     UpdateEquipSlotCursor
        jsr     _c39975

; A button
        lda     $08
        bit     #$80
        beq     @98b4
        jsr     PlaySelectSfx
        lda     $4e                     ; save cursor position
        sta     $5f
        lda     #$57                    ; go to menu state $57
        sta     $26
        jsr     GetValidEquip
        jsr     SortValidEquip
        jsr     InitEquipListCursor
        lda     #$55                    ; return to menu state $55 afterwards
        sta     $27
        jsr     _c39233
        jsr     ClearBG1ScreenA
        jsr     WaitVblank
        jmp     DrawEquipItemList

; B button
@98b4:  lda     $09
        bit     #$80
        beq     @98c8
        jsr     PlayCancelSfx
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        lda     #$36                    ; go to menu state $36
        sta     $26
        rts
@98c8:  lda     #$7e                    ; go to menu state $7e if user presses top r or l button
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ menu state $56: equip (slot select, remove) ]

MenuState_56:
@98cf:  jsr     UpdateEquipSlotCursor
        lda     $08
        bit     #$80
        beq     @98f4
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $4b
        tay
        lda     $001f,y
        jsr     IncItemQty
        lda     #$ff
        sta     $001f,y
        jsr     _c3911b
@98f4:  lda     $09
        bit     #$80
        beq     @9908
        jsr     PlayCancelSfx
        jsr     LoadEquipOptionCursor
        jsr     InitEquipOptionCursor
        lda     #$36
        sta     $26
        rts
@9908:  lda     #$7f
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ menu state $57: equip (item select) ]

MenuState_57:
@990f:  jsr     _c39ad3
        jsr     _c39233
        lda     $08
        bit     #$80
        beq     @9944
        jsr     CheckCanEquipSelItem
        bcc     @996e
        jsr     PlaySelectSfx
        lda     $001f,y
        cmp     #$ff
        beq     @992d
        jsr     IncItemQty
@992d:  clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        sta     $001f,y
        jsr     DecItemQty
        jsr     _c3911b
        bra     @994d
@9944:  lda     $09
        bit     #$80
        beq     @996d
        jsr     PlayCancelSfx
@994d:  jsr     _c39c87
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$c1
        trb     $46
        jsr     LoadEquipSlotCursor
        lda     $5f
        sta     $4e
        jsr     InitEquipSlotCursor
        lda     #$55
        sta     $26
@996d:  rts
@996e:  jsr     PlayInvalidSfx
        jsr     CreateMosaicTask
        rts

; ------------------------------------------------------------------------------

; [ draw "r-hand" & "l-hand" text ]

_c39975:
@9975:  lda     $11d8       ; gauntlet effect
        and     #$08
        beq     @998f       ; branch if no gauntlet
        jsr     GetSelCharPropPtr
        lda     $001f,y     ; right hand (main hand)
        cmp     #$ff
        beq     @99a6       ; branch if empty
        lda     $0020,y     ; left hand (off-hand)
        cmp     #$ff
        beq     @99ca       ; branch if empty
        bra     @998f

; draw both hands with teal text
@998f:  lda     #$2c        ; teal text
        sta     $29
        jsr     @9998
        bra     @999f

; draw "R-Hand" text
@9998:  ldy     #.loword(EquipRHandText)
        jsr     DrawPosText
        rts

; draw "L-Hand" text
@999f:  ldy     #.loword(EquipLHandText)
        jsr     DrawPosText
        rts

; gauntlet, main hand empty
@99a6:  lda     $0020,y     ; left hand (off-hand)
        cmp     #$ff
        bne     @99af       ; branch if not empty
        bra     @998f       ; both hands empty, draw both with teal text

; gauntlet, right hand empty
@99af:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon effects
        and     #$40
        beq     @998f       ; branch if not 2-handed
        lda     #$24        ; gray text
        sta     $29
        jsr     @9998       ; draw "r-hand" text
        lda     #$2c        ; teal text
        sta     $29
        bra     @999f       ; draw "l-hand" text

; gauntlet, left hand empty
@99ca:  lda     $001f,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x
        and     #$40
        beq     @998f
        lda     #$2c        ; teal text
        sta     $29
        jsr     @9998       ; draw "r-hand" text
        lda     #$24        ; gray text
        sta     $29
        bra     @999f       ; draw "l-hand" text

; ------------------------------------------------------------------------------

; [ update gauntlet & genji glove effects ]

; $cd = 1 for genji glove
; $a1 = 1 for gauntlet bonus
; carry set = no gauntlet bonus
; carry clear = gauntlet w/ 2-handed weapon & no shield

CheckHandEffects:
@99e8:  stz     $cd         ; $cd = 0
        lda     $11d8       ; branch if character doesn't have genji glove
        and     #$10
        beq     @99f3
        inc     $cd         ; $cd++
@99f3:  stz     $a1         ;
        lda     $11d8       ; branch if character doesn't have gauntlet
        and     #$08
        beq     @9a0c
        lda     $001f,y     ; branch if right hand is empty
        cmp     #$ff
        beq     @9a0e
        lda     $0020,y     ; branch if left hand is empty
        cmp     #$ff
        beq     @9a2b
        bra     @9a0c       ; set carry and return
@9a0c:  sec
        rts
@9a0e:  lda     $0020,y     ; branch if left hand is not empty
        cmp     #$ff
        bne     @9a17
        bra     @9a0c       ; set carry and return
@9a17:  jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon properties
        and     #$40
        beq     @9a0c       ; set carry and return if not a 2-handed weapon
        clc
        lda     #$01
        sta     $a1
        rts
@9a2b:  lda     $001f,y     ; right hand
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+19,x   ; weapon properties
        and     #$40
        beq     @9a0c       ; set carry and return if not a 2-handed weapon
        clc
        lda     #$01
        sta     $a1
        rts

; ------------------------------------------------------------------------------

; [ check if selected item can be equipped ]

CheckCanEquipSelItem:
@9a42:  jsr     GetEquipSlotPtr
        clr_a
        lda     $4b                     ; cursor position
        bra     CheckCanEquipItem

; ------------------------------------------------------------------------------

; [ get pointer to current item slot ]

GetEquipSlotPtr:
@9a4a:  jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $5f                     ; add item slot number
        tay
        rts

; ------------------------------------------------------------------------------

; [ check if item can be equipped ]

;  a = position in list
; +y = pointer to current item slot
; carry set = item can be equipped, carry clear = item can't be equipped

CheckCanEquipItem:
@9a56:  phy
        tax
        lda     $7e9d8a,x               ; selected item
        tax
        lda     $1869,x                 ; item number
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; $f6 = item type
        and     #$07
        sta     $f6
        ply
        lda     $5f                     ; selected item slot
        cmp     #$02
        bcs     @9acf                   ; set carry and return if helmet or armor
        cmp     #$01
        beq     @9aa5

; right hand is selected
        lda     $0020,y                 ; left hand item
        cmp     #$ff
        beq     @9a97                   ; set carry and return if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     #$03
        beq     @9a99                   ; branch if shield
        lda     $11d8
        and     #$10
        beq     @9a99                   ; branch if character has genji glove effect
@9a97:  sec
        rts
@9a99:  lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     $f6                     ; clear carry and return if same as selected item
        beq     @9ad1
        sec
        rts

; left hand is selected
@9aa5:  lda     $001e,y                 ; right hand item
        cmp     #$ff
        beq     @9ac3                   ; set carry and return if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     #$03
        beq     @9ac5                   ; branch if shield
        lda     $11d8
        and     #$10
        beq     @9ac5                   ; branch if character has genji glove effect
@9ac3:  sec
        rts
@9ac5:  lda     f:ItemProp,x            ; item type
        and     #$07
        cmp     $f6                     ; clear carry and return if same as selected item
        beq     @9ad1
@9acf:  sec
        rts
@9ad1:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39ad3:
@9ad3:  lda     $7e9d89
        cmp     #$0a
        jcc     UpdateEquipShortListCursor
        lda     #$05
        sta     $2a
        jsr     ScrollListPage
        jcc     UpdateEquipLongListCursor
        rts

; ------------------------------------------------------------------------------

; [ init item list cursor (equip/relic) ]

InitEquipListCursor:
@9aeb:  lda     $7e9d89
        beq     @9b0c
        cmp     #10
        bcs     @9b06

; short list (less than 10 items)
        jsr     CreateEquipSlotCursorTask
        stz     $4a
        jsr     LoadEquipShortListCursor
        lda     $7e9d89
        sta     $54
        jmp     InitEquipShortListCursor

; long list (10 or more items)
@9b06:  jsr     CreateEquipSlotCursorTask
        jsr     _c39b0d
@9b0c:  rts

; ------------------------------------------------------------------------------

; [  ]

_c39b0d:
@9b0d:  stz     $4a
        jsr     CreateScrollArrowTask2
        longa
        lda     #$0060
        sta     $7e34ca,x
        lda     #$6000
        sta     hWRDIVL
        shorta
        lda     $7e9d89
        sec
        sbc     #9
        sta     hWRDIVB
        nop5
        longa
        lda     hRDDIVL
        sta     $7e354a,x
        shorta
        ldy     $00
        sty     $4f
        jsr     LoadEquipLongListCursor
        jsr     InitEquipLongListCursor
        lda     $7e9d89
        sec
        sbc     #$09
        sta     $5c
        lda     #$09
        sta     $5a
        lda     #$01
        sta     $5b
        rts

; ------------------------------------------------------------------------------

; [ update list of equippable items ]

; $4b = cursor position (0 = weapon, 1 = shield, 2 = helmet, 3 = armor)

GetValidEquip:
@9b59:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        lda     #$20
        sta     $29
        lda     $4b         ; cursor position
        cmp     #$02
        beq     @9bb2       ; branch if helmet
        cmp     #$03
        beq     @9b6f       ; branch if armor
        bra     @9b72       ; branch if weapon or shield
@9b6f:  jmp     @9bee

; weapon or shield
@9b72:  ldx     $00
        txy
@9b75:  clr_a
        lda     $1869,y     ; item number
        cmp     #$ff
        beq     @9ba3       ; branch if empty
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x   ; item type
        and     #$07
        cmp     #$01
        beq     @9b91       ; branch if weapon
        cmp     #$03
        bne     @9ba3       ; skip if not shield
@9b91:  longa
        lda     f:ItemProp+1,x   ; equippable characters
        bit     $e7
        beq     @9ba3       ; branch if not equippable
        shorta
        tya
        sta     hWMDATA       ; add to list of possible items
        inc     $e0         ; increment number of possible items
@9ba3:  shorta        ; next item
        iny
        cpy     #$00ff
        bne     @9b75
        lda     $e0         ; set length of list
        sta     $7e9d89
        rts

; helmet
@9bb2:  ldx     $00
        txy
@9bb5:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @9bdf
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$04
        bne     @9bdf
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @9bdf
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@9bdf:  shorta
        iny
        cpy     #$00ff
        bne     @9bb5
        lda     $e0
        sta     $7e9d89
        rts

; armor
@9bee:  ldx     $00
        txy
@9bf1:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @9c1b
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$02
        bne     @9c1b
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @9c1b
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@9c1b:  shorta
        iny
        cpy     #$00ff
        bne     @9bf1
        lda     $e0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ clear list of optimum items ]

ClearValidItemList:
@9c2a:  ldx     $00
        lda     #$ff
@9c2e:  sta     $7e9d8a,x
        inx
        cpx     #9
        bne     @9c2e
        ldx     #$9d8a
        stx     hWMADDL
        stz     $e0         ; $e0 = number of possible items
        rts

; ------------------------------------------------------------------------------

; [ get character equippability mask ]

; +$e7 = mask

GetCharEquipMask:
@9c41:  jsr     GetSelCharPropPtr
        clr_a
        lda     $0000,y                 ; actor number

chrequinf_get1:
_c39c48:
@9c48:  asl
        tax
        longa
        lda     f:CharEquipMaskTbl,x
        sta     $e7
        shorta
        lda     $11d8
        and     #$20
        beq     @9c66
        longa
        lda     $e7
        ora     #$8000
        sta     $e7
        shorta
@9c66:  rts

; ------------------------------------------------------------------------------

; character equippability masks
CharEquipMaskTbl:
@9c67:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [ clear modified stats text ]

_c39c87:
@9c87:  clr_ax
        ldy     #$0009      ; clear 9 lines
        longa
@9c8e:  sta     $7e7cbf,x   ; clear 100's digit
        inx2
        sta     $7e7cbf,x   ; clear 10's digit
        inx2
        sta     $7e7cbf,x   ; clear 1's digit
        inx2
        txa
        clc
        adc     #$007a      ; next line
        tax
        dey
        bne     @9c8e
        shorta
        rts

; ------------------------------------------------------------------------------

; [ draw item list text (equip/relic) ]

DrawEquipItemList:
@9cac:  lda     $7e9d89
        beq     @9cdd
        jsr     GetListTextPos
        clr_a
        lda     $7e9d89
        cmp     #$09
        bcc     @9cc0
        lda     #$09
@9cc0:  tay
@9cc1:  phy
        jsr     DrawEquipItemListRow
        inc     $e5
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @9cc1
        longa
        clr_a
        sta     $7e9bd0
        shorta
        rts
@9cdd:  lda     $27
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ draw one row of equip item list ]

DrawEquipItemListRow:
@9ce2:  jsr     GetEquipSlotPtr
        clr_a
        lda     $e5
        jsr     CheckCanEquipItem
        bcs     @9cf1
        lda     #$28
        bra     @9cf3
@9cf1:  lda     #$20
@9cf3:  sta     $29
        lda     $e6
        inc
        ldx     #$0002
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tay
        jsr     LoadEquipListItemName
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ load item name for equip item list ]

LoadEquipListItemName:
@9d11:  ldx     #$9e8b
        stx     hWMADDL
@9d17:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @9d17
        tyx
        clr_a
        lda     $7e9d8a,x
        tay
        lda     $1869,y
        cmp     #$ff
        beq     @9d4f
        sta     hM7A
        stz     hM7A
        lda     #13
        sta     hM7B
        sta     hM7B
        ldx     hMPYL
        ldy     #13
@9d40:  lda     f:ItemName,x
        sta     hWMDATA
        inx
        dey
        bne     @9d40
        stz     hWMDATA
        rts
@9d4f:  ldy     #13
        lda     #$ff
@9d54:  sta     hWMDATA
        dey
        bne     @9d54
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ add item to inventory ]

; A: item id

IncItemQty:
@9d5e:  phy
        sta     $e0
        ldy     $00
@9d63:  cmp     $1869,y
        beq     @9d8a
        cmp     #$ff
        beq     @9d95
        iny
        cpy     #$0100
        bne     @9d63
        ldy     $00
@9d74:  lda     $1869,y
        cmp     #$ff
        beq     @9d7e
        iny
        bra     @9d74
@9d7e:  lda     #1
        sta     $1969,y
        lda     $e0
        sta     $1869,y
        bra     @9d95
@9d8a:  lda     $1969,y
        cmp     #99
        beq     @9d95
        inc
        sta     $1969,y
@9d95:  ply
        rts

; ------------------------------------------------------------------------------

; [ remove item from inventory ]

; A: item id

DecItemQty:
@9d97:  phy
        sta     $e0
        ldy     $00
@9d9c:  cmp     $1869,y
        beq     @9da9
        iny
        cpy     #$0100
        bne     @9d9c
        ply
        rts
@9da9:  lda     $1969,y
        cmp     #1
        beq     @9db9
        lda     $1969,y
        dec
        sta     $1969,y
        bra     @9dc2
@9db9:  clr_a
        sta     $1969,y
        lda     #$ff
        sta     $1869,y
@9dc2:  ply
        rts

; ------------------------------------------------------------------------------

; [ create cursor task for equip menu slot cursor ]

CreateEquipSlotCursorTask:
@9dc4:  lda     #2
        ldy     #.loword(EquipSlotCursorTask)
        jsr     CreateTask
        longa
        lda     $55
        sta     $7e33ca,x
        lda     $57
        sta     $7e344a,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask:
@9ddd:  tax
        jmp     (.loword(EquipSlotCursorTaskTbl),x)

EquipSlotCursorTaskTbl:
@9de1:  .addr   EquipSlotCursorTask_00
        .addr   EquipSlotCursorTask_01

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask_00:
@9de5:  ldx     $2d
        lda     #$01
        tsb     $46
        longa
        lda     #.loword(CursorAnimData)
        sta     $32c9,x
        shorta
        lda     #^CursorAnimData
        sta     $35ca,x
        jsr     InitAnimTask
        inc     $3649,x
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

EquipSlotCursorTask_01:
@9e00:  lda     $46
        bit     #$01
        beq     @9e0d
        ldx     $2d
        jsr     UpdateAnimTask
        sec
        rts
@9e0d:  clc
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39e0f:
@9e0f:  jsr     _c39e23
        bra     _c39e37

; ------------------------------------------------------------------------------

; [  ]

_c39e14:
@9e14:  jsr     _c39e37
        lda     $021e
        and     #$01
        beq     @9e20
        bra     _c39e23
@9e20:  jmp     TfrBigTextGfx

; ------------------------------------------------------------------------------

; [  ]

_c39e23:
@9e23:  ldy     #$4000
        sty     $1b
        ldy     #$7849
        sty     $1d
        lda     #$7e
        sta     $1f
        ldy     #$0880
        sty     $19
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39e37:
@9e37:  ldy     #$0000
        sty     $14
        ldy     #$3849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0800
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ menu state $58: relic (init) ]

MenuState_58:
@9e4b:  jsr     _c39e50
        bra     _c39e6f

; ------------------------------------------------------------------------------

; [  ]

_c39e50:
@9e50:  jsr     DisableInterrupts
        jsr     DisableWindow1PosHDMA
        stz     $4a
        stz     $49
        lda     #$10
        tsb     $45
        stz     $99
        jsr     InitBigText
        jsr     InitEquipScrollHDMA
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        jmp     CreateCursorTask

; ------------------------------------------------------------------------------

; [  ]

_c39e6f:
@9e6f:  jsr     DrawRelicMenu
        lda     #$01
        sta     $26
        lda     #$59
        sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $79: switch character (relic equip) ]

MenuState_79:
@9e7d:  jsr     _c39e99
        jsr     DrawEquipTitleEquip
        jsr     _c39ea8
        lda     #$5a
        jmp     _c39eb3

; ------------------------------------------------------------------------------

; [ menu state $7a: switch character (relic remove) ]

MenuState_7a:
@9e8b:  jsr     _c39e99
        jsr     DrawEquipTitleRemove
        jsr     _c39ea8
        lda     #$5c
        jmp     _c39eb3

; ------------------------------------------------------------------------------

; [  ]

_c39e99:
@9e99:  jsr     _c39e50
        jsr     DrawRelicMenu
        jsr     _c39e37
        jsr     _c39e23
        jmp     _c39614

; ------------------------------------------------------------------------------

; [  ]

_c39ea8:
@9ea8:  jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$01
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39eb3:
@9eb3:  sta     $27
        jmp     EnableInterrupts

; ------------------------------------------------------------------------------

; [ menu state $59: relic options (equip/remove) ]

MenuState_59:
@9eb8:  jsr     _c39e23
        jsr     _c3960c
        jsr     DrawRelicOptions
        jsr     UpdateRelicOptionCursor
        lda     $08
        bit     #$80
        beq     @9ed0
        jsr     PlaySelectSfx
        jmp     SelectRelicOption
@9ed0:  lda     $09
        bit     #$80
        beq     @9edc
        jsr     PlayCancelSfx
        jsr     _c39eeb
@9edc:  jsr     _c39ee6
        lda     #$58
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [  ]

_c39ee6:
@9ee6:  lda     $26
        sta     $d1
        rts

; ------------------------------------------------------------------------------

; [ check reequip ]

_c39eeb:
@9eeb:  jsr     UpdateEquipStats
        jsr     GetSelCharPropPtr
        lda     $0000,y
        cmp     #$0d
        beq     @9eff
        jsr     _c39f5c
        lda     $99
        bne     @9f06
@9eff:  lda     #$04
        sta     $27
        stz     $26
        rts
@9f06:  lda     #$06
        trb     $46
        jsr     _c39e37
        jsr     _c39e23
        jsr     _c39f1c
        lda     #$f0
        sta     $22
        lda     #$6c
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39f1c:
@9f1c:  jsr     ClearEquipOptionText
        ldy     #.loword(_c3a40f)
        jsr     DrawPosText
        lda     $1d4e
        and     #$10
        beq     @9f44
        lda     #$6e
        sta     $27
        lda     $d1
        cmp     #$59
        beq     @9f3d
        ldy     #.loword(_c3a3fd)
        jsr     DrawPosText
        rts
@9f3d:  ldy     #.loword(_c3a3eb)
        jsr     DrawPosText
        rts
@9f44:  lda     #$6d
        sta     $27
        lda     $d1
        cmp     #$59
        beq     @9f55
        ldy     #.loword(_c3a405)
        jsr     DrawPosText
        rts
@9f55:  ldy     #.loword(_c3a3f3)
        jsr     DrawPosText
        rts

; ------------------------------------------------------------------------------

; [  ]

_c39f5c:
@9f5c:  jsr     GetSelCharPropPtr
        lda     $0023,y
        cmp     $b0
        bne     @9f6f
        lda     $0024,y
        cmp     $b1
        bne     @9f6f
        bra     @9fa9
@9f6f:  lda     $b0
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
        lda     $b1
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
        lda     $0023,y
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
        lda     $0024,y
        cmp     #$d1
        beq     @9fac
        cmp     #$d0
        beq     @9fac
        cmp     #$da
        beq     @9fac
@9fa9:  stz     $99
        rts
@9fac:  lda     #$01
        sta     $99
        rts

; ------------------------------------------------------------------------------

; [ menu state $6c:  ]

MenuState_6c:
@9fb1:  lda     $22
        bne     @9fb8
        stz     $26
        rts
@9fb8:  dec     $22
        lda     $08
        bit     #$10
        bne     @9fcc
        lda     $08
        bit     #$20
        bne     @9fcc
        lda     $09
        bit     #$80
        beq     @9fce
@9fcc:  stz     $26
@9fce:  rts

; ------------------------------------------------------------------------------

; [ select relic option (equip, remove) ]

SelectRelicOption:
@9fcf:  clr_a
        lda     $4b
        asl
        tax
        jmp     (.loword(SelectRelicOptionTbl),x)

SelectRelicOptionTbl:
@9fd7:  .addr   SelectRelicOption_00
        .addr   SelectRelicOption_01

; ------------------------------------------------------------------------------

; [ 0: equip ]

SelectRelicOption_00:
@9fdb:  jsr     _c39614
        jsr     DrawEquipTitleEquip
        jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$5a
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ 1: remove ]

SelectRelicOption_01:
@9fec:  jsr     _c39614
        jsr     DrawEquipTitleRemove
        jsr     LoadRelicSlotCursor
        jsr     InitRelicSlotCursor
        lda     #$5c
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ menu state $5a: relic slot select ]

MenuState_5a:
@9ffd:  jsr     _c39e14
        jsr     UpdateRelicSlotCursor
        lda     $08
        bit     #$80
        beq     @a033
        jsr     PlaySelectSfx
        lda     $4e
        sta     $5f
        lda     #$5b
        sta     $26
        jsr     _c3a051
        jsr     SortValidEquip
        jsr     InitEquipListCursor
        lda     #$5a
        sta     $27
        jsr     ClearBG1ScreenA
        jsr     WaitVblank
        jsr     DrawEquipItemList
        jsr     _c39233
        jsr     _c39e23
        jmp     WaitVblank
@a033:  lda     $09
        bit     #$80
        beq     @a047
        jsr     PlayCancelSfx
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        lda     #$59
        sta     $26
        rts
@a047:  jsr     _c39ee6
        lda     #$79
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [  ]

_c3a051:
@a051:  jsr     ClearValidItemList
        jsr     GetCharEquipMask
        lda     #$20
        sta     $29
        ldx     $00
        txy
@a05e:  clr_a
        lda     $1869,y
        cmp     #$ff
        beq     @a088
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp,x
        and     #$07
        cmp     #$05
        bne     @a088
        longa
        lda     f:ItemProp+1,x
        bit     $e7
        beq     @a088
        shorta
        tya
        sta     hWMDATA
        inc     $e0
@a088:  shorta
        iny
        cpy     #$0100
        bne     @a05e
        lda     $e0
        sta     $7e9d89
        rts

; ------------------------------------------------------------------------------

; [ menu state $5b: relic item select ]

MenuState_5b:
@a097:  lda     #$10
        trb     $45
        jsr     _c39e14
        jsr     _c39ad3
        jsr     _c39233
        jsr     _c3a1d8
        lda     $08
        bit     #$80
        beq     @a0dc
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $5f
        tay
        lda     $0023,y
        cmp     #$ff
        beq     @a0c5
        jsr     IncItemQty
@a0c5:  clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        sta     $0023,y
        jsr     DecItemQty
        jsr     _c39131
        bra     @a0e5
@a0dc:  lda     $09
        bit     #$80
        beq     @a109
        jsr     PlayCancelSfx
@a0e5:  lda     #$10
        tsb     $45
        jsr     _c39c87
        longa
        lda     #$0100
        sta     $7e9bd0
        shorta
        lda     #$c1
        trb     $46
        jsr     LoadRelicSlotCursor
        lda     $5f
        sta     $4e
        jsr     InitRelicSlotCursor
        lda     #$5a
        sta     $26
@a109:  rts

; ------------------------------------------------------------------------------

; [ menu state $5c: remove relic ]

MenuState_5c:
@a10a:  jsr     _c39e23
        jsr     UpdateRelicSlotCursor
        lda     $08
        bit     #$80
        beq     @a132
        jsr     PlaySelectSfx
        jsr     GetSelCharPropPtr
        longac
        tya
        shorta
        adc     $4b
        tay
        lda     $0023,y
        jsr     IncItemQty
        lda     #$ff
        sta     $0023,y
        jsr     _c39131
@a132:  lda     $09
        bit     #$80
        beq     @a146
        jsr     PlayCancelSfx
        jsr     LoadRelicOptionCursor
        jsr     InitRelicOptionCursor
        lda     #$59
        sta     $26
        rts
@a146:  jsr     _c39ee6
        lda     #$7a
        sta     $e0
        jmp     CheckShoulderBtns

; ------------------------------------------------------------------------------

; [ sort items by attack/defense power ]

SortValidEquip:
@a150:  ldx     #$ac8d
        stx     hWMADDL
        lda     $7e9d89
        beq     @a186
        cmp     #$01
        beq     @a186
        sta     $e7
        stz     $e8
        clr_axy
@a167:  lda     $7e9d8a,x
        phx
        tay
        lda     $1869,y
        jsr     GetItemPropPtr
        ldx     hMPYL
        lda     f:ItemProp+20,x   ; attack/defense power
        sta     hWMDATA
        plx
        inx
        cpx     $e7
        bne     @a167
        jsr     _c3a187
@a186:  rts

; ------------------------------------------------------------------------------

; [ put item list in order of decreasing attack/defense power ]

_c3a187:
@a187:  dec     $e7
        phb
        lda     #$7e
        pha
        plb
        clr_ay
@a190:  clr_ax
@a192:  lda     $ac8d,x     ; item number
        cmp     $ac8e,x
        bcs     @a1b7
        sta     $e0
        lda     $9d8a,x
        sta     $e1
        lda     $ac8e,x
        sta     $ac8d,x
        lda     $9d8b,x
        sta     $9d8a,x
        lda     $e0
        sta     $ac8e,x
        lda     $e1
        sta     $9d8b,x
@a1b7:  inx                 ;
        cpx     $e7
        bne     @a192
        iny                 ;
        cpy     $e7
        bne     @a190
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

@a1c3:  jsr     GetItemDescPtr
        jsr     GetSelCharPropPtr
        lda     $4b
        bne     @a1d2
        lda     $0023,y
        bra     @a1d5
@a1d2:  lda     $0024,y
@a1d5:  jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; [  ]

_c3a1d8:
@a1d8:  jsr     GetItemDescPtr
        clr_a
        lda     $4b
        tax
        lda     $7e9d8a,x
        tax
        lda     $1869,x
        jmp     LoadItemDesc

; ------------------------------------------------------------------------------

; pointers to party equip screen slot names
@a1ea:  .word   $a21a,$a21f,$a225,$a22b,$a231,$a237,$a23d,$a242
        .word   $a248,$a24e,$a254,$a25a,$a260,$a265,$a26b,$a271
        .word   $a277,$a27d,$a283,$a288,$a28e,$a294,$a29a,$a2a0

; party equip screen slot names (used in Japanese version only)
@a21a:  .byte   $4f,$39,$9f,$2d,$00
@a21f:  .byte   $6b,$39,$63,$3f,$a9,$00
@a225:  .byte   $cf,$39,$8b,$7f,$9d,$00
@a22b:  .byte   $eb,$39,$6b,$a7,$3f,$00
@a231:  .byte   $4f,$3a,$8a,$6e,$54,$00
@a237:  .byte   $6b,$3a,$8a,$6e,$55,$00
@a23d:  .byte   $4f,$3b,$9f,$2d,$00
@a242:  .byte   $6b,$3b,$63,$3f,$a9,$00
@a248:  .byte   $cf,$3b,$8b,$7f,$9d,$00
@a24e:  .byte   $eb,$3b,$6b,$a7,$3f,$00
@a254:  .byte   $4f,$3c,$8a,$6e,$54,$00
@a25a:  .byte   $6b,$3c,$8a,$6e,$55,$00
@a260:  .byte   $4f,$3d,$9f,$2d,$00
@a265:  .byte   $6b,$3d,$63,$3f,$a9,$00
@a26b:  .byte   $cf,$3d,$8b,$7f,$9d,$00
@a271:  .byte   $eb,$3d,$6b,$a7,$3f,$00
@a277:  .byte   $4f,$3e,$8a,$6e,$54,$00
@a27d:  .byte   $6b,$3e,$8a,$6e,$55,$00
@a283:  .byte   $4f,$3f,$9f,$2d,$00
@a288:  .byte   $6b,$3f,$63,$3f,$a9,$00
@a28e:  .byte   $cf,$3f,$8b,$7f,$9d,$00
@a294:  .byte   $eb,$3f,$6b,$a7,$3f,$00
@a29a:  .byte   $4f,$40,$8a,$6e,$54,$00
@a2a0:  .byte   $6b,$40,$8a,$6e,$55,$00

; ------------------------------------------------------------------------------

EquipOptionTextList:
@a2a6:  .addr   EquipOptionEquipText
        .addr   EquipOptionOptimumText
        .addr   EquipOptionRemoveText
        .addr   EquipOptionEmptyText

EquipSlotTextList:
@a2ae:  .addr   EquipHeadText
        .addr   EquipBodyText

RelicOptionTextList:
@a2b2:  .addr   RelicOptionEquipText
        .addr   RelicOptionRemoveText

RelicSlotTextList:
@a2b6:  .addr   EquipRelic1Text
        .addr   EquipRelic2Text

; c3/a2ba: "R-Hand"
EquipRHandText:
@a2ba:  .byte   $0d,$7a,$91,$c4,$a1,$9a,$a7,$9d,$00

; c3/a2c3: "L-Hand"
EquipLHandText:
@a2c3:  .byte   $8d,$7a,$8b,$c4,$a1,$9a,$a7,$9d,$00

; c3/a2cc: "Head"
EquipHeadText:
@a2cc:  .byte   $0d,$7b,$87,$9e,$9a,$9d,$00

; c3/a2d3: "Body"
EquipBodyText:
@a2d3:  .byte   $8d,$7b,$81,$a8,$9d,$b2,$00

; c3/a2da: "Relic"
EquipRelic1Text:
@a2da:  .byte   $0d,$7b,$91,$9e,$a5,$a2,$9c,$00

; c3/a2e2: "Relic"
EquipRelic2Text:
@a2e2:  .byte   $8d,$7b,$91,$9e,$a5,$a2,$9c,$00

; blank text for equip options and title
EquipBlankOptionsText:
@a2ea:  .byte   $0d,$79,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
        .byte   $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00

; c3/a309: "EQUIP"
EquipTitleEquipText:
@a309:  .byte   $39,$79,$84,$90,$94,$88,$8f,$00

; c3/a311: "REMOVE"
EquipTitleRemoveText:
@a311:  .byte   $39,$79,$91,$84,$8c,$8e,$95,$84,$00

; c3/a31a: "EQUIP"
EquipOptionEquipText:
@a31a:  .byte   $0d,$79,$84,$90,$94,$88,$8f,$00

; c3/a322: "OPTIMUM"
EquipOptionOptimumText:
@a322:  .byte   $1b,$79,$8e,$8f,$93,$88,$8c,$94,$8c,$00

; c3/a32c: "RMOVE"
EquipOptionRemoveText:
@a32c:  .byte   $2d,$79,$91,$8c,$8e,$95,$84,$00

; c3/a334: "EMPTY"
EquipOptionEmptyText:
@a334:  .byte   $3b,$79,$84,$8c,$8f,$93,$98,$00

; c3/a33c: "EQUIP"
RelicOptionEquipText:
@a33c:  .byte   $11,$79,$84,$90,$94,$88,$8f,$00

; c3/a344: "REMOVE"
RelicOptionRemoveText:
@a344:  .byte   $1f,$79,$91,$84,$8c,$8e,$95,$84,$00

; ------------------------------------------------------------------------------

EquipStatTextList1:
@a34d:  .addr   EquipStrengthText
        .addr   EquipStaminaText
        .addr   EquipMagPwrText
        .addr   EquipEvadeText
        .addr   EquipMagEvadeText
        .addr   EquipArrow1Text
        .addr   EquipArrow2Text
        .addr   EquipArrow3Text
        .addr   EquipArrow4Text
        .addr   EquipArrow5Text
        .addr   EquipArrow6Text
        .addr   EquipArrow7Text
        .addr   EquipArrow8Text
        .addr   EquipArrow9Text

EquipStatTextList2:
@a369:  .addr   EquipSpeedText
        .addr   EquipAttackPwrText
        .addr   EquipDefenseText
        .addr   EquipMagDefText

; "Vigor"
EquipStrengthText:
@a371:  .byte   $a9,$7c,$95,$a2,$a0,$a8,$ab,$00

; "Stamina"
EquipStaminaText:
@a379:  .byte   $a9,$7d,$92,$ad,$9a,$a6,$a2,$a7,$9a,$00

; "Mag.Pwr"
EquipMagPwrText:
@a383:  .byte   $29,$7e,$8c,$9a,$a0,$c5,$8f,$b0,$ab,$00

; "Evade %"
EquipEvadeText:
@a38d:  .byte   $a9,$7f,$84,$af,$9a,$9d,$9e,$ff,$cd,$00

; MBlock%
EquipMagEvadeText:
@a397:  .byte   $a9,$80,$8c,$81,$a5,$a8,$9c,$a4,$cd,$00

; right arrows
EquipArrow1Text:
@a3a1:  .byte   $bd,$7c,$d5,$00

EquipArrow2Text:
@a3a5:  .byte   $3d,$7d,$d5,$00

EquipArrow3Text:
@a3a9:  .byte   $bd,$7d,$d5,$00

EquipArrow4Text:
@a3ad:  .byte   $3d,$7e,$d5,$00

EquipArrow5Text:
@a3b1:  .byte   $3d,$7f,$d5,$00

EquipArrow6Text:
@a3b5:  .byte   $bd,$7f,$d5,$00

EquipArrow7Text:
@a3b9:  .byte   $bd,$7e,$d5,$00

EquipArrow8Text:
@a3bd:  .byte   $3d,$80,$d5,$00

EquipArrow9Text:
@a3c1:  .byte   $bd,$80,$d5,$00

; "Speed"
EquipSpeedText:
@a3c5:  .byte   $29,$7d,$92,$a9,$9e,$9e,$9d,$00

; "Bat.Pwr"
EquipAttackPwrText:
@a3cd:  .byte   $a9,$7e,$81,$9a,$ad,$c5,$8f,$b0,$ab,$00

; "Defense"
EquipDefenseText:
@a3d7:  .byte   $29,$7f,$83,$9e,$9f,$9e,$a7,$ac,$9e,$00

; "Mag.Def"
EquipMagDefText:
@a3e1:  .byte   $29,$80,$8c,$9a,$a0,$c5,$83,$9e,$9f,$00

; ------------------------------------------------------------------------------

; "Empty"
_c3a3eb:
@a3eb:  .byte   $23,$79,$84,$a6,$a9,$ad,$b2,$00

; "Optimum"
_c3a3f3:
@a3f3:  .byte   $21,$79,$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00

; "Empty"
_c3a3fd:
@a3fd:  .byte   $a3,$79,$84,$a6,$a9,$ad,$b2,$00

; "Optimum"
_c3a405:
@a405:  .byte   $a1,$79,$8e,$a9,$ad,$a2,$a6,$ae,$a6,$00

; "Equipment changed."
_c3a40f:
@a40f:  .byte   $15,$7a,$84,$aa,$ae,$a2,$a9,$a6,$9e,$a7,$ad,$ff,$9c,$a1,$9a,$a7
        .byte   $a0,$9e,$9d,$c5,$00

; ------------------------------------------------------------------------------
