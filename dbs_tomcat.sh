#!/bin/bash

JAVA_HOME=/usr/local/jdk7
export JAVA_HOME
### not run ssh dev1 "cd /home ; ls ;/bin/echo 'hello $1' ;/sbin/ifconfig" 

echo -e "\033[32;49;1m p1=$1 p2=$2 p3=$3 p4=$4 p5=$5 \033[39;49;0m"
workspace=$1
server=$2
targetFileName=$3
scpFiles=$4
tomcatbase="/usr/local"
#scp files to target machine temp 

profile=""
if [[ $targetFileName =~ "dev" ]]
then
  profile="dev"
elif [[ $targetFileName =~ "test" ]]
then
  profile="test"
else
  profile=""
fi


mvn -B -f /root/.jenkins/workspace/$targetFileName/pom.xml -s /usr/local/maven/conf/settings.xml -gs /usr/local/maven/conf/settings.xml clean install -U package -P $profile  -Dmaven.test.skip=true

#scp -r $workspace/target/$scpFiles.war $server:~/temp/
if [ ! -d "$workspace/target" ]
then
	scp -i /home/jenkins/jenkins -P 54008 $workspace/$scpFiles/target/$scpFiles.war jenkins@$server:~/temp/
else
	scp -i /home/jenkins/jenkins -P 54008 $workspace/target/$scpFiles.war jenkins@$server:~/temp/
fi

#login remote machine
echo -e "\033[32;49;1m will login $server \033[39;49;0m"
#ssh $server   << remotetags  
ssh -i /home/jenkins/jenkins -p 54008 jenkins@$server << remotetags

echo -e "\033[32;49;1m login $server sucess \033[39;49;0m"
ifconfig

/home/d/tools/bin/shutdown.sh $targetFileName

##move files to tomcat run home
echo -e "\033[32;49;1m "scpFiles:"$scpFiles \033[39;49;0m"

#substring exe dir war file
echo -e "\033[32;49;1m "jobWar:"${scpFiles} \033[39;49;0m"

cd ~/temp
#mv ${scpFiles}.war ${scpFiles}.zip
#rm -rf ${scpFiles}
#mkdir ${scpFiles}

#mv ${scpFiles}.zip ./${scpFiles}
#cd ./${scpFiles}
#unzip ${scpFiles}.zip
#rm ${scpFiles}.zip

echo -e "\033[32;49;1m "targetWebapps:"$tomcatbase/$targetFileName/webapps \033[39;49;0m"


#cd ..
rm -rf $tomcatbase/$targetFileName/webapps/${scpFiles}
rm $tomcatbase/$targetFileName/webapps/$scpFiles.war
mv ${scpFiles}.war  $tomcatbase/$targetFileName/webapps/


#start tomcat
/home/d/tools/bin/start_tomcat.sh  $tomcatbase/$targetFileName  $scpFiles $targetFileName

ps -ef | grep $targetFileName

echo "will exit from $server"
exit  
remotetags




