
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                              FINAL FANTASY VI                              |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: ending.asm                                                           |
; |                                                                            |
; | description: code for ending cutscenes and credits                         |
; |                                                                            |
; | created: 12/8/2022                                                         |
; +----------------------------------------------------------------------------+

.import CreditsGfx, EndingFontGfx
.import EndingGfx1, EndingGfx2, EndingGfx3, EndingGfx4, EndingGfx5
.import WorldBackdropGfxPtr, WorldBackdropTilesPtr

.segment "menu_code"

; ------------------------------------------------------------------------------

; cinematic state jump table
EndingStateTbl:
@c406:  make_jump_tbl EndingState, $8b

; ------------------------------------------------------------------------------

; [ ending cinematic ]

; $0201: ending cinematic state ( -> $26)
EndingCutscene:
@c51c:  php
        longai
        pha
        phx
        phy
        phb
        phd
        shorta
        lda     #$00
        pha
        plb
        ldx     #$0000
        phx
        pld
        ldx     #$0000
        stx     $00
        lda     #$7e
        sta     hWMADDH
        jsr     InitInterrupts
        jsr     InitRAM
        ldy     #$012c
        sty     $85         ; ??? (something to do with character full name text)
        stz     $b4         ; use inverse credits palette
        jsr     DisableDMA
        jsr     DisableInterruptsEnding
        jsl     InitHWRegsMenu
        jsl     InitCtrl
        jsr     ResetTasks
        jsr     ClearVRAM
        jsl     PushMode7Vars
        lda     $0201       ; cinematic state
        sta     $26
        jsr     EndingLoop
        jsl     PopMode7Vars
        jsr     DisableInterruptsEnding
        longai
        pld
        plb
        ply
        plx
        pla
        plp
        rtl
        .a8

; ------------------------------------------------------------------------------

; [ disable interrupts ]

DisableInterruptsEnding:
@c576:  lda     #$8f        ; screen off
        sta     hINIDISP
        clr_a
        sta     hNMITIMEN       ; disable nmi and irq
        sta     hMDMAEN
        sta     hHDMAEN
        rts

; ------------------------------------------------------------------------------

; [ disable dma 1 & dma 2 ]

DisableDMA:
@c586:  clr_ay
        sty     $1b
        sty     $1d
        sta     $1f
        sty     $16
        sta     $18
        ldy     #$0001
        sty     $19
        sty     $12
        ldy     #$7fff
        sty     $14
        rts

; ------------------------------------------------------------------------------

; [ enable bg1 color addition ]

_c3c59f:
@c59f:  lda     #$01
        sta     hCGADSUB
        rts

; ------------------------------------------------------------------------------

; [ cinematic loop ]

EndingLoop:
@c5a5:  clr_a
        lda     $26         ; cinematic state
        cmp     #$ff
        beq     @c5bd       ; terminate if $ff
        longa
        asl
        tax
        shorta
        jsr     (.loword(EndingStateTbl),x)   ; state code
        jsr     ExecTasks
        jsr     WaitVblank
        bra     @c5a5
@c5bd:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $00: fade out ]

EndingState_00:
@c5be:  ldy     $20                     ; return if wait counter is not clear
        bne     @c5d3
        lda     #$01                    ; wait for fade
        sta     $26
        ldy     #15                     ; wait 15 frames
        sty     $20
        lda     #0
        ldy     #.loword(EndingFadeOutTask)
        jsr     CreateTask
@c5d3:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $01: wait for fade ]

EndingState_01:
@c5d4:  ldy     $20         ; return if wait counter is not clear
        bne     @c5db
        jmp     ExitEnding
@c5db:  rts

; ------------------------------------------------------------------------------

; [ use normal credits palette ]

; used for clouds scenes

_c3c5dc:
@c5dc:  lda     #1
        sta     $b4
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $05: clouds 3 (mode 7 airship above clouds) ]

; credits scene 1

EndingState_05:
@c5e1:  jsr     _c3c5dc       ; use normal credits palette
        jsl     InitHWRegsCredits
        jsr     _c3d40c       ; load graphics (airship above clouds)
        jsr     InitMode7Scroll
        jsl     _d4cbfc
        ldy     #$0010
        sty     $8e
        longa
        lda     #$fff1
        sta     $7eb68d
        lda     #$002e
        sta     $7eb68f
        lda     #$0071
        sta     $7eb695
        lda     #$008d
        sta     $7eb697
        shorta
        ldy     #$005e
        sty     $c7
        ldy     #$2f00
        sty     $c5
        ldy     #$0100
        sty     $b7
        ldy     #$0311
        sty     $b9
        ldy     #$0080
        sty     $35
        ldy     #$0291
        sty     $37
        jsr     UpdateMode7HDMA
        ldy     $00
        sty     $cf         ; clear frame counter
        jsr     LoadCreditsTextScene1
        lda     #2
        ldy     #.loword(CreditsTextTaskScene1)
        jsr     CreateTask
        lda     #$02
        ldy     #.loword(_c3c681)
        jsr     CreateTask
        lda     #0
        ldy     #.loword(_c3d0f2)
        jsr     CreateTask
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        jsr     _c3d018       ;
        lda     #$03        ; cinematic state 3 (wait)
        sta     $26
        ldy     #$021c      ; set timer to 9.0s
        sty     $20
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ create fade in thread ]

CreateEndingFadeInTask:
@c66c:  lda     #0
        ldy     #.loword(EndingFadeInTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

EndingWaitVblank:
@c675:  lda     #$01
        sta     $44
        jsr     WaitVblank
        lda     #$0f
        sta     $44
        rts

; ------------------------------------------------------------------------------

EndingState_06:

; ------------------------------------------------------------------------------

; [ ??? thread ]

_c3c681:
@c681:  tax
        jmp     (.loword(_c3c685),x)

_c3c685:
@c685:  .addr   _c3c68b, _c3c69a, _c3c6ba

; ------------------------------------------------------------------------------

_c3c68b:
@c68b:  ldx     $2d
        inc     $3649,x
        longa
        lda     #$024e
        sta     $3349,x
        shorta

_c3c69a:
@c69a:  ldx     $2d
        lda     $23
        and     #$01
        bne     @c6a6
        longa
        inc     $8e
@c6a6:  longa
        lda     $8e
        sta     $0600
        stz     $07c2
        stz     $0984
        jsr     _c3c6bf
        shorta
        sec
        rts

_c3c6ba:
@c6ba:  jsr     _c3c6bf
        sec
        rts

; ------------------------------------------------------------------------------

_c3c6bf:
@c6bf:  longa
        dec     $35
        dec     $b7
        lda     $35
        sta     $b691
        lda     $37
        sta     $b693
        lda     $b7
        sta     $b699
        lda     $b9
        sta     $b69b
        shorta
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $07, $08: unused ??? ]

EndingState_07:
EndingState_08:

; ------------------------------------------------------------------------------

FadeOutCreditsPal:
@c6dc:  lda     #^BlackPal
        sta     $ed
        lda     #$04        ; speed = 4 frames per update
        ldy     #$31c9      ; destination = $7e31c9 (sprite palette 4)
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^BlackPal
        sta     $ed
        lda     #$04        ; speed = 4 frames per update
        ldy     #$31e9      ; destination = $7e31e9 (sprite palette 5)
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade in inverse credits palette ]

; used for everything except clouds scenes

_c3c703:
@c703:  lda     #^_c29754        ; source = $c29754 (inverse credits palette 1)
        sta     $ed
        lda     #4        ; speed = 4 frames per update
        ldy     #$31c9      ; destination = $7e31c9 (sprite palette 4)
        sty     $e7
        ldx     #.loword(_c29754)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^_c2974c        ; source = $c2974c (inverse credits palette 2)
        sta     $ed
        lda     #4        ; speed = 4 frames per update
        ldy     #$31e9      ; destination = $7e31e9 (sprite palette 5)
        sty     $e7
        ldx     #.loword(_c2974c)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade in normal credits palette ]

; used for clouds scenes only

_c3c72a:
@c72a:  lda     #^_c29744        ; source = $c29744 (normal credits palette 1)
        sta     $ed
        lda     #$04        ; speed = 4 frames per update
        ldy     #$31c9      ; destination = $7e31c9 (sprite palette 4)
        sty     $e7
        ldx     #.loword(_c29744)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^_c2973c        ; source = $c2973c (normal credits palette 2)
        sta     $ed
        lda     #$04        ; speed = 4 frames per update
        ldy     #$31e9      ; destination = $7e31e9 (sprite palette 5)
        sty     $e7
        ldx     #.loword(_c2973c)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ load credits sprite palettes ]

LoadCreditsSpritePal:
@c751:  lda     #^_c297f4
        ldy     #$3149      ; sprite palette 0
        ldx     #.loword(_c297f4)
        jsr     LoadPal
        lda     #^_c29794
        ldy     #$3169      ; sprite palette 1
        ldx     #.loword(_c29794)
        jsr     LoadPal
        lda     #^_c297b4
        ldy     #$3189      ; sprite palette 2
        ldx     #.loword(_c297b4)
        jsr     LoadPal
        lda     #^_c297d4
        ldy     #$31a9      ; sprite palette 3
        ldx     #.loword(_c297d4)
        jsr     LoadPal
        lda     #^_c29834
        ldy     #$3209      ; sprite palette 6
        ldx     #.loword(_c29834)
        jsr     LoadPal
        lda     #^_c29814
        ldy     #$3229      ; sprite palette 7
        ldx     #.loword(_c29814)
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; unused ending states

EndingState_25:
EndingState_26:
EndingState_27:
EndingState_2c:
EndingState_31:
EndingState_36:
EndingState_37:
EndingState_39:
EndingState_3a:
EndingState_3b:
EndingState_4e:
EndingState_54:
EndingState_55:
EndingState_56:
EndingState_57:
EndingState_58:
EndingState_59:
EndingState_5e:
EndingState_5f:
EndingState_60:
EndingState_61:
EndingState_62:
EndingState_63:
EndingState_6b:
EndingState_6c:
EndingState_6d:
EndingState_72:
EndingState_73:
EndingState_74:
EndingState_75:
EndingState_76:
EndingState_77:
EndingState_7c:
EndingState_7d:
EndingState_7e:
EndingState_7f:
EndingState_80:
EndingState_81:

; ------------------------------------------------------------------------------

; [ cinematic state $09: tiny airship 1 ]

; credits scene 2

EndingState_09:
@c794:  jsr     _c3c5dc       ; use normal credits palette
        jsl     InitHWRegsCredits
        jsr     _c3d522
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        jsr     LoadCreditsSpritePal
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        ldy     #.loword(CreditsScrollScene2)
        lda     #^CreditsScrollScene2
        jsr     CreateMode7ScrollTask
        jsr     LoadCreditsTextScene2
        ldy     $00
        sty     $cf
        lda     #2
        ldy     #.loword(CreditsTextTaskScene2)
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control thread
        inc     $26
        ldy     #$03c0      ; set timer to 16.0s
        sty     $20
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $0a: tiny airship 2 ]

EndingState_0a:
@c7d2:  ldy     $20
        bne     @c7e0
        inc     $26
        ldy     #$0870      ; set timer to 36s
        sty     $20
        jsr     InitTinyAirshipTasks
@c7e0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $0b: tiny airship 3 ]

EndingState_0b:
@c7e1:  ldy     $20
        bne     @c801
        lda     #$03
        sta     $26
        ldy     #2*60                   ; 2 seconds
        sty     $20
        lda     #^WhitePal
        sta     $ed
        lda     #$02
        ldy     #$30a9
        sty     $e7
        ldx     #.loword(WhitePal)
        stx     $eb
        jsr     CreateFadePalTask
@c801:  rts

; ------------------------------------------------------------------------------

; [ create tiny airship and shadow ]

InitTinyAirshipTasks:
@c802:  jsr     _c3c846       ; create generic thread w/ counter
        longa
        lda     #.loword(TinyAirshipAnim)
        jsr     InitTinyAirshipMovement
        shorta
        lda     #^TinyAirshipAnim
        sta     $7e35ca,x
        lda     #$f8
        sta     $7e33ca,x   ; x position
        lda     #$a0
        sta     $7e344a,x   ; y position

; airship shadow
        lda     #3
        ldy     #.loword(_c3de84)      ; generic animation thread w/ counter
        jsr     CreateTask
        longa
        lda     #.loword(TinyAirshipShadowAnim)
        jsr     InitTinyAirshipMovement
        shorta
        lda     #^TinyAirshipShadowAnim
        sta     $7e35ca,x
        lda     #$f8
        sta     $7e33ca,x   ; x position
        lda     #$b0
        sta     $7e344a,x   ; y position
        rts

; ------------------------------------------------------------------------------

; [ create generic thread w/ counter ]

_c3c846:
@c846:  lda     #1
        ldy     #.loword(_c3de84)      ; generic animation thread w/ counter
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ init tiny airship thread ]

InitTinyAirshipMovement:
        .a16
@c84f:  sta     $7e32c9,x   ; pointer to sprite data
        lda     #$ffc0
        sta     $7e34c9,x   ; horizontal speed
        lda     #$ffe0
        sta     $7e3549,x   ; vertical speed
        lda     #$0400
        sta     $7e3349,x   ; movement counter
        rts
        .a8

; ------------------------------------------------------------------------------

; [ cinematic state $02: clouds 1 (slow scroll) ]

EndingState_02:
@c869:  jsr     _c3c87e       ; clouds init
        ldy     #$00f0
        sty     $20
        ldy     #.loword(CreditsScrollClouds1)
        lda     #^CreditsScrollClouds1
        jsr     CreateMode7ScrollTask
        inc     $26
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ clouds init ]

_c3c87e:
@c87e:  jsl     InitHWRegsCredits
        jsr     _c3d522
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        jsr     LoadCreditsSpritePal
        jsr     _c3d15c       ; clear credits text palettes
        ldy     #$0200
        sty     $c7
        ldy     #$f000
        sty     $c5
        jsr     UpdateMode7HDMA
        jsr     LoadCreditsBGPal
        jsr     _c3d2a0       ; create camera control thread
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $03: wait ]

EndingState_03:
@c8a6:  ldy     $20
        bne     @c8ac
        stz     $26         ; cinematic state 0 (begin fade out)
@c8ac:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $04: clouds 2 (spiraling down) ]

EndingState_04:
@c8ad:  jsr     _c3c87e       ; clouds init
        ldy     #$8000
        sty     $c7
        ldy     #$8000
        sty     $c5
        jsr     UpdateMode7HDMA
        ldy     #$0078
        sty     $20
        ldy     #.loword(CreditsScrollClouds2)
        lda     #^CreditsScrollClouds2
        jsr     CreateMode7ScrollTask
        lda     #$03
        sta     $26
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $0c: sea with boat 1 ]

; credits scene 3

EndingState_0c:
@c8d1:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsr     _c3d5aa
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        ldy     #$1000
        sty     $c5
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        jsr     LoadCreditsSpritePal
        ldy     #.loword(CreditsScrollScene3)
        lda     #^CreditsScrollScene3
        jsr     CreateMode7ScrollTask
        jsr     _c3cac7       ; create oscillating birds (boat)
        jsr     LoadCreditsTextScene3
        ldy     $00
        sty     $cf
        lda     #2
        ldy     #.loword(CreditsTextTaskScene3)
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control thread
        ldy     #$0438      ; wait 18.0s
        sty     $20
        inc     $26
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $0d: sea with boat 2 ]

EndingState_0d:
@c917:  ldy     $20
        bne     @c925
        jsr     _c3c94e       ; create boat threads
        stz     $26
        ldy     #$02d0      ; wait 12.0s
        sty     $20
@c925:  rts

; ------------------------------------------------------------------------------

; [ create boat thread (right half only) ]

; unused

@c926:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(_cff7fd)
        sta     $7e32c9,x
        lda     #$ffc0
        sta     $7e34c9,x
        shorta
        lda     #^_cff7fd
        sta     $7e35ca,x
        lda     #$f8
        sta     $7e33ca,x
        lda     #$70
        sta     $7e344a,x
        rts

; ------------------------------------------------------------------------------

; [ create boat threads ]

_c3c94e:
@c94e:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(_cff809)
        sta     $7e32c9,x
        lda     #$ffc0
        sta     $7e34c9,x
        shorta
        lda     #^_cff809
        sta     $7e35ca,x
        lda     #$f8
        sta     $7e33ca,x
        lda     #$50
        sta     $7e344a,x
        lda     #$01
        ldy     #.loword(_c3c9a2)      ; boat thread (right half)
        jsr     CreateTask
        longa
        lda     #.loword(_cff7fd)      ; cf/f7fd (boat, right half)
        sta     $7e32c9,x
        lda     #$ffc0
        sta     $7e34c9,x
        shorta
        lda     #^_cff7fd
        sta     $7e35ca,x
        lda     #$f8
        sta     $7e33ca,x
        lda     #$50
        sta     $7e344a,x
        rts

