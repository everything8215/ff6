; ------------------------------------------------------------------------------

; $00: rare steal
; $01: common steal
; $02: rare drop
; $03: common drop

; ------------------------------------------------------------------------------

; 0: guard
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 1: soldier
        .byte ITEM::TONIC, ITEM::POTION
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 2: templar
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 3: ninja
        .byte ITEM::CHERUB_DOWN, ITEM::EMPTY
        .byte ITEM::NINJA_STAR, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 4: samurai
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 5: orog
        .byte ITEM::AMULET, ITEM::EMPTY
        .byte ITEM::AMULET, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 6: mag_roader_1
        .byte ITEM::SHURIKEN, ITEM::BOLT_EDGE
        .byte ITEM::WATER_EDGE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 7: retainer
        .byte ITEM::AURA, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 8: hazer
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 9: dahling
        .byte ITEM::MOOGLE_SUIT, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 10: rain_man
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 11: brawler
        .byte ITEM::BANDANA, ITEM::EMPTY
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 12: apokryphos
        .byte ITEM::CURE_RING, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 13: dark_force
        .byte ITEM::CRYSTAL, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 14: whisper
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::SOFT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 15: over_mind
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::REVIVIFY, ITEM::GREEN_CHERRY

; ------------------------------------------------------------------------------

; 16: osteosaur
        .byte ITEM::REMEDY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 17: commander
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 18: rhodox
        .byte ITEM::TONIC, ITEM::ANTIDOTE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 19: were_rat
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 20: ursus
        .byte ITEM::SNEAK_RING, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 21: rhinotaur
        .byte ITEM::MITHRIL_CLAW, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 22: steroidite
        .byte ITEM::THUNDER_SHLD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 23: leafer
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 24: stray_cat
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 25: lobo
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 26: doberman
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 27: vomammoth
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 28: fidor
        .byte ITEM::POTION, ITEM::FENIX_DOWN
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 29: baskervor
        .byte ITEM::GAIA_GEAR, ITEM::EMPTY
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 30: suriander
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 31: chimera
        .byte ITEM::HYPER_WRIST, ITEM::EMPTY
        .byte ITEM::GOLD_ARMOR, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 32: behemoth
        .byte ITEM::RUNNINGSHOES, ITEM::EMPTY
        .byte ITEM::X_POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 33: mesosaur
        .byte ITEM::EMPTY, ITEM::ANTIDOTE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 34: pterodon
        .byte ITEM::GUARDIAN, ITEM::MITHRILKNIFE
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 35: fossilfang
        .byte ITEM::REMEDY, ITEM::REVIVIFY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 36: white_drgn
        .byte ITEM::PEARL_LANCE, ITEM::X_POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 37: doom_drgn
        .byte ITEM::POD_BRACELET, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 38: brachosaur
        .byte ITEM::RIBBON, ITEM::EMPTY
        .byte ITEM::ECONOMIZER, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 39: tyranosaur
        .byte ITEM::IMPS_ARMOR, ITEM::EMPTY
        .byte ITEM::IMP_HALBERD, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 40: dark_wind
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 41: beakor
        .byte ITEM::POTION, ITEM::EYEDROP
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 42: vulture
        .byte ITEM::FENIX_DOWN, ITEM::POTION
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 43: harpy
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 44: hermitcrab
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 45: trapper
        .byte ITEM::AUTOCROSSBOW, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 46: hornet
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 47: crasshoppr
        .byte ITEM::ANTIDOTE, ITEM::ANTIDOTE
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 48: delta_bug
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::SLEEPING_BAG, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 49: gilomantis
        .byte ITEM::POISON_CLAW, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 50: trilium
        .byte ITEM::REMEDY, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 51: nightshade
        .byte ITEM::NUTKIN_SUIT, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 52: tumbleweed
        .byte ITEM::TITANIUM, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 53: bloompire
        .byte ITEM::ECHO_SCREEN, ITEM::EMPTY
        .byte ITEM::SMOKE_BOMB, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 54: trilobiter
        .byte ITEM::TONIC, ITEM::ANTIDOTE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 55: siegfried_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 56: nautiloid
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::EYEDROP, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 57: exocite
        .byte ITEM::MITHRIL_CLAW, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 58: anguiform
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 59: reach_frog
        .byte ITEM::TACK_STAR, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 60: lizard
        .byte ITEM::DRAINER, ITEM::EMPTY
        .byte ITEM::SOFT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 61: chickenlip
        .byte ITEM::SLEEPING_BAG, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 62: hoover
        .byte ITEM::REMEDY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 63: rider
        .byte ITEM::ELIXIR, ITEM::MITHRIL_VEST
        .byte ITEM::REMEDY, ITEM::REMEDY

