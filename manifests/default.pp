define append_if_no_such_line($file, $line, $refreshonly = 'false') {
   exec { "/bin/echo '$line' >> '$file'":
      unless      => "/bin/grep -Fxqe '$line' '$file'",
      path        => "/bin",
      refreshonly => $refreshonly
   }
}


class el {
  include apt
  include stdlib

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  } ->
  file { '/vagrant/elasticsearch':
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
  } ->
  class { 'elasticsearch':
    java_install => true,
    package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.1.deb',
    config => {
      'cluster' => { 
        'name' => 'vagrant_elasticsearch'
      },
      'index' => {
        'number_of_replicas' => '0',
        'number_of_shards' => '1',
      },
      'network' => {
        'host' => '0.0.0.0',
      }
    }
  } ->
  service { "elasticsearch-service":
    name => 'elasticsearch',
    ensure => running
  } ->
  exec { 'add logstash repo key':
    command => '/usr/bin/wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | /usr/bin/apt-key add -'
  } ->
  exec { 'add logstash repo':
    command => '/bin/echo "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main" >> /etc/apt/sources.list'
  } ->
  exec { 'apt-get update 1':
    command => '/usr/bin/apt-get update'
  } ->
  class { 'logstash':
  } ->
  file { "/etc/logstash/conf.d/logstash":
    ensure => "/vagrant/confs/logstash/logstash.conf",
  }
}

class kibana {
  include apt
  include stdlib
  
  package { "nginx":
    ensure => installed
  } ->
  file { "/etc/nginx/sites-available/default":
    ensure => link,
    target => "/vagrant/confs/nginx/default"
  } ->
  service { "nginx-ruuing":
    name => 'nginx',
    ensure => running
  } ->
  exec { 'reload nginx':
    command => '/etc/init.d/nginx reload'
  }
  
  package { "curl":
    ensure => installed
  } ->
  file { '/vagrant/kibana':
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
  } ->
  exec { 'download kibana':
    command => '/usr/bin/curl https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz | /bin/tar xvz -C /vagrant/kibana'
  }
}

include el
include kibana

Class['el'] -> Class['kibana']
