; ------------------------------------------------------------------------------

; [ update gauge values/condemned number in graphics buffer ]

UpdateCounterGfxBuf:
@5c54:  shortai
        ldx     #$06
        ldy     #$03
@5c5a:  lda     near wTargetProp1::w7e3218_H,x  ; atb gauge - 1
        dec
        sta     near wATBGaugeBuf,y          ; update graphics buffer
        lda     near wTargetProp2::w7e3b04,x
        sta     near wMorphGaugeBuf,y        ; update morph gauge buffer
        lda     near wTargetProp2::w7e3b05,x
        sta     near wCondemnNumBuf,y      ; update condemned number buffer
        dex2
        dey
        bpl     @5c5a
        rts

; ------------------------------------------------------------------------------

; [ update monster graphics buffer and run difficulty ]

UpdateMonsterGfxBuf:
@5c73:  longa
        ldy     #$08
@5c77:  clr_a
        sta     near w7e2015 - 2,y     ; clear number of monsters alive for each name
        dec
        sta     near w7e200d - 2,y     ; clear monster names
        dey2
        bne     @5c77
        shorta
        lda     #$06
        trb     zb1         ; clear can't run flag and disable warp/smoke bomb
        lda     near w7e201f
        cmp     #BATTLE_TYPE::PINCER
        bne     @5ca4       ; branch if not a pincer attack
        lda     near w7e2eac
        and     near w7e2f2f
        beq     @5ca4
        lda     near w7e2ead
        and     near w7e2f2f
        beq     @5ca4
        lda     #$02                    ; can't run away
        tsb     zb1
@5ca4:  stz     near w7e3a3b       ; clear run difficulty
        stz     near w7e3eb0 + 26       ; clear number of different types of monsters
@5caa:  lda     near wTargetProp2::_4::w7e3aa0,y
        lsr
        bcc     @5d04       ; branch if monster is not present
        lda     near wTargetMask::_4 + 1,y     ; monster mask
        bit     near w7e3a3a
        bne     @5d04       ; branch if monster died or escaped
        bit     near w7e3408_H
        beq     @5d04       ; branch if monster was not revived or summoned
        lda     near wTargetProp3::_4::w7e3ee4,y
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @5d04       ; branch if monster has petrify, wound, or zombie status
        lda     near wTargetProp2::_4::MonsterStatus,y  ; MONSTER_STATUS::HARDER_TO_RUN
        lsr                 ; set carry if harder to run
        bit     #MONSTER_STATUS::CANT_ESCAPE >> 1
        beq     @5cd0       ; branch if party can run
        lda     #$06
        tsb     zb1             ; can't run away, disable warp/smoke bomb
@5cd0:  clr_a
        rol
        sec
        rol
        asl                 ; A = 2 (6 if monster is harder to run from)
        adc     near w7e3a3b       ; add to run difficulty
        sta     near w7e3a3b
        lda     near wTargetProp2::_4::MonsterFlags,y
        bit     #MONSTER_FLAG::HIDE_NAME
        bne     @5d04
        longa
        ldx     #$00
@5ce6:  lda     near w7e200d,x
        bpl     @5cf4
        lda     near wTargetProp1::_4::w7e3380,y
        sta     near w7e200d,x
        inc     near w7e3eb0 + 26
@5cf4:  cmp     near wTargetProp1::_4::w7e3380,y
        bne     @5cfe
        inc     near w7e2015,x
        bra     @5d04
@5cfe:  inx2
        cpx     #$08
        bcc     @5ce6
@5d04:  shorta
        iny2
        cpy     #$0c
        bcc     @5caa
        lda     near w7e201f
        cmp     #BATTLE_TYPE::SIDE
        beq     @5d19
        lda     zb0
        bit     #$40
        beq     @5d1c
@5d19:  stz     near w7e3a3b
@5d1c:  lda     near w7e3a42                 ; enemy characters that are alive
        beq     @5d25
        lda     #$02                    ; can't run away
        tsb     zb1
@5d25:  rts

; ------------------------------------------------------------------------------

; [ update character hp/mp/status in graphics buffer ]

UpdateCharGfxBuf:
@5d26:  php
        longa
        shorti
        ldy     #$06
@5d2d:  lda     near wTargetProp2::CurrHP,y     ; current hp
        sta     near w7e2e78,y
        lda     near wTargetProp2::MaxHP,y     ; max hp
        sta     near w7e2e80,y
        lda     near wTargetProp2::CurrMP,y     ; current mp
        sta     near w7e2e88,y
        lda     near wTargetProp2::MaxMP,y     ; max mp
        sta     near w7e2e90,y
        lda     near wTargetProp3::w7e3ee4,y     ; status 1 & 2
        sta     near w7e2e98,y
        lda     near wTargetProp3::w7e3ef8,y     ; status 3 & 4
        sta     near w7e2ea0,y
        dey2
        bpl     @5d2d
        plp
        rts

; ------------------------------------------------------------------------------
