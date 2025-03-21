
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

inc_lang "text/char_name_%s.inc"
inc_lang "text/item_name_%s.inc"
inc_lang "text/magic_name_%s.inc"
inc_lang "text/map_title_%s.inc"
.include "text/mte_tbl_jp.inc"

.import Dlg1, DlgBankInc, DlgPtrs, DTETbl, LargeFontGfx, FontWidth

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ init dialog text ]

.proc InitDlgText
        stz     $0568                   ; dialog flags
        stz     $c5                     ; line number
        stz     $cc                     ; dialog window region
        stz     $d3                     ; keypress state
        stz     $c9                     ; dialog pointer
        stz     $ca
        lda     #^Dlg1
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
        lda     #4                      ; current x position on dialog window
        sta     $bf
        stz     $c0                     ; width of current word
        lda     #$e0                    ; max x position on dialog window
        sta     $c8
        ldx     #$9003                  ; clear current character graphics buffer
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        ldx     #$0080
:       stz     hWMDATA
        dex
        bne     :-
        jsr     ClearTextGfxBuf
        jsr     ClearDlgTextVRAM
        rts
.endproc  ; InitDlgText

; ------------------------------------------------------------------------------

; [ update pointer to current dialog item ]

.proc GetDlgPtr
        lda     #^Dlg1                  ; bank byte
        sta     $cb
        longa
        lda     $d0                     ; dialog index
        asl
        tax
        lda     f:DlgPtrs,x             ; pointer to dialog item
        sta     $c9
        lda     $d0                     ; dialog index
        cmp     f:DlgBankInc            ; first dialog item in next bank
        bcc     :+                      ; branch if less
        shorta0
        inc     $cb                     ; increment bank byte
:       shorta0
        lda     #1                      ; enable dialog display
        sta     $0568
        rts
.endproc  ; GetDlgPtr

; ------------------------------------------------------------------------------

; [ display map name ]

.proc ShowMapTitle
        stz     $0567                   ; clear map name dialog counter
        lda     $1eb9
        and     #$40                    ; return if party switching is enabled
        bne     :+
        lda     $0745                   ; return if map name dialog is disabled
        bne     :++
:       stz     $0745
        rts

:       lda     #$64                    ; set counter to 100 frames
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

.if ::LANG_EN
        stz     $c0                     ; clear width of current word
        ldy     $00
Loop:   lda     [$c9],y                 ; get next character
        beq     Done                    ; branch if end of string
        tax
        lda     f:FontWidth,x           ; get character width
        clc
        adc     $c0                     ; add to width of current word
        sta     $c0
        iny                             ; next character
        bra     Loop
Done:   lda     #$e0                    ; $bf = ($e0 - width) / 2
        sec                             ; text centered in dialog window
        sbc     $c0
.else
        ldy     $00
        tyx
Loop:   lda     [$c9],y
        beq     Done
        cmp     #$20
        bcs     :+
        iny
:       inx
        iny
        bra     Loop
Done:   txa
        sta     hWRMPYA
        lda     #12
        sta     hWRMPYB
        lda     #$e0
        sec
        sbc     hRDMPYL
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
:       jsr     UpdateDlgTextOneLine
        jsr     TfrMapTitleGfx
        lda     $0568                   ; branch until complete
        bpl     :-
        stz     $d3                     ; keypress state
        stz     $cc                     ; text region (will not erase text)
        jsr     OpenMapTitleWindow
        rts
.endproc  ; ShowMapTitle

; ------------------------------------------------------------------------------

.if LANG_EN

; [ calculate width of current word ]

; $c0 = calculated width

.proc CalcTextWidth
        lda     $cf                     ; save text buffer position
        pha
        lda     $cb                     ; save pointer to current dialog character
        pha
        ldx     $c9
        phx
        stz     $c0                     ; width = 0
Loop:   ldy     $00
        lda     [$c9],y                 ; load first letter
        bpl     NotDTE                  ; branch if not dte
        and     #$7f
        asl
        tax
        lda     $cf
        cmp     #$80
        beq     :+
        lda     #$80
        sta     $cf
        bra     SkipFirstLetter
:       lda     f:DTETbl,x              ; first dte letter
        cmp     #$7f
        beq     Done
        phx
        tax
        lda     f:FontWidth,x           ; width += letter width
        clc
        adc     $c0
        sta     $c0
        plx

