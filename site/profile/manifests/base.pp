class profile::base {
  class { '::ntp': }

  class { 'puppet_agent': }
}
