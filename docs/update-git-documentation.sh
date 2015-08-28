#!/bin/bash
#
# git pull, then rebuild the docs.

gitdir=/var/www/www.mlpack.org/mlpack-git/
docdir=/var/www/www.mlpack.org/docs/mlpack-git/
postdir=/var/www/www.mlpack.org/docs/doxygen-post/

cd $gitdir

git pull # Update sources.

cd build
# We have to build everything for the sake of the man pages.
# This probably precipitates cleaning the environment.
make clean
rm -rf doc/html/*
make -j2 # Will probably use Doxygen 1.8 (well, I hope).

# Rebuild the man pages and the documentation.
make man doc
# build/doc/html/ should be symlinked to $docdir/doxygen already.
# We need to invert all the images.
cd doc/html/
mogrify -negate *.png

# Now postprocess all of the HTML.
for i in *.html; do
  $postdir/label_html_templates.py $i > tmp.html;
  mv tmp.html $i;
done
cd ../../

# Now move the HTML to the right place.
mv $docdir/doxygen $docdir/doxygen-old;
mv $gitdir/build/doc/html $docdir/doxygen;
rm -rf $docdir/doxygen-old;

# Copy the man page results to the right directory.
rm -rf $docdir/man/*
cp share/man/*.gz $docdir/man/
cd $docdir/man/

gunzip *.gz
../../generate-man-html.sh # Rebuild html.
