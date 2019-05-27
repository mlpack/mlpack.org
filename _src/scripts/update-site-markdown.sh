#!/bin/bash
#
# Update the site's Markdown to the latest version and release.
#
# Run this from the root of the repository.

# Get most recent version.
active_version=`ls files/mlpack-*.tar.gz |\
                grep -v 'git' |\
                sort -r |\
                head -1 |\
                sed 's|files/mlpack-||' |\
                sed 's|.tar.gz||'`;

grep '^ - ' doc/mlpack-$active_version/quickstart.md > quickstart.md;
sed -i 's/](doxygen/](doc\/stable\/doxygen/g' quickstart.md;
