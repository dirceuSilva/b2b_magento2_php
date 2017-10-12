#!/bin/bash

targetdir=$1

echo "Set permissions for shared hosting (one user)"
find $targetdir/var $targetdir/vendor $targetdir/pub/static $targetdir/pub/media $targetdir/app/etc -type f -exec chmod u+w {} \;
find $targetdir/var $targetdir/vendor $targetdir/pub/static $targetdir/pub/media $targetdir/app/etc -type d -exec chmod u+w {} \;
chmod u+x $targetdir/bin/magento
chown -R www-data:www-data $targetdir/

#These aren't in the official documentation, but it doesn't work without them
sed -i 's/0770/0775/g' $targetdir/vendor/magento/framework/Filesystem/DriverInterface.php
sed -i 's/0660/0664/g' $targetdir/vendor/magento/framework/Filesystem/DriverInterface.php
find $targetdir/var/generation -type d -exec chmod g+s {} \;
chmod -R a+x $targetdir/