# eMule

## English

This add-on runs eMule Community under Wine. Open **eMule** from the sidebar to use the full interface. amd64 (x86_64) only.

### Quick start

1. Start the add-on, enable **Show in sidebar** and open the entry. The first start can take a couple of minutes.
2. Forward **TCP 4662** and **UDP 4672** on your router to this machine (with a fixed IP) to get a High ID. Do not forward 4711. UPnP does not work in this add-on.
3. Downloads are saved in `/media/emule/Incoming` by default.

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `resolution` | `1600x900` | Size of the virtual desktop |
| `download_path` | `/media/emule` | Base folder for downloads (`Incoming` and `Temp` are created inside) |
| `require_external_disk` | `false` | Use it when `download_path` is on an external disk: if the disk is missing, the add-on stops instead of writing to the system disk |
| `install_vcredist` | `false` | Enable only if eMule does not start |
| `nickname` | empty | Name other users see; empty keeps the one set in eMule |
| `web_server` | `false` | Enables the eMule web server (port 4711) at every start |
| `web_password` | empty | Password of the web interface; if empty, a random one is generated and logged once |
| `watchdog` | `true` | Every minute checks eMule and the remote desktop and restarts them if they stop responding |

### External disk

1. Make the disk available as **Media** storage (Settings → System → Storage). It appears under `/media`, for example `/media/Volume`.
2. Set `download_path` to `/media/Volume/emule`, turn on `require_external_disk` and restart.
3. In eMule, **Options → Directories**, set Incoming and Temp to `Z:\media\Volume\emule\Incoming` and `Z:\media\Volume\emule\Temp`.

Before unplugging the disk, stop the add-on and run `sync`. Do not unplug an exFAT disk while eMule is running.

### Web interface

Enable it with the `web_server` option (and optionally `web_password`; otherwise a random password is shown in the log), or in eMule (**Options → Web Interface**). Then set a host port for `4711/tcp` in the **Network** tab and open `http://<IP-of-Home-Assistant>:4711`. Keep it on the local network: never forward it on the router.

### Problems

If eMule does not start, enable `install_vcredist`, restart the add-on and read the log lines starting with `[emule-addon]`.

Full documentation (storage, several disks, optimization, troubleshooting): <https://github.com/stefanodr/ha-addon-emule>

## Italiano

Questo add-on esegue eMule Community con Wine. Apri **eMule** dalla barra laterale per usare l'interfaccia completa. Solo amd64 (x86_64).

### Avvio rapido

1. Avvia l'add-on, attiva **Mostra nella barra laterale** e apri la voce. Il primo avvio può richiedere un paio di minuti.
2. Inoltra **TCP 4662** e **UDP 4672** dal router verso questa macchina (con IP fisso) per ottenere un ID alto. Non inoltrare la 4711. L'UPnP non funziona in questo add-on.
3. I download vengono salvati in `/media/emule/Incoming` per impostazione predefinita.

### Opzioni

| Opzione | Predefinito | Descrizione |
|---------|-------------|-------------|
| `resolution` | `1600x900` | Dimensione del desktop virtuale |
| `download_path` | `/media/emule` | Cartella base dei download (al suo interno vengono create `Incoming` e `Temp`) |
| `require_external_disk` | `false` | Usalo quando `download_path` è su un disco esterno: se il disco manca, l'add-on si ferma invece di scrivere sul disco di sistema |
| `install_vcredist` | `false` | Attivalo solo se eMule non si avvia |
| `nickname` | vuoto | Nome che vedono gli altri utenti; vuoto mantiene quello impostato in eMule |
| `web_server` | `false` | Abilita il web server di eMule (porta 4711) a ogni avvio |
| `web_password` | vuota | Password dell'interfaccia web; se vuota ne viene generata una casuale e mostrata una volta nel log |
| `watchdog` | `true` | Ogni minuto controlla eMule e il desktop remoto e li riavvia se smettono di rispondere |

### Disco esterno

1. Rendi il disco disponibile come archiviazione **Media** (Impostazioni → Sistema → Archiviazione). Compare sotto `/media`, per esempio `/media/Volume`.
2. Imposta `download_path` su `/media/Volume/emule`, attiva `require_external_disk` e riavvia.
3. In eMule, **Opzioni → Cartelle**, imposta Incoming e Temp su `Z:\media\Volume\emule\Incoming` e `Z:\media\Volume\emule\Temp`.

Prima di scollegare il disco, ferma l'add-on e lancia `sync`. Non scollegare un disco exFAT mentre eMule è in esecuzione.

### Interfaccia web

Abilitala con l'opzione `web_server` (e, facoltativamente, `web_password`; altrimenti nel log compare una password casuale) oppure in eMule (**Opzioni → Interfaccia Web**). Poi imposta una porta host per `4711/tcp` nella scheda **Rete** e apri `http://<IP-di-Home-Assistant>:4711`. Tienila sulla rete locale: non inoltrarla mai sul router.

### Problemi

Se eMule non si avvia, attiva `install_vcredist`, riavvia l'add-on e leggi le righe del log che iniziano con `[emule-addon]`.

Documentazione completa (archiviazione, più dischi, ottimizzazione, risoluzione dei problemi): <https://github.com/stefanodr/ha-addon-emule>
