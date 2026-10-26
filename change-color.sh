#!/bin/bash
# Usage: change-color.sh <color|reset> [--no-reload]   (see Palette.txt)

themeDir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
colorName=$1

if [ -z "${colorName}" ]; then
	echo "Usage: $0 <color|reset> [--no-reload]  (see Palette.txt)"
	exit 1
fi

if [ "${colorName}" = 'reset' ]; then
	cp "${themeDir}/scalable/places/folder-grey.svg" "${themeDir}/scalable/places/folder.svg"
	echo "reset" > "${themeDir}/.folder-color"
else
    color=$(awk -v vawk="${colorName}" '$1==vawk{print $3}' "${themeDir}/Palette.txt")
    colorDark=$(awk -v vawk="${colorName}-dark" '$1==vawk{print $3}' "${themeDir}/Palette.txt")

    if [ -n "${color}" ] && [ -n "${colorDark}" ]; then
        sed -i "64s/#[a-f0-9]\{6\}/#${color::-2}/g" "${themeDir}/scalable/places/folder.svg"
        sed -i "59s/#[a-f0-9]\{6\}/#${colorDark::-2}/g" "${themeDir}/scalable/places/folder.svg"
        # remembered so that install.sh can apply it again after an update
        echo "${colorName}" > "${themeDir}/.folder-color"
    else
        echo "Invalid argument ..."
        exit 1
    fi
fi

if [ "$2" != '--no-reload' ]; then
    # switch away and back to the current theme (Neuwaita or Neuwaita-Dark) to reload it
    currentTheme=$(gsettings get org.gnome.desktop.interface icon-theme)
    gsettings set org.gnome.desktop.interface icon-theme 'hicolor'
    gsettings set org.gnome.desktop.interface icon-theme "${currentTheme//\'/}"
fi