; ------------------------------------------------------------------------------

; 64: chupon_colosseum
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 65: pipsqueak
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 66: m_tekarmor
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::POTION

; ------------------------------------------------------------------------------

; 67: sky_armor
        .byte ITEM::EMPTY, ITEM::TINCTURE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 68: telstar
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::GREEN_BERET, ITEM::GREEN_BERET

; ------------------------------------------------------------------------------

; 69: lethal_wpn
        .byte ITEM::DEBILITATOR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 70: vaporite
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 71: flan
        .byte ITEM::MAGICITE, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 72: ing
        .byte ITEM::AMULET, ITEM::EMPTY
        .byte ITEM::REVIVIFY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 73: humpty
        .byte ITEM::EMPTY, ITEM::GREEN_CHERRY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 74: brainpan
        .byte ITEM::EARRINGS, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 75: cruller
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 76: cactrot
        .byte ITEM::SOFT, ITEM::EMPTY
        .byte ITEM::SOFT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 77: repo_man
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 78: harvester
        .byte ITEM::DRAGOONBOOTS, ITEM::GOGGLES
        .byte ITEM::BARRIER_RING, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 79: bomb
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 80: still_life
        .byte ITEM::FAKEMUSTACHE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 81: boxed_set
        .byte ITEM::ANTIDOTE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 82: slamdancer
        .byte ITEM::THIEFKNIFE, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 83: hadesgigas
        .byte ITEM::ATLAS_ARMLET, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 84: pug
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::TINTINABAR, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 85: magic_urn
        .byte ITEM::ELIXIR, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 86: mover
        .byte ITEM::EMPTY, ITEM::SUPER_BALL
        .byte ITEM::MAGICITE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 87: figaliz
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 88: buffalax
        .byte ITEM::DIAMOND_VEST, ITEM::TINCTURE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 89: aspik
        .byte ITEM::TONIC, ITEM::EMPTY
        .byte ITEM::X_POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 90: ghost
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 91: crawler
        .byte ITEM::REMEDY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 92: sand_ray
        .byte ITEM::ANTIDOTE, ITEM::ANTIDOTE
        .byte ITEM::ANTIDOTE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 93: areneid
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 94: actaneon
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 95: sand_horse
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 96: dark_side
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 97: mad_oscar
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::REMEDY, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 98: crawly
        .byte ITEM::REMEDY, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 99: bleary
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 100: marshal
        .byte ITEM::EMPTY, ITEM::MITHRILKNIFE
        .byte ITEM::POTION, ITEM::POTION

; ------------------------------------------------------------------------------

