
# the assembler
ASM = ca65
ASMFLAGS = -g -I include
VERSION_EXT =

# the linker
LINK = ld65
LINKFLAGS =

# script to fix the SNES checksum
FIX_CHECKSUM = python3 tools/fix_checksum.py

# list of ROM versions
VERSIONS = ff6-en ff6-en1 ff6-jp
OBJ_DIR = obj
ROM_DIR = rom
ROMS = $(foreach V, $(VERSIONS), $(ROM_DIR)/$(V).sfc)

# the SPC program
SPC_PRG = src/sound/ff6-spc.dat

.PHONY: all rip clean distclean mml spc wav rng event monster_gfx text dte \
	$(VERSIONS) $(MODULES)

# disable default suffix rules
.SUFFIXES:

# make all versions
all: $(VERSIONS)

# rip data from ROMs
rip:
	python3 tools/extract_assets.py
	python3 tools/fix_dlg.py combine en
	python3 tools/fix_dlg.py combine jp

# shuffle the RNG table
rng:
	python3 tools/shuffle_rng.py src/field/rng_tbl.dat

spc: $(SPC_PRG)

clean:
	$(RM) -rf $(ROM_DIR) $(OBJ_DIR)
	$(RM) -f src/text/*.dat
	$(RM) src/sound/song_script/*.asm src/sound/sfx_script/*.asm
	$(RM) src/sound/sample_brr/*.wav src/sound/sfx_brr/*.wav
	$(RM) $(SPC_PRG)
	$(RM) rom/ff6-event.bin

distclean: clean
	python3 tools/clean_assets.py

# ROM filenames
FF6_JP_PATH = $(ROM_DIR)/ff6-jp.sfc
FF6_EN_PATH = $(ROM_DIR)/ff6-en.sfc
FF6_EN1_PATH = $(ROM_DIR)/ff6-en1.sfc

ff6-jp: $(FF6_JP_PATH)
ff6-en: $(FF6_EN_PATH)
ff6-en1: $(FF6_EN1_PATH)

# set up target-specific variables
ff6-jp: VERSION_EXT = jp
ff6-en: VERSION_EXT = en
ff6-en1: VERSION_EXT = en1

ff6-jp: ASMFLAGS += -D ROM_VERSION=0
ff6-en: ASMFLAGS += -D LANG_EN=1 -D ROM_VERSION=0
ff6-en1: ASMFLAGS += -D LANG_EN=1 -D ROM_VERSION=1

%.lz: %
	python3 tools/ff6_lzss.py $< $@

# list of all include files
INC_FILES = $(wildcard include/*.inc) $(wildcard include/*/*.inc)

# target-specific object filenames
OBJ_FILES_JP = $(foreach M,$(MODULES),$(OBJ_DIR)/$(M)_jp.o)
OBJ_FILES_EN = $(foreach M,$(MODULES),$(OBJ_DIR)/$(M)_en.o)
OBJ_FILES_EN1 = $(foreach M,$(MODULES),$(OBJ_DIR)/$(M)_en1.o)

# list of modules
MODULES = field btlgfx battle menu sound cutscene event world gfx text

# generate rules for making each module
define MAKE_MODULE
$1_SRC := $(wildcard src/$1/*) $(wildcard src/$1/*/*)
$$(OBJ_DIR)/$1_%.o: $$($1_SRC) $$(INC_FILES)
	@mkdir -p $$(OBJ_DIR)
	$$(ASM) $$(ASMFLAGS) -l $$(@:o=lst) src/$1/$1_main.asm -o $$@
endef

$(foreach M, $(MODULES), $(eval $(call MAKE_MODULE,$(M))))

# temporary compressed cutscene program file
LZ_DIR = temp_lz
CUTSCENE_LZ = $(LZ_DIR)/cutscene.lz
CUTSCENE_LZ_ASM = $(LZ_DIR)/cutscene_lz.asm

$(OBJ_DIR)/ff6-spc.o: src/sound/ff6-spc.asm
	@mkdir -p $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -l $(@:o=lst) $< -o $@

$(SPC_PRG): cfg/ff6-spc.cfg $(OBJ_DIR)/ff6-spc.o
	$(LINK) $(LINKFLAGS) -o $@ -C $< $(OBJ_DIR)/ff6-spc.o

