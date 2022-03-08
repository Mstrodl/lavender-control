class profile::user(
  String $password
) {
  user { 'mary':
    ensure => present,
    comment => 'Mary Strodl',
    managehome => true,
    membership => minimum,
    groups => [
      'wheel', 'uucp', 'audio', 'plugdev', 'libvirt',
      'docker', 'wireshark', 'bumblebee',
    ],
    # Thanks Mirabito :)
    password => Sensitive(pw_hash($password, 'sha-512', fqdn_rand_string(16))),
  }
}
