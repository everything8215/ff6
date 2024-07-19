
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: text.asm                                                             |
; |                                                                            |
; | description: dialogue text routines                                        |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

inc_lang "text/item_name_%s.inc"
inc_lang "text/magic_name_%s.inc"
inc_lang "text/map_title_%s.inc"

.import Dlg1, DlgBankInc, DlgPtrs, DTETbl, LargeFontGfx, FontWidth

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init dialog text ]

InitDlgText:
@7f64:  stz     $0568                   ; dialog flags
        stz     $c5                     ; line number
        stz     $cc                     ; dialog window region
        stz     $d3                     ; keypress state
        stz     $c9                     ; dialog pointer
        stz     $ca
        lda     #$cd
        sta     $cb
        stz     $056d                   ; multiple choice selection is not changing
        stz     $056e                   ; clear current multiple choice selection
        stz     $056f                   ; clear maximum multiple choice selection
        stz     $0582                   ; disable multiple choice cursor update
        stz     $d0                     ; dialog index
        stz     $d1
        lda     #$80                    ; text buffer is empty
        sta     $cf
        ldx     $00                     ; set vram pointers to beginning of line 1
        stx     $c1
        stx     $c3
        stx     $0569                   ; pause counter
        stx     $056b                   ; keypress counter
        ldx     #$0700                  ; unused
        stx     $c6
        lda     #$04                    ; current x position on dialog window
        sta     $bf
        stz     $c0                     ; width of current word
        lda     #$e0                    ; max x position on dialog window
        sta     $c8
        ldx     #$9003                  ; clear current character graphics buffer
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     #$0080
@7fb2:  stz     hWMDATA
        dex
        bne     @7fb2
        jsr     ClearTextGfxBuf
        jsr     ClearDlgTextVRAM
        rts

; ------------------------------------------------------------------------------

; [ update pointer to current dialog item ]

GetDlgPtr:
@7fbf:  lda     #^Dlg1                  ; bank byte
        sta     $cb
        longa
        lda     $d0                     ; dialog index
        asl
        tax
        lda     f:DlgPtrs,x             ; pointer to dialog item
        sta     $c9
        lda     $d0                     ; dialog index
        cmp     f:DlgBankInc            ; first dialog item in next bank
        bcc     @7fdc                   ; branch if less
        shorta0
        inc     $cb                     ; increment bank byte
@7fdc:  shorta0
        lda     #1                      ; enable dialog display
        sta     $0568
        rts

; ------------------------------------------------------------------------------

; [ display map name ]

ShowMapTitle:
@7fe5:  stz     $0567                   ; clear map name dialog counter
        lda     $1eb9
        and     #$40                    ; return if party switching is enabled
        bne     @7ff4
        lda     $0745                   ; return if map name dialog is disabled
        bne     @7ff8
@7ff4:  stz     $0745
        rts
@7ff8:  lda     #$64                    ; set counter to 100 frames
        sta     $0567
        lda     #^MapTitle              ; get pointer to map name
        sta     $cb
        lda     $0520
        asl
        tax
        longa_clc
        lda     f:MapTitlePtrs,x
        adc     #.loword(MapTitle)
        sta     $c9
        shorta0
.if LANG_EN
        stz     $c0                     ; clear width of current word
        ldy     $00
@8018:  lda     [$c9],y                 ; get next character
        beq     @8029                   ; branch if end of string
        tax
        lda     f:FontWidth,x           ; get character width
        clc
        adc     $c0                     ; add to width of current word
        sta     $c0
        iny                             ; next character
        bra     @8018
@8029:  lda     #$e0                    ; $bf = ($e0 - width) / 2
        sec                             ; text centered in dialog window
        sbc     $c0
.else
        ldy     $00
        tyx
@8017:  lda     [$c9],y
        beq     @8024
        cmp     #$20
        bcs     @8020
        iny
@8020:  inx
        iny
        bra     @8017
@8024:  txa
        sta     $4202
        lda     #$0c
        sta     $4203
        lda     #$e0
        sec
        sbc     $4216
.endif
        lsr
        sta     $bf
        tay                             ; $c1 = ($bf / 16) * 32
        sty     hWRDIVL                 ; pointer to vram, rounded down to nearest tile
        lda     #$10
        sta     hWRDIVB
        nop7
        lda     hRDDIVL
        sta     hWRMPYA
        lda     #$20
        sta     hWRMPYB
        nop3
        ldy     hRDMPYL
        sty     $c1
@8054:  jsr     UpdateDlgTextOneLine
        jsr     TfrMapTitleGfx
        lda     $0568                   ; branch until complete
        bpl     @8054
        stz     $d3                     ; keypress state
        stz     $cc                     ; text region (will not erase text)
        jsr     OpenMapTitleWindow
        rts

