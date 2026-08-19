.include "src/text/blitz_desc.inc"
.include "blitz_code.inc"

.export BlitzCode

; ------------------------------------------------------------------------------

.segment "blitz_code"

; c4/7a40
BlitzCode:

; ------------------------------------------------------------------------------

; 0: pummel
        blitz_code PUMMEL
        blitz_btn LEFT
        blitz_btn RIGHT
        blitz_btn LEFT
        end_blitz_code

; ------------------------------------------------------------------------------

; 1: aura bolt
        blitz_code AURABOLT
        blitz_btn DOWN
        blitz_btn DOWN_LEFT
        blitz_btn LEFT
        end_blitz_code

; ------------------------------------------------------------------------------

; 2: suplex
        blitz_code SUPLEX
        blitz_btn X_BUTTON
        blitz_btn Y_BUTTON
        blitz_btn DOWN
        blitz_btn UP
        end_blitz_code

; ------------------------------------------------------------------------------

; 3: fire dance
        blitz_code FIRE_DANCE
        blitz_btn LEFT
        blitz_btn DOWN_LEFT
        blitz_btn DOWN
        blitz_btn DOWN_RIGHT
        blitz_btn RIGHT
        end_blitz_code

; ------------------------------------------------------------------------------

; 4: mantra
        blitz_code MANTRA
        blitz_btn R_BUTTON
        blitz_btn L_BUTTON
        blitz_btn R_BUTTON
        blitz_btn L_BUTTON
        blitz_btn X_BUTTON
        blitz_btn Y_BUTTON
        end_blitz_code

; ------------------------------------------------------------------------------

; 5: air blade
        blitz_code AIR_BLADE
        blitz_btn UP
        blitz_btn UP_RIGHT
        blitz_btn RIGHT
        blitz_btn DOWN_RIGHT
        blitz_btn DOWN
        blitz_btn DOWN_LEFT
        blitz_btn LEFT
        end_blitz_code

; ------------------------------------------------------------------------------

; 6: spiraler
        blitz_code SPIRALER
        blitz_btn R_BUTTON
        blitz_btn L_BUTTON
        blitz_btn X_BUTTON
        blitz_btn Y_BUTTON
        blitz_btn RIGHT
        blitz_btn LEFT
        end_blitz_code

; ------------------------------------------------------------------------------

; 7: bum rush
        blitz_code BUM_RUSH
        blitz_btn LEFT
        blitz_btn UP_LEFT
        blitz_btn UP
        blitz_btn UP_RIGHT
        blitz_btn RIGHT
        blitz_btn DOWN_RIGHT
        blitz_btn DOWN
        blitz_btn DOWN_LEFT
        blitz_btn LEFT
        end_blitz_code

; ------------------------------------------------------------------------------

.include "blitz_code.inc"

