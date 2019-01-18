#!/usr/bin/env python
import os, sys, socket
import time

# Definir nombre servidor e instancias IBv10
server01 = "PPECBPIB01"
server02 = "PPECBPIB02"
qm01 = "TCSRBRK_BP1"
qm02 = "TCSRBRK_BP2"
ib01 = "TCSBRKR1_BP"
ib02 = "TCSBRKR1_BP"

# Obtener nombre de servidor
myhost = socket.gethostname()

# Funcion que verifica cuando todos los procesos del Bus estan detenidos
def stop_ib10(appname):
    comando = os.popen("ps -Af |grep low").read()
    procesos = comando.count(appname)
    while procesos > 0:
        print("Numero de procesos pendientes: " + str(procesos))
        comando = os.popen("ps -Af |grep low").read()
        procesos = comando.count(appname)
        time.sleep(2)
    return

if myhost == server01:
    mq = qm01
    ib = ib01
elif myhost == server02:
    mq = qm02
    ib = ib02

os.system("mqsistop " + ib)
stop_ib10(appname = ib)

os.system("endmqm -w " + mq)
stop_ib10(appname = mq)

print("IBM Integration Bus", ib, "detenido exitosamente.")
