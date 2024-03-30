; ------------------------------------------------------------------------------

.include "const.inc"
.include "hardware.inc"
.include "event_cmd.inc"
.include "macros.inc"

.include "sound/song_script.inc"

; ------------------------------------------------------------------------------

.export EventScript
.export EventScript_NoEvent := NoEvent
.export EventScript_WaitDlg := WaitDlg
.export EventScript_GameStart := GameStart_ext
.export EventScript_TreasureItem := TreasureItem
.export EventScript_TreasureMagic := TreasureMagic
.export EventScript_TreasureGil := TreasureGil
.export EventScript_TreasureEmpty := TreasureEmpty
.export EventScript_RandBattle := RandBattle
.export EventScript_GameOver := GameOver_ext
.export EventScript_Tent := Tent_ext
.export EventScript_Warp := Warp_ext
.export EventScript_TreasureMonster := TreasureMonster
.export EventScript_WorldTent := WorldTent_ext
.export EventScript_AirshipGround := AirshipGround
.export EventScript_AirshipDeck := AirshipDeck
.export EventScript_EnterKefkasTower := EnterKefkasTower_ext
.export EventScript_EnterPhoenixCave := EnterPhoenixCave_ext
.export EventScript_EnterGogosLair := EnterGogosLair
.export EventScript_DoomGazeDefeated := DoomGazeDefeated

; ------------------------------------------------------------------------------

.segment "event_script"

begin_fixed_block EventScript, $02e600

; ------------------------------------------------------------------------------

; ca/0000
.proc NoEvent
        no_event
.endproc  ; NoEvent

; ------------------------------------------------------------------------------

; ca/0001
.proc WaitDlg
	wait_dlg
	return
.endproc

; ------------------------------------------------------------------------------

; ca/0003
.proc GameStart_ext
	call GameStart
	return
.endproc

; ------------------------------------------------------------------------------

; ca/0008
.proc TreasureItem
	dlg $0b85
	return
.endproc

; ------------------------------------------------------------------------------

; ca/000c
.proc TreasureMagic
	dlg $0b86
	return
.endproc

; ------------------------------------------------------------------------------

; ca/0010
.proc TreasureGil
	dlg $0b87
	return
.endproc

; ------------------------------------------------------------------------------

; ca/0014
.proc TreasureEmpty
	dlg $0b88
	return
.endproc

; ------------------------------------------------------------------------------

; ca/0018
.proc RandBattle
	obj_script SLOT_2, ASYNC
	        scroll_obj
	        end
	obj_script SLOT_3, ASYNC
	        scroll_obj
	        end
	obj_script SLOT_4, ASYNC
	        scroll_obj
	        end
	obj_script SLOT_1
	        scroll_obj
	        end
	rand_battle
	if_b_switch $40, :+

game_over:
	call GameOver
:       update_party
	return
.endproc  ; RandBattle

GameOver_ext := RandBattle::game_over

; ------------------------------------------------------------------------------

; ca/0034
.proc Tent_ext
        call Tent
        return
.endproc

; ------------------------------------------------------------------------------

; ca/0039
.proc Warp_ext
        if_switch $0127=0, Warp
        return
.endproc

; ------------------------------------------------------------------------------

; ca/0040
.proc TreasureMonster
        dlg $0b90
        call $cb0e1c
        treasure_battle
        call $ca5ea9
        update_party
        fade_in
        return
.endproc

; ------------------------------------------------------------------------------

; ca/004f
.proc WorldTent_ext
        set_script_mode WORLD
        fade_out
        wait 2
        load_map 3, 8, 8, UP, $06, 0
        set_script_mode EVENT
        return
.endproc

; ------------------------------------------------------------------------------

; ca/0059
.proc AirshipGround
        set_script_mode WORLD
        if_all
                switch $009d=1
                switch $009e=0
                goto $ca5ad4
        load_map 7, 8, 35, UP, $02, 0
        set_script_mode EVENT
        return
.endproc

; ------------------------------------------------------------------------------

; ca/0068
.proc AirshipDeck
        set_script_mode WORLD
        switch $0246=1

; blackjack
        if_switch $00a4=1, :+
        load_map 6, 16, 6, UP, $22, $80
        set_script_mode EVENT
        return

; falcon
:       set_script_mode WORLD
        load_map 11, 16, 8, UP, $32, $80
        set_script_mode EVENT
        return
.endproc  ; AirshipDeck

; ------------------------------------------------------------------------------

; ca/007f
.proc EnterKefkasTower_ext
        set_script_mode WORLD
        .byte $20, $40
