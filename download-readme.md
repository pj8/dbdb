## MySQL

- macOS ARM
  - https://dev.mysql.com/downloads/mysql/
  - Select `macOS`
  - Select `macOS 15 (ARM, 64-bit)`
  - Select `Compressed TAR Archive`
  - e.g.

```bash
# 8.0.41
major=8
minor=0
patch=41
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-macos15-arm64.tar.gz
wget -O mysql-$version-macos.tar.gz "$url"

# 8.4.4
major=8
minor=4
patch=4
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-macos15-arm64.tar.gz
wget -O mysql-$version-macos.tar.gz "$url"

# 9.2.0
major=9
minor=2
patch=0
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-macos15-arm64.tar.gz
wget -O mysql-$version-macos.tar.gz "$url"
```

- Linux x86_64
  - https://dev.mysql.com/downloads/mysql/
  - Select `Linux - Generic`
  - Select `Linux - Generic (glibc 2.28)(x86, 64-bit)`
  - Select `Compressed TAR Archive`
  - e.g.

```bash
# 8.0.41
major=8
minor=0
patch=41
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-linux-glibc2.28-x86_64.tar.xz
wget -O mysql-$version-linux.tar.gz "$url"

# 8.4.4
major=8
minor=4
patch=4
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-linux-glibc2.28-x86_64.tar.xz
wget -O mysql-$version-linux.tar.gz "$url"

# 9.2.0
major=9
minor=2
patch=0
version=$major.$minor.$patch
url=https://dev.mysql.com/get/Downloads/MySQL-$major.$minor/mysql-$version-linux-glibc2.28-x86_64.tar.xz
wget -O mysql-$version-linux.tar.gz "$url"
```