; ------------------------------------------------------------------------------

; [ boat thread (right half) ]

_c3c9a2:
@c9a2:  tax
        jmp     (.loword(_c3c9a6),x)

_c3c9a6:
@c9a6:  .addr   _c3c9aa, _c3c9bc

; ------------------------------------------------------------------------------

_c3c9aa:
@c9aa:  ldx     $2d
        inc     $3649,x
        longa
        lda     #$0040
        sta     $3349,x     ; set thread counter to 64
        shorta
        jsr     InitAnimTask

_c3c9bc:
@c9bc:  ldx     $2d
        ldy     $3349,x     ; start moving left after 64 frames (i think...)
        bne     @c9c8
        jsr     UpdateEndingAnimTask
        sec
        rts
@c9c8:  jsr     DecTaskCounter
        sec
        rts

; ------------------------------------------------------------------------------

EndingState_0e:
EndingState_0f:

; ------------------------------------------------------------------------------

; [ cinematic state $10: sea with airship 1 ]

; credits scene 4

EndingState_10:
@c9cd:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsr     _c3d5da
        jsr     _c3ca71
        jsr     InitCreditsFixedColorHDMA
        jsr     InitCreditsColorMathHDMA
        jsr     LoadCreditsSpritePal
        ldy     #$0028
        sty     $3b
        ldy     #$ff6d
        sty     $c3
        ldy     #$034c
        sty     $c7
        ldy     #$fd00
        sty     $c5
        jsr     UpdateMode7HDMA
        jsr     _c3cafd       ; create oscillating birds (sea with airship)
        lda     #$02
        ldy     #.loword(_c3cbc6)      ; airship position thread (going left)
        jsr     CreateTask
        longa
        lda     #.loword(AirshipLeftAnim)
        sta     $7e32c9,x
        shorta
        lda     #^AirshipLeftAnim
        sta     $7e35ca,x
        lda     #$78
        sta     $7e33ca,x
        lda     #$58
        sta     $7e344a,x
        jsr     CreateEndingAnimTask
        longa
        lda     #.loword(AirshipShadowAnim)
        sta     $7e32c9,x
        shorta
        lda     #^AirshipShadowAnim
        sta     $7e35ca,x
        lda     #$80
        sta     $7e33ca,x
        lda     #$80
        sta     $7e344a,x
        jsr     LoadCreditsBGPal
        jsr     LoadCreditsTextScene4
        ldy     $00
        sty     $cf
        lda     #2
        ldy     #.loword(CreditsTextTaskScene4)
        jsr     CreateTask
        ldy     #.loword(CreditsScrollScene4)
        lda     #^CreditsScrollScene4
        jsr     CreateMode7ScrollTask
        lda     #$03
        ldy     #.loword(ScrollBG2RightThread)
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control thread
        inc     $26
        ldy     #$04b0
        sty     $20
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [  ]

_c3ca71:
@ca71:  jsr     InitMode7Scroll
        jsr     LoadCloudsBackdropGfx
        jsr     InitBigAirshipMode7HDMA
        jsr     _c3d15c       ; clear credits text palettes
        jmp     _c3ca80

; ------------------------------------------------------------------------------

; [  ]

_c3ca80:
@ca80:  lda     #^_c2953c
        ldy     #$3049
        ldx     #.loword(_c2953c)
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $11: sea with airship 2 ]

EndingState_11:
@ca8c:  ldy     $20
        bne     @caa1
        lda     #$03
        sta     $26
        ldy     #$0708
        sty     $20
        lda     #$01
        ldy     #.loword(_c3cc79)
        jsr     CreateTask
@caa1:  rts

; ------------------------------------------------------------------------------

; [ scroll bg2 right thread ]

ScrollBG2RightThread:
@caa2:  lda     $23
        and     #$01
        bne     @caae
        longa
        dec     $39
        shorta
@caae:  sec
        rts

; ------------------------------------------------------------------------------

; [ scroll bg2 left thread ]

ScrollBG2LeftThread:
@cab0:  lda     $23
        and     #$01
        bne     @cabc
        longa
        inc     $39
        shorta
@cabc:  sec
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $12, $13:  ]

; unused

EndingState_12:
EndingState_13:
@cabe:  ldy     $20
        bne     @cac6
        lda     #$ff
        sta     $26
@cac6:  rts

; ------------------------------------------------------------------------------

; [ create oscillating birds (boat) ]

_c3cac7:
@cac7:  ldx     $00
@cac9:  phx
        jsr     _c3cb5f       ; create oscillating bird thread
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:ShipBirdsAnim,x   ; sprite data pointer (+$cf0000)
        inx2
        sta     $32c9,y
        shorta
        lda     f:ShipBirdsAnim,x   ; x position
        inx
        sta     $34ca,y
        lda     f:ShipBirdsAnim,x   ; y position
        inx
        sta     $344a,y
        lda     #$01
        sta     $364a,y     ; sprite doesn't scroll with bg
        plb
        cpx     #$0018      ; repeat 6 times
        bne     @cac9
        rts

; ------------------------------------------------------------------------------

; [ create oscillating birds (sea with airship) ]

_c3cafd:
@cafd:  ldx     $00
@caff:  phx
        jsr     _c3cb5f       ; create oscillating bird thread
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:_cff7cd,x
        inx2
        sta     $32c9,y
        shorta
        lda     f:_cff7cd,x
        inx
        sta     $34ca,y
        lda     f:_cff7cd,x
        inx
        sta     $344a,y
        plb
        cpx     #$0018
        bne     @caff
        rts

; ------------------------------------------------------------------------------

; [ create oscillating birds (land with airship) ]

_c3cb2e:
@cb2e:  ldx     $00
@cb30:  phx
        jsr     _c3cb5f       ; create oscillating bird thread
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:_cff7e5,x
        inx2
        sta     $32c9,y
        shorta
        lda     f:_cff7e5,x
        inx
        sta     $34ca,y
        lda     f:_cff7e5,x
        inx
        sta     $344a,y
        plb
        cpx     #$0018
        bne     @cb30
        rts

; ------------------------------------------------------------------------------

; [ create oscillating bird thread ]

_c3cb5f:
@cb5f:  lda     #2
        ldy     #.loword(_c3cb68)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ oscillating bird thread ]

_c3cb68:
@cb68:  tax
        jmp     (.loword(_c3cb6c),x)

_c3cb6c:
@cb6c:  .addr   _c3cb70, _c3cb87

; ------------------------------------------------------------------------------

_c3cb70:
@cb70:  ldx     $2d
        inc     $3649,x
        stz     $334a,x
        lda     f:_c3cb68,x             ; looks like a bug ???
        sta     $3349,x
        lda     #^_cff706
        sta     $35ca,x
        jsr     InitAnimTask

_c3cb87:
@cb87:  ldx     $2d
        jsr     _c3cb94                 ; update oscillating bird position
        inc     $3349,x
        jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update oscillating bird position ]

_c3cb94:
@cb94:  longa
        lda     $3349,x
        jsr     CalcCosine
        sta     $eb
        sta     $e0
        lda     $e0
        bpl     @cba8
        eor     #$ffff
        inc
@cba8:  sta     $e0
        lda     $eb
        bpl     @cbb7
        jsr     _c3cc31
        eor     #$ffff
        inc
        bra     @cbba
@cbb7:  jsr     _c3cc31
@cbba:  ldx     $2d
        clc
        adc     $34c9,x
        sta     $33c9,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ airship position thread (with splash) ]

_c3cbc6:
@cbc6:  tax
        jmp     (.loword(_c3cbca),x)

_c3cbca:
@cbca:  .addr   _c3cbce, _c3cbe6

; ------------------------------------------------------------------------------

_c3cbce:
@cbce:  ldx     $2d
        inc     $3649,x
        stz     $334a,x
        stz     $3349,x
        lda     #$78
        sta     $33ca,x
        lda     #$20
        sta     $354a,x
        jsr     InitAnimTask

_c3cbe6:
@cbe6:  ldx     $2d
        jsr     _c3cbff       ; update airship position (sine)
        ldx     $2d
        inc     $3349,x
        lda     $3349,x
        cmp     #$38
        bcs     @cbfa
        jsr     _c3cc38       ; create airship splash thread
@cbfa:  jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update airship position (sine) ]

_c3cbff:
@cbff:  longa
        lda     $3349,x
        jsr     CalcSine
        sta     $eb
        sta     $e0
        lda     $e0
        bpl     @cc13
        eor     #$ffff
        inc
@cc13:  sta     $e0
        lda     $eb
        bpl     @cc22
        jsr     _c3cc31
        eor     #$ffff
        inc
        bra     @cc25
@cc22:  jsr     _c3cc31
@cc25:  ldx     $2d
        clc
        adc     $3549,x
        sta     $3449,x
        shorta
        rts

; ------------------------------------------------------------------------------

_c3cc31:
@cc31:  lda     $e0
        lsr4
        rts

; ------------------------------------------------------------------------------

; [ create airship splash thread ]

_c3cc38:
@cc38:  lda     $23
        and     #$03
        bne     @cc78
        phb
        lda     #$00
        pha
        plb
        jsr     _c3c846       ; create generic thread w/ counter
        longa
        lda     #.loword(AirshipSplashAnim)
        sta     $7e32c9,x
        lda     #$0100
        sta     $7e34c9,x
        lda     #$ff80
        sta     $7e3549,x
        shorta
        lda     #$18
        sta     $7e3349,x
        lda     #^AirshipSplashAnim
        sta     $7e35ca,x
        lda     #$7e
        sta     $7e33ca,x
        lda     #$7c
        sta     $7e344a,x
        plb
@cc78:  rts

; ------------------------------------------------------------------------------

; [ airship position thread (???) ]

_c3cc79:
@cc79:  tax
        jmp     (.loword(_c3cc7d),x)

_c3cc7d:
@cc7d:  .addr   _c3cc81, _c3cca8

; ------------------------------------------------------------------------------

_c3cc81:
@cc81:  ldx     $2d
        inc     $3649,x
        lda     #^_cff772
        sta     $35ca,x
        longa
        lda     #.loword(_cff772)      ; cf/f772 (bird 5)
        sta     $32c9,x
        lda     #$0010
        sta     $3349,x
        shorta
        lda     #$00
        sta     $34ca,x
        lda     #$00
        sta     $354a,x
        jsr     InitAnimTask

_c3cca8:
@cca8:  ldx     $2d
        lda     $33ca,x
        cmp     #$08
        bcs     @ccb3
        clc
        rts
@ccb3:  longa
        lda     $3349,x
        jsr     CalcCosine
        sta     $eb
        sta     $e0
        lda     $e0
        bpl     @ccc7
        eor     #$ffff
        inc
@ccc7:  sta     $e0
        lda     $eb
        bpl     @ccd6
        lda     $e0
        asl
        eor     #$ffff
        inc
        bra     @ccd9
@ccd6:  lda     $e0
        asl
@ccd9:  ldx     $2d
        clc
        adc     $34c9,x
        sta     $33c9,x
        lda     $3349,x
        jsr     CalcSine
        sta     $eb
        sta     $e0
        lda     $e0
        bpl     @ccf4
        eor     #$ffff
        inc
@ccf4:  sta     $e0
        lda     $eb
        bpl     @cd02
        lda     $e0
        eor     #$ffff
        inc
        bra     @cd04
@cd02:  lda     $e0
@cd04:  ldx     $2d
        clc
        adc     $3549,x
        sta     $3449,x
        inc     $3349,x
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $14: airship/land with birds 1 ]

; credits scene 5

EndingState_14:
@cd17:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsl     _c3d573
        jsr     _c3ca71
        jsr     InitCreditsFixedColorHDMA
        jsr     InitCreditsColorMathHDMA
        jsr     LoadCreditsSpritePal
        ldy     #$0028
        sty     $3b
        ldy     #$ffcd
        sty     $c3
        ldy     #$030b
        sty     $c7
        ldy     #$f000
        sty     $c5
        jsr     UpdateMode7HDMA
        jsr     LoadCreditsBGPal
        jsr     _c3cb2e       ; create oscillating birds (land with airship)
        jsr     _c3cfdc
        longa
        lda     #.loword(AirshipRightAnim)
        sta     $7e32c9,x
        shorta
        lda     #^AirshipRightAnim
        sta     $7e35ca,x
        lda     #$78
        sta     $7e33ca,x
        lda     #$58
        sta     $7e354a,x
        ldy     #.loword(CreditsScrollScene5)
        lda     #^CreditsScrollScene5
        jsr     CreateMode7ScrollTask
        jsr     LoadCreditsTextScene5
        ldy     $00
        sty     $cf
        lda     #2
        ldy     #.loword(CreditsTextTaskScene5)
        jsr     CreateTask
        lda     #$03
        ldy     #.loword(ScrollBG2LeftThread)
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control thread
        inc     $26
        ldy     #$04b0
        sty     $20
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

_c3cd97:
@cd97:  lda     #2
        ldy     #.loword(_c3cdea)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $15: airship with birds 2 ]

EndingState_15:
@cda0:  ldy     $20
        bne     @cde9
        lda     #$03
        sta     $26
        ldy     #$0708
        sty     $20
        jsr     _c3cd97
        lda     #$00
        sta     $7e33ca,x
        lda     #$50
        sta     $7e344a,x
        jsr     _c3cd97
        lda     #$18
        sta     $7e33ca,x
        lda     #$40
        sta     $7e344a,x
        jsr     _c3cd97
        lda     #$40
        sta     $7e33ca,x
        lda     #$68
        sta     $7e344a,x
        jsr     _c3cd97
        lda     #$10
        sta     $7e33ca,x
        lda     #$48
        sta     $7e344a,x
@cde9:  rts

; ------------------------------------------------------------------------------

EndingState_16:
EndingState_17:

; ------------------------------------------------------------------------------

; [  ]

_c3cdea:
@cdea:  tax
        jmp     (.loword(_c3cdee),x)

_c3cdee:
@cdee:  .addr   _c3ce00,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f
        .addr   _c3ce33

; ------------------------------------------------------------------------------

_c3ce00:
@ce00:  ldx     $2d
        inc     $3649,x
        longa
        lda     #.loword(_cff74f)      ; cf/f74f (bird 4)
        sta     $32c9,x
        shorta
        lda     #^_cff74f
        sta     $35ca,x
        stz     $35c9,x
        jsr     _c3ce43
        ldx     $2d
        jsr     InitAnimTask

_c3ce1f:
@ce1f:  ldx     $2d
        ldy     $3349,x
        bne     @ce2b
        jsr     _c3ce43
        ldx     $2d
@ce2b:  jsr     DecTaskCounter
        jsr     UpdateEndingAnimTask
        sec
        rts

_c3ce33:
@ce33:  jsr     UpdateEndingAnimTask
        ldx     $2d
        lda     $33ca,x
        cmp     #$01
        bcs     @ce41
        clc
        rts
@ce41:  sec
        rts

; ------------------------------------------------------------------------------

_c3ce43:
@ce43:  ldy     $2d
        tyx
        clr_a
        lda     $35c9,y
        inc     $35c9,x
        inc     $3649,x
        asl3
        longa
        tax
        lda     f:_c3ce6e,x
        sta     $34c9,y
        lda     f:_c3ce6e+2,x
        sta     $3549,y
        lda     f:_c3ce6e+4,x
        sta     $3349,y
        shorta
        rts

; ------------------------------------------------------------------------------

_c3ce6e:
@ce6e:  .word   $0020,$fff0,$0384,$0000
        .word   $0020,$0000,$003c,$0000
        .word   $0020,$0020,$003c,$0000
        .word   $0010,$0040,$003c,$0000
        .word   $ffe0,$0040,$003c,$0000
        .word   $ffc0,$0040,$00b4,$0000
        .word   $ff80,$0080,$00b4,$0000

; ------------------------------------------------------------------------------

; [ cinematic state $18: land without sprites ]

; credits scene 6

EndingState_18:
@cea6:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsl     _c3d573
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        ldy     #$1800
        sty     $c5
        jsr     UpdateMode7HDMA
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        ldy     #.loword(CreditsScrollScene6)
        lda     #^CreditsScrollScene6
        jsr     CreateMode7ScrollTask
        jsr     LoadCreditsTextScene6
        ldy     $00
        sty     $cf
        lda     #2
        ldy     #.loword(CreditsTextTaskScene6)
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control thread
        lda     #$03
        sta     $26
        ldy     #$0e10      ; set timer to 60s
        sty     $20
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

EndingState_19:
EndingState_1a:
EndingState_1b:

; ------------------------------------------------------------------------------

; [ cinematic state $1c: big airship ]

; credits scene 7

