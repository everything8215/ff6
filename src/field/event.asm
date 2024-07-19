
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: event.asm                                                            |
; |                                                                            |
; | description: event routines                                                |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

inc_lang "text/char_name_%s.inc"

.import MapSpritePal, EventScript, EventTriggerPtrs

.export BushidoLevelTbl, NaturalMagic, LevelUpExp, LevelUpHP, LevelUpMP

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init event script ]

.proc InitEvent
        ldx     $00
        stx     $e3         ; clear event pause counter
        stx     $e8         ; clear event stack
        ldx     #.loword(EventScript_NoEvent)
        stx     $e5
        lda     #^EventScript_NoEvent
        sta     $e7
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1          ; set event loop count
        sta     f:$0005c4
        lda     #$80        ; object to wait for
        sta     $e2
        stz     $e1         ; event not waiting for anything
        rts
.endproc  ; InitEvent

; ------------------------------------------------------------------------------

; event command jump table (starts at $35)
EventCmdTbl:
.repeat $100 - $35, i
        .addr .ident(.sprintf("EventCmd_%02x", i + $35))
.endrep

; ------------------------------------------------------------------------------

; [ execute events ]

.proc ExecEvent
        inc     $47
        lda     $84
        bne     continue_event
        lda     $58
        bne     :+
        lda     $47
        and     #$03
        bne     continue_event
:       jsr     _c0714a

continue_event:
        ldx     $e3                     ; decrement event pause counter
        beq     :+
        dex
        stx     $e3
        rts
:       lda     $0798                   ; check if waiting to update party characters
        beq     :+
done:   rts
:       lda     $055a                   ; check if bg is waiting for update
        beq     :+
        cmp     #$05
        bne     done
:       lda     $055b
        beq     :+
        cmp     #$05
        bne     done
:       lda     $055c
        beq     :+
        cmp     #$05
        bne     done
:       jsr     UpdateCtrlFlags

; check if waiting for object
        lda     $e1
        bpl     check_wait_fade         ; branch if not waiting for object
        lda     $e2
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        lda     $087c,y
        and     #$0f
        beq     :+
        rts
:       lda     $e1
        and     #$7f
        sta     $e1
        bra     exec_cmd

; check if waiting for screen to fade
check_wait_fade:
        lda     $e1
        and     #$40
        beq     check_wait_scroll       ; branch if not waiting for fade
        lda     $4a
        beq     :+
        rts
:       lda     $e1
        and     #$bf
        sta     $e1
        rts

; check if waiting for screen to scroll
check_wait_scroll:
        lda     $e1
        and     #$20
        beq     exec_cmd                ; branch if not waiting for scroll
        lda     $0541
        cmp     $0557
        beq     :+
        inc
        cmp     $0557
        beq     :+
        dec2
        cmp     $0557
        bne     done2
:       lda     $0542
        cmp     $0558
        beq     :+
        inc
        cmp     $0558
        beq     :+
        dec2
        cmp     $0558
        beq     :+
done2:  rts
:       lda     $e1
        and     #$df
        sta     $e1
        ldx     $00
        stx     $0547
        stx     $0549
        stx     $054b
        stx     $054d
        stx     $054f
        stx     $0551

exec_cmd:
        ldy     #5
        lda     [$e5],y
        sta     $ef
        dey
        lda     [$e5],y
        sta     $ee
        dey
        lda     [$e5],y
        sta     $ed
        dey
        lda     [$e5],y
        sta     $ec
        dey
        lda     [$e5],y
        sta     $eb
        dey
        lda     [$e5],y
        sta     $ea
        cmp     #$31
        jcc     InitObjScript
        cmp     #$35
        jcc     ExecPartyObjScript

; execute event command
        sec
        sbc     #$35
        longa
        asl
        tax
        lda     f:EventCmdTbl,x         ; event command table
        sta     $2a
        shorta0
        jmp     ($002a)                 ; jump to event command code
.endproc  ; ExecEvent

ContinueEvent := ExecEvent::continue_event

; ------------------------------------------------------------------------------

; [ increment event pointer and continue ]

; A: number of bytes to increment event pc by

.proc IncEventPtrContinue
        clc                 ; increment event pointer
        adc     $e5
        sta     $e5
        lda     $e6
        adc     #0
        sta     $e6
        lda     $e7
        adc     #0
        sta     $e7
        jmp     ContinueEvent
.endproc  ; IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ increment event pointer and return ]

.proc IncEventPtrReturn
        clc
        adc     $e5
        sta     $e5
        lda     $e6
        adc     #0
        sta     $e6
        lda     $e7
        adc     #0
        sta     $e7
        rts
.endproc  ; IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ push event pointer ]

; A: number of bytes to increment event pc by

.proc PushEventPtr
        ldx     $e8
        clc
        adc     $e5         ; event pc += a
        sta     $e5
        sta     $05f4,x
        lda     $e6
        adc     #0
        sta     $e6
        sta     $05f5,x
        lda     $e7
        adc     #0
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8
        rts
.endproc  ; PushEventPtr

; ------------------------------------------------------------------------------

; [ begin object script ]

; A: object index

.proc InitObjScript
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
start:  lda     $087c,y                 ; set movement type to script controlled
        and     #$f0
        ora     #$01
        sta     $087c,y
        tdc
        sta     $0886,y                 ; clear number of steps to take
        lda     $e5                     ; event pc
        clc
        adc     #$02
        sta     $0883,y                 ; set object script pointer
        lda     $e6
        adc     #$00
        sta     $0884,y
        lda     $e7
        adc     #$00
        sta     $0885,y
        lda     $eb                     ; branch if not waiting until complete
        bpl     async
        lda     $ea                     ; get object number
        cmp     #$31
        bcc     :+
        sec
        sbc     #$31
        asl
        tay
        ldx     $0803,y
        stx     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
:       sta     $e2                     ; set object to wait for
        lda     #$80                    ; waiting for object script
        sta     $e1

async:  lda     $eb                     ; add object script length + 2 to event pc
        and     #$7f
        inc2
        jmp     IncEventPtrContinue
.endproc  ; InitObjScript

; ------------------------------------------------------------------------------

; [ begin object script (party character) ]

; A: object index

.proc ExecPartyObjScript
        sec
        sbc     #$31
        asl
        tax
        ldy     $0803,x                 ; pointer to object data
        cpy     #$07b0
        beq     :+                      ; branch if there's no character in that slot
        lda     $0867,y                 ; character's party
        and     #$07
        cmp     $1a6d                   ; branch if not in current party
        bne     :+
        sty     hWRDIVL
        lda     #$29                    ; divide by $29 to get character index
        sta     hWRDIVB
        nop8
        lda     hRDDIVL
        sta     $ea
        jmp     InitObjScript::start
:       lda     #$31                    ; use showing character
        sta     $ea
        ldy     #$07d9
        jmp     InitObjScript::start
.endproc  ; ExecPartyObjScript

; ------------------------------------------------------------------------------

; [ event command $35: wait for object ]

; $eb: object number

.proc EventCmd_35
        lda     $eb
        cmp     #$31        ; branch if not a party character
        bcc     :+
        sec
        sbc     #$31
        asl
        tay
        ldx     $0803,y     ; get pointer to party character object data
        stx     hWRDIVL
        lda     #$29        ; divide by $29 to get character number
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
:       sta     $e2         ; object to wait for
        lda     #$80
        sta     $e1         ; waiting for object
        lda     #2
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_35

; ------------------------------------------------------------------------------

; [ event command $36: disable object passability ]

; $eb: object number

.proc EventCmd_36
        jsr     CalcObjPtr
        lda     $087c,y
        and     #$ef
        sta     $087c,y
        lda     #2
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_36

; ------------------------------------------------------------------------------

; [ event command $78: enable object passability ]

; $eb: object number

.proc EventCmd_78
        jsr     CalcObjPtr
        lda     $087c,y
        ora     #$10
        sta     $087c,y
        lda     #2
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_78

; ------------------------------------------------------------------------------

; [ event command $37: set object graphics ]

; $eb: object number
; $ec: graphics index

.proc EventCmd_37
        jsr     CalcObjPtr
        lda     $ec
        sta     $0879,y                 ; set object graphics index
        jsr     CalcCharPtr
        cpy     #$0250
        bcs     :+                      ; branch if not a character
        lda     $ec
        sta     $1601,y                 ; set character graphics index
:       lda     #3
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_37

; ------------------------------------------------------------------------------

; [ event command $43: set object palette ]

; $eb: object number
; $ec: palette index

.proc EventCmd_43
        jsr     CalcObjPtr
        lda     $ec
        asl
        sta     $1a
        lda     $0880,y     ; set palette (upper sprite)
        and     #$f1
        ora     $1a
        sta     $0880,y
        lda     $0881,y     ; set palette (lower sprite)
        and     #$f1
        ora     $1a
        sta     $0881,y
        lda     #3
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_43

; ------------------------------------------------------------------------------

; [ event command $44: set object vehicle ]

; $eb: object number
; $ec: svv-----
;        s: character shown
;        v: vehicle index (0 = no vehicle, 1 = chocobo, 2 = magitek, 3 = raft)

.proc EventCmd_44
        jsr     CalcObjPtr
        lda     $ec
        and     #$e0
        sta     $1a
        lda     $0868,y
        and     #$1f
        ora     $1a
        sta     $0868,y
        lda     #3
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_44

; ------------------------------------------------------------------------------

; [ event command $45: validate and sort active objects ]

.proc EventCmd_45
        lda     #1
        sta     $0798
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_45

; ------------------------------------------------------------------------------

; [ event command $46: activate party ]

; $eb: party number (0..7)

.proc EventCmd_46
        lda     $eb
        sta     $1a6d       ; set party
        ldy     #$07d9
        sty     $07fb       ; clear party character object data pointers
        sty     $07fd
        sty     $07ff
        sty     $0801
        lda     #2
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_46

; ------------------------------------------------------------------------------

; [ event command $47: update party objects ]

.proc EventCmd_47
        jsr     GetTopChar
        jsr     PushCharFlags
        lda     #1
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_47

; ------------------------------------------------------------------------------

; [ event command $38: lock screen ]

.proc EventCmd_38
        lda     #1
        sta     $0559
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_38

; ------------------------------------------------------------------------------

; [ event command $39: unlock screen ]

.proc EventCmd_39
        stz     $0559
        lda     #1
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_39

; ------------------------------------------------------------------------------

; [ event command $3a: make party user-controlled ]

.proc EventCmd_3a
        ldy     $0803
        lda     #$02
        sta     $087c,y
        sta     $087d,y
        lda     #1
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_3a

; ------------------------------------------------------------------------------

; [ event command $3b: make party script-controlled ]

.proc EventCmd_3b
        ldy     $0803
        lda     #$01
        sta     $087c,y
        lda     #1
        jmp     IncEventPtrContinue
.endproc  ; EventCmd_3b

; ------------------------------------------------------------------------------

; [ event command $3f: add character to party ]

; $eb: character number
; $eb: party number (0..7, 0 = remove from party)

EventCmd_3f:
@9d3b:  jsr     PopCharFlags
        lda     $ec
        jsr     FindEmptyCharSlot
        ora     $ec
        sta     $1a
        jsr     CalcObjPtr
        lda     $0867,y
        and     #$e0
        ora     $1a
        sta     $0867,y     ; set party and battle slot in object data
        sta     $1a
        tdc
        sta     $087d,y     ; clear saved movement type
        jsr     GetTopCharPtr
        lda     $eb
        tay
        lda     $1a
        sta     $1850,y     ; set party and battle slot in character data
        jsr     UpdateEquip
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3c: set party characters ]

; $eb: slot 0 character
; $ec: slot 1 character ($ff = empty slot)
; $ed: slot 2 character ($ff = empty slot)
; $ee: slot 3 character ($ff = empty slot)

EventCmd_3c:
@9d6d:  ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        jsr     CalcObjPtr
        sty     $07fb
        lda     $ec
        bmi     @9da3
        sta     $eb
        jsr     CalcObjPtr
        sty     $07fd
        lda     $ed
        bmi     @9da3
        sta     $eb
        jsr     CalcObjPtr
        sty     $07ff
        lda     $ee
        bmi     @9da3
        sta     $eb
        jsr     CalcObjPtr
        sty     $0801
@9da3:  lda     #$01
        sta     $0798
        lda     #5
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ calculate pointer to character data ]

; $eb: object number

CalcCharPtr:
@9dad:  lda     $eb
        cmp     #$31
        bcc     @9de0
        sec
        sbc     #$31
        asl
        tax
        ldy     $0803,x
        cpy     #$07b0
        beq     @9dde
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @9dde
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        bra     @9de0
@9dde:  lda     #$11
@9de0:  sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        rts

; ------------------------------------------------------------------------------

; [ calculate pointer to object data ]

; $eb: object number

CalcObjPtr:
@9df0:  lda     $eb
        cmp     #$31
        bcc     @9e2b
        sec
        sbc     #$31
        asl
        tax
        ldy     $0803,x
        cpy     #$07b0
        beq     @9e23
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @9e23
        sty     hWRDIVL
        lda     #$29
        sta     hWRDIVB
        nop8
        lda     hRDDIVL
        sta     $eb
        rts
@9e23:  ldy     #$07d9
        lda     #$31
        sta     $eb
        rts
@9e2b:  lda     $eb
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop3
        ldy     hRDMPYL
        rts

; ------------------------------------------------------------------------------

; [ event command $3d: create object ]

; $eb: object number

EventCmd_3d:
@9e3c:  jsr     CalcObjPtr
        lda     $0867,y     ; return if object is already enabled
        and     #$40
        bne     @9e62
        lda     $0867,y     ; enable object, not visible
        and     #$3f
        ora     #$40
        sta     $0867,y
        jsr     StartObjAnim
        lda     $eb
        cmp     #$10
        bcs     @9e62       ; return if not a character object
        tay
        lda     $1850,y     ; enable object in character data
        ora     #$40
        sta     $1850,y
@9e62:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $3e: delete object ]

; $eb: object number

EventCmd_3e:
@9e67:  jsr     CalcObjPtr
        lda     $0867,y     ; return if object is already disabled
        and     #$40
        beq     @9e9d
        lda     $0867,y     ; disable object, not visible
        and     #$3f
        sta     $0867,y
        tdc
        sta     $087d,y     ; clear saved movement type
        jsr     StopObjAnim
        phy
        jsr     GetTopCharPtr
        ply
        ldx     $087a,y     ; pointer to object map data
        lda     #$ff
        sta     $7e2000,x   ; clear map data
        lda     $eb
        cmp     #$10
        bcs     @9e9d       ; branch if not a character object
        tay
        lda     $1850,y     ; disable object in character data
        and     #$3f
        sta     $1850,y
