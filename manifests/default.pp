# Update APT Cache
class { 'apt':
  always_apt_update => true,
}


# Java is required
class { 'java': }

# Elasticsearch
class { 'elasticsearch':
  manage_repo  => true,
  repo_version => '1.7',
}

elasticsearch::instance { 'es-01':
  config => { 
  'cluster.name' => 'vagrant_elasticsearch',
  'index.number_of_replicas' => '0',
  'index.number_of_shards'   => '1',
  'network.host' => '0.0.0.0',
  'marvel.agent.enabled' => false #DISABLE marvel data collection. 
  },        # Configuration hash
  init_defaults => { }, # Init defaults hash
  before => Exec['start kibana']
}

elasticsearch::plugin{'royrusso/elasticsearch-HQ':
  instances  => 'es-01'
}

elasticsearch::plugin{'elasticsearch/marvel/latest':
  instances  => 'es-01'
}

# Logstash
class { 'logstash':
  # autoupgrade  => true,
  ensure       => 'present',
  manage_repo  => true,
  repo_version => '1.5',
  require      => [ Class['java'], Class['elasticsearch'] ],
}

# remove initial logstash config
#file { '/etc/logstash/conf.d/logstash':
  #ensure  => '/vagrant/confs/logstash/logstash.conf',
 # require => [ Class['logstash'] ],
#}


# Kibana
package { 'curl':
  ensure  => 'present',
  require => [ Class['apt'] ],
}

file { '/opt/kibana':
  ensure => 'directory',
  group  => 'vagrant',
  owner  => 'vagrant',
}

exec { 'download_kibana':
  command => '/usr/bin/curl -L https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz | /bin/tar xvz -C /opt/kibana --strip-components 1',
  require => [ Package['curl'], File['/opt/kibana'], Class['elasticsearch'] ],
  timeout => 1800
}

exec {'start kibana':
    command => '/etc/init.d/kibana start',
}
