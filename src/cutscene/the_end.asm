
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: the_end.asm                                                          |
; |                                                                            |
; | description: code for "THE END" screen with stars                          |
; |                                                                            |
; | created: 12/6/2022                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

.segment "the_end_code"
.a8
.i16

; ------------------------------------------------------------------------------

; [ the end ]

TheEnd_ext:
@f400:  clc
        xce
        shorta
        longi
        lda     #$00
        pha
        plb
        ldx     #$0500                  ; set dp to $0500
        phx
        pld
        lda     #$80                    ; disable interrupts
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        sei
        lda     #$5c                    ; set up interrupt jump code
        sta     $1500
        lda     #<TheEndNMI
        sta     $1501
        lda     #>TheEndNMI
        sta     $1502
        lda     #^TheEndNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        lda     #<TheEndIRQ
        sta     $1505
        lda     #>TheEndIRQ
        sta     $1506
        lda     #^TheEndIRQ
        sta     $1507

; init hardware registers
        lda     #$00
        sta     hOBJSEL
        lda     #$01
        sta     hBGMODE
        lda     #$00
        sta     hMOSAIC
        lda     #$40
        sta     hBG1SC
        lda     #$50
        sta     hBG2SC
        lda     #$60
        sta     hBG3SC
        sta     hBG4SC
        lda     #$00
        sta     hBG12NBA
        sta     hBG34NBA
        lda     #$b6
        sta     hBG1HOFS
        lda     #$00
        sta     hBG1HOFS
        lda     #$a8
        sta     hBG1VOFS
        lda     #$00
        sta     hBG1VOFS
        lda     #$b2
        sta     hBG2HOFS
        lda     #$00
        sta     hBG2HOFS
        lda     #$ad
        sta     hBG2VOFS
        lda     #$00
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
        lda     #$00
        sta     hM7SEL
        sta     hM7A
        sta     hM7A
        sta     hM7B
        sta     hM7B
        sta     hM7C
        sta     hM7C
        sta     hM7D
        sta     hM7D
        sta     hM7X
        sta     hM7X
        sta     hM7Y
        sta     hM7Y
        lda     #$33
        sta     hW12SEL
        lda     #$00
        sta     hW34SEL
        lda     #$08
        sta     hWOBJSEL
        lda     #$4e
        sta     hWH0
        lda     #$b1
        sta     hWH1
        lda     #$00
        sta     hWH2
        sta     hWH3
        lda     #$00
        sta     hWBGLOG
        lda     #$00
        sta     hWOBJLOG
        lda     #$13
        sta     hTM
        lda     #$00
        sta     hTS
        lda     #$13
        sta     hTMW
        lda     #$00
        sta     hTSW
        lda     #$02
        sta     hCGSWSEL
        lda     #$00
        sta     hCGADSUB
        lda     #$e0
        sta     hCOLDATA
        lda     #$00
        sta     hSETINI
        lda     #$ff
        sta     hWRIO
        lda     #$00
        sta     hWRMPYA
        sta     hWRMPYB
        sta     hWRDIVL
        sta     hWRDIVH
        sta     hWRDIVB
        sta     hHTIMEL
        sta     hHTIMEH
        sta     hVTIMEL
        sta     hVTIMEH
        sta     hMDMAEN
        sta     hHDMAEN

; transfer graphics to vram
        lda     #$00
        sta     hVMADDL
        sta     hVMADDH
        lda     #$01
        sta     $4300
        lda     #$18
        sta     $4301
        lda     #<TheEndGfx1
        sta     $4302
        lda     #>TheEndGfx1
        sta     $4303
        lda     #^TheEndGfx1
        sta     $4304
        lda     #$00                    ; size = $0d00
        sta     $4305
        lda     #$0d
        sta     $4306
        lda     #$01
        sta     hMDMAEN
        lda     #<TheEndGfx2
        sta     $4302
        lda     #>TheEndGfx2
        sta     $4303
        lda     #^TheEndGfx2
        sta     $4304
        lda     #$00                    ; size = $0100
        sta     $4305
        lda     #$01
        sta     $4306
        lda     #$01
        sta     hMDMAEN

