
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

.a8
.i16
.segment "field_code"

; ------------------------------------------------------------------------------

; [ load saved game ]

.proc RestartGame
        ldx     $00
        txy
        clr_a
Loop1:  lda     $1600,y
        sta     $7ff1c0,x
        lda     $1608,y
        sta     $7ff1d0,x
        lda     $1611,y
        sta     $7ff1e0,x
        lda     $1612,y
        sta     $7ff1f0,x
        lda     $1613,y
        sta     $7ff200,x
        longa_clc
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        bne     Loop1
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
        clr_a
        lda     $0205
        jne     JmpReset
        ldx     $00
        txy
Loop2:  lda     $1600,y
        cmp     $7ff1c0,x
        jne     Skip
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
Skip:   longa_clc
        tya
        adc     #$0025
        tay
        shorta0
        inx
        cpx     #$0010
        jne     Loop2
        jsr     UpdateEquip
        rts
.endproc  ; RestartGame

; ------------------------------------------------------------------------------

; [ update character max hp ]

; +$20 = previous level
; +$22 = new level

.proc UpdateMaxHP
        longa
        lda     $160b,y
        and     #$3fff
        sta     $1e                     ; +$1e = max hp
        shorta0
        ldx     $20
Loop:   cpx     $22                     ; branch if at target level
        beq     Done
        lda     f:LevelUpHP,x
        clc
        adc     $1e                     ; add to max hp
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     Loop
Done:   ldx     #9999
        cpx     $1e
        bcs     :+
        stx     $1e
:       longa
        lda     $1e
        sta     $160b,y                 ; set new max hp
        shorta0
        rts
.endproc  ; UpdateMaxHP

; ------------------------------------------------------------------------------

; [ update character max mp ]

; +$20 = previous level
; +$22 = new level

.proc UpdateMaxMP
        longa
        lda     $160f,y
        and     #$3fff
        sta     $1e                     ; +$1e = max mp
        shorta0
        ldx     $20
Loop:   cpx     $22                     ; branch if at target level
        beq     Done
        lda     f:LevelUpMP,x           ; mp progression value
        clc
        adc     $1e                     ; add to max mp
        sta     $1e
        lda     $1f
        adc     #$00
        sta     $1f
        inx
        bra     Loop
Done:   ldx     #999
        cpx     $1e
        bcs     :+
        stx     $1e
:       longa
        lda     $1e
        sta     $160f,y                 ; set new max mp
        shorta0
        rts
.endproc  ; UpdateMaxMP

; ------------------------------------------------------------------------------

; [ check main menu ]

.proc CheckMenu
        lda     $59                     ; return if menu is already opening
        bne     Done
        lda     $06                     ; return if x button not down
        and     #$40
        beq     Done
        lda     $56                     ; return if battle enabled
        bne     Done
        lda     $84                     ; return map load enabled
        bne     Done
        lda     $4a                     ; return if fading in/out
        bne     Done
        lda     $055e                   ; return if parties switching ???
        bne     Done
        ldx     $e5                     ; return if an event is running
        cpx     #.loword(EventScript_NoEvent)
        bne     Done
        lda     $e7
        cmp     #^EventScript_NoEvent
        bne     Done
        ldy     $0803                   ; party object
        lda     $087e,y                 ; return if moving
        bne     Done
        lda     $0869,y                 ; return if between tiles
        bne     Done
        lda     $086a,y
        and     #$0f
        bne     Done
        lda     $086c,y
        bne     Done
        lda     $086d,y
        and     #$0f
        bne     Done
        lda     $1eb8                   ; return if main menu is disabled
        and     #$04
        bne     Done
        lda     #1                      ; open menu
        sta     $59
        jsr     FadeOut
Done:   rts
.endproc  ; CheckMenu

; ------------------------------------------------------------------------------

; [ open main menu ]

.import EventScript_Tent, EventScript_Warp

.proc OpenMainMenu
        lda     $4a                     ; return if still fading out
        bne     Done
        lda     $59                     ; return if not opening menu
        bne     :+
Done:   jmp     MainMenuRet
:       stz     $59                     ; disable menu
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
        beq     Tent                    ; branch if a tent was used
        cmp     #$03
        beq     Warp                    ; branch if warp/warp stone was used
        jmp     FieldMain               ; return to main code loop and fade in

Tent:   ldx     #.loword(EventScript_Tent)
        stx     $e5
        stx     $05f4
        lda     #^EventScript_Tent
        sta     $e7
        sta     $05f6
        bra     :+

Warp:   ldx     #.loword(EventScript_Warp)
        stx     $e5
        stx     $05f4
        lda     #^EventScript_Warp
        sta     $e7
        sta     $05f6
:       ldy     $0803                   ; party object
        lda     $087c,y                 ; set movement type to talking/interacting
        and     #$f0
        ora     #$04
        sta     $087c,y
        ldx     #.loword(EventScript_NoEvent)
        stx     $0594
        lda     #^EventScript_NoEvent
        sta     $0596
        lda     #1
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
.endproc  ; OpenMainMenu

; ------------------------------------------------------------------------------

; [ optimize character's equipment ]

.proc OptimizeCharEquip
        jsr     PushCharFlags
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
.endproc  ; OptimizeCharEquip

; ------------------------------------------------------------------------------

; [ open menu ]

.proc OpenMenu
        jsr     DisableInterrupts
        jsr     PushCharFlags
        jsr     PushPartyPal
        jsr     PushPartyMap
        jsr     PushDP
        ldx     $0541                   ; save scroll position
        stx     $1f66
        ldx     a:$00af                 ; save party position
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
.endproc  ; OpenMenu

; ------------------------------------------------------------------------------
