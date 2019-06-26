#!/bin/ksh
##OS Class
OS=`uname`

if [ $OS = Linux ]
then
    echo "$1:*" | sudo /usr/sbin/chpasswd -e
elif [ $OS = AIX ]
then 
    echo "$1:*" | sudo chpasswd -c -e
fi
