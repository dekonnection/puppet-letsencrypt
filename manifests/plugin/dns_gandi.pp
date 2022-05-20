# @summary Installs and configures the dns-gandi plugin
#
class letsencrypt::plugin::dns_gandi (
  Optional[String[1]] $package_name = undef,
  Optional[String[1]] $api_key      = undef,
  Optional[String[1]] $sharing_id   = undef,
  Stdlib::Absolutepath $config_path = "${letsencrypt::config_dir}/dns-gandi.ini",
  Boolean $manage_package           = true,
  Integer $propagation_seconds      = 10,
) {
  require letsencrypt::install

  if ! $api_key {
    fail('No authentication method provided, please specify api_key.')
  }

  if $manage_package {
    if ! $package_name {
      fail('No package name provided for certbot dns gandi plugin.')
    }

    package { $package_name:
      ensure => installed,
    }
  }

  if $sharing_id {
    $ini_vars = {
      "certbot_plugin_gandi:dns_api_key"    => $api_key,
      "certbot_plugin_gandi:dns_sharing_id" => $sharing_id,
    }
  } else {
    $ini_vars = {
      "certbot_plugin_gandi:dns_api_key"    => $api_key,
    }
  }


  file { $config_path:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
        vars => { '' => $ini_vars },
    }),
  }
}
