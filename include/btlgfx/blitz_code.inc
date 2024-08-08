.list off
.ifndef BLITZ_CODE_INC
BLITZ_CODE_INC = 1

.global BlitzCode

.enum BLITZ_CODE
        NONE                            = 0
        A_BUTTON                        = 1
        B_BUTTON                        = 2
        X_BUTTON                        = 3
        Y_BUTTON                        = 4
        L_BUTTON                        = 5
        R_BUTTON                        = 6
        DOWN_LEFT                       = 7
        DOWN                            = 8
        DOWN_RIGHT                      = 9
        RIGHT                           = 10
        UP_RIGHT                        = 11
        UP                              = 12
        UP_LEFT                         = 13
        LEFT                            = 14
.endenum

.scope BlitzCode
        ARRAY_LENGTH                    = 8
        ITEM_SIZE                       = 12
.endscope

.endif
.list on
