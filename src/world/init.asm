
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: world/init.asm                                                       |
; |                                                                            |
; | description: world map initialization routines                             |
; |                                                                            |
; | created: 5/12/2023                                                         |
; +----------------------------------------------------------------------------+

.include "sound/song_script.inc"

.import RNGTbl
.import World1BGPal, World2BGPal, World1SpritePal, World2SpritePal, World3Pal
.import EventScript_NoEvent, EventScript_GameOver

; ------------------------------------------------------------------------------

; airship songs (blackjack, searching for friends)
AirshipSongTbl:
@8389:  .byte   SONG::BLACKJACK
        .byte   SONG::BLACKJACK
        .byte   SONG::SEARCHING_FOR_FRIENDS
        .byte   SONG::SEARCHING_FOR_FRIENDS

; ------------------------------------------------------------------------------

; chocobo songs (techno de chocobo)
ChocoSongTbl:
@838d:  .byte   SONG::TECHNO_DE_CHOCOBO
        .byte   SONG::TECHNO_DE_CHOCOBO
        .byte   SONG::TECHNO_DE_CHOCOBO
        .byte   SONG::TECHNO_DE_CHOCOBO

; ------------------------------------------------------------------------------

; world map songs (terra, veldt, dark world, searching for friends)
WorldSongTbl:
@8391:  .byte   SONG::TERRA
        .byte   SONG::VELDT              ; unused, i think
        .byte   SONG::DARK_WORLD
        .byte   SONG::SEARCHING_FOR_FRIENDS

; ------------------------------------------------------------------------------

; train ride songs (save them!)
TrainSongTbl:
@8395:  .byte   SONG::SAVE_THEM
        .byte   SONG::SAVE_THEM          ; unused

; ------------------------------------------------------------------------------

; serpent trench songs (the serpent trench)
SnakeSongTbl:
@8397:  .byte   SONG::SERPENT_TRENCH
        .byte   SONG::SERPENT_TRENCH

; ------------------------------------------------------------------------------

; [ init world map ]

LoadWorld:
@8399:  shorta
        lda     #$00
        pha
        plb
        lda     $11f6                   ; disable battle
        and     #$fd
        sta     $11f6
        longa
        stz     $04                     ; clear pressed buttons
        stz     $06
        stz     $08
        stz     $0a
        stz     $0c
        stz     $0e
        lda     $1f64                   ; map index
        and     #$01ff
        cmp     #$0002
        jeq     InitSnakeRoad           ; branch if not serpent trench
        shorta
        lda     $1f68                   ; facing direction
        bpl     @83ce
        and     #$7f
        bra     @83d7
@83ce:  lda     $1f65
        lsr4
        and     #$03
@83d7:  sta     $1f68
        lda     $11f3
        jmi     InitAirship
        lda     $11fa                   ; vehicle
        and     #$03
        beq     @83f0
        cmp     #$02
        beq     @83f3
        jmp     InitAirship
@83f0:  jmp     InitWorld
@83f3:  jmp     InitChoco

; ------------------------------------------------------------------------------

; [ reload map ]

ReloadMap:
@83f6:  shorta
        lda     #$00
        pha
        plb
        longa
        lda     $1f64
        and     #$01ff
        cmp     #$0002
        jeq     InitSnakeRoad           ; branch if not serpent trench
        shorta
        lda     $11fa                   ; vehicle
        and     #$03
        beq     @841c
        cmp     #$02
        beq     @841f
        jmp     InitAirship
@841c:  jmp     InitWorld
@841f:  jmp     InitChoco

; ------------------------------------------------------------------------------

; [ init world map (airship) ]

InitAirship:
@8422:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        lda     $1eb7
        and     #$f7
        sta     $1eb7
        lda     $11f6
        bit     #$02
        beq     @8442                   ; branch if battle is not enabled
        jsr     PopDP
        bra     @8469
@8442:  jsr     PushMode7Vars
        longa
        lda     $1f60
        lsr4
        and     #$0ff0
        sta     $38
        lda     $1f60
        asl4
        and     #$0ff0
        sta     $34
        shorta
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
@8469:  lda     #$01
        sta     $ca
        lda     #$01
        sta     $20
        lda     #$01
        sta     $7eb652
        lda     #$10
        sta     $1300
        lda     #$ff
        sta     $1302
        lda     $1eb9
        bit     #$10
        bne     @84b0
        lda     $1eb7
        bit     #$08
        beq     @8493
        lda     #$19
        bra     @84a8
@8493:  clr_a
        xba
        lda     $1f64
        and     #$03
        asl
        tax
        lda     $1eb7
        bit     #$01
        beq     @84a4
        inx
@84a4:  lda     f:AirshipSongTbl,x
@84a8:  sta     $1f80
        sta     $1301
        bra     @84b6
@84b0:  lda     $1f80
        sta     $1301
@84b6:  jsl     ExecSound_ext
        shorta
        phb
        lda     #$7e
        pha
        plb
        lda     f:$001f64
        bne     @84cc
        ldx     #$0000
        bra     @84cf
@84cc:  ldx     #$0100
@84cf:  ldy     #$0000
        longa
@84d4:  lda     f:World1BGPal,x
        sta     $e000,y
        iny2
        inx2
        cpy     #$0100
        bne     @84d4
        shorta
        lda     f:$001f64
        bne     @84f1
        ldx     #$0200
        bra     @84f4
@84f1:  ldx     #$0300
@84f4:  ldy     #$0000
        longa
