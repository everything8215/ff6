
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: src/btlgfx/char_ai.asm                                               |
; |                                                                            |
; | description: character a.i. properties                                     |
; |                                                                            |
; | created: 11/11/2023                                                        |
; +----------------------------------------------------------------------------+

; [ data format (24 bytes each) ]

;   0: p------h flags
;        p: hide characters in current party (show a.i. characters only)
;        h: hide names/gauges for all characters in battle menu
;   1: battle bg (ignored if $ff)
;   2: valid monster targets (change with a.i. command $fb)
;   3: song ($ff for default battle song, ignored if continuing current song)
;   4-23: character slots (4 * 5 bytes each)
;           0: pecccccc ($ff for empty slot, i.e. use party character)
;                p: character is not in the party (see anim cmd $C7/$10)
;                   exclude from entry/victory animations, also hide name/gauge
;                e: enemy character (faces opposite direction, acts as enemy)
;                c: character properties
;           1: character graphics ($ff to use default for character properties)
;           2: monster a.i. script (add $0100)
;           3: x position (multiply by 2)
;           4: y position (multiply by 2)

; ------------------------------------------------------------------------------

.include "char_ai.inc"
.include "src/sound/song_script.inc"

; ------------------------------------------------------------------------------

; [ init character ai data ]

_c2bd43:
scene_init:
@bd43:  lda     #$ff
        sta     near w7e629d
        stz     near w7e2f47
        stz     near w7e6192                   ; characters not in the party (gets inverted later)
        longa
        clr_ax
        lda     #$ffff
@bd55:  sta     near w7e6246,x
        inx2
        cpx     #$0010
        bne     @bd55
        shorta0
        lda     near w7e2f49
        bpl     @bd95                   ; branch if character ai is disabled
        lda     near w7e2f4a                   ; character ai index
        sta     $22
        lda     #$18
        sta     $24
        jsl     Mult8_far
        ldx     $26
        lda     f:CharAI+1,x            ; special battle background
        cmp     #$ff
        beq     @bd84                   ; branch if no special background
        sta     near w7eecb8                   ; set battle background
        stz     near w7eecb8+1
@bd84:  lda     f:CharAI+2,x
        sta     near w7e2f46                   ; characters that can be targetted
        lda     f:CharAI+3,x
        sta     near w7e629d                   ; special song index
        jsr     _c2be6e
@bd95:  lda     near w7e2f4b
        bmi     @bdd0
        inc     near wSfxDisabled                   ; disable sound effects
        lda     #$10                    ; spc command $10 (load song)
        sta     $1300
        lda     #$ff                    ; full volume
        sta     $1302
        lda     near w7e629d
        cmp     #$ff
        bne     @bdbf                   ; branch if a special song from character ai data
        lda     near w7e2f4b
        and     #$38
        lsr3
        tax
        lda     f:BattleSongTbl,x
        cmp     #$ff
        beq     @bdcd                   ; branch if continuing same song
@bdbf:  sta     $1301                   ; song number
        lda     $11e4
        and     #$08
        bne     @bdcd                   ; branch if continuing current music
        jsl     ExecSound_ext
@bdcd:  stz     near wSfxDisabled                   ; enable sound effects
@bdd0:  clr_axy
        longa
@bdd5:  stz     near wCharGfxDataBuf::IsCharAI,x
        lda     near w7e6246,y
        cmp     #$ffff
        beq     @bde3
        inc     near wCharGfxDataBuf::IsCharAI,x
@bde3:  tya
        clc
        adc     #$0004
        tay
        txa
        clc
        adc     #$0020
        tax
        cpx     #$0080
        bne     @bdd5
        shorta0
        lda     #1
        sta     $10
        clr_ax
@bdfd:  lda     near wCharGfxDataBuf::CharID,x
        cmp     #CHAR_PROP::KEFKA_7
        bne     @be0c
        lda     near w7e6192                   ; exclude Kefka 7 from the party
        ora     $10
        sta     near w7e6192
@be0c:  asl     $10
        txa
        clc
        adc     #$20
        tax
        cmp     #$80
        bne     @bdfd
        lda     near w7e6192                   ; invert characters in the party
        not_a
        sta     near w7e6192
        inc     near wSfxDisabled                   ; disable sound effects
        lda     #$82
        sta     $1300
        clr_a
        sta     $1301
        dec
        sta     $1302
        lda     $11e4
        and     #$08
        bne     @be3a
        jsl     ExecSound_ext
