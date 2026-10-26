<h1 align="center"> Neuwaita </h1>
<h4 align="center"> A different take on the Adwaita theme. </h4>

![Showcase](img/Showcase.png)

![Mimes](img/Mimes.png)

## Installation
### With git (recommended, easy to update)
User installation:
```sh
git clone --depth 1 https://github.com/xydani/Neuwaita.git ~/.local/share/icons/Neuwaita
```
System-wide installation:
```sh
sudo git clone --depth 1 https://github.com/xydani/Neuwaita.git /usr/share/icons/Neuwaita
```
Then select Neuwaita in GNOME Tweaks, or run:
```sh
gsettings set org.gnome.desktop.interface icon-theme 'Neuwaita'
```

### With the install script
Download or clone the repository anywhere and run:
```sh
./install.sh                  # current user (~/.local/share/icons/Neuwaita)
sudo ./install.sh --system    # system-wide (/usr/share/icons/Neuwaita)
./install.sh --watch-accent   # current user + folders follow the GNOME accent color
./install.sh --uninstall      # remove (add --system for the system-wide install)
```

## Updating
```sh
# git, user installation
git -C ~/.local/share/icons/Neuwaita pull
# git, system-wide installation
sudo git -C /usr/share/icons/Neuwaita pull
# install script: pull/download the new version and run ./install.sh again
```
If you changed the folder color with `change-color.sh`, run `git -C <install dir> checkout scalable/places/folder.svg` before pulling, then set the color again.
## Customize folder colors
Run change-color.sh to change the folder's colors, See [Palette.txt](Palette.txt) for available colors.
```sh
# Change the folders to blue
./change-color.sh blue
# Reset the color to grey
./change-color.sh reset
```
## Automatically change folder color when the accent color changes (GNOME)
Run `./install.sh --watch-accent`, or create `~/.config/systemd/user/watchAccent.service` yourself:

```desktop
[Unit]
Description=Neuwaita Accent Color Watcher
After=graphical-session.target
[Service]
ExecStart=%h/.local/share/icons/Neuwaita/watch-accent.sh
Restart=always
RestartSec=3
[Install]
WantedBy=graphical-session.target
```
and enable it:
```sh
systemctl --user daemon-reload
systemctl --user enable --now watchAccent.service
```
## Requesting new icons:
I understand you really want the icon but when making an icon request,
1. Check [scalable/apps](scalable/apps) if the icon you want is already present.
2. Please include the [actual name of the icon](#how-to-find-the-actual-name-of-the-icon) that you want to request.
3. Attach an image of the original icons for the icons that you are requesting.
## Using a fallback theme
You can tell system to use a fallback theme in case Neuwaita doesn't provide an icon for your app.
1. Navigate to Neuwaita installation directory (either `~/.local/share/icons/Neuwaita` or `/usr/share/icons/Neuwaita` depending on your installation)
2. Edit `Inherits` variable in index.theme

```desktop
[Icon Theme]
Name=Neuwaita
Comment=Neuwaita icon theme
Inherits=theme-name,theme-name-2
Example=folder
```
You can add as many inherits as you wish. In the example above, icons will be first searched in `Neuwaita` then `theme-name` and then lastly in `theme-name-2`.
### How to find the **Actual name** of the icon?
You're searching for the [reverse domain name notation](https://en.wikipedia.org/wiki/Reverse_domain_name_notation) (e.g `org.mozilla.firefox` for Firefox) it can be found in different ways:
- Icons are usually located inside `/usr/share/icons/hicolor/scalable/<Name of your app>`
- For System-wide Flatpaks the location is `/var/lib/flatpak/app/<Name of your app>` the name of the folder is the name of your icon
- For user Flatpaks the location is `~/.var/app/<Name of your app>`
  If you don't wanna find the icon in the files you can also look for the app in flathub go to the app you are requesting and scroll down to find installation instructions and there is a command you can copy as `flatpak install flathub <Actual name of your app>`
  
## Credits
Neuwaita was originally created by **RusticBard** (github.com/RusticBard/Neuwaita, no longer available).
This repository continues the project from the last public version (commit 112525b, March 2026) and adds new icons and fixes.

Licensed under the GNU GPL v3 (see [LICENSE](LICENSE)). The original repository also included a CC0 1.0 dedication ([LICENSE.md](LICENSE.md)), kept here for reference.
All app logos and trademarks belong to their respective owners.