EndingState_1c:
@ceec:  jsl     InitHWRegsCredits
        jsl     _c3d573
        jsr     _c3d144
        jsr     _c3ca71
        jsr     InitCreditsFixedColorHDMA
        jsr     InitCreditsColorMathHDMA
        ldy     #$0100
        sty     $c5
        ldy     #$02dc
        sty     $c7
        jsr     UpdateMode7HDMA
        ldy     #$0010
        sty     $3b
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsSpritePal
        jsr     LoadCreditsBGPal
        jsr     LoadCreditsTextScene7
        ldy     $00
        sty     $cf
        lda     #2
        ldy     #.loword(CreditsTextTaskScene7)
        jsr     CreateTask
        lda     #$00
        ldy     #.loword(_c3cf9a)      ; bg scrolling thread (big airship)
        jsr     CreateTask
        jsr     InitAirshipPropellerLeftAnim
        lda     #$14
        sta     $7e354a,x
        lda     #$44
        sta     $7e33ca,x
        jsr     InitAirshipPropellerRightAnim
        lda     #$14
        sta     $7e354a,x
        lda     #$ac
        sta     $7e33ca,x
        jsr     InitAirshipPropellerLeftAnim
        lda     #$e8
        sta     $7e354a,x
        lda     #$60
        sta     $7e33ca,x
        jsr     InitAirshipPropellerRightAnim
        lda     #$e8
        sta     $7e354a,x
        lda     #$90
        sta     $7e33ca,x
        jsr     _c3cfdc       ; create airship position thread (no water splash)
        longa
        lda     #.loword(BigAirshipAnim)
        sta     $7e32c9,x
        shorta
        lda     #^BigAirshipAnim
        sta     $7e35ca,x
        lda     #$48
        sta     $7e33ca,x
        lda     #$f8
        sta     $7e354a,x
        lda     #$03
        sta     $26
        ldy     #37*60                  ; 37 sec
        sty     $20
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ bg scrolling thread (big airship) ]

_c3cf9a:
@cf9a:  lda     $23
        and     #$7f
        bne     @cfa2
        inc     $3b         ; increment bg2 v-scroll every 128 frames
@cfa2:  lda     $23
        and     #$01
        bne     @cfb0
        longa
        dec     $b9         ; decrement bg1 v-scroll every 2 frames
        dec     $37
        shorta
@cfb0:  sec
        rts

; ------------------------------------------------------------------------------

; [ create big airship propeller thread (left side, cw) ]

InitAirshipPropellerLeftAnim:
@cfb2:  jsr     _c3cfdc
        lda     #^AirshipPropellerLeftAnim
        sta     $7e35ca,x
        longa
        lda     #.loword(AirshipPropellerLeftAnim)
        sta     $7e32c9,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create big airship propeller thread (right side, ccw) ]

InitAirshipPropellerRightAnim:
@cfc7:  jsr     _c3cfdc
        lda     #^AirshipPropellerRightAnim
        sta     $7e35ca,x
        longa
        lda     #.loword(AirshipPropellerRightAnim)
        sta     $7e32c9,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create airship position thread (no water splash) ]

_c3cfdc:
@cfdc:  lda     #$02
        ldy     #.loword(_c3cff8)      ; airship position thread (no water splash)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ decrement task counter ]

DecTaskCounter:
@cfe5:  ldx     $2d
        longa
        dec     $3349,x     ; decrement counter
        shorta
        rts

; ------------------------------------------------------------------------------

; [ set task counter ]

; unused

@cfef:  longa
        tya
        sta     $3349,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ airship position thread (no water splash) ]

_c3cff8:
@cff8:  tax
        jmp     (.loword(_c3cffc),x)

_c3cffc:
@cffc:  .addr   _c3d000, _c3d00b

; ------------------------------------------------------------------------------

_c3d000:
@d000:  ldx     $2d
        inc     $3649,x
        stz     $3349,x
        jsr     InitAnimTask

_c3d00b:
@d00b:  ldx     $2d
        jsr     _c3cbff       ; update airship position (sine)
        inc     $3349,x
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $1d-$1f:  ]

; unused

EndingState_1d:
EndingState_1e:
EndingState_1f:

; ------------------------------------------------------------------------------

; [  ]

_c3d018:
@d018:  lda     #^_c2959c
        ldy     #$3049
        ldx     #.loword(_c2959c)
        jsr     LoadPal
        lda     #^_c2959c
        ldy     #$3069
        ldx     #.loword(_c2959c)
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $20: airship with jet trails 1 ]

EndingState_20:
@d02f:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        lda     #$80
        sta     hM7SEL
        jsr     _c3d60a
        jsr     InitMode7Scroll
        jsl     _d4ce55
        lda     #^_c29754
        ldy     #$31c9
        ldx     #.loword(_c29754)
        jsr     LoadPal
        lda     #^_c2974c
        ldy     #$31e9
        ldx     #.loword(_c2974c)
        jsr     LoadPal
        jsr     LoadCreditsBGPal
        jsr     _c3d018
        ldy     #$0001
        sty     $bb
        sty     $c1
        ldy     #$0008
        sty     $b7
        ldy     #$0018
        sty     $b9
        ldy     #$ffd8
        sty     $35
        ldy     #$ffd0
        sty     $37
        lda     #0
        ldy     #.loword(_c3d122)
        jsr     CreateTask
        inc     $26
        ldy     #$0096
        sty     $20
        lda     #0
        ldy     #.loword(_c3d0a8)
        jsr     CreateTask
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $21: airship with jet trails 2 ]

EndingState_21:
@d096:  ldy     $20
        bne     @d0a7
        stz     $26
        ldy     #$0078
        sty     $20
        jsr     _c3e16b
        jsr     _c3e241
@d0a7:  rts

; ------------------------------------------------------------------------------

; [ ??? task ]

_c3d0a8:
@d0a8:  lda     $23
        and     #$01
        beq     @d0bf
        lda     #$51
        sta     $7e9849
        lda     #$4f
        sta     $7e984a
        jsr     _c3d0d0
        sec
        rts
@d0bf:  lda     #$59
        sta     $7e9849
        lda     #$5a
        sta     $7e984a
        jsr     _c3d0d0
        sec
        rts

; ------------------------------------------------------------------------------

_c3d0d0:
@d0d0:  ldy     #$0283
        sty     $14
        ldy     #$9849
        sty     $16
        ldy     #$0206
        sty     $1b
        ldy     #$984a
        sty     $1d
        lda     #$7e
        sta     $18
        sta     $1f
        ldy     #$0001
        sty     $12
        sty     $19
        rts

; ------------------------------------------------------------------------------

; [ ??? task ]

_c3d0f2:
@d0f2:  lda     $23
        and     #$01
        beq     @d103
        lda     #$58
        sta     $7e9849
        jsr     _c3d10e
        sec
        rts
@d103:  lda     #$34
        sta     $7e9849
        jsr     _c3d10e
        sec
        rts

; ------------------------------------------------------------------------------

_c3d10e:
@d10e:  ldy     #$0892
        sty     $14
        ldy     #$9849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$0001
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $22-$24:  ]

; unused

EndingState_22:
EndingState_23:
EndingState_24:

_c3d122:
@d122:  jsr     _c3d127
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d127:
@d127:  lda     $23
        and     #$07
        bne     @d137       ; branch 7 out of 8 frames
        ldy     $b9
        dey
        sty     $b9
        ldy     $b7
        iny
        sty     $b7
@d137:  longa
        inc     $bb
        inc     $bb
        inc     $c1
        inc     $c1
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d144:
@d144:  ldy     #$d7ba
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0580
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$6c00
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ clear credits text palettes ]

_c3d15c:
@d15c:  lda     #^BlackPal
        ldy     #$31c9      ; sprite palette 4
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$31e9      ; sprite palette 5
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ load credits bg palettes ]

LoadCreditsBGPal:
@d173:  lda     #^_c295bc
        ldy     #$3069      ; bg palette 1
        ldx     #.loword(_c295bc)
        jsr     LoadPal
        lda     #^_c295dc
        ldy     #$3089      ; bg palette 2
        ldx     #.loword(_c295dc)
        jsr     LoadPal
        lda     #^_c295fc
        ldy     #$30a9      ; bg palette 3
        ldx     #.loword(_c295fc)
        jsr     LoadPal
        lda     #^_c2961c
        ldy     #$30c9      ; bg palette 4
        ldx     #.loword(_c2961c)
        jsr     LoadPal
        lda     #^_c2963c
        ldy     #$3109      ; bg palette 6
        ldx     #.loword(_c2963c)
        jsr     LoadPal
        lda     #^_c2965c
        ldy     #$3129      ; bg palette 7
        ldx     #.loword(_c2965c)
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ scroll bg3 down thread ]

_c3d1b6:
@d1b6:  ldy     $cf
        cpy     $64
        beq     @d1ca
        lda     $23
        and     #$03
        bne     @d1c8
        longa
        dec     $3f         ; scroll bg3 up
        shorta
@d1c8:  sec
        rts
@d1ca:  clc
        rts

; ------------------------------------------------------------------------------

; [ fade in thread ]

EndingFadeInTask:
@d1cc:  tax
        jmp     (.loword(EndingFadeInTaskTbl),x)

EndingFadeInTaskTbl:
@d1d0:  .addr   EndingFadeInTask_00
        .addr   EndingFadeInTask_01

; ------------------------------------------------------------------------------

; 0: init
EndingFadeInTask_00:
@d1d4:  ldx     $2d
        inc     $3649,x
        lda     #$01
        sta     $344a,x
        lda     #$0f
        sta     $3349,x

; 1: update
EndingFadeInTask_01:
@d1e3:  ldx     $2d
        lda     $3349,x
        beq     @d1f7
        lda     $344a,x
        sta     $44         ; screen display register (-> $2100)
        inc     $344a,x
        dec     $3349,x
        sec
        rts
@d1f7:  lda     #$0f        ; screen on, full brightness
        sta     $44         ; screen display register (-> $2100)
        clc
        rts

; ------------------------------------------------------------------------------

; [ fade out thread ]

EndingFadeOutTask:
@d1fd:  tax
        jmp     (.loword(EndingFadeOutTaskTbl),x)

EndingFadeOutTaskTbl:
@d201:  .addr   EndingFadeOutTask_00
        .addr   EndingFadeOutTask_01

; ------------------------------------------------------------------------------

; state 0: init
EndingFadeOutTask_00:
@d205:  ldx     $2d
        inc     $3649,x     ; increment thread state
        lda     #$0f
        sta     $33ca,x     ; set initial screen brightness to full

; state 1: update
EndingFadeOutTask_01:
@d20f:  ldy     $20         ; terminate when wait counter reaches zero
        beq     @d21f
        ldx     $2d
        lda     $33ca,x
        sta     $44         ; set screen brightness
        dec     $33ca,x     ; decrement screen brightness
        sec
        rts
@d21f:  lda     #$80        ; screen off
        sta     $44
        clc
        rts

; ------------------------------------------------------------------------------

; [ load mode 7 scrolling data ]

; +Y: pointer to mode 7 scrolling data
;  A: pointer bank

CreateMode7ScrollTask:
@d225:  pha
        phy
        lda     #1
        ldy     #.loword(Mode7ScrollTask)
        jsr     CreateTask
        longa
        ply
        tya
        sta     $7e32c9,x
        shorta
        pla
        sta     $7e35ca,x
        rts

; ------------------------------------------------------------------------------

; [ mode 7 scrolling task ]

Mode7ScrollTask:
@d23f:  tax
        jmp     (.loword(Mode7ScrollTaskTbl),x)

Mode7ScrollTaskTbl:
@d243:  .addr   Mode7ScrollTask_00
        .addr   Mode7ScrollTask_01

; ------------------------------------------------------------------------------

Mode7ScrollTask_00:
@d247:  ldx     $2d
        inc     $3649,x
        jsr     InitAnimTask

Mode7ScrollTask_01:
@d24f:  ldx     $2d
        jsr     UpdateAnimData
        clr_a
        lda     $36c9,x                 ; data pointer
        tay
        longa
        lda     [$eb],y                 ; buttons pressed
        sta     $04
        shorta
        sec
        rts

; ------------------------------------------------------------------------------

; [ update mode 7 registers ]

UpdateMode7Regs:
@d263:  lda     $bb
        sta     hM7A
        lda     $bc
        sta     hM7A
        lda     $bd
        sta     hM7B
        lda     $be
        sta     hM7B
        lda     $bf
        sta     hM7C
        lda     $c0
        sta     hM7C
        lda     $c1
        sta     hM7D
        lda     $c2
        sta     hM7D
        lda     $b7
        sta     hM7X
        lda     $b8
        sta     hM7X
        lda     $b9
        sta     hM7Y
        lda     $ba
        sta     hM7Y
        rts

; ------------------------------------------------------------------------------

; [ create camera control thread ]

_c3d2a0:
@d2a0:  lda     #0
        ldy     #.loword(_c3d2a9)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ camera control thread ]

_c3d2a9:
@d2a9:  lda     $04
        bit     #$10
        beq     @d2b7       ; branch if R button not pressed
        longa
        inc     $c3
        shorta
        inc     $59
@d2b7:  lda     $04
        bit     #$20
        beq     @d2c5       ; branch if L button not pressed
        longa
        dec     $c3
        shorta
        dec     $59
@d2c5:  lda     $04
        bit     #$40
        beq     @d2d1       ; branch if X button not pressed
        longa
        inc     $c7         ; increase tilt angle
        shorta
@d2d1:  lda     $05
        bit     #$40
        beq     @d2dd       ; branch if Y button not pressed
        longa
        dec     $c7         ; decrease tilt angle
        shorta
@d2dd:  lda     $04
        bit     #$80
        beq     @d2e5       ; branch if A button not pressed
        inc     $c6         ; zoom in
@d2e5:  lda     $05
        bit     #$80
        beq     @d2ed       ; branch if B button not pressed
        dec     $c6         ; zoom out
@d2ed:  lda     $05
        bit     #$08
        beq     @d2fb       ; branch if up button not pressed
        longa
        dec     $b9         ; decrement y position
        dec     $37
        shorta
@d2fb:  lda     $05
        bit     #$04
        beq     @d309       ; branch if down button not pressed
        longa
        inc     $b9         ; increment y position
        inc     $37
        shorta
@d309:  lda     $05
        bit     #$02
        beq     @d317       ; branch if left button not pressed
        longa
        dec     $b7         ; decrement x position
        dec     $35
        shorta
@d317:  lda     $05
        bit     #$01
        beq     @d325       ; branch if right button not pressed
        longa
        inc     $b7         ; increment x position
        inc     $35
        shorta
@d325:  jsr     _c3d338       ; clip x & y position
        longa
        lda     $04
        and     #$f0ff
        shorta
        beq     @d336       ; branch if no buttons are pressed
        jsr     UpdateMode7HDMA
@d336:  sec
        rts

; ------------------------------------------------------------------------------

; [ clip x & y position ]

_c3d338:
@d338:  longa
        lda     $b7
        and     #$1fff      ; max $1fff
        sta     $b7
        lda     $b9
        and     #$1fff
        sta     $b9
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init hdma (big airship) ]

InitBigAirshipMode7HDMA:
@d34b:  jsl     _d4cb8f
        stz     $4310       ; hdma channel #1
        lda     #<hBGMODE
        sta     $4311
        ldy     #.loword(BigAirshipMode7HDMATbl)
        sty     $4312
        lda     #^BigAirshipMode7HDMATbl
        sta     $4314
        sta     $4317
        lda     #$02
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; bg mode hdma table for big airship (mode 1 for $47 scanlines, then mode 7 for the remainder)
BigAirshipMode7HDMATbl:
@d36a:  .byte   $47,$01
        .byte   $01,$07
        .byte   $00

; ------------------------------------------------------------------------------

; [ init color math hdma (credits) ]

InitCreditsColorMathHDMA:
@d36f:  lda     #$01
        sta     $4330
        lda     #$30
        sta     $4331
        ldy     #.loword(CreditsColorMathHDMATbl)
        sty     $4332
        lda     #^CreditsColorMathHDMATbl
        sta     $4334
        sta     $4337
        lda     #$08
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ init fixed color hdma (credits) ]

InitCreditsFixedColorHDMA:
@d38c:  stz     $4320
        lda     #$32
        sta     $4321
        ldy     #.loword(CreditsFixedColorHDMATbl)
        sty     $4322
        lda     #^CreditsFixedColorHDMATbl
        sta     $4324
        sta     $4327
        lda     #$04
        tsb     $43
        rts

; ------------------------------------------------------------------------------

CreditsColorMathHDMATbl:
@d3a7:  .byte   $47,$80
        .byte   $41,$01
        .byte   $82,$01
        .byte   $00

CreditsFixedColorHDMATbl:
@d3ae:  .byte   $47,$e0
        .byte   $01,$ed
        .byte   $01,$eb
        .byte   $01,$ea
        .byte   $02,$e9
        .byte   $03,$e8
        .byte   $04,$e7
        .byte   $05,$e6
        .byte   $06,$e5
        .byte   $07,$e4
        .byte   $08,$e3
        .byte   $0c,$e2
        .byte   $0f,$e1
        .byte   $1e,$e0
        .byte   $00

; ------------------------------------------------------------------------------

; unused

