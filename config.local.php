<?php
// Database Config
// mysql = MySQL 3.23 and 4.0, 4.1 or 5
// mysqli = MySQL 4.1+ or MariaDB
// pgsql = PostgreSQL
// sqlite = SQLite 3
$CONF['database_type'] = getenv('DATABASE_TYPE');
$CONF['database_host'] = getenv('DATABASE_HOST');
$CONF['database_user'] = getenv('DATABASE_USER');
$CONF['database_password'] = getenv('DATABASE_PASSWORD');
$CONF['database_name'] = getenv('DATABASE_NAME');
$CONF['database_name'] = getenv('DATABASE_NAME');
$CONF['setup_password'] = getenv('SETUP_PASSWORD');
$CONF['configured'] = true;