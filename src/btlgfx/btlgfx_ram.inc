; ------------------------------------------------------------------------------

.if LANG_EN
        BG1_BLANK_CHAR                  = $c8
        ZERO_CHAR                       = $b4
        COLON_CHAR                      = $c1
        TILDE_CHAR                      = $ce
        GAUGE_EMPTY_CHAR                = $f0
        GAUGE_FULL_CHAR                 = $f8
        GAUGE_LEFT_CHAR                 = $f9
        GAUGE_RIGHT_CHAR                = $fa
.else
        GAUGE_EMPTY_CHAR                = $10
        GAUGE_FULL_CHAR                 = $18
        GAUGE_LEFT_CHAR                 = $19
        GAUGE_RIGHT_CHAR                = $1a
        ZERO_CHAR                       = $53
        BG1_BLANK_CHAR                  = $67
        TILDE_CHAR                      = $ce
        COLON_CHAR                      = $cf
.endif

.enum CIRCLE_SHAPE
        CIRCLE
        BIO_BLAST
        BIG_BLOB
        TOP_BEAM
        VERT_OVAL
        SMALL_BLOB
        HORZ_OVAL
        ULTIMA
        SLIMER_BLOB

        COUNT
.endenum

.enum BG_SCROLL_HDMA
        WAVE_FULL_BG1   ; one value per scanline, 224 values (bg1)  WAVE_FULL_BG1
        WAVE_FULL_BG2   ; one value per scanline, 224 values (bg2)  WAVE_FULL_BG2 (never used)
        WAVE_FULL_BG3   ; one value per scanline, 224 values (bg3)  WAVE_FULL_BG3 (never used)
        DEFAULT_BG1   ; single fixed value for battlefield area (bg1 default)  DEFAULT_BG1
        DEFAULT_BG2   ; one value per scanline, repeats every 32 lines (bg2 default)  DEFAULT_BG2
        DEFAULT_BG3   ; single fixed value for battlefield area (bg3 default)  DEFAULT_BG3
        WAVE_32_BG1   ; one value per scanline, repeats every 32 lines (bg1)  WAVE_32_BG1
        WAVE_32_BG3   ; one value per scanline, repeats every 32 lines (bg3)  WAVE_32_BG3
        WAVE_64_BG1   ; one value per scanline, repeats every 64 lines (bg1)  WAVE_64_BG1
        CHUNKY_BG1   ; single value for every 8 scanlines (bg1)  CHUNKY_BG1
        TRAIN_BG2  ; phantom train ext, magitek train (bg2)  TRAIN_BG2
        CYANS_DREAM_BG2  ; cyan's dream (bg2)  CYANS_DREAM_BG2

; bg3 tables when slot window is open
        BG_SCROLL_HDMA_12  ; unused (bg1)
        BG_SCROLL_HDMA_13  ; unused (bg2)
        WAVE_FULL_BG3_SLOT  ; one value per scanline, 224 values (bg3)
        BG_SCROLL_HDMA_15  ; unused (bg1)
        BG_SCROLL_HDMA_16  ; unused (bg2)
        DEFAULT_BG3_SLOT  ; single value for battlefield area (bg3 default)
        BG_SCROLL_HDMA_18  ; unused (bg1)
        WAVE_32_BG3_SLOT  ; one value per scanline, repeats every 32 lines (bg3)
        BG_SCROLL_HDMA_20  ; unused (bg1)
        BG_SCROLL_HDMA_21  ; unused (bg1)
        BG_SCROLL_HDMA_22  ; unused (bg2)
        BG_SCROLL_HDMA_23  ; unused (bg2)

        COUNT
.endenum

; ------------------------------------------------------------------------------

        ram_verbose 0

        ram_org $00

        BTLGFX_ZP_START := _ram_offset

; constant zero
        ram_word zZero
        ram_word z02

; current controller state with repeating buttons (all other input)
        ram_word z04

; current controller state (for L/R scrolling)
        ram_word z06

; controller state for newly pressed buttons (for B button cancel)
        ram_word z08

; unmapped controller state (for blitz input, L+R running)
        ram_word z0a

; previous controller state (never used)
        ram_word z0c

; frame counter (stops when game paused)
        ram_word z0e

; scratchpad RAM
        ram_res 54, zScratch

; NMI status (0: no NMI, 1: NMI in progress, $ff: NMI disabled)
        ram_byte zNMIState

; VBlank state (0: waiting for vblank, 1: vblank complete)
        ram_byte zVBlankState

; pointer to menu text
        ram_word z48

; pointer to menu text tilemap (main row)
        ram_word z4a

; pointer to battle dialogue text
        _ram_offset .set _ram_offset - 4
        ram_faraddr zDlgTextPtr
        ram_byte zUseAltDlgColor

; pointer to menu text tilemap (dakuten row)
        ram_word z4c

; tile flags for menu text
        ram_byte z4e

        ram_word z4f
        ram_word z51
        ram_word z53

; blank tile for no dakuten
        ram_word z55

; dakuten tile (dots)
        ram_word z57

; handakuten tile (circle)
        ram_word z59