; CA/007F: 20        Move vehicle as follows: (go up), 64 units
        load_map 17, 15, 8, UP, $36, 0
        set_script_mode EVENT
        return
.endproc

; ------------------------------------------------------------------------------

; ca/0088
.proc EnterPhoenixCave_ext
        set_script_mode WORLD
        load_map 17, 16, 8, UP, $36, 0
        set_script_mode EVENT
        return
.endproc

; ------------------------------------------------------------------------------

; ca/008f
.proc EnterGogosLair
        set_script_mode WORLD
        load_map $0114, 10, 12, UP, $06, $80
        set_script_mode EVENT
        return
.endproc

; ------------------------------------------------------------------------------

; ca/0096
.proc DoomGazeDefeated
        set_script_mode WORLD
        load_map 17, 17, 8, UP, $36, $01
        set_script_mode EVENT
        return
.endproc

; ------------------------------------------------------------------------------

; ca/009d
.proc DoomGazeMagicite
        create_obj NPC_3
        show_obj NPC_3
        sort_obj
        obj_script SLOT_1
                dir LEFT
                speed NORMAL
                end
        obj_script NPC_3
                speed FASTER
                move RIGHT_RIGHT_DOWN, 6
                speed NORMAL
                jump_high
                move RIGHT, 2
                speed SLOW
                jump_low
                move RIGHT, 1
                end
        obj_script SLOT_1
                dir RIGHT
                end
        wait_1s
        call $cac810, 3
        wait_45f
        dlg $0b9e
        obj_script SLOT_1
                move RIGHT, 2
                dir DOWN
                end
        pass_off SLOT_1
        pass_off NPC_3
        obj_script NPC_3
                speed SLOWER
                move UP, 1
                hide_obj
                end
        sfx 141
        flash WHITE
        obj_script SLOT_1
                action $10
                end
        pass_on SLOT_1
        dlg $0b9f
        give_genju BAHAMUT
        load_map_fade $01ff, 0, 0, UP, $24, 1
        set_script_mode WORLD
        end
.endproc  ; DoomGazeMagicite

        set_script_mode EVENT

; ------------------------------------------------------------------------------

; [ Tent ]

; ca/00ea
.proc Tent
        fade_in
        fade_song $30
        obj_script SLOT_1, ASYNC
                action 9
                wait 6
                action 39
                end
        play_song_pause SONG_NIGHTY_NIGHT
        call $cacfbd
        wait_song_end
        resume_song $10
        obj_script SLOT_1
                action 9
                end
        wait_1s
        call $cac7fe, 3
        return
.endproc

; ------------------------------------------------------------------------------

; [ Warp/Warp Stone ]

; ca/0108
.proc Warp
        sfx 76
        loop 2
                obj_script SLOT_1
                        dir RIGHT
                        end
                obj_script SLOT_1
                        dir UP
                        end
                obj_script SLOT_1
                        dir LEFT
                        end
                obj_script SLOT_1
                        dir DOWN
                        end
                end_loop
        fade_out
        loop 2
                obj_script SLOT_1
                        dir RIGHT
                        end
                obj_script SLOT_1
                        dir UP
                        end
                obj_script SLOT_1
                        dir LEFT
                        end
                obj_script SLOT_1
                        dir DOWN
                        end
                end_loop
        wait_fade
        switch $01cc=0
        switch $01cd=0
        switch $02bc=0
        if_switch $02bf=1, phoenix_cave_warp
        if_switch $02be=1, kefkas_tower_warp
        call reset_turtles
        load_map $01ff, 0, 0, UP, $24, 0
        set_script_mode WORLD
        end
        set_script_mode EVENT

; warp event when in kefka's tower
kefkas_tower_warp:
        call $cc0ff6
        return

; warp event when in phoenix cave
phoenix_cave_warp:
        call $cc1001
        return

; reset some turtles when in darill's tomb
reset_turtles:
        switch $02b4=0
        switch $02b6=0
        return
.endproc  ; Warp

; ------------------------------------------------------------------------------

; [ Tent (world map) ]

.proc WorldTent
        switch $01c2=0
        play_song_pause SONG_NIGHTY_NIGHT
        obj_script SLOT_1
                action 9
                wait 6
                action 39
                end
        call $cacfbd
        wait_song_end
        resume_song $10
        obj_script SLOT_1
                action 9
                end
        wait_1s
        call $cac7fe, 3
        wait_30f
        load_map_fade $01fe, 0, 0, UP, $24, 0
        set_script_mode WORLD
        end
