; ------------------------------------------------------------------------------

; $00: rare steal
; $01: common steal
; $02: rare drop
; $03: common drop

; ------------------------------------------------------------------------------

; 0: guard
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 1: soldier
        .byte ITEM_TONIC, ITEM_POTION
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 2: templar
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 3: ninja
        .byte ITEM_CHERUB_DOWN, ITEM_EMPTY
        .byte ITEM_NINJA_STAR, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 4: samurai
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 5: orog
        .byte ITEM_AMULET, ITEM_EMPTY
        .byte ITEM_AMULET, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 6: mag_roader_1
        .byte ITEM_SHURIKEN, ITEM_BOLT_EDGE
        .byte ITEM_WATER_EDGE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 7: retainer
        .byte ITEM_AURA, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 8: hazer
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 9: dahling
        .byte ITEM_MOOGLE_SUIT, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 10: rain_man
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 11: brawler
        .byte ITEM_BANDANA, ITEM_EMPTY
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 12: apokryphos
        .byte ITEM_CURE_RING, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 13: dark_force
        .byte ITEM_CRYSTAL, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 14: whisper
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_SOFT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 15: over_mind
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_REVIVIFY, ITEM_GREEN_CHERRY

; ------------------------------------------------------------------------------

; 16: osteosaur
        .byte ITEM_REMEDY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 17: commander
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 18: rhodox
        .byte ITEM_TONIC, ITEM_ANTIDOTE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 19: were_rat
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 20: ursus
        .byte ITEM_SNEAK_RING, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 21: rhinotaur
        .byte ITEM_MITHRIL_CLAW, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 22: steroidite
        .byte ITEM_THUNDER_SHLD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 23: leafer
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 24: stray_cat
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 25: lobo
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 26: doberman
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 27: vomammoth
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 28: fidor
        .byte ITEM_POTION, ITEM_FENIX_DOWN
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 29: baskervor
        .byte ITEM_GAIA_GEAR, ITEM_EMPTY
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 30: suriander
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 31: chimera
        .byte ITEM_HYPER_WRIST, ITEM_EMPTY
        .byte ITEM_GOLD_ARMOR, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 32: behemoth
        .byte ITEM_RUNNINGSHOES, ITEM_EMPTY
        .byte ITEM_X_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 33: mesosaur
        .byte ITEM_EMPTY, ITEM_ANTIDOTE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 34: pterodon
        .byte ITEM_GUARDIAN, ITEM_MITHRILKNIFE
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 35: fossilfang
        .byte ITEM_REMEDY, ITEM_REVIVIFY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 36: white_drgn
        .byte ITEM_PEARL_LANCE, ITEM_X_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 37: doom_drgn
        .byte ITEM_POD_BRACELET, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 38: brachosaur
        .byte ITEM_RIBBON, ITEM_EMPTY
        .byte ITEM_ECONOMIZER, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 39: tyranosaur
        .byte ITEM_IMPS_ARMOR, ITEM_EMPTY
        .byte ITEM_IMP_HALBERD, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 40: dark_wind
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 41: beakor
        .byte ITEM_POTION, ITEM_EYEDROP
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 42: vulture
        .byte ITEM_FENIX_DOWN, ITEM_POTION
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 43: harpy
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 44: hermitcrab
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 45: trapper
        .byte ITEM_AUTOCROSSBOW, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 46: hornet
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 47: crasshoppr
        .byte ITEM_ANTIDOTE, ITEM_ANTIDOTE
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 48: delta_bug
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_SLEEPING_BAG, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 49: gilomantis
        .byte ITEM_POISON_CLAW, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 50: trilium
        .byte ITEM_REMEDY, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 51: nightshade
        .byte ITEM_NUTKIN_SUIT, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 52: tumbleweed
        .byte ITEM_TITANIUM, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 53: bloompire
        .byte ITEM_ECHO_SCREEN, ITEM_EMPTY
        .byte ITEM_SMOKE_BOMB, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 54: trilobiter
        .byte ITEM_TONIC, ITEM_ANTIDOTE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 55: siegfried_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 56: nautiloid
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_EYEDROP, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 57: exocite
        .byte ITEM_MITHRIL_CLAW, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 58: anguiform
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 59: reach_frog
        .byte ITEM_TACK_STAR, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 60: lizard
        .byte ITEM_DRAINER, ITEM_EMPTY
        .byte ITEM_SOFT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 61: chickenlip
        .byte ITEM_SLEEPING_BAG, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 62: hoover
        .byte ITEM_REMEDY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 63: rider
        .byte ITEM_ELIXIR, ITEM_MITHRIL_VEST
        .byte ITEM_REMEDY, ITEM_REMEDY

