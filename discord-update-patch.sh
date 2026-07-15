mkdir -p ~/.config/discord && cat << 'EOF' > ~/.config/discord/settings.json
{
  "IS_MAXIMIZED": false,
  "IS_MINIMIZED": false,
  "chromiumSwitches": {},
  "SKIP_HOST_UPDATE": true
}
EOF
chmod 444 ~/.config/discord/settings.json
