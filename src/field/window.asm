
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: window.asm                                                           |
; |                                                                            |
; | description: dialogue window routines                                      |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import WindowGfx

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ copy dialog window graphics to vram ]

.proc TfrWindowGfx
        lda     #$80
        sta     hVMAINC                 ; destination = $2e00 (vram)
        ldx     #$2e00
        stx     hVMADDL
        ldy     #28                     ; 28 tiles total
        lda     $0565                   ; wallpaper index
        asl
        tax
        longa
        lda     f:DlgWindowGfxPtrs,x
        tax
:       .repeat 8, i
        lda     f:WindowGfx+i*2,x       ; first 8 bytes of tile
        sta     hVMDATAL
        .endrep
        .repeat 8, i
        lda     f:WindowGfx+16+i*2,x    ; set the top bit of bitplane 3
        ora     #$ff00
        sta     hVMDATAL
        .endrep
        txa
        clc
        adc     #$0020                  ; next tile
        tax
        dey
        jne     :-
        shorta0
        rts

; pointers to wallpaper graphics (+$ed0000)
DlgWindowGfxPtrs:
        .repeat 8, i
        .word   i*$0380
        .endrep
.endproc

; ------------------------------------------------------------------------------

; [ open map name dialog window ]

.proc OpenMapTitleWindow
        lda     #$7e
        pha
        plb
        longa
        lda     $7bfa       ; save hdma tables
        sta     $7ed1
        lda     $7bfd
        sta     $7ed4
        lda     $7c00
        sta     $7ed7
        lda     $7c03
        sta     $7eda
        lda     $7cb0
        sta     $7f85
        lda     $7cb3
        sta     $7f88
        lda     $7cb6
        sta     $7f8b
        lda     $7cb9
        sta     $7f8e
        lda     $7d66
        sta     $8039
        lda     $7d69
        sta     $803c
        lda     $7d6c
        sta     $803f
        lda     $7d6f
        sta     $8042
        lda     $7e1c
        sta     $80ed
        lda     $7e1f
        sta     $80f0
        lda     $7e22
        sta     $80f3
        lda     $7e25
        sta     $80f6
        lda     $7b9f
        sta     $7e77
        lda     $7ba2
        sta     $7e7a
        lda     $7ba5
        sta     $7e7d
        lda     $7ba8
        sta     $7e80
        lda     $7d0b
        sta     $7fdf
        lda     $7d0e
        sta     $7fe2
        lda     $7d11
        sta     $7fe5
        lda     $7d14
        sta     $7fe8
        lda     $7dc1
        sta     $8093
        lda     $7dc4
        sta     $8096
        lda     $7dc7
        sta     $8099
        lda     $7dca
        sta     $809c
        lda     #$8533      ; set bg1 scroll hdma data
        sta     $7bfa
        sta     $7bfd
        sta     $7c00
        lda     #$8553
        sta     $7c03
        lda     #$8573      ; set bg3 scroll hdma data
        sta     $7cb0
        lda     #$8583
        sta     $7cb3
        lda     #$8593
        sta     $7cb6
        lda     #$85a3
        sta     $7cb9
        lda     #$8ca3      ; set window 2 hdma data
        sta     $7d66
        lda     #$8ca3
        sta     $7d69
        lda     #$8ca3
        sta     $7d6c
        lda     #$8ca3
        sta     $7d6f
        lda     #$8bd3      ; set color add/sub settings hdma data
        sta     $7e1c
        lda     #$8be3
        sta     $7e1f
        lda     #$8bf3
        sta     $7e22
        lda     #$8c03
        sta     $7e25
        lda     #$81b3      ; set mosaic/bg location hdma data
        sta     $7b9f
        sta     $7ba2
        sta     $7ba5
        sta     $7ba8
        lda     #$8a43      ; set fixed color add/sub hdma data
        sta     $7d0b
        lda     #$8a53
        sta     $7d0e
        lda     #$8a63
        sta     $7d11
        lda     #$8a73
        sta     $7d14
        lda     #$8183      ; set main/sub screen designation hdma data
        sta     $7dc1
        sta     $7dc4
        sta     $7dc7
        sta     $7dca
        shorta0
        tdc
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ close map name dialog window ]

