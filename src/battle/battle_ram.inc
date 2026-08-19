; ------------------------------------------------------------------------------

        ram_verbose 0

        ram_org $a0

; graphics script data buffer
        ram_byte za0                    ; graphics script data flags
        ram_byte za1                    ; attacker index
        ram_word za2                    ; all targets
        ram_word za4                    ; hit targets
        ram_word za6                    ; reflected/cover targets
        ram_byte za8                    ; target id protected by cover
        ram_byte za9                    ; unused
        ram_res 4, zaa                  ; character block types
        ram_word zae                    ; reflected / super ball / launcher attacker

        ram_byte zb0                    ; battle flags 1
        ram_byte zb1                    ; battle flags 2
        ram_byte zb2                    ; battle flags 3
        ram_byte zb3                    ; battle flags 4

        ram_byte zb4                    ; graphics script command
        ram_byte zb5                    ; battle command for graphics script
        ram_byte zb6                    ; attack for graphics script
        ram_byte zb7                    ; parameter 4 for graphics script

; attack targets
; also spell id for immediate actions
; also flags for misc. counters expiring
        ram_word zb8                    ; targets

        ram_byte zba                    ; attack flags
        ram_byte zbb                    ; targeting flags
        ram_byte zbc                    ; primary damage multiplier
        ram_byte zbd                    ; secondary damage multiplier
        ram_byte zbe                    ; random number

        .assert _ram_offset <= $e8, error, "Insufficient battle zero-page RAM"

; ------------------------------------------------------------------------------

        ram_org $e8

        ram_res 24, zScratch

; ------------------------------------------------------------------------------

        ram_org $7e3000

        ram_byte_array w7e3000, 16      ; slot for each character id
        ram_word_array w7e3010, 4       ; character data offset (+$1600)
        ram_word_array wTargetMask, 10
        ram_word_array w7e302c, 4       ; pointers to spells lists
        ram_res 54, w7e3034             ; master spell list
        ram_res 26, w7e306a             ; master lore list
        ram_res 256, w7e3084
        ram_res 128, w7e3184

        ram_array wTargetProp1, 10, 50, 2
                ram_byte w7e3204
                ram_byte w7e3205
                end_ram_block

; ATB gauge %
; empty when the high byte is set to 1 and fills when it overflows to zero
                ram_word w7e3218
                end_ram_block

; advance wait duration, monster special attack properties
                ram_byte AdvanceWaitDur
                ram_byte MonsterSpecialProp
                end_ram_block

; current subscript of AI script (normal and retal)
                ram_byte w7e3240
                ram_byte w7e3241
                end_ram_block

; pointer to start of AI script (normal)
                ram_word w7e3254
                end_ram_block

; pointer to start of AI script (retal)
                ram_word w7e3268
                end_ram_block

; retaliation targets
                ram_byte RetalTarget  ; any action
                ram_byte RetalUnusedTarget  ; unused
                end_ram_block
                ram_byte RetalCmdTarget  ; specific command
                ram_byte RetalAttackTarget  ; attack
                end_ram_block
                ram_byte RetalItemTarget  ; item
                ram_byte RetalElemTarget  ; element
                end_ram_block

; control targets
                ram_byte ControlTarget  ; target you control
                ram_byte ControlAttacker  ; target controlled by you
                end_ram_block

; command list pointers
                ram_byte w7e32cc  ; normal
                ram_byte w7e32cd  ; retal
                end_ram_block

                ram_byte w7e32e0
                ram_byte w7e32e1
                end_ram_block
                ram_byte w7e32f4
                ram_byte w7e32f5
                end_ram_block
                ram_byte w7e3308
                ram_byte w7e3309
                end_ram_block

; immune status (bits are 0 if immune)
                ram_byte ImmuneStatus1
                ram_byte ImmuneStatus2
                end_ram_block
                ram_byte ImmuneStatus3
                ram_byte ImmuneStatus4
                end_ram_block

; equipped esper
                ram_byte w7e3344

; esper targetting properties (never used)
                ram_byte w7e3345
                end_ram_block

; seize target and attacker
                ram_byte SeizeTarget
                ram_byte SeizeAttacker
                end_ram_block

; love token target and attacker
                ram_byte LoveTokenTarget
                ram_byte LoveTokenAttacker
                end_ram_block

