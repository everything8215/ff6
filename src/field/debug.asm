
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

.if LANG_EN

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

; ------------------------------------------------------------------------------

.else

@d381:  lda     #$08
        jsr     $d576
        ldy     $00
@d388:  lda     $0868,y
        and     #$06
        lsr
        sta     $1e
        jsr     $d5c1
        longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @d388
        lda     #$28
        jsr     $d576
        rts
        ldy     $1189
        sty     $1e
        jsr     $d600
        ldy     $118f
        sty     $1e
        jsr     $d600
        ldy     $1195
        sty     $1e
        jsr     $d600
        ldy     $119b
        sty     $1e
        jsr     $d600
        lda     #$2a
        jsr     $d576
        rts

; ------------------------------------------------------------------------------

@d3ce:  lda     #$01
        jsr     $d576
        lda     $1a6d
        sta     $1e
        jsr     $d5c1
        lda     #$04
        jsr     $d576
        ldy     $00
@d3e2:  lda     $1850,y
        and     #$40
        beq     @d3ec
        tya
        bra     @d3ee
@d3ec:  lda     #$10
@d3ee:  sta     $1e
        jsr     $d5c1
        iny
        cpy     #$0010
        bne     @d3e2
        lda     #$0b
        jsr     $d576
        lda     #$10
        ldy     $0803
        cpy     #$0290
        bcs     @d41a
        sty     $4204
        lda     #$29
        sta     $4206
        nop7
        lda     $4214
@d41a:  sta     $1e
        jsr     $d5c1
        lda     #$10
        ldy     $0805
        cpy     #$0290
        bcs     @d43b
        sty     $4204
        lda     #$29
        sta     $4206
        nop7
        lda     $4214
@d43b:  sta     $1e
        jsr     $d5c1
        lda     #$10
        ldy     $0807
        cpy     #$0290
        bcs     @d45c
        sty     $4204
        lda     #$29
        sta     $4206
        nop7
        lda     $4214
@d45c:  sta     $1e
        jsr     $d5c1
        lda     #$10
        ldy     $0809
        cpy     #$0290
        bcs     @d47d
        sty     $4204
        lda     #$29
        sta     $4206
        nop7
        lda     $4214
@d47d:  sta     $1e
        jsr     $d5c1
        lda     #$01
        jsr     $d576
        ldy     $00
@d489:  lda     $1850,y
        and     #$40
        beq     @d497
        lda     $1850,y
        and     #$07
        bra     @d499
@d497:  lda     #$10
@d499:  sta     $1e
        jsr     $d5c1
        iny
        cpy     #$0010
        bne     @d489
        lda     #$0b
        jsr     $d576
        rts
        lda     $46
        and     #$03
        bne     @d4cc
        lda     $05
        and     #$10
        beq     @d4bf
        ldx     $1f64
        inx
        stx     $1f64
        bra     @d4cc
@d4bf:  lda     $05
        and     #$20
        beq     @d4cc
        ldx     $1f64
        dex
        stx     $1f64
@d4cc:  ldx     a:$0082
        stx     $1e
        jsr     $d600
        longa
        ldx     $0803
        lda     $086a,x
        lsr4
        sta     $2a
        sta     $1e
        shorta0
        jsr     $d5d1
        longa
        ldx     $0803
        lda     $086d,x
        lsr4
        sta     $2b
        sta     $1e
        shorta0
        jsr     $d5d1
        lda     #$02
        jsr     $d576
        lda     $aa
        sta     $1e
        jsr     $d5d1
        lda     $b8
        sta     $1e
        jsr     $d585
        lda     $b2
        sta     $1e
        jsr     $d5d1
        lda     $0632
        sta     $1e
        jsr     $d5d1
        lda     #$01
        jsr     $d576
        ldx     $1f64
        stx     $1e
        jsr     $d600
        ldx     $078c
        stx     $1e
        jsr     $d600
        lda     $078b
        sta     $1e
        jsr     $d5d1
        ldx     $078c
        stx     $4204
        lda     $078b
        sta     $4206
        nop7
        lda     $4214
        sta     $1e
        jsr     $d5d1
        lda     $b9
        sta     $1e
        jsr     $d585
        ldx     $2a
        lda     $7f0000,x
        tax
        lda     $0643,x
        sta     $1e
        jsr     $d5d1
        lda     #$04
        jsr     $d576
        rts

