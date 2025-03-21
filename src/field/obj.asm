
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

.proc InitSpritePal
        ldx     $00
:       lda     f:MapSpritePal,x
        sta     $7e7300,x
        sta     $7e7500,x
        inx
        cpx     #$0100
        bne     :-
        rts
.endproc  ; InitSpritePal

; ------------------------------------------------------------------------------

; unused (same as FirstObjTbl1 and FirstObjTbl2)
UnusedFirstObjTbl:
        .byte   $00,$0c,$18,$24

; ------------------------------------------------------------------------------

; [ init character portrait (from ending) ]

.proc InitPortrait
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
        clr_a
        pha
        plb
        stz     hMDMAEN
        ldx     #$7000                  ; clear vram $7000-$7800
        stx     hVMADDL
        lda     #$80
        sta     hVMAINC
        lda     #$09
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$0000                  ; source = $00 (fixed address)
        stx     hDMA0::ADDR
        lda     #$00
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$1000
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        stz     hMDMAEN
        lda     #$41
        sta     hDMA0::CTRL
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
        sta     hDMA0::ADDR
        shorta0
        lda     #^PortraitGfx
        sta     hDMA0::ADDR_B
        ldy     #$0020                  ; transfer one tile at a time
        sty     hDMA0::SIZE
        lda     f:PortraitVRAMTbl,x
        longa_clc
        asl4
        clc
        adc     #$7000
        sta     hVMADDL
        shorta0
        lda     #BIT_0
        sta     hMDMAEN
        inx
        cpx     #25
        bne     @517c
        rts
.endproc  ; InitPortrait
; ------------------------------------------------------------------------------

; pointers to character portrait graphics (+$ed0000, first 16 only)
PortraitGfxPtrs:
        .repeat 16, i
        .addr   PortraitGfx+$0320*i
        .endrep

; character portrait tile formation
PortraitTiles:
        .byte   $00,$01,$02,$03,$08
        .byte   $10,$11,$12,$13,$09
        .byte   $04,$05,$06,$07,$0a
        .byte   $14,$15,$16,$17,$0b
        .byte   $0d,$0e,$0f,$18,$0c

; character portrait vram location
PortraitVRAMTbl:
        .byte   $00,$01,$02,$03,$04
        .byte   $10,$11,$12,$13,$14
        .byte   $20,$21,$22,$23,$24
        .byte   $30,$31,$32,$33,$34
        .byte   $40,$41,$42,$43,$44

; ------------------------------------------------------------------------------

; [ init character object sprite priority ]

.proc InitCharSpritePriority
        ldy     $00
:       lda     $0868,y                 ; sprite priority/walking animation
        and     #$f8                    ; enable walking animation
        ora     #$01
        sta     $0868,y
        longa_clc                          ; loop through character objects only
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     :-
        rts
.endproc  ; InitCharSpritePriority

; ------------------------------------------------------------------------------

; [ init npc event bits ]

.proc InitNPCSwitches
        ldx     $00
:       lda     f:InitNPCSwitch,x
        sta     $1ee0,x
        inx
        cpx     #sizeof_InitNPCSwitch
        bne     :-
        rts
.endproc  ; InitNPCSwitches

.pushseg
.segment "init_npc_switch"

; c0/e0a0
InitNPCSwitch:
        .incbin "init_npc_switch.dat"
        calc_size InitNPCSwitch

.popseg

; ------------------------------------------------------------------------------

; [ init object map data ]

.proc InitNPCMap
        ldy     $00                     ; loop through all objects
        stz     $1b
Loop:   cpy     $0803                   ; skip if this is the party object
        beq     Skip
        ldx     $088d,y                 ; skip if object is not on this map
        cpx     a:$0082
        bne     Skip
        lda     $0867,y                 ; skip if object is not visible
        bpl     Skip
        lda     $087c,y                 ; skip if object scrolls with bg2
        bmi     Skip
        lda     $0868,y                 ; skip if this is an npc with special graphics
        and     #$e0
        cmp     #$80
        beq     Skip
        lda     $088c,y                 ; skip if not normal sprite priority
        and     #$c0
        bne     Skip
        jsr     GetObjMapPtr
        ldx     $087a,y                 ; get pointer
        lda     $1b
        sta     $7e2000,x               ; set object map data
Skip:   inc     $1b                     ; next object
        inc     $1b
        longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$07b0
        bne     Loop
        ldy     $0803                   ; pointer to party object data
        sty     hWRDIVL
        lda     #$29                    ; divide by $29 to get object number
        sta     hWRDIVB
        lda     $b8                     ; tile properties, branch if bottom sprite is lower z-level
        and     #$04
        beq     :+
        lda     $b2                     ; return if party is on lower z-level
        cmp     #$02
        beq     Done
:       jsr     GetObjMapPtr
        ldx     $087a,y                 ; get pointer
        lda     hRDDIVL                 ; get object number * 2
        asl
        sta     $7e2000,x               ; set object map data
Done:   rts
.endproc  ; InitNPCMap

; ------------------------------------------------------------------------------

; [ load npc data ]

.proc InitNPCs
        ldx     $00
:       stz     $0af7,x                 ; clear object data for npcs $10-$28
        inx
        cpx     #$03d8
        bne     :-
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
        jeq     HideRemainingNPCs
Loop:   lda     f:NPCProp::EventPtr,x
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
        beq     :+                      ; branch if npc is not enabled
        lda     #$c0                    ; enable and show npc
:       sta     $0867,y
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
        beq     :+                      ; branch if no special animation
        lsr5
        ora     $088c,y
        sta     $088c,y
        lda     f:NPCProp::AnimType,x
        and     #NPC_ANIM_TYPE::MASK
        asl3
        ora     $088c,y
        ora     #$20                    ; enable animation
        sta     $088c,y
        bra     :+
:       longa
        lda     $82                     ; set map index
        sta     $088d,y
        shorta0
        clr_a
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
        jne     Loop

; disable and hide any remaining npcs
HideRemainingNPCs:
        cpy     #$07b0
        beq     Done
:       lda     $0867,y
        and     #$3f
        sta     $0867,y
        longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$07b0                  ; 32 npcs total
        bne     :-
Done:   jsr     _c0714a
        rts
.endproc  ; InitNPCs

; ------------------------------------------------------------------------------

; [ init special npc graphics ]

.proc InitSpecialNPCs
        lda     $078f       ; return if there are no active npc's
        beq     Done
        ldy     #$0290      ; start with npc $10
        clr_a
Loop:   pha
        lda     $0868,y     ; skip if not special graphics
        and     #$e0
        cmp     #$80
        bne     :+
        phy
        jsr     InitSpecialNPCGfx
        ply
:       longa_clc
        tya
        adc     #$0029      ; loop through all active npc's
        tay
        shorta0
        pla
        inc
        cmp     $078f
        bne     Loop
Done:   rts
.endproc  ; InitSpecialNPCs

; ------------------------------------------------------------------------------

; [ init special graphics for npc ]

; Y: pointer to npc object data

.proc InitSpecialNPCGfx
        lda     $087c,y     ; passability flag
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
        clr_a
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
        lda     $087c,y                 ; 32x32 graphics flag
        and     #$20
        bne     Is32x32

; 16x16 graphics
Is16x16:
        lda     #$41
        sta     hDMA0::CTRL
        lda     #$80
        sta     hVMAINC
        lda     #<hVMDATAL
        sta     hDMA0::HREG
@Loop1: ldx     $3b
        stx     $2d
        ldy     #2                      ; copy 2 tiles
@Loop2: stz     hMDMAEN
        ldx     $2d
        stx     hVMADDL
        ldx     $2a
        stx     hDMA0::ADDR
        lda     $2c
        sta     hDMA0::ADDR_B
        ldx     #$0040
        stx     hDMA0::SIZE
        lda     #BIT_0
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
        bne     @Loop2
        longa_clc
        lda     $3b
        adc     #$0020
        sta     $3b
        shorta0
        dec     $1b
        bne     @Loop1
        rts

