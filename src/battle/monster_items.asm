; ------------------------------------------------------------------------------

; $00: rare steal
; $01: common steal
; $02: rare drop
; $03: common drop

.mac monster_steal rare_item, common_item
        .byte ITEM::rare_item, ITEM::common_item
.endmac

.define monster_drop monster_steal

; ------------------------------------------------------------------------------

; 0: guard
        monster_steal      POTION, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 1: soldier
        monster_steal      TONIC, POTION
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 2: templar
        monster_steal      TONIC, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 3: ninja
        monster_steal      CHERUB_DOWN, EMPTY
        monster_drop       NINJA_STAR, EMPTY

; ------------------------------------------------------------------------------

; 4: samurai
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 5: orog
        monster_steal      AMULET, EMPTY
        monster_drop       AMULET, REVIVIFY

; ------------------------------------------------------------------------------

; 6: mag_roader_1
        monster_steal      SHURIKEN, BOLT_EDGE
        monster_drop       WATER_EDGE, EMPTY

; ------------------------------------------------------------------------------

; 7: retainer
        monster_steal      AURA, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 8: hazer
        monster_steal      POTION, EMPTY
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 9: dahling
        monster_steal      MOOGLE_SUIT, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 10: rain_man
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 11: brawler
        monster_steal      BANDANA, EMPTY
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 12: apokryphos
        monster_steal      CURE_RING, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 13: dark_force
        monster_steal      CRYSTAL, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 14: whisper
        monster_steal      POTION, EMPTY
        monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 15: over_mind
        monster_steal      POTION, EMPTY
        monster_drop       REVIVIFY, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 16: osteosaur
        monster_steal      REMEDY, EMPTY
        monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 17: commander
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 18: rhodox
        monster_steal      TONIC, ANTIDOTE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 19: were_rat
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 20: ursus
        monster_steal      SNEAK_RING, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 21: rhinotaur
        monster_steal      MITHRIL_CLAW, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 22: steroidite
        monster_steal      THUNDER_SHLD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 23: leafer
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 24: stray_cat
        monster_steal      POTION, EMPTY
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 25: lobo
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 26: doberman
        monster_steal      POTION, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 27: vomammoth
        monster_steal      POTION, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 28: fidor
        monster_steal      POTION, FENIX_DOWN
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 29: baskervor
        monster_steal      GAIA_GEAR, EMPTY
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 30: suriander
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 31: chimera
        monster_steal      HYPER_WRIST, EMPTY
        monster_drop       GOLD_ARMOR, EMPTY

; ------------------------------------------------------------------------------

; 32: behemoth
        monster_steal      RUNNINGSHOES, EMPTY
        monster_drop       X_POTION, EMPTY

; ------------------------------------------------------------------------------

; 33: mesosaur
        monster_steal      EMPTY, ANTIDOTE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 34: pterodon
        monster_steal      GUARDIAN, MITHRILKNIFE
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 35: fossilfang
        monster_steal      REMEDY, REVIVIFY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 36: white_drgn
        monster_steal      PEARL_LANCE, X_POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 37: doom_drgn
        monster_steal      POD_BRACELET, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 38: brachosaur
        monster_steal      RIBBON, EMPTY
        monster_drop       ECONOMIZER, EMPTY

; ------------------------------------------------------------------------------

; 39: tyranosaur
        monster_steal      IMPS_ARMOR, EMPTY
        monster_drop       IMP_HALBERD, EMPTY

; ------------------------------------------------------------------------------

; 40: dark_wind
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 41: beakor
        monster_steal      POTION, EYEDROP
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 42: vulture
        monster_steal      FENIX_DOWN, POTION
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 43: harpy
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 44: hermitcrab
        monster_steal      EMPTY, POTION
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 45: trapper
        monster_steal      AUTOCROSSBOW, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 46: hornet
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 47: crasshoppr
        monster_steal      ANTIDOTE, ANTIDOTE
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 48: delta_bug
        monster_steal      EMPTY, TONIC
        monster_drop       SLEEPING_BAG, EMPTY

