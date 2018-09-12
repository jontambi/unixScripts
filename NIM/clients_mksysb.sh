#!/bin/ksh

#Directorio root mksysb
ROOT_MKSYSB=/export/mksysb

#Crea directorios si no existen
[ -d $ROOT_MKSYSB/actual ] || mkdir $ROOT_MKSYSB/actual
[ -d $ROOT_MKSYSB/anterior ] || mkdir $ROOT_MKSYSB/anterior

echo " "
echo "Listar los grupos"
echo " "
lsnim -t mac_group |awk {'print $1'}
echo " "
echo "Ingresar el nombre de grupo: "
read MAC_GROUP

echo " "
echo "Listar lpp_source"
#lsnim -t lpp_source | awk {'print $1'} |grep lpp
lsnim -t lpp_source | awk -F "_" {'print $2'} |grep lpp |awk {'print $1'}
echo " "
echo "Seleccionar lpp_source: "
read LPP_SOURCE
echo " "
OSLEVEL=`lsnim -l spot_$LPP_SOURCE |grep oslevel_s |awk {'print $3'}`


echo "Iniciando proceso de respaldo mksysb..."
echo " "
#Genera mksysb de los clientes de un grupo especificado
for mac in `lsnim -l $MAC_GROUP |grep member |awk {'print $3'} | sort`
do
  MKSBASE=$ROOT_MKSYSB/actual/$mac
  MKSCLIENT="$mac"_mksysb
  #Verificar si se puede ejecutar mksysb en el cliente
  nim -o lslpp $mac >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Existe un problema con la comunicacion con el cliente $mac, o la configuracion NIM esta incorrecta. Se procedera con el backup del siguiente cliente"
    continue
  fi
  echo "$mac"
  echo " "
  #Eliminar mksysb del cliente
  lsnim $MKSCLIENT >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Copiando mksysb anterior al directorio $ROOT_MKSYSB/anterior "
    nim -o remove $MKSCLIENT
    [ -f $MKSBASE ] && mv -f $MKSBASE $ROOT_MKSYSB/anterior/
  fi

  #Crear mksysb del cliente
  echo "Iniciando ejecucion de mksysb para $mac..."
  echo " "
  nim -o define -t mksysb -a server=master -a location=$MKSBASE -a source=$mac -a mk_image=yes -a mksysb_flags=emi -a comments="Ejecutado en '$(date)'" $MKSCLIENT
  if [ $? -ne 0 ]; then
    echo "mksysb en el cliente $mac no se ejecuto correctamente, puede contener errores."
    continue
  fi
  echo "mksysb en el cliente $mac se ejecuto correctamente"
  echo " "

  #Intalar FixPack en el cliente nim
  echo "Iniciando instalacion de fixpack AIX"
  echo " "
  nim -o cust -a lpp_source=$LPP_SOURCE -a accept_licenses=yes -a fixes=update_all  $mac
  if [ $? -ne 0 ]; then
    echo "Se provoco un error al aplicar el Fix $LPP_SOURCE. Verificar el funcionamiento del cliente $mac"
    continue
  fi
  OSLEVEL_MAC=`/usr/lpp/bos.sysmgt/nim/methods/m_cust -a script=oslevel_status $mac`
  if [ $OSLEVEL_MAC -ne $OSLEVEL ]; then
    nim -o cust -a lpp_source=$LPP_SOURCE -a accept_licenses=yes -a fixes=update_all  $mac
  fi
  echo "La actualizacion del cliente $mac termino satisfactoriamente."
done
