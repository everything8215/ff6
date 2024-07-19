; ------------------------------------------------------------------------------

.include "gfx/portrait.inc"

.import BattleCharPal, MenuSpriteGfx, WindowGfx, WindowPal, SmallFontGfx

.segment "menu_code"

; ------------------------------------------------------------------------------

; [ init graphics for colosseum character select ]

LoadColosseumGfx:
@6a66:  jsr     ClearPortraitGfx
        jsr     LoadFontGfx2bpp
        jsr     LoadFontPal
        jsr     LoadPortraitPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadPortraitGfx
        jsr     LoadCharGfx
        jsr     LoadMonsterGfx
        jmp     LoadColosseumBGGfx

; ------------------------------------------------------------------------------

; [ init menu graphics ]

InitMenuGfx:
@6a87:  clr_a
        lda     w0200       ; menu type
        asl
        tax
        jmp     (near InitMenuGfxTbl,x)

InitMenuGfxTbl:
@6a90:  .addr   InitMenuGfx_00
        .addr   InitMenuGfx_01
        .addr   InitMenuGfx_02
        .addr   InitMenuGfx_03
        .addr   InitMenuGfx_04
        .addr   InitMenuGfx_05
        .addr   InitMenuGfx_06
        .addr   InitMenuGfx_07
        .addr   InitMenuGfx_08
        .addr   InitMenuGfx_09

; ------------------------------------------------------------------------------

; type 6: swdtech renaming menu
InitMenuGfx_06:
@6aa4:  jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadMiscMenuSpriteGfx
        jmp     LoadMiscMenuSpritePal

; ------------------------------------------------------------------------------

; type 4/5/8/9: party select/unused/final battle order/unused
InitMenuGfx_04:
InitMenuGfx_05:
InitMenuGfx_08:
InitMenuGfx_09:
@6ab0:  jsr     ClearPortraitGfx
        jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadPortraitPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadPortraitGfx
        jmp     LoadCharGfx

; ------------------------------------------------------------------------------

; type 3: shop
InitMenuGfx_03:
@6ace:  jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadPortraitPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadCharPal
        jsr     LoadMiscMenuSpritePal
        jsr     LoadPortraitGfx
        jmp     LoadShopCharGfx

; ------------------------------------------------------------------------------

; type 0/2/7: main menu/load game/colosseum
InitMenuGfx_00:
InitMenuGfx_02:
InitMenuGfx_07:
@6ae9:  jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadMiscMenuSpriteGfx
        jsr     LoadPortraitGfx
        jsr     LoadPortraitPal
        jsr     LoadCharGfx
        jsr     LoadMiscMenuSpritePal
        jmp     LoadGrayCharPal

; ------------------------------------------------------------------------------

; type 1: name change
InitMenuGfx_01:
@6b04:  jsr     LoadFontGfx2bpp
        jsr     LoadFontGfx4bpp
        jsr     LoadFontPal
        jsr     LoadMiscMenuSpriteGfx
        jmp     LoadMiscMenuSpritePal

; ------------------------------------------------------------------------------

; [ load font graphics (2bpp) ]

LoadFontGfx2bpp:
@6b13:  longa
        ldy     #$6000
        sty     hVMADDL
        ldx     z0
@6b1d:  lda     f:SmallFontGfx,x   ; small font graphics
        sta     hVMDATAL
        inx2
        cpx     #$1000
        bne     @6b1d
@6b2b:  sta     hVMDATAL
        inx
        cpx     #$1400
        bne     @6b2b
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load font/window graphics (4bpp) ]

LoadFontGfx4bpp:
@6b37:  ldy     #$5000
        sty     hVMADDL
        longa
        clr_ax
@6b41:  ldy     #8
@6b44:  lda     f:_c36b9c,x
        sta     hVMDATAL
        dey
        bne     @6b44
        inx2
        cpx     #$0020
        bne     @6b41
        ldx     z0
@6b57:  ldy     #8
@6b5a:  lda     f:SmallFontGfx+$80,x
        sta     hVMDATAL
        inx2
        dey
        bne     @6b5a
.repeat 8
        stz     hVMDATAL
.endrep
        cpx     #$0f80
        bne     @6b57
        ldy     #$7800
        sty     hVMADDL
        ldx     z0
@6b8b:  lda     f:WindowGfx,x           ; menu window graphics
        sta     hVMDATAL
        inx2
        cpx     #$1000
        bne     @6b8b
        shorta
        rts

; ------------------------------------------------------------------------------

_c36b9c:
@6b9c:  .word   $0000,$0000,$00ff,$0000,$ff00,$0000,$ffff,$0000
        .word   $0000,$00ff,$00ff,$00ff,$ff00,$00ff,$ffff,$00ff

; ------------------------------------------------------------------------------

; [ load window palette ]

