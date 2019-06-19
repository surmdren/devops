#!/bin/ksh
##OS Class
OS=`uname`

while read line
    do
        if [ $OS = Linux ]
        then
            /usr/bin/chage -d 2019-06-12 $line
            /usr/bin/chage -M 90 $line
        elif [ $OS = AIX ]
        then
            sudo chsec -f /etc/security/passwd -s $line -a lastupdate=1560268800
            sudo chsec -f /etc/security/user -s $line -a maxage=13
        fi
    done < /home/ysurmd/ansible/squad/user.txt
