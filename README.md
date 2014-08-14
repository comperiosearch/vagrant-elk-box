This vagrant box installs elasticsearch, logstash and kibana. In addition, it installs nginx and configures it to serve kibana on port 5601 (you can access it from your host machine by going to http://localhost:5601/)

## Prequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/)



## Up and SSH

To get started run:

    vagrant up
    vagrant ssh

**NOTE**: there is an issue with the current Vagrant version, so you might get the following error when you do vagrant up:

```
Failed to mount folders in Linux guest. This is usually because                                   
the "vboxsf" file system is not available. Please verify that                                     
the guest additions are properly installed in the guest and                                       
can work properly. The command attempted was:
mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` vagrant /vagrant  
mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` vagrant /vagrant
```


**Check out this link to fix the error:** https://github.com/mitchellh/vagrant/issues/3341#issuecomment-39015570


After fixing the error do:

      vagrant provision

and you are ready to go.


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
