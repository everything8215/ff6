
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
.import OptimizeEquip_ext
.import InitSound_ext, ExecSound_ext
.import LoadWorld_ext, MagitekTrain_ext, EndingAirshipScene2_ext
.import OpeningCredits_ext, TitleScreen_ext
.import FloatingIslandScene_ext, WorldOfRuinScene_ext

.import WorldBattleRate, SubBattleRate
.import WindowGfx, WindowPal

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
@0008:  rtl
        nop2
        ; jmp     CheckBattleWorld

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
        jsr     ExecObjScript
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
        lda     #$01
        sta     $fe
        ldy     #$0002
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
        lda     #$08
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
        adc     #$03
        sta     $fb
        lda     [$f3],y
        ora     #$f8
        xba
        tay
@04d3:  lda     a:$0000,y
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
        ldx     #$00d7                  ; vertical timer set to scanline 215
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
        lda     f:$c2fe6d,x             ; sin/cos table
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
        lda     $c2fe6d,x               ; sin/cos table
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
        bne     @096f
        jmp     @0a78
@096f:  lda     $075d
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
        lda     $c2fe6d,x               ; sin/cos table
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
        lda     $c2fe6d,x               ; sin/cos table
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
        lda     $c2fe6d,x               ; sin/cos table
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

EffectColor:
@0d95:  lda     #$20
        sta     $0752
        lda     #$40
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
        lda     f:EffectColorTbl,x
        sta     hWRMPYB                 ; multiplier
        txa
        inc
        and     #$1f
        sta     $1e
        lda     hRDMPYH
        ora     $0752
        sta     hWMDATA
        ldx     $20
        lda     f:$c00e17,x
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

EffectColorTbl:
@0df7:  .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f
        .byte   $1f,$1e,$1d,$1c,$1b,$1a,$19,$18,$17,$16,$15,$14,$13,$12,$11,$10
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f
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
        lda     $ed82f6,x
        sta     $1e
        lda     $ed82f4,x
        tax
        shorta0
        cpx     $1e
        beq     @1637
@15ef:  longa
        lda     $ed8634,x
        sta     $2a
        lda     $ed8635,x
        sta     $2b
        phx
        lda     $ed8636,x
        and     #$01ff
        lsr3
        tay
        lda     $ed8636,x
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
        bne     @18fc
        jmp     @1a26
@18fc:  shorta0
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
        bne     @1a8f
        jmp     @1b77
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

TfrBG1TilesTop:
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

TfrBG1TilesBtm:
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

TfrBG2TilesTop:
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

TfrBG2TilesBtm:
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

TfrBG3TilesTop:
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

TfrBG3TilesBtm:
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
        jsr     TfrBG1TilesBtm
        lda     $5a
        ora     #$01        ; enable bg1 map flip
        sta     $5a
        stz     $055a
        bra     @1e9b
@1e51:  jsr     TfrBG1TilesTop
        dec     $055a
        bra     @1e9b
@1e59:  lda     $055b
        beq     @1e7b
        cmp     #$03
        bcs     @1e7b
        dec
        bne     @1e73
        jsr     TfrBG2TilesBtm
        lda     $5a
        ora     #$02
        sta     $5a
        stz     $055b
        bra     @1e9b
@1e73:  jsr     TfrBG2TilesTop
        dec     $055b
        bra     @1e9b
@1e7b:  lda     $055c
        beq     @1e9b
        cmp     #$03
        bcs     @1e9b
        dec
        bne     @1e95
        jsr     TfrBG3TilesBtm
        lda     $5a
        ora     #$04
        sta     $5a
        stz     $055c
        bra     @1e9b
@1e95:  jsr     TfrBG3TilesTop
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
        beq     @2554
        jmp     @24b1
@2554:  lda     #$00
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
        beq     @2646
        jmp     @25a4
@2646:  lda     #$00
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

; a = horizontal clip

CopyMapTiles:
@2980:  cmp     #$0f
        bne     @2987
        jmp     @29f5
@2987:  cmp     #$1f
        bne     @298e
        jmp     @29cc
@298e:  cmp     #$3f
        bne     @2995
        jmp     @29a3
@2995:  jmp     @2a1e
        ldy     #$d040
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

; [ copy dialog window graphics to vram ]

TfrWindowGfx:
@2de6:  lda     #$80
        sta     hVMAINC                 ; destination = $2e00 (vram)
        ldx     #$2e00
        stx     hVMADDL
        ldy     #28                     ; 28 tiles total
        lda     $0565                   ; wallpaper index
        asl
        tax
        longa
        lda     f:DlgWindowGfxPtrs,x
        tax
@2e00:
.repeat 8, i
        lda     f:WindowGfx+i*2,x       ; first 8 bytes of tile
        sta     hVMDATAL
.endrep
.repeat 8, i
        lda     f:WindowGfx+16+i*2,x    ; set the top bit of bitplane 3
        ora     #$ff00
        sta     hVMDATAL
.endrep
        txa
        clc
        adc     #$0020                  ; next tile
        tax
        dey
        beq     @2e94
        jmp     @2e00
@2e94:  shorta0
        rts

; ------------------------------------------------------------------------------

; pointers to wallpaper graphics (+$ed0000)
DlgWindowGfxPtrs:
@2e98:
.repeat 8, i
        .word   i*$0380
.endrep
; make_ptr_tbl_rel WindowGfx, 8, WindowGfx

; ------------------------------------------------------------------------------

; [ open map name dialog window ]

OpenMapTitleWindow:
@2ea8:  lda     #$7e
        pha
        plb
        longa
        lda     $7bfa       ; save hdma tables
        sta     $7ed1
        lda     $7bfd
        sta     $7ed4
        lda     $7c00
        sta     $7ed7
        lda     $7c03
        sta     $7eda
        lda     $7cb0
        sta     $7f85
        lda     $7cb3
        sta     $7f88
        lda     $7cb6
        sta     $7f8b
        lda     $7cb9
        sta     $7f8e
        lda     $7d66
        sta     $8039
        lda     $7d69
        sta     $803c
        lda     $7d6c
        sta     $803f
        lda     $7d6f
        sta     $8042
        lda     $7e1c
        sta     $80ed
        lda     $7e1f
        sta     $80f0
        lda     $7e22
        sta     $80f3
        lda     $7e25
        sta     $80f6
        lda     $7b9f
        sta     $7e77
        lda     $7ba2
        sta     $7e7a
        lda     $7ba5
        sta     $7e7d
        lda     $7ba8
        sta     $7e80
        lda     $7d0b
        sta     $7fdf
        lda     $7d0e
        sta     $7fe2
        lda     $7d11
        sta     $7fe5
        lda     $7d14
        sta     $7fe8
        lda     $7dc1
        sta     $8093
        lda     $7dc4
        sta     $8096
        lda     $7dc7
        sta     $8099
        lda     $7dca
        sta     $809c
        lda     #$8533      ; set bg1 scroll hdma data
        sta     $7bfa
        sta     $7bfd
        sta     $7c00
        lda     #$8553
        sta     $7c03
        lda     #$8573      ; set bg3 scroll hdma data
        sta     $7cb0
        lda     #$8583
        sta     $7cb3
        lda     #$8593
        sta     $7cb6
        lda     #$85a3
        sta     $7cb9
        lda     #$8ca3      ; set window 2 hdma data
        sta     $7d66
        lda     #$8ca3
        sta     $7d69
        lda     #$8ca3
        sta     $7d6c
        lda     #$8ca3
        sta     $7d6f
        lda     #$8bd3      ; set color add/sub settings hdma data
        sta     $7e1c
        lda     #$8be3
        sta     $7e1f
        lda     #$8bf3
        sta     $7e22
        lda     #$8c03
        sta     $7e25
        lda     #$81b3      ; set mosaic/bg location hdma data
        sta     $7b9f
        sta     $7ba2
        sta     $7ba5
        sta     $7ba8
        lda     #$8a43      ; set fixed color add/sub hdma data
        sta     $7d0b
        lda     #$8a53
        sta     $7d0e
        lda     #$8a63
        sta     $7d11
        lda     #$8a73
        sta     $7d14
        lda     #$8183      ; set main/sub screen designation hdma data
        sta     $7dc1
        sta     $7dc4
        sta     $7dc7
        sta     $7dca
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ close map name dialog window ]

CloseMapTitleWindow:
@2fed:  lda     $0745       ; return if map name dialog window is not open
        beq     @303f
        lda     #$7e
        pha
        plb
        ldx     $00
        longa
@2ffa:  lda     $7ed1,x     ; restore hdma tables
        sta     $7bfa,x
        lda     $7f85,x
        sta     $7cb0,x
        lda     $8039,x
        sta     $7d66,x
        lda     $80ed,x
        sta     $7e1c,x
        lda     $7e77,x
        sta     $7b9f,x
        lda     $7fdf,x
        sta     $7d0b,x
        lda     $8093,x
        sta     $7dc1,x
        inx3
        cpx     #$000c
        bne     @2ffa
        shorta0
        tdc
        pha
        plb
        stz     $0745       ; map name dialog window closed
        stz     $0567       ; clear map name dialog counter
        stz     $0568       ; clear dialog flags
        lda     #$09        ; dialog region = 9
        sta     $cc
@303f:  rts

; ------------------------------------------------------------------------------

; [ unused ??? ]

_c03040:
@3040:  lda     #$7e
        pha
        plb
        lda     $bc
        asl
        clc
        adc     $bc
        tax
        ldy     #$0008
        longa
@3050:  lda     $7b9c,x
        sta     $7e74,x
        lda     $7bf7,x
        sta     $7ece,x
        lda     $7cad,x
        sta     $7f82,x
        lda     $7d63,x
        sta     $8036,x
        lda     $7d08,x
        sta     $7fdc,x
        lda     $7e19,x
        sta     $80ea,x
        inx3
        dey
        bne     @3050
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ update dialog window ]

UpdateDlgWindow:
@3081:  lda     $ba
        bne     @3086
@3085:  rts
@3086:  lda     $bc
        asl
        clc
        adc     $bc
        tax
        lda     $ba
        bpl     @3094
        jmp     @31ba
@3094:  lda     $bb
        cmp     #$05
        beq     @3085
        asl
        sta     $1a
        asl3
        clc
        adc     $1a
        tay
        lda     $0564
        beq     @30ac
        jmp     @3139

; open dialog window
@30ac:  lda     #$c0
        pha
        plb
        longa
        lda     #$0009
        sta     $1e
@30b7:  lda     $327a,y
        beq     @30f4
        lda     $7e7bf7,x
        sta     $7e7ece,x
        lda     $7e7cad,x
        sta     $7e7f82,x
        lda     $7e7d63,x
        sta     $7e8036,x
        lda     $7e7e19,x
        sta     $7e80ea,x
        lda     $7e7b9c,x
        sta     $7e7e74,x
        lda     $7e7d08,x
        sta     $7e7fdc,x
        lda     $7e7dbe,x
        sta     $7e8090,x
@30f4:  lda     $32d4,y
        beq     @3127
        sta     $7e7bf7,x
        lda     $332e,y
        sta     $7e7cad,x
        lda     $3388,y
        sta     $7e7d63,x
        lda     $33e2,y
        sta     $7e7e19,x
        lda     $343c,y
        sta     $7e7b9c,x
        lda     $34f0,y
        sta     $7e7d08,x
        lda     $354a,y
        sta     $7e7dbe,x
@3127:  iny2
        inx3
        dec     $1e
        bne     @30b7
        shorta0
        inc     $bb
        tdc
        pha
        plb
        rts

; open dialog window (text only)
@3139:  lda     #$c0
        pha
        plb
        longa
        lda     #$0009
        sta     $1e
@3144:  lda     $327a,y
        beq     @3171
        lda     $7e7cad,x
        sta     $7e7f82,x
        lda     $7e7d63,x
        sta     $7e8036,x
        lda     $7e7b9c,x
        sta     $7e7e74,x
        lda     $7e7e19,x
        sta     $7e80ea,x
        lda     $7e7dbe,x
        sta     $7e8090,x
@3171:  lda     $332e,y
        beq     @31a8
        sta     $7e7cad,x
        lda     $3388,y
        sta     $7e7d63,x
        lda     $3496,y
        sta     $7e7b9c,x
        lda     f:$001ed8
        and     #$0001
        bne     @31a1
        lda     #$8c73
        sta     $7e7e19,x
        lda     $35a4,y
        sta     $7e7dbe,x
        bra     @31a8
@31a1:  lda     #$81a3
        sta     $7e7dbe,x
@31a8:  iny2
        inx3
        dec     $1e
        bne     @3144
        shorta0
        inc     $bb
        tdc
        pha
        plb
        rts

; close dialog window
@31ba:  lda     $bb
        bne     @31c1
        jmp     @3277
@31c1:  dec     $bb
        lda     $bb
        asl
        sta     $1a
        asl3
        clc
        adc     $1a
        tay
        lda     $0564
        beq     @31d7
        jmp     @322f
@31d7:  lda     #$c0
        pha
        plb
        longa
        lda     #$0009
        sta     $1e
@31e2:  lda     $327a,y
        beq     @321f
        lda     $7e7ece,x
        sta     $7e7bf7,x
        lda     $7e7f82,x
        sta     $7e7cad,x
        lda     $7e8036,x
        sta     $7e7d63,x
        lda     $7e80ea,x
        sta     $7e7e19,x
        lda     $7e7e74,x
        sta     $7e7b9c,x
        lda     $7e7fdc,x
        sta     $7e7d08,x
        lda     $7e8090,x
        sta     $7e7dbe,x
@321f:  iny2
        inx3
        dec     $1e
        bne     @31e2
        shorta0
        tdc
        pha
        plb
        rts

; close dialog window (text only)
@322f:  lda     #$c0
        pha
        plb
        longa
        lda     #$0009
        sta     $1e
@323a:  lda     $327a,y
        beq     @3267
        lda     $7e7f82,x
        sta     $7e7cad,x
        lda     $7e8036,x
        sta     $7e7d63,x
        lda     $7e7e74,x
        sta     $7e7b9c,x
        lda     $7e80ea,x
        sta     $7e7e19,x
        lda     $7e8090,x
        sta     $7e7dbe,x
@3267:  iny2
        inx3
        dec     $1e
        bne     @323a
        shorta0
        tdc
        pha
        plb
        rts
@3277:  stz     $ba
        rts

; ------------------------------------------------------------------------------

; dialog window strips added/removed each frame
@327a:  .word   0,0,0,0,1,0,0,0,0
        .word   0,0,0,1,0,1,0,0,0
        .word   0,0,1,0,0,0,1,0,0
        .word   0,1,0,0,0,0,0,1,0
        .word   1,0,0,0,0,0,0,0,1

; hdma pointers for bg1 scroll (hdma #4)
@32d4:  .word   $0000,$0000,$0000,$0000,$8513,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$84b3,$84d3,$84f3,$0000,$0000,$0000
        .word   $0000,$0000,$8413,$8433,$8453,$8473,$8493,$0000,$0000
        .word   $0000,$8333,$8353,$8373,$8393,$83b3,$83d3,$83f3,$0000
        .word   $8313,$8313,$8313,$8313,$8313,$8313,$8313,$8313,$8313

; hdma pointers for bg3 scroll (hdma #3)
@332e:  .word   $0000,$0000,$0000,$0000,$85f3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$85f3,$85f3,$85f3,$0000,$0000,$0000
        .word   $0000,$0000,$85f3,$85f3,$85f3,$85f3,$85f3,$0000,$0000
        .word   $0000,$85f3,$85f3,$85f3,$85f3,$85f3,$85f3,$85f3,$0000
        .word   $85f3,$8613,$8633,$8653,$8673,$8693,$86b3,$86d3,$86f3

; hdma pointers for window 2 position (hdma #5)
@3388:  .word   $0000,$0000,$0000,$0000,$8ca3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8ca3,$8ca3,$8ca3,$0000,$0000,$0000
        .word   $0000,$0000,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$0000,$0000
        .word   $0000,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$0000
        .word   $8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3,$8ca3

; hdma pointers for color add/sub settings (hdma #1)
@33e2:  .word   $0000,$0000,$0000,$0000,$8c53,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8c23,$8c33,$8c43,$0000,$0000,$0000
        .word   $0000,$0000,$8bd3,$8be3,$8bf3,$8c03,$8c13,$0000,$0000
        .word   $0000,$8b63,$8b73,$8b83,$8b93,$8ba3,$8bb3,$8bc3,$0000
        .word   $8ad3,$8ae3,$8af3,$8b03,$8b13,$8b23,$8b33,$8b43,$8b53

; hdma pointers for mosaic/bg location (hdma #7)
@343c:  .word   $0000,$0000,$0000,$0000,$81b3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$81b3,$81b3,$81b3,$0000,$0000,$0000
        .word   $0000,$0000,$81b3,$81b3,$81b3,$81b3,$81b3,$0000,$0000
        .word   $0000,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$0000
        .word   $81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3,$81b3

; hdma pointers for mosaic/bg location (hdma #7) text only
@3496:  .word   $0000,$0000,$0000,$0000,$81d3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$81d3,$81d3,$81d3,$0000,$0000,$0000
        .word   $0000,$0000,$81d3,$81d3,$81d3,$81d3,$81d3,$0000,$0000
        .word   $0000,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$0000
        .word   $81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3,$81d3

; hdma pointers for fixed color add/sub (hdma #2)
@34f0:  .word   $0000,$0000,$0000,$0000,$8ac3,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8a93,$8aa3,$8ab3,$0000,$0000,$0000
        .word   $0000,$0000,$8a43,$8a53,$8a63,$8a73,$8a83,$0000,$0000
        .word   $0000,$89d3,$89e3,$89f3,$8a03,$8a13,$8a23,$8a33,$0000
        .word   $8943,$8953,$8963,$8973,$8983,$8993,$89a3,$89b3,$89c3

; hdma pointers for main/sub screen designation (hdma #6)
@354a:  .word   $0000,$0000,$0000,$0000,$8183,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8183,$8183,$8183,$0000,$0000,$0000
        .word   $0000,$0000,$8183,$8183,$8183,$8183,$8183,$0000,$0000
        .word   $0000,$8183,$8183,$8183,$8183,$8183,$8183,$8183,$0000
        .word   $8183,$8183,$8183,$8183,$8183,$8183,$8183,$8183,$8183

; hdma pointers for main/sub screen designation (hdma #6) text only
@35a4:  .word   $0000,$0000,$0000,$0000,$8193,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$8193,$8193,$8193,$0000,$0000,$0000
        .word   $0000,$0000,$8193,$8193,$8193,$8193,$8193,$0000,$0000
        .word   $0000,$8193,$8193,$8193,$8193,$8193,$8193,$8193,$0000
        .word   $8193,$8193,$8193,$8193,$8193,$8193,$8193,$8193,$8193

; ------------------------------------------------------------------------------

; [ init dialog window ]

InitDlgWindow:
@35fe:  jsr     TfrWindowGfx
        lda     $0565       ; wallpaper index
        sta     hWRMPYA
        lda     #$0e        ; get pointer to wallpaper palette
        sta     hWRMPYB
        nop2
        ldx     $00
        ldy     hRDMPYL
@3613:  lda     $1d57,y     ; copy wallpaper palette to ram
        sta     $7e72f2,x
        sta     $7e74f2,x
        inx
        iny
        cpx     #$000e
        bne     @3613
        lda     #$80        ; vram memory settings
        sta     hVMAINC
        ldx     #$4020      ; vram destination = $4020 (dialog window at top of screen)
        stx     hVMADDL
        ldx     $00
@3632:  lda     f:DlgWindowTilesTop,x   ; low byte of bg data
        sta     hVMDATAL
        lda     #$3e        ; high byte of bg data (high priority, palette 7)
        sta     hVMDATAH
        inx
        cpx     #$0120
        bne     @3632
        ldx     #$4240      ; vram destination = $4240 (dialog window at bottom of screen)
        stx     hVMADDL
        ldx     $00
@364c:  lda     f:DlgWindowTilesTop,x
        sta     hVMDATAL
        lda     #$3e
        sta     hVMDATAH
        inx
        cpx     #$0120
        bne     @364c
        ldx     #$4400      ; vram destination = $4400
        stx     hVMADDL
        ldx     #$0020      ; clear 1 line
@3667:  lda     #$ff
        sta     hVMDATAL
        lda     #$21        ; high byte of bg data (high priority, palette 0)
        sta     hVMDATAH
        dex
        bne     @3667
        jsr     TfrDlgTiles       ; dialog window at top of screen
        ldx     #$0120      ; clear 9 lines
@367a:  lda     #$ff
        sta     hVMDATAL
        lda     #$21
        sta     hVMDATAH
        dex
        bne     @367a
        jsr     TfrDlgTiles       ; dialog window at bottom of screen
        ldx     #$0020      ; clear 1 line
@368d:  lda     #$ff
        sta     hVMDATAL
        lda     #$21
        sta     hVMDATAH
        dex
        bne     @368d
        rts

; ------------------------------------------------------------------------------

; [ load dialog text tile formation to vram ]

TfrDlgTiles:
@369b:  ldy     $00
@369d:  ldx     $00
@369f:  lda     f:DlgTextTiles,x
        bmi     @36ab
        tya
        clc
        adc     f:DlgTextTiles,x   ; tile index
@36ab:  sta     hVMDATAL
        lda     #$21        ; tile flags
        sta     hVMDATAH
        inx
        cpx     #$0040
        bne     @369f
        tya
        clc
        adc     #$40
        tay
        bne     @369d
        rts

; ------------------------------------------------------------------------------

; dialog text tile formation (32x2, low byte only)
DlgTextTiles:
@36c1:  .byte   $ff,$ff,$00,$02,$04,$06,$08,$0a,$0c,$0e,$10,$12,$14,$16,$18,$1a
        .byte   $1c,$1e,$20,$22,$24,$26,$28,$2a,$2c,$2e,$30,$32,$34,$36,$ff,$ff
        .byte   $ff,$ff,$01,$03,$05,$07,$09,$0b,$0d,$0f,$11,$13,$15,$17,$19,$1b
        .byte   $1d,$1f,$21,$23,$25,$27,$29,$2b,$2d,$2f,$31,$33,$35,$37,$ff,$ff

; dialog window tile formation (32x9, low byte only, first and last tile on each line get masked)
DlgWindowTilesTop:
@3701:  .byte   $f0,$f0,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2
        .byte   $f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f1,$f2,$f3,$f3

DlgWindowTilesMid:
@3721:  .byte   $f4,$f4,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1
        .byte   $e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$f5,$f5
        .byte   $f6,$f6,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5
        .byte   $e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$f7,$f7
        .byte   $f4,$f4,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9
        .byte   $ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$f5,$f5
        .byte   $f6,$f6,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed
        .byte   $ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$ec,$ed,$ee,$ef,$f7,$f7
        .byte   $f4,$f4,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1
        .byte   $e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$e0,$e1,$e2,$e3,$f5,$f5
        .byte   $f6,$f6,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5
        .byte   $e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$e4,$e5,$e6,$e7,$f7,$f7
        .byte   $f4,$f4,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9
        .byte   $ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$e8,$e9,$ea,$eb,$f5,$f5

DlgWindowTilesBtm:
@3801:  .byte   $f8,$f8,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa
        .byte   $f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$f9,$fa,$fb,$fb

; ------------------------------------------------------------------------------

; [ init hdma data ]

InitHDMA:
@3821:  lda     #$43        ; channel #0: bg2 scroll ($210f & $2110)
        sta     $4300       ; 2 address, write twice
        lda     #$0f
        sta     $4301
        ldx     #$7c51
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        lda     #$44        ; channel #7: mosaic & bg1-3 data location in vram ($2106, $2107, $2108, $2109)
        sta     $4370       ; 4 address
        lda     #$06
        sta     $4371
        ldx     #$7b9b
        stx     $4372
        lda     #$7e
        sta     $4374
        sta     $4377
        lda     #$43        ; channel #4: bg1 scroll ($210d & $210e)
        sta     $4340       ; 2 address, write twice
        lda     #$0d
        sta     $4341
        ldx     #$7bf6
        stx     $4342
        lda     #$7e
        sta     $4344
        sta     $4347
        lda     #$43        ; channel #3: bg3 scroll ($2111 & $2112)
        sta     $4330       ; 2 address, write twice
        lda     #$11
        sta     $4331
        ldx     #$7cac
        stx     $4332
        lda     #$7e
        sta     $4334
        sta     $4337
        lda     #$42        ; channel #2: fixed color add/sub values ($2132)
        sta     $4320       ; 1 address, write twice
        lda     #$32
        sta     $4321
        ldx     #$7d07
        stx     $4322
        lda     #$7e
        sta     $4324
        sta     $4327
        lda     #$41        ; channel #5: window 2 position ($2128 & $2129)
        sta     $4350       ; 2 address
        lda     #$28
        sta     $4351
        ldx     #$7d62
        stx     $4352
        lda     #$7e
        sta     $4354
        sta     $4357
        lda     #$41        ; channel #6: main/sub screen designation ($212c & $212d)
        sta     $4360       ; 2 address
        lda     #$2c
        sta     $4361
        ldx     #$7dbd
        stx     $4362
        lda     #$7e
        sta     $4364
        sta     $4367
        lda     #$41        ; channel #1: color add/sub settings ($2130 & $2131)
        sta     $4310       ; 2 address
        lda     #$30
        sta     $4311
        ldx     #$7e18
        stx     $4312
        lda     #$7e
        sta     $4314
        sta     $4317
        lda     #$7e
        pha
        plb
        ldx     $00         ; set up hdma tables
        lda     #$88        ; 27 strips @ 8 scanlines each
@38e9:  sta     $7b40,x
        sta     $7b9b,x
        sta     $7bf6,x
        sta     $7c51,x
        sta     $7cac,x
        sta     $7d07,x
        sta     $7d62,x
        sta     $7dbd,x
        sta     $7e18,x
        inx3
        cpx     #$0051
        bne     @38e9
        lda     #$87        ; 1 strip @ 7 scanlines
        sta     $7b40
        sta     $7b9b
        sta     $7bf6
        sta     $7c51
        sta     $7cac
        sta     $7d07
        sta     $7d62
        sta     $7dbd
        sta     $7e18
        lda     #$80        ; end of table (223 scanlines total)
        sta     $7b40,x
        sta     $7b9b,x
        sta     $7bf6,x
        sta     $7c51,x
        sta     $7cac,x
        sta     $7d07,x
        sta     $7d62,x
        sta     $7dbd,x
        sta     $7e18,x
        tdc
        pha
        plb
        jsr     InitFontColorHDMATbl
        jsr     InitScrollHDMATbl
        jsr     InitMosaicHDMATbl
        jsr     InitColorMathHDMATbl
        jsr     InitColorMathHDMAData
        jsr     InitWindowHDMATbl
        jsr     InitWindowHDMAData
        jsr     InitMaskHDMATbl
        jsr     InitMaskHDMAData
        jsr     InitFixedColorHDMATbl
        jsr     InitFixedColorHDMAData
        rts

; ------------------------------------------------------------------------------

; [ init unused hdma table ]

InitFontColorHDMATbl:
@396b:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3973:  lda     #$8143
        sta     $7b41,x
        inx3
        cpx     #$0051
        bne     @3973
        ldx     $00
@3983:  lda     f:FontColorTbl,x
        sta     $8143,x
        inx2
        cpx     #$0020
        bne     @3983
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; color palette for unused hdma data
FontColorTbl:
@3998:  .word   $4210,$4a52,$5294,$5ad6,$6318,$6b5a,$739c,$7bde

; ------------------------------------------------------------------------------

; [ load horizontal fade bars (from ending) ]

InitFadeBars:
@39a8:  lda     $1ed8
        and     #$01
        beq     @3a04
        lda     #$7e
        pha
        plb
        longa
        lda     #$8903
        sta     $7d0b
        lda     #$8913
        sta     $7d0e
        lda     #$8923
        sta     $7d3b
        lda     #$8933
        sta     $7d3e
        lda     #$8c93
        sta     $7e1c
        sta     $7e1f
        sta     $7e4c
        sta     $7e4f
        ldx     $00
@39de:  lda     #$81a3
        sta     $7df7,x
        lda     #$8733
        sta     $7ce6,x
        lda     #$8253
        sta     $7bd5,x
        lda     #$8c73
        sta     $7e52,x
        inx3
        cpx     #$0018
        bne     @39de
        shorta0
        tdc
        pha
        plb
@3a04:  rts

; ------------------------------------------------------------------------------

; [ init main/sub screen designation hdma table ]

InitMaskHDMATbl:
@3a05:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3a0d:  lda     #$8163
        sta     $7dbe,x
        inx3
        cpx     #$0051
        bne     @3a0d
        lda     #$8173
        sta     $7dbe
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init main/sub screen designation hdma data ]

InitMaskHDMAData:
@3a28:  ldx     #$8173
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        tdc
.repeat 16
        sta     hWMDATA
.endrep
        ldx     #$8183
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     #$05
        sta     hWMDATA
.repeat 15
        xba
        sta     hWMDATA
.endrep
        tdc
        ldx     #$8193
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     #$1f
        sta     hWMDATA
.repeat 15
        xba
        sta     hWMDATA
.endrep
        tdc
        ldx     #$8163
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     $51
        sta     hWMDATA
        xba
        lda     $52
        sta     hWMDATA
.repeat 14
        xba
        sta     hWMDATA
.endrep
        tdc
        ldx     #$81a3
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     #$04
        sta     hWMDATA
.repeat 15
        xba
        sta     hWMDATA
.endrep
        tdc
        rts

; ------------------------------------------------------------------------------

; [ update window 2 position hdma table ]

InitWindowHDMATbl:
@3b9b:  lda     $0566
        lsr
        bcs     @3bd0
        lda     #$7e
        pha
        plb
        longa
        ldx     $00
        lda     #$8cb3
@3bac:  ldy     $7d66,x
        cpy     #$8ca3
        beq     @3bb7
        sta     $7d66,x
@3bb7:  clc
        adc     #$0010
        inx3
        cpx     #$004e
        bne     @3bac
        lda     #$8ff3
        sta     $7d63
        shorta0
        tdc
        pha
        plb
        rts
@3bd0:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
        lda     #$8e53
@3bdb:  ldy     $7d66,x
        cpy     #$8ca3
        beq     @3be6
        sta     $7d66,x
@3be6:  clc
        adc     #$0010
        inx3
        cpx     #$004e
        bne     @3bdb
        lda     #$8ff3
        sta     $7d63
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init window 2 position hdma data ]

InitWindowHDMAData:
@3bff:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3c07:  lda     #$00ff
        sta     $8ff3,x
        lda     #$ff00
        sta     $8ca3,x
        inx2
        cpx     #$0010
        bne     @3c07
        ldx     $00
@3c1c:  lda     #$ff00
        sta     $8cb3,x
        sta     $8e53,x
        inx2
        cpx     #$01a0
        bne     @3c1c
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init fixed color add/sub hdma table ]

InitFixedColorHDMATbl:
@3c33:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3c3b:  lda     #$8753
        sta     $7d08,x
        inx3
        cpx     #$0051
        bne     @3c3b
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init fixed color add/sub hdma data ]

InitFixedColorHDMAData:
@3c50:  ldx     #$8753      ; set wram address to $7e8753
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     $00
@3c5d:  lda     #$e0        ; set all 8 scanlines to black
        sta     hWMDATA
        lda     #$00
        sta     hWMDATA
        inx
        cpx     #$0008
        bne     @3c5d
        ldx     #$8943      ; set wram address to $7e8943
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     $00
@3c7a:  lda     f:DlgWindowFixedColorTbl,x
        sta     hWMDATA       ; each byte gets copied twice
        lda     f:DlgWindowFixedColorTbl,x
        sta     hWMDATA
        inx
        cpx     #$00c8
        bne     @3c7a
        ldx     #$8903      ; set wram address to $7e8903
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     $00
@3c9b:  lda     f:FadeBarsFixedColorTbl,x
        sta     hWMDATA       ; each byte gets copied twice
        sta     hWMDATA
        inx
        cpx     #$0010
        bne     @3c9b
        ldx     #$8923      ; repeat in reverse order
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     #$0010
@3cb9:  lda     f:FadeBarsFixedColorTbl-1,x
        sta     hWMDATA       ; each byte gets copied twice
        sta     hWMDATA
        dex
        bne     @3cb9
        rts

; ------------------------------------------------------------------------------

; fixed color data for horizontal fade bars, from ending
FadeBarsFixedColorTbl:
@3cc7:  .byte   $fc,$f8,$f4,$f0,$ee,$ec,$ea,$e9,$e8,$e7,$e6,$e5,$e4,$e3,$e2,$e1

; ------------------------------------------------------------------------------

; fixed color data for dialog window gradient
DlgWindowFixedColorTbl:
@3cd7:  .byte   $e7, $e7, $e7, $e6, $e6, $e6, $e6, $e6
        .byte   $e5, $e5, $e5, $e5, $e5, $e4, $e4, $e4
        .byte   $e4, $e4, $e3, $e3, $e3, $e3, $e3, $e2
        .byte   $e2, $e2, $e2, $e2, $e1, $e1, $e1, $e1
        .byte   $e1, $e0, $e0, $e0, $e0, $e0, $e1, $e1
        .byte   $e1, $e1, $e1, $e2, $e2, $e2, $e2, $e2
        .byte   $e3, $e3, $e3, $e3, $e3, $e4, $e4, $e4
        .byte   $e4, $e4, $e5, $e5, $e5, $e5, $e5, $e6
        .byte   $e6, $e6, $e6, $e6, $e7, $e7, $e7, $e7

@3d1f:  .byte   $e7, $e7, $e6, $e6, $e6, $e6, $e5, $e5
        .byte   $e5, $e5, $e4, $e4, $e4, $e4, $e3, $e3
        .byte   $e3, $e3, $e2, $e2, $e2, $e2, $e1, $e1
        .byte   $e1, $e1, $e0, $e0, $e0, $e0, $e1, $e1
        .byte   $e1, $e1, $e2, $e2, $e2, $e2, $e3, $e3
        .byte   $e3, $e3, $e4, $e4, $e4, $e4, $e5, $e5
        .byte   $e5, $e5, $e6, $e6, $e6, $e6, $e7, $e7

@3d57:  .byte   $e7, $e6, $e6, $e6, $e5, $e5, $e5, $e4
        .byte   $e4, $e4, $e3, $e3, $e3, $e2, $e2, $e2
        .byte   $e1, $e1, $e1, $e0, $e0, $e0, $e1, $e1
        .byte   $e1, $e2, $e2, $e2, $e3, $e3, $e3, $e4
        .byte   $e4, $e4, $e5, $e5, $e5, $e6, $e6, $e6

@3d7f:  .byte   $e6, $e5, $e5, $e4, $e4, $e3, $e3, $e2
        .byte   $e2, $e1, $e1, $e0, $e0, $e1, $e1, $e2
        .byte   $e2, $e3, $e3, $e4, $e4, $e5, $e5, $e6

@3d97:  .byte   $e4, $e3, $e2, $e1, $e0, $e1, $e2, $e3

; ------------------------------------------------------------------------------

; [ init color add/sub settings hdma table ]

InitColorMathHDMATbl:
@3d9f:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@3da7:  lda     #$8c63
        sta     $7e19,x
        inx3
        cpx     #$0051
        bne     @3da7
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init color add/sub settings hdma data ]

InitColorMathHDMAData:
@3dbc:  lda     #$7e
        pha
        plb
        ldx     $00
@3dc2:  lda     $50
        sta     $8c63,x
        sta     $8c73,x
        lda     $4e
        sta     $8c64,x
        tdc
        sta     $8c74,x
        lda     #$20
        sta     $8ad3,x
        sta     $8ae3,x
        sta     $8af3,x
        sta     $8b03,x
        sta     $8b13,x
        sta     $8b23,x
        sta     $8b33,x
        sta     $8b43,x
        sta     $8b53,x
        sta     $8b63,x
        sta     $8b73,x
        sta     $8b83,x
        sta     $8b93,x
        sta     $8ba3,x
        sta     $8bb3,x
        sta     $8bc3,x
        sta     $8bd3,x
        sta     $8be3,x
        sta     $8bf3,x
        sta     $8c03,x
        sta     $8c13,x
        sta     $8c23,x
        sta     $8c33,x
        sta     $8c43,x
        sta     $8c53,x
        sta     $8c83,x
        sta     $8c93,x
        inx2
        cpx     #$0010
        bne     @3dc2
        ldx     $00
@3e2f:  lda     #$01
        sta     $8ad4,x
        sta     $8adc,x
        sta     $8ae4,x
        sta     $8aec,x
        sta     $8af4,x
        sta     $8afc,x
        sta     $8b04,x
        sta     $8b0c,x
        sta     $8b14,x
        sta     $8b64,x
        sta     $8b6c,x
        sta     $8b74,x
        sta     $8b7c,x
        sta     $8b84,x
        sta     $8b8c,x
        sta     $8b94,x
        sta     $8bd4,x
        sta     $8bdc,x
        sta     $8be4,x
        sta     $8bec,x
        sta     $8bf4,x
        sta     $8c24,x
        sta     $8c2c,x
        sta     $8c34,x
        sta     $8c54,x
        lda     #$1f
        sta     $8c84,x
        sta     $8c8c,x
        lda     #$81
        sta     $8b1c,x
        sta     $8b24,x
        sta     $8b2c,x
        sta     $8b34,x
        sta     $8b3c,x
        sta     $8b44,x
        sta     $8b4c,x
        sta     $8b54,x
        sta     $8b5c,x
        sta     $8b9c,x
        sta     $8ba4,x
        sta     $8bac,x
        sta     $8bb4,x
        sta     $8bbc,x
        sta     $8bc4,x
        sta     $8bcc,x
        sta     $8bfc,x
        sta     $8c04,x
        sta     $8c0c,x
        sta     $8c14,x
        sta     $8c1c,x
        sta     $8c3c,x
        sta     $8c44,x
        sta     $8c4c,x
        sta     $8c5c,x
        lda     #$9f
        sta     $8c94,x
        sta     $8c9c,x
        inx2
        cpx     #$0008
        beq     @3ee3
        jmp     @3e2f
@3ee3:  tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init mosaic/bg location hdma table and data ]

InitMosaicHDMATbl:
@3ee7:  ldx     $00
        lda     #$7e
        pha
        plb
        longa
@3eef:  lda     #$8233
        sta     $7b9c,x
        inx3
        cpx     #$0051
        bne     @3eef
        shorta0
        ldx     $00
@3f02:  tdc
        sta     $81b3,x
        sta     $81d3,x
        sta     $8213,x
        sta     $8253,x
        lda     #$0f
        sta     $81f3,x
        sta     $8233,x
        lda     #$40
        sta     $81b4,x
        sta     $81f4,x
        lda     #$48
        sta     $8214,x
        sta     $8234,x
        sta     $81d4,x
        sta     $8254,x
        lda     #$50
        sta     $81d5,x
        sta     $8215,x
        sta     $8235,x
        sta     $8255,x
        lda     #$44
        sta     $81b6,x
        sta     $81d6,x
        sta     $81f6,x
        sta     $8256,x
        lda     #$58
        sta     $8216,x
        sta     $8236,x
        inx4
        cpx     #$0020
        bne     @3f02
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ flip bg1 map location ]

FlipBG1:
@3f5e:  ldx     $00
        lda     $058c
        eor     #$04
        sta     $058c
@3f68:  sta     $7e8214,x
        sta     $7e8234,x
        sta     $7e81d4,x
        inx4
        cpx     #$0020
        bne     @3f68
        rts

; ------------------------------------------------------------------------------

; [ flip bg2 map location ]

FlipBG2:
@3f7e:  ldx     $00
        lda     $058e
        eor     #$04
        sta     $058e
@3f88:  sta     $7e81d5,x
        sta     $7e8215,x
        sta     $7e8235,x
        inx4
        cpx     #$0020
        bne     @3f88
        rts

; ------------------------------------------------------------------------------

; [ flip bg3 map location ]

FlipBG3:
@3f9e:  ldx     $00
        lda     $0590
        eor     #$04
        sta     $0590
@3fa8:  sta     $7e8216,x
        sta     $7e8236,x
        inx4
        cpx     #$0020
        bne     @3fa8
        rts

; ------------------------------------------------------------------------------

; [ flip all bg map locations (unused) ]

_c03fba:
@3fba:  lda     $058c
        eor     #$04
        sta     $058c
        lda     $058e
        eor     #$04
        sta     $058e
        lda     $0590
        eor     #$04
        sta     $0590
        ldx     $00
@3fd4:  lda     $058c
        sta     $7e8214,x
        sta     $7e8234,x
        sta     $7e81d4,x
        lda     $058e
        sta     $7e81d5,x
        sta     $7e8215,x
        sta     $7e8235,x
        lda     $0590
        sta     $7e8216,x
        sta     $7e8236,x
        inx4
        cpx     #$0020
        bne     @3fd4
        rts

; ------------------------------------------------------------------------------

; [ random bg3 mosaic (unused) ]

_c04007:
@4007:  lda     #$7e
        pha
        plb
        lda     $46
        asl2
        tax
        ldy     $00
@4012:  lda     f:RNGTbl,x   ; random number table
        cmp     #$c0
        bcc     @4020       ; branch if less than 192 (3/4 chance)
        and     #$30        ; set mosaic size (0..3)
        ora     #$04        ; enable mosaic in bg3
        bra     @4021
@4020:  tdc
@4021:  sta     $81d3,y
        inx
        iny4
        cpy     #$0020
        bne     @4012
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ init bg scroll hdma table and data ]

InitScrollHDMATbl:
@4032:  lda     #$7e
        pha
        plb
        longa
        ldx     $00
@403a:  lda     #$8273                  ; set hdma tables
        sta     $7bfa,x
        lda     #$8293
        sta     $7bfd,x
        lda     #$82b3
        sta     $7c55,x
        lda     #$82d3
        sta     $7c58,x
        lda     #$82f3
        sta     $7cb0,x
        sta     $7cb3,x
        inx6
        cpx     #$004e
        bne     @403a
        ldx     $00                     ; bg1 scroll hdma data for dialog window
        tdc
@4069:  sta     $8313,x                 ; clear horizontal scroll values
        inx2
        cpx     #$0220
        bne     @4069
        ldx     $00
        txy
@4076:  lda     f:DlgWindowBG1ScrollTbl,x
        and     #$00ff
        sta     $8335,y                 ; set vertical scroll values
        iny4
        inx
        cpx     #$0080
        bne     @4076
        ldx     $00                     ; bg3 scroll hdma data for dialog window
        txy
@408d:  tdc
        sta     $85f3,y                 ; clear horizontal scroll values
        lda     f:DlgWindowBG3ScrollTbl,x
        and     #$00ff
        sta     $85f5,y                 ; set vertical scroll values
        inx2
        iny4
        cpy     #$0120
        bne     @408d
        ldx     $00                     ; bg3 scroll hdma data for map name window
        txy
@40a9:  tdc
        sta     $8573,y                 ; clear horizontal scroll values
        lda     f:MapTitleBG3ScrollTbl,x
        and     #$00ff
        sta     $8575,y                 ; set vertical scroll values
        inx2
        iny4
        cpy     #$0080
        bne     @40a9
        ldx     $00                     ; bg1 scroll hdma data for map name window
        tdc
@40c5:  sta     $8533,x                 ; clear horizontal scroll values
        inx2
        cpx     #$0020
        bne     @40c5
        ldx     $00
        tdc
@40d2:  tdc
        sta     $8553,x
        lda     #$0028
        sta     $8555,x                 ; set vertical scroll values to $28
        inx4
        cpx     #$0020
        bne     @40d2
        ldx     $00                     ; bg3 scroll data (unused)
@40e7:  lda     #$00b0
        sta     $8715,x
        tdc
        sta     $8713,x
        inx4
        cpx     #$0020
        bne     @40e7
        ldx     $00                     ; bg3 scroll data for horizontal fade bars (from ending)
@40fc:  lda     #$00b8
        sta     $8735,x
        tdc
        sta     $8733,x
        inx4
        cpx     #$0020
        bne     @40fc
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; bg3 vertical scroll values for dialog window
bg3_mess_pos_tbl:
DlgWindowBG3ScrollTbl:
@4116:  .word   $fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc
        .word   $fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc,$fffc
        .word   $fffc,$fffc,$fffc,$fffc,$fffd,$fffd,$fffd,$fffd
        .word   $fffd,$fffd,$fffd,$fffd,$fffd,$fffd,$fffd,$fffd
        .word   $fffd,$fffd,$fffd,$fffe,$fffe,$fffe,$fffe,$fffe
        .word   $fffe,$fffe,$fffe,$fffe,$fffe,$fffe,$fffe,$fffe
        .word   $fffe,$fffe,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
        .word   $ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff,$ffff
        .word   $ffff,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
        .word   $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
        .word   $0001,$0001,$0001,$0001,$0001,$0001,$0001,$0001
        .word   $0001,$0001,$0001,$0001,$0001,$0001

; bg3 vertical scroll values for map name window
MapTitleBG3ScrollTbl:
@41f2:  .word   $fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa
        .word   $fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$fffa
        .word   $fffa,$fffa,$fffa,$fffa,$fffa,$fffa,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000

; bg1 vertical scroll values for dialog window (compresses window while opening)
DlgWindowBG1ScrollTbl:
@4236:  .byte   $f8,$f8,$f9,$f9,$f9,$f9,$fa,$fa
        .byte   $fa,$fb,$fb,$fb,$fb,$fc,$fc,$fc
        .byte   $fd,$fd,$fd,$fd,$fe,$fe,$fe,$ff
        .byte   $ff,$ff,$ff,$00,$00,$01,$01,$01
        .byte   $01,$02,$02,$02,$03,$03,$03,$03
        .byte   $04,$04,$04,$05,$05,$05,$05,$06
        .byte   $06,$06,$07,$07,$07,$07,$08,$08

@426e:  .byte   $f0,$f1,$f2,$f2,$f3,$f4,$f5,$f6
        .byte   $f6,$f7,$f8,$f9,$fa,$fa,$fb,$fc
        .byte   $fd,$fe,$fe,$ff,$01,$02,$02,$03
        .byte   $04,$05,$06,$06,$07,$08,$09,$0a
        .byte   $0a,$0b,$0c,$0d,$0e,$0e,$0f,$10

@4296:  .byte   $e8,$ea,$ec,$ee,$f0,$f2,$f4,$f6
        .byte   $f8,$fa,$fc,$fe,$02,$04,$06,$08
        .byte   $0a,$0c,$0e,$10,$12,$14,$16,$18

@42ae:  .byte   $e0,$e8,$f0,$f8,$08,$10,$18,$20

; ------------------------------------------------------------------------------

; [ update bg scroll hdma data ]

UpdateScrollHDMA:
@42b6:  longa
        lda     $64
        sec
        sbc     #8
        shorta
        sta     hBG2HOFS
        xba
        sta     hBG2HOFS
        longa
        lda     $68
        clc
        adc     $074e
        shorta
        sta     hBG2VOFS
        xba
        sta     hBG2VOFS
        tdc
        lda     #$7e
        pha
        plb
        longa
        lda     $5c                     ; bg1 horizontal scroll position
        sec
        sbc     #8
.repeat 16, i
        sta     $8273+i*4
.endrep
        lda     $64                     ; bg2 horizontal scroll position
        sec
        sbc     #8
.repeat 16, i
        sta     $82b3+i*4
.endrep
        lda     $6c                     ; bg3 horizontal scroll position
        sec
        sbc     #8
.repeat 8, i
        sta     $82f3+i*4
.endrep
        lda     $60                     ; bg1 vertical scroll position
        clc
        adc     $074c
.repeat 16,i
        sta     $8275+i*4
.endrep

; bg1
        shorta0
        lda     $0521
        and     #$10
        bne     @43ac
        jmp     @444a

; wavy bg1
@43ac:  lda     $46
        lsr
        clc
        adc     $60                     ; bg1 vertical scroll position
        and     #$0f
        asl
        tax
        longa
        ldy     $60
.repeat 16, i
        tya
        clc
        adc     f:WavyScrollTbl1+i*2,x
        sta     $8275+i*4
.endrep

; bg2
@444a:  shorta0
        lda     $0521
        and     #$08
        bne     @4457
        jmp     @44f8

; wavy bg2
@4457:  lda     $46
        lsr
        clc
        adc     $68
        clc
        adc     #$08
        and     #$0f
        asl
        tax
        longa
        ldy     $68
.repeat 16, i
        tya
        clc
        adc     f:WavyScrollTbl1+i*2,x
        sta     $82b5+i*4
.endrep

; bg3
@44f8:  shorta0
        lda     $46
        lsr3
        clc
        adc     $70
        and     #$07
        asl
        tax
        lda     $0521
        and     #$04
        bne     @4511
        ldx     #$0020
@4511:  longac
        lda     $70
        adc     $0750
        tay
        clc
        adc     f:WavyScrollTbl3,x
        sta     $82f5
.repeat 7, i
        tya
        clc
        adc     f:WavyScrollTbl3+(i+1)*2,x
        sta     $82f5+(i+1)*4
.endrep
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; scroll HDMA values for wavy BG1 and BG2
WavyScrollTbl1:
@4567:  .word   $0000,$0001,$0001,$0002,$0002,$0002,$0001,$0001
        .word   $0000,$ffff,$ffff,$fffe,$fffe,$fffe,$ffff,$ffff
        .word   $0000,$0001,$0001,$0002,$0002,$0002,$0001,$0001
        .word   $0000,$ffff,$ffff,$fffe,$fffe,$fffe,$ffff,$ffff

; unused scroll values for BG1 and BG2
WavyScrollTbl2:
@45a7:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; scroll HDMA values for wavy BG3
WavyScrollTbl3:
@45e7:  .word   $0000,$0001,$0001,$0001,$0000,$ffff,$ffff,$ffff
        .word   $0000,$0001,$0001,$0001,$0000,$ffff,$ffff,$ffff

; unused scroll values for BG3
WavyScrollTbl4:
@4607:  .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
        .word   $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000

; ------------------------------------------------------------------------------

; [ init party position ]

InitPlayerPos:
@4627:  ldy     $0803
        lda     $1fc0                   ; party position
        longa
        asl4
        shorta
        sta     $086a,y                 ; set party object x position
        xba
        sta     $086b,y
        tdc
        lda     $1fc1
        longa
        asl4
        shorta
        sta     $086d,y                 ; set party object y position
        xba
        sta     $086e,y
        tdc
        rts

; ------------------------------------------------------------------------------

; [ init party object ]

InitPlayerObj:
@4651:  ldy     $0803                   ; pointer to party object data
        lda     $0743                   ; party facing direction
        bmi     @4667
        sta     $087f,y                 ; set party object facing direction
        tax
        lda     f:ObjStopTileTbl,x
        sta     $0876,y                 ; set graphical action
        sta     $0877,y
@4667:  tdc
        sta     $087e,y                 ; clear movement direction
        sta     $0886,y
        longa
        sta     $0871,y                 ; clear movement speed
        sta     $0873,y
        shorta
        lda     #$02                    ; set object speed to $02
        sta     $0875,y
        rts

; ------------------------------------------------------------------------------

; [ init party z-level ]

InitZLevel:
@467e:  jsr     UpdateLocalTiles
        ldy     $0803                   ; pointer to party object data
        lda     $b8                     ; branch if not on a bridge tile
        and     #$04
        beq     @46c5

; bridge tile
        lda     $0744                   ; saved/destination z-level
        sta     $b2                     ; set party's current z-level
        cmp     #$02
        beq     @46ab                   ; branch if party is on lower z-level

; bridge tile, party on upper z-level
        ldx     #$00f8                  ; set sprite data pointer (upper z-level)
        stx     $b4
        lda     $0880,y                 ; set top sprite priority to 3 (shown above bg priority 1)
        ora     #$30
        sta     $0880,y
        lda     $0881,y                 ; set bottom sprite priority to 2 (shown below bg priority 1)
        and     #$cf
        ora     #$20
        sta     $0881,y
        rts

; bridge tile, party on lower z-level
@46ab:  ldx     #$01b8                  ; set sprite data pointer (lower z-level)
        stx     $b4
        lda     $0880,y                 ; set top sprite priority to 2 (shown below bg priority 1)
        and     #$cf
        ora     #$20
        sta     $0880,y
        lda     $0881,y                 ; set bottom sprite priority to 2 (shown below bg priority 1)
        and     #$cf
        ora     #$20
        sta     $0881,y
        rts

; not a bridge tile
@46c5:  lda     $b8                     ; tile z-level passability
        and     #$03
        sta     a:$00b2                 ; store as party z-level
        lda     $0881,y                 ; set bottom sprite priority to 2 (shown below bg priority 1)
        and     #$cf
        ora     #$20
        sta     $0881,y
        lda     $b8                     ; upper sprite priority
        and     #$08
        beq     @46e0                   ; branch if upper sprite is not shown above bg priority 1)
        lda     #$30
        bra     @46e2
@46e0:  lda     #$20
@46e2:  sta     $1a
        lda     $0880,y                 ; set top sprite priority to 2 or 3
        and     #$cf
        ora     $1a
        sta     $0880,y
        ldx     #$00f8                  ; set sprite data pointer (upper z-level)
        stx     $b4
        rts

; ------------------------------------------------------------------------------

; [ check adjacent npcs ]

CheckNPCs:
@46f4:  lda     $4c                     ; return if fading in/out
        cmp     #$f0
        bne     @472b
        lda     $59                     ; return if menu is opening
        bne     @472b
        lda     $84                     ; return if map is loading
        bne     @472b
        ldy     $0803                   ; get party object number
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        ldx     $e5                     ; return if an event is running
        cpx     #$0000
        bne     @472b
        lda     $e7
        cmp     #$ca
        bne     @472b
        lda     $087c,y                 ; party object movement type
        and     #$0f
        cmp     #$02                    ; return if not user-controlled
        bne     @472b
        lda     $ba                     ; return if dialog window is open
        bne     @472b
        lda     $06                     ; return if a button is not down
        bmi     @472c
@472b:  rts
@472c:  lda     $087f,y                 ; party object facing direction
        inc
        jsr     GetObjMapAdjacent
        ldx     $1e
        lda     $7e2000,x               ; object that party is facing
        bmi     @478e                   ; branch if no object there
        lsr
        cmp     hRDDIVL
        beq     @478e                   ; branch if the party there is the party object (???)
        asl
        tax
        ldy     $0799,x                 ; get pointer to target object data
        lda     $087c,y
        and     #$40
        bne     @472b                   ; return if the object activates on collision
        lda     $b8
        and     #$07                    ; current tile z-level
        cmp     #$01
        beq     @4771                   ; branch if upper z-level, not a bridge tile
        cmp     #$02
        beq     @477c                   ; branch if lower z-level, not a bridge tile
        cmp     #$03
        beq     @4785                   ; branch if upper & lower z-level, not a bridge tile

; bridge tile
        lda     $b2                     ; party z-level
        cmp     $0888,y
        beq     @47cc                   ; try to do event if target is on the same z-level as the party
        cmp     #$01
        bne     @478e                   ; no match if the party is not on the upper z-level
        lda     $0888,y                 ; try to do event if target is on a bridge tile
        and     #$04
        bne     @47cc
        bra     @478e

; upper z-level tile
@4771:  lda     $0888,y
        and     #$07
        cmp     #$02
        beq     @478e                   ; try to do event only if target is upper z-level
        bra     @47cc

; lower z-level tile
@477c:  lda     $0888,y
        and     #$02
        bne     @47cc                   ; try to do event if target is not upper z-level
        bra     @478e

; upper & lower z-level tile
@4785:  lda     $0888,y
        and     #$04
        bne     @478e                   ; try to do event only if target is on a bridge tile
        bra     @47cc

; no match, check for an npc on the other side of a counter tile
@478e:  ldx     $1e
        lda     $7f0000,x
        tax
        lda     $7e7600,x
        cmp     #$f7
        beq     @472b                   ; return of the adjacent tile is fully impassable
        and     #$07
        cmp     #$07
        bne     @472b                   ; return if the adjacent tile is not a counter tile
        lda     $087f,y
        tax
        lda     $1e
        clc
        adc     f:ThruTileOffsetX,x               ; go one more tile in the facing direction
        and     $86
        sta     $1e
        lda     $1f
        clc
        adc     f:ThruTileOffsetY,x
        and     $87
        sta     $1f
        ldx     $1e
        lda     $7e2000,x               ; return if there's no npc there
        bmi     @47cb
        tax
        ldy     $0799,x                 ; if there's an npc there, try to do event
        bra     @47cc
@47cb:  rts

; party and target match, try to do event
@47cc:  lda     $087c,y                 ; branch if target object is already activated
        and     #$0f
        cmp     #$04
        beq     @47cb
        sta     $087d,y                 ; save target object movement type
        ldy     $da                     ; pointer to party object data
        lda     $087f,y                 ; facing direction
        inc2
        and     #$03
        sta     $1a                     ; $1a = opposite of party facing direction
        ldy     $0799,x                 ; pointer to target object data
        lda     $087f,y                 ; facing direction
        asl3
        sta     $1b
        lda     $0868,y                 ; save old facing direction
        and     #$e7
        ora     $1b
        sta     $0868,y
        lda     $087c,y                 ; branch if object doesn't turn when activated
        and     #$20
        bne     @480c
        lda     $1a
        sta     $087f,y                 ; set facing direction
        tax
        lda     f:ObjStopTileTbl,x               ; graphics position (standing still)
        sta     $0877,y                 ; set graphics position
@480c:  lda     $087c,y                 ; set movement type to activated
        and     #$f0
        ora     #$04
        sta     $087c,y
        lda     $0889,y                 ; set event pc
        sta     $e5
        sta     $05f4
        lda     $088a,y
        sta     $e6
        sta     $05f5
        lda     $088b,y
        clc
        adc     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000                  ; set event return address
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003                  ; set event stack pointer
        stx     $e8
        ldy     $da                     ; pointer to party object data
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        lda     #$04                    ; set movement type to activated
        sta     $087c,y
        jsr     CloseMapTitleWindow
        rts

; ------------------------------------------------------------------------------

; x-offset for through-tile
ThruTileOffsetX:
@4857:  .byte   $00,$01,$00,$ff

; y-offset for through-tile
ThruTileOffsetY:
@485b:  .byte   $ff,$00,$01,$00

; ------------------------------------------------------------------------------

; [ do user-controlled object movement ]

UpdatePlayerMovement:
@485f:  jsr     UpdateLocalTiles
        lda     $b8                     ; $b1 = tile z-level passability (unused)
        and     #$03
        sta     $b1
        jsr     UpdatePlayerSpritePriorityAfter
        jsr     UpdatePlayerLayerPriorityAfter
        ldy     $da                     ; pointer to current object data
        longa
        tdc
        sta     $0871,y                 ; clear object movement speed
        sta     $0873,y
        sta     $73                     ; clear movement bg scroll speed
        sta     $75
        sta     $77
        sta     $79
        sta     $7b
        sta     $7d
        shorta
        lda     $0868,y                 ; enable walking animation
        ora     #$01
        sta     $0868,y
        lda     $1eb9                   ; branch if user does not have control
        bmi     @48bc
        lda     $84                     ; branch if map is loading
        bne     @48bc
        lda     $59                     ; branch if menu is opening
        bne     @48bc
        lda     $055e                   ; branch if there are object collisions
        bne     @48bc
        lda     $055a                   ; branch if bg1 needs to be updated
        beq     @48aa
        cmp     #$05
        bne     @48bc
@48aa:  lda     $055b                   ; branch if bg2 needs to be updated
        beq     @48b3
        cmp     #$05
        bne     @48bc
@48b3:  lda     $055c                   ; branch if bg3 needs to be updated
        beq     @48bf
        cmp     #$05
        beq     @48bf
@48bc:  jmp     @49ef
@48bf:  lda     $b8                     ; bottom tile, bottom sprite z-level
        and     #$04
        beq     @48cb                   ; branch if not a bridge tile
        lda     $b2
        cmp     #$02
        beq     @48d1                   ; branch if party is lower z-level
@48cb:  lda     $b8
        and     #$c0
        bne     @48d4                   ; branch if tile has diagonal movement
@48d1:  jmp     @4978

; diagonal movement
@48d4:  lda     $07
        and     #$01
        beq     @490a
        lda     #$01
        sta     $087f,y
        lda     $b8
        bmi     @48f9
        lda     $a8
        tax
        lda     $7e7600,x
        cmp     #$f7
        beq     @48f6
        and     #$40
        beq     @48f6
        lda     #$05
        bra     @493f
@48f6:  jmp     @4978
@48f9:  lda     $ae
        tax
        lda     $7e7600,x
        bpl     @4978
        cmp     #$f7
        beq     @4978
        lda     #$06
        bra     @493f
@490a:  lda     $07
        and     #$02
        beq     @4978
        lda     #$03
        sta     $087f,y
        lda     $b8
        bpl     @492e
        lda     $b8
        bpl     @4996
        lda     $a6
        tax
        lda     $7e7600,x
        bpl     @4978
        cmp     #$f7
        beq     @4978
        lda     #$08
        bra     @493f
@492e:  lda     $ac
        tax
        lda     $7e7600,x
        cmp     #$f7
        beq     @4978
        and     #$40
        beq     @4978
        lda     #$07
@493f:  sta     $087e,y
        sta     $b3
        lda     $b8
        and     #$04
        bne     @4954
        lda     $b8
        and     #$03
        cmp     #$03
        beq     @4954
        sta     $b2
@4954:  jsr     UpdatePlayerSpritePriorityBefore
        jsr     UpdatePlayerLayerPriorityBefore
        jsr     CalcObjMoveDir
        jsr     UpdateScrollRate
        stz     $85
        lda     #$01                    ; one step
        sta     $0886,y
        jsr     UpdateOverlay
        jsr     IncSteps
        jsr     UpdatePartyFlags
        lda     #$01
        sta     $57
        stz     $078e
        rts

; not diagonal movement
@4978:  lda     $07
        and     #$01
        beq     @4996                   ; branch if right button is not pressed
        lda     #$47                    ; set graphic position
        sta     $0877,y
        lda     #$01                    ; set facing direction
        sta     $087f,y
        jsr     CheckDoor
        bne     @49ef                   ; branch if a door opened
        lda     #$02                    ; movement direction = 2 (right)
        jsr     CheckPlayerMove
        beq     @49ef                   ; branch if movement not allowed
        bra     @4a03                   ; branch if movement allowed
@4996:  lda     $07
        and     #$02
        beq     @49b4                   ; branch if left button is not pressed
        lda     #$07
        sta     $0877,y
        lda     #$03
        sta     $087f,y
        jsr     CheckDoor
        bne     @49ef                   ; branch if a door opened
        lda     #$04                    ; movement direction = 4 (left)
        jsr     CheckPlayerMove
        beq     @49ef
        bra     @4a03
@49b4:  lda     $07
        and     #$08
        beq     @49d1                   ; branch if up button is not pressed
        lda     #$04
        sta     $0877,y
        tdc
        sta     $087f,y
        jsr     CheckDoor
        bne     @49ef                   ; branch if a door opened
        lda     #$01                    ; movement direction = 1 (up)
        jsr     CheckPlayerMove
        beq     @49ef
        bra     @4a03
@49d1:  lda     $07
        and     #$04
        beq     @49ef                   ; branch if down button is not pressed
        lda     #$01
        sta     $0877,y
        lda     #$02
        sta     $087f,y
        jsr     CheckDoor
        bne     @49ef                   ; branch if a door opened
        lda     #$03                    ; movement direction = 3 (down)
        jsr     CheckPlayerMove
        beq     @49ef
        bra     @4a03

; party didn't move
@49ef:  ldy     $0803
        tdc
        sta     $087e,y                 ; no movement
        stz     $0886                   ; zero steps
        jsr     UpdateOverlay
        jsr     CheckNPCs
        jsr     CheckTreasure
        rts

; party moved
@4a03:  jsr     IncSteps
        jsl     DoPoisonDmg
        ldy     $0803
        jsr     CalcObjMoveDir
        jsr     UpdateScrollRate
        stz     $85                     ; disable entrance triggers
        lda     #$01                    ; take one step
        sta     $0886
        jsr     UpdatePartyFlags
        lda     $1eb6                   ; clear tile event bit
        and     #$df
        sta     $1eb6
        lda     $1eb7                   ; clear save point event bit
        and     #$7f
        sta     $1eb7
        jsr     UpdateOverlay
        jsr     CheckNPCs
        lda     #1                      ; random battles enabled
        sta     $57
        stz     $078e                   ; party is not on a trigger
        rts

; ------------------------------------------------------------------------------

; unused
@4a3b:  .byte   $10,$08,$04,$02

; ------------------------------------------------------------------------------

; [ update hp each step ]

DoPoisonDmg:
@4a3f:  php
        shorta0
        longi
        ldx     $1e
        phx
        ldx     $20
        phx
        ldx     $22
        phx
        ldx     $24
        phx
        ldx     $00
        txy

; start of character loop
@4a54:  lda     $1850,x
        and     #$40
        beq     @4acb
        lda     $1850,x
        and     #$07
        cmp     $1a6d
        bne     @4acb
        lda     $1614,y
        and     #$c2
        bne     @4a93
        lda     $1623,y                 ; check for tintinabar
        cmp     #$e5
        beq     @4a7a
        lda     $1624,y
        cmp     #$e5
        bne     @4a93
@4a7a:  jsr     CalcMaxHP
        lda     $161c,y
        lsr2
        longac
        adc     $1609,y
        cmp     $1e
        bcc     @4a8d
        lda     $1e
@4a8d:  sta     $1609,y
        shorta0
@4a93:  lda     $1614,y
        and     #$04
        beq     @4acb                   ; branch if not poisoned
        lda     #$0f
        sta     $11f0
        longa
        lda     #$0f00
        sta     $0796
        shorta0
        jsr     CalcMaxHP
        longa
        lda     $1e
        lsr5
        sta     $1e
        lda     $1609,y
        sec
        sbc     $1e
        beq     @4ac2
        bcs     @4ac5
@4ac2:  lda     #1                      ; min 1 hp
@4ac5:  sta     $1609,y
        shorta0
@4acb:  longac                          ; next character
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        beq     @4ade
        jmp     @4a54
@4ade:  plx
        stx     $24
        plx
        stx     $22
        plx
        stx     $20
        plx
        stx     $1e
        plp
        rtl

; ------------------------------------------------------------------------------

; [ reset party event bits ]

; called whenever the player takes a step

UpdatePartyFlags:
@4aec:  lda     $1a6d       ; branch if not party 1
        cmp     #$01
        bne     @4b15

; party 1
        lda     $1ed8
        and     #$ef
        sta     $1ed8
        lda     $1ed8
        and     #$df
        sta     $1ed8
        lda     $1ed8
        and     #$bf
        sta     $1ed8
        lda     $1ed8
        and     #$7f
        sta     $1ed8
        bra     @4b5f

; party 2
@4b15:  cmp     #$02        ; branch if not party 2
        bne     @4b3b
        lda     $1ed9
        and     #$fe
        sta     $1ed9
        lda     $1ed9
        and     #$fd
        sta     $1ed9
        lda     $1ed9
        and     #$fb
        sta     $1ed9
        lda     $1ed9
        and     #$f7
        sta     $1ed9
        bra     @4b5f

; party 3
@4b3b:  cmp     #$03        ; return if not party 3
        bne     @4b5f
        lda     $1ed9
        and     #$ef
        sta     $1ed9
        lda     $1ed9
        and     #$df
        sta     $1ed9
        lda     $1ed9
        and     #$bf
        sta     $1ed9
        lda     $1ed9
        and     #$7f
        sta     $1ed9
@4b5f:  rts

; ------------------------------------------------------------------------------

; [ increment steps ]

IncSteps:
@4b60:  lda     $1866                   ; 9999999 max steps
        cmp     #.lobyte(9999999)
        bne     @4b75
        lda     $1867
        cmp     #.hibyte(9999999)
        bne     @4b75
        lda     $1868
        cmp     #.bankbyte(9999999)
        beq     @4b82
@4b75:  inc     $1866
        bne     @4b82
        inc     $1867
        bne     @4b82
        inc     $1868
@4b82:  rts

; ------------------------------------------------------------------------------

; [ check treasures ]

CheckTreasure:
@4b83:  lda     $ba
        bne     @4bd3
        lda     $59
        bne     @4bd3
        lda     $84
        bne     @4bd3
        ldy     $e5
        cpy     #$0000
        bne     @4bd3
        lda     $e7
        cmp     #$ca
        bne     @4bd3
        lda     $b8
        and     #$04
        beq     @4ba8
        lda     $b2
        cmp     #$02
        beq     @4bd3
@4ba8:  lda     $06
        bpl     @4bd3       ; return if a button is not pressed
        ldy     $0803
        lda     $087f,y
        tax
        lda     $087a,y
        clc
        adc     f:TreasureOffsetX,x
        and     $86
        sta     $2a
        lda     $087b,y
        clc
        adc     f:TreasureOffsetY,x
        and     $87
        sta     $2b
        ldx     $2a
        lda     $7e2000,x
        bmi     @4bd4
@4bd3:  rts
@4bd4:  longa
        lda     $82
        asl
        tax
        lda     $ed82f6,x   ; pointer to treasure data
        sta     $1e
        lda     $ed82f4,x
        tax
        shorta0
        cpx     $1e
        beq     @4bd3
@4bec:  lda     $ed8634,x   ; x position
        cmp     $2a
        bne     @4bfc
        lda     $ed8635,x   ; y position
        cmp     $2b
        beq     @4c06
@4bfc:  inx5
        cpx     $1e
        bne     @4bec
        rts
@4c06:  longa
        lda     $ed8638,x   ; treasure contents
        sta     $1a
        lda     $ed8636,x   ; treasure event bit and type
        sta     $1e
        and     #$0007
        tax
        lda     $1e
        and     #$01ff
        lsr3
        tay
        shorta0
        lda     $1e40,y
        and     f:BitOrTbl,x
        bne     @4bd3       ; return if treasure has already been obtained
        lda     $1e40,y
        ora     f:BitOrTbl,x
        sta     $1e40,y     ; set treasure event bit
        lda     $1f
        bpl     @4c80       ; branch if not gp

; gp
        lda     $1a
        sta     hWRMPYA
        lda     #$64        ; multiply by 100
        sta     hWRMPYB
        nop3
        ldy     hRDMPYL
        sty     $22
        stz     $24
        longac
        tya
        adc     $1860       ; add to gp
        sta     $1860
        shorta0
        adc     $1862
        sta     $1862
        cmp     #$98
        bcc     @4c78
        ldx     $1860
        cpx     #$967f
        bcc     @4c78
        ldx     #$967f      ; max 9,999,999 gp
        stx     $1860
        lda     #$98
        sta     $1862
@4c78:  jsr     HexToDec
        ldx     #$0010      ; $ca0010 (chest with gp)
        bra     @4cac

; item
@4c80:  lda     $1f
        and     #$40
        beq     @4c93       ; branch if not an item
        lda     $1a
        sta     $0583
        jsr     GiveItem
        ldx     #$0008      ; $ca0008 (chest with item)
        bra     @4cac

; monster
@4c93:  lda     $1f
        and     #$20
        beq     @4ca3       ; branch if not a monster
        lda     $1a
        sta     $0789       ; set monster-in-a-box formation
        ldx     #$0040      ; $ca0040 (chest with monster)
        bra     @4cac

; empty
@4ca3:  lda     $1f
        and     #$10
        beq     @4ca9       ; <- this has no effect
@4ca9:  ldx     #$0014      ; $ca0014 (empty chest)
@4cac:  stx     $e5         ; set event pc
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000      ; event return address = $ca0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003      ; event stack pointer
        stx     $e8
        ldy     $0803
        lda     $087c,y     ;
        sta     $087d,y
        lda     #$04
        sta     $087c,y
        jsr     CloseMapTitleWindow
        ldx     $2a
        lda     $7f0000,x   ; bg1 tile
        cmp     #$13
        bne     @4d06       ; branch if not a closed treasure chest
        stx     $8f
        ldx     #.loword(TreasureTiles)
        stx     $8c
        lda     #^*
        sta     $8e
        ldx     #$0000
        stx     $2a
        lda     #$04
        sta     $055a
        jsr     ModifyMap
        lda     #$a6        ; sound effect $a6 (treasure chest)
        jsr     PlaySfx
        rts
@4d06:  lda     #$1b        ; sound effect $1b (pot/crate treasure)
        jsr     PlaySfx
        rts

; ------------------------------------------------------------------------------

; treasure chest map data (1x1)
TreasureTiles:
@4d0c:  .byte   $01, $01
        .byte   $12

TreasureOffsetX:
@4d0f:  .byte   $00, $01, $00, $ff

TreasureOffsetY:
@4d13:  .byte   $ff, $00, $01, $00

; ------------------------------------------------------------------------------

; [ load door map data ]

DrawOpenDoor:
@4d17:  ldy     $00
@4d19:  cpy     $1127
        beq     @4d50
        phy
        ldx     $1129,y
        stx     $8f
        lda     $7f0000,x
        cmp     #$05
        bne     @4d31
        ldx     #.loword(OpenDoorTiles1)
        bra     @4d3d
@4d31:  cmp     #$07
        bne     @4d3a
        ldx     #.loword(OpenDoorTiles2)
        bra     @4d3d
@4d3a:  ldx     #.loword(OpenDoorTiles3)
@4d3d:  stx     $8c
        lda     #^*
        sta     $8e
        ldx     #$0000
        stx     $2a
        jsr     ModifyMap
        ply
        iny2
        bra     @4d19
@4d50:  rts

; ------------------------------------------------------------------------------

; [ open door ]

; return value = 1 if a door opens, 0 if a door doesn't open

CheckDoor:
@4d51:  lda     $b8         ; return if tile is lower z-level
        and     #$04
        beq     @4d60
        lda     $b2         ; return if party is lower z-level
        cmp     #$02
        bne     @4d60
@4d5d:  jmp     @4e04
@4d60:  lda     $087f,y     ; facing direction
        lsr
        bcs     @4d5d       ; return if not facing up or down
        bne     @4d72       ; branch if facing down
        lda     $b0         ; door's y position is 2 tiles above party
        dec2
        sta     $90         ; $90 = door's y position
        lda     $a7         ; tile above character
        bra     @4d78
@4d72:  lda     $b0         ; door's y position is same as party
        sta     $90
        lda     $ad         ; tile below character
@4d78:  cmp     #$15
        bne     @4d91       ; branch if not small door 1
        lda     $7e7615     ; small door 1 tile properties
        cmp     #$f7
        beq     @4d5d       ; return if impassable
        and     #$20
        beq     @4d5d       ; return if not a door tile
        lda     $af         ; door's x position is same as party
        sta     $8f         ; $8f = door's x position
        ldx     #.loword(OpenDoorTiles1)
        bra     @4dc2
@4d91:  cmp     #$17
        bne     @4daa       ; branch if not small door 2
        lda     $7e7617
        cmp     #$f7
        beq     @4e04
        and     #$20
        beq     @4e04
        lda     $af
        sta     $8f
        ldx     #.loword(OpenDoorTiles2)
        bra     @4dc2
@4daa:  cmp     #$1c
        bne     @4e04       ; return if not big door
        lda     $7e761c
        cmp     #$f7
        beq     @4e04
        and     #$20
        beq     @4e04
        lda     $af
        dec
        sta     $8f
        ldx     #.loword(OpenDoorTiles3)
@4dc2:  stx     $8c         ; ++$8c = bg data source address
        lda     $90
        inc
        xba
        lda     $af
        tax
        tdc
        lda     $7e2000,x   ; return if there is an object on the door
        cmp     #$ff
        bne     @4e04
        longac
        ldx     $1127       ; get open door count (x2)
        lda     $8f
        sta     $1129,x     ; save door position
        inx2                ; increment open door count
        cpx     #$0030
        bcs     @4de8       ; maximum of 24 open doors
        stx     $1127
@4de8:  shorta0
        lda     #^*
        sta     $8e
        ldx     #$0000      ;
        stx     $2a
        lda     #$04        ; update bg1 (immediately)
        sta     $055a
        jsr     ModifyMap
        lda     #$2c        ; play door sound effect
        jsr     PlaySfx
        lda     #$01        ; return (door opened)
        rts
@4e04:  tdc                 ; return (no door opened)
        rts

; ------------------------------------------------------------------------------

; small door 1 map data (1x2)
OpenDoorTiles1:
@4e06:  .byte   $01,$02
        .byte   $04
				.byte   $14

; small door 2 map data (1x2)
OpenDoorTiles2:
@4e0a:  .byte   $01,$02
        .byte   $06
        .byte   $16

; big door map data (3x2)
OpenDoorTiles3:
@4e0e:  .byte   $03,$02
        .byte   $08,$09,$0a
        .byte   $18,$19,$1a

; ------------------------------------------------------------------------------

; [ party takes a step ]

; a = facing direction (in)
; a = 1 if movement allowed, 0 if not (out)

CheckPlayerMove:
@4e16:  sta     $b3         ; set movement direction
        tax
        lda     $c04f8d,x   ; get pointer to tile number
        tax
        lda     $a3,x       ; bg1 tile
        tax
        lda     $1eb8       ; branch if sprint shoes effect is disabled
        and     #$02
        bne     @4e33
        lda     $11df       ; branch if not wearing sprint shoes
        and     #$20
        beq     @4e33
        lda     #$03        ; object speed = 3 (sprint shoes)
        bra     @4e35
@4e33:  lda     #$02        ; object speed = 2 (normal)
@4e35:  sta     $0875,y
        lda     #$7e
        pha
        plb
        phx
        lda     $b3         ; movement direction
        dec
        tax
        lda     f:DirectionBitTbl,x   ; get direction bit mask
        sta     $1a
        plx
        lda     $b9         ; directional passability of current tile
        and     #$0f
        and     $1a
        beq     @4e98       ; return if direction not allowed
        lda     $7600,x     ; destination tile properties
        and     #$07
        cmp     #$07
        beq     @4e98       ; return if destination is a counter tile
        lda     $b8         ; branch if current tile is not a bridge tile
        and     #$04
        beq     @4e77

; bridge tile
        lda     $b2
        and     #$01
        beq     @4e6e       ; branch if party is on lower z-level

; bridge tile, party on upper z-level
        lda     $7600,x     ; movement allowed unless destination tile is lower z-level
        and     #$02
        bne     @4e98
        bra     @4e9d

; bridge tile, party on lower z-level
@4e6e:  lda     $7600,x     ; movement allowed unless destination tile is upper z-level
        and     #$01
        bne     @4e98
        bra     @4e9d

; current tile is not a bridge tile
@4e77:  lda     $7600,x     ; destination tile z-level
        and     #$03
        cmp     #$03
        beq     @4e9d       ; movement always allowed if destination tile is upper & lower z-level
        lda     $b8
        and     #$03
        cmp     #$03
        beq     @4e91       ; branch if party is on upper & lower z-level
        eor     #$03
        and     $7600,x     ; movement allowed if party and destination z-level match
        bne     @4e98
        bra     @4e9d
@4e91:  lda     $7600,x     ; party on upper & lower, movement allowed unless destination is a bridge tile
        and     #$04
        beq     @4e9d
@4e98:  tdc
        pha
        plb
        tdc                 ; a = 0 (no movement)
        rts

; movement allowed
@4e9d:  phx
        lda     $b3
        jsr     GetObjMapAdjacent
        plx
        ldy     $1e
        lda     $2000,y     ; object map data at destination
        bmi     @4ec4       ; branch if there's no object there
        lda     $7600,x
        and     #$04
        beq     @4e98       ; movement not allowed unless destination tile is a bridge tile
        lda     $b8
        and     #$07
        cmp     #$01
        beq     @4e98       ; movement not allowed if current tile is upper z-level
        cmp     #$02
        beq     @4ec4       ; movement allowed if current tile is lower z-level
        lda     $b2
        cmp     #$02
        bne     @4e98       ; movement not allowed if party is not on lower z-level
@4ec4:  lda     $7600,x     ; branch if destination tile is not a bridge tile
        and     #$04
        beq     @4ed1
        lda     $b2         ; branch if party is on lower z-level (object map data doesn't get set if party is on bottom of a bridge tile)
        cmp     #$02
        beq     @4eef
@4ed1:  tdc
        pha
        plb
        ldx     $0803       ; get party object number
        stx     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop4
        lda     #$7e
        pha
        plb
        lda     f:hRDDIVL
        asl
        sta     $2000,y     ; set object map data
@4eef:  lda     $b8         ; current tile z-level
        and     #$07
        cmp     #$03
        bcs     @4efd       ; branch if a bridge tile (party retains previous z-level)
        lda     $b8
        and     #$03        ; set new party z-level
        sta     $b2
@4efd:  jsr     UpdatePlayerSpritePriorityBefore
        jsr     UpdatePlayerLayerPriorityBefore
        tdc
        pha
        plb
        ldy     $da         ; pointer to object data
        lda     $b3         ; set movement direction
        sta     $087e,y
        lda     #$01        ; a = 1 (movement allowed)
        rts

; ------------------------------------------------------------------------------

DirectionBitTbl:
@4f10:  .byte   $08,$01,$04,$02

; ------------------------------------------------------------------------------

; [ update party sprite priority (based on current tile) ]

UpdatePlayerSpritePriorityAfter:
@4f14:  ldx     $b4         ; pointer to party sprite data (+$0300)
        cpx     #$00f8
        beq     @4f2c       ; return if party sprite is already lower z-level
        lda     $b8         ; return if current tile is a bridge tile
        and     #$04
        bne     @4f2c
        lda     $b6         ; return if upper tile is a bridge tile
        and     #$04
        bne     @4f2c
        ldx     #$00f8      ; make party sprite lower z-level
        stx     $b4
@4f2c:  rts

; ------------------------------------------------------------------------------

; [ update party sprite priority (based on destination tile) ]

UpdatePlayerSpritePriorityBefore:
@4f2d:  ldx     $b4
        cpx     #$01b8      ; return if sprite is already lower z-level
        beq     @4f7a
        lda     $b3         ; movement direction
        tax
        lda     f:_c04f8d,x   ; tile in movement direction
        tax
        lda     $a3,x
        tax
        lda     $7e7600,x   ; tile properties
        sta     $1a
        and     #$04
        beq     @4f56       ; branch if not a bridge tile

; destination tile is a bridge tile
        lda     $b2         ; return if party is not on lower z-level
        cmp     #$02
        bne     @4f7a
        ldx     #$01b8      ; set sprite to lower z-level priority
        stx     $b4
        bra     @4f7a

; destination tile is not a bridge tile
@4f56:  lda     $b3
        tax
        lda     f:_c04f7b,x   ; destination tile for upper sprite
        tax
        lda     $a3,x
        tax
        lda     $7e7600,x
        cmp     #$f7        ; return if impassable
        beq     @4f7a
        and     #$04
        beq     @4f7a       ; return if not a bridge tile
        lda     $b6
        and     #$07
        cmp     #$02
        bne     @4f7a       ; return if current top sprite tile is not lower z-level only
        ldx     #$01b8      ; set sprite to lower z-level priority
        stx     $b4
@4f7a:  rts

; ------------------------------------------------------------------------------

; pointers to upper sprite tiles in movement directions (+$a3)
_c04f7b:
@4f7b:  .byte   $04,$01,$05,$07,$03,$02,$08,$06,$00
        .byte   $04,$01,$02,$05,$08,$07,$06,$03,$00

; pointers to tiles in movement directions (+$a3)
_c04f8d:
@4f8d:  .byte   $07,$04,$08,$0a,$06,$05,$0b,$09,$03
        .byte   $07,$04,$05,$08,$0b,$0a,$09,$06,$03

; ------------------------------------------------------------------------------

; [ update party layer priority (based on current tile) ]

UpdatePlayerLayerPriorityAfter:
@4f9f:  ldy     $0803
        lda     $0868,y     ; party layer priority
        and     #$06
        beq     @4fac       ; branch if default priority (based on tile properties)
        jmp     _c07c69
@4fac:  lda     $b8
        and     #$04
        beq     @4fc2       ; branch if not on a bridge tile

; bridge tile
        lda     $b2
        cmp     #$01
        bne     @4fe5       ; return if upper z-level
        lda     $0880,y     ; upper sprite shown above bg priority 1
        ora     #$30
        sta     $0880,y
        bra     @4fd7

; not on a bridge tile
@4fc2:  lda     $0880,y
        and     #$10
        bne     @4fd7
        lda     $b8
        and     #$08
        beq     @4fd7       ; branch if current tile is not priority for upper sprite
        lda     $0880,y     ; upper sprite priority = 3
        ora     #$30
        sta     $0880,y
@4fd7:  lda     $b8
        and     #$10
        beq     @4fe5       ; branch if current tile is not priority for lower sprite
        lda     $0881,y     ; lower sprite priority = 3
        ora     #$30
        sta     $0881,y
@4fe5:  rts

; ------------------------------------------------------------------------------

; [ update party layer priority (based on destination tile) ]

UpdatePlayerLayerPriorityBefore:
@4fe6:  ldy     $0803
        lda     $0868,y     ; sprite layer priority
        and     #$06
        beq     @4ff3
        jmp     _c07c69
@4ff3:  lda     $b3
        tax
        lda     $c04f8d,x
        tax
        lda     $a3,x
        tax
        lda     $7e7600,x
        and     #$04
        beq     @5018
        lda     $b2
        cmp     #$02
        bne     @5031
        lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
        bra     @5031
@5018:  lda     $0880,y
        and     #$10
        beq     @5031
        lda     $7e7600,x
        and     #$08
        bne     @5031
        lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
@5031:  lda     $7e7600,x
        and     #$10
        bne     @5043
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
@5043:  rts

; ------------------------------------------------------------------------------

; [ update adjacent tile properties ]

UpdateLocalTiles:
@5044:  ldy     $0803
        longa
        lda     $086d,y
        lsr4
        shorta
        sta     $23
        dec
        and     $87
        sta     $21
        dec
        and     $87
        sta     $1f
        lda     $23
        inc
        and     $87
        sta     $25
        stz     $1e
        stz     $20
        stz     $22
        stz     $24
        longa
        lda     $086a,y
        lsr4
        and     #$00ff
        shorta
        dec
        and     $86
        sta     $1a
        inc
        and     $86
        sta     $1b
        inc
        and     $86
        sta     $1c
        lda     #$7f
        pha
        plb
        tdc
        tax
        tay
        shorti
        ldy     $1a
        lda     ($1e),y
        sta     $a3
        lda     ($20),y
        sta     $a6
        lda     ($22),y
        sta     $a9
        lda     ($24),y
        sta     $ac
        ldy     $1b
        lda     ($1e),y
        sta     $a4
        lda     ($20),y
        sta     $a7
        lda     ($22),y
        sta     $aa
        lda     ($24),y
        sta     $ad
        ldy     $1c
        lda     ($1e),y
        sta     $a5
        lda     ($20),y
        sta     $a8
        lda     ($22),y
        sta     $ab
        lda     ($24),y
        sta     $ae
        lda     #$7e
        pha
        plb
        ldx     $a7
        lda     $7600,x
        sta     $b6
        lda     $7700,x
        sta     $b7
        ldx     $aa
        lda     $7600,x
        sta     $b8
        lda     $7700,x
        sta     $b9
        longi
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load sprite palettes ]

InitSpritePal:
@50eb:  ldx     $00
@50ed:  lda     f:MapSpritePal,x
        sta     $7e7300,x
        sta     $7e7500,x
        inx
        cpx     #$0100
        bne     @50ed
        rts

; ------------------------------------------------------------------------------

; unused
@5100:  .byte   $00,$0c,$18,$24

; ------------------------------------------------------------------------------

; [ init character portrait (from ending) ]

InitPortrait:
@5104:  lda     f:$001eb8               ; return if portrait event bit is not set
        and     #$40
        bne     @510d
        rts
@510d:  lda     $0795                   ; portrait index
        longa
        xba
        lsr3
        tax
        shorta0
        lda     #$7e
        pha
        plb
        ldy     $00
@5120:  lda     $ed5860,x               ; character portrait color palette
        sta     $75e0,y
        inx
        iny
        cpy     #$0020
        bne     @5120
        tdc
        pha
        plb
        stz     hMDMAEN
        ldx     #$7000                  ; clear vram $7000-$7800
        stx     hVMADDL
        lda     #$80
        sta     hVMAINC
        lda     #$09
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$0000                  ; source = $00 (fixed address)
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        lda     #$41
        sta     $4300
        lda     $0795                   ; portrait index
        asl
        tax
        longac
        lda     f:PortraitGfxPtrs,x     ; pointer to portrait graphics
        sta     $2a
        shorta0
        ldx     $00
@517c:  lda     f:PortraitTiles,x       ; tile formation
        longac
        xba
        lsr3
        clc
        adc     $2a
        sta     $4302
        shorta0
        lda     #$ed
        sta     $4304
        ldy     #$0020                  ; transfer one tile at a time
        sty     $4305
        lda     f:PortraitVRAMTbl,x
        longac
        asl4
        clc
        adc     #$7000
        sta     hVMADDL
        shorta0
        lda     #$01
        sta     hMDMAEN
        inx
        cpx     #25
        bne     @517c
        rts

; ------------------------------------------------------------------------------

; pointers to character portrait graphics (+$ed0000, first 16 only)
PortraitGfxPtrs:
@51ba:  .word   $1d00,$2020,$2340,$2660,$2980,$2ca0,$2fc0,$32e0
        .word   $3600,$3920,$3c40,$3f60,$4280,$45a0,$48c0,$4be0

; character portrait tile formation
PortraitTiles:
@51da:  .byte   $00,$01,$02,$03,$08
        .byte   $10,$11,$12,$13,$09
        .byte   $04,$05,$06,$07,$0a
        .byte   $14,$15,$16,$17,$0b
        .byte   $0d,$0e,$0f,$18,$0c

; character portrait vram location
PortraitVRAMTbl:
@51f3:  .byte   $00,$01,$02,$03,$04
        .byte   $10,$11,$12,$13,$14
        .byte   $20,$21,$22,$23,$24
        .byte   $30,$31,$32,$33,$34
        .byte   $40,$41,$42,$43,$44

; ------------------------------------------------------------------------------

; [ init character object sprite priority ]

InitCharSpritePriority:
@520c:  ldy     $00
@520e:  lda     $0868,y                 ; sprite priority/walking animation
        and     #$f8                    ; enable walking animation
        ora     #$01
        sta     $0868,y
        longac                          ; loop through character objects only
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @520e
        rts

; ------------------------------------------------------------------------------

; [ init npc event bits ]

InitNPCSwitches:
@5228:  ldx     $00
@522a:  lda     $c0e0a0,x
        sta     $1ee0,x
        inx
        cpx     #$0080
        bne     @522a
        rts

; ------------------------------------------------------------------------------

; [ init object map data ]

InitNPCMap:
@5238:  ldy     $00                     ; loop through all objects
        stz     $1b
@523c:  cpy     $0803                   ; skip if this is the party object
        beq     @526f
        ldx     $088d,y                 ; skip if object is not on this map
        cpx     a:$0082
        bne     @526f
        lda     $0867,y                 ; skip if object is not visible
        bpl     @526f
        lda     $087c,y                 ; skip if object scrolls with bg2
        bmi     @526f
        lda     $0868,y                 ; skip if this is an npc with special graphics
        and     #$e0
        cmp     #$80
        beq     @526f
        lda     $088c,y                 ; skip if not normal sprite priority
        and     #$c0
        bne     @526f
        jsr     GetObjMapPtr
        ldx     $087a,y                 ; get pointer
        lda     $1b
        sta     $7e2000,x               ; set object map data
@526f:  inc     $1b                     ; next object
        inc     $1b
        longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$07b0
        bne     @523c
        ldy     $0803                   ; pointer to party object data
        sty     hWRDIVL
        lda     #$29                    ; divide by $29 to get object number
        sta     hWRDIVB
        lda     $b8                     ; tile properties, branch if bottom sprite is lower z-level
        and     #$04
        beq     @5299
        lda     $b2                     ; return if party is on lower z-level
        cmp     #$02
        beq     @52a7
@5299:  jsr     GetObjMapPtr
        ldx     $087a,y                 ; get pointer
        lda     hRDDIVL                   ; get object number * 2
        asl
        sta     $7e2000,x               ; set object map data
@52a7:  rts

; ------------------------------------------------------------------------------

; [ load npc data ]

InitNPCs:
@52a8:  ldx     $00
@52aa:  stz     $0af7,x                 ; clear object data for npc's $10-$28
        inx
        cpx     #$03d8
        bne     @52aa
        stz     $078f                   ; clear number of active npc's
        longa
        lda     $82                     ; map index
        asl
        tax
        lda     f:NPCPropPtrs+2,x       ; pointer to next map's npc data
        sta     $1e
        lda     f:NPCPropPtrs,x         ; pointer to this map's npc data
        tax
        shorta0
        ldy     #$0290                  ; start at object $10
        cpx     $1e
        bne     @52d4                   ; end loop after last npc
        jmp     @5434
@52d4:  lda     f:NPCPropPtrs,x           ; copy pointer to event script
        sta     $0889,y
        lda     f:NPCPropPtrs+1,x
        sta     $088a,y
        lda     f:NPCPropPtrs+2,x
        and     #$03
        sta     $088b,y
        lda     f:NPCPropPtrs+2,x         ; copy color palette
        and     #$1c
        lsr
        sta     $0880,y
        sta     $0881,y
        lda     f:NPCPropPtrs+2,x         ; scroll with bg2
        and     #$20
        asl2
        sta     $087c,y
        longa
        lda     f:NPCPropPtrs+2,x         ; event bit to enable this object
        lsr6
        shorta
        phx
        phy
        jsr     GetNPCSwitch0
        ply
        plx
        cmp     #$00
        beq     @531e                   ; branch if npc is not enabled
        lda     #$c0                    ; enable and show npc
@531e:  sta     $0867,y
        lda     f:NPCPropPtrs+4,x         ; npc shown in/on vehicle (or special npc graphics)
        and     #$80
        sta     $0868,y
        longa
        lda     f:NPCPropPtrs+4,x         ; x position
        and     #$007f
        asl4
        sta     $086a,y
        lda     f:NPCPropPtrs+5,x         ; y position
        and     #$003f
        asl4
        sta     $086d,y
        shorta0
        sta     $0869,y                 ; clear lsb's of position
        sta     $086c,y
        sta     $086f,y                 ; clear jump y-offset
        sta     $0870,y
        sta     $0887,y                 ; clear jump counter
        lda     f:NPCPropPtrs+5,x         ; object speed
        and     #$c0
        lsr6
        sta     $0875,y
        lda     f:NPCPropPtrs+6,x         ; graphics index (also actor index)
        sta     $0878,y
        sta     $0879,y
        lda     f:NPCPropPtrs+7,x         ; movement type
        and     #$0f
        ora     $087c,y
        sta     $087c,y
        lda     f:NPCPropPtrs+7,x         ; sprite priority
        and     #$30
        asl2
        sta     $088c,y
        lda     f:NPCPropPtrs+7,x         ; vehicle index (or animation speed)
        and     #$c0
        lsr
        ora     $0868,y
        sta     $0868,y
        lda     f:NPCPropPtrs+8,x         ; facing direction
        and     #$03
        sta     $087f,y
        phx
        tax
        lda     f:ObjStopTileTbl,x      ; graphic position for facing direction
        sta     $0877,y
        sta     $0876,y
        plx
        lda     f:NPCPropPtrs+8,x         ; turn when activated (or 32x32 sprite)
        and     #$04
        asl3
        ora     $087c,y
        sta     $087c,y
        lda     f:NPCPropPtrs+8,x         ; sprite layer priority
        and     #$18
        lsr2
        sta     $1a
        lda     $0868,y
        and     #$f9
        ora     $1a
        sta     $0868,y
        lda     f:NPCPropPtrs+8,x         ; special animation offset
        and     #$e0
        beq     @53f6                   ; branch if no special animation
        lsr5
        ora     $088c,y
        sta     $088c,y
        lda     f:NPCPropPtrs+8,x         ; animated frame type
        and     #$03
        asl3
        ora     $088c,y
        ora     #$20                    ; enable animation
        sta     $088c,y
        bra     @53f6
@53f6:  longa
        lda     $82                     ; set map index
        sta     $088d,y
        shorta0
        tdc
        sta     $087e,y                 ; clear movement direction
        sta     $0886,y                 ; clear number of steps to take
        sta     $0882,y                 ; clear script wait counter
        lda     $0868,y                 ; enable walking animation
        ora     #$01
        sta     $0868,y
        phx
        jsr     GetObjMapPtr
        jsr     UpdateSpritePriority
        plx
        inc     $078f                   ; increment number of active npcs
        longac
        tya                             ; next npc
        adc     #$0029
        tay
        txa
        clc
        adc     #$0009
        tax
        shorta0
        cpx     $1e
        beq     @5434
        jmp     @52d4
@5434:  cpy     #$07b0                  ; disable and hide any remaining npcs
        beq     @5450
@5439:  lda     $0867,y
        and     #$3f
        sta     $0867,y
        longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$07b0                  ; 32 npcs total
        bne     @5439
@5450:  jsr     _c0714a
        rts

; ------------------------------------------------------------------------------

; [ init special npc graphics ]

InitSpecialNPCs:
@5454:  lda     $078f       ; return if there are no active npc's
        beq     @547d
        ldy     #$0290      ; start with npc $10
        tdc
@545d:  pha
        lda     $0868,y     ; skip if not special graphics
        and     #$e0
        cmp     #$80
        bne     @546c
        phy
        jsr     InitSpecialNPCGfx
        ply
@546c:  longac
        tya
        adc     #$0029      ; loop through all active npc's
        tay
        shorta0
        pla
        inc
        cmp     $078f
        bne     @545d
@547d:  rts

; ------------------------------------------------------------------------------

; [ init special graphics for npc ]

; y = pointer to npc object data

InitSpecialNPCGfx:
@547e:  lda     $087c,y     ; passability flag
        ora     #$10
        sta     $087c,y
        lda     $0879,y     ; graphic index
        longa
        asl
        tax
        lda     f:MapSpriteGfxPtrsLo,x   ; ++$2a = pointer to graphics
        sta     $2a
        shorta0
        lda     f:MapSpriteGfxPtrsHi,x
        sta     $2c
        lda     $0889,y     ; continuous animation flag
        asl
        tdc
        rol
        sta     $1b
        lda     $0868,y     ; copy to walking animation flag
        and     #$fe
        ora     $1b
        sta     $0868,y
        lda     $0889,y     ; +$3b = vram address
        and     #$7f
        xba
        longa
        lsr3
        clc
        adc     #$7000
        sta     $3b
        shorta0
        lda     $088c,y     ; $1b = animated frame type
        and     #$18
        lsr3
        inc
        sta     $1b
        lda     $087c,y     ; 32x32 graphics flag
        and     #$20
        bne     @5533

; 16x16 graphics
        lda     #$41
        sta     $4300
        lda     #$80
        sta     hVMAINC
        lda     #$18
        sta     $4301
@54e3:  ldx     $3b
        stx     $2d
        ldy     #2      ; copy 2 tiles
@54ea:  stz     hMDMAEN
        ldx     $2d
        stx     hVMADDL
        ldx     $2a
        stx     $4302
        lda     $2c
        sta     $4304
        ldx     #$0040
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longac
        lda     $2d
        adc     #$0100
        sta     $2d
        lda     $2a
        clc
        adc     #$0040
        sta     $2a
        shorta0
        adc     $2c
        sta     $2c
        dey
        bne     @54ea
        longac
        lda     $3b
        adc     #$0020
        sta     $3b
        shorta0
        dec     $1b
        bne     @54e3
        rts

; 32x32 graphics
@5533:  lda     #$41
        sta     $4300
        lda     #$80
        sta     hVMAINC
        lda     #$18
        sta     $4301
@5542:  ldx     $3b
        stx     $2d
        ldy     #4                      ; copy 4 tiles
@5549:  stz     hMDMAEN
        ldx     $2d
        stx     hVMADDL
        ldx     $2a
        stx     $4302
        lda     $2c
        sta     $4304
        ldx     #$0080      ; $80 bytes each
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        longac
        lda     $2d
        adc     #$0100
        sta     $2d
        lda     $2a
        clc
        adc     #$0080
        sta     $2a
        shorta0
        adc     $2c
        sta     $2c
        dey
        bne     @5549
        longac
        lda     $3b
        adc     #$0040
        sta     $3b
        shorta0
        dec     $1b
        bne     @5542
        rts

; ------------------------------------------------------------------------------

; [ add object to animation queue ]

; y = pointer to object data

StartObjAnim:
@5592:  ldx     $00
        longa
@5596:  lda     $10f7,x     ; object animation queue
        cmp     #$07b0
        beq     @55a5       ; look for the next available slot
        inx2
        cpx     #$002e
        bne     @5596
@55a5:  tya
        sta     $10f7,x     ; add object to queue
        shorta0
        txa
        sta     $088f,y     ; pointer to animation queue
        rts

; ------------------------------------------------------------------------------

; [ remove object from animation queue ]

; y = pointer to object data

StopObjAnim:
@55b1:  lda     $088f,y     ; pointer to animation queue
        tax
        longa
        lda     #$07b0
        sta     $10f7,x     ; no object
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init object animation ]

InitObjAnim:
@55c1:  ldy     $00
        tyx
@55c4:  lda     $0867,y
        and     #$40
        beq     @55df
        longa
        tya
        sta     $10f7,x
        shorta0
        txa
        sta     $088f,y
        inx2
        cpx     #$0030
        beq     @55ee
@55df:  longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$07b0
        bne     @55c4
@55ee:  rts

; ------------------------------------------------------------------------------

; [ clear object animation queue ]

ResetObjAnim:
@55ef:  longa
        stz     a:$0048       ; clear animation queue pointer
        stz     a:$0049
        ldx     $00
        lda     #$07b0
@55fc:  sta     $10f7,x     ; clear animation queue
        inx2
        cpx     #$0030
        bne     @55fc
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init object graphics ]

InitObjGfx:
@560a:  jsr     ClearObjMap
        jsr     ClearSpriteGfx
        jsr     TfrVehicleGfx
        jsr     ResetObjAnim
        rts

; ------------------------------------------------------------------------------

; [ update object sprite priority ]

UpdateSpritePriority:
@5617:  lda     $0881,y     ; lower sprite always shown behind priority 1 bg
        and     #$cf
        ora     #$20
        sta     $0881,y
        ldx     $087a,y     ; pointer to map data
        lda     $7f0000,x   ; bg1 tile
        tax
        lda     $7e7600,x   ; tile z-level properties
        and     #$07
        sta     $0888,y     ; set object z-level
        cmp     #$01
        beq     @5649       ; branch if lower z-level
        cmp     #$02
        beq     @5654       ; branch if upper z-level
        cmp     #$03
        beq     @565f       ; branch if transition tile
        lda     $0880,y     ; upper sprite shown in front of priority 1 bg
        and     #$cf
        ora     #$30
        sta     $0880,y
        rts
@5649:  lda     $0880,y     ; upper sprite shown behind priority 1 bg
        and     #$cf
        ora     #$20
        sta     $0880,y
        rts
@5654:  lda     $0880,y     ; upper sprite shown behind priority 1 bg
        and     #$cf
        ora     #$20
        sta     $0880,y
        rts
@565f:  lda     $0880,y     ; upper sprite shown behind priority 1 bg
        and     #$cf
        ora     #$20
        sta     $0880,y
        rts

; ------------------------------------------------------------------------------

; [ clear object map data ]

ClearObjMap:
@566a:  ldx     #$2000      ; clear $7e2000-$7e6000
        stx     hWMADDL
        stz     hWMADDH
        ldx     #$4000
        lda     #$ff
@5678:  sta     hWMDATA
        dex
        bne     @5678
        rts

; ------------------------------------------------------------------------------

; [ copy vehicle graphics to vram ]

TfrVehicleGfx:
@567f:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$7200                  ; vram destination = $7200
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #.loword(MapVehicleGfx) ; source address
        stx     $4302
        lda     #^MapVehicleGfx
        sta     $4304
        sta     $4307
        ldx     #$1c00                  ; size = $1c00
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ clear sprite graphics in vram ]

ClearSpriteGfx:
@56b1:  stz     a:$0081
        lda     #$80
        sta     hVMAINC
        ldx     #$6000      ; vram destination = $6000 (sprite graphics)
        stx     hVMADDL
        lda     #$09        ; fixed dma source address
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$0081      ; source address = $81 (dp)
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$2000      ; size = $2000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init sprite high data ]

InitSpriteMSB:
@56e3:  lda     #$7e
        pha
        plb
        ldy     $00
        tdc
@56ea:  ldx     #$0010
@56ed:  sta     $7800,y     ; sprite high data pointers
        iny
        dex
        bne     @56ed
        inc
        cpy     #$0100
        bne     @56ea
        ldy     $00
@56fc:  ldx     $00
@56fe:  lda     f:SpriteMSBAndTbl,x   ; sprite high data inverse bit masks
        sta     $7900,y
        lda     f:SpriteMSBOrTbl,x   ; sprite high data bit masks
        sta     $7a00,y
        iny
        inx
        cpx     #$0010
        bne     @56fe
        cpy     #$0100
        bne     @56fc
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; sprite high data inverse bit masks
SpriteMSBAndTbl:
@571c:  .byte   $fe,$fe,$fe,$fe,$fb,$fb,$fb,$fb,$ef,$ef,$ef,$ef,$bf,$bf,$bf,$bf

; sprite high data bit masks
SpriteMSBOrTbl:
@572c:  .byte   $01,$01,$01,$01,$04,$04,$04,$04,$10,$10,$10,$10,$40,$40,$40,$40

; ------------------------------------------------------------------------------

; [ update object positions ]

MoveObjs:
@573c:  stz     $dc         ; start with object 0
        lda     #$18        ; update 24 objects
        sta     $de
@5742:  lda     $dc         ; return if past the last active object
        cmp     $dd
        bcc     @574b
        jmp     @5801
@574b:  tax
        longa
        lda     $0803,x     ; get pointer to object data
        sta     $da
        tay
        lda     $0871,y     ; get horizontal movement speed
        bmi     @5770
        lda     $0869,y     ; moving right, add to horizontal position
        clc
        adc     $0871,y
        sta     $0869,y
        shorta
        tdc
        adc     $086b,y
        sta     $086b,y
        longa
        bra     @578c
@5770:  lda     $0871,y     ; moving left, subtract from horizontal position
        eor     $02
        sta     $1a
        lda     $0869,y
        clc
        sbc     $1a
        sta     $0869,y
        shorta
        lda     $086b,y
        sbc     $00
        sta     $086b,y
        longa
@578c:  lda     $0873,y     ; get vertical movement speed
        bmi     @57a6
        lda     $086c,y     ; moving down, add to vertical position
        clc
        adc     $0873,y
        sta     $086c,y
        shorta
        tdc
        adc     $086e,y
        sta     $086e,y
        bra     @57c0
@57a6:  lda     $0873,y     ; moving up, subtract from vertical position
        eor     $02
        sta     $1a
        lda     $086c,y
        clc
        sbc     $1a
        sta     $086c,y
        shorta
        lda     $086e,y
        sbc     $00
        sta     $086e,y
@57c0:  tdc                 ; get jump position
        shorta
        lda     $0887,y
        and     #$3f
        beq     @57d6       ; skip if not jumping
        lda     $0887,y     ; decrement jump counter
        tax
        dec
        sta     $0887,y
        lda     f:ObjJumpLowTbl,x   ; set y-offset
@57d6:  sta     $086f,y
        jsr     UpdateObjFrame
        lda     $0869,y     ; branch if object is between tiles
        bne     @5801
        lda     $086a,y
        and     #$0f
        bne     @5801
        lda     $086c,y
        bne     @5801
        lda     $086d,y
        and     #$0f
        bne     @5801
        tdc
        sta     $0871,y     ; clear movement speed if object reached the next tile
        sta     $0872,y
        sta     $0873,y
        sta     $0874,y
@5801:  inc     $dc         ; next object
        inc     $dc
        dec     $de
        beq     @580c
        jmp     @5742
@580c:  rts

; ------------------------------------------------------------------------------

; graphics positions for vehicle movement (chocobo/magitek only)
ObjVehicleTileTbl:
@580d:  .byte   $04,$05,$04,$03,$6e,$6f,$6e,$6f,$01,$02,$01,$00,$2e,$2f,$2e,$2f

; graphics positions for character movement
ObjMoveTileTbl:
@581d:  .byte   $04,$05,$04,$03,$47,$48,$47,$46,$01,$02,$01,$00,$07,$08,$07,$06

; graphics positions for standing still
ObjStopTileTbl:
@582d:  .byte   $04,$47,$01,$07

; graphics positions for special animation (animation offset)
ObjSpecialTileTbl:
@5831:  .byte   $00,$00,$32,$28,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [ update object graphics position ]

UpdateObjFrame:
@5839:  lda     $088c,y     ; check for special object animation
        and     #$20
        beq     @5843
        jmp     @58e4
@5843:  cpy     $0803       ; no special animation, check if this is the party object
        bne     @5855
        lda     $b9         ; tile properties
        cmp     #$ff
        beq     @5855
        and     #$40        ; force facing direction to be up if on a ladder tile
        beq     @5855
        tdc
        bra     @5858
@5855:  lda     $087f,y     ; facing direction
@5858:  asl2
        sta     $1a
        lda     $0868,y     ; vehicle
        and     #$60
        beq     @5866
        jmp     @58ad

; no vehicle
@5866:  lda     $0868,y
        and     #$01        ; return if walking animation is disabled
        beq     @58aa
        lda     $b8         ; tile properties, diagonal movement
        and     #$c0
        beq     @587d
        ldx     $0871,y
        beq     @588a
        ldx     $0873,y
        bne     @5897
@587d:  ldx     $0871,y     ; use horizontal direction to get frame
        beq     @588a
        lda     $086a,y
        lsr3
        bra     @589d
@588a:  ldx     $0873,y     ; use vertical direction
        beq     @58aa
        lda     $086d,y
        lsr3
        bra     @589d
@5897:  lda     $46         ; diagonal, use vblank counter, but only divide by 4 (faster steps)
        lsr2
        bra     @589d
@589d:  and     #$03        ; combine frame and facing direction
        clc
        adc     $1a
        tax
        lda     f:ObjMoveTileTbl,x   ; get graphics position
        sta     $0877,y
@58aa:  jmp     @5937

; chocobo or magitek
@58ad:  cmp     #$60
        beq     @58d8
        ldx     $0871,y
        beq     @58be
        lda     $086a,y     ; horizontal movement
        lsr3
        bra     @58c9
@58be:  ldx     $0873,y
        beq     @58c9
        lda     $086d,y     ; vertical movement
        lsr3
@58c9:  and     #$03        ; combine frame and facing direction
        clc
        adc     $1a
        tax
        lda     f:ObjVehicleTileTbl,x   ; get graphics position
        sta     $0877,y
        bra     @5937

; raft
@58d8:  lda     $1a
        tax
        lda     f:ObjMoveTileTbl,x
        sta     $0877,y
        bra     @5937

; special animation
@58e4:  lda     $0868,y     ; special animation speed (this will always be zero for special npc graphics)
        and     #$60
        lsr5
        tax
        lda     $45         ; frame counter
        lsr                 ; 0: update every 4 frames
        lsr                 ; 1: update every 8 frames
@58f3:  cpx     #$0000      ; 2: update every 16 frames
        beq     @58fc       ; 3: update every 32 frames
        lsr
        dex
        bra     @58f3
@58fc:  tax
        lda     $088c,y     ; number of animated frames
        and     #$18
        bne     @5908
        stz     $1b         ; 0: one frame
        bra     @5927
@5908:  cmp     #$08
        bne     @5917
        txa
        and     #$01
        beq     @5913
        lda     #$40
@5913:  sta     $1b         ; 1: one frame, flips back and forth horizontally
        bra     @5927
@5917:  cmp     #$10
        bne     @5922
        txa
        and     #$01
        sta     $1b         ; 2: two frames
        bra     @5927
@5922:  txa
        and     #$03
        sta     $1b         ; 3: 4 frames
@5927:  lda     $088c,y     ; graphic position offset
        and     #$07
        tax
        lda     f:ObjSpecialTileTbl,x
        clc
        adc     $1b
        sta     $0877,y     ; set next graphic position
@5937:  rts

; ------------------------------------------------------------------------------

; [ update party sprite data ]

FixPlayerSpritePriority:
@5938:  ldy     $0803       ; party object
        lda     $0868,y     ; vehicle
        and     #$60
        bne     @599e       ; branch if in a vehicle
        lda     $0867,y
        bpl     @599e       ; branch if not visible
        longa
        lda     $b4
        cmp     #$00f8
        bne     @5973       ; branch if not normal priority

; party is normal priority
        lda     $03dc       ; copy party object's top sprite data to party sprite data (normal priority)
        sta     $03f8
        lda     $03de
        sta     $03fa
        lda     $049c       ; copy party object's top sprite data to party sprite data (low priority)
        sta     $04bc
        lda     $049e
        sta     $04be
        lda     #$efef      ; hide low priority top sprite and normal priority bottom sprite
        sta     $04b8
        sta     $03fc
        bra     @5994

; party is low priority
@5973:  lda     $03dc       ; copy party object's top sprite data to party sprite data (low priority)
        sta     $04b8
        lda     $03de
        sta     $04ba
        lda     $049c       ; copy party object's bottom sprite data to party sprite data (low priority)
        sta     $04bc
        lda     $049e
        sta     $04be
        lda     #$efef
        sta     $03f8       ; hide normal priority party sprites
        sta     $03fc
@5994:  sta     $03dc       ; hide normal priority object sprites for party
        sta     $049c
        shorta0
        rts
@599e:  lda     #$ef
        sta     $04b9       ; hide low priority party sprites
        sta     $04bd
        sta     $03f9       ; hide normal priority party sprites
        sta     $03fd
        rts

; ------------------------------------------------------------------------------

; y-offsets for objects jumping (low)
ObjJumpLowTbl:
@59ad:  .byte   $02,$04,$06,$08,$09,$0a,$0b,$0b,$0b,$0b,$0a,$09,$08,$06,$04,$02
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; y-offsets for objects jumping (high)
ObjJumpHighTbl:
@59ed:  .byte   $05,$09,$0e,$11,$15,$18,$1b,$1e,$20,$22,$24,$26,$27,$28,$29,$29
        .byte   $29,$29,$28,$27,$26,$24,$22,$20,$1e,$1b,$18,$15,$11,$0e,$09,$05
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [ update object sprite data ]

DrawObjSprites:

@hDP := hWMDATA & $ff00

@5a2d:  ldx     #@hDP
        phx
        pld
        ldx     #$0300      ; clear $0300-$0520
        stx     <hWMADDL
        stz     <hWMADDH
        ldy     #$0020
        lda     #$ef
@5a3e:
.repeat 16
        sta     <hWMDATA
.endrep
        dey
        bne     @5a3e
        ldx     #$0500
        stx     <hWMADDL
        stz     <hWMADDH
.repeat 32
        stz     <hWMDATA
.endrep
        ldx     #$0000
        phx
        pld
        lda     #$7e
        pha
        plb
        lda     #6          ; update graphics for 6 sprites per frame
        sta     $de
        lda     $47         ; get first sprite to update this frame
        and     #$03
        tax
        lda     f:FirstObjTbl1,x
        sta     $dc
@5ac0:  lda     $dc
        tax
        ldy     $10f7,x     ; pointer to object data
        cpy     #$07b0
        beq     @5ad1       ; branch if empty
        lda     $0877,y
        sta     $0876,y     ; set current graphic position
@5ad1:  inc     $dc         ; next object
        inc     $dc
        dec     $de
        bne     @5ac0
        ldy     #$00a0      ; normal priority sprite data pointer
        sty     $d4
        ldy     #$0020      ; low and high priority sprite data pointer
        sty     $d6
        sty     $d8
        lda     #$18        ; update all 24 objects every frame
        sta     $de
        stz     $dc         ; current object

; start of object loop
_5aeb:  lda     $dc
        cmp     $dd         ; branch if less than total number of active objects
        bcc     @5af4
        jmp     DrawNextObj
@5af4:  tax
        lda     $0803,x     ; pointer to object data
        sta     $da
        lda     $0804,x
        sta     $db
        ldy     $da
        lda     $0867,y     ; skip if object is not visible
        bmi     @5b09
        jmp     DrawNextObj
@5b09:  lda     $0868,y     ; vehicle
        and     #$e0
        cmp     #$80
        bne     @5b15       ; branch if not special graphics
        jmp     DrawObjSpecial
@5b15:  lda     $088c,y     ; branch if object animation is enabled
        and     #$20
        bne     DrawObjNoVehicle
        lda     $0868,y     ; branch if not in a vehicle
        and     #$60
        beq     DrawObjNoVehicle
        cmp     #$20
        bne     @5b2a
        jmp     DrawChoco
@5b2a:  cmp     #$40
        bne     @5b31
        jmp     DrawMagitek
@5b31:  jmp     DrawRaft

; next object
DrawNextObj:
@5b34:  shorta0
        inc     $dc
        inc     $dc
        dec     $de
        beq     @5b42       ; branch if last object
        jmp     _5aeb
@5b42:  jsr     FixPlayerSpritePriority
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; unused
@5b49:  .byte   $fe,$fb,$ef,$bf
        .byte   $01,$04,$10,$40

; unused
@5b51:  .word   $0000,$00f6,$01ec,$02e2,$03d8

; object sprite graphics locations in vram
ObjSpriteVRAMTbl:
@5b5b:  .word   $0000,$0004,$0008,$000c
        .word   $0020,$0024,$0028,$002c
        .word   $0040,$0044,$0048,$004c
        .word   $0060,$0064,$0068,$006c
        .word   $0080,$0084,$0088,$008c
        .word   $00a0,$00a4,$00a8,$00ac

; ------------------------------------------------------------------------------

; [ update object sprite data (no vehicle) ]

DrawObjNoVehicle:
@5b8b:  lda     $087c,y                 ; branch if object scrolls with bg2
        bmi     @5bc0

; object scrolls with bg1
        longac
        lda     $086d,y                 ; y position
        sbc     $60                     ; bg1 vertical scroll position
        sec
        sbc     $7f                     ; vertical offset for shake screen
        sec
        sbc     $086f,y                 ; y shift for jumping
        sta     $24                     ; +$24 = y position on screen for bottom sprite
        sec
        sbc     #$0010
        sta     $22                     ; +$22 = y position on screen for top sprite
        clc
        adc     #$0020
        sta     $26                     ; +$26 = y position on screen for tile below bottom sprite
        lda     $086a,y                 ; x position
        sec
        sbc     $5c                     ; bg1 horizontal scroll position
        clc
        adc     #$0008                  ; add 8
        sta     $1e                     ; +$1e = x position on screen
        clc
        adc     #$0008                  ; add 8
        shorta
        bra     @5bee

; object scrolls with bg2
@5bc0:  longac
        lda     $086d,y
        sbc     $68
        sec
        sbc     $7f
        sec
        sbc     $086f,y
        sta     $24
        sec
        sbc     #$0010
        sta     $22
        clc
        adc     #$0020
        sta     $26
        lda     $086a,y
        sec
        sbc     $64
        clc
        adc     #$0008
        sta     $1e
        clc
        adc     #$0008
        shorta
@5bee:  xba                 ; return if sprite is off-screen to the right
        beq     @5bf4
        jmp     DrawNextObj
@5bf4:  lda     $27
        beq     @5bfb       ; return if sprite is off-screen to the bottom
        jmp     DrawNextObj
@5bfb:  tdc
        lda     $0876,y     ; graphics position
        tax
        lda     f:TopSpriteHFlip,x   ; horizontal flip flag (upper sprite)
        ora     $0880,y
        sta     $1b
        lda     f:BtmSpriteHFlip,x   ; horizontal flip flag (lower sprite)
        ora     $0881,y
        sta     $1d
        lda     $088f,y     ; pointer to animation queue
        tax
        lda     f:ObjSpriteVRAMTbl,x   ; object sprite graphics location in vram
        sta     $1a         ; $1a = upper tile
        inc2
        sta     $1c         ; $1c = lower tile
        lda     $088c,y     ; sprite order priority
        and     #$c0
        beq     @5c31       ; branch if normal priority
        cmp     #$40
        bne     @5c2e
        jmp     @5c93       ; jump if high priority
@5c2e:  jmp     @5cf5       ; jump if low priority

; normal priority
@5c31:  longa
        lda     $d4         ; decrement normal priority sprite data pointer
        sec
        sbc     #4
        sta     $d4
        tay
        lda     $1a
        sta     $0342,y     ; set sprite data
        lda     $1c
        sta     $0402,y
        shorta0
        lda     $1e
        sta     $0340,y     ; set x position
        sta     $0400,y
        lda     $22
        sta     $0341,y     ; set y position
        lda     $24
        sta     $0401,y
        lda     $7800,y     ; get pointer to high sprite data
        tax
        lda     $1f         ; branch if x position is > 255
        lsr
        bcs     @5c78
        lda     $0504,x     ; clear high bit of x position
        and     $7900,y
        sta     $0504,x
        lda     $0510,x
        and     $7900,y
        sta     $0510,x
        bra     @5c90
@5c78:  lda     $0504,x     ; set high bit of x position
        and     $7900,y
        ora     $7a00,y
        sta     $0504,x
        lda     $0510,x
        and     $7900,y
        ora     $7a00,y
        sta     $0510,x
@5c90:  jmp     DrawNextObj

; high priority
@5c93:  longa
        lda     $d6
        sec
        sbc     #4
        sta     $d6
        tay
        lda     $1a
        sta     $0302,y
        lda     $1c
        sta     $0322,y
        shorta0
        lda     $1e
        sta     $0300,y
        sta     $0320,y
        lda     $22
        sta     $0301,y
        lda     $24
        sta     $0321,y
        lda     $7800,y
        tax
        lda     $1f
        lsr
        bcs     @5cda
        lda     $0500,x
        and     $7900,y
        sta     $0500,x
        lda     $0502,x
        and     $7900,y
        sta     $0502,x
        bra     @5cf2
@5cda:  lda     $0500,x
        and     $7900,y
        ora     $7a00,y
        sta     $0500,x
        lda     $0502,x
        and     $7900,y
        ora     $7a00,y
        sta     $0502,x
@5cf2:  jmp     DrawNextObj

; low priority
@5cf5:  longa
        lda     $d8
        sec
        sbc     #4
        sta     $d8
        tay
        lda     $1a
        sta     $04c2,y
        lda     $1c
        sta     $04e2,y
        shorta0
        lda     $1e
        sta     $04c0,y
        sta     $04e0,y
        lda     $22
        sta     $04c1,y
        lda     $24
        sta     $04e1,y
        lda     $7800,y
        tax
        lda     $1f
        lsr
        bcs     @5d3c
        lda     $051c,x
        and     $7900,y
        sta     $051c,x
        lda     $051e,x
        and     $7900,y
        sta     $051e,x
        bra     @5d54
@5d3c:  lda     $051c,x
        and     $7900,y
        ora     $7a00,y
        sta     $051c,x
        lda     $051e,x
        and     $7900,y
        ora     $7a00,y
        sta     $051e,x
@5d54:  jmp     DrawNextObj

; ------------------------------------------------------------------------------

; [ update object sprite data (magitek) ]

; uses 3 top and 3 bottom sprites

DrawMagitek:
@5d57:  lda     $088f,y     ; pointer to animation queue
        tax
        lda     f:ObjSpriteVRAMTbl,x   ; sprite vram location (rider)
        sta     $1a
        longa
        lda     $086a,y     ; x-position
        sec
        sbc     $5c         ; bg1 h-scroll
        sta     $1e         ; $1e = left half x-position
        clc
        adc     #$0010
        sta     $20         ; $20 = right half x-position
        lda     $086d,y     ; y-position
        clc
        sbc     $60         ; bg1 v-scroll
        sec
        sbc     $7f         ; vertical offset for shake screen
        sec
        sbc     #$0008
        sta     $26
        sbc     #$0010
        sta     $24
        sbc     #$0006
        sta     $22
        clc
        adc     #$001e
        shorta
        xba
        beq     @5d96       ; branch if sprite is on screen
        jmp     DrawNextObj
@5d96:  tdc
        ldy     $1e
        cpy     #$0120
        bcc     @5da6
        cpy     #$ffe0
        bcs     @5da6
        jmp     DrawNextObj
@5da6:  longa
        lda     $d4         ; pointer to normal priority sprite
        sec
        sbc     #$000c      ; use 3 sprites (3 top and 3 bottom)
        sta     $d4
        shorta0
        ldy     $d4
        longa
        lda     $1e         ; left half + 8 to get rider x-position
        clc
        adc     #$0008
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y     ; x-position
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $1e         ; left half of vehicle (top)
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y     ; y-position
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $20         ; right half of vehicle (top)
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        ldy     $d4
        longa
        lda     $1e
        sta     $2a         ; left half of vehicle (bottom)
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        longa
        lda     $20
        sta     $2a         ; right half of vehicle (bottom)
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        ldy     $d4
        lda     $24
        sta     $0345,y
        sta     $0349,y
        lda     $26
        sta     $0401,y
        sta     $0405,y
        ldy     $da         ; pointer to current object data
        lda     $087f,y     ; facing direction
        cmp     #$01
        beq     @5e40       ; branch if facing right
        lda     $0881,y
        and     #$0e
        ora     #$20
        bra     @5e47
@5e40:  lda     $0881,y
        and     #$0e
        ora     #$60        ; flip horizontally
@5e47:  ldy     $d4
        sta     $0343,y
        lda     $1a
        sta     $0342,y
        ldy     $da
        lda     $087f,y
        asl3
        sta     $1a
        ldx     $0871,y     ; horizontal movement speed
        beq     @5e65       ; branch if not moving horizontally
        lda     $086a,y     ; x-position
        bra     @5e68
@5e65:  lda     $086d,y     ; y-position
@5e68:  lsr2
        sta     $1b
        and     #$06
        clc
        adc     $1a
        tax
        ldy     $d4
        lda     $1b
        lsr
        and     #$01
        clc
        adc     $22
        sta     $0341,y
        longa
        lda     $c05eb6,x
        sta     $0346,y
        lda     $c05ed6,x
        sta     $034a,y
        lda     $c05ef6,x
        sta     $0402,y
        lda     $c05f16,x
        sta     $0406,y
        shorta0
        lda     #$ef
        sta     $0409,y
        ldy     $da
        lda     $0868,y
        bmi     @5eb3       ; branch if rider is shown
        ldy     $d4
        lda     #$ef
        sta     $0341,y     ; hide rider sprite
@5eb3:  jmp     DrawNextObj

; ------------------------------------------------------------------------------

; magitek tile formation (top left)
MagitekTopLeftTiles:
@5eb6:  .word   $2fac, $2fc0, $2fac, $2fc4
        .word   $6fca, $6fe2, $6fca, $6fea
        .word   $2fa0, $2fa4, $2fa0, $2fa8
        .word   $2fc8, $2fe0, $2fc8, $2fe8

; magitek tile formation (top right)
MagitekTopRightTiles:
@5ed6:  .word   $6fac, $6fc4, $6fac, $6fc0
        .word   $6fc8, $6fe0, $6fc8, $6fe8
        .word   $6fa0, $6fa8, $6fa0, $6fa4
        .word   $2fca, $2fe2, $2fca, $2fea

; magitek tile formation (bottom left)
MagitekBtmLeftTiles:
@5ef6:  .word   $2fae, $2fc2, $2fae, $2fc6
        .word   $6fce, $6fe6, $6fce, $6fee
        .word   $2fa2, $2fa6, $2fa2, $2faa
        .word   $2fcc, $2fe4, $2fcc, $2fec

; magitek tile formation (bottom right)
MagitekBtmRightTiles:
@5f16:  .word   $6fae, $6fc6, $6fae, $6fc2
        .word   $6fcc, $6fe4, $6fcc, $6fec
        .word   $6fa2, $6faa, $6fa2, $6fa6
        .word   $2fce, $2fe6, $2fce, $2fee

; ------------------------------------------------------------------------------

; [ update object sprite data (raft) ]

; uses 3 top and 3 bottom sprites

DrawRaft:
@5f36:  lda     $088f,y
        tax
        lda     f:ObjSpriteVRAMTbl,x
        sta     $1a
        longa
        lda     $086a,y
        sec
        sbc     $5c
        sta     $1e
        clc
        adc     #$0010
        sta     $20
        lda     $086d,y
        clc
        sbc     $60
        sec
        sbc     $7f
        sec
        sbc     #$0008
        sta     $26
        sbc     #$0010
        sta     $24
        sbc     #$0008
        sta     $22
        clc
        adc     #$001e
        shorta
        xba
        beq     @5f75
        jmp     DrawNextObj
@5f75:  tdc
        ldy     $1e
        cpy     #$0120
        bcc     @5f85
        cpy     #$ffe0
        bcs     @5f85
        jmp     DrawNextObj
@5f85:  longa
        lda     $d4
        sec
        sbc     #$000c
        sta     $d4
        shorta0
        ldy     $d4
        longa
        lda     $1e
        clc
        adc     #$0008
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $1e
        clc
        adc     #$0008
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $1e
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        ldy     $d4
        longa
        lda     $20
        sta     $2a
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        longa
        lda     $1e
        sta     $2a
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        longa
        lda     $20
        sta     $2a
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        ldy     $d4
        lda     $24
        sta     $0349,y
        sta     $0401,y
        lda     $26
        sta     $0405,y
        sta     $0409,y
        ldy     $da
        lda     $087f,y
        cmp     #$01
        beq     @6038
        lda     $0881,y
        and     #$0e
        ora     #$20
        bra     @603f
@6038:  lda     $0881,y
        and     #$0e
        ora     #$60
@603f:  ldy     $d4
        sta     $0343,y
        sta     $0347,y
        lda     $1a
        sta     $0342,y
        inc2
        sta     $0346,y
        ldy     $da
        lda     $087f,y
        asl
        tax
        ldy     $d4
        lda     $22
        sta     $0341,y
        clc
        adc     #$10
        sta     $0345,y
        longa
        lda     $c0609a,x
        sta     $034a,y
        lda     $c060a2,x
        sta     $0402,y
        lda     $c060aa,x
        sta     $0406,y
        lda     $c060b2,x
        sta     $040a,y
        shorta0
        ldy     $da
        lda     $0868,y
        bmi     @6097
        ldy     $d4
        lda     #$ef
        sta     $0341,y
        sta     $0345,y
@6097:  jmp     DrawNextObj

; ------------------------------------------------------------------------------

RaftTiles:
@609a:  .word   $2f20, $2f28, $2f20, $2f28
        .word   $2f24, $2f2c, $2f24, $2f2c
        .word   $2f22, $2f2a, $2f22, $2f2a
        .word   $2f26, $2f2e, $2f26, $2f2e

; ------------------------------------------------------------------------------

; [ update object sprite data (chocobo) ]

; uses 3 top and 3 bottom sprites

DrawChoco:
@60ba:  lda     $088f,y
        tax
        lda     f:ObjSpriteVRAMTbl,x
        sta     $1a
        inc2
        sta     $1c
        ldx     $0871,y
        beq     @60d2
        lda     $086a,y
        bra     @60d5
@60d2:  lda     $086d,y
@60d5:  lsr2
        and     #$06
        tax
        longa
        lda     $086a,y
        sec
        sbc     $5c
        sta     $20
        clc
        adc     #$0008
        sta     $1e
        lda     $086d,y
        clc
        sbc     $60
        sec
        sbc     $7f
        sec
        sbc     #$0008
        sta     $26
        sbc     #$0010
        sta     $24
        sbc     #$0004
        sta     $22
        clc
        adc     #$001c
        shorta
        xba
        beq     @610f
        jmp     DrawNextObj
@610f:  tdc
        ldy     $1e
        cpy     #$0120
        bcc     @611f
        cpy     #$ffe0
        bcs     @611f
        jmp     DrawNextObj
@611f:  longa
        lda     $d4
        sec
        sbc     #$000c
        sta     $d4
        shorta0
        ldy     $da
        lda     $087f,y     ; facing direction
        beq     DrawChocoUp
        dec
        bne     @6139
        jmp     DrawChocoRight
@6139:  dec
        bne     @613f
        jmp     DrawChocoDown
@613f:  jmp     DrawChocoLeft

; chocobo facing up
DrawChocoUp:
@6142:  ldy     $1e
        sty     $2a
        ldy     $d4
        jsr     SetBtmSpriteMSB
        iny4
        jsr     SetTopSpriteMSB
        iny4
        jsr     SetTopSpriteMSB
        ldy     $d4
        longa
        lda     $1e
        clc
        adc     f:ChocoUpTailX,x
        sta     $2a
        shorta
        sta     $0340,y
        tdc
        jsr     SetTopSpriteMSB
        lda     $24
        clc
        adc     f:ChocoUpTailY,x
        sta     $0341,y
        longa
        lda     f:ChocoUpTailTile,x
        sta     $0342,y
        lda     f:ChocoUpBodyTile1,x
        sta     $034a,y
        lda     f:ChocoUpBodyTile2,x
        sta     $0402,y
        shorta0
        ldy     $da
        lda     $0881,y
        and     #$0e
        ora     $c06201,x
        ldy     $d4
        sta     $0347,y
        lda     $1a
        sta     $0346,y
        lda     $1e
        sta     $0344,y
        sta     $0348,y
        sta     $0400,y
        lda     $22
        clc
        adc     f:ChocoUpBodyX,x
        sta     $0345,y
        lda     $24
        sta     $0349,y
        lda     $26
        sta     $0401,y
        lda     #$ef
        sta     $0405,y
        sta     $0409,y
        ldy     $da
        lda     $0868,y
        bmi     @61dd
        ldy     $d4
        lda     #$ef
        sta     $0345,y
@61dd:  jmp     _64ca

; ------------------------------------------------------------------------------

ChocoUpTailX:
@61e0:  .word   $0000, $0001, $0000, $ffff ; tail x-offset

ChocoUpTailY:
@61e8:  .word   $0009, $000a, $0009, $000a ; tail y-offset

ChocoUpBodyX:
@61f0:  .word   $0000, $0001, $0000, $0001 ; body y-offset

ChocoUpTailTile:
@61f8:  .word   $2f4a, $6f4a, $2f4a, $6f4a ; tail tile

ChocoUpTileFlags:
@6200:  .word   $2000, $2000, $2000, $2000 ; unused

ChocoUpBodyTile1:
@6208:  .word   $2f4c, $2f60, $2f4c, $6f60 ; body tile (top)

ChocoUpBodyTile2:
@6210:  .word   $2f4e, $2f62, $2f4e, $6f62 ; body tile (bottom)

; ------------------------------------------------------------------------------

; chocobo facing down
DrawChocoDown:
@6218:  ldy     $1e
        sty     $2a
        ldy     $d4
        jsr     SetTopSpriteMSB
        jsr     SetBtmSpriteMSB
        iny4
        jsr     SetTopSpriteMSB
        iny4
        jsr     SetTopSpriteMSB
        ldy     $d4
        longa
        lda     $1e
        clc
        adc     $c062b9,x
        sta     $2a
        shorta
        sta     $0340,y
        tdc
        jsr     SetTopSpriteMSB
        lda     $24
        clc
        adc     $c062c1,x
        sta     $0341,y
        longa
        lda     $c062d1,x
        sta     $0342,y
        lda     $c062e1,x
        sta     $034a,y
        lda     $c062e9,x
        sta     $0402,y
        shorta0
        ldy     $da
        lda     $0881,y
        and     #$0e
        ora     $c062da,x
        ldy     $d4
        sta     $0347,y
        lda     $1a
        sta     $0346,y
        lda     $1e
        sta     $0344,y
        sta     $0348,y
        sta     $0400,y
        lda     $22
        clc
        adc     $c062c9,x
        sta     $0345,y
        lda     $24
        sta     $0349,y
        lda     $26
        sta     $0401,y
        lda     #$ef
        sta     $0405,y
        sta     $0409,y
        ldy     $da
        lda     $0868,y
        bmi     @62b6
        ldy     $d4
        lda     #$ef
        sta     $0345,y
@62b6:  jmp     _64ca

; ------------------------------------------------------------------------------

@62b9:  .word   $0000, $0001, $0000, $ffff ; head x-offset
        .word   $0007, $0008, $0007, $0008 ; head y-offset
        .word   $ffff, $0001, $ffff, $0001 ; body y-offset
        .word   $2f40, $2f40, $2f40, $2f40 ; head tile
        .word   $2000, $2000, $2000, $2000 ; unused
        .word   $2f42, $2f46, $2f42, $6f46 ; body tile (top)
        .word   $2f44, $2f48, $2f44, $6f48 ; body tile (bottom)

; ------------------------------------------------------------------------------

; chocobo facing right
DrawChocoRight:
@62f1:  ldy     $d4
        longa
        lda     $1e
        sec
        sbc     #$0003
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $20
        clc
        adc     #$0010
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        ldy     $d4
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        longa
        lda     $20
        sta     $2a
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        ldy     $d4
        lda     $22
        clc
        adc     $c063c5,x
        sta     $0341,y
        clc
        adc     #$10
        sta     $0345,y
        ldy     $da
        lda     $0881,y
        and     #$0e
        ora     #$60
        ldy     $d4
        sta     $0343,y
        sta     $0347,y
        lda     $1a
        sta     $0342,y
        lda     $1c
        sta     $0346,y
        lda     $24
        sta     $0349,y
        sta     $0409,y
        clc
        adc     #$10
        sta     $0401,y
        sta     $0405,y
        longa
        lda     $c063cd,x
        sta     $034a,y
        lda     $c063d5,x
        sta     $040a,y
        lda     $c063dd,x
        sta     $0402,y
        lda     $c063e5,x
        sta     $0406,y
        shorta0
        ldy     $da
        lda     $0868,y
        bmi     @63c2
        ldy     $d4
        lda     #$ef
        sta     $0341,y
        sta     $0345,y
@63c2:  jmp     _64ca

; ------------------------------------------------------------------------------

@63c5:  .word   $0000, $ffff, $0000, $ffff ; y-offset
        .word   $6f64, $6f6c, $6f64, $6f84
        .word   $6f68, $6f80, $6f68, $6f88
        .word   $6f66, $6f6e, $6f66, $6f86
        .word   $6f6a, $6f82, $6f6a, $6f8a

; ------------------------------------------------------------------------------

; chocobo facing left
DrawChocoLeft:
@63ed:  ldy     $d4
        longa
        lda     $1e
        clc
        adc     #$0003
        sta     $2a
        clc
        adc     #$0008
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $20
        clc
        adc     #$0010
        sta     $2a
        clc
        adc     #$0008
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        ldy     $d4
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        longa
        lda     $20
        sta     $2a
        clc
        adc     #$0008
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        ldy     $d4
        lda     $22
        clc
        adc     $c063c5,x
        sta     $0341,y
        clc
        adc     #$10
        sta     $0345,y
        ldy     $da
        lda     $0881,y
        and     #$0e
        ora     #$20
        ldy     $d4
        sta     $0343,y
        sta     $0347,y
        lda     $1a
        sta     $0342,y
        lda     $1c
        sta     $0346,y
        lda     $24
        sta     $0349,y
        sta     $0409,y
        clc
        adc     #$10
        sta     $0401,y
        sta     $0405,y
        longa
        lda     $c064d5,x
        sta     $034a,y
        lda     $c064cd,x
        sta     $040a,y
        lda     $c064e5,x
        sta     $0402,y
        lda     $c064dd,x
        sta     $0406,y
        shorta0
        ldy     $da
        lda     $0868,y
        bmi     _64ca
        ldy     $d4
        lda     #$ef
        sta     $0341,y
        sta     $0345,y
_64ca:  jmp     DrawNextObj

; ------------------------------------------------------------------------------

@64cd:  .word   $2f64, $2f6c, $2f64, $2f84
        .word   $2f68, $2f80, $2f68, $2f88
        .word   $2f66, $2f6e, $2f66, $2f86
        .word   $2f6a, $2f82, $2f6a, $2f8a

; ------------------------------------------------------------------------------

; unused ???
@64ed:  .word   $0000, $0010, $0020, $0030

; ------------------------------------------------------------------------------

; [ update object sprite data (special graphics) ]

DrawObjSpecial:
@64f5:  ldx     $00
        stx     $24
        stx     $20
        lda     $087c,y     ; check if object scrolls with bg2
        sta     $1a
        phy                 ; push object pointer so we can temporarily use a master object
        lda     $088b,y     ; branch if a master object is used
        and     #$02
        beq     @6530

; w/ master object - shift sprite right (tiles)
        lda     $088b,y
        and     #$01
        bne     @6519
        lda     $088a,y
        and     #$e0
        lsr
        sta     $20
        bra     @6521

; w/ master object - shift sprite down (tiles)
@6519:  lda     $088a,y
        and     #$e0
        lsr
        sta     $24
@6521:  lda     $088a,y     ; master object number
        and     #$1f
        clc
        adc     #$10        ; add $10 to get npc number
        asl
        tax
        ldy     $0799,x     ; get pointer to master object data
        bra     @654f

; shift sprite right (pixels * 2)
@6530:  lda     $088b,y
        and     #$01
        bne     @6544
        lda     $088a,y
        and     #$e0
        lsr4
        sta     $20
        bra     @654f

; shift sprite down (pixels * 2)
@6544:  lda     $088a,y
        and     #$e0
        lsr4
        sta     $24
@654f:  lda     $1a
        bmi     @6584       ; branch if object scrolls with bg2

; object scrolls with bg1
        longac
        lda     $086d,y     ; y position
        adc     $24         ; add add y offset
        clc
        sbc     $60         ; subtract vertical scroll position
        sec
        sbc     $7f         ; subtract shake screen offset
        sec
        sbc     $086f,y     ; subtract jump offset
        sec
        sbc     #$0008      ; subtract 8
        sta     $22         ; +$22 = top sprite y offset
        clc
        adc     #$0020
        sta     $26         ; +$26 = bottom sprite y offset
        lda     $086a,y     ; x position
        sec
        sbc     $5c         ; subtract horizontal scroll position
        clc
        adc     $20         ; add x offset
        clc
        adc     #$0008      ; add 8
        sta     $1e         ; +$1e = sprite x position
        shorta0
        bra     @65b3

; object scrolls with bg2
@6584:  longac
        lda     $086d,y
        adc     $24
        clc
        sbc     $68
        sec
        sbc     $7f
        sec
        sbc     $086f,y
        sec
        sbc     #$0008
        sta     $22
        clc
        adc     #$0020
        sta     $26
        lda     $086a,y
        sec
        sbc     $64
        clc
        adc     $20
        clc
        adc     #$0008
        sta     $1e
        shorta0
@65b3:  ply                 ; no longer using master object
        ldx     $1e
        cpx     #$ffe0      ; return if sprite is off-screen
        bcs     @65c3
        cpx     #$0100
        bcc     @65c3
        jmp     DrawNextObj
@65c3:  lda     $27
        beq     @65ca
        jmp     DrawNextObj
@65ca:  tdc
        lda     $0868,y     ; continuous animation flag -> horizontal flip ???
        and     #$01
        lsr
        ror2
        ora     #$01
        ora     $0880,y
        sta     $1b
        lda     $0868,y     ; animation speed (this will always be 0)
        and     #$60
        lsr5
        tax
        lda     $45         ; frame counter / 4
        lsr2
@65e9:  cpx     #$0000      ; divide by 2 (slower animation) for higher speed values
        beq     @65f2
        lsr
        dex
        bra     @65e9
@65f2:  sta     $1a         ; $1a = frame counter >> (2 + speed)
        lda     $088c,y     ;
        and     #$18
        lsr3
        tax
        lda     $1a
        and     f:ObjAnimFrameMaskTbl,x   ; number of frames mask
        asl
        sta     $1a         ; $1a = frames mask * 2
        lda     $087c,y     ; 32x32 sprite
        and     #$20
        beq     @660f
        asl     $1a
@660f:  lda     $0889,y     ; vram address
        asl
        clc
        adc     $1a
        sta     $1a
        tyx
        lda     $088c,y     ; sprite order
        and     #$c0
        beq     @662a       ; branch if normal
        cmp     #$40
        bne     @6627
        jmp     @667b       ; jump if high
@6627:  jmp     @66cc       ; jump if low

; normal sprite priority
@662a:  longa
        lda     $d4         ; use one sprite
        sec
        sbc     #$0004
        sta     $d4
        tay
        lda     $1a
        sta     $0342,y
        shorta0
        lda     $087c,x     ; branch if not a 32x32 sprite
        and     #$20
        beq     @6648
        lda     $7a00,y     ; sprite high data bit mask
        asl                 ; << 1 to get the large sprite flag
@6648:  sta     $1c
        lda     $1e
        sta     $0340,y     ; set x position
        lda     $22
        sta     $0341,y     ; set y position
        lda     $7800,y     ; pointer to high sprite data
        tax
        lda     $1f
        lsr
        bcs     @666a       ; branch if x > 255
        lda     $0504,x
        and     $7900,y     ; clear high x position msb
        ora     $1c         ; 32x32 flag
        sta     $0504,x
        bra     @6678
@666a:  lda     $0504,x
        and     $7900,y
        ora     $7a00,y     ; set high x position msb
        ora     $1c         ; 32x32 flag
        sta     $0504,x
@6678:  jmp     DrawNextObj

; high sprite priority
@667b:  longa
        lda     $d6         ; use one sprite
        sec
        sbc     #$0004
        sta     $d6
        tay
        lda     $1a
        sta     $0302,y
        shorta0
        lda     $087c,x
        and     #$20
        beq     @6699
        lda     $7a00,y
        asl
@6699:  sta     $1c
        lda     $1e
        sta     $0300,y
        lda     $22
        sta     $0301,y
        lda     $7800,y
        tax
        lda     $1f
        lsr
        bcs     @66bb
        lda     $0500,x
        and     $7900,y
        ora     $1c
        sta     $0500,x
        bra     @66c9
@66bb:  lda     $0500,x
        and     $7900,y
        ora     $7a00,y
        ora     $1c
        sta     $0500,x
@66c9:  jmp     DrawNextObj

; low sprite priority
@66cc:  longa
        lda     $d8         ; use one sprite
        sec
        sbc     #$0004
        sta     $d8
        tay
        lda     $1a
        sta     $04c2,y
        shorta0
        lda     $087c,x
        and     #$20
        beq     @66ea
        lda     $7a00,y
        asl
@66ea:  sta     $1c
        lda     $1e
        sta     $04c0,y
        lda     $22
        sta     $04c1,y
        lda     $7800,y
        tax
        lda     $1f
        lsr
        bcs     @670c
        lda     $051c,x
        and     $7900,y
        ora     $1c
        sta     $051c,x
        bra     @671a
@670c:  lda     $051c,x
        and     $7900,y
        ora     $7a00,y
        ora     $1c
        sta     $051c,x
@671a:  jmp     DrawNextObj

; ------------------------------------------------------------------------------

; bit masks for number of animation frames (animated frame type)
ObjAnimFrameMaskTbl:
@671d:  .byte   $00,$00,$01,$03

; ------------------------------------------------------------------------------

; [ set/clear sprite x position msb (top sprite) ]

; $2b = 0 (clear) or 1 (set)

SetTopSpriteMSB:
@6721:  pha
        phx
        phy
        lda     $2b
        lsr
        bcs     @6738
        lda     $7800,y
        tax
        lda     $0504,x
        and     $7900,y
        sta     $0504,x
        bra     @6748
@6738:  lda     $7800,y
        tax
        lda     $0504,x
        and     $7900,y
        ora     $7a00,y
        sta     $0504,x
@6748:  ply
        plx
        pla
        rts

; ------------------------------------------------------------------------------

; [ set/clear sprite x position msb (bottom sprite) ]

; $2b = 0 (clear) or 1 (set)

SetBtmSpriteMSB:
@674c:  pha
        phx
        phy
        lda     $2b
        lsr
        bcs     @6763
        lda     $7800,y
        tax
        lda     $0510,x
        and     $7900,y
        sta     $0510,x
        bra     @6773
@6763:  lda     $7800,y
        tax
        lda     $0510,x
        and     $7900,y
        ora     $7a00,y
        sta     $0510,x
@6773:  ply
        plx
        pla
        rts

; ------------------------------------------------------------------------------

; first object to update each frame
FirstObjTbl1:
@6777:  .byte   $00,$0c,$18,$24

; ------------------------------------------------------------------------------

; [ transfer object graphics to vram ]

; only six objects get updated per frame
; called during nmi, takes four frames to fully update
; called four times in a row when a map loads

TfrObjGfxSub:
@677b:  stz     hHDMAEN
        lda     #$41
        sta     $4300
        lda     #$80
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     $47
        and     #$03
        tax
        lda     f:FirstObjTbl1,x
        sta     $48
        stz     $49
        txa
        asl
        tax
        longa
        lda     $c0693c,x
        sta     $14
        lda     #$0006
        sta     $18
@67aa:  stz     hMDMAEN
        ldx     $48
        ldy     $10f7,x
        cpy     #$07b0
        bne     @67ba
        jmp     @6866
@67ba:  lda     $0879,y
        and     #$00ff
        asl
        tax
        lda     f:MapSpriteGfxPtrsLo,x
        sta     $0e
        lda     f:MapSpriteGfxPtrsHi,x
        sta     $10
        ldx     $14
        lda     $c06944,x
        sta     hVMADDL
        clc
        adc     #$0100
        sta     $16
        lda     $0876,y
        and     #$003f
        asl2
        sta     $12
        asl
        clc
        adc     $12
        tax
        ldy     #$0001
        lda     f:MapSpriteTileOffsets,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+2,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+8,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+10,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     $16
        sta     hVMADDL
        lda     f:MapSpriteTileOffsets+4,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+6,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
@6866:  inc     $14
        inc     $14
        inc     $48
        inc     $48
        dec     $18
        beq     @6875
        jmp     @67aa
@6875:  shorta0
        rts

; ------------------------------------------------------------------------------

; [ load character graphics (world map) ]

TfrObjGfxWorld:
@6879:  stz     hHDMAEN
        stx     hVMADDL
        longa
        and     #$003f
        asl2
        sta     $12
        asl
        clc
        adc     $12
        sta     $12
        lda     $11fb
        and     #$00ff
        asl
        tax
        lda     f:MapSpriteGfxPtrsLo,x
        sta     $0e
        lda     f:MapSpriteGfxPtrsHi,x
        sta     $10
        shorta0
        stz     hMDMAEN
        lda     #$41
        sta     $4300
        lda     #$80
        sta     hVMAINC
        lda     #$18
        sta     $4301
        longa
        ldx     $12
        ldy     #$0001
        lda     f:MapSpriteTileOffsets,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+2,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+4,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+6,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+8,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+10,x
        clc
        adc     $0e
        sta     $4302
        tdc
        adc     $10
        sta     $4304
        sty     hMDMAEN
        shorta0
        rts

; ------------------------------------------------------------------------------

@6934:  .word   $0000, $00f6, $01ec, $02e2
        .word   $0000, $000c, $0018, $0024

@6944:  .word   $6000, $6040, $6080, $60c0, $6200, $6240
        .word   $6280, $62c0, $6400, $6440, $6480, $64c0
        .word   $6600, $6640, $6680, $66c0, $6800, $6840
        .word   $6880, $68c0, $6a00, $6a40, $6a80, $6ac0

; ------------------------------------------------------------------------------

; [ init terra outline graphics (unused) ]

InitTerraOutline:
@6974:  ldx     $00
        txa
@6977:  sta     $7e6000,x
        inx
        cpx     #$6c00
        bne     @6977
        ldx     $00
        stx     $1e
        stx     $22
        ldx     #$6000
        stx     $36
        lda     #$7e
        sta     $38
        ldx     $1e
        lda     f:MapSpriteGfxPtrsLo,x
        sta     $2a
        inc
        sta     $2d
        clc
        adc     #$0f
        sta     $30
        inc
        sta     $33
        lda     $c0d0f3,x
        sta     $2b
        sta     $2e
        sta     $31
        sta     $34
        lda     f:MapSpriteGfxPtrsHi,x
        sta     $2c
        sta     $2f
        sta     $32
        sta     $35
        ldx     $00
        stx     $20
@69bf:  longa
        ldx     $20
        lda     $c0ce46,x
        sta     $24
        shorta0
        lda     #$08
        sta     $1a
@69d0:  ldy     $24
        lda     [$2d],y
        ora     [$30],y
        ora     [$33],y
        eor     $02
        and     [$2a],y
        iny2
        sty     $24
        ldy     $22
        sta     [$36],y
        iny2
        sty     $22
        dec     $1a
        bne     @69d0
        longac
        lda     $22
        adc     #$0010
        sta     $22
        shorta0
        ldx     $20
        inx2
        stx     $20
        cpx     #$006c
        bne     @69bf
        rts

; ------------------------------------------------------------------------------

; [ update timer sprite data ]

DrawTimer:
@6a04:  lda     $1188       ; return if timer is disabled
        and     #$40
        bne     @6a0c
        rts
@6a0c:  ldx     $1189       ; timer value
        stx     hWRDIVL
        lda     #60         ; divide by 60 to get seconds
        sta     hWRDIVB
        nop7
        ldx     hRDDIVL
        stx     hWRDIVL
        lda     #10         ; divide by 10 to get 10 seconds
        sta     hWRDIVB
        nop7
        lda     hRDMPYL
        sta     $1d         ; remainder is one's digit of seconds
        ldx     hRDDIVL
        stx     hWRDIVL
        lda     #6          ; divide by 6 to get minutes
        sta     hWRDIVB
        nop7
        lda     hRDMPYL
        sta     $1c         ; remainder is ten's digit of seconds
        ldx     hRDDIVL
        stx     hWRDIVL
        lda     #10         ; divide by 10 to get 10 minutes
        sta     hWRDIVB
        nop7
        lda     hRDMPYL
        sta     $1b         ; remainder is one's digit of minutes
        lda     hRDDIVL
        sta     $1a         ; result is ten's digit of minutes
        lda     #$cc        ; set sprite y coordinates
        sta     $030d
        sta     $0311
        sta     $0315
        sta     $0319
        sta     $031d
        lda     #$c8        ; set sprite x coordinates
        sta     $030c
        lda     #$d0
        sta     $0310
        lda     #$d8
        sta     $031c
        lda     #$e0
        sta     $0314
        lda     #$e8
        sta     $0318
        lda     #$31        ; set priority = 3, palette = 0, msb of graphics = 1
        sta     $030f
        sta     $0313
        sta     $0317
        sta     $031b
        sta     $031f
        lda     #$84        ; colon graphics
        sta     $031e
        lda     $1a         ; digit graphics
        tax
        lda     f:TimerTiles,x
        sta     $030e
        lda     $1b
        tax
        lda     f:TimerTiles,x
        sta     $0312
        lda     $1c
        tax
        lda     f:TimerTiles,x
        sta     $0316
        lda     $1d
        tax
        lda     f:TimerTiles,x
        sta     $031a
        rts

; ------------------------------------------------------------------------------

; timer graphics pointers (+$0100, vram)
TimerTiles:
@6ad1:  .byte   $60,$62,$64,$66,$68,$6a,$6c,$6e,$80,$82

; ------------------------------------------------------------------------------

; [ load timer graphics ]

LoadTimerGfx:
@6adb:  lda     $0521
        bmi     @6ae1
        rts
@6ae1:  lda     #$80
        sta     hVMAINC
        ldx     #$7600
        stx     hVMADDL
        ldx     $00
@6aee:  lda     $c48b00,x
        eor     $c48b01,x
        sta     hVMDATAL
        lda     $c48b01,x
        sta     hVMDATAH
        lda     $c48b02,x
        eor     $c48b03,x
        sta     hVMDATAL
        lda     $c48b03,x
        sta     hVMDATAH
        lda     $c48b04,x
        eor     $c48b05,x
        sta     hVMDATAL
        lda     $c48b05,x
        sta     hVMDATAH
        lda     $c48b06,x
        eor     $c48b07,x
        sta     hVMDATAL
        lda     $c48b07,x
        sta     hVMDATAH
        lda     $c48b08,x
        eor     $c48b09,x
        sta     hVMDATAL
        lda     $c48b09,x
        sta     hVMDATAH
        lda     $c48b0a,x
        eor     $c48b0b,x
        sta     hVMDATAL
        lda     $c48b0b,x
        sta     hVMDATAH
        lda     $c48b0c,x
        eor     $c48b0d,x
        sta     hVMDATAL
        lda     $c48b0d,x
        sta     hVMDATAH
        lda     $c48b0e,x
        eor     $c48b0f,x
        sta     hVMDATAL
        lda     $c48b0f,x
        sta     hVMDATAH
        ldy     #$0018
@6b81:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6b81
        longac
        txa
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        beq     @6b9c
        jmp     @6aee
@6b9c:  ldy     #$0100
@6b9f:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6b9f
@6ba8:  lda     $c48b00,x
        eor     $c48b01,x
        sta     hVMDATAL
        lda     $c48b01,x
        sta     hVMDATAH
        lda     $c48b02,x
        eor     $c48b03,x
        sta     hVMDATAL
        lda     $c48b03,x
        sta     hVMDATAH
        lda     $c48b04,x
        eor     $c48b05,x
        sta     hVMDATAL
        lda     $c48b05,x
        sta     hVMDATAH
        lda     $c48b06,x
        eor     $c48b07,x
        sta     hVMDATAL
        lda     $c48b07,x
        sta     hVMDATAH
        lda     $c48b08,x
        eor     $c48b09,x
        sta     hVMDATAL
        lda     $c48b09,x
        sta     hVMDATAH
        lda     $c48b0a,x
        eor     $c48b0b,x
        sta     hVMDATAL
        lda     $c48b0b,x
        sta     hVMDATAH
        lda     $c48b0c,x
        eor     $c48b0d,x
        sta     hVMDATAL
        lda     $c48b0d,x
        sta     hVMDATAH
        lda     $c48b0e,x
        eor     $c48b0f,x
        sta     hVMDATAL
        lda     $c48b0f,x
        sta     hVMDATAH
        ldy     #$0018
@6c3b:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6c3b
        longac
        txa
        adc     #$0010
        tax
        shorta0
        cpx     #$00a0
        beq     @6c56
        jmp     @6ba8
@6c56:  lda     $c48bd0
        eor     $c48bd1
        sta     hVMDATAL
        lda     $c48bd1
        sta     hVMDATAH
        lda     $c48bd2
        eor     $c48bd3
        sta     hVMDATAL
        lda     $c48bd3
        sta     hVMDATAH
        lda     $c48bd4
        eor     $c48bd5
        sta     hVMDATAL
        lda     $c48bd5
        sta     hVMDATAH
        lda     $c48bd6
        eor     $c48bd7
        sta     hVMDATAL
        lda     $c48bd7
        sta     hVMDATAH
        lda     $c48bd8
        eor     $c48bd9
        sta     hVMDATAL
        lda     $c48bd9
        sta     hVMDATAH
        lda     $c48bda
        eor     $c48bdb
        sta     hVMDATAL
        lda     $c48bdb
        sta     hVMDATAH
        lda     $c48bdc
        eor     $c48bdd
        sta     hVMDATAL
        lda     $c48bdd
        sta     hVMDATAH
        lda     $c48bde
        eor     $c48bdf
        sta     hVMDATAL
        lda     $c48bdf
        sta     hVMDATAH
        ldy     #$01a0
@6ce9:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6ce9
        rts

; ------------------------------------------------------------------------------

; [ update party equipment effects ]

UpdateEquip:
@6cf3:  stz     $11df       ; clear equipment effects
        ldy     $00
        stz     $1b
@6cfa:  lda     $0867,y     ; check if character is enabled
        and     #$40
        beq     @6d14
        lda     $0867,y     ; check if character is in the current party
        and     #$07
        cmp     $1a6d
        bne     @6d14
        phy
        lda     $1b
        jsl     UpdateEquip_ext
        tdc
        ply
@6d14:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inc     $1b
        cpy     #$0290
        bne     @6cfa
        rts

; ------------------------------------------------------------------------------

; [ update party switching ]

CheckChangeParty:
@6d26:  lda     $1eb9       ; return if party switching is disabled
        and     #$40
        beq     @6d76
        lda     a:$0084       ; return if map is loading
        bne     @6d76
        lda     $055e       ; return if there was a party collision
        bne     @6d76
        ldx     $e5         ; return if running an event
        cpx     #$0000
        bne     @6d76
        lda     $e7
        cmp     #$ca
        bne     @6d76
        ldy     $0803       ; party object
        lda     $0869,y     ; return if between tiles
        bne     @6d76
        lda     $086a,y
        and     #$0f
        bne     @6d76
        lda     $086c,y
        bne     @6d76
        lda     $086d,y
        and     #$0f
        bne     @6d76
        lda     $07         ; branch if y button is down
        and     #$40
        bne     @6d6c
        lda     #$01        ; enable party switching and return
        sta     $0762
        bra     @6d76
@6d6c:  lda     $0762       ; y button down, check if party switching was enabled last frame
        beq     @6d76
        stz     $0762       ; if so, disable party switching and do the switch
        bra     ChangeParty
@6d76:  rts

; ------------------------------------------------------------------------------

; [ switch parties ]

ChangeParty:
@6d77:  lda     $1a6d       ; party number
        tay
        lda     $b2         ; save party z-level
        sta     $1ff3,y
        lda     $1a6d       ; increment party number
        inc
        cmp     #$04
        bne     @6d8a
        lda     #$01
@6d8a:  sta     $1a6d
        lda     #$20        ; look for character in the new party with the highest battle order
        sta     $1a
        ldy     #$07d9
        sty     $07fb
        ldy     $00
@6d99:  lda     $0867,y
        and     #$40
        cmp     #$40
        bne     @6dba
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @6dba
        lda     $0867,y
        and     #$18
        cmp     $1a
        bcs     @6dba
        sta     $1a
        sty     $07fb       ; make that character the showing character
@6dba:  longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @6d99
        ldy     $07fb       ; if no characters were found, increment the party and try again
        cpy     #$07d9
        beq     @6d77
        ldy     $07fb       ; if the new showing character was already the party object, return
        cpy     $0803
        beq     @6e43
        ldx     #$07d9      ; clear party slot 1 through 3
        stx     $07fd
        stx     $07ff
        stx     $0801
        ldx     $0803       ; copy movement type from the old party object to the new one
        lda     $087c,x
        sta     $087c,y
        sta     $087d,y
        lda     #$00        ; clear the old party object movement type
        sta     $087c,x
        sta     $087d,x
        lda     $087f,x     ; old party object facing direction
        asl3
        sta     $1a
        lda     $0868,x     ; set saved facing direction
        and     #$e7
        ora     $1a
        sta     $0868,x
        ldx     $088d,y     ; branch if the new party is on a different map
        cpx     $82
        bne     @6e44
        lda     #$01        ; reload same map
        sta     $58
        lda     #$80        ; enable map startup event
        sta     $11fa
        lda     $087a,y     ; set party position
        sta     $1fc0
        sta     $1f66
        lda     $087b,y
        sta     $1fc1
        sta     $1f67
        jsr     FadeOut
        lda     #$01
        sta     $84
        jsr     PushPartyMap
        lda     $1a6d       ; restore new party's z-level
        tay
        lda     $1ff3,y
        and     #$03
        sta     $0744
@6e43:  rts
@6e44:  lda     #$80        ; enable map startup event
        sta     $11fa
        longa
        lda     $088d,y     ; set new map
        sta     $1f64
        lda     $086a,y     ; set party position
        lsr4
        shorta
        sta     $1fc0
        longa
        lda     $086d,y
        lsr4
        shorta
        sta     $1fc1
        tdc
        jsr     FadeOut
        lda     #$80        ; don't update party facing direction
        sta     $0743
        lda     #$01        ; enable map load
        sta     $84
        jsr     PushPartyMap
        lda     $1a6d       ; restore new party's z-level
        tay
        lda     $1ff3,y
        and     #$03
        sta     $0744
        rts

; ------------------------------------------------------------------------------

; [ save map and position for character objects ]

PushPartyMap:
@6e88:  ldx     $00
        txy
@6e8b:  longac
        lda     $088d,x
        sta     $1f81,y
        lda     $086a,x
        lsr4
        shorta
        sta     $1fd3,y
        longa
        lda     $086d,x
        lsr4
        shorta
        sta     $1fd4,y
        longac
        txa
        adc     #$0029
        tax
        shorta0
        iny2
        cpy     #$0020
        bne     @6e8b
        rts

; ------------------------------------------------------------------------------

; [ restore map index for character objects ]

PopPartyMap:
@6ebf:  ldx     $00
        txy
@6ec2:  longac
        lda     $1f81,y     ; object map index
        sta     $088d,x
        txa
        adc     #$0029
        tax
        shorta0
        iny2                ; loop through 16 characters
        cpy     #$0020
        bne     @6ec2
        rts

; ------------------------------------------------------------------------------

; [ restore character positions ]

PopPartyPos:
@6eda:  ldx     $00
        txy
@6edd:  tdc
        sta     $0869,x
        sta     $086c,x
        lda     $0880,x
        ora     #$20
        sta     $0880,x
        lda     $0881,x
        ora     #$20
        sta     $0881,x
        longa
        lda     $1fd3,y
        and     #$00ff
        asl4
        sta     $086a,x
        lda     $1fd4,y
        and     #$00ff
        asl4
        sta     $086d,x
        txa
        clc
        adc     #$0029
        tax
        shorta0
        iny2                ; loop through 16 characters
        cpy     #$0020
        bne     @6edd
        rts

; ------------------------------------------------------------------------------

; [ save character palettes ]

PushPartyPal:
@6f21:  ldx     $00
        txy
@6f24:  lda     $0880,x
        and     #$0e
        sta     $1f70,y
        longac
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010
        bne     @6f24
        rts

; ------------------------------------------------------------------------------

; [ restore character palettes ]

PopPartyPal:
@6f3d:  ldx     $00
        txy
@6f40:  lda     $0880,x     ; restore character palettes
        and     #$f1
        ora     $1f70,y
        sta     $0880,x
        lda     $0881,x
        and     #$f1
        ora     $1f70,y
        sta     $0881,x
        longac
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010
        bne     @6f40
        rts

; ------------------------------------------------------------------------------

; [ get first character in party ]

GetTopChar:
@6f67:  ldy     $0803
        sty     $1e
        ldx     $086a,y
        stx     $26
        ldx     $086d,y
        stx     $28
        lda     #$20
        sta     $1a
        ldx     $00
        txy
@6f7d:  lda     $1850,y
        and     #$07
        cmp     $1a6d
        bne     @6fb9
        longa
        lda     $26
        sta     $086a,x
        lda     $28
        sta     $086d,x
        lda     $087a,x
        sta     $20
        shorta0
        sta     $0869,x
        sta     $086c,x
        phx
        ldx     $20
        lda     #$ff
        sta     $7e2000,x
        plx
        lda     $1850,y
        and     #$18
        cmp     $1a
        bcs     @6fb9
        sta     $1a
        stx     $07fb
@6fb9:  longac
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010
        bne     @6f7d
        ldx     $07fb
        lda     $0867,x
        ora     #$80
        sta     $0867,x
        cpx     $1e
        bne     @6fdb
        jmp     @7065
@6fdb:  ldy     $1e
        longa
        lda     $087a,y
        sta     $087a,x
        shorta0
        lda     $0880,y
        and     #$30
        sta     $1a
        lda     $0880,x
        and     #$cf
        ora     $1a
        sta     $0880,x
        lda     $0881,y
        and     #$30
        sta     $1a
        lda     $0881,x
        and     #$cf
        ora     $1a
        sta     $0881,x
        lda     $0868,y
        sta     $0868,x
        lda     $087e,y
        sta     $087e,x
        lda     $087f,y
        sta     $087f,x
        lda     $0877,y
        sta     $0877,x
        lda     $087c,y
        sta     $087c,x
        sta     $087d,x
        lda     #$00
        sta     $087c,y
        sta     $087d,y
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        lda     $0867,y
        and     #$7f
        sta     $0867,y
        nop3
        ldy     hRDDIVL
        sta     $1850,y
        stx     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        lda     $0867,x
        ora     #$80
        sta     $0867,x
        nop3
        ldy     hRDDIVL
        sta     $1850,y
@7065:  ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        lda     #$01
        sta     $0798
        rts

; ------------------------------------------------------------------------------

; [ restore character data ]

PopCharFlags:
@7077:  ldx     $00
        txy
@707a:  lda     $1850,y     ; visible, enabled, row, battle order, party
        sta     $0867,x
        longac
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010      ; loop through 16 characters
        bne     @707a
        rts

; ------------------------------------------------------------------------------

; [ save character data ]

PushCharFlags:
@7091:  ldx     $00
        txy
@7094:  lda     $0867,x     ; visible, enabled, row, party
        and     #$e7
        sta     $1a
        lda     $1850,y     ; battle order
        and     #$18
        ora     $1a
        sta     $1850,y
        longac
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010      ; loop through 16 characters
        bne     @7094
        rts

; ------------------------------------------------------------------------------

; [ calculate object data pointers ]

CalcObjPtrs:
@70b6:  lda     #$29        ; object data is 41 bytes each
        sta     hWRMPYA
        ldx     $00
@70bd:  txa
        lsr
        sta     hWRMPYB
        nop3
        longa
        lda     hRDMPYL
        sta     $0799,x     ; store pointer
        shorta0
        inx2
        cpx     #$0062      ; $31 objects total
        bne     @70bd
        rts

; ------------------------------------------------------------------------------

; [ get pointer to first valid character ]

; y = pointer to object data

GetTopCharPtr:
@70d8:  cpy     $07fb
        bne     @70ee       ; branch if not party character 0
        ldy     #$07d9
        sty     $07fb       ; clear all party character slots
        sty     $07fd
        sty     $07ff
        sty     $0801
        bra     @711c
@70ee:  cpy     $07fd       ; branch if not party character 1
        bne     @7101
        ldy     #$07d9
        sty     $07fd       ; clear party character slots 1-3
        sty     $07ff
        sty     $0801
        bra     @711c
@7101:  cpy     $07ff       ; branch if not party character 2
        bne     @7111
        ldy     #$07d9
        sty     $07ff       ; clear party character slots 2-3
        sty     $0801
        bra     @711c
@7111:  cpy     $0801       ; branch if not party character 3
        bne     @711c
        ldy     #$07d9
        sty     $0801       ; clear party character slots 3
@711c:  rts

; ------------------------------------------------------------------------------

; [  ]

@711d:  ldy     $00
@711f:  lda     $0867,y
        and     #$40
        beq     @713a
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @713a
        longa
        lda     $82
        sta     $088d,y
        shorta0
@713a:  longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @711f
        rts

; ------------------------------------------------------------------------------

; [ update character objects ]

_c0714a:
sort_obj_work:
@714a:  ldx     #$0803
        stx     hWMADDL
        lda     #$00
        sta     hWMADDH
        stz     $1b
        ldy     $07fb
        cpy     #$07d9
        beq     @719a
        lda     $0867,y
        and     #$40
        bne     @7178
        ldy     #$07d9
        sty     $07fb
        sty     $07fd
        sty     $07ff
        sty     $0801
        jmp     @724f
@7178:  lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @719a
        lda     $82
        sta     $088d,y
        lda     $83
        sta     $088e,y
        lda     $07fb
        sta     hWMDATA
        lda     $07fc
        sta     hWMDATA
        inc     $1b
@719a:  ldy     $07fd
        cpy     #$07d9
        beq     @71da
        lda     $0867,y
        and     #$40
        bne     @71b8
        ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        jmp     @724f
@71b8:  lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @71da
        lda     $82
        sta     $088d,y
        lda     $83
        sta     $088e,y
        lda     $07fd
        sta     hWMDATA
        lda     $07fe
        sta     hWMDATA
        inc     $1b
@71da:  ldy     $07ff
        cpy     #$07d9
        beq     @7216
        lda     $0867,y
        and     #$40
        bne     @71f4
        ldy     #$07d9
        sty     $07ff
        sty     $0801
        bra     @724f
@71f4:  lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @7216
        lda     $82
        sta     $088d,y
        lda     $83
        sta     $088e,y
        lda     $07ff
        sta     hWMDATA
        lda     $0800
        sta     hWMDATA
        inc     $1b
@7216:  ldy     $0801
        cpy     #$07d9
        beq     @724f
        lda     $0867,y
        and     #$40
        bne     @722d
        ldy     #$07d9
        sty     $0801
        bra     @724f
@722d:  lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @724f
        lda     $82
        sta     $088d,y
        lda     $83
        sta     $088e,y
        lda     $0801
        sta     hWMDATA
        lda     $0802
        sta     hWMDATA
        inc     $1b
@724f:  ldx     $00
@7251:  ldy     $0799,x
        cpy     $07fb
        beq     @7295
        cpy     $07fd
        beq     @7295
        cpy     $07ff
        beq     @7295
        cpy     $0801
        beq     @7295
        lda     $0867,y
        and     #$40
        beq     @7295
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @7295
        lda     $82
        sta     $088d,y
        lda     $83
        sta     $088e,y
        lda     $0799,x
        sta     hWMDATA
        sta     $1c
        lda     $079a,x
        sta     hWMDATA
        sta     $1d
        inc     $1b
@7295:  inx2
        cpx     #$0020
        bne     @7251
        lda     #$b0
        sta     hWMDATA
        lda     #$07
        sta     hWMDATA
        inc     $1b
        ldx     $00
@72aa:  ldy     $0799,x
        lda     $0867,y
        and     #$40
        beq     @72d8
        lda     $0867,y
        and     #$07
        beq     @72ca
        cmp     $1a6d
        beq     @72d8
        phx
        ldx     $088d,y
        txy
        plx
        cpy     $82
        bne     @72d8
@72ca:  lda     $0799,x
        sta     hWMDATA
        lda     $079a,x
        sta     hWMDATA
        inc     $1b
@72d8:  inx2
        cpx     #$0020
        bne     @72aa
        ldx     #$0020
@72e2:  ldy     $0799,x
        lda     $0867,y
        and     #$40
        beq     @72fa
        lda     $0799,x
        sta     hWMDATA
        lda     $079a,x
        sta     hWMDATA
        inc     $1b
@72fa:  inx2
        cpx     #$0060
        bne     @72e2
        lda     $1b
        asl
        sta     $dd
        stz     $0798
        rts

; ------------------------------------------------------------------------------

; starting object to update each frame * 2
FirstObjTbl2:
@730a:  .byte   $00,$0c,$18,$24

; ------------------------------------------------------------------------------

; [ detect object collisions ]

; y = pointer to object data

CheckCollosions:
@730e:  lda     $59         ; return if menu opening
        bne     @7334
        lda     $087c,y     ; return if object does not activate on collision
        and     #$40
        beq     @7334
        ldx     $e5         ; return if an event is running
        cpx     #$0000
        bne     @7334
        lda     $e7
        cmp     #$ca
        bne     @7334
        lda     $84         ; return if a map is loading
        bne     @7334
        lda     $055e       ;
        bne     @7334
        cpy     #$0290      ; return if the object is a character
        bcs     @7335
@7334:  rts
@7335:  lda     $087a,y     ; pointer to object map data
        sta     $1e         ; +$1e = tile above
        sta     $22         ; +$22 = tile below
        inc
        and     $86
        sta     $20         ; +$20 = tile to the right
        lda     $1e
        dec
        and     $86
        sta     $24         ; +$24 = tile to the left
        lda     $087b,y
        clc
        adc     #$20
        sta     $21
        sta     $25
        lda     $087b,y
        dec
        and     $87
        clc
        adc     #$20
        sta     $1f
        lda     $087b,y
        inc
        and     $87
        clc
        adc     #$20
        sta     $23
        lda     #$7e
        pha
        plb
        stz     $1b         ; $1b = facing direction
        lda     ($1e)       ; check if the object came in contact with a character
        cmp     #$20
        bcc     @7390
        inc     $1b
        lda     ($20)
        cmp     #$20
        bcc     @7390
        inc     $1b
        lda     ($22)
        cmp     #$20
        bcc     @7390
        inc     $1b
        lda     ($24)
        cmp     #$20
        bcc     @7390
        tdc
        pha
        plb
        rts
@7390:  sta     $1a
        tdc
        pha
        plb
        sty     $0562
        lda     $1a
        tax
        ldy     $0799,x
        sty     $0560
        lda     $1b
        sta     $055f
        lda     #$01
        sta     $055e
        rts

; ------------------------------------------------------------------------------

; [ update party collisions ]

UpdateCollisionScroll:
@73ac:  lda     $055e       ; return if no collisions occurred
        cmp     #$01
        bne     @73ce
        ldy     $0803       ; return if party is between tiles
        lda     $0869,y
        bne     @73ce
        lda     $086a,y
        and     #$0f
        bne     @73ce
        lda     $086c,y
        bne     @73ce
        lda     $086d,y
        and     #$0f
        beq     @73cf
@73ce:  rts
@73cf:  lda     #$02        ; increment collision status
        sta     $055e
        ldy     $0560       ; collided object data pointer
        longa
        lda     $086a,y
        lsr4
        sta     $26         ; +$26 = x position (in tiles)
        lda     $086d,y
        lsr4
        sta     $28         ; +$28 = y position (in tiles)
        shorta0
        stz     $27
        stz     $29
        lda     $26         ; set destination horizontal scroll position
        sta     $0557
        sec
        sbc     $0541       ; subtract current scroll position
        bpl     @7402
        inc     $27         ; $27: 0 = scrolling right, 1 = scrolling left
        eor     $02
        inc
@7402:  sta     $26         ; $26 = horizontal scroll distance
        lda     $28         ; set vertical horizontal scroll position
        sta     $0558
        sec
        sbc     $0542       ; subtract current scroll position
        bpl     @7414
        inc     $29         ; $29: 0 = scrolling down, 1 = scrolling up
        eor     $02
        inc
@7414:  sta     $28         ; $28 = vertical scroll distance
        cmp     #$02
        bcs     @7423       ; branch if scrolling more that 2 tiles
        lda     $26
        cmp     #$02
        bcs     @7423
        jmp     @74bb
@7423:  lda     $28
        cmp     $26
        bcs     @744d       ; branch if vertical scroll distance is greater than horizontal scroll distance
        longa
        xba
        asl
        sta     hWRDIVL
        shorta0
        lda     $26
        sta     hWRDIVB
        nop7
        ldx     hRDDIVL
        stx     $0549
        ldx     #$0200      ; 4 pixels/frame in the horizontal direction
        stx     $0547
        bra     @7471
@744d:  lda     $26
        longa
        xba
        asl
        sta     hWRDIVL
        shorta0
        lda     $28
        sta     hWRDIVB
        nop7
        ldx     hRDDIVL
        stx     $0547
        ldx     #$0200      ; 4 pixels/frame in the vertical direction
        stx     $0549
@7471:  lda     $27         ; branch if scrolling right
        beq     @7483
        longa
        lda     $0547       ; negate horizontal scroll speed
        eor     $02
        inc
        sta     $0547
        shorta0
@7483:  lda     $29         ; branch if scrolling up
        beq     @7495
        longa
        lda     $0549       ; negate vertical scroll speed
        eor     $02
        inc
        sta     $0549
        shorta0
@7495:  ldx     $0547       ; copy bg1 scroll speed to bg2 and bg3
        stx     $054b
        stx     $054f
        ldx     $0549
        stx     $054d
        stx     $0551
        ldx     $00         ; clear scroll due to movement
        stx     a:$0073
        stx     a:$0075
        stx     a:$0077
        stx     a:$0079
        stx     a:$007b
        stx     a:$007d
@74bb:  lda     $087f,y     ; update facing direction
        asl3
        sta     $1a
        lda     $0868,y
        and     #$e7
        ora     $1a
        sta     $0868,y
        lda     $055f       ; get collision direction
        clc
        adc     #$02        ; change left to right, up to down so character will face attacker
        and     #$03
        sta     $087f,y
        tax
        lda     f:ObjStopTileTbl,x   ; set graphic position based on facing direction
        sta     $0877,y
        lda     $1a6d       ; save default party
        sta     $055d
        lda     $0867,y     ; set new party
        and     #$07
        sta     $1a6d
        lda     $087c,y     ; set movement type to activated
        and     #$f0
        ora     #$04
        sta     $087c,y
        sta     $087d,y
        ldy     #$07d9      ; clear character slot 1 through 3 object pointers
        sty     $07fd
        sty     $07ff
        sty     $0801
        ldy     $0562       ; colliding npc data pointer
        tdc
        sta     $0882,y     ; clear queue counter
        lda     $055f       ; set facing direction
        sta     $087f,y
        tax
        lda     f:ObjStopTileTbl,x   ; set graphic position based on facing direction
        sta     $0877,y
        lda     $087c,y     ; save movement type
        sta     $087d,y
        and     #$f0        ; set movement type to activated
        ora     #$04
        sta     $087c,y
        lda     $0889,y     ; set event pc
        sta     $e5
        sta     $05f4
        lda     $088a,y
        sta     $e6
        sta     $05f5
        lda     $088b,y
        clc
        adc     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000      ; set return address
        stx     $0594
        lda     #$ca
        sta     $0596       ; set loop count
        lda     #$01
        sta     $05c7       ; set stack pointer
        ldx     #$0003
        stx     $e8
        ldy     $0803       ; party object data pointer
        lda     $087c,y     ; save movement type
        sta     $087d,y
        and     #$f0        ; set movement type to activated
        ora     #$04
        sta     $087c,y
        lda     $e1         ; wait for scroll to finish before executing events
        ora     #$20
        sta     $e1
        lda     #$01        ; wait for character objects to get updated
        sta     $0798
        jsr     CloseMapTitleWindow
        rts

; ------------------------------------------------------------------------------

; [ update object actions ]

; called once per frame and once by map loader

ExecObjScript:
@7578:  lda     $47         ; only update 6 objects per frame
        and     #$03
        tax
        lda     f:FirstObjTbl2,x   ; get first object (x2)
        sta     $dc
        lda     #$06
        sta     $de

_c07587:
@7587:  tdc                 ; start of loop
        shorta
        lda     $dc
        tax
        ldy     $0803,x     ; get pointer to object data
        sty     $da
        cmp     $dd         ; skip if greater than the current total number of objects
        bcc     @7599
@7596:  jmp     _c07656
@7599:  lda     $0869,y     ; skip if this object is between tiles
        bne     @7596
        lda     $086a,y
        and     #$0f
        bne     @7596
        lda     $086c,y
        bne     @7596
        lda     $086d,y
        and     #$0f
        bne     @7596
        lda     $087c,y     ; branch if object scrolls with bg2
        bmi     @7634
        lda     $0868,y     ; branch if object has special graphics
        and     #$e0
        cmp     #$80
        beq     @7634
        lda     $088c,y     ; branch if not normal sprite priority
        and     #$c0
        bne     @7634
        cpy     #$07b0      ; branch if this is the camera
        beq     @763a
        ldx     $087a,y     ; pointer to map data (old)
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        pha
        pla
        pha
        pla
        lda     hRDDIVL       ; get object number
        asl
        cmp     $7e2000,x   ; if this object is shown in map data, clear it for now
        bne     @75ea
        lda     #$ff
        sta     $7e2000,x
@75ea:  lda     $0867,y     ; branch if object is visible
        bpl     @763a
        jsr     GetObjMapPtr
        ldx     $087a,y
        lda     $7f0000,x   ; tile number
        tax
        lda     $7e7600,x   ; tile properties
        and     #$03
        sta     $0888,y     ; set z-level
        lda     $dc         ; current object
        bne     @7629       ; branch if not object 0 (party)
        lda     $087c,y     ; branch if movement is not user-controlled
        and     #$0f
        cmp     #$02
        bne     @7629
        lda     $b8         ; branch if not on a bridge tile
        and     #$04
        beq     @761c
        lda     $b2         ; branch if object is not on lower z-level
        cmp     #$02
        beq     @7627
@761c:  ldx     $087a,y     ; pointer to map data
        lda     hRDDIVL       ; get object number
        asl
        sta     $7e2000,x   ; set object map data
@7627:  bra     @763a
@7629:  ldx     $087a,y     ; pointer to map data
        lda     hRDDIVL       ; get object number
        asl
        sta     $7e2000,x   ; set object map data
@7634:  jsr     UpdateObjLayerPriorityAfter
        jsr     CheckCollosions
@763a:  lda     $087c,y     ; movement type
        and     #$0f
        dec
        bne     @7645
        jmp     _c076e9       ; jump if script-controlled
@7645:  dec
        bne     @764b
        jmp     _c076de
@764b:  dec
        beq     _7662       ; branch if random
        dec
        beq     _7667       ; branch if activated
        cpy     $0803       ; branch if current object is the party object
        beq     _7667

; next object
_c07656:
@7656:  inc     $dc         ; next object
        inc     $dc
        dec     $de
        beq     @7661
        jmp     _c07587
@7661:  rts

; random movement
_7662:  jsr     NPCMoveRand
        bra     _c07656

; activated (movement)
_7667:  longa
        tdc
        sta     $0871,y     ; clear movement speed
        sta     $0873,y
        shorta
        lda     $e5         ; return if an event is running
        cmp     #$00
        bne     @76db
        lda     $e6
        cmp     #$00
        bne     @76db
        lda     $e7
        cmp     #$ca
        bne     @76db
        lda     $087d,y
        cpy     $0803
        bne     @769a       ; branch if not the party object
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @769a       ; branch if not the current party
        lda     #$02        ; set movement type to user-controlled (return control to user after event is complete)
        bra     @76cf
@769a:  lda     $087d,y     ; previous movement type
        and     #$0f
        cmp     #$02
        bne     @76a7       ; branch if not user-controlled
        lda     #$00        ; set movement type to none
        bra     @76cf
@76a7:  sta     $1a         ; restore previous movement type
        lda     $087c,y
        and     #$f0
        ora     $1a
        sta     $087c,y
        lda     $087c,y     ; return if object activates on collision
        and     #$20
        bne     @76cd
        lda     $0868,y     ; restore facing direction
        and     #$18
        lsr3
        sta     $087f,y
        tax
        lda     f:ObjStopTileTbl,x   ; set graphics position
        sta     $0877,y
@76cd:  bra     _c07656
@76cf:  sta     $1a         ; set new movement type
        lda     $087c,y
        and     #$f0
        ora     $1a
        sta     $087c,y
@76db:  jmp     _c07656

; user-controlled movement
_c076de:
@76de:  lda     $1eb9       ; return if user-control event bit is set
        bmi     @76e6
        jsr     UpdatePlayerMovement
@76e6:  jmp     _c07656

; script-controlled movement
_c076e9:
@76e9:  lda     $0882,y     ; decrement script wait counter
        beq     @76f8
        dec
        sta     $0882,y
        jmp     _c07656
@76f5:  jmp     @7783
@76f8:  lda     $0886,y     ; number of steps to take
        beq     @76f5
        lda     $087e,y     ; movement direction
        beq     @76f5

; do script-controlled movement
        cpy     #$07b0
        beq     @7769
        sta     $b3
        cmp     #$05
        bcs     @7769
        jsr     GetObjMapAdjacent
        ldx     $1e
        lda     $087c,y
        bmi     @7769
        and     #$10
        bne     @773c
        lda     $7e2000,x
        bmi     @773c
        longa
        tdc
        sta     $0871,y
        sta     $0873,y
        shorta
        cpy     #$07b0
        beq     @7736
        cpy     $0803
        bne     @7739
@7736:  jsr     UpdateScrollRate
@7739:  jmp     _c07656
@773c:  sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        lda     $087c,y
        bmi     @7769
        lda     $0868,y
        and     #$e0
        cmp     #$80
        beq     @7769
        lda     $088c,y
        and     #$c0
        bne     @7769
        lda     hRDDIVL
        asl
        sta     $7e2000,x
        lda     $7f0000,x
        tax
        jsr     UpdateObjLayerPriorityBefore
@7769:  jsr     CalcObjMoveDir
        cpy     #$07b0
        beq     @7776
        cpy     $0803
        bne     @7779
@7776:  jsr     UpdateScrollRate
@7779:  lda     $0886,y
        dec
        sta     $0886,y
        jmp     _c07656

; do next command from object script
@7783:  longa
        lda     $0883,y     ; script pointer
        sta     $2a
        shorta0
        lda     $0885,y
        sta     $2c
        lda     [$2a]       ; script command
        bmi     @779c

; object command $00-$7f: set graphical position
        sta     $0877,y
        jmp     _c07801

; object command $80-$9f: horizontal/vertical movement
@779c:  cmp     #$a0
        bcc     @77a3
        jmp     @77bf
@77a3:  sec
        sbc     #$80
        sta     $1a
        and     #$03
        sta     $087f,y     ; set facing direction
        inc
        sta     $087e,y     ; set movement direction
        lda     $1a
        lsr2
        inc
        sta     $0886,y     ; set number of steps to take
        jsr     IncObjScriptPtr
        jmp     _c076e9       ; do script-controlled movement

; object command $a0-$bf: diagonal movement
@77bf:  cmp     #$b0
        bcs     @77e1
        sec
        sbc     #$9c
        sta     $1a
        inc
        sta     $087e,y     ; set movement direction
        lda     $1a
        tax
        lda     f:ObjMoveDirTbl,x   ; set facing direction
        sta     $087f,y
        lda     #$01
        sta     $0886,y     ; take one step
        jsr     IncObjScriptPtr
        jmp     _c076e9       ; do script-controlled movement

; object command $c0-$c5: set object speed
@77e1:  cmp     #$c6
        bcs     @77ee
        sec
        sbc     #$c0
        sta     $0875,y     ; set object speed
        jmp     _c07801

; object command $c6-$ff
@77ee:  sec
        sbc     #$c6
        asl
        tax
        longa
        lda     $c07807,x
        sta     $2d
        shorta0
        jmp     ($002d)

; ------------------------------------------------------------------------------

; [  ]

_c07801:
@7801:  jsr     IncObjScriptPtr
        jmp     _c076e9

; ------------------------------------------------------------------------------

; object command jump table
@7807:  .addr   ObjCmd_c6
        .addr   ObjCmd_c7
        .addr   ObjCmd_c8
        .addr   ObjCmd_c9
        .addr   0
        .addr   0
        .addr   ObjCmd_cc
        .addr   ObjCmd_cd
        .addr   ObjCmd_ce
        .addr   ObjCmd_cf
        .addr   ObjCmd_d0
        .addr   ObjCmd_d1
        .addr   0
        .addr   0
        .addr   0
        .addr   ObjCmd_d5
        .addr   0
        .addr   ObjCmd_d7
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   ObjCmd_dc
        .addr   ObjCmd_dd
        .addr   0
        .addr   0
        .addr   ObjCmd_e0
        .addr   ObjCmd_e1
        .addr   ObjCmd_e2
        .addr   ObjCmd_e3
        .addr   ObjCmd_e4
        .addr   ObjCmd_e5
        .addr   ObjCmd_e6
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   ObjCmd_f9
        .addr   ObjCmd_fa
        .addr   ObjCmd_fb
        .addr   ObjCmd_fc
        .addr   ObjCmd_fd
        .addr   0
        .addr   ObjCmd_ff

; ------------------------------------------------------------------------------

; [ object command $c6: enable walking animation ]

ObjCmd_c6:
@787b:  lda     $0868,y
        ora     #$01
        sta     $0868,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $c7: disable walking animation ]

ObjCmd_c7:
@7886:  lda     $0868,y
        and     #$fe
        sta     $0868,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $c8: set sprite layer priority ]

; $eb = priority (0..3)

ObjCmd_c8:
@7891:  ldy     #$0001
        lda     [$2a],y
        asl
        sta     $1a
        ldy     $da
        lda     $0868,y
        and     #$f9
        ora     $1a
        sta     $0868,y
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $cc: turn object up ]

ObjCmd_cc:
@78ab:  tdc
        sta     $087f,y
        lda     #$04
        sta     $0877,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $cd: turn object right ]

ObjCmd_cd:
@78b7:  lda     #$01
        sta     $087f,y
        lda     #$47
        sta     $0877,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $ce: turn object down ]

ObjCmd_ce:
@78c4:  lda     #$02
        sta     $087f,y
        lda     #$01
        sta     $0877,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $cf: turn object left ]

ObjCmd_cf:
@78d1:  lda     #$03
        sta     $087f,y
        lda     #$07
        sta     $0877,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $d0: show object ]

ObjCmd_d0:
@78de:  lda     $0867,y     ; return if object already visible
        bmi     @7924
        ora     #$80
        sta     $0867,y     ; make object visible
        lda     $0868,y     ; set sprite layer priority to default
        and     #$f9
        sta     $0868,y
        lda     $0880,y     ; both sprites shown below priority 1 bg
        and     #$cf
        ora     #$20
        sta     $0880,y
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
        phy
        sty     hWRDIVL     ; get object number
        lda     #$29
        sta     hWRDIVB
        nop7
        ldy     hRDDIVL
        cpy     #$0010
        bcs     @7924       ; branch if not a character
        lda     $1850,y     ; set character visible flag
        ora     #$80
        sta     $1850,y
@7924:  ply
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $d1: hide object ]

ObjCmd_d1:
@7928:  lda     $0867,y
        and     #$7f
        sta     $0867,y
        tdc
        sta     $087d,y
        lda     $087c,y
        and     #$f0
        sta     $087c,y
        ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x
        phy
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        ldy     hRDDIVL
        cpy     #$0010
        bcs     @7965
        lda     $1850,y
        and     #$7f
        sta     $1850,y
@7965:  ply
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e1: set event bit (+$1e80) ]

ObjCmd_e1:
@7969:  phy
        ldy     #$0001
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1e80,y
        ora     f:BitOrTbl,x
        sta     $1e80,y
        ply
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e2: set event bit (+$1ea0) ]

ObjCmd_e2:
@7983:  phy
        ldy     #$0001
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ea0,y
        ora     f:BitOrTbl,x
        sta     $1ea0,y
        ply
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e3: set event bit (+$1ec0) ]

ObjCmd_e3:
@799d:  phy
        ldy     #$0001
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ec0,y
        ora     f:BitOrTbl,x
        sta     $1ec0,y
        ply
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e4: clear event bit (+$1e80) ]

ObjCmd_e4:
@79b7:  phy
        ldy     #$0001
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitAndTbl,x
        sta     $1e80,y
        ply
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e5: clear event bit (+$1ea0) ]

ObjCmd_e5:
@79d1:  phy
        ldy     #$0001
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ea0,y
        and     f:BitAndTbl,x
        sta     $1ea0,y
        ply
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e6: clear event bit (+$1ec0) ]

ObjCmd_e6:
@79eb:  phy
        ldy     #$0001
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ec0,y
        and     f:BitAndTbl,x
        sta     $1ec0,y
        ply
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $c9: set vehicle ]

; $eb = vvv-----
;       v = vehicle (0..7)

ObjCmd_c9:
@7a05:  ldy     #$0001
        lda     [$2a],y
        and     #$e0
        sta     $1a
        ldy     $da
        lda     $0868,y
        ora     $1a
        sta     $0868,y
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $d5: set position ]

ObjCmd_d5:
@7a1e:  ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x
        ldy     #$0001
        lda     [$2a],y
        longa
        asl4
        sta     $1e
        shorta0
        iny
        lda     [$2a],y
        ldy     $da
        longa
        asl4
        sta     $086d,y
        lda     $1e
        sta     $086a,y
        shorta
        tdc
        sta     $086c,y
        sta     $0869,y
        jsr     GetObjMapPtr
        jsr     UpdateSpritePriority
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jmp     _c07656

; ------------------------------------------------------------------------------

; [ object command $d7: scroll to object ]

ObjCmd_d7:
@7a65:  ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x   ; clear object in map data
        longa
        ldx     $0803
        lda     $086a,x     ; set party position
        sta     $086a,y
        lda     $086d,x
        sta     $086d,y
        shorta0
        sta     $086c,y     ; clear low byte of object position
        sta     $0869,y
        jsr     GetObjMapPtr
        jsr     UpdateSpritePriority
        jsr     IncObjScriptPtr
        jmp     _c07656

; ------------------------------------------------------------------------------

; [ object command $dc: jump (low) ]

ObjCmd_dc:
@7a94:  lda     #$0f
        sta     $0887,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $dd: jump (high) ]

ObjCmd_dd:
@7a9c:  lda     #$5f
        sta     $0887,y
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $e0: pause ]

; $eb: duration (frames * 4)
; times 4 because each object updates once per 4 frames

ObjCmd_e0:
@7aa4:  longa
        tdc
        sta     $0871,y     ; clear movement speed
        sta     $0873,y
        shorta
        cpy     #$07b0
        beq     @7ab9       ; branch if camera
        cpy     $0803
        bne     @7abc       ; branch if not showing character
@7ab9:  jsr     UpdateScrollRate
@7abc:  phy
        ldy     #$0001
        lda     [$2a],y     ; set pause duration
        ply
        sta     $0882,y
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jmp     _c07656

; ------------------------------------------------------------------------------

; [ object command $f9: jump to event script ]

ObjCmd_f9:
@7acf:  lda     $055e
        bne     @7b09       ; branch if a collision is already in progress
        ldx     $e5
        cpx     #$0000
        bne     @7b09       ; branch if an event is running
        lda     $e7
        cmp     #$ca
        bne     @7b09
        phy
        ldy     #$0001      ; copy event address
        lda     [$2a],y
        sta     $e5
        iny
        lda     [$2a],y
        sta     $e6
        iny
        lda     [$2a],y
        clc
        adc     #$ca
        sta     $e7
        ldy     #$0003
        sty     a:$00e8       ; set event stack pointer
        ply
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
@7b09:  jmp     _c07656

; ------------------------------------------------------------------------------

; [ object command $fa: branch backward (50% chance) ]

ObjCmd_fa:
@7b0c:  jsr     Rand
        cmp     #$80
        bcs     _c07b26       ; 1/2 chance to branch
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $fb: branch forward (50% chance) ]

ObjCmd_fb:
@7b19:  jsr     Rand
        cmp     #$80
        bcs     _c07b4b       ; 1/2 chance to branch
        jsr     IncObjScriptPtr
        jmp     _c07801

; ------------------------------------------------------------------------------

; [ object command $fc: branch backward ]

ObjCmd_fc:
_c07b26:
@7b26:  ldy     #$0001
        lda     [$2a],y
        sta     $1a
        ldy     $da
        lda     $0883,y
        sec
        sbc     $1a
        sta     $0883,y
        lda     $0884,y
        sbc     #$00
        sta     $0884,y
        lda     $0885,y
        sbc     #$00
        sta     $0885,y
        jmp     _c076e9

; ------------------------------------------------------------------------------

; [ object command $fd: branch forward ]

ObjCmd_fd:
_c07b4b:
@7b4b:  ldy     #$0001
        lda     [$2a],y
        sta     $1a
        ldy     $da
        lda     $0883,y
        clc
        adc     $1a
        sta     $0883,y
        lda     $0884,y
        adc     #$00
        sta     $0884,y
        lda     $0885,y
        adc     #$00
        sta     $0885,y
        jmp     _c076e9

; ------------------------------------------------------------------------------

; [ object command $ff: end of script ]

ObjCmd_ff:
@7b70:  tdc
        sta     $0885,y     ; clear script pointer (bank byte)
        lda     $087c,y
        and     #$f0
        sta     $087c,y     ; clear movement type
        longa
        tdc
        sta     $0871,y     ; clear movement speed
        sta     $0873,y
        sta     $0883,y     ; clear script pointer
        shorta
        cpy     #$07b0
        beq     @7b94       ; branch if camera
        cpy     $0803
        bne     @7b97       ; branch if not showing character
@7b94:  jsr     UpdateScrollRate
@7b97:  jmp     _c07656

; ------------------------------------------------------------------------------

; [ increment object script pointer ]

IncObjScriptPtr:
@7b9a:  longac
        lda     $0883,y
        adc     #$0001
        sta     $0883,y
        shorta0
        lda     $0885,y
        adc     #$00
        sta     $0885,y
        rts

; ------------------------------------------------------------------------------

; [ do random object movement ]

NPCMoveRand:
@7bb1:  jsr     Rand
        and     #$03        ; movement direction = (1..4)
        inc
        sta     $b3
        jsr     GetObjMapAdjacent
        ldx     $1e
        lda     $7e2000,x   ; return if there's an object there
        bpl     @7c1f
        lda     $7f0000,x   ; bg1 tile
        tax
        lda     $7e7700,x   ; branch if npc can't randomly move here
        bpl     @7c1f
        lda     $0888,y     ; object z-level
        dec
        bne     @7beb       ; branch if not upper z-level

; object is upper z-level
        lda     $7e7600,x   ; tile z-level
        and     #$07
        cmp     #$01
        beq     @7bf5       ; branch if tile is upper z-level
        lda     $7e7600,x
        and     #$07
        cmp     #$04
        beq     @7bf5
        bra     @7c1f       ; return if a bridge tile

; object is lower z-level
@7beb:  lda     $7e7600,x   ; tile z-level
        and     #$07
        cmp     #$02
        bne     @7c1f       ; return if tile is not lower z-level
@7bf5:  jsr     UpdateObjLayerPriorityBefore
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop8
        lda     hRDDIVL       ; object number
        asl
        ldx     $1e
        sta     $7e2000,x   ; put object at new location in map data
        lda     $b3
        sta     $087e,y     ; set movement direction
        dec
        sta     $087f,y     ; set facing direction
        jsr     CalcObjMoveDir
        rts

; stop object and return
@7c1f:  tdc
        sta     $0871,y
        sta     $0872,y
        sta     $0873,y
        sta     $0874,y
        rts

; ------------------------------------------------------------------------------

; [ update object layer priority (based on current tile) ]

UpdateObjLayerPriorityAfter:
@7c2d:  lda     $0868,y     ; sprite layer priority
        and     #$06
        bne     _c07c69
        ldx     $087a,y     ; pointer to map data
        lda     $7f0000,x   ; bg1 tile
        tax
        lda     $7e7600,x   ; tile properties
        cmp     #$f7
        beq     _7c94       ; branch if tile is impassable
        and     #$04
        bne     _7c94       ; branch if tile is a bridge tile
        lda     $7e7600,x
        and     #$08
        beq     @7c58       ; branch if top sprite isn't shown above priority 1 bg
        lda     $0880,y     ; top sprite shown above priority 1 bg
        ora     #$30
        sta     $0880,y
@7c58:  lda     $7e7600,x   ;
        and     #$10
        beq     @7c68
        lda     $0881,y
        ora     #$30
        sta     $0881,y
@7c68:  rts

; ------------------------------------------------------------------------------

; [  ]

_c07c69:
set_fixed_prio:       ; i think...
@7c69:  lsr
        dec
        bne     _7c80       ; branch if not priority 1
        lda     $0880,y
        ora     #$30
        sta     $0880,y
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
        rts

_7c80:  dec
        bne     _7c94       ; branch if not priority 2
        lda     $0880,y
        ora     #$30
        sta     $0880,y
        lda     $0881,y
        ora     #$30
        sta     $0881,y
        rts

_7c94:  lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
        rts

; ------------------------------------------------------------------------------

; [ update object layer priority (based on destination tile) ]

; x = bg1 tile index

UpdateObjLayerPriorityBefore:
@7ca9:  lda     $0868,y     ; object sprite layer priority
        and     #$06
        bne     _c07c69
        lda     $7e7600,x
        cmp     #$f7
        beq     _7c94
        and     #$04
        bne     _7c94
        lda     $7e7600,x
        and     #$08
        bne     @7cce
        lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
@7cce:  lda     $7e7600,x
        and     #$10
        bne     @7ce0
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
@7ce0:  rts

; ------------------------------------------------------------------------------

; [ update pointer to object map data ]

GetObjMapPtr:
@7ce1:  longa
        lda     $086a,y     ; x position
        lsr4
        shorta
        and     $86         ; bg1 x clip
        sta     $087a,y     ; low byte of object map data pointer
        longa
        lda     $086d,y     ; y position
        lsr4
        shorta
        and     $87         ; bg1 y clip
        sta     $087b,y     ; high byte of object map data pointer
        tdc
        rts

; ------------------------------------------------------------------------------

; [ get pointer to object map data in facing direction ]

;    a = facing direction + 1
; +$1e = pointer to object map data in facing direction (out)

GetObjMapAdjacent:
@7d03:  tax
        jsr     GetObjMapPtr
        lda     $087a,y
        clc
        adc     f:AdjacentXTbl,x
        and     $86
        sta     $1e
        lda     $087b,y
        clc
        adc     f:AdjacentYTbl,x
        and     $87
        sta     $1f
        rts

; ------------------------------------------------------------------------------

AdjacentXTbl:
@7d20:  .byte   $00,$00,$01,$00,$ff

AdjacentYTbl:
@7d25:  .byte   $00,$ff,$00,$01,$00

; ------------------------------------------------------------------------------

; [ update bg2/bg3 movement scroll speed ]

CalcParallaxRate:
@7d2a:  ldx     $73         ; bg1 h-scroll speed
        bmi     @7d60       ; branch if negative
        longa
        txa
        lsr4
        shorta
        sta     hWRMPYA
        lda     $0553       ; bg2 h-scroll multiplier
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        sta     $77         ; set bg2 h-scroll speed
        shorta0
        lda     $0555       ; bg3 h-scroll multiplier
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        sta     $7b         ; set bg3 h-scroll speed
        shorta0
        bra     @7d99
@7d60:  longa
        txa
        eor     $02
        inc
        lsr4
        shorta
        sta     hWRMPYA
        lda     $0553
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        eor     $02
        inc
        sta     $77
        shorta0
        lda     $0555
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        eor     $02
        inc
        sta     $7b
        shorta0
@7d99:  ldx     $75         ; bg1 v-scroll speed
        bmi     @7dce       ; branch if negative
        longa
        txa
        lsr4
        shorta
        sta     hWRMPYA
        lda     $0554
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        sta     $79
        shorta0
        lda     $0556
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        sta     $7d
        shorta0
        rts
@7dce:  longa
        txa
        eor     $02
        inc
        lsr4
        shorta
        sta     hWRMPYA
        lda     $0554
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        eor     $02
        inc
        sta     $79
        shorta0
        lda     $0556
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        eor     $02
        inc
        sta     $7d
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update movement scroll speed ]

UpdateScrollRate:
@7e08:  lda     $0559       ; branch if screen is not locked
        beq     @7e20
        cpy     #$07b0      ; return if not the camera
        bne     @7e1f
        ldx     $1021       ; ($0871 + $07b0)
        stx     $73         ; set horizontal scroll speed
        ldx     $1023       ; ($0873 + $07b0)
        stx     $75         ; set vertical scroll speed
        jsr     CalcParallaxRate
@7e1f:  rts
@7e20:  ldy     $0803
        lda     $062d       ; max horizontal scroll position
        cmp     #$ff
        beq     @7e3c       ; branch if no max
        lda     $af
        ldx     $0871,y     ; party horizontal scroll speed
        bpl     @7e32
        dec
@7e32:  cmp     $062c       ; branch if less than the minimum
        bcc     @7e43
        cmp     $062d       ; branch if greater than the maximum
        bcs     @7e43
@7e3c:  ldx     $0871,y     ; party horizontal movement speed
        stx     $73         ; set horizontal scroll speed
        bra     @7e4b
@7e43:  ldx     $00
        stx     $73
        stx     $77
        stx     $7b
@7e4b:  lda     $062f       ; max vertical scroll position
        cmp     #$ff
        beq     @7e64       ; branch if no max
        lda     $b0
        ldx     $0873,y
        bpl     @7e5a
        dec
@7e5a:  cmp     $062e
        bcc     @7e6b
        cmp     $062f
        bcs     @7e6b
@7e64:  ldx     $0873,y
        stx     $75
        bra     @7e73
@7e6b:  ldx     $00
        stx     $75
        stx     $79
        stx     $7d
@7e73:  jsr     CalcParallaxRate
        rts

; ------------------------------------------------------------------------------

; [ calculate object movement direction and speed ]

CalcObjMoveDir:
@7e77:  lda     $0875,y     ; object speed
        tax
        lda     f:ObjMoveMult,x   ; speed multiplier
        sta     $1b
        lda     $087e,y     ; movement direction
        dec
        asl
        tax
        lda     f:ObjMoveRateH,x
        sta     hWRMPYA
        lda     $1b
        sta     hWRMPYB
        nop3
        longa
        lda     hRDMPYL
        eor     f:ObjMoveMaskH,x
        bpl     @7ea2
        inc
@7ea2:  sta     $0871,y
        shorta0
        lda     f:ObjMoveRateV,x
        sta     hWRMPYA
        lda     $1b
        sta     hWRMPYB
        nop3
        longa
        lda     hRDMPYL
        eor     f:ObjMoveMaskV,x
        bpl     @7ec3
        inc
@7ec3:  sta     $0873,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; object movement speed multipliers
ObjMoveMult:
@7eca:  .byte   $01,$02,$04,$08,$10,$20,$10,$08,$04,$02

; horizontal movement speeds for each movement direction
ObjMoveRateH:
@7ed4:  .word   $0000,$0040,$0000,$0040,$0040,$0040,$0040,$0040
        .word   $0020,$0040,$0040,$0020,$0020,$0040,$0040,$0020

; horizontal speed masks for each movement direction
ObjMoveMaskH:
@7ef4:  .word   $0000,$0000,$0000,$ffff,$0000,$0000,$ffff,$ffff
        .word   $0000,$0000,$0000,$0000,$ffff,$ffff,$ffff,$ffff

; vertical movement speeds for each movement direction
ObjMoveRateV:
@7f14:  .word   $0040,$0000,$0040,$0000,$0040,$0040,$0040,$0040
        .word   $0040,$0020,$0020,$0040,$0040,$0020,$0020,$0040

; vertical speed masks for each movement direction
ObjMoveMaskV:
@7f34:  .word   $ffff,$0000,$0000,$0000,$ffff,$0000,$0000,$ffff
        .word   $ffff,$ffff,$0000,$0000,$0000,$0000,$ffff,$ffff

; corresponding facing directions for each movement direction
ObjMoveDirTbl:
@7f54:  .byte   $00,$01,$02,$03,$01,$01,$03,$03,$00,$01,$01,$02,$02,$03,$03,$00

; ------------------------------------------------------------------------------

; [ init dialog text ]

InitDlgText:
@7f64:  stz     $0568       ; dialog flags
        stz     $c5         ; line number
        stz     $cc         ; dialog window region
        stz     $d3         ; keypress state
        stz     $c9         ; dialog pointer
        stz     $ca
        lda     #$cd
        sta     $cb
        stz     $056d       ; multiple choice selection is not changing
        stz     $056e       ; clear current multiple choice selection
        stz     $056f       ; clear maximum multiple choice selection
        stz     $0582       ; disable multiple choice cursor update
        stz     $d0         ; dialog index
        stz     $d1
        lda     #$80        ; text buffer is empty
        sta     $cf
        ldx     $00         ; set vram pointers to beginning of line 1
        stx     $c1
        stx     $c3
        stx     $0569       ; pause counter
        stx     $056b       ; keypress counter
        ldx     #$0700      ; unused
        stx     $c6
        lda     #$04        ; current x position on dialog window
        sta     $bf
        stz     $c0         ; width of current word
        lda     #$e0        ; max x position on dialog window
        sta     $c8
        ldx     #$9003      ; clear current character graphics buffer
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     #$0080
@7fb2:  stz     hWMDATA
        dex
        bne     @7fb2
        jsr     ClearTextGfxBuf
        jsr     ClearDlgTextVRAM
        rts

; ------------------------------------------------------------------------------

; [ update pointer to current dialog item ]

GetDlgPtr:
@7fbf:  lda     #^Dlg1                  ; bank byte
        sta     $cb
        longa
        lda     $d0                     ; dialog index
        asl
        tax
        lda     f:DlgPtrs,x             ; pointer to dialog item
        sta     $c9
        lda     $d0                     ; dialog index
        cmp     f:DlgBankInc            ; first dialog item in next bank
        bcc     @7fdc                   ; branch if less
        shorta0
        inc     $cb                     ; increment bank byte
@7fdc:  shorta0
        lda     #1                      ; enable dialog display
        sta     $0568
        rts

; ------------------------------------------------------------------------------

; [ display map name ]

ShowMapTitle:
@7fe5:  stz     $0567                   ; clear map name dialog counter
        lda     $1eb9
        and     #$40                    ; return if party switching is enabled
        bne     @7ff4
        lda     $0745                   ; return if map name dialog is disabled
        bne     @7ff8
@7ff4:  stz     $0745
        rts
@7ff8:  lda     #$64                    ; set counter to 100 frames
        sta     $0567
        lda     #^MapTitle              ; get pointer to map name
        sta     $cb
        lda     $0520
        asl
        tax
        longac
        lda     f:MapTitlePtrs,x
        adc     #.loword(MapTitle)
        sta     $c9
        shorta0
        stz     $c0                     ; clear width of current word
        ldy     $00
@8018:  lda     [$c9],y                 ; get next character
        beq     @8029                   ; branch if end of string
        tax
        lda     f:FontWidth,x           ; get character width
        clc
        adc     $c0                     ; add to width of current word
        sta     $c0
        iny                             ; next character
        bra     @8018
@8029:  lda     #$e0                    ; $bf = ($e0 - width) / 2
        sec                             ; text centered in dialog window
        sbc     $c0
        lsr
        sta     $bf
        tay                             ; $c1 = ($bf / 16) * 32
        sty     hWRDIVL                   ; pointer to vram, rounded down to nearest tile
        lda     #$10
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        sta     hWRMPYA
        lda     #$20
        sta     hWRMPYB
        nop3
        ldy     hRDMPYL
        sty     $c1
@8054:  jsr     UpdateDlgTextOneLine
        jsr     TfrMapTitleGfx
        lda     $0568                   ; branch until complete
        bpl     @8054
        stz     $d3                     ; keypress state
        stz     $cc                     ; text region (will not erase text)
        jsr     OpenMapTitleWindow
        rts

; ------------------------------------------------------------------------------

; [ calculate width of current word ]

; $c0 = calculated width

CalcTextWidth:
@8067:  lda     $cf         ; save text buffer position
        pha
        lda     $cb         ; save pointer to current dialog character
        pha
        ldx     $c9
        phx
        stz     $c0         ; width = 0
@8072:  ldy     $00
        lda     [$c9],y     ; load first letter
        bpl     @80b0       ; branch if not dte
        and     #$7f
        asl
        tax
        lda     $cf
        cmp     #$80
        beq     @8088
        lda     #$80
        sta     $cf
        bra     @809c
@8088:  lda     f:DTETbl,x   ; first dte letter
        cmp     #$7f
        beq     @80d2
        phx
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        plx
@809c:  lda     $c0dfa1,x   ; second dte letter
        cmp     #$7f
        beq     @80d2
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        bra     @80c6
@80b0:  ldy     $00
        lda     [$c9],y
        cmp     #$20
        bcc     @80dc       ; branch if a special letter
        cmp     #$7f
        beq     @80d2       ; return if a space
        tax
        lda     f:FontWidth,x   ; width += character width
        clc
        adc     $c0
        sta     $c0
@80c6:  inc     $c9         ; next character
        bne     @8072
        inc     $ca
        bne     @8072
        inc     $cb
        bra     @8072
@80d2:  plx                 ; restore dialog pointer and text buffer position and return
        stx     $c9
        pla
        sta     $cb
        pla
        sta     $cf
        rts
@80dc:  cmp     #$1a        ; branch if item name
        beq     @8118
        cmp     #$02        ; return if end of message or new line
        bcc     @80d2
        cmp     #$10        ; return if not a character name
        bcs     @80d2
        dec                 ; decrement to get character index
        dec
        sta     hWRMPYA
        lda     #$25        ; get pointer to character data
        sta     hWRMPYB
        lda     $cf         ; return if text buffer is not empty
        bpl     @80d2
        lda     #$06        ; six letters
        sta     $1a
        ldy     hRDMPYL
@80fd:  lda     $1602,y     ; get letter
        cmp     #$ff
        beq     @80d2       ; return if no letter
        sec
        sbc     #$60        ; convert to dialog text
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        iny                 ; next letter
        dec     $1a         ; return after 6 letters
        bne     @80fd
        bra     @80d2
@8118:  lda     $0583       ; item index
        sta     hWRMPYA
        lda     #$0d        ; get pointer to item name
        sta     hWRMPYB
        lda     $cf         ; return if text buffer is not empty
        bpl     @80d2
        lda     #$0c        ; 12 letters
        sta     $1a
        ldx     hRDMPYL
@812e:  txy
        lda     $d2b301,x   ; item name
        cmp     #$ff        ; return if no letter
        beq     @80d2
        sec
        sbc     #$60        ; convert to dialog text
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        tyx
        inx                 ; next letter
        dec     $1a         ; return after 12 letters
        bne     @812e
        bra     @80d2

; ------------------------------------------------------------------------------

; [ update dialog text ]

UpdateDlgText:
@814c:  longa
        lda     $00         ; set font shadow color to black
        sta     $7e7204
        sta     $7e7404
        lda     $1d55       ; set font color
        sta     $7e7202
        sta     $7e7402
        sta     $7e7206
        sta     $7e7406
        shorta0
        lda     $0567       ; decrement counter for map name dialog window
        beq     @817b
        dec     $0567
        bne     @817b
        jsr     CloseMapTitleWindow
@817b:  lda     $0568       ; dialog flags
        bne     @8181       ; return if there's no dialog text
        rts
@8181:  ldx     $0569       ; decrement counter for dialog pause
        beq     @818b
        dex
        stx     $0569
        rts
@818b:  ldx     $056b       ; keypress counter
        beq     @81af
        longa
        txa
        and     #$7fff
        tax
        shorta0
        cpx     $00
        bne     @81a8
        stz     $056c
        stz     $d3         ; keypress state
        stz     $056f
        bra     @81af
@81a8:  ldx     $056b
        dex
        stx     $056b
@81af:  lda     $d3         ; branch if waiting for keypress
        bne     @81b6
        jmp     @823b
@81b6:  lda     $056f       ; max multiple choice selection
        cmp     #$02
        bcc     @821f       ; branch if 1 or 0
        lda     $056e
        asl
        tax
        longa
        lda     $0570,x     ; set current cursor position (for erasing the indicator)
        sta     $c3
        shorta0
        lda     $07
        and     #$0f        ; branch if direction button is down
        bne     @81d7
        stz     $056d       ; multiple choice selection is not changing
        bra     @8209
@81d7:  lda     $056d       ; branch if multiple choice selection is already changing
        bne     @821f
        lda     $07
        and     #$0a        ; branch if up and left are not pressed
        beq     @81f2
        lda     $056e       ; decrement multiple choice selection
        dec
        bmi     @8209       ; branch if less than zero (no change)
        sta     $056e
        lda     #$01        ; multiple choice selection is changing
        sta     $056d
        bra     @8209
@81f2:  lda     $07
        and     #$05        ; branch if up and left are not pressed
        beq     @8209
        lda     $056e       ; increment multiple choice selection
        inc
        cmp     $056f       ; branch if equal to max selection (no change)
        beq     @8209
        sta     $056e
        lda     #$01        ; multiple choice selection is changing
        sta     $056d
@8209:  jsr     DrawDlgCursor
        lda     $056e       ; current selection
        asl
        tax
        longa
        lda     $0570,x     ; position of multiple choice indicator
        sta     $0580       ; set current
        shorta0
        inc     $0582       ; enable update
@821f:  lda     $d3         ; keypress state
        cmp     #$01
        beq     @822d       ; branch if waiting for keypress
        lda     $06         ; a button
        bmi     @8241       ; decrement keypress and branch if not pressed
        dec     $d3
        bra     @8241
@822d:  lda     $06         ; return if a button not pressed
        bpl     @8241
        dec     $d3         ; decrement keypress state
        stz     $056f       ; disable multiple choice
        stz     $056c       ; disable keypress timer
        bra     @8241       ; return
@823b:  lda     $cc         ; decrement region to clear (getting ready for next page)
        beq     @8242
        dec     $cc
@8241:  rts
@8242:  lda     $0568       ; dialog flags
        bpl     UpdateDlgTextOneLine
        sta     $ba
        stz     $0568
        rts

UpdateDlgTextOneLine:
@824d:  jsr     CalcTextWidth
        lda     $bf         ; add width to current x position
        clc
        adc     $c0
        bcs     @825b       ; branch if it overflowed
        cmp     $c8
        bcc     @825f       ; branch if less than max width
@825b:  jsr     NewLine
        rts
@825f:  lda     $cf         ; branch if text buffer is empty
        bmi     @8284
@8263:  lda     $cf
        tax
        lda     $7e9183,x   ; text buffer
        sta     $cd         ; set next letter to display
        stz     $ce
        lda     $7e9184,x   ; branch if next letter is the end of the string
        beq     @827a
        jsr     DrawDlgText
        inc     $cf         ; increment text buffer position and return
        rts
@827a:  lda     #$80        ; empty dialog text buffer
        sta     $cf
        jsr     DrawDlgText
        jmp     @829d       ; increment dialog pointer by 1
@8284:  ldy     $00
        lda     [$c9],y     ; load current dialog letter
        sta     $bd
        iny
        lda     [$c9],y     ; load next dialog letter
        sta     $be
        lda     $bd         ; branch if current letter is dte
        bmi     @829a
        cmp     #$20        ; branch if special letter
        bcc     @82b5
        jmp     @845a
@829a:  jmp     @8466

; increment dialog pointer
@829d:  lda     #$01        ; increment by 1
        bra     @82a3
@82a1:  lda     #$02        ; increment by 2
@82a3:  clc
        adc     $c9
        sta     $c9
        lda     $ca
        adc     #$00
        sta     $ca
        lda     $cb
        adc     #$00
        sta     $cb
        rts

; special letter $00: end of message
@82b5:  cmp     #$00
        bne     @82c2
        jsr     NewPage
        lda     #$80
        sta     $0568
        rts

; special letter $01: new line
@82c2:  cmp     #$01
        bne     @82cc
        jsr     NewLine
        jmp     @829d       ; increment dialog pointer by 1

; special letter $02-$0f: character name
@82cc:  cmp     #$10
        bcs     @8302
        dec2
        sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        ldx     $00
@82e3:  lda     $1602,y
        sec
        sbc     #$60
        sta     $7e9183,x
        cmp     #$9f
        beq     @82f8
        iny
        inx
        cpx     #$0006
        bne     @82e3
@82f8:  tdc
        sta     $7e9183,x
        stz     $cf
        jmp     @8263

; special letter $10: pause for 1 second
@8302:  cmp     #$10
        bne     @830f
        ldx     #$003c      ; 60 frames
        stx     $0569
        jmp     @829d       ; increment dialog pointer by 1

; special letter $11: pause for x/4 seconds
@830f:  cmp     #$11
        bne     @832a
        lda     $be
        sta     hWRMPYA
        lda     #$0f        ; divide by 15
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        stx     $0569
        jmp     @82a1       ; increment dialog pointer by 2

; special letter $12: wait for keypress
@832a:  cmp     #$12
        bne     @8337
        ldx     #$8001      ; waiting for keypress, timer is 1 frame only
        stx     $056b
        jmp     @829d       ; increment dialog pointer by 1

; special letter $13: new page
@8337:  cmp     #$13
        bne     @8341
        jsr     NewPage
        jmp     @829d       ; increment dialog pointer by 1

; special letter $14: tab (x spaces)
@8341:  cmp     #$14
        bne     @8362
        lda     $be         ; number of spaces
        sta     $1e
        stz     $1f
        ldx     $00
        lda     #$7f        ; space
@834f:  sta     $7e9183,x
        inx
        cpx     $1e
        bne     @834f
        tdc                 ; end of string
        sta     $7e9183,x
        stz     $cf
        jmp     @829d       ; increment dialog pointer by 1

; special letter $15: multiple choice indicator
@8362:  cmp     #$15
        bne     @837f
        lda     $056f       ; maximum multiple choice position found so far
        asl
        tay
        longa
        lda     $c1         ; set current position as a new multiple choice position
        sta     $0570,y
        shorta0
        lda     #$ff        ; wide space
        sta     $bd
        inc     $056f       ; increment number of multiple choice positions
        jmp     @845a       ; process like a normal letter

; special letter $16: pause for x/4 seconds, then wait for keypress
@837f:  cmp     #$16
        bne     @83a4
        lda     $be
        sta     hWRMPYA
        lda     #$0f
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        ora     #$8000
        sta     $056b
        shorta0
        lda     #$01        ; waiting for keypress
        sta     $d3
        jmp     @82a1

; special letter $19: gold quantity
@83a4:  cmp     #$19
        bne     @83d3
        stz     $1a
        ldx     $00
        txy
@83ad:  lda     $1a
        bne     @83b8
        lda     $0755,y
        beq     @83c3
        inc     $1a
@83b8:  lda     $0755,y
        clc
        adc     #$54
        sta     $7e9183,x
        inx
@83c3:  iny
        cpy     #$0007
        bne     @83ad
        tdc
        sta     $7e9183,x
        stz     $cf
        jmp     @8263

; special letter $1a: item name
@83d3:  cmp     #$1a
        bne     @840f
        lda     $0583
        sta     hWRMPYA
        lda     #$0d
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
        lda     #$7e
        pha
        plb
@83ee:  lda     $d2b301,x   ; load item name (ignore symbol)
        sec
        sbc     #$60
        sta     $9183,y
        cmp     #$9f
        beq     @8403
        inx
        iny
        cpy     #$000c
        bne     @83ee
@8403:  tdc
        sta     $9183,y
        tdc
        pha
        plb
        stz     $cf
        jmp     @8263

; special letter $1b: spell name
@840f:  cmp     #$1b
        bne     @844b
        lda     $0584
        sta     hWRMPYA
        lda     #$04        ; multiply by 4 (this is carried over from ff6j, it should be 7 for ff3us)
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
        lda     #$7e
        pha
        plb
@842a:  lda     $e6f568,x   ; load spell name (ignore symbol)
        sec                 ; subtract $60 to convert battle text to dialog text
        sbc     #$60
        sta     $9183,y     ; store in buffer
        cmp     #$9f        ; break if $ff was reached
        beq     @843f
        inx
        iny
        cpy     #$0004      ; copy up to 4 bytes (should be 7)
        bne     @842a
@843f:  tdc
        sta     $9183,y     ; store $00 in the last byte
        tdc
        pha
        plb
        stz     $cf
        jmp     @8263

; special letter $1c-$1f: extra japanese characters (unused)
@844b:  sec
        sbc     #$1b
        sta     $ce
        lda     $be
        sta     $cd
        jsr     DrawDlgText
        jmp     @82a1       ; increment dialog pointer by 2

; $20-$7f: normal letter
@845a:  lda     $bd
        sta     $cd
        stz     $ce
        jsr     DrawDlgText
        jmp     @829d       ; increment dialog pointer by 1

; $80-$ff: dte
@8466:  and     #$7f
        asl
        tay
        ldx     #.loword(DTETbl)      ; pointer to dte table
        stx     $2a
        lda     #^DTETbl
        sta     $2c
        lda     [$2a],y
        sta     $7e9183     ; store first byte in text buffer
        iny
        lda     [$2a],y
        sta     $7e9184     ; store second byte in text buffer
        tdc
        sta     $7e9185     ; end of string
        stz     $cf         ; set text position to 0
        jmp     @8263       ; write both letters

; ------------------------------------------------------------------------------

; [ load dialog font widths ]

InitDlgVWF:
@848a:  lda     #$7e        ; set wram address
        sta     hWMADDH
        ldx     #$9e00
        stx     hWMADDL
        ldx     $00
@8497:  lda     f:FontWidth,x   ; copy widths for letters $00-$7f
        sta     hWMDATA
        inx
        cpx     #$0080
        bne     @8497
        ldx     #.loword(DTETbl)      ; set a pointer to the dte table
        stx     $2a
        lda     #^DTETbl
        sta     $2c
        ldx     $00
        txy
@84b0:  stz     $1a
        lda     [$2a],y
        tax
        lda     f:FontWidth,x   ; get the width of the first letter
        sta     $1a
        iny
        lda     [$2a],y
        tax
        lda     f:FontWidth,x   ; add the width of the second letter
        clc
        adc     $1a
        sta     hWMDATA       ; store in wram
        iny
        cpy     #$0100
        bne     @84b0
        rts

; ------------------------------------------------------------------------------

; [ update dialog text graphics ]

DrawDlgText:
@84d0:  ldx     $cd         ; letter number
        lda     f:FontWidth,x   ; letter width
        clc
        adc     $bf         ; add to current x position
        cmp     $c8
        bcc     @84e1       ; branch if less than max position
        jsr     NewLine
        rts
@84e1:  jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        ldx     $c1         ; set vram tile address
        stx     $c3
        inc     $c5         ; text graphics needs to get copied
        ldx     $cd         ; letter index
        lda     $bf         ; x position
        and     #$0f
        clc
        adc     f:FontWidth,x   ; add letter width
        and     #$f0
        beq     @850e       ; branch if it hasn't reached the next tile
        jsr     ShiftPrevLetter
        longac
        lda     $c1         ; increment tile vram pointer
        adc     #$0020
        sta     $c1
        shorta0
@850e:  ldx     $cd         ; letter index
        lda     $bf         ; x position
        clc
        adc     f:FontWidth,x   ; add letter width
        sta     $bf         ; set new x position
        rts

; ------------------------------------------------------------------------------

; [ new line ]

NewLine:
@851a:  lda     #$ff        ; new line ($00ff)
        sta     $cd
        stz     $ce
        jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        lda     #$04        ; set x position back to the left (carriage return)
        sta     a:$00bf
        longac
        lda     $c1         ; set tile vram address
        sta     $c3
        and     #$0600      ; set current vram position to the beginning of the next line
        adc     #$0200
        and     #$07ff
        sta     $c1
        shorta0
        inc     $c5         ; text graphics needs to get copied
        jsr     ClearTextGfxBuf
        ldx     $c1         ; return unless end of page was reached (end of line 4)
        bne     @8553
        lda     #$09        ; text fully displayed
        sta     $cc
        lda     #$02        ; waiting for key release
        sta     $d3
@8553:  rts

; ------------------------------------------------------------------------------

; [ new page ]

NewPage:
@8554:  lda     #$ff        ; new line ($00ff)
        sta     $cd
        stz     $ce
        jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        lda     #$04        ; set x position back to the left (carriage return)
        sta     a:$00bf
        ldx     $c1         ; set tile vram address
        stx     $c3
        inc     $c5         ; text graphics needs to get copied
        ldx     $00
        stx     $c1         ; set current vram position to the top of the page
        jsr     ClearTextGfxBuf
        lda     #$09        ; text fully displayed
        sta     $cc
        lda     #$02        ; waiting for key release
        sta     $d3
        rts

; ------------------------------------------------------------------------------

; [ clear all dialog text graphics in vram ]

ClearDlgTextVRAM:
@857e:  stz     hMDMAEN
        ldx     #$3800
        stx     hVMADDL
        lda     #$80
        sta     hVMAINC
        lda     #$09
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$0000
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$1000      ; clear $3800-$3fff in vram
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ clear dialog text graphics region in vram ]

ClearDlgTextRegion:
@85b0:  lda     $cc         ; current dialog text region to clear
        beq     @85f2
        cmp     #$09        ; return if none
        beq     @85f2
        dec
        asl
        tax
        longa
        lda     $c085f3,x   ; set vram address
        sta     hVMADDL
        shorta0
        stz     hMDMAEN     ; disable dma
        lda     #$80
        sta     hVMAINC     ; clear $01c0 bytes (copy from $00)
        lda     #$09
        sta     $4300       ; fixed address dma to $2118
        lda     #$18
        sta     $4301
        ldx     #$0000
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$01c0      ; 7 tiles (32x32, 2bpp)
        stx     $4305
        lda     #$01
        sta     hMDMAEN
@85f2:  rts

; ------------------------------------------------------------------------------

; pointers to dialog text regions in vram
@85f3:  .word   $3ee0, $3e00, $3ce0, $3c00, $3ae0, $3a00, $38e0, $3800

; ------------------------------------------------------------------------------

; [ copy dialog text graphics to vram ]

TfrDlgTextGfx:
@8603:  lda     $c5         ; return if there is no tile to be copied
        beq     _8641
        stz     $c5

TfrMapTitleGfx:
@8609:  stz     hMDMAEN
        lda     #$80        ; vram control register
        sta     hVMAINC
        longac
        lda     $c3         ; vram destination
        adc     #$3800
        sta     hVMADDL
        shorta0
        lda     #$41        ; dma control register
        sta     $4300
        lda     #$18        ; dma destination register
        sta     $4301
        ldx     #$9083      ; dma source address
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0040      ; dma size (four 2bpp tiles)
        stx     $4305
        lda     #$01
        sta     hMDMAEN
_8641:  rts

; ------------------------------------------------------------------------------

; [ copy dialog text graphics to vram buffer ]

; copies one 16x16 tile per frame

CopyDlgTextToBuf:
@8642:  lda     #$7e
        pha
        plb
        stz     $9083       ; left two 8x8 tiles, top 4 rows of pixels are always blank
        stz     $9084
        stz     $9085
        stz     $9086
        stz     $9087
        stz     $9088
        stz     $9089
        stz     $908a
        lda     $9104       ; copy left half of tiles
        sta     $908b       ; bp 1-2
        lda     $9144
        sta     $908c       ; bp 3-4
        lda     $9106
        sta     $908d
        lda     $9146
        sta     $908e
        lda     $9108
        sta     $908f
        lda     $9148
        sta     $9090
        lda     $910a
        sta     $9091
        lda     $914a
        sta     $9092
        lda     $910c
        sta     $9093
        lda     $914c
        sta     $9094
        lda     $910e
        sta     $9095
        lda     $914e
        sta     $9096
        lda     $9110
        sta     $9097
        lda     $9150
        sta     $9098
        lda     $9112
        sta     $9099
        lda     $9152
        sta     $909a
        lda     $9114
        sta     $909b
        lda     $9154
        sta     $909c
        lda     $9116
        sta     $909d
        lda     $9156
        sta     $909e
        lda     $9118
        sta     $909f
        lda     $9158
        sta     $90a0
        lda     $911a
        sta     $90a1
        lda     $915a
        sta     $90a2
        stz     $90a3       ; right two 8x8 tiles, top 4 rows of pixels are always blank
        stz     $90a4
        stz     $90a5
        stz     $90a6
        stz     $90a7
        stz     $90a8
        stz     $90a9
        stz     $90aa
        lda     $9103       ; copy right half of tiles
        sta     $90ab
        lda     $9143
        sta     $90ac
        lda     $9105
        sta     $90ad
        lda     $9145
        sta     $90ae
        lda     $9107
        sta     $90af
        lda     $9147
        sta     $90b0
        lda     $9109
        sta     $90b1
        lda     $9149
        sta     $90b2
        lda     $910b
        sta     $90b3
        lda     $914b
        sta     $90b4
        lda     $910d
        sta     $90b5
        lda     $914d
        sta     $90b6
        lda     $910f
        sta     $90b7
        lda     $914f
        sta     $90b8
        lda     $9111
        sta     $90b9
        lda     $9151
        sta     $90ba
        lda     $9113
        sta     $90bb
        lda     $9153
        sta     $90bc
        lda     $9115
        sta     $90bd
        lda     $9155
        sta     $90be
        lda     $9117
        sta     $90bf
        lda     $9157
        sta     $90c0
        lda     $9119
        sta     $90c1
        lda     $9159
        sta     $90c2
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ copy multiple choice indicator graphics to vram buffer ]

DrawDlgCursor:
@879a:  ldx     #$9083
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
.repeat 8
        stz     hWMDATA
.endrep
        ldx     $00
        txy
@87c0:  lda     f:DlgCursorGfx,x
        sta     hWMDATA
        lsr
        sta     hWMDATA
        inx
        cpx     #12
        bne     @87c0
.repeat 32
        stz     hWMDATA
.endrep
        rts

; ------------------------------------------------------------------------------

; multiple choice indicator graphics
DlgCursorGfx:
@8832:  .byte   $20,$30,$38,$3c,$3e,$3f,$3e,$3c,$38,$30,$20,$00

; ------------------------------------------------------------------------------

; [ copy multiple choice indicator graphics to vram ]

TfrDlgCursorGfx:
@883e:  lda     $0582
        beq     @88a8
        stz     $0582
        lda     #$80
        sta     hVMAINC
        stz     hMDMAEN
        longac
        lda     $c3         ; old cursor position
        adc     #$3800
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$90a3
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0020
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        longac
        lda     $0580       ; multiple choice position
        adc     #$3800
        sta     hVMADDL
        shorta0
        ldx     #$9083
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0020
        stx     $4305
        lda     #$01
        sta     hMDMAEN
@88a8:  rts

; ------------------------------------------------------------------------------

; [ clear text graphics buffer ]

ClearTextGfxBuf:
@88a9:  lda     #$7e
        sta     hWMADDH
        ldx     #$9103      ; clear $9103-$9182
        stx     hWMADDL
        ldx     #$0010
@88b7:
.repeat 8
        stz     hWMDATA
.endrep
        dex
        bne     @88b7
        rts

; ------------------------------------------------------------------------------

; [ copy letter graphics to text graphics buffer ]

DrawLetter:
@88d3:  lda     #$7e
        pha
        plb
        lda     a:$00bf       ; branch if on an even tile
        and     #$08
        beq     @88e1
        jmp     @8924
@88e1:  ldx     $00
@88e3:  lda     $9104,x     ; copy left part of letter buffer to left part of tile
        ora     $9004,x
        sta     $9104,x
        lda     $9103,x     ; copy middle part of letter buffer to middle part of tile
        ora     $9003,x
        sta     $9103,x
        lda     $9124,x     ; copy right part of letter buffer to right part of tile
        ora     $9024,x
        sta     $9124,x
        lda     $9144,x     ; repeat for bpp 3-4
        ora     $9044,x
        sta     $9144,x
        lda     $9143,x
        ora     $9043,x
        sta     $9143,x
        lda     $9164,x
        ora     $9064,x
        sta     $9164,x
        inx2
        cpx     #$0020
        bne     @88e3
        tdc
        pha
        plb
        rts
@8924:  ldx     $00
@8926:  lda     $9103,x     ; copy left part of letter to middle part of tile
        ora     $9004,x
        sta     $9103,x
        lda     $9124,x     ; copy middle part of letter to right part of tile
        ora     $9003,x
        sta     $9124,x
        lda     $9123,x     ; copy right part of letter to far right part of tile
        ora     $9024,x
        sta     $9123,x
        lda     $9143,x     ; repeat for bpp 3-4
        ora     $9044,x
        sta     $9143,x
        lda     $9164,x
        ora     $9043,x
        sta     $9164,x
        lda     $9163,x
        ora     $9064,x
        sta     $9163,x
        inx2
        cpx     #$0020
        bne     @8926
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ copy next tile to current tile ]

ShiftPrevLetter:
@8967:  lda     #$7e
        pha
        plb
        ldx     $00
@896d:  lda     $9123,x
        sta     $9103,x
        lda     $9163,x
        sta     $9143,x
        tdc
        sta     $9123,x     ; clear next tile
        sta     $9163,x
        inx
        cpx     #$0020
        bne     @896d
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load letter graphics ]

LoadLetterGfx:

@FontGfx := FontGfxLarge-32*22          ; skip first 32 tiles

@898a:  lda     #$7e                    ; clear next letter graphics
        sta     hWMADDH
        ldx     #$9023
        stx     hWMADDL
.repeat 24
        stz     hWMDATA
.endrep
        ldx     #$9063
        stx     hWMADDL
.repeat 24
        stz     hWMDATA
.endrep
        longa
        lda     $cd                     ; x = letter number * 22
        asl
        sta     $1e
        asl
        sta     $20
        asl2
        clc
        adc     $1e
        clc
        adc     $20
        tax
        shorta0
        lda     #$7e
        pha
        plb
        lda     a:$00bf                 ; current x position of text
        and     #$07                    ; get position within 8x8 tile
        cmp     #$04
        bne     @8a51                   ; branch if not 4 (halfway through tile)
        jmp     @8b23
@8a51:  bcc     @8a56                   ; branch if less than 4
        jmp     @8b42
@8a56:  eor     $02                     ; letter needs to shift left
        clc
        adc     #$05
        sta     $1e                     ; +$1e = 4 - x
        stz     $1f
        longa
        ldy     $1e
        lda     f:@FontGfx,x            ; letter graphics (first row of pixels)
@8a67:  asl                             ; shift left
        dey
        bne     @8a67
        sta     $9003                   ; move to buffer
        lsr
        sta     $9045                   ; shadow
        ldy     $1e
        lda     f:@FontGfx+2,x          ; next line
@8a78:  asl
        dey
        bne     @8a78
        sta     $9005
        lsr
        sta     $9047
        ldy     $1e
        lda     f:@FontGfx+4,x
@8a89:  asl
        dey
        bne     @8a89
        sta     $9007
        lsr
        sta     $9049
        ldy     $1e
        lda     f:@FontGfx+6,x
@8a9a:  asl
        dey
        bne     @8a9a
        sta     $9009
        lsr
        sta     $904b
        ldy     $1e
        lda     f:@FontGfx+8,x
@8aab:  asl
        dey
        bne     @8aab
        sta     $900b
        lsr
        sta     $904d
        ldy     $1e
        lda     f:@FontGfx+10,x
@8abc:  asl
        dey
        bne     @8abc
        sta     $900d
        lsr
        sta     $904f
        ldy     $1e
        lda     f:@FontGfx+12,x
@8acd:  asl
        dey
        bne     @8acd
        sta     $900f
        lsr
        sta     $9051
        ldy     $1e
        lda     f:@FontGfx+14,x
@8ade:  asl
        dey
        bne     @8ade
        sta     $9011
        lsr
        sta     $9053
        ldy     $1e
        lda     f:@FontGfx+16,x
@8aef:  asl
        dey
        bne     @8aef
        sta     $9013
        lsr
        sta     $9055
        ldy     $1e
        lda     f:@FontGfx+18,x
@8b00:  asl
        dey
        bne     @8b00
        sta     $9015
        lsr
        sta     $9057
        ldy     $1e
        lda     f:@FontGfx+20,x
@8b11:  asl
        dey
        bne     @8b11
        sta     $9017
        lsr
        sta     $9059
        shorta0
        tdc
        pha
        plb
        rts
@8b23:  longa                           ; letter doesn't need to shift
        ldy     $00
@8b27:  lda     f:@FontGfx,x            ; letter graphics
        sta     $9003,y
        lsr
        sta     $9045,y                 ; shadow
        inx2
        iny2
        cpy     #$0016                  ; 22 bytes
        bne     @8b27
        shorta0
        tdc
        pha
        plb
        rts
@8b42:  sec                             ; letter needs to shift right
        sbc     #$04
        sta     $1e                     ; +$1e = x - 4
        stz     $1f
        longa
        ldy     $1e
        lda     f:@FontGfx,x            ; letter graphics
@8b51:  lsr
        ror     $9023
        dey
        bne     @8b51
        sta     $9003
        lsr
        sta     $9045
        lda     $9023
        ror
        sta     $9065
        ldy     $1e
        lda     f:@FontGfx+2,x
@8b6c:  lsr
        ror     $9025
        dey
        bne     @8b6c
        sta     $9005
        lsr
        sta     $9047
        lda     $9025
        ror
        sta     $9067
        ldy     $1e
        lda     f:@FontGfx+4,x
@8b87:  lsr
        ror     $9027
        dey
        bne     @8b87
        sta     $9007
        lsr
        sta     $9049
        lda     $9027
        ror
        sta     $9069
        ldy     $1e
        lda     f:@FontGfx+6,x
@8ba2:  lsr
        ror     $9029
        dey
        bne     @8ba2
        sta     $9009
        lsr
        sta     $904b
        lda     $9029
        ror
        sta     $906b
        ldy     $1e
        lda     f:@FontGfx+8,x
@8bbd:  lsr
        ror     $902b
        dey
        bne     @8bbd
        sta     $900b
        lsr
        sta     $904d
        lda     $902b
        ror
        sta     $906d
        ldy     $1e
        lda     f:@FontGfx+10,x
@8bd8:  lsr
        ror     $902d
        dey
        bne     @8bd8
        sta     $900d
        lsr
        sta     $904f
        lda     $902d
        ror
        sta     $906f
        ldy     $1e
        lda     f:@FontGfx+12,x
@8bf3:  lsr
        ror     $902f
        dey
        bne     @8bf3
        sta     $900f
        lsr
        sta     $9051
        lda     $902f
        ror
        sta     $9071
        ldy     $1e
        lda     f:@FontGfx+14,x
@8c0e:  lsr
        ror     $9031
        dey
        bne     @8c0e
        sta     $9011
        lsr
        sta     $9053
        lda     $9031
        ror
        sta     $9073
        ldy     $1e
        lda     f:@FontGfx+16,x
@8c29:  lsr
        ror     $9033
        dey
        bne     @8c29
        sta     $9013
        lsr
        sta     $9055
        lda     $9033
        ror
        sta     $9075
        ldy     $1e
        lda     f:@FontGfx+18,x
@8c44:  lsr
        ror     $9035
        dey
        bne     @8c44
        sta     $9015
        lsr
        sta     $9057
        lda     $9035
        ror
        sta     $9077
        ldy     $1e
        lda     f:@FontGfx+20,x
@8c5f:  lsr
        ror     $9037
        dey
        bne     @8c5f
        sta     $9017
        lsr
        sta     $9059
        lda     $9037
        ror
        sta     $9079
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; pointers to unused dialog strings
@8c7b:  .word   $8cab,$8cae,$8cb3,$8cb6,$8cb9,$8cbe,$8cc1,$8cc4
        .word   $8cc9,$8ccc,$8cd6,$8cde,$8ce1,$8ce4,$8ce9,$8cf1
        .word   $8cf4,$8cf9,$8cfe,$8d04,$8d08,$8d0b,$8d0f,$8d12

; dialog strings carried over from ff6j (unused)
@8cab:  .byte   $c7,$c7,$00
        .byte   $1f,$f9,$1f,$f8,$00
        .byte   $bd,$85,$00
        .byte   $bd,$7f,$00
        .byte   $1e,$9f,$1e,$af,$00
        .byte   $93,$8d,$00
        .byte   $77,$85,$00
        .byte   $1c,$00,$1d,$ed,$00
        .byte   $85,$8d,$00
        .byte   $1f,$2a,$1f,$78,$1f,$86,$1f,$a6,$d0,$00
        .byte   $1f,$70,$1f,$64,$1f,$6a,$d0,$00
        .byte   $6b,$a7,$00
        .byte   $73,$9b,$00
        .byte   $1e,$da,$1c,$03,$00
        .byte   $1f,$20,$1f,$92,$1f,$b8,$d0,$00
        .byte   $b9,$3f,$00
        .byte   $1c,$04,$1e,$0d,$00
        .byte   $45,$33,$35,$ab,$00
        .byte   $1f,$76,$1f,$46,$d0,$00
        .byte   $9b,$1d,$e6,$00
        .byte   $37,$bf,$00
        .byte   $85,$6f,$ad,$00
        .byte   $3f,$d2,$00
        .byte   $1e,$23,$1e,$01,$00

; ------------------------------------------------------------------------------

; [ init palette animation ]

InitPalAnim:
@8d17:  lda     $053a
        bne     @8d1d
        rts
@8d1d:  dec
        sta     hWRMPYA
        lda     #$0c
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
@8d2e:  lda     $c09825,x   ; palette animation data
        sta     $10ea,y
        lda     $c09826,x
        sta     $10e8,y
        lda     $c09827,x
        sta     $10eb,y
        lda     $c09828,x
        sta     $10ec,y
        lda     $c09829,x
        sta     $10ed,y
        lda     $c0982a,x
        sta     $10ee,y
        lda     #$00
        sta     $10e7,y
        sta     $10e9,y
        longac
        txa
        adc     #$0006
        tax
        shorta0
        tya
        clc
        adc     #$08
        tay
        cmp     #$10
        bne     @8d2e
        rts

; ------------------------------------------------------------------------------

; [ update palette animation ]

UpdatePalAnim:
@8d74:  lda     $053a       ; palette animation index
        beq     @8dc7
        ldy     $00
@8d7b:  lda     $10ea,y     ; palette animation type
        bmi     @8dbb
        and     #$f0
        lsr4
        bne     @8d92

; 0 (counter only)
        jsr     IncPalAnimCounter
        cmp     #0
        bne     @8dbb       ; branch if no reset
        jmp     @8dbb       ; branch anyway
@8d92:  dec
        bne     @8da2

; 1 (cycle)
        jsr     IncPalAnimCounter
        cmp     #0
        bne     @8dbb
        jsr     UpdatePalAnimCycle
        jmp     @8dbb

; 2 (rom)
@8da2:  dec
        bne     @8db0
        jsr     IncPalAnimCounter
        phy
        jsr     LoadPalAnimColors
        ply
        jmp     @8dbb
@8db0:  dec
        bne     @8dbb

; 3 (pulse)
        jsr     IncPalAnimCounter
        phy
        jsr     UpdatePalAnimPulse
        ply
@8dbb:  tya
        clc
        adc     #$08
        tay
        cmp     #$10
        beq     @8dc7
        jmp     @8d7b
@8dc7:  rts

; ------------------------------------------------------------------------------

; [ update palette animation counters ]

IncPalAnimCounter:
@8dc8:  lda     $10e7,y     ; increment frame counter
        inc
        sta     $10e7,y
        cmp     $10e8,y
        bne     @8def
        lda     #$00
        sta     $10e7,y
        lda     $10e9,y     ; increment color counter
        inc
        sta     $10e9,y
        lda     $10ea,y
        and     #$0f
        cmp     $10e9,y
        bne     @8def
        tdc                 ; return 0 for reset
        sta     $10e9,y
        rts
@8def:  lda     #$01        ; return 1 for no reset
        rts

; ------------------------------------------------------------------------------

_c08df2:
@8df2:  .byte   $70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0
        .byte   $e0,$d0,$c0,$b0,$a0,$90,$80,$70,$60

; ------------------------------------------------------------------------------

; [ update palette animation (pulse) ]

UpdatePalAnimPulse:
@8e04:  lda     $10e9,y
        tax
        lda     f:_c08df2,x
        sta     hWRMPYA
        lda     $10eb,y
        tax
        lda     $10ec,y
        inc2
        tay
@8e19:  lda     $7e7200,x
        and     #$1f
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        and     #$1f
        sta     $1e
        lda     $7e7201,x
        and     #$7c
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        and     #$7c
        sta     $1f
        longa
        lda     $7e7200,x
        and     #$03e0
        lsr2
        shorta
        sta     hWRMPYB
        nop3
        lda     hRDMPYH
        and     #$f8
        longa
        asl2
        ora     $1e
        sta     $7e7400,x
        shorta0
        inx2
        dey2
        bne     @8e19
        rts

; ------------------------------------------------------------------------------

; [ load colors from ROM for palette animation ]

LoadPalAnimColors:
@8e6b:  lda     $10eb,y
        clc
        adc     #$00
        sta     $2a
        lda     #$74
        sta     $2b
        lda     #$7e
        sta     $2c
        lda     $10e9,y
        longa
        asl5
        clc
        adc     $10ed,y     ; rom color offset
        tax
        shorta0
        lda     $10ec,y
        tay
        iny2
        longa
@8e95:  lda     $e6f200,x   ; palette animation color palette
        sta     [$2a]
        inc     $2a
        inc     $2a
        inx2
        dey2
        bne     @8e95
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update palette animation (cycle) ]

UpdatePalAnimCycle:
@8ea9:  lda     $10eb,y
        tax
        clc
        adc     $10ec,y
        sta     $20
        stz     $21
        longa
        lda     $7e7400,x
        sta     $1e
@8ebd:  lda     $7e7402,x
        sta     $7e7400,x
        inx2
        cpx     $20
        bne     @8ebd
        lda     $1e
        sta     $7e7400,x
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init bg animation ]

InitBGAnim:
@8ed5:  jsr     InitBG12Anim
        jsr     InitBG3Anim
        rts

; ------------------------------------------------------------------------------

; [ init bg1/bg2 animation ]

InitBG12Anim:
@8edc:  lda     $053b                   ; bg1/bg2 animation index
        and     #$1f
        asl
        tax
        longa
        lda     f:MapBGAnimPropPtrs,x
        tax
        shorta0
        ldy     $00
@8eef:  lda     #$e6
        sta     $106d,y                 ; graphics bank = $e6
        longac
        tdc
        sta     $1069,y                 ; clear animation counter
        lda     f:MapBGAnimProp,x         ; animation speed
        sta     $106b,y
        lda     f:MapBGAnimProp+2,x       ; frame 1 pointer
        sta     $106e,y
        lda     f:MapBGAnimProp+4,x       ; frame 2 pointer
        sta     $1070,y
        lda     f:MapBGAnimProp+6,x       ; frame 3 pointer
        sta     $1072,y
        lda     f:MapBGAnimProp+8,x       ; frame 4 pointer
        sta     $1074,y
        txa
        adc     #10                     ; next tile (8 tiles total)
        tax
        tya
        adc     #$000d
        tay
        shorta0
        cpy     #$0068
        bne     @8eef
        lda     #$10                    ; $1a = tile counter (16 tiles, last 8 don't get animated)
        sta     $1a
        ldy     #$9f00                  ; destination address = $7e9f00
        sty     hWMADDL
        lda     #$7e
        sta     hWMADDH
        lda     $053b                   ; bg1/bg2 animation index
        and     #$1f
        asl
        tax
        longa
        lda     f:MapBGAnimPropPtrs,x
        tay
        shorta0
@8f4f:  tyx
        longac
        lda     f:MapBGAnimProp+2,x     ; frame 1 pointer
        tax
        shorta0
        lda     #$80                    ; $1b = tile graphics counter (4 frames per tile, 32 bytes per frame)
        sta     $1b
@8f5e:  lda     f:MapAnimGfx,x          ; copy tile graphics to ram
        sta     hWMDATA
        inx
        dec     $1b
        bne     @8f5e
        longa
        tya
        clc
        adc     #$000a
        tay
        shorta0
        dec     $1a
        bne     @8f4f
        stz     hHDMAEN                 ; dma graphics to vram
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$2800                  ; destination = $2800 vram
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$9f00                  ; source = $7e9f00
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0800                  ; size = $0800
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ init bg3 animation ]

InitBG3Anim:
@8fb1:  lda     $053b                   ; bg3 animation index
        and     #$e0
        lsr5
        bne     @8fbe                   ; return if not valid
        rts
@8fbe:  dec
        tay
        asl
        tax
        longa
        lda     f:MapBG3AnimPropPtrs,x
        tax
        tdc
        sta     $10d1                   ; clear animation counter
        lda     f:MapBG3AnimProp,x        ; animation speed
        sta     $10d3
        lda     f:MapBG3AnimProp+2,x      ; size
        sta     $10d5
        lda     f:MapBG3AnimProp+4,x      ; frame 1 pointer
        sta     $10d7
        lda     f:MapBG3AnimProp+6,x      ; frame 2 pointer
        sta     $10d9
        lda     f:MapBG3AnimProp+8,x      ; frame 3 pointer
        sta     $10db
        lda     f:MapBG3AnimProp+10,x     ; frame 4 pointer
        sta     $10dd
        lda     f:MapBG3AnimProp+12,x     ; frame 5 pointer
        sta     $10df
        lda     f:MapBG3AnimProp+14,x     ; frame 6 pointer
        sta     $10e1
        lda     f:MapBG3AnimProp+16,x     ; frame 7 pointer
        sta     $10e3
        lda     f:MapBG3AnimProp+18,x     ; frame 8 pointer
        sta     $10e5
        shorta0
        tya
        sta     $1a
        asl
        clc
        adc     $1a
        tax
        longac
        lda     f:MapAnimGfxBG3Ptrs,x   ; pointer to bg3 animation graphics (+$e6cdc0)
        clc
        adc     #.loword(MapAnimGfxBG3)
        sta     $f3
        shorta0
        lda     #^MapAnimGfxBG3
        sta     $f5
        ldx     #$bf00                  ; destination = $7ebf00
        stx     $f6
        lda     #$7e
        sta     $f8
        jsl     Decompress
        rts

; ------------------------------------------------------------------------------

; [ copy bg1/bg2 animation graphics to vram ]

; called every other frame during irq (30hz)

TfrBGAnimGfx:
@903f:  lda     $053b
        bne     @9050
        ldx     #$0008
@9047:  dex
        bne     @9047
        lda     #$80
        sta     hINIDISP
        rts
@9050:  stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$2800
        stx     hVMADDL
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$1000
        phx
        pld
        shorti
        longac
        ldy     #$01
        nop5
        ldx     #$80
        stx     hINIDISP
        lda     $69
        clc
        adc     $6b
        sta     $69
        and     #$0600
        xba
        tax
        lda     $6e,x       ; graphics pointer
        sta     $4302
        ldx     $6d         ; graphics bank
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $76
        clc
        adc     $78
        sta     $76
        and     #$0600
        xba
        tax
        lda     $7b,x
        sta     $4302
        ldx     $7a
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $83
        clc
        adc     $85
        sta     $83
        and     #$0600
        xba
        tax
        lda     $88,x
        sta     $4302
        ldx     $87
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $90
        clc
        adc     $92
        sta     $90
        and     #$0600
        xba
        tax
        lda     $95,x
        sta     $4302
        ldx     $94
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $9d
        clc
        adc     $9f
        sta     $9d
        and     #$0600
        xba
        tax
        lda     $a2,x
        sta     $4302
        ldx     $a1
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $aa
        clc
        adc     $ac
        sta     $aa
        and     #$0600
        xba
        tax
        lda     $af,x
        sta     $4302
        ldx     $ae
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $b7
        clc
        adc     $b9
        sta     $b7
        and     #$0600
        xba
        tax
        lda     $bc,x
        sta     $4302
        ldx     $bb
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        lda     $c4
        clc
        adc     $c6
        sta     $c4
        and     #$0600
        xba
        tax
        lda     $c9,x
        sta     $4302
        ldx     $c8
        stx     $4304
        ldx     #$80
        stx     $4305
        sty     hMDMAEN
        shorta
        longi
        ldx     #$0000
        phx
        pld
        tdc
        rts

; ------------------------------------------------------------------------------

; [ copy bg3 animation graphics to vram ]

; called every other frame during irq (30hz)

TfrBG3AnimGfx:
@9178:  stz     hMDMAEN     ; disable dma
        lda     #$80
        sta     hVMAINC     ; vram settings
        ldx     #$3000
        stx     hVMADDL     ; destination = $3000 (vram)
        lda     #$41
        sta     $4300       ; dma settings
        lda     #$18
        sta     $4301       ; dma to $2118 (vram)
        ldx     #$0005
@9193:  dex
        bne     @9193       ; wait
        lda     #$80
        sta     hINIDISP    ; screen off
        lda     $053b       ; bg3 animation index
        and     #$e0
        beq     @91d4       ; return if bg3 animation is disabled
        longac
        lda     $10d5       ; size
        sta     $4305
        lda     $10d1       ; add animation speed to animation counter
        adc     $10d3
        sta     $10d1
        shorta0
        lda     $10d2       ; frame index
        and     #$0e
        tax
        longac
        lda     $10d7,x     ; frame pointer
        adc     #$bf00
        sta     $4302
        shorta0
        lda     #$7e
        sta     $4304
        lda     #$01        ; enable dma
        sta     hMDMAEN
@91d4:  rts

; ------------------------------------------------------------------------------

MapBGAnimPropPtrs:
@91d5:  make_ptr_tbl_rel MapBGAnimProp, 21

@91ff:  .include "data/map_bg_anim_prop.asm"

MapBG3AnimPropPtrs:
@979f:  make_ptr_tbl_rel MapBG3AnimProp, 7

@97ad:  .include "data/map_bg3_anim_prop.asm"

; ------------------------------------------------------------------------------

; [ init event script ]

InitEvent:
@989d:  ldx     $00
        stx     $e3         ; clear event pause counter
        stx     $e8         ; clear event stack
        ldx     #$0000      ; $ca0000 (no event)
        stx     $e5
        lda     #$ca
        sta     $e7
        ldx     #$0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #1          ; set event loop count
        sta     f:$0005c4
        lda     #$80        ; object to wait for
        sta     $e2
        stz     $e1         ; event not waiting for anything
        rts

; ------------------------------------------------------------------------------

; event command jump table (starts at $35)
@98c4:  .addr   EventCmd_35
        .addr   EventCmd_36
        .addr   EventCmd_37
        .addr   EventCmd_38
        .addr   EventCmd_39
        .addr   EventCmd_3a
        .addr   EventCmd_3b
        .addr   EventCmd_3c
        .addr   EventCmd_3d
        .addr   EventCmd_3e
        .addr   EventCmd_3f
        .addr   EventCmd_40
        .addr   EventCmd_41
        .addr   EventCmd_42
        .addr   EventCmd_43
        .addr   EventCmd_44
        .addr   EventCmd_45
        .addr   EventCmd_46
        .addr   EventCmd_47
        .addr   EventCmd_48
        .addr   EventCmd_49
        .addr   EventCmd_4a
        .addr   EventCmd_4b
        .addr   EventCmd_4c
        .addr   EventCmd_4d
        .addr   EventCmd_4e
        .addr   EventCmd_4f
        .addr   EventCmd_50
        .addr   EventCmd_51
        .addr   EventCmd_52
        .addr   EventCmd_53
        .addr   EventCmd_54
        .addr   EventCmd_55
        .addr   EventCmd_56
        .addr   EventCmd_57
        .addr   EventCmd_58
        .addr   EventCmd_59
        .addr   EventCmd_5a
        .addr   EventCmd_5b
        .addr   EventCmd_5c
        .addr   EventCmd_5d
        .addr   EventCmd_5e
        .addr   EventCmd_5f
        .addr   EventCmd_60
        .addr   EventCmd_61
        .addr   EventCmd_62
        .addr   EventCmd_63
        .addr   EventCmd_64
        .addr   EventCmd_65
        .addr   EventCmd_66
        .addr   EventCmd_67
        .addr   EventCmd_68
        .addr   EventCmd_69
        .addr   EventCmd_6a
        .addr   EventCmd_6b
        .addr   EventCmd_6c
        .addr   EventCmd_6d
        .addr   EventCmd_6e
        .addr   EventCmd_6f
        .addr   EventCmd_70
        .addr   EventCmd_71
        .addr   EventCmd_72
        .addr   EventCmd_73
        .addr   EventCmd_74
        .addr   EventCmd_75
        .addr   EventCmd_76
        .addr   EventCmd_77
        .addr   EventCmd_78
        .addr   EventCmd_79
        .addr   EventCmd_7a
        .addr   EventCmd_7b
        .addr   EventCmd_7c
        .addr   EventCmd_7d
        .addr   EventCmd_7e
        .addr   EventCmd_7f
        .addr   EventCmd_80
        .addr   EventCmd_81
        .addr   EventCmd_82
        .addr   EventCmd_83
        .addr   EventCmd_84
        .addr   EventCmd_85
        .addr   EventCmd_86
        .addr   EventCmd_87
        .addr   EventCmd_88
        .addr   EventCmd_89
        .addr   EventCmd_8a
        .addr   EventCmd_8b
        .addr   EventCmd_8c
        .addr   EventCmd_8d
        .addr   EventCmd_8e
        .addr   EventCmd_8f
        .addr   EventCmd_90
        .addr   EventCmd_91
        .addr   EventCmd_92
        .addr   EventCmd_93
        .addr   EventCmd_94
        .addr   EventCmd_95
        .addr   EventCmd_96
        .addr   EventCmd_97
        .addr   EventCmd_98
        .addr   EventCmd_99
        .addr   EventCmd_9a
        .addr   EventCmd_9b
        .addr   EventCmd_9c
        .addr   EventCmd_9d
        .addr   EventCmd_9e
        .addr   EventCmd_9f
        .addr   EventCmd_a0
        .addr   EventCmd_a1
        .addr   EventCmd_a2
        .addr   EventCmd_a3
        .addr   EventCmd_a4
        .addr   EventCmd_a5
        .addr   EventCmd_a6
        .addr   EventCmd_a7
        .addr   EventCmd_a8
        .addr   EventCmd_a9
        .addr   EventCmd_aa
        .addr   EventCmd_ab
        .addr   EventCmd_ac
        .addr   EventCmd_ad
        .addr   EventCmd_ae
        .addr   EventCmd_af
        .addr   EventCmd_b0
        .addr   EventCmd_b1
        .addr   EventCmd_b2
        .addr   EventCmd_b3
        .addr   EventCmd_b4
        .addr   EventCmd_b5
        .addr   EventCmd_b6
        .addr   EventCmd_b7
        .addr   EventCmd_b8
        .addr   EventCmd_b9
        .addr   EventCmd_ba
        .addr   EventCmd_bb
        .addr   EventCmd_bc
        .addr   EventCmd_bd
        .addr   EventCmd_be
        .addr   EventCmd_bf
        .addr   EventCmd_c0
        .addr   EventCmd_c1
        .addr   EventCmd_c2
        .addr   EventCmd_c3
        .addr   EventCmd_c4
        .addr   EventCmd_c5
        .addr   EventCmd_c6
        .addr   EventCmd_c7
        .addr   EventCmd_c8
        .addr   EventCmd_c9
        .addr   EventCmd_ca
        .addr   EventCmd_cb
        .addr   EventCmd_cc
        .addr   EventCmd_cd
        .addr   EventCmd_ce
        .addr   EventCmd_cf
        .addr   EventCmd_d0
        .addr   EventCmd_d1
        .addr   EventCmd_d2
        .addr   EventCmd_d3
        .addr   EventCmd_d4
        .addr   EventCmd_d5
        .addr   EventCmd_d6
        .addr   EventCmd_d7
        .addr   EventCmd_d8
        .addr   EventCmd_d9
        .addr   EventCmd_da
        .addr   EventCmd_db
        .addr   EventCmd_dc
        .addr   EventCmd_dd
        .addr   EventCmd_de
        .addr   EventCmd_df
        .addr   EventCmd_e0
        .addr   EventCmd_e1
        .addr   EventCmd_e2
        .addr   EventCmd_e3
        .addr   EventCmd_e4
        .addr   EventCmd_e5
        .addr   EventCmd_e6
        .addr   EventCmd_e7
        .addr   EventCmd_e8
        .addr   EventCmd_e9
        .addr   EventCmd_ea
        .addr   EventCmd_eb
        .addr   EventCmd_ec
        .addr   EventCmd_ed
        .addr   EventCmd_ee
        .addr   EventCmd_ef
        .addr   EventCmd_f0
        .addr   EventCmd_f1
        .addr   EventCmd_f2
        .addr   EventCmd_f3
        .addr   EventCmd_f4
        .addr   EventCmd_f5
        .addr   EventCmd_f6
        .addr   EventCmd_f7
        .addr   EventCmd_f8
        .addr   EventCmd_f9
        .addr   EventCmd_fa
        .addr   EventCmd_fb
        .addr   EventCmd_fc
        .addr   EventCmd_fd
        .addr   EventCmd_fe
        .addr   EventCmd_ff

; ------------------------------------------------------------------------------

; [ execute events ]

ExecEvent:
@9a5a:  inc     $47
        lda     $84
        bne     _c09a6d
        lda     $58
        bne     @9a6a
        lda     $47
        and     #$03
        bne     _c09a6d
@9a6a:  jsr     _c0714a

_c09a6d:
@9a6d:  ldx     $e3         ; decrement event pause counter
        beq     @9a75
        dex
        stx     $e3
        rts
@9a75:  lda     $0798       ;
        beq     @9a7b
@9a7a:  rts
@9a7b:  lda     $055a       ;
        beq     @9a84
        cmp     #$05
        bne     @9a7a
@9a84:  lda     $055b
        beq     @9a8d
        cmp     #$05
        bne     @9a7a
@9a8d:  lda     $055c
        beq     @9a96
        cmp     #$05
        bne     @9a7a
@9a96:  jsr     UpdateCtrlFlags
        lda     $e1
        bpl     @9abe
        lda     $e2
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        lda     $087c,y
        and     #$0f
        beq     @9ab6
        rts
@9ab6:  lda     $e1
        and     #$7f
        sta     $e1
        bra     @9b1b
@9abe:  lda     $e1
        and     #$40
        beq     @9ad0
        lda     $4a
        beq     @9ac9
        rts
@9ac9:  lda     $e1
        and     #$bf
        sta     $e1
        rts
@9ad0:  lda     $e1
        and     #$20
        beq     @9b1b
        lda     $0541
        cmp     $0557
        beq     @9aeb
        inc
        cmp     $0557
        beq     @9aeb
        dec2
        cmp     $0557
        bne     @9b00
@9aeb:  lda     $0542
        cmp     $0558
        beq     @9b01
        inc
        cmp     $0558
        beq     @9b01
        dec2
        cmp     $0558
        beq     @9b01
@9b00:  rts
@9b01:  lda     $e1
        and     #$df
        sta     $e1
        ldx     $00
        stx     $0547
        stx     $0549
        stx     $054b
        stx     $054d
        stx     $054f
        stx     $0551
@9b1b:  ldy     #$0005
        lda     [$e5],y
        sta     $ef
        dey
        lda     [$e5],y
        sta     $ee
        dey
        lda     [$e5],y
        sta     $ed
        dey
        lda     [$e5],y
        sta     $ec
        dey
        lda     [$e5],y
        sta     $eb
        dey
        lda     [$e5],y
        sta     $ea
        cmp     #$31
        bcs     @9b42
        jmp     InitObjScript
@9b42:  cmp     #$35
        bcs     @9b49
        jmp     ExecPartyObjScript

; execute event command
@9b49:  sec
        sbc     #$35
        longa
        asl
        tax
        lda     $c098c4,x   ; event command table
        sta     $2a
        shorta0
        jmp     ($002a)     ; jump to event command code

; ------------------------------------------------------------------------------

; [ increment event pointer and continue ]

IncEventPtrContinue:
@9b5c:  clc                 ; increment event pointer
        adc     $e5
        sta     $e5
        lda     $e6
        adc     #0
        sta     $e6
        lda     $e7
        adc     #0
        sta     $e7
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ increment event pointer and return ]

IncEventPtrReturn:
@9b70:  clc
        adc     $e5
        sta     $e5
        lda     $e6
        adc     #$00
        sta     $e6
        lda     $e7
        adc     #$00
        sta     $e7
        rts

; ------------------------------------------------------------------------------

; [ push event pointer ]

; a = number of bytes to increment event pc by

PushEventPtr:
@9b82:  ldx     $e8
        clc
        adc     $e5         ; event pc += a
        sta     $e5
        sta     $05f4,x
        lda     $e6
        adc     #$00
        sta     $e6
        sta     $05f5,x
        lda     $e7
        adc     #$00
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8
        rts

; ------------------------------------------------------------------------------

; [ begin object script ]

; a = object index

InitObjScript:
@9ba5:  sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
_9bb4:  lda     $087c,y     ; set movement type to script controlled
        and     #$f0
        ora     #$01
        sta     $087c,y
        tdc
        sta     $0886,y     ; clear number of steps to take
        lda     $e5         ; event pc
        clc
        adc     #$02
        sta     $0883,y     ; set object script pointer
        lda     $e6
        adc     #$00
        sta     $0884,y
        lda     $e7
        adc     #$00
        sta     $0885,y
        lda     $eb         ; branch if not waiting until complete
        bpl     @9c02
        lda     $ea         ; get object number
        cmp     #$31
        bcc     @9bfc
        sec
        sbc     #$31
        asl
        tay
        ldx     $0803,y
        stx     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
@9bfc:  sta     $e2         ; set object to wait for
        lda     #$80        ; waiting for object script
        sta     $e1
@9c02:  lda     $eb         ; add object script length + 2 to event pc
        and     #$7f
        inc2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ begin object script (party character) ]

; a: object index

ExecPartyObjScript:
@9c0b:  sec
        sbc     #$31
        asl
        tax
        ldy     $0803,x     ; pointer to object data
        cpy     #$07b0
        beq     @9c3a       ; branch if there's no character in that slot
        lda     $0867,y     ; character's party
        and     #$07
        cmp     $1a6d       ; branch if not in current party
        bne     @9c3a
        sty     hWRDIVL
        lda     #$29        ; divide by $29 to get character index
        sta     hWRDIVB
        nop8
        lda     hRDDIVL
        sta     $ea
        jmp     _9bb4
@9c3a:  lda     #$31        ; use showing character
        sta     $ea
        ldy     #$07d9
        jmp     _9bb4

; ------------------------------------------------------------------------------

; [ event command $35: wait for object ]

; $eb = object number

EventCmd_35:
@9c44:  lda     $eb
        cmp     #$31        ; branch if not a party character
        bcc     @9c64
        sec
        sbc     #$31
        asl
        tay
        ldx     $0803,y     ; get pointer to party character object data
        stx     hWRDIVL
        lda     #$29        ; divide by $29 to get character number
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
@9c64:  sta     $e2         ; object to wait for
        lda     #$80
        sta     $e1         ; waiting for object
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $36: disable object passability ]

; $eb = object number

EventCmd_36:
@9c6f:  jsr     CalcObjPtr
        lda     $087c,y
        and     #$ef
        sta     $087c,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $78: enable object passability ]

; $eb = object number

EventCmd_78:
@9c7f:  jsr     CalcObjPtr
        lda     $087c,y
        ora     #$10
        sta     $087c,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $37: set object graphics ]

; $eb = object number
; $ec = graphics index

EventCmd_37:
@9c8f:  jsr     CalcObjPtr
        lda     $ec
        sta     $0879,y     ; set object graphics index
        jsr     CalcCharPtr
        cpy     #$0250
        bcs     @9ca4       ; branch if not a character
        lda     $ec
        sta     $1601,y     ; set character graphics index
@9ca4:  lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $43: set object palette ]

; $eb = object number
; $ec = palette index

EventCmd_43:
@9ca9:  jsr     CalcObjPtr
        lda     $ec
        asl
        sta     $1a
        lda     $0880,y     ; set palette (upper sprite)
        and     #$f1
        ora     $1a
        sta     $0880,y
        lda     $0881,y     ; set palette (lower sprite)
        and     #$f1
        ora     $1a
        sta     $0881,y
        lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $44: set object vehicle ]

; $eb = object number
; $ec = svv-----
;       s: character shown
;       v: vehicle index (0 = no vehicle, 1 = chocobo, 2 = magitek, 3 = raft)

EventCmd_44:
@9cca:  jsr     CalcObjPtr
        lda     $ec
        and     #$e0
        sta     $1a
        lda     $0868,y
        and     #$1f
        ora     $1a
        sta     $0868,y
        lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $45: wait for character objects to update ]

EventCmd_45:
@9ce2:  lda     #$01
        sta     $0798
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $46: set current party ]

; $eb = party number (0..7)

EventCmd_46:
@9cea:  lda     $eb
        sta     $1a6d       ; set party
        ldy     #$07d9
        sty     $07fb       ; clear party character object data pointers
        sty     $07fd
        sty     $07ff
        sty     $0801
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $47: create party object ]

EventCmd_47:
@9d03:  jsr     GetTopChar
        jsr     PushCharFlags
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $38: lock screen ]

EventCmd_38:
@9d0e:  lda     #1
        sta     $0559
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $39: unlock screen ]

EventCmd_39:
@9d16:  stz     $0559
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3a: make party user-controlled ]

EventCmd_3a:
@9d1e:  ldy     $0803
        lda     #$02
        sta     $087c,y
        sta     $087d,y
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3b: make party script-controlled ]

EventCmd_3b:
@9d2e:  ldy     $0803
        lda     #$01
        sta     $087c,y
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3f: add character to party ]

; $eb = character number
; $eb = party number (0..7, 0 = remove from party)

EventCmd_3f:
@9d3b:  jsr     PopCharFlags
        lda     $ec
        jsr     FindEmptyCharSlot
        ora     $ec
        sta     $1a
        jsr     CalcObjPtr
        lda     $0867,y
        and     #$e0
        ora     $1a
        sta     $0867,y     ; set party and battle slot in object data
        sta     $1a
        tdc
        sta     $087d,y     ; clear saved movement type
        jsr     GetTopCharPtr
        lda     $eb
        tay
        lda     $1a
        sta     $1850,y     ; set party and battle slot in character data
        jsr     UpdateEquip
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3c: set party characters ]

; $eb = slot 0 character
; $ec = slot 1 character ($ff = empty slot)
; $ed = slot 2 character ($ff = empty slot)
; $ee = slot 3 character ($ff = empty slot)

EventCmd_3c:
@9d6d:  ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        jsr     CalcObjPtr
        sty     $07fb
        lda     $ec
        bmi     @9da3
        sta     $eb
        jsr     CalcObjPtr
        sty     $07fd
        lda     $ed
        bmi     @9da3
        sta     $eb
        jsr     CalcObjPtr
        sty     $07ff
        lda     $ee
        bmi     @9da3
        sta     $eb
        jsr     CalcObjPtr
        sty     $0801
@9da3:  lda     #$01
        sta     $0798
        lda     #$05
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ calculate pointer to character data ]

; $eb = object number

CalcCharPtr:
@9dad:  lda     $eb
        cmp     #$31
        bcc     @9de0
        sec
        sbc     #$31
        asl
        tax
        ldy     $0803,x
        cpy     #$07b0
        beq     @9dde
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @9dde
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        bra     @9de0
@9dde:  lda     #$11
@9de0:  sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        rts

; ------------------------------------------------------------------------------

; [ calculate pointer to object data ]

; $eb = object number

CalcObjPtr:
@9df0:  lda     $eb
        cmp     #$31
        bcc     @9e2b
        sec
        sbc     #$31
        asl
        tax
        ldy     $0803,x
        cpy     #$07b0
        beq     @9e23
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @9e23
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop8
        lda     hRDDIVL
        sta     $eb
        rts
@9e23:  ldy     #$07d9
        lda     #$31
        sta     $eb
        rts
@9e2b:  lda     $eb
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop3
        ldy     hRDMPYL
        rts

; ------------------------------------------------------------------------------

; [ event command $3d: create object ]

; $eb = object number

EventCmd_3d:
@9e3c:  jsr     CalcObjPtr
        lda     $0867,y     ; return if object is already enabled
        and     #$40
        bne     @9e62
        lda     $0867,y     ; enable object, not visible
        and     #$3f
        ora     #$40
        sta     $0867,y
        jsr     StartObjAnim
        lda     $eb
        cmp     #$10
        bcs     @9e62       ; return if not a character object
        tay
        lda     $1850,y     ; enable object in character data
        ora     #$40
        sta     $1850,y
@9e62:  lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3e: delete object ]

; $eb = object number

EventCmd_3e:
@9e67:  jsr     CalcObjPtr
        lda     $0867,y     ; return if object is already disabled
        and     #$40
        beq     @9e9d
        lda     $0867,y     ; disable object, not visible
        and     #$3f
        sta     $0867,y
        tdc
        sta     $087d,y     ; clear saved movement type
        jsr     StopObjAnim
        phy
        jsr     GetTopCharPtr
        ply
        ldx     $087a,y     ; pointer to object map data
        lda     #$ff
        sta     $7e2000,x   ; clear map data
        lda     $eb
        cmp     #$10
        bcs     @9e9d       ; branch if not a character object
        tay
        lda     $1850,y     ; disable object in character data
        and     #$3f
        sta     $1850,y
@9e9d:  lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ get next available party slot ]

; a = party number number (0..2)

FindEmptyCharSlot:
@9ea2:  sta     $1a
        cmp     #$00
        beq     @9ed4
        ldy     $00
@9eaa:  lda     $0867,y     ; branch if character is not enabled
        and     #$40
        beq     @9ec3
        lda     $0867,y     ; branch if character is not in that party
        and     #$07
        cmp     $1a
        bne     @9ec3
        lda     $0867,y
        and     #$18
        cmp     #$00
        beq     @9ed5
@9ec3:  longa
        tya
        clc
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @9eaa
        tdc                 ; slot 0
@9ed4:  rts
@9ed5:  ldy     $00
@9ed7:  lda     $0867,y
        and     #$40
        beq     @9ef0
        lda     $0867,y
        and     #$07
        cmp     $1a
        bne     @9ef0
        lda     $0867,y
        and     #$18
        cmp     #$08
        beq     @9f02
@9ef0:  longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @9ed7
        lda     #$08        ; slot 1
        rts
@9f02:  ldy     $00
@9f04:  lda     $0867,y
        and     #$40
        beq     @9f1d
        lda     $0867,y
        and     #$07
        cmp     $1a
        bne     @9f1d
        lda     $0867,y
        and     #$18
        cmp     #$10
        beq     @9f2f
@9f1d:  longac
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @9f04
        lda     #$10        ; slot 2
        rts
@9f2f:  lda     #$18        ; slot 3
        rts

; ------------------------------------------------------------------------------

; [ event command $77: normalize character level ]

; $eb = character number

EventCmd_77:
@9f32:  jsr     CalcAverageLevel
        pha
        jsr     CalcCharPtr
        lda     $1608,y     ; character level
        dec
        sta     $20         ; +$20 = previous level - 1
        stz     $21
        pla
        cmp     $1608,y
        bcc     @9f70       ; branch if average is less than character level
        sta     $1608,y     ; set character level to average
        dec
        sta     $22         ; +$22 = new level - 1
        stz     $23
        jsr     UpdateMaxHP
        jsr     UpdateMaxMP
        lda     $160b,y     ; set hp to maximum
        sta     $1609,y
        lda     $160c,y
        sta     $160a,y
        lda     $160f,y     ; set mp to maximum
        sta     $160d,y
        lda     $1610,y
        sta     $160e,y
        jsr     UpdateAbilities
@9f70:  jsr     UpdateExp
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ calculate average character level ]

CalcAverageLevel:
@9f78:  ldx     $1ede       ; +$20 = characters available
        stx     $20
        ldx     $00
        txy
        stx     $1e         ; +$1e = sum of available characters' levels
        stz     $1b         ;  $1b = number of active characters
@9f84:  longac
        lsr     $20
        shorta0
        bcc     @9f9d
        lda     $1e
        clc
        adc     $1608,x     ; character level
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inc     $1b
@9f9d:  iny                 ; next character
        longac
        txa
        adc     #$0025
        tax
        shorta0
        cpy     #$000e
        bne     @9f84
        ldx     $1e
        stx     hWRDIVL
        lda     $1b
        beq     @9fc5
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        bra     @9fc7
@9fc5:  lda     #$03        ; minimum 3
@9fc7:  cmp     #$63
        bcc     @9fcd
        lda     #$63        ; maximum 99
@9fcd:  rts

; ------------------------------------------------------------------------------

; [ event command $8d: remove character equipped items/esper ]

EventCmd_8d:
@9fce:  lda     $eb         ; calculate pointer to character data
        sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop2
        ldy     #$0006
        ldx     hRDMPYL
        lda     #$ff
        sta     $161e,x     ; remove esper
@9fe5:  phy
        phx
        lda     $161f,x     ; item slot
        cmp     #$ff
        beq     @a02c       ; branch if no item in this slot
        sta     $1a         ; $1a = item number
        lda     #$ff
        sta     $161f,x     ; clear item slot
        ldx     $00
@9ff7:  lda     $1869,x     ; look for item in inventory
        cmp     $1a
        beq     @a021       ; branch if found
        inx
        cpx     #$0100
        bne     @9ff7
        ldx     $00
@a006:  lda     $1869,x     ; look for next available item slot
        cmp     #$ff
        beq     @a015
        inx
        cpx     #$0100
        bne     @a006
        bra     @a02c       ; branch if there are no available item slots
@a015:  lda     $1a
        sta     $1869,x     ; set item number
        lda     #$01
        sta     $1969,x     ; item quantity = 1
        bra     @a02c
@a021:  lda     $1969,x     ; branch if item quantity is 99
        cmp     #$63
        beq     @a02c
        inc                 ; increment quantity
        sta     $1969,x
@a02c:  plx                 ; next item
        ply
        inx
        dey
        bne     @9fe5
        jsr     UpdateEquip
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7f: set character name ]

; $eb = character number
; $ec = name index

EventCmd_7f:
@a03a:  jsr     CalcCharPtr
        lda     #6                      ; calculate pointer to character name
        sta     hWRMPYA
        lda     $ec
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
.repeat 6, i
        lda     f:CharName+i,x          ; copy character name (6 bytes)
        sta     $1602+i,y
.endrep
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $40: set character properties ]

; $eb = character number
; $ec = actor number

EventCmd_40:
@a07c:  jsr     CalcCharPtr
        lda     #$16        ; calculate pointer to actor properties
        sta     hWRMPYA
        lda     $ec
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     $ed7ca2,x   ; battle commands
        sta     $1616,y
        lda     $ed7ca3,x
        sta     $1617,y
        lda     $ed7ca4,x
        sta     $1618,y
        lda     $ed7ca5,x
        sta     $1619,y
        lda     $ed7ca6,x   ; vigor
        sta     $161a,y
        lda     $ed7ca7,x   ; speed
        sta     $161b,y
        lda     $ed7ca8,x   ; stamina
        sta     $161c,y
        lda     $ed7ca9,x   ; mag. power
        sta     $161d,y
        lda     #$ff        ; clear esper
        sta     $161e,y
        lda     $ed7caf,x   ; weapon
        sta     $161f,y
        lda     $ed7cb0,x   ; shield
        sta     $1620,y
        lda     $ed7cb1,x   ; helmet
        sta     $1621,y
        lda     $ed7cb2,x   ; armor
        sta     $1622,y
        lda     $ed7cb3,x   ; relics
        sta     $1623,y
        lda     $ed7cb4,x
        sta     $1624,y
        lda     $ed7ca0,x   ; max hp
        sta     $160b,y
        lda     $ed7ca1,x   ; max mp
        sta     $160f,y
        tdc
        sta     $160c,y
        sta     $1610,y
        phx
        phy
        lda     $ec         ; actor
        sta     $1600,y
        jsr     CalcAverageLevel
        ply
        plx
        sta     $1608,y     ; set level
        lda     $ed7cb5,x   ; level modifier
        and     #$0c
        lsr2
        tax
        lda     f:CharAvgLevelTbl,x   ; add modifier
        clc
        adc     $1608,y
        beq     @a12f
        bpl     @a131
@a12f:  lda     #1          ; minimum level = 1
@a131:  cmp     #99         ; maximum level = 99
        bcc     @a137
        lda     #99
@a137:  sta     $1608,y
        jsr     InitMaxHP
        lda     $160b,y     ; set hp to max
        sta     $1609,y
        lda     $160c,y
        sta     $160a,y
        jsr     InitMaxMP
        lda     $160f,y     ; set mp to max
        sta     $160d,y
        lda     $1610,y
        sta     $160e,y
        jsr     UpdateExp
        tyx
        jsr     CalcObjPtr
        lda     $087c,y     ; set movement type to script-controlled
        and     #$f0
        ora     #$01
        sta     $087c,y
        lda     $0868,y     ; enable walking animation
        ora     #$01
        sta     $0868,y
        lda     #$00        ; clear object settings
        sta     $0867,y
        txy
        jsr     UpdateAbilities
        lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ update character natural skills ]

; y = pointer to character data

UpdateAbilities:
@a17f:  lda     $1600,y     ; actor index
        cmp     #$00
        beq     @a196       ; branch if terra
        cmp     #$06
        beq     @a1b8       ; branch if celes
        cmp     #$02
        beq     @a1da       ; branch if cyan
        cmp     #$05
        bne     @a195       ; return if not sabin
        jmp     @a201
@a195:  rts

; update terra's natural magic
@a196:  ldx     $00
@a198:  lda     $ece3c1,x   ; level that the spell is learned
        cmp     $1608,y     ; current level
        beq     @a1a3
        bcs     @a195       ; return if greater than current level
@a1a3:  phy
        lda     $ece3c0,x   ; spell number
        tay
        lda     #$ff
        sta     $1a6e,y     ; learn spell
        ply
        inx2                ; next natural spell (16 total)
        cpx     #$0020
        beq     @a195
        bra     @a198

; update celes' natural magic
@a1b8:  ldx     $00
@a1ba:  lda     $ece3e1,x   ; level that the spell is learned
        cmp     $1608,y     ; current level
        beq     @a1c5
        bcs     @a195       ; return if greater than current level
@a1c5:  phy
        lda     $ece3e0,x   ; spell number
        tay
        lda     #$ff
        sta     $1bb2,y     ; learn spell
        ply
        inx2                ; next natural spell (16 total)
        cpx     #$0020
        beq     @a195
        bra     @a1ba

; update cyan's swdtech
@a1da:  stz     $1b
        ldx     $00
@a1de:  lda     $e6f490,x
        cmp     $1608,y
        beq     @a1e9
        bcs     @a1f3
@a1e9:  inc     $1b
        inx
        cpx     #8
        beq     @a1f3
        bra     @a1de
@a1f3:  lda     $1b
        tax
        lda     $1cf7
        ora     f:LearnAbilityTbl,x
        sta     $1cf7
        rts

; update sabin's blitz
@a201:  stz     $1b
        ldx     $00
@a205:  lda     $e6f498,x
        cmp     $1608,y
        beq     @a210
        bcs     @a21a
@a210:  inc     $1b
        inx
        cpx     #8
        beq     @a21a
        bra     @a205
@a21a:  lda     $1b
        tax
        lda     $1d28
        ora     f:LearnAbilityTbl,x
        sta     $1d28
        rts

; ------------------------------------------------------------------------------

; character average level modifiers
CharAvgLevelTbl:
@a228:  .byte   $00,$02,$05,$fd

; swdtech/blitz learn flags
LearnAbilityTbl:
@a22c:  .byte   $00,$01,$03,$07,$0f,$1f,$3f,$7f,$ff

; ------------------------------------------------------------------------------

; [ update character experience points ]

; y = pointer to character data

UpdateExp:
@a235:  lda     $1608,y     ; $1b = current level
        sta     $1b
        ldx     $00
        stx     $2a         ; ++$2a = calculated experience points
        stz     $2c
@a240:  dec     $1b
        beq     @a25c       ; branch at current level
        longa
        lda     $ed8220,x   ; add experience progression value
        clc
        adc     $2a
        sta     $2a
        shorta0
        lda     $2c
        adc     #$00
        sta     $2c
        inx2                ; next level
        bra     @a240
@a25c:  asl     $2a         ; ++$2a *= 8
        rol     $2b
        rol     $2c
        asl     $2a
        rol     $2b
        rol     $2c
        asl     $2a
        rol     $2b
        rol     $2c
        lda     $2a         ; set character experience points
        sta     $1611,y
        lda     $2b
        sta     $1612,y
        lda     $2c
        sta     $1613,y
        rts

; ------------------------------------------------------------------------------

; [ init character max hp ]

; y = pointer to character data

InitMaxHP:
@a27e:  lda     #$16
        sta     hWRMPYA
        lda     $1600,y
        sta     hWRMPYB
        lda     $1608,y
        sta     $1b
        stz     $1f
        ldx     hRDMPYL
        lda     $ed7ca0,x               ; starting hp
        sta     $1e
        ldx     $00
@a29b:  dec     $1b
        beq     @a2b1
        lda     $e6f4a0,x
        clc
        adc     $1e
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @a29b
@a2b1:  longac
        lda     $1e
        sta     $160b,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init character max mp ]

; y = pointer to character data

InitMaxMP:
@a2bc:  lda     #$16
        sta     hWRMPYA
        lda     $1600,y
        sta     hWRMPYB
        lda     $1608,y
        sta     $1b
        stz     $1f
        ldx     hRDMPYL
        lda     $ed7ca1,x   ; starting mp
        sta     $1e
        ldx     $00
@a2d9:  dec     $1b
        beq     @a2ef
        lda     $e6f502,x
        clc
        adc     $1e
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @a2d9
@a2ef:  longac
        lda     $1e
        sta     $160f,y
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ event command $41: show object ]

; $eb = object number

EventCmd_41:
@a2fa:  jsr     CalcObjPtr
        lda     $0867,y
        and     #$40
        beq     @a331       ; return if object is not enabled
        lda     $0867,y     ; return if object is already visible
        bmi     @a331
        ora     #$80        ; make object visible
        sta     $0867,y
        lda     $0880,y     ; set top sprite layer priority to 2
        and     #$cf
        ora     #$20
        sta     $0880,y
        lda     $0881,y     ; set bottom sprite layer priority to 2
        and     #$cf
        ora     #$20
        sta     $0881,y
        lda     $eb         ; return if not a character object
        cmp     #$10
        bcs     @a331
        tay
        lda     $1850,y     ; set character object settings
        ora     #$80
        sta     $1850,y
@a331:  lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $42: hide object ]

; $eb = object number

EventCmd_42:
@a336:  jsr     CalcObjPtr
        lda     $0867,y
        and     #$7f
        sta     $0867,y
        tdc
        sta     $087d,y
        ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x
        lda     $087c,y
        and     #$f0
        sta     $087c,y
        lda     $eb
        cmp     #$10
        bcs     @a365
        tay
        lda     $1850,y
        and     #$7f
        sta     $1850,y
@a365:  lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $79: set party's map ]

;  $eb = party number
; +$ec = map number

EventCmd_79:
@a36a:  ldy     $00
@a36c:  lda     $0867,y
        and     #$40
        beq     @a386
        lda     $0867,y
        and     #$07
        cmp     $eb
        bne     @a386       ; branch if character is not in that party
        longa
        lda     $ec
        sta     $088d,y     ; set character object's map
        shorta0
@a386:  longac        ; next character
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @a36c
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7e: move current party ]

; $eb = x position
; $ec = y position

EventCmd_7e:
@a39a:  longa
        lda     $eb
        and     #$00ff
        asl4
        sta     $26
        lda     $ec
        and     #$00ff
        asl4
        sta     $28
        shorta0
        ldy     $00
        stz     $1b
@a3b9:  lda     $0867,y
        and     #$40
        beq     @a3fa
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @a3fa
        ldx     $087a,y
        lda     $7e2000,x
        cmp     $1b
        bne     @a3db
        lda     #$ff
        sta     $7e2000,x
@a3db:  longa
        lda     $26
        sta     $086a,y
        lda     $28
        sta     $086d,y
        shorta0
        sta     $0869,y
        sta     $086c,y
        lda     $eb
        sta     $087a,y
        lda     $ec
        sta     $087b,y
@a3fa:  longac        ; next character
        tya
        adc     #$0029
        tay
        shorta0
        inc     $1b
        inc     $1b
        cpy     #$0290
        bne     @a3b9
        lda     #$01        ; re-load the same map
        sta     $58
        lda     $eb         ; set global map position
        sta     $1fc0
        sta     $1f66
        lda     $ec
        sta     $1fc1
        sta     $1f67
        lda     #$01        ; enable map load
        sta     $84
        lda     #$03
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $7a: set object's event pointer ]

;   $eb = object number
; ++$ec = event pointer

EventCmd_7a:
@a42a:  jsr     CalcObjPtr
        lda     $ec
        sta     $0889,y     ; set event pointer
        lda     $ed
        sta     $088a,y
        lda     $ee
        sta     $088b,y
        lda     #$05
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7b: restore default party ]

EventCmd_7b:
@a441:  lda     $055d
        cmp     $1a6d       ; return if default party is already active
        beq     @a450
        dec
        sta     $1a6d       ; set current party
        jsr     ChangeParty
@a450:  lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7c: enable collision activation ]

; $eb = object number

EventCmd_7c:
@a455:  jsr     CalcObjPtr
        lda     $087c,y
        ora     #$40
        sta     $087c,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7d: disable collision activation ]

; $eb = object number

EventCmd_7d:
@a465:  jsr     CalcObjPtr
        lda     $087c,y
        and     #$bf
        sta     $087c,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $48: display dialog message ]

; +$eb = bt-ddddd dddddddd
;        b: show at bottom of screen
;        t: show text only
;        d: dialog message

EventCmd_48:
@a475:  longa
        lda     $eb
        and     #$1fff
        sta     $d0         ; dialog message number
        shorta0
        lda     $ec         ; branch if showing at bottom of screen
        bmi     @a489
        lda     #$01
        bra     @a48b
@a489:  lda     #$12
@a48b:  sta     $bc         ; dialog window y position (1 or 12)
        lda     $ec
        and     #$40
        lsr6
        sta     $0564       ; text only
        jsr     GetDlgPtr
        lda     #1
        sta     $ba         ; enable dialog window
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $49: wait for dialog window to close ]

EventCmd_49:
@a4a6:  lda     $ba         ; dialog window state
        beq     @a4ab
        rts
@a4ab:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $4a: wait for dialog keypress ]

EventCmd_4a:
@a4b0:  lda     $d3         ; dialog keypress state
        cmp     #$01
        beq     @a4b7
        rts
@a4b7:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $4b: display dialog message (wait for keypress) ]

; +$eb = bt-ddddd dddddddd
;        b: show at bottom of screen
;        t: show text only
;        d: dialog message

EventCmd_4b:
@a4bc:  longa
        lda     $eb
        and     #$1fff
        sta     $d0         ; set dialog index
        shorta0
        lda     $ec
        bmi     @a4d0       ; branch if showing dialog window at bottom of screen
        lda     #$01        ; y = 1 (top of screen)
        bra     @a4d2
@a4d0:  lda     #$12        ; y = 18 (bottom of screen)
@a4d2:  sta     $bc
        lda     $ec         ; text only flag
        and     #$40
        lsr6
        sta     $0564
        jsr     GetDlgPtr
        lda     #$01        ; enable dialog window
        sta     $ba
        lda     #$01        ; $ca0001 (wait for dialog keypress)
        sta     $eb
        lda     #$00
        sta     $ec
        lda     #$00
        sta     $ed
        lda     #$03        ; return address is pc+3
        jmp     _b1a3       ; jump to subroutine

; ------------------------------------------------------------------------------

; [ event command $4e: initiate random battle ]

EventCmd_4e:
@a4f9:  inc     $56         ; enable battle
        stz     $078a       ; enable blur and sound
        lda     #$01
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $af: initiate colosseum battle ]

EventCmd_af:
@a503:  lda     $0201
        bne     @a515
        ldx     #$023f      ; normal colosseum battle
        lda     $1ed7
        and     #$f7
        sta     $1ed7
        bra     @a520
@a515:  ldx     #$023e      ; colosseum battle vs. shadow
        lda     $1ed7
        ora     #$08
        sta     $1ed7
@a520:  longa
        txa
        sta     f:$0011e0
        lda     #$001c
        sta     f:$0011e2     ; set battle background to colosseum
        shorta0
        lda     #$c0
        sta     $11fa
        lda     $1ed7
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #$01
        sta     $56
        lda     #$c0
        sta     $078a
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $8e: initiate monster-in-a-box battle ]

EventCmd_8e:
@a54e:  lda     $0789       ; monster-in-a-box event battle group number
        sta     $eb
        lda     #$3f        ; default battle bg
        sta     $ec
        jsr     EventBattle
        ldx     $0541       ; set scroll position
        stx     $1f66
        ldx     a:$00af       ; set party position
        stx     $1fc0
        lda     #$c0        ; enable map startup event, disable auto fade-in
        sta     $11fa
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $82: reset default party ]

EventCmd_82:
@a570:  lda     #1
        sta     $055d
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $4d: initiate battle ]

; $eb = event battle group
; $ec = bsgggggg
;       b: disable blur
;       s: disable sound effect
;       g: battle bg ($3f = map default)

EventCmd_4d:
@a578:  jsr     EventBattle
        ldx     $0541       ; set scroll position
        stx     $1f66
        ldx     a:$00af       ; set party position
        stx     $1fc0
        lda     #$e0        ; enable map startup event, disable auto fade-in, don't update map size
        sta     $11fa
        lda     #3
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $4c: initiate battle (party collision) ]

; $eb = event battle group
; $ec = bsgggggg
;       b: disable blur
;       s: disable sound effect
;       g: battle bg ($3f = map default)

EventCmd_4c:
@a591:  jsr     EventBattle
        ldx     $0557       ; set party position and scroll position to the collided party
        stx     $1f66
        stx     $1fc0
        lda     #$c0        ; enable map startup event, disable auto fade-in
        sta     $11fa
        lda     #3
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ set event battle index ]

; $eb = event battle group
; $ec = bsgggggg
;       b: disable blur
;       s: disable sound effect
;       g: battle bg ($3f = map default)

EventBattle:
@a5a7:  lda     $eb         ; event battle group
        longa
        asl2
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$c0
        bcc     @a5ba       ; 3/4 chance to choose the first battle
        inx2                ; 1/4 chance to choose the second battle
@a5ba:  longa
        lda     $cf5000,x   ; battle index
        sta     f:$0011e0
        shorta0
        lda     $ec         ; battle blur/sound flags
        and     #$c0
        sta     $078a
        lda     $ec         ; battle bg
        and     #$3f
        cmp     #$3f
        bne     @a5db
        lda     $0522       ; map's default battle bg
        and     #$7f
@a5db:  sta     f:$0011e2     ; set battle bg
        tdc
        sta     f:$0011e3
        lda     $1ed7       ;
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #1        ; enable battle
        sta     $56
        rts

; ------------------------------------------------------------------------------

; [ event command $4f: restore saved game ]

EventCmd_4f:
@a5f3:  lda     #1                      ; enable restore saved game
        sta     $11f1
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $50: modify bg palettes ]

; $eb = mmmrgbii
;       m: color function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub

EventCmd_50:
@a5fd:  lda     #$08        ; color range begin (skip font palette)
        sta     $df
        lda     #$f0        ; color range end (skip dialog window palette)
        sta     $e0
        jsr     InitColorMod
        dec
        bne     @a610
        jsr     BGColorInc
        bra     @a63b
@a610:  dec
        bne     @a618
        jsr     BGColorIncFlash
        bra     @a63b
@a618:  dec
        bne     @a620
        jsr     BGColorUnInc
        bra     @a63b
@a620:  dec
        bne     @a628
        jsr     BGColorDec
        bra     @a63b
@a628:  dec
        bne     @a630
        jsr     BGColorDecFlash
        bra     @a63b
@a630:  dec
        bne     @a638
        jsr     BGColorUnDec
        bra     @a63b
@a638:  jsr     BGColorRestore
@a63b:  lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $51: modify bg palette range ]

; $eb = mmmrgbii
;       m: color function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub
; $ec = range start
; $ed = range end

EventCmd_51:
@a640:  lda     $ec
        asl
        sta     $df
        lda     $ed
        inc
        asl
        sta     $e0
        jsr     InitColorMod
        dec
        bne     @a656
        jsr     BGColorInc
        bra     @a681
@a656:  dec
        bne     @a65e
        jsr     BGColorIncFlash
        bra     @a681
@a65e:  dec
        bne     @a666
        jsr     BGColorUnInc
        bra     @a681
@a666:  dec
        bne     @a66e
        jsr     BGColorDec
        bra     @a681
@a66e:  dec
        bne     @a676
        jsr     BGColorDecFlash
        bra     @a681
@a676:  dec
        bne     @a67e
        jsr     BGColorUnDec
        bra     @a681
@a67e:  jsr     BGColorRestore
@a681:  lda     #4
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $52: modify object palettes ]

; $eb = mmmrgbii
;       m: color math function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub

EventCmd_52:
@a686:  stz     $df
        stz     $e0
        jsr     InitColorMod
        dec
        bne     @a695
        jsr     SpriteColorInc
        bra     @a6c0
@a695:  dec
        bne     @a69d
        jsr     SpriteColorIncFlash
        bra     @a6c0
@a69d:  dec
        bne     @a6a5
        jsr     SpriteColorUnInc
        bra     @a6c0
@a6a5:  dec
        bne     @a6ad
        jsr     SpriteColorDec
        bra     @a6c0
@a6ad:  dec
        bne     @a6b5
        jsr     SpriteColorDecFlash
        bra     @a6c0
@a6b5:  dec
        bne     @a6bd
        jsr     SpriteColorUnDec
        bra     @a6c0
@a6bd:  jsr     SpriteColorRestore
@a6c0:  lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $53: modify object palette range ]

; $eb = mmmrgbii
;       m: color math function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub
; $ec = range start
; $ed = range end

EventCmd_53:
@a6c5:  lda     $ec
        asl
        sta     $df
        lda     $ed
        inc
        asl
        sta     $e0
        jsr     InitColorMod
        dec
        bne     @a6db
        jsr     SpriteColorInc
        bra     @a706
@a6db:  dec
        bne     @a6e3
        jsr     SpriteColorIncFlash
        bra     @a706
@a6e3:  dec
        bne     @a6eb
        jsr     SpriteColorUnInc
        bra     @a706
@a6eb:  dec
        bne     @a6f3
        jsr     SpriteColorDec
        bra     @a706
@a6f3:  dec
        bne     @a6fb
        jsr     SpriteColorDecFlash
        bra     @a706
@a6fb:  dec
        bne     @a703
        jsr     SpriteColorUnDec
        bra     @a706
@a703:  jsr     SpriteColorRestore
@a706:  lda     #4
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ init palette color modification ]

InitColorMod:
@a70b:  stz     $1a                     ;  $1a = red color constant
        stz     $1b                     ;  $1b = blue color constant
        stz     $20                     ; +$20 = green color constant
        stz     $21
        lda     $eb                     ; intensity
        and     #$03
        asl
        tax
        lda     $eb                     ; red
        and     #$10
        beq     @a725
        lda     f:RedColorTbl,x
        sta     $1a
@a725:  lda     $eb                     ; blue
        and     #$08
        beq     @a736
        longa
        lda     f:GreenColorTbl,x
        sta     $20
        shorta0
@a736:  lda     $eb                     ; green
        and     #$04
        beq     @a742
        lda     f:BlueColorTbl,x
        sta     $1b
@a742:  lda     $eb                     ; branch if adding color
        bpl     @a764
        lda     $1a
        eor     $02
        and     #$1f
        sta     $1a
        lda     $1b
        eor     $02
        and     #$7c
        sta     $1b
        longa
        lda     $20
        eor     $02
        and     #$03e0
        sta     $20
        shorta0
@a764:  lda     $eb                     ; return color function
        lsr5
        rts

; ------------------------------------------------------------------------------

; red color intensities
RedColorTbl:
@a76c:  .word   $0004,$0008,$0010,$001f

; blue color intensities
BlueColorTbl:
@a774:  .word   $0010,$0020,$0040,$007c

; green color intensities
GreenColorTbl:
@a77c:  .word   $0080,$0100,$0200,$03e0

; ------------------------------------------------------------------------------

; [ event command $54: disable fixed color math ]

EventCmd_54:
@a784:  stz     $4d
        stz     $4b
        lda     $4f
        sta     $4e
        lda     $53
        sta     $52
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $55: flash screen ]

; $eb = bgr-----
;       b: affect blue
;       g: affect green
;       r: affect red

EventCmd_55:
@a795:  lda     $4d         ; return if fixed color math is already enabled
        bne     @a7a3
        lda     $4e         ; save color math designation
        sta     $4f
        lda     $52         ; save subscreen designation
        sta     $53
        stz     $52         ; clear subscreen designation
@a7a3:  lda     #$07        ; affect bg only
        sta     $4e
        lda     $eb         ; set color components
        and     #$e0
        sta     $54
        lda     #$f8        ; set starting intensity to full
        sta     $4d
        lda     #$08        ; fixed color fading out, speed 8
        sta     $4b
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $56: set fixed color addition ]

; $eb = bgrssiii
;       b: affect blue
;       g: affect green
;       r: affect red
;       s: speed
;       i: intensity

EventCmd_56:
@a7ba:  lda     $4d
        bne     @a7c5
        lda     $eb
        jsr     InitFixedColorAdd
        bra     @a7cb
@a7c5:  lda     $4b
        and     #$7f
        sta     $4b
@a7cb:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $57: set fixed color subtraction ]

; $eb = bgrssiii
;       b: affect blue
;       g: affect green
;       r: affect red
;       s: speed
;       i: intensity

EventCmd_57:
@a7d0:  lda     $4d
        bne     @a7db
        lda     $eb
        jsr     InitFixedColorSub
        bra     @a7e1
@a7db:  lda     $4b
        and     #$7f
        sta     $4b
@a7e1:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $58: shake screen ]

; $eb = o321ffaa
;       o: shake obj layer
;       3: shake bg3
;       2: shake bg2
;       1: shake bg1
;       f: frequency
;       a: amplitude

EventCmd_58:
@a7e6:  lda     $eb
        sta     $074a
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $96: fade in ]

EventCmd_96:
@a7f0:  lda     #$10
        sta     $4a
        lda     #$10
        sta     $4c
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $97: fade out ]

EventCmd_97:
@a7fd:  lda     #$90
        sta     $4a
        lda     #$f0
        sta     $4c
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $59: fade in ]

; $eb = speed (0..31)

EventCmd_59:
@a80a:  lda     $eb
        sta     $4a
        lda     #$10
        sta     $4c
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5a: fade out ]

; $eb = speed (0..31)

EventCmd_5a:
@a817:  lda     $eb
        ora     #$80
        sta     $4a
        lda     #$f0
        sta     $4c
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5b: stop fade in/out ]

EventCmd_5b:
@a826:  stz     $4a
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5c: wait for fade in/out ]

EventCmd_5c:
@a82d:  lda     $e1
        ora     #$40
        sta     $e1
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5d: scroll bg1 ]

; these are the ones where $ff -> $ffff
; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_5d:
@a838:  lda     $eb
        bmi     @a84a
        longa
        asl4
        sta     $0547
        shorta0
        bra     @a85a
@a84a:  eor     $02
        longa
        asl4
        eor     $02
        sta     $0547
        shorta0
@a85a:  lda     $ec
        bmi     @a86c
        longa
        asl4
        sta     $0549
        shorta0
        bra     @a87c
@a86c:  eor     $02
        longa
        asl4
        eor     $02
        sta     $0549
        shorta0
@a87c:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $70: scroll bg1 ]

; these are the ones where $ff -> $fff0
; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_70:
@a881:  lda     $eb
        bmi     @a893
        longa
        asl4
        sta     $0547
        shorta0
        bra     @a8a5
@a893:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0547
        shorta0
@a8a5:  lda     $ec
        bmi     @a8b7
        longa
        asl4
        sta     $0549
        shorta0
        bra     @a8c9
@a8b7:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0549
        shorta0
@a8c9:  lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5e: scroll bg2 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_5e:
@a8ce:  lda     $eb
        bmi     @a8e0
        longa
        asl4
        sta     $054b
        shorta0
        bra     @a8f0
@a8e0:  eor     $02
        longa
        asl4
        eor     $02
        sta     $054b
        shorta0
@a8f0:  lda     $ec
        bmi     @a902
        longa
        asl4
        sta     $054d
        shorta0
        bra     @a912
@a902:  eor     $02
        longa
        asl4
        eor     $02
        sta     $054d
        shorta0
@a912:  lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $71: scroll bg2 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_71:
@a917:  lda     $eb
        bmi     @a929
        longa
        asl4
        sta     $054b
        shorta0
        bra     @a93b
@a929:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054b
        shorta0
@a93b:  lda     $ec
        bmi     @a94d
        longa
        asl4
        sta     $054d
        shorta0
        bra     @a95f
@a94d:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054d
        shorta0
@a95f:  lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5f: scroll bg3 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_5f:
@a964:  lda     $eb
        bmi     @a976
        longa
        asl4
        sta     $054f
        shorta0
        bra     @a986
@a976:  eor     $02
        longa
        asl4
        eor     $02
        sta     $054f
        shorta0
@a986:  lda     $ec
        bmi     @a998
        longa
        asl4
        sta     $0551
        shorta0
        bra     @a9a8
@a998:  eor     $02
        longa
        asl4
        eor     $02
        sta     $0551
        shorta0
@a9a8:  lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $72: scroll bg3 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_72:
@a9ad:  lda     $eb
        bmi     @a9bf
        longa
        asl4
        sta     $054f
        shorta0
        bra     @a9d1
@a9bf:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054f
        shorta0
@a9d1:  lda     $ec
        bmi     @a9e3
        longa
        asl4
        sta     $0551
        shorta0
        bra     @a9f5
@a9e3:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0551
        shorta0
@a9f5:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $60: change palette ]

; $eb = vram palette (0..15)
; $ec = character palette (0..31)

EventCmd_60:
@a9fa:  longa
        lda     $eb
        and     #$00ff
        asl5
        tay
        lda     $ec
        and     #$00ff
        asl5
        tax
        shorta0
        lda     #$7e
        pha
        plb
        longa
        lda     #$0010
        sta     $1e
@aa20:  lda     f:MapSpritePal,x
        sta     $7200,y
        sta     $7400,y
        inx2
        iny2
        dec     $1e
        bne     @aa20
        shorta0
        tdc
        pha
        plb
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $61: filter colors ]

; $eb = filter number (0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = magenta, 6 = cyan, 7 = white)
; $ec = color range begin
; $ed = color range end

EventCmd_61:
@aa3d:  lda     $eb
        asl
        tax
        longa
        lda     f:ColorFilterTbl,x
        sta     $20
        shorta0
        lda     $ed
        inc
        sec
        sbc     $ec
        tay
        lda     $ec
        longa
        asl
        tax
        shorta0
@aa5c:  lda     $7e7200,x               ; red
        and     #$1f
        sta     $1e
        lda     $7e7201,x               ; green
        lsr2
        and     #$1f
        clc
        adc     $1e
        sta     $1e
        stz     $1f
        longa
        lda     $7e7200,x               ; blue
        asl3
        xba
        and     #$001f
        clc
        adc     $1e                     ; average color (r + g + b) / 3
        sta     hWRDIVL
        shorta
        lda     #3
        sta     hWRDIVB
        nop5
        inx2
        lda     hRDDIVL                 ; blue
        asl2
        xba
        lda     hRDDIVL                 ; red
        longa
        sta     $1e
        lda     hRDDIVL                 ; green
        xba
        lsr3
        ora     $1e
        and     $20                     ; filter
        sta     $7e73fe,x               ; set filtered color
        shorta0
        dey
        bne     @aa5c
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; color filter values
ColorFilterTbl:
@aabb:  .word   $0000,$001f,$03e0,$03ff,$7c00,$7c1f,$7fe0,$7fff

; ------------------------------------------------------------------------------

; [ event command $62: mosaic screen ]

; $eb = speed

EventCmd_62:
@aacb:  lda     $eb
        sta     $11f0       ; mosaic speed
        ldx     #$1e00
        stx     $0796       ; mosaic counter
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $63: enable flashlight ]

; $eb = flashlight radius (0..31)

EventCmd_63:
@aadb:  lda     $eb
        and     #$1f
        ora     #$80
        sta     $077b
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $64: set bg animation frame ]

; $eb = animation tile (0..7)
; $ec = frame (0..3)

EventCmd_64:
@aae9:  lda     $eb
        sta     hWRMPYA
        lda     #$0d
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     $ec
        and     #$03
        asl
        sta     $1069,x
        stz     $106a,x
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $65: set bg animation speed ]

; $eb = animation tile (0..7)
; $ec = speed (signed)

EventCmd_65:
@ab09:  lda     $eb
        sta     hWRMPYA
        lda     #$0d
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     $ec
        and     #$7f
        longa
        asl4
        sta     $1e
        shorta0
        lda     $ec
        bpl     @ab38
        longa
        lda     $1e
        eor     $02
        inc
        sta     $1e
        shorta0
@ab38:  longa
        lda     $1e
        sta     $106b,x
        shorta0
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $6a: load map (wait for fade out) ]

; +$eb = --ddnzpm mmmmmmmm
;        d: facing direction
;        n: show map name
;        z: z-level
;        p: set destination as parent map
;        m: map number ($01fe = previous map, $01ff = parent map)
;  $ed = x position
;  $ee = y position
;  $ef = efs---vv
;        e: enable map startup event
;        f: disable map fade in when loading
;        s: don't update map size when loading map
;        v: world map vehicle (0 = no vehicle, 1 = airship, 2 = chocobo)

EventCmd_6a:
@ab47:  jsr     PushPartyMap
        jsr     FadeOut
        lda     $e1
        ora     #$40        ; wait for fade out
        sta     $e1
        bra     _ab5a

; ------------------------------------------------------------------------------

; [ event command $6b: load map (no fade out) ]

; +$eb = --ddnzpm mmmmmmmm
;        d: facing direction
;        n: show map name
;        z: z-level
;        p: set destination as parent map
;        m: map number ($01fe = previous map, $01ff = parent map)
;  $ed = x position
;  $ee = y position
;  $ef = efs---vv
;        e: enable map startup event
;        f: disable map fade in when loading
;        s: don't update map size when loading map
;        v: world map vehicle (0 = no vehicle, 1 = airship, 2 = chocobo)

EventCmd_6b:
@ab55:  jsr     PushPartyMap
        stz     $4a
_ab5a:  lda     #$01        ; enable map load
        sta     $84
        lda     $ef         ; map startup flags
        sta     $11fa
        longa
        lda     $eb         ; branch if not setting parent map
        and     #$0200
        beq     @ab79
        lda     $eb         ; set parent map
        and     #$01ff
        sta     $1f69
        lda     $ed
        sta     $1f6b
@ab79:  lda     $eb         ; map number
        sta     $1f64
        and     #$01ff
        cmp     #$01ff      ; branch if loading parent map
        beq     @abcd
        cmp     #$01fe      ; branch if loading previous map
        beq     @abd2
        tax
        shorta0
        cpx     #$0003
        bcs     @abaf       ; branch if not loading a 3d map
        ldx     $ed
        stx     $1f60       ; set world map position
@ab99:  longac
        lda     $e5
        adc     #$0006
        sta     $11fd       ; set world map event pointer
        shorta
        lda     $e7
        adc     #$00
        sta     $11ff
        tdc
        bra     @ac06
@abaf:  lda     $ed         ; set position
        sta     $1fc0
        lda     $ee
        sta     $1fc1
@abb9:  lda     $ec         ; set facing direction
        and     #$30
        lsr4
        sta     $0743
        lda     $ec         ; show map name
        and     #$08
        sta     $0745
        bra     @ac06
@abcd:  jsr     RestoreParentMap
        bra     @abdb
@abd2:  shorta0
        lda     $1fd2
        sta     $1f68
@abdb:  longa
        lda     $eb
        and     #$fe00
        ora     $1f69
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     @abfb
        lda     $1f6b
        sta     $1f60
        shorta0
        bra     @ab99
@abfb:  lda     $1f6b
        sta     $1fc0
        shorta0
        bra     @abb9
@ac06:  lda     #6
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $6c: set parent map ]

; +$eb = --ddnzpm mmmmmmmm
;        d: facing direction
;        n: show map name
;        z: z-level
;        p: set destination as parent map
;        m: map number
;  $ed = x position
;  $ee = y position
;  $ef = parent map facing direction

EventCmd_6c:
@ac0b:  ldy     $eb
        sty     $1f69
        ldy     $ed
        sty     $1f6b
        lda     $ef
        sta     $1fd2
        lda     #6
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $75: update map data ]

EventCmd_75:
@ac1f:  lda     $055a
        cmp     #$05
        bne     @ac2a
        dec
        sta     $055a
@ac2a:  lda     $055b
        cmp     #$05
        bne     @ac35
        dec
        sta     $055b
@ac35:  lda     $055c
        cmp     #$05
        bne     @ac40
        dec
        sta     $055c
@ac40:  lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $73: change map data (update immediately) ]

; $eb = x position
; $ec = bbyyyyyy
;       b: 0 = bg1, 1 = bg2, 2 = bg3
;       y: y position
; $ed = width
; $ee = height

EventCmd_73:
@ac45:  lda     $ec
        and     #$c0
        bne     @ac52
        lda     #$04
        sta     $055a
        bra     _ac62
@ac52:  cmp     #$40
        bne     @ac5d
        lda     #$04
        sta     $055b
        bra     _ac62
@ac5d:  lda     #$04
        sta     $055c
; fall through

; ------------------------------------------------------------------------------

; [ event command $74: change map data (no update) ]

; $eb = x position
; $ec = bbyyyyyy
;       b: 0 = bg1, 1 = bg2, 2 = bg3
;       y: y position
; $ed = width
; $ee = height

_ac62:
EventCmd_74:
@ac62:  lda     $ec
        and     #$c0
        bne     @ac76
        lda     $055a
        cmp     #$04
        beq     @ac94
        lda     #$05
        sta     $055a
        bra     @ac94
@ac76:  cmp     #$40
        bne     @ac88
        lda     $055b
        cmp     #$04
        beq     @ac94
        lda     #$05
        sta     $055b
        bra     @ac94
@ac88:  lda     $055c
        cmp     #$04
        beq     @ac94
        lda     #$05
        sta     $055c
@ac94:  lda     $eb
        sta     $8f
        lda     $ec
        and     #$3f
        sta     $90
        longac
        lda     $e5
        adc     #$0003
        sta     $8c
        shorta
        lda     $e7
        adc     #$00
        sta     $8e
        lda     $ed
        sta     hWRMPYA
        lda     $ee
        sta     hWRMPYB
        nop2
        longac
        lda     hRDMPYL
        adc     #$0002
        adc     $8c
        sta     $e5
        shorta
        lda     $8e
        adc     #$00
        sta     $e7
        tdc
        lda     $ec
        and     #$c0
        bne     @acde
        ldx     #$0000
        stx     $2a
        jmp     ModifyMap
@acde:  bmi     @ace8
        ldx     #$4000
        stx     $2a
        jmp     ModifyMap
@ace8:  ldx     #$8000
        stx     $2a
        jmp     ModifyMap

; ------------------------------------------------------------------------------

; [ event command $80: give item ]

; $eb = item number

EventCmd_80:
@acf0:  lda     $eb
        sta     $1a
        jsr     GiveItem
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ add item to inventory ]

; $1a = item number

GiveItem:
@acfc:  ldx     $00
@acfe:  lda     $1869,x     ; look for item
        cmp     $1a
        beq     @ad22       ; branch if found
        inx
        cpx     #$0100
        bne     @acfe
        ldx     $00         ; look for first empty slot
@ad0d:  lda     $1869,x
        cmp     #$ff
        beq     @ad17
        inx
        bra     @ad0d
@ad17:  lda     $1a         ; set item number
        sta     $1869,x
        lda     #$01        ; quantity 1
        sta     $1969,x
        rts
@ad22:  lda     $1969,x
        cmp     #$63        ; max quantity 99
        beq     @ad2c
        inc     $1969,x     ; add 1 to quantity
@ad2c:  rts

; ------------------------------------------------------------------------------

; [ event command $81: take item ]

; $eb = item number

EventCmd_81:
@ad2d:  ldx     $00
@ad2f:  lda     $1869,x     ; look for item
        cmp     $eb
        beq     @ad3e
        inx
        cpx     #$0100
        bne     @ad2f
        bra     @ad4b       ; return if not found
@ad3e:  dec     $1969,x     ; subtract 1 from quantity
        lda     $1969,x
        bne     @ad4b
        lda     #$ff        ; set slot empty if there's none left
        sta     $1869,x
@ad4b:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $84: give gp ]

; +$eb = gp amount

EventCmd_84:
@ad50:  longac
        lda     $1860       ; add gp
        adc     $eb
        sta     $1860
        shorta0
        adc     $1862
        sta     $1862
        cmp     #$98        ; max gp 9999999
        bcc     @ad7a
        ldx     $1860
        cpx     #$967f
        bcc     @ad7a
        ldx     #$967f
        stx     $1860
        lda     #$98
        sta     $1862
@ad7a:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $85: take gp ]

; +$eb = gp amount

EventCmd_85:
@ad7f:  lda     $1eb7       ; clear "not enough gp" flag
        and     #$bf
        sta     $1eb7
        longa
        lda     $1860       ; subtract gp amount
        sec
        sbc     $eb
        sta     $2a
        shorta0
        lda     $1862
        sbc     #$00
        sta     $2c
        cmp     #$a0        ; branch if total is still positive
        bcc     @ada9
        lda     $1eb7       ; set "not enough gp" flag
        ora     #$40
        sta     $1eb7
        bra     @adb3
@ada9:  ldx     $2a         ; set new gp amount
        stx     $1860
        lda     $2c
        sta     $1862
@adb3:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $86: give esper ]

; $eb = esper number ($36..$50)

EventCmd_86:
@adb8:  lda     $eb
        sec
        sbc     #$36
        sta     $eb
        and     #$07
        tax
        lda     $eb
        lsr3
        tay
        lda     $1a69,y     ; set the appropriate esper bit
        ora     f:BitOrTbl,x
        sta     $1a69,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $87: take esper ]

; $eb = esper number ($36..$50)

EventCmd_87:
@add7:  lda     $eb
        sec
        sbc     #$36
        sta     $eb
        jsr     GetSwitchOffset
        lda     $1a69,y
        and     f:BitAndTbl,x
        sta     $1a69,y     ; clear the appropriate esper bit
        ldy     $00
@aded:  lda     $161e,y     ; remove the esper if equipped on a character
        cmp     $eb
        bne     @adf9
        lda     #$ff
        sta     $161e,y
@adf9:  longac
        tya                 ; next character
        adc     #$0025
        tay
        shorta0
        cpy     #$0250
        bne     @aded
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ unused event command: teach spell ]

; $eb = character number (0..12)
; $ec = spell number (0..53)

GiveMagic:
@ae0d:  lda     $eb
        sta     hWRMPYA
        lda     #$36        ; get pointer to character's spell data
        sta     hWRMPYB
        lda     $ec
        longac
        nop
        adc     hRDMPYL
        tax
        shorta0
        lda     #$ff
        sta     $1a6e,x     ; set spell learn %
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $88: remove status ]

; +$eb = status to clear (inverse bit mask)

EventCmd_88:
@ae2d:  jsr     CalcCharPtr
        cpy     #$0250
        bcs     @ae42       ; return if not a character
        longa
        lda     $1614,y     ; clear status
        and     $ec
        sta     $1614,y
        shorta0
@ae42:  lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $89: set status ]

; +$eb = status to set

EventCmd_89:
@ae47:  jsr     CalcCharPtr
        cpy     #$0250
        bcs     @ae5c       ; return if not a character
        longa
        lda     $1614,y     ; set status
        ora     $ec
        sta     $1614,y
        shorta0
@ae5c:  lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $8a: toggle status ]

; +$eb = status to toggle

EventCmd_8a:
@ae61:  jsr     CalcCharPtr
        cpy     #$0250
        bcs     @ae76       ; return if not a character
        longa
        lda     $1614,y     ; toggle status
        eor     $ec
        sta     $1614,y
        shorta0
@ae76:  lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $8b: add/subtract hp ]

; $eb = character number
; $ec = shhhhhhh ($ff = set to max)
;       s: 0 = add, 1 = subtract
;       h: pointer to constant below (1, 2, 4, 8, 16, 32, 64, 128)

EventCmd_8b:
@ae7b:  jsr     CalcCharPtr
        cpy     #$0250
        bcc     @ae86       ; return if not a character
        jmp     @aed3
@ae86:  jsr     CalcMaxHP
        lda     $ec
        and     #$7f
        cmp     #$7f
        beq     @aec9       ; branch if setting to maximum
        asl
        tax
        lda     $ec
        bmi     @aeae       ; branch if subtracting hp
        longac
        lda     $1609,y     ; add constant
        adc     f:HPTbl,x
        cmp     $1e
        bcc     @aea6       ; can't go higher than max
        lda     $1e
@aea6:  sta     $1609,y
        shorta0
        bra     @aed3
@aeae:  longa
        lda     $1609,y     ; subtract constant
        beq     @aec1
        sec
        sbc     f:HPTbl,x
        beq     @aebe
        bpl     @aec1
@aebe:  lda     #$0001      ; can't go less than 1
@aec1:  sta     $1609,y
        shorta0
        bra     @aed3
@aec9:  longa        ; set hp to max
        lda     $1e
        sta     $1609,y
        shorta0
@aed3:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; hp add/subtract constants
HPTbl:
@aed8:  .word   1,2,4,8,16,32,64,128

; ------------------------------------------------------------------------------

; [ calculate max hp w/ boost ]

; +$1e = max hp (out)

CalcMaxHP:
@aee8:  phx
        longa
        lda     $160b,y     ; max hp (base)
        and     #$3fff
        sta     $1e
        lsr
        sta     $20         ; +$20 = 50% of max
        lsr
        sta     $22         ; +$22 = 25% of max
        lsr
        sta     $24         ; +$24 = 12.5% of max
        shorta0
        lda     $160c,y
        and     #$c0        ; branch if no boost
        beq     @af33
        cmp     #$40        ; branch if 25% boost
        beq     @af28
        cmp     #$80        ; branch if 50% boost
        beq     @af1b
        longac
        lda     $1e         ; add 12.5%
        adc     $24
        sta     $1e
        shorta0
        bra     @af33
@af1b:  longac
        lda     $1e         ; add 50%
        adc     $20
        sta     $1e
        shorta0
        bra     @af33
@af28:  longac
        lda     $1e         ; add 25%
        adc     $22
        sta     $1e
        shorta0
@af33:  ldx     #9999
        cpx     $1e
        bcs     @af3c
        stx     $1e
@af3c:  plx
        rts

; ------------------------------------------------------------------------------

; [ event command $8c: add/subtract mp ]

; $eb = character number
; $ec = smmmmmmm ($ff = set to max)
;       s: 0 = add, 1 = subtract
;       m: pointer to constant below (all 0)

EventCmd_8c:
@af3e:  jsr     CalcCharPtr
        cpy     #$0250
        bcc     @af49
        jmp     @af90
@af49:  jsr     CalcMaxMP
        lda     $ec
        and     #$7f
        cmp     #$7f
        beq     @af86
        asl
        tax
        lda     $ec
        bmi     @af71
        longac
        lda     $160d,y
        adc     f:MPTbl,x
        cmp     $1e
        bcc     @af69
        lda     $1e
@af69:  sta     $160d,y
        shorta0
        bra     @af90
@af71:  longa
        lda     $160d,y
        sec
        sbc     f:MPTbl,x
        bpl     @af7e
        tdc
@af7e:  sta     $160d,y
        shorta0
        bra     @af90
@af86:  longa
        lda     $1e
        sta     $160d,y
        shorta0
@af90:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; mp add/subtract constants
MPTbl:
@af95:  .word   0,0,0,0,0,0,0

; ------------------------------------------------------------------------------

; [ calculate max mp w/ boost ]

; +$1e = max mp (out)

CalcMaxMP:
@afa3:  phx
        longa
        lda     $160f,y
        and     #$3fff
        sta     $1e
        lsr
        sta     $20
        lsr
        sta     $22
        lsr
        sta     $24
        shorta0
        lda     $1610,y
        and     #$c0
        beq     @afed
        cmp     #$40
        beq     @afe2
        cmp     #$80
        beq     @afd5
        longac
        lda     $1e
        adc     $24
        sta     $1e
        shorta
        bra     @afed
@afd5:  longac
        lda     $1e
        adc     $20
        sta     $1e
        shorta0
        bra     @afed
@afe2:  longac
        lda     $1e
        adc     $22
        sta     $1e
        shorta0
@afed:  ldx     #999                    ; 999 max
        cpx     $1e
        bcs     @aff6
        stx     $1e
@aff6:  plx
        rts

; ------------------------------------------------------------------------------

; [ event command $8f: give all swdtechs ]

EventCmd_8f:
@aff8:  lda     #$ff
        sta     $1cf7
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $90: give bum rush ]

EventCmd_90:
@b002:  lda     $1d28
        ora     #$80
        sta     $1d28
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $98: name change menu ]

; $eb = character number

EventCmd_98:
@b00f:  jsr     CalcCharPtr
        longa
        tya
        clc
        adc     #$1600
        sta     $0201       ; +$0201 = absolute pointer to character data
        shorta0
        lda     #$01
        sta     $0200       ; $0200 = #$01 (name change menu)
        jsr     OpenMenu
        lda     #$01
        sta     $84         ; enable map load
        lda     #$e0
        sta     $11fa       ; map startup flags
        lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $99: party select menu ]

;  $eb = number of parties (msb = clear parties, crashes if 0)
; +$ec = forced characters

EventCmd_99:
@b035:  ldy     $0803       ; clear pointers to character object data
        sty     $07fb
        ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        lda     $eb
        sta     $0201       ; $0201 = number of parties
        ldx     $ec
        stx     $0202       ; +$0202 = forced characters
        lda     #$04
        sta     $0200       ; $0200 = #$04 (party select)
        jsr     OpenMenu
        jsr     _c0714a
        jsr     GetTopChar
        lda     #$01
        sta     $84         ; enable map load
        lda     #$c0
        sta     $11fa       ; map startup flags
        lda     #4
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $9b: shop menu ]

; $eb = shop number

EventCmd_9b:
@b06d:  lda     $eb
        sta     $0201       ; $0201 = shop number
        ldy     $0803
        lda     $0879,y
        sta     $0202       ; $0202 = showing character graphic index
        lda     #$03
        sta     $0200       ; $0200 = #$03 (shop)
        jsr     OpenMenu
        lda     #$01
        sta     $84         ; enable map load
        lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $9c: optimize character's equipment ]

; $eb = character number

EventCmd_9c:
@b08c:  lda     $eb
        sta     $0201       ; $0201 = character number
        jsr     OptimizeEquip
        jsr     UpdateEquip
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $9d: final battle menu ]

EventCmd_9d:
@b09c:  lda     #$08
        sta     $0200       ; $0200 = #$08 (final battle menu)
        jsr     OpenMenu
        lda     #$01
        sta     $84         ; enable map load
        lda     #$e0
        sta     $11fa       ; map startup flags
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $9a: colosseum menu ]

EventCmd_9a:
@b0b2:  lda     #$07
        sta     $0200       ; $0200 = #$07 (colosseum menu)
        jsr     OpenMenu
        lda     $0205
        cmp     #$ff
        beq     @b0c5       ; branch if no valid item was selected
        lda     #$40
        bra     @b0c6
@b0c5:  tdc
@b0c6:  sta     $1a
        lda     $1ebd       ; set or clear event bit for valid colosseum item
        and     #$bf
        ora     $1a
        sta     $1ebd
        lda     #$c0
        sta     $11fa       ; map startup flags
        lda     #$01
        sta     $84         ; enable map load
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $a0: set timer ]

;  +$eb = starting counter value (frames)
; ++$ed = pfrmxxee eeeeeeee eeeeeeee
;         p: pause timer in menu and battle
;         f: timer visible on field (timer 0 only)
;         r: used if timer runs out during emperor's banquet
;         m: timer visible in menu and battle (timer 0 only)
;         x: timer number
;         e: event pointer (+$ca0000)

EventCmd_a0:
@b0e0:  lda     $ef         ; timer number
        and     #$0c
        sta     $1a
        lsr
        clc
        adc     $1a
        tay
        lda     $eb         ; set counter
        sta     $1189,y
        lda     $ec
        sta     $118a,y
        lda     $ed         ; set event pointer
        sta     $118b,y
        lda     $ee
        sta     $118c,y
        lda     $ef
        sta     $1188,y     ; set flags
        and     #$03
        sta     $118d,y     ; bank byte of event pointer
        lda     #6
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a1: reset timer ]

; $eb = timer number

EventCmd_a1:
@b10e:  lda     $eb
        asl
        sta     $1a
        asl
        clc
        adc     $1a
        tay
        tdc
        sta     $1188,y
        sta     $1189,y
        sta     $118a,y
        sta     $118b,y
        sta     $118c,y
        sta     $118d,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a2: clear overlay tiles ]

EventCmd_a2:
@b130:  jsr     ClearOverlayTiles
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b0: loop start ]

; $eb = loop count ($ff = loop until event bit clear)

EventCmd_b0:
@b138:  lda     #$02
        jsr     PushEventPtr
        lda     $eb
        sta     $05c4,x     ; set loop count
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $b1: loop end ]

EventCmd_b1:
@b145:  ldx     $e8         ; event stack pointer
        lda     $05c4,x     ; decrement loop count
        dec
        sta     $05c4,x
        beq     @b162       ; branch if done looping
        lda     $05f1,x     ; set event pc back to start of loop
        sta     $e5
        lda     $05f2,x
        sta     $e6
        lda     $05f3,x
        sta     $e7
        jmp     _c09a6d
@b162:  ldx     $e8         ; decrement stack pointer
        dex3
        stx     $e8
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ unused ]

@b16e:  rts

; ------------------------------------------------------------------------------

; [ event command $bc: loop if event bit is clear ]

; used to wait for keypress
; +$eb = event bit

EventCmd_bc:
@b16f:  lda     $ec
        xba
        lda     $eb
        jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitOrTbl,x
        bne     @b194       ; branch if set
        ldx     $e8         ; set event pc back to start of loop
        lda     $05f1,x
        sta     $e5
        lda     $05f2,x
        sta     $e6
        lda     $05f3,x
        sta     $e7
        jmp     _c09a6d
@b194:  ldx     $e8         ; decrement stack pointer
        dex3
        stx     $e8
        lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ unused ]

@b1a0:  rts

; ------------------------------------------------------------------------------

; [ event command $b2: jump to subroutine ]

; ++$eb = event pointer

EventCmd_b2:
@b1a1:  lda     #$04        ; a = event pc + 4
_b1a3:  ldx     $e8
        clc
        adc     $e5
        sta     $0594,x     ; set return address
        lda     $e6
        adc     #$00
        sta     $0595,x
        lda     $e7
        adc     #$00
        sta     $0596,x
        lda     $eb         ; set event pc
        sta     $e5
        sta     $05f4,x
        lda     $ec
        sta     $e6
        sta     $05f5,x
        lda     $ed
        clc
        adc     #$ca
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8         ; increment stack pointer
        lda     #1
        sta     $05c4,x     ; loop count (do subroutine once)
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $b3: jump to subroutine multiple times ]

;   $eb = loop count
; ++$ec = event pointer

EventCmd_b3:
@b1df:  ldx     $e8         ; a = event pc + 5
        lda     $e5
        clc
        adc     #$05
        sta     $0594,x     ; set return address
        lda     $e6
        adc     #$00
        sta     $0595,x
        lda     $e7
        adc     #$00
        sta     $0596,x
        lda     $ec
        sta     $e5
        sta     $05f4,x
        lda     $ed
        sta     $e6
        sta     $05f5,x
        lda     $ee
        clc
        adc     #$ca
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8         ; increment stack pointer
        lda     $eb
        sta     $05c4,x     ; set loop count
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $b4: pause (short) ]

; $eb = pause length (frames)

EventCmd_b4:
@b21d:  lda     $eb
        tax
        stx     $e3
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b5: pause (long) ]

; $eb = pause length (frames * 15)

EventCmd_b5:
@b227:  lda     $eb
        sta     hWRMPYA
        lda     #$0f
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        stx     $e3
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $91: pause (15 frames) ]

EventCmd_91:
@b23f:  ldx     #15
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $92: pause (30 frames) ]

EventCmd_92:
@b249:  ldx     #30
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $93: pause (45 frames) ]

EventCmd_93:
@b253:  ldx     #45
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $94: pause (60 frames) ]

EventCmd_94:
@b25d:  ldx     #60
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $95: pause (120 frames) ]

EventCmd_95:
@b267:  ldx     #120
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $bd: jump (50% chance) ]

; ++$eb = event pointer

EventCmd_bd:
@b271:  jsr     Rand
        cmp     #$80
        bcs     @b28b       ; 1/2 chance to branch
        longac
        lda     $e5
        adc     #4          ; increment event pc and continue
        sta     $e5
        shorta0
        adc     $e7
        sta     $e7
        jmp     _c09a6d
@b28b:  ldx     $eb         ; set new event pc
        stx     $e5
        lda     $ed
        clc
        adc     #$ca
        sta     $e7
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $b7: jump (battle flag conditional) ]

;   $eb = battle flag (+$1dc9)
; ++$ec = event pointer

EventCmd_b7:
@b299:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1dc9,y
        and     f:BitOrTbl,x   ; branch if bit is clear
        beq     @b2ba
        longac
        lda     $e5
        adc     #$0005      ; increment event pc and continue
        sta     $e5
        shorta0
        adc     $e7
        sta     $e7
        jmp     _c09a6d
@b2ba:  ldx     $ec         ; set new event pc
        stx     $e5
        lda     $ee
        clc
        adc     #$ca
        sta     $e7
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $c0-$c7: jump (event bit conditional, or) ]

; +$eb = sbbbbbbb bbbbbbbb
;        s: 1 = branch if set, 0 = branch if clear
;        b: event bit

; c0 +t1 ++aa                                 if(t1) jump; else continue;
; c1 +t1 +t2 ++aa                             if(t1 || t2) jump; else continue;
; c2 +t1 +t2 +t3 ++aa                         if(t1 || t2 || t3) jump; else continue;
; c3 +t1 +t2 +t3 +t4 ++aa                     if(t1 || t2 || t3 || t4) jump; else continue;
; c4 +t1 +t2 +t3 +t4 +t5 ++aa                 if(t1 || t2 || t3 || t4 || t5) jump; else continue;
; c5 +t1 +t2 +t3 +t4 +t5 +t6 ++aa             if(t1 || t2 || t3 || t4 || t5 || t6) jump; else continue;
; c6 +t1 +t2 +t3 +t4 +t5 +t6 +t7 ++aa         if(t1 || t2 || t3 || t4 || t5 || t6 || t7) jump; else continue;
; c7 +t1 +t2 +t3 +t4 +t5 +t6 +t7 +t8 ++aa     if(t1 || t2 || t3 || t4 || t5 || t6 || t7 || t8) jump; else continue;

EventCmd_c0:
EventCmd_c1:
EventCmd_c2:
EventCmd_c3:
EventCmd_c4:
EventCmd_c5:
EventCmd_c6:
EventCmd_c7:
@b2c8:  lda     $ea
        sec
        sbc     #$bf
        asl
        inc
        tay                 ; +$20 = pointer to jump address
        sty     $20
        ldy     #$0001
        sty     $1e
@b2d7:  ldy     $1e
        longa
        lda     [$e5],y     ; branch if testing if set
        bmi     @b2e8
        shorta
        jsr     GetEventSwitch0
        beq     @b312       ; branch if clear
        bra     @b2f2
.a16
@b2e8:  and     #$7fff
        shorta
        jsr     GetEventSwitch0
        bne     @b312       ; branch if set
@b2f2:  ldy     $1e         ; next bit
        iny2
        sty     $1e
        cpy     $20
        bne     @b2d7
        iny3
        longac
        tya
        adc     $e5         ; increment event pc and continue
        sta     $e5
        shorta
        lda     $e7
        adc     #$00
        sta     $e7
        tdc
        jmp     _c09a6d
@b312:  ldy     $20         ; set new event pc
        longa
        lda     [$e5],y
        sta     $2a
        shorta0
        iny2
        lda     [$e5],y
        clc
        adc     #$ca
        sta     $e7
        ldy     $2a
        sty     $e5
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $c8-$cf: jump (event bit conditional, and) ]

; +$eb = sbbbbbbb bbbbbbbb
;        s: 1 = branch if set, 0 = branch if clear
;        b: event bit

; c8 +t1 ++aa                                 if(t1) jump; else continue;
; c9 +t1 +t2 ++aa                             if(t1 && t2) jump; else continue;
; ca +t1 +t2 +t3 ++aa                         if(t1 && t2 && t3) jump; else continue;
; cb +t1 +t2 +t3 +t4 ++aa                     if(t1 && t2 && t3 && t4) jump; else continue;
; cc +t1 +t2 +t3 +t4 +t5 ++aa                 if(t1 && t2 && t3 && t4 && t5) jump; else continue;
; cd +t1 +t2 +t3 +t4 +t5 +t6 ++aa             if(t1 && t2 && t3 && t4 && t5 && t6) jump; else continue;
; ce +t1 +t2 +t3 +t4 +t5 +t6 +t7 ++aa         if(t1 && t2 && t3 && t4 && t5 && t6 && t7) jump; else continue;
; cf +t1 +t2 +t3 +t4 +t5 +t6 +t7 +t8 ++aa     if(t1 && t2 && t3 && t4 && t5 && t6 && t7 && t8) jump; else continue;

EventCmd_c8:
EventCmd_c9:
EventCmd_ca:
EventCmd_cb:
EventCmd_cc:
EventCmd_cd:
EventCmd_ce:
EventCmd_cf:
@b32d:  lda     $ea
        sec
        sbc     #$c7
        asl
        inc
        tay                 ; +$20 = pointer to jump address
        sty     $20
        ldy     #$0001
        sty     $1e
@b33c:  ldy     $1e
        longa
        lda     [$e5],y     ; branch if testing if set
        bmi     @b34d
        shorta
        jsr     GetEventSwitch0
        bne     @b37c
        bra     @b357
.a16
@b34d:  and     #$7fff
        shorta
        jsr     GetEventSwitch0
        beq     @b37c
@b357:  ldy     $1e
        iny2
        sty     $1e
        cpy     $20
        bne     @b33c
        ldy     $20         ; set new event pc
        longa
        lda     [$e5],y
        sta     $2a
        shorta0
        iny2
        lda     [$e5],y
        clc
        adc     #$ca
        sta     $e7
        ldy     $2a
        sty     $e5
        jmp     _c09a6d
@b37c:  ldy     $20         ; increment event pc and continue
        iny3
        longac
        tya
        adc     $e5
        sta     $e5
        shorta
        lda     $e7
        adc     #$00
        sta     $e7
        tdc
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $e7: set character portrait ]

; $eb = character number

EventCmd_e7:
@b394:  lda     $eb
        sta     $0795
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e4: get active party number ]

EventCmd_e4:
@b39e:  tdc
        sta     $1eb5       ; +$1eb4 = 1 << party number
        lda     $1a6d
        inc
        tax
        lda     #$01
@b3a9:  dex
        beq     @b3af
        asl
        bra     @b3a9
@b3af:  sta     $1eb4
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e3: get characters in any party ]

EventCmd_e3:
@b3b7:  tdc
        sta     $1eb4       ; +$1eb4 = characters in any party
        sta     $1eb5
        ldx     $00
        txy
@b3c1:  lda     $0867,y
        and     #$07
        beq     @b3d2
        lda     $1eb4
        ora     f:BitOrTbl,x
        sta     $1eb4
@b3d2:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b3c1
        ldx     $00
        txy
@b3e5:  lda     $09af,y
        and     #$07
        beq     @b3f6
        lda     $1eb5
        ora     f:BitOrTbl,x
        sta     $1eb5
@b3f6:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b3e5
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $de: get characters in active party ]

EventCmd_de:
@b40b:  tdc
        sta     $1eb4       ; +$1eb4 = characters in the active party
        sta     $1eb5
        ldx     $00
        txy
@b415:  lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @b429
        lda     $1eb4
        ora     f:BitOrTbl,x
        sta     $1eb4
@b429:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b415
        ldx     $00
        txy
@b43c:  lda     $09af,y
        and     #$07
        cmp     $1a6d
        bne     @b450
        lda     $1eb5
        ora     f:BitOrTbl,x
        sta     $1eb5
@b450:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b43c
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $df: get characters that are enabled objects ]

EventCmd_df:
@b465:  tdc
        sta     $1eb4
        sta     $1eb5
        ldx     $00
        txy
@b46f:  lda     $0867,y
        and     #$40
        beq     @b480
        lda     $1eb4
        ora     f:BitOrTbl,x
        sta     $1eb4
@b480:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b46f
        ldx     $00
        txy
@b493:  lda     $09af,y
        and     #$40
        beq     @b4a4
        lda     $1eb5
        ora     f:BitOrTbl,x
        sta     $1eb5
@b4a4:  longac
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b493
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e2: get showing character ]

EventCmd_e2:
@b4b9:  lda     #$20
        sta     $1a
        ldy     $00
        tyx
@b4c0:  lda     $1850,y
        and     #$07
        cmp     $1a6d
        bne     @b4d7
        lda     $1850,y
        and     #$18
        cmp     $1a
        bcs     @b4d7
        sta     $1a
        stx     $1e
@b4d7:  inx
        iny
        cpy     #$0010
        bne     @b4c0
        longa
        lda     $1e
        asl
        tax
        lda     $c0b4f3,x
        sta     $1eb4
        shorta0
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

@b4f3:  .word   $0001, $0002, $0004, $0008, $0010, $0020, $0040, $0080
        .word   $0100, $0200, $0400, $0800, $1000, $2000, $4000, $8000

; ------------------------------------------------------------------------------

; [ event command $e0: get initialized characters ]

EventCmd_e0:
@b513:  ldx     $1edc
        stx     $1eb4
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e1: get available characters ]

EventCmd_e1:
@b51e:  ldx     $1ede
        stx     $1eb4
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e8: set event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value

EventCmd_e8:
@b529:  lda     $eb
        asl
        tay
        longa
        lda     $ec
        sta     $1fc2,y
        shorta0
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e9: add to event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value to add

EventCmd_e9:
@b53c:  lda     $eb
        asl
        tay
        longac
        lda     $1fc2,y
        adc     $ec
        bcc     @b54b
        lda     $02
@b54b:  sta     $1fc2,y
        shorta0
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ea: subtract from event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value to subtract

EventCmd_ea:
@b556:  lda     $eb
        asl
        tay
        longa
        lda     $1fc2,y
        sec
        sbc     $ec
        bcs     @b566
        lda     $00
@b566:  sta     $1fc2,y
        shorta0
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $eb: compare event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value to compare to

EventCmd_eb:
@b571:  lda     $eb
        asl
        tay
        ldx     $1fc2,y
        cpx     $ec
        bcc     @b582
        beq     @b586
        lda     #$02        ; if variable is greater than value, $1eb4 = $0002
        bra     @b588
@b582:  lda     #$04        ; if variable is less than value, $1eb4 = $0004
        bra     @b588
@b586:  lda     #$01        ; if variable is equal to value, $1eb4 = $0001
@b588:  sta     $1eb4
        stz     $1eb5
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d0: set event bit ($0000-$00ff) ]

; $eb = event bit

EventCmd_d0:
@b593:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1e80,y
        ora     f:BitOrTbl,x
        sta     $1e80,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d2: set event bit ($0100-$01ff) ]

; $eb = event bit

EventCmd_d2:
@b5a7:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ea0,y
        ora     f:BitOrTbl,x
        sta     $1ea0,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d4: set event bit ($0200-$02ff) ]

; $eb = event bit

EventCmd_d4:
@b5bb:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ec0,y
        ora     f:BitOrTbl,x
        sta     $1ec0,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d1: clear event bit ($0000-$00ff) ]

; $eb = event bit

EventCmd_d1:
@b5cf:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitAndTbl,x
        sta     $1e80,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d3: clear event bit ($0100-$01ff) ]

; $eb = event bit

EventCmd_d3:
@b5e3:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ea0,y
        and     f:BitAndTbl,x
        sta     $1ea0,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d5: clear event bit ($0200-$02ff) ]

; $eb = event bit

EventCmd_d5:
@b5f7:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ec0,y
        and     f:BitAndTbl,x
        sta     $1ec0,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d6: set event bit ($0300-$03ff) ]

; $eb = event bit

EventCmd_d6:
@b60b:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ee0,y
        ora     f:BitOrTbl,x
        sta     $1ee0,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d8: set event bit ($0400-$04ff) ]

; $eb = event bit

EventCmd_d8:
@b61f:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f00,y
        ora     f:BitOrTbl,x
        sta     $1f00,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $da: set event bit ($0500-$05ff) ]

; $eb = event bit

EventCmd_da:
@b633:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f20,y
        ora     f:BitOrTbl,x
        sta     $1f20,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $dc: set event bit ($0600-$06ff) ]

; $eb = event bit

EventCmd_dc:
@b647:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f40,y
        ora     f:BitOrTbl,x
        sta     $1f40,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d7: clear event bit ($0300-$03ff) ]

; $eb = event bit

EventCmd_d7:
@b65b:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ee0,y
        and     f:BitAndTbl,x
        sta     $1ee0,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d9: clear event bit ($0400-$04ff) ]

; $eb = event bit

EventCmd_d9:
@b66f:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f00,y
        and     f:BitAndTbl,x
        sta     $1f00,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $db: clear event bit ($0500-$05ff) ]

; $eb = event bit

EventCmd_db:
@b683:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f20,y
        and     f:BitAndTbl,x
        sta     $1f20,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $dd: clear event bit ($0600-$06ff) ]

; $eb = event bit

EventCmd_dd:
@b697:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f40,y
        and     f:BitAndTbl,x
        sta     $1f40,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b8: set battle flag ]

; $eb = battle flag (+$1dc9)

EventCmd_b8:
@b6ab:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1dc9,y
        ora     f:BitOrTbl,x
        sta     $1dc9,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b9: clear battle flag ]

; $eb = battle flag (+$1dc9)

EventCmd_b9:
@b6bf:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1dc9,y
        and     f:BitAndTbl,x
        sta     $1dc9,y
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b6: jump based on dialog selection ]

; b6 ++a1 ++a2 ...
; a1 = event pointer for first selection, etc.

EventCmd_b6:
@b6d3:  lda     $056e
        asl
        sec
        adc     $056e
        tay
        lda     [$e5],y     ; set event pointer
        sta     $1e
        iny
        lda     [$e5],y
        sta     $1f
        iny
        lda     [$e5],y
        clc
        adc     #$ca
        sta     $e7
        ldy     $1e
        sty     $e5
        stz     $056e       ; clear dialog selection
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $be: jump to subroutine based on +$1eb4 ]

;   $eb = number of bits to check
; ++$ec = bbbb--aa aaaaaaaa aaaaaaaa
;         b = bit to check in +$1eb4
;         a = event pointer

EventCmd_be:
@b6f7:  lda     $eb
        asl
        sec
        adc     $eb
        inc
        sta     $1e
        stz     $1f
        ldy     #$0002
@b705:  lda     [$e5],y
        sta     $2a
        iny
        lda     [$e5],y
        sta     $2b
        iny
        lda     [$e5],y
        sta     $2c
        iny
        lsr4
        longac
        adc     #$01a0
        phy
        jsr     GetEventSwitch0
        ply
        shorta
        cmp     #$00
        bne     @b740
        cpy     $1e
        bne     @b705
        longac
        lda     $e5
        adc     $1e
        sta     $e5
        shorta
        lda     $e7
        adc     #$00
        sta     $e7
        tdc
        jmp     _c09a6d
@b740:  ldx     $e8
        lda     $1e
        clc
        adc     $e5
        sta     $0594,x
        lda     $e6
        adc     $1f
        sta     $0595,x
        lda     $e7
        adc     #$00
        sta     $0596,x
        lda     $2a
        sta     $e5
        sta     $05f4,x
        lda     $2b
        sta     $e6
        sta     $05f5,x
        lda     $2c
        and     #$03
        clc
        adc     #$ca
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8
        lda     #$01
        sta     $05c4,x
        jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ event command $f0: play song ]

; $eb = psssssss
;       p: 0 = normal start position, 1 = alternative start position
;       s: song number

EventCmd_f0:
@b780:  lda     $eb
        and     #$7f
        sta     $1301
        sta     $1f80
        lda     #$ff        ; volume = 100%
        sta     $1302
        lda     $eb
        bpl     @b797
        lda     #$14
        bra     @b799
@b797:  lda     #$10
@b799:  sta     $1300
        jsl     ExecSound_ext
@b7a0:  lda     hRDNMI
        bpl     @b7a0
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ef: play song (w/ volume) ]

; $eb = psssssss
;       p: 0 = normal start position, 1 = alternative start position
;       s: song number
; $ec = volume

EventCmd_ef:
@b7aa:  lda     $eb
        and     #$7f
        sta     $1301
        sta     $1f80
        lda     $ec
        sta     $1302
        lda     $eb
        bpl     @b7c1
        lda     #$14
        bra     @b7c3
@b7c1:  lda     #$10
@b7c3:  sta     $1300
        jsl     ExecSound_ext
@b7ca:  lda     hRDNMI
        bpl     @b7ca
        lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f1: fade song in ]

; $eb = psssssss
;       p: 0 = normal start position, 1 = alternative start position
;       s: song number
; $ec = fade speed (spc ticks)

EventCmd_f1:
@b7d4:  lda     $eb
        and     #$7f
        sta     $1301
        sta     $1f80
        lda     #$20
        sta     $1302
        lda     $eb
        bpl     @b7eb
        lda     #$14
        bra     @b7ed
@b7eb:  lda     #$10
@b7ed:  sta     $1300
        jsl     ExecSound_ext
        lda     #$81
        sta     $1300
        lda     $ec
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
@b807:  lda     hRDNMI
        bpl     @b807
        lda     #$03
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f2: fade song out ]

; $eb = fade speed (spc ticks)

EventCmd_f2:
@b811:  lda     #$81
        sta     $1300
        lda     $eb
        sta     $1301
        stz     $1302
        jsl     ExecSound_ext
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f3: fade in previous song ]

; $eb = fade speed (spc ticks)

EventCmd_f3:
@b827:  lda     #$10
        sta     $1300
        lda     $1309
        sta     $1301
        sta     $1f80
        stz     $1302
        jsl     ExecSound_ext
        lda     #$81
        sta     $1300
        lda     $eb
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f4: play game sound effect ]

; $eb = sound effect

EventCmd_f4:
@b854:  lda     $eb
        jsr     PlaySfx
        lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f5: play game sound effect (with pan) ]

; $eb = sound effect
; $ec = pan
; $ed = pan speed

EventCmd_f5:
@b85e:  lda     #$18        ; spc command $18 (play game sound effect)
        sta     $1300
        lda     $eb         ; sound effect index
        sta     $1301
        lda     #$80
        sta     $1302
        jsl     ExecSound_ext
        lda     #$83        ; spc command $83 (set sound effect pan w/ envelope)
        sta     $1300
        lda     $ec
        sta     $1301
        lda     $ed
        sta     $1302
        jsl     ExecSound_ext
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f6: spc command ]

; $eb = command
; $ec = data byte 1
; $ed = data byte 2

EventCmd_f6:
@b889:  lda     $eb
        sta     $1300
        lda     $ec
        sta     $1301
        lda     $ed
        sta     $1302
        jsl     ExecSound_ext
        lda     #$04
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f7: continue to next part of song ]

; used on the phantom train to progress to the next part of the song
; could also be used by dancing mad, though that song is controlled by the battle program

EventCmd_f7:
@b8a1:  lda     #$89        ; spc command $89 (continue to next part of song)
        sta     $1300
        jsl     ExecSound_ext
        lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f8: wait for spc ]

EventCmd_f8:
@b8af:  lda     hAPUIO2
        beq     @b8b5
        rts
@b8b5:  lda     #$01
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f9: wait for song position ]

; used during the opera scene and the ending to sync the music with the events
; $eb = song position

EventCmd_f9:
@b8ba:  lda     $eb
        cmp     hAPUIO1
        beq     @b8c2
        rts
@b8c2:  lda     #$02
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $fa: wait for song to end ]

EventCmd_fa:
@b8c7:  lda     hAPUIO3
        beq     @b8cd
        rts
@b8cd:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $fb & $fd: no effect ]

; $fb is in the event script a few places, usually right after a sound effect
; $fd is used by the map startup event

EventCmd_fb:
EventCmd_fd:
@b8d2:  lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $fe: return ]

EventCmd_fe:
@b8d7:  ldx     $e8         ; decrement event loop counter
        lda     $05c4,x
        dec
        sta     $05c4,x
        beq     @b8f4       ; branch if last loop
        lda     $05f1,x     ; set event pc to start of subroutine and continue
        sta     $e5
        lda     $05f2,x
        sta     $e6
        lda     $05f3,x
        sta     $e7
        jmp     _c09a6d
@b8f4:  ldx     $e8         ; decrement event stack pointer
        dex3
        stx     $e8
        lda     $0594,x     ; pop event pc
        sta     $e5
        lda     $0595,x
        sta     $e6
        lda     $0596,x
        sta     $e7
        cpx     $00
        bne     @b917
        ldy     $0803       ; if event stack gets back to the top, restore the party object movement type
        lda     $087d,y
        sta     $087c,y
@b917:  jmp     _c09a6d

; ------------------------------------------------------------------------------

; [ misc. unused event commands ]

; these will cause the game to lock up

EventCmd_66:
EventCmd_67:
EventCmd_68:
EventCmd_69:
EventCmd_6d:
EventCmd_6e:
EventCmd_6f:
EventCmd_76:
EventCmd_83:
EventCmd_9e:
EventCmd_9f:
EventCmd_a3:
EventCmd_a4:
EventCmd_a5:
EventCmd_e5:
EventCmd_e6:
EventCmd_ec:
EventCmd_ed:
EventCmd_ee:
EventCmd_fc:
EventCmd_ff:
@b91a:  rts

; ------------------------------------------------------------------------------

; [ event command $ab: game load menu ]

EventCmd_ab:
@b91b:  lda     #$02
        sta     $0200       ; $0200 = #$02 (load game)
        jsr     OpenMenu
        lda     $307ff1     ; add 13 to random number seed
        clc
        adc     #$0d
        sta     $307ff1
        sta     $1f6d       ; init random numbers
        sta     $1fa1
        sta     $1fa2
        sta     $1fa4
        sta     $1fa3
        sta     $1fa5
        lda     $0205       ; set/clear event bit if there is at least one saved game
        and     #$80
        sta     $1a
        lda     $1edf
        and     #$7f
        ora     $1a
        sta     $1edf
        stz     $58         ; don't reload the same map
        jsr     UpdateEquip
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ac: load saved game data ]

EventCmd_ac:
@b95e:  jsr     InitSavedGame
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a9: show title screen ]

EventCmd_a9:
@b966:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     TitleScreen_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     $0200
        and     #$80
        sta     $1a
        lda     $1edf       ; set/clear event bit if there is at least one saved game
        and     #$7f
        ora     $1a
        sta     $1edf
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $aa: opening credits ]

EventCmd_aa:
@b992:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     OpeningCredits_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     $0200
        and     #$80
        sta     $1a
        lda     $1edf       ; set/clear event bit if there is at least one saved game
        and     #$7f
        ora     $1a
        sta     $1edf
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $bb: the end cinematic ]

EventCmd_bb:
@b9be:  jsr     DisableInterrupts
        jml     $e5f400     ; the end cinematic

; ------------------------------------------------------------------------------

; [ event command $ae: magitek train ride scene ]

EventCmd_ae:
@b9c5:  jsr     PushDP
        jsr     DisableInterrupts
        phd
        phb
        php
        jsl     MagitekTrain_ext
        plp
        plb
        pld
        tdc
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $bf: ending airship scene ]

EventCmd_bf:
@b9e7:  jsr     PushDP
        jsr     DisableInterrupts
        phd
        phb
        php
        jsl     EndingAirshipScene2_ext
        plp
        plb
        pld
        tdc
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a6: disable pyramid ]

EventCmd_a6:
@ba09:  stz     $0781       ; disable pyramid
        jsr     ClearWindowPos
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a7: enable pyramid ]

; $eb = pyramid object

EventCmd_a7:
@ba14:  lda     #$01
        sta     $0781       ; enable pyramid
        lda     $eb
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        stx     $077f       ; set pointer to pyramid object
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ba: ending cinematic ]

EventCmd_ba:
@ba31:  lda     $eb         ; $0201 = ending cinematic number
        sta     $0201
        jsr     PushDP
        jsr     DisableInterrupts
        jsl     EndingCutscene_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        jsr     EnableInterrupts
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a8: floating island cutscene ]

EventCmd_a8:
@ba51:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     FloatingIslandScene_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ad: world of ruin cutscene ]

EventCmd_ad:
@ba69:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     WorldOfRuinScene_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ update a button and facing direction event bits ]

UpdateCtrlFlags:
@ba81:  ldy     $0803
        lda     $087f,y     ; party facing direction
        tax
        lda     $1eb6
        and     #$f0
        ora     f:BitOrTbl,x
        sta     $1eb6
        lda     $06         ; branch if a button is not down
        bpl     @baa2
        lda     $1eb6
        ora     #$10
        sta     $1eb6
        bra     @baaa
@baa2:  lda     $1eb6
        and     #$ef
        sta     $1eb6
@baaa:  rts

; ------------------------------------------------------------------------------

; [ get event bit (+$1e80) ]

GetEventSwitch0:
@baab:  jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0100-$01ff) ]

GetEventSwitch1:
@bab6:  jsr     GetSwitchOffset
        lda     $1ea0,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0300-$03ff) ]

GetNPCSwitch0:
@bac1:  jsr     GetSwitchOffset
        lda     $1ee0,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0400-$04ff) ]

GetNPCSwitch1:
@bacc:  jsr     GetSwitchOffset
        lda     $1f00,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0500-$05ff) ]

GetNPCSwitch2:
@bad7:  jsr     GetSwitchOffset
        lda     $1f20,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0600-$06ff) ]

GetNPCSwitch3:
@bae2:  jsr     GetSwitchOffset
        lda     $1f40,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get bit pointer ]

; a = bit number

GetSwitchOffset:
@baed:  longa
        tax
        lsr3
        tay                 ; y = byte pointer
        shorta0
        txa
        and     #$07
        tax                 ; x = bit mask pointer
        rts

; ------------------------------------------------------------------------------

; bit masks
BitOrTbl:
@bafc:  .byte   $01,$02,$04,$08,$10,$20,$40,$80

; inverse bit masks
BitAndTbl:
@bb04:  .byte   $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f

; ------------------------------------------------------------------------------

; [ clear event bits ]

InitEventSwitches:
@bb0c:  ldx     $00
@bb0e:  stz     $1e80,x
        inx
        cpx     #$0060
        bne     @bb0e
        rts

; ------------------------------------------------------------------------------

; [ clear treasure bits ]

InitTreasureSwitches:
@bb18:  ldx     $00
@bb1a:  stz     $1e40,x
        inx
        cpx     #$0030
        bne     @bb1a
        rts

; ------------------------------------------------------------------------------

; [ decrement timers ]

; called from other banks

DecTimersMenuBattle:
@bb24:  pha
        phx
        phy
        phb
        phd
        php
        shorta0
        longi
        tdc
        pha
        plb
        lda     $1dd1
        and     #$9f
        sta     $1dd1
        lda     $1188
        and     #$10
        beq     @bb49
        lda     $1dd1
        ora     #$40
        sta     $1dd1
@bb49:  lda     $1188
        bmi     @bb68
        ldx     $1189
        beq     @bb59
        dex
        stx     $1189
        bra     @bb68
@bb59:  lda     $1188       ; used during emperor's banquet
        and     #$20
        beq     @bb68
        lda     $1dd1
        ora     #$20
        sta     $1dd1
@bb68:  lda     $118e
        bmi     @bb87
        ldx     $118f
        beq     @bb78
        dex
        stx     $118f
        bra     @bb87
@bb78:  lda     $118e
        and     #$20
        beq     @bb87
        lda     $1dd1
        ora     #$20
        sta     $1dd1
@bb87:  lda     $1194
        bmi     @bba6
        ldx     $1195
        beq     @bb97
        dex
        stx     $1195
        bra     @bba6
@bb97:  lda     $1194
        and     #$20
        beq     @bba6
        lda     $1dd1
        ora     #$20
        sta     $1dd1
@bba6:  lda     $119a
        bmi     @bbc5
        ldx     $119b
        beq     @bbb6
        dex
        stx     $119b
        bra     @bbc5
@bbb6:  lda     $119a
        and     #$20
        beq     @bbc5
        lda     $1dd1
        ora     #$20
        sta     $1dd1
@bbc5:  plp
        pld
        plb
        ply
        plx
        pla
        rts

; ------------------------------------------------------------------------------

; [ decrement timers ]

DecTimers:
@bbcc:  ldx     $1189
        beq     @bbd5
        dex
        stx     $1189
@bbd5:  ldx     $118f
        beq     @bbde
        dex
        stx     $118f
@bbde:  ldx     $1195
        beq     @bbe7
        dex
        stx     $1195
@bbe7:  ldx     $119b
        beq     @bbf0
        dex
        stx     $119b
@bbf0:  rts

; ------------------------------------------------------------------------------

; [ check timer events ]

CheckTimer:
@bbf1:  ldy     $00
@bbf3:  ldx     $1189,y
        bne     @bc63
        ldx     $118b,y
        bne     @bc02
        lda     $118d,y
        beq     @bc63
@bc02:  ldx     $e5
        cpx     #$0000
        bne     @bc63
        lda     $e7
        cmp     #$ca
        bne     @bc63
        ldx     $0803
        lda     $086a,x
        and     #$0f
        bne     @bc63
        lda     $086d,x
        and     #$0f
        bne     @bc63
        ldx     $118b,y
        stx     $e5
        stx     $05f4
        lda     $118d,y
        clc
        adc     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003
        stx     $e8
        ldx     $da
        lda     $087c,x
        sta     $087d,x
        lda     #$04
        sta     $087c,x
        tdc
        sta     $118b,y
        sta     $118c,y
        sta     $118d,y
        jsr     CloseMapTitleWindow
        rts
@bc63:  iny6
        cpy     #$0018
        bne     @bbf3
        rts

; ------------------------------------------------------------------------------

; [ check event triggers ]

CheckEventTriggers:
@bc6f:  lda     $84
        bne     @bccf
        lda     $59
        bne     @bccf
        ldy     $0803
        lda     $086a,y
        and     #$0f
        bne     @bccf
        lda     $0869,y
        bne     @bccf
        lda     $086d,y
        and     #$0f
        bne     @bccf
        lda     $086c,y
        bne     @bccf
        ldx     $e5
        cpx     #$0000
        bne     @bccf
        lda     $e7
        cmp     #$ca
        bne     @bccf
        lda     $087c,y
        and     #$0f
        cmp     #$02
        bne     @bccf
        longa
        lda     $82
        asl
        tax
        lda     f:EventTriggerPtrs+2,x
        sta     $1e
        lda     f:EventTriggerPtrs,x
        cmp     $1e
        beq     @bccf
        tax
@bcbd:  lda     f:EventTriggerPtrs,x
        cmp     $af
        beq     @bcd3
        txa
        clc
        adc     #5
        tax
        cpx     $1e
        bne     @bcbd
@bccf:  shorta0
        rts
@bcd3:  lda     f:EventTriggerPtrs+2,x
        sta     $e5
        sta     $05f4
        tdc
        sta     $0871,y
        sta     $0873,y
        shorta
        sta     $087e,y
        lda     #$01
        sta     $078e
        lda     f:EventTriggerPtrs+4,x
        clc
        adc     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003
        stx     $e8
        lda     $087c,y
        sta     $087d,y
        lda     #$04
        sta     $087c,y
        jsr     UpdateScrollRate
        jsr     CloseMapTitleWindow
        rts

; ------------------------------------------------------------------------------

; [ init character object data ]

InitSavedGame:
@bd20:  stz     $58                     ; don't reload the same map
        ldy     $0803                   ; party object
        lda     #1                      ; enable walking animation
        sta     $0868,y
        jsr     PopCharFlags
        ldx     $00                     ; copy character data to character objects
        txy
@bd30:  lda     $1600,y                 ; actor
        sta     $0878,x
        lda     $1601,y                 ; graphics
        sta     $0879,x
        tdc
        sta     $087c,x                 ; clear movement type
        sta     $087d,x
        lda     #$01                    ; enable walking animation
        sta     $0868,x
        longac                          ; next character
        txa
        adc     #$0029
        tax
        tya
        clc
        adc     #$0025
        tay
        shorta0
        cpy     #$0250
        bne     @bd30
        ldx     $1fa6                   ; pointer to party object data
        stx     $07fb                   ; store in character object slot 0
        lda     #$02                    ; user-controlled
        sta     $087c,x
        lda     $1f68                   ; set facing direction
        sta     $0743
        jsr     PopPartyPal
        ldy     #$07d9
        sty     $07fd                   ; clear character object slot 1 through 3
        sty     $07ff
        sty     $0801
        jsr     _c0714a
        jsr     InitCharSpritePriority
        lda     #$80                    ; enable map startup event
        sta     $11fa
        lda     #1                      ; enable map load
        sta     $84
        rts

; ------------------------------------------------------------------------------

; [ init sram ]

InitNewGame:
@bd8d:  ldx     $00                     ; clear character data
@bd8f:  stz     $1600,x
        inx
        cpx     #$0250
        bne     @bd8f
        ldx     $00                     ; loop through character data
@bd9a:  lda     #$ff
        sta     $1600,x                 ; no actor in slot
        sta     $161e,x                 ; no esper
        longac
        txa
        adc     #$0025
        tax
        shorta0
        cpx     #$0250
        bne     @bd9a
        ldx     $00                     ; clear characters visible/enabled, battle order, party
@bdb3:  stz     $1850,x
        inx
        cpx     #$0010
        bne     @bdb3
        ldx     $00                     ; clear inventory
        lda     $02
@bdc0:  stz     $1969,x
        sta     $1869,x
        inx
        cpx     #$0100
        bne     @bdc0
        ldx     $00                     ; clear character spells known
@bdce:  stz     $1a6e,x
        inx
        cpx     #$0288
        bne     @bdce
        ldx     $00                     ; clear character skill data
@bdd9:  stz     $1cf6,x
        inx
        cpx     #$0057
        bne     @bdd9
        ldx     $00                     ; load swdtech names
@bde4:  lda     $cf3c40,x
        sta     $1cf8,x
        inx
        cpx     #$0030
        bne     @bde4
        stz     $1a69                   ; clear espers
        stz     $1a6a
        stz     $1a6b
        stz     $1a6c
        ldx     $00                     ; clear event flags
@bdff:  stz     $1dc9,x
        inx
        cpx     #$0054
        bne     @bdff
        ldx     $00                     ; load starting rages
@be0a:  lda     $c47aa0,x
        sta     $1d2c,x
        inx
        cpx     #$0020
        bne     @be0a
        lda     $e6f564                 ; load starting lores
        sta     $1d29
        lda     $e6f565
        sta     $1d2a
        lda     $e6f566
        sta     $1d2b
        stz     $0565                   ; set wallpaper index to 0
        ldx     #$7fff                  ; set font color to white
        stx     $1d55
        ldx     $00                     ; set window palette
@be37:  lda     f:WindowPal+2,x
        sta     $1d57,x
        inx
        cpx     #14
        bne     @be37
        lda     #1                      ; set party z-levels to 1
        sta     $1ff3
        sta     $1ff4
        sta     $1ff5
        sta     $1ff6
        ldx     $00                     ; clear timers
        stx     $1189
        stx     $118f
        stx     $1195
        stx     $119b
        stx     $118b                   ; clear timer event pointers
        stx     $1191
        stx     $1197
        stx     $119d
        tdc
        sta     $118d
        sta     $1193
        sta     $1199
        sta     $119f
        jsr     CalcObjPtrs
        stz     $11f1                   ; disable restore saved game
        jsr     InitEvent
        stz     $58                     ; don't reload the same map
        stz     $0559                   ; don't lock screen
        jsr     InitEventSwitches
        jsr     InitNPCSwitches
        jsr     InitTreasureSwitches
        ldx     #$0003                  ; $ca0003 (game start)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000                  ; set return address to $ca0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01                    ; loop once
        sta     $05c7
        ldx     #$0003                  ; set event stack
        stx     $e8
        lda     #$02                    ; party will be user-controlled after event
        sta     $087d
        stz     $47                     ; clear event counter
.if DEBUG
        ldx     #$5eb3
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        lda     #0
        sta     $1600
        sta     $1601
        lda     #1
        sta     $1a6d
        lda     #$c1
        sta     $1850
        sta     $0867
        lda     $1eb9
        and     #$80
        sta     $1eb9
        lda     #80
        sta     $1f60
        lda     #80
        sta     $1f61
.endif
        rts

; ------------------------------------------------------------------------------

; [ load map ]

LoadMap:
@bebc:  jsr     DisableInterrupts
        jsr     InitDlgVWF
        lda     $58                     ; branch if reloading the same map
        bne     @bef8
        longa
        lda     $1f64                   ; current map index
        and     #$01ff                  ; clear startup flags
        sta     $1f64
        sta     $82
        shorta0
        jsr     LoadMapProp
        stz     $47                     ; clear event counter
        stz     $077b                   ; disable flashlight
        lda     #$01                    ; enable entrance triggers
        sta     $85
        ldx     $00                     ; clear open doors
        stx     $1127
        jsr     CalcObjPtrs
        jsr     CalcScrollRange
        ldx     $00
        stx     $078c                   ; clear number of steps for random battles
        stz     $078b                   ; clear number of random battles this map
        jsr     PopPartyPos
@bef8:  jsr     _c0714a
        jsr     InitPlayerPos
        lda     $11fa                   ; branch if map size update is disabled
        and     #$20
        bne     @bf08
        jsr     InitMapSize
@bf08:  lda     $1f66                   ; set scroll position
        sta     $0541
        lda     $1f67
        sta     $0542
        jsr     InitParallax
        ldx     #$4800                  ; set bg data vram locations
        stx     $058b
        ldx     #$5000
        stx     $058d
        ldx     #$5800
        stx     $058f
        ldx     $e5                     ; branch if an event is running
        bne     @bf36
        lda     $e7
        cmp     #$ca
        bne     @bf36
        jsr     GetTopChar
@bf36:  stz     $84                     ; disable map load
        stz     $57                     ; disable random battle
        stz     $56                     ; disable battle
        stz     $4c                     ; clear screen brightness
        stz     $055e                   ; no object collisions
        stz     $0567                   ; clear map name dialog counter
        stz     $5a                     ; disable bg map flip
        stz     $055a                   ; disable bg map updates
        stz     $055b
        stz     $055c
        stz     $bb                     ; dialog window closed
        stz     $ba
        lda     #$01                    ; wait for character objects to get updated
        sta     $0798
        jsr     InitColorMath
        jsr     InitPPU
        jsr     LoadMapGfx
        jsr     TfrBG3Gfx
        jsr     LoadMapPal
        jsr     LoadMapTiles
        jsr     InitTreasures
        jsr     DrawOpenDoor
        jsr     LoadTileset
        jsr     LoadTileProp
        jsr     InitScrollPos
        jsr     InitMapTiles
        jsr     InitDlgText
        jsr     InitObjGfx
        jsr     InitOverlay
        jsr     InitDlgWindow
        jsr     InitHDMA
        jsr     InitFadeBars
        jsr     ResetSprites
        jsr     InitSpritePal
        jsr     InitSpriteMSB
        jsr     InitBGAnim
        jsr     InitPalAnim
        jsr     UpdateEquip
        jsr     UpdateScrollHDMA
        jsr     LoadTimerGfx
        lda     $1eb6                   ; enable object map data update
        ora     #$40
        sta     $1eb6
        lda     $58                     ; branch if re-loading the same map
        bne     @bfc6
        stz     $1ebe                   ; unused
        stz     $1ebf
        jsr     InitNPCs
        jsr     InitPlayerObj
        lda     $1eb6                   ; disable object map data update
        and     #$bf
        sta     $1eb6
@bfc6:  jsr     InitObjAnim
        jsr     InitSpecialNPCs
        jsr     InitPortrait
        jsr     InitNPCMap
        lda     $11fa                   ; branch if map startup event is enabled
        bmi     @bfda
        jmp     @c0a4
@bfda:  longa
        lda     $1f64                   ; map index * 3
        and     #$01ff
        sta     $1e
        asl
        clc
        adc     $1e
        tax
        shorta0
        lda     #$b2                    ; set map startup event code
        sta     $0624                   ; $0624 b2 xxxxxx jump to xxxxxx
        lda     f:MapInitEvent,x               ; pointer to map startup event
        sta     $0625
        sta     $2a
        lda     f:MapInitEvent+1,x
        sta     $0626
        sta     $2b
        lda     f:MapInitEvent+2,x
        sta     $0627
        clc
        adc     #^EventScript
        sta     $2c
        lda     [$2a]
        cmp     #$fe
        bne     @c018
        jmp     @c0a4
@c018:  lda     #$d3                    ; $0628 d3 cf     clear event bit $1eb9.7 (enable user control of character)
        sta     $0628
        lda     #$cf
        sta     $0629
        lda     #$fd                    ; $062a fd        add 1 to event pc (does nothing)
        sta     $062a
        lda     #$fe                    ; $062b fe        return
        sta     $062b
        lda     $1eb9                   ; disable user control of character
        ora     #$80
        sta     $1eb9
        ldx     $e8                     ; push current event address onto event stack
        lda     $e5
        sta     $0594,x
        lda     $e6
        sta     $0595,x
        lda     $e7
        sta     $0596,x
        lda     #$24                    ; set event pc to $000624
        sta     $e5
        sta     $05f4,x
        lda     #$06
        sta     $e6
        sta     $05f5,x
        lda     #$00
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8                     ; set event stack pointer
        lda     #$01                    ; do event one time
        sta     $05c4,x
        ldy     $0803
        lda     $087c,y                 ; save party movement type
        sta     $087d,y
@c06e:  jsr     ExecEvent
        lda     $1eb9
        bpl     @c08a                   ; branch if user has control of character
        jsr     ExecObjScript
        jsr     MoveObjs
        jsr     UpdateBG1
        jsr     UpdateBG2
        jsr     UpdateBG3
        jsr     TfrMapTiles
        bra     @c06e
@c08a:  lda     [$e5]                   ; branch if current event opcode is return
        cmp     #$fe
        bne     @c0a4
        ldx     $e8
        dex3
        ldy     $0594,x                 ; branch unless there's an address on the event stack
        bne     @c0a4
        lda     $0596,x
        cmp     #$ca
        bne     @c0a4
        jsr     ExecEvent
@c0a4:  lda     $11fa                   ; branch if map fade in is disabled
        and     #$40
        bne     @c0ae
        jsr     FadeIn
@c0ae:  jsr     InitZLevel
        jsr     UpdateOverlay
        jsr     PlayMapSong
        stz     $11fa                   ; clear map startup flags
        stz     $58                     ; don't reload the same map
        jsr     ShowMapTitle
        stz     $dc
@c0c1:  lda     $dc                     ; loop through all active objects
        cmp     $dd
        beq     @c0da
        tax
        ldy     $0803,x
        jsr     UpdateObjFrame
        lda     $0877,y                 ; set current graphic positions
        sta     $0876,y
        inc     $dc                     ; next object
        inc     $dc
        bra     @c0c1
@c0da:  stz     $47                     ; clear event counter
        jsr     TfrObjGfxSub            ; update object 0-5 graphics in vram
        inc     $47
        jsr     TfrObjGfxSub            ; update object 6-11 graphics in vram
        inc     $47
        jsr     TfrObjGfxSub            ; update object 12-17 graphics in vram
        inc     $47
        jsr     TfrObjGfxSub            ; update object 18-23 graphics in vram
        rts

; ------------------------------------------------------------------------------

; [ battle blur/sound ]

BattleMosaic:
@c0ef:  lda     $078a       ; branch if battle sound effect is disabled
        and     #$40
        bne     @c0fb
        lda     #$c1        ; play battle sound effect
        jsr     PlaySfx
@c0fb:  lda     $078a       ; return if battle blur is disabled
        bmi     @c13d
        stz     $46         ; clear frame counter
@c102:  jsr     WaitVblank
        lda     $46
        cmp     #$10
        bcs     @c10f
        and     #$07        ; increase mosaic size from 0 to 7 twice
        bra     @c111
@c10f:  and     #$0f        ; then increase from 0 to 15 once
@c111:  asl4
        ora     #$0f        ; enable mosaic on all bg layers
        sta     $7e8233     ; store in screen mosaic hdma table ($2106)
        sta     $7e8237
        sta     $7e823b
        sta     $7e823f
        sta     $7e8243
        sta     $7e8247
        sta     $7e824b
        sta     $7e824f
        lda     $46         ; loop for $20 frames
        cmp     #$20
        bne     @c102
@c13d:  rts

; ------------------------------------------------------------------------------

; [ execute battle ]

ExecBattle:
@c13e:  jsr     BattleMosaic
        jsr     DisableInterrupts
        jsr     PushDP
        jsr     PushCharFlags
        ldx     $0803       ; save pointer to party object data
        stx     $1fa6
        lda     $087f,x     ; save facing direction
        sta     $1f68
        lda     $b2         ; save z-level
        sta     $0744
        php
        phb
        phd
        jsl     Battle_ext
        pld
        plb
        plp
        jsr     DisableInterrupts
        jsr     PopDP
        jsr     PopCharFlags
        lda     #1        ; re-load the same map
        sta     $58
        jsr     InitInterrupts
        rts

; ------------------------------------------------------------------------------

; [ update random battles (world map) ]

CheckBattleWorld:
@c176:  tdc
        jsr     PopDP
        lda     $1f64       ; map index
        asl3
        sta     $1a
        lda     $11f9       ; battle bg index
        and     #$07
        ora     $1a
        tax
        lda     f:WorldBattleBGTbl,x
        sta     f:$0011e2
        tdc
        sta     f:$0011e3
        txa
        and     #$07
        tax
        lda     f:BattleBGRateTbl,x
        sta     $22
        stz     $23
        lda     f:BattleBGGroupTbl,x
        sta     $20
        stz     $21
        lda     $1f64
        sta     $1f
        stz     $1e
        lda     $1f61
        and     #$e0
        sta     $1e
        lda     $1f60
        lsr3
        and     #$1c
        ora     $1e
        sta     $1e
        longa
        lda     $1e
        ora     $20
        tax
        shorta0
        lda     $cf5400,x               ; world battle groups
        sta     $24
        cmp     #$ff
        bne     @c1df                   ; branch if not a veldt sector
        lda     #$0f
        sta     f:$0011e4               ; set veldt flags
@c1df:  longa
        lda     $1e
        lsr2
        tax
        shorta0
        lda     f:WorldBattleRate,x     ; world battle rates
        ldy     $22
        beq     @c1f6
@c1f1:  lsr2
        dey
        bne     @c1f1
@c1f6:  and     #$03
        cmp     #$03
        beq     @c278
        sta     $1a
        lda     $11df
        and     #$03
        asl2
        ora     $1a
        asl
        tax
        lda     f:WorldBattleRateTbl,x
        ora     f:WorldBattleRateTbl+1,x
        beq     @c278
        longa
        lda     $1f6e
        clc
        adc     f:WorldBattleRateTbl,x
        bcc     @c222
        lda     #$ff00
@c222:  sta     $1f6e
        shorta0
        jsr     UpdateBattleRng
        cmp     $1f6f
        bcs     @c278
        stz     $1f6e
        stz     $1f6f
        lda     $24
        cmp     #$ff
        bne     @c23f       ; branch if not a veldt sector
        jmp     GetVeldtBattle
@c23f:  longa
        asl3
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$50
        bcc     @c25d
        inx2
        cmp     #$a0
        bcc     @c25d
        inx2
        cmp     #$f0
        bcc     @c25d
        inx2
@c25d:  longa
        lda     $cf4800,x
        sta     f:$0011e0
        tdc
@c268:  shorta
        lda     $1ed7
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #1
        bra     @c279
@c278:  tdc
@c279:  pha
        jsr     PushDP
        pla
        rtl

; ------------------------------------------------------------------------------

; world map battle backgrounds (8 per map)
WorldBattleBGTbl:
@c27f:  .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $00,$01,$2f,$03,$05,$05,$06,$07

; world map battle rate for each battle bg
BattleBGRateTbl:
@c28f:  .byte   $03,$02,$01,$02,$03,$00,$03,$03

; world map battle groups for each battle bg
BattleBGGroupTbl:
@c297:  .byte   $00,$01,$02,$01,$00,$03,$00,$00

; world map random battle rates
; 8 bytes each (normal, low, high, none)
WorldBattleRateTbl:
@c29f:  .word   $00c0,$0060,$0180,$0000  ; normal
        .word   $0060,$0030,$00c0,$0000  ; charm bangle
        .word   $0000,$0000,$0000,$0000  ; moogle charm
        .word   $0000,$0000,$0000,$0000  ; unused

; normal map random battle rates
; 8 bytes each (normal, low, high, very high)
SubBattleRateTbl:
@c2bf:  .word   $0070,$0040,$0160,$0200  ; normal
        .word   $0038,$0020,$00b0,$0100  ; charm bangle
        .word   $0000,$0000,$0000,$0000  ; moogle charm
        .word   $0000,$0000,$0000,$0000  ; unused

; ------------------------------------------------------------------------------

; [ select a veldt formation ]

GetVeldtBattle:
@c2df:  inc     $1fa5
        lda     $1fa5
        and     #$3f
        tax
@c2e8:  lda     $1ddd,x
        bne     @c2f4
        txa
        inc
        and     #$3f
        tax
        bra     @c2e8
@c2f4:  sta     $1a
        txa
        sta     $1fa5
        longa
        asl3
        sta     $1e
        shorta0
        jsr     UpdateBattleGrpRng
        and     #$07
        tax
@c30a:  lda     $1a
        and     f:BitOrTbl,x
        bne     @c319
        txa
        inc
        and     #$07
        tax
        bra     @c30a
@c319:  longac
        txa
        adc     $1e
        sta     f:$0011e0
        shorta0
        pha
        jsr     PushDP
        pla
        lda     #1
        rtl

; ------------------------------------------------------------------------------

; [ update random battles ]

CheckBattleSub:
@c32d:  lda     $84
        bne     @c36b
        lda     $078e
        bne     @c36b
        lda     $1eb9
        and     #$20
        bne     @c36b
        ldx     $e5
        bne     @c36b
        lda     $e7
        cmp     #$ca
        bne     @c36b
        lda     $0525
        bpl     @c36b
        ldy     $0803
        lda     $0869,y
        bne     @c36b
        lda     $086a,y
        and     #$0f
        bne     @c36b
        lda     $086c,y
        bne     @c36b
        lda     $086d,y
        and     #$0f
        bne     @c36b
        lda     $57
        bne     @c36c       ; branch if random battle is enabled
@c36b:  rts
@c36c:  stz     $57         ; disable random battle
        ldx     $078c       ; increment number of steps on map
        inx
        stx     $078c
        lda     a:$0082       ; map index
        and     #$03
        tay
        longa
        lda     a:$0082
        lsr2
        tax
        shorta0
        lda     f:SubBattleRate,x       ; probability data (2 bits per map)
        cpy     $00
        beq     @c393
@c38e:  lsr2
        dey
        bne     @c38e
@c393:  and     #$03
        sta     $1a
        lda     $11df       ; moogle charm and charm bangle effect
        and     #$03
        asl2
        ora     $1a
        asl
        tax
        lda     f:SubBattleRateTbl,x
        ora     f:SubBattleRateTbl+1,x
        bne     @c3af
        jmp     @c478       ; return if battle probability is zero (moogle charm)
@c3af:  longac
        lda     $1f6e       ; random battle counter
        adc     f:SubBattleRateTbl,x   ; add random battle rate (max #$ff00)
        bcc     @c3bd
        lda     #$ff00
@c3bd:  sta     $1f6e
        shorta0
        jsr     UpdateBattleRng
        cmp     $1f6f
        bcs     @c36b       ; return if greater than counter (no battle yet)
        stz     $1f6e       ; clear random battle counter
        stz     $1f6f
        ldx     a:$0082
        lda     $cf5600,x   ; get the map's battle group
        longa
        asl3
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$50
        bcc     @c3f6
        inx2
        cmp     #$a0
        bcc     @c3f6
        inx2
        cmp     #$f0
        bcc     @c3f6
        inx2
@c3f6:  longa
        lda     $cf4800,x   ; random battle groups (8 bytes each)
        sta     f:$0011e0
        shorta0
        lda     $0522       ; battle bg
        and     #$7f
        sta     f:$0011e2
        tdc
        sta     f:$0011e3
        ldx     $0541       ; save bg1 scroll position
        stx     $1f66
        ldx     a:$00af       ; save party position
        stx     $1fc0
        lda     $1ed7       ;
        and     #$10
        lsr
        sta     f:$0011e4
        inc     $078b       ; increment number of random battles on this map
        longa
        tdc
        sta     $0871,y     ; clear object 0 movement speed
        sta     $0873,y
        sta     $73         ; clear bg scroll from movement
        sta     $75
        sta     $77
        sta     $79
        sta     $7b
        sta     $7d
        shorta
        ldx     #$0018      ; $ca0018 (random battle)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003
        stx     $e8
        ldy     $0803
        lda     $087c,y     ; save party movement type
        sta     $087d,y
        lda     #$04        ; movement type 4 (activated)
        sta     $087c,y
        lda     #$80
        sta     $11fa       ; enable map startup event
@c478:  rts

; ------------------------------------------------------------------------------

; [ update random number for random battle ]

UpdateBattleRng:
@c479:  phx
        inc     $1fa1       ; increment random number pointer
        bne     @c488
        lda     $1fa4
        clc
        adc     #$11        ; add 17 to random number counter
        sta     $1fa4
@c488:  lda     $1fa1
        tax
        lda     f:RNGTbl,x   ; add random number to counter
        clc
        adc     $1fa4
        plx
        rts

; ------------------------------------------------------------------------------

; [ update random number for battle group ]

UpdateBattleGrpRng:
@c496:  phx
        inc     $1fa2
        bne     @c4a5
        lda     $1fa3
        clc
        adc     #$17
        sta     $1fa3
@c4a5:  lda     $1fa2
        tax
        lda     f:RNGTbl,x
        clc
        adc     $1fa3
        plx
        rts

; ------------------------------------------------------------------------------

; [ load saved game ]

RestartGame:
@c4b3:  ldx     $00
        txy
        tdc
@c4b7:  lda     $1600,y
        sta     $7ff1c0,x
        lda     $1608,y
        sta     $7ff1d0,x
        lda     $1611,y
        sta     $7ff1e0,x
        lda     $1612,y
        sta     $7ff1f0,x
        lda     $1613,y
        sta     $7ff200,x
        longac
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        bne     @c4b7
        jsr     PushDP
        phb
        phd
        php
        jsl     LoadSavedGame_ext
        plp
        pld
        plb
        jsr     PopDP
        jsr     PopPartyMap
        tdc
        lda     $0205
        beq     @c506
        jmp     JmpReset
@c506:  ldx     $00
        txy
@c509:  lda     $1600,y
        cmp     $7ff1c0,x
        beq     @c515
        jmp     @c54b
@c515:  phx
        lda     $1608,y
        dec
        sta     $20
        stz     $21
        lda     $7ff1d0,x
        sta     $1608,y
        dec
        sta     $22
        stz     $23
        jsr     UpdateMaxHP
        jsr     UpdateMaxMP
        plx
        lda     $7ff1e0,x
        sta     $1611,y
        lda     $7ff1f0,x
        sta     $1612,y
        lda     $7ff200,x
        sta     $1613,y
        phx
        jsr     UpdateAbilities
        plx
@c54b:  longac
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        beq     @c55e
        jmp     @c509
@c55e:  jsr     UpdateEquip
        rts

; ------------------------------------------------------------------------------

; [ update character max hp ]

; +$20 = previous level
; +$22 = new level

UpdateMaxHP:
@c562:  longa
        lda     $160b,y
        and     #$3fff
        sta     $1e         ; +$1e = max hp
        shorta0
        ldx     $20
@c571:  cpx     $22         ; branch if not at target level
        beq     @c587
        lda     $e6f4a0,x   ; hp progression value
        clc
        adc     $1e         ; add to max hp
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @c571
@c587:  ldx     #$270f      ; 9999 maximum
        cpx     $1e
        bcs     @c590
        stx     $1e
@c590:  longa
        lda     $1e
        sta     $160b,y     ; set new max hp
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update character max mp ]

; +$20 = previous level
; +$22 = new level

UpdateMaxMP:
@c59b:  longa
        lda     $160f,y
        and     #$3fff
        sta     $1e         ; +$1e = max mp
        shorta0
        ldx     $20
@c5aa:  cpx     $22         ; branch if not at target level
        beq     @c5c0
        lda     $e6f502,x   ; mp progression value
        clc
        adc     $1e         ; add to max mp
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @c5aa
@c5c0:  ldx     #$03e7      ; 999 maximum
        cpx     $1e
        bcs     @c5c9
        stx     $1e
@c5c9:  longa
        lda     $1e
        sta     $160f,y     ; set new max mp
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ check main menu ]

CheckMenu:
@c5d4:  lda     $59         ; return if menu is already opening
        bne     @c62a
        lda     $06         ; return if x button not down
        and     #$40
        beq     @c62a
        lda     $56         ; return if battle enabled
        bne     @c62a
        lda     $84         ; return map load enabled
        bne     @c62a
        lda     $4a         ; return if fading in/out
        bne     @c62a
        lda     $055e       ; return if parties switching ???
        bne     @c62a
        ldx     $e5         ; return if an event is running
        cpx     #$0000
        bne     @c62a
        lda     $e7
        cmp     #$ca
        bne     @c62a
        ldy     $0803       ; party object
        lda     $087e,y     ; return if moving
        bne     @c62a
        lda     $0869,y     ; return if between tiles
        bne     @c62a
        lda     $086a,y
        and     #$0f
        bne     @c62a
        lda     $086c,y
        bne     @c62a
        lda     $086d,y
        and     #$0f
        bne     @c62a
        lda     $1eb8       ; return if main menu is disabled
        and     #$04
        bne     @c62a
        lda     #$01        ; open menu
        sta     $59
        jsr     FadeOut
@c62a:  rts

; ------------------------------------------------------------------------------

; [ open main menu ]

OpenMainMenu:
@c62b:  lda     $4a                     ; return if still fading out
        bne     @c633
        lda     $59                     ; return if not opening menu
        bne     @c636
@c633:  jmp     MainMenuReturn
@c636:  stz     $59                     ; disable menu
        lda     #$00                    ; set menu mode to main menu
        sta     $0200
        lda     $1eb7                   ; on a save point
        and     #$80
        sta     $1a
        lda     $0521                   ; warp/x-zone enable
        and     #$03
        ora     $1a
        sta     $0201                   ; set menu flags
        jsr     OpenMenu
        lda     $0205
        cmp     #$02
        beq     @c65f                   ; branch if a tent was used
        cmp     #$03
        beq     @c670                   ; branch if warp/warp stone was used
        jmp     FieldMain               ; return to main code loop and fade in
@c65f:  ldx     #$0034                  ; $ca0034 (tent)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        bra     @c67f
@c670:  ldx     #$0039                  ; $ca0039 (warp/warp stone)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
@c67f:  ldy     $0803                   ; party object
        lda     $087c,y                 ; set movement type to talking/interacting
        and     #$f0
        ora     #$04
        sta     $087c,y
        ldx     #$0000                  ; clear event stack
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003
        stx     $e8
        ldy     $da                     ; current object
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        lda     #$04                    ; set movement type to talking/interacting
        sta     $087c,y
        stz     $58                     ; load new map
        jmp     FieldMain               ; return to main code loop and fade in

; ------------------------------------------------------------------------------

; [ optimize character's equipment ]

OptimizeEquip:
@c6b3:  jsr     PushCharFlags
        jsr     PushDP
        php
        phb
        phd
        jsl     OptimizeEquip_ext
        pld
        plb
        plp
        jsr     PopDP
        jsr     PopCharFlags
        rts

; ------------------------------------------------------------------------------

; [ open menu ]

OpenMenu:
@c6ca:  jsr     DisableInterrupts
        jsr     PushCharFlags
        jsr     PushPartyPal
        jsr     PushPartyMap
        jsr     PushDP
        ldx     $0541       ; save scroll position
        stx     $1f66
        ldx     a:$00af       ; save party position
        stx     $1fc0
        ldx     $0803       ; save pointer to party object data
        stx     $1fa6
        lda     $087f,x     ; save facing direction
        sta     $1f68
        lda     $b2         ; save z-level
        sta     $0744
        php
        phb
        phd
        jsl     OpenMenu_ext
        pld
        plb
        plp
        jsr     DisableInterrupts
        jsr     PopDP
        jsr     PopCharFlags
        jsr     PopPartyMap
        lda     $1d4e       ; update wallpaper index
        and     #$07
        sta     $0565
        lda     #$01        ; reload the same map
        sta     $58
        lda     #$80        ; enable map startup event
        sta     $11fa
        jsr     InitInterrupts
        stz     $4c         ; clear screen brightness
        rts

; ------------------------------------------------------------------------------

; [ init sprite overlays ]

InitOverlay:
@c723:  jsr     LoadOverlayData
        jsr     LoadOverlayGfx
        rts

; ------------------------------------------------------------------------------

; [ load sprite overlay graphics ]

LoadOverlayGfx:
@c72a:  lda     #$80        ; vram settings
        sta     hVMAINC
        ldx     #.loword(OverlayVRAMTbl)
        stx     $2d
        lda     #^OverlayVRAMTbl
        sta     $2f
        ldy     $00
@c73a:  phy
        lda     $0633,y     ; overlay tile number (tiles are 8 bytes each)
        longa
        asl3
        clc
        adc     #.loword(OverlayTilemap)
        sta     $2a         ; ++$2a = source address
        shorta0
        lda     #^OverlayTilemap
        sta     $2c
        ldy     $00
@c752:  longac
        lda     [$2d]       ; set vram destination
        sta     hVMADDL
        lda     [$2a],y     ; pointer to graphics
        tax
        shorta0
.repeat 8, i
        lda     f:OverlayGfx+i,x   ; set low 8 bits only (convert 1bpp to 4bpp)
        sta     hVMDATAL
        stz     hVMDATAH
.endrep
.repeat 8
        stz     hVMDATAL       ; clear high 16 bits
        stz     hVMDATAH
.endrep
        longac
        lda     $2d         ; next 8x8 tile
        adc     #2
        sta     $2d
        shorta0
        iny2
        cpy     #8
        beq     @c7f5
        jmp     @c752
@c7f5:  ply                 ; next 16x16 tile
        iny
        cpy     #$0010
        beq     @c7ff
        jmp     @c73a
@c7ff:  rts

; ------------------------------------------------------------------------------

; vram destination for overlay graphics (4 per 16x16 tile)
OverlayVRAMTbl:
@c800:  .word   $6c00,$6c10,$6d00,$6d10
        .word   $6c20,$6c30,$6d20,$6d30
        .word   $6c40,$6c50,$6d40,$6d50
        .word   $6c60,$6c70,$6d60,$6d70
        .word   $6c80,$6c90,$6d80,$6d90
        .word   $6ca0,$6cb0,$6da0,$6db0
        .word   $6cc0,$6cd0,$6dc0,$6dd0
        .word   $6ce0,$6cf0,$6de0,$6df0
        .word   $6e00,$6e10,$6f00,$6f10
        .word   $6e20,$6e30,$6f20,$6f30
        .word   $6e40,$6e50,$6f40,$6f50
        .word   $6e60,$6e70,$6f60,$6f70
        .word   $6e80,$6e90,$6f80,$6f90
        .word   $6ea0,$6eb0,$6fa0,$6fb0
        .word   $6ec0,$6ed0,$6fc0,$6fd0
        .word   $6ee0,$6ef0,$6fe0,$6ff0

; ------------------------------------------------------------------------------

; [ load sprite overlay data ]

LoadOverlayData:
@c880:  lda     $0531       ; overlay index
        asl
        tax
        longac
        lda     f:OverlayPropPtrs,x
        adc     #.loword(OverlayProp)
        sta     $f3
        shorta0
        lda     #^OverlayProp
        sta     $f5
        ldx     #$0633      ; destination address = $000633
        stx     $f6
        lda     #$00
        sta     $f8
        jsl     Decompress
        rts

; ------------------------------------------------------------------------------

; [ update overlay data ]

UpdateOverlay:
@c8a5:  ldy     $0803
        lda     $087c,y     ; return if user doesn't have control of party
        and     #$0f
        cmp     #$02
        beq     @c8b2
        rts
@c8b2:  longa
        lda     $086d,y     ; get party xy position on screen
        clc
        sbc     $60
        sta     $28
        lda     $086a,y
        sec
        sbc     $5c
        clc
        adc     #$0008
        sta     $26
        shorta0
        lda     $27
        lda     $29
        lda     #$7e        ; set wram address to overlay data ($7e0763)
        sta     hWMADDH
        ldx     #$0763
        stx     hWMADDL
        lda     $b8         ; branch if not on a stairs tile
        and     #$c0
        beq     @c8ec
        lda     $b8
        and     #$04
        beq     @c8ef
        lda     $b2
        cmp     #$01
        beq     @c8ec
@c8ec:  jmp     _ca1a
@c8ef:  lda     $087e,y
        beq     @c8fe
        cmp     #$05
        bcs     @c8fb
        jmp     _ca1a
@c8fb:  sec
        sbc     #$04
@c8fe:  sta     $1a
        asl3
        clc
        adc     $1a
        sta     $1a
        tax
        lda     $26
        clc
        adc     f:_c0c9ed,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0c9ed+1,x
        sta     hWMDATA
        lda     f:_c0c9ed+2,x
        tay
        phx
        lda     $00a3,y
        tax
        tay
        lda     $7e7600,x
        plx
        and     #$04
        beq     @c936
        lda     $b2
        dec
        beq     @c944
@c936:  lda     $0643,y
        cmp     #$ff
        beq     @c944
        and     #$3f
        clc
        adc     #$c0
        bra     @c945
@c944:  tdc
@c945:  sta     hWMDATA
        lda     $0643,y
        and     #$c0
        sta     hWMDATA
        lda     $26
        clc
        adc     f:_c0c9ed+3,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0c9ed+4,x
        sta     hWMDATA
        lda     f:_c0c9ed+5,x
        tay
        phx
        lda     $00a3,y
        tax
        tay
        lda     $7e7600,x
        plx
        and     #$04
        beq     @c97d
        lda     $b2
        dec
        beq     @c98b
@c97d:  lda     $0643,y
        cmp     #$ff
        beq     @c98b
        and     #$3f
        clc
        adc     #$c0
        bra     @c98c
@c98b:  tdc
@c98c:  sta     hWMDATA
        lda     $0643,y
        and     #$c0
        sta     hWMDATA
        lda     $26
        clc
        adc     f:_c0c9ed+6,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0c9ed+7,x
        sta     hWMDATA
        lda     f:_c0c9ed+8,x
        tay
        phx
        lda     $00a3,y
        tax
        tay
        lda     $7e7600,x
        plx
        and     #$04
        beq     @c9c4
        lda     $b2
        dec
        beq     @c9d2
@c9c4:  lda     $0643,y
        cmp     #$ff
        beq     @c9d2
        and     #$3f
        clc
        adc     #$c0
        bra     @c9d3
@c9d2:  tdc
@c9d3:  sta     hWMDATA
        lda     $0643,y
        and     #$c0
        sta     hWMDATA
        lda     #$ef
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; (5 * 9 bytes)
_c0c9ed:
@c9ed:  .byte   $00,$00,$07,$10,$f0,$05,$10,$00,$08
        .byte   $10,$00,$05,$00,$10,$07,$10,$10,$08
        .byte   $00,$00,$07,$00,$10,$0a,$10,$10,$0b
        .byte   $10,$00,$07,$10,$10,$0a,$00,$10,$09
        .byte   $10,$10,$07,$00,$00,$03,$00,$10,$06

; ------------------------------------------------------------------------------

; not on a stairs tile
_ca1a:  lda     $b8         ; tile properties
        and     #$04
        beq     @ca27       ; branch if not a bridge tile
        lda     $b2
        dec
        beq     @ca5e       ; branch if party is on upper z-level
        bra     @ca42

; party is not on a bridge tile
@ca27:  lda     $aa         ; tile number
        tay
        lda     $0643,y     ; overlay tile formation
        cmp     #$ff
        beq     @ca5e       ; branch if no overlay tile
        sta     $1a
        and     #$3f        ; tile index bits
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0        ; vh flip bits (lower z-level)
        sta     $1a
        bra     @ca64

; party is not on upper z-level
@ca42:  lda     $aa         ; tile number
        tay
        lda     $0643,y     ; overlay tile formation
        cmp     #$ff
        beq     @ca5e       ; branch if no overlay tile
        sta     $1a
        and     #$3f        ; tile index bits
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0        ; vh flip bits
        inc                 ; upper z-level
        sta     $1a
        bra     @ca64

; party is on upper z-level
@ca5e:  lda     #$01        ; +$1a = #$0001 (no overlay tile)
        sta     $1a
        stz     $1b
@ca64:  lda     a:$0074       ; horizontal scroll speed
        bpl     @ca70
        lda     $26         ; tile x position
        clc
        adc     #$10
        sta     $26
@ca70:  lda     $26
        sta     hWMDATA
        lda     a:$0076       ; vertical scroll speed
        bpl     @ca81
        lda     $28         ; tile y position
        clc
        adc     #$10
        sta     $28
@ca81:  lda     $28
        sta     hWMDATA
        lda     $1b         ; tile index
        sta     hWMDATA
        lda     $1a         ; vh flip and priority
        sta     hWMDATA
        lda     $b8         ;
        and     #$04
        beq     @ca9d
        lda     $b2
        dec
        beq     @cb03
        bra     @cae7

;
@ca9d:  lda     $b8         ; tile z-level
        and     #$03
        cmp     #$02
        beq     @cab6       ; branch if lower
        cmp     #$03
        beq     @cac0       ; branch if transition
        lda     $b6
        cmp     #$f7
        beq     @cacc
        and     #$07
        dec
        beq     @cacc
        bra     @cb03

;
@cab6:  lda     $b6         ; top tile z-layer
        and     #$07
        cmp     #$01
        beq     @cb03       ; branch if upper z-level
        bra     @cacc

;
@cac0:  lda     $b6
        cmp     #$f7
        beq     @cacc
        and     #$02
        bne     @cacc
        bra     @cb03

;
@cacc:  lda     $a7
        tay
        lda     $0643,y
        cmp     #$ff
        beq     @cb03
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        sta     $1a
        bra     @cb09

;
@cae7:  lda     $a7
        tay
        lda     $0643,y
        cmp     #$ff
        beq     @cb03
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        inc
        sta     $1a
        bra     @cb09

; no top overlay tile
@cb03:  lda     #$01
        sta     $1a
        stz     $1b
@cb09:  lda     $26
        sta     hWMDATA
        lda     $28
        sec
        sbc     #$10
        sta     hWMDATA
        lda     $1b
        sta     hWMDATA
        lda     $1a
        sta     hWMDATA
        ldy     $0803
        lda     $087e,y
        tax
        lda     f:_c0cc73,x
        tax
        stx     $2a
        lda     $087e,y
        beq     @cb94
        lda     f:_c0cc7d+2,x
        tax
        lda     $a3,x
        tax
        lda     $7e7600,x
        sta     $1e
        and     #$04
        beq     @cb5b
        lda     $b8
        and     #$04
        beq     @cb52
@cb4b:  lda     $b2
        dec
        beq     @cb94
        bra     @cb7b
@cb52:  lda     $b8
        and     #$03
        dec
        beq     @cb94
        bra     @cb7b

;
@cb5b:  lda     $b8
        and     #$04
        bra     @cb63

;
        bra     @cb4b

;
@cb63:  lda     $0643,x
        cmp     #$ff
        beq     @cb94
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        sta     $1a
        bra     @cb9a

;
@cb7b:  lda     $0643,x
        cmp     #$ff
        beq     @cb94
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        inc
        sta     $1a
        bra     @cb9a

;
@cb94:  lda     #$01
        sta     $1a
        stz     $1b
@cb9a:  ldx     $2a
        lda     $26
        clc
        adc     f:_c0cc7d,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0cc7d+1,x
        sta     hWMDATA
        lda     $1b
        sta     hWMDATA
        lda     $1a
        sta     hWMDATA
        ldy     $0803
        lda     $087e,y
        bne     @cbc5
        jmp     @cc4c

;
@cbc5:  lda     f:_c0cc7d+5,x
        tax
        lda     $a3,x
        tax
        lda     $1e
        and     #$04
        beq     @cbe6
        lda     $b8
        and     #$07
        cmp     #$01
        beq     @cc4c
        cmp     #$02
        beq     @cc33
        lda     $b2
        dec
        beq     @cc4c
        bra     @cc33

;
@cbe6:  lda     $1e
        and     #$03
        cmp     #$02
        beq     @cc01
        cmp     #$03
        beq     @cc0d
        lda     $7e7600,x
        cmp     #$f7
        beq     @cc1b
        and     #$07
        dec
        beq     @cc1b
        bra     @cc4c

;
@cc01:  lda     $7e7600,x
        and     #$07
        cmp     #$01
        beq     @cc4c
        bra     @cc1b

;
@cc0d:  lda     $7e7600,x
        cmp     #$f7
        beq     @cc1b
        and     #$02
        bne     @cc1b
        bra     @cc4c

;
@cc1b:  lda     $0643,x
        cmp     #$ff
        beq     @cc4c
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        sta     $1a
        bra     @cc52

;
@cc33:  lda     $0643,x
        cmp     #$ff
        beq     @cc4c
        sta     $1a
        and     #$3f
        clc
        adc     #$c0
        sta     $1b
        lda     $1a
        and     #$c0
        inc
        sta     $1a
        bra     @cc52

;
@cc4c:  lda     #$01
        sta     $1a
        stz     $1b
@cc52:  ldx     $2a
        lda     $26
        clc
        adc     f:_c0cc7d+3,x
        sta     hWMDATA
        lda     $28
        clc
        adc     f:_c0cc7d+4,x
        sta     hWMDATA
        lda     $1b
        sta     hWMDATA
        lda     $1a
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

_c0cc73:
@cc73:  .byte   $00,$00,$06,$0c,$12,$18,$1e,$24,$2a,$30

; (4 * 6 bytes)
_c0cc7d:
@cc7d:  .byte   $00,$f0,$04,$00,$e0,$01
        .byte   $10,$00,$08,$10,$f0,$05
        .byte   $00,$10,$0a,$00,$00,$07
        .byte   $f0,$00,$06,$f0,$f0,$03

; ------------------------------------------------------------------------------

; [ update overlay sprite data ]

DrawOverlaySprites:
@cc95:  ldx     $00
        txy
@cc98:  lda     $74         ; horizontal scroll speed
        beq     @cca8
        bmi     @cca8       ; branch if not positive
        lda     $5c         ; horizontal scroll position
        dec
        and     #$0f
        inc
        eor     #$ff
        bra     @ccae
@cca8:  lda     $5c
        and     #$0f
        eor     #$ff
@ccae:  sec
        adc     $0763,x     ; add overlay tile x position
        sta     $1a
        lda     $76         ; vertical scroll speed
        beq     @ccc4
        bmi     @ccc4       ; branch if not positive
        lda     $60         ; vertical scroll position
        dec
        and     #$0f
        inc
        eor     #$ff
        bra     @ccca
@ccc4:  lda     $60
        and     #$0f
        eor     #$ff
@ccca:  sec
        adc     $0764,x     ; add overlay tile y position
        sec
        sbc     $7f         ; subtract shake screen offset
        sta     $1b
        lda     $0765,x     ; overlay tile number
        beq     @cd1b       ; 0 = no tile
        lda     $0766,x
        and     #$01
        bne     @ccfe       ; branch if lower z-level
        lda     $1a         ; set sprite data for upper z-level overlay sprite
        sta     $03e0,y
        lda     $1b
        sta     $03e1,y
        lda     $0765,x
        sta     $03e2,y
        lda     $0766,x
        and     #$ce
        sta     $03e3,y
        lda     #$ef        ; hide lower z-level overlay sprite
        sta     $04a1,y
        bra     @cd1b
@ccfe:  lda     $1a         ; set sprite data for lower z-level overlay sprite
        sta     $04a0,y
        lda     $1b
        sta     $04a1,y
        lda     $0765,x
        sta     $04a2,y
        lda     $0766,x
        and     #$ce
        sta     $04a3,y
        lda     #$ef        ; hide upper z-level overlay sprite
        sta     $03e1,y
@cd1b:  iny4                ; next tile
        inx4
        cpx     #$0010
        beq     @cd2b
        jmp     @cc98
@cd2b:  rts

; ------------------------------------------------------------------------------

; [ clear overlay tiles ]

ClearOverlayTiles:
@cd2c:  tdc
        sta     $0765
        sta     $0769
        sta     $076d
        sta     $0771
        rts

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

; tile numbers for digits 0-9 and a-f
DebugHexDigitTbl:
@d386:  .byte   $38,$39,$3a,$3b,$3c,$3d,$3e,$3f
        .byte   $78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$ff

; ------------------------------------------------------------------------------

; [  ]

_c0d397:
@d397:  ldx     $e5
        cpx     #$0000
        bne     @d3dd
        lda     $e7
        cmp     #$ca
        bne     @d3dd       ; return if an event is running
        lda     $1868
        cmp     #$10
        bcc     @d3dd       ; return if less than 16 steps
        ldx     #$004a      ; $ca004a (invalid event address)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000
        stx     $0594       ; event stack = $ca0000
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7       ; event loop count = 1
        ldx     #$0003
        stx     $e8         ; stack event pointer
        ldy     $0803       ; party object
        lda     $087c,y     ; save movement type
        sta     $087d,y
        lda     #$04        ; movement type 4 (activated)
        sta     $087c,y
@d3dd:  rts

; ------------------------------------------------------------------------------

; [ load text graphics for debug mode ]

DebugLoadGfx:
@d3de:  stz     hMDMAEN     ; disable dma
        lda     #$80
        sta     hVMAINC
        lda     #$18
        sta     $4301
        lda     #$41
        sta     $4300
        ldx     #$39c0      ; destination = $39c0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #$e120      ; source = $c0e120 (fixed width font graphics)
        stx     $4302
        lda     #$c0
        sta     $4304
        sta     $4307
        ldx     #$0080      ; size = $0080
        stx     $4305
        lda     #$01        ; enable dma
        sta     hMDMAEN
        ldx     #$3bc0      ; destination = $3bc0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #$e1a0      ; source = $c0e1a0 (fixed width font graphics)
        stx     $4302
        lda     #$c0
        sta     $4304
        sta     $4307
        ldx     #$0080      ; size = $0080
        stx     $4305
        lda     #$01        ; enable dma
        sta     hMDMAEN
        ldx     #$3dc0      ; destination = $3dc0 (vram, bg3 dialog text graphics)
        stx     hVMADDL
        ldx     #$e220      ; source = $c0e220 (fixed width font graphics)
        stx     $4302
        lda     #$c0
        sta     $4304
        sta     $4307
        ldx     #$0080      ; size = $0080
        stx     $4305
        lda     #$01
        sta     hMDMAEN     ; enable dma
        rts
        rts

; ------------------------------------------------------------------------------

; [  ]

_c0d44f:
@d44f:  lda     $0568
        bne     @d49e       ; return if dialog is being displayed
        lda     $46
        and     #$07
        bne     @d49e       ; return 7/8 frames
        lda     $05
        and     #$10
        beq     @d469       ; branch if start button is not pressed
        ldx     a:$00d0       ; increment dialog index
        inx
        stx     a:$00d0
        bra     @d476
@d469:  lda     $05
        and     #$20
        beq     @d49e       ; branch if select button is not pressed
        ldx     a:$00d0       ; decrement dialog index
        dex
        stx     a:$00d0
@d476:  ldx     a:$00d0
        stx     $1e
        jsr     DebugDrawWord
        ldx     $0569       ; counter for dialog pause
        stx     $1e
        jsr     DebugDrawWord
        ldx     $056b       ; counter for keypress
        stx     $1e
        jsr     DebugDrawWord
        lda     #49
        jsr     DebugDrawBlank
        jsr     GetDlgPtr
        lda     #$01
        sta     $bc         ; dialog window at top of screen
        lda     #$01
        sta     $ba         ; enable dialog window
@d49e:  rts

; ------------------------------------------------------------------------------

; [ display spaces ]

; a: number of spaces

DebugDrawBlank:
@d49f:  tay
@d4a0:  lda     #$ff        ; tile $01ff, palette 0, high priority
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        dey
        bne     @d4a0
        rts

; ------------------------------------------------------------------------------

; [ display 8-bit binary value (normal order, msb first) ]

DebugDrawBinary:
@d4ae:  lda     #$ff        ; tile $01ff, palette 0, high priority
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        ldy     #$0008
@d4bb:  tdc
        asl     $1e
        adc     #$38
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        dey
        bne     @d4bb
        rts

; ------------------------------------------------------------------------------

; [ display 8-bit binary value (reverse order, lsb first) ]

DebugDrawBinaryRev:
@d4cc:  lda     #$ff
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        ldy     #$0008
@d4d9:  tdc
        lsr     $1e
        adc     #$38        ; 0 or 1
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        dey
        bne     @d4d9
        rts

; ------------------------------------------------------------------------------

; [ display 4-bit value ]

DebugDrawNybble:
@d4ea:  lda     $1e
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ display 8-bit value ]

; $1e: value

DebugDrawByte:
@d4fa:  lda     #$ff
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ display 16-bit value ]

; +$1e: value

DebugDrawWord:
@d529:  lda     #$ff
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1f
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1f
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        lsr4
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        lda     $1e
        and     #$0f
        tax
        lda     f:DebugHexDigitTbl,x
        sta     hWMDATA
        lda     #$21
        sta     hWMDATA
        rts

; ------------------------------------------------------------------------------

; [ display event bit value ]

DebugDrawEventSwitch:
@d57c:  lda     $46
        and     #$03
        bne     @d5ae       ; branch 3/4 frames
        lda     $05
        and     #$10
        beq     @d599       ; branch if start button is not pressed
        longa
        lda     $115b       ; display next 2 event bytes
        clc
        adc     #$0010
        sta     $115b
        shorta0
        bra     @d5ae
@d599:  lda     $05
        and     #$20
        beq     @d5ae       ; branch if select button is not pressed
        longa
        lda     $115b       ; display previous 2 event bytes
        sec
        sbc     #$0010
        sta     $115b
        shorta0
@d5ae:  lda     #7
        jsr     DebugDrawBlank
        ldx     $115b
        stx     $1e         ; event bit address
        jsr     DebugDrawWord
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e80,x     ; event bit
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     $1e81,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     #2
        jsr     DebugDrawBlank
        lda     #7
        jsr     DebugDrawBlank
        longac
        lda     $115b
        adc     #$0010
        sta     $1e
        shorta0
        jsr     DebugDrawWord
        longa
        lda     $115b
        lsr3
        tax
        shorta0
        lda     $1e82,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     $1e83,x
        sta     $1e
        jsr     DebugDrawBinaryRev
        lda     #2
        jsr     DebugDrawBlank
        rts

; ------------------------------------------------------------------------------

.include "header.asm"

; ------------------------------------------------------------------------------