; monster index for name in menu
                ram_word w7e3380
                end_ram_block

; charm target and attacker
                ram_byte CharmTarget
                ram_byte CharmAttacker
                end_ram_block

; monster index for rage and special attack
                ram_word w7e33a8
                end_ram_block

; unused
                ram_byte
                ram_byte
                end_ram_block

; damage taken
                ram_word DmgTaken
                end_ram_block

; damage healed
                ram_word DmgHealed
                end_ram_block
        end_ram_array

; zinger attacker and target
        ram_byte wZingerAttacker
        ram_byte wZingerTarget

; doom gaze target
        ram_word wDoomGaze

        ram_word w7e33fc
        ram_word w7e33fe
        ram_byte w7e3400
        ram_byte w7e3401
        ram_byte w7e3402
        ram_byte w7e3403
        ram_byte w7e3404
        ram_byte w7e3405
        ram_byte w7e3406
        ram_byte w7e3407
        ram_word w7e3408
        ram_byte w7e340a
        ram_byte
        ram_byte
        ram_byte
        ram_byte
        ram_byte

        ram_byte w7e3410
        ram_byte w7e3411
        ram_byte w7e3412
        ram_byte w7e3413
        ram_byte w7e3414
        ram_byte w7e3415
        ram_byte w7e3416
        ram_byte w7e3417
        ram_byte w7e3418
        ram_byte w7e3419
        ram_byte w7e341a
        ram_byte w7e341b
        ram_byte w7e341c
        ram_byte w7e341d
        ram_byte w7e341e
        ram_byte w7e341f

        sizeof_wInitNullBlock1 = _ram_offset - wInitNullBlock1

; ------------------------------------------------------------------------------

; these queues do not get initialized at the start of a battle

        ram_res 256, w7e3420
        ram_res 256, w7e3520
        ram_res 256, w7e3620
        ram_res 256, w7e3720
        ram_res 256, w7e3820
        ram_res 256, w7e3920

; ------------------------------------------------------------------------------

        ram_res 0, wInitZeroBlock1

        ram_res 8, w7e3a20

        ram_byte w7e3a28
        ram_byte w7e3a29
        ram_byte w7e3a2a
        ram_byte w7e3a2b

        ram_byte w7e3a2c
        ram_byte w7e3a2d
        ram_byte w7e3a2e
        ram_byte w7e3a2f
        ram_word w7e3a30
        ram_word w7e3a32
        ram_byte w7e3a34
        ram_byte w7e3a35  ; unused
        ram_word wGolemHP

        ram_byte w7e3a38
        ram_byte w7e3a39
        ram_byte w7e3a3a
        ram_byte w7e3a3b
        ram_word w7e3a3c
        ram_word w7e3a3e

; AI characters (high byte unused)
        ram_word w7e3a40
        ram_word w7e3a42
        ram_word w7e3a44
        ram_byte w7e3a46
        ram_byte w7e3a47
        ram_word w7e3a48
        ram_word w7e3a4a
        ram_word w7e3a4c
        ram_word w7e3a4e
        ram_word w7e3a50  ; unused
        ram_word w7e3a52  ; unused
        ram_word w7e3a54
        ram_word w7e3a56
        ram_byte w7e3a58
        ram_byte
        ram_word w7e3a5a
        ram_word w7e3a5c
        ram_word w7e3a5e
        ram_word w7e3a60
        ram_word w7e3a62
        ram_byte w7e3a64
        ram_byte w7e3a65
        ram_byte w7e3a66
        ram_byte w7e3a67
        ram_byte w7e3a68
        ram_byte w7e3a69
        ram_byte w7e3a6a
        ram_byte
        ram_byte w7e3a6c
        ram_byte w7e3a6d
        ram_byte w7e3a6e
        ram_byte w7e3a6f
        ram_byte w7e3a70
        ram_byte w7e3a71
        ram_byte w7e3a72
        ram_byte w7e3a73
        ram_word w7e3a74
        ram_byte w7e3a76
        ram_byte w7e3a77
        ram_word w7e3a78
        ram_byte w7e3a7a
        ram_byte w7e3a7b
        ram_byte w7e3a7c
        ram_byte w7e3a7d
        ram_byte w7e3a7e
        ram_byte w7e3a7f
        ram_byte w7e3a80
        ram_byte w7e3a81
        ram_byte w7e3a82
        ram_byte w7e3a83

