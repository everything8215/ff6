
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: debug.asm                                                            |
; |                                                                            |
; | description: debug routines                                                |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.import DebugFontGfx

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; tile numbers for digits 0-9 and A-F
DebugHexDigitTbl:
        .byte   $38,$39,$3a,$3b,$3c,$3d,$3e,$3f
        .byte   $78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$ff

        DEBUG_TILE_FLAGS = $21
        DEBUG_ZERO_CHAR = $38
        DEBUG_BLANK_CHAR = $ff

; ------------------------------------------------------------------------------

; [  ]

; unused

.proc DebugUnusedEvent
        ldx     $e5
        cpx     #.loword(EventScript_NoEvent)
        bne     Done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     Done                    ; return if an event is running
        lda     $1868
        cmp     #$10
        bcc     Done                    ; return if less than 1048576 steps
        ldx     #$004a                  ; $ca004a (invalid event address)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594                   ; event stack = $ca0000
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1
        sta     $05c7                   ; event loop count = 1
        ldx     #$0003
        stx     $e8                     ; stack event pointer
        ldy     $0803                   ; party object
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        lda     #$04                    ; movement type 4 (activated)
        sta     $087c,y
Done:   rts
.endproc  ; DebugUnusedEvent

; ------------------------------------------------------------------------------

; [ load text graphics for debug mode ]

.proc DebugLoadGfx
        stz     hMDMAEN                 ; disable dma
        lda     #$80
        sta     hVMAINC
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        lda     #$41
        sta     hDMA0::CTRL
        ldx     #$39c0                  ; destination = $39c0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #.loword(DebugFontGfx)
        stx     hDMA0::ADDR
        lda     #^DebugFontGfx
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0080                  ; size = $0080
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        ldx     #$3bc0                  ; destination = $3bc0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #near (DebugFontGfx + $80)
        stx     hDMA0::ADDR
        lda     #^(DebugFontGfx + $80)
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0080                  ; size = $0080
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        ldx     #$3dc0                  ; destination = $3dc0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #near (DebugFontGfx + $0100)
        stx     hDMA0::ADDR
        lda     #^(DebugFontGfx + $0100)
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0080                  ; size = $0080
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN                 ; enable dma
        rts
.endproc

; ------------------------------------------------------------------------------

; [ unused ]

.proc DebugUpdate
.if ::DEBUG
; check L+R+start
        lda     $04
        and     #JOY_L|JOY_R
        cmp     #JOY_L|JOY_R
        bne     :+
        lda     $09
        and     #>JOY_START
        beq     :+
        lda     $44                     ; toggle debug info
        eor     #BIT_7
        sta     $44
        jsr     DebugUpdateHDMATbl

; return if debug info is disabled
:       lda     $44
        bpl     Done

; check L
        ldx     $08
        cpx     #JOY_L
        bne     :+
        lda     $44
        inc
        and     #%111
        ora     #BIT_7
        sta     $44

:       ldx     #$6c00
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     $44
        and     #%111

; 0: event info
        bne     :+
        jmp     DebugDrawEventInfo

; 1: party info
:       dec
        bne     :+
        jmp     DebugDrawPartyInfo

; 2: map info
:       dec
        bne     :+
        jmp     DebugDrawMapInfo

; 3: layer info
:       dec
        bne     :+
        jmp     DebugDrawLayerInfo

; 4: timer info
:       dec
        bne     :+
        jmp     DebugDrawTimerInfo

; 5, 6, 7: no effect
:       lda     #64
        jsr     DebugDrawBlank

.endif
Done:   rts
.endproc

.if DEBUG
.proc DebugUpdateHDMATbl
        phb
        lda     #$7e
        pha
        plb
        lda     $44
        bpl     :+

; update hdma tables for debug info on
        ldx     #$81d3
        stx     $7be7
        stx     $7bea
        ldx     #$8713
        stx     $7cf8
        stx     $7cfb
        ldx     #$8193
        stx     $7e09
        stx     $7e0c
        plb
        rts

