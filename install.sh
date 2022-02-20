#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

INIT_PATH=/etc/init.d/ndc.init;
CONFIGDIR=/etc/not-docker-compose;
DATADIR=/opt/not-docker-compose;
STOREDIR=/var/lib/not-docker-compose;
DIR=/var/run/not-docker-compose
GRP=ndc

echo "Installing not-docker-compose...";

if [ $(grep -c "^ndc:" /etc/group) -ne 0 ];
then
		echo "Not creating group ndc: group exists!"
else
	addgroup ndc;
fi

if [ $(id -nG $SUDO_USER | grep -c ndc) -ne 0 ];
then
	echo "Not adding user $SUDO_USER to group ndc : entry exists!"
else
	usermod -a -G ndc $SUDO_USER;
fi

mkdir $CONFIGDIR;
chmod 770 $CONFIGDIR;
chgrp ndc $CONFIGDIR;

mkdir $DATADIR;
chmod 770 $DATADIR;
chgrp ndc $DATADIR;

mkdir $STOREDIR;
chmod 770 $STOREDIR;
chgrp ndc $STOREDIR;

#checking if file exists
if [ ! -f "$INIT_PAPTH" ];
then
touch $INIT_PATH;
fi

#writing rc to file
echo "#!/bin/bash" > $INIT_PATH;

echo "mkdir $DIR;" >> $INIT_PATH;

echo "chgrp $GRP $DIR;" >> $INIT_PATH;

echo "chmod 770 $DIR" >> $INIT_PATH;

#making rc executable
chmod +x $INIT_PATH;

MY_PATH="`dirname \"$0\"`"              # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized
if [ -z "$MY_PATH" ] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

#creating rc link to rc3 to make sure it runs as root
RC_LINK=/etc/rc3.d/S02ndc.init;

if ! [ -L "$RC_LINK" ];
then
ln -s $INIT_PATH $RC_LINK;
fi

#this is needed for ubuntu
uname -v | awk '!/Ubuntu/{exit 1}' && sudo update-rc.d ndc.init defaults;

echo "DONE!";
