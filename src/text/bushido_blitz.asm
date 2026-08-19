.include "src/text/blitz_desc.inc"
.include "src/text/bushido_desc.inc"
.include "src/text/bushido_name.inc"

; ------------------------------------------------------------------------------

; check bushido index
_bushido_seq .set 0

.mac check_bushido_index bushido_id
        .assert _bushido_seq = ATTACK::bushido_id - ATTACK::FIRST_BUSHIDO, error, "bushido index mismatch"
        .assert _bushido_seq = BUSHIDO_NAME::bushido_id, error, "bushido index mismatch"
        .assert _bushido_seq = BUSHIDO_DESC::bushido_id, error, "bushido index mismatch"
        _bushido_seq .set _bushido_seq + 1
.endmac

        check_bushido_index DISPATCH
        check_bushido_index RETORT
        check_bushido_index SLASH
        check_bushido_index QUADRA_SLAM
        check_bushido_index EMPOWERER
        check_bushido_index STUNNER
        check_bushido_index QUADRA_SLICE
        check_bushido_index CLEAVE

; ------------------------------------------------------------------------------

; cf/3c40
.segment "bushido_name"

BushidoName:
.if LANG_EN
        fixed_block $c0
        .incbin "assets/text/bushido_name.bin"
        end_fixed_block
.else
        .incbin "assets/text/bushido_name.bin"
.endif

; ------------------------------------------------------------------------------

; cf/fc00
.segment "bushido_blitz_desc"

BlitzDesc:
        fixed_block $0100
        .incbin "assets/text/blitz_desc.bin"
        end_fixed_block

BushidoDesc:
        fixed_block $0100
        .incbin "assets/text/bushido_desc.bin"
        end_fixed_block

; ------------------------------------------------------------------------------

; cf/ff9e
.segment "bushido_blitz_desc_ptrs"

BlitzDescPtrs:
        ptr_tbl BLITZ_DESC

BushidoDescPtrs:
        ptr_tbl BUSHIDO_DESC

; ------------------------------------------------------------------------------
