#!/bin/sh
set -e
sudo pkg update
sudo pkg install -y nvidia-driver nvidia-xconfig nvidia-settings
sudo sysrc kld_list+="nvidia-modeset"
sudo sysrc linux_enable="YES"
sudo sysrc dbus_enable="YES"
sudo nvidia-xconfig
sudo reboot