; ------------------------------------------------------------------------------

; 49: gilomantis
        monster_steal      POISON_CLAW, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 50: trilium
        monster_steal      REMEDY, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 51: nightshade
        monster_steal      NUTKIN_SUIT, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 52: tumbleweed
        monster_steal      TITANIUM, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 53: bloompire
        monster_steal      ECHO_SCREEN, EMPTY
        monster_drop       SMOKE_BOMB, EMPTY

; ------------------------------------------------------------------------------

; 54: trilobiter
        monster_steal      TONIC, ANTIDOTE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 55: siegfried_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 56: nautiloid
        monster_steal      POTION, TONIC
        monster_drop       EYEDROP, EMPTY

; ------------------------------------------------------------------------------

; 57: exocite
        monster_steal      MITHRIL_CLAW, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 58: anguiform
        monster_steal      POTION, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 59: reach_frog
        monster_steal      TACK_STAR, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 60: lizard
        monster_steal      DRAINER, EMPTY
        monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 61: chickenlip
        monster_steal      SLEEPING_BAG, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 62: hoover
        monster_steal      REMEDY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 63: rider
        monster_steal      ELIXIR, MITHRIL_VEST
        monster_drop       REMEDY, REMEDY

; ------------------------------------------------------------------------------

; 64: chupon_colosseum
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 65: pipsqueak
        monster_steal      EMPTY, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 66: m_tekarmor
        monster_steal      POTION, TONIC
        monster_drop       EMPTY, POTION

; ------------------------------------------------------------------------------

; 67: sky_armor
        monster_steal      EMPTY, TINCTURE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 68: telstar
        monster_steal      X_POTION, EMPTY
        monster_drop       GREEN_BERET, GREEN_BERET

; ------------------------------------------------------------------------------

; 69: lethal_wpn
        monster_steal      DEBILITATOR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 70: vaporite
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 71: flan
        monster_steal      MAGICITE, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 72: ing
        monster_steal      AMULET, EMPTY
        monster_drop       REVIVIFY, EMPTY

; ------------------------------------------------------------------------------

; 73: humpty
        monster_steal      EMPTY, GREEN_CHERRY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 74: brainpan
        monster_steal      EARRINGS, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 75: cruller
        monster_steal      EMPTY, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 76: cactrot
        monster_steal      SOFT, EMPTY
        monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 77: repo_man
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 78: harvester
        monster_steal      DRAGOONBOOTS, GOGGLES
        monster_drop       BARRIER_RING, EMPTY

; ------------------------------------------------------------------------------

; 79: bomb
        monster_steal      POTION, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 80: still_life
        monster_steal      FAKEMUSTACHE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 81: boxed_set
        monster_steal      ANTIDOTE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 82: slamdancer
        monster_steal      THIEFKNIFE, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 83: hadesgigas
        monster_steal      ATLAS_ARMLET, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 84: pug
        monster_steal      EMPTY, EMPTY
        monster_drop       TINTINABAR, EMPTY

; ------------------------------------------------------------------------------

; 85: magic_urn
        monster_steal      ELIXIR, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 86: mover
        monster_steal      EMPTY, SUPER_BALL
        monster_drop       MAGICITE, EMPTY

; ------------------------------------------------------------------------------

; 87: figaliz
        monster_steal      POTION, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 88: buffalax
        monster_steal      DIAMOND_VEST, TINCTURE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 89: aspik
        monster_steal      TONIC, EMPTY
        monster_drop       X_POTION, EMPTY

; ------------------------------------------------------------------------------

; 90: ghost
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 91: crawler
        monster_steal      REMEDY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 92: sand_ray
        monster_steal      ANTIDOTE, ANTIDOTE
        monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 93: areneid
        monster_steal      EMPTY, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 94: actaneon
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 95: sand_horse
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 96: dark_side
        monster_steal      TONIC, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 97: mad_oscar
        monster_steal      X_POTION, EMPTY
        monster_drop       REMEDY, REVIVIFY

