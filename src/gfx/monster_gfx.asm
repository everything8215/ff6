; ------------------------------------------------------------------------------

.include "gfx/monster_gfx.inc"

; ------------------------------------------------------------------------------

.macro inc_monster_gfx _name, _file
        .ident(.sprintf("MONSTER_GFX_%s", _name)) = (* - MonsterGfx) >> 3
        .incbin .sprintf("monster_gfx/%s.trm", _file)
.endmac

.macro make_monster_gfx_prop _gfx, _bpp, _size, _pal
        .if _bpp = 3
                .word .ident(.sprintf("MONSTER_GFX_%s", _gfx)) | $8000
        .else
                .word .ident(.sprintf("MONSTER_GFX_%s", _gfx))
        .endif

        .ifnblank _pal
                .if _size = 16
                        .byte >.ident(.sprintf("MONSTER_PAL_%s", _pal)) | $80
                .else
                        .byte >.ident(.sprintf("MONSTER_PAL_%s", _pal))
                .endif
                .byte <.ident(.sprintf("MONSTER_PAL_%s", _pal))
        .else
                .if _size = 16
                        .byte >.ident(.sprintf("MONSTER_PAL_%s", _gfx)) | $80
                .else
                        .byte >.ident(.sprintf("MONSTER_PAL_%s", _gfx))
                .endif
                .byte <.ident(.sprintf("MONSTER_PAL_%s", _gfx))
        .endif

        .byte .ident(.sprintf("MONSTER_STENCIL_%s", _gfx))
.endmac

.macro inc_monster_pal _name, _file
        .ident(.sprintf("MONSTER_PAL_%s", _name)) = (* - MonsterPal) >> 4
        .incbin .sprintf("monster_gfx/%s.pal", _file)
.endmac

; ------------------------------------------------------------------------------

.segment "monster_gfx"

MonsterGfx:
inc_monster_gfx "GUARD", "guard.4bpp"
inc_monster_gfx "SOLDIER", "soldier.4bpp"
inc_monster_gfx "TEMPLAR", "templar.4bpp"
inc_monster_gfx "NINJA", "ninja.4bpp"
inc_monster_gfx "SAMURAI", "samurai.4bpp"
inc_monster_gfx "OROG", "orog.4bpp"
inc_monster_gfx "MAG_ROADER_1", "mag_roader_1.4bpp"
inc_monster_gfx "HAZER", "hazer.4bpp"
inc_monster_gfx "DAHLING", .sprintf("dahling_%s.4bpp", LANG_SUFFIX)
inc_monster_gfx "RAIN_MAN", "rain_man.4bpp"
inc_monster_gfx "BRAWLER", "brawler.4bpp"
inc_monster_gfx "APOKRYPHOS", "apokryphos.4bpp"
inc_monster_gfx "DARK_FORCE", "dark_force.4bpp"
inc_monster_gfx "WHISPER", "whisper.3bpp"
inc_monster_gfx "OVER_MIND", "over_mind.4bpp"
inc_monster_gfx "OSTEOSAUR", "osteosaur.4bpp"
inc_monster_gfx "RHODOX", "rhodox.3bpp"
inc_monster_gfx "WERE_RAT", "were_rat.4bpp"
inc_monster_gfx "URSUS", "ursus.3bpp"
inc_monster_gfx "RHINOTAUR", "rhinotaur.4bpp"
inc_monster_gfx "PHUNBABA", "phunbaba.4bpp"
inc_monster_gfx "LEAFER", "leafer.4bpp"
inc_monster_gfx "STRAY_CAT", "stray_cat.3bpp"
inc_monster_gfx "LOBO", "lobo.3bpp"
inc_monster_gfx "DOBERMAN", "doberman.4bpp"
inc_monster_gfx "VOMAMMOTH", "vomammoth.4bpp"
inc_monster_gfx "FIDOR", "fidor.4bpp"
inc_monster_gfx "BASKERVOR", "baskervor.4bpp"
inc_monster_gfx "SURIANDER", "suriander.3bpp"
inc_monster_gfx "CHIMERA", "chimera.4bpp"
inc_monster_gfx "BEHEMOTH", "behemoth.4bpp"
inc_monster_gfx "MESOSAUR", "mesosaur.4bpp"
inc_monster_gfx "PTERODON", "pterodon.4bpp"
inc_monster_gfx "FOSSILFANG", "fossilfang.4bpp"
inc_monster_gfx "DRAGON", "dragon.4bpp"
inc_monster_gfx "CZARDRAGON", "czardragon.4bpp"
inc_monster_gfx "BRACHOSAUR", "brachosaur.4bpp"
inc_monster_gfx "TYRANOSAUR", "tyranosaur.4bpp"
inc_monster_gfx "DARK_WIND", "dark_wind.4bpp"
inc_monster_gfx "BEAKOR", "beakor.4bpp"
inc_monster_gfx "VULTURE", "vulture.4bpp"
inc_monster_gfx "HARPY", "harpy.4bpp"
inc_monster_gfx "HERMITCRAB", "hermitcrab.4bpp"
inc_monster_gfx "TRAPPER", "trapper.4bpp"
inc_monster_gfx "HORNET", "hornet.4bpp"
inc_monster_gfx "CRASSHOPPR", "crasshoppr.4bpp"
inc_monster_gfx "DELTA_BUG", "delta_bug.4bpp"
inc_monster_gfx "GILOMANTIS", "gilomantis.4bpp"
inc_monster_gfx "TRILIUM", "trilium.4bpp"
inc_monster_gfx "NIGHTSHADE", "nightshade.4bpp"
inc_monster_gfx "TUMBLEWEED", "tumbleweed.4bpp"
inc_monster_gfx "BLOOMPIRE", "bloompire.4bpp"
inc_monster_gfx "TRILOBITER", "trilobiter.3bpp"
inc_monster_gfx "SIEGFRIED", "siegfried.4bpp"
inc_monster_gfx "NAUTILOID", "nautiloid.4bpp"
inc_monster_gfx "EXOCITE", "exocite.4bpp"
inc_monster_gfx "ANGUIFORM", "anguiform.4bpp"
inc_monster_gfx "REACH_FROG", "reach_frog.4bpp"
inc_monster_gfx "LIZARD", "lizard.4bpp"
inc_monster_gfx "CHICKENLIP", "chickenlip.4bpp"
inc_monster_gfx "HOOVER", "hoover.4bpp"
inc_monster_gfx "RIDER", "rider.4bpp"
inc_monster_gfx "CHUPON", "chupon.4bpp"
inc_monster_gfx "PIPSQUEAK", "pipsqueak.4bpp"
inc_monster_gfx "MTEKARMOR", "mtekarmor.4bpp"
inc_monster_gfx "SKY_ARMOR", "sky_armor.4bpp"
inc_monster_gfx "TELSTAR", "telstar.4bpp"
inc_monster_gfx "LETHAL_WPN", "lethal_wpn.4bpp"
inc_monster_gfx "VAPORITE", "vaporite.3bpp"
inc_monster_gfx "FLAN", "flan.4bpp"
inc_monster_gfx "ING", "ing.4bpp"
inc_monster_gfx "HUMPTY", "humpty.3bpp"
inc_monster_gfx "BRAINPAN", "brainpan.4bpp"
inc_monster_gfx "CRULLER", "cruller.4bpp"
inc_monster_gfx "CACTROT", "cactrot.3bpp"
inc_monster_gfx "REPO_MAN", "repo_man.4bpp"
inc_monster_gfx "HARVESTER", "harvester.4bpp"
inc_monster_gfx "BOMB", "bomb.4bpp"
inc_monster_gfx "STILL_LIFE", "still_life.4bpp"
inc_monster_gfx "BOXED_SET", "boxed_set.4bpp"
inc_monster_gfx "SLAMDANCER", "slamdancer.4bpp"
inc_monster_gfx "HADESGIGAS", "hadesgigas.4bpp"
inc_monster_gfx "PUG", "pug.4bpp"
inc_monster_gfx "MAGIC_URN", "magic_urn.4bpp"
inc_monster_gfx "MOVER", "mover.3bpp"
inc_monster_gfx "FIGALIZ", "figaliz.4bpp"
inc_monster_gfx "BUFFALAX", "buffalax.4bpp"
inc_monster_gfx "ASPIK", "aspik.3bpp"
inc_monster_gfx "GHOST", "ghost.4bpp"
inc_monster_gfx "ARENEID", "areneid.3bpp"
inc_monster_gfx "ACTANEON", "actaneon.4bpp"
inc_monster_gfx "SAND_HORSE", "sand_horse.4bpp"
inc_monster_gfx "MAD_OSCAR", "mad_oscar.4bpp"
inc_monster_gfx "CRAWLY", "crawly.4bpp"
inc_monster_gfx "BLEARY", "bleary.4bpp"
inc_monster_gfx "CRITIC", .sprintf("critic_%s.4bpp", LANG_SUFFIX)
inc_monster_gfx "MAG_ROADER_2", "mag_roader_2.4bpp"
inc_monster_gfx "FORTIS", "fortis.4bpp"
inc_monster_gfx "TRIXTER", "trixter.4bpp"
inc_monster_gfx "DIDALOS", "didalos.4bpp"
inc_monster_gfx "WOOLLY", "woolly.4bpp"
inc_monster_gfx "VETERAN", "veteran.4bpp"
inc_monster_gfx "WHELK_SHELL", "whelk_shell.3bpp"
inc_monster_gfx "VARGAS", "vargas.4bpp"
inc_monster_gfx "TUNNELARMR", "tunnelarmr.4bpp"
inc_monster_gfx "GHOSTTRAIN", "ghosttrain.4bpp"
inc_monster_gfx "DADALUMA", "dadaluma.4bpp"
inc_monster_gfx "SHIVA", "shiva.4bpp"
inc_monster_gfx "IFRIT_BOSS", "ifrit_boss.4bpp"
inc_monster_gfx "NUMBER_024", "number_024.4bpp"
inc_monster_gfx "NUMBER_128", "number_128.4bpp"
inc_monster_gfx "CRANE", "crane.4bpp"
inc_monster_gfx "UMARO", "umaro.4bpp"
inc_monster_gfx "GUARDIAN", "guardian.4bpp"
inc_monster_gfx "AIR_FORCE", "air_force.4bpp"
inc_monster_gfx "TRITOCH_BOSS", "tritoch_boss.4bpp"
inc_monster_gfx "FLAMEEATER", "flameeater.4bpp"
inc_monster_gfx "ATMAWEAPON", "atmaweapon.4bpp"
inc_monster_gfx "TENTACLE_1", "tentacle_1.3bpp"
inc_monster_gfx "DOOM_GAZE", "doom_gaze.4bpp"
inc_monster_gfx "CHADARNOOK_LADY", .sprintf("chadarnook_lady_%s.4bpp", LANG_SUFFIX)
inc_monster_gfx "CURLEY", "curley.4bpp"
inc_monster_gfx "LARRY", "larry.4bpp"
inc_monster_gfx "MOE", "moe.4bpp"
inc_monster_gfx "HIDON", "hidon.4bpp"
inc_monster_gfx "HIDONITE", "hidonite.4bpp"
inc_monster_gfx "DOOM", "doom.4bpp"
inc_monster_gfx "GODDESS", .sprintf("goddess_%s.4bpp", LANG_SUFFIX)
inc_monster_gfx "POLTRGEIST", "poltrgeist.4bpp"
inc_monster_gfx "FINAL_KEFKA", "final_kefka.4bpp"
inc_monster_gfx "ULTROS_1", "ultros_1.4bpp"
inc_monster_gfx "ULTROS_2", "ultros_2.4bpp"
inc_monster_gfx "WHELK_HEAD_1", "whelk_head_1.4bpp"
inc_monster_gfx "WHELK_HEAD_2", "whelk_head_2.4bpp"
inc_monster_gfx "MERCHANT", "merchant.4bpp"
inc_monster_gfx "B_DAY_SUIT", "b_day_suit.4bpp"
inc_monster_gfx "TENTACLE_2", "tentacle_2.3bpp"
inc_monster_gfx "RIGHT_BLADE", "right_blade.4bpp"
inc_monster_gfx "LEFT_BLADE", "left_blade.4bpp"
inc_monster_gfx "ROUGH", "rough.4bpp"
inc_monster_gfx "STRIKER", "striker.4bpp"
inc_monster_gfx "LASER_GUN", "laser_gun.4bpp"
inc_monster_gfx "SPECK", "speck.3bpp"
inc_monster_gfx "MISSILEBAY", "missilebay.4bpp"
inc_monster_gfx "CHADARNOOK_DEMON", "chadarnook_demon.4bpp"
inc_monster_gfx "KEFKA", "kefka.4bpp"
inc_monster_gfx "PIRANHA", "piranha.4bpp"
inc_monster_gfx "SOULSAVER", "soulsaver.4bpp"
inc_monster_gfx "RAMUH", "ramuh.4bpp"
inc_monster_gfx "IFRIT", "ifrit.4bpp"
inc_monster_gfx "SIREN", .sprintf("siren_%s.4bpp", LANG_SUFFIX)
inc_monster_gfx "TERRATO", "terrato.4bpp"
inc_monster_gfx "SHOAT", "shoat.4bpp"
inc_monster_gfx "MADUIN", "maduin.4bpp"
inc_monster_gfx "BISMARK", "bismark.3bpp"
inc_monster_gfx "STRAY", "stray.4bpp"
inc_monster_gfx "PALIDOR", "palidor.4bpp"
inc_monster_gfx "TRITOCH", "tritoch.4bpp"
inc_monster_gfx "ODIN", "odin.4bpp"
inc_monster_gfx "RAIDEN", "raiden.4bpp"
inc_monster_gfx "BAHAMUT", "bahamut.4bpp"
inc_monster_gfx "ALEXANDR", "alexandr.4bpp"
inc_monster_gfx "CRUSADER_1", "crusader_1.4bpp"
inc_monster_gfx "KIRIN", "kirin.4bpp"
inc_monster_gfx "ZONESEEK", "zoneseek.4bpp"
inc_monster_gfx "CARBUNKL", "carbunkl.4bpp"
inc_monster_gfx "PHANTOM", "phantom.3bpp"
inc_monster_gfx "SRAPHIM", "sraphim.4bpp"
inc_monster_gfx "GOLEM", "golem.4bpp"
inc_monster_gfx "UNICORN", "unicorn.4bpp"
inc_monster_gfx "FENRIR", "fenrir.4bpp"
inc_monster_gfx "STARLET", .sprintf("starlet_%s.4bpp", LANG_SUFFIX)
inc_monster_gfx "PHOENIX", "phoenix.4bpp"
inc_monster_gfx "TIGERBREAK", "tigerbreak.4bpp"
inc_monster_gfx "CRUSADER_2", "crusader_2.4bpp"
inc_monster_gfx "IMP", "imp.3bpp"

