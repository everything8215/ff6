; ------------------------------------------------------------------------------

; [ battle graphics ]

ExecBtlGfx_ext:
@0000:  pha
        clr_a
        pla
        asl
        tax
        jmp     (near BtlGfxTbl,x)

; ------------------------------------------------------------------------------

; battle graphics command jump table
BtlGfxTbl:
        ptr_tbl BTL_GFX

; ------------------------------------------------------------------------------

; [ battle graphics command $0d: get position in menu queue ]

; $10 = character slot

        array_label BTL_GFX, BTL_GFX::GET_MENU_QUEUE_POS
@0024:  lda     $10
        and     #%11
        tax
        lda     near wMenuQueue,x
        rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $0c: scroll bg for final battle ]

        array_label BTL_GFX, BTL_GFX::FINAL_BATTLE_SCROLL
; last_init:
@002d:  lda     near w7eecb8
        cmp     #$35
        bne     @004b
        inc     near wSfxDisabled       ; disable sound effects
        lda     #$81
        sta     $1300
        lda     #$80
        sta     $1301
        stz     $1302
        jsl     ExecSound_ext
        stz     near wSfxDisabled       ; enable sound effects
@004b:  lda     #$80
        sta     near w7e6285
        inc     near w7ee9ef       ; stop battle time
        inc     near wPauseNotAllowed       ; disable pause
        inc     near w7e629a
        jsr     _c10105       ; force close all battle menus
        jsl     SaveCursorMem
        jsr     _c1926b
        clr_a
        jsr     _c1925e
        jsr     _c191dc
        clr_ax
@006c:  stz     near w7e6178,x
        inx
        cpx     #$00be
        bne     @006c
        rtl

; ------------------------------------------------------------------------------

; [ init graphics for next part of final battle ]

_c10076:
last_init2:
@0076:  jsr     _c10fe0
        jsr     _c10fb6
        stz     near w7ee9ef       ; start battle time
        jsr     _c10df3
        inc     near w7ee9ef       ; stop battle time
        jsr     _c10e67
        jsr     InitCharMenuOrder
        jsr     InitMenuText
        jsr     InitCharGfxFinalBattle
        jsr     LoadStatusPal
        jsr     _c1468f
        jsr     InitMenuText
        jsr     TfrTopMenuTiles
        inc     near wEnableUpdateMenuWindowTiles       ; enable battle menu update
        jsr     _c10f8f       ; check if characters can change equipment
        jsr     UpdateDrawOrder
        jsl     LoadCursorMem
        rts

; ------------------------------------------------------------------------------

; [ battle graphics command $0a: update inventory with obtained items ]

        array_label BTL_GFX, BTL_GFX::UPDATE_INVENTORY
@00ab:  jsr     _c14445       ; update inventory with obtained items
        rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $09: fade out & terminate battle ]

        array_label BTL_GFX, BTL_GFX::TERMINATE_BATTLE
@00af:  lda     near w7e2f4b
        bmi     @00bb
        lda     $11e4
        and     #$08
        beq     @00c0       ; branch if not continuing current music
@00bb:  lda     near w7e6284
        beq     @00d7
@00c0:  inc     near wSfxDisabled       ; disable sound effects
        lda     #$81
        sta     $1300
        lda     #$10
        sta     $1301
        stz     $1302
        jsl     ExecSound_ext
        stz     near wSfxDisabled       ; enable sound effects
@00d7:  lda     near w7ee9f9
        beq     @00e6
@00dc:  lda     #1
        jsr     WaitA       ; wait 1 frame
        dec     near w7ee9f9
        bne     @00dc
@00e6:  jsl     SaveCursorMem
        clr_a
        pha
        plb
        stz     hNMITIMEN
        stz     hMDMAEN
        stz     hHDMAEN
        lda     #$80
        sta     hINIDISP
        lda     #$6b                    ; rtl (should be rti)
        sta     $1500
        sta     $1504
        sei
        rtl

; ------------------------------------------------------------------------------

; [ force close all battle menus ]

_c10105:
win_all_close_wait:
@0105:  ldx     #$ffff      ; close all battle menus
        stx     near wMenuQueue
        stx     near wMenuQueue + 2
        jsr     WaitFrame
        lda     near wMenuIsOpen       ; branch if menu is still open
        bne     @0105
        rts

; ------------------------------------------------------------------------------

; [ battle graphics command $08: victory animation ]

        array_label BTL_GFX, BTL_GFX::VICTORY
@0117:  inc     near wPauseNotAllowed       ; disable pause
        inc     near w7e629a
        jsr     _c10105       ; force close all battle menus
        jsl     UpdateMonsterNames
        lda     near w7e2f49
        and     #$02
        bne     @016a       ; return if fanfare is disabled
        clr_ax
