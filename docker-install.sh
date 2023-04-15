#!/bin/bash

# Update repositories and install required packages
echo "Y" | sudo apt update
echo "Y" | sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository to APT sources
echo "Y" | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Update package list with Docker packages
echo "Y" | apt-cache policy docker-ce

# Install Docker
echo "Y" | sudo apt install -y docker-ce

# Add current user to Docker group
echo "dev" | sudo -S usermod -aG docker ${USER}

# Switch to current user
su - ${USER}

# Add another user to Docker group
echo "dev" | sudo -S usermod -aG docker username