; 101: trooper
        .byte ITEM::MITHRILBLADE, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 102: general
        .byte ITEM::MITHRIL_SHLD, ITEM::TONIC
        .byte ITEM::GREEN_CHERRY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 103: covert
        .byte ITEM::TACK_STAR, ITEM::SHURIKEN
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 104: ogor
        .byte ITEM::MURASAME, ITEM::ASHURA
        .byte ITEM::EMPTY, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 105: warlock
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 106: madam
        .byte ITEM::GOGGLES, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 107: joker
        .byte ITEM::GREEN_BERET, ITEM::TONIC
        .byte ITEM::MITHRIL_ROD, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 108: iron_fist
        .byte ITEM::HEAD_BAND, ITEM::TONIC
        .byte ITEM::MITHRILKNIFE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 109: goblin
        .byte ITEM::MITHRILGLOVE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 110: apparite
        .byte ITEM::POTION, ITEM::REVIVIFY
        .byte ITEM::REVIVIFY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 111: powerdemon
        .byte ITEM::DIAMOND_VEST, ITEM::POTION
        .byte ITEM::AMULET, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 112: displayer
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 113: vector_pup
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 114: peepers
        .byte ITEM::ELIXIR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 115: sewer_rat
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 116: slatter
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 117: rhinox
        .byte ITEM::FLASH, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 118: rhobite
        .byte ITEM::POTION, ITEM::POTION
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 119: wild_cat
        .byte ITEM::TABBY_SUIT, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 120: red_fang
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::DRIED_MEAT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 121: bounty_man
        .byte ITEM::POTION, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 122: tusker
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::SOFT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 123: ralph
        .byte ITEM::TIGER_MASK, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 124: chitonid
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::REMEDY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 125: wart_puck
        .byte ITEM::DRIED_MEAT, ITEM::FLAIL
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 126: rhyos
        .byte ITEM::GOLD_LANCE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 127: srbehemoth_undead
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::BEHEMOTHSUIT, ITEM::BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 128: vectaur
        .byte ITEM::NINJA_STAR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 129: wyvern
        .byte ITEM::DRAGOONBOOTS, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 130: zombone
        .byte ITEM::POTION, ITEM::FENIX_DOWN
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 131: dragon
        .byte ITEM::GENJI_GLOVE, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 132: brontaur
        .byte ITEM::DRIED_MEAT, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 133: allosaurus
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 134: cirpius
        .byte ITEM::TONIC, ITEM::ANTIDOTE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 135: sprinter
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::IMPS_ARMOR, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 136: gobbler
        .byte ITEM::POTION, ITEM::GREEN_CHERRY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 137: harpiai
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 138: gloomshell
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 139: drop
        .byte ITEM::EMPTY, ITEM::TINCTURE
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 140: mind_candy
        .byte ITEM::TONIC, ITEM::SOFT
        .byte ITEM::SOFT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 141: weedfeeder
        .byte ITEM::ANTIDOTE, ITEM::ANTIDOTE
        .byte ITEM::ECHO_SCREEN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 142: luridan
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 143: toe_cutter
        .byte ITEM::EMPTY, ITEM::POISON_ROD
        .byte ITEM::POISON_ROD, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 144: over_grunk
        .byte ITEM::REMEDY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 145: exoray
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 146: crusher
        .byte ITEM::EMPTY, ITEM::SUPER_BALL
        .byte ITEM::SUPER_BALL, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 147: uroburos
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 148: primordite
        .byte ITEM::TONIC, ITEM::EYEDROP
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 149: sky_cap
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 150: cephaler
        .byte ITEM::REMEDY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 151: maliga
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 152: gigan_toad
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::SLEEPING_BAG, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 153: geckorex
        .byte ITEM::TORTOISESHLD, ITEM::EMPTY
        .byte ITEM::TORTOISESHLD, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 154: cluck
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 155: land_worm
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 156: test_rider
        .byte ITEM::PARTISAN, ITEM::EMPTY
        .byte ITEM::STOUT_SPEAR, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 157: plutoarmor
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 158: tomb_thumb
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::GREEN_CHERRY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 159: heavyarmor
        .byte ITEM::IRONHELMET, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 160: chaser
        .byte ITEM::BIO_BLASTER, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 161: scullion
        .byte ITEM::AIR_ANCHOR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 162: poplium
        .byte ITEM::POTION, ITEM::EMPTY
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 163: intangir
        .byte ITEM::MAGICITE, ITEM::EMPTY
        .byte ITEM::ANTIDOTE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 164: misfit
        .byte ITEM::BACK_GUARD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 165: eland
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 166: enuo
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 167: deep_eye
        .byte ITEM::EMPTY, ITEM::EYEDROP
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 168: greasemonk
        .byte ITEM::BUCKLER, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 169: neckhunter
        .byte ITEM::DARK_HOOD, ITEM::EMPTY
        .byte ITEM::PEACE_RING, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 170: grenade
        .byte ITEM::FIRE_SKEAN, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 171: critic
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 172: pan_dora
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 173: souldancer
        .byte ITEM::MOOGLE_SUIT, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 174: gigantos
        .byte ITEM::ELIXIR, ITEM::X_POTION
        .byte ITEM::HARDENED, ITEM::HARDENED

