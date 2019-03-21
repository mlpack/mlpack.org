#!/bin/bash
#
# This script regenerates the IRC pages and is meant to be called right after a
# UTC new day has begun.
#
# It takes no arguments, and expects that its working directory is the root of
# the repository.
#
# This also symlinks irc/logs/ to the right place using the hardcoded directory
# below.  Change if needed.

rm irc/logs;
ln -s /home/ryan/irclogs/freenode/mlpack irc/logs;

chmod a+r irc/logs/*;
irc/scripts/regen-html.sh "$PWD/irc/logs/" "$PWD/irc/" "$PWD/irc/scripts/";
irc/scripts/make-all-logs.sh "$PWD/irc/logs/" "$PWD/irc/";
