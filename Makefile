
# the assembler
ASM = ca65
ASMFLAGS = -I include
VERSION_EXT =

# the linker
LINK = ld65
LINKFLAGS =

# lzss encoder for cutscene program
LZSS = python3 tools/encode_cutscene.py

# script to fix the SNES checksum
FIX_CHECKSUM = python3 tools/fix_checksum.py

# list of ROM versions
VERSIONS = ff6-jp ff6-en ff6-en1
ROM_DIR = rom
ROMS = $(foreach V, $(VERSIONS), $(ROM_DIR)/$(V).sfc)

.PHONY: all rip clean distclean mml spc $(VERSIONS) $(MODULES)

# disable default suffix rules
.SUFFIXES:

# make all versions
all: $(VERSIONS)

# rip data from ROMs
rip:
	python3 tools/extract_ff6.py

mml:
	python3 tools/encode_mml.py

spc: include/spc/ff6-spc.dat

clean:
	$(RM) -r $(ROM_DIR) obj

distclean: clean
	$(RM) -r assets include/assets include/script

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

# list of all include files
INC_FILES = $(wildcard include/*.inc) $(wildcard include/assets/*.inc)

# target-specific object filenames
OBJ_FILES_JP = $(foreach M,$(MODULES),obj/$(M)_jp.o)
OBJ_FILES_EN = $(foreach M,$(MODULES),obj/$(M)_en.o)
OBJ_FILES_EN1 = $(foreach M,$(MODULES),obj/$(M)_en1.o)

# list of modules
MODULES = assets field menu btlgfx battle sound cutscene world

# generate rules for making each module
define MAKE_MODULE
$1_SRC := $$(wildcard src/$1/*.asm)
obj/$1_%.o: $$($1_SRC) $$(INC_FILES)
	@mkdir -p obj
	$$(ASM) $$(ASMFLAGS) -l $$(@:o=lst) src/$1/main.asm -o $$@
endef

$(foreach M, $(MODULES), $(eval $(call MAKE_MODULE,$(M))))

# temporary compressed cutscene program file
LZ_DIR = temp_lz
CUTSCENE_LZ = $(LZ_DIR)/cutscene.lz
CUTSCENE_LZ_ASM = $(LZ_DIR)/cutscene_lz.asm

obj/spc.o: src/spc/main.asm
	@mkdir -p obj
	$(ASM) $(ASMFLAGS) -l $(@:o=lst) $< -o $@

include/spc/ff6-spc.dat: cfg/ff6-spc.cfg obj/spc.o
	@mkdir -p include/spc
	$(LINK) $(LINKFLAGS) -o $@ -C $< obj/spc.o

# rules for making ROM files
# run linker twice: 1st for the cutscene program, 2nd for the ROM itself
$(FF6_JP_PATH): cfg/ff6-jp.cfg spc mml $(OBJ_FILES_JP)
	@mkdir -p $(LZ_DIR)
	$(LINK) $(LINKFLAGS) -o "" -C $< $(OBJ_FILES_JP)
	${LZSS} $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	@mkdir -p rom
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_JP) $(CUTSCENE_LZ).o
	@$(RM) -rf $(LZ_DIR)
	$(FIX_CHECKSUM) $@

$(FF6_EN_PATH): cfg/ff6-en.cfg spc mml $(OBJ_FILES_EN)
	@mkdir -p $(LZ_DIR)
	$(LINK) $(LINKFLAGS) -o "" -C $< $(OBJ_FILES_EN)
	${LZSS} $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	@mkdir -p rom
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_EN) $(CUTSCENE_LZ).o
	@$(RM) -rf $(LZ_DIR)
	$(FIX_CHECKSUM) $@

$(FF6_EN1_PATH): cfg/ff6-en.cfg spc mml $(OBJ_FILES_EN1)
	@mkdir -p $(LZ_DIR)
	$(LINK) $(LINKFLAGS) -o "" -C $< $(OBJ_FILES_EN1)
	${LZSS} $(CUTSCENE_LZ:lz=bin) $(CUTSCENE_LZ)
	@printf '.segment "cutscene_lz"\n.incbin "cutscene.lz"' > $(CUTSCENE_LZ_ASM)
	$(ASM) --bin-include-dir $(LZ_DIR) $(CUTSCENE_LZ_ASM) -o $(CUTSCENE_LZ).o
	@mkdir -p rom
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_EN1) $(CUTSCENE_LZ).o
	@$(RM) -rf $(LZ_DIR)
	$(FIX_CHECKSUM) $@