@be3a:  stz     near wSfxDisabled                   ; enable sound effects
        lda     f:$001d4f
        and     #$40
        sta     near w7e629c
        lda     f:$001d54
        bpl     @be65
        lda     f:$001d4f
        sta     $10
        clr_ax
@be54:  lda     $10
        and     #$01
        sta     near w7e6198,x
        lsr     $10
        inx
        cpx     #4
        bne     @be54
        bra     @be6d
@be65:  clr_ax
        stx     near w7e6198
        stx     near w7e619a
@be6d:  rtl

; ------------------------------------------------------------------------------

; [  ]

_c2be6e:
set_play_xy:
@be6e:  phx
        lda     f:CharAI,x
        bmi     @bee9                   ; branch if non-ai characters not shown
        lda     #4
        sta     $10
@be79:  lda     f:CharAI+4,x
        cmp     #$ff
        beq     @bee7
        and     #$3f
        sta     $12
        stz     $14
        clr_ay
        lda     #$01                    ; character bit mask
        sta     $18
@be8d:  lda     near wCharGfxDataBuf::CharID,y
        cmp     $12
        bne     @bed1
        lda     f:CharAI+4,x
        and     #CHAR_AI_FLAG_ENEMY_CHAR
        beq     @bea1
        lda     $18
        sta     near w7e2f47                   ; characters acting as enemies
@bea1:  lda     f:CharAI+4,x
        bpl     @beaf
        lda     $18
        ora     near w7e6192                   ; exclude from the party
        sta     near w7e6192
@beaf:  lda     $14
        asl2
        tay
        lda     f:CharAI+7,x            ; x position
        cmp     #$ff
        beq     @bede
        longa
        asl
        sta     near w7e6246,y
        lda     f:CharAI+8,x            ; y position
        and     #$00ff
        asl
        sta     near w7e6248,y
        shorta
        bra     @bede
@bed1:  asl     $18
        inc     $14
        tya
        clc
        adc     #$20
        tay
        cmp     #$80
        bne     @be8d
@bede:  inx5
        dec     $10
        bne     @be79
@bee7:  plx
        rts

; non-ai characters are not shown (hide party)
@bee9:  clr_ay
        lda     #$01                    ; character bit mask
        sta     $10
@beef:  lda     f:CharAI+4,x
        cmp     #$ff
        beq     @bf0e                   ; branch if ai character slot is disabled
        and     #$40
        beq     @bf00                   ; branch if not acting as enemy
        lda     $10
        sta     near w7e2f47                   ; set character acting as enemy
@bf00:  lda     f:CharAI+4,x
        bpl     @bf0e                   ; branch if character is not shown
        lda     $10
        ora     near w7e6192                   ; exclude from the party
        sta     near w7e6192
@bf0e:  lda     f:CharAI+7,x            ; x position
        cmp     #$ff
        beq     @bf29
        longa
        asl
        sta     near w7e6246,y
        lda     f:CharAI+8,x            ; y position
        and     #$00ff
        asl
        sta     near w7e6248,y
        shorta
@bf29:  asl     $10                     ; next character
        iny4
        inx5
        cpy     #$0010
        bne     @beef
        plx
        rts

; ------------------------------------------------------------------------------

; battle songs
BattleSongTbl:
        .byte   SONG::BATTLE_THEME
        .byte   SONG::DECISIVE_BATTLE
        .byte   SONG::FIERCE_BATTLE
        .byte   SONG::RETURNERS
        .byte   SONG::SAVE_THEM
        .byte   SONG::DANCING_MAD_1_2_3
        .byte   SONG::NONE
        .byte   SONG::NONE

; ------------------------------------------------------------------------------

.pushseg
.segment "char_ai"

; d0/fd00
CharAI:

; ------------------------------------------------------------------------------

; $00: none

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte $ff
.byte 0,0
.byte 255,255

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $01: shadow_colosseum

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::SHADOW

; slot 0
.byte CHAR_PROP::SHADOW|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::SHADOW,<MONSTER::SHADOW_COLOSSEUM
.byte 40,48

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $02: terra_flashback

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::BURNING_BUILDING
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1|CHAR_AI_FLAG_NOT_IN_PARTY
.byte CHAR_GFX::KEFKA,0
.byte 255,255

