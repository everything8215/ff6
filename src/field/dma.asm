; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ unused dma ]

; +$2a = source address
; +$3b = vram destination address
; +$39 = size

.proc UnusedDMA
        stz     hVMAINC
        stz     hMDMAEN
        lda     #$41
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        lda     $2c
        sta     hDMA0::ADDR_B
        ldx     $3b
        stx     hVMADDL
        ldx     $2a
        stx     hDMA0::ADDR
        ldx     $39
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts
.endproc  ; UnusedDMA

; ------------------------------------------------------------------------------

; [ copy sprite data to vram ]

.proc TfrSprites
        stz     hOAMADDL
        stz     hMDMAEN
        lda     #$40
        sta     hDMA0::CTRL
        lda     #<hOAMDATA
        sta     hDMA0::HREG
        ldx     #$0300
        stx     hDMA0::ADDR
        lda     #$00
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0220
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts
.endproc  ; TfrSprites

; ------------------------------------------------------------------------------

; [ init sprite data ]

.proc ResetSprites
        ldx     #$0200
        lda     #$f0
:       sta     $02fd,x
        dex4
        bne     :-
        ldx     #$0020
:       stz     $04ff,x
        dex
        bne     :-
        rts
.endproc  ; ResetSprites

; ------------------------------------------------------------------------------

; [ copy color palettes to vram ]

.proc TfrPal
        stz     hCGADD
        stz     hMDMAEN
        lda     #$42
        sta     hDMA0::CTRL
        lda     #<hCGDATA
        sta     hDMA0::HREG
        ldx     #$7400
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0200
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts
.endproc  ; TfrPal

; ------------------------------------------------------------------------------
