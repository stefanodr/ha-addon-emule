# Add-on eMule per Home Assistant

[![Aggiungi il repository al mio Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fstefanodr%2Fha-addon-emule)

Esegui il vero **eMule** (il client Windows per le reti eD2K e Kad) dentro Home Assistant OS. L'add-on avvia eMule Community con Wine e mostra l'interfaccia completa nella barra laterale di Home Assistant: stesso programma, con tutte le funzioni, senza bisogno di un PC Windows.

> **Stato: sperimentale.** L'add-on è nuovo e va ancora provato su installazioni reali. Se qualcosa non funziona, apri una issue.

## Requisiti

- Home Assistant OS oppure installazione Supervised
- **Solo amd64 (x86_64)**: mini PC, NUC, macchine virtuali. Raspberry Pi e altre schede ARM non sono supportate, perché eMule è un programma x86.

## Installazione

1. In Home Assistant vai su **Impostazioni → Add-on → Raccolta add-on**.
2. Apri il menu (in alto a destra) → **Repository** e aggiungi `https://github.com/stefanodr/ha-addon-emule`, oppure usa il pulsante in cima a questa pagina.
3. Cerca **eMule** nella raccolta e premi **Installa**.
4. Avvia l'add-on e attiva **Mostra nella barra laterale**.
5. Apri **eMule** dalla barra laterale.

## Primo avvio

Al primo avvio viene creato l'ambiente Wine e possono servire un paio di minuti. Poi eMule si apre con le impostazioni predefinite: i download vanno in `/media/emule/Incoming`, i file temporanei in `/media/emule/Temp` e la connessione alla rete è automatica.

## Rete e porte

Per ottenere un ID alto (e velocità molto migliori) inoltra queste porte dal router verso la macchina di Home Assistant:

| Porta | Protocollo | Uso |
|-------|------------|-----|
| 4662 | TCP | connessioni client ed2k |
| 4672 | UDP | Kad e richieste estese |

Se cambi le porte dentro eMule, cambiale anche nella scheda **Rete** dell'add-on.

Il web server di eMule (porta 4711) è facoltativo. Abilitalo in eMule (Opzioni → Interfaccia Web), poi imposta una porta host per la 4711 nella scheda **Rete** dell'add-on.

## Configurazione

| Opzione | Predefinito | Descrizione |
|---------|-------------|-------------|
| `resolution` | `1600x900` | Dimensione del desktop virtuale |
| `download_path` | `/media/emule` | Cartella base dei download (al suo interno vengono create `Incoming` e `Temp`) |
| `install_vcredist` | `false` | Installa una volta il runtime Visual C++. Attivalo solo se eMule non si avvia |

## Dati e backup

- Impostazioni, crediti e coda dei download sono nella cartella dati dell'add-on e sono inclusi nei backup di Home Assistant.
- I download sono in `/media` (o `/share`) e **non** fanno parte del backup dell'add-on.

## Limitazioni

- Solo amd64.
- L'interfaccia è un desktop remoto nel browser, quindi non è pensata per gli schermi dei telefoni.
- Alcune integrazioni solo Windows (estensioni della shell, notifiche nella tray) non si applicano.

## Avviso legale

eMule è un programma legittimo, ma condividere materiale protetto da copyright senza autorizzazione è illegale nella maggior parte dei paesi. Sei responsabile di ciò che scarichi e condividi.

Questo progetto non è affiliato al progetto eMule né ai suoi sviluppatori. eMule Community è sviluppato su <https://github.com/irwir/eMule> ed è distribuito con licenza GNU GPL.
