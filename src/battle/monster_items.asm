; ------------------------------------------------------------------------------

; $00: rare steal
; $01: common steal
; $02: rare drop
; $03: common drop

.mac make_monster_steal rare_item, common_item
        .byte ITEM::rare_item, ITEM::common_item
.endmac

.define make_monster_drop make_monster_steal

; ------------------------------------------------------------------------------

; 0: guard
        make_monster_steal      POTION, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 1: soldier
        make_monster_steal      TONIC, POTION
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 2: templar
        make_monster_steal      TONIC, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 3: ninja
        make_monster_steal      CHERUB_DOWN, EMPTY
        make_monster_drop       NINJA_STAR, EMPTY

; ------------------------------------------------------------------------------

; 4: samurai
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 5: orog
        make_monster_steal      AMULET, EMPTY
        make_monster_drop       AMULET, REVIVIFY

; ------------------------------------------------------------------------------

; 6: mag_roader_1
        make_monster_steal      SHURIKEN, BOLT_EDGE
        make_monster_drop       WATER_EDGE, EMPTY

; ------------------------------------------------------------------------------

; 7: retainer
        make_monster_steal      AURA, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 8: hazer
        make_monster_steal      POTION, EMPTY
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 9: dahling
        make_monster_steal      MOOGLE_SUIT, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 10: rain_man
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 11: brawler
        make_monster_steal      BANDANA, EMPTY
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 12: apokryphos
        make_monster_steal      CURE_RING, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 13: dark_force
        make_monster_steal      CRYSTAL, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 14: whisper
        make_monster_steal      POTION, EMPTY
        make_monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 15: over_mind
        make_monster_steal      POTION, EMPTY
        make_monster_drop       REVIVIFY, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 16: osteosaur
        make_monster_steal      REMEDY, EMPTY
        make_monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 17: commander
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 18: rhodox
        make_monster_steal      TONIC, ANTIDOTE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 19: were_rat
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 20: ursus
        make_monster_steal      SNEAK_RING, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 21: rhinotaur
        make_monster_steal      MITHRIL_CLAW, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 22: steroidite
        make_monster_steal      THUNDER_SHLD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 23: leafer
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 24: stray_cat
        make_monster_steal      POTION, EMPTY
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 25: lobo
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 26: doberman
        make_monster_steal      POTION, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 27: vomammoth
        make_monster_steal      POTION, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 28: fidor
        make_monster_steal      POTION, FENIX_DOWN
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 29: baskervor
        make_monster_steal      GAIA_GEAR, EMPTY
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 30: suriander
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 31: chimera
        make_monster_steal      HYPER_WRIST, EMPTY
        make_monster_drop       GOLD_ARMOR, EMPTY

; ------------------------------------------------------------------------------

; 32: behemoth
        make_monster_steal      RUNNINGSHOES, EMPTY
        make_monster_drop       X_POTION, EMPTY

; ------------------------------------------------------------------------------

; 33: mesosaur
        make_monster_steal      EMPTY, ANTIDOTE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 34: pterodon
        make_monster_steal      GUARDIAN, MITHRILKNIFE
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 35: fossilfang
        make_monster_steal      REMEDY, REVIVIFY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 36: white_drgn
        make_monster_steal      PEARL_LANCE, X_POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 37: doom_drgn
        make_monster_steal      POD_BRACELET, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 38: brachosaur
        make_monster_steal      RIBBON, EMPTY
        make_monster_drop       ECONOMIZER, EMPTY

; ------------------------------------------------------------------------------

; 39: tyranosaur
        make_monster_steal      IMPS_ARMOR, EMPTY
        make_monster_drop       IMP_HALBERD, EMPTY

; ------------------------------------------------------------------------------

; 40: dark_wind
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 41: beakor
        make_monster_steal      POTION, EYEDROP
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 42: vulture
        make_monster_steal      FENIX_DOWN, POTION
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 43: harpy
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 44: hermitcrab
        make_monster_steal      EMPTY, POTION
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 45: trapper
        make_monster_steal      AUTOCROSSBOW, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 46: hornet
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 47: crasshoppr
        make_monster_steal      ANTIDOTE, ANTIDOTE
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 48: delta_bug
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       SLEEPING_BAG, EMPTY

; ------------------------------------------------------------------------------

