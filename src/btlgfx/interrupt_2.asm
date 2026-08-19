; ------------------------------------------------------------------------------

; hdma #6 table, normal (+++$2109)
HDMA6Tbl:
        hdma_addr 100, w7e897b          ; battlefield
        hdma_addr 51, w7e897b
        hdma_addr 73, w7e897f           ; menu
        hdma_end

; hdma #7 table (+++$212a)
HDMA7Tbl:
        hdma_addr 4, w7e8987            ; battlefield
        hdma_addr 96, w7e898b
        hdma_addr 51, w7e898b
        hdma_addr 68, w7e898f           ; menu
        hdma_addr 5, w7e8987
        hdma_end

; hdma #6 table, slot (+++$2109)
HDMA6SlotTbl:
        hdma_addr 100, w7e897b          ; battlefield
        hdma_addr 51, w7e897b
        hdma_addr 12, w7e897f           ; menu
        hdma_addr 48, w7e8983
        hdma_addr 13, w7e897f
        hdma_end

; hdma #3 table, slot (+++$2105)
HDMA3SlotTbl:
        hdma_addr 100, w7e896f          ; battlefield
        hdma_addr 51, w7e896f
        hdma_addr 12, w7e8973           ; menu
        hdma_addr 48, w7e8977
        hdma_addr 13, w7e8973
        hdma_end

; hdma #3 table, normal (+++$2105)
HDMA3Tbl:
        hdma_addr 100, w7e896f          ; battlefield
        hdma_addr 51, w7e896f
        hdma_addr 73, w7e8973           ; menu
        hdma_end

; hdma #4 table (+++$212f)
HDMA4Tbl:
        hdma_addr 112 | BIT_7, w7e8993
        hdma_addr 112 | BIT_7, w7e8993 + 112*4
        hdma_end

; hdma #5 table (+++$2126, window position)
HDMA5Tbl:
        hdma_addr 76 | BIT_7, w7e9f1f
        hdma_addr 76 | BIT_7, w7e9f1f + 76 * 4
        hdma_addr 72 | BIT_7, w7e9c7f
        hdma_end

; hdma #5 table (+$2131, color math)
; used for fade in, then replaced with the window position HDMA table
HDMA5FadeInTbl:
        hdma_addr 112 | BIT_7, w7eea32
        hdma_addr 112 | BIT_7, w7eea32 + 112 * 2
        hdma_end

; ------------------------------------------------------------------------------

