; ------------------------------------------------------------------------------

.include "field/long_entrance.inc"
.include "field/short_entrance.inc"

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ check entrance triggers ]

.proc CheckEntrances
        lda     $84                     ; return if a map is loading
        bne     Done
        lda     $59                     ; return if menu is opening
        bne     Done
        lda     $85                     ; return if entrance triggers are disabled
        bne     Done
        lda     $56                     ; return if entering battle
        bne     Done
        ldy     $0803                   ; return if between tiles
        lda     $086a,y
        and     #$0f
        bne     Done
        lda     $086d,y
        and     #$0f
        bne     Done
        ldx     $e5                     ; return if an event is running
        cpx     #.loword(EventScript_NoEvent)
        bne     Done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     Done
        lda     $b8                     ; branch if on a bridge tile
        and     #$04
        beq     :+
        lda     $b2                     ; return if party is not on upper z-level
        cmp     #$01
        bne     Done
:       jsr     CheckLongEntrance
        jsr     CheckShortEntrance
Done:   rts
.endproc  ; CheckEntrances

; ------------------------------------------------------------------------------

; [ check long entrance triggers ]

.proc CheckLongEntrance
        longa
        lda     $82
        asl
        tax
        lda     f:LongEntrancePtrs+2,x
        sta     $1e
        lda     f:LongEntrancePtrs,x
        tax
        cmp     $1e
        jeq     Done
        shorta0
Loop:   stz     $26
        stz     $28
        lda     f:LongEntrance::Length,x
        bmi     Vertical

; horizontal trigger
Horizontal:
        sta     $1a
        lda     f:LongEntrance::SrcY,x
        cmp     $b0
        bne     Next
        lda     $af
        sec
        sbc     f:LongEntrance::SrcX,x
        bcc     Next
        sta     $26
        lda     f:LongEntrance::SrcX,x
        clc
        adc     $1a
        cmp     $af
        bcs     DoEntrance
        bra     Next

; vertical trigger
Vertical:
        and     #$7f
        sta     $1a
        lda     f:LongEntrance::SrcX,x
        cmp     $af
        bne     Next
        lda     $b0
        sec
        sbc     f:LongEntrance::SrcY,x
        bcc     Next
        sta     $28
        lda     f:LongEntrance::SrcY,x
        clc
        adc     $1a
        cmp     $b0
        bcs     DoEntrance
Next:   longa_clc
        txa
        adc     #LongEntrance::ITEM_SIZE
        tax
        shorta0
        cpx     $1e
        bne     Loop
        rts

; player is on a trigger
DoEntrance:
        lda     #$01
        sta     $078e
        longa
        lda     f:LongEntrance::Map,x
        and     #$0200
        beq     :+
        jsr     SetParentMap
:       lda     f:LongEntrance::Map,x
        and     #$01ff
        cmp     #$01ff
        beq     LoadParentMap
        lda     f:LongEntrance::Map,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     :+                      ; branch if not a world map

; to world map
        lda     f:LongEntrance::DestPos,x
        sta     $1f60
        shorta0
        lda     #$01
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts

; to sub-map
:       lda     f:LongEntrance::DestPos,x  ; destination xy position
        sta     $1fc0
        shorta0
        lda     f:LongEntrance::Flags,x  ; facing direction
        and     #$30
        lsr4
        sta     $0743
        lda     f:LongEntrance::Flags,x  ; show map name
        and     #$08
        sta     $0745
        lda     #$01                    ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:LongEntrance::Flags,x
        and     #$04
        beq     :+                      ; branch if upper z-layer
        lsr
        sta     $0744
:       lda     #1                      ; enable map load
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts

LoadParentMap:
        jsr     RestoreParentMap
        longa
        lda     f:LongEntrance::Map,x
        and     #$fe00
        ora     $1f69
        sta     $1f64
        shorta0
        ldx     $1f69
        cpx     #$0003
        bcs     :+                      ; branch if not a world map

; parent map is a world map
        ldy     $1f6b
        sty     $1f60
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts

; parent map is a sub-map
:       lda     $1f68
        sta     $0743
        lda     f:LongEntrance::Flags,x
        and     #$08
        sta     $0745
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts
Done:   shorta0
        rts
.endproc  ; CheckLongEntrance

; ------------------------------------------------------------------------------

.pushseg
.segment "long_entrance"