@012d:  lda     f:_c1016b,x   ; copy to battle script command queue
        sta     near w7e2d6e,x
        inx
        cpx     #5
        bne     @012d
        jsr     WaitFrame
        jsr     WaitFrame
        lda     $11e4
        and     #$08
        bne     @0163       ; branch if continuing music from map
        inc     near wSfxDisabled       ; disable sound effects
        inc     near w7e6284
        lda     #$10
        sta     $1300
        lda     #SONG::VICTORY_FANFARE
        sta     $1301
        lda     #$ff
        sta     $1302
        jsl     ExecSound_ext
        stz     near wSfxDisabled       ; enable sound effects
@0163:  inc     near w7e628d
        jsl     array_item BTL_GFX, BTL_GFX::GFX_SCRIPT
@016a:  rtl

; ------------------------------------------------------------------------------

; battle script command $0f/01: execute battle event 1 (victory)
_c1016b:
@016b:  .byte   GFX_CMD::BATTLE_EVENT
        .byte   BATTLE_EVENT_SCRIPT::VICTORY_FANFARE
        .byte   0
        .byte   0

        .byte   GFX_CMD::TERMINATE

; ------------------------------------------------------------------------------

; [ battle graphics command $07: nothing ]

        array_label BTL_GFX, BTL_GFX::BTL_GFX_7
@0170:  rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $0b:  ]

        array_label BTL_GFX, BTL_GFX::BTL_GFX_11
@0171:  lda     near wMenuIsOpen               ; return if menu is not open
        beq     @0186
        lda     $10
        cmp     near w7e62ca
        bne     @0186
        jsr     TfrTopMenuTiles
        jsr     _c147ac
        inc     near wEnableUpdateMenuWindowTiles       ; enable menu window update
@0186:  rtl

; ------------------------------------------------------------------------------

; [ redraw top menu ]

; called after characters are added or removed from the party

RedrawTopMenu:
        jsr     DrawMonsterNames
        jsr     TfrTopMenuTiles
        inc     near wEnableUpdateMenuWindowTiles
        jsr     WaitFrame
        jsr     CopyMonsterNameBuffer
        rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $06: update monster names ]

UpdateMonsterNames:
        array_label BTL_GFX, BTL_GFX::UPDATE_MONSTER_NAMES
@0197:  clr_ax
@0199:  lda     near w7e200d,x     ; compare monster name data to buffer
        cmp     near w7eebff,x
        bne     @01a8
        inx
        cpx     #$0010
        bne     @0199
        rtl
@01a8:  lda     near wMenuIsOpen       ; return if menu is open
        bne     @01bc
        jsr     DrawMonsterNames
        jsr     TfrTopMenuTiles
        inc     near wEnableUpdateMenuWindowTiles       ; enable battle menu update
        jsr     WaitFrame
        jsr     CopyMonsterNameBuffer
@01bc:  rtl

; ------------------------------------------------------------------------------

; [ copy monster name data from buffer ]

CopyMonsterNameBuffer:
@01bd:  clr_ax
@01bf:  lda     near w7e200d,x
        sta     near w7eebff,x
        inx
        cpx     #$0010
        bne     @01bf
        rts

; ------------------------------------------------------------------------------

; [ battle graphics command $05: add item obtained in battle ]

        array_label BTL_GFX, BTL_GFX::GIVE_ITEM
@01cc:  lda     near w7e64da       ; next available slot for item obtained in battle
        and     #%1111
        sta     $10
        asl2
        clc
        adc     $10
        tax
        clr_ay
@01db:  lda     near wItemPropBuf,y     ; copy item data to items obtained in battle (5 bytes)
        sta     near w7e602d,x
        inx
        iny
        cpy     #sizeof_wItemPropBuf
        bne     @01db
        inc     near w7e64da       ; increment number of items obtained in battle
        rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $00: init battle graphics ]

        array_label BTL_GFX, BTL_GFX::INIT
@01ec:  jsl     InitHWRegs
        jsr     InitBattleGfx
        jsl     array_item BTL_GFX, BTL_GFX::WAIT_FRAME
        jsr     UpdateDrawOrder         ; probably redundant
        rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $01: wait one frame ]

; called from main battle loop, and 4 times after each attack animation

        array_label BTL_GFX, BTL_GFX::WAIT_FRAME
