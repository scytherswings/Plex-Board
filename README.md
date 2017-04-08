# Plex-Board
## Version 0.11.0


[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg?branch=master)](https://travis-ci.org/scytherswings/Plex-Board)
[![Coverage Status](https://coveralls.io/repos/scytherswings/Plex-Board/badge.svg?branch=dev&service=github)](https://coveralls.io/github/scytherswings/Plex-Board?branch=dev)
[![Gitter](https://badges.gitter.im/scytherswings/Plex-Board.svg)](https://gitter.im/scytherswings/Plex-Board?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B6MNRRPVZ34TN)

What is Plex-Board? Put simply, it is a dynamic dashboard for checking the status of multiple services related 
to Plex Media Server (Plex, Couchpotato, Sickrage, Deluge, Sabnzbd+, etc.).

This is essentially a revamp of a cool project ([Network-Status-Page](https://github.com/scytherswings/Network-Status-Page)) I forked a little while ago.

Pronounced "Plex *dash* board" like that ghetto name [La-a](http://www.urbandictionary.com/define.php?term=la-a) (La *dash* A)... sorry...

Just for clarification, yes this is _another_ Plex dashboard, but this project is _different_ and I'll tell you why.

[PlexWatchWeb](https://github.com/ecleese/plexWatchWeb) and [PlexPy](https://github.com/JonnyWong16/plexpy) 
are projects oriented more towards statistics etc.

__Plex-Board__ is meant to help the users **and** administrators of a Plex server get a quick overview on the 
status of the various services related to, and including Plex itself.
There's a large list of features I plan to support in the future and I take all requests into consideration. 
If there is something you'd like to see, feel free to chat about it on 
[Gitter](https://gitter.im/scytherswings/Plex-Board?utm_source=share-link&utm_medium=link&utm_campaign=share-link), or create a feature request ticket.


Here are a few screenshots of v0.4.2 (the last major UI update):
![Now-Playing](http://i.imgur.com/WjyXjMv.png)

![Recently Added](http://i.imgur.com/C0ZEvvW.png)

![All Services Panel](http://i.imgur.com/MdRkfZJ.png)

![Plex Token Authentication](http://i.imgur.com/xw2GfUR.png)

![Modal dialog boxes!](http://i.imgur.com/BBDeol0.png)

## System Requirements

You should have enough space to allow logs and an image cache, so I wouldn't recommend using on a system with less than 1GB free HDD space.

Rails can probably run on 512MB of RAM fine and CPU usage will vary. You can probably get away with a single core, but dual core may run smoother.

It will run on the original Raspberry Pi which is pretty neat.


## Install Instructions
##### Development branch status:

[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg?branch=dev)](https://travis-ci.org/scytherswings/Plex-Board)

### This project is not ready for real production use yet, so don't expect stability until a 1.0.0 release.
Then when things break you can yell at me and use this readme as an excuse

#### Other supported operating systems:

[Plex-Board Wiki Homepage](https://github.com/scytherswings/Plex-Board/wiki)

##### Ubuntu 16.04 LTS

These instructions have been tested on a fresh install of Ubuntu 16.04 using bash as of 4/7/2017.

1. `sudo apt-get update && sudo apt-get install git bundler nodejs curl -y;`

2. `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 &&
\curl -sSL https://get.rvm.io | bash -s stable`

3. `source /usr/local/rvm/scripts/rvm`

4. `cd /opt` \
Now at this point, you might have to give your user write permissions to this directory.
 If that is the case run: \
 `sudo chmod 777 /opt -R`

5. `git clone https://github.com/scytherswings/Plex-Board.git`

6. `rvm install ruby-2.3.4` 

    If you get a message saying something like: \
    `RVM is not a function, selecting rubies with 'rvm use ...' will not work.` \
    Then you'll have to run: \
    `/bin/bash --login` \
    or reboot with: \
    `sudo reboot` \
    Start at the next step if you choose to reboot.
    Also, installing ruby could take a while if it has to compile from source. 
    It should be about 1 beer long.

7. `cd /opt/Plex-Board`

8. `./serverSetup.sh`

9. Check the newly created `server_config.yml` file to see that all the settings match what you want them to.
If you're not running behind a reverse proxy then you shouldn't need to touch this file at all.

10. __Plex-Board__ should now be installed!

## Running Instructions
1. `./startServer.sh` \
If you use RVM you'll need to make sure you use the gemset that 
we set up earlier each time you run the server. 
This way you will isolate Plex-Board dependencies from the rest of your system.

    If you get an error that looks like:\
    ...`Address family not supported by protocol - socket(2) for "::1" port 3000 (Errno::EAFNOSUPPORT)`\
    You can either disable IPv6 for your OS or edit the `server_config.yml` to use a specific IP address on your system e.g. \
    `http://192.168.0.102:3000` \
    See the `server_config.yml` file for more details. 
    
2. `./stopServer.sh` will stop the server.

## Updating Instructions
1. `./update.sh` Will run `git pull` and `serverSetup.sh` for you.


### Feedback
If you run into any bugs, please, make a ticket or ask in the 
[Gitter](https://gitter.im/scytherswings/Plex-Board?utm_source=share-link&utm_medium=link&utm_campaign=share-link)
chat room. 
I'm sure I'll miss something in my testing so feel free to let me know what I overlooked. 
Since I work on this project in my free time, I can't always respond to chats immediately but I'll do the best I can to get back to you within the day.
