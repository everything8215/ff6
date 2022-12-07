
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: field.asm                                                            |
; |                                                                            |
; | description: field program                                                 |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "field_data.asm"

.import Battle_ext, UpdateEquip_ext
.import OpenMenu_ext, InitCtrl_ext, UpdateCtrlField_ext
.import IncGameTime_ext, LoadSavedGame_ext, EndingCutscene_ext
.import OptimizeCharEquip_ext
.import InitSound_ext, ExecSound_ext
.import LoadWorld_ext, MagitekTrain_ext, EndingAirshipScene2_ext
.import OpeningCredits_ext, TitleScreen_ext, TheEnd_ext
.import FloatingContScene_ext, WorldOfRuinScene_ext

.import WorldBattleRate, SubBattleRate
.import WindowGfx, WindowPal, PortraitGfx, PortraitPal
.import SineTbl8

.export LoadMapCharGfx_ext, CheckBattleWorld_ext, DoPoisonDmg_ext
.export DecTimersMenuBattle_ext

; ------------------------------------------------------------------------------

.segment "field_code"
.a8
.i16

; ------------------------------------------------------------------------------

LoadMapCharGfx_ext:
@0000:  jsr     TfrObjGfxWorld
        rtl

; ------------------------------------------------------------------------------

StartingMapIndex:
@0004:  .word   3                       ; starting map

StartingMapX:
@0006:  .byte   8                       ; starting x position

StartingMapY:
@0007:  .byte   8                       ; starting y position

; ------------------------------------------------------------------------------

CheckBattleWorld_ext:
@0008:  jmp     CheckBattleWorld

; ------------------------------------------------------------------------------

DoPoisonDmg_ext:
@000b:  jmp     DoPoisonDmg
        nop7

; ------------------------------------------------------------------------------

DecTimersMenuBattle_ext:
@0015:  jsr     DecTimersMenuBattle
        rtl

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

; a = sound effect index

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

; ++$22 = hex value to convert

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

; [ update window mask settings ]

SetWindowSelect:
@063c:  lda     $077b
        bne     @064f
        lda     $0781
        bne     @064f
        lda     $0521
        and     #$20
        bne     @064f                   ; branch if spotlights are enabled
        bra     @066d
@064f:  lda     $0526                   ; window mask
        and     #$03
        asl2
        tax
        lda     f:WindowSelectTbl,x
        sta     hW12SEL
        lda     f:WindowSelectTbl+1,x
        sta     hW34SEL
        lda     f:WindowSelectTbl+2,x
        sta     hWOBJSEL
        rts
@066d:  lda     #$33                    ; use default settings
        sta     hW12SEL
        lda     #$03
        sta     hW34SEL
        lda     #$f3
        sta     hWOBJSEL
        rts

; ------------------------------------------------------------------------------

; window mask settings
WindowSelectTbl:
@067d:  .byte   $33,$03,$f3,$00
        .byte   $b3,$03,$f3,$00
        .byte   $ff,$0f,$ff,$00
        .byte   $33,$0f,$f3,$00

; ------------------------------------------------------------------------------

; [ reset window mask hdma data ]

ClearWindowPos:
@068d:  inc     $0566
        lda     $0566
        lsr
        bcs     @069e
        ldx     #$8cb3
        stx     hWMADDL
        bra     @06a4
@069e:  ldx     #$8e53
        stx     hWMADDL
@06a4:  lda     #$7e
        sta     hWMADDH
        lda     #$d0
        jsr     ResetWindowPos
        rts

; ------------------------------------------------------------------------------

; [ update flashlight ]

; use bresenham's circle algorithm (i think...) through 90 degrees to
; find the points of the flashlight circle

UpdateFlashlight:
@06af:  lda     $077b                   ; return if flashlight is not enabled
        bmi     @06b5
        rts
@06b5:  and     #$1f                    ; target flashlight size * 2
        asl
        cmp     $077c                   ; compare to current flashlight size
        beq     @06cd
        bcs     @06c7
        dec     $077c
        dec     $077c
        bra     @06cd
@06c7:  inc     $077c
        inc     $077c
@06cd:  ldy     $0803                   ; party object
        lda     $086a,y                 ; x position
        sec
        sbc     $5c                     ; subtract bg1 scroll pos to get screen pos
        clc
        adc     #$10                    ; add $10
        sta     $077d                   ; set flashlight x position
        lda     $086d,y                 ; y position
        sec
        sbc     $60                     ; subtract bg1 scroll pos to get screen pos
        sec
        sbc     #$08                    ; subtract 8
        sta     $077e                   ; set flashlight y position
        inc     $0566                   ; window 2 frame counter
        lda     $0566
        lsr
        bcs     @06f9
        ldx     #$8cb3                  ; even frame
        stx     hWMADDL
        bra     @06ff
@06f9:  ldx     #$8e53                  ; odd frame
        stx     hWMADDL
@06ff:  lda     #$7e
        sta     hWMADDH
        lda     $077c                   ; $1a = current radius (in pixels)
        sta     $1a
        bne     @0714
        lda     #$d0                    ; radius 0, close window 2 in all lines
        jsr     ResetWindowPos
        stz     $077b
        rts
@0714:  ldx     #$0100                  ; $0100 / flashlight radius
        stx     hWRDIVL
        lda     $1a
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        sta     hWRMPYA                 ; 1 / r
        lda     $1a
        sta     $27                     ; +$26: x = r + 0.5
        lda     #$80
        sta     $26
        stz     $28                     ; +$28: y = 0
        stz     $29
        shorti
        longa
@073c:  ldx     $29
        stx     hWRMPYB
        lda     $26                     ; x -= y / r
        sec
        sbc     hRDMPYL
        sta     $26
        bmi     @075f                   ; exit loop when x goes negative
        xba
        sta     $7e7b00,x
        ldy     $27                     ; y += x / r
        sty     hWRMPYB
        lda     $28
        clc
        adc     hRDMPYL
        sta     $28
        bra     @073c
@075f:  shorta0
        lda     $077e                   ; flashlight y position
        sec
        sbc     $1a                     ; subtract radius
        bcc     @076d
        jsr     ResetWindowPos
@076d:  ldy     $077d                   ; do top half of flashlight first
        ldx     $1a
        cpx     $077e
        bcc     @077a
        ldx     $077e
@077a:  dex
@077b:  tya                             ; flashlight x position
        sec
        sbc     $7e7b00,x               ; subtract width
        bcs     @0784
        tdc                             ; min value is 0
@0784:  sta     hWMDATA                 ; set left side of window
        tya
        clc
        adc     $7e7b00,x               ; add width
        bcc     @0791
        lda     #$ff                    ; max value is $ff
@0791:  sta     hWMDATA                 ; set right side of window
        dex                             ; next line
        bne     @077b
        ldy     $077d                   ; then do bottom half of flashlight
        ldx     $1a
        lda     $077e
        cmp     #$d0
        bcs     @07df
        clc
        adc     $1a
        cmp     #$d0
        bcc     @07b1
        lda     #$d0
        sec
        sbc     $077e
        tax
@07b1:  stx     $2a
        ldx     $00
@07b5:  tya
        sec
        sbc     $7e7b00,x
        bcs     @07be
        tdc
@07be:  sta     hWMDATA
        tya
        clc
        adc     $7e7b00,x
        bcc     @07cb
        lda     #$ff
@07cb:  sta     hWMDATA
        inx
        cpx     $2a
        bne     @07b5
        lda     #$d1                    ; a = 209 - (radius + y position)
        sec
        sbc     $1a
        sec
        sbc     $077e
        jsr     ResetWindowPos
@07df:  longi
        rts

; ------------------------------------------------------------------------------

; [ sine ]

; a = $1a * sin($1b)

CalcSine:
@07e2:  lda     $1a
        sta     hWRMPYA
        lsr
        sta     $1a
        lda     $1b
        tax
        lda     f:SineTbl8,x             ; sin/cos table
        clc
        adc     #$80
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sec
        sbc     $1a
        rts

; ------------------------------------------------------------------------------

; [ cosine ]

; a = $1a * cos($1b)

CalcCosine:
@0801:  lda     $1a
        sta     hWRMPYA
        lsr
        sta     $1a
        lda     $1b
        clc
        adc     #$40
        tax
        lda     f:SineTbl8,x               ; sin/cos table
        clc
        adc     #$80
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sec
        sbc     $1a
        rts

; ------------------------------------------------------------------------------

; [ update pyramid ]

UpdatePyramid:
@0823:  lda     $0781
        bne     @0829
        rts
@0829:  ldy     $077f
        lda     $086a,y
        sec
        sbc     $5c
        clc
        adc     #$10
        sta     $077d
        lda     $086d,y
        sec
        sbc     $60
        sta     $077e
        longac
        lda     $0790
        clc
        adc     #$0040
        sta     $0790
        shorta0
        lda     $0790
        and     #$c0
        sta     $1b
        lda     $0791
        asl
        clc
        adc     $1b
        sta     $1b
        stz     $1a
        jsr     CalcSine
        clc
        adc     $077e
        sec
        sbc     #$30
        sta     $075d
        stz     $1a
        jsr     CalcCosine
        clc
        adc     $077d
        sta     $075c
        lda     $0790
        and     #$c0
        sta     $1b
        lda     $0791
        asl
        clc
        adc     $1b
        sec
        sbc     #$20
        sta     $1b
        lda     #$20
        sta     $1a
        jsr     CalcSine
        clc
        adc     $077e
        sta     $075f
        lda     #$40
        sta     $1a
        jsr     CalcCosine
        clc
        adc     $077d
        sta     $075e
        lda     $0790
        and     #$c0
        sta     $1b
        lda     $0791
        asl
        clc
        adc     $1b
        clc
        adc     #$20
        sta     $1b
        lda     #$20
        sta     $1a
        jsr     CalcSine
        clc
        adc     $077e
        sta     $0761
        lda     #$40
        sta     $1a
        jsr     CalcCosine
        clc
        adc     $077d
        sta     $0760
        inc     $0566
        lda     $0566
        lsr
        bcs     @08ea
        ldx     #$8cb3
        stx     hWMADDL
        bra     @08f0
@08ea:  ldx     #$8e53
        stx     hWMADDL
@08f0:  lda     #$7e
        sta     hWMADDH
        lda     $075d
        cmp     $075f
        bcc     @0909
        ldx     $075c
        ldy     $075e
        stx     $075e
        sty     $075c
@0909:  lda     $075f
        cmp     $0761
        bcc     @091d
        ldx     $075e
        ldy     $0760
        stx     $0760
        sty     $075e
@091d:  lda     $075d
        cmp     $075f
        bcc     @0931
        ldx     $075c
        ldy     $075e
        stx     $075e
        sty     $075c
@0931:  lda     $075d
        cmp     $075f
        bne     @0950
        lda     $075c
        cmp     $075e
        bcc     @094d
        ldx     $075c
        ldy     $075e
        stx     $075e
        sty     $075c
@094d:  jmp     @0a24
@0950:  lda     $075e
        cmp     $0760
        bcc     @0964
        ldx     $075e
        ldy     $0760
        stx     $0760
        sty     $075e
@0964:  lda     $075f
        cmp     $0761
        jeq     @0a78
        lda     $075d
        sta     $2c
        lda     $075f
        sec
        sbc     $075d
        sta     $28
        lda     $075e
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sta     $1a
        sty     $2a
        lda     $0761
        sec
        sbc     $075d
        sta     $28
        lda     $0760
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2d
        cmp     $1a
        bne     @09c4
        ldy     $2a
        cpy     $2d
        bcc     @09c4
        ldx     $075e
        ldy     $0760
        stx     $0760
        sty     $075e
        ldx     $2a
        ldy     $2d
        stx     $2d
        sty     $2a
@09c4:  lda     $0761
        sec
        sbc     $075f
        bcc     @09f7
        sta     $28
        lda     $0760
        sta     $26
        sec
        lda     $075e
        sta     $27
        jsr     CalcWindowPos
        sty     $30
        lda     $075f
        sta     $32
        lda     $0761
        sta     $2f
        lda     $075c
        longa
        xba
        tax
        tay
        shorta0
        jmp     @0ac2
@09f7:  eor     #$ff
        inc
        sta     $28
        lda     $075e
        sta     $26
        sec
        lda     $0760
        sta     $27
        jsr     CalcWindowPos
        sty     $30
        lda     $0761
        sta     $32
        lda     $075f
        sta     $2f
        lda     $075c
        longa
        xba
        tax
        tay
        shorta0
        jmp     @0b18
