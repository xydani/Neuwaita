#!/bin/bash
# Installs Neuwaita by copying the theme files.
#   ./install.sh                 install for the current user (~/.local/share/icons)
#   sudo ./install.sh --system   install system-wide (/usr/share/icons)
#   ./install.sh --watch-accent  user install + systemd service that follows the GNOME accent color
#   ./install.sh --uninstall     remove the user install (add --system for the system-wide one)

set -e

srcDir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
destRoot="${HOME}/.local/share/icons"
system=0
watch=0
uninstall=0

for arg in "$@"; do
    case "$arg" in
        --system) system=1; destRoot="/usr/share/icons" ;;
        --watch-accent) watch=1 ;;
        --uninstall) uninstall=1 ;;
        -h|--help) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

dest="${destRoot}/Neuwaita"
serviceFile="${HOME}/.config/systemd/user/watchAccent.service"

if [ $system = 1 ] && [ $watch = 1 ]; then
    echo "--watch-accent needs write access to the theme, use it with a user install."
    exit 1
fi

if [ $uninstall = 1 ]; then
    if [ $system = 0 ] && [ -f "$serviceFile" ]; then
        systemctl --user disable --now watchAccent.service || true
        rm -f "$serviceFile"
        systemctl --user daemon-reload
    fi
    rm -rf "$dest"
    echo "Removed ${dest}"
    exit 0
fi

if [ "$(readlink -f "$dest")" = "$srcDir" ]; then
    echo "${dest} already points to this directory, nothing to copy."
else
    # keep the folder color chosen with change-color.sh
    savedFolder=""
    if [ -f "${dest}/scalable/places/folder.svg" ]; then
        savedFolder="$(mktemp)"
        cp "${dest}/scalable/places/folder.svg" "$savedFolder"
    fi

    rm -rf "$dest"
    mkdir -p "$dest"
    cp -a "$srcDir"/{index.theme,scalable,Palette.txt,change-color.sh,watch-accent.sh,LICENSE} "$dest"/

    if [ -n "$savedFolder" ]; then
        mv "$savedFolder" "${dest}/scalable/places/folder.svg"
        chmod 644 "${dest}/scalable/places/folder.svg"
    fi

    command -v gtk-update-icon-cache >/dev/null && gtk-update-icon-cache -qf "$dest" 2>/dev/null || true
    echo "Installed to ${dest}"
fi

if [ $watch = 1 ]; then
    mkdir -p "$(dirname "$serviceFile")"
    cat > "$serviceFile" <<EOF
[Unit]
Description=Neuwaita Accent Color Watcher
After=graphical-session.target
[Service]
ExecStart=${dest}/watch-accent.sh
Restart=always
RestartSec=3
[Install]
WantedBy=graphical-session.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable --now watchAccent.service
    echo "Accent color watcher enabled"
fi

if [ $system = 0 ] && command -v gsettings >/dev/null; then
    if [ "$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null)" = "'Neuwaita'" ]; then
        # switch theme back and forth so running apps reload the icons
        gsettings set org.gnome.desktop.interface icon-theme 'hicolor'
        gsettings set org.gnome.desktop.interface icon-theme 'Neuwaita'
        echo "Theme reloaded"
    else
        echo "Activate it with: gsettings set org.gnome.desktop.interface icon-theme 'Neuwaita'"
    fi
fi