InitWindowPal:
@6bbc:  ldx     #8
        stx     $e7
        ldx     #0
        txy
        longa
@6bc7:  lda     #7
        sta     $e9
@6bcc:  lda     f:WindowPal+2,x         ; load wallpaper palettes
        sta     $1d57,y
        inx2
        iny2
        dec     $e9
        bne     @6bcc
        txa
        clc
        adc     #$0012
        tax
        dec     $e7
        bne     @6bc7
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load menu text palettes ]

LoadFontPal:
@6be8:  ldx     z0
        txa
        sta     hCGADD
@6bee:  longa
        lda     f:FontPal,x
        sta     wPalBuf,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #$00a0
        bne     @6bee
        rts

; ------------------------------------------------------------------------------

; [ load character portrait color palettes ]

LoadPortraitPal:
@6c09:  ldx     z0
        txy
@6c0c:  longa
        lda     zCharPropPtr,x                   ; pointer to character data
        phx
        phy
        tay
        clr_a
        shorta
        lda     #$10                    ; $e3 = counter (16 colors per palette)
        sta     $e3
        lda     $0014,y                 ; imp status
        and     #$20
        beq     @6c25
        lda     #$0f                    ; use portrait $0f
        bra     @6c30
@6c25:  clr_a
        lda     0,y                 ; character number
        cmp     #CHAR_PROP::LOCKE            ; if it's locke, use palette $01
        beq     @6c30
        lda     $0001,y                 ; otherwise, use the actor number
@6c30:  tax
        lda     f:CharPortraitPalTbl,x  ; get corresponding palette number
        longa
        asl5
        tax
        ply
@6c3e:  longa
        phx
        lda     f:PortraitPal,x
        tyx
        sta     wPalBuf::SpritePal0,x
        shorta
        plx
        inx2                ; next color
        iny2
        dec     $e3
        bne     @6c3e
        plx
        inx2                ; next palette
        cpx     #8
        bne     @6c0c
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load grayscale character sprite palette ]

LoadGrayCharPal:
@6c60:  lda     #$90
        sta     hCGADD
        ldx     z0
@6c67:  longa
        lda     f:GrayscalePal,x
        sta     wPalBuf::SpritePal1,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        iny2
        inx2
        cpx     #$0020
        bne     @6c67
        rts

; ------------------------------------------------------------------------------

; [ load cursor/icon palettes ]

LoadMiscMenuSpritePal:
@6c84:  ldx     z0
        lda     #$ec
        sta     hCGADD
@6c8b:  longa
        lda     f:StatusIconPal,x
        sta     $7e3221,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #8
        bne     @6c8b
        ldx     z0
        lda     #$fc
        sta     hCGADD
@6cac:  longa
        lda     f:GrayscalePal+$18,x   ; cursor palette
        sta     $7e3241,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #8
        bne     @6cac
        rts

; ------------------------------------------------------------------------------

; [ load character sprite palettes ]

LoadCharPal:
@6cc7:  ldx     z0
        lda     #$a0
        sta     hCGADD
@6cce:  longa
        lda     f:BattleCharPal,x
        sta     wPalBuf::SpritePal2,x
        shorta
        sta     hCGDATA
        xba
        sta     hCGDATA
        inx2
        cpx     #$00c0
        bne     @6cce
        rts

; ------------------------------------------------------------------------------

; [ load character sprite graphics ]

; used for colosseum, party change, and save screen, but not shops

LoadCharGfx:
@6ce9:  clr_ax
@6ceb:  phx
        longa
        lda     f:CharGfxVRAMAddr,x
        sta     $f3
        txa
        asl
        tax
        lda     f:MenuCharGfxPtrs+2,x   ; low word
        sta     $e7
        lda     f:MenuCharGfxPtrs,x     ; high word
        sta     $e9
        ldx     z0
@6d05:  lda     f:MenuCharPoseOffsets,x
        sta     $ef
        jsr     _c36d44
        lda     $f3
        clc
        adc     #$0100
        sta     $f3
        inx2                            ; next tile
        cpx     #4
        bne     @6d05
        lda     $f3
        sec
        sbc     #$01e0
        sta     $f3
        lda     f:MenuCharPoseOffsets,x
        sta     $ef
        jsr     _c36d44
        lda     $f3
        clc
        adc     #$0100
        sta     $f3
        jsr     _c36d67
        plx
        inx2                            ; next character (load 22 characters)
        cpx     #$002c
        bne     @6ceb
        shorta
        rts

; ------------------------------------------------------------------------------

; [ copy character sprite tile graphics to vram ]

; copies two adjacent 8x8 tiles

_c36d44:
@6d44:  clc
        lda     $ef
        adc     $e7
        sta     $eb
        clr_a
        adc     $e9
        sta     $ed
        ldy     $f3
        sty     hVMADDL
        jmp     @6d58                   ; this doesn't do anything
