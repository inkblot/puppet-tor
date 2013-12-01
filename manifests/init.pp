class tor (
	$entry              = true,
	$socksport          = '9050',
	$sockslistenaddress = '127.0.0.1',
	$sockspolicies      = [ {
			policy => 'accept',
			target => '192.168.0.0/16',
		}, {
			policy => 'reject',
			target => '*',
		} ],
) {

	package { 'tor':
		ensure => installed,
	}

	file { '/etc/tor/torrc':
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		content => template('tor/torrc.erb'),
		require => Package['tor'],
		notify  => Service['tor'],
	}

	service { 'tor':
		ensure => running,
	}

}
