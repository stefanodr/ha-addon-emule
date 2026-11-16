## eMule add-on v0.1.4

### Added
- New option `require_external_disk`. Turn it on when `download_path` is on an external disk (for example `/media/Volume/emule`). At start the add-on checks that the disk is really mounted; if it is not, it waits up to 3 minutes and then stops with an explanation in the log, instead of silently writing to the system disk.
- README: new section on using an external disk, including the eMule folder paths to set.

### Note
- The option is off by default, so existing installations are not affected.
- The check runs at start only. If the disk is removed while eMule is running, stop the add-on.

---

## Add-on eMule v0.1.4

### Novità
- Nuova opzione `require_external_disk`. Attivala quando `download_path` è su un disco esterno (per esempio `/media/Volume/emule`). All'avvio l'add-on controlla che il disco sia davvero montato; se non lo è, aspetta fino a 3 minuti e poi si ferma con una spiegazione nel log, invece di scrivere in silenzio sul disco di sistema.
- README: nuova sezione sull'uso di un disco esterno, con i percorsi da impostare in eMule.

### Nota
- L'opzione è disattivata di default, quindi le installazioni esistenti non cambiano.
- Il controllo viene fatto solo all'avvio. Se il disco viene rimosso mentre eMule è in esecuzione, ferma l'add-on.
