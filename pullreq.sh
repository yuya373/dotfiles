#!/bin/sh

hub pull-request -F PULLREQ_MSG

if [ $? -eq 1 ]; then
  rm -f ./PULLREQ_MSG
fi
