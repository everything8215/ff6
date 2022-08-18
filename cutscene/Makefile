
NAME = cutscene
OBJ_DIR = obj
TARGET = $(OBJ_DIR)/$(NAME)_$(VERSION_EXT).o

SRC_MAIN = $(NAME).asm
SRC_FILES = $(wildcard *.asm)
INC_DIR = ../include
INC_FILES = $(wildcard $(INC_DIR)/*.inc)
DATA_FILES = $(wildcard data/*)
GFX_FILES = $(wildcard gfx/*)
TEXT_FILES = $(wildcard text/*)

.PHONY: all clean

# disable default suffix rules
.SUFFIXES:

all: $(TARGET)

clean:
	$(RM) -r $(OBJ_DIR) data gfx text

$(TARGET): $(SRC_FILES) $(INC_FILES) $(DATA_FILES) $(GFX_FILES) $(TEXT_FILES)
	@mkdir -p $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -I $(INC_DIR) -l $(@:o=lst) $(SRC_MAIN) -o $@
