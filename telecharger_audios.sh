#!/bin/bash
# Télécharge les 114 sourates récitées par Mahmoud Khalil Al-Husary
# et les numérote 001.mp3 ... 114.mp3 dans assets/audio/
#
# Usage : lance ce script depuis la racine de ton projet Flutter
#   chmod +x telecharger_audios.sh
#   ./telecharger_audios.sh

set -e

DEST="assets/audio"
BASE_URL="https://download.quranicaudio.com/quran/mahmood_khaleel_al-husaree"

mkdir -p "$DEST"

echo "Téléchargement des 114 sourates vers $DEST ..."
echo ""

for i in $(seq -w 1 114); do
  # seq -w donne déjà 001, 002 ... mais uniquement sur 3 chiffres si la
  # borne max fait 3 chiffres, ce qui est le cas ici (114).
  DEST_FILE="$DEST/$i.mp3"

  if [ -f "$DEST_FILE" ]; then
    echo "[$i/114] déjà présent, ignoré"
    continue
  fi

  URL="$BASE_URL/$i.mp3"
  echo "[$i/114] téléchargement depuis $URL"

  # -f : échoue proprement si 404 au lieu d'écrire une page d'erreur HTML
  # --retry : réessaie automatiquement en cas de coupure réseau
  if curl -f -L --retry 5 --retry-delay 3 -o "$DEST_FILE" "$URL"; then
    echo "[$i/114] OK ($(du -h "$DEST_FILE" | cut -f1))"
  else
    echo "[$i/114] ÉCHEC — vérifie ta connexion et relance le script (il reprendra où il s'est arrêté)"
    rm -f "$DEST_FILE"
  fi
done

echo ""
echo "Terminé. Fichiers présents :"
ls "$DEST" | wc -l
echo "/ 114 attendus"
