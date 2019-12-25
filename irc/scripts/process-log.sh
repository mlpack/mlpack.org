#!/bin/bash
# build-page.sh $logfile
#
# A ridiculous bash script to regenerate HTML IRC log files.  This takes an
# irssi logfile as an argument and then outputs some escaped HTML.  Doesn't do
# anything with a header or footer, and is (in general) meant for use in other
# scripts.

logfile=$1;

if [ "a$logfile" = "a" ]; then
  echo "Must specify log file as first parameter."
  exit
fi

# Get the list of nicks that talked this day.
nameslist=`cat $logfile | grep -E '^[0-9]{2}:[0-9]{2} < ' |
    sed -E 's/^[0-9]{2}:[0-9]{2} < ([^>]*)>.*$/\1/' | sort | uniq`;

# Isn't this abomination of sed awesome?  We're taking the irssi logs and
# forcing them to be HTML.  If irssi ever changes log format, we're screwed.
cat $logfile | sed -E 's/</\&lt;/g' |
               sed -E 's/>/\&gt;/g' |
               sed -E 's/\[/\&#91;/g' |
               sed -E 's/\]/\&#93;/g' |
               sed -E 's/$/<\/font><br>/' |
               sed -E 's/-!-/<\/font><font color="#aaa">-!-<\/font><font color="#aaa">/' |
               sed -E 's/^/<font color="#bb2222">/' > /tmp/build-page-tmp-0;

# Now set a color for each particular nick that was seen that day.
counter=0
for i in $nameslist;
do
  # Filter out [ and ] from names...
  safename=`echo $i | sed 's/\[/\&#91;/g' | sed 's/\]/\&#93;/g'` 
  cat /tmp/build-page-tmp-$counter | sed -E "s/(&lt; "$safename"&gt;)/<\/font><font class=\"ircnick"$counter"\">\1<\/font><font color=\"#616161\">/" > /tmp/build-page-tmp-$(($counter + 1));
  counter=$(($counter + 1));
done

cat /tmp/build-page-tmp-$counter;
rm -f /tmp/build-page-tmp*;
