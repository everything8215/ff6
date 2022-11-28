
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: skills.asm                                                           |
; |                                                                            |
; | description: skills menu                                                   |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import BushidoName, MonsterName, GenjuBonusName, GenjuName, DanceName
.import GenjuAttackDesc, GenjuAttackDescPtrs
.import BlitzDesc, BlitzDescPtrs, BushidoDesc, BushidoDescPtrs

; ------------------------------------------------------------------------------

; [ init cursor (skills) ]

LoadSkillsCursor:
@4b50:  ldy     #.loword(SkillsCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (skills) ]

UpdateSkillsCursor:
@4b56:  jsr     MoveCursor

InitSkillsCursor:
@4b59:  ldy     #.loword(SkillsCursorPos)
        jsr     UpdateCursorPos
        clr_a
        lda     $28         ; selected character
        asl
        tax
        lda     $4d
        sta     $0236,x     ; save cursor position
        lda     $4e
        sta     $0237,x
        rts

; ------------------------------------------------------------------------------

; skills cursor data
SkillsCursorProp:
@4b6f:  .byte   $80,$00,$01,$01,$07

; skills cursor positions
SkillsCursorPos:
@4b74:  .byte   $00,$14
        .byte   $00,$24
        .byte   $00,$44
        .byte   $00,$54
        .byte   $00,$64
        .byte   $00,$74
        .byte   $00,$84

; ------------------------------------------------------------------------------

; [ init cursor (magic) ]

LoadMagicCursor:
@4b82:  ldy     #.loword(MagicCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (magic) ]

UpdateMagicCursor:
@4b88:  jsr     MoveListCursor

InitMagicCursor:
@4b8b:  ldy     #.loword(MagicCursorPos)
        jsr     UpdateListCursorPos
        clr_a
        lda     $28         ; character slot
        asl
        tax
        lda     $4f
        sta     $023e,x     ; save cursor position
        lda     $50
        sta     $023f,x
        lda     $28
        tax
        lda     $4a
        sta     $0246,x
        rts

; ------------------------------------------------------------------------------

; magic cursor data
MagicCursorProp:
@4ba9:  .byte   $01,$00,$00,$02,$08

; magic cursor positions
MagicCursorPos:
@4bae:  .byte   $08,$74,$70,$74
        .byte   $08,$80,$70,$80
        .byte   $08,$8c,$70,$8c
        .byte   $08,$98,$70,$98
        .byte   $08,$a4,$70,$a4
        .byte   $08,$b0,$70,$b0
        .byte   $08,$bc,$70,$bc
        .byte   $08,$c8,$70,$c8

; ------------------------------------------------------------------------------

; [ init cursor (blitz/swdtech/dance) ]

LoadAbilityCursor:
@4bce:  ldy     #.loword(AbilityCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (blitz/swdtech/dance) ]

UpdateAbilityCursor:
@4bd4:  jsr     MoveCursor

InitAbilityCursor:
@4bd7:  ldy     #.loword(AbilityCursorPos)
        sty     $e7
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

; blitz/swdtech/dance cursor data
AbilityCursorProp:
@4bdf:  .byte   $00,$00,$00,$02,$04

; blitz/swdtech/dance cursor positions
AbilityCursorPos:
@4be4:  .byte   $08,$74,$78,$74
        .byte   $08,$8c,$78,$8c
        .byte   $08,$a4,$78,$a4
        .byte   $08,$bc,$78,$bc

; ------------------------------------------------------------------------------

; [ init cursor (lore) ]

LoadLoreCursor:
@4bf4:  ldy     #.loword(LoreCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (lore) ]

UpdateLoreCursor:
@4bfa:  jsr     MoveListCursor

InitLoreCursor:
@4bfd:  ldy     #.loword(LoreCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; lore cursor data
LoreCursorProp:
@4c03:  .byte   $01,$00,$00,$01,$08

; lore cursor positions
LoreCursorPos:
@4c08:  .byte   $08,$74
        .byte   $08,$80
        .byte   $08,$8c
        .byte   $08,$98
        .byte   $08,$a4
        .byte   $08,$b0
        .byte   $08,$bc
        .byte   $08,$c8

; ------------------------------------------------------------------------------

; [ init cursor (espers select) ]

LoadGenjuCursor:
@4c18:  ldy     #.loword(GenjuCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (espers select) ]

UpdateGenjuCursor:
@4c1e:  jsr     MoveListCursor

InitGenjuCursor:
@4c21:  ldy     #.loword(GenjuCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; espers select cursor data
GenjuCursorProp:
@4c27:  .byte   $01,$00,$00,$02,$08

; espers select cursor positions
GenjuCursorPos:
@4c2c:  .byte   $08,$74,$78,$74
        .byte   $08,$80,$78,$80
        .byte   $08,$8c,$78,$8c
        .byte   $08,$98,$78,$98
        .byte   $08,$a4,$78,$a4
        .byte   $08,$b0,$78,$b0
        .byte   $08,$bc,$78,$bc
        .byte   $08,$c8,$78,$c8

; ------------------------------------------------------------------------------

; [ init cursor (rage) ]

LoadRiotCursor:
@4c4c:  ldy     #.loword(RiotCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor (rage) ]

UpdateRiotCursor:
@4c52:  jsr     MoveListCursor

InitRiotCursor:
@4c55:  ldy     #.loword(RiotCursorPos)
        jmp     UpdateListCursorPos

; ------------------------------------------------------------------------------

; rage cursor data
RiotCursorProp:
@4c5b:  .byte   $01,$00,$00,$02,$08

; rage cursor positions
RiotCursorPos:
@4c60:  .byte   $18,$74,$88,$74
        .byte   $18,$80,$88,$80
        .byte   $18,$8c,$88,$8c
        .byte   $18,$98,$88,$98
        .byte   $18,$a4,$88,$a4
        .byte   $18,$b0,$88,$b0
        .byte   $18,$bc,$88,$bc
        .byte   $18,$c8,$88,$c8

; ------------------------------------------------------------------------------

; [ init bg (skills) ]

_c34c80:
@4c80:  stz     $9e                     ;
        jsr     DisableDMA2
        lda     #$01
        sta     hBG1SC
        jsr     ClearBG2ScreenA
        jsr     ClearBG2ScreenB
        ldy     #.loword(SkillsMagicWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsCharWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsDescWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsOptionsWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsOptionsWindow1)
        jsr     DrawWindow
        ldy     #.loword(SkillsMagicWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsCharWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsDescWindow2)
        jsr     DrawWindow
        ldy     #.loword(SkillsMPWindow)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     _c34d27
        jsr     TfrBG1ScreenAB
        jsr     ClearBG3ScreenA
        jsr     ClearBG3ScreenB
        jsr     ClearBG3ScreenC
        jsr     _c3a662
        jsr     _c34d3d
        lda     $79
        sta     $29
        ldy     #.loword(SkillsGenjuText)
        jsr     DrawPosText
        lda     $7a
        sta     $29
        ldy     #.loword(SkillsMagicText)
        jsr     DrawPosText
        lda     $7b
        sta     $29
        ldy     #.loword(SkillsBushidoText)
        jsr     DrawPosText
        lda     $7c
        sta     $29
        ldy     #.loword(SkillsBlitzText)
        jsr     DrawPosText
        lda     $7d
        sta     $29
        ldy     #.loword(SkillsLoreText)
        jsr     DrawPosText
        lda     $7e
        sta     $29
        ldy     #.loword(SkillsRiotText)
        jsr     DrawPosText
        lda     $7f
        sta     $29
        ldy     #.loword(SkillsDanceText)
        jsr     DrawPosText
        jmp     TfrBG3ScreenAB

