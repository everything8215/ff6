.import AttackGfxMode7
.import AttackTilesMode7

; ------------------------------------------------------------------------------

; [ execute battle animation init function ]

ExecAnimType:
@e8d0:  and     #$7f
        asl
        tax
        jsr     (near AnimTypeTbl,x)
        rtl

; ------------------------------------------------------------------------------

; battle animation init function jump table
AnimTypeTbl:
        ptr_tbl ANIM_TYPE

; ------------------------------------------------------------------------------

; [ battle animation init $0d:  ]

        array_label ANIM_TYPE, $0d
@e9d6:  rts

; ------------------------------------------------------------------------------

; [ battle animation init $7e: umaro's throw ]

        array_label ANIM_TYPE, $7e
@e9d7:  inc     near w7e60ac       ; pause bg1 animation threads
        clr_axy
@e9dd:  lda     near wCharGfxDataBuf::CharID,x
        cmp     #CHAR::UMARO
        beq     @e9f0
        iny
        txa
        clc
        adc     #$20
        tax
        cpx     #$0080
        bne     @e9dd
        rts
@e9f0:  sty     $10
        tya
        asl
        tay
        longa
        lda     near w7e8033,y
        sec
        sbc     #$0008
        sta     $14
        lda     near w7e803b,y
        sec
        sbc     #$0008
        sta     $16
        shorta0
        clr_ax
@ea0e:  lda     near wAnimThread::AttackerIndex,x
        sta     near wAnimThread::TargetIndex,x
        lda     $10
        sta     near wAnimThread::AttackerIndex,x
        longa
        lda     near wAnimThread::AttackerPosX,x
        sta     near wAnimThread::TargetPosX,x
        lda     near wAnimThread::AttackerPosY,x
        sta     near wAnimThread::TargetPosY,x
        lda     $14
        sta     near wAnimThread::AttackerPosX,x
        lda     $16
        sta     near wAnimThread::AttackerPosY,x
        txa
        clc
        adc     #$0080
        tax
        shorta0
        cpx     #BG1_THREAD_OFFSET
        bne     @ea0e
        inc     near w7ee9ee
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $7d: tonic, potion, tincture, ether, elixir, megalixir, antidote, soft ]

        array_label ANIM_TYPE, $7d
@ea43:  lda     #$05
        sta     $26
        lda     #$02
        jsr     CopyThread
        lda     #$03
        jsr     SetNumThreads
        jmp     _c2f9eb

; ------------------------------------------------------------------------------

; [ wait for scanline 160 ]

WaitLine160_near:
@ea54:  lda     f:hSTAT78
        lda     f:hSLHV     ; latch horizontal/vertical counter
        lda     f:hOPVCT     ; vertical scanline counter
        cmp     #$a0
        bcc     @ea54       ; branch if less than 160
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $7c: use high priority bg3 ]

        array_label ANIM_TYPE, $7c
@ea65:  jsr     array_item ANIM_TYPE, $1d
        lda     near w7e896f
        ora     #$08
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $7b:  ]

        array_label ANIM_TYPE, $7b
@ea71:  jsr     WaitLine160_near
        lda     near w7e898d                 ; disable bg1 in main screen
        and     #$fe
        sta     near w7e898d
        jsr     array_item ANIM_TYPE, $1d
        lda     near w7e896f                 ; use high priority bg3
        ora     #$08
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $7a: transforming into magicite ]

        array_label ANIM_TYPE, $7a
@ea88:  jsr     array_item ANIM_TYPE, $2a
        lda     #$04
        sta     $26
        lda     #$07
        jsr     CopyThread
        lda     #$08
        jsr     SetNumThreads
        inc     near w7e60ad       ; pause bg3 animation threads
        rts

; ------------------------------------------------------------------------------

; esper graphics (shiva, kirin, bismark, carbunkl, terrato)
EventSpriteGenjuTbl:
        .word   GENJU_GFX::SHIVA
        .word   GENJU_GFX::KIRIN
        .word   GENJU_GFX::BISMARK
        .word   GENJU_GFX::CARBUNKL
        .word   GENJU_GFX::TERRATO

; ------------------------------------------------------------------------------

; [ battle animation init $79: event animation $08-$0c ]

; for event animations with espers, this loads esper graphics to bg1 rather
; than the sprite layer. the default sound effect index is used to determine
; which esper to load (see table at c2/ea9d)

        array_label ANIM_TYPE, $79
@eaa7:  lda     near w7ee9e7       ; default sound effect
        asl
        tax
        longa
        lda     f:EventSpriteGenjuTbl,x
        tax
        shorta0
        jsl     LoadSummonGfxBG1_far
        jmp     LoadSummonPalBG1

; ------------------------------------------------------------------------------

; [ battle animation init $78: echo screen, smoke bomb ]

        array_label ANIM_TYPE, $78
@eabd:  lda     #$03
        sta     $26
        lda     #$03
        jsr     CopyThread
        lda     #$04
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $77: possess ]

        array_label ANIM_TYPE, $77
@eacb:  stz     near wHideBG1MonsterSprites
        jsl     ResetSpritePriority_far
        jsl     WaitFrame_far
        jsl     ClearBG3Tiles_far
        jsl     GetAttackerNum_far
        pha
        lda     near w7e898d                 ; disable bg1 in main screen
        pha
        and     #$fe
        sta     near w7e898d
        lda     near w7e896f                 ; 8x8 bg1 and bg3 tiles, low priority bg3
        and     #$e7
        ora     #$50
        sta     near w7e896f
        jsl     ClearBG1Tiles_far
        pla
        sta     near w7e898d
        pla
        and     #$03
        asl5
        tax
        clr_ay
@eb05:  lda     near w7e7e00::_12,x          ; copy ghost palette to bg1 anim palette
        sta     near w7e7e00::_3,y
        iny
        inx
        cpy     #$0020
        bne     @eb05
        lda     near w7e627d                 ; clear bg1 target flag
        and     #$7f
        sta     near w7e627d
        jmp     _c2fa0f                 ; add bg1, affect bg3

; ------------------------------------------------------------------------------

; [ battle animation init $76: wavecannon ]

        array_label ANIM_TYPE, $76
@eb1d:  jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jmp     _c2fa1b

; ------------------------------------------------------------------------------

; [ battle animation init $72: hyperdrive ]

        array_label ANIM_TYPE, $72
@eb2c:  jsr     array_item ANIM_TYPE, $22
        stz     near w7e60ac       ; unpause bg1 animation threads
        jmp     array_item ANIM_TYPE, $32

; ------------------------------------------------------------------------------

; [ battle animation init $75: h-bomb ]

        array_label ANIM_TYPE, $75
@eb35:  jsr     InitMode7
        ldx     #near w7ebe3f
        ldy     #$0800
        jsr     LoadMode7AnimGfx
        lda     #$03
        sta     $26
        lda     #$02
        jsr     CopyThread
        lda     #$03
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $74: purifier ]

        array_label ANIM_TYPE, $74
@eb4f:  jsr     InitMode7
        ldx     #GENJU_GFX::CRUSADER_1
        phx
        jsl     _c1240a
        jsr     LoadSummonPalBG1
        jsl     ClearBGAnimFrames_far
        plx
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        ldx     #GENJU_GFX::CRUSADER_2
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f1ca
        jsr     InitCircle
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        lda     #$cc
        sta     f:hW34SEL
        lda     #$01
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $73: soul out ]

        array_label ANIM_TYPE, $73
@eb87:  jsr     array_item ANIM_TYPE, $27
        clr_a
        inc     near w7e60ac       ; pause bg1 animation threads
        jmp     _c2f011

; ------------------------------------------------------------------------------

; [ battle animation init $71: remedy ]

        array_label ANIM_TYPE, $71
@eb91:  jsr     _c2f9eb
        jmp     _c2eefe

; ------------------------------------------------------------------------------

; [ battle animation init $70: revivify, eyedrop ]

        array_label ANIM_TYPE, $70
