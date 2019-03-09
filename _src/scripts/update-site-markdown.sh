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

sed -i 's/\[build mlpack from source\](doc\/mlpack-[^\/]*\/doxygen\/build.html)/[build mlpack from source](doc\/mlpack-'$active_version'\/doxygen\/build.html)/' community.md;

sed -i 's/\[Python bindings\]([^)]*)/[Python bindings](doc\/mlpack-'$active_version'\/python_documentation.html)/' community.md;

sed -i 's/\[command-line programs\]([^)]*)/[command-line programs](doc\/mlpack-'$active_version'\/cli_documentation.html)/' community.md;

sed -i 's/\[here\](doc\/mlpack-[^)]*)/[here](doc\/mlpack-'$active_version'\/doxygen\/sample.html)/' community.md;
