# astroneer-offsite-backups

![Astroneer Logo](https://astroneer.space/presskit/astroneer/images/header.png)

[![Build Status](https://travis-ci.com/alex4108/astroneer-offsite-backups.svg?branch=master)](https://travis-ci.com/alex4108/astroneer-offsite-backups)
[![GitHub issues](https://img.shields.io/github/issues/alex4108/astroneer-offsite-backups)](https://github.com/alex4108/astroneer-offsite-backups/issues)
[![GitHub forks](https://img.shields.io/github/forks/alex4108/astroneer-offsite-backups)](https://github.com/alex4108/astroneer-offsite-backups/network)
[![GitHub stars](https://img.shields.io/github/stars/alex4108/astroneer-offsite-backups)](https://github.com/alex4108/astroneer-offsite-backups/stargazers)
[![GitHub license](https://img.shields.io/github/license/alex4108/astroneer-offsite-backups)](https://github.com/alex4108/astroneer-offsite-backups/blob/master/LICENSE)
![GitHub All Releases](https://img.shields.io/github/downloads/alex4108/astroneer-offsite-backups/total)
![GitHub contributors](https://img.shields.io/github/contributors/alex4108/astroneer-offsite-backups)


This module is capable of moving the astroneer server files to an offsite location.

Did I save you some time?  [Buy me a :coffee::smile:](https://venmo.com/alex-schittko)

# Initial setup

1. Download the [latest release](https://github.com/alex4108/astroneer-offsite-backups/releases), and extract the files.
1. Open a powershell session and `cd` to the folder you extracted to, eg `cd C:\Users\Administrator\Downloads\astroneer-offsite-backups\`
1. Setup rclone for an offsite location: `.\rclone\rclone.exe config`

# Configuration

## Scheduled Task
1. Execute the script with all Required parameters, and the `-install 1` parameter.
1. Check your online target for backups

## One-Time Execution
1. Execute the script with all Required parameters

# Parameters 

* `-sourceDirectory "C:\Path\To\Astroneer\Files\"` _Required_ The directory of your astroneer backups directory.
* `-onlineTarget "gdrive:/ASTRO"` _Required_ Sets the online target to use in rclone.  
* `-retentionInDays 7` _Default: 7_ Sets the number of days to hold backups for.  Backups will be expired locally *and* remotely after the rentention time is exceeded.
* `-install 1` If set, will install a scheduled task to run every 15 minutes or every `-frequencyInMinutes` 
* `-frequencyInMinutes 15` _Default: 15, Requires `-install 1`_ Sets the number of minutes to run the installed scheduled task.  A value of 5 will run the job every 5 minutes.  This only has effect if you're using the `-install 1` parameter.

# Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

# Troubleshooting

* rclone doesn't recognize the online target given to the script

You can debug your online target like this: `.\rclone\rclone.exe ls gdrive:/ASTRO`

If you're having trouble using rclone, [the documentation](https://rclone.org/docs/) will be of significant help.