; ------------------------------------------------------------------------------

.if LANG_EN

; [ calculate width of current word ]

; $c0 = calculated width

CalcTextWidth:
@8067:  lda     $cf         ; save text buffer position
        pha
        lda     $cb         ; save pointer to current dialog character
        pha
        ldx     $c9
        phx
        stz     $c0         ; width = 0
@8072:  ldy     $00
        lda     [$c9],y     ; load first letter
        bpl     @80b0       ; branch if not dte
        and     #$7f
        asl
        tax
        lda     $cf
        cmp     #$80
        beq     @8088
        lda     #$80
        sta     $cf
        bra     @809c
@8088:  lda     f:DTETbl,x   ; first dte letter
        cmp     #$7f
        beq     @80d2
        phx
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        plx
@809c:  lda     f:DTETbl+1,x   ; second dte letter
        cmp     #$7f
        beq     @80d2
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        bra     @80c6
@80b0:  ldy     $00
        lda     [$c9],y
        cmp     #$20
        bcc     @80dc       ; branch if a special letter
        cmp     #$7f
        beq     @80d2       ; return if a space
        tax
        lda     f:FontWidth,x   ; width += character width
        clc
        adc     $c0
        sta     $c0
@80c6:  inc     $c9         ; next character
        bne     @8072
        inc     $ca
        bne     @8072
        inc     $cb
        bra     @8072
@80d2:  plx                 ; restore dialog pointer and text buffer position and return
        stx     $c9
        pla
        sta     $cb
        pla
        sta     $cf
        rts
@80dc:  cmp     #$1a        ; branch if item name
        beq     @8118
        cmp     #$02        ; return if end of message or new line
        bcc     @80d2
        cmp     #$10        ; return if not a character name
        bcs     @80d2
        dec                 ; decrement to get character index
        dec
        sta     hWRMPYA
        lda     #$25        ; get pointer to character data
        sta     hWRMPYB
        lda     $cf         ; return if text buffer is not empty
        bpl     @80d2
        lda     #$06        ; six letters
        sta     $1a
        ldy     hRDMPYL
@80fd:  lda     $1602,y     ; get letter
        cmp     #$ff
        beq     @80d2       ; return if no letter
        sec
        sbc     #$60        ; convert to dialog text
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        iny                 ; next letter
        dec     $1a         ; return after 6 letters
        bne     @80fd
        bra     @80d2
@8118:  lda     $0583       ; item index
        sta     hWRMPYA
        lda     #ITEM_NAME_SIZE
        sta     hWRMPYB
        lda     $cf         ; return if text buffer is not empty
        bpl     @80d2
        lda     #ITEM_NAME_SIZE-1
        sta     $1a
        ldx     hRDMPYL
@812e:  txy
        lda     f:ItemName+1,x   ; item name
        cmp     #$ff        ; return if no letter
        beq     @80d2
        sec
        sbc     #$60        ; convert to dialog text
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        tyx
        inx                 ; next letter
        dec     $1a         ; return after 12 letters
        bne     @812e
        bra     @80d2

.endif

; ------------------------------------------------------------------------------

; [ update dialog text ]

UpdateDlgText:
@814c:  longa
        lda     $00                   ; set font shadow color to black
        sta     $7e7204
        sta     $7e7404
        lda     $1d55                   ; set font color
        sta     $7e7202
        sta     $7e7402
        sta     $7e7206
        sta     $7e7406
        shorta0
        lda     $0567                   ; decrement counter for map name dialog window
        beq     @817b
        dec     $0567
        bne     @817b
        jsr     CloseMapTitleWindow
@817b:  lda     $0568                   ; dialog flags
        bne     @8181                   ; return if there's no dialog text
        rts
@8181:  ldx     $0569                   ; decrement counter for dialog pause
        beq     @818b
        dex
        stx     $0569
        rts
@818b:  ldx     $056b                   ; keypress counter
        beq     @81af
        longa
        txa
        and     #$7fff
        tax
        shorta0
        cpx     $00
        bne     @81a8
        stz     $056c
        stz     $d3                     ; keypress state
        stz     $056f
        bra     @81af
@81a8:  ldx     $056b
        dex
        stx     $056b
@81af:  lda     $d3                     ; branch if waiting for keypress
        jeq     @823b
        lda     $056f                   ; max multiple choice selection
        cmp     #$02
        bcc     @821f                   ; branch if 1 or 0
        lda     $056e
        asl
        tax
        longa
        lda     $0570,x                 ; set current cursor position (for erasing the indicator)
        sta     $c3
        shorta0
        lda     $07
        and     #$0f                    ; branch if direction button is down
        bne     @81d7
        stz     $056d                   ; multiple choice selection is not changing
        bra     @8209