; ------------------------------------------------------------------------------

; 98: crawly
        monster_steal      REMEDY, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 99: bleary
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 100: marshal
        monster_steal      EMPTY, MITHRILKNIFE
        monster_drop       POTION, POTION

; ------------------------------------------------------------------------------

; 101: trooper
        monster_steal      MITHRILBLADE, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 102: general
        monster_steal      MITHRIL_SHLD, TONIC
        monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 103: covert
        monster_steal      TACK_STAR, SHURIKEN
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 104: ogor
        monster_steal      MURASAME, ASHURA
        monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 105: warlock
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 106: madam
        monster_steal      GOGGLES, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 107: joker
        monster_steal      GREEN_BERET, TONIC
        monster_drop       MITHRIL_ROD, EMPTY

; ------------------------------------------------------------------------------

; 108: iron_fist
        monster_steal      HEAD_BAND, TONIC
        monster_drop       MITHRILKNIFE, EMPTY

; ------------------------------------------------------------------------------

; 109: goblin
        monster_steal      MITHRILGLOVE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 110: apparite
        monster_steal      POTION, REVIVIFY
        monster_drop       REVIVIFY, EMPTY

; ------------------------------------------------------------------------------

; 111: powerdemon
        monster_steal      DIAMOND_VEST, POTION
        monster_drop       AMULET, REVIVIFY

; ------------------------------------------------------------------------------

; 112: displayer
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 113: vector_pup
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 114: peepers
        monster_steal      ELIXIR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 115: sewer_rat
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 116: slatter
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 117: rhinox
        monster_steal      FLASH, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 118: rhobite
        monster_steal      POTION, POTION
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 119: wild_cat
        monster_steal      TABBY_SUIT, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 120: red_fang
        monster_steal      TONIC, TONIC
        monster_drop       DRIED_MEAT, EMPTY

; ------------------------------------------------------------------------------

; 121: bounty_man
        monster_steal      POTION, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 122: tusker
        monster_steal      POTION, TONIC
        monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 123: ralph
        monster_steal      TIGER_MASK, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 124: chitonid
        monster_steal      EMPTY, POTION
        monster_drop       REMEDY, EMPTY

; ------------------------------------------------------------------------------

; 125: wart_puck
        monster_steal      DRIED_MEAT, FLAIL
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 126: rhyos
        monster_steal      GOLD_LANCE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 127: srbehemoth_undead
        monster_steal      EMPTY, EMPTY
        monster_drop       BEHEMOTHSUIT, BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 128: vectaur
        monster_steal      NINJA_STAR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 129: wyvern
        monster_steal      DRAGOONBOOTS, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 130: zombone
        monster_steal      POTION, FENIX_DOWN
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 131: dragon
        monster_steal      GENJI_GLOVE, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 132: brontaur
        monster_steal      DRIED_MEAT, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 133: allosaurus
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 134: cirpius
        monster_steal      TONIC, ANTIDOTE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 135: sprinter
        monster_steal      EMPTY, EMPTY
        monster_drop       IMPS_ARMOR, EMPTY

; ------------------------------------------------------------------------------

; 136: gobbler
        monster_steal      POTION, GREEN_CHERRY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 137: harpiai
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 138: gloomshell
        monster_steal      POTION, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 139: drop
        monster_steal      EMPTY, TINCTURE
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 140: mind_candy
        monster_steal      TONIC, SOFT
        monster_drop       SOFT, EMPTY

; ------------------------------------------------------------------------------

; 141: weedfeeder
        monster_steal      ANTIDOTE, ANTIDOTE
        monster_drop       ECHO_SCREEN, EMPTY

; ------------------------------------------------------------------------------

; 142: luridan
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 143: toe_cutter
        monster_steal      EMPTY, POISON_ROD
        monster_drop       POISON_ROD, EMPTY

; ------------------------------------------------------------------------------

