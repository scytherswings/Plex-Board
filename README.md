# Plex-Board
## Version 0.5.3


[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg?branch=master)](https://travis-ci.org/scytherswings/Plex-Board)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/scytherswings/Plex-Board?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=body_badge)
[![Coverage Status](https://coveralls.io/repos/scytherswings/Plex-Board/badge.svg?branch=dev&service=github)](https://coveralls.io/github/scytherswings/Plex-Board?branch=dev)

What is Plex-Board? Put simply, it is a dynamic dashboard for checking the status of multiple services related to Plex Media Server (Plex, Couchpotato, Sickrage, Deluge, Sabnzbd+, etc.).

This is essentially a revamp of a cool project ([Network-Status-Page](https://github.com/scytherswings/Network-Status-Page)) I forked a little while ago.

Pronounced "Plex Dashboard" like that ghetto name [La-a][] (La Dash A)... sorry...

[La-a]: http://www.urbandictionary.com/define.php?term=la-a


Just for clarification, yes this is _another_ Plex dashboard, but this project is _different_ and I'll tell you why.

PlexWatchWeb and the newer (and very cool) PlexPy projects are oriented more towards statistics etc.
Plex-Board is meant to help the users **and** administrators of a Plex server get a quick overview on the status of the various services related to and including Plex itself.
There's a large list of features I plan to support in the future and I take all requests into consideration. If there is something you'd like to see, feel free to chat about it on Gitter, or create a feature request ticket.


Here are a few screenshots of v0.4.2:
![Now-Playing](http://i.imgur.com/WjyXjMv.png)

![Recently Added](http://i.imgur.com/C0ZEvvW.png)

![All Services Panel](http://i.imgur.com/MdRkfZJ.png)

![Plex Token Authentication](http://i.imgur.com/xw2GfUR.png)

![Modal dialog boxes!](http://i.imgur.com/BBDeol0.png)

## System Requirements

You should have enough space to allow logs and an image cache, so I wouldn't recommend using on a system with less that 1GB free HDD space.

Rails can probably run on 512MB of RAM fine and CPU usage will vary. You can probably get away with a single core, but dual core may run smoother.


## Install Instructions
##### Development branch status:

[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg?branch=dev)](https://travis-ci.org/scytherswings/Plex-Board)

### This project is not ready for real production use yet, so don't expect stability until a 1.0.0 release

These instructions have been tested on a fresh install of Ubuntu 14.04 using bash as of 10/16/2015.
Other operating systems will probably work, but for now I'm only going to write instructions for Ubuntu.

1. `sudo apt-get update; sudo apt-get install git bundler nodejs -y;`

2. ```gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3;
curl -sSL https://get.rvm.io | bash -s stable --rails```

3. `cd /opt` Now at this point, you might have to give your user write permissions to this directory. If that is the case run `sudo chmod 755 /opt -R`

4. `git clone https://github.com/scytherswings/Plex-Board.git`

5. `rvm use 2.3.0; cd /opt/Plex-Board;` If you get a message saying something like: `RVM is not a function, selecting rubies with 'rvm use ...' will not work.` 
Then you'll have to run `/bin/bash --login` or reboot with `sudo reboot`.

6. `cd /opt/Plex-Board`

7. `./serverSetup.sh`

8. `./runServer.sh` Note that the server will stop running if you kill this process (like if you exit out of an SSH session etc.) 

Remember, this is for _testing._


### Feedback
If you run into any bugs, please, make a ticket or ask in the Gitter chat room. 
I'm sure I'll miss something in my testing so feel free to let me know what I overlooked. 
Since I work on this project in my free time, I can't always respond to chats immediately but I'll do the best I can to get back to you within the day.
