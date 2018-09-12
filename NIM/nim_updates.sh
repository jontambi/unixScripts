#!/bin/ksh

#lsnim -c machines > NIMMACHINES.txt
#lsnim -c machines | grep -v master | awk '{print $1}' > /admin/scripts/MKSYSB/NIMMACHINES.txt

NIMCLIENTS=/admin/scripts/MKSYSB/NIMMACHINES.txt
fecha=$(date +%Y%m%d_%H%m%S)

while read line
do
  echo "Working on mksysb_$line ..."
  #Elimina el spot anterior
  nim -o remove spot_${line} > /dev/null 2>&1 &
  wait
  #Elimina el mksysb anterior.
  nim -o remove mksysb_${line} > /dev/null 2>&1 &
  wait
  /admin/scripts/MKSYSB/runMKSYSB.sh $line &
  sleep 2
done < $NIMCLIENTS
