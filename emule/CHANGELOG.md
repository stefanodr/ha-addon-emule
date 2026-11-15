# Changelog

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