.proc CloseMapTitleWindow
        lda     $0745       ; return if map name dialog window is not open
        beq     Done
        lda     #$7e
        pha
        plb
        ldx     $00
        longa
:       lda     $7ed1,x     ; restore hdma tables
        sta     $7bfa,x
        lda     $7f85,x
        sta     $7cb0,x
        lda     $8039,x
        sta     $7d66,x
        lda     $80ed,x
        sta     $7e1c,x
        lda     $7e77,x
        sta     $7b9f,x
        lda     $7fdf,x
        sta     $7d0b,x
        lda     $8093,x
        sta     $7dc1,x
        inx3
        cpx     #12
        bne     :-
        shorta0
        tdc
        pha
        plb
        stz     $0745       ; map name dialog window closed
        stz     $0567       ; clear map name dialog counter
        stz     $0568       ; clear dialog flags
        lda     #$09        ; dialog region = 9
        sta     $cc
Done:   rts
.endproc

; ------------------------------------------------------------------------------

; [ unused ]

.proc _c03040
        lda     #$7e
        pha
        plb
        lda     $bc
        asl
        clc
        adc     $bc
        tax
        ldy     #8
        longa
:       lda     $7b9c,x
        sta     $7e74,x
        lda     $7bf7,x
        sta     $7ece,x
        lda     $7cad,x
        sta     $7f82,x
        lda     $7d63,x
        sta     $8036,x
        lda     $7d08,x
        sta     $7fdc,x
        lda     $7e19,x
        sta     $80ea,x
        inx3
        dey
        bne     :-
        shorta0
        tdc
        pha
        plb
        rts
.endproc

; ------------------------------------------------------------------------------

; [ update dialog window ]

.proc UpdateDlgWindow
        lda     $ba
        bne     :+
Done:   rts
:       lda     $bc
        asl
        clc
        adc     $bc
        tax
        lda     $ba
        jmi     UpdateClose
        lda     $bb
        cmp     #$05
        beq     Done
        asl
        sta     $1a
        asl3
        clc
        adc     $1a
        tay
        lda     $0564
        jne     UpdateOpenText

; open dialog window
UpdateOpen:
        lda     #^*
        pha
        plb
        longa
        lda     #9
        sta     $1e
Loop1:  lda     DlgOpenMaskTbl,y
        beq     :+
        lda     $7e7bf7,x
        sta     $7e7ece,x
        lda     $7e7cad,x
        sta     $7e7f82,x
        lda     $7e7d63,x
        sta     $7e8036,x
        lda     $7e7e19,x
        sta     $7e80ea,x
        lda     $7e7b9c,x
        sta     $7e7e74,x
        lda     $7e7d08,x
        sta     $7e7fdc,x
        lda     $7e7dbe,x
        sta     $7e8090,x
:       lda     DlgOpenBG1ScrollTbl,y
        beq     :+
        sta     $7e7bf7,x
        lda     DlgOpenBG3ScrollTbl,y
        sta     $7e7cad,x
        lda     DlgOpenWindowPosTbl,y
        sta     $7e7d63,x
        lda     DlgOpenColorMathTbl,y
        sta     $7e7e19,x
        lda     DlgOpenBGLocTbl,y
        sta     $7e7b9c,x
        lda     DlgOpenFixedColorTbl,y
        sta     $7e7d08,x
        lda     DlgOpenMainSubTbl,y
        sta     $7e7dbe,x
:       iny2
        inx3
        dec     $1e
        bne     Loop1
        shorta0
        inc     $bb
        tdc
        pha
        plb
        rts

; open dialog window (text only)
UpdateOpenText:
        lda     #^*
        pha
        plb
        longa
        lda     #9
        sta     $1e
