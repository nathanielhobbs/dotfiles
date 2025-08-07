#!/usr/bin/env bash
# install.sh — Hyprland environment setup for Fedora 42

set -euo pipefail
cd "$(dirname "$0")"

echo "[*] Updating system and enabling RPM Fusion..."
sudo dnf upgrade -y
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "[*] Enabling extra repos for missing tools..."
sudo dnf copr enable atim/starship -y

echo "[*] Installing Hyprland and environment tools..."
sudo dnf install -y hyprland kitty waybar wofi dunst \
  wl-clipboard swappy grim slurp swaylock swaybg \
  brightnessctl pavucontrol blueman thunar \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  qt5ct qt6ct lxappearance kvantum \
  zsh starship ripgrep fd-find unzip git curl \
  gnome-keyring lxpolkit alacritty


echo "[*] Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
if [ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]; then
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d JetBrainsMono
  mv JetBrainsMono/*.ttf .
  rm -r JetBrainsMono JetBrainsMono.zip
  fc-cache -fv
fi
cd -

echo "[*] Installing Anyrun dependencies..."
sudo dnf install -y cargo rustc meson gcc-c++ libxkbcommon-devel \
  cairo-devel pango-devel gtk3-devel gdk-pixbuf2-devel

echo "[*] Cloning and building Anyrun..."
if [ ! -d "$HOME/.local/src/anyrun" ]; then
  mkdir -p ~/.local/src
  git clone https://github.com/Kirottu/anyrun ~/.local/src/anyrun
  cd ~/.local/src/anyrun
  cargo build --release
  mkdir -p ~/.local/bin
  cp target/release/anyrun ~/.local/bin/
fi
cd -

echo "[*] Copying dotfiles..."
mkdir -p ~/.config
cp -r bash ~/.config/
cp -r hyprland ~/.config/
cp -r waybar ~/.config/
cp -r anyrun ~/.config/

echo "[*] Setting up starship prompt..."
if ! grep -q 'starship init' ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

echo "[*] Making sure your power menu script is executable..."
chmod +x ~/.config/waybar/scripts/power_menu.sh

echo "[*] Creating Hyprland auto-config script for single-monitor setups..."
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprland-autoconfig.sh <<'EOF'
#!/usr/bin/env bash

CONFIG="$HOME/.config/hyprland/hyprland.conf"
MARKER="$CONFIG.single_monitor_applied"

if [[ -f "$MARKER" ]]; then exit 0; fi

MONITOR_COUNT=$(hyprctl monitors | grep -c "Monitor")

if [[ "$MONITOR_COUNT" -eq 1 ]]; then
    echo "[*] Detected single monitor setup. Updating hyprland.conf..."

    # Remove specific monitor references
    sed -i '/^monitor=DP-1/d' "$CONFIG"
    sed -i '/^monitor=HDMI-A-1/d' "$CONFIG"
    sed -i '/^workspace=.*monitor:DP-1/d' "$CONFIG"
    sed -i '/^workspace=.*monitor:HDMI-A-1/d' "$CONFIG"

    # Add fallback monitor and workspace assignments
    echo "monitor=,preferred,auto,1" >> "$CONFIG"
    for i in {1..8}; do
      echo "workspace=$i,monitor:" >> "$CONFIG"
    done

    touch "$MARKER"
fi
EOF

chmod +x ~/.config/hypr/hyprland-autoconfig.sh

# Ensure exec-once line exists
if ! grep -q 'hyprland-autoconfig.sh' ~/.config/hyprland/hyprland.conf; then
  echo 'exec-once = ~/.config/hypr/hyprland-autoconfig.sh' >> ~/.config/hyprland/hyprland.conf
fi

echo "[✓] Installation complete. Reboot or log into Hyprland to apply your environment."

