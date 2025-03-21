
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: init.asm                                                             |
; |                                                                            |
; | description: field init routines                                           |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

inc_lang "text/bushido_name_%s.inc"

.import WindowPal, MapInitEvent, EventScript_GameStart

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init game data for saved game ]

.proc InitSavedGame
        stz     $58                     ; don't reload the same map
        ldy     $0803                   ; party object
        lda     #1                      ; enable walking animation
        sta     $0868,y
        jsr     PopCharFlags
        ldx     $00                     ; copy character data to character objects
        txy
Loop:   lda     $1600,y                 ; actor
        sta     $0878,x
        lda     $1601,y                 ; graphics
        sta     $0879,x
        clr_a
        sta     $087c,x                 ; clear movement type
        sta     $087d,x
        lda     #$01                    ; enable walking animation
        sta     $0868,x
        longa_clc                       ; next character
        txa
        adc     #$0029
        tax
        tya
        clc
        adc     #$0025
        tay
        shorta0
        cpy     #$0250
        bne     Loop
        ldx     $1fa6                   ; pointer to party object data
        stx     $07fb                   ; store in character object slot 0
        lda     #$02                    ; user-controlled
        sta     $087c,x
        lda     $1f68                   ; set facing direction
        sta     $0743
        jsr     PopPartyPal
        ldy     #$07d9
        sty     $07fd                   ; clear character object slots 1-4
        sty     $07ff
        sty     $0801
        jsr     _c0714a
        jsr     InitCharSpritePriority
        lda     #$80                    ; enable map startup event
        sta     $11fa
        lda     #1                      ; enable map load
        sta     $84
        rts
.endproc  ; InitSavedGame

; ------------------------------------------------------------------------------

; [ init game data for new game ]

.proc InitNewGame

; clear character data
        ldx     $00
:       stz     $1600,x
        inx
        cpx     #$0250
        bne     :-

        ldx     $00                     ; loop through character data
:       lda     #$ff
        sta     $1600,x                 ; no actor in slot
        sta     $161e,x                 ; no esper
        longa_clc
        txa
        adc     #$0025
        tax
        shorta0
        cpx     #$0250
        bne     :-

; clear character flags
        ldx     $00
:       stz     $1850,x
        inx
        cpx     #$0010
        bne     :-

; clear inventory
        ldx     $00
        lda     $02
:       stz     $1969,x
        sta     $1869,x
        inx
        cpx     #$0100
        bne     :-

; clear character spells known
        ldx     $00
:       stz     $1a6e,x
        inx
        cpx     #$0288
        bne     :-

; clear character skill data
        ldx     $00
:       stz     $1cf6,x
        inx
        cpx     #$0057
        bne     :-

; load swdtech names (unused in English version)
        ldx     $00
:       lda     f:BushidoName,x
        sta     $1cf8,x
        inx
        cpx     #$0030
        bne     :-

; clear espers
        stz     $1a69
        stz     $1a6a
        stz     $1a6b
        stz     $1a6c

; clear event flags
        ldx     $00
:       stz     $1dc9,x
        inx
        cpx     #$0054
        bne     :-

; load starting rages and lores
        ldx     $00
:       lda     f:InitRage,x
        sta     $1d2c,x
        inx
        cpx     #$0020
        bne     :-
        lda     f:InitLore
        sta     $1d29
        lda     f:InitLore+1
        sta     $1d2a
        lda     f:InitLore+2
        sta     $1d2b

; set wallpaper index and font color
        stz     $0565
        ldx     #$7fff
        stx     $1d55

; set window palette (1st window only)
        ldx     $00
:       lda     f:WindowPal+2,x
        sta     $1d57,x
        inx
        cpx     #14
        bne     :-

; set party z-levels to 1
        lda     #1
        sta     $1ff3
        sta     $1ff4
        sta     $1ff5
        sta     $1ff6

; clear timers
        ldx     $00
        stx     $1189
        stx     $118f
        stx     $1195
        stx     $119b

