#!/bin/sh

echo "Checking if EFS is mounted..."
df -h 

# Start Nginx in foreground
nginx -g "daemon off;"