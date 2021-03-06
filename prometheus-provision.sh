export DEBIAN_FRONTEND=noninteractive

# prometheus & node_exporter user
useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false node_exporter

cd /tmp

# standart
echo "Standart packages installing..."
apt-get install -y vim git build-essential curl apt-transport-https > /dev/null 2>&1

# prometheus
echo "Prometheus installing..."
echo "a5d56b613b77e1d12e99ed5f77359d097c63cb6db64e8b04496eff186df11484 prometheus-1.7.2.linux-amd64.tar.gz" > prometheus-1.7.2.linux-amd64.tar.gz.sha256
wget --quiet https://github.com/prometheus/prometheus/releases/download/v1.7.2/prometheus-1.7.2.linux-amd64.tar.gz

CHECKSUM_STATE=$(echo -n "$(sha256sum -c prometheus-1.7.2.linux-amd64.tar.gz.sha256)" | tail -c 2)
if [ "$CHECKSUM_STATE" != "OK"  ]
then
	echo "Warning! Checksum does not match!"
	exit 1
else
	tar xvfz prometheus-1.7.2.linux-amd64.tar.gz > /dev/null 2>&1
fi

# copy binary prometheus files
cp prometheus-1.7.2.linux-amd64/prometheus /usr/local/bin/
cp prometheus-1.7.2.linux-amd64/promtool /usr/local/bin/

chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

# alertmanager
echo "Alertmanager installing..."
echo "407e0311689207b385fb1252f36d3c3119ae9a315e3eba205aaa69d576434ed7 alertmanager-0.9.1.linux-amd64.tar.gz" > alertmanager-0.9.1.linux-amd64.tar.gz.sha256
wget --quiet https://github.com/prometheus/alertmanager/releases/download/v0.9.1/alertmanager-0.9.1.linux-amd64.tar.gz

CHECKSUM_STATE=$(echo -n "$(sha256sum -c alertmanager-0.9.1.linux-amd64.tar.gz.sha256)" | tail -c 2)
if [ "$CHECKSUM_STATE" != "OK"  ]
then
	echo "Warning! Checksum does not match!"
	exit 1
else
	tar xvfz alertmanager-0.9.1.linux-amd64.tar.gz > /dev/null 2>&1
fi

# copy binary prometheus files
cp alertmanager-0.9.1.linux-amd64/alertmanager /usr/local/bin/
cp alertmanager-0.9.1.linux-amd64.tar.gz/amtool /usr/local/bin/

chown prometheus:prometheus /usr/local/bin/alertmanager
chown prometheus:prometheus /usr/local/bin/amtool

mkdir /etc/prometheus
mkdir /var/lib/prometheus
mkdir /var/lib/prometheus/alertmanager

chown -R prometheus:prometheus /var/lib/prometheus

cp /vagrant/prometheus/* /etc/prometheus/

chown -R prometheus:prometheus /etc/prometheus/

cp /vagrant/systemd/prometheus.service /etc/systemd/system/prometheus.service
cp /vagrant/systemd/alertmanager.service /etc/systemd/system/alertmanager.service
systemctl daemon-reload

# node_exporter
echo "node_exporter installing..."
echo "d5980bf5d0dc7214741b65d3771f08e6f8311c86531ae21c6ffec1d643549b2e node_exporter-0.14.0.linux-amd64.tar.gz" > node_exporter-0.14.0.linux-amd64.tar.gz.sha256
wget --quiet https://github.com/prometheus/node_exporter/releases/download/v0.14.0/node_exporter-0.14.0.linux-amd64.tar.gz

CHECKSUM_STATE=$(echo -n "$(sha256sum -c node_exporter-0.14.0.linux-amd64.tar.gz.sha256)" | tail -c 2)
if [ "$CHECKSUM_STATE" != "OK"  ]
then
    echo "Warning! Checksum does not match!"
    exit 1
else
    tar xvfz node_exporter-0.14.0.linux-amd64.tar.gz > /dev/null 2>&1
fi

cp node_exporter-0.14.0.linux-amd64/node_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/node_exporter

cp /vagrant/systemd/node_exporter.service /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter > /dev/null 2>&1

# securing
apt-get install -y nginx apache2-utils > /dev/null 2>&1
cp /vagrant/nginx/htpasswd /etc/nginx/.htpasswd
cp /vagrant/nginx/prometheus /etc/nginx/sites-available/

rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/prometheus /etc/nginx/sites-enabled/
systemctl reload nginx

# grafana
echo "Grafana installing..."
echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" > /etc/apt/sources.list.d/grafana.list
curl -s https://packagecloud.io/gpg.key | sudo apt-key add - > /dev/null 2>&1
apt-get update -qq
apt-get install -y grafana > /dev/null 2>&1
systemctl start grafana-server
systemctl enable grafana-server > /dev/null 2>&1

# just in case
sleep 3

# add data source
curl -X POST -H "Content-Type: application/json" -d '{
  "name": "Prometheus",
  "type": "prometheus",
  "url": "http://192.168.50.5:9090",
  "access": "direct",
  "basicAuth": false
}' http://admin:admin@localhost:3000/api/datasources

# add examples dashboards
curl -X POST -H "Content-Type: application/json" -d \
	@/vagrant/grafana/host-stats_rev1.json \
	http://admin:admin@localhost:3000/api/dashboards/db

curl -X POST -H "Content-Type: application/json" -d \
	@/vagrant/grafana/node-exporter-full_rev7.json \
	http://admin:admin@localhost:3000/api/dashboards/db

curl -X POST -H "Content-Type: application/json" -d \
	@/vagrant/grafana/node-exporter-single-server_rev7.json \
	http://admin:admin@localhost:3000/api/dashboards/db