; ------------------------------------------------------------------------------

; [  ]

_c34d27:
@4d27:  jsr     ClearBG1ScreenA
        jsr     ClearBG1ScreenB
        lda     #$24
        sta     $29
        ldx     #.loword(SkillsCharLabelTextList)
        ldy     #$0006
        jsr     DrawPosList
        jmp     _c34ee5

; ------------------------------------------------------------------------------

; [ update skills text colors ]

_c34d3d:
@4d3d:  lda     #$24        ; init all skills to gray (disabled)
        ldx     $00
@4d41:  sta     $79,x
        inx
        cpx     #$0007
        bne     @4d41
        jsr     _c34edd
        phy
        ldx     #$0004
@4d50:  phx
        ldx     $00
@4d53:  lda     $0016,y     ; battle command
        cmp     f:_c34d78,x
        bne     @4d60
        lda     #$20
        sta     $79,x
@4d60:  inx
        cpx     #$0007
        bne     @4d53
        iny
        plx
        dex
        bne     @4d50
        ply
        lda     $0000,y     ; espers always disabled for character $0c (gogo)
        cmp     #$0c
        bne     @4d77
        lda     #$24
        sta     $79
@4d77:  rts

; ------------------------------------------------------------------------------

; battle commands for enabling skills (esper, magic, swdtech, blitz, lore, rage, dance)
_c34d78:
@4d78:  .byte   $02,$02,$07,$0a,$0c,$10,$13

; ------------------------------------------------------------------------------

; [  ]

_c34d7f:
@4d7f:  jsr     ClearBG1ScreenA
        jsr     _c34f1c
        jsr     DrawMagicList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsMPCostText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; window data for skills menu
; c3/4d98: bg2_0( 1, 1) [ 7x 4]
; c3/4d9c: bg2_0( 1, 7) [ 7x10]
; c3/4da0: bg2_0( 1, 6) [28x 5]
; c3/4da4: bg2_0( 1,13) [28x12]
; c3/4da8: bg2_0( 1, 1) [28x 3]
; c3/4dac: bg2_1( 1, 6) [28x 5]
; c3/4db0: bg2_1( 1,13) [28x12]
; c3/4db4: bg2_1(22, 4) [ 7x 1]
; c3/4db8: bg2_1( 1, 1) [28x 3]

; espers/magic window
SkillsOptionsWindow1:
@4d98:  .word   $588b
        .byte   $07,$04

; character skills list window
SkillsOptionsWindow2:
@4d9c:  .word   $5a0b
        .byte   $07,$0a

; character info window
SkillsCharWindow1:
@4da0:  .word   $59cb
        .byte   $1c,$05

; spell list window
SkillsMagicWindow1:
@4da4:  .word   $5b8b
        .byte   $1c,$0c

; description window
SkillsDescWindow1:
@4da8:  .word   $588b
        .byte   $1c,$03

; character window, top right screen
SkillsCharWindow2:
@4dac:  .word   $61cb
        .byte   $1c,$05

; spell list window, top right screen
SkillsMagicWindow2:
@4db0:  .word   $638b
        .byte   $1c,$0c

; mp cost window, top right screen
SkillsMPWindow:
@4db4:  .word   $6175
        .byte   $07,$01

; description window, top right screen
SkillsDescWindow2:
@4db8:  .word   $608b
        .byte   $1c,$03

; ------------------------------------------------------------------------------

; [ init bg scrolling hdma (skills) ]

InitSkillsBGScrollHDMA:
@4dbc:  lda     #$02        ; hdma #5 - one address, write twice, absolue addressing
        sta     $4350
        lda     #$12        ; destination = $2112 (bg3 vertical scroll)
        sta     $4351
        ldy     #.loword(SkillsBG3VScrollHDMATbl)
        sty     $4352
        lda     #^SkillsBG3VScrollHDMATbl
        sta     $4354
        lda     #^SkillsBG3VScrollHDMATbl
        sta     $4357
        lda     #$20        ; enable hdma channel #5
        tsb     $43
        jsr     LoadSkillsBG1VScrollHDMATbl
        ldx     $00
@4ddf:  lda     f:SkillsBG1HScrollHDMATbl,x   ; load bg1 horizontal scroll hdma table
        sta     $7e9a09,x
        inx
        cpx     #$000d
        bne     @4ddf
        lda     #$02        ; hdma #6 - one address, write twice, absolue addressing
        sta     $4360
        lda     #$0d        ; destination = $210d (bg1 horizontal scroll)
        sta     $4361
        ldy     #$9a09      ; source = $7e9a09
        sty     $4362
        lda     #$7e
        sta     $4364
        lda     #$7e
        sta     $4367
        lda     #$02        ; hdma #6 - one address, write twice, absolue addressing
        sta     $4370
        lda     #$0e        ; destination = $210e (bg1 vertical scroll)
        sta     $4371
        ldy     #$9849      ; source = $7e9849
        sty     $4372
        lda     #$7e
        sta     $4374
        lda     #$7e
        sta     $4377
        lda     #$c0        ; enable hdma channel #6 and #7
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll hdma table (skills)
SkillsBG3VScrollHDMATbl:
@4e26:  .byte   $4f
        .word   $0002
        .byte   $40
        .word   $0002
        .byte   $00

; ------------------------------------------------------------------------------

; [ load bg1 vertical scroll hdma table (skills) ]

LoadSkillsBG1VScrollHDMATbl:
@4e2d:  ldx     $00
@4e2f:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$0012
        bne     @4e2f
@4e3d:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        clr_a
        lda     $49         ; vertical scroll position
        asl4
        and     #$ff
        longa
        clc
        adc     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        shorta
        inx2
        cpx     #$005a
        bne     @4e3d
@4e63:  lda     f:SkillsBG1VScrollHDMATbl,x
        sta     $7e9849,x
        inx
        cpx     #$005e
        bne     @4e63
        rts

; ------------------------------------------------------------------------------

; bg1 horizontal scroll hdma table (skills)
SkillsBG1HScrollHDMATbl:
@4e72:  .byte   $27
        .word   $0100
        .byte   $48
        .word   $0100
        .byte   $60
        .word   $0000
        .byte   $1e
        .word   $0100
        .byte   $00

