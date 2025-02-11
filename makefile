
#OPENSCAD = openscad
OPENSCAD = /home/dab/Applications/OpenSCAD-2025.01.20.ai22731-x86_64_a4c72bcfe5c1c89d509dc8e83641dfac.AppImage

SRC_DIR = scad_files
BUILD_DIR = stl_files

SCAD_FILES = $(wildcard $(SRC_DIR)/*.scad)
STL_FILES = $(patsubst $(SRC_DIR)/%.scad,$(BUILD_DIR)/%.stl,$(SCAD_FILES))

all: $(STL_FILES)

$(BUILD_DIR)/%.stl: $(SRC_DIR)/%.scad
	@mkdir -p $(BUILD_DIR)
	$(OPENSCAD) -o $@ $<

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