@01fb:  phx
        phy
        jsr     WaitVblank
        jsr     _c10df3       ; update hp/mp/status buffers (for graphics)
        jsr     UpdateMenuWindow
        jsr     UpdateStatusChangeAnim
        jsr     CheckMenuReady
        jsr     UpdateCharText
        jsl     UpdateCondemnNum
        jsr     MonsterDeathAnim
        jsl     UpdateFacingDir
        lda     near w7ee9ef
        bne     @0223       ; branch if battle time is stopped
        jsl     UpdateBattleTime_ext
@0223:  ply
        plx
        rtl

; ------------------------------------------------------------------------------

; [ wait for vblank (long access) ]

WaitFrame_far:
@0226:  jsr     WaitFrame
        rtl

; ------------------------------------------------------------------------------

; [ wait one frame ]

; called from graphics bank, used during animations
; this version does not update the buffers for character hp/mp/status

WaitFrame:
@022a:  phx
        phy
        jsr     WaitVblank
        jsr     UpdateMenuWindow
        jsr     CheckMenuReady
        jsr     UpdateCharText
        jsl     UpdateCondemnNum
        jsl     UpdateFacingDir
        lda     near w7ee9ef
        bne     @0249       ; branch if battle time is stopped
        jsl     UpdateBattleTime_ext
@0249:  ply
        plx
        rts

; ------------------------------------------------------------------------------

; [ battle graphics command $03: close battle menu ]

; $10: character slot

        array_label BTL_GFX, BTL_GFX::CLOSE_MENU
@024c:  lda     $10
        and     #%11
        tax
        lda     #$ff
        sta     near wMenuQueue,x
        rtl

; ------------------------------------------------------------------------------

; [ battle graphics command $02: open battle menu ]

; adds a character to the menu queue
; $10: m-----cc
;        m: set if character is controlling a monster
;        c: character number

        array_label BTL_GFX, BTL_GFX::OPEN_MENU
@0257:  lda     near w7e628b       ; return if menu is not allowed to open
        bne     @0285
        lda     $10
        asl
        rol
        and     #1
        sta     $12
        lda     $10
        and     #3
        tax
        lda     $12
        sta     near w7e62cc,x     ; character is controlling a monster
        lda     near wMenuQueue,x
        cmp     #$ff
        bne     @0285       ; return if character is already in the menu queue
        txa
        sta     near wMenuQueueIndex
        jsr     UpdateMenuQueue
        lda     near wMenuQueueIndex
        tax
        lda     #3
        sta     near wMenuQueue,x     ; put character in the back of the menu queue
@0285:  rtl

; ------------------------------------------------------------------------------

; [ update battle menu queue ]

; moves characters up to the frontmost empty slot in the queue

UpdateMenuQueue:
@0286:  clr_ax
        stz     $10
        stz     $12
@028c:  jsr     UpdateMenuQueueSlot
        bcc     @0293       ; branch if slot empty
        inc     $12
@0293:  inc     $10         ; next slot
        lda     $10
        cmp     #5
        bne     @028c
        lda     $12         ; first empty slot
        sta     $10
@029f:  lda     $10
        cmp     #5
        beq     @02b1
        lda     #$ff
        sta     $12
        jsr     UpdateMenuQueueSlot
        inc     $10
        jmp     @029f
@02b1:  rts

; ------------------------------------------------------------------------------

; [ update menu order slot ]

; $10 = position in menu order to find
; $12 = new menu order to set
; carry clear = slot was empty, carry set = slot was found

UpdateMenuQueueSlot:
@02b2:  clr_ax
@02b4:  lda     near wMenuQueue,x     ; character position in menu queue
        cmp     $10
        beq     @02c3
        inx
        cpx     #4
        bne     @02b4
        clc
        rts
@02c3:  lda     $12
        sta     near wMenuQueue,x
        sec
        rts

; ------------------------------------------------------------------------------

; [ update battle menu ]

; called every frame after vblank
; checks if a character's menu is ready to open

CheckMenuReady:
@02ca:  jsr     UpdateMenuQueue
        clr_ax
@02cf:  lda     near wMenuQueue,x               ; character position in menu queue
        beq     @02dc                   ; branch if at top of queue
        inx                             ; next character
        cpx     #4
        bne     @02cf
        bra     @02f9                   ; return if no character was at the top of the queue
@02dc:  lda     near w7ee9f1                 ; return if menu is not ready to open yet
        ora     near wMenuWindowState
        ora     near w7e628b
        ora     near wMenuIsOpen
        ora     near wEnableUpdateMenuWindowTiles
        ora     near w7e7bcc
        bne     @02f9
        stz     near wCloseMenu              ; un-close menu (allow to open)
        stx     near w7e62ca                 ; set active character
        jsr     OpenMenu
@02f9:  rts

; ------------------------------------------------------------------------------