@eb97:  jsr     array_item ANIM_TYPE, $22
        jsr     array_item ANIM_TYPE, $1d
        stz     near w7e60ac       ; unpause bg1 animation threads
        jsl     _c1aaa1
        lda     $12
        bmi     @ebbb
        and     #$03
        asl5
        tax
        lda     near wCharGfxDataBuf::ShownStatus1,x
        bpl     @ebbb
        stz     near wBG1Thread::ThreadIsActive
        stz     near wBG3Thread::ThreadIsActive
@ebbb:  rts

; ------------------------------------------------------------------------------

; [ battle animation init $6f: slow, x-potion, x-ether ]

        array_label ANIM_TYPE, $6f
@ebbc:  jsr     array_item ANIM_TYPE, $47
        jmp     array_item ANIM_TYPE, $1d

; ------------------------------------------------------------------------------

; [ battle animation init $6e: tigerbreak ]

        array_label ANIM_TYPE, $6e
@ebc2:  ldx     #GENJU_GFX::TIGERBREAK
        jsl     LoadSummonGfxSprite_far
        clr_ax
@ebcb:  lda     f:BattleCharPal,x   ; character sprite color palette 0
        sta     near w7e7e00::_11,x
        sta     near w7e7c00::_11,x
        inx
        cpx     #$0020
        bne     @ebcb
        jsr     _c2f98b
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $6d: fader ]

        array_label ANIM_TYPE, $6d
@ebe1:  ldx     #GENJU_GFX::PHANTOM
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jmp     array_item ANIM_TYPE, $03

; ------------------------------------------------------------------------------

; [ battle animation init $6c: tri-dazer ]

        array_label ANIM_TYPE, $6c
@ebee:  ldx     #GENJU_GFX::TRITOCH
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f9c7
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $6b: true edge ]

        array_label ANIM_TYPE, $6b
@ebfe:  jsr     InitMode7
        ldx     #GENJU_GFX::RAIDEN
        phx
        jsl     _c12400
        jsr     LoadSummonPalBG1
        jsl     ClearBGAnimFrames_far
        plx
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        inc     near w7e62b0
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $6a: metamorph ]

        array_label ANIM_TYPE, $6a
@ec1c:  ldx     #GENJU_GFX::RAGNAROK
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $69: earth wall ]

        array_label ANIM_TYPE, $69
@ec29:  ldx     #GENJU_GFX::GOLEM
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jmp     _c2f590

; ------------------------------------------------------------------------------

; [ battle animation init $68: cat rain ]

        array_label ANIM_TYPE, $68
@ec36:  ldx     #GENJU_GFX::STRAY
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jmp     array_item ANIM_TYPE, $1c

; ------------------------------------------------------------------------------

; [ battle animation init $67: demi, quartr, reflect???, charm ]

        array_label ANIM_TYPE, $67
@ec43:  lda     #$08
        jsr     _c2f011
        jmp     _c2f9d3

; ------------------------------------------------------------------------------

; [ battle animation init $66: mirager ]

        array_label ANIM_TYPE, $66
@ec4b:  jsr     array_item ANIM_TYPE, $1d
        inc     near w7e60ac       ; pause bg1 animation threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $65: forcefield ]

        array_label ANIM_TYPE, $65
@ec52:  jsr     InitCircle
        lda     #CIRCLE_SHAPE::HORZ_OVAL
        sta     near wCircleShape
        lda     #$cc
        sta     f:hW34SEL
        rts

; ------------------------------------------------------------------------------

; [ load mode 7 animation graphics ]

; +X: graphics offset (+$7e0000, after decompressing graphics to $7eae3f)
; +Y: tile layout offset (+$d8daf2, after decompressing)

LoadMode7AnimGfx:
@ec61:  phx
        phy
        lda     #^AttackGfxMode7
        sta     $f5
        ldx     #near AttackGfxMode7
        stx     $f3
        lda     #^w7eae3f
        sta     $f8
        ldx     #near w7eae3f
        stx     $f6
        jsl     Decompress_ext
        ply
        plx
        phy
        stz     near w7ee9f0            ; init zoom/rotation counter used by overcast
        dec     near w7ee9f0
        lda     near w7e898d            ; disable bg1 and bg3 in main screen
        and     #$12
        sta     near w7e898d
        lda     #$3f
        sta     $14
        lda     #$7e
        jsl     _c2c027
        phx
        phy
        lda     #^AttackTilesMode7
        sta     $f5
        ldx     #near AttackTilesMode7
        stx     $f3
        lda     #^w7eae3f
        sta     $f8
        ldx     #near w7eae3f
        stx     $f6
        jsl     Decompress_ext
        ply
        plx
        plx
        phb
        lda     #$7f
        pha
        plb
        ldy     #$c400      ; bg1 tile data buffer
        sty     $10
        lda     #$20        ; 32 rows
        sta     $12
@ecbd:  clr_ay
@ecbf:  lda     w7eae3f,x   ; tile index
        sta     ($10),y
        inx
        iny2
        cpy     #$0040
        bne     @ecbf
        longa
        lda     $10         ; next row
        clc
        adc     #$0100
        sta     $10
        shorta0
        dec     $12
        bne     @ecbd
        plb
        ldx     #$2000
        stx     $10
        ldx     #$c400
        ldy     #$0000
        lda     #$7f
        jsl     WaitTfrVRAM_far
        inc     near w7ee9ee
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $63: s. cross ]

        array_label ANIM_TYPE, $63
@ecf6:  jsr     InitMode7
        ldx     #near w7eae3f + $0800
        ldy     #$0000
        jsr     LoadMode7AnimGfx
        longa
        clr_ax
@ed06:  clr_ay
@ed08:  lda     near wGenjuThread1::BLOCK_1,y
        sta     near wAnimThread::_0::BLOCK_1,x
        sta     near wAnimThread::_1::BLOCK_1,x
        lda     near wGenjuThread1::BLOCK_2,y
        sta     near wAnimThread::_0::BLOCK_2,x
        sta     near wAnimThread::_1::BLOCK_2,x
        lda     near wGenjuThread1::BLOCK_3,y
        sta     near wAnimThread::_0::BLOCK_3,x
        sta     near wAnimThread::_1::BLOCK_3,x
        inx2
        iny2
        cpy     #wAnimThread::BLOCK_SIZE
        bne     @ed08
        txa
        clc
        adc     #$0070
        tax
        cpx     #$0300
        bne     @ed06
        shorta0
        clr_ax
        stz     $10
@ed3e:  lda     $10
        clc
        adc     #$06
        sta     near wAnimThread::_0::AnimFrameCounter,x
        clc
        adc     #$06
        sta     near wAnimThread::_1::AnimFrameCounter,x
        sta     $10
        inc     near wAnimThread::ThreadIndex,x
        longa
        txa
        clc
        adc     #$0080
        tax
        shorta0
        cpx     #$0300
        bne     @ed3e
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $64: overcast ]

        array_label ANIM_TYPE, $64
@ed62:  jsr     InitMode7
        ldx     #near w7eae3f
        ldy     #$0400
        jmp     LoadMode7AnimGfx

; ------------------------------------------------------------------------------

; [ battle animation init $62: mind blast, seize, zinger ]

        array_label ANIM_TYPE, $62
@ed6e:  jsl     ResetSpritePriority_far
        stz     near wHideBG1MonsterSprites
        jsl     WaitFrame_far
        jsl     UpdateSpritePriority_far
        lda     near w7e896f
        and     #$ef
        sta     near w7e896f
        jsl     GetAttackerNum_far
        lda     $10
        jmp     _c2f322

; ------------------------------------------------------------------------------

; [ battle animation init $61: flare star ]

        array_label ANIM_TYPE, $61
@ed8e:  jsr     _c2f967
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #$cc
        sta     f:hW34SEL
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $60: goner ]

        array_label ANIM_TYPE, $60
@eda3:  jsr     InitCircle
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $5f: quasar ]

        array_label ANIM_TYPE, $5f
@edac:  clr_ax
@edae:  lda     #$08
        sta     $10
