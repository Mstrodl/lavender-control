class profile::base($manage_ntp = true) {
  if $manage_ntp {
    class { '::ntp': }
  }

  # Arch manages puppet in the repos
  if $::facts['os']['family'] == "Archlinux" {
    package { 'puppet':
      ensure => latest,
    }
    service { 'puppet':
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
    }
  } else {
    class { 'puppet_agent':
      package_version => 'auto',
      collection => 'puppet6',
      manage_repo => true,
    }
  }
}
