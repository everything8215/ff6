; ------------------------------------------------------------------------------

; [ battle ]

BattleMain:
@000c:  php
        shortai
        lda     #$7e
        pha
        plb
        jsr     InitRAM

RestartBattle:
@0016:  jsr     InitBattle

; start of main battle loop
BattleLoop:
@0019:  inc     zbe                     ; increment random number
        lda     near w7e3402                   ; decrement quick counter
        bne     @0023
        dec     near w7e3402
@0023:  lda     #BTL_GFX::WAIT_FRAME
        jsr     ExecBtlGfx
        jsr     UpdateCharProp
        lda     near w7e3a58                   ; branch if no menus need to be updated
        beq     @0033
        jsr     _c200cc
@0033:  lda     near w7e340a                   ; immediate action
        cmp     #$ff
        jne     _c22163                   ; execute immediate action
        lda     #$04
        trb     near w7e3a46
        beq     @0049                   ; branch if gau just appeared ($3a46.2)
        jsr     ResetForVeldtGau
        bra     @0019

; retaliation action
@0049:  ldx     near w7e3407                   ; current counterattacker
        bpl     @005f
@004e:  ldx     near w7e3a68                   ; counterattack queue pointer
        cpx     near w7e3a69
        beq     @0062
        inc     near w7e3a68
        lda     near w7e3920,x                 ; counterattack queue
        bmi     @004e                   ; continue if empty
        tax
@005f:  jmp     ExecRetal

;
@0062:  lda     near w7e3a3a
        and     near w7e2f2f
        beq     @006f
        trb     near w7e2f2f
        bra     @0019
@006f:  lda     #$20
        trb     zb0
        beq     @007d
        jsr     UpdateMonsterGfxBuf
        lda     #BTL_GFX::UPDATE_MONSTER_NAMES
        jsr     ExecBtlGfx
@007d:  lda     #$04
        trb     zb0
        jsr     CheckBattleEnd
        lda     #$ff
        ldx     #3
@0088:  sta     near w7e33fc,x                 ; reset target retaliation flags
        dex
        bpl     @0088
        lda     #$01                    ; clear counterattack flag
        trb     zb1

; advance wait command
@0092:  ldx     near w7e3a64                   ; advance wait queue start
        cpx     near w7e3a65
        beq     @00a6                   ; branch if equal to advance wait queue end
        inc     near w7e3a64                   ; increment advance wait queue start
        lda     near w7e3720,x                 ; get next advance wait queue action
        bmi     @0092                   ; loop if no action
        tax
        jmp     _c22188                   ; execute advance wait action

; normal action
@00a6:  ldx     near w7e3406                   ; currently acting character/monster
        bpl     @00c2                   ; branch if valid
@00ab:  ldx     near w7e3a66                   ; action queue start
        cpx     near w7e3a67                   ; branch if not equal to action queue end
        bne     @00b9
        stz     near w7e3a95                   ; all actions are complete, allow battle to end
        jmp     @0019
@00b9:  inc     near w7e3a66                   ; increment action queue pointer
        lda     near w7e3820,x                 ; action queue
        bmi     @00ab                   ; branch if not a valid action
        tax
@00c2:  jmp     ExecAction

; ------------------------------------------------------------------------------

; [ fade out and terminate battle ]

TerminateBattle:
@00c5:  lda     #BTL_GFX::TERMINATE_BATTLE
        jsr     ExecBtlGfx
        plp
        rtl

; ------------------------------------------------------------------------------

; [ update menus ]

_c200cc:
_commandwrite:
@00cc:  ldx     #$06
@00ce:  lda     near wTargetMask,x     ; character mask
        trb     near w7e3a58       ; disable menu update for character
        beq     @00df       ; skip if menu doesn't need to be updated
        stx     $10
        lsr     $10
        lda     #BTL_GFX::BTL_GFX_11
        jsr     ExecBtlGfx
@00df:  dex2                ; next character
        bpl     @00ce
        rts

; ------------------------------------------------------------------------------
