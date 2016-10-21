#!/bin/bash
## Program to take mongo backup
#Author: Vinod.N K
#Usage: Mongo Backup.
#Distro : Linux -Centos, Rhel, and any fedora
#Check whether root user is running the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

#Starting the script


USERNAME=user
PASSWORD=password
DBHOST=127.0.0.1
BACKUPDIR="/newbackup/CLient/Mongo"
BINPATH="/moofwd_home/mongo/bin"
DATE=`date +%Y-%m-%d`
BACKDIR=`date +%Y-%m`
OPT=""
OPT="$OPT --username=$USERNAME --password=$PASSWORD"


dbdump () {
"$BINPATH/mongodump" --host=$DBHOST --out=$1 $OPT
return 0
}

DESTDIR=$BACKUPDIR/$BACKDIR

if [ ! -e "$DESTDIR" ]
        then
        mkdir -p "$DESTDIR"
fi

dbdump "$DESTDIR/$DATE"
cd $DESTDIR
/bin/tar -zcvf "mongo.$DATE.tar.gz" "$DATE"
/bin/rm -rf "$DESTDIR/$DATE"
/apps/s3cmd/s3cmd  put mongo.$DATE.tar.gz  s3://moofwd_backup/AIEP/Mongo/mongo.$DATE.tar.gz
echo "$DESTDIR/$DATE"