; transfer palettes to ppu (for bg)
        lda     #$00
        sta     hCGADD
        lda     #$00
        sta     $4300
        lda     #$22
        sta     $4301
        lda     #<TheEndPal
        sta     $4302
        lda     #>TheEndPal
        sta     $4303
        lda     #^TheEndPal
        sta     $4304
        lda     #$00                    ; size = $0100
        sta     $4305
        lda     #$01
        sta     $4306
        lda     #$01
        sta     hMDMAEN

; transfer palettes to ppu (for sprites)
        lda     #$00
        sta     $4300
        lda     #$22
        sta     $4301
        lda     #<TheEndPal
        sta     $4302
        lda     #>TheEndPal
        sta     $4303
        lda     #^TheEndPal
        sta     $4304
        lda     #$00                    ; size = $0100
        sta     $4305
        lda     #$01
        sta     $4306
        lda     #$01
        sta     hMDMAEN

; load star color palette for fade in
        ldx     #0
        txy
@f5fb:  lda     f:TheEndPal+$80,x
        sta     $24
        and     #$1f                    ; isolate red component
        asl2
        sta     $08c0,y                 ; red
        lda     f:TheEndPal+$81,x       ; isolate blue component
        lsr
        ror     $24
        lsr
        ror     $24
        asl2
        sta     $08c4,y                 ; green
        lda     $24
        and     #$f8                    ; isolate green component
        lsr
        sta     $08c2,y                 ; blue
        lda     #$00
        sta     $0800,y                 ; clear current color component values
        sta     $0801,y
        sta     $0802,y
        sta     $0803,y
        sta     $0804,y
        sta     $0805,y
        sta     $0980,x                 ; clear current color palette values
        sta     $0981,x
        iny6                            ; next color (16 colors)
        inx2
        cpx     #$20
        bne     @f5fb

; load the end palette for fade in (same as above)
        ldx     #0
        txy
@f64a:  lda     f:TheEndPal+$60,x
        sta     $24
        and     #$1f
        asl
        sta     $0920,y
        lda     f:TheEndPal+$61,x
        lsr
        ror     $24
        lsr
        ror     $24
        asl
        sta     $0924,y
        lda     $24
        and     #$f8
        lsr2
        sta     $0922,y
        lda     #$00
        sta     $0860,y
        sta     $0861,y
        sta     $0862,y
        sta     $0863,y
        sta     $0864,y
        sta     $0865,y
        sta     $09a0,x
        sta     $09a1,x
        iny6
        inx2
        cpx     #$0020
        bne     @f64a

; copy tilemap to vram
        ldx     #$0000
        lda     #$00
        sta     hVMADDL
        lda     #$40
        sta     hVMADDH
@f6a1:  lda     #$06
        sta     hVMDATAL
        lda     #$24
        sta     hVMDATAH
        inx
        cpx     #$000d
        bne     @f6a1
        ldx     #$0000
        lda     #$20
        sta     hVMADDL
        lda     #$40
        sta     hVMADDH
@f6be:  lda     #$06
        sta     hVMDATAL
        lda     #$24
        sta     hVMDATAH
        inx
        cpx     #$000d
        bne     @f6be
        ldx     #$0000
        lda     #$40
        sta     hVMADDL
        lda     #$40
        sta     hVMADDH
@f6db:  lda     #$06
        sta     hVMDATAL
        lda     #$24
        sta     hVMDATAH
        inx
        cpx     #$000d
        bne     @f6db
        lda     #$60
        sta     hVMADDL
        lda     #$40
        sta     hVMADDH
        lda     #$00
@f6f7:  sta     hVMDATAL
        pha
        lda     #$24
        sta     hVMDATAH
        pla
        inc
        cmp     #$0d
        bne     @f6f7
        lda     #$80
        sta     hVMADDL
        lda     #$40
        sta     hVMADDH
        lda     #$10
