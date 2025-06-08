#!/bin/bash
set -e # Exit on any error

# --- MUST CHANGE: UPDATE THIS WITH YOUR GITHUB REPO URL ---
GIT_REPO_URL="https://github.com/your-username/multinodes-marketplace.git"
PROJECT_DIR="/var/www/multinodes"

echo "--- Starting One-Time Server Setup ---"

# 1. INSTALL SYSTEM DEPENDENCIES
echo "--> Installing Nginx, Node.js, Git, Certbot..."
sudo apt-get update
sudo apt-get install -y nginx nodejs npm git certbot python3-certbot-nginx

# 2. INSTALL PM2 (PROCESS MANAGER)
echo "--> Installing PM2..."
sudo npm install -g pm2

# 3. CLONE YOUR PROJECT FROM GITHUB
echo "--> Cloning project from Git..."
sudo git clone "$GIT_REPO_URL" "$PROJECT_DIR"

# 4. SET UP NGINX
echo "--> Configuring Nginx..."
# Link the config file from your project to Nginx's configuration directory
sudo ln -s "$PROJECT_DIR/nginx/multinodes.conf" /etc/nginx/sites-available/multinodes
sudo ln -s /etc/nginx/sites-available/multinodes /etc/nginx/sites-enabled/
# Remove the default nginx config
sudo rm /etc/nginx/sites-enabled/default

echo "--> Testing Nginx configuration..."
sudo nginx -t
sudo systemctl reload nginx

# 5. MAKE SCRIPTS EXECUTABLE
echo "--> Making scripts executable..."
sudo chmod +x $PROJECT_DIR/scripts/*.sh

# 6. RUN INITIAL DEPLOYMENT (installs packages and starts app)
echo "--> Running initial deployment..."
cd "$PROJECT_DIR"
sudo ./scripts/deploy.sh

# 7. SET UP PM2 TO START ON SYSTEM BOOT
echo "--> Setting up PM2 startup script..."
echo "!!! IMPORTANT ACTION REQUIRED !!!"
echo "The next command will output another command. You MUST copy and run that command yourself!"
sudo pm2 startup systemd

echo "--- Server Setup Complete! ---"