; update hdma tables for debug info off
:       ldx     #$8233
        stx     $7be7
        stx     $7bea
        ldx     #$82f3
        stx     $7cf8
        stx     $7cfb
        ldx     #$8163
        stx     $7e09
        stx     $7e0c
        plb
        rts
.endproc  ; DebugUpdateHDMATbl
.endif

; ------------------------------------------------------------------------------

.if LANG_EN

; [ display dialogue (debug) ]

.proc DebugShowDlg
        lda     $0568
        bne     Done                    ; return if dialog is being displayed
        lda     $46
        and     #%111
        bne     Done                    ; return 7/8 frames
        lda     $05
        and     #>JOY_START
        beq     :+                      ; branch if start button is not pressed
        ldx     a:$00d0                 ; increment dialog index
        inx
        stx     a:$00d0
        bra     NoChangeDlg
:       lda     $05
        and     #>JOY_SELECT
        beq     Done                    ; branch if select button is not pressed
        ldx     a:$00d0                 ; decrement dialog index
        dex
        stx     a:$00d0

NoChangeDlg:
        ldx     a:$00d0
        stx     $1e
        jsr     DebugDrawWord
        ldx     $0569                   ; counter for dialog pause
        stx     $1e
        jsr     DebugDrawWord
        ldx     $056b                   ; counter for keypress
        stx     $1e
        jsr     DebugDrawWord
        lda     #49
        jsr     DebugDrawBlank
        jsr     GetDlgPtr
        lda     #$01
        sta     $bc                     ; dialog window at top of screen
        lda     #$01
        sta     $ba                     ; enable dialog window
Done:   rts
.endproc  ; DebugShowDlg

.endif

; ------------------------------------------------------------------------------

.if (LANG_EN = 0) || DEBUG

; [ draw layer priority for character objects ]

.proc DebugDrawLayerInfo
        lda     #8
        jsr     DebugDrawBlank
        ldy     $00
Loop:   lda     $0868,y                 ; object layer priority
        and     #$06
        lsr
        sta     $1e
        jsr     DebugDrawNybble
        longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     Loop
        lda     #40
        jsr     DebugDrawBlank
        rts
.endproc  ; DebugDrawLayerInfo

; ------------------------------------------------------------------------------

; [ draw timer durations ]

.proc DebugDrawTimerInfo
        ldy     $1189
        sty     $1e
        jsr     DebugDrawWord
        ldy     $118f
        sty     $1e
        jsr     DebugDrawWord
        ldy     $1195
        sty     $1e
        jsr     DebugDrawWord
        ldy     $119b
        sty     $1e
        jsr     DebugDrawWord
        lda     #42
        jsr     DebugDrawBlank
        rts
.endproc  ; DebugDrawTimerInfo

; ------------------------------------------------------------------------------

; [ draw party info (debug) ]

.proc DebugDrawPartyInfo

; draw current party index
        lda     #1
        jsr     DebugDrawBlank
        lda     $1a6d                   ; current party
        sta     $1e
        jsr     DebugDrawNybble
        lda     #4
        jsr     DebugDrawBlank

; draw list of enabled characters
        ldy     $00
Loop1:  lda     $1850,y
        and     #$40
        beq     :+                      ; branch if character is not enabled
        tya
        bra     :++
:       lda     #$10
:       sta     $1e
        jsr     DebugDrawNybble
        iny
        cpy     #$0010
        bne     Loop1
        lda     #11
        jsr     DebugDrawBlank

; char slot 1
        lda     #$10
        ldy     $0803
        cpy     #$0290
        bcs     :+
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
:       sta     $1e
        jsr     DebugDrawNybble

; char slot 2
        lda     #$10
        ldy     $0805
        cpy     #$0290
        bcs     :+
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
:       sta     $1e
        jsr     DebugDrawNybble

; char slot 3
        lda     #$10
        ldy     $0807
        cpy     #$0290
        bcs     :+
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
:       sta     $1e
        jsr     DebugDrawNybble