; ------------------------------------------------------------------------------

; 64: chupon_colosseum
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 65: pipsqueak
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 66: m_tekarmor
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_POTION

; ------------------------------------------------------------------------------

; 67: sky_armor
        .byte ITEM_EMPTY, ITEM_TINCTURE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 68: telstar
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_GREEN_BERET, ITEM_GREEN_BERET

; ------------------------------------------------------------------------------

; 69: lethal_wpn
        .byte ITEM_DEBILITATOR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 70: vaporite
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 71: flan
        .byte ITEM_MAGICITE, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 72: ing
        .byte ITEM_AMULET, ITEM_EMPTY
        .byte ITEM_REVIVIFY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 73: humpty
        .byte ITEM_EMPTY, ITEM_GREEN_CHERRY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 74: brainpan
        .byte ITEM_EARRINGS, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 75: cruller
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 76: cactrot
        .byte ITEM_SOFT, ITEM_EMPTY
        .byte ITEM_SOFT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 77: repo_man
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 78: harvester
        .byte ITEM_DRAGOONBOOTS, ITEM_GOGGLES
        .byte ITEM_BARRIER_RING, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 79: bomb
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 80: still_life
        .byte ITEM_FAKEMUSTACHE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 81: boxed_set
        .byte ITEM_ANTIDOTE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 82: slamdancer
        .byte ITEM_THIEFKNIFE, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 83: hadesgigas
        .byte ITEM_ATLAS_ARMLET, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 84: pug
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_TINTINABAR, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 85: magic_urn
        .byte ITEM_ELIXIR, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 86: mover
        .byte ITEM_EMPTY, ITEM_SUPER_BALL
        .byte ITEM_MAGICITE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 87: figaliz
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 88: buffalax
        .byte ITEM_DIAMOND_VEST, ITEM_TINCTURE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 89: aspik
        .byte ITEM_TONIC, ITEM_EMPTY
        .byte ITEM_X_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 90: ghost
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 91: crawler
        .byte ITEM_REMEDY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 92: sand_ray
        .byte ITEM_ANTIDOTE, ITEM_ANTIDOTE
        .byte ITEM_ANTIDOTE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 93: areneid
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 94: actaneon
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 95: sand_horse
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 96: dark_side
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 97: mad_oscar
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_REMEDY, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 98: crawly
        .byte ITEM_REMEDY, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 99: bleary
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 100: marshal
        .byte ITEM_EMPTY, ITEM_MITHRILKNIFE
        .byte ITEM_POTION, ITEM_POTION

; ------------------------------------------------------------------------------

