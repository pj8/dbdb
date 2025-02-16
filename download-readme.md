```bash
# MySQL

# - macOS ARM
#   - https://dev.mysql.com/downloads/mysql/
#   - Select `macOS`
#   - Select `macOS 15 (ARM, 64-bit)`
#   - Select `Compressed TAR Archive`
#   - e.g.

## 8.0.41
major=8
minor=0
patch=41
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-macos15-arm64.tar.gz
wget -O mysql-$version-macos.tar.gz "$url"

## 8.4.4
major=8
minor=4
patch=4
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-macos15-arm64.tar.gz
wget -O mysql-$version-macos.tar.gz "$url"

## 9.2.0
major=9
minor=2
patch=0
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-macos15-arm64.tar.gz
wget -O mysql-$version-macos.tar.gz "$url"

# MongoDB

## macOS(ARM)
version=6.0.20
url="https://fastdl.mongodb.org/osx/mongodb-macos-arm64-$version.tgz"
wget -O mongodb-$version-macos.tar.gz "$url"
version=7.0.16
url="https://fastdl.mongodb.org/osx/mongodb-macos-arm64-$version.tgz"
wget -O mongodb-$version-macos.tar.gz "$url"
version=8.0.4
url="https://fastdl.mongodb.org/osx/mongodb-macos-arm64-$version.tgz"
wget -O mongodb-$version-macos.tar.gz "$url"

```
