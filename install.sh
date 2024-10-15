#!/bin/bash

# default val
NODE_NAME=""
PUBLIC_WHOOK=""
PRIVATE_WHOOK=""
PANEL=""
KEY=""
NODE_ID=$(openssl rand -hex 4)  # this generates a random ID

# Function to display help
usage() {
    echo "Usage: $0 --node-name <node_name> --public-whook <public_whook> --private-whook <private_whook> --panel <panel_url> --key <panel_key>"
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --node-name) NODE_NAME="$2"; shift ;;
        --public-whook) PUBLIC_WHOOK="$2"; shift ;;
        --private-whook) PRIVATE_WHOOK="$2"; shift ;;
        --panel) PANEL="$2"; shift ;;
        --key) KEY="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

# Check if all required parameters are provided
if [ -z "$NODE_NAME" ] || [ -z "$PUBLIC_WHOOK" ] || [ -z "$PRIVATE_WHOOK" || [ -z "$PANEL" || [ -z "$KEY" ]; then
    echo "Error: All fields are required... or Radar will not work"
    usage
fi

# Create radar directory if it doesn't exist
sudo mkdir -p /etc/sryden
cd /etc/sryden

# Get strategies
git clone https://github.com/radarpowered/strategies

# Generate the config.json file with the provided parameters
sudo bash -c "cat > /etc/sryden/config.json << EOL
{
  \"public_whook\": \"$PUBLIC_WHOOK\",
  \"private_whook\": \"$PRIVATE_WHOOK\",
  \"panel\": \"$PANEL\",
  \"key\": \"$KEY\",
  \"node_name\": \"$NODE_NAME\"
}
EOL"

echo "Config file has been created."

# Rest of the installation process
echo "Installing Radar v3.0.0..."
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update
sudo apt-get install -y nodejs
sudo curl -o /etc/sryden/radar.js https://raw.githubusercontent.com/radarpowered/src/refs/heads/main/index.js
cd /etc/sryden
sudo npm init -y
sudo npm install dockerode fs-extra axios path glob crypto pm2 toml adm-zip child_process -g
sudo npm install dockerode fs-extra axios path glob crypto pm2 toml adm-zip child_process
sudo pm2 start /etc/sryden/radar.js --name "radar"
sudo pm2 save
sudo pm2 startup
echo "Done! Radar has been set up. It has also been set up to automatically start on boot, and Radar will automatically keep itself up via pm2. You should not need to do anything from now on."
