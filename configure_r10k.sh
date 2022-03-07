#!/bin/bash

puppet module install puppetlabs-inifile --version 5.2.0 --ignore-dependencies
puppet module install puppetlabs-vcsrepo --version 5.0.0 --ignore-dependencies
puppet module install choria-mcollective --version 0.14.1 --ignore-dependencies
puppet module install puppet-systemd --version 3.8.0 --ignore-dependencies
puppet module install puppet-r10k --version 10.1.1 --ignore-dependencies

puppet apply configure_r10k.pp