@81d7:  lda     $056d                   ; branch if multiple choice selection is already changing
        bne     @821f
        lda     $07
        and     #$0a                    ; branch if up and left are not pressed
        beq     @81f2
        lda     $056e                   ; decrement multiple choice selection
        dec
        bmi     @8209                   ; branch if less than zero (no change)
        sta     $056e
        lda     #1                      ; multiple choice selection is changing
        sta     $056d
        bra     @8209
@81f2:  lda     $07
        and     #$05                    ; branch if up and left are not pressed
        beq     @8209
        lda     $056e                   ; increment multiple choice selection
        inc
        cmp     $056f                   ; branch if equal to max selection (no change)
        beq     @8209
        sta     $056e
        lda     #1                      ; multiple choice selection is changing
        sta     $056d
@8209:  jsr     DrawDlgCursor
        lda     $056e                   ; current selection
        asl
        tax
        longa
        lda     $0570,x                 ; position of multiple choice indicator
        sta     $0580                   ; set current
        shorta0
        inc     $0582                   ; enable update
@821f:  lda     $d3                     ; keypress state
        cmp     #$01
        beq     @822d                   ; branch if waiting for keypress
        lda     $06                     ; a button
        bmi     @8241                   ; decrement keypress and branch if not pressed
        dec     $d3
        bra     @8241
@822d:  lda     $06                     ; return if a button not pressed
        bpl     @8241
        dec     $d3                     ; decrement keypress state
        stz     $056f                   ; disable multiple choice
        stz     $056c                   ; disable keypress timer
        bra     @8241                   ; return
@823b:  lda     $cc                     ; decrement region to clear (getting ready for next page)
        beq     @8242
        dec     $cc
@8241:  rts
@8242:  lda     $0568                   ; dialog flags
        bpl     UpdateDlgTextOneLine
        sta     $ba
        stz     $0568
        rts

UpdateDlgTextOneLine:
@824d:
.if LANG_EN
        jsr     CalcTextWidth
        lda     $bf                     ; add width to current x position
        clc
        adc     $c0
        bcs     @825b                   ; branch if it overflowed
        cmp     $c8
        bcc     @825f                   ; branch if less than max width
@825b:  jsr     NewLine
        rts
@825f:  lda     $cf                     ; branch if text buffer is empty
        bmi     @8284
@8263:  lda     $cf
        tax
        lda     $7e9183,x               ; text buffer
        sta     $cd                     ; set next letter to display
        stz     $ce
        lda     $7e9184,x
        beq     @827a                   ; branch if next letter is terminator
        jsr     DrawDlgText
        inc     $cf                     ; increment buffer position and return
        rts
@827a:  lda     #$80                    ; empty dialog text buffer
        sta     $cf
        jsr     DrawDlgText
        jmp     @829d                   ; increment dialog pointer by 1
@8284:  ldy     $00
        lda     [$c9],y                 ; load current dialog letter
        sta     $bd
        iny
        lda     [$c9],y                 ; load next dialog letter
        sta     $be
        lda     $bd                     ; branch if current letter is dte
        bmi     @829a
        cmp     #$20                    ; branch if special letter
        bcc     @82b5
        jmp     @845a
@829a:  jmp     @8466

.else

@825f:  lda     $cf
        bmi     @81b3
@8263:  lda     $cf
        tax
        lda     $7e9183,x
        cmp     #$20
        bcs     @8195
        sec
        sbc     #$1b
        sta     $ce
        lda     $7e9184,x
        sta     $cd
        lda     $7e9185,x
        beq     @81a9
        jsr     $8405
        inc     $cf
        inc     $cf
        rts
@8195:  lda     $7e9183,x
        sta     $cd
        stz     $ce
        lda     $7e9184,x
        beq     @81a9
        jsr     $8405
        inc     $cf
        rts
@81a9:  lda     #$80
        sta     $cf
        jsr     $8405
        jmp     $81d6
@81b3:  ldy     $00
        lda     [$c9],y
        sta     $bd
        iny
        lda     [$c9],y
        sta     $be
        lda     $bd
        cmp     #$ff
        beq     @81d3
        cmp     #$20
        bcc     @82b5
        cmp     #$d8
        bcc     @81d3
        cmp     #$f0
        bcs     @823f
        jmp     @83cd
@81d3:  jmp     @845a
.endif

; increment dialog pointer
@829d:  lda     #1                      ; increment by 1
        bra     @82a3
