; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ unused dma ]

; +$2a = source address
; +$3b = vram destination address
; +$39 = size

UnusedDMA:
@0f95:  stz     hVMAINC
        stz     hMDMAEN
        lda     #$41
        sta     $4300
        lda     #<hVMDATAL
        sta     $4301
        lda     $2c
        sta     $4304
        ldx     $3b
        stx     hVMADDL
        ldx     $2a
        stx     $4302
        ldx     $39
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy sprite data to vram ]

TfrSprites:
@0fbf:  stz     hOAMADDL
        stz     hMDMAEN
        lda     #$40
        sta     $4300
        lda     #<hOAMDATA
        sta     $4301
        ldx     #$0300
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init sprite data ]

ResetSprites:
@0fe9:  ldx     #$0200
        lda     #$f0
@0fee:  sta     $02fd,x
        dex4
        bne     @0fee
        ldx     #$0020
@0ffa:  stz     $04ff,x
        dex
        bne     @0ffa
        rts

; ------------------------------------------------------------------------------

; [ copy color palettes to vram ]

TfrPal:
@1001:  stz     hCGADD
        stz     hMDMAEN
        lda     #$42
        sta     $4300
        lda     #$22
        sta     $4301
        ldx     #$7400
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------
