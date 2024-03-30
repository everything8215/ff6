
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

.import WindowPal, EventScript_GameStart

.a8
.i16
.segment "field_code"

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
        longa_clc                          ; next character
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
        longa_clc
        txa
        adc     #$0025
        tax
        shorta0
        cpx     #$0250
        bne     @bd9a
        ldx     $00                     ; clear character flags
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
@bde4:  lda     f:BushidoName,x
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
@be0a:  lda     f:InitRage,x
        sta     $1d2c,x
        inx
        cpx     #$0020
        bne     @be0a
        lda     f:InitLore
        sta     $1d29
        lda     f:InitLore+1
        sta     $1d2a
        lda     f:InitLore+2
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
.if DEBUG

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
        tdc
        tay
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
        ; cutscene        intro

        char_name       TERRA, CHAR_PROP_TERRA_INTRO
        char_prop       TERRA, CHAR_PROP_TERRA
        create_obj      OBJ_TERRA
        obj_gfx         OBJ_TERRA, MAP_SPRITE_GFX_TERRA
        obj_pal         OBJ_TERRA, MAP_SPRITE_PAL_TERRA

        char_name       LOCKE, CHAR_PROP_LOCKE
        char_prop       LOCKE, CHAR_PROP_LOCKE
        create_obj      OBJ_LOCKE
        obj_gfx         OBJ_LOCKE, MAP_SPRITE_GFX_LOCKE
        obj_pal         OBJ_LOCKE, MAP_SPRITE_PAL_LOCKE

        char_name       EDGAR, CHAR_PROP_EDGAR
        char_prop       EDGAR, CHAR_PROP_EDGAR
        create_obj      OBJ_EDGAR
        obj_gfx         OBJ_EDGAR, MAP_SPRITE_GFX_EDGAR
        obj_pal         OBJ_EDGAR, MAP_SPRITE_PAL_EDGAR_SABIN_CELES

        char_party      TERRA,1
        char_party      LOCKE,1
        char_party      EDGAR,1
        activate_party  1
        show_obj        OBJ_TERRA

        loop_start      4
        give_gil        50000
        loop_end
        give_item       ITEM_PALADIN_SHLD
        give_item       ITEM_PALADIN_SHLD
        give_item       ITEM_PALADIN_SHLD
        give_item       ITEM_ILLUMINA
        give_item       ITEM_WING_EDGE
        give_item       ITEM_AURA_LANCE
        char_opt_equip  TERRA
        char_opt_equip  LOCKE
        char_opt_equip  EDGAR

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

        set_parent_map 0, $55, $6e, DIR_UP, 0, 0
        load_map $4b, 1, 28, DIR_UP, 0, $40
        fade_in
        unlock_screen

        start_timer 0, 240, $CBCE32, 0

        ; .byte   $45                     ; refresh objects

        obj_script_wait OBJ_TERRA
        obj_dir LEFT
        obj_end

        ; call_x          :+, 3

;         show_dlg_wait   $01ca
;         jmp_choice      choice1, choice2

; choice1:
;         take_gil        1
;         return

; choice2:
;         give_gil        1
;         return

        ; .linecont +
        ; if_switch_or    :+, $0130,1, $0132,0, $0001,1
        ; if_switch_and   :+, \
        ;         $0130,1, $0132,0, $0133,1, \
        ;         $0134,0, $0135,1, $0136,0, \
        ;         $0007,1
        ; .linecont -

        return

        .popcpu

.endif
        rts

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

LoadMap:
@bebc:  jsr     DisableInterrupts

.if LANG_EN
        jsr     InitDlgVWF
.endif

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
        cmp     #^EventScript_NoEvent
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
        jpl     @c0a4
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
        jeq     @c0a4                   ; branch if event simply returns

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
@c06e:  jsr     ExecEvent
        lda     $1eb9
        bpl     @c08a                   ; branch if user has control of character
        jsr     UpdateObjActions
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
        cmp     #^EventScript_NoEvent
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

.pushseg
.segment "map_init_event"

; d1/fa00
MapInitEvent:
        .incbin "map_init_event.dat"

.popseg

; ------------------------------------------------------------------------------