@82a1:  lda     #2                      ; increment by 2
@82a3:  clc
        adc     $c9
        sta     $c9
        lda     $ca
        adc     #$00
        sta     $ca
        lda     $cb
        adc     #$00
        sta     $cb
        rts

; special letter $00: end of message
@82b5:  cmp     #$00
        bne     @82c2
        jsr     NewPage
        lda     #$80
        sta     $0568
        rts

; special letter $01: new line
@82c2:  cmp     #$01
        bne     @82cc
        jsr     NewLine
        jmp     @829d                   ; increment dialog pointer by 1

; special letter $02-$0f: character name
@82cc:  cmp     #$10
        bcs     @8302
        dec2
        sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        ldx     $00

.if LANG_EN
@82e3:  lda     $1602,y
        sec
        sbc     #$60
        sta     $7e9183,x
        cmp     #$9f
        beq     @82f8
        iny
        inx
        cpx     #$0006
        bne     @82e3
@82f8:  tdc
        sta     $7e9183,x
        stz     $cf
        jmp     @8263

.else

@821c:  lda     #$1f
        sta     $7e9183,x
        lda     $1602,y
        sta     $7e9184,x
        cmp     #$ff
        beq     @8235
        iny
        inx2
        cpx     #12
        bne     @821c
@8235:  tdc
        sta     $7e9183,x
        stz     $cf
        jmp     $8171

@823f:  sec
        sbc     #$f0
        sta     $4202
        lda     #$25
        sta     $4203
        nop
        nop
        nop
        nop
        ldy     $4216
        ldx     $00
@8253:  lda     $1602,y
        sta     $7e9183,x
        cmp     #$ff
        beq     @8265
        iny
        inx
        cpx     #$0006
        bne     @8253
@8265:  tdc
        sta     $7e9183,x
        stz     $cf
        jmp     $8171
.endif

; special letter $10: pause for 1 second
@8302:  cmp     #$10
        bne     @830f
        ldx     #$003c                  ; 60 frames
        stx     $0569
        jmp     @829d                   ; increment dialog pointer by 1

; special letter $11: pause for x/4 seconds
@830f:  cmp     #$11
        bne     @832a
        lda     $be
        sta     hWRMPYA
        lda     #$0f                    ; divide by 15
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        stx     $0569
        jmp     @82a1                   ; increment dialog pointer by 2

; special letter $12: wait for keypress
@832a:  cmp     #$12
        bne     @8337
        ldx     #$8001                  ; waiting for keypress, timer is 1 frame only
        stx     $056b
        jmp     @829d                   ; increment dialog pointer by 1

; special letter $13: new page
@8337:  cmp     #$13
        bne     @8341
        jsr     NewPage
        jmp     @829d                   ; increment dialog pointer by 1

; special letter $14: tab (x spaces)
@8341:  cmp     #$14
        bne     @8362
        lda     $be                     ; number of spaces
        sta     $1e
        stz     $1f
        ldx     $00
.if LANG_EN
        lda     #$7f                    ; space
.else
        lda     #$ff
.endif
@834f:  sta     $7e9183,x
        inx
        cpx     $1e
        bne     @834f
        tdc                             ; end of string
        sta     $7e9183,x
        stz     $cf
        jmp     @829d                   ; increment dialog pointer by 1

; special letter $15: multiple choice indicator
@8362:  cmp     #$15
        bne     @837f
        lda     $056f                   ; max choice found so far
        asl
        tay
        longa
        lda     $c1                     ; add a multiple choice position
        sta     $0570,y
        shorta0
        lda     #$ff                    ; wide space
        sta     $bd
        inc     $056f                   ; increment number of choices
        jmp     @845a                   ; process like a normal letter

; special letter $16: pause for x/4 seconds, then wait for keypress
@837f:  cmp     #$16
        bne     @83a4
        lda     $be
        sta     hWRMPYA
        lda     #$0f
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        ora     #$8000
        sta     $056b
        shorta0
        lda     #$01                    ; waiting for keypress
        sta     $d3
        jmp     @82a1

; special letter $19: gold quantity
@83a4:  cmp     #$19
        bne     @83d3
        stz     $1a
        ldx     $00
        txy
@83ad:  lda     $1a
        bne     @83b8
        lda     $0755,y
        beq     @83c3
        inc     $1a
@83b8:  lda     $0755,y
        clc
.if LANG_EN
        adc     #$54
.else
        adc     #$53
.endif
        sta     $7e9183,x
        inx
@83c3:  iny
        cpy     #$0007
        bne     @83ad
        tdc
        sta     $7e9183,x
        stz     $cf
        jmp     @8263

