
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
        ptr_tbl ENDING_STATE

; ------------------------------------------------------------------------------

; [ ending cutscene ]

; $0201: ending cutscene state ( -> $26)
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
        ldx     #0
        stx     zZero
        lda     #$7e
        sta     hWMADDH
        jsr     InitInterrupts
        jsr     InitRAM
        ldy     #$012c
        sty     z85         ; ??? (something to do with character full name text)
        stz     zb4         ; use inverse credits palette
        jsr     DisableDMA
        jsr     DisableInterruptsEnding
        jsl     InitHWRegsMenu
        jsl     InitCtrl
        jsr     ResetTasks
        jsr     ClearVRAM
        jsl     PushMode7Vars
        lda     r0201
        sta     zEndingState
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
        sty     zDMA2Dest
        sty     zDMA2Src
        sta     zDMA2Src_B
        sty     zDMA1Src
        sta     zDMA1Src_B
        ldy     #$0001
        sty     zDMA2Size
        sty     zDMA1Size
        ldy     #$7fff
        sty     zDMA1Dest
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
        lda     zEndingState         ; cinematic state
        cmp     #ENDING_STATE::TERMINATE
        beq     @c5bd       ; terminate if $ff
        longa
        asl
        tax
        shorta
        jsr     (near EndingStateTbl,x)   ; state code
        jsr     ExecTasks
        jsr     WaitVblank
        bra     @c5a5
@c5bd:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $00: fade out ]

        array_label ENDING_STATE, ENDING_STATE::FADE_OUT
@c5be:  ldy     zWaitCounter            ; return if wait counter is not clear
        bne     @c5d3
        lda     #ENDING_STATE::WAIT_FADE
        sta     zEndingState
        ldy     #15                     ; wait 15 frames
        sty     zWaitCounter
        lda     #0
        ldy     #near EndingFadeOutTask
        jsr     CreateTask
@c5d3:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $01: wait for fade, then terminate ]

        array_label ENDING_STATE, ENDING_STATE::WAIT_FADE
@c5d4:  ldy     zWaitCounter            ; return if wait counter is not clear
        bne     @c5db
        jmp     ExitEnding
@c5db:  rts

; ------------------------------------------------------------------------------

; [ use normal credits palette ]

; used for clouds scenes

_c3c5dc:
@c5dc:  lda     #1
        sta     zb4
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $05: clouds 3 (mode 7 airship above clouds) ]

; credits scene 1

        array_label ENDING_STATE, ENDING_STATE::CLOUDS_3
@c5e1:  jsr     _c3c5dc       ; use normal credits palette
        jsl     InitHWRegsCredits
        jsr     _c3d40c       ; load graphics (airship above clouds)
        jsr     InitMode7Scroll
        jsl     _d4cbfc
        ldy     #$0010
        sty     z8e
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
        sty     zc7
        ldy     #$2f00
        sty     zc5
        ldy     #$0100
        sty     zM7X
        ldy     #$0311
        sty     zM7Y
        ldy     #$0080
        sty     zBG1HScroll
        ldy     #$0291
        sty     zBG1VScroll
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        ldy     zZero
        sty     zcf         ; clear frame counter
        jsr     LoadCreditsTextScene1
        lda     #2
        ldy     #near CreditsTextTaskScene1
        jsr     CreateTask
        lda     #2
        ldy     #near _c3c681
        jsr     CreateTask
        lda     #0
        ldy     #near _c3d0f2
        jsr     CreateTask
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        jsr     _c3d018       ;
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        ldy     #9 * 60
        sty     zWaitCounter
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ create fade in task ]

CreateEndingFadeInTask:
@c66c:  lda     #0
        ldy     #near EndingFadeInTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ wait for vblank ]

EndingWaitVblank:
@c675:  lda     #$01
        sta     zScreenBrightness
        jsr     WaitVblank
        lda     #$0f
        sta     zScreenBrightness
        rts

; ------------------------------------------------------------------------------

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_6

; ------------------------------------------------------------------------------

; [ airship scaling and bg scrolling task ]

_c3c681:
@c681:  tax
        jmp     (near _c3c685,x)

_c3c685:
@c685:  .addr   _c3c68b, _c3c69a, _c3c6ba

; ------------------------------------------------------------------------------

; 0: init
_c3c68b:
@c68b:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #590
        sta     near wTaskProp::w7e3349,x
        shorta

; 1: scale airship and scroll bg
_c3c69a:
@c69a:  ldx     zTaskOffset
        lda     zFrameCounter
        and     #%1
        bne     @c6a6                   ; increase scaling every other frame
        longa
        inc     z8e
@c6a6:  longa
        lda     z8e
        sta     $0600
        stz     $07c2
        stz     $0984
        jsr     _c3c6bf
        shorta
        sec
        rts

; 2: scroll bg only
_c3c6ba:
@c6ba:  jsr     _c3c6bf
        sec
        rts

; ------------------------------------------------------------------------------

; [ scroll clouds below airship ]

_c3c6bf:
@c6bf:  longa
        dec     zBG1HScroll
        dec     zM7X
        lda     zBG1HScroll
        sta     $b691
        lda     zBG1VScroll
        sta     $b693
        lda     zM7X
        sta     $b699
        lda     zM7Y
        sta     $b69b
        shorta
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $07, $08: unused ??? ]

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_7
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_8

; ------------------------------------------------------------------------------

FadeOutCreditsPal:
@c6dc:  lda     #^BlackPal
        sta     zed
        lda     #4        ; speed = 4 frames per update
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^BlackPal
        sta     zed
        lda     #4        ; speed = 4 frames per update
        ldy     #near wPalBuf::SpritePal5
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade in inverse credits palette ]

; used for everything except clouds scenes

_c3c703:
@c703:  lda     #^_c29754        ; source = $c29754 (inverse credits palette 1)
        sta     zed
        lda     #4        ; speed = 4 frames per update
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near _c29754
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^_c2974c        ; source = $c2974c (inverse credits palette 2)
        sta     zed
        lda     #4        ; speed = 4 frames per update
        ldy     #near wPalBuf::SpritePal5
        sty     ze7
        ldx     #near _c2974c
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade in normal credits palette ]

; used for clouds scenes only

_c3c72a:
@c72a:  lda     #^_c29744        ; source = $c29744 (normal credits palette 1)
        sta     zed
        lda     #$04        ; speed = 4 frames per update
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near _c29744
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^_c2973c        ; source = $c2973c (normal credits palette 2)
        sta     zed
        lda     #4        ; speed = 4 frames per update
        ldy     #near wPalBuf::SpritePal5
        sty     ze7
        ldx     #near _c2973c
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ load credits sprite palettes ]

LoadCreditsSpritePal:
@c751:  lda     #^_c297f4
        ldy     #near wPalBuf::SpritePal0
        ldx     #near _c297f4
        jsr     LoadPal
        lda     #^_c29794
        ldy     #near wPalBuf::SpritePal1
        ldx     #near _c29794
        jsr     LoadPal
        lda     #^_c297b4
        ldy     #near wPalBuf::SpritePal2
        ldx     #near _c297b4
        jsr     LoadPal
        lda     #^_c297d4
        ldy     #near wPalBuf::SpritePal3
        ldx     #near _c297d4
        jsr     LoadPal
        lda     #^_c29834
        ldy     #near wPalBuf::SpritePal6
        ldx     #near _c29834
        jsr     LoadPal
        lda     #^_c29814
        ldy     #near wPalBuf::SpritePal7
        ldx     #near _c29814
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; unused ending states

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_37
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_38
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_39
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_44
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_49
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_54
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_55
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_57
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_58
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_59
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_78
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_84
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_85
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_86
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_87
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_88
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_89
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_94
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_95
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_96
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_97
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_98
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_99
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_107
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_108
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_109
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_114
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_115
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_116
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_117
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_118
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_119
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_124
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_125
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_126
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_127
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_128
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_129

; ------------------------------------------------------------------------------

; [ cinematic state $09: tiny airship 1 ]

; credits scene 2

        array_label ENDING_STATE, ENDING_STATE::TINY_AIRSHIP_1
@c794:  jsr     _c3c5dc       ; use normal credits palette
        jsl     InitHWRegsCredits
        jsr     _c3d522
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        jsr     LoadCreditsSpritePal
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        ldy     #near CreditsScrollScene2
        lda     #^CreditsScrollScene2
        jsr     CreateMode7ScrollTask
        jsr     LoadCreditsTextScene2
        ldy     zZero
        sty     zcf
        lda     #2
        ldy     #near CreditsTextTaskScene2
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control task
        inc     zEndingState
        ldy     #16 * 60
        sty     zWaitCounter
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $0a: tiny airship 2 ]

        array_label ENDING_STATE, ENDING_STATE::TINY_AIRSHIP_2
@c7d2:  ldy     zWaitCounter
        bne     @c7e0
        inc     zEndingState
        ldy     #36 * 60
        sty     zWaitCounter
        jsr     InitTinyAirshipTasks
@c7e0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $0b: tiny airship 3 ]

        array_label ENDING_STATE, ENDING_STATE::TINY_AIRSHIP_3
@c7e1:  ldy     zWaitCounter
        bne     @c801
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        lda     #^WhitePal
        sta     zed
        lda     #2
        ldy     #near wPalBuf::BGPal3
        sty     ze7
        ldx     #near WhitePal
        stx     zeb
        jsr     CreateFadePalTask
@c801:  rts

; ------------------------------------------------------------------------------

; [ create tiny airship and shadow ]

InitTinyAirshipTasks:
@c802:  jsr     _c3c846       ; create generic task w/ counter
        longa
        lda     #near TinyAirshipAnim
        jsr     InitTinyAirshipMovement
        shorta
        lda     #^TinyAirshipAnim
        sta     wTaskProp::AnimBank,x
        lda     #$f8
        sta     wTaskProp::PosX_H,x
        lda     #$a0
        sta     wTaskProp::PosY_H,x   ; y position

; airship shadow
        lda     #3
        ldy     #near _c3de84           ; generic animation task w/ counter
        jsr     CreateTask
        longa
        lda     #near TinyAirshipShadowAnim
        jsr     InitTinyAirshipMovement
        shorta
        lda     #^TinyAirshipShadowAnim
        sta     wTaskProp::AnimBank,x
        lda     #$f8
        sta     wTaskProp::PosX_H,x   ; x position
        lda     #$b0
        sta     wTaskProp::PosY_H,x   ; y position
        rts

; ------------------------------------------------------------------------------

; [ create generic task w/ counter ]

_c3c846:
@c846:  lda     #1
        ldy     #near _c3de84      ; generic animation task w/ counter
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ init tiny airship task ]

InitTinyAirshipMovement:
        .a16
@c84f:  sta     wTaskProp::AnimPtr,x
        lda     #near -64
        sta     wTaskProp::SpeedX,x   ; horizontal speed
        lda     #near -32
        sta     wTaskProp::SpeedY,x   ; vertical speed
        lda     #$0400
        sta     wTaskProp::w7e3349,x   ; movement counter
        rts
        .a8

; ------------------------------------------------------------------------------

; [ cinematic state $02: clouds 1 (slow scroll) ]

        array_label ENDING_STATE, ENDING_STATE::CLOUDS_1
@c869:  jsr     InitEndingClouds
        ldy     #4 * 60
        sty     zWaitCounter
        ldy     #near CreditsScrollClouds1
        lda     #^CreditsScrollClouds1
        jsr     CreateMode7ScrollTask
        inc     zEndingState
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ clouds init ]

InitEndingClouds:
@c87e:  jsl     InitHWRegsCredits
        jsr     _c3d522
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        jsr     LoadCreditsSpritePal
        jsr     _c3d15c       ; clear credits text palettes
        ldy     #$0200
        sty     zc7
        ldy     #$f000
        sty     zc5
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        jsr     LoadCreditsBGPal
        jsr     _c3d2a0       ; create camera control task
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $03: fade out (ending) ]

        array_label ENDING_STATE, ENDING_STATE::FADE_ENDING
@c8a6:  ldy     zWaitCounter
        bne     @c8ac
        stz     zEndingState            ; ENDING_STATE::FADE_OUT
@c8ac:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $04: clouds 2 (spiraling down) ]

        array_label ENDING_STATE, ENDING_STATE::CLOUDS_2
@c8ad:  jsr     InitEndingClouds
        ldy     #$8000
        sty     zc7
        ldy     #$8000
        sty     zc5
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        ldy     #2 * 60
        sty     zWaitCounter
        ldy     #near CreditsScrollClouds2
        lda     #^CreditsScrollClouds2
        jsr     CreateMode7ScrollTask
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $0c: sea with boat 1 ]

; credits scene 3

        array_label ENDING_STATE, ENDING_STATE::SEA_BOAT_1
@c8d1:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsr     _c3d5aa
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        ldy     #$1000
        sty     zc5
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        jsr     LoadCreditsSpritePal
        ldy     #near CreditsScrollScene3
        lda     #^CreditsScrollScene3
        jsr     CreateMode7ScrollTask
        jsr     _c3cac7       ; create oscillating birds (boat)
        jsr     LoadCreditsTextScene3
        ldy     zZero
        sty     zcf
        lda     #2
        ldy     #near CreditsTextTaskScene3
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control task
        ldy     #18 * 60
        sty     zWaitCounter
        inc     zEndingState
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $0d: sea with boat 2 ]

        array_label ENDING_STATE, ENDING_STATE::SEA_BOAT_2
@c917:  ldy     zWaitCounter
        bne     @c925
        jsr     _c3c94e                 ; create boat tasks
        stz     zEndingState            ; ENDING_STATE::FADE_OUT
        ldy     #12 * 60
        sty     zWaitCounter
@c925:  rts

; ------------------------------------------------------------------------------

; [ create boat task (right half only) ]

; unused

@c926:  jsr     CreateEndingAnimTask
        longa
        lda     #near _cff7fd
        sta     wTaskProp::AnimPtr,x
        lda     #$ffc0
        sta     wTaskProp::SpeedX,x
        shorta
        lda     #^_cff7fd
        sta     wTaskProp::AnimBank,x
        lda     #$f8
        sta     wTaskProp::PosX_H,x
        lda     #$70
        sta     wTaskProp::PosY_H,x
        rts

; ------------------------------------------------------------------------------

; [ create boat tasks ]

_c3c94e:
@c94e:  jsr     CreateEndingAnimTask
        longa
        lda     #near _cff809
        sta     wTaskProp::AnimPtr,x
        lda     #$ffc0
        sta     wTaskProp::SpeedX,x
        shorta
        lda     #^_cff809
        sta     wTaskProp::AnimBank,x
        lda     #$f8
        sta     wTaskProp::PosX_H,x
        lda     #$50
        sta     wTaskProp::PosY_H,x
        lda     #1
        ldy     #near _c3c9a2      ; boat task (right half)
        jsr     CreateTask
        longa
        lda     #near _cff7fd      ; cf/f7fd (boat, right half)
        sta     wTaskProp::AnimPtr,x
        lda     #$ffc0
        sta     wTaskProp::SpeedX,x
        shorta
        lda     #^_cff7fd
        sta     wTaskProp::AnimBank,x
        lda     #$f8
        sta     wTaskProp::PosX_H,x
        lda     #$50
        sta     wTaskProp::PosY_H,x
        rts

; ------------------------------------------------------------------------------

; [ boat task (right half) ]

_c3c9a2:
@c9a2:  tax
        jmp     (near _c3c9a6,x)

_c3c9a6:
@c9a6:  .addr   _c3c9aa, _c3c9bc

; ------------------------------------------------------------------------------

_c3c9aa:
@c9aa:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #$0040
        sta     near wTaskProp::w7e3349,x     ; set task counter to 64
        shorta
        jsr     InitAnimTask

_c3c9bc:
@c9bc:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x     ; start moving left after 64 frames (i think...)
        bne     @c9c8
        jsr     UpdateEndingAnimTask
        sec
        rts
@c9c8:  jsr     DecTaskCounter
        sec
        rts

; ------------------------------------------------------------------------------

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_14
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_15

; ------------------------------------------------------------------------------

; [ cinematic state $10: sea with airship 1 ]

; credits scene 4

        array_label ENDING_STATE, ENDING_STATE::SEA_AIRSHIP_1