@84f9:  lda     f:World1BGPal,x
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @84f9
        plb
        shorta
        lda     f:WorldBackdropGfxPtr
        sta     $d2
        lda     f:WorldBackdropGfxPtr+1
        sta     $d3
        lda     f:WorldBackdropGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropGfx
        lda     f:WorldBackdropTilesPtr
        sta     $d2
        lda     f:WorldBackdropTilesPtr+1
        sta     $d3
        lda     f:WorldBackdropTilesPtr+2
        sta     $d4
        ldx     #$2000      ; destination = $7e2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropTiles
        lda     f:WorldAnimSpriteGfxPtr
        sta     $d2
        lda     f:WorldAnimSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldAnimSpriteGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8586
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        bra     @8598
@8586:  lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
@8598:  ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @85be
        lda     f:MinimapGfx1Ptr
        sta     $d2
        lda     f:MinimapGfx1Ptr+1
        sta     $d3
        lda     f:MinimapGfx1Ptr+2
        sta     $d4
        bra     @85d0
@85be:  lda     f:MinimapGfx2Ptr
        sta     $d2
        lda     f:MinimapGfx2Ptr+1
        sta     $d3
        lda     f:MinimapGfx2Ptr+2
        sta     $d4
@85d0:  ldx     #$4000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     FixMinimap
        lda     f:WorldMiscSpriteGfxPtr
        sta     $d2
        lda     f:WorldMiscSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldMiscSpriteGfxPtr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     $11f6
        bit     #$08
        beq     @860e
        and     #$f7
        sta     $11f6
        bra     @864c
@860e:  lda     f:$001f64
        bne     @8628
        lda     f:WorldGfx1Ptr
        sta     $d2
        lda     f:WorldGfx1Ptr+1
        sta     $d3
        lda     f:WorldGfx1Ptr+2
        sta     $d4
        bra     @863a
@8628:  lda     f:WorldGfx2Ptr
        sta     $d2
        lda     f:WorldGfx2Ptr+1
        sta     $d3
        lda     f:WorldGfx2Ptr+2
        sta     $d4
@863a:  ldx     #$6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrWorldMapGfx
        jsr     InitWaterGfx
@864c:  lda     $11f6
        bit     #$04
        beq     @865a
        and     #$fb
        sta     $11f6
        bra     @8695
@865a:  lda     f:$001f64
        bne     @8674
        lda     f:WorldTilemap1Ptr
        sta     $d2
        lda     f:WorldTilemap1Ptr+1
        sta     $d3
        lda     f:WorldTilemap1Ptr+2
        sta     $d4
        bra     @8686
@8674:  lda     f:WorldTilemap2Ptr
        sta     $d2
        lda     f:WorldTilemap2Ptr+1
        sta     $d3
        lda     f:WorldTilemap2Ptr+2
        sta     $d4
@8686:  ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     ModifyMap
@8695:  jsr     InitTilemap256

; init doom gaze positions
        shortai
        lda     $1f6d
        inc3
        sta     $1f6d
        tax
        ldy     #$00
@86a6:  lda     f:RNGTbl,x   ; random number table
        and     #$3f
        sta     $0b00,y
        clr_a
        sta     $0b01,y
        inx
        lda     f:RNGTbl,x
        lsr2
        sta     $0b02,y
        clr_a
        sta     $0b03,y
        iny4
        cpy     #$10
        bne     @86a6
        jmp     InitInterruptsVehicle

; ------------------------------------------------------------------------------

; [ init world map (chocobo) ]

InitChoco:
@86cc:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     PushMode7Vars
        jsr     InitHWRegs
        lda     #$10
        sta     $1300
        lda     #$ff
        sta     $1302
        lda     $1eb9
        bit     #$10
        bne     @8714
        lda     $1eb7
        bit     #$08
        beq     @86f7
        lda     #$19
        bra     @870c
@86f7:  clr_a
        xba
        lda     $1f64
        and     #$03
        asl
        tax
        lda     $1eb7
        bit     #$01
        beq     @8708
        inx
@8708:  lda     f:ChocoSongTbl,x
@870c:  sta     $1f80
        sta     $1301
        bra     @871a
@8714:  lda     $1f80
        sta     $1301
@871a:  jsl     ExecSound_ext
        longa
        lda     $1f64
        and     #$6000
        xba
        lsr4
        shorta
        sta     hWRMPYA
        lda     #$5a
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        ora     #$8000
        sta     $11f2
        stz     $11f4
        lda     f:$001f60
        lsr4
        and     #$0ff0
        clc
        adc     #$0008
        sta     $38
        lda     f:$001f60
        asl4
        and     #$0ff0
        clc
        adc     #$0008
        sta     $34
        shorta
        phb
        lda     #$7e
        pha
        plb
        lda     f:$001f64
        bne     @8779
        ldx     #$0000
        bra     @877c
@8779:  ldx     #$0100
@877c:  ldy     #$0000
        longa
@8781:  lda     f:World1BGPal,x
        sta     $e000,y
        iny2
        inx2
        cpy     #$0100
        bne     @8781
        shorta
        lda     f:$001f64
        bne     @879e
        ldx     #$0200
        bra     @87a1
@879e:  ldx     #$0300
@87a1:  ldy     #$0000
        longa
