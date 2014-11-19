# ex: syntax=puppet si ts=4 sw=4 et

class tor (
    $socks                      = true,
    $socksport                  = '9050',
    $sockslistenaddresses       = '127.0.0.1',
    $sockspolicies              = [
        {
            policy => 'accept',
            target => '192.168.0.0/16',
        },
        {
            policy => 'reject',
            target => '*',
        }
    ],
    $dirservers                 = [],
    $usebridges                 = false,
    $updatebridgesfromauthority = true,
    $bridges                    = [],
    $relay                      = true,
    $orport                     = '9001',
    $orlistenaddress            = '0.0.0.0:9001',
    $nickname                   = 'ididnteditheconfig',
    $address                    = false,
    $bridge                     = false,
    $publishserverdescriptor    = true,
    $directory                  = false,
    $dirport                    = '9000',
    $dirlistenaddress           = '0.0.0.0:9000',
    $transport                  = false,
    $translistenaddress         = '127.0.0.1',
    $dnsport                    = false,
    $dnslistenaddress           = '127.0.0.1',
    $identity_key_source        = false,
    $user,
    $group,
    $tor_service,
    $tor_package,
    $repo_class,
) {

    if $repo_class {
        class { $repo_class:
            before => Package['tor'],
        }
    }

    package { 'tor':
        name   => $tor_package,
        ensure => latest,
    }

    if $identity_key_source {
        # A 1024-bit PEM format RSA private key
        file { '/var/lib/tor/keys/secret_id_key':
            ensure => present,
            owner  => $user,
            group  => $group,
            mode   => '0600',
            source => $identity_key_source,
        }
    }

    concat { '/etc/tor/torrc':
        owner   => 'root',
        group   => 'root',
        require => Package['tor'],
        notify  => Service['tor'],
    }

    concat::fragment { 'torrc-main':
        target  => '/etc/tor/torrc',
        content => template('tor/torrc.erb'),
        order   => '00',
    }

    service { 'tor':
        name   => $tor_service,
        ensure => running,
    }

}