SkipFirstLetter:
        lda     f:DTETbl+1,x            ; second dte letter
        cmp     #$7f
        beq     Done
        tax
        lda     f:FontWidth,x           ; width += letter width
        clc
        adc     $c0
        sta     $c0
        bra     :+

NotDTE: ldy     $00
        lda     [$c9],y
        cmp     #$20
        bcc     EscapeCode              ; branch if an escape code
        cmp     #$7f
        beq     Done                    ; return if a space
        tax
        lda     f:FontWidth,x           ; width += character width
        clc
        adc     $c0
        sta     $c0
:       inc     $c9                     ; next character
        bne     Loop
        inc     $ca
        bne     Loop
        inc     $cb
        bra     Loop

; restore dialog pointer and text buffer position and return
Done:   plx
        stx     $c9
        pla
        sta     $cb
        pla
        sta     $cf
        rts

EscapeCode:
        cmp     #$1a        ; branch if item name
        beq     CalcItemWidth
        cmp     #$02        ; return if end of message or new line
        bcc     Done
        cmp     #$10        ; return if not a character name
        bcs     Done

; character name
        dec                 ; decrement to get character index
        dec
        sta     hWRMPYA
        lda     #$25        ; get pointer to character data
        sta     hWRMPYB
        lda     $cf         ; return if text buffer is not empty
        bpl     Done
        lda     #CharName::ITEM_SIZE
        sta     $1a
        ldy     hRDMPYL
Loop2:  lda     $1602,y     ; get letter
        cmp     #$ff
        beq     Done       ; return if no letter
        sec
        sbc     #$60        ; convert to dialog text
        tax
        lda     f:FontWidth,x   ; width += letter width
        clc
        adc     $c0
        sta     $c0
        iny                 ; next letter
        dec     $1a         ; return after 6 letters
        bne     Loop2
        bra     Done

CalcItemWidth:
        lda     $0583                   ; item index
        sta     hWRMPYA
        lda     #ItemName::ITEM_SIZE
        sta     hWRMPYB
        lda     $cf                     ; return if text buffer is not empty
        bpl     Done
        lda     #ItemName::ITEM_SIZE-1
        sta     $1a
        ldx     hRDMPYL
Loop3:  txy
        lda     f:ItemName+1,x          ; item name
        cmp     #$ff                    ; return if no letter
        beq     Done
        sec
        sbc     #$60                    ; convert to dialog text
        tax
        lda     f:FontWidth,x           ; width += letter width
        clc
        adc     $c0
        sta     $c0
        tyx
        inx                             ; next letter
        dec     $1a                     ; return after 12 letters
        bne     Loop3
        bra     Done
.endproc  ; CalcTextWidth

.endif  ; LANG_EN

; ------------------------------------------------------------------------------

; [ update dialog text ]

.proc UpdateDlgText
        longa
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
        beq     :+
        dec     $0567
        bne     :+
        jsr     CloseMapTitleWindow
:       lda     $0568                   ; dialog flags
        bne     :+                      ; return if there's no dialog text
        rts
:       ldx     $0569                   ; decrement counter for dialog pause
        beq     :+
        dex
        stx     $0569
        rts
:       ldx     $056b                   ; keypress counter
        beq     _81af
        longa
        txa
        and     #$7fff
        tax
        shorta0
        cpx     $00
        bne     _81a8
        stz     $056c
        stz     $d3                     ; keypress state
        stz     $056f
        bra     _81af
_81a8:  ldx     $056b
        dex
        stx     $056b
_81af:  lda     $d3                     ; branch if waiting for keypress
        jeq     _823b
        lda     $056f                   ; max multiple choice selection
        cmp     #2
        bcc     _821f                   ; branch if 1 or 0
        lda     $056e
        asl
        tax
        longa
        lda     $0570,x                 ; set current cursor position (for erasing the indicator)
        sta     $c3
        shorta0
        lda     $07
        and     #$0f                    ; branch if any direction button is down
        bne     _81d7
        stz     $056d                   ; multiple choice selection is not changing
        bra     _8209
_81d7:  lda     $056d                   ; branch if multiple choice selection is already changing
        bne     _821f
        lda     $07
        and     #>(JOY_UP | JOY_LEFT)
        beq     _81f2
        lda     $056e                   ; decrement multiple choice selection
        dec
        bmi     _8209                   ; branch if less than zero (no change)
        sta     $056e
        lda     #1                      ; multiple choice selection is changing
        sta     $056d
        bra     _8209
