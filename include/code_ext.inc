.ifndef CODE_EXT_INC
CODE_EXT_INC = 1

; field module
.global LoadMapCharGfx_ext, CheckBattleWorld_ext, DoPoisonDmg_ext
.global DecTimersMenuBattle_ext

; battle module
.global Battle_ext, UpdateBattleTime_ext
.global UpdateEquip_ext, CalcMagicEffect_ext

; battle graphics module
.global SineTbl8, SineTbl16
.global ExecBtlGfx_ext, Decompress_ext

; cutscene module
.global OpeningCredits_ext, TitleScreen_ext
.global FloatingContScene_ext, WorldOfRuinScene_ext
.global TheEnd_ext

; menu module
.global OpenMenu_ext, UpdateCtrlBattle_ext, InitCtrl_ext, UpdateCtrlField_ext
.global IncGameTime_ext, LoadSavedGame_ext, EndingCutscene_ext
.global OptimizeCharEquip_ext, EndingAirshipScene_ext

; sound module
.global InitSound_ext, ExecSound_ext
.global TfrSong_ext, TfrSongScript_ext  ; unused

; world module
.global LoadWorld_ext, UpdateMode7Vars_ext, UpdateMode7Rot_ext
.global PushMode7Vars_ext, PopMode7Vars_ext, UpdateMode7Circle_ext
.global MagitekTrain_ext, EndingAirshipScene2_ext

.endif
