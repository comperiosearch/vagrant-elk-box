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

# Elasticsearch
class { 'elasticsearch':
  manage_repo  => true,
  repo_version => '1.5',
}

elasticsearch::instance { 'es-01':
  config => {
  'cluster.name' => 'vagrant_elasticsearch',
  'index.number_of_replicas' => '0',
  'index.number_of_shards'   => '1',
  'network.host' => '0.0.0.0',
  'indices.memory.index_buffer_size' => '50%',
  'discovery.zen.ping.multicast.enabled' => 'false'
  },        # Configuration hash
  init_defaults => {
      'ES_HEAP_SIZE' => '2048000000'
  }, # Init defaults hash
  before => Exec['start kibana']
}

elasticsearch::plugin{'royrusso/elasticsearch-HQ':
  module_dir => 'HQ',
  instances  => 'es-01'
}

# Logstash
class { 'logstash':
  # autoupgrade  => true,
  ensure       => 'present',
  manage_repo  => true,
  repo_version => '1.4',
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
# needs python
class { 'python':}

python::pip { 'elasticsearchpython' :
  pkgname => 'elasticsearch',
  require => [Class['python']],
  ensure => present
}

python::pip { 'gmvault' :
  pkgname => 'gmvault',
  require => [Class['python']],
  ensure => present
}

python::pip { 'python-dateutil' :
  pkgname => 'python-dateutil',
  require => [Class['python']],
  ensure => present
}

python::pip { 'beautifulsoup4' :
  pkgname => 'beautifulsoup4',
  require => [Class['python']],
  ensure => present
}


python::pip { 'click' :
  pkgname => 'click',
  require => [Class['python']],
  ensure => present
}

vcsrepo { '/vagrant/gmail-madness':
  ensure => latest,
  provider => git,
  source => 'git://github.com/comperiosearch/gmail-madness.git',
  revision => 'master',
}

exec { 'download_kibana':
  command => '/usr/bin/curl -L https://download.elasticsearch.org/kibana/kibana/kibana-4.0.2-linux-x64.tar.gz | /bin/tar xvz -C /vagrant/kibana',
  require => [ Package['curl'], File['/vagrant/kibana'],Class['elasticsearch'] ],
  timeout     => 1800
}

exec {'start kibana':
  command => '/bin/sleep 10 && /vagrant/kibana/kibana-4.0.2-linux-x64/bin/kibana & ',
  require => [ Exec['download_kibana']]
}