; 144: over_grunk
        monster_steal      REMEDY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 145: exoray
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 146: crusher
        monster_steal      EMPTY, SUPER_BALL
        monster_drop       SUPER_BALL, EMPTY

; ------------------------------------------------------------------------------

; 147: uroburos
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 148: primordite
        monster_steal      TONIC, EYEDROP
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 149: sky_cap
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 150: cephaler
        monster_steal      REMEDY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 151: maliga
        monster_steal      EMPTY, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 152: gigan_toad
        monster_steal      EMPTY, EMPTY
        monster_drop       SLEEPING_BAG, EMPTY

; ------------------------------------------------------------------------------

; 153: geckorex
        monster_steal      TORTOISESHLD, EMPTY
        monster_drop       TORTOISESHLD, EMPTY

; ------------------------------------------------------------------------------

; 154: cluck
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 155: land_worm
        monster_steal      X_POTION, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 156: test_rider
        monster_steal      PARTISAN, EMPTY
        monster_drop       STOUT_SPEAR, EMPTY

; ------------------------------------------------------------------------------

; 157: plutoarmor
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 158: tomb_thumb
        monster_steal      EMPTY, EMPTY
        monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 159: heavyarmor
        monster_steal      IRONHELMET, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 160: chaser
        monster_steal      BIO_BLASTER, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 161: scullion
        monster_steal      AIR_ANCHOR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 162: poplium
        monster_steal      POTION, EMPTY
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 163: intangir
        monster_steal      MAGICITE, EMPTY
        monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 164: misfit
        monster_steal      BACK_GUARD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 165: eland
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 166: enuo
        monster_steal      X_POTION, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 167: deep_eye
        monster_steal      EMPTY, EYEDROP
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 168: greasemonk
        monster_steal      BUCKLER, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 169: neckhunter
        monster_steal      DARK_HOOD, EMPTY
        monster_drop       PEACE_RING, EMPTY

; ------------------------------------------------------------------------------

; 170: grenade
        monster_steal      FIRE_SKEAN, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 171: critic
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 172: pan_dora
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 173: souldancer
        monster_steal      MOOGLE_SUIT, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 174: gigantos
        monster_steal      ELIXIR, X_POTION
        monster_drop       HARDENED, HARDENED

; ------------------------------------------------------------------------------

; 175: mag_roader_2
        monster_steal      SHURIKEN, BOLT_EDGE
        monster_drop       FIRE_SKEAN, EMPTY

; ------------------------------------------------------------------------------

; 176: spek_tor
        monster_steal      X_POTION, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 177: parasite
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 178: earthguard
        monster_steal      MEGALIXIR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 179: coelecite
        monster_steal      POTION, ANTIDOTE
        monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 180: anemone
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 181: hipocampus
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 182: spectre
        monster_steal      ICE_ROD, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 183: evil_oscar
        monster_steal      EMPTY, WARP_STONE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 184: slurm
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 185: latimeria
        monster_steal      EMPTY, GAIA_GEAR
        monster_drop       ANTIDOTE, EMPTY

; ------------------------------------------------------------------------------

; 186: stillgoing
        monster_steal      EMPTY, EMPTY
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 187: allo_ver
        monster_steal      POTION, TONIC
        monster_drop       TIGER_FANGS, TIGER_FANGS

; ------------------------------------------------------------------------------

; 188: phase
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 189: outsider
        monster_steal      BREAK_BLADE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 190: barb_e
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 191: parasoul
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 192: pm_stalker
        monster_steal      X_POTION, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 193: hemophyte
        monster_steal      TACK_STAR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 194: sp_forces
        monster_steal      EMPTY, TONIC
        monster_drop       MAGICITE, EMPTY

; ------------------------------------------------------------------------------

; 195: nohrabbit
        monster_steal      EMPTY, REMEDY
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 196: wizard
        monster_steal      ICE_ROD, THUNDER_ROD
        monster_drop       FIRE_ROD, EMPTY

; ------------------------------------------------------------------------------