@0a24:  lda     $0761
        sec
        sbc     $075d
        sta     $28
        lda     $0760
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2a
        lda     $0761
        sec
        sbc     $075f
        sta     $28
        lda     $0760
        sta     $26
        lda     $075e
        sta     $27
        jsr     CalcWindowPos
        sty     $2d
        lda     $075d
        sta     $2c
        lda     $0761
        sta     $32
        sta     $2f
        longa
        lda     $075c
        and     #$00ff
        xba
        tax
        lda     $075e
        and     #$00ff
        xba
        tay
        shorta0
        jmp     @0ac2
@0a78:  lda     $075f
        sec
        sbc     $075d
        sta     $28
        lda     $075e
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2a
        lda     $0761
        sec
        sbc     $075d
        sta     $28
        lda     $0760
        sta     $26
        lda     $075c
        sta     $27
        jsr     CalcWindowPos
        sty     $2d
        lda     $075d
        sta     $2c
        lda     $0761
        sta     $2f
        sta     $32
        lda     $075c
        longa
        xba
        tax
        tay
        shorta0
        jmp     @0ac2
@0ac2:  lda     $2c
        jsr     ResetWindowPos
        lda     $32
        sec
        sbc     $2c
        beq     @0aeb
        sta     $22
        stz     $23
        longac
@0ad4:  txa
        clc
        adc     $2a
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $2d
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0ad4
        shorta0
@0aeb:  lda     $2f
        sec
        sbc     $32
        beq     @0b0f
        sta     $22
        stz     $23
        longac
@0af8:  txa
        clc
        adc     $30
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $2d
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0af8
        shorta0
@0b0f:  lda     #$d0
        sec
        sbc     $2f
        jsr     ResetWindowPos
        rts
@0b18:  lda     $2c
        jsr     ResetWindowPos
        lda     $32
        sec
        sbc     $2c
        beq     @0b41
        sta     $22
        stz     $23
        longac
@0b2a:  txa
        clc
        adc     $2a
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $2d
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0b2a
        shorta0
@0b41:  lda     $2f
        sec
        sbc     $32
        beq     @0b65
        sta     $22
        stz     $23
        longac
@0b4e:  txa
        clc
        adc     $2a
        tax
        sta     hWMDATA-1
        tya
        clc
        adc     $30
        tay
        sta     hWMDATA-1
        dec     $22
        bne     @0b4e
        shorta0
@0b65:  lda     #$d0
        sec
        sbc     $2f
        jsr     ResetWindowPos
        rts

; ------------------------------------------------------------------------------

; [ set window 2 hdma lines to fully closed ]

; x = number of lines to set

ResetWindowPos:
@0b6e:  phx
        tax
        beq     @0b7d
        lda     #$ff                    ; left side if window = $ff
@0b74:  sta     hWMDATA
        stz     hWMDATA                 ; right side if window = $00
        dex                             ; left > right, so the window is empty
        bne     @0b74
@0b7d:  plx
        rts

; ------------------------------------------------------------------------------

; [  ]

CalcWindowPos:
@0b7f:  lda     $26
        sec
        sbc     $27
        bcc     @0b9b
        xba
        tay
        sty     hWRDIVL
        lda     $28
        sta     hWRDIVB
        tdc
        nop6
        ldy     hRDDIVL
        rts
@0b9b:  eor     #$ff
        inc
        xba
        tay
        sty     hWRDIVL
        lda     $28
        sta     hWRDIVB
        tdc
        nop5
        longa
        lda     hRDDIVL
        eor     $02
        inc
        tay
        shorta0
        lda     #$01
        rts

; ------------------------------------------------------------------------------

; [ update spotlights ]

UpdateSpotlights:
@0bbd:  lda     $0521
        and     #$20
        bne     @0bc5                   ; return if spotlights are not enabled
        rts
@0bc5:  inc     $0566
        lda     $0566
        lsr
        bcs     @0bd6
        ldx     #$8cb3
        stx     hWMADDL
        bra     @0bdc
@0bd6:  ldx     #$8e53
        stx     hWMADDL
@0bdc:  lda     #$7e
        sta     hWMADDH
        stz     $26
        lda     $0790
        lsr
        bcs     @0c16
        longa
        lda     $0783
        clc
        adc     #$0032
        sta     $0783
        shorta0
        lda     $0784
        tax
        lda     f:SineTbl8,x               ; sin/cos table
        clc
        adc     #$80
        lsr
        sta     $27
        longa
        inc     $0790
        lda     $0790
        lsr
        and     #$00ff
        shorta
        bra     @0c4b
@0c16:  longa
        lda     $0785
        clc
        adc     #$001e
        sta     $0785
        shorta0
        lda     $0786
        clc
        adc     #$40
        tax
        lda     f:SineTbl8,x               ; sin/cos table
        clc
        adc     #$80
        lsr
        clc
        adc     #$70
        sta     $27
        longa
        inc     $0790
        lda     $0790
        lsr
        clc
        adc     #$0040
        and     #$00ff
        shorta
@0c4b:  tax
        lda     f:SineTbl8,x               ; sin/cos table
        bmi     @0c66
        longa
        asl
        sec
        sbc     #$0018
        sta     $20
        clc
        adc     #$0030
        sta     $24
        shorta0
        bra     @0c81
@0c66:  longa
        eor     $02
        inc
        asl
        eor     $02
        inc
        ora     #$fe00
        sec
        sbc     #$0018
        sta     $20
        clc
        adc     #$0030
        sta     $24
        shorta0
@0c81:  longac
        lda     $26
        tax
        adc     #$0c00
        tay
        shorta0
        lda     $21
        bmi     @0c93
        bra     @0c9b
@0c93:  lda     $25
        bmi     @0c99
        bra     @0cd5
@0c99:  bra     @0d17
@0c9b:  lda     #$68
        sta     $22
        stz     $23
        longac
@0ca3:  txa
        adc     $20
        tax
        bcs     @0cc3
@0ca9:  sta     hWMDATA-1
        tya
        adc     $24
        tay
        bcs     @0ccb
@0cb2:  sta     hWMDATA-1
        stx     hWMDATA-1
        sty     hWMDATA-1
        dec     $22
        bne     @0ca3
        shorta0
        rts
@0cc3:  lda     $02
        tax
        stz     $20
        clc
        bra     @0ca9
@0ccb:  lda     $02
        tay
        stz     $24
        stz     $25
        clc
        bra     @0cb2
@0cd5:  lda     #$68
        sta     $22
        stz     $23
        longa
        lda     $20
        eor     $02
        inc
        sta     $20
@0ce4:  txa
        sec
        sbc     $20
        tax
        bcc     @0d06
@0ceb:  sta     hWMDATA-1
        tya
        clc
        adc     $24
        tay
        bcs     @0d0d
@0cf5:  sta     hWMDATA-1
        stx     hWMDATA-1
        sty     hWMDATA-1
        dec     $22
        bne     @0ce4
        shorta0
        rts
@0d06:  ldx     $00
        stx     $20
        tdc
        bra     @0ceb
@0d0d:  lda     $02
        tay
        stz     $24
        stz     $25
        clc
        bra     @0cf5
@0d17:  lda     #$68
        sta     $22
        stz     $23
        longa
        lda     $20
        eor     $02
        inc
        sta     $20
        lda     $24
        eor     $02
        inc
        sta     $24
@0d2d:  txa
        sec
        sbc     $20
        tax
        bcc     @0d4f
@0d34:  sta     hWMDATA-1
        tya
        sec
        sbc     $24
        tay
        bcc     @0d56
@0d3e:  sta     hWMDATA-1
        stx     hWMDATA-1
        sty     hWMDATA-1
        dec     $22
        bne     @0d2d
        shorta0
        rts
@0d4f:  ldx     $00
        stx     $20
        tdc
        bra     @0d34
@0d56:  ldy     $00
        sty     $24
        tdc
        bra     @0d3e
        lda     #$7e
        pha
        plb
        longa
        ldy     $00
        tyx
@0d66:  lda     $7d08,y
        cmp     #$8753
        bne     @0d75
        lda     f:_c00d8d,x
        sta     $7d08,y
@0d75:  txa
        clc
        adc     #$0002
        and     #$0007
        tax
        iny3
        cpy     #$005a
        bne     @0d66
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

_c00d8d:
@0d8d:  .word   $8763,$8773,$8783,$8793

; ------------------------------------------------------------------------------

; [ unused ??? ]

; this seems to be an unused fixed color effect for the spotlights

EffectColor:
@0d95:  lda     #$20                    ; set bit for red
        sta     $0752
        lda     #$40                    ; set bit for green
        sta     $0753
        lda     #$80
        sta     hWRMPYA                 ; multiplicand
        ldx     #$8763
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     a:$0046                 ; frame counter
        and     #$1f
        tax
        stx     $1e
        lda     a:$0046                 ; frame counter
        asl
        and     #$1f
        tax
        stx     $20
        ldy     #$0020
@0dc3:  ldx     $1e
        lda     f:EffectColorRedTbl,x
        sta     hWRMPYB                 ; multiplier
        txa
        inc
        and     #$1f
        sta     $1e
        lda     hRDMPYH
        ora     $0752
        sta     hWMDATA
        ldx     $20
        lda     f:EffectColorGreenTbl,x
        sta     hWRMPYB                 ; multiplier
        txa
        inc
        and     #$1f
        sta     $20
        lda     hRDMPYH
        ora     $0753
        sta     hWMDATA
        dey
        bne     @0dc3
        rts

; ------------------------------------------------------------------------------

EffectColorRedTbl:
@0df7:  .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
        .byte   $1f,$1e,$1d,$1c,$1b,$1a,$19,$18,$17,$16,$15,$14,$13,$12,$11,$10

EffectColorGreenTbl:
@0e17:  .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
        .byte   $0f,$0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00

; ------------------------------------------------------------------------------

; [ update mosaic hdma data ]

UpdateMosaic:
@0e37:  lda     $11f0
        beq     @0e61
        inc
        longa
        asl4
        sta     $10
        lda     $0796
        sec
        sbc     $10
        sta     $0796
        bpl     @0e56
        stz     $0796
        stz     $11f0
@0e56:  shorta0
        lda     $0797
        tax
        lda     f:MosaicTbl,x
@0e61:  sta     $7e8233
        sta     $7e8237
        sta     $7e823b
        sta     $7e823f
        sta     $7e8243
        sta     $7e8247
        sta     $7e824b
        sta     $7e824f
        rts

; ------------------------------------------------------------------------------

MosaicTbl:
@0e82:  .byte   $0f,$1f,$2f,$3f,$4f,$5f,$6f,$7f,$8f,$9f,$af,$bf,$cf,$df,$ef
        .byte   $ff,$ef,$df,$cf,$bf,$af,$9f,$8f,$7f,$6f,$5f,$4f,$3f,$2f,$1f

; ------------------------------------------------------------------------------

; [ update shake screen ]

UpdateShake:
@0ea0:  lda     $46
        lsr
        bcc     @0ec8
        lda     $074b
        sta     hWRMPYA
        lda     #$c0
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        sta     $074b
        ldx     $00
        stx     $074c
        stx     $074e
        stx     $0750
        stx     a:$007f
        rts
@0ec8:  lda     $074a
        and     #$03
        sta     $22
        beq     @0f07
        lda     $074a
        and     #$0c
        lsr2
        beq     @0ee6
        tax
        jsr     Rand
        and     f:ShakeAndTbl,x
        bne     @0f07
        bra     @0efa
@0ee6:  lda     $074a
        and     #$fc
        sta     $074a
        lda     $22
        tax
        lda     f:ShakeAndTbl,x
        sta     $074b
        bra     @0f07
@0efa:  lda     $22
        tax
        jsr     Rand
        and     f:ShakeAndTbl,x
        sta     $074b
@0f07:  stz     $074d
        stz     $074f
        stz     $0751
        stz     a:$0080
        lda     $074a
        and     #$10
        beq     @0f20
        lda     $074b
        sta     $074c
@0f20:  lda     $074a
        and     #$20
        beq     @0f2d
        lda     $074b
        sta     $074e
@0f2d:  lda     $074a
        and     #$40
        beq     @0f3a
        lda     $074b
        sta     $0750
@0f3a:  lda     $074a
        bpl     @0f44
        lda     $074b
        sta     $7f
@0f44:  rts

