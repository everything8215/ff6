; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ reset ]

Reset:
@0019:  sei                             ; disable interrupts
        clc                             ; disable emulation mode
        xce
        shorta
        longi
        ldx     #$15ff                  ; set stack pointer
        txs
        ldx     #$0000                  ; set direct page
        phx
        pld
        tdc                             ; set data bank
        pha
        plb
        lda     #$01                    ; select fastrom
        sta     hMEMSEL
        stz     hMDMAEN                 ; disable dma & hdma
        stz     hHDMAEN
        lda     #$8f                    ; screen off
        sta     hINIDISP
        stz     hNMITIMEN               ; disable nmi and irq
        jsr     ClearRAM
        ldx     #0                      ; set $00 and $02
        stx     $00
        ldx     #$ffff
        stx     $02
        jsr     InitInterrupts
        jsl     InitSound_ext
        jsl     InitCtrl_ext
        lda     f:StartingMapX          ; set starting position and map
        sta     $1fc0
        lda     f:StartingMapY
        sta     $1fc1
        longa
        lda     f:StartingMapIndex
        sta     $1f64
        shorta0
        stz     $115a                   ; unused
        stz     $1159
        lda     #$40                    ; disable auto fade in when loading map
        sta     $11fa
        jsr     InitNewGame
; fallthrough

; ------------------------------------------------------------------------------

; [ field main code loop ]

FieldMain:
@007f:  stz     $4a                     ; disable fade
        lda     #1                      ; enable map load
        sta     $84

FieldLoop:
@0085:  lda     $4a                     ; branch if fading
        bne     @00aa
        lda     $84                     ; branch if map is already loaded
        beq     @00aa
        longa
        lda     $1f64                   ; map index
        and     #$03ff
        tax
        shorta0
        cpx     #$0003                  ; branch if not a 3d map
        bcs     @00a4

; load world map
        jsr     LoadWorldMap
        jmp     FieldMain

; load sub-map
@00a4:  jsr     LoadMap
        jsr     EnableInterrupts
@00aa:  jsr     WaitVblank
        jsr     UpdateShake
        jsr     UpdatePalAnim
        ldy     $0803                   ; party object
        longa
        lda     $086d,y                 ; y position (in pixels)
        lsr4                            ; convert to tiles
        shorta
        sta     $b0                     ; set party y position
        longa
        lda     $086a,y                 ; x position (in pixels)
        lsr4                            ; convert to tiles
        shorta
        sta     $af                     ; set party x position
        tdc
        jsr     CheckTimer
        jsr     CheckEventTriggers
        jsr     DecTimers
        jsr     ExecEvent
        lda     $4a                     ; loop if map is loading and fade out is complete
        bne     @00e5
        lda     $84
        bne     @0085
@00e5:  jsr     CheckEntrances
        lda     $4a                     ; loop if map is loading and fade out is complete
        bne     @00f0
        lda     $84
        bne     @0085
@00f0:  jsr     CheckBattleSub
        lda     $11f1                   ; branch if not restoring a saved game
        beq     @010d

; restore saved game
        stz     $11f1                   ; disable restore saved game
        ldx     #$0000                  ; $ca0000 (no event)
        stx     $e5
        lda     #$ca
        sta     $e7
        jsr     RestartGame
        jsr     InitSavedGame
        jmp     FieldMain               ; loop

; battle
@010d:  lda     $56                     ; branch if battle not enabled
        beq     @0119
        stz     $56                     ; disable battle
        jsr     ExecBattle
        jmp     FieldMain               ; loop

; no battle
@0119:  jsr     UpdateDlgText
        jsr     UpdateDlgWindow
        jsr     UpdateObjActions
        jsr     CalcScrollPos
        jsr     MoveObjs
        jsr     UpdateBG1
        jsr     UpdateBG2
        jsr     UpdateBG3
        jsr     UpdateScroll
        jsr     DrawObjSprites
        jsr     DrawOverlaySprites
        jsr     CheckChangeParty
        jsr     UpdateCollisionScroll
        jsr     UpdateFlashlight
        jsr     UpdatePyramid
        jsr     UpdateSpotlights
        jsr     DrawTimer

; reset max vertical scanline position every 256 frames
        lda     $46                     ; vblank counter
        bne     @0153
        stz     $0632
@0153:  lda     hSLHV                   ; latch horizontal/vertical counter
        lda     hOPHCT                  ; horizontal scanline position
        sta     $0630
        lda     hOPHCT
        lda     hOPVCT                  ; vertical scanline position
        sta     $0631
        lda     hOPVCT