; clear timer event pointers
        stx     $118b
        stx     $1191
        stx     $1197
        stx     $119d
        clr_a
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
        ldx     #.loword(EventScript_GameStart)
        stx     $e5
        stx     $05f4
        lda     #^EventScript_GameStart
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1                      ; loop once
        sta     $05c7
        ldx     #$0003                  ; set event stack
        stx     $e8
        lda     #$02                    ; party will be user-controlled after event
        sta     $087d
        stz     $47                     ; clear event counter
        .if     .not ::DEBUG
        rts
        .else

; set event pc
        ldx     #.loword(DebugEvent)
        stx     $e5
        lda     #^DebugEvent
        sta     $e7

; set airship position
        lda     #85
        sta     $1f62
        lda     #111
        sta     $1f63
        lda     $1eb7
        ora     #$02
        sta     $1eb7

; init game vars
        clr_ay
        sty     $1dc7                   ; clear save count
        stz     $1d54                   ; reset controller to default
        stz     $1d4e                   ; clear config settings
        stz     $1d4f
        sty     $1860                   ; clear gil
        stz     $1862
        sty     $1863                   ; clear game time
        stz     $1865
        sty     $1866                   ; clear steps
        stz     $1868
        sty     $021b                   ; clear menu game time
        sty     $021d
        jsl     InitCtrl_ext
        rts

        .pushcpu

        .include "event_cmd.inc"
        .include "gfx/map_sprite_gfx.inc"
        .include "gfx/map_sprite_pal.inc"

DebugEvent:

        char_name       TERRA, TERRA
        char_prop       TERRA, TERRA
        create_obj      TERRA
        obj_gfx         TERRA, TERRA
        obj_pal         TERRA, TERRA

        char_name       LOCKE, LOCKE
        char_prop       LOCKE, LOCKE
        create_obj      LOCKE
        obj_gfx         LOCKE, LOCKE
        obj_pal         LOCKE, LOCKE

        char_name       EDGAR, EDGAR
        char_prop       EDGAR, EDGAR
        create_obj      EDGAR
        obj_gfx         EDGAR, EDGAR
        obj_pal         EDGAR, EDGAR

        char_name       CYAN, CYAN
        char_prop       CYAN, CYAN
        create_obj      CYAN
        obj_gfx         CYAN, CYAN
        obj_pal         CYAN, CYAN

        char_party      TERRA,1
        char_party      LOCKE,1
        char_party      EDGAR,1
        char_party      CYAN,1
        activate_party  1
        show_obj        TERRA

        loop            4
        give_gil        50000
        end_loop
        give_item       PALADIN_SHLD
        give_item       PALADIN_SHLD
        give_item       PALADIN_SHLD
        give_item       PALADIN_SHLD
        give_item       ILLUMINA
        give_item       WING_EDGE
        give_item       AURA_LANCE
        give_item       SKY_RENDER
        opt_equip       TERRA
        opt_equip       LOCKE
        opt_equip       EDGAR
        opt_equip       CYAN
        give_bushido

        give_genju      BAHAMUT
        give_genju      PHOENIX
        give_genju      ALEXANDR
        give_genju      CRUSADER
        give_genju      RAIDEN
        give_genju      ODIN
        give_genju      RAGNAROK

        set_switch      $02e0
        set_switch      $02f0
        clr_switch      $01cc
        set_switch      $01c1
        set_switch      $010b
        set_switch      $01e3
        set_switch      $016f
        set_switch      $0170

        set_parent_map 0, {85, 110}, UP
        load_map $4b, {2, 28}, RIGHT, NO_FADE_IN
        fade_in
        unlock_camera

        return

        .popcpu
        .undef loop

.endif
.endproc  ; InitNewGame

; ------------------------------------------------------------------------------

.pushseg
.segment "init_rage"

; c4/7aa0
InitRage:
        .byte   $00,$48,$28,$02,$00,$40,$40,$02,$04,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.segment "init_lore"

; e6/f564
InitLore:
        .byte   $88,$00,$10

.popseg

; ------------------------------------------------------------------------------

; [ load map ]