@87a6:  lda     f:World1BGPal,x
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @87a6
        plb
        shorta
        lda     f:WorldBackdropGfxPtr
        sta     $d2
        lda     f:WorldBackdropGfxPtr+1
        sta     $d3
        lda     f:WorldBackdropGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropGfx
        lda     f:WorldBackdropTilesPtr
        sta     $d2
        lda     f:WorldBackdropTilesPtr+1
        sta     $d3
        lda     f:WorldBackdropTilesPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrBackdropTiles
        lda     f:WorldAnimSpriteGfxPtr
        sta     $d2
        lda     f:WorldAnimSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldAnimSpriteGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldChocoGfx1Ptr
        sta     $d2
        lda     f:WorldChocoGfx1Ptr+1
        sta     $d3
        lda     f:WorldChocoGfx1Ptr+2
        sta     $d4
        ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8851
        lda     f:MinimapGfx1Ptr
        sta     $d2
        lda     f:MinimapGfx1Ptr+1
        sta     $d3
        lda     f:MinimapGfx1Ptr+2
        sta     $d4
        bra     @8863
@8851:  lda     f:MinimapGfx2Ptr
        sta     $d2
        lda     f:MinimapGfx2Ptr+1
        sta     $d3
        lda     f:MinimapGfx2Ptr+2
        sta     $d4
@8863:  ldx     #$4000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     FixMinimap
        lda     f:WorldChocoGfx2Ptr
        sta     $d2
        lda     f:WorldChocoGfx2Ptr+1
        sta     $d3
        lda     f:WorldChocoGfx2Ptr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     $11f6
        bit     #$08
        beq     @88a1
        and     #$f7
        sta     $11f6
        bra     @88df
@88a1:  lda     f:$001f64
        bne     @88bb
        lda     f:WorldGfx1Ptr
        sta     $d2
        lda     f:WorldGfx1Ptr+1
        sta     $d3
        lda     f:WorldGfx1Ptr+2
        sta     $d4
        bra     @88cd
@88bb:  lda     f:WorldGfx2Ptr
        sta     $d2
        lda     f:WorldGfx2Ptr+1
        sta     $d3
        lda     f:WorldGfx2Ptr+2
        sta     $d4
@88cd:  ldx     #$6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrWorldMapGfx
        jsr     InitWaterGfx
@88df:  lda     $11f6
        bit     #$04
        beq     @88ed
        and     #$fb
        sta     $11f6
        bra     @8928
@88ed:  lda     f:$001f64
        bne     @8907
        lda     f:WorldTilemap1Ptr
        sta     $d2
        lda     f:WorldTilemap1Ptr+1
        sta     $d3
        lda     f:WorldTilemap1Ptr+2
        sta     $d4
        bra     @8919
@8907:  lda     f:WorldTilemap2Ptr
        sta     $d2
        lda     f:WorldTilemap2Ptr+1
        sta     $d3
        lda     f:WorldTilemap2Ptr+2
        sta     $d4
@8919:  ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     ModifyMap
@8928:  jsr     InitTilemap256
        shorta
        lda     #$02
        sta     $ca
        lda     #$02
        sta     $20
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
        stz     $6a
        stz     $6b
        stz     $6c
        lda     $11fb
        sta     hWRMPYA
        lda     #$a0
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        stx     $6a
        lda     #$16
        sta     hWRMPYB
        nop3
        lda     hRDMPYL
        clc
        adc     $6b
        sta     $6b
        lda     hRDMPYH
        adc     $6c
        sta     $6c
        clc
        lda     $6a
        adc     #$80
        sta     $6a
        lda     $6b
        adc     #$01
        sta     $6b
        lda     $6c
        adc     #$d5
        sta     $6c
        lda     #$80
        sta     hVMAINC
        longa
        lda     #$6ac0
        sta     hVMADDL
        ldy     #$0000
@8990:  lda     [$6a],y
        sta     hVMDATAL
        iny2
        cpy     #$0040
        bne     @8990
        lda     #$6bc0
        sta     hVMADDL
        ldy     #$00c0
@89a5:  lda     [$6a],y
        sta     hVMDATAL
        iny2
        cpy     #$0100
        bne     @89a5

; load character sprite palette
        shorta
        phb
        lda     #$e6
        pha
        plb
        lda     #$00
        xba
        lda     f:$0011fc
        and     #$07
        asl5
        tay
        ldx     #$0000
        longa
@89cc:  lda     $8000,y
        sta     $7ee140,x
        iny2
        inx2
        cpx     #$0020
        bne     @89cc
        plb
        jmp     InitInterruptsVehicle

; ------------------------------------------------------------------------------

; [ init world map (no vehicle) ]

InitWorld:
@89e0:  shorta
        longi
        lda     #$80        ; screen off
        sta     hINIDISP
        jsr     PushMode7Vars
        jsr     InitHWRegs
        lda     #$10        ; song command (play song)
        sta     $1300
        lda     #$ff        ; full volume
        sta     $1302
        lda     $1eb9       ; don't change song when loading map
        bit     #$10
        bne     @8a28
        lda     $1eb7       ; branch if not on the veldt
        bit     #$08
        beq     @8a0b
        lda     #$19        ; veldt music
        bra     @8a20
@8a0b:  clr_a
        xba
        lda     $1f64       ; map index
        and     #$03
        asl
        tax
        lda     $1eb7       ; alternative music flag
        bit     #$01
        beq     @8a1c
        inx
@8a1c:  lda     f:WorldSongTbl,x   ; song number
@8a20:  sta     $1f80
        sta     $1301
        bra     @8a2e
@8a28:  lda     $1f80
        sta     $1301
@8a2e:  jsl     ExecSound_ext
        longa
        stz     $08         ;
        lda     f:$001f60     ; map position
        shorta
        sta     $e0
        xba
        sta     $e2
        longa
        lda     $df
        lsr4
        sta     $34
        lda     $e1
        lsr4
        sta     $38
        shorta
        phb
        lda     #$7e
        pha
        plb
        lda     f:$001f64
        bne     @8a65
        ldx     #$0000
        bra     @8a6a
