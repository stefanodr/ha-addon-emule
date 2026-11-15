# eMule add-on for Home Assistant

[![Add repository to my Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fstefanodr%2Fha-addon-emule)

Run the real **eMule** (the Windows client for the eD2K and Kad networks) inside Home Assistant OS. The add-on runs eMule Community under Wine and shows its full interface in the Home Assistant sidebar, so you get the same program, with all its features, without a Windows PC.

> **Status: experimental.** The add-on is new and still needs testing on real installations. Please open an issue if something does not work.

## Requirements

- Home Assistant OS or Supervised installation
- **amd64 (x86_64) only**: mini PCs, NUCs, virtual machines. Raspberry Pi and other ARM boards are not supported, because eMule is an x86 program.

## Installation

1. In Home Assistant go to **Settings → Add-ons → Add-on Store**.
2. Open the menu (top right) → **Repositories** and add `https://github.com/stefanodr/ha-addon-emule`, or use the button at the top of this page.
3. Find **eMule** in the store and click **Install**.
4. Start the add-on and enable **Show in sidebar**.
5. Open **eMule** from the sidebar.

## First start

The first start creates the Wine environment and can take a minute or two. After that eMule opens with default settings: downloads go to `/media/emule/Incoming`, temporary files to `/media/emule/Temp`, and it connects to the network automatically.

## Network and ports

To get a High ID (and much better speeds) forward these ports on your router to the Home Assistant machine:

| Port | Protocol | Purpose |
|------|----------|---------|
| 4662 | TCP | ed2k client connections |
| 4672 | UDP | Kad and extended requests |

If you change the ports inside eMule, change them in the add-on **Network** tab as well.

The eMule web server (port 4711) is optional. Enable it in eMule (Options → Web Interface), then set a host port for 4711 in the add-on **Network** tab.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `resolution` | `1600x900` | Size of the virtual desktop |
| `download_path` | `/media/emule` | Base folder for downloads (`Incoming` and `Temp` are created inside it) |
| `install_vcredist` | `false` | Installs the Visual C++ runtime once. Enable it only if eMule does not start |

## Data and backups

- Settings, credits and the download queue are stored in the add-on data folder and are included in Home Assistant backups.
- Downloads are stored in `/media` (or `/share`) and are **not** part of the add-on backup.

## Limitations

- amd64 only.
- The interface is a remote desktop in the browser, so it is not meant for phone screens.
- Some Windows-only integrations (shell extensions, tray notifications) do not apply.

## Legal notice

eMule is a legitimate program, but sharing copyrighted material without permission is illegal in most countries. You are responsible for what you download and share.

This project is not affiliated with the eMule Project or its maintainers. eMule Community is developed at <https://github.com/irwir/eMule> and is distributed under the GNU GPL.

## Italiano

La documentazione in italiano è in [README.it.md](README.it.md).
