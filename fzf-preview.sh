#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
    >&2 echo "usage: $0 FILENAME[:LINENO][:IGNORED]"
    exit 1
fi

file=${1/#\~\//$HOME/}

type=$(file --brief --dereference --mime -- "$file")

if [[ $type =~ /directory ]]; then
    ls -l "$file"
else
    $ZPLUG_REPOS/junegunn/fzf/bin/fzf-preview.sh "$file"
fi

