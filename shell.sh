#!/bin/sh

# Open an interactive shell inside the PHP container as the 'devilbox' user,
# starting in /shared/httpd, supporting both docker-compose v1 and v2 (docker compose).
if hash docker-compose 2>/dev/null; then
	docker-compose exec --user devilbox php /bin/sh -c "cd /shared/httpd; exec bash -l"
else
	docker compose exec --user devilbox php /bin/sh -c "cd /shared/httpd; exec bash -l"
fi
