#!/bin/bash

# Add Node.js 22.x repo (system-wide)
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

# Install Node.js and npm
sudo apt install -y nodejs

# Install PM2
npm install pm2@latest -g