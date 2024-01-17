
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/interrupt.asm                                                  |
; |                                                                            |
; | description: world map interrupt routines                                  |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ world nmi (w/ vehicle) ]

VehicleNMI:
@a509:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        shorta
        tdc
        pha
        plb
        inc     a:$0024                 ; vblank flag
        cmp     hRDNMI
        jsl     IncGameTime_ext

; transfer character graphics to vram
        lda     $f7
        ldx     #$6f00
        jsl     LoadMapCharGfx_ext

; transfer vertically scrolling tilemap buffer to vram
        ldx     $44
        bmi     @a555
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6d50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0100
        stx     $4305
        lda     #$00
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        bra     @a5a4

; transfer horizontally scrolling tilemap buffer to vram
@a555:  ldx     $46
        bmi     @a5a4
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6e50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        ldx     $46
        inx
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6ed0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN

; transfer color palettes to ppu
@a5a4:  stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; set scrolling registers and mode7 registers
        longa
        lda     $34
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     $38
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     $34
        sta     hM7X
        lda     $35
        sta     hM7X
        lda     $38
        sta     hM7Y
        lda     $39
        sta     hM7Y

; copy sprite data to ppu
        stz     $4300
        lda     #$04
        sta     $4301
        ldx     #$6b30
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; copy animated water tiles to ppu
        lda     f:$001f64
        cmp     #$02
        beq     @a674                   ; branch if serpent trench
        lda     #$80
        sta     hVMAINC
        ldx     #$1100
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b750
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$1500
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b7d0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; this section has no effect
@a674:  lda     $e7
        bit     #$01
        bne     @a680
        lda     $20
        cmp     #$01
        bne     @a680

; set screen brightness
@a680:  shorta
        lda     $23
        bne     @a688
        lda     #$80
@a688:  sta     hINIDISP

; enable hdma channels
        stz     $fa
        lda     $e9
        bit     #$01
        beq     @a699
        lda     $fa
        ora     #$04                    ; enable hdma channel #2 (fixed color)
        sta     $fa
@a699:  lda     $e9
        bit     #$02
        beq     @a6a5
        lda     $fa
        ora     #$08                    ; enable hdma channel #3 (window)
        sta     $fa
@a6a5:  lda     #$f2                    ; enable all except #2 and #3
        ora     $fa
        sta     hHDMAEN
        pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------

; [ world irq (airship) ]

AirshipIRQ:
@a6b7:  php
        longa
        pha
        phb
        shorta
        tdc
        pha
        plb
        cmp     hTIMEUP                 ; reset irq flag
        lda     #$07
        sta     hBGMODE                 ; change to mode 7
        plb
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ world irq (chocobo) ]

ChocoIRQ:
@a6cf:  php
        longa
        pha
        phb
        shorta
        tdc
        pha
        plb
        cmp     hTIMEUP                 ; reset irq flag
@a6dc:  lda     hHVBJOY                 ; wait for hblank
        bit     #$40
        bne     @a6dc
        cmp     hSLHV                   ; latch h/v counter
        lda     hOPVCT
        cmp     hOPVCT
        cmp     #$90
        bcs     @a6fc

; 1st irq (at bg mode transition)
        lda     #$9c
        sta     hVTIMEL
        lda     #$07
        sta     hBGMODE
        bra     @a701

; 2nd irq (scanline 156)
@a6fc:  lda     #$63
        sta     hCGADSUB
@a701:  plb
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ vector approach irq ]

VectorApproachIRQ:
@a707:  php
        longa
        pha
        shorta
        cmp     f:hTIMEUP
        lda     #$07
        sta     f:hBGMODE
        lda     #$02
        sta     f:hCGSWSEL
        lda     #$a3
        sta     f:hCGADSUB
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ world nmi (no vehicle) ]

WorldNMI:
@a728:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        shorta
        tdc
        pha
        plb
        inc     a:$0024                 ; vblank flag
        cmp     hRDNMI
        jsl     IncGameTime_ext

        lda     $e8
        bit     #$20
        jne     @a8d2                   ; no vram transfers
        bit     #$80
        jne     @a8c7

; transfer character graphics to vram
        lda     $f7
        ldx     #$6f00
        jsl     LoadMapCharGfx_ext

; transfer horizontally scrolling tilemap buffer to vram
        ldx     $44
        bmi     @a784
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6d50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0100
        stx     $4305
        lda     #$00
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        bra     @a7d3

