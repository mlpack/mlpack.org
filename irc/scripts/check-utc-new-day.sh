#!/bin/bash
# Check if it's between 5am and 6am UTC.  If so, run the script given as an
# argument.
curhour=`date --utc -I'seconds' | sed -E 's/.*T([0-9]{2}):[0-9]{2}:[0-9]{2}.*/\1/'`;

if [ "a$curhour" = "a05" ]; then
  $@;
fi
