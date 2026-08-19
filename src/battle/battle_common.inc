; ------------------------------------------------------------------------------

        ram_verbose 0

; variables shared between battle mechanics and battle graphics modules

        ram_org $7e2000

        ram_res 0, wInitNullBlock1

        ram_byte w7e2000
        ram_word_array w7e2001, 6
        ram_word_array w7e200d, 4
        ram_word_array w7e2015, 4
        ram_byte w7e201d
        ram_byte w7e201e
        ram_byte w7e201f
        ram_byte w7e2020
        ram_byte wGaugeSetting
        ram_byte_array wATBGaugeBuf, 4
        ram_byte_array wMorphGaugeBuf, 4
        ram_byte_array wCondemnNumBuf, 4
        ram_array wCmdList, 4, 4 * 3
                ram_byte CmdID
                ram_byte Disabled
                ram_byte Flags
        end_ram_array
        ram_array wControlCmdList, 4, 4 * 3
                ram_byte CmdID
                ram_byte Disabled
                ram_byte Flags
        end_ram_array
        ram_array wSpellList, 4, 4 * (1 + 54 + 24)
                ram_byte AttackID
                ram_byte Disabled
                ram_byte Flags
                ram_byte MPCost
        end_ram_array

        .define wSpellListGenju wSpellList
        .define wSpellListMagic 4 + wSpellListGenju
        .define wSpellListLore 54 * 4 + wSpellListMagic

; known rages
        ram_res 256, wRageList

; known dances
        ram_res 8, wDanceList

; inventory buffer
        ram_array wItemList, 256 + 8, 5
                ram_byte ItemID
                ram_byte UsageFlags
                ram_byte Targeting
                ram_byte Qty
                ram_byte EquipFlags
        end_ram_array

; equipped items
        .define wRHandItemList wItemList::_256
        .define wLHandItemList wItemList::_260

; player action list
        ram_array wPlayerActionBuf, 4, 8
                ram_byte CharSlot
                ram_byte BattleCmd
                ram_byte Attack
                ram_word Targets
                ram_byte SecondAttack   ; second attack for x-magic
                ram_word SecondTargets
        end_ram_array

; damage numerals (5+ targets)
        ram_array w7e2bce, 8, 20
        end_ram_array

; graphics script parameters
        ram_array w7e2c6e, 16, 16
        end_ram_array

; graphics script
        ram_array w7e2d6e, 64, 4
                ram_byte GfxCmd
                ram_byte BattleCmd
                ram_byte Attack
                ram_byte Param3
        end_ram_array

        ram_res 4, w7e2e6e              ; characters with genju glove equipped

; buffer for loading and saving item properties
        ram_res 0, wItemPropBuf

        ram_byte w7e2e72                 ; current item index
        ram_byte w7e2e73                 ; current item usage flags
        ram_byte w7e2e74                 ; current item targeting flags
        ram_byte w7e2e75                 ; current item quantity
        ram_byte w7e2e76                 ; current item equip flags

        sizeof_wItemPropBuf = _ram_offset - wItemPropBuf

        ram_byte                        ; unused

        ram_res 8, w7e2e78              ; char current hp buffer
        ram_res 8, w7e2e80              ; char max hp buffer
        ram_res 8, w7e2e88              ; char current mp buffer
        ram_res 8, w7e2e90              ; char max mp buffer
        ram_res 8, w7e2e98              ; char status 1/2 buffer
        ram_res 8, w7e2ea0              ; char status 3/4 buffer
        ram_res 4, w7e2ea8
        ram_byte w7e2eac
        ram_byte w7e2ead

        ram_array wCharGfxDataBuf, 4, 32
                ram_byte GfxID
                ram_res 6, Name
                ram_word CurrHP
                ram_word MaxHP
                ram_word CurrMP
                ram_word MaxMP
                ram_res 0, ActiveStatus12
                ram_byte ActiveStatus1
                ram_byte ActiveStatus2
                ram_res 0, ActiveStatus34
                ram_byte ActiveStatus3
                ram_byte ActiveStatus4
                ram_res 0, ShownStatus12
                ram_byte ShownStatus1
                ram_byte ShownStatus2
                ram_res 0, ShownStatus34
                ram_byte ShownStatus3
                ram_byte ShownStatus4
                ram_byte Row
                ram_byte CharID
                ram_byte IsCharAI
        end_ram_array

; command setting (0: window, 1: short)
        ram_byte w7e2f2e

; visible monsters ???
        ram_byte w7e2f2f

; character equipment change pending
        ram_res 4, w7e2f30

; menu window graphics index
        ram_byte w7e2f34

; variables for battle messages
        ram_faraddr w7e2f35
        ram_faraddr w7e2f38
        ram_faraddr w7e2f3b
        ram_faraddr w7e2f3e

; stop battle time (wait mode, menu open)
        ram_byte w7e2f41

; monster roulette target
        ram_word w7e2f42

; monster with invisible status
        ram_byte w7e2f44

; L+R pressed (enable character running animation)
        ram_byte w7e2f45

; valid character targets (from character a.i.)
        ram_byte w7e2f46

; enemy character (from character a.i.)
        ram_byte w7e2f47

; battle properties
        ram_byte w7e2f48
        ram_byte w7e2f49
        ram_byte w7e2f4a
        ram_byte w7e2f4b

; characters/monster that can't be targeted
        ram_word w7e2f4c

; characters/monster that can be targeted
        ram_word w7e2f4e

; character monster facing directions
        ram_word w7e2f50

; reset by battle animation command $c7/$0f, no effect, never used
        ram_byte w7e2f52

; h-flip for controlled/confused targets
        ram_word w7e2f53

        .assert _ram_offset <= $7e3000, error, "Insufficient common battle WRAM"

; ------------------------------------------------------------------------------