.if LANG_EN
        .res $78, 0
        .res $01c0
.else
        .res $138, 0
.endif

; ------------------------------------------------------------------------------

.segment "monster_gfx_prop"

; d2/7000
MonsterGfxProp:
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "SOLDIER", 4, 8
make_monster_gfx_prop "TEMPLAR", 4, 8
make_monster_gfx_prop "NINJA", 4, 8
make_monster_gfx_prop "SAMURAI", 4, 8
make_monster_gfx_prop "OROG", 4, 8
make_monster_gfx_prop "MAG_ROADER_1", 4, 8
make_monster_gfx_prop "SAMURAI", 4, 8
make_monster_gfx_prop "HAZER", 4, 8
make_monster_gfx_prop "DAHLING", 4, 8
make_monster_gfx_prop "RAIN_MAN", 4, 8
make_monster_gfx_prop "BRAWLER", 4, 8
make_monster_gfx_prop "APOKRYPHOS", 4, 8
make_monster_gfx_prop "DARK_FORCE", 4, 8
make_monster_gfx_prop "WHISPER", 3, 8
make_monster_gfx_prop "OVER_MIND", 4, 8
make_monster_gfx_prop "OSTEOSAUR", 4, 16
make_monster_gfx_prop "SOLDIER", 4, 8
make_monster_gfx_prop "RHODOX", 3, 8
make_monster_gfx_prop "WERE_RAT", 4, 8
make_monster_gfx_prop "URSUS", 3, 8
make_monster_gfx_prop "RHINOTAUR", 4, 8
make_monster_gfx_prop "PHUNBABA", 4, 16, "STEROIDITE"
make_monster_gfx_prop "LEAFER", 4, 8
make_monster_gfx_prop "STRAY_CAT", 3, 8
make_monster_gfx_prop "LOBO", 3, 8
make_monster_gfx_prop "DOBERMAN", 4, 8
make_monster_gfx_prop "VOMAMMOTH", 4, 8
make_monster_gfx_prop "FIDOR", 4, 8
make_monster_gfx_prop "BASKERVOR", 4, 8
make_monster_gfx_prop "SURIANDER", 3, 8
make_monster_gfx_prop "CHIMERA", 4, 16
make_monster_gfx_prop "BEHEMOTH", 4, 16
make_monster_gfx_prop "MESOSAUR", 4, 8
make_monster_gfx_prop "PTERODON", 4, 8
make_monster_gfx_prop "FOSSILFANG", 4, 8
make_monster_gfx_prop "DRAGON", 4, 16, "WHITE_DRGN"
make_monster_gfx_prop "CZARDRAGON", 4, 16, "DOOM_DRGN"
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "TYRANOSAUR", 4, 8
make_monster_gfx_prop "DARK_WIND", 4, 8
make_monster_gfx_prop "BEAKOR", 4, 8
make_monster_gfx_prop "VULTURE", 4, 8
make_monster_gfx_prop "HARPY", 4, 16
make_monster_gfx_prop "HERMITCRAB", 4, 8
make_monster_gfx_prop "TRAPPER", 4, 8
make_monster_gfx_prop "HORNET", 4, 8
make_monster_gfx_prop "CRASSHOPPR", 4, 8
make_monster_gfx_prop "DELTA_BUG", 4, 8
make_monster_gfx_prop "GILOMANTIS", 4, 8
make_monster_gfx_prop "TRILIUM", 4, 8
make_monster_gfx_prop "NIGHTSHADE", 4, 8
make_monster_gfx_prop "TUMBLEWEED", 4, 8
make_monster_gfx_prop "BLOOMPIRE", 4, 8
make_monster_gfx_prop "TRILOBITER", 3, 8
make_monster_gfx_prop "SIEGFRIED", 4, 8
make_monster_gfx_prop "NAUTILOID", 4, 8
make_monster_gfx_prop "EXOCITE", 4, 8
make_monster_gfx_prop "ANGUIFORM", 4, 8
make_monster_gfx_prop "REACH_FROG", 4, 8
make_monster_gfx_prop "LIZARD", 4, 8
make_monster_gfx_prop "CHICKENLIP", 4, 8
make_monster_gfx_prop "HOOVER", 4, 16
make_monster_gfx_prop "RIDER", 4, 16
make_monster_gfx_prop "CHUPON", 4, 16
make_monster_gfx_prop "PIPSQUEAK", 4, 8
make_monster_gfx_prop "MTEKARMOR", 4, 8
make_monster_gfx_prop "SKY_ARMOR", 4, 8
make_monster_gfx_prop "TELSTAR", 4, 8
make_monster_gfx_prop "LETHAL_WPN", 4, 16
make_monster_gfx_prop "VAPORITE", 3, 8
make_monster_gfx_prop "FLAN", 4, 8
make_monster_gfx_prop "ING", 4, 8
make_monster_gfx_prop "HUMPTY", 3, 8
make_monster_gfx_prop "BRAINPAN", 4, 8
make_monster_gfx_prop "CRULLER", 4, 8
make_monster_gfx_prop "CACTROT", 3, 8
make_monster_gfx_prop "REPO_MAN", 4, 8
make_monster_gfx_prop "HARVESTER", 4, 8
make_monster_gfx_prop "BOMB", 4, 8
make_monster_gfx_prop "STILL_LIFE", 4, 8
make_monster_gfx_prop "BOXED_SET", 4, 8
make_monster_gfx_prop "SLAMDANCER", 4, 8
make_monster_gfx_prop "HADESGIGAS", 4, 16
make_monster_gfx_prop "PUG", 4, 8
make_monster_gfx_prop "MAGIC_URN", 4, 8
make_monster_gfx_prop "MOVER", 3, 8
make_monster_gfx_prop "FIGALIZ", 4, 8
make_monster_gfx_prop "BUFFALAX", 4, 16
make_monster_gfx_prop "ASPIK", 3, 8
make_monster_gfx_prop "GHOST", 4, 8
make_monster_gfx_prop "FIGALIZ", 4, 8
make_monster_gfx_prop "TRILOBITER", 3, 8, "SAND_RAY"
make_monster_gfx_prop "ARENEID", 3, 8
make_monster_gfx_prop "ACTANEON", 4, 8
make_monster_gfx_prop "SAND_HORSE", 4, 8
make_monster_gfx_prop "WHISPER", 3, 8
make_monster_gfx_prop "MAD_OSCAR", 4, 8
make_monster_gfx_prop "CRAWLY", 4, 8
make_monster_gfx_prop "BLEARY", 4, 8
make_monster_gfx_prop "GUARD", 4, 8, "MARSHAL"
make_monster_gfx_prop "SOLDIER", 4, 8, "TROOPER"
make_monster_gfx_prop "TEMPLAR", 4, 8, "GENERAL"
make_monster_gfx_prop "NINJA", 4, 8, "COVERT"
make_monster_gfx_prop "OROG", 4, 8, "OGOR"
make_monster_gfx_prop "HAZER", 4, 8, "WARLOCK"
make_monster_gfx_prop "DAHLING", 4, 8, "MADAM"
make_monster_gfx_prop "RAIN_MAN", 4, 8, "JOKER"
make_monster_gfx_prop "BRAWLER", 4, 8, "IRON_FIST"
make_monster_gfx_prop "APOKRYPHOS", 4, 8, "GOBLIN"
make_monster_gfx_prop "WHISPER", 3, 8, "APPARITE"
make_monster_gfx_prop "OVER_MIND", 4, 8, "POWERDEMON"
make_monster_gfx_prop "OSTEOSAUR", 4, 16, "DISPLAYER"
make_monster_gfx_prop "DOBERMAN", 4, 8
make_monster_gfx_prop "RHODOX", 3, 8, "PEEPERS"
make_monster_gfx_prop "WERE_RAT", 4, 8, "SEWER_RAT"
make_monster_gfx_prop "URSUS", 3, 8, "SLATTER"
make_monster_gfx_prop "RHINOTAUR", 4, 8, "RHINOX"
make_monster_gfx_prop "LEAFER", 4, 8, "RHOBITE"
make_monster_gfx_prop "STRAY_CAT", 3, 8, "WILD_CAT"
make_monster_gfx_prop "LOBO", 3, 8, "RED_FANG"
make_monster_gfx_prop "DOBERMAN", 4, 8, "BOUNTY_MAN"
make_monster_gfx_prop "VOMAMMOTH", 4, 8, "TUSKER"
make_monster_gfx_prop "FIDOR", 4, 8, "RALPH"
make_monster_gfx_prop "BASKERVOR", 4, 8, "CHITONID"
make_monster_gfx_prop "SURIANDER", 3, 8, "WART_PUCK"
make_monster_gfx_prop "CHIMERA", 4, 16, "RHYOS"
make_monster_gfx_prop "BEHEMOTH", 4, 16, "SRBEHEMOTH_UNDEAD"
make_monster_gfx_prop "MESOSAUR", 4, 8, "VECTAUR"
make_monster_gfx_prop "PTERODON", 4, 8, "WYVERN"
make_monster_gfx_prop "FOSSILFANG", 4, 8, "ZOMBONE"
make_monster_gfx_prop "DRAGON", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16, "BRONTAUR"
make_monster_gfx_prop "TYRANOSAUR", 4, 8, "ALLOSAURUS"
make_monster_gfx_prop "DARK_WIND", 4, 8, "CIRPIUS"
make_monster_gfx_prop "BEAKOR", 4, 8, "SPRINTER"
make_monster_gfx_prop "VULTURE", 4, 8, "GOBBLER"
make_monster_gfx_prop "HARPY", 4, 16, "HARPIAI"
make_monster_gfx_prop "HERMITCRAB", 4, 8, "GLOOMSHELL"
make_monster_gfx_prop "TRAPPER", 4, 8, "DROP"
make_monster_gfx_prop "HORNET", 4, 8, "MIND_CANDY"
make_monster_gfx_prop "CRASSHOPPR", 4, 8, "WEEDFEEDER"
make_monster_gfx_prop "DELTA_BUG", 4, 8, "LURIDAN"
make_monster_gfx_prop "GILOMANTIS", 4, 8, "TOE_CUTTER"
make_monster_gfx_prop "TRILIUM", 4, 8, "OVER_GRUNK"
make_monster_gfx_prop "NIGHTSHADE", 4, 8, "EXORAY"
make_monster_gfx_prop "TUMBLEWEED", 4, 8, "CRUSHER"
make_monster_gfx_prop "BLOOMPIRE", 4, 8, "UROBUROS"
make_monster_gfx_prop "EXOCITE", 4, 8, "PRIMORDITE"
make_monster_gfx_prop "SKY_ARMOR", 4, 8
make_monster_gfx_prop "NAUTILOID", 4, 8, "CEPHALER"
make_monster_gfx_prop "EXOCITE", 4, 8, "MALIGA"
make_monster_gfx_prop "REACH_FROG", 4, 8, "GIGAN_TOAD"
make_monster_gfx_prop "LIZARD", 4, 8, "GECKOREX"
make_monster_gfx_prop "CHICKENLIP", 4, 8, "CLUCK"
make_monster_gfx_prop "HOOVER", 4, 16, "LAND_WORM"
make_monster_gfx_prop "RIDER", 4, 16, "TEST_RIDER"
make_monster_gfx_prop "MTEKARMOR", 4, 8, "PLUTOARMOR"
make_monster_gfx_prop "PIPSQUEAK", 4, 8, "TOMB_THUMB"
make_monster_gfx_prop "MTEKARMOR", 4, 8, "HEAVYARMOR"
make_monster_gfx_prop "TELSTAR", 4, 8, "CHASER"
make_monster_gfx_prop "LETHAL_WPN", 4, 16, "SCULLION"
make_monster_gfx_prop "VAPORITE", 3, 8, "POPLIUM"
make_monster_gfx_prop "BEHEMOTH", 4, 16, "INTANGIR"
make_monster_gfx_prop "ING", 4, 8, "MISFIT"
make_monster_gfx_prop "HUMPTY", 3, 8, "ELAND"
make_monster_gfx_prop "CRULLER", 4, 8, "ENUO"
make_monster_gfx_prop "BLEARY", 4, 8, "DEEP_EYE"
make_monster_gfx_prop "REPO_MAN", 4, 8, "GREASEMONK"
make_monster_gfx_prop "HARVESTER", 4, 8, "NECKHUNTER"
make_monster_gfx_prop "BOMB", 4, 8, "GRENADE"
make_monster_gfx_prop "CRITIC", 4, 16
make_monster_gfx_prop "BOXED_SET", 4, 8, "PAN_DORA"
make_monster_gfx_prop "SLAMDANCER", 4, 8, "SOULDANCER"
make_monster_gfx_prop "HADESGIGAS", 4, 16, "GIGANTOS"
make_monster_gfx_prop "MAG_ROADER_2", 4, 8
make_monster_gfx_prop "STRAY_CAT", 3, 8, "WILD_CAT"
make_monster_gfx_prop "ASPIK", 3, 8, "PARASITE"
make_monster_gfx_prop "TRILOBITER", 3, 8, "EARTHGUARD"
make_monster_gfx_prop "ARENEID", 3, 8, "COELECITE"
make_monster_gfx_prop "ACTANEON", 4, 8, "ANEMONE"
make_monster_gfx_prop "SAND_HORSE", 4, 8, "HIPOCAMPUS"
make_monster_gfx_prop "GHOST", 4, 8
make_monster_gfx_prop "MAD_OSCAR", 4, 8, "EVIL_OSCAR"
make_monster_gfx_prop "CRAWLY", 4, 8, "SLURM"
make_monster_gfx_prop "ANGUIFORM", 4, 8, "LATIMERIA"
make_monster_gfx_prop "GUARD", 4, 8, "STILLGOING"
make_monster_gfx_prop "OSTEOSAUR", 4, 16
make_monster_gfx_prop "BRAINPAN", 4, 8, "PHASE"
make_monster_gfx_prop "NINJA", 4, 8, "OUTSIDER"
make_monster_gfx_prop "DAHLING", 4, 8, "BARB_E"
make_monster_gfx_prop "RAIN_MAN", 4, 8, "PARASOUL"
make_monster_gfx_prop "WHISPER", 3, 8, "PM_STALKER"
make_monster_gfx_prop "OROG", 4, 8, "HEMOPHYTE"
make_monster_gfx_prop "TEMPLAR", 4, 8, "SP_FORCES"
make_monster_gfx_prop "LEAFER", 4, 8, "NOHRABBIT"
make_monster_gfx_prop "HAZER", 4, 8, "WIZARD"
make_monster_gfx_prop "BRAWLER", 4, 8, "SCRAPPER"
make_monster_gfx_prop "RHINOTAUR", 4, 8, "CERITOPS"
make_monster_gfx_prop "SOLDIER", 4, 8, "COMMANDO"
make_monster_gfx_prop "BUFFALAX", 4, 16, "OPINICUS"
make_monster_gfx_prop "RHODOX", 3, 8, "POPPERS"
make_monster_gfx_prop "LOBO", 3, 8, "LUNARIS"
make_monster_gfx_prop "DOBERMAN", 4, 8, "GARM"
make_monster_gfx_prop "DARK_WIND", 4, 8, "VINDR"
make_monster_gfx_prop "BEAKOR", 4, 8, "KIWOK"
make_monster_gfx_prop "VOMAMMOTH", 4, 8, "NASTIDON"
make_monster_gfx_prop "VAPORITE", 3, 8
make_monster_gfx_prop "CRASSHOPPR", 4, 8, "INSECARE"
make_monster_gfx_prop "WERE_RAT", 4, 8, "VERMIN"
make_monster_gfx_prop "GILOMANTIS", 4, 8, "MANTODEA"
make_monster_gfx_prop "FIDOR", 4, 8, "BOGY"
make_monster_gfx_prop "URSUS", 3, 8, "PRUSSIAN"
make_monster_gfx_prop "FOSSILFANG", 4, 8, "BLACK_DRGN"
make_monster_gfx_prop "BASKERVOR", 4, 8, "ADAMANCHYT"
make_monster_gfx_prop "RIDER", 4, 16, "DANTE"
make_monster_gfx_prop "PTERODON", 4, 8, "WIREY_DRGN"
make_monster_gfx_prop "MTEKARMOR", 4, 8, "DUELLER"
make_monster_gfx_prop "VAPORITE", 3, 8, "PSYCHOT"
make_monster_gfx_prop "FLAN", 4, 8, "MUUS"
make_monster_gfx_prop "ING", 4, 8, "KARKASS"
make_monster_gfx_prop "HARVESTER", 4, 8, "PUNISHER"
make_monster_gfx_prop "BOMB", 4, 8
make_monster_gfx_prop "REPO_MAN", 4, 8, "GABBLDEGAK"
make_monster_gfx_prop "BEHEMOTH", 4, 16, "GTBEHEMOTH"
make_monster_gfx_prop "ARENEID", 3, 8, "SCORPION"
make_monster_gfx_prop "TYRANOSAUR", 4, 8, "CHAOS_DRGN"
make_monster_gfx_prop "SKY_ARMOR", 4, 8, "SPIT_FIRE"
make_monster_gfx_prop "CHIMERA", 4, 16, "VECTAGOYLE"
make_monster_gfx_prop "GHOST", 4, 8, "LICH"
make_monster_gfx_prop "VULTURE", 4, 8, "OSPREY"
make_monster_gfx_prop "MAG_ROADER_1", 4, 8, "MAG_ROADER_3"
make_monster_gfx_prop "HORNET", 4, 8, "BUG"
make_monster_gfx_prop "ACTANEON", 4, 8, "SEA_FLOWER"
make_monster_gfx_prop "FORTIS", 4, 8
make_monster_gfx_prop "BEAKOR", 4, 8, "ABOLISHER"
make_monster_gfx_prop "HARPY", 4, 16, "AQUILA"
make_monster_gfx_prop "TRAPPER", 4, 8, "JUNK"
make_monster_gfx_prop "TRILIUM", 4, 8, "MANDRAKE"
make_monster_gfx_prop "REPO_MAN", 4, 8, "1ST_CLASS"
make_monster_gfx_prop "SLAMDANCER", 4, 8, "TAP_DANCER"
make_monster_gfx_prop "GHOST", 4, 8, "NECROMANCR"
make_monster_gfx_prop "HADESGIGAS", 4, 16, "BORRAS"
make_monster_gfx_prop "MAG_ROADER_2", 4, 8, "MAG_ROADER_4"
make_monster_gfx_prop "WERE_RAT", 4, 8
make_monster_gfx_prop "URSUS", 3, 8, "GOLD_BEAR"
make_monster_gfx_prop "TELSTAR", 4, 8, "INNOC"
make_monster_gfx_prop "TRIXTER", 4, 8
make_monster_gfx_prop "LOBO", 3, 8, "RED_WOLF"
make_monster_gfx_prop "DIDALOS", 4, 16
make_monster_gfx_prop "WOOLLY", 4, 8
make_monster_gfx_prop "VETERAN", 4, 8
make_monster_gfx_prop "SKY_ARMOR", 4, 8, "SKY_BASE"
make_monster_gfx_prop "PIPSQUEAK", 4, 8, "IRONHITMAN"
make_monster_gfx_prop "LETHAL_WPN", 4, 16, "IO"
make_monster_gfx_prop "PUG", 4, 8
make_monster_gfx_prop "WHELK_SHELL", 3, 8, "WHELK"
make_monster_gfx_prop "WHELK_SHELL", 3, 8, "PRESENTER"
make_monster_gfx_prop "MTEKARMOR", 4, 8, "MEGA_ARMOR"
make_monster_gfx_prop "VARGAS", 4, 16
make_monster_gfx_prop "TUNNELARMR", 4, 16
make_monster_gfx_prop "TUNNELARMR", 4, 16, "PROMETHEUS"
make_monster_gfx_prop "GHOSTTRAIN", 4, 8
make_monster_gfx_prop "DADALUMA", 4, 16
make_monster_gfx_prop "SHIVA", 4, 8
make_monster_gfx_prop "IFRIT_BOSS", 4, 8
make_monster_gfx_prop "NUMBER_024", 4, 16
make_monster_gfx_prop "NUMBER_128", 4, 16
make_monster_gfx_prop "NUMBER_128", 4, 16, "INFERNO"
make_monster_gfx_prop "CRANE", 4, 16
make_monster_gfx_prop "CRANE", 4, 16
make_monster_gfx_prop "UMARO", 4, 8
make_monster_gfx_prop "UMARO", 4, 8
make_monster_gfx_prop "GUARDIAN", 4, 16
make_monster_gfx_prop "GUARDIAN", 4, 16
make_monster_gfx_prop "AIR_FORCE", 4, 16
make_monster_gfx_prop "TRITOCH_BOSS", 4, 16
make_monster_gfx_prop "TRITOCH_BOSS", 4, 16
make_monster_gfx_prop "FLAMEEATER", 4, 8
make_monster_gfx_prop "ATMAWEAPON", 4, 16
make_monster_gfx_prop "WOOLLY", 4, 8, "NERAPA"
make_monster_gfx_prop "BEHEMOTH", 4, 16, "SRBEHEMOTH"
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "TENTACLE_1", 3, 8, "TENTACLE"
make_monster_gfx_prop "DIDALOS", 4, 16, "DULLAHAN"
make_monster_gfx_prop "DOOM_GAZE", 4, 16
make_monster_gfx_prop "CHADARNOOK_LADY", 4, 16
make_monster_gfx_prop "CURLEY", 4, 8
make_monster_gfx_prop "LARRY", 4, 8
make_monster_gfx_prop "MOE", 4, 8
make_monster_gfx_prop "DARK_FORCE", 4, 8, "WREXSOUL"
make_monster_gfx_prop "HIDON", 4, 16
make_monster_gfx_prop "SAMURAI", 4, 8, "KATANASOUL"
make_monster_gfx_prop "SLAMDANCER", 4, 8, "L30_MAGIC"
make_monster_gfx_prop "HIDONITE", 4, 8
make_monster_gfx_prop "DOOM", 4, 16
make_monster_gfx_prop "GODDESS", 4, 16
make_monster_gfx_prop "POLTRGEIST", 4, 16
make_monster_gfx_prop "FINAL_KEFKA", 4, 16
make_monster_gfx_prop "RAIN_MAN", 4, 8, "L40_MAGIC"
make_monster_gfx_prop "ULTROS_1", 4, 8
make_monster_gfx_prop "ULTROS_2", 4, 8
make_monster_gfx_prop "ULTROS_2", 4, 8
make_monster_gfx_prop "CHUPON", 4, 16
make_monster_gfx_prop "HAZER", 4, 8, "L20_MAGIC"
make_monster_gfx_prop "SIEGFRIED", 4, 8
make_monster_gfx_prop "GHOST", 4, 8, "L10_MAGIC"
make_monster_gfx_prop "OVER_MIND", 4, 8, "L50_MAGIC"
make_monster_gfx_prop "WHELK_HEAD_1", 4, 8
make_monster_gfx_prop "WHELK_HEAD_2", 4, 8
make_monster_gfx_prop "HADESGIGAS", 4, 16
make_monster_gfx_prop "CZARDRAGON", 4, 16
make_monster_gfx_prop "PUG", 4, 8, "MASTER_PUG"
make_monster_gfx_prop "WOOLLY", 4, 8, "L60_MAGIC"
make_monster_gfx_prop "MERCHANT", 4, 8
make_monster_gfx_prop "B_DAY_SUIT", 4, 8
make_monster_gfx_prop "TENTACLE_1", 3, 8, "TENTACLE"
make_monster_gfx_prop "TENTACLE_2", 3, 8, "TENTACLE"
make_monster_gfx_prop "TENTACLE_2", 3, 8, "TENTACLE"
make_monster_gfx_prop "RIGHT_BLADE", 4, 8, "RIGHT_LEFT_BLADE"
make_monster_gfx_prop "LEFT_BLADE", 4, 8, "RIGHT_LEFT_BLADE"
make_monster_gfx_prop "ROUGH", 4, 8, "ROUGH_STRIKER"
make_monster_gfx_prop "STRIKER", 4, 8, "ROUGH_STRIKER"
make_monster_gfx_prop "DARK_FORCE", 4, 8, "L70_MAGIC"
make_monster_gfx_prop "TRITOCH_BOSS", 4, 16
make_monster_gfx_prop "LASER_GUN", 4, 8
make_monster_gfx_prop "SPECK", 3, 8
make_monster_gfx_prop "MISSILEBAY", 4, 8, "LASER_GUN"
make_monster_gfx_prop "CHADARNOOK_DEMON", 4, 16
make_monster_gfx_prop "MESOSAUR", 4, 8, "ICE_DRAGON"
make_monster_gfx_prop "KEFKA", 4, 8
make_monster_gfx_prop "PTERODON", 4, 8, "STORM_DRGN"
make_monster_gfx_prop "TYRANOSAUR", 4, 8, "DIRT_DRGN"
make_monster_gfx_prop "URSUS", 3, 8
make_monster_gfx_prop "TEMPLAR", 4, 8, "SP_FORCES"
make_monster_gfx_prop "SOLDIER", 4, 8
make_monster_gfx_prop "BRACHOSAUR", 4, 16, "GOLD_DRGN"
make_monster_gfx_prop "FOSSILFANG", 4, 8, "SKULL_DRGN"
make_monster_gfx_prop "CZARDRAGON", 4, 16, "BLUE_DRGN"
make_monster_gfx_prop "DRAGON", 4, 16, "RED_DRAGON"
make_monster_gfx_prop "PIRANHA", 4, 8
make_monster_gfx_prop "PIRANHA", 4, 8, "RIZOPAS"
make_monster_gfx_prop "WHISPER", 3, 8, "PM_STALKER"
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "BRACHOSAUR", 4, 16
make_monster_gfx_prop "HIDONITE", 4, 8
make_monster_gfx_prop "HIDONITE", 4, 8
make_monster_gfx_prop "HIDONITE", 4, 8
make_monster_gfx_prop "DAHLING", 4, 8
make_monster_gfx_prop "TRIXTER", 4, 8, "L90_MAGIC"
make_monster_gfx_prop "FORTIS", 4, 8, "PROTOARMOR"
make_monster_gfx_prop "NUMBER_024", 4, 16, "MAGIMASTER"
make_monster_gfx_prop "SOULSAVER", 4, 8
make_monster_gfx_prop "ULTROS_2", 4, 8
make_monster_gfx_prop "TRIXTER", 4, 8, "NAUGHTY"
make_monster_gfx_prop "PHUNBABA", 4, 16
make_monster_gfx_prop "PHUNBABA", 4, 16
make_monster_gfx_prop "PHUNBABA", 4, 16
make_monster_gfx_prop "PHUNBABA", 4, 16
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "HOOVER", 4, 16, "ZONE_EATER"
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "KEFKA", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "SOLDIER", 4, 8, "OFFICER"
make_monster_gfx_prop "TEMPLAR", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "SOLDIER", 4, 8
make_monster_gfx_prop "IFRIT_BOSS", 4, 8, "ESPER"
make_monster_gfx_prop "GHOSTTRAIN", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "ATMAWEAPON", 4, 16, "ATMA"
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "RAMUH", 4, 8
make_monster_gfx_prop "IFRIT", 4, 16
make_monster_gfx_prop "SHIVA", 4, 8
make_monster_gfx_prop "SIREN", 4, 8
make_monster_gfx_prop "TERRATO", 4, 16
make_monster_gfx_prop "SHOAT", 4, 8
make_monster_gfx_prop "MADUIN", 4, 8
make_monster_gfx_prop "BISMARK", 3, 16
make_monster_gfx_prop "STRAY", 4, 8
make_monster_gfx_prop "PALIDOR", 4, 16
make_monster_gfx_prop "TRITOCH", 4, 16
make_monster_gfx_prop "ODIN", 4, 16
make_monster_gfx_prop "RAIDEN", 4, 16
make_monster_gfx_prop "BAHAMUT", 4, 16
make_monster_gfx_prop "ALEXANDR", 4, 16
make_monster_gfx_prop "CRUSADER_1", 4, 16
make_monster_gfx_prop "GUARD", 4, 8
make_monster_gfx_prop "KIRIN", 4, 8
make_monster_gfx_prop "ZONESEEK", 4, 8
make_monster_gfx_prop "CARBUNKL", 4, 8
make_monster_gfx_prop "PHANTOM", 3, 8
make_monster_gfx_prop "SRAPHIM", 4, 8
make_monster_gfx_prop "GOLEM", 4, 8
make_monster_gfx_prop "UNICORN", 4, 8
make_monster_gfx_prop "FENRIR", 4, 16
make_monster_gfx_prop "STARLET", 4, 16
make_monster_gfx_prop "PHOENIX", 4, 16
make_monster_gfx_prop "TIGERBREAK", 4, 8
make_monster_gfx_prop "CRUSADER_2", 4, 16
make_monster_gfx_prop "CRUSADER_2", 4, 16, "CRUSADER_3"
make_monster_gfx_prop "IMP", 3, 8, "TRILIUM"
make_monster_gfx_prop "GUARD", 4, 8

