#!/bin/bash

# Portable Devilbox Environment Setup Script
# Creates a .env file from the portable template with user customizations

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_FILE="$SCRIPT_DIR/env-portable-template"
ENV_FILE="$SCRIPT_DIR/.env"

echo "=== Portable Devilbox Environment Setup ==="
echo ""

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file 'env-portable-template' not found!"
    exit 1
fi

# Check if .env already exists
if [ -f "$ENV_FILE" ]; then
    echo "⚠️  .env file already exists!"
    echo ""
    read -p "Do you want to overwrite it? (y/N): " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    echo ""
fi

echo "Setting up your portable Devilbox environment..."
echo ""

# Copy template
cp "$TEMPLATE_FILE" "$ENV_FILE"
echo "✓ Created .env from portable template"

# Get user's UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "✓ Detected your user ID: $USER_ID"
echo "✓ Detected your group ID: $GROUP_ID"

# Update UID/GID in .env file
sed -i.bak "s/NEW_UID=1000/NEW_UID=$USER_ID/" "$ENV_FILE"
sed -i.bak "s/NEW_GID=1000/NEW_GID=$GROUP_ID/" "$ENV_FILE"
rm "$ENV_FILE.bak"

echo "✓ Updated .env with your user/group IDs"

# Ask for timezone
echo ""
echo "Current timezone setting: CET"
read -p "Enter your timezone (press Enter to keep CET): " user_timezone
if [ ! -z "$user_timezone" ]; then
    sed -i.bak "s/TIMEZONE=CET/TIMEZONE=$user_timezone/" "$ENV_FILE"
    rm "$ENV_FILE.bak"
    echo "✓ Updated timezone to: $user_timezone"
fi

# Ask about TLD suffix
echo ""
echo "Current TLD suffix: local (projects will be available as project.local)"
read -p "Enter your preferred TLD suffix (press Enter to keep 'local'): " user_tld
if [ ! -z "$user_tld" ]; then
    sed -i.bak "s/TLD_SUFFIX=local/TLD_SUFFIX=$user_tld/" "$ENV_FILE"
    rm "$ENV_FILE.bak"
    echo "✓ Updated TLD suffix to: $user_tld"
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Your portable Devilbox is ready:"
echo "  • Configuration: .env"
echo "  • Database storage: ./data/ directories"
echo "  • User ID: $USER_ID"
echo "  • Group ID: $GROUP_ID"
echo "  • Timezone: $(grep "^TIMEZONE=" "$ENV_FILE" | cut -d'=' -f2)"
echo "  • TLD Suffix: $(grep "^TLD_SUFFIX=" "$ENV_FILE" | cut -d'=' -f2)"
echo ""
echo "To start Devilbox:"
echo "  docker-compose up -d"
echo ""
echo "To access projects:"
echo "  http://project-name.$(grep "^TLD_SUFFIX=" "$ENV_FILE" | cut -d'=' -f2)"
echo ""
echo "Your setup is now portable and can be moved to any machine!"
