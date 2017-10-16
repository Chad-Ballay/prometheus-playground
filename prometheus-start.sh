sudo cp /vagrant/prometheus/* /etc/prometheus/

sudo chown -R prometheus:prometheus /etc/prometheus

sudo service prometheus start
sudo service alertmanager start
