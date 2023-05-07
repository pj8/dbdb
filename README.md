# DBDB

```
 ----------------------------------------------
< DBDB, What a great database version manager! >
 ----------------------------------------------
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

<details><summary>MySQL</summary><div>

## MySQL

### Manage MySQL Server on localhost

```
./mysql/{create|start|stop|restart|port|status|connect|delete}.sh {name} {mysqlVersion} {port}

# e.g. Create MySQL server.
./mysql/create.sh mysql1 5.7.31 3306

# e.g. Create another one.
./mysql/create.sh mysql2 8.0.30 13306

# e.g.
./mysql/start.sh   mysql1
./mysql/stop.sh    mysql1
./mysql/restart.sh mysql1
./mysql/port.sh    mysql1
./mysql/status.sh  mysql1
./mysql/connect.sh mysql1
./mysql/delete.sh  mysql1

# e.g. Create with random port.
./mysql/create.sh mysql1 5.7.31 random

# e.g. Try create, then start server.
./mysql/create-start.sh mysql1 5.7.31 3306
```

### Supported MySQL Versions

- 5.7.31
- 8.0.23
- 8.0.30

</div></details>

<details><summary>PostgreSQL</summary><div>

## PostgreSQL

### Manage PostgreSQL Server on localhost

```
./postgresql/{create|start|stop|restart|port|status|connect|delete}.sh {name} {postgresqlVersion} {port}

# e.g.
./postgresql/create.sh  pg1 12.4 5432
./postgresql/start.sh   pg1
./postgresql/stop.sh    pg1
./postgresql/restart.sh pg1
./postgresql/port.sh    pg1
./postgresql/status.sh  pg1
./postgresql/connect.sh pg1
./postgresql/delete.sh  pg1
```

### Supported PostgreSQL Versions

- 12.4
- 12.6
- 13.2

</div></details>

<details><summary>Redis</summary><div>

## Redis

### Manage Redis Server on localhost

```
./redis/{create|start|stop|restart|port|status|connect|delete}.sh {name} {redisVersion} {port}

# e.g.
./redis/create.sh  redis1 6.0.10 6379
./redis/start.sh   redis1
./redis/stop.sh    redis1
./redis/restart.sh redis1
./redis/port.sh    redis1
./redis/status.sh  redis1
./redis/connect.sh redis1
./redis/delete.sh  redis1
```

### Supported Redis Versions

- 5.0.14 (`make` causes an error on M1 Mac.)
- 6.0.16
- 6.2.6

</div></details>

<details><summary>MongoDB</summary><div>

## MongoDB

### Manage MongoDB Server on localhost

```
./mongodb/{create|start|stop|restart|port|status|connect|delete}.sh {name} {mongodbVersion} {port}

# e.g.
./mongodb/create.sh  mongo1 4.4.3 27017
./mongodb/start.sh   mongo1
./mongodb/stop.sh    mongo1
./mongodb/restart.sh mongo1
./mongodb/port.sh    mongo1
./mongodb/status.sh  mongo1
./mongodb/connect.sh mongo1
./mongodb/delete.sh  mongo1
```

### Supported MongoDB Versions

- 4.4.10
- 5.0.3

</div></details>

## Tips

### Create with random port.

```
/path/to/dbdb/mysql/create.sh mysql5-foo 5.7.31 random
```

### Show port number.

```
/path/to/dbdb/mysql/port.sh mysql5-foo
```

### Start by creating the database server if it does not exist.

```
# Create and start
/path/to/dbdb/mysql/create-start.sh mysql5-foo 5.7.31 3306
```

### How do I show all the database servers?

- You can use `dbdb.sh` for that.

```
./dbdb.sh
```

### How to start a database server when my server booted?

- [`crontab -e` with @reboot](https://man7.org/linux/man-pages/man5/crontab.5.html#EXTENSIONS)

```
# Start mysql5
@reboot /path/to/dbdb/mysql/start.sh mysql5-foo

# Start mysql8 with port 13306
@reboot /path/to/dbdb/mysql/start.sh mysql8-bar

# Create and start
@reboot /path/to/dbdb/redis/create-start.sh redis1 6.0.10 6379
```
