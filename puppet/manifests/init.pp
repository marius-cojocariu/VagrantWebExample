include apache

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}


class install_git {
  
	package { 
		'git-core':
 ensure => installed,
  
	}

}


class install_apache {
	exec { "restart-apache": 
		command => "/usr/sbin/service apache2 restart"
	}
	exec { 'enable-mod-rewrite': 
		command => '/usr/sbin/a2enmod rewrite'
	}
	exec {"apache-timeout-fix": 
		command => '/bin/echo "Timeout 7200" >> /etc/apache2/apache2.conf'
	}
	exec {"php-timeout-and-postmax-fix": 
		command => '/bin/echo "memory_limit = 512M" >> /etc/php5/apache2/php.ini && /bin/echo "max_execution_time = 7200" >> /etc/php5/apache2/php.ini && /bin/echo "post_max_size = 2GB" >> /etc/php5/apache2/php.ini && /bin/echo "upload_max_filesize = 2GB" >> /etc/php5/apache2/php.ini'
	}

	class additional_php_packages {
		package {
			'php5-xdebug': ensure => installed
		}
		package {
			'php5-suhosin': ensure => installed
		}
		package {
			'php5-sasl': ensure => installed
		}
		package {
			'php5-memcached': ensure => installed
		}
		package {
			'php5-memcache': ensure => installed
		}
		package {
			'php5-mcrypt': ensure => installed
		}
		package {
			'php5-intl': ensure => installed
		}
		package {
			'php5-imap': ensure => installed
		}
		package {
			'php5-geoip': ensure => installed
		}
		package {
			'php5-enchant': ensure => installed
		}
		package {
			'php5-xsl': ensure => installed
		}
		package {
			'php5-xmlrpc': ensure => installed
		}
		package {
			'php5-tidy': ensure => installed
		}
		package {
			'php5-sqlite': ensure => installed
		}
		package {
			'php5-snmp': ensure => installed
		}
		package {
			'php5-odbc': ensure => installed
		}
		package {
			'php5-mysql': ensure => installed
		}
		package {
			'php5-ldap': ensure => installed
		}
		package {
			'php5-gmp': ensure => installed
		}
		package {
			'php5-gd': ensure => installed
		}
		package {
			'php5-dev': ensure => installed
		}
		package {
			'php5-curl': ensure => installed
		}
		package {
			'php5-cli': ensure => installed
		}
	}

	class {'apache::mod::php': } -> class { 'additional_php_packages': } -> 
	class { 'install_phpmyadmin': } -> apache::vhost { "localhost":
		priority        => '10',
		port            => '80',
		docroot         => '/vagrant/', 
		override  => 'All'
	} -> apache::vhost { "phpmyadmin":
		priority        => '11',
		port            => '80',
		docroot         => '/var/www/phpmyadmin/', 
		template => 'vhost-phpmyadmin.conf.erb'
	} -> Exec["enable-mod-rewrite"] ->
	Exec["apache-timeout-fix"] -> Exec["php-timeout-and-postmax-fix"] -> 
	Exec["restart-apache"]
}

class install_mysql {
	class { 'mysql::server':
		config_hash => { 'root_password' => 'asd123' }
	} 
}

class install_phpmyadmin {
	exec { "download-stable-phpmyadmin": 
		command => '/usr/bin/wget --output-document=/var/www/STABLE.zip https://github.com/phpmyadmin/phpmyadmin/archive/STABLE.zip'
	}
	exec { "unpack-phpmyadmin": 
		command => '/usr/bin/unzip -qo /var/www/STABLE.zip -d /var/www && /bin/rm -Rf /var/www/phpmyadmin /var/www/STABLE.zip  && /bin/mv /var/www/phpmyadmin-STABLE /var/www/phpmyadmin'
	}
	exec { "populate-phpmyadmin-table":
		command => '/usr/bin/mysql phpmyadmin < /var/www/phpmyadmin/examples/create_tables.sql -u phpmyadmin --password=asd123'
	}
	exec { "default-config-file": 
		command => '/bin/cp /vagrant/puppet/resources/config.inc.php /var/www/phpmyadmin/config.inc.php && /bin/chmod 644 /var/www/phpmyadmin/config.inc.php'
	}

	package {
		'unzip': ensure => installed
	} -> package {
		'wget': ensure => installed
	} -> Exec["download-stable-phpmyadmin"] -> Exec["unpack-phpmyadmin"] -> mysql::db { 'phpmyadmin':
		user     => 'phpmyadmin',
		password => 'asd123',
		host     => 'localhost',
		grant    => ['all'],
	} -> Exec["populate-phpmyadmin-table"] -> Exec["default-config-file"]
}

Exec["apt-update"] -> class { 'install_mysql':
} -> class { 'install_apache': 
} -> class { 'install_git': 
} 