_81f2:  lda     $07
        and     #>(JOY_DOWN | JOY_RIGHT)
        beq     _8209
        lda     $056e                   ; increment multiple choice selection
        inc
        cmp     $056f                   ; branch if equal to max selection (no change)
        beq     _8209
        sta     $056e
        lda     #1                      ; multiple choice selection is changing
        sta     $056d
_8209:  jsr     DrawDlgCursor
        lda     $056e                   ; current selection
        asl
        tax
        longa
        lda     $0570,x                 ; position of multiple choice indicator
        sta     $0580                   ; set current
        shorta0
        inc     $0582                   ; enable update
_821f:  lda     $d3                     ; keypress state
        cmp     #$01
        beq     _822d                   ; branch if waiting for keypress
        lda     $06                     ; A button
        bmi     _8241                   ; decrement keypress and branch if not pressed
        dec     $d3
        bra     _8241
_822d:  lda     $06                     ; return if A button not pressed
        bpl     _8241
        dec     $d3                     ; decrement keypress state
        stz     $056f                   ; disable multiple choice
        stz     $056c                   ; disable keypress timer
        bra     _8241                   ; return

_823b:  lda     $cc                     ; decrement region to clear (getting ready for next page)
        beq     _8242
        dec     $cc
_8241:  rts
_8242:  lda     $0568                   ; dialog flags
        bpl     UpdateDlgTextOneLine
        sta     $ba
        stz     $0568
        rts

::UpdateDlgTextOneLine:

.if ::LANG_EN
        jsr     CalcTextWidth
        lda     $bf                     ; add width to current x position
        clc
        adc     $c0
        bcs     _825b                   ; branch if it overflowed
        cmp     $c8
        bcc     _825f                   ; branch if less than max width
_825b:  jsr     NewLine
        rts
_825f:  lda     $cf                     ; branch if text buffer is empty
        bmi     _8284
_8263:  lda     $cf
        tax
        lda     $7e9183,x               ; text buffer
        sta     $cd                     ; set next letter to display
        stz     $ce
        lda     $7e9184,x
        beq     _827a                   ; branch if next letter is terminator
        jsr     DrawDlgText
        inc     $cf                     ; increment buffer position and return
        rts
_827a:  lda     #$80                    ; empty dialog text buffer
        sta     $cf
        jsr     DrawDlgText
        jmp     _829d                   ; increment dialog pointer by 1
_8284:  ldy     $00
        lda     [$c9],y                 ; load current dialog letter
        sta     $bd
        iny
        lda     [$c9],y                 ; load next dialog letter
        sta     $be
        lda     $bd                     ; branch if current letter is dte
        bmi     _829a
        cmp     #$20                    ; branch if special letter
        bcc     _82b5
        jmp     _845a
_829a:  jmp     _8466

.else

_825f:  lda     $cf
        bmi     _81b3
_8263:  lda     $cf
        tax
        lda     $7e9183,x
        cmp     #$20
        bcs     _8195
        sec
        sbc     #$1b
        sta     $ce
        lda     $7e9184,x
        sta     $cd
        lda     $7e9185,x
        beq     _81a9
        jsr     DrawDlgText
        inc     $cf
        inc     $cf
        rts
_8195:  lda     $7e9183,x
        sta     $cd
        stz     $ce
        lda     $7e9184,x
        beq     _81a9
        jsr     DrawDlgText
        inc     $cf
        rts
_81a9:  lda     #$80
        sta     $cf
        jsr     DrawDlgText
        jmp     _829d
_81b3:  ldy     $00
        lda     [$c9],y
        sta     $bd
        iny
        lda     [$c9],y
        sta     $be
        lda     $bd
        cmp     #$ff
        beq     _81d3
        cmp     #$20
        bcc     _82b5
        cmp     #$d8
        bcc     _81d3
        cmp     #$f0
        bcs     _823f
        jmp     _83cd
_81d3:  jmp     _845a
.endif

; increment dialog pointer
_829d:  lda     #1                      ; increment by 1
        bra     _82a3
_82a1:  lda     #2                      ; increment by 2
_82a3:  clc
        adc     $c9
        sta     $c9
        lda     $ca
        adc     #0
        sta     $ca
        lda     $cb
        adc     #0
        sta     $cb
        rts

