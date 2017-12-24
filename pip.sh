#!/usr/bin/bash

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

sudo pip install awscli
pip install --upgrade --user awsebcli
