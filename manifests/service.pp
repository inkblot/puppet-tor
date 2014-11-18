# ex: syntax=puppet si ts=4 sw=4 et

define tor::service (
    $private_key_source = false,
    $real_port          = 'same',
    $real_address       = '127.0.0.1',
    $virtual_port,
) {
    concat::fragment { "torrc-service-${name}":
        target  => '/etc/tor/torrc',
        content => template('tor/service.erb'),
        order   => "05-${name}-00",
    }

    File {
        ensure => present,
        owner  => $::tor::user,
        group  => $::tor::group,
        before => Service['tor'],
    }

    file { "/var/lib/tor/${name}":
        ensure => directory,
        mode   => '2700',
    }

    if $private_key_source {
        file { "/var/lib/tor/${name}/private_key":
            ensure => present,
            mode   => '0600',
            source => $private_key_source,
        }
    }
}
