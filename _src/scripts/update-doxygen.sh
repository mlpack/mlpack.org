#!/bin/bash
#
# The intention of this script is to rebuild the doxygen documentation,
# preferably nightly.  So this script can be called directly from a cron job.
#
# The script also rebuild the IRC documentation.
#
# The working directory for this script does not matter (unlike many of the
# other scripts).
#
# The script takes one argument, which is the directory to output the new
# website into.

# Change to root directory.
cd "$(dirname "$0")";
cd ../../;

_src/scripts/update-irc.sh;
_src/scripts/build-version.sh git;
_src/scripts/rebuild-docs.sh;

jekyll clean && \
    jekyll b -d tmp_site/ -b / && \
    ln -s /home/ryan/irclogs/freenode/mlpack/ tmp_site/irc/logs && \
    ln -s /home/jenkins-mlpack/workspace/blog/script/blog/doxygen tmp_site/gsocblog && \
    mkdir old_site/ && \
    mv "$1/"* old_site/ && \
    mv tmp_site/* "$1/" && \
    rm -rf tmp_site old_site;