@c9cd:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsr     _c3d5da
        jsr     _c3ca71
        jsr     InitCreditsFixedColorHDMA
        jsr     InitCreditsColorMathHDMA
        jsr     LoadCreditsSpritePal
        ldy     #$0028
        sty     zBG2VScroll
        ldy     #$ff6d
        sty     zc3
        ldy     #$034c
        sty     zc7
        ldy     #$fd00
        sty     zc5
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        jsr     _c3cafd       ; create oscillating birds (sea with airship)
        lda     #2
        ldy     #near _c3cbc6      ; airship position task (going left)
        jsr     CreateTask
        longa
        lda     #near AirshipLeftAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^AirshipLeftAnim
        sta     wTaskProp::AnimBank,x
        lda     #$78
        sta     wTaskProp::PosX_H,x
        lda     #$58
        sta     wTaskProp::PosY_H,x
        jsr     CreateEndingAnimTask
        longa
        lda     #near AirshipShadowAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^AirshipShadowAnim
        sta     wTaskProp::AnimBank,x
        lda     #$80
        sta     wTaskProp::PosX_H,x
        lda     #$80
        sta     wTaskProp::PosY_H,x
        jsr     LoadCreditsBGPal
        jsr     LoadCreditsTextScene4
        ldy     zZero
        sty     zcf
        lda     #2
        ldy     #near CreditsTextTaskScene4
        jsr     CreateTask
        ldy     #near CreditsScrollScene4
        lda     #^CreditsScrollScene4
        jsr     CreateMode7ScrollTask
        lda     #3
        ldy     #near ScrollBG2Righttask
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control task
        inc     zEndingState
        ldy     #20 * 60
        sty     zWaitCounter
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
        ldy     #near wPalBuf::BGPal0
        ldx     #near _c2953c
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $11: sea with airship 2 ]

        array_label ENDING_STATE, ENDING_STATE::SEA_AIRSHIP_2
@ca8c:  ldy     zWaitCounter
        bne     @caa1
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        ldy     #30 * 60
        sty     zWaitCounter
        lda     #1
        ldy     #near _c3cc79
        jsr     CreateTask
@caa1:  rts

; ------------------------------------------------------------------------------

; [ scroll bg2 right task ]

ScrollBG2Righttask:
@caa2:  lda     zFrameCounter
        and     #%1
        bne     @caae
        longa
        dec     zBG2HScroll
        shorta
@caae:  sec
        rts

; ------------------------------------------------------------------------------

; [ scroll bg2 left task ]

ScrollBG2Lefttask:
@cab0:  lda     zFrameCounter
        and     #%1
        bne     @cabc
        longa
        inc     zBG2HScroll
        shorta
@cabc:  sec
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $12, $13:  ]

; unused

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_18
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_19
@cabe:  ldy     zWaitCounter
        bne     @cac6
        lda     #ENDING_STATE::TERMINATE
        sta     zEndingState
@cac6:  rts

; ------------------------------------------------------------------------------

; [ create oscillating birds (boat) ]

_c3cac7:
@cac7:  ldx     zZero
@cac9:  phx
        jsr     _c3cb5f       ; create oscillating bird task
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:ShipBirdsAnim,x   ; sprite data pointer (+$cf0000)
        inx2
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     f:ShipBirdsAnim,x   ; x position
        inx
        sta     near wTaskProp::SpeedX_H,y
        lda     f:ShipBirdsAnim,x   ; y position
        inx
        sta     near wTaskProp::PosY_H,y
        lda     #$01
        sta     near wTaskProp::Flags,y     ; sprite doesn't scroll with bg
        plb
        cpx     #$0018      ; repeat 6 times
        bne     @cac9
        rts

; ------------------------------------------------------------------------------

; [ create oscillating birds (sea with airship) ]

_c3cafd:
@cafd:  ldx     zZero
@caff:  phx
        jsr     _c3cb5f       ; create oscillating bird task
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:_cff7cd,x
        inx2
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     f:_cff7cd,x
        inx
        sta     near wTaskProp::SpeedX_H,y
        lda     f:_cff7cd,x
        inx
        sta     near wTaskProp::PosY_H,y
        plb
        cpx     #$0018
        bne     @caff
        rts

; ------------------------------------------------------------------------------

; [ create oscillating birds (land with airship) ]

_c3cb2e:
@cb2e:  ldx     zZero
@cb30:  phx
        jsr     _c3cb5f       ; create oscillating bird task
        txy
        plx
        phb
        lda     #$7e
        pha
        plb
        longa
        lda     f:_cff7e5,x
        inx2
        sta     near wTaskProp::AnimPtr,y
        shorta
        lda     f:_cff7e5,x
        inx
        sta     near wTaskProp::SpeedX_H,y
        lda     f:_cff7e5,x
        inx
        sta     near wTaskProp::PosY_H,y
        plb
        cpx     #$0018
        bne     @cb30
        rts

; ------------------------------------------------------------------------------

; [ create oscillating bird task ]

_c3cb5f:
@cb5f:  lda     #2
        ldy     #near _c3cb68
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ oscillating bird task ]

_c3cb68:
@cb68:  tax
        jmp     (near _c3cb6c,x)

_c3cb6c:
@cb6c:  .addr   _c3cb70, _c3cb87

; ------------------------------------------------------------------------------

_c3cb70:
@cb70:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        stz     near wTaskProp::w7e3349_H,x
        lda     f:_c3cb68,x             ; looks like a bug ???
        sta     near wTaskProp::w7e3349,x
        lda     #^_cff706
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask

_c3cb87:
@cb87:  ldx     zTaskOffset
        jsr     _c3cb94                 ; update oscillating bird position
        inc     near wTaskProp::w7e3349,x
        jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update oscillating bird position ]

_c3cb94:
@cb94:  longa
        lda     near wTaskProp::w7e3349,x
        jsr     CalcCosine
        sta     zeb
        sta     ze0
        lda     ze0
        bpl     @cba8
        neg_a
@cba8:  sta     ze0
        lda     zeb
        bpl     @cbb7
        jsr     _c3cc31
        neg_a
        bra     @cbba
@cbb7:  jsr     _c3cc31
@cbba:  ldx     zTaskOffset
        clc
        adc     near wTaskProp::SpeedX,x
        sta     near wTaskProp::PosX,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ airship position task (with splash) ]

_c3cbc6:
@cbc6:  tax
        jmp     (near _c3cbca,x)

_c3cbca:
@cbca:  .addr   _c3cbce, _c3cbe6

; ------------------------------------------------------------------------------

_c3cbce:
@cbce:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        stz     near wTaskProp::w7e3349_H,x
        stz     near wTaskProp::w7e3349,x
        lda     #$78
        sta     near wTaskProp::PosX_H,x
        lda     #$20
        sta     near wTaskProp::SpeedY_H,x
        jsr     InitAnimTask

_c3cbe6:
@cbe6:  ldx     zTaskOffset
        jsr     _c3cbff       ; update airship position (sine)
        ldx     zTaskOffset
        inc     near wTaskProp::w7e3349,x
        lda     near wTaskProp::w7e3349,x
        cmp     #$38
        bcs     @cbfa
        jsr     _c3cc38       ; create airship splash task
@cbfa:  jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update airship position (sine) ]

_c3cbff:
@cbff:  longa
        lda     near wTaskProp::w7e3349,x
        jsr     CalcSine
        sta     zeb
        sta     ze0
        lda     ze0
        bpl     @cc13
        neg_a
@cc13:  sta     ze0
        lda     zeb
        bpl     @cc22
        jsr     _c3cc31
        neg_a
        bra     @cc25
@cc22:  jsr     _c3cc31
@cc25:  ldx     zTaskOffset
        clc
        adc     near wTaskProp::SpeedY,x
        sta     near wTaskProp::PosY,x
        shorta
        rts

; ------------------------------------------------------------------------------

_c3cc31:
@cc31:  lda     ze0
        lsr4
        rts

; ------------------------------------------------------------------------------

; [ create airship splash task ]

_c3cc38:
@cc38:  lda     zFrameCounter
        and     #%11
        bne     @cc78
        phb
        lda     #$00
        pha
        plb
        jsr     _c3c846       ; create generic task w/ counter
        longa
        lda     #near AirshipSplashAnim
        sta     wTaskProp::AnimPtr,x
        lda     #$0100
        sta     wTaskProp::SpeedX,x
        lda     #$ff80
        sta     wTaskProp::SpeedY,x
        shorta
        lda     #$18
        sta     wTaskProp::w7e3349,x
        lda     #^AirshipSplashAnim
        sta     wTaskProp::AnimBank,x
        lda     #$7e
        sta     wTaskProp::PosX_H,x
        lda     #$7c
        sta     wTaskProp::PosY_H,x
        plb
@cc78:  rts

; ------------------------------------------------------------------------------

; [ airship position task (???) ]

_c3cc79:
@cc79:  tax
        jmp     (near _c3cc7d,x)

_c3cc7d:
@cc7d:  .addr   _c3cc81, _c3cca8

; ------------------------------------------------------------------------------

_c3cc81:
@cc81:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     #^_cff772
        sta     near wTaskProp::AnimBank,x
        longa
        lda     #near _cff772      ; cf/f772 (bird 5)
        sta     near wTaskProp::AnimPtr,x
        lda     #$0010
        sta     near wTaskProp::w7e3349,x
        shorta
        lda     #$00
        sta     near wTaskProp::SpeedX_H,x
        lda     #$00
        sta     near wTaskProp::SpeedY_H,x
        jsr     InitAnimTask

_c3cca8:
@cca8:  ldx     zTaskOffset
        lda     near wTaskProp::PosX_H,x
        cmp     #$08
        bcs     @ccb3
        clc
        rts
@ccb3:  longa
        lda     near wTaskProp::w7e3349,x
        jsr     CalcCosine
        sta     zeb
        sta     ze0
        lda     ze0
        bpl     @ccc7
        neg_a
@ccc7:  sta     ze0
        lda     zeb
        bpl     @ccd6
        lda     ze0
        asl
        neg_a
        bra     @ccd9
@ccd6:  lda     ze0
        asl
@ccd9:  ldx     zTaskOffset
        clc
        adc     near wTaskProp::SpeedX,x
        sta     near wTaskProp::PosX,x
        lda     near wTaskProp::w7e3349,x
        jsr     CalcSine
        sta     zeb
        sta     ze0
        lda     ze0
        bpl     @ccf4
        neg_a
@ccf4:  sta     ze0
        lda     zeb
        bpl     @cd02
        lda     ze0
        neg_a
        bra     @cd04
@cd02:  lda     ze0
@cd04:  ldx     zTaskOffset
        clc
        adc     near wTaskProp::SpeedY,x
        sta     near wTaskProp::PosY,x
        inc     near wTaskProp::w7e3349,x
        shorta
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $14: airship/land with birds 1 ]

; credits scene 5

        array_label ENDING_STATE, ENDING_STATE::LAND_BIRDS_1
@cd17:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsl     _c3d573
        jsr     _c3ca71
        jsr     InitCreditsFixedColorHDMA
        jsr     InitCreditsColorMathHDMA
        jsr     LoadCreditsSpritePal
        ldy     #$0028
        sty     zBG2VScroll
        ldy     #$ffcd
        sty     zc3
        ldy     #$030b
        sty     zc7
        ldy     #$f000
        sty     zc5
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        jsr     LoadCreditsBGPal
        jsr     _c3cb2e       ; create oscillating birds (land with airship)
        jsr     _c3cfdc
        longa
        lda     #near AirshipRightAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^AirshipRightAnim
        sta     wTaskProp::AnimBank,x
        lda     #$78
        sta     wTaskProp::PosX_H,x
        lda     #$58
        sta     wTaskProp::SpeedY_H,x
        ldy     #near CreditsScrollScene5
        lda     #^CreditsScrollScene5
        jsr     CreateMode7ScrollTask
        jsr     LoadCreditsTextScene5
        ldy     zZero
        sty     zcf
        lda     #2
        ldy     #near CreditsTextTaskScene5
        jsr     CreateTask
        lda     #3
        ldy     #near ScrollBG2Lefttask
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control task
        inc     zEndingState
        ldy     #20 * 60
        sty     zWaitCounter
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

_c3cd97:
@cd97:  lda     #2
        ldy     #near _c3cdea
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $15: airship with birds 2 ]

        array_label ENDING_STATE, ENDING_STATE::LAND_BIRDS_2
@cda0:  ldy     zWaitCounter
        bne     @cde9
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        ldy     #30 * 60
        sty     zWaitCounter
        jsr     _c3cd97
        lda     #$00
        sta     wTaskProp::PosX_H,x
        lda     #$50
        sta     wTaskProp::PosY_H,x
        jsr     _c3cd97
        lda     #$18
        sta     wTaskProp::PosX_H,x
        lda     #$40
        sta     wTaskProp::PosY_H,x
        jsr     _c3cd97
        lda     #$40
        sta     wTaskProp::PosX_H,x
        lda     #$68
        sta     wTaskProp::PosY_H,x
        jsr     _c3cd97
        lda     #$10
        sta     wTaskProp::PosX_H,x
        lda     #$48
        sta     wTaskProp::PosY_H,x
@cde9:  rts

; ------------------------------------------------------------------------------

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_22
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_23

; ------------------------------------------------------------------------------

; [  ]

_c3cdea:
@cdea:  tax
        jmp     (near _c3cdee,x)

_c3cdee:
@cdee:  .addr   _c3ce00,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f,_c3ce1f
        .addr   _c3ce33

; ------------------------------------------------------------------------------

_c3ce00:
@ce00:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #near _cff74f      ; cf/f74f (bird 4)
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^_cff74f
        sta     near wTaskProp::AnimBank,x
        stz     near wTaskProp::w7e35c9,x
        jsr     _c3ce43
        ldx     zTaskOffset
        jsr     InitAnimTask

_c3ce1f:
@ce1f:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @ce2b
        jsr     _c3ce43
        ldx     zTaskOffset
@ce2b:  jsr     DecTaskCounter
        jsr     UpdateEndingAnimTask
        sec
        rts

_c3ce33:
@ce33:  jsr     UpdateEndingAnimTask
        ldx     zTaskOffset
        lda     near wTaskProp::PosX_H,x
        cmp     #$01
        bcs     @ce41
        clc
        rts
@ce41:  sec
        rts

; ------------------------------------------------------------------------------

_c3ce43:
@ce43:  ldy     zTaskOffset
        tyx
        clr_a
        lda     near wTaskProp::w7e35c9,y
        inc     near wTaskProp::w7e35c9,x
        inc     near wTaskProp::State,x
        asl3
        longa
        tax
        lda     f:_c3ce6e,x
        sta     near wTaskProp::SpeedX,y
        lda     f:_c3ce6e+2,x
        sta     near wTaskProp::SpeedY,y
        lda     f:_c3ce6e+4,x
        sta     near wTaskProp::w7e3349,y
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

        array_label ENDING_STATE, ENDING_STATE::LAND_1
@cea6:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        jsl     _c3d573
        jsr     InitMode7Scroll
        jsl     _d4cb8f
        ldy     #$1800
        sty     zc5
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsBGPal
        ldy     #near CreditsScrollScene6
        lda     #^CreditsScrollScene6
        jsr     CreateMode7ScrollTask
        jsr     LoadCreditsTextScene6
        ldy     zZero
        sty     zcf
        lda     #2
        ldy     #near CreditsTextTaskScene6
        jsr     CreateTask
        jsr     _c3d2a0       ; create camera control task
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        ldy     #60 * 60
        sty     zWaitCounter
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_25
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_26
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_27

; ------------------------------------------------------------------------------

; [ cinematic state $1c: big airship ]

; credits scene 7

        array_label ENDING_STATE, ENDING_STATE::BIG_AIRSHIP
@ceec:  jsl     InitHWRegsCredits
        jsl     _c3d573
        jsr     _c3d144
        jsr     _c3ca71
        jsr     InitCreditsFixedColorHDMA
        jsr     InitCreditsColorMathHDMA
        ldy     #$0100
        sty     zc5
        ldy     #$02dc
        sty     zc7
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
        ldy     #$0010
        sty     zBG2VScroll
        jsr     _c3d15c       ; clear credits text palettes
        jsr     LoadCreditsSpritePal
        jsr     LoadCreditsBGPal
        jsr     LoadCreditsTextScene7
        ldy     zZero
        sty     zcf
        lda     #2
        ldy     #near CreditsTextTaskScene7
        jsr     CreateTask
        lda     #0
        ldy     #near _c3cf9a      ; bg scrolling task (big airship)
        jsr     CreateTask
        jsr     InitAirshipPropellerLeftAnim
        lda     #$14
        sta     wTaskProp::SpeedY_H,x
        lda     #$44
        sta     wTaskProp::PosX_H,x
        jsr     InitAirshipPropellerRightAnim
        lda     #$14
        sta     wTaskProp::SpeedY_H,x
        lda     #$ac
        sta     wTaskProp::PosX_H,x
        jsr     InitAirshipPropellerLeftAnim
        lda     #$e8
        sta     wTaskProp::SpeedY_H,x
        lda     #$60
        sta     wTaskProp::PosX_H,x
        jsr     InitAirshipPropellerRightAnim
        lda     #$e8
        sta     wTaskProp::SpeedY_H,x
        lda     #$90
        sta     wTaskProp::PosX_H,x
        jsr     _c3cfdc       ; create airship position task (no water splash)
        longa
        lda     #near BigAirshipAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^BigAirshipAnim
        sta     wTaskProp::AnimBank,x
        lda     #$48
        sta     wTaskProp::PosX_H,x
        lda     #$f8
        sta     wTaskProp::SpeedY_H,x
        lda     #ENDING_STATE::FADE_ENDING
        sta     zEndingState
        ldy     #37 * 60
        sty     zWaitCounter
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ bg scrolling task (big airship) ]

