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
    pacman::key { 'aur':
      keyid => '0x4338A0E98FE8718EA718126FD8A8A0C4D0CE4C1E',
      url => 'https://aur.coolmathgames.tech/key.gpg',
    } -> pacman::repo { 'aur':
      siglevel => 'Required',
      server => 'https://aur.coolmathgames.tech',
      order => '99',
    }

    pacman::repo { 'dkp-libs':
      server => 'https://downloads.devkitpro.org/packages',
      order => '99',
    }
    pacman::repo { 'dkp-linux':
      server => 'https://downloads.devkitpro.org/packages/linux/$arch',
      order => '99',
    }

    # Aur packages:
    package { 'saldl-git':
      ensure => latest,
      # require => Class['pacman::repo']['aur'],
    }
  }
}