.endproc  ; WorldTent

        set_script_mode EVENT

; ------------------------------------------------------------------------------

.proc EnterKefkasTower_proc

strago_dlg:
        obj_script STRAGO
                speed SLOW
                move LEFT, 1
                action 34
                end
        obj_script EDGAR
                dir RIGHT
                end
        dlg $0ba6, BOTTOM
        return

celes_dlg:
        obj_script CELES
                dir DOWN
                end
        dlg $0ba5, BOTTOM
        return

skip_dlg:
        dlg $0b8d
        if_switch $0127=0, $ca02d5
        return

start:  if_switch $0029=1, skip_dlg
        dlg $0b8d
        load_map_fade 1, 137, 198, DOWN, $24, 1
        set_script_mode VEHICLE
; CA/01B1: C5        Set vehicle height to $7E (max is $7E), (unknown byte $00)
        .byte $C5,$00,$7E
; CA/01B4: 40        Move vehicle as follows: (go down), 56 units
        .byte $40,$38
; CA/01B6: C7        Place airship at position (137, 199)
        .byte $C7,$89,$C7
        load_map 17, 15, 8, DOWN, $36, $40
        set_script_mode EVENT
        lock_camera
        call $cac90b
        call $cac9ed
        if_switch $02f0=0, :+
        obj_script TERRA, ASYNC
                pos 21, 7
                dir DOWN
                end
:       if_switch $02f1=0, :+
        obj_script LOCKE, ASYNC
                pos 23, 9
                dir LEFT
                end
:       if_switch $02f2=0, :+
        obj_script CYAN, ASYNC
                pos 24, 7
                dir LEFT
                end
:       if_switch $02f3=0, :+
        obj_script SHADOW, ASYNC
                pos 25, 9
                dir LEFT
                end
:       if_switch $02f4=0, :+
        obj_script EDGAR, ASYNC
                pos 16, 8
                dir DOWN
                end
:       if_switch $02f5=0, :+
        obj_script SABIN, ASYNC
                pos 14, 6
                dir LEFT
                end
:       if_switch $02f6=0, :+
        obj_script CELES, ASYNC
                pos 17, 8
                dir LEFT
                end
:       if_switch $02f7=0, :+
        obj_script STRAGO, ASYNC
                pos 18, 9
                dir DOWN
                end
:       if_switch $02f8=0, :+
        obj_script RELM, ASYNC
                pos 11, 7
                dir LEFT
                end
:       if_switch $02f9=0, :+
        obj_script SETZER, ASYNC
                pos 15, 8
                action 10
                end
:       hide_obj MOG
        hide_obj GAU
        hide_obj GOGO
        hide_obj UMARO
        wait_2s
        fade_in
        obj_script CELES
                dir DOWN
                end
        obj_script EDGAR
                speed NORMAL
                move DOWN, 1
                wait 8
                action 25
                end
        dlg $0ba0
        wait_30f
        obj_script CELES
                action 32
                wait 8
                speed SLOW
                move UP, 2
                action 28
                end
        obj_script SETZER, ASYNC
                action 35 | ACTION_H_FLIP
                end
        obj_script EDGAR
                action 35 | ACTION_H_FLIP
                end
        dlg $0ba1, BOTTOM
        wait_90f
        obj_script CELES
                dir LEFT
                end
        wait_1s
        dlg $0ba2, BOTTOM
        obj_script EDGAR
                move UP, 2
                end
        dlg $0ba3, BOTTOM
        wait_30f
        loop 3
                obj_script CELES
                        action 21
                        end
                obj_script CELES
                        dir LEFT
                        end
                end_loop
        wait_30f
        obj_script CELES
                action 34
                end
        dlg $0ba4, BOTTOM
        set_case AVAIL_CHARS
        if_case
                case CHAR::STRAGO, strago_dlg
                case CHAR::CELES, celes_dlg
                end_case
        obj_script EDGAR
                dir RIGHT
                end
        wait_1s
        loop 3
                obj_script EDGAR
                        action 21 | ACTION_H_FLIP
                        end
                obj_script EDGAR
                        dir RIGHT
                        end
                end_loop
        wait_30f
        dlg $0ba7, BOTTOM
        wait_45f
        obj_script CELES
                action 35 | ACTION_H_FLIP
                end
        dlg $0ba8, BOTTOM
        if_switch $01a0=0, :+
        obj_script CAMERA
                speed NORMAL
                move RIGHT, 2
                speed SLOW
                move RIGHT, 1
                speed SLOWER
                move RIGHT, 1
                end
        obj_script TERRA
                action 32
                end
