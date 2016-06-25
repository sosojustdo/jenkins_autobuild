#!/bin/sh

echo "Please enter target server ip"
read ip
pub=`cat ~/.ssh/id_rsa.pub`
ssh root@$ip   << code
	ifconfig | grep "Bcast"
	cd ~
	if [ -d .ssh ];then
            echo "/root/.ssh exist"
	else
	    echo "/root/.ssh not exist ,will mkdir .ssh"
	    mkdir .ssh
	fi
	echo "$pub" >> .ssh/authorized_keys
	chmod 700 .ssh
    chmod 600 .ssh/authorized_keys
	echo "Auth $username no pass login sucess"
code
echo "auth finished"