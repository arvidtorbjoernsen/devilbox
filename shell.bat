
@echo off
setlocal
where docker-compose >nul 2>nul
if %ERRORLEVEL%==0 (
  docker-compose exec --user devilbox php /bin/sh -c "cd /shared/httpd; exec bash -l"
) else (
  docker compose exec --user devilbox php /bin/sh -c "cd /shared/httpd; exec bash -l"
)
