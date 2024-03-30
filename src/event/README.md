# FF6 Event Script

The event script contains the storyline and scenario information used by the
event interpreter in the field engine. Please note that this portion of the
disassembly is a work in progress. Many event script instructions are not
implemented yet, and modifications to the script will likely cause the
game to crash.

## History and background

The event engine was written primarily by lead programmer Ken Narita, who
also worked on most of the other Squaresoft RPGs of the time. Programmer
Satoshi Ogata likely wrote the portions of the event engine used on the world
map. Compared to the earlier event engines of the series, the FF6 event
engine has many new capabilities and improvements, including better
parallel execution and program flow control, as well as game-specific
commands like the rotating pyramid effect used just before the final
battle. Narita went on to develop a similar event engine for Chrono
Trigger which inherits much of the functionality of the FF6 engine.

The event script itself was likely written by Narita along with event
planners Tsuka Fujita and Keisuke Matsuhara. Although the original event
script created by the Squaresoft developers is not publicly available,
through reverse-engineering it's possible to create a public version of
the event script which can be assembled into a byte-for-byte copy of
the original. It is a very large block of data in the ROM, using almost
200 kB of space, or about 12% of the 3 MB ROM. Currently only a small
portion of the event script has been reverse-engineered in this way, but
hopefully the rest can be disassembled in the same format eventually.

Special thanks to Yousei and Imzogelmo for their pioneering work in
understanding the event script format.

## Commands by category

### Character/Inventory Commands

