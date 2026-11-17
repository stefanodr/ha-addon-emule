# HaMedia

## English

HaMedia publishes folders of your media storage as a DLNA/UPnP media server, so your TV finds it in its list of media servers. It is read-only and does not convert files.

### Quick start

1. In **Configuration**, set `media_dirs` to the folders to publish (default `/media/emule/Incoming`). Only folders under `/media` or `/share` are accepted.
2. Start the add-on and open the list of media servers on your TV. **HaMedia** (or the name you set in `server_name`) appears within a minute.
3. To check without a TV, open `http://<IP-of-Home-Assistant>:8200/` in a browser: the page shows how many files were indexed.

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `server_name` | `HaMedia` | Name shown by the TV |
| `media_dirs` | `/media/emule/Incoming` | Folders to publish |
| `media_type` | `all` | `all`, `video`, `audio` or `pictures` |
| `port` | `8200` | HTTP port of the media server |
| `require_external_disk` | `false` | For folders on an external disk: wait up to 3 minutes for it at start, then stop |
| `rescan_on_start` | `true` | Rescan the folders at every start |

### Network

The add-on uses the **host network** (needed for DLNA discovery). DLNA has no password: anyone on your network can browse the published folders. Do not forward its ports on your router.

If you unplug and plug the disk again, restart the add-on. Stop the add-on before unplugging the disk.

Full documentation: <https://github.com/stefanodr/ha-addon-emule/blob/main/hamedia/README.md>

## Italiano

HaMedia pubblica cartelle della tua archiviazione multimediale come server multimediale DLNA/UPnP, così la TV lo trova nell'elenco dei server multimediali. È in sola lettura e non converte i file.

### Avvio rapido

1. In **Configurazione**, imposta `media_dirs` con le cartelle da pubblicare (predefinita `/media/emule/Incoming`). Sono accettate solo cartelle sotto `/media` o `/share`.
2. Avvia l'add-on e apri l'elenco dei server multimediali della TV. **HaMedia** (o il nome impostato in `server_name`) compare entro un minuto.
3. Per controllare senza la TV, apri `http://<IP-di-Home-Assistant>:8200/` in un browser: la pagina mostra quanti file sono stati indicizzati.

### Opzioni

| Opzione | Predefinito | Descrizione |
|---------|-------------|-------------|
| `server_name` | `HaMedia` | Nome mostrato dalla TV |
| `media_dirs` | `/media/emule/Incoming` | Cartelle da pubblicare |
| `media_type` | `all` | `all`, `video`, `audio` o `pictures` |
| `port` | `8200` | Porta HTTP del server multimediale |
| `require_external_disk` | `false` | Per cartelle su un disco esterno: all'avvio aspetta il disco fino a 3 minuti, poi si ferma |
| `rescan_on_start` | `true` | Riscansiona le cartelle a ogni avvio |

### Rete

L'add-on usa la **rete dell'host** (necessaria per la scoperta DLNA). DLNA non ha password: chiunque sulla tua rete può sfogliare le cartelle pubblicate. Non inoltrare le sue porte sul router.

Se scolleghi e ricolleghi il disco, riavvia l'add-on. Ferma l'add-on prima di scollegare il disco.

Documentazione completa: <https://github.com/stefanodr/ha-addon-emule/blob/main/hamedia/README.it.md>
