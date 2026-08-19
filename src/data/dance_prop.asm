.include "src/text/dance_name.inc"

.export DanceProp

; ------------------------------------------------------------------------------

_dance_prop_seq .set 0

.mac dance_prop dance_id
        .assert DANCE::dance_id = _dance_prop_seq, error, "dance_prop index mismatch"
        .assert DANCE::dance_id = DANCE_NAME::dance_id, error, "dance_name index mismatch"
        _dance_attack_0 .set ATTACK::NONE
        _dance_attack_1 .set ATTACK::NONE
        _dance_attack_2 .set ATTACK::NONE
        _dance_attack_3 .set ATTACK::NONE
        _dance_attack_seq .set 0
.endmac

.mac dance_attack attack_id
        .ident(.sprintf("_dance_attack_%d", _dance_attack_seq)) .set ATTACK::attack_id
        _dance_attack_seq .set _dance_attack_seq + 1
.endmac

.mac end_dance_prop
        .byte _dance_attack_0
        .byte _dance_attack_1
        .byte _dance_attack_2
        .byte _dance_attack_3
        _dance_prop_seq .set _dance_prop_seq + 1
.endmac

; ------------------------------------------------------------------------------

.segment "dance_prop"

; cf/fe80
DanceProp:
        dance_prop WIND_SONG
        dance_attack WIND_SLASH
        dance_attack SUN_BATH
        dance_attack PLASMA
        dance_attack COKATRICE
        end_dance_prop

        dance_prop FOREST_SUITE
        dance_attack RAGE
        dance_attack HARVESTER
        dance_attack ELF_FIRE
        dance_attack WOMBAT
        end_dance_prop

        dance_prop DESERT_ARIA
        dance_attack SAND_STORM
        dance_attack ANTLION
        dance_attack WIND_SLASH
        dance_attack KITTY
        end_dance_prop

        dance_prop LOVE_SONATA
        dance_attack ELF_FIRE
        dance_attack SPECTER
        dance_attack SNARE
        dance_attack TAPIR
        end_dance_prop

        dance_prop EARTH_BLUES
        dance_attack LAND_SLIDE
        dance_attack SONIC_BOOM
        dance_attack SUN_BATH
        dance_attack WHUMP
        end_dance_prop

        dance_prop WATER_RONDO
        dance_attack EL_NINO
        dance_attack PLASMA
        dance_attack SPECTER
        dance_attack WILD_BEAR
        end_dance_prop

        dance_prop DUSK_REQUIEM
        dance_attack CAVE_IN
        dance_attack SNARE
        dance_attack ELF_FIRE
        dance_attack POIS_FROG
        end_dance_prop

        dance_prop SNOWMAN_JAZZ
        dance_attack SNOWBALL
        dance_attack SURGE
        dance_attack SNARE
        dance_attack ICE_RABBIT
        end_dance_prop

; ------------------------------------------------------------------------------

.delmac dance_prop
.delmac dance_attack
.delmac end_dance_prop

; ------------------------------------------------------------------------------
