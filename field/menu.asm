
; +----------------------------------------------------------------------------+
; |                                                                            |
; |                            FINAL FANTASY VI                                |
; |                                                                            |
; +----------------------------------------------------------------------------+
; | file: menu.asm                                                             |
; |                                                                            |
; | description: menu routines                                                 |
; |                                                                            |
; | created: 9/23/2022                                                         |
; +----------------------------------------------------------------------------+

; ------------------------------------------------------------------------------

; [ load saved game ]

RestartGame:
@c4b3:  ldx     $00
        txy
        tdc
@c4b7:  lda     $1600,y
        sta     $7ff1c0,x
        lda     $1608,y
        sta     $7ff1d0,x
        lda     $1611,y
        sta     $7ff1e0,x
        lda     $1612,y
        sta     $7ff1f0,x
        lda     $1613,y
        sta     $7ff200,x
        longac
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        bne     @c4b7
        jsr     PushDP
        phb
        phd
        php
        jsl     LoadSavedGame_ext
        plp
        pld
        plb
        jsr     PopDP
        jsr     PopPartyMap
        tdc
        lda     $0205
        jne     JmpReset
        ldx     $00
        txy
@c509:  lda     $1600,y
        cmp     $7ff1c0,x
        jne     @c54b
        phx
        lda     $1608,y
        dec
        sta     $20
        stz     $21
        lda     $7ff1d0,x
        sta     $1608,y
        dec
        sta     $22
        stz     $23
        jsr     UpdateMaxHP
        jsr     UpdateMaxMP
        plx
        lda     $7ff1e0,x
        sta     $1611,y
        lda     $7ff1f0,x
        sta     $1612,y
        lda     $7ff200,x
        sta     $1613,y
        phx
        jsr     UpdateAbilities
        plx
@c54b:  longac
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        jne     @c509
        jsr     UpdateEquip
        rts

; ------------------------------------------------------------------------------

; [ update character max hp ]

; +$20 = previous level
; +$22 = new level

UpdateMaxHP:
@c562:  longa
        lda     $160b,y
        and     #$3fff
        sta     $1e                     ; +$1e = max hp
        shorta0
        ldx     $20
@c571:  cpx     $22                     ; branch if not at target level
        beq     @c587
        lda     f:LevelUpHP,x
        clc
        adc     $1e                     ; add to max hp
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @c571
@c587:  ldx     #$270f                  ; 9999 maximum
        cpx     $1e
        bcs     @c590
        stx     $1e
@c590:  longa
        lda     $1e
        sta     $160b,y                 ; set new max hp
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ update character max mp ]

; +$20 = previous level
; +$22 = new level

UpdateMaxMP:
@c59b:  longa
        lda     $160f,y
        and     #$3fff
        sta     $1e                     ; +$1e = max mp
        shorta0
        ldx     $20
@c5aa:  cpx     $22                     ; branch if not at target level
        beq     @c5c0
        lda     f:LevelUpMP,x           ; mp progression value
        clc
        adc     $1e                     ; add to max mp
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     @c5aa
@c5c0:  ldx     #$03e7                  ; 999 maximum
        cpx     $1e
        bcs     @c5c9
        stx     $1e
@c5c9:  longa
        lda     $1e
        sta     $160f,y                 ; set new max mp
        shorta0
        rts

; ------------------------------------------------------------------------------

; [ check main menu ]

CheckMenu:
@c5d4:  lda     $59                     ; return if menu is already opening
        bne     @c62a
        lda     $06                     ; return if x button not down
        and     #$40
        beq     @c62a
        lda     $56                     ; return if battle enabled
        bne     @c62a
        lda     $84                     ; return map load enabled
        bne     @c62a
        lda     $4a                     ; return if fading in/out
        bne     @c62a
        lda     $055e                   ; return if parties switching ???
        bne     @c62a
        ldx     $e5                     ; return if an event is running
        cpx     #$0000
        bne     @c62a
        lda     $e7
        cmp     #$ca
        bne     @c62a
        ldy     $0803                   ; party object
        lda     $087e,y                 ; return if moving
        bne     @c62a
        lda     $0869,y                 ; return if between tiles
        bne     @c62a
        lda     $086a,y
        and     #$0f
        bne     @c62a
        lda     $086c,y
        bne     @c62a
        lda     $086d,y
        and     #$0f
        bne     @c62a
        lda     $1eb8                   ; return if main menu is disabled
        and     #$04
        bne     @c62a
        lda     #1                      ; open menu
        sta     $59
        jsr     FadeOut
