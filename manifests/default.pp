define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly
   }
}

# Add the repositories to APT
class { 'apt':
  always_apt_update => true,
}->
exec { 'apt-get update':
  command => '/usr/bin/apt-get update -qq'
}

apt_key { 'elasticsearch':
  ensure => 'present',
  id     => 'D88E42B4',
  source => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
}

apt::source { 'elasticsearch':
  comment     => 'Elasticsearch 1.3 repository',
  location    => 'http://packages.elasticsearch.org/elasticsearch/1.3/debian/',
  include_src => false,
  release     => 'stable',
  repos       => 'main',
}

apt::source { 'logstash':
  comment     => 'Logstash 1.4 repository',
  location    => 'http://packages.elasticsearch.org/logstash/1.4/debian',
  include_src => false,
  release     => 'stable',
  repos       => 'main',
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
  autoupgrade => true,
  config      => {
    'cluster' => {
      'name'  => 'vagrant_elasticsearch'
    },
    'index'   => {
      'number_of_replicas' => '0',
      'number_of_shards'   => '1',
    },
    'network' => {
      'host'  => '0.0.0.0',
    }
  },
  ensure      => 'present',
  require     => [ Class['apt'], Class['java'], File['/vagrant/elasticsearch'] ],
}

service { 'elasticsearch-service':
  ensure  => 'running',
  name    => 'elasticsearch',
  require => [ Class['elasticsearch'] ],
}

# Logstash
class { 'logstash':
  autoupgrade => true,
  ensure      => 'present',
  require     => [ Class['elasticsearch'] ],
}

file { '/etc/logstash/conf.d/logstash':
  ensure  => '/vagrant/confs/logstash/logstash.conf',
  require => [ Class['logstash'] ],
}

package { 'nginx':
  ensure  => 'present',
  require => [ Class['apt'] ],
}

file { '/etc/nginx/sites-available/default':
  ensure  => 'link',
  require => [ Package['nginx'] ],
  target  => '/vagrant/confs/nginx/default',
}

service { "nginx-service":
  ensure  => 'running',
  name    => 'nginx',
  require => [ Package['nginx'], File['/etc/nginx/sites-available/default'] ],
}->
exec { 'reload nginx':
  command => '/etc/init.d/nginx reload',
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
  command => '/usr/bin/curl https://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz | /bin/tar xz -C /vagrant/kibana',
  creates => '/vagrant/kibana/kibana-latest/config.js',
  require => [ Package['curl'], File['/vagrant/kibana'] ],
}