; 197: scrapper
        monster_steal      THIEF_GLOVE, EMPTY
        monster_drop       AIR_LANCET, EMPTY

; ------------------------------------------------------------------------------

; 198: ceritops
        monster_steal      EMPTY, EMPTY
        monster_drop       WHITE_CAPE, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 199: commando
        monster_steal      MITHRIL_VEST, TENT
        monster_drop       TENT, EMPTY

; ------------------------------------------------------------------------------

; 200: opinicus
        monster_steal      WARP_STONE, EMPTY
        monster_drop       WARP_STONE, EMPTY

; ------------------------------------------------------------------------------

; 201: poppers
        monster_steal      EMPTY, EMPTY
        monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 202: lunaris
        monster_steal      POTION, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 203: garm
        monster_steal      FENIX_DOWN, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 204: vindr
        monster_steal      CHOCOBO_SUIT, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 205: kiwok
        monster_steal      EMPTY, EMPTY
        monster_drop       WHITE_CAPE, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 206: nastidon
        monster_steal      POTION, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 207: rinn
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 208: insecare
        monster_steal      EMPTY, ECHO_SCREEN
        monster_drop       SMOKE_BOMB, EMPTY

; ------------------------------------------------------------------------------

; 209: vermin
        monster_steal      ANTIDOTE, POTION
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 210: mantodea
        monster_steal      IMP_HALBERD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 211: bogy
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 212: prussian
        monster_steal      FULL_MOON, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 213: black_drgn
        monster_steal      EMPTY, REVIVIFY
        monster_drop       TENT, EMPTY

; ------------------------------------------------------------------------------

; 214: adamanchyt
        monster_steal      GOLD_SHLD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 215: dante
        monster_steal      DIAMOND_HELM, EMPTY
        monster_drop       GOLD_SHLD, EMPTY

; ------------------------------------------------------------------------------

; 216: wirey_drgn
        monster_steal      DRAGOONBOOTS, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 217: dueller
        monster_steal      CHAIN_SAW, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 218: psychot
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 219: muus
        monster_steal      MAGICITE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 220: karkass
        monster_steal      SOUL_SABRE, MITHRILBLADE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 221: punisher
        monster_steal      BONE_CLUB, RISING_SUN
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 222: balloon
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 223: gabbldegak
        monster_steal      FENIX_DOWN, EYEDROP
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 224: gtbehemoth
        monster_steal      TIGER_FANGS, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 225: scorpion
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 226: chaos_drgn
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 227: spit_fire
        monster_steal      ELIXIR, TINCTURE
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 228: vectagoyle
        monster_steal      SWORDBREAKER, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 229: lich
        monster_steal      POISON_ROD, GREEN_CHERRY
        monster_drop       GREEN_CHERRY, EMPTY

; ------------------------------------------------------------------------------

; 230: osprey
        monster_steal      EMPTY, EMPTY
        monster_drop       ECHO_SCREEN, EMPTY

; ------------------------------------------------------------------------------

; 231: mag_roader_3
        monster_steal      SHURIKEN, BOLT_EDGE
        monster_drop       WATER_EDGE, EMPTY

; ------------------------------------------------------------------------------

; 232: bug
        monster_steal      POTION, SOFT
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 233: sea_flower
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 234: fortis
        monster_steal      DRILL, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 235: abolisher
        monster_steal      EMPTY, ANTIDOTE
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 236: aquila
        monster_steal      ECONOMIZER, FENIX_DOWN
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 237: junk
        monster_steal      NOISEBLASTER, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 238: mandrake
        monster_steal      POTION, POTION
        monster_drop       REMEDY, EMPTY

; ------------------------------------------------------------------------------

; 239: 1st_class
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 240: tap_dancer
        monster_steal      SWORDBREAKER, DIRK
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 241: necromancr
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       EMPTY, REVIVIFY

; ------------------------------------------------------------------------------