@f712:  sta     hVMDATAL
        pha
        lda     #$24
        sta     hVMDATAH
        pla
        inc
        cmp     #$1d
        bne     @f712
        lda     #$a0
        sta     hVMADDL
        lda     #$40
        sta     hVMADDH
        lda     #$20
@f72d:  sta     hVMDATAL
        pha
        lda     #$24
        sta     hVMDATAH
        pla
        inc
        cmp     #$2d
        bne     @f72d
        lda     #$00
        sta     hVMADDL
        lda     #$50
        sta     hVMADDH
        lda     #$30
@f748:  sta     hVMDATAL
        pha
        lda     #$2c
        sta     hVMDATAH
        pla
        inc
        cmp     #$3e
        bne     @f748
        lda     #$20
        sta     hVMADDL
        lda     #$50
        sta     hVMADDH
        lda     #$40
@f763:  sta     hVMDATAL
        pha
        lda     #$2c
        sta     hVMDATAH
        pla
        inc
        cmp     #$4e
        bne     @f763
        lda     #$40
        sta     hVMADDL
        lda     #$50
        sta     hVMADDH
        lda     #$50
@f77e:  sta     hVMDATAL
        pha
        lda     #$2c
        sta     hVMDATAH
        pla
        inc
        cmp     #$5e
        bne     @f77e
        lda     #$60
        sta     hVMADDL
        lda     #$50
        sta     hVMADDH
        lda     #$60
@f799:  sta     hVMDATAL
        pha
        lda     #$2c
        sta     hVMDATAH
        pla
        inc
        cmp     #$6e
        bne     @f799

; init all stars (128 total)
        ldy     #$0200
@f7ab:  jsr     InitTheEndStar
        dey4                            ; next star
        bne     @f7ab
        ldx     #$0020

; clear $1a00-$1a1f ???
@f7b7:  stz     $19ff,x
        dex
        bne     @f7b7

; set up window position hdma table
        lda     #$57
        sta     $1b00
        lda     #$18
        sta     $1b01
        lda     #$10
        sta     $1b02
        lda     #$18
        sta     $1b03
        lda     #$4e
        sta     $1b04
        lda     #$b1
        sta     $1b05
        lda     #$01
        sta     $1b06
        lda     #$18
        sta     $1b07
        lda     #$10
        sta     $1b08
        lda     #$00
        sta     $1b09

; scroll up bg1
        ldx     #2                      ; update bg1 scroll every 2 frames
        stx     $34
        lda     #$02                    ; no effect ???
        sta     $14
        lda     #$80
        sta     hNMITIMEN
        lda     #$a8                    ; set bg1 vertical scroll to $a8
        sta     $40
        stz     $3a                     ; clear bg2 scroll value
        stz     $3b
        lda     #$01                    ; set bg2 scroll counter (for hdma updates)
        sta     $3c
        stz     $00
        stz     $01
        stz     $38
@f80f:  lda     $38                     ; wait for vblank
        beq     @f80f
        lda     #$0f                    ; screen on, full brightness
        sta     hINIDISP
@f818:  lda     $38                     ; wait for vblank
        beq     @f818
        stz     $38
        jsr     ResetTheEndStars
        lda     hAPUIO1
        beq     @f818                   ; wait for spc
@f826:  lda     $38                     ; wait for vblank
        beq     @f826
        stz     $38
        dec     $34
        bne     @f826
        lda     #$02                    ; next 2 frames
        sta     $34
        lda     $40
        sta     hBG1VOFS                ; bg1 vertical scroll
        lda     #$00
        sta     hBG1VOFS
        lda     $40                     ; scroll up to to $c1
        inc
        sta     $40
        cmp     #$c1
        bne     @f826

; fade in "the end"
@f847:  lda     $38                     ; wait for vblank
        beq     @f847
        stz     $38
        jsr     ResetTheEndStars
        lda     #$02
        cmp     hAPUIO1
        bne     @f847
        lda     #$80                    ; 128 frames
        sta     $44
@f85b:  lda     $38                     ; wait for vblank
        beq     @f85b
        stz     $38
        ldx     #$0000
        txy
