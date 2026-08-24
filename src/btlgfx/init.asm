.import CharProp
.import StatusGfx
.import BattleMonsters
.import MonsterAlign

; ------------------------------------------------------------------------------

; [ init sine wave tables ]

InitSineBuf:
@0d5c:  ldx     #near w7ee7bf
        stz     $24
@0d61:  clr_a
        jsr     _c10d7d
        lda     $24
        clc
        adc     #$02
        sta     $24
        longa
        txa
        clc
        adc     #$0040
        tax
        shorta0
        cpx     #near w7ee7bf+512
        bne     @0d61
        rts

; ------------------------------------------------------------------------------

; [ calculate sine wave table ]

;  +X: destination address (+$7e0000)
; $24: wave amplitude

_c10d7d:
sin_tmp_buf_set:
@0d7d:  lda     #$10
        sta     $1a
        lda     #$40                    ; 32 iterations
        sta     $1c
        stz     $1d
        stz     $22
        bra     _0d91

_c10d8b:
sin_tmp_buf_set64:
@0d8b:  pha
        lda     #1
        sta     $22
        pla

sin_tmp_buf_set_main:
_0d91:  phx
        sta     $16
        stx     $10
        lda     #$7e
        sta     $12
        stz     $1b
        phb
        lda     #$00
        pha
        plb
        clr_ay
        lda     $16
        longa
        asl
        sta     $16
        lda     $22
        and     #1
        beq     @0dd3

; tornado (for hdma table with interlaced x and y values)
@0db1:  shorti
        jsr     _c16c02
        longi
        dec2
        sta     [$10],y
        lda     $16
        clc
        adc     $1a
        sta     $16
        iny4
        cpy     $1c
        bne     @0db1
        clr_a
        longi
        shorta
        plb
        plx
        rts

; for sine wave tables with only one set of values
@0dd3:  shorti
        jsr     _c16c02
        longi
        dec2
        sta     [$10],y
        lda     $16
        clc
        adc     $1a
        sta     $16
        iny2
        cpy     $1c
        bne     @0dd3
        clr_a
        longi
        shorta
        plb
        plx
        rts

; ------------------------------------------------------------------------------

; [ update hp/mp/status buffers (for graphics) ]

_c10df3:
copy_player_work:
@0df3:  clr_ax
        dex
        stx     $10
        stx     $12
        lda     near w7e628d       ; branch if victory fanfare is happening
        bne     @0e0c
        lda     near w7ee9ef       ; branch if battle time is not stopped
        beq     @0e0c
        inx
        stx     $12         ; mask all statuses except imp, clear, and magitek
        ldxflg  STATUS12, {IMP, VANISH, MAGITEK}
        stx     $10
@0e0c:  longa
        clr_axy
@0e11:  lda     near w7e2e78,x     ; update hp/mp/status buffers
        sta     near wCharGfxDataBuf::CurrHP,y
        lda     near w7e2e80,x
        sta     near wCharGfxDataBuf::MaxHP,y
        lda     near w7e2e88,x
        sta     near wCharGfxDataBuf::CurrMP,y
        lda     near w7e2e90,x
        sta     near wCharGfxDataBuf::MaxMP,y
        lda     near w7e2e98,x
        and     $10
        sta     near wCharGfxDataBuf::ActiveStatus12,y
        lda     near w7e2ea0,x
        and     $12
        sta     near wCharGfxDataBuf::ActiveStatus34,y
        inx2                ; next character
        tya
        clc
        adc     #$0020
        tay
        cpx     #$0008
        bne     @0e11
        shorta0
        stz     $10
        clr_ax
@0e4d:  lda     near w7e2ea0 + 1,x     ; update characters with hidden status (sneezed, etc.)
        andflg  STATUS4, HIDE
        eorflg  STATUS4, HIDE
        lsr
        ora     $10
        lsr
        sta     $10
        inx2
        cpx     #8
        bne     @0e4d
        lda     $10
        sta     near w7e61ad
        rts

; ------------------------------------------------------------------------------

; [  ]

_c10e67:
status_playcopy:
@0e67:  longa
        clr_ax
@0e6b:  lda     near wCharGfxDataBuf::ActiveStatus12,x
        sta     near wCharGfxDataBuf::ShownStatus12,x
        lda     near wCharGfxDataBuf::ActiveStatus34,x
        sta     near wCharGfxDataBuf::ShownStatus34,x
        txa
        clc
        adc     #$0020
        tax
        cpx     #$0080
        bne     @0e6b
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ load battle data ]