_c3cf9a:
@cf9a:  lda     zFrameCounter
        and     #%1111111
        bne     @cfa2
        inc     zBG2VScroll
@cfa2:  lda     zFrameCounter
        and     #$01
        bne     @cfb0
        longa
        dec     zM7Y         ; decrement bg1 v-scroll every 2 frames
        dec     zBG1VScroll
        shorta
@cfb0:  sec
        rts

; ------------------------------------------------------------------------------

; [ create big airship propeller task (left side, cw) ]

InitAirshipPropellerLeftAnim:
@cfb2:  jsr     _c3cfdc
        lda     #^AirshipPropellerLeftAnim
        sta     wTaskProp::AnimBank,x
        longa
        lda     #near AirshipPropellerLeftAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create big airship propeller task (right side, ccw) ]

InitAirshipPropellerRightAnim:
@cfc7:  jsr     _c3cfdc
        lda     #^AirshipPropellerRightAnim
        sta     wTaskProp::AnimBank,x
        longa
        lda     #near AirshipPropellerRightAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create airship position task (no water splash) ]

_c3cfdc:
@cfdc:  lda     #2
        ldy     #near _c3cff8      ; airship position task (no water splash)
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ decrement task counter ]

DecTaskCounter:
@cfe5:  ldx     zTaskOffset
        longa
        dec     near wTaskProp::w7e3349,x     ; decrement counter
        shorta
        rts

; ------------------------------------------------------------------------------

; [ set task counter ]

; unused

@cfef:  longa
        tya
        sta     near wTaskProp::w7e3349,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ airship position task (no water splash) ]

_c3cff8:
@cff8:  tax
        jmp     (near _c3cffc,x)

_c3cffc:
@cffc:  .addr   _c3d000, _c3d00b

; ------------------------------------------------------------------------------

_c3d000:
@d000:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        stz     near wTaskProp::w7e3349,x
        jsr     InitAnimTask

_c3d00b:
@d00b:  ldx     zTaskOffset
        jsr     _c3cbff       ; update airship position (sine)
        inc     near wTaskProp::w7e3349,x
        jsr     UpdateAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $1d-$1f:  ]

; unused

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_29
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_30
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_31

; ------------------------------------------------------------------------------

; [  ]

_c3d018:
@d018:  lda     #^_c2959c
        ldy     #near wPalBuf::BGPal0
        ldx     #near _c2959c
        jsr     LoadPal
        lda     #^_c2959c
        ldy     #near wPalBuf::BGPal1
        ldx     #near _c2959c
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $20: airship with jet trails 1 ]

        array_label ENDING_STATE, ENDING_STATE::BIG_JET_1
@d02f:  jsl     InitHWRegsCredits
        jsr     _c3c59f
        lda     #$80
        sta     hM7SEL
        jsr     _c3d60a
        jsr     InitMode7Scroll
        jsl     _d4ce55
        lda     #^_c29754
        ldy     #near wPalBuf::SpritePal4
        ldx     #near _c29754
        jsr     LoadPal
        lda     #^_c2974c
        ldy     #near wPalBuf::SpritePal5
        ldx     #near _c2974c
        jsr     LoadPal
        jsr     LoadCreditsBGPal
        jsr     _c3d018
        ldy     #$0001
        sty     zM7A
        sty     zM7D
        ldy     #$0008
        sty     zM7X
        ldy     #$0018
        sty     zM7Y
        ldy     #$ffd8
        sty     zBG1HScroll
        ldy     #$ffd0
        sty     zBG1VScroll
        lda     #0
        ldy     #near _c3d122
        jsr     CreateTask
        inc     zEndingState
        ldy     #2 * 60 + 30
        sty     zWaitCounter
        lda     #0
        ldy     #near _c3d0a8
        jsr     CreateTask
        jmp     CreateEndingFadeInTask

; ------------------------------------------------------------------------------

; [ cinematic state $21: airship with jet trails 2 ]

        array_label ENDING_STATE, ENDING_STATE::BIG_JET_2
@d096:  ldy     zWaitCounter
        bne     @d0a7
        stz     zEndingState            ; ENDING_STATE::FADE_OUT
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e16b
        jsr     _c3e241
@d0a7:  rts

; ------------------------------------------------------------------------------

; [ airship with jet trails animation task ]

_c3d0a8:
@d0a8:  lda     zFrameCounter
        and     #%1
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

; [ transfer animated tile for airship with jet trails animation ]

_c3d0d0:
@d0d0:  ldy     #$0283
        sty     zDMA1Dest
        ldy     #$9849
        sty     zDMA1Src
        ldy     #$0206
        sty     zDMA2Dest
        ldy     #$984a
        sty     zDMA2Src
        lda     #$7e
        sta     zDMA1Src_B
        sta     zDMA2Src_B
        ldy     #1
        sty     zDMA1Size
        sty     zDMA2Size
        rts

; ------------------------------------------------------------------------------

; [ airship above clouds animation task ]

_c3d0f2:
@d0f2:  lda     zFrameCounter
        and     #%1
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

; [ transfer animated tile for airship above clouds animation ]

_c3d10e:
@d10e:  ldy     #$0892
        sty     zDMA1Dest
        ldy     #$9849
        sty     zDMA1Src
        lda     #$7e
        sta     zDMA1Src_B
        ldy     #1                      ; transfer 1 byte
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $22-$24:  ]

; unused

        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_34
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_35
        array_label ENDING_STATE, ENDING_STATE::ENDING_STATE_36

_c3d122:
@d122:  jsr     _c3d127
        sec
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d127:
@d127:  lda     zFrameCounter
        and     #%111
        bne     @d137       ; branch 7 out of 8 frames
        ldy     zM7Y
        dey
        sty     zM7Y
        ldy     zM7X
        iny
        sty     zM7X
@d137:  longa
        inc     zM7A
        inc     zM7A
        inc     zM7D
        inc     zM7D
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d144:
@d144:  ldy     #$d7ba
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0580
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$6c00
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ clear credits text palettes ]

_c3d15c:
@d15c:  lda     #^BlackPal
        ldy     #near wPalBuf::SpritePal4
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::SpritePal5
        ldx     #near BlackPal
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ load credits bg palettes ]

LoadCreditsBGPal:
@d173:  lda     #^_c295bc
        ldy     #near wPalBuf::BGPal1
        ldx     #near _c295bc
        jsr     LoadPal
        lda     #^_c295dc
        ldy     #near wPalBuf::BGPal2
        ldx     #near _c295dc
        jsr     LoadPal
        lda     #^_c295fc
        ldy     #near wPalBuf::BGPal3
        ldx     #near _c295fc
        jsr     LoadPal
        lda     #^_c2961c
        ldy     #near wPalBuf::BGPal4
        ldx     #near _c2961c
        jsr     LoadPal
        lda     #^_c2963c
        ldy     #near wPalBuf::BGPal6
        ldx     #near _c2963c
        jsr     LoadPal
        lda     #^_c2965c
        ldy     #near wPalBuf::BGPal7
        ldx     #near _c2965c
        jsr     LoadPal
        rts

; ------------------------------------------------------------------------------

; [ scroll bg3 down task ]

_c3d1b6:
@d1b6:  ldy     zcf
        cpy     z64
        beq     @d1ca
        lda     zFrameCounter
        and     #%11
        bne     @d1c8
        longa
        dec     zBG3VScroll
        shorta
@d1c8:  sec
        rts
@d1ca:  clc
        rts

; ------------------------------------------------------------------------------

; [ fade in task ]

EndingFadeInTask:
@d1cc:  tax
        jmp     (near EndingFadeInTaskTbl,x)

EndingFadeInTaskTbl:
@d1d0:  .addr   EndingFadeInTask_00
        .addr   EndingFadeInTask_01

; ------------------------------------------------------------------------------

; 0: init
EndingFadeInTask_00:
@d1d4:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     #$01
        sta     near wTaskProp::PosY_H,x
        lda     #$0f
        sta     near wTaskProp::w7e3349,x

; 1: update
EndingFadeInTask_01:
@d1e3:  ldx     zTaskOffset
        lda     near wTaskProp::w7e3349,x
        beq     @d1f7
        lda     near wTaskProp::PosY_H,x
        sta     zScreenBrightness
        inc     near wTaskProp::PosY_H,x
        dec     near wTaskProp::w7e3349,x
        sec
        rts
@d1f7:  lda     #$0f        ; screen on, full brightness
        sta     zScreenBrightness
        clc
        rts

; ------------------------------------------------------------------------------

; [ fade out task ]

EndingFadeOutTask:
@d1fd:  tax
        jmp     (near EndingFadeOutTaskTbl,x)

EndingFadeOutTaskTbl:
@d201:  .addr   EndingFadeOutTask_00
        .addr   EndingFadeOutTask_01

; ------------------------------------------------------------------------------

; state 0: init
EndingFadeOutTask_00:
@d205:  ldx     zTaskOffset
        inc     near wTaskProp::State,x     ; increment task state
        lda     #$0f
        sta     near wTaskProp::PosX_H,x     ; set initial screen brightness to full

; state 1: update
EndingFadeOutTask_01:
@d20f:  ldy     zWaitCounter         ; terminate when wait counter reaches zero
        beq     @d21f
        ldx     zTaskOffset
        lda     near wTaskProp::PosX_H,x
        sta     zScreenBrightness
        dec     near wTaskProp::PosX_H,x     ; decrement screen brightness
        sec
        rts
@d21f:  lda     #$80        ; screen off
        sta     zScreenBrightness
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
        ldy     #near Mode7ScrollTask
        jsr     CreateTask
        longa
        ply
        tya
        sta     wTaskProp::AnimPtr,x
        shorta
        pla
        sta     wTaskProp::AnimBank,x
        rts

; ------------------------------------------------------------------------------

; [ mode 7 scrolling task ]

Mode7ScrollTask:
@d23f:  tax
        jmp     (near Mode7ScrollTaskTbl,x)

Mode7ScrollTaskTbl:
@d243:  .addr   Mode7ScrollTask_00
        .addr   Mode7ScrollTask_01

; ------------------------------------------------------------------------------

Mode7ScrollTask_00:
@d247:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        jsr     InitAnimTask

Mode7ScrollTask_01:
@d24f:  ldx     zTaskOffset
        jsr     UpdateAnimData
        clr_a
        lda     near wTaskProp::w7e36c9,x          ; data pointer
        tay
        longa
        lda     [zeb],y                 ; buttons pressed
        sta     zRawCtrlState
        shorta
        sec
        rts

; ------------------------------------------------------------------------------

; [ update mode 7 registers ]

UpdateMode7Regs:
@d263:  lda     zM7A
        sta     hM7A
        lda     zM7A + 1
        sta     hM7A

        lda     zM7B
        sta     hM7B
        lda     zM7B + 1
        sta     hM7B

        lda     zM7C
        sta     hM7C
        lda     zM7C + 1
        sta     hM7C

        lda     zM7D
        sta     hM7D
        lda     zM7D + 1
        sta     hM7D

        lda     zM7X
        sta     hM7X
        lda     zM7X + 1
        sta     hM7X

        lda     zM7Y
        sta     hM7Y
        lda     zM7Y + 1
        sta     hM7Y
        rts

; ------------------------------------------------------------------------------

; [ create camera control task ]

_c3d2a0:
@d2a0:  lda     #0
        ldy     #near _c3d2a9
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ camera control task ]

_c3d2a9:
@d2a9:  lda     zRawCtrlState_L
        bit     #JOY_R
        beq     @d2b7       ; branch if R button not pressed
        longa
        inc     zc3
        shorta
        inc     zCursorWrap
@d2b7:  lda     zRawCtrlState_L
        bit     #JOY_L
        beq     @d2c5       ; branch if L button not pressed
        longa
        dec     zc3
        shorta
        dec     zCursorWrap
@d2c5:  lda     zRawCtrlState_L
        bit     #JOY_X
        beq     @d2d1       ; branch if X button not pressed
        longa
        inc     zc7         ; increase tilt angle
        shorta
@d2d1:  lda     zRawCtrlState_H
        bit     #>JOY_Y
        beq     @d2dd       ; branch if Y button not pressed
        longa
        dec     zc7         ; decrease tilt angle
        shorta
@d2dd:  lda     zRawCtrlState_L
        bit     #JOY_A
        beq     @d2e5       ; branch if A button not pressed
        inc     zc5_H         ; zoom in
@d2e5:  lda     zRawCtrlState_H
        bit     #>JOY_B
        beq     @d2ed       ; branch if B button not pressed
        dec     zc5_H         ; zoom out
@d2ed:  lda     zRawCtrlState_H
        bit     #>JOY_UP
        beq     @d2fb       ; branch if up button not pressed
        longa
        dec     zM7Y         ; decrement y position
        dec     zBG1VScroll
        shorta
@d2fb:  lda     zRawCtrlState_H
        bit     #>JOY_DOWN
        beq     @d309       ; branch if down button not pressed
        longa
        inc     zM7Y         ; increment y position
        inc     zBG1VScroll
        shorta
@d309:  lda     zRawCtrlState_H
        bit     #>JOY_LEFT
        beq     @d317       ; branch if left button not pressed
        longa
        dec     zM7X         ; decrement x position
        dec     zBG1HScroll
        shorta
@d317:  lda     zRawCtrlState_H
        bit     #>JOY_RIGHT
        beq     @d325       ; branch if right button not pressed
        longa
        inc     zM7X         ; increment x position
        inc     zBG1HScroll
        shorta
@d325:  jsr     _c3d338       ; clip x & y position
        longa
        lda     zRawCtrlState
        and     #near ~JOY_DIR_MASK
        shorta
        beq     @d336       ; branch if no buttons are pressed
        jsr     UpdateMode7HDMA
.if !LANG_EN
        jsr     _c3e2bf
.endif
@d336:  sec
        rts

; ------------------------------------------------------------------------------

.if !LANG_EN

_c3e2bf:
@e2bf:  ldy     $07c2
        sty     $07c4
        ldy     $0984
        sty     $0986
        ldy     $0b46
        sty     $0b48
        ldy     $0602
        sty     zM7A
        sty     zM7D
        ldy     $07c4
        sty     zM7B
        ldy     $0986
        sty     zM7C
        rts
.endif

; ------------------------------------------------------------------------------

; [ clip x & y position ]

_c3d338:
@d338:  longa
        lda     zM7X
        and     #$1fff      ; max $1fff
        sta     zM7X
        lda     zM7Y
        and     #$1fff
        sta     zM7Y
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init hdma (big airship) ]

InitBigAirshipMode7HDMA:
@d34b:  jsl     _d4cb8f
        stz     hDMA1::CTRL
        lda     #<hBGMODE
        sta     hDMA1::HREG
        ldy     #near BigAirshipMode7HDMATbl
        sty     hDMA1::ADDR
        lda     #^BigAirshipMode7HDMATbl
        sta     hDMA1::ADDR_B
        sta     hDMA1::HDMA_B
        lda     #BIT_1
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; bg mode hdma table for big airship (mode 1 for 71 scanlines, then mode 7 for the remainder)
BigAirshipMode7HDMATbl:
        hdma_byte 71, 1
        hdma_byte 1, 7
        hdma_end

; ------------------------------------------------------------------------------

; [ init color math hdma (credits) ]

InitCreditsColorMathHDMA:
@d36f:  lda     #$01
        sta     hDMA3::CTRL
        lda     #<hCGSWSEL
        sta     hDMA3::HREG
        ldy     #near CreditsColorMathHDMATbl
        sty     hDMA3::ADDR
        lda     #^CreditsColorMathHDMATbl
        sta     hDMA3::ADDR_B
        sta     hDMA3::HDMA_B
        lda     #BIT_3
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

; [ init fixed color hdma (credits) ]

InitCreditsFixedColorHDMA:
@d38c:  stz     hDMA2::CTRL
        lda     #<hCOLDATA
        sta     hDMA2::HREG
        ldy     #near CreditsFixedColorHDMATbl
        sty     hDMA2::ADDR
        lda     #^CreditsFixedColorHDMATbl
        sta     hDMA2::ADDR_B
        sta     hDMA2::HDMA_B
        lda     #BIT_2
        tsb     zEnableHDMA
        rts

; ------------------------------------------------------------------------------

CreditsColorMathHDMATbl:
        hdma_byte 71, $80
        hdma_byte 65, $01
        hdma_byte 130, $01
        hdma_end

CreditsFixedColorHDMATbl:
        hdma_byte 71, $e0
        hdma_byte 1, $ed
        hdma_byte 1, $eb
        hdma_byte 1, $ea
        hdma_byte 2, $e9
        hdma_byte 3, $e8
        hdma_byte 4, $e7
        hdma_byte 5, $e6
        hdma_byte 6, $e5
        hdma_byte 7, $e4
        hdma_byte 8, $e3
        hdma_byte 12, $e2
        hdma_byte 15, $e1
        hdma_byte 30, $e0
        hdma_end

; ------------------------------------------------------------------------------

.if LANG_EN

; unused