; animation script pointer
        ram_faraddr zAnimScriptPtr

        ram_byte z5e
        ram_byte z5f
        ram_byte z60

; pointer to monster graphics buffer
        ram_word z61

; unused
        ram_byte z63

; pointer to monster graphics in ROM
        ram_faraddr z64

        ram_byte z67
        ram_byte z68

; hex->dec conversion result (most significant digits first)
        ram_res 8, z69

        ram_byte z71
        ram_byte z72
        ram_byte z73
        ram_byte z74
        ram_byte z75

        ram_word z76
        ram_word z78
        ram_byte z7a
        ram_byte z7b
        ram_byte z7c

        ram_byte z7d
        ram_byte z7e
        ram_byte z7f
        ram_byte z80
        ram_word z81
        ram_word z83
        ram_byte z85
        ram_word z86
        ram_word z88
        ram_word z8a
        ram_word z8c
        ram_byte z8e

; pointer to battle event script
        ram_faraddr z8f
        ram_byte z92
        ram_byte z93
        ram_byte z94
        ram_byte z95
        ram_byte z96
        ram_byte z97

; frame counter (ignores pause)
        ram_byte z98
        ram_byte z99
        ram_byte z9a
        ram_byte z9b

        .assert _ram_offset <= $a0, error, "Insufficient battle graphics zero-page RAM"
        BTLGFX_ZP_SIZE = _ram_offset

; ------------------------------------------------------------------------------

; battle graphics variables (bank $7e)

        ram_org $7e4000

        ram_byte wMenuQueueIndex
        ram_res 4, wMenuQueue

; filtered item list for tools and throw menu
        ram_array wToolsThrowItemList, 256, 3
                ram_byte ItemID
                ram_byte Qty
                ram_byte Targeting
        end_ram_array

.mac bg_scroll_hdma_res label, num_lines
        ram_array label, num_lines, 4
                ram_word Horz
                ram_word Vert
        end_ram_array
.endmac

; bg scroll hdma data
        bg_scroll_hdma_res wBufferTextScrollData, 60
        bg_scroll_hdma_res wBG1ScrollData, 224
        bg_scroll_hdma_res wBG2ScrollData, 224
        bg_scroll_hdma_res wBG3ScrollData, 224
        bg_scroll_hdma_res wCmdTextScrollData, 64
        bg_scroll_hdma_res wRowDefTextScrollData, 72
        bg_scroll_hdma_res wCharStatusTextScrollData, 80
        bg_scroll_hdma_res wListTextScrollData, 128
        bg_scroll_hdma_res wGenjuTextScrollData, 40
        bg_scroll_hdma_res wEquipTextScrollData, 48
        bg_scroll_hdma_res w7e5535, 40  ; unused ???

        ram_res 256, w7e55d5
        ram_res 64, w7e56d5
        ram_res 64, w7e5715
        ram_res 128, w7e5755
        ram_res 128, w7e57d5

; text buffers (2 bytes per tile, 2 rows, upper row is for dakuten)
        ram_res 640, w7e5855            ; 32x10 tile buffer for menu text
        ram_res 4 * 48, w7e5ad5         ; monster names
        ram_res 4 * 28, w7e5b95         ; character names
        ram_res 4 * 16, w7e5c05         ; character hp text buffer
        ram_res 4 * 24, w7e5c45         ; gauge text buffer
        ram_res 4 * 28, w7e5ca5         ; character mp text buffer
        ram_res 14, w7e5d15             ; curr/max mp text buffer
        ram_res 14, w7e5d23             ; mp cost text buffer
        ram_res 14 * 5, w7e5d31         ; row text buffer
        ram_res 14 * 5, w7e5d77         ; def. text buffer
        ram_res 24 * 6, w7e5dbd         ; swdtech numerals and gauge text buffer
        ram_res 32 * 4, w7e5e4d         ; menu list text buffer
        .if LANG_EN
        ram_res 20 * 8, w7e5ecd         ; status names text buffer
        .else
        ram_res 14 * 8, w7e5ecd         ; status names text buffer
        .endif

; tornado data
        ram_res 16, w7e5f6d
        ram_res 16, w7e5f7d
        ram_res 16, w7e5f8d
        ram_res 16, w7e5f9d

