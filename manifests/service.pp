class etcd::service (
  
) {
  $docker_path = $etcd::docker_path
  $registry = $etcd::registry
  $version = $etcd::version

  # The `etcd::peers` list can be passed either as a list of IPs or as a list of hostnames.
  # We compute the index of the current node to use it in the configuartions.
  # There's one `fqdn` per host, but there could be multiple IPs so we need to rely
  # on the network interface being set to do this
  $ip = inline_template("<%= scope.lookupvar('::ipaddress_${$etcd::nic}') -%>")
  $idx_ip = inline_template("<%= scope.lookupvar('etcd::peers').sort.index('$ip') -%>")
  $idx_fqdn = inline_template("<%= scope.lookupvar('etcd::peers').sort.index('$::fqdn') -%>")

  if is_integer($idx_ip) {
    $idx = $idx_ip
    $address = $ip
  } elsif is_integer($idx_fqdn) {
    $idx = $idx_fqdn 
    $address = $::fqdn
  }

  if !is_integer($idx) {
    fail("Can't find etcd::nic : \"${etcd::nic} : ${ip}\" or fqdn \"$::fqdn\" in peers \"${etcd::peers}\". Please read documentation.")
  }
  notify {"${address} - ${idx} in ${peers}":}

  file { '/etc/systemd/system/etcd.service':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('etcd/etcd.service.erb'),
  } ->   
  exec { 'reload-etcd_docker-service':
    command => 'systemctl daemon-reload'
  } ->
  service { 'etcd':
    ensure  => $etcd::service_ensure,
    enable  => $etcd::service_enable
  }
 
} 
