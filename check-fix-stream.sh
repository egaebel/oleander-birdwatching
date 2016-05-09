#!/bin/sh

LOG_FILE=/home/pi/output.log

thedate=$(TZ=$(cat /etc/timezone) date)
echo running check-fix-stream.sh at $thedate\n >> $LOG_FILE

# Trim logfile if need be
logsize=$(stat -c %s $LOG_FILE)
if [ $logsize -ge 1000000 ]; then
    rm $LOG_FILE
fi

# If the stream startup script has not completed
if [ ! -e "/home/pi/stream-started-successfully" ]; then
    echo Stream not started yet >> $LOG_FILE
    exit
fi

# Check that all is running well
output=$(ps -C avconv | wc -l)
if [ $output != "2" ]; then
    echo streamVideoRTSP was found to be STOPPED at $thedate\n >> $LOG_FILE
    sudo kill $(pidof crtmpserver)
    sudo /home/pi/stream-startup.sh    
    crtmppidcheck=$(pidof crtmpserver | wc -l)
    streamRTSPpidcheck=$(pidof streamVideoRTSP | wc -l)
    if [ $crtmppidcheck == "1" ] && [ $streamRTSPpidcheck == "1" ]; then
        echo Successfully restarted stream!\n >> $LOG_FILE
    else
        psauxoutput="$(ps aux)"
        echo Failed to restart stream! >> $LOG_FILE
        echo dumping processes... >> $LOG_FILE
        echo $psauxoutput >> $LOG_FILE
        echo Rebooting machine............. >> $LOG_FILE
        # sudo reboot
    fi
else
    echo streamVideoRTSP is running, no worries!\n
fi
