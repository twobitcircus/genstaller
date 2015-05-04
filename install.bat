@SET PATH=%PATH%;windows;windows\cwRsync_5.4.1_x86_Free

@call:ini DEST_DIR DEST_DIR
@call:ini IP IP
@call:ini DEVICE DEVICE
@call:ini SOURCE_DIR SOURCE_DIR
@call:ini DEST_DIR DEST_DIR
@call:ini URL_PATH URL_PATH
@call:ini HTTP_PORT HTTP_PORT

set /p IP="Enter the IP address of the device:"
@ECHO IP is %IP%

@ECHO "copying to the device"
pscp dependencies\%DEVICE%\rsync root@%IP%:/usr/bin
ssh -o StrictHostKeyChecking=no root@%IP% chmod +x /usr/bin/rsync
ssh -o StrictHostKeyChecking=no root@%IP% date 010100002015

rsync -e "ssh -o StrictHostKeyChecking=no" -avrz --files-from=../genstaller_syncfiles ../%SOURCE_DIR%/ root@%IP%:%DEST_DIR%

exit /b

:ini    
@for /f "tokens=2 delims==" %%a in ('find "%~1=" ..\genstaller_config') do @set %~2=%%a
@exit /b