@d3cb:  stz     hDMA2::CTRL
        lda     #<hCOLDATA
        sta     hDMA2::HREG
        ldy     #$9849
        sty     hDMA2::ADDR
        lda     #$7e
        sta     hDMA2::ADDR_B
        sta     hDMA2::HDMA_B
        lda     #BIT_2
        tsb     zEnableHDMA
        rts
.endif

; ------------------------------------------------------------------------------

; [ init mode 7 scrolling data ]

InitMode7Scroll:
@d3e6:  ldy     #$0100
        sty     zM7X
        ldy     #$0080
        sty     zM7Y
        sty     zBG1HScroll
        clr_ay
        sty     zBG1VScroll
        stz     z58
        lda     #$40
        sta     zCursorWrap
        ldy     #$0000
        sty     zc7
        ldy     #$0100
        sty     zc5
        ldy     #$0000
        sty     zc3
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
        stx     zf1
        lda     #$7e
        sta     zf3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [ load credits font graphics ]

LoadCreditsFontGfx:
@d439:  ldy     #near EndingFontGfx
        lda     #^EndingFontGfx
        jsr     Decompress
        jsr     _c3d497
        ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0c00
        sty     zeb
        ldy     #$7000
        jsr     TfrGfx2bpp
.if LANG_EN
        ldy     #near (SmallFontGfx + $0800)
.else
        ldy     #near (SmallFontGfx + $0200)
.endif
        sty     ze7
        lda     #^SmallFontGfx
        sta     ze9
        ldy     #$0200                  ; 32 tiles
        sty     zeb
        ldy     #$7e00
.if LANG_EN
        jsr     TfrGfx2bpp
        jmp     _c3d46f                 ; load punctuation graphics
.else
        jmp     TfrGfx2bpp
.endif

; ------------------------------------------------------------------------------

.if LANG_EN

; [ load punctuation graphics ]

_c3d46f:

@PeriodGfx := SmallFontGfx + $0c50
@SpaceGfx := SmallFontGfx + $0ff0

@d46f:  ldy     #near @PeriodGfx
        sty     ze7
        lda     #^@PeriodGfx
        sta     ze9
        ldy     #16                     ; 1 tile
        sty     zeb
        ldy     #$7fa0
        jsr     TfrGfx2bpp
        ldy     #near @SpaceGfx
        sty     ze7
        lda     #^@SpaceGfx
        sta     ze9
        ldy     #16                     ; 1 tile
        sty     zeb
        ldy     #$7fb0
        jmp     TfrGfx2bpp

.endif

; ------------------------------------------------------------------------------

; [  ]

_c3d497:
@d497:  phb
        lda     #$7e
        pha
        plb
        ldx     zZero
        txy
@d49f:  phx
        clr_a
        lda     f:_c29854,x
        longa
        asl4
        tax
        shorta
        lda     #$10
        sta     ze0
@d4b2:  lda     $c000,x
        sta     $c400,y
        inx
        iny
        dec     ze0
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
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$4000
        jsr     EndingTfrVRAM
        longa
        lda     f:WorldBackdropTilesPtr
        tay
        shorta
        lda     f:WorldBackdropTilesPtr+2
        jsr     Decompress
        ldy     #$2000
        sty     zed
        jsr     _c3d518
        ldy     #$0400
        sty     zeb
        ldy     #$5000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [  ]

_c3d518:
@d518:  ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
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
        stx     zf1
        lda     #$7e
        sta     zf3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d552:
@d552:  stz     ze4
        stz     ze5
        lda     #$80
        sta     zed
        ldx     #$9800
        lda     #$7f
        jmp     _c3d74f

; ------------------------------------------------------------------------------

; [  ]

_c3d562:
@d562:  ldx     #$0080
        stx     ze4
        lda     #$80
        sta     zed
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
        stx     zf1
        lda     #$7e
        sta     zf3
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
        stx     zf1
        lda     #$7f
        sta     zf3
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
        stx     zf1
        lda     #$7f
        sta     zf3
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
        stx     zf1
        lda     #$7f
        sta     zf3
        jmp     _c3d706

; ------------------------------------------------------------------------------

; [  ]

_c3d634:
@d634:  ldy     #$b800
        sty     ze7
        lda     #$7f
        sta     ze9
        stz     zed
        stz     zee
        ldy     #$4000
        sty     zeb
        ldy     #$0000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [  ]

_c3d64c:
@d64c:  ldy     #$b800
        sty     ze7
        lda     #$7f
        sta     ze9
        stz     zed
        stz     zee
        ldy     #$4000
        sty     zeb
        ldy     #$2000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load credits palette assignments (land/sea) ]

_c3d664:
@d664:  ldx     #near _cff9e1      ; palette assignment
        lda     #^_cff9e1
        bra     _d670

; ------------------------------------------------------------------------------

; [ load credits palette assignments (airship/clouds) ]

_c3d66b:
@d66b:  ldx     #near _cff969      ; palette assignment
        lda     #^_cff969
_d670:  stx     z91
        sta     z93
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d675:
@d675:  ldx     #near _cffae9
        lda     #^_cffae9
_d67a:  stx     zf7
        sta     zf9
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d67f:
@d67f:  ldx     #near _cffac9
        lda     #^_cffac9
        bra     _d67a

; ------------------------------------------------------------------------------

; [  ]

_c3d686:
@d686:  ldx     #near _cffaa9
        lda     #^_cffaa9
        bra     _d67a

; ------------------------------------------------------------------------------

; [  ]

_c3d68d:
@d68d:  ldx     #near _cffb09
        lda     #^_cffb09
        bra     _d67a

; ------------------------------------------------------------------------------

; [ load credits graphics (land/sea) ]

InitCreditsGfxLandSea:
@d694:  jsr     LoadCreditsGfx
        ldx     #$141a      ; credits graphics (land/sea)
        stx     ze7
        lda     #$7f
        sta     ze9
        ldy     #$9800
        sty     zeb
        lda     #$7f
        sta     zed
        ldy     #$18e0
        sty     zef
        jmp     CopyCreditsGfx

; ------------------------------------------------------------------------------

; [ load credits graphics (clouds/airship) ]

InitCreditsGfxClouds:
@d6b1:  jsr     LoadCreditsGfx
        ldx     #$ed3a      ; credits graphics (clouds/airship)
        stx     ze7
        lda     #$7e
        sta     ze9
        ldy     #$9800
        sty     zeb
        lda     #$7f
        sta     zed
        ldy     #$0ee0
        sty     zef
        jmp     CopyCreditsGfx

; ------------------------------------------------------------------------------

; [ load ending credits graphics data ]

LoadCreditsGfx:
@d6ce:  ldy     #near CreditsGfx
        lda     #^CreditsGfx
        jmp     Decompress

; ------------------------------------------------------------------------------

; [  ]

_c3d6d6:
@d6d6:  ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$17ba      ; size = $17ba
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ copy data (ram -> ram) ]

; ++$e7: source address
; ++$eb: destination address
;  +$ef: size
;  +$f1: constant to add to each word

CopyCreditsGfx:
@d6ee:  stz     zf1
        stz     zf2
        longa
        ldy     zZero
@d6f6:  lda     [ze7],y
        clc
        adc     zf1
        sta     [zeb],y
        iny2
        cpy     zef
        bne     @d6f6
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d706:
@d706:  clr_ay
@d708:  longa
        lda     [zf7],y
        tax
        iny2
        lda     [zf7],y
        sta     ze7
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
        sta     ze0
@d72c:  lda     #$20
        sta     ze1
        ldx     ze7
@d732:  lda     [zf1],y
        sta     $b800,x
        iny
        inx2
        dec     ze1
        bne     @d732
        longa_clc
        lda     ze7
        adc     #$0100
        sta     ze7
        shorta
        dec     ze0
        bne     @d72c
        plb
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3d74f:
@d74f:  sta     ze9
        stx     ze7
        phb
        lda     #$7f
        pha
        plb
        clr_ax
@d75a:  lda     #$08
        sta     ze6
@d75e:  longa
        ldy     #$0010
        lda     [ze7]
        sta     zf1
        lda     [ze7],y
        sta     zef
        shorta0
        ldy     #$0008
@d771:  clr_a
        asl     zf0
        rol
        asl     zef
        rol
        asl     zf2
        rol
        asl     zf1
        rol
        and     #$0f
        beq     @d792
        sta     ze0
        phy
        ldy     ze4
        lda     [z91],y
        ply
        asl4
        and     #$f0
        ora     ze0
@d792:  sta     $b801,x
        inx2
        dey
        bne     @d771
        ldy     ze7
        iny2
        sty     ze7
        dec     ze6
        bne     @d75e
        longa
        inc     ze4
        lda     ze7
        clc
        adc     #$0010
        sta     ze7
        shorta0
        dec     zed
        bne     @d75a
        plb
        rts

; ------------------------------------------------------------------------------

; [ credits text task (airship above water) ]

.proc CreditsTextTaskScene1
        phb
        lda     #^*
        pha
        plb
        ldy     zcf
        cpy     #60
        bne     :+
        jsr     DrawCreditsTextScene1Page1
:       plb
        sec
        rts
.endproc  ; CreditsTextTaskScene1

; ------------------------------------------------------------------------------

; [ credits text task (tiny airship) ]

.proc CreditsTextTaskScene2
        phb
        lda     #^*
        pha
        plb
        ldy     zcf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene2Page1
        bra     Done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene2Page2
        bra     Done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene2Page3
        bra     Done
:       cpy     #$04f6
        bne     :+
        jsr     DrawCreditsTextScene2Page4
        bra     Done
:       cpy     #$069a
        bne     :+
        jsr     DrawCreditsTextScene2Page5
        bra     Done
:       cpy     #$083e
        bne     :+
        jsr     DrawCreditsTextScene2Page6
        bra     Done
:       cpy     #$09e2
        bne     Done
        jsr     DrawCreditsTextScene2Page7
Done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene2

; ------------------------------------------------------------------------------

; [ credits text task (boat) ]

.proc CreditsTextTaskScene3
        phb
        lda     #^*
        pha
        plb
        ldy     zcf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene3Page1
        bra     Done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene3Page2
        bra     Done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene3Page3
        bra     Done
:       cpy     #$04f6
        bne     Done
        jsr     DrawCreditsTextScene3Page4
Done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene3

; ------------------------------------------------------------------------------

; [ credits text task (airship/sea) ]

.proc CreditsTextTaskScene4
        phb
        lda     #^*
        pha
        plb
        ldy     zcf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene4Page1
        bra     Done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene4Page2
        bra     Done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene4Page3
        bra     Done
:       cpy     #$04f6
        bne     :+
        jsr     DrawCreditsTextScene4Page4
        bra     Done
:       cpy     #$069a
        bne     :+
        jsr     DrawCreditsTextScene4Page5
        bra     Done
:       cpy     #$083e
        bne     :+
        jsr     DrawCreditsTextScene4Page6
        bra     Done
:       cpy     #$09e2
        bne     Done
        jsr     DrawCreditsTextScene4Page7
Done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene4

; ------------------------------------------------------------------------------

; [ credits text task (airship/land) ]

.proc CreditsTextTaskScene5
        phb
        lda     #^*
        pha
        plb
        ldy     zcf
        cpy     #10
        bne     :+
        jsr     DrawCreditsTextScene5Page1
        bra     Done
:       cpy     #$01ae
        bne     :+
        jsr     DrawCreditsTextScene5Page2
        bra     Done
:       cpy     #$0352
        bne     :+
        jsr     DrawCreditsTextScene5Page3
        bra     Done
:       cpy     #$04f6
        bne     :+
        jsr     DrawCreditsTextScene5Page4
        bra     Done
:       cpy     #$069a
        bne     :+
        jsr     DrawCreditsTextScene5Page5
        bra     Done
:       cpy     #$083e
        bne     :+
        jsr     DrawCreditsTextScene5Page6
        bra     Done
:       cpy     #$09e2
        bne     Done
        jsr     DrawCreditsTextScene5Page7
Done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene5

; ------------------------------------------------------------------------------

; [ credits text task (land) ]

.proc CreditsTextTaskScene6
        phb
        lda     #^*
        pha
        plb
        ldy     zcf
        cpy     #4 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page1
        bra     Done
:       cpy     #12 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page2
        bra     Done
:       cpy     #20 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page3
        bra     Done
:       cpy     #28 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page4
        bra     Done
:       cpy     #36 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page5
        bra     Done
:       cpy     #44 * 60
        bne     :+
        jsr     DrawCreditsTextScene6Page6
        bra     Done
:       cpy     #52 * 60
        bne     Done
        jsr     DrawCreditsTextScene6Page7
Done:   plb
        sec
        rts
.endproc  ; CreditsTextTaskScene6

; ------------------------------------------------------------------------------

; [ credits text task (big airship) ]

.proc CreditsTextTaskScene7
@d933:  phb
        lda     #^*
        pha
        plb
        ldy     zcf
.if ::LANG_EN
        cpy     #1 * 60
.else
        cpy     #4 * 60
.endif
        bne     :+
        jsr     DrawCreditsTextScene7Page1
        bra     Done
.if ::LANG_EN
:       cpy     #8 * 60
.else
:       cpy     #12 * 60
.endif
        bne     :+
        jsr     DrawCreditsTextScene7Page2
        bra     Done
.if ::LANG_EN
:       cpy     #15 * 60
.else
:       cpy     #20 * 60
.endif
        bne     :+
        jsr     DrawCreditsTextScene7Page3
        bra     Done
.if ::LANG_EN
:       cpy     #22 * 60
        bne     :+
        jsr     DrawCreditsTextScene7Page4
        bra     Done
:       cpy     #29 * 60
        bne     Done
        jsr     DrawCreditsTextScene7Page5
Done:   plb
        sec
        rts
.else
:       cpy     #28 * 60
        bne     Done
        jsr     DrawCreditsTextScene7Page4
Done:   plb
        sec
        rts
.endif

.endproc  ; CreditsTextTaskScene7

; ------------------------------------------------------------------------------

; [ draw credits text (airship above clouds) ]

LoadCreditsTextScene1:
@d96d:  ldx     #near SmallCreditsTextPtrs1      ; c2/9dc0 (producer)
        lda     #^SmallCreditsTextPtrs1
        ldy     #$0004      ; 1 string
        jsr     LoadSmallCreditsText
        ldx     #near BigCreditsTextPtrs1      ; c2/9c44 (hironobu sakaguchi)
        lda     #^BigCreditsTextPtrs1
        ldy     #$0008      ; 2 strings
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (tiny airship) ]

LoadCreditsTextScene2:
@d983:  ldx     #near SmallCreditsTextPtrs2
        lda     #^SmallCreditsTextPtrs2
        ldy     #$0028
        jsr     LoadSmallCreditsText
        ldx     #near BigCreditsTextPtrs2
        lda     #^BigCreditsTextPtrs2
        ldy     #$0060
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (boat) ]

LoadCreditsTextScene3:
@d999:  ldx     #near SmallCreditsTextPtrs3
        lda     #^SmallCreditsTextPtrs3
        ldy     #$0018
        jsr     LoadSmallCreditsText
        ldx     #near BigCreditsTextPtrs3
        lda     #^BigCreditsTextPtrs3
        ldy     #$0040
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (airship/sea) ]

LoadCreditsTextScene4:
@d9af:  ldx     #near SmallCreditsTextPtrs4
        lda     #^SmallCreditsTextPtrs4
        ldy     #$0020
        jsr     LoadSmallCreditsText
        ldx     #near BigCreditsTextPtrs4
        lda     #^BigCreditsTextPtrs4
        ldy     #$0064
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (airship/land) ]

LoadCreditsTextScene5:
@d9c5:  ldx     #near SmallCreditsTextPtrs5
        lda     #^SmallCreditsTextPtrs5
.if LANG_EN
        ldy     #$0024
.else
        ldy     #$0020
.endif
        jsr     LoadSmallCreditsText
        ldx     #near BigCreditsTextPtrs5
        lda     #^BigCreditsTextPtrs5
.if LANG_EN
        ldy     #$0070
.else
        ldy     #$0068
.endif
        jmp     LoadBigCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (land) ]

LoadCreditsTextScene6:
@d9db:  ldx     #near SmallCreditsTextPtrs6
        lda     #^SmallCreditsTextPtrs6
.if LANG_EN
        ldy     #$00e4
.else
        ldy     #$00e8
.endif
        jmp     LoadSmallCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (big airship) ]

LoadCreditsTextScene7:
@d9e6:  ldx     #near SmallCreditsTextPtrs7
        lda     #^SmallCreditsTextPtrs7
.if LANG_EN
        ldy     #$006c
.else
        ldy     #$0068
.endif
        jmp     LoadSmallCreditsText

; ------------------------------------------------------------------------------

; [ draw credits text (small font) ]

LoadSmallCreditsText:
@d9f1:  stx     z4a
        sta     z4c
        sty     z4d
        jmp     LoadSmallCreditsText2

; ------------------------------------------------------------------------------

; [ draw credits text (large font) ]

LoadBigCreditsText:
@d9fa:  stx     z4a
        sta     z4c
        sty     z4d
        jmp     LoadBigCreditsText2

; ------------------------------------------------------------------------------

