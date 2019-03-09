#!/bin/bash
#
# Build contributors.md.

cat _src/mlpack-git/COPYRIGHT.txt |\
    grep 'Copyright' |
    sed 's/^[ ]*Copyright [0-9&-]*, //' |\
    sed 's/ <.*$//' |\
    grep -v 'Copyright:' |\
    sed 's/^/ - /' > contributors.md;