; special letter $1a: item name
@83d3:  cmp     #$1a
        bne     @840f
        lda     $0583
        sta     hWRMPYA
        lda     #ITEM_NAME_SIZE
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
        lda     #$7e
        pha
        plb
@83ee:  lda     f:ItemName+1,x          ; ignore symbol

.if LANG_EN
        sec
        sbc     #$60
        sta     $9183,y
        cmp     #$9f
.else
        sta     $9183,y
        cmp     #$ff
.endif
        beq     @8403
        inx
        iny
        cpy     #ITEM_NAME_SIZE-1
        bne     @83ee
@8403:  tdc
        sta     $9183,y
        tdc
        pha
        plb
        stz     $cf
        jmp     @8263

; special letter $1b: spell name
@840f:  cmp     #$1b
        bne     @844b
        lda     $0584
        sta     hWRMPYA
        lda     #4                      ; carried over from ff6j, should be 7
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
        lda     #$7e
        pha
        plb
@842a:  lda     f:MagicName+1,x
.if LANG_EN
        sec                             ; subtract $60 to convert to big font
        sbc     #$60
        sta     $9183,y                 ; store in buffer
        cmp     #$9f                    ; break if $ff was reached
.else
        sta     $9183,y
        cmp     #$ff
.endif
        beq     @843f
        inx
        iny
        cpy     #$0004                  ; copy up to 4 bytes (should be 7)
        bne     @842a
@843f:  tdc
        sta     $9183,y                 ; store $00 in the last byte
        tdc
        pha
        plb
        stz     $cf
        jmp     @8263

; special letter $1c-$1f: extra japanese characters (unused)
@844b:  sec
        sbc     #$1b
        sta     $ce
        lda     $be
        sta     $cd
        jsr     DrawDlgText
        jmp     @82a1                   ; increment dialog pointer by 2

; $20-$7f: normal letter
@845a:  lda     $bd
        sta     $cd
        stz     $ce
        jsr     DrawDlgText
        jmp     @829d                   ; increment dialog pointer by 1

; $80-$ff: dte
.if LANG_EN
@8466:  and     #$7f
        asl
        tay
        ldx     #.loword(DTETbl)        ; pointer to dte table
        stx     $2a
        lda     #^DTETbl
        sta     $2c
        lda     [$2a],y
        sta     $7e9183                 ; store first byte in text buffer
        iny
        lda     [$2a],y
        sta     $7e9184                 ; store second byte in text buffer
        tdc
        sta     $7e9185                 ; end of string
        stz     $cf                     ; set text position to 0
        jmp     @8263                   ; write both letters
.else
@83cd:  sec
        sbc     #$d8
        asl
        tax
        rep     #$20
        lda     $c08bb0,x
        sta     $2a
        tdc
        sep     #$20
        lda     #$c0
        sta     $2c
        ldx     $00
        txy
@83e4:  lda     [$2a],y
        beq     @83fc
        cmp     #$20
        bcs     @83f4
        sta     $7e9183,x
        iny
        inx
        lda     [$2a],y
@83f4:  sta     $7e9183,x
        iny
        inx
        bra     @83e4
@83fc:  sta     $7e9183,x
        stz     $cf
        jmp     $8171
.endif

; ------------------------------------------------------------------------------

.if LANG_EN

; [ load dialog font widths ]

InitDlgVWF:
@848a:  lda     #$7e                    ; set wram address
        sta     hWMADDH
        ldx     #$9e00
        stx     hWMADDL
        ldx     $00
@8497:  lda     f:FontWidth,x           ; copy widths for letters $00-$7f
        sta     hWMDATA
        inx
        cpx     #$0080
        bne     @8497
        ldx     #.loword(DTETbl)        ; set a pointer to the dte table
        stx     $2a
        lda     #^DTETbl
        sta     $2c
        ldx     $00
        txy
@84b0:  stz     $1a
        lda     [$2a],y
        tax
        lda     f:FontWidth,x           ; get the width of the first letter
        sta     $1a
        iny
        lda     [$2a],y
        tax
        lda     f:FontWidth,x           ; add the width of the second letter
        clc
        adc     $1a
        sta     hWMDATA                 ; store in wram
        iny
        cpy     #$0100
        bne     @84b0
        rts

.endif

; ------------------------------------------------------------------------------

; [ update dialog text graphics ]

DrawDlgText:
@84d0:  ldx     $cd                     ; letter number
        lda     f:FontWidth,x           ; letter width
        clc
        adc     $bf                     ; add to current x position
        cmp     $c8
        bcc     @84e1                   ; branch if less than max position
        jsr     NewLine
        rts
