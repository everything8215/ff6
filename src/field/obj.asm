
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: obj.asm                                                              |
; |                                                                            |
; | description: sprite object routines                                        |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "gfx/portrait.inc"
.include "gfx/map_sprite_gfx.inc"
.include "event/npc_prop.inc"

.import MapSpritePal, SmallFontGfx

.a8
.i16
.segment "field_code"

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
@5120:  lda     f:PortraitPal,x         ; character portrait color palette
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
        longa_clc
        lda     f:PortraitGfxPtrs,x     ; pointer to portrait graphics
        sta     $2a
        shorta0
        ldx     $00
@517c:  lda     f:PortraitTiles,x       ; tile formation
        longa_clc
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
        longa_clc
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
@51ba:
.repeat 16, i
        .addr   PortraitGfx+$0320*i
.endrep

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
        longa_clc                          ; loop through character objects only
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @520e
        rts

; ------------------------------------------------------------------------------

; [ init npc event bits ]

.proc InitNPCSwitches
        ldx     $00
loop:   lda     f:InitNPCSwitch,x
        sta     $1ee0,x
        inx
        cpx     #sizeof_InitNPCSwitch
        bne     loop
        rts
.endproc  ; InitNPCSwitches

.pushseg
.segment "init_npc_switch"

; c0/e0a0
.proc InitNPCSwitch
        .incbin "init_npc_switch.dat"
.endproc
sizeof_InitNPCSwitch = .sizeof(InitNPCSwitch)

.popseg

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
        longa_clc
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
@52aa:  stz     $0af7,x                 ; clear object data for npcs $10-$28
        inx
        cpx     #$03d8
        bne     @52aa
        stz     $078f                   ; clear number of active npcs
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
        jeq     @5434                   ; end loop after last npc
@52d4:  lda     f:NPCProp::EventPtr,x
        sta     $0889,y
        lda     f:NPCProp::EventPtr+1,x
        sta     $088a,y
        lda     f:NPCProp::EventPtr+2,x
        and     #%11
        sta     $088b,y
        lda     f:NPCProp::Pal,x         ; copy color palette
        and     #$1c
        lsr
        sta     $0880,y
        sta     $0881,y
        lda     f:NPCProp::Scroll,x         ; scroll with bg2
        and     #NPC_SCROLL::MASK
        asl2
        sta     $087c,y
        longa
        lda     f:NPCProp::Switch,x
        lsr6
        shorta
        phx
        phy
        jsr     GetNPCSwitch0
        ply
        plx
        cmp     #0
        beq     @531e                   ; branch if npc is not enabled
        lda     #$c0                    ; enable and show npc
@531e:  sta     $0867,y
        lda     f:NPCProp::SpecialNPC,x ; or special npc graphics
        and     #$80
        sta     $0868,y
        longa
        lda     f:NPCProp::PosX,x
        and     #$007f
        asl4
        sta     $086a,y
        lda     f:NPCProp::PosY,x
        and     #$003f
        asl4
        sta     $086d,y
        shorta0
        sta     $0869,y                 ; clear lsb's of position
        sta     $086c,y
        sta     $086f,y                 ; clear jump y-offset
        sta     $0870,y
        sta     $0887,y                 ; clear jump counter
        lda     f:NPCProp::Speed,x
        and     #$c0
        lsr6
        sta     $0875,y
        lda     f:NPCProp::Gfx,x         ; graphics index (also actor index)
        sta     $0878,y
        sta     $0879,y
        lda     f:NPCProp::Movement,x
        and     #NPC_MOVEMENT::MASK
        ora     $087c,y
        sta     $087c,y
        lda     f:NPCProp::SpritePriority,x
        and     #NPC_SPRITE_PRIORITY::MASK
        asl2
        sta     $088c,y
        lda     f:NPCProp::Vehicle,x         ; vehicle index (or animation speed)
        and     #$c0
        lsr
        ora     $0868,y
        sta     $0868,y
        lda     f:NPCProp::Dir,x
        and     #$03
        sta     $087f,y
        phx
        tax
        lda     f:ObjStopTileTbl,x      ; graphic position for facing direction
        sta     $0877,y
        sta     $0876,y
        plx
        lda     f:NPCProp::React,x         ; turn when activated (or 32x32 sprite)
        and     #NPC_REACT::MASK
        asl3
        ora     $087c,y
        sta     $087c,y
        lda     f:NPCProp::LayerPriority,x         ; layer priority
        and     #NPC_LAYER_PRIORITY::MASK
        lsr2
        sta     $1a
        lda     $0868,y
        and     #$f9
        ora     $1a
        sta     $0868,y
        lda     f:NPCProp::AnimFrame,x
        and     #NPC_ANIM_FRAME::MASK
        beq     @53f6                   ; branch if no special animation
        lsr5
        ora     $088c,y
        sta     $088c,y
        lda     f:NPCProp::AnimType,x
        and     #NPC_ANIM_TYPE::MASK
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
        longa_clc
        tya                             ; next npc
        adc     #$0029
        tay
        txa
        clc
        adc     #NPCProp::ITEM_SIZE
        tax
        shorta0
        cpx     $1e
        jne     @52d4
@5434:  cpy     #$07b0                  ; disable and hide any remaining npcs
        beq     @5450
@5439:  lda     $0867,y
        and     #$3f
        sta     $0867,y
        longa_clc
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
@546c:  longa_clc
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
        longa_clc
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
        longa_clc
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
        longa_clc
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
        longa_clc
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
@55df:  longa_clc
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
        ldx     #.loword(VehicleGfx) ; source address
        stx     $4302
        lda     #^VehicleGfx
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
        jcs     @5801
        tax
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
        jne     @5742
        rts

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
        jne     @58e4
        cpy     $0803       ; no special animation, check if this is the party object
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
        jne     @58ad

; no vehicle
        lda     $0868,y
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

@5a2d:  ldx     #@hDP                   ; nonzero dp, don't use clr_a
        phx
        pld
        ldx     #$0300                  ; clear $0300-$0520
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
        lda     #6                      ; update graphics for 6 sprites per frame
        sta     $de
        lda     $47                     ; get first sprite to update this frame
        and     #$03
        tax
        lda     f:FirstObjTbl1,x
        sta     $dc
@5ac0:  lda     $dc
        tax
        ldy     $10f7,x                 ; pointer to object data
        cpy     #$07b0
        beq     @5ad1                   ; branch if empty
        lda     $0877,y
        sta     $0876,y                 ; set current graphic position
@5ad1:  inc     $dc                     ; next object
        inc     $dc
        dec     $de
        bne     @5ac0
        ldy     #$00a0                  ; normal priority sprite data pointer
        sty     $d4
        ldy     #$0020                  ; low and high priority sprite data pointer
        sty     $d6
        sty     $d8
        lda     #$18                    ; update all 24 objects every frame
        sta     $de
        stz     $dc                     ; current object

