# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.define "prometheus" do |vb|
    vb.vm.box = "debian/stretch64"
    vb.vm.hostname = "prometheus"
    vb.vm.network "private_network", ip: '192.168.50.5'
    vb.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
    end

    vb.vm.provision "shell", path: "prometheus-provision.sh"
    vb.vm.provision "shell", path: "prometheus-start.sh", run: "always", privileged: false
  end

  config.vm.define "server1" do |vb|
    vb.vm.box = "debian/stretch64"
    vb.vm.hostname = "server1"
    vb.vm.network "private_network", ip: '192.168.50.6'
    vb.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
    end

    vb.vm.provision "shell", path: "node_exporter-provision.sh"
  end
end