@edb2:  lda     $7fc411,x   ; bg1 animation tile data
        and     #$e3
        ora     #$10        ; set to palette 4
        sta     $7fc411,x
        lda     $7fc4a1,x
        and     #%11100011
        ora     #%00010000
        sta     $7fc4a1,x
        inx2                ; next tile
        dec     $10
        bne     @edb2
        longa
        txa                 ; next frame
        clc
        adc     #$0010
        tax
        shorta0
        cpx     #$00a0
        bne     @edae
        jsr     _c2f1ca
        lda     #$08
        sta     near wGenjuThread1::AnimFrameCounter
        lda     #$10
        sta     near wGenjuThread2::AnimFrameCounter
        lda     #$18
        sta     near wGenjuThread3::AnimFrameCounter
        jmp     _c2f9c7

; ------------------------------------------------------------------------------

; [ battle animation init $5e: chocobop, l.4 flare, gp rain, autocrossbow, throw 2 dice ]

        array_label ANIM_TYPE, $5e
@edf5:  jsr     _c2fa1b       ; add bg1, affect sprites and bg2
        lda     #$04        ; frame delay = $04
        jmp     _c2f6da       ; duplicate animation thread (jumps to life 3)

; ------------------------------------------------------------------------------

; [ battle animation init $5d: grandtrain, train ]

        array_label ANIM_TYPE, $5d
@edfd:  stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        jmp     _c2f9c7

; ------------------------------------------------------------------------------

; [ battle animation init $5c: tekmissile, cleansweep, launcher, missile ]

        array_label ANIM_TYPE, $5c
@ee0c:  jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        ldx     #$0120
        jsr     _c2f178
        jsr     _c2f1ca
        lda     #$08
        sta     near wGenjuThread1::AnimFrameCounter
        lda     #$10
        sta     near wGenjuThread2::AnimFrameCounter
        lda     #$18
        sta     near wGenjuThread3::AnimFrameCounter
        jmp     _c2fa1b

; ------------------------------------------------------------------------------

; [ battle animation init $59: run ]

        array_label ANIM_TYPE, $59
@ee30:  jsr     _c2f098
        lda     near w7e201f
        cmp     #BATTLE_TYPE::PINCER
        bne     @ee68
        lda     near w7e201e
        and     near w7e61ab
        and     near w7e2eac                   ; monsters on right side of screen
        beq     @ee48
        clr_a                           ; face left
        bra     @ee4a
@ee48:  lda     #1                      ; face right
@ee4a:  sta     near wAnimThread::_0::w7e6f87
        sta     near wAnimThread::_8::w7e6f87
        sta     near wAnimThread::_16::w7e6f87
        sta     near wAnimThread::_24::w7e6f87
        ror3
        and     #$40
        sta     near wCharGfxData::_0::Flip
        sta     near wCharGfxData::_1::Flip
        sta     near wCharGfxData::_2::Flip
        sta     near wCharGfxData::_3::Flip
        rts
@ee68:  lda     near w7e201f
        cmp     #BATTLE_TYPE::SIDE
        bne     @ee75
        inc     near wAnimThread::_16::w7e6f87
        inc     near wAnimThread::_24::w7e6f87
@ee75:  rts

; ------------------------------------------------------------------------------

; [ battle animation init $5b: delta hit, evil toot ]

        array_label ANIM_TYPE, $5b
@ee76:  jsr     _c2f1ca
        lda     #$03
        jsr     SetNumThreads
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jmp     _c2fa1b

; ------------------------------------------------------------------------------

; [ battle animation init $5a: slimer ]

        array_label ANIM_TYPE, $5a
@ee8d:  jsr     array_item ANIM_TYPE, $0e
        jsr     _c2fa1b
        lda     #CIRCLE_SHAPE::SLIMER_BLOB
        sta     near wCircleShape
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $58: clear ]

        array_label ANIM_TYPE, $58
@ee99:  jsr     array_item ANIM_TYPE, $1d
        lda     near w7e896f
        ora     #$08
        sta     near w7e896f
        jmp     _c2fa33

; ------------------------------------------------------------------------------

; [ battle animation init $57: sleep, 7-flush, fire ball, love token, meteo ]

        array_label ANIM_TYPE, $57
@eea7:  lda     #$10
        jmp     _c2f011

; ------------------------------------------------------------------------------

; [ battle animation init $56: bolt 3, blow fish, exploder, imp song, virite, net ]

; terra/tritoch lightning

        array_label ANIM_TYPE, $56
@eeac:  lda     #$07
        sta     $26
        lda     #$02
        jsr     CopyThread
        lda     #$03
        jsr     SetNumThreads
        jmp     _c2fa1b

; ------------------------------------------------------------------------------

; [ battle animation init $55: x-fer ]

        array_label ANIM_TYPE, $55
@eebd:  jsr     array_item ANIM_TYPE, $1d
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        lda     #CIRCLE_SHAPE::TOP_BEAM
        sta     near wCircleShape
        lda     near w7e896f
        ora     #$08
        sta     near w7e896f
        lda     #$02
        jsr     _c2eefe
        jmp     _c2fa33

; ------------------------------------------------------------------------------

; [ battle animation init $54: confuser, 50 gs, revenger ]

        array_label ANIM_TYPE, $54
@eede:  jsr     _c2f973
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        lda     near w7e896f
        and     #$ef
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $53: grav bomb ]

        array_label ANIM_TYPE, $53
@eef6:  jsr     _c2f9d3
        inc     near w7e60ac       ; pause bg1 animation threads
        lda     #$02

_c2eefe:
@eefe:  sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $52: bio blast ]

        array_label ANIM_TYPE, $52
@ef0a:  jsr     _c2fa1b
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #CIRCLE_SHAPE::BIO_BLAST
        sta     near wCircleShape
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $51: bolt edge, surge, diffuser, flash rain, engulf, slide ]

; vargas' blizzard fist

        array_label ANIM_TYPE, $51
@ef1c:  jmp     _c2f9c7

; ------------------------------------------------------------------------------

; [ battle animation init $50: snare ]

        array_label ANIM_TYPE, $50
@ef1f:  jsr     _c2f98b       ; add bg1, affect bg2
        clr_ax
@ef24:  lda     $7fc401,x   ; bg1 tile data buffer
        and     #$df        ; set tile priority to 0
        sta     $7fc401,x
        inx2                ; affect first 32 tiles (first two rows of frame)
        cpx     #$0040
        bne     @ef24
        jsl     ResetSpritePriority_far
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL     ; enable bg1 in window 2
        lda     #CIRCLE_SHAPE::HORZ_OVAL
        sta     near wCircleShape
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $4f: sneeze, green cherry ]

        array_label ANIM_TYPE, $4f
@ef48:  jmp     _c2f9eb

; ------------------------------------------------------------------------------

; [ battle animation init $4e: fire beam, bolt beam, ice beam, tek laser ]

        array_label ANIM_TYPE, $4e
@ef4b:  inc     a:z99       ; pause sprite animation threads
        inc     near w7e60ad       ; pause bg3 animation threads
        jsr     _c2f9c7
        lda     #$08
        jmp     _ef5b

; ------------------------------------------------------------------------------

; [ battle animation init $4d: cave in, snowball, lode stone ]

        array_label ANIM_TYPE, $4d
@ef59:  lda     #$10
_ef5b:  sta     $26
        lda     #$02
        jsr     CopyThread
        lda     #$03
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $4c: land slide ]

        array_label ANIM_TYPE, $4c
@ef67:  jsr     array_item ANIM_TYPE, $16
        lda     #$06
        sta     $26
        lda     #$07
        jsr     CopyThread
        lda     #$08
        jsr     SetNumThreads
        jmp     _c2fa27

; ------------------------------------------------------------------------------

; [ battle animation init $4b: specter ]

        array_label ANIM_TYPE, $4b
@ef7b:  jsr     array_item ANIM_TYPE, $4a
        jsl     GetAttackerNum_far
        clr_ax
        lda     $10
        asl2
        sta     $12
@ef8a:  lda     $7fc400,x
        cmp     #$ee
        beq     @efb1
        clc
        adc     $12
        sta     $7fc400,x
        sta     $7fc600,x
        lda     $7fc401,x
        ora     #$02
        sta     $7fc401,x
        lda     $7fc601,x
        ora     #$02
        sta     $7fc601,x
