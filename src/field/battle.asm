
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

.include "gfx/battle_bg.inc"

.import EventScript_RandBattle

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ battle blur/sound ]

.proc BattleMosaic
        lda     $078a                   ; branch if battle sound effect is disabled
        and     #$40
        bne     :+
        lda     #$c1                    ; play battle sound effect
        jsr     PlaySfx
:       lda     $078a                   ; return if battle blur is disabled
        bmi     done
        stz     $46                     ; clear frame counter
loop:   jsr     WaitVblank
        lda     $46
        cmp     #$10
        bcs     last_half
        and     #$07                    ; increase mosaic size from 0 to 7 twice
        bra     :+

last_half:
        and     #$0f                    ; then increase from 0 to 15 once
:       asl4
        ora     #$0f                    ; enable mosaic on all bg layers
        sta     $7e8233                 ; store in screen mosaic hdma table ($2106)
        sta     $7e8237
        sta     $7e823b
        sta     $7e823f
        sta     $7e8243
        sta     $7e8247
        sta     $7e824b
        sta     $7e824f
        lda     $46                     ; loop for 32 frames
        cmp     #32
        bne     loop
done:   rts
.endproc  ; BattleMosaic

; ------------------------------------------------------------------------------

; [ execute battle ]

.proc ExecBattle
        jsr     BattleMosaic
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
.endproc  ; ExecBattle

; ------------------------------------------------------------------------------

; [ update random battles (world map) ]

.proc CheckBattleWorld
        clr_a
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
        clr_a
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
        lda     f:WorldBattleGroup,x    ; world battle groups
        sta     $24
        cmp     #$ff
        bne     :+                      ; branch if not a veldt sector
        lda     #$0f
        sta     f:$0011e4               ; set veldt flags
:       longa
        lda     $1e
        lsr2
        tax
        shorta0
        lda     f:WorldBattleRate,x     ; world battle rates
        ldy     $22
        beq     :+
loop:   lsr2
        dey
        bne     loop
:       and     #$03
        cmp     #$03
        beq     no_battle
        sta     $1a
        lda     $11df
        and     #$03
        asl2
        ora     $1a
        asl
        tax
        lda     f:WorldBattleRateTbl,x
        ora     f:WorldBattleRateTbl+1,x
        beq     no_battle
        longa
        lda     $1f6e
        clc
        adc     f:WorldBattleRateTbl,x
        bcc     :+
        lda     #$ff00
:       sta     $1f6e
        shorta0
        jsr     UpdateBattleRng
        cmp     $1f6f
        bcs     no_battle
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
        bcc     :+
        inx2
        cmp     #$a0
        bcc     :+
        inx2
        cmp     #$f0
        bcc     :+
        inx2
:       longa
        lda     f:RandBattleGroup,x
        sta     f:$0011e0
        shorta0
        lda     $1ed7
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #1
        bra     :+

no_battle:
        clr_a
:       pha
        jsr     PushDP
        pla
        rtl

.endproc  ; CheckBattleWorld

; ------------------------------------------------------------------------------

; world map battle backgrounds (8 per map)
WorldBattleBGTbl:

; world of balance
        .byte   BATTLE_BG_FIELD_WOB
        .byte   BATTLE_BG_FOREST_WOR
        .byte   BATTLE_BG_DESERT_WOB
        .byte   BATTLE_BG_FOREST_WOB
        .byte   BATTLE_BG_ZOZO_INT
        .byte   BATTLE_BG_FIELD_WOR
        .byte   BATTLE_BG_VELDT
        .byte   BATTLE_BG_CLOUDS

; world of ruin
        .byte   BATTLE_BG_FIELD_WOB
        .byte   BATTLE_BG_FOREST_WOR
        .byte   BATTLE_BG_DESERT_WOR
        .byte   BATTLE_BG_FOREST_WOB
        .byte   BATTLE_BG_FIELD_WOR
        .byte   BATTLE_BG_FIELD_WOR
        .byte   BATTLE_BG_VELDT
        .byte   BATTLE_BG_CLOUDS

; world map battle rate for each battle bg
BattleBGRateTbl:
        .byte   3,2,1,2,3,0,3,3

; world map battle groups for each battle bg
BattleBGGroupTbl:
        .byte   0,1,2,1,0,3,0,0

; world map random battle rates
; 8 bytes each (normal, low, high, none)
WorldBattleRateTbl:
        .word   $00c0,$0060,$0180,$0000  ; normal
        .word   $0060,$0030,$00c0,$0000  ; charm bangle
        .word   $0000,$0000,$0000,$0000  ; moogle charm
        .word   $0000,$0000,$0000,$0000  ; unused

; normal map random battle rates
; 8 bytes each (normal, low, high, very high)
SubBattleRateTbl:
        .word   $0070,$0040,$0160,$0200  ; normal
        .word   $0038,$0020,$00b0,$0100  ; charm bangle
        .word   $0000,$0000,$0000,$0000  ; moogle charm
        .word   $0000,$0000,$0000,$0000  ; unused