; bg1 vertical scroll hdma table (skills)
SkillsBG1VScrollHDMATbl:
@4e7f:  .byte   $3f
        .word   $0000
        .byte   $0c
        .word   $0004
        .byte   $0c
        .word   $0008
        .byte   $0a
        .word   $000c
        .byte   $01
        .word   $000c
        .byte   $0d
        .word   $0008
        .byte   $04
        .word   $ff94
        .byte   $04
        .word   $ff94
        .byte   $04
        .word   $ff94
        .byte   $04
        .word   $ff98
        .byte   $04
        .word   $ff98
        .byte   $04
        .word   $ff98
        .byte   $04
        .word   $ff9c
        .byte   $04
        .word   $ff9c
        .byte   $04
        .word   $ff9c
        .byte   $04
        .word   $ffa0
        .byte   $04
        .word   $ffa0
        .byte   $04
        .word   $ffa0
        .byte   $04
        .word   $ffa4
        .byte   $04
        .word   $ffa4
        .byte   $04
        .word   $ffa4
        .byte   $04
        .word   $ffa8
        .byte   $04
        .word   $ffa8
        .byte   $04
        .word   $ffa8
        .byte   $04
        .word   $ffac
        .byte   $04
        .word   $ffac
        .byte   $04
        .word   $ffac
        .byte   $04
        .word   $ffb0
        .byte   $04
        .word   $ffb0
        .byte   $04
        .word   $ffb0
        .byte   $1e
        .word   $ff20
        .byte   $00

; ------------------------------------------------------------------------------

; [  ]

_c34edd:
@4edd:  clr_a
        lda     $28
        asl
        tax
        ldy     $6d,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34ee5:
@4ee5:  jsr     _c34edd
        sty     $67
        jmp     @4eed

; ???
@4eed:  ldy     #$42dd
        ldx     #$4f50
        jsr     DrawStatusIcons
        ldy     #.loword(SkillsCharHPSlashText)
        jsr     DrawPosText
        ldy     #.loword(SkillsCharMPSlashText)
        jsr     DrawPosText
        ldx     #.loword(_c34f12)
        jsr     DrawCharBlock

_c34f08:
@4f08:  lda     #$20
        sta     $29
        ldy     #$421d
        jmp     DrawEquipGenju

; ------------------------------------------------------------------------------

; ram addresses for lv/hp/mp text (skills)
_c34f12:
@4f12:  .word   $4237,$42b3,$42bd,$4333,$433d

; ------------------------------------------------------------------------------

; [  ]

_c34f1c:
@4f1c:  ldx     #$9d89
        stx     hWMADDL
        ldx     #$0036
        lda     #$ff
@4f27:  sta     hWMDATA
        dex
        bne     @4f27
        clr_ay
        lda     $1d54
        and     #$07
        asl2
        tax
@4f37:  phx
        lda     f:_c34f49,x
        cmp     #$ff
        beq     @4f47
        jsr     _c34f61
        plx
        inx
        bra     @4f37
@4f47:  plx
        rts

; ------------------------------------------------------------------------------

_c34f49:
@4f49:  .byte   $2d,$00,$18,$ff
        .byte   $2d,$18,$00,$ff
        .byte   $00,$18,$2d,$ff
        .byte   $00,$2d,$18,$ff
        .byte   $18,$2d,$00,$ff
        .byte   $18,$00,$2d,$ff

; ------------------------------------------------------------------------------

; [  ]

_c34f61:
@4f61:  cmp     #$00
        beq     @4f6e
        cmp     #$2d
        beq     @4f73
        ldx     #$0015
        bra     @4f78
@4f6e:  ldx     #$0018
        bra     @4f78
@4f73:  ldx     #$0009
        bra     @4f78
@4f78:  stx     $e0
        tax
@4f7b:  tyx
        sta     $7e9d89,x
        inc
        iny
        dec     $e0
        bne     @4f7b
        rts

; ------------------------------------------------------------------------------

; [ draw entire magic list ]

DrawMagicList:
@4f87:  jsr     GetListTextPos
        ldy     #8
@4f8d:  phy
        jsr     DrawMagicListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @4f8d
        rts

; ------------------------------------------------------------------------------

; [ draw one row of magic list ]

DrawMagicListRow:
@4f9e:  jsr     GetMagicNamePtr
        ldx     #$0003
        jsr     _c34fc4
        inc     $e5
        jsr     GetMagicNamePtr
        ldx     #$0010
        jsr     _c34fc4
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to magic spell name ]

GetMagicNamePtr:
@4fb5:  ldy     #7
        sty     $eb
        ldy     #.loword(MagicName)
        sty     $ef
        lda     #^MagicName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c34fc4:
@4fc4:  lda     $e6
        inc
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        lda     $9e
        beq     @503e
        jsr     _c350ec
        jsr     _c3514d
        jsr     _c350ec
        cmp     #$ff
        beq     @501a
        jsr     _c350a2
        cmp     #$ff
        bne     @501a
        jsr     _c350ec
        jsr     LoadArrayItem
        ldx     #$9e92
        stx     hWMADDL
        lda     #$ff
        sta     hWMDATA
        jsr     _c350ec
        jsr     _c3510d
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        lda     #$ff
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
@501a:  clr_a
        lda     $e5
        tax
        lda     #$ff
        sta     $7e9d89,x
        jsr     _c351b9
        ldy     #$000b
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5032:  sta     hWMDATA
        dey
        bne     @5032
        stz     hWMDATA
        jmp     DrawPosTextBuf
@503e:  jsr     _c350ec
        cmp     #$ff
        beq     @501a
        jsr     _c350a2
        cmp     #$00
        beq     @501a
        jsr     _c350ec
        jsr     LoadArrayItem
        ldx     #$9e92
        stx     hWMADDL
        jsr     _c350ec
        jsr     _c350a2
        cmp     #$ff
        beq     @5088
        pha
        jsr     _c351b9
        lda     #$2c
        sta     $29
        lda     #$c7
        sta     hWMDATA
        pla
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        lda     #$cd
        sta     hWMDATA
@5082:  stz     hWMDATA
        jmp     DrawPosTextBuf
@5088:  lda     #$24
        sta     $29
        jsr     _c350ec
        jsr     _c3514d
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        bra     @5082

; ------------------------------------------------------------------------------

; [  ]

_c350a2:
@50a2:  sta     $e0
        jsr     _c34edd
        lda     $0000,y
        cmp     #$0c
        beq     _50c5

_c350ae:
@50ae:  sta     hWRMPYA
        lda     #$36
        sta     hWRMPYB
        clr_a
        lda     $e0
        longa
        adc     hRDMPYL
        tax
        shorta
        lda     $1a6e,x
        rts

_50c5:  stz     $e1
@50c7:  clr_a
        lda     $e1
        cmp     $28
        beq     @50e2
        asl
        tax
        ldy     $6d,x
        beq     @50e2
        lda     $0000,y
        cmp     #$0c
        bcs     @50e2
        jsr     _c350ae
        cmp     #$ff
        beq     @50eb
@50e2:  inc     $e1
        lda     $e1
        cmp     #$04
        bne     @50c7
        clr_a
@50eb:  rts

