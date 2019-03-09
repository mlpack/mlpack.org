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

sed -i 's/\[mlpack-[^t]*.tar.gz\](files\/mlpack-[^t]*.tar.gz)/[mlpack-'$active_version'.tar.gz](files\/mlpack-'$active_version'.tar.gz/' index.md;

sed -i 's/^ [*] \[documentation\]([^)]*)/ * [documentation](doc\/mlpack-'$active_version'\/cli_documentation.html)/' index.md;

sed -i 's/^ [*] \[tutorials\]([^)]*)/ * [tutorials](doc\/mlpack-'$active_version'\/cli_documentation.html#tutorials)/' index.md; 

grep '^ - ' doc/mlpack-$active_version/quickstart.md > quickstart.md;
