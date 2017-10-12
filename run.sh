#!/bin/bash

echo "Initializing Magento2 Container..."
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mageroot="/src"

echo "Initializing Magento2 setup using MAGE_ROOT=$mageroot..."
if [ "$M2SETUP_FORCE_EXECUTION" == "true" ] || [ ! -f "$mageroot/app/etc/config.php" ] || [ ! -f "$mageroot/app/etc/env.php" ]; then
  $DIR/magento-create-project.sh $mageroot

  $DIR/magento-set-permissions.sh $mageroot

  $DIR/magento-install.sh $mageroot
fi

$DIR/magento-deploy.sh $mageroot
echo "The setup script has completed execution."

echo "php-fpm started"
/usr/local/sbin/php-fpm