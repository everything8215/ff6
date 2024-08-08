.segment "menu_code_far"

        fixed_block $0600

; ------------------------------------------------------------------------------

; [ clear party character data ]

ClearCharProp:
@ca00:  stz     $75                     ; clear battle order
        stz     $76
        stz     $77
        stz     $78
        ldy     z0
        sty     zCharPropPtr::Slot1
        sty     zCharPropPtr::Slot2
        sty     zCharPropPtr::Slot3
        sty     zCharPropPtr::Slot4
        lda     #$ff
        sta     zCharID::Slot1                 ; set character numbers to $ff (no character)
        sta     zCharID::Slot2
        sta     zCharID::Slot3
        sta     zCharID::Slot4
        rtl

; ------------------------------------------------------------------------------

; [ init hdma for menu window gradient bars ]

; A: menu type
;      0: field menu
;      1: save select
;      2: colosseum (select challenger)

InitGradientHDMA:
@ca1d:  xba
        lda     z0
        xba
        asl
        tax
        longa
        lda     f:MenuFixedColorHDMATblPtrs,x
        sta     hDMA3::ADDR
        lda     f:MenuAddSubHDMATblPtrs,x
        sta     hDMA4::ADDR
        shorta
        stz     hDMA3::CTRL
        lda     #<hCOLDATA
        sta     hDMA3::HREG
        lda     #^*
        sta     hDMA3::ADDR_B
        sta     hDMA3::HDMA_B
        sta     hDMA4::ADDR_B
        sta     hDMA4::HDMA_B
        stz     hDMA4::CTRL
        lda     #<hCGADSUB
        sta     hDMA4::HREG
        lda     #BIT_3 | BIT_4
        tsb     zEnableHDMA
        lda     #$80
        sta     hCGSWSEL
        lda     #$82
        sta     hCGADSUB
        lda     #$17
        sta     hTM
        lda     #$17
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        rtl

; ------------------------------------------------------------------------------

; pointers to add/sub dma tables
MenuAddSubHDMATblPtrs:
@ca71:  .addr   MenuAddSubHDMATbl_00
        .addr   MenuAddSubHDMATbl_01
        .addr   MenuAddSubHDMATbl_02

; add/sub hdma data for normal menu window
MenuAddSubHDMATbl_00:
        hdma_byte 112, $02
        hdma_byte 112, $82
        hdma_end

; pointers to fixed color hdma tables
MenuFixedColorHDMATblPtrs:
@ca7c:  .addr   MenuFixedColorHDMATbl_00
        .addr   MenuFixedColorHDMATbl_01
        .addr   MenuFixedColorHDMATbl_02

; fixed color hdma data for normal menu window
MenuFixedColorHDMATbl_00:
        hdma_byte 10, FIXED_CLR::WHITE | 11
        hdma_byte 10, FIXED_CLR::WHITE | 10
        hdma_byte 10, FIXED_CLR::WHITE | 9
        hdma_byte 10, FIXED_CLR::WHITE | 8
        hdma_byte 10, FIXED_CLR::WHITE | 7
        hdma_byte 10, FIXED_CLR::WHITE | 6
        hdma_byte 10, FIXED_CLR::WHITE | 5
        hdma_byte 10, FIXED_CLR::WHITE | 4
        hdma_byte 10, FIXED_CLR::WHITE | 3
        hdma_byte 10, FIXED_CLR::WHITE | 2
        hdma_byte 10, FIXED_CLR::WHITE | 1
        hdma_byte 10, FIXED_CLR::WHITE | 0
        hdma_byte 10, FIXED_CLR::WHITE | 1
        hdma_byte 10, FIXED_CLR::WHITE | 2
        hdma_byte 10, FIXED_CLR::WHITE | 3
        hdma_byte 10, FIXED_CLR::WHITE | 4
        hdma_byte 10, FIXED_CLR::WHITE | 5
        hdma_byte 10, FIXED_CLR::WHITE | 6
        hdma_byte 10, FIXED_CLR::WHITE | 7
        hdma_byte 10, FIXED_CLR::WHITE | 8
        hdma_byte 10, FIXED_CLR::WHITE | 9
        hdma_byte 10, FIXED_CLR::WHITE | 10
        hdma_byte 10, FIXED_CLR::WHITE | 11
        hdma_byte 10, FIXED_CLR::WHITE | 12
        hdma_end

