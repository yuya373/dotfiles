#!/bin/bash

for file in ~/Dropbox/skk/dict/*;  do
    ./yaskkserv_make_dictionary $file "${file}.yaskkserv"
done


