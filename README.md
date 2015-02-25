This vagrant box installs elasticsearch, logstash and kibana 4. (nginx is not necessary with kibana 4) 

## Prequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) (minimum version 1.6)



## Up and SSH

To get started run:

    vagrant up
    vagrant ssh

Elasticsearch will be available on the host machine at [http://localhost:9200/](http://localhost:9200/), Kibana at [http://localhost:5601/](http://localhost:5601/)


## Vagrant commands


```
vagrant up # starts the machine
vagrant ssh # ssh to the machine
vagrant halt # shut down the machine
vagrant provision # applies the bash and puppet provisioning

```

To run Logstash manually.
Use the following command to use an example logstash config and feed example log file located at example-logs/testlog



```bash

 /opt/logstash/bin/logstash agent -f /vagrant/confs/logstash/logstash.conf

```


If kibana for some reason should fail to start, start it manually using

```bash

/vagrant/kibana/kibana-4.0.0-linux-x64/bin/kibana

```

Read (a bit) more: http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/