_c10e86:
mon_data_get:
@0e86:  ldx     #$000f      ; battle data is 15 bytes each
        stx     $22
        ldx     $11e0       ; battle number
        stx     $24
        longa
        jsr     Mult816       ; ++$26 = $22 * +$24 (pointer to battle data)
        shorta
        ldx     $26
        lda     f:BattleMonsters+14,x   ; $28 = top bit of monster numbers
        sta     $28
        longa
        lda     f:BattleMonsters,x   ; $10 = bg1 monsters (never used)
        xba
        lsr6
        and     #$003f
        sta     $10
        shorta0
        lda     f:BattleMonsters,x   ; vram map index
        lsr4
        sta     near w7e2000
        lda     f:BattleMonsters+1,x   ; monsters present
        and     #$3f
        sta     near w7e61aa
        clr_ay
@0eca:  lsr     $28
        rol
        and     #$01
        sta     $2a
        lda     f:BattleMonsters+8,x   ; x position
        and     #$f0
        lsr
        sta     near w7e80c3,y
        clr_a
        sta     near w7e80c3+1,y
        lda     f:BattleMonsters+8,x   ; y position
        and     #$0f
        asl3
        sta     near w7e80cf,y
        clr_a
        sta     near w7e80cf+1,y
        lsr     $10
        rol
        and     #$01
        sta     near w7e80f3+1,y     ; bg1 monster (never used)
        iny2
        inx
        cpy     #$000c
        bne     @0eca
        rts

; ------------------------------------------------------------------------------

; [ clear bg1 vertical scroll hdma data (battlefield region) ]

_c10f00:
bg1_line_init:
@0f00:  longa
        clr_ax
        lda     #$ffff
@0f07:  sta     near wBG1ScrollData::Vert,x
        inx4
        cpx     #151 * 4
        bne     @0f07
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ init menu list scrolling ??? ]

_c10f17:
line_init:
@0f17:  jsl     _c2b6f7
        jsr     _c146a5
        rts

; ------------------------------------------------------------------------------

; [ init character menu order ]

; $10: current menu slot (empty char slots are pushed to the bottom)
; $12: characters included in menu order (enemy characters are not included)
;

InitCharMenuOrder:
set_mess_main_poi:
@0f1f:  ldx     #$ffff                  ; start with no characters shown
        stx     near w7e64d6
        stx     near w7e64d6+2
        inx
        tay
        stz     $10
        stz     $12
        lda     near w7e2f47                   ; don't include enemy characters
        not_a
        sta     $14
        lda     near w7e6192                   ; include characters in the party
        and     $14
        sta     $14
@0f3c:  lda     near wCharGfxDataBuf::GfxID,x
        cmp     #$ff
        beq     @0f55                   ; branch if no character
        lda     $12
        ora     #$10                    ; activate character
        sta     $12
        lda     $14
        and     #$01
        beq     @0f55
        lda     $10
        sta     near w7e64d6,y
        iny
@0f55:  lsr     $14                     ; next character
        lsr     $12
        inc     $10
        txa
        clc
        adc     #$20
        tax
        cmp     #$80
        bne     @0f3c
        lda     $12
        sta     near w7e201d
        stz     near w7e61ac
        stz     near w7e61ad
        lda     near w7e2f4a                   ; character ai index
        sta     $22
        lda     #$18
        sta     $24
        jsr     Mult8
        ldx     $26
        lda     f:CharAI,x              ; character ai data
        and     #CHAR_AI_FLAG_HIDE_NAMES
        beq     @0f8e                   ; branch if character names are not hidden
        ldx     #$ffff
        stx     near w7e64d6                   ; hide all character names
        stx     near w7e64d6+2
@0f8e:  rts

; ------------------------------------------------------------------------------

; [ check if characters can change equipment ]

_c10f8f:
chr_equip_init:
@0f8f:  clr_ay
@0f91:  tya
        asl5
        tax
        lda     near wCharGfxDataBuf::CharID,x
        sta     $22
        lda     #$16
        sta     $24
        jsr     Mult8
        ldx     $26
        lda     f:CharProp+21,x   ; character can't change equipment during battle
        and     #CHAR_PROP_FIXED_EQUIP
        sta     near w7e6286,y
        iny                 ; next character
        cpy     #$0004
        bne     @0f91
        rts

; ------------------------------------------------------------------------------

; [  ]

_c10fb6:
player_work_init:
@0fb6:  ldx     #$0007
@0fb9:  stz     near wCharGfxDataBuf::_0,x
        stz     near wCharGfxDataBuf::_1,x
        stz     near wCharGfxDataBuf::_2,x
        stz     near wCharGfxDataBuf::_3,x
        inx
        cpx     #$0016
        bne     @0fb9
        lda     near w7e2e98
        ora     near w7e2e98 + 2
        ora     near w7e2e98 + 4
        ora     near w7e2e98 + 6
        andflg  STATUS1, MAGITEK
        lsr3
        sta     near wMagitekModeEnabled
        rts

