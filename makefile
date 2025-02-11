# Variablen
OPENSCAD = openscad  # DOS-Style-Pfad für OpenSCAD
SRCDIR = scad_files
BUILDDIR = stl_files

# Finde alle SCAD-Dateien im Quellverzeichnis

SCAD_FILES := $(wildcard $(SRCDIR)/*.scad)

# Generiere die entsprechenden STL-Dateinamen
STL_FILES = $(patsubst $(SRCDIR)\%.scad,$(BUILDDIR)\%.stl,$(SCAD_FILES))

# Standardziel
all: $(STL_FILES)

# Regel zum Erstellen der STL-Dateien aus den SCAD-Dateien
$(BUILDDIR)\%.stl: $(SRCDIR)\%.scad
               @echo 'Building file: $*.scad'
               #@if not exist $(BUILDDIR) mkdir $(BUILDDIR)
               @echo 'Invoking: openscad'
               $(OPENSCAD) -o $@ $<   

# Aufräumen
clean:
               @if exist "$(BUILDDIR)" rmdir /S /Q "$(BUILDDIR)"

.PHONY: all clean