Loop2:  lda     DlgOpenMaskTbl,y
        beq     :+
        lda     $7e7cad,x
        sta     $7e7f82,x
        lda     $7e7d63,x
        sta     $7e8036,x
        lda     $7e7b9c,x
        sta     $7e7e74,x
        lda     $7e7e19,x
        sta     $7e80ea,x
        lda     $7e7dbe,x
        sta     $7e8090,x
:       lda     DlgOpenBG3ScrollTbl,y
        beq     :+
        sta     $7e7cad,x
        lda     DlgOpenWindowPosTbl,y
        sta     $7e7d63,x
        lda     DlgTextOpenBGLocTbl,y
        sta     $7e7b9c,x
        lda     f:$001ed8               ; check for fade bars (ending)
        and     #$0001
        bne     EndingFadeBars
        lda     #$8c73
        sta     $7e7e19,x
        lda     DlgTextOpenMainSubTbl,y
        sta     $7e7dbe,x
        bra     :+

EndingFadeBars:
        lda     #$81a3
        sta     $7e7dbe,x
:       iny2
        inx3
        dec     $1e
        bne     Loop2
        shorta0
        inc     $bb
        tdc
        pha
        plb
        rts

; close dialog window
UpdateClose:
        lda     $bb
        jeq     WindowClosed
        dec     $bb
        lda     $bb
        asl
        sta     $1a
        asl3
        clc
        adc     $1a
        tay
        lda     $0564
        jne     UpdateCloseText
        lda     #^*
        pha
        plb
        longa
        lda     #9
        sta     $1e
Loop3:  lda     DlgOpenMaskTbl,y
        beq     :+
        lda     $7e7ece,x
        sta     $7e7bf7,x
        lda     $7e7f82,x
        sta     $7e7cad,x
        lda     $7e8036,x
        sta     $7e7d63,x
        lda     $7e80ea,x
        sta     $7e7e19,x
        lda     $7e7e74,x
        sta     $7e7b9c,x
        lda     $7e7fdc,x
        sta     $7e7d08,x
        lda     $7e8090,x
        sta     $7e7dbe,x
:       iny2
        inx3
        dec     $1e
        bne     Loop3
        shorta0
        tdc
        pha
        plb
        rts

; close dialog window (text only)
UpdateCloseText:
        lda     #^*
        pha
        plb
        longa
        lda     #9
        sta     $1e
Loop4:  lda     DlgOpenMaskTbl,y
        beq     :+
        lda     $7e7f82,x
        sta     $7e7cad,x
        lda     $7e8036,x
        sta     $7e7d63,x
        lda     $7e7e74,x
        sta     $7e7b9c,x
        lda     $7e80ea,x
        sta     $7e7e19,x
        lda     $7e8090,x
        sta     $7e7dbe,x
:       iny2
        inx3
        dec     $1e
        bne     Loop4
        shorta0
        tdc
        pha
        plb
        rts

WindowClosed:
        stz     $ba
        rts

; dialog window strips added/removed each frame
DlgOpenMaskTbl:
        .word   0,0,0,0,1,0,0,0,0
        .word   0,0,0,1,0,1,0,0,0
        .word   0,0,1,0,0,0,1,0,0
        .word   0,1,0,0,0,0,0,1,0
        .word   1,0,0,0,0,0,0,0,1