@d3cb:  stz     $4320
        lda     #$32
        sta     $4321
        ldy     #$9849
        sty     $4322
        lda     #$7e
        sta     $4324
        sta     $4327
        lda     #$04
        tsb     $43
        rts

; ------------------------------------------------------------------------------

; [ init mode 7 scrolling data ]

InitMode7Scroll:
@d3e6:  ldy     #$0100
        sty     $b7
        ldy     #$0080
        sty     $b9
        sty     $35
        clr_ay
        sty     $37
        stz     $58
        lda     #$40
        sta     $59
        ldy     #$0000
        sty     $c7
        ldy     #$0100
        sty     $c5
        ldy     #$0000
        sty     $c3
        rts

; ------------------------------------------------------------------------------

; [ load graphics (airship above clouds) ]

_c3d40c:
@d40c:  jsr     LoadCreditsFontGfx
        jsr     InitCreditsGfxClouds
        jsr     _c3d66b       ; load credits palette assignment (clouds/airship)
        jsr     _c3d552
        jsr     _c3d42a
        jsr     _c3d634
        jsr     _c3d66b       ; load credits palette assignment (clouds/airship)
        jsr     _c3d562
        jsr     _c3d42a
        jmp     _c3d64c

; ------------------------------------------------------------------------------

; [  ]

_c3d42a:
@d42a:  jsr     _c3d68d
        ldx     #$fc1a      ; credits tilemap (clouds)
        stx     $f1
        lda     #$7e
        sta     $f3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [ load credits font graphics ]

LoadCreditsFontGfx:
@d439:  ldy     #.loword(EndingFontGfx)
        lda     #^EndingFontGfx
        jsr     Decompress
        jsr     _c3d497
        ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0c00
        sty     $eb
        ldy     #$7000
        jsr     TfrGfx2bpp
        ldy     #$87c0                  ; c4/87c0 (fixed-width font graphics)
        sty     $e7
        lda     #$c4
        sta     $e9
        ldy     #$0200                  ; 32 tiles
        sty     $eb
        ldy     #$7e00
        jsr     TfrGfx2bpp
        jmp     _c3d46f                 ; load punctuation graphics

; ------------------------------------------------------------------------------

; [ load punctuation graphics ]

_c3d46f:
@d46f:  ldy     #$8c10      ; "." (period)
        sty     $e7
        lda     #$c4
        sta     $e9
        ldy     #$0010      ; 1 tile
        sty     $eb
        ldy     #$7fa0
        jsr     TfrGfx2bpp
        ldy     #$8fb0      ; " " (space)
        sty     $e7
        lda     #$c4
        sta     $e9
        ldy     #$0010      ; 1 tile
        sty     $eb
        ldy     #$7fb0
        jmp     TfrGfx2bpp

; ------------------------------------------------------------------------------

; [  ]

_c3d497:
@d497:  phb
        lda     #$7e
        pha
        plb
        ldx     $00
        txy
@d49f:  phx
        clr_a
        lda     f:_c29854,x
        longa
        asl4
        tax
        shorta
        lda     #$10
        sta     $e0
@d4b2:  lda     $c000,x
        sta     $c400,y
        inx
        iny
        dec     $e0
        bne     @d4b2
        clr_ax
@d4c0:  sta     $c400,y
        iny
        inx
        cpx     #$0010
        bne     @d4c0
        plx
@d4cb:  inx
        cpx     #$0040
@d4cf:  bne     @d49f
        plb
        rts

; ------------------------------------------------------------------------------

; [ load clouds backdrop graphics ]

LoadCloudsBackdropGfx:
@d4d3:  longa
        lda     f:WorldBackdropGfxPtr
        tay
        shorta
        lda     f:WorldBackdropGfxPtr+2
        jsr     Decompress
        jsr     _c3d518
        ldy     #$1a20
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$4000
        jsr     EndingTfrVRAM
        longa
        lda     f:WorldBackdropTilesPtr
        tay
        shorta
        lda     f:WorldBackdropTilesPtr+2
        jsr     Decompress
        ldy     #$2000
        sty     $ed
        jsr     _c3d518
        ldy     #$0400
        sty     $eb
        ldy     #$5000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [  ]

_c3d518:
@d518:  ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d522:
@d522:  jsr     LoadCreditsFontGfx
        jsr     InitCreditsGfxClouds
        jsr     _c3d6d6
        jsr     _c3d66b       ; load credits palette assignment (clouds/airship)
        jsr     _c3d552
        jsr     _c3d543
        jsr     _c3d634
        jsr     _c3d66b       ; load credits palette assignment (clouds/airship)
        jsr     _c3d562
        jsr     _c3d543
        jmp     _c3d64c

; ------------------------------------------------------------------------------

_c3d543:
@d543:  jsr     _c3d686
        ldx     #$fc1a      ; credits tilemap (clouds)
        stx     $f1
        lda     #$7e
        sta     $f3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d552:
@d552:  stz     $e4
        stz     $e5
        lda     #$80
        sta     $ed
        ldx     #$9800
        lda     #$7f
        jmp     _c3d74f

; ------------------------------------------------------------------------------

; [  ]

_c3d562:
@d562:  ldx     #$0080
        stx     $e4
        lda     #$80
        sta     $ed
        ldx     #$a800
        lda     #$7f
        jmp     _c3d74f

; ------------------------------------------------------------------------------

; [  ]

_c3d573:
@d573:  jsr     LoadCreditsFontGfx
        jsr     InitCreditsGfxLandSea
        jsr     _c3d6d6
        jmp     _d582

; ------------------------------------------------------------------------------

; [  ]

EndingAirshipScene:
@d57f:  jsr     InitCreditsGfxLandSea
_d582:  jsr     _c3d664       ; load credits palette assignment (land/sea)
        jsr     _c3d552
        jsr     _c3d59b       ; load credits tile layout (land)
        jsr     _c3d634
        jsr     _c3d664       ; load credits palette assignment (land/sea)
        jsr     _c3d562
        jsr     _c3d59b       ; load credits tile layout (land)
        jsr     _c3d64c
        rtl

; ------------------------------------------------------------------------------

; [  ]

_c3d59b:
@d59b:  jsr     _c3d675
        ldx     #$dd3a      ; credits tilemap (land)
        stx     $f1
        lda     #$7e
        sta     $f3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d5aa:
@d5aa:  jsr     LoadCreditsFontGfx
        jsr     InitCreditsGfxLandSea
        jsr     _c3d6d6
        jsr     _c3d664       ; load credits palette assignment (land/sea)
        jsr     _c3d552
        jsr     _c3d5cb
        jsr     _c3d634
        jsr     _c3d664       ; load credits palette assignment (land/sea)
        jsr     _c3d562
        jsr     _c3d5cb
        jmp     _c3d64c

; ------------------------------------------------------------------------------

; [  ]

_c3d5cb:
@d5cb:  jsr     _c3d67f
        ldx     #$2cfa      ; credits tilemap (sea)
        stx     $f1
        lda     #$7f
        sta     $f3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d5da:
@d5da:  jsr     LoadCreditsFontGfx
        jsr     InitCreditsGfxLandSea
        jsr     _c3d6d6
        jsr     _c3d664       ; load credits palette assignment (land/sea)
        jsr     _c3d552
        jsr     _c3d5fb
        jsr     _c3d634
        jsr     _c3d664       ; load credits palette assignment (land/sea)
        jsr     _c3d562
        jsr     _c3d5fb
        jmp     _c3d64c

; ------------------------------------------------------------------------------

; [  ]

_c3d5fb:
@d5fb:  jsr     _c3d686
        ldx     #$2cfa      ; credits tilemap (sea)
        stx     $f1
        lda     #$7f
        sta     $f3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d60a:
@d60a:  jsr     InitCreditsGfxClouds
        jsr     _c3d66b       ; load credits palette assignment (clouds/airship)
        jsr     _c3d552
        jsr     _c3d625
        jsr     _c3d634
        jsr     _c3d66b       ; load credits palette assignment (clouds/airship)
        jsr     _c3d562
        jsr     _c3d625
        jmp     _c3d64c

; ------------------------------------------------------------------------------

; [  ]

_c3d625:
@d625:  jsr     _c3d675
        ldx     #$041a      ; credits tilemap (airship)
        stx     $f1
        lda     #$7f
        sta     $f3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d634:
@d634:  ldy     #$b800
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$4000
        sty     $eb
        ldy     #$0000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [  ]

_c3d64c:
@d64c:  ldy     #$b800
        sty     $e7
        lda     #$7f
        sta     $e9
        stz     $ed
        stz     $ee
        ldy     #$4000
        sty     $eb
        ldy     #$2000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load credits palette assignments (land/sea) ]

_c3d664:
@d664:  ldx     #.loword(_cff9e1)      ; palette assignment
        lda     #^_cff9e1
        bra     _d670

; ------------------------------------------------------------------------------

; [ load credits palette assignments (airship/clouds) ]

_c3d66b:
@d66b:  ldx     #.loword(_cff969)      ; palette assignment
        lda     #^_cff969
_d670:  stx     $91
        sta     $93
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d675:
@d675:  ldx     #.loword(_cffae9)
        lda     #^_cffae9
_d67a:  stx     $f7
        sta     $f9
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d67f:
@d67f:  ldx     #.loword(_cffac9)
        lda     #^_cffac9
        bra     _d67a

; ------------------------------------------------------------------------------

; [  ]

_c3d686:
@d686:  ldx     #.loword(_cffaa9)
        lda     #^_cffaa9
        bra     _d67a

; ------------------------------------------------------------------------------

; [  ]

_c3d68d:
@d68d:  ldx     #.loword(_cffb09)
        lda     #^_cffb09
        bra     _d67a

; ------------------------------------------------------------------------------

; [ load credits graphics (land/sea) ]

InitCreditsGfxLandSea:
@d694:  jsr     LoadCreditsGfx
        ldx     #$141a      ; credits graphics (land/sea)
        stx     $e7
        lda     #$7f
        sta     $e9
        ldy     #$9800
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$18e0
        sty     $ef
        jmp     CopyCreditsGfx

; ------------------------------------------------------------------------------

; [ load credits graphics (clouds/airship) ]

InitCreditsGfxClouds:
@d6b1:  jsr     LoadCreditsGfx
        ldx     #$ed3a      ; credits graphics (clouds/airship)
        stx     $e7
        lda     #$7e
        sta     $e9
        ldy     #$9800
        sty     $eb
        lda     #$7f
        sta     $ed
        ldy     #$0ee0
        sty     $ef
        jmp     CopyCreditsGfx

; ------------------------------------------------------------------------------

; [ load ending credits graphics data ]

LoadCreditsGfx:
@d6ce:  ldy     #.loword(CreditsGfx)
        lda     #^CreditsGfx
        jmp     Decompress

; ------------------------------------------------------------------------------

; [  ]

_c3d6d6:
@d6d6:  ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$17ba      ; size = $17ba
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ copy data (ram -> ram) ]

; ++$e7: source address
; ++$eb: destination address
;  +$ef: size
;  +$f1: constant to add to each word

CopyCreditsGfx:
@d6ee:  stz     $f1
        stz     $f2
        longa
        ldy     $00
@d6f6:  lda     [$e7],y
        clc
        adc     $f1
        sta     [$eb],y
        iny2
        cpy     $ef
        bne     @d6f6
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d706:
@d706:  clr_ay
@d708:  longa
        lda     [$f7],y
        tax
        iny2
        lda     [$f7],y
        sta     $e7
        iny2
        shorta
        phy
        txy
        jsr     _c3d723
        ply
        cpy     #$0020
        bne     @d708
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d723:
@d723:  phb
        lda     #$7f
        pha
        plb
        lda     #$20
        sta     $e0
@d72c:  lda     #$20
        sta     $e1
        ldx     $e7
@d732:  lda     [$f1],y
        sta     $b800,x
        iny
        inx2
        dec     $e1
        bne     @d732
        longa_clc
        lda     $e7
        adc     #$0100
        sta     $e7
        shorta
        dec     $e0
        bne     @d72c
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d74f:
@d74f:  sta     $e9
        stx     $e7
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@d75a:  lda     #$08
        sta     $e6
@d75e:  longa
        ldy     #$0010
        lda     [$e7]
        sta     $f1
        lda     [$e7],y
        sta     $ef
        shorta0
        ldy     #$0008
@d771:  clr_a
        asl     $f0
        rol
        asl     $ef
        rol
        asl     $f2
        rol
        asl     $f1
        rol
        and     #$0f
        beq     @d792
        sta     $e0
        phy
        ldy     $e4
        lda     [$91],y
        ply
        asl4
        and     #$f0
        ora     $e0
@d792:  sta     $b801,x
        inx2
        dey
        bne     @d771
        ldy     $e7
        iny2
        sty     $e7
        dec     $e6
        bne     @d75e
        longa
        inc     $e4
        lda     $e7
        clc
        adc     #$0010
        sta     $e7
        shorta0
        dec     $ed
        bne     @d75a
        plb
        rts

; ------------------------------------------------------------------------------

; [ credits text thread (airship above water) ]

.proc CreditsTextTaskScene1
        phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #60
        bne     :+
        jsr     DrawCreditsTextScene1Page1
:       plb
        sec
        rts
.endproc  ; CreditsTextTaskScene1

; ------------------------------------------------------------------------------

; [ credits text thread (tiny airship) ]

.proc CreditsTextTaskScene2
        phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene2Page1
        bra     done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene2Page2
        bra     done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene2Page3
        bra     done
:       cpy     #$04f6
        bne     :+
        jsr     DrawCreditsTextScene2Page4
        bra     done
:       cpy     #$069a
        bne     :+
        jsr     DrawCreditsTextScene2Page5
        bra     done
:       cpy     #$083e
        bne     :+
        jsr     DrawCreditsTextScene2Page6
        bra     done
:       cpy     #$09e2
        bne     done
        jsr     DrawCreditsTextScene2Page7
done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene2

; ------------------------------------------------------------------------------

; [ credits text thread (boat) ]

.proc CreditsTextTaskScene3
        phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene3Page1
        bra     done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene3Page2
        bra     done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene3Page3
        bra     done
:       cpy     #$04f6
        bne     done
        jsr     DrawCreditsTextScene3Page4
done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene3

; ------------------------------------------------------------------------------

; [ credits text thread (airship/sea) ]

.proc CreditsTextTaskScene4
        phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene4Page1
        bra     done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene4Page2
        bra     done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene4Page3
        bra     done
:       cpy     #$04f6
        bne     :+
        jsr     DrawCreditsTextScene4Page4
        bra     done
:       cpy     #$069a
        bne     :+
        jsr     DrawCreditsTextScene4Page5
        bra     done
:       cpy     #$083e
        bne     :+
        jsr     DrawCreditsTextScene4Page6
        bra     done
:       cpy     #$09e2
        bne     done
        jsr     DrawCreditsTextScene4Page7
done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene4

; ------------------------------------------------------------------------------

; [ credits text thread (airship/land) ]

.proc CreditsTextTaskScene5
        phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene5Page1
        bra     done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene5Page2
        bra     done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene5Page3
        bra     done
:       cpy     #$04f6
        bne     :+
        jsr     DrawCreditsTextScene5Page4
        bra     done
:       cpy     #$069a
        bne     :+
        jsr     DrawCreditsTextScene5Page5
        bra     done
:       cpy     #$083e
        bne     :+
        jsr     DrawCreditsTextScene5Page6
        bra     done
:       cpy     #$09e2
        bne     done
        jsr     DrawCreditsTextScene5Page7
done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene5

; ------------------------------------------------------------------------------

; [ credits text thread (land) ]

.proc CreditsTextTaskScene6
        phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #4 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page1
        bra     done
:       cpy     #12 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page2
        bra     done
:       cpy     #20 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page3
        bra     done
:       cpy     #28 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page4
        bra     done
:       cpy     #36 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page5
        bra     done
:       cpy     #44 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page6
        bra     done
:       cpy     #52 * 60
        bne     done
        jsr     DrawCreditsTextScene6Page7
done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene6

; ------------------------------------------------------------------------------

; [ credits text thread (big airship) ]

.proc CreditsTextTaskScene7
@d933:  phb
        lda     #^*
        pha
        plb
        ldy     $cf
        cpy     #1 * 60
        bne     :+
        jsr     DrawCreditsTextScene7Page1
        bra     done
:       cpy     #8 * 60
        bne     :+
        jsr     DrawCreditsTextScene7Page2
        bra     done
:       cpy     #15 * 60
        bne     :+
        jsr     DrawCreditsTextScene7Page3
        bra     done
:       cpy     #22 * 60
        bne     :+
        jsr     DrawCreditsTextScene7Page4
        bra     done
:       cpy     #29 * 60
        bne     done
        jsr     DrawCreditsTextScene7Page5
done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene7

; ------------------------------------------------------------------------------

; [ draw credits text (airship above clouds) ]

