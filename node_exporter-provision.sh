export DEBIAN_FRONTEND=noninteractive

cd /tmp

# node_exporter user
useradd --no-create-home --shell /bin/false node_exporter

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