; ------------------------------------------------------------------------------

; [ init character graphics ]

_c10fe0:
user_init_option:
.if LANG_EN
@0fe0:  clr_ax
@0fe2:  stz     near wCharGfxData,x     ; clear character graphics data
        inx
        cpx     #$0080
        bne     @0fe2
.endif
        stz     near w7ee9ec       ; disable animation sound effect
        stz     near wSfxDisabled       ; enable sound effects
        lda     $1dd1       ; battle end event flags
        sta     near w7eecef
        lda     $1d4e       ; wallpaper
        and     #$07
        sta     near w7e2f34
        stz     near w7ee9f1       ;
        lda     #$ff
        sta     near w7e2f46       ; make all characters targettable
        sta     near w7e6191       ; show all monsters
        sta     near wPauseNotAllowed       ; disable pause
        jsl     _c2bd43     ; init character ai data
        jsr     _c10e86
        lda     near w7e61aa
        sta     near w7e201e
        sta     near w7e2f2f
        sta     near w7e61ab
        clr_ax
        dex
        stx     near w7e61b2
        stx     near w7e61b2+2
        rts

; ------------------------------------------------------------------------------

; [ init battle graphics data ]

InitBattleGfx:
user_init:
@102a:  jsl     DecTimersMenuBattle_ext
        clr_ax
        lda     #$e0
@1032:  sta     $0300,x     ; clear sprite data
        inx
        cpx     #$0200
        bne     @1032
        clr_ax
@103d:  stz     $0500,x     ; clear high sprite data
        inx
        cpx     #$0020
        bne     @103d
        ldy     #$4000
        ldx     #$2000
        jsr     ClearVRAM       ; clear vram $4000-$6000
        ldy     #$2c00
        ldx     #$0400
        jsr     ClearVRAM       ; clear vram $2c00-$3000
        longa
        clr_ax
@105c:  sta     $7fa000,x   ; clear character graphics buffer
        sta     $7fa100,x
        sta     $7fa200,x
        sta     $7fa300,x
        inx2
        cpx     #$0100
        bne     @105c
        shorta
        ldx     $11e2       ; battle background
        stx     near w7eecb8
        lda     #$ff        ; disable nmi
        sta     zNMIState
        stz     near w7ee9ef       ; start battle time
        jsr     _c10fe0
        lda     near w7e2f44       ; invisible monsters
        not_a
        sta     near w7ee9e6       ; visible monsters
        jsr     _c10fb6
        jsr     _c10df3
        jsr     _c10e67
        jsr     InitCharMenuOrder
        lda     #$ff
        sta     near w7e60ab
        sta     z55                     ; blank tile (no dakuten)
        lda     #$51
        sta     z57                     ; dakuten tile (dots)
        inc
        sta     z59                     ; handakuten tile (circle)
        clr_ax
@10a9:  lda     #$c8
        sta     $04cc,x
        lda     #$97
        sta     $04cd,x
        clr_a
        sta     $04ce,x
        sta     $04cf,x
        inx4
        cpx     #$0024
        bne     @10a9
        lda     #$80
        sta     $051c
        lda     #$aa
        sta     $051d
        sta     $051e
        stz     $051f
        ldx     #$6800      ; clear menu bg1 tile data
        ldy     #$0800
        jsr     InitMenuTiles
        ldx     #$7000      ; clear menu bg2 tile data
        ldy     #$0800
        jsr     InitMenuTiles
        ldx     #$0c00      ; clear battlefield bg1 tile data
        ldy     #$0400
        jsr     InitBGTiles
        ldx     #$5400      ; clear battlefield bg3 tile data
        ldy     #$0400
        jsr     InitBG3Tiles
        ldx     #$7800      ; clear menu bg3 tile data
        ldy     #$0800
        jsr     InitBG3Tiles
        jsr     InitHypotenuseTbl
        clr_ax
