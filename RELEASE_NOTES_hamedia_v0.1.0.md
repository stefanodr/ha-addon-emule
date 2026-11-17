## HaMedia v0.1.0 — first release (experimental)

A new add-on in this repository: a **DLNA/UPnP media server** for Home Assistant, built on MiniDLNA. Smart TVs, consoles and players on your network find it by themselves, like the media server of a router. It was made to watch the files downloaded with the eMule add-on, but it works with any folder under `/media` or `/share`.

### Features
- Read-only publication of one or more folders, with an optional filter (all, video, audio, pictures)
- Automatic detection of new files, and a rescan at every start
- Optional wait for the external disk at start (`require_external_disk`)
- No transcoding: very light on the host
- Options translated into English and Italian

### Notes
- Experimental: the media server was tested on its own, the add-on still needs testing on real Home Assistant installations.
- It uses the **host network**, which DLNA discovery needs. DLNA has no password: do not forward its ports on your router.
- Formats and subtitles depend on the TV.

---

## HaMedia v0.1.0 — prima release (sperimentale)

Un nuovo add-on in questo repository: un **server multimediale DLNA/UPnP** per Home Assistant, basato su MiniDLNA. Smart TV, console e lettori della tua rete lo trovano da soli, come fanno con il server multimediale di un router. Nasce per guardare i file scaricati con l'add-on eMule, ma funziona con qualsiasi cartella sotto `/media` o `/share`.

### Funzioni
- Pubblicazione in sola lettura di una o più cartelle, con filtro facoltativo (tutto, video, audio, immagini)
- Rilevamento automatico dei file nuovi e riscansione a ogni avvio
- Attesa facoltativa del disco esterno all'avvio (`require_external_disk`)
- Nessuna transcodifica: molto leggero per l'host
- Opzioni tradotte in inglese e italiano

### Note
- Sperimentale: il server multimediale è stato provato da solo, l'add-on va ancora provato su installazioni reali di Home Assistant.
- Usa la **rete dell'host**, necessaria per la scoperta DLNA. DLNA non ha password: non inoltrare le sue porte sul router.
- Formati e sottotitoli dipendono dalla TV.