; offset-per-tile data for slot menu (32 16-bit values)
        ram_scope wOffsetPerTile
                ram_res 64, H   ; horizontal: always zero
                ram_res 64, V   ; vertical: changes as slot reels turn
        end_ram_scope

        ram_res 16 * 5, w7e602d

        ram_byte w7e607d
        ram_byte w7e607e
        ram_byte w7e607f
        ram_byte w7e6080
        ram_byte w7e6081
        ram_byte w7e6082
        ram_byte w7e6083
        ram_byte w7e6084
        ram_res 16, w7e6085
        ram_byte w7e6095
        ram_byte w7e6096
        ram_byte w7e6097
        ram_byte w7e6098
        ram_byte w7e6099
        ram_byte w7e609a
        ram_byte w7e609b
        ram_byte w7e609c
        ram_byte w7e609d
        ram_byte w7e609e
        ram_byte w7e609f
        ram_byte w7e60a0
        ram_byte w7e60a1
        ram_byte w7e60a2
        ram_byte w7e60a3
        ram_byte w7e60a4
        ram_byte w7e60a5
        ram_byte w7e60a6
        ram_byte w7e60a7
        ram_byte w7e60a8
        ram_byte w7e60a9
        ram_byte w7e60aa
        ram_byte w7e60ab
        ram_byte w7e60ac
        ram_byte w7e60ad
        ram_byte w7e60ae
        ram_byte w7e60af
        ram_byte w7e60b0
        ram_byte w7e60b1
        ram_byte w7e60b2
        ram_res 128, w7e60b3
        ram_res 10, w7e6133
        ram_byte wAnimCharTargets
        ram_byte wAnimMonsterTargets
        ram_byte w7e613f
        ram_byte w7e6140
        ram_byte w7e6141
        ram_res 10, w7e6142
        ram_byte w7e614c
        ram_byte w7e614d
        ram_byte w7e614e
        ram_byte w7e614f
        ram_byte w7e6150
        ram_byte w7e6151
        ram_byte w7e6152
        ram_byte w7e6153
        ram_byte w7e6154
        ram_byte w7e6155
        ram_byte w7e6156
        ram_byte w7e6157
        ram_byte w7e6158
        ram_byte w7e6159
        ram_byte w7e615a
        ram_byte w7e615b
        ram_byte w7e615c
        ram_byte w7e615d
        ram_byte w7e615e
        ram_byte w7e615f
        ram_byte w7e6160
        ram_byte w7e6161
        ram_byte w7e6162
        ram_byte w7e6163
        ram_byte w7e6164
        ram_byte w7e6165
        ram_byte w7e6166
        ram_byte w7e6167
        ram_byte w7e6168
        ram_word w7e6169
        ram_byte w7e616b
        ram_byte w7e616c
        ram_byte w7e616d
        ram_byte w7e616e
        ram_byte w7e616f
        ram_byte w7e6170
        ram_byte w7e6171
        ram_byte w7e6172
        ram_byte w7e6173
        ram_byte w7e6174
        ram_byte w7e6175
        ram_byte w7e6176
        ram_byte w7e6177
        ram_byte w7e6178
        ram_byte w7e6179
        ram_byte w7e617a
        ram_byte w7e617b
        ram_byte w7e617c
        ram_byte w7e617d
        ram_res 12, w7e617e
        ram_byte wIsMonsterAttackAnim
        ram_res 6, w7e618b

; monsters not newly entering (draw monsters if bits are set)
        ram_byte w7e6191

        ram_byte w7e6192
        ram_byte w7e6193
        ram_byte w7e6194
        ram_byte w7e6195
        ram_byte w7e6196
        ram_byte w7e6197
        ram_byte w7e6198
        ram_byte w7e6199
        ram_byte w7e619a
        ram_byte w7e619b
        ram_byte w7e619c
        ram_byte w7e619d
        ram_res 4, w7e619e
        ram_res 4, w7e61a2
        ram_res 4, w7e61a6
        ram_byte w7e61aa
        ram_byte w7e61ab
        ram_byte w7e61ac
        ram_byte w7e61ad
        ram_res 4, w7e61ae
        ram_res 4, w7e61b2

        ram_array wCharGfxData, 4, 32
                ram_byte
                ram_word PosX
                ram_word PosY
                ram_byte ReadyAction
                ram_byte Pal
                ram_byte LayerPriority
                ram_byte Flip
                ram_byte StatusAction
                ram_byte AnimAction
                ram_byte AnimFrame
                ram_byte AnimCounter
                ram_byte CurrFrame
                ram_byte PrevFrame
                ram_word OffsetX
                ram_word OffsetY
                ram_word w7e61c9
                ram_word w7e61cb
                ram_byte VanishCounter
                ram_byte w7e61ce  ; disable char gfx update
                ram_byte StatusSpriteIndex
                ram_byte w7e61d0  ; double action speed
                ram_byte DisableFloatOffset
                ram_word JumpOffset
                ram_word AnimOffsetX
        end_ram_array

        ram_res 4 * 4, w7e6236
        ram_res 4 * 4, w7e6246
        w7e6248 := w7e6246 + 2
        ram_res 4 * 4, w7e6256
        ram_word w7e6266
        ram_word w7e6268
        ram_byte w7e626a
        ram_byte w7e626b
        ram_byte w7e626c
        ram_byte w7e626d
        ram_byte w7e626e
        ram_byte w7e626f
        ram_byte w7e6270
        ram_byte w7e6271
        ram_byte w7e6272
        ram_word w7e6273
        ram_word w7e6275
        ram_word w7e6277
        ram_byte w7e6279
        ram_byte w7e627a
        ram_byte w7e627b
        ram_byte w7e627c
        ram_byte w7e627d
        ram_word w7e627e
        ram_byte w7e6280

        ram_byte w7e6281
        ram_byte w7e6282
        ram_byte w7e6283
        ram_byte w7e6284
        ram_byte w7e6285
        ram_byte w7e6286
        ram_byte w7e6287
        ram_byte w7e6288
        ram_byte w7e6289
        ram_byte wEnableFlashback
        ram_byte w7e628b
        ram_byte w7e628c
        ram_byte w7e628d
        ram_byte w7e628e
        ram_byte w7e628f
        ram_word w7e6290
        ram_word w7e6292
        ram_word w7e6294
        ram_word w7e6296
        ram_word w7e6298
        ram_byte w7e629a
        ram_byte w7e629b
        ram_byte w7e629c
        ram_byte w7e629d
        ram_byte w7e629e
        ram_byte w7e629f
        ram_res 4, w7e62a0
        ram_byte w7e62a4
        ram_res 4, w7e62a5
        ram_byte w7e62a9
        ram_byte w7e62aa
        ram_byte wBattleIsPaused
        ram_byte w7e62ac
        ram_byte w7e62ad
        ram_byte w7e62ae
        ram_byte w7e62af
        ram_byte w7e62b0
        ram_byte w7e62b1
        ram_byte w7e62b2
        ram_byte w7e62b3
        ram_byte w7e62b4
        ram_byte w7e62b5
        ram_byte w7e62b6
        ram_byte w7e62b7
        ram_byte w7e62b8
        ram_byte w7e62b9
        ram_byte w7e62ba
        ram_word w7e62bb
        ram_byte w7e62bd
        ram_byte w7e62be
        ram_byte w7e62bf
        ram_byte w7e62c0
        ram_byte w7e62c1
        ram_byte w7e62c2
        ram_byte w7e62c3
        ram_byte w7e62c4
        ram_byte w7e62c5
        ram_byte w7e62c6
        ram_byte w7e62c7
        ram_byte w7e62c8
        ram_byte w7e62c9
        ram_word w7e62ca
        ram_byte w7e62cc
        ram_byte w7e62cd
        ram_byte w7e62ce
        ram_byte w7e62cf
        ram_byte w7e62d0
        ram_byte w7e62d1

