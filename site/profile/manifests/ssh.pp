class profile::ssh(
  Hash[String, Hash[String, String]] $keys,
  Array[String] $users = ['root'],
) {
  $keys_new = $users.map |$username| {
    $keys.map |$key_name, $key| {
      {
        "${username}_${key_name}" => $key + {
          user => $username,
        },
      }
    }.reduce |$memo, $key| {
      if $memo =~ Hash {
        $memo + $key
      } else {
        $key
      }
    }
  }.reduce |$memo, $key| {
    if $memo =~ Hash {
      $memo + $key
    } else {
      $key
    }
  }

  class { 'ssh':
    keys => $keys_new,
  }
}