LoadCreditsTextScene1:
@d96d:  ldx     #.loword(SmallCreditsTextPtrs1)      ; c2/9dc0 (producer)
        lda     #^SmallCreditsTextPtrs1
        ldy     #$0004      ; 1 string
        jsr     LoadSmallCreditsText
        ldx     #.loword(BigCreditsTextPtrs1)      ; c2/9c44 (hironobu sakaguchi)
        lda     #^BigCreditsTextPtrs1
        ldy     #$0008      ; 2 strings
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (tiny airship) ]

LoadCreditsTextScene2:
@d983:  ldx     #.loword(SmallCreditsTextPtrs2)
        lda     #^SmallCreditsTextPtrs2
        ldy     #$0028
        jsr     LoadSmallCreditsText
        ldx     #.loword(BigCreditsTextPtrs2)
        lda     #^BigCreditsTextPtrs2
        ldy     #$0060
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (boat) ]

LoadCreditsTextScene3:
@d999:  ldx     #.loword(SmallCreditsTextPtrs3)
        lda     #^SmallCreditsTextPtrs3
        ldy     #$0018
        jsr     LoadSmallCreditsText
        ldx     #.loword(BigCreditsTextPtrs3)
        lda     #^BigCreditsTextPtrs3
        ldy     #$0040
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (airship/sea) ]

LoadCreditsTextScene4:
@d9af:  ldx     #.loword(SmallCreditsTextPtrs4)
        lda     #^SmallCreditsTextPtrs4
        ldy     #$0020
        jsr     LoadSmallCreditsText
        ldx     #.loword(BigCreditsTextPtrs4)
        lda     #^BigCreditsTextPtrs4
        ldy     #$0064
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (airship/land) ]

LoadCreditsTextScene5:
@d9c5:  ldx     #.loword(SmallCreditsTextPtrs5)
        lda     #^SmallCreditsTextPtrs5
        ldy     #$0024
        jsr     LoadSmallCreditsText
        ldx     #.loword(BigCreditsTextPtrs5)
        lda     #^BigCreditsTextPtrs5
        ldy     #$0070
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (land) ]

LoadCreditsTextScene6:
@d9db:  ldx     #.loword(SmallCreditsTextPtrs6)
        lda     #^SmallCreditsTextPtrs6
        ldy     #$00e4
        jmp     LoadSmallCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (big airship) ]

LoadCreditsTextScene7:
@d9e6:  ldx     #.loword(SmallCreditsTextPtrs7)
        lda     #^SmallCreditsTextPtrs7
        ldy     #$006c
        jmp     LoadSmallCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (small font) ]

LoadSmallCreditsText:
@d9f1:  stx     $4a
        sta     $4c
        sty     $4d
        jmp     LoadSmallCreditsText2

; ------------------------------------------------------------------------------

; [ draw credits text (large font) ]

LoadBigCreditsText:
@d9fa:  stx     $4a
        sta     $4c
        sty     $4d
        jmp     LoadBigCreditsText2

; ------------------------------------------------------------------------------

; [ draw credits text ]

.macro make_draw_credits_sub _scene,_page
        .local _label, _sprites
        .define _label .ident(.sprintf("DrawCreditsTextScene%dPage%d", _scene, _page))
        .define _sprites .ident(.sprintf("CreditsSpritesScene%dPage%d", _scene, _page))
_label:
        ldy     #.sizeof(_sprites)
        ldx     #.loword(_sprites)
        lda     #^_sprites
        jmp     CreateCreditsPageTasks
.endmac

        make_draw_credits_sub 1,1

        make_draw_credits_sub 2,1
        make_draw_credits_sub 2,2
        make_draw_credits_sub 2,3
        make_draw_credits_sub 2,4
        make_draw_credits_sub 2,5
        make_draw_credits_sub 2,6
        make_draw_credits_sub 2,7

        make_draw_credits_sub 3,1
        make_draw_credits_sub 3,2
        make_draw_credits_sub 3,3
        make_draw_credits_sub 3,4

        make_draw_credits_sub 4,1
        make_draw_credits_sub 4,2
        make_draw_credits_sub 4,3
        make_draw_credits_sub 4,4
        make_draw_credits_sub 4,5
        make_draw_credits_sub 4,6
        make_draw_credits_sub 4,7

        make_draw_credits_sub 5,1
        make_draw_credits_sub 5,2
        make_draw_credits_sub 5,3
        make_draw_credits_sub 5,4
        make_draw_credits_sub 5,5
        make_draw_credits_sub 5,6
        make_draw_credits_sub 5,7

        make_draw_credits_sub 6,1
        make_draw_credits_sub 6,2
        make_draw_credits_sub 6,3
        make_draw_credits_sub 6,4
        make_draw_credits_sub 6,5
        make_draw_credits_sub 6,6
        make_draw_credits_sub 6,7

        make_draw_credits_sub 7,1
        make_draw_credits_sub 7,2
        make_draw_credits_sub 7,3
        make_draw_credits_sub 7,4
        make_draw_credits_sub 7,5

; ------------------------------------------------------------------------------

; [ create tasks for credits page sprites ]

;  A: source bank
; +X: source address
; +Y: word count * 4

CreateCreditsPageTasks:
@dba5:  sty     $fa
        stx     $f7
        sta     $f9
        ldy     $00
@dbad:  longa
        lda     [$f7],y                 ; sprite data address (+$7e0000)
        tax
        iny2
        lda     [$f7],y                 ; xy position
        sta     $60
        shorta
        phy
        txy
        jsr     CreateCreditsTextTask
        ply
        iny2                            ; next word
        cpy     $fa
        bne     @dbad
        sec
        rts

; ------------------------------------------------------------------------------

; [ load credits text (small font) ]

; ++$4a: source
;  +$4d: word count * 4

LoadSmallCreditsText2:
@dbc8:  ldy     $00
@dbca:  jsr     SetSmallCreditsSpriteFlags
        longa
        lda     [$4a],y     ; source
        tax
        iny2
        lda     [$4a],y     ; destination (+$7e0000)
        sta     $e7
        iny2
        phy
        ldy     $e7
        shorta
        jsr     LoadSmallCreditsWord
        ply
        cpy     $4d
        bne     @dbca
        rts

; ------------------------------------------------------------------------------

; [ load credits text (large font) ]

; ++$4a: source
;  +$4d: word count * 4

LoadBigCreditsText2:
@dbe8:  ldy     $00
@dbea:  jsr     SetBigCreditsSpriteFlags
        longa
        lda     [$4a],y     ; +X = source
        tax
        iny2
        lda     [$4a],y     ; +$e7 = destination (+$7e0000)
        sta     $e7
        iny2
        phy
        ldy     $e7
        shorta
        jsr     LoadBigCreditsWord
        ply
        cpy     $4d
        bne     @dbea
        rts

; ------------------------------------------------------------------------------

; [ set sprite tile flags for credits text (small font) ]

SetSmallCreditsSpriteFlags:
@dc08:  ldx     #$0b00      ; palette 2, tile offset $0300
        stx     $f1
        rts

; ------------------------------------------------------------------------------

; [ set sprite tile flags for credits text (big font) ]

SetBigCreditsSpriteFlags:
@dc0e:  ldx     #$0900      ; palette 2, tile offset $0100
        stx     $f1
        rts

; ------------------------------------------------------------------------------

; [ create credits text thread ]

; $60: x position
; $61: y position

CreateCreditsTextTask:
@dc14:  sty     $f1
        stz     $af
        lda     #0
        ldy     #.loword(CreditsTextTask)
        jsr     CreateTask
        longa
        lda     $f1
        sta     $7e32c9,x
        lda     #7*60
        sta     $7e3349,x               ; frame counter (7.0s)
        shorta
        lda     #$7e
        sta     $7e35ca,x
        lda     $60
        sta     $7e33ca,x
        lda     $61
        sta     $7e344a,x
        rts

; ------------------------------------------------------------------------------

; [ credits text thread ]

; creates sprites for one word of credits text
; sprites move up and fade in, wait, then fade out

CreditsTextTask:
@dc44:  tax
        jmp     (.loword(CreditsTextTaskTbl),x)

CreditsTextTaskTbl:
@dc48:  .addr   CreditsTextTask_00
        .addr   CreditsTextTask_01

; ------------------------------------------------------------------------------

; state 0: init
CreditsTextTask_00:
@dc4c:  ldx     $2d
        inc     $3649,x
        lda     $344a,x     ; y position
        clc
        adc     #$20
        sta     $344a,x
        longa
        lda     #$ff80
        sta     $3549,x     ; vertical speed
        stz     $34c9,x     ; horizontal speed
        shorta
        jsr     InitAnimTask
        lda     $af         ; branch if credits palette is already fading in
        bne     CreditsTextTask_01
        phb
        lda     #$00
        pha
        plb
        lda     $b4
        bne     @dc7c       ; branch if not using inverse credits palette
        jsr     _c3c703       ; fade in inverse credits palette
        bra     @dc7f
@dc7c:  jsr     _c3c72a       ; fade in normal credits palette
@dc7f:  lda     #1
        sta     $af         ; disable credits palette fade in
        plb

; state 1: update
CreditsTextTask_01:
@dc84:  ldx     $2d
        ldy     $3349,x     ; frame counter
        beq     @dca9
        cpy     #$0164      ; stop scrolling after 1.067s
        bne     @dc96
        stz     $3549,x
        stz     $354a,x
@dc96:  cpy     #$0080      ; start fade out after 4.867s
        beq     @dcab
@dc9b:  jsr     UpdateEndingAnimTask
        ldx     $2d
        longa
        dec     $3349,x
        shorta
        sec
        rts
@dca9:  clc
        rts
@dcab:  lda     $af
        beq     @dc9b       ; branch if credits palette is already fading out
        stz     $af
        phb
        lda     #$00
        pha
        plb
        jsr     FadeOutCreditsPal
        plb
        bra     @dc9b

; ------------------------------------------------------------------------------

; [ load word (small font) ]

LoadSmallCreditsWord:
@dcbc:  jsr     CalcCreditsWordLength
        jsr     InitCreditsString
@dcc2:  jsr     LoadSmallCreditsSprite
        bcc     @dcd0
        lda     $e0
        clc
        adc     #8                      ; increment x position
        sta     $e0
        bra     @dcc2
@dcd0:  rts

; ------------------------------------------------------------------------------

; [ load string (big font) ]

LoadBigCreditsWord:
@dcd1:  jsr     CalcCreditsWordLength
        jsr     InitCreditsString
@dcd7:  clr_a
        lda     [$e7]
        beq     @dd01                   ; branch if '\0'
        sta     $e3
        lda     $e0
        ora     #$80                    ; use a 16x16 sprite
        sta     [$eb],y                 ; x-position
        iny
        clr_a
        sta     [$eb],y                 ; y-position
        iny
        clr_a
        lda     $e3
        longa_clc
        adc     $f1
        sta     [$eb],y                 ; vhoopppm mmmmmmmm
        inc     $e7
        iny2
        shorta
        lda     $e0
        clc
        adc     #8                      ; increment x position
        sta     $e0
        bra     @dcd7
@dd01:  rts

; ------------------------------------------------------------------------------

; [ load letter (small font) ]

LoadSmallCreditsSprite:
@dd02:  clr_a
        lda     [$e7]                   ; letter tile
        beq     @dd23                   ; branch if terminator
        sta     $e3
        lda     $e0
        sta     [$eb],y                 ; x position
        iny
        clr_a
        sta     [$eb],y                 ; y position
        iny
        clr_a
        lda     $e3
        longa_clc
        adc     $f1                     ; set tile flags
        sta     [$eb],y                 ; vhoopppm mmmmmmmm
        inc     $e7
        iny2
        shorta
        sec
        rts
@dd23:  clc                             ; clear carry if '\0'
        rts

; ------------------------------------------------------------------------------

; [ init string ]

InitCreditsString:
@dd25:  ldy     $00
        sta     [$eb],y     ; string length
        iny
        stz     $e0         ; x-position
        stz     $ef
        stz     $f0
        rts

; ------------------------------------------------------------------------------

; [ get word length ]

CalcCreditsWordLength:
@dd31:  stx     $e7
        lda     #^CreditsText
        sta     $e9
        sty     $eb
        lda     #$7e
        sta     $ed
        longa_clc
        lda     $eb
        adc     #$0003
        sta     [$eb]
        inc     $eb
        inc     $eb
        shorta
        lda     #$fe
        sta     [$eb]
        inc     $eb
        ldy     $00
        tyx
@dd55:  lda     [$e7],y     ; find the end of the string
        iny
        cmp     #0
        beq     @dd5f
        inx
        bra     @dd55
@dd5f:  txa
        rts

; ------------------------------------------------------------------------------

; [ decompress ]

; +Y: source address
;  A: source bank

Decompress:
@dd61:  sty     $f3
        sta     $f5
        ldy     #$c000      ; destination = $7ec000
        sty     $f6
        lda     #$7e
        sta     $f8
        jsl     Decompress_ext
        rts

; ------------------------------------------------------------------------------

; [ clear vram ]

ClearVRAM:
@dd73:  longa
        clr_a
        sta     hVMADDL
        tay
@dd7a:  sta     hVMDATAL
        iny
        cpy     #$8000
        bne     @dd7a
        shorta
        rts

; ------------------------------------------------------------------------------

; [ copy graphics to vram (2bpp -> 4bpp) ]

;    +Y: vram address
; ++$e7: source
;  +$eb: size

TfrGfx2bpp:
@dd86:  sty     hVMADDL
        clr_ay
        longa
@dd8d:  ldx     #8
@dd90:  lda     [$e7],y     ; copy first 8 words
        sta     hVMDATAL
        iny2
        dex
        bne     @dd90
.repeat 8
        stz     hVMDATAL      ; clear 8 words (high bitplanes)
.endrep
        cpy     $eb
        bne     @dd8d
        shorta
        rts

; ------------------------------------------------------------------------------

; [ copy data/graphics to vram ]

;    +Y: vram address
; ++$e7: source
;  +$eb: size
;  +$ed: constant to add to each copied word

EndingTfrVRAM:
@ddb9:  longa
        tya
        sta     hVMADDL
        clr_ay
@ddc1:  lda     [$e7],y
        clc
        adc     $ed
        sta     hVMDATAL
        iny2
        cpy     $eb
        bne     @ddc1
        shorta
        rts

; ------------------------------------------------------------------------------

; [ update hdma data for mode 7 variables ]

UpdateMode7HDMA:
@ddd2:  phb
        lda     #$00
        pha
        plb
        longa
        lda     $c3
        jsr     CalcCosine
        sta     $e0
        sta     $eb
        lda     $e0
        bpl     @ddea
        eor     #$ffff
        inc
@ddea:  sta     $e0
        lsr
        sta     $cb
        lda     $c3
        jsr     CalcSine
        sta     $e0
        sta     $ed
        lda     $e0
        bpl     @de00
        eor     #$ffff
        inc
@de00:  sta     $e0
        lsr
        sta     $c9
        ldy     #$01be
        lda     $c5
        sta     $e7
@de0c:  lda     $cb
        sta     hWRDIVL
        shorta
        lda     $e8
        sta     hWRDIVB
        nop5
        longa
        lda     $eb
        bpl     @de2c
        lda     hRDDIVL
        eor     #$ffff
        inc
        bra     @de2f
@de2c:  lda     hRDDIVL
@de2f:  sta     $0602,y     ; m7a and m7d
        sta     $0604,y
        lda     $c9
        sta     hWRDIVL
        shorta
        lda     $e8
        sta     hWRDIVB
        nop2
        longa
        lda     $e7
        sec
        sbc     $c7
        sta     $e7
        lda     $ed
        bpl     @de59
        lda     hRDDIVL
        eor     #$ffff
        inc
        bra     @de5c
@de59:  lda     hRDDIVL
@de5c:  sta     $07c4,y     ; m7b
        sta     $07c6,y
        eor     #$ffff
        inc
        sta     $0986,y     ; m7c
        sta     $0988,y
        dey4
        bpl     @de0c
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ +A = cos(A) ]

CalcCosine:
        .a16
@de76:  clc
        adc     #$0040
; fallthrough

; ------------------------------------------------------------------------------

; [ +A = sin(A) ]

CalcSine:
@de7a:  and     #$00ff
        asl
        tax
        lda     f:SineTbl16,x
        rts
        .a8

; ------------------------------------------------------------------------------

; [ generic animation thread w/ counter ]

_c3de84:
@de84:  tax
        jmp     (.loword(_c3de88),x)

_c3de88:
@de88:  .addr   _c3de8c, _c3de94

; ------------------------------------------------------------------------------

_c3de8c:
@de8c:  ldx     $2d
        inc     $3649,x
        jsr     InitAnimTask

_c3de94:
@de94:  ldx     $2d
        ldy     $3349,x     ; terminate thread when counter reaches zero
        beq     @dea9
        jsr     UpdateEndingAnimTask
        ldx     $2d
        longa
        dec     $3349,x     ; decrement counter
        shorta
        sec
        rts
