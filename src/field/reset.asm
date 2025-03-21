; ------------------------------------------------------------------------------

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ reset ]

.proc Reset
        sei                             ; disable interrupts
        clc                             ; disable emulation mode
        xce
        shorta
        longi
        ldx     #$15ff                  ; set stack pointer
        txs
        ldx     #$0000                  ; set direct page
        phx
        pld
        clr_a                           ; set data bank
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

::FieldMain:
        stz     $4a                     ; disable fade
        lda     #1                      ; enable map load
        sta     $84

FieldLoop:
        lda     $4a                     ; branch if fading
        bne     NoMapLoad
        lda     $84                     ; branch if map is already loaded
        beq     NoMapLoad
        longa
        lda     $1f64                   ; map index
        and     #$03ff
        tax
        shorta0

; load world map
        cpx     #$0003                  ; branch if not a 3d map
        bcs     :+
        jsr     LoadWorldMap
        jmp     FieldMain

; load sub-map
:       jsr     LoadMap
        jsr     EnableInterrupts

NoMapLoad:
        jsr     WaitVblank
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
        clr_a
        jsr     CheckTimer
        jsr     CheckEventTriggers
        jsr     DecTimers
        jsr     ExecEvent
        lda     $4a                     ; loop if map is loading and fade out is complete
        bne     :+
        lda     $84
        bne     FieldLoop
:       jsr     CheckEntrances
        lda     $4a                     ; loop if map is loading and fade out is complete
        bne     :+
        lda     $84
        bne     FieldLoop
:       jsr     CheckBattleSub

; check restore saved game
        lda     $11f1                   ; branch if not restoring a saved game
        beq     :+
        stz     $11f1                   ; disable restore saved game
        ldx     #.loword(EventScript_NoEvent)
        stx     $e5
        lda     #^EventScript_NoEvent
        sta     $e7
        jsr     RestartGame
        jsr     InitSavedGame
        jmp     FieldMain

; check battle
:       lda     $56                     ; branch if battle not enabled
        beq     :+
        stz     $56                     ; disable battle
        jsr     ExecBattle
        jmp     FieldMain

; no battle
:       jsr     UpdateDlgText
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
        .if ::DEBUG
        jsr     DebugUpdate
        .endif

; reset max vertical scanline position every 256 frames
        lda     $46                     ; vblank counter
        bne     :+
        stz     $0632
:       lda     hSLHV                   ; latch horizontal/vertical counter
        lda     hOPHCT                  ; horizontal scanline position
        sta     $0630
        lda     hOPHCT
        lda     hOPVCT                  ; vertical scanline position
        sta     $0631
        lda     hOPVCT

; calculate max vertical scanline position since last reset
        lda     $0631
        cmp     $0632
        bcc     :+
        sta     $0632
:       jsr     CheckMenu
        jmp     OpenMainMenu

::MainMenuRet:
        jmp     FieldLoop

; unused
        jsr     DisableInterrupts
        jmp     FieldMain
.endproc  ; Reset

; ------------------------------------------------------------------------------

; [ field nmi ]

.proc FieldNMI
        php
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
        clr_a
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
        .if ::DEBUG
        ldx     #$45e0                  ; transfer debug tiles to vram
        stx     $3b
        ldx     #$6c00
        stx     $2a
        lda     #$7e
        sta     $2c
        lda     #$80                    ; 2 rows
        sta     $39
        jsr     UnusedDMA
        .endif
        lda     $0586                   ; bg1 horizontal scroll status
        cmp     #$02
        bne     :+                      ; branch if no update is needed
        jsr     TfrBG1TilesHScroll
        stz     $0586
:       lda     $0588                   ; bg2 horizontal scroll status
        cmp     #$02
        bne     CheckVerticalScroll
        jsr     TfrBG2TilesHScroll
        stz     $0588
        bra     CheckBG3Scroll

CheckVerticalScroll:
        lda     $0585                   ; bg1 vertical scroll status
        cmp     #$02
        bne     :+
        jsr     TfrBG1TilesVScroll
        stz     $0585
:       lda     $0587                   ; bg2 vertical scroll status
        cmp     #$02
        bne     CheckBG3Scroll
        jsr     TfrBG2TilesVScroll
        stz     $0587
        bra     CheckVerticalScroll

CheckBG3Scroll:
        lda     $058a                   ; bg3 horizontal scroll status
        cmp     #$02
        bne     :+
        jsr     TfrBG3TilesHScroll
        stz     $058a
        bra     DoneScroll
:       lda     $0589                   ; bg3 vertical scroll status
        cmp     #$02
        bne     DoneScroll
        jsr     TfrBG3TilesVScroll
        stz     $0589