; don't update target draw order every frame during animations
        ram_byte wStaticDrawOrder

        ram_byte w7e62d3
        ram_byte w7e62d4
        ram_byte w7e62d5
        ram_res 8 * 8, w7e62d6
        ram_byte w7e6316
        ram_word w7e6317
        ram_byte w7e6319
        ram_res 4, w7e631a
        ram_res 4, w7e631e
        ram_res 4, w7e6322
        ram_res 4, w7e6326
        ram_res 4, w7e632a
        ram_byte w7e632e
        ram_byte w7e632f
        bg_scroll_hdma_res w7e6330, 32
        bg_scroll_hdma_res w7e63b0, 64
        ram_word w7e64b0
        ram_word w7e64b2
        ram_word w7e64b4
        ram_word w7e64b6
        ram_byte w7e64b8
        ram_byte w7e64b9

; magitek mode variables
        ram_byte wMagitekModeEnabled
        ram_byte wForceMagitekGfxTfr
        ram_res 8, wMagitekGfxSrcPtr
        ram_res 8, wMagitekGfxVRAMPtr
        ram_res 4, wMagitekAnimType
        ram_res 4, w7e64d0
        ram_byte wMagitekPalOffset

        ram_byte w7e64d5

; characters in battle menu order (empty slots pushed to end)
        ram_res 4, w7e64d6

; number of items added to inventory
        ram_byte w7e64da
        ram_byte w7e64db

; animation variables
        ram_word w7e64dc
        ram_array wAnimThread, 85, 64, 16
                ram_byte SpriteIsActive
                ram_word SpritePosX
                ram_word SpritePosY
                ram_byte SpriteFrame
                ram_byte SpriteTileOffset
                ram_word SpriteFlags
                ram_byte IsBackSprite
                ram_word w7e64e8
                ram_word w7e64ea
                ram_word SubReturnPtr
                end_ram_block

                ram_byte ThreadIsActive
                ram_byte FrameWidth
                ram_byte FrameHeight
                ram_faraddr ScriptPtr
                ram_byte AnimRate
                ram_byte AnimFrameCounter
                ram_byte ThreadIndex
                ram_byte w7e6a37
                ram_byte AttackerIndex
                ram_byte TargetIndex
                ram_word ThreadPosX
                ram_word ThreadPosY
                end_ram_block

                ram_word AttackerPosX
                ram_word AttackerPosY
                ram_word TargetPosX
                ram_word TargetPosY
                ram_byte LayerPriority
                ram_byte w7e6f87
                ram_byte w7e6f88
                ram_word LoopPtr
                ram_byte LoopCounter
                ram_byte LoopFrameOffset
                ram_byte LoopFrameCounter
                end_ram_block

                ram_word ThreadOffsetX
                ram_word ThreadOffsetY
                ram_byte TargetWidth
                ram_byte TargetHeight
                ram_byte w7e74d4
                ram_byte SpritePal
                ram_byte w7e74d6
                ram_byte w7e74d7
                ram_byte w7e74d8
                ram_word w7e74d9
                ram_byte w7e74db
                ram_word w7e74dc
                end_ram_block
        end_ram_array

        .define wBG1Thread array_item wAnimThread, 80
        .define wBG3Thread array_item wAnimThread, 81
        .define wGenjuThread1 array_item wAnimThread, 82
        .define wGenjuThread2 array_item wAnimThread, 83
        .define wGenjuThread3 array_item wAnimThread, 84

        BG1_THREAD_OFFSET = array_offset wAnimThread, 80
        BG3_THREAD_OFFSET = array_offset wAnimThread, 81
        GENJU_THREAD_1_OFFSET = array_offset wAnimThread, 82
        GENJU_THREAD_2_OFFSET = array_offset wAnimThread, 83
        GENJU_THREAD_3_OFFSET = array_offset wAnimThread, 84

        ram_byte w7e7a1e