@dea9:  clc
        rts

; ------------------------------------------------------------------------------

; [ generic ending animation task ]

EndingAnimTask:
@deab:  tax
        jmp     (.loword(EndingAnimTaskTbl),x)

EndingAnimTaskTbl:
@deaf:  .addr   EndingAnimTask_00
        .addr   EndingAnimTask_01

; ------------------------------------------------------------------------------

EndingAnimTask_00:
@deb3:  ldx     $2d
        inc     $3649,x
        jsr     InitAnimTask

EndingAnimTask_01:
@debb:  jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update animation thread position ]

UpdateEndingAnimTask:
@dec0:  ldx     $2d

; move horizontally
        longa_clc
        lda     $33c9,x
        adc     $34c9,x
        sta     $33c9,x

; move vertically
        lda     $3449,x
        clc
        adc     $3549,x
        sta     $3449,x
        shorta

; update animation and draw sprites
        jsr     UpdateAnimTask
        rts

; ------------------------------------------------------------------------------

; [ large text thread ]

EndingBigTextTask:
@dedd:  sta     $e0
        lda     $47
        bne     @dee9
        lda     $e0
        tax
        jmp     (.loword(EndingBigTextTaskTbl),x)
@dee9:  clc
        rts

EndingBigTextTaskTbl:
@deeb:  .addr   EndingBigTextTask_00
        .addr   EndingBigTextTask_01
        .addr   EndingBigTextTask_02
        .addr   EndingBigTextTask_03
        .addr   EndingBigTextTask_04
        .addr   EndingBigTextTask_05
        .addr   EndingBigTextTask_06
        .addr   EndingBigTextTask_07
        .addr   EndingBigTextTask_08

; ------------------------------------------------------------------------------

; state 8: terminate
EndingBigTextTask_08:
@defd:  clc
        rts

; state 0: init
EndingBigTextTask_00:
@deff:  ldx     $2d
        inc     $3649,x
        longa
        stz     $3549,x
        lda     $85
        sta     $3349,x
        shorta
        jsr     InitAnimTask
; fall through

; state 1/3/5/7: wait
EndingBigTextTask_01:
EndingBigTextTask_03:
EndingBigTextTask_05:
EndingBigTextTask_07:
_df13:  jsr     _c3df4b       ; decrement animation thread movement counter
        jsr     UpdateEndingAnimTask
        sec
        rts

; state 2: move up (2.5 seconds)
EndingBigTextTask_02:
@df1b:  ldy     #$ffc0
        ldx     #$0096
        bra     _df32

; state 4: don't move (4 seconds)
EndingBigTextTask_04:
@df23:  ldy     $00
        ldx     #$00f0
        bra     _df32

; state 6: move up (6 seconds)
EndingBigTextTask_06:
@df2a:  ldy     #$ffc0
        ldx     #$012c
        bra     _df32

_df32:  sty     $e7
        stx     $e9
        ldx     $2d
        longa
        lda     $e7
        sta     $3549,x     ; vertical movement speed
        lda     $e9
        sta     $3349,x     ; movement counter
        shorta
        inc     $3649,x     ; increment state
        bra     _df13

; ------------------------------------------------------------------------------

; [ decrement animation thread movement counter ]

_c3df4b:
@df4b:  ldx     $2d
        longa
        lda     $3349,x     ; movement counter
        bne     @df59
        inc     $3649,x     ; thread state
        bra     @df5c
@df59:  dec     $3349,x
@df5c:  shorta
        rts

; ------------------------------------------------------------------------------

; [ draw character name ]

DrawEndingCharName:
@df5f:  ldy     $00
@df61:  sty     $eb
        longa
        tya
        asl
        tax
        lda     f:CharPropPtrs,x   ; pointers to character data
        tay
        shorta
        lda     $0000,y
        cmp     $28         ; compare character index
        beq     @df99
        longa_clc
        lda     #$0025
        adc     $e7
        sta     $e7
        shorta
        ldy     $eb
        iny
        cpy     #$0010
        bne     @df61
        ldx     $00
        lda     #$bf
@df8d:  sta     $7e9e89,x
        inx
        cpx     #$0006
        bne     @df8d
        bra     @dfa9
@df99:  ldx     $00
@df9b:  lda     $0002,y     ; character name
        sta     $7e9e89,x
        iny
        inx
        cpx     #6
        bne     @df9b
@dfa9:  jsr     _c3dfb3
        jsr     _c3a611
        jsr     _c3a63b
        rts

; ------------------------------------------------------------------------------

; [ calculate character name position ]

_c3dfb3:
@dfb3:  ldx     $00
        stz     $e0
        stz     $e1
@dfb9:  clr_a
        lda     $7e9e89,x
        cmp     #$ff
        beq     @dfd7
        phx
        sec
        sbc     #$60
        tax
        lda     $c48fc0,x   ; letter width
        clc
        adc     $e0
        sta     $e0
        plx
        inx
        cpx     #$0006
        bne     @dfb9
@dfd7:  longa
        lda     $e0
        lsr
        sta     $e0
        lda     #$0080
        sec
        sbc     $e0
        eor     #$ffff
        inc
        sta     $3d
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create bg1 h-scroll thread ]

; +Y: scroll counter

_c3dfed:
@dfed:  sty     $f3
        lda     #0
        ldy     #.loword(_c3e002)
        jsr     CreateTask
        longa
        lda     $f3
        sta     $7e3349,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ bg1 h-scroll thread ]

_c3e002:
@e002:  ldx     $2d
        longa
        lda     $3349,x
        beq     @e01e
        dec     $3349,x
        shorta
        lda     $23
        and     #$03
        bne     @e01c
        longa
        inc     $35
        shorta
@e01c:  sec
        rts
@e01e:  shorta
        clc
        rts

; ------------------------------------------------------------------------------

; [ create character full name thread ]

CreateBigCharNameTask:
@e022:  clr_a
        lda     $28         ; character index
        asl2
        sta     $e0
        lda     $28
        asl
        clc
        adc     $e0
        tax
        longa
        lda     f:EndingCharNameAnim,x   ; pointer to animation data (+$c20000)
        sta     $4d
        shorta
        lda     f:EndingCharNameAnim+2,x   ; x position
        sta     $53
        longa
        lda     f:EndingCharNameAnim+3,x   ; pointer to animation data (+$c20000)
        sta     $4f
        shorta
        lda     f:EndingCharNameAnim+5,x   ; x position
        sta     $54
        jsr     CreateEndingBigTextTask
        longa
        lda     $4d
        sta     $7e32c9,x
        shorta
        lda     #^EndingCharNameAnim
        sta     $7e35ca,x
        lda     $53
        sta     $7e33ca,x
        lda     #$d0
        sta     $7e344a,x   ; y position = $d0
        jsr     CreateEndingBigTextTask
        longa
        lda     $4f
        sta     $7e32c9,x
        shorta
        lda     #^EndingCharNameAnim
        sta     $7e35ca,x
        lda     $54
        sta     $7e33ca,x
        lda     #$d0
        sta     $7e344a,x   ; y position = $d0
        rts

; ------------------------------------------------------------------------------

; [ create large text thread ]

CreateEndingBigTextTask:
@e08f:  lda     #1
        ldy     #.loword(EndingBigTextTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create "and you" text thread ]

_c3e098:
@e098:  jsr     CreateEndingBigTextTask
        longa
        lda     #.loword(AndYouAnim)
        sta     $7e32c9,x
        shorta
        lda     #^AndYouAnim
        sta     $7e35ca,x
        lda     #$68        ; x position = $68
        sta     $7e33ca,x
        lda     #$d0        ; y position = $d0
        sta     $7e344a,x
        rts

; ------------------------------------------------------------------------------

; [ init ending graphics & palettes ]

; A: character index

InitEndingGfx:
@e0b9:  sta     $28         ; character index
        jsl     InitHWRegsEnding
        jsr     ClearBG3ScreenA
        jsr     ClearBG2ScreenA
        lda     #^BlackPal
        ldy     #$3049      ; bg palette 0
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$3069      ; bg palette 1
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$3089      ; bg palette 2
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$30e9      ; bg palette 5
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$3109      ; bg palette 6
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$3149      ; sprite palette 0
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$3169      ; sprite palette 1
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #$31c9      ; sprite palette 3
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        jsr     LoadEndingFontGfx
        jmp     LoadEndingBGGfx

; ------------------------------------------------------------------------------

; [ draw character credits text ]

DrawEndingCharText:
@e123:  stz     $47
        jsr     CreateEndingCharAsTask
        lda     #$2c        ; palette 3, high priority
        sta     $29
        jsr     DrawEndingCharName
        lda     #$01
        trb     $45
        jsr     TfrVRAM2
        lda     #$01
        tsb     $45         ; enable dma at next vblank
        jsr     CreateBigCharNameTask

_c3e13d:
@e13d:  jsr     _c3ef21       ; set up dma
        inc     $26         ; next cinematic state
        jmp     EndingWaitVblank

; ------------------------------------------------------------------------------

; [ fade out ending bg palettes ]

_c3e145:
@e145:  lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$30e9      ; bg palette 5
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$3109      ; bg palette 6
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask

_c3e16b:
@e16b:  lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$3069      ; bg palette 1
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$3089      ; bg palette 2
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade in ending bg palettes ]

_c3e192:
@e192:  lda     #^_c2967c
        sta     $ed
        lda     #2
        ldy     #$3069      ; bg palette 1
        sty     $e7
        ldx     #.loword(_c2967c)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^_c2969c
        sta     $ed
        lda     #2
        ldy     #$3089      ; bg palette 2
        sty     $e7
        ldx     #.loword(_c2969c)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^_c296dc
        sta     $ed
        lda     #2
        ldy     #$30e9      ; bg palette 5
        sty     $e7
        ldx     #.loword(_c296dc)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^_c296fc
        sta     $ed
        lda     #2
        ldy     #$3109      ; bg palette 6
        sty     $e7
        ldx     #.loword(_c296fc)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3e1df:
@e1df:  lda     #^_c29754
        sta     $ed
        lda     #4
        ldy     #$3049      ; bg palette 0
        sty     $e7
        ldx     #.loword(_c29754)
        stx     $eb
        jsr     CreateFadePalTask
        lda     #^_c29754
        sta     $ed
        lda     #$04
        ldy     #$3169      ; sprite palette 1
        sty     $e7
        ldx     #.loword(_c29754)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3e206:
@e206:  stz     $cf
        stz     $d0
        ldy     #$00f0
        sty     $64
        lda     #0
        ldy     #.loword(_c3d1b6)      ; scroll bg3 down thread
        jsr     CreateTask
        jsr     _c3e241
        lda     #^BlackPal
        sta     $ed
        lda     #4
        ldy     #$3169
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask

_c3e22d:
@e22d:  lda     #^_c29754
        sta     $ed
        lda     #4
        ldy     #$3149
        sty     $e7
        ldx     #.loword(_c29754)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade out background palette 0 ]

_c3e241:
@e241:  lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$3049
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade out sprite palette 0 ]

_c3e255:
@e255:  lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$3149
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ exit ending cutscene ]

ExitEnding:
@e269:  lda     #$ff
        sta     $26
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $28: shadow 1 ]

EndingState_28:
@e26e:  lda     #$03        ; character 3
        jsr     InitEndingGfx
        jsr     _c3ef48
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     InitShadowAppleAnim
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

_c3e28a:
@e28a:  lda     #^_c29774
        sta     $ed
        lda     #$02
        ldy     #$31c9      ; sprite palette 2
        sty     $e7
        ldx     #.loword(_c29774)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

_c3e29e:
@e29e:  lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$31c9
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $29: shadow 2 ]

EndingState_29:
@e2b2:  ldy     $20
        bne     @e2c0
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e2c0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2a: shadow 3 ]

EndingState_2a:
@e2c1:  ldy     $20
        bne     @e2cf
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e2cf:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2b: shadow 4 ]

EndingState_2b:
@e2d0:  ldy     $20
        bne     @e2e6
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e2e6:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $38: fade out (character credits) ]

EndingState_38:
@e2e7:  ldy     $20
        bne     @e2f7
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        lda     #$01        ; cinematic state $01 (wait for fade out)
        sta     $26
        jsr     _c3e255
@e2f7:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $32: cyan 1 ]

EndingState_32:
@e2f8:  lda     #$02        ; character 2
        jsr     InitEndingGfx
        jsr     _c3ef68
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e468
        ldy     #$ffb8
        sty     $35
        jsr     _c3e839
        jsr     InitCyanSwordAnim
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $33: cyan 2 ]

EndingState_33:
@e319:  ldy     $20
        bne     @e327
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e327:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $34: cyan 3 ]

EndingState_34:
@e328:  ldy     $20
        bne     @e336
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e336:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $35: cyan 4 ]

EndingState_35:
@e337:  ldy     $20
        bne     @e34a
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e34a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $40: edgar/sabin 1 ]

EndingState_40:
@e34b:  lda     #$04        ; character 4
        jsr     InitEndingGfx
        jsr     _c3ef7e       ; load coin graphics (sprite)
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     InitCoinAnim
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $41: edgar/sabin 2 ]

EndingState_41:
@e364:  ldy     $20
        bne     @e372
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e372:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $42: edgar/sabin 3 ]

EndingState_42:
@e373:  ldy     $20
        bne     @e381
        inc     $26
        jsr     _c3e206
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e381:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $43: edgar/sabin 4 ]

EndingState_43:
@e382:  ldy     $20
        bne     @e3a1
        ldy     $00
        sty     $3f
        lda     #$05        ; character 5
        sta     $28
        jsr     CreateEndingCharAsTask
        jsr     _c3e255
        jsr     DrawEndingCharName
        jsr     _c3e1df
        inc     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
@e3a1:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $44: edgar/sabin 5 ]

EndingState_44:
@e3a2:  ldy     $20
        bne     @e3b1
        lda     #$01
        sta     $47
        inc     $26
        ldy     #$00b4      ; wait 3 seconds
        sty     $20
@e3b1:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $45: edgar/sabin 6 ]

EndingState_45:
@e3b2:  ldy     $20
        bne     @e3cc
        lda     #$4f
        sta     $26
        ldy     #3*60      ; wait 3 seconds
        sty     $20
        stz     $47
        ldy     #$0014
        sty     $85
        jsr     CreateBigCharNameTask
        jsr     _c3e206
@e3cc:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4f: edgar/sabin 7 ]

EndingState_4f:
@e3cd:  ldy     $20
        bne     @e3e0
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e3e0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $3c: mog 1 ]

EndingState_3c:
@e3e1:  lda     #$0a        ; character 10
        jsr     InitEndingGfx
        jsr     _c3efa2
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        jsr     _c3ea24
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $3d: mog 2 ]

EndingState_3d:
@e3fd:  ldy     $20
        bne     @e40b
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e40b:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $3e: mog 3 ]

EndingState_3e:
@e40c:  ldy     $20
        bne     @e41a
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e41a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $3f: mog 4 ]

EndingState_3f:
@e41b:  ldy     $20
        bne     @e431
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e431:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $46: gogo 1 ]

EndingState_46:
@e432:  lda     #$0c        ; character 12
        jsr     InitEndingGfx
        jsr     _c3efb8
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e839
        jsr     _c3e9e4
        lda     #2
        ldy     #.loword(_c3e49f)
        jsr     CreateTask
        lda     #$b4
        lda     $7e3349,x
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $47: gogo 2 ]

EndingState_47:
@e459:  ldy     $20
        bne     @e467
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e467:  rts

; ------------------------------------------------------------------------------

_c3e468:
@e468:  lda     #^_c2955c
        sta     $ed
        lda     #1
        ldy     #$31c9
        sty     $e7
        ldx     #.loword(_c2955c)
        stx     $eb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $48: gogo 3 ]

EndingState_48:
@e47c:  ldy     $20
        bne     @e48a
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e48a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $49: gogo 4 ]

EndingState_49:
@e48b:  ldy     $20
        bne     @e49e
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e49e:  rts

; ------------------------------------------------------------------------------

_c3e49f:
@e49f:  tax
        jmp     (.loword(_c3e4a3),x)

_c3e4a3:
@e4a3:  .addr   _c3e4ab, _c3e4ba, _c3e4ab, _c3e4df

; ------------------------------------------------------------------------------

_c3e4ab:
@e4ab:  ldx     $2d
        lda     $3349,x
        bne     @e4b5
        inc     $3649,x
@e4b5:  dec     $3349,x
        sec
        rts

_c3e4ba:
@e4ba:  phb
        lda     #$00
        pha
        plb
        lda     #^_c2957c
        sta     $ed
        lda     #1
        ldy     #$31c9
        sty     $e7
        ldx     #.loword(_c2957c)
        stx     $eb
        jsr     CreateFadePalTask
        plb
        ldx     $2d
        lda     #$3c
        sta     $3349,x
        inc     $3649,x
        sec
        rts

