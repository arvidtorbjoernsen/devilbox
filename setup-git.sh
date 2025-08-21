#!/bin/bash

# Git Setup Script for Portable Devilbox
# This script helps you set up git remotes for maintaining your portable setup

set -e

echo "=== Devilbox Git Setup Script ==="
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check current remotes
echo "Current git remotes:"
git remote -v
echo ""

# Ask user for their fork URL
echo "To set up your portable Devilbox with proper git workflow:"
echo ""
echo "1. First, fork the repository on GitHub:"
echo "   Go to: https://github.com/cytopia/devilbox"
echo "   Click 'Fork' to create your own copy"
echo ""
read -p "Enter your fork URL (e.g., https://github.com/YOUR_USERNAME/devilbox.git): " FORK_URL

if [ -z "$FORK_URL" ]; then
    echo "No URL provided. Exiting."
    exit 1
fi

echo ""
echo "Setting up git remotes..."

# Rename origin to upstream
if git remote get-url origin | grep -q "cytopia/devilbox"; then
    echo "✓ Renaming official repo from 'origin' to 'upstream'"
    git remote rename origin upstream
else
    echo "! Origin is not the official devilbox repo"
fi

# Add user's fork as origin
echo "✓ Adding your fork as 'origin'"
git remote add origin "$FORK_URL"

# Show updated remotes
echo ""
echo "Updated git remotes:"
git remote -v
echo ""

# Commit the portable changes
echo "Committing your portable setup changes..."
git add .
git commit -m "feat: make devilbox portable with local data storage

- Store all database data in local ./data/ directories
- Added HOST_PATH_DATABASE_DATADIR configuration variable
- Updated .gitignore to exclude database files
- Created migration script and documentation
- Enables full portability across machines" || echo "No changes to commit"

echo ""
echo "Pushing to your fork..."
git push -u origin master

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Your git workflow is now configured:"
echo "  upstream = Official Devilbox repository (cytopia/devilbox)"
echo "  origin   = Your fork ($FORK_URL)"
echo ""
echo "To stay updated with official changes:"
echo "  git fetch upstream"
echo "  git merge upstream/master"
echo "  git push origin master"
echo ""
echo "Your portable setup is now tracked in your repository!"