; 101: trooper
        .byte ITEM_MITHRILBLADE, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 102: general
        .byte ITEM_MITHRIL_SHLD, ITEM_TONIC
        .byte ITEM_GREEN_CHERRY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 103: covert
        .byte ITEM_TACK_STAR, ITEM_SHURIKEN
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 104: ogor
        .byte ITEM_MURASAME, ITEM_ASHURA
        .byte ITEM_EMPTY, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 105: warlock
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 106: madam
        .byte ITEM_GOGGLES, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 107: joker
        .byte ITEM_GREEN_BERET, ITEM_TONIC
        .byte ITEM_MITHRIL_ROD, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 108: iron_fist
        .byte ITEM_HEAD_BAND, ITEM_TONIC
        .byte ITEM_MITHRILKNIFE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 109: goblin
        .byte ITEM_MITHRILGLOVE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 110: apparite
        .byte ITEM_POTION, ITEM_REVIVIFY
        .byte ITEM_REVIVIFY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 111: powerdemon
        .byte ITEM_DIAMOND_VEST, ITEM_POTION
        .byte ITEM_AMULET, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 112: displayer
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 113: vector_pup
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 114: peepers
        .byte ITEM_ELIXIR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 115: sewer_rat
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 116: slatter
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 117: rhinox
        .byte ITEM_FLASH, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 118: rhobite
        .byte ITEM_POTION, ITEM_POTION
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 119: wild_cat
        .byte ITEM_TABBY_SUIT, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 120: red_fang
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_DRIED_MEAT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 121: bounty_man
        .byte ITEM_POTION, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 122: tusker
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_SOFT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 123: ralph
        .byte ITEM_TIGER_MASK, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 124: chitonid
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_REMEDY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 125: wart_puck
        .byte ITEM_DRIED_MEAT, ITEM_FLAIL
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 126: rhyos
        .byte ITEM_GOLD_LANCE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 127: srbehemoth_undead
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_BEHEMOTHSUIT, ITEM_BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 128: vectaur
        .byte ITEM_NINJA_STAR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 129: wyvern
        .byte ITEM_DRAGOONBOOTS, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 130: zombone
        .byte ITEM_POTION, ITEM_FENIX_DOWN
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 131: dragon
        .byte ITEM_GENJI_GLOVE, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 132: brontaur
        .byte ITEM_DRIED_MEAT, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 133: allosaurus
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 134: cirpius
        .byte ITEM_TONIC, ITEM_ANTIDOTE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 135: sprinter
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_IMPS_ARMOR, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 136: gobbler
        .byte ITEM_POTION, ITEM_GREEN_CHERRY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 137: harpiai
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 138: gloomshell
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 139: drop
        .byte ITEM_EMPTY, ITEM_TINCTURE
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 140: mind_candy
        .byte ITEM_TONIC, ITEM_SOFT
        .byte ITEM_SOFT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 141: weedfeeder
        .byte ITEM_ANTIDOTE, ITEM_ANTIDOTE
        .byte ITEM_ECHO_SCREEN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 142: luridan
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 143: toe_cutter
        .byte ITEM_EMPTY, ITEM_POISON_ROD
        .byte ITEM_POISON_ROD, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 144: over_grunk
        .byte ITEM_REMEDY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 145: exoray
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 146: crusher
        .byte ITEM_EMPTY, ITEM_SUPER_BALL
        .byte ITEM_SUPER_BALL, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 147: uroburos
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 148: primordite
        .byte ITEM_TONIC, ITEM_EYEDROP
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 149: sky_cap
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 150: cephaler
        .byte ITEM_REMEDY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 151: maliga
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 152: gigan_toad
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_SLEEPING_BAG, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 153: geckorex
        .byte ITEM_TORTOISESHLD, ITEM_EMPTY
        .byte ITEM_TORTOISESHLD, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 154: cluck
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 155: land_worm
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 156: test_rider
        .byte ITEM_PARTISAN, ITEM_EMPTY
        .byte ITEM_STOUT_SPEAR, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 157: plutoarmor
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 158: tomb_thumb
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_GREEN_CHERRY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 159: heavyarmor
        .byte ITEM_IRONHELMET, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 160: chaser
        .byte ITEM_BIO_BLASTER, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 161: scullion
        .byte ITEM_AIR_ANCHOR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 162: poplium
        .byte ITEM_POTION, ITEM_EMPTY
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 163: intangir
        .byte ITEM_MAGICITE, ITEM_EMPTY
        .byte ITEM_ANTIDOTE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 164: misfit
        .byte ITEM_BACK_GUARD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 165: eland
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 166: enuo
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 167: deep_eye
        .byte ITEM_EMPTY, ITEM_EYEDROP
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 168: greasemonk
        .byte ITEM_BUCKLER, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 169: neckhunter
        .byte ITEM_DARK_HOOD, ITEM_EMPTY
        .byte ITEM_PEACE_RING, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 170: grenade
        .byte ITEM_FIRE_SKEAN, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 171: critic
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 172: pan_dora
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 173: souldancer
        .byte ITEM_MOOGLE_SUIT, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 174: gigantos
        .byte ITEM_ELIXIR, ITEM_X_POTION
        .byte ITEM_HARDENED, ITEM_HARDENED

