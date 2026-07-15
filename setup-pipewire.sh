#!/bin/sh
set -e
sudo pkg install -y pipewire wireplumber pipewire-spa-oss pavucontrol dbus
sudo sysrc dbus_enable="YES"
if ! pgrep -x dbus-daemon >/dev/null; then
    sudo service dbus start
fi

RUNTIME_CMD='export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"; mkdir -p "$XDG_RUNTIME_DIR"; chmod 700 "$XDG_RUNTIME_DIR"'

for profile in "$HOME/.profile" "$HOME/.bash_profile" "$HOME/.zprofile"; do
    if [ -f "$profile" ] || [ "$profile" = "$HOME/.profile" ]; then
        if ! grep -q "XDG_RUNTIME_DIR" "$profile" 2>/dev/null; then
            {
                echo "$RUNTIME_CMD"
            } >> "$profile"
        fi
    fi
done

export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

rm -f "$HOME/.config/autostart/pipewire.desktop"
rm -f "$HOME/.config/autostart/pipewire-pulse.desktop"
rm -f "$HOME/.config/autostart/wireplumber.desktop"
mkdir -p "$HOME/.config/pipewire/pipewire.conf.d"

cat > "$HOME/.config/pipewire/pipewire.conf.d/10-autostart.conf" <<'EOF'
context.exec = [
    { path = "/usr/local/bin/wireplumber" args = "" }
    { path = "/usr/local/bin/pipewire-pulse" args = "" }
]
EOF

sudo mkdir -p /usr/local/etc/xdg/autostart
sudo tee /usr/local/etc/xdg/autostart/pipewire.desktop >/dev/null <<'EOF'
[Desktop Entry]
Type=Application
Name=PipeWire
Comment=Start PipeWire
Exec=sh -c "pkill -x pipewire; exec /usr/local/bin/pipewire"
Terminal=false
NoDisplay=true
EOF
sudo rm /usr/local/etc/xdg/autostart/pulseaudio.desktop
echo
echo "Also make sure to set your mixer to volume 1, after setting the new one as default via 'mixer vol=1'"
echo "(to see them, run cat /dev/sndstat. To change them, run sudo sysctl hw.snd.default_unit=X, where X = the number after pcm)"
echo
