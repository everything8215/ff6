; ------------------------------------------------------------------------------

; [ update battle script data ]

; X: attacker index * 2

InitGfxParams:
@57c2:  php
        shortai
        stz     za0         ; clear flags
        txa
        lsr
        sta     za1         ; set attacker index
        cmp     #$04
        bcc     @57d1       ; branch if attacker is a character
        ror     za0         ; attacker is a monster
@57d1:  lda     zb8_H
        sta     za2_H         ; set targets
        sta     za4_H         ; set targets hit
        lda     zb8_L
        sta     za2_L
        sta     za4_L
        bne     @57e3       ; branch if there is at least one character target
        lda     #$40
        tsb     za0         ; no character targets
@57e3:  lda     za0
        asl
        bcc     @57ea       ; branch if attacker is a character
        eor     #$80
@57ea:  bpl     @57f0
        lda     #$02        ; set no friendly targets flag
        tsb     zba
@57f0:  lda     #$10
        trb     zb0
        bne     @57f8
        tsb     za0         ; enable pre-magic swirly animation
@57f8:  lda     near w7e3a70
        beq     @580a       ; return if not last attack
        lda     near w7e3a8e
        beq     @580a       ; return if dragon horn is not active
        lda     #$02
        tsb     za0         ; set dragon horn effect
        lda     #$60
        tsb     zba         ; random target, can hit dead target (for next attack)
@580a:  plp
        rts

; ------------------------------------------------------------------------------