; ------------------------------------------------------------------------------

; 175: mag_roader_2
        .byte ITEM::SHURIKEN, ITEM::BOLT_EDGE
        .byte ITEM::FIRE_SKEAN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 176: spek_tor
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 177: parasite
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 178: earthguard
        .byte ITEM::MEGALIXIR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 179: coelecite
        .byte ITEM::POTION, ITEM::ANTIDOTE
        .byte ITEM::ANTIDOTE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 180: anemone
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::GREEN_CHERRY

; ------------------------------------------------------------------------------

; 181: hipocampus
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 182: spectre
        .byte ITEM::ICE_ROD, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 183: evil_oscar
        .byte ITEM::EMPTY, ITEM::WARP_STONE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 184: slurm
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 185: latimeria
        .byte ITEM::EMPTY, ITEM::GAIA_GEAR
        .byte ITEM::ANTIDOTE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 186: stillgoing
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 187: allo_ver
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::TIGER_FANGS, ITEM::TIGER_FANGS

; ------------------------------------------------------------------------------

; 188: phase
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 189: outsider
        .byte ITEM::BREAK_BLADE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 190: barb_e
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 191: parasoul
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 192: pm_stalker
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 193: hemophyte
        .byte ITEM::TACK_STAR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 194: sp_forces
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::MAGICITE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 195: nohrabbit
        .byte ITEM::EMPTY, ITEM::REMEDY
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 196: wizard
        .byte ITEM::ICE_ROD, ITEM::THUNDER_ROD
        .byte ITEM::FIRE_ROD, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 197: scrapper
        .byte ITEM::THIEF_GLOVE, ITEM::EMPTY
        .byte ITEM::AIR_LANCET, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 198: ceritops
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::WHITE_CAPE, ITEM::GREEN_CHERRY

; ------------------------------------------------------------------------------

; 199: commando
        .byte ITEM::MITHRIL_VEST, ITEM::TENT
        .byte ITEM::TENT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 200: opinicus
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::WARP_STONE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 201: poppers
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::GREEN_CHERRY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 202: lunaris
        .byte ITEM::POTION, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 203: garm
        .byte ITEM::FENIX_DOWN, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 204: vindr
        .byte ITEM::CHOCOBO_SUIT, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 205: kiwok
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::WHITE_CAPE, ITEM::GREEN_CHERRY

; ------------------------------------------------------------------------------

; 206: nastidon
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 207: rinn
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 208: insecare
        .byte ITEM::EMPTY, ITEM::ECHO_SCREEN
        .byte ITEM::SMOKE_BOMB, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 209: vermin
        .byte ITEM::ANTIDOTE, ITEM::POTION
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 210: mantodea
        .byte ITEM::IMP_HALBERD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 211: bogy
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 212: prussian
        .byte ITEM::FULL_MOON, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 213: black_drgn
        .byte ITEM::EMPTY, ITEM::REVIVIFY
        .byte ITEM::TENT, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 214: adamanchyt
        .byte ITEM::GOLD_SHLD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 215: dante
        .byte ITEM::DIAMOND_HELM, ITEM::EMPTY
        .byte ITEM::GOLD_SHLD, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 216: wirey_drgn
        .byte ITEM::DRAGOONBOOTS, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 217: dueller
        .byte ITEM::CHAIN_SAW, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 218: psychot
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 219: muus
        .byte ITEM::MAGICITE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 220: karkass
        .byte ITEM::SOUL_SABRE, ITEM::MITHRILBLADE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 221: punisher
        .byte ITEM::BONE_CLUB, ITEM::RISING_SUN
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 222: balloon
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 223: gabbldegak
        .byte ITEM::FENIX_DOWN, ITEM::EYEDROP
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 224: gtbehemoth
        .byte ITEM::TIGER_FANGS, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 225: scorpion
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 226: chaos_drgn
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 227: spit_fire
        .byte ITEM::ELIXIR, ITEM::TINCTURE
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 228: vectagoyle
        .byte ITEM::SWORDBREAKER, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 229: lich
        .byte ITEM::POISON_ROD, ITEM::GREEN_CHERRY
        .byte ITEM::GREEN_CHERRY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 230: osprey
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::ECHO_SCREEN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 231: mag_roader_3
        .byte ITEM::SHURIKEN, ITEM::BOLT_EDGE
        .byte ITEM::WATER_EDGE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 232: bug
        .byte ITEM::POTION, ITEM::SOFT
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 233: sea_flower
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 234: fortis
        .byte ITEM::DRILL, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 235: abolisher
        .byte ITEM::EMPTY, ITEM::ANTIDOTE
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 236: aquila
        .byte ITEM::ECONOMIZER, ITEM::FENIX_DOWN
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 237: junk
        .byte ITEM::NOISEBLASTER, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 238: mandrake
        .byte ITEM::POTION, ITEM::POTION
        .byte ITEM::REMEDY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 239: 1st_class
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 240: tap_dancer
        .byte ITEM::SWORDBREAKER, ITEM::DIRK
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 241: necromancr
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::REVIVIFY

