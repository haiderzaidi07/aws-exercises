#!/bin/bash

# Extract app files from tar artifact
tar -xvzf nodejs-app.tar.gz

# Start Node.js server via PM2
pm2 start server.js