; calculate max vertical scanline position since last reset
        lda     $0631
        cmp     $0632
        bcc     @0173
        sta     $0632
@0173:  jsr     CheckMenu
        jmp     OpenMainMenu

MainMenuReturn:
@0179:  jmp     FieldLoop

; unused
@017c:  jsr     DisableInterrupts
        jmp     FieldMain

; ------------------------------------------------------------------------------

; [ field nmi ]

FieldNMI:
@0182:  php
        longai
        pha
        phx
        phy
        phb
        phd
        longi
        shorta
        ldx     #$0000
        phx
        pld
        tdc
        pha
        plb
        lda     hRDNMI                  ; reset nmi flag register
        stz     hMDMAEN                 ; disable dma
        stz     hHDMAEN
        lda     #$a1                    ; enable nmi, vertical irq, and controller
        sta     hNMITIMEN
        jsr     UpdateBrightness
        jsr     TfrPal
        jsr     TfrSprites
        jsr     TfrMapTiles
        lda     $0586                   ; bg1 horizontal scroll status
        cmp     #$02
        bne     @01bd                   ; branch if no update is needed
        jsr     TfrBG1TilesHScroll
        stz     $0586
@01bd:  lda     $0588                   ; bg2 horizontal scroll status
        cmp     #$02
        bne     @01cc
        jsr     TfrBG2TilesHScroll
        stz     $0588
        bra     @01e8
@01cc:  lda     $0585                   ; bg1 vertical scroll status
        cmp     #$02
        bne     @01d9
        jsr     TfrBG1TilesVScroll
        stz     $0585
@01d9:  lda     $0587                   ; bg2 vertical scroll status
        cmp     #$02
        bne     @01e8
        jsr     TfrBG2TilesVScroll
        stz     $0587
        bra     @01cc
@01e8:  lda     $058a                   ; bg3 horizontal scroll status
        cmp     #$02
        bne     @01f7
        jsr     TfrBG3TilesHScroll
        stz     $058a
        bra     @0204
@01f7:  lda     $0589                   ; bg3 vertical scroll status
        cmp     #$02
        bne     @0204
        jsr     TfrBG3TilesVScroll
        stz     $0589
@0204:  jsr     TfrObjGfxSub
        jsr     TfrDlgCursorGfx
        jsr     TfrDlgTextGfx
        jsr     ClearDlgTextRegion
        lda     #$e0                    ; clear fixed color add/sub register
        sta     hCOLDATA
        stz     hMDMAEN                 ; disable dma
        lda     #$43                    ; set up hdma channel 0
        sta     $4300
        lda     #$0f
        sta     $4301
        ldx     #$7c51
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        lda     $0521                   ; wavy bg2 graphics
        and     #$08
        lsr3
        ora     #$fe
        sta     hHDMAEN                 ; enable hdma channels
        jsr     UpdateScrollHDMA
        jsr     UpdateFixedColor
        jsr     UpdateMosaic
        jsr     InitWindowHDMATbl
        jsr     SetWindowSelect
        jsr     UpdateCtrl
        jsl     IncGameTime_ext
        inc     $46                     ; increment vblank counter
        inc     $45                     ; increment frame counter
        inc     $55                     ; disable vblank
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti

; ------------------------------------------------------------------------------

; [ field irq ]

; called every frame at scanline 215

FieldIRQ:
@0262:  php
        longai
        pha
        phx
        phy
        phb
        phd
        longi
        shorta
        ldx     #$0000
        phx
        pld
        tdc
        pha
        plb
        lda     hTIMEUP                 ; reset irq flag register
        bpl     @0290                   ; branch if vertical timer didn't end
        lda     #$81                    ; enable nmi and controller, disable irq
        sta     hNMITIMEN
        stz     hHDMAEN                 ; disable hdma
        lda     $45                     ; frame counter
        lsr
        bcs     @028d
        jsr     TfrBGAnimGfx
        bra     @0290
@028d:  jsr     TfrBG3AnimGfx
@0290:  longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti

.a8
.i16

; ------------------------------------------------------------------------------

; [ validate checksum (unused) ]

ValidateChecksum:
@0299:  ldx     #0
        stx     $1e
        stx     $2a
        lda     #$c0
        sta     $2c
@02a4:  ldy     #0
@02a7:  lda     [$2a],y
        clc
        adc     $1e
        sta     $1e
        tdc
        adc     $1f
        sta     $1f
        iny
        bne     @02a7
        lda     $2c
        inc
        sta     $2c
        cmp     #$f0
        bne     @02a4
        lda     f:HeaderChecksum+1
        cmp     $1f
        bne     @02d0
        lda     f:HeaderChecksum
        cmp     $1e
        bne     @02d0
        rts