; ------------------------------------------------------------------------------

; 175: mag_roader_2
        .byte ITEM_SHURIKEN, ITEM_BOLT_EDGE
        .byte ITEM_FIRE_SKEAN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 176: spek_tor
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 177: parasite
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 178: earthguard
        .byte ITEM_MEGALIXIR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 179: coelecite
        .byte ITEM_POTION, ITEM_ANTIDOTE
        .byte ITEM_ANTIDOTE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 180: anemone
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_GREEN_CHERRY

; ------------------------------------------------------------------------------

; 181: hipocampus
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 182: spectre
        .byte ITEM_ICE_ROD, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 183: evil_oscar
        .byte ITEM_EMPTY, ITEM_WARP_STONE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 184: slurm
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 185: latimeria
        .byte ITEM_EMPTY, ITEM_GAIA_GEAR
        .byte ITEM_ANTIDOTE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 186: stillgoing
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 187: allo_ver
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_TIGER_FANGS, ITEM_TIGER_FANGS

; ------------------------------------------------------------------------------

; 188: phase
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 189: outsider
        .byte ITEM_BREAK_BLADE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 190: barb_e
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 191: parasoul
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 192: pm_stalker
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 193: hemophyte
        .byte ITEM_TACK_STAR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 194: sp_forces
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_MAGICITE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 195: nohrabbit
        .byte ITEM_EMPTY, ITEM_REMEDY
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 196: wizard
        .byte ITEM_ICE_ROD, ITEM_THUNDER_ROD
        .byte ITEM_FIRE_ROD, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 197: scrapper
        .byte ITEM_THIEF_GLOVE, ITEM_EMPTY
        .byte ITEM_AIR_LANCET, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 198: ceritops
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_WHITE_CAPE, ITEM_GREEN_CHERRY

; ------------------------------------------------------------------------------

; 199: commando
        .byte ITEM_MITHRIL_VEST, ITEM_TENT
        .byte ITEM_TENT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 200: opinicus
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_WARP_STONE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 201: poppers
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_GREEN_CHERRY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 202: lunaris
        .byte ITEM_POTION, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 203: garm
        .byte ITEM_FENIX_DOWN, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 204: vindr
        .byte ITEM_CHOCOBO_SUIT, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 205: kiwok
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_WHITE_CAPE, ITEM_GREEN_CHERRY

; ------------------------------------------------------------------------------

; 206: nastidon
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 207: rinn
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 208: insecare
        .byte ITEM_EMPTY, ITEM_ECHO_SCREEN
        .byte ITEM_SMOKE_BOMB, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 209: vermin
        .byte ITEM_ANTIDOTE, ITEM_POTION
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 210: mantodea
        .byte ITEM_IMP_HALBERD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 211: bogy
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 212: prussian
        .byte ITEM_FULL_MOON, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 213: black_drgn
        .byte ITEM_EMPTY, ITEM_REVIVIFY
        .byte ITEM_TENT, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 214: adamanchyt
        .byte ITEM_GOLD_SHLD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 215: dante
        .byte ITEM_DIAMOND_HELM, ITEM_EMPTY
        .byte ITEM_GOLD_SHLD, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 216: wirey_drgn
        .byte ITEM_DRAGOONBOOTS, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 217: dueller
        .byte ITEM_CHAIN_SAW, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 218: psychot
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 219: muus
        .byte ITEM_MAGICITE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 220: karkass
        .byte ITEM_SOUL_SABRE, ITEM_MITHRILBLADE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 221: punisher
        .byte ITEM_BONE_CLUB, ITEM_RISING_SUN
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 222: balloon
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 223: gabbldegak
        .byte ITEM_FENIX_DOWN, ITEM_EYEDROP
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 224: gtbehemoth
        .byte ITEM_TIGER_FANGS, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 225: scorpion
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 226: chaos_drgn
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 227: spit_fire
        .byte ITEM_ELIXIR, ITEM_TINCTURE
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 228: vectagoyle
        .byte ITEM_SWORDBREAKER, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 229: lich
        .byte ITEM_POISON_ROD, ITEM_GREEN_CHERRY
        .byte ITEM_GREEN_CHERRY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 230: osprey
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_ECHO_SCREEN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 231: mag_roader_3
        .byte ITEM_SHURIKEN, ITEM_BOLT_EDGE
        .byte ITEM_WATER_EDGE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 232: bug
        .byte ITEM_POTION, ITEM_SOFT
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 233: sea_flower
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 234: fortis
        .byte ITEM_DRILL, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 235: abolisher
        .byte ITEM_EMPTY, ITEM_ANTIDOTE
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 236: aquila
        .byte ITEM_ECONOMIZER, ITEM_FENIX_DOWN
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 237: junk
        .byte ITEM_NOISEBLASTER, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 238: mandrake
        .byte ITEM_POTION, ITEM_POTION
        .byte ITEM_REMEDY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 239: 1st_class
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 240: tap_dancer
        .byte ITEM_SWORDBREAKER, ITEM_DIRK
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 241: necromancr
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_REVIVIFY