; [ draw credits text ]

.mac draw_credits_sub scene, page
        .local sprites
        .define sprites .ident(.sprintf("CreditsSpritesScene%dPage%d", scene, page))

        .ident(.sprintf("DrawCreditsTextScene%dPage%d", scene, page)) := *
        ldy     #.sizeof(sprites)
        ldx     #near sprites
        lda     #^sprites
        jmp     CreateCreditsPageTasks
.endmac

        draw_credits_sub 1,1

        draw_credits_sub 2,1
        draw_credits_sub 2,2
        draw_credits_sub 2,3
        draw_credits_sub 2,4
        draw_credits_sub 2,5
        draw_credits_sub 2,6
        draw_credits_sub 2,7

        draw_credits_sub 3,1
        draw_credits_sub 3,2
        draw_credits_sub 3,3
        draw_credits_sub 3,4

        draw_credits_sub 4,1
        draw_credits_sub 4,2
        draw_credits_sub 4,3
        draw_credits_sub 4,4
        draw_credits_sub 4,5
        draw_credits_sub 4,6
        draw_credits_sub 4,7

        draw_credits_sub 5,1
        draw_credits_sub 5,2
        draw_credits_sub 5,3
        draw_credits_sub 5,4
        draw_credits_sub 5,5
        draw_credits_sub 5,6
        draw_credits_sub 5,7

        draw_credits_sub 6,1
        draw_credits_sub 6,2
        draw_credits_sub 6,3
        draw_credits_sub 6,4
        draw_credits_sub 6,5
        draw_credits_sub 6,6
        draw_credits_sub 6,7

        draw_credits_sub 7,1
        draw_credits_sub 7,2
        draw_credits_sub 7,3
        draw_credits_sub 7,4
.if LANG_EN
        draw_credits_sub 7,5
.endif

; ------------------------------------------------------------------------------

; [ create tasks for credits page sprites ]

;  A: source bank
; +X: source address
; +Y: word count * 4

CreateCreditsPageTasks:
@dba5:  sty     zfa
        stx     zf7
        sta     zf9
        ldy     zZero
@dbad:  longa
        lda     [zf7],y                 ; sprite data address (+$7e0000)
        tax
        iny2
        lda     [zf7],y                 ; xy position
        sta     z60
        shorta
        phy
        txy
        jsr     CreateCreditsTextTask
        ply
        iny2                            ; next word
        cpy     zfa
        bne     @dbad
        sec
        rts

; ------------------------------------------------------------------------------

; [ load credits text (small font) ]

; ++$4a: source
;  +$4d: word count * 4

LoadSmallCreditsText2:
@dbc8:  ldy     zZero
@dbca:  jsr     SetSmallCreditsSpriteFlags
        longa
        lda     [z4a],y     ; source
        tax
        iny2
        lda     [z4a],y     ; destination (+$7e0000)
        sta     ze7
        iny2
        phy
        ldy     ze7
        shorta
        jsr     LoadSmallCreditsWord
        ply
        cpy     z4d
        bne     @dbca
        rts

; ------------------------------------------------------------------------------

; [ load credits text (large font) ]

; ++$4a: source
;  +$4d: word count * 4

LoadBigCreditsText2:
@dbe8:  ldy     zZero
@dbea:  jsr     SetBigCreditsSpriteFlags
        longa
        lda     [z4a],y     ; +X = source
        tax
        iny2
        lda     [z4a],y     ; +$e7 = destination (+$7e0000)
        sta     ze7
        iny2
        phy
        ldy     ze7
        shorta
        jsr     LoadBigCreditsWord
        ply
        cpy     z4d
        bne     @dbea
        rts

; ------------------------------------------------------------------------------

; [ set sprite tile flags for credits text (small font) ]

SetSmallCreditsSpriteFlags:
@dc08:  ldx     #$0b00      ; palette 2, tile offset $0300
        stx     zf1
        rts

; ------------------------------------------------------------------------------

; [ set sprite tile flags for credits text (big font) ]

SetBigCreditsSpriteFlags:
@dc0e:  ldx     #$0900      ; palette 2, tile offset $0100
        stx     zf1
        rts

; ------------------------------------------------------------------------------

; [ create credits text task ]

; $60: x position
; $61: y position

CreateCreditsTextTask:
@dc14:  sty     zf1
        stz     zaf
        lda     #0
        ldy     #near CreditsTextTask
        jsr     CreateTask
        longa
        lda     zf1
        sta     wTaskProp::AnimPtr,x
        lda     #7*60
        sta     wTaskProp::w7e3349,x               ; frame counter (7.0s)
        shorta
        lda     #$7e
        sta     wTaskProp::AnimBank,x
        lda     z60
        sta     wTaskProp::PosX_H,x
        lda     z60 + 1
        sta     wTaskProp::PosY_H,x
        rts

; ------------------------------------------------------------------------------

; [ credits text task ]

; creates sprites for one word of credits text
; sprites move up and fade in, wait, then fade out

CreditsTextTask:
@dc44:  tax
        jmp     (near CreditsTextTaskTbl,x)

CreditsTextTaskTbl:
@dc48:  .addr   CreditsTextTask_00
        .addr   CreditsTextTask_01

; ------------------------------------------------------------------------------

; state 0: init
CreditsTextTask_00:
@dc4c:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     near wTaskProp::PosY_H,x     ; y position
        clc
        adc     #$20
        sta     near wTaskProp::PosY_H,x
        longa
        lda     #$ff80
        sta     near wTaskProp::SpeedY,x     ; vertical speed
        stz     near wTaskProp::SpeedX,x     ; horizontal speed
        shorta
        jsr     InitAnimTask
        lda     zaf         ; branch if credits palette is already fading in
        bne     CreditsTextTask_01
        phb
        lda     #$00
        pha
        plb
        lda     zb4
        bne     @dc7c       ; branch if not using inverse credits palette
        jsr     _c3c703       ; fade in inverse credits palette
        bra     @dc7f
@dc7c:  jsr     _c3c72a       ; fade in normal credits palette
@dc7f:  lda     #1
        sta     zaf         ; disable credits palette fade in
        plb

; state 1: update
CreditsTextTask_01:
@dc84:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x     ; frame counter
        beq     @dca9
        cpy     #$0164      ; stop scrolling after 1.067s
        bne     @dc96
        stz     near wTaskProp::SpeedY,x
        stz     near wTaskProp::SpeedY_H,x
@dc96:  cpy     #$0080      ; start fade out after 4.867s
        beq     @dcab
@dc9b:  jsr     UpdateEndingAnimTask
        ldx     zTaskOffset
        longa
        dec     near wTaskProp::w7e3349,x
        shorta
        sec
        rts
@dca9:  clc
        rts
@dcab:  lda     zaf
        beq     @dc9b       ; branch if credits palette is already fading out
        stz     zaf
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
        lda     ze0
        clc
        adc     #8                      ; increment x position
        sta     ze0
        bra     @dcc2
@dcd0:  rts

; ------------------------------------------------------------------------------

; [ load string (big font) ]

LoadBigCreditsWord:
@dcd1:  jsr     CalcCreditsWordLength
        jsr     InitCreditsString
@dcd7:  clr_a
        lda     [ze7]
        beq     @dd01                   ; branch if '\0'
        sta     ze3
        lda     ze0
        ora     #$80                    ; use a 16x16 sprite
        sta     [zeb],y                 ; x-position
        iny
        clr_a
        sta     [zeb],y                 ; y-position
        iny
        clr_a
        lda     ze3
        longa_clc
        adc     zf1
        sta     [zeb],y                 ; vhoopppm mmmmmmmm
        inc     ze7
        iny2
        shorta
        lda     ze0
        clc
        adc     #8                      ; increment x position
        sta     ze0
        bra     @dcd7
@dd01:  rts

; ------------------------------------------------------------------------------

; [ load letter (small font) ]

LoadSmallCreditsSprite:
@dd02:  clr_a
        lda     [ze7]                   ; letter tile
        beq     @dd23                   ; branch if terminator
        sta     ze3
        lda     ze0
        sta     [zeb],y                 ; x position
        iny
        clr_a
        sta     [zeb],y                 ; y position
        iny
        clr_a
        lda     ze3
        longa_clc
        adc     zf1                     ; set tile flags
        sta     [zeb],y                 ; vhoopppm mmmmmmmm
        inc     ze7
        iny2
        shorta
        sec
        rts
@dd23:  clc                             ; clear carry if '\0'
        rts

; ------------------------------------------------------------------------------

; [ init string ]

InitCreditsString:
@dd25:  ldy     zZero
        sta     [zeb],y     ; string length
        iny
        stz     ze0         ; x-position
        stz     zef
        stz     zf0
        rts

; ------------------------------------------------------------------------------

; [ get word length ]

CalcCreditsWordLength:
@dd31:  stx     ze7
        lda     #^CreditsText
        sta     ze9
        sty     zeb
        lda     #$7e
        sta     zed
        longa_clc
        lda     zeb
        adc     #$0003
        sta     [zeb]
        inc     zeb
        inc     zeb
        shorta
        lda     #$fe
        sta     [zeb]
        inc     zeb
        ldy     zZero
        tyx
@dd55:  lda     [ze7],y     ; find the end of the string
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
@dd61:  sty     zf3
        sta     zf5
        ldy     #$c000      ; destination = $7ec000
        sty     zf6
        lda     #$7e
        sta     zf8
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
@dd90:  lda     [ze7],y     ; copy first 8 words
        sta     hVMDATAL
        iny2
        dex
        bne     @dd90
        .repeat 8
        stz     hVMDATAL      ; clear 8 words (high bitplanes)
        .endrep
        cpy     zeb
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
@ddc1:  lda     [ze7],y
        clc
        adc     zed
        sta     hVMDATAL
        iny2
        cpy     zeb
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
        lda     zc3
        jsr     CalcCosine
        sta     ze0
        sta     zeb
        lda     ze0
        bpl     @ddea
        neg_a
@ddea:  sta     ze0
        lsr
        sta     zcb
        lda     zc3
        jsr     CalcSine
        sta     ze0
        sta     zed
        lda     ze0
        bpl     @de00
        neg_a
@de00:  sta     ze0
        lsr
        sta     zc9
.if LANG_EN
        ldy     #$01be
.else
        ldy     #$01c0
.endif
        lda     zc5
        sta     ze7
@de0c:  lda     zcb
        sta     hWRDIVL
        shorta
        lda     ze8
        sta     hWRDIVB
        nop5
        longa
        lda     zeb
        bpl     @de2c
        lda     hRDDIVL
        neg_a
        bra     @de2f
@de2c:  lda     hRDDIVL
@de2f:  sta     $0602,y     ; m7a and m7d
        sta     $0604,y
        lda     zc9
        sta     hWRDIVL
        shorta
        lda     ze8
        sta     hWRDIVB
        nop2
        longa
        lda     ze7
        sec
        sbc     zc7
        sta     ze7
        lda     zed
        bpl     @de59
        lda     hRDDIVL
        neg_a
        bra     @de5c
@de59:  lda     hRDDIVL
@de5c:  sta     $07c4,y     ; m7b
        sta     $07c6,y
        neg_a
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

; [ generic animation task w/ counter ]

_c3de84:
@de84:  tax
        jmp     (near _c3de88,x)

_c3de88:
@de88:  .addr   _c3de8c, _c3de94

; ------------------------------------------------------------------------------

_c3de8c:
@de8c:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        jsr     InitAnimTask

_c3de94:
@de94:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x     ; terminate task when counter reaches zero
        beq     @dea9
        jsr     UpdateEndingAnimTask
        ldx     zTaskOffset
        longa
        dec     near wTaskProp::w7e3349,x     ; decrement counter
        shorta
        sec
        rts
@dea9:  clc
        rts

; ------------------------------------------------------------------------------

; [ generic ending animation task ]

EndingAnimTask:
@deab:  tax
        jmp     (near EndingAnimTaskTbl,x)

EndingAnimTaskTbl:
@deaf:  .addr   EndingAnimTask_00
        .addr   EndingAnimTask_01

; ------------------------------------------------------------------------------

EndingAnimTask_00:
@deb3:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        jsr     InitAnimTask

EndingAnimTask_01:
@debb:  jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

; [ update animation task position ]

UpdateEndingAnimTask:
@dec0:  ldx     zTaskOffset

; move horizontally
        longa_clc
        lda     near wTaskProp::PosX,x
        adc     near wTaskProp::SpeedX,x
        sta     near wTaskProp::PosX,x

; move vertically
        lda     near wTaskProp::PosY,x
        clc
        adc     near wTaskProp::SpeedY,x
        sta     near wTaskProp::PosY,x
        shorta

; update animation and draw sprites
        jsr     UpdateAnimTask
        rts

; ------------------------------------------------------------------------------

; [ large text task ]

EndingBigTextTask:
@dedd:  sta     ze0
        lda     z47
        bne     @dee9
        lda     ze0
        tax
        jmp     (near EndingBigTextTaskTbl,x)
@dee9:  clc
        rts

.enum ENDING_BIG_TEXT_TASK
        INIT
        WAIT_1
        MOVE_IN
        WAIT_2
        STOP
        WAIT_3
        MOVE_OUT
        WAIT_4
        TERMINATE
        COUNT
.endenum

EndingBigTextTaskTbl:
        ptr_tbl ENDING_BIG_TEXT_TASK

; ------------------------------------------------------------------------------

; state 8: terminate
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::TERMINATE
@defd:  clc
        rts

; state 0: init
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::INIT
@deff:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        stz     near wTaskProp::SpeedY,x
        lda     z85
        sta     near wTaskProp::w7e3349,x
        shorta
        jsr     InitAnimTask
; fall through

; state 1/3/5/7: wait
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::WAIT_1
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::WAIT_2
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::WAIT_3
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::WAIT_4
_df13:  jsr     _c3df4b       ; decrement animation task movement counter
        jsr     UpdateEndingAnimTask
        sec
        rts

; state 2: move up (2.5 seconds)
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::MOVE_IN
@df1b:  ldy     #$ffc0
        ldx     #$0096
        bra     _df32

; state 4: don't move (4 seconds)
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::STOP
@df23:  ldy     zZero
        ldx     #$00f0
        bra     _df32

; state 6: move up (6 seconds)
        array_label ENDING_BIG_TEXT_TASK, ENDING_BIG_TEXT_TASK::MOVE_OUT
@df2a:  ldy     #$ffc0
        ldx     #$012c
        bra     _df32

_df32:  sty     ze7
        stx     ze9
        ldx     zTaskOffset
        longa
        lda     ze7
        sta     near wTaskProp::SpeedY,x     ; vertical movement speed
        lda     ze9
        sta     near wTaskProp::w7e3349,x     ; movement counter
        shorta
        inc     near wTaskProp::State,x     ; increment state
        bra     _df13

; ------------------------------------------------------------------------------

; [ decrement animation task movement counter ]

_c3df4b:
@df4b:  ldx     zTaskOffset
        longa
        lda     near wTaskProp::w7e3349,x     ; movement counter
        bne     @df59
        inc     near wTaskProp::State,x     ; task state
        bra     @df5c
@df59:  dec     near wTaskProp::w7e3349,x
@df5c:  shorta
        rts

; ------------------------------------------------------------------------------

; [ draw character name ]

DrawEndingCharName:
@df5f:  ldy     zZero
@df61:  sty     zeb
        longa
        tya
        asl
        tax
        lda     f:CharPropPtrs,x        ; pointers to character data
        tay
        shorta
        lda     0,y
        cmp     zSelIndex               ; compare character index
        beq     @df99
        longa_clc
        lda     #$0025
        adc     ze7
        sta     ze7
        shorta
        ldy     zeb
        iny
        cpy     #$0010
        bne     @df61
        ldx     zZero
.if LANG_EN
        lda     #$bf
.else
        lda     #$cb
.endif
@df8d:  sta     $7e9e89,x
        inx
        cpx     #$0006
        bne     @df8d
        bra     @dfa9
@df99:  ldx     zZero
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

.if LANG_EN

@dfb3:  ldx     zZero
        stz     ze0
        stz     ze1
@dfb9:  clr_a
        lda     $7e9e89,x
        cmp     #$ff
        beq     @dfd7
        phx
        sec
        sbc     #$60
        tax
        lda     f:FontWidth,x   ; letter width
        clc
        adc     ze0
        sta     ze0
        plx
        inx
        cpx     #$0006
        bne     @dfb9
@dfd7:  longa
        lda     ze0
        lsr
        sta     ze0
        lda     #$0080
        sec
        sbc     ze0
        neg_a
        sta     zBG3HScroll
        shorta
        rts

.else

@ef03:  ldx     zZero
        txy
@ef06:  lda     $7e9e89,x
        sta     $7e9e93,x
        cmp     #$ff
        bne     @ef13
        iny
@ef13:  inx
        cpx     #6
        bne     @ef06
        longa
        tya
        asl2
        neg_a
        sta     zBG3HScroll
        shorta
        rts

.endif

; ------------------------------------------------------------------------------

; [ create bg1 h-scroll task ]

; +Y: scroll counter