@efb1:  inx2
        cpx     #$0040
        bne     @ef8a
        lda     $10
        asl5
        tax
        clr_ay
@efc2:  lda     near w7e7e00::_12,x
        sta     near w7e7e00::_3,y
        inx
        iny
        cpy     #$0020
        bne     @efc2
        jmp     _c2f9d3

; ------------------------------------------------------------------------------

; [ battle animation init $4a: elf fire, fire wall ]

        array_label ANIM_TYPE, $4a
@efd2:  jsr     _c2f9eb
        lda     #$01
        sta     $26
        lda     #$07
        jsr     CopyThread
        lda     #$08
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $49: antlion, lifeshaver ]

        array_label ANIM_TYPE, $49
@efe3:  jsr     _c2f98b
        clr_ax
@efe8:  lda     $7fc401,x
        and     #$df
        sta     $7fc401,x
        inx2
        cpx     #$0020
        bne     @efe8
        jsl     ResetSpritePriority_far
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $48: harvester, scar beam ]

        array_label ANIM_TYPE, $48
@effe:  lda     #$10
        jsr     _c2f66f
        jsl     ResetSpritePriority_far
        ldx     #$0060
        jsl     _c1c3a7
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $47: mute, slow 2, cure 3, sun bath, el nino, blaster, atomic ray, riot blade ]

; water splash

        array_label ANIM_TYPE, $47
@f00f:  lda     #$03

_c2f011:
@f011:  sta     $26
        lda     #$03
        jsr     CopyThread
        lda     #$04
        jsr     SetNumThreads
        jmp     _c2f9eb

; ------------------------------------------------------------------------------

; [ battle animation init $46: moon song ]

        array_label ANIM_TYPE, $46
@f020:  ldx     #GENJU_GFX::FENRIR
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ init mode 7 animation ]

InitMode7:
@f02d:  phb
        lda     #$7f
        pha
        plb
        clr_ax
        longa
        lda     #$003f
@f039:  sta     $c400,x
        sta     $cc00,x
        sta     $d400,x
        sta     $dc00,x
        inx2
        cpx     #$0800
        bne     @f039
        shorta0
        plb
        lda     near w7e898d                 ; disable bg1 in main screen
        and     #$fe
        sta     near w7e898d
        ldx     #$0100
        stx     near w7ee9c4
        stx     near w7ee9ca
        clr_ax
        stx     near w7ee9c6
        stx     near w7ee9c8
        stx     near w7ee9cc
        stx     near w7ee9ce
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $45: atom edge ]

        array_label ANIM_TYPE, $45
@f070:  jsr     InitMode7
        ldx     #GENJU_GFX::ODIN
        phx
        jsl     _c12400
        jsr     LoadSummonPalBG1
        jsl     ClearBGAnimFrames_far
        plx
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        inc     near w7e62b0
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $44: sonic dive ]

        array_label ANIM_TYPE, $44
@f08e:  ldx     #GENJU_GFX::PALIDOR
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1

_c2f098:
magic_type59_main:
@f098:  clr_ayx
@f09b:  lda     near wAnimThread::TargetIndex,x
        sta     near wAnimThread::AttackerIndex,x
        longa
        lda     near wAnimThread::TargetPosX,x
        sta     near wAnimThread::AttackerPosX,x
        lda     near wAnimThread::TargetPosY,x
        sta     near wAnimThread::AttackerPosY,x
        txa
        clc
        adc     #$0080
        tax
        shorta0
        iny
        cpx     #$0200
        bne     @f09b
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $43: chaos wing ]

        array_label ANIM_TYPE, $43
@f0c1:  ldx     #GENJU_GFX::MADUIN
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2fa1b
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $42: sun flare ]

        array_label ANIM_TYPE, $42
@f0dd:  lda     #$02
        jsr     _c2f66f
        ldx     #GENJU_GFX::BAHAMUT
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $41: group hug ]

        array_label ANIM_TYPE, $41
@f0f9:  ldx     #GENJU_GFX::STARLET
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2fa1b
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $40: reviver ]

        array_label ANIM_TYPE, $40
@f109:  ldx     #GENJU_GFX::SRAPHIM
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jsr     array_item ANIM_TYPE, $1c
        jmp     _c2fa33

; ------------------------------------------------------------------------------

; [ battle animation init $3f: rebirth ]

        array_label ANIM_TYPE, $3f
@f119:  ldx     #GENJU_GFX::PHOENIX
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f9a3
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $3e: heal horn ]

        array_label ANIM_TYPE, $3e
@f129:  ldx     #GENJU_GFX::UNICORN
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f997
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        lda     near w7e896f
        and     #$f7
        sta     near w7e896f
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $3d: life guard ]

        array_label ANIM_TYPE, $3d
@f14d:  ldx     #GENJU_GFX::KIRIN
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2fa27
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #CIRCLE_SHAPE::VERT_OVAL
        sta     near wCircleShape
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $3c: ruby power ]

        array_label ANIM_TYPE, $3c
@f16b:  ldx     #GENJU_GFX::CARBUNKL
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [  ]

_c2f178:
set_circle_line:
@f178:  stx     $10
        clr_ax
        longa
        clr_ax
        lda     #$f708
@f183:  sta     near w7e9a1f+2,x
        inx4
        cpx     $10
        bne     @f183
        shorta0
        inc     near w7e6197
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $3b: justice ]

        array_label ANIM_TYPE, $3b
magic_type3b:
@f195:  ldx     #GENJU_GFX::ALEXANDR
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jsr     _c2fa0f
        jsl     ResetSpritePriority_far
        ldx     #$0081
        jsl     _c1c3a7
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        ldx     #$0200
        jsr     _c2f178
        jsr     _c2f1ca
        lda     near w7e896f
        and     #$f7                    ; disable bg3 priority
        sta     near w7e896f
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ copy genju thread 1 to genju thread 2 and 3 ]

_c2f1ca:
magic_type3b_sub:
@f1ca:  stz     near wGenjuThread1::ThreadIndex
        ldx     #GENJU_THREAD_1_OFFSET
@f1d0:  lda     near wAnimThread::BLOCK_1,x
        sta     near wAnimThread::_1::BLOCK_1,x
        sta     near wAnimThread::_2::BLOCK_1,x
        lda     near wAnimThread::BLOCK_2,x
        sta     near wAnimThread::_1::BLOCK_2,x
        sta     near wAnimThread::_2::BLOCK_2,x
        lda     near wAnimThread::BLOCK_3,x
        sta     near wAnimThread::_1::BLOCK_3,x
        sta     near wAnimThread::_2::BLOCK_3,x
        inx
        cpx     #GENJU_THREAD_2_OFFSET
        bne     @f1d0
        inc     near wGenjuThread2::ThreadIndex
        lda     #2
        sta     near wGenjuThread3::ThreadIndex
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $3a: hope song ]

        array_label ANIM_TYPE, $3a
@f1fa:  stz     near w7e62ad                 ; clear backdrop gradient counters
        stz     near w7e62ae
        jsr     _c2f66d
        ldx     #GENJU_GFX::SIREN
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jsr     _c2fa03
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $39: gem dust ]

        array_label ANIM_TYPE, $39
@f211:  ldx     #GENJU_GFX::SHIVA
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f9c7
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $38: bolt fist ]

        array_label ANIM_TYPE, $38
@f221:  ldx     #GENJU_GFX::RAMUH
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f9eb       ; add bg2, affect sprites
        jmp     array_item ANIM_TYPE, $0b       ; two animation threads

; ------------------------------------------------------------------------------

; [ battle animation init $37: wall (zoneseek) ]

        array_label ANIM_TYPE, $37
@f231:  ldx     #GENJU_GFX::ZONESEEK
        jsl     LoadSummonGfxBG1_far
        jsr     LoadSummonPalBG1
        jsr     _c2f9eb       ; add bg2, affect sprites
        jmp     array_item ANIM_TYPE, $0b       ; two animation threads

; ------------------------------------------------------------------------------