@02d0:  jmp     @02d0                   ; infinite loop

; ------------------------------------------------------------------------------

; [ play sound effect ]

; A: sound effect index

PlaySfx:
@02d3:  sta     $1301
        lda     #$18
        sta     $1300
        lda     #$80
        sta     $1302
        jsl     ExecSound_ext
        rts

; ------------------------------------------------------------------------------

; [ convert hex to decimal ]

; ++$22: hex value to convert

HexToDec:
@02e5:  phx
        phy
        ldx     $00
@02e9:  ldy     #0
        stz     $25
@02ee:  longa
        lda     $22
        sec
        sbc     f:Pow10Lo,x
        sta     $22
        lda     $24
        sbc     f:Pow10Hi,x
        sta     $24
        bcc     @0307
        iny
        jmp     @02ee
@0307:  lda     $22
        clc
        adc     f:Pow10Lo,x
        sta     $22
        lda     $24
        adc     f:Pow10Hi,x
        sta     $24
        shorta0
        phx
        txa
        lsr
        tax
        tya
        sta     $0754,x
        plx
        inx2
        cpx     #$0010
        bne     @02e9
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; hex to decimal conversion constants

Pow10Lo:
@032e:  .word   $9680,$4240,$86a0,$2710,$03e8,$0064,$000a,$0001

Pow10Hi:
@033e:  .word   $0098,$000f,$0001,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ play default song ]

PlayMapSong:
@034e:  lda     $1eb9
        and     #$10
        bne     @035f
        lda     $053c
        beq     @0373
        sta     $1f80
        bra     @0362
@035f:  lda     $1f80
@0362:  sta     $1301
        lda     #$10
        sta     $1300
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
@0373:  rts

; ------------------------------------------------------------------------------

; [ disable interrupts ]

DisableInterrupts:
@0374:  stz     hMDMAEN
        stz     hHDMAEN
        lda     #$80
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        sei
        rts

; ------------------------------------------------------------------------------

; [ enable interrupts ]

EnableInterrupts:
@0386:  lda     hRDNMI
        bpl     @0386
        lda     #$81
        sta     hNMITIMEN
        lda     #$00
        sta     hINIDISP
        cli
        rts

; ------------------------------------------------------------------------------

; [ load world map ]

LoadWorldMap:
@0397:  stz     $0205
        stz     hMDMAEN
        stz     hHDMAEN
        lda     #$8f
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        ldx     $e5
        bne     @03bd
        lda     $e7
        cmp     #$ca
        bne     @03bd
        stz     $11fd
        stz     $11fe
        stz     $11ff
@03bd:  jsr     PushDP
        jsr     PushCharFlags
        jsr     PushPartyPal
        jsr     PushPartyMap
        ldx     $0803
        stx     $1fa6
        ldy     $0803
        lda     $0879,y
        sta     $11fb
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        ldy     hRDDIVL
        lda     $1f70,y
        lsr
        sta     $11fc
        pha
        phx
        phy
        phd
        phb
        php
        jsl     LoadWorld_ext
        plp
        plb
        pld
        ply
        plx
        pla
        sei
        stz     hMDMAEN
        stz     hHDMAEN
        lda     #$8f
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        xba
        jsr     InitInterrupts
        jsr     PopDP
        jsr     PopCharFlags
        jsr     PopPartyMap
        lda     $1d4e
        and     #$07
        sta     $0565
        longa
        lda     $1f64
        sta     $1e
        and     #$01ff
        sta     $1f64
        lda     $1f66
        sta     $1fc0
        shorta0
        lda     $1f
        and     #$30
        lsr4
        sta     $0743
        lda     $1f
        and     #$08
        sta     $0745
        ldx     $11fd
        stx     $e5
        lda     $11ff
        sta     $e7
        cmp     #$ca
        bne     @046b
        cpx     #$0000
        bne     @046b
        ldx     $00
        stx     $e8
        lda     #$80
        sta     $11fa
@046b:  rts

; ------------------------------------------------------------------------------

; [ decompress ]

; ++$f3 = source address
; ++$f6 = destination address

Decompress:
@046c:  phb
        longa
        lda     [$f3]
        sta     $fc
        lda     $f6
        sta     f:hWMADDL
        shorta
        lda     $f8
        and     #$01
        sta     f:hWMADDH
        lda     #1
        sta     $fe
        ldy     #2
        lda     #$7f
        pha
        plb
        ldx     #$f800
        tdc
