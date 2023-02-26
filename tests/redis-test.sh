#!/usr/bin/env bash
set -aeuvx

. ../lib/functions.sh

cd ../redis
rm -fr redis-*.tar.gz

date=$(date +%Y%m%d%H%M%S)
md5="md5"
[ "$(getOS)" = "linux" ] && md5="md5sum"
hash=$(echo "dbdb-$date"|$md5|cut -d ' ' -f 1)

# 6.0.16
echo "Test create..."
./create.sh       dbdb-test-$hash 6.0.16 random
echo "Test start..."
./start.sh        dbdb-test-$hash
echo "Test status..."
./status.sh       dbdb-test-$hash
echo "Test stop..."
./stop.sh         dbdb-test-$hash
echo "Test delete..."
./delete.sh       dbdb-test-$hash

# 6.2.6
echo "Test create..."
./create.sh       dbdb-test-$hash 6.2.6 random
echo "Test start..."
./start.sh        dbdb-test-$hash
echo "Test status..."
./status.sh       dbdb-test-$hash
echo "Test stop..."
./stop.sh         dbdb-test-$hash
echo "Test delete..."
./delete.sh       dbdb-test-$hash