@9e9d:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ get next available character slot in party ]

; A: party number (0..7)

FindEmptyCharSlot:
@9ea2:  sta     $1a
        cmp     #$00
        beq     @9ed4                   ; return if no party
        ldy     $00
@9eaa:  lda     $0867,y                 ; branch if character is not enabled
        and     #$40
        beq     @9ec3
        lda     $0867,y                 ; branch if character is not in that party
        and     #$07
        cmp     $1a
        bne     @9ec3
        lda     $0867,y
        and     #$18
        cmp     #$00
        beq     @9ed5
@9ec3:  longa
        tya
        clc
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @9eaa
        tdc                             ; slot 1
@9ed4:  rts

; try slot 2
@9ed5:  ldy     $00
@9ed7:  lda     $0867,y
        and     #$40
        beq     @9ef0
        lda     $0867,y
        and     #$07
        cmp     $1a
        bne     @9ef0
        lda     $0867,y
        and     #$18
        cmp     #$08
        beq     @9f02
@9ef0:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @9ed7
        lda     #$08                    ; slot 2
        rts

; try slot 3
@9f02:  ldy     $00
@9f04:  lda     $0867,y
        and     #$40
        beq     @9f1d
        lda     $0867,y
        and     #$07
        cmp     $1a
        bne     @9f1d
        lda     $0867,y
        and     #$18
        cmp     #$10
        beq     @9f2f
@9f1d:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @9f04
        lda     #$10                    ; slot 3
        rts

; give up and use slot 4 (even if it's already occupied)
@9f2f:  lda     #$18                    ; slot 4
        rts

; ------------------------------------------------------------------------------

; [ event command $77: normalize character level ]

; $eb: character number

EventCmd_77:
@9f32:  jsr     CalcAverageLevel
        pha
        jsr     CalcCharPtr
        lda     $1608,y     ; character level
        dec
        sta     $20         ; +$20 = previous level - 1
        stz     $21
        pla
        cmp     $1608,y
        bcc     @9f70       ; branch if average is less than character level
        sta     $1608,y     ; set character level to average
        dec
        sta     $22         ; +$22 = new level - 1
        stz     $23
        jsr     UpdateMaxHP
        jsr     UpdateMaxMP
        lda     $160b,y     ; set hp to maximum
        sta     $1609,y
        lda     $160c,y
        sta     $160a,y
        lda     $160f,y     ; set mp to maximum
        sta     $160d,y
        lda     $1610,y
        sta     $160e,y
        jsr     UpdateAbilities
@9f70:  jsr     UpdateExp
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ calculate average character level ]

CalcAverageLevel:
@9f78:  ldx     $1ede       ; +$20 = characters available
        stx     $20
        ldx     $00
        txy
        stx     $1e         ; +$1e = sum of available characters' levels
        stz     $1b         ;  $1b = number of active characters
@9f84:  longa_clc
        lsr     $20
        shorta0
        bcc     @9f9d
        lda     $1e
        clc
        adc     $1608,x     ; character level
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inc     $1b
@9f9d:  iny                 ; next character
        longa_clc
        txa
        adc     #$0025
        tax
        shorta0
        cpy     #$000e
        bne     @9f84
        ldx     $1e
        stx     hWRDIVL
        lda     $1b
        beq     @9fc5
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        bra     @9fc7
@9fc5:  lda     #$03        ; minimum 3
@9fc7:  cmp     #$63
        bcc     @9fcd
        lda     #$63        ; maximum 99
@9fcd:  rts

; ------------------------------------------------------------------------------

; [ event command $8d: remove character equipped items/esper ]

EventCmd_8d:
@9fce:  lda     $eb         ; calculate pointer to character data
        sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop2
        ldy     #$0006
        ldx     hRDMPYL
        lda     #$ff
        sta     $161e,x     ; remove esper
@9fe5:  phy
        phx
        lda     $161f,x     ; item slot
        cmp     #$ff
        beq     @a02c       ; branch if no item in this slot
        sta     $1a         ; $1a = item number
        lda     #$ff
        sta     $161f,x     ; clear item slot
        ldx     $00
@9ff7:  lda     $1869,x     ; look for item in inventory
        cmp     $1a
        beq     @a021       ; branch if found
        inx
        cpx     #$0100
        bne     @9ff7
        ldx     $00
@a006:  lda     $1869,x     ; look for next available item slot
        cmp     #$ff
        beq     @a015
        inx
        cpx     #$0100
        bne     @a006
        bra     @a02c       ; branch if there are no available item slots
@a015:  lda     $1a
        sta     $1869,x     ; set item number
        lda     #$01
        sta     $1969,x     ; item quantity = 1
        bra     @a02c
@a021:  lda     $1969,x     ; branch if item quantity is 99
        cmp     #$63
        beq     @a02c
        inc                 ; increment quantity
        sta     $1969,x
@a02c:  plx                 ; next item
        ply
        inx
        dey
        bne     @9fe5
        jsr     UpdateEquip
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7f: set character name ]

; $eb: character number
; $ec: name index

EventCmd_7f:
@a03a:  jsr     CalcCharPtr
        lda     #6                      ; calculate pointer to character name
        sta     hWRMPYA
        lda     $ec
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
.repeat 6, i
        lda     f:CharName+i,x          ; copy character name (6 bytes)
        sta     $1602+i,y
.endrep
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $40: set character properties ]

; $eb: character number
; $ec: actor number

EventCmd_40:
@a07c:  jsr     CalcCharPtr
        lda     #$16        ; calculate pointer to actor properties
        sta     hWRMPYA
        lda     $ec
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     f:CharProp+2,x   ; battle commands
        sta     $1616,y
        lda     f:CharProp+3,x
        sta     $1617,y
        lda     f:CharProp+4,x
        sta     $1618,y
        lda     f:CharProp+5,x
        sta     $1619,y
        lda     f:CharProp+6,x   ; vigor
        sta     $161a,y
        lda     f:CharProp+7,x   ; speed
        sta     $161b,y
        lda     f:CharProp+8,x   ; stamina
        sta     $161c,y
        lda     f:CharProp+9,x   ; mag. power
        sta     $161d,y
        lda     #$ff        ; clear esper
        sta     $161e,y
        lda     f:CharProp+15,x   ; weapon
        sta     $161f,y
        lda     f:CharProp+16,x   ; shield
        sta     $1620,y
        lda     f:CharProp+17,x   ; helmet
        sta     $1621,y
        lda     f:CharProp+18,x   ; armor
        sta     $1622,y
        lda     f:CharProp+19,x   ; relics
        sta     $1623,y
        lda     f:CharProp+20,x
        sta     $1624,y
        lda     f:CharProp,x   ; max hp
        sta     $160b,y
        lda     f:CharProp+1,x   ; max mp
        sta     $160f,y
        tdc
        sta     $160c,y
        sta     $1610,y
        phx
        phy
        lda     $ec         ; actor
        sta     $1600,y
        jsr     CalcAverageLevel
        ply
        plx
        sta     $1608,y     ; set level
        lda     f:CharProp+21,x   ; level modifier
        and     #LEVEL_MOD_MASK
        lsr2
        tax
        lda     f:CharLevelModTbl,x   ; add level modifier
        clc
        adc     $1608,y
        beq     @a12f
        bpl     @a131
@a12f:  lda     #1          ; minimum level = 1
@a131:  cmp     #99         ; maximum level = 99
        bcc     @a137
        lda     #99
@a137:  sta     $1608,y
        jsr     InitMaxHP
        lda     $160b,y     ; set hp to max
        sta     $1609,y
        lda     $160c,y
        sta     $160a,y
        jsr     InitMaxMP
        lda     $160f,y     ; set mp to max
        sta     $160d,y
        lda     $1610,y
        sta     $160e,y
        jsr     UpdateExp
        tyx
        jsr     CalcObjPtr
        lda     $087c,y     ; set movement type to script-controlled
        and     #$f0
        ora     #$01
        sta     $087c,y
        lda     $0868,y     ; enable walking animation
        ora     #$01
        sta     $0868,y
        lda     #$00        ; clear object settings
        sta     $0867,y
        txy
        jsr     UpdateAbilities
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ update character natural skills ]

; y: pointer to character data

UpdateAbilities:
@a17f:  lda     $1600,y                 ; actor index
        cmp     #CHAR::TERRA
        beq     @a196                   ; branch if terra
        cmp     #CHAR::CELES
        beq     @a1b8                   ; branch if celes
        cmp     #CHAR::CYAN
        beq     @a1da                   ; branch if cyan
        cmp     #CHAR::SABIN
        jeq     @a201                   ; branch if sabin
@a195:  rts

; update terra's natural magic
@a196:  ldx     $00
@a198:  lda     f:NaturalMagic+1,x      ; level that the spell is learned
        cmp     $1608,y                 ; current level
        beq     @a1a3
        bcs     @a195                   ; return if greater than current level
@a1a3:  phy
        lda     f:NaturalMagic,x        ; spell number
        tay
        lda     #$ff
        sta     $1a6e,y                 ; learn spell
        ply
        inx2                            ; next natural spell (16 total)
        cpx     #$0020
        beq     @a195
        bra     @a198

; update celes' natural magic
@a1b8:  ldx     $00
@a1ba:  lda     f:NaturalMagic+$21,x    ; level that the spell is learned
        cmp     $1608,y                 ; current level
        beq     @a1c5
        bcs     @a195                   ; return if greater than current level
@a1c5:  phy
        lda     f:NaturalMagic+$20,x    ; spell number
        tay
        lda     #$ff
        sta     $1bb2,y                 ; learn spell
        ply
        inx2                            ; next natural spell (16 total)
        cpx     #$0020
        beq     @a195
        bra     @a1ba

; update cyan's swdtech
@a1da:  stz     $1b
        ldx     $00
@a1de:  lda     f:BushidoLevelTbl,x
        cmp     $1608,y
        beq     @a1e9
        bcs     @a1f3
@a1e9:  inc     $1b
        inx
        cpx     #8
        beq     @a1f3
        bra     @a1de
@a1f3:  lda     $1b
        tax
        lda     $1cf7
        ora     f:LearnAbilityTbl,x
        sta     $1cf7
        rts

; update sabin's blitz
@a201:  stz     $1b
        ldx     $00
@a205:  lda     f:BlitzLevelTbl,x
        cmp     $1608,y
        beq     @a210
        bcs     @a21a
@a210:  inc     $1b
        inx
        cpx     #8
        beq     @a21a
        bra     @a205
@a21a:  lda     $1b
        tax
        lda     $1d28
        ora     f:LearnAbilityTbl,x
        sta     $1d28
        rts

; ------------------------------------------------------------------------------

; character average level modifiers
CharLevelModTbl:
@a228:  .byte   0,2,5,<(-3)

; swdtech/blitz learn flags
LearnAbilityTbl:
@a22c:  .byte   $00,$01,$03,$07,$0f,$1f,$3f,$7f,$ff

.pushseg
.segment "bushido_blitz_level"

; e6/f490
BushidoLevelTbl:
        .byte   1,6,12,15,24,34,44,70

; e6/f498
BlitzLevelTbl:
        .byte   1,6,10,15,23,30,42,70

.segment "natural_magic"

; ec/e3c0
NaturalMagic:

; terra
        .byte ATTACK::CURE, 1
        .byte ATTACK::FIRE, 3
        .byte ATTACK::ANTDOT, 6
        .byte ATTACK::DRAIN, 12
        .byte ATTACK::LIFE, 18
        .byte ATTACK::FIRE_2, 22
        .byte ATTACK::WARP, 26
        .byte ATTACK::CURE_2, 33
        .byte ATTACK::DISPEL, 37
        .byte ATTACK::FIRE_3, 43
        .byte ATTACK::LIFE_2, 49
        .byte ATTACK::PEARL, 57
        .byte ATTACK::BREAK, 68
        .byte ATTACK::QUARTR, 75
        .byte ATTACK::MERTON, 86
        .byte ATTACK::ULTIMA, 99

; celes
        .byte ATTACK::ICE, 1
        .byte ATTACK::CURE, 4
        .byte ATTACK::ANTDOT, 8
        .byte ATTACK::IMP, 13
        .byte ATTACK::SCAN, 18
        .byte ATTACK::SAFE, 22
        .byte ATTACK::ICE_2, 26
        .byte ATTACK::HASTE, 32
        .byte ATTACK::BSERK, 40
        .byte ATTACK::MUDDLE, 32
        .byte ATTACK::ICE_3, 42
        .byte ATTACK::VANISH, 48
        .byte ATTACK::HASTE2, 52
        .byte ATTACK::PEARL, 72
        .byte ATTACK::FLARE, 81
        .byte ATTACK::METEOR, 98

.popseg

; ------------------------------------------------------------------------------

; [ update character experience points ]

; y: pointer to character data

UpdateExp:
@a235:  lda     $1608,y     ; $1b = current level
        sta     $1b
        ldx     $00
        stx     $2a         ; ++$2a = calculated experience points
        stz     $2c
@a240:  dec     $1b
        beq     @a25c       ; branch at current level
        longa
        lda     f:LevelUpExp,x   ; add experience progression value
        clc
        adc     $2a
        sta     $2a
        shorta0
        lda     $2c
        adc     #$00
        sta     $2c
        inx2                ; next level
        bra     @a240
@a25c:  asl     $2a         ; ++$2a *= 8
        rol     $2b
        rol     $2c
        asl     $2a
        rol     $2b
        rol     $2c
        asl     $2a
        rol     $2b
        rol     $2c
        lda     $2a         ; set character experience points
        sta     $1611,y
        lda     $2b
        sta     $1612,y
        lda     $2c
        sta     $1613,y
        rts

.pushseg
.segment "level_up_exp"

LevelUpExp:
        .word   4,8,14,24,34,48,62,79  ; 2-9
        .word   99,120,143,169,195,224,257,289,323,360  ; 10-19
        .word   402,441,484,528,575,627,674,728,785,842  ; 20-29
        .word   899,961,1025,1088,1157,1224,1296,1370,1443,1522  ; 30-39
        .word   1599,1680,1763,1850,1936,2024,2117,2208,2305,2401  ; 40-49
        .word   2500,2602,2704,2808,2916,3024,3137,3248,3365,3481  ; 50-59
        .word   3599,3722,3843,3970,4096,4224,4357,4488,4625,4762  ; 60-69
        .word   4899,5041,5183,5330,5477,5625,5774,5929,6083,6241  ; 70-79
        .word   6400,6562,6724,6888,7056,7225,7397,7569,7743,7921  ; 80-89
        .word   8100,8282,8464,8648,8836,9025,9217,9409,9603,11111  ; 90-99

