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
  before  => [ Class['elasticsearch'], Class['logstash'] ],
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
  autoupgrade  => true,
  config       => {
    'cluster'  => {
      'name'   => 'vagrant_elasticsearch'
    },
    'index'    => {
      'number_of_replicas' => '0',
      'number_of_shards'   => '1',
    },
    'network'  => {
      'host'   => '0.0.0.0',
    }
  },
  ensure       => 'present',
  manage_repo  => true,
  repo_version => '1.3',
  require      => [ Class['apt'], Class['java'], File['/vagrant/elasticsearch'] ],
}

service { 'elasticsearch-service':
  ensure  => 'running',
  name    => 'elasticsearch',
  require => [ Class['elasticsearch'] ],
}

# Logstash
class { 'logstash':
  autoupgrade  => true,
  ensure       => 'present',
  manage_repo  => true,
  repo_version => '1.4',
  require      => [ Class['apt'], Class['elasticsearch'] ],
}

file { '/etc/logstash/conf.d/logstash':
  ensure  => '/vagrant/confs/logstash/logstash.conf',
  require => [ Class['logstash'] ],
}

package { 'nginx':
  ensure  => 'present',
  require => [ Class['apt'] ],
}

file { 'nginx-config':
  ensure  => 'link',
  path    => '/etc/nginx/sites-available/default',
  require => [ Package['nginx'] ],
  target  => '/vagrant/confs/nginx/default',
}

service { "nginx-service":
  ensure  => 'running',
  name    => 'nginx',
  require => [ Package['nginx'], File['nginx-config'] ],
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
