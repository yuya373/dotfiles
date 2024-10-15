#!/bin/bash
set -eu

mkdir -p ~/dev
pushd ~/dev

gh repo clone casouri/tree-sitter-module
pushd ~/dev/tree-sitter-module
./batch.sh

rm -rf ~/.emacs.d/tree-sitter/*
mkdir -p ~/.emacs.d/tree-sitter/
mv ~/dev/tree-sitter-module/dist/* ~/.emacs.d/tree-sitter/

popd