_c3e4df:
@e4df:  phb
        lda     #$00
        pha
        plb
        lda     #^BlackPal
        sta     $ed
        lda     #$01
        ldy     #$31c9
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
        plb
        clc
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $50: gau 1 ]

EndingState_50:
@e4fa:  lda     #$0b        ; character 11
        jsr     InitEndingGfx
        jsr     _c3efce
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $51: gau 2 ]

EndingState_51:
@e513:  ldy     $20
        bne     @e521
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e521:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $52: gau 3 ]

EndingState_52:
@e522:  ldy     $20
        bne     @e533
        inc     $26
        jsr     InitGauEyesAnim
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e533:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $53: gau 4 ]

EndingState_53:
@e534:  ldy     $20
        bne     @e54a
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e54a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $5a: terra 1 ]

EndingState_5a:
@e54b:  lda     #$00        ; character 0
        jsr     InitEndingGfx
        jsr     _c3efe4
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e468
        jsr     _c3e83f
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $5b: terra 2 ]

EndingState_5b:
@e564:  ldy     $20
        bne     @e572
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e572:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $5c: terra 3 ]

EndingState_5c:
@e573:  ldy     $20
        bne     @e584
        inc     $26
        jsr     _c3ea03
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e584:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $5d: terra 4 ]

EndingState_5d:
@e585:  ldy     $20
        bne     @e59b
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e59b:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $64: locke/celes 1 ]

EndingState_64:
@e59c:  lda     #$01        ; character 1
        jsr     InitEndingGfx
        jsr     _c3effa
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e83f
        ldy     #$ffe0
        sty     $35
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $65: locke/celes 2 ]

EndingState_65:
@e5b7:  ldy     $20
        bne     @e5c5
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e5c5:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $66: locke/celes 3 ]

EndingState_66:
@e5c6:  ldy     $20
        bne     @e5d4
        inc     $26
        jsr     _c3e206
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e5d4:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $67: locke/celes 4 ]

EndingState_67:
@e5d5:  ldy     $20
        bne     @e5f4
        ldy     $00
        sty     $3f
        lda     #$06        ; character 6
        sta     $28
        jsr     CreateEndingCharAsTask
        jsr     _c3e255
        jsr     DrawEndingCharName
        jsr     _c3e1df
        inc     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
@e5f4:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $68: locke/celes 5 ]

EndingState_68:
@e5f5:  ldy     $20
        bne     @e604
        lda     #$01
        sta     $47
        inc     $26
        ldy     #$00b4      ; wait 3 seconds
        sty     $20
@e604:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $69: locke/celes 6 ]

EndingState_69:
@e605:  ldy     $20
        bne     @e61d
        inc     $26
        ldy     #3*60      ; wait 3 seconds
        sty     $20
        stz     $47
        ldy     #$0014
        sty     $85
        jsr     CreateBigCharNameTask
        jsr     _c3e206
@e61d:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $6a: locke/celes 7 ]

EndingState_6a:
@e61e:  ldy     $20
        bne     @e634
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e634:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $6e: relm 1 ]

EndingState_6e:
@e635:  lda     #$08        ; character 8
        jsr     InitEndingGfx
        jsr     _c3f00d
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e468
        jsr     _c3e83f
        jsr     InitRelmBrushAnim
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $6f: relm 2 ]

EndingState_6f:
@e651:  ldy     $20
        bne     @e65f
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e65f:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $70: relm 3 ]

EndingState_70:
@e660:  ldy     $20
        bne     @e66e
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e66e:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $71: relm 4 ]

EndingState_71:
@e66f:  ldy     $20
        bne     @e685
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e685:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $78: strago 1 ]

EndingState_78:
@e686:  lda     #$07        ; character 7
        jsr     InitEndingGfx
        jsr     _c3f023
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3ed7f
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $79: strago 2 ]

EndingState_79:
@e69c:  ldy     $20
        bne     @e6aa
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e6aa:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $7a: strago 3 ]

EndingState_7a:
@e6ab:  ldy     $20
        bne     @e6b9
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e6b9:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $7b: strago 4 ]

EndingState_7b:
@e6ba:  ldy     $20
        bne     @e6cd
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e6cd:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2d: book 1 ]

EndingState_2d:
@e6ce:  jsr     InitEndingGfx
        jsr     _c3f023
        jsr     _c3e192       ; fade in ending bg palettes
        ldy     #$02d0      ; wait 12 seconds
        sty     $20
        jmp     _c3e13d

; ------------------------------------------------------------------------------

; [ cinematic state $2e: book 2 ]

EndingState_2e:
@e6df:  ldy     $20
        bne     @e6ed
        inc     $26
        jsr     _c3ed94
        ldy     #$01e0      ; wait 8 seconds
        sty     $20
@e6ed:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2f: book 3 ]

EndingState_2f:
@e6ee:  ldy     $20
        bne     @e6f9
        inc     $26
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e6f9:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $30: book 4 ]

EndingState_30:
@e6fa:  ldy     $20
        bne     @e710
        lda     #$38
        sta     $26
        jsr     CreateEndingMosaicTask
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e845
@e710:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4a: "and you" 1 ]

EndingState_4a:
@e711:  jsr     InitEndingGfx
        jsr     _c3f023
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3eda9
        ldy     #$00b4      ; wait 3 seconds
        sty     $20
        stz     $47
        jsr     _c3e098       ; create "and you" thread
        jmp     _c3e13d

; ------------------------------------------------------------------------------

; [ cinematic state $4b: "and you" 2 ]

EndingState_4b:
@e72a:  ldy     $20
        bne     @e735
        inc     $26
        ldy     #$00ec      ; wait 3.9 seconds
        sty     $20
@e735:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4c: "and you" 3 ]

EndingState_4c:
@e736:  ldy     $20
        bne     @e748
        lda     #$01
        sta     $99
        inc     $26
        ldy     #$016c      ; wait 6.1 seconds
        sty     $20
        jsr     _c3e22d
@e748:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4d: "and you" 4 ]

EndingState_4d:
@e749:  ldy     $20
        bne     @e75c
        lda     #$38
        sta     $26
        jsr     CreateEndingMosaicTask
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
@e75c:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $82: setzer 1 ]

EndingState_82:
@e75d:  lda     #$09        ; character 9
        jsr     InitEndingGfx
        jsr     _c3f036       ; load ending sprite graphics 3
        jsr     _c3e192       ; fade in ending bg palettes
        lda     #^BlackPal
        ldy     #$3189
        ldx     #.loword(BlackPal)
        jsr     LoadPal
        lda     #^_c29774
        sta     $ed
        lda     #2
        ldy     #$3189
        sty     $e7
        ldx     #.loword(_c29774)
        stx     $eb
        jsr     CreateFadePalTask
        jsr     _c3e839
        jsr     InitSetzerCardsAnim
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $83: setzer 2 ]

EndingState_83:
@e794:  ldy     $20
        bne     @e7a2
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e7a2:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $84: setzer 3 ]

EndingState_84:
@e7a3:  ldy     $20
        bne     @e7b1
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 6 seconds
        sty     $20
@e7b1:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $85: setzer 4 ]

EndingState_85:
@e7b2:  ldy     $20
        bne     @e7c0
        inc     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
@e7c0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $86: setzer 5 ]

EndingState_86:
@e7c1:  ldy     $20
        bne     @e7e4
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        lda     #$01
        sta     $26
        jsr     _c3e255
        lda     #^BlackPal
        sta     $ed
        lda     #$04
        ldy     #$3189
        sty     $e7
        ldx     #.loword(BlackPal)
        stx     $eb
        jsr     CreateFadePalTask
@e7e4:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $87: umaro 1 ]

EndingState_87:
@e7e5:  lda     #$0d        ; character 13
        jsr     InitEndingGfx
        jsr     _c3f072       ; load skull graphics (sprite)
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        jsr     InitUmaroSkullAnim
        jsr     _c3ea7c       ; create walking mini-mog threads
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $88: umaro 2 ]

EndingState_88:
@e804:  ldy     $20
        bne     @e812
        inc     $26
        jsr     _c3e1df
        ldy     #$00f0      ; wait 4 seconds
        sty     $20
@e812:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $89: umaro 3 ]

EndingState_89:
@e813:  ldy     $20
        bne     @e821
        inc     $26
        jsr     _c3e206
        ldy     #$0168      ; wait 12 seconds
        sty     $20
@e821:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $8a: umaro 4 ]

EndingState_8a:
@e822:  ldy     $20
        bne     @e838
        lda     #$38
        sta     $26
        ldy     #$0078      ; wait 2 seconds
        sty     $20
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e838:  rts

; ------------------------------------------------------------------------------

; [ h-scroll bg1 1200 pixels ]

_c3e839:
@e839:  ldy     #$04b0
        jmp     _c3dfed       ; create bg1 h-scroll thread

; ------------------------------------------------------------------------------

; [ h-scroll bg1 312 pixels ]

_c3e83f:
@e83f:  ldy     #$0138
        jmp     _c3dfed       ; create bg1 h-scroll thread

; ------------------------------------------------------------------------------

; [ h-scroll bg1 180 pixels ]

_c3e845:
@e845:  ldy     #$00b4
        jmp     _c3dfed       ; create bg1 h-scroll thread

; ------------------------------------------------------------------------------

; [ create screen mosaic thread ]

CreateEndingMosaicTask:
@e84b:  clr_a
        ldy     #.loword(EndingMosaicTask)
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ screen mosaic thread ]

EndingMosaicTask:
@e852:  tax
        jmp     (.loword(EndingMosaicTaskTbl),x)

EndingMosaicTaskTbl:
@e856:  .addr   EndingMosaicTask_00
        .addr   EndingMosaicTask_01

; ------------------------------------------------------------------------------

EndingMosaicTask_00:
@e85a:  ldx     $2d
        inc     $3649,x     ; increment thread state
        stz     $33ca,x
        stz     $3349,x

EndingMosaicTask_01:
@e865:  ldx     $2d
        lda     $3349,x     ; decrement counter
        beq     @e871
        dec     $3349,x
        sec
        rts
@e871:  lda     $33ca,x
        ora     #$0f
        sta     $b5         ; screen mosaic
        ldx     $2d
        lda     $33ca,x
        clc
        adc     #$10
        sta     $33ca,x
        lda     #$10
        sta     $3349,x
        sec
        rts

; ------------------------------------------------------------------------------

; unused

@e88a:  lda     $23
        and     #$03
        bne     @e896
        longa
        inc     $35
        shorta
@e896:  rts

; ------------------------------------------------------------------------------

; [ create "as" thread ]

CreateEndingCharAsTask:
@e897:  lda     #3
        ldy     #.loword(_c3de84)      ; generic animation thread w/ counter
        jsr     CreateTask
        longa
        lda     #.loword(EndingCharAsAnim)
        sta     $7e32c9,x
        lda     #10*60      ; terminate after 10 seconds
        sta     $7e3349,x
        shorta
        lda     #^EndingCharAsAnim
        sta     $7e35ca,x
        lda     #$79
        sta     $7e33ca,x   ; x = $79
        lda     #$c0
        sta     $7e344a,x   ; y = $c0
        rts

; ------------------------------------------------------------------------------

; [ create skull thread ]

; umaro

InitUmaroSkullAnim:
@e8c4:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(UmaroSkullAnim)
        sta     $7e32c9,x
        shorta
        lda     #^UmaroSkullAnim
        sta     $7e35ca,x
        lda     #$c4
        sta     $7e33ca,x
        lda     #$4f
        jmp     _c3ea68

; ------------------------------------------------------------------------------

; [ create four spinning card threads ]

; setzer

InitSetzerCardsAnim:
@e8e3:  jsr     CreateSetzerCardTask       ; first card
        lda     #$78
        sta     $7e33ca,x
        lda     #$50
        sta     $7e33ca,x
        longa
        lda     #$0080
        sta     $7e3549,x
        lda     #$0020
        sta     $7e34c9,x
        shorta
        jsr     CreateSetzerCardTask       ; second card
        lda     #$04
        sta     $7e36ca,x
        lda     #$48
        sta     $7e33ca,x
        lda     #$c0
        sta     $7e344a,x
        longa
        lda     #$0060
        sta     $7e3549,x
        lda     #$0040
        sta     $7e34c9,x
        shorta
        jsr     CreateSetzerCardTask       ; third card
        lda     #$0c
        sta     $7e36ca,x
        lda     #$98
        sta     $7e33ca,x
        lda     #$10
        sta     $7e344a,x
        longa
        lda     #$0080
        sta     $7e3549,x
        lda     #$ffe0
        sta     $7e34c9,x
        shorta
        jsr     CreateSetzerCardTask       ; fourth card
        lda     #$12
        sta     $7e36ca,x
        lda     #$d0
        sta     $7e33ca,x
        lda     #$80
        sta     $7e344a,x
        longa
        lda     #$0080
        sta     $7e3549,x
        lda     #$00a0
        sta     $7e34c9,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create spinning card thread ]

CreateSetzerCardTask:
@e97a:  lda     #0
        ldy     #.loword(EndingAnimTask)
        jsr     CreateTask
        longa
        lda     #.loword(SetzerCardAnim)
        sta     $7e32c9,x
        shorta
        lda     #^SetzerCardAnim
        sta     $7e35ca,x
        rts

; ------------------------------------------------------------------------------

; [ create eyes thread ]

; gau

InitGauEyesAnim:
@e994:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(GauEyesAnim)
        sta     $7e32c9,x
        shorta
        lda     #^GauEyesAnim
        sta     $7e35ca,x
        lda     #$cb
        sta     $7e33ca,x
        lda     #$5f
        jmp     _c3ea68

; ------------------------------------------------------------------------------

; [ create apple thread ]

; shadow

InitShadowAppleAnim:
@e9b3:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(ShadowAppleAnim)
        sta     $7e32c9,x
        shorta
        lda     #^ShadowAppleAnim
        sta     $7e35ca,x
        lda     #$c0
        sta     $7e33ca,x
        lda     #$57
        jmp     _c3ea68

; ------------------------------------------------------------------------------

; [ create generic animation task ]

CreateEndingAnimTask:
@e9d2:  lda     #3
        ldy     #.loword(EndingAnimTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create generic animation task (priority 2) ]

; unused

@e9db:  lda     #2
        ldy     #.loword(EndingAnimTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

_c3e9e4:
@e9e4:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(GogoGlimmerAnim)
        sta     $7e32c9,x
        shorta
        lda     #^GogoGlimmerAnim
        sta     $7e35ca,x
        lda     #$c8
        sta     $7e33ca,x
        lda     #$61
        jmp     _c3ea68

; ------------------------------------------------------------------------------

_c3ea03:
@ea03:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(TerraPendantAnim)
        sta     $7e32c9,x
        shorta
        lda     #^TerraPendantAnim
        sta     $7e35ca,x
        lda     #$80
        sta     $7e33ca,x
        lda     #$60
        sta     $7e344a,x
        rts

; ------------------------------------------------------------------------------

; [ create dancing mini-mog thread ]

; mog

_c3ea24:
@ea24:  jsr     CreateEndingAnimTask
        longa
        lda     #.loword(MogMiniMoogleAnim)
        sta     $7e32c9,x
        shorta
        lda     #^MogMiniMoogleAnim
        sta     $7e35ca,x
        lda     #$e0
        sta     $7e33ca,x
        lda     #$6f
        jsr     _c3ea68
        jsr     _c3ea73
        lda     #$ba
        sta     $7e33ca,x
        jsr     _c3ea73
        lda     #$c6
        sta     $7e33ca,x
        jsr     _c3ea73
        lda     #$d1
        sta     $7e33ca,x
        jsr     _c3ea73
        lda     #$dc
        sta     $7e33ca,x
        rts

; ------------------------------------------------------------------------------

_c3ea68:
@ea68:  sta     $7e344a,x

_c3ea6c:
@ea6c:  lda     #$01
        sta     $7e364a,x
        rts

; ------------------------------------------------------------------------------

_c3ea73:
@ea73:  lda     #2
        ldy     #.loword(_c3eafc)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create walking mini-moogle threads ]

; umaro

_c3ea7c:
@ea7c:  jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$3a
        sta     $7e33ca,x
        longa
        lda     #$01a4
        sta     $7e3349,x
        lda     #.loword(UmaroMiniMoogleAnim4)
        sta     $7e37c9,x
        shorta
        jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$2e
        sta     $7e33ca,x
        longa
        lda     #$01b8
        sta     $7e3349,x
        lda     #.loword(UmaroMiniMoogleAnim5)
        sta     $7e37c9,x
        shorta
        jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$21
        sta     $7e33ca,x
        longa
        lda     #$01cc
        sta     $7e3349,x
        lda     #.loword(UmaroMiniMoogleAnim6)
        sta     $7e37c9,x
        shorta
        jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$14
        sta     $7e33ca,x
        longa
        lda     #$01e0
        sta     $7e3349,x
        lda     #.loword(UmaroMiniMoogleAnim7)
        sta     $7e37c9,x
        shorta
        rts

; ------------------------------------------------------------------------------

