#!/bin/bash
# regen-newest-html.sh <irssi-logdir> <output-html-dir>
#
# A ridiculous bash script to regenerate HTML IRC log files.  This is really
# getting close to the wrongest way to run a public logging system.  I kinda
# like it because it's so terrible.
#
# This expects that header.html and footer.html are in
# output-html-dir/templates/ and those will be used to generate the header and
# footer.

echo "Content-type: text/html"
echo "";

cd ..; # Don't run in scripts/.
logdir='./irc/logs/';
htmldir='./irc/';
scriptdir='./irc/scripts/';

if [ "a$logdir" = "a" ]; then
  echo "Must specify log directory as first parameter."
  exit
fi

if [ "a$htmldir" = "a" ]; then
  echo "Must specify html directory as second parameter."
  exit
fi

if [ "a$scriptdir" = "a" ]; then
  echo "Assuming that scriptdir is scripts/."
  scriptdir="scripts/";
fi

logfile=`ls -t $logdir | head -1`;

# Modify some unset information in the templates, after deriving what the day
# is.
filename=`basename $logfile .log | sed 's/#//'`;
date=`echo $filename | sed -E 's/.*([0-9]{4})([0-9]{2})([0-9]{2}).*/\1-\2-\3/'`;

# Print the header.
cat $htmldir/templates/header.html | sed -E 's/%%DAY%%/'$date'/g'

# Generate the calendar.
$scriptdir/create-stdout-calendar.sh $logfile $logdir;

# Turn the irssi log into something that's kind of like HTML.
$scriptdir/process-log.sh $logdir/$logfile;

cat $htmldir/templates/footer.html
