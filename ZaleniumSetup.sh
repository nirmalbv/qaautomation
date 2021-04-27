#!/bin/bash

time=$(date +%d-%m-%y_%H.%M);
#echo $time

echo "Script Started at [ $(date +"%d-%m-%Y %H:%M:%S") ]"
echo "                               "


usage(){

echo "Enter valid parameters for desiredContainers , maxDockerSeleniumContainers, videoRecordingEnabled "
echo 
echo "options:"
echo "First Value: desiredContainers --> Number of nodes/containers created on startup --> Default value is 2"
#echo "First Value: desiredContainers --> Number of Firefox nodes/containers created on startup --> Default value is 2"
echo "Second Value: maxDockerSeleniumContainers --> Maximum number of docker-selenium containers running at the same time --> Default value is 10"
echo "Third Value: videoRecordingEnabled --> Sets "true" if video is recorded in every test"
echo
echo
echo "To Stop the Zalenium Server, type ./scriptname -stop and enter"
echo
}

startZaleniumServer(){

echo "Starting the Zalenium Server....."
echo

echo "Pulling the Docker Selenium Image"
echo
docker pull elgalu/selenium

echo
echo
echo "Pulling the docker Zalenium Image"
echo
docker pull dosel/zalenium

echo
echo
echo "Starting the Zalenium Server and registering the given Containers"
echo ""

    docker run --rm -d --name zalenium -p 4444:4444 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /tmp/videos:/home/seluser/videos \
      --privileged dosel/zalenium start --desiredContainers $givenContainers --maxDockerSeleniumContainers $maxDockerContainers --videoRecordingEnabled $videoRecording --maxTestSessions 150 --timeZone $zone

echo ""
echo "Points your tests to http://localhost:4444/wd/hub and run them"
echo
}

stopZaleniumServer(){

	echo "Stopping the Zalenium Server....."
	docker stop zalenium

}


# Get the options
while getopts ":hs" option; do
   case $option in
      h)
        echo "Command line arguments format"
         usage
         exit;;
     s)
         stopZaleniumServer
         exit;;
   esac
done

#Have commented the below function for accepting commandline args

#readZaleniumParameters(){

#commenting the below lines because changing the script to commandline args
#read -p "Enter the number of nodes on Startup: " givenContainers
#read -p "Enter the number of Firefox nodes on Startup: " ffContainers
#read -p "Enter the Maximum number of nodes running at the same time: " maxDockerContainers
#read -p "Video Recording [true/false]: " videoRecording

#echo "Total number of arguments : $#"

givenContainers=$1
#echo $givenContainers
maxDockerContainers=$2
#echo $maxDockerContainers 
videoRecording=$3
#echo $videoRecording
zone="America/Montreal"

	if [[ $givenContainers == '' || $maxDockerContainers == '' || $videoRecording == '' ]];then
		usage
	else
		startZaleniumServer
	fi
#}

###############Start of Execution##########
#readZaleniumParameters

