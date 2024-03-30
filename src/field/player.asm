
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: player.asm                                                           |
; |                                                                            |
; | description: player/party routines                                         |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

.include "field/treasure_prop.inc"

.import EventScript_NoEvent
.import EventScript_TreasureItem, EventScript_TreasureMagic
.import EventScript_TreasureGil, EventScript_TreasureEmpty
.import EventScript_TreasureMonster

.a8
.i16
.segment "field_code"

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
        cpx     #.loword(EventScript_NoEvent)
        bne     @472b
        lda     $e7
        cmp     #^EventScript_NoEvent
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
        adc     #^EventScript
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
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
        cmp     #ITEM_TINTINABAR
        beq     @4a7a
        lda     $1624,y
        cmp     #ITEM_TINTINABAR
        bne     @4a93
@4a7a:  jsr     CalcMaxHP
        lda     $161c,y
        lsr2
        longa_clc
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
@4acb:  longa_clc                       ; next character
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        jne     @4a54
        plx
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
        cpy     #.loword(EventScript_NoEvent)
        bne     @4bd3
        lda     $e7
        cmp     #^EventScript_NoEvent
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
        lda     f:TreasurePropPtrs+2,x   ; pointer to treasure data
        sta     $1e
        lda     f:TreasurePropPtrs,x
        tax
        shorta0
        cpx     $1e
        beq     @4bd3
@4bec:  lda     f:TreasureProp,x   ; x position
        cmp     $2a
        bne     @4bfc
        lda     f:TreasureProp+1,x   ; y position
        cmp     $2b
        beq     @4c06
@4bfc:  inx5
        cpx     $1e
        bne     @4bec
        rts
@4c06:  longa
        lda     f:TreasureProp+4,x   ; treasure contents
        sta     $1a
        lda     f:TreasureProp+2,x   ; treasure event bit and type
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
        bpl     @4c80       ; branch if not gil

; gil
        lda     $1a
        sta     hWRMPYA
        lda     #100        ; multiply by 100
        sta     hWRMPYB
        nop3
        ldy     hRDMPYL
        sty     $22
        stz     $24
        longa_clc
        tya
        adc     $1860       ; add to gil
        sta     $1860
        shorta0
        adc     $1862
        sta     $1862
        cmp     #^9999999
        bcc     @4c78
        ldx     $1860
        cpx     #.loword(9999999)
        bcc     @4c78
        ldx     #.loword(9999999)      ; max 9,999,999 gil
        stx     $1860
        lda     #^9999999
        sta     $1862
@4c78:  jsr     HexToDec
        ldx     #.loword(EventScript_TreasureGil)
        bra     @4cac

; item
@4c80:  lda     $1f
        and     #$40
        beq     @4c93       ; branch if not an item
        lda     $1a
        sta     $0583
        jsr     GiveItem
        ldx     #.loword(EventScript_TreasureItem)
        bra     @4cac

; monster
@4c93:  lda     $1f
        and     #$20
        beq     @4ca3       ; branch if not a monster
        lda     $1a
        sta     $0789       ; set monster-in-a-box formation
        ldx     #.loword(EventScript_TreasureMonster)
        bra     @4cac

; empty
@4ca3:  lda     $1f
        and     #$10
        beq     @4ca9       ; <- this has no effect
@4ca9:  ldx     #.loword(EventScript_TreasureEmpty)

@4cac:  stx     $e5         ; set event pc
        stx     $05f4
        lda     #^EventScript_TreasureItem
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
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
@4d0c:  .byte   $01,$01
        .byte   $12

TreasureOffsetX:
@4d0f:  .byte   $00,$01,$00,$ff

TreasureOffsetY:
@4d13:  .byte   $ff,$00,$01,$00

.pushseg
.segment "treasure_prop"

; ed/82f4
TreasurePropPtrs:
        make_ptr_tbl_rel TreasureProp, TREASURE_PROP_ARRAY_LENGTH
        .addr TreasurePropEnd - TreasureProp

; ed/8634
TreasureProp:
        .incbin "trigger/treasure_prop.dat"
        TreasurePropEnd := *

.popseg

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
        longa_clc
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
        lda     f:_c04f8d,x   ; get pointer to tile number
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
        jne     _c07c69
        lda     $b8
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
        jne     _c07c69
        lda     $b3
        tax
        lda     f:_c04f8d,x
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
