class profile::ssh(
  Hash[String, Hash[String, String]] $keys,
) {
  $keys_new = ['root', 'mary'].reduce |$memo, $username| {
    $keyset = $keys.reduce |$memo, $entry| {
      if User[$username] {
        $key_name = $entry[0]
        $key = $entry[1]
        $key_subset = {
          "${username}_${key_name}" => $key + {
            user => $username,
          },
        }
        if $memo =~ Hash {
          $memo + $key_subset
        } else {
          $key_subset
        }
      } elsif $memo {
        $memo
      } else {
        {}
      }
    }
    if $memo =~ Hash {
      $memo + $keyset
    } else {
      $keyset
    }
  }
  class { 'ssh':
    keys => $keys_new,
  }
}
