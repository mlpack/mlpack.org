#!/bin/bash
# gen-nav-html.sh
#
# Generate the main HTML pages for the IRC logging system.
# This includes 'logs.html', which displays the current day's logs.

logdir=$1
htmldir=$2
outdir=$3

if [ "a$logdir" = "a" ]; then
  echo "Must specify logs directory as first parameter."
  exit
fi

if [ "a$htmldir" = "a" ]; then
  echo "Must specify html/ directory as second parameter."
  exit
fi

if [ "a$outdir" = "a" ]; then
  echo "Must specify output directory as third parameter."
  exit
fi

# Find the newest log file in the logs directory.
newestlog=`ls -t $logdir | head -1`;

# Using the newest log, generate the main logs.html file.
cat $logdir/$newestlog |
  sed -E 's/</\&lt;/g' |
  sed -E 's/>/\&gt;/g' |
  sed -E 's/$/<\/font><br>/' |
  sed -E 's/-!-/<\/font><font color="#aaaaaa">-!-<\/font><font color="#666666">/' |
  sed -E 's/(&lt;.*&gt;)/<font color="#eab72c">\1<\/font><font color="#aaaaaa">/'|
  sed -E 's/^/<font color="#bb2222">/' > logs.tmp

# Create the calendar, complete with links to other days.

# What month is it?  $date is in YYYYMMDD format.
date=`basename $newestlog .log | sed 's/^\#mlpack.//'`;

# Split the date apart.
year=`echo $date | sed -E 's/^([0-9]{4})[0-9]*/\1/'`;
month=`echo $date | sed -E 's/^[0-9]{4}([0-9]{2})[0-9]*/\1/'`;
day=`echo $date | sed -E 's/^[0-9]{6}([0-9]{2})/\1/'`;

# Get the weekday corresponding to the first day of the month.
daynames=('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat');
dow=`date --date="${year}${month}01" '+%w'`;
monthname=`date --date="$date" '+%B'`;
daysinmonth=`cal $month $year | grep '[^ ]' | tail -1 | awk -F' ' '{ print $NF }'`;

# Generate the first row of the calendar table for this month.  We'll use divs
# because divs are the future and HTML table tags make people cringe.  This is
# probably the only non-cringeworthy decision I've made in this entire system.

# Create the calendar itself, with links to last month and next month.
echo "<div class=\"irccal\"><div class=\"irccaltop\">" > cal.tmp;
lastyear=$year;
lastmonth=$(($month - 1));
if [ "$lastmonth" -eq "0" ]; then
  lastyear=$(($year - 1));
  lastmonth="12";
fi
if [ "$lastmonth" -lt "10" ]; then
  lastmonth="0$lastmonth";
fi

# Does anything from last month exist?
if [ -a "$htmldir/mlpack.${lastyear}${lastmonth}${day}.html" ]; then
  linkto="mlpack.${lastyear}${lastmonth}${day}.html";
else
  list=`ls $htmldir/mlpack.${lastyear}${lastmonth}*.html 2>/dev/null | wc -l`;
  if [ "a$list" = "a0" ]; then
    # Nothing exists.  No link.
    linkto="";
  else
    # Link to oldest.
    linkto=`ls -t $htmldir/mlpack.${lastyear}${lastmonth}*.html | tail -1`;
    linkto=`basename $linkto`;
  fi
fi

if [ "a$linkto" = "a" ]; then
  echo "<div class=\"irccalnavleft\">&lt;</div>" >> cal.tmp;
else
  echo "<div class=\"irccalnavleft\"><a href=\"${linkto}\">&lt;</a></div>" >> cal.tmp;
fi

# Does anything from next month exist?
nextyear=$year;
nextmonth=$(($month + 1));
if [ "$nextmonth" -eq "13" ]; then
  nextyear=$(($year + 1));
  nextmonth=1;