; 49: gilomantis
        make_monster_steal      POISON_CLAW, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 50: trilium
        make_monster_steal      REMEDY, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 51: nightshade
        make_monster_steal      NUTKIN_SUIT, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 52: tumbleweed
        make_monster_steal      TITANIUM, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 53: bloompire
        make_monster_steal      ECHO_SCREEN, EMPTY
        make_monster_drop       SMOKE_BOMB, EMPTY

; ------------------------------------------------------------------------------

; 54: trilobiter
        make_monster_steal      TONIC, ANTIDOTE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 55: siegfried_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 56: nautiloid
        make_monster_steal      POTION, TONIC
        make_monster_drop       EYEDROP, EMPTY

; ------------------------------------------------------------------------------

; 57: exocite
        make_monster_steal      MITHRIL_CLAW, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 58: anguiform
        make_monster_steal      POTION, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 59: reach_frog
        make_monster_steal      TACK_STAR, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 60: lizard
        make_monster_steal      DRAINER, EMPTY
        make_monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 61: chickenlip
        make_monster_steal      SLEEPING_BAG, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 62: hoover
        make_monster_steal      REMEDY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 63: rider
        make_monster_steal      ELIXIR, MITHRIL_VEST
        make_monster_drop       REMEDY, REMEDY

; ------------------------------------------------------------------------------

; 64: chupon_colosseum
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 65: pipsqueak
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 66: m_tekarmor
        make_monster_steal      POTION, TONIC
        make_monster_drop       EMPTY, POTION

; ------------------------------------------------------------------------------

; 67: sky_armor
        make_monster_steal      EMPTY, TINCTURE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 68: telstar
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       GREEN_BERET, GREEN_BERET

; ------------------------------------------------------------------------------

; 69: lethal_wpn
        make_monster_steal      DEBILITATOR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 70: vaporite
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 71: flan
        make_monster_steal      MAGICITE, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 72: ing
        make_monster_steal      AMULET, EMPTY
        make_monster_drop       REVIVIFY, EMPTY

; ------------------------------------------------------------------------------

; 73: humpty
        make_monster_steal      EMPTY, GREEN_CHERRY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 74: brainpan
        make_monster_steal      EARRINGS, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 75: cruller
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 76: cactrot
        make_monster_steal      SOFT, EMPTY
        make_monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 77: repo_man
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 78: harvester
        make_monster_steal      DRAGOONBOOTS, GOGGLES
        make_monster_drop       BARRIER_RING, EMPTY

; ------------------------------------------------------------------------------

; 79: bomb
        make_monster_steal      POTION, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 80: still_life
        make_monster_steal      FAKEMUSTACHE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 81: boxed_set
        make_monster_steal      ANTIDOTE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 82: slamdancer
        make_monster_steal      THIEFKNIFE, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 83: hadesgigas
        make_monster_steal      ATLAS_ARMLET, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 84: pug
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       TINTINABAR, EMPTY

; ------------------------------------------------------------------------------

; 85: magic_urn
        make_monster_steal      ELIXIR, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 86: mover
        make_monster_steal      EMPTY, SUPER_BALL
        make_monster_drop       MAGICITE, EMPTY

; ------------------------------------------------------------------------------

; 87: figaliz
        make_monster_steal      POTION, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 88: buffalax
        make_monster_steal      DIAMOND_VEST, TINCTURE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 89: aspik
        make_monster_steal      TONIC, EMPTY
        make_monster_drop       X_POTION, EMPTY

; ------------------------------------------------------------------------------

; 90: ghost
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 91: crawler
        make_monster_steal      REMEDY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 92: sand_ray
        make_monster_steal      ANTIDOTE, ANTIDOTE
        make_monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 93: areneid
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 94: actaneon
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 95: sand_horse
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 96: dark_side
        make_monster_steal      TONIC, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 97: mad_oscar
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       REMEDY, REVIVIFY

; ------------------------------------------------------------------------------

; 98: crawly
        make_monster_steal      REMEDY, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 99: bleary
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 100: marshal
        make_monster_steal      EMPTY, MITHRILKNIFE
        make_monster_drop       POTION, POTION

; ------------------------------------------------------------------------------

