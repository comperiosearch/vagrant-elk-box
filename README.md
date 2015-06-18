This vagrant box installs elasticsearch 1.6, logstash 1.5 and kibana 4. 

## Prequisites

[VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) (minimum version 1.6)
Other providers, like VMWare may work, not tested!


## Up and SSH

To get started run:

    vagrant up
    vagrant ssh

Note: the original `vagrant up` will also do a `provision`. If there are major failures on this then log in with `varant ssh` and then `apt-get update` and then `provision` again.

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

## Sample data

There are currently two sets of data:

* example logs (loaded via JSON)
* stock data (loaded via CSV)

## Configuration

Logstash is started on boot and indexes into elasticsearch using the config files locally held in `/vagrant/confs/logstash/` and mapped on box into `/etc/logstash/conf.d`.

The files are read from the `input` section of each `conf` file.

## Services on the box

### Logstash

Logstash is controlled by init script at 

```bash

 sudo service logstash 

```

### Kibana

Kibana is controlled by init script at 

```bash

sudo service kibana 

```
### Elastic Search

Elasticsearch is controlled by init script
````
sudo service elasticsearch-es-01
````

## Testing new data

If you have a new config or data and want to invoke it, reload it using the `--config` (`-f`) option.

```bash
vagrant ssh
sudo /opt/logstash/bin/logstash --config /etc/logstash/conf.d/
```

## Testing your config script

If you are developing a new config then it is useful to test the script first using the `--configtest` (`-t`) option.

```bash
vagrant ssh
sudo /opt/logstash/bin/logstash --configtest /etc/logstash/conf.d/
```

## Configuration details
Elasticsearch and Logstash are installed using puppet modules.  deb file for Kibana is downloaded and extracted, thanks to @UnrealQuester we even have init script for Kibana. 
Installation can be configured in the file [/manifests/default.pp](/manifests/default.pp) .For details on the elasticsearch puppet configuration, see [https://forge.puppetlabs.com/elasticsearch/elasticsearch](https://forge.puppetlabs.com/elasticsearch/elasticsearch) Logstash puppet at [https://forge.puppetlabs.com/elasticsearch/logstash](https://forge.puppetlabs.com/elasticsearch/logstash)

Elasticsearch is installed using cluster name 'vagrant_elasticsearch', instance name es-01, using 1 shard, 0 replicas. 

Read (a bit) more: http://blog.comperiosearch.com/blog/2014/08/14/elk-one-vagrant-box/

## Using Kibana

### Visualising stocks

The stock data and visualisation is from (here)[http://blog.webkid.io/visualize-datasets-with-elk/]. The (original dataset for stocks is here)[https://gist.github.com/chrtze/51fa6bb4025ba9c7c2b3]. The images below are from the site too.

  1. Open (Kibana)[http://localhost:5601]
  2. Visualisation
  3. Add from new search

### Linechart: highest value of stock for each day

* Y Axis: Max, High
* X axis: Date Histogram, Date, Daily

!()[http://blog.webkid.io/content/images/2015/04/linechart.gif]

### Barchart: volume of stock

* Type: Vertical Barchart
* Y Axis: Max, Volume
* X axis: Date Histogram, Date, Daily

!()[http://blog.webkid.io/content/images/2015/04/barchart.gif]

### Metric: the basics

* Metric 1: Count
* Metric 2: Max, High
* Metric 3: Average, High

!()[http://blog.webkid.io/content/images/2015/04/metric.gif]

### Dasboard

Combine the graphs in a dashboard

!()[http://blog.webkid.io/content/images/2015/04/dashboard-1.gif]

Be able to play with them and change dates and zooming

!()[http://blog.webkid.io/content/images/2015/04/dashboard-2.gif]


