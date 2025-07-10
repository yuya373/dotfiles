#!/usr/bin/env bash
set -e

if [ ! -d $HOME/.goenv ]; then
    git clone https://github.com/go-nv/goenv.git $HOME/.goenv
fi
