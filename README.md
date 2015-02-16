This vagrant box installs elasticsearch, logstash and kibana 4. (nginx is not necessary with kibana 4) 

## Prequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) (minimum version 1.6)



## Up and SSH

To get started run:

    vagrant up
    vagrant ssh

Elasticsearch will be available on the host machine at [http://localhost:9200/](http://localhost:9200/), Kibana at [http://localhost:5601/](http://localhost:5601/)

**NOTE**: there is an issue with the current Vagrant version, so you might get the following error when you do vagrant up:

```
Failed to mount folders in Linux guest. This is usually because                                   
the "vboxsf" file system is not available. Please verify that                                     
the guest additions are properly installed in the guest and                                       
can work properly. The command attempted was:
mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` vagrant /vagrant  
mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` vagrant /vagrant
```

To fix this error, do in the guest machine (VM logged):
```
    $ sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
```


Exit the VM and do:

      vagrant reload

and you are ready to go.

Read more about this error: https://github.com/mitchellh/vagrant/issues/3341#issuecomment-39015570

## Vagrant commands


```
vagrant up # starts the machine
vagrant ssh # ssh to the machine
vagrant halt # shut down the machine
vagrant provision # applies the bash and puppet provisioning

```

To run Logstash manually


```bash

/opt/logstash/bin/logstash agent -f /path/to/your.config
```


Read (a bit) more: http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/
