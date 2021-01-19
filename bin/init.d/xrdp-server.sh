#!/bin/bash


echo "Installing xrdp-server..."

echo "➜ Updating APT repositories..."
sudo apt -y update

echo
echo "➜ Installing xrdp xorgxrdp xserver-xorg-{video,input}-all..."
sudo apt install -y \
    xrdp \
    xorgxrdp \
    xserver-xorg-video-all \
    xserver-xorg-input-all \
    || { echo "Failed to install necessary packages."; exit 128; }


echo
echo -n "➜ Updating /etc/xrdp/xrdp.init... "
sed -i.orig '/new_cursors/ s!true!false!' /etc/xrdp/xrdp.ini
echo "OK"

echo -n "➜ Updating /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla... "
cat <<'__XRDP__' | sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla >/dev/null
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes

[Allow Wifi Scan]
Identity=unix-user:*
Action=org.freedesktop.NetworkManager.wifi.scan;org.freedesktop.NetworkManager.enable-disable-wifi;org.freedesktop.NetworkManager.settings.modify.own;org.freedesktop.NetworkManager.settings.modify.syste>
ResultAny=yes
ResultInactive=yes
ResultActive=yes

[Allow Package Management all Users]
Identity=unix-user:*
Action=org.debian.apt.*;io.snapcraft.*;org.freedesktop.packagekit.*;com.ubuntu.update-notifier.*
ResultAny=no
ResultInactive=no
ResultActive=yes
__XRDP__
echo "OK"

echo -n "➜ Updating \${HOME}/.xsessionrc... "
cat <<'__XSESSIONRC__' >~/.xsessionrc
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
__XSESSIONRC__
echo "OK"

echo
echo "➜ Restarting xrdp..."
systemctl enable xrdp
systemctl restart xrdp

echo
echo "🎉 xrdp installation is complete!!"
echo
