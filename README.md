# Plex-Board
## Version 0.4

[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg)](https://travis-ci.org/scytherswings/Plex-Board)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/scytherswings/Plex-Board?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=body_badge)

What is Plex-Board? Put simply, it is a dynamic dashboard for checking the status of multiple services related to Plex Media Server (Plex, Couchpotato, Sickrage, Deluge, Sabnzbd+, etc.).

This is essentially a revamp of a cool project ([Network-Status-Page](https://github.com/scytherswings/Network-Status-Page)) I forked a little while ago.

Pronounced "Plex Dashboard" like that ghetto name [La-a][] (La Dash A)... sorry...

[La-a]: http://www.urbandictionary.com/define.php?term=la-a


Just for clarificaiton, yes this is _another_ Plex dashboard, but this project is _different_ and I'll tell you why.

PlexWatchWeb and the newer (and very cool) PlexPy projects are oriented more towards statistics etc.
Plex-Board is meant to help the users **and** administrators of a Plex server get a quick overview on the status of the various services related to and including Plex itself.
Eventually I intend to support a unified search that will allow users to request media to be added which could then go to an approval page, or be allowed by default.


Here are a few screenshots of v0.4
![home](http://i.imgur.com/IHuLsAh.png)

![add](http://i.imgur.com/6qnMZwa.png)

![view](http://i.imgur.com/zDbDLD4.png)

![all](http://i.imgur.com/9JWlycL.png)


## System Requirements

You should have enough space to allow logs and an image cache, so I wouldn't recommend using on a system with less that 1GB free HDD space.

Rails can probably run on 512MB of RAM fine and CPU usage will vary. You can probably get away with a single core, but dual core may run smoother.



## Install Instructions
### This project is not ready for real production use yet, so don't expect stability until a 1.0 release

These instructions have been tested on a fresh install of Ubuntu 14.04 as of 10/16/2015.
Other operating systems will probably work, but for now I'm only going to write instructions for Ubuntu.

1. `sudo apt-get update; sudo apt-get install git bundler nodejs -y;`

2. ```gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3;
curl -sSL https://get.rvm.io | bash -s stable --rails```

3. `cd /opt` Now at this point, you might have to give your user write permissions to this directory. If that is the case run `sudo chmod 755 /opt -R`

4. `git clone https://github.com/scytherswings/Plex-Board.git`

5. `rvm use 2.2.1; cd /opt/Plex-Board;` If you get a message saying something like: `RVM is not a function, selecting rubies with 'rvm use ...' will not work.` 
Then you'll have to run `/bin/bash --login` or reboot with `sudo reboot`.

6. `cd /opt/Plex-Board`

7. `./serverSetup.sh`

8. `./runServer.sh` Note that the server will stop running if you kill this process (like if you exit out of an SSH session etc.) Remember, this is for _testing._

### Feedback
If you run into any bugs, please, make a ticket or ask in the Gitter chat room. 
I'm sure I'll miss something in my testing so feel free to let me know what I overlooked. 
Since I work on this project in my free time, I can't always respond to chats immediately but I'll do the best I can to get back to you within the day.
