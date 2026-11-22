## eMule add-on v0.2.0

### What's new
- New options: `nickname`, `web_server`, `web_password`, `watchdog`.
- `web_server` enables the eMule web server (port 4711) at every start with `web_password` (a random password is generated and shown once in the log if empty). Set a host port for 4711/tcp in the Network tab to reach it.
- `watchdog` (on by default): every minute it restarts the remote desktop helpers if they stop, and restarts eMule if it runs without listening on its TCP port.
- Documentation: choosing between eMule and the new aMule add-on.

### Note
- No "low resource" mode: lowering connections or statistics does not reduce the idle CPU (it comes from Wine). For lower consumption use the aMule add-on.

---

## Add-on eMule v0.2.0

### Novità
- Nuove opzioni: `nickname`, `web_server`, `web_password`, `watchdog`.
- `web_server` abilita il web server di eMule (porta 4711) a ogni avvio con `web_password` (se vuota, ne viene generata una casuale e mostrata una volta nel log). Per raggiungerlo imposta una porta host per 4711/tcp nella scheda Rete.
- `watchdog` (attivo di default): ogni minuto riavvia gli aiuti del desktop remoto se si fermano e riavvia eMule se resta in esecuzione senza ascoltare sulla sua porta TCP.
- Documentazione: come scegliere tra eMule e il nuovo add-on aMule.

### Nota
- Nessuna modalità «risorse ridotte»: ridurre connessioni o statistiche non abbassa la CPU a riposo (dipende da Wine). Per consumi più bassi usa l'add-on aMule.
