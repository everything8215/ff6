.export GenjuOrder

_genju_order_seq .set 0

; ------------------------------------------------------------------------------

.scope GENJU_ORDER
.endscope

.mac genju_order val
        .local genju_index
        genju_index = ATTACK::val - ATTACK::FIRST_GENJU
        array_item GENJU_ORDER, {genju_index} = _genju_order_seq + 1
        _genju_order_seq .set _genju_order_seq + 1
.endmac

; ------------------------------------------------------------------------------

; This is the list of espers in the order that they will appear in the menu.
; If any espers are missing from this list, there will be an assembler error.
        genju_order RAMUH
        genju_order KIRIN
        genju_order SIREN
        genju_order STRAY
        genju_order IFRIT
        genju_order SHIVA
        genju_order UNICORN
        genju_order MADUIN
        genju_order SHOAT
        genju_order PHANTOM
        genju_order CARBUNKL
        genju_order BISMARK
        genju_order GOLEM
        genju_order ZONESEEK
        genju_order SRAPHIM
        genju_order PALIDOR
        genju_order FENRIR
        genju_order TRITOCH
        genju_order TERRATO
        genju_order STARLET
        genju_order ALEXANDR
        genju_order PHOENIX
        genju_order ODIN
        genju_order BAHAMUT
        genju_order RAGNAROK
        genju_order CRUSADER
        genju_order RAIDEN

; confirm that all espers are included in the list
        .assert _genju_order_seq = ATTACK::NUM_GENJU, error, "Mismatch in genju_order"

; ------------------------------------------------------------------------------

.segment "genju_order"

; d1/f9b5
GenjuOrder:
        .repeat ATTACK::NUM_GENJU, i
                .byte array_item GENJU_ORDER, i
        .endrep

; ------------------------------------------------------------------------------
