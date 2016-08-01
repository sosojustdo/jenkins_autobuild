#!/bin/bash

echo "tomcat base path:"$1
echo "project name:"$2
echo "tomcat instance name:"$3
tomcat_base_path=$1
project_name=$2
tomcat_instance_name=$3

sh $tomcat_base_path/bin/startup.sh
 
echo -e "\033[32;49;1m===================tomcat heath check beging!================================================================================================\033[39;49;0m"

count=0
while true
do
	((count++))
	if [ $count -gt 120 ]
	then
		cd $tomcat_base_path/logs
	    echo -e "\033[31;49;1m===================tomcat heath check fail, please login server resolver!====================================================================\033[39;49;0m"
	    echo -e "\033[31;49;1m `tail -100 catalina.out` \033[39;49;0m"
	    break
	else
		sleep 1
	    echo -e "\033[32;49;1m===================tomcat heath check doing!================================================================================================\033[39;49;0m"
	    pid=`ps aux|grep $3|grep -v grep | grep java |awk '{print $2}'`
	    tomcat_port='0'
	   	if [ $pid ]
	   	then 
	   		port_info=`netstat -anp|grep $pid | awk 'NR==1{print $4}'`
	   		if [ $port_info ]
	   		then
	   			port=${port_info:8}   			
	   			#exclude dubbo port
	   			if [[ ${port:0:2} -eq "80" ]]
				then
					tomcat_port = $port
				else
					port_info_1=`netstat -anp|grep $pid | awk 'NR==2{print $4}'`
					if [ $port_info_1 ]
					then
						tomcat_port=${port_info_1:8}
					fi
				fi
	   			heath_check_url="http://127.0.0.1:"${tomcat_port}/${project_name}/"home.html"
	   			http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code} $heath_check_url`
	   			if [ $http_code -eq 200 ]
	   			then
	   				echo -e "\033[32;49;1m===================tomcat heath check success!================================================================================================\033[39;49;0m"
	   				break
	   			fi
	   		fi
		fi
	fi  
done


