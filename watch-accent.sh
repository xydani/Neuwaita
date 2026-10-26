#!/bin/bash

themeDir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

gsettings monitor org.gnome.desktop.interface accent-color | while read -r line; do
    color=$(echo "$line" | cut -d':' -f2 | tr -d " '")
    "${themeDir}/change-color.sh" $color
done
