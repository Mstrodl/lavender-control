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
}