; ------------------------------------------------------------------------------

.segment "monster_pal"

; d2/7820
MonsterPal:
inc_monster_pal "GUARD", "guard"
inc_monster_pal "SOLDIER", "soldier"
inc_monster_pal "TEMPLAR", "templar"
inc_monster_pal "NINJA", "ninja"
inc_monster_pal "SAMURAI", "samurai"
inc_monster_pal "OROG", "orog"
inc_monster_pal "MAG_ROADER_1", "mag_roader_1"
inc_monster_pal "HAZER", "hazer"
inc_monster_pal "DAHLING", "dahling"
inc_monster_pal "RAIN_MAN", "rain_man"
inc_monster_pal "BRAWLER", "brawler"
inc_monster_pal "APOKRYPHOS", "apokryphos"
inc_monster_pal "DARK_FORCE", "dark_force"
inc_monster_pal "WHISPER", "whisper"
inc_monster_pal "OVER_MIND", "over_mind"
inc_monster_pal "OSTEOSAUR", "osteosaur"
inc_monster_pal "RHODOX", "rhodox"
inc_monster_pal "WERE_RAT", "were_rat"
inc_monster_pal "URSUS", "ursus"
inc_monster_pal "RHINOTAUR", "rhinotaur"
inc_monster_pal "STEROIDITE", "steroidite"
inc_monster_pal "LEAFER", "leafer"
inc_monster_pal "STRAY_CAT", "stray_cat"
inc_monster_pal "LOBO", "lobo"
inc_monster_pal "DOBERMAN", "doberman"
inc_monster_pal "VOMAMMOTH", "vomammoth"
inc_monster_pal "FIDOR", "fidor"
inc_monster_pal "BASKERVOR", "baskervor"
inc_monster_pal "SURIANDER", "suriander"
inc_monster_pal "CHIMERA", "chimera"
inc_monster_pal "BEHEMOTH", "behemoth"
inc_monster_pal "MESOSAUR", "mesosaur"
inc_monster_pal "PTERODON", "pterodon"
inc_monster_pal "FOSSILFANG", "fossilfang"
inc_monster_pal "WHITE_DRGN", "white_drgn"
inc_monster_pal "DOOM_DRGN", "doom_drgn"
inc_monster_pal "BRACHOSAUR", "brachosaur"
inc_monster_pal "TYRANOSAUR", "tyranosaur"
inc_monster_pal "DARK_WIND", "dark_wind"
inc_monster_pal "BEAKOR", "beakor"
inc_monster_pal "VULTURE", "vulture"
inc_monster_pal "HARPY", "harpy"
inc_monster_pal "HERMITCRAB", "hermitcrab"
inc_monster_pal "TRAPPER", "trapper"
inc_monster_pal "HORNET", "hornet"
inc_monster_pal "CRASSHOPPR", "crasshoppr"
inc_monster_pal "DELTA_BUG", "delta_bug"
inc_monster_pal "GILOMANTIS", "gilomantis"
inc_monster_pal "TRILIUM", "trilium"
inc_monster_pal "NIGHTSHADE", "nightshade"
inc_monster_pal "TUMBLEWEED", "tumbleweed"
inc_monster_pal "BLOOMPIRE", "bloompire"
inc_monster_pal "TRILOBITER", "trilobiter"
inc_monster_pal "SIEGFRIED", "siegfried"
inc_monster_pal "NAUTILOID", "nautiloid"
inc_monster_pal "EXOCITE", "exocite"
inc_monster_pal "ANGUIFORM", "anguiform"
inc_monster_pal "REACH_FROG", "reach_frog"
inc_monster_pal "LIZARD", "lizard"
inc_monster_pal "CHICKENLIP", "chickenlip"
inc_monster_pal "HOOVER", "hoover"
inc_monster_pal "RIDER", "rider"
inc_monster_pal "CHUPON", "chupon"
inc_monster_pal "PIPSQUEAK", "pipsqueak"
inc_monster_pal "MTEKARMOR", "mtekarmor"
inc_monster_pal "SKY_ARMOR", "sky_armor"
inc_monster_pal "TELSTAR", "telstar"
inc_monster_pal "LETHAL_WPN", "lethal_wpn"
inc_monster_pal "VAPORITE", "vaporite"
inc_monster_pal "FLAN", "flan"
inc_monster_pal "ING", "ing"
inc_monster_pal "HUMPTY", "humpty"
inc_monster_pal "BRAINPAN", "brainpan"
inc_monster_pal "CRULLER", "cruller"
inc_monster_pal "CACTROT", "cactrot"
inc_monster_pal "REPO_MAN", "repo_man"
inc_monster_pal "HARVESTER", "harvester"
inc_monster_pal "BOMB", "bomb"
inc_monster_pal "STILL_LIFE", "still_life"
inc_monster_pal "BOXED_SET", "boxed_set"
inc_monster_pal "SLAMDANCER", "slamdancer"
inc_monster_pal "HADESGIGAS", "hadesgigas"
inc_monster_pal "PUG", "pug"
inc_monster_pal "MAGIC_URN", "magic_urn"
inc_monster_pal "MOVER", "mover"
inc_monster_pal "FIGALIZ", "figaliz"
inc_monster_pal "BUFFALAX", "buffalax"
inc_monster_pal "ASPIK", "aspik"
inc_monster_pal "GHOST", "ghost"
inc_monster_pal "SAND_RAY", "sand_ray"
inc_monster_pal "ARENEID", "areneid"
inc_monster_pal "ACTANEON", "actaneon"
inc_monster_pal "SAND_HORSE", "sand_horse"
inc_monster_pal "MAD_OSCAR", "mad_oscar"
inc_monster_pal "CRAWLY", "crawly"
inc_monster_pal "BLEARY", "bleary"
inc_monster_pal "MARSHAL", "marshal"
inc_monster_pal "TROOPER", "trooper"
inc_monster_pal "GENERAL", "general"
inc_monster_pal "COVERT", "covert"
inc_monster_pal "OGOR", "ogor"
inc_monster_pal "WARLOCK", "warlock"
inc_monster_pal "MADAM", "madam"
inc_monster_pal "JOKER", "joker"
inc_monster_pal "IRON_FIST", "iron_fist"
inc_monster_pal "GOBLIN", "goblin"
inc_monster_pal "APPARITE", "apparite"
inc_monster_pal "POWERDEMON", "powerdemon"
inc_monster_pal "DISPLAYER", "displayer"
inc_monster_pal "PEEPERS", "peepers"
inc_monster_pal "SEWER_RAT", "sewer_rat"
inc_monster_pal "SLATTER", "slatter"
inc_monster_pal "RHINOX", "rhinox"
inc_monster_pal "RHOBITE", "rhobite"
inc_monster_pal "WILD_CAT", "wild_cat"
inc_monster_pal "RED_FANG", "red_fang"
inc_monster_pal "BOUNTY_MAN", "bounty_man"
inc_monster_pal "TUSKER", "tusker"
inc_monster_pal "RALPH", "ralph"
inc_monster_pal "CHITONID", "chitonid"
inc_monster_pal "WART_PUCK", "wart_puck"
inc_monster_pal "RHYOS", "rhyos"
inc_monster_pal "SRBEHEMOTH_UNDEAD", "srbehemoth_undead"
inc_monster_pal "VECTAUR", "vectaur"
inc_monster_pal "WYVERN", "wyvern"
inc_monster_pal "ZOMBONE", "zombone"
inc_monster_pal "DRAGON", "dragon"
inc_monster_pal "BRONTAUR", "brontaur"
inc_monster_pal "ALLOSAURUS", "allosaurus"
inc_monster_pal "CIRPIUS", "cirpius"
inc_monster_pal "SPRINTER", "sprinter"
inc_monster_pal "GOBBLER", "gobbler"
inc_monster_pal "HARPIAI", "harpiai"
inc_monster_pal "GLOOMSHELL", "gloomshell"
inc_monster_pal "DROP", "drop"
inc_monster_pal "MIND_CANDY", "mind_candy"
inc_monster_pal "WEEDFEEDER", "weedfeeder"
inc_monster_pal "LURIDAN", "luridan"
inc_monster_pal "TOE_CUTTER", "toe_cutter"
inc_monster_pal "OVER_GRUNK", "over_grunk"
inc_monster_pal "EXORAY", "exoray"
inc_monster_pal "CRUSHER", "crusher"
inc_monster_pal "UROBUROS", "uroburos"
inc_monster_pal "PRIMORDITE", "primordite"
inc_monster_pal "CEPHALER", "cephaler"
inc_monster_pal "MALIGA", "maliga"
inc_monster_pal "GIGAN_TOAD", "gigan_toad"
inc_monster_pal "GECKOREX", "geckorex"
inc_monster_pal "CLUCK", "cluck"
inc_monster_pal "LAND_WORM", "land_worm"
inc_monster_pal "TEST_RIDER", "test_rider"
inc_monster_pal "PLUTOARMOR", "plutoarmor"
inc_monster_pal "TOMB_THUMB", "tomb_thumb"
inc_monster_pal "HEAVYARMOR", "heavyarmor"
inc_monster_pal "CHASER", "chaser"
inc_monster_pal "SCULLION", "scullion"
inc_monster_pal "POPLIUM", "poplium"
inc_monster_pal "INTANGIR", "intangir"
inc_monster_pal "MISFIT", "misfit"
inc_monster_pal "ELAND", "eland"
inc_monster_pal "ENUO", "enuo"
inc_monster_pal "DEEP_EYE", "deep_eye"
inc_monster_pal "GREASEMONK", "greasemonk"
inc_monster_pal "NECKHUNTER", "neckhunter"
inc_monster_pal "GRENADE", "grenade"
inc_monster_pal "CRITIC", "critic"
inc_monster_pal "PAN_DORA", "pan_dora"
inc_monster_pal "SOULDANCER", "souldancer"
inc_monster_pal "GIGANTOS", "gigantos"
inc_monster_pal "MAG_ROADER_2", "mag_roader_2"
inc_monster_pal "PARASITE", "parasite"
inc_monster_pal "EARTHGUARD", "earthguard"
inc_monster_pal "COELECITE", "coelecite"
inc_monster_pal "ANEMONE", "anemone"
inc_monster_pal "HIPOCAMPUS", "hipocampus"
inc_monster_pal "EVIL_OSCAR", "evil_oscar"
inc_monster_pal "SLURM", "slurm"
inc_monster_pal "LATIMERIA", "latimeria"
inc_monster_pal "STILLGOING", "stillgoing"
inc_monster_pal "PHASE", "phase"
inc_monster_pal "OUTSIDER", "outsider"
inc_monster_pal "BARB_E", "barb_e"
inc_monster_pal "PARASOUL", "parasoul"
inc_monster_pal "PM_STALKER", "pm_stalker"
inc_monster_pal "HEMOPHYTE", "hemophyte"
inc_monster_pal "SP_FORCES", "sp_forces"
inc_monster_pal "NOHRABBIT", "nohrabbit"
inc_monster_pal "WIZARD", "wizard"
inc_monster_pal "SCRAPPER", "scrapper"
inc_monster_pal "CERITOPS", "ceritops"
inc_monster_pal "COMMANDO", "commando"
inc_monster_pal "OPINICUS", "opinicus"
inc_monster_pal "POPPERS", "poppers"
inc_monster_pal "LUNARIS", "lunaris"
inc_monster_pal "GARM", "garm"
inc_monster_pal "VINDR", "vindr"
inc_monster_pal "KIWOK", "kiwok"
inc_monster_pal "NASTIDON", "nastidon"
inc_monster_pal "INSECARE", "insecare"
inc_monster_pal "VERMIN", "vermin"
inc_monster_pal "MANTODEA", "mantodea"
inc_monster_pal "BOGY", "bogy"
inc_monster_pal "PRUSSIAN", "prussian"
inc_monster_pal "BLACK_DRGN", "black_drgn"
inc_monster_pal "ADAMANCHYT", "adamanchyt"
inc_monster_pal "DANTE", "dante"
inc_monster_pal "WIREY_DRGN", "wirey_drgn"
inc_monster_pal "DUELLER", "dueller"
inc_monster_pal "PSYCHOT", "psychot"
inc_monster_pal "MUUS", "muus"
inc_monster_pal "KARKASS", "karkass"
inc_monster_pal "PUNISHER", "punisher"
inc_monster_pal "GABBLDEGAK", "gabbldegak"
inc_monster_pal "GTBEHEMOTH", "gtbehemoth"
inc_monster_pal "SCORPION", "scorpion"
inc_monster_pal "CHAOS_DRGN", "chaos_drgn"
inc_monster_pal "SPIT_FIRE", "spit_fire"
inc_monster_pal "VECTAGOYLE", "vectagoyle"
inc_monster_pal "LICH", "lich"
inc_monster_pal "OSPREY", "osprey"
inc_monster_pal "MAG_ROADER_3", "mag_roader_3"
inc_monster_pal "BUG", "bug"
inc_monster_pal "SEA_FLOWER", "sea_flower"
inc_monster_pal "FORTIS", "fortis"
inc_monster_pal "ABOLISHER", "abolisher"
inc_monster_pal "AQUILA", "aquila"
inc_monster_pal "JUNK", "junk"
inc_monster_pal "MANDRAKE", "mandrake"
inc_monster_pal "1ST_CLASS", "1st_class"
inc_monster_pal "TAP_DANCER", "tap_dancer"
inc_monster_pal "NECROMANCR", "necromancr"
inc_monster_pal "BORRAS", "borras"
inc_monster_pal "MAG_ROADER_4", "mag_roader_4"
inc_monster_pal "GOLD_BEAR", "gold_bear"
inc_monster_pal "INNOC", "innoc"
inc_monster_pal "TRIXTER", "trixter"
inc_monster_pal "RED_WOLF", "red_wolf"
inc_monster_pal "DIDALOS", "didalos"
inc_monster_pal "WOOLLY", "woolly"
inc_monster_pal "VETERAN", "veteran"
inc_monster_pal "SKY_BASE", "sky_base"
inc_monster_pal "IRONHITMAN", "ironhitman"
inc_monster_pal "IO", "io"
inc_monster_pal "WHELK", "whelk"
inc_monster_pal "PRESENTER", "presenter"
inc_monster_pal "MEGA_ARMOR", "mega_armor"
inc_monster_pal "VARGAS", "vargas"
inc_monster_pal "TUNNELARMR", "tunnelarmr"
inc_monster_pal "PROMETHEUS", "prometheus"
inc_monster_pal "GHOSTTRAIN", "ghosttrain"
inc_monster_pal "DADALUMA", "dadaluma"
inc_monster_pal "SHIVA", "shiva"
inc_monster_pal "IFRIT_BOSS", "ifrit_boss"
inc_monster_pal "NUMBER_024", "number_024"
inc_monster_pal "NUMBER_128", "number_128"
inc_monster_pal "INFERNO", "inferno"
inc_monster_pal "CRANE", "crane"
inc_monster_pal "UMARO", "umaro"
inc_monster_pal "GUARDIAN", "guardian"
inc_monster_pal "AIR_FORCE", "air_force"
inc_monster_pal "TRITOCH_BOSS", "tritoch_boss"
inc_monster_pal "FLAMEEATER", "flameeater"
inc_monster_pal "ATMAWEAPON", "atmaweapon"
inc_monster_pal "NERAPA", "nerapa"
inc_monster_pal "SRBEHEMOTH", "srbehemoth"
inc_monster_pal "TENTACLE", "tentacle"
inc_monster_pal "DULLAHAN", "dullahan"
inc_monster_pal "DOOM_GAZE", "doom_gaze"
inc_monster_pal "CHADARNOOK_LADY", "chadarnook_lady"
inc_monster_pal "CURLEY", "curley"
inc_monster_pal "LARRY", "larry"
inc_monster_pal "MOE", "moe"
inc_monster_pal "WREXSOUL", "wrexsoul"
inc_monster_pal "HIDON", "hidon"
inc_monster_pal "KATANASOUL", "katanasoul"
inc_monster_pal "L30_MAGIC", "l30_magic"
inc_monster_pal "HIDONITE", "hidonite"
inc_monster_pal "DOOM", "doom"
inc_monster_pal "GODDESS", "goddess"
inc_monster_pal "POLTRGEIST", "poltrgeist"
inc_monster_pal "FINAL_KEFKA", "final_kefka"
inc_monster_pal "L40_MAGIC", "l40_magic"
inc_monster_pal "ULTROS_1", "ultros_1"
inc_monster_pal "ULTROS_2", "ultros_2"
inc_monster_pal "L20_MAGIC", "l20_magic"
inc_monster_pal "L10_MAGIC", "l10_magic"
inc_monster_pal "L50_MAGIC", "l50_magic"
inc_monster_pal "WHELK_HEAD_1", "whelk_head_1"
inc_monster_pal "WHELK_HEAD_2", "whelk_head_2"
inc_monster_pal "CZARDRAGON", "czardragon"
inc_monster_pal "MASTER_PUG", "master_pug"
inc_monster_pal "L60_MAGIC", "l60_magic"
inc_monster_pal "MERCHANT", "merchant"
inc_monster_pal "B_DAY_SUIT", "b_day_suit"
inc_monster_pal "RIGHT_LEFT_BLADE", "right_left_blade"
inc_monster_pal "ROUGH_STRIKER", "rough_striker"
inc_monster_pal "L70_MAGIC", "l70_magic"
inc_monster_pal "LASER_GUN", "laser_gun"
inc_monster_pal "SPECK", "speck"
inc_monster_pal "CHADARNOOK_DEMON", "chadarnook_demon"
inc_monster_pal "ICE_DRAGON", "ice_dragon"
inc_monster_pal "KEFKA", "kefka"
inc_monster_pal "STORM_DRGN", "storm_drgn"
inc_monster_pal "DIRT_DRGN", "dirt_drgn"
inc_monster_pal "GOLD_DRGN", "gold_drgn"
inc_monster_pal "SKULL_DRGN", "skull_drgn"
inc_monster_pal "BLUE_DRGN", "blue_drgn"
inc_monster_pal "RED_DRAGON", "red_dragon"
inc_monster_pal "PIRANHA", "piranha"
inc_monster_pal "RIZOPAS", "rizopas"
inc_monster_pal "L90_MAGIC", "l90_magic"
inc_monster_pal "PROTOARMOR", "protoarmor"
inc_monster_pal "MAGIMASTER", "magimaster"
inc_monster_pal "SOULSAVER", "soulsaver"
inc_monster_pal "NAUGHTY", "naughty"
inc_monster_pal "PHUNBABA", "phunbaba"
inc_monster_pal "ZONE_EATER", "zone_eater"
inc_monster_pal "OFFICER", "officer"
inc_monster_pal "ESPER", "esper"
inc_monster_pal "ATMA", "atma"
inc_monster_pal "RAMUH", "ramuh"
inc_monster_pal "IFRIT", "ifrit"
inc_monster_pal "SIREN", "siren"
inc_monster_pal "TERRATO", "terrato"
inc_monster_pal "SHOAT", "shoat"
inc_monster_pal "MADUIN", "maduin"
inc_monster_pal "BISMARK", "bismark"
inc_monster_pal "STRAY", "stray"
inc_monster_pal "PALIDOR", "palidor"
inc_monster_pal "TRITOCH", "tritoch"
inc_monster_pal "ODIN", "odin"
inc_monster_pal "RAIDEN", "raiden"
inc_monster_pal "BAHAMUT", "bahamut"
inc_monster_pal "ALEXANDR", "alexandr"
inc_monster_pal "CRUSADER_1", "crusader_1"
inc_monster_pal "KIRIN", "kirin"
inc_monster_pal "ZONESEEK", "zoneseek"
inc_monster_pal "CARBUNKL", "carbunkl"
inc_monster_pal "PHANTOM", "phantom"
inc_monster_pal "SRAPHIM", "sraphim"
inc_monster_pal "GOLEM", "golem"
inc_monster_pal "UNICORN", "unicorn"
inc_monster_pal "FENRIR", "fenrir"
inc_monster_pal "STARLET", "starlet"
inc_monster_pal "PHOENIX", "phoenix"
inc_monster_pal "TIGERBREAK", "tigerbreak"
inc_monster_pal "CRUSADER_2", "crusader_2"
inc_monster_pal "CRUSADER_3", "crusader_3"

