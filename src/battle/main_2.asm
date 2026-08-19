.include "src/text/attack_msg.inc"

; ------------------------------------------------------------------------------

; [ update character battle stats ]

UpdateCharProp:
_equipchange:
@2095:  ldx     #3
@2097:  lda     near w7e2f30,x
        beq     @20da
        stz     near w7e2f30,x
        phx
        phy
        txa
        sta     $ee
        asl
        sta     $ef
        asl
        adc     $ee
        tax
        lda     near wRHandItemList::ItemID,x
        xba
        lda     near wLHandItemList::ItemID,x
        ldx     $ef
        longi
        ldy     near w7e3010,x
        sta     $1620,y
        xba
        sta     $161f,y
        lda     near wTargetProp3::w7e3ee4,x
        sta     $1614,y
        shorti
        lda     near w7e3ed8 + 1,x
        jsl     UpdateEquip
        jsr     UpdateEquipBattle
        jsr     UpdateCmdList
        jsr     UpdateImmuneStatus
        ply
        plx
@20da:  dex                 ; next character
        bpl     @2097
        rts

; ------------------------------------------------------------------------------

; [ command $2a: run ]

        array_label ACTION_BATTLE_CMD, ACTION_BATTLE_CMD::RUN_AWAY
; _escape:
@20de:  lda     near w7e2f45       ; return if characters are not running
        beq     @2162
        longa
        lda     #make_word GFX_CMD::ATTACK_MSG, ATTACK_MSG::RUN_FAIL
        sta     near w7e3a28
        shorta
        lda     zb1
        bit     #$02
        bne     @215f       ; branch if can't run away
        lda     near w7e3a38
        beq     @2162       ; return if no characters just escaped
        sta     zb8_L         ; set targets
        stz     near w7e3a38       ; clear character that just escaped
        jsr     ClearGfxParams
        ldx     #$06
@2102:  lda     near wTargetMask,x     ; bit mask
        trb     zb8_L
        beq     @2144       ; skip if that character didn't just escape
        xba
        lda     near wTargetProp1::w7e3218_H,x
        bne     @2144       ; skip if atb gauge is not full
        lda     near wTargetProp2::w7e3aa0,x
        bit     #$50
        bne     @2144       ; skip if $3aa0.4 or $3aa0.6 is set
        lsr
        bcc     @2144       ; skip if character is not present
        lda     near wTargetProp3::w7e3ee4,x
        bit     #STATUS1::ZOMBIE
        bne     @2144       ; skip if character has zombie status
        lda     near wTargetProp3::w7e3ef9,x
        bit     #STATUS4::HIDE
        bne     @2144       ; skip if character has hide status
        xba
        tsb     zb8_L         ; add target
        tsb     near w7e3a39       ; characters that have left the battle
        tsb     near w7e2f4c       ; characters that can be targetted
        lda     near wTargetProp2::w7e3aa1,x     ; set $3aa1.6 (pending run action)
        ora     #$40
        sta     near wTargetProp2::w7e3aa1,x
        lda     near wTargetProp1::w7e3204,x     ; remove all advance wait actions
        ora     #$40
        sta     near wTargetProp1::w7e3204,x
        jsr     _c207c8
        txy
@2144:  dex2                ; next character
        bpl     @2102
        lda     zb8_L
        beq     @2162       ; branch if no characters ran away
        stz     zb8_H         ; clear monster targets
        tyx
        jsr     InitGfxParams
        jsr     CopyGfxParamsToBuf
        longa
        lda     #make_word GFX_CMD::ATTACK_ANIM, GFX_BATTLE_CMD::RUN_AWAY
        sta     near w7e3a28
        shorta
@215f:  jsr     _c2629e       ; add battle script command to queue
@2162:  rts

; ------------------------------------------------------------------------------

; [ execute immediate action ]

; A: pointer to command list (+$3184)

_c22163:
_event:
@2163:  pea     BattleLoop-1
        pha
        asl
        tay
        clc
        jsr     InitPlayerAction
        pla
        tay
        lda     near w7e3184,y     ; command list
        cmp     near w7e340a       ; immediate action
        bne     @2179       ; branch if they don't match
        lda     #$ff
@2179:  sta     near w7e340a       ; set immediate action
        lda     #$ff
        sta     near w7e3184,y     ; clear command list slot
        lda     #$01        ; set counterattack flag
        tsb     zb1
        jmp     ExecCmd

; ------------------------------------------------------------------------------

; [ execute advance wait action ]

; called when an advance wait action reaches the top of the queue

_c22188:
_gaugefull:
@2188:  lda     #$80
        jsr     SetFlag1       ; set $3aa1.7
        lda     near wTargetProp2::w7e3aa0,x
        bit     #$50
        bne     @220a       ; return if $3aa0.4 or $3aa0.6 are set
        lda     near wTargetProp2::w7e3aa1,x     ; clear $3aa1.7, set $3aa1.0
        and     #$7f
        ora     #$01
        sta     near wTargetProp2::w7e3aa1,x
        jsr     QueueAction
        lda     near wTargetProp1::w7e32cc,x     ; return if character/monster has no actions pending in the command list
        bmi     @220a
        asl
        tay
        lda     near w7e3420,y     ; command
        cmp     #GFX_BATTLE_CMD::GFX_BATTLE_CMD_30
        bcs     @220a       ; return if >= $1e
        sta     near w7e2d6e + 1       ; battle script command (byte 1)
        cmp     #BATTLE_CMD::JUMP
        beq     @21bc       ; branch if command is $16 (jump)
        cpx     #$08
        bcc     @21e6       ; branch if a character
        bra     @220a       ; return if a monster

; jump
@21bc:  lda     near wTargetProp1::w7e3205,x
        bpl     @220a       ; branch if $3205.7 is clear
        longa
        cpx     #$08
        bcs     @21d3
        lda     #BATTLE_CMD::JUMP
        sta     near w7e3f28
        lda     near w7e3520,y
        sta     near w7e3f2a
@21d3:  lda     near wTargetMask,x
        tsb     near w7e3f2c
        shorta
        lda     near wTargetProp3::w7e3ef9,x
        ora     #STATUS4::HIDE
        sta     near wTargetProp3::w7e3ef9,x
        jsr     UpdateCharGfxBuf

; all character commands + monsters using jump
@21e6:  jsr     InitGfxScript
        jsr     ClearGfxParams
        longa
        lda     near w7e3520,y     ; load targets
        sta     zb8
        shorta
        lda     #GFX_CMD::ADVANCE_WAIT
        sta     near w7e2d6e::_0
        lda     #GFX_CMD::TERMINATE
        sta     near w7e2d6e::_1
        jsr     InitGfxParams
        jsr     CopyGfxParamsToBuf
        lda     #BTL_GFX::GFX_SCRIPT
        jsr     ExecBtlGfx
@220a:  jmp     BattleLoop

; ------------------------------------------------------------------------------
