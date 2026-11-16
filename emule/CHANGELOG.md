# Changelog

## 0.1.6

**English**

- First **stable** release (the add-on is no longer marked as experimental).
- Complete rewrite of the documentation in English and Italian: first start, usage, network and ports, eMule web interface, security, storage (external disks, several disks, filesystems, safe disconnection), optimization with measured figures, troubleshooting.
- The add-on documentation tab now covers options, external disk and web interface in both languages.
- No change to the add-on behavior.

**Italiano**

- Prima versione **stabile** (l'add-on non è più indicato come sperimentale).
- Documentazione riscritta in modo completo in inglese e italiano: primo avvio, uso, rete e porte, interfaccia web di eMule, sicurezza, archiviazione (dischi esterni, più dischi, filesystem, scollegamento sicuro), ottimizzazione con dati misurati, risoluzione dei problemi.
- La scheda di documentazione dell'add-on ora tratta opzioni, disco esterno e interfaccia web in entrambe le lingue.
- Nessuna modifica al comportamento dell'add-on.

## 0.1.5

**English**

- eMule and its `wineserver` now run at low priority (`nice 10`), so a busy host gives CPU to other services first. The idle CPU usage itself is unchanged: it comes from eMule running under Wine, not from the network or the interface.

**Italiano**

- eMule e il suo `wineserver` ora girano a priorità bassa (`nice 10`), così, quando l'host è carico, la CPU va prima agli altri servizi. Il consumo a riposo non cambia: dipende da eMule sotto Wine, non dalla rete né dall'interfaccia.

## 0.1.4

**English**

- New option `require_external_disk`: when the download folder is on an external disk (for example `/media/Volume/emule`), the add-on checks at start that the disk is really mounted. If it is not, it waits up to 3 minutes and then stops with an explanation in the log, instead of silently writing to the system disk.
- README: new section on using an external disk.

**Italiano**

- Nuova opzione `require_external_disk`: quando la cartella dei download è su un disco esterno (per esempio `/media/Volume/emule`), all'avvio l'add-on controlla che il disco sia davvero montato. Se non lo è, aspetta fino a 3 minuti e poi si ferma con una spiegazione nel log, invece di scrivere in silenzio sul disco di sistema.
- README: nuova sezione sull'uso di un disco esterno.

## 0.1.3

**English**

- Lower idle CPU usage: the VNC server no longer polls the screen continuously (removed `-noxdamage`, added slower polling when idle).
- New icon and logo: a stylized mule.

**Italiano**

- Minore uso di CPU a riposo: il server VNC non controlla più lo schermo di continuo (rimosso `-noxdamage`, polling più lento quando non c'è attività).
- Nuova icona e nuovo logo: un mulo stilizzato.

## 0.1.2

**English**

- Fix: eMule used its default `config`, `incoming` and `temp` folders next to `emule.exe`, inside the container, so settings and downloads were lost on update. These folders now point to persistent locations (`/data/emule-config`, and `Incoming` / `Temp` under the download folder).

**Italiano**

- Correzione: eMule usava le cartelle predefinite `config`, `incoming` e `temp` accanto a `emule.exe`, dentro il contenitore, quindi impostazioni e download andavano persi con gli aggiornamenti. Ora queste cartelle puntano a percorsi persistenti (`/data/emule-config` e `Incoming` / `Temp` dentro la cartella dei download).

## 0.1.1

**English**

- Fix: the image build failed because `winetricks` is in Debian's `contrib` component; it is now enabled.

**Italiano**

- Correzione: il build dell'immagine falliva perché `winetricks` si trova nel componente `contrib` di Debian; ora è abilitato.

## 0.1.0

**English**

- First experimental release.
- Runs eMule Community 0.70b (64-bit, checksum-verified) under Wine.
- Full interface in the Home Assistant sidebar through ingress (noVNC).
- Default configuration seeded on first start: downloads in `/media/emule/Incoming`, temporary files in `/media/emule/Temp`.
- Ports 4662/TCP and 4672/UDP exposed; optional web server port 4711.
- Options: `resolution`, `download_path`, `install_vcredist`.
- amd64 only.

**Italiano**

- Prima release sperimentale.
- Esegue eMule Community 0.70b (64 bit, con verifica del checksum) con Wine.
- Interfaccia completa nella barra laterale di Home Assistant tramite ingress (noVNC).
- Configurazione predefinita creata al primo avvio: download in `/media/emule/Incoming`, file temporanei in `/media/emule/Temp`.
- Porte 4662/TCP e 4672/UDP esposte; porta 4711 facoltativa per il web server.
- Opzioni: `resolution`, `download_path`, `install_vcredist`.
- Solo amd64.