:       wait_2s
        call $cacbaf
        party_menu 3
        load_map 17, 15, 8, LEFT, $34, $40
        set_party_map 3, 17
        call _ca0429
        activate_party 3
        sort_obj
        update_party
        obj_script SLOT_1
                pos 17, 10
                end
        show_obj SLOT_1
        update_party
        call _ca0456
        activate_party 3
        sort_obj
        call _ca0469
        fade_out
        wait_fade
        activate_party 1
        sort_obj
        switch $01cc=1
        load_map $014e, 11, 7, LEFT, $34, $c0
        switch $01cc=0
        lock_camera
        hide_obj SLOT_1
        set_party_map 2, $014e
        set_party_map 3, $014e
        activate_party 2
        sort_obj
        obj_script SLOT_1
                pos 43, 7
                end
        show_obj SLOT_1
        sort_obj
        update_party
        activate_party 3
        sort_obj
        obj_script SLOT_1
                pos 56, 9
                end
        show_obj SLOT_1
        sort_obj
        update_party
        activate_party 1
        sort_obj
        show_obj SLOT_1
        obj_script SLOT_1
                pos 11, 0
                action 22
                speed FAST
                end
        update_party
        fade_in
        obj_script CAMERA, ASYNC
                speed NORMAL
                move DOWN, 7
                end
        obj_script SLOT_1
                anim_off
                layer 2
                move DOWN, 10
                action 31
                speed FAST
                jump_high
                move LEFT_DOWN_DOWN, 2
                speed NORMAL
                jump_high
                move DOWN, 2
                action 9
                anim_on
                layer 0
                end
        activate_party 2
        sort_obj
        update_party
        wait_obj CAMERA
        obj_script CAMERA, ASYNC
                speed FAST
                move RIGHT, 26
                move RIGHT_RIGHT_DOWN, 3
                end
        wait_15f 14
        obj_script SLOT_1
                speed FASTER
                layer 2
                action 31
                anim_off
                move DOWN, 14
                action 9
                anim_on
                layer 0
                end
        wait_obj CAMERA
        activate_party 3
        sort_obj
        update_party
        fade_song $40
        obj_script CAMERA, ASYNC
                move RIGHT, 8
                move RIGHT_DOWN, 5
                end
        wait_45f
        obj_script SLOT_1
                move DOWN, 13
                action 9 | ACTION_H_FLIP
                anim_on
                end
        wait_obj CAMERA
        activate_party 1
        sort_obj
        update_party
        load_map_fade $014e, 9, 16, LEFT, $34, $80
        unlock_camera
        if_switch $0029=1, :+
        dlg $0b92
:       dlg $0b93, {BOTTOM, TEXT_ONLY}
        switch $01ce=1
        switch $02be=1
        switch $0029=1
        return
.endproc  ; EnterKefkasTower_proc

EnterKefkasTower := EnterKefkasTower_proc::start

; ------------------------------------------------------------------------------

_ca03ba:
        if_any
                switch $01b0=0
                switch $01b4=0
                switch $01f0=0
                goto EventReturn
        call _ca03e7
        return

_ca03c9:
        if_any
                switch $01b0=0
                switch $01b4=0
                switch $01f1=0
                goto EventReturn
        call _ca03e7
        return

_ca03d8:
        if_any
                switch $01b0=0
                switch $01b4=0
                switch $01f2=0
                goto EventReturn
        call _ca03e7
        return

_ca03e7:
        lock_camera
        obj_script NPC_1, ASYNC
                wait 1
                end
        obj_script SLOT_1
                jump_low
                move UP, 1
                action 15
                anim_off
                end
        obj_script NPC_1, ASYNC
                move UP, 8
                end
        obj_script SLOT_1
                speed SLOW
                move UP, 8
                anim_on
                end
        fade_out
        wait_fade
        call $cc2109
        return

; ------------------------------------------------------------------------------

.proc EnterPhoenixCave
        obj_script SLOT_1
                move DOWN, 2
                end
        dlg $0b8d
        call $cacbaf
        party_menu 2
        call _ca0429
        call _ca0456
        load_map_fade $013e, 8, 7, DOWN, $20, $c0
        call $cc2090
        switch $02bf=1
        return
.endproc  ; EnterPhoenixCave

; ------------------------------------------------------------------------------

