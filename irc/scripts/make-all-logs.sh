#!/bin/bash
# make-all-logs.sh
#
# Create the file all-logs.html, which lists links to all of the individual log
# days.

logdir=$1;
htmldir=$2;

if [ "a$logdir" = "a" ]; then
  echo "First parameter must be the log directory.";
  exit
fi

if [ "a$htmldir" = "a" ]; then
  echo "Second parameter must be output html directory.";
  exit
fi

# For each log entry, make a link.  Iterate in reverse, so that newest logs are
# on top.
echo "<div class=\"irclogchatlines\">" >> $htmldir/all-logs.tmp;
files=($logdir/#mlpack.*.log);
for ((index=${#files[@]}-1; index >= 0; index--));
do
  i="${files[$index]}";
  filename=`basename $i .log | sed 's/#//'`;
  date=`echo $filename | sed 's/mlpack\.//'`;
  displaydate=`date --date=${date} '+%B %d, %Y (%A)'`;
  lines=`grep '^[0-9][0-9]:[0-9][0-9] < ' $i | wc -l`;

  echo "<a href=\"${filename}.html\">$displaydate</a><div class=\"lines\">" >> $htmldir/all-logs.tmp;
  if [ "$lines" -gt "300" ]; then
    echo "<font class=\"irclotsoflines3\">" >> $htmldir/all-logs.tmp;
  elif [ "$lines" -gt "150" ]; then
    echo "<font class=\"irclotsoflines2\">" >> $htmldir/all-logs.tmp;
  elif [ "$lines" -gt "25" ]; then
    echo "<font class=\"irclotsoflines\">" >> $htmldir/all-logs.tmp;
  fi
  echo "[$lines lines of chat]" >> $htmldir/all-logs.tmp;
  if [ "$lines" -gt "25" ]; then
    echo "</font>" >> $htmldir/all-logs.tmp;
  fi
  echo "</div><br>" >> $htmldir/all-logs.tmp;
done
echo "</div>" >> $htmldir/all-logs.tmp;

cat $htmldir/templates/header-all.html $htmldir/all-logs.tmp $htmldir/templates/footer.html > $htmldir/logs-all.html;

rm -f $htmldir/all-logs.tmp;

# Now generate mlpack.log, which has every bit of log in it.
cat $logdir/#mlpack.*.log > $htmldir/mlpack.log