; start of object loop
_5aeb:  lda     $dc
        cmp     $dd                     ; branch if less than total number of active objects
        jcs     DrawNextObj
        tax
        lda     $0803,x                 ; pointer to object data
        sta     $da
        lda     $0804,x
        sta     $db
        ldy     $da
        lda     $0867,y                 ; skip if object is not visible
        jpl     DrawNextObj
        lda     $0868,y                 ; vehicle
        and     #$e0
        cmp     #$80
        jeq     DrawObjSpecial          ; branch if special graphics
        lda     $088c,y                 ; branch if object animation is enabled
        and     #$20
        bne     DrawObjNoVehicle
        lda     $0868,y                 ; branch if not in a vehicle
        and     #$60
        beq     DrawObjNoVehicle
        cmp     #$20
        jeq     DrawChoco
        cmp     #$40
        jeq     DrawMagitek
        jmp     DrawRaft

; next object
DrawNextObj:
@5b34:  shorta0
        inc     $dc
        inc     $dc
        dec     $de
        jne     _5aeb
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
        longa_clc
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
@5bc0:  longa_clc
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
        jne     DrawNextObj
        lda     $27
        jne     DrawNextObj   ; return if sprite is off-screen to the bottom
        tdc
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
        jeq     @5c93       ; jump if high priority
        jmp     @5cf5       ; jump if low priority

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
        sbc     #8
        sta     $26
        sbc     #16
        sta     $24
        sbc     #6
        sta     $22
        clc
        adc     #30
        shorta
        xba
        jne     DrawNextObj ; branch if sprite is on screen
        tdc
        ldy     $1e
        cpy     #$0120
        bcc     @5da6
        cpy     #$ffe0
        jcc     DrawNextObj
@5da6:  longa
        lda     $d4         ; pointer to normal priority sprite
        sec
        sbc     #12      ; use 3 sprites (3 top and 3 bottom)
        sta     $d4
        shorta0
        ldy     $d4
        longa
        lda     $1e         ; left half + 8 to get rider x-position
        clc
        adc     #8
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
        lda     f:MagitekTopLeftTiles,x
        sta     $0346,y
        lda     f:MagitekTopRightTiles,x
        sta     $034a,y
        lda     f:MagitekBtmLeftTiles,x
        sta     $0402,y
        lda     f:MagitekBtmRightTiles,x
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
@5eb6:  .word   $2fac,$2fc0,$2fac,$2fc4
        .word   $6fca,$6fe2,$6fca,$6fea
        .word   $2fa0,$2fa4,$2fa0,$2fa8
        .word   $2fc8,$2fe0,$2fc8,$2fe8

; magitek tile formation (top right)
MagitekTopRightTiles:
@5ed6:  .word   $6fac,$6fc4,$6fac,$6fc0
        .word   $6fc8,$6fe0,$6fc8,$6fe8
        .word   $6fa0,$6fa8,$6fa0,$6fa4
        .word   $2fca,$2fe2,$2fca,$2fea

; magitek tile formation (bottom left)
MagitekBtmLeftTiles:
@5ef6:  .word   $2fae,$2fc2,$2fae,$2fc6
        .word   $6fce,$6fe6,$6fce,$6fee
        .word   $2fa2,$2fa6,$2fa2,$2faa
        .word   $2fcc,$2fe4,$2fcc,$2fec

; magitek tile formation (bottom right)
MagitekBtmRightTiles:
@5f16:  .word   $6fae,$6fc6,$6fae,$6fc2
        .word   $6fcc,$6fe4,$6fcc,$6fec
        .word   $6fa2,$6faa,$6fa2,$6fa6
        .word   $2fce,$2fe6,$2fce,$2fee

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
        adc     #16
        sta     $20
        lda     $086d,y
        clc
        sbc     $60
        sec
        sbc     $7f
        sec
        sbc     #8
        sta     $26
        sbc     #16
        sta     $24
        sbc     #8
        sta     $22
        clc
        adc     #30
        shorta
        xba
        jne     DrawNextObj
        tdc
        ldy     $1e
        cpy     #$0120
        bcc     @5f85
        cpy     #$ffe0
        jcc     DrawNextObj
@5f85:  longa
        lda     $d4
        sec
        sbc     #12
        sta     $d4
        shorta0
        ldy     $d4
        longa
        lda     $1e
        clc
        adc     #8
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $1e
        clc
        adc     #8
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
        lda     f:RaftTiles,x
        sta     $034a,y
        lda     f:RaftTiles+8,x
        sta     $0402,y
        lda     f:RaftTiles+16,x
        sta     $0406,y
        lda     f:RaftTiles+24,x
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
@609a:  .word   $2f20,$2f28,$2f20,$2f28
        .word   $2f24,$2f2c,$2f24,$2f2c
        .word   $2f22,$2f2a,$2f22,$2f2a
        .word   $2f26,$2f2e,$2f26,$2f2e

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
        adc     #8
        sta     $1e
        lda     $086d,y
        clc
        sbc     $60
        sec
        sbc     $7f
        sec
        sbc     #8
        sta     $26
        sbc     #16
        sta     $24
        sbc     #4
        sta     $22
        clc
        adc     #28
        shorta
        xba
        jne     DrawNextObj
        tdc
        ldy     $1e
        cpy     #$0120
        bcc     @611f
        cpy     #$ffe0
        jcc     DrawNextObj
@611f:  longa
        lda     $d4
        sec
        sbc     #12
        sta     $d4
        shorta0
        ldy     $da
        lda     $087f,y                 ; facing direction
        beq     DrawChocoUp
        dec
        jeq     DrawChocoRight
        dec
        jeq     DrawChocoDown
        jmp     DrawChocoLeft

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
        ora     f:ChocoUpTileFlags+1,x
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
@61e0:  .word   $0000,$0001,$0000,$ffff ; tail x-offset

ChocoUpTailY:
@61e8:  .word   $0009,$000a,$0009,$000a ; tail y-offset

ChocoUpBodyX:
@61f0:  .word   $0000,$0001,$0000,$0001 ; body y-offset

ChocoUpTailTile:
@61f8:  .word   $2f4a,$6f4a,$2f4a,$6f4a ; tail tile

ChocoUpTileFlags:
@6200:  .word   $2000,$2000,$2000,$2000 ; unused

ChocoUpBodyTile1:
@6208:  .word   $2f4c,$2f60,$2f4c,$6f60 ; body tile (top)

ChocoUpBodyTile2:
@6210:  .word   $2f4e,$2f62,$2f4e,$6f62 ; body tile (bottom)

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
        adc     f:ChocoDownHeadX,x
        sta     $2a
        shorta
        sta     $0340,y
        tdc
        jsr     SetTopSpriteMSB
        lda     $24
        clc
        adc     f:ChocoDownHeadY,x
        sta     $0341,y
        longa
        lda     f:ChocoDownHeadTile,x
        sta     $0342,y
        lda     f:ChocoDownBodyTopTile,x
        sta     $034a,y
        lda     f:ChocoDownBodyBtmTile,x
        sta     $0402,y
        shorta0
        ldy     $da
        lda     $0881,y
        and     #$0e
        ora     f:ChocoDownTileFlags+1,x
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
        adc     f:ChocoBodyHeadX,x
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

ChocoDownHeadX:
@62b9:  .word   $0000,$0001,$0000,$ffff ; head x-offset