; 101: trooper
        make_monster_steal      MITHRILBLADE, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 102: general
        make_monster_steal      MITHRIL_SHLD, TONIC
        make_monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 103: covert
        make_monster_steal      TACK_STAR, SHURIKEN
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 104: ogor
        make_monster_steal      MURASAME, ASHURA
        make_monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 105: warlock
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 106: madam
        make_monster_steal      GOGGLES, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 107: joker
        make_monster_steal      GREEN_BERET, TONIC
        make_monster_drop       MITHRIL_ROD, EMPTY

; ------------------------------------------------------------------------------

; 108: iron_fist
        make_monster_steal      HEAD_BAND, TONIC
        make_monster_drop       MITHRILKNIFE, EMPTY

; ------------------------------------------------------------------------------

; 109: goblin
        make_monster_steal      MITHRILGLOVE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 110: apparite
        make_monster_steal      POTION, REVIVIFY
        make_monster_drop       REVIVIFY, EMPTY

; ------------------------------------------------------------------------------

; 111: powerdemon
        make_monster_steal      DIAMOND_VEST, POTION
        make_monster_drop       AMULET, REVIVIFY

; ------------------------------------------------------------------------------

; 112: displayer
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 113: vector_pup
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 114: peepers
        make_monster_steal      ELIXIR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 115: sewer_rat
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 116: slatter
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 117: rhinox
        make_monster_steal      FLASH, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 118: rhobite
        make_monster_steal      POTION, POTION
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 119: wild_cat
        make_monster_steal      TABBY_SUIT, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 120: red_fang
        make_monster_steal      TONIC, TONIC
        make_monster_drop       DRIED_MEAT, EMPTY

; ------------------------------------------------------------------------------

; 121: bounty_man
        make_monster_steal      POTION, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 122: tusker
        make_monster_steal      POTION, TONIC
        make_monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 123: ralph
        make_monster_steal      TIGER_MASK, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 124: chitonid
        make_monster_steal      EMPTY, POTION
        make_monster_drop       REMEDY, EMPTY

; ------------------------------------------------------------------------------

; 125: wart_puck
        make_monster_steal      DRIED_MEAT, FLAIL
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 126: rhyos
        make_monster_steal      GOLD_LANCE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 127: srbehemoth_undead
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       BEHEMOTHSUIT, BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 128: vectaur
        make_monster_steal      NINJA_STAR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 129: wyvern
        make_monster_steal      DRAGOONBOOTS, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 130: zombone
        make_monster_steal      POTION, FENIX_DOWN
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 131: dragon
        make_monster_steal      GENJI_GLOVE, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 132: brontaur
        make_monster_steal      DRIED_MEAT, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 133: allosaurus
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 134: cirpius
        make_monster_steal      TONIC, ANTIDOTE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 135: sprinter
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       IMPS_ARMOR, EMPTY

; ------------------------------------------------------------------------------

; 136: gobbler
        make_monster_steal      POTION, GREEN_CHERRY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 137: harpiai
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 138: gloomshell
        make_monster_steal      POTION, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 139: drop
        make_monster_steal      EMPTY, TINCTURE
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 140: mind_candy
        make_monster_steal      TONIC, SOFT
        make_monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 141: weedfeeder
        make_monster_steal      ANTIDOTE, ANTIDOTE
        make_monster_drop       ECHO_SCREEN, EMPTY

; ------------------------------------------------------------------------------

; 142: luridan
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 143: toe_cutter
        make_monster_steal      EMPTY, POISON_ROD
        make_monster_drop       POISON_ROD, EMPTY

; ------------------------------------------------------------------------------

; 144: over_grunk
        make_monster_steal      REMEDY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 145: exoray
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 146: crusher
        make_monster_steal      EMPTY, SUPER_BALL
        make_monster_drop       SUPER_BALL, EMPTY

; ------------------------------------------------------------------------------

; 147: uroburos
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 148: primordite
        make_monster_steal      TONIC, EYEDROP
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 149: sky_cap
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 150: cephaler
        make_monster_steal      REMEDY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 151: maliga
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 152: gigan_toad
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       SLEEPING_BAG, EMPTY

; ------------------------------------------------------------------------------

; 153: geckorex
        make_monster_steal      TORTOISESHLD, EMPTY
        make_monster_drop       TORTOISESHLD, EMPTY

; ------------------------------------------------------------------------------

