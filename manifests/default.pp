define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly
   }
}

# Update APT Cache
class { 'apt':
  always_apt_update => true,
}

exec { 'apt-get update':
  before  => [ Class['logstash'] ],
  command => '/usr/bin/apt-get update -qq'
}

file { '/vagrant/elasticsearch':
  ensure => 'directory',
  group  => 'vagrant',
  owner  => 'vagrant',
}

# Java is required
class { 'java': }

exec { 'add es repo key':
    command => '/usr/bin/wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | /usr/bin/apt-key add -'
  }

# Elasticsearch
class { 'elasticsearch':
  manage_repo  => true,
  repo_version => '1.4',
  #package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.3.deb',
  require  => [Exec['apt-get update'], Exec['add es repo key'] ]
}

elasticsearch::instance { 'es-01':
  config => {
  'cluster.name' => 'vagrant_elasticsearch',
  'index.number_of_replicas' => '0',
  'index.number_of_shards'   => '1',
  'network.host' => '0.0.0.0'
  },        # Configuration hash
  init_defaults => { }, # Init defaults hash
}

elasticsearch::plugin{'royrusso/elasticsearch-HQ':
  module_dir => 'HQ',
  instances  => 'es-01'
}


# Logstash
class { 'logstash':
  # autoupgrade  => true,
  ensure       => 'present',
#  manage_repo  => true,
#  repo_version => '1.4',
  package_url => 'http://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.5.0.beta1-1_all.deb',
  require      => [ Class['java'], Class['elasticsearch'] ],
}

file { '/etc/logstash/conf.d/logstash':
  ensure  => '/vagrant/confs/logstash/logstash.conf',
  require => [ Class['logstash'] ],
}


# Kibana
package { 'curl':
  ensure  => 'present',
  require => [ Class['apt'] ],
}

file { '/vagrant/kibana':
  ensure => 'directory',
  group  => 'vagrant',
  owner  => 'vagrant',
}

exec { 'download_kibana':
  command => '/usr/bin/curl -L https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-rc1-linux-x64.tar.gz | /bin/tar xvz -C /vagrant/kibana',
  require => [ Package['curl'], File['/vagrant/kibana'] ]
}

exec {'start kibana':
  command => '/vagrant/kibana/kibana-4.0.0-rc1/bin/kibana',
  require => [ Exec['download_kibana']]
}

# needs python
class { 'python':}

python::pip { 'elasticsearchpython' :
  pkgname       => 'elasticsearch',
  require => [Class['python']],
  ensure => present
}


exec {'importpy':
  command  => '/usr/bin/python /vagrant/import.py',
  require => [ Class['elasticsearch'], Class['python']]
}