ChocoDownHeadY:
@62c1:  .word   $0007,$0008,$0007,$0008 ; head y-offset

ChocoBodyHeadX:
@62c9:  .word   $ffff,$0001,$ffff,$0001 ; body y-offset

ChocoDownHeadTile:
@62d1:  .word   $2f40,$2f40,$2f40,$2f40 ; head tile

ChocoDownTileFlags:
@62d9:  .word   $2000,$2000,$2000,$2000 ; tile flags

ChocoDownBodyTopTile:
@62e1:  .word   $2f42,$2f46,$2f42,$6f46 ; body tile (top)

ChocoDownBodyBtmTile:
@62e9:  .word   $2f44,$2f48,$2f44,$6f48 ; body tile (bottom)

; ------------------------------------------------------------------------------

; chocobo facing right
DrawChocoRight:
@62f1:  ldy     $d4
        longa
        lda     $1e
        sec
        sbc     #3
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
        adc     #16
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
        adc     f:ChocoSideYTbl,x
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
        lda     f:ChocoRightTopLeftTiles,x
        sta     $034a,y
        lda     f:ChocoRightTopRightTiles,x
        sta     $040a,y
        lda     f:ChocoRightBtmLeftTiles,x
        sta     $0402,y
        lda     f:ChocoRightBtmRightTiles,x
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

ChocoSideYTbl:
@63c5:  .word   $0000,$ffff,$0000,$ffff ; y-offset

ChocoRightTopLeftTiles:
@63cd:  .word   $6f64,$6f6c,$6f64,$6f84

ChocoRightTopRightTiles:
@63d5:  .word   $6f68,$6f80,$6f68,$6f88

ChocoRightBtmLeftTiles:
@63dd:  .word   $6f66,$6f6e,$6f66,$6f86

ChocoRightBtmRightTiles:
@63e5:  .word   $6f6a,$6f82,$6f6a,$6f8a

; ------------------------------------------------------------------------------

; chocobo facing left
DrawChocoLeft:
@63ed:  ldy     $d4
        longa
        lda     $1e
        clc
        adc     #3
        sta     $2a
        clc
        adc     #8
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
        adc     #16
        sta     $2a
        clc
        adc     #8
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
        adc     #8
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
        adc     f:ChocoSideYTbl,x
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
        lda     f:ChocoLeftTopRightTiles,x
        sta     $034a,y
        lda     f:ChocoLeftTopLeftTiles,x
        sta     $040a,y
        lda     f:ChocoLeftBtmRightTiles,x
        sta     $0402,y
        lda     f:ChocoLeftBtmLeftTiles,x
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

ChocoLeftTopLeftTiles:
@64cd:  .word   $2f64,$2f6c,$2f64,$2f84

ChocoLeftTopRightTiles:
@64d5:  .word   $2f68,$2f80,$2f68,$2f88

ChocoLeftBtmLeftTiles:
@64dd:  .word   $2f66,$2f6e,$2f66,$2f86

ChocoLeftBtmRightTiles:
@64e5:  .word   $2f6a,$2f82,$2f6a,$2f8a

; unused ???
@64ed:  .word   $0000,$0010,$0020,$0030

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
        longa_clc
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
@6584:  longa_clc
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
        jcs     DrawNextObj
@65c3:  lda     $27
        jne     DrawNextObj
        tdc
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
        jeq     @667b       ; jump if high
        jmp     @66cc       ; jump if low

; normal sprite priority
@662a:  longa
        lda     $d4         ; use one sprite
        sec
        sbc     #4
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
        sbc     #4
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
        sbc     #4
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
        lda     f:_c0693c,x
        sta     $14
        lda     #$0006
        sta     $18
@67aa:  stz     hMDMAEN
        ldx     $48
        ldy     $10f7,x
        cpy     #$07b0
        jeq     @6866
        lda     $0879,y
        and     #$00ff
        asl
        tax
        lda     f:MapSpriteGfxPtrsLo,x
        sta     $0e
        lda     f:MapSpriteGfxPtrsHi,x
        sta     $10
        ldx     $14
        lda     f:_c06944,x
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
        jne     @67aa
        shorta0
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

_c06934:
@6934:  .word   $0000,$00f6,$01ec,$02e2

_c0693c:
@693c:  .word   $0000,$000c,$0018,$0024

_c06944:
@6944:  .word   $6000,$6040,$6080,$60c0,$6200,$6240
        .word   $6280,$62c0,$6400,$6440,$6480,$64c0
        .word   $6600,$6640,$6680,$66c0,$6800,$6840
        .word   $6880,$68c0,$6a00,$6a40,$6a80,$6ac0

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
        lda     f:MapSpriteGfxPtrsLo+1,x
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
        lda     f:MapSpriteTileOffsets+12,x
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
        longa_clc
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
@6a04:  lda     $1188                   ; return if timer is disabled
        and     #$40
        bne     @6a0c
        rts
@6a0c:  ldx     $1189                   ; timer value
        stx     hWRDIVL
        lda     #60                     ; divide by 60 to get seconds
        sta     hWRDIVB
        nop7
        ldx     hRDDIVL
        stx     hWRDIVL
        lda     #10                     ; divide by 10 to get 10 seconds
        sta     hWRDIVB
        nop7
        lda     hRDMPYL
        sta     $1d                     ; remainder is one's digit of seconds
        ldx     hRDDIVL
        stx     hWRDIVL
        lda     #6                      ; divide by 6 to get minutes
        sta     hWRDIVB
        nop7
        lda     hRDMPYL
        sta     $1c                     ; remainder is ten's digit of seconds
        ldx     hRDDIVL
        stx     hWRDIVL
        lda     #10                     ; divide by 10 to get 10 minutes
        sta     hWRDIVB
        nop7
        lda     hRDMPYL
        sta     $1b                     ; remainder is one's digit of minutes
        lda     hRDDIVL
        sta     $1a                     ; result is ten's digit of minutes
        lda     #$cc                    ; set sprite y coordinates
        sta     $030d
        sta     $0311
        sta     $0315
        sta     $0319
        sta     $031d
        lda     #$c8                    ; set sprite x coordinates
        sta     $030c
        lda     #$d0
        sta     $0310
        lda     #$d8
        sta     $031c
        lda     #$e0
        sta     $0314
        lda     #$e8
        sta     $0318
        lda     #$31                    ; set priority = 3, palette = 0, msb of graphics = 1
        sta     $030f
        sta     $0313
        sta     $0317
        sta     $031b
        sta     $031f
        lda     #$84                    ; colon graphics
        sta     $031e
        lda     $1a                     ; digit graphics
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

.if LANG_EN
@DigitGfx := SmallFontGfx+$0b40
@ColonGfx := SmallFontGfx+$0c10
.else
@DigitGfx := SmallFontGfx+$0530
@ColonGfx := SmallFontGfx+$0cf0
.endif

@6adb:  lda     $0521
        bmi     @6ae1
        rts
@6ae1:  lda     #$80
        sta     hVMAINC
        ldx     #$7600
        stx     hVMADDL
        ldx     $00
