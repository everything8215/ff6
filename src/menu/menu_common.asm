.include "src/sound/sfx.inc"
.include "src/sound/song_script.inc"

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ open menu ]

.proc OpenMenu
        longi
        shorta
        lda     #$00                    ; set data bank
        pha
        plb
        ldx     #$0000                  ; set direct page
        phx
        pld
        ldx     #0                      ; set zZero
        stx     zZero
        lda     #$7e
        sta     hWMADDH                 ; set wram bank
        jsr     InitInterrupts
        lda     r0200
        cmp     #MENU_TYPE::GAME_LOAD
        bne     :+                      ; branch if not opening game load menu
        jsr     InitSaveSlot
:       jsr     InitMenu
        jsr     OpenMenuType
        jsl     InitCtrl
        lda     #$8f
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        lda     r0200
        cmp     #MENU_TYPE::GAME_LOAD
        bne     :+                      ; branch if not restoring a saved game
        lda     r0205
        bpl     :+                      ; branch if tent/warp/warp stone was used
        lda     $1d4e
        and     #$20
        beq     :+                      ; branch if stereo mode
        lda     #$ff
        jsr     SetStereoMono
:       lda     r0200
        bne     Done                    ; branch if not main menu
        lda     r0205
        bpl     Done                    ; return if return code is positive
        cmp     #$fe
        bne     :+                      ; branch if not using rename card

; rename card
        lda     #MENU_TYPE::NAME_CHANGE
        sta     r0200
        lda     r0201
        sta     r020f
        ldy     r0206
        sty     r0201
        jsl     OpenMenu_ext
        lda     r020f
        sta     r0201
        stz     r0200
        jmp     OpenMenu

; swdtech renaming (ff6j)
:       lda     #MENU_TYPE::BUSHIDO_NAME
        sta     r0200
        lda     r0201
        sta     r020f
        lda     r0206
        sta     r0201
        jsl     OpenMenu_ext
        lda     r020f
        sta     r0201
        stz     r0200
        jmp     OpenMenu

; return from menu
Done:   rtl
.endproc  ; OpenMenu

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

.proc InitInterrupts
        lda     #$5c
        sta     $1500
        sta     $1504
        ldx     #near MenuNMI
        stx     $1501
        ldx     #near MenuIRQ
        stx     $1505
        lda     #^MenuNMI
        sta     $1503
        sta     $1507
        rts
.endproc  ; InitInterrupts

; ------------------------------------------------------------------------------

; [ open menu (type) ]

.proc OpenMenuType

        clr_a
        lda     r0200
        asl
        tax
        jmp     (near OpenMenuTypeTbl,x)

.endproc  ; OpenMenuType

; menu type jump table
OpenMenuTypeTbl:
        ptr_tbl MENU_TYPE

; ------------------------------------------------------------------------------

; [ init menu ]

.proc InitMenu
        jsr     InitRAM
        jsr     InitCharProp
        jsr     _c369a9
        jsl     InitHWRegsMenu
        jsl     InitCtrl
        clr_a
        jsl     InitGradientHDMA
        jsr     InitWindow1PosHDMA
        jsr     ResetTasks
        jsr     InitMenuGfx
        jmp     LoadWindowGfx
.endproc  ; InitMenu

; ------------------------------------------------------------------------------

; [ menu type $00: main menu (field menu) ]

.proc FieldMenu
        array_label MENU_TYPE, MENU_TYPE::FIELD
        lda     #MENU_STATE::FIELD_MENU_INIT
        sta     zMenuState
        jmp     MenuLoop
.endproc  ; FieldMenu

; ------------------------------------------------------------------------------

; [ menu type $03: shop ]

.proc ShopMenu
        array_label MENU_TYPE, MENU_TYPE::SHOP
        jsr     InitFontColor
        lda     #MENU_STATE::SHOP_INIT
        sta     zMenuState
        jmp     MenuLoop
.endproc  ; ShopMenu

; ------------------------------------------------------------------------------

; [ menu type $04: party select ]

.proc PartyMenu
        array_label MENU_TYPE, MENU_TYPE::PARTY
        jsr     InitFontColor
        jsr     ResetCursorPos
        lda     #MENU_STATE::PARTY_INIT
        sta     zMenuState
        jmp     MenuLoop
.endproc  ; PartyMenu

; ------------------------------------------------------------------------------

; [ clear previous cursor position ]

.proc ResetCursorPos
        clr_ay
        sty     z8e
        rts
.endproc  ; ResetCursorPos

; ------------------------------------------------------------------------------

; [ menu type $05: ??? (unused) ]

.proc ItemDetailsMenu
        array_label MENU_TYPE, MENU_TYPE::ITEM_DETAILS
        jsr     InitFontColor
        jsr     ResetCursorPos
        lda     #MENU_STATE::MENU_STATE_2F
        sta     zMenuState
        bra     MenuLoop
.endproc  ; ItemDetailsMenu

; ------------------------------------------------------------------------------

; [ menu type $06: swdtech renaming (ff6j) ]

.proc BushidoNameMenu
        array_label MENU_TYPE, MENU_TYPE::BUSHIDO_NAME
        jsr     InitFontColor
        lda     #MENU_STATE::BUSHIDO_NAME_INIT
        sta     zMenuState
        bra     MenuLoop
.endproc  ; BushidoNameMenu

; ------------------------------------------------------------------------------

; [ menu type $07: colosseum ]

.proc ColosseumMenu
        array_label MENU_TYPE, MENU_TYPE::COLOSSEUM
        jsr     InitFontColor
        stz     $79
        stz     $7a
        stz     $7b
        lda     #$ff
        sta     r0205
        lda     #MENU_STATE::COLOSSEUM_ITEM_INIT
        sta     zMenuState
        bra     MenuLoop
.endproc  ; ColosseumMenu

; ------------------------------------------------------------------------------

; [ menu type $08: final battle order ]

.proc FinalOrderMenu
        array_label MENU_TYPE, MENU_TYPE::FINAL_ORDER
        jsr     InitFontColor
        lda     #MENU_STATE::FINAL_ORDER_INIT
        sta     zMenuState
        bra     MenuLoop
.endproc  ; FinalOrderMenu

; ------------------------------------------------------------------------------

; [ menu type $02: restore game ]

.proc GameLoadMenu
        array_label MENU_TYPE, MENU_TYPE::GAME_LOAD
        lda     $307ff1                 ; increment random number seed
        inc
        sta     $307ff1
        jsl     InitCtrl
        jsr     CheckSRAM
        bcc     SRAMInvalid             ; branch if sram is invalid
        lda     #SONG::PRELUDE
        sta     $1301
        lda     #$10
        sta     $1300
        lda     #$80
        sta     $1302
        jsl     ExecSound_ext
        lda     #$ff
        sta     r0205
        lda     #MENU_STATE::LOAD_INIT
        sta     zMenuState
        bra     MenuLoop

; sram invalid
SRAMInvalid:
        jsr     ResetGameTime
        lda     #1
        sta     rSelSaveSlot
        stz     rSaveSlotToLoad         ; don't load a saved game
        lda     #MENU_STATE::TERMINATE
        sta     zMenuState              ; terminate menu
        stz     r0205                   ; clear return code
        bra     MenuLoop
.endproc  ; GameLoadMenu

; ------------------------------------------------------------------------------

; [ menu type $01: name change ]

.proc NameChangeMenu
        array_label MENU_TYPE, MENU_TYPE::NAME_CHANGE
        jsr     InitFontColor
        lda     #MENU_STATE::NAME_CHANGE_INIT
        sta     zMenuState
.endproc  ; NameChangeMenu
; fall through

; ------------------------------------------------------------------------------

; [ menu state loop ]

.proc MenuLoop
        jsr     UpdatePPU
@01bd:  clr_a
        lda     zMenuState                     ; return if menu state is $ff
        cmp     #MENU_STATE::TERMINATE
        beq     @01d8
        longa
        asl
        tax
        shorta
        jsr     (near MenuStateTbl,x)
        jsr     ExecTasks
        jsr     WaitFrame
        jsr     CheckEventTimer
        bra     @01bd
@01d8:  stz     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; menu state jump table
MenuStateTbl:
        ptr_tbl MENU_STATE, 128

.endproc  ; MenuLoop

; unused menu states
        array_item MENU_STATE, {MENU_STATE::MENU_STATE_7B} = 0
        array_item MENU_STATE, {MENU_STATE::MENU_STATE_7C} = 0

; ------------------------------------------------------------------------------

; [ check event timer ]

.proc CheckEventTimer
        lda     zb4
        bne     :+
        lda     $1188       ; return if event timer can cause the menu to close
        bit     #$20
        beq     :+
        ldy     $1189       ; return unless event timer ran out
        bne     :+
        lda     #MENU_STATE::TERMINATE
        sta     zNextMenuState
        stz     zMenuState
        lda     #$05
        sta     r0205
        sta     zb4
:       rts
.endproc  ; CheckEventTimer

; ------------------------------------------------------------------------------

; [ draw positioned text, latin alphabet with no dakuten ]

;  +y = source address (+$c30000)
; $29 = flags (zTextColor)

.proc DrawPosText
        sty     ze7
        lda     #^*
        sta     ze9

::DrawPosTextFar:
        ldx     zZero
        txy
        longa
        lda     [ze7]
        sta     zeb
        inc     ze7
        inc     ze7
        shorta
        lda     #$7e
        sta     zed
Loop:   lda     [ze7],y
        beq     Done
        phy
        txy
        sta     [zeb],y
        inx
        txy
        lda     zTextColor
        sta     [zeb],y
        inx
        ply
        iny
        bra     Loop
Done:   rts
.endproc  ; DrawPosText

; ------------------------------------------------------------------------------

; [ draw positioned text, kana with dakuten ]

.if LANG_EN

DrawPosKana := DrawPosText
DrawPosKanaFar := DrawPosTextFar

.else

.proc DrawPosKana
        sty     ze7
        lda     #^*
        sta     ze9

::DrawPosKanaFar:
        ldx     zZero
        txy
        longa
        lda     [ze7]
        sta     zeb
        inc     ze7
        inc     ze7
        shorta
        lda     #$7e
        sta     zed
Loop:   lda     [ze7],y
        sta     ze0
        beq     Done

; new line
        cmp     #$01
        bne     :+
        longa
        lda     zeb
        clc
        adc     #$0080
        sta     zeb
        ldx     zZero
        shorta
        iny
        bra     Loop

