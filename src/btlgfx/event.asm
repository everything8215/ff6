.include "battle_event_script.inc"

; ------------------------------------------------------------------------------

; [ battle script command $0f: execute battle event ]

; b1: battle event number

        array_label GFX_CMD, GFX_CMD::BATTLE_EVENT
        ldy     #1
        lda     (z76),y     ; battle event number
        cmp     #$1b
        beq     @fd77
        cmp     #$1f
        beq     @fd77
        inc     near w7ee9ef       ; stop battle time except for event $1b (gau) and $1f (wrexsoul)
@fd77:  lda     near w7e628c       ; branch if seamless scripts is enabled
        bne     @fd8f
        jsr     _c10df3       ; update hp/mp/status buffers
        .repeat 4
        jsl     array_item BTL_GFX, BTL_GFX::WAIT_FRAME   ; wait 4 frames
        .endrep
@fd8f:  inc     near w7ee9ef       ; stop battle time
        ldy     #1
        lda     (z76),y     ; battle event number
        longa
        asl
        tax
        lda     f:BattleEventScriptPtrs,x   ; get pointer to battle event script
        sta     z8f
        shorta0
        lda     #^BattleEventScript
        sta     z8f_B
@fda8:  lda     [z8f]       ; get battle event script command
        cmp     #BATTLE_EVENT_CMD::TERMINATE
        beq     @fdba       ; branch if end of script
        asl
        tax
        jsr     (near BattleEventCmdTbl,x)
        ldy     z8f         ; increment event script pointer
        iny
        sty     z8f
        bra     @fda8       ; next script command
@fdba:  stz     near w7ee9ef       ; start battle time
        rts

; ------------------------------------------------------------------------------

; battle event command jump table
BattleEventCmdTbl:
        ptr_tbl BATTLE_EVENT_CMD

; ------------------------------------------------------------------------------