; [ battle animation init $36: sea song ]

        array_label ANIM_TYPE, $36
@f241:  stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        ldx     #GENJU_GFX::BISMARK
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2fa1b
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $35: earth aura ]

        array_label ANIM_TYPE, $35
@f25d:  lda     #CIRCLE_SHAPE::HORZ_OVAL
        sta     near wCircleShape
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        ldx     #GENJU_GFX::TERRATO
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2f9a3
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $34: demon eye ]

        array_label ANIM_TYPE, $34
@f27b:  ldx     #GENJU_GFX::SHOAT
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        inc     near w7e62b0
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $33: inferno ]

        array_label ANIM_TYPE, $33
@f289:  ldx     #GENJU_GFX::IFRIT
        jsl     LoadSummonGfxSprite_far
        jsr     LoadSummonPalSprite
        jsr     _c2fa27
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $32: ultima ]

        array_label ANIM_TYPE, $32
@f299:  jsr     _c2f9af
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #$cc
        sta     f:hW34SEL
        lda     #CIRCLE_SHAPE::ULTIMA
        sta     near wCircleShape
        lda     near w7e896f
        and     #$f7
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $24: antdot, regen, star prism ]

        array_label ANIM_TYPE, $24
@f2b9:  jsr     array_item ANIM_TYPE, $14
        jmp     array_item ANIM_TYPE, $1d

; ------------------------------------------------------------------------------

; [ battle animation init $08: slash ]

        array_label ANIM_TYPE, $08
@f2bf:  jsr     array_item ANIM_TYPE, $1d
        ldx     #$8402      ; subtract bg3
        stx     $10
        lda     #$13        ; affect sprites, bg1, and bg2
        jsl     SetColorMathHDMA_far
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jsl     ClearBG3Tiles_far
        lda     near w7e896f       ; 16x16 bg3 tiles, high priority bg3
        ora     #$48
        sta     near w7e896f
        clr_ax
        stx     near wBG3ScrollData::Horz       ; clear bg3 scroll hdma data
        stx     near wBG3ScrollData::Vert
        inc     near w7e60ad       ; pause bg3 animation threads
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2f2f1:
caster_pri_up:
@f2f1:  jsl     GetAttackerNum_far
        lda     $10
        bmi     @f304
        asl5
        tay
        lda     #$30
        sta     near wCharGfxData::LayerPriority,y
@f304:  rts

; ------------------------------------------------------------------------------

; [ battle animation init $06:  ]

        array_label ANIM_TYPE, $06
@f305:  jsl     ResetSpritePriority_far
        stz     near wHideBG1MonsterSprites
        jsl     WaitFrame_far
        jsl     UpdateSpritePriority_far
        lda     near w7e896f
        and     #$ef
        sta     near w7e896f
        jsl     _c1aaa1
        lda     $12

_c2f322:
@f322:  and     #$7f
        sec
        sbc     #$04
        jsr     GetBitMask_near
        pha
        jsl     MonstersToBG1_far
        jsr     _c2f2f1
        jsl     TfrBG1Tiles_far
        jsl     WaitFrame_far
        pla
        not_a
        sta     near w7e60ab
        lda     near w7e627d
        and     #$7f
        sta     near w7e627d
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $29: quake ]

        array_label ANIM_TYPE, $29
@f351:  jsr     array_item ANIM_TYPE, $1f
        lda     #CIRCLE_SHAPE::HORZ_OVAL
        sta     near wCircleShape
        stz     near w7e60ac       ; unpause bg1 animation threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $1f: imp ]

        array_label ANIM_TYPE, $1f
magic_type1f:
@f35d:  inc     near w7e60ac       ; pause bg1 animation threads
        jsr     _c2f9eb
        jsr     InitCircle
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        lda     #$3c
        sta     f:hW12SEL

_c2f36f:
tpri_up:
@f36f:  jsl     _c1aaa1
        lda     $12
        bpl     @f384
        and     #$0f
        sec
        sbc     #$04
        asl
        tay
        lda     #$31
        sta     near w7e80db+1,y
        rts
@f384:  and     #$03
        asl5
        tay
        lda     #$30
        sta     near wCharGfxData::LayerPriority,y
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $1e:  ]

        array_label ANIM_TYPE, $1e
@f392:  lda     #$08
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jsr     SetNumThreads
        jsr     _c2fa1b
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #CIRCLE_SHAPE::VERT_OVAL
        sta     near wCircleShape
        inc     near w7e60ac       ; pause bg1 animation threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $20: tekbarrier ]

        array_label ANIM_TYPE, $20
@f3b5:  lda     #$08
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jsr     SetNumThreads
        jsr     _c2fa03
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $2c:  ]

        array_label ANIM_TYPE, $2c
@f3d9:  jsr     _c2fa1b
        lda     #$cc
        sta     f:hW34SEL
        jsr     InitCircle
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $2a: x-zone ]

        array_label ANIM_TYPE, $2a
magic_type2a:
@f3e9:  jsr     _c2f9df
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        lda     #CIRCLE_SHAPE::BIG_BLOB
        sta     near wCircleShape
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $31: pearl ]

        array_label ANIM_TYPE, $31
@f3fb:  lda     #$00
        sta     $26
        lda     #$02
        jsr     CopyThread
        lda     #$03
        jsr     SetNumThreads
        lda     near w7e896f
        and     #$f7
        sta     near w7e896f
        jsr     _c2f9bb
        inc     near w7e60ac       ; pause bg1 animation threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $1a: rasp ]

        array_label ANIM_TYPE, $1a
@f418:  lda     #$08
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jsr     SetNumThreads
        jsr     _c2fa33
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $04: debilitator ]

        array_label ANIM_TYPE, $04
@f436:  jsr     _c2fa33
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jsl     ResetSpritePriority_far
        jsl     GetAttackerNum_far
        lda     $10
        jsl     _c1c3ed
        lda     $10
        and     #$03
        asl5
        tay
        lda     #$30
        sta     near wCharGfxData::LayerPriority,y
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $0c: aurabolt ]

        array_label ANIM_TYPE, $0c
@f46b:  jsr     _c2fa33
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        inc     near w7e60ac       ; pause bg1 animation threads
        inc     near w7e60ad       ; pause bg3 animation threads
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $0a: stunner, spin edge, takedown ]

        array_label ANIM_TYPE, $0a
@f489:  jsr     _c2fa33
        inc     near w7e60ac       ; pause bg1 animation threads
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [  ]

AnimType_09_far:
@f498:  jsr     array_item ANIM_TYPE, $09
        rtl

; ------------------------------------------------------------------------------

; [ battle animation init $09: quadra slam, empowerer, quadra slice, pummel, air blade, shock, mooglerush ]

        array_label ANIM_TYPE, $09
@f49c:  inc     near w7e60ac       ; pause bg1 animation threads
        lda     #8
        sta     near w7e7b0e       ; 8 monster threads
        sta     near w7e7b0f       ; 8 character threads
        ldx     #$0102      ; add bg1
        stx     $10
        lda     #$12        ; affect sprites and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [  ]

_c2f4b3:
get_caster_data_x:
@f4b3:  jsl     GetAttackerNum_far
        lda     $10
        longa
        asl
        tax
        lda     f:_c2ce8b,x   ; pointer to animation thread data (+$7e64de)
        clc
        adc     #$0010
        tax
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $12: esper magic ]

        array_label ANIM_TYPE, $12
@f4ca:  jsr     _c2f4b3
        lda     #$01
        sta     near wAnimThread::_0::AnimFrameCounter,x
        sta     near wAnimThread::_1::AnimFrameCounter,x
        sta     near wAnimThread::_2::AnimFrameCounter,x

; 3 threads, equally spaced around a circle
        lda     #0
        sta     near wAnimThread::_0::w7e74d8,x
        lda     #$ff/3
        sta     near wAnimThread::_1::w7e74d8,x
        lda     #2*$ff/3
        sta     near wAnimThread::_2::w7e74d8,x
        ldx     #$0302      ; add bg1 and bg2
        stx     $10
        lda     #$10        ; affect sprites
        jsl     SetColorMathHDMA_far
        lda     #4
        sta     near w7e7b0f
        rts

