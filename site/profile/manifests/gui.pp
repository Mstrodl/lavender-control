class profile::gui {
  package { 'emacs':
    ensure => latest,
  }
  vcsrepo { '/home/mary/.emacs.d':
    ensure => latest,
    provider => git,
    source => 'https://github.com/Mstrodl/.emacs.d.git',
  }
}