; kana w/o dakuten
:       phy
        cmp     #$53
        bcc     :+
        lda     #$ff
        sta     ze1
        bra     DrawChar

; circle (handakuten)
:       cmp     #$49
        bcc     :+
        lda     #$52
        sta     ze1
        lda     ze0
        clc
        adc     #$17
        sta     ze0
        bra     DrawChar

; dots (dakuten)
:       cmp     #$20
        bcc     DrawChar
        lda     #$51
        sta     ze1
        lda     ze0
        clc
        adc     #$40
        sta     ze0

DrawChar:
        txy
        lda     ze1
        sta     [zeb],y
        iny
        lda     zTextColor
        sta     [zeb],y
        longa
        txa
        clc
        adc     #$0040
        tay
        shorta
        lda     ze0
        sta     [zeb],y
        iny
        lda     zTextColor
        sta     [zeb],y
        inx2
        ply
        iny
        bra     Loop
Done:   rts
.endproc  ; DrawPosKana

.endif

; ------------------------------------------------------------------------------

; [ init buffer for window tiles ]

; Y: flags applied to each tile
;      ---ppptt tttttttt
;        p: bg palette
;        t: tile offset

.proc SetWindowTileFlags
        sty     ze7
        ldx     zZero
        longa
Loop:   lda     f:WindowTileTbl,x
        clc
        adc     ze7
        sta     $7e9f19,x
        inx2
        cpx     #$0038
        bne     Loop
        shorta
        rts
.endproc  ; SetWindowTileFlags

; ------------------------------------------------------------------------------

; [ load and draw window ]

; +y = source address (+$c30000)

.proc DrawWindow
        lda     #^*
        sta     ze9

::DrawWindowFar:
        sty     ze7
        ldx     zZero
        txy
        longa
        lda     [ze7],y
        sta     zeb
        iny2
        lda     [ze7],y
        sta     ze0
        shorta
        sta     ze2
        lda     #$7e
        sta     zed
        ldx     zZero
        txy
        shorti
        ldx     ze0
        ldy     ze1
        longi
        stx     zef
        sty     zf1
        longa
        jsr     DrawWindowRows
        shorta
        rts
.endproc  ; DrawWindow

; ------------------------------------------------------------------------------

; [ draw window tile rows ]

.proc DrawWindowRows
        .a16
        jsr     DrawBorderTop
        ldx     zZero
        ldy     #$0040
        sty     zf3
Loop:   phx
        txa
        and     #%11
        asl
        tax
        jsr     (near DrawWindowRowsTbl,x)
        lda     zf3
        clc
        adc     #$0040
        sta     zf3
        tay
        plx
        inx
        cpx     zf1
        bne     Loop
        jmp     DrawBorderBtm

.endproc  ; DrawWindowRows

.enum DRAW_WINDOW_ROWS
        COUNT = 4
.endenum

DrawWindowRowsTbl:
        ptr_tbl DRAW_WINDOW_ROWS

; ------------------------------------------------------------------------------

; [ draw border row ]

.proc DrawBorderTop
        ldy     zZero
        jsr     SetBorderPatternMask
        lda     $7e9f49
        sta     ze3
        lda     $7e9f4b
        sta     ze5
        ldx     #$0020
        stx     ze0
        bra     DrawWindowRow
.endproc  ; DrawBorderTop

.proc DrawBorderBtm
        jsr     SetBorderPatternMask
        lda     $7e9f4d
        sta     ze3
        lda     $7e9f4f
        sta     ze5
        ldx     #$0024
        stx     ze0
        bra     DrawWindowRow
.endproc  ; DrawBorderBtm

; ------------------------------------------------------------------------------

; [ draw window row ]

        array_label DRAW_WINDOW_ROWS, 0
        jsr     SetWindowPatternMask
        jsr     GetWindowBorder1
        stz     ze0
        bra     DrawWindowRow

        array_label DRAW_WINDOW_ROWS, 1
        jsr     SetWindowPatternMask
        jsr     GetWindowBorder2
        ldx     #$0008
        stx     ze0
        bra     DrawWindowRow

        array_label DRAW_WINDOW_ROWS, 2
        jsr     SetWindowPatternMask
        jsr     GetWindowBorder1
        ldx     #$0010
        stx     ze0
        bra     DrawWindowRow

        array_label DRAW_WINDOW_ROWS, 3
        jsr     SetWindowPatternMask
        jsr     GetWindowBorder2
        ldx     #$0018
        stx     ze0
        bra     DrawWindowRow

; ------------------------------------------------------------------------------

; [ set window area pattern mask ]

.proc SetWindowPatternMask
        ldx     #%11
        stx     zf5
        rts
.endproc  ; SetWindowPatternMask

; ------------------------------------------------------------------------------

; [ set border area pattern mask ]

.proc SetBorderPatternMask
        ldx     #%1
        stx     zf5
        rts
.endproc  ; SetBorderPatternMask

; ------------------------------------------------------------------------------

; [ get 1st tile of left/right border ]

.proc GetWindowBorder1
        lda     $7e9f41
        sta     ze3
        lda     $7e9f43
        sta     ze5
        rts
.endproc  ; GetWindowBorder1

; ------------------------------------------------------------------------------

; [ get 2nd tile of left/right border ]

.proc GetWindowBorder2
        lda     $7e9f45
        sta     ze3
        lda     $7e9f47
        sta     ze5
        rts
.endproc  ; GetWindowBorder2

; ------------------------------------------------------------------------------

; [ draw one row of window ]

.proc DrawWindowRow
        ldx     zZero
        lda     ze3
        sta     [zeb],y
        iny2
Loop:   phx
        txa
        and     zf5
        asl
        clc
        adc     ze0
        tax
        lda     $7e9f19,x
        plx
        cpx     zef
        beq     Done
        sta     [zeb],y
        iny2
        inx
        bra     Loop
Done:   lda     ze5
        sta     [zeb],y
        rts
        .a8
.endproc  ; DrawWindowRow

; ------------------------------------------------------------------------------

WindowTileTbl:
        .word   $0180,$0181,$0182,$0183  ; window mid 1
        .word   $0184,$0185,$0186,$0187  ; window mid 2
        .word   $0188,$0189,$018a,$018b  ; window mid 3
        .word   $018c,$018d,$018e,$018f  ; window mid 4
        .word   $0191,$0192,$0199,$019a  ; upper/lower border
        .word   $0194,$0195,$0196,$0197  ; left/right border
        .word   $0190,$0193,$0198,$019b  ; border corners

; ------------------------------------------------------------------------------

; [ draw number text (3 digit) ]

.proc Draw16BitNum
        ldy     #5
        sty     ze0
        ldy     #2
        bra     DrawNumText
.endproc  ; Draw16BitNum

; ------------------------------------------------------------------------------

; [ draw number text (4 digit) ]

; hp/mp

.proc DrawNum4
        ldy     #5
        sty     ze0
        ldy     #1
        bra     DrawNumText
.endproc  ; DrawNum4

; ------------------------------------------------------------------------------

; [ draw number text (5 digit) ]

.proc DrawNum5
        ldy     #5
        sty     ze0
        ldy     zZero
        bra     DrawNumText
.endproc  ; DrawNum5

; ------------------------------------------------------------------------------

; [ draw number text (8 digit) ]

; experience

.proc DrawNum8
        ldy     #8
        sty     ze0
        ldy     zZero
        bra     DrawNumText
.endproc  ; DrawNum8

; ------------------------------------------------------------------------------

; [ draw number text (7 digit) ]

; steps, gp

.proc DrawNum7
        ldy     #8
        sty     ze0
        ldy     #1
        bra     DrawNumText
.endproc  ; DrawNum7

; ------------------------------------------------------------------------------

; [ draw number text (2 digit) ]

.proc DrawNum2
        ldy     #3
        sty     ze0
        ldy     #1
        bra     DrawNumText
.endproc  ; DrawNum2

; ------------------------------------------------------------------------------

; [ draw number text (3 digit) ]

.proc DrawNum3
        ldy     #3
        sty     ze0
        ldy     zZero
.endproc  ; DrawNum3
; fall through

; ------------------------------------------------------------------------------

; [ draw number text ]

;      +X: destination address (+$7e0000)
;      +Y: text buffer offset
;     $29: vhopppmm high byte of bg data (zTextColor)
;    +$e0: text length
; $f7-$ff: text buffer

.proc DrawNumText
        stx     zeb
        lda     #$7e
        sta     zed
        tyx
        ldy     zZero
Loop:   lda     zf7,x
        sta     [zeb],y
        iny
        lda     zTextColor
        sta     [zeb],y
        iny
        inx
        cpx     ze0
        bne     Loop
        rts
.endproc  ; DrawNumText

; ------------------------------------------------------------------------------

; [ convert hex to decimal (3 digits) ]

;    +$f3 = hex number
; $f7-$f9 = decimal digits (battle text)

.proc HexToDec3
        jsr     HexToDecZeroes3
        ldy     zZero
        ldx     #2
Loop:   lda     zf7,y
        cmp     #ZERO_CHAR
        bne     Done
        lda     #$ff
        sta     zf7,y
        iny
        dex
        bne     Loop
Done:   rts
.endproc  ; HexToDec3

; ------------------------------------------------------------------------------

; [ convert hex to decimal (3 digits, keep leading zeroes) ]

;    +$f3 = hex number
; $f7-$f9 = decimal digits (battle text)

.proc HexToDecZeroes3
        sta     ze0
        lda     #3
        sta     ze4
        ldy     zZero
        tyx

DigitLoop:
        stz     ze1
        lda     f:HexToDec3Tbl,x
        inx
        sta     ze3

DivLoop:
        lda     ze0
        sec
        sbc     ze3
        bcc     :+
        sta     ze0
        inc     ze1
        bra     DivLoop
:       clc
        adc     zed
        sta     zf3
        lda     ze1
        clc
        adc     #ZERO_CHAR
        sta     zf7,y
        iny
        dec     ze4
        bne     DigitLoop
        rts
.endproc  ; HexToDecZeroes3

; ------------------------------------------------------------------------------

; data for 3 digit hex to dec conversion
HexToDec3Tbl:
        .byte   100, 10, 1

; ------------------------------------------------------------------------------

; [ convert hex to decimal (5 digits) ]

;    +$f3 = hex number
; $f7-$fb = decimal digits (battle text)

HexToDec5:
@052e:  lda     #5
        sta     ze0
        ldy     zZero
        tyx
@0535:  longa
        lda     f:HexToDec5Tbl,x
        inx2
        sta     zed
        stz     zeb