; add/sub hdma data for save select menu window
MenuAddSubHDMATbl_01:
@cab3:  hdma_byte 31,$02
        hdma_byte 16,$82
.repeat 3
        hdma_byte 28,$02
        hdma_byte 28,$82
.endrep
        hdma_end

; add/sub hdma data for colosseum menu window
MenuAddSubHDMATbl_02:
@cac4:  hdma_byte 23,$02
        hdma_byte 120,$82
        hdma_byte 36,$02
        hdma_byte 36,$82
        hdma_end

; fixed color hdma data for save select menu window
MenuFixedColorHDMATbl_01:
@cacd:  hdma_byte 15,$e0
        hdma_byte 2,$e7
        hdma_byte 2,$e6
        hdma_byte 2,$e5
        hdma_byte 2,$e4
        hdma_byte 2,$e3
        hdma_byte 2,$e2
        hdma_byte 2,$e1
        hdma_byte 2,$e0
        hdma_byte 2,$e1
        hdma_byte 2,$e2
        hdma_byte 2,$e3
        hdma_byte 2,$e4
        hdma_byte 2,$e5
        hdma_byte 2,$e6
        hdma_byte 2,$e7
.repeat 3
        hdma_byte 4,$e7
        hdma_byte 4,$e6
        hdma_byte 4,$e5
        hdma_byte 4,$e4
        hdma_byte 4,$e3
        hdma_byte 4,$e2
        hdma_byte 4,$e1
        hdma_byte 4,$e0
        hdma_byte 4,$e1
        hdma_byte 4,$e2
        hdma_byte 4,$e3
        hdma_byte 4,$e4
        hdma_byte 4,$e5
        hdma_byte 4,$e6
.endrep
        hdma_end

; fixed color hdma data for colosseum challenger select window
MenuFixedColorHDMATbl_02:
@cb42:  hdma_byte 7,$e0
        hdma_byte 2,$e7
        hdma_byte 2,$e6
        hdma_byte 2,$e5
        hdma_byte 2,$e4
        hdma_byte 2,$e3
        hdma_byte 2,$e2
        hdma_byte 2,$e1
        hdma_byte 2,$e0
        hdma_byte 2,$e1
        hdma_byte 2,$e2
        hdma_byte 2,$e3
        hdma_byte 2,$e4
        hdma_byte 2,$e5
        hdma_byte 2,$e6
        hdma_byte 3,$e7
        hdma_byte 103,$e0  ; no fixed color in battle bg region
        hdma_byte 2,$ea
        hdma_byte 4,$e9
        hdma_byte 4,$e8
        hdma_byte 4,$e7
        hdma_byte 4,$e6
        hdma_byte 4,$e5
        hdma_byte 4,$e4
        hdma_byte 4,$e3
        hdma_byte 4,$e2
        hdma_byte 4,$e1
        hdma_byte 4,$e0
        hdma_byte 4,$e1
        hdma_byte 4,$e2
        hdma_byte 4,$e3
        hdma_byte 4,$e4
        hdma_byte 4,$e5
        hdma_byte 4,$e6
        hdma_byte 4,$e7
        hdma_byte 4,$e8
        hdma_byte 4,$e9
        hdma_byte 2,$ea
        hdma_end

; ------------------------------------------------------------------------------

; [ init mode 7 hdma (all credits scenes except clouds 3) ]

_d4cb8f:
@cb8f:  lda     #$42
        sta     hDMA4::CTRL
        sta     hDMA5::CTRL
        sta     hDMA6::CTRL
        sta     hDMA7::CTRL
        lda     #<hM7A
        sta     hDMA4::HREG
        inc
        sta     hDMA5::HREG
        inc
        sta     hDMA6::HREG
        inc
        sta     hDMA7::HREG
        ldy     #near _d4cbe7
        sty     hDMA4::ADDR
        ldy     #near _d4cbee
        sty     hDMA5::ADDR
        ldy     #near _d4cbf5
        sty     hDMA6::ADDR
        ldy     #near _d4cbe7
        sty     hDMA7::ADDR
        lda     #^_d4cbe7
        sta     hDMA4::ADDR_B
        sta     hDMA5::ADDR_B
        sta     hDMA6::ADDR_B
        sta     hDMA7::ADDR_B
        lda     #$00
        sta     hDMA4::HDMA_B
        sta     hDMA5::HDMA_B
        sta     hDMA6::HDMA_B
        sta     hDMA7::HDMA_B
        lda     #BIT_4 | BIT_5 | BIT_6 | BIT_7
        tsb     zEnableHDMA
        rtl

