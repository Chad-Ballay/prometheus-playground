cd /home/vagrant/client_golang/examples/random
nohup ./random -listen-address=:8080 &
nohup ./random -listen-address=:8081 &
nohup ./random -listen-address=:8082 &


cp /vagrant/prometheus.yml /home/vagrant/prometheus.yml
cp /vagrant/prometheus.rules /home/vagrant/prometheus.rules

cd /home/vagrant/prometheus-1.7.2.linux-amd64
nohup ./prometheus -config.file=/home/vagrant/prometheus.yml > prometheus.log 2>&1 &

sudo service grafana-server start
