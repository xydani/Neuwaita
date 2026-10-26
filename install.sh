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

# true if $1 is a Neuwaita theme folder
isNeuwaita() {
    grep -qx 'Name=Neuwaita' "$1/index.theme" 2>/dev/null
}

if [ ! -f "${srcDir}/index.theme" ] || [ ! -d "${srcDir}/scalable" ]; then
    echo "Run this script from the Neuwaita folder, next to index.theme."
    exit 1
fi

if [ $system = 1 ] && [ "$(id -u)" != 0 ]; then
    echo "--system needs root, run: sudo $0 $*"
    exit 1
fi

if [ $system = 0 ] && [ "$(id -u)" = 0 ]; then
    echo "Running as root would install into root's home. Run without sudo, or add --system."
    exit 1
fi

if [ $system = 1 ] && [ $watch = 1 ]; then
    echo "--watch-accent needs write access to the theme, use it with a user install."
    exit 1
fi

if [ -e "$dest" ] && [ "$(readlink -f "$dest")" != "$srcDir" ] && ! isNeuwaita "$dest"; then
    echo "${dest} exists but is not a Neuwaita theme, not touching it."
    exit 1
fi

if [ $uninstall = 1 ]; then
    if [ $system = 0 ] && [ -f "$serviceFile" ]; then
        systemctl --user disable --now watchAccent.service || true
        rm -f "$serviceFile"
        systemctl --user daemon-reload
    fi
    if [ "$(readlink -f "$dest")" = "$srcDir" ]; then
        echo "${dest} points to this directory, remove it by hand if you really want to."
        exit 1
    fi
    rm -rf "$dest"
    echo "Removed ${dest}"
    exit 0
fi

if [ "$(readlink -f "$dest")" = "$srcDir" ]; then
    echo "${dest} already points to this directory, nothing to copy."
elif [ -d "${dest}/.git" ]; then
    echo "${dest} is a git clone. Update it with: git -C ${dest} pull"
    echo "To switch to the install script, move or delete that folder first."
    exit 1
else
    # keep the folder color chosen with change-color.sh
    folderColor="$(cat "${dest}/.folder-color" 2>/dev/null || true)"

    rm -rf "$dest"
    mkdir -p "$dest"
    cp -a --no-preserve=ownership "$srcDir"/{index.theme,scalable,Palette.txt,change-color.sh,watch-accent.sh,LICENSE} "$dest"/

    if [ -n "$folderColor" ]; then
        "${dest}/change-color.sh" "$folderColor" --no-reload || true
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

if [ $system = 0 ] && command -v gsettings >/dev/null \
    && [ "$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null)" != "'Neuwaita'" ]; then
    echo "Activate it with: gsettings set org.gnome.desktop.interface icon-theme 'Neuwaita'"
fi
echo "Log out and back in to see the new icons everywhere."