@0541:  sec
        lda     zf3
        sbc     zed
        bcc     @054e
        sta     zf3
        inc     zeb         ; increment digit
        bra     @0541
@054e:  clc
        adc     zed
        sta     zf3
        shorta
        lda     zeb
        clc
        adc     #ZERO_CHAR
        sta     zf7,y
        iny
        dec     ze0
        bne     @0535
        ldy     zZero
        ldx     #4
@0567:  lda     zf7,y
        cmp     #ZERO_CHAR
        bne     @0577
        lda     #$ff
        sta     zf7,y
        iny
        dex
        bne     @0567
@0577:  rts

; ------------------------------------------------------------------------------

; data for 5 digit hex to dec conversion
HexToDec5Tbl:
        .word   10000, 1000, 100, 10, 1

; ------------------------------------------------------------------------------

; [ convert hex to decimal (8 digits) ]

;    +$f3 = hex number
; $f7-$fe = decimal digits (battle text)

HexToDec8:
@0582:  stz     zf4
        lda     #8
        sta     ze0
        ldy     zZero
        tyx
@058b:  longa
        stz     zeb
@058f:  sec
        lda     zf1
        sbc     f:HexToDec8TblLo,x
        sta     zf1
        lda     zf3
        sbc     f:HexToDec8TblHi,x
        sta     zf3
        bcc     @05a6
        inc     zeb
        bra     @058f
@05a6:  lda     zf1
        clc
        adc     f:HexToDec8TblLo,x
        sta     zf1
        lda     zf3
        adc     f:HexToDec8TblHi,x
        sta     zf3
        shorta
        lda     zeb
        clc
        adc     #ZERO_CHAR
        sta     zf7,y
        iny
        inx2
        dec     ze0
        bne     @058b
        ldy     zZero
        ldx     #7
@05cd:  lda     zf7,y
        cmp     #ZERO_CHAR
        bne     @05dd
        lda     #$ff
        sta     zf7,y
        iny
        dex
        bne     @05cd
@05dd:  rts

; ------------------------------------------------------------------------------

; data for 8 digit hex to dec conversion
HexToDec8TblLo:
        .addr   10000000
        .addr   1000000
        .addr   100000
        .addr   10000
        .addr   1000
        .addr   100
        .addr   10
        .addr   1

HexToDec8TblHi:
        .word   ^10000000
        .word   ^1000000
        .word   ^100000
        .word   ^10000
        .word   ^1000
        .word   ^100
        .word   ^10
        .word   ^1

; ------------------------------------------------------------------------------

; [ init cursor ]

; +y = pointer to cursor data (+$c30000)

; $00 x------y
;     x: disable cursor wrap in x direction
;     y: disable cursor wrap in y direction
; $01 initial x position (0-based)
; $02 initial y position
; $03 maximum x position (1-based)
; $04 maximum y position

LoadCursor:
@05fe:  lda     #^*
        sta     zed

LoadCursorFar:
@0602:  sty     zeb
        ldy     zZero
        lda     [zeb],y
        sta     zCursorWrap
        iny
        longa
        stz     z51
        lda     [zeb],y
        sta     z4d
        iny2
        lda     [zeb],y
        sta     z53
        stz     z4f
        shorta
        rts

; ------------------------------------------------------------------------------

; [ select first valid character slot ]

SelectFirstChar:
@061e:  clr_ay
@0620:  tya
        asl
        tax
        lda     z85,x       ; character select cursor positions
        bne     @062f
        inc     z4e         ; increment cursor position
        iny
        cpy     #4
        bne     @0620
@062f:  rts

; ------------------------------------------------------------------------------

; [ set pointer to cursor data ]

; y = pointer to cursor data (+$c30000)

SetCursorPtr:
@0630:  sty     ze7
        lda     #^*
        sta     ze9
        rts

; ------------------------------------------------------------------------------

; [ update cursor position (rotated list) ]

; y = pointer to cursor data (+$c30000)

UpdateHorzCursorPos:
@0637:  jsr     SetCursorPtr
        jsr     CalcHorzListIndex
        jmp     SetCursorPos

; ------------------------------------------------------------------------------

; [ update cursor position (single page) ]

; y = pointer to cursor data (+$c30000)

UpdateCursorPos:
@0640:  jsr     SetCursorPtr

UpdateCursorPosFar:
@0643:  jsr     CalcShortListIndex
        bra     SetCursorPos

; ------------------------------------------------------------------------------

; [ update cursor position (scrolling page) ]

; y = pointer to cursor data (+$c30000)

UpdateListCursorPos:
@0648:  jsr     SetCursorPtr
        jsr     CalcLongListIndex
        bra     SetCursorPos

; ------------------------------------------------------------------------------

; [ update selected item (horizontal list) ]

CalcHorzListIndex:
@0650:  phb
        lda     #$00
        pha
        plb
@0655:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @0655
        lda     z54                     ; max y position
        sta     hM7A
        stz     hM7A
        lda     z4d                     ; current x position (relative to page)
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     z4e                     ; current y position (relative to page)
        sta     z4b                     ; $4b = $54 * $4d + $4e
        plb
        rts

; ------------------------------------------------------------------------------

; [ update selected item (vertical list, single page) ]

CalcShortListIndex:
@0677:  phb
        lda     #$00
        pha
        plb
@067c:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @067c
        lda     z53                     ; max x position
        sta     hM7A
        stz     hM7A
        lda     z4e                     ; current y position (relative to page)
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     z4d                     ; current x position (relative to page)
        sta     z4b                     ; $4b = $53 * $4e + $4d
        plb
        rts

; ------------------------------------------------------------------------------

; [ update selected item (vertical list, scrolling page) ]

CalcLongListIndex:
@069e:  phb
        lda     #$00
        pha
        plb
@06a3:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @06a3
        lda     z53                     ; max x position
        sta     hM7A
        stz     hM7A
        lda     z50                     ; current y position (absolute)
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     z4f                     ; current x position (absolute)
        sta     z4b                     ; $4b = $53 * $50 + $4f
        plb
        rts

; ------------------------------------------------------------------------------

; [ update cursor sprite position ]

SetCursorPos:
@06c5:  phb
        lda     #$00
        pha
        plb
        lda     z53
        dec
        cmp     z4d
        bcs     @06dd
        lda     z53
        dec
        sec
        sbc     z51
        sta     ze0
        sta     ze2
        bra     @06e5
@06dd:  lda     z53
        sta     ze0
        lda     z4d
        sta     ze2
@06e5:  lda     z54
        dec
        cmp     z4e
        bcs     @06f6
        lda     z54
        dec
        sec
        sbc     z52
        sta     ze1
        bra     @06fa
@06f6:  lda     z4e
        sta     ze1
@06fa:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @06fa
        lda     ze0
        sta     hM7A
        stz     hM7A
        lda     ze1
        sta     hM7B
        sta     hM7B
        lda     hMPYL
        clc
        adc     ze2
        asl
        xba
        lda     zZero
        xba
        tay
        lda     [ze7],y
        sta     z55
        stz     z56
        iny
        lda     [ze7],y
        sta     z57
        stz     z58
        plb
        rts

; ------------------------------------------------------------------------------

; [ update cursor movement (single page) ]

MoveCursor:

; up
@072d:  lda     zRepCtrlState_H                     ; branch if up button is not pressed
        bit     #>JOY_UP
        beq     @0750
        lda     z4e
        bne     @0748
        lda     zCursorWrap
        and     #$01
        bne     @07af
        lda     z54
        dec
        sta     z4e
        jsr     PlayMoveSfx
        jmp     @07af
@0748:  dec     z4e
        jsr     PlayMoveSfx
        jmp     @07af

; down
@0750:  lda     zRepCtrlState_H                     ; branch if down button is not pressed
        bit     #>JOY_DOWN
        beq     @0773
        lda     z54
        dec
        cmp     z4e
        bne     @076b
        lda     zCursorWrap
        and     #$01
        bne     @07af
        stz     z4e
        jsr     PlayMoveSfx
        jmp     @07af
@076b:  inc     z4e
        jsr     PlayMoveSfx
        jmp     @07af

; left
@0773:  lda     zRepCtrlState_H                     ; branch if left button is not pressed
        bit     #>JOY_LEFT
        beq     @0792
        lda     z4d
        bne     @078b
        lda     zCursorWrap
        bmi     @07af
        lda     z53
        dec
        sta     z4d
        jsr     PlayMoveSfx
        bra     @07af
@078b:  dec     z4d
        jsr     PlayMoveSfx
        bra     @07af

; right
@0792:  lda     zRepCtrlState_H                     ; branch if right button is not pressed
        bit     #>JOY_RIGHT
        beq     @07af
        lda     z53
        dec
        cmp     z4d
        bne     @07aa
        lda     zCursorWrap
        bmi     @07af
        stz     z4d
        jsr     PlayMoveSfx
        bra     @07af
@07aa:  inc     z4d
        jsr     PlayMoveSfx
@07af:  rts

; ------------------------------------------------------------------------------

; [ create cursor sprite task ]

CreateCursorTask:
@07b0:  lda     #1                      ; priority 1
        ldy     #near CursorTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ cursor sprite task ]

CursorTask:
@07b8:  tax
        jmp     (near CursorTaskTbl,x)

CursorTaskTbl:
@07bc:  .addr   CursorTask_00
        .addr   CursorTask_01

; ------------------------------------------------------------------------------

; state $00: init
CursorTask_00:
@07c0:  ldx     zTaskOffset
        longa
        lda     #near CursorAnimData
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^CursorAnimData
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask
        inc     near wTaskProp::State,x                 ; increment task state
        lda     #$01
        sta     near wTaskProp::Flags,x                 ; sprite doesn't scroll with bg
; fallthrough

; ------------------------------------------------------------------------------

; state $01: update
CursorTask_01:
@07dc:  lda     z46                     ; terminate if cursor 1 & 2 are inactive
        and     #$06
        beq     @07fd
        lda     z45                     ;
        bit     #$04
        beq     @07fb
        ldx     zTaskOffset
        longa
        lda     z55                     ; set cursor x position
        sta     near wTaskProp::PosX_H,x
        lda     z57                     ; set cursor y position
        sta     near wTaskProp::PosY_H,x
        shorta
        jsr     UpdateAnimTask
@07fb:  sec
        rts
@07fd:  clc
        rts

; ------------------------------------------------------------------------------

; [ flashing cursor task ]

FlashingCursorTask:
@07ff:  tax
        jmp     (near FlashingCursorTaskTbl,x)