; ------------------------------------------------------------------------------

; 242: borras
        .byte ITEM::MUSCLE_BELT, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 243: mag_roader_4
        .byte ITEM::SHURIKEN, ITEM::BOLT_EDGE
        .byte ITEM::FIRE_SKEAN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 244: wild_rat
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 245: gold_bear
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::POTION, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 246: innoc
        .byte ITEM::BIO_BLASTER, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 247: trixter
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 248: red_wolf
        .byte ITEM::TONIC, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 249: didalos
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 250: woolly
        .byte ITEM::HARDENED, ITEM::IMPERIAL
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 251: veteran
        .byte ITEM::EARRINGS, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 252: sky_base
        .byte ITEM::FLASH, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 253: ironhitman
        .byte ITEM::AUTOCROSSBOW, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 254: io
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 255: pugs
        .byte ITEM::MINERVA, ITEM::EMPTY
        .byte ITEM::MINERVA, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 256: whelk
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::TINCTURE

; ------------------------------------------------------------------------------

; 257: presenter
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::DRAGON_CLAW, ITEM::DRAGON_CLAW

; ------------------------------------------------------------------------------

; 258: mega_armor
        .byte ITEM::EMPTY, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 259: vargas
        .byte ITEM::MITHRIL_CLAW, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 260: tunnelarmr
        .byte ITEM::BIO_BLASTER, ITEM::AIR_LANCET
        .byte ITEM::ELIXIR, ITEM::ELIXIR

; ------------------------------------------------------------------------------

; 261: prometheus
        .byte ITEM::DEBILITATOR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 262: ghosttrain
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::TENT, ITEM::TENT

; ------------------------------------------------------------------------------

; 263: dadaluma
        .byte ITEM::SNEAK_RING, ITEM::JEWEL_RING
        .byte ITEM::THIEFKNIFE, ITEM::HEAD_BAND

; ------------------------------------------------------------------------------

; 264: shiva
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 265: ifrit
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 266: number_024
        .byte ITEM::DRAINER, ITEM::RUNE_EDGE
        .byte ITEM::FLAME_SABRE, ITEM::BLIZZARD

; ------------------------------------------------------------------------------

; 267: number_128
        .byte ITEM::TEMPEST, ITEM::EMPTY
        .byte ITEM::TENT, ITEM::TENT

; ------------------------------------------------------------------------------

; 268: inferno
        .byte ITEM::ICE_SHLD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 269: crane_1
        .byte ITEM::NOISEBLASTER, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 270: crane_2
        .byte ITEM::DEBILITATOR, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 271: umaro_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 272: umaro_2
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 273: guardian_vector
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 274: guardian_boss
        .byte ITEM::RIBBON, ITEM::FORCE_ARMOR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 275: air_force
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::CZARINA_RING, ITEM::CZARINA_RING

; ------------------------------------------------------------------------------

; 276: tritoch_intro
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 277: tritoch_morph
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 278: flameeater
        .byte ITEM::EMPTY, ITEM::FLAME_SABRE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 279: atmaweapon
        .byte ITEM::RIBBON, ITEM::ELIXIR
        .byte ITEM::ELIXIR, ITEM::ELIXIR