; char slot 4
        lda     #$10
        ldy     $0809
        cpy     #$0290
        bcs     :+
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
:       sta     $1e
        jsr     DebugDrawNybble
        lda     #1
        jsr     DebugDrawBlank

; draw party index for each character
        ldy     $00
Loop2:  lda     $1850,y
        and     #$40
        beq     :+
        lda     $1850,y
        and     #$07
        bra     :++
:       lda     #$10
:       sta     $1e
        jsr     DebugDrawNybble
        iny
        cpy     #$0010
        bne     Loop2
        lda     #11
        jsr     DebugDrawBlank
        rts
.endproc  ; DebugDrawPartyInfo

; ------------------------------------------------------------------------------

; [ draw map info (debug) ]

.proc DebugDrawMapInfo
        lda     $46
        and     #%11
        bne     NoMapChange
        lda     $05
        and     #>JOY_START
        beq     :+
        ldx     $1f64                   ; increment map index
        inx
        stx     $1f64
        bra     NoMapChange
:       lda     $05
        and     #>JOY_SELECT
        beq     NoMapChange
        ldx     $1f64                   ; decrement map index
        dex
        stx     $1f64

; draw map index
NoMapChange:
        ldx     a:$0082
        stx     $1e
        jsr     DebugDrawWord

; draw player x,y position
        longa
        ldx     $0803
        lda     $086a,x
        lsr4
        sta     $2a
        sta     $1e
        shorta0
        jsr     DebugDrawByte
        longa
        ldx     $0803
        lda     $086d,x
        lsr4
        sta     $2b
        sta     $1e
        shorta0
        jsr     DebugDrawByte
        lda     #2
        jsr     DebugDrawBlank

; draw tile index at player position
        lda     $aa
        sta     $1e
        jsr     DebugDrawByte

; draw tile properties at player position
        lda     $b8
        sta     $1e
        jsr     DebugDrawBinary

; draw party z-level
        lda     $b2
        sta     $1e
        jsr     DebugDrawByte

; draw max scanline position
        lda     $0632
        sta     $1e
        jsr     DebugDrawByte
        lda     #1
        jsr     DebugDrawBlank

; draw current map index
        ldx     $1f64
        stx     $1e
        jsr     DebugDrawWord

; draw steps for random battle
        ldx     $078c
        stx     $1e
        jsr     DebugDrawWord

; draw number of random battles on this map
        lda     $078b
        sta     $1e
        jsr     DebugDrawByte

; draw number of steps per random battle
        ldx     $078c
        stx     hWRDIVL
        lda     $078b
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        sta     $1e
        jsr     DebugDrawByte

; draw more tile properties
        lda     $b9
        sta     $1e
        jsr     DebugDrawBinary

; draw sprite overlay at player position
        ldx     $2a
        lda     $7f0000,x
        tax
        lda     $0643,x
        sta     $1e
        jsr     DebugDrawByte
        lda     #4
        jsr     DebugDrawBlank
        rts
.endproc  ; DebugDrawMapInfo

.endif

; ------------------------------------------------------------------------------

; [ draw spaces in WRAM buffer (debug) ]

; A: number of spaces to draw

.proc DebugDrawBlank
        tay
:       lda     #DEBUG_BLANK_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        dey
        bne     :-
        rts
.endproc

; ------------------------------------------------------------------------------

; [ draw binary byte, MSB first (debug) ]

.proc DebugDrawBinary
        lda     #DEBUG_BLANK_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        ldy     #8
:       clr_a
        asl     $1e
        adc     #DEBUG_ZERO_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        dey
        bne     :-
        rts
.endproc  ; DebugDrawBinary

; ------------------------------------------------------------------------------

; [ draw binary byte, LSB first (debug) ]

.proc DebugDrawBinaryRev
        lda     #DEBUG_BLANK_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        ldy     #8
:       clr_a
        lsr     $1e
        adc     #DEBUG_ZERO_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        dey
        bne     :-
        rts
.endproc  ; DebugDrawBinaryRev

; ------------------------------------------------------------------------------

; [ draw 4-bit variable (debug) ]

; $1e: variable to draw ($10 draws a blank tile)