; transfer vertically scrolling tilemap buffer to vram
@a784:  ldx     $46
        bmi     @a7d3
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6e50
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN
        ldx     $46
        inx
        stx     hVMADDL
        ldx     #$1800
        stx     $4300
        ldx     #$6ed0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$02
        sta     hVMAINC
        lda     #$01
        sta     hMDMAEN

; transfer color palettes to ppu
@a7d3:  stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; set scrolling registers and mode7 registers
        longa
        lda     $34
        clc
        adc     #$0008
        and     #$0fff
        sta     a:$00fa
        lda     $38
        sec
        sbc     #$0002
        and     #$0fff
        sta     a:$00fc
        lda     a:$00fa
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     a:$00fc
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     a:$00fa
        sta     hM7X
        lda     a:$00fb
        sta     hM7X
        lda     a:$00fc
        sta     hM7Y
        lda     a:$00fd
        sta     hM7Y

; copy sprite data to ppu
        stz     $4300
        lda     #$04
        sta     $4301
        ldx     #$6b30
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; copy animated water tiles to ppu
        lda     #$80
        sta     hVMAINC
        ldx     #$1100
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b750
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #$1500
        stx     hVMADDL
        ldx     #$1900
        stx     $4300
        ldx     #$b7d0
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN

; enable hdma channels
        lda     #$f0
        sta     hHDMAEN

; set screen brightness
        lda     $23
        bne     @a8c4
        lda     #$80
@a8c4:  sta     hINIDISP
@a8c7:  pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; same as above without any vram transfers

; set scrolling registers and mode7 registers
@a8d2:  longa
        lda     $34
        clc
        adc     #$0008
        and     #$0fff
        sta     a:$00fa
        lda     $38
        sec
        sbc     #$0002
        and     #$0fff
        sta     a:$00fc
        lda     a:$00fa
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     a:$00fc
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     a:$00fa
        sta     hM7X
        lda     a:$00fb
        sta     hM7X
        lda     a:$00fc
        sta     hM7Y
        lda     a:$00fd
        sta     hM7Y

; enable hdma channels
        lda     #$f0
        sta     hHDMAEN
        jmp     @a8c7

; ------------------------------------------------------------------------------

; [ world irq (no vehicle) ]

WorldIRQ:
@a93a:  php
        longa
        pha
        phb
        shorta
        tdc
        pha
        plb
        cmp     hTIMEUP
        plb
        longa
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ magitek train ride nmi ]

TrainNMI:
@a94d:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        lda     #$0000
        tcd
        shorta
        tdc
        pha
        plb
        cmp     hRDNMI                  ; clear nmi
        inc     a:$00fa                 ; increment 4 frame counter
        jsl     IncGameTime_ext
        lda     #$02
        stz     hM7X                    ; m7x = $0200
        sta     hM7X
        lda     #$e0
        sta     hM7Y                    ; m7y = $01e0
        lda     #$01
        sta     hM7Y
        lda     $3d
        sta     hM7A
        lda     $3e
        sta     hM7A
        lda     $3f
        sta     hM7B
        lda     $40
        sta     hM7B
        lda     $41
        sta     hM7C
        lda     $42
        sta     hM7C
        lda     $3d
        sta     hM7D
        lda     $3e
        sta     hM7D
        lda     $24                     ;
        bne     @a9e0
        stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000                  ; source = $7ee000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200                  ; size = $0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        shorta
        lda     #$80
        sta     hBG1HOFS                ; bg1 horizontal scroll
        lda     #$01
        sta     hBG1HOFS
        lda     #$70
        sta     hBG1VOFS                ; bg1 vertical scroll
        lda     #$01
        sta     hBG1VOFS
        jmp     @aa1c
@a9e0:  stz     hVMAINC
        ldx     #$a618                  ; source = $7fa618 (last $3e00 of graphics)
        ldy     #$1318                  ; destination = $1318 (vram)
@a9e9:  shorta
        sty     hVMADDL
        stz     $4300
        lda     #$18
        sta     $4301
        stx     $4302
        lda     #$7f
        sta     $4304
        lda     #$50                    ; size = $0050
        sta     $4305
        stz     $4306
        lda     #$01
        sta     hMDMAEN
        longa_clc
        tya
        adc     #$0080
        tay
        txa
        adc     #$0100
        tax
        cmp     #$e418
        bne     @a9e9
@aa1c:  shorta
        stz     $fe                     ;
        lda     #$10
        sta     hVTIMEL                 ; vertical irq counter = 16
        lda     #$b1
        sta     hNMITIMEN               ; enable interrupts
        pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------

; [ magitek train ride irq ]

