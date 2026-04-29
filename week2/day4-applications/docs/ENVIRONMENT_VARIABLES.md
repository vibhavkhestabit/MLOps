# Environment Variables Reference

This document catalogs the required `.env` configurations for all application stacks. Never commit actual `.env` files to version control.

## 1. express-postgresql-api/.env
```
PORT=3000
NODE_ENV=production
DB_HOST=127.0.0.1
DB_PORT=5432
DB_USER=dbadmin
DB_PASSWORD=AdminP@ssw0rd123
DB_NAME=testdb
```

## 2. fastapi-mysql-api/.env

```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=password
DB_NAME=appdb
```
## 3. laravel-mysql-api/.env

```
APP_ENV=production
APP_DEBUG=false
APP_URL=http://localhost:9000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=appdb
DB_USERNAME=root
DB_PASSWORD=password
```

## 4. next-frontend/.env.local

### Exposed to the browser to allow client-side fetching
```
NEXT_PUBLIC_LARAVEL_API=[http://127.0.0.1:9000/api](http://127.0.0.1:9000/api)
```