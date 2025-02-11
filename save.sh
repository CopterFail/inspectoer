# Überprüfen, ob die Ordner existieren
#if [ ! -d "$SOURCE_DIR" ] || [ ! -d "$DEST_DIR" ]; then
#    echo "Einer der angegebenen Ordner existiert nicht."
#    exit 1
#fi

# Kopieren der *.scad Dateien
#cp "$SOURCE_DIR"/*.scad "$DEST_DIR"
cp *.scad ~/OneDrive/3ddrucker/cad/inspectoer/inspectoer

# Git-Repository initialisieren, falls es noch nicht existiert
#if [ ! -d .git ]; then
#    git init
#fi

# Alle *.scad Dateien zum Staging-Bereich hinzufügen
git add *.scad

# Commit erstellen
git commit -m "automatic update .scad files"

#todo:
#git config --global user.name "Ihr Name"
#git config --global user.email "ihre.email@example.com"
#git config --global credential.helper store
#git push origin master
#git remote add origin <repository-url>