; 154: cluck
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 155: land_worm
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 156: test_rider
        make_monster_steal      PARTISAN, EMPTY
        make_monster_drop       STOUT_SPEAR, EMPTY

; ------------------------------------------------------------------------------

; 157: plutoarmor
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 158: tomb_thumb
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 159: heavyarmor
        make_monster_steal      IRONHELMET, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 160: chaser
        make_monster_steal      BIO_BLASTER, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 161: scullion
        make_monster_steal      AIR_ANCHOR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 162: poplium
        make_monster_steal      POTION, EMPTY
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 163: intangir
        make_monster_steal      MAGICITE, EMPTY
        make_monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 164: misfit
        make_monster_steal      BACK_GUARD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 165: eland
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 166: enuo
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 167: deep_eye
        make_monster_steal      EMPTY, EYEDROP
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 168: greasemonk
        make_monster_steal      BUCKLER, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 169: neckhunter
        make_monster_steal      DARK_HOOD, EMPTY
        make_monster_drop       PEACE_RING, EMPTY

; ------------------------------------------------------------------------------

; 170: grenade
        make_monster_steal      FIRE_SKEAN, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 171: critic
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 172: pan_dora
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 173: souldancer
        make_monster_steal      MOOGLE_SUIT, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 174: gigantos
        make_monster_steal      ELIXIR, X_POTION
        make_monster_drop       HARDENED, HARDENED

; ------------------------------------------------------------------------------

; 175: mag_roader_2
        make_monster_steal      SHURIKEN, BOLT_EDGE
        make_monster_drop       FIRE_SKEAN, EMPTY

; ------------------------------------------------------------------------------

; 176: spek_tor
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 177: parasite
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 178: earthguard
        make_monster_steal      MEGALIXIR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 179: coelecite
        make_monster_steal      POTION, ANTIDOTE
        make_monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 180: anemone
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 181: hipocampus
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 182: spectre
        make_monster_steal      ICE_ROD, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 183: evil_oscar
        make_monster_steal      EMPTY, WARP_STONE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 184: slurm
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 185: latimeria
        make_monster_steal      EMPTY, GAIA_GEAR
        make_monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 186: stillgoing
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 187: allo_ver
        make_monster_steal      POTION, TONIC
        make_monster_drop       TIGER_FANGS, TIGER_FANGS

; ------------------------------------------------------------------------------

; 188: phase
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 189: outsider
        make_monster_steal      BREAK_BLADE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 190: barb_e
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 191: parasoul
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 192: pm_stalker
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 193: hemophyte
        make_monster_steal      TACK_STAR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 194: sp_forces
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       MAGICITE, EMPTY

; ------------------------------------------------------------------------------

; 195: nohrabbit
        make_monster_steal      EMPTY, REMEDY
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 196: wizard
        make_monster_steal      ICE_ROD, THUNDER_ROD
        make_monster_drop       FIRE_ROD, EMPTY

; ------------------------------------------------------------------------------

; 197: scrapper
        make_monster_steal      THIEF_GLOVE, EMPTY
        make_monster_drop       AIR_LANCET, EMPTY

; ------------------------------------------------------------------------------

; 198: ceritops
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       WHITE_CAPE, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 199: commando
        make_monster_steal      MITHRIL_VEST, TENT
        make_monster_drop       TENT, EMPTY

; ------------------------------------------------------------------------------

; 200: opinicus
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 201: poppers
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 202: lunaris
        make_monster_steal      POTION, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 203: garm
        make_monster_steal      FENIX_DOWN, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 204: vindr
        make_monster_steal      CHOCOBO_SUIT, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 205: kiwok
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       WHITE_CAPE, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 206: nastidon
        make_monster_steal      POTION, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 207: rinn
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 208: insecare
        make_monster_steal      EMPTY, ECHO_SCREEN
        make_monster_drop       SMOKE_BOMB, EMPTY

; ------------------------------------------------------------------------------

; 209: vermin
        make_monster_steal      ANTIDOTE, POTION
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 210: mantodea
        make_monster_steal      IMP_HALBERD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 211: bogy
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 212: prussian
        make_monster_steal      FULL_MOON, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 213: black_drgn
        make_monster_steal      EMPTY, REVIVIFY
        make_monster_drop       TENT, EMPTY

; ------------------------------------------------------------------------------