; special letter $00: end of message
_82b5:  cmp     #$00
        bne     _82c2
        jsr     NewPage
        lda     #$80
        sta     $0568
        rts

; special letter $01: new line
_82c2:  cmp     #$01
        bne     _82cc
        jsr     NewLine
        jmp     _829d                   ; increment dialog pointer by 1

; special letter $02-$0f: character name
_82cc:  cmp     #$10
        bcs     _8302
        dec2
        sta     hWRMPYA
        lda     #$25
        sta     hWRMPYB
        nop4
        ldy     hRDMPYL
        ldx     $00

.if ::LANG_EN
_82e3:  lda     $1602,y
        sec
        sbc     #$60
        sta     $7e9183,x
        cmp     #$9f
        beq     _82f8
        iny
        inx
        cpx     #CharName::ITEM_SIZE
        bne     _82e3
_82f8:  clr_a
        sta     $7e9183,x
        stz     $cf
        jmp     _8263

.else

_821c:  lda     #$1f
        sta     $7e9183,x
        lda     $1602,y
        sta     $7e9184,x
        cmp     #$ff
        beq     _8235
        iny
        inx2
        cpx     #12
        bne     _821c
_8235:  clr_a
        sta     $7e9183,x
        stz     $cf
        jmp     _8263

_823f:  sec
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
_8253:  lda     $1602,y
        sta     $7e9183,x
        cmp     #$ff
        beq     _8265
        iny
        inx
        cpx     #CharName::ITEM_SIZE
        bne     _8253
_8265:  clr_a
        sta     $7e9183,x
        stz     $cf
        jmp     _8263
.endif

; special letter $10: pause for 1 second
_8302:  cmp     #$10
        bne     _830f
        ldx     #60
        stx     $0569
        jmp     _829d                   ; increment dialog pointer by 1

; special letter $11: pause for x/4 seconds
_830f:  cmp     #$11
        bne     _832a
        lda     $be
        sta     hWRMPYA
        lda     #15
        sta     hWRMPYB
        nop4
        ldx     hRDMPYL
        stx     $0569
        jmp     _82a1                   ; increment dialog pointer by 2

; special letter $12: wait for keypress
_832a:  cmp     #$12
        bne     _8337
        ldx     #$8001                  ; waiting for keypress, timer is 1 frame only
        stx     $056b
        jmp     _829d                   ; increment dialog pointer by 1

; special letter $13: new page
_8337:  cmp     #$13
        bne     _8341
        jsr     NewPage
        jmp     _829d                   ; increment dialog pointer by 1

; special letter $14: tab (x spaces)
_8341:  cmp     #$14
        bne     _8362
        lda     $be                     ; number of spaces
        sta     $1e
        stz     $1f
        ldx     $00
.if ::LANG_EN
        lda     #$7f                    ; space
.else
        lda     #$ff
.endif
_834f:  sta     $7e9183,x
        inx
        cpx     $1e
        bne     _834f
        clr_a                             ; end of string
        sta     $7e9183,x
        stz     $cf
        jmp     _829d                   ; increment dialog pointer by 1

; special letter $15: multiple choice indicator
_8362:  cmp     #$15
        bne     _837f
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
        jmp     _845a                   ; process like a normal letter

; special letter $16: pause for x/4 seconds, then wait for keypress
_837f:  cmp     #$16
        bne     _83a4
        lda     $be
        sta     hWRMPYA
        lda     #15
        sta     hWRMPYB
        nop2
        longa
        lda     hRDMPYL
        ora     #$8000
        sta     $056b
        shorta0
        lda     #$01                    ; waiting for keypress
        sta     $d3
        jmp     _82a1

; special letter $19: gold quantity
_83a4:  cmp     #$19
        bne     _83d3
        stz     $1a
        ldx     $00
        txy
_83ad:  lda     $1a
        bne     _83b8
        lda     $0755,y
        beq     _83c3
        inc     $1a
_83b8:  lda     $0755,y
        clc
.if ::LANG_EN
        adc     #$54
.else
        adc     #$53
.endif
        sta     $7e9183,x
        inx
_83c3:  iny
        cpy     #7
        bne     _83ad
        clr_a
        sta     $7e9183,x
        stz     $cf
        jmp     _8263

