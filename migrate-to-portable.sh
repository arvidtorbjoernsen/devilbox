#!/bin/bash

# Devilbox Volume Migration Script
# This script helps migrate data from Docker named volumes to local directories
# for a portable Devilbox setup

set -e

DEVILBOX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$DEVILBOX_DIR/data"

echo "=== Devilbox Volume Migration Script ==="
echo "This script will migrate your database data from Docker volumes to local directories"
echo "for a portable setup."
echo ""

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose not found. Please install docker-compose first."
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "Error: This script must be run from the devilbox root directory"
    exit 1
fi

# Function to migrate a volume
migrate_volume() {
    local volume_name="$1"
    local target_dir="$2"
    local temp_container="migrate_temp"
    
    echo "Checking volume: $volume_name"
    
    # Check if volume exists
    if ! docker volume ls -q | grep -q "^${volume_name}$"; then
        echo "  Volume $volume_name not found, skipping..."
        return 0
    fi
    
    echo "  Migrating $volume_name to $target_dir..."
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"
    
    # Create temporary container to copy data
    docker run --rm -d --name "$temp_container" -v "$volume_name":/source -v "$target_dir":/target alpine:latest tail -f /dev/null
    
    # Copy data from volume to local directory
    docker exec "$temp_container" sh -c "cp -a /source/. /target/ 2>/dev/null || true"
    
    # Clean up
    docker stop "$temp_container" 2>/dev/null || true
    
    echo "  ✓ Migration completed for $volume_name"
}

echo "Starting migration process..."
echo ""

# Get current MySQL server version from .env
MYSQL_SERVER=$(grep "^MYSQL_SERVER=" .env 2>/dev/null | cut -d'=' -f2 || echo "mariadb-10.10")
PGSQL_SERVER=$(grep "^PGSQL_SERVER=" .env 2>/dev/null | cut -d'=' -f2 || echo "15-alpine")
MONGO_SERVER=$(grep "^MONGO_SERVER=" .env 2>/dev/null | cut -d'=' -f2 || echo "5.0")

echo "Detected versions:"
echo "  MySQL/MariaDB: $MYSQL_SERVER"
echo "  PostgreSQL: $PGSQL_SERVER"
echo "  MongoDB: $MONGO_SERVER"
echo ""

# Migrate volumes
migrate_volume "devilbox-$MYSQL_SERVER" "$DATA_DIR/mysql"
migrate_volume "devilbox-pgsql-$PGSQL_SERVER" "$DATA_DIR/postgres"
migrate_volume "devilbox-mongo-$MONGO_SERVER" "$DATA_DIR/mongo"
migrate_volume "devilbox-mail" "$DATA_DIR/mail"

echo ""
echo "=== Migration Complete ==="
echo ""
echo "Your database data has been migrated to local directories:"
echo "  MySQL: $DATA_DIR/mysql"
echo "  PostgreSQL: $DATA_DIR/postgres"
echo "  MongoDB: $DATA_DIR/mongo"
echo "  Mail: $DATA_DIR/mail"
echo ""
echo "Next steps:"
echo "1. Stop your current Devilbox: docker-compose stop"
echo "2. Remove old containers: docker-compose rm -f"
echo "3. Start with portable setup: docker-compose up -d"
echo ""
echo "Note: The old Docker volumes are still available if you need to revert."
echo "You can remove them manually with: docker volume rm [volume-name]"
