#!/bin/bash

powershell.exe -Sta -NoProfile -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File c:/Users/yuya373/notify.ps1 "$1" "$2"