@1105:  lda     f:CondemnNumGfxPtrs,x
        sta     near w7ee9d2,x
        inx
        cpx     #8
        bne     @1105
        jsr     LoadBattleBG
        jsr     InitMonsterGfx
        jsr     LoadMonsterPal
        jsr     _c13e72       ; init monster sprite data
        jsr     InitMonsterPos
        jsr     TfrMonsterGfx
        jsr     LoadMenuGfx
        jsr     InitMenuWindows
        jsr     _c10f17
        jsr     InitHDMA
        jsr     _c16b47
        jsr     _c1496b
        jsr     _c1468f
        jsr     InitMenuText
        jsr     TfrTopMenuTiles
        inc     near wEnableUpdateMenuWindowTiles
        jsr     InitCharGfx
        jsr     LoadStatusPal
        jsr     InitCursorSprites
        ldx     #near StatusGfx
        stx     $f3
        lda     #^StatusGfx
        sta     $f5
        ldx     #$a400
        stx     $f6
        lda     #$7f
        sta     $f8
        jsl     Decompress_ext
        ldx     #$0400
        stx     $36
        ldx     #$b800
        lda     #$7f
        ldy     #$2e00
        jsr     TfrVRAM

; transfer offset-per-tile data to vram
        ldx     #wOffsetPerTile::SIZE
        stx     $36
        ldx     #near wOffsetPerTile
        lda     #^wOffsetPerTile
        ldy     #$4000
        jsr     TfrVRAM

; copy target draw order from buffer
        clr_ax
@1183:  lda     near wTargetDrawOrderBuf,x
        sta     near wTargetDrawOrder,x
        inx
        cpx     #wTargetDrawOrderBuf::SIZE
        bne     @1183
        lda     #$09            ; 8x8 bg tiles, high priority bg3, mode 1
        sta     near w7e896f
        lda     #$09
        sta     near w7e8973
        lda     #$02            ; use mode 2 for slot menu for per-tile scroll
        sta     near w7e8977
        stz     near w7e896f+1
        stz     near w7e8974
        stz     near w7e8978

; battlefield region bg1 tilemap vram location = $0c00, 1 screen
        lda     #$0c
        sta     near w7e8971

; battlefield region bg2 tilemap vram location = $6000, 2 screens horizontal
        lda     #$61
        sta     near w7e8972

; battlefield region bg3 tilemap vram location = $5400, 1 screen
        lda     #$54
        sta     near w7e897b
        sta     near w7e897c                 ; bg4 location (unused)

; menu region bg1 tilemap vram location = $6800, 2 screens horizontal
        lda     #$69
        sta     near w7e8975

; slot region bg1 tilemap vram location = $6c00, 1 screen
        lda     #$6c
        sta     near w7e8979

; menu region bg2 tilemap vram location = $7000, 2 screens horizontal
        lda     #$71
        sta     near w7e8976
        sta     near w7e897a

; menu region bg3 tilemap vram location = $7800, 2 screens horizontal
        lda     #$79
        sta     near w7e897f
        sta     near w7e8980                 ; bg4 location (unused)
        sta     near w7e8984

; offset-per-tile data vram location = $4000, 1 screen
        lda     #$40
        sta     near w7e8983

; battlefield region bg1/bg2 gfx vram location = $0000/$1000
        lda     #$10
        sta     near w7e897d
        sta     near w7e607d

; battlefield region bg3/bg4 gfx vram location = $5000
        lda     #$55
        sta     near w7e897e

; mainscreen/subscreen designation
        lda     #$17                    ; enable sprites, bg1, bg2, bg3
        sta     near w7e898d
        sta     near w7e8991
        stz     near w7e8989                 ; disable all layers
        stz     near w7e898a
        stz     near w7e898e
        stz     near w7e8992

; menu/slot region bg1/bg2 gfx vram location = $2000
        lda     #$22
        sta     near w7e8981
        sta     near w7e8985

; menu/slot region bg3/bg4 gfx vram location = $5000
        lda     #$55
        sta     near w7e8982
        sta     near w7e8986

        clr_ax
        longa
        lda     #$ff97          ; full subtract, all layers, white
@1213:  sta     near w7eea32,x
        inx2
        cpx     #$01c0
        bne     @1213
        shorta0
        lda     #$80
        sta     near w7ee9f9
        clr_ax
@1227:  lda     #$08
        sta     near w7e9a1f,x
        stz     near w7e9a1f+2,x
        lda     #$f7
        sta     near w7e9a1f+1,x
        sta     near w7e9a1f+3,x
        inx4
        cpx     #$025c
        bne     @1227
@1240:  stz     near w7e9a1f,x
        stz     near w7e9a1f+2,x
        lda     #$f7
        sta     near w7e9a1f+1,x
        sta     near w7e9a1f+3,x
        inx4
        cpx     #$0400
        bne     @1240
        longa
        phb
        lda     #$025f
        ldx     #near w7e9a1f
        ldy     #near w7e9f1f
        mvn     w7e9a1f,w7e9f1f
        plb
        shorta0
        clr_ax
        lda     #$e0
