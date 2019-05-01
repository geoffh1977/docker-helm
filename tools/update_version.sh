#!/bin/bash
# Update The Software Version From Online

# Get The Versions Of The Software

SITE_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-helm | grep -oP '(?<=<Key>).*?(?=</Key>)' | grep -Eo "[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}" | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n -u | tail -n1)
LOCAL_VERSION=$(grep "finalImageVersion" container.conf | cut -d= -f 2)

# Check Versions And Update File
if [ "$SITE_VERSION" != "$LOCAL_VERSION" ]
then
  sed -i "s/^finalImageVersion=.*/finalImageVersion=${SITE_VERSION}/" container.conf
  SHA=$(curl -s "https://storage.googleapis.com/kubernetes-helm/helm-v${SITE_VERSION}-linux-amd64.tar.gz.sha256" | awk '{print $1}')
  sed -i "s/^helmSha256=.*/helmSha256=${SHA}/" container.conf
  echo " Version Updated."
else
  echo " No Version Change."
fi
