#!/bin/bash

tar -xvzf nodejs-app.tar.gz

pm2 start server.js