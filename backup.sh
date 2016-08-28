#!/bin/bash

# Backup Directory
BACKUPDIR=/data/backups/

# Current Time ( needed for backup file naming )
BACKUPTIME=$(date +"%Y-%m-%d_%H%M")

# Password / Key for encryption
PASSWORD="PZEz5BaqhKG4s4Zm" # Replace with a self-generated password

# SERVERLIST
SERVERLIST=$(cat serverlist.template)

for data in $SERVERLIST
do
        SERVERNAME=$( echo $data | cut -f1 -d '|' )
        USERNAME=$( echo $data | cut -f2 -d '|' )
        echo $SERVERNAME $USERNAME
done

exit 0
