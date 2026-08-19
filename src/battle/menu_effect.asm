; ------------------------------------------------------------------------------

; [ calculate item/spell effect (from menu) ]

; X: 0 = spell, 2 = item

CalcMagicEffect:
_menumagic:
@4730:  phx
        phy
        phb
        php
        shortai
        pha
        lda     #$7e
        pha
        plb
        pla
        clc
        jsr     (near MenuEffectTbl,x)
        jsr     EquipStatusMod
        jsr     CalcStatus
        plp
        plb
        ply
        plx
        rtl

; ------------------------------------------------------------------------------

; jump table for item/spell
table_menumagic:
MenuEffectTbl:
@474b:  .addr   MenuMagicEffect
        .addr   MenuItemEffect

; ------------------------------------------------------------------------------

; x = 0: cast spell
MenuMagicEffect:
@474f:  jsr     LoadMagicProp
        lda     $11a4
        bpl     @4775                   ; branch if not a fraction of hp
        lda     $11a6
        sta     $e8
        longai
        lda     $11b2
        jsr     CalcMaxHPMP
        cmp     #MAX_HP + 1                  ; max 9999
        bcc     @476c
        lda     #MAX_HP
@476c:  shorti
        jsr     CalcRatio
        sta     $11b0
        rts
@4775:  jmp     CalcMagicDmg

; ------------------------------------------------------------------------------

; x = 2: use item
MenuItemEffect:
@4778:  .a8
        jsr     CalcItemEffect
        lda     #$01
        tsb     $11a2       ; physical damage
        rts

; ------------------------------------------------------------------------------
