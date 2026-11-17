# eMule add-on for Home Assistant

[![Add repository to my Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fstefanodr%2Fha-addon-emule)

Run the real **eMule** (the Windows client for the eD2K and Kad networks) inside Home Assistant OS. The add-on runs eMule Community under Wine and shows its full interface in the Home Assistant sidebar, so you get the same program, with all its features, without a Windows PC.

> **Status: stable.** First stable release. It has been tested on Home Assistant OS running on an x86_64 mini PC, with downloads on a USB SSD. Please open an issue if something does not work on your setup.

> **Also in this repository: [HaMedia](hamedia/README.md)**, a DLNA media server that shows your downloaded files to your TV, like the media server of a router.

## Features

- The real **eMule Community 0.70b** (64-bit), not a look-alike: eD2K and Kad networks, credits, queue, search, categories, IP filter, scheduler and the built-in web server.
- Full interface in the Home Assistant sidebar through ingress, usable from any browser or the Home Assistant app.
- Optional eMule **web interface** to check the queue and add downloads from any device on your network, without going through Home Assistant.
- Settings, credits and download queue survive restarts and updates, and are included in Home Assistant backups.
- Downloads can go to any disk visible under `/media` or `/share`, with a **safety check** that stops the add-on if an external disk is missing instead of filling the system disk.
- Runs at low priority, so cameras, automations and other add-ons come first when the host is busy.
- Options translated into English and Italian.

## Requirements

- Home Assistant OS or Supervised installation.
- **amd64 (x86_64) only**: mini PCs, NUCs, virtual machines. Raspberry Pi and other ARM boards are not supported, because eMule is an x86 program.
- About 200 MB of free RAM and some free disk space for the downloads.
- A router where you can forward ports (see [Network and ports](#network-and-ports)).

## Installation

1. In Home Assistant go to **Settings → Add-ons → Add-on Store**.
2. Open the menu (top right) → **Repositories** and add `https://github.com/stefanodr/ha-addon-emule`, or use the button at the top of this page.
3. Find **eMule** in the store and click **Install**. The first build downloads Wine and eMule and can take several minutes.
4. Start the add-on and enable **Show in sidebar** (and **Start on boot** if you want it always on).
5. Open **eMule** from the sidebar.

## First start

The first start creates the Wine environment and can take a minute or two, so the sidebar page may stay empty for a while. After that eMule opens with default settings: downloads go to `/media/emule/Incoming`, temporary files to `/media/emule/Temp`, and it connects to the network automatically.

Recommended first steps in eMule:

1. **Options → General:** choose your nickname.
2. **Options → Connection:** enter your real line speed, and set the upload limit to about 80% of your real upload speed. A saturated upload slows down downloads.
3. Forward the ports on your router (next section) and check that you get a **High ID**.

## Using eMule

### Open the interface

The interface is a remote desktop shown in the browser. Open **eMule** from the Home Assistant sidebar; it is protected by your Home Assistant login. It reconnects by itself if the connection drops, and it scales to the size of the page.

### Add downloads

- **Search** tab inside eMule, as on Windows.
- **ed2k links:** copy the link, then in the **Transfers** window use the paste button for ed2k links. In the remote desktop, the clipboard of your device is not shared automatically: open the side panel of the remote desktop (small arrow on the left edge of the page), use the clipboard box to paste the link, then click inside eMule and paste.
- **From a phone or tablet:** it is easier to use the eMule web interface (see below) and paste the link in its page.

### Everyday notes

- Closing the browser tab does not stop anything: eMule keeps running inside the add-on.
- If you quit eMule from its own menu, the add-on starts it again after 5 seconds. To really stop it, stop the add-on from Home Assistant.
- Do not tick the `Z:` drive in **Options → Directories → Shared Directories**: `Z:` is the whole container, including the add-on configuration. Share only specific folders under `Z:\media\...` or `Z:\share\...`.

## Network and ports

### Port forwarding

To get a **High ID** (and much better speeds) forward these ports on your router to the Home Assistant machine. Give that machine a fixed IP address first (DHCP reservation), otherwise the forwarding stops working when the address changes.

| Port | Protocol | Router | Purpose |
|------|----------|--------|---------|
| 4662 | TCP | forward | ed2k client connections |
| 4672 | UDP | forward | Kad and extended requests |
| 4711 | TCP | **do not forward** | eMule web interface, local network only |

If you change the ports inside eMule, change them in the add-on **Network** tab as well.

### Check the connection

In the status bar at the bottom of eMule you should see an **ed2k High ID** and **Kad: Connected** (open, not firewalled). If you get a Low ID:

- check that the forwarding points to the right IP and that the IP is fixed;
- check for a second router in front of yours (double NAT);
- ask your provider whether you are behind CGNAT (shared public IP): in that case port forwarding is not possible and you will stay on Low ID.

### Why UPnP does not work

The add-on runs in its own Docker network, so eMule cannot talk to your router and UPnP will not work. Forward the two ports by hand, and turn UPnP off in **Options → Connection** to avoid errors in the log.

### eMule web interface (port 4711)

The web interface lets you see the queue and add downloads from a PC, tablet or phone on your network.

1. In eMule go to **Options → Web Interface**, enable the web server and set a **strong, unique administrator password**. Apply.
2. In Home Assistant open the add-on, tab **Network**, and set a host port for `4711/tcp` (for example 4711). Save and restart the add-on.
3. From any device on your network open `http://<IP-of-Home-Assistant>:4711`.

### Security

- Never forward port 4711 on your router. The web server uses plain HTTP, so the password travels unencrypted, and it is not meant to be exposed to the internet.
- To reach it from outside your home, use a VPN (for example WireGuard) or Tailscale, then use the same local address.
- The remote desktop is available only through Home Assistant ingress and is not exposed on the network.
- The only ports reachable from the internet are the two you forward yourself.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `resolution` | `1600x900` | Size of the virtual desktop (1280x720, 1366x768, 1600x900 or 1920x1080) |
| `download_path` | `/media/emule` | Base folder for downloads (`Incoming` and `Temp` are created inside it) |
| `require_external_disk` | `false` | Turn it on when `download_path` is on an external disk. If the disk is missing, the add-on waits up to 3 minutes and then stops instead of writing to the system disk |
| `install_vcredist` | `false` | Installs the Visual C++ runtime once. Enable it only if eMule does not start |

Network ports can be changed in the **Network** tab. After changing options, restart the add-on.

## Storage

### Default

Without any change, downloads go to `/media/emule/Incoming` and temporary files to `/media/emule/Temp`, on the Home Assistant system disk.

### Use another disk

To keep downloads off the system disk, connect the drive and make Home Assistant use it as **Media** storage (**Settings → System → Storage**). It then appears as a folder under `/media`, for example `/media/Volume`. You can list the folders from a terminal add-on with `ls /media`.

1. Set `download_path` to a folder on that disk, for example `/media/Volume/emule`, and turn on `require_external_disk`.
2. Restart the add-on and check the log: you should see `Disk found at /media/Volume`.
3. In eMule open **Options → Directories** and set the Incoming and Temp folders to `Z:\media\Volume\emule\Incoming` and `Z:\media\Volume\emule\Temp`. This step is needed because eMule keeps its own copy of the paths after the first start.
4. Move any file already downloaded from the old folder, then delete the old folder from the system disk.

The paths of the form `Z:\media\...` are the same as `/media/...` in Home Assistant: `Z:` is the root of the add-on.

### Several disks

`download_path` accepts a single folder, so Incoming and Temp live on one disk. Other disks can still be used:

- **Share folders from other disks:** in **Options → Directories**, expand `Z:` → `media` → your disk and tick the folder you want to share. Ctrl-click includes the subfolders.
- **Send finished downloads to another disk:** eMule categories can have their own Incoming folder. In the **Transfers** window edit a category and choose a folder on the other disk (for example `Z:\media\Disk2\movies`).

Only the disk of `download_path` is checked by `require_external_disk`. If a disk used by a category is missing, the same problem can happen: the folder would be created on the system disk. Keep that in mind when you unplug disks.

### Filesystems

- **ext4** is the most robust choice for a disk that stays connected.
- **exFAT** works well (it is what the author tested with), but it has no journal: do not unplug the disk while eMule is running, or the filesystem can be damaged.
- **FAT32** cannot hold files larger than 4 GB: do not use it.
- Temporary files cause many small writes. An SSD or a hard disk is fine; a cheap USB stick will wear out quickly.
- Do not put `Temp` on network storage (SMB/NFS): it is slow and eMule works poorly with it. A NAS is fine for finished files you copy there later.

### Disconnect the disk safely

If you want to unplug the disk to copy the files directly from another computer (faster than the network):

1. **Stop the add-on** from Home Assistant. Quitting from eMule's own menu is not enough, because the add-on restarts it.
2. In a terminal add-on run `sync`, then wait a few seconds.
3. Unplug the disk and copy only the finished files from `Incoming`. The `.part` files in `Temp` are incomplete downloads.
4. Plug the disk back in and wait about 30 seconds. Check with `ls /media/Volume` that it is mounted, then start the add-on.

If the add-on is started with the disk missing and `require_external_disk` is on, it waits up to 3 minutes and then stops with an explanation in the log.

## Optimization

### What to expect

On the author's x86_64 mini PC, at idle:

- `emule.exe` uses about 11% of one CPU core and the Wine server (`wineserver`) another 11%. Home Assistant shows about 5–6% for the add-on.
- The memory is about 2% of an 8 GB host (`emule.exe` itself is about 64 MB).

This idle cost comes from eMule running under Wine and did **not** change when eMule was disconnected from the networks or when nobody had the interface open.

### Recommendations

- **Disk:** put `Incoming` and `Temp` on a local SSD or hard disk, not on network storage.
- **Limits:** set the upload limit to about 80% of your real upload speed and avoid dozens of simultaneous downloads.
- **Shared files:** every shared file is hashed once and stays in memory, so share only what you want to share. A very large library makes the first start slower.
- **Desktop size:** a smaller `resolution` uses a little less memory.
- **Priority:** since version 0.1.5 eMule runs at low priority (`nice 10`). There is nothing to configure: when the host is busy, other services get the CPU first.
- **Web interface:** it adds a negligible load while idle. If you leave a page open with automatic refresh, increase the refresh interval or close the page when you do not need it.

### What did not help

In our tests, lowering the maximum number of connections and the refresh interval of the statistics did not reduce the idle CPU. Do not expect a gain from those settings.

### Measure it yourself (optional)

If you use a terminal add-on with protection mode off, this prints the processes of the add-on (second reading, averaged over 60 seconds):

```
docker exec $(docker ps --format '{{.Names}}' | grep -i emule) top -b -n 2 -d 60 -o %CPU | awk '/^top/{n++} n==2' | head -10
```

## Data and backups

- Settings, credits and the download queue are stored in the add-on data folder and are included in Home Assistant backups.
- Downloads are stored in `/media` (or `/share`) and are **not** part of the add-on backup.

## Updating

Updates appear in Home Assistant like any other add-on update, and your settings are kept. Changes are listed in the [CHANGELOG](emule/CHANGELOG.md) and in the GitHub releases.

## Troubleshooting

| Problem | What to do |
|---------|------------|
| The sidebar page is empty after the first start | Wait one or two minutes while the Wine environment is created, then reload. Check the add-on log |
| eMule does not start | Enable `install_vcredist`, restart the add-on and read the log lines starting with `[emule-addon]` |
| The add-on stops at start with "is not a separate mounted disk" | The external disk is not connected or not mounted. Check `ls /media` and the Storage page; if the folder is meant to be on the system disk, turn off `require_external_disk` |
| Low ID or Kad "firewalled" | Check the port forwarding, the fixed IP, double NAT and CGNAT (see [Network and ports](#network-and-ports)) |
| Downloads are not in the folder I chose | In eMule check **Options → Directories**: the paths must be `Z:\media\...` |
| The interface is too small or too large | Change `resolution` and restart the add-on |
| The web interface does not open | Check the host port for `4711/tcp` in the Network tab, the password, and that you use `http://`, not `https://` |

When you report a problem, include the add-on log and the version number.

## Limitations

- amd64 only.
- The interface is a remote desktop in the browser: it works on a tablet, but it is not comfortable on a phone. Use the web interface instead.
- UPnP does not work, ports must be forwarded by hand.
- Some Windows-only integrations (shell extensions, tray notifications, opening ed2k links from the browser) do not apply.
- The external disk check runs only when the add-on starts. If the disk is removed while eMule is running, stop the add-on first.

## Legal notice

eMule is a legitimate program, but sharing copyrighted material without permission is illegal in most countries. You are responsible for what you download and share.

This project is not affiliated with the eMule Project or its maintainers.

## Credits

- [eMule Community](https://github.com/irwir/eMule), distributed under the GNU GPL.
- [Wine](https://www.winehq.org/), [noVNC](https://novnc.com/) and [x11vnc](https://github.com/LibVNC/x11vnc).

## Italiano

La documentazione in italiano è in [README.it.md](README.it.md).
