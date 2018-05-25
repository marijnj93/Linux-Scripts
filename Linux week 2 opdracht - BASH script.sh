#!/bin/bash

clear

echo "Het script start nu."
echo

echo "Voer de volledige locatie in waar de foto's staan die verplaatst moeten worden."
echo "Bijvoorbeeld: /home/marijn/Pictures"
read -p "Directory: " directory
echo

echo "Voer de locatie van de folder in, waar de foto's verplaatst naar moeten worden als die ouder zijn dan de gekozen optie."
echo "Bijvoorbeeld: /home/marijn/Pictures_sorted"
read -p "Folder: " newdirectory
echo

echo "Voer een maandnummer in om foto’s in de geselecteerde folder naar een (nieuw te creëren) folder te verplaatsen "
echo "die ouder zijn dan de gekozen optie."
echo "Bijvoorbeeld: 09"
read -p "Maandnummer: " monthnumber
echo

cd $directory

search=$(find . -name "*.jpg" -o -name "*.png" )
for f in $search
do
	echo "Bestandsnaam: $f"
	filemonth=$(date -r $f +%m)
	fileyear=$(date -r $f +%Y)
	filenameofthemonth=$(date -r $f +%B)
	if [ $filemonth \< $monthnumber ]; then
		echo "Het bestand is ouder dan de ingevoerde maand en zal verplaatst worden."
		echo
		fullpath=$newdirectory"/"$fileyear"/"$filenameofthemonth
		mkdir -p $fullpath
		mv "$f" $fullpath
	fi

	if [ $filemonth \= $monthnumber ]; then
		echo "Het bestand is NIET ouder en NIET nieuwer dan de ingevoerde maand het zal dus NIET verplaatst worden."
		echo
	fi
	if [ $filemonth \> $monthnumber ]; then
		echo "Het bestand is nieuwer dan de ingevoerde maand en zal NIET verplaatst worden."
		echo
	fi
done

# Laat de inhoud van de niewe folder zien.
echo "De inhoud van de nieuwe folder is:"
tree "$newdirectory"
