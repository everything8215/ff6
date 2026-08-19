# -----------------------------------------------------------------------------
# define variables
# -----------------------------------------------------------------------------

# the assembler
ASM := ca65
ASMFLAGS := -g -I .

# the linker
LINK := ld65
LINKFLAGS :=

# python interpreter
PYTHON := python3
export PYTHONPATH := tools/romtools:$(PYTHONPATH)

# define language
LANG := en

ifeq ($(LANG),en)
  ASMFLAGS += -D LANG_EN=1
else ifeq ($(LANG),jp)
  ASMFLAGS += -D LANG_JP=1
else
  $(error Unsupported language: $(LANG))
endif

# define build directories
BUILD_DIR := build/$(LANG)
OBJ_DIR := $(BUILD_DIR)/obj
BIN_DIR := $(BUILD_DIR)/bin
DEP_DIR := $(BUILD_DIR)/dep
LST_DIR := $(BUILD_DIR)/lst
ROM_DIR := $(BUILD_DIR)/rom

ASMFLAGS += -I $(BUILD_DIR) --bin-include-dir $(BUILD_DIR)

# set the ROM version
ROM_VERSION ?= 0
ASMFLAGS += -D ROM_VERSION=$(ROM_VERSION)

# list of modules
MODULES := field btlgfx battle data menu sound cutscene event world gfx text

# object files
OBJ_FILES := $(foreach M,$(MODULES),$(OBJ_DIR)/$(M).o)

# ROM filename
ROM_PATH := $(ROM_DIR)/ff6-$(LANG).sfc

.PHONY: all rip clean distclean mml spc wav rng event monster_gfx text dte lz

# disable default suffix rules
.SUFFIXES:

# -----------------------------------------------------------------------------
# ROM file rule
# -----------------------------------------------------------------------------

# temporary compressed cutscene program file
TEMP_LZ_DIR := $(BUILD_DIR)/temp_lz
CUTSCENE_LZ := $(TEMP_LZ_DIR)/cutscene.lz
CUTSCENE_LZ_ASM := $(TEMP_LZ_DIR)/cutscene_lz.asm

# rule for making the ROM file
# run linker twice: 1st for the cutscene program, 2nd for the ROM itself
$(ROM_PATH): cfg/ff6-$(LANG).cfg mml localized lz text monster_gfx spc $(OBJ_FILES)
	@mkdir -p $(TEMP_LZ_DIR) $(ROM_DIR)
	$(LINK) $(LINKFLAGS) -o "" -C $< $(OBJ_FILES)
	$(PYTHON) tools/encode_cutscene.py $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(TEMP_LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	$(LINK) $(LINKFLAGS) --dbgfile $(@:sfc=dbg) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES) $(CUTSCENE_LZ).o
	@rm -rf $(TEMP_LZ_DIR)
	$(PYTHON) tools/fix_checksum.py $@

# make all versions
all:
	$(MAKE) LANG=en
	$(MAKE) LANG=jp

# -----------------------------------------------------------------------------
# rules to build event script only
# -----------------------------------------------------------------------------

EVENT_DIR := $(BUILD_DIR)/event
EVENT_OBJ := $(OBJ_DIR)/event.o
EVENT_BIN := $(EVENT_DIR)/ff6-event.bin

event: $(EVENT_BIN)

$(EVENT_BIN): cfg/ff6-event.cfg $(EVENT_OBJ)
	@mkdir -p $(EVENT_DIR)
	$(LINK) $(LINKFLAGS) -o $@ -C $< $(EVENT_OBJ)

# -----------------------------------------------------------------------------
# assembly module rules
# -----------------------------------------------------------------------------

# generate rules for making each assembly module
define MAKE_MODULE
$$(OBJ_DIR)/$1.o: src/$1/$1_main.asm
	@mkdir -p $$(OBJ_DIR) $$(DEP_DIR) $$(LST_DIR)
	$$(ASM) $$(ASMFLAGS) --create-dep $$(DEP_DIR)/$1.d -l $$(LST_DIR)/$1.lst $$< -o $$@
endef

# this rule applies to all modules and the spc code
$(foreach M, $(MODULES) spc, $(eval $(call MAKE_MODULE,$(M))))

# -----------------------------------------------------------------------------
# localized asset rules
# -----------------------------------------------------------------------------

