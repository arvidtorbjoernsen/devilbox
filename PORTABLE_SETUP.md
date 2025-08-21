# Devilbox Portable Database Setup

This Devilbox installation has been configured to store all database data in local directories instead of Docker named volumes, making it fully portable.

## Database Data Storage

All database data is now stored in the `data/` directory:

```
data/
├── www/           # Web projects (existing)
├── mysql/         # MySQL/MariaDB data files
├── postgres/      # PostgreSQL data files  
├── redis/         # Redis data files
├── mongo/         # MongoDB data files
└── mail/          # Mail catch-all data
```

## Benefits of This Setup

- **Portability**: You can move the entire Devilbox directory to another machine and all database data comes with it
- **Backup**: Easy to backup by simply copying the `data/` directory
- **Version Control**: You can exclude the `data/` directory from version control while keeping the configuration
- **Visibility**: Database files are directly accessible on your host system

## Configuration

The database data path is controlled by the `HOST_PATH_DATABASE_DATADIR` variable in `.env`:

```bash
HOST_PATH_DATABASE_DATADIR=./data
```

You can change this to any path you prefer (absolute or relative to the devilbox directory).

## Important Notes

1. **First Run**: On first startup, the database services will initialize their data in the respective directories
2. **Existing Data**: If you had existing databases in Docker volumes, you'll need to migrate that data manually
3. **Permissions**: The database directories may need proper ownership/permissions depending on your system
4. **Container Recreation**: When changing the data directory path, recreate containers:
   ```bash
   docker-compose stop
   docker-compose rm -f
   docker-compose up -d
   ```

## Migration from Named Volumes

If you have existing data in Docker named volumes, you can migrate it:

1. Start the old setup and backup your databases
2. Apply this portable configuration  
3. Start the new setup and restore your databases

## Security

Remember to:
- Add `data/mysql/`, `data/postgres/`, `data/redis/`, `data/mongo/` to `.gitignore` if using version control
- Ensure proper file permissions for database directories
- Regularly backup the `data/` directory
