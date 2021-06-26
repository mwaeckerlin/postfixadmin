# PostfixAdmin

Docker Image for Postfixadmin

Best to use in https://github.com/mwaeckerlin/mailservice

Use with https://github.com/mwaeckerlin/postfixadmin-proxy as nginx proxy in front of this

## Configuration

- `SETUP_PASSWORD`: the hashed postfixadmin setup dassword, no default
- `DATABASE_TYPE`: database type, default: `mysqli` - only tested with that
- `DATABASE_HOST`: name of the database host, default: `postfixadmin-db`
- `DATABASE_NAME`: name of the database, default: `postfixadmin`
- `DATABASE_USER`: name of thae database user, default: `postfixadmin`
- `DATABASE_PASSWORD`: password of the database user, default: `ChangeMe`

### Setup Password

Best start with an undefined setup password, then open http://localhost:8080/public/setup.php in the browser and follow the instruction to set a setup password. At the end, you get a hash. Then set this hash to `SETUP_PASSWORD` and restart. Then open the setup again to configure an administrator.

### Database Types

- `mysql`: MySQL 3.23 and 4.0, 4.1 or 5
- `mysqli`: MySQL 4.1+ or MariaDB
- `pgsql`: PostgreSQL
- `sqlite`: SQLite 3