; 32x32 graphics
Is32x32:
        lda     #$41
        sta     hDMA0::CTRL
        lda     #$80
        sta     hVMAINC
        lda     #<hVMDATAL
        sta     hDMA0::HREG
@Loop1: ldx     $3b
        stx     $2d
        ldy     #4                      ; copy 4 tiles
@Loop2: stz     hMDMAEN
        ldx     $2d
        stx     hVMADDL
        ldx     $2a
        stx     hDMA0::ADDR
        lda     $2c
        sta     hDMA0::ADDR_B
        ldx     #$0080                  ; $80 bytes each
        stx     hDMA0::SIZE
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
        bne     @Loop2
        longa_clc
        lda     $3b
        adc     #$0040
        sta     $3b
        shorta0
        dec     $1b
        bne     @Loop1
        rts
.endproc  ; InitSpecialNPCGfx

; ------------------------------------------------------------------------------

; [ add object to animation queue ]

; called when an object is created (event command $3d)
; Y: pointer to object data

.proc StartObjAnim
        ldx     $00
        longa
:       lda     $10f7,x                 ; object animation queue
        cmp     #$07b0
        beq     FoundObj                ; look for the next available slot
        inx2
        cpx     #$002e
        bne     :-

FoundObj:
        tya
        sta     $10f7,x                 ; add object to queue
        shorta0
        txa
        sta     $088f,y                 ; pointer to animation queue
        rts
.endproc  ; StartObjAnim

; ------------------------------------------------------------------------------

; [ remove object from animation queue ]

; called when an object is deleted (event command $3e)
; Y: pointer to object data

.proc StopObjAnim
        lda     $088f,y     ; pointer to animation queue
        tax
        longa
        lda     #$07b0
        sta     $10f7,x     ; no object
        shorta0
        rts
.endproc  ; StopObjAnim

; ------------------------------------------------------------------------------

; [ init object animation ]

; called when a map is loaded

.proc InitObjAnim
        ldy     $00
        tyx
Loop:   lda     $0867,y
        and     #$40
        beq     :+
        longa
        tya
        sta     $10f7,x
        shorta0
        txa
        sta     $088f,y
        inx2
        cpx     #$0030                  ; max of 24 animated objects
        beq     Done
:       longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$07b0
        bne     Loop
Done:   rts
.endproc  ; InitObjAnim

; ------------------------------------------------------------------------------

; [ clear object animation queue ]

.proc ResetObjAnim
        longa
        stz     a:$0048       ; clear animation queue pointer
        stz     a:$0049
        ldx     $00
        lda     #$07b0
:       sta     $10f7,x     ; clear animation queue
        inx2
        cpx     #$0030
        bne     :-
        shorta0
        rts
.endproc  ; ResetObjAnim

; ------------------------------------------------------------------------------

; [ init object graphics ]

.proc InitObjGfx
        jsr     ClearObjMap
        jsr     ClearSpriteGfx
        jsr     TfrVehicleGfx
        jsr     ResetObjAnim
        rts
.endproc  ; InitObjGfx

; ------------------------------------------------------------------------------

; [ update object sprite priority ]

.proc UpdateSpritePriority
        lda     $0881,y     ; lower sprite always shown behind priority 1 bg
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
        beq     LowerZ
        cmp     #$02
        beq     UpperZ
        cmp     #$03
        beq     Transition

; bridge tile: upper sprite shown in front of priority 1 bg
BridgeTile:
        lda     $0880,y
        and     #$cf
        ora     #$30
        sta     $0880,y
        rts

; lower z-level: upper sprite shown behind priority 1 bg
LowerZ:
        lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
        rts

; upper z-level: upper sprite shown behind priority 1 bg
UpperZ:
        lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
        rts

; transition tile: upper sprite shown behind priority 1 bg
Transition:
        lda     $0880,y
        and     #$cf
        ora     #$20
        sta     $0880,y
        rts
.endproc  ; UpdateSpritePriority

; ------------------------------------------------------------------------------

; [ clear object map data ]

.proc ClearObjMap
        ldx     #$2000                  ; clear $7e2000-$7e6000
        stx     hWMADDL
        stz     hWMADDH
        ldx     #$4000
        lda     #$ff
:       sta     hWMDATA
        dex
        bne     :-
        rts
.endproc  ; ClearObjMap

; ------------------------------------------------------------------------------

; [ copy vehicle graphics to vram ]

.proc TfrVehicleGfx
        stz     hMDMAEN
        lda     #$80
        sta     hVMAINC
        ldx     #$7200                  ; vram destination = $7200
        stx     hVMADDL
        lda     #$41
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #near VehicleGfx        ; source address
        stx     hDMA0::ADDR
        lda     #^VehicleGfx
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$1c00                  ; size = $1c00
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts
.endproc  ; TfrVehicleGfx

; ------------------------------------------------------------------------------

; [ clear sprite graphics in vram ]

.proc ClearSpriteGfx
        stz     a:$0081
        lda     #$80
        sta     hVMAINC
        ldx     #$6000                  ; vram destination = $6000 (sprite graphics)
        stx     hVMADDL
        lda     #$09                    ; fixed dma source address
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$0081                  ; source address = $81 (dp)
        stx     hDMA0::ADDR
        lda     #$00
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$2000                  ; size = $2000
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts
.endproc  ; ClearSpriteGfx

; ------------------------------------------------------------------------------

; [ init sprite high data ]

.proc InitSpriteMSB
        lda     #$7e
        pha
        plb
        ldy     $00
        clr_a
Loop1:  ldx     #$0010
Loop2:  sta     $7800,y     ; sprite high data pointers
        iny
        dex
        bne     Loop2
        inc
        cpy     #$0100
        bne     Loop1
        ldy     $00
Loop3:  ldx     $00
Loop4:  lda     f:SpriteMSBAndTbl,x   ; sprite high data inverse bit masks
        sta     $7900,y
        lda     f:SpriteMSBOrTbl,x   ; sprite high data bit masks
        sta     $7a00,y
        iny
        inx
        cpx     #$0010
        bne     Loop4
        cpy     #$0100
        bne     Loop3
        clr_a
        pha
        plb
        rts
.endproc  ; InitSpriteMSB

; ------------------------------------------------------------------------------

; sprite high data inverse bit masks
SpriteMSBAndTbl:
        .byte   $fe,$fe,$fe,$fe
        .byte   $fb,$fb,$fb,$fb
        .byte   $ef,$ef,$ef,$ef
        .byte   $bf,$bf,$bf,$bf

; sprite high data bit masks
SpriteMSBOrTbl:
        .byte   $01,$01,$01,$01
        .byte   $04,$04,$04,$04
        .byte   $10,$10,$10,$10
        .byte   $40,$40,$40,$40

; ------------------------------------------------------------------------------

; [ update object positions ]

.proc MoveObjs
        stz     $dc                     ; start with object 0
        lda     #$18                    ; update 24 objects
        sta     $de
Loop:   lda     $dc                     ; return if past the last active object
        cmp     $dd
        jcs     Skip
        tax
        longa
        lda     $0803,x                 ; get pointer to object data
        sta     $da
        tay

; update horizontal movement
        lda     $0871,y                 ; get horizontal movement speed
        bmi     MoveLeft

; moving right, add to horizontal position
        lda     $0869,y
        clc
        adc     $0871,y
        sta     $0869,y
        shorta
        clr_a
        adc     $086b,y
        sta     $086b,y
        longa
        bra     :+

; moving left, subtract from horizontal position
MoveLeft:
        lda     $0871,y
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

; vertical movement
:       lda     $0873,y                 ; get vertical movement speed
        bmi     MoveUp

; moving down, add to vertical position
        lda     $086c,y
        clc
        adc     $0873,y
        sta     $086c,y
        shorta
        clr_a
        adc     $086e,y
        sta     $086e,y
        bra     :+

; moving up, subtract from vertical position
MoveUp:
        lda     $0873,y
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

; update jump offset
:       clr_a                           ; get jump position
        shorta
        lda     $0887,y
        and     #$3f
        beq     :+                      ; skip if not jumping
        lda     $0887,y                 ; decrement jump counter
        tax
        dec
        sta     $0887,y
        lda     f:ObjJumpLowTbl,x       ; set y-offset

