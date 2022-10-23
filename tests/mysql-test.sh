#!/usr/bin/env bash
set -aeuvx

. ../lib/functions.sh

cd ../mysql
rm -fr mysql-*.tar.gz

date=$(date +%Y%m%d%H%M%S)
md5="md5"
[ "`getOS`" = "linux" ] && md5="md5sum"
hash=$(echo "dbdb-$date"|$md5|cut -d ' ' -f 1)

# 5.7.31
randomPort=`getRandomPort`
echo "Test create..."
./create.sh       dbdb-test-$hash 5.7.31 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 5.7.31 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 5.7.31 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 5.7.31 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 5.7.31 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 5.7.31 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 5.7.31 $randomPort

# 8.0.23
randomPort=`getRandomPort`
echo "Test create..."
./create.sh       dbdb-test-$hash 8.0.23 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 8.0.23 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 8.0.23 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 8.0.23 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 8.0.23 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 8.0.23 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 8.0.23 $randomPort

# 8.0.30
randomPort=`getRandomPort`
echo "Test create..."
./create.sh       dbdb-test-$hash 8.0.30 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 8.0.30 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 8.0.30 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 8.0.30 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 8.0.30 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 8.0.30 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 8.0.30 $randomPort