; 214: adamanchyt
        make_monster_steal      GOLD_SHLD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 215: dante
        make_monster_steal      DIAMOND_HELM, EMPTY
        make_monster_drop       GOLD_SHLD, EMPTY

; ------------------------------------------------------------------------------

; 216: wirey_drgn
        make_monster_steal      DRAGOONBOOTS, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 217: dueller
        make_monster_steal      CHAIN_SAW, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 218: psychot
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 219: muus
        make_monster_steal      MAGICITE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 220: karkass
        make_monster_steal      SOUL_SABRE, MITHRILBLADE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 221: punisher
        make_monster_steal      BONE_CLUB, RISING_SUN
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 222: balloon
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 223: gabbldegak
        make_monster_steal      FENIX_DOWN, EYEDROP
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 224: gtbehemoth
        make_monster_steal      TIGER_FANGS, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 225: scorpion
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 226: chaos_drgn
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 227: spit_fire
        make_monster_steal      ELIXIR, TINCTURE
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 228: vectagoyle
        make_monster_steal      SWORDBREAKER, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 229: lich
        make_monster_steal      POISON_ROD, GREEN_CHERRY
        make_monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 230: osprey
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       ECHO_SCREEN, EMPTY

; ------------------------------------------------------------------------------

; 231: mag_roader_3
        make_monster_steal      SHURIKEN, BOLT_EDGE
        make_monster_drop       WATER_EDGE, EMPTY

; ------------------------------------------------------------------------------

; 232: bug
        make_monster_steal      POTION, SOFT
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 233: sea_flower
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 234: fortis
        make_monster_steal      DRILL, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 235: abolisher
        make_monster_steal      EMPTY, ANTIDOTE
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 236: aquila
        make_monster_steal      ECONOMIZER, FENIX_DOWN
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 237: junk
        make_monster_steal      NOISEBLASTER, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 238: mandrake
        make_monster_steal      POTION, POTION
        make_monster_drop       REMEDY, EMPTY

; ------------------------------------------------------------------------------

; 239: 1st_class
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 240: tap_dancer
        make_monster_steal      SWORDBREAKER, DIRK
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 241: necromancr
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 242: borras
        make_monster_steal      MUSCLE_BELT, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 243: mag_roader_4
        make_monster_steal      SHURIKEN, BOLT_EDGE
        make_monster_drop       FIRE_SKEAN, EMPTY

; ------------------------------------------------------------------------------

; 244: wild_rat
        make_monster_steal      TONIC, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 245: gold_bear
        make_monster_steal      POTION, TONIC
        make_monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 246: innoc
        make_monster_steal      BIO_BLASTER, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 247: trixter
        make_monster_steal      FENIX_DOWN, EMPTY
        make_monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 248: red_wolf
        make_monster_steal      TONIC, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 249: didalos
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 250: woolly
        make_monster_steal      HARDENED, IMPERIAL
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 251: veteran
        make_monster_steal      EARRINGS, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 252: sky_base
        make_monster_steal      FLASH, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 253: ironhitman
        make_monster_steal      AUTOCROSSBOW, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 254: io
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 255: pugs
        make_monster_steal      MINERVA, EMPTY
        make_monster_drop       MINERVA, EMPTY

; ------------------------------------------------------------------------------

; 256: whelk
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       TINCTURE, TINCTURE

; ------------------------------------------------------------------------------

; 257: presenter
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       DRAGON_CLAW, DRAGON_CLAW

; ------------------------------------------------------------------------------

; 258: mega_armor
        make_monster_steal      EMPTY, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 259: vargas
        make_monster_steal      MITHRIL_CLAW, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 260: tunnelarmr
        make_monster_steal      BIO_BLASTER, AIR_LANCET
        make_monster_drop       ELIXIR, ELIXIR

; ------------------------------------------------------------------------------

; 261: prometheus
        make_monster_steal      DEBILITATOR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 262: ghosttrain
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       TENT, TENT

; ------------------------------------------------------------------------------

; 263: dadaluma
        make_monster_steal      SNEAK_RING, JEWEL_RING
        make_monster_drop       THIEFKNIFE, HEAD_BAND

; ------------------------------------------------------------------------------

; 264: shiva
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 265: ifrit
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 266: number_024
        make_monster_steal      DRAINER, RUNE_EDGE
        make_monster_drop       FLAME_SABRE, BLIZZARD

