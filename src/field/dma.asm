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
.endproc  ; UnusedDMA

; ------------------------------------------------------------------------------

; [ copy sprite data to vram ]

.proc TfrSprites
        stz     hOAMADDL
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
.endproc  ; TfrSprites

; ------------------------------------------------------------------------------

; [ init sprite data ]

.proc ResetSprites
        ldx     #$0200
        lda     #$f0
loop1:  sta     $02fd,x
        dex4
        bne     loop1
        ldx     #$0020
loop2:  stz     $04ff,x
        dex
        bne     loop2
        rts
.endproc  ; ResetSprites

; ------------------------------------------------------------------------------

; [ copy color palettes to vram ]

.proc TfrPal
        stz     hCGADD
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
.endproc  ; TfrPal

; ------------------------------------------------------------------------------
