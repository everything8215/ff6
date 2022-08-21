
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: menu.asm                                                             |
; |                                                                            |
; | description: menu program                                                  |
; |                                                                            |
; | created: 8/2/2022                                                          |
; +----------------------------------------------------------------------------+

.p816

.include "const.inc"
.include "hardware.inc"
.include "macros.inc"

.include "menu_data.asm"

.import ExecSound_ext

.export OpenMenu_ext, UpdateCtrlBattle_ext, InitCtrl_ext, UpdateCtrlField_ext
.export IncGameTime_ext, LoadSavedGame_ext, EndingCutscene_ext
.export OptimizeEquip_ext, EndingAirshipScene_ext

; ------------------------------------------------------------------------------

.segment "menu_code"
.a8
.i16

; ------------------------------------------------------------------------------

OpenMenu_ext:
@0000:  jmp     OpenMenu

UpdateCtrlBattle_ext:
@0003:  jmp     UpdateCtrlBattle

InitCtrl_ext:
@0006:  jmp     InitCtrl

UpdateCtrlField_ext:
@0009:  jmp     UpdateCtrlField

IncGameTime_ext:
@000c:  jmp     IncGameTime

LoadSavedGame_ext:
@000f:  jmp     LoadSavedGame

EndingCutscene_ext:
@0012:  jmp     EndingCutscene

OptimizeEquip_ext:
@0015:  jmp     OptimizeEquip

EndingAirshipScene_ext:
@0018:  jmp     EndingAirshipScene

; ------------------------------------------------------------------------------

; [ open menu ]

OpenMenu:
@001b:  longi
        shorta
        lda     #$00                    ; set data bank
        pha
        plb
        ldx     #$0000                  ; set direct page
        phx
        pld
        ldx     #$0000                  ; set $00
        stx     $00
        lda     #$7e
        sta     $2183                   ; set wram bank
        jsr     InitInterrupts
        lda     $0200
        cmp     #$02
        bne     @003f                   ; branch if not opening game load menu
        jsr     InitSaveSlot
@003f:  jsr     InitMenu
        jsr     OpenMenuType
        jsl     InitCtrl
        lda     #$8f
        sta     $2100
        stz     $4200
        stz     $420b
        stz     $420c
        lda     $0200
        cmp     #$02
        bne     @006f                   ; branch if not restoring a saved game
        lda     $0205
        bpl     @006f                   ; branch if tent/warp/warp stone was used
        lda     $1d4e
        and     #$20
        beq     @006f                   ; branch if stereo mode
        ; lda     #$ff
        ; jsr     $3e3f       ; set mono/stereo mode
@006f:  lda     $0200
;         bne     @00bf       ; branch if not main menu
;         lda     $0205
;         bpl     @00bf       ; return if return code is positive
;         cmp     #$fe
;         bne     @009e       ; branch if not using rename card
;
; ; rename card
;         lda     #$01
;         sta     $0200
;         lda     $0201
;         sta     $020f
;         ldy     $0206
;         sty     $0201
;         jsl     OpenMenu
;         lda     $020f
;         sta     $0201
;         stz     $0200
;         jmp     @001b
;
; ; swdtech renaming (ff6j)
; @009e:  lda     #$06
;         sta     $0200
;         lda     $0201
;         sta     $020f
;         lda     $0206
;         sta     $0201
;         jsl     OpenMenu
;         lda     $020f
;         sta     $0201
;         stz     $0200
;         jmp     @001b

; return from menu
@00bf:  rtl

; ------------------------------------------------------------------------------

; [ set up interrupt jump code ]

InitInterrupts:
@00c0:  lda     #$5c
        sta     $1500
        sta     $1504
        ldx     #.loword(MenuNMI)
        stx     $1501
        ldx     #.loword(MenuIRQ)
        stx     $1505
        lda     #^MenuNMI
        sta     $1503
        sta     $1507
        rts

; ------------------------------------------------------------------------------

; [ open menu (type) ]

OpenMenuType:
@00dd:  tdc
        lda     $0200
        asl
        tax
        jmp     (.loword(MenuTypeTbl),x)

; menu type jump table
MenuTypeTbl:
        .addr   MainMenu
        .addr   NameChangeMenu
        .addr   GameLoadMenu
        .addr   ShopMenu
        .addr   PartySelectMenu
        .addr   ItemDetailsMenu
        .addr   BushidoNameMenu
        .addr   ColosseumMenu
        .addr   FinalBattleOrderMenu

; ------------------------------------------------------------------------------

; [ init menu ]