# Localized files in the assets directory have ".en" or ".jp" inserted
# before the actual file extension. These files will be copied into the
# corresponding build directory with the language extension removed.

# find all files in the assets directory with the selected language extension
ASSETS_LOCALIZED := $(shell find assets -type f -name "*.$(LANG).*" 2>/dev/null)

# skip text files since they are all localized
ASSETS_LOCALIZED := $(filter-out assets/text/%,$(ASSETS_LOCALIZED))

# remove the language extension and copy to the build directory
BUILD_LOCALIZED := $(addprefix $(BUILD_DIR)/,$(subst .$(LANG).,.,$(ASSETS_LOCALIZED)))

localized: $(BUILD_LOCALIZED)

# Create a combined list paired together by a vertical bar (e.g., "build/en/assets/file.4bpp|assets/file.en.4bpp")
PAIRED_LIST := $(join $(BUILD_LOCALIZED), $(addprefix |,$(ASSETS_LOCALIZED)))

# Template to generate the hardcoded one-to-one rule
# $(1) = Target Path, $(2) = Source Path
define MAKE_LOCALIZED_ASSET
$(1): $(2)
	@mkdir -p $$(dir $$@)
	cp $$< $$@
endef

# Loop through the paired items, split them at the '|', and evaluate the rule
$(foreach pair,$(PAIRED_LIST),\
  $(eval\
	  $(call MAKE_LOCALIZED_ASSET,\
		  $(word 1,$(subst |, ,$(pair))),\
			$(word 2,$(subst |, ,$(pair)))\
		)\
	)\
)

# -----------------------------------------------------------------------------
# lz compression rules
# -----------------------------------------------------------------------------

# load lz-compressed file list
LZ_LIST := $(shell cat assets/lz_list.txt)

# find non-localized lz files in the assets directory and change to the build directory
LZ_ASSET_LIST := $(foreach pat,$(LZ_LIST),\
  $(shell find assets -type f -path "$(pat)" -not -name "*.*$(suffix $(pat))"))
LZ_ASSET_LIST := $(addprefix $(BUILD_DIR)/,$(LZ_ASSET_LIST))

# find localized lz files in the build directory (possibly not created yet)
LZ_BUILD_LIST := $(filter $(addprefix $(BUILD_DIR)/,$(subst *,%,$(LZ_LIST))),$(BUILD_LOCALIZED))

# add the lz extension
LZ_FILES := $(addsuffix .lz,$(LZ_ASSET_LIST) $(LZ_BUILD_LIST))

lz: $(LZ_FILES)

# compress non-localized files in the assets directory
$(BUILD_DIR)/%.lz: %
	@mkdir -p $(dir $@)
	$(PYTHON) tools/ff6_lzss.py $< $@

# compress localized files in the build directory
$(BUILD_DIR)/%.lz: $(BUILD_DIR)/%
	@mkdir -p $(dir $@)
	$(PYTHON) tools/ff6_lzss.py $< $@

# -----------------------------------------------------------------------------
# spc code rules
# -----------------------------------------------------------------------------

# the SPC program
SPC_PRG := $(BIN_DIR)/spc.bin

$(SPC_PRG): cfg/ff6-spc.cfg $(OBJ_DIR)/spc.o
	@mkdir -p $(dir $@)
	$(LINK) $(LINKFLAGS) -o $@ -C $< $(OBJ_DIR)/spc.o

spc: $(SPC_PRG)

# -----------------------------------------------------------------------------
# text rules
# -----------------------------------------------------------------------------

