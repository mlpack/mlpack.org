#!/bin/bash
#
# git pull, then rebuild the docs.

gitdir=/var/www/www.mlpack.org/mlpack-git/
docdir=/var/www/www.mlpack.org/docs/mlpack-git/

cd $gitdir

git pull # Update sources.

cd build
# We have to build everything for the sake of the man pages.
# This probably precipitates cleaning the environment.
make clean
rm -rf doc/html/*
make -j2

# Rebuild the man pages and the documentation.
make man doc
# build/doc/html/ should be symlinked to $docdir/doxygen already.
# We need to invert all the images.
cd doc/html/
mogrify -negate *.png
cd ../../

# Copy the man page results to the right directory.
rm -rf $docdir/man/*
cp share/man/*.gz $docdir/man/
cd $docdir/man/

gunzip *.gz
../../generate-man-html.sh # Rebuild html.
