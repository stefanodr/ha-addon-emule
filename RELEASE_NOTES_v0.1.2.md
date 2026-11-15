## eMule add-on v0.1.2

### Fixed
- eMule used its default `config`, `incoming` and `temp` folders inside the container, so settings and downloads were lost when the add-on was updated. They now point to persistent locations: configuration in the add-on data folder, downloads in `/media/emule/Incoming` and `/media/emule/Temp` (or the folder set in `download_path`).

### Note
- If you changed the folders manually in eMule while on 0.1.1, check **Options → Directories** after updating.

---

## Add-on eMule v0.1.2

### Correzioni
- eMule usava le cartelle predefinite `config`, `incoming` e `temp` dentro il contenitore, quindi impostazioni e download andavano persi aggiornando l'add-on. Ora puntano a percorsi persistenti: configurazione nella cartella dati dell'add-on, download in `/media/emule/Incoming` e `/media/emule/Temp` (o nella cartella impostata in `download_path`).

### Nota
- Se con la 0.1.1 hai cambiato le cartelle a mano in eMule, dopo l'aggiornamento controlla **Opzioni → Cartelle**.
