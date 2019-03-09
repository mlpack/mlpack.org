#!/bin/bash
#
# Extract the list of quickstart tutorials from doc/tutorials/tutorials.txt for
# a given mlpack version.
#
# $1: version ("3.0.4", etc.)
# $2: output Markdown file

cat _src/mlpack-$1/doc/tutorials/tutorials.txt | \
    sed -E 's/@section [^ ]*/###/' |\
    grep -v '^@' |\
    grep -v '^\/\*!$' |\
    grep -v '\*\/$' |\
    sed -E 's/^[ ]*- \\ref ([^ ]*)/ - [\1](doc\/mlpack-'$1'\/doxygen\/\1.html)/' |\
    sed -n '/### Introductory Tutorials/q;p' |\
    grep -v '^### Introductory Tutorials' \
    > $2;

# Now extract the actual name of each quickstart tutorial.
for i in `cat $2 | grep '^ - \[.*\]' | sed -E 's/ - \[(.*)\].*$/\1/'`;
do
  # Extract the title from the prebuilt file.
  title=`grep '^<div class="title">' doc/mlpack-${1}/doxygen/${i}.html |\
      sed -E 's/^<div class="title">([^<]*)<\/div>.*$/\1/'`;
  sed -i 's/^ - \['$i'\]/ - \['"${title//\//\\\/}"'\]/' $2;
done