_c3dfed:
@dfed:  sty     zf3
        lda     #0
        ldy     #near _c3e002
        jsr     CreateTask
        longa
        lda     zf3
        sta     wTaskProp::w7e3349,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ bg1 h-scroll task ]

_c3e002:
@e002:  ldx     zTaskOffset
        longa
        lda     near wTaskProp::w7e3349,x
        beq     @e01e
        dec     near wTaskProp::w7e3349,x
        shorta
        lda     zFrameCounter
        and     #%11
        bne     @e01c
        longa
        inc     zBG1HScroll
        shorta
@e01c:  sec
        rts
@e01e:  shorta
        clc
        rts

; ------------------------------------------------------------------------------

; [ create character full name task ]

CreateBigCharNameTask:
@e022:  clr_a
        lda     zSelIndex
        asl2
        sta     ze0
        lda     zSelIndex
        asl
        clc
        adc     ze0
        tax
        longa
        lda     f:EndingCharNameAnim,x   ; pointer to animation data (+$c20000)
        sta     z4d
        shorta
        lda     f:EndingCharNameAnim+2,x   ; x position
        sta     z53
        longa
        lda     f:EndingCharNameAnim+3,x   ; pointer to animation data (+$c20000)
        sta     z4f
        shorta
        lda     f:EndingCharNameAnim+5,x   ; x position
        sta     z54
        jsr     CreateEndingBigTextTask
        longa
        lda     z4d
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^EndingCharNameAnim
        sta     wTaskProp::AnimBank,x
        lda     z53
        sta     wTaskProp::PosX_H,x
        lda     #$d0
        sta     wTaskProp::PosY_H,x   ; y position = $d0
        jsr     CreateEndingBigTextTask
        longa
        lda     z4f
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^EndingCharNameAnim
        sta     wTaskProp::AnimBank,x
        lda     z54
        sta     wTaskProp::PosX_H,x
        lda     #$d0
        sta     wTaskProp::PosY_H,x   ; y position = $d0
        rts

; ------------------------------------------------------------------------------

; [ create large text task ]

CreateEndingBigTextTask:
@e08f:  lda     #1
        ldy     #near EndingBigTextTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create "and you" text task ]

_c3e098:
@e098:  jsr     CreateEndingBigTextTask
        longa
        lda     #near AndYouAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^AndYouAnim
        sta     wTaskProp::AnimBank,x
        lda     #$68        ; x position = $68
        sta     wTaskProp::PosX_H,x
        lda     #$d0        ; y position = $d0
        sta     wTaskProp::PosY_H,x
        rts

; ------------------------------------------------------------------------------

; [ init ending graphics & palettes ]

; A: character index

InitEndingGfx:
@e0b9:  sta     zSelIndex
        jsl     InitHWRegsEnding
        jsr     ClearBG3ScreenA
        jsr     ClearBG2ScreenA
        lda     #^BlackPal
        ldy     #near wPalBuf::BGPal0
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::BGPal1
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::BGPal2
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::BGPal5
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::BGPal6
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::SpritePal0
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::SpritePal1
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^BlackPal
        ldy     #near wPalBuf::SpritePal4
        ldx     #near BlackPal
        jsr     LoadPal
        jsr     LoadEndingFontGfx
        jmp     LoadEndingBGGfx

; ------------------------------------------------------------------------------

; [ draw character credits text ]

DrawEndingCharText:
@e123:  stz     z47
        jsr     CreateEndingCharAsTask
        lda     #$2c        ; palette 3, high priority
        sta     zTextColor
        jsr     DrawEndingCharName
        lda     #$01
        trb     z45
        jsr     TfrVRAM2
        lda     #$01
        tsb     z45         ; enable dma at next vblank
        jsr     CreateBigCharNameTask

_c3e13d:
@e13d:  jsr     _c3ef21       ; set up dma
        inc     zEndingState         ; next cinematic state
        jmp     EndingWaitVblank

; ------------------------------------------------------------------------------

; [ fade out ending bg palettes ]

_c3e145:
@e145:  lda     #^BlackPal
        sta     zed
        lda     #$04
        ldy     #near wPalBuf::BGPal5
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^BlackPal
        sta     zed
        lda     #$04
        ldy     #near wPalBuf::BGPal6
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask

_c3e16b:
@e16b:  lda     #^BlackPal
        sta     zed
        lda     #$04
        ldy     #near wPalBuf::BGPal1
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^BlackPal
        sta     zed
        lda     #$04
        ldy     #near wPalBuf::BGPal2
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade in ending bg palettes ]

_c3e192:
@e192:  lda     #^_c2967c
        sta     zed
        lda     #2
        ldy     #near wPalBuf::BGPal1
        sty     ze7
        ldx     #near _c2967c
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^_c2969c
        sta     zed
        lda     #2
        ldy     #near wPalBuf::BGPal2
        sty     ze7
        ldx     #near _c2969c
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^_c296dc
        sta     zed
        lda     #2
        ldy     #near wPalBuf::BGPal5
        sty     ze7
        ldx     #near _c296dc
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^_c296fc
        sta     zed
        lda     #2
        ldy     #near wPalBuf::BGPal6
        sty     ze7
        ldx     #near _c296fc
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3e1df:
@e1df:  lda     #^_c29754
        sta     zed
        lda     #4
        ldy     #near wPalBuf::BGPal0
        sty     ze7
        ldx     #near _c29754
        stx     zeb
        jsr     CreateFadePalTask
        lda     #^_c29754
        sta     zed
        lda     #$04
        ldy     #near wPalBuf::SpritePal1
        sty     ze7
        ldx     #near _c29754
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3e206:
@e206:  stz     zcf_L
        stz     zcf_H
        ldy     #$00f0
        sty     z64
        lda     #0
        ldy     #near _c3d1b6      ; scroll bg3 down task
        jsr     CreateTask
        jsr     _c3e241
        lda     #^BlackPal
        sta     zed
        lda     #4
        ldy     #near wPalBuf::SpritePal1
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask

_c3e22d:
@e22d:  lda     #^_c29754
        sta     zed
        lda     #4
        ldy     #near wPalBuf::SpritePal0
        sty     ze7
        ldx     #near _c29754
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade out background palette 0 ]

_c3e241:
@e241:  lda     #^BlackPal
        sta     zed
        lda     #$04
        ldy     #near wPalBuf::BGPal0
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ fade out sprite palette 0 ]

_c3e255:
@e255:  lda     #^BlackPal
        sta     zed
        lda     #4
        ldy     #near wPalBuf::SpritePal0
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ exit ending cutscene ]

ExitEnding:
@e269:  lda     #ENDING_STATE::TERMINATE
        sta     zEndingState
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $28: shadow 1 ]

        array_label ENDING_STATE, ENDING_STATE::SHADOW_1
@e26e:  lda     #CHAR::SHADOW
        jsr     InitEndingGfx
        jsr     _c3ef48
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     InitShadowAppleAnim
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

_c3e28a:
@e28a:  lda     #^_c29774
        sta     zed
        lda     #2
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near _c29774
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

_c3e29e:
@e29e:  lda     #^BlackPal
        sta     zed
        lda     #4
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $29: shadow 2 ]

        array_label ENDING_STATE, ENDING_STATE::SHADOW_2
@e2b2:  ldy     zWaitCounter
        bne     @e2c0
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e2c0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2a: shadow 3 ]

        array_label ENDING_STATE, ENDING_STATE::SHADOW_3
@e2c1:  ldy     zWaitCounter
        bne     @e2cf
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e2cf:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2b: shadow 4 ]

        array_label ENDING_STATE, ENDING_STATE::SHADOW_4
@e2d0:  ldy     zWaitCounter
        bne     @e2e6
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e2e6:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $38: fade out (character credits) ]

        array_label ENDING_STATE, ENDING_STATE::FADE_CREDITS
@e2e7:  ldy     zWaitCounter
        bne     @e2f7
        ldy     #2 * 60
        sty     zWaitCounter
        lda     #ENDING_STATE::WAIT_FADE
        sta     zEndingState
        jsr     _c3e255
@e2f7:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $32: cyan 1 ]

        array_label ENDING_STATE, ENDING_STATE::CYAN_1
@e2f8:  lda     #CHAR::CYAN
        jsr     InitEndingGfx
        jsr     _c3ef68
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e468
        ldy     #$ffb8
        sty     zBG1HScroll
        jsr     _c3e839
        jsr     InitCyanSwordAnim
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $33: cyan 2 ]

        array_label ENDING_STATE, ENDING_STATE::CYAN_2
@e319:  ldy     zWaitCounter
        bne     @e327
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e327:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $34: cyan 3 ]

        array_label ENDING_STATE, ENDING_STATE::CYAN_3
@e328:  ldy     zWaitCounter
        bne     @e336
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e336:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $35: cyan 4 ]

        array_label ENDING_STATE, ENDING_STATE::CYAN_4
@e337:  ldy     zWaitCounter
        bne     @e34a
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e34a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $40: edgar/sabin 1 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_1
@e34b:  lda     #CHAR::EDGAR
        jsr     InitEndingGfx
        jsr     _c3ef7e       ; load coin graphics (sprite)
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     InitCoinAnim
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $41: edgar/sabin 2 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_2
@e364:  ldy     zWaitCounter
        bne     @e372
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e372:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $42: edgar/sabin 3 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_3
@e373:  ldy     zWaitCounter
        bne     @e381
        inc     zEndingState
        jsr     _c3e206
        ldy     #4 * 60
        sty     zWaitCounter
@e381:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $43: edgar/sabin 4 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_4
@e382:  ldy     zWaitCounter
        bne     @e3a1
        ldy     zZero
        sty     zBG3VScroll
        lda     #CHAR::SABIN
        sta     zSelIndex
        jsr     CreateEndingCharAsTask
        jsr     _c3e255
        jsr     DrawEndingCharName
        jsr     _c3e1df
        inc     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
@e3a1:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $44: edgar/sabin 5 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_5
@e3a2:  ldy     zWaitCounter
        bne     @e3b1
        lda     #1
        sta     z47                     ; terminate big text task
        inc     zEndingState
        ldy     #3 * 60
        sty     zWaitCounter
@e3b1:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $45: edgar/sabin 6 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_6
@e3b2:  ldy     zWaitCounter
        bne     @e3cc
        lda     #ENDING_STATE::EDGAR_SABIN_7
        sta     zEndingState
        ldy     #3 * 60
        sty     zWaitCounter
        stz     z47
        ldy     #$0014
        sty     z85
        jsr     CreateBigCharNameTask
        jsr     _c3e206
@e3cc:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4f: edgar/sabin 7 ]

        array_label ENDING_STATE, ENDING_STATE::EDGAR_SABIN_7
@e3cd:  ldy     zWaitCounter
        bne     @e3e0
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e3e0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $3c: mog 1 ]

        array_label ENDING_STATE, ENDING_STATE::MOG_1
@e3e1:  lda     #CHAR::MOG
        jsr     InitEndingGfx
        jsr     _c3efa2
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        jsr     _c3ea24
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $3d: mog 2 ]

        array_label ENDING_STATE, ENDING_STATE::MOG_2
@e3fd:  ldy     zWaitCounter
        bne     @e40b
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e40b:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $3e: mog 3 ]

        array_label ENDING_STATE, ENDING_STATE::MOG_3
@e40c:  ldy     zWaitCounter
        bne     @e41a
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e41a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $3f: mog 4 ]

        array_label ENDING_STATE, ENDING_STATE::MOG_4
@e41b:  ldy     zWaitCounter
        bne     @e431
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e431:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $46: gogo 1 ]

        array_label ENDING_STATE, ENDING_STATE::GOGO_1
@e432:  lda     #CHAR::GOGO
        jsr     InitEndingGfx
        jsr     _c3efb8
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e839
        jsr     _c3e9e4
        lda     #2
        ldy     #near _c3e49f
        jsr     CreateTask
        lda     #$b4
        lda     wTaskProp::w7e3349,x
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $47: gogo 2 ]

        array_label ENDING_STATE, ENDING_STATE::GOGO_2
@e459:  ldy     zWaitCounter
        bne     @e467
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e467:  rts

; ------------------------------------------------------------------------------

_c3e468:
@e468:  lda     #^_c2955c
        sta     zed
        lda     #1
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near _c2955c
        stx     zeb
        jsr     CreateFadePalTask
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $48: gogo 3 ]

        array_label ENDING_STATE, ENDING_STATE::GOGO_3
@e47c:  ldy     zWaitCounter
        bne     @e48a
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e48a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $49: gogo 4 ]

        array_label ENDING_STATE, ENDING_STATE::GOGO_4
@e48b:  ldy     zWaitCounter
        bne     @e49e
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e49e:  rts

; ------------------------------------------------------------------------------

_c3e49f:
@e49f:  tax
        jmp     (near _c3e4a3,x)

_c3e4a3:
@e4a3:  .addr   _c3e4ab, _c3e4ba, _c3e4ab, _c3e4df

; ------------------------------------------------------------------------------

_c3e4ab:
@e4ab:  ldx     zTaskOffset
        lda     near wTaskProp::w7e3349,x
        bne     @e4b5
        inc     near wTaskProp::State,x
@e4b5:  dec     near wTaskProp::w7e3349,x
        sec
        rts

_c3e4ba:
@e4ba:  phb
        lda     #$00
        pha
        plb
        lda     #^_c2957c
        sta     zed
        lda     #1
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near _c2957c
        stx     zeb
        jsr     CreateFadePalTask
        plb
        ldx     zTaskOffset
        lda     #$3c
        sta     near wTaskProp::w7e3349,x
        inc     near wTaskProp::State,x
        sec
        rts

_c3e4df:
@e4df:  phb
        lda     #$00
        pha
        plb
        lda     #^BlackPal
        sta     zed
        lda     #1
        ldy     #near wPalBuf::SpritePal4
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
        plb
        clc
        rts

; ------------------------------------------------------------------------------

; [ cinematic state $50: gau 1 ]

        array_label ENDING_STATE, ENDING_STATE::GAU_1
@e4fa:  lda     #CHAR::GAU
        jsr     InitEndingGfx
        jsr     _c3efce
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $51: gau 2 ]

        array_label ENDING_STATE, ENDING_STATE::GAU_2
@e513:  ldy     zWaitCounter
        bne     @e521
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e521:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $52: gau 3 ]

        array_label ENDING_STATE, ENDING_STATE::GAU_3
@e522:  ldy     zWaitCounter
        bne     @e533
        inc     zEndingState
        jsr     InitGauEyesAnim
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e533:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $53: gau 4 ]

        array_label ENDING_STATE, ENDING_STATE::GAU_4
@e534:  ldy     zWaitCounter
        bne     @e54a
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e54a:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $5a: terra 1 ]

        array_label ENDING_STATE, ENDING_STATE::TERRA_1
@e54b:  lda     #CHAR::TERRA
        jsr     InitEndingGfx
        jsr     _c3efe4
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e468
        jsr     _c3e83f
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $5b: terra 2 ]

        array_label ENDING_STATE, ENDING_STATE::TERRA_2
@e564:  ldy     zWaitCounter
        bne     @e572
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e572:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $5c: terra 3 ]

        array_label ENDING_STATE, ENDING_STATE::TERRA_3
@e573:  ldy     zWaitCounter
        bne     @e584
        inc     zEndingState
        jsr     _c3ea03
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e584:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $5d: terra 4 ]

        array_label ENDING_STATE, ENDING_STATE::TERRA_4
@e585:  ldy     zWaitCounter
        bne     @e59b
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e59b:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $64: locke/celes 1 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_1
@e59c:  lda     #CHAR::LOCKE
        jsr     InitEndingGfx
        jsr     _c3effa
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e83f
        ldy     #$ffe0
        sty     zBG1HScroll
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $65: locke/celes 2 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_2
@e5b7:  ldy     zWaitCounter
        bne     @e5c5
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e5c5:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $66: locke/celes 3 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_3
@e5c6:  ldy     zWaitCounter
        bne     @e5d4
        inc     zEndingState
        jsr     _c3e206
        ldy     #4 * 60
        sty     zWaitCounter
@e5d4:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $67: locke/celes 4 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_4
@e5d5:  ldy     zWaitCounter
        bne     @e5f4
        ldy     zZero
        sty     zBG3VScroll
        lda     #CHAR::CELES
        sta     zSelIndex
        jsr     CreateEndingCharAsTask
        jsr     _c3e255
        jsr     DrawEndingCharName
        jsr     _c3e1df
        inc     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
@e5f4:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $68: locke/celes 5 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_5
@e5f5:  ldy     zWaitCounter
        bne     @e604
        lda     #$01
        sta     z47
        inc     zEndingState
        ldy     #3 * 60
        sty     zWaitCounter
@e604:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $69: locke/celes 6 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_6
@e605:  ldy     zWaitCounter
        bne     @e61d
        inc     zEndingState
        ldy     #3 * 60
        sty     zWaitCounter
        stz     z47
        ldy     #$0014
        sty     z85
        jsr     CreateBigCharNameTask
        jsr     _c3e206