; ------------------------------------------------------------------------------

; [  ]

_c350ec:
@50ec:  clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c350f5:
@50f5:  pha
@50f6:  lda     hHVBJOY                 ; wait for hblank
        and     #$40
        beq     @50f6
        pla
        sta     hM7A
        stz     hM7A
        lda     #14
        sta     hM7B
        sta     hM7B
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3510d:
@510d:  pha
        jsr     _c350f5
        ldx     hMPYL
        lda     f:MagicProp+5,x   ; spell data
        sta     $e0
        pla
        cmp     #$99
        bne     @512e
        lda     $021b
        asl
        sta     $e0
        lda     $021c
        cmp     #$1e
        bcc     @512e
        inc     $e0
@512e:  lda     $11d7
        bit     #$40
        beq     @513a
        clr_a
        lda     #$01
        bra     @514b
@513a:  lda     $11d7
        bit     #$20
        beq     @5148
        clr_a
        lda     $e0
        inc
        lsr
        bra     @514b
@5148:  clr_a
        lda     $e0
@514b:  tax
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3514d:
@514d:  cmp     #$2a
        beq     @517b
        cmp     #$12
        beq     @516e
@5155:  jsr     _c350f5
        ldx     hMPYL
        lda     f:MagicProp+3,x
        and     #$01
        beq     @516c
        jsr     _c350ec
        jsr     _c3510d
        jmp     @5188
@516c:  bra     _51b9
@516e:  sta     $e3
        lda     $0201
        bit     #$01
        beq     @516c
        lda     $e3
        bra     @5155
@517b:  sta     $e3
        lda     $0201
        bit     #$02
        beq     @516c
        lda     $e3
        bra     @5155
@5188:  stx     $e2
        jsr     _c34edd
        lda     $0014,y
        and     #$20
        beq     @519b
        jsr     _c350ec
        cmp     #$23
        bne     _51b9
@519b:  longa
        lda     $000d,y
        sta     $e0
        shorta
        ldx     $e2
        cpx     $e0
        beq     @51ac
        bcs     _51b9
@51ac:  clr_a
        lda     $e5
        tax
        lda     #$20
        sta     $29
        sta     $7e9e09,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c351b9:
_51b9:  clr_a
        lda     $e5
        tax
        lda     #$28
        sta     $29
        sta     $7e9e09,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c351c6:
@51c6:  lda     #$20
        sta     $29
        longa
        lda     #$81bf
        sta     $7e9e89
        shorta
        ldx     #$9e8b
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        jsr     _c3510d
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c351f9:
@51f9:  jsr     ClearBG1ScreenA
        jsr     DrawLoreList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsLoreTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [  ]

_c3520f:
@520f:  ldx     #$9d89
        stx     hWMADDL
        ldx     $00
        stz     $e0
@5219:  ldy     #8
        lda     $1d29,x     ; known lores
@521f:  ror
        pha
        bcc     @522a
        lda     $e0
        sta     hWMDATA
        bra     @522f
@522a:  lda     #$ff
        sta     hWMDATA
@522f:  inc     $e0
        pla
        dey
        bne     @521f
        inx
        cpx     #$0003
        bne     @5219
        rts

; ------------------------------------------------------------------------------

; [ draw entire lore list ]

DrawLoreList:
@523c:  jsr     _c3520f
        jsr     GetListTextPos
        ldy     #8
@5245:  phy
        jsr     DrawLoreListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @5245
        rts

; ------------------------------------------------------------------------------

; [ draw one row of lore list ]

DrawLoreListRow:
@5256:  lda     #$20
        sta     $29
        jsr     _c35266
        ldx     #$0003
        jsr     _c35275
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35266:
@5266:  ldy     #$000a
        sty     $eb
        ldy     #$f9fd      ; $e6f9fd (lore names)
        sty     $ef
        lda     #$e6
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35275:
@5275:  lda     $e6
        inc
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @52c0
        lda     $e5
        jsr     LoadArrayItem
        ldx     #$9e95
        stx     hWMADDL
        lda     #$c7
        sta     hWMDATA
        lda     $e5
        clc
        adc     #$8b
        jsr     _c3510d
        jsr     HexToDec3
        lda     $f7
        sta     hWMDATA
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
@52c0:  ldy     #$000e
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@52cb:  sta     hWMDATA
        dey
        bne     @52cb
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c352d7:
@52d7:  jsr     ClearBG1ScreenA
        jsr     _c3536e
        lda     #$20
        sta     $29
        jsr     _c352f4
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsBushidoTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [  ]

_c352f4:
@52f4:  jsr     GetListTextPos
        inc     $e6
        stz     $e5
        ldy     #$0004
@52fe:  phy
        jsr     _c35311
        lda     $e6
        inc4
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @52fe
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35311:
@5311:  jsr     _c35328
        ldx     #$0003
        jsr     _c35337
        inc     $e5
        jsr     _c35328
        ldx     #$0011
        jsr     _c35337
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35328:
@5328:  ldy     #12
        sty     $eb
        ldy     #.loword(BushidoName)
        sty     $ef
        lda     #^BushidoName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35337:
@5337:  lda     $e6
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @5357
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@5357:  ldy     #$000c
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5362:  sta     hWMDATA
        dey
        bne     @5362
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c3536e:
@536e:  ldx     #$9d89
        stx     hWMADDL
        ldy     #$0008
        stz     $e0
        clr_a
        lda     $1cf7
@537d:  ror
        pha
        bcc     @5385
        lda     $e0
        bra     @5387
@5385:  lda     #$ff
@5387:  sta     hWMDATA
        inc     $e0
        pla
        dey
        bne     @537d
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35391:
@5391:  jsr     ClearBG1ScreenA
        jsr     DrawRiotList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsRiotTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw entire rage list ]

DrawRiotList:
@53a7:  jsr     GetRiotList
        jsr     GetListTextPos
        ldy     #9
@53b0:  phy
        jsr     GetRiotListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @53b0
        rts

; ------------------------------------------------------------------------------

; [  ]

GetRiotList:
@53c1:  ldx     #$9d89
        stx     hWMADDL
        ldx     $00
        stz     $e0
@53cb:  ldy     #$0008
        lda     $1d2c,x     ; known rages
@53d1:  ror
        pha
        bcc     @53dc
        lda     $e0
        sta     hWMDATA
        bra     @53e1
@53dc:  lda     #$ff
        sta     hWMDATA
@53e1:  inc     $e0
        pla
        dey
        bne     @53d1
        inx
        cpx     #$0020
        bne     @53cb
        rts

; ------------------------------------------------------------------------------

; [ draw one row of rage list ]

GetRiotListRow:
@53ee:  lda     #$20
        sta     $29
        jsr     GetMonsterNamePtr
        ldx     #$0005
        jsr     DrawRiotName
        inc     $e5
        jsr     GetMonsterNamePtr
        ldx     #$0013
        jsr     DrawRiotName
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to monster name ]