@8a65:  ldx     #$0100
        sta     $d2
@8a6a:  ldy     #$0000
        longa
@8a6f:  lda     f:World1BGPal,x   ; map palettes
        sta     $e000,y
        iny2
        inx2
        cpy     #$0100
        bne     @8a6f
        shorta
        lda     f:$001f64
        bne     @8a8c
        ldx     #$0200
        bra     @8a8f
@8a8c:  ldx     #$0300
@8a8f:  ldy     #$0000
        longa
@8a94:  lda     f:World1BGPal,x   ; vehicle palettes
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @8a94
        plb
        shorta
        lda     f:WorldAnimSpriteGfxPtr
        sta     $d2
        lda     f:WorldAnimSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldAnimSpriteGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8adf
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        bra     @8af1
@8adf:  lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
@8af1:  ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:$001f64
        bne     @8b17
        lda     f:MinimapGfx1Ptr
        sta     $d2
        lda     f:MinimapGfx1Ptr+1
        sta     $d3
        lda     f:MinimapGfx1Ptr+2
        sta     $d4
        bra     @8b29
@8b17:  lda     f:MinimapGfx2Ptr
        sta     $d2
        lda     f:MinimapGfx2Ptr+1
        sta     $d3
        lda     f:MinimapGfx2Ptr+2
        sta     $d4
@8b29:  ldx     #$4000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     FixMinimap
        lda     f:WorldMiscSpriteGfxPtr
        sta     $d2
        lda     f:WorldMiscSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldMiscSpriteGfxPtr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     $11f6
        bit     #$08
        beq     @8b67       ; branch if map graphics are not loaded yet
        and     #$f7
        sta     $11f6
        bra     @8ba5
@8b67:  lda     f:$001f64
        bne     @8b81       ; branch if world of ruin
        lda     f:WorldGfx1Ptr
        sta     $d2
        lda     f:WorldGfx1Ptr+1
        sta     $d3
        lda     f:WorldGfx1Ptr+2
        sta     $d4
        bra     @8b93
@8b81:  lda     f:WorldGfx2Ptr
        sta     $d2
        lda     f:WorldGfx2Ptr+1
        sta     $d3
        lda     f:WorldGfx2Ptr+2
        sta     $d4
@8b93:  ldx     #$6f50      ; destination = $7e6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrWorldMapGfx
        jsr     InitWaterGfx
@8ba5:  lda     $11f6
        bit     #$04
        beq     @8bb3
        and     #$fb
        sta     $11f6
        bra     @8bee
@8bb3:  lda     f:$001f64
        bne     @8bcd
        lda     f:WorldTilemap1Ptr
        sta     $d2
        lda     f:WorldTilemap1Ptr+1
        sta     $d3
        lda     f:WorldTilemap1Ptr+2
        sta     $d4
        bra     @8bdf
@8bcd:  lda     f:WorldTilemap2Ptr
        sta     $d2
        lda     f:WorldTilemap2Ptr+1
        sta     $d3
        lda     f:WorldTilemap2Ptr+2
        sta     $d4
@8bdf:  ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     ModifyMap
@8bee:  jsr     InitTilemap256
        ldx     #$0000
@8bf4:  lda     $7ee100,x
        sta     $7ee120,x
        lda     $7ee101,x
        sta     $7ee121,x
        lda     $7ee102,x
        sta     $7ee122,x
        lda     $7ee103,x
        sta     $7ee123,x
        inx4
        cpx     #$0020
        bne     @8bf4
        lda     f:$001f64
        sta     $f4
        shorta
        clr_a
        xba
        lda     $1f68
        sta     $f6
        asl2
        tax
        lda     f:CharMoveFrameTbl,x
        sta     $f7
        lda     #$03
        sta     $ca
        lda     #$03
        sta     $20
        lda     #$80
        sta     $7b
        lda     #$70
        sta     $7d
        jmp     InitInterruptsWorld

; ------------------------------------------------------------------------------

; [ init magitek train ride ]

MagitekTrain:
@8c48:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        stz     $73
        stz     $74
        lda     $11f6
        bit     #$02
        beq     @8c6b       ; branch if battle is not enabled
        jsr     PopDP
        lda     $34
        sec
        sbc     #$05
        sta     $34
        bra     @8c6e
@8c6b:  jsr     PushMode7Vars
@8c6e:  lda     #$10        ; spc command $10 (play song)
        sta     $1300
        lda     f:TrainSongTbl
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        shorta
        lda     f:MagitekTrainPalPtr
        sta     $6a
        lda     f:MagitekTrainPalPtr+1
        sta     $6b
        lda     f:MagitekTrainPalPtr+2
        sta     $6c
        jsr     TfrPal
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     f:MagitekTrainGfxPtr
        sta     $d2
        lda     f:MagitekTrainGfxPtr+1
        sta     $d3
        lda     f:MagitekTrainGfxPtr+2
        sta     $d4
        ldx     #$a000      ; destination = $7ea000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     InitTrainGfx
        ldx     #.loword(MagitekTrainTiles)
        stx     $6a
        lda     #^MagitekTrainTiles
        sta     $6c
        jsr     LoadTrainTilePtrs
        jsr     TfrTrainTiles
        ldx     #$1808
        stx     $4300
        ldx     #$0058      ; source = $000058
        stx     $4302
        lda     #$00
        sta     $4304
        ldx     #$4000      ; size = $4000
        stx     $4305
        stz     $58
        stz     hVMAINC
        stz     hVMADDL
        stz     hVMADDH
        lda     #$01
        sta     hMDMAEN
        longai
        lda     $36
        and     #$0020
        pha
        sta     $58
        lda     $34
        sta     $64
        jsr     _ee25f5       ; update magitek train ride script data
        lda     $34
        clc
        adc     #$0005
        sta     $34
        pla
        sta     $58
        lda     #$0020
        sec
        sbc     $58
        sta     $58
        lda     $34
        sta     $64
        jsr     _ee25f5       ; update magitek train ride script data
        lda     $34
        clc
        adc     #$0005
        sta     $34
        jmp     InitInterruptsTrain

