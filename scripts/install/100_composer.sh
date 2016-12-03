#!/bin/sh
set -e
echo "===> Installing PHP Composer"
cd /scripts
curl -sS https://getcomposer.org/installer | php