.proc DebugDrawNybble
        lda     $1e
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        rts
.endproc  ; DebugDrawNybble

; ------------------------------------------------------------------------------

; [ draw 8-bit variable (debug) ]

; $1e: variable to draw

.proc DebugDrawByte
        lda     #DEBUG_BLANK_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        lda     $1e
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        lda     $1e
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        rts
.endproc  ; DebugDrawByte

; ------------------------------------------------------------------------------

; [ draw 16-bit variable (debug) ]

; +$1e: variable to draw

.proc DebugDrawWord
        lda     #DEBUG_BLANK_CHAR
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        lda     $1f
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        lda     $1f
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
.endproc  ; DebugDrawWord
; fallthrough

; ------------------------------------------------------------------------------

; [ draw half of a 16-bit variable (debug) ]

; $1e: variable to draw

.proc DebugDrawHalfWord
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        lda     $1e
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        lda     $1e
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #DEBUG_TILE_FLAGS
        sta     hWMDATA
        rts
.endproc  ; DebugDrawHalfWord

; ------------------------------------------------------------------------------

; [ display event bit value (debug) ]

.proc DebugDrawEventInfo
        lda     $46
        and     #$03
        bne     DrawSwitches            ; branch 3/4 frames
        lda     $05
        and     #>JOY_START
        beq     :+                      ; check start button
        longa
        lda     $115b                   ; increment event bits shown
        clc
        adc     #$0010
        sta     $115b
        shorta0
        bra     DrawSwitches
:       lda     $05
        and     #>JOY_SELECT
        beq     DrawSwitches
        longa
        lda     $115b                   ; decrement event bits shown
        sec
        sbc     #$0010
        sta     $115b
        shorta0

DrawSwitches:
        lda     #7
        jsr     DebugDrawBlank
        ldx     $115b
        stx     $1e
        jsr     DebugDrawWord
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e80,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     $1e81,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     #2
        jsr     DebugDrawBlank
        lda     #7
        jsr     DebugDrawBlank
        longa_clc
        lda     $115b
        adc     #$0010
        sta     $1e
        shorta0
        jsr     DebugDrawWord
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e82,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     $1e83,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     #2
        jsr     DebugDrawBlank
        rts
.endproc  ; DebugDrawEventInfo

; ------------------------------------------------------------------------------

.if !LANG_EN

; stale code
        .a16
        clc
        adc     #$0010
        sta     $115b
        shorta0
        bra     :+
        lda     $05
        and     #>JOY_SELECT
        beq     :+
        longa
        lda     $115b
        sec
        sbc     #$0010
        sta     $115b
        shorta0
:       lda     #$07
        jsr     $d5fc
        ldx     $115b
        stx     $1e
        jsr     $d686
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e80,x
        sta     $1e
        jsr     DebugDrawHalfWord
        lda     $1e81,x
        sta     $1e
        jsr     DebugDrawHalfWord
        lda     #$02
        jsr     $d5fc
        lda     #$07
        jsr     $d5fc
        longa_clc
        lda     $115b
        adc     #$0010
        sta     $1e
        shorta0
        jsr     $d686
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e82,x
        sta     $1e
        jsr     DebugDrawHalfWord
        lda     $1e83,x
        sta     $1e
        jsr     DebugDrawHalfWord
        lda     #$02
        jsr     $d5fc
        rts

; ------------------------------------------------------------------------------

; stale code
        .byte   $5b,$11
        lsr3
        tax
        shorta0
        lda     $1e80,x
        sta     $1e
        jsr     $d67e
        lda     $1e81,x
        sta     $1e
        jsr     $d67e
        lda     #$02
        jsr     $d651
        lda     #$07
        jsr     $d651
        longa_clc
        lda     $115b
        adc     #$0010
        sta     $1e
        shorta0
        jsr     $d6db
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e82,x
        sta     $1e
        jsr     $d67e
        lda     $1e83,x
        sta     $1e
        jsr     $d67e
        lda     #$02
        jsr     $d651
        rts

.endif

; ------------------------------------------------------------------------------
