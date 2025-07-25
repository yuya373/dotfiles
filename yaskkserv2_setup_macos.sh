#!/bin/bash

# Copy plist to LaunchAgents
cp ~/dotfiles/com.github.wachikun.yaskkserv2.plist ~/Library/LaunchAgents/

# Load the service
launchctl load ~/Library/LaunchAgents/com.github.wachikun.yaskkserv2.plist

echo "yaskkserv2 service installed and started"
echo "To check status: launchctl list | grep yaskkserv2"
echo "To stop: launchctl unload ~/Library/LaunchAgents/com.github.wachikun.yaskkserv2.plist"
echo "To restart: launchctl unload ~/Library/LaunchAgents/com.github.wachikun.yaskkserv2.plist && launchctl load ~/Library/LaunchAgents/com.github.wachikun.yaskkserv2.plist"
