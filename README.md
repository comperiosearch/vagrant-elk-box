This vagrant box installs elasticsearch 1.7, logstash 1.5.4 and kibana 4.1.1

## Prerequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) (minimum version 1.6)
Other providers, like VMWare may work, not tested!


## Up and SSH

To start the vagrant box run:

    vagrant up

To log in to the machine run:

    vagrant ssh

Elasticsearch will be available on the host machine at [http://localhost:9200/](http://localhost:9200/) 

Kibana at [http://localhost:5601/](http://localhost:5601/)

Marvel elasticsearch plugin at [http://localhost:9200/_plugin/marvel/](http://localhost:9200/_plugin/marvel/)

HQ elasticsearch plugin at [http://localhost:9200/_plugin/HQ/](http://localhost:9200/_plugin/HQ/)


## Vagrant commands


```
vagrant up # starts the machine
vagrant ssh # ssh to the machine
vagrant halt # shut down the machine
vagrant provision # applies the bash and puppet provisioning

```

##Elasticsearch
Installed via debian package, started on boot.
Controlled by

```bash

 sudo service elasticsearch-es-01

```


##Logstash
Installed via debian package, started on boot.
Controlled by

```bash

 sudo service logstash

```

If you want some sample Logstash data to play with, run

```bash

/opt/logstash/bin/logstash agent -f /vagrant/confs/logstash/logstash.conf

```
It will index into elasticsearch
reading from example log file at [/vagrant/example-logs/testlog](/example-logs/testlog)

##Kibana 
Manual install, start up script provided in this repo.
Controlled by

```bash

sudo service kibana

```

## Configuration details
Elasticsearch and Logstash are installed using puppet modules.  deb file for Kibana is downloaded and extracted, thanks to @UnrealQuester we even have init script for Kibana. 
Installation can be configured in the file [/manifests/default.pp](/manifests/default.pp) .For details on the elasticsearch puppet configuration, see [https://forge.puppetlabs.com/elasticsearch/elasticsearch](https://forge.puppetlabs.com/elasticsearch/elasticsearch) Logstash puppet at [https://forge.puppetlabs.com/elasticsearch/logstash](https://forge.puppetlabs.com/elasticsearch/logstash)

Elasticsearch is installed using cluster name 'vagrant_elasticsearch', instance name es-01, using 1 shard, 0 replicas. 


Read (a bit) more: http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/