; [ battle event command $13: add/remove character as a target ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::CHAR_TARGET
        jsl     AddCharTarget
        rts

; ------------------------------------------------------------------------------

; [ battle event command $14: add/remove character from top menu ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::CHAR_MENU
        jsl     AddCharToTopMenu
        jsr     DrawCharNames
        jsl     RedrawTopMenu
        rts

; ------------------------------------------------------------------------------

; pointers to event animation properties

EventAnimPropPtrs:
        .word   257 * 14  ; 00: terra/tritoch lightning
        .word   258 * 14  ; 01: blizzard fist (vargas)
        .word   259 * 14  ; 02: terra/tritoch lightning (w/o explosions)
        .word   260 * 14  ; 03: water splash (bg1)
        .word   261 * 14  ; 04: water splash (sprite)
        .word   262 * 14  ; 05: bahamut
        .word   263 * 14  ; 06: zoneseek
        .word   264 * 14  ; 07: fenrir
        .word   265 * 14  ; 08: shiva
        .word   266 * 14  ; 09: kirin
        .word   267 * 14  ; 0a: bismark
        .word   268 * 14  ; 0b: carbunkl
        .word   269 * 14  ; 0c: terrato
        .word   270 * 14  ; 0d: phantom
        .word   271 * 14  ; 0e: transform into magicite
        .word   294 * 14  ; 0f: puff of smoke (kefka/leo)
        .word   384 * 14  ; 10: statues lightning bolt (kefka/gestahl)
        .word   385 * 14  ; 11: black magic swirly (kefka/gestahl)
        .word   273 * 14  ; 12: move monster back (ultros, unused)
        .word   273 * 14  ; 13: move monster back (ultros, unused)

; ------------------------------------------------------------------------------

; [ clear battle script data ]

_c2fe21:
clr_magic_info:
@fe21:  clr_ax
@fe23:  sta     near w7e2c6e,x
        inx
        cpx     #$0010
        bne     @fe23
        rtl

; ------------------------------------------------------------------------------

; [ battle event command $0d: event animation ]

; b1: event animation number
; b2: attacker
; b3: target

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::ATTACK_ANIM
        jsl     _c2fe21     ; clear battle script data
        ldy     #1
        lda     [z8f],y     ; event animation number
        longa
        asl
        tax
        lda     f:EventAnimPropPtrs,x
        sta     $1e
        shorta0
        iny
        lda     [z8f],y                 ; attacker
        jsr     _c1fe99                 ; find actor
        sta     near w7e2c6e + 1                   ; set attacker
        iny
        lda     [z8f],y                 ; target
        bpl     @fe7a

; character target
        lda     near w7e2c6e + 1
        jsr     GetBitMask
        sta     near w7e2c6e + 2
        sta     near w7e2c6e + 4
        sta     near wAnimCharTargets                 ; character target mask
        stz     near wAnimMonsterTargets
        lda     #$00
        sta     near w7e2c6e
        lda     [z8f],y                 ; target
        cmp     #$ff
        bne     @fe8b
        lda     #$80
        sta     near w7e2c6e
        lda     #$04
        sta     near w7e2c6e + 1
        bra     @fe8b

; monster target
@fe7a:  sta     near w7e2c6e + 3
        sta     near w7e2c6e + 5
        sta     near wAnimMonsterTargets                 ; monster target mask
        stz     near wAnimCharTargets
        lda     #$40
        sta     near w7e2c6e
@fe8b:  longa
        inc     z8f                     ; increment battle event pointer
        inc     z8f
        inc     z8f
        shorta0
        jmp     InitEventAnimThreads

; ------------------------------------------------------------------------------

; [ find actor ]

_c1fe99:
get_cas_chg_local:
@fe99:  sta     $10
        clr_ax
        stz     $12
@fe9f:  lda     $10
        cmp     near wCharGfxDataBuf::CharID,x
        beq     @feb4       ; branch if actor matches
        inc     $12
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @fe9f
        clr_a
        rts
@feb4:  lda     $12
        and     #$03
        rts

; ------------------------------------------------------------------------------

; [ battle event command $12: animations for all characters ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::ALL_CHARS_ANIM
        clr_axy
@febc:  lda     near w7e6192                   ; characters in the party
        and     f:BitOrTbl,x
        beq     @ff02
        lda     near wCharGfxDataBuf::GfxID,y
        cmp     #$ff
        beq     @ff02

; if not victory fanfare, magitek characters use a different script pointer
        lda     near w7e628d                   ; victory fanfare
        bne     @feda
        lda     near wMagitekModeEnabled                   ; magitek mode
        beq     @feda
        lda     #$16
        bra     @feef

; dead, petrified, and a.i. characters use a different script pointer
@feda:  lda     near wCharGfxDataBuf::IsCharAI,y
        bne     @fee6
        lda     near wCharGfxDataBuf::ActiveStatus1,y
        andflg  STATUS1, {DEAD, PETRIFY}
        beq     @feea
@fee6:  lda     #$17
        bra     @feef

; otherwise, it's based on the character's graphics index
@feea:  lda     near wCharGfxDataBuf::GfxID,y
        and     #$1f
@feef:  asl
        inc
        phy
        tay
        longa
        lda     [z8f],y                 ; pointer to animation script
        sta     $24
        shorta0
        phx
        jsr     CreateCharEntryAnimThread
        plx
        ply
@ff02:  inx
        tya
        clc
        adc     #$20
        tay
        cpy     #$0080
        bne     @febc
        longa
        lda     z8f
        clc
        adc     #$0030
        sta     z8f
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ create an animation thread for character entry ]

; also used to create character victory fanfare animation threads

CreateCharEntryAnimThread:
        txa
        sta     $10
        sta     near w7e613f
        longa
        asl7
        tax
        lda     #make_word 1, 1
        sta     $22
        shorta0
        lda     $10
        sta     near w7e2c6e + 1
        stz     near w7e2c6e
        lda     #^BattleEventScript
        sta     $26
        jsr     CreateStandaloneThread
        rts

; ------------------------------------------------------------------------------

; [ clear animations (long access) ]

InitEventAnim_far:
@ff43:  jsr     InitEventAnim
        rtl

; ------------------------------------------------------------------------------

; [ battle event command $0e: init event animation ]

InitEventAnim:
        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::RESET_ANIM
        jsl     InitAnimVars
        jsr     ClearSpriteAnimFrameBuf
        jmp     ClearThreadData

; ------------------------------------------------------------------------------

; [ execute animations (long access) ]

ExecEventAnim_far:
@ff51:  jsr     ExecEventAnim
        rtl

; ------------------------------------------------------------------------------

; [ battle event command $0f: execute animations ]

ExecEventAnim:
        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::EXEC_ANIM
        jsr     ExecAnimScript
        stz     near w7e627d                 ; make sure we don't trigger odin death
        jsl     DeinitAnimVars
        rts

; ------------------------------------------------------------------------------

; [ battle event command $07-$0c: animation for monster ]

;  b0: 7 + monster slot
;  b1:
; +b2: pointer to animation data

        .repeat 6, i
        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::MONSTER_1_ANIM + i
        .endrep
        lda     [z8f]                   ; monster slot
        sec
        sbc     #3
        pha
        ldy     #1
        lda     [z8f],y
        clc
        adc     #4
        sta     $10
        ora     #$80
        sta     near w7e613f
        jmp     InitEventAnimScript

; ------------------------------------------------------------------------------

; [ battle event command $03-$06: animation for character ]

;  b0: 3 + character slot
;  b1: character id
; +b2: pointer to animation data

        .repeat 4, i
        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::CHAR_1_ANIM + i
        .endrep
        lda     [z8f]
        sec
        sbc     #3
        pha
        ldy     #1
        lda     [z8f],y                 ; character id
        sta     $10
        clr_axy
@ff88:  lda     near wCharGfxDataBuf::CharID,y
        cmp     $10
        beq     @ffa3
        tya
        clc
        adc     #$20
        tay
        inx
        cpx     #4
        bne     @ff88
        pla
        ldy     z8f
        iny3
        sty     z8f
        rts
@ffa3:  txa
        sta     $10
        sta     near w7e613f
; fallthrough

; ------------------------------------------------------------------------------

; [ add a character or monster event animation to the queue ]

InitEventAnimScript:
        pla                             ; A = target index
        longa
        asl7
        tax
        lda     #make_word 1, 1         ; 1x1 frame size
        sta     $22
        inc     z8f
        inc     z8f
        lda     [z8f]
        sta     $24
        inc     z8f
        shorta0
        lda     $10
        sta     near w7e2c6e + 1
        cmp     #4
        bcc     @ffd7

; monster attacker
        ora     #$80
        sta     $10
        lda     #$c0
        bra     @ffd8

; character attacker
@ffd7:  clr_a
@ffd8:  sta     near w7e2c6e
        lda     #^BattleEventScript
        sta     $26
        jsr     CreateStandaloneThread
        rts

; ------------------------------------------------------------------------------

; [ battle event command $02: no effect ]

        array_label BATTLE_EVENT_CMD, BATTLE_EVENT_CMD::BATTLE_EVENT_CMD_2
        rts

; ------------------------------------------------------------------------------

; unused
@ffe4:  rts

; ------------------------------------------------------------------------------

.pushseg
.segment "battle_event"

; d0/9800
BattleEventScriptPtrs:
        ptr_tbl BATTLE_EVENT_SCRIPT

; d0/9842
BattleEventScript:
        .include "battle_event_script.asm"
        .incbin "assets/data/btlgfx/battle_event_script.bin", 1589

.popseg

; ------------------------------------------------------------------------------
