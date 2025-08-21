# Complete Portable Devilbox Setup Guide

## .env File Strategy

The `.env` file contains your personal configuration and should NOT be committed to git (it's already in `.gitignore`). Here's how to handle it across machines:

### Files in Your Repository:
- ✅ `env-portable-template` - Your portable configuration template (tracked)
- ✅ `setup-portable-env.sh` - Interactive setup script (tracked)
- ❌ `.env` - Personal configuration (ignored by git)

### Setting Up on a New Machine:

#### Option 1: Use the Setup Script (Recommended)
```bash
git clone https://github.com/YOUR_USERNAME/devilbox.git
cd devilbox
./setup-portable-env.sh
```

#### Option 2: Manual Setup
```bash
git clone https://github.com/YOUR_USERNAME/devilbox.git
cd devilbox
cp env-portable-template .env
# Edit .env to customize NEW_UID, NEW_GID, TIMEZONE, etc.
docker-compose up -d
```

### Key Environment Variables for Portability:

```bash
# Your user/group IDs (auto-detected by script)
NEW_UID=1000
NEW_GID=1000

# Database storage path (for portability)
HOST_PATH_DATABASE_DATADIR=./data

# Your timezone
TIMEZONE=UTC

# Project domain suffix
TLD_SUFFIX=local
```

### What Gets Tracked vs Ignored:

**Tracked (in your repository):**
- `docker-compose.yml` (with portable volume mounts)
- `env-portable-template` (your configuration template)
- `setup-portable-env.sh` (setup automation)
- `data/` directory structure (with .keepme files)
- Documentation files

**Ignored (not tracked):**
- `.env` (personal configuration)
- `data/mysql/`, `data/postgres/`, etc. (database files)
- `log/` files
- `backups/` (your database backups)

### Machine-Specific Customizations:

Each machine might need different settings in `.env`:
- `NEW_UID`/`NEW_GID` (user permissions)
- `TIMEZONE` (local timezone)
- `LOCAL_LISTEN_ADDR` (network configuration)
- Port mappings if there are conflicts

### Updating Your Template:

When you make configuration changes you want to share across machines:

```bash
# Update your template with changes from .env
cp .env env-portable-template

# Remove machine-specific settings from template
# Edit env-portable-template to use generic values:
# NEW_UID=1000
# NEW_GID=1000
# TIMEZONE=UTC

# Commit the template
git add env-portable-template
git commit -m "update: portable configuration template"
git push origin master
```

## Complete Workflow Example:

### Initial Setup (First Machine):
```bash
# Your current setup is already done!
git add env-portable-template setup-portable-env.sh ENV_MANAGEMENT.md
git commit -m "feat: add portable environment management"
git push origin master
```

### New Machine Setup:
```bash
git clone https://github.com/YOUR_USERNAME/devilbox.git
cd devilbox
./setup-portable-env.sh
docker-compose up -d
```

This approach gives you the best of both worlds: tracked configuration templates and machine-specific customization!
