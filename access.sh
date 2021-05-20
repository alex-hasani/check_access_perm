#!/bin/bash

### To check the last access

echo "Enter the Work Order Number: "
read wo_no
mkdir ./"$wo_no"
chmod ug+rwx ./"$wo_no"
cd ./"$wo_no"
while read line
do
        echo "Enter requester's -a account: "
        read req_name
        a =  last | grep -e $req_name | awk '{ print $1 }' | sort -u
        if [[ $req_name eq $a ]]
        then
                echo "The user has logged in the server before." > ./result.txt
                access_group = cat /etc/security/access.conf | grep -e ^+:@ | grep -v +:@itnix @global-users:ALL | grep -v -:ALL:ALL
                b = getent netgroup $access_group | grep -e $req_name
                if [[ $b == *"$req_name"* ]]
                then
                        echo "$b" >> ./result.txt
                        echo "The user is already in the netgroup" >> ./result.txt
                fi
        else
                getent netgroup $access_group | grep -e $req_name >> ./result.txt
                echo "The user has not been found in the last login list." > ./result.txt
        fi
        exit
done < ../servers.txt

