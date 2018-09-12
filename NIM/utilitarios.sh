Hi,

You can use this: /usr/lpp/bos.sysmgt/nim/methods/m_cust -a script=+NIM_Script+ Server

It works without problems from years at my office. I use it in this kind of script:
for mac in `lsnim -t standalone | awk '{print $1}' | sort`
do
echo $mac
/usr/lpp/bos.sysmgt/nim/methods/m_cust -a script=NIM_Script $mac
echo " "
done

nim -o define -t script -a server=master -a location=/admin/scripts/status_client.sh  status_client