; ------------------------------------------------------------------------------

; 267: number_128
        make_monster_steal      TEMPEST, EMPTY
        make_monster_drop       TENT, TENT

; ------------------------------------------------------------------------------

; 268: inferno
        make_monster_steal      ICE_SHLD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 269: crane_1
        make_monster_steal      NOISEBLASTER, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 270: crane_2
        make_monster_steal      DEBILITATOR, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 271: umaro_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 272: umaro_2
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 273: guardian_vector
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 274: guardian_boss
        make_monster_steal      RIBBON, FORCE_ARMOR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 275: air_force
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       CZARINA_RING, CZARINA_RING

; ------------------------------------------------------------------------------

; 276: tritoch_intro
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 277: tritoch_morph
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 278: flameeater
        make_monster_steal      EMPTY, FLAME_SABRE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 279: atmaweapon
        make_monster_steal      RIBBON, ELIXIR
        make_monster_drop       ELIXIR, ELIXIR

; ------------------------------------------------------------------------------

; 280: nerapa
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 281: srbehemoth
        make_monster_steal      MURASAME, EMPTY
        make_monster_drop       BEHEMOTHSUIT, BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 282: kefka_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 283: tentacle
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 284: dullahan
        make_monster_steal      GENJI_GLOVE, X_POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 285: doom_gaze
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 286: chadarnook_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 287: curley
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 288: larry
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 289: moe
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 290: wrexsoul
        make_monster_steal      MEMENTO_RING, EMPTY
        make_monster_drop       POD_BRACELET, POD_BRACELET

; ------------------------------------------------------------------------------

; 291: hidon
        make_monster_steal      THORNLET, WARP_STONE
        make_monster_drop       WARP_STONE, WARP_STONE

; ------------------------------------------------------------------------------

; 292: katanasoul
        make_monster_steal      STRATO, MURASAME
        make_monster_drop       OFFERING, OFFERING

; ------------------------------------------------------------------------------

; 293: l30_magic
        make_monster_steal      TINCTURE, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 294: hidonite
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 295: doom
        make_monster_steal      SAFETY_BIT, EMPTY
        make_monster_drop       SKY_RENDER, SKY_RENDER

; ------------------------------------------------------------------------------

; 296: goddess
        make_monster_steal      MINERVA, EMPTY
        make_monster_drop       EXCALIBUR, EXCALIBUR

; ------------------------------------------------------------------------------

; 297: poltrgeist
        make_monster_steal      RED_JACKET, EMPTY
        make_monster_drop       AURA_LANCE, AURA_LANCE

; ------------------------------------------------------------------------------

; 298: kefka_final
        make_monster_steal      EMPTY, MEGALIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 299: l40_magic
        make_monster_steal      TINCTURE, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 300: ultros_river
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 301: ultros_opera
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 302: ultros_mountain
        make_monster_steal      EMPTY, WHITE_CAPE
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 303: chupon_airship
        make_monster_steal      EMPTY, DIRK
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 304: l20_magic
        make_monster_steal      TINCTURE, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 305: siegfried_2
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       GREEN_CHERRY, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 306: l10_magic
        make_monster_steal      TINCTURE, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 307: l50_magic
        make_monster_steal      ETHER, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 308: head
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       POTION, POTION

; ------------------------------------------------------------------------------

; 309: whelk_head
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       DRAGON_CLAW, DRAGON_CLAW

; ------------------------------------------------------------------------------

; 310: colossus
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       BANDANA, BANDANA

; ------------------------------------------------------------------------------

; 311: czardragon
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 312: master_pug
        make_monster_steal      MEGALIXIR, ELIXIR
        make_monster_drop       GRAEDUS, GRAEDUS

; ------------------------------------------------------------------------------

; 313: l60_magic
        make_monster_steal      ETHER, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 314: merchant
        make_monster_steal      GUARDIAN, PLUMED_HAT
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 315: b_day_suit
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 316: tentacle_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 317: tentacle_2
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 318: tentacle_3
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 319: rightblade
        make_monster_steal      TINCTURE, EMPTY
        make_monster_drop       EMPTY, FENIX_DOWN

; ------------------------------------------------------------------------------

