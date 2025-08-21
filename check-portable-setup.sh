#!/bin/bash

# Portable Devilbox Status Check
# Verifies that your portable setup is correctly configured

echo "🔍 Portable Devilbox Setup Verification"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: Run this script from the devilbox root directory"
    exit 1
fi

echo "📂 Directory Structure:"
echo "----------------------"

# Check data directories
for dir in mysql postgres redis mongo mail; do
    if [ -d "data/$dir" ]; then
        echo "✅ data/$dir/ exists"
        if [ -f "data/$dir/.keepme" ]; then
            echo "   ├── .keepme file present"
        else
            echo "   ⚠️  .keepme file missing"
        fi
    else
        echo "❌ data/$dir/ missing"
    fi
done

echo ""
echo "📋 Configuration Files:"
echo "----------------------"

# Check essential files
files=(
    "env-portable-template:✅ Environment template"
    "setup-portable-env.sh:✅ Environment setup script"
    "migrate-to-portable.sh:✅ Migration script"
    "setup-git.sh:✅ Git setup script"
    "PORTABLE_SETUP.md:✅ Technical documentation"
    "GIT_SETUP_GUIDE.md:✅ Git workflow guide" 
    "ENV_MANAGEMENT.md:✅ Environment management guide"
    "README_PORTABLE.md:✅ Complete setup overview"
)

for item in "${files[@]}"; do
    file=$(echo "$item" | cut -d':' -f1)
    desc=$(echo "$item" | cut -d':' -f2)
    
    if [ -f "$file" ]; then
        echo "$desc"
        if [ -x "$file" ]; then
            echo "   ├── Executable permissions: ✅"
        fi
    else
        echo "❌ $file missing"
    fi
done

echo ""
echo "🐳 Docker Configuration:"
echo "------------------------"

# Check docker-compose.yml modifications
if grep -q "HOST_PATH_DATABASE_DATADIR" docker-compose.yml; then
    echo "✅ Docker-compose uses portable volume mounts"
else
    echo "❌ Docker-compose not updated for portable volumes"
fi

# Check .env file
if [ -f ".env" ]; then
    echo "✅ .env file exists"
    if grep -q "HOST_PATH_DATABASE_DATADIR" .env; then
        echo "   ├── Contains portable configuration: ✅"
    else
        echo "   ⚠️  Missing portable configuration"
    fi
else
    echo "⚠️  .env file not found (create from template)"
fi

echo ""
echo "📝 Git Configuration:"
echo "--------------------"

# Check git status
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✅ Git repository initialized"
    
    # Check remotes
    if git remote | grep -q "upstream"; then
        echo "✅ Upstream remote configured"
    else
        echo "⚠️  Upstream remote not set (run setup-git.sh)"
    fi
    
    # Check if .env is ignored
    if git check-ignore .env > /dev/null 2>&1; then
        echo "✅ .env file properly ignored"
    else
        echo "⚠️  .env file not ignored by git"
    fi
else
    echo "❌ Not a git repository"
fi

echo ""
echo "🎯 Next Steps:"
echo "-------------"

if [ ! -f ".env" ]; then
    echo "1. Set up environment: ./setup-portable-env.sh"
fi

if ! git remote | grep -q "upstream"; then
    echo "2. Set up git workflow: ./setup-git.sh"
fi

echo "3. Start Devilbox: docker-compose up -d"
echo "4. Access projects: http://project-name.local"

echo ""
echo "✨ Your Devilbox is ready for portable use!"
