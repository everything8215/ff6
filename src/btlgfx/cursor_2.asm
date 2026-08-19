; ------------------------------------------------------------------------------

; tables of icons in each slot reel

; 0: lucky 7
; 1: dragon
; 2: bar
; 3: airship
; 4: chocobo
; 5: diamond

SlotReel1Tbl:
@a800:  .word   0,4,5,3,4,5,2,5,1,4,5,3,5,2,3,1

SlotReel2Tbl:
        .word   0,4,1,5,3,4,1,5,4,3,2,5,4,3,2,5

SlotReel3Tbl:
        .word   0,1,3,4,2,5,4,3,1,5,4,3,2,5,4,5

; ------------------------------------------------------------------------------

; palette data for swdtech menu (grays out attacks that aren't known)
BushidoTextPalTbl:
@a860:  .byte   $21,$21,$21,$21,$21,$21,$21,$21,$25,$25,$25,$25,$25,$25,$25

; ------------------------------------------------------------------------------

; horizontal movement speed for back row (4 battle types, 4 characters each)
_c2a86f:
player_chg_x_offset2:
@a86f:  .lobytes +2,+2,+2,+2
        .lobytes -2,-2,-2,-2
        .lobytes 0,0,0,0
        .lobytes +2,+2,-2,-2

; ------------------------------------------------------------------------------

; horizontal movement speed for front row (4 battle types, 4 characters each)
_c2a87f:
player_chg_x_offset:
@a87f:  .lobytes -2,-2,-2,-2
        .lobytes +2,+2,+2,+2
        .lobytes 0,0,0,0
        .lobytes -2,-2,+2,+2

; ------------------------------------------------------------------------------
