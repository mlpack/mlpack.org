#!/bin/bash
#
# Generate documentation in doc/mlpack-${version}/ for each version.

# Workflow:
#
# - make sure all .tar.gzs are dropped in files/.
# - run this script with $PWD=root of repository

# We need a working copy of the site.
jekyll b;

rm -f doc/*

# Get most recent version.
active_version=`ls files/mlpack-*.tar.gz |\
                grep -v 'git' |\
                sort -r |\
                head -1 |\
                sed 's|_src/mlpack-||' |\
                sed 's|.tar.gz||'`;

# Get list of versions.
doxygen_versions=();
for i in `ls files/mlpack-*.tar.gz | sort -r`;
do
  doxygen_versions+=("`basename $i .tar.gz | sed 's/mlpack-//'`");
done

doc_versions=();
for i in `ls files/mlpack-*.tar.gz | sort -r`;
do
  version=`basename $i .tar.gz | sed 's/mlpack-//'`;

  # Build the documentation for this version and get things in the right place.
  _src/scripts/build-version.sh ${version};
done

_src/scripts/rebuild-docs.sh;
_src/scripts/extract-contributors.sh;

jekyll clean && jekyll b;
