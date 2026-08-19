; ------------------------------------------------------------------------------

; [ add battle script command to queue ]

_c2629b:
_writeanima3_mem_16:
@629b:  sta     near w7e3a28                   ; set gfx script command id

_c2629e:
_writeanima2:
@629e:  pha
        phx
        php
        longa
        shorti
        ldx     near w7e3a72
        lda     near w7e3a28
        sta     near w7e2d6e,x
        lda     near w7e3a2a
        sta     near w7e2d6e + 2,x
        inx4                ; increment battle script command queue pointer
        stx     near w7e3a72
        plp
        plx
        pla
        rts

; ------------------------------------------------------------------------------

; [ add battle script command to queue (8-bit access) ]

_c262bf:
; _writeanima3_mem_8:
; _writeanima4:
@62bf:  php
        longa
        jsr     _c2629b       ; add battle script command to queue
        plp
        rts

; ------------------------------------------------------------------------------

; [ add obtained items to inventory ]

_c262c7:
_writeinhand:
        .a8
@62c7:  ldx     #$06
@62c9:  lda     near wTargetMask,x     ; character mask
        trb     near w7e3a8c       ; clear "character obtained an item" flag
        beq     @62ea       ; skip if character didn't obtain an item
        lda     near wTargetProp1::w7e32f4,x     ; item obtained
        cmp     #ITEM::EMPTY
        beq     @62ea       ; skip if empty
        jsr     LoadItemProp
        lda     #1
        sta     near w7e2e75       ; item quantity = 1
        lda     #BTL_GFX::GIVE_ITEM
        jsr     ExecBtlGfx
        lda     #ITEM::EMPTY
        sta     near wTargetProp1::w7e32f4,x     ; clear item obtained
@62ea:  dex2                ; next character
        bpl     @62c9
        rts

; ------------------------------------------------------------------------------

; [ apply and display damage ]

ExecDmg:
        .a16
        phx
        phy
        stz     $f0
        stz     $f2
        ldy     #$12
@62f7:  lda     near wTargetProp1::DmgTaken,y
        cmp     near wTargetProp1::DmgHealed,y
        bne     @6302
        inc
        beq     @6345
@6302:  lda     near wTargetMask,y
        trb     near w7e3a5a
        jsr     ApplyDmg
        cpy     near w7e3a82
        bne     @6323
        lda     near wTargetProp1::DmgTaken,y
        inc
        beq     @6323
        sec
        lda     near wGolemHP
        sbc     near wTargetProp1::DmgTaken,y
        bcs     @6320
        clr_a
@6320:  sta     near wGolemHP
@6323:  lda     near wTargetProp1::DmgHealed,y
        inc
        beq     @6345
        dec
        ora     #$8000
        sta     near wTargetProp1::DmgHealed,y
        inc     $f2
        lda     near wTargetProp1::DmgTaken,y
        inc
        bne     @6345
        dec     $f2
        lda     near wTargetProp1::DmgHealed,y
        sta     near wTargetProp1::DmgTaken,y
        clr_a
        dec
        sta     near wTargetProp1::DmgHealed,y
@6345:  lda     near wTargetMask,y
        bit     near w7e3a5a
        beq     @6353
        lda     #$4000
        sta     near wTargetProp1::DmgTaken,y
@6353:  lda     near wTargetProp1::DmgTaken,y     ; damage taken
        inc
        beq     @635b
        inc     $f0
@635b:  dey2
        bpl     @62f7
        ldy     $f0
        cpy     #5
        jsr     ShowDmgNumerals
        jsr     ShowDmgNumeralsMulti
        lda     $f2
        beq     @6387
        ldx     #$12
        ldy     #$00
@6371:  lda     near wTargetProp1::DmgHealed,x     ; copy damage healed to damage taken
        sta     near wTargetProp1::DmgTaken,x
        inc
        beq     @637b
        iny
@637b:  dex2
        bpl     @6371
        cpy     #5
        jsr     ShowDmgNumerals
        jsr     ShowDmgNumeralsMulti
