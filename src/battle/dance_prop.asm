; ------------------------------------------------------------------------------

.mac make_dance_prop attack1, attack2, attack3, attack4
        .byte ATTACK::attack1, ATTACK::attack2
        .byte ATTACK::attack3, ATTACK::attack4
.endmac

; ------------------------------------------------------------------------------

DanceProp:

; 0: wind song
        make_dance_prop WIND_SLASH, SUN_BATH, PLASMA, COKATRICE

; 1: forest suite
        make_dance_prop RAGE, HARVESTER, ELF_FIRE, WOMBAT

; 2: desert aria
        make_dance_prop SAND_STORM, ANTLION, WIND_SLASH, KITTY

; 3: love sonata
        make_dance_prop ELF_FIRE, SPECTER, SNARE, TAPIR

; 4: earth blues
        make_dance_prop LAND_SLIDE, SONIC_BOOM, SUN_BATH, WHUMP

; 5: water rondo
        make_dance_prop EL_NINO, PLASMA, SPECTER, WILD_BEAR

; 6: dusk requiem
        make_dance_prop CAVE_IN, SNARE, ELF_FIRE, POIS_FROG

; 7: snowman jazz
        make_dance_prop SNOWBALL, SURGE, SNARE, ICE_RABBIT

; ------------------------------------------------------------------------------
