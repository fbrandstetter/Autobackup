#!/bin/bash

# Backup Directory
BACKUPDIR = /data/backups/

# Current Time ( needed for backup file naming )
BACKUPTIME = $(date +"%Y-%m-%d_%H%M")

# Password / Key for encryption
PASSWORD = "PZEz5BaqhKG4s4Zm" # Replace with a self-generated password

# SERVERLIST
SERVERLIST = $(cat serverlist.template)

exit 0