; pointers to bg scroll hdma tables (hdma #0, #1, and #2)
BGScrollHDMATbl:
        ptr_tbl BG_SCROLL_HDMA

; ------------------------------------------------------------------------------

; $09/$15: hdma #0 table, 19 values, change every 8 scanlines (+$210d, bg1 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::CHUNKY_BG1
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::CHUNKY_BG1 + 12
        .repeat 18, i                   ; battlefield
        hdma_addr 8, array_item wBG1ScrollData, i
        .endrep
        hdma_addr 7, wBG1ScrollData::_18
        hdma_addr 73 | BIT_7, wBG1ScrollData::_151   ; menu
        hdma_end

; $00/$0c: hdma #0 table, 224 values (+$210d, bg1 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_FULL_BG1
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_FULL_BG1 + 12
        hdma_addr 112 | BIT_7, wBG1ScrollData::_0
        hdma_addr 112 | BIT_7, wBG1ScrollData::_112
        hdma_end

; $01/$0d: hdma #1 table, 224 values (+$210f, bg2 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_FULL_BG2
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_FULL_BG2 + 12
        hdma_addr 112 | BIT_7, wBG2ScrollData::_0
        hdma_addr 112 | BIT_7, wBG2ScrollData::_112
        hdma_end

; $02: hdma #2 table, 224 values (+$2111, bg3 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_FULL_BG3
        hdma_addr 112 | BIT_7, wBG3ScrollData::_0
        hdma_addr 112 | BIT_7, wBG3ScrollData::_112
        hdma_end

; $06/$12: hdma #0 table, 32 values (+$210d, bg1 scroll)
; used for odin/raiden/cleave death animation
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_32_BG1
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_32_BG1 + 12
        hdma_addr 32 | BIT_7, wBG1ScrollData::_0   ; battlefield
        hdma_addr 32 | BIT_7, wBG1ScrollData::_0
        hdma_addr 32 | BIT_7, wBG1ScrollData::_0
        hdma_addr 32 | BIT_7, wBG1ScrollData::_0
        hdma_addr 23 | BIT_7, wBG1ScrollData::_0
        hdma_addr 73 | BIT_7, wBG1ScrollData::_151   ; menu
        hdma_end

; $08/$14: hdma #0 table, 64 values (+$210d, bg1 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_64_BG1
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_64_BG1 + 12
        hdma_addr 64 | BIT_7, wBG1ScrollData::_0   ; battlefield
        hdma_addr 64 | BIT_7, wBG1ScrollData::_0
        hdma_addr 23 | BIT_7, wBG1ScrollData::_0
        hdma_addr 73 | BIT_7, wBG1ScrollData::_151   ; menu
        hdma_end

; $03/$0f: hdma #0 table, single value (+$210d, bg1 scroll)
; default bg1 scroll hdma table
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::DEFAULT_BG1
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::DEFAULT_BG1 + 12
        hdma_addr 64, wBG1ScrollData::_0           ; battlefield
        hdma_addr 64, wBG1ScrollData::_0
        hdma_addr 23, wBG1ScrollData::_0
        hdma_addr 73 | BIT_7, wBG1ScrollData::_151   ; menu
        hdma_end

; $0b/$17: hdma #1 table (+$210f, bg2 scroll)
; cyan's dream battle bg
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::CYANS_DREAM_BG2
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::CYANS_DREAM_BG2 + 12
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0   ; battlefield
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0
        hdma_addr 16 | BIT_7, wBG2ScrollData::_0
        hdma_addr 48 | BIT_7, wBG2ScrollData::_64
        hdma_addr 23 | BIT_7, wBG2ScrollData::_64
        hdma_addr 73 | BIT_7, wBG2ScrollData::_151   ; menu
        hdma_end

; $0a/$16: hdma #1 table (+$210f, bg2 scroll)
; phantom train exterior and magitek train battle bg
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::TRAIN_BG2
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::TRAIN_BG2 + 12
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0   ; battlefield
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0
        hdma_addr 23 | BIT_7, wBG2ScrollData::_0
        hdma_addr 41 | BIT_7, wBG2ScrollData::_64
        hdma_addr 23 | BIT_7, wBG2ScrollData::_64
        hdma_addr 73 | BIT_7, wBG2ScrollData::_151   ; menu
        hdma_end

; $04/$10: hdma #1 table (+$210f, bg2 scroll)
; default bg2 scroll hdma table
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::DEFAULT_BG2
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::DEFAULT_BG2 + 12
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0   ; battlefield
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0
        hdma_addr 32 | BIT_7, wBG2ScrollData::_0
        hdma_addr 23 | BIT_7, wBG2ScrollData::_0
        hdma_addr 73 | BIT_7, wBG2ScrollData::_151   ; menu
        hdma_end

; $07: hdma #2 table (+$2111, bg3 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_32_BG3
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0   ; battlefield
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0
        hdma_addr 23 | BIT_7, wBG3ScrollData::_0
        hdma_addr 73 | BIT_7, wBG3ScrollData::_151   ; menu
        hdma_end

; $05: hdma #2 table (+$2111, bg3 scroll)
; default bg3 scroll hdma table
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::DEFAULT_BG3
        hdma_addr 64, wBG3ScrollData::_0           ; battlefield
        hdma_addr 64, wBG3ScrollData::_0
        hdma_addr 23, wBG3ScrollData::_0
        hdma_addr 73 | BIT_7, wBG3ScrollData::_151   ; menu
        hdma_end

; $0e: hdma #2 table (+$2111, bg3 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_FULL_BG3_SLOT
        hdma_addr 100 | BIT_7, wBG3ScrollData::_0  ; battlefield
        hdma_addr 51 | BIT_7, wBG3ScrollData::_100
        hdma_addr 12 | BIT_7, wBG3ScrollData::_151   ; menu
        hdma_addr 48, w7e7b86
        hdma_addr 13 | BIT_7, wBG3ScrollData::_211
        hdma_end

; $13: hdma #2 table (+$2111, bg3 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::WAVE_32_BG3_SLOT
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0   ; battlefield
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0
        hdma_addr 32 | BIT_7, wBG3ScrollData::_0
        hdma_addr 23 | BIT_7, wBG3ScrollData::_0
        hdma_addr 12 | BIT_7, wBG3ScrollData::_151   ; menu
        hdma_addr 48, w7e7b86
        hdma_addr 13 | BIT_7, wBG3ScrollData::_211
        hdma_end

; $11: hdma #2 table (+$2111, bg3 scroll)
        array_label BG_SCROLL_HDMA, BG_SCROLL_HDMA::DEFAULT_BG3_SLOT
        hdma_addr 64, wBG3ScrollData::_0           ; battlefield
        hdma_addr 64, wBG3ScrollData::_0
        hdma_addr 23, wBG3ScrollData::_0
        hdma_addr 12 | BIT_7, wBG3ScrollData::_151   ; menu
        hdma_addr 48, w7e7b86
        hdma_addr 13 | BIT_7, wBG3ScrollData::_211
        hdma_end

; ------------------------------------------------------------------------------

; vram offsets for each strip of menu window tiles
_c2d294:
@d294:  .word   $0000,$0020,$0040,$0060,$0080,$00a0,$00c0,$00e0

; pointers to bg2 tile data in vram (menu region)
_c2d2a4:
@d2a4:  .word   $7140,$7160,$7180,$71a0,$71c0,$71e0,$7200,$7220

; ram buffer offsets for each strip of menu window tiles
_c2d2b4:
@d2b4:  .word   $0000,$0040,$0080,$00c0,$0100,$0140,$0180,$01c0

; pointers to character sprite graphics in ram (top)
CharTopGfxBufPtrs:
        .addr   $a000,$a080,$a100,$a180

; pointers to character sprite graphics in ram (bottom)
CharTopGfxVRAMPtrs:
        .addr   $a200,$a280,$a300,$a380

; pointers to character sprite graphics in vram (top)
CharBtmGfxBufPtrs:
        .word   $2000,$2040,$2080,$20c0

; pointers to character sprite graphics in vram (bottom)
CharBtmGfxVRAMPtrs:
        .word   $2100,$2140,$2180,$21c0

; wram address for status graphics
StatusGfxBufPtrs:
@d2e4:  .word   $a400,$a600,$a480,$a680,$a500,$a700,$a580,$a780
        .word   $a800,$aa00,$a880,$aa80,$a900,$ab00,$a980,$ab80
        .word   $ac00,$ae00,$ac80,$ae80,$ad00,$af00,$ad80,$af80
        .word   $b000,$b200,$b080,$b280,$b100,$b300,$b180,$a780

; vram address for status graphics
StatusGfxVRAMPtrs:
@d324:  .word   $2200,$2300,$2240,$2340,$2280,$2380,$22c0,$23c0
        .word   $2200,$2300,$2240,$2340,$2280,$2380,$22c0,$23c0
        .word   $2200,$2300,$2240,$2340,$2280,$2380,$22c0,$23c0
        .word   $2200,$2300,$2240,$2340,$2280,$2380,$22c0,$23c0

; ------------------------------------------------------------------------------

_c2d364:
@d364:  .byte   $0e,$2a,$46,$62

; ------------------------------------------------------------------------------

.mac hdma_prop ctrl, reg, table
        .byte ctrl, <reg
        .faraddr table
.endmac

; 0: hdma #0 ($c2d1f2 -> +$210d)
; 1: hdma #1 ($c2d225 -> +$210f)
; 2: hdma #2 ($c2d24b -> +$2111)
; 3: hdma #3, normal ($c2d12e -> +++$2105)
; 4: hdma #4 ($c2d138 -> +++$212f)
; 5: hdma #5 ($c2d149 -> +$2131)
; 6: hdma #6, normal ($c2d0f4 -> +++$2109)
; 7: hdma #3, slot ($c2d11e -> +++$2105)
; 8: hdma #6, slot ($c2d10e -> +++$2109)
; 9: hdma #7 ($c2d0fe -> +++$212a)
; 10: hdma #5 ($c2d13f -> +++$2126)

HDMAProp:

; initial tables
HDMAProp::_0:   hdma_prop $43, hBG1HOFS,   BG_SCROLL_HDMA::_3
HDMAProp::_1:   hdma_prop $43, hBG2HOFS,   BG_SCROLL_HDMA::_4
HDMAProp::_2:   hdma_prop $43, hBG3HOFS,   BG_SCROLL_HDMA::_5
HDMAProp::_3:   hdma_prop $44, hBGMODE,    HDMA3Tbl
HDMAProp::_4:   hdma_prop $44, hTSW,       HDMA4Tbl
HDMAProp::_5:   hdma_prop $41, hCGADSUB,   HDMA5FadeInTbl
HDMAProp::_6:   hdma_prop $44, hBG3SC,     HDMA6Tbl

; additional tables
HDMAProp::_7:   hdma_prop $44, hBGMODE,    HDMA3SlotTbl
HDMAProp::_8:   hdma_prop $44, hBG3SC,     HDMA6SlotTbl
HDMAProp::_9:   hdma_prop $44, hWBGLOG,    HDMA7Tbl
HDMAProp::_10:  hdma_prop $44, hWH0,       HDMA5Tbl

; ------------------------------------------------------------------------------

; repeat count for bg3 hdma scroll data (vertical)
_c2d39f:
@d39f:  .byte   1,1,1,1,1,2,1,2,1,2,2,3,2,3,3,3
        .byte   4,3,4,4,4,5,4,5,5,5,5,5,5,5,5,4
        .byte   5,4,4,4,3,4,3,3,3,2,3,2,2,1,2,1
        .byte   2,1,1,1,1,1

; ------------------------------------------------------------------------------

; [ init hardware registers ]

InitHWRegs:
        lda     #$00
        pha
        plb
        sta     hNMITIMEN       ; disable interrupts
        ldx     #BTLGFX_ZP_START
        phx
        pld
        lda     #$80
        sta     hINIDISP
        lda     #$61        ; sprite gfx at vram $2000, 16x16 & 32x32 sprites
        sta     hOBJSEL
        lda     #$80
        sta     hVMAINC
        lda     #$00
        tax
        sta     hBG4HOFS
        sta     hBG4HOFS
        sta     hBG4VOFS
        sta     hBG4VOFS
        sta     hTMW
        sta     hTSW
        sta     hMDMAEN
        sta     hHDMAEN
        sta     hCGADSUB
        sta     hSETINI
        sta     hCGSWSEL
        sta     hWH2
        sta     $2129
        lda     #^BattleNMI        ; set interrupt jump code
        sta     $1503
        lda     #^BattleIRQ
        sta     $1507
        ldx     #near BattleNMI
        stx     $1501
        ldx     #near BattleIRQ
        stx     $1505
        lda     #$5c
        sta     $1500
        sta     $1504
        lda     #$01        ; select fastrom
        sta     f:hMEMSEL
        lda     #$33        ; bg/window settings
        sta     hW12SEL
        sta     hW34SEL
        sta     hWOBJSEL
        lda     #$7e
        pha
        plb
        ldx     #0      ; clear $00-$9b
@d450:  stz     a:BTLGFX_ZP_START,x
        inx
        cpx     #BTLGFX_ZP_SIZE
        bne     @d450
        ldx     #near w7e6178      ; clear $6178-$8d12
@d45c:  stz     a:$0000,x
        inx
        cpx     #near w7e8d13
        bne     @d45c
        clr_ax
@d467:  sta     near w7e7e00,x     ; clear $7e00-$7fff (color palettes)
        inx
        cpx     #$0200
        bne     @d467
        rtl

; ------------------------------------------------------------------------------

summon_obj_set_tbl:
_c2d471:
        .repeat 8, i
        .addr w7eae3f + i * $0200
        .word $2400 + i * $0100
        .endrep
        .addr w7ebe3f
        .word $2c00
        .addr w7ebe3f + $0600
        .word $2d00

; ------------------------------------------------------------------------------

; battle event palettes
BattleEventPal:

; tritoch sparkling palettes
@d499:  .word   $2529,$0843,$7ffe,$7f32,$5a2a,$4544,$30a2,$56f2
        .word   $2a0a,$1121,$19d9,$10d2,$0c8a,$0ebd,$09f1,$050a

        .word   $2d6b,$0843,$5a2a,$7ffe,$7f32,$5a2a,$4544,$56f2
        .word   $2a0a,$1121,$19d9,$10d2,$0c8a,$0ebd,$09f1,$050a

        .word   $2d6b,$0843,$4544,$5a2a,$7ffe,$7f32,$5a2a,$56f2
        .word   $2a0a,$1121,$19d9,$10d2,$0c8a,$0ebd,$09f1,$050a

        .word   $2d6b,$0843,$5a2a,$4544,$5a2a,$7ffe,$7f32,$56f2
        .word   $2a0a,$1121,$19d9,$10d2,$0c8a,$0ebd,$09f1,$050a

        .word   $2d6b,$0843,$6ef1,$5a2a,$4544,$5a2a,$7ffe,$56f2
        .word   $2a0a,$1121,$19d9,$10d2,$0c8a,$0ebd,$09f1,$050a

; ------------------------------------------------------------------------------