; ------------------------------------------------------------------------------

; [ copy animation thread ]

;   A: number of copies
; $26: frame delay

CopyThread:
@f4f8:  sta     $22                     ; $22 = number of copies
        lda     $26
        sta     $28                     ; $28 = frame delay

; make a consecutive bitmask of character and monster targets
; wAnimCharTargets: --mmmmmm ----cccc
;     $12: ------mm mmmmcccc
        ldx     near wAnimCharTargets
        stx     $12
        txa
        asl4
        sta     $12
        longa
        lda     $12
        lsr4
        sta     $12
        lda     near w7e6080                 ; characters/monsters with this thread
        lsr4
        sta     near w7e6080
        stz     $24                     ; +$24 = pointer to animation thread data
        shorta0
@f523:  lda     near w7e6080
        and     #$01
        bne     @f56f                   ; skip if target does not have this thread
        lda     $12
        and     #$01
        beq     @f56f                   ; skip if not a target
        lda     $22                     ; $14 = counter for number of copies
        sta     $14
        ldx     $24                     ; pointer to animation thread data
        lda     #1
        sta     $1a                     ; thread number (start with 1)
@f53a:  stx     $1e
        lda     #wAnimThread::BLOCK_SIZE
        sta     $10
@f540:  lda     near wAnimThread::_0::BLOCK_1,x     ; copy thread data
        sta     near wAnimThread::_1::BLOCK_1,x
        lda     near wAnimThread::_0::BLOCK_2,x
        sta     near wAnimThread::_1::BLOCK_2,x
        lda     near wAnimThread::_0::BLOCK_3,x
        sta     near wAnimThread::_1::BLOCK_3,x
        inx                             ; next byte
        dec     $10
        bne     @f540
        phx
        ldx     $1e                     ; pointer to animation thread data
        lda     $1a                     ; set thread index
        sta     near wAnimThread::_1::ThreadIndex,x
        inc     $1a
        lda     near wAnimThread::_0::AnimFrameCounter,x     ; add frame delay to previous thread's frame counter
        clc
        adc     $26
        sta     near wAnimThread::_1::AnimFrameCounter,x
        plx
        dec     $14                     ; next copy
        bne     @f53a
@f56f:  ror     $13                     ; next character/monster
        ror     $12
        ror     near w7e6081
        ror     near w7e6080
        longa
        lda     $24                     ; increment pointer to animation thread data
        clc
        adc     #$0080
        sta     $24
        tax
        shorta0
        cpx     #BG1_THREAD_OFFSET
        bne     @f523
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $15: flare, step mine, dread, fenix down ]

        array_label ANIM_TYPE, $15
@f58d:  jsr     _c2fa33

_c2f590:
@f590:  lda     #$08
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $2d: merton ]

        array_label ANIM_TYPE, $2d
@f59e:  jmp     _c2fa33

; ------------------------------------------------------------------------------

; [ battle animation init $23: haste2, phantasm ]

        array_label ANIM_TYPE, $23
@f5a1:  jmp     _c2fa33

; ------------------------------------------------------------------------------

; [ battle animation init $30: break ]

        array_label ANIM_TYPE, $30
@f5a4:  lda     #$00
        sta     $26
        lda     #$07
        jsr     CopyThread
        lda     #$08
        jsr     SetNumThreads
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jmp     _c2fa27

; ------------------------------------------------------------------------------

; [ battle animation init $22: dispel, shock wave ]

        array_label ANIM_TYPE, $22
magic_type22:
@f5c1:  inc     near w7e60ac       ; pause bg1 animation threads
        lda     #$00
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $2f: sketch ]

        array_label ANIM_TYPE, $2f
magic_type2f:
@f5d2:  ldy     #$2800
        jsl     ClearBG1TargetTiles_far
        lda     near w7e898d                 ; disable bg1 in main screen
        and     #$fe
        sta     near w7e898d
        ldy     #3
        lda     (z76),y

.if ROM_VERSION >= 1
; **** added in rev 1 ****
        bpl     @f5e6
        ldx     #$ffff
        bra     @f5f1
; ************************
.endif

@f5e6:  asl
        tax
        longa
        lda     near w7e2001,x
        tax
        shorta0
@f5f1:  jsl     LoadSketchMonsterGfx
        jmp     array_item ANIM_TYPE, $0b

; ------------------------------------------------------------------------------

; [ battle animation init $2e:  ]

        array_label ANIM_TYPE, $2e
magic_type2e:
@f5f8:  lda     #$08
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jsr     SetNumThreads
        jsr     _c2fa1b
        inc     near w7e60ac       ; pause bg1 animation threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $21:  ]

        array_label ANIM_TYPE, $21
magic_type21:
@f60d:  lda     #$08
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jsr     SetNumThreads
        jsr     _c2fa27
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #CIRCLE_SHAPE::SMALL_BLOB
        sta     near wCircleShape
        inc     near w7e60ac       ; pause bg1 animation threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $14: life, life 2, whump, fallen one ]

        array_label ANIM_TYPE, $14
magic_type14:
@f630:  lda     #$06
        sta     $26
        lda     #$05
        jsr     CopyThread
        lda     #$06
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $1c: fire 3, muddle, cure 2, etc. ]

; tapir, ice rabbit, big guard, pearl wind, l.3 muddle, rippler, confusion, dried meat, health, shadow edge

        array_label ANIM_TYPE, $1c
magic_type1c:
@f63e:  stz     $26
        lda     #$03
        jsr     CopyThread
        lda     #$04
        jsr     SetNumThreads
        jmp     _c2fa1b

; ------------------------------------------------------------------------------

; number of duplicate threads per target (meteor, fire dance)
_c2f64d:
chg_type28_copy:
@f64d:  .byte   $00,$05,$02,$01,$01,$00,$00

; ------------------------------------------------------------------------------

; total number of threads per target
_c2f654:
chg_type28_copy2:
@f654:  .byte   $01,$06,$03,$02,$02,$01,$01

; ------------------------------------------------------------------------------

; [ battle animation init $28: meteor, fire dance ]

        array_label ANIM_TYPE, $28
magic_type28:
@f65b:  jsr     _c2fa03
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL     ; enable bg1 in window 2, bg2 in window 1
        lda     #$cc
        sta     f:hW34SEL     ; enable bg3 in window 2

_c2f66d:
magic_type28_main:
@f66d:  lda     #$08

_c2f66f:
magic_type28_main2:
@f66f:  sta     $26
        clr_ax
        longa
        lda     near wAnimCharTargets       ; targets
        ldy     #$0010
@f67b:  asl
        bcc     @f67f       ; branch if target wasn't hit
        inx
@f67f:  dey                 ; next target
        bne     @f67b
        cpx     #$0006      ; max 6 targets
        bcc     @f68a
        ldx     #$0006
@f68a:  shorta0
        lda     #CIRCLE_SHAPE::HORZ_OVAL
        sta     near wCircleShape
        lda     f:_c2f64d,x   ; number of duplicate threads per target
        beq     @f69d
        phx
        jsr     CopyThread
        plx
@f69d:  lda     f:_c2f654,x   ; total number of threads per target
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $18: drain, osmose, raid, cold dust ]

        array_label ANIM_TYPE, $18
@f6a4:  jsr     _c2fa27
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL     ; enable bg1 in window 2, bg2 in window 1
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        inc     near w7e60ac       ; pause bg1 animation threads
        lda     #$03
        sta     $26
        lda     #$05        ; make 5 copies
        jsr     CopyThread
        lda     #$06
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $25: fire, bio, etc. ]

; sonic boom, plasma, blaze, shimsham, sonic boom, plasma, blaze, shimsham

        array_label ANIM_TYPE, $25
@f6c4:  jsr     _c2fa3f       ; set color add/sub data (add bg1 and bg2, affect sprites)
        lda     #$08        ; 8 frame delay between threads
        sta     $26
        lda     #$02        ; make 2 copies
        jsr     CopyThread
        lda     #$03
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ battle animation init $17: life 3 ]

        array_label ANIM_TYPE, $17
