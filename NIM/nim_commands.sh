#LISTING ALL DEFINED NIM OBJECTS
lsnim

#LISTING ALL DEFINED OBJECTS OF A SPECIFIC TYPE
lsnim -t <type>

#SHOWING AN OBJECT'S DEFINITION
lsnim -l <object>

#DEFINING AN LPP SOURCE
nim -o define -t lpp_source -a server=master -a location=</path/to/bffs> -a comments=<free text> <lpp source>

#DEFINING A NETWORK
nim -o define -t ent -a net_addr=<netaddress> -a snm=<netmask> -a routing1="default <gateway>" <network>

#DEFINING A NIM CLIENT
"nim -o define -t standalone -a platform=chrp -a netboot_kernel=64 -a if1="<network> <ip label> 0 ent" -a cable_type1=tp <client>"
"You could also use an ip address instead of an ip label here"

#DEFINING AN MKSYSB RESOURCE
"nim -o define -t mksysb -a server=master -a comments="<free text>" -a location=<directory> <mksysb>"

#DEFINING AN IMAGE_DATA RESOURCE
"nim -o define -t image_data -a server=master -a comments="<free text>" -a location=</path/to/image_data> <image_data>"

#CREATING A SPOT FROM AN LPP SOURCE
"nim -o define -t spot -a server=master -a source=<lpp source> -a location=<directory> -a comments="<free text>" <spot>"

#CREATING A SPOT FROM AN MKSYSB
"nim -o define -t spot -a server=master -a source=<mksysb> -a location=<directory> -a comments="<free text>" <spot>"

Use the base directory for your spots here rather than a spot specific directory. NIM automatically creates a subdirectory with the name of the spot object: <spot>

#PREPARE SPOT AND LPP SOURCE FOR AN ALTERNATE DISK MIGRATION
"nimadm -M -s <spot> -l <lpp source> -d <source directory>"

In <source directory> NIM searches for the two filesets «bos.alt_disk_install.rte» and «bos.alt_disk_install.boot_images». nimadm then updates spot and LPP source with these two filesets. This way you can migrate a client to a lower AIX level then the level of the NIM server itself. This feature has been added to NIM with AIX 7.1.

#MODIFYING A CLIENT DEFINITION
"nim -o change -a <attribute>=<value> <client>"
You find the exact names of valid attributes in the output of lsnim -l <client>. The option change is used to change the value of an attribute, e.g. if you want to change a clients netboot kernel from 64 to mp you would type:
"nim -o change -a netboot_kernel=mp <client>"

#RE-INITIALIZING A CLIENT
If a clients /etc/niminfo is out of date. It can be rewritten by the below procedure:

client# "rm /etc/niminfo"
client# "niminit -a name=<client> -a master=<nimserver> -a connect=nimsh"

This procedure is useful if you want to move a client from one NIM server to another. In this case remember to first create the client on the server before running this procedure.
"-a connect=nimsh" is optional and only required if you dont want the NIM server to communicate via rsh with the client.

#INSTALLING A CLIENT
"nim -o bos_inst -a spot=<spot> -a lpp_source=<lpp source> -a fb_script=<script> -a script=<postinstall script> -a no_client_boot=yes -a accept_licenses=yes <client>"

Use the option no_client_boot=yes if you dont want NIM to initiate a reboot of your LPAR over rsh. You have to manually boot the LPAR from the SMS menu then - what is probably what you want.
#INSTALLING A CLIENT WITH AN MKSYSB IMAGE
"nim -o bos_inst -a source=mksysb -a spot=<spot> -a mksysb=<mksysb> -a lpp_source=<lpp source> -a fb_script=<script> -a script=<postinstall script> -a no_client_boot=yes -a accept_licenses=yes <client>"

#RESET A NIM CLIENT
"nim -F -o reset <client>"

resets a NIM client so new operations can be done. Please note that often its not enough to just reset a NIM object because there are still resources allocated for the client. You find all resources still allocated to the client with lsnim -l <client>. They can be removed with:
"nim -o deallocate -a spot=<spot> -a ...=... <client>"

To remove all resources from a client simply run:
"nim -o deallocate -a subclass=all <client>"

#QUERY A CLIENT FOR INSTALLED APARS
"nim -o fix_query <client>"

This command is useful to check for your nimserver can reach the client.
#ENABLING A MAINTENANCE BOOT
"nim -o maint_boot -a spot=<spot> <client>"

Now you can boot your client over the network into a maintenance shell.
#START AN ALTERNATE DISK MIGRATION
"nimadm -c <client> -l <lpp source> -s <spot> -d <hdisk> -Y"

#DEFINE A GROUP
"nim –o define –t mac_group –a add_member=sp-tsm2 speedy_mac_group"

#DEFINE script
"nim -o define -t script -a server=master -a location=/export/nim/postscripts/postinstall.sh  postinstall-script"

#DEFINE fb_script
nim -o define -t fb_script -a server=master -a location=/export/nim/script_res/myscript.sh fb_script1
