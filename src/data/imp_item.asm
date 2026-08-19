.export ImpItem
.export IMP_ITEM_COUNT: zp = 10

.segment "imp_item"

; ed/82e4
ImpItem:
        .byte ITEM::CURSED_SHLD
        .byte ITEM::THORNLET
        .byte ITEM::IMP_HALBERD
        .byte ITEM::TORTOISESHLD
        .byte ITEM::TITANIUM
        .byte ITEM::IMPS_ARMOR
        .byte ITEM::ATMA_WEAPON
        .byte ITEM::DRAINER
        .byte ITEM::SOUL_SABRE
        .byte ITEM::HEAL_ROD
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
        .byte ITEM::EMPTY
