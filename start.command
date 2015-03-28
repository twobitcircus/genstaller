#!/bin/bash

cd `dirname $0`

source ../genstaller_config

if [ -z $1 ]
then
  IP=`osascript -e "display dialog \"Enter the IP address of the device\" default answer \"\"" -e "log text returned of result" 2>&1`
else
  IP=$1
fi

echo "IP is $IP"

echo "copying to the device"
rsync -e "ssh -o StrictHostKeyChecking=no" -avrz --files-from=../genstaller_syncfiles $SOURCE_DIR/ root@$IP:$DEST_DIR
if [ $? -ne 0 ]
then
  echo "rsync not found, installing it"
  if [ $DEVICE == "galileo" ]
  then
    scp dependencies/galileo/rsync root@$IP:/usr/bin/rsync
  else
    scp -r dependencies/edison root@$IP:/tmp/edison
    ssh root@$IP "opkg install /tmp/edison/libpopt0_1.16-r3_i586.ipk /tmp/edison/uclibc_0.9.33+git0+946799cd0ce0c6c803c9cb173a84f4d607bde350-r8.4_i586.ipk /tmp/edison/rsync_3.0.9-r0_i586.ipk" --force-overwrite
  fi

  if [ $? -ne 0 ]
  then
    echo "installing rsync failed, exiting"
    exit 1;
  else
    echo "copying files to the device"
    rsync -e "ssh -o StrictHostKeyChecking=no" -avrz --files-from=../genstaller_syncfiles $SOURCE_DIR/ root@$IP:$DEST_DIR
    if [ $? -ne 0 ]
    then
      echo "rsync failed again, exiting"
    fi
  fi
fi

echo "launching on the device"
ssh -o StrictHostKeyChecking=no -f root@$IP "sh -c \"( (nohup $DEST_DIR/run.sh 2>&1 >app.out </dev/null) & )\""
while :
do
  sleep 2
  echo "checking if application is running (be patient)"
  curl --silent -f --output /dev/null http://$IP:$HTTP_PORT/
  if [ $? -eq 0 ]
  then
    break
  fi
done

URL="http://$IP:$HTTP_PORT$URL_PATH"

echo "application is running"
echo "launching application at $URL"

open $URL