FlashingCursorTaskTbl:
@0803:  .addr   FlashingCursorTask_00
        .addr   FlashingCursorTask_01
        .addr   FlashingCursorTask_02
        .addr   FlashingCursorTask_03

; ------------------------------------------------------------------------------

; state $00, $02: init
FlashingCursorTask_00:
FlashingCursorTask_02:
@080b:  ldx     zTaskOffset
        lda     #$01
        tsb     z46                     ; flashing cursor task is active
        longa
        lda     #near FlashingCursorAnimData
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^FlashingCursorAnimData
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask
        lda     #$01
        sta     near wTaskProp::Flags,x                 ; sprite doesn't scroll with bg
        inc     near wTaskProp::State,x                 ; increment task state
; fall through

; ------------------------------------------------------------------------------

; state $01: update (vertical scroll)
FlashingCursorTask_01:
@082b:  lda     z46                     ; terminate if flashing cursor not active
        bit     #$01
        beq     _0865
        ldx     zTaskOffset
        longa
        lda     zTextScrollRate
        neg_a
        clc
        adc     near wTaskProp::PosY_H,x
        sta     near wTaskProp::PosY_H,x                 ; set vertical offset
        shorta
        lda     z46
        and     #$c0
        beq     @0860
        lda     zSelIndex                     ; $e1 = current selection
.if LANG_EN
        sta     ze1
        inc
        sta     ze0                     ; $e0 = current selection + 1
        lda     z4a                     ; page scroll position + 9
        clc                             ; note: page must be at least 10 lines
        adc     #9
        cmp     ze1
        bcc     @0863                   ; return if flashing cursor past bottom
        lda     z4a
.else
        and     #$fe
        inc
        sta     ze0
        lda     z4a
        asl
        clc
        adc     #19
        cmp     ze0
        bcc     @0863
        lda     z4a
        asl
.endif
        cmp     ze0
        bcs     @0863                   ; return if flashing cursor past top
@0860:  jsr     UpdateAnimTask
@0863:  sec
        rts
_0865:  clc
        rts

; ------------------------------------------------------------------------------

; state $03: update (horizontal scroll)
FlashingCursorTask_03:
@0867:  lda     z46                     ; terminate if flashing cursor not active
        bit     #$01
        beq     _0865
        ldx     zTaskOffset
        longa
        lda     z97
        neg_a
        clc
        adc     near wTaskProp::PosX_H,x
        sta     near wTaskProp::PosX_H,x                 ; set horizontal offset
        shorta
        ldy     near wTaskProp::PosX_H,x                 ; return if offscreen to the right
        cpy     #$0100
        bcs     @088b
        jsr     UpdateAnimTask
@088b:  sec
        rts

; ------------------------------------------------------------------------------

; animation data (cursor)
CursorAnimData:
@088d:  .addr   CursorSpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

; sprite data (cursor)
CursorSpriteData:
@0890:  .byte   1
        .byte   $80,$00,$00,$3e

; ------------------------------------------------------------------------------

; sprite data (flashing cursor)
HiddenCursorSpriteData:
@0895:  .byte   0

; ------------------------------------------------------------------------------

; animation data (flashing cursor)
FlashingCursorAnimData:
@0896:  .addr   CursorSpriteData
        .byte   2
        .addr   HiddenCursorSpriteData
        .byte   2
        .addr   CursorSpriteData
        .byte   $ff

; ------------------------------------------------------------------------------

; [ create multi-cursor ]

CreateMultiCursorTask:
@089f:  clr_ax
@08a1:  lda     z85,x                   ; cursor position for character slot 1
        beq     @08c9                   ; branch if slot is empty
        phx
        lda     #1
        ldy     #near MultiCursorTask
        jsr     CreateTask
        txy
        plx
        lda     #$7e
        pha
        plb
        lda     z85,x                   ; set cursor position
        sta     near wTaskProp::PosX_H,y
        lda     z85 + 1,x
        sta     near wTaskProp::PosY_H,y
        clr_a
        sta     near wTaskProp::PosX + 2,y                 ; clear high byte of x and y position
        sta     near wTaskProp::PosY + 2,y
        lda     #$00
        pha
        plb
@08c9:  inx2                            ; next character slot
        cpx     #8
        bne     @08a1
        rts

; ------------------------------------------------------------------------------

; [ multi-cursor task ]

MultiCursorTask:
@08d1:  tax
        jmp     (near MultiCursorTaskTbl,x)

MultiCursorTaskTbl:
@08d5:  .addr   MultiCursorTask_00
        .addr   MultiCursorTask_01

; ------------------------------------------------------------------------------

; state 0: init
MultiCursorTask_00:
@08d9:  ldx     zTaskOffset
        lda     #$08                    ; activate multi-cursor
        tsb     z46
        longa
        lda     #near FlashingCursorAnimData
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^FlashingCursorAnimData
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask
        inc     near wTaskProp::State,x                 ; increment task state
        lda     #$01
        sta     near wTaskProp::Flags,x                 ; sprite doesn't scroll with bg

; ------------------------------------------------------------------------------

; state 1: update
MultiCursorTask_01:
@08f9:  lda     z46                     ; terminate if multi-cursor is not active
        bit     #$08
        beq     @0906
        ldx     zTaskOffset
        jsr     UpdateAnimTask
        sec
        rts
@0906:  clc
        rts

; ------------------------------------------------------------------------------

; [ update top/bottom page scroll flags ]

UpdateScrollArrowFlags:
@0908:  lda     #$c0
        tsb     z46
        lda     z4a                     ; branch if not at page 0
        bne     @0914
        lda     #$40                    ; page can't scroll up
        trb     z46
@0914:  lda     z4a                     ; branch if not at max page scroll position
        cmp     z5c
        bne     @091e
        lda     #$80                    ; page can't scroll down
        trb     z46
@091e:  rts

; ------------------------------------------------------------------------------

; [ init scroll indicator task (item/skills list) ]

CreateScrollArrowTask1:
@091f:  lda     #3                      ; priority 3
        ldy     #near ScrollArrowTask
        jsr     CreateTask
        longa
        lda     #$00e8                  ; should be #$e800 -> wTaskProp::PosX
        sta     wTaskProp::PosX_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init scroll indicator task (equip/relic item list) ]

CreateScrollArrowTask2:
@0933:  lda     #3                      ; priority 3
        ldy     #near ScrollArrowTask
        jsr     CreateTask
        longa
.if LANG_EN
        lda     #$0078                  ; x offset
.else
        lda     #$0070                  ; x offset
.endif
        sta     wTaskProp::PosX_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ scroll indicator arrow task ]

ScrollArrowTask:
@0947:  tax
        jmp     (near ScrollArrowTaskTbl,x)

ScrollArrowTaskTbl:
@094b:  .addr   ScrollArrowTask_00
        .addr   ScrollArrowTask_01

; ------------------------------------------------------------------------------

; state $00: init
ScrollArrowTask_00:
@094f:  ldx     zTaskOffset
        longa
        lda     #near ScrollArrowAnimData_00
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^ScrollArrowAnimData_00
        sta     near wTaskProp::AnimBank,x
        inc     near wTaskProp::State,x                 ; increment task state
        jsr     InitAnimTask
        lda     #$c0
        tsb     z46                     ; enable scrolling up and down
; fall through

; ------------------------------------------------------------------------------

; state $01: update
ScrollArrowTask_01:
@096a:  lda     z46                     ; scroll page flags
        and     #$c0
        beq     @09d9                   ; terminate task if page can't scroll up or down
        ldx     zTaskOffset
        jsr     UpdateScrollArrowFlags
@0975:  lda     f:hHVBJOY               ; wait for hblank
        and     #$40
        beq     @0975
        lda     near wTaskProp::SpeedY_H,x
        sta     f:hM7A
        lda     near wTaskProp::SpeedY + 2,x
        sta     f:hM7A
        lda     z4a                     ; page scroll position
        sta     f:hM7B
        sta     f:hM7B
.if LANG_EN
        lda     z4a
        bmi     @09aa
        clr_a
        lda     f:hMPYM
        longa_clc
        adc     near wTaskProp::SpeedX_H,x
        sta     near wTaskProp::PosY_H,x        ; set vertical offset
        shorta
        bra     @09bd
@09aa:  clr_a
        lda     f:hMPYM
        longa_clc
        adc     #$0070                  ; this is hard-coded for the item list
        clc
        adc     near wTaskProp::SpeedX_H,x
        sta     near wTaskProp::PosY_H,x        ; set vertical offset
        shorta
@09bd:  clr_a
.else
        clr_a
        lda     f:hMPYM
        longa_clc
        adc     near wTaskProp::SpeedX_H,x
        sta     near wTaskProp::PosY_H,x
        shorta
.endif
        lda     z46                     ; scroll page flags
        and     #$c0
        lsr5
        txy
        tax
        longa
        lda     f:ScrollArrowAnimDataTbl,x
        sta     near wTaskProp::AnimPtr,y
        shorta
        jsr     UpdateAnimTask
        sec
        rts
@09d9:  clc
        rts

; ------------------------------------------------------------------------------

; pointers to animation data
ScrollArrowAnimDataTbl:
@09db:  .addr   ScrollArrowAnimData_00
        .addr   ScrollArrowAnimData_01
        .addr   ScrollArrowAnimData_02
        .addr   ScrollArrowAnimData_03

; ------------------------------------------------------------------------------

; can scroll both up and down
ScrollArrowAnimData_00:
ScrollArrowAnimData_03:
@09e3:  .addr   ScrollArrowSpriteDataNone
        .byte   $10
        .addr   ScrollArrowSpriteDataBoth
        .byte   $10
        .addr   ScrollArrowSpriteDataNone
        .byte   $ff

; can scroll up only
ScrollArrowAnimData_01:
@09ec:  .addr   ScrollArrowSpriteDataNone
        .byte   $10
        .addr   ScrollArrowSpriteDataUp
        .byte   $10
        .addr   ScrollArrowSpriteDataNone
        .byte   $ff

; can scroll down only
ScrollArrowAnimData_02:
@09f5:  .addr   ScrollArrowSpriteDataNone
        .byte   $10
        .addr   ScrollArrowSpriteDataDown
        .byte   $10
        .addr   ScrollArrowSpriteDataNone
        .byte   $ff

; ------------------------------------------------------------------------------

; sprite data
ScrollArrowSpriteDataNone:
@09fe:  .byte   2
        .byte   $00,$00,$02,$3e
        .byte   $00,$08,$02,$be

