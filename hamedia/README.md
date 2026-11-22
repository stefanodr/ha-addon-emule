# HaMedia: DLNA media server for Home Assistant

HaMedia publishes folders of your Home Assistant media storage as a **DLNA/UPnP media server**, so smart TVs, consoles and players on your network find it by themselves, the same way they find the media server of a router. It is built on [MiniDLNA](https://sourceforge.net/projects/minidlna/) (ReadyMedia).

It was made to watch on the TV the files downloaded with the [eMule add-on](../README.md) from the same repository, but it works with any folder under `/media` or `/share`.

> **Status: stable.** Tested on Home Assistant OS on an x86_64 mini PC, with media on a USB SSD and a Samsung smart TV. Please open an issue if something does not work on your setup.

## Features

- Appears in the list of media servers of TVs and players, with the name you choose.
- **Read-only:** nothing can be deleted or changed from the TV.
- One or more folders under `/media` or `/share`, with an optional filter (everything, only video, only audio or only pictures).
- New files are detected automatically while the add-on runs, and the folders are rescanned at every start.
- Optional **wait for the external disk** at start, as in the eMule add-on.
- Very light: no transcoding, it serves the files as they are.

## Requirements

- Home Assistant OS or Supervised installation.
- amd64 or aarch64 (nothing in the add-on depends on the architecture, but the author can test only amd64).
- A TV or player that supports DLNA/UPnP, on the same network as Home Assistant.

## Installation

1. Add the repository `https://github.com/stefanodr/ha-addon-emule` to the Add-on Store (see the [main README](../README.md)).
2. Find **HaMedia** in the store and click **Install**.
3. In the **Configuration** tab choose the folders to publish. By default it publishes `/media/emule/Incoming`.
4. Start the add-on.

## Using it

1. After the start, open the list of media servers on your TV or player (the place where the router's media server already appears). **HaMedia** should be there within a minute; if not, restart the TV or reopen the list.
2. Browse the folders and play the files.
3. To check that the server works without a TV, open `http://<IP-of-Home-Assistant>:8200/` in a browser: the status page shows how many video, audio and picture files it has indexed.

### Together with the eMule add-on

- Set the folder to the one where eMule saves finished downloads, for example `/media/Volume/emule/Incoming`.
- That folder contains only completed files: incomplete downloads stay in `Temp`.
- eMule shares everything in `Incoming`. If you want the TV to see only films, create a separate folder (for example `/media/Volume/Film`), give an eMule category that folder as its Incoming folder, and publish that folder with HaMedia.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `server_name` | `HaMedia` | Name shown by the TV or player (up to 64 characters) |
| `media_dirs` | `/media/emule/Incoming` | List of folders to publish. Only folders under `/media` or `/share` are accepted |
| `media_type` | `all` | `all`, `video`, `audio` or `pictures`: what to publish from the folders |
| `port` | `8200` | HTTP port of the media server |
| `require_external_disk` | `false` | Turn it on when the folders are on an external disk (for example `/media/Volume/...`). At start the add-on waits up to 3 minutes for the disk, then stops instead of publishing an empty library |
| `rescan_on_start` | `true` | Rescan the folders at every start, to pick up files added or removed while the add-on was stopped |

After changing the options, restart the add-on.

## Network

- The add-on uses the **host network**. DLNA discovery relies on multicast packets (SSDP, UDP 1900) that do not cross the internal Docker network, so there is no other way to make the TV find the server. This means the add-on is not isolated from the network of the Home Assistant machine.
- It uses TCP port 8200 (or the one you set) and UDP port 1900 on the Home Assistant machine.
- DLNA has no password: any device on your network can browse and play the published folders. The folders are read-only. Publish only what you are happy to share at home, and do not use it on a network with guests you do not trust.
- Do **not** forward these ports on your router.
- TV and Home Assistant must be on the same network (same subnet). Some routers and access points block multicast between Wi-Fi and cable: if the TV does not see the server, check that option.

## External disk

If the folders are on a USB disk:

- Turn on `require_external_disk`, so that at start the add-on waits for the disk instead of building an empty library.
- If you unplug and plug the disk again, **restart the add-on** so that it watches the new mount.
- Stop the add-on before unplugging the disk, so that it does not keep the disk busy.

## Formats and subtitles

HaMedia does not convert anything: the TV must be able to play the file. Most TVs play `.mkv`, `.mp4` and `.avi` with common codecs, but it depends on the model. If a file does not play on the TV, try it with another player to see whether the problem is the format. Subtitle support (for example an `.srt` file with the same name as the video) also depends on the TV.

## Troubleshooting

| Problem | What to do |
|---------|------------|
| The TV does not see the server | Check that the add-on is running; open `http://<IP>:8200/` from a PC; check that the TV is on the same network and that multicast is not blocked between Wi-Fi and cable; restart the TV |
| The library is empty | Check the folder in `media_dirs` and that the disk is mounted (`ls /media` in a terminal add-on); read the add-on log |
| The add-on stops at start with "is not a separate mounted disk" | The external disk is not connected or not mounted. Connect it and restart, or turn off `require_external_disk` |
| New files do not appear | Wait a few minutes; if they still do not appear, restart the add-on |
| The add-on does not start because of the port | Another service is using the port: change `port` |
| A file is listed but does not play | It is probably a format the TV does not support |

When you report a problem, include the add-on log and the version number.

## Limitations

- DLNA/UPnP only, with no transcoding and no web interface for browsing (the status page only shows the counts).
- No password and no separate users.
- The disk check runs only when the add-on starts.

## Credits

[MiniDLNA / ReadyMedia](https://sourceforge.net/projects/minidlna/), distributed under the GNU GPL. This project is not affiliated with it.

## Italiano

La documentazione in italiano è in [README.it.md](README.it.md).
