#!/bin/bash

# Install Java
sudo apt update -y
sudo apt install -y openjdk-21-jre-headless

# Add Jenkins repo and install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins

sudo systemctl start jenkins


# Add Node.js 22.x repo (system-wide)
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

# Install Node.js and npm
sudo apt install -y nodejs