ScrollArrowSpriteDataBoth:
@0a07:  .byte   2
        .byte   $00,$00,$12,$3e
        .byte   $00,$08,$12,$be

ScrollArrowSpriteDataUp:
@0a10:  .byte   2
        .byte   $00,$00,$12,$3e
        .byte   $00,$08,$02,$be

ScrollArrowSpriteDataDown:
@0a19:  .byte   2
        .byte   $00,$00,$02,$3e
        .byte   $00,$08,$12,$be

; ------------------------------------------------------------------------------

; [ create portrait task (slot 1) ]

CreatePortraitTask1:
@0a22:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z60
        phb
        lda     #$7e
        pha
        plb
        ldy     zZero
        jsr     InitPortraitRowPos
        ldy     zZero
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0015
        sta     near wTaskProp::PosY_H,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 2) ]

CreatePortraitTask2:
@0a4b:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z60 + 1
        phb
        lda     #$7e
        pha
        plb
        ldy     #1
        jsr     InitPortraitRowPos
        ldy     #1
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0045
        sta     near wTaskProp::PosY_H,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 3) ]

CreatePortraitTask3:
@0a76:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z60 + 2
        phb
        lda     #$7e
        pha
        plb
        ldy     #2
        jsr     InitPortraitRowPos
        ldy     #2
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$0075
        sta     near wTaskProp::PosY_H,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ create portrait task (slot 4) ]

CreatePortraitTask4:
@0aa1:  lda     #3
        ldy     #near PortraitTask
        jsr     CreateTask
        txa
        sta     z60 + 3
        phb
        lda     #$7e
        pha
        plb
        ldy     #3
        jsr     InitPortraitRowPos
        ldy     #3
        jsr     GetPortraitAnimDataPtr
        longa
        lda     #$00a5
        sta     near wTaskProp::PosY_H,x
        shorta
        jsr     InitAnimTask
        plb
        rts

; ------------------------------------------------------------------------------

; [ init portrait task animation data pointer ]

; +y = character slot

GetPortraitAnimDataPtr:
@0acc:  phx
        phx
        tyx
        lda     zCharRowOrder,x
        and     #%00011000
        lsr2
        tax
        longa
        lda     f:PortraitAnimDataTbl,x
        ply
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     #^Portrait1AnimData
        sta     near wTaskProp::AnimBank,y
        plx
        rts

; ------------------------------------------------------------------------------

; pointers to portrait animation data
PortraitAnimDataTbl:
@0ae9:  .addr   Portrait1AnimData
        .addr   Portrait2AnimData
        .addr   Portrait3AnimData
        .addr   Portrait4AnimData

; ------------------------------------------------------------------------------

; [ init portrait task x offset ]

; +y = character slot

InitPortraitRowPos:
@0af1:  phx
        tyx
        lda     #$02        ;
        bit     z45
        bne     @0aff
        lda     zCharRowOrder,x       ; character row
        bit     #$20
        beq     @0b06       ; branch if front row
@0aff:  longa
        lda     #26
        bra     @0b0b
@0b06:  longa
        lda     #14
@0b0b:  plx
        sta     near wTaskProp::PosX_H,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ portrait task ]

.enum PORTRAIT_TASK
        INIT
        SUSTAIN
        SLIDE_RIGHT
        SLIDE_LEFT
        WAIT_SLIDE

        COUNT
.endenum

.proc PortraitTask

@0b12:  tax
        jmp     (near PortraitTaskTbl,x)

PortraitTaskTbl:
        ptr_tbl PORTRAIT_TASK

.endproc  ; PortraitTask

; ------------------------------------------------------------------------------

; state 0: init
        array_label PORTRAIT_TASK, PORTRAIT_TASK::INIT
@0b20:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     #1
        sta     near wTaskProp::Flags,x
; fall through

; ------------------------------------------------------------------------------

; state 1: update
        array_label PORTRAIT_TASK, PORTRAIT_TASK::SUSTAIN
@0b2a:  ldx     zTaskOffset
        lda     near wTaskProp::w7e35c9,x
        bmi     @0b36
        jsr     UpdateAnimTask
        sec
        rts
@0b36:  clc
        rts

; ------------------------------------------------------------------------------

; state 2: slide to the right
        array_label PORTRAIT_TASK, PORTRAIT_TASK::SLIDE_RIGHT
@0b38:  ldx     zTaskOffset
        longa
        lda     #1
        sta     near wTaskProp::SpeedX_H,x
        lda     #12
        sta     near wTaskProp::w7e3349,x
        shorta
        array_op bra, PORTRAIT_TASK, PORTRAIT_TASK::WAIT_SLIDE

; ------------------------------------------------------------------------------

; state 3: slide to the left
        array_label PORTRAIT_TASK, PORTRAIT_TASK::SLIDE_LEFT
@0b4c:  ldx     zTaskOffset
        longa
        lda     #near -1
        sta     near wTaskProp::SpeedX_H,x
        lda     #12
        sta     near wTaskProp::w7e3349,x
        shorta
; fall through

; ------------------------------------------------------------------------------

; state 4: wait for slide
        array_label PORTRAIT_TASK, PORTRAIT_TASK::WAIT_SLIDE
@0b5e:  ldx     zTaskOffset
        lda     #PORTRAIT_TASK::WAIT_SLIDE
        sta     near wTaskProp::State,x
        longa
        lda     near wTaskProp::w7e3349,x                 ; branch if slide complete
        beq     @0b80
        lda     near wTaskProp::SpeedX_H,x                 ; increase horizontal position
        clc
        adc     near wTaskProp::PosX_H,x
        sta     near wTaskProp::PosX_H,x
        dec     near wTaskProp::w7e3349,x                 ; decrement movement counter
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; slide complete
@0b80:  shorta
        lda     #1                      ; back to state 1
        sta     near wTaskProp::State,x
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; portrait slot 1 animation data
Portrait1AnimData:
@0b8c:  .addr   Portrait1SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

; portrait slot 1 sprite data
Portrait1SpriteData:
@0b8f:  .byte   13
        .byte   $80,$00,$60,$20
        .byte   $90,$00,$62,$20
        .byte   $80,$10,$64,$20
        .byte   $90,$10,$66,$20
        .byte   $20,$00,$68,$20
        .byte   $20,$08,$69,$20
        .byte   $20,$10,$6a,$20
        .byte   $20,$18,$6b,$20
        .byte   $20,$20,$6c,$20
        .byte   $00,$20,$6d,$20
        .byte   $08,$20,$6e,$20
        .byte   $10,$20,$6f,$20
        .byte   $18,$20,$78,$20

; ------------------------------------------------------------------------------

Portrait2AnimData:
@0bc4:  .addr   Portrait2SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

Portrait2SpriteData:
@0bc7:  .byte   13
        .byte   $80,$00,$80,$22
        .byte   $90,$00,$82,$22
        .byte   $80,$10,$84,$22
        .byte   $90,$10,$86,$22
        .byte   $20,$00,$88,$22
        .byte   $20,$08,$89,$22
        .byte   $20,$10,$8a,$22
        .byte   $20,$18,$8b,$22
        .byte   $20,$20,$8c,$22
        .byte   $00,$20,$8d,$22
        .byte   $08,$20,$8e,$22
        .byte   $10,$20,$8f,$22
        .byte   $18,$20,$98,$22

; ------------------------------------------------------------------------------

Portrait3AnimData:
@0bfc:  .addr   Portrait3SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

Portrait3SpriteData:
@0bff:  .byte   13
        .byte   $80,$00,$a0,$24
        .byte   $90,$00,$a2,$24
        .byte   $80,$10,$a4,$24
        .byte   $90,$10,$a6,$24
        .byte   $20,$00,$a8,$24
        .byte   $20,$08,$a9,$24
        .byte   $20,$10,$aa,$24
        .byte   $20,$18,$ab,$24
        .byte   $20,$20,$ac,$24
        .byte   $00,$20,$ad,$24
        .byte   $08,$20,$ae,$24
        .byte   $10,$20,$af,$24
        .byte   $18,$20,$b8,$24

; ------------------------------------------------------------------------------

Portrait4AnimData:
@0c34:  .addr   Portrait4SpriteData
        .byte   $fe

; ------------------------------------------------------------------------------

Portrait4SpriteData:
@0c37:  .byte   13
        .byte   $80,$00,$c0,$26
        .byte   $90,$00,$c2,$26
        .byte   $80,$10,$c4,$26
        .byte   $90,$10,$c6,$26
        .byte   $20,$00,$c8,$26
        .byte   $20,$08,$c9,$26
        .byte   $20,$10,$ca,$26
        .byte   $20,$18,$cb,$26
        .byte   $20,$20,$cc,$26
        .byte   $00,$20,$cd,$26
        .byte   $08,$20,$ce,$26
        .byte   $10,$20,$cf,$26
        .byte   $18,$20,$d8,$26

; ------------------------------------------------------------------------------

; [ draw hp/mp/lv number text ]

; +x = pointer to destination bg data addresses (+$c30000)
; pointer order is lv, current hp, max hp, current mp, max mp (2 bytes each, +$7e0000)

DrawCharBlock:
@0c6c:  stx     zef         ; set pointer to bg data address
        lda     #^*
        sta     zf1
        ldx     zSelCharPropPtr
        lda     a:$0008,x     ; character level
        jsr     HexToDec3
        longa
        lda     [zef]       ; get bg data address
        tax
        shorta
        jsr     DrawNum2
        ldx     zSelCharPropPtr
        lda     a:$000b,x     ; max hp
        sta     zf3
        lda     a:$000c,x
        sta     zf4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxHP
        jsr     HexToDec5
        ldy     #$0004
        jsr     DrawHPMP
        ldy     zSelCharPropPtr
        jsr     CheckMaxHP
        lda     $0009,y     ; current hp
        sta     zf3
        lda     $000a,y
        sta     zf4
        jsr     HexToDec5
        ldy     #$0002
        jsr     DrawHPMP
        jsr     CheckMPVisible
        bcc     @0cef
        ldx     zSelCharPropPtr
        lda     a:$000f,x     ; max mp
        sta     zf3
        lda     a:$0010,x
        sta     zf4
        jsr     CalcMaxHPMP
        jsr     ValidateMaxMP
        jsr     HexToDec5
        ldy     #$0008
        jsr     DrawHPMP
        ldy     zSelCharPropPtr
        jsr     CheckMaxMP
        lda     $000d,y     ; current mp
        sta     zf3
        lda     $000e,y
        sta     zf4
        jsr     HexToDec5
        ldy     #$0006
        jmp     DrawHPMP
