#!/bin/bash

ps x -rc -opcpu,command| head -n 11 | tail -n 10
