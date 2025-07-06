#!/bin/bash
set -e

mkdir -p ~/.config/yaskkserv2

# ~/Dropbox/skk/dict/ 以下のファイルを指定
files=(
    ~/Dropbox/skk/dict/SKK-JISYO.L
    ~/Dropbox/skk/dict/SKK-JISYO.geo
    ~/Dropbox/skk/dict/SKK-JISYO.jinmei
    ~/Dropbox/skk/dict/SKK-JISYO.propernoun
    ~/Dropbox/skk/dict/SKK-JISYO.station
    ~/Dropbox/skk/dict/SKK-JISYO.zipcode
)

yaskkserv2_make_dictionary --dictionary-filename="${HOME}/.config/yaskkserv2/dict.yaskkserv2" "${files[@]}"