@c62a:  rts

; ------------------------------------------------------------------------------

; [ open main menu ]

OpenMainMenu:
@c62b:  lda     $4a                     ; return if still fading out
        bne     @c633
        lda     $59                     ; return if not opening menu
        bne     @c636
@c633:  jmp     MainMenuReturn
@c636:  stz     $59                     ; disable menu
        lda     #$00                    ; set menu mode to main menu
        sta     $0200
        lda     $1eb7                   ; on a save point
        and     #$80
        sta     $1a
        lda     $0521                   ; warp/x-zone enable
        and     #$03
        ora     $1a
        sta     $0201                   ; set menu flags
        jsr     OpenMenu
        lda     $0205
        cmp     #$02
        beq     @c65f                   ; branch if a tent was used
        cmp     #$03
        beq     @c670                   ; branch if warp/warp stone was used
        jmp     FieldMain               ; return to main code loop and fade in
@c65f:  ldx     #$0034                  ; $ca0034 (tent)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
        bra     @c67f
@c670:  ldx     #$0039                  ; $ca0039 (warp/warp stone)
        stx     $e5
        stx     $05f4
        lda     #$ca
        sta     $e7
        sta     $05f6
@c67f:  ldy     $0803                   ; party object
        lda     $087c,y                 ; set movement type to talking/interacting
        and     #$f0
        ora     #$04
        sta     $087c,y
        ldx     #$0000                  ; clear event stack
        stx     $0594
        lda     #$ca
        sta     $0596
        lda     #$01
        sta     $05c7
        ldx     #$0003
        stx     $e8
        ldy     $da                     ; current object
        lda     $087c,y                 ; save movement type
        sta     $087d,y
        lda     #$04                    ; set movement type to talking/interacting
        sta     $087c,y
        stz     $58                     ; load new map
        jmp     FieldMain               ; return to main code loop and fade in

; ------------------------------------------------------------------------------

; [ optimize character's equipment ]

OptimizeCharEquip:
@c6b3:  jsr     PushCharFlags
        jsr     PushDP
        php
        phb
        phd
        jsl     OptimizeCharEquip_ext
        pld
        plb
        plp
        jsr     PopDP
        jsr     PopCharFlags
        rts

; ------------------------------------------------------------------------------

; [ open menu ]

OpenMenu:
@c6ca:  jsr     DisableInterrupts
        jsr     PushCharFlags
        jsr     PushPartyPal
        jsr     PushPartyMap
        jsr     PushDP
        ldx     $0541                   ; save scroll position
        stx     $1f66
        ldx     a:$00af                   ; save party position
        stx     $1fc0
        ldx     $0803                   ; save pointer to party object data
        stx     $1fa6
        lda     $087f,x                 ; save facing direction
        sta     $1f68
        lda     $b2                     ; save z-level
        sta     $0744
        php
        phb
        phd
        jsl     OpenMenu_ext
        pld
        plb
        plp
        jsr     DisableInterrupts
        jsr     PopDP
        jsr     PopCharFlags
        jsr     PopPartyMap
        lda     $1d4e                   ; update wallpaper index
        and     #$07
        sta     $0565
        lda     #$01                    ; reload the same map
        sta     $58
        lda     #$80                    ; enable map startup event
        sta     $11fa
        jsr     InitInterrupts
        stz     $4c                     ; clear screen brightness
        rts

; ------------------------------------------------------------------------------
