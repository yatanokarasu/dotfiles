#!/bin/bash


echo "Installing x-set-keys for emacs key-binding..."
echo "➜ Installing libglib2.0-dev and libx11-dev..."
sudo apt install -y \
    libglib2.0-dev \
    libx11-dev \
    || { echo "Failed to install necessary packages."; exit 128; }

_x_set_keys_repo=$(mktemp -d)
trap 'echo Deleting ${_x_set_keys_repo}...; rm -rf ${_x_set_keys_repo}' EXIT

echo
echo "➜ Downloading x-set-keys..."
git clone https://github.com/kawao/x-set-keys "${_x_set_keys_repo}"
# shellcheck disable=SC2164
pushd "${_x_set_keys_repo}" >/dev/null

echo
echo "➜ Building x-set-keys..."
make
sudo make install
echo
echo "➜ Post-installing..."
sudo chmod u+s /usr/local/bin/x-set-keys
cat <<'__KEYS__' | sudo tee -a /etc/x-set-keys.conf2 >/dev/null
#####################
# Basic mappings
#####################
C-i :: Tab
C-m :: Return
C-g :: Escape
C-h :: BackSpace
C-d :: Delete

#####################
# Cursor navigation
#####################
C-a :: Home
C-e :: End
C-b :: Left
C-f :: Right
C-p :: Up
C-n :: Down
A-v :: Page_Up
C-v :: Page_Down
# Go to previous word
A-b :: C-Left
# Go to next word
A-f :: C-Right

#####################
# Cut/Copy and Paste
#####################
# start/end selection
C-space :: $select
# Cut
A-w :: C-c
# Copy
C-w :: C-x
# Paste
C-y :: C-v
# Kill word
A-d :: S-C-Right C-x
# Kill line
C-k :: S-End C-x
# Kill word backward
A-BackSpace :: S-C-Left C-x

#####################
# Others
#####################
# Undo
C-slash :: C-z
# Find
C-s :: C-f
# Open file
C-x C-f :: C-o
# Save file
C-x C-s :: C-s
# Close file/tab
C-x k :: C-w
# Quit application
C-x C-c :: A-F4
# Send any key after Control+q
C-q C-q :: C-q

C-comma :: C-Home
C-period :: C-End
C-x C-w :: C-S-s
__KEYS__

cat <<'__PROFILE__' >>"${HOME}/.profile2"

if [ -z "${TMUX}" ]; then
    if [ -f /usr/local/bin/x-set-keys ] && pgrep -v x-set-keys >/dev/null; then
        /usr/local/bin/x-set-keys \
            --exclude-focus-class="Gnome-terminal" \
            /etc/x-set-keys.conf >/dev/null 2>&1 &
    fi
fi

__PROFILE__

popd >/dev/null || exit 255

echo
echo "🎉 x-set-keys installation is complete!!"
echo
