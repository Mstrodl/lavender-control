class profile::gui {
  vcsrepo { '/home/mary/.emacs.d':
    ensure => latest,
    provider => git,
    source => 'https://github.com/Mstrodl/.emacs.d.git',
  }
  package { 'alacritty':
    ensure => latest,
  }
  package { 'chromium':
    ensure => latest,
  }
  package { 'thunderbird':
    ensure => latest,
  }
  package { 'signal-desktop':
    ensure => latest,
  }
  package { 'inkscape':
    ensure => latest,
  }
  package { 'gimp':
    ensure => latest,
  }
}
