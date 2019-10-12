#!/bin/bash

read -p "Please enter the installation url (eg. https://...): " INSTALLERURL
echo ""
read -p "Please enter your License Key: " DTLICENSE
echo ""
echo "Installation command: " $INSTALLERURL
echo ""
echo "License Key: " $DTLICENSE
echo ""
read -p "are the above details correct? (y/n)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then 
  cp ./scripts/dtm-install.template.sh ./scripts/dtm-install.sh
  sed -i '' 's~INSTALLERURL~'"$INSTALLERURL"'~' ./scripts/dtm-install.sh
  sed -i '' 's~LICENSE~'"$DTLICENSE"'~' ./scripts/dtm-install.sh
  echo ""
fi
  