; ------------------------------------------------------------------------------

; screen shake data

ShakeAndTbl:
@0f45:  .byte   $00,$03,$06,$0c

ShakeRandTbl:
@0f49:  .byte   $00,$07,$0f,$1f

; ------------------------------------------------------------------------------

; [ begin fade in ]

FadeIn:
@0f4d:  lda     #$10
        sta     $4a
        lda     #$10
        sta     $4c
        rts

; ------------------------------------------------------------------------------

; [ begin fade out ]

FadeOut:
@0f56:  lda     #$90
        sta     $4a
        lda     #$f0
        sta     $4c
        rts

; ------------------------------------------------------------------------------

; [ update screen brightness ]

UpdateBrightness:
@0f5f:  lda     $4a
        bmi     @0f76
        lda     $4c
        and     #$f0
        cmp     #$f0
        beq     @0f89
        lda     $4a
        and     #$1f
        clc
        adc     $4c
        sta     $4c
        bra     @0f8b
@0f76:  lda     $4c
        beq     @0f89
        lda     $4a
        and     #$1f
        sta     $10
        lda     $4c
        sec
        sbc     $10
        sta     $4c
        bra     @0f8b
@0f89:  stz     $4a
@0f8b:  lda     $4c
        lsr4
        sta     hINIDISP
        rts

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

; [ begin fixed color addition ]

InitFixedColorAdd:
@102b:  pha
        lda     $4e                     ; save color add/sub settings
        sta     $4f
        lda     $52                     ; save subscreen designation
        sta     $53
        stz     $52                     ; disable all layers in subscreen
        lda     #$07
        sta     $4e                     ; set color add/sub settings
        pla
        bra     _104d

; ------------------------------------------------------------------------------

; [ begin fixed color subtraction ]

InitFixedColorSub:
@103d:  pha
        lda     $4e
        sta     $4f
        lda     $52
        sta     $53
        stz     $52
        lda     #$87
        sta     $4e
        pla
_104d:  jsr     CalcFixedColor
        stz     $4d
        rts

; ------------------------------------------------------------------------------

; [ update fixed color add/sub hdma data ]

UpdateFixedColor:
@1053:  lda     $4b
        bpl     @1072                   ; branch if fading out
        and     #$7f
        clc
        adc     $4d                     ; add speed to current intensity
        sta     $4d
        lda     $54                     ; branch if not past target intensity
        and     #$1f
        asl3
        cmp     $4d
        bcs     @1087
        lda     $4d                     ; clear lower 3 bits (target intensity reached)
        and     #$f8
        sta     $4d
        jmp     @1087
@1072:  lda     $4d
        beq     @107d
        sec
        sbc     $4b                     ; subtract speed from current intensity
        sta     $4d
        bra     @1087
@107d:  lda     $4f
        sta     $4e
        lda     $53
        sta     $52
        stz     $4b
@1087:  lda     $4d                     ; color intensity
        lsr3
        sta     $0e
        beq     @109a                   ; branch if intensity is zero
        lda     $54
        and     #$e0                    ; color components
        beq     @109a                   ; use white if there are no colors
        ora     $0e
        bra     @109c
@109a:  lda     #$e0                    ; set to white
@109c:  sta     $7e8753                 ; set fixed color hdma data ($2132)
        sta     $7e8755
        sta     $7e8757
        sta     $7e8759
        sta     $7e875b
        sta     $7e875d
        sta     $7e875f
        sta     $7e8761
        lda     $4e                     ; fixed color add/sub settings ($2131)
        sta     $7e8c64
        sta     $7e8c66
        sta     $7e8c68
        sta     $7e8c6a
        sta     $7e8c6c
        sta     $7e8c6e
        sta     $7e8c70
        sta     $7e8c72
        lda     $50                     ; color addition select ($2130)
        sta     $7e8c63
        sta     $7e8c65
        sta     $7e8c67
        sta     $7e8c69
        sta     $7e8c6b
        sta     $7e8c6d
        sta     $7e8c6f
        sta     $7e8c71
        lda     $52                     ; subscreen designation ($212d)
        sta     $7e8164
        sta     $7e8166
        sta     $7e8168
        sta     $7e816a
        sta     $7e816c
        sta     $7e816e
        sta     $7e8170
        sta     $7e8172
        rts

; ------------------------------------------------------------------------------

; [ init fixed color add/sub ]

; a = bgrssiii
;     b: affect blue
;     g: affect green
;     r: affect red
;     s: speed
;     i: intensity

CalcFixedColor:
@1123:  pha
        pha
        and     #$e0                    ; colors affected
        sta     $1a
        pla
        and     #$07                    ; intensity
        asl2
        clc
        adc     #$03
        ora     $1a
        sta     $54
        pla
        and     #$18                    ; speed
        lsr3
        tax
        lda     f:FixedColorRateTbl,x
        sta     $4b
        rts

; ------------------------------------------------------------------------------

; fixed color speeds
FixedColorRateTbl:
@1143:  .byte   $81,$82,$84,$84

; ------------------------------------------------------------------------------

; [ bg color math $01: increment colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

BGColorInc:
@1147:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df                       ; first color
@114f:  lda     $7400,y                   ; red component (active color palette)
        and     #$1f
        cmp     $1a                       ; branch if greater than red constant
        bcs     @1159
        inc                               ; add 1
@1159:  sta     $1e
        lda     $7401,y                   ; blue component
        and     #$7c
        cmp     $1b                       ; branch if greater than blue constant
        bcs     @1166
        adc     #$04                      ; add 1
@1166:  sta     $1f
        longa
        lda     $7400,y                   ; green component
        and     #$03e0
        cmp     $20
        bcs     @1177
        adc     #$0020
@1177:  ora     $1e                       ; +$1e = modified color
        sta     $7400,y
        tdc                               ; next color
        shorta
        iny2
        cpy     $e0                       ; end of color range
        bne     @114f
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $03: decrement colors (restore to normal) ]

BGColorUnInc:
@118b:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1193:  lda     $7200,y                   ; unmodified red component
        and     #$1f
        sta     $1a
        lda     $7400,y                   ; active red component
        and     #$1f
        cmp     $1a
        beq     @11a4
        dec
@11a4:  sta     $1e
        lda     $7201,y                   ; unmodified blue component
        and     #$7c
        sta     $1b
        lda     $7401,y                   ; active blue component
        and     #$7c
        cmp     $1b
        beq     @11b8
        sbc     #$04
@11b8:  sta     $1f
        longa
        lda     $7200,y                   ; unmodified green component
        and     #$03e0
        sta     $20
        lda     $7400,y                   ; active green component
        and     #$03e0
        cmp     $20
        beq     @11d1
        sbc     #$0020
@11d1:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @1193
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $04: decrement colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

BGColorDec:
@11e5:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@11ed:  lda     $7400,y
        and     #$1f
        cmp     $1a
        beq     @11f9
        bcc     @11f9
        dec
@11f9:  sta     $1e
        lda     $7401,y
        and     #$7c
        cmp     $1b
        beq     @1208
        bcc     @1208
        sbc     #$04
@1208:  sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        cmp     $20
        beq     @121b
        bcc     @121b
        sbc     #$0020
@121b:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @11ed
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $06: increment colors (restore to normal) ]

BGColorUnDec:
@122f:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1237:  lda     $7200,y
        and     #$1f
        sta     $1a
        lda     $7400,y
        and     #$1f
        cmp     $1a
        beq     @1248
        inc
@1248:  sta     $1e
        lda     $7201,y
        and     #$7c
        sta     $1b
        lda     $7401,y
        and     #$7c
        cmp     $1b
        beq     @125c
        adc     #$04
@125c:  sta     $1f
        longa
        lda     $7200,y
        and     #$03e0
        sta     $20
        lda     $7400,y
        and     #$03e0
        cmp     $20
        beq     @1275
        adc     #$0020
@1275:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @1237
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $02: add color ]

BGColorIncFlash:
@1289:  lda     #$1f
        sta     $1a
        lda     #$7c
        sta     $1b
        ldx     #$03e0
        stx     $20
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@129e:  lda     $7400,y
        and     #$1f
        clc
        adc     $1a
        cmp     #$1f
        bcc     @12ac
        lda     #$1f
@12ac:  sta     $1e
        lda     $7401,y
        and     #$7c
        clc
        adc     $1b
        cmp     #$7c
        bcc     @12bc
        lda     #$7c
@12bc:  sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        clc
        adc     $20
        cmp     #$03e0
        bcc     @12d1
        lda     #$03e0
@12d1:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @129e
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $05: subtract color ]

BGColorDecFlash:
@12e5:  lda     $1a
        clc
        adc     #$04
        sta     $1a
        lda     $1b
        clc
        adc     #$10
        sta     $1b
        longa
        lda     $20
        clc
        adc     #$0080
        sta     $20
        shorta0
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1308:  lda     $7400,y
        and     #$1f
        sec
        sbc     $1a
        bpl     @1313
        tdc
@1313:  sta     $1e
        lda     $7401,y
        and     #$7c
        sec
        sbc     $1b
        bpl     @1320
        tdc
@1320:  sta     $1f
        longa
        lda     $7400,y
        and     #$03e0
        sec
        sbc     $20
        bpl     @1330
        tdc
@1330:  ora     $1e
        sta     $7400,y
        shorta0
        iny2
        cpy     $e0
        bne     @1308
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ bg color math $00/$07: restore all colors to normal ]

BGColorRestore:
@1344:  lda     #$7e
        pha
        plb
        longa
        shorti
        ldx     $00
@134e:  lda     $7200,x     ; copy unmodified palette to active palette
        sta     $7400,x
        lda     $7202,x
        sta     $7402,x
        lda     $7204,x
        sta     $7404,x
        lda     $7206,x
        sta     $7406,x
        lda     $7208,x
        sta     $7408,x
        lda     $720a,x
        sta     $740a,x
        lda     $720c,x
        sta     $740c,x
        lda     $720e,x
        sta     $740e,x
        txa
        clc
        adc     #$0010
        tax
        bne     @134e
        shorta0
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $01: increment colors ]

;  $1a = ---rrrrr red color target
;  $1b = -bbbbb-- blue color target
; +$20 = ------gg ggg----- green color target

SpriteColorInc:
@138f:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1397:  lda     $7500,y
        and     #$1f
        cmp     $1a
        bcs     @13a1
        inc
@13a1:  sta     $1e
        lda     $7501,y
        and     #$7c
        cmp     $1b
        bcs     @13ae
        adc     #$04
@13ae:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        cmp     $20
        bcs     @13bf
        adc     #$0020
@13bf:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @1397
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $03: decrement colors (back to normal) ]

SpriteColorUnInc:
@13d3:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@13db:  lda     $7300,y
        and     #$1f
        sta     $1a
        lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     @13ec
        dec
@13ec:  sta     $1e
        lda     $7301,y
        and     #$7c
        sta     $1b
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     @1400
        sbc     #$04
@1400:  sta     $1f
        longa
        lda     $7300,y
        and     #$03e0
        sta     $20
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     @1419
        sbc     #$0020
@1419:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @13db
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $04: decrement colors ]

;  $1a = red color target
;  $1b = blue color target
; +$20 = green color target

SpriteColorDec:
@142d:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1435:  lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     @1441
        bcc     @1441
        dec
@1441:  sta     $1e
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     @1450
        bcc     @1450
        sbc     #$04
@1450:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     @1463
        bcc     @1463
        sbc     #$0020
@1463:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @1435
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $06: increment colors (back to normal) ]

SpriteColorUnDec:
@1477:  lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@147f:  lda     $7300,y
        and     #$1f
        sta     $1a
        lda     $7500,y
        and     #$1f
        cmp     $1a
        beq     @1490
        inc
@1490:  sta     $1e
        lda     $7301,y
        and     #$7c
        sta     $1b
        lda     $7501,y
        and     #$7c
        cmp     $1b
        beq     @14a4
        adc     #$04
@14a4:  sta     $1f
        longa
        lda     $7300,y
        and     #$03e0
        sta     $20
        lda     $7500,y
        and     #$03e0
        cmp     $20
        beq     @14bd
        adc     #$0020