:       sta     $086f,y
        jsr     UpdateObjFrame
        lda     $0869,y                 ; branch if object is between tiles
        bne     Skip
        lda     $086a,y
        and     #$0f
        bne     Skip
        lda     $086c,y
        bne     Skip
        lda     $086d,y
        and     #$0f
        bne     Skip

; clear movement speed if object reached the next tile
        clr_a
        sta     $0871,y
        sta     $0872,y
        sta     $0873,y
        sta     $0874,y

; next object
Skip:   inc     $dc
        inc     $dc
        dec     $de
        jne     Loop
        rts
.endproc  ; MoveObjs

; ------------------------------------------------------------------------------

; graphics positions for vehicle movement (chocobo/magitek only)
ObjVehicleTileTbl:
        .byte   $04,$05,$04,$03
        .byte   $6e,$6f,$6e,$6f
        .byte   $01,$02,$01,$00
        .byte   $2e,$2f,$2e,$2f

; graphics positions for character movement
ObjMoveTileTbl:
        .byte   $04,$05,$04,$03
        .byte   $47,$48,$47,$46
        .byte   $01,$02,$01,$00
        .byte   $07,$08,$07,$06

; graphics positions for standing still
ObjStopTileTbl:
        .byte   $04,$47,$01,$07

; graphics positions for special animation (animation offset)
ObjSpecialTileTbl:
        .byte   $00,$00,$32,$28,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [ update object graphics position ]

.proc UpdateObjFrame
        lda     $088c,y                 ; check for special object animation
        and     #$20
        jne     SpecialAnim
        cpy     $0803                   ; no special animation, check if this is the party object
        bne     :+
        lda     $b9                     ; tile properties
        cmp     #$ff
        beq     :+
        and     #$40                    ; force facing direction to be up if on a ladder tile
        beq     :+
        clr_a
        bra     :++
:       lda     $087f,y                 ; facing direction
:       asl2
        sta     $1a
        lda     $0868,y                 ; vehicle
        and     #$60
        jne     OnVehicle

; no vehicle
        lda     $0868,y
        and     #$01                    ; return if walking animation is disabled
        beq     @58aa
        lda     $b8                     ; tile properties, diagonal movement
        and     #$c0
        beq     @587d
        ldx     $0871,y
        beq     @588a
        ldx     $0873,y
        bne     @5897
@587d:  ldx     $0871,y                 ; use horizontal direction to get frame
        beq     @588a
        lda     $086a,y
        lsr3
        bra     @589d
@588a:  ldx     $0873,y                 ; use vertical direction
        beq     @58aa
        lda     $086d,y
        lsr3
        bra     @589d
@5897:  lda     $46                     ; diagonal, use vblank counter, but only divide by 4 (faster steps)
        lsr2
        bra     @589d
@589d:  and     #$03                    ; combine frame and facing direction
        clc
        adc     $1a
        tax
        lda     f:ObjMoveTileTbl,x      ; get graphics position
        sta     $0877,y
@58aa:  jmp     Done

OnVehicle:
        cmp     #$60
        beq     Raft

; chocobo or magitek
        ldx     $0871,y
        beq     @58be
        lda     $086a,y                 ; horizontal movement
        lsr3
        bra     @58c9
@58be:  ldx     $0873,y
        beq     @58c9
        lda     $086d,y                 ; vertical movement
        lsr3
@58c9:  and     #$03                    ; combine frame and facing direction
        clc
        adc     $1a
        tax
        lda     f:ObjVehicleTileTbl,x   ; get graphics position
        sta     $0877,y
        bra     Done

Raft:
        lda     $1a
        tax
        lda     f:ObjMoveTileTbl,x
        sta     $0877,y
        bra     Done

; special animation
SpecialAnim:
        lda     $0868,y                 ; special animation speed (this will always be zero for special npc graphics)
        and     #$60
        lsr5
        tax
        lda     $45                     ; frame counter
        lsr                             ; 0: update every 4 frames
        lsr                             ; 1: update every 8 frames
@58f3:  cpx     #$0000                  ; 2: update every 16 frames
        beq     @58fc                   ; 3: update every 32 frames
        lsr
        dex
        bra     @58f3
@58fc:  tax
        lda     $088c,y                 ; number of animated frames

; 0: one frame
        and     #$18
        bne     @5908
        stz     $1b
        bra     @5927

; 1: one frame, flips back and forth horizontally
@5908:  cmp     #$08
        bne     @5917
        txa
        and     #$01
        beq     @5913
        lda     #$40
@5913:  sta     $1b
        bra     @5927

; 2: two frames
@5917:  cmp     #$10
        bne     @5922
        txa
        and     #$01
        sta     $1b
        bra     @5927

; 3: 4 frames
@5922:  txa
        and     #$03
        sta     $1b

@5927:  lda     $088c,y     ; graphic position offset
        and     #$07
        tax
        lda     f:ObjSpecialTileTbl,x
        clc
        adc     $1b
        sta     $0877,y     ; set next graphic position
Done:   rts
.endproc  ; UpdateObjFrame

; ------------------------------------------------------------------------------

; [ update party sprite data ]

.proc FixPlayerSpritePriority
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
.endproc  ; FixPlayerSpritePriority

; ------------------------------------------------------------------------------

; y-offsets for objects jumping (low)
ObjJumpLowTbl:
        .byte   $02,$04,$06,$08,$09,$0a,$0b,$0b,$0b,$0b,$0a,$09,$08,$06,$04,$02
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; y-offsets for objects jumping (high)
ObjJumpHighTbl:
        .byte   $05,$09,$0e,$11,$15,$18,$1b,$1e,$20,$22,$24,$26,$27,$28,$29,$29
        .byte   $29,$29,$28,$27,$26,$24,$22,$20,$1e,$1b,$18,$15,$11,$0e,$09,$05
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; ------------------------------------------------------------------------------

; [ update object sprite data ]

.proc DrawObjSprites
        ldx     #(hWMDATA & $ff00)      ; nonzero dp, don't use clr_a
        phx
        pld
        ldx     #$0300                  ; clear $0300-$0520
        stx     <hWMADDL
        stz     <hWMADDH
        ldy     #$0020
        lda     #$ef
:       .repeat 16
        sta     <hWMDATA
        .endrep
        dey
        bne     :-
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
        and     #%11
        tax
        lda     f:FirstObjTbl1,x
        sta     $dc
Loop1:  lda     $dc
        tax
        ldy     $10f7,x                 ; pointer to object data
        cpy     #$07b0
        beq     :+                      ; branch if empty
        lda     $0877,y
        sta     $0876,y                 ; set current graphic position
:       inc     $dc                     ; next object
        inc     $dc
        dec     $de
        bne     Loop1
        ldy     #$00a0                  ; normal priority sprite data pointer
        sty     $d4
        ldy     #$0020                  ; low and high priority sprite data pointer
        sty     $d6
        sty     $d8
        lda     #$18                    ; update all 24 objects every frame
        sta     $de
        stz     $dc                     ; current object

; start of object loop
Loop2:  lda     $dc
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

::DrawNextObj:
        shorta0
        inc     $dc
        inc     $dc
        dec     $de
        jne     Loop2
        jsr     FixPlayerSpritePriority
        clr_a
        pha
        plb
        rts
.endproc  ; DrawObjSprites

; ------------------------------------------------------------------------------

; unused
        .byte   $fe,$fb,$ef,$bf
        .byte   $01,$04,$10,$40

; unused
        .word   $0000,$00f6,$01ec,$02e2,$03d8

; object sprite graphics locations in vram
ObjSpriteVRAMTbl:
        .word   $0000,$0004,$0008,$000c
        .word   $0020,$0024,$0028,$002c
        .word   $0040,$0044,$0048,$004c
        .word   $0060,$0064,$0068,$006c
        .word   $0080,$0084,$0088,$008c
        .word   $00a0,$00a4,$00a8,$00ac

; ------------------------------------------------------------------------------

; [ update object sprite data (no vehicle) ]

