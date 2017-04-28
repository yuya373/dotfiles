#!/bin/bash

git clone git@github.com:wachikun/yaskkserv.git
cd yaskkserv
./configure --enable-google-japanese-input --enable-google-suggest --enable-systemd
make
sudo make install_hairy
