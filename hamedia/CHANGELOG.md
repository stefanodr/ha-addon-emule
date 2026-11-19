# Changelog

## 0.1.3

**English**

- The icon shown by TVs and players in their list of media servers is now the same television with a play button used by the add-on. MiniDLNA is rebuilt during the image build with its four built-in icons replaced.
- The first build/update takes a few minutes longer because MiniDLNA is compiled.
- Some TVs keep the old icon in a cache: if it does not change, restart the TV or reopen the media server list.

**Italiano**

- L'icona mostrata da TV e lettori nell'elenco dei server multimediali è ora la stessa televisione con tasto play usata dall'add-on. MiniDLNA viene ricompilato durante la creazione dell'immagine sostituendo le sue quattro icone interne.
- La prima installazione/aggiornamento richiede qualche minuto in più perché MiniDLNA viene compilato.
- Alcune TV conservano la vecchia icona in cache: se non cambia, riavvia la TV o riapri l'elenco dei server multimediali.

## 0.1.2

**English**

- New icon and logo: a television with a play button, which says more clearly what the add-on is.
- No change to the add-on behavior.

**Italiano**

- Nuova icona e nuovo logo: una televisione con un tasto play, che dice più chiaramente cos'è l'add-on.
- Nessuna modifica al comportamento dell'add-on.

## 0.1.1

**English**

- Fix: the add-on stopped at start with "Failed to open log file '/var/log/minidlna/minidlna.log'". The log folder is now created in the add-on data folder, and what MiniDLNA writes there is shown in the add-on log.

**Italiano**

- Correzione: l'add-on si fermava all'avvio con "Failed to open log file '/var/log/minidlna/minidlna.log'". Ora la cartella di log viene creata nella cartella dati dell'add-on e ciò che MiniDLNA vi scrive compare nel log dell'add-on.

## 0.1.0

**English**

- First experimental release.
- DLNA/UPnP media server based on MiniDLNA, so TVs and players find it in their list of media servers.
- Read-only publication of one or more folders under `/media` or `/share`, with an optional filter (all, video, audio, pictures).
- Options: `server_name`, `media_dirs`, `media_type`, `port`, `require_external_disk`, `rescan_on_start`.
- Optional wait for the external disk at start, as in the eMule add-on.
- Uses the host network (needed for DLNA discovery).

**Italiano**

- Prima release sperimentale.
- Server multimediale DLNA/UPnP basato su MiniDLNA, così TV e lettori lo trovano nell'elenco dei server multimediali.
- Pubblicazione in sola lettura di una o più cartelle sotto `/media` o `/share`, con filtro facoltativo (tutto, video, audio, immagini).
- Opzioni: `server_name`, `media_dirs`, `media_type`, `port`, `require_external_disk`, `rescan_on_start`.
- Attesa facoltativa del disco esterno all'avvio, come nell'add-on eMule.
- Usa la rete dell'host (necessaria per la scoperta DLNA).