; ------------------------------------------------------------------------------

; [ init world map (serpent trench) ]

InitSnakeRoad:
@8d48:  shorta
        longi
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        lda     $11f6
        bit     #$02
        beq     @8d66       ; branch if battle is not enabled
        jsr     PopDP
        stz     $23
        lda     #$0f
        sta     $22
        bra     @8d8d
@8d66:  jsr     PushMode7Vars
        longa
        lda     $1f60
        lsr4
        and     #$0ff0
        sta     $38
        lda     $1f60
        asl4
        and     #$0ff0
        sta     $34
        shorta
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
@8d8d:  lda     #$04
        sta     $ca
        lda     #$04
        sta     $20
        lda     $1eb9
        bit     #$10
        bne     @8dbf
        ldx     #$0000
        lda     #$10
        sta     $1300
        lda     $1eb7       ; alternative world map song
        bit     #$01
        beq     @8dac
        inx
@8dac:  lda     f:SnakeSongTbl,x
        sta     $1f80
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
@8dbf:  lda     #$a3
        sta     hCGADSUB                ; half add, sprites, bg1, bg2
        shorta
        clr_a
        sta     $7e2000
        sta     $7e2001
        lda     #$80
        sta     hVMAINC
        ldx     #$5000
        stx     hVMADDL
        ldx     #$1809
        stx     $4300
        ldx     #$2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$4000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$4400
        stx     hVMADDL
        ldx     #$1809
        stx     $4300
        ldx     #$2000
        stx     $4302
        lda     #$7e
        sta     $4304
        ldx     #$1000
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        ldx     #.loword(World3Pal)
        stx     $d2
        lda     #^World3Pal
        sta     $d4
        ldx     #$e000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldAnimSpriteGfxPtr
        sta     $d2
        lda     f:WorldAnimSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldAnimSpriteGfxPtr+2
        sta     $d4
        ldx     #$2000
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:AirshipGfx1Ptr
        sta     $d2
        lda     f:AirshipGfx1Ptr+1
        sta     $d3
        lda     f:AirshipGfx1Ptr+2
        sta     $d4
        ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldMiscSpriteGfxPtr
        sta     $d2
        lda     f:WorldMiscSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldMiscSpriteGfxPtr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     f:WorldGfx3Ptr
        sta     $d2
        lda     f:WorldGfx3Ptr+1
        sta     $d3
        lda     f:WorldGfx3Ptr+2
        sta     $d4
        ldx     #$6f50
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrWorldMapGfx
        lda     f:WorldTilemap3Ptr
        sta     $d2
        lda     f:WorldTilemap3Ptr+1
        sta     $d3
        lda     f:WorldTilemap3Ptr+2
        sta     $d4
        ldx     #$0000
        stx     $d5
        lda     #$7f
        sta     $d7
        jsr     Decompress
        jsr     InitTilemap128
        jmp     InitInterruptsVehicle

; ------------------------------------------------------------------------------

; [ init ending airship scene ]

EndingAirshipScene2:
@8ed4:  shorta
        longi
        jsl     EndingAirshipScene_ext
        clr_a
        pha
        plb
        lda     #$80
        sta     hINIDISP
        jsr     InitHWRegs
        jsr     PushMode7Vars
        shorta
        lda     #$80
        sta     $7b
        lda     #$d0
        sta     $7d
        lda     #$7e
        pha
        plb
        longa
        ldx     #$0300
        ldy     #$0000
@8f00:  lda     f:World1BGPal,x
        sta     $e100,y
        iny2
        inx2
        cpy     #$0100
        bne     @8f00
        ldx     #$0000
@8f13:  lda     $e1c0,x
        sta     $e140,x
        inx2
        cpx     #$0020
        bne     @8f13
        shorta
        lda     f:EndingAirshipPalPtr
        sta     $d2
        lda     f:EndingAirshipPalPtr+1
        sta     $d3
        lda     f:EndingAirshipPalPtr+2
        sta     $d4
        longa
        ldy     #$0000
@8f39:  lda     [$d2],y
        sta     $e000,y
        iny2
        cpy     #$0100
        bne     @8f39
        stz     $e000
        ldx     #$0000
@8f4b:  lda     $e100,x
        sta     $e120,x
        inx2
        cpx     #$0020
        bne     @8f4b
        shorta
        clr_a
        pha
        plb
        lda     f:AirshipGfx2Ptr
        sta     $d2
        lda     f:AirshipGfx2Ptr+1
        sta     $d3
        lda     f:AirshipGfx2Ptr+2
        sta     $d4
        ldx     #$2800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        lda     f:WorldMiscSpriteGfxPtr
        sta     $d2
        lda     f:WorldMiscSpriteGfxPtr+1
        sta     $d3
        lda     f:WorldMiscSpriteGfxPtr+2
        sta     $d4
        ldx     #$4800
        stx     $d5
        lda     #$7e
        sta     $d7
        jsr     Decompress
        jsr     TfrSpriteGfx
        lda     #$5c
        sta     $1500
        ldx     #.loword(EndingAirshipSceneNMI)
        stx     $1501
        lda     #^EndingAirshipSceneNMI
        sta     $1503
        jmp     FalconEndingMain