.proc DrawObjNoVehicle
        lda     $087c,y                 ; branch if object scrolls with bg2
        bmi     ScrollWithBG2

; object scrolls with bg1
ScrollWithBG1:
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
        adc     #8                      ; add 8
        sta     $1e                     ; +$1e = x position on screen
        clc
        adc     #8                      ; add 8
        shorta
        bra     :+

; object scrolls with bg2
ScrollWithBG2:
        longa_clc
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

:       xba                             ; return if sprite is off-screen to the right
        jne     DrawNextObj
        lda     $27
        jne     DrawNextObj             ; return if sprite is off-screen to the bottom
        clr_a
        lda     $0876,y                 ; graphics position
        tax
        lda     f:TopSpriteHFlip,x      ; horizontal flip flag (upper sprite)
        ora     $0880,y
        sta     $1b
        lda     f:BtmSpriteHFlip,x      ; horizontal flip flag (lower sprite)
        ora     $0881,y
        sta     $1d
        lda     $088f,y                 ; pointer to animation queue
        tax
        lda     f:ObjSpriteVRAMTbl,x   ; object sprite graphics location in vram
        sta     $1a                     ; $1a = upper tile
        inc2
        sta     $1c                     ; $1c = lower tile
        lda     $088c,y                 ; sprite order priority
        and     #$c0
        beq     NormalPriority
        cmp     #$40
        jeq     HighPriority
        jmp     LowPriority

; normal priority
NormalPriority:
        longa
        lda     $d4                     ; decrement normal priority sprite data pointer
        sec
        sbc     #4
        sta     $d4
        tay
        lda     $1a
        sta     $0342,y                 ; set sprite data
        lda     $1c
        sta     $0402,y
        shorta0
        lda     $1e
        sta     $0340,y                 ; set x position
        sta     $0400,y
        lda     $22
        sta     $0341,y                 ; set y position
        lda     $24
        sta     $0401,y
        lda     $7800,y                 ; get pointer to high sprite data
        tax
        lda     $1f                     ; branch if x position is > 255
        lsr
        bcs     :+
        lda     $0504,x                 ; clear high bit of x position
        and     $7900,y
        sta     $0504,x
        lda     $0510,x
        and     $7900,y
        sta     $0510,x
        bra     :++
:       lda     $0504,x                 ; set high bit of x position
        and     $7900,y
        ora     $7a00,y
        sta     $0504,x
        lda     $0510,x
        and     $7900,y
        ora     $7a00,y
        sta     $0510,x
:       jmp     DrawNextObj

; high priority
HighPriority:
        longa
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
        bcs     :+
        lda     $0500,x
        and     $7900,y
        sta     $0500,x
        lda     $0502,x
        and     $7900,y
        sta     $0502,x
        bra     :++
:       lda     $0500,x
        and     $7900,y
        ora     $7a00,y
        sta     $0500,x
        lda     $0502,x
        and     $7900,y
        ora     $7a00,y
        sta     $0502,x
:       jmp     DrawNextObj

; low priority
LowPriority:
        longa
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
        bcs     :+
        lda     $051c,x
        and     $7900,y
        sta     $051c,x
        lda     $051e,x
        and     $7900,y
        sta     $051e,x
        bra     :++
:       lda     $051c,x
        and     $7900,y
        ora     $7a00,y
        sta     $051c,x
        lda     $051e,x
        and     $7900,y
        ora     $7a00,y
        sta     $051e,x
:       jmp     DrawNextObj
.endproc  ; DrawObjNoVehicle

; ------------------------------------------------------------------------------

; [ update object sprite data (magitek) ]

; uses 3 top and 3 bottom sprites

.proc DrawMagitek
        lda     $088f,y                 ; pointer to animation queue
        tax
        lda     f:ObjSpriteVRAMTbl,x    ; sprite vram location (rider)
        sta     $1a
        longa
        lda     $086a,y                 ; x-position
        sec
        sbc     $5c                     ; bg1 h-scroll
        sta     $1e                     ; $1e = left half x-position
        clc
        adc     #$0010
        sta     $20                     ; $20 = right half x-position
        lda     $086d,y                 ; y-position
        clc
        sbc     $60                     ; bg1 v-scroll
        sec
        sbc     $7f                     ; vertical offset for shake screen
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
        jne     DrawNextObj             ; branch if sprite is on screen
        clr_a
        ldy     $1e
        cpy     #$0120
        bcc     :+
        cpy     #$ffe0
        jcc     DrawNextObj
:       longa
        lda     $d4                     ; pointer to normal priority sprite
        sec
        sbc     #12                     ; use 3 sprites (3 top and 3 bottom)
        sta     $d4
        shorta0
        ldy     $d4
        longa
        lda     $1e                     ; left half + 8 to get rider x-position
        clc
        adc     #8
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y                 ; x-position
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $1e                     ; left half of vehicle (top)
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y                 ; y-position
        jsr     SetTopSpriteMSB
        iny4
        longa
        lda     $20                     ; right half of vehicle (top)
        sta     $2a
        shorta0
        lda     $2a
        sta     $0340,y
        jsr     SetTopSpriteMSB
        ldy     $d4
        longa
        lda     $1e
        sta     $2a                     ; left half of vehicle (bottom)
        shorta0
        lda     $2a
        sta     $0400,y
        jsr     SetBtmSpriteMSB
        iny4
        longa
        lda     $20
        sta     $2a                     ; right half of vehicle (bottom)
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
        ldy     $da                     ; pointer to current object data
        lda     $087f,y                 ; facing direction
        cmp     #$01
        beq     :+                      ; branch if facing right
        lda     $0881,y
        and     #$0e
        ora     #$20
        bra     :++
:       lda     $0881,y
        and     #$0e
        ora     #$60                    ; flip horizontally
:       ldy     $d4
        sta     $0343,y
        lda     $1a
        sta     $0342,y
        ldy     $da
        lda     $087f,y
        asl3
        sta     $1a
        ldx     $0871,y                 ; horizontal movement speed
        beq     :+                      ; branch if not moving horizontally
        lda     $086a,y                 ; x-position
        bra     :++
:       lda     $086d,y                 ; y-position
:       lsr2
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
        bmi     :+                      ; branch if rider is shown
        ldy     $d4
        lda     #$ef
        sta     $0341,y                 ; hide rider sprite
:       jmp     DrawNextObj
.endproc  ; DrawMagitek

; ------------------------------------------------------------------------------

; magitek tile formation (top left)
MagitekTopLeftTiles:
        .word   $2fac,$2fc0,$2fac,$2fc4
        .word   $6fca,$6fe2,$6fca,$6fea
        .word   $2fa0,$2fa4,$2fa0,$2fa8
        .word   $2fc8,$2fe0,$2fc8,$2fe8

; magitek tile formation (top right)
MagitekTopRightTiles:
        .word   $6fac,$6fc4,$6fac,$6fc0
        .word   $6fc8,$6fe0,$6fc8,$6fe8
        .word   $6fa0,$6fa8,$6fa0,$6fa4
        .word   $2fca,$2fe2,$2fca,$2fea

; magitek tile formation (bottom left)
MagitekBtmLeftTiles:
        .word   $2fae,$2fc2,$2fae,$2fc6
        .word   $6fce,$6fe6,$6fce,$6fee
        .word   $2fa2,$2fa6,$2fa2,$2faa
        .word   $2fcc,$2fe4,$2fcc,$2fec

; magitek tile formation (bottom right)
MagitekBtmRightTiles:
        .word   $6fae,$6fc6,$6fae,$6fc2
        .word   $6fcc,$6fe4,$6fcc,$6fec
        .word   $6fa2,$6faa,$6fa2,$6fa6
        .word   $2fce,$2fe6,$2fce,$2fee

; ------------------------------------------------------------------------------

; [ update object sprite data (raft) ]

; uses 3 top and 3 bottom sprites

.proc DrawRaft
        lda     $088f,y
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
        clr_a
        ldy     $1e
        cpy     #$0120
        bcc     :+
        cpy     #$ffe0
        jcc     DrawNextObj
