; ------------------------------------------------------------------------------

.include "field/long_entrance.inc"
.include "field/short_entrance.inc"

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ check entrance triggers ]

CheckEntrances:
@18a3:  lda     $84         ; return if a map is loading
        bne     @18e3
        lda     $59         ; return if menu is opening
        bne     @18e3
        lda     $85         ; return if entrance triggers are disabled
        bne     @18e3
        lda     $56         ; return if entering battle
        bne     @18e3
        ldy     $0803       ; return if between tiles
        lda     $086a,y
        and     #$0f
        bne     @18e3
        lda     $086d,y
        and     #$0f
        bne     @18e3
        ldx     $e5         ; return if an event is running
        cpx     #.loword(EventScript_NoEvent)
        bne     @18e3
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     @18e3
        lda     $b8         ; branch if on a bridge tile
        and     #$04
        beq     @18dd
        lda     $b2         ; return if party is not on upper z-level
        cmp     #$01
        bne     @18e3
@18dd:  jsr     CheckLongEntrance
        jsr     CheckShortEntrance
@18e3:  rts

; ------------------------------------------------------------------------------

; [ check long entrance triggers ]

CheckLongEntrance:
@18e4:  longa
        lda     $82
        asl
        tax
        lda     f:LongEntrancePtrs+2,x
        sta     $1e
        lda     f:LongEntrancePtrs,x
        tax
        cmp     $1e
        jeq     @1a26
        shorta0
@18ff:  stz     $26
        stz     $28
        lda     f:LongEntrancePtrs+2,x
        bmi     @192b
        sta     $1a
        lda     f:LongEntrancePtrs+1,x
        cmp     $b0
        bne     @194d
        lda     $af
        sec
        sbc     f:LongEntrancePtrs,x
        bcc     @194d
        sta     $26
        lda     f:LongEntrancePtrs,x
        clc
        adc     $1a
        cmp     $af
        bcs     @195c
        bra     @194d
@192b:  and     #$7f
        sta     $1a
        lda     f:LongEntrancePtrs,x
        cmp     $af
        bne     @194d
        lda     $b0
        sec
        sbc     f:LongEntrancePtrs+1,x
        bcc     @194d
        sta     $28
        lda     f:LongEntrancePtrs+1,x
        clc
        adc     $1a
        cmp     $b0
        bcs     @195c
@194d:  longa_clc
        txa
        adc     #7
        tax
        shorta0
        cpx     $1e
        bne     @18ff
        rts
@195c:  lda     #$01
        sta     $078e
        longa
        lda     f:LongEntrancePtrs+3,x
        and     #$0200
        beq     @196f
        jsr     SetParentMap
@196f:  lda     f:LongEntrancePtrs+3,x
        and     #$01ff
        cmp     #$01ff
        beq     @19e0
        lda     f:LongEntrancePtrs+3,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     @199f       ; branch if not a world map
        lda     f:LongEntrancePtrs+5,x
        sta     $1f60
        shorta0
        lda     #$01
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
@199f:  lda     f:LongEntrancePtrs+5,x   ; destination xy position
        sta     $1fc0
        shorta0
        lda     f:LongEntrancePtrs+4,x   ; facing direction
        and     #$30
        lsr4
        sta     $0743
        lda     f:LongEntrancePtrs+4,x   ; show map name
        and     #$08
        sta     $0745
        lda     #$01        ; destination z-level (0 = upper, 1 = lower)
        sta     $0744
        lda     f:LongEntrancePtrs+4,x
        and     #$04
        beq     @19d0       ; branch if upper z-layer
        lsr
        sta     $0744
@19d0:  lda     #1        ; enable map load
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts
@19e0:  jsr     RestoreParentMap
        longa
        lda     f:LongEntrancePtrs+3,x
        and     #$fe00
        ora     $1f69
        sta     $1f64
        shorta0
        ldx     $1f69
        cpx     #$0003
        bcs     @1a0e       ; branch if not a world map
        ldy     $1f6b
        sty     $1f60
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
@1a0e:  lda     $1f68
        sta     $0743
        lda     f:LongEntrancePtrs+4,x
        and     #$08
        sta     $0745
        jsr     FadeOut
        lda     #$80
        sta     $11fa
        rts