InitMenu:
@00f8:  ; jsr     $68fa       ; init menu ram
        ; jsr     $6915       ; init party character data
        ; jsr     $69a9       ;
        ; jsl     $d4cd48     ; init menu hardware registers
        jsl     InitCtrl
        tdc
        ; jsl     $d4ca1d     ; init hdma for menu window gradient bars
        ; jsr     $69dc       ; init window 1 position hdma
        ; jsr     $1114       ; init threads
        ; jsr     $6a87       ; init menu graphics
        ; jmp     @3a87       ; init custom menu window
        rts

; ------------------------------------------------------------------------------

; [ menu type $00: main menu ]

MainMenu:
@011a:  lda     #$04                    ; menu state $04 (main menu init)
        sta     $26
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $03: shop ]

ShopMenu:
@0121:  ; jsr     $3f99                   ; init font color
        lda     #$24                    ; menu state $24 (shop init)
        sta     $26
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $04: party select ]

PartySelectMenu:
@012b:  ; jsr     $3f99                   ; init font color
        ; jsr     $0138                   ; clear previous cursor position
        lda     #$2c                    ; menu state $2c (party select init)
        sta     $26
        jmp     MenuLoop

; ------------------------------------------------------------------------------

; [ clear previous cursor position ]

@0138:  tdc
        tay
        sty     $8e
        rts

; ------------------------------------------------------------------------------

; [ menu type $05: item details ??? (unused) ]

ItemDetailsMenu:
@013d:  ; jsr     $3f99                   ; init font color
        ; jsr     $0138                   ; clear previous cursor position
        lda     #$2f                    ; menu state $2f (item details)
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $06: swdtech renaming (ff6j) ]

BushidoNameMenu:
@0149:  ; jsr     $3f99                   ; init font color
        lda     #$3f                    ; menu state $3f
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $07: colosseum ]

ColosseumMenu:
@0152:  ; jsr     $3f99                   ; init font color
        stz     $79
        stz     $7a
        stz     $7b
        lda     #$ff
        sta     $0205
        lda     #$71                    ; menu state $71 (colosseum item select init)
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $08: final battle order ]

FinalBattleOrderMenu:
; @0166:  jsr     $3f99                   ; init font color
        lda     #$73                    ; menu state $73 (final battle order init)
        sta     $26
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $02: restore game ]

GameLoadMenu:
@016f:  lda     $307ff1                 ; increment random number seed
        inc
        sta     $307ff1
        jsl     InitCtrl
        jsr     CheckSRAM
        ; bcc     @019f                   ; branch if sram is invalid
        ; lda     #$01                    ; song $01 (the prelude)
        ; sta     $1301
        ; lda     #$10
        ; sta     $1300
        ; lda     #$80
        ; sta     $1302
        ; jsl     ExecSound_ext
        ; lda     #$ff
        ; sta     $0205
        ; lda     #$20                    ; menu state $20 (restore game init)
        ; sta     $26
        ; bra     MenuLoop

; sram invalid
; @019f:  jsr     $2a21                   ; clear game time
        lda     #1
        sta     $0224                   ; current saved game slot = 1
        stz     $021f                   ; don't load a saved game
        lda     #$ff
        sta     $26                     ; terminate menu
        stz     $0205                   ; clear return code
        bra     MenuLoop

; ------------------------------------------------------------------------------

; [ menu type $01: name change ]

NameChangeMenu:
@01b3:  ; jsr     $3f99                   ; init font color
        lda     #$5d                    ; menu state $5d (name change init)
        sta     $26
; fall through

; ------------------------------------------------------------------------------

; [ menu state loop ]

MenuLoop:
; @01ba:  jsr     $1412                   ; update hardware registers
@01bd:  tdc
        ; lda     $26                     ; return if menu state is $ff
        ; cmp     #$ff
        ; beq     @01d8
        ; longa
        ; asl
        ; tax
        ; shorta
        ; jsr     ($01db,x)               ; do menu state code
        ; jsr     $11b0                   ; execute threads
        ; jsr     $134d                   ; wait for next frame
        ; jsr     $02db                   ; check timer 0
        ; bra     @01bd
@01d8:  stz     $43                     ; disable hdma
        rts

; ------------------------------------------------------------------------------

; [ menu nmi ]

MenuNMI:
@1387:  rti

; ------------------------------------------------------------------------------

; [ menu irq ]

MenuIRQ:
@13c7:  rti

; ------------------------------------------------------------------------------

; [ increment game time ]

IncGameTime:
@13c8:  rtl

; ------------------------------------------------------------------------------

