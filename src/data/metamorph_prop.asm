.export MetamorphProp

.segment "metamorph_prop"

.mac metamorph_items item1, item2, item3, item4
        .byte ITEM::item1
        .byte ITEM::item2
        .byte ITEM::item3
        .byte ITEM::item4
.endmac

; c4/7f40
MetamorphProp:
        metamorph_items ANTIDOTE, GREEN_CHERRY, EYEDROP, SOFT  ; 0
        metamorph_items TENT, FENIX_DOWN, WARP_STONE, REVIVIFY  ; 1
        metamorph_items DRIED_MEAT, DRIED_MEAT, DRIED_MEAT, DRIED_MEAT  ; 2
        metamorph_items REMEDY, REMEDY, REMEDY, REMEDY  ; 3
        metamorph_items MITHRILBLADE, MITHRIL_HELM, MITHRIL_MAIL, HEAVY_SHLD  ; 4
        metamorph_items GOLD_LANCE, GOLD_SHLD, GOLD_HELMET, GOLD_ARMOR  ; 5
        metamorph_items CRYSTAL, CRYSTAL_SHLD, CRYSTAL_HELM, CRYSTAL_MAIL  ; 6
        metamorph_items IMPS_ARMOR, TITANIUM, TORTOISESHLD, IMP_HALBERD  ; 7
        metamorph_items TONIC, TONIC, TONIC, OGRE_NIX  ; 8
        metamorph_items TONIC, TONIC, TONIC, MARVEL_SHOES  ; 9
        metamorph_items TONIC, TONIC, TONIC, TINTINABAR  ; 10
        metamorph_items TONIC, TONIC, TONIC, MEGALIXIR  ; 11
        metamorph_items TONIC, TONIC, TONIC, X_POTION  ; 12
        metamorph_items TONIC, TONIC, TONIC, X_ETHER  ; 13
        metamorph_items TONIC, TONIC, TONIC, ELIXIR  ; 14
        metamorph_items TONIC, TONIC, TONIC, GAUNTLET  ; 15
        metamorph_items TONIC, TONIC, TONIC, GENJI_GLOVE  ; 16
        metamorph_items TONIC, TONIC, TONIC, SAFETY_BIT  ; 17
        metamorph_items TONIC, TONIC, TONIC, EXP_EGG  ; 18
        metamorph_items TONIC, TONIC, TONIC, RIBBON  ; 19
        metamorph_items TONIC, TONIC, TONIC, FLAME_SHLD  ; 20
        metamorph_items TONIC, TONIC, TONIC, ICE_SHLD  ; 21
        metamorph_items TONIC, TONIC, TONIC, THUNDER_SHLD  ; 22
        metamorph_items CURSED_RING, CURSED_RING, THORNLET, RELIC_RING  ; 23
        metamorph_items CURE_RING, CURE_RING, SAFETY_BIT, POD_BRACELET  ; 24
        metamorph_items TRUMP, TRUMP, ASSASSIN, STRIKER  ; 25
        metamorph_items DIRK, DIRK, DIRK, DIRK  ; 26
        metamorph_items DIRK, DIRK, DIRK, DIRK  ; 27
        metamorph_items DIRK, DIRK, DIRK, DIRK  ; 28
        metamorph_items DIRK, DIRK, DIRK, DIRK  ; 29
        metamorph_items DIRK, DIRK, DIRK, DIRK  ; 30
        metamorph_items DIRK, DIRK, DIRK, DIRK  ; 31
