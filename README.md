# DBDB

![dbdb](https://user-images.githubusercontent.com/177159/112558153-6e3cd200-8e11-11eb-9cc0-47ef91eedfb1.png)


## MySQL
### Create/Start/Stop/Restart/Status/Connect/Delete MySQL Server on localhost
```
cd mysql
./{create|start|stop|restart|status|connect|delete}.sh {name} {mysqlVersion} {port}

# e.g. Create MySQL server.
./create.sh mysql1 5.7.31 3306

# e.g. Create another one.
./create.sh mysql2 8.0.23 13306

# e.g. 
./start.sh   mysql1 5.7.31 3306
./stop.sh    mysql1 5.7.31 3306
./restart.sh mysql1 5.7.31 3306
./status.sh  mysql1 5.7.31 3306
./connect.sh mysql1 5.7.31 3306
./delete.sh  mysql1 5.7.31 3306

# e.g. Try create, then start server.
./create-start.sh mysql1 5.7.31 3306
```

### Supported MySQL Versions
- 5.7.31
- 8.0.23

----

## PostgreSQL
### Create/Start/Stop/Restart/Status/Connect/Delete PostgreSQL Server on localhost
```
cd postgresql
./{create|start|stop|restart|status|connect|delete}.sh {name} {postgresqlVersion} {port}

# e.g.
./create.sh  pg1 12.4 5432
./start.sh   pg1 12.4 5432
./stop.sh    pg1 12.4 5432
./restart.sh pg1 12.4 5432
./status.sh  pg1 12.4 5432
./connect.sh pg1 12.4 5432
./delete.sh  pg1 12.4 5432
```
### Supported PostgreSQL Versions
- 12.4
- 12.6
- 13.2

----

## Redis
### Create/Start/Stop/Restart/Status/Connect/Delete Redis Server on localhost
```
cd redis
./{create|start|stop|restart|status|connect|delete}.sh {name} {redisVersion} {port}

# e.g.
./create.sh  redis1 6.0.10 6379
./start.sh   redis1 6.0.10 6379
./stop.sh    redis1 6.0.10 6379
./restart.sh redis1 6.0.10 6379
./status.sh  redis1 6.0.10 6379
./connect.sh redis1 6.0.10 6379
./delete.sh  redis1 6.0.10 6379
```
### Supported Redis Versions
- 5.0.10
- 6.0.10

----

## MongoDB
### Create/Start/Stop/Restart/Status/Connect/Delete MongoDB Server on localhost
```
cd mongodb
./{create|start|stop|restart|status|connect|delete}.sh {name} {mongodbVersion} {port}

# e.g.
./create.sh  mongo1 4.4.3 27017
./start.sh   mongo1 4.4.3 27017
./stop.sh    mongo1 4.4.3 27017
./restart.sh mongo1 4.4.3 27017
./status.sh  mongo1 4.4.3 27017
./connect.sh mongo1 4.4.3 27017
./delete.sh  mongo1 4.4.3 27017
```
### Supported MongoDB Versions
- 4.4.3