; ------------------------------------------------------------------------------

.segment "monster_stencil"

; d2/a820
MonsterStencil:
        .addr   MonsterStencilSmall
        .addr   MonsterStencilLarge

; ------------------------------------------------------------------------------

; d2/a824
MonsterStencilSmall:
        .incbin "monster_gfx/guard.stn"
        .incbin "monster_gfx/soldier.stn"
        .incbin "monster_gfx/templar.stn"
        .incbin "monster_gfx/ninja.stn"
        .incbin "monster_gfx/samurai.stn"
        .incbin "monster_gfx/orog.stn"
        .incbin "monster_gfx/mag_roader_1.stn"
        .incbin "monster_gfx/hazer.stn"
        incbin_lang "monster_gfx/dahling_%s.stn"
        .incbin "monster_gfx/rain_man.stn"
        .incbin "monster_gfx/brawler.stn"
        .incbin "monster_gfx/apokryphos.stn"
        .incbin "monster_gfx/dark_force.stn"
        .incbin "monster_gfx/whisper.stn"
        .incbin "monster_gfx/over_mind.stn"
        .incbin "monster_gfx/rhodox.stn"
        .incbin "monster_gfx/were_rat.stn"
        .incbin "monster_gfx/ursus.stn"
        .incbin "monster_gfx/rhinotaur.stn"
        .incbin "monster_gfx/leafer.stn"
        .incbin "monster_gfx/stray_cat.stn"
        .incbin "monster_gfx/lobo.stn"
        .incbin "monster_gfx/doberman.stn"
        .incbin "monster_gfx/vomammoth.stn"
        .incbin "monster_gfx/fidor.stn"
        .incbin "monster_gfx/baskervor.stn"
        .incbin "monster_gfx/suriander.stn"
        .incbin "monster_gfx/mesosaur.stn"
        .incbin "monster_gfx/pterodon.stn"
        .incbin "monster_gfx/fossilfang.stn"
        .incbin "monster_gfx/tyranosaur.stn"
        .incbin "monster_gfx/dark_wind.stn"
        .incbin "monster_gfx/beakor.stn"
        .incbin "monster_gfx/vulture.stn"
        .incbin "monster_gfx/hermitcrab.stn"
        .incbin "monster_gfx/trapper.stn"
        .incbin "monster_gfx/hornet.stn"
        .incbin "monster_gfx/crasshoppr.stn"
        .incbin "monster_gfx/delta_bug.stn"
        .incbin "monster_gfx/gilomantis.stn"
        .incbin "monster_gfx/trilium.stn"
        .incbin "monster_gfx/nightshade.stn"
        .incbin "monster_gfx/tumbleweed.stn"
        .incbin "monster_gfx/bloompire.stn"
        .incbin "monster_gfx/trilobiter.stn"
        .incbin "monster_gfx/siegfried.stn"
        .incbin "monster_gfx/nautiloid.stn"
        .incbin "monster_gfx/exocite.stn"
        .incbin "monster_gfx/anguiform.stn"
        .incbin "monster_gfx/reach_frog.stn"
        .incbin "monster_gfx/lizard.stn"
        .incbin "monster_gfx/chickenlip.stn"
        .incbin "monster_gfx/pipsqueak.stn"
        .incbin "monster_gfx/mtekarmor.stn"
        .incbin "monster_gfx/sky_armor.stn"
        .incbin "monster_gfx/telstar.stn"
        .incbin "monster_gfx/vaporite.stn"
        .incbin "monster_gfx/flan.stn"
        .incbin "monster_gfx/ing.stn"
        .incbin "monster_gfx/humpty.stn"
        .incbin "monster_gfx/brainpan.stn"
        .incbin "monster_gfx/cruller.stn"
        .incbin "monster_gfx/cactrot.stn"
        .incbin "monster_gfx/repo_man.stn"
        .incbin "monster_gfx/harvester.stn"
        .incbin "monster_gfx/bomb.stn"
        .incbin "monster_gfx/still_life.stn"
        .incbin "monster_gfx/boxed_set.stn"
        .incbin "monster_gfx/slamdancer.stn"
        .incbin "monster_gfx/pug.stn"
        .incbin "monster_gfx/magic_urn.stn"
        .incbin "monster_gfx/mover.stn"
        .incbin "monster_gfx/figaliz.stn"
        .incbin "monster_gfx/aspik.stn"
        .incbin "monster_gfx/ghost.stn"
        .incbin "monster_gfx/areneid.stn"
        .incbin "monster_gfx/actaneon.stn"
        .incbin "monster_gfx/sand_horse.stn"
        .incbin "monster_gfx/mad_oscar.stn"
        .incbin "monster_gfx/crawly.stn"
        .incbin "monster_gfx/bleary.stn"
        .incbin "monster_gfx/mag_roader_2.stn"
        .incbin "monster_gfx/fortis.stn"
        .incbin "monster_gfx/trixter.stn"
        .incbin "monster_gfx/woolly.stn"
        .incbin "monster_gfx/veteran.stn"
        .incbin "monster_gfx/whelk_shell.stn"
        .incbin "monster_gfx/ghosttrain.stn"
        .incbin "monster_gfx/shiva.stn"
        .incbin "monster_gfx/ifrit_boss.stn"
        .incbin "monster_gfx/umaro.stn"
        .incbin "monster_gfx/flameeater.stn"
        .incbin "monster_gfx/tentacle_1.stn"
        .incbin "monster_gfx/curley.stn"
        .incbin "monster_gfx/larry.stn"
        .incbin "monster_gfx/moe.stn"
        .incbin "monster_gfx/hidonite.stn"
        .incbin "monster_gfx/ultros_1.stn"
        .incbin "monster_gfx/ultros_2.stn"
        .incbin "monster_gfx/whelk_head_1.stn"
        .incbin "monster_gfx/whelk_head_2.stn"
        .incbin "monster_gfx/merchant.stn"
        .incbin "monster_gfx/b_day_suit.stn"
        .incbin "monster_gfx/tentacle_2.stn"
        .incbin "monster_gfx/right_blade.stn"
        .incbin "monster_gfx/left_blade.stn"
        .incbin "monster_gfx/rough.stn"
        .incbin "monster_gfx/striker.stn"
        .incbin "monster_gfx/laser_gun.stn"
        .incbin "monster_gfx/speck.stn"
        .incbin "monster_gfx/missilebay.stn"
        .incbin "monster_gfx/kefka.stn"
        .incbin "monster_gfx/piranha.stn"
        .incbin "monster_gfx/soulsaver.stn"
        .incbin "monster_gfx/ramuh.stn"
        incbin_lang "monster_gfx/siren_%s.stn"
        .incbin "monster_gfx/shoat.stn"
        .incbin "monster_gfx/maduin.stn"
        .incbin "monster_gfx/stray.stn"
        .incbin "monster_gfx/kirin.stn"
        .incbin "monster_gfx/zoneseek.stn"
        .incbin "monster_gfx/carbunkl.stn"
        .incbin "monster_gfx/phantom.stn"
        .incbin "monster_gfx/sraphim.stn"
        .incbin "monster_gfx/golem.stn"
        .incbin "monster_gfx/unicorn.stn"
        .incbin "monster_gfx/tigerbreak.stn"
        .incbin "monster_gfx/imp.stn"