@1a26:  shorta0
        rts

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

SetParentMap:
@1a2a:  longa
        lda     $82
        and     #$01ff
        sta     $1f69       ; parent map
        lda     $af
        sta     $1f6b       ; parent xy position
        shorta0
        ldy     $0803
        lda     $087e,y
        sta     $1fd2       ; parent map facing direction
        rts

; ------------------------------------------------------------------------------

; [ restore parent map position ]

RestoreParentMap:
@1a46:  phx
        shorta0
        lda     $1fd2       ; parent facing direction
        and     #$03
        eor     #$02        ; invert
        tax
        eor     #$80
        sta     $1f68       ; set facing direction
        lda     $1f6b
        clc
        adc     f:DirXTbl,x   ; x offset for parent facing direction
        sta     $1f6b
        lda     $1f6c
        clc
        adc     f:DirYTbl,x   ; y offset for parent facing direction
        sta     $1f6c
        plx
        rts

; ------------------------------------------------------------------------------

; x offset for parent facing direction
DirXTbl:
@1a6f:  .byte   $00,$01,$00,$ff

; y offset for parent facing direction
DirYTbl:
@1a73:  .byte   $ff,$00,$01,$00

; ------------------------------------------------------------------------------

; [ check short entrance triggers ]

CheckShortEntrance:
@1a77:  longa
        lda     $82
        asl
        tax
        lda     f:ShortEntrancePtrs+2,x
        sta     $1e
        lda     f:ShortEntrancePtrs,x
        tax
        cmp     $1e
        jeq     @1b77
@1a8f:  lda     f:ShortEntrancePtrs,x   ; check xy position
        cmp     $af
        beq     @1aa4
        txa
        clc
        adc     #6
        tax
        cpx     $1e
        bne     @1a8f
        jmp     @1b77
@1aa4:  lda     #$0001
        sta     $078e
        lda     f:ShortEntrancePtrs+2,x
        and     #$0200
        beq     @1ab6
        jsr     SetParentMap
@1ab6:  lda     f:ShortEntrancePtrs+2,x
        and     #$01ff
        cmp     #$01ff
        beq     @1b27
        lda     f:ShortEntrancePtrs+2,x
        sta     $1f64
        and     #$01ff
        cmp     #$0003
        bcs     @1ae6
        lda     f:ShortEntrancePtrs+4,x
        sta     $1f60
        shorta0
        lda     #1
        sta     $84
        jsr     PushPartyMap
        jsr     FadeOut
        rts
@1ae6:  lda     f:ShortEntrancePtrs+4,x
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
        beq     @1b17
        lsr
        sta     $0744
@1b17:  jsr     FadeOut
        lda     #$80
        sta     $11fa
        lda     #1
        sta     $84
        jsr     PushPartyMap
        rts
@1b27:  jsr     RestoreParentMap
        longa
        lda     f:ShortEntrancePtrs+2,x
        and     #$fe00
        ora     $1f69
        sta     $1f64
        shorta0
        ldx     $1f69
        cpx     #$0003
        bcs     @1b52
        ldy     $1f6b
        sty     $1f60
        lda     #$01
        sta     $84
        jsr     FadeOut
        rts
@1b52:  lda     $1f68
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
@1b77:  shorta0
        rts

; ------------------------------------------------------------------------------

.pushseg
.segment "short_entrance"

; df/bb00
begin_fixed_block ShortEntrancePtrs, $1f00
        make_ptr_tbl_rel ShortEntrance, SHORT_ENTRANCE_ARRAY_LENGTH, ShortEntrancePtrs
        .addr ShortEntranceEnd - ShortEntrancePtrs

; df/bf02
ShortEntrance:
        .incbin "trigger/short_entrance.dat"
        ShortEntranceEnd := *

end_fixed_block ShortEntrancePtrs

.popseg

; ------------------------------------------------------------------------------