; special letter $1a: item name
_83d3:  cmp     #$1a
        bne     _840f
        lda     $0583
        sta     hWRMPYA
        lda     #ItemName::ITEM_SIZE
        sta     hWRMPYB
        nop3
        ldx     hRDMPYL
        ldy     $00
        lda     #$7e
        pha
        plb
_83ee:  lda     f:ItemName+1,x          ; ignore symbol

.if ::LANG_EN
        sec
        sbc     #$60
        sta     $9183,y
        cmp     #$9f
.else
        sta     $9183,y
        cmp     #$ff
.endif
        beq     _8403
        inx
        iny
        cpy     #ItemName::ITEM_SIZE-1
        bne     _83ee
_8403:  clr_a
        sta     $9183,y
        clr_a
        pha
        plb
        stz     $cf
        jmp     _8263

; special letter $1b: spell name
_840f:  cmp     #$1b
        bne     _844b
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
_842a:  lda     f:MagicName+1,x
.if ::LANG_EN
        sec                             ; subtract $60 to convert to big font
        sbc     #$60
        sta     $9183,y                 ; store in buffer
        cmp     #$9f                    ; break if $ff was reached
.else
        sta     $9183,y
        cmp     #$ff
.endif
        beq     _843f
        inx
        iny
        cpy     #4                      ; copy up to 4 bytes (should be 7)
        bne     _842a
_843f:  clr_a
        sta     $9183,y                 ; store $00 in the last byte
        clr_a
        pha
        plb
        stz     $cf
        jmp     _8263

; special letter $1c-$1f: extra japanese characters (unused)
_844b:  sec
        sbc     #$1b
        sta     $ce
        lda     $be
        sta     $cd
        jsr     DrawDlgText
        jmp     _82a1                   ; increment dialog pointer by 2

; $20-$7f: normal letter
_845a:  lda     $bd
        sta     $cd
        stz     $ce
        jsr     DrawDlgText
        jmp     _829d                   ; increment dialog pointer by 1

; $80-$ff: dte
.if ::LANG_EN
_8466:  and     #$7f
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
        clr_a
        sta     $7e9185                 ; end of string
        stz     $cf                     ; set text position to 0
        jmp     _8263                   ; write both letters
.else
_83cd:  sec
        sbc     #$d8
        asl
        tax
        rep     #$20
        lda     f:MTETblPtrs,x
        sta     $2a
        clr_a
        sep     #$20
        lda     #^MTETbl
        sta     $2c
        ldx     $00
        txy
_83e4:  lda     [$2a],y
        beq     _83fc
        cmp     #$20
        bcs     _83f4
        sta     $7e9183,x
        iny
        inx
        lda     [$2a],y
_83f4:  sta     $7e9183,x
        iny
        inx
        bra     _83e4
_83fc:  sta     $7e9183,x
        stz     $cf
        jmp     _8263
.endif
.endproc  ; UpdateDlgText

; ------------------------------------------------------------------------------

.if LANG_EN

; [ load dialog font widths ]

.proc InitDlgVWF
        lda     #$7e                    ; set wram address
        sta     hWMADDH
        ldx     #$9e00
        stx     hWMADDL
        ldx     $00
:       lda     f:FontWidth,x           ; copy widths for letters $00-$7f
        sta     hWMDATA
        inx
        cpx     #$0080
        bne     :-
        ldx     #.loword(DTETbl)        ; set a pointer to the dte table
        stx     $2a
        lda     #^DTETbl
        sta     $2c
        ldx     $00
        txy
:       stz     $1a
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
        bne     :-
        rts
.endproc  ; InitDlgVWF
.endif

; ------------------------------------------------------------------------------

; [ update dialog text graphics ]

.proc DrawDlgText
        ldx     $cd                     ; letter number
        lda     f:FontWidth,x           ; letter width
        clc
        adc     $bf                     ; add to current x position
        cmp     $c8
        bcc     :+                      ; branch if less than max position
        jsr     NewLine
        rts
:       jsr     LoadLetterGfx
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
        beq     :+                      ; branch if it hasn't reached the next tile
        jsr     ShiftPrevLetter
        longa_clc
        lda     $c1                     ; increment tile vram pointer
        adc     #$0020
        sta     $c1
        shorta0
:       ldx     $cd                     ; letter index
        lda     $bf                     ; x position
        clc
        adc     f:FontWidth,x           ; add letter width
        sta     $bf                     ; set new x position
        rts
