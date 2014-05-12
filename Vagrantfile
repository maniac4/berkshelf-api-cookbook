# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "berkshelf-api"
  config.vm.box      = "CentOS-6.3-x86_64-minimal"
  config.vm.box_url  = "http://vagrant.peakcasual.net/CentOS-6.3-x86_64-minimal.box"

  config.vm.network :private_network, ip: "20.20.20.20"
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.provision :chef_solo do |chef|
    chef.roles_path = "roles"
    chef.add_role("berkshelf-api")
  end
end