@0cef:  ldx     #$9e8b
        stx     hWMADDL
        longa
        ldy     #$0006
        lda     [zef],y
        sec
        sbc     #$0006
        sta     $7e9e89
        shorta
        ldx     #$000c
        lda     #$ff
@0d0b:  sta     hWMDATA
        dex
        bne     @0d0b
        stz     hWMDATA
        ldy     #$9e89
        sty     ze7
        lda     #$7e
        sta     ze9
        jsr     DrawPosTextFar
        rts

; ------------------------------------------------------------------------------

; [ draw hp/mp text ]

DrawHPMP:
@0d21:  longa
        lda     [zef],y
        tax
        shorta
        jmp     DrawNum4

; ------------------------------------------------------------------------------

; [ check if character has mp ]

; carry set = has mp, carry cleared = no mp

CheckMPVisible:
@0d2b:  lda     $1a69       ; set carry and return if the party has any espers
        ora     $1a6a
        ora     $1a6b
        ora     $1a6c
        bne     @0d63
        ldx     zSelCharPropPtr
        clr_a
        lda     a:0,x     ; set carry and return if the character is gogo
        cmp     #CHAR_PROP::GOGO
        beq     @0d63
        bcs     @0d61       ; clear carry and return if the character is higher than gogo
        sta     hWRMPYA
        lda     #$36        ; get pointer to character's spell list
        sta     hWRMPYB
        nop3
        ldy     #$0036
        ldx     hRDMPYL
@0d56:  lda     $1a6e,x     ; check each spell
        cmp     #$ff
        beq     @0d63       ; set carry and return if any spells are known
        inx
        dey
        bne     @0d56
@0d61:  clc                 ; clear carry (don't show mp)
        rts
@0d63:  sec                 ; set carry (show mp)
        rts

; ------------------------------------------------------------------------------

; [ calculate max hp/mp w/ boost ]

; +$f3 = bbhhhhhh hhhhhhhh
;        b: boost
;        h: max hp/mp

CalcMaxHPMP:
@0d65:  longa
        lda     zf3
        and     #$3fff
        sta     ze7
        lda     zf3
        and     #$c000
        clc
        rol4
        tax
        lda     ze7
        jmp     (near MaxHPMPTbl,x)

; ------------------------------------------------------------------------------

; hp/mp boost jump table
MaxHPMPTbl:
@0d7e:  .addr   MaxHPMP_00
        .addr   MaxHPMP_01
        .addr   MaxHPMP_02
        .addr   MaxHPMP_03

; ------------------------------------------------------------------------------

MaxHPMP_00:
@0d86:  clr_a                             ; 0: no boost

MaxHPMP_03:
@0d87:  lsr                             ; 3: 12.5% boost

MaxHPMP_01:
@0d88:  lsr                             ; 1: 25% boost

MaxHPMP_02:
@0d89:  lsr                             ; 2: 50% boost
        clc
        adc     ze7
        sta     zf3
        shorta
        rts

; ------------------------------------------------------------------------------

; [ check max hp (9999) ]

; +$f3 = number to max out

ValidateMaxHP:
@0d92:  ldx     zf3
        cpx     #MAX_HP + 1
        bcc     @0d9e
        ldx     #MAX_HP
        stx     zf3
@0d9e:  rts

; ------------------------------------------------------------------------------

; [ check max mp (999) ]

; +$f3 = number to max out

ValidateMaxMP:
@0d9f:  ldx     zf3
        cpx     #MAX_MP + 1
        bcc     @0dab
        ldx     #MAX_MP
        stx     zf3
@0dab:  rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (item list) ]

RestoreItemCursorPos:
@0dac:  ldy     r022f
        sty     z4f
        lda     z4f
        sta     z4d
        lda     r0231
        bra     _0e1e

; ------------------------------------------------------------------------------

; [ swap two characters' saved cursor positions ]

SwapSavedCharCursorPos:
@0dba:  clr_a
        lda     z4b
        asl
        tax
        lda     zSelIndex
        asl
        tay
        longa
        lda     $0236,x     ; saved skills cursor position
        sta     ze7
        lda     $0236,y
        sta     $0236,x
        lda     ze7
        sta     $0236,y
        lda     $023e,x
        sta     ze7
        lda     $023e,y
        sta     $023e,x
        lda     ze7
        sta     $023e,y
        shorta
        clr_a
        lda     z4b
        tax
        lda     zSelIndex
        tay
        lda     $0246,x
        sta     ze0
        lda     $0246,y
        sta     $0246,x
        lda     ze0
        sta     $0246,y
        rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (skills) ]

RestoreSkillsCursorPos:
@0dff:  clr_a
        lda     zSelIndex         ; selected character slot
        asl
        tax
        ldy     $0236,x     ; saved skills cursor position
        sty     z4d
        rts

; ------------------------------------------------------------------------------

; [ restore saved cursor position (magic) ]

RestoreMagicCursorPos:
@0e0a:  clr_a
        lda     zSelIndex
        asl
        tax
        ldy     $023e,x     ; saved magic cursor position
        sty     z4f
        lda     z4f
        sta     z4d
        lda     zSelIndex
        tax
        lda     $0246,x     ; saved magic page scroll position
_0e1e:  sta     z4a
        lda     z50
        sec
        sbc     z4a
        sta     z4e
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens A & B) ]

TfrBG1ScreenAB:
@0e28:  ldy     #$0000
        sty     hVMADDL
        ldy     #near wBG1Tiles::ScreenA
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens B & C) ]

TfrBG1ScreenBC:
@0e36:  ldy     #$0400
        sty     hVMADDL
        ldy     #near wBG1Tiles::ScreenB
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg1 data to vram (screens C & D) ]

TfrBG1ScreenCD:
@0e44:  ldy     #$0800
        sty     hVMADDL
        ldy     #near wBG1Tiles::ScreenC
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (screens A & B) ]

TfrBG2ScreenAB:
@0e52:  ldy     #$1000
        sty     hVMADDL
        ldy     #near wBG2Tiles::ScreenA
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg2 data to vram (screens C & D) ]

TfrBG2ScreenCD:
@0e60:  ldy     #$1800
        sty     hVMADDL
        ldy     #near wBG2Tiles::ScreenC
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (screens A & B) ]

TfrBG3ScreenAB:
@0e6e:  ldy     #$4000
        sty     hVMADDL
        ldy     #near wBG3Tiles::ScreenA
        sty     hDMA0::ADDR
        bra     TfrBGTiles

; ------------------------------------------------------------------------------

; [ copy bg3 data to vram (screens C & D) ]

TfrBG3ScreenCD:
@0e7c:  ldy     #$4800
        sty     hVMADDL
        ldy     #near wBG3Tiles::ScreenC
        sty     hDMA0::ADDR
; fall through

; copy bg data to vram, must already be in vblank
TfrBGTiles:
@0e88:  lda     #$01        ; two address - low, high
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        lda     #$7e
        sta     hDMA0::ADDR_B
        ldy     #$1000      ; dma size (two screens)
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ play cursor sound effect (move) ]

PlayMoveSfx:
@0ea3:  lda     zae         ; return if sound effect is already being played this frame
        cmp     #$21
        beq     _0eb1
; fall through

; ------------------------------------------------------------------------------

; [ play cursor sound effect (cancel) ]

PlayCancelSfx:
@0ea9:  lda     #$21
        sta     zae
        sta     f:hAPUIO0
_0eb1:  rts

; ------------------------------------------------------------------------------

; [ play cursor sound effect (select) ]

PlaySelectSfx:
@0eb2:  lda     #$20
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play success sound effect ]

PlaySuccessSfx:
@0eb9:  lda     #$23
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play invalid sound effect ]

PlayInvalidSfx:
@0ec0:  lda     #$22
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play delete/erase sound effect ]

PlayEraseSfx:
@0ec7:  lda     #$24
        sta     f:hAPUIO0
        rts

; ------------------------------------------------------------------------------

; [ play cash register sound effect ]

PlayShopSfx:
@0ece:  lda     #SFX::CASH_REGISTER
; fallthrough

PlayGameSfx:
        sta     f:$001301
        lda     #$18
        sta     f:$001300
        lda     #$80
        sta     f:$001302
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ play cure/item sound effect ]

PlayCureSfx:
@0ee5:  lda     #SFX::MENU_CURE
        bra     PlayGameSfx

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screens A & B) ]

; NOTE: Unlike TfrBGTiles, these routines do not need to be called during vblank

InitDMA1BG1ScreenAB:
@0ee9:  ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenA
        sta     zDMA1Src_B
        ldy     #$1000
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screen A) ]

InitDMA1BG1ScreenA:
@0efd:  ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenA
        sta     zDMA1Src_B
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg1 data, screen B) ]

InitDMA1BG1ScreenB:
@0f11:  ldy     #$0400
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenB
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenB
        sta     zDMA1Src_B
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screens A & B) ]

InitDMA1BG3ScreenAB:
@0f25:  ldy     #$4000
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA1Src_B
        ldy     #$1000
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screen A) ]

InitDMA1BG3ScreenA:
@0f39:  ldy     #$4000
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA1Src_B
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 1 (bg3 data, screen B) ]

InitDMA1BG3ScreenB:
@0f4d:  ldy     #$4400
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenB
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenB
        sta     zDMA1Src_B
        ldy     #$0800
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 2 (bg3 data, screen A) ]

InitDMA2BG3ScreenA:
@0f61:  ldy     #$4000
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA2Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA2Src_B
        ldy     #$0800
        sty     zDMA2Size
        rts

; ------------------------------------------------------------------------------

; [ init dma 2 (bg3 data, screen B) ]

InitDMA2BG3ScreenB:
@0f75:  ldy     #$4400
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenB
        sty     zDMA2Src
        lda     #^wBG3Tiles::ScreenB
        sta     zDMA2Src_B
        ldy     #$0800
        sty     zDMA2Size
        rts

; ------------------------------------------------------------------------------

; [ disable dma 2 ]

DisableDMA2:
@0f89:  stz     zDMA2Dest
        stz     zDMA2Dest+1
        rts

; ------------------------------------------------------------------------------

; [ load color palette ]

;  A: source bank
; +X: source address
; +Y: destination address (+$7e0000)

LoadPal:
@0f8e:  sta     zed
        sty     ze7
        stx     zeb
        lda     #$7e
        sta     ze9
        ldy     zZero
        longa