.popseg

; ------------------------------------------------------------------------------

; [ init character max hp ]

; y = pointer to character data

InitMaxHP:
@a27e:  lda     #$16
        sta     hWRMPYA
        lda     $1600,y
        sta     hWRMPYB
        lda     $1608,y
        sta     $1b
        stz     $1f
        ldx     hRDMPYL
        lda     f:CharProp,x               ; starting hp
        sta     $1e
        ldx     $00
@a29b:  dec     $1b
        beq     @a2b1
        lda     f:LevelUpHP,x
        clc
        adc     $1e
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @a29b
@a2b1:  longa_clc
        lda     $1e
        sta     $160b,y
        shorta0
        rts

.pushseg
.segment "level_up_hp"

; e6/f4a0
LevelUpHP:
        .byte   11,12,14,17,20,22,24,26  ; 2-9
        .byte   27,28,30,35,39,44,50,54,57,61  ; 10-19
        .byte   65,67,69,72,76,79,82,86,90,95  ; 20-29
        .byte   99,100,101,102,102,103,104,106,107,108  ; 30-39
        .byte   110,111,113,114,116,117,119,120,122,125  ; 40-49
        .byte   128,130,131,133,134,136,137,139,142,144  ; 50-59
        .byte   145,147,148,150,152,153,155,156,158,160  ; 60-69
        .byte   162,160,155,151,145,140,136,132,126,120  ; 70-79
        .byte   117,113,110,108,105,102,100,98,95,92  ; 80-89
        .byte   90,88,87,85,83,82,80,83,86,88  ; 90-99

.popseg

; ------------------------------------------------------------------------------

; [ init character max mp ]

; y = pointer to character data

InitMaxMP:
@a2bc:  lda     #$16
        sta     hWRMPYA
        lda     $1600,y
        sta     hWRMPYB
        lda     $1608,y
        sta     $1b
        stz     $1f
        ldx     hRDMPYL
        lda     f:CharProp+1,x   ; starting mp
        sta     $1e
        ldx     $00
@a2d9:  dec     $1b
        beq     @a2ef
        lda     f:LevelUpMP,x
        clc
        adc     $1e
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @a2d9
@a2ef:  longa_clc
        lda     $1e
        sta     $160f,y
        shorta0
        rts

; ------------------------------------------------------------------------------

.pushseg
.segment "level_up_mp"

; e6/f502
LevelUpMP:

.if LANG_EN
        .byte   4,4,5,5,6,6,7,8  ; 2-9
        .byte   8,9,9,10,10,10,10,10,11,11  ; 10-19
        .byte   11,11,11,12,12,12,12,12,13,13  ; 20-29
        .byte   13,13,13,14,14,14,14,14,15,15  ; 30-39
        .byte   15,15,15,16,16,16,16,16,17,17  ; 40-49
        .byte   17,16,15,14,13,12,11,10,9,8  ; 50-59
        .byte   7,6,5,5,6,6,7,7,7,8  ; 60-69
        .byte   8,8,8,8,7,7,7,6,6,6  ; 70-79
        .byte   6,5,5,5,5,5,5,5,6,6  ; 80-89
        .byte   6,6,6,7,8,9,10,11,12,13  ; 90-99
.else

        .byte   $05,$06,$07,$08,$09,$0a,$0b,$0c  ; 2-9
        .byte   $0d,$0e,$0f,$10,$11,$11,$11,$11,$10,$10  ; 10-19
        .byte   $10,$0f,$0f,$0f,$0e,$0e,$0e,$0e,$0d,$0d  ; 20-29
        .byte   $0d,$0d,$0c,$0c,$0c,$0c,$0b,$0b,$0b,$0b  ; 30-39
        .byte   $0b,$0b,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a  ; 40-49
        .byte   $09,$09,$09,$09,$09,$09,$09,$09,$09,$09  ; 50-59
        .byte   $0a,$08,$08,$08,$08,$08,$08,$08,$08,$08  ; 60-69
        .byte   $08,$0a,$0a,$07,$06,$05,$04,$05,$06,$07  ; 70-79
        .byte   $08,$09,$08,$07,$06,$05,$06,$07,$05,$06  ; 80-89
        .byte   $07,$08,$09,$0a,$08,$08,$09,$0a,$0b,$0d  ; 90-99

.endif

.popseg

; ------------------------------------------------------------------------------

; [ event command $41: show object ]

; $eb = object number

EventCmd_41:
@a2fa:  jsr     CalcObjPtr
        lda     $0867,y
        and     #$40
        beq     @a331       ; return if object is not enabled
        lda     $0867,y     ; return if object is already visible
        bmi     @a331
        ora     #$80        ; make object visible
        sta     $0867,y
        lda     $0880,y     ; set top sprite layer priority to 2
        and     #$cf
        ora     #$20
        sta     $0880,y
        lda     $0881,y     ; set bottom sprite layer priority to 2
        and     #$cf
        ora     #$20
        sta     $0881,y
        lda     $eb         ; return if not a character object
        cmp     #$10
        bcs     @a331
        tay
        lda     $1850,y     ; set character object settings
        ora     #$80
        sta     $1850,y
@a331:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $42: hide object ]

; $eb = object number

EventCmd_42:
@a336:  jsr     CalcObjPtr
        lda     $0867,y
        and     #$7f
        sta     $0867,y
        tdc
        sta     $087d,y
        ldx     $087a,y
        lda     #$ff
        sta     $7e2000,x
        lda     $087c,y
        and     #$f0
        sta     $087c,y
        lda     $eb
        cmp     #$10
        bcs     @a365
        tay
        lda     $1850,y
        and     #$7f
        sta     $1850,y
@a365:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $79: set party's map ]

;  $eb = party number
; +$ec = map number

EventCmd_79:
@a36a:  ldy     $00
@a36c:  lda     $0867,y
        and     #$40
        beq     @a386
        lda     $0867,y
        and     #$07
        cmp     $eb
        bne     @a386       ; branch if character is not in that party
        longa
        lda     $ec
        sta     $088d,y     ; set character object's map
        shorta0
@a386:  longa_clc        ; next character
        tya
        adc     #$0029
        tay
        shorta0
        cpy     #$0290
        bne     @a36c
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7e: move current party ]

; $eb = x position
; $ec = y position

EventCmd_7e:
@a39a:  longa
        lda     $eb
        and     #$00ff
        asl4
        sta     $26
        lda     $ec
        and     #$00ff
        asl4
        sta     $28
        shorta0
        ldy     $00
        stz     $1b
@a3b9:  lda     $0867,y
        and     #$40
        beq     @a3fa
        lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @a3fa
        ldx     $087a,y
        lda     $7e2000,x
        cmp     $1b
        bne     @a3db
        lda     #$ff
        sta     $7e2000,x
@a3db:  longa
        lda     $26
        sta     $086a,y
        lda     $28
        sta     $086d,y
        shorta0
        sta     $0869,y
        sta     $086c,y
        lda     $eb
        sta     $087a,y
        lda     $ec
        sta     $087b,y
@a3fa:  longa_clc        ; next character
        tya
        adc     #$0029
        tay
        shorta0
        inc     $1b
        inc     $1b
        cpy     #$0290
        bne     @a3b9
        lda     #$01        ; re-load the same map
        sta     $58
        lda     $eb         ; set global map position
        sta     $1fc0
        sta     $1f66
        lda     $ec
        sta     $1fc1
        sta     $1f67
        lda     #$01        ; enable map load
        sta     $84
        lda     #3
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $7a: set object's event pointer ]

;   $eb = object number
; ++$ec = event pointer

EventCmd_7a:
@a42a:  jsr     CalcObjPtr
        lda     $ec
        sta     $0889,y     ; set event pointer
        lda     $ed
        sta     $088a,y
        lda     $ee
        sta     $088b,y
        lda     #5
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7b: restore default party ]

EventCmd_7b:
@a441:  lda     $055d
        cmp     $1a6d       ; return if default party is already active
        beq     @a450
        dec
        sta     $1a6d       ; set current party
        jsr     ChangeParty
@a450:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7c: enable collision activation ]

; $eb = object number

EventCmd_7c:
@a455:  jsr     CalcObjPtr
        lda     $087c,y
        ora     #$40
        sta     $087c,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $7d: disable collision activation ]

; $eb = object number

EventCmd_7d:
@a465:  jsr     CalcObjPtr
        lda     $087c,y
        and     #$bf
        sta     $087c,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $48: display dialog message ]

; +$eb = bt-ddddd dddddddd
;        b: show at bottom of screen
;        t: show text only
;        d: dialog message

EventCmd_48:
@a475:  longa
        lda     $eb
        and     #$1fff
        sta     $d0         ; dialog message number
        shorta0
        lda     $ec         ; branch if showing at bottom of screen
        bmi     @a489
        lda     #$01
        bra     @a48b
@a489:  lda     #$12
@a48b:  sta     $bc         ; dialog window y position (1 or 12)
        lda     $ec
        and     #$40
        lsr6
        sta     $0564       ; text only
        jsr     GetDlgPtr
        lda     #1
        sta     $ba         ; enable dialog window
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $49: wait for dialog window to close ]

EventCmd_49:
@a4a6:  lda     $ba         ; dialog window state
        beq     @a4ab
        rts
@a4ab:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $4a: wait for dialog text to display ]

EventCmd_4a:
@a4b0:  lda     $d3         ; dialog keypress state
        cmp     #$01
        beq     @a4b7
        rts
@a4b7:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $4b: display dialog message (wait for keypress) ]

; +$eb = bt-ddddd dddddddd
;        b: show at bottom of screen
;        t: show text only
;        d: dialog message

.import EventScript_WaitDlg

EventCmd_4b:

@WaitDlg = EventScript_WaitDlg - EventScript

@a4bc:  longa
        lda     $eb
        and     #$1fff
        sta     $d0         ; set dialog index
        shorta0
        lda     $ec
        bmi     @a4d0       ; branch if showing dialog window at bottom of screen
        lda     #$01        ; y = 1 (top of screen)
        bra     @a4d2
@a4d0:  lda     #$12        ; y = 18 (bottom of screen)
@a4d2:  sta     $bc
        lda     $ec         ; text only flag
        and     #$40
        lsr6
        sta     $0564
        jsr     GetDlgPtr
        lda     #$01        ; enable dialog window
        sta     $ba
        lda     #<@WaitDlg
        sta     $eb
        lda     #>@WaitDlg
        sta     $ec
        lda     #^@WaitDlg
        sta     $ed
        lda     #$03        ; return address is pc+3
        jmp     _b1a3       ; jump to subroutine

; ------------------------------------------------------------------------------

; [ event command $4e: initiate random battle ]

EventCmd_4e:
@a4f9:  inc     $56         ; enable battle
        stz     $078a       ; enable blur and sound
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $af: initiate colosseum battle ]

EventCmd_af:
@a503:  lda     $0201
        bne     @a515
        ldx     #$023f      ; normal colosseum battle
        lda     $1ed7
        and     #$f7
        sta     $1ed7
        bra     @a520
@a515:  ldx     #$023e      ; colosseum battle vs. shadow
        lda     $1ed7
        ora     #$08
        sta     $1ed7
@a520:  longa
        txa
        sta     f:$0011e0
        lda     #$001c
        sta     f:$0011e2     ; set battle background to colosseum
        shorta0
        lda     #$c0
        sta     $11fa
        lda     $1ed7
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #$01
        sta     $56
        lda     #$c0
        sta     $078a
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $8e: initiate monster-in-a-box battle ]

EventCmd_8e:
@a54e:  lda     $0789       ; monster-in-a-box event battle group number
        sta     $eb
        lda     #$3f        ; default battle bg
        sta     $ec
        jsr     EventBattle
        ldx     $0541       ; set scroll position
        stx     $1f66
        ldx     a:$00af       ; set party position
        stx     $1fc0
        lda     #$c0        ; enable map startup event, disable auto fade-in
        sta     $11fa
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $82: reset default party ]

EventCmd_82:
@a570:  lda     #1
        sta     $055d
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $4d: initiate battle ]

; $eb = event battle group
; $ec = bsgggggg
;       b: disable blur
;       s: disable sound effect
;       g: battle bg ($3f = map default)

EventCmd_4d:
@a578:  jsr     EventBattle
        ldx     $0541       ; set scroll position
        stx     $1f66
        ldx     a:$00af       ; set party position
        stx     $1fc0
        lda     #$e0        ; enable map startup event, disable auto fade-in, don't update map size
        sta     $11fa
        lda     #3
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $4c: initiate battle (party collision) ]

; $eb = event battle group
; $ec = bsgggggg
;       b: disable blur
;       s: disable sound effect
;       g: battle bg ($3f = map default)

EventCmd_4c:
@a591:  jsr     EventBattle
        ldx     $0557       ; set party position and scroll position to the collided party
        stx     $1f66
        stx     $1fc0
        lda     #$c0        ; enable map startup event, disable auto fade-in
        sta     $11fa
        lda     #3
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ set event battle index ]

; $eb = event battle group
; $ec = bsgggggg
;       b: disable blur
;       s: disable sound effect
;       g: battle bg ($3f = map default)

EventBattle:
@a5a7:  lda     $eb         ; event battle group
        longa
        asl2
        tax
        shorta0
        jsr     UpdateBattleGrpRng
        cmp     #$c0
        bcc     @a5ba       ; 3/4 chance to choose the first battle
        inx2                ; 1/4 chance to choose the second battle
@a5ba:  longa
        lda     f:EventBattleGroup,x   ; battle index
        sta     f:$0011e0
        shorta0
        lda     $ec         ; battle blur/sound flags
        and     #$c0
        sta     $078a
        lda     $ec         ; battle bg
        and     #$3f
        cmp     #$3f
        bne     @a5db
        lda     $0522       ; map's default battle bg
        and     #$7f
@a5db:  sta     f:$0011e2     ; set battle bg
        tdc
        sta     f:$0011e3
        lda     $1ed7       ;
        and     #$10
        lsr
        sta     f:$0011e4
        lda     #1        ; enable battle
        sta     $56
        rts

; ------------------------------------------------------------------------------