; character/monster draw order buffer
        ram_array wTargetDrawOrderBuf, 10, 4
                ram_word BottomY
                ram_word TargetIndex
                end_ram_array

; character/monster draw order buffer
        ram_array wTargetDrawOrder, 10, 4
                ram_word BottomY
                ram_word TargetIndex
                end_ram_array

        ram_res 4, w7e7a6f
        ram_res 8 * 2, w7e7a73
        ram_byte w7e7a83
        ram_byte w7e7a84
        ram_byte w7e7a85
        ram_res 6, w7e7a86
        ram_res 6, w7e7a8c
        ram_res 6, w7e7a92
        ram_res 6, w7e7a98
        ram_res 6, w7e7a9e
        ram_res 6, w7e7aa4
        ram_res 6, w7e7aaa
        ram_res 6, w7e7ab0
        ram_res 6, w7e7ab6
        ram_res 6, w7e7abc
        ram_res 6, w7e7ac2
        ram_res 6, w7e7ac8
        ram_byte w7e7ace
        ram_byte w7e7acf
        ram_array w7e7ad0, 6, 4
                ram_word Pos
                ram_word Index
        end_ram_array
        ram_byte w7e7ae8
        ram_byte w7e7ae9
        ram_byte w7e7aea
        ram_byte w7e7aeb
        ram_word w7e7aec
        ram_byte w7e7aee
        ram_byte w7e7aef
        ram_byte w7e7af0
        ram_byte w7e7af1
        ram_byte w7e7af2  ; unused
        ram_byte w7e7af3  ; unused
        ram_byte w7e7af4
        ram_byte wWeaponAnimIndex       ; also monster special animation index
        ram_word wAnimThreadPtr
        ram_word wAttackerThreadPtr
        ram_word wSpriteThreadPtr
        ram_byte wSpriteThreadCounter

        ram_byte w7e7afd
        ram_word w7e7afe

        ram_byte w7e7b00
        ram_byte w7e7b01
        ram_byte w7e7b02
        ram_word w7e7b03
        ram_word w7e7b05
        ram_res 5, w7e7b07

; sprite draw order is invalid
        ram_byte wDrawOrderInvalid

        ram_byte w7e7b0d  ; wNumThreadsToUpdate
        ram_byte w7e7b0e  ; wThreadsPerMonster
        ram_byte w7e7b0f  ; wThreadsPerChar
        ram_res 4, w7e7b10
        ram_byte w7e7b14  ; wNumSpriteThreads
        ram_byte w7e7b15  ; wEnableBG1AnimUpdate
        ram_word w7e7b16  ; wBG1AnimOffsetX
        ram_word w7e7b18  ; wBG1AnimOffsetY
        ram_faraddr w7e7b1a  ; wBG1AnimTilesBufPtr
        ram_word w7e7b1d  ; wBG3AnimPosX
        ram_word w7e7b1f  ; wBG3AnimPosY
        ram_byte w7e7b21  ; wEnableBG3AnimUpdate
        ram_word w7e7b22  ; wBG3AnimOffsetX
        ram_word w7e7b24  ; wBG3AnimOffsetY
        ram_faraddr w7e7b26  ; wBG3AnimTilesBufPtr
        ram_word w7e7b29  ; wBG3AnimPosX
        ram_word w7e7b2b  ; wBG3AnimPosY
        ram_word w7e7b2d
        ram_word w7e7b2f
        ram_word w7e7b31
        ram_word w7e7b33
        ram_word w7e7b35
        ram_word w7e7b37
        ram_byte w7e7b39
        ram_byte w7e7b3a
        ram_byte w7e7b3b
        ram_byte w7e7b3c
        ram_byte w7e7b3d
        ram_byte w7e7b3e
        ram_res 10, w7e7b3f
        ram_res 10, w7e7b49
        ram_res 10, w7e7b53
        ram_res 10, w7e7b5d
        ram_byte wHideBG1MonsterSprites
        ram_byte w7e7b68
        ram_byte w7e7b69
        ram_byte w7e7b6a
        ram_byte w7e7b6b
        ram_res 4, w7e7b6c
        ram_res 4, w7e7b70
        ram_res 4, w7e7b74
        ram_byte w7e7b78
        ram_byte w7e7b79
        ram_byte w7e7b7a
        ram_byte w7e7b7b
        ram_byte w7e7b7c
        ram_byte w7e7b7d
        ram_byte w7e7b7e
        ram_byte w7e7b7f
        ram_byte w7e7b80
        ram_byte w7e7b81
        ram_byte w7e7b82
        ram_byte w7e7b83
        ram_byte w7e7b84
        ram_byte w7e7b85
        ram_res 4, w7e7b86

