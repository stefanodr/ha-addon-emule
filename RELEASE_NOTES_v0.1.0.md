## eMule add-on v0.1.0

First experimental release. Runs eMule Community 0.70b under Wine and shows the full interface in the Home Assistant sidebar.

### What's included
- eMule Community 0.70b (64-bit), downloaded at build time and verified by SHA-256
- Full interface through Home Assistant ingress (noVNC), no extra ports needed to use it
- Default configuration on first start: downloads in `/media/emule/Incoming`, temporary files in `/media/emule/Temp`
- Ports 4662/TCP and 4672/UDP exposed; optional port 4711 for the eMule web server
- Options: `resolution`, `download_path`, `install_vcredist`
- English and Italian translations of the options

### Known limitations
- amd64 only (no Raspberry Pi / ARM)
- Experimental: not yet validated on many installations, please report problems in the issues

---

## Add-on eMule v0.1.0

Prima release sperimentale. Esegue eMule Community 0.70b con Wine e mostra l'interfaccia completa nella barra laterale di Home Assistant.

### Cosa include
- eMule Community 0.70b (64 bit), scaricato in fase di build e verificato con SHA-256
- Interfaccia completa tramite ingress di Home Assistant (noVNC), senza porte aggiuntive per usarla
- Configurazione predefinita al primo avvio: download in `/media/emule/Incoming`, file temporanei in `/media/emule/Temp`
- Porte 4662/TCP e 4672/UDP esposte; porta 4711 facoltativa per il web server di eMule
- Opzioni: `resolution`, `download_path`, `install_vcredist`
- Traduzioni delle opzioni in inglese e italiano

### Limitazioni note
- Solo amd64 (niente Raspberry Pi / ARM)
- Sperimentale: non ancora validato su molte installazioni, segnala i problemi nelle issue