@14bd:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @147f
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $02: add colors (doesn't work) ]

SpriteColorIncFlash:
@14d1:  lda     #$1f
        sta     $1a
        lda     #$7c
        sta     $1b
        ldx     #$03e0
        stx     $20
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@14e6:  lda     $7500,y
        and     #$1f
        clc
        adc     $1a
        cmp     #$1f
        bcc     @14f4
        lda     #$1f
@14f4:  sta     $1e
        lda     $7501,y
        and     #$7c
        clc
        adc     $1b
        cmp     #$7c
        bcc     @1504
        lda     #$7c
@1504:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        clc
        adc     $20
        cmp     #$03e0
        bcc     @1519
        lda     #$03e0
@1519:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @14e6
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $05: subtract colors ]

SpriteColorDecFlash:
@152d:  lda     $1a
        clc
        adc     #$04
        sta     $1a
        lda     $1b
        clc
        adc     #$10
        sta     $1b
        longa
        lda     $20
        clc
        adc     #$0080
        sta     $20
        shorta0
        lda     #$7e
        pha
        plb
        shorti
        ldy     $df
@1550:  lda     $7500,y
        and     #$1f
        sec
        sbc     $1a
        bpl     @155b
        tdc
@155b:  sta     $1e
        lda     $7501,y
        and     #$7c
        sec
        sbc     $1b
        bpl     @1568
        tdc
@1568:  sta     $1f
        longa
        lda     $7500,y
        and     #$03e0
        sec
        sbc     $20
        bpl     @1578
        tdc
@1578:  ora     $1e
        sta     $7500,y
        shorta0
        iny2
        cpy     $e0
        bne     @1550
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ object color math $00/$07: restore all colors to normal ]

SpriteColorRestore:
@158c:  lda     #$7e
        pha
        plb
        longa
        shorti
        ldx     $00
@1596:  lda     $7300,x
        sta     $7500,x
        lda     $7302,x
        sta     $7502,x
        lda     $7304,x
        sta     $7504,x
        lda     $7306,x
        sta     $7506,x
        lda     $7308,x
        sta     $7508,x
        lda     $730a,x
        sta     $750a,x
        lda     $730c,x
        sta     $750c,x
        lda     $730e,x
        sta     $750e,x
        txa
        clc
        adc     #$0010
        tax
        bne     @1596
        shorta0
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load treasure chest map data ]

InitTreasures:
@15d7:  longa
        lda     $82
        asl
        tax
        lda     f:TreasurePropPtrs+2,x
        sta     $1e
        lda     f:TreasurePropPtrs,x
        tax
        shorta0
        cpx     $1e
        beq     @1637
@15ef:  longa
        lda     f:TreasureProp,x
        sta     $2a
        lda     f:TreasureProp+1,x
        sta     $2b
        phx
        lda     f:TreasureProp+2,x
        and     #$01ff
        lsr3
        tay
        lda     f:TreasureProp+2,x
        and     #$0007
        tax
        shorta0
        lda     $1e40,y
        and     f:BitOrTbl,x
        beq     @162d
        ldx     $2a
        lda     $7f0000,x
        cmp     #$13
        bne     @162d
        lda     #$12
        sta     $7f0000,x
@162d:  plx
        inx5
        cpx     $1e
        bne     @15ef
@1637:  rts

; ------------------------------------------------------------------------------

; [ load bg2/bg3 color add/sub data ]

InitColorMath:
@1638:  lda     $0540                   ; bg2/bg3 add/sub mode
        asl
        clc
        adc     $0540
        tax
        lda     f:MapColorMath,x        ; color math designation ($2131)
        sta     $4f
        lda     #$22                    ; addition select ($2130)
        sta     $50
        lda     $4b                     ; fixed color fade
        bne     @1653
        lda     $4f
        sta     $4e
@1653:  lda     f:MapColorMath+1,x      ; main screen designation ($212c)
        ora     #$01                    ; bg1 always on
        sta     $51
        lda     f:MapColorMath+2,x      ; sub screen designation ($212d)
        sta     $53
        sta     hTS
        lda     $4b
        bne     @166c
        lda     $53
        sta     $52
@166c:  rts

; ------------------------------------------------------------------------------

; [ load bg2/bg3 parallax scrolling data ]

InitParallax:
@166d:  lda     $0536                   ; bg2/bg3 scroll mode
        asl3
        tax
        lda     f:MapParallax,x         ; bg2 horizontal scroll speed
        bmi     @1688
        longa
        asl4
        sta     $054b
        shorta0
        bra     @169a
@1688:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054b
        shorta0
@169a:  lda     f:MapParallax+1,x       ; bg2 vertical scroll speed
        bmi     @16ae
        longa
        asl4
        sta     $054d
        shorta0
        bra     @16c0
@16ae:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054d
        shorta0
@16c0:  lda     f:MapParallax+2,x       ; bg3 horizontal scroll speed
        bmi     @16d4
        longa
        asl4
        sta     $054f
        shorta0
        bra     @16e6
@16d4:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054f
        shorta0
@16e6:  lda     f:MapParallax+3,x       ; bg3 vertical scroll speed
        bmi     @16fa
        longa
        asl4
        sta     $0551
        shorta0
        bra     @170c
@16fa:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0551
        shorta0
@170c:  lda     f:MapParallax+4,x       ; bg2 horizontal scroll multiplier
        sta     $0553
        lda     f:MapParallax+5,x       ; bg2 vertical scroll multiplier
        sta     $0554
        lda     f:MapParallax+6,x       ; bg3 horizontal scroll multiplier
        sta     $0555
        lda     f:MapParallax+7,x       ; bg3 vertical scroll multiplier
        sta     $0556
        rts

; ------------------------------------------------------------------------------

; [ init map size ]

InitMapSize:
@1729:  ldx     $00
        stx     $5b         ; clear scroll position
        stx     $5d
        stx     $5f
        stx     $61
        stx     $63
        stx     $65
        stx     $67
        stx     $69
        stx     $6b
        stx     $6d
        stx     $6f
        stx     $71
        stx     $73         ; clear movement scroll speed
        stx     $75
        stx     $77
        stx     $79
        stx     $7b
        stx     $7d
        stx     $0547       ; clear event scroll speed
        stx     $0549
        stx     $054b
        stx     $054d
        stx     $054f
        stx     $0551
        stz     $0586       ; disable scrolling redraw
        stz     $0585
        stz     $0588
        stz     $0587
        stz     $058a
        stz     $0589
        jsr     InitScrollClip
        jsr     CalcScrollRange
        rts

; ------------------------------------------------------------------------------

; map size masks
ScrollClipTbl:
@177a:  .byte   $0f,$1f,$3f,$7f,$ff

; ------------------------------------------------------------------------------

; [ calculate min/max scroll positions ]

CalcScrollRange:
@177f:  ldx     $1fc0
        stx     $1f66
        ldx     $053e
        bne     @179a
        stz     $062c
        stz     $062e
        lda     #$ff
        sta     $062d
        sta     $062f
        bra     @17b6
@179a:  lda     #$08
        sta     $062c
        lda     $053e
        sec
        sbc     #$07
        sta     $062d
        lda     #$07
        sta     $062e
        lda     $053f
        sec
        sbc     #$07
        sta     $062f
@17b6:  lda     $062c
        cmp     $1f66
        bcc     @17c3
        sta     $1f66
        bra     @17ce
@17c3:  lda     $062d
        cmp     $1f66
        bcs     @17ce
        sta     $1f66
@17ce:  lda     $062e
        cmp     $1f67
        bcc     @17db
        sta     $1f67
        bra     @17e6
@17db:  lda     $062f
        cmp     $1f67
        bcs     @17e6
        sta     $1f67
@17e6:  rts

; ------------------------------------------------------------------------------

; [ update bg clip data ]

InitScrollClip:
@17e7:  lda     $0537
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $89
        lda     $0537
        lsr2
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $88
        lda     $0537
        lsr4
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $87
        lda     $0537
        lsr6
        tax
        lda     f:ScrollClipTbl,x
        sta     $86
        lda     $0538
        lsr4
        and     #$03
        tax
        lda     f:ScrollClipTbl,x
        sta     $8b
        lda     $0538
        lsr6
        tax
        lda     f:ScrollClipTbl,x
        sta     $8a
        lda     $0538
        and     #$01
        sta     $0591
        lda     $0538
        lsr
        and     #$01
        sta     $0592
        lda     $0538
        lsr
        and     #$01
        sta     $0593
        rts

; ------------------------------------------------------------------------------

; [ init map tiles ]

InitMapTiles:
@185c:  lda     $0542
        sec
        sbc     #$0f
        sta     $0542
        lda     $0544
        sec
        sbc     #$0f
        sta     $0544
        lda     $0546
        sec
        sbc     #$0f
        sta     $0546
        lda     #$10
@1879:  pha
        jsr     InitBG1VScroll
        jsr     TfrBG1TilesVScroll
        jsr     InitBG2VScroll
        jsr     TfrBG2TilesVScroll
        jsr     InitBG3VScroll
        jsr     TfrBG3TilesVScroll
        inc     $0542
        inc     $0544
        inc     $0546
        pla
        dec
        bne     @1879
        dec     $0542
        dec     $0544
        dec     $0546
        rts

; ------------------------------------------------------------------------------

; [ check entrance triggers ]

CheckEntrances:
@18a3:  lda     $84         ; return if a map is loading
        bne     @18e3
        lda     $59         ; return if menu is opening
        bne     @18e3
        lda     $85         ; return if entrance triggers are disabled
        bne     @18e3
        lda     $56         ; return if entering battle
        bne     @18e3
        ldy     $0803       ; return if between tiles
        lda     $086a,y
        and     #$0f
        bne     @18e3
        lda     $086d,y
        and     #$0f
        bne     @18e3
        ldx     $e5         ; return if an event is running
        cpx     #$0000
        bne     @18e3
        lda     $e7
        cmp     #$ca
        bne     @18e3
        lda     $b8         ; branch if on a bridge tile
        and     #$04
        beq     @18dd
        lda     $b2         ; return if party is not on upper z-level
        cmp     #$01
        bne     @18e3
@18dd:  jsr     CheckLongEntrance
        jsr     CheckShortEntrance
@18e3:  rts

; ------------------------------------------------------------------------------

; [ check long entrance triggers ]

CheckLongEntrance:
@18e4:  longa
        lda     $82
        asl
        tax
        lda     f:LongEntrancePtrs+2,x
        sta     $1e
        lda     f:LongEntrancePtrs,x
        tax
        cmp     $1e
        jeq     @1a26
        shorta0
@18ff:  stz     $26
        stz     $28
        lda     f:LongEntrancePtrs+2,x
        bmi     @192b
        sta     $1a
        lda     f:LongEntrancePtrs+1,x
        cmp     $b0
        bne     @194d
        lda     $af
        sec
        sbc     f:LongEntrancePtrs,x
        bcc     @194d
        sta     $26
        lda     f:LongEntrancePtrs,x
        clc
        adc     $1a
        cmp     $af
        bcs     @195c
        bra     @194d
@192b:  and     #$7f
        sta     $1a
        lda     f:LongEntrancePtrs,x
        cmp     $af
        bne     @194d
        lda     $b0
        sec
        sbc     f:LongEntrancePtrs+1,x
        bcc     @194d
        sta     $28
        lda     f:LongEntrancePtrs+1,x
        clc
        adc     $1a
        cmp     $b0
        bcs     @195c
@194d:  longac
        txa
        adc     #7
        tax
        shorta0
        cpx     $1e
        bne     @18ff
        rts
@195c:  lda     #$01
        sta     $078e
        longa
        lda     f:LongEntrancePtrs+3,x
        and     #$0200
        beq     @196f
        jsr     SetParentMap
@196f:  lda     f:LongEntrancePtrs+3,x
        and     #$01ff
        cmp     #$01ff
        beq     @19e0
        lda     f:LongEntrancePtrs+3,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     @199f       ; branch if not a world map
        lda     f:LongEntrancePtrs+5,x
        sta     $1f60
        shorta0
        lda     #$01
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
@199f:  lda     f:LongEntrancePtrs+5,x   ; destination xy position
        sta     $1fc0
        shorta0
        lda     f:LongEntrancePtrs+4,x   ; facing direction
        and     #$30
        lsr4
        sta     $0743
        lda     f:LongEntrancePtrs+4,x   ; show map name
        and     #$08
        sta     $0745
        lda     #$01        ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:LongEntrancePtrs+4,x
        and     #$04
        beq     @19d0       ; branch if upper z-layer
        lsr
        sta     $0744
