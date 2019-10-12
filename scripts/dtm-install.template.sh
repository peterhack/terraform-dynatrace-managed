#!/bin/bash

# Download Dynatrace Managed Installer
wget -nv -O dynatrace-managed.sh INSTALLERURL

# Install Dynatrace Managed with root rights
sudo /bin/sh ./dynatrace-managed.sh --license LICENSE --install-silent 


DTMURL="INSTALLERURL"
DTMLIC="LICENSE"