; ------------------------------------------------------------------------------

; 242: borras
        .byte ITEM_MUSCLE_BELT, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 243: mag_roader_4
        .byte ITEM_SHURIKEN, ITEM_BOLT_EDGE
        .byte ITEM_FIRE_SKEAN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 244: wild_rat
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 245: gold_bear
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_POTION, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 246: innoc
        .byte ITEM_BIO_BLASTER, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 247: trixter
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 248: red_wolf
        .byte ITEM_TONIC, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 249: didalos
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 250: woolly
        .byte ITEM_HARDENED, ITEM_IMPERIAL
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 251: veteran
        .byte ITEM_EARRINGS, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 252: sky_base
        .byte ITEM_FLASH, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 253: ironhitman
        .byte ITEM_AUTOCROSSBOW, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 254: io
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 255: pugs
        .byte ITEM_MINERVA, ITEM_EMPTY
        .byte ITEM_MINERVA, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 256: whelk
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_TINCTURE

; ------------------------------------------------------------------------------

; 257: presenter
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_DRAGON_CLAW, ITEM_DRAGON_CLAW

; ------------------------------------------------------------------------------

; 258: mega_armor
        .byte ITEM_EMPTY, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 259: vargas
        .byte ITEM_MITHRIL_CLAW, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 260: tunnelarmr
        .byte ITEM_BIO_BLASTER, ITEM_AIR_LANCET
        .byte ITEM_ELIXIR, ITEM_ELIXIR

; ------------------------------------------------------------------------------

; 261: prometheus
        .byte ITEM_DEBILITATOR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 262: ghosttrain
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_TENT, ITEM_TENT

; ------------------------------------------------------------------------------

; 263: dadaluma
        .byte ITEM_SNEAK_RING, ITEM_JEWEL_RING
        .byte ITEM_THIEFKNIFE, ITEM_HEAD_BAND

; ------------------------------------------------------------------------------

; 264: shiva
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 265: ifrit
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 266: number_024
        .byte ITEM_DRAINER, ITEM_RUNE_EDGE
        .byte ITEM_FLAME_SABRE, ITEM_BLIZZARD

; ------------------------------------------------------------------------------

; 267: number_128
        .byte ITEM_TEMPEST, ITEM_EMPTY
        .byte ITEM_TENT, ITEM_TENT

; ------------------------------------------------------------------------------

; 268: inferno
        .byte ITEM_ICE_SHLD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 269: crane_1
        .byte ITEM_NOISEBLASTER, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 270: crane_2
        .byte ITEM_DEBILITATOR, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 271: umaro_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 272: umaro_2
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 273: guardian_vector
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 274: guardian_boss
        .byte ITEM_RIBBON, ITEM_FORCE_ARMOR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 275: air_force
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_CZARINA_RING, ITEM_CZARINA_RING

; ------------------------------------------------------------------------------

; 276: tritoch_intro
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 277: tritoch_morph
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 278: flameeater
        .byte ITEM_EMPTY, ITEM_FLAME_SABRE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 279: atmaweapon
        .byte ITEM_RIBBON, ITEM_ELIXIR
        .byte ITEM_ELIXIR, ITEM_ELIXIR