@126e:  sta     near w7e8993+3,x
        inx4
        cpx     #$025c
        bne     @126e
        clr_ax
        lda     #$e0
        sta     $10
        stz     $1a
@1282:  lda     #$02
        sta     near w7e8993 + 151 * 4 + 1,x
        lda     #$82
        sta     near w7e8993 + 151 * 4 + 2,x
        lda     $10
        sta     near w7e8993 + 151 * 4 + 3,x
        inc     $1a
        lda     $1a
        cmp     #$03
        bne     @12a3
        stz     $1a
        lda     $10
        cmp     #$ff
        beq     @12a3
        inc     $10
@12a3:  inx4
        cpx     #$0120
        bne     @1282
        clr_axy
@12af:  lda     near w7e8993 + 152 * 4 + 3,x
        sta     near w7eea32 + 152 * 2 + 1,y
        lda     #$82
        sta     near w7eea32 + 152 * 2,y
        inx4
        iny2
        cpy     #$0090
        bne     @12af
        ldx     #$ffff
        stx     near wMenuQueue
        stx     near wMenuQueue + 2
        clr_ax
        dec
@12d1:  sta     near w7e602d,x
        inx
        cpx     #$0040      ; should be #$0050 *** bug ***
        bne     @12d1
        clr_ax
        dec
        sta     near wForceCharGfxTfr        ; no character gfx update required
@12e0:  sta     near wPlayerActionBuf,x
        inx
        cpx     #$0020
        bne     @12e0
        clr_ax
        stx     near w7e2f30
        stx     near w7e2f30 + 2
        jsr     InitSineBuf
        jsr     ClearBG1TileBuf
        ldx     #$04c0
        stx     $36
        ldx     #near w7ea97f
        lda     #^w7ea97f
        ldy     #$0c00
        jsr     TfrVRAM

; init fade in
        lda     #$4c
        sta     near w7ee9f7
        stz     near w7ee9f8
        lda     #1
        sta     near w7ee9f6                 ; enable fade in

; init timer tiles
        ldx     #$21ff
        stx     near w7e6290
        stx     near w7e6292
        stx     near w7e6294
        stx     near w7e6296
        stx     near w7e6298
        jsr     _c10f8f       ; check if characters can change equipment
        jsr     UpdateDrawOrder
        jsr     _c10659
        jsl     LoadCursorMem
        ldx     $11e0
        cpx     #$01d7
        bne     @1346
        inc     near w7e6282
        stz     near w7ee9e6
        stz     near w7e201e
        bra     @136a
@1346:  cpx     #$01e5
        bne     @136a       ; branch if not battle $01e5 (terra vs. soldiers)
        ldx     #array_offset w7e7e00, 0
        stx     $18
        ldx     #w7e7e00::SIZE
        stx     $1a
        jsl     FilterColors
        inc     near wEnableFlashback       ; enable flashback mode
        clr_ax
@135e:  lda     near w7e7e00::_12,x     ; copy unaltered character palettes
        sta     near w7e81ad,x
        inx
        cpx     #$0080
        bne     @135e
@136a:  lda     #1
        sta     near w7e7b0d       ; 1 thread to update
        sta     near w7e7b0e       ; 1 monster thread
        sta     near w7e7b0f       ; 1 character thread
        stz     near wHideBG1MonsterSprites
        stz     near w7e7b6b
        lda     #$17
        sta     f:hTM
        sta     f:hTMW
        stz     zNMIState
        inc     near w7e6197
        jsl     InitAnimVars
        longa
        jsl     UpdateBattleBG
        shorta0
        lda     near w7e201e
        pha
        stz     near w7e201e
@139e:  lda     f:hRDNMI
        bpl     @139e
@13a4:  lda     f:hRDNMI
        bpl     @13a4
        lda     #$81
        sta     f:hNMITIMEN
        cli
        inc     near w7e628c
        inc     near w7ee9ef       ; stop battle time
        clr_ax
@13b9:  lda     f:EntryGfxScript,x      ; copy char/monster entry script
        sta     near w7e2d6e,x
        inx
        cpx     #9
        bne     @13b9
        pla
        sta     near w7e2d6e::_0 + 3       ; monsters shown (flags)
        lda     near w7e61ab
        pha
        stz     near w7e61ab
        lda     near w7e2f48       ; monster entrance type
        and     #$0f
        sta     near w7e2d6e::_0 + 1
        tax
        lda     f:CharEntryFirstTbl,x
        beq     @13fc       ; branch if monsters enter before characters

