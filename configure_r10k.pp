# This puppet script will set up r10k and create a webhook at 0.0.0.0:8088

# Define stages
stage { 'install': }

class configure_r10k::install {
  class {'r10k::webhook::config':
    use_mcollective => false,
	  enable_ssl      => false,
	  protected       => false,
  }

  # Now we can use http://${::fqdn}:8088/payload
  class {'r10k::webhook':
    use_mcollective => false,
    user            => 'root',
    group           => '0',
    require         => Class['r10k::webhook::config'],
  }

  class { 'r10k':
    remote => 'https://github.com/mstrodl/lavender-control.git',
  }
}

# Assign classes to stages and run
class { 'configure_r10k::install':
  stage  => 'install',
}