.proc LoadMap
        jsr     DisableInterrupts
        .if     ::LANG_EN
        jsr     InitDlgVWF
        .endif
        lda     $58                     ; branch if reloading the same map
        bne     :+
        longa
        lda     $1f64                   ; current map index
        and     #$01ff                  ; clear startup flags
        sta     $1f64
        sta     $82
        shorta0
        jsr     LoadMapProp
        stz     $47                     ; clear event counter
        stz     $077b                   ; disable flashlight
        lda     #1                      ; enable entrance triggers
        sta     $85
        ldx     $00                     ; clear open doors
        stx     $1127
        jsr     CalcObjPtrs
        jsr     CalcScrollRange
        ldx     $00
        stx     $078c                   ; clear step counter for random battles
        stz     $078b                   ; clear number of battles this map
        jsr     PopPartyPos

; jump here if reloading the same map
:       jsr     _c0714a
        jsr     InitPlayerPos
        lda     $11fa                   ; branch if map size update is disabled
        and     #$20
        bne     :+
        jsr     InitMapSize
:       lda     $1f66                   ; set scroll position
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
        bne     :+
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     :+
        jsr     GetTopChar
:       stz     $84                     ; disable map load
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
        lda     #1                      ; wait for character objects to update
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
        .if     ::DEBUG
        jsr     DebugLoadGfx
        .endif
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
        bne     :+
        stz     $1ebe                   ; unused
        stz     $1ebf
        jsr     InitNPCs
        jsr     InitPlayerObj
        lda     $1eb6                   ; disable object map data update
        and     #$bf
        sta     $1eb6
:       jsr     InitObjAnim
        jsr     InitSpecialNPCs
        jsr     InitPortrait
        jsr     InitNPCMap
        lda     $11fa                   ; branch if map startup event is enabled
        jpl     SkipStartupEvent
        longa
        lda     $1f64                   ; map index * 3
        and     #$01ff
        sta     $1e
        asl
        clc
        adc     $1e
        tax
        shorta0

; set map startup event code

; $0624 b2 xxxxxx jump to xxxxxx
        lda     #$b2
        sta     $0624
        lda     f:MapInitEvent,x        ; pointer to map startup event
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
        jeq     SkipStartupEvent

; $0628 d3 cf     clear event bit $1eb9.7 (enable user control of character)
        lda     #$d3
        sta     $0628
        lda     #$cf
        sta     $0629

; $062a fd        add 1 to event pc (does nothing)
        lda     #$fd
        sta     $062a

; $062b fe        return
        lda     #$fe
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

StartupEventLoop:
        jsr     ExecEvent
        lda     $1eb9
        bpl     :+                      ; branch if user has control of character
        jsr     UpdateObjActions
        jsr     MoveObjs
        jsr     UpdateBG1
        jsr     UpdateBG2
        jsr     UpdateBG3
        jsr     TfrMapTiles
        bra     StartupEventLoop

; user now has control
:       lda     [$e5]                   ; branch if current event opcode is return
        cmp     #$fe
        bne     SkipStartupEvent
        ldx     $e8
        dex3
        ldy     $0594,x                 ; branch unless there's an address on the event stack
        bne     SkipStartupEvent
        lda     $0596,x
        cmp     #^EventScript_NoEvent
        bne     SkipStartupEvent
        jsr     ExecEvent

SkipStartupEvent:
        lda     $11fa                   ; branch if map fade in is disabled
        and     #$40
        bne     :+
        jsr     FadeIn
:       jsr     InitZLevel
        jsr     UpdateOverlay
        jsr     PlayMapSong
        stz     $11fa                   ; clear map startup flags
        stz     $58                     ; don't reload the same map
        jsr     ShowMapTitle

; loop through all active objects
        stz     $dc
:       lda     $dc
        cmp     $dd
        beq     :+
        tax
        ldy     $0803,x
        jsr     UpdateObjFrame
        lda     $0877,y                 ; set current graphic positions
        sta     $0876,y
        inc     $dc                     ; next object
        inc     $dc
        bra     :-

; update all object graphics
:       stz     $47                     ; clear event counter
        jsr     TfrObjGfxSub            ; update object 0-5 graphics in vram
        .repeat 3
        inc     $47
        jsr     TfrObjGfxSub            ; update object 6-23 graphics in vram
        .endrep
        rts
.endproc  ; LoadMap

; ------------------------------------------------------------------------------
