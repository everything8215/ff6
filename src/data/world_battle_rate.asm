; ------------------------------------------------------------------------------

.export WorldBattleRate

; ------------------------------------------------------------------------------

.mac _world_battle_rate_sub bit_offset, val
        .if val & 1
                bitlist_set bit_offset
        .endif
        .if val & 2
                bitlist_set bit_offset + 1
        .endif
.endmac

.mac _world_battle_rate x_sector, y_sector, grass, forest, desert, dirt
        .local sector_offset
        sector_offset = (x_sector + y_sector * 8) * 8
        .if .paramcount = 3
                _world_battle_rate_sub sector_offset + 6, grass
                _world_battle_rate_sub sector_offset + 4, grass
                _world_battle_rate_sub sector_offset + 2, grass
                _world_battle_rate_sub sector_offset + 0, grass
        .elseif .paramcount = 6
                _world_battle_rate_sub sector_offset + 6, grass
                _world_battle_rate_sub sector_offset + 4, forest
                _world_battle_rate_sub sector_offset + 2, desert
                _world_battle_rate_sub sector_offset + 0, dirt
        .else
                .error "Invalid world battle rate"
        .endif
.endmac

.mac world_battle_rate xy_sector, val
        _world_battle_rate xy_sector, val
.endmac

; ------------------------------------------------------------------------------

; 128 bytes total
; WoB then WoR, 8x8 sectors per world, sectors are 32x32 tiles each
; 1 byte per sector, 2 bits per battle bg
; grass, forest, desert, dirt, where grass is the highest 2 bits

; The only sector which uses different rates for each battle bg is near
; Narshe in the world of balance which has a low rate everywhere except in
; forests. Also, most of the sectors which don't have a normal rate don't
; seem to make much sense based on the final version of the map. It seems
; likely that the world map was adjusted somewhat prior to release but this
; table was not updated to match.

; battle rates
;   0: normal
;   1: low
;   2: high
;   3: no battles

; cf/5800
WorldBattleRate:

; all sectors have normal battle rate except those listed below

; world of balance world map sectors
        bitlist 512
        world_battle_rate {5, 0}, 1  ; north of crazy old man's house
        world_battle_rate {2, 1}, {1, 0, 1, 1}  ; narshe area
        world_battle_rate {4, 1}, 1  ; east of nikeah
        world_battle_rate {1, 2}, 1  ; west half of figaro desert
        world_battle_rate {4, 2}, 1  ; small part of doma castle area
        world_battle_rate {6, 2}, 2  ; mountains north of the veldt
        world_battle_rate {5, 3}, 2  ; forest west of veldt
        end_bitlist

; world of ruin world map sectors
        bitlist 512
        end_bitlist

; ------------------------------------------------------------------------------
