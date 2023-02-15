# Indexer Discovery

![image](https://user-images.githubusercontent.com/80450749/216515499-aae143c2-a256-4dbe-99ac-776f41c9d92e.png)


  
1.Spin up all the instances as per the architecture diagram and enable clustering either by GUI mode or CLI mode.

2.Don’t add the 4th indexer to the cluster, we will be adding it after we configure the indexer discovery.

3.Now to enable index discovery you need to edit two conf files.

4.Server.conf file on cluster master node and outputs.conf file on forwarder.


### Below configuration is to be done in Cluster Master

```
## vi /opt/splunk/etc/system/local/server.conf --> Go to this location

#add the following lines under indexer discovery stanza --- clear if any configuration under the stanza

[indexer_discovery]
pass4SymmKey = $7$r/lE0vgDzH6qaj8oJYcOd4fFWKq7ajx7gmRRBGb/wvdw91JzZfnlp+0mG/XO
polling_rate = 10
indexerWeightByDiskCapacity = true
```

### Below configuration is to be done in Forwarders

```
## vi /opt/splunkforwarder/etc/system/local/outputs.conf --> Go to this location

#your outputs.conf file should only have this configuration so delete if any other configuration is present

[tcpout:idxc-forwarders]
indexerDiscovery = cluster1



[indexer_discovery:cluster1]
master_uri = https:// < Cluster master IP >:8089
pass4SymmKey = $7$Vy0GwfUBrM6xbwL201aFKHKhImbTwVkHeFNnnmerigPGo7L6J1t5yIQLM0CN




[tcpout]
defaultGroup = idxc-forwarders
autoLBFrequency = 10
```

Now add the 4th indexer to the cluster and search the internal logs of the UF on the SH for internal logs (index=_*)  you will be able to see all the internal logs of the machines in the cluster.

Also if you forwarded any data into the cluster it will be replicated in indexer 4 too.