; bg3 scroll hdma table offset (12 when using slot, 0 otherwise)
        ram_byte w7e7b8a

        ram_byte wSlotHDMAActive
        ram_byte wSlotReelPos1  ; slot reel 1 position
        ram_byte wSlotReelPos2  ; slot reel 2 position
        ram_byte wSlotReelPos3  ; slot reel 3 position
        ram_byte w7e7b8f
        ram_byte w7e7b90
        ram_byte w7e7b91
        ram_byte w7e7b92
        ram_byte w7e7b93
        ram_byte w7e7b94
        ram_byte w7e7b95
        ram_byte w7e7b96
        ram_byte w7e7b97
        ram_byte w7e7b98
        ram_byte w7e7b99
        ram_byte w7e7b9a
        ram_byte w7e7b9b
        ram_byte w7e7b9c
        ram_byte w7e7b9d
        ram_byte w7e7b9e
        ram_word w7e7b9f
        ram_word w7e7ba1
        ram_byte w7e7ba3

; item usage flags to filter inventory for tools/throw list
        ram_byte w7e7ba4

        ram_byte w7e7ba5
        ram_byte w7e7ba6
        ram_byte w7e7ba7
        ram_byte w7e7ba8
        ram_byte wEnableUpdateMenuTextTiles
        ram_word w7e7baa
        ram_byte w7e7bac
        ram_byte wForceCharGfxTfr     ; char id or $ff to disable
        ram_byte w7e7bae
        ram_byte w7e7baf
        ram_byte w7e7bb0
        ram_word w7e7bb1
        ram_word w7e7bb3
        ram_byte w7e7bb5
        ram_byte w7e7bb6
        ram_byte w7e7bb7
        ram_byte w7e7bb8
        ram_byte w7e7bb9
        ram_byte w7e7bba
        ram_byte wEnableUpdateMenuWindowTiles
        ram_word w7e7bbc
        ram_word w7e7bbe
        ram_word w7e7bc0
        ram_res 8, wMenuInput
        ram_byte wMenuIsOpen
        ram_byte wCloseMenu
        ram_byte w7e7bcc
        ram_res 4, w7e7bcd
        ram_byte w7e7bd1
        ram_word w7e7bd2
        ram_word w7e7bd4
        ram_byte w7e7bd6
        ram_word w7e7bd7
        ram_word w7e7bd9

; doing a menu window update for bg1 instead of bg2
        ram_word wIsBG1MenuWindowUpdate
        ram_byte w7e7bdd
        ram_word w7e7bde
        ram_word w7e7be0
        ram_word w7e7be2
        ram_word w7e7be4
        ram_byte w7e7be6
        ram_word w7e7be7
        ram_word w7e7be9
        ram_byte w7e7beb
        ram_word w7e7bec
        ram_byte w7e7bee
        ram_byte w7e7bef
        ram_res 16, wMenuWindowState
        ram_array w7e7c00, 16, 32
                ram_word Color0
                ram_word Color1
                ram_word Color2
                ram_word Color3
                ram_word Color4
                ram_word Color5
                ram_word Color6
                ram_word Color7
                ram_word Color8
                ram_word Color9
                ram_word Color10
                ram_word Color11
                ram_word Color12
                ram_word Color13
                ram_word Color14
                ram_word Color15
        end_ram_array
        ram_array w7e7e00, 16, 32
                ram_word Color0
                ram_word Color1
                ram_word Color2
                ram_word Color3
                ram_word Color4
                ram_word Color5
                ram_word Color6
                ram_word Color7
                ram_word Color8
                ram_word Color9
                ram_word Color10
                ram_word Color11
                ram_word Color12
                ram_word Color13
                ram_word Color14
                ram_word Color15
        end_ram_array
        ram_byte w7e8000
        ram_faraddr w7e8001
        ram_word w7e8004
        ram_word w7e8006
        ram_word w7e8008
        ram_byte w7e800a
        ram_byte w7e800b
        ram_byte w7e800c
        ram_byte w7e800d
        ram_byte w7e800e
        ram_res 6 * 2, w7e800f
        ram_res 6 * 2, w7e801b
        ram_res 6 * 2, w7e8027
        ram_res 4 * 2, w7e8033
        ram_res 4 * 2, w7e803b
        ram_res 4 * 2, w7e8043
        ram_res 6 * 2, w7e804b
        ram_res 6 * 2, w7e8057
        ram_res 6 * 2, w7e8063
        ram_res 6 * 2, w7e806f
        ram_res 6 * 2, w7e807b
        ram_res 6 * 2, w7e8087
        ram_res 6 * 2, w7e8093
        ram_res 6 * 2, w7e809f
        ram_res 6 * 2, w7e80ab
        ram_res 6 * 2, w7e80b7
        ram_res 6 * 2, w7e80c3
        ram_res 6 * 2, w7e80cf
        ram_res 6 * 2, w7e80db
        ram_res 6 * 2, w7e80e7
        ram_res 6 * 2, w7e80f3
        ram_res 6 * 2, w7e80ff
        ram_res 6 * 2, w7e810b
        ram_res 6 * 2, w7e8117
        ram_res 6 * 2, w7e8123
        ram_res 6 * 2, w7e812f
        ram_res 4 * 4, w7e813b
        ram_res 8 * 4, w7e814b
        ram_res 60, w7e816b
        ram_byte w7e81a7
        ram_word w7e81a8
        ram_byte w7e81aa
        ram_byte w7e81ab
        ram_byte w7e81ac
        ram_res 4 * 32, w7e81ad
        ram_res 32, w7e822d
        ram_byte w7e824d
        ram_byte w7e824e
        ram_byte w7e824f
        ram_byte w7e8250
        ram_byte w7e8251
        ram_byte w7e8252
        ram_byte w7e8253
        ram_word w7e8254
        ram_byte w7e8256
        ram_byte w7e8257
        ram_byte w7e8258
        ram_res 6 * 17 * 4, w7e8259
        ram_res 6 * 17 * 4, w7e83f1
        ram_res 6 * 17 * 4, w7e8589
        ram_res 6 * 17 * 4, w7e8721
        ram_res 6, w7e88b9
        ram_array w7e88bf, 6, 3
                ram_byte Red
                ram_byte Green
                ram_byte Blue
        end_ram_array
        ram_byte w7e88d1
        ram_byte w7e88d2
        ram_byte w7e88d3
        ram_byte w7e88d4
        ram_word w7e88d5
        ram_word w7e88d7
        ram_byte w7e88d9
        ram_byte w7e88da
        ram_byte w7e88db
        ram_byte w7e88dc
        ram_word w7e88dd
        ram_word w7e88df
        ram_byte w7e88e1
        ram_byte w7e88e2
        ram_res 4, w7e88e3
        ram_res 4, w7e88e7
        ram_res 4, w7e88eb
        ram_res 4, w7e88ef
        ram_res 4, w7e88f3
        ram_res 4, w7e88f7
        ram_res 4, w7e88fb
        ram_res 4, w7e88ff
        ram_res 4, w7e8903
        ram_res 4, w7e8907
        ram_byte w7e890b
        ram_byte w7e890c
        ram_byte w7e890d
        ram_byte w7e890e