@6aee:
.repeat 8, i
        lda     f:@DigitGfx+i*2,x
        eor     f:@DigitGfx+i*2+1,x
        sta     hVMDATAL
        lda     f:@DigitGfx+i*2+1,x
        sta     hVMDATAH
.endrep
        ldy     #$0018
@6b81:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6b81
        longa_clc
        txa
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        jne     @6aee
        ldy     #$0100
@6b9f:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6b9f
@6ba8:
.repeat 8, i
        lda     f:@DigitGfx+i*2,x
        eor     f:@DigitGfx+i*2+1,x
        sta     hVMDATAL
        lda     f:@DigitGfx+i*2+1,x
        sta     hVMDATAH
.endrep
        ldy     #$0018
@6c3b:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6c3b
        longa_clc
        txa
        adc     #$0010
        tax
        shorta0
        cpx     #$00a0
        jne     @6ba8
.repeat 8, i
        lda     f:@ColonGfx+i*2
        eor     f:@ColonGfx+i*2+1
        sta     hVMDATAL
        lda     f:@ColonGfx+i*2+1
        sta     hVMDATAH
.endrep
        ldy     #$01a0
@6ce9:  stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     @6ce9
        rts

; ------------------------------------------------------------------------------

; [ update party equipment effects ]

UpdateEquip:
@6cf3:  stz     $11df                   ; clear equipment effects
        ldy     $00
        stz     $1b
@6cfa:  lda     $0867,y                 ; check if character is enabled
        and     #$40
        beq     @6d14
        lda     $0867,y                 ; check if character is in current party
        and     #$07
        cmp     $1a6d
        bne     @6d14
        phy
        lda     $1b
        jsl     UpdateEquip_ext
        tdc
        ply
@6d14:  longa_clc
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
@6d26:  lda     $1eb9                   ; return if party switching is disabled
        and     #$40
        beq     @6d76
        lda     a:$0084                 ; return if map is loading
        bne     @6d76
        lda     $055e                   ; return if there was a party collision
        bne     @6d76
        ldx     $e5                     ; return if running an event
        cpx     #.loword(EventScript_NoEvent)
        bne     @6d76
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     @6d76
        ldy     $0803                   ; party object
        lda     $0869,y                 ; return if between tiles
        bne     @6d76
        lda     $086a,y
        and     #$0f
        bne     @6d76
        lda     $086c,y
        bne     @6d76
        lda     $086d,y
        and     #$0f
        bne     @6d76
        lda     $07                     ; branch if y button is down
        and     #$40
        bne     @6d6c
        lda     #$01                    ; enable party switching and return
        sta     $0762
        bra     @6d76
@6d6c:  lda     $0762                   ; y button, check party switching
        beq     @6d76
        stz     $0762                   ; if so, switch party
        bra     ChangeParty
@6d76:  rts

; ------------------------------------------------------------------------------

; [ switch parties ]

ChangeParty:
@6d77:  lda     $1a6d                   ; party number
        tay
        lda     $b2                     ; save party z-level
        sta     $1ff3,y
        lda     $1a6d                   ; increment party number
        inc
        cmp     #4                      ; only switch between first 3 parties
        bne     @6d8a
        lda     #1
@6d8a:  sta     $1a6d
        lda     #$20                    ; look for top character in new party
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
        sty     $07fb                   ; set the showing character
@6dba:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @6d99

; if no characters were found, increment the party and try again
        ldy     $07fb
        cpy     #$07d9
        beq     @6d77
        ldy     $07fb

; return if the new showing character was already the party object
        cpy     $0803
        beq     @6e43
        ldx     #$07d9                  ; clear party slots 2 through 4
        stx     $07fd
        stx     $07ff
        stx     $0801
        ldx     $0803                   ; copy movement type
        lda     $087c,x
        sta     $087c,y
        sta     $087d,y
        lda     #$00                    ; clear old party object movement type
        sta     $087c,x
        sta     $087d,x
        lda     $087f,x                 ; old party object facing direction
        asl3
        sta     $1a
        lda     $0868,x                 ; set saved facing direction
        and     #$e7
        ora     $1a
        sta     $0868,x
        ldx     $088d,y
        cpx     $82
        bne     @6e44

; new party is on the same map
        lda     #$01                    ; reload same map
        sta     $58
        lda     #$80                    ; enable map startup event
        sta     $11fa
        lda     $087a,y                 ; set party position
        sta     $1fc0
        sta     $1f66
        lda     $087b,y
        sta     $1fc1
        sta     $1f67
        jsr     FadeOut
        lda     #$01
        sta     $84
        jsr     PushPartyMap
        lda     $1a6d                   ; restore new party's z-level
        tay
        lda     $1ff3,y
        and     #$03
        sta     $0744
@6e43:  rts

; new party is on a different map
@6e44:  lda     #$80                    ; enable map startup event
        sta     $11fa
        longa
        lda     $088d,y                 ; set new map
        sta     $1f64
        lda     $086a,y                 ; set party position
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
        lda     #$80                    ; don't update party facing direction
        sta     $0743
        lda     #$01                    ; enable map load
        sta     $84
        jsr     PushPartyMap
        lda     $1a6d                   ; restore new party's z-level
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
@6e8b:  longa_clc
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
        longa_clc
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
@6ec2:  longa_clc
        lda     $1f81,y                 ; object map index
        sta     $088d,x
        txa
        adc     #$0029
        tax
        shorta0
        iny2                            ; loop through 16 characters
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
        iny2                            ; loop through 16 characters
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
        longa_clc
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
@6f40:  lda     $0880,x                 ; restore character palettes
        and     #$f1
        ora     $1f70,y
        sta     $0880,x
        lda     $0881,x
        and     #$f1
        ora     $1f70,y
        sta     $0881,x
        longa_clc
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

.proc GetTopChar
        ldy     $0803                   ; previous top char
        sty     $1e
        ldx     $086a,y                 ; x position
        stx     $26
        ldx     $086d,y                 ; y position
        stx     $28
        lda     #$20                    ; layer priority
        sta     $1a
        ldx     $00
        txy
loop:   lda     $1850,y
        and     #$07
        cmp     $1a6d
        bne     skip                    ; not in active party
        longa
        lda     $26
        sta     $086a,x                 ; set position
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
        sta     $7e2000,x               ; remove from object map data
        plx
        lda     $1850,y
        and     #$18
        cmp     $1a
        bcs     skip
        sta     $1a
        stx     $07fb                   ; topmost character in active party
skip:   longa_clc
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010
        bne     loop

; check if top char changed
        ldx     $07fb
        lda     $0867,x
        ora     #$80
        sta     $0867,x
        cpx     $1e
        jeq     done
        ldy     $1e
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
done:   ldy     #$07d9
        sty     $07fd                   ; hide slots 2, 3, 4
        sty     $07ff
        sty     $0801
        lda     #1
        sta     $0798                   ; validate and sort active objects
        rts
.endproc  ; GetTopChar

; ------------------------------------------------------------------------------

; [ restore character data ]

PopCharFlags:
@7077:  ldx     $00
        txy
