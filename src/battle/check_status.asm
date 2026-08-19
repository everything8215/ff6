; ------------------------------------------------------------------------------

; [ check if status set ]

; status to check pushed to stack (4 bytes)
; carry set: none set (out)
; carry clear: one or more set (out)

CheckStatus:
@5864:  longa_clc
        lda     near wTargetProp3::w7e3ee4,y     ; check if status is set
        and     5,s
        bne     @5875       ; branch if any are set
        lda     near wTargetProp3::w7e3ef8,y
        and     3,s
        bne     @5875
        sec                 ; set carry if none are set
@5875:  lda     1,s       ; fix return address
        sta     5,s
        pla
        pla
        shorta
        rts

; ------------------------------------------------------------------------------