LoadSavedGame:
@14fe:  lda     $021f                   ; branch if not loading a saved game
        ; beq     @1514
        ; jsr     $1566                   ; load saved game data
        ; jsr     $19d1                   ; calculate saved game data checksum
        ; jsr     $19eb                   ; check saved game data checksum
        ; beq     @1514                   ; branch if checksum invalid
        ; jsr     $1595                   ; restore timer data
        ; tdc                             ; return $00
        ; bra     @1518
@1514:  shorta
        lda     #$ff                    ; return $ff
@1518:  sta     $0205
        tdc
        rtl

; ------------------------------------------------------------------------------

; [ load window palette ]

LoadWindowPal:
@6bbc:  ldx     #8
        stx     $e7
        ldx     #0
        txy
        longa
@6bc7:  lda     #7
        sta     $e9
@6bcc:  lda     f:WindowPal+2,x         ; load wallpaper palettes
        sta     $1d57,y
        inx2
        iny2
        dec     $e9
        bne     @6bcc
        txa
        clc
        adc     #$0012
        tax
        dec     $e7
        bne     @6bc7
        shorta
        rts

; ------------------------------------------------------------------------------

; [ check if sram is valid ]

CheckSRAM:
@7023:  longa
        lda     #$e41b                  ; fixed value
        cmp     $307ff8
        beq     @7047
        cmp     $307ffa
        beq     @7047
        cmp     $307ffc
        beq     @7047
        cmp     $307ffe
        beq     @7047
        shorta
        jsr     ClearSRAM
        clc
        rts
@7047:  shorta
        sec
        rts

; ------------------------------------------------------------------------------

; [ clear sram ]

ClearSRAM:
@704b:  phb
        lda     #$30
        pha
        plb
        ldx     #0
        longa
@7055:  stz     $6000,x                 ; clear 30/6000-30/7fff
        inx
        inx
        stz     $6000,x
        inx2
        cpx     #$2000
        bne     @7055
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ init saved menu cursor positions ]

_c37068:
@7068:  ldx     #0
@706b:  stz     $022b,x                 ; clear saved menu cursor positions
        inx
        cpx     #$001f
        bne     @706b
        lda     #$01                    ; character skills cursors default to magic
        sta     $0237
        sta     $0239
        sta     $023b
        sta     $023d
        rts

; ------------------------------------------------------------------------------

; [ make sram valid ]

ValidateSRAM:
@7083:  longa
        lda     #$e41b                  ; set fixed value
        sta     $307ff8
        sta     $307ffa
        sta     $307ffc
        sta     $307ffe
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init saved game data ]

InitSaveSlot:
@709b:  jsr     _c37068
        ldy     #$7fff                  ; set default font color
        sty     $1d55
        lda     #$12                    ; set default button mappings
        sta     $1d50
        lda     #$34
        sta     $1d51
        lda     #$56
        sta     $1d52
        lda     #$06
        sta     $1d53
        lda     #$2a                    ;
        sta     $1d4d
        tdc
        tay
        sty     $1dc7                   ;
        stz     $1d54
        stz     $1d4e
        stz     $1d4f
        sty     $1863                   ; clear game time
        stz     $1865
        sty     $1860                   ; clear gp
        stz     $1862
        sty     $1866                   ; clear steps
        stz     $1868
        sty     $021b                   ; clear menu game time
        sty     $021d
        jsr     LoadWindowPal
        rts

; ------------------------------------------------------------------------------

OptimizeEquip:
@96d2:  rtl

; ------------------------------------------------------------------------------

; [ init controller ]

InitCtrl:
@a424:  lda     #$08                    ; set direction button repeat delay (8 frames)
        sta     $0229
        lda     #$03                    ; set button repeat rate (3 frames/repeat)
        sta     $022a
        sta     $0226
        lda     #$20                    ; set a button repeat delay (32 frames)
        sta     $0225
        lda     $1d54                   ; branch if no special button configuration
        and     #$40
        beq     @a441
        jsr     SetCustomBtnMap
        rtl
@a441:  jsr     SetDefaultBtnMap
        rtl

; ------------------------------------------------------------------------------

; [ update controller (battle) ]

UpdateCtrlBattle:
@a445:  lda     $1d54
        bpl     @a458
        tdc
        lda     $0201
        tax
        lda     $1d4f
        and     f:_c3a53d,x
        bne     @a45d
@a458:  ldx     hSTDCNTRL1L
        bra     @a462
@a45d:  ldx     hSTDCNTRL2L
        bra     @a462
@a462:  jsr     _c3a483
        jsr     _c3a4bd
        jsr     _c3a4f6
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [ update controller (menu) ]

