# HaMedia: server multimediale DLNA per Home Assistant

HaMedia pubblica cartelle dell'archiviazione multimediale di Home Assistant come **server multimediale DLNA/UPnP**, così smart TV, console e lettori della tua rete lo trovano da soli, come fanno con il server multimediale di un router. È basato su [MiniDLNA](https://sourceforge.net/projects/minidlna/) (ReadyMedia).

Nasce per guardare in TV i file scaricati con l'[add-on eMule](../README.it.md) dello stesso repository, ma funziona con qualsiasi cartella sotto `/media` o `/share`.

> **Stato: stabile.** Provato su Home Assistant OS su un mini PC x86_64, con i file su un SSD USB e una smart TV Samsung. Se qualcosa non funziona nella tua configurazione, apri una issue.

## Funzioni

- Compare nell'elenco dei server multimediali di TV e lettori, con il nome che scegli.
- **Sola lettura:** dalla TV non si può cancellare né modificare nulla.
- Una o più cartelle sotto `/media` o `/share`, con un filtro facoltativo (tutto, solo video, solo audio o solo immagini).
- I file nuovi vengono rilevati in automatico mentre l'add-on è in esecuzione, e le cartelle vengono riscansionate a ogni avvio.
- **Attesa del disco esterno** facoltativa all'avvio, come nell'add-on eMule.
- Molto leggero: nessuna transcodifica, serve i file così come sono.

## Requisiti

- Home Assistant OS oppure installazione Supervised.
- amd64 o aarch64 (nell'add-on nulla dipende dall'architettura, ma l'autore può provare solo amd64).
- Una TV o un lettore con supporto DLNA/UPnP, sulla stessa rete di Home Assistant.

## Installazione

1. Aggiungi il repository `https://github.com/stefanodr/ha-addon-emule` alla Raccolta add-on (vedi il [README principale](../README.it.md)).
2. Cerca **HaMedia** nella raccolta e premi **Installa**.
3. Nella scheda **Configurazione** scegli le cartelle da pubblicare. Per impostazione predefinita pubblica `/media/emule/Incoming`.
4. Avvia l'add-on.

## Uso

1. Dopo l'avvio, apri l'elenco dei server multimediali della TV o del lettore (il punto in cui compare già il server multimediale del router). **HaMedia** dovrebbe comparire entro un minuto; in caso contrario riavvia la TV o riapri l'elenco.
2. Sfoglia le cartelle e riproduci i file.
3. Per controllare che il server funzioni senza la TV, apri `http://<IP-di-Home-Assistant>:8200/` in un browser: la pagina di stato mostra quanti file video, audio e immagini ha indicizzato.

### Insieme all'add-on eMule

- Imposta la cartella dove eMule salva i download finiti, per esempio `/media/Volume/emule/Incoming`.
- Quella cartella contiene solo file completi: i download incompleti restano in `Temp`.
- eMule condivide tutto ciò che sta in `Incoming`. Se vuoi che la TV veda solo i film, crea una cartella separata (per esempio `/media/Volume/Film`), assegnala come cartella Incoming a una categoria di eMule e pubblica quella cartella con HaMedia.

## Configurazione

| Opzione | Predefinito | Descrizione |
|---------|-------------|-------------|
| `server_name` | `HaMedia` | Nome mostrato dalla TV o dal lettore (fino a 64 caratteri) |
| `media_dirs` | `/media/emule/Incoming` | Elenco delle cartelle da pubblicare. Sono accettate solo cartelle sotto `/media` o `/share` |
| `media_type` | `all` | `all`, `video`, `audio` o `pictures`: cosa pubblicare dalle cartelle |
| `port` | `8200` | Porta HTTP del server multimediale |
| `require_external_disk` | `false` | Attivalo quando le cartelle sono su un disco esterno (per esempio `/media/Volume/...`). All'avvio l'add-on aspetta il disco fino a 3 minuti, poi si ferma invece di pubblicare una libreria vuota |
| `rescan_on_start` | `true` | Riscansiona le cartelle a ogni avvio, per rilevare i file aggiunti o tolti mentre l'add-on era fermo |

Dopo aver cambiato le opzioni, riavvia l'add-on.

## Rete

- L'add-on usa la **rete dell'host**. La scoperta DLNA si basa su pacchetti multicast (SSDP, UDP 1900) che non attraversano la rete interna di Docker, quindi non c'è un altro modo per far trovare il server alla TV. Questo significa che l'add-on non è isolato dalla rete della macchina di Home Assistant.
- Usa la porta TCP 8200 (o quella che imposti) e la porta UDP 1900 sulla macchina di Home Assistant.
- DLNA non ha password: qualsiasi dispositivo della tua rete può sfogliare e riprodurre le cartelle pubblicate. Le cartelle sono in sola lettura. Pubblica solo ciò che sei contento di condividere in casa e non usarlo su una rete con ospiti di cui non ti fidi.
- **Non** inoltrare queste porte sul router.
- TV e Home Assistant devono stare sulla stessa rete (stessa sottorete). Alcuni router e access point bloccano il multicast tra Wi-Fi e cavo: se la TV non vede il server, controlla questa opzione.

## Disco esterno

Se le cartelle sono su un disco USB:

- Attiva `require_external_disk`, così all'avvio l'add-on aspetta il disco invece di costruire una libreria vuota.
- Se scolleghi e ricolleghi il disco, **riavvia l'add-on** perché osservi il nuovo montaggio.
- Ferma l'add-on prima di scollegare il disco, così non lo tiene occupato.

## Formati e sottotitoli

HaMedia non converte nulla: la TV deve essere in grado di riprodurre il file. La maggior parte delle TV riproduce `.mkv`, `.mp4` e `.avi` con i codec comuni, ma dipende dal modello. Se un file non parte sulla TV, provalo con un altro lettore per capire se il problema è il formato. Anche il supporto ai sottotitoli (per esempio un file `.srt` con lo stesso nome del video) dipende dalla TV.

## Risoluzione dei problemi

| Problema | Cosa fare |
|----------|-----------|
| La TV non vede il server | Controlla che l'add-on sia in esecuzione; apri `http://<IP>:8200/` da un PC; controlla che la TV sia sulla stessa rete e che il multicast non sia bloccato tra Wi-Fi e cavo; riavvia la TV |
| La libreria è vuota | Controlla la cartella in `media_dirs` e che il disco sia montato (`ls /media` in un add-on terminale); leggi il log dell'add-on |
| L'add-on si ferma all'avvio con "is not a separate mounted disk" | Il disco esterno non è collegato o non è montato. Collegalo e riavvia, oppure disattiva `require_external_disk` |
| I file nuovi non compaiono | Aspetta qualche minuto; se non compaiono, riavvia l'add-on |
| L'add-on non parte per colpa della porta | Un altro servizio usa la porta: cambia `port` |
| Un file è elencato ma non parte | Probabilmente è un formato che la TV non supporta |

Quando segnali un problema, allega il log dell'add-on e il numero di versione.

## Limitazioni

- Solo DLNA/UPnP, senza transcodifica e senza interfaccia web per sfogliare (la pagina di stato mostra solo i conteggi).
- Nessuna password e nessun utente separato.
- Il controllo del disco viene fatto solo all'avvio dell'add-on.

## Crediti

[MiniDLNA / ReadyMedia](https://sourceforge.net/projects/minidlna/), distribuito con licenza GNU GPL. Questo progetto non è affiliato ad esso.