@707a:  lda     $1850,y
        sta     $0867,x
        longa_clc
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010                  ; loop through 16 characters
        bne     @707a
        rts

; ------------------------------------------------------------------------------

; [ save character data ]

PushCharFlags:
@7091:  ldx     $00
        txy
@7094:  lda     $0867,x
        and     #$e7
        sta     $1a
        lda     $1850,y                 ; battle order
        and     #$18
        ora     $1a
        sta     $1850,y
        longa_clc
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010                  ; loop through 16 characters
        bne     @7094
        rts

; ------------------------------------------------------------------------------

; [ calculate object data pointers ]

CalcObjPtrs:
@70b6:  lda     #$29                    ; object data is 41 bytes each
        sta     hWRMPYA
        ldx     $00
@70bd:  txa
        lsr
        sta     hWRMPYB
        nop3
        longa
        lda     hRDMPYL
        sta     $0799,x                 ; store pointer
        shorta0
        inx2
        cpx     #$0062                  ; $31 objects total
        bne     @70bd
        rts

; ------------------------------------------------------------------------------

; [ get pointer to first valid character ]

; y = pointer to object data

GetTopCharPtr:
@70d8:  cpy     $07fb
        bne     @70ee                   ; branch if not party character 0
        ldy     #$07d9
        sty     $07fb                   ; clear all party character slots
        sty     $07fd
        sty     $07ff
        sty     $0801
        bra     @711c
@70ee:  cpy     $07fd                   ; branch if not party character 1
        bne     @7101
        ldy     #$07d9
        sty     $07fd                   ; clear party character slots 1-3
        sty     $07ff
        sty     $0801
        bra     @711c
@7101:  cpy     $07ff                   ; branch if not party character 2
        bne     @7111
        ldy     #$07d9
        sty     $07ff                   ; clear party character slots 2-3
        sty     $0801
        bra     @711c
@7111:  cpy     $0801                   ; branch if not party character 3
        bne     @711c
        ldy     #$07d9
        sty     $0801                   ; clear party character slots 3
@711c:  rts

; ------------------------------------------------------------------------------

; [ unused ]

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
@713a:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @711f
        rts

; ------------------------------------------------------------------------------

; [ validate and sort active objects ]

_c0714a:
sort_obj_work:
@714a:  ldx     #$0803
        stx     hWMADDL
        lda     #$00
        sta     hWMADDH
        stz     $1b

; char slot 1
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

; char slot 2
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

; char slot 3
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

; char slot 4
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

; other characters in the active party ???
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

; camera object
        lda     #$b0
        sta     hWMDATA
        lda     #$07
        sta     hWMDATA
        inc     $1b

; characters not in the active party
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

; npc objects
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
@730e:  lda     $59                     ; return if menu opening
        bne     @7334
        lda     $087c,y                 ; return if not a collision object
        and     #$40
        beq     @7334
        ldx     $e5                     ; return if an event is running
        cpx     #.loword(EventScript_NoEvent)
        bne     @7334
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     @7334
        lda     $84                     ; return if a map is loading
        bne     @7334
        lda     $055e                   ;
        bne     @7334
        cpy     #$0290                  ; return if the object is a character
        bcs     @7335
@7334:  rts
@7335:  lda     $087a,y                 ; pointer to object map data
        sta     $1e                     ; +$1e = tile above
        sta     $22                     ; +$22 = tile below
        inc
        and     $86
        sta     $20                     ; +$20 = tile to the right
        lda     $1e
        dec
        and     $86
        sta     $24                     ; +$24 = tile to the left
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
        stz     $1b                     ; $1b = facing direction

; check if the object came in contact with a character
        lda     ($1e)
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

; do collision event
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
        lda     #1
        sta     $055e
        rts

; ------------------------------------------------------------------------------

; [ update party collisions ]

UpdateCollisionScroll:
@73ac:  lda     $055e                   ; return if no collisions occurred
        cmp     #1
        bne     @73ce
        ldy     $0803                   ; return if party is between tiles
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
@73cf:  lda     #$02                    ; increment collision status
        sta     $055e
        ldy     $0560                   ; collided object data pointer
        longa
        lda     $086a,y
        lsr4
        sta     $26                     ; +$26 = x position (in tiles)
        lda     $086d,y
        lsr4
        sta     $28                     ; +$28 = y position (in tiles)
        shorta0
        stz     $27
        stz     $29
        lda     $26                     ; set destination h-scroll position
        sta     $0557
        sec
        sbc     $0541                   ; subtract current scroll position
        bpl     @7402
        inc     $27                     ; $27: 0 = scroll right, 1 = scroll left
        eor     $02
        inc
@7402:  sta     $26                     ; $26 = h-scroll distance
        lda     $28                     ; set horizontal scroll position
        sta     $0558
        sec
        sbc     $0542                   ; subtract current scroll position
        bpl     @7414
        inc     $29                     ; $29: 0 = scroll down, 1 = scroll up
        eor     $02
        inc
@7414:  sta     $28                     ; $28 = vertical scroll distance
        cmp     #2
        bcs     @7423                   ; branch if scrolling more than 2 tiles
        lda     $26
        cmp     #2
        jcc     @74bb

; scrolling more than 2 tiles
@7423:  lda     $28
        cmp     $26
        bcs     @744d

; h-scroll distance greater than v-scroll distance
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
        ldx     #$0200                  ; 4 pixels/frame horizontally
        stx     $0547
        bra     @7471

; v-scroll distance greater than h-scroll distance
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
        ldx     #$0200                  ; 4 pixels/frame vertically
        stx     $0549
@7471:  lda     $27                     ; branch if scrolling right
        beq     @7483
        longa
        lda     $0547                   ; negate horizontal scroll speed
        eor     $02
        inc
        sta     $0547
        shorta0
@7483:  lda     $29                     ; branch if scrolling up
        beq     @7495
        longa
        lda     $0549                   ; negate vertical scroll speed
        eor     $02
        inc
        sta     $0549
        shorta0
@7495:  ldx     $0547                   ; copy bg1 scroll speed to bg2 and bg3
        stx     $054b
        stx     $054f
        ldx     $0549
        stx     $054d
        stx     $0551
        ldx     $00                     ; clear scroll due to movement
        stx     a:$0073
        stx     a:$0075
        stx     a:$0077
        stx     a:$0079
        stx     a:$007b
        stx     a:$007d
