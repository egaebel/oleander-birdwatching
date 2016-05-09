#!/bin/sh

LOG_FILE=/home/pi/output.log
CRTMP_LOG_FILE=/home/pi/crtmpserver.log
AVCONV_LOG_FILE=/home/pi/avconv.log

thedate=$(TZ=$(cat /etc/timezone) date)
echo Running stream-startup.sh at $thedate\n >> $LOG_FILE

rm /home/pi/stream-started-successfully

cd /opt/crtmpserver/builders/cmake/
echo Starting crtmpserver >> $LOG_FILE
echo Starting crtmpserver at $thedate >> $CRTMP_LOG_FILE
sudo ./crtmpserver/crtmpserver ./crtmpserver/crtmpserver.lua >> $CRTMP_LOG_FILE &

sleep 10

cd /opt/boneCV/
echo Starting streamVideoRTSP >> $LOG_FILE
echo Starting streamVideoRTSP at $thedate >> $AVCONV_LOG_FILE
sudo ./streamVideoRTSP >> $AVCONV_LOG_FILE &

sleep 30

touch /home/pi/stream-started-successfully
