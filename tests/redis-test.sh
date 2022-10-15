#!/usr/bin/env bash
set -aeuvx

. ../lib/functions.sh

cd ../redis
rm -fr redis-*.tar.gz

while true
do
  randomPort=$(shuf -i "49152-65535" -n 1)
  netstat -a -n | grep ".$randomPort" | grep "LISTEN" 1>/dev/null 2>&1 || break
done
echo randomPort:$randomPort

date=$(date +%Y%m%d%H%M%S)
md5="md5"
[ "`getOS`" = "linux" ] && md5="md5sum"
hash=$(echo "dbdb-$date"|$md5)

# 5.0.14 (Error `make` on M1 Mac.)
#./create.sh       dbdb-test-$hash 5.0.14 $randomPort

# 6.0.16
echo "Test create..."
./create.sh       dbdb-test-$hash 6.0.16 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 6.0.16 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 6.0.16 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 6.0.16 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 6.0.16 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 6.0.16 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 6.0.16 $randomPort

# 6.2.6
echo "Test create..."
./create.sh       dbdb-test-$hash 6.2.6 $randomPort
echo "Test start..."
./start.sh        dbdb-test-$hash 6.2.6 $randomPort
echo "Test status..."
./status.sh       dbdb-test-$hash 6.2.6 $randomPort
echo "Test stop..."
./stop.sh         dbdb-test-$hash 6.2.6 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 6.2.6 $randomPort
echo "Test create-start..."
./create-start.sh dbdb-test-$hash 6.2.6 $randomPort
echo "Test delete..."
./delete.sh       dbdb-test-$hash 6.2.6 $randomPort
