.ifndef NPC_PROP_INC
NPC_PROP_INC = 1

; ------------------------------------------------------------------------------

.global NPCProp, NPCPropPtrs

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

.enum NPC_PROP
        COUNT = $01a0
        ITEM_SIZE = 9

        BASE_PTR = NPCPropPtrs
.endenum

.scope NPCProp
        EventPtr := NPCPropPtrs
        Pal := NPCPropPtrs + 2
        Scroll := NPCPropPtrs + 2
        Switch := NPCPropPtrs + 2
        PosX := NPCPropPtrs + 4
        SpecialNPC := NPCPropPtrs + 4
        PosY := NPCPropPtrs + 5
        Speed := NPCPropPtrs + 5
        Gfx := NPCPropPtrs + 6
        Movement := NPCPropPtrs + 7
        SpritePriority := NPCPropPtrs + 7
        Vehicle := NPCPropPtrs + 7
        Dir := NPCPropPtrs + 8
        LayerPriority := NPCPropPtrs + 8
        React := NPCPropPtrs + 8

        ; for animated npcs
        AnimType := NPCPropPtrs + 8
        AnimFrame := NPCPropPtrs + 8
.endscope

; ------------------------------------------------------------------------------

.endif