@19d0:  lda     #1        ; enable map load
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts
@19e0:  jsr     RestoreParentMap
        longa
        lda     f:LongEntrancePtrs+3,x
        and     #$fe00
        ora     $1f69
        sta     $1f64
        shorta0
        ldx     $1f69
        cpx     #$0003
        bcs     @1a0e       ; branch if not a world map
        ldy     $1f6b
        sty     $1f60
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
@1a0e:  lda     $1f68
        sta     $0743
        lda     f:LongEntrancePtrs+4,x
        and     #$08
        sta     $0745
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts
@1a26:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ set parent map ]

SetParentMap:
@1a2a:  longa
        lda     $82
        and     #$01ff
        sta     $1f69       ; parent map
        lda     $af
        sta     $1f6b       ; parent xy position
        shorta0
        ldy     $0803
        lda     $087e,y
        sta     $1fd2       ; parent map facing direction
        rts

; ------------------------------------------------------------------------------

; [ restore parent map position ]

RestoreParentMap:
@1a46:  phx
        shorta0
        lda     $1fd2       ; parent facing direction
        and     #$03
        eor     #$02        ; invert
        tax
        eor     #$80
        sta     $1f68       ; set facing direction
        lda     $1f6b
        clc
        adc     f:DirXTbl,x   ; x offset for parent facing direction
        sta     $1f6b
        lda     $1f6c
        clc
        adc     f:DirYTbl,x   ; y offset for parent facing direction
        sta     $1f6c
        plx
        rts

; ------------------------------------------------------------------------------

; x offset for parent facing direction
DirXTbl:
@1a6f:  .byte   $00,$01,$00,$ff

; y offset for parent facing direction
DirYTbl:
@1a73:  .byte   $ff,$00,$01,$00

; ------------------------------------------------------------------------------

; [ check short entrance triggers ]

CheckShortEntrance:
@1a77:  longa
        lda     $82
        asl
        tax
        lda     f:ShortEntrancePtrs+2,x
        sta     $1e
        lda     f:ShortEntrancePtrs,x
        tax
        cmp     $1e
        jeq     @1b77
@1a8f:  lda     f:ShortEntrancePtrs,x   ; check xy position
        cmp     $af
        beq     @1aa4
        txa
        clc
        adc     #6
        tax
        cpx     $1e
        bne     @1a8f
        jmp     @1b77
@1aa4:  lda     #$0001
        sta     $078e
        lda     f:ShortEntrancePtrs+2,x
        and     #$0200
        beq     @1ab6
        jsr     SetParentMap
@1ab6:  lda     f:ShortEntrancePtrs+2,x
        and     #$01ff
        cmp     #$01ff
        beq     @1b27
        lda     f:ShortEntrancePtrs+2,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     @1ae6
        lda     f:ShortEntrancePtrs+4,x
        sta     $1f60
        shorta0
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
@1ae6:  lda     f:ShortEntrancePtrs+4,x
        sta     $1fc0
        shorta0
        lda     f:ShortEntrancePtrs+3,x   ; facing direction
        lsr4
        and     #$03
        sta     $0743
        lda     f:ShortEntrancePtrs+3,x   ; show map name
        and     #$08
        sta     $0745
        lda     #$01        ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:ShortEntrancePtrs+3,x
        and     #$04
        beq     @1b17
        lsr
        sta     $0744
@1b17:  jsr     FadeOut
        lda     #$80
        sta     $11fa
        lda     #1
        sta     $84
        jsr     PushPartyMap
        rts
@1b27:  jsr     RestoreParentMap
        longa
        lda     f:ShortEntrancePtrs+2,x
        and     #$fe00
        ora     $1f69
        sta     $1f64
        shorta0
        ldx     $1f69
        cpx     #$0003
        bcs     @1b52
        ldy     $1f6b
        sty     $1f60
        lda     #$01
        sta     $84
        jsr     FadeOut
        rts
@1b52:  lda     $1f68
        sta     $0743
        ldy     $1f6b
        sty     $1f66
        lda     f:ShortEntrancePtrs+3,x
        and     #$08
        sta     $0745
        lda     #$80
        sta     $11fa
        lda     #1
        sta     $84
        jsr     FadeOut
        jsr     PushPartyMap
        rts
@1b77:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ calculate bg scroll positions ]

InitScrollPos:
@1b7b:  longa
        lda     $0541       ; bg1 scroll position
        and     #$00ff
        sec
        sbc     #$0007
        asl4
        sta     $5c
        lda     $0542
        and     #$00ff
        sec
        sbc     #$0007
        asl4
        sta     $60
        shorta0
        lda     $0553
        sta     hWRMPYA
        lda     $0541
        sta     hWRMPYB
        lda     $88
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0532
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $88
        sta     $0543
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $64
        shorta0
        lda     $0554
        sta     hWRMPYA
        lda     $0542
        sta     hWRMPYB
        lda     $89
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0533
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $89
        sta     $0544
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $68
        shorta0
        lda     $0555
        sta     hWRMPYA
        lda     $0541
        sta     hWRMPYB
        lda     $8a
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0534
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $8a
        sta     $0545
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $6c
        shorta0
        lda     $0556
        sta     hWRMPYA
        lda     $0542
        sta     hWRMPYB
        lda     $8b
        longa
        asl4
        ora     #$000f
        sta     $1e
        lda     $0535
        and     #$00ff
        asl4
        clc
        adc     hRDMPYL
        sta     $20
        lsr4
        shorta
        and     $8b
        sta     $0546
        longa
        lda     $20
        sec
        sbc     #$0070
        and     $1e
        sta     $70
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load map properties ]

LoadMapProp:
@1cad:  longa
        lda     $82         ; map index
        asl5                ; multiply by 33
        clc
        adc     $82
        tax
        shorta0
        ldy     $00
@1cbf:  lda     f:MapProp,x   ; map properties
        sta     $0520,y
        inx
        iny
        cpy     #33
        bne     @1cbf
        rts

; ------------------------------------------------------------------------------

; [ load tile properties ]

LoadTileProp:
@1cce:  lda     $0524
        asl
        tax
        longac
        lda     f:MapTilePropPtrs,x
        adc     #.loword(MapTileProp)
        sta     $f3
        shorta0
        lda     #^MapTileProp
        sta     $f5
        ldx     #$7600
        stx     $f6
        lda     #$7e
        sta     $f8
        jsl     Decompress
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 map to vram (top half) ]

TfrBG1TopTiles:
@1cf3:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $91
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$d9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg1 map to vram (bottom half) ]

TfrBG1BtmTiles:
@1d24:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        longa
        lda     a:$0091
        clc
        adc     #$0200
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$ddc0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg2 map to vram (top half) ]

TfrBG2TopTiles:
@1d5f:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $97
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e1c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg2 map to vram (bottom half) ]

TfrBG2BtmTiles:
@1d90:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        longa
        lda     a:$0097
        clc
        adc     #$0200
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e5c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 map to vram (top half) ]

TfrBG3TopTiles:
@1dcb:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $9d
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 map to vram (bottom half) ]

TfrBG3BtmTiles:
@1dfc:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        longa
        lda     a:$009d
        clc
        adc     #$0200
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$edc0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0400
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ copy map changes to vram ]

TfrMapTiles:
@1e37:  lda     $055a       ; bg1 map data update status
        beq     @1e59       ; skip if not 1 or 2
        cmp     #$03
        bcs     @1e59
        dec
        bne     @1e51       ; branch if 2
        jsr     TfrBG1BtmTiles
        lda     $5a
        ora     #$01        ; enable bg1 map flip
        sta     $5a
        stz     $055a
        bra     @1e9b
@1e51:  jsr     TfrBG1TopTiles
        dec     $055a
        bra     @1e9b
@1e59:  lda     $055b
        beq     @1e7b
        cmp     #$03
        bcs     @1e7b
        dec
        bne     @1e73
        jsr     TfrBG2BtmTiles
        lda     $5a
        ora     #$02
        sta     $5a
        stz     $055b
        bra     @1e9b
@1e73:  jsr     TfrBG2TopTiles
        dec     $055b
        bra     @1e9b
@1e7b:  lda     $055c
        beq     @1e9b
        cmp     #$03
        bcs     @1e9b
        dec
        bne     @1e95
        jsr     TfrBG3BtmTiles
        lda     $5a
        ora     #$04
        sta     $5a
        stz     $055c
        bra     @1e9b
@1e95:  jsr     TfrBG3TopTiles
        dec     $055c
@1e9b:  lda     $055a       ; return if no maps need to be flipped
        ora     $055b
        ora     $055c
        bne     @1ec3
        lda     $5a
        and     #$01
        beq     @1eaf
        jsr     FlipBG1
@1eaf:  lda     $5a
        and     #$02
        beq     @1eb8
        jsr     FlipBG2
@1eb8:  lda     $5a
        and     #$04
        beq     @1ec1
        jsr     FlipBG3
@1ec1:  stz     $5a
@1ec3:  rts

; ------------------------------------------------------------------------------

; [ change map data ]

;  +$2a = pointer to map data ($0000 for bg1, $4000 for bg2, $8000 for bg3)
;  +$8f = destination offset (+$7f0000)
; ++$8c = source pointer (source format: width [1 byte], height [1 byte], tile data [1 byte each])

ModifyMap:
@1ec4:  lda     #$7f
        sta     $2f         ; ++$2d = destination
        lda     $8f
        sta     $2a
        lda     $90
        clc
        adc     $2b
        sta     $2b
        sta     $2e
        ldy     $00
        lda     [$8c],y     ; +$26 = width
        sta     $26
        stz     $27
        iny
        lda     [$8c],y     ; $28 = height
        sta     $28
        sta     $29
        iny
@1ee5:  ldx     $26         ; copy tile data
        lda     $2a
        sta     $2d
@1eeb:  lda     [$8c],y
        sta     [$2d]
        iny                 ; next tile
        inc     $2d
        dex
        bne     @1eeb
        inc     $2e         ; next row
        dec     $29
        bne     @1ee5
        longa
        lda     $2a
        and     #$3fff
        sta     $2a
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update bg1 map changes ]

;  $1b = x tile counter (16 tiles per line)
; +$1e = pointer to bg1 map (+$7fd9c0)
;  $20 = x start tile
;  $28 = y tile counter (8 lines per frame)
; +$2a = pointer to bg1 map data (+$7f0000)

UpdateBG1:
@1f08:  lda     $055a       ; return unless waiting for update in ram
        cmp     #$05
        beq     @1f13
        cmp     #$03
        bcs     @1f14
@1f13:  rts
@1f14:  cmp     #$04
        bne     @1f20
        lda     $0542       ; bg1 map update status = 04: top half
        sec
        sbc     #$07        ; bg1 center (y - 7)
        bra     @1f24
@1f20:  lda     $0542       ; bg1 map update status = 03: bottom half
        inc                 ; bg1 center (y + 1)
@1f24:  and     $87         ; bg1 vertical clip
        sta     $2b
        lda     $0541
        sec
        sbc     #$07        ; bg1 center (x - 7)
        and     $86         ; bg1 horizontal clip
        sta     $2a
        sta     $20         ; x start
        lda     $058c       ; flip map data in vram
        eor     #$04
        sta     $92
        stz     $91
        shorta0
        lda     $2a         ;
        and     #$0f
        asl2
        sta     $1e
        stz     $1f
        lda     $2b
        and     #$0f
        xba
        longa
        lsr
        ora     $1e
        sta     $1e
        shorta0
        lda     #$08        ; set y tile counter to 8
        sta     $28
        lda     #$7f
        pha
        plb
@1f61:  lda     #$10        ; set x tile counter to 16
        sta     $1b
        ldy     $1e
        lda     $20
        sta     $2a
@1f6b:  lda     ($2a)       ; get tile index
        longa
        asl
        tax
        lda     $c000,x     ; copy bg1 tile formation to bg1 map
        sta     $d9c0,y
        lda     $c200,x
        sta     $d9c2,y
        lda     $c400,x
        sta     $da00,y
        lda     $c600,x
        sta     $da02,y
        tya
        clc
        adc     #$0004
        and     #$ffbf
        tay
        shorta0
        lda     $2a         ; increment pointer to map data (x)
        inc
        and     $86         ; bg1 horizontal mask
        sta     $2a
        dec     $1b         ; decrement x tile counter
        bne     @1f6b       ; next tile
        lda     $2b         ; increment pointer to map data (y)
        inc
        and     $87         ; bg1 vertical mask
        sta     $2b
        longac
        lda     $1e         ; increment pointer to map (y)
        adc     #$0080
        and     #$07ff
        sta     $1e
        shorta0
        dec     $28         ; decrement y tile counter
        bne     @1f61       ; next line
        lda     #$00
        pha
        plb
        dec     $055a       ; decrement bg1 map update status
        rts

