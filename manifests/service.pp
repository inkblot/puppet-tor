# ex: syntax=puppet si ts=4 sw=4 et

define tor::service (
    $real_port    = 'same',
    $real_address = '127.0.0.1',
    $virtual_port,
) {
    concat::fragment { "torrc-service-${name}":
        target  => '/etc/tor/torrc',
        content => template('tor/service.erb'),
        order   => "05-${name}-00",
    }
}