; cursor memory data (copied to/from $0280-$02DF)
        ram_res 4, w7e890f              ; command position
        ram_res 4, w7e8913              ; magic scroll position
        ram_res 4, w7e8917              ; magic x-offset
        ram_res 4, w7e891b              ; magic y-offset
        ram_res 4, w7e891f              ; lore scroll position
        ram_res 4, w7e8923              ; lore x-offset
        ram_res 4, w7e8927              ; lore y-offset
        ram_res 4, w7e892b              ; rage scroll position
        ram_res 4, w7e892f              ; rage x-offset
        ram_res 4, w7e8933              ; rage y-offset
        ram_res 4, w7e8937              ; dance x-offset
        ram_res 4, w7e893b              ; dance y-offset
        ram_res 4, w7e893f              ; magitek x-offset
        ram_res 4, w7e8943              ; magitek y-offset
        ram_res 4, w7e8947              ; item scroll position
        ram_res 4, w7e894b              ; item x-offset
        ram_res 4, w7e894f              ; item y-offset
        ram_res 4, w7e8953              ; throw scroll position
        ram_res 4, w7e8957              ; throw x-offset
        ram_res 4, w7e895b              ; throw y-offset
        ram_res 4, w7e895f              ; tools scroll position
        ram_res 4, w7e8963              ; tools x-offset
        ram_res 4, w7e8967              ; tools y-offset
        ram_res 4, w7e896b              ; character id

        ram_byte w7e896f
        ram_byte w7e8970
        ram_byte w7e8971
        ram_byte w7e8972
        ram_byte w7e8973
        ram_byte w7e8974
        ram_byte w7e8975
        ram_byte w7e8976
        ram_byte w7e8977
        ram_byte w7e8978
        ram_byte w7e8979
        ram_byte w7e897a
        ram_byte w7e897b
        ram_byte w7e897c
        ram_byte w7e897d
        ram_byte w7e897e
        ram_byte w7e897f
        ram_byte w7e8980
        ram_byte w7e8981
        ram_byte w7e8982
        ram_byte w7e8983
        ram_byte w7e8984
        ram_byte w7e8985
        ram_byte w7e8986
        ram_byte w7e8987
        ram_byte w7e8988
        ram_byte w7e8989
        ram_byte w7e898a
        ram_byte w7e898b
        ram_byte w7e898c
        ram_byte w7e898d
        ram_byte w7e898e
        ram_byte w7e898f
        ram_byte w7e8990
        ram_byte w7e8991
        ram_byte w7e8992
        ram_res 224 * 4, w7e8993

        ram_res $0300, w7e8d13          ; 32x12 tilemap buffer for menus
        ram_res $0200, w7e9013          ; 32x8 tilemap buffer for "short" command menu
        ram_res $0200, w7e9213          ; 32x8 tilemap buffer for "window" command menu
        ram_res $0200, w7e9413          ; 32x8 tilemap buffer for Relm's control menu

        ram_byte w7e9613
        ram_byte w7e9614
        ram_byte w7e9615
        ram_byte w7e9616
        ram_byte w7e9617
        ram_byte w7e9618
        ram_byte w7e9619
        ram_byte w7e961a
        ram_byte wCircleShape
        ram_byte w7e961c
        ram_byte w7e961d
        ram_byte w7e961e
        ram_res $0100, w7e961f
        ram_res $0100, w7e971f
        ram_res $0200, w7e981f
        ram_res 152 * 4, w7e9a1f
        ram_res 72 * 4, w7e9c7f
        ram_res 128, w7e9d9f
        ram_res 256, w7e9e1f
        ram_res 152 * 4, w7e9f1f
        ram_res $0200, w7ea17f
        ram_res $0200, w7ea37f
        ram_res $0200, w7ea57f
        ram_res $0200, w7ea77f
        ram_res $04c0, w7ea97f
        ram_res $1000, w7eae3f
        ram_res $1000, w7ebe3f
        ram_res $0a80, w7ece3f
        ram_res $0a80, w7ed8bf
        ram_res $0400, wLargeTextGfxBuf
        ram_res $0080, wLargeTextTileBuf
        ram_res 64, w7ee7bf
        ram_res 64, w7ee7ff
        ram_res 64, w7ee83f
        ram_res 64, w7ee87f
        ram_res 64, w7ee8bf
        ram_res 64, w7ee8ff
        ram_res 64, w7ee93f
        ram_res 64, w7ee97f

        ram_word wLargeTextGfxVRAMAddr
        ram_byte w7ee9c1
        ram_byte w7ee9c2
        ram_byte w7ee9c3
        ram_word w7ee9c4
        ram_word w7ee9c6
        ram_word w7ee9c8
        ram_word w7ee9ca
        ram_word w7ee9cc
        ram_word w7ee9ce
        ram_word w7ee9d0
        ram_res 4 * 2, w7ee9d2
        ram_byte w7ee9da
        ram_byte w7ee9db
        ram_byte w7ee9dc
        ram_byte w7ee9dd
        ram_byte w7ee9de
        ram_byte w7ee9df
        ram_byte w7ee9e0
        ram_byte w7ee9e1
        ram_word w7ee9e2
        ram_byte w7ee9e4
        ram_byte w7ee9e5
        ram_byte w7ee9e6
        ram_byte w7ee9e7
        ram_byte w7ee9e8
        ram_byte w7ee9e9
        ram_byte w7ee9ea
        ram_byte w7ee9eb
        ram_byte w7ee9ec
        ram_byte wSfxDisabled            ; victory animation or background scrolling
        ram_byte w7ee9ee
        ram_byte w7ee9ef
        ram_byte w7ee9f0
        ram_byte w7ee9f1
        ram_faraddr w7ee9f2
        ram_byte w7ee9f5
        ram_byte w7ee9f6
        ram_byte w7ee9f7
        ram_byte w7ee9f8
        ram_byte w7ee9f9
        ram_byte w7ee9fa
        ram_byte w7ee9fb
        ram_byte w7ee9fc
        ram_byte w7ee9fd
        ram_res 16 * 2, w7ee9fe
        ram_res 10 * 2, w7eea1e
        ram_res 228 * 2, w7eea32
        ram_byte w7eebfa
        ram_byte w7eebfb
        ram_byte w7eebfc
        ram_byte w7eebfd
        ram_byte w7eebfe
        ram_res 4 * 2, w7eebff
        ram_res 4 * 2, w7eec07
        ram_byte wPauseNotAllowed
        ram_byte wDragonHornActive
        ram_array wBattleBGPal, 3, 32
                ram_word Color0
                ram_word Color1
                ram_word Color2
                ram_word Color3
                ram_word Color4
                ram_word Color5
                ram_word Color6
                ram_word Color7
                ram_word Color8
                ram_word Color9
                ram_word Color10
                ram_word Color11
                ram_word Color12
                ram_word Color13
                ram_word Color14
                ram_word Color15
        end_ram_array
        ram_array wBattleBGPalBuf, 2, 32
                ram_word Color0
                ram_word Color1
                ram_word Color2
                ram_word Color3
                ram_word Color4
                ram_word Color5
                ram_word Color6
                ram_word Color7
                ram_word Color8
                ram_word Color9
                ram_word Color10
                ram_word Color11
                ram_word Color12
                ram_word Color13
                ram_word Color14
                ram_word Color15
        end_ram_array
        ram_byte w7eecb1
        ram_byte w7eecb2
        ram_byte w7eecb3
        ram_word w7eecb4
        ram_word w7eecb6
        ram_word w7eecb8
        ram_byte w7eecba
        ram_byte w7eecbb
        ram_res 16, w7eecbc
        ram_res 16, w7eeccc
        ram_res 16, w7eecdc
        ram_word w7eecec
        ram_byte w7eecee
        ram_byte w7eecef
        .if LANG_EN
        ram_byte        w7eecf0
        .endif

        .assert _ram_offset <= $7ef800, error, "Insufficient battle graphics WRAM"

        ram_org $7ef800

        ram_res $0800, wHypotenuseTbl
