#!/bin/ksh
for mac in `lsnim -t standalone | awk '{print $1}' | sort`
do
echo $mac
/usr/lpp/bos.sysmgt/nim/methods/m_cust -a script=status_client $mac
echo " "
done