DoneScroll:
        jsr     TfrObjGfxSub
        jsr     TfrDlgCursorGfx
        jsr     TfrDlgTextGfx
        jsr     ClearDlgTextRegion
        lda     #$e0                    ; clear fixed color add/sub register
        sta     hCOLDATA
        stz     hMDMAEN                 ; disable dma
        lda     #$43                    ; set up hdma channel 0
        sta     hDMA0::CTRL
        lda     #<hBG2HOFS
        sta     hDMA0::HREG
        ldx     #$7c51
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        lda     $0521                   ; wavy bg2 graphics
        and     #$08
        lsr3
        ora     #$fe
        sta     hHDMAEN                 ; enable hdma channels
        jsr     UpdateScrollHDMA
        jsr     UpdateFixedColor
        jsr     UpdateMosaic
        jsr     UpdateWindowHDMATbl
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
.endproc  ; FieldNMI
.a8
.i16

; ------------------------------------------------------------------------------

; [ field irq ]

; called every frame at scanline 215

.proc FieldIRQ
        php
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
        clr_a
        pha
        plb
        lda     hTIMEUP                 ; reset irq flag register
        bpl     :++                     ; branch if vertical timer didn't end
        lda     #$81                    ; enable nmi and controller, disable irq
        sta     hNMITIMEN
        stz     hHDMAEN                 ; disable hdma
        lda     $45                     ; frame counter
        lsr
        bcs     :+
        jsr     TfrBGAnimGfx            ; update bg1/2 on even frames
        bra     :++
:       jsr     TfrBG3AnimGfx           ; update bg3 on odd frames
:       longai
        pld
        plb
        ply
        plx
        pla
        plp
        rti
.endproc  ; FieldIRQ
.a8
.i16

; ------------------------------------------------------------------------------

; [ validate checksum (unused) ]

.proc ValidateChecksum
        ldx     #0
        stx     $1e
        stx     $2a
        lda     #$c0                    ; start in bank $c0
        sta     $2c
Loop:   ldy     #0
:       lda     [$2a],y
        clc
        adc     $1e
        sta     $1e
        clr_a
        adc     $1f
        sta     $1f
        iny
        bne     :-
        lda     $2c
        inc
        sta     $2c
        cmp     #$f0                    ; end in bank $f0
        bne     Loop
        lda     f:HeaderChecksum+1
        cmp     $1f
        bne     Fail
        lda     f:HeaderChecksum
        cmp     $1e
        bne     Fail
        rts
Fail:   jmp     Fail                    ; infinite loop
.endproc  ; ValidateChecksum

; ------------------------------------------------------------------------------

; [ play sound effect ]

; A: sound effect index

.proc PlaySfx
        sta     $1301
        lda     #$18
        sta     $1300
        lda     #$80
        sta     $1302
        jsl     ExecSound_ext
        rts
.endproc  ; PlaySfx

; ------------------------------------------------------------------------------

; [ convert hex to decimal ]

; ++$22: hex value to convert

.proc HexToDec
        phx
        phy
        ldx     $00
Loop:   ldy     #0
        stz     $25
:       longa
        lda     $22
        sec
        sbc     f:Pow10Lo,x
        sta     $22
        lda     $24
        sbc     f:Pow10Hi,x
        sta     $24
        bcc     :+
        iny
        jmp     :-
:       lda     $22
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
        bne     Loop
        ply
        plx
        rts

; hex to decimal conversion constants

Pow10Lo:
        .addr   10000000
        .addr   1000000
        .addr   100000
        .addr   10000
        .addr   1000
        .addr   100
        .addr   10
        .addr   1

Pow10Hi:
        .word   ^10000000
        .word   ^1000000
        .word   ^100000
        .word   ^10000
        .word   ^1000
        .word   ^100
        .word   ^10
        .word   ^1

.endproc  ; HexToDec

; ------------------------------------------------------------------------------

; [ play default song ]

.proc PlayMapSong
        lda     $1eb9
        and     #$10
        bne     Override
        lda     $053c                   ; map's default song
        beq     Done
        sta     $1f80
        bra     :+

Override:
        lda     $1f80

:       sta     $1301
        lda     #$10
        sta     $1300
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
Done:   rts
.endproc  ; PlayMapSong

; ------------------------------------------------------------------------------

; [ disable interrupts ]

.proc DisableInterrupts
        stz     hMDMAEN
        stz     hHDMAEN
        lda     #$80
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        sei
        rts
.endproc  ; DisableInterrupts

; ------------------------------------------------------------------------------

; [ enable interrupts ]

.proc EnableInterrupts
:       lda     hRDNMI
        bpl     :-
        lda     #$81
        sta     hNMITIMEN
        lda     #$00
        sta     hINIDISP
        cli
        rts
.endproc  ; EnableInterrupts

; ------------------------------------------------------------------------------

; [ load world map ]

