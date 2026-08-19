; ------------------------------------------------------------------------------

; [ update controller ]

UpdateCtrl:
@1b85:  phb
        clr_a
        pha
        plb
        lda     w7e62ca     ; active character
        and     #%11
        sta     f:$000201
        jsl     UpdateCtrlBattle_ext
        plb
        ldx     z04         ; swap buttons pressed and buttons in repeat mode
        phx
        ldx     z0a
        stx     z04
        plx
        stx     z0a
        stx     near w7e6268
        longa
        lda     near w7e6266       ; buttons pressed last frame
        not_a
        and     near w7e6268       ; new buttons
        and     #$f0f0      ; mask direction buttons
        sta     near w7e6268
        txa
        and     #$0f0f
        ora     near w7e6268
        sta     near w7e6268
        stx     near w7e6266
        shorta0
        rts

; ------------------------------------------------------------------------------
