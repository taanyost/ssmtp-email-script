#!/bin/bash
#daily report email script that gets piped to ssmtp via statusmail1.sh

#writes hddtemp output to temporary text file and then sets that output to a variable
#so that specific rack position can be appended to the printed line
hddtemp -w /dev/sda >> /scripts/sdatemp.txt
hddtemp -w /dev/sdb >> /scripts/sdbtemp.txt
hddtemp -w /dev/sdc >> /scripts/sdctemp.txt
hddtemp -w /dev/sdd >> /scripts/sddtemp.txt
hddtemp -w /dev/sde >> /scripts/sdetemp.txt
hddtemp -w /dev/sdf >> /scripts/sdftemp.txt
hddtemp -w /dev/sdg >> /scripts/sdgtemp.txt

#writes lm-sensors output to temporary text file and uses grep to pull only important information back
sensors >> /scripts/sensorstemp.txt

#global variables
sda=$(</scripts/sdatemp.txt)
sdb=$(</scripts/sdbtemp.txt)
sdc=$(</scripts/sdctemp.txt)
sdd=$(</scripts/sddtemp.txt)
sde=$(</scripts/sdetemp.txt)
sdf=$(</scripts/sdftemp.txt)
sdg=$(</scripts/sdgtemp.txt)

echo "From: ******** Server"
echo "Subject: ******** Daily Report"
echo    "Administrator,"
echo -e
echo    "This email is the daily status report for the ******** server."
#include system time in report
echo -n "The local system time is: "&date +%c
echo -e
#uses DNS resolver to print IP address for reference by administrator if server is not assigned a static IP
echo -n "The local IP address is: "&dig +short myip.opendns.com @resolver1.opendns.com
echo -e
echo    "******** Drive Temperatures:"
echo -e
echo    "Drive(s) mounted @ /"
echo    $sdg"(Rack 7)"
echo -e
echo    "Drive(s) mounted @ /name1"
echo    $sda"(Rack 1)"
echo    $sdb"(Rack 2)"
echo    $sdc"(Rack 3)"
echo -e
echo    "Drive(s) mounted @ /name2"
echo    $sdd"(Rack 4)"
echo    $sde"(Rack 5)"
echo    $sdf"(Rack 6)"
echo -e
echo    "******** System Temperatures:"
echo -e
grep CPU /scripts/sensorstemp.txt
grep Motherboard /scripts/sensorstemp.txt
echo -e
echo    "******** Zpool Error Status:"
echo -e
#list mounted zpool status, -x displays only if all pools are healthy
zpool status -x
echo -e
echo    "******** Zpool Capacity:"
echo -e
#list mounted zpool information, -Ho modifies options to display to listed column headers and keeps header spacing constant
zpool list -Ho name,size,alloc,health
echo -e
echo    "END OF REPORT"
echo    "******** Server created by **** | 2020"
#remove temporary text files
rm /scripts/sd*temp.txt
rm /scripts/sensorstemp.txt