.proc LoadWorldMap
        stz     $0205
        stz     hMDMAEN
        stz     hHDMAEN
        lda     #$8f
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        ldx     $e5
        bne     :+
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     :+
        stz     $11fd
        stz     $11fe
        stz     $11ff
:       jsr     PushDP
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
        cmp     #^EventScript_NoEvent
        bne     :+
        cpx     #.loword(EventScript_NoEvent)
        bne     :+
        ldx     $00
        stx     $e8
        lda     #$80
        sta     $11fa
:       rts
.endproc  ; LoadWorldMap

; ------------------------------------------------------------------------------

; [ decompress ]

; ++$f3 = source address
; ++$f6 = destination address

zDecompSrc := $f3
zDecompDest := $f6
zDecompPtr := $f9
zDecompRun := $fb
zDecompSize := $fc
zDecompCounter := $fe
zDecompHeader := $ff

wDecompBuf := $7ff800

.proc Decompress
        phb
        longa
        lda     [zDecompSrc]
        sta     zDecompSize
        lda     zDecompDest
        sta     f:hWMADDL
        shorta
        lda     zDecompDest+2
        and     #BIT_0
        sta     f:hWMADDH
        lda     #1
        sta     zDecompCounter
        ldy     #2                      ; first 2 bytes are size

; init buffer
        lda     #^wDecompBuf
        pha
        plb
        ldx     #.loword(wDecompBuf)
        clr_a
:       sta     a:0,x
        inx
        bne     :-
        ldx     #.loword(-34)
Loop:   dec     zDecompCounter
        bne     :+
        lda     #8                      ; load the next header byte
        sta     zDecompCounter
        lda     [zDecompSrc],y
        sta     zDecompHeader
        iny
:       lsr     zDecompHeader
        bcc     :+
        lda     [zDecompSrc],y
        sta     f:hWMDATA
        sta     a:0,x
        inx
        bne     IncPtr
        ldx     #.loword(wDecompBuf)
        bra     IncPtr
:       lda     [zDecompSrc],y
        xba
        iny
        sty     zDecompPtr
        lda     [zDecompSrc],y
        lsr3
        clc
        adc     #3
        sta     zDecompRun
        lda     [zDecompSrc],y
        ora     #>wDecompBuf
        xba
        tay

CopyBuf:
        lda     0,y
        sta     f:hWMDATA
        sta     a:0,x
        inx
        bne     :+
        ldx     #.loword(wDecompBuf)
:       iny
        bne     :+
        ldy     #.loword(wDecompBuf)
:       dec     zDecompRun
        bne     CopyBuf
        ldy     zDecompPtr

IncPtr:
        iny
        cpy     zDecompSize
        bne     Loop
        clr_a
        xba
        plb
        rtl
.endproc  ; Decompress

; ------------------------------------------------------------------------------

; [ clear direct page (unused) ]

.proc ClearDP
        ldx     #0
:       stz     a:0,x
        inx
        cpx     #$0100
        bne     :-
        rts
.endproc  ; ClearDP

; ------------------------------------------------------------------------------

; [ save direct page ]

.proc PushDP
        ldx     #0
:       lda     a:0,x
        sta     $1200,x
        inx
        cpx     #$0100
        bne     :-
        rts
.endproc  ; PushDP

; ------------------------------------------------------------------------------

; [ restore direct page ]

.proc PopDP
        ldx     #0
:       lda     $1200,x
        sta     a:0,x
        inx
        cpx     #$0100
        bne     :-
        rts
.endproc  ; PopDP

; ------------------------------------------------------------------------------

; [ clear $0000-$1200 ]

.proc ClearRAM
        clr_ax
        stx     hWMADDL
        sta     hWMADDH
        ldx     #$0120
:       .repeat 16
        sta     hWMDATA
        .endrep
        dex
        bne     :-
        rts
.endproc  ; ClearRAM

; ------------------------------------------------------------------------------

; [ wait for vblank ]

zVBlankFlag := $55

.proc WaitVblank
        stz     zVBlankFlag
:       lda     zVBlankFlag
        beq     :-
        stz     zVBlankFlag
        rts
.endproc  ; WaitVblank

; ------------------------------------------------------------------------------

; [ update controller ]

.proc UpdateCtrl
        jsl     UpdateCtrlField_ext
        clr_a
        rts
.endproc  ; UpdateCtrl

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

.proc InitInterrupts
        lda     #$5c                    ; jml
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
.endproc  ; InitInterrupts

; ------------------------------------------------------------------------------

; [ init ppu hardware registers ]

.proc InitPPU
        lda     #$80
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
.endproc  ; InitPPU

; ------------------------------------------------------------------------------

; [ update random number ]

wRand := $1f6d

.proc Rand
        phx
        inc     wRand
        lda     wRand
        tax
        lda     f:RNGTbl,x
        plx
        rts
.endproc  ; Rand

; ------------------------------------------------------------------------------
