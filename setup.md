# Hyprland setup

## Setup

```bash
sudo pacman -S noctalia
```

Copy the noctalia settings files and place it where yours is located, make a backup if needed.

Path: ~/.local/state/noctalia

Files:
- settings.toml
- state.toml

Copy the script for the sddm pixie theme from *.config/noctalia* and paste into your own *.config/noctalia* folder

## Display Manager

### Noctalia Greeter

See the oficial site for the installation and configuration

### SDDM with Pixie theme

**Install dependencies:** `yay -S sddm tomlq --needed`

Follow their step by step: https://github.com/xCaptaiN09/pixie-sddm

Make the avatar and background be own by the User:
```bash
sudo chown "$USER" /usr/share/sddm/themes/pixie/assets/{avatar,background}.jpg
```


## OCR

**Copy Text from images:**

```bash
sudo pacman -S tesseract tesseract-data-eng tesseract-data-por
```

*The script is in hypr/scripts/ocr.sh*


## Hyprland Plugins

### Gloview

```bash
hyprpm add https://github.com/fedsfarm/gloview
hyprpm enable gloview
```