; [ event command $4f: restore saved game ]

EventCmd_4f:
@a5f3:  lda     #1                      ; enable restore saved game
        sta     $11f1
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $50: modify bg palettes ]

; $eb = mmmrgbii
;       m: color function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub

EventCmd_50:
@a5fd:  lda     #$08        ; color range begin (skip font palette)
        sta     $df
        lda     #$f0        ; color range end (skip dialog window palette)
        sta     $e0
        jsr     InitColorMod
        dec
        bne     @a610
        jsr     BGColorInc
        bra     @a63b
@a610:  dec
        bne     @a618
        jsr     BGColorIncFlash
        bra     @a63b
@a618:  dec
        bne     @a620
        jsr     BGColorUnInc
        bra     @a63b
@a620:  dec
        bne     @a628
        jsr     BGColorDec
        bra     @a63b
@a628:  dec
        bne     @a630
        jsr     BGColorDecFlash
        bra     @a63b
@a630:  dec
        bne     @a638
        jsr     BGColorUnDec
        bra     @a63b
@a638:  jsr     BGColorRestore
@a63b:  lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $51: modify bg palette range ]

; $eb = mmmrgbii
;       m: color function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub
; $ec = range start
; $ed = range end

EventCmd_51:
@a640:  lda     $ec
        asl
        sta     $df
        lda     $ed
        inc
        asl
        sta     $e0
        jsr     InitColorMod
        dec
        bne     @a656
        jsr     BGColorInc
        bra     @a681
@a656:  dec
        bne     @a65e
        jsr     BGColorIncFlash
        bra     @a681
@a65e:  dec
        bne     @a666
        jsr     BGColorUnInc
        bra     @a681
@a666:  dec
        bne     @a66e
        jsr     BGColorDec
        bra     @a681
@a66e:  dec
        bne     @a676
        jsr     BGColorDecFlash
        bra     @a681
@a676:  dec
        bne     @a67e
        jsr     BGColorUnDec
        bra     @a681
@a67e:  jsr     BGColorRestore
@a681:  lda     #4
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $52: modify object palettes ]

; $eb = mmmrgbii
;       m: color math function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = decrement colors (restore to normal)
;          4 = decrement colors
;          5 = subtract color
;          6 = increment colors (restore to normal)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub

EventCmd_52:
@a686:  stz     $df
        stz     $e0
        jsr     InitColorMod
        dec
        bne     @a695
        jsr     SpriteColorInc
        bra     @a6c0
@a695:  dec
        bne     @a69d
        jsr     SpriteColorIncFlash
        bra     @a6c0
@a69d:  dec
        bne     @a6a5
        jsr     SpriteColorUnInc
        bra     @a6c0
@a6a5:  dec
        bne     @a6ad
        jsr     SpriteColorDec
        bra     @a6c0
@a6ad:  dec
        bne     @a6b5
        jsr     SpriteColorDecFlash
        bra     @a6c0
@a6b5:  dec
        bne     @a6bd
        jsr     SpriteColorUnDec
        bra     @a6c0
@a6bd:  jsr     SpriteColorRestore
@a6c0:  lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $53: modify object palette range ]

; $eb = mmmrgbii
;       m: color math function
;          0 = restore all colors to normal
;          1 = increment color
;          2 = add color (doesn't work)
;          3 = un-increment colors (ignores intensity)
;          4 = decrement colors
;          5 = subtract color
;          6 = un-decrement colors (ignores intensity)
;          7 = restore all colors to normal
;       r/g/b: affected colors
;       i: target intensity for inc/dec, add/sub value for add/sub
; $ec = range start
; $ed = range end

EventCmd_53:
@a6c5:  lda     $ec
        asl
        sta     $df
        lda     $ed
        inc
        asl
        sta     $e0
        jsr     InitColorMod
        dec
        bne     @a6db
        jsr     SpriteColorInc
        bra     @a706
@a6db:  dec
        bne     @a6e3
        jsr     SpriteColorIncFlash
        bra     @a706
@a6e3:  dec
        bne     @a6eb
        jsr     SpriteColorUnInc
        bra     @a706
@a6eb:  dec
        bne     @a6f3
        jsr     SpriteColorDec
        bra     @a706
@a6f3:  dec
        bne     @a6fb
        jsr     SpriteColorDecFlash
        bra     @a706
@a6fb:  dec
        bne     @a703
        jsr     SpriteColorUnDec
        bra     @a706
@a703:  jsr     SpriteColorRestore
@a706:  lda     #4
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ init palette color modification ]

InitColorMod:
@a70b:  stz     $1a                     ;  $1a = red color constant
        stz     $1b                     ;  $1b = blue color constant
        stz     $20                     ; +$20 = green color constant
        stz     $21
        lda     $eb                     ; intensity
        and     #$03
        asl
        tax
        lda     $eb                     ; red
        and     #$10
        beq     @a725
        lda     f:RedColorTbl,x
        sta     $1a
@a725:  lda     $eb                     ; blue
        and     #$08
        beq     @a736
        longa
        lda     f:GreenColorTbl,x
        sta     $20
        shorta0
@a736:  lda     $eb                     ; green
        and     #$04
        beq     @a742
        lda     f:BlueColorTbl,x
        sta     $1b
@a742:  lda     $eb                     ; invert colors if subtracting
        bpl     @a764
        lda     $1a
        eor     $02
        and     #$1f
        sta     $1a
        lda     $1b
        eor     $02
        and     #$7c
        sta     $1b
        longa
        lda     $20
        eor     $02
        and     #$03e0
        sta     $20
        shorta0
@a764:  lda     $eb                     ; return color function
        lsr5
        rts

; ------------------------------------------------------------------------------

; red color intensities
RedColorTbl:
@a76c:  .word   $0004,$0008,$0010,$001f

; blue color intensities
BlueColorTbl:
@a774:  .word   $0010,$0020,$0040,$007c

; green color intensities
GreenColorTbl:
@a77c:  .word   $0080,$0100,$0200,$03e0

; ------------------------------------------------------------------------------

; [ event command $54: disable fixed color math ]

EventCmd_54:
@a784:  stz     $4d
        stz     $4b
        lda     $4f
        sta     $4e
        lda     $53
        sta     $52
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $55: flash screen ]

; $eb = bgr-----
;       b: affect blue
;       g: affect green
;       r: affect red

EventCmd_55:
@a795:  lda     $4d         ; return if fixed color math is already enabled
        bne     @a7a3
        lda     $4e         ; save color math designation
        sta     $4f
        lda     $52         ; save subscreen designation
        sta     $53
        stz     $52         ; clear subscreen designation
@a7a3:  lda     #$07        ; affect bg only
        sta     $4e
        lda     $eb         ; set color components
        and     #$e0
        sta     $54
        lda     #$f8        ; set starting intensity to full
        sta     $4d
        lda     #$08        ; fixed color fading out, speed 8
        sta     $4b
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $56: set fixed color addition ]

; $eb = bgrssiii
;       b: affect blue
;       g: affect green
;       r: affect red
;       s: speed
;       i: intensity

EventCmd_56:
@a7ba:  lda     $4d
        bne     @a7c5
        lda     $eb
        jsr     InitFixedColorAdd
        bra     @a7cb
@a7c5:  lda     $4b
        and     #$7f
        sta     $4b
@a7cb:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $57: set fixed color subtraction ]

; $eb = bgrssiii
;       b: affect blue
;       g: affect green
;       r: affect red
;       s: speed
;       i: intensity

EventCmd_57:
@a7d0:  lda     $4d
        bne     @a7db
        lda     $eb
        jsr     InitFixedColorSub
        bra     @a7e1
@a7db:  lda     $4b
        and     #$7f
        sta     $4b
@a7e1:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $58: shake screen ]

; $eb = o321ffaa
;       o: shake obj layer
;       3: shake bg3
;       2: shake bg2
;       1: shake bg1
;       f: frequency
;       a: amplitude

EventCmd_58:
@a7e6:  lda     $eb
        sta     $074a
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $96: fade in ]

EventCmd_96:
@a7f0:  lda     #$10
        sta     $4a
        lda     #$10
        sta     $4c
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $97: fade out ]

EventCmd_97:
@a7fd:  lda     #$90
        sta     $4a
        lda     #$f0
        sta     $4c
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $59: fade in ]

; $eb = speed (0..31)

EventCmd_59:
@a80a:  lda     $eb
        sta     $4a
        lda     #$10
        sta     $4c
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5a: fade out ]

; $eb = speed (0..31)

EventCmd_5a:
@a817:  lda     $eb
        ora     #$80
        sta     $4a
        lda     #$f0
        sta     $4c
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5b: stop fade in/out ]

EventCmd_5b:
@a826:  stz     $4a
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5c: wait for fade in/out ]

EventCmd_5c:
@a82d:  lda     $e1
        ora     #$40
        sta     $e1
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5d: scroll bg1 ]

; these are the ones where $ff -> $ffff (basically -0)
; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_5d:
@a838:  lda     $eb
        bmi     @a84a
        longa
        asl4
        sta     $0547
        shorta0
        bra     @a85a
@a84a:  eor     $02
        longa
        asl4
        eor     $02
        sta     $0547
        shorta0
@a85a:  lda     $ec
        bmi     @a86c
        longa
        asl4
        sta     $0549
        shorta0
        bra     @a87c
@a86c:  eor     $02
        longa
        asl4
        eor     $02
        sta     $0549
        shorta0
@a87c:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $70: scroll bg1 ]

; these are the ones where $ff -> $fff0
; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_70:
@a881:  lda     $eb
        bmi     @a893
        longa
        asl4
        sta     $0547
        shorta0
        bra     @a8a5
@a893:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0547
        shorta0
@a8a5:  lda     $ec
        bmi     @a8b7
        longa
        asl4
        sta     $0549
        shorta0
        bra     @a8c9
@a8b7:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0549
        shorta0
@a8c9:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5e: scroll bg2 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_5e:
@a8ce:  lda     $eb
        bmi     @a8e0
        longa
        asl4
        sta     $054b
        shorta0
        bra     @a8f0
@a8e0:  eor     $02
        longa
        asl4
        eor     $02
        sta     $054b
        shorta0
@a8f0:  lda     $ec
        bmi     @a902
        longa
        asl4
        sta     $054d
        shorta0
        bra     @a912
@a902:  eor     $02
        longa
        asl4
        eor     $02
        sta     $054d
        shorta0
@a912:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $71: scroll bg2 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_71:
@a917:  lda     $eb
        bmi     @a929
        longa
        asl4
        sta     $054b
        shorta0
        bra     @a93b
@a929:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054b
        shorta0
@a93b:  lda     $ec
        bmi     @a94d
        longa
        asl4
        sta     $054d
        shorta0
        bra     @a95f
@a94d:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054d
        shorta0
@a95f:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $5f: scroll bg3 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_5f:
@a964:  lda     $eb
        bmi     @a976
        longa
        asl4
        sta     $054f
        shorta0
        bra     @a986
@a976:  eor     $02
        longa
        asl4
        eor     $02
        sta     $054f
        shorta0
@a986:  lda     $ec
        bmi     @a998
        longa
        asl4
        sta     $0551
        shorta0
        bra     @a9a8
@a998:  eor     $02
        longa
        asl4
        eor     $02
        sta     $0551
        shorta0
@a9a8:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $72: scroll bg3 ]

; $eb = horizontal scroll speed
; $ec = vertical scroll speed

EventCmd_72:
@a9ad:  lda     $eb
        bmi     @a9bf
        longa
        asl4
        sta     $054f
        shorta0
        bra     @a9d1
@a9bf:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $054f
        shorta0
@a9d1:  lda     $ec
        bmi     @a9e3
        longa
        asl4
        sta     $0551
        shorta0
        bra     @a9f5
@a9e3:  eor     $02
        inc
        longa
        asl4
        eor     $02
        inc
        sta     $0551
        shorta0
@a9f5:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $60: change palette ]

; $eb = vram palette (0..15)
; $ec = character palette (0..31)

EventCmd_60:
@a9fa:  longa
        lda     $eb
        and     #$00ff
        asl5
        tay
        lda     $ec
        and     #$00ff
        asl5
        tax
        shorta0
        lda     #$7e
        pha
        plb
        longa
        lda     #$0010
        sta     $1e
@aa20:  lda     f:MapSpritePal,x
        sta     $7200,y
        sta     $7400,y
        inx2
        iny2
        dec     $1e
        bne     @aa20
        shorta0
        tdc
        pha
        plb
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $61: filter colors ]

; $eb = filter number (0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = magenta, 6 = cyan, 7 = white)
; $ec = color range begin
; $ed = color range end

EventCmd_61:
        lda     $eb
        asl
        tax
        longa
        lda     f:ColorFilterTbl,x
        sta     $20
        shorta0
        lda     $ed
        inc
        sec
        sbc     $ec
        tay
        lda     $ec
        longa
        asl
        tax
        shorta0
loop:   lda     $7e7200,x               ; red
        and     #$1f
        sta     $1e
        lda     $7e7201,x               ; green
        lsr2
        and     #$1f
        clc
        adc     $1e
        sta     $1e
        stz     $1f
        longa
        lda     $7e7200,x               ; blue
        asl3
        xba
        and     #$001f
        clc
        adc     $1e                     ; average color (r + g + b) / 3
        sta     hWRDIVL
        shorta
        lda     #3
        sta     hWRDIVB
        nop5
        inx2
        lda     hRDDIVL                 ; blue
        asl2
        xba
        lda     hRDDIVL                 ; red
        longa
        sta     $1e
        lda     hRDDIVL                 ; green
        xba
        lsr3
        ora     $1e
        and     $20                     ; filter
        sta     $7e73fe,x               ; set filtered color
        shorta0
        dey
        bne     loop
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; color filter values
ColorFilterTbl:
@aabb:  .word   $0000,$001f,$03e0,$03ff,$7c00,$7c1f,$7fe0,$7fff

; ------------------------------------------------------------------------------

; [ event command $62: mosaic screen ]

; $eb = speed

EventCmd_62:
@aacb:  lda     $eb
        sta     $11f0       ; mosaic speed
        ldx     #$1e00
        stx     $0796       ; mosaic counter
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $63: enable flashlight ]

; $eb = flashlight radius (0..31)

EventCmd_63:
@aadb:  lda     $eb
        and     #$1f
        ora     #$80
        sta     $077b
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $64: set bg animation frame ]

; $eb = animation tile (0..7)
; $ec = frame (0..3)