@f6d5:  jsr     _c2fa1b       ; add bg1, affect sprites and bg2
        lda     #$28        ; frame delay = $28

_c2f6da:
@f6da:  sta     $26
        lda     #$01        ; 1 copy
        jsr     CopyThread
        lda     #$02
        jmp     SetNumThreads

; ------------------------------------------------------------------------------

; [ set number of animation threads ]

SetNumThreads:
@f6e6:  sta     near w7e7b0f       ; character threads
        sta     near w7e7b0e       ; monster threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $11: white/effect magic ]

        array_label ANIM_TYPE, $11
@f6ed:  jsr     _c2f4b3

; set thread frame delays
        lda     #1
        sta     near wAnimThread::_0::AnimFrameCounter,x
        sta     near wAnimThread::_1::AnimFrameCounter,x
        lda     #9
        sta     near wAnimThread::_2::AnimFrameCounter,x
        sta     near wAnimThread::_3::AnimFrameCounter,x
        lda     #17
        sta     near wAnimThread::_4::AnimFrameCounter,x
        sta     near wAnimThread::_5::AnimFrameCounter,x

; set thread frame offsets
        lda     #1
        sta     near wAnimThread::_2::LoopFrameOffset,x
        sta     near wAnimThread::_3::LoopFrameOffset,x
        lda     #2
        sta     near wAnimThread::_4::LoopFrameOffset,x
        sta     near wAnimThread::_5::LoopFrameOffset,x

; reverse direction
        lda     #$80
        sta     near wAnimThread::_1::w7e74d8,x
        sta     near wAnimThread::_3::w7e74d8,x
        sta     near wAnimThread::_5::w7e74d8,x

; 3 sprites move forward, 3 move backward
        clr_a
        sta     near wAnimThread::_0::w7e74d9,x
        sta     near wAnimThread::_2::w7e74d9,x
        sta     near wAnimThread::_4::w7e74d9,x
        lda     #$ff
        sta     near wAnimThread::_1::w7e74d9,x
        sta     near wAnimThread::_3::w7e74d9,x
        sta     near wAnimThread::_5::w7e74d9,x

; run init function below, but with 7 threads instead of 2
        jsr     array_item ANIM_TYPE, $0f
        lda     #7
        sta     near w7e7b0f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $0f: w wind, spiraler, black magic, blitz ]

        array_label ANIM_TYPE, $0f
@f741:  jsr     _c2fa1b
        jsl     ResetSpritePriority_far
        jsl     GetAttackerNum_far
        lda     $10
        jsl     _c1c3ed
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        lda     near w7e896f
        and     #$f7
        sta     near w7e896f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $16: remedy, wild bear ]

        array_label ANIM_TYPE, $16
@f763:  jsr     _c2fa1b
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        lda     #CIRCLE_SHAPE::TOP_BEAM
        sta     near wCircleShape
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $19: scan, targetting ]

        array_label ANIM_TYPE, $19
@f77d:  jsr     _c2f9f7
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $2b:  ]

        array_label ANIM_TYPE, $2b
@f795:  jsr     _c2f9d3
        lda     #2
        sta     near w7e7b0e
        sta     near w7e7b0f
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $13: storm, rage/lore, swdtech ]

        array_label ANIM_TYPE, $13
@f7a1:  jsr     _c2fa1b
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        stz     near wCircleShape       ; CIRCLE_SHAPE::CIRCLE
        jsl     ResetSpritePriority_far
        jsl     GetAttackerNum_far
        lda     $10
        jsl     _c1c3ed
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $0e: mantra ]

        array_label ANIM_TYPE, $0e
@f7c7:  jsr     _c2fa27
        jsr     InitCircle
        lda     #$3c
        sta     f:hW12SEL
        jsl     ResetSpritePriority_far
        jsl     GetAttackerNum_far
        lda     $10
        jsl     _c1c3ed
        lda     #CIRCLE_SHAPE::BIG_BLOB
        sta     near wCircleShape
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $03: sour mouth, bio blaster ]

        array_label ANIM_TYPE, $03
@f7ef:  jsr     _c2fa33
        jsr     InitCircle
        lda     #$cc
        sta     f:hW34SEL
        lda     #CIRCLE_SHAPE::BIO_BLAST
        sta     near wCircleShape
        lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $0b/10: poison, ice 2, etc. ]

; stop, float, vanish, warp, quick, cure, water edge, cleave, rage, cokatrice, wombat
; pois. frog, super ball, heal force, aero, l.5 doom, pep up, stone, chokesmoke, schiller
; megazerk, entwine, magnitude8, n. cross, r.polarity, tentacle, heart burn, discard
; back blade, x-meteo, wild fang, lagomorph, most non-spell attacks
; battle (attack $ee) uses init function $0b

        array_label ANIM_TYPE, $0b
        array_label ANIM_TYPE, $10
@f809:  lda     #2
        sta     near w7e7b0e       ; 2 monster threads
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $05: air anchor ]

        array_label ANIM_TYPE, $05
@f812:  inc     near w7e60aa       ;
        lda     #6
        sta     near w7e7b0e       ; 6 monster threads
        lda     #2
        sta     near w7e7b0f       ; 2 character threads
        rts

; ------------------------------------------------------------------------------

; [ battle animation init $01/$07: retort, noiseblaster, flash, chain saw, drill ]

        array_label ANIM_TYPE, $01
        array_label ANIM_TYPE, $07
@f820:  inc     near w7e60ac       ; pause bg1 animation threads
        lda     #2
        sta     near w7e7b0f       ; 2 character threads
        jmp     _c2fa3f       ; add bg1 and bg2, affect sprites

; ------------------------------------------------------------------------------

; [ battle animation init $02:  ]

        array_label ANIM_TYPE, $02
@f82b:  lda     #6
        sta     near w7e7b0e       ; 6 monster threads
        sta     near w7e7b0f       ; 6 character threads
        jmp     _c2fa3f       ; add bg1 and bg2, affect sprites

; ------------------------------------------------------------------------------

; [ battle animation init $00: bolt, suplex, bomblet ]

        array_label ANIM_TYPE, $00
@f836:  jmp     _c2fa3f       ; add bg1 & bg2, affect sprites

; ------------------------------------------------------------------------------

; [ battle animation init $1b: ice, fire 2, bolt 2, ice 3, etc. ]

; safe, rflect, shell, fire skean, wind slash, sand storm, flash, aqua rake, revenge, l? pearl
; lullaby, acid rain, cyclonic, mega volt, giga volt, blizzard, absolute 0, gale cut, baba breath
; shadowfang, royalshock, morph

        array_label ANIM_TYPE, $1b
@f839:  jmp     _c2fa1b       ; add bg1, affect sprites & bg2

; ------------------------------------------------------------------------------

; [ battle animation init $26: condemned ]

        array_label ANIM_TYPE, $26
@f83c:  lda     near w7e896f       ; disable bg3 priority
        and     #$f7
        sta     near w7e896f
        jmp     _c2fa0f       ; add bg1, affect bg3

; ------------------------------------------------------------------------------

; [ battle animation init $27: doom, roulette, sabresoul ]

        array_label ANIM_TYPE, $27
magic_type27:
@f847:  longa
        lda     near w7e6080       ; targets hit
        not_a
        sta     $22
        lda     near w7e607e       ; possible targets
        and     $22
        pha
        shorta0
        plx
        bne     @f85e       ;
        rts
@f85e:  stz     near wHideBG1MonsterSprites
        jsl     ResetSpritePriority_far
        jsl     WaitFrame_far
        jsl     UpdateSpritePriority_far
        jsl     ClearBG3Tiles_far
        jsl     _c1aaa1
        lda     $12
        bpl     @f88f       ; branch if a character
        and     #$7f
        sec
        sbc     #$04
        jsr     GetBitMask_near
        jsl     MonstersToBG1_far
        jsl     TfrBG1Tiles_far
        jsl     WaitFrame_far
        bra     @f8ae
@f88f:  and     #$03
        asl5
        tax
        clr_ay
