class profile::gui {
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
  package { 'oneko':
    ensure => latest,
  }
  package { 'plasma-desktop':
    ensure => latest,
  }
  package { 'plasma-browser-integration':
    ensure => latest,
  }
  # Thanks work
  package { 'networkmanager-openconnect':
    ensure => latest,
  }
  package { 'kdenlive':
    ensure => latest,
  }
  package { 'kdeconnect':
    ensure => latest,
  }
  package { 'calibre':
    ensure => latest,
  }
  package { 'okular':
    ensure => latest,
  }
  package { 'xournalpp':
    ensure => latest,
  }
}
