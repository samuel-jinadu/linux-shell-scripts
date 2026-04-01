#!/bin/sh

# a script that upon invocation shows the time and date, lists all logged-in users, and gives the system uptime, then saves this information to a logfile
$LOGFILE="$HOME/sys-info.log"
echo "Report generated at '$(date)'" | tee -a $LOGFILE
echo "Logged-in users:" | tee -a $LOGFILE
users | tee -a $LOGFILE
uptime -p | tee -a $LOGFILE
echo "" >> $LOGFILE