.proc _ca0429
        call $cacca4
        hide_obj SLOT_1
        set_party_map 1, 17
        set_party_map 2, 17
        sort_obj
        lock_camera
        activate_party 1
        sort_obj
        update_party
        obj_script SLOT_1
                pos 15, 10
                dir DOWN
                end
        show_obj SLOT_1
        update_party
        activate_party 2
        sort_obj
        update_party
        obj_script SLOT_1
                pos 16, 10
                dir DOWN
                end
        show_obj SLOT_1
        update_party
        return
.endproc  ; _ca0429

; ------------------------------------------------------------------------------

.proc _ca0456
        activate_party 1
        sort_obj
        update_party
        fade_in
        wait_fade
        call _ca0469
        activate_party 2
        sort_obj
        update_party
        call _ca0469
        return
.endproc

; ------------------------------------------------------------------------------

.proc _ca0469
        update_party
        obj_script SLOT_1
                action 9
                wait 3
                layer 2
                speed NORMAL
                action 22
                anim_off
                jump_high
                move DOWN, 2
                speed FASTER
                move DOWN, 7
                anim_on
                layer 0
                end
        return
.endproc

; ------------------------------------------------------------------------------

.proc _ca047d
        call $cacb9f
        player_ctrl_off
        update_party
        load_map 11, 16, 8, LEFT, $30, $80
        return
.endproc

; ------------------------------------------------------------------------------

; [ final battle & ending ]

; ca/048a
.proc FinalBattle_proc

_ca048a:
        mod_bg BG1, 8, 19, 15, 13
        .res 15*13, 0
        return

_ca0553:
        obj_script SLOT_1
                pos 15, 27
                end
        show_obj SLOT_1
        sort_obj
        return

_ca055d:
        call $cac6ac
        obj_script SLOT_1, ASYNC
                speed NORMAL
                dir UP
                end
        obj_script SLOT_2, ASYNC
                speed NORMAL
                move LEFT, 1
                dir UP
                end
        obj_script SLOT_3, ASYNC
                speed NORMAL
                move RIGHT, 1
                dir UP
                end
        obj_script SLOT_4, ASYNC
                speed NORMAL
                move DOWN, 1
                dir UP
                end
        wait_45f
        activate_party 3
        sort_obj
        return

; ca/057d
start:
        load_map $0150, 15, 20, DOWN, $24, $40
        lock_camera
        play_song SONG_SILENCE
        spc_cmd $11,$4d,$a0
        sfx 251
        spc_cmd $82,$20,$60
        mod_bg_pal MOD_PAL_DEC_FLASH, MOD_PAL_WHITE, 0, 5, 7
        set_party_map 1, $0150
        set_party_map 2, $0150
        set_party_map 3, $0150
        hide_obj SLOT_1
        hide_obj SLOT_2
        hide_obj SLOT_3
        hide_obj SLOT_4
        activate_party 3
        sort_obj
        obj_script SLOT_1
                pos 0, 0
                end
        show_obj SLOT_1
        sort_obj
        activate_party 2
        sort_obj
        obj_script SLOT_1
                pos 0, 0
                end
        show_obj SLOT_1
        sort_obj
        activate_party 1
        sort_obj
        obj_script SLOT_1
                pos 15, 27
                end
        show_obj SLOT_1
        sort_obj
        fade_in
        obj_script SLOT_1
                speed NORMAL
                move UP, 5
                end
        call $cac6ac
        obj_script SLOT_1, ASYNC
                speed NORMAL
                move UP, 1
                end
        obj_script SLOT_2, ASYNC
                speed NORMAL
                move LEFT, 1
                dir UP
                end
        obj_script SLOT_3, ASYNC
                speed NORMAL
                move RIGHT, 1
                dir UP
                end
        obj_script SLOT_4, ASYNC
                speed NORMAL
                dir UP
                end
        wait_45f
        lock_camera
        activate_party 2
        sort_obj
        call _ca0553
        obj_script SLOT_1
                speed NORMAL
                move UP, 3
                move LEFT_LEFT_UP
                move LEFT_UP
                end
        call _ca055d
        call _ca0553
        obj_script SLOT_1
                speed NORMAL
                move UP, 3
                move RIGHT_RIGHT_UP
                move RIGHT_UP
                end
        call _ca055d
        call $caf28d
        obj_script CAMERA
        speed SLOW
        move UP, 14
        end
        wait_1s
        spc_cmd $82,$00,$ff
        sfx 205
        dlg $0ba9, TEXT_ONLY
        obj_script CAMERA
                move DOWN, 3
                end
        sfx 212
        pyramid_on NPC_1
        fixed_clr BLUE, 0, 2
        wait_15f
        loop 31
                mod_bg_pal MOD_PAL_UNDEC, MOD_PAL_WHITE, 3, 5, 7
                wait 2
                end_loop
        mod_sprite_pal MOD_PAL_DEC_FLASH, MOD_PAL_WHITE, 0, 48, 63
        create_obj NPC_1
        show_obj NPC_1
        sort_obj
        obj_script NPC_1, ASYNC
                action $1d
                end
        wait_30f
        loop 31
                mod_sprite_pal MOD_PAL_UNDEC, MOD_PAL_WHITE, 0, 48, 63
                wait 2
                end_loop
        sfx 251
        spc_cmd $82, $20, $60
        wait_30f
        dlg $0baa, TEXT_ONLY
        obj_script CAMERA
                move DOWN, 7
                end
        dlg $0bab, {BOTTOM, TEXT_ONLY}
        call $cac819
        call $cac853
        pass_off NPC_2
        pass_off NPC_3
        pass_off NPC_4
        pass_off NPC_5
        obj_script NPC_1
                action 9 | ACTION_H_FLIP
                wait 3
                action 16
                end
        obj_script SLOT_1, ASYNC
                speed FASTER
                action 31
                anim_off
                move LEFT_LEFT_UP, 2
                move LEFT_UP
                move LEFT_UP_UP, 2
                action 11
                speed SLOWER
