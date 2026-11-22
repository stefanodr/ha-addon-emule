# Add-on aMule per Home Assistant

Il client nativo Linux **aMule** per le reti eD2K e Kad, con la sua interfaccia web nella barra laterale di Home Assistant. Funziona senza Wine e senza schermo virtuale, quindi richiede molte meno risorse dell'[add-on eMule](../README.it.md), che esegue il vero eMule per Windows.

Vedi [DOCS.md](DOCS.md) per installazione, opzioni e primo avvio. English: [README.md](README.md).

## aMule o eMule?

Misure sullo stesso mini PC (Home Assistant OS, download su SSD USB):

| | Add-on eMule (Wine) | Add-on aMule |
|---|---|---|
| CPU a riposo | 5.7-6.3% | **0.4%** |
| RAM a riposo | 2.0-2.1% | **0.5%** |
| CPU durante il download di un film | 26.8% | **1.9%** |
| RAM durante il download di un film | 5.7% | **3%** |
| Interfaccia | la vera finestra di eMule | interfaccia web più semplice |
| Opzioni avanzate di eMule Community | tutte | alcune mancano |

Scegli **aMule** per un downloader sempre acceso. Scegli **eMule** se vuoi esattamente il programma Windows, con tutte le sue opzioni.

- Entrambi gli add-on usano le stesse porte (TCP 4662, UDP 4672): eseguine uno solo alla volta.
- Le due identità e i due crediti sono separati: non vengono condivisi.
- Cartelle: aMule usa `/media/amule` di default, eMule `/media/emule`.
