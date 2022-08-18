
# exported variables used by module makefiles
export ASM = ca65
export ASMFLAGS =
export VERSION_EXT

# the linker
LINK = ld65
LINKFLAGS =

# list of ROM versions
VERSIONS = ff6-jp ff6-en ff6-en1
ROM_DIR = rom
ROMS = $(foreach V, $(VERSIONS), $(ROM_DIR)/$(V).sfc)

# list of modules
MODULES = field menu btlgfx battle sound cutscene world

.PHONY: all rip encode-jp encode-en clean $(VERSIONS) $(MODULES)

# disable default suffix rules
.SUFFIXES:

# make all versions
all: $(VERSIONS)

# rip data from ROMs
rip:
	node tools/decode-ff6.js

# encode-jp: ff6-jp-data.json
# 	node tools/encode-ff6.js ff6-jp-data.json
#
# encode-en: ff6-en-data.json
# 	node tools/encode-ff6.js ff6-en-data.json

# clean module subdirectories
MODULES_CLEAN = $(foreach M, $(MODULES), $(M)_clean)

%_clean:
	$(MAKE) -C $* clean

clean: $(MODULES_CLEAN)
	$(RM) -r $(ROM_DIR)

# ROM filenames
FF6_JP_PATH = $(ROM_DIR)/ff6-jp.sfc
FF6_EN_PATH = $(ROM_DIR)/ff6-en.sfc
FF6_EN1_PATH = $(ROM_DIR)/ff6-en1.sfc

ff6-jp: $(FF6_JP_PATH)
ff6-en: $(FF6_EN_PATH)
ff6-en1: $(FF6_EN1_PATH)

# set up target-specific variables
ff6-jp: VERSION_EXT = jp
ff6-jp: ASMFLAGS += -D ROM_VERSION=0

ff6-en: VERSION_EXT = en
ff6-en: ASMFLAGS += -D LANG_EN=1 -D ROM_VERSION=0

ff6-en1: VERSION_EXT = en1
ff6-en1: ASMFLAGS += -D LANG_EN=1 -D ROM_VERSION=1

# target-specific object filenames
OBJ_FILES_JP = $(foreach M, $(MODULES), $(M)/obj/$(M)_jp.o)
OBJ_FILES_EN = $(foreach M, $(MODULES), $(M)/obj/$(M)_en.o)
OBJ_FILES_EN1 = $(foreach M, $(MODULES), $(M)/obj/$(M)_en1.o)

# rules for making ROM files
$(FF6_JP_PATH): ff6-jp.lnk encode-jp $(OBJ_FILES_JP)
	@mkdir -p rom
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_JP)
	node tools/calc-checksum.js $@

$(FF6_EN_PATH): ff6-en.lnk encode-en $(OBJ_FILES_EN)
	@mkdir -p rom
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_EN)
	node tools/calc-checksum.js $@

$(FF6_EN1_PATH): ff6-en.lnk encode-en $(OBJ_FILES_EN1)
	@mkdir -p rom
	$(LINK) $(LINKFLAGS) -m $(@:sfc=map) -o $@ -C $< $(OBJ_FILES_EN1)
	node tools/calc-checksum.js $@

# run sub-make to create object files for each module
$(OBJ_FILES_JP): $(MODULES)
$(OBJ_FILES_EN): $(MODULES)
$(OBJ_FILES_EN1): $(MODULES)

# rules for making modules in subdirectories
define MAKE_MODULE
$1/obj/$1_%.o:
	$$(MAKE) -C $1
endef

$(foreach M, $(MODULES), $(eval $(call MAKE_MODULE,$(M))))
