#!/usr/bin/env bash
set -aeuvx

. ../lib/functions.sh

cd ../postgresql
rm -fr postgresql-*.tar.gz

date=$(date +%Y%m%d%H%M%S)
md5="md5"
[ "$(getOS)" = "linux" ] && md5="md5sum"
hash=$(echo "dbdb-$date" | $md5 | cut -d ' ' -f 1)

# 12.4
echo "Test create..."
./create.sh dbdb-test-$hash 12.4 random
echo "Test port..."
./port.sh dbdb-test-$hash
echo "Test start..."
./start.sh dbdb-test-$hash
echo "Test status..."
./status.sh dbdb-test-$hash
echo "Test stop..."
./stop.sh dbdb-test-$hash
echo "Test delete..."
./delete.sh dbdb-test-$hash

# 12.6
echo "Test create..."
./create.sh dbdb-test-$hash 12.6 random
echo "Test port..."
./port.sh dbdb-test-$hash
echo "Test start..."
./start.sh dbdb-test-$hash
echo "Test status..."
./status.sh dbdb-test-$hash
echo "Test stop..."
./stop.sh dbdb-test-$hash
echo "Test delete..."
./delete.sh dbdb-test-$hash

# 13.2
echo "Test create..."
./create.sh dbdb-test-$hash 13.2 random
echo "Test port..."
./port.sh dbdb-test-$hash
echo "Test start..."
./start.sh dbdb-test-$hash
echo "Test status..."
./status.sh dbdb-test-$hash
echo "Test stop..."
./stop.sh dbdb-test-$hash
echo "Test delete..."
./delete.sh dbdb-test-$hash

# dbdb.sh
./create-start.sh dbdb-test-$hash 13.2 random
../dbdb.sh
../dbdb.sh -f json
if command -v jq >/dev/null 2>&1; then
  ../dbdb.sh -f json | jq
fi
./delete.sh dbdb-test-$hash
