# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
# Install wget
sudo apt-get install -qy wget;

# Update puppet installation
#wget https://raw.githubusercontent.com/hashicorp/puppet-bootstrap/master/ubuntu.sh
sh /vagrant/ubuntu.sh

mkdir -p /etc/puppet/modules;
if [ ! -d /etc/puppet/modules/file_concat ]; then
puppet module install ispavailability/file_concat
fi
if [ ! -d /etc/puppet/modules/apt ]; then
puppet module install puppetlabs-apt --version 1.8.0
fi
if [ ! -d /etc/puppet/modules/java ]; then
puppet module install puppetlabs-java
fi
if [ ! -d /etc/puppet/modules/elasticsearch ]; then
puppet module install elasticsearch-elasticsearch
fi
if [ ! -d /etc/puppet/modules/logstash ]; then
puppet module install elasticsearch-logstash
fi
if [ ! -f /etc/init.d/kibana ]; then
sudo cp /vagrant/kibana4_init /etc/init.d/kibana
sudo sed -i 's/\r//' /etc/init.d/kibana
sudo chmod +x /etc/init.d/kibana
sudo update-rc.d kibana defaults
fi
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # set to false, if you do NOT want to check the correct VirtualBox Guest Additions version when booting this box
  if defined?(VagrantVbguest::Middleware)
    config.vbguest.auto_update = true
  end

  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.network :forwarded_port, guest: 5601, host: 5601
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 9300, host: 9300
  config.vm.network :forwarded_port, guest: 5959, host: 5959, protocol: "tcp"
  config.vm.network :forwarded_port, guest: 5959, host: 5959, protocol: "udp"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "2048"]
  end

  config.vm.provider "vmware_fusion" do |v, override|
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"] = "2048"
  end

  config.vm.provision "shell", inline: $script
  config.vm.provision "puppet", manifests_path: "manifests", manifest_file: "default.pp"
end
