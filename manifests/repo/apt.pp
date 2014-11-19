# ex: syntax=puppet si ts=4 sw=4 et

class tor::repo::apt {
    apt::source { 'torproject':
        location          => 'http://deb.torproject.org/torproject.org',
        release           => $::lsbdistcodename,
        repos             => 'main',
        required_packages => 'deb.torproject.org-keyring',
        key               => '886DDD89',
        key_server        => 'keys.gnupg.net',
    }
}
