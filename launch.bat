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


@SET URL=http://%IP%:%HTTP_PORT%%URL_PATH%
@ECHO opening browser to %URL%
@START %URL%

@ECHO launching on the device
ssh -o StrictHostKeyChecking=no root@%IP% %DEST_DIR%/run.sh

exit /b

:ini    
@for /f "tokens=2 delims==" %%a in ('find "%~1=" ..\genstaller_config') do @set %~2=%%a
@exit /b