@74bb:  lda     $087f,y                 ; update facing direction
        asl3
        sta     $1a
        lda     $0868,y
        and     #$e7
        ora     $1a
        sta     $0868,y
        lda     $055f                   ; get collision direction
        clc
        adc     #$02                    ; make character face attacker
        and     #$03
        sta     $087f,y
        tax
        lda     f:ObjStopTileTbl,x      ; set sprite based on facing direction
        sta     $0877,y
        lda     $1a6d                   ; save default party
        sta     $055d
        lda     $0867,y                 ; set new party
        and     #$07
        sta     $1a6d
        lda     $087c,y                 ; set movement type to activated
        and     #$f0
        ora     #$04
        sta     $087c,y
        sta     $087d,y
        ldy     #$07d9                  ; clear character slot 1 through 4
        sty     $07fd
        sty     $07ff
        sty     $0801
        ldy     $0562                   ; colliding npc data pointer
        tdc
        sta     $0882,y                 ; clear queue counter
        lda     $055f                   ; set facing direction
        sta     $087f,y
        tax
        lda     f:ObjStopTileTbl,x      ; set sprite based on facing direction
        sta     $0877,y
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        and     #$f0                    ; set movement type to activated
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
        adc     #^EventScript
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596                   ; set loop count
        lda     #1
        sta     $05c7                   ; set stack pointer
        ldx     #$0003
        stx     $e8
        ldy     $0803                   ; party object data pointer
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        and     #$f0                    ; set movement type to activated
        ora     #$04
        sta     $087c,y
        lda     $e1                     ; wait for scroll before executing event
        ora     #$20
        sta     $e1
        lda     #1                      ; wait for character objects update
        sta     $0798
        jsr     CloseMapTitleWindow
        rts

; ------------------------------------------------------------------------------

; [ update object actions ]

; called once per frame and once by map loader

UpdateObjActions:
@7578:  lda     $47                     ; only update 6 objects per frame
        and     #$03
        tax
        lda     f:FirstObjTbl2,x        ; get first object (x2)
        sta     $dc
        lda     #$06
        sta     $de

ObjActionLoop:
@7587:  tdc                             ; start of loop
        shorta
        lda     $dc
        tax
        ldy     $0803,x                 ; get pointer to object data
        sty     $da
        cmp     $dd                     ; skip if past last object
        bcc     @7599
@7596:  jmp     UpdateNextObjAction
@7599:  lda     $0869,y                 ; skip if this object is between tiles
        bne     @7596
        lda     $086a,y
        and     #$0f
        bne     @7596
        lda     $086c,y
        bne     @7596
        lda     $086d,y
        and     #$0f
        bne     @7596
        lda     $087c,y                 ; branch if object scrolls with bg2
        bmi     @7634
        lda     $0868,y                 ; branch if object has special graphics
        and     #$e0
        cmp     #$80
        beq     @7634
        lda     $088c,y                 ; branch if not normal sprite priority
        and     #$c0
        bne     @7634
        cpy     #$07b0                  ; branch if this is the camera
        beq     @763a
        ldx     $087a,y                 ; pointer to map data (old)
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        pha
        pla
        pha
        pla
        lda     hRDDIVL                 ; get object number
        asl
        cmp     $7e2000,x               ; clear in object map data for now
        bne     @75ea
        lda     #$ff
        sta     $7e2000,x
@75ea:  lda     $0867,y                 ; branch if object is visible
        bpl     @763a
        jsr     GetObjMapPtr
        ldx     $087a,y
        lda     $7f0000,x               ; tile number
        tax
        lda     $7e7600,x               ; tile properties
        and     #$03
        sta     $0888,y                 ; set z-level
        lda     $dc                     ; current object
        bne     @7629                   ; branch if not object 0 (party)
        lda     $087c,y                 ; branch if not user-controlled
        and     #$0f
        cmp     #$02
        bne     @7629
        lda     $b8                     ; branch if not on a bridge tile
        and     #$04
        beq     @761c
        lda     $b2                     ; branch if not on lower z-level
        cmp     #$02
        beq     @7627
@761c:  ldx     $087a,y                 ; pointer to map data
        lda     hRDDIVL                 ; get object number
        asl
        sta     $7e2000,x               ; set object map data
@7627:  bra     @763a
@7629:  ldx     $087a,y                 ; pointer to map data
        lda     hRDDIVL                 ; get object number
        asl
        sta     $7e2000,x               ; set object map data
@7634:  jsr     UpdateObjLayerPriorityAfter
        jsr     CheckCollosions
@763a:  lda     $087c,y                 ; movement type
        and     #$0f
        dec
        jeq     ExecObjScript
        dec
        jeq     UpdatePlayerAction
        dec
        beq     UpdateRandomObjAction
        dec
        beq     UpdateActiveObjAction
        cpy     $0803                   ; branch if this is the party object
        beq     UpdateActiveObjAction

; go to next object
UpdateNextObjAction:
@7656:  inc     $dc                     ; next object
        inc     $dc
        dec     $de
        jne     ObjActionLoop
        rts

; random movement
UpdateRandomObjAction:
@7662:  jsr     NPCMoveRand
        bra     UpdateNextObjAction

; activated (movement)
UpdateActiveObjAction:
@7667:  longa
        tdc
        sta     $0871,y                 ; clear movement speed
        sta     $0873,y
        shorta
        lda     $e5                     ; return if an event is running
        cmp     #<EventScript_NoEvent
        bne     @76db
        lda     $e6
        cmp     #>EventScript_NoEvent
        bne     @76db
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     @76db
        lda     $087d,y
        cpy     $0803
        bne     @769a                   ; branch if not the party object
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @769a                   ; branch if not the current party
        lda     #$02                    ; set movement type to user-controlled
        bra     @76cf
@769a:  lda     $087d,y                 ; previous movement type
        and     #$0f
        cmp     #$02
        bne     @76a7                   ; branch if not user-controlled
        lda     #$00                    ; set movement type to none
        bra     @76cf
@76a7:  sta     $1a                     ; restore previous movement type
        lda     $087c,y
        and     #$f0
        ora     $1a
        sta     $087c,y
        lda     $087c,y                 ; return if object collision-activated
        and     #$20
        bne     @76cd
        lda     $0868,y                 ; restore facing direction
        and     #$18
        lsr3
        sta     $087f,y
        tax
        lda     f:ObjStopTileTbl,x      ; set graphics position
        sta     $0877,y
@76cd:  bra     UpdateNextObjAction
@76cf:  sta     $1a                     ; set new movement type
        lda     $087c,y
        and     #$f0
        ora     $1a
        sta     $087c,y
@76db:  jmp     UpdateNextObjAction

; user-controlled movement
UpdatePlayerAction:
@76de:  lda     $1eb9                   ; return if user-control is disabled
        bmi     @76e6
        jsr     UpdatePlayerMovement
@76e6:  jmp     UpdateNextObjAction

; script-controlled movement
ExecObjScript:
@76e9:  lda     $0882,y                 ; decrement script wait counter
        beq     @76f8
        dec
        sta     $0882,y
        jmp     UpdateNextObjAction
@76f5:  jmp     @7783
@76f8:  lda     $0886,y                 ; number of steps to take
        beq     @76f5
        lda     $087e,y                 ; movement direction
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
@7739:  jmp     UpdateNextObjAction
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
        jmp     UpdateNextObjAction

; do next command from object script
@7783:  longa
        lda     $0883,y                 ; script pointer
        sta     $2a
        shorta0
        lda     $0885,y
        sta     $2c
        lda     [$2a]                   ; script command
        bmi     @779c

; object command $00-$7f: set graphical position
        sta     $0877,y
        jmp     IncObjScriptPtrContinue

