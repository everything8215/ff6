; ------------------------------------------------------------------------------

; [ init roulette cursor (monster attacker) ]

InitMonsterRoulette:
        stz     near w7e62b6
        stz     near w7e62b9
        stz     near w7e62bb
        stz     near w7e62bb+1
        jsr     Rand
        and     #$7f
        clc
        adc     #$80
        sta     near w7e62b8
        sta     near w7e62ba
        inc     near w7e62b5       ; enable roulette cursor
        rts

; ------------------------------------------------------------------------------

; [ update roulette cursor (monster attacker) ]

UpdateMonsterRoulette:
        lda     near w7e62b5       ; return if roulette cursor is disabled
        beq     @b43c

; determine valid targets for roulette cursor
        stz     $3a
        clr_ax
@b3d7:  lda     near wCharGfxDataBuf::ActiveStatus1,x
        asl
        ror     $3a
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @b3d7
        lda     $3a         ; $3a = characters without wound status
        lsr4
        not_a
        sta     $3a
        lda     near w7e201d       ;
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        sta     $36         ; $36 = visible characters
        lda     z92         ;
        and     $3a         ; mask characters with wound status
        ora     $36         ; add visible characters
        beq     @b43c       ; return if there are no characters
        lda     near w7e62b9
        beq     @b421       ;
        lda     z0e         ; frame counter
        and     #%1
        beq     @b43c       ; return on even frames
        dec     near w7e62b7       ;
        bne     @b439
        ldx     near w7e62bb
        stx     near w7e2f42           ; set roulette target
        stz     near w7e62b5
        rts

;
@b421:  lda     near w7e62b6
        beq     @b43f
        lda     z0e         ; frame counter
        and     #%111
        bne     @b49b       ; every 8 frames
        dec     near w7e62b7       ; decrement ??? counter
        bne     @b45b
        inc     near w7e62b9
        lda     #$20        ; set ??? counter to 32 * 8 frames (4.25 seconds)
        sta     near w7e62b7
@b439:  jmp     @b49b

; return
@b43c:  jmp     @b516

;
@b43f:  lda     near w7e62ba
        bne     @b452
        jsr     Rand
        and     #$07
        clc
        adc     #$08        ; (8..15)
        sta     near w7e62b7
        inc     near w7e62b6
@b452:  dec     near w7e62ba
        lda     z0e         ; frame counter
        and     #%11
        bne     @b49b       ; every 4 frames
@b45b:  inc     near w7e62b8
        lda     near w7e62b8
        and     #$08
        beq     @b487

; monster target
        lda     near w7e62b8
        and     #$07
        tax
        lda     near w7e201d
        and     near w7e61ac
        and     near w7e61ad
        and     near w7e6193
        and     $3a
        and     f:BitOrTbl,x
        beq     @b45b
        sta     near w7e62bb
        stz     near w7e62bb+1
        bra     @b49b

; character target
@b487:  lda     near w7e62b8
        and     #$07
        tax
        lda     z92
        and     f:BitOrTbl,x
        beq     @b45b
        sta     near w7e62bb+1
        stz     near w7e62bb

; draw roulette cursor sprite
@b49b:  ldx     #$38e0      ; +$3a = tile data for cursor
        stx     $3a
        lda     near w7e62bb       ;
        beq     @b4d5

; cursor on character
        jsr     GetBitNum       ; get bit number
        asl
        tax
        lda     near w7e809f,x     ; character front offset (0 if facing left)
        beq     @b4b3       ; branch if facing left
        lda     #$78
        sta     $3b
@b4b3:  lda     near w7e8087+1,x
        and     #$01
        bne     @b4cd
        lda     near w7e8093+1,x
        and     #$01
        bne     @b4cd
        lda     near w7e8087,x
        sta     $36
        lda     near w7e8093,x
        sta     $37
        bra     @b500
@b4cd:  lda     #$e0
        sta     $36
        sta     $37
        bra     @b500

; cursor on monster
@b4d5:  lda     near w7e62bb+1
        beq     @b516
        jsr     GetBitNum       ; get bit number
        asl
        tax
        lda     near w7e807b,x
        beq     @b4e8
        lda     #$78        ; flip horizontally
        sta     $3b
@b4e8:  lda     near w7e8063+1,x
        and     #$01
        bne     @b4cd
        lda     near w7e806f+1,x
        and     #$01
        bne     @b4cd
        lda     near w7e8063,x
        sta     $36
        lda     near w7e806f,x
        sta     $37