; ------------------------------------------------------------------------------

; [ update bg2 map changes ]

UpdateBG2:
@1fc2:  lda     $055b
        cmp     #$05
        beq     @1fcd
        cmp     #$03
        bcs     @1fce
@1fcd:  rts
@1fce:  cmp     #$04
        bne     @1fda
        lda     $0544
        sec
        sbc     #$07
        bra     @1fde
@1fda:  lda     $0544
        inc
@1fde:  and     $89
        clc
        adc     #$40
        sta     $2b
        lda     $0543
        sec
        sbc     #$07
        and     $88
        sta     $2a
        sta     $20
        lda     $058e
        eor     #$04
        sta     $98
        stz     $97
        shorta0
        lda     $2a
        and     #$0f
        asl2
        sta     $1e
        stz     $1f
        lda     $2b
        and     #$0f
        xba
        longa
        lsr
        ora     $1e
        sta     $1e
        shorta0
        lda     #$08
        sta     $28
        lda     #$7f
        pha
        plb
@201e:  lda     #$10
        sta     $1b
        ldy     $1e
        lda     $20
        sta     $2a
@2028:  lda     ($2a)
        longa
        asl
        tax
        lda     $c800,x
        sta     $e1c0,y
        lda     $ca00,x
        sta     $e1c2,y
        lda     $cc00,x
        sta     $e200,y
        lda     $ce00,x
        sta     $e202,y
        tya
        clc
        adc     #$0004
        and     #$ffbf
        tay
        shorta0
        lda     $2a
        inc
        and     $88
        sta     $2a
        dec     $1b
        bne     @2028
        lda     $2b
        inc
        and     $89
        ora     #$40
        sta     $2b
        longac
        lda     $1e
        adc     #$0080
        and     #$07ff
        sta     $1e
        shorta0
        dec     $28
        bne     @201e
        lda     #$00
        pha
        plb
        dec     $055b
        rts

; ------------------------------------------------------------------------------

; [ update bg3 map changes ]

UpdateBG3:
@2081:  lda     $055c
        cmp     #$05
        beq     @208c
        cmp     #$03
        bcs     @208d
@208c:  rts
@208d:  cmp     #$04
        bne     @2099
        lda     $0546
        sec
        sbc     #$07
        bra     @209d
@2099:  lda     $0546
        inc
@209d:  and     $8b
        clc
        sta     $2b
        lda     $0545
        sec
        sbc     #$07
        and     $8a
        sta     $2a
        sta     $24
        lda     $0590
        eor     #$04
        sta     $9e
        stz     $9d
        shorta0
        lda     $2a
        and     #$0f
        asl2
        sta     $1e
        stz     $1f
        lda     $2b
        and     #$0f
        xba
        longa
        lsr
        ora     $1e
        sta     $1e
        shorta0
        lda     #$08
        sta     $28
@20d7:  lda     #$10
        sta     $1b
        ldy     $1e
        lda     $24
        sta     $2a
        jsr     _c0249a
        lda     $2b
        inc
        and     $8b
        sta     $2b
        longac
        lda     $1e
        adc     #$0080
        and     #$07ff
        sta     $1e
        shorta0
        dec     $28
        bne     @20d7
        dec     $055c
        rts

; ------------------------------------------------------------------------------

; [ update bg for scrolling ]

UpdateScroll:
@2102:  lda     $0589       ; bg3 vertical scroll
        cmp     #$01
        bne     @2111
        jsr     UpdateBG3VScroll
        inc     $0589
        bra     @211e
@2111:  lda     $058a       ; bg3 horizontal scroll
        cmp     #$01
        bne     @211e
        jsr     UpdateBG3HScroll
        inc     $058a
@211e:  lda     $0586       ; bg1 horizontal scroll
        cmp     #$01
        bne     @212b
        jsr     UpdateBG1HScroll
        inc     $0586
@212b:  lda     $0588       ; bg2 horizontal scroll
        cmp     #$01
        bne     @2139
        jsr     UpdateBG2HScroll
        inc     $0588
        rts
@2139:  lda     $0585       ; bg1 vertical scroll
        cmp     #$01
        bne     @2146
        jsr     UpdateBG1VScroll
        inc     $0585
@2146:  lda     $0587       ; bg2 vertical scroll
        cmp     #$01
        bne     @2153
        jsr     UpdateBG2VScroll
        inc     $0587
@2153:  rts

; ------------------------------------------------------------------------------

; [ update bg1 for scrolling (vertical) ]

UpdateBG1VScroll:
@2154:  longac
        lda     $75
        adc     $0549
        bmi     _2168

InitBG1VScroll:
@215d:  shorta0
        lda     $0542
        clc
        adc     #$08
        bra     _2171

_2168:  shorta0
        lda     $0542
        sec
        sbc     #$07
_2171:  and     $87
        clc
        adc     #$00
        sta     $2b
        and     #$0f
        longa
        xba
        lsr2
        clc
        adc     $058b
        sta     $91
        shorta0
        lda     $0541
        sec
        sbc     #$07
        and     $86
        sta     $2a
        lda     $2a
        and     #$0f
        asl2
        tay
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@21a3:  lda     ($2a)
        bmi     @21d9
        asl
        tax
        longa
        lda     $c000,x
        sta     $d9c0,y
        lda     $c200,x
        sta     $d9c2,y
        lda     $c400,x
        sta     $da00,y
        lda     $c600,x
        sta     $da02,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $86
        sta     $2a
        dec     $1b
        bne     @21a3
        bra     @2209
@21d9:  asl
        tax
        longa
        lda     $c100,x
        sta     $d9c0,y
        lda     $c300,x
        sta     $d9c2,y
        lda     $c500,x
        sta     $da00,y
        lda     $c700,x
        sta     $da02,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $86
        sta     $2a
        dec     $1b
        bne     @21a3
@2209:  lda     #$00
        pha
        plb
        longi
        rts

; ------------------------------------------------------------------------------

; [ update bg1 for scrolling (horizontal) ]

UpdateBG1HScroll:
@2210:  longac
        lda     $73
        adc     $0547
        bmi     @2224
        shorta0
        lda     $0541
        clc
        adc     #$08
        bra     @222d
@2224:  shorta0
        lda     $0541
        sec
        sbc     #$07
@222d:  and     $86
        sta     $2a
        lda     $0542
        sec
        sbc     #$07
        and     $87
        clc
        adc     #$00
        sta     $2b
        and     #$0f
        asl2
        tay
        ldx     $2a
        stx     $2d
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@2251:  lda     ($2a)
        bmi     @2287
        asl
        tax
        longa
        lda     $c000,x
        sta     $d840,y
        lda     $c400,x
        sta     $d842,y
        lda     $c200,x
        sta     $d880,y
        lda     $c600,x
        sta     $d882,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $87
        sta     $2b
        dec     $1b
        bne     @2251
        bra     @22b7
@2287:  asl
        tax
        longa
        lda     $c100,x
        sta     $d840,y
        lda     $c500,x
        sta     $d842,y
        lda     $c300,x
        sta     $d880,y
        lda     $c700,x
        sta     $d882,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $87
        sta     $2b
        dec     $1b
        bne     @2251
@22b7:  longi
        lda     #$00
        pha
        plb
        lda     $2d
        and     #$0f
        asl
        sta     $93
        inc
        sta     $95
        lda     $058c
        sta     $94
        sta     $96
        rts

; ------------------------------------------------------------------------------

; [ update bg2 for scrolling (vertical) ]

UpdateBG2VScroll:
@22cf:  longac
        lda     $79
        adc     $054d
        bmi     _22e3

InitBG2VScroll:
@22d8:  shorta0
        lda     $0544
        clc
        adc     #$08
        bra     _22ec

_22e3:  shorta0
        lda     $0544
        sec
        sbc     #$07
_22ec:  and     $89
        clc
        adc     #$40
        sta     $2b
        and     #$0f
        longa
        xba
        lsr2
        clc
        adc     $058d
        sta     $97
        shorta0
        lda     $0543
        sec
        sbc     #$07
        and     $88
        sta     $2a
        lda     $2a
        and     #$0f
        asl2
        tay
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@231e:  lda     ($2a)
        bmi     @2354
        asl
        tax
        longa
        lda     $c800,x
        sta     $e1c0,y
        lda     $ca00,x
        sta     $e1c2,y
        lda     $cc00,x
        sta     $e200,y
        lda     $ce00,x
        sta     $e202,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $88
        sta     $2a
        dec     $1b
        bne     @231e
        bra     @2384
@2354:  asl
        tax
        longa
        lda     $c900,x
        sta     $e1c0,y
        lda     $cb00,x
        sta     $e1c2,y
        lda     $cd00,x
        sta     $e200,y
        lda     $cf00,x
        sta     $e202,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$bf
        tay
        lda     $2a
        inc
        and     $88
        sta     $2a
        dec     $1b
        bne     @231e
@2384:  lda     #$00
        pha
        plb
        longi
        rts

; ------------------------------------------------------------------------------

; [ update bg2 for scrolling (horizontal) ]

UpdateBG2HScroll:
@238b:  longac
        lda     $77
        adc     $054b
        bmi     @239f
        shorta0
        lda     $0543
        clc
        adc     #$08
        bra     @23a8
@239f:  shorta0
        lda     $0543
        sec
        sbc     #$07
@23a8:  and     $88
        sta     $2a
        lda     $0544
        sec
        sbc     #$07
        and     $89
        clc
        adc     #$40
        sta     $2b
        and     #$0f
        asl2
        tay
        ldx     $2a
        stx     $2d
        shorti
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@23cc:  lda     ($2a)
        bmi     @2404
        asl
        tax
        longa
        lda     $c800,x
        sta     $d8c0,y
        lda     $cc00,x
        sta     $d8c2,y
        lda     $ca00,x
        sta     $d900,y
        lda     $ce00,x
        sta     $d902,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $89
        ora     #$40
        sta     $2b
        dec     $1b
        bne     @23cc
        bra     @2436
@2404:  asl
        tax
        longa
        lda     $c900,x
        sta     $d8c0,y
        lda     $cd00,x
        sta     $d8c2,y
        lda     $cb00,x
        sta     $d900,y
        lda     $cf00,x
        sta     $d902,y
        tdc
        shortac
        tya
        adc     #$03
        and     #$3f
        tay
        lda     $2b
        inc
        and     $89
        ora     #$40
        sta     $2b
        dec     $1b
        bne     @23cc
@2436:  longi
        lda     #$00
        pha
        plb
        lda     $2d
        and     #$0f
        asl
        sta     $99
        inc
        sta     $9b
        lda     $058e
        sta     $9a
        sta     $9c
        rts

; ------------------------------------------------------------------------------

; [ update bg3 for scrolling (vertical) ]

UpdateBG3VScroll:
@244e:  longac
        lda     $7d
        adc     $0551
        bmi     _2466

InitBG3VScroll:
@2457:  shorta0
        lda     $0546
        clc
        adc     #$08
        and     $8b
        sta     $2b
        bra     _2473

_2466:  shorta0
        lda     $0546
        sec
        sbc     #$07
        and     $8b
        sta     $2b
_2473:  lda     $0545
        sec
        sbc     #$07
        and     $8a
        sta     $2a
        lda     $2b
        and     #$0f
        longa
        xba
        lsr2
        clc
        adc     $058f
        sta     $9d
        shorta0
        lda     $2a
        and     #$0f
        asl2
        tay
        jsr     _c0249a
        rts

; ------------------------------------------------------------------------------

; [ update two rows of bg3 map data ]

; common code for bg3 vertical scrolling and bg3 map changes
; +$2a = pointer to source bg3 map data (+$7f8000)
;    y = pointer to destination in bg3 map (+$7fe9c0)

_c0249a:
@249a:  lda     $0522       ; bg3 foreground
        and     #$80
        lsr2
        sta     $36        ; +$36 = tile flags
        stz     $37
        ldx     $2a
        stx     $2d
        lda     #$10
        sta     $1b         ; $1b = tile counter (16)
        lda     #$7f
        pha
        plb