EventCmd_64:
@aae9:  lda     $eb
        sta     hWRMPYA
        lda     #$0d
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     $ec
        and     #$03
        asl
        sta     $1069,x
        stz     $106a,x
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $65: set bg animation speed ]

; $eb = animation tile (0..7)
; $ec = speed (signed)

EventCmd_65:
@ab09:  lda     $eb
        sta     hWRMPYA
        lda     #$0d
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        lda     $ec
        and     #$7f
        longa
        asl4
        sta     $1e
        shorta0
        lda     $ec
        bpl     @ab38
        longa
        lda     $1e
        eor     $02
        inc
        sta     $1e
        shorta0
@ab38:  longa
        lda     $1e
        sta     $106b,x
        shorta0
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $6a: load map (wait for fade out) ]

; +$eb = --ddnzpm mmmmmmmm
;        d: facing direction
;        n: show map name
;        z: z-level
;        p: set destination as parent map
;        m: map number ($01fe = previous map, $01ff = parent map)
;  $ed = x position
;  $ee = y position
;  $ef = efs---vv
;        e: enable map startup event
;        f: disable map fade in when loading
;        s: don't update map size when loading map
;        v: world map vehicle (0 = no vehicle, 1 = airship, 2 = chocobo)

EventCmd_6a:
@ab47:  jsr     PushPartyMap
        jsr     FadeOut
        lda     $e1
        ora     #$40        ; wait for fade out
        sta     $e1
        bra     _ab5a

; ------------------------------------------------------------------------------

; [ event command $6b: load map (no fade out) ]

; +$eb = --ddnzpm mmmmmmmm
;        d: facing direction
;        n: show map name
;        z: z-level
;        p: set destination as parent map
;        m: map number ($01fe = previous map, $01ff = parent map)
;  $ed = x position
;  $ee = y position
;  $ef = efs---vv
;        e: enable map startup event
;        f: disable map fade in when loading
;        s: don't update map size when loading map
;        v: world map vehicle (0 = no vehicle, 1 = airship, 2 = chocobo)

EventCmd_6b:
@ab55:  jsr     PushPartyMap
        stz     $4a
_ab5a:  lda     #$01        ; enable map load
        sta     $84
        lda     $ef         ; map startup flags
        sta     $11fa
        longa
        lda     $eb         ; branch if not setting parent map
        and     #$0200
        beq     @ab79
        lda     $eb         ; set parent map
        and     #$01ff
        sta     $1f69
        lda     $ed
        sta     $1f6b
@ab79:  lda     $eb         ; map number
        sta     $1f64
        and     #$01ff
        cmp     #$01ff      ; branch if loading parent map
        beq     @abcd
        cmp     #$01fe      ; branch if loading previous map
        beq     @abd2
        tax
        shorta0
        cpx     #$0003
        bcs     @abaf       ; branch if not loading a 3d map
        ldx     $ed
        stx     $1f60       ; set world map position
@ab99:  longa_clc
        lda     $e5
        adc     #$0006
        sta     $11fd       ; set world map event pointer
        shorta
        lda     $e7
        adc     #$00
        sta     $11ff
        tdc
        bra     @ac06
@abaf:  lda     $ed         ; set position
        sta     $1fc0
        lda     $ee
        sta     $1fc1
@abb9:  lda     $ec         ; set facing direction
        and     #$30
        lsr4
        sta     $0743
        lda     $ec         ; show map name
        and     #$08
        sta     $0745
        bra     @ac06
@abcd:  jsr     RestoreParentMap
        bra     @abdb
@abd2:  shorta0
        lda     $1fd2
        sta     $1f68
@abdb:  longa
        lda     $eb
        and     #$fe00
        ora     $1f69
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     @abfb
        lda     $1f6b
        sta     $1f60
        shorta0
        bra     @ab99
@abfb:  lda     $1f6b
        sta     $1fc0
        shorta0
        bra     @abb9
@ac06:  lda     #6
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $6c: set parent map ]

; +$eb = map number
;  $ed = x position
;  $ee = y position
;  $ef = parent map facing direction

EventCmd_6c:
@ac0b:  ldy     $eb
        sty     $1f69
        ldy     $ed
        sty     $1f6b
        lda     $ef
        sta     $1fd2
        lda     #6
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $75: apply map changes ]

EventCmd_75:
@ac1f:  lda     $055a
        cmp     #$05
        bne     @ac2a
        dec
        sta     $055a
@ac2a:  lda     $055b
        cmp     #$05
        bne     @ac35
        dec
        sta     $055b
@ac35:  lda     $055c
        cmp     #$05
        bne     @ac40
        dec
        sta     $055c
@ac40:  lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $73: change map data (update immediately) ]

; $eb = x position
; $ec = bbyyyyyy
;       b: 0 = bg1, 1 = bg2, 2 or 3 = bg3
;       y: y position
; $ed = width
; $ee = height

EventCmd_73:
@ac45:  lda     $ec
        and     #$c0
        bne     @ac52
        lda     #$04
        sta     $055a
        bra     _ac62
@ac52:  cmp     #$40
        bne     @ac5d
        lda     #$04
        sta     $055b
        bra     _ac62
@ac5d:  lda     #$04
        sta     $055c
; fall through

; ------------------------------------------------------------------------------

; [ event command $74: change map data (no update) ]

; $eb = x position
; $ec = bbyyyyyy
;       b: 0 = bg1, 1 = bg2, 2 = bg3
;       y: y position
; $ed = width
; $ee = height

_ac62:
EventCmd_74:
@ac62:  lda     $ec
        and     #$c0
        bne     @ac76
        lda     $055a
        cmp     #$04
        beq     @ac94
        lda     #$05
        sta     $055a
        bra     @ac94
@ac76:  cmp     #$40
        bne     @ac88
        lda     $055b
        cmp     #$04
        beq     @ac94
        lda     #$05
        sta     $055b
        bra     @ac94
@ac88:  lda     $055c
        cmp     #$04
        beq     @ac94
        lda     #$05
        sta     $055c
@ac94:  lda     $eb
        sta     $8f
        lda     $ec
        and     #$3f
        sta     $90
        longa_clc
        lda     $e5
        adc     #$0003
        sta     $8c
        shorta
        lda     $e7
        adc     #$00
        sta     $8e
        lda     $ed
        sta     hWRMPYA
        lda     $ee
        sta     hWRMPYB
        nop2
        longa_clc
        lda     hRDMPYL
        adc     #$0002
        adc     $8c
        sta     $e5
        shorta
        lda     $8e
        adc     #$00
        sta     $e7
        tdc
        lda     $ec
        and     #$c0
        bne     @acde
        ldx     #$0000
        stx     $2a
        jmp     ModifyMap
@acde:  bmi     @ace8
        ldx     #$4000
        stx     $2a
        jmp     ModifyMap
@ace8:  ldx     #$8000
        stx     $2a
        jmp     ModifyMap

; ------------------------------------------------------------------------------

; [ event command $80: give item ]

; $eb = item number

EventCmd_80:
@acf0:  lda     $eb
        sta     $1a
        jsr     GiveItem
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ add item to inventory ]

; $1a = item number

GiveItem:
@acfc:  ldx     $00
@acfe:  lda     $1869,x     ; look for item
        cmp     $1a
        beq     @ad22       ; branch if found
        inx
        cpx     #$0100
        bne     @acfe
        ldx     $00       ; look for first empty slot
@ad0d:  lda     $1869,x
        cmp     #$ff
        beq     @ad17
        inx
        bra     @ad0d
@ad17:  lda     $1a         ; set item number
        sta     $1869,x
        lda     #$01        ; quantity 1
        sta     $1969,x
        rts
@ad22:  lda     $1969,x
        cmp     #$63        ; max quantity 99
        beq     @ad2c
        inc     $1969,x     ; add 1 to quantity
@ad2c:  rts

; ------------------------------------------------------------------------------

; [ event command $81: take item ]

; $eb = item number

EventCmd_81:
@ad2d:  ldx     $00
@ad2f:  lda     $1869,x     ; look for item
        cmp     $eb
        beq     @ad3e
        inx
        cpx     #$0100
        bne     @ad2f
        bra     @ad4b       ; return if not found
@ad3e:  dec     $1969,x     ; subtract 1 from quantity
        lda     $1969,x
        bne     @ad4b
        lda     #$ff        ; set slot empty if there's none left
        sta     $1869,x
@ad4b:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $84: give gil ]

; +$eb = gil amount

EventCmd_84:
@ad50:  longa_clc
        lda     $1860       ; add gil
        adc     $eb
        sta     $1860
        shorta0
        adc     $1862
        sta     $1862
        cmp     #^MAX_GIL
        bcc     @ad7a
        ldx     $1860
        cpx     #.loword(MAX_GIL)
        bcc     @ad7a
        ldx     #.loword(MAX_GIL)
        stx     $1860
        lda     #^MAX_GIL
        sta     $1862
@ad7a:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $85: take gil ]

; +$eb = gil amount

EventCmd_85:
@ad7f:  lda     $1eb7       ; clear "not enough gil" flag
        and     #$bf
        sta     $1eb7
        longa
        lda     $1860       ; subtract gil amount
        sec
        sbc     $eb
        sta     $2a
        shorta0
        lda     $1862
        sbc     #$00
        sta     $2c
        cmp     #$a0        ; branch if total is still positive
        bcc     @ada9
        lda     $1eb7       ; set "not enough gil" flag
        ora     #$40
        sta     $1eb7
        bra     @adb3
@ada9:  ldx     $2a         ; set new gil amount
        stx     $1860
        lda     $2c
        sta     $1862
@adb3:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $86: give esper ]

; $eb = esper number ($36..$50)

EventCmd_86:
@adb8:  lda     $eb
        sec
        sbc     #$36
        sta     $eb
        and     #$07
        tax
        lda     $eb
        lsr3
        tay
        lda     $1a69,y     ; set the appropriate esper bit
        ora     f:BitOrTbl,x
        sta     $1a69,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $87: take esper ]

; $eb = esper number ($36..$50)

EventCmd_87:
@add7:  lda     $eb
        sec
        sbc     #$36
        sta     $eb
        jsr     GetSwitchOffset
        lda     $1a69,y
        and     f:BitAndTbl,x
        sta     $1a69,y     ; clear the appropriate esper bit
        ldy     $00
@aded:  lda     $161e,y     ; remove the esper if equipped on a character
        cmp     $eb
        bne     @adf9
        lda     #$ff
        sta     $161e,y
@adf9:  longa_clc
        tya                 ; next character
        adc     #$0025
        tay
        shorta0
        cpy     #$0250
        bne     @aded
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ unused event command: teach spell ]

; $eb = character number (0..12)
; $ec = spell number (0..53)

GiveMagic:
@ae0d:  lda     $eb
        sta     hWRMPYA
        lda     #$36        ; get pointer to character's spell data
        sta     hWRMPYB
        lda     $ec
        longa_clc
        nop
        adc     hRDMPYL
        tax
        shorta0
        lda     #$ff
        sta     $1a6e,x     ; set spell learn %
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $88: remove status ]

;  $eb = character number
; +$ec = status to clear (inverse bit mask)

EventCmd_88:
@ae2d:  jsr     CalcCharPtr
        cpy     #$0250
        bcs     @ae42       ; return if not a character
        longa
        lda     $1614,y     ; clear status
        and     $ec
        sta     $1614,y
        shorta0
@ae42:  lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $89: set status ]

;  $eb = character number
; +$ec = status to set

EventCmd_89:
@ae47:  jsr     CalcCharPtr
        cpy     #$0250
        bcs     @ae5c       ; return if not a character
        longa
        lda     $1614,y     ; set status
        ora     $ec
        sta     $1614,y
        shorta0
@ae5c:  lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $8a: toggle status ]

;  $eb = character number
; +$ec = status to toggle

EventCmd_8a:
@ae61:  jsr     CalcCharPtr
        cpy     #$0250
        bcs     @ae76       ; return if not a character
        longa
        lda     $1614,y     ; toggle status
        eor     $ec
        sta     $1614,y
        shorta0
@ae76:  lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $8b: add/subtract hp ]

; $eb = character number
; $ec = shhhhhhh ($ff = set to max)
;       s: 0 = add, 1 = subtract
;       h: pointer to constant below (1, 2, 4, 8, 16, 32, 64, 128)

EventCmd_8b:
@ae7b:  jsr     CalcCharPtr
        cpy     #$0250
        jcs     @aed3
        jsr     CalcMaxHP
        lda     $ec
        and     #$7f
        cmp     #$7f
        beq     @aec9                   ; branch if setting to maximum
        asl
        tax
        lda     $ec
        bmi     @aeae                   ; branch if subtracting hp
        longa_clc
        lda     $1609,y                 ; add constant
        adc     f:HPTbl,x
        cmp     $1e
        bcc     @aea6                   ; can't go higher than max
        lda     $1e
@aea6:  sta     $1609,y
        shorta0
        bra     @aed3
@aeae:  longa
        lda     $1609,y                 ; subtract constant
        beq     @aec1
        sec
        sbc     f:HPTbl,x
        beq     @aebe
        bpl     @aec1
@aebe:  lda     #1                      ; can't go less than 1
@aec1:  sta     $1609,y
        shorta0
        bra     @aed3
@aec9:  longa                           ; set hp to max
        lda     $1e
        sta     $1609,y
        shorta0
@aed3:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; hp add/subtract constants
HPTbl:
@aed8:  .word   1,2,4,8,16,32,64,128

; ------------------------------------------------------------------------------

; [ calculate max hp w/ boost ]

; +$1e = max hp (out)

CalcMaxHP:
@aee8:  phx
        longa
        lda     $160b,y     ; max hp (base)
        and     #$3fff
        sta     $1e
        lsr
        sta     $20         ; +$20 = 50% of max
        lsr
        sta     $22         ; +$22 = 25% of max
        lsr
        sta     $24         ; +$24 = 12.5% of max
        shorta0
        lda     $160c,y
        and     #$c0        ; branch if no boost
        beq     @af33
        cmp     #$40        ; branch if 25% boost
        beq     @af28
        cmp     #$80        ; branch if 50% boost
        beq     @af1b
        longa_clc
        lda     $1e         ; add 12.5%
        adc     $24
        sta     $1e
        shorta0
        bra     @af33
@af1b:  longa_clc
        lda     $1e         ; add 50%
        adc     $20
        sta     $1e
        shorta0
        bra     @af33
@af28:  longa_clc
        lda     $1e         ; add 25%
        adc     $22
        sta     $1e
        shorta0