TrainIRQ:
@aa35:  php
        longai
        pha
        phx
        phy
        phb
        shorta
        lda     #$00
        pha
        plb
        cmp     hTIMEUP                 ; clear irq
        lda     a:$00fe
        bne     @aa5a
        inc     a:$00fe
        lda     #$d0
        sta     hVTIMEL                 ; vertical irq counter = 208
        lda     a:$0023
        sta     hINIDISP                ; set screen brightness
        bra     @aaa5
@aa5a:  lda     #$81
        sta     hNMITIMEN               ; disable irq
        lda     #$80
        sta     hINIDISP                ; screen off
        lda     a:$0024
        beq     @aaa5                   ; return if not in vblank
        stz     hVMAINC
        ldx     #$9618                  ; source = $7f9618 (first $1000 bytes of graphics)
        ldy     #$0b18                  ; destination = $0b18 (vram)
@aa72:  shorta
        sty     hVMADDL
        stz     $4300
        lda     #$18
        sta     $4301
        stx     $4302
        lda     #$7f
        sta     $4304
        lda     #$50
        sta     $4305                   ; size = $0050
        stz     $4306
        lda     #$01
        sta     hMDMAEN
        longa_clc
        tya
        adc     #$0080
        tay
        txa
        adc     #$0100
        tax
        cmp     #$a618
        bne     @aa72
@aaa5:  plb
        longai
        ply
        plx
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ update water tile animation ]

UpdateWaterAnim:
@aaad:  php
        phb
        shorta
        lda     #$7e
        pha
        plb
        ldx     #$0000
@aab8:  phx
        lda     #$00
        xba
        lda     $b850,x
        clc
        adc     #$10
        sta     $b850,x
        bcc     @ab18
        txa
        cmp     #$08
        bcc     @aace
        adc     #$07
@aace:  asl3
        tax
        lda     $b750,x
        pha
        longa
        lda     $b751,x
        sta     $b750,x
        lda     $b753,x
        sta     $b752,x
        lda     $b755,x
        sta     $b754,x
        shorta
        lda     $b757,x
        sta     $b756,x
        lda     $b790,x
        sta     $b757,x
        longa
        lda     $b791,x
        sta     $b790,x
        lda     $b793,x
        sta     $b792,x
        lda     $b795,x
        sta     $b794,x
        shorta
        lda     $b797,x
        sta     $b796,x
        pla
        sta     $b797,x
@ab18:  plx
        inx
        cpx     #$0010
        bne     @aab8
        longai
        lda     $1f64
        and     #$0003
        bne     @ab4a
        lda     $b860
        dec
        and     #$000f
        bne     @ab47
        ldx     $e0da
        lda     $e0de
        stx     $e0de
        ldx     $e0dc
        sta     $e0dc
        stx     $e0da
        lda     #$0010
@ab47:  sta     $b860
@ab4a:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ ending airship scene nmi ]

EndingAirshipSceneNMI:
@ab4d:  php
        phb
        longa
        pha
        longi
        phx
        phy
        phd
        shorta
        tdc
        pha
        plb
        inc     a:$0024
        cmp     hRDNMI
        stz     hCGADD
        ldx     #$2200
        stx     $4300
        ldx     #$e000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0200
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longa
        lda     $34
        sec
        sbc     $7b
        and     #$1fff
        sta     a:$0077
        lda     $38
        sec
        sbc     $7d
        and     #$1fff
        sta     a:$0079
        shorta
        lda     $77
        sta     hBG1HOFS
        lda     $78
        sta     hBG1HOFS
        lda     $79
        sta     hBG1VOFS
        lda     $7a
        sta     hBG1VOFS
        lda     $34
        sta     hM7X
        lda     $35
        sta     hM7X
        lda     $38
        sta     hM7Y
        lda     $39
        sta     hM7Y
        stz     $4300
        lda     #$04
        sta     $4301
        ldx     #$6b30
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$0220
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        shorta
        lda     $23
        bne     @abe9
        lda     #$80
@abe9:  sta     hINIDISP
        stz     $fa
        lda     $e9
        bit     #$01
        beq     @abfa
        lda     $fa
        ora     #$04
        sta     $fa
@abfa:  lda     $e9
        bit     #$02
        beq     @ac06
        lda     $fa
        ora     #$08
        sta     $fa
@ac06:  lda     #$f2
        ora     $fa
        sta     hHDMAEN
        pld
        longi
        ply
        plx
        longa
        pla
        plb
        plp
        rti

; ------------------------------------------------------------------------------
