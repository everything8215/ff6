
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: battle.asm                                                           |
; |                                                                            |
; | description: battle routines                                               |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ battle blur/sound ]

BattleMosaic:
@c0ef:  lda     $078a                   ; branch if battle sound effect is disabled
        and     #$40
        bne     @c0fb
        lda     #$c1                    ; play battle sound effect
        jsr     PlaySfx
@c0fb:  lda     $078a                   ; return if battle blur is disabled
        bmi     @c13d
        stz     $46                     ; clear frame counter
@c102:  jsr     WaitVblank
        lda     $46
        cmp     #$10
        bcs     @c10f
        and     #$07                    ; increase mosaic size from 0 to 7 twice
        bra     @c111
@c10f:  and     #$0f                    ; then increase from 0 to 15 once
@c111:  asl4
        ora     #$0f                    ; enable mosaic on all bg layers
        sta     $7e8233                 ; store in screen mosaic hdma table ($2106)
        sta     $7e8237
        sta     $7e823b
        sta     $7e823f
        sta     $7e8243
        sta     $7e8247
        sta     $7e824b
        sta     $7e824f
        lda     $46                     ; loop for $20 frames
        cmp     #$20
        bne     @c102
@c13d:  rts

; ------------------------------------------------------------------------------

; [ execute battle ]

ExecBattle:
@c13e:  jsr     BattleMosaic
        jsr     DisableInterrupts
        jsr     PushDP
        jsr     PushCharFlags
        ldx     $0803                   ; save pointer to party object data
        stx     $1fa6
        lda     $087f,x                 ; save facing direction
        sta     $1f68
        lda     $b2                     ; save z-level
        sta     $0744
        php
        phb
        phd
        jsl     Battle_ext
        pld
        plb
        plp
        jsr     DisableInterrupts
        jsr     PopDP
        jsr     PopCharFlags
        lda     #1                    ; re-load the same map
        sta     $58
        jsr     InitInterrupts
        rts

; ------------------------------------------------------------------------------

; [ update random battles (world map) ]

CheckBattleWorld:
@c176:  tdc
        jsr     PopDP
        lda     $1f64                   ; map index
        asl3
        sta     $1a
        lda     $11f9                   ; battle bg index
        and     #$07
        ora     $1a
        tax
        lda     f:WorldBattleBGTbl,x
        sta     f:$0011e2
        tdc
        sta     f:$0011e3
        txa
        and     #$07
        tax
        lda     f:BattleBGRateTbl,x
        sta     $22
        stz     $23
        lda     f:BattleBGGroupTbl,x
        sta     $20
        stz     $21
        lda     $1f64
        sta     $1f
        stz     $1e
        lda     $1f61
        and     #$e0
        sta     $1e
        lda     $1f60
        lsr3
        and     #$1c
        ora     $1e
        sta     $1e
        longa
        lda     $1e
        ora     $20
        tax
        shorta0
        lda     f:WorldBattleGroup,x               ; world battle groups
        sta     $24
        cmp     #$ff
        bne     @c1df                   ; branch if not a veldt sector
        lda     #$0f
        sta     f:$0011e4               ; set veldt flags
@c1df:  longa
        lda     $1e
        lsr2
        tax
        shorta0
        lda     f:WorldBattleRate,x     ; world battle rates
        ldy     $22
        beq     @c1f6
@c1f1:  lsr2
        dey
        bne     @c1f1
@c1f6:  and     #$03
        cmp     #$03
        beq     @c278
        sta     $1a
        lda     $11df
        and     #$03
        asl2
        ora     $1a
        asl
        tax
        lda     f:WorldBattleRateTbl,x
        ora     f:WorldBattleRateTbl+1,x
        beq     @c278
        longa
        lda     $1f6e
        clc
        adc     f:WorldBattleRateTbl,x
        bcc     @c222
        lda     #$ff00
@c222:  sta     $1f6e
        shorta0
        jsr     UpdateBattleRng
        cmp     $1f6f
        bcs     @c278
        stz     $1f6e
        stz     $1f6f
        lda     $24
        cmp     #$ff
        jeq     GetVeldtBattle          ; jump if a veldt sector
        longa
        asl3
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$50
        bcc     @c25d
        inx2
        cmp     #$a0
        bcc     @c25d
        inx2
        cmp     #$f0
        bcc     @c25d
        inx2
@c25d:  longa
        lda     f:RandBattleGroup,x
        sta     f:$0011e0
        tdc
@c268:  shorta
        lda     $1ed7
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #1
        bra     @c279
@c278:  tdc
@c279:  pha
        jsr     PushDP
        pla
        rtl

; ------------------------------------------------------------------------------

; world map battle backgrounds (8 per map)
WorldBattleBGTbl:
@c27f:  .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $00,$01,$2f,$03,$05,$05,$06,$07

; world map battle rate for each battle bg
BattleBGRateTbl:
@c28f:  .byte   $03,$02,$01,$02,$03,$00,$03,$03

; world map battle groups for each battle bg
BattleBGGroupTbl:
@c297:  .byte   $00,$01,$02,$01,$00,$03,$00,$00

; world map random battle rates
; 8 bytes each (normal, low, high, none)
WorldBattleRateTbl:
@c29f:  .word   $00c0,$0060,$0180,$0000  ; normal
        .word   $0060,$0030,$00c0,$0000  ; charm bangle
        .word   $0000,$0000,$0000,$0000  ; moogle charm
        .word   $0000,$0000,$0000,$0000  ; unused

