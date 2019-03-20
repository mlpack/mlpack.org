#!/bin/bash
# create-stdout-calendar.sh
#
# Generate the HTML for the calendar and dump it to stdout.  This assumes that
# links to the other mlpack log files will work.

# Name of the log file to generate the calendar from.  We only use the date in
# the filename.
logfile=$1;

# Directory containing other logs.
logdir=$2;

if [ "a$logfile" = "a" ]; then
  echo "Must specify log file as first parameter."
  exit
fi

if [ "a$logdir" = "a" ]; then
  echo "Must specify logs directory as second parameter."
  exit
fi

# What month is it?  $date is in YYYYMMDD format.
date=`basename $logfile .log | sed 's/^\#mlpack.//'`;

# Split the date apart.
year=`echo $date | sed -E 's/^([0-9]{4})[0-9]*/\1/'`;
month=`echo $date | sed -E 's/^[0-9]{4}([0-9]{2})[0-9]*/\1/'`;
monno=`echo $month | sed 's/^0//'`; # Remove a leading zero.
day=`echo $date | sed -E 's/^[0-9]{6}([0-9]{2})/\1/'`;
dayno=`echo $day | sed 's/^0//'`; # Remove a leading zero.

# Get the weekday corresponding to the first day of the month.
daynames=('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat');
dow=`date --date="${year}${month}01" '+%w'`;
monthname=`date --date="$date" '+%B'`;
daysinmonth=`cal $month $year | grep '[^ ]' | tail -1 | awk -F' ' '{ print $NF }'`;

# Generate the first row of the calendar table for this month.  We'll use divs
# because divs are the future and HTML table tags make people cringe.  This is
# probably the only non-cringeworthy decision I've made in this entire system.

# Create the calendar itself, with links to last month and next month.
echo "<div class=\"irccal\"><div class=\"irccaltop\">";
lastyear=$year;
lastmonno=$(($monno - 1));
if [ "$lastmonno" -eq "0" ]; then
  lastyear=$(($year - 1));
  lastmonno="12";
fi
if [ "$lastmonno" -lt "10" ]; then
  lastmonth="0$lastmonno";
else
  lastmonth="$lastmonno";
fi

# Does anything from last month exist?
if [ -a "$logdir/#mlpack.${lastyear}${lastmonth}${day}.log" ]; then
  linkto="mlpack.${lastyear}${lastmonth}${day}.html";
else
  list=`ls $logdir/#mlpack.${lastyear}${lastmonth}*.log 2>/dev/null | wc -l`;
  if [ "a$list" = "a0" ]; then
    # Nothing exists.  No link.
    linkto="";
  else
    if [ "${day}" -ge "29" ]; then
      # Link to the newest; the number of days in the previous month is
      # different.
      linkto=`ls -t $logdir/#mlpack.${lastyear}${lastmonth}*.log | sed 's/#//' | head -1`;
      linkto=`basename $linkto .log`;
      linkto="${linkto}.html";
    else
      # Link to oldest.
      linkto=`ls -t $logdir/#mlpack.${lastyear}${lastmonth}*.log | sed 's/#//' | tail -1`;
      linkto=`basename $linkto .log`;
      linkto="${linkto}.html";
    fi
  fi
fi

if [ "a$linkto" = "a" ]; then
  echo "<div class=\"irccalnavleft\">&lt;</div>";
else
  echo "<div class=\"irccalnavleft\"><a href=\"${linkto}\">&lt;</a></div>";
fi

# Does anything from next month exist?
nextyear=$year;
nextmonno=$(($monno + 1));
if [ "$nextmonno" -eq "13" ]; then
  nextyear=$(($year + 1));
  nextmonno="1";
  nextmonth="1";
fi
if [ "$nextmonno" -lt "10" ]; then
  nextmonth="0$nextmonno";
else
  nextmonth="$nextmonno";
fi

if [ -a "$logdir/#mlpack.${nextyear}${nextmonth}${day}.log" ]; then
  linkto="mlpack.${nextyear}${nextmonth}${day}.html";