; slot 1
.byte CHAR_PROP::TERRA
.byte $ff,<MONSTER::TERRA_FLASHBACK
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $03: vargas

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~BIT_0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::SABIN|CHAR_AI_FLAG_NOT_IN_PARTY
.byte $ff,$ff
.byte 60,108

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $04: kefka_imp_camp_1

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,<MONSTER::KEFKA_IMP_CAMP
.byte 32,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $05: cyan_imp_camp_1

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::CYAN
.byte CHAR_GFX::CYAN,<MONSTER::CYAN_IMP_CAMP
.byte 80,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $06: cyan_imp_camp_2

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::CYAN
.byte CHAR_GFX::CYAN,<MONSTER::CYAN_IMP_CAMP
.byte 80,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $07: piranha

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $08: unused_08

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_2|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,<MONSTER::KEFKA_IMP_CAMP
.byte 32,44

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $09: unused_09

.byte CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1
.byte CHAR_GFX::KEFKA,$ff
.byte 100,100

; slot 1
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 32,60

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0a: gau_veldt

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::GAU|CHAR_AI_FLAG_NOT_IN_PARTY|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::GAU,<MONSTER::GAU_VELDT
.byte 48,52

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0b: unused_0b

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 60,100

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::LOCKE,$ff
.byte 60,100

; slot 2
.byte CHAR_PROP::CELES
.byte CHAR_GFX::CELES,$ff
.byte 60,100

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0c: sealed_gate_1

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_2|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,<MONSTER::KEFKA_ESPER_GATE
.byte 100,44

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0d: sealed_gate_2

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_2|CHAR_AI_FLAG_ENEMY_CHAR
.byte CHAR_GFX::KEFKA,$ff
.byte 100,48

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0e: blackjack_espers

.byte CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::METAMORPHOSIS

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 60,100

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::LOCKE,$ff
.byte 60,100

; slot 2
.byte CHAR_PROP::SETZER
.byte CHAR_GFX::SETZER,$ff
.byte 60,100

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $0f: ultros_relm

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::RELM|CHAR_AI_FLAG_NOT_IN_PARTY
.byte CHAR_GFX::RELM,$ff
.byte 255,255

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $10: espers go to thamasa

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::TERRA,$ff
.byte 100,100

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $11: blitz_tutorial

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::KEFKA,$ff
.byte 64,88

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::BROWN_SOLDIER,$ff
.byte 92,80

; slot 2
.byte CHAR_PROP::CYAN
.byte CHAR_GFX::BROWN_SOLDIER,$ff
.byte 40,84

; slot 3
.byte CHAR_PROP::SHADOW
.byte CHAR_GFX::BROWN_SOLDIER,$ff
.byte 100,100

; ------------------------------------------------------------------------------

; $12: kefka_esper

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_3
.byte CHAR_GFX::KEFKA,$ff
.byte 92,44

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $13: kefka_gestahl

.byte CHAR_AI_FLAG_HIDE_NAMES|CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA
.byte CHAR_GFX::KEFKA,$ff
.byte 88,84

; slot 1
.byte CHAR_PROP::LOCKE
.byte CHAR_GFX::GESTAHL,$ff
.byte 48,84

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $14: kefka_leo

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::TERRA|CHAR_AI_FLAG_NOT_IN_PARTY
.byte CHAR_GFX::KEFKA,$ff
.byte 60,100

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $15: unused_15

.byte CHAR_AI_FLAG_HIDE_PARTY
.byte BATTLE_BG::DEFAULT
.byte <~0
.byte SONG::NONE

; slot 0
.byte CHAR_PROP::KEFKA_1
.byte CHAR_GFX::KEFKA,$ff
.byte 255,255

; slot 1
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 2
.byte $ff
.byte $ff,$ff
.byte 255,255

; slot 3
.byte $ff
.byte $ff,$ff
.byte 255,255

; ------------------------------------------------------------------------------

; $16: unused_16

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~BIT_0
.byte SONG::NONE

; slot 0
.byte $ff
.byte 0,0
.byte 255,255

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

; $17: unused_17

.byte CHAR_AI_FLAG_NONE
.byte BATTLE_BG::DEFAULT
.byte <~BIT_0
.byte SONG::NONE

; slot 0
.byte $ff
.byte 0,0
.byte 255,255

; slot 1
.byte $ff
.byte 0,0
.byte 255,255

; slot 2
.byte $ff
.byte 0,0
.byte 255,255

; slot 3
.byte $ff
.byte 0,0
.byte 255,255

; ------------------------------------------------------------------------------

.popseg