@0492:  sta     a:$0000,x
        inx
        bne     @0492
        ldx     #$ffde
@049b:  dec     $fe
        bne     @04a8
        lda     #8
        sta     $fe
        lda     [$f3],y
        sta     $ff
        iny
@04a8:  lsr     $ff
        bcc     @04bd
        lda     [$f3],y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @04ef
        ldx     #$f800
        bra     @04ef
@04bd:  lda     [$f3],y
        xba
        iny
        sty     $f9
        lda     [$f3],y
        lsr3
        clc
        adc     #3
        sta     $fb
        lda     [$f3],y
        ora     #$f8
        xba
        tay
@04d3:  lda     $0000,y
        sta     f:hWMDATA
        sta     a:$0000,x
        inx
        bne     @04e3
        ldx     #$f800
@04e3:  iny
        bne     @04e9
        ldy     #$f800
@04e9:  dec     $fb
        bne     @04d3
        ldy     $f9
@04ef:  iny
        cpy     $fc
        bne     @049b
        tdc
        xba
        plb
        rtl

; ------------------------------------------------------------------------------

; [ clear direct page (unused) ]

ClearDP:
@04f8:  ldx     #0
@04fb:  stz     a:$0000,x
        inx
        cpx     #$0100
        bne     @04fb
        rts

; ------------------------------------------------------------------------------

; [ save direct page ]

PushDP:
@0505:  ldx     #0
@0508:  lda     a:$0000,x
        sta     $1200,x
        inx
        cpx     #$0100
        bne     @0508
        rts

; ------------------------------------------------------------------------------

; [ restore direct page ]

PopDP:
@0515:  ldx     #0
@0518:  lda     $1200,x
        sta     a:$0000,x
        inx
        cpx     #$0100
        bne     @0518
        rts

; ------------------------------------------------------------------------------

; [ clear $0000-$1200 ]

ClearRAM:
@0525:  tdc
        tax
        stx     hWMADDL
        sta     hWMADDH
        ldx     #$0120
@0530:
.repeat 16
        sta     hWMDATA
.endrep
        dex
        bne     @0530
        rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

WaitVblank:
@0564:  stz     $55
@0566:  lda     $55
        beq     @0566
        stz     $55
        rts

; ------------------------------------------------------------------------------

; [ update controller ]

UpdateCtrl:
@056d:  jsl     UpdateCtrlField_ext
        tdc
        rts

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

InitInterrupts:
@0573:  lda     #$5c                    ; jml
        sta     $1500
        sta     $1504
        ldx     #.loword(FieldNMI)
        stx     $1501
        lda     #^FieldNMI
        sta     $1503
        ldx     #.loword(FieldIRQ)
        stx     $1505
        lda     #^FieldIRQ
        sta     $1507
        rts

; ------------------------------------------------------------------------------

; [ init ppu hardware registers ]

InitPPU:
@0592:  lda     #$80
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        lda     #$03                    ; sprite graphics at $6000 (vram)
        ora     #$60                    ; 16x16 and 32x32 sprites
        sta     hOBJSEL
        stz     hOAMADDL
        stz     hOAMADDH
        lda     #$09
        sta     hBGMODE
        stz     hMOSAIC
        lda     #$48
        sta     hBG1SC
        lda     #$50
        sta     hBG2SC
        lda     #$58
        sta     hBG3SC
        lda     #$00
        sta     hBG12NBA
        lda     #$03
        sta     hBG34NBA
        lda     #$80
        sta     hVMAINC
        sta     hCGADD
        lda     #$33
        sta     hW12SEL
        lda     #$03
        sta     hW34SEL
        lda     #$f3
        sta     hWOBJSEL
        lda     #$08
        sta     hWH0
        lda     #$f7
        sta     hWH1
        lda     #$00
        sta     hWH2
        lda     #$ff
        sta     hWH3
        lda     #$00
        sta     hWBGLOG
        lda     #$00
        sta     hWOBJLOG
        lda     #$17
        sta     hTMW
        stz     hTSW
        lda     #$22
        sta     hCGSWSEL
        lda     #$e0
        sta     hCOLDATA
        lda     #$00
        sta     hSETINI
        lda     #$ff
        sta     hWRIO
        stz     hHTIMEL
        stz     hHTIMEH
        ldx     #215                    ; vertical timer set to scanline 215
        stx     hVTIMEL
        rts

; ------------------------------------------------------------------------------

; [ update random number ]

Rand:
@062e:  phx
        inc     $1f6d
        lda     $1f6d
        tax
        lda     f:RNGTbl,x
        plx
        rts

; ------------------------------------------------------------------------------