@84e1:  jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        ldx     $c1                     ; set vram tile address
        stx     $c3
        inc     $c5                     ; text graphics needs to get copied
        ldx     $cd                     ; letter index
        lda     $bf                     ; x position
        and     #$0f
        clc
        adc     f:FontWidth,x           ; add letter width
        and     #$f0
        beq     @850e                   ; branch if it hasn't reached the next tile
        jsr     ShiftPrevLetter
        longa_clc
        lda     $c1                     ; increment tile vram pointer
        adc     #$0020
        sta     $c1
        shorta0
@850e:  ldx     $cd                     ; letter index
        lda     $bf                     ; x position
        clc
        adc     f:FontWidth,x           ; add letter width
        sta     $bf                     ; set new x position
        rts

; ------------------------------------------------------------------------------

; [ new line ]

NewLine:
@851a:  lda     #$ff                    ; new line ($00ff)
        sta     $cd
        stz     $ce
        jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        lda     #$04                    ; set x position back to the left
        sta     a:$00bf
        longa_clc
        lda     $c1                     ; set tile vram address
        sta     $c3
        and     #$0600                  ; move vram pointer to next line
        adc     #$0200
        and     #$07ff
        sta     $c1
        shorta0
        inc     $c5                     ; text graphics needs to get copied
        jsr     ClearTextGfxBuf
        ldx     $c1                     ; return unless end of page was reached
        bne     @8553
        lda     #$09                    ; text fully displayed
        sta     $cc
        lda     #$02                    ; waiting for key release
        sta     $d3
@8553:  rts

; ------------------------------------------------------------------------------

; [ new page ]

NewPage:
@8554:  lda     #$ff                    ; new line ($00ff)
        sta     $cd
        stz     $ce
        jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        lda     #$04                    ; set x position back to the left
        sta     a:$00bf
        ldx     $c1                     ; set tile vram address
        stx     $c3
        inc     $c5                     ; text graphics needs to get copied
        ldx     $00
        stx     $c1                     ; move vram pointer to top of page
        jsr     ClearTextGfxBuf
        lda     #$09                    ; text fully displayed
        sta     $cc
        lda     #$02                    ; waiting for key release
        sta     $d3
        rts

; ------------------------------------------------------------------------------

; [ clear all dialog text graphics in vram ]

ClearDlgTextVRAM:
@857e:  stz     hMDMAEN
        ldx     #$3800
        stx     hVMADDL
        lda     #$80
        sta     hVMAINC
        lda     #$09
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$0000
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$1000                  ; clear $3800-$3fff in vram
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        rts

; ------------------------------------------------------------------------------

; [ clear dialog text graphics region in vram ]

ClearDlgTextRegion:
@85b0:  lda     $cc                     ; current dialog text region to clear
        beq     @85f2
        cmp     #$09                    ; return if none
        beq     @85f2
        dec
        asl
        tax
        longa
        lda     f:_c085f3,x             ; set vram address
        sta     hVMADDL
        shorta0
        stz     hMDMAEN                 ; disable dma
        lda     #$80
        sta     hVMAINC                 ; clear $01c0 bytes (copy from $00)
        lda     #$09
        sta     $4300                   ; fixed address dma to $2118
        lda     #$18
        sta     $4301
        ldx     #$0000
        stx     $4302
        lda     #$00
        sta     $4304
        sta     $4307
        ldx     #$01c0                  ; 7 tiles (32x32, 2bpp)
        stx     $4305
        lda     #$01
        sta     hMDMAEN
@85f2:  rts

; ------------------------------------------------------------------------------

; pointers to dialog text regions in vram
_c085f3:
@85f3:  .word   $3ee0,$3e00,$3ce0,$3c00,$3ae0,$3a00,$38e0,$3800

; ------------------------------------------------------------------------------

; [ copy dialog text graphics to vram ]

TfrDlgTextGfx:
@8603:  lda     $c5                     ; return if there's no tile to be copied
        beq     _8641
        stz     $c5

TfrMapTitleGfx:
@8609:  stz     hMDMAEN
        lda     #$80                    ; vram control register
        sta     hVMAINC
        longa_clc
        lda     $c3                     ; vram destination
        adc     #$3800
        sta     hVMADDL
        shorta0
        lda     #$41                    ; dma control register
        sta     $4300
        lda     #$18                    ; dma destination register
        sta     $4301
        ldx     #$9083                  ; dma source address
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0040                  ; dma size (four 2bpp tiles)
        stx     $4305
        lda     #$01
        sta     hMDMAEN
_8641:  rts

; ------------------------------------------------------------------------------