[`char_name`](#char_name),
[`char_party`](#char_party),
[`char_prop`](#char_prop),
`dec_hp`,
`dec_mp`,
`give_blitz`,
`give_bushido`,
`give_genju`,
`give_gil`,
`give_item`,
`inc_hp`,
`inc_mp`,
`max_hp`,
`max_mp`,
`norm_lvl`,
`opt_equip`,
`remove_equip`,
`remove_status`,
`set_status`,
`take_genju`,
`take_gil`,
`take_item`,
`toggle_status`

### Cutscene Commands

`cutscene`,
`ending`

### Control Commands

`branch`,
`call`,
`end`,
`if_b_switch`,
`if_case`,
`if_dir`,
`if_key`,
`if_rand`,
[`if_switch`](#if_switch),
[`if_switch_any`](#if_switch_all-if_switch_any),
[`if_switch_all`](#if_switch_all-if_switch_any),
`end_loop`,
`exec`,
[`goto`](#goto),
`no_event`,
`loop`,
`loop_until`,
`return`,
`set_b_switch`,
`clr_b_switch`,
`set_case`,
[`switch`](#switch),
`start_timer`,
`stop_timer`,
`user_ctrl_on`,
`user_ctrl_off`,
[`set_var`](#set_var),
[`add_var`](#add_var),
[`sub_var`](#sub_var),
[`cmp_var`](#cmp_var),
`wait`,
`wait_15f`

### Dialogue Commands

`dlg`,
`wait_dlg`,
`wait_key`,
`choice`

### Map Commands

`bg_anim_speed`
`bg_anim_frame`
`load_map`, `parent_map`
`map_pal`
`mod_bg`
`wait_bg`

### Battle/Menu Commands

[`battle`](#battle)
`colosseum_menu`
`final_order`
`load_menu`
`name_menu`
`party_menu`
`shop_menu`

### Object Commands

`action`,
`anim`,
`collision`,
`create_obj`,
`delete_obj`,
`dir`,
`hide_obj`,
`jump`,
`layer`,
`move`,
`obj_gfx`,
`obj_event`,
`obj_pal`,
`pos`,
`obj_script`,
`pass`,
`pyramid`,
`scroll_obj`,
`show_obj`,
`sort_obj`,
[`speed`](#speed),
`update_party`,
[`vehicle`](#vehicle),
[`wait_obj`](#wait_obj)

### Party Commands

`activate_party`,
`party_chars`,
`party_pos`,
`party_map`,
`reset_prev_party`,
`restore_prev_party`

### Screen Commands

`clr_overlay`,
`fade_in`,
`fade_out`,
`filter_pal`,
`fixed_color_on`,
`fixed_color_off`,
`flash`,
`flashlight`,
`lock_camera`,
`mod_pal`,
`mosaic`,
`pause_fade`,
`portrait`,
`scroll_bg`,
`shake`,
`unlock_camera`,
`wait_fade`

### Sound Commands

`play_song`,
`spc_cmd`,
`sfx`

### World Commands

`airship_pos`,
`altitude`,
`angle`,
`figaro_submerge`,
`figaro_emerge`,
`hide_arrows`,
`hide_party`,
`lock_arrows`,
`minimap_on, minimap_off`,
`rotation_center`,
`show_arrows`,
`show_party`,
`vehicle_gfx`

## Commands by opcode

### Event commands

| Opcode | Command |
|-----:|---|
| 00-34 | [`obj_script`](#obj_script) |
|    35 | [`wait_obj`](#wait_obj) |
|    36 | `pass_off` |
|    37 | `obj_gfx` |
|    38 | `lock_camera` |
|    39 | `unlock_camera` |
|    3A | `user_ctrl_on` |
|    3B | `user_ctrl_off` |
|    3C | `party_chars` |
|    3D | `create_obj` |
|    3E | `delete_obj` |
|    3F | [`char_party`](#char_party) |
|    40 | [`char_prop`](#char_prop) |
|    41 | `show_obj` |
|    42 | `hide_obj` |
|    43 | `obj_pal` |
|    44 | [`vehicle`](#vehicle) |
|    45 | `sort_obj` |
|    46 | `activate_party` |
|    47 | `update_party` |
|    48 | `show_dlg` |
|    49 | `wait_dlg` |
|    4A | `wait_key` |
|    4B | `show_dlg` |
| 4C-4E | [`battle`](#battle) |
|    4F | `restore_save` |
| 50-53 | `mod_pal` |
|    54 | `fixed_clr` |
|    55 | `flash` |
| 56-57 | `fixed_clr` |
|    58 | `shake` |
|    59 | `fade_in` |
|    5A | `fade_out` |
|    5B | `pause_fade` |
|    5C | `wait_fade` |
| 5D-5F | `scroll_bg` |
|    60 | `map_pal` |
|    61 | `filter_pal` |
|    62 | `mosaic` |
|    63 | `flashlight` |
|    64 | `bg_anim_frame` |
|    65 | `bg_anim_speed` |
| 66-69 | (unused) |
| 6A-6B | `load_map` |
|    6C | `parent_map` |
| 6D-6F | (unused) |
| 70-72 | `scroll_bg` |
| 73-75 | `mod_bg` |
|    76 | (unused) |
|    77 | `norm_lvl` |
|    78 | `pass_on` |
|    79 | `party_map` |
|    7A | `obj_event` |
|    7B | `restore_prev_party` |
|    7C | `collision_on` |
|    7D | `collision_off` |
|    7E | `party_pos` |
|    7F | [`char_name`](#char_name) |
|    80 | `give_item` |
|    81 | `take_item` |
|    82 | `reset_prev_party` |
|    83 | (unused) |
|    84 | `give_gil` |
|    85 | `take_gil` |
|    86 | `give_genju` |
|    87 | `take_genju` |
| 88-8A | `char_status` |
|    8B | `inc_hp, dec_hp, max_hp` |
|    8C | `inc_mp, dec_mp, max_mp` |
|    8D | `remove_equip` |
|    8E | `battle` |
|    8F | `give_bushido` |
|    90 | `give_blitz` |
|    91 | `wait_15f, wait_90f` |
|    92 | `wait_30f` |
|    93 | `wait_45f` |
|    94 | `wait_60f, wait_1s` |
|    95 | `wait_120f, wait_2s` |
|    96 | `fade_in` |
|    97 | `fade_out` |
|    98 | `name_menu` |
|    99 | `party_menu` |
|    9A | `colosseum_menu` |
|    9B | `shop_menu` |
|    9C | `opt_equip` |
|    9D | `final_order` |
|    9E | (unused) |
|    9F | (unused) |
|    A0 | `start_timer` |
|    A1 | `stop_timer` |
|    A2 | `clr_overlay` |
| A3-A5 | (unused) |
|    A6 | `pyramid_off` |
|    A7 | `pyramid_on` |
| A8-AA | `cutscene` |
|    AB | `load_menu` |
|    AC | `restore_game` |
| AD-AE | `cutscene` |
|    AF | `battle` |
|    B0 | `loop_start` |
|    B1 | `loop_end` |
| B2-B3 | `call` |
|    B4 | [`wait`](#wait) |
|    B5 | `wait_15f` |
|    B6 | `choice` |
|    B7 | `if_b_switch` |
|    B8 | `set_b_switch` |
|    B9 | `clr_b_switch` |
|    BA | `ending` |
|    BB | `cutscene` |
|    BC | `loop_until` |
|    BD | `if_rand` |
|    BE | `if_case` |
|    BF | `cutscene` |
| C0-C7 | [`if_switch`](#if_switch), [`if_switch_any`](#if_switch_all-if_switch_any) |
| C8-CF | [`if_switch_all`](#if_switch_all-if_switch_any) |
| D0-DD | [`switch`](#switch) |
| DE-E4 | [`set_case`](#set_case) |
| E5-E6 | (unused) |
|    E7 | `portrait` |
|    E8 | [`set_var`](#set_var) |
|    E9 | [`add_var`](#add_var) |
|    EA | [`sub_var`](#sub_var) |
|    EB | [`cmp_var`](#cmp_var) |
| EC-EE | (unused) |
| EF-F1 | `play_song` |
|    F2 | `fade_song` |
|    F3 | `resume_song` |
| F4-F5 | `sfx` |
|    F6 | `spc_cmd` |
|    F7 | `continue_song` |
|    F8 | `wait_spc` |
|    F9 | `wait_song_pos` |
|    FA | `wait_song_end` |
|    FB | `nop` |
|    FC | (unused) |
|    FD | `dummy` |
|    FE | [`return`](#return) |
|    FF | [`end`](#end) |

### Object commands

| Opcode | Command |
|:-----:|---|
| 00-7F | `action` |
| 80-AB | `move` |
| AC-BF | (unused) |
| C0-C5 | [`speed`](#speed) |
| C6-C7 | `anim` |
|    C8 | `layer` |
|    C9 | [`vehicle`](#vehicle) |
| CA-CB | (unused) |
| CC-CF | `dir` |
|    D0 | `show_obj` |
|    D1 | `hide_obj` |
| D2-D4 | (unused) |
|    D5 | `pos` |
|    D6 | (unused) |
|    D7 | `scroll_obj` |
| D8-DB | (unused) |
| DC-DD | `jump` |
| DE-DF | (unused) |
|    E0 | `wait` |
| E1-E6 | `set_switch, clr_switch` |
| E7-F8 | (unused) |
|    F9 | `exec` |
| FA-FD | `branch` |
|    FE | (unused) |
|    FF | [`end`](#end) |

### World commands

| Opcode | Command |
|:-----:|---|
| 00-7F | `action` |
| 80-AB | `move` |
| AC-AF | (unused) |
| B0-B7 | [`if_switch`](#if_switch), [`if_switch_any`](#if_switch_all-if_switch_any) |
| B8-BF | [`if_switch_all`](#if_switch_all-if_switch_any) |
| C0-C4 | [`speed`](#speed) |
| C5-C6 | (unused) |
|    C7 | `airship_pos` |
| C8-C9 | `set_switch, clr_switch` |
| CA-CB | (unused) |
| CC-CF | `dir` |
|    D0 | `show_party` |
|    D1 | `hide_party` |
| D2-D3 | `load_map` |
|    D4 | `if_key` |
|    D5 | `if_dir` |
|    D6 | `fade_in` |
|    D7 | `fade_out` |
| D8-DC | (unused) |
|    DD | `minimap_off` |
|    DE | (unused) |
|    DF | `minimap_on` |
|    E0 | `wait` |
| E1-FB | (unused) |
|    FC | `vehicle_gfx` |
|    FD | `figaro_submerge` |
|    FE | `figaro_emerge` |
|    FF | [`end`](#end) |

### Vehicle commands

| Opcode | Command |
|:-----:|---|
| 00-7F | `move` |
| 80-AF | (unused) |
| B0-B7 | [`if_switch`](#if_switch), [`if_switch_any`](#if_switch_all-if_switch_any) |
| B8-BF | [`if_switch_all`](#if_switch_all-if_switch_any) |
|    C0 | `vehicle_flags` |
| C1-C4 | `angle` |
|    C5 | `altitude` |
|    C6 | `move_forward` |
|    C7 | `airship_pos` |
| C8-C9 | `set_switch, clr_switch` |
|    CA | `battle` |
|    D0 | `show_vehicle` |
|    D1 | `hide_vehicle` |
| D2-D3 | `load_map` |
| D4-D7 | (unused) |
|    D8 | `fade_in` |
|    D9 | `fade_out` |
|    DA | `show_arrows` |
|    DB | `lock_arrows` |
|    DC | `hide_arrows` |
|    DD | `minimap_off` |
|    DE | `rotation_center` |
|    DF | `minimap_on` |
|    E0 | `cutscene` |
| E1-F1 | (unused) |
| F2-F5 | `cutscene` |
|    F6 | `?` |
|    F7 | `vehicle_gfx` |
| F8-FC | `cutscene` |
|    FD | `vehicle_gfx` |
|    FE | `cutscene` |
|    FF | [`end`](#end) |

## Command descriptions

### `add_var`

Script modes: `E---` \
Syntax: `add_var <var_id> <value>`

Add `value` to event variable `var_id`. The result is capped at 65535.

### `battle`

Script modes: `E--V` \
Syntax: `battle <battle_id>, [battle_bg], [flags]`

Initiates a battle. The `battle_id` parameter is an event battle index,
`battle_bg` is a battle background index, and `flags` is a bitwise combination
of `BATTLE_FLAGS::NO_BLUR` to disable the blur effect, `BATTLE_FLAGS::NO_SFX`
to disable the battle sound effect, and `BATTLE_FLAGS::COLLISION` to scroll to
the party which collided with a collision-enabled NPC. Alternatively,
`battle_id` may be one of the following special values in which case
`battle_bg` and `flags` are ignored:

- `rand`: Random battle determined by the map
- `colosseum`: Colosseum battle
- `treasure` Battle determined by an opened treasure chest

### `call`

Script modes: `EOWV` \
Syntax: `call <label> [repeat]`

Call an event subroutine `label`. The optional `repeat` parameter
determines how many times the subroutine gets repeated (255 max).

### `char_name`

Script modes: `E---` \
Syntax: `char_name <char_id>, <name_id>`

Changes the name for character `char_id`. The `name_id` parameter specifies
one of the 64 character names. Character names are not initialized for a new
game, so this command must be used prior to the first time every new character
is encountered. The player may later choose to change a character's name via
the `name_menu` command or by using a Rename Card item.

### `char_party`

Script modes: `E---` \
Syntax: `char_party <char_id>, <party_id>`

Move `char_id` to `party_id`. If `party_id` is zero (no party), remove that
character from their current party. The character will be placed in the
first empty slot in that party. If the party is full, the character will
be placed in slot 4.

### `char_prop`

Script modes: `E---` \
Syntax: `char_prop <char_id>, <char_prop_id>`

Change the character properties for `char_id`. The `char_prop_id` parameter
specifies one of the 64 character properties.

### `cmp_var`

Script modes: `E---` \
Syntax: `cmp_var <var_id> <value>`

Compare the current value of event variable `var_id` to `value`. The result of
the comparison can be determined from the case variable using an `if_case`
command. The following results are possible:

- `VAR_EQUAL`: Set if `var_id` is equal to `value`
- `VAR_GREATER`: Set if `var_id` is greater than `value`
- `VAR_LESS`: Set if `var_id` is less than `value`

Two examples are shown below. The first uses an `if_case` block to check the comparison result. The second checks the first case variable directly to see if the variable is equal to 50.

```text
example1:
        cmp_var VAR_1, 50
        if_case
                case VAR_EQUAL, is_equal
                case VAR_GREATER, is_greater
                case VAR_LESS, is_less
                end_case
        return

example2:
        cmp_var VAR_1, 50
        if_switch $01a0=1, is_equal
        return

is_equal:
        return

is_greater:
        return

is_less:
        return
```

### `end`

Script modes: `EOWV` \
Syntax: `end`

Marks the end of the script. In object (O) mode, the specified object reverts
to its default behavior. The event script will resume execution if it was
waiting for that object via an `obj_wait` command or a script with the `AWAIT`
flag set.

### `exec`

Script modes: `-O--` \
Syntax: `exec <label>`

Execute the event `label` from within an object script. This command is
typically used when a script-controlled NPC reaches its destination and
triggers an event (i.e. multi-party battles in Narshe).

### `goto`

Script modes: `E-WV` \
Syntax: `goto <label>`

This instruction serves as a terminator for a conditional block of
[`switch`](#switch) statements initiated by an
[`if_switch_all`](#if_switch_all-if_switch_any) or
[`if_switch_any`](#if_switch_all-if_switch_any) instruction. If the
corresponding condition is true (all/any of the switch statements are true),
event execution jumps to `label`.

### `obj_script`

Script modes: `E---` \
Syntax: `obj_script <obj> [flags]`

Begin a synchronous or asynchronous script for object `obj`. This command
automatically changes the script mode from event (E) to object (O). The `flags`
parameter may be one of the following:

- `AWAIT`: Event execution does not continue until object script terminates (default)
- `ASYNC`: Event execution continues while object script executes

### `if_switch`

Script modes: `E-WV` \
Syntax: `if_switch <switch_id>=<0 or 1>, <label>`

Jump to `label` if event switch `switch_id` has the value specified. This command only checks a single switch. To check multiple switches, use a `if_switch_any` or `if_switch_all` block.

### `if_switch_all`, `if_switch_any`

Script modes: `E-WV` \
Syntax: `if_switch_all`

Starts a block of [`switch`](#switch) statements and conditionally jumps to label specified
by the [`goto`](#goto) instruction at the end of the block. For `if_switch_all`, the
jump occurs if *all* of the switch conditions are met (logical AND). For
`if_switch_all`, the jump occurs if *any* of the switch conditions are met
(logical OR).

```text
example:
        if_switch_all
                switch SWITCH_1=0
                switch SWITCH_2=1
                goto all_true
        return

; go here if both switch statements are true
all_true:
        return
```

### `return`

Script modes: `E---` \
Syntax: `return`

Marks the end of an event subroutine and returns to the point where the subroutine was called.

### `set_case`

Script modes: `E---` \
Syntax: `set_case <case>`

Initialize the case variable prior to an if_case command. The `case`
parameter may be one of the following:

- `PARTY_CHARS`: All characters in the currently active party
- `OBJ_CHARS`: All characters that are currently active objects
- `INIT_CHARS`: All initialized characters (name, properties, etc.)
- `AVAIL_CHARS`: All characters that are available in the party select menu
- `TOP_CHAR`: The topmost character in the party
- `ALL_PARTIES`: All characters in any party
- `CURR_PARTY`: Sets a switch for the currently active party index

### `set_var`

Script modes: `E---` \
Syntax: `set_var <var_id> <value>`

Set event variable `var_id` to `value`.

### `speed`

Script modes: `-OW-` \
Syntax: `speed <speed>`

Set the movement speed of an object. The speed parameter must be one of the following:

- `SLOWER`: 1 pixel every 4 frames
- `SLOW`: 1 pixel every 2 frames
- `NORMAL`: 1 pixel per frame (normal walking speed)
- `FAST`: 2 pixels per frame (sprint shoes speed)
- `FASTER`: 4 pixels per frame
- `FASTEST`: 8 pixels per frame (object mode only)

### `sub_var`

Script modes: `E---` \
Syntax: `sub_var <var_id> <value>`

Subtract `value` from event variable `var_id`. If the result is less than zero,
the variable will be set to zero.

### `switch`

Script modes: `EOWV` \
Syntax: `switch <switch_id>=<0 or 1>`

The `switch` instruction has two different functions depending on where it
is executed. Normally, it simply sets the value of `switch_id` to the
specified value of 0 or 1. Inside of an [`if_switch_all`](#if_switch_all-if_switch_any) or [`if_switch_any`](#if_switch_all-if_switch_any)
block, the value of `switch_id` is compared to the specified value of 0 or 1
to determine whether the conditional block is true or not.

### `vehicle`

Script modes: `EO--` \
Syntax (event mode): `vehicle <obj_id>, <vehicle>, [flags]` \
Syntax (object mode): `vehicle <vehicle>, [flags]`

Set the vehicle shown for an object. The `vehicle` parameter can be one of the following: `NONE`, `CHOCOBO`, `MAGITEK`, or `RAFT`. The optional `flags` parameter can be either `HIDE_RIDER` (default) or `SHOW_RIDER` to hide or show the rider sprite.

Note that changing a character's vehicle to magitek armor has no effect in battle. To use magitek armor in battle, inflict the magitek status via the `set_status` command.

When setting an object's vehicle to `NONE`, the `HIDE_RIDER` flag should normally be used. The `SHOW_RIDER` flag in conjunction with no vehicle identifies objects with special graphics, but this combination should only be used in NPC properties and not in the event script.

### `wait`

Script modes: `EOWV` \
Syntax: `wait <duration>`

Pause event execution for a specified number of frames/time. Event (E),
world (W), and vehicle (V) script modes operate at 60 frames per second,
so a duration of 60 frames will last 1 second in real-time. Object (O)
script mode operates at 15 frames per second, so a duration of 60 frames
will last 4 seconds in real-time.

### `wait_obj`

Script modes: `E---` \
Syntax: `wait_obj <obj>`

Pause event execution until the object script for object `obj` terminates. Has
no effect if there is currently no script running for `obj`.

## Constants

### `char_id`

- Main characters:
TERRA, LOCKE, CYAN, SHADOW, EDGAR, SABIN, CELES, STRAGO, RELM, SETZER, MOG, GAU, GOGO, UMARO
- Extra moogles:
KUPEK, KUPOP, KUMAMA, KUKU, KUTAN, KUPAN, KUSHU, KURIN, KURU, KAMOG
- Phantom train ghosts: GHOST_1, GHOST_2
- Other characters: WEDGE, BANON, MADUIN, VICKS, LEO, KEFKA

### `obj`

- NPCs: NPC_1 through NPC_32
- Camera object: CAMERA
- Character slots in the active party: SLOT_1, SLOT_2, SLOT_3, SLOT_4