; ------------------------------------------------------------------------------

; 280: nerapa
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 281: srbehemoth
        .byte ITEM::MURASAME, ITEM::EMPTY
        .byte ITEM::BEHEMOTHSUIT, ITEM::BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 282: kefka_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 283: tentacle
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 284: dullahan
        .byte ITEM::GENJI_GLOVE, ITEM::X_POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 285: doom_gaze
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 286: chadarnook_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 287: curley
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 288: larry
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 289: moe
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 290: wrexsoul
        .byte ITEM::MEMENTO_RING, ITEM::EMPTY
        .byte ITEM::POD_BRACELET, ITEM::POD_BRACELET

; ------------------------------------------------------------------------------

; 291: hidon
        .byte ITEM::THORNLET, ITEM::WARP_STONE
        .byte ITEM::WARP_STONE, ITEM::WARP_STONE

; ------------------------------------------------------------------------------

; 292: katanasoul
        .byte ITEM::STRATO, ITEM::MURASAME
        .byte ITEM::OFFERING, ITEM::OFFERING

; ------------------------------------------------------------------------------

; 293: l30_magic
        .byte ITEM::TINCTURE, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 294: hidonite
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 295: doom
        .byte ITEM::SAFETY_BIT, ITEM::EMPTY
        .byte ITEM::SKY_RENDER, ITEM::SKY_RENDER

; ------------------------------------------------------------------------------

; 296: goddess
        .byte ITEM::MINERVA, ITEM::EMPTY
        .byte ITEM::EXCALIBUR, ITEM::EXCALIBUR

; ------------------------------------------------------------------------------

; 297: poltrgeist
        .byte ITEM::RED_JACKET, ITEM::EMPTY
        .byte ITEM::AURA_LANCE, ITEM::AURA_LANCE

; ------------------------------------------------------------------------------

; 298: kefka_final
        .byte ITEM::EMPTY, ITEM::MEGALIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 299: l40_magic
        .byte ITEM::TINCTURE, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 300: ultros_river
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 301: ultros_opera
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 302: ultros_mountain
        .byte ITEM::EMPTY, ITEM::WHITE_CAPE
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 303: chupon_airship
        .byte ITEM::EMPTY, ITEM::DIRK
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 304: l20_magic
        .byte ITEM::TINCTURE, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 305: siegfried_2
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::GREEN_CHERRY, ITEM::GREEN_CHERRY

; ------------------------------------------------------------------------------

; 306: l10_magic
        .byte ITEM::TINCTURE, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 307: l50_magic
        .byte ITEM::ETHER, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 308: head
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::POTION, ITEM::POTION

; ------------------------------------------------------------------------------

; 309: whelk_head
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::DRAGON_CLAW, ITEM::DRAGON_CLAW

; ------------------------------------------------------------------------------

; 310: colossus
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::BANDANA, ITEM::BANDANA

; ------------------------------------------------------------------------------

; 311: czardragon
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 312: master_pug
        .byte ITEM::MEGALIXIR, ITEM::ELIXIR
        .byte ITEM::GRAEDUS, ITEM::GRAEDUS

; ------------------------------------------------------------------------------

; 313: l60_magic
        .byte ITEM::ETHER, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 314: merchant
        .byte ITEM::GUARDIAN, ITEM::PLUMED_HAT
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 315: b_day_suit
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 316: tentacle_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 317: tentacle_2
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 318: tentacle_3
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 319: rightblade
        .byte ITEM::TINCTURE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::FENIX_DOWN

; ------------------------------------------------------------------------------

; 320: left_blade
        .byte ITEM::TINCTURE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::FENIX_DOWN

; ------------------------------------------------------------------------------

; 321: rough
        .byte ITEM::FLAME_SHLD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 322: striker
        .byte ITEM::FLAME_SHLD, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 323: l70_magic
        .byte ITEM::ETHER, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 324: tritoch_boss
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 325: laser_gun
        .byte ITEM::EMPTY, ITEM::X_ETHER
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 326: speck
        .byte ITEM::AMULET, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 327: missilebay
        .byte ITEM::DEBILITATOR, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 328: chadarnook_2
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 329: ice_dragon
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::FORCE_SHLD, ITEM::FORCE_SHLD

