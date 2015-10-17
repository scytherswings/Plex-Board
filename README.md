[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg?branch=master)](https://travis-ci.org/scytherswings/Plex-Board)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/scytherswings/Plex-Board?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=body_badge)

# Plex-Board
## Version 0.1

What is Plex-Board? Put simply, it is a dynamic dashboard for checking the status of multiple services related to Plex Media Server (Plex, Couchpotato, Sickrage, Deluge, Sabnzbd+, etc.).

This is essentially a revamp of a cool project ([Network-Status-Page](https://github.com/scytherswings/Network-Status-Page)) I forked a little while ago.

Pronounced "Plex Dashboard" like that ghetto name [La-a][] (La Dash A)... sorry...

[La-a]: http://www.urbandictionary.com/define.php?term=la-a


###### Development branch status:

[![Build Status](https://travis-ci.org/scytherswings/Plex-Board.svg?branch=dev)](https://travis-ci.org/scytherswings/Plex-Board)

Just for clarificaiton, yes this is _another_ Plex dashboard, but this project is _different_ and I'll tell you why...

PlexWatchWeb and the newer(and very cool) PlexPy projects are oriented more towards statistics etc.
Plex-Board is meant to help the users **and** administrators of a Plex server get a quick overview on the status of the various services related to and including Plex itself.
Eventually I intend to support a unified search that will allow users to request media to be added which could then go to an approval page, or be allowed by default.


Here are a few screenshots of v0.1
![home](http://i.imgur.com/8kcDikC.png)

![add](http://i.imgur.com/6qnMZwa.png)

![view](http://i.imgur.com/zDbDLD4.png)

![all](http://i.imgur.com/9JWlycL.png)


## System Requirements

You should have enough space to allow logs and an image cache, so I wouldn't recommend using on a system with less that 1GB free HDD space.

Rails can probably run on 512MB of RAM fine and CPU usage will vary. You can probably get away with a single core, but dual core may run smoother.



## Install Instructions - for testing, not production

These instructions have been tested on a fresh install of Ubuntu 14.04 as of 10/16/2015. 
Other operating systems will probably work, but for now I'm only going to write instructions for Ubuntu.

1. `sudo apt-get update; sudo apt-get install git bundler -y;`

2. ```gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3; 
curl -sSL https://get.rvm.io | bash -s stable --rails```

4. `cd /opt` Now at this point, you might have to give your user write permissions to this directory. If that is the case run `sudo chmod 777 /opt -R` This is not a best practice, but it will get you by.

5. `git clone https://github.com/scytherswings/Plex-Board.git`

6. Now you might just want to reboot, otherwise you will have to fool around with your shell. `sudo reboot`

7. `rvm use 2.2.1; cd /opt/Plex-Board; bundle install --without development test;`

8. `./runServer.sh` Note that the server will stop running if you kill this process (like if you exit out of an SSH session etc.) Remeber, this is for _testing!_
Also, keep in mind