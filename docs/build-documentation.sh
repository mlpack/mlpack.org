#!/bin/bash
#
# git pull, then rebuild the docs.
#
# $1: version of mlpack (should be unpacked into /var/www/www.mlpack.org/mlpack-x.y.z/)
# should be in the format "mlpack-2.2.3" or similar.  "mlpack-git" for git
# master.
srcdir=/var/www/www.mlpack.org/$1/
docdir=/var/www/www.mlpack.org/docs/$1/
postdir=/var/www/www.mlpack.org/docs/doxygen-post/
doxygensrcdir=/var/www/www.mlpack.org/docs/doxygen-src/

cd $srcdir

if [ "$1" == "mlpack-git" ]; then
  git pull # Update sources.
fi

cd build

# Do we need to update the Doxygen stylesheet?
modified_lines=`cat $srcdir/Doxyfile | grep 'doxygen-src/header.html' | wc -l`;
if [ "a$modified_lines" == "a0" ]; then
  # Modify the Doxyfile.
  sed -i "s|HTML_HEADER[ ]*=[ ]*.*$|HTML_HEADER = ${doxygensrcdir}/header.html|" $srcdir/Doxyfile;
  sed -i "s|HTML_FOOTER[ ]*=[ ]*.*$|HTML_FOOTER = ${doxygensrcdir}/footer.html|" $srcdir/Doxyfile;
  sed -i "s|HTML_STYLESHEET[ ]*=[ ]*.*$|HTML_STYLESHEET = ${doxygensrcdir}/doxygen.css|" $srcdir/Doxyfile;
  sed -i "s|HTML_EXTRA_STYLESHEET[ ]*=[ ]*.*$|HTML_EXTRA_STYLESHEET = ${doxygensrcdir}/style-doxygen.css|" $srcdir/Doxyfile;
fi

# We have to build everything for the sake of the man pages.
# This probably precipitates cleaning the environment.
make clean
rm -rf doc/html/*
make -j2
# Rebuild the man pages and the documentation.
make man doc
# Restore original doxyfile.
if [ "$1" == "mlpack-git" ]; then
  git checkout $srcdir/Doxyfile
fi
# We need to invert all the images.
cd doc/html/
mogrify -negate *.png
# Move the extra CSS.
cp $doxygensrcdir/tabs.css .
cp $doxygensrcdir/dynamic_tables.js .

# Now postprocess all of the HTML.
for i in *.html; do
  $doxygensrcdir/label_html_templates.py $i > tmp.html;
  mv tmp.html $i;
done
cd ../../

# Now move the HTML to the right place.
mv $docdir/doxygen $docdir/doxygen-old;
mv $srcdir/build/doc/html $docdir/doxygen;
rm -rf $docdir/doxygen-old;

# Now add the author tags to the generated tutorials.
python $doxygensrcdir/tutorial_author_annotator.py $docdir/*/tutorials/ $docdir/doxygen/

# Copy the man page results to the right directory.
rm -rf $docdir/man/*
cp share/man/*.gz $docdir/man/
cd $docdir/man/

gunzip *.gz
../../generate-man-html.sh # Rebuild html.