:       longa
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
        beq     :+
        lda     $0881,y
        and     #$0e
        ora     #$20
        bra     :++
:       lda     $0881,y
        and     #$0e
        ora     #$60
:       ldy     $d4
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
        bmi     :+
        ldy     $d4
        lda     #$ef
        sta     $0341,y
        sta     $0345,y
:       jmp     DrawNextObj
.endproc  ; DrawRaft

; ------------------------------------------------------------------------------

RaftTiles:
        .word   $2f20,$2f28,$2f20,$2f28
        .word   $2f24,$2f2c,$2f24,$2f2c
        .word   $2f22,$2f2a,$2f22,$2f2a
        .word   $2f26,$2f2e,$2f26,$2f2e

; ------------------------------------------------------------------------------

; [ update object sprite data (chocobo) ]

; uses 3 top and 3 bottom sprites

.proc DrawChoco
        lda     $088f,y
        tax
        lda     f:ObjSpriteVRAMTbl,x
        sta     $1a
        inc2
        sta     $1c
        ldx     $0871,y
        beq     :+
        lda     $086a,y
        bra     :++
:       lda     $086d,y
:       lsr2
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
        clr_a
        ldy     $1e
        cpy     #$0120
        bcc     :+
        cpy     #$ffe0
        jcc     DrawNextObj
:       longa
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
.endproc  ; DrawChoco

; chocobo facing up
.proc DrawChocoUp
        ldy     $1e
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
        clr_a
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
        bmi     :+
        ldy     $d4
        lda     #$ef
        sta     $0345,y
:       jmp     DoneChoco
.endproc  ; DrawChocoUp

; ------------------------------------------------------------------------------

ChocoUpTailX:
        .addr   0,1,0,-1                ; tail x-offset

ChocoUpTailY:
        .word   9,10,9,10               ; tail y-offset

ChocoUpBodyX:
        .word   0,1,0,1                 ; body y-offset

ChocoUpTailTile:
        .word   $2f4a,$6f4a,$2f4a,$6f4a ; tail tile

ChocoUpTileFlags:
        .word   $2000,$2000,$2000,$2000 ; unused

ChocoUpBodyTile1:
        .word   $2f4c,$2f60,$2f4c,$6f60 ; body tile (top)

ChocoUpBodyTile2:
        .word   $2f4e,$2f62,$2f4e,$6f62 ; body tile (bottom)

; ------------------------------------------------------------------------------

; chocobo facing down
.proc DrawChocoDown
        ldy     $1e
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
        clr_a
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
        bmi     :+
        ldy     $d4
        lda     #$ef
        sta     $0345,y
:       jmp     DoneChoco

ChocoDownHeadX:
        .addr   0,1,0,-1                ; head x-offset

ChocoDownHeadY:
        .addr   7,8,7,8                 ; head y-offset

ChocoBodyHeadX:
        .addr   -1,1,-1,1               ; body y-offset

ChocoDownHeadTile:
        .word   $2f40,$2f40,$2f40,$2f40 ; head tile

ChocoDownTileFlags:
        .word   $2000,$2000,$2000,$2000 ; tile flags

ChocoDownBodyTopTile:
        .word   $2f42,$2f46,$2f42,$6f46 ; body tile (top)

ChocoDownBodyBtmTile:
        .word   $2f44,$2f48,$2f44,$6f48 ; body tile (bottom)

.endproc  ; DrawChocoDown

; ------------------------------------------------------------------------------

; chocobo facing right
.proc DrawChocoRight
        ldy     $d4
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
        adc     f:ChocoRightYTbl,x
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
        bmi     :+
        ldy     $d4
        lda     #$ef
        sta     $0341,y
        sta     $0345,y
:       jmp     DoneChoco

ChocoRightYTbl:
        .addr   0,-1,0,-1               ; y-offset

ChocoRightTopLeftTiles:
        .word   $6f64,$6f6c,$6f64,$6f84

ChocoRightTopRightTiles:
        .word   $6f68,$6f80,$6f68,$6f88

ChocoRightBtmLeftTiles:
        .word   $6f66,$6f6e,$6f66,$6f86

ChocoRightBtmRightTiles:
        .word   $6f6a,$6f82,$6f6a,$6f8a

.endproc  ; DrawChocoRight

; ------------------------------------------------------------------------------

; chocobo facing left
.proc DrawChocoLeft
        ldy     $d4
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
        adc     f:ChocoLeftYTbl,x
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
        bmi     DoneChoco
        ldy     $d4
        lda     #$ef
        sta     $0341,y
        sta     $0345,y

::DoneChoco:
        jmp     DrawNextObj

ChocoLeftYTbl := ::DrawChocoRight::ChocoRightYTbl

ChocoLeftTopLeftTiles:
        .word   $2f64,$2f6c,$2f64,$2f84

ChocoLeftTopRightTiles:
        .word   $2f68,$2f80,$2f68,$2f88

ChocoLeftBtmLeftTiles:
        .word   $2f66,$2f6e,$2f66,$2f86

ChocoLeftBtmRightTiles:
        .word   $2f6a,$2f82,$2f6a,$2f8a

; unused ???
        .word   $0000,$0010,$0020,$0030

.endproc  ; DrawChocoLeft

; ------------------------------------------------------------------------------

; [ update object sprite data (special graphics) ]

.proc DrawObjSpecial
        ldx     $00
        stx     $24
        stx     $20
        lda     $087c,y                 ; check if object scrolls with bg2
        sta     $1a
        phy                             ; push object pointer so we can temporarily use a master object
        lda     $088b,y                 ; branch if a master object is used
        and     #$02
        beq     ShiftRight

; w/ master object - shift sprite right (tiles)
ShiftRightSlave:
        lda     $088b,y
        and     #$01
        bne     ShiftDownSlave
        lda     $088a,y
        and     #$e0
        lsr
        sta     $20
        bra     :+

; w/ master object - shift sprite down (tiles)
ShiftDownSlave:
        lda     $088a,y
        and     #$e0
        lsr
        sta     $24

:       lda     $088a,y                 ; master object number
        and     #$1f
        clc
        adc     #$10                    ; add $10 to get npc number
        asl
        tax
        ldy     $0799,x                 ; get pointer to master object data
        bra     :+

; shift sprite right (pixels * 2)
ShiftRight:
        lda     $088b,y
        and     #$01
        bne     ShiftDown
        lda     $088a,y
        and     #$e0
        lsr4
        sta     $20
        bra     :+

; shift sprite down (pixels * 2)
ShiftDown:
        lda     $088a,y
        and     #$e0
        lsr4
        sta     $24
:       lda     $1a
        bmi     ScrollWithBG2           ; branch if object scrolls with bg2

; object scrolls with bg1
        longa_clc
        lda     $086d,y                 ; y position
        adc     $24                     ; add add y offset
        clc
        sbc     $60                     ; subtract vertical scroll position
        sec
        sbc     $7f                     ; subtract shake screen offset
        sec
        sbc     $086f,y                 ; subtract jump offset
        sec
        sbc     #$0008                  ; subtract 8
        sta     $22                     ; +$22 = top sprite y offset
        clc
        adc     #$0020
        sta     $26                     ; +$26 = bottom sprite y offset
        lda     $086a,y                 ; x position
        sec
        sbc     $5c                     ; subtract horizontal scroll position
        clc
        adc     $20                     ; add x offset
        clc
        adc     #$0008                  ; add 8
        sta     $1e                     ; +$1e = sprite x position
        shorta0
        bra     :+

; object scrolls with bg2
ScrollWithBG2:
        longa_clc
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

:       ply                             ; no longer using master object
        ldx     $1e
        cpx     #$ffe0                  ; return if sprite is off-screen
        bcs     :+
        cpx     #$0100
        jcs     DrawNextObj
:       lda     $27
        jne     DrawNextObj
        clr_a
        lda     $0868,y                 ; continuous animation flag -> horizontal flip ???
        and     #$01
        lsr
        ror2
        ora     #$01
        ora     $0880,y
        sta     $1b
        lda     $0868,y                 ; animation speed (this will always be 0)
        and     #$60
        lsr5
        tax
        lda     $45                     ; frame counter / 4
        lsr2
