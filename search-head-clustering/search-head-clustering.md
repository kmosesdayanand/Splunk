# Search Head Clustering

#### In order to setup Search Head Clustering we need a Deployer(Splunk Enterprise Instance) and two or more Search Heads(Splunk Enterprise Instnaces).

1. Install Splunk Enterprise Editionon your instance.
2. Enable Splunk to start on boot. This is optional instruction./opt/splunk/bin/splunk enable boot-start.
3. Start Splunk /opt/splunk/bin/splunk start.
4. Before settingup SH cluster enable https.
5. Settings --> server setting --> General settings
6. Restart the splunk.
7. In the Deployer
8. vi /opt/splunk/etc/system/local/server.conf
9. ```
   		[shclustering]
   		pass4SymmKey = password
   		shcluster_label = shcluster1
   ```
10. In the Search Head Peer Node

```
    ./splunk init shcluster-config -auth <username>:<password> -mgmt_uri <URI of your search head member>:<management_port> -replication_port <replication_port> -replication_factor <n> -conf_deploy_fetch_url <URL deployer>:<management_port> -secret <security_key> -shcluster_label <label>
 
```

Example:

```diff
+ In sh1
./splunk init shcluster-config -auth admin:splunk1234 -mgmt_uri https://10.128.0.16:8089 -replication_port 34567 -replication_factor 3 -conf_deploy_fetch_url https://10.128.0.17:8089 -secret shcluster -shcluster_label shcluster1
+ In sh2
./splunk init shcluster-config -auth admin:splunk1234 -mgmt_uri https://10.166.0.2:8089 -replication_port 34567 -replication_factor 3 -conf_deploy_fetch_url https://10.128.0.17:8089 -secret shcluster -shcluster_label shcluster1
+ In sh3
./splunk init shcluster-config -auth admin:splunk1234 -mgmt_uri https://10.202.0.2:8089 -replication_port 34567 -replication_factor 3 -conf_deploy_fetch_url https://10.128.0.17:8089 -secret shcluster -shcluster_label shcluster1

```

## When you execute the following commands the backend files looks like this

In the backend, you will find the following configuration in each search node system/local server.conf

```

[ replication_port:/ /34567]


[shclustering]
conf_deploy_fetch url = https:// <shc_master_ip>:<mgmt_port>
disabled = 0
mgmt _ uri = https:// <SH_ip>:<mgmt_port>
pass4SymmKey = <secret key>
shcluster label =shcluster1

```

### To select the Capitan for the Search Heads

Run below the command on every search head peer node you want to include in the Cluster.

```
./splunk bootstrap shcluster-captain -servers_list "<URI of search head node>:<management_port>,<URI of search head node>:<management_port>,..." -auth <username>:<password>
 
```

```diff
+ Example format for three search head peers:

  ./splunk bootstrap shcluster-captain -servers_list "https:// :8089,https:// :8089,https://:8089 " -auth admin:password
```

### To check search head cluster status

On search head peers execute the following.

```

./splunk show shcluster-status -auth <username>:<password>
 
```

### To connect sh cluster with stand-alone indexer

In the search head settings --> distributed search --> add search peer--->add indexer management port, user name and password.

### To add Indexer Cluster to Search Head Cluster

Run on each search head.

```
./splunk edit cluster-config -mode searchhead -manager_uri https:// <Indexer Cluster Master ip>:8089  -auth  <username>:<password>
```

```diff
+ Example:
./splunk edit cluster-config -mode searchhead -manager_uri https://10.128.0.15:8089  -auth admin:splunk1234
```

## Cluster Label
```
splunk edit shcluster-config -shcluster_label <CLUSTER LABEL>
```

Reference: https://docs.splunk.com/Documentation/Splunk/9.0.2/DistSearch/Connectclustersearchheadstosearchpeers

Reference: https://docs.splunk.com/Documentation/Splunk/9.0.2/DistSearch/SHCdeploymentoverview
