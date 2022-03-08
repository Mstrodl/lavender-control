class profile::development_tools(
  String $wakatime_config
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
  }

  file { '/home/mary/.eyaml/config.yaml':
    ensure => present,
    source => "puppet:///modules/public_key.pkcs7.pem",
  }
}