; [ copy dialog text graphics to vram buffer ]

; copies one 16x16 tile per frame

CopyDlgTextToBuf:
@8642:  lda     #$7e
        pha
        plb

; left two 8x8 tiles
.repeat 8, i
        stz     $9083+i                 ; top 4 rows of pixels are always blank
.endrep
.repeat 12, i
        lda     $9104+i*2               ; copy left half of tiles
        sta     $908b+i*2               ; bp 1-2
        lda     $9144+i*2
        sta     $908c+i*2               ; bp 3-4
.endrep

; right two 8x8 tiles
.repeat 8, i
        stz     $90a3+i                 ; top 4 rows of pixels are always blank
.endrep
.repeat 12, i
        lda     $9103+i*2               ; copy right half of tiles
        sta     $90ab+i*2
        lda     $9143+i*2
        sta     $90ac+i*2
.endrep
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ copy multiple choice indicator graphics to vram buffer ]

DrawDlgCursor:
@879a:  ldx     #$9083
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
.repeat 8
        stz     hWMDATA
.endrep
        ldx     $00
        txy
@87c0:  lda     f:DlgCursorGfx,x
        sta     hWMDATA
        lsr
        sta     hWMDATA
        inx
        cpx     #12
        bne     @87c0
.repeat 32
        stz     hWMDATA
.endrep
        rts

; ------------------------------------------------------------------------------

; multiple choice indicator graphics
DlgCursorGfx:
@8832:  .byte   $20,$30,$38,$3c,$3e,$3f,$3e,$3c,$38,$30,$20,$00

; ------------------------------------------------------------------------------

; [ copy multiple choice indicator graphics to vram ]

TfrDlgCursorGfx:
@883e:  lda     $0582
        beq     @88a8
        stz     $0582
        lda     #$80
        sta     hVMAINC
        stz     hMDMAEN
        longa_clc
        lda     $c3         ; old cursor position
        adc     #$3800
        sta     hVMADDL
        shorta0
        lda     #$41
        sta     $4300
        lda     #$18
        sta     $4301
        ldx     #$90a3
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0020
        stx     $4305
        lda     #$01
        sta     hMDMAEN
        stz     hMDMAEN
        longa_clc
        lda     $0580       ; multiple choice position
        adc     #$3800
        sta     hVMADDL
        shorta0
        ldx     #$9083
        stx     $4302
        lda     #$7e
        sta     $4304
        sta     $4307
        ldx     #$0020
        stx     $4305
        lda     #$01
        sta     hMDMAEN
@88a8:  rts

; ------------------------------------------------------------------------------

; [ clear text graphics buffer ]

ClearTextGfxBuf:
@88a9:  lda     #$7e
        sta     hWMADDH
        ldx     #$9103      ; clear $9103-$9182
        stx     hWMADDL
        ldx     #$0010
@88b7:
.repeat 8
        stz     hWMDATA
.endrep
        dex
        bne     @88b7
        rts

; ------------------------------------------------------------------------------

; [ copy letter graphics to text graphics buffer ]

DrawLetter:
@88d3:  lda     #$7e
        pha
        plb
        lda     a:$00bf                 ; branch if on an even tile
        and     #$08
        jne     @8924

; odd tile
        ldx     $00
@88e3:
.repeat 2, i
        lda     $9104+i*$40,x           ; left part
        ora     $9004+i*$40,x
        sta     $9104+i*$40,x
        lda     $9103+i*$40,x           ; middle part
        ora     $9003+i*$40,x
        sta     $9103+i*$40,x
        lda     $9124+i*$40,x           ; right part
        ora     $9024+i*$40,x
        sta     $9124+i*$40,x
.endrep
        inx2
        cpx     #$0020
        bne     @88e3
        tdc
        pha
        plb
        rts

; even tile
@8924:  ldx     $00
@8926:
.repeat 2, i
        lda     $9103+i*$40,x           ; left part
        ora     $9004+i*$40,x
        sta     $9103+i*$40,x
        lda     $9124+i*$40,x           ; right part
        ora     $9003+i*$40,x
        sta     $9124+i*$40,x
        lda     $9123+i*$40,x           ; middle part
        ora     $9024+i*$40,x
        sta     $9123+i*$40,x
.endrep
        inx2
        cpx     #$0020
        bne     @8926
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ copy next tile to current tile ]

ShiftPrevLetter:
@8967:  lda     #$7e
        pha
        plb
        ldx     $00
@896d:  lda     $9123,x
        sta     $9103,x
        lda     $9163,x
        sta     $9143,x
        tdc
        sta     $9123,x     ; clear next tile
        sta     $9163,x
        inx
        cpx     #$0020
        bne     @896d
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; [ load letter graphics ]