; 242: borras
        monster_steal      MUSCLE_BELT, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 243: mag_roader_4
        monster_steal      SHURIKEN, BOLT_EDGE
        monster_drop       FIRE_SKEAN, EMPTY

; ------------------------------------------------------------------------------

; 244: wild_rat
        monster_steal      TONIC, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 245: gold_bear
        monster_steal      POTION, TONIC
        monster_drop       POTION, EMPTY

; ------------------------------------------------------------------------------

; 246: innoc
        monster_steal      BIO_BLASTER, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 247: trixter
        monster_steal      FENIX_DOWN, EMPTY
        monster_drop       FENIX_DOWN, EMPTY

; ------------------------------------------------------------------------------

; 248: red_wolf
        monster_steal      TONIC, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 249: didalos
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 250: woolly
        monster_steal      HARDENED, IMPERIAL
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 251: veteran
        monster_steal      EARRINGS, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 252: sky_base
        monster_steal      FLASH, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 253: ironhitman
        monster_steal      AUTOCROSSBOW, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 254: io
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 255: pugs
        monster_steal      MINERVA, EMPTY
        monster_drop       MINERVA, EMPTY

; ------------------------------------------------------------------------------

; 256: whelk
        monster_steal      EMPTY, EMPTY
        monster_drop       TINCTURE, TINCTURE

; ------------------------------------------------------------------------------

; 257: presenter
        monster_steal      EMPTY, EMPTY
        monster_drop       DRAGON_CLAW, DRAGON_CLAW

; ------------------------------------------------------------------------------

; 258: mega_armor
        monster_steal      EMPTY, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 259: vargas
        monster_steal      MITHRIL_CLAW, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 260: tunnelarmr
        monster_steal      BIO_BLASTER, AIR_LANCET
        monster_drop       ELIXIR, ELIXIR

; ------------------------------------------------------------------------------

; 261: prometheus
        monster_steal      DEBILITATOR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 262: ghosttrain
        monster_steal      EMPTY, EMPTY
        monster_drop       TENT, TENT

; ------------------------------------------------------------------------------

; 263: dadaluma
        monster_steal      SNEAK_RING, JEWEL_RING
        monster_drop       THIEFKNIFE, HEAD_BAND

; ------------------------------------------------------------------------------

; 264: shiva
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 265: ifrit
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 266: number_024
        monster_steal      DRAINER, RUNE_EDGE
        monster_drop       FLAME_SABRE, BLIZZARD

; ------------------------------------------------------------------------------

; 267: number_128
        monster_steal      TEMPEST, EMPTY
        monster_drop       TENT, TENT

; ------------------------------------------------------------------------------

; 268: inferno
        monster_steal      ICE_SHLD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 269: crane_1
        monster_steal      NOISEBLASTER, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 270: crane_2
        monster_steal      DEBILITATOR, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 271: umaro_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 272: umaro_2
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 273: guardian_vector
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 274: guardian_boss
        monster_steal      RIBBON, FORCE_ARMOR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 275: air_force
        monster_steal      EMPTY, ELIXIR
        monster_drop       CZARINA_RING, CZARINA_RING

; ------------------------------------------------------------------------------

; 276: tritoch_intro
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 277: tritoch_morph
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 278: flameeater
        monster_steal      EMPTY, FLAME_SABRE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 279: atmaweapon
        monster_steal      RIBBON, ELIXIR
        monster_drop       ELIXIR, ELIXIR

; ------------------------------------------------------------------------------

; 280: nerapa
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 281: srbehemoth
        monster_steal      MURASAME, EMPTY
        monster_drop       BEHEMOTHSUIT, BEHEMOTHSUIT

; ------------------------------------------------------------------------------

; 282: kefka_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 283: tentacle
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 284: dullahan
        monster_steal      GENJI_GLOVE, X_POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 285: doom_gaze
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 286: chadarnook_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 287: curley
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 288: larry
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 289: moe
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 290: wrexsoul
        monster_steal      MEMENTO_RING, EMPTY
        monster_drop       POD_BRACELET, POD_BRACELET

