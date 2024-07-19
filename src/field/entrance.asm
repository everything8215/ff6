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
        bne     done
        lda     $59                     ; return if menu is opening
        bne     done
        lda     $85                     ; return if entrance triggers are disabled
        bne     done
        lda     $56                     ; return if entering battle
        bne     done
        ldy     $0803                   ; return if between tiles
        lda     $086a,y
        and     #$0f
        bne     done
        lda     $086d,y
        and     #$0f
        bne     done
        ldx     $e5                     ; return if an event is running
        cpx     #.loword(EventScript_NoEvent)
        bne     done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     done
        lda     $b8                     ; branch if on a bridge tile
        and     #$04
        beq     :+
        lda     $b2                     ; return if party is not on upper z-level
        cmp     #$01
        bne     done
:       jsr     CheckLongEntrance
        jsr     CheckShortEntrance
done:   rts
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
        jeq     done
        shorta0
loop:   stz     $26
        stz     $28
        lda     f:LongEntrancePtrs+2,x
        bmi     vertical

; horizontal trigger
        sta     $1a
        lda     f:LongEntrancePtrs+1,x
        cmp     $b0
        bne     next
        lda     $af
        sec
        sbc     f:LongEntrancePtrs,x
        bcc     next
        sta     $26
        lda     f:LongEntrancePtrs,x
        clc
        adc     $1a
        cmp     $af
        bcs     do_entrance
        bra     next

; vertical trigger
vertical:
        and     #$7f
        sta     $1a
        lda     f:LongEntrancePtrs,x
        cmp     $af
        bne     next
        lda     $b0
        sec
        sbc     f:LongEntrancePtrs+1,x
        bcc     next
        sta     $28
        lda     f:LongEntrancePtrs+1,x
        clc
        adc     $1a
        cmp     $b0
        bcs     do_entrance
next:   longa_clc
        txa
        adc     #7
        tax
        shorta0
        cpx     $1e
        bne     loop
        rts

; player is on a trigger
do_entrance:
        lda     #$01
        sta     $078e
        longa
        lda     f:LongEntrancePtrs+3,x
        and     #$0200
        beq     :+
        jsr     SetParentMap
:       lda     f:LongEntrancePtrs+3,x
        and     #$01ff
        cmp     #$01ff
        beq     load_parent_map
        lda     f:LongEntrancePtrs+3,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     :+                      ; branch if not a world map

; to world map
        lda     f:LongEntrancePtrs+5,x
        sta     $1f60
        shorta0
        lda     #$01
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts

; to sub-map
:       lda     f:LongEntrancePtrs+5,x  ; destination xy position
        sta     $1fc0
        shorta0
        lda     f:LongEntrancePtrs+4,x  ; facing direction
        and     #$30
        lsr4
        sta     $0743
        lda     f:LongEntrancePtrs+4,x  ; show map name
        and     #$08
        sta     $0745
        lda     #$01                    ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:LongEntrancePtrs+4,x
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

load_parent_map:
        jsr     RestoreParentMap
        longa
        lda     f:LongEntrancePtrs+3,x
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
        lda     f:LongEntrancePtrs+4,x
        and     #$08
        sta     $0745
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts
done:   shorta0
        rts
.endproc  ; CheckLongEntrance

; ------------------------------------------------------------------------------

.pushseg
.segment "long_entrance"

; ed/f480
LongEntrancePtrs:
        make_ptr_tbl_rel LongEntrance, LONG_ENTRANCE_ARRAY_LENGTH, LongEntrancePtrs
        .addr LongEntranceEnd - LongEntrancePtrs

; ed/f882
LongEntrance:
        .incbin "trigger/long_entrance.dat"
        LongEntranceEnd := *

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

; x offset for parent facing direction
DirXTbl:
@1a6f:  .byte   $00,$01,$00,$ff

; y offset for parent facing direction
DirYTbl:
@1a73:  .byte   $ff,$00,$01,$00

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
        jeq     done
loop:   lda     f:ShortEntrancePtrs,x   ; check xy position
        cmp     $af
        beq     do_entrance
        txa
        clc
        adc     #6
        tax
        cpx     $1e
        bne     loop
        jmp     done

do_entrance:
        lda     #$0001
        sta     $078e
        lda     f:ShortEntrancePtrs+2,x
        and     #$0200
        beq     :+
        jsr     SetParentMap
:       lda     f:ShortEntrancePtrs+2,x
        and     #$01ff
        cmp     #$01ff
        beq     load_parent_map
        lda     f:ShortEntrancePtrs+2,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     :+
        lda     f:ShortEntrancePtrs+4,x
        sta     $1f60
        shorta0
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
:       lda     f:ShortEntrancePtrs+4,x
        sta     $1fc0
        shorta0
        lda     f:ShortEntrancePtrs+3,x   ; facing direction
        lsr4
        and     #$03
        sta     $0743
        lda     f:ShortEntrancePtrs+3,x   ; show map name
        and     #$08
        sta     $0745
        lda     #$01        ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:ShortEntrancePtrs+3,x
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

load_parent_map:
        jsr     RestoreParentMap
        longa
        lda     f:ShortEntrancePtrs+2,x
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
        lda     f:ShortEntrancePtrs+3,x
        and     #$08
        sta     $0745
        lda     #$80
        sta     $11fa
        lda     #1
        sta     $84
        jsr     FadeOut
        jsr     PushPartyMap
        rts
done:   shorta0
        rts
.endproc  ; CheckShortEntrance

; ------------------------------------------------------------------------------

.pushseg
.segment "short_entrance"

; df/bb00
begin_block ShortEntrancePtrs, $1f00
        make_ptr_tbl_rel ShortEntrance, SHORT_ENTRANCE_ARRAY_LENGTH, ShortEntrancePtrs
        .addr ShortEntranceEnd - ShortEntrancePtrs

; df/bf02
ShortEntrance:
        .incbin "trigger/short_entrance.dat"
        ShortEntranceEnd := *

end_block ShortEntrancePtrs

.popseg

; ------------------------------------------------------------------------------
