#!/bin/sh
sudo pkg install -y pipewire wireplumber dbus

sudo sysrc dbus_enable="YES"
sudo service dbus start

RUNTIME_CMD='mkdir -p /tmp/runtime-$(whoami) && export XDG_RUNTIME_DIR=/tmp/runtime-$(whoami)'

for profile in "$HOME/.profile" "$HOME/.bash_profile" "$HOME/.zprofile"; do
    if [ -f "$profile" ] || [ "$profile" = "$HOME/.profile" ]; then
        if ! grep -q "XDG_RUNTIME_DIR" "$profile" 2>/dev/null; then
            echo "" >> "$profile"
            echo "# Setup XDG_RUNTIME_DIR for Wayland/Pipewire" >> "$profile"
            echo "$RUNTIME_CMD" >> "$profile"
        fi
    fi
done

mkdir -p /tmp/runtime-$(whoami)
export XDG_RUNTIME_DIR=/tmp/runtime-$(whoami)

rm -f "$HOME/.config/autostart/pipewire.desktop"
rm -f "$HOME/.config/autostart/pipewire-pulse.desktop"
rm -f "$HOME/.config/autostart/wireplumber.desktop"
mkdir -p "$HOME/.config/pipewire/pipewire.conf.d"

cat << 'EOF' > "$HOME/.config/pipewire/pipewire.conf.d/10-autostart.conf"
context.exec = [
    { path = "/usr/local/bin/wireplumber" args = "" }
    { path = "/usr/local/bin/pipewire-pulse" args = "" }
]
EOF

sudo mkdir -p /usr/local/etc/xdg/autostart
sudo tee /usr/local/etc/xdg/autostart/pipewire.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=PipeWire
Comment=Start PipeWire with automated sub-services
Exec=sh -c "pkill -x pipewire; /usr/local/bin/pipewire"
Terminal=false
Type=Application
NoDisplay=true
EOF