; ------------------------------------------------------------------------------

; 291: hidon
        monster_steal      THORNLET, WARP_STONE
        monster_drop       WARP_STONE, WARP_STONE

; ------------------------------------------------------------------------------

; 292: katanasoul
        monster_steal      STRATO, MURASAME
        monster_drop       OFFERING, OFFERING

; ------------------------------------------------------------------------------

; 293: l30_magic
        monster_steal      TINCTURE, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 294: hidonite
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 295: doom
        monster_steal      SAFETY_BIT, EMPTY
        monster_drop       SKY_RENDER, SKY_RENDER

; ------------------------------------------------------------------------------

; 296: goddess
        monster_steal      MINERVA, EMPTY
        monster_drop       EXCALIBUR, EXCALIBUR

; ------------------------------------------------------------------------------

; 297: poltrgeist
        monster_steal      RED_JACKET, EMPTY
        monster_drop       AURA_LANCE, AURA_LANCE

; ------------------------------------------------------------------------------

; 298: kefka_final
        monster_steal      EMPTY, MEGALIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 299: l40_magic
        monster_steal      TINCTURE, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 300: ultros_river
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 301: ultros_opera
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 302: ultros_mountain
        monster_steal      EMPTY, WHITE_CAPE
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 303: chupon_airship
        monster_steal      EMPTY, DIRK
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 304: l20_magic
        monster_steal      TINCTURE, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 305: siegfried_2
        monster_steal      EMPTY, EMPTY
        monster_drop       GREEN_CHERRY, GREEN_CHERRY

; ------------------------------------------------------------------------------

; 306: l10_magic
        monster_steal      TINCTURE, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 307: l50_magic
        monster_steal      ETHER, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 308: head
        monster_steal      EMPTY, EMPTY
        monster_drop       POTION, POTION

; ------------------------------------------------------------------------------

; 309: whelk_head
        monster_steal      EMPTY, EMPTY
        monster_drop       DRAGON_CLAW, DRAGON_CLAW

; ------------------------------------------------------------------------------

; 310: colossus
        monster_steal      EMPTY, EMPTY
        monster_drop       BANDANA, BANDANA

; ------------------------------------------------------------------------------

; 311: czardragon
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 312: master_pug
        monster_steal      MEGALIXIR, ELIXIR
        monster_drop       GRAEDUS, GRAEDUS

; ------------------------------------------------------------------------------

; 313: l60_magic
        monster_steal      ETHER, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 314: merchant
        monster_steal      GUARDIAN, PLUMED_HAT
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 315: b_day_suit
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 316: tentacle_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 317: tentacle_2
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 318: tentacle_3
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 319: rightblade
        monster_steal      TINCTURE, EMPTY
        monster_drop       EMPTY, FENIX_DOWN

; ------------------------------------------------------------------------------

; 320: left_blade
        monster_steal      TINCTURE, EMPTY
        monster_drop       EMPTY, FENIX_DOWN

; ------------------------------------------------------------------------------

; 321: rough
        monster_steal      FLAME_SHLD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 322: striker
        monster_steal      FLAME_SHLD, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 323: l70_magic
        monster_steal      ETHER, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 324: tritoch_boss
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 325: laser_gun
        monster_steal      EMPTY, X_ETHER
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 326: speck
        monster_steal      AMULET, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 327: missilebay
        monster_steal      DEBILITATOR, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 328: chadarnook_2
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 329: ice_dragon
        monster_steal      EMPTY, EMPTY
        monster_drop       FORCE_SHLD, FORCE_SHLD

; ------------------------------------------------------------------------------

; 330: kefka_narshe
        monster_steal      ELIXIR, ETHER
        monster_drop       PEACE_RING, PEACE_RING

; ------------------------------------------------------------------------------

; 331: storm_drgn
        monster_steal      EMPTY, EMPTY
        monster_drop       FORCE_ARMOR, FORCE_ARMOR

; ------------------------------------------------------------------------------