@loop:          move UP, 1
                move DOWN, 1
                branch @loop
                end
        wait_15f
        obj_script NPC_1
                action 22
                end
        dlg $0bac, {BOTTOM, TEXT_ONLY}
        activate_party 2
        sort_obj
        obj_script NPC_1
                action 9
                wait 3
                action 16 | ACTION_H_FLIP
                end
        obj_script SLOT_1, ASYNC
                speed FASTER
                action 31
                anim_off
                move RIGHT_RIGHT_UP, 2
                move RIGHT_UP
                move RIGHT_UP_UP, 2
                action 11
                speed SLOWER
@loop2:         move UP, 1
                move DOWN, 1
                branch @loop2
                end
        wait_15f
        obj_script NPC_1
                action 22
                end
        dlg $0bad, {BOTTOM, TEXT_ONLY}
        obj_script NPC_1
                action 25
                wait 2
                action 16
                end
        obj_script SLOT_1
                speed FASTER
                action 31
                move LEFT_DOWN_DOWN
                action 11
                speed FAST
                jump_high
                move LEFT_DOWN_DOWN, 2
                jump_high
                move DOWN, 4
                action 40
                anim_on
                end
        activate_party 3
        sort_obj
        obj_script NPC_1
                action 9
                wait 2
                action 25 | ACTION_H_FLIP
                wait 2
                action 16 | ACTION_H_FLIP
                end
        obj_script SLOT_1
                speed FASTER
                action 31
                move RIGHT_DOWN_DOWN
                action 11
                speed FAST
                jump_high
                move RIGHT_DOWN_DOWN, 2
                jump_high
                move DOWN, 4
                action 40
                anim_on
                end
        activate_party 1
        sort_obj
        obj_script SLOT_1
                move UP, 2
                end
        dlg $0bae, {TEXT_ONLY, BOTTOM}
        obj_script CAMERA, ASYNC
                move UP, 8
                end
        wait_1s
        fixed_clr BLACK, 0, 2
        loop 31
                mod_bg_pal MOD_PAL_DEC, MOD_PAL_WHITE, 3, 5, 7
                end_loop
        obj_script NPC_1
                dir RIGHT
                wait 4
                action 23
                end
        dlg $0baf, {TEXT_ONLY, ASYNC}
        wait_45f
        wait_obj CAMERA
        loop 31
                mod_bg_pal MOD_PAL_DEC, MOD_PAL_WHITE, 3, $50, $5f
                wait 1
                end_loop
        mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $5e, $5e
        loop 2
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $5d, $5d
                end_loop
        loop 3
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $5c, $5c
                end_loop
        loop 4
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $5b, $5b
                end_loop
        loop 5
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $5a, $5a
                end_loop
        loop 6
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $59, $59
                end_loop
        loop 7
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $58, $58
                end_loop
        loop 8
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $57, $57
                end_loop
        loop 9
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $56, $56
                end_loop
        loop 10
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $55, $55
                end_loop
        loop 11
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $54, $54
                end_loop
        loop 12
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $53, $53
                end_loop
        loop 13
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $52, $52
                end_loop
        loop 14
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $51, $51
                end_loop
        loop 15
                mod_bg_pal MOD_PAL_INC, MOD_PAL_BLUE, 3, $5f, $5f
                end_loop
        wait_dlg
        fixed_clr {RED, BLUE}, 0, 2
        wait_15f
        loop 31
                mod_bg_pal MOD_PAL_UNDEC, MOD_PAL_WHITE, 3, 5, 7
                wait 2
                end_loop
        obj_script NPC_1, ASYNC
                wait 8
                dir RIGHT
                end
        set_case ALL_PARTIES
        if_case
                case CHAR::TERRA, $ca3a0a
                case CHAR::LOCKE, $ca3a18
                case CHAR::EDGAR, $ca3a26
                case CHAR::CELES, $ca3a34
                case CHAR::SABIN, $ca3a42
                case CHAR::CYAN, $ca3a50
                case CHAR::SHADOW, $ca3a5e
                case CHAR::STRAGO, $ca3a6c
                case CHAR::RELM, $ca3a7a
                case CHAR::SETZER, $ca3a88
                case CHAR::MOG, $ca3a96
                case CHAR::GAU, $ca3aa4
                case CHAR::GOGO, $ca3ab2
                case CHAR::UMARO, $ca3ac0
                end_case
        obj_script NPC_1
                action 16 | ACTION_H_FLIP
                end
        wait_1s
        obj_script NPC_1
                action 27
                wait 1
                dir LEFT
                end
        if_case
                case CHAR::TERRA, $ca3ace
                case CHAR::LOCKE, $ca3ae8
                case CHAR::EDGAR, $ca3b02
                case CHAR::CELES, $ca3b1c
                case CHAR::SABIN, $ca3b36
                case CHAR::CYAN, $ca3b50
                case CHAR::SHADOW, $ca3b6a
                case CHAR::STRAGO, $ca3b84
                case CHAR::RELM, $ca3b9e
                case CHAR::SETZER, $ca3bb8
                case CHAR::MOG, $ca3bd2
                case CHAR::GAU, $ca3bec
                case CHAR::GOGO, $ca3c06
                case CHAR::UMARO, $ca3c20
                end_case
        fixed_clr BLACK, 0, 2
        loop 4
                obj_script NPC_1
                        action 21
                        end
                obj_script NPC_1
                        dir LEFT
                        end
                end_loop
        dlg $0bb2, TEXT_ONLY
        wait_1s
        fixed_clr GREEN, 0, 2
        if_case
                case CHAR::TERRA, $ca3c3a
                case CHAR::LOCKE, $ca3c4e
                case CHAR::EDGAR, $ca3c62
                case CHAR::CELES, $ca3c76
                case CHAR::SABIN, $ca3c8a
                case CHAR::CYAN, $ca3c9e
                case CHAR::SHADOW, $ca3cb2
                case CHAR::STRAGO, $ca3cc6
                case CHAR::RELM, $ca3cda
                case CHAR::SETZER, $ca3cee
                case CHAR::MOG, $ca3d02
                case CHAR::GAU, $ca3d16
                case CHAR::GOGO, $ca3d2a
                case CHAR::UMARO, $ca3d3e
                end_case
        activate_party 2
        sort_obj
        obj_script SLOT_1
                pos 18, 22
                dir UP
                end
        activate_party 3
        sort_obj
        obj_script SLOT_1
                pos 12, 22
                dir UP
                end
        activate_party 1
        sort_obj
        obj_script SLOT_1
                pos 15, 21
                dir UP
                end
        obj_script NPC_1, ASYNC
                dir DOWN
                end
        obj_script CAMERA
                speed SLOW
                move DOWN, 9
                end
        if_case CHAR::TERRA, $ca3d52
        if_case CHAR::LOCKE, $ca3d56
        if_case CHAR::CYAN, $ca3d5a
        if_case CHAR::SHADOW, $ca3d5e
        if_case CHAR::EDGAR, $ca3d62
        if_case CHAR::SABIN, $ca3d66
        if_case CHAR::CELES, $ca3d6a
        if_case CHAR::STRAGO, $ca3d6e
        if_case CHAR::RELM, $ca3d72
        if_case CHAR::SETZER, $ca3d76
        if_case CHAR::MOG, $ca3d7a
        if_case CHAR::GAU, $ca3d7e