# list of all text files
TEXT_ASSETS := $(wildcard assets/text/*.$(LANG).txt)
TEXT_BIN := $(basename $(basename $(TEXT_ASSETS)))
TEXT_BIN := $(addsuffix .bin,$(addprefix $(BUILD_DIR)/,$(TEXT_BIN)))

MENU_TEXT_SRC := src/menu/menu_text.$(LANG).inc
MENU_TEXT_BUILD := $(BUILD_DIR)/assets/text/menu_text.inc

text: $(TEXT_BIN) $(MENU_TEXT_BUILD)

$(BUILD_DIR)/assets/text/%.bin: assets/text/%.$(LANG).txt
	@mkdir -p $(dir $@)
	$(PYTHON) tools/encode_text.py $< $@

dte:
	$(PYTHON) tools/fix_dlg.py dte en

# rules for encoding menu text
$(MENU_TEXT_BUILD): $(MENU_TEXT_SRC)
	@mkdir -p $(dir $@)
	$(PYTHON) tools/encode_menu_text.py $< $@

# -----------------------------------------------------------------------------
# song/sfx script rules
# -----------------------------------------------------------------------------

# rules for converting mml files to asm
SONG_MML_FILES := $(wildcard assets/mml/song/*.mml)
SONG_ASM_FILES := $(addprefix $(BUILD_DIR)/, $(SONG_MML_FILES:mml=asm))

SFX_MML_FILES := $(wildcard assets/mml/sfx/*.mml)
SFX_ASM_FILES := $(addprefix $(BUILD_DIR)/, $(SFX_MML_FILES:mml=asm))

mml: $(SONG_ASM_FILES) $(SFX_ASM_FILES)

$(BUILD_DIR)/assets/mml/song/%.asm: assets/mml/song/%.mml
	@mkdir -p $(dir $@)
	$(PYTHON) tools/encode_mml.py $< $@

$(BUILD_DIR)/assets/mml/sfx/%.asm: assets/mml/sfx/%.mml
	@mkdir -p $(dir $@)
	$(PYTHON) tools/encode_sfx.py $< $@

# -----------------------------------------------------------------------------
# brr/wav sample rules
# -----------------------------------------------------------------------------

# rules for converting extracted BRR files to WAV files
BRR_FILES := $(wildcard assets/sound/sample_brr/*.brr) \
	$(wildcard assets/sound/sfx_brr/*.brr)
WAV_FILES := $(BRR_FILES:brr=wav)
wav: $(WAV_FILES)

%.wav: %.brr
	$(PYTHON) tools/brr.py $< $@

# -----------------------------------------------------------------------------
# monster graphics rules
# -----------------------------------------------------------------------------

# find non-localized graphics files in the assets directory and change to the build directory
MONSTER_GFX_ASSET_LIST := $(shell find assets/gfx/monster_gfx -type f -name "*.[34]bpp" -not -name "*.*.[34]bpp" 2>/dev/null)
MONSTER_GFX_ASSET_LIST := $(addprefix $(BUILD_DIR)/,$(MONSTER_GFX_ASSET_LIST))

# find localized monster graphics files in the build directory (possibly not created yet)
MONSTER_GFX_BUILD_LIST := $(filter $(BUILD_DIR)/assets/gfx/monster_gfx/%,$(BUILD_LOCALIZED))

# rules for trimming monster graphics
MONSTER_GFX_FILES := $(MONSTER_GFX_ASSET_LIST) $(MONSTER_GFX_BUILD_LIST)
MONSTER_COMPRESSED_FILES := $(addsuffix .stc,$(MONSTER_GFX_FILES))
MONSTER_STENCIL_FILES := $(MONSTER_COMPRESSED_FILES:stc=stn)

monster_gfx: $(MONSTER_COMPRESSED_FILES) $(MONSTER_STENCIL_FILES)

# rule for non-localized files
$(BUILD_DIR)/%.stc: %
	@mkdir -p $(dir $@)
	$(PYTHON) tools/monster_stencil.py $< $@

# rule for localized files
$(BUILD_DIR)/%.stc: $(BUILD_DIR)/%
	@mkdir -p $(dir $@)
	$(PYTHON) tools/monster_stencil.py $< $@

# -----------------------------------------------------------------------------
# general python script rules
# -----------------------------------------------------------------------------

# install submodules
setup:
	git submodule update --init --recursive --remote --force

# rip data from ROMs
rip: setup
	$(PYTHON) tools/extract_assets.py

# shuffle the RNG table
rng:
	$(PYTHON) tools/shuffle_rng.py assets/data/field/rng_tbl.bin

# -----------------------------------------------------------------------------
# repo cleaning rules
# -----------------------------------------------------------------------------

clean:
	rm -rf build

distclean: clean
	rm -rf assets/data
	rm -rf assets/gfx
	rm -rf assets/sound
	$(PYTHON) tools/clean_text.py

# -----------------------------------------------------------------------------
# assembler dependencies
# -----------------------------------------------------------------------------

-include $(shell find $(DEP_DIR) -name "*.d" 2>/dev/null)