; 320: left_blade
        make_monster_steal      TINCTURE, EMPTY
        make_monster_drop       EMPTY, FENIX_DOWN

; ------------------------------------------------------------------------------

; 321: rough
        make_monster_steal      FLAME_SHLD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 322: striker
        make_monster_steal      FLAME_SHLD, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 323: l70_magic
        make_monster_steal      ETHER, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 324: tritoch_boss
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 325: laser_gun
        make_monster_steal      EMPTY, X_ETHER
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 326: speck
        make_monster_steal      AMULET, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 327: missilebay
        make_monster_steal      DEBILITATOR, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 328: chadarnook_2
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 329: ice_dragon
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       FORCE_SHLD, FORCE_SHLD

; ------------------------------------------------------------------------------

; 330: kefka_narshe
        make_monster_steal      ELIXIR, ETHER
        make_monster_drop       PEACE_RING, PEACE_RING

; ------------------------------------------------------------------------------

; 331: storm_drgn
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       FORCE_ARMOR, FORCE_ARMOR

; ------------------------------------------------------------------------------

; 332: dirt_drgn
        make_monster_steal      X_POTION, EMPTY
        make_monster_drop       MAGUS_ROD, MAGUS_ROD

; ------------------------------------------------------------------------------

; 333: ipooh
        make_monster_steal      POTION, POTION
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 334: leader
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       FENIX_DOWN, BLACK_BELT

; ------------------------------------------------------------------------------

; 335: grunt
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 336: gold_drgn
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       CRYSTAL_ORB, CRYSTAL_ORB

; ------------------------------------------------------------------------------

; 337: skull_drgn
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       MUSCLE_BELT, MUSCLE_BELT

; ------------------------------------------------------------------------------

; 338: blue_drgn
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       SCIMITAR, SCIMITAR

; ------------------------------------------------------------------------------

; 339: red_dragon
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       STRATO, STRATO

; ------------------------------------------------------------------------------

; 340: piranha
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 341: rizopas
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       REMEDY, REMEDY

; ------------------------------------------------------------------------------

; 342: specter
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       HYPER_WRIST, HYPER_WRIST

; ------------------------------------------------------------------------------

; 343: short_arm
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 344: long_arm
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 345: face
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 346: tiger
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 347: tools
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 348: magic
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 349: hit
        make_monster_steal      EMPTY, ELIXIR
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 350: girl
        make_monster_steal      EMPTY, RAGNAROK
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 351: sleep
        make_monster_steal      EMPTY, ATMA_WEAPON
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 352: hidonite_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 353: hidonite_2
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 354: hidonite_3
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 355: l80_magic
        make_monster_steal      ETHER, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 356: l90_magic
        make_monster_steal      ETHER, EMPTY
        make_monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 357: protoarmor
        make_monster_steal      MITHRIL_MAIL, POTION
        make_monster_drop       BIO_BLASTER, EMPTY

; ------------------------------------------------------------------------------

; 358: magimaster
        make_monster_steal      CRYSTAL_ORB, ELIXIR
        make_monster_drop       MEGALIXIR, MEGALIXIR

; ------------------------------------------------------------------------------

; 359: soulsaver
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 360: ultros_airship
        make_monster_steal      EMPTY, DRIED_MEAT
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 361: naughty
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 362: phunbaba_1
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 363: phunbaba_2
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 364: phunbaba_3
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 365: phunbaba_4
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 366: terra_flashback
        make_monster_steal      STAR_PENDANT, FENIX_DOWN
        make_monster_drop       REMEDY, EMPTY

; ------------------------------------------------------------------------------

; 367: kefka_imp_camp
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 368: cyan_imp_camp
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 369: zone_eater
        make_monster_steal      WARP_STONE, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 370: gau_veldt
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 371: kefka_vs_leo
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 372: kefka_esper_gate
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 373: officer
        make_monster_steal      POTION, TONIC
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 374: cadet
        make_monster_steal      EMPTY, TONIC
        make_monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 375: 0177
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 376: 0178
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 377: soldier_flashback
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 378: kefka_vs_esper
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 379: event
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 380: 017c
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 381: atma
        make_monster_steal      CRYSTAL_ORB, DRAINER
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 382: shadow_colosseum
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 383: colosseum
        make_monster_steal      EMPTY, EMPTY
        make_monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------
