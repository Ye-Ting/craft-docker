#!/bin/sh
set -e
echo "===> Installing dependencies"
cd /scripts && touch .gitignore

echo "===> +  Configuring user and group"
CM_USER=""
CM_GROUP=""

if [ "$CM_USER" = "" ]; then
  CM_USER="$(stat -c '%u' "/var/www")"
fi
if [ "$CM_GROUP" = "" ]; then
  CM_GROUP="$(stat -c '%g' "/var/www")"
fi

echo "===> +    User id: $CM_USER"
echo "===> +    Group id: $CM_GROUP"

getent group "$CM_GROUP" || groupadd craftman -g "$CM_GROUP"

usermod -u "$CM_USER" www-data || echo "User $CM_USER already exists"
usermod -G "$CM_GROUP" www-data || echo "Group $CM_GROUP already exists"

echo "===> +  Configuring site permissions"
chown -R $CM_USER:$CM_GROUP /var/www
echo "===> +    Set 775 permissions to /var/www"
chmod -R 775 /var/www

# Download and install libraries
echo "===> +  Update and install apt-get libraries"
apt-get update
apt-get install -y --no-install-recommends           libfreetype6-dev         libjpeg62-turbo-dev         libmcrypt-dev         libpng12-dev         libmagickwand-dev         vim curl git wget unzip

echo "===> +  Install php extensions"
printf "\n" | pecl install -f imagick

docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
docker-php-ext-install -j$(nproc) iconv mcrypt gd mbstring pdo pdo_mysql zip
docker-php-ext-enable imagick

echo "===> +  Enable apache mods"
a2enmod rewrite setenvif deflate headers filter



