#!/bin/bash

LIST_FILE="prilog.txt"
INVALID_FILES=()

#konverzija u unix
sed -i 's/\r//' "$LIST_FILE"

echo "Kreiram fajlove..."
while IFS= read -r filename; do
    filename=$(echo "$filename" )
    touch "$filename"
done < "$LIST_FILE"

echo "Fajlovi kreirani!"
echo ""

echo "Validiram i sortiram fajlove..."
while IFS= read -r filename; do
    filename=$(echo "$filename")
    
    if [[ ! "$filename" =~ ^k[0-9a-f]{8}\.kod$ ]]; then
        echo "Nevalidan format: $filename"
        INVALID_FILES+=("$filename")
        continue
    fi

    E="${filename:5:1}"
    G="${filename:7:1}"

    G_DEC=$((16#$G))

    if (( G_DEC % 2 == 0 )); then
        DIR="${G}0/${E}0"
    else
        X_DEC=$((G_DEC - 1))
        X=$(printf '%x' $X_DEC)
        DIR="${X}0/${E}0"
    fi

    mkdir -p "$DIR"
    mv "$filename" "$DIR/"

done < "$LIST_FILE"

echo ""
echo "Nevalidni fajlovi:"
echo "============================="
for f in "${INVALID_FILES[@]}"; do
    echo "  - $f"
done
echo "============================="
echo "Ukupno nevalidnih: ${#INVALID_FILES[@]}"