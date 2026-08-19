; ------------------------------------------------------------------------------

; [ battle animation command $80/$85: load chadarnook battle bg palette ]

; 0: lights on
; 1: lights off
; 2: 1/8 chance to do lights off, otherwise do nothing

AnimCmd_00_85_far:
@af21:  ldy     zAnimScriptPtr
        iny
        sty     zAnimScriptPtr
        lda     [zAnimScriptPtr]
        beq     @af4b
        cmp     #1
        beq     @af35
        jsr     Rand_near
        and     #$07
        bne     @af4a

; load lights off palette
@af35:  longa
        clr_ax
@af39:  lda     f:ChadarnookBGPalLightsOff,x
        sta     near w7e7e00::_5,x
        inx2
        cpx     #$0060
        bne     @af39
        shorta0
@af4a:  rtl

; load lights on palette
@af4b:  longa
        clr_ax
@af4f:  lda     f:ChadarnookBGPalLightsOn,x
        sta     near w7e7e00::_5,x
        inx2
        cpx     #$0060
        bne     @af4f
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$83:  ]

; save monster position during chadarnook entry

AnimCmd_00_83_far:
        clr_ax
@af63:  stz     near w7e8057,x     ; clear monster y-shift for sprite priority
        inx
        cpx     #$000c
        bne     @af63
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bpl     @af96       ; return if a character
        and     #$0f
        sec
        sbc     #$04
        asl
        tax
        longa
        lda     #near -8
        sta     near w7e8057,x     ; set monster y-shift to -8
        lda     near w7e80cf,x     ; monster y position (top)
        sta     near w7eecb4       ;
        sec
        sbc     #$0100
        sta     near w7e80cf,x
        stx     near w7eecb6       ;
        shorta0
@af96:  rtl

; ------------------------------------------------------------------------------

; high sprite data
_c2af97:
@af97:  .byte   $02,$08,$20,$80
        .byte   $03,$0c,$30,$c0
        .byte   $01,$04,$10,$40

; ------------------------------------------------------------------------------

; [ init high sprite data ]

_c2afa3:
oam_hibit_init:
@afa3:  clr_ay
        stz     $10
@afa7:  lda     $10
        lsr2
        sta     near w7ea17f,y
        sta     near w7ea17f+1,y
        sta     near w7ea17f+2,y
        sta     near w7ea17f+3,y
        lda     $10
        and     #$03
        tax
        lda     f:_c2af97,x
        sta     near w7ea37f,y
        sta     near w7ea37f+1,y
        sta     near w7ea37f+2,y
        sta     near w7ea37f+3,y
        lda     f:_c2af97+4,x
        sta     near w7ea57f,y
        sta     near w7ea57f+1,y
        sta     near w7ea57f+2,y
        sta     near w7ea57f+3,y
        lda     f:_c2af97+8,x
        sta     near w7ea77f,y
        sta     near w7ea77f+1,y
        sta     near w7ea77f+2,y
        sta     near w7ea77f+3,y
        inc     $10
        iny4
        cpy     #$0200
        bne     @afa7
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$72: branch if attack didn't miss ]

AnimCmd_00_72_far:
        ldx     zAnimScriptPtr
        inx
        stx     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::w7e6f88,x     ; branch if attack didn't miss
        bpl     @b006
        rtl
@b006:  lda     [zAnimScriptPtr]
        longa
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        shorta0
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$74: branch if character needs to step back ]

; unused, identical to command $db

AnimCmd_00_74_far:
        ldx     near wAnimThreadPtr
        lda     near wAnimThread::TargetIndex,x     ; target
        bmi     @b025       ; branch if a monster
        tay
        lda     near w7e61ae,y     ;
        beq     @b038
@b025:  ldy     #1
        lda     [zAnimScriptPtr],y
        longa
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        shorta0
@b038:  ldx     zAnimScriptPtr
        inx
        stx     zAnimScriptPtr
        rtl

; ------------------------------------------------------------------------------

; [ battle animation command $80/$7d: branch if dragon horn is active ]

AnimCmd_00_7d_far:
        ldx     zAnimScriptPtr
        inx
        stx     zAnimScriptPtr
        ldx     near wAnimThreadPtr
        lda     near wDragonHornActive
        bne     @b04c
        rtl
@b04c:  lda     [zAnimScriptPtr]
        longa
        sta     $22
        lda     zAnimScriptPtr
        clc
        adc     $22
        sta     zAnimScriptPtr
        shorta0
        rtl

; ------------------------------------------------------------------------------

; monster death animation palette
MonsterDeathPal:
@b05d:  .word   $318c,$0401,$7c1f,$741d,$6419,$5c17,$5415,$4c13
        .word   $4411,$3c0f,$340d,$2c0b,$2409,$1c07,$1405,$0c03

; ------------------------------------------------------------------------------

; block/shield palettes (8 colors each)
BlockPal:
@b07d:  .word   $0000,$0000,$001a,$0013,$000d,$7ffe,$0380,$01c0  ; cape
        .word   $0000,$0000,$7ffe,$373a,$2295,$1d8b,$28f2,$186e  ; shield, golem
        .word   $0000,$0000,$7ffe,$6737,$4a71,$2989,$2ef8,$098f  ; knife, sword
        .word   $35ad,$0c63,$6fff,$2108,$31f8,$2926,$18c6,$0172  ; dog

; ------------------------------------------------------------------------------

; unused
@b0bd:  .byte   $02,$04,$06,$08,$0a,$0c,$0e,$10

; ------------------------------------------------------------------------------
