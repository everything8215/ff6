; ------------------------------------------------------------------------------

; [ hide floating island in mini-map ]

FixMinimap:
@9af1:  php
        shorta
        lda     $1f64
        bne     @9b12                   ; return if not world of balance
        lda     $1e93
        bit     #$40
        beq     @9b12                   ; return if floating island has not lifted off
        longa
        lda     $7ee1a2                 ; hide floating island
        sta     $7ee1ac
        sta     $7ee1ae
        sta     $7ee1b0
@9b12:  plp
        rts

; ------------------------------------------------------------------------------
