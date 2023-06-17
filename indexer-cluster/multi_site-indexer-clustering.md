
# Multi-Site Clustering

## Manager Node 

```
/opt/splunk/bin/splunk edit cluster-config -mode manager -multisite true -available_sites site1,site2 -site site1 -site_replication_factor origin:2,total:3 -site_search_factor origin:1,total:2
```

## Peer Nodes


```
/opt/splunk/bin/splunk edit cluster-config -mode peer -site site1 -manager_uri https://<cluster_master_ip>:8089 -replication_port 9887
```
```
/opt/splunk/bin/splunk edit cluster-config -mode peer -site site2 -manager_uri  https://<cluster_master_ip>:8089 -replication_port 9887 
```
## Search Heads

```
/opt/splunk/bin/splunk edit cluster-config -mode searchhead -site site1 -manager_uri https://<cluster_master_ip>:8089
```
```
/opt/splunk/bin/splunk edit cluster-config -mode searchhead -site site2 -manager_uri https://<cluster_master_ip>:8089
```
## Cluster Label
```
splunk edit cluster-config -cluster_label <CLUSTER LABEL>
```