.endproc  ; DrawDlgText

; ------------------------------------------------------------------------------

; [ new line ]

.proc NewLine
        lda     #$ff                    ; new line ($00ff)
        sta     $cd
        stz     $ce
        jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        lda     #4                      ; set x position back to the left
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
        bne     :+
        lda     #$09                    ; text fully displayed
        sta     $cc
        lda     #$02                    ; waiting for key release
        sta     $d3
:       rts
.endproc  ; NewLine

; ------------------------------------------------------------------------------

; [ new page ]

.proc NewPage
        lda     #$ff                    ; new line ($00ff)
        sta     $cd
        stz     $ce
        jsr     LoadLetterGfx
        jsr     DrawLetter
        jsr     CopyDlgTextToBuf
        lda     #4                      ; set x position back to the left
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
.endproc  ; NewPage

; ------------------------------------------------------------------------------

; [ clear all dialog text graphics in vram ]

.proc ClearDlgTextVRAM
        stz     hMDMAEN
        ldx     #$3800
        stx     hVMADDL
        lda     #$80
        sta     hVMAINC
        lda     #$09
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$0000
        stx     hDMA0::ADDR
        lda     #$00
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$1000                  ; clear $3800-$3fff in vram
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        rts
.endproc  ; ClearDlgTextVRAM

; ------------------------------------------------------------------------------

; [ clear dialog text graphics region in vram ]

.proc ClearDlgTextRegion
        lda     $cc                     ; current dialog text region to clear
        beq     Done
        cmp     #$09                    ; return if none
        beq     Done
        dec
        asl
        tax
        longa
        lda     f:DlgTextRegionPtrs,x
        sta     hVMADDL                 ; set vram address
        shorta0
        stz     hMDMAEN                 ; disable dma
        lda     #$80
        sta     hVMAINC                 ; clear $01c0 bytes (copy from $00)
        lda     #$09
        sta     hDMA0::CTRL             ; fixed address dma to $2118
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$0000
        stx     hDMA0::ADDR
        lda     #$00
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$01c0                  ; 7 tiles (32x32, 2bpp)
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
Done:   rts

; pointers to dialog text regions in vram
DlgTextRegionPtrs:
        .word   $3ee0,$3e00,$3ce0,$3c00,$3ae0,$3a00,$38e0,$3800
.endproc  ; ClearDlgTextRegion

; ------------------------------------------------------------------------------

; [ copy dialog text graphics to vram ]

.proc TfrDlgTextGfx
        lda     $c5                     ; return if there's no tile to be copied
        beq     Done
        stz     $c5

::TfrMapTitleGfx:
        stz     hMDMAEN
        lda     #$80                    ; vram control register
        sta     hVMAINC
        longa_clc
        lda     $c3                     ; vram destination
        adc     #$3800
        sta     hVMADDL
        shorta0
        lda     #$41                    ; dma control register
        sta     hDMA0::CTRL
        lda     #<hVMDATAL              ; dma destination register
        sta     hDMA0::HREG
        ldx     #$9083                  ; dma source address
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0040                  ; dma size (four 2bpp tiles)
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
Done:   rts
.endproc  ; TfrDlgTextGfx

; ------------------------------------------------------------------------------

; [ copy dialog text graphics to vram buffer ]

; copies one 16x16 tile per frame

.proc CopyDlgTextToBuf
        lda     #$7e
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
        clr_a
        pha
        plb
        rts
.endproc  ; CopyDlgTextToBuf

; ------------------------------------------------------------------------------

; [ copy multiple choice indicator graphics to vram buffer ]

.proc DrawDlgCursor
        ldx     #$9083
        stx     hWMADDL
        lda     #$7e
        sta     hWMADDH
        .repeat 8
        stz     hWMDATA
        .endrep
        ldx     $00
        txy
:       lda     f:DlgCursorGfx,x
        sta     hWMDATA
        lsr
        sta     hWMDATA
        inx
        cpx     #12
        bne     :-
        .repeat 32
        stz     hWMDATA
        .endrep
        rts

; multiple choice indicator graphics
DlgCursorGfx:
        .byte   %00100000
        .byte   %00110000
        .byte   %00111000
        .byte   %00111100
        .byte   %00111110
        .byte   %00111111
        .byte   %00111110
        .byte   %00111100
        .byte   %00111000
        .byte   %00110000
        .byte   %00100000
        .byte   %00000000