@24b1:  ldx     $2a
        lda     $8000,x
        longa
        sta     $20
        and     #$003f      ; tile index
        tax
        lda     $20
        and     #$00c0      ; x/y flip
        ora     $36
        sta     $20         ; $20 = tile flags (w/ x/y flip)
        lda     $d000,x     ; bg3 tile formation
        and     #$001c      ; palette
        ora     $20
        xba
        sta     $22         ; +$22 = tile flags (w/ palette)
        and     #$c000
        cmp     #$4000      ; branch if horizontal flip only
        beq     @24fa
        cmp     #$8000      ; branch if vertical flip only
        beq     @2510
        cmp     #$c000      ; branch if horizontal and vertical flip
        beq     @2526
        txa
        asl2
        ora     $22
        sta     $e9c0,y     ; no flip
        inc
        sta     $e9c2,y
        inc
        sta     $ea00,y
        inc
        sta     $ea02,y
        bra     @253a
@24fa:  txa
        asl2
        ora     $22
        sta     $e9c2,y     ; horizontal flip
        inc
        sta     $e9c0,y
        inc
        sta     $ea02,y
        inc
        sta     $ea00,y
        bra     @253a
@2510:  txa
        asl2
        ora     $22
        sta     $ea00,y     ; vertical flip
        inc
        sta     $ea02,y
        inc
        sta     $e9c0,y
        inc
        sta     $e9c2,y
        bra     @253a
@2526:  txa
        asl2
        ora     $22
        sta     $ea02,y     ; horizontal and vertical flip
        inc
        sta     $ea00,y
        inc
        sta     $e9c2,y
        inc
        sta     $e9c0,y
@253a:  tya                 ; next tile
        inc3
        inc
        and     #$ffbf      ;
        tay
        shorta0
        lda     $2a
        inc
        and     $8a
        sta     $2a
        dec     $1b
        jne     @24b1
        lda     #$00
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ update bg3 for scrolling (horizontal) ]

UpdateBG3HScroll:
@2559:  longac
        lda     $7b
        adc     $054f
        bmi     @2571
        shorta0
        lda     $0545
        clc
        adc     #$08
        and     $8a
        sta     $2a
        bra     @257e
@2571:  shorta0
        lda     $0545
        sec
        sbc     #$07
        and     $8a
        sta     $2a
@257e:  lda     $0546
        sec
        sbc     #$07
        and     $8b
        sta     $2b
        and     #$0f
        asl2
        tay
        lda     $0522
        and     #$80
        lsr2
        sta     $36
        stz     $37
        ldx     $2a
        stx     $2d
        lda     #$10
        sta     $1b
        lda     #$7f
        pha
        plb
@25a4:  ldx     $2a
        lda     $8000,x
        longa
        sta     $20
        and     #$003f
        tax
        lda     $20
        and     #$00c0
        ora     $36
        sta     $20
        lda     $d000,x
        and     #$001c
        ora     $20
        xba
        sta     $22
        and     #$c000
        cmp     #$4000
        beq     @25ed
        cmp     #$8000
        beq     @2603
        cmp     #$c000
        beq     @2619
        txa
        asl2
        ora     $22
        sta     $d940,y
        inc
        sta     $d980,y
        inc
        sta     $d942,y
        inc
        sta     $d982,y
        bra     @262d
@25ed:  txa
        asl2
        ora     $22
        sta     $d980,y
        inc
        sta     $d940,y
        inc
        sta     $d982,y
        inc
        sta     $d942,y
        bra     @262d
@2603:  txa
        asl2
        ora     $22
        sta     $d942,y
        inc
        sta     $d982,y
        inc
        sta     $d940,y
        inc
        sta     $d980,y
        bra     @262d
@2619:  txa
        asl2
        ora     $22
        sta     $d982,y
        inc
        sta     $d942,y
        inc
        sta     $d980,y
        inc
        sta     $d940,y
@262d:  shorta0
        lda     $2b
        inc
        and     $8b
        sta     $2b
        tya
        inc4
        and     #$3f
        tay
        dec     $1b
        jne     @25a4
        lda     #$00
        pha
        plb
        lda     $2d
        and     #$0f
        asl
        sta     $9f
        inc
        sta     $a1
        lda     $0590
        sta     $a0
        sta     $a2
        rts

; ------------------------------------------------------------------------------

; [ load map palette ]

LoadMapPal:
@265c:  lda     $0539
        longa
        xba
        tax
        shorta0
        lda     #$7e
        pha
        plb
        ldy     $00
@266c:  lda     f:MapPal,x
        sta     $7200,y
        sta     $7400,y
        inx
        iny
        cpy     #$0100
        bne     @266c
        stz     $7200
        stz     $7201
        stz     $7400
        stz     $7401
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load bg1/bg2 graphics ]

; each tileset copies $2000 bytes, but they overlap in vram,
; so only the first $1000 bytes is available for tilesets 2-4

LoadMapGfx:
@268d:  ldy     #$0000      ; first tileset, $2000 bytes -> vram $0000
        lda     $0527
        and     #$7f
        jsr     TfrBG12Gfx
        ldy     #$1000      ; second tileset, $1000 bytes -> vram $1000
        longa
        lda     $0527
        asl
        and     #$7f00
        xba
        shorta
        jsr     TfrBG12Gfx
        ldy     #$1800      ; third tileset, $1000 bytes -> vram $1800
        longa
        lda     $0528
        asl2
        and     #$7f00
        xba
        shorta
        sta     $1b         ; $1b = third tileset index
        jsr     TfrBG12Gfx
        ldy     #$2000      ; fourth tileset, $1000 bytes -> vram $2000
        longa
        lda     $0529
        asl3
        and     #$7f00
        xba
        shorta
        cmp     $1b         ; skip tileset 4 if it's the same as tileset 3
        beq     @26d7
        jsr     TfrBG12Gfx
@26d7:  rts

; ------------------------------------------------------------------------------

; [ copy bg1/bg2 graphics to vram ]

; a = tileset index
; y = vram destination address

TfrBG12Gfx:
@26d8:  sty     hVMADDL
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        longa
        lda     f:MapGfxPtrs,x   ; ++$2a = pointer to tileset
        clc
        adc     #.loword(MapGfx)
        sta     $2a
        sta     $4302
        shorta
        lda     f:MapGfxPtrs+2,x
        adc     #^MapGfx
        sta     $2c
        sta     $4304
        sta     $4307
        longa
        lda     $2a
        beq     @2750
        tdc                 ; check if tileset spans two banks
        sec
        sbc     $2a
        cmp     #$2000
        bcs     @2750
        sta     $4305       ; size in first bank
        sta     $1e
        lda     #$2000
        sec
        sbc     $1e         ; +$1e = remainder of tileset in the next bank
        sta     $1e
        shorta0
        lda     #$01        ; first bank dma
        sta     hMDMAEN
        lda     $2c         ; increment bank
        inc
        sta     $4304
        sta     $4307
        ldx     $00
        stx     $4302
        ldx     $1e         ; size is remainder of data
        stx     $4305
        lda     #$01        ; second bank dma
        sta     hMDMAEN
        rts
@2750:  tdc                 ; no overflow, only need one dma
        shorta
        ldx     #$2000      ; full size $2000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ load bg3 graphics ]

TfrBG3Gfx:
@275f:  longa
        lda     $052a
        lsr4
        and     #$003f
        shorta
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longac
        lda     f:MapGfxBG3Ptrs,x
        adc     #.loword(MapGfxBG3)
        sta     $f3
        shorta0
        lda     #^MapGfxBG3
        sta     $f5
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        lda     #$7f
        pha
        plb
        ldx     $00
@2799:  lda     $d040,x
        sta     $d000,x
        inx
        cpx     #$0040
        bne     @2799
        tdc
        pha
        plb
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$3000      ; destination = $3000 (vram)
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$d080      ; source = $7fd080
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$1000      ; size = $1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ load tile formation ]

LoadTileset:
@27da:  longa
        lda     $052b
        lsr2
        and     #$007f
        shorta
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longac
        lda     f:MapTilesetPtrs,x   ; pointers to tilesets
        adc     #.loword(MapTileset)
        sta     $f3
        shorta0
        lda     f:MapTilesetPtrs+2,x   ; bank byte
        adc     #^MapTileset
        sta     $f5
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$c000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     $00
@281d:  lda     $7fd040,x
        sta     hWMDATA
        lda     $7fd440,x
        sta     hWMDATA
        inx
        cpx     #$0400
        bne     @281d
        lda     $052c
        lsr
        and     #$7f
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longac
        lda     f:MapTilesetPtrs,x
        adc     #.loword(MapTileset)
        sta     $f3
        shorta0
        lda     f:MapTilesetPtrs+2,x
        adc     #^MapTileset
        sta     $f5
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$c800
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     $00
@286e:  lda     $7fd040,x
        sta     hWMDATA
        lda     $7fd440,x
        sta     hWMDATA
        inx
        cpx     #$0400
        bne     @286e
        rts

; ------------------------------------------------------------------------------

; [ load map data ]

LoadMapTiles:
@2883:  longa
        lda     $052d       ; bg1 layout
        and     #$03ff
        sta     $1e
        asl
        clc
        adc     $1e
        tax
        lda     f:SubTilemapPtrs,x
        clc
        adc     #.loword(SubTilemap)
        sta     $f3
        shorta0
        lda     f:SubTilemapPtrs+2,x
        adc     #^SubTilemap
        sta     $f5
        cpx     $00
        beq     @28c2       ; branch if layout index is zero
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$0000
        lda     $86
        jsr     CopyMapTiles
        bra     @28d6
@28c2:  ldx     #$0000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     #$4000
@28d0:  stz     hWMDATA
        dex
        bne     @28d0
@28d6:  longa
        lda     $052e       ; bg2 layout
        lsr
        and     #$07fe
        sta     $1e
        lsr
        clc
        adc     $1e
        tax
        lda     f:SubTilemapPtrs,x
        clc
        adc     #.loword(SubTilemap)
        sta     $f3
        shorta0
        lda     f:SubTilemapPtrs+2,x
        adc     #^SubTilemap
        sta     $f5
        cpx     $00
        beq     @2916       ; branch if layout index is zero
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$4000
        lda     $88
        jsr     CopyMapTiles
        bra     @292a
@2916:  ldx     #$4000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     #$4000
@2924:  stz     hWMDATA
        dex
        bne     @2924
@292a:  longa
        lda     $052f       ; bg3 layout
        lsr3
        and     #$07fe
        sta     $1e
        lsr
        clc
        adc     $1e
        tax
        lda     f:SubTilemapPtrs,x
        clc
        adc     #.loword(SubTilemap)
        sta     $f3
        shorta0
        lda     f:SubTilemapPtrs+2,x
        adc     #^SubTilemap
        sta     $f5
        cpx     $00
        beq     @296b       ; branch if layout index is zero
        ldx     #$d040
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress
        ldx     #$8000
        lda     $8a
        jsr     CopyMapTiles
        rts
@296b:  ldx     #$8000
        stx     hWMADDL
        lda     #$7f
        sta     hWMADDH
        ldx     #$4000
@2979:  stz     hWMDATA
        dex
        bne     @2979
        rts

; ------------------------------------------------------------------------------

; [ copy bg map data to buffer ]

; A: horizontal clip

CopyMapTiles:
@2980:  cmp     #$0f
        jeq     @29f5
        cmp     #$1f
        jeq     @29cc
        cmp     #$3f
        jeq     @29a3
        jmp     @2a1e
@2998:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@29a3:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@29ae:  tdc
        ldy     #$0040
@29b2:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @29b2
        longac
        txa
        adc     #$00c0
        tax
        xba
        shorta
        and     #$3f
        bne     @29ae
        rts
@29cc:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@29d7:  tdc
        ldy     #$0020
@29db:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @29db
        longac
        txa
        adc     #$00e0
        tax
        xba
        shorta
        and     #$3f
        bne     @29d7
        rts
@29f5:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@2a00:  tdc
        ldy     #$0010
@2a04:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @2a04
        longac
        txa
        adc     #$00f0
        tax
        xba
        shorta
        and     #$3f
        bne     @2a00
        rts
@2a1e:  ldy     #$d040
        sty     hWMADDL
        lda     #$7f
        sta     hWMADDH
@2a29:  tdc
        ldy     #$0080
@2a2d:  lda     hWMDATA
        sta     $7f0000,x
        inx
        dey
        bne     @2a2d
        longac
        txa
        adc     #$0080
        tax
        xba
        shorta
        and     #$3f
        bne     @2a29
        rts

; ------------------------------------------------------------------------------

; [ update bg1 map data in vram (vertical scroll) ]