; object command $80-$9f: horizontal/vertical movement
@779c:  cmp     #$a0
        jcs     @77bf
        sec
        sbc     #$80
        sta     $1a
        and     #$03
        sta     $087f,y                 ; set facing direction
        inc
        sta     $087e,y                 ; set movement direction
        lda     $1a
        lsr2
        inc
        sta     $0886,y                 ; set number of steps to take
        jsr     IncObjScriptPtr
        jmp     ExecObjScript

; object command $a0-$bf: diagonal movement
@77bf:  cmp     #$b0
        bcs     @77e1
        sec
        sbc     #$9c
        sta     $1a
        inc
        sta     $087e,y                 ; set movement direction
        lda     $1a
        tax
        lda     f:ObjMoveDirTbl,x       ; set facing direction
        sta     $087f,y
        lda     #1
        sta     $0886,y                 ; take one step
        jsr     IncObjScriptPtr
        jmp     ExecObjScript

; object command $c0-$c5: set object speed
@77e1:  cmp     #$c6
        bcs     @77ee
        sec
        sbc     #$c0
        sta     $0875,y                 ; set object speed
        jmp     IncObjScriptPtrContinue

; object command $c6-$ff
@77ee:  sec
        sbc     #$c6
        asl
        tax
        longa
        lda     f:ObjCmdTbl,x
        sta     $2d
        shorta0
        jmp     ($002d)

; ------------------------------------------------------------------------------

; [ increment object script pointer and continue ]

IncObjScriptPtrContinue:
@7801:  jsr     IncObjScriptPtr
        jmp     ExecObjScript

; ------------------------------------------------------------------------------

; object command jump table
ObjCmdTbl:
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
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $c7: disable walking animation ]

ObjCmd_c7:
@7886:  lda     $0868,y
        and     #$fe
        sta     $0868,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $c8: set sprite layer priority ]

; $eb = priority (0..3)

ObjCmd_c8:
@7891:  ldy     #1
        lda     [$2a],y
        asl
        sta     $1a
        ldy     $da
        lda     $0868,y
        and     #$f9
        ora     $1a
        sta     $0868,y
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $cc: turn object up ]

ObjCmd_cc:
@78ab:  tdc
        sta     $087f,y
        lda     #$04
        sta     $0877,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $cd: turn object right ]

ObjCmd_cd:
@78b7:  lda     #$01
        sta     $087f,y
        lda     #$47
        sta     $0877,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $ce: turn object down ]

ObjCmd_ce:
@78c4:  lda     #$02
        sta     $087f,y
        lda     #$01
        sta     $0877,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $cf: turn object left ]

ObjCmd_cf:
@78d1:  lda     #$03
        sta     $087f,y
        lda     #$07
        sta     $0877,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $d0: show object ]

ObjCmd_d0:
@78de:  lda     $0867,y                 ; return if object already visible
        bmi     @7924
        ora     #$80
        sta     $0867,y                 ; make object visible
        lda     $0868,y                 ; set sprite layer priority to default
        and     #$f9
        sta     $0868,y
        lda     $0880,y                 ; both sprites shown below priority 1 bg
        and     #$cf
        ora     #$20
        sta     $0880,y
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
        phy
        sty     hWRDIVL                 ; get object number
        lda     #$29
        sta     hWRDIVB
        nop7
        ldy     hRDDIVL
        cpy     #$0010
        bcs     @7924                   ; branch if not a character
        lda     $1850,y                 ; set character visible flag
        ora     #$80
        sta     $1850,y
@7924:  ply
        jmp     IncObjScriptPtrContinue

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
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e1: set event bit (+$1e80) ]

ObjCmd_e1:
@7969:  phy
        ldy     #1
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1e80,y
        ora     f:BitOrTbl,x
        sta     $1e80,y
        ply
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e2: set event bit (+$1ea0) ]

ObjCmd_e2:
@7983:  phy
        ldy     #1
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ea0,y
        ora     f:BitOrTbl,x
        sta     $1ea0,y
        ply
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e3: set event bit (+$1ec0) ]

ObjCmd_e3:
@799d:  phy
        ldy     #1
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ec0,y
        ora     f:BitOrTbl,x
        sta     $1ec0,y
        ply
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e4: clear event bit (+$1e80) ]

ObjCmd_e4:
@79b7:  phy
        ldy     #1
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitAndTbl,x
        sta     $1e80,y
        ply
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e5: clear event bit (+$1ea0) ]

ObjCmd_e5:
@79d1:  phy
        ldy     #1
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ea0,y
        and     f:BitAndTbl,x
        sta     $1ea0,y
        ply
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e6: clear event bit (+$1ec0) ]

ObjCmd_e6:
@79eb:  phy
        ldy     #1
        lda     [$2a],y
        jsr     GetSwitchOffset
        lda     $1ec0,y
        and     f:BitAndTbl,x
        sta     $1ec0,y
        ply
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $c9: set vehicle ]

; $eb = vvv-----
;       v = vehicle (0..7)

ObjCmd_c9:
@7a05:  ldy     #1
        lda     [$2a],y
        and     #$e0
        sta     $1a
        ldy     $da
        lda     $0868,y
        ora     $1a
        sta     $0868,y
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $d5: set position ]

ObjCmd_d5:
@7a1e:  ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x
        ldy     #1
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
        jmp     UpdateNextObjAction

; ------------------------------------------------------------------------------

; [ object command $d7: scroll to object ]

ObjCmd_d7:
@7a65:  ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x               ; clear object in map data
        longa
        ldx     $0803
        lda     $086a,x                 ; set party position
        sta     $086a,y
        lda     $086d,x
        sta     $086d,y
        shorta0
        sta     $086c,y                 ; clear low byte of object position
        sta     $0869,y
        jsr     GetObjMapPtr
        jsr     UpdateSpritePriority
        jsr     IncObjScriptPtr
        jmp     UpdateNextObjAction

; ------------------------------------------------------------------------------

; [ object command $dc: jump (low) ]

ObjCmd_dc:
@7a94:  lda     #$0f
        sta     $0887,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $dd: jump (high) ]

ObjCmd_dd:
@7a9c:  lda     #$5f
        sta     $0887,y
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $e0: pause ]

; $eb: duration (frames * 4)
; times 4 because each object updates once per 4 frames

ObjCmd_e0:
@7aa4:  longa
        tdc
        sta     $0871,y                 ; clear movement speed
        sta     $0873,y
        shorta
        cpy     #$07b0
        beq     @7ab9                   ; branch if camera
        cpy     $0803
        bne     @7abc                   ; branch if not showing character
@7ab9:  jsr     UpdateScrollRate
@7abc:  phy
        ldy     #1
        lda     [$2a],y                 ; set pause duration
        ply
        sta     $0882,y
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jmp     UpdateNextObjAction

; ------------------------------------------------------------------------------

; [ object command $f9: jump to event script ]

ObjCmd_f9:
@7acf:  lda     $055e
        bne     @7b09                   ; branch if a collision is already in progress
        ldx     $e5
        cpx     #.loword(EventScript_NoEvent)
        bne     @7b09                   ; branch if an event is running
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     @7b09
        phy
        ldy     #1                      ; copy event address
        lda     [$2a],y
        sta     $e5
        iny
        lda     [$2a],y
        sta     $e6
        iny
        lda     [$2a],y
        clc
        adc     #^EventScript
        sta     $e7
        ldy     #$0003
        sty     a:$00e8                   ; set event stack pointer
        ply
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
        jsr     IncObjScriptPtr