@0f9c:  lda     [zeb],y
        sta     [ze7],y
        iny2
        cpy     #$0020
        bne     @0f9c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create fade in/out palette task ]

;   A: speed (frames per update)
;  +X: source address
;  +Y: destination address (+$7e0000)
; $ed: source bank

CreateFadePalTask:
@0faa:  pha
        sty     ze7
        stx     zeb
        lda     #$7e
        sta     ze9
        lda     #0
        ldy     #near FadePalTask
        jsr     CreateTask
        pla
        sta     wTaskProp::w7e37c9_H,x
        lda     ze9
        sta     wTaskProp::w7e36c9,x
        lda     zed
        sta     wTaskProp::AnimCounter,x
        longa
        lda     ze7
        sta     wTaskProp::PosX,x
        lda     zeb
        sta     wTaskProp::PosY,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ fade in/out palette task ]

; +$3349 = color counter
; +$33c9 = destination address (+$7e0000) wTaskProp::PosX
; +$3449 = source address wTaskProp::PosY
;  $35c9 = frame counter
;  $36c9 = destination bank (always $7e)
;  $36ca = source bank
;  $37ca = speed (frames per update)

FadePalTask:
@0fdd:  tax
        jmp     (near FadePalTaskTbl,x)

FadePalTaskTbl:
@0fe1:  .addr   FadePalTask_00
        .addr   FadePalTask_01

; ------------------------------------------------------------------------------

; state 0: init
FadePalTask_00:
@0fe5:  ldx     zTaskOffset
        lda     #$1f
        sta     near wTaskProp::w7e3349,x                 ; set color counter to 31
        lda     zZero
        sta     near wTaskProp::w7e3349_H,x
        inc     near wTaskProp::State,x                 ; increment task state
        sec
        rts

; ------------------------------------------------------------------------------

; state 1: update
FadePalTask_01:
@0ff6:  ldx     zTaskOffset
        lda     near wTaskProp::w7e35c9,x                 ; branch if waiting for frame counter
        bne     @1032
        lda     near wTaskProp::w7e37c9_H,x                 ; set frame counter
        sta     near wTaskProp::w7e35c9,x
        lda     near wTaskProp::w7e36c9,x                 ; +$e0 = destination address
        sta     ze2
        lda     near wTaskProp::AnimCounter,x                 ; +$e3 = source address
        sta     ze5
        longa
        lda     near wTaskProp::PosX,x
        sta     ze0
        lda     near wTaskProp::PosY,x
        sta     ze3
        lda     near wTaskProp::w7e3349,x                 ; $f1 = color counter value
        sta     zf1
        jsr     UpdateFadePal
        shorta
        ldx     a:zTaskOffset
        lda     near wTaskProp::w7e3349,x                 ; decrement color counter
        beq     @1030
        dec     near wTaskProp::w7e3349,x
        bne     @1032                   ; terminate task when color counter reaches zero
@1030:  clc
        rts
@1032:  dec     near wTaskProp::w7e35c9,x                 ; decrement frame counter
        sec
        rts

; ------------------------------------------------------------------------------

; [ update palette ]

.a16

UpdateFadePal:
@1037:  ldx     #16                     ; 16 colors
        ldy     zZero
@103c:  lda     [ze0],y                 ; $e7 = current color value (destination)
        sta     ze7
        lda     [ze3],y                 ; $e9 = target color value (source)
        sta     ze9
        jsr     UpdateFadeColor
        lda     ze7
        sta     [ze0],y                 ; set current color value
        iny2                            ; next color
        dex
        bne     @103c
        rts

; ------------------------------------------------------------------------------

; [ update color ]

UpdateFadeColor:
@1051:  lda     ze7                     ; current color
        and     #$001f                  ; isolate red
        sta     zeb
        lda     ze9                     ; target color
        and     #$001f                  ; isolate red
        sec
        sbc     zeb                     ; subtract current red
        beq     @106e                   ; branch if zero
        bcc     @106c                   ; branch if negative
        cmp     zf1
        bcc     @106e                   ; branch if less than color counter
        inc     zeb                     ; increment current red
        bra     @106e
@106c:  dec     zeb                     ; decrement current red
@106e:  lda     ze7
        and     #$03e0                  ; isolate green
        sta     zed
        lda     ze9
        and     #$03e0
        sec
        sbc     zed
        beq     @109b
        bcc     @1093
        asl3
        xba
        cmp     zf1
        bcc     @109b
        clc
        lda     zed
        adc     #$0020
        sta     zed
        bra     @109b
@1093:  lda     zed
        sec
        sbc     #$0020
        sta     zed
@109b:  lda     ze7
        and     #$7c00                  ; isolate blue
        sta     zef
        lda     ze9
        and     #$7c00
        sec
        sbc     zef
        beq     @10cb
        bcc     @10c3
        shorta
        xba
        lsr2
        longa
        cmp     zf1
        bcc     @10cb
        clc
        lda     zef
        adc     #$0400
        sta     zef
        bra     @10cb
@10c3:  lda     zef
        sec
        sbc     #$0400
        sta     zef
@10cb:  lda     zeb                     ; combine red, green, and blue
        ora     zed
        ora     zef
        sta     ze7                     ; set current color
        rts

.a8

; ------------------------------------------------------------------------------

; white color palette
WhitePal:
@10d4:  .word   $0000,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff
        .word   $7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff,$7fff

; black color palette
BlackPal:
@10f4:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ reset tasks ]

ResetTasks:
@1114:  ldx     zZero
        stx     zTaskOffset
        stx     zNumTasks
        longa
        jsr     ResetSprites
        shorti
        ldx     #$7e
        phx
        plb
        ldx     #0
@1127:  stz     near wTaskProp::CodePtr,x                 ; clear task data
        stz     near wTaskProp::State,x
        stz     near wTaskProp::w7e35c9,x
        stz     near wTaskProp::Pal,x
        stz     near wTaskProp::PosX,x
        stz     near wTaskProp::PosY,x
        stz     near wTaskProp::SpeedX,x
        stz     near wTaskProp::SpeedY,x
        inx2
        cpx     #$80
        bne     @1127
        ldx     #$00
        phx
        plb
        shorta
        longi
        rts

; ------------------------------------------------------------------------------

; [ clear sprite data ]

.a16

ResetSprites:
@114e:  ldx     zZero
@1150:  lda     #$e001
        sta     rSprites,x                 ; move all sprites offscreen
        inx2
        lda     #$0001
        sta     rSprites,x
        inx2
        cpx     #$0200
        bne     @1150
        ldy     zZero                      ; clear high sprite data
        tya
@1168:  sta     rSpritesHi,y
        iny2
        cpy     #$0020
        bne     @1168
        rts

.a8

; ------------------------------------------------------------------------------

; [ create task ]

; A: priority
; Y: address

CreateTask:
@1173:  tax
        lda     #$7e
        pha
        plb
        txa
        jsr     InitTask
        shorta
        lda     #$00
        pha
        plb
        lda     zTaskOffset
        sta     wTaskProp::w7e374a,x               ; set task data pointer
        inc     zNumTasks
        rts

; ------------------------------------------------------------------------------

; [ init task code pointer ]

; A: priority

InitTask:
@118b:  xba
        lda     #$00
        xba
        asl4
        longa
        tax
@1196:  lda     near wTaskProp::CodePtr,x                 ; find the first available task in this priority level
        bne     @11a0
        tya
        sta     near wTaskProp::CodePtr,x                 ; set task code pointer
        rts
@11a0:  inx2
        cpx     #$0080
        bne     @1196
        dex2                            ; no empty task found, use the second to last one
        tya
        sta     near wTaskProp::CodePtr,x                 ; set task data pointer
@11ad:  bra     @11ad                   ; infinite loop
        rts

.a8

; ------------------------------------------------------------------------------

; [ execute tasks ]

ExecTasks:
@11b0:  phb
        lda     #$7e
        pha
        plb
        ldx     #rSprites               ; set starting pointers to sprite data
        stx     zSpritePtr
        ldx     #rSpritesHi
        stx     zSpriteHiPtr
        lda     #$03                    ; initial mask for hi-sprite data
        sta     zSpriteHiCounter
        stz     zSpriteHiVal
        ldx     #128                    ; start with 128 unused sprites
        stx     zNumUnusedSprites
        ldx     zZero
        longa
@11ce:  lda     near wTaskProp::CodePtr,x     ; task code pointer
        beq     @11f5                   ; branch if task is not active
        stx     zTaskOffset
        phx
        sta     zTaskCodePtr
        shorta
        clr_a
        lda     near wTaskProp::State,x                 ; task state
        asl
        jsr     @1203                   ; execute task
        longa
        plx
        bcs     @11f5                   ; branch if task didn't terminate
        stz     near wTaskProp::CodePtr,x                 ; clear task data
        stz     near wTaskProp::State,x
        stz     near wTaskProp::w7e35c9,x
        stz     near wTaskProp::Pal,x
        dec     zNumTasks
@11f5:  inx2                            ; next task
        cpx     #$0080
        bne     @11ce
        jsr     HideUnusedSprites
        shorta
        plb
        rts