; ------------------------------------------------------------------------------

; d2/ac24
MonsterStencilLarge:
        .incbin "monster_gfx/osteosaur.stn"
        .incbin "monster_gfx/phunbaba.stn"
        .incbin "monster_gfx/chimera.stn"
        .incbin "monster_gfx/behemoth.stn"
        .incbin "monster_gfx/dragon.stn"
        .incbin "monster_gfx/czardragon.stn"
        .incbin "monster_gfx/brachosaur.stn"
        .incbin "monster_gfx/harpy.stn"
        .incbin "monster_gfx/hoover.stn"
        .incbin "monster_gfx/rider.stn"
        .incbin "monster_gfx/chupon.stn"
        .incbin "monster_gfx/lethal_wpn.stn"
        .incbin "monster_gfx/hadesgigas.stn"
        .incbin "monster_gfx/buffalax.stn"
        incbin_lang "monster_gfx/critic_%s.stn"
        .incbin "monster_gfx/didalos.stn"
        .incbin "monster_gfx/vargas.stn"
        .incbin "monster_gfx/tunnelarmr.stn"
        .incbin "monster_gfx/dadaluma.stn"
        .incbin "monster_gfx/number_024.stn"
        .incbin "monster_gfx/number_128.stn"
        .incbin "monster_gfx/crane.stn"
        .incbin "monster_gfx/guardian.stn"
        .incbin "monster_gfx/air_force.stn"
        .incbin "monster_gfx/tritoch_boss.stn"
        .incbin "monster_gfx/atmaweapon.stn"
        .incbin "monster_gfx/doom_gaze.stn"
        incbin_lang "monster_gfx/chadarnook_lady_%s.stn"
        .incbin "monster_gfx/hidon.stn"
        .incbin "monster_gfx/doom.stn"
        incbin_lang "monster_gfx/goddess_%s.stn"
        .incbin "monster_gfx/poltrgeist.stn"
        .incbin "monster_gfx/final_kefka.stn"
        .incbin "monster_gfx/chadarnook_demon.stn"
        .incbin "monster_gfx/ifrit.stn"
        .incbin "monster_gfx/terrato.stn"
        .incbin "monster_gfx/bismark.stn"
        .incbin "monster_gfx/palidor.stn"
        .incbin "monster_gfx/tritoch.stn"
        .incbin "monster_gfx/odin.stn"
        .incbin "monster_gfx/raiden.stn"
        .incbin "monster_gfx/bahamut.stn"
        .incbin "monster_gfx/alexandr.stn"
        .incbin "monster_gfx/crusader_1.stn"
        .incbin "monster_gfx/fenrir.stn"
        incbin_lang "monster_gfx/starlet_%s.stn"
        .incbin "monster_gfx/phoenix.stn"
        .incbin "monster_gfx/crusader_2.stn"

; ------------------------------------------------------------------------------