:       cpx     #0                      ; divide by 2 (slower animation) for higher speed values
        beq     :+
        lsr
        dex
        bra     :-
:       sta     $1a                     ; $1a = frame counter >> (2 + speed)
        lda     $088c,y                 ;
        and     #$18
        lsr3
        tax
        lda     $1a
        and     f:ObjAnimFrameMaskTbl,x ; number of frames mask
        asl
        sta     $1a                     ; $1a = frames mask * 2
        lda     $087c,y                 ; 32x32 sprite
        and     #$20
        beq     :+
        asl     $1a
:       lda     $0889,y                 ; vram address
        asl
        clc
        adc     $1a
        sta     $1a
        tyx
        lda     $088c,y                 ; sprite order
        and     #$c0
        beq     NormalPriority
        cmp     #$40
        jeq     HighPriority
        jmp     LowPriority

; normal sprite priority
NormalPriority:
        longa
        lda     $d4                     ; use one sprite
        sec
        sbc     #4
        sta     $d4
        tay
        lda     $1a
        sta     $0342,y
        shorta0
        lda     $087c,x                 ; branch if not a 32x32 sprite
        and     #$20
        beq     :+
        lda     $7a00,y                 ; sprite high data bit mask
        asl                             ; << 1 to get the large sprite flag
:       sta     $1c
        lda     $1e
        sta     $0340,y                 ; set x position
        lda     $22
        sta     $0341,y                 ; set y position
        lda     $7800,y                 ; pointer to high sprite data
        tax
        lda     $1f
        lsr
        bcs     :+                      ; branch if x > 255
        lda     $0504,x
        and     $7900,y                 ; clear high x position msb
        ora     $1c                     ; 32x32 flag
        sta     $0504,x
        bra     :++
:       lda     $0504,x
        and     $7900,y
        ora     $7a00,y                 ; set high x position msb
        ora     $1c                     ; 32x32 flag
        sta     $0504,x
:       jmp     DrawNextObj

; high sprite priority
HighPriority:
        longa
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
        beq     :+
        lda     $7a00,y
        asl
:       sta     $1c
        lda     $1e
        sta     $0300,y
        lda     $22
        sta     $0301,y
        lda     $7800,y
        tax
        lda     $1f
        lsr
        bcs     :+
        lda     $0500,x
        and     $7900,y
        ora     $1c
        sta     $0500,x
        bra     :++
:       lda     $0500,x
        and     $7900,y
        ora     $7a00,y
        ora     $1c
        sta     $0500,x
:       jmp     DrawNextObj

; low sprite priority
LowPriority:
        longa
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
        beq     :+
        lda     $7a00,y
        asl
:       sta     $1c
        lda     $1e
        sta     $04c0,y
        lda     $22
        sta     $04c1,y
        lda     $7800,y
        tax
        lda     $1f
        lsr
        bcs     :+
        lda     $051c,x
        and     $7900,y
        ora     $1c
        sta     $051c,x
        bra     :++
:       lda     $051c,x
        and     $7900,y
        ora     $7a00,y
        ora     $1c
        sta     $051c,x
:       jmp     DrawNextObj
.endproc  ; DrawObjSpecial

; ------------------------------------------------------------------------------

; bit masks for number of animation frames (animated frame type)
ObjAnimFrameMaskTbl:
        .byte   %00,%00,%01,%11

; ------------------------------------------------------------------------------

; [ set/clear sprite x position msb (top sprite) ]

; $2b: 0 (clear) or 1 (set)

.proc SetTopSpriteMSB
        pha
        phx
        phy
        lda     $2b
        lsr
        bcs     :+
        lda     $7800,y
        tax
        lda     $0504,x
        and     $7900,y
        sta     $0504,x
        bra     :++
:       lda     $7800,y
        tax
        lda     $0504,x
        and     $7900,y
        ora     $7a00,y
        sta     $0504,x
:       ply
        plx
        pla
        rts
.endproc  ; SetTopSpriteMSB

; ------------------------------------------------------------------------------

; [ set/clear sprite x position msb (bottom sprite) ]

; $2b: 0 (clear) or 1 (set)

.proc SetBtmSpriteMSB
        pha
        phx
        phy
        lda     $2b
        lsr
        bcs     :+
        lda     $7800,y
        tax
        lda     $0510,x
        and     $7900,y
        sta     $0510,x
        bra     :++
:       lda     $7800,y
        tax
        lda     $0510,x
        and     $7900,y
        ora     $7a00,y
        sta     $0510,x
:       ply
        plx
        pla
        rts
.endproc  ; SetBtmSpriteMSB

; ------------------------------------------------------------------------------

; first object to update each frame
FirstObjTbl1:
        .byte   $00,$0c,$18,$24

; ------------------------------------------------------------------------------

; [ transfer object graphics to vram ]

; only six objects get updated per frame
; called during nmi, takes four frames to fully update
; called four times in a row when a map loads

.proc TfrObjGfxSub
        stz     hHDMAEN
        lda     #$41
        sta     hDMA0::CTRL
        lda     #$80
        sta     hVMAINC
        lda     #<hVMDATAL
        sta     hDMA0::HREG
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
        lda     f:FirstObjTbl3,x
        sta     $14
        lda     #$0006
        sta     $18
Loop:   stz     hMDMAEN
        ldx     $48
        ldy     $10f7,x
        cpy     #$07b0
        jeq     Skip
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
        ldy     #BIT_0
        lda     f:MapSpriteTileOffsets,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+2,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+8,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+10,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     $16
        sta     hVMADDL
        lda     f:MapSpriteTileOffsets+4,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+6,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
Skip:   inc     $14
        inc     $14
        inc     $48
        inc     $48
        dec     $18
        jne     Loop
        shorta0
        rts
.endproc  ; TfrObjGfxSub

; ------------------------------------------------------------------------------

; [ load character graphics (world map) ]

.proc TfrObjGfxWorld
        stz     hHDMAEN
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
        sta     hDMA0::CTRL
        lda     #$80
        sta     hVMAINC
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        longa
        ldx     $12
        ldy     #BIT_0
        lda     f:MapSpriteTileOffsets,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+2,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+4,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+6,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+8,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        lda     f:MapSpriteTileOffsets+10,x
        clc
        adc     $0e
        sta     hDMA0::ADDR
        clr_a
        adc     $10
        sta     hDMA0::ADDR_B
        sty     hMDMAEN
        shorta0
        rts
.endproc  ; TfrObjGfxWorld

; ------------------------------------------------------------------------------

; unused
_c06934:
        .word   $0000,$00f6,$01ec,$02e2

FirstObjTbl3:
        .word   $0000,$000c,$0018,$0024

; vram address for object graphics
_c06944:
        .word   $6000,$6040,$6080,$60c0,$6200,$6240
        .word   $6280,$62c0,$6400,$6440,$6480,$64c0
        .word   $6600,$6640,$6680,$66c0,$6800,$6840
        .word   $6880,$68c0,$6a00,$6a40,$6a80,$6ac0

; ------------------------------------------------------------------------------

; [ init terra outline graphics (unused) ]

.proc InitTerraOutline
        ldx     $00
        txa
:       sta     $7e6000,x
        inx
        cpx     #$6c00
        bne     :-
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
Loop:   longa
        ldx     $20
        lda     f:MapSpriteTileOffsets+12,x
        sta     $24
        shorta0
        lda     #$08
        sta     $1a
:       ldy     $24
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
        bne     :-
        longa_clc
        lda     $22
        adc     #$0010
        sta     $22
        shorta0
        ldx     $20
        inx2
        stx     $20
        cpx     #$006c
        bne     Loop
        rts
.endproc  ; InitTerraOutline

; ------------------------------------------------------------------------------

; [ update timer sprite data ]

.proc DrawTimer
        lda     $1188                   ; return if timer is disabled
        and     #$40
        bne     :+
        rts
:       ldx     $1189                   ; timer value
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

