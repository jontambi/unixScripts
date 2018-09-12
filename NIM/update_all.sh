#!/bin/ksh
for mac in `lsnim -t standalone | awk '{print $1}' | sort`
do
  echo $mac
  nim -o remove $mac_mksysb

  nim -o define -t mksysb -a server=master -a location=/export/mksysb/semanal_mksysb -a mk_image=yes -a mksysb_flags=em $mac_mksysb

  nim –o cust –a lpp_source=lppsource_71tl4sp5 –a accept_licenses=yes –a fixes=update_all  $mac
  echo " "
done
