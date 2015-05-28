Etcd
====

This project is part of Adobe HSTACK project group.

##Source:
* https://git.corp.adobe.com/metal-cell/puppet-etcd

## JIRA project
* https://jira.corp.adobe.com/browse/HSTACK
* Component: [**puppet-etcd**](https://jira.corp.adobe.com/browse/HSTACK/component/24915)

## Contributing Guide
Check [Contributors Guide](http://saasbase.corp.adobe.com/guides/saasbase_contributors.html)


## Table of Contents

  * [etcd](#etcd)
        * [Table of Contents](#table-of-contents)
    * [Overview](#overview)
    * [Module Description](#module-description)
    * [Setup](#setup)
      * [What etcd affects](#what-etcd-affects)
      * [Setup Requirements](#setup-requirements)
      * [Beginning with etcd](#beginning-with-etcd)
    * [Usage](#usage)
    * [Reference](#reference)
    * [Limitations](#limitations)
    * [Development](#development)
    * [Contributing](#contributing)


## Overview

A minimal docker-based Etcd 2.x puppet module.

## Module Description

This module is solely based on Docker and only deploys a service unit file.

## Setup

### What etcd affects

* It currently works only on systemd enabled operating systems
* Writes direcly (and only to) `/etc/systemd/system/etcd.service`

### Setup Requirements 

* Requires Docker to be installed on the host system

### Beginning with etcd

* Configure the peer list

## Usage

If using [saasbase-deployment](https://git.corp.adobe.com/saasbase/saasbase-deployment) 
manifests:

```
etcd::version: v2.0.3
etcd::registry: "quay.io/coreos/etcd"
etcd::nic: eth0
etcd::peers: ["%{ipaddress_eth0}"]
```

## Reference

* Uses [systemd-docker](https://github.com/ibuildthecloud/systemd-docker)
  to work around some of the systemd - docker limitations

## Limitations

Only systemd based systems are currenly supported. 

Due to `systemd`, `systemd-docker` and `docker` indirections improper
configuration may lead to weird states where the docker container isn't
running but systemd sees the service as running.

Note that on CentOS 7 `cpu,cpuacct` and `cpuacct,cpu` cgroups are 
inconsistent and, hence systemd-docker needs to be run with 
`--cgroups name=systemd` in order to work properly. I couldn't find
the upstream bug, and didn't have time to investigate. It's likely a bug in
CentOS as it seems to be working properly on other systems.

See 

* https://github.com/ibuildthecloud/systemd-docker/issues/15
* https://github.com/docker/docker/issues/9365


## Development

This is an Adobe Open Development project.
https://git.corp.adobe.com/metal-cell/puppet-etcd

## Contributing

This project complies to the SaasBase Contribution guide.
Read more here http://saasbase.corp.adobe.com/guides/saasbase_contributors.html
