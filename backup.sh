#!/bin/bash

# Backup Directory ( where to store the encrypted backups )
BACKUPDIR=""

# Current Time ( needed for backup file naming )
BACKUPTIME=$(date +"%Y-%m-%d_%H%M")

# Password / Key for encryption
PASSWORD=""

# SERVERLIST
SERVERLIST=$(cat serverlist.template)

# DEFAULT EXCLUDES ( Folders which aren't being backuped on ALL servers )
DEFAULT_EXCLUDES="default-excludes.template"

# Decide whether we want to delete backups if Disk is full or just stop backuping ( yes or no )
FREEUPSPACE=""

# Available Disk Space
DISKSPACE=$(df --output=avail -h "$PWD" | sed '1d;s/[^0-9]//g' | tr --delete "\n")

# MAX used space ( defines after which amount the script starts deleting old backups in case `FREEUPSPACE` is 'yes' )
MAXUSED="" # in GB


if [ "$DISKSPACE" -gt "$MAXUSED" ]; then
        echo "THERE ARE ONLY $DISKSPACE GB AVAILABLE ON THIS SYSTEM!"
        if [ ${FREEUPSPACE} = "yes" ]; then
                echo "FREEING UP SPACE NOW!"
                for i in {1..5}
                do
                        OLDESTFILE=$(find "${BACKUPDIR}" -type f -printf '%T+ %p\n' | sort | head -n 1 | cut -f2 -d ' ')
                        cd "${BACKUPDIR}"
                        rm "${OLDESTFILE}"
                        echo "DELETING $i FILE."
                done
        fi
        if [ ${FREEUPSPACE} = "no" ]; then
                echo "NOT FREEING UP SPACE. EXITING NOW."
                exit 1
        fi
fi

# Loop through all servers and do something
for data in ${SERVERLIST}
do
        # Set variables
        SERVERNAME=$( echo $data | cut -f1 -d '|' )
        USERNAME=$( echo $data | cut -f2 -d '|' )
        EXCLUDES=$( echo $data | cut -f3 -d '|' )

        # Create directory for the backup
        mkdir "${BACKUPTIME}-${SERVERNAME}"

        # Grab files from remote server
        rsync -r --exclude-from "$DEFAULT_EXCLUDES" --exclude-from "$EXCLUDES" -v -e ssh ${USERNAME}@${SERVERNAME}:/ ${BACKUPTIME}-${SERVERNAME}/

        # Create archive
        tar cvf "${BACKUPTIME}-${SERVERNAME}.tar" -C "${BACKUPTIME}-${SERVERNAME}/" .

        # Remove folder
        rm -rf "${BACKUPTIME}-${SERVERNAME}/"

        # Encrypt archive
        openssl aes-256-cbc -salt -in "${BACKUPTIME}-${SERVERNAME}.tar" -out "${BACKUPTIME}-${SERVERNAME}.tar.aes" -k "${PASSWORD}"

        # Remove unencrypted archive
        rm "${BACKUPTIME}-${SERVERNAME}.tar"

        # Move archive
        mv "${BACKUPTIME}-${SERVERNAME}.tar.aes" "${BACKUPDIR}"

done

exit 0
