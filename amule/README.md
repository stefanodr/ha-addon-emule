# aMule add-on for Home Assistant

The native Linux **aMule** client for the eD2K and Kad networks, with its web interface in the Home Assistant sidebar. It runs without Wine and without a virtual screen, so it needs far fewer resources than the [eMule add-on](../README.md), which runs the real Windows eMule.

See [DOCS.md](DOCS.md) for installation, options and the first start. Italiano: [README.it.md](README.it.md).

## aMule or eMule?

Measured on the same mini PC (Home Assistant OS, downloads on a USB SSD):

| | eMule add-on (Wine) | aMule add-on |
|---|---|---|
| CPU at rest | 5.7-6.3% | **0.4%** |
| RAM at rest | 2.0-2.1% | **0.5%** |
| CPU downloading a film | 26.8% | **1.9%** |
| RAM downloading a film | 5.7% | **3%** |
| Interface | the real eMule window | simpler web interface |
| Advanced eMule Community options | all | some missing |

Choose **aMule** for an always-on downloader. Choose **eMule** if you want exactly the Windows program, with all its options.

- Both add-ons use the same ports (TCP 4662, UDP 4672): run only one at a time.
- The two keep separate identities and credits: they are not shared.
- Folders: aMule uses `/media/amule` by default, eMule `/media/emule`.
