
# Multi-Site Clustering

## CLI Mode

### Manager Node 

```
/opt/splunk/bin/splunk edit cluster-config -mode manager -multisite true -available_sites site1,site2 -site site1 -site_replication_factor origin:2,total:3 -site_search_factor origin:1,total:2
```

### Peer Nodes


```
/opt/splunk/bin/splunk edit cluster-config -mode peer -site site1 -manager_uri https://<cluster_master_ip>:8089 -replication_port 9887
```
```
/opt/splunk/bin/splunk edit cluster-config -mode peer -site site2 -manager_uri  https://<cluster_master_ip>:8089 -replication_port 9887 
```
### Search Heads

```
/opt/splunk/bin/splunk edit cluster-config -mode searchhead -site site1 -manager_uri https://<cluster_master_ip>:8089
```
```
/opt/splunk/bin/splunk edit cluster-config -mode searchhead -site site2 -manager_uri https://<cluster_master_ip>:8089
```
### Cluster Label
```
splunk edit cluster-config -cluster_label <CLUSTER LABEL>
```

## .conf files

### Cluster Master (server.conf)

```
[general]
serverName = s1-cm
pass4SymmKey = $7$lq2dF6G4CXwcQOZyHm2lVRm/+BC4MOMQEceVuTuqG7sE9nX2EGFxzg==
site = site1

[sslConfig]
sslPassword = $7$Q6tDQJnZqmKAMmcsZuUhUGuUpjT7YoMnT+tu2Hq0kYpV+PMPqInQlg==

[lmpool:auto_generated_pool_download-trial]
description = auto_generated_pool_download-trial
peers = *
quota = MAX
stack_id = download-trial

[lmpool:auto_generated_pool_forwarder]
description = auto_generated_pool_forwarder
peers = *
quota = MAX
stack_id = forwarder

[lmpool:auto_generated_pool_free]
description = auto_generated_pool_free
peers = *
quota = MAX
stack_id = free

[clustering]
available_sites = site1,site2
mode = manager
multisite = true
site_replication_factor = origin:2,total:3
site_search_factor = origin:1,total:2

[lmpool:auto_generated_pool_enterprise]
description = auto_generated_pool_enterprise
peers = *
quota = MAX
stack_id = enterprise

[license]
active_group = Enterprise
```
### Peer (server.conf)
```
[general]
serverName = s1-idx-1
pass4SymmKey = $7$Rnb29Px2eBx0SfvtW9tahzgsLTXeCLkEG2DBjohTCdwbkOzeA0PsRQ==
site = site1

[sslConfig]
sslPassword = $7$3rd1ml3V7gVWHhvlfrOeWWboR/zRXLyMQOnLHaclqZHHPIGEm88jGQ==

[lmpool:auto_generated_pool_download-trial]
description = auto_generated_pool_download-trial
peers = *
quota = MAX
stack_id = download-trial

[lmpool:auto_generated_pool_forwarder]
description = auto_generated_pool_forwarder
peers = *
quota = MAX
stack_id = forwarder

[lmpool:auto_generated_pool_free]
description = auto_generated_pool_free
peers = *
quota = MAX
stack_id = free

[replication_port://9887]

[clustering]
manager_uri = https://<cluster_master_ip>:8089
mode = peer

[license]
manager_uri = https://<license_master_ip>:8089
```
## Search Head (server.conf)
```
[general]
serverName = s1-sh
pass4SymmKey = $7$So3ayz3MmGgN3Us+VYbSHBqKtjdzSEUZYg8ITi6CTr2qUoB801tsAw==
site = site0

[sslConfig]
sslPassword = $7$YcqO8h9B6wKbmzXjQcs7wz+93tmwwQzaNK8au3/nASenfc7k+dmhSg==

[lmpool:auto_generated_pool_download-trial]
description = auto_generated_pool_download-trial
peers = *
quota = MAX
stack_id = download-trial

[lmpool:auto_generated_pool_forwarder]
description = auto_generated_pool_forwarder
peers = *
quota = MAX
stack_id = forwarder

[lmpool:auto_generated_pool_free]
description = auto_generated_pool_free
peers = *
quota = MAX
stack_id = free

[clustering]
manager_uri = https://<cluster_master_ip>:8089
mode = searchhead
multisite = true

[license]
active_group = Enterprise
manager_uri = https://<license_master_ip>:8089
```
## Monitoring Console
![image](https://github.com/kmosesdayanand/Splunk/assets/80450749/b54498f4-4966-4947-9bd1-d7d93a9c99df)



## Indexer Clustering console 
![image](https://github.com/kmosesdayanand/Splunk/assets/80450749/a0690ae4-6393-443a-98b1-a726082cc994)