@7b09:  jmp     UpdateNextObjAction

; ------------------------------------------------------------------------------

; [ object command $fa: branch backward (50% chance) ]

ObjCmd_fa:
@7b0c:  jsr     Rand
        cmp     #$80
        bcs     ObjCmd_fc               ; 1/2 chance to branch
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $fb: branch forward (50% chance) ]

ObjCmd_fb:
@7b19:  jsr     Rand
        cmp     #$80
        bcs     ObjCmd_fd               ; 1/2 chance to branch
        jsr     IncObjScriptPtr
        jmp     IncObjScriptPtrContinue

; ------------------------------------------------------------------------------

; [ object command $fc: branch backward ]

ObjCmd_fc:
@7b26:  ldy     #1
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
        jmp     ExecObjScript

; ------------------------------------------------------------------------------

; [ object command $fd: branch forward ]

ObjCmd_fd:
@7b4b:  ldy     #1
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
        jmp     ExecObjScript

; ------------------------------------------------------------------------------

; [ object command $ff: end of script ]

ObjCmd_ff:
@7b70:  tdc
        sta     $0885,y                 ; clear script pointer (bank byte)
        lda     $087c,y
        and     #$f0
        sta     $087c,y                 ; clear movement type
        longa
        tdc
        sta     $0871,y                 ; clear movement speed
        sta     $0873,y
        sta     $0883,y                 ; clear script pointer
        shorta
        cpy     #$07b0
        beq     @7b94                   ; branch if camera
        cpy     $0803
        bne     @7b97                   ; branch if not showing character
@7b94:  jsr     UpdateScrollRate
@7b97:  jmp     UpdateNextObjAction

; ------------------------------------------------------------------------------

; [ increment object script pointer ]

IncObjScriptPtr:
@7b9a:  longa_clc
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
        and     #$03                    ; movement direction = (1..4)
        inc
        sta     $b3
        jsr     GetObjMapAdjacent
        ldx     $1e
        lda     $7e2000,x               ; return if there's an object there
        bpl     @7c1f
        lda     $7f0000,x               ; bg1 tile
        tax
        lda     $7e7700,x               ; branch if npc can't randomly move here
        bpl     @7c1f
        lda     $0888,y                 ; object z-level
        dec
        bne     @7beb                   ; branch if not upper z-level

; object is upper z-level
        lda     $7e7600,x               ; tile z-level
        and     #$07
        cmp     #$01
        beq     @7bf5                   ; branch if tile is upper z-level
        lda     $7e7600,x
        and     #$07
        cmp     #$04
        beq     @7bf5
        bra     @7c1f                   ; return if a bridge tile

; object is lower z-level
@7beb:  lda     $7e7600,x               ; tile z-level
        and     #$07
        cmp     #$02
        bne     @7c1f                   ; return if tile is not lower z-level
@7bf5:  jsr     UpdateObjLayerPriorityBefore
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop8
        lda     hRDDIVL                 ; object number
        asl
        ldx     $1e
        sta     $7e2000,x               ; put object at new location in map data
        lda     $b3
        sta     $087e,y                 ; set movement direction
        dec
        sta     $087f,y                 ; set facing direction
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
@7c2d:  lda     $0868,y                 ; sprite layer priority
        and     #$06
        bne     _c07c69
        ldx     $087a,y                 ; pointer to map data
        lda     $7f0000,x               ; bg1 tile
        tax
        lda     $7e7600,x               ; tile properties
        cmp     #$f7
        beq     _7c94                   ; branch if tile is impassable
        and     #$04
        bne     _7c94                   ; branch if tile is a bridge tile
        lda     $7e7600,x
        and     #$08
        beq     @7c58                   ; branch if top sprite isn't shown above priority 1 bg
        lda     $0880,y                 ; top sprite shown above priority 1 bg
        ora     #$30
        sta     $0880,y
@7c58:  lda     $7e7600,x               ;
        and     #$10
        beq     @7c68
        lda     $0881,y
        ora     #$30
        sta     $0881,y
@7c68:  rts

; ------------------------------------------------------------------------------

; [  ]

_c07c69:
set_fixed_prio:                         ; i think...
@7c69:  lsr
        dec
        bne     _7c80                   ; branch if not priority 1
        lda     $0880,y
        ora     #$30
        sta     $0880,y
        lda     $0881,y
        and     #$cf
        ora     #$20
        sta     $0881,y
        rts

_7c80:  dec
        bne     _7c94                   ; branch if not priority 2
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
@7ca9:  lda     $0868,y                 ; object sprite layer priority
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
        lda     $086a,y                 ; x position
        lsr4
        shorta
        and     $86                     ; bg1 x clip
        sta     $087a,y                 ; low byte of object map data pointer
        longa
        lda     $086d,y                 ; y position
        lsr4
        shorta
        and     $87                     ; bg1 y clip
        sta     $087b,y                 ; high byte of object map data pointer
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
@7d2a:  ldx     $73                     ; bg1 h-scroll speed
        bmi     @7d60                   ; branch if negative
        longa
        txa
        lsr4
        shorta
        sta     hWRMPYA
        lda     $0553                   ; bg2 h-scroll multiplier
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        sta     $77                     ; set bg2 h-scroll speed
        shorta0
        lda     $0555                   ; bg3 h-scroll multiplier
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        sta     $7b                     ; set bg3 h-scroll speed
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
@7d99:  ldx     $75                     ; bg1 v-scroll speed
        bmi     @7dce                   ; branch if negative
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
@7e08:  lda     $0559                   ; branch if screen is not locked
        beq     @7e20
        cpy     #$07b0                  ; return if not the camera
        bne     @7e1f
        ldx     $1021                   ; ($0871 + $07b0)
        stx     $73                     ; set horizontal scroll speed
        ldx     $1023                   ; ($0873 + $07b0)
        stx     $75                     ; set vertical scroll speed
        jsr     CalcParallaxRate
@7e1f:  rts
@7e20:  ldy     $0803
        lda     $062d                   ; max horizontal scroll position
        cmp     #$ff
        beq     @7e3c                   ; branch if no max
        lda     $af
        ldx     $0871,y                 ; party horizontal scroll speed
        bpl     @7e32
        dec
@7e32:  cmp     $062c                   ; branch if less than the minimum
        bcc     @7e43
        cmp     $062d                   ; branch if greater than the maximum
        bcs     @7e43
@7e3c:  ldx     $0871,y                 ; party horizontal movement speed
        stx     $73                     ; set horizontal scroll speed
        bra     @7e4b
@7e43:  ldx     $00
        stx     $73
        stx     $77
        stx     $7b
@7e4b:  lda     $062f                   ; max vertical scroll position
        cmp     #$ff
        beq     @7e64                   ; branch if no max
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
@7e77:  lda     $0875,y                 ; object speed
        tax
        lda     f:ObjMoveMult,x         ; speed multiplier
        sta     $1b
        lda     $087e,y                 ; movement direction
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