GetMonsterNamePtr:
@5409:  ldy     #10
        sty     $eb
        ldy     #.loword(MonsterName)
        sty     $ef
        lda     #^MonsterName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [ draw monster name for rage list ]

DrawRiotName:
@5418:  lda     $e6
        inc
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @543b
        lda     $e5
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@543b:  ldy     #10
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5446:  sta     hWMDATA
        dey
        bne     @5446
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw esper selection menu ]

DrawGenjuMenu:
@5452:  jsr     ClearBG1ScreenA
        lda     #$20
        sta     $29
        jsr     DrawGenjuList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsGenjuTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw entire esper list ]

DrawGenjuList:
@546c:  jsr     GetGenjuList
        jsr     GetListTextPos
        ldy     #8
@5475:  phy
        jsr     DrawGenjuListRow
        lda     $e6
        inc2
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @5475
        rts

; ------------------------------------------------------------------------------

; [  ]

GetGenjuList:
@5486:  ldx     #$9ded
        stx     hWMADDL
        ldx     $00
        stz     $e0
@5490:  ldy     #8
        lda     $1a69,x     ; current espers
@5496:  ror
        pha
        bcc     @54a1
        lda     $e0
        sta     hWMDATA
        bra     @54a6
@54a1:  lda     #$ff
        sta     hWMDATA
@54a6:  inc     $e0
        pla
        dey
        bne     @5496
        inx
        cpx     #$0004
        bne     @5490
        ldx     #$9d89
        stx     hWMADDL
        lda     #$ff
        ldx     #$001d
@54bd:  sta     hWMDATA
        dex
        bne     @54bd
        ldx     #$9ded
        stx     hWMADDL
        ldy     #$001b
        clr_a
@54cd:  lda     hWMDATA
        bmi     @54df
        pha
        tax
        lda     $d1f9b5,x   ; esper order for menu
        dec
        tax
        pla
        sta     $7e9d89,x
@54df:  dey
        bne     @54cd
        rts

; ------------------------------------------------------------------------------

; [ draw one row of esper list ]

DrawGenjuListRow:
@54e3:  jsr     _c354fa
        ldx     #$0003
        jsr     _c35509
        inc     $e5
        jsr     _c354fa
        ldx     #$0011
        jsr     _c35509
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [  ]

_c354fa:
@54fa:  ldy     #8
        sty     $eb
        ldy     #.loword(GenjuName)
        sty     $ef
        lda     #^GenjuName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35509:
@5509:  lda     $e6
        inc
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @555d
        jsr     _c35574
        jsr     LoadArrayItem
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        clc
        adc     #$36
        jsr     _c3510d
        pha
        ldx     #$9e93
        stx     hWMADDL
        lda     #$c7
        sta     hWMDATA
        pla
        jsr     HexToDec3
        lda     $f7
        sta     hWMDATA
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf
@555d:  ldy     #$000c
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5568:  sta     hWMDATA
        dey
        bne     @5568
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35574:
@5574:  sta     $e0
        ldx     $00
        ldy     #$0010
@557b:  lda     $161e,x     ; esper
        cmp     $e0
        beq     @5593
        longa
        txa
        clc
        adc     #$0025
        tax
        shorta
        dey
        bne     @557b
        lda     #$20
        bra     @5595
@5593:  lda     #$28
@5595:  sta     $29
        lda     $e0
        rts

; ------------------------------------------------------------------------------

; [ show error message if esper is already equipped ]

_c3559a:
@559a:  lda     #$20
        sta     $29
        longa
        lda     #$40cd                  ; position
        sta     $7e9e89
        lda     #$9e8b
        sta     hWMADDL
        shorta
        ldy     #6
@55b2:  lda     $1602,x                 ; load character name
        cmp     #$ff
        beq     @55c0
        sta     hWMDATA
        inx
        dey
        bne     @55b2
@55c0:  ldx     $00
@55c2:  lda     f:GenjuEquipErrorMsgText,x
        beq     @55ce
        sta     hWMDATA
        inx
        bra     @55c2
@55ce:  stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ draw blitz menu ]

DrawBlitzMenu:
@55d4:  jsr     ClearBG1ScreenA
        jsr     DrawBlitzList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsBlitzTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw entire list of blitz inputs ]

DrawBlitzList:
@55ea:  jsr     GetBlitzList
        jsr     GetListTextPos
        stz     $e5
        inc     $e6
        ldy     #4
@55f7:  phy
        jsr     DrawBlitzListRow
        lda     $e6
        inc4
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @55f7
        rts

; ------------------------------------------------------------------------------

; [ draw one row of blitz inputs ]

DrawBlitzListRow:
@560a:  ldx     #$0004
        jsr     DrawBlitzInput
        inc     $e5
        ldx     #$0012
        jsr     DrawBlitzInput
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get list of known blitzes or dances ]

GetBlitzList:
@561b:  lda     $1d28
        bra     _5623

GetDanceList:
@5620:  lda     $1d4c
_5623:  ldx     #$9d89
        stx     hWMADDL
        ldx     $00
        ldy     #8
@562e:  ror
        pha
        bcc     @5638
        txa
        sta     hWMDATA
        bra     @563d
@5638:  lda     #$ff
        sta     hWMDATA
@563d:  inx
        pla
        dey
        bne     @562e
        rts

; ------------------------------------------------------------------------------

; [ draw blitz button input code ]

DrawBlitzInput:
@5643:  lda     $e6
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @566c
        jsr     GetBlitzInputTiles
        ldy     #$9e89
        sty     $e7
        lda     #$7e
        sta     $e9
        jmp     _c356bc
@566c:  ldy     #$0008
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5677:  sta     hWMDATA
        dey
        bne     @5677
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [ get tiles for blitz button input code ]

GetBlitzInputTiles:
@5683:  pha
        asl3
        sta     $e0
        pla
        asl2
        clc
        adc     $e0
        tax
        ldy     #$9e8b
        sty     hWMADDL
        ldy     #10
@5699:  phx
        lda     f:BlitzCode,x
        asl
        tax
        lda     f:BlitzInputTileTbl,x
        sta     hWMDATA
        inx
        lda     f:BlitzInputTileTbl,x
        sta     hWMDATA
        inx
        plx
        inx
        dey
        bne     @5699
        stz     hWMDATA
        stz     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [  ]

_c356bc:
@56bc:  ldy     $00
        longa
        lda     [$e7]
        sta     $eb
        inc     $e7
        inc     $e7
        shorta
        lda     #$7e
        sta     $ed
@56ce:  longa
        lda     [$e7],y
        beq     @56dc
        sta     [$eb],y
        shorta
        iny2
        bra     @56ce
@56dc:  shorta
        rts

; ------------------------------------------------------------------------------

; [ load esper attack description ]

LoadGenjuAttackDesc:
@56df:  jsr     GetLoadGenjuAttackDescPtr
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load magic description ]

LoadMagicDesc:
@56e5:  jsr     GetMagicDescPtr
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load lore description ]

