# genstaller

This is a quick and dirty installer for apps running on Intel Edison/Galileo.  was written with the following use case in mind:

- We have a directory of files (in our case, node.js code) on a desktop computer
- We want to rsync changes to the device
- We want to launch node on the device
- We want to wait until the webserver is available
- When it's available, we want to redirect the user's browser to the appropriate URL on the device

Additionally,

- This process should provide a one click way to install a tool on a completely clean Edison/Galileo
- The user should not have to open a terminal to make it happen.
- It should work on Windows and OSX

Genstaller is a bash script and a batch file.  For Windows, it includes some tools (rsync, scp, ssh, curl) which are included on OSX.

## Setup

You should clone genstaller into a directory in or alongside your project directory.

Create two configuration files: `genstaller_config` and `genstaller_syncfiles` by copying the included examples.  Alter `genstaller_config` as documented in the sample file.  `genstaller_syncfiles` contains a list of files in `DEST_DIR` that should actually be rsync'ed to the remote device.

Mac users can double-click on start.command.  Windows users can double click on start.bat.

## Notes

genstaller will execute `$DEST_DIR/run.sh` on the remote side.  This script should generally clean up from previous runs of the app, and execute whatever needs to be executed.  Here's an example `run.sh`:

```
#!/bin/sh

cd `dirname $0`

ps | grep app.js | grep -v grep | awk '{print $1}' | xargs kill
node app.js
```

## TODO

- Better windows support.  I primarily test on OSX.

## NOTES

- Intel, would you PLEASE include rsync in your distribution images?
