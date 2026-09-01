
.enum INIT_TARGET
        FIGHT
        ITEM
        MAGIC
        THROW_TOOLS

        COUNT
.endenum

.enum CMD_TARGET
        NO_TARGET_ATTACKER              = $01
        TYPE_MASK                       = $06
        TYPE_DEFAULT                    = $00
        TYPE_ITEM                       = $02
        TYPE_MAGIC                      = $04
        TYPE_TOOLS                      = $06
        RAISE_TARGET                    = $08
        NO_RETARGET                     = $10
        ALLOW_DEAD_TARGET               = $20
        RAND_TARGET                     = $40
        NO_TARGET_CHAR                  = $80
.endenum

; ------------------------------------------------------------------------------

; [ init attack target ]

; _inittarget:
.proc InitTarget

@26d3:  phx
        phy
        pha
        stz     zba
        ldx     #TARGET::ENEMY
        stx     zbb
        ldx     #$00
        cmp     #$1e
        bcs     @2701
        tax
        lda     f:CmdTargetTbl,x
        pha
        and     #$e1
        sta     zba
        lda     1,s
        and     #$18
        lsr
        tsb     zba
        txa
        asl
        tax
        lda     f:BattleCmdProp+1,x   ; targetting byte
        sta     zbb
        pla
        and     #$06
        tax
        xba
@2701:  jsr     (near InitTargetTbl,x)
        pla
        ply
        plx
_2707:  rts

.endproc  ; InitTarget

; ------------------------------------------------------------------------------

; 3: throw/tools
        array_label INIT_TARGET, INIT_TARGET::THROW_TOOLS
@2708:  ldx     #$04
@270a:  cmp     f:ThrowToolsItemTbl,x
        bne     @2716
        sbc     f:ThrowToolsOffsetTbl,x
        bra     _274d
@2716:  dex
        bpl     @270a
        sec
; fallthrough

; ------------------------------------------------------------------------------

; [  ]

InitItemTarget:
; itemcursor:
@271a:  sta     near w7e3411
        jsr     GetItemPropPtr
        longi
        tax
        lda     f:ItemProp+14,x   ; targetting
        sta     zbb
        lda     f:ItemProp+21,x   ;
        bitflg  STATUS1, {DEAD, PETRIFY, ZOMBIE}
        bne     @2735
        lda     #$08
        trb     zba
@2735:  lda     f:ItemProp+18,x   ;
        shorti
        rts

; ------------------------------------------------------------------------------

; 1: item
        array_label INIT_TARGET, INIT_TARGET::ITEM
@273c:  cmp     #ITEM::SPRINT_SHOES
        jsr     InitItemTarget
        bcs     InitTarget::_2707
        bmi     @274b
        xba
        lda     #$10
        tsb     zb1
        xba
@274b:  and     #$3f
; fall through

; ------------------------------------------------------------------------------

; 2: commands that use a spell/attack
; magic, swdtech, blitz, lore, slot, rage, dance, x-magic, summon, health, shock, magitek
        array_label INIT_TARGET, INIT_TARGET::MAGIC
_274d:  sta     near w7e3410       ; set last spell used
        bra     _2754

; ------------------------------------------------------------------------------

; 0: commands that don't use a spell attack
; fight, morph, revert, steal, capture, runic, sketch, control, leap, mimic,
; row, def, jump, gp rain, possess, and all commands above $1d
        array_label INIT_TARGET, INIT_TARGET::FIGHT
@2752:  lda     #ATTACK::BATTLE
_2754:  jsr     LoadMagicProp
        lda     zbb
        inc
        bne     @2761       ; branch if targetting isn't from a menu
        lda     $11a0
        sta     zbb
@2761:  lda     $11a2       ;
        pha
        and     #$04        ; isolate resurrection targetting flag
        asl
        tsb     zba         ; copy to "can hit dead targets flag"
        lda     1,s
        and     #$10        ; random target flag
        asl2
        tsb     zba         ; copy to $ba
        pla
        and     #$80        ; can't target characters flag
        tsb     zba
        rts

; ------------------------------------------------------------------------------

; bio blaster, flash, fire skean, water edge, bolt edge
ThrowToolsItemTbl:
        .byte   ITEM::BIO_BLASTER
        .byte   ITEM::FLASH
        .byte   ITEM::FIRE_SKEAN
        .byte   ITEM::WATER_EDGE
        .byte   ITEM::BOLT_EDGE

; ------------------------------------------------------------------------------

; spell offsets for above items
ThrowToolsOffsetTbl:
        .byte   ITEM::BIO_BLASTER - ATTACK::BIO_BLAST_TOOL
        .byte   ITEM::FLASH - ATTACK::FLASH_TOOL
        .byte   ITEM::FIRE_SKEAN - ATTACK::FIRE_SKEAN
        .byte   ITEM::WATER_EDGE - ATTACK::WATER_EDGE
        .byte   ITEM::BOLT_EDGE - ATTACK::BOLT_EDGE

; ------------------------------------------------------------------------------

; command init jump table
InitTargetTbl:
        ptr_tbl INIT_TARGET

; ------------------------------------------------------------------------------

; command targetting data (one byte per command)

CmdTargetTbl:
        opflg .byte, CMD_TARGET, {ALLOW_DEAD_TARGET}                    ; FIGHT
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET, TYPE_ITEM} ; ITEM
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; MAGIC
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET}            ; MORPH
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET}            ; REVERT
        opflg .byte, CMD_TARGET, {TYPE_DEFAULT}                         ; STEAL
        opflg .byte, CMD_TARGET, {ALLOW_DEAD_TARGET}                    ; CAPTURE
        opflg .byte, CMD_TARGET, {ALLOW_DEAD_TARGET, TYPE_MAGIC}        ; BUSHIDO
        opflg .byte, CMD_TARGET, {TYPE_TOOLS}                           ; THROW
        opflg .byte, CMD_TARGET, {TYPE_TOOLS}                           ; TOOLS
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; BLITZ
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET}            ; RUNIC
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; LORE
        opflg .byte, CMD_TARGET, {NO_TARGET_CHAR}                       ; SKETCH
        opflg .byte, CMD_TARGET, {NO_TARGET_CHAR}                       ; CONTROL
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; SLOT
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; RAGE
        opflg .byte, CMD_TARGET, {NO_TARGET_CHAR}                       ; LEAP
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET}            ; MIMIC
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; DANCE
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET}            ; ROW
        opflg .byte, CMD_TARGET, {RAISE_TARGET, NO_RETARGET}            ; DEF
        opflg .byte, CMD_TARGET, {ALLOW_DEAD_TARGET, NO_TARGET_ATTACKER}; JUMP
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; X_MAGIC
        opflg .byte, CMD_TARGET, {NO_TARGET_ATTACKER}                   ; GIL_TOSS
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; SUMMON
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; HEALTH
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; SHOCK
        opflg .byte, CMD_TARGET, {NO_TARGET_CHAR, NO_TARGET_ATTACKER}   ; POSSESS
        opflg .byte, CMD_TARGET, {TYPE_MAGIC}                           ; MAGITEK

; ------------------------------------------------------------------------------