; ------------------------------------------------------------------------------

; 280: nerapa
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 281: srbehemoth
        .byte ITEM_MURASAME, ITEM_EMPTY
        .byte ITEM_BEHEMOTHSUIT, ITEM_BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 282: kefka_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 283: tentacle
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 284: dullahan
        .byte ITEM_GENJI_GLOVE, ITEM_X_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 285: doom_gaze
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 286: chadarnook_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 287: curley
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 288: larry
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 289: moe
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 290: wrexsoul
        .byte ITEM_MEMENTO_RING, ITEM_EMPTY
        .byte ITEM_POD_BRACELET, ITEM_POD_BRACELET

; ------------------------------------------------------------------------------

; 291: hidon
        .byte ITEM_THORNLET, ITEM_WARP_STONE
        .byte ITEM_WARP_STONE, ITEM_WARP_STONE

; ------------------------------------------------------------------------------

; 292: katanasoul
        .byte ITEM_STRATO, ITEM_MURASAME
        .byte ITEM_OFFERING, ITEM_OFFERING

; ------------------------------------------------------------------------------

; 293: l30_magic
        .byte ITEM_TINCTURE, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 294: hidonite
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 295: doom
        .byte ITEM_SAFETY_BIT, ITEM_EMPTY
        .byte ITEM_SKY_RENDER, ITEM_SKY_RENDER

; ------------------------------------------------------------------------------

; 296: goddess
        .byte ITEM_MINERVA, ITEM_EMPTY
        .byte ITEM_EXCALIBUR, ITEM_EXCALIBUR

; ------------------------------------------------------------------------------

; 297: poltrgeist
        .byte ITEM_RED_JACKET, ITEM_EMPTY
        .byte ITEM_AURA_LANCE, ITEM_AURA_LANCE

; ------------------------------------------------------------------------------

; 298: kefka_final
        .byte ITEM_EMPTY, ITEM_MEGALIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 299: l40_magic
        .byte ITEM_TINCTURE, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 300: ultros_river
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 301: ultros_opera
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 302: ultros_mountain
        .byte ITEM_EMPTY, ITEM_WHITE_CAPE
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 303: chupon_airship
        .byte ITEM_EMPTY, ITEM_DIRK
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 304: l20_magic
        .byte ITEM_TINCTURE, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 305: siegfried_2
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_GREEN_CHERRY, ITEM_GREEN_CHERRY

; ------------------------------------------------------------------------------

; 306: l10_magic
        .byte ITEM_TINCTURE, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 307: l50_magic
        .byte ITEM_ETHER, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 308: head
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_POTION, ITEM_POTION

; ------------------------------------------------------------------------------

; 309: whelk_head
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_DRAGON_CLAW, ITEM_DRAGON_CLAW

; ------------------------------------------------------------------------------

; 310: colossus
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_BANDANA, ITEM_BANDANA

; ------------------------------------------------------------------------------

; 311: czardragon
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 312: master_pug
        .byte ITEM_MEGALIXIR, ITEM_ELIXIR
        .byte ITEM_GRAEDUS, ITEM_GRAEDUS

; ------------------------------------------------------------------------------

; 313: l60_magic
        .byte ITEM_ETHER, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 314: merchant
        .byte ITEM_GUARDIAN, ITEM_PLUMED_HAT
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 315: b_day_suit
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 316: tentacle_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 317: tentacle_2
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 318: tentacle_3
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 319: rightblade
        .byte ITEM_TINCTURE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_FENIX_DOWN

; ------------------------------------------------------------------------------

; 320: left_blade
        .byte ITEM_TINCTURE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_FENIX_DOWN

; ------------------------------------------------------------------------------

; 321: rough
        .byte ITEM_FLAME_SHLD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 322: striker
        .byte ITEM_FLAME_SHLD, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 323: l70_magic
        .byte ITEM_ETHER, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 324: tritoch_boss
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 325: laser_gun
        .byte ITEM_EMPTY, ITEM_X_ETHER
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 326: speck
        .byte ITEM_AMULET, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 327: missilebay
        .byte ITEM_DEBILITATOR, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 328: chadarnook_2
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 329: ice_dragon
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_FORCE_SHLD, ITEM_FORCE_SHLD