UpdateCtrlMenu:
@a46e:  ldx     hSTDCNTRL1L
        jsr     _c3a483
        jsr     _c3a4bd
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [ update controller (field/world) ]

UpdateCtrlField:
@a47a:  ldx     hSTDCNTRL1L
        jsr     _c3a483
        jmp     _c3a527

; ------------------------------------------------------------------------------

; [  ]

joy_getsub:
_c3a483:
@a483:  ldy     $e0                     ; push dp variables
        sty     $0213
        ldy     $e7
        sty     $0215
        ldy     $e9
        sty     $0217
        ldy     $eb
        sty     $0219
        stx     $eb
        longa
        lda     $0c
        and     #$fff0
        sta     $e0
        jsr     _c3a541
        lda     $0c
        eor     #$ffff
        and     $06
        sta     $08
        ldy     $06
        sty     $0c
        lda     hSTDCNTRL1L
        ora     hSTDCNTRL2L
        sta     $04
        shorta
        rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4bd:
@a4bd:  longa
        lda     $06
        and     #$fff0
        cmp     $e0
        shorta
        bne     @a4e5
        lda     $0227
        beq     @a4d4
        dec     $0227
        bne     @a4f1
@a4d4:  dec     $0228
        bne     @a4f1
        lda     $022a
        sta     $0228
        ldy     $06
        sty     $0a
        bra     @a4f5
@a4e5:  lda     $0229
        sta     $0227
        lda     $022a
        sta     $0228
@a4f1:  ldy     $08
        sty     $0a
@a4f5:  rts

; ------------------------------------------------------------------------------

; [  ]

_c3a4f6:
@a4f6:  lda     $06
        bit     #$80
        beq     @a517
        lda     $0225
        beq     @a506
        dec     $0225
        bne     @a522
@a506:  dec     $0226
        bne     @a522
        lda     $022a
        sta     $0226
        lda     #$80
        tsb     $0a
        bra     @a526
@a517:  lda     #$20
        sta     $0225
        lda     $022a
        sta     $0226
@a522:  lda     $08
        sta     $0a
@a526:  rts

; ------------------------------------------------------------------------------

; [ pop dp variables used for joypad ]

joy_sub3:
_c3a527:
@a527:  ldy     $0213
        sty     $e0
        ldy     $0215
        sty     $e7
        ldy     $0217
        sty     $e9
        ldy     $0219
        sty     $eb
        tdc
        rtl

; ------------------------------------------------------------------------------

_c3a53d:
@a53d:  .byte   $01,$02,$04,$08

; ------------------------------------------------------------------------------

; [  ]

.a16

_c3a541:
@a541:  lda     $eb
        and     #$0f00
        sta     $06
        lda     #$0080
        sta     $e7
        lda     #$8000
        sta     $e9
        ldy     $00
        jsr     _c3a581
        lda     #$0040
        sta     $e7
        lda     #$4000
        sta     $e9
        iny
        jsr     _c3a581
        lda     #$0020
        sta     $e7
        lda     #$0010
        sta     $e9
        iny
        jsr     _c3a581
        lda     #$1000
        sta     $e7
        lda     #$2000
        sta     $e9
        iny
        jmp     _c3a581

.a8

; ------------------------------------------------------------------------------

; [  ]

_c3a581:
@a581:  lda     $eb
        bit     $e7
        beq     @a59b
        tdc
        shorta
        lda     $0220,y
        and     #$f0
        longa
        lsr3
        tax
        lda     f:_c3a5b4,x
        tsb     $06
@a59b:  lda     $eb
        bit     $e9
        beq     @a5b3
        tdc
        shorta
        lda     $0220,y
        and     #$0f
        longa
        asl
        tax
        lda     _c3a5b4,x
        tsb     $06
@a5b3:  rts

; ------------------------------------------------------------------------------

_c3a5b4:
@a5b4:  .word   $1000,$0080,$8000,$0040,$4000,$0020,$0010,$2000

; ------------------------------------------------------------------------------

; [ set custom button mapping ]

SetCustomBtnMap:
@a5c4:  ldy     $1d50
        sty     $0220
        ldy     $1d52
        sty     $0222
        rts

; ------------------------------------------------------------------------------

; [ set default button mapping ]

SetDefaultBtnMap:
@a5d1:  ldy     #$3412
        sty     $0220
        ldy     #$0656
        sty     $0222
        rts

; ------------------------------------------------------------------------------

EndingCutscene:
@c51c:  rtl

; ------------------------------------------------------------------------------

EndingAirshipScene:
@c51c:  rtl

; ------------------------------------------------------------------------------
