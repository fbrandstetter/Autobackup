# Autobackup

Autobackup is an automated backup system which retrieves data to backup from a remote server and stores it on the storage server.

## Usage

    ./backup.sh

## Config
All configuration is done in the `backup.sh` file. The following fields should be adapted to fit your needs:

    BACKUPDIR=""
    PASSWORD=""
    BACKUPDATA=""

## Example Config

    BACKUPDIR="/data/backup/"
    PASSWORD="sf9h4jp398hncpg9vncj409bn"
    BACKUPDATA="/var/www/"

This will grab the folder `/var/www/` and it's subdirectories and files from the remote server, create a new archive, encrypt it and move it to `BACKUPDIR`. 

## Decryption
If you want to decrypt the archive ( i.e. to restore the backuped data ) you can run the following command:

    openssl aes-256-cbc -d -salt -in BACKUP.tar.aes -out backup.restored.tar
    mkdir backup/
    tar -xvf backup.restored.tar backup/

You now have all backuped files in the `backup/` folder.

## Server-List
All servers are being added in the `serverlist.template` file. In order to have a working authentication, you have to add the SSH-KEY of the storage server to the server from which you want to grab files. You can add new servers using the following sheme:

    <SERVER_HOSTNAME OR IP>|<USERNAME FOR AUTHENTICATION>