_c3eaf5:
@eaf5:  lda     #$05
        sta     $7e3649,x
        rts

; ------------------------------------------------------------------------------

; [ umaro mini-moogle task ]

_c3eafc:
@eafc:  tax
        jmp     (.loword(_c3eb00),x)

_c3eb00:
@eb00:  .addr   _c3eb10, _c3eb35, _c3eb5e, _c3eb7b
        .addr   _c3eb97, _c3eb9c, _c3eba9, _c3ebd0

; ------------------------------------------------------------------------------

_c3eb10:
@eb10:  ldx     $2d
        inc     $3649,x
        longa
        lda     #.loword(UmaroMiniMoogleAnim1)
        sta     $32c9,x
        lda     #$0168
        sta     $3349,x
        shorta
        lda     #$64
        sta     $344a,x
        lda     #^UmaroMiniMoogleAnim1
        sta     $35ca,x
        jsr     _c3ea6c
        jsr     InitAnimTask

_c3eb35:
@eb35:  ldx     $2d
        ldy     $3349,x
        bne     @eb56
        inc     $3649,x
        longa
        lda     #.loword(UmaroMiniMoogleAnim3)
        sta     $32c9,x
        shorta
        lda     #^UmaroMiniMoogleAnim3
        sta     $35ca,x
        lda     #$10
        sta     $3349,x
        jsr     InitAnimTask
@eb56:  jsr     DecTaskCounter
        jsr     UpdateEndingAnimTask
        sec
        rts

_c3eb5e:
@eb5e:  ldx     $2d
        ldy     $3349,x
        bne     @eb6d
        inc     $3649,x
        lda     #$3c
        sta     $3349,x
@eb6d:  jsr     DecTaskCounter
        jsr     _c3ebf0
        jsr     UpdateEndingAnimTask
        inc     $35c9,x
        sec
        rts

_c3eb7b:
@eb7b:  ldx     $2d
        ldy     $3349,x
        bne     @eb8f
        jsr     _c3ebd5
        longa
        lda     #$012c
        sta     $3349,x
        shorta
@eb8f:  jsr     DecTaskCounter
        jsr     UpdateEndingAnimTask
        sec
        rts

_c3eb97:
@eb97:  jsr     UpdateEndingAnimTask
        sec
        rts

_c3eb9c:
@eb9c:  ldx     $2d
        jsr     _c3ebd5
        lda     #$70
        sta     $344a,x
        jsr     _c3ea6c

_c3eba9:
@eba9:  ldx     $2d
        ldy     $3349,x
        bne     @ebc8
        inc     $3649,x
        longa
        stz     $34c9,x
        lda     $37c9,x
        sta     $32c9,x
        shorta
        lda     #^UmaroMiniMoogleAnim1
        sta     $35ca,x
        jsr     InitAnimTask
@ebc8:  jsr     DecTaskCounter
        jsr     UpdateEndingAnimTask
        sec
        rts

_c3ebd0:
@ebd0:  jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

_c3ebd5:
@ebd5:  inc     $3649,x
        longa
        lda     #.loword(UmaroMiniMoogleAnim2)
        sta     $32c9,x
        lda     #$0040
        sta     $34c9,x
        shorta
        lda     #^UmaroMiniMoogleAnim2
        sta     $35ca,x
        jmp     InitAnimTask

; ------------------------------------------------------------------------------

; [  ]

_c3ebf0:
@ebf0:  ldx     $2d
        lda     $35c9,x
        and     #$0f
        tax
        lda     f:MiniMoogleJumpOffset,x
        sta     $e0
        bmi     @ec0d
        ldx     $2d
        lda     $344a,x
        clc
        adc     $e0
        sta     $344a,x
        bra     @ec23
@ec0d:  ldx     $2d
        lda     a:$00e0
        bpl     @ec17
        eor     #$ff
        inc
@ec17:  sta     a:$00e0
        lda     $344a,x
        sec
        sbc     $e0
        sta     $344a,x
@ec23:  rts

; ------------------------------------------------------------------------------

; [ create spinning coin thread ]

InitCoinAnim:
@ec24:  lda     #2
        ldy     #.loword(CoinAnimTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create paintbrush sparkle thread ]

InitRelmBrushAnim:
@ec2d:  lda     #0
        ldy     #.loword(RelmBrushAnimTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create sword sparkle thread ]

InitCyanSwordAnim:
@ec36:  lda     #0
        ldy     #.loword(CyanSwordAnimTask)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create sparkle thread ]

_c3ec3f:
@ec3f:  lda     #2
        ldy     #.loword(_c3ed14)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ paintbrush sparkle thread ]

; relm

RelmBrushAnimTask:
@ec48:  tax
        jmp     (.loword(_c3ec4c),x)

_c3ec4c:
@ec4c:  .addr   _c3ec50, _c3ec67

; ------------------------------------------------------------------------------

_c3ec50:
@ec50:  ldx     $2d
        inc     $3649,x
        longa
        lda     #$0168
        sta     $3349,x
        shorta
        lda     #$e4
        sta     $c7
        lda     #$03
        sta     $c9

_c3ec67:
@ec67:  lda     $c9
        beq     @ecac
        ldx     $2d
        ldy     $3349,x
        bne     @eca7
        lda     #$08
        sta     $3349,x
        phb
        lda     #$00
        pha
        plb
        jsr     _c3ec3f
        lda     #$68
        sta     $7e344a,x
        longa
        lda     #.loword(TerraPendantAnim)
        sta     $7e32c9,x
        shorta
        lda     #^TerraPendantAnim
        sta     $7e35ca,x
        lda     $c7
        sta     $7e33ca,x
        plb
        dec     $c7
        dec     $c7
        dec     $c7
        dec     $c7
        dec     $c9
@eca7:  jsr     DecTaskCounter
        sec
        rts
@ecac:  clc
        rts

; ------------------------------------------------------------------------------

; [ sword glimmer thread ]

; cyan

CyanSwordAnimTask:
@ecae:  tax
        jmp     (.loword(_c3ecb2),x)

_c3ecb2:
@ecb2:  .addr   _c3ecb6, _c3eccd

; ------------------------------------------------------------------------------

_c3ecb6:
@ecb6:  ldx     $2d
        inc     $3649,x
        longa
        lda     #$0168
        sta     $3349,x
        shorta
        lda     #$c8
        sta     $c7
        lda     #$04
        sta     $c9

_c3eccd:
@eccd:  lda     $c9
        beq     @ed12
        ldx     $2d
        ldy     $3349,x
        bne     @ed0d
        lda     #$08
        sta     $3349,x
        phb
        lda     #$00
        pha
        plb
        jsr     _c3ec3f
        lda     #$60
        sta     $7e344a,x
        longa
        lda     #.loword(CyanKatanaAnim)
        sta     $7e32c9,x
        shorta
        lda     #^CyanKatanaAnim
        sta     $7e35ca,x
        lda     $c7
        sta     $7e33ca,x
        plb
        dec     $c7
        dec     $c7
        dec     $c7
        dec     $c7
        dec     $c9
@ed0d:  jsr     DecTaskCounter
        sec
        rts
@ed12:  clc
        rts

; ------------------------------------------------------------------------------

; [ sparkle thread ]

_c3ed14:
@ed14:  tax
        jmp     (.loword(_c3ed18),x)

_c3ed18:
@ed18:  .addr   _c3ed1c, _c3ed29

; ------------------------------------------------------------------------------

_c3ed1c:
@ed1c:  ldx     $2d
        inc     $3649,x
        lda     #$01
        sta     $364a,x
        jsr     InitAnimTask

_c3ed29:
@ed29:  ldx     $2d
        lda     $36ca,x
        cmp     #$fe
        beq     @ed37
        jsr     UpdateEndingAnimTask
        sec
        rts
@ed37:  clc
        rts

; ------------------------------------------------------------------------------

; [ spinning coin thread ]

CoinAnimTask:
@ed39:  tax
        jmp     (.loword(CoinAnimTaskTbl),x)

CoinAnimTaskTbl:
@ed3d:  .addr   CoinAnimTask_00
        .addr   CoinAnimTask_01

; ------------------------------------------------------------------------------

CoinAnimTask_00:
@ed41:  ldx     $2d
        inc     $3649,x
        longa
        lda     #.loword(EdgarCoinAnim)
        sta     $32c9,x
        lda     #$0080
        sta     $34c9,x
        shorta
        lda     #$c8
        sta     $3349,x
        lda     #^EdgarCoinAnim
        sta     $35ca,x
        lda     #$10
        sta     $33ca,x
        lda     #$64
        sta     $344a,x
        jsr     InitAnimTask

CoinAnimTask_01:
@ed6d:  ldx     $2d
        lda     $3349,x
        bne     @ed77
        stz     $34c9,x
@ed77:  dec     $3349,x
        jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

_c3ed7f:
@ed7f:  jsr     _c3edbe
        longa
        lda     #.loword(BookAnimStrago)
        sta     $7e32c9,x
        shorta
        lda     #^BookAnimStrago
        sta     $7e35ca,x
        rts

; ------------------------------------------------------------------------------

_c3ed94:
@ed94:  jsr     _c3edbe
        longa
        lda     #.loword(BookAnim1)
        sta     $7e32c9,x
        shorta
        lda     #^BookAnim1
        sta     $7e35ca,x
        rts

; ------------------------------------------------------------------------------

_c3eda9:
@eda9:  jsr     _c3edbe
        longa
        lda     #.loword(BookAnim2)
        sta     $7e32c9,x
        shorta
        lda     #^BookAnim2
        sta     $7e35ca,x
        rts

; ------------------------------------------------------------------------------

_c3edbe:
@edbe:  clr_ay
        sta     $99
        sty     $60
        lda     #1
        ldy     #.loword(_c3ee04)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

_c3edcd:
@edcd:  stx     $e7
        lda     #$7f
        sta     $e9
        sty     $eb
        lda     #$7e
        sta     $ed
        ldx     $00
        longa
@eddd:  clr_ay
@eddf:  lda     [$e7],y
        clc
        adc     $60
        sta     [$eb],y
        iny2
        cpy     $e0
        bne     @eddf
        lda     $e7
        clc
        adc     #$0040
        sta     $e7
        lda     $eb
        clc
        adc     #$0040
        sta     $eb
        inx
        cpx     $e2
        bne     @eddd
        shorta
        rts

; ------------------------------------------------------------------------------

_c3ee04:
@ee04:  tax
        jmp     (.loword(_c3ee08),x)

_c3ee08:
@ee08:  .addr   _c3ee0e, _c3ee18, _c3ee1c

; ------------------------------------------------------------------------------

_c3ee0e:
@ee0e:  ldx     $2d
        inc     $3649,x
        jsr     InitAnimTask
        sec
        rts

_c3ee18:
@ee18:  lda     $99
        bne     _ee59

_c3ee1c:
@ee1c:  ldx     $2d
        jsr     UpdateAnimData
        ldx     $2d
        shorti
        lda     $36c9,x
        tay
        longa
        lda     [$eb],y
        sta     $e7
        iny2
        shorta
        lda     $35ca,x
        sta     $e9
        longi
        ldy     $00
        longa
        lda     [$e7],y
        sta     $e0
        iny2
        lda     [$e7],y
        sta     $e2
        iny2
        lda     [$e7],y
        tax
        iny2
        lda     [$e7],y
        tay
        shorta
        jsr     _c3edcd
        sec
        rts
_ee59:  stz     $99
        ldx     $2d
        inc     $3649,x
        longa
        lda     #.loword(BookAnimEnd)
        sta     $32c9,x
        shorta
        lda     #^BookAnimEnd
        sta     $35ca,x
        jsr     InitAnimTask
        bra     _c3ee1c

; ------------------------------------------------------------------------------

; [ load ending font graphics ]

LoadEndingFontGfx:
@ee74:  ldy     #.loword(EndingFontGfx)
        lda     #^EndingFontGfx
        jsr     Decompress
        ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0900      ; copy $0900 bytes to vram at $7000
        sty     $eb
        ldy     #$7000
        jmp     TfrGfx2bpp

; ------------------------------------------------------------------------------

; [ load ending bg graphics ]

LoadEndingBGGfx:
@ee90:  ldy     #.loword(EndingGfx1)
        lda     #^EndingGfx1
        jsr     Decompress
        ldy     #$3849      ; destination = $7e3849 (bg1 data, top left)
        sty     $eb
        lda     #$7e
        sta     $ed
        jsr     _c3ef10       ; load bg data
        ldy     #$4049      ; destination = $7e3849 (bg1 data, top right)
        sty     $eb
        lda     #$7e
        sta     $ed
        jsr     _c3ef10       ; load bg data
        ldy     #$c000      ; source = $7ec000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$1f60      ; size = $1f60
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$3000      ; destination = vram $3000
        jsr     EndingTfrVRAM
        ldy     #$df60      ; source = $7edf60
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0b40      ; size = $0b40
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$4000      ; destination = vram $4000
        jsr     EndingTfrVRAM
        ldy     #$eaa0      ; source = $7eeaa0
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0e00      ; size = $0e00
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$5000      ; destination = vram $5000
        jsr     EndingTfrVRAM
        ldy     #$0448      ; source = $7f0448
        sty     $e7
        lda     #$7f
        sta     $e9
        ldy     #$0780      ; size = $0780
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$1000      ; destination = vram $1000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load bg data (book cinematic) ]

_c3ef10:
@ef10:  ldy     #$f8a0      ; source = $7ef8a0
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0780      ; size = $0780
        sty     $ef
        jmp     CopyCreditsGfx

; ------------------------------------------------------------------------------

_c3ef21:
@ef21:  ldy     #$1800
        sty     $1b
        ldy     #$7849
        sty     $1d
        lda     #$7e
        sta     $1f
        ldy     #$0800
        sty     $19
        ldy     #$0000
        sty     $14
        ldy     #$3849
        sty     $16
        lda     #$7e
        sta     $18
        ldy     #$1000
        sty     $12
        rts

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 2 ]

_c3ef48:
@ef48:  ldy     #.loword(EndingGfx2)
        lda     #^EndingGfx2
        jsr     Decompress
        ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0380
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

_c3ef68:
@ef68:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$0026
        sty     $e0
        ldy     #$0002
        sty     $e2
        ldx     #$03e0
        ldy     #$3ba1
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3ef7e:
@ef7e:  jsr     _c3ef87
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 4 ]

_c3ef87:
@ef87:  ldy     #.loword(EndingGfx4)      ; $d99d4b (ending graphics, coin and skull)
        lda     #^EndingGfx4
        jsr     Decompress
        ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0800
        sty     $eb
        stz     $ed
        stz     $ee
        rts

; ------------------------------------------------------------------------------

_c3efa2:
@efa2:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$000e
        sty     $e0
        ldy     #$0008
        sty     $e2
        ldx     #$0020
        ldy     #$3a77
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3efb8:
@efb8:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$001c
        sty     $e0
        ldy     #$0009
        sty     $e2
        ldx     #$002e
        ldy     #$3a2d
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3efce:
@efce:  jsr     _c3f056
        ldy     #$000c
        sty     $e0
        ldy     #$0007
        sty     $e2
        ldx     #$004a
        ldy     #$3ab7
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3efe4:
@efe4:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$000e
        sty     $e0
        ldy     #$0005
        sty     $e2
        ldx     #$0220
        ldy     #$3b35
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3effa:
@effa:  ldy     #$0018
        sty     $e0
        ldy     #$0006
        sty     $e2
        ldx     #$0274
        ldy     #$3b69
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3f00d:
@f00d:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$0014
        sty     $e0
        ldy     #$0002
        sty     $e2
        ldx     #$0360
        ldy     #$3bf3
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3f023:
@f023:  ldy     #$001c
        sty     $e0
        ldy     #$0006
        sty     $e2
        ldx     #$0bc8
        ldy     #$3ad9
        jmp     _c3edcd

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 3 ]

; cards, sparkle, mini-mog, eyes, ...

_c3f036:
@f036:  ldy     #.loword(EndingGfx3)
        lda     #^EndingGfx3
        jsr     Decompress
        ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$0df0
        sty     $eb
        stz     $ed
        stz     $ee
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 5 ]

_c3f056:
@f056:  ldy     #.loword(EndingGfx5)
        lda     #^EndingGfx5
        jsr     Decompress
        ldy     #$c000
        sty     $e7
        lda     #$7e
        sta     $e9
        ldy     #$00c0
        sty     $eb
        ldy     #$6000
        jmp     TfrGfx2bpp

; ------------------------------------------------------------------------------

; [ load skull graphics (sprite) ]

_c3f072:
@f072:  jsr     _c3f036       ; load ending sprite graphics 3
        jsr     _c3ef87
        ldy     #$6800
        jsr     EndingTfrVRAM
        ldy     #$000a
        sty     $e0
        ldy     #$0005
        sty     $e2
        ldx     #$0056
        ldy     #$3b37
        jmp     _c3edcd

; ------------------------------------------------------------------------------
