export DEBIAN_FRONTEND=noninteractive

cd /home/vagrant

# standart
apt-get install -y vim git build-essential

# prometheus
wget --quiet https://github.com/prometheus/prometheus/releases/download/v1.7.2/prometheus-1.7.2.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz


# golang
wget --quiet https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.9.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/bin/go

# sample client
git clone https://github.com/prometheus/client_golang.git
cd client_golang/examples/random
go get -d
go build

# grafana
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.5.2_amd64.deb
apt-get install -y adduser libfontconfig
dpkg -i grafana_4.5.2_amd64.deb

chown -R vagrant:vagrant /home/vagrant

# cleaning
rm go1.9.linux-amd64.tar.gz prometheus-1.7.2.linux-amd64.tar.gz