LoadLoreDesc:
@56eb:  ldx     #.loword(LoreDescPtrs)
        stx     $e7
        ldx     #.loword(LoreDesc)
        stx     $eb
        lda     #^LoreDescPtrs
        sta     $e9
        lda     #^LoreDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load swdtech description ]

LoadBushidoDesc:
@5700:  ldx     #.loword(BushidoDescPtrs)
        stx     $e7
        ldx     #.loword(BushidoDesc)
        stx     $eb
        lda     #^BushidoDescPtrs
        sta     $e9
        lda     #^BushidoDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load blitz description ]

LoadBlitzDesc:
@5715:  ldx     #.loword(BlitzDescPtrs)
        stx     $e7
        ldx     #.loword(BlitzDesc)
        stx     $eb
        lda     #^BlitzDescPtrs
        sta     $e9
        lda     #^BlitzDesc
        sta     $ed
        jmp     LoadBigText

; ------------------------------------------------------------------------------

; [ load description text ]

LoadBigText:
@572a:  ldx     #$9ec9
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x

LoadItemDesc:
@5738:  cmp     #$ff
        beq     @576d
        longa
        asl
        tay
        lda     [$e7],y
        tay
        shorta
@5745:  lda     [$eb],y
        beq     @574f
        sta     hWMDATA
        iny
        bra     @5745
@574f:  dey
        lda     [$eb],y
        iny
        cmp     #$1c
        beq     @5767
        cmp     #$1d
        beq     @5767
        cmp     #$1e
        beq     @5767
        cmp     #$1f
        beq     @5767
@5763:  stz     hWMDATA
        rts
@5767:  stz     hWMDATA
        iny
        bra     @5745
@576d:  lda     #$ff
        sta     hWMDATA
        bra     @5763

; ------------------------------------------------------------------------------

; [ draw dance menu ]

DrawDanceMenu:
@5774:  jsr     ClearBG1ScreenA
        jsr     DrawDanceList
        lda     #$2c
        sta     $29
        ldy     #.loword(SkillsDanceTitleText)
        jsr     DrawPosText
        jsr     CreateSubPortraitTask
        jmp     InitDMA1BG3ScreenB

; ------------------------------------------------------------------------------

; [ draw dance list text ]

DrawDanceList:
@578a:  jsr     GetDanceList
        jsr     GetListTextPos
        inc     $e6
        stz     $e5
        ldy     #4
@5797:  phy
        jsr     DrawDanceListRow
        lda     $e6
        inc4
        and     #$1f
        sta     $e6
        ply
        dey
        bne     @5797
        rts

; ------------------------------------------------------------------------------

; [ draw one row of dance list (2 dance names) ]

DrawDanceListRow:
@57aa:  jsr     GetDanceNamePtr
        ldx     #$0003
        jsr     DrawDanceName
        inc     $e5
        jsr     GetDanceNamePtr
        ldx     #$0011
        jsr     DrawDanceName
        inc     $e5
        rts

; ------------------------------------------------------------------------------

; [ get pointer to dance name ]

GetDanceNamePtr:
@57c1:  ldy     #12
        sty     $eb
        ldy     #.loword(DanceName)
        sty     $ef
        lda     #^DanceName
        sta     $f1
        rts

; ------------------------------------------------------------------------------

; [ draw dance name ]

DrawDanceName:
@57d0:  lda     $e6
        jsr     GetBG1TilemapPtr
        longa
        txa
        sta     $7e9e89
        shorta
        clr_a
        lda     $e5
        tax
        lda     $7e9d89,x
        cmp     #$ff
        beq     @57f0
        jsr     LoadArrayItem
        jmp     DrawPosTextBuf
@57f0:  ldy     #$000c
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@57fb:  sta     hWMDATA
        dey
        bne     @57fb
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35807:
@5807:  clr_a
        lda     $60
        tax
        lda     #$ff
        sta     $7e35c9,x
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35812:
@5812:  jsr     ClearBG2ScreenA
        ldy     #.loword(_c3583f)
        jsr     DrawWindow
        ldy     #.loword(_c35843)
        jsr     DrawWindow
        ldy     #.loword(_c35847)
        jsr     DrawWindow
        jsr     TfrBG2ScreenAB
        jsr     ClearBG1ScreenB
        ldy     #$ffc0
        sty     $35
        lda     #$02
        tsb     $45
        jsr     _c3318a
        jsr     _c3584b
        jmp     _c3319f

; ------------------------------------------------------------------------------

_c3583f:
@583f:  .byte   $9d,$58,$13,$18

_c35843:
@5843:  .byte   $8b,$58,$07,$02

_c35847:
@5847:  .byte   $8b,$59,$07,$03

; ------------------------------------------------------------------------------

; [  ]

_c3584b:
@584b:  lda     #$20
        sta     $29
        ldy     #.loword(_c35889)
        jsr     DrawPosText
        ldy     #.loword(_c3588e)
        jsr     DrawPosText
        clr_a
        lda     $4b
        sta     $e5
        jsr     GetMagicNamePtr
        longa
        lda     #$790d
        sta     $7e9e89
        shorta
        jsr     _c350ec
        jsr     LoadArrayItem
        jsr     DrawPosTextBuf
        jsr     _c350ec
        jsr     _c3510d
        jsr     HexToDec3
        ldx     #$7a0f
        jsr     DrawNum2
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

_c35889:
@5889:  .byte   $15,$7a,$8c,$8f,$00

_c3588e:
@588e:  .byte   $4d,$7a,$8d,$9e,$9e,$9d,$9e,$9d,$00

; ------------------------------------------------------------------------------

; [ init esper detail menu ]

InitEsperDetailMenu:
@5897:  ldy     $4f
        sty     $8e
        lda     $4a
        sta     $90
        jsr     LoadGenjuProp
        jsr     DrawEsperDetailMenu
        jsr     InitDMA1BG1ScreenB
        jsr     WaitVblank
        jsr     InitDMA1BG1ScreenA
        longa
        lda     #$0100
        sta     $7e9a10
        shorta
        lda     $49
        sta     $5f
        lda     #$07
        sta     $49
        jsr     LoadSkillsBG1VScrollHDMATbl
        lda     #$c0
        trb     $46
        jsr     LoadGenjuDetailCursor
        jmp     InitGenjuDetailCursor

; ------------------------------------------------------------------------------

; [ menu state $4d: esper detail ]

MenuState_4d:
@58ce:  jsr     UpdateGenjuDetailCursor
        jsr     _c35b93

; A button
        lda     $08
        bit     #$80
        beq     @590a
        clr_a
        lda     $4b
        bne     @590a
        lda     $99
        jsr     _c35574
        sta     $e0
        lda     $29
        cmp     #$28
        bne     @5902
        jsr     PlayInvalidSfx
        lda     #$10
        tsb     $45
        jsr     _c3559a
        ldy     #$0020
        sty     $20
        lda     #$34
        sta     $26
        jmp     InitDMA1BG1ScreenB

; equip esper
@5902:  jsr     PlaySelectSfx
        jsr     _c32929
        bra     _c35913

; B button
@590a:  lda     $09
        bit     #$80
        beq     _597c
        jsr     PlayCancelSfx

