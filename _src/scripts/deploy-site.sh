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

# Download datasets.
rm -rf datasets/;
mkdir datasets/;
cd datasets/;
wget https://www.ratml.org/misc/datasets.tar.gz;
tar -xvzpf datasets.tar.gz;
rm datasets.tar.gz;
cd ../

jekyll clean && \
    jekyll b -d tmp_site/ -b / && \
    ln -s /home/ryan/irclogs/freenode/mlpack/ tmp_site/irc/logs && \
    ln -s /home/jenkins-mlpack/workspace/blog/script/blog/doxygen tmp_site/gsocblog && \
    mkdir old_site/ && \
    mv "$1/"* old_site/ && \
    mv tmp_site/* "$1/" && \
    ln -s "$1/doc/$newest_version" "$1/doc/stable" && \
    rm -rf tmp_site old_site;
