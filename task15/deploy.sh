#!/bin/bash

# Extract app files from tar artifact
tar -xvzf nodejs-app.tar.gz

SCRIPT_NAME="server"

# Start Node.js server via PM2 or Restart if already running
if pm2 list | grep -q "$SCRIPT_NAME"; then
    echo "$SCRIPT_NAME.js is already running. Restarting..."
    pm2 restart "$SCRIPT_NAME.js"
else
    echo "$SCRIPT_NAME.js is not running. Starting..."
    pm2 start "$SCRIPT_NAME.js"
fi