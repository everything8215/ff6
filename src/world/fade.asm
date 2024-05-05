
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/fade.asm                                                       |
; |                                                                            |
; | description: world map screen fade out routines                            |
; |                                                                            |
; | created: 5/18/2023                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ fade out (no vehicle) ]

FadeOut:
@2292:  php
        phb
        shorta
        clr_a
        pha
        plb
@2299:  lda     $23
        beq     @22a1
        dec
        beq     @22a1
        dec
@22a1:  sta     $23
@22a3:  lda     $24                     ; wait for vblank
        beq     @22a3
        stz     $24
        lda     $23                     ; wait for fade out
        bne     @2299
        lda     $e8
        and     #$7f
        sta     $e8
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ fade out (no vehicle, slow) ]

FadeOutSlow:
@22b6:  php
        phb
        shorta
        clr_a
        pha
        plb
@22bd:  lda     $23
        beq     @22c2
        dec
@22c2:  sta     $23
@22c4:  lda     $24                     ; wait for vblank
        beq     @22c4
        stz     $24
        lda     $23                     ; wait for fade out
        bne     @22bd
        lda     $e8
        and     #$7f
        sta     $e8
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ fade out (vehicle) ]

FadeOutVehicle:
@22d7:  php
        phb
        shorta
        lda     #$00
        pha
        plb
@22df:  lda     $24
        beq     @22df
        stz     $24
@22e5:  shorta
        lda     #$02
        sta     hBGMODE                 ; screen mode 2
        lda     $1f64
        cmp     #$02
        beq     @22f7
        lda     #$03                    ; WoB or WoR
        bra     @22f9
@22f7:  lda     #$83                    ; serpent trench
@22f9:  sta     hCGADSUB
        longa
        lda     #$00e0
        sec
        sbc     $87
        sta     hVTIMEL
        shorta
        lda     $23
        beq     @2311
        dec
        beq     @2311
        dec
@2311:  sta     $23
@2313:  lda     $24                     ; wait for vblank
        beq     @2313
        stz     $24
        lda     $23                     ; wait for fade out
        bne     @22e5
        lda     $e8
        and     #$7f
        sta     $e8
        plb
        plp
        rts

; ------------------------------------------------------------------------------
