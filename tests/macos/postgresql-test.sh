#!/usr/bin/env bash
set -aeuvx

cd ../../postgresql
rm -fr postgresql-*.tar.gz

while true
do
  randomPort=$(shuf -i "49152-65535" -n 1)
  netstat -a -n | grep ".$randomPort" | grep "LISTEN" 1>/dev/null 2>&1 || break
done
echo randomPort:$randomPort

date=$(date +%Y%m%d%H%M%S)
hash=$(echo "dbdb-$date"|md5)

# 12.4
echo "Test create..."
./create.sh       dbdb-test-$hash 12.4 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 12.4 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 12.4 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 12.4 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 12.4 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 12.4 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 12.4 $randomPort

# 12.6
echo "Test create..."
./create.sh       dbdb-test-$hash 12.6 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 12.6 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 12.6 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 12.6 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 12.6 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 12.6 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 12.6 $randomPort

# 13.2
echo "Test create..."
./create.sh       dbdb-test-$hash 13.2 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 13.2 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 13.2 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 13.2 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 13.2 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 13.2 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 13.2 $randomPort
