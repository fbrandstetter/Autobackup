# Autobackup

Autobackup is an automated backup system which retrieves data to backup from a remote server and stores it on the storage server.

## Usage

    ./backup.sh

## Config
All configuration is done in the `backup.sh` file. The following fields should be adapted to fit your needs:

    BACKUPDIR=""
    PASSWORD=""
    BACKUPDATA=""
    FREEUPSPACE=""

## Example Config

    BACKUPDIR="/data/backup/"
    PASSWORD="sf9h4jp398hncpg9vncj409bn"
    BACKUPDATA="/var/www/"
    FREEUPSPACE="no"

This will grab the folder `/var/www/` and it's subdirectories and files from the remote server, create a new archive, encrypt it and move it to `BACKUPDIR`. The `FREEUPSPACE` variable sets, whether our server should check available disk space and delete backups in case it's full or not. In case that there are less than 10G disk space available, the script will delete the oldest 5 backups from `BACKUPDIR`. 

## Decryption
If you want to decrypt the archive ( i.e. to restore the backuped data ) you can run the following command:

    openssl aes-256-cbc -d -salt -in BACKUP.tar.aes -out backup.restored.tar
    mkdir backup/
    tar -xvf backup.restored.tar backup/

You now have all backuped files in the `backup/` folder.

## Server-List
All servers are being added in the `serverlist.template` file. In order to have a working authentication, you have to add the SSH-KEY of the storage server to the server from which you want to grab files. You can add new servers using the following sheme:

    <SERVER_HOSTNAME OR IP>|<USERNAME FOR AUTHENTICATION>|<EXCLUDE LIST>

# Exclude
Each server has it's own exclude list which directories we don't want to backup. Actually, by default we backup the entire system ( `/` ). An example for an exclude list looks like this:

    DIRECTORY/
    FILE.txt
    DIRECTORY/
    FILE.dat
