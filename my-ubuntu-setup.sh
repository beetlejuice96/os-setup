#!/bin/bash

# Ubuntu automatic setup script
# This script installs: Docker, Docker Compose, VSCode, Google Chrome, Git, NVM, DBeaver, Postman, Discord

# Exit on error
set -e

echo "Starting Ubuntu setup script..."
echo "Updating package lists..."
sudo apt update

# Install Git
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    sudo apt install -y git
else
    echo "Git is already installed"
fi

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed"
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed"
fi

# Install VSCode
if ! command -v code &> /dev/null; then
    echo "Installing Visual Studio Code..."
    sudo apt install -y wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
else
    echo "Visual Studio Code is already installed"
fi

# Warp Terminal installation removed as it will be installed separately

# Install Google Chrome
if ! command -v google-chrome &> /dev/null; then
    echo "Installing Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
else
    echo "Google Chrome is already installed"
fi

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    
    # Set up NVM in the current shell
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest LTS version of Node.js
    echo "Installing Node.js LTS version..."
    nvm install --lts
else
    echo "NVM is already installed"
    # Set up NVM in the current shell anyway to use it
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install DBeaver
if ! command -v dbeaver &> /dev/null; then
    echo "Installing DBeaver..."
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
    sudo apt update
    sudo apt install -y dbeaver-ce
else
    echo "DBeaver is already installed"
fi

# Install Discord
if ! command -v discord &> /dev/null; then
    echo "Installing Discord..."
    wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    sudo apt install -y ./discord.deb
    rm discord.deb
else
    echo "Discord is already installed"
fi

# Install Postman
if ! command -v postman &> /dev/null; then
    echo "Installing Postman..."
    wget -O postman.tar.gz https://dl.pstmn.io/download/latest/linux64
    sudo tar -xzf postman.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/bin/postman
    rm postman.tar.gz
    
    # Create desktop entry for Postman
    cat > ~/.local/share/applications/postman.desktop << EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Comment=Postman API Client
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL
else
    echo "Postman is already installed"
fi

# Install Slack
if ! command -v slack &> /dev/null; then
    echo "Installing Slack..."
    sudo apt install -y wget
    wget -qO - https://slack.com/keys/public.key | sudo apt-key add -
    echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" | sudo tee /etc/apt/sources.list.d/slack.list
    sudo apt update
    sudo apt install -y slack-desktop
else
    echo "Slack is already installed"
fi

echo "Installation complete!"
echo "Note: You may need to log out and log back in for some changes to take effect."
echo "To start using Docker without sudo, run: newgrp docker"
echo "To start using NVM, restart your terminal or run: source ~/.bashrc"
