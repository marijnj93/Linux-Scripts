#!/bin/bash

clear

echo "Het script start nu."
echo

echo "Voer de volledige locatie in waar de foto's staan die verplaatst moeten worden."
echo "Bijvoorbeeld: /home/marijn/f"
read -p "Directory: " directory
echo

echo "Voer een maandnummer in om foto’s in de geselecteerde folder naar een (nieuw te creëren) folder te verplaatsen "
echo "die ouder zijn dan de gekozen optie."
echo "Bijvoorbeeld: 09"
read -p "Maandnummer: " monthnumber
echo

echo "Voer de locatie van de folder in, waar de foto's verplaatst naar moeten worden als die ouder zijn dan de gekozen optie."
echo "Bijvoorbeeld: /home/marijn/Pictures/hierin"
read -p "Folder: " newdirectory
echo

cd $directory

search=$(find . -name "*.jpg" -o -name "*.png" )
for f in $search
do
	echo "Bestandsnaam: $f"
	filemonth=$(date -r $f +%m)

	if [ $filemonth \< $monthnumber ]; then
		echo "Het bestand is ouder dan de ingevoerde maand en zal verplaatst worden."
		echo
		mkdir -p "$newdirectory"
		cp "$f" "$newdirectory"
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
echo "De inhoud van de nieuwe folder is:"
ls -ha "$newdirectory"