; hdma pointers for bg1 scroll (hdma #4)
DlgOpenBG1ScrollTbl:
        .word   $0000,$0000,$0000,$0000,$8513,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$84b3,$84d3,$84f3,$0000,$0000,$0000
        .word   $0000,$0000,$8413,$8433,$8453,$8473,$8493,$0000,$0000
        .word   $0000,$8333,$8353,$8373,$8393,$83b3,$83d3,$83f3,$0000
        .word   $8313,$8313,$8313,$8313,$8313,$8313,$8313,$8313,$8313

; hdma pointers for bg3 scroll (hdma #3)
DlgOpenBG3ScrollTbl:
        .word   $0000,$0000,$0000,$0000,$85f3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$85f3,$85f3,$85f3,$0000,$0000,$0000
        .word   $0000,$0000,$85f3,$85f3,$85f3,$85f3,$85f3,$0000,$0000
        .word   $0000,$85f3,$85f3,$85f3,$85f3,$85f3,$85f3,$85f3,$0000
        .word   $85f3,$8613,$8633,$8653,$8673,$8693,$86b3,$86d3,$86f3

; hdma pointers for window 2 position (hdma #5)
DlgOpenWindowPosTbl:
        .word   $0000,$0000,$0000,$0000,$8ca3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8ca3,$8ca3,$8ca3,$0000,$0000,$0000
        .word   $0000,$0000,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$0000,$0000
        .word   $0000,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$0000
        .word   $8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3

; hdma pointers for color add/sub settings (hdma #1)
DlgOpenColorMathTbl:
        .word   $0000,$0000,$0000,$0000,$8c53,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8c23,$8c33,$8c43,$0000,$0000,$0000
        .word   $0000,$0000,$8bd3,$8be3,$8bf3,$8c03,$8c13,$0000,$0000
        .word   $0000,$8b63,$8b73,$8b83,$8b93,$8ba3,$8bb3,$8bc3,$0000
        .word   $8ad3,$8ae3,$8af3,$8b03,$8b13,$8b23,$8b33,$8b43,$8b53

; hdma pointers for mosaic/bg location (hdma #7)
DlgOpenBGLocTbl:
        .word   $0000,$0000,$0000,$0000,$81b3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$81b3,$81b3,$81b3,$0000,$0000,$0000
        .word   $0000,$0000,$81b3,$81b3,$81b3,$81b3,$81b3,$0000,$0000
        .word   $0000,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$0000
        .word   $81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3

; hdma pointers for mosaic/bg location (hdma #7) text only
DlgTextOpenBGLocTbl:
        .word   $0000,$0000,$0000,$0000,$81d3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$81d3,$81d3,$81d3,$0000,$0000,$0000
        .word   $0000,$0000,$81d3,$81d3,$81d3,$81d3,$81d3,$0000,$0000
        .word   $0000,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$0000
        .word   $81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3

; hdma pointers for fixed color add/sub (hdma #2)
DlgOpenFixedColorTbl:
        .word   $0000,$0000,$0000,$0000,$8ac3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8a93,$8aa3,$8ab3,$0000,$0000,$0000
        .word   $0000,$0000,$8a43,$8a53,$8a63,$8a73,$8a83,$0000,$0000
        .word   $0000,$89d3,$89e3,$89f3,$8a03,$8a13,$8a23,$8a33,$0000
        .word   $8943,$8953,$8963,$8973,$8983,$8993,$89a3,$89b3,$89c3

; hdma pointers for main/sub screen designation (hdma #6)
DlgOpenMainSubTbl:
        .word   $0000,$0000,$0000,$0000,$8183,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8183,$8183,$8183,$0000,$0000,$0000
        .word   $0000,$0000,$8183,$8183,$8183,$8183,$8183,$0000,$0000
        .word   $0000,$8183,$8183,$8183,$8183,$8183,$8183,$8183,$0000
        .word   $8183,$8183,$8183,$8183,$8183,$8183,$8183,$8183,$8183

; hdma pointers for main/sub screen designation (hdma #6) text only
DlgTextOpenMainSubTbl:
        .word   $0000,$0000,$0000,$0000,$8193,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8193,$8193,$8193,$0000,$0000,$0000
        .word   $0000,$0000,$8193,$8193,$8193,$8193,$8193,$0000,$0000
        .word   $0000,$8193,$8193,$8193,$8193,$8193,$8193,$8193,$0000
        .word   $8193,$8193,$8193,$8193,$8193,$8193,$8193,$8193,$8193
.endproc

; ------------------------------------------------------------------------------

; [ init dialog window ]

.proc InitDlgWindow
        jsr     TfrWindowGfx
        lda     $0565                   ; wallpaper index
        sta     hWRMPYA
        lda     #$0e                    ; get pointer to wallpaper palette
        sta     hWRMPYB
        nop2
        ldx     $00
        ldy     hRDMPYL
:       lda     $1d57,y                 ; copy wallpaper palette to ram
        sta     $7e72f2,x
        sta     $7e74f2,x
        inx
        iny
        cpx     #$000e
        bne     :-

        lda     #$80                    ; vram memory settings
        sta     hVMAINC
        ldx     #$4020                  ; vram destination = $4020 (dialog window at top of screen)
        stx     hVMADDL
        ldx     $00
:       lda     f:DlgWindowTilesTop,x   ; low byte of bg data
        sta     hVMDATAL
        lda     #$3e                    ; high byte of bg data (high priority, palette 7)
        sta     hVMDATAH
        inx
        cpx     #$0120
        bne     :-

        ldx     #$4240                  ; vram destination = $4240 (dialog window at bottom of screen)
        stx     hVMADDL
        ldx     $00
:       lda     f:DlgWindowTilesTop,x
        sta     hVMDATAL
        lda     #$3e
        sta     hVMDATAH
        inx
        cpx     #$0120
        bne     :-

        ldx     #$4400                  ; vram destination = $4400
        stx     hVMADDL
        ldx     #$0020                  ; clear 1 line
:       lda     #$ff
        sta     hVMDATAL
        lda     #$21                    ; high byte of bg data (high priority, palette 0)
        sta     hVMDATAH
        dex
        bne     :-

        jsr     TfrDlgTiles             ; dialog window at top of screen
        ldx     #$0120                  ; clear 9 lines
:       lda     #$ff
        sta     hVMDATAL
        lda     #$21
        sta     hVMDATAH
        dex
        bne     :-

        jsr     TfrDlgTiles             ; dialog window at bottom of screen
        ldx     #$0020                  ; clear 1 line
:       lda     #$ff
        sta     hVMDATAL
        lda     #$21
        sta     hVMDATAH
        dex
        bne     :-
        rts

; load dialog text tile formation to vram
TfrDlgTiles:
        ldy     $00
LoopY:  ldx     $00
LoopX:  lda     f:DlgTextTiles,x
        bmi     :+
        tya
        clc
        adc     f:DlgTextTiles,x   ; tile index
:       sta     hVMDATAL
        lda     #$21        ; tile flags
        sta     hVMDATAH
        inx
        cpx     #$0040
        bne     LoopX
        tya
        clc
        adc     #$40
        tay
        bne     LoopY
        rts

; dialog text tile formation (32x2, low byte only)
DlgTextTiles:
        .byte   $ff,$ff,$00,$02,$04,$06,$08,$0a,$0c,$0e,$10,$12,$14,$16,$18,$1a
        .byte   $1c,$1e,$20,$22,$24,$26,$28,$2a,$2c,$2e,$30,$32,$34,$36,$ff,$ff
        .byte   $ff,$ff,$01,$03,$05,$07,$09,$0b,$0d,$0f,$11,$13,$15,$17,$19,$1b
        .byte   $1d,$1f,$21,$23,$25,$27,$29,$2b,$2d,$2f,$31,$33,$35,$37,$ff,$ff

; dialog window tile formation (32x9, low byte only, first and last tile on each line get masked)
DlgWindowTilesTop:
        .byte   $f0,$f0,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2
        .byte   $f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f3,$f3

DlgWindowTilesMid:
        .byte   $f4,$f4,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1
        .byte   $e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$f5,$f5
        .byte   $f6,$f6,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5
        .byte   $e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$f7,$f7
        .byte   $f4,$f4,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9
        .byte   $ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$f5,$f5
        .byte   $f6,$f6,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed
        .byte   $ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$f7,$f7
        .byte   $f4,$f4,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1
        .byte   $e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$f5,$f5
        .byte   $f6,$f6,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5
        .byte   $e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$f7,$f7
        .byte   $f4,$f4,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9
        .byte   $ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$f5,$f5

DlgWindowTilesBtm:
        .byte   $f8,$f8,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa
        .byte   $f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$fb,$fb
.endproc

; ------------------------------------------------------------------------------
