include apache

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> class {'apache::mod::php': 

} -> class { 'mysql::server':
	config_hash => { 'root_password' => '' }
}