@f865:  lda     $0920,y                 ; update palette 3 (fade in the end)
        clc
        adc     $0860,y
        sta     $0860,y
        lda     #$00
        adc     $0861,y
        sta     $0861,y
        sta     $28
        lda     $0924,y
        clc
        adc     $0864,y
        sta     $0864,y
        lda     #$00
        adc     $0865,y
        sta     $0865,y
        sta     $09a1,x
        lda     $0922,y
        clc
        adc     $0862,y
        sta     $0862,y
        lda     #$00
        adc     $0863,y
        sta     $0863,y
        asl4
        rol     $09a1,x
        asl
        rol     $09a1,x
        ora     $28
        sta     $09a0,x
        iny6                            ; next color
        inx2
        cpx     #$0020
        bne     @f865
        jsr     ResetTheEndStars
        dec     $44                     ; decrement frame counter
        bne     @f85b

; play song
@f8c4:  lda     $38                     ; wait for vblank
        beq     @f8c4
        stz     $38
        jsr     ResetTheEndStars
        lda     hAPUIO3
        bne     @f8c4
        lda     #$10
        sta     $1300
        lda     #$01                    ; song $01 (the prelude)
        sta     $1301
        lda     #$00
        sta     $1302
        jsl     ExecSound_ext
        lda     #$ff
        sta     $1305
        ldx     #1200                   ; 1200 frames (20 seconds)
        stx     $34
        lda     #64                     ; 64 frames
        sta     $44
@f8f3:  lda     $38                     ; wait for vblank
        beq     @f8f3
        stz     $38
        jsr     ResetTheEndStars
        ldx     $34
        dex
        stx     $34
        bne     @f8f3

; fade in stars
        lda     #$10
        sta     $1300
        lda     #$01                    ; song $01 (the prelude)
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        lda     #64                     ; 64 frames
        sta     $44
@f91a:  lda     $38                     ; wait for vblank
        beq     @f91a
        stz     $38
        ldx     #$0000
        txy
@f924:  lda     $08c0,y                 ; update palette 12 (fade in stars)
        clc
        adc     $0800,y
        sta     $0800,y
        lda     #$00
        adc     $0801,y
        sta     $0801,y
        sta     $28
        lda     $08c4,y
        clc
        adc     $0804,y
        sta     $0804,y
        lda     #$00
        adc     $0805,y
        sta     $0805,y
        sta     $0981,x
        lda     $08c2,y
        clc
        adc     $0802,y
        sta     $0802,y
        lda     #$00
        adc     $0803,y
        sta     $0803,y
        asl4
        rol     $0981,x
        asl
        rol     $0981,x
        ora     $28
        sta     $0980,x
        iny6
        inx2
        cpx     #$0020
        bne     @f924
        jsr     ResetTheEndStars
        dec     $44                     ; decrement frame counter
        bne     @f91a

; loop forever
@f983:  lda     $38                     ; wait for vblank
        beq     @f983
        stz     $38
        jsr     ResetTheEndStars
        bra     @f983                   ; infinite loop

; ------------------------------------------------------------------------------

; [ init star ]

; +Y: pointer to star data

InitTheEndStar:
@f98e:  ldx     $00
        inc     $00
        lda     f:RNGTbl,x
        sta     $02
        and     #$07
        sta     $24
        sta     $0cfc,y                 ; horizontal speed
        lda     $02
        and     #$3f
        clc
        adc     #$60
        sta     $17fc,y                 ; x position
        ldx     $02
        lda     f:RNGTbl,x
        sta     $02
        and     #$07
        bne     @f9b6
        inc
@f9b6:  sta     $0cfd,y                 ; vertical speed
        ora     $24
        sta     $25
        lda     $02
        and     #$1f
        clc
        adc     #$60
        sta     $17fd,y                 ; y position
        ldx     $02
        lda     f:RNGTbl,x
        and     #$3f
        sta     $0afe,y
        and     #$0f
        bne     @f9d7
        inc