; ------------------------------------------------------------------------------

; 330: kefka_narshe
        .byte ITEM_ELIXIR, ITEM_ETHER
        .byte ITEM_PEACE_RING, ITEM_PEACE_RING

; ------------------------------------------------------------------------------

; 331: storm_drgn
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_FORCE_ARMOR, ITEM_FORCE_ARMOR

; ------------------------------------------------------------------------------

; 332: dirt_drgn
        .byte ITEM_X_POTION, ITEM_EMPTY
        .byte ITEM_MAGUS_ROD, ITEM_MAGUS_ROD

; ------------------------------------------------------------------------------

; 333: ipooh
        .byte ITEM_POTION, ITEM_POTION
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 334: leader
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_FENIX_DOWN, ITEM_BLACK_BELT

; ------------------------------------------------------------------------------

; 335: grunt
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 336: gold_drgn
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_CRYSTAL_ORB, ITEM_CRYSTAL_ORB

; ------------------------------------------------------------------------------

; 337: skull_drgn
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_MUSCLE_BELT, ITEM_MUSCLE_BELT

; ------------------------------------------------------------------------------

; 338: blue_drgn
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_SCIMITAR, ITEM_SCIMITAR

; ------------------------------------------------------------------------------

; 339: red_dragon
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_STRATO, ITEM_STRATO

; ------------------------------------------------------------------------------

; 340: piranha
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 341: rizopas
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_REMEDY, ITEM_REMEDY

; ------------------------------------------------------------------------------

; 342: specter
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_HYPER_WRIST, ITEM_HYPER_WRIST

; ------------------------------------------------------------------------------

; 343: short_arm
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 344: long_arm
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 345: face
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 346: tiger
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 347: tools
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 348: magic
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 349: hit
        .byte ITEM_EMPTY, ITEM_ELIXIR
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 350: girl
        .byte ITEM_EMPTY, ITEM_RAGNAROK
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 351: sleep
        .byte ITEM_EMPTY, ITEM_ATMA_WEAPON
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 352: hidonite_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 353: hidonite_2
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 354: hidonite_3
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 355: l80_magic
        .byte ITEM_ETHER, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 356: l90_magic
        .byte ITEM_ETHER, ITEM_EMPTY
        .byte ITEM_TINCTURE, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 357: protoarmor
        .byte ITEM_MITHRIL_MAIL, ITEM_POTION
        .byte ITEM_BIO_BLASTER, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 358: magimaster
        .byte ITEM_CRYSTAL_ORB, ITEM_ELIXIR
        .byte ITEM_MEGALIXIR, ITEM_MEGALIXIR

; ------------------------------------------------------------------------------

; 359: soulsaver
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 360: ultros_airship
        .byte ITEM_EMPTY, ITEM_DRIED_MEAT
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 361: naughty
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 362: phunbaba_1
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 363: phunbaba_2
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 364: phunbaba_3
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 365: phunbaba_4
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 366: terra_flashback
        .byte ITEM_STAR_PENDANT, ITEM_FENIX_DOWN
        .byte ITEM_REMEDY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 367: kefka_imp_camp
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 368: cyan_imp_camp
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 369: zone_eater
        .byte ITEM_WARP_STONE, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 370: gau_veldt
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 371: kefka_vs_leo
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 372: kefka_esper_gate
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 373: officer
        .byte ITEM_POTION, ITEM_TONIC
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 374: cadet
        .byte ITEM_EMPTY, ITEM_TONIC
        .byte ITEM_TONIC, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 375: 0177
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 376: 0178
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 377: soldier_flashback
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 378: kefka_vs_esper
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 379: event
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 380: 017c
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 381: atma
        .byte ITEM_CRYSTAL_ORB, ITEM_DRAINER
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 382: shadow_colosseum
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------

; 383: colosseum
        .byte ITEM_EMPTY, ITEM_EMPTY
        .byte ITEM_EMPTY, ITEM_EMPTY

; ------------------------------------------------------------------------------
