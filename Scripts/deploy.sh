#!/bin/bash
set -e

echo "🚀 Deploying Multinodes Marketplace..."

# 1. Go to the backend directory
echo "--> Navigating to backend directory..."
cd backend

# 2. Install/update dependencies
echo "--> Installing npm dependencies..."
npm install --production

# 3. Go back to the root project directory
cd ..

# 4. Restart the application with PM2 using the ecosystem file
echo "--> Restarting server with PM2..."
pm2 startOrRestart backend/ecosystem.config.js

echo "✅ Deployment Complete!"
pm2 status