@f9d7:  sta     $0cfe,y
        lda     $25
        cmp     #$04
        bcc     @fa06
        lda     $0cfe,y
        cmp     #$07
        bcs     @fa06
        asl
        sta     $0cfe,y
        lda     $0afe,y
        lsr
        sta     $0afe,y
        bra     @fa06
        lda     $0cfe,y
        cmp     #$08
        bcc     @fa06
        lsr
        sta     $0cfe,y
        lda     $0afe,y
        asl
        sta     $0afe,y
@fa06:  lda     #$1f                    ; graphics pointer
        sta     $17fe,y
        lda     #$38                    ; (highest priority, sprite palette 6)
        sta     $17ff,y
        lda     #$00                    ;
        sta     $0cff,y
        rts

; ------------------------------------------------------------------------------

; [ reset invalid stars ]

ResetTheEndStars:
@fa16:  ldy     #$0200
@fa19:  lda     $0cfc,y
        bpl     @fa21                   ; branch if star is valid
        jsr     InitTheEndStar
@fa21:  dey4
        bne     @fa19
        rts

; ------------------------------------------------------------------------------

; [ update bg2 scroll hdma table ]

; +X: scroll value (from $3a, 0..12)

UpdateTheEndHDMA:
@fa28:  lda     #$50
        sta     $1c00
        stz     $1c01
        stz     $1c02
        lda     #$c0
        sta     $1c03
        stz     $05
        txa
        asl
        sta     $04
        ldx     $04
        ldy     #0
@fa43:  lda     f:TheEndHDMATbl,x
        sta     $1c04,y
        inx
        iny
        cpy     #$0040
        bne     @fa43
        lda     #0
        sta     $1c04,y
        rts

; ------------------------------------------------------------------------------

; [ update sprite data ]

DrawTheEndStars:
@fa57:  ldy     #$0080
        lda     $3e
        and     #$03
        asl
        sta     $04
        stz     $05
        ldx     $04
        jsr     (.loword(DrawTheEndStarsTbl),x)
        inc     $3e
        rts

; ------------------------------------------------------------------------------

; [ update sprites 0-31 ]

; +y: pointer to sprite data

DrawTheEndStars_00:
@fa6b:  lda     $17fc,y                 ; x position
        bmi     @fa7d                   ; branch if on right half of screen
        sec
        sbc     $0cfc,y                 ; subtract horizontal speed
        bcs     @fa8a
        lda     #$ff
        sta     $0cfc,y
        bra     @fae4
@fa7d:  clc
        adc     $0cfc,y                 ; add horizontal speed
        bcc     @fa8a
        lda     #$ff
        sta     $0cfc,y
        bra     @fae4
@fa8a:  sta     $17fc,y                 ; set new x position
        lda     $17fd,y                 ; y position
        cmp     #$70
        bcs     @faa1                   ; branch if on bottom half of screen
        sec
        sbc     $0cfd,y                 ; subtract vertical speed
        bcs     @fab0
        lda     #$ff
        sta     $0cfc,y
        bra     @fae4
@faa1:  clc
        adc     $0cfd,y                 ; add vertical speed
        cmp     #$e0
        bcc     @fab0
        lda     #$ff
        sta     $0cfc,y
        bra     @fae4
@fab0:  sta     $17fd,y                 ; set new y position
        lda     $0afe,y                 ;
        clc
        adc     $0cfe,y                 ;
        bcc     @fabe
        lda     #$ff
@fabe:  sta     $0afe,y
        cmp     #$40
        bcc     @fae4
        cmp     #$c0
        bcs     @facd
        lda     #$0f                    ; tile 15
        bra     @fae1
@facd:  cmp     #$f0
        bcs     @fada
        lda     #$01                    ;
        jsr     _e5fc6b
        lda     #$0e                    ; tile 14
        bra     @fae1
@fada:  lda     #$02                    ;
        jsr     _e5fc6b
        lda     #$0d                    ; tile 13
@fae1:  sta     $17fe,y                 ; set graphics pointer
@fae4:  dey4                            ; next sprite
        bne     @fa6b
        rts

