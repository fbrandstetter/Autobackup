# Autobackup

Autobackup is an automated backup system which retrieves data to backup from a remote server and stores it on the storage server.

## Installation

You can install AutoBackup using `git` easily on your system. Go ahead and clone the repository:

    mkdir /opt/
    git clone https://github.com/fbrandstetter/Autobackup.git /opt/autobackup/

## Configuration

Some settings ( like the `serverlist.template` file ) might be prefilled with example content. Feel free to remove or adapt this content in order to fit your needs. More detailed configuration options which are available can be found in the `README.md` file.

## Cron

Because we ideally want to backup our data regularly, we'll be using cronjob, which will run our backup script on the designated time(s). We can open and watch our existing cronjobs using the following command:

    crontab -e

We can now add an entry to our crons which runs the backupscript which should be located at `/opt/autobackup/backup.sh` if you properly followed this guide. In order to have our backup script running every day at 0:00 ( midnight ) we can add the following entry to our cronjobs:

    @midnight /opt/autobackup/backup.sh