@f899:  lda     near w7e7e00::_12,x
        sta     near w7e7e00::_3,y
        iny
        inx
        cpy     #$0020
        bne     @f899
        lda     near w7e896f       ; change bg1 tile size to 16x16
        ora     #$10
        sta     near w7e896f
@f8ae:  lda     near w7e627d       ; use bg1 for graphics ???
        and     #$7f
        sta     near w7e627d
        jsr     _c2f36f
        jsl     WaitFrame_far
        lda     near w7e896f       ; disable bg3 priority, change bg3 tile size to 16x16
        and     #$f7
        ora     #$40
        sta     near w7e896f
        jmp     _c2fa1b       ; add bg1, affect sprites and bg2

; ------------------------------------------------------------------------------

; [ battle animation init $1d: haste, bserk, dispatch, bum rush, dischord, wallchange, escape ]

        array_label ANIM_TYPE, $1d
magic_type1d:
@f8ca:  stz     near wHideBG1MonsterSprites
        jsl     ResetSpritePriority_far
        jsl     WaitFrame_far
        jsl     ClearBG3Tiles_far
        jsl     _c1aaa1
        lda     $12
        bpl     @f925
        and     #$7f
        sec
        sbc     #$04
        jsr     GetBitMask_near
        pha
        sta     $14
        jsr     WaitLine160_near
        lda     near w7e898d                 ; disable bg1 in main screen
        pha
        and     #$fe
        sta     near w7e898d
        lda     $14
        jsl     MonstersToBG1_far
        jsl     TfrBG1Tiles_far
        jsl     UpdateSpritePriority_far
        jsl     WaitFrame_far
        jsr     WaitLine160_near
        lda     near w7e896f
        and     #$e7
        sta     near w7e896f
        pla
        sta     near w7e898d
        pla
        not_a
        sta     near w7e60ab
        jsl     WaitFrame_far
        bra     @f95c
@f925:  pha
        jsr     WaitLine160_near
        lda     near w7e898d                 ; disable bg1 in main screen
        pha
        and     #$fe
        sta     near w7e898d
        lda     near w7e896f
        and     #$e7
        ora     #$50
        sta     near w7e896f
        jsl     ClearBG1Tiles_far
        pla
        sta     near w7e898d
        pla
        and     #$03
        asl5
        tax
        clr_ay
@f94f:  lda     near w7e7e00::_12,x
        sta     near w7e7e00::_3,y
        iny
        inx
        cpy     #$0020
        bne     @f94f
@f95c:  lda     near w7e627d
        and     #$7f
        sta     near w7e627d
        jmp     _c2fa0f       ; add bg1, affect bg3

; ------------------------------------------------------------------------------

; [ add bg3, affect bg1 ]

_c2f967:
hdma_set18:
@f967:  ldx     #$0402      ; add bg3
        stx     $10
        lda     #$01        ; affect bg1
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1 and bg3, affect sprites and bg2 ]

_c2f973:
hdma_set17:
@f973:  ldx     #$4502      ; half add bg1 and bg3
        stx     $10
        lda     #$12        ; affect sprites and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg3, affect bg1 and bg2 ]

; unused

_c2f97f:
hdma_set16:
@f97f:  ldx     #$0402      ; add bg3
        stx     $10
        lda     #$03        ; affect bg1 and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1, affect bg2 ]

_c2f98b:
hdma_set15:
@f98b:  ldx     #$0102      ; add bg1
        stx     $10
        lda     #$02        ; affect bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1, affect sprite and bg3 ]

_c2f997:
hdma_set14:
@f997:  ldx     #$0102      ; add bg1
        stx     $10
        lda     #$14        ; affect sprites and bg3
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg3, affect sprites and bg2 ]

_c2f9a3:
hdma_set13:
@f9a3:  ldx     #$0402      ; add bg3
        stx     $10
        lda     #$12        ; affect sprites and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ half add bg1, affect sprites and bg3 ]

_c2f9af:
hdma_set12:
@f9af:  ldx     #$4102      ; half add bg1
        stx     $10
        lda     #$14        ; affect sprites and bg3
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg2, affect bg3 ]

_c2f9bb:
hdma_set11:
@f9bb:  ldx     #$0202      ; add bg2
        stx     $10
        lda     #$04        ; affect bg3
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1 and bg3, affect sprites and bg2 ]

_c2f9c7:
hdma_set10:
@f9c7:  ldx     #$0502      ; add bg1 and bg3
        stx     $10
        lda     #$12        ; affect sprites and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ half add bg1, affect sprites and bg2 ]

_c2f9d3:
hdma_set09:
@f9d3:  ldx     #$4102      ; half add bg1
        stx     $10
        lda     #$12        ; affect sprites and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg3, affect sprites ]

_c2f9df:
hdma_set08:
@f9df:  ldx     #$0402      ; add bg3
        stx     $10
        lda     #$10        ; affect sprites
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg2, affect sprites ]

_c2f9eb:
hdma_set07:
@f9eb:  ldx     #$0202      ; add bg2
        stx     $10
        lda     #$10        ; affect sprites
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ half add bg1, affect sprites ]

_c2f9f7:
hdma_set06:
@f9f7:  ldx     #$4102      ; half add bg1
        stx     $10
        lda     #$10        ; affect sprites
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg3, affect sprites and bg1 ]

_c2fa03:
hdma_set05:
@fa03:  ldx     #$0402      ; add bg3
        stx     $10
        lda     #$11        ; affect sprites and bg1
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1, affect bg3 ]

_c2fa0f:
hdma_set04:
@fa0f:  ldx     #$0102      ; add bg1
        stx     $10
        lda     #$04        ; affect bg3
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1, affect sprites and bg2 ]

_c2fa1b:
hdma_set03:
@fa1b:  ldx     #$0102      ; add bg1
        stx     $10
        lda     #$12        ; affect sprites and bg2
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1, affect sprites ]

_c2fa27:
hdma_set02:
@fa27:  ldx     #$0102      ; add bg1
        stx     $10
        lda     #$10        ; affect sprites
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg3, affect sprites, bg1, and bg3 ]

_c2fa33:
hdma_set01:
@fa33:  ldx     #$0402      ; add bg3
        stx     $10
        lda     #$13        ; affect sprites, bg1, and bg3
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ add bg1 and bg2, affect sprites ]

_c2fa3f:
hdma_set00:
@fa3f:  ldx     #$0302      ; add bg1 and bg2
        stx     $10
        lda     #$10        ; affect sprites
        jsl     SetColorMathHDMA_far
        rts

; ------------------------------------------------------------------------------

; [ init circle (far) ]

InitCircle_far:
@fa4b:  jsr     InitCircle
        rtl

; ------------------------------------------------------------------------------

; [ init circle ]

InitCircle:
@fa4f:  clr_axy
@fa52:  lda     #$ff
        sta     near w7e9a1f+2,x     ; window position hdma buffer (left)
        sta     near w7e961f,y
        inc
        sta     near w7e9a1f+3,x     ; window position hdma buffer (right)
        sta     near w7e961f+1,y
        iny2
        inx4
        cpx     #$025c
        bne     @fa52
        inc     near w7e6197       ;
        rts

; ------------------------------------------------------------------------------

; [ load esper palette (bg1) ]

LoadSummonPalBG1:
@fa70:  ldx     near w7e6169
        clr_ay
@fa75:  lda     f:MonsterPal,x
        sta     near w7e7e00::_3,y
        sta     near w7e7c00::_3,y
        inx
        iny
        cpy     #$0020
        bne     @fa75
        rts

; ------------------------------------------------------------------------------

; [ load esper palette (sprite) ]

LoadSummonPalSprite:
@fa87:  ldx     near w7e6169
        clr_ay
@fa8c:  lda     f:MonsterPal,x
        sta     near w7e7e00::_11,y
        sta     near w7e7c00::_11,y
        inx
        iny
        cpy     #$0020
        bne     @fa8c
        rts

; ------------------------------------------------------------------------------

; [ A = 1 << A ]

GetBitMask_near:
@fa9e:  tax
        lda     f:BitOrTbl,x
        rts

; ------------------------------------------------------------------------------
