#!/bin/bash
#
# Rebuild and deploy the website to the given directory.

if [ "$#" -ne "1" ];
then
  echo "Usage: deploy-site.sh /path/to/deployment/";
  exit 1;
fi

deploy_dir="$1";
mkdir -p "$deploy_dir";
cp -vr *.html css/ doc/ files/ img/ papers/ v1/ "$deploy_dir";