; ------------------------------------------------------------------------------

; hdma tables for all credits scenes except clouds 3

; m7a & m7d hdma table
_d4cbe7:
        hdma_addr 123 | BIT_7, $0604
        hdma_addr 101 | BIT_7, $06f8
        hdma_end

; m7b hdma table
_d4cbee:
        hdma_addr 123 | BIT_7, $07c6
        hdma_addr 101 | BIT_7, $08ba
        hdma_end

; m7c hdma table
_d4cbf5:
        hdma_addr 123 | BIT_7, $0988
        hdma_addr 101 | BIT_7, $0a7c
        hdma_end

; ------------------------------------------------------------------------------

; [ init mode 7 hdma (credits, airship above clouds) ]

_d4cbfc:
@cbfc:  lda     #$43
        sta     hDMA1::CTRL
        sta     hDMA2::CTRL
        lda     #$42
        sta     hDMA4::CTRL
        sta     hDMA5::CTRL
        sta     hDMA6::CTRL
        sta     hDMA7::CTRL
        lda     #<hBG1HOFS  ; channel #1 destination = $210d, $210e (bg1 hscroll, vscroll)
        sta     hDMA1::HREG
        lda     #<hM7X      ; channel #2 destination = $211f, $2120 (center x, y)
        sta     hDMA2::HREG
        lda     #<hM7A      ; channel #4 destination = $211b (m7a)
        sta     hDMA4::HREG
        inc                 ; channel #5 destination = $211c (m7b)
        sta     hDMA5::HREG
        inc                 ; channel #6 destination = $211d (m7c)
        sta     hDMA6::HREG
        inc                 ; channel #7 destination = $211e (m7d)
        sta     hDMA7::HREG
        ldy     #near _d4cd3a
        sty     hDMA1::ADDR
        ldy     #near _d4cd41
        sty     hDMA2::ADDR
        ldy     #near _d4cd25
        sty     hDMA4::ADDR
        ldy     #near _d4cd2c
        sty     hDMA5::ADDR
        ldy     #near _d4cd33
        sty     hDMA6::ADDR
        ldy     #near _d4cd25
        sty     hDMA7::ADDR
        lda     #^_d4cd3a
        sta     hDMA1::ADDR_B
        sta     hDMA2::ADDR_B
        sta     hDMA4::ADDR_B
        sta     hDMA5::ADDR_B
        sta     hDMA6::ADDR_B
        sta     hDMA7::ADDR_B
        lda     #$00
        sta     hDMA4::HDMA_B
        sta     hDMA5::HDMA_B
        sta     hDMA6::HDMA_B
        sta     hDMA7::HDMA_B
        lda     #$7e
        sta     hDMA1::HDMA_B
        sta     hDMA2::HDMA_B
        lda     #$04
        sta     hDMA3::CTRL
        lda     #<hCGSWSEL
        sta     hDMA3::HREG
        ldy     #near FixedColorHDMATbl
        sty     hDMA3::ADDR
        lda     #^FixedColorHDMATbl
        sta     hDMA3::ADDR_B
        sta     hDMA3::HDMA_B
        lda     #BIT_1 | BIT_2 | BIT_3 | BIT_4 | BIT_5 | BIT_6 | BIT_7
        tsb     zEnableHDMA
        rtl

; ------------------------------------------------------------------------------

; fixed color hdma table
FixedColorHDMATbl:
        hdma_4byte 99, {$80, $01, $e0, $00}
        hdma_4byte 1, {$80, $01, $e1, $00}
        hdma_4byte 1, {$80, $01, $e2, $00}
        hdma_4byte 1, {$80, $01, $e3, $00}
        hdma_4byte 1, {$80, $01, $e4, $00}
        hdma_4byte 1, {$80, $01, $e5, $00}
        hdma_4byte 1, {$80, $01, $e6, $00}
        hdma_4byte 1, {$80, $01, $e7, $00}
        hdma_4byte 1, {$80, $01, $e8, $00}
        hdma_4byte 1, {$80, $01, $e9, $00}
        hdma_4byte 1, {$80, $01, $ea, $00}
        hdma_4byte 1, {$80, $01, $eb, $00}
        hdma_4byte 1, {$80, $01, $ec, $00}
        hdma_4byte 2, {$80, $01, $ee, $00}
        hdma_4byte 3, {$80, $01, $f0, $00}
        hdma_4byte 3, {$80, $01, $f3, $00}
        hdma_4byte 2, {$80, $01, $f6, $00}
        hdma_4byte 1, {$80, $01, $fa, $00}
        hdma_4byte 1, {$80, $01, $fb, $00}
        hdma_4byte 1, {$80, $01, $fc, $00}
        hdma_4byte 1, {$80, $01, $ef, $00}
        hdma_4byte 1, {$80, $01, $ec, $00}
        hdma_4byte 1, {$80, $01, $ea, $00}
        hdma_4byte 1, {$80, $01, $e6, $00}
        hdma_4byte 1, {$80, $01, $e3, $00}
        hdma_4byte 2, {$80, $01, $e2, $00}
        hdma_4byte 3, {$80, $01, $e1, $00}
        hdma_4byte 1, {$82, $81, $e0, $00}
        hdma_end

