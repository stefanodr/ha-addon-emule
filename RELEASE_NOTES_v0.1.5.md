## eMule add-on v0.1.5

### Changed
- eMule and its `wineserver` now run at low priority (`nice 10`). When the host is busy, other services (for example cameras or automations) get the CPU first.

### Note
- Idle CPU usage is unchanged. Measurements show it is a fixed cost of eMule running under Wine (it stays the same with eMule disconnected and with the interface closed), not a problem of the network or the interface.

---

## Add-on eMule v0.1.5

### Modifiche
- eMule e il suo `wineserver` ora girano a priorità bassa (`nice 10`). Quando l'host è carico, gli altri servizi (per esempio telecamere o automazioni) hanno la precedenza sulla CPU.

### Nota
- Il consumo di CPU a riposo non cambia. Le misure mostrano che è un costo fisso di eMule sotto Wine (resta uguale con eMule disconnesso e con l'interfaccia chiusa), non un problema della rete o dell'interfaccia.