@af33:  ldx     #9999
        cpx     $1e
        bcs     @af3c
        stx     $1e
@af3c:  plx
        rts

; ------------------------------------------------------------------------------

; [ event command $8c: add/subtract mp ]

; $eb = character number
; $ec = smmmmmmm ($ff = set to max)
;       s: 0 = add, 1 = subtract
;       m: pointer to constant below (all 0)

EventCmd_8c:
@af3e:  jsr     CalcCharPtr
        cpy     #$0250
        jcs     @af90
        jsr     CalcMaxMP
        lda     $ec
        and     #$7f
        cmp     #$7f
        beq     @af86
        asl
        tax
        lda     $ec
        bmi     @af71
        longa_clc
        lda     $160d,y
        adc     f:MPTbl,x
        cmp     $1e
        bcc     @af69
        lda     $1e
@af69:  sta     $160d,y
        shorta0
        bra     @af90
@af71:  longa
        lda     $160d,y
        sec
        sbc     f:MPTbl,x
        bpl     @af7e
        tdc
@af7e:  sta     $160d,y
        shorta0
        bra     @af90
@af86:  longa
        lda     $1e
        sta     $160d,y
        shorta0
@af90:  lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; mp add/subtract constants
MPTbl:
@af95:  .word   0,0,0,0,0,0,0

; ------------------------------------------------------------------------------

; [ calculate max mp w/ boost ]

; +$1e = max mp (out)

CalcMaxMP:
@afa3:  phx
        longa
        lda     $160f,y
        and     #$3fff
        sta     $1e
        lsr
        sta     $20
        lsr
        sta     $22
        lsr
        sta     $24
        shorta0
        lda     $1610,y
        and     #$c0
        beq     @afed
        cmp     #$40
        beq     @afe2
        cmp     #$80
        beq     @afd5
        longa_clc
        lda     $1e
        adc     $24
        sta     $1e
        shorta
        bra     @afed
@afd5:  longa_clc
        lda     $1e
        adc     $20
        sta     $1e
        shorta0
        bra     @afed
@afe2:  longa_clc
        lda     $1e
        adc     $22
        sta     $1e
        shorta0
@afed:  ldx     #999                    ; 999 max
        cpx     $1e
        bcs     @aff6
        stx     $1e
@aff6:  plx
        rts

; ------------------------------------------------------------------------------

; [ event command $8f: give all swdtechs ]

EventCmd_8f:
@aff8:  lda     #$ff
        sta     $1cf7
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $90: give bum rush ]

EventCmd_90:
@b002:  lda     $1d28
        ora     #$80
        sta     $1d28
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $98: name change menu ]

; $eb = character number

EventCmd_98:
@b00f:  jsr     CalcCharPtr
        longa
        tya
        clc
        adc     #$1600
        sta     $0201       ; +$0201 = absolute pointer to character data
        shorta0
        lda     #$01
        sta     $0200       ; $0200 = #$01 (name change menu)
        jsr     OpenMenu
        lda     #$01
        sta     $84         ; enable map load
        lda     #$e0
        sta     $11fa       ; map startup flags
        lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $99: party select menu ]

;  $eb = number of parties (msb = clear parties, crashes if 0)
; +$ec = forced characters

EventCmd_99:
@b035:  ldy     $0803       ; clear pointers to character object data
        sty     $07fb
        ldy     #$07d9
        sty     $07fd
        sty     $07ff
        sty     $0801
        lda     $eb
        sta     $0201       ; $0201 = number of parties
        ldx     $ec
        stx     $0202       ; +$0202 = forced characters
        lda     #$04
        sta     $0200       ; $0200 = #$04 (party select)
        jsr     OpenMenu
        jsr     _c0714a
        jsr     GetTopChar
        lda     #$01
        sta     $84         ; enable map load
        lda     #$c0
        sta     $11fa       ; map startup flags
        lda     #4
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $9b: shop menu ]

; $eb = shop number

EventCmd_9b:
@b06d:  lda     $eb
        sta     $0201       ; $0201 = shop number
        ldy     $0803
        lda     $0879,y
        sta     $0202       ; $0202 = showing character graphic index
        lda     #$03
        sta     $0200       ; $0200 = #$03 (shop)
        jsr     OpenMenu
        lda     #$01
        sta     $84         ; enable map load
        lda     #2
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $9c: optimize character's equipment ]

; $eb = character number

EventCmd_9c:
@b08c:  lda     $eb
        sta     $0201       ; $0201 = character number
        jsr     OptimizeCharEquip
        jsr     UpdateEquip
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $9d: final battle menu ]

EventCmd_9d:
@b09c:  lda     #$08
        sta     $0200       ; $0200 = #$08 (final battle menu)
        jsr     OpenMenu
        lda     #$01
        sta     $84         ; enable map load
        lda     #$e0
        sta     $11fa       ; map startup flags
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $9a: colosseum menu ]

EventCmd_9a:
@b0b2:  lda     #$07
        sta     $0200       ; $0200 = #$07 (colosseum menu)
        jsr     OpenMenu
        lda     $0205
        cmp     #$ff
        beq     @b0c5       ; branch if no valid item was selected
        lda     #$40
        bra     @b0c6
@b0c5:  tdc
@b0c6:  sta     $1a
        lda     $1ebd       ; set or clear event bit for valid colosseum item
        and     #$bf
        ora     $1a
        sta     $1ebd
        lda     #$c0
        sta     $11fa       ; map startup flags
        lda     #$01
        sta     $84         ; enable map load
        lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $a0: set timer ]

;  +$eb = starting counter value (frames)
; ++$ed = pfrmxxee eeeeeeee eeeeeeee
;         p: pause timer in menu and battle
;         f: timer visible on field (timer 0 only)
;         r: used if timer runs out during emperor's banquet
;         m: timer visible in menu and battle (timer 0 only)
;         x: timer number
;         e: event pointer (+$ca0000)

EventCmd_a0:
@b0e0:  lda     $ef         ; timer number
        and     #$0c
        sta     $1a
        lsr
        clc
        adc     $1a
        tay
        lda     $eb         ; set counter
        sta     $1189,y
        lda     $ec
        sta     $118a,y
        lda     $ed         ; set event pointer
        sta     $118b,y
        lda     $ee
        sta     $118c,y
        lda     $ef
        sta     $1188,y     ; set flags
        and     #$03
        sta     $118d,y     ; bank byte of event pointer
        lda     #6
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a1: reset timer ]

; $eb = timer number

EventCmd_a1:
@b10e:  lda     $eb
        asl
        sta     $1a
        asl
        clc
        adc     $1a
        tay
        tdc
        sta     $1188,y
        sta     $1189,y
        sta     $118a,y
        sta     $118b,y
        sta     $118c,y
        sta     $118d,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a2: clear overlay tiles ]

EventCmd_a2:
@b130:  jsr     ClearOverlayTiles
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b0: loop start ]

; $eb = loop count ($ff = loop until event bit clear)

EventCmd_b0:
@b138:  lda     #$02
        jsr     PushEventPtr
        lda     $eb
        sta     $05c4,x     ; set loop count
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $b1: loop end ]

EventCmd_b1:
@b145:  ldx     $e8         ; event stack pointer
        lda     $05c4,x     ; decrement loop count
        dec
        sta     $05c4,x
        beq     @b162       ; branch if done looping
        lda     $05f1,x     ; set event pc back to start of loop
        sta     $e5
        lda     $05f2,x
        sta     $e6
        lda     $05f3,x
        sta     $e7
        jmp     ContinueEvent
@b162:  ldx     $e8         ; decrement stack pointer
        dex3
        stx     $e8
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ unused ]

@b16e:  rts

; ------------------------------------------------------------------------------

; [ event command $bc: loop if event bit is clear ]

; used to wait for keypress
; +$eb = event bit

EventCmd_bc:
@b16f:  lda     $ec
        xba
        lda     $eb
        jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitOrTbl,x
        bne     @b194       ; branch if set
        ldx     $e8         ; set event pc back to start of loop
        lda     $05f1,x
        sta     $e5
        lda     $05f2,x
        sta     $e6
        lda     $05f3,x
        sta     $e7
        jmp     ContinueEvent
@b194:  ldx     $e8         ; decrement stack pointer
        dex3
        stx     $e8
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ unused ]

@b1a0:  rts

; ------------------------------------------------------------------------------

; [ event command $b2: jump to subroutine ]

; ++$eb = event pointer

EventCmd_b2:
@b1a1:  lda     #$04        ; a = event pc + 4
_b1a3:  ldx     $e8
        clc
        adc     $e5
        sta     $0594,x     ; set return address
        lda     $e6
        adc     #$00
        sta     $0595,x
        lda     $e7
        adc     #$00
        sta     $0596,x
        lda     $eb         ; set event pc
        sta     $e5
        sta     $05f4,x
        lda     $ec
        sta     $e6
        sta     $05f5,x
        lda     $ed
        clc
        adc     #^EventScript
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8         ; increment stack pointer
        lda     #1
        sta     $05c4,x     ; loop count (do subroutine once)
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $b3: jump to subroutine multiple times ]

;   $eb = loop count
; ++$ec = event pointer

EventCmd_b3:
@b1df:  ldx     $e8         ; A: event pc + 5
        lda     $e5
        clc
        adc     #5
        sta     $0594,x     ; set return address
        lda     $e6
        adc     #$00
        sta     $0595,x
        lda     $e7
        adc     #$00
        sta     $0596,x
        lda     $ec
        sta     $e5
        sta     $05f4,x
        lda     $ed
        sta     $e6
        sta     $05f5,x
        lda     $ee
        clc
        adc     #^EventScript
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8         ; increment stack pointer
        lda     $eb
        sta     $05c4,x     ; set loop count
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $b4: pause (short) ]

; $eb = pause length (frames)

EventCmd_b4:
@b21d:  lda     $eb
        tax
        stx     $e3
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b5: pause (long) ]

; $eb = pause length (frames * 15)

EventCmd_b5:
@b227:  lda     $eb
        sta     hWRMPYA
        lda     #$0f
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        stx     $e3
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $91: pause (15 frames) ]

EventCmd_91:
@b23f:  ldx     #15
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $92: pause (30 frames) ]

EventCmd_92:
@b249:  ldx     #30
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $93: pause (45 frames) ]

EventCmd_93:
@b253:  ldx     #45
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $94: pause (60 frames) ]

EventCmd_94:
@b25d:  ldx     #60
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $95: pause (120 frames) ]

EventCmd_95:
@b267:  ldx     #120
        stx     $e3
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $bd: jump (50% chance) ]

; ++$eb = event pointer

EventCmd_bd:
@b271:  jsr     Rand
        cmp     #$80
        bcs     @b28b       ; 1/2 chance to branch
        longa_clc
        lda     $e5
        adc     #4          ; increment event pc and continue
        sta     $e5
        shorta0
        adc     $e7
        sta     $e7
        jmp     ContinueEvent
@b28b:  ldx     $eb         ; set new event pc
        stx     $e5
        lda     $ed
        clc
        adc     #^EventScript
        sta     $e7
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $b7: jump (battle flag conditional) ]

;   $eb = battle flag (+$1dc9)
; ++$ec = event pointer

EventCmd_b7:
@b299:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1dc9,y
        and     f:BitOrTbl,x   ; branch if bit is clear
        beq     @b2ba
        longa_clc
        lda     $e5
        adc     #$0005      ; increment event pc and continue
        sta     $e5
        shorta0
        adc     $e7
        sta     $e7
        jmp     ContinueEvent
@b2ba:  ldx     $ec         ; set new event pc
        stx     $e5
        lda     $ee
        clc
        adc     #^EventScript
        sta     $e7
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $c0-$c7: jump (event bit conditional, or) ]

; +$eb = sbbbbbbb bbbbbbbb
;        s: 1 = branch if set, 0 = branch if clear
;        b: event bit

; c0 +t1 ++aa                                 if(t1) jump; else continue;
; c1 +t1 +t2 ++aa                             if(t1 || t2) jump; else continue;
; c2 +t1 +t2 +t3 ++aa                         if(t1 || t2 || t3) jump; else continue;
; c3 +t1 +t2 +t3 +t4 ++aa                     if(t1 || t2 || t3 || t4) jump; else continue;
; c4 +t1 +t2 +t3 +t4 +t5 ++aa                 if(t1 || t2 || t3 || t4 || t5) jump; else continue;
; c5 +t1 +t2 +t3 +t4 +t5 +t6 ++aa             if(t1 || t2 || t3 || t4 || t5 || t6) jump; else continue;
; c6 +t1 +t2 +t3 +t4 +t5 +t6 +t7 ++aa         if(t1 || t2 || t3 || t4 || t5 || t6 || t7) jump; else continue;
; c7 +t1 +t2 +t3 +t4 +t5 +t6 +t7 +t8 ++aa     if(t1 || t2 || t3 || t4 || t5 || t6 || t7 || t8) jump; else continue;

EventCmd_c0:
EventCmd_c1:
EventCmd_c2:
EventCmd_c3:
EventCmd_c4:
EventCmd_c5:
EventCmd_c6:
EventCmd_c7:
@b2c8:  lda     $ea
        sec
        sbc     #$bf
        asl
        inc
        tay                 ; +$20 = pointer to jump address
        sty     $20
        ldy     #$0001
        sty     $1e
@b2d7:  ldy     $1e
        longa
        lda     [$e5],y     ; branch if testing if set
        bmi     @b2e8
        shorta
        jsr     GetEventSwitch0
        beq     @b312       ; branch if clear
        bra     @b2f2
.a16
@b2e8:  and     #$7fff
        shorta
        jsr     GetEventSwitch0
        bne     @b312       ; branch if set
@b2f2:  ldy     $1e         ; next bit
        iny2
        sty     $1e
        cpy     $20
        bne     @b2d7
        iny3
        longa_clc
        tya
        adc     $e5         ; increment event pc and continue
        sta     $e5
        shorta
        lda     $e7
        adc     #$00
        sta     $e7
        tdc
        jmp     ContinueEvent
@b312:  ldy     $20         ; set new event pc
        longa
        lda     [$e5],y
        sta     $2a
        shorta0
        iny2
        lda     [$e5],y
        clc
        adc     #^EventScript
        sta     $e7
        ldy     $2a
        sty     $e5
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $c8-$cf: jump (event bit conditional, and) ]

; +$eb = sbbbbbbb bbbbbbbb
;        s: 1 = branch if set, 0 = branch if clear
;        b: event bit

