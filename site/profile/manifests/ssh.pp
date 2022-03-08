class profile::ssh(
  Hash[String, Hash[String, String]] $keys,
) {
  $keys_new = {}
  $keys.each |$name, $key| {
    ['root', 'mary'].each |$username| {
      if User[$username] {
        $keys_new[$username + "_" + $name] = $key + {
          user => $username,
        }
      }
    }
  }
  class { 'ssh':
    keys => $keys_new,
  }
}
