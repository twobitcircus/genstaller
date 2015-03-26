@echo off
SET PATH=%PATH%;windows\cwRsync_5.4.1_x86_Free;windows
SET DEST_DIR=pr2
SET URL_PATH=/nightmares/nightmares.html
SET HTTP_PORT=8000

SET SSH_OPTIONS=-o StrictHostKeyChecking=no

set /p IP="Enter the IP address of the device:"

ECHO IP is %IP%

rsync -e "ssh %SSH_OPTIONS%" dependencies/rsync root@%IP%:/usr/bin
rsync -e "ssh %SSH_OPTIONS%" -avrz --files-from=syncfiles ./ root@%IP%:%DEST_DIR%

ECHO launching on the device
ssh %SSH_OPTIONS% -f root@%IP% "sh -c ""( (nohup %DEST_DIR%/run.sh 2>&1 >app.out </dev/null) & )"""

:WHILE1
ECHO checking if application is running (be patient)
curl --silent -f -o NUL http://%IP%:%HTTP_PORT%/
IF %ERRORLEVEL% EQU 0 GOTO :BROWSE
timeout /t 2 /nobreak
GOTO :WHILE1

:BROWSE
SET URL=http://%IP%:%HTTP_PORT%%URL_PATH%
ECHO launching application at %URL%
START %URL%