; known lores
        ram_res 3, w7e3a84

; number of lores known (used to choose a random lore)
        ram_byte wNumKnownLores

; characters removed via possess or bababreath
        ram_byte w7e3a88

; random weapon spellcast properties
        ram_byte wWeaponSpellCast

; engulfed targets
        ram_word w7e3a8a

        ram_byte w7e3a8c

; potential engulf targets (all must get engulfed to trigger gogo cave)
        ram_byte w7e3a8d

; dragon horn effect
        ram_byte w7e3a8e

; battle mode (0: active, 1: wait)
        ram_byte w7e3a8f

; battle speed constant = 255 - (battle_speed * 24)
        ram_byte w7e3a90

; status update counter
        ram_byte w7e3a91
        ram_byte w7e3a92
        ram_byte w7e3a93
        ram_byte w7e3a94
        ram_byte w7e3a95
        ram_byte w7e3a96
        ram_byte w7e3a97
        ram_word w7e3a98

; number of known rages (used to choose a random rage)
        ram_byte wNumKnownRages

; bitmask of available tools (used to choose a random tool)
        ram_byte wOwnedTools

; unused
        ram_byte w7e3a9c
        ram_byte w7e3a9d
        ram_byte w7e3a9e
        ram_byte w7e3a9f

        ram_array wTargetProp2, 10, 104, 2
                ram_byte w7e3aa0
                ram_byte w7e3aa1
                end_ram_block

; command delay counter
                ram_word w7e3ab4
                end_ram_block
                ram_word w7e3ac8
                end_ram_block
                ram_byte w7e3adc
                ram_byte w7e3add
                end_ram_block
                ram_byte w7e3af0
                ram_byte w7e3af1
                end_ram_block
                ram_byte w7e3b04
                ram_byte w7e3b05
                end_ram_block

; level, speed
                ram_byte Level
                ram_byte Speed
                end_ram_block

; strength * 2, unused speed stat
                ram_byte Strength
                ram_byte w7e3b2d
                end_ram_block

; stamina, magic power * 1.5
                ram_byte Stamina
                ram_byte MagicPower
                end_ram_block

; 255 - (evade * 2) + 1, 255 - (mblock * 2) + 1
                ram_byte Evade
                ram_byte MagicEvade
                end_ram_block

; right/left hand attack power
                ram_byte RHandAttackPower
                ram_byte LHandAttackPower
                end_ram_block

; hit rate
                ram_byte RHandHitRate
                ram_byte LHandHitRate
                end_ram_block

; right/left attack element
                ram_byte RHandElement
                ram_byte LHandElement
                end_ram_block

; right/left hand weapon flags
                ram_byte RHandWeaponFlags
                ram_byte LHandWeaponFlags
                end_ram_block

; defense, mag.def
                ram_byte Defense
                ram_byte MagicDefense
                end_ram_block

; absorbed/immune elements
                ram_byte ElemAbsorb
                ram_byte ElemNull
                end_ram_block

; weak/halved elements
                ram_byte ElemWeak
                ram_byte ElemHalf
                end_ram_block

; current HP
                ram_word CurrHP
                end_ram_block

; current MP
                ram_word CurrMP
                end_ram_block

; max HP
                ram_word MaxHP
                end_ram_block

; max MP
                ram_word MaxMP
                end_ram_block

; relic effects 1/3
                ram_byte RelicEffect1
                ram_byte RelicEffect3
                end_ram_block

; relic effects 4/5
                ram_byte RelicEffect4
                ram_byte RelicEffect5
                end_ram_block

; equipment status 2/3
                ram_word EquipStatus23
                end_ram_block

; monster status 2, monster special animation
                ram_byte MonsterStatus
                ram_byte MonsterSpecialAnim
                end_ram_block

; metamorph id, monster flags
                ram_byte MetamorphProp
                ram_byte MonsterFlags
                end_ram_block

; items equipped in left and right hand
                ram_byte RHandItem
                ram_byte LHandItem
                end_ram_block