; CA/0893: 56    Increase color component(s) 26 (Black), at intensity 10

.endproc  ; FinalBattle_proc

FinalBattle := FinalBattle_proc:: start

; ------------------------------------------------------------------------------

        GameStart := $ca5e33
        EventReturn := $ca5eb3

        .incbin "event_script.dat"

; ------------------------------------------------------------------------------

; [ restore party hp/mp/status ]

; cc/e499
.proc RestoreParty
        max_hp SLOT_1
        max_hp SLOT_2
        max_hp SLOT_3
        max_hp SLOT_4
        max_mp SLOT_1
        max_mp SLOT_2
        max_mp SLOT_3
        max_mp SLOT_4
        and_status SLOT_1, INTERCEPTOR
        and_status SLOT_2, INTERCEPTOR
        and_status SLOT_3, INTERCEPTOR
        and_status SLOT_4, INTERCEPTOR
        return
.endproc

; ------------------------------------------------------------------------------

; [ init floating continent variables ]

; cc/e4c2
.proc _cce4c2
        switch $0636=0
        switch $062b=0
        switch $062f=0
        switch $0630=0
        switch $0634=0
        switch $0652=0
        switch $065f=0
        switch $0661=0
        switch $063c=0
        switch $0637=0
        switch $0638=0
        return
