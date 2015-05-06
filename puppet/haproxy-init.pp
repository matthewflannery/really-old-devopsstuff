node 'haproxy-server' {
  class { 'haproxy': }
  haproxy::listen { 'puppet00':
    ipaddress => $::ipaddress,
    ports     => '8140',
    global_options  => {
      'log'         => "{$::ipaddress} local0"
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '4000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats',
    }
     defaults_options => {
      'log'     => 'global',
      'stats'   => 'enable',
      'option'  => 'redispatch',
      'retries' => '3',
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'check 10s',
      ],
      'maxconn' => '8000', 
  }
}
# HAProxy server will automatically collect configurations from backend servers. 
# The backend nodes will export their HAProxy configurations to the puppet master which, 
# will then distribute them to the HAProxy server.

node /^master\d+/ { 
  @@haproxy::balancermember { $::fqdn:
    listening_service => 'puppet00',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8140',
    options           => 'check',
  }
}

  file { '/etc/logrotate.d/haproxy': ## Configure logrotate 
            ensure => present,
            source => "files/haproxy-logrotate",
            owner => root,
            group => root,
            mode => 644
            notify => Service['haproxy'], # haproxy will restart whenever you edit this file 
            require => Package['haproxy'],
      }

  file { '/etc/rsyslog.d/49-haproxy.conf': ## Configure system rsyslog
            ensure => present,
            source => "files/haproxy-rsyslog.conf",
            owner => root, group => root, mode => 644
            notify => Service['haproxy'], # haproxy will restart whenever you edit this file 
            require => Package['haproxy'],
      }

