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
	java_install => true,
	manage_repo  => true,
	repo_version => '1.4',
}

elasticsearch::instance { 'es-01':
  config => { 
	'cluster.name' => 'vagrant_elasticsearch',
	'index.number_of_replicas' => '0',
	'index.number_of_shards'   => '1',
	'network.host' => '0.0.0.0',
	'http.cors.enabled' => 'true',
	'http.cors.allow-origin' => 'http://localhost:5601'
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
  manage_repo  => true,
  repo_version => '1.4',
  require      => [ Class['java'], Class['elasticsearch'] ],
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
  command => '/usr/bin/curl https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz | /bin/tar xz -C /vagrant/kibana',
  creates => '/vagrant/kibana/kibana-latest/config.js',
  require => [ Package['curl'], File['/vagrant/kibana'] ],
}