; swap battle script commands
        ldx     near w7e2d6e::_0
        phx
        ldx     near w7e2d6e::_0 + 2
        phx
        ldx     near w7e2d6e::_1
        stx     near w7e2d6e::_0
        ldx     near w7e2d6e::_1 + 2
        stx     near w7e2d6e::_0 + 2
        plx
        stx     near w7e2d6e::_1 + 2
        plx
        stx     near w7e2d6e::_1
@13fc:  jsl     array_item BTL_GFX, BTL_GFX::GFX_SCRIPT
        pla
        sta     near w7e61ab

; wait for fade in
@1404:  jsr     WaitFrame
        lda     near w7ee9f6
        bne     @1404
        clr_ax
        stx     $10
        jsr     SetColorMathHDMA
        inc     near w7e7b96                 ; enable HDMA #5 update
        stz     near w7ee9ef                 ; start battle time
        stz     near w7e628c
        stz     near wPauseNotAllowed       ; enable pause
        rts

; ------------------------------------------------------------------------------

; set if characters enter before monsters (1 byte per monster entrance type)
CharEntryFirstTbl:
@1420:  .byte   0,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0

; battle script commands (monster entrance and character entrance)
EntryGfxScript:
@1431:  .byte   GFX_CMD::MONSTER_ENTRY_EXIT
        .byte   0
        .byte   0
        .byte   0

        .byte   GFX_CMD::BATTLE_EVENT
        .byte   BATTLE_EVENT_SCRIPT::CHAR_ENTRY
        .byte   0
        .byte   0

        .byte   GFX_CMD::TERMINATE

.enum CALC_MONSTER_POS
        COUNT = BATTLE_TYPE::COUNT
.endenum

; battle type jump table for monster positions
CalcMonsterPosTbl:
        ptr_tbl CALC_MONSTER_POS

; ------------------------------------------------------------------------------

; [ clear target group data ]

InitTargetGroups:
@1442:  clr_ax
        dec
@1445:  sta     near w7e7a86,x               ; clear target groups
        inx
        cpx     #24
        bne     @1445
        clr_ax
@1450:  stz     near w7e807b,x               ; clear monster cursor positions
        inx
        cpx     #12
        bne     @1450
        rts

; ------------------------------------------------------------------------------

; [  ]

_c1145a:
set_mon_gr0:
@145a:  clr_ax
@145c:  txa
        sta     near w7e7a86,x
        inx
        cpx     #6
        bne     @145c
        rts

; ------------------------------------------------------------------------------

; [  ]

_c11467:
@1467:  clr_ax
@1469:  txa
        sta     near w7e7a92,x
        inx
        cpx     #$0006
        bne     @1469
        rts

; ------------------------------------------------------------------------------

; [  ]

_c11474:
set_play_gr1:
@1474:  clr_ax
@1476:  txa
        sta     near w7e7a8c,x
        inx
        cpx     #$0004
        bne     @1476
        rts

; ------------------------------------------------------------------------------

; 0: normal

        array_label CALC_MONSTER_POS, BATTLE_TYPE::NORMAL
@1481:  jsr     _c1145a
        jsr     _c11474
        clr_ax
@1489:  lda     near w7e812f,x     ; monster width
        asl3
        sta     near w7e807b,x
        inx2
        cpx     #$000c
        bne     @1489
        rts

; ------------------------------------------------------------------------------

; 1: back

        array_label CALC_MONSTER_POS, BATTLE_TYPE::BACK
@149a:  jsr     _c11467
        jsr     _c11474
        clr_ax
        lda     #$20
@14a4:  sta     near w7e809f,x
        inx2
        cpx     #$0008
        bne     @14a4
        clr_ax
@14b0:  lda     near w7e812f,x     ; monster width
        asl3
        sta     $10
        lda     near w7e80c3,x     ; negate x position
        neg_a
        sec
        sbc     $10         ; subtract width
        sta     near w7e80c3,x
        lda     near w7e80f3,x     ; face left
        eor     near w7e617e,x
        eor     #$01
        sta     near w7e80f3,x
        inx2
        cpx     #$000c
        bne     @14b0
        rts

; ------------------------------------------------------------------------------

; 2: pincer

        array_label CALC_MONSTER_POS, BATTLE_TYPE::PINCER
@14d7:  jsr     _c11474
        clr_ax
        stz     $10
        stz     $12
        stz     $16
