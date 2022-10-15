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
while true
do
  randomPort=$(shuf -i "49152-65535" -n 1)
  netstat -a -n | grep ".$randomPort" | grep "LISTEN" 1>/dev/null 2>&1 || break
done
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
while true
do
  randomPort=$(shuf -i "49152-65535" -n 1)
  netstat -a -n | grep ".$randomPort" | grep "LISTEN" 1>/dev/null 2>&1 || break
done
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
while true
do
  randomPort=$(shuf -i "49152-65535" -n 1)
  netstat -a -n | grep ".$randomPort" | grep "LISTEN" 1>/dev/null 2>&1 || break
done
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