_c35913:
@5913:  lda     #$10
        tsb     $45
        lda     $5f
        sta     $49
        jsr     DrawGenjuList
        jsr     CreateScrollArrowTask1
        longa
        lda     #$1000
        sta     $7e354a,x
        lda     #$0060
        sta     $7e34ca,x
        shorta
        jsr     LoadGenjuCursor
        lda     $8e
        sta     $4d
        ldy     $8e
        sty     $4f
        lda     $90
        sta     $4a
        lda     $4a
        sta     $e0
        lda     $50
        sec
        sbc     $e0
        sta     $4e
        jsr     InitGenjuCursor
        lda     #$06
        sta     $5c
        lda     #$08
        sta     $5a
        lda     #$02
        sta     $5b
        jsr     InitDMA1BG1ScreenA
        jsr     WaitVblank
        longa
        clr_a
        sta     $7e9a10
        shorta
        ldy     #$0100
        sty     $39
        sty     $3d
        jsr     LoadSkillsBG1VScrollHDMATbl
        jsr     InitDMA1BG1ScreenB
        lda     #$1e
        sta     $26
_597c:  rts

; ------------------------------------------------------------------------------

; [ load cursor for esper details ]

LoadGenjuDetailCursor:
@597d:  ldy     #.loword(GenjuDetailCursorProp)
        jmp     LoadCursor

; ------------------------------------------------------------------------------

; [ update cursor positions for esper details ]

UpdateGenjuDetailCursor:
@5983:  jsr     MoveCursor

InitGenjuDetailCursor:
@5986:  ldy     #.loword(GenjuDetailCursorPos)
        jmp     UpdateCursorPos

; ------------------------------------------------------------------------------

GenjuDetailCursorProp:
@598c:  .byte   $80,$00,$00,$01,$07

GenjuDetailCursorPos:
@5991:  .byte   $10,$70
        .byte   $18,$7c
        .byte   $18,$88
        .byte   $18,$94
        .byte   $18,$a0
        .byte   $18,$ac
        .byte   $18,$b8

; ------------------------------------------------------------------------------

; [ draw esper detail menu ]

DrawEsperDetailMenu:
@599f:  lda     #$20
        sta     $29
        ldy     #.loword(GenjuLearnRateText)
        jsr     DrawPosText
        ldy     #.loword(GenjuLearnPctText)
        jsr     DrawPosText
        lda     $99
        jsr     _c35574
        ldy     #$4411
        jsr     InitTextBuf
        clr_a
        lda     $99
        asl3
        tax
        ldy     #8
@59c4:  lda     f:GenjuName,x
        sta     hWMDATA
        inx
        dey
        bne     @59c4
        stz     hWMDATA
        jsr     DrawPosTextBuf
        clr_a
        lda     $4b
        tax
        lda     $7e9d89,x
        sta     hWRMPYA
        lda     #11
        sta     hWRMPYB
        lda     #$20
        sta     $29
        ldy     #$0011
        sty     $f5
        longa
        lda     hRDMPYL
        tax
@59f4:  shorta
        lda     f:GenjuProp,x               ; magic learn rate
        sta     $e0
        inx
        lda     f:GenjuProp,x               ; magic spell id
        sta     $e1
        inx
        phx
        ldx     #$0005
        ldy     $f5
        lda     $e1
        pha
        jsr     DrawGenjuMagicName
        ldx     #$0018
        ldy     $f5
        pla
        sta     $e1
        jsr     _c35a84
        plx
        longa
        inc     $f5
        inc     $f5
        lda     $f5
        cmp     #$001b
        bne     @59f4
        shorta
        lda     f:GenjuProp,x               ; level up bonus
        cmp     #$ff
        beq     @5a67
        sta     hWRMPYA
        lda     #9
        sta     hWRMPYB
        ldy     #$4713
        jsr     InitTextBuf
        ldx     $00
@5a43:  lda     f:GenjuAtLevelUpText,x
        sta     hWMDATA
        inx
        cpx     #$000e
        bne     @5a43
        ldx     hRDMPYL
        ldy     #$0009
@5a56:  lda     f:GenjuBonusName,x
        sta     hWMDATA
        inx
        dey
        bne     @5a56
        stz     hWMDATA
        jmp     DrawPosTextBuf
@5a67:  ldy     #$4713
        jsr     InitTextBuf
        ldy     #$0017
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5a78:  sta     hWMDATA
        dey
        bne     @5a78
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35a84:
@5a84:  jsr     _c35b3d
        longa
        txa
        sta     $7e9e89
        shorta
        ldx     #$9e8b
        stx     hWMADDL
        lda     $e1
        cmp     #$ff
        beq     @5ad1
        jsr     _c350a2
        cmp     #$ff
        beq     @5ac2
        pha
        lda     #$ff
        sta     hWMDATA
        pla
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
@5ab7:  lda     #$cd
        sta     hWMDATA
@5abc:  stz     hWMDATA
        jmp     DrawPosTextBuf
@5ac2:  lda     #$b5
        sta     hWMDATA
        lda     #$b4
        sta     hWMDATA
        sta     hWMDATA
        bra     @5ab7
@5ad1:  lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        bra     @5abc

; ------------------------------------------------------------------------------

; [ draw magic name and learn rate in esper/armor detail menu ]

DrawGenjuMagicName:
@5ae1:  jsr     _c35b3d
        longa
        txa
        sta     $7e9e89
        shorta

DrawItemMagicName:
@5aed:  jsr     GetMagicNamePtr
        lda     $e1
        cmp     #$ff
        beq     @5b26
        jsr     LoadArrayItem
        ldx     #$9e92
        stx     hWMADDL
        lda     #$c1                    ; colon
        sta     hWMDATA
        lda     #$ff
        sta     hWMDATA
        sta     hWMDATA
        lda     #$d7                    ; multiplication sign
        sta     hWMDATA
        lda     $e0
        jsr     HexToDec3
        lda     $f8
        sta     hWMDATA
        lda     $f9
        sta     hWMDATA
        stz     hWMDATA
        jmp     DrawPosTextBuf

; empty magic slot
@5b26:  ldy     #$000f
        ldx     #$9e8b
        stx     hWMADDL
        lda     #$ff
@5b31:  sta     hWMDATA
        dey
        bne     @5b31
        stz     hWMDATA
        jmp     DrawPosTextBuf

; ------------------------------------------------------------------------------

; [  ]

_c35b3d:
@5b3d:  longa
        tya
        asl6
        sta     $e7
        txa
        asl
        clc
        adc     $e7
        adc     #$4049
        tax
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load esper properties ]

LoadGenjuProp:
@5b54:  clr_a
        lda     $99
        sta     $7eab8d
        lda     $4b
        tax
        lda     $7e9d89,x
        sta     hWRMPYA
        lda     #11
        sta     hWRMPYB
        phb
        lda     #$7e
        pha
        plb
        ldy     #$0001
        longa
        lda     f:hRDMPYL
        tax
        shorta
