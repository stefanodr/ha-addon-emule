## aMule add-on v0.1.0 (experimental)

### What's new
- New add-on: the native Linux aMule 2.3.3 daemon with its web interface in the Home Assistant sidebar. No Wine and no virtual screen, so it is meant to use far fewer resources than the eMule add-on.
- Default ports 4663/TCP and 4673/UDP: it can run together with the eMule add-on, so you can compare them.
- Options: `download_path` (default `/media/amule`), `require_external_disk`, `nickname`, `web_password` (a random one is generated and logged if empty).

### Note
- aMule has its own identity and credits, separate from eMule. Forward the two new ports on your router.

---

## Add-on aMule v0.1.0 (sperimentale)

### Novità
- Nuovo add-on: il demone nativo Linux aMule 2.3.3 con la sua interfaccia web nel menu laterale di Home Assistant. Niente Wine né schermo virtuale, quindi pensato per usare molte meno risorse dell'add-on eMule.
- Porte predefinite 4663/TCP e 4673/UDP: può funzionare insieme all'add-on eMule, così puoi confrontarli.
- Opzioni: `download_path` (predefinita `/media/amule`), `require_external_disk`, `nickname`, `web_password` (se vuota ne viene generata una casuale e mostrata nel log).

### Nota
- aMule ha una propria identità e propri crediti, separati da eMule. Inoltra sul router le due nuove porte.
