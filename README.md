0. describe project - local media server only using pi and external HD
1. add photo of physical setup
2. describe exfat/fstab process for external SSD:
    - get device uuid using lsblk -f or blkid
    - update fstab file with ...
    - create mount point, mount
    - error on already existing shows sycning with jellyfin?
3. describe .env and config, media, downloads locations
4. describe gluetun, openvpn setup and possibly wireguard. link gluetun test? and paste test cmd
5. post qbittorrent changes to fix CPU usage - gluetun was crashing causing port to be reset.  needed to turn off dht, pex, local peer and limit active torrents so the device doesn't fry. Also added script to sync ports
6. post future improvements
    - wireguard - optimizations?
    - proper user ids, hardlinks
    - more env variables
    - optimize qbittorrent

After running instructions:
1. Open sonarr, radarr - get API keys, set download client
2. Open prowlarr, set sonarr radarr API keys, add indexers
3. Open jellyfin, setup libraries
4. Open jellyseer, set sonarr radarr API keys
5. Get forwarded port from gluetun logs, plug it in qbittorrent
