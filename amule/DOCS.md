# aMule

## English

aMule is the native Linux client of the ed2k / Kad network. This add-on runs its daemon and web interface without Wine or a virtual screen, so it uses far fewer resources than the eMule add-on. It uses the same ports as the eMule add-on, so run only one of them at a time.

### Quick start

1. Start the add-on and open the log: the first time it prints the web interface password (or set your own in `web_password`).
2. Click **aMule** in the sidebar, log in with that password and use the **Search** page or paste ed2k links in **Transfers**.
3. Forward on your router **TCP 4662** and **UDP 4672** to Home Assistant, otherwise you stay on a "low ID" with fewer sources. UPnP is off.

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `download_path` | `/media/amule` | Base folder; `Incoming` and `Temp` are created inside |
| `require_external_disk` | off | Wait for a separate disk (for example `/media/Volume/amule`) and stop if it is missing |
| `nickname` | `HAmule` | Name other users see |
| `web_password` | empty | Web interface password; if empty a random one is generated and logged once |

### Notes

- Settings, credits and queue live in the add-on data and are included in backups.
- aMule has its own identity and credits: they are not shared with the eMule add-on.
- The web interface is reachable only through Home Assistant. aMule's control port is internal.

## Italiano

aMule è il client nativo Linux della rete ed2k / Kad. Questo add-on esegue il demone e l'interfaccia web senza Wine né schermo virtuale, quindi usa molte meno risorse dell'add-on eMule. Usa le stesse porte dell'add-on eMule, quindi eseguine uno solo alla volta.

### Avvio rapido

1. Avvia l'add-on e apri il log: la prima volta mostra la password dell'interfaccia web (oppure impostane una tua in `web_password`).
2. Clicca **aMule** nel menu laterale, accedi con quella password e usa la pagina **Cerca** o incolla i link ed2k in **Trasferimenti**.
3. Sul router inoltra **TCP 4662** e **UDP 4672** verso Home Assistant, altrimenti resti con "ID basso" e meno fonti. UPnP è disattivato.

### Opzioni

| Opzione | Predefinito | Descrizione |
|---------|-------------|-------------|
| `download_path` | `/media/amule` | Cartella base; dentro vengono create `Incoming` e `Temp` |
| `require_external_disk` | no | Aspetta un disco separato (per esempio `/media/Volume/amule`) e si ferma se manca |
| `nickname` | `HAmule` | Nome che vedono gli altri utenti |
| `web_password` | vuota | Password dell'interfaccia web; se vuota ne viene generata una casuale e mostrata una volta nel log |

### Note

- Impostazioni, crediti e coda stanno nei dati dell'add-on e sono inclusi nei backup.
- aMule ha una propria identità e propri crediti: non sono condivisi con l'add-on eMule.
- L'interfaccia web è raggiungibile solo tramite Home Assistant. La porta di controllo di aMule è interna.
