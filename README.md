This vagrant box installs elasticsearch 1.5, logstash 1.5 and kibana 4. 

## Prequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) (minimum version 1.6)
Other providers, like VMWare may work, not tested!


## Up and SSH

To get started run:

    vagrant up
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

Logstash is started on boot and indexes into elasticsearch using the config file at /vagrant/confs/logstash/logstash.conf,
reading from example log file at /vagrant/example-logs/testlog
Controlled by 

```bash

 sudo /etc/init.d/logstash status

```


Kibana is controlled by init script at 

```bash

sudo /etc/init.d/kibana status

```

Read (a bit) more: http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/