; ------------------------------------------------------------------------------

; hdma tables for clouds 3 (mode 7 airship above clouds)
;   the first value writes then waits 124 frames (airship)
;   the second value writes every frame for 100 frames (clouds)

; m7a & m7d hdma table
_d4cd25:
        hdma_addr 124, $0600
        hdma_addr 100 | BIT_7, $06f8
        hdma_end

; m7b hdma table
_d4cd2c:
        hdma_addr 124, $07c2
        hdma_addr 100 | BIT_7, $08ba
        hdma_end

; m7c hdma table
_d4cd33:
        hdma_addr 124, $0984
        hdma_addr 100 | BIT_7, $0a7c
        hdma_end

; bg1 scroll hdma table
_d4cd3a:
        hdma_addr 124, $b68d
        hdma_addr 100, $b691
        hdma_end

; center x,y position hdma table
_d4cd41:
        hdma_addr 124, $b695
        hdma_addr 100, $b699
        hdma_end

; ------------------------------------------------------------------------------

; [ init menu hardware registers ]

InitHWRegsMenu:
@cd48:  lda     #$01
        sta     hOBJSEL
        ldx     z0
        stx     hOAMADDL
        lda     #$09
        sta     hBGMODE
        lda     #$00
        sta     hMOSAIC
        lda     #$03
        sta     hBG1SC
        lda     #$13
        sta     hBG2SC
        lda     #$43
        sta     hBG3SC
        lda     #$65
        sta     hBG12NBA
        lda     #$66
        sta     hBG34NBA
        clr_a
        sta     hHDMAEN
        sta     hMDMAEN
        sta     hBG1HOFS
        sta     hBG1HOFS
        sta     hBG1VOFS
        sta     hBG1VOFS
        sta     hBG2HOFS
        sta     hBG2HOFS
        sta     hBG2VOFS
        sta     hBG2VOFS
        sta     hBG3HOFS
        sta     hBG3HOFS
        sta     hBG3VOFS
        sta     hBG3VOFS
        sta     hBG4HOFS
        sta     hBG4HOFS
        sta     hBG4VOFS
        sta     hBG4VOFS
        lda     #$80
        sta     hVMAINC
        clr_ax
        stx     hVMADDL
        sta     hCGADD
        lda     #$3f
        sta     hW12SEL
        lda     #$33
        sta     hW34SEL
        sta     hWOBJSEL
        lda     #$08
        sta     hWH0
        sta     hWH2
        lda     #$f7
        sta     hWH1
        sta     hWH3
        clr_a
        sta     hTSW
        sta     hSETINI
        sta     hWBGLOG
        sta     hWOBJLOG
        lda     #$1f
        sta     hTM
        lda     #$0f
        sta     hTS
        lda     #$0f
        sta     hTMW
        rtl

; ------------------------------------------------------------------------------

; [ init menu ram ]