.endproc  ; DrawDlgCursor

; ------------------------------------------------------------------------------

; [ copy multiple choice indicator graphics to vram ]

.proc TfrDlgCursorGfx
        lda     $0582
        beq     Done
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
        sta     hDMA0::CTRL
        lda     #<hVMDATAL
        sta     hDMA0::HREG
        ldx     #$90a3
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0020
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
        stz     hMDMAEN
        longa_clc
        lda     $0580       ; multiple choice position
        adc     #$3800
        sta     hVMADDL
        shorta0
        ldx     #$9083
        stx     hDMA0::ADDR
        lda     #$7e
        sta     hDMA0::ADDR_B
        sta     hDMA0::HDMA_B
        ldx     #$0020
        stx     hDMA0::SIZE
        lda     #BIT_0
        sta     hMDMAEN
Done:   rts
.endproc  ; TfrDlgCursorGfx

; ------------------------------------------------------------------------------

; [ clear text graphics buffer ]

.proc ClearTextGfxBuf
        lda     #$7e
        sta     hWMADDH
        ldx     #$9103      ; clear $9103-$9182
        stx     hWMADDL
        ldx     #$0010
:       .repeat 8
        stz     hWMDATA
        .endrep
        dex
        bne     :-
        rts
.endproc  ; ClearTextGfxBuf

; ------------------------------------------------------------------------------

; [ copy letter graphics to text graphics buffer ]

.proc DrawLetter
        lda     #$7e
        pha
        plb
        lda     a:$00bf                 ; branch if on an even tile
        and     #$08
        jne     EvenTile

; odd tile
        ldx     $00
:       .repeat 2, i
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
        bne     :-
        clr_a
        pha
        plb
        rts

; even tile
EvenTile:
        ldx     $00
:       .repeat 2, i
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
        bne     :-
        clr_a
        pha
        plb
        rts
.endproc  ; DrawLetter

; ------------------------------------------------------------------------------

; [ copy next tile to current tile ]

.proc ShiftPrevLetter
        lda     #$7e
        pha
        plb
        ldx     $00
:       lda     $9123,x
        sta     $9103,x
        lda     $9163,x
        sta     $9143,x
        clr_a
        sta     $9123,x     ; clear next tile
        sta     $9163,x
        inx
        cpx     #$0020
        bne     :-
        clr_a
        pha
        plb
        rts
.endproc  ; ShiftPrevLetter

; ------------------------------------------------------------------------------

; [ load letter graphics ]

.proc LoadLetterGfx
        FontGfx := LargeFontGfx-32*22          ; skip 32 tiles (escape codes)

        lda     #$7e                    ; clear next letter graphics
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
        cmp     #4
        jeq     NoShift                 ; branch if 4 (halfway through tile)
        jcs     RightShift              ; branch if more than 4

; letter needs to shift left
LeftShift:
        eor     $02
        clc
        adc     #5
        sta     $1e                     ; +$1e = 4 - x
        stz     $1f
        longa
        .repeat 11, i
        ldy     $1e
        lda     f:FontGfx+i*2,x         ; letter graphics (first row of pixels)
:       asl                             ; shift left
        dey
        bne     :-
        sta     $9003+i*2               ; move to buffer
        lsr
        sta     $9045+i*2               ; shadow
        .endrep
        shorta0
        clr_a
        pha
        plb
        rts

; letter doesn't need to shift
NoShift:
        longa
        ldy     $00
:       lda     f:FontGfx,x            ; letter graphics
        sta     $9003,y
        lsr
        sta     $9045,y                 ; shadow
        inx2
        iny2
        cpy     #22
        bne     :-
        shorta0
        clr_a
        pha
        plb
        rts

; letter needs to shift right
RightShift:
        sec
        sbc     #4
        sta     $1e                     ; +$1e = x - 4
        stz     $1f
        longa
        .repeat 11, i
        ldy     $1e
        lda     f:FontGfx+i*2,x        ; letter graphics
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
        clr_a
        pha
        plb
        rts
.endproc  ; LoadLetterGfx

; ------------------------------------------------------------------------------

; pointers to MTE strings
MTETblPtrs:
        ptr_tbl MTETbl

; MTE strings carried over from ff6j (unused in English translation)
MTETbl:
        .incbin "src/text/mte_tbl_jp.dat"

; ------------------------------------------------------------------------------
