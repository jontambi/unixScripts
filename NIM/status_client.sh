#!/bin/ksh

#Verifica OSLEVEL
oslevel -sq | awk 'NR==1'