@6d58:  ldy     z0
@6d5a:  lda     [$eb],y
        sta     hVMDATAL
        iny2
        cpy     #$0040
        bne     @6d5a
        rts

; ------------------------------------------------------------------------------

; [ clear two tiles in vram ]

; clears the two tiles below a character's feet

.a16

_c36d67:
@6d67:  ldy     $f3
        sty     hVMADDL
        lda     #$0020
        sta     $e7
@6d71:  stz     hVMDATAL
        dec     $e7
        bne     @6d71
        rts

.a8

; ------------------------------------------------------------------------------

; [  ]

LoadShopCharGfx:
@6d79:  ldy     #$3000
        sty     hVMADDL
        stz     $e3
@6d81:  ldy     z0
@6d83:  shorta
        clr_a
        tyx
        lda     f:_c36e07,x
        asl
        tax
        longa
        lda     f:_c36e27,x
        cmp     #$ffff
        beq     @6dea
        pha
        lda     #$16a0
        shorta
        sta     hM7A
        xba
        sta     hM7A
        lda     $e3
        sta     hM7B
        sta     hM7B
        longa
        pla
        clc
        adc     hMPYL
        sta     $eb
        shorta
        lda     hMPYH
        adc     #$d5
        sta     $ed
        longa_clc
        lda     $eb
        adc     #$0000
        sta     $eb
        shorta
        lda     $ed
        adc     #$00
        sta     $ed
        longa
        phy
        jsr     _c36df8
        ply
@6dd7:  iny
        cpy     #$0020
        bne     @6d83
        shorta
        inc     $e3
        inc     $e3
        lda     $e3
        cmp     #$10
        bne     @6d81
        rts

.a16
@6dea:  lda     #$0010
        sta     $e7
@6def:  stz     hVMDATAL
        dec     $e7
        bne     @6def
        bra     @6dd7

; ------------------------------------------------------------------------------

; [  ]

_c36df8:
@6df8:  ldy     z0
@6dfa:  lda     [$eb],y
        sta     hVMDATAL
        iny2
        cpy     #$0020
        bne     @6dfa
        rts

.a8

; ------------------------------------------------------------------------------

_c36e07:
@6e07:  .byte   $00,$01,$04,$05,$08,$09,$0c,$0d,$10,$11,$14,$15,$18,$19,$1c,$1d
        .byte   $02,$03,$06,$07,$0a,$0b,$0e,$0f,$12,$13,$16,$17,$1a,$1b,$1e,$1f

_c36e27:
@6e27:  .word   $03c0,$03e0,$0500,$0520,$0540,$0560,$ffff,$ffff
        .word   $03c0,$0660,$0680,$06a0,$06c0,$06e0,$ffff,$ffff
        .word   $1a60,$1a80,$1ba0,$1bc0,$1be0,$1c00,$ffff,$ffff
        .word   $1a60,$1d00,$1d20,$1d40,$1d60,$1d80,$ffff,$ffff

; ------------------------------------------------------------------------------

; [ copy standard menu cursor/icon graphics to vram ]

LoadMiscMenuSpriteGfx:
@6e67:  longa
        ldy     #$2000
        sty     hVMADDL
        ldx     z0
@6e71:  lda     f:MenuSpriteGfx,x
        sta     hVMDATAL
        inx2
        cpx     #$1400
        bne     @6e71
        shorta
        rts

; ------------------------------------------------------------------------------

; [ load character portrait graphics ]

LoadPortraitGfx:
@6e82:  ldx     z0
@6e84:  longa
        lda     f:PortraitVRAMTbl,x     ; set vram pointer
        sta     hVMADDL
        ldy     zCharPropPtr,x          ; pointer to character data
        phx
        clr_a
        shorta
        lda     $0014,y                 ; imp status
        and     #STATUS1::IMP
        beq     @6e9e
        lda     #PORTRAIT_IMP
        bra     @6ea8
@6e9e:  lda     0,y                     ; character properties index
        cmp     #CHAR_PROP::LOCKE       ; if it's $01 (locke), use portrait 1
        beq     @6ea8
        lda     1,y                     ; otherwise, use char number
@6ea8:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x     ; pointer to character portrait graphics
        tax
        jsr     TfrPortraitGfx
        plx
        inx2
        cpx     #8
        bne     @6e84
        shorta
        rts

; ------------------------------------------------------------------------------

; [ get pointer to character portrait graphics ]

;   $9c = character slot number

;  +$19 = size (out)
;  +$1b = vram destination pointer (out)
; ++$1d = pointer to graphics (out)

