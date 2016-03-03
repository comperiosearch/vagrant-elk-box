# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # set to false, if you do NOT want to check the correct VirtualBox Guest Additions version when booting this box
  if defined?(VagrantVbguest::Middleware)
    config.vbguest.auto_update = true
  end

  config.vm.box = "ubuntu/vivid64"
  config.vm.box_version = "20160203.0.0"
  config.vm.network :forwarded_port, guest: 5601, host: 5601
  config.vm.network :forwarded_port, guest: 5044, host: 5044
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 9300, host: 9300

  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "4", "--memory", "8192"]
  end

  config.vm.provider "vmware_fusion" do |v, override|
     ## the puppetlabs ubuntu 14-04 image might work on vmware, not tested?
    v.provision "shell", path: 'ubuntu.sh'
    v.box = "phusion/ubuntu-15.04-amd64"
    v.vmx["numvcpus"] = "4"
    v.vmx["memsize"] = "8192"
  end
  config.vm.provision "shell", path: 'setup.sh'
  config.vm.provision "puppet",  manifest_file: "default.pp"
end
