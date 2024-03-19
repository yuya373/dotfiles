#!/bin/bash
set -eu

pushd ~/dev

gh repo clone casouri/tree-sitter-module
./batch.sh

rm -rf ~/.emacs.d/tree-sitter/*
mv ~/dev/tree-sitter-module/dist/* ~/.emacs.d/tree-sitter/

popd
