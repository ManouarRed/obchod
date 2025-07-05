#!/bin/bash

 - # Redirect all output to output.txt                                                     │
 │    4    - exec > output.txt 2>&1

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting deployment script..."

# --- NVM and Node.js Setup ---
echo "Installing NVM and Node.js v20..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20
nvm use 20
nvm alias default 20
node -v
npm -v

# --- Backend Deployment ---
echo "Navigating to backend directory..."
cd back

echo "Installing backend dependencies..."
npm install --production

echo "Starting backend server..."
# Assuming your hosting environment will manage process persistence
# and that the 'start' script in package.json will correctly bind to the host's assigned port.
npm start &

# --- Frontend Deployment ---
echo "Navigating to frontend directory..."
cd ../front

echo "Installing frontend dependencies..."
npm install

echo "Building frontend for production..."
# VITE_API_BASE_URL is passed as an environment variable from your hosting
npm run build

echo "Deployment complete!"