; ------------------------------------------------------------------------------

; [ update sprites 32-63 ]

DrawTheEndStars_01:
@faeb:  lda     $187c,y
        bmi     @fafd
        sec
        sbc     $0d7c,y
        bcs     @fb0a
        lda     #$ff
        sta     $0d7c,y
        bra     @fb64
@fafd:  clc
        adc     $0d7c,y
        bcc     @fb0a
        lda     #$ff
        sta     $0d7c,y
        bra     @fb64
@fb0a:  sta     $187c,y
        lda     $187d,y
        cmp     #$70
        bcs     @fb21
        sec
        sbc     $0d7d,y
        bcs     @fb30
        lda     #$ff
        sta     $0d7c,y
        bra     @fb64
@fb21:  clc
        adc     $0d7d,y
        cmp     #$e0
        bcc     @fb30
        lda     #$ff
        sta     $0d7c,y
        bra     @fb64
@fb30:  sta     $187d,y
        lda     $0b7e,y
        clc
        adc     $0d7e,y
        bcc     @fb3e
        lda     #$ff
@fb3e:  sta     $0b7e,y
        cmp     #$40
        bcc     @fb64
        cmp     #$c0
        bcs     @fb4d
        lda     #$0f
        bra     @fb61
@fb4d:  cmp     #$f0
        bcs     @fb5a
        lda     #$01
        jsr     _e5fc88
        lda     #$0e
        bra     @fb61
@fb5a:  lda     #$02
        jsr     _e5fc88
        lda     #$0d
@fb61:  sta     $187e,y
@fb64:  dey4
        bne     @faeb
        rts

; ------------------------------------------------------------------------------

; [ update sprites 64-95 ]

DrawTheEndStars_02:
@fb6b:  lda     $18fc,y
        bmi     @fb7d
        sec
        sbc     $0dfc,y
        bcs     @fb8a
        lda     #$ff
        sta     $0dfc,y
        bra     @fbe4
@fb7d:  clc
        adc     $0dfc,y
        bcc     @fb8a
        lda     #$ff
        sta     $0dfc,y
        bra     @fbe4
@fb8a:  sta     $18fc,y
        lda     $18fd,y
        cmp     #$70
        bcs     @fba1
        sec
        sbc     $0dfd,y
        bcs     @fbb0
        lda     #$ff
        sta     $0dfc,y
        bra     @fbe4
@fba1:  clc
        adc     $0dfd,y
        cmp     #$e0
        bcc     @fbb0
        lda     #$ff
        sta     $0dfc,y
        bra     @fbe4
@fbb0:  sta     $18fd,y
        lda     $0bfe,y
        clc
        adc     $0dfe,y
        bcc     @fbbe
        lda     #$ff
@fbbe:  sta     $0bfe,y
        cmp     #$40
        bcc     @fbe4
        cmp     #$c0
        bcs     @fbcd
        lda     #$0f
        bra     @fbe1
@fbcd:  cmp     #$f0
        bcs     @fbda
        lda     #$01
        jsr     _e5fca5
        lda     #$0e
        bra     @fbe1
@fbda:  lda     #$02
        jsr     _e5fca5
        lda     #$0d
@fbe1:  sta     $18fe,y
@fbe4:  dey4
        bne     @fb6b
        rts

; ------------------------------------------------------------------------------

; [ update sprites 96-127 ]

DrawTheEndStars_03:
@fbeb:  lda     $197c,y
        bmi     @fbfd
        sec
        sbc     $0e7c,y
        bcs     @fc0a
        lda     #$ff
        sta     $0e7c,y
        bra     @fc64
@fbfd:  clc
        adc     $0e7c,y
        bcc     @fc0a
        lda     #$ff
        sta     $0e7c,y
        bra     @fc64
@fc0a:  sta     $197c,y
        lda     $197d,y
        cmp     #$70
        bcs     @fc21
        sec
        sbc     $0e7d,y
        bcs     @fc30
        lda     #$ff
        sta     $0e7c,y
        bra     @fc64
