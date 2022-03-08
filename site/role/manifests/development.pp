class role::development {
  include role::server
  include profile::user
  include profile::development_tools
}
