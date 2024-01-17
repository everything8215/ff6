.segment "menu_code"

; ------------------------------------------------------------------------------

; [ check if sram is valid ]

CheckSRAM:
@7023:  longa
        lda     #$e41b                  ; fixed value
        cmp     $307ff8
        beq     @7047
        cmp     $307ffa
        beq     @7047
        cmp     $307ffc
        beq     @7047
        cmp     $307ffe
        beq     @7047
        shorta
        jsr     ClearSRAM
        clc
        rts
@7047:  shorta
        sec
        rts

; ------------------------------------------------------------------------------

; [ clear sram ]

ClearSRAM:
@704b:  phb
        lda     #$30
        pha
        plb
        ldx     #0
        longa
@7055:  stz     $6000,x                 ; clear 30/6000-30/7fff
        inx2
        stz     $6000,x
        inx2
        cpx     #$2000
        bne     @7055
        shorta
        plb
        rts

; ------------------------------------------------------------------------------

; [ reset saved menu cursor positions ]

ResetMenuCursorMemory:
@7068:  ldx     #0
@706b:  stz     $022b,x                 ; clear saved menu cursor positions
        inx
        cpx     #$001f
        bne     @706b
        lda     #$01                    ; character skills cursors default to magic
        sta     $0237
        sta     $0239
        sta     $023b
        sta     $023d
        rts

; ------------------------------------------------------------------------------

; [ make sram valid ]

ValidateSRAM:
@7083:  longa
        lda     #$e41b                  ; set fixed value
        sta     $307ff8
        sta     $307ffa
        sta     $307ffc
        sta     $307ffe
        shorta
        rts

; ------------------------------------------------------------------------------

; [ init saved game data ]

InitSaveSlot:
@709b:  jsr     ResetMenuCursorMemory
        ldy     #$7fff                  ; set default font color
        sty     $1d55
        lda     #$12                    ; set default button mappings
        sta     $1d50
        lda     #$34
        sta     $1d51
        lda     #$56
        sta     $1d52
        lda     #$06
        sta     $1d53
        lda     #$2a                    ;
        sta     $1d4d
        clr_ay
        sty     $1dc7                   ;
        stz     $1d54
        stz     $1d4e
        stz     $1d4f
        sty     $1863                   ; clear game time
        stz     $1865
        sty     $1860                   ; clear gp
        stz     $1862
        sty     $1866                   ; clear steps
        stz     $1868
        sty     $021b                   ; clear menu game time
        sty     $021d
        jsr     InitWindowPal
        rts

; ------------------------------------------------------------------------------