# list of all text files
TEXT_JSON_FILES = $(wildcard src/text/*.json)
TEXT_DAT_FILES = $(TEXT_JSON_FILES:json=dat)

text: $(TEXT_DAT_FILES)

src/text/dlg1_%.dat src/text/dlg2_%.dat: src/text/dlg1_%.json src/text/dlg2_%.json
	python3 tools/fix_dlg.py split $*
	python3 tools/encode_text.py src/text/dlg1_$*.json
	python3 tools/encode_text.py src/text/dlg2_$*.json
	python3 tools/fix_dlg.py combine $*
	@touch $@

src/text/%.dat: src/text/%.json
	python3 tools/encode_text.py $<

dte:
	python3 tools/fix_dlg.py dte en

# rules for converting mml files to asm
SONG_MML_FILES = $(wildcard src/sound/song_script/*.mml)
SONG_ASM_FILES = $(SONG_MML_FILES:mml=asm)

SFX_MML_FILES = $(wildcard src/sound/sfx_script/*.mml)
SFX_ASM_FILES = $(SFX_MML_FILES:mml=asm)

mml: $(SONG_ASM_FILES) $(SFX_ASM_FILES)

src/sound/song_script/%.asm: src/sound/song_script/%.mml
	python3 tools/encode_mml.py $<

src/sound/sfx_script/%.asm: src/sound/sfx_script/%.mml
	python3 tools/encode_sfx.py $<

# rules for converting extracted BRR files to WAV files
BRR_FILES = $(wildcard src/sound/sample_brr/*.brr) \
	$(wildcard src/sound/sfx_brr/*.brr)
WAV_FILES = $(BRR_FILES:brr=wav)
wav: $(WAV_FILES)

%.wav: %.brr
	python3 tools/brr.py $< $@

# rules for trimming monster graphics
MONSTER_GFX_FILES = $(wildcard src/gfx/monster_gfx/*.4bpp) \
	$(wildcard src/gfx/monster_gfx/*.3bpp)
MONSTER_TRIMMED_FILES = $(addsuffix .trm,$(MONSTER_GFX_FILES))
monster_gfx: $(MONSTER_TRIMMED_FILES)

%.trm: %
	python3 tools/monster_stencil.py $<

event: rom/ff6-event.bin

rom/ff6-event.bin: cfg/ff6-event.cfg obj/event_en.o
	$(LINK) $(LINKFLAGS) -o $@ -C $< obj/event_en.o

# rules for making ROM files
# run linker twice: 1st for the cutscene program, 2nd for the ROM itself
$(FF6_JP_PATH): cfg/ff6-jp.cfg spc mml text monster_gfx $(OBJ_FILES_JP)
	@mkdir -p $(LZ_DIR) $(ROM_DIR)
	$(LINK) $(LINKFLAGS) --dbgfile $(@:sfc=dbg) -o "" -C $< $(OBJ_FILES_JP)
	python3 tools/encode_cutscene.py $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_JP) $(CUTSCENE_LZ).o
	@$(RM) -rf $(LZ_DIR)
	$(FIX_CHECKSUM) $@

$(FF6_EN_PATH): cfg/ff6-en.cfg spc mml text monster_gfx $(OBJ_FILES_EN)
	@mkdir -p $(LZ_DIR) $(ROM_DIR)
	$(LINK) $(LINKFLAGS) --dbgfile $(@:sfc=dbg) -o "" -C $< $(OBJ_FILES_EN)
	python3 tools/encode_cutscene.py $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_EN) $(CUTSCENE_LZ).o
	@$(RM) -rf $(LZ_DIR)
	$(FIX_CHECKSUM) $@

$(FF6_EN1_PATH): cfg/ff6-en.cfg spc mml text monster_gfx $(OBJ_FILES_EN1)
	@mkdir -p $(LZ_DIR) $(ROM_DIR)
	$(LINK) $(LINKFLAGS) --dbgfile $(@:sfc=dbg) -o "" -C $< $(OBJ_FILES_EN1)
	python3 tools/encode_cutscene.py $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_EN1) $(CUTSCENE_LZ).o
	@$(RM) -rf $(LZ_DIR)
	$(FIX_CHECKSUM) $@
