#!/bin/bash

/usr/local/sbin/yaskkserv --max-connection=32 \
	--google-japanese-input-timeout=1.0 \
	--google-japanese-input=notfound-input-suggest \
	--google-suggest \
	~/Dropbox/skk/dict/SKK-JISYO.*.yaskkserv