; execute task (carry clear: terminate, carry set: don't terminate)
@1203:  jmp     (zTaskCodePtr)

; ------------------------------------------------------------------------------

; [ init animation task ]

InitAnimTask:
@1206:  clr_a
        sta     near wTaskProp::w7e36c9,x
        longa
        lda     near wTaskProp::AnimPtr,x
        sta     zeb
        shorta
        lda     near wTaskProp::AnimBank,x
        sta     zed
        ldy     #2
        lda     [zeb],y
        sta     near wTaskProp::AnimCounter,x
        rts

; ------------------------------------------------------------------------------

; [ update animation task ]

UpdateAnimTask:
@1221:  jsr     UpdateAnimData
        jmp     UpdateAnimSprites

; ------------------------------------------------------------------------------

; [ update animation data ]

UpdateAnimData:
@1227:  ldx     zTaskOffset
        ldy     zZero
        longa
        lda     near wTaskProp::AnimPtr,x     ; ++$eb = animation data pointer
        sta     zeb
        shorta
        lda     near wTaskProp::AnimBank,x
        sta     zed
@1239:  lda     near wTaskProp::AnimCounter,x     ; next animation data byte
        cmp     #$fe
        beq     @1262                   ; return if $fe (stop animation)
        cmp     #$ff
        bne     @124c                   ; branch if not $ff (repeat)
        stz     near wTaskProp::w7e36c9,x          ; reset animation data offset
        jsr     SetAnimDur
        bra     @1239
@124c:  lda     near wTaskProp::AnimCounter,x     ; frame counter
        bne     @125f                   ; decrement and return if not zero
        lda     near wTaskProp::w7e36c9,x          ; increment animation data offset
        clc
        adc     #3
        sta     near wTaskProp::w7e36c9,x
        jsr     SetAnimDur
        bra     @1239
@125f:  dec     near wTaskProp::AnimCounter,x     ; decrement frame counter
@1262:  rts

; ------------------------------------------------------------------------------

; [ set animation frame counter ]

SetAnimDur:
@1263:  shorti
        lda     near wTaskProp::w7e36c9,x          ; animation data offset + 2
        tay
        iny2
        lda     [zeb],y
        sta     near wTaskProp::AnimCounter,x     ; set frame counter
        longi
        rts

; ------------------------------------------------------------------------------

; [ update animation sprites ]

UpdateAnimSprites:
@1273:  shorti
        lda     near wTaskProp::w7e36c9,x          ; animation data offset
        tay
        longa
        lda     [zeb],y                 ; ++$e7 = pointer to sprite data
        sta     ze7
        iny2
        shorta
        lda     near wTaskProp::AnimBank,x
        sta     ze9
        longi
        ldy     zZero
        lda     zNumUnusedSprites       ; return if there are no sprites remaining
        beq     @12fb
        lda     [ze7],y
        sta     ze6                     ; $e6 = number of sprites
        beq     @12fb                   ; return if there are no sprites
        iny
@1297:  lda     [ze7],y                 ; $e0 = x position
        sta     ze0
        bpl     @12b0                   ; branch if not a 32x32 sprite
        clr_a
        lda     zSpriteHiCounter
        tax
        lda     f:LargeSpriteTbl,x      ; high sprite mask
        clc
        adc     zSpriteHiVal            ; should probably be ora instead
        sta     zSpriteHiVal
        sta     (zSpriteHiPtr)          ; set sprite high data
        ldx     zTaskOffset
        bra     @12b4
@12b0:  lda     zSpriteHiVal
        sta     (zSpriteHiPtr)          ; set sprite high data
@12b4:  lda     ze0
        and     #$7f
        sta     ze0
        lda     near wTaskProp::Flags,x
        bit     #$01
        beq     @12ce
        stz     ze1
        longa
        lda     ze0
        sec
        sbc     zBG1HScroll
        sta     ze0
        shorta
@12ce:  jsr     DrawAnimSprite
        dec     zSpriteHiCounter        ; decrement pointer to high sprite data masks
        bpl     @12df                   ; branch if positive
        lda     #3                      ; reset to 3
        sta     zSpriteHiCounter
        stz     zSpriteHiVal            ; clear current high sprite data byte
        longa
        inc     zSpriteHiPtr            ; increment pointer to high sprite data
@12df:  longa
        lda     ze0
        sta     (zSpritePtr)            ; set sprite data (position)
        inc     zSpritePtr
        inc     zSpritePtr
        lda     ze2
        sta     (zSpritePtr)            ; set sprite data (other bytes)
        inc     zSpritePtr
        inc     zSpritePtr
        shorta
        dec     zNumUnusedSprites       ; decrement number of unused sprites
        beq     @12fb
        dec     ze6                     ; next sprite
        bne     @1297
@12fb:  rts

; ------------------------------------------------------------------------------

; [ update animation sprite data ]

DrawAnimSprite:
@12fc:  lda     ze0                     ; $e0 = x position
        clc
        adc     near wTaskProp::PosX_H,x                 ; add horizontal offset
        sta     ze0
        iny
        lda     [ze7],y                 ; $e1 = y position
        clc
        adc     near wTaskProp::PosY_H,x                 ; add vertical offset
        sta     ze1
        iny
        lda     [ze7],y                 ; $e2 = graphics offset
        sta     ze2
        iny
        lda     near wTaskProp::Flags,x                 ; branch if not flipped horizontal
        bit     #$02
        beq     @1320
        lda     [ze7],y
        ora     #$40
        bra     @1322
@1320:  lda     [ze7],y
@1322:  sta     ze3                     ; $e3 = vhoopppm
        lda     near wTaskProp::Pal,x                 ; special palette
        beq     @1332
        lda     ze3
        and     #%11110001
        ora     near wTaskProp::Pal,x
        sta     ze3
@1332:  iny
        rts

; ------------------------------------------------------------------------------

; large sprite flags for high sprite data
LargeSpriteTbl:
@1334:  .byte   $80,$20,$08,$02

; ------------------------------------------------------------------------------

; [ hide unused sprites ]

.proc HideUnusedSprites
        .a16
        ldy     zNumUnusedSprites
        beq     Done
        ldx     #$01fc
        lda     #$e001
:       sta     rSprites,x
        dex4
        dey
        bne     :-
Done:   rts
        .a8
.endproc  ; HideUnusedSprites

; ------------------------------------------------------------------------------

; [ wait for next frame ]

.proc WaitFrame
        jsr     WaitVblank
        lda     z46                     ; branch if not scrolling text
        bit     #$20
        beq     :+
        jsr     UpdateTextScroll
:       jsl     UpdateCtrlMenu
        lda     zWaitCounter
        beq     Done                    ; return if not waiting for menu state counter
        clr_ay
        sty     zNewCtrlState           ; clear controller buttons
        sty     zRepCtrlState
Done:   rts
.endproc  ; WaitFrame

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVblank:
@1368:  lda     #$81                    ; enable interrupts
        sta     hNMITIMEN
        sta     zInterruptEnable
        cli
@1370:  lda     zInterruptEnable
        bne     @1370
        sei                             ; disable interrupts
        lda     zScreenBrightness
        sta     hINIDISP
        lda     zEnableHDMA
        sta     hHDMAEN
        lda     zMosaic
        sta     hMOSAIC
        stz     zae                     ; clear current sound effect
        rts

; ------------------------------------------------------------------------------

; [ menu nmi ]

MenuNMI:
@1387:  php
        longai
        pha
        phx
        phy
        phb
        phd
        shorta
        lda     hRDNMI
        lda     #$00
        pha
        plb
        ldx     #$0000
        phx
        pld
        lda     zInterruptEnable
        beq     @13b1
        jsr     UpdatePPU
        longa
        inc     zcf                     ; increment frame counter
        shorta
        ldy     zWaitCounter                     ; decrement menu state frame counter
        beq     @13b1
        dey
        sty     zWaitCounter
@13b1:  jsl     DecTimersMenuBattle_ext
        jsl     IncGameTime
        inc     zFrameCounter
        clr_a
        sta     zInterruptEnable
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti

.a8

; ------------------------------------------------------------------------------

; [ menu irq ]

MenuIRQ:
@13c7:  rti

; ------------------------------------------------------------------------------

; [ increment game time ]

IncGameTime:
@13c8:  lda     rGameTimeFrames
        cmp     #60
        beq     @13d1
        bra     @13fc
@13d1:  stz     rGameTimeFrames
        lda     rGameTimeSeconds
        cmp     #59
        beq     @13e0
        inc     rGameTimeSeconds
        bra     @13fc
@13e0:  stz     rGameTimeSeconds
        lda     rGameTimeMinutes
        cmp     #59
        beq     @13ef
        inc     rGameTimeMinutes
        bra     @13fc
@13ef:  stz     rGameTimeMinutes
        lda     rGameTimeHours
        cmp     #99
        beq     @13fc
        inc     rGameTimeHours
@13fc:  lda     rGameTimeHours
        cmp     #99
        bne     @140d
        lda     rGameTimeMinutes
        cmp     #59
        bne     @140d
        stz     rGameTimeSeconds
@140d:  inc     rGameTimeFrames
        clr_a
        rtl

; ------------------------------------------------------------------------------

; [ update ppu registers and transfer data to vram ]

UpdatePPU:

; disable DMA
@1412:  stz     hHDMAEN
        stz     hMDMAEN

; set bg scrolling registers
        lda     zBG1HScroll
        sta     hBG1HOFS
        lda     zBG1HScroll+1
        sta     hBG1HOFS
        lda     zBG1VScroll
        sta     hBG1VOFS
        lda     zBG1VScroll+1
        sta     hBG1VOFS
        lda     zBG2HScroll
        sta     hBG2HOFS
        lda     zBG2HScroll+1
        sta     hBG2HOFS
        lda     zBG2VScroll
        sta     hBG2VOFS
        lda     zBG2VScroll+1
        sta     hBG2VOFS
        lda     zBG3HScroll
        sta     hBG3HOFS
        lda     zBG3HScroll+1
        sta     hBG3HOFS
        lda     zBG3VScroll
        sta     hBG3VOFS
        lda     zBG3VScroll+1
        sta     hBG3VOFS
        jsr     UpdateMode7Regs
        jsr     TfrSprites
        jsr     TfrPal
        jsr     TfrVRAM1
        jmp     TfrVRAM2

; ------------------------------------------------------------------------------

; [ copy sprite data to ppu ]

TfrSprites:
@1463:  ldx     zZero          ; clear oam address
        stx     hOAMADDL
        txa
        sta     hDMA0::ADDR_B
        lda     #$02
        sta     hDMA0::CTRL
        lda     #<hOAMDATA
        sta     hDMA0::HREG
        ldy     #rSprites
        sty     hDMA0::ADDR
        ldy     #$0220
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram 1 ]

TfrVRAM1:
@1488:  ldy     zDMA1Dest
        sty     hVMADDL
        lda     #$01
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldy     zDMA1Src
        sty     hDMA0::ADDR
        lda     zDMA1Src_B
        sta     hDMA0::ADDR_B
        ldy     zDMA1Size
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram 2 ]

TfrVRAM2:
@14ac:  ldy     zDMA2Dest
        beq     @14d1
        sty     hVMADDL
        lda     #$01
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldy     zDMA2Src
        sty     hDMA0::ADDR
        lda     zDMA2Src_B
        sta     hDMA0::ADDR_B
        ldy     zDMA2Size
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
@14d1:  rts

; ------------------------------------------------------------------------------

; [ copy color palettes to ppu ]

TfrPal:
@14d2:  lda     z45
        bit     #$01
        beq     @14fd
        lda     zZero
        sta     hCGADD
        lda     #$02
        sta     hDMA0::CTRL
        lda     #<hCGDATA
        sta     hDMA0::HREG
        ldy     #near wPalBuf
        sty     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        ldy     #$0200
        sty     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
@14fd:  rts

; ------------------------------------------------------------------------------
