#!/bin/bash

themeDir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
colorName=$1

if [ -z "${colorName}" ]; then
	echo "Usage: $0 <color|reset>  (see Palette.txt)"
	exit 1
fi

if [ "${colorName}" = 'reset' ]; then
	cp "${themeDir}/scalable/places/folder-grey.svg" "${themeDir}/scalable/places/folder.svg"
else
    if grep -wq "${colorName}" "${themeDir}/Palette.txt" ; then
        color=$(awk -v vawk="${1}" '$1==vawk{print $3}' "${themeDir}/Palette.txt")
        colorDark=$(awk -v vawk="${1}-dark" '$1==vawk{print $3}' "${themeDir}/Palette.txt")

        sed -i "64s/#[a-f0-9]\{6\}/#${color::-2}/g" "${themeDir}/scalable/places/folder.svg"
        sed -i "59s/#[a-f0-9]\{6\}/#${colorDark::-2}/g" "${themeDir}/scalable/places/folder.svg"
    else
        echo "Invalid argument ..."
        exit 1
    fi
fi

gsettings set org.gnome.desktop.interface icon-theme 'hicolor'
gsettings set org.gnome.desktop.interface icon-theme 'Neuwaita'
