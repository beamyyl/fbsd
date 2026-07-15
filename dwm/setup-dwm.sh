#!/bin/sh
set -e
sudo pkg install -y libXft libXinerama gmake gcc llvm pkgconf sndio xorg
git clone https://github.com/beamyyl/dwm
rm -rf dwm/setupdwm.sh
rm -rf dwm/README.md
rm -rf dwm/dwm/config.mk
rm -rf dwm/st/config.mk
rm -rf dwm/slstatus/config.mk
# the 'p' stands for patched btw
cp pdwm/config.mk dwm/dwm/config.mk
cp pst/config.mk dwm/st/config.mk
cp pslstatus/config.mk dwm/slstatus/config.mk
cd dwm/dwm/
sudo gmake clean install
cd ../st
sudo gmake clean install
cd ../slstatus
sudo gmake clean install
