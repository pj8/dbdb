# DBDB

```
 -----------------------------------------------
< DBDB, What a great database version manager! >
 -----------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Install

```
git clone https://github.com/pj8/dbdb.git
cd dbdb
```

## MySQL

### Create/Start/Stop/Restart/Status/Connect/Delete MySQL Server on localhost

```
./mysql/{create|start|stop|restart|status|connect|delete}.sh {name} {mysqlVersion} {port}

# e.g. Create MySQL server.
./mysql/create.sh mysql1 5.7.31 3306

# e.g. Create another one.
./mysql/create.sh mysql2 8.0.30 13306

# e.g.
./mysql/start.sh   mysql1 5.7.31 3306
./mysql/stop.sh    mysql1 5.7.31 3306
./mysql/restart.sh mysql1 5.7.31 3306
./mysql/status.sh  mysql1 5.7.31 3306
./mysql/connect.sh mysql1 5.7.31 3306
./mysql/delete.sh  mysql1 5.7.31 3306

# e.g. Create with random port.
./mysql/create.sh mysql1 5.7.31 random

# e.g. Try create, then start server.
./mysql/create-start.sh mysql1 5.7.31 3306
```

### Supported MySQL Versions

- 5.7.31
- 8.0.23
- 8.0.30

---

## PostgreSQL

### Create/Start/Stop/Restart/Status/Connect/Delete PostgreSQL Server on localhost

```
./postgresql/{create|start|stop|restart|status|connect|delete}.sh {name} {postgresqlVersion} {port}

# e.g.
./postgresql/create.sh  pg1 12.4 5432
./postgresql/start.sh   pg1 12.4 5432
./postgresql/stop.sh    pg1 12.4 5432
./postgresql/restart.sh pg1 12.4 5432
./postgresql/status.sh  pg1 12.4 5432
./postgresql/connect.sh pg1 12.4 5432
./postgresql/delete.sh  pg1 12.4 5432
```

### Supported PostgreSQL Versions

- 12.4
- 12.6
- 13.2

---

## Redis

### Create/Start/Stop/Restart/Status/Connect/Delete Redis Server on localhost

```
./redis/{create|start|stop|restart|status|connect|delete}.sh {name} {redisVersion} {port}

# e.g.
./redis/create.sh  redis1 6.0.10 6379
./redis/start.sh   redis1 6.0.10 6379
./redis/stop.sh    redis1 6.0.10 6379
./redis/restart.sh redis1 6.0.10 6379
./redis/status.sh  redis1 6.0.10 6379
./redis/connect.sh redis1 6.0.10 6379
./redis/delete.sh  redis1 6.0.10 6379
```

### Supported Redis Versions

- 5.0.14 (Error `make` on M1 Mac.)
- 6.0.16
- 6.2.6

---

## MongoDB

### Create/Start/Stop/Restart/Status/Connect/Delete MongoDB Server on localhost

```
./mongodb/{create|start|stop|restart|status|connect|delete}.sh {name} {mongodbVersion} {port}

# e.g.
./mongodb/create.sh  mongo1 4.4.3 27017
./mongodb/start.sh   mongo1 4.4.3 27017
./mongodb/stop.sh    mongo1 4.4.3 27017
./mongodb/restart.sh mongo1 4.4.3 27017
./mongodb/status.sh  mongo1 4.4.3 27017
./mongodb/connect.sh mongo1 4.4.3 27017
./mongodb/delete.sh  mongo1 4.4.3 27017
```

### Supported MongoDB Versions

- 4.4.10
- 5.0.3

---

## Tips

### Create with random port.

```
/path/to/dbdb/mysql/create.sh mysql5-foo 5.7.31 random
```

### Start by creating the database server if it does not exist.

```
# Try create, then start server.
/path/to/dbdb/mysql/create-start.sh mysql5-foo 5.7.31 3306
```

### How do I show all the database servers?

- You can use `dbdb.sh` for that.

```
/path/to/dbdb/dbdb.sh

mongodb.4.4.3.mongo4 is stopped.
/path/to/dbdb/mongodb/start.sh   mongo4 4.4.3 27017
/path/to/dbdb/mongodb/stop.sh    mongo4 4.4.3 27017
/path/to/dbdb/mongodb/restart.sh mongo4 4.4.3 27017
/path/to/dbdb/mongodb/status.sh  mongo4 4.4.3 27017
/path/to/dbdb/mongodb/connect.sh mongo4 4.4.3 27017
/path/to/dbdb/mongodb/delete.sh  mongo4 4.4.3 27017

mysql.5.7.31.mysql5-foo is running.
/path/to/dbdb/mysql/start.sh   mysql5-foo 5.7.31 3306
/path/to/dbdb/mysql/stop.sh    mysql5-foo 5.7.31 3306
/path/to/dbdb/mysql/restart.sh mysql5-foo 5.7.31 3306
/path/to/dbdb/mysql/status.sh  mysql5-foo 5.7.31 3306
/path/to/dbdb/mysql/connect.sh mysql5-foo 5.7.31 3306
/path/to/dbdb/mysql/delete.sh  mysql5-foo 5.7.31 3306

...
```

### How to start a database server when my server booted?

- [`crontab -e` with @reboot](https://man7.org/linux/man-pages/man5/crontab.5.html#EXTENSIONS)

```
# Start mysql5
@reboot /path/to/dbdb/mysql/start.sh mysql5-foo 5.7.31 3306

# Start mysql8 with port 13306
@reboot /path/to/dbdb/mysql/start.sh mysql8-bar 8.0.30 13306

# Try create, then start the server
@reboot /path/to/dbdb/redis/create-start.sh  redis1 6.0.10 6379
```
