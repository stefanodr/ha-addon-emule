# Add-on eMule per Home Assistant

[![Aggiungi il repository al mio Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fstefanodr%2Fha-addon-emule)

Esegui il vero **eMule** (il client Windows per le reti eD2K e Kad) dentro Home Assistant OS. L'add-on avvia eMule Community con Wine e mostra l'interfaccia completa nella barra laterale di Home Assistant: stesso programma, con tutte le funzioni, senza bisogno di un PC Windows.

> **Stato: stabile.** Prima versione stabile. È stato provato su Home Assistant OS in esecuzione su un mini PC x86_64, con i download su un SSD USB. Se qualcosa non funziona nella tua configurazione, apri una issue.

> **Nello stesso repository c'è anche [HaMedia](hamedia/README.it.md)**, un server multimediale DLNA che mostra in TV i file scaricati, come fa il server multimediale di un router.

> **Nello stesso repository c'è anche [aMule](amule/README.it.md)**, un'alternativa nativa e leggera (senza Wine) con interfaccia web: circa 15 volte meno CPU a riposo. Scegli questo add-on se vuoi esattamente il programma Windows, aMule per un downloader sempre acceso.

## Funzioni

- Il vero **eMule Community 0.70b** (64 bit), non un clone: reti eD2K e Kad, crediti, coda, ricerca, categorie, filtro IP, scheduler e web server integrato.
- Interfaccia completa nella barra laterale di Home Assistant tramite ingress, utilizzabile da qualsiasi browser o dall'app di Home Assistant.
- **Interfaccia web** di eMule facoltativa, per controllare la coda e aggiungere download da qualsiasi dispositivo della rete, senza passare da Home Assistant.
- Impostazioni, crediti e coda dei download restano dopo riavvii e aggiornamenti, e sono inclusi nei backup di Home Assistant.
- I download possono andare su qualsiasi disco visibile in `/media` o `/share`, con un **controllo di sicurezza** che ferma l'add-on se un disco esterno manca, invece di riempire il disco di sistema.
- Gira a priorità bassa, quindi telecamere, automazioni e altri add-on hanno la precedenza quando l'host è carico.
- Opzioni tradotte in inglese e italiano.

## Requisiti

- Home Assistant OS oppure installazione Supervised.
- **Solo amd64 (x86_64)**: mini PC, NUC, macchine virtuali. Raspberry Pi e altre schede ARM non sono supportate, perché eMule è un programma x86.
- Circa 200 MB di RAM libera e un po' di spazio su disco per i download.
- Un router in cui puoi inoltrare le porte (vedi [Rete e porte](#rete-e-porte)).

## Installazione

1. In Home Assistant vai su **Impostazioni → Add-on → Raccolta add-on**.
2. Apri il menu (in alto a destra) → **Repository** e aggiungi `https://github.com/stefanodr/ha-addon-emule`, oppure usa il pulsante in cima a questa pagina.
3. Cerca **eMule** nella raccolta e premi **Installa**. Il primo build scarica Wine ed eMule e può richiedere diversi minuti.
4. Avvia l'add-on e attiva **Mostra nella barra laterale** (e **Avvia all'avvio** se lo vuoi sempre attivo).
5. Apri **eMule** dalla barra laterale.

## Primo avvio

Al primo avvio viene creato l'ambiente Wine e possono servire un paio di minuti, quindi la pagina nella barra laterale può restare vuota per un po'. Poi eMule si apre con le impostazioni predefinite: i download vanno in `/media/emule/Incoming`, i file temporanei in `/media/emule/Temp` e la connessione alla rete è automatica.

Primi passi consigliati in eMule:

1. **Opzioni → Generale:** scegli il tuo nickname.
2. **Opzioni → Connessione:** inserisci la velocità reale della tua linea e imposta il limite di upload a circa l'80% dell'upload reale. Un upload saturo rallenta i download.
3. Inoltra le porte sul router (sezione seguente) e controlla di ottenere un **ID alto**.

## Usare eMule

### Aprire l'interfaccia

L'interfaccia è un desktop remoto mostrato nel browser. Apri **eMule** dalla barra laterale di Home Assistant: è protetta dal tuo accesso a Home Assistant. Si riconnette da sola se la connessione cade e si adatta alle dimensioni della pagina.

### Aggiungere download

- **Scheda Cerca** dentro eMule, come su Windows.
- **Link ed2k:** copia il link, poi nella finestra **Trasferimenti** usa il pulsante per incollare i link ed2k. Nel desktop remoto gli appunti del tuo dispositivo non sono condivisi in automatico: apri il pannello laterale del desktop remoto (piccola freccia sul bordo sinistro della pagina), incolla il link nella casella degli appunti, poi clicca dentro eMule e incolla.
- **Da telefono o tablet:** è più comodo usare l'interfaccia web di eMule (vedi sotto) e incollare il link nella sua pagina.

### Note d'uso

- Chiudere la scheda del browser non ferma nulla: eMule continua a girare dentro l'add-on.
- Se esci da eMule dal suo menu, l'add-on lo riavvia dopo 5 secondi. Per fermarlo davvero, ferma l'add-on da Home Assistant.
- Non spuntare l'unità `Z:` in **Opzioni → Cartelle → Cartelle condivise**: `Z:` è l'intero contenitore, compresa la configurazione dell'add-on. Condividi solo cartelle specifiche sotto `Z:\media\...` o `Z:\share\...`.

## Rete e porte

### Inoltro delle porte

Per ottenere un **ID alto** (e velocità molto migliori) inoltra queste porte dal router verso la macchina di Home Assistant. Assegna prima un indirizzo IP fisso a quella macchina (prenotazione DHCP), altrimenti l'inoltro smette di funzionare quando l'indirizzo cambia.

| Porta | Protocollo | Router | Uso |
|-------|------------|--------|-----|
| 4662 | TCP | inoltra | connessioni client ed2k |
| 4672 | UDP | inoltra | Kad e richieste estese |
| 4711 | TCP | **non inoltrare** | interfaccia web di eMule, solo rete locale |

Se cambi le porte dentro eMule, cambiale anche nella scheda **Rete** dell'add-on.

### Verificare la connessione

Nella barra di stato in basso di eMule devi vedere **ed2k ID alto** e **Kad: Connesso** (aperto, non firewalled). Se ottieni un ID basso:

- controlla che l'inoltro punti all'IP giusto e che l'IP sia fisso;
- controlla che non ci sia un secondo router davanti al tuo (doppio NAT);
- chiedi al provider se sei dietro CGNAT (IP pubblico condiviso): in quel caso l'inoltro delle porte non è possibile e resterai con ID basso.

### Perché l'UPnP non funziona

L'add-on gira in una sua rete Docker, quindi eMule non riesce a parlare con il router e l'UPnP non funziona. Inoltra a mano le due porte e disattiva l'UPnP in **Opzioni → Connessione** per evitare errori nel log.

### Interfaccia web di eMule (porta 4711)

L'interfaccia web permette di vedere la coda e aggiungere download da un PC, tablet o telefono della tua rete.

1. Attiva l'opzione `web_server` e imposta una `web_password` **forte e unica** (se la lasci vuota, una password casuale compare una sola volta nel log dell'add-on). In alternativa abilitala in eMule da **Opzioni → Interfaccia Web**.
2. In Home Assistant apri l'add-on, scheda **Rete**, e imposta una porta host per `4711/tcp` (per esempio 4711). Salva e riavvia l'add-on.
3. Da qualsiasi dispositivo della rete apri `http://<IP-di-Home-Assistant>:4711`.

### Sicurezza

- Non inoltrare mai la porta 4711 sul router. Il web server usa HTTP semplice, quindi la password viaggia in chiaro, e non è pensato per essere esposto su internet.
- Per raggiungerlo da fuori casa usa una VPN (per esempio WireGuard) o Tailscale, e poi lo stesso indirizzo locale.
- Il desktop remoto è disponibile solo tramite l'ingress di Home Assistant e non è esposto sulla rete.
- Le uniche porte raggiungibili da internet sono le due che inoltri tu.

## Configurazione

| Opzione | Predefinito | Descrizione |
|---------|-------------|-------------|
| `resolution` | `1600x900` | Dimensione del desktop virtuale (1280x720, 1366x768, 1600x900 o 1920x1080) |
| `download_path` | `/media/emule` | Cartella base dei download (al suo interno vengono create `Incoming` e `Temp`) |
| `require_external_disk` | `false` | Attivalo quando `download_path` è su un disco esterno. Se il disco manca, l'add-on aspetta fino a 3 minuti e poi si ferma, invece di scrivere sul disco di sistema |
| `install_vcredist` | `false` | Installa una volta il runtime Visual C++. Attivalo solo se eMule non si avvia |
| `nickname` | vuoto | Nome che vedono gli altri utenti ed2k. Vuoto mantiene quello impostato in eMule |
| `web_server` | `false` | Abilita il web server di eMule (porta 4711) a ogni avvio |
| `web_password` | vuota | Password dell'interfaccia web. Se vuota, ne viene generata una casuale e mostrata una volta nel log dell'add-on |
| `watchdog` | `true` | Ogni minuto controlla che eMule e il desktop remoto siano attivi e li riavvia se smettono di rispondere |

Le porte di rete si cambiano nella scheda **Rete**. Dopo aver cambiato le opzioni, riavvia l'add-on.

## Archiviazione

### Predefinita

Senza modifiche, i download vanno in `/media/emule/Incoming` e i file temporanei in `/media/emule/Temp`, sul disco di sistema di Home Assistant.

### Usare un altro disco

Per tenere i download fuori dal disco di sistema, collega l'unità e fai in modo che Home Assistant la usi come archiviazione **Media** (**Impostazioni → Sistema → Archiviazione**). Comparirà come cartella dentro `/media`, per esempio `/media/Volume`. Puoi vedere le cartelle da un add-on terminale con `ls /media`.

1. Imposta `download_path` su una cartella del disco, per esempio `/media/Volume/emule`, e attiva `require_external_disk`.
2. Riavvia l'add-on e controlla il log: devi vedere `Disk found at /media/Volume`.
3. In eMule apri **Opzioni → Cartelle** e imposta Incoming e Temp su `Z:\media\Volume\emule\Incoming` e `Z:\media\Volume\emule\Temp`. Serve perché eMule conserva una sua copia dei percorsi dopo il primo avvio.
4. Sposta i file già scaricati dalla vecchia cartella, poi cancella la vecchia cartella dal disco di sistema.

I percorsi del tipo `Z:\media\...` corrispondono a `/media/...` in Home Assistant: `Z:` è la radice dell'add-on.

### Più dischi

`download_path` accetta una sola cartella, quindi Incoming e Temp stanno su un solo disco. Gli altri dischi si possono usare comunque:

- **Condividere cartelle di altri dischi:** in **Opzioni → Cartelle** espandi `Z:` → `media` → il tuo disco e spunta la cartella da condividere. Con Ctrl-clic includi le sottocartelle.
- **Mandare i download completati su un altro disco:** le categorie di eMule possono avere una propria cartella Incoming. Nella finestra **Trasferimenti** modifica una categoria e scegli una cartella dell'altro disco (per esempio `Z:\media\Disco2\film`).

`require_external_disk` controlla solo il disco di `download_path`. Se manca un disco usato da una categoria, può succedere lo stesso problema: la cartella verrebbe creata sul disco di sistema. Tienilo presente quando scolleghi i dischi.

### Filesystem

- **ext4** è la scelta più robusta per un disco che resta collegato.
- **exFAT** funziona bene (è quello con cui l'autore ha provato), ma non ha journal: non scollegare il disco mentre eMule è in esecuzione, o il filesystem può danneggiarsi.
- **FAT32** non può contenere file più grandi di 4 GB: non usarlo.
- I file temporanei causano molte piccole scritture. Un SSD o un disco meccanico vanno bene; una chiavetta USB economica si consuma in fretta.
- Non mettere `Temp` su archiviazione di rete (SMB/NFS): è lento e eMule ci lavora male. Un NAS va bene per i file finiti che copi dopo.

### Scollegare il disco in sicurezza

Se vuoi scollegare il disco per copiare i file direttamente da un altro computer (più veloce della rete):

1. **Ferma l'add-on** da Home Assistant. Uscire dal menu di eMule non basta, perché l'add-on lo riavvia.
2. In un add-on terminale lancia `sync`, poi aspetta qualche secondo.
3. Scollega il disco e copia solo i file finiti da `Incoming`. I file `.part` in `Temp` sono download incompleti.
4. Ricollega il disco e aspetta circa 30 secondi. Controlla con `ls /media/Volume` che sia montato, poi avvia l'add-on.

Se l'add-on viene avviato con il disco assente e `require_external_disk` attivo, aspetta fino a 3 minuti e poi si ferma con una spiegazione nel log.

## Ottimizzazione

### Cosa aspettarsi

Sul mini PC x86_64 dell'autore, a riposo:

- `emule.exe` usa circa l'11% di un core e il server Wine (`wineserver`) un altro 11%. Home Assistant mostra circa il 5–6% per l'add-on.
- La memoria è circa il 2% di un host da 8 GB (`emule.exe` da solo circa 64 MB).

Questo consumo a riposo dipende da eMule che gira sotto Wine e **non** è cambiato né con eMule disconnesso dalle reti né con l'interfaccia chiusa.

### Consigli

- **Alternativa più leggera:** se il consumo a riposo conta più del programma Windows, usa l'[add-on aMule](amule/README.it.md): circa 15 volte meno CPU a riposo.

- **Disco:** metti `Incoming` e `Temp` su un SSD o un disco meccanico locale, non su archiviazione di rete.
- **Limiti:** imposta l'upload a circa l'80% dell'upload reale ed evita decine di download contemporanei.
- **File condivisi:** ogni file condiviso viene calcolato (hash) una volta e resta in memoria, quindi condividi solo ciò che vuoi condividere. Una libreria molto grande rende più lento il primo avvio.
- **Dimensione del desktop:** una `resolution` più piccola usa un po' meno memoria.
- **Priorità:** dalla versione 0.1.5 eMule gira a priorità bassa (`nice 10`). Non c'è nulla da configurare: quando l'host è carico, gli altri servizi hanno la precedenza sulla CPU.
- **Interfaccia web:** a riposo aggiunge un carico trascurabile. Se lasci una pagina aperta con aggiornamento automatico, aumenta l'intervallo di aggiornamento o chiudi la pagina quando non ti serve.

### Cosa non è servito

Nei nostri test, abbassare il numero massimo di connessioni e l'intervallo di aggiornamento delle statistiche non ha ridotto la CPU a riposo. Non aspettarti un guadagno da queste impostazioni.

### Misurare da solo (facoltativo)

Se usi un add-on terminale con la protezione disattivata, questo comando mostra i processi dell'add-on (seconda lettura, media su 60 secondi):

```
docker exec $(docker ps --format '{{.Names}}' | grep -i emule) top -b -n 2 -d 60 -o %CPU | awk '/^top/{n++} n==2' | head -10
```

## Dati e backup

- Impostazioni, crediti e coda dei download sono nella cartella dati dell'add-on e sono inclusi nei backup di Home Assistant.
- I download sono in `/media` (o `/share`) e **non** fanno parte del backup dell'add-on.

## Aggiornamenti

Gli aggiornamenti compaiono in Home Assistant come quelli di qualsiasi add-on, e le tue impostazioni vengono mantenute. Le modifiche sono elencate nel [CHANGELOG](emule/CHANGELOG.md) e nelle release di GitHub.

## Risoluzione dei problemi

| Problema | Cosa fare |
|----------|-----------|
| La pagina nella barra laterale è vuota dopo il primo avvio | Aspetta uno o due minuti mentre viene creato l'ambiente Wine, poi ricarica. Controlla il log dell'add-on |
| eMule non si avvia | Attiva `install_vcredist`, riavvia l'add-on e leggi le righe del log che iniziano con `[emule-addon]` |
| L'add-on si ferma all'avvio con "is not a separate mounted disk" | Il disco esterno non è collegato o non è montato. Controlla `ls /media` e la pagina Archiviazione; se la cartella deve stare sul disco di sistema, disattiva `require_external_disk` |
| ID basso o Kad "firewalled" | Controlla l'inoltro delle porte, l'IP fisso, il doppio NAT e il CGNAT (vedi [Rete e porte](#rete-e-porte)) |
| I download non sono nella cartella che ho scelto | In eMule controlla **Opzioni → Cartelle**: i percorsi devono essere `Z:\media\...` |
| L'interfaccia è troppo piccola o troppo grande | Cambia `resolution` e riavvia l'add-on |
| L'interfaccia web non si apre | Controlla la porta host di `4711/tcp` nella scheda Rete, la password e che usi `http://` e non `https://` |

Quando segnali un problema, allega il log dell'add-on e il numero di versione.

## Limitazioni

- Solo amd64.
- L'interfaccia è un desktop remoto nel browser: su tablet funziona, ma su telefono non è comoda. Usa invece l'interfaccia web.
- L'UPnP non funziona, le porte vanno inoltrate a mano.
- Alcune integrazioni solo Windows (estensioni della shell, notifiche nella tray, apertura dei link ed2k dal browser) non si applicano.
- Il controllo del disco esterno viene fatto solo all'avvio dell'add-on. Se il disco viene rimosso mentre eMule è in esecuzione, ferma prima l'add-on.

## Avviso legale

eMule è un programma legittimo, ma condividere materiale protetto da copyright senza autorizzazione è illegale nella maggior parte dei paesi. Sei responsabile di ciò che scarichi e condividi.

Questo progetto non è affiliato al progetto eMule né ai suoi sviluppatori.

## Crediti

- [eMule Community](https://github.com/irwir/eMule), distribuito con licenza GNU GPL.
- [Wine](https://www.winehq.org/), [noVNC](https://novnc.com/) e [x11vnc](https://github.com/LibVNC/x11vnc).
