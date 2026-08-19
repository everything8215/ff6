; ------------------------------------------------------------------------------

; [ clear bg tile data in vram ]

; +X: destination (vram)
; +Y: size (words)

InitMenuTiles:
@1916:  phx
        ldx     #$00ee      ; tile $00ee
        stx     $10
        plx
        bra     _192f

InitBGTiles:
@191f:  phx
        ldx     #$02ee      ; tile $02ee
        stx     $10
        plx
        bra     _192f

; unused
_c11928:
@1928:  phx
        ldx     #$01ee      ; tile $01ee
        stx     $10
        plx

_192f:  phb
        lda     #$00
        pha
        plb
        stx     hVMADDL
        longa
        lda     $10
@193b:  sta     hVMDATAL
        dey
        bne     @193b
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------

; [ clear vram ]

; +Y: address
; +X: size (words)

ClearVRAM:
@1946:  phb
        lda     #$00
        pha
        plb
        sty     hVMADDL
        stx     hDMA7::SIZE
        ldx     #near @Zero
        stx     hDMA7::ADDR
        lda     #$09                    ; fixed address, 2 bytes lh
        sta     hDMA7::CTRL
        lda     #<hVMDATAL
        sta     hDMA7::HREG
        lda     #^@Zero
        sta     hDMA7::ADDR_B
        lda     #BIT_7
        sta     hMDMAEN
        plb
        rts

; zero word for clearing vram
@Zero:
@196d:  .word   0

; ------------------------------------------------------------------------------

; [ large data dma to vram (partial) ]

PartialTfrVRAM:
@196f:  lda     near w7e8000            ; branch if large data transfer is disabled
        beq     @1988
        ldx     near w7e8006            ; set size
        stx     $36
        ldx     near w7e8001
        ldy     near w7e8004
        lda     near w7e8001_B
        jsr     TfrVRAM
        stz     near w7e8000
@1988:  rts

; ------------------------------------------------------------------------------

; [ init large data dma to vram (long access) ]

WaitTfrVRAM_far:
@1989:  jsr     WaitTfrVRAM
        rtl

; ------------------------------------------------------------------------------

; [ init large data dma to vram (> 1kb) ]

;    A: source bank
;   +X: source address
;   +Y: destination address (vram)
; +$10: total size (data gets transferred in chunks, 1kb per frame)

WaitTfrVRAM:
@198d:  phx
        phy
        pha
        ldx     $10
        phx
@1993:  lda     near w7e8000       ; branch if large data dma is not in use
        beq     @199d
        jsr     WaitFrame
        bra     @1993       ; loop
@199d:  plx
        stx     near w7e8008       ; set dma size
        pla
        sta     near w7e8001_B       ; set source bank
        ply
        sty     near w7e8004       ; set destination address
        plx
        stx     near w7e8001       ; set source address
        stz     near w7e800a       ; last chunk
@19b0:  longa
        lda     near w7e8008       ; branch if size is <= $0400 (1kb)
        cmp     #$0400
        beq     @19c4
        bcc     @19c4
        lda     #$0400      ; partial size $0400
        sta     near w7e8006
        bra     @19ca
@19c4:  sta     near w7e8006       ; transfer full size
        inc     near w7e800a       ; not last chunk
@19ca:  shorta0
        inc     near w7e8000       ; enable dma
@19d0:  jsr     WaitFrame
        lda     near w7e8000       ; loop if dma is still enabled
        bne     @19d0
        longa
        lda     near w7e8001       ; add $0400 to source address
        clc
        adc     #$0400
        sta     near w7e8001
        lda     near w7e8004       ; add $0200 to destination address
        clc
        adc     #$0200
        sta     near w7e8004
        lda     near w7e8008       ; subtract $0400 from size
        sec
        sbc     #$0400
        sta     near w7e8008
        shorta0
        lda     near w7e800a       ; loop if not last chunk
        beq     @19b0
        rts

; ------------------------------------------------------------------------------

; bit masks
BitOrTbl:
        .byte   %00000001
        .byte   %00000010
        .byte   %00000100
        .byte   %00001000
        .byte   %00010000
        .byte   %00100000
        .byte   %01000000
        .byte   %10000000

; ------------------------------------------------------------------------------

; [ get bit mask ]

; A = 1 << A (out)

GetBitMask:
@1a09:  tax
        lda     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get bit number ]

; returns the number of the first bit set in a (0 if no bits are set)

GetBitNum:
bit_num_chg:
@1a0f:  ldx     zZero
@1a11:  lsr
        bcs     @1a1c
        inx
        cpx     #8
        bne     @1a11
        clr_a
        rts
@1a1c:  txa
        and     #$07
        rts

; ------------------------------------------------------------------------------

; [ wait for vblank (unused) ]

@1a20:  jsr     WaitVblank
        rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVblank:
@1a24:  inc     zVBlankState
@1a26:  lda     zVBlankState
        bne     @1a26       ; brach if not clear
        rts

; ------------------------------------------------------------------------------

; [ copy data to vram (during NMI, for small data) ]

;   +Y: destination address (vram)
;   +X: source address
;    A: source bank
; +$36: size

TfrVRAM:
@1a2b:  phb
        pha
        lda     #$00
        pha
        plb
        pla
        sty     hVMADDL
        stx     hDMA7::ADDR
        sta     hDMA7::ADDR_B
        lda     #$01
        sta     hDMA7::CTRL
        lda     #$18
        sta     hDMA7::HREG
        ldx     $36
        stx     hDMA7::SIZE
        lda     #BIT_7
        sta     hMDMAEN
        plb
        rts

; ------------------------------------------------------------------------------

; [ copy animation bg tile data to vram ]

;   +X: source address
;    A: source bank
; +$36: vram destination address

_c11a51:
@1a51:  phb
        pha
        lda     #$00
        pha
        plb
        pla
        stx     hDMA7::ADDR
        sta     hDMA7::ADDR_B
        lda     #$01
        sta     hDMA7::CTRL
        lda     #$18
        sta     hDMA7::HREG
        longa
        shorti
        ldy     #$20        ; 32 bytes per dma
        ldx     #BIT_7
        lda     #$0010      ; dma 16 times
        sta     $38
        lda     $36
@1a77:  sta     hVMADDL
        sty     hDMA7::SIZE
        stx     hMDMAEN
        clc
        adc     #$0020
        dec     $38
        bne     @1a77
        shorta0
        longi
        plb
        rts

; ------------------------------------------------------------------------------
