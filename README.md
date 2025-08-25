# Media Server

## Purpose
To be honest, the main goal of this project is to learn Docker Compose.  I figured it would be a fun exercise to try making a media server using some existing hardware I already have - a Raspberry Pi Model 4 B and an external SSD.  The recent Netflix price hike may or may not have also been a factor.

**This is not meant to be a guide**, I just wanted to see how far I can go blind (sort of) and document the process.  This setup is very much flawed right now in multiple aspects, and I'm looking into iteratively improving them (see the section below for a list of planned improvements).  I just wanted to get a media server up and running ASAP so I can watch my stuff, and learn Docker in the process.

There are plenty of guides out there like [this one](https://trash-guides.info/) for a more proper setup.

---

## Use case(s)
Here's some of the restrictions and use cases I had in mind before starting this project:
1. Local use only - I just want to start the server up when I feel like watching, and access the content via my TV or PC.  Maybe in the future to use as a portable plug-and-play server too - but I'd have to beef up security for this.
2. I want to be able to download videos from streaming sites, and import to my library.
3. Downloads to be through a VPN.
4. All software to be installed via Docker Compose.
5. No plans to use it outside my home.  Also mobile access is probably out of scope, given that transcoding is not advised on such small hardware.
---

## Hardware

| Specification       | Details              |
|---------------------|----------------------|
| Server | Raspberry Pi Model 4 B (w/ fan and heatsink)|
| OS Storage | Sandisk 64GB SD Card|
| Media Storage | [Samsung Portable SSD T7 Shield 1TB](https://www.jbhifi.com.au/products/samsung-portable-ssd-t7-shield-1tb-black) |

A photo of my physical setup:

<details open>
    <img src="https://github.com/user-attachments/assets/02b45a36-016f-42b8-b4df-325ad7760265" alt="Raspberry Pi Media Server" width="400px" />
</details>

---

## Software
| Purpose | Software | Port |
|---|---|---|
| OS | Ubuntu Server 20.04 | -
| Media Server | Jellyfin | 8096 |
| Request management, Media Discovery | Jellyseer | 5055 |
| TV shows manager | Sonarr | 8989 |
| Movies manager | Radarr | 7878 |
| Indexers manager | Prowlarr | 9696 |
| Download client (torrent) | qBitTorrent | 8080 |
| VPN service | Proton VPN | - |
| VPN client | Gluetun | - |
| Stream downloader | yt-dlp (to do) | - |

---

## Setup

#### 1. Initial installs
Run the usual `sudo apt update && sudo apt upgrade`, [install docker](https://docs.docker.com/engine/install/ubuntu/), pull the project, etc.
#### 2. Setup ssh (for remote access)
[Install SSH](https://documentation.ubuntu.com/server/how-to/security/openssh-server/index.html), and  since I'm lazy, just [set up password auth for now.](https://askubuntu.com/a/1521410)
#### 3. Mount external SSD
Edit the `fstab` file so the SSD is mounted automatically on startup.  For simplicity's sake I set the mount point on an `ssd/` folder on the project root directory.

A quick step-by-step on what I did:
- get device uuid using `lsblk -f` or `blkid`
- update `/etc/fstab` by adding the following line: `UUID=<uuid> <mount point> exfat defaults,uid=1000,gid=1000,umask=0002 0 0` *permissions could use improvement
- either reboot, or manually create the mount point and mount manually for the session

#### 4. Create directories
Run the `setup.sh` script to create the necessary directories, also create the necessary directories on the mounted external SSD (will need to add this to the script)

#### 4a. (Optional) Rename and organize already existing media
In my case my SSD already contains some movies and shows I have downloaded.  Just reorganized by moving the content to the media folders created above.

#### 5. Set environment variables

Copy `.env.sample` into a `.env` file and fill out the required variables.

---

## Running the app

If everything goes well, run the `run-docker.sh` script and the app should start.  Once the app is running, we'll have to do some configuration on some of the running containers so they can talk to each other.  Here's a checklist on what to configure:
- [ ] Sonarr - set qBittorrent url, set media path
- [ ] Radarr - set qBittorrent url, set media path
- [ ] Prowlarr - set qBittorrent, Sonarr, Radarr url and API keys
- [ ] Prowlarr - add indexers
- [ ] Jellyseer - set Jellyfin, Sonarr, Radarr urls and API keys
- [ ] Jellyfin - finish setup wizard
- [ ] qBittorrent - configure torrent settings

---

## Gluetun, ProtonVPN and qBittorrent

- TO DO, describe gluetun crashing, and port forwarding not working because port is not synced, made script for it

---
## Improvements / To do
- [Hard links](https://trash-guides.info/File-and-Folder-Structure/Hardlinks-and-Instant-Moves/) for better storage
- Proper user IDs and permissions for each container (might be related to hard links)
- Better way to sync gluetun and qBittorrent port, or explore other VPN clients and/or torrent clients
- Move more variables to `.env`
- Optimise qBittorrent settings for CPU usage
- Better SSH security - remove password auth and use certs
- Better security in general
- `yt-dlp` integration
- Usenet?
- Bazarr for subtitles
- Another Sonarr/Radarr instance for anime
- Sonarr and Radarr download quality profiles
