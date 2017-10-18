#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

targetdir=$1
if [ ! -f "$targetdir/composer.json" ]; then 
    echo "No composer.json found on $targetdir. Creating a new one with 'composer create-project'"
    composer create-project \
        --repository-url=https://repo.magento.com/ \
        magento/project-enterprise-edition=2.1.7 \
        $targetdir
    exit 0
fi

echo "Found a composer.json on $targetdir. Installing packages dependencies..."
composer install
