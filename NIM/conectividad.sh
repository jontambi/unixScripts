#!/bin/ksh
for srv in `lsnim -t standalone | awk '{print $1}' | sort`
do
  printf "%-20s" $srv
  nim -o lslpp $srv >/dev/null 2>&1
  [ "$?" == 0 ] && echo OK || echo "Problem"
done
