## Serial Access

Sprout has 7 serial ports for plugging in things which have nice serial interfaces (basically the sun & cisco stuff).

At the time of writing the following devices are setup:

*  cynic

*  daniel

*  enzyme

*  hadron

*  morpheus

*  murphy

## The console command

The console command lists the configured devices, and gives some basic help information to them who might be new.

### /usr/local/bin/console


	if [ -n "$1" ]; then

	        if [ -f /etc/minicom/minirc.$1 ]; then
	                exec /usr/local/bin/minicom $1
	                exit 0
	        else
	                echo "The device $1 is not configured"
	        fi
	fi

	echo "The following devices are configured for serial access:"

	devices=`ls /etc/minicom/minirc*|grep -v dfl`
	for device in $devices; do
	        echo "    * ${device:(20)}"
	done
	echo
	echo "Run 'console `<device>` to connect. This does not need to be ran as root."
	echo "There are docs on: https://docs.redbrick.dcu.ie/doku.php?id=sprout-serial"



This is pretty quick and dirty, speaks for itself.

### Minicom Configuration

There is a config file for each device in /etc/minicom/. Stuff here overrides any default config, generally this is only the port, but it could be used to set other options on a per client basis.


## Re-installing

One day someone will re-install. If that's you, and you're trying to make it work you need to run


	/dev/MAKEDEV tty04
	/dev/MAKEDEV tty05
	...
	/dev/MAKEDEV tty08

There is no documentation on this, I've just saved you three weeks of your life, your sanity, and possibly your hair. I expect to be repaid in pints.