LoadLetterGfx:

@FontGfx := LargeFontGfx-32*22          ; skip first 32 tiles

@898a:  lda     #$7e                    ; clear next letter graphics
        sta     hWMADDH
        ldx     #$9023
        stx     hWMADDL
.repeat 24
        stz     hWMDATA
.endrep
        ldx     #$9063
        stx     hWMADDL
.repeat 24
        stz     hWMDATA
.endrep
        longa
        lda     $cd                     ; x = letter number * 22
        asl
        sta     $1e
        asl
        sta     $20
        asl2
        clc
        adc     $1e
        clc
        adc     $20
        tax
        shorta0
        lda     #$7e
        pha
        plb
        lda     a:$00bf                 ; current x position of text
        and     #$07                    ; get position within 8x8 tile
        cmp     #$04
        jeq     @8b23                   ; branch if 4 (halfway through tile)
        jcs     @8b42                   ; branch if more than 4

; letter needs to shift left
        eor     $02
        clc
        adc     #$05
        sta     $1e                     ; +$1e = 4 - x
        stz     $1f
        longa
.repeat 11, i
        ldy     $1e
        lda     f:@FontGfx+i*2,x        ; letter graphics (first row of pixels)
:       asl                             ; shift left
        dey
        bne     :-
        sta     $9003+i*2               ; move to buffer
        lsr
        sta     $9045+i*2               ; shadow
.endrep
        shorta0
        tdc
        pha
        plb
        rts

; letter doesn't need to shift
@8b23:  longa
        ldy     $00
@8b27:  lda     f:@FontGfx,x            ; letter graphics
        sta     $9003,y
        lsr
        sta     $9045,y                 ; shadow
        inx2
        iny2
        cpy     #$0016                  ; 22 bytes
        bne     @8b27
        shorta0
        tdc
        pha
        plb
        rts

; letter needs to shift right
@8b42:  sec
        sbc     #$04
        sta     $1e                     ; +$1e = x - 4
        stz     $1f
        longa
.repeat 11, i
        ldy     $1e
        lda     f:@FontGfx+i*2,x        ; letter graphics
:       lsr
        ror     $9023+i*2
        dey
        bne     :-
        sta     $9003+i*2
        lsr
        sta     $9045+i*2
        lda     $9023+i*2
        ror
        sta     $9065+i*2
.endrep
        shorta0
        tdc
        pha
        plb
        rts

; ------------------------------------------------------------------------------

; pointers to MTE strings
@8c7b:  .addr   @8cab,@8cae,@8cb3,@8cb6,@8cb9,@8cbe,@8cc1,@8cc4
        .addr   @8cc9,@8ccc,@8cd6,@8cde,@8ce1,@8ce4,@8ce9,@8cf1
        .addr   @8cf4,@8cf9,@8cfe,@8d04,@8d08,@8d0b,@8d0f,@8d12

; MTE strings carried over from ff6j (unused in English translation)
@8cab:  .byte   $c7,$c7,$00
@8cae:  .byte   $1f,$f9,$1f,$f8,$00
@8cb3:  .byte   $bd,$85,$00
@8cb6:  .byte   $bd,$7f,$00
@8cb9:  .byte   $1e,$9f,$1e,$af,$00
@8cbe:  .byte   $93,$8d,$00
@8cc1:  .byte   $77,$85,$00
@8cc4:  .byte   $1c,$00,$1d,$ed,$00
@8cc9:  .byte   $85,$8d,$00
@8ccc:  .byte   $1f,$2a,$1f,$78,$1f,$86,$1f,$a6,$d0,$00
@8cd6:  .byte   $1f,$70,$1f,$64,$1f,$6a,$d0,$00
@8cde:  .byte   $6b,$a7,$00
@8ce1:  .byte   $73,$9b,$00
@8ce4:  .byte   $1e,$da,$1c,$03,$00
@8ce9:  .byte   $1f,$20,$1f,$92,$1f,$b8,$d0,$00
@8cf1:  .byte   $b9,$3f,$00
@8cf4:  .byte   $1c,$04,$1e,$0d,$00
@8cf9:  .byte   $45,$33,$35,$ab,$00
@8cfe:  .byte   $1f,$76,$1f,$46,$d0,$00
@8d04:  .byte   $9b,$1d,$e6,$00
@8d08:  .byte   $37,$bf,$00
@8d0b:  .byte   $85,$6f,$ad,$00
@8d0f:  .byte   $3f,$d2,$00
@8d12:  .byte   $1e,$23,$1e,$01,$00

; ------------------------------------------------------------------------------