@e61d:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $6a: locke/celes 7 ]

        array_label ENDING_STATE, ENDING_STATE::LOCKE_CELES_7
@e61e:  ldy     zWaitCounter
        bne     @e634
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e634:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $6e: relm 1 ]

        array_label ENDING_STATE, ENDING_STATE::RELM_1
@e635:  lda     #CHAR::RELM
        jsr     InitEndingGfx
        jsr     _c3f00d
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e468
        jsr     _c3e83f
        jsr     InitRelmBrushAnim
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $6f: relm 2 ]

        array_label ENDING_STATE, ENDING_STATE::RELM_2
@e651:  ldy     zWaitCounter
        bne     @e65f
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e65f:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $70: relm 3 ]

        array_label ENDING_STATE, ENDING_STATE::RELM_3
@e660:  ldy     zWaitCounter
        bne     @e66e
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e66e:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $71: relm 4 ]

        array_label ENDING_STATE, ENDING_STATE::RELM_4
@e66f:  ldy     zWaitCounter
        bne     @e685
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e685:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $78: strago 1 ]

        array_label ENDING_STATE, ENDING_STATE::STRAGO_1
@e686:  lda     #CHAR::STRAGO
        jsr     InitEndingGfx
        jsr     _c3f023
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3ed7f
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $79: strago 2 ]

        array_label ENDING_STATE, ENDING_STATE::STRAGO_2
@e69c:  ldy     zWaitCounter
        bne     @e6aa
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e6aa:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $7a: strago 3 ]

        array_label ENDING_STATE, ENDING_STATE::STRAGO_3
@e6ab:  ldy     zWaitCounter
        bne     @e6b9
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e6b9:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $7b: strago 4 ]

        array_label ENDING_STATE, ENDING_STATE::STRAGO_4
@e6ba:  ldy     zWaitCounter
        bne     @e6cd
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
@e6cd:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2d: book 1 ]

        array_label ENDING_STATE, ENDING_STATE::BOOK_1
@e6ce:  jsr     InitEndingGfx
        jsr     _c3f023
        jsr     _c3e192       ; fade in ending bg palettes
        ldy     #12 * 60
        sty     zWaitCounter
        jmp     _c3e13d

; ------------------------------------------------------------------------------

; [ cinematic state $2e: book 2 ]

        array_label ENDING_STATE, ENDING_STATE::BOOK_2
@e6df:  ldy     zWaitCounter
        bne     @e6ed
        inc     zEndingState
        jsr     _c3ed94
        ldy     #8 * 60
        sty     zWaitCounter
@e6ed:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $2f: book 3 ]

        array_label ENDING_STATE, ENDING_STATE::BOOK_3
@e6ee:  ldy     zWaitCounter
        bne     @e6f9
        inc     zEndingState
        ldy     #6 * 60
        sty     zWaitCounter
@e6f9:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $30: book 4 ]

        array_label ENDING_STATE, ENDING_STATE::BOOK_4
@e6fa:  ldy     zWaitCounter
        bne     @e710
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        jsr     CreateEndingMosaicTask
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e845
@e710:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4a: "and you" 1 ]

        array_label ENDING_STATE, ENDING_STATE::AND_YOU_1
@e711:  jsr     InitEndingGfx
        jsr     _c3f023
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3eda9
        ldy     #3 * 60
        sty     zWaitCounter
        stz     z47
        jsr     _c3e098       ; create "and you" task
        jmp     _c3e13d

; ------------------------------------------------------------------------------

; [ cinematic state $4b: "and you" 2 ]

        array_label ENDING_STATE, ENDING_STATE::AND_YOU_2
@e72a:  ldy     zWaitCounter
        bne     @e735
        inc     zEndingState
        ldy     #4 * 60 - 4
        sty     zWaitCounter
@e735:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4c: "and you" 3 ]

        array_label ENDING_STATE, ENDING_STATE::AND_YOU_3
@e736:  ldy     zWaitCounter
        bne     @e748
        lda     #$01
        sta     z99
        inc     zEndingState
        ldy     #6 * 60 + 4
        sty     zWaitCounter
        jsr     _c3e22d
@e748:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $4d: "and you" 4 ]

        array_label ENDING_STATE, ENDING_STATE::AND_YOU_4
@e749:  ldy     zWaitCounter
        bne     @e75c
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        jsr     CreateEndingMosaicTask
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
@e75c:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $82: setzer 1 ]

        array_label ENDING_STATE, ENDING_STATE::SETZER_1
@e75d:  lda     #CHAR::SETZER
        jsr     InitEndingGfx
        jsr     _c3f036       ; load ending sprite graphics 3
        jsr     _c3e192       ; fade in ending bg palettes
        lda     #^BlackPal
        ldy     #near wPalBuf::SpritePal2
        ldx     #near BlackPal
        jsr     LoadPal
        lda     #^_c29774
        sta     zed
        lda     #2
        ldy     #near wPalBuf::SpritePal2
        sty     ze7
        ldx     #near _c29774
        stx     zeb
        jsr     CreateFadePalTask
        jsr     _c3e839
        jsr     InitSetzerCardsAnim
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $83: setzer 2 ]

        array_label ENDING_STATE, ENDING_STATE::SETZER_2
@e794:  ldy     zWaitCounter
        bne     @e7a2
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e7a2:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $84: setzer 3 ]

        array_label ENDING_STATE, ENDING_STATE::SETZER_3
@e7a3:  ldy     zWaitCounter
        bne     @e7b1
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e7b1:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $85: setzer 4 ]

        array_label ENDING_STATE, ENDING_STATE::SETZER_4
@e7b2:  ldy     zWaitCounter
        bne     @e7c0
        inc     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
@e7c0:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $86: setzer 5 ]

        array_label ENDING_STATE, ENDING_STATE::SETZER_5
@e7c1:  ldy     zWaitCounter
        bne     @e7e4
        ldy     #2 * 60
        sty     zWaitCounter
        lda     #ENDING_STATE::WAIT_FADE
        sta     zEndingState
        jsr     _c3e255
        lda     #^BlackPal
        sta     zed
        lda     #4
        ldy     #near wPalBuf::SpritePal2
        sty     ze7
        ldx     #near BlackPal
        stx     zeb
        jsr     CreateFadePalTask
@e7e4:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $87: umaro 1 ]

        array_label ENDING_STATE, ENDING_STATE::UMARO_1
@e7e5:  lda     #CHAR::UMARO
        jsr     InitEndingGfx
        jsr     _c3f072       ; load skull graphics (sprite)
        jsr     _c3e192       ; fade in ending bg palettes
        jsr     _c3e28a
        jsr     _c3e83f
        jsr     InitUmaroSkullAnim
        jsr     _c3ea7c       ; create walking mini-mog tasks
        ldy     #2 * 60
        sty     zWaitCounter
        jmp     DrawEndingCharText

; ------------------------------------------------------------------------------

; [ cinematic state $88: umaro 2 ]

        array_label ENDING_STATE, ENDING_STATE::UMARO_2
@e804:  ldy     zWaitCounter
        bne     @e812
        inc     zEndingState
        jsr     _c3e1df
        ldy     #4 * 60
        sty     zWaitCounter
@e812:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $89: umaro 3 ]

        array_label ENDING_STATE, ENDING_STATE::UMARO_3
@e813:  ldy     zWaitCounter
        bne     @e821
        inc     zEndingState
        jsr     _c3e206
        ldy     #6 * 60
        sty     zWaitCounter
@e821:  rts

; ------------------------------------------------------------------------------

; [ cinematic state $8a: umaro 4 ]

        array_label ENDING_STATE, ENDING_STATE::UMARO_4
@e822:  ldy     zWaitCounter
        bne     @e838
        lda     #ENDING_STATE::FADE_CREDITS
        sta     zEndingState
        ldy     #2 * 60
        sty     zWaitCounter
        jsr     _c3e145       ; fade out ending bg palettes
        jsr     _c3e29e
        jsr     _c3e845
@e838:  rts

; ------------------------------------------------------------------------------

; [ h-scroll bg1 1200 pixels ]

_c3e839:
@e839:  ldy     #$04b0
        jmp     _c3dfed       ; create bg1 h-scroll task

; ------------------------------------------------------------------------------

; [ h-scroll bg1 312 pixels ]

_c3e83f:
@e83f:  ldy     #$0138
        jmp     _c3dfed       ; create bg1 h-scroll task

; ------------------------------------------------------------------------------

; [ h-scroll bg1 180 pixels ]

_c3e845:
@e845:  ldy     #$00b4
        jmp     _c3dfed       ; create bg1 h-scroll task

; ------------------------------------------------------------------------------

; [ create screen mosaic task ]

CreateEndingMosaicTask:
@e84b:  clr_a
        ldy     #near EndingMosaicTask
        jmp     CreateTask

; ------------------------------------------------------------------------------

; [ screen mosaic task ]

EndingMosaicTask:
@e852:  tax
        jmp     (near EndingMosaicTaskTbl,x)

EndingMosaicTaskTbl:
@e856:  .addr   EndingMosaicTask_00
        .addr   EndingMosaicTask_01

; ------------------------------------------------------------------------------

EndingMosaicTask_00:
@e85a:  ldx     zTaskOffset
        inc     near wTaskProp::State,x     ; increment task state
        stz     near wTaskProp::PosX_H,x
        stz     near wTaskProp::w7e3349,x

EndingMosaicTask_01:
@e865:  ldx     zTaskOffset
        lda     near wTaskProp::w7e3349,x     ; decrement counter
        beq     @e871
        dec     near wTaskProp::w7e3349,x
        sec
        rts
@e871:  lda     near wTaskProp::PosX_H,x
        ora     #$0f
        sta     zMosaic
        ldx     zTaskOffset
        lda     near wTaskProp::PosX_H,x
        clc
        adc     #$10
        sta     near wTaskProp::PosX_H,x
        lda     #$10
        sta     near wTaskProp::w7e3349,x
        sec
        rts

; ------------------------------------------------------------------------------

; unused

@e88a:  lda     zFrameCounter
        and     #%11
        bne     @e896
        longa
        inc     zBG1HScroll
        shorta
@e896:  rts

; ------------------------------------------------------------------------------

; [ create "as" task ]

CreateEndingCharAsTask:
@e897:  lda     #3
        ldy     #near _c3de84      ; generic animation task w/ counter
        jsr     CreateTask
        longa
        lda     #near EndingCharAsAnim
        sta     wTaskProp::AnimPtr,x
        lda     #10*60      ; terminate after 10 seconds
        sta     wTaskProp::w7e3349,x
        shorta
        lda     #^EndingCharAsAnim
        sta     wTaskProp::AnimBank,x
        lda     #$79
        sta     wTaskProp::PosX_H,x   ; x = $79
        lda     #$c0
        sta     wTaskProp::PosY_H,x   ; y = $c0
        rts

; ------------------------------------------------------------------------------

; [ create skull task ]

; umaro

InitUmaroSkullAnim:
@e8c4:  jsr     CreateEndingAnimTask
        longa
        lda     #near UmaroSkullAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^UmaroSkullAnim
        sta     wTaskProp::AnimBank,x
        lda     #$c4
        sta     wTaskProp::PosX_H,x
        lda     #$4f
        jmp     _c3ea68

; ------------------------------------------------------------------------------

; [ create four spinning card tasks ]

; setzer

InitSetzerCardsAnim:
@e8e3:  jsr     CreateSetzerCardTask       ; first card
        lda     #$78
        sta     wTaskProp::PosX_H,x
        lda     #$50
        sta     wTaskProp::PosX_H,x
        longa
        lda     #$0080
        sta     wTaskProp::SpeedY,x
        lda     #$0020
        sta     wTaskProp::SpeedX,x
        shorta
        jsr     CreateSetzerCardTask       ; second card
        lda     #4
        sta     wTaskProp::AnimCounter,x
        lda     #$48
        sta     wTaskProp::PosX_H,x
        lda     #$c0
        sta     wTaskProp::PosY_H,x
        longa
        lda     #$0060
        sta     wTaskProp::SpeedY,x
        lda     #$0040
        sta     wTaskProp::SpeedX,x
        shorta
        jsr     CreateSetzerCardTask       ; third card
        lda     #12
        sta     wTaskProp::AnimCounter,x
        lda     #$98
        sta     wTaskProp::PosX_H,x
        lda     #$10
        sta     wTaskProp::PosY_H,x
        longa
        lda     #$0080
        sta     wTaskProp::SpeedY,x
        lda     #$ffe0
        sta     wTaskProp::SpeedX,x
        shorta
        jsr     CreateSetzerCardTask       ; fourth card
        lda     #18
        sta     wTaskProp::AnimCounter,x
        lda     #$d0
        sta     wTaskProp::PosX_H,x
        lda     #$80
        sta     wTaskProp::PosY_H,x
        longa
        lda     #$0080
        sta     wTaskProp::SpeedY,x
        lda     #$00a0
        sta     wTaskProp::SpeedX,x
        shorta
        rts

; ------------------------------------------------------------------------------

; [ create spinning card task ]

CreateSetzerCardTask:
@e97a:  lda     #0
        ldy     #near EndingAnimTask
        jsr     CreateTask
        longa
        lda     #near SetzerCardAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^SetzerCardAnim
        sta     wTaskProp::AnimBank,x
        rts

; ------------------------------------------------------------------------------

; [ create eyes task ]

; gau

InitGauEyesAnim:
@e994:  jsr     CreateEndingAnimTask
        longa
        lda     #near GauEyesAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^GauEyesAnim
        sta     wTaskProp::AnimBank,x
        lda     #$cb
        sta     wTaskProp::PosX_H,x
        lda     #$5f
        jmp     _c3ea68

; ------------------------------------------------------------------------------

; [ create apple task ]

; shadow

InitShadowAppleAnim:
@e9b3:  jsr     CreateEndingAnimTask
        longa
        lda     #near ShadowAppleAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^ShadowAppleAnim
        sta     wTaskProp::AnimBank,x
        lda     #$c0
        sta     wTaskProp::PosX_H,x
        lda     #$57
        jmp     _c3ea68

; ------------------------------------------------------------------------------

; [ create generic animation task ]

CreateEndingAnimTask:
@e9d2:  lda     #3
        ldy     #near EndingAnimTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create generic animation task (priority 2) ]

; unused

@e9db:  lda     #2
        ldy     #near EndingAnimTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

_c3e9e4:
@e9e4:  jsr     CreateEndingAnimTask
        longa
        lda     #near GogoGlimmerAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^GogoGlimmerAnim
        sta     wTaskProp::AnimBank,x
        lda     #$c8
        sta     wTaskProp::PosX_H,x
        lda     #$61
        jmp     _c3ea68

; ------------------------------------------------------------------------------

_c3ea03:
@ea03:  jsr     CreateEndingAnimTask
        longa
        lda     #near TerraPendantAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^TerraPendantAnim
        sta     wTaskProp::AnimBank,x
        lda     #$80
        sta     wTaskProp::PosX_H,x
        lda     #$60
        sta     wTaskProp::PosY_H,x
        rts

; ------------------------------------------------------------------------------

; [ create dancing mini-mog task ]

; mog

_c3ea24:
@ea24:  jsr     CreateEndingAnimTask
        longa
        lda     #near MogMiniMoogleAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^MogMiniMoogleAnim
        sta     wTaskProp::AnimBank,x
        lda     #$e0
        sta     wTaskProp::PosX_H,x
        lda     #$6f
        jsr     _c3ea68
        jsr     _c3ea73
        lda     #$ba
        sta     wTaskProp::PosX_H,x
        jsr     _c3ea73
        lda     #$c6
        sta     wTaskProp::PosX_H,x
        jsr     _c3ea73
        lda     #$d1
        sta     wTaskProp::PosX_H,x
        jsr     _c3ea73
        lda     #$dc
        sta     wTaskProp::PosX_H,x
        rts

; ------------------------------------------------------------------------------

_c3ea68:
@ea68:  sta     wTaskProp::PosY_H,x

_c3ea6c:
@ea6c:  lda     #$01
        sta     wTaskProp::Flags,x
        rts

; ------------------------------------------------------------------------------

_c3ea73:
@ea73:  lda     #2
        ldy     #near _c3eafc
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create walking mini-moogle tasks ]

; umaro

_c3ea7c:
@ea7c:  jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$3a
        sta     wTaskProp::PosX_H,x
        longa
        lda     #$01a4
        sta     wTaskProp::w7e3349,x
        lda     #near UmaroMiniMoogleAnim4
        sta     wTaskProp::w7e37c9,x
        shorta
        jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$2e
        sta     wTaskProp::PosX_H,x
        longa
        lda     #$01b8
        sta     wTaskProp::w7e3349,x
        lda     #near UmaroMiniMoogleAnim5
        sta     wTaskProp::w7e37c9,x
        shorta
        jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$21
        sta     wTaskProp::PosX_H,x
        longa
        lda     #$01cc
        sta     wTaskProp::w7e3349,x
        lda     #near UmaroMiniMoogleAnim6
        sta     wTaskProp::w7e37c9,x
        shorta
        jsr     _c3ea73
        jsr     _c3eaf5
        lda     #$14
        sta     wTaskProp::PosX_H,x
        longa
        lda     #$01e0
        sta     wTaskProp::w7e3349,x
        lda     #near UmaroMiniMoogleAnim7
        sta     wTaskProp::w7e37c9,x
        shorta
        rts

