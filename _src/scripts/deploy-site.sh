#!/bin/bash
#
# Rebuild and deploy the website to the given directory.

if [ "$#" -ne "1" ];
then
  echo "Usage: deploy-site.sh /path/to/deployment/";
  exit 1;
fi

# Find the newest version.
newest_version=`ls doc/ | grep 'mlpack-[0-9]' | sort -r | head -1`;

jekyll clean && \
    jekyll b -d tmp_site/ -b / && \
    cp -r html/* tmp_site/ && \
    ln -s /home/ryan/irclogs/freenode/mlpack/ tmp_site/irc/logs && \
    ln -s /home/jenkins-mlpack/workspace/blog/script/blog/doxygen tmp_site/gsocblog && \
    mkdir _old_site/ && \
    mv "$1/"* _old_site/ && \
    mv tmp_site/* "$1/" && \
    ln -s "$1/doc/$newest_version" "$1/doc/stable" && \
    rm -rf tmp_site _old_site;
