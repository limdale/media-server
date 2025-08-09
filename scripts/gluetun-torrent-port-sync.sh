#!/bin/sh
TORRENT_CONFIG=qbittorrent/qBittorrent/qBittorrent.conf
while true
do
	TORRENT_PORT=$(cat $TORRENT_CONFIG | grep 'Session\\Port' | cut -f2 -d'=')	
	GLUETUN_PORT="$(cat ./gluetun/forwarded_port)"
	if [ "$TORRENT_PORT" != "$GLUETUN_PORT" ]
	then
		CURRENT_TIME="`TZ=Australia/Sydney date "+%Y-%m-%d %H:%M:%S%Y%m%d%H%M%S"`"
		echo "$CURRENT_TIME  Torrent Port: $TORRENT_PORT\nGluetun Port: $GLUETUN_PORT"
		echo "$CURRENT_TIME  Replacing torrent port"
		sudo docker compose down qbittorrent 
		sed -i "s/^Session\\\Port=.*/Session\\\Port=$GLUETUN_PORT/" $TORRENT_CONFIG
		sudo docker compose up -d qbittorrent
	fi
	sleep 20
done
