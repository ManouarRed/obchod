#!/bin/bash

# Redirect all output to output.log
exec > output.log 2>&1

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

# Create .env file from HostCreators environment variable
# This relies on you setting the ENV_FILE_CONTENT variable in your HostCreators panel.
echo "Creating .env file from ENV_FILE_CONTENT..."
echo "$ENV_FILE_CONTENT" > .env

echo "Installing backend dependencies..."
npm install --production

echo "Starting backend server..."
# IMPORTANT: This 'npm start &'-command only initiates the server.
# You MUST configure your HostCreators panel to ensure this Node.js process
# runs persistently and is restarted if it crashes or the server reboots.
# Consult HostCreators documentation on how to manage Node.js applications.
npm start &

# --- Frontend Deployment ---
echo "Navigating to frontend directory..."
cd ../front

echo "Installing frontend dependencies..."
npm install

echo "Building frontend for production..."
npm run build

echo "Copying built frontend files to the project root..."
# This assumes your web server is configured to serve static files from the project root.
# Remove existing built files from root to ensure clean deployment
rm -rf ../assets ../index.html ../*.js ../*.css # Add more patterns if other file types are generated at root

# Move contents of dist to the project root
mv dist/* ../

# Clean up the now empty dist directory
rmdir dist

echo "Deployment complete!"
