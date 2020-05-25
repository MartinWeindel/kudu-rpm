# kudu-rpm
Building & providing RPM binary packages for Apache Kudu on CentOS 7.

# Installation of Apache Kudu
## Download
The latest RPM package is available from the [release page](https://github.com/MartinWeindel/kudu-rpm/releases).

## Prerequisites
- CentOS 7
- NTP must be installed and configured, e.g.
```
yum install ntpd
systemctl start ntpd
systemctl enable ntpd
```

For development deployments you can alternatively disable the hybrid clock with adding the following
line to `/etc/kudu/conf/master.gflagfile` and `/etc/kudu/conf/tserver.gflagfile`
```
--use_hybrid_clock=false
```

### Installation of RPM package
```
yum install https://github.com/MartinWeindel/kudu-rpm/releases/download/v1.12.0-1/kudu-1.12.0-1.x86_64.rpm
```

### Updating from older version
```
yum erase kudu
yum install https://github.com/MartinWeindel/kudu-rpm/releases/download/v1.12.0-1/kudu-1.12.0-1.x86_64.rpm
```

### Running master server as service
- for multi master installations configure `--master_addresses` in `/etc/kudu/conf/master.gflagfile`
- more details see [Apache Kudu Configuration](http://kudu.apache.org/docs/configuration.html)
- starting the master server
```
systemctl start kudu-master
systemctl enable kudu-master
```

### Running tablet server as service
- if master runs on other machine(s), configure `tserver_master_addrs` in `/etc/kudu/conf/tserver.gflagfile`
- more details see [Apache Kudu Configuration](http://kudu.apache.org/docs/configuration.html)
- starting the tablet server
```
systemctl start kudu-tserver
systemctl enable kudu-tserver
```

# Building the RPM package
The build process uses the Apache Kudu binaries built with the docker image `mweindel/apache-kudu`
and creates a RPM package containing kudu client, kudu-master and kudu-tserver.

After checking out this project, just run
```
./extract-rpms.sh
```

## Updating to new version
- build docker image `mweindel/apache-kudu`
- adjust versions in `README.md`, `extract-rpms.sh`, `Dockerfile`, and `spec/header`
- commit and release