@b500:  lda     z71         ; next available sprite
        longa
        asl2
        tax
        lda     $36
        sta     $0300,x     ; set sprite data
        lda     $3a
        sta     $0302,x
        shorta0
        inc     z71         ; increment number of active sprites
@b516:  rts

; ------------------------------------------------------------------------------

; [ init cursor sprites ]

.proc InitCursorSprites
        clr_ax
        lda     #$38                    ; priority 3, sprite palette 4
:       sta     near w7e88e3+3,x
        inx4
        cpx     #$0028
        bne     :-
        ldx     #make_word $e0, $e0     ; set tile id for menu cursors
        stx     near w7e7a6f
        ldx     #make_word $e0, $e2     ; $e2 for the scroll arrows is unused
        stx     near w7e7a6f+2
        rts
.endproc  ; InitCursorSprites

; ------------------------------------------------------------------------------

; flashing scroll arrows sprite data (both, down, up; not flashing, then flashing)
ScrollArrowsTileTbl:
@b534:  .word   $38e2   ; both
        .word   $78e2   ; both
        .word   $38e2   ; down
        .word   $b8e4   ; down
        .word   $38e2   ; up
        .word   $38e4   ; up

; ------------------------------------------------------------------------------

; [ update cursor sprites ]

DrawCursorSprites:

; arrow sprite for selected character
@b540:  shorti
        lda     near w7e62be
        bne     @b595
        lda     near w7e62bd
        bne     @b595
        lda     near w7e632f
        beq     @b595
        lda     near w7e62ca       ; active character (arrow indicator)
        asl5
        tax
        longi
        jsr     _c134a5
        shorti
        lda     near w7e62ca       ; active character (arrow indicator)
        asl
        tax
        lda     near w7e8033+1,x     ; center x position (high byte)
        and     #$01
        bne     @b595       ; branch if greater than $0100 (hide arrow if character is offscreen)
        lda     near w7e803b+1,x     ; center y position (high byte)
        and     #$01
        bne     @b595       ; branch if greater than $0100 (hide arrow if character is offscreen)
        lda     near w7e8033,x     ; character center x position - 8 (left y position)
        sec
        sbc     #$08
        sta     $0318       ; set arrow sprite x position
        lda     near w7e803b,x     ; character center y position - 24 (top y position)
        sec
        sbc     #$18
        clc
        adc     $38         ;
        sta     $0319       ; set arrow sprite y position
        lda     #$2e
        sta     $031a
        lda     #$28
        sta     $031b
        bra     @b59d
@b595:  lda     #$e0        ; hide arrow sprite
        sta     $0318
        sta     $0319

; extra cursor sprite for selected item in item list
@b59d:  lda     near w7e7baf
        beq     @b5c4
        lda     near w7e7bb0
        sta     near w7e88e7+1
        lda     #1
        sta     near w7e88e7
        longi
        ldx     near w7e7bb1
        cpx     near w7e7bb3
        bcc     @b5c4
        cpx     #$00ca
        bcs     @b5c4
        lda     near w7e7bb1
        sta     near w7e88e7+2
        bra     @b5c7
@b5c4:  stz     near w7e88e7

; extra cursor sprite for selected item in equip menu
@b5c7:  shorti
        stz     near w7e88eb
        lda     near w7e7bb5
        beq     @b5e0
        lda     near w7e7bb6
        sta     near w7e88eb+1
        inc     near w7e88eb
        lda     near w7e7bb7
        sta     near w7e88eb+2

; draw menu cursors (main, item select, equip select)
@b5e0:  clr_axy
@b5e3:  lda     near w7e88e3,y
        bne     @b5f2
        lda     #$e0
        sta     $04f0,y     ; hide cursor
        sta     $04f1,y
        bra     @b60a
@b5f2:  lda     near w7e88e3+1,y     ; cursor x position
        sta     $04f0,y
        lda     near w7e88e3+2,y     ; cursor y position
        sta     $04f1,y
        lda     near w7e88e3+3,y     ; cursor vhoopppm
        sta     $04f3,y
        lda     near w7e7a6f,x     ; cursor tile index
        sta     $04f2,y
@b60a:  inx                 ; next cursor
        iny4
        cpy     #$0c
        bne     @b5e3

; scroll arrows sprite
        lda     near w7e88e3,y
        bne     @b622                   ; branch if active
        lda     #$e0
        sta     $04f0,y                 ; hide scroll arrows
        sta     $04f1,y
        bra     @b64e