; ------------------------------------------------------------------------------

@d576:  tay
@d577:  lda     #$ff
        sta     $2180
        lda     #$21
        sta     $2180
        dey
        bne     @d577
        rts

; ------------------------------------------------------------------------------

@d585:  lda     #$ff
        sta     $2180
        lda     #$21
        sta     $2180
        ldy     #$0008
@d592:  tdc
        asl     $1e
        adc     #$38
        sta     $2180
        lda     #$21
        sta     $2180
        dey
        bne     @d592
        rts

; ------------------------------------------------------------------------------

@d5a3:  lda     #$ff
        sta     $2180
        lda     #$21
        sta     $2180
        ldy     #$0008
@d5b0:  tdc
        lsr     $1e
        adc     #$38
        sta     $2180
        lda     #$21
        sta     $2180
        dey
        bne     @d5b0
        rts

; ------------------------------------------------------------------------------

@d5c1:  lda     $1e
        tax
        lda     $c0d2b8,x
        sta     $2180
        lda     #$21
        sta     $2180
        rts

; ------------------------------------------------------------------------------

@d5d1:  lda     #$ff
        sta     $2180
        lda     #$21
        sta     $2180
        lda     $1e
        lsr4
        tax
        lda     $c0d2b8,x
        sta     $2180
        lda     #$21
        sta     $2180
        lda     $1e
        and     #$0f
        tax
        lda     $c0d2b8,x
        sta     $2180
        lda     #$21
@d5fc:  sta     $2180
        rts

; ------------------------------------------------------------------------------

@d600:  lda     #$ff
        sta     $2180
        lda     #$21
        sta     $2180
        lda     $1f
        lsr4
        tax
        lda     $c0d2b8,x
        sta     $2180
        lda     #$21
        sta     $2180
        lda     $1f
        and     #$0f
        tax
        lda     $c0d2b8,x
        sta     $2180
@d629:  lda     #$21
        sta     $2180
        lda     $1e
        lsr4
        tax
        lda     $c0d2b8,x
        sta     $2180
        lda     #$21
        sta     $2180
        lda     $1e
        and     #$0f
        tax
        lda     $c0d2b8,x
        sta     $2180
        lda     #$21
        sta     $2180
        rts

; ------------------------------------------------------------------------------

@d653:  lda     $46
        and     #$03
        bne     @d685
        lda     $05
        and     #$10
        beq     @d670
        longa
        lda     $115b
        clc
        adc     #$0010
        sta     $115b
        shorta0
        bra     @d685
@d670:  lda     $05
        and     #$20
        beq     @d685
        longa
        lda     $115b
        sec
        sbc     #$0010
        sta     $115b
        shorta0
@d685:  lda     #$07
        jsr     $d576
        ldx     $115b
        stx     $1e
        jsr     $d600
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e80,x
        sta     $1e
        jsr     $d5a3
        lda     $1e81,x
        sta     $1e
        jsr     $d5a3
        lda     #$02
        jsr     $d576
        lda     #$07
        jsr     $d576
        longa_clc
        lda     $115b
        adc     #$0010
        sta     $1e
        shorta0
        jsr     $d600
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e82,x
        sta     $1e
        jsr     $d5a3
        lda     $1e83,x
        sta     $1e
        jsr     $d5a3
        lda     #$02
        jsr     $d576
        rts

; ------------------------------------------------------------------------------

        .a16
@d6ea:  clc
        adc     #$0010
        sta     $115b
        shorta0
        bra     @d70b
        lda     $05
        and     #$20
        beq     @d70b
        longa
        lda     $115b
        sec
        sbc     #$0010
        sta     $115b
        shorta0
@d70b:  lda     #$07
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
        jsr     $d629
        lda     $1e81,x
        sta     $1e
        jsr     $d629
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
        jsr     $d629
        lda     $1e83,x
        sta     $1e
        jsr     $d629
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
