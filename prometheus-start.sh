sudo cp /vagrant/prometheus/prometheus.yml /etc/prometheus/prometheus.yml
sudo cp /vagrant/prometheus/prometheus.rules /etc/prometheus/prometheus.rules

sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.rules

sudo service prometheus start
