# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "prometheus" do |vb|
    vb.vm.box = "debian/stretch64"
    vb.vm.hostname = "prometheus"
    vb.vm.network "private_network", ip: '192.168.50.5'
    vb.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "2048"
    end

    vb.vm.provision "shell", path: "provision.sh"
    vb.vm.provision "shell", path: "start.sh", run: "always", privileged: false
  end

  # config.vm.define "server1" do |vb|
  #   vb.vm.box = "debian/stretch64"
  #   vb.vm.hostname = "server1"
  #   vb.vm.network "private_network", ip: '192.168.50.6'
  #   vb.vm.provider "virtualbox" do |vb|
  #     vb.gui = false
  #     vb.memory = "512"
  #   end
  # end
  #
  # config.vm.define "server2" do |vb|
  #   vb.vm.box = "debian/stretch64"
  #   vb.vm.hostname = "server2"
  #   vb.vm.network "private_network", ip: '192.168.50.7'
  #   vb.vm.provider "virtualbox" do |vb|
  #     vb.gui = false
  #     vb.memory = "512"
  #   end
  # end
end