@14e2:  lda     near w7e812f,x     ; monster width
        asl3
        sta     $14
        lda     near w7e80c3,x     ; x position
        clc
        adc     $14
        cmp     #$68
        bcc     @151a       ; branch if on left side of screen
        lda     near w7e80c3,x
        sec
        sbc     #$40
        clc
        adc     $14
        neg_a
        sta     near w7e80c3,x
        lda     near w7e80f3,x
        eor     near w7e617e,x
        eor     #$01
        sta     near w7e80f3,x
        lda     $12
        tay
        lda     $16
        sta     near w7e7a92,y                 ; monsters on the right
        inc     $12
        bra     @1529
@151a:  lda     $14
        sta     near w7e807b,x
        lda     $10
        tay
        lda     $16
        sta     near w7e7a86,y                 ; monsters on the left
        inc     $10
@1529:  inc     $16
        inx2
        cpx     #12
        bne     @14e2
        rts

; ------------------------------------------------------------------------------

; 3: side

        array_label CALC_MONSTER_POS, BATTLE_TYPE::SIDE
@1533:  jsr     _c11467
        clr_a
        sta     near w7e7a98
        inc
        sta     near w7e7a98+1
        inc
        sta     near w7e7a8c
        inc
        sta     near w7e7a8c+1
        lda     #$20
        sta     near w7e809f+4
        sta     near w7e809f+6
        clr_ax
@1550:  lda     near w7e812f,x     ; monster width
        asl3
        sta     $12
        lsr
        sta     $10
        lda     near w7e80c3,x     ; x position
        clc
        adc     #$30
        sta     near w7e80c3,x
        clc
        adc     $10
        bmi     @1576       ; branch if center x-coordinate of monster is greater than $7f
        lda     near w7e80f3,x     ; flip monster horizontally
        eor     near w7e617e,x
        eor     #$01
        sta     near w7e80f3,x
        bra     @157b
@1576:  lda     $12
        sta     near w7e807b,x
@157b:  inx2
        cpx     #$000c
        bne     @1550
        rts

; ------------------------------------------------------------------------------

; y-offsets for monster vertical alignment
;   0: ceiling
;   1: ground
;   2: floating
;   3: buried
;   4: flying

MonsterAlignOffset:
        .lobytes 96, 0, -8, 8, -40

; ------------------------------------------------------------------------------

; [ init monster positions ]

InitMonsterPos:
@1588:  jsr     InitTargetGroups
        stz     near w7e7b79                 ; clear target masks for target groups
        stz     near w7e7b7a
        stz     near w7e7b7b
        stz     near w7e7b7c
        clr_ax
@1599:  stz     near w7e80f3,x               ; clear vh flip for monsters
        inx
        cpx     #$000c
        bne     @1599
        lda     near w7e201f                   ; battle type
        asl
        tax
        jsr     CalcMonsterPos
        jsr     SortTargetGroups
        lda     near w7e7b79
        sta     near w7e2eac
        lda     near w7e7b7b
        sta     near w7e2ead

; return if not a colosseum battle
        ldx     $11e0
        cpx     #$023f                  ; battle $023f (colosseum)
        bne     @1603
        lda     near w7e812f                 ; width
        asl3
        sta     $10
        lda     near w7e812f+1               ; height
        asl3
        sta     $12
        lda     #$80
        sec
        sbc     $12
        tax
        stx     near w7e80cf                 ; top y position
        lda     near w7e2001                   ; monster index
        tax
        lda     f:MonsterAlign,x        ; monster vertical alignment
        bne     @15e9
        stz     near w7e80cf                 ; align with top of screen (ceiling)
        bra     @15f6
@15e9:  dec
        tax
        lda     near w7e80cf
        clc
        adc     f:MonsterAlignOffset+1,x
        sta     near w7e80cf                 ; top y position
@15f6:  lda     #$80
        sec
        sbc     $10
        lsr
        clc
        adc     #$18
        tax
        stx     near w7e80c3                 ; left x position
@1603:  rts

; ------------------------------------------------------------------------------

; [ init monster positions for each battle type ]

CalcMonsterPos:
@1604:  jmp     (near CalcMonsterPosTbl,x)   ; jump based on battle type

; ------------------------------------------------------------------------------

; [ sort targets for moving between target groups ]

SortTargetGroups:
@1607:  clr_ax
        dec
@160a:  sta     near w7e7a9e,x               ; clear target cursor data
        inx
        cpx     #$0030
        bne     @160a

; sort characters
        clr_ax
        sta     $10
        lda     #3
        sta     $12
@161b:  lda     $10
        sta     near w7e7ab6,x               ; unused
        sta     near w7e7ac2,x               ; this is the only one that is used
        lda     $12
        sta     near w7e7abc,x               ; unused
        sta     near w7e7ac8,x               ; unused
        inc     $10
        dec     $12
        inx
        cpx     #4
        bne     @161b

