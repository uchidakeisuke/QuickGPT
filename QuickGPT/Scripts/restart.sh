#!/bin/bash

# Path to your application
APP_PATH="/Applications/QuickGPT.app"

# Get the PID of the application
PID=$(pgrep -f "$APP_PATH/Contents/MacOS/QuickGPT")

# Terminate the application
kill -9 $PID

# Wait a moment
sleep 1

# Relaunch the application
open "$APP_PATH"
