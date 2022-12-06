# mr-vercetti/docker-svencoop
[![Build Status](https://drone.vercetti.cc/api/badges/mr-vercetti/docker-svencoop-server/status.svg)](https://drone.vercetti.cc/mr-vercetti/docker-svencoop-server)

Dedicated [Sven Co-Op](https://www.svencoop.com/manual/startup.html) server in a Docker container.

![Sven Co-op logo](https://raw.githubusercontent.com/mr-vercetti/docker-svencoop-server/master/.misc/svencoop-logo.jpg "Sven Co-op logo")

## Usage
Examples of how you can run this container on your own machine. 

#### docker-compose
```
services:
   svencoop:
      image: mrvercetti/svencoop-server
      container_name: svencoop
      environment:
         - GAME_PARAMS=-console -port 27015 +maxplayers 8 +map stadium4 +log on
         - GAME_NAME=Sven Co-Op server
         - GAME_PASSWORD=123
      ports:
         - 27015:27015
         - 27015:27015/udp
      restart: unless-stopped
```

#### docker-cli
```
docker run -d \
    --name=svencoop \
    --env GAME_PARAMS=-console -port 27015 +maxplayers 8 +map stadium4 +log on
    --env GAME_NAME=Sven Co-Op server \
    --env GAME_PASSWORD=123 \
    --port 27015:27015 \
    --port 27015:27015/udp \
    --restart unless-stopped \ 
    mrvercetti/svencoop-server
```
### Environment variables
All of them are optional. Don't quote them as this can cause weird issues.
* `GAME_PARAMS` - startup parameters for server, you can specify port, map, max number of players and much [more](https://www.svencoop.com/manual/server-basic.html#start-cmd).
* `GAME_NAME` - name which will be displayed in server browser.
* `GAME_PASSWORD` - if specified, the server will ask for it when joining the game.