; ------------------------------------------------------------------------------

; [ select a veldt formation ]

.proc GetVeldtBattle
        inc     $1fa5
        lda     $1fa5
        and     #$3f
        tax

; find a nonzero byte in the list of available veldt battles
loop1:  lda     $1ddd,x
        bne     :+
        txa
        inc
        and     #$3f
        tax
        bra     loop1
:       sta     $1a
        txa
        sta     $1fa5
        longa
        asl3
        sta     $1e
        shorta0
        jsr     UpdateBattleGrpRng
        and     #$07
        tax

; pick a random available battle
loop2:  lda     $1a
        and     f:BitOrTbl,x
        bne     :+
        txa
        inc
        and     #$07
        tax
        bra     loop2
:       longa_clc
        txa
        adc     $1e
        sta     f:$0011e0
        shorta0
        pha
        jsr     PushDP
        pla
        lda     #1
        rtl
.endproc  ; GetVeldtBattle

; ------------------------------------------------------------------------------

; [ update random battles ]

.proc CheckBattleSub
        lda     $84
        bne     done
        lda     $078e
        bne     done
        lda     $1eb9
        and     #$20
        bne     done
        ldx     $e5
        bne     done
        lda     $e7
        cmp     #^EventScript
        bne     done
        lda     $0525
        bpl     done
        ldy     $0803
        lda     $0869,y
        bne     done
        lda     $086a,y
        and     #$0f
        bne     done
        lda     $086c,y
        bne     done
        lda     $086d,y
        and     #$0f
        bne     done
        lda     $57
        bne     :+
done:   rts

:       stz     $57                     ; disable random battle
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
        beq     :+
loop:   lsr2
        dey
        bne     loop
:       and     #$03
        sta     $1a
        lda     $11df                   ; moogle charm and charm bangle effect
        and     #$03
        asl2
        ora     $1a
        asl
        tax
        lda     f:SubBattleRateTbl,x
        ora     f:SubBattleRateTbl+1,x
        jeq     moogle_charm            ; return if battle probability is zero
        longa_clc
        lda     $1f6e                   ; random battle counter
        adc     f:SubBattleRateTbl,x    ; add random battle rate (max #$ff00)
        bcc     :+
        lda     #$ff00
:       sta     $1f6e
        shorta0
        jsr     UpdateBattleRng
        cmp     $1f6f
        bcs     done                    ; return if counter didn't overflow
        stz     $1f6e                   ; clear random battle counter
        stz     $1f6f
        ldx     a:$0082
        lda     f:SubBattleGroup,x      ; get the map's battle group
        longa
        asl3
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$50
        bcc     :+
        inx2
        cmp     #$a0
        bcc     :+
        inx2
        cmp     #$f0
        bcc     :+
        inx2
:       longa
        lda     f:RandBattleGroup,x               ; random battle groups (8 bytes each)
        sta     f:$0011e0
        shorta0
        lda     $0522                   ; battle bg
        and     #$7f
        sta     f:$0011e2
        clr_a
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
        clr_a
        sta     $0871,y                 ; clear object 0 movement speed
        sta     $0873,y
        sta     $73                     ; clear bg scroll from movement
        sta     $75
        sta     $77
        sta     $79
        sta     $7b
        sta     $7d
        shorta
        ldx     #.loword(EventScript_RandBattle)
        stx     $e5
        stx     $05f4
        lda     #^EventScript_RandBattle
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1
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

moogle_charm:
        rts
.endproc  ; CheckBattleSub

; ------------------------------------------------------------------------------

; [ update random number for random battle ]

.proc UpdateBattleRng
        phx
        inc     $1fa1                   ; increment random number pointer
        bne     :+
        lda     $1fa4
        clc
        adc     #17                     ; add 17 to random number counter
        sta     $1fa4
:       lda     $1fa1
        tax
        lda     f:RNGTbl,x              ; add random number to counter
        clc
        adc     $1fa4
        plx
        rts
.endproc  ; UpdateBattleRng

; ------------------------------------------------------------------------------

; [ update random number for battle group ]

.proc UpdateBattleGrpRng
        phx
        inc     $1fa2
        bne     :+
        lda     $1fa3
        clc
        adc     #$17
        sta     $1fa3
:       lda     $1fa2
        tax
        lda     f:RNGTbl,x
        clc
        adc     $1fa3
        plx
        rts
.endproc  ; UpdateBattleGrpRng

; ------------------------------------------------------------------------------

.export EventBattleGroup

.segment "battle_groups"

; cf/4800
RandBattleGroup:
        .incbin "rand_battle_group.dat"

; cf/5000
EventBattleGroup:
        .incbin "event_battle_group.dat"

; cf/5400
WorldBattleGroup:
        .incbin "world_battle_group.dat"

; cf/5600
SubBattleGroup:
        .incbin "sub_battle_group.dat"

; cf/5800
WorldBattleRate:
        .incbin "world_battle_rate.dat"

; cf/5880
SubBattleRate:
        .incbin "sub_battle_rate.dat"

; ------------------------------------------------------------------------------
