class profile::user(
  String $password
) {
  # Hack:
  group { 'libvirt': }
  group { 'docker': }
  group { 'plugdev': }
  group { 'wireshark': }
  group { 'bumblebee': }

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
