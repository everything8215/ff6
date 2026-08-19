; ------------------------------------------------------------------------------

; [ get bit number ]

.proc GetBitNum

        ldx     #0
:       lsr
        beq     Done
        inx
        bra     :-
Done:   rts

.endproc  ; GetBitNum

; ------------------------------------------------------------------------------

; [ get the first valid target in +A ]

; +A: valid targets (bitmask)
; +Y: pointer to target data (out)

.proc BitToTargetID

        phx
        php
        longa
        shorti
        ldx     #$12
:       bit     near wTargetMask,x
        bne     Done
        dex2
        bpl     :-
Done:   txy
        plp
        .a8
        plx
        rts

.endproc  ; BitToTargetID

; ------------------------------------------------------------------------------

; [ X = number of bits set in A ]

.proc CountBits
        ldx     #0
Loop:   lsr
        bcc     :+
        inx
:       bne     Loop
        rts

.endproc  ; CountBits

; ------------------------------------------------------------------------------

; [ get bit mask and byte number ]

; A: bit number
; A: bit mask (out)
; X: byte number (out)

.proc GetBitPtr

        phy
        pha
        ror
        lsr2
        tax
        pla
        and     #%111
        tay
        lda     #0
        sec
:       rol
        dey
        bpl     :-
        ply
        rts

.endproc  ; GetBitPtr

; ------------------------------------------------------------------------------

; [ pick a random bit set in A ]

.proc RandBit

        phy
        php
        longa
        sta     $ee
        jsr     CountBits
        txa
        beq     Done
        jsr     RandA
        tax
        sec
        clr_a
:       rol
        bit     $ee
        beq     :-
        dex
        bpl     :-
Done:   plp
        .a8
        ply
        rts

.endproc  ; RandBit

; ------------------------------------------------------------------------------

; [ choose battle type/umaro's attack ]

; X: probability type
; A: allowed bits (bitmask)
; X: battle type/umaro's attack (out)

.proc RandBitWithRate

        phy
        xba
        lda     #0
        ldy     #3
Loop:   xba
        asl
        xba
        bcc     Skip                    ; branch if battle type is not available
        adc     f:RandBitRateTbl,x
Skip:   sta     $fc,y
        inx
        dey
        bpl     Loop
        jsr     RandA
        ldx     #4
:       dex
        cmp     $fc,x
        bcs     :-
        ply
        rts

.endproc  ; RandBitWithRate

; ------------------------------------------------------------------------------

RandBitRateTbl:
@5269:  .byte   $9e,$5f,$ff,$ff         ; 0: umaro attack probabilities
        .byte   $5e,$3f,$ff,$5f
        .byte   $5e,$3f,$5f,$ff
        .byte   $3e,$3f,$3f,$3f
        .byte   $1e,$07,$07,$cf         ; 4: battle type probabilities

; ------------------------------------------------------------------------------