fi
if [ "$nextmonth" -lt "10" ]; then
  nextmonth="0$nextmonth";
fi

if [ -a "$htmldir/mlpack.${nextyear}${nextmonth}${day}.html" ]; then
  linkto="mlpack.${nextyear}${nextmonth}${day}.html";
else
  list=`ls $htmldir/mlpack.${nextyear}${nextmonth}*.html 2>/dev/null | wc -l`;
  if [ "a$list" = "a0" ]; then
    linkto="";
  else
    # Link to newest.
    linkto=`ls -t $htmldir/mlpack.${nextyear}${nextmonth}*.html | head -1`;
    linkto=`basename $linkto`;
  fi
fi

if [ "a$linkto" = "a" ]; then
  echo "<div class=\"irccalnavright\">&gt;</div>" >> cal.tmp;
else
  echo "<div class=\"irccalnavright\"><a href=\"$linkto\">&gt;</a></div>" >> cal.tmp;
fi

echo "<div class=\"irccalmonth\">$monthname $year</div>" >> cal.tmp;

# The header row.
echo "</div><div class=\"irccalheaderrow\">" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Sun</div>" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Mon</div>" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Tue</div>" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Wed</div>" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Thu</div>" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Fri</div>" >> cal.tmp;
echo "<div class=\"irccalheadercell\">Sat</div>" >> cal.tmp;

echo "</div>" >> cal.tmp;

# Now the first row.
echo "<div class=\"irccalrow\">" >> cal.tmp;

# Fill in spaces where there isn't a day.
cellid=0;
for i in `seq 0 $((dow - 1))`;
do
  echo "<div class=\"irccalinvalidcell\">&nbsp;</div>" >> cal.tmp;
  cellid=$((cellid + 1)); # Not possible for this to be more than 6.
done

# Now fill in all the days from the first of the month to the current day of the
# month minus one.
for i in `seq 1 $((day - 1))`;
do
  # Do we need a new row?
  cellid=$((cellid + 1));
  if [ "$cellid" -eq "7" ]; then
    cellid=0;
    # Set up new row.
    echo "</div><div class=\"irccalrow\">" >> cal.tmp;
  fi

  # The cell we are putting information into.
  echo "<div class=\"irccalcell\">" >> cal.tmp;

  # We want the day number, with a hyperlink to that day's log.
  # This path is hardcoded...
  if [ "$i" -lt "10" ]; then
    echo "<a href=\"mlpack.${year}${month}0${i}.html\">$i</a>" >> cal.tmp;
  else
    echo "<a href=\"mlpack.${year}${month}${i}.html\">$i</a>" >> cal.tmp;
  fi

  # Close the cell.
  echo "</div>" >> cal.tmp;
done

# Today's link.
cellid=$((cellid + 1));
if [ "$cellid" -eq "7" ]; then
  cellid=0;
  echo "</div><div class=\"irccalrow\">" >> cal.tmp;
fi
adjday=`echo $day | sed 's/^[0]*//'`;
echo "<div class=\"irccalactivecell\">$adjday</div>" >> cal.tmp;

# The rest of the days in the month, which don't exist yet.
for i in `seq $((day + 1)) $daysinmonth`;
do
  # Do we need a new row?
  cellid=$((cellid + 1));
  if [ "$cellid" -eq "7" ]; then
    cellid=0;
    echo "</div><div class=\"irccalrow\">" >> cal.tmp;
  fi

  # The cell we are putting information into.
  echo "<div class=\"irccalfuturecell\">$i</div>" >> cal.tmp;
done


# Close the calendar.
echo "</div><div class=\"separator\"></div>" >> cal.tmp;
echo "<div class=\"irccalallnav\"><a href=\"logs-all.html\">list of all logs</a></div></div>" >> cal.tmp;

# Put the files together.
cat $htmldir/templates/header.html cal.tmp logs.tmp $htmldir/templates/footer.html > $htmldir/logs.html