GetPortraitGfxPtr:
@6ebf:  lda     #^PortraitGfx
        sta     zDMA2Src+2
        ldy     #$0320
        sty     zDMA2Size
        clr_a
        lda     $9c
        asl
        tax
        longa
        lda     f:PortraitVRAMTbl,x
        sta     zDMA2Dest
        ldy     zCharPropPtr,x
        clr_a
        shorta
        lda     $0014,y
        and     #STATUS1::IMP
        beq     @6ee5
        lda     #PORTRAIT_IMP
        bra     @6eef
@6ee5:  lda     0,y
        cmp     #CHAR_PROP::LOCKE
        beq     @6eef
        lda     $0001,y
@6eef:  longa
        asl
        tax
        lda     f:PortraitGfxPtrs,x
        clc
        adc     #near PortraitGfx
        sta     zDMA2Src
        shorta
        rts

; ------------------------------------------------------------------------------

; corresponding color palettes for each character portrait
CharPortraitPalTbl:
@6f00:  .byte   0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
        .byte   16,17,0,14,18,0,0,0,0,0,6

; pointers to character portrait graphics
PortraitGfxPtrs:
@6f1b:
.repeat 18, _i
        .addr   _i * $0320  ; first 18 portraits are sequential
.endrep
        .addr   0
        .addr   PORTRAIT_SOLDIER*$0320
        .addr   PORTRAIT_GHOST*$0320
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   0
        .addr   PORTRAIT_CELES*$0320

; vram pointers for character portrait graphics
PortraitVRAMTbl:
@6f51:  .word   $2600,$2800,$2a00,$2c00,$2e00,$3000,$3200,$3400

; ------------------------------------------------------------------------------

; [ make a list of character palettes for save slot 1 ]

MakeSaveSlot1PalList:
@6f61:  ldy     $91
        beq     @6f80
        ldx     z0
@6f67:  lda     zCharID,x
        bmi     @6f73
        jsr     GetCharGfxID
        jsr     FixSoldierPal
        bra     @6f75
@6f73:  lda     #$ff
@6f75:  sta     $7eaa71,x
        inx
        cpx     #4
        bne     @6f67
        rts
@6f80:  ldx     z0
        bra     _6f84

_6f84:  lda     #$ff
        sta     $7eaa71,x
        sta     $7eaa72,x
        sta     $7eaa73,x
        sta     $7eaa74,x
        rts

; ------------------------------------------------------------------------------

; [ get character graphics index ]

GetCharGfxID:
@6f97:  phx
        longa
        txa
        asl
        tax
        ldy     zCharPropPtr,x
        shorta
        plx
        lda     $0001,y
        rts

; ------------------------------------------------------------------------------

; [ fix palette id for brown or green soldier ]

FixSoldierPal:
@6fa6:  cmp     #CHAR_GFX::SOLDIER
        bne     @6fb7
        lda     $1ea0
        bit     #$08
        beq     @6fb5
        lda     #$16                    ; brown soldier
        bra     @6fb7
@6fb5:  lda     #$0e                    ; green soldier
@6fb7:  rts

; ------------------------------------------------------------------------------

; [ make a list of character palettes for save slot 2 ]

MakeSaveSlot2PalList:
@6fb8:  ldy     $93
        beq     @6fd7
        ldx     z0
@6fbe:  lda     zCharID,x
        bmi     @6fca
        jsr     GetCharGfxID
        jsr     FixSoldierPal
        bra     @6fcc
@6fca:  lda     #$ff
@6fcc:  sta     $7eaa75,x
        inx
        cpx     #4
        bne     @6fbe
        rts
@6fd7:  ldx     #4
        bra     _6f84

; ------------------------------------------------------------------------------

; [ make a list of character palettes for save slot 3 ]

MakeSaveSlot3PalList:
@6fdc:  ldy     $95
        beq     @6ffb
        ldx     z0
@6fe2:  lda     zCharID,x
        bmi     @6fee
        jsr     GetCharGfxID
        jsr     FixSoldierPal
        bra     @6ff0
@6fee:  lda     #$ff
@6ff0:  sta     $7eaa79,x
        inx
        cpx     #4
        bne     @6fe2
        rts
@6ffb:  ldx     #8
        bra     _6f84

; ------------------------------------------------------------------------------

; [ copy character portrait graphics to vram ]

; +x = pointer to portrait graphics (+$ed1d00)

TfrPortraitGfx:
@7000:  ldy     #$0190
@7003:  lda     f:PortraitGfx,x   ; character portrait graphics
        sta     hVMDATAL
        inx2
        dey
        bne     @7003
        rts

; ------------------------------------------------------------------------------

; [ clear blank portrait graphics ]

; for party select menu

ClearPortraitGfx:
@7010:  ldx     #$9f51
        stx     hWMADDL
        ldx     #$0190
@7019:  stz     hWMDATA
        stz     hWMDATA
        dex
        bne     @7019
        rts

; ------------------------------------------------------------------------------
