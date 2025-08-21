# Git Setup Guide for Portable Devilbox

This guide explains how to maintain your customized Devilbox setup while staying updated with the official repository.

## Option 1: Fork + Upstream Remote (Recommended)

### Step 1: Fork the Repository
1. Go to https://github.com/cytopia/devilbox
2. Click "Fork" to create your own copy under your GitHub account
3. Note your fork URL: `https://github.com/YOUR_USERNAME/devilbox`

### Step 2: Update Git Remotes
```bash
# Rename current origin to upstream
git remote rename origin upstream

# Add your fork as the new origin
git remote add origin https://github.com/YOUR_USERNAME/devilbox.git

# Verify remotes
git remote -v
```

### Step 3: Push Your Changes
```bash
# Commit your portable changes
git add .
git commit -m "feat: make devilbox portable with local data storage"

# Push to your fork
git push -u origin master
```

### Step 4: Staying Updated
```bash
# Fetch latest changes from official repo
git fetch upstream

# Merge or rebase upstream changes
git merge upstream/master
# OR
git rebase upstream/master

# Push updates to your fork
git push origin master
```

## Option 2: Multiple Remotes

Keep the original setup but add your own remote:

```bash
# Add your personal repo as a second remote
git remote add personal https://github.com/YOUR_USERNAME/devilbox-portable.git

# Push your changes to personal repo
git push personal master

# Pull updates from official repo
git pull origin master

# Push updates to your repo
git push personal master
```

## Option 3: Branch Strategy

Create a custom branch for your modifications:

```bash
# Create and switch to custom branch
git checkout -b portable-setup

# Commit your changes
git add .
git commit -m "feat: make devilbox portable with local data storage"

# Push custom branch to your fork
git push origin portable-setup

# To update: switch to master, pull, merge into your branch
git checkout master
git pull origin master
git checkout portable-setup
git merge master
```

## Recommended Workflow

1. **Use Option 1** (Fork + Upstream) for the cleanest setup
2. **Create feature branches** for experimental changes
3. **Keep master in sync** with upstream
4. **Use pull requests** to merge your features

## Files to Track in Your Repository

Your customized `.env` file and portable setup should include:
- ✅ Modified `docker-compose.yml` (portable volumes)
- ✅ Custom `.env` configuration
- ✅ `PORTABLE_SETUP.md` documentation
- ✅ `migrate-to-portable.sh` script
- ✅ `data/` directory structure (with .keepme files)
- ❌ Database files (excluded by .gitignore)

## Switching Machines

With this setup, switching machines is simple:
1. Clone your fork: `git clone https://github.com/YOUR_USERNAME/devilbox.git`
2. Copy your `.env` file (or use the tracked one)
3. Run: `docker-compose up -d`
4. Your databases and configuration are ready!

## Handling Conflicts

When merging upstream changes that conflict with your portable setup:
1. Backup your `data/` directory
2. Resolve conflicts manually
3. Test the setup: `docker-compose up -d`
4. Restore data if needed