; c8 +t1 ++aa                                 if(t1) jump; else continue;
; c9 +t1 +t2 ++aa                             if(t1 && t2) jump; else continue;
; ca +t1 +t2 +t3 ++aa                         if(t1 && t2 && t3) jump; else continue;
; cb +t1 +t2 +t3 +t4 ++aa                     if(t1 && t2 && t3 && t4) jump; else continue;
; cc +t1 +t2 +t3 +t4 +t5 ++aa                 if(t1 && t2 && t3 && t4 && t5) jump; else continue;
; cd +t1 +t2 +t3 +t4 +t5 +t6 ++aa             if(t1 && t2 && t3 && t4 && t5 && t6) jump; else continue;
; ce +t1 +t2 +t3 +t4 +t5 +t6 +t7 ++aa         if(t1 && t2 && t3 && t4 && t5 && t6 && t7) jump; else continue;
; cf +t1 +t2 +t3 +t4 +t5 +t6 +t7 +t8 ++aa     if(t1 && t2 && t3 && t4 && t5 && t6 && t7 && t8) jump; else continue;

EventCmd_c8:
EventCmd_c9:
EventCmd_ca:
EventCmd_cb:
EventCmd_cc:
EventCmd_cd:
EventCmd_ce:
EventCmd_cf:
@b32d:  lda     $ea
        sec
        sbc     #$c7
        asl
        inc
        tay                 ; +$20 = pointer to jump address
        sty     $20
        ldy     #$0001
        sty     $1e
@b33c:  ldy     $1e
        longa
        lda     [$e5],y     ; branch if testing if set
        bmi     @b34d
        shorta
        jsr     GetEventSwitch0
        bne     @b37c
        bra     @b357
.a16
@b34d:  and     #$7fff
        shorta
        jsr     GetEventSwitch0
        beq     @b37c
@b357:  ldy     $1e
        iny2
        sty     $1e
        cpy     $20
        bne     @b33c
        ldy     $20         ; set new event pc
        longa
        lda     [$e5],y
        sta     $2a
        shorta0
        iny2
        lda     [$e5],y
        clc
        adc     #^EventScript
        sta     $e7
        ldy     $2a
        sty     $e5
        jmp     ContinueEvent
@b37c:  ldy     $20         ; increment event pc and continue
        iny3
        longa_clc
        tya
        adc     $e5
        sta     $e5
        shorta
        lda     $e7
        adc     #$00
        sta     $e7
        tdc
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $e7: set character portrait ]

; $eb = character number

EventCmd_e7:
@b394:  lda     $eb
        sta     $0795
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e4: get active party number ]

EventCmd_e4:
@b39e:  clr_a
        sta     $1eb5       ; +$1eb4 = 1 << party number
        lda     $1a6d
        inc
        tax
        lda     #1
@b3a9:  dex
        beq     @b3af
        asl
        bra     @b3a9
@b3af:  sta     $1eb4
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e3: get characters in any party ]

EventCmd_e3:
@b3b7:  tdc
        sta     $1eb4       ; +$1eb4 = characters in any party
        sta     $1eb5
        ldx     $00
        txy
@b3c1:  lda     $0867,y
        and     #$07
        beq     @b3d2
        lda     $1eb4
        ora     f:BitOrTbl,x
        sta     $1eb4
@b3d2:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b3c1
        ldx     $00
        txy
@b3e5:  lda     $09af,y
        and     #$07
        beq     @b3f6
        lda     $1eb5
        ora     f:BitOrTbl,x
        sta     $1eb5
@b3f6:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #8
        bne     @b3e5
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $de: get characters in active party ]

EventCmd_de:
@b40b:  tdc
        sta     $1eb4       ; +$1eb4 = characters in the active party
        sta     $1eb5
        ldx     $00
        txy
@b415:  lda     $0867,y
        and     #$07
        cmp     $1a6d
        bne     @b429
        lda     $1eb4
        ora     f:BitOrTbl,x
        sta     $1eb4
@b429:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b415
        ldx     $00
        txy
@b43c:  lda     $09af,y
        and     #$07
        cmp     $1a6d
        bne     @b450
        lda     $1eb5
        ora     f:BitOrTbl,x
        sta     $1eb5
@b450:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #8
        bne     @b43c
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $df: get characters that are enabled objects ]

EventCmd_df:
@b465:  clr_a
        sta     $1eb4
        sta     $1eb5
        ldx     $00
        txy
@b46f:  lda     $0867,y
        and     #$40
        beq     @b480
        lda     $1eb4
        ora     f:BitOrTbl,x
        sta     $1eb4
@b480:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #$0008
        bne     @b46f
        ldx     $00
        txy
@b493:  lda     $09af,y
        and     #$40
        beq     @b4a4
        lda     $1eb5
        ora     f:BitOrTbl,x
        sta     $1eb5
@b4a4:  longa_clc
        tya
        adc     #$0029
        tay
        shorta0
        inx
        cpx     #8
        bne     @b493
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e2: get showing character ]

EventCmd_e2:
@b4b9:  lda     #$20
        sta     $1a
        ldy     $00
        tyx
@b4c0:  lda     $1850,y
        and     #$07
        cmp     $1a6d
        bne     @b4d7
        lda     $1850,y
        and     #$18
        cmp     $1a
        bcs     @b4d7
        sta     $1a
        stx     $1e
@b4d7:  inx
        iny
        cpy     #$0010
        bne     @b4c0
        longa
        lda     $1e
        asl
        tax
        lda     f:CharMaskTbl,x
        sta     $1eb4
        shorta0
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

CharMaskTbl:
@b4f3:  .word   $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        .word   $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

; ------------------------------------------------------------------------------

; [ event command $e0: get initialized characters ]

EventCmd_e0:
@b513:  ldx     $1edc
        stx     $1eb4
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e1: get available characters ]

EventCmd_e1:
@b51e:  ldx     $1ede
        stx     $1eb4
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e8: set event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value

EventCmd_e8:
@b529:  lda     $eb
        asl
        tay
        longa
        lda     $ec
        sta     $1fc2,y
        shorta0
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $e9: add to event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value to add

EventCmd_e9:
@b53c:  lda     $eb
        asl
        tay
        longa_clc
        lda     $1fc2,y
        adc     $ec
        bcc     @b54b
        lda     $02
@b54b:  sta     $1fc2,y
        shorta0
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ea: subtract from event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value to subtract

EventCmd_ea:
@b556:  lda     $eb
        asl
        tay
        longa
        lda     $1fc2,y
        sec
        sbc     $ec
        bcs     @b566
        lda     $00
@b566:  sta     $1fc2,y
        shorta0
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $eb: compare event variable ]

;  $eb = event variable (+$1fc2)
; +$ec = value to compare to

EventCmd_eb:
@b571:  lda     $eb
        asl
        tay
        ldx     $1fc2,y
        cpx     $ec
        bcc     @b582
        beq     @b586
        lda     #$02        ; if variable is greater than value, $1eb4 = $0002
        bra     @b588
@b582:  lda     #$04        ; if variable is less than value, $1eb4 = $0004
        bra     @b588
@b586:  lda     #$01        ; if variable is equal to value, $1eb4 = $0001
@b588:  sta     $1eb4
        stz     $1eb5
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d0: set event bit ($0000-$00ff) ]

; $eb = event bit

EventCmd_d0:
@b593:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1e80,y
        ora     f:BitOrTbl,x
        sta     $1e80,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d2: set event bit ($0100-$01ff) ]

; $eb = event bit

EventCmd_d2:
@b5a7:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ea0,y
        ora     f:BitOrTbl,x
        sta     $1ea0,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d4: set event bit ($0200-$02ff) ]

; $eb = event bit

EventCmd_d4:
@b5bb:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ec0,y
        ora     f:BitOrTbl,x
        sta     $1ec0,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d1: clear event bit ($0000-$00ff) ]

; $eb = event bit

EventCmd_d1:
@b5cf:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitAndTbl,x
        sta     $1e80,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d3: clear event bit ($0100-$01ff) ]

; $eb = event bit

EventCmd_d3:
@b5e3:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ea0,y
        and     f:BitAndTbl,x
        sta     $1ea0,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d5: clear event bit ($0200-$02ff) ]

; $eb = event bit

EventCmd_d5:
@b5f7:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ec0,y
        and     f:BitAndTbl,x
        sta     $1ec0,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d6: set event bit ($0300-$03ff) ]

; $eb = event bit

EventCmd_d6:
@b60b:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ee0,y
        ora     f:BitOrTbl,x
        sta     $1ee0,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d8: set event bit ($0400-$04ff) ]

; $eb = event bit

EventCmd_d8:
@b61f:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f00,y
        ora     f:BitOrTbl,x
        sta     $1f00,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $da: set event bit ($0500-$05ff) ]

; $eb = event bit

EventCmd_da:
@b633:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f20,y
        ora     f:BitOrTbl,x
        sta     $1f20,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $dc: set event bit ($0600-$06ff) ]

; $eb = event bit

EventCmd_dc:
@b647:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f40,y
        ora     f:BitOrTbl,x
        sta     $1f40,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d7: clear event bit ($0300-$03ff) ]

; $eb = event bit

EventCmd_d7:
@b65b:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1ee0,y
        and     f:BitAndTbl,x
        sta     $1ee0,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $d9: clear event bit ($0400-$04ff) ]

; $eb = event bit

EventCmd_d9:
@b66f:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f00,y
        and     f:BitAndTbl,x
        sta     $1f00,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $db: clear event bit ($0500-$05ff) ]

; $eb = event bit

EventCmd_db:
@b683:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f20,y
        and     f:BitAndTbl,x
        sta     $1f20,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $dd: clear event bit ($0600-$06ff) ]

; $eb = event bit

EventCmd_dd:
@b697:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1f40,y
        and     f:BitAndTbl,x
        sta     $1f40,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b8: set battle flag ]

; $eb = battle flag (+$1dc9)

EventCmd_b8:
@b6ab:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1dc9,y
        ora     f:BitOrTbl,x
        sta     $1dc9,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b9: clear battle flag ]

; $eb = battle flag (+$1dc9)

EventCmd_b9:
@b6bf:  lda     $eb
        jsr     GetSwitchOffset
        lda     $1dc9,y
        and     f:BitAndTbl,x
        sta     $1dc9,y
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $b6: jump based on dialog selection ]

; b6 ++a1 ++a2 ...
; a1 = event pointer for first selection, etc.

EventCmd_b6:
@b6d3:  lda     $056e
        asl
        sec
        adc     $056e
        tay
        lda     [$e5],y     ; set event pointer
        sta     $1e
        iny
        lda     [$e5],y
        sta     $1f
        iny
        lda     [$e5],y
        clc
        adc     #^EventScript
        sta     $e7
        ldy     $1e
        sty     $e5
        stz     $056e       ; clear dialog selection
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $be: jump to subroutine based on +$1eb4 ]

;   $eb = number of bits to check
; ++$ec = bbbb--aa aaaaaaaa aaaaaaaa
;         b = bit to check in +$1eb4
;         a = event pointer

EventCmd_be:
@b6f7:  lda     $eb
        asl
        sec
        adc     $eb
        inc
        sta     $1e
        stz     $1f
        ldy     #$0002
@b705:  lda     [$e5],y
        sta     $2a
        iny
        lda     [$e5],y
        sta     $2b
        iny
        lda     [$e5],y
        sta     $2c
        iny
        lsr4
        longa_clc
        adc     #$01a0
        phy
        jsr     GetEventSwitch0
        ply
        shorta
        cmp     #$00
        bne     @b740
        cpy     $1e
        bne     @b705
        longa_clc
        lda     $e5
        adc     $1e
        sta     $e5
        shorta
        lda     $e7
        adc     #$00
        sta     $e7
        tdc
        jmp     ContinueEvent
@b740:  ldx     $e8
        lda     $1e
        clc
        adc     $e5
        sta     $0594,x
        lda     $e6
        adc     $1f
        sta     $0595,x
        lda     $e7
        adc     #$00
        sta     $0596,x
        lda     $2a
        sta     $e5
        sta     $05f4,x
        lda     $2b
        sta     $e6
        sta     $05f5,x
        lda     $2c
        and     #$03
        clc
        adc     #^EventScript
        sta     $e7
        sta     f:$0005f6,x
        inx3
        stx     $e8
        lda     #1                      ; repeat 1 time
        sta     $05c4,x
        jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ event command $f0: play song ]

; $eb = psssssss
;       p: 0 = normal start position, 1 = alternative start position
;       s: song number

EventCmd_f0:
@b780:  lda     $eb
        and     #$7f
        sta     $1301
        sta     $1f80
        lda     #$ff        ; volume = 100%
        sta     $1302
        lda     $eb
        bpl     @b797
        lda     #$14
        bra     @b799
@b797:  lda     #$10
@b799:  sta     $1300
        jsl     ExecSound_ext
@b7a0:  lda     hRDNMI
        bpl     @b7a0
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ef: play song (w/ volume) ]

; $eb = psssssss
;       p: 0 = normal start position, 1 = alternative start position
;       s: song number
; $ec = volume

EventCmd_ef:
@b7aa:  lda     $eb
        and     #$7f
        sta     $1301
        sta     $1f80
        lda     $ec
        sta     $1302
        lda     $eb
        bpl     @b7c1
        lda     #$14
        bra     @b7c3
@b7c1:  lda     #$10
@b7c3:  sta     $1300
        jsl     ExecSound_ext
@b7ca:  lda     hRDNMI
        bpl     @b7ca
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f1: fade song in ]

; $eb = psssssss
;       p: 0 = normal start position, 1 = alternative start position
;       s: song number
; $ec = fade speed (spc ticks)

EventCmd_f1:
@b7d4:  lda     $eb
        and     #$7f
        sta     $1301
        sta     $1f80
        lda     #$20
        sta     $1302
        lda     $eb
        bpl     @b7eb
        lda     #$14
        bra     @b7ed
@b7eb:  lda     #$10
@b7ed:  sta     $1300
        jsl     ExecSound_ext
        lda     #$81
        sta     $1300
        lda     $ec
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
@b807:  lda     hRDNMI
        bpl     @b807
        lda     #3
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f2: fade song out ]

; $eb = fade speed (spc ticks)

EventCmd_f2:
@b811:  lda     #$81
        sta     $1300
        lda     $eb
        sta     $1301
        stz     $1302
        jsl     ExecSound_ext
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f3: fade in previous song ]

; $eb = fade speed (spc ticks)