; ------------------------------------------------------------------------------

; [ init hardware registers ]

InitHWRegs:
@8faf:  clr_a
        pha
        plb
        sta     hHDMAEN                 ; disable hdma
        lda     #$03
        sta     hOBJSEL                 ; sprite graphics at vram $6000, 8x8 and 16x16
        stz     hOAMADDL                ; clear sprite data address
        stz     hOAMADDH
        lda     #$07
        sta     hBGMODE                 ; screen mode 7
        lda     #$40
        stz     hMOSAIC                 ; clear pixelation register
        sta     hBG1SC                  ; bg1 tile data at $4000
        lda     #$45
        sta     hBG2SC                  ; bg2 tile data at $4400
        lda     #$4c
        sta     hBG3SC                  ; bg3 tile data at $4c00
        stz     hBG4SC
        lda     #$55
        sta     hBG12NBA                ; bg1/bg2 graphics at $5000
        stz     hBG34NBA                ; bg3/bg4 graphics at $0000
        stz     hBG3HOFS                ; clear bg3 horizontal/vertical scroll
        stz     hBG3HOFS
        stz     hBG3VOFS
        stz     hBG3VOFS
        lda     #$80
        sta     hVMAINC                 ; video port control
        stz     hM7SEL                  ; clear mode 7 settings
        lda     #$33
        sta     hW12SEL                 ; enable bg1/bg2 in window 1
        stz     hW34SEL                 ; disable bg3/bg4
        lda     #$33
        sta     hWOBJSEL                ; enable color/sprites in window 1
        lda     #$08
        sta     hWH0                    ; window 1 left position = $08
        lda     #$f7
        sta     hWH1                    ; window 1 right position = $f7
        stz     hWH2
        stz     hWH3
        stz     hWBGLOG
        stz     hWOBJLOG
        lda     #$13
        sta     hTM                     ; enable sprites, bg1, and bg2 in main screen
        lda     #$10
        sta     hTS                     ; enable sprites in subscreen (for transparency in forests)
        lda     #$13
        sta     hTMW                    ; enable sprites, bg1, and bg2 masks in main screen
        lda     #$10
        sta     hTSW                    ; enable sprites mask in subscreen
        lda     #$02
        sta     hCGSWSEL                ; enable subscreen add/sub
        lda     #$23
        sta     hCGADSUB                ; add/sub affect back-area, bg1, and bg2
        lda     #$e0
        sta     hCOLDATA                ; clear fixed color data
        stz     hSETINI                 ; clear screen mode/video select
        stz     hNMITIMEN               ; disable all counters
        lda     #$ff
        sta     hWRIO                   ; i/o port
        stz     hWRMPYA
        stz     hWRMPYB
        stz     hWRDIVL
        stz     hWRDIVH
        stz     hWRDIVB
        stz     hHTIMEL                 ; clear horizontal irq counter
        stz     hHTIMEH
        stz     hVTIMEL                 ; clear vertical irq counter
        stz     hVTIMEH
        stz     hMDMAEN                 ; disable dma
        stz     hHDMAEN                 ; disable hdma
        phb
        lda     #$7e
        pha
        plb
        longa
        ldx     #0
@9072:  stz     $b5d0,x                 ; clear animation data
        inx2
        cpx     #$0180
        bne     @9072
        plb
        shorta
        ldx     #$0019
@9082:  stz     a:0,x                   ; clear $0019-$00ff
        inx
        cpx     #$0100
        bne     @9082
        rts

; ------------------------------------------------------------------------------

; [ save mode 7 variables ]

PushMode7Vars:
@908c:  phb
        php
        longai
        ldx     #$0520      ; source = $000520
        ldy     #$f120      ; destination = $7ef120
        lda     #$06df      ; size = $06e0
        mvn     #$00,#$7e
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ restore mode 7 variables ]

PopMode7Vars:
@909f:  phb
        php
        longai
        ldx     #$f120      ; source = $7ef120
        ldy     #$0520      ; destination = $000520
        lda     #$06df      ; size = $06e0
        mvn     #$7e,#$00
        plp
        plb
        rts

; ------------------------------------------------------------------------------

; [ save direct page ]

PushDP:
@90b2:  php
        phb
        shortai
        lda     #$00
        pha
        plb
        longa_clc
        lda     #$0000
@90bf:  tax
        lda     a:0,x
        sta     $0a00,x
        lda     a:2,x
        sta     $0a02,x
        lda     a:4,x
        sta     $0a04,x
        lda     a:6,x
        sta     $0a06,x
        lda     a:8,x
        sta     $0a08,x
        lda     a:10,x
        sta     $0a0a,x
        lda     a:12,x
        sta     $0a0c,x
        lda     a:14,x
        sta     $0a0e,x
        txa
        adc     #$0010
        cmp     #$0100
        bne     @90bf
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ restore direct page ]

PopDP:
@90fc:  php
        phb
        shortai
        lda     #$00
        pha
        plb
        longa_clc
        lda     #$0000