@b622:  lda     near w7e88e3+1,y             ; scroll arrows x position
        sta     $04f0,y
        lda     near w7e88e3+2,y             ; scroll arrows y position
        sta     $04f1,y
        lda     z0e                     ; frame counter
        lsr3
        and     #%10                    ; flash every 16 frames
        sta     $36
        lda     near w7e88e3+3,y             ; 0 = both, 1 = down, 2 = up
        asl2
        clc
        adc     $36
        tax
        lda     f:ScrollArrowsTileTbl,x
        sta     $04f2,y
        lda     f:ScrollArrowsTileTbl+1,x
        sta     $04f3,y

; character/monster target cursors
@b64e:  jsr     UpdateTargetCursors
        clr_ay
@b653:  lda     near w7e88f3,y     ; character/monster cursor
        bne     @b662       ; branch if active
        lda     #$e0
        sta     $0300,y     ; hide cursor
        sta     $0301,y
        bra     @b679
@b662:  lda     near w7e88f3+1,y     ; cursor x position
        sta     $0300,y
        lda     near w7e88f3+2,y     ; cursor y position
        sta     $0301,y
        lda     near w7e88f3+3,y     ; cursor vhoopppm
        sta     $0303,y
        lda     #$e0        ; cursor tile = $e0
        sta     $0302,y
@b679:  iny4                ; next cursor (6 total)
        cpy     #$18
        bne     @b653
        longi
        rts

; ------------------------------------------------------------------------------

; [ update character/monster cursor sprite data ]

UpdateTargetCursors:
        .i8
@b684:  clr_ax
        lda     #$38        ; vhoopppm for all cursors = $38
@b688:  sta     near w7e88f3+3,x
        stz     near w7e88f3,x     ; disable all character/monster cursors
        sta     near w7e88ff+3,x
        stz     near w7e88ff,x
        inx4
        cpx     #$0c
        bne     @b688
        lda     near w7e7b7f       ; branch if cursors are on one side only
        beq     @b6a9
        lda     z0e         ; frame counter
        and     #%1
        beq     @b6ae       ; show cursors on monsters on odd frames
        bra     @b702
@b6a9:  lda     near w7e7b7d
        beq     @b702

; cursors on characters
@b6ae:  clr_axy
        lda     near w7e7b7d       ; characters with cursors shown
        and     near w7e201d       ; ignore hidden characters
        and     near w7e61ac       ;
        and     near w7e61ad
        and     near w7e6193       ; clear characters acting as enemies
        sta     $36
@b6c2:  lsr     $36
        bcc     @b6f6       ; skip cursor
        lda     near w7e809f,y     ; character cursor x offset
        beq     @b6d0       ; branch if facing left
        lda     #$78
        sta     near w7e88f3+3,x     ; vhoopppm = $78 (horizontally flipped)
@b6d0:  lda     near w7e8087+1,y     ; character right x position (high byte)
        and     #$01
        bne     @b6f6       ; skip if offscreen
        lda     near w7e8093+1,y     ; character center y position (high byte)
        and     #$01
        bne     @b6f6       ; skip if offscreen
        lda     near w7e8093,y     ; character center y position
        cmp     #$a0
        bcs     @b6f6       ; skip if below battlefield region
        lda     #$01
        sta     near w7e88f3,x     ; enable cursor
        lda     near w7e8087,y     ; character right x position
        sta     near w7e88f3+1,x
        lda     near w7e8093,y     ; character center x position
        sta     near w7e88f3+2,x
@b6f6:  iny2                ; next cursor
        inx4
        cpx     #$18
        bne     @b6c2
        bra     @b74a

; cursors on monsters
@b702:  clr_axy
        lda     near w7e7b7e
        and     z92
        sta     $36
@b70c:  lsr     $36
        bcc     @b740
        lda     near w7e807b,y
        beq     @b71a
        lda     #$78
        sta     near w7e88f3+3,x
@b71a:  lda     near w7e8063+1,y
        and     #$01
        bne     @b740
        lda     near w7e806f+1,y
        and     #$01
        bne     @b740
        lda     near w7e806f,y
        cmp     #$a0
        bcs     @b740
        lda     #$01
        sta     near w7e88f3,x
        lda     near w7e8063,y
        sta     near w7e88f3+1,x
        lda     near w7e806f,y
        sta     near w7e88f3+2,x
@b740:  iny2
        inx4
        cpx     #$18
        bne     @b70c
@b74a:  rts
        .i16

; ------------------------------------------------------------------------------