; ed/f480
LongEntrancePtrs:
        ptr_tbl LongEntrance
        end_ptr LongEntrance

; ed/f882
LongEntrance:
        .incbin "trigger/long_entrance.dat"
LongEntrance::End:

.popseg

; ------------------------------------------------------------------------------

; [ set parent map ]

.proc SetParentMap
        longa
        lda     $82
        and     #$01ff
        sta     $1f69                   ; parent map
        lda     $af
        sta     $1f6b                   ; parent xy position
        shorta0
        ldy     $0803
        lda     $087e,y
        sta     $1fd2                   ; parent map facing direction
        rts
.endproc  ; SetParentMap

; ------------------------------------------------------------------------------

; [ restore parent map position ]

.proc RestoreParentMap
        phx
        shorta0
        lda     $1fd2                   ; parent facing direction
        and     #$03
        eor     #$02                    ; invert
        tax
        eor     #$80
        sta     $1f68                   ; set facing direction
        lda     $1f6b
        clc
        adc     f:DirXTbl,x             ; x offset for parent facing direction
        sta     $1f6b
        lda     $1f6c
        clc
        adc     f:DirYTbl,x             ; y offset for parent facing direction
        sta     $1f6c
        plx
        rts
.endproc  ; RestoreParentMap

; ------------------------------------------------------------------------------

; x and y offsets for parent facing direction (up, right, down, left)
DirXTbl: .lobytes +0,+1,+0,-1
DirYTbl: .lobytes -1,+0,+1,+0

; ------------------------------------------------------------------------------

; [ check short entrance triggers ]

.proc CheckShortEntrance
        longa
        lda     $82
        asl
        tax
        lda     f:ShortEntrancePtrs+2,x
        sta     $1e
        lda     f:ShortEntrancePtrs,x
        tax
        cmp     $1e
        jeq     Done
Loop:   lda     f:ShortEntrance::SrcPos,x   ; check xy position
        cmp     $af
        beq     DoEntrance
        txa
        clc
        adc     #ShortEntrance::ITEM_SIZE
        tax
        cpx     $1e
        bne     Loop
        jmp     Done

DoEntrance:
        lda     #$0001
        sta     $078e
        lda     f:ShortEntrance::Map,x
        and     #$0200
        beq     :+
        jsr     SetParentMap
:       lda     f:ShortEntrance::Map,x
        and     #$01ff
        cmp     #$01ff
        beq     LoadParentMap
        lda     f:ShortEntrance::Map,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     :+
        lda     f:ShortEntrance::DestPos,x
        sta     $1f60
        shorta0
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
:       lda     f:ShortEntrance::DestPos,x
        sta     $1fc0
        shorta0
        lda     f:ShortEntrance::Flags,x   ; facing direction
        lsr4
        and     #$03
        sta     $0743
        lda     f:ShortEntrance::Flags,x   ; show map name
        and     #$08
        sta     $0745
        lda     #$01        ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:ShortEntrance::Flags,x
        and     #$04
        beq     :+
        lsr
        sta     $0744
:       jsr     FadeOut
        lda     #$80
        sta     $11fa
        lda     #1
        sta     $84
        jsr     PushPartyMap
        rts

LoadParentMap:
        jsr     RestoreParentMap
        longa
        lda     f:ShortEntrance::Map,x
        and     #$fe00
        ora     $1f69
        sta     $1f64
        shorta0
        ldx     $1f69
        cpx     #$0003
        bcs     :+
        ldy     $1f6b
        sty     $1f60
        lda     #$01
        sta     $84
        jsr     FadeOut
        rts
:       lda     $1f68
        sta     $0743
        ldy     $1f6b
        sty     $1f66
        lda     f:ShortEntrance::Flags,x
        and     #$08
        sta     $0745
        lda     #$80
        sta     $11fa
        lda     #1
        sta     $84
        jsr     FadeOut
        jsr     PushPartyMap
        rts

Done:   shorta0
        rts
.endproc  ; CheckShortEntrance

; ------------------------------------------------------------------------------

.pushseg
.segment "short_entrance"

; df/bb00
ShortEntrancePtrs:
        fixed_block $1f00
        ptr_tbl ShortEntrance
        end_ptr ShortEntrance

; df/bf02
ShortEntrance:
        .incbin "trigger/short_entrance.dat"

ShortEntrance::End:
        end_fixed_block

.popseg

; ------------------------------------------------------------------------------