; ------------------------------------------------------------------------------

; 330: kefka_narshe
        .byte ITEM::ELIXIR, ITEM::ETHER
        .byte ITEM::PEACE_RING, ITEM::PEACE_RING

; ------------------------------------------------------------------------------

; 331: storm_drgn
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::FORCE_ARMOR, ITEM::FORCE_ARMOR

; ------------------------------------------------------------------------------

; 332: dirt_drgn
        .byte ITEM::X_POTION, ITEM::EMPTY
        .byte ITEM::MAGUS_ROD, ITEM::MAGUS_ROD

; ------------------------------------------------------------------------------

; 333: ipooh
        .byte ITEM::POTION, ITEM::POTION
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 334: leader
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::FENIX_DOWN, ITEM::BLACK_BELT

; ------------------------------------------------------------------------------

; 335: grunt
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 336: gold_drgn
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::CRYSTAL_ORB, ITEM::CRYSTAL_ORB

; ------------------------------------------------------------------------------

; 337: skull_drgn
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::MUSCLE_BELT, ITEM::MUSCLE_BELT

; ------------------------------------------------------------------------------

; 338: blue_drgn
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::SCIMITAR, ITEM::SCIMITAR

; ------------------------------------------------------------------------------

; 339: red_dragon
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::STRATO, ITEM::STRATO

; ------------------------------------------------------------------------------

; 340: piranha
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 341: rizopas
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::REMEDY, ITEM::REMEDY

; ------------------------------------------------------------------------------

; 342: specter
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::HYPER_WRIST, ITEM::HYPER_WRIST

; ------------------------------------------------------------------------------

; 343: short_arm
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 344: long_arm
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 345: face
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 346: tiger
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 347: tools
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 348: magic
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 349: hit
        .byte ITEM::EMPTY, ITEM::ELIXIR
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 350: girl
        .byte ITEM::EMPTY, ITEM::RAGNAROK
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 351: sleep
        .byte ITEM::EMPTY, ITEM::ATMA_WEAPON
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 352: hidonite_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 353: hidonite_2
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 354: hidonite_3
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 355: l80_magic
        .byte ITEM::ETHER, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 356: l90_magic
        .byte ITEM::ETHER, ITEM::EMPTY
        .byte ITEM::TINCTURE, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 357: protoarmor
        .byte ITEM::MITHRIL_MAIL, ITEM::POTION
        .byte ITEM::BIO_BLASTER, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 358: magimaster
        .byte ITEM::CRYSTAL_ORB, ITEM::ELIXIR
        .byte ITEM::MEGALIXIR, ITEM::MEGALIXIR

; ------------------------------------------------------------------------------

; 359: soulsaver
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 360: ultros_airship
        .byte ITEM::EMPTY, ITEM::DRIED_MEAT
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 361: naughty
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 362: phunbaba_1
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 363: phunbaba_2
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 364: phunbaba_3
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 365: phunbaba_4
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 366: terra_flashback
        .byte ITEM::STAR_PENDANT, ITEM::FENIX_DOWN
        .byte ITEM::REMEDY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 367: kefka_imp_camp
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 368: cyan_imp_camp
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 369: zone_eater
        .byte ITEM::WARP_STONE, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 370: gau_veldt
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 371: kefka_vs_leo
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 372: kefka_esper_gate
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 373: officer
        .byte ITEM::POTION, ITEM::TONIC
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 374: cadet
        .byte ITEM::EMPTY, ITEM::TONIC
        .byte ITEM::TONIC, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 375: 0177
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 376: 0178
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 377: soldier_flashback
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 378: kefka_vs_esper
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 379: event
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 380: 017c
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 381: atma
        .byte ITEM::CRYSTAL_ORB, ITEM::DRAINER
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 382: shadow_colosseum
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------

; 383: colosseum
        .byte ITEM::EMPTY, ITEM::EMPTY
        .byte ITEM::EMPTY, ITEM::EMPTY

; ------------------------------------------------------------------------------