; normal map random battle rates
; 8 bytes each (normal, low, high, very high)
SubBattleRateTbl:
@c2bf:  .word   $0070,$0040,$0160,$0200  ; normal
        .word   $0038,$0020,$00b0,$0100  ; charm bangle
        .word   $0000,$0000,$0000,$0000  ; moogle charm
        .word   $0000,$0000,$0000,$0000  ; unused

; ------------------------------------------------------------------------------

; [ select a veldt formation ]

GetVeldtBattle:
@c2df:  inc     $1fa5
        lda     $1fa5
        and     #$3f
        tax
@c2e8:  lda     $1ddd,x
        bne     @c2f4
        txa
        inc
        and     #$3f
        tax
        bra     @c2e8
@c2f4:  sta     $1a
        txa
        sta     $1fa5
        longa
        asl3
        sta     $1e
        shorta0
        jsr     UpdateBattleGrpRng
        and     #$07
        tax
@c30a:  lda     $1a
        and     f:BitOrTbl,x
        bne     @c319
        txa
        inc
        and     #$07
        tax
        bra     @c30a
@c319:  longa_clc
        txa
        adc     $1e
        sta     f:$0011e0
        shorta0
        pha
        jsr     PushDP
        pla
        lda     #1
        rtl

; ------------------------------------------------------------------------------

; [ update random battles ]

CheckBattleSub:
@c32d:  lda     $84
        bne     @c36b
        lda     $078e
        bne     @c36b
        lda     $1eb9
        and     #$20
        bne     @c36b
        ldx     $e5
        bne     @c36b
        lda     $e7
        cmp     #$ca
        bne     @c36b
        lda     $0525
        bpl     @c36b
        ldy     $0803
        lda     $0869,y
        bne     @c36b
        lda     $086a,y
        and     #$0f
        bne     @c36b
        lda     $086c,y
        bne     @c36b
        lda     $086d,y
        and     #$0f
        bne     @c36b
        lda     $57
        bne     @c36c                   ; branch if random battle is enabled
@c36b:  rts
@c36c:  stz     $57                     ; disable random battle
        ldx     $078c                   ; increment number of steps on map
        inx
        stx     $078c
        lda     a:$0082                 ; map index
        and     #$03
        tay
        longa
        lda     a:$0082
        lsr2
        tax
        shorta0
        lda     f:SubBattleRate,x       ; probability data (2 bits per map)
        cpy     $00
        beq     @c393
@c38e:  lsr2
        dey
        bne     @c38e
@c393:  and     #$03
        sta     $1a
        lda     $11df                   ; moogle charm and charm bangle effect
        and     #$03
        asl2
        ora     $1a
        asl
        tax
        lda     f:SubBattleRateTbl,x
        ora     f:SubBattleRateTbl+1,x
        jeq     @c478                   ; return if battle probability is zero
        longa_clc
        lda     $1f6e                   ; random battle counter
        adc     f:SubBattleRateTbl,x    ; add random battle rate (max #$ff00)
        bcc     @c3bd
        lda     #$ff00
@c3bd:  sta     $1f6e
        shorta0
        jsr     UpdateBattleRng
        cmp     $1f6f
        bcs     @c36b                   ; return if counter didn't overflow
        stz     $1f6e                   ; clear random battle counter
        stz     $1f6f
        ldx     a:$0082
        lda     f:SubBattleGroup,x               ; get the map's battle group
        longa
        asl3
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$50
        bcc     @c3f6
        inx2
        cmp     #$a0
        bcc     @c3f6
        inx2
        cmp     #$f0
        bcc     @c3f6
        inx2
@c3f6:  longa
        lda     f:RandBattleGroup,x               ; random battle groups (8 bytes each)
        sta     f:$0011e0
        shorta0
        lda     $0522                   ; battle bg
        and     #$7f
        sta     f:$0011e2
        tdc
        sta     f:$0011e3
        ldx     $0541                   ; save bg1 scroll position
        stx     $1f66
        ldx     a:$00af                 ; save party position
        stx     $1fc0
        lda     $1ed7                   ;
        and     #$10
        lsr
        sta     f:$0011e4
        inc     $078b                   ; increment battle count on this map
        longa
        tdc
        sta     $0871,y                 ; clear object 0 movement speed
        sta     $0873,y
        sta     $73                     ; clear bg scroll from movement
        sta     $75
        sta     $77
        sta     $79
        sta     $7b
        sta     $7d
        shorta
        ldx     #$0018                  ; $ca0018 (random battle)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        ldx     #$0000
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003
        stx     $e8
        ldy     $0803
        lda     $087c,y                 ; save party movement type
        sta     $087d,y
        lda     #$04                    ; movement type 4 (activated)
        sta     $087c,y
        lda     #$80
        sta     $11fa                   ; enable map startup event
@c478:  rts

; ------------------------------------------------------------------------------

; [ update random number for random battle ]

UpdateBattleRng:
@c479:  phx
        inc     $1fa1                   ; increment random number pointer
        bne     @c488
        lda     $1fa4
        clc
        adc     #17                     ; add 17 to random number counter
        sta     $1fa4
@c488:  lda     $1fa1
        tax
        lda     f:RNGTbl,x              ; add random number to counter
        clc
        adc     $1fa4
        plx
        rts

; ------------------------------------------------------------------------------

; [ update random number for battle group ]

UpdateBattleGrpRng:
@c496:  phx
        inc     $1fa2
        bne     @c4a5
        lda     $1fa3
        clc
        adc     #$17
        sta     $1fa3
@c4a5:  lda     $1fa2
        tax
        lda     f:RNGTbl,x
        clc
        adc     $1fa3
        plx
        rts

; ------------------------------------------------------------------------------
