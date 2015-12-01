# == Class: etcd
#
# Minimal recipe that uses a docker registry to deploy and run etcd.
# Only systemd based systems are currently supported.
#
# === Parameters
#
# [*version*]
#   The container version (e.g. `v2.0.3`)
# [*registry*]
#   The docker registry uri or path (e.g. `quay.io/coreos/etcd`)
# [*nic*]
#   The network interface on which the service should bind on.
#   Either the IP address of this interface or the equivalent fqdn
#   needs to be present in the peers list.
#   NOTE: make sure this matches the IP you want to use with Etcd.
# [*peers*]
#   The list of etcd peers (ips or fqdn) in this cluster.
#   This list will be sorted and the IP/fqdn  corresponding to *nic*
#   will be used to determine the peer index.
#   E.g. `[10.0.0.1, 10.0.0.2, 10.0.0.3]`
# [*docker_path*]
#   The path ot the docker binary on the host.
# [*service_enable*]
#   Whether this service should be enabled
# [*service_ensure*]
#   The desired service state (e.g. `running`)
#
#
# === Examples
#
#  class { 'etcd':
#    version => 'v2.0.3',
#  }
#
# === Authors
#
# Cosmin Lehene <clehene@adobe.com>
#
# === Copyright
#
# Copyright 2015 Cosmin Lehene
#
class etcd (
  $version,
  $registry              = "quay.io/coreos/etcd",
  $nic                   = hiera("nic", "lo"),
  $peers                 = [$::ipaddress_lo],
  $docker_path           = "/bin/docker",
  $service_enable        = "true",
  $service_ensure        = "running",
){
  include docker
  Class['etcd'] <- Class['docker']
  anchor { 'etcd::begin': } ->
  class { '::etcd::service': } ->
  anchor { 'etcd::end': }
}
