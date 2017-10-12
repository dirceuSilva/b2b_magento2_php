#!/bin/bash

targetdir=$1

if [ "$M2SETUP_USE_SAMPLE_DATA" = true ]; then
    echo "Running magento sampledata:deploy"
    $targetdir/bin/magento sampledata:deploy
    echo "Ignore the above error (bug in Magento), fixing with 'composer update'..."
    composer update
    M2SETUP_USE_SAMPLE_DATA_STRING="--use-sample-data"
else
    M2SETUP_USE_SAMPLE_DATA_STRING=""
fi

echo "Running magento setup:install"
$targetdir/bin/magento setup:install \
    --db-host=$M2SETUP_DB_HOST \
    --db-name=$M2SETUP_DB_NAME \
    --db-user=$M2SETUP_DB_USER \
    --db-password=$M2SETUP_DB_PASSWORD \
    --base-url=$M2SETUP_BASE_URL \
    --admin-firstname=$M2SETUP_ADMIN_FIRSTNAME \
    --admin-lastname=$M2SETUP_ADMIN_LASTNAME \
    --admin-email=$M2SETUP_ADMIN_EMAIL \
    --admin-user=$M2SETUP_ADMIN_USER \
    --admin-password=$M2SETUP_ADMIN_PASSWORD \
    --backend-frontname=$M2SETUP_ADMIN_URI \
    $M2SETUP_USE_SAMPLE_DATA_STRING