@fc21:  clc
        adc     $0e7d,y
        cmp     #$e0
        bcc     @fc30
        lda     #$ff
        sta     $0e7c,y
        bra     @fc64
@fc30:  sta     $197d,y
        lda     $0c7e,y
        clc
        adc     $0e7e,y
        bcc     @fc3e
        lda     #$ff
@fc3e:  sta     $0c7e,y
        cmp     #$40
        bcc     @fc64
        cmp     #$c0
        bcs     @fc4d
        lda     #$0f
        bra     @fc61
@fc4d:  cmp     #$f0
        bcs     @fc5a
        lda     #$01
        jsr     _e5fcc2
        lda     #$0e
        bra     @fc61
@fc5a:  lda     #$02
        jsr     _e5fcc2
        lda     #$0d
@fc61:  sta     $197e,y
@fc64:  dey4
        bne     @fbeb
        rts

; ------------------------------------------------------------------------------

; [ ??? sprites 0-31 ]

_e5fc6b:
@fc6b:  cmp     $0cff,y
        beq     @fc87
        sta     $0cff,y
        lda     $0cfc,y
        lsr
        adc     $0cfc,y
        sta     $0cfc,y
        lda     $0cfd,y
        lsr
        adc     $0cfd,y
        sta     $0cfd,y
@fc87:  rts

; ------------------------------------------------------------------------------

; [ ??? sprites 32-63 ]

_e5fc88:
@fc88:  cmp     $0d7f,y
        beq     @fca4
        sta     $0d7f,y
        lda     $0d7c,y
        lsr
        adc     $0d7c,y
        sta     $0d7c,y
        lda     $0d7d,y
        lsr
        adc     $0d7d,y
        sta     $0d7d,y
@fca4:  rts

; ------------------------------------------------------------------------------

; [ ??? sprites 64-95 ]

_e5fca5:
@fca5:  cmp     $0dff,y
        beq     @fcc1
        sta     $0dff,y
        lda     $0dfc,y
        lsr
        adc     $0dfc,y
        sta     $0dfc,y
        lda     $0dfd,y
        lsr
        adc     $0dfd,y
        sta     $0dfd,y
@fcc1:  rts

; ------------------------------------------------------------------------------

; [ ??? sprites 96-127 ]

_e5fcc2:
@fcc2:  cmp     $0e7f,y
        beq     @fcde
        sta     $0e7f,y
        lda     $0e7c,y
        lsr
        adc     $0e7c,y
        sta     $0e7c,y
        lda     $0e7d,y
        lsr
        adc     $0e7d,y
        sta     $0e7d,y
@fcde:  rts

; ------------------------------------------------------------------------------

; [ the end nmi ]

TheEndNMI:
@fcdf:  phb
        phd
        php
        longa
        longi
        pha
        phx
        phy
        shorta
        lda     #$00
        pha
        plb
        ldx     #$0500                  ; set dp to $0500
        phx
        pld
        lda     #$10
        lda     #$00
        sta     hHDMAEN
        lda     #$00
        sta     hOAMADDL
        sta     hOAMADDH
        lda     #$00
        sta     $4300
        lda     #<hOAMDATA              ; $1800 -> $2104 (sprite data)
        sta     $4301
        lda     #$00
        sta     $4302
        lda     #$18
        sta     $4303
        lda     #$00
        sta     $4304
        lda     #$20                    ; copy $0200 bytes
        sta     $4305
        lda     #$02
        sta     $4306
        lda     #$00
        sta     $4307
        lda     #$01
        sta     hMDMAEN

; update palette 12
        lda     #$c0
        sta     hCGADD
        lda     #$00
        sta     $4300
        lda     #<hCGDATA               ; $0980 -> $2122 (palette data)
        sta     $4301
        lda     #$80
        sta     $4302
        lda     #$09
        sta     $4303
        lda     #$00
        sta     $4304
        lda     #$20                    ; copy 32 bytes (16 colors)
        sta     $4305
        lda     #$00
        sta     $4306
        lda     #$00
        sta     $4307
        lda     #$01
        sta     hMDMAEN

; update palette 3
        lda     #$30
        sta     hCGADD
        lda     #$00
        sta     $4300
        lda     #<hCGDATA               ; $09a0 -> $2122 (palette data)
        sta     $4301
        lda     #$a0
        sta     $4302
        lda     #$09
        sta     $4303
        lda     #$00
        sta     $4304
        lda     #$20                    ; copy 32 bytes (16 colors)
        sta     $4305
        lda     #$00
        sta     $4306
        lda     #$00
        sta     $4307
        lda     #$01
        sta     hMDMAEN

        jsr     DrawTheEndStars
        inc     $38                     ; set vblank flag
        dec     $3c                     ; decrement bg2 scroll counter
        bne     @fdb1
        lda     #$06
        sta     $3c
        ldx     $3a
        jsr     UpdateTheEndHDMA
        lda     $3a                     ; increment bg2 scroll value
        inc
        cmp     #$0c
        bcc     @fdaf
        lda     #$00
@fdaf:  sta     $3a
@fdb1:  lda     #$01                    ; set up hdma channel #7
        sta     $4370                   ; $1b00 -> $2126 (window 1 position)
        lda     #<hWH0
        sta     $4371
        lda     #$00
        sta     $4372
        lda     #$1b
        sta     $4373
        lda     #$00
        sta     $4374
        sta     $4377
        lda     #$01                    ; set up hdma channel #6
        sta     $4360                   ; $1b00 -> $2128 (window 2 position)
        lda     #<hWH2
        sta     $4361
        lda     #$00
        sta     $4362
        lda     #$1b
        sta     $4363
        lda     #$00
        sta     $4364
        sta     $4367
        lda     #$02                    ; set up hdma channel #5
        sta     $4350                   ; $1c00 -> $2110 (bg2 vertical scroll)
        lda     #<hBG2VOFS
        sta     $4351
        lda     #$00
        sta     $4352
        lda     #$1c
        sta     $4353
        lda     #$00
        sta     $4354
        sta     $4357
        lda     #$e0
        sta     hHDMAEN                 ; enable hdma channels #5, #6, #7
        longa
        longi
        ply
        plx
        pla
        plp
        pld
        plb
        rti

; ------------------------------------------------------------------------------

; [ the end irq ]

TheEndIRQ:
@fe15:  rti

; ------------------------------------------------------------------------------

; sprite data update jump table
DrawTheEndStarsTbl:
@fe16:  .addr   DrawTheEndStars_00
        .addr   DrawTheEndStars_01
        .addr   DrawTheEndStars_02
        .addr   DrawTheEndStars_03

; ------------------------------------------------------------------------------

; bg2 scroll hdma data
TheEndHDMATbl:
@fe1e:  .word   $00ac,$00ad,$00ae,$00ae,$00ae,$00ad,$00ac,$00ab
        .word   $00aa,$00aa,$00aa,$00ab,$00ac,$00ad,$00ae,$00ae
        .word   $00ae,$00ad,$00ac,$00ab,$00aa,$00aa,$00aa,$00ab
        .word   $00ac,$00ad,$00ae,$00ae,$00ae,$00ad,$00ac,$00ab
        .word   $00aa,$00aa,$00aa,$00ab,$00ac,$00ad,$00ae,$00ae
        .word   $00ae,$00ad,$00ac,$00ab,$00aa,$00aa,$00aa,$00ab
        .word   $00ac,$00ad,$00ae,$00ae,$00ae,$00ad,$00ac,$00ab
        .word   $00aa,$00aa,$00aa,$00ab,$00ac,$00ad,$00ae,$00ae
        .word   $00ae,$00ad,$00ac,$00ab,$00aa,$00aa,$00aa,$00ab
        .word   $00ac,$00ad,$00ae,$00ae,$00ae,$00ad,$00ac,$00ab
        .word   $00aa,$00aa,$00aa,$00ab

; ------------------------------------------------------------------------------
