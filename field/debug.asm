
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

; ------------------------------------------------------------------------------

; tile numbers for digits 0-9 and a-f
DebugHexDigitTbl:
@d386:  .byte   $38,$39,$3a,$3b,$3c,$3d,$3e,$3f
        .byte   $78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$ff

; ------------------------------------------------------------------------------

; [  ]

; unused

_c0d397:
@d397:  ldx     $e5
        cpx     #$0000
        bne     @d3dd
        lda     $e7
        cmp     #$ca
        bne     @d3dd                   ; return if an event is running
        lda     $1868
        cmp     #$10
        bcc     @d3dd                   ; return if less than 16 steps
        ldx     #$004a                  ; $ca004a (invalid event address)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000
        stx     $0594                   ; event stack = $ca0000
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7                   ; event loop count = 1
        ldx     #$0003
        stx     $e8                     ; stack event pointer
        ldy     $0803                   ; party object
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        lda     #$04                    ; movement type 4 (activated)
        sta     $087c,y
@d3dd:  rts

; ------------------------------------------------------------------------------

; [ load text graphics for debug mode ]

DebugLoadGfx:
@d3de:  stz     hMDMAEN                 ; disable dma
        lda     #$80
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     #$39c0                  ; destination = $39c0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #$e120                  ; source = $c0e120 (fixed width font graphics)
        stx     $4302
        lda     #$c0
        sta     $4304
        sta     $4307
        ldx     #$0080                  ; size = $0080
        stx     $4305
        lda     #$01                    ; enable dma
        sta     hMDMAEN
        ldx     #$3bc0                  ; destination = $3bc0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #$e1a0                  ; source = $c0e1a0 (fixed width font graphics)
        stx     $4302
        lda     #$c0
        sta     $4304
        sta     $4307
        ldx     #$0080                  ; size = $0080
        stx     $4305
        lda     #$01                    ; enable dma
        sta     hMDMAEN
        ldx     #$3dc0                  ; destination = $3dc0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #$e220                  ; source = $c0e220 (fixed width font graphics)
        stx     $4302
        lda     #$c0
        sta     $4304
        sta     $4307
        ldx     #$0080                  ; size = $0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN                 ; enable dma
        rts
        rts

; ------------------------------------------------------------------------------

; [  ]

_c0d44f:
@d44f:  lda     $0568
        bne     @d49e                   ; return if dialog is being displayed
        lda     $46
        and     #$07
        bne     @d49e                   ; return 7/8 frames
        lda     $05
        and     #$10
        beq     @d469                   ; branch if start button is not pressed
        ldx     a:$00d0                 ; increment dialog index
        inx
        stx     a:$00d0
        bra     @d476
@d469:  lda     $05
        and     #$20
        beq     @d49e                   ; branch if select button is not pressed
        ldx     a:$00d0                 ; decrement dialog index
        dex
        stx     a:$00d0
@d476:  ldx     a:$00d0
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
@d49e:  rts

; ------------------------------------------------------------------------------

; [ display spaces ]

; a: number of spaces

DebugDrawBlank:
@d49f:  tay
@d4a0:  lda     #$ff                    ; tile $01ff, palette 0, high priority
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        dey
        bne     @d4a0
        rts

; ------------------------------------------------------------------------------

; [ display 8-bit binary value (normal order, msb first) ]

DebugDrawBinary:
@d4ae:  lda     #$ff                    ; tile $01ff, palette 0, high priority
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        ldy     #$0008
@d4bb:  tdc
        asl     $1e
        adc     #$38
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        dey
        bne     @d4bb
        rts

; ------------------------------------------------------------------------------

; [ display 8-bit binary value (reverse order, lsb first) ]

DebugDrawBinaryRev:
@d4cc:  lda     #$ff
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        ldy     #$0008
@d4d9:  tdc
        lsr     $1e
        adc     #$38                    ; 0 or 1
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        dey
        bne     @d4d9
        rts

; ------------------------------------------------------------------------------

; [ display 4-bit value ]

DebugDrawNybble:
@d4ea:  lda     $1e
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ display 8-bit value ]

; $1e: value

DebugDrawByte:
@d4fa:  lda     #$ff
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ display 16-bit value ]

; +$1e: value

DebugDrawWord:
@d529:  lda     #$ff
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1f
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1f
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ display event bit value ]

DebugDrawEventSwitch:
@d57c:  lda     $46
        and     #$03
        bne     @d5ae                   ; branch 3/4 frames
        lda     $05
        and     #$10
        beq     @d599                   ; branch if start button is not pressed
        longa
        lda     $115b                   ; display next 2 event bytes
        clc
        adc     #$0010
        sta     $115b
        shorta0
        bra     @d5ae
@d599:  lda     $05
        and     #$20
        beq     @d5ae                   ; branch if select button is not pressed
        longa
        lda     $115b                   ; display previous 2 event bytes
        sec
        sbc     #$0010
        sta     $115b
        shorta0
@d5ae:  lda     #7
        jsr     DebugDrawBlank
        ldx     $115b
        stx     $1e                     ; event bit address
        jsr     DebugDrawWord
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e80,x                 ; event bit
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     $1e81,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     #2
        jsr     DebugDrawBlank
        lda     #7
        jsr     DebugDrawBlank
        longac
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

; ------------------------------------------------------------------------------