InitMenuRAM:
@cdf3:  clr_ay
        sty     zM7A                     ; clear mode7 registers
        sty     zM7B
        sty     zM7C
        sty     zM7D
        sty     zM7X
        sty     zM7Y
        sty     z06                     ; clear controller buttons
        sty     z08
        sty     z0c
        sty     z0a
        sty     $97                     ;
        sty     zTaskCodePtr
        sta     zEnableHDMA             ; disable hdma
        sta     zMenuState
        sta     z25                     ; clear main menu selection
        sta     $b4                     ; use inverse credits palette
        sta     zMosaic
        sta     zSelIndex
        sta     zTextColor
        sta     $60                     ; clear portrait task data pointers
        sta     $61
        sta     $62
        sta     $63
        sta     z46                     ; clear cursor/scrolling flags
        sta     zSelSaveSlot
        sta     $ae                     ; clear current sound effect
        lda     #$ff
        sta     $86                     ; clear cursor positions
        sta     $88
        sta     $8a
        sta     $8c
        lda     #$05                    ;
        sta     z45
        sty     zDMA2Dest               ; dma 1 destination = $0000 vram
        ldy     #$4000                  ; dma 2 destination = $4000 vram
        sty     zDMA1Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA1Src+2
        sta     zDMA2Src+2
        ldy     #$1000                  ; dma 1 & 2 size = $1000
        sty     zDMA1Size
        sty     zDMA2Size
        lda     #$0c                    ; font width (for jp version)
        sta     zb6
        rtl

; ------------------------------------------------------------------------------

; [ init unused hdma ]

_d4ce55:
@ce55:  lda     #$70
        sta     $7e9d89
        sta     $7e9d8b
        lda     #$11
        sta     $7e9d8a
        sta     $7e9d8c
        stz     hDMA1::CTRL
        lda     #<hTM
        sta     hDMA1::HREG
        ldy     #$9d89
        sty     hDMA1::ADDR
        lda     #$7e
        sta     hDMA1::ADDR_B
        lda     #$7e
        sta     hDMA1::HDMA_B
        lda     #BIT_1
        tsb     zEnableHDMA
        rtl

; ------------------------------------------------------------------------------

; unused hdma table
@ce86:  hdma_addr 112, $9d89
        hdma_addr 112, $9d89
; NOTE: missing hdma_end

; ------------------------------------------------------------------------------

; [ init hardware registers (ending character roll) ]

InitHWRegsEnding:
@ce8c:  lda     #$03
        sta     hOBJSEL
        ldx     z0
        stx     hOAMADDL
        lda     #$09
        sta     hBGMODE
        lda     #$03
        sta     hBG1SC
        lda     #$11
        sta     hBG2SC
        lda     #$19
        sta     hBG3SC
        sta     hBG4SC
        lda     #$33
        sta     hBG12NBA
        lda     #$22
        sta     hBG34NBA
        jsr     InitEndingWindowMask
        stz     hCGSWSEL
        lda     #$e0
        sta     hCOLDATA
        lda     #$17
        sta     hTM
        lda     #$02
        sta     hTS
        lda     #$82
        sta     hCGSWSEL
        lda     #$d1
        sta     hCGADSUB
        rtl

; ------------------------------------------------------------------------------

; [ init hardware registers (ending credits) ]

InitHWRegsCredits:
@ced7:  lda     #$03
        sta     hOBJSEL
        ldx     z0
        stx     hOAMADDL
        lda     #$07
        sta     hBGMODE
        lda     #$58
        sta     hBG1SC
        lda     #$50
        sta     hBG2SC
        lda     #$7c
        sta     hBG3SC
        sta     hBG4SC
        lda     #$44
        sta     hBG12NBA
        lda     #$77
        sta     hBG34NBA
        jsr     InitEndingWindowMask
        stz     hM7SEL
        lda     #$13
        sta     hTM
        lda     #$10
        sta     hTS
        lda     #$e0
        sta     hCOLDATA
        lda     #$82
        sta     hCGSWSEL
        lda     #$81
        sta     hCGADSUB
        rtl

; ------------------------------------------------------------------------------

; [ init window settings ]

InitEndingWindowMask:
@cf22:  lda     #$33
        sta     hW12SEL
        sta     hW34SEL
        lda     #$08
        sta     hWH0
        sta     hWH2
        lda     #$f7
        sta     hWH1
        sta     hWH3
        rts

; ------------------------------------------------------------------------------

; [ save memory for mode 7 hdma data ]

PushMode7Vars:
@cf3b:  ldx     z0
@cf3d:  lda     $0600,x
        sta     $7f4000,x
        inx
        cpx     #$054c
        bne     @cf3d
        rtl

; ------------------------------------------------------------------------------

; [ restore memory for mode 7 hdma data ]

PopMode7Vars:
@cf4b:  ldx     z0
@cf4d:  lda     $7f4000,x
        sta     $0600,x
        inx
        cpx     #$054c
        bne     @cf4d
        rtl

; ------------------------------------------------------------------------------

        end_fixed_block

; ------------------------------------------------------------------------------
