class profile::development_tools(
  String $wakatime_config,
  String $eyaml_public_key,
) {
  package { 'emacs':
    ensure => latest,
  }
  package { 'gcc':
    ensure => latest,
  }
  package { 'cmake':
    ensure => latest,
  }
  if $::facts['os']['family'] == 'Archlinux' {
    package { 'jq-git':
      ensure => latest,
    }
  } else {
    package { 'jq':
      ensure => latest,
    }
  }
  package { 'man-db':
    ensure => latest,
  }
  class { 'nodejs':
    # This should be auto-updated
    repo_url_suffix => '17.x',
    nodejs_package_ensure => latest,
    nodejs_dev_package_ensure => latest,
    npm_package_ensure => latest,
  }

  if $::facts['os']['family'] == 'Archlinux' {
    package { 'wakatime-cli-bin':
      ensure => latest,
      # require => Class['pacman::repo']['aur'],
    }
    file { '/home/mary/.wakatime.cfg':
      ensure => present,
      content => Sensitive($wakatime_config),
    }
    package { 'rustup':
      ensure => latest,
    }
    package { 'prettier':
      ensure => latest,
    }
  }

  file { '/home/mary/.eyaml':
    ensure => directory,
    owner => 'mary',
  } -> file { '/home/mary/.eyaml/config.yaml':
    ensure => present,
    content => $eyaml_public_key,
    owner => 'mary',
  }

  file { '/home/mary/projects':
    ensure => directory,
    owner => 'mary',
  }
}
