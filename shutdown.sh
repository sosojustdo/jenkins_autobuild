#!/bin/bash
source /etc/profile

echo -e "\033[32;49;1m===================stop $1 beging=========================================================================================\033[39;49;0m"

count=0
while true
do
	((count++))
	if [ $count -gt 50 ]
	then
	   echo -e "\033[31;49;1m===================stop $1 fail===========================================================================================\033[39;49;0m"
	   break
	else
		sleep 1
		echo -e "\033[32;49;1m===================stop $1 doing============================================================================================\033[39;49;0m"
	    pro=`ps aux|grep $1|grep -v grep | grep java |awk '{print $2}'`
	   	if [ ! $pro ]
	   	then 
	   		echo -e "\033[32;49;1m===================stop $1 sucess===============================================================================================\033[39;49;0m"
			break
		else  
		  	for i in $pro
			do
			    kill -9 $i
			done
		fi
	fi  
done


