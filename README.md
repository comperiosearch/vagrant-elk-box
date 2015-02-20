This is a fork off the vagrant-elk-box with additional python installation, elasticsearch mappings and data import scripts for importing the vinmonopolet product catalog. It can be used to create the environment used for [this blog post](http://blog.comperiosearch.com/blog/2015/02/09/kibana-4-beer-analytics-engine/)
At the moment, no kibana configuration is exported, so you are completely free to toy around and fix it at your own will:)
Happy times :)

This vagrant box installs elasticsearch, logstash and kibana 4. (nginx is not needed with kibana 4) 


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



## Data import and elasticsearch setup

The import.py is a python script that downloads the product catalog from vinmonopolet.no, and puts it into an elasticsearch instance running at localhost:9200. index template for elasticsearch is defined in mapping.json


## Troubleshooting / operations
The import script fails now and then due to 404 from the server hosting the Vinmonopolet products. You can run it manually using the commands
(`vagrant ssh` first)

` /usr/bin/python /vagrant/import.py`


 If kibana for some reason should fail to start, start it manually using

` /vagrant/kibana/kibana-4.0.0-linux-x64/bin/kibana`



## The ELK box

Read (a bit) more: [http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/](http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/)
