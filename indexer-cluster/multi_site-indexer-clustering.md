
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

## Monitoring Console
![image](https://github.com/kmosesdayanand/Splunk/assets/80450749/b54498f4-4966-4947-9bd1-d7d93a9c99df)



## Indexer Clustering console 
![image](https://github.com/kmosesdayanand/Splunk/assets/80450749/a0690ae4-6393-443a-98b1-a726082cc994)


