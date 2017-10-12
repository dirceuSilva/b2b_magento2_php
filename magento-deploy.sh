#!/bin/bash

targetdir=$1

echo "Running magento static-content:deploy, indexer:reindex and setting deploy:mode to $M2MODE"
$targetdir/bin/magento setup:static-content:deploy
$targetdir/bin/magento indexer:reindex
$targetdir/bin/magento deploy:mode:set $M2MODE
