
OPENSCAD = openscad
#OPENSCAD = /home/dab/Applications/OpenSCAD-2025.01.20.ai22731-x86_64_a4c72bcfe5c1c89d509dc8e83641dfac.AppImage
ARGS := --backend=manifold --imgsize=1200,900 --camera=0,0,0,55,0,25,180 --viewall --autocenter

SRC_DIR = scad_files
BUILD_DIR = stl_files
DOC_DIR = doc_files

SCAD_FILES = $(wildcard $(SRC_DIR)/*.scad)
STL_FILES = $(patsubst $(SRC_DIR)/%.scad,$(BUILD_DIR)/%.stl,$(SCAD_FILES))
DOC_FILES = $(wildcard $(DOC_DIR)/*.png)

all: $(STL_FILES) $(DOC_FILES)

$(BUILD_DIR)/%.stl: $(SRC_DIR)/%.scad
	@mkdir -p $(BUILD_DIR)
	$(OPENSCAD) $(ARGS) -o $@ $<

$(DOC_DIR)/%.png : $(DOC_DIR)/%.scad
#%.png : $(DOC_DIR)/%.scad
	$(OPENSCAD) $(ARGS) -o $@ $<
#	$(OPENSCAD) $(ARGS) -o $@ $< > $(LOG) 2>&1

inspectoer.zip: $(STL_FILES)
	#echo($(STL_FILES))
	zip -j $@ $^

clean:
	rm -rf $(BUILD_DIR)
	rm -f inspector.zip

.PHONY: all clean
