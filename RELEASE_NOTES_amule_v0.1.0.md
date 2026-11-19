## aMule add-on v0.1.0 (experimental)

### What's new
- New add-on: the native Linux aMule 2.3.3 daemon with its web interface in the Home Assistant sidebar. No Wine and no virtual screen, so it is meant to use far fewer resources than the eMule add-on.
- Same ports as the eMule add-on (4662/TCP, 4672/UDP): run only one of the two at a time.
- Options: `download_path` (default `/media/amule`), `require_external_disk`, `nickname`, `web_password` (a random one is generated and logged if empty).

### Note
- aMule has its own identity and credits, separate from eMule. Your existing router port forwarding (4662/4672) works unchanged.

---

## Add-on aMule v0.1.0 (sperimentale)

### Novità
- Nuovo add-on: il demone nativo Linux aMule 2.3.3 con la sua interfaccia web nel menu laterale di Home Assistant. Niente Wine né schermo virtuale, quindi pensato per usare molte meno risorse dell'add-on eMule.
- Stesse porte dell'add-on eMule (4662/TCP, 4672/UDP): esegui un solo add-on alla volta.
- Opzioni: `download_path` (predefinita `/media/amule`), `require_external_disk`, `nickname`, `web_password` (se vuota ne viene generata una casuale e mostrata nel log).

### Nota
- aMule ha una propria identità e propri crediti, separati da eMule. Il port forwarding già impostato sul router (4662/4672) funziona senza modifiche.
