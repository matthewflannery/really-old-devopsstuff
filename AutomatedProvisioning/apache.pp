class { 'apache':
  default_mods        => true,
  default_confd_files => true,
}

apache::vhost { 'first.example.com':
  port    => '80',
  docroot => '/var/www/first',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
}

apache::vhost { 'second.example.com':
  port          => '80',
  docroot       => '/var/www/second',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
}

file { '/var/www/first/index.html':
        ensure => file,
        content => "<html>Hello from server 1</html>",
}

file { '/var/www/second/index.html':
        ensure => file,
        content => "<html>Hello from server 2</html>",
}