else
  list=`ls $logdir/#mlpack.${nextyear}${nextmonth}*.log 2>/dev/null | wc -l`;
  if [ "a$list" = "a0" ]; then
    linkto="";
  else
    # Link to newest.
    linkto=`ls -t $logdir/#mlpack.${nextyear}${nextmonth}*.log | sed 's/#//' | head -1`;
    linkto=`basename $linkto .log`;
    linkto="${linkto}.html";
  fi
fi

if [ "a$linkto" = "a" ]; then
  echo "<div class=\"irccalnavright\">&gt;</div>";
else
  echo "<div class=\"irccalnavright\"><a href=\"$linkto\">&gt;</a></div>";
fi

echo "<div class=\"irccalmonth\">$monthname $year</div>";

# The header row.
echo "</div><div class=\"irccalheaderrow\">";
echo "<div class=\"irccalheadercell\">Sun</div>";
echo "<div class=\"irccalheadercell\">Mon</div>";
echo "<div class=\"irccalheadercell\">Tue</div>";
echo "<div class=\"irccalheadercell\">Wed</div>";
echo "<div class=\"irccalheadercell\">Thu</div>";
echo "<div class=\"irccalheadercell\">Fri</div>";
echo "<div class=\"irccalheadercell\">Sat</div>";

echo "</div>";

# Now the first row.
echo "<div class=\"irccalrow\">";

# Fill in spaces where there isn't a day.
cellid=0;
for i in `seq 0 $((dow - 1))`;
do
  echo "<div class=\"irccalinvalidcell\">&nbsp;</div>";
  cellid=$((cellid + 1)); # Not possible for this to be more than 6.
done

# Now fill in all the days from the first of the month to the current day of the
# month minus one.
for i in `seq 1 $(($dayno - 1))`;
do
  # Do we need a new row?
  cellid=$((cellid + 1));
  if [ "$cellid" -eq "7" ]; then
    cellid=0;
    # Set up new row.
    echo "</div><div class=\"irccalrow\">";
  fi

  # The cell we are putting information into.
  echo "<div class=\"irccalcell\">";

  # We want the day number, with a hyperlink to that day's log.
  # This path is hardcoded...
  if [ "$i" -lt "10" ]; then
    # Does this log day exist?
    if [ -a "$logdir/#mlpack.${year}${month}0${i}.log" ]; then
      echo "<a href=\"mlpack.${year}${month}0${i}.html\">$i</a>";
    else
      echo "$i" >> $outfile;
    fi
  else
    if [ -a "$logdir/#mlpack.${year}${month}${i}.log" ]; then
      echo "<a href=\"mlpack.${year}${month}${i}.html\">$i</a>";
    else
      echo "$i";
    fi
  fi

  # Close the cell.
  echo "</div>";
done

# Today's link.
cellid=$((cellid + 1));
if [ "$cellid" -eq "7" ]; then
  cellid=0;
  echo "</div><div class=\"irccalrow\">";
fi
echo "<div class=\"irccalactivecell\">$dayno</div>";

# The rest of the days in the month.
for i in `seq $(($dayno + 1)) $daysinmonth`;
do
  # Do we need a new row?
  cellid=$((cellid + 1));
  if [ "$cellid" -eq "7" ]; then
    cellid=0;
    echo "</div><div class=\"irccalrow\">";
  fi

  # The cell we are putting information into.
  echo "<div class=\"irccalcell\">";
  if [ "$i" -lt "10" ]; then
    if [ -a "$logdir/#mlpack.${year}${month}0${i}.log" ]; then
      echo "<a href=\"mlpack.${year}${month}0${i}.html\">$i</a>";
    else
      echo "$i";
    fi
  else
    if [ -a "$logdir/#mlpack.${year}${month}${i}.log" ]; then
      echo "<a href=\"mlpack.${year}${month}${i}.html\">$i</a>";
    else
      echo "$i";
    fi
  fi
  echo "</div>";
done


# Close the calendar.
echo "</div><div class=\"separator\"></div>";
echo "<div class=\"irccalallnav\"><a href=\"logs-all.html\">list of all logs</a></div></div>";