@5b7b:  inx
        lda     f:GenjuProp,x               ; esper properties
        sta     $ab8d,y
        inx
        iny
        cpy     #6
        bne     @5b7b
        lda     f:GenjuProp,x
        sta     $ab93
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c35b93:
@5b93:  ldx     #$9ec9
        stx     hWMADDL
        clr_a
        lda     $4b
        tax
        lda     $7eab8d,x
        cmp     #$ff
        beq     @5bd1
        pha
        jsr     GetGenjuDescPtr
        pla
        longa
        asl
        tay
        lda     [$e7],y
        tay
        shorta
@5bb3:  lda     [$eb],y
        beq     @5bbd
        sta     hWMDATA
        iny
        bra     @5bb3
@5bbd:  dey
        lda     [$eb],y
        iny
        cmp     #$1c
        beq     @5bd5
        cmp     #$1d
        beq     @5bd5
        cmp     #$1e
        beq     @5bd5
        cmp     #$1f
        beq     @5bd5
@5bd1:  stz     hWMDATA
        rts
@5bd5:  stz     hWMDATA
        iny
        bra     @5bb3

; ------------------------------------------------------------------------------

; [ load esper or magic description for esper menu ]

GetGenjuDescPtr:
@5bdb:  lda     $4b
        beq     GetLoadGenjuAttackDescPtr
        cmp     #$06
        beq     GetGenjuBonusDescPtr

GetMagicDescPtr:
@5be3:  ldx     #$cf80      ; $d8cf80 (pointers to spell descriptions)
        stx     $e7
        ldx     #$c9a0      ; $d8c9a0 (spell descriptions)
        stx     $eb
        lda     #$d8
        sta     $e9
        lda     #$d8
        sta     $ed
        rts

GetGenjuBonusDescPtr:
@5bf6:  ldx     #$ffd0      ; $edffd0 (pointers to esper bonus descriptions)
        stx     $e7
        ldx     #$fe00      ; $edfe00 (esper bonus descriptions)
        stx     $eb
        lda     #$ed
        sta     $e9
        lda     #$ed
        sta     $ed
        rts

GetLoadGenjuAttackDescPtr:
@5c09:  ldx     #.loword(GenjuAttackDescPtrs)
        stx     $e7
        ldx     #.loword(GenjuAttackDesc)
        stx     $eb
        lda     #^GenjuAttackDescPtrs
        sta     $e9
        lda     #^GenjuAttackDesc
        sta     $ed
        rts

; ------------------------------------------------------------------------------

BlitzInputTileTbl:
@5c1c:  .word   $0000,$0000,$0000,$2097,$2098,$208b,$2091,$20d6
@5c2c:  .word   $a0d4,$60d6,$20d5,$c0d6,$20d4,$a0d6,$60d5

; unused
SkillsListTextPtrs:
@5c3a:  .addr   SkillsGenjuText
        .addr   SkillsMagicText
        .addr   SkillsBushidoText
        .addr   SkillsBlitzText
        .addr   SkillsLoreText
        .addr   SkillsRiotText
        .addr   SkillsDanceText

SkillsGenjuText:
@5c48:  .byte   $0d,$79,$84,$ac,$a9,$9e,$ab,$ac,$00

SkillsMagicText:
@5c51:  .byte   $8d,$79,$8c,$9a,$a0,$a2,$9c,$00

SkillsBushidoText:
@5c59:  .byte   $8d,$7a,$92,$b0,$9d,$93,$9e,$9c,$a1,$00

SkillsBlitzText:
@5c63:  .byte   $0d,$7b,$81,$a5,$a2,$ad,$b3,$00

SkillsLoreText:
@5c6b:  .byte   $8d,$7b,$8b,$a8,$ab,$9e,$00

SkillsRiotText:
@5c72:  .byte   $0d,$7c,$91,$9a,$a0,$9e,$00

SkillsDanceText:
@5c79:  .byte   $8d,$7c,$83,$9a,$a7,$9c,$9e,$00

SkillsCharLabelTextList:
@5c81:  .addr   SkillsCharLevelText
        .addr   SkillsCharHPText
        .addr   SkillsCharMPText

; text for small skills window

; there's a bug here: if you first select "espers" and then select "rage" for example, the last two
; characters of espers don't get erased and it instead displays "ragers"

; c3/5c87: bg3_1(23,5) "MP_    "
SkillsMPCostText:
@5c87:  .word   $81b7
        .byte   $8c,$8f,$c7,$ff,$ff,$ff,$ff,$00

; c3/5c91: bg3_1(23,5) "Lore"
SkillsLoreTitleText:
@5c91:  .word   $81b7
        .byte   $8b,$a8,$ab,$9e,$00

; c3/5c98: bg3_1(23,5) "Rage"
SkillsRiotTitleText:
@5c98:  .word   $81b7
        .byte   $91,$9a,$a0,$9e,$00

; c3/5c9f: bg3_1(23,5) "Dance"
SkillsDanceTitleText:
@5c9f:  .word   $81b7
        .byte   $83,$9a,$a7,$9c,$9e,$00

; c3/5ca7: bg3_1(23,5) "Espers"
SkillsGenjuTitleText:
@5ca7:  .word   $81b7
        .byte   $84,$ac,$a9,$9e,$ab,$ac,$00

; c3/5cb0: bg3_1(23,5) "Blitz"
SkillsBlitzTitleText:
@5cb0:  .word   $81b7
        .byte   $81,$a5,$a2,$ad,$b3,$00

; c3/5cb8: bg3_1(23,5) "SwdTech"
SkillsBushidoTitleText:
@5cb8:  .word   $81b7
        .byte   $92,$b0,$9d,$93,$9e,$9c,$a1,$00

; "LV"
SkillsCharLevelText:
@5cc2:  .word   $422d
        .byte   $8b,$95,$00

; "HP"
SkillsCharHPText:
@5cc7:  .word   $42ad
        .byte   $87,$8f,$00

; "MP"
SkillsCharMPText:
@5ccc:  .word   $432d
        .byte   $8c,$8f,$00

; "/"
SkillsCharHPSlashText:
@5cd1:  .word   $42bb
        .byte   $c0,$00

; "/"
SkillsCharMPSlashText:
@5cd5:  .word   $433b
        .byte   $c0,$00

; " has it!"
GenjuEquipErrorMsgText:
@5cd9:  .byte   $ff,$a1,$9a,$ac,$ff,$a2,$ad,$be,$00

; "Skill"
GenjuLearnPctText:
@5ce2:  .word   $4439
        .byte   $92,$a4,$a2,$a5,$a5,$00

; "Learn.Rate"
GenjuLearnRateText:
@5cea:  .word   $4423
        .byte   $8b,$9e,$9a,$ab,$a7,$c5,$91,$9a,$ad,$9e,$00

; "At level up..."
GenjuAtLevelUpText:
@5cf7:  .byte   $80,$ad,$ff,$a5,$9e,$af,$9e,$a5,$ff,$ae,$a9,$c5,$c5,$c5

; ------------------------------------------------------------------------------