; timer graphics pointers (+$0100, vram)
TimerTiles:
        .byte   $60,$62,$64,$66,$68,$6a,$6c,$6e,$80,$82

.endproc  ; DrawTimer

; ------------------------------------------------------------------------------

; [ load timer graphics ]

.proc LoadTimerGfx

        .if ::LANG_EN
                DigitGfx := SmallFontGfx+$0b40
                ColonGfx := SmallFontGfx+$0c10
        .else
                DigitGfx := SmallFontGfx+$0530
                ColonGfx := SmallFontGfx+$0cf0
        .endif

        lda     $0521
        bmi     :+
        rts
:       lda     #$80
        sta     hVMAINC
        ldx     #$7600
        stx     hVMADDL
        ldx     $00
Loop1:  .repeat 8, i
        lda     f:DigitGfx+i*2,x
        eor     f:DigitGfx+i*2+1,x
        sta     hVMDATAL
        lda     f:DigitGfx+i*2+1,x
        sta     hVMDATAH
        .endrep
        ldy     #$0018
:       stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     :-
        longa_clc
        txa
        adc     #$0010
        tax
        shorta0
        cpx     #$0080
        jne     Loop1
        ldy     #$0100
:       stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     :-
Loop2:  .repeat 8, i
        lda     f:DigitGfx+i*2,x
        eor     f:DigitGfx+i*2+1,x
        sta     hVMDATAL
        lda     f:DigitGfx+i*2+1,x
        sta     hVMDATAH
        .endrep
        ldy     #$0018
:       stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     :-
        longa_clc
        txa
        adc     #$0010
        tax
        shorta0
        cpx     #$00a0
        jne     Loop2
        .repeat 8, i
        lda     f:ColonGfx+i*2
        eor     f:ColonGfx+i*2+1
        sta     hVMDATAL
        lda     f:ColonGfx+i*2+1
        sta     hVMDATAH
        .endrep
        ldy     #$01a0
:       stz     hVMDATAL
        stz     hVMDATAH
        dey
        bne     :-
        rts
.endproc  ; LoadTimerGfx

; ------------------------------------------------------------------------------

; [ update party equipment effects ]

.proc UpdateEquip
        stz     $11df                   ; clear equipment effects
        ldy     $00
        stz     $1b
Loop:   lda     $0867,y                 ; check if character is enabled
        and     #$40
        beq     :+
        lda     $0867,y                 ; check if character is in current party
        and     #$07
        cmp     $1a6d
        bne     :+
        phy
        lda     $1b
        jsl     UpdateEquip_ext
        clr_a
        ply
:       longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inc     $1b
        cpy     #$0290
        bne     Loop
        rts
.endproc  ; UpdateEquip

; ------------------------------------------------------------------------------

; [ update party switching ]

.proc CheckChangeParty
        lda     $1eb9                   ; return if party switching is disabled
        and     #$40
        beq     Done
        lda     a:$0084                 ; return if map is loading
        bne     Done
        lda     $055e                   ; return if there was a party collision
        bne     Done
        ldx     $e5                     ; return if running an event
        cpx     #.loword(EventScript_NoEvent)
        bne     Done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     Done
        ldy     $0803                   ; party object
        lda     $0869,y                 ; return if between tiles
        bne     Done
        lda     $086a,y
        and     #$0f
        bne     Done
        lda     $086c,y
        bne     Done
        lda     $086d,y
        and     #$0f
        bne     Done
        lda     $07                     ; branch if y button is down
        and     #$40
        bne     :+
        lda     #$01                    ; enable party switching and return
        sta     $0762
        bra     Done
:       lda     $0762                   ; y button, check party switching
        beq     Done
        stz     $0762                   ; if so, switch party
        bra     ChangeParty
Done:   rts
.endproc  ; CheckChangeParty

; ------------------------------------------------------------------------------

; [ switch parties ]

.proc ChangeParty
        lda     $1a6d                   ; party number
        tay
        lda     $b2                     ; save party z-level
        sta     $1ff3,y
        lda     $1a6d                   ; increment party number
        inc
        cmp     #4                      ; only switch between first 3 parties
        bne     :+
        lda     #1
:       sta     $1a6d
        lda     #$20                    ; look for top character in new party
        sta     $1a
        ldy     #$07d9
        sty     $07fb
        ldy     $00
Loop:   lda     $0867,y
        and     #$40
        cmp     #$40
        bne     :+
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     :+
        lda     $0867,y
        and     #$18
        cmp     $1a
        bcs     :+
        sta     $1a
        sty     $07fb                   ; set the showing character
:       longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     Loop

; if no characters were found, increment the party and try again
        ldy     $07fb
        cpy     #$07d9
        beq     ChangeParty
        ldy     $07fb

; return if the new showing character was already the party object
        cpy     $0803
        beq     Done
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
        bne     DifferentMap

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
Done:   rts

; new party is on a different map
DifferentMap:
        lda     #$80                    ; enable map startup event
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
        clr_a
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
.endproc  ; ChangeParty

; ------------------------------------------------------------------------------

; [ save map and position for character objects ]

.proc PushPartyMap
        ldx     $00
        txy
Loop:   longa_clc
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
        bne     Loop
        rts
.endproc  ; PushPartyMap

; ------------------------------------------------------------------------------

; [ restore map index for character objects ]

.proc PopPartyMap
        ldx     $00
        txy
Loop:   longa_clc
        lda     $1f81,y                 ; object map index
        sta     $088d,x
        txa
        adc     #$0029
        tax
        shorta0
        iny2                            ; loop through 16 characters
        cpy     #$0020
        bne     Loop
        rts
.endproc  ; PopPartyMap

; ------------------------------------------------------------------------------

; [ restore character positions ]

.proc PopPartyPos
        ldx     $00
        txy
Loop:   clr_a
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
        bne     Loop
        rts
.endproc  ; PopPartyPos

; ------------------------------------------------------------------------------

; [ save character palettes ]

.proc PushPartyPal
        ldx     $00
        txy
Loop:   lda     $0880,x
        and     #$0e
        sta     $1f70,y
        longa_clc
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010
        bne     Loop
        rts
.endproc  ; PushPartyPal

; ------------------------------------------------------------------------------

; [ restore character palettes ]

.proc PopPartyPal
        ldx     $00
        txy
Loop:   lda     $0880,x                 ; restore character palettes
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
        bne     Loop
        rts
.endproc  ; PopPartyPal

; ------------------------------------------------------------------------------

; [ update party objects ]

; called via event command $47, after the party select menu, and when a
; map is loaded

.proc GetTopChar
        ldy     $0803                   ; save previous top char
        sty     $1e
        ldx     $086a,y                 ; x position
        stx     $26
        ldx     $086d,y                 ; y position
        stx     $28
        lda     #$20                    ; dummy value for topmost party slot
        sta     $1a

; loop through 16 characters
        ldx     $00
        txy
Loop:   lda     $1850,y
        and     #$07
        cmp     $1a6d
        bne     Skip                    ; skip if not in active party
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
        lda     $1850,y                 ; check if this was the top character
        and     #$18
        cmp     $1a
        bcs     Skip
        sta     $1a
        stx     $07fb                   ; set top character in active party
Skip:   longa_clc
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010
        bne     Loop

; make top char visible
        ldx     $07fb
        lda     $0867,x
        ora     #$80
        sta     $0867,x

; return if top char didn't change
        cpx     $1e
        jeq     Done
        ldy     $1e
        longa
        lda     $087a,y                 ; copy obj properties from prev top char
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
Done:   ldy     #$07d9
        sty     $07fd                   ; hide slots 2, 3, 4
        sty     $07ff
        sty     $0801
        lda     #1
        sta     $0798                   ; validate and sort active objects
        rts
.endproc  ; GetTopChar

; ------------------------------------------------------------------------------

; [ restore character data ]

.proc PopCharFlags
        ldx     $00
        txy
Loop:   lda     $1850,y
        sta     $0867,x
        longa_clc
        txa
        adc     #$0029
        tax
        shorta0
        iny
        cpy     #$0010                  ; loop through 16 characters
        bne     Loop
        rts
