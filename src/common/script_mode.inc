.ifndef SCRIPT_MODE_INC
SCRIPT_MODE_INC = 1

.enum SCRIPT_MODE
        EVENT
        OBJ
        WORLD
        VEHICLE
        BATTLE_ANIM
        BATTLE_EVENT
.endenum

.define set_script_mode(mode) ::script_mode .set SCRIPT_MODE::mode
.define is_script_mode(mode) ::script_mode = SCRIPT_MODE::mode

.mac _assert_script_mode mode
        .assert ::script_mode = SCRIPT_MODE::mode, error, "Invalid script mode"
.endmac

.endif