.endproc

; ------------------------------------------------------------------------------

; [ init world of ruin variables ]

; cc/e4d9
.proc _cce4d9

; number of dragons remaining
        set_var 6, 8

; reset all character object events
        obj_event TERRA, EventReturn
        obj_event LOCKE, EventReturn
        obj_event CELES, EventReturn
        obj_event EDGAR, EventReturn
        obj_event SABIN, EventReturn
        obj_event CYAN, EventReturn
        obj_event GAU, EventReturn
        obj_event SETZER, EventReturn
        obj_event STRAGO, EventReturn
        obj_event RELM, EventReturn
        obj_event SHADOW, EventReturn
        obj_event UMARO, EventReturn
        obj_event GOGO, EventReturn
        obj_event MOG, EventReturn

; enable/disable world of ruin npcs
        switch $069a=1
        switch $0636=0
        switch $0637=0
        switch $0638=0
        switch $0652=0
        switch $0661=0
        switch $0667=0
        switch $0653=0
        switch $0654=0
        switch $067a=0
        switch $067b=1
        switch $067c=1
        switch $0651=0
        switch $067f=1
        switch $067e=1
        switch $0600=0
        switch $0606=0
        switch $0688=0
        switch $0602=0
        switch $0603=0
        switch $0607=0
        switch $0615=0
        switch $0616=0
        switch $061a=0
        switch $0617=0
        switch $0618=0
        switch $0619=0
        switch $063d=0
        switch $063e=0
        switch $064e=0
        switch $068b=1
        switch $06ad=1
        switch $0654=0
        return
.endproc  ; _cce4d9

; ------------------------------------------------------------------------------

; [ Game Over ]

; cc/e566
.proc GameOver
        load_map 5, 8, 7, LEFT, $30, $40
        fade_song 160
        vehicle SLOT_1, NONE
        vehicle SLOT_2, NONE
        vehicle SLOT_3, NONE
        vehicle SLOT_4, NONE
        obj_script SLOT_1
                anim_on
                layer 0
                end
        obj_script SLOT_2
                anim_on
                layer 0
                end
        obj_script SLOT_3
                anim_on
                layer 0
                end
        obj_script SLOT_4
                anim_on
                layer 0
                end
        show_obj SLOT_1
        hide_obj SLOT_2
        hide_obj SLOT_3
        hide_obj SLOT_4
        update_party
        obj_script SLOT_1
                dir LEFT
                end
        clr_overlay
        shake ALL, 0, 1
        if_switch $02ab=1, :+
        if_switch $02ac=1, :+
        if_switch $02ad=1, :+
        if_switch $02ae=1, :+
        stop_timer 0
        stop_timer 1
        stop_timer 2
        stop_timer 3
:       fade_in 4
        wait_fade
        wait_1s
        obj_script SLOT_1
                action 21
                end
        wait_30f
        obj_script SLOT_1
                action 34
                end
        wait_15f
        obj_script SLOT_1
                action 9
                end
        wait_1s
        play_song SONG_REST_IN_PEACE
        wait_1s
        dlg $06d5, {BOTTOM, TEXT_ONLY}
        fade_song $80
        fade_out 4
        wait_fade
        wait_90f
        hide_obj SLOT_1
        hide_obj SLOT_2
        hide_obj SLOT_3
        hide_obj SLOT_4
        sort_obj
        unlock_camera
        restore_save
        return
.endproc  ; GameOver

; ------------------------------------------------------------------------------

end_fixed_block EventScript

; ------------------------------------------------------------------------------