; sort monsters left to right (press left)
        clr_axy
        longa
@163a:  lda     near w7e80c3,x
        sta     near w7e7ad0::Pos,y
        inx2
        iny4
        cpx     #$000c
        bne     @163a
        shorta0
        jsr     SortMonsterTargetGroup
        clr_axy
@1654:  lda     near w7e7ad0::Index,x
        sta     near w7e7a9e,y
        iny
        inx4
        cpy     #6
        bne     @1654

; sort monsters right to left (press right)
        clr_axy
        longa
@1669:  lda     near w7e812f,x
        and     #$00ff
        asl3
        clc
        adc     near w7e80c3,x
        sta     near w7e7ad0::Pos,y
        inx2
        iny4
        cpx     #$000c
        bne     @1669
        shorta0
        jsr     SortMonsterTargetGroup
        clr_ax
        ldy     #5
@168f:  lda     near w7e7ad0::Index,x
        sta     near w7e7aa4,y
        dey
        inx4
        cpx     #$0018
        bne     @168f

; sort monsters top to bottom (unused)
        clr_axy
        longa
@16a4:  lda     near w7e80cf,x
        sta     near w7e7ad0::Pos,y
        inx2
        iny4
        cpx     #$000c
        bne     @16a4
        shorta0
        jsr     SortMonsterTargetGroup
        clr_axy
@16be:  lda     near w7e7ad0::Index,x
        sta     near w7e7aaa,y
        iny
        inx4
        cpy     #6
        bne     @16be

; sort monsters bottom to top (unused)
        clr_axy
        longa
@16d3:  lda     near w7e812f+1,x
        and     #$00ff
        asl3
        clc
        adc     near w7e80cf,x
        sta     near w7e7ad0::Pos,y
        inx2
        iny4
        cpx     #$000c
        bne     @16d3
        shorta0
        jsr     SortMonsterTargetGroup
        clr_ax
        ldy     #5
@16f9:  lda     near w7e7ad0::Index,x
        sta     near w7e7ab0,y
        dey
        inx4
        cpx     #$0018
        bne     @16f9

; generate bitmasks for targets on each side of the screen
        clr_ay
@170b:  lda     near w7e7a86,y               ; monsters on the left
        bmi     @171b
        tax
        lda     f:TargetMaskTbl,x
        ora     near w7e7b79
        sta     near w7e7b79
@171b:  lda     near w7e7a8c,y               ; characters on the left
        bmi     @172b
        tax
        lda     f:TargetMaskTbl,x
        ora     near w7e7b7a
        sta     near w7e7b7a
@172b:  lda     near w7e7a92,y               ; monsters on the right
        bmi     @173b
        tax
        lda     f:TargetMaskTbl,x
        ora     near w7e7b7b
        sta     near w7e7b7b
@173b:  lda     near w7e7a98,y               ; characters on the right
        bmi     @174b
        tax
        lda     f:TargetMaskTbl,x
        ora     near w7e7b7c
        sta     near w7e7b7c
@174b:  iny
        cpy     #6
        bne     @170b
        rts

; ------------------------------------------------------------------------------

; [ sort monster targets by position ]

SortMonsterTargetGroup:
@1752:  longa
        clr_ax
        stz     $10
@1758:  lda     $10
        sta     near w7e7ad0::Index,x
        inc     $10
        inx4
        cpx     #$0018
        bne     @1758
@1768:  clr_ax
        stz     $14
@176c:  lda     near w7e7ad0::_0::Pos,x
        cmp     near w7e7ad0::_1::Pos,x
        beq     @1794
        bcc     @1794
        inc     $14
        lda     near w7e7ad0::_1::Pos,x
        pha
        lda     near w7e7ad0::_0::Pos,x
        sta     near w7e7ad0::_1::Pos,x
        pla
        sta     near w7e7ad0::_0::Pos,x
        lda     near w7e7ad0::_1::Index,x
        pha
        lda     near w7e7ad0::_0::Index,x
        sta     near w7e7ad0::_1::Index,x
        pla
        sta     near w7e7ad0::_0::Index,x
@1794:  inx4
        cpx     #$0014
        bne     @176c
        lda     $14
        bne     @1768
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ clear bg data in vram ]

; +X: destination (vram)
; +Y: size (words)

InitBG3Tiles:
@17a5:  phb
        lda     #$00
        pha
        plb
        stx     hVMADDL
        longa
        lda     #$01ee      ; tile $01ee
@17b2:  sta     hVMDATAL
        dey
        bne     @17b2
        shorta0
        plb
        rts

; ------------------------------------------------------------------------------