; ------------------------------------------------------------------------------

_c3eaf5:
@eaf5:  lda     #5
        sta     wTaskProp::State,x
        rts

; ------------------------------------------------------------------------------

; [ umaro mini-moogle task ]

_c3eafc:
@eafc:  tax
        jmp     (near _c3eb00,x)

_c3eb00:
@eb00:  .addr   _c3eb10, _c3eb35, _c3eb5e, _c3eb7b
        .addr   _c3eb97, _c3eb9c, _c3eba9, _c3ebd0

; ------------------------------------------------------------------------------

_c3eb10:
@eb10:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #near UmaroMiniMoogleAnim1
        sta     near wTaskProp::AnimPtr,x
        lda     #$0168
        sta     near wTaskProp::w7e3349,x
        shorta
        lda     #$64
        sta     near wTaskProp::PosY_H,x
        lda     #^UmaroMiniMoogleAnim1
        sta     near wTaskProp::AnimBank,x
        jsr     _c3ea6c
        jsr     InitAnimTask

_c3eb35:
@eb35:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @eb56
        inc     near wTaskProp::State,x
        longa
        lda     #near UmaroMiniMoogleAnim3
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^UmaroMiniMoogleAnim3
        sta     near wTaskProp::AnimBank,x
        lda     #$10
        sta     near wTaskProp::w7e3349,x
        jsr     InitAnimTask
@eb56:  jsr     DecTaskCounter
        jsr     UpdateEndingAnimTask
        sec
        rts

_c3eb5e:
@eb5e:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @eb6d
        inc     near wTaskProp::State,x
        lda     #$3c
        sta     near wTaskProp::w7e3349,x
@eb6d:  jsr     DecTaskCounter
        jsr     _c3ebf0
        jsr     UpdateEndingAnimTask
        inc     near wTaskProp::w7e35c9,x
        sec
        rts

_c3eb7b:
@eb7b:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @eb8f
        jsr     _c3ebd5
        longa
        lda     #$012c
        sta     near wTaskProp::w7e3349,x
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
@eb9c:  ldx     zTaskOffset
        jsr     _c3ebd5
        lda     #$70
        sta     near wTaskProp::PosY_H,x
        jsr     _c3ea6c

_c3eba9:
@eba9:  ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @ebc8
        inc     near wTaskProp::State,x
        longa
        stz     near wTaskProp::SpeedX,x
        lda     near wTaskProp::w7e37c9,x
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^UmaroMiniMoogleAnim1
        sta     near wTaskProp::AnimBank,x
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
@ebd5:  inc     near wTaskProp::State,x
        longa
        lda     #near UmaroMiniMoogleAnim2
        sta     near wTaskProp::AnimPtr,x
        lda     #$0040
        sta     near wTaskProp::SpeedX,x
        shorta
        lda     #^UmaroMiniMoogleAnim2
        sta     near wTaskProp::AnimBank,x
        jmp     InitAnimTask

; ------------------------------------------------------------------------------

; [  ]

_c3ebf0:
@ebf0:  ldx     zTaskOffset
        lda     near wTaskProp::w7e35c9,x
        and     #$0f
        tax
        lda     f:MiniMoogleJumpOffset,x
        sta     ze0
        bmi     @ec0d
        ldx     zTaskOffset
        lda     near wTaskProp::PosY_H,x
        clc
        adc     ze0
        sta     near wTaskProp::PosY_H,x
        bra     @ec23
@ec0d:  ldx     zTaskOffset
        lda     a:ze0
        bpl     @ec17
        neg_a
@ec17:  sta     a:ze0
        lda     near wTaskProp::PosY_H,x
        sec
        sbc     ze0
        sta     near wTaskProp::PosY_H,x
@ec23:  rts

; ------------------------------------------------------------------------------

; [ create spinning coin task ]

InitCoinAnim:
@ec24:  lda     #2
        ldy     #near CoinAnimTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create paintbrush sparkle task ]

InitRelmBrushAnim:
@ec2d:  lda     #0
        ldy     #near RelmBrushAnimTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create sword sparkle task ]

InitCyanSwordAnim:
@ec36:  lda     #0
        ldy     #near CyanSwordAnimTask
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ create sparkle task ]

_c3ec3f:
@ec3f:  lda     #2
        ldy     #near _c3ed14
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

; [ paintbrush sparkle task ]

; relm

RelmBrushAnimTask:
@ec48:  tax
        jmp     (near _c3ec4c,x)

_c3ec4c:
@ec4c:  .addr   _c3ec50, _c3ec67

; ------------------------------------------------------------------------------

_c3ec50:
@ec50:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #$0168
        sta     near wTaskProp::w7e3349,x
        shorta
        lda     #$e4
        sta     zc7
        lda     #$03
        sta     zc9

_c3ec67:
@ec67:  lda     zc9
        beq     @ecac
        ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @eca7
        lda     #$08
        sta     near wTaskProp::w7e3349,x
        phb
        lda     #$00
        pha
        plb
        jsr     _c3ec3f
        lda     #$68
        sta     wTaskProp::PosY_H,x
        longa
        lda     #near TerraPendantAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^TerraPendantAnim
        sta     wTaskProp::AnimBank,x
        lda     zc7
        sta     wTaskProp::PosX_H,x
        plb
        dec     zc7
        dec     zc7
        dec     zc7
        dec     zc7
        dec     zc9
@eca7:  jsr     DecTaskCounter
        sec
        rts
@ecac:  clc
        rts

; ------------------------------------------------------------------------------

; [ sword glimmer task ]

; cyan

CyanSwordAnimTask:
@ecae:  tax
        jmp     (near _c3ecb2,x)

_c3ecb2:
@ecb2:  .addr   _c3ecb6, _c3eccd

; ------------------------------------------------------------------------------

_c3ecb6:
@ecb6:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #$0168
        sta     near wTaskProp::w7e3349,x
        shorta
        lda     #$c8
        sta     zc7
        lda     #$04
        sta     zc9

_c3eccd:
@eccd:  lda     zc9
        beq     @ed12
        ldx     zTaskOffset
        ldy     near wTaskProp::w7e3349,x
        bne     @ed0d
        lda     #$08
        sta     near wTaskProp::w7e3349,x
        phb
        lda     #$00
        pha
        plb
        jsr     _c3ec3f
        lda     #$60
        sta     wTaskProp::PosY_H,x
        longa
        lda     #near CyanKatanaAnim
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^CyanKatanaAnim
        sta     wTaskProp::AnimBank,x
        lda     zc7
        sta     wTaskProp::PosX_H,x
        plb
        dec     zc7
        dec     zc7
        dec     zc7
        dec     zc7
        dec     zc9
@ed0d:  jsr     DecTaskCounter
        sec
        rts
@ed12:  clc
        rts

; ------------------------------------------------------------------------------

; [ sparkle task ]

_c3ed14:
@ed14:  tax
        jmp     (near _c3ed18,x)

_c3ed18:
@ed18:  .addr   _c3ed1c, _c3ed29

; ------------------------------------------------------------------------------

_c3ed1c:
@ed1c:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        lda     #$01
        sta     near wTaskProp::Flags,x
        jsr     InitAnimTask

_c3ed29:
@ed29:  ldx     zTaskOffset
        lda     near wTaskProp::AnimCounter,x
        cmp     #$fe
        beq     @ed37
        jsr     UpdateEndingAnimTask
        sec
        rts
@ed37:  clc
        rts

; ------------------------------------------------------------------------------

; [ spinning coin task ]

CoinAnimTask:
@ed39:  tax
        jmp     (near CoinAnimTaskTbl,x)

CoinAnimTaskTbl:
@ed3d:  .addr   CoinAnimTask_00
        .addr   CoinAnimTask_01

; ------------------------------------------------------------------------------

CoinAnimTask_00:
@ed41:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #near EdgarCoinAnim
        sta     near wTaskProp::AnimPtr,x
        lda     #$0080
        sta     near wTaskProp::SpeedX,x
        shorta
        lda     #$c8
        sta     near wTaskProp::w7e3349,x
        lda     #^EdgarCoinAnim
        sta     near wTaskProp::AnimBank,x
        lda     #$10
        sta     near wTaskProp::PosX_H,x
        lda     #$64
        sta     near wTaskProp::PosY_H,x
        jsr     InitAnimTask

CoinAnimTask_01:
@ed6d:  ldx     zTaskOffset
        lda     near wTaskProp::w7e3349,x
        bne     @ed77
        stz     near wTaskProp::SpeedX,x
@ed77:  dec     near wTaskProp::w7e3349,x
        jsr     UpdateEndingAnimTask
        sec
        rts

; ------------------------------------------------------------------------------

_c3ed7f:
@ed7f:  jsr     _c3edbe
        longa
        lda     #near BookAnimStrago
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^BookAnimStrago
        sta     wTaskProp::AnimBank,x
        rts

; ------------------------------------------------------------------------------

_c3ed94:
@ed94:  jsr     _c3edbe
        longa
        lda     #near BookAnim1
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^BookAnim1
        sta     wTaskProp::AnimBank,x
        rts

; ------------------------------------------------------------------------------

_c3eda9:
@eda9:  jsr     _c3edbe
        longa
        lda     #near BookAnim2
        sta     wTaskProp::AnimPtr,x
        shorta
        lda     #^BookAnim2
        sta     wTaskProp::AnimBank,x
        rts

; ------------------------------------------------------------------------------

_c3edbe:
@edbe:  clr_ay
        sta     z99
        sty     z60
        lda     #1
        ldy     #near _c3ee04
        jsr     CreateTask
        rts

; ------------------------------------------------------------------------------

_c3edcd:
@edcd:  stx     ze7
        lda     #$7f
        sta     ze9
        sty     zeb
        lda     #$7e
        sta     zed
        ldx     zZero
        longa
@eddd:  clr_ay
@eddf:  lda     [ze7],y
        clc
        adc     z60
        sta     [zeb],y
        iny2
        cpy     ze0
        bne     @eddf
        lda     ze7
        clc
        adc     #$0040
        sta     ze7
        lda     zeb
        clc
        adc     #$0040
        sta     zeb
        inx
        cpx     ze2
        bne     @eddd
        shorta
        rts

; ------------------------------------------------------------------------------

_c3ee04:
@ee04:  tax
        jmp     (near _c3ee08,x)

_c3ee08:
@ee08:  .addr   _c3ee0e, _c3ee18, _c3ee1c

; ------------------------------------------------------------------------------

_c3ee0e:
@ee0e:  ldx     zTaskOffset
        inc     near wTaskProp::State,x
        jsr     InitAnimTask
        sec
        rts

_c3ee18:
@ee18:  lda     z99
        bne     _ee59

_c3ee1c:
@ee1c:  ldx     zTaskOffset
        jsr     UpdateAnimData
        ldx     zTaskOffset
        shorti
        lda     near wTaskProp::w7e36c9,x
        tay
        longa
        lda     [zeb],y
        sta     ze7
        iny2
        shorta
        lda     near wTaskProp::AnimBank,x
        sta     ze9
        longi
        ldy     zZero
        longa
        lda     [ze7],y
        sta     ze0
        iny2
        lda     [ze7],y
        sta     ze2
        iny2
        lda     [ze7],y
        tax
        iny2
        lda     [ze7],y
        tay
        shorta
        jsr     _c3edcd
        sec
        rts
_ee59:  stz     z99
        ldx     zTaskOffset
        inc     near wTaskProp::State,x
        longa
        lda     #near BookAnimEnd
        sta     near wTaskProp::AnimPtr,x
        shorta
        lda     #^BookAnimEnd
        sta     near wTaskProp::AnimBank,x
        jsr     InitAnimTask
        bra     _c3ee1c

; ------------------------------------------------------------------------------

; [ load ending font graphics ]

LoadEndingFontGfx:
@ee74:  ldy     #near EndingFontGfx
        lda     #^EndingFontGfx
        jsr     Decompress
        ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0900      ; copy $0900 bytes to vram at $7000
        sty     zeb
        ldy     #$7000
        jmp     TfrGfx2bpp

; ------------------------------------------------------------------------------

; [ load ending bg graphics ]

LoadEndingBGGfx:
@ee90:  ldy     #near EndingGfx1
        lda     #^EndingGfx1
        jsr     Decompress
        ldy     #near wBG1Tiles::ScreenA
        sty     zeb
        lda     #$7e
        sta     zed
        jsr     _c3ef10       ; load bg data
        ldy     #near wBG1Tiles::ScreenB
        sty     zeb
        lda     #$7e
        sta     zed
        jsr     _c3ef10       ; load bg data
        ldy     #$c000      ; source = $7ec000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$1f60      ; size = $1f60
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$3000      ; destination = vram $3000
        jsr     EndingTfrVRAM
        ldy     #$df60      ; source = $7edf60
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0b40      ; size = $0b40
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$4000      ; destination = vram $4000
        jsr     EndingTfrVRAM
        ldy     #$eaa0      ; source = $7eeaa0
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0e00      ; size = $0e00
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$5000      ; destination = vram $5000
        jsr     EndingTfrVRAM
        ldy     #$0448      ; source = $7f0448
        sty     ze7
        lda     #$7f
        sta     ze9
        ldy     #$0780      ; size = $0780
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$1000      ; destination = vram $1000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load bg data (book cinematic) ]

_c3ef10:
@ef10:  ldy     #$f8a0      ; source = $7ef8a0
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0780      ; size = $0780
        sty     zef
        jmp     CopyCreditsGfx

; ------------------------------------------------------------------------------

_c3ef21:
@ef21:  ldy     #$1800
        sty     zDMA2Dest
        ldy     #near wBG3Tiles::ScreenA
        sty     zDMA2Src
        lda     #^wBG3Tiles::ScreenA
        sta     zDMA2Src_B
        ldy     #$0800
        sty     zDMA2Size
        ldy     #$0000
        sty     zDMA1Dest
        ldy     #near wBG1Tiles::ScreenA
        sty     zDMA1Src
        lda     #^wBG1Tiles::ScreenA
        sta     zDMA1Src_B
        ldy     #$1000
        sty     zDMA1Size
        rts

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 2 ]

_c3ef48:
@ef48:  ldy     #near EndingGfx2
        lda     #^EndingGfx2
        jsr     Decompress
        ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0380
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

_c3ef68:
@ef68:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$0026
        sty     ze0
        ldy     #$0002
        sty     ze2
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
@ef87:  ldy     #near EndingGfx4      ; $d99d4b (ending graphics, coin and skull)
        lda     #^EndingGfx4
        jsr     Decompress
        ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0800
        sty     zeb
        stz     zed
        stz     zee
        rts

; ------------------------------------------------------------------------------

_c3efa2:
@efa2:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$000e
        sty     ze0
        ldy     #$0008
        sty     ze2
        ldx     #$0020
        ldy     #$3a77
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3efb8:
@efb8:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$001c
        sty     ze0
        ldy     #$0009
        sty     ze2
        ldx     #$002e
        ldy     #$3a2d
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3efce:
@efce:  jsr     _c3f056
        ldy     #$000c
        sty     ze0
        ldy     #$0007
        sty     ze2
        ldx     #$004a
        ldy     #$3ab7
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3efe4:
@efe4:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$000e
        sty     ze0
        ldy     #$0005
        sty     ze2
        ldx     #$0220
        ldy     #$3b35
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3effa:
@effa:  ldy     #$0018
        sty     ze0
        ldy     #$0006
        sty     ze2
        ldx     #$0274
        ldy     #$3b69
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3f00d:
@f00d:  jsr     _c3f036       ; load ending sprite graphics 3
        ldy     #$0014
        sty     ze0
        ldy     #$0002
        sty     ze2
        ldx     #$0360
        ldy     #$3bf3
        jmp     _c3edcd

; ------------------------------------------------------------------------------

_c3f023:
@f023:  ldy     #$001c
        sty     ze0
        ldy     #$0006
        sty     ze2
        ldx     #$0bc8
        ldy     #$3ad9
        jmp     _c3edcd

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 3 ]

; cards, sparkle, mini-mog, eyes, ...

_c3f036:
@f036:  ldy     #near EndingGfx3
        lda     #^EndingGfx3
        jsr     Decompress
        ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$0df0
        sty     zeb
        stz     zed
        stz     zee
        ldy     #$6000
        jmp     EndingTfrVRAM

; ------------------------------------------------------------------------------

; [ load ending sprite graphics 5 ]

_c3f056:
@f056:  ldy     #near EndingGfx5
        lda     #^EndingGfx5
        jsr     Decompress
        ldy     #$c000
        sty     ze7
        lda     #$7e
        sta     ze9
        ldy     #$00c0
        sty     zeb
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
        sty     ze0
        ldy     #$0005
        sty     ze2
        ldx     #$0056
        ldy     #$3b37
        jmp     _c3edcd

; ------------------------------------------------------------------------------