@6387:  clr_a
        dec
        ldx     #$12
@638b:  sta     near wTargetProp1::DmgHealed,x     ; invalidate all damage
        sta     near wTargetProp1::DmgTaken,x
        dex2
        bpl     @638b
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ display damage numerals (less than 5 targets) ]

ShowDmgNumerals:
@6398:  bcs     @63b3
        ldx     #$12
@639c:  lda     near wTargetProp1::DmgTaken,x
        inc
        beq     @63ae       ; branch if target didn't take damage
        dec
        sta     near w7e3a2a
        txa
        lsr
        xba
        ora     #GFX_CMD::DMG_NUMERALS_SINGLE
        jsr     _c2629b       ; add battle script command to queue
@63ae:  dex2
        bpl     @639c
@63b3:  rts

; ------------------------------------------------------------------------------

; [ display damage numerals (5 or more targets) ]

ShowDmgNumeralsMulti:
@63b4:  bcc     @63da
        php
        shorta
        lda     #GFX_CMD::DMG_NUMERALS_MULTI
        jsr     _c2629b       ; add battle script command to queue
        lda     near w7e3a34       ; number of targets
        inc     near w7e3a34
        xba
        lda     #$14
        jsr     MultAB
        longai_clc
        adc     #near w7e2bce
        tay
        ldx     #near wTargetProp1::DmgTaken
        lda     #$0013
        mvn     wTargetProp1,w7e2bce     ; copy damage variables to graphics buffer
        plp
@63da:  rts

; ------------------------------------------------------------------------------

; [ copy battle script data to buffer ]

CopyGfxParamsToBuf:
@63db:  phx
        phy
        php
        shorta
        clr_a
        lda     near w7e3a32
        pha
        longai_clc
        adc     #near w7e2c6e
        tay
        ldx     #za0
        lda     #$000f
        mvn     #$7e,#$7e
        shortai
        pla
        adc     #$10
        sta     near w7e3a32
        plp
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ clear graphics script data buffer ]

ClearGfxParams:
@6400:  phx
        php
        longa
        ldx     #6
@6406:  stz     za0,x
        stz     za0 + 8,x
        dex2
        bpl     @6406
        plp
        plx
        rts

; ------------------------------------------------------------------------------

; [ do battle graphics command ]

ExecBtlGfx:
@6411:  phx
        phy
        php
        shorta
        longi_clc
        pha
        clr_a
        pla
        cmp     #BTL_GFX::OPEN_MENU
        bne     @6425       ; branch if command is not $02 (open battle menu)
        lda     zb1
        bmi     @6429       ; return if battle menu is disabled
        lda     #BTL_GFX::OPEN_MENU
@6425:  jsl     ExecBtlGfx_ext
@6429:  plp
        ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ command $2b: misc. monster animations (ai command $fa) ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::MONSTER_ANIM
@642d:  longa
        lda     zb8
        sta     near w7e3a2a
        shorta
        lda     zb6
        xba
        lda     #GFX_CMD::MONSTER_ANIM
        jmp     _c262bf       ; add battle script command to queue

; ------------------------------------------------------------------------------

; [ defeat all monsters immediately (unused) ]

; debug

DebugWin:
@643e:  .i8
        longa
        lda     $1d55       ; font color
        cmp     #$7bde
        shorta
        bne     @6468       ; branch if not (30,30,30)
        lda     f:hSTDCNTRL1H
        cmp     #>(JOY_UP | JOY_SELECT)
        bne     @6468       ; branch unless select and up are pressed on controller 2
        lda     #$02
        tsb     near w7e3a96       ; make sure it's been pressed for more than one frame ???
        bne     @6468
        lda     #$ff        ; affect all monsters
        sta     zb8_H
        lda     #$05        ; hide monsters and set wound status
        sta     zb8_L
        ldx     #MONSTER_ENTRY_EXIT_ANIM::INSTANT
        lda     #ACTION_BATTLE_CMD::MONSTER_ENTRY_EXIT
        jsr     CreateImmediateAction
@6468:  rts

; ------------------------------------------------------------------------------
