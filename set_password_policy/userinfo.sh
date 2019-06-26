#!/bin/ksh
##OS Class
OS=`uname`
server=`uname -n`
timestamp=`date +%Y%m%d`

cat /dev/null > /tmp/userinfo/user.nonexpired.txt
cat /dev/null > /tmp/userinfo/user.fullname.txt
cat /dev/null > /tmp/userinfo/user.emailinfo.txt
cat /dev/null > /tmp/userinfo/user.nonpasswd.txt
##Collect the non-expired user information
if [ $OS = Linux ]
then
    cat /etc/passwd | awk -F : '{print $1}' > user.$server.$timestamp.txt
    sudo cat /etc/shadow | grep -E ':\*:|:!:|:!!:|:x:' | awk -F : '{print $1}' >> /tmp/userinfo/user.nonpasswd.txt
elif [ $OS = AIX ]
then
    sudo lsuser -a maxage ALL | grep maxage=0 | awk '{print $1}' > user.$server.$timestamp.txt
    sudo cat /etc/security/passwd > /tmp/userinfo/passwd_aix.txt
fi

while read line
    do
        if [ $OS = Linux ]
        then
            ##Get the Maximum age of the user then check it value is 9999 or not.
            cmd_result=$(sudo chage -l $line | grep -i Maximum | sed s/[[:space:]]//g | awk -F : '{print $2}')
            echo $cmd_result
            if [[ $cmd_result -eq 99999 ]]
            then
                ##Save the non-expired id to user.nonexpired.$server.$timestamp.txt
                ##non-expired id email information to user.emailinfo.$server_$timestamp.txt
                echo $line >> /tmp/userinfo/user.nonexpired.txt
                cat /etc/passwd | grep -w "^$line" | awk -F : '{print $5}' >> /tmp/userinfo/user.fullname.txt
                cat /etc/passwd | grep -w  "^$line" | awk -F : '{print $5}' | awk -F / '{print $6}' >> /tmp/userinfo/user.emailinfo.txt
            fi
        elif [ $OS = AIX ]
        then
            ##Save the non-expired id to user.nonexpired.$server.$timestamp.txt
            ##non-expired id email information to user.emailinfo.$server_$timestamp.txt
            echo $line  >> /tmp/userinfo/user.nonexpired.txt
            cat /etc/passwd | grep -w "^$line" | awk -F : '{print $5}' >> /tmp/userinfo/user.fullname.txt
            cat /etc/passwd | grep -w "^$line" | awk -F : '{print $5}' | awk -F / '{print $6}' >> /tmp/userinfo/user.emailinfo.txt
        fi
    done < user.$server.$timestamp.txt