EventCmd_f3:
@b827:  lda     #$10
        sta     $1300
        lda     $1309
        sta     $1301
        sta     $1f80
        stz     $1302
        jsl     ExecSound_ext
        lda     #$81
        sta     $1300
        lda     $eb
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f4: play game sound effect ]

; $eb = sound effect

EventCmd_f4:
@b854:  lda     $eb
        jsr     PlaySfx
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f5: play game sound effect (with pan) ]

; $eb = sound effect
; $ec = pan
; $ed = pan speed

EventCmd_f5:
@b85e:  lda     #$18        ; spc command $18 (play game sound effect)
        sta     $1300
        lda     $eb         ; sound effect index
        sta     $1301
        lda     #$80
        sta     $1302
        jsl     ExecSound_ext
        lda     #$83        ; spc command $83 (set sound effect pan w/ envelope)
        sta     $1300
        lda     $ec
        sta     $1301
        lda     $ed
        sta     $1302
        jsl     ExecSound_ext
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f6: spc command ]

; $eb = command
; $ec = data byte 1
; $ed = data byte 2

EventCmd_f6:
@b889:  lda     $eb
        sta     $1300
        lda     $ec
        sta     $1301
        lda     $ed
        sta     $1302
        jsl     ExecSound_ext
        lda     #4
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f7: continue to next part of song ]

; used on the phantom train to progress to the next part of the song
; could also be used by dancing mad, though that song is controlled by the battle program

EventCmd_f7:
@b8a1:  lda     #$89        ; spc command $89 (continue to next part of song)
        sta     $1300
        jsl     ExecSound_ext
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f8: wait for spc ]

EventCmd_f8:
@b8af:  lda     hAPUIO2
        beq     @b8b5
        rts
@b8b5:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $f9: wait for song position ]

; used during the opera scene and the ending to sync the music with the events
; $eb = song position

EventCmd_f9:
@b8ba:  lda     $eb
        cmp     hAPUIO1
        beq     @b8c2
        rts
@b8c2:  lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $fa: wait for song to end ]

EventCmd_fa:
@b8c7:  lda     hAPUIO3
        beq     @b8cd
        rts
@b8cd:  lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $fb & $fd: no effect ]

; $fb is in the event script a few places, usually right after a sound effect
; $fd is used by the map startup event

EventCmd_fb:
EventCmd_fd:
@b8d2:  lda     #1
        jmp     IncEventPtrReturn

; ------------------------------------------------------------------------------

; [ event command $fe: return ]

EventCmd_fe:
@b8d7:  ldx     $e8         ; decrement event loop counter
        lda     $05c4,x
        dec
        sta     $05c4,x
        beq     @b8f4       ; branch if last loop
        lda     $05f1,x     ; set event pc to start of subroutine and continue
        sta     $e5
        lda     $05f2,x
        sta     $e6
        lda     $05f3,x
        sta     $e7
        jmp     ContinueEvent
@b8f4:  ldx     $e8         ; decrement event stack pointer
        dex3
        stx     $e8
        lda     $0594,x     ; pop event pc
        sta     $e5
        lda     $0595,x
        sta     $e6
        lda     $0596,x
        sta     $e7
        cpx     $00
        bne     @b917
        ldy     $0803       ; if event stack gets back to the top, restore the party object movement type
        lda     $087d,y
        sta     $087c,y
@b917:  jmp     ContinueEvent

; ------------------------------------------------------------------------------

; [ misc. unused event commands ]

; these will cause the game to lock up

EventCmd_66:
EventCmd_67:
EventCmd_68:
EventCmd_69:
EventCmd_6d:
EventCmd_6e:
EventCmd_6f:
EventCmd_76:
EventCmd_83:
EventCmd_9e:
EventCmd_9f:
EventCmd_a3:
EventCmd_a4:
EventCmd_a5:
EventCmd_e5:
EventCmd_e6:
EventCmd_ec:
EventCmd_ed:
EventCmd_ee:
EventCmd_fc:
EventCmd_ff:
@b91a:  rts

; ------------------------------------------------------------------------------

; [ event command $ab: game load menu ]

EventCmd_ab:
@b91b:  lda     #$02
        sta     $0200                   ; $0200 = #$02 (load game)
        jsr     OpenMenu
        lda     $307ff1                 ; add 13 to random number seed
        clc
        adc     #$0d
        sta     $307ff1
        sta     $1f6d                   ; init random numbers
        sta     $1fa1
        sta     $1fa2
        sta     $1fa4
        sta     $1fa3
        sta     $1fa5
        lda     $0205                   ; set/clear event bit if there is at least one saved game
        and     #$80
        sta     $1a
        lda     $1edf
        and     #$7f
        ora     $1a
        sta     $1edf
        stz     $58                     ; don't reload the same map
        jsr     UpdateEquip
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ac: load saved game data ]

EventCmd_ac:
@b95e:  jsr     InitSavedGame
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a9: show title screen ]

EventCmd_a9:
@b966:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     TitleScreen_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     $0200
        and     #$80
        sta     $1a
        lda     $1edf                   ; set/clear event bit if there is at least one saved game
        and     #$7f
        ora     $1a
        sta     $1edf
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $aa: opening credits ]

EventCmd_aa:
@b992:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     OpeningCredits_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     $0200
        and     #$80
        sta     $1a
        lda     $1edf                   ; set/clear event bit if there is at least one saved game
        and     #$7f
        ora     $1a
        sta     $1edf
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $bb: "the end" cinematic ]

EventCmd_bb:
@b9be:  jsr     DisableInterrupts
        jml     TheEnd_ext

; ------------------------------------------------------------------------------

; [ event command $ae: magitek train ride scene ]

EventCmd_ae:
@b9c5:  jsr     PushDP
        jsr     DisableInterrupts
        phd
        phb
        php
        jsl     MagitekTrain_ext
        plp
        plb
        pld
        tdc
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $bf: ending airship scene ]

EventCmd_bf:
@b9e7:  jsr     PushDP
        jsr     DisableInterrupts
        phd
        phb
        php
        jsl     EndingAirshipScene2_ext
        plp
        plb
        pld
        tdc
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        jsr     EnableInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a6: disable pyramid ]

EventCmd_a6:
@ba09:  stz     $0781                   ; disable pyramid
        jsr     ClearWindowPos
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a7: enable pyramid ]

; $eb = pyramid object

EventCmd_a7:
@ba14:  lda     #1
        sta     $0781                   ; enable pyramid
        lda     $eb
        sta     hWRMPYA
        lda     #$29
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        stx     $077f                   ; set pointer to pyramid object
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ba: ending cinematic ]

EventCmd_ba:
@ba31:  lda     $eb                     ; $0201: ending cinematic number
        sta     $0201
        jsr     PushDP
        jsr     DisableInterrupts
        jsl     EndingCutscene_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        jsr     EnableInterrupts
        lda     #2
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $a8: floating island cutscene ]

EventCmd_a8:
@ba51:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     FloatingContScene_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ event command $ad: world of ruin cutscene ]

EventCmd_ad:
@ba69:  jsr     PushDP
        jsr     DisableInterrupts
        jsl     WorldOfRuinScene_ext
        jsr     PopDP
        jsr     DisableInterrupts
        jsr     InitInterrupts
        lda     #1
        jmp     IncEventPtrContinue

; ------------------------------------------------------------------------------

; [ update a button and facing direction event bits ]

UpdateCtrlFlags:
@ba81:  ldy     $0803
        lda     $087f,y                 ; party facing direction
        tax
        lda     $1eb6
        and     #$f0
        ora     f:BitOrTbl,x
        sta     $1eb6
        lda     $06                     ; branch if A button is not down
        bpl     @baa2
        lda     $1eb6
        ora     #$10
        sta     $1eb6
        bra     @baaa
@baa2:  lda     $1eb6
        and     #$ef
        sta     $1eb6
@baaa:  rts

; ------------------------------------------------------------------------------

; [ get event bit (+$1e80) ]

GetEventSwitch0:
@baab:  jsr     GetSwitchOffset
        lda     $1e80,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0100-$01ff) ]

GetEventSwitch1:
@bab6:  jsr     GetSwitchOffset
        lda     $1ea0,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0300-$03ff) ]

GetNPCSwitch0:
@bac1:  jsr     GetSwitchOffset
        lda     $1ee0,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0400-$04ff) ]

GetNPCSwitch1:
@bacc:  jsr     GetSwitchOffset
        lda     $1f00,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0500-$05ff) ]

GetNPCSwitch2:
@bad7:  jsr     GetSwitchOffset
        lda     $1f20,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get event bit ($0600-$06ff) ]

GetNPCSwitch3:
@bae2:  jsr     GetSwitchOffset
        lda     $1f40,y
        and     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------

; [ get bit pointer ]

; a = bit number

GetSwitchOffset:
@baed:  longa
        tax
        lsr3
        tay                             ; y = byte pointer
        shorta0
        txa
        and     #$07
        tax                             ; x = bit mask pointer
        rts

; ------------------------------------------------------------------------------

; bit masks
BitOrTbl:
@bafc:  .byte   $01,$02,$04,$08,$10,$20,$40,$80

; inverse bit masks
BitAndTbl:
@bb04:  .byte   $fe,$fd,$fb,$f7,$ef,$df,$bf,$7f

; ------------------------------------------------------------------------------

; [ clear event bits ]

InitEventSwitches:
@bb0c:  ldx     $00
@bb0e:  stz     $1e80,x
        inx
        cpx     #$0060
        bne     @bb0e
        rts

; ------------------------------------------------------------------------------

; [ clear treasure bits ]

InitTreasureSwitches:
@bb18:  ldx     $00
@bb1a:  stz     $1e40,x
        inx
        cpx     #$0030
        bne     @bb1a
        rts

; ------------------------------------------------------------------------------

; [ decrement timers ]

; called from other banks

.proc DecTimersMenuBattle
        pha
        phx
        phy
        phb
        phd
        php
        shorta0
        longi
        tdc
        pha
        plb
        lda     $1dd1
        and     #$9f
        sta     $1dd1
        lda     $1188
        and     #$10
        beq     :+
        lda     $1dd1
        ora     #$40
        sta     $1dd1

; timer 1
:       lda     $1188
        bmi     skip1
        ldx     $1189
        beq     :+
        dex
        stx     $1189
        bra     skip1
:       lda     $1188                   ; used during emperor's banquet
        and     #$20
        beq     skip1
        lda     $1dd1
        ora     #$20
        sta     $1dd1

; timer 2
skip1:  lda     $118e
        bmi     skip2
        ldx     $118f
        beq     :+
        dex
        stx     $118f
        bra     skip2
:       lda     $118e
        and     #$20
        beq     skip2
        lda     $1dd1
        ora     #$20
        sta     $1dd1

; timer 3
skip2:  lda     $1194
        bmi     skip3
        ldx     $1195
        beq     :+
        dex
        stx     $1195
        bra     skip3
:       lda     $1194
        and     #$20
        beq     skip3
        lda     $1dd1
        ora     #$20
        sta     $1dd1

; timer 4
skip3:  lda     $119a
        bmi     skip4
        ldx     $119b
        beq     :+
        dex
        stx     $119b
        bra     skip4
:       lda     $119a
        and     #$20
        beq     skip4
        lda     $1dd1
        ora     #$20
        sta     $1dd1
skip4:  plp
        pld
        plb
        ply
        plx
        pla
        rts
.endproc  ; DecTimersMenuBattle

; ------------------------------------------------------------------------------

; [ decrement timers ]

.proc DecTimers
        ldx     $1189
        beq     :+
        dex
        stx     $1189
:       ldx     $118f
        beq     :+
        dex
        stx     $118f
:       ldx     $1195
        beq     :+
        dex
        stx     $1195
:       ldx     $119b
        beq     :+
        dex
        stx     $119b
:       rts
.endproc  ; DecTimers

; ------------------------------------------------------------------------------

; [ check timer events ]

.proc CheckTimer
        ldy     $00
loop:   ldx     $1189,y
        bne     skip
        ldx     $118b,y
        bne     :+
        lda     $118d,y
        beq     skip
:       ldx     $e5
        cpx     #.loword(EventScript_NoEvent)
        bne     skip
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     skip
        ldx     $0803
        lda     $086a,x
        and     #$0f
        bne     skip
        lda     $086d,x
        and     #$0f
        bne     skip
        ldx     $118b,y
        stx     $e5
        stx     $05f4
        lda     $118d,y
        clc
        adc     #^EventScript
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1
        sta     $05c7
        ldx     #$0003
        stx     $e8
        ldx     $da
        lda     $087c,x
        sta     $087d,x
        lda     #$04
        sta     $087c,x
        tdc
        sta     $118b,y
        sta     $118c,y
        sta     $118d,y
        jsr     CloseMapTitleWindow
        rts
skip:   iny6
        cpy     #$0018
        bne     loop
        rts
.endproc  ; CheckTimer

; ------------------------------------------------------------------------------

; [ check event triggers ]

.proc CheckEventTriggers
        lda     $84
        bne     done
        lda     $59
        bne     done
        ldy     $0803
        lda     $086a,y
        and     #$0f
        bne     done
        lda     $0869,y
        bne     done
        lda     $086d,y
        and     #$0f
        bne     done
        lda     $086c,y
        bne     done
        ldx     $e5
        cpx     #.loword(EventScript_NoEvent)
        bne     done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     done
        lda     $087c,y
        and     #$0f
        cmp     #$02
        bne     done
        longa
        lda     $82
        asl
        tax
        lda     f:EventTriggerPtrs+2,x
        sta     $1e
        lda     f:EventTriggerPtrs,x
        cmp     $1e
        beq     done
        tax
loop:   lda     f:EventTriggerPtrs,x
        cmp     $af
        beq     do_trigger
        txa
        clc
        adc     #5
        tax
        cpx     $1e
        bne     loop
done:   shorta0
        rts

do_trigger:
        lda     f:EventTriggerPtrs+2,x
        sta     $e5
        sta     $05f4
        tdc
        sta     $0871,y
        sta     $0873,y
        shorta
        sta     $087e,y
        lda     #$01
        sta     $078e
        lda     f:EventTriggerPtrs+4,x
        clc
        adc     #^EventScript
        sta     $e7
        sta     $05f6
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1
        sta     $05c7
        ldx     #$0003
        stx     $e8
        lda     $087c,y
        sta     $087d,y
        lda     #$04
        sta     $087c,y
        jsr     UpdateScrollRate
        jsr     CloseMapTitleWindow
        rts
.endproc  ; CheckEventTriggers

; ------------------------------------------------------------------------------