; 332: dirt_drgn
        monster_steal      X_POTION, EMPTY
        monster_drop       MAGUS_ROD, MAGUS_ROD

; ------------------------------------------------------------------------------

; 333: ipooh
        monster_steal      POTION, POTION
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 334: leader
        monster_steal      EMPTY, EMPTY
        monster_drop       FENIX_DOWN, BLACK_BELT

; ------------------------------------------------------------------------------

; 335: grunt
        monster_steal      EMPTY, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 336: gold_drgn
        monster_steal      EMPTY, EMPTY
        monster_drop       CRYSTAL_ORB, CRYSTAL_ORB

; ------------------------------------------------------------------------------

; 337: skull_drgn
        monster_steal      EMPTY, EMPTY
        monster_drop       MUSCLE_BELT, MUSCLE_BELT

; ------------------------------------------------------------------------------

; 338: blue_drgn
        monster_steal      EMPTY, EMPTY
        monster_drop       SCIMITAR, SCIMITAR

; ------------------------------------------------------------------------------

; 339: red_dragon
        monster_steal      EMPTY, EMPTY
        monster_drop       STRATO, STRATO

; ------------------------------------------------------------------------------

; 340: piranha
        monster_steal      EMPTY, EMPTY
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 341: rizopas
        monster_steal      EMPTY, EMPTY
        monster_drop       REMEDY, REMEDY

; ------------------------------------------------------------------------------

; 342: specter
        monster_steal      EMPTY, EMPTY
        monster_drop       HYPER_WRIST, HYPER_WRIST

; ------------------------------------------------------------------------------

; 343: short_arm
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 344: long_arm
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 345: face
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 346: tiger
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 347: tools
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 348: magic
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 349: hit
        monster_steal      EMPTY, ELIXIR
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 350: girl
        monster_steal      EMPTY, RAGNAROK
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 351: sleep
        monster_steal      EMPTY, ATMA_WEAPON
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 352: hidonite_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 353: hidonite_2
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 354: hidonite_3
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 355: l80_magic
        monster_steal      ETHER, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 356: l90_magic
        monster_steal      ETHER, EMPTY
        monster_drop       TINCTURE, EMPTY

; ------------------------------------------------------------------------------

; 357: protoarmor
        monster_steal      MITHRIL_MAIL, POTION
        monster_drop       BIO_BLASTER, EMPTY

; ------------------------------------------------------------------------------

; 358: magimaster
        monster_steal      CRYSTAL_ORB, ELIXIR
        monster_drop       MEGALIXIR, MEGALIXIR

; ------------------------------------------------------------------------------

; 359: soulsaver
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 360: ultros_airship
        monster_steal      EMPTY, DRIED_MEAT
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 361: naughty
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 362: phunbaba_1
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 363: phunbaba_2
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 364: phunbaba_3
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 365: phunbaba_4
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 366: terra_flashback
        monster_steal      STAR_PENDANT, FENIX_DOWN
        monster_drop       REMEDY, EMPTY

; ------------------------------------------------------------------------------

; 367: kefka_imp_camp
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 368: cyan_imp_camp
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 369: zone_eater
        monster_steal      WARP_STONE, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 370: gau_veldt
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 371: kefka_vs_leo
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 372: kefka_esper_gate
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 373: officer
        monster_steal      POTION, TONIC
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 374: cadet
        monster_steal      EMPTY, TONIC
        monster_drop       TONIC, EMPTY

; ------------------------------------------------------------------------------

; 375: 0177
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 376: 0178
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 377: soldier_flashback
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 378: kefka_vs_esper
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 379: event
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 380: 017c
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 381: atma
        monster_steal      CRYSTAL_ORB, DRAINER
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 382: shadow_colosseum
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

; 383: colosseum
        monster_steal      EMPTY, EMPTY
        monster_drop       EMPTY, EMPTY

; ------------------------------------------------------------------------------

.delmac monster_steal
.undef monster_drop

; ------------------------------------------------------------------------------
