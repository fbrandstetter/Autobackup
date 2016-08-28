#!/bin/bash

# Backup Directory ( where to store the encrypted backups )
BACKUPDIR=/data/backups/

# Current Time ( needed for backup file naming )
BACKUPTIME=$(date +"%Y-%m-%d_%H%M")

# Password / Key for encryption
PASSWORD="PZEz5BaqhKG4s4Zm" # Replace with a self-generated password

# SERVERLIST
SERVERLIST=$(cat serverlist.template)

# Backuped Data ( what data to backup )
BACKUPDATA=/home/

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
