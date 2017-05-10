# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "private_network", ip: "192.168.33.11"


  config.vm.provider "virtualbox" do |v|
    v.name = "Elk-Stack"
    v.memory = 4096
    v.cpus = 2
  end

  config.vm.provision :shell, :path => "startup.sh", :run => 'always', :privileged => false

  config.vm.provision :docker
  config.vm.provision :docker_compose, yml: "/vagrant/docker-compose.yml", run: "always"
end
