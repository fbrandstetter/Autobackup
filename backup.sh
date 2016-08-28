#!/bin/bash

# Backup Directory ( where to store the encrypted backups )
BACKUPDIR=""

# Current Time ( needed for backup file naming )
BACKUPTIME=$(date +"%Y-%m-%d_%H%M")

# Password / Key for encryption
PASSWORD=""

# SERVERLIST
SERVERLIST=$(cat serverlist.template)

# Backuped Data ( what data to backup )
BACKUPDATA=""

# Decide whether we want to delete backups if Disk is full or just stop backuping ( yes or no )
FREEUPSPACE=""

# Available Disk Space
DISKSPACE=$(df --output=avail -h "$PWD" | sed '1d;s/[^0-9]//g')

# MAX used space ( defines after which amount the script starts deleting old backups in case `FREEUPSPACE` is 'yes' )
MAXUSED="" # in GB


if [[ ( $FREEUPSPACE = "yes" ) && ( $DISKSPACE -lt $MAXUSED ) ]]; then
        echo "THERE ARE ONLY $DISKSPACE GB AVAILABLE ON THIS SYSTEM!"
        if [ $FREEUPSPACE = "yes" ]; then
                echo "FREEING UP SPACE NOW!"
                for i in {1..5}
                do
                        OLDESTFILE=$(find $BACKUPDIR -type f -printf '%T+ %p\n' | sort | head -n 1 | cut -f2 -d ' ')
                        cd $BACKUPDIR
                        rm $OLDESTFILE
                        echo "DELETING $i FILE."
                done
        fi
        exit 1
fi

# Loop through all servers and do something
for data in $SERVERLIST
do
        # Set variables
        SERVERNAME=$( echo $data | cut -f1 -d '|' )
        USERNAME=$( echo $data | cut -f2 -d '|' )

        # Create directory for the backup
        mkdir $BACKUPTIME-$SERVERNAME

        # Grab files from remote server
        echo "get -r $BACKUPDATA $BACKUPTIME-$SERVERNAME/" | sftp $USERNAME@$SERVERNAME

        # Create archive
        tar cvf $BACKUPTIME-$SERVERNAME.tar -C $BACKUPTIME-$SERVERNAME/ .

        # Remove folder
        rm -rf $BACKUPTIME-$SERVERNAME/

        # Encrypt archive
        openssl aes-256-cbc -salt -in $BACKUPTIME-$SERVERNAME.tar -out $BACKUPTIME-$SERVERNAME.tar.aes -k $PASSWORD

        # Remove unencrypted archive
        rm $BACKUPTIME-$SERVERNAME.tar

        # Move archive
        mv $BACKUPTIME-$SERVERNAME.tar.aes $BACKUPDIR

done

exit 0
