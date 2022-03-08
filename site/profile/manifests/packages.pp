# Basic packages for development use

class profile::packages {
  package { 'neovim':
    ensure => latest,
  }
  package { 'vim':
    ensure => latest,
  }
  package { 'git':
    ensure => latest,
  }
  package { 'tmux':
    ensure => latest,
  }
  package { 'sudo':
    ensure => latest,
  }
  package { 'curl':
    ensure => latest,
  }
  if $::facts['os']['family'] == 'Archlinux' {
    class { 'pacman': }
    # AUR setup!
    pacman::key { 'aur.coolmathgames.tech':
      keyid  => '0x4338A0E98FE8718EA718126FD8A8A0C4D0CE4C1E',
      source => 'puppet:///files/aur.coolmathgames.tech.asc',
    }
    pacman::repo { 'aur.coolmathgames.tech':
      siglevel => 'required',
      server => 'https://aur.coolmathgames.tech',
      order => '99',
      requires => pacman::key['aur.coolmathgames.tech'],
    }

    # Aur packages:
    package { 'saldl-git':
      ensure => latest,
      requires => Class['pacman::repo', 'aur.coolmathgames.tech'],
    }
  }
}