.endproc  ; PopCharFlags

; ------------------------------------------------------------------------------

; [ save character data ]

.proc PushCharFlags
        ldx     $00
        txy
Loop:   lda     $0867,x
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
        bne     Loop
        rts
.endproc  ; PushCharFlags

; ------------------------------------------------------------------------------

; [ calculate object data pointers ]

.proc CalcObjPtrs
        lda     #$29                    ; object data is 41 bytes each
        sta     hWRMPYA
        ldx     $00
Loop:   txa
        lsr
        sta     hWRMPYB
        nop3
        longa
        lda     hRDMPYL
        sta     $0799,x                 ; store pointer
        shorta0
        inx2
        cpx     #$0062                  ; $31 objects total
        bne     Loop
        rts
.endproc  ; CalcObjPtrs

; ------------------------------------------------------------------------------

; [ get pointer to first valid character ]

; y: pointer to object data

.proc GetTopCharPtr
        cpy     $07fb
        bne     :+                      ; branch if not party character 0
        ldy     #$07d9
        sty     $07fb                   ; clear all party character slots
        sty     $07fd
        sty     $07ff
        sty     $0801
        bra     Done
:       cpy     $07fd                   ; branch if not party character 1
        bne     :+
        ldy     #$07d9
        sty     $07fd                   ; clear party character slots 1-3
        sty     $07ff
        sty     $0801
        bra     Done
:       cpy     $07ff                   ; branch if not party character 2
        bne     :+
        ldy     #$07d9
        sty     $07ff                   ; clear party character slots 2-3
        sty     $0801
        bra     Done
:       cpy     $0801                   ; branch if not party character 3
        bne     Done
        ldy     #$07d9
        sty     $0801                   ; clear party character slot 3
Done:   rts
.endproc  ; GetTopCharPtr

; ------------------------------------------------------------------------------

; [ unused ]

.proc _c0711d
        ldy     $00
Loop:   lda     $0867,y
        and     #$40
        beq     :+
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     :+
        longa
        lda     $82
        sta     $088d,y
        shorta0
:       longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     Loop
        rts
.endproc  ; _c0711d

; ------------------------------------------------------------------------------

; [ validate and sort active objects ]

; This routine generates the list of object pointers at $0803-$0866, which
; determines the order in which objects will be updated. The first object in
; the list (the player object at $0803) is always the first character in
; the active party. Next come the other characters in the active party. The
; camera object always comes next, followed by all characters that are in
; other parties (but not including NPC characters). Finally, the NPCs from
; the map come at the end of the list. Note that if there are no characters
; in the active party, then the camera object acts as the player object.

.proc _c0714a
sort_obj_work:
        ldx     #$0803
        stx     hWMADDL
        lda     #$00
        sta     hWMADDH
        stz     $1b

; char slot 1
CheckSlot1:
        ldy     $07fb
        cpy     #$07d9
        beq     CheckSlot2
        lda     $0867,y
        and     #$40
        bne     :+                      ; branch if enabled
        ldy     #$07d9
        sty     $07fb                   ; hide the party object
        sty     $07fd
        sty     $07ff
        sty     $0801
        jmp     CheckOtherSlots
:       lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     CheckSlot2
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
CheckSlot2:
        ldy     $07fd
        cpy     #$07d9
        beq     CheckSlot3
        lda     $0867,y
        and     #$40
        bne     :+
        ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        jmp     CheckOtherSlots
:       lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     CheckSlot3
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
CheckSlot3:
        ldy     $07ff
        cpy     #$07d9
        beq     CheckSlot4
        lda     $0867,y
        and     #$40
        bne     :+
        ldy     #$07d9
        sty     $07ff
        sty     $0801
        bra     CheckOtherSlots
:       lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     CheckSlot4
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
CheckSlot4:
        ldy     $0801
        cpy     #$07d9
        beq     CheckOtherSlots
        lda     $0867,y
        and     #$40
        bne     :+
        ldy     #$07d9
        sty     $0801
        bra     CheckOtherSlots
:       lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     CheckOtherSlots
        lda     $82
        sta     $088d,y
        lda     $83
        sta     $088e,y
        lda     $0801
        sta     hWMDATA
        lda     $0802
        sta     hWMDATA
        inc     $1b

; other characters in the active party
CheckOtherSlots:
        ldx     $00
Loop:   ldy     $0799,x                 ; loop through all character objects
        cpy     $07fb
        beq     Skip                    ; skip if already in the list
        cpy     $07fd
        beq     Skip
        cpy     $07ff
        beq     Skip
        cpy     $0801
        beq     Skip
        lda     $0867,y
        and     #$40
        beq     Skip
        lda     $0867,y
        and     #$07
        cmp     $1a6d                   ; skip if not in the active party
        bne     Skip
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
Skip:   inx2
        cpx     #$0020
        bne     Loop

; camera object
        lda     #$b0
        sta     hWMDATA
        lda     #$07
        sta     hWMDATA
        inc     $1b

; characters not in the active party
        ldx     $00
Loop2:  ldy     $0799,x
        lda     $0867,y
        and     #$40
        beq     Skip2
        lda     $0867,y
        and     #$07
        beq     :+
        cmp     $1a6d
        beq     Skip2                   ; skip if in the active party
        phx
        ldx     $088d,y
        txy
        plx
        cpy     $82
        bne     Skip2
:       lda     $0799,x
        sta     hWMDATA
        lda     $079a,x
        sta     hWMDATA
        inc     $1b
Skip2:  inx2
        cpx     #$0020
        bne     Loop2

; npc objects
        ldx     #$0020
Loop3:  ldy     $0799,x
        lda     $0867,y
        and     #$40
        beq     :+
        lda     $0799,x
        sta     hWMDATA
        lda     $079a,x
        sta     hWMDATA
        inc     $1b
:       inx2
        cpx     #$0060
        bne     Loop3

; update the total number of active objects
        lda     $1b
        asl
        sta     $dd
        stz     $0798
        rts
.endproc  ; _c0714a

; ------------------------------------------------------------------------------

; starting object to update each frame * 2
FirstObjTbl2:
        .byte   $00,$0c,$18,$24

; ------------------------------------------------------------------------------

; [ detect object collisions ]

; Y: pointer to object data

.proc CheckCollosions
        lda     $59                     ; return if menu opening
        bne     Done
        lda     $087c,y                 ; return if not a collision object
        and     #$40
        beq     Done
        ldx     $e5                     ; return if an event is running
        cpx     #.loword(EventScript_NoEvent)
        bne     Done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     Done
        lda     $84                     ; return if a map is loading
        bne     Done
        lda     $055e                   ;
        bne     Done
        cpy     #$0290                  ; return if the object is a character
        bcs     :+
Done:   rts
:       lda     $087a,y                 ; pointer to object map data
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
        bcc     DoCollision
        inc     $1b
        lda     ($20)
        cmp     #$20
        bcc     DoCollision
        inc     $1b
        lda     ($22)
        cmp     #$20
        bcc     DoCollision
        inc     $1b
        lda     ($24)
        cmp     #$20
        bcc     DoCollision
        clr_a
        pha
        plb
        rts

; do collision event
DoCollision:
        sta     $1a
        clr_a
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
.endproc  ; CheckCollosions

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
        clr_a
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
        lda     #6
        sta     $de

ObjActionLoop:
@7587:  clr_a                           ; start of loop
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
        clr_a
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
        clr_a
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
@78ab:  clr_a
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
        clr_a
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
        clr_a
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
        clr_a
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
@7b70:  clr_a
        sta     $0885,y                 ; clear script pointer (bank byte)
        lda     $087c,y
        and     #$f0
        sta     $087c,y                 ; clear movement type
        longa
        clr_a
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
@7c1f:  clr_a
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

; X: bg1 tile index

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
        clr_a
        rts

; ------------------------------------------------------------------------------

; [ get pointer to object map data in facing direction ]

;    A: facing direction + 1
; +$1e: pointer to object map data in facing direction (out)

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
        .lobytes 0,0,1,0,-1

AdjacentYTbl:
        .lobytes 0,-1,0,1,0

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
