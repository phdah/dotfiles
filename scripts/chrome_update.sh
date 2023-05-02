#!/bin/bash

# Install/upgrade Chrome
wget -P $HOME https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i $HOME/google-chrome-stable_current_amd64.deb
apt-get install -f --yes
rm $HOME/google-chrome-stable_current_amd64.deb