TfrBG1TilesVScroll:
@2a47:  stz     hMDMAEN
        lda     #$80        ; vram address increments horizontally
        sta     hVMAINC
        ldx     $91
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$d9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg1 map data in vram (horizontal scroll) ]

TfrBG1TilesHScroll:
@2a78:  stz     hMDMAEN
        lda     #$81        ; vram address increments vertically
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     $93
        stx     hVMADDL
        ldx     #$d840
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        ldx     $95
        stx     hVMADDL
        ldx     #$d880
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg2 map data in vram (vertical scroll) ]

TfrBG2TilesVScroll:
@2aca:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $97
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e1c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg2 map data in vram (horizontal scroll) ]

TfrBG2TilesHScroll:
@2afb:  stz     hMDMAEN
        lda     #$81
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     $99
        stx     hVMADDL
        ldx     #$d8c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        ldx     $9b
        stx     hVMADDL
        ldx     #$d900
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg3 map data in vram (vertical scroll) ]

TfrBG3TilesVScroll:
@2b4d:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     $9d
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$e9c0
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update bg3 map data in vram (horizontal scroll) ]

TfrBG3TilesHScroll:
@2b7e:  stz     hMDMAEN
        lda     #$81
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     $9f
        stx     hVMADDL
        ldx     #$d940
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        ldx     $a1
        stx     hVMADDL
        ldx     #$d980
        stx     $4302
        lda     #$7f
        sta     $4304
        sta     $4307
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ update scroll position ]

CalcScrollPos:
@2bd0:  longa
        shorti
        ldy     #$01
        lda     $73
        clc
        adc     $0547
        sta     $1e
        beq     @2c2e
        bmi     @2c08
        lda     $5b
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2bf9
        sty     $0586
        ldx     $0541
        inx
        stx     $0541
@2bf9:  lda     $5b
        clc
        adc     $1e
        sta     $5b
        lda     $5d
        adc     $00
        sta     $5d
        bra     @2c2e
@2c08:  eor     $02
        inc
        sta     $1e
        lda     $5b
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2c21
        sty     $0586
        ldx     $0541
        dex
        stx     $0541
@2c21:  lda     $5b
        sec
        sbc     $1e
        sta     $5b
        lda     $5d
        sbc     $00
        sta     $5d
@2c2e:  lda     $75
        clc
        adc     $0549
        sta     $1e
        bmi     @2c5e
        lda     $5f
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2c4f
        sty     $0585
        ldx     $0542
        inx
        stx     $0542
@2c4f:  lda     $5f
        clc
        adc     $1e
        sta     $5f
        lda     $61
        adc     $00
        sta     $61
        bra     @2c84
@2c5e:  eor     $02
        inc
        sta     $1e
        lda     $5f
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2c77
        sty     $0585
        ldx     $0542
        dex
        stx     $0542
@2c77:  lda     $5f
        sec
        sbc     $1e
        sta     $5f
        lda     $61
        sbc     $00
        sta     $61
@2c84:  lda     $77
        clc
        adc     $054b
        sta     $1e
        beq     @2cdc
        bmi     @2cb6
        lda     $63
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2ca7
        sty     $0588
        ldx     $0543
        inx
        stx     $0543
@2ca7:  lda     $63
        clc
        adc     $1e
        sta     $63
        lda     $65
        adc     $00
        sta     $65
        bra     @2cdc
@2cb6:  eor     $02
        inc
        sta     $1e
        lda     $63
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2ccf
        sty     $0588
        ldx     $0543
        dex
        stx     $0543
@2ccf:  lda     $63
        sec
        sbc     $1e
        sta     $63
        lda     $65
        sbc     $00
        sta     $65
@2cdc:  lda     $79
        clc
        adc     $054d
        sta     $1e
        bmi     @2d0c
        lda     $67
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2cfd
        sty     $0587
        ldx     $0544
        inx
        stx     $0544
@2cfd:  lda     $67
        clc
        adc     $1e
        sta     $67
        lda     $69
        adc     $00
        sta     $69
        bra     @2d32
@2d0c:  eor     $02
        inc
        sta     $1e
        lda     $67
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2d25
        sty     $0587
        ldx     $0544
        dex
        stx     $0544
@2d25:  lda     $67
        sec
        sbc     $1e
        sta     $67
        lda     $69
        sbc     $00
        sta     $69
@2d32:  lda     $7b
        clc
        adc     $054f
        sta     $1e
        beq     @2d8a
        bmi     @2d64
        lda     $6b
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2d55
        sty     $058a
        ldx     $0545
        inx
        stx     $0545
@2d55:  lda     $6b
        clc
        adc     $1e
        sta     $6b
        lda     $6d
        adc     $00
        sta     $6d
        bra     @2d8a
@2d64:  eor     $02
        inc
        sta     $1e
        lda     $6b
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2d7d
        sty     $058a
        ldx     $0545
        dex
        stx     $0545
@2d7d:  lda     $6b
        sec
        sbc     $1e
        sta     $6b
        lda     $6d
        sbc     $00
        sta     $6d
@2d8a:  lda     $7d
        clc
        adc     $0551
        sta     $1e
        bmi     @2dba
        lda     $6f
        and     #$0fff
        ora     #$f000
        clc
        adc     $1e
        bcc     @2dab
        sty     $0589
        ldx     $0546
        inx
        stx     $0546
@2dab:  lda     $6f
        clc
        adc     $1e
        sta     $6f
        lda     $71
        adc     $00
        sta     $71
        bra     @2de0
@2dba:  eor     $02
        inc
        sta     $1e
        lda     $6f
        and     #$0fff
        sec
        sbc     $1e
        bcs     @2dd3
        sty     $0589
        ldx     $0546
        dex
        stx     $0546
@2dd3:  lda     $6f
        sec
        sbc     $1e
        sta     $6f
        lda     $71
        sbc     $00
        sta     $71
@2de0:  longi
        shorta0
        rts

; ------------------------------------------------------------------------------

        .include "window.asm"
        .include "hdma.asm"
        .include "player.asm"
        .include "obj.asm"
        .include "text.asm"
        .include "anim.asm"
        .include "event.asm"
        .include "init.asm"
        .include "battle.asm"
        .include "menu.asm"
        .include "overlay.asm"

; ------------------------------------------------------------------------------

; horizontal flip flag for object graphics positions (upper sprite)
TopSpriteHFlip:
@cd3a:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

; horizontal flip flag for object graphics positions (lower sprite)
BtmSpriteHFlip:
@cdba:  .byte   $00,$00,$40,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $40,$40,$40,$00,$40,$00,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

; object spriteheet
MapSpriteTileOffsets:
@ce3a:  .word   $0000,$0020,$0040,$0060,$0080,$00a0 ; $00
        .word   $0000,$0020,$00c0,$00e0,$0100,$0120
        .word   $0000,$0020,$0140,$0160,$0080,$00a0
        .word   $0180,$01a0,$01c0,$01e0,$0200,$0220
        .word   $0180,$01a0,$0240,$0260,$0280,$02a0
        .word   $0180,$01a0,$02c0,$02e0,$0200,$0220
        .word   $0300,$0320,$0340,$0360,$0380,$03a0
        .word   $03c0,$03e0,$0400,$0420,$0440,$0460
        .word   $0300,$0320,$0480,$04a0,$04c0,$04e0 ; $08
        .word   $0700,$0720,$0740,$0760,$0780,$07a0
        .word   $07c0,$07e0,$0800,$0820,$0840,$0860
        .word   $0880,$08a0,$08c0,$08e0,$0900,$0920
        .word   $03c0,$03e0,$0500,$0520,$0540,$0560
        .word   $0300,$0320,$0580,$0360,$05a0,$03a0
        .word   $0300,$05c0,$05e0,$0600,$0620,$0640
        .word   $03c0,$0660,$0680,$06a0,$06c0,$06e0
        .word   $0940,$0960,$0980,$09a0,$09c0,$09e0 ; $10
        .word   $0940,$0960,$0a00,$09a0,$09c0,$09e0
        .word   $0a20,$0a40,$0a60,$0a80,$0aa0,$0ac0
        .word   $0000,$0020,$0ba0,$0bc0,$0100,$0120
        .word   $0000,$0020,$00c0,$0be0,$0100,$0120
        .word   $12c0,$03e0,$12e0,$0420,$0440,$0460
        .word   $0d40,$0d60,$0d80,$0da0,$0dc0,$0de0
        .word   $0e00,$0e20,$0e40,$0e60,$0e80,$0ea0
        .word   $0ec0,$0ee0,$0f00,$0f20,$0f40,$0f60 ; $18
        .word   $0d40,$0020,$0d80,$00e0,$0dc0,$0120
        .word   $1040,$0020,$1060,$00e0,$0dc0,$0120
        .word   $0180,$0e20,$0240,$0e60,$0280,$0ea0
        .word   $0180,$1080,$0240,$10a0,$0280,$0ea0
        .word   $0c00,$0c20,$0c40,$0c60,$0c80,$0ca0
        .word   $0cc0,$0ce0,$0d00,$0d20,$0c80,$0ca0
        .word   $0f80,$0fa0,$0fc0,$0fe0,$1000,$1020
        .word   $10c0,$10e0,$1100,$1120,$0100,$0120 ; $20
        .word   $1140,$1160,$1180,$11a0,$0280,$02a0
        .word   $11c0,$11e0,$1200,$1220,$0440,$0460
        .word   $1240,$1260,$1280,$12a0,$0100,$0120
        .word   $1460,$1480,$1300,$1320,$1340,$1360
        .word   $1460,$1480,$1380,$1320,$1340,$1360
        .word   $13a0,$13c0,$13e0,$1400,$1420,$1440
        .word   $14a0,$14c0,$14e0,$1500,$1520,$1540
        .word   $0a20,$0a40,$0a60,$0a80,$0aa0,$0ac0 ; $28 (alt. knocked out)
        .word   $0620,$0640,$0660,$0680,$06a0,$06c0 ; $29 (misc. npc's: special)
        .word   $0500,$0020,$0520,$00e0,$0540,$0120 ; $2a (misc. npc's: waving 1)
        .word   $0560,$0020,$0580,$00e0,$0540,$0120 ; $2b (misc. npc's: waving 1)
        .word   $05a0,$05c0,$05e0,$0600,$0100,$0120 ; $2c (misc. npc's: head down, facing down)
        .word   $0500,$0520,$0540,$0560,$0580,$05a0 ; $2d (misc. npc's: special)
        .word   $1620,$1640,$1660,$1680,$15e0,$1600 ; $2e (riding 1)
        .word   $1560,$1580,$15a0,$15c0,$15e0,$1600 ; $2f (riding 2)
        .word   $00c0,$0020,$00e0,$0060,$0100,$00a0 ; $30 (ramuh: staff raised)
        .word   $0120,$0140,$0040,$0060,$0080,$00a0 ; $31 (ramuh: eyes closed)
        .word   $0000,$0000,$0020,$0040,$0060,$0080 ; $32 (special animation frame 1)
        .word   $0000,$0000,$00a0,$00c0,$00e0,$0100 ; $33 (special animation frame 2)
        .word   $0000,$0000,$0120,$0140,$0160,$0180 ; $34 (special animation frame 3)
        .word   $0000,$0000,$01a0,$01c0,$01e0,$0200 ; $35 (special animation frame 4)
        .word   $05c0,$05e0,$0600,$0620,$0640,$0660 ; $36 (opera singing: mouth open)
        .word   $0680,$06a0,$06c0,$06e0,$0640,$0660 ; $37 (opera singing: mouth closed)
        .word   $0680,$06a0,$06c0,$06e0,$0640,$0660 ; $38 (opera singing: unused)
        .word   $0000,$0020,$0040,$0040,$0040,$0040 ; $39 (unused)

; pointers to object sprite graphics (lower 2 bytes)
MapSpriteGfxPtrsLo:
@d0f2:
.repeat 165, i
        .addr   .ident(.sprintf("MapSpriteGfx_%04x", i))
.endrep

; pointers to object sprite graphics, tile size (upper 2 bytes)
; the high byte gets copied to $4305 and determines the number of bytes per tile
MapSpriteGfxPtrsHi:
@d23c:
.repeat 165, i
        .word $2000 | (.ident(.sprintf("MapSpriteGfx_%04x", i))>>16)
.endrep

; ------------------------------------------------------------------------------

        .include "debug.asm"
        .include "header.asm"

; ------------------------------------------------------------------------------