@9109:  tax
        lda     $0a00,x
        sta     a:0,x
        lda     $0a02,x
        sta     a:2,x
        lda     $0a04,x
        sta     a:4,x
        lda     $0a06,x
        sta     a:6,x
        lda     $0a08,x
        sta     a:8,x
        lda     $0a0a,x
        sta     a:10,x
        lda     $0a0c,x
        sta     a:12,x
        lda     $0a0e,x
        sta     a:14,x
        txa
        adc     #$0010
        cmp     #$0100
        bne     @9109
        plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ set interrupt jump code (w/ vehicle) ]

InitInterruptsVehicle:
@9146:  shorta
        longi
        lda     #$5c
        sta     $1500
        ldx     #.loword(VehicleNMI)
        stx     $1501
        lda     #^VehicleNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        lda     a:$0020
        cmp     #$02
        beq     @9173
        ldx     #.loword(AirshipIRQ)
        stx     $1505
        lda     #^AirshipIRQ
        sta     $1507
        bra     @917e
@9173:  ldx     #.loword(ChocoIRQ)
        stx     $1505
        lda     #^ChocoIRQ
        sta     $1507
@917e:  jmp     VehicleMain

; ------------------------------------------------------------------------------

; [ set interrupt jump code (no vehicle) ]

InitInterruptsWorld:
@9181:  shorta
        longi
        lda     #$5c
        sta     $1500
        ldx     #.loword(WorldNMI)
        stx     $1501
        lda     #^WorldNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        ldx     #.loword(WorldIRQ)
        stx     $1505
        lda     #^WorldIRQ
        sta     $1507
        jmp     WorldMain

; ------------------------------------------------------------------------------

; [ set interrupt jump code (magitek train ride) ]

InitInterruptsTrain:
@91a8:  shorta
        longi
        clr_a
        pha
        plb
        lda     #$5c
        sta     $1500
        ldx     #.loword(TrainNMI)
        stx     $1501
        lda     #^TrainNMI
        sta     $1503
        lda     #$5c
        sta     $1504
        ldx     #.loword(TrainIRQ)
        stx     $1505
        lda     #^TrainIRQ
        sta     $1507
        jmp     TrainMain

; ------------------------------------------------------------------------------

; [ terminate world map (w/ vehicle) ]

ExitVehicle:
@91d2:  shorta
        lda     $11f6
        bit     #$10
        beq     @91e6
        lda     $20
        cmp     #$02
        beq     @91e3
        bra     @91e6
@91e3:  jsr     DismountChocoAnim
@91e6:  lda     #$80
        sta     hINIDISP
        lda     #$00
        sta     hNMITIMEN
        sta     hHDMAEN
        sei
        lda     $19
        cmp     #$ff
        beq     @920c
        jsr     PopMode7Vars
        stz     $11fa
        stz     $11fd
        stz     $11fe
        stz     $11ff
        jmp     ReloadMap
@920c:  longai
        lda     $f4
        and     #$01ff
        cmp     #$0003
        bcs     @9233
        shorta
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $e7
        bit     #$40
        beq     @922e
        lda     $ec
        sec
        sbc     #$80
        pha
        bra     @924d
@922e:  lda     $ec
        pha
        bra     @924d
@9233:  shorta
        lda     $e7
        bit     #$40
        bne     @9246
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $ec
        pha
        bra     @924d
@9246:  lda     #0
        pha
        pha
        lda     #^EventScript_NoEvent
        pha
@924d:  lda     $f1
        pha
        longa
        lda     $1c
        pha
        lda     $f4
        pha
        jsr     PopMode7Vars
        pla
        sta     $1f64
        and     #$01ff
        cmp     #$0002
        bcs     @926d
        pla
        sta     $1f60
        bra     @9271
@926d:  pla
        sta     $1f66
@9271:  shorta
        pla
        sta     $11fa
        pla
        sta     $11ff
        pla
        sta     $11fe
        pla
        sta     $11fd
        rtl

; ------------------------------------------------------------------------------

; [ terminate world map (no vehicle) ]

ExitWorld:
@9284:  shorta
        lda     #$7e
        pha
        plb
        lda     #$80
        sta     f:hINIDISP
        lda     #$00
        sta     f:hNMITIMEN
        sta     f:hHDMAEN
        sei
        longai
        lda     $f4
        and     #$01ff
        cmp     #$0003
        bcs     @92c2
        shorta
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $e7
        bit     #$40
        beq     @92bd
        lda     $ec
        sec
        sbc     #$80
        pha
        bra     @92dc
@92bd:  lda     $ec
        pha
        bra     @92dc
@92c2:  shorta
        lda     $e7
        bit     #$40
        bne     @92d5
        lda     $ea
        pha
        lda     $eb
        pha
        lda     $ec
        pha
        bra     @92dc
@92d5:  lda     #0
        pha
        pha
        lda     #^EventScript_NoEvent
        pha
@92dc:  lda     $f1
        pha
        longa
        lda     $1c
        pha
        lda     $f4
        pha
        jsr     PopMode7Vars
        pla
        sta     f:$001f64
        and     #$01ff
        cmp     #$0002
        bcs     @92fe
        pla
        sta     f:$001f60
        bra     @9303
@92fe:  pla
        sta     f:$001f66
@9303:  shorta
        pla
        sta     f:$0011fa
        pla
        sta     f:$0011ff
        pla
        sta     f:$0011fe
        pla
        sta     f:$0011fd
        rtl

; ------------------------------------------------------------------------------

; [ terminate world map (end of magitek train ride) ]

ExitTrain:
@931a:  shorta
        lda     #$00
        pha
        plb
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        lda     #$7e
        pha
        plb
        sei
        jsr     PopMode7Vars
        rtl

; ------------------------------------------------------------------------------

; [ terminate world map (game over) ]

