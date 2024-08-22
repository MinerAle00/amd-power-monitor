# Setup Power Consumption AMD CPU using Grafana & Prometeheus 

Questa repository fornisce una guida dettagliata per configurare il monitoraggio del consumo energetico delle CPU AMD utilizzando Grafana e Prometheus. La soluzione proposta consente di raccogliere, visualizzare e analizzare i dati sul consumo energetico delle CPU AMD in tempo reale, offrendo una panoramica completa delle prestazioni e dell’efficienza energetica del sistema.

**La repository non é ancora completa di tutti i passaggi, nei prossimi giorni verrá ultimata**

## Indice

- [Requisiti](#requisiti)
  - [Hardware Necessario](#hardware-necessario)
  - [Software Necessario](#software-necessario)
- [Istruzioni di Configurazione](#istruzioni-di-configurazione)
  - [Installazione di Grafana](#installazione-di-grafana)
  - [Configurazione di Grafana](#configurazione-di-grafana)
  - [Installazione di Prometheus](#installazione-di-prometheus)
  - [Configurazione di Prometheus](#configurazione-di-prometheus)
  - [Installazione di RAPL](#installazione-di-rapl)
- [Risorse Utili](#risorse-utili)

## Requisiti

### Hardware Necessario

- **PC** con **CPU AMD Ryzen** e Linux Installato.
- **Macchina Virtuale o Server Esterno** con una distro Ubuntu installata.

### Software Necessario

- **Prometheus**: Per la raccolta e la memorizzazione delle metriche.
- **Grafana**: Per la visualizzazione e l'analisi dei dati.
- **RAPL**: Per ottenere le metriche sul consumo energetico delle CPU AMD.

## Installazione Grafana

```
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana
```

## Configurazione di Grafana

```
sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server.service
```

## Installazione Prometheus

```
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.54.0/prometheus-2.54.0.linux-amd64.tar.gz Vedere release [qui](https://github.com/prometheus/prometheus/releases)
tar vxf prometheus*.tar.gz
cd prometheus*/
sudo mv prometheus /usr/local/bin
sudo mv promtool /usr/local/bin
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown -R prometheus:prometheus /var/lib/prometheus
```

## Configurazione di Prometheus

```
sudo nano /etc/systemd/system/prometheus.service
```
```
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```
```
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
```

## Installazione di RAPL
WIP

## Risorse Utili

- **Documentazione di Prometheus**: [Prometheus Documentation](https://prometheus.io/docs/)
- **Documentazione di Grafana**: [Grafana Documentation](https://grafana.com/docs/)
- **Forum di Supporto**: [Prometheus GitHub Discussions](https://github.com/prometheus/prometheus/discussions), [Grafana Community](https://community.grafana.com/)
- **AMD Energy**: [Rapl Github](https://github.com/amd/amd_energy)