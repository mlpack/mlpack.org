#!/bin/bash
#
# Extract the list of tutorials from doc/tutorials/tutorials.txt for a given
# mlpack version.
#
# $1: version ("3.0.4", etc.)
# $2: output Markdown file

cat _src/mlpack-$1/doc/tutorials/tutorials.txt | \
    sed -E 's/@section [^ ]*/###/' |\
    grep -v '^@' |\
    grep -v '^\/\*!$' |\
    grep -v '\*\/$' |\
    sed -E 's/^[ ]*- \\ref ([^ ]*)/ - [\1](doxygen\/\1.html)/' |\
    sed '1,/^### Introductory Tutorials/ d' |\
    awk 'BEGIN { print "### Introductory Tutorials" } // { print $0; }' \
    > $2;

# Now, extract the actual name of each tutorial.
for i in `cat $2 | grep '^ - \[.*\]' | sed -E 's/ - \[(.*)\].*$/\1/'`;
do
  # Extract the title from the prebuilt file.
  title=`grep '<div class=\"title\">' doc/mlpack-${1}/doxygen/${i}.html |\
      sed -E 's/<div class=\"title\">([^<]*)<\/div>.*$/\1/'`;
  sed -i 's/^ - \['$i'\]/ - \['"${title//\//\\\/}"'\]/' $2;
done
