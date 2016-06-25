#!/bin/bash

JAVA_HOME=/usr/lib/jvm/jdk1.6.0_45
export JAVA_HOME
### not run ssh dev1 "cd /home ; ls ;/bin/echo 'hello $1' ;/sbin/ifconfig" 
#/home/d/tools/bin/dbs_tomcat.sh /home/d/jenkins/workspace/price-api 10.255.209.147 priceapi priceapi
echo "p1=$1 p2=$2 p3=$3 p4=$4"
workspace=$1
server=$2
targetFileName=$3
scpFiles=$4
tomcatbase="/home/d/www/jobs"
#scp files to target machine temp 
#scp -r $workspace/$scpFiles $server:~/temp/
#kill process
ssh jenkins@$server "/home/d/tools/bin/shutdown.sh $targetFileName"
ssh jenkins@$server "rm -rf $tomcatbase/$targetFileName"
ssh jenkins@$server "mkdir $tomcatbase/$targetFileName"
scp -r $workspace/$scpFiles/* $server:$tomcatbase/$targetFileName

echo "++++++++++++++++++++++++++++++++++++++++"
echo "+                                      +"
echo "+                                      +"
echo "+         finished copy files          +"
echo "+                                      +"
echo "+                                      +"
echo "++++++++++++++++++++++++++++++++++++++++"


#login remote machine
echo "will login $server"
ssh jenkins@$server   << remotetags  

echo "login $server sucess"
ifconfig

#run server
cd $tomcatbase/$targetFileName
# nohup /bin/sh ./bin/startup.sh &
nohup /bin/sh ./bin/startup.sh start > /dev/null 2>&1 &

pwd
ls -la $tomcatbase/$targetFileName
echo "+++++++++++++++++Server Started++++++++++++++++++++"
sleep 0.2
ps -ef | grep $targetFileName

echo "will exit from $server"
exit 0
remotetags



