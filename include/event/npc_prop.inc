.ifndef NPC_PROP_INC
NPC_PROP_INC = 1

; ------------------------------------------------------------------------------

.global NPCPropPtrs

; ------------------------------------------------------------------------------

.enum NPC_SCROLL
        BG1 = 0
        BG2 = 1 << 5
        MASK = 1 << 5
.endenum

.enum NPC_MOVEMENT
        NONE
        SCRIPT
        PLAYER
        RANDOM
        ACTIVE
        MASK = %1111
.endenum

.enum NPC_SPRITE_PRIORITY
        NORMAL = 0
        HIGH = 1 << 4
        LOW = 2 << 4
        MASK = %11 << 4
.endenum

.enum NPC_LAYER_PRIORITY
        DEFAULT = 0
        TOP_SPRITE_ONLY = 1 << 3
        FOREGROUND = 2 << 3
        BACKGROUND = 3 << 3
        MASK = %11 << 3
.endenum

.enum NPC_REACT
        FACE_PLAYER = 0
        NONE = 1 << 2
        MASK = %1 << 2
.endenum

.enum NPC_ANIM_TYPE
        ONE_FRAME
        H_FLIP
        TWO_FRAMES
        FOUR_FRAMES
        MASK = %11
.endenum

.enum NPC_ANIM_FRAME
        DEFAULT = 0
        NONE = 1 << 5
        SPECIAL = 2 << 5
        KNOCKED_OUT = 3 << 5
        MASK = %111 << 5
.endenum

.enum NPC_ANIM_SPEED
        FASTEST = 0
        FAST = 1 << 6
        MEDIUM = 2 << 6
        SLOW = 3 << 6
        MASK = %11 << 6
.endenum

.enum NPC_MASTER_OFFSET_DIR
        RIGHT
        DOWN
.endenum

; ------------------------------------------------------------------------------

.scope NPCProp
        ARRAY_LENGTH = $01a0
        ITEM_SIZE = 9

        Start := NPCPropPtrs

        EventPtr := Start
        Pal := Start + 2
        Scroll := Start + 2
        Switch := Start + 2
        PosX := Start + 4
        SpecialNPC := Start + 4
        PosY := Start + 5
        Speed := Start + 5
        Gfx := Start + 6
        Movement := Start + 7
        SpritePriority := Start + 7
        Vehicle := Start + 7
        Dir := Start + 8
        LayerPriority := Start + 8
        React := Start + 8

        ; for animated npcs
        AnimType := Start + 8
        AnimFrame := Start + 8
.endscope

; ------------------------------------------------------------------------------

.endif