; weapon special effect (also has shield block info, but it's not used here)
                ram_byte RHandWeaponSpecial
                ram_byte LHandWeaponSpecial
                end_ram_block

; equipped relics (only used for choosing umaro's attack)
                ram_word Relics
                end_ram_block

; physical/magic block graphic
                ram_word BlockGfx
                end_ram_block

; number of spells known (for choosing a random spell), sleep counter
                ram_byte NumKnownSpells
                ram_byte SleepCounter
                end_ram_block

; AI script loop address
                ram_word w7e3d0c
                end_ram_block

; AI script loop address (retaliation)
                ram_word w7e3d20
                end_ram_block

; weapon spell cast on attack
                ram_byte RHandSpellCast
                ram_byte LHandSpellCast
                end_ram_block

; last command/attack used against this target
                ram_byte w7e3d48
                ram_byte w7e3d49
                end_ram_block

; last item/element used against this target
                ram_byte w7e3d5c
                ram_byte w7e3d5d
                end_ram_block

; run counter, run factor
                ram_byte w7e3d70
                ram_byte w7e3d71
                end_ram_block

; monster experience
                ram_word MonsterExp
                end_ram_block

; monster gold
                ram_word MonsterGil
                end_ram_block

; monster variable (for AI scripts)
                ram_byte MonsterVar
                ram_byte
                end_ram_block

; monster timer
                ram_word MonsterTimer
                end_ram_block

; pending status to apply
                ram_byte w7e3dd4
                ram_byte w7e3dd5
                end_ram_block
                ram_byte w7e3de8
                ram_byte w7e3de9
                end_ram_block

; pending status to remove
                ram_byte w7e3dfc
                ram_byte w7e3dfd
                end_ram_block
                ram_byte w7e3e10
                ram_byte w7e3e11
                end_ram_block

; poison damage multiplier
                ram_byte PoisonDmgMult
                ram_byte                ; unused
                end_ram_block
                ram_byte                ; unused
                ram_byte                ; unused
                end_ram_block

; retaliation flags
                ram_byte RetalFlags

; extra status
;   use control menu (bit 0), added in English version, unused in Japanese version
;   phantasm (STATUS2::SAP)
;   overcast (STATUS1::ZOMBIE)
                ram_byte ExtraStatus
                end_ram_block

; status for determining retaliation
                ram_word RetalStatus12
                end_ram_block
                ram_word RetalStatus34
                end_ram_block

; unused
                ram_byte
                ram_byte
                end_ram_block

                ram_byte
                ram_byte
                end_ram_block
        end_ram_array

        ram_res 36, w7e3eb0

        sizeof_wInitZeroBlock1 = _ram_offset - wInitZeroBlock1

; ------------------------------------------------------------------------------

        ram_res 0, wInitNullBlock2

        ram_word wBattleID
        ram_word w7e3ed6

        ram_res 8, w7e3ed8

        ram_byte w7e3ee0
        ram_byte w7e3ee1
        ram_byte w7e3ee2
        ram_byte w7e3ee3  ; unused

        sizeof_wInitNullBlock2 = _ram_offset - wInitNullBlock2

; ------------------------------------------------------------------------------

        ram_res 0, wInitZeroBlock2

        ram_array wTargetProp3, 10, 6, 2
                ram_byte w7e3ee4
                ram_byte w7e3ee5
                end_ram_block
                ram_byte w7e3ef8
                ram_byte w7e3ef9
                end_ram_block
                ram_byte ReflectCounter
                ram_byte FreezeCounter
                end_ram_block
        end_ram_array

        ram_byte w7e3f20
        ram_byte w7e3f21
        ram_word w7e3f22
        ram_byte w7e3f24
        ram_byte w7e3f25
        ram_word w7e3f26
        ram_byte w7e3f28
        ram_byte w7e3f29
        ram_word w7e3f2a
        ram_word w7e3f2c
        ram_byte w7e3f2e
        ram_byte w7e3f2f
        ram_word w7e3f30
        ram_word wMorphRate
        ram_res 16, w7e3f34             ; unused

        sizeof_wInitZeroBlock2 = _ram_offset - wInitZeroBlock2

; ------------------------------------------------------------------------------

; battle monster properties
        ram_res 0, wBattleMonsters
        ram_word w7e3f44                ; battle monster flags
        ram_res 6, w7e3f46              ; monster ids
        ram_res 6, w7e3f4c              ; xy positions (not used here)
        ram_byte w7e3f52                ; monster id msbs

        .assert _ram_offset <= $7e4000, error, "Insufficient battle WRAM"

; ------------------------------------------------------------------------------
