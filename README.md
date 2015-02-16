This is a fork off the vagrant-elk-box with additional python installation, elasticsearch mappings and data import scripts for importing the vinmonopolet product catalog. It can be used to create the environment used for [this blog post](http://blog.comperiosearch.com/blog/2015/02/09/kibana-4-beer-analytics-engine/)
At the moment, no kibana configuration is exported, so you are completely free to toy around and fix it at your own will:)
Happy times :)


## Prequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) (minimum version 1.6)



## Up and SSH

To get started run:

    vagrant up
    vagrant ssh

## Vagrant commands


```
vagrant up # starts the machine
vagrant ssh # ssh to the machine
vagrant halt # shut down the machine
vagrant provision # applies the bash and puppet provisioning

```

## Data import and elasticsearch setup

The import.py is a python script that downloads the product catalog from vinmonopolet.no, and puts it into an elasticsearch instance running at localhost:9200. index template for elasticsearch is defined in mapping.json


## The ELK box

Read (a bit) more: [http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/](http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/)