GameOver:
@9335:  shorta
        clr_a
        pha
        plb
        lda     #$80
        sta     hINIDISP
        stz     hNMITIMEN
        stz     hHDMAEN
        sei
        jsr     PopMode7Vars
        lda     #$03        ; load map 3
        sta     f:$001f64
        clr_a
        sta     f:$001f65
        lda     #^EventScript_GameOver
        sta     f:$0011ff
        clr_a
        sta     f:$0011fe
        lda     #<EventScript_GameOver
        sta     f:$0011fd
        lda     $11f6       ; disable battle
        and     #$fd
        sta     $11f6
        rtl

; ------------------------------------------------------------------------------

; [ land airship or dismount chocobo ]

LandAirship:
@936e:  php
        phb
        shorta
        lda     $20
        cmp     #$02
        beq     @93d4                   ; branch if chocobo
        lda     $c2
        bit     #$02
        jne     @942c                   ; return if airship can't land
        lda     $1f64
        cmp     #$01
        bne     @93d4                   ; branch if not in WoR
        lda     $c3
        bit     #$80
        beq     @93af                   ; branch if not kefka's tower
        lda     f:VehicleEvent_04       ; ca/007f (enter kefka's tower)
        sta     $ea
        lda     f:VehicleEvent_04+1
        sta     $eb
        lda     f:VehicleEvent_04+2
        clc
        adc     #^EventScript
        sta     $ec
        stz     $ed
        stz     $ee
        lda     $e7
        ora     #$41
        sta     $e7
        bra     @942c
@93af:  bit     #$40
        beq     @93d4                   ; branch if not phoenix cave
        lda     f:VehicleEvent_03       ; ca/0088 (enter phoenix cave)
        sta     $ea
        lda     f:VehicleEvent_03+1
        sta     $eb
        lda     f:VehicleEvent_03+2
        clc
        adc     #^EventScript
        sta     $ec
        stz     $ed
        stz     $ee
        lda     $e7
        ora     #$41
        sta     $e7
        bra     @942c

; chocobo
@93d4:  lda     $c3
        bit     #$20
        beq     @93e2                   ; branch if not a veldt tile
        lda     $1eb7
        ora     #$08
        sta     $1eb7
@93e2:  lda     #$03
        sta     $19
        lda     $1e
        ora     #$01
        sta     $1e
        ldx     #$0000
        stx     $29
        stx     $2b
        stx     $26
        stz     $28
        stx     $2d
        longa
        lda     $34
        lsr4
        and     #$00ff
        sta     f:$001f60               ; set player xy position
        lda     $38
        asl4
        and     #$ff00
        clc
        adc     f:$001f60
        sta     f:$001f60
        lda     $20
        and     #$00ff
        cmp     #$0001
        bne     @942c                   ; branch if not in airship
        lda     f:$001f60
        sta     f:$001f62               ; set airship xy position
@942c:  plb
        plp
        rts

; ------------------------------------------------------------------------------

; [ apply map layout modifications ]

ModifyMap:
@942f:  phb
        php
        shortai
        lda     f:$001f64               ; map index
        asl
        clc
        adc     f:$001f64
        tax
        lda     f:WorldModDataPtrs,x    ; pointer to modification data
        sta     $6a
        lda     f:WorldModDataPtrs+1,x
        sta     $6b
        lda     f:WorldModDataPtrs+2,x
        sta     $6c
        pha
        plb
        longai
        lda     f:WorldModDataPtrs+3,x  ; pointer to next map's modification data
        sec
        sbc     f:WorldModDataPtrs,x
        sta     $66                     ; length of modification data
        ldy     #0
@9462:  longa
        lda     [$6a],y                 ; event bit index
        iny2
        sta     $5a
        and     #$0007
        tax
        lda     f:BitOrTbl,x            ; bit mask
        sta     $5c
        lda     $5a
        and     #$7fff
        lsr3
        tax
        shorta
        lda     f:$001e80,x             ; event bit
        and     $5c
        beq     @94cb                   ; skip this chunk if not set
        phy
        longa_clc
        lda     [$6a],y                 ; pointer to modified tiles
        adc     f:WorldModDataPtrs
        tay
        lda     a:0,y                   ; tile offset (x then y)
        tax
        shorta
        lda     a:2,y                   ; width (high nybble)
        lsr4
        sta     $68
        lda     a:2,y                   ; height (low nybble)
        and     #$0f
        sta     $69
        shorta
@94a9:  lda     $68
        sta     $5e                     ; x
        stx     $60
@94af:  lda     a:3,y
        sta     $7f0000,x
        iny                             ; next column
        inx
        dec     $5e
        bne     @94af
        longa_clc                          ; next row
        lda     $60
        adc     #$0100
        tax
        shorta
        dec     $69
        bne     @94a9
        ply
@94cb:  iny2                            ; next chunk
        cpy     $66
        bne     @9462
        plp
        plb
        rts

; ------------------------------------------------------------------------------

.pushseg
.segment "magitek_train_tiles"

; d8/dd00
MagitekTrainTiles:
        .incbin "magitek_train_tiles.dat"

.popseg

; ------------------------------------------------------------------------------

.pushseg
.segment "world_mod"

begin_block _WorldModData, $0500

; ce/f600
World1ModData:
        .incbin "world_1_mod.dat"
World2ModData:
        .incbin "world_2_mod.dat"
WorldModDataEnd:

; ce/f648
WorldModTiles:
        .incbin "world_mod_tiles.dat"
end_block _WorldModData

.popseg

; ------------------------------------------------------------------------------
