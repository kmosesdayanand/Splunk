# Indexer Clustering

\##There are three ways of doing Clustering.

* CLI Mode.
* .conf Mode.
* GUI Mode.

### CLI Mode

Execute the following on Master node.

```
./splunk edit cluster-config -mode master –replication_factor <number> -search factor <number> -secret <string> -cluster_label <string>

```

Execute the following on Peer Node.

```

splunk edit cluster-config -mode slave -master_uri https://<ip> : <mgmt._port>:<host name>:<mgmt_port>  replication_port <port> -secret <string> -cluster label <string>

```

### .conf Mode

#### Master Node ---- server.conf

```

[general]
serverName = cm-daya
pass4SymmKey = $7$I/8C3zpY3QUQu6VPtthuM9vUyU+FcKsPY/L8TAB5rm+pwU5H5ZgnAA==

[sslConfig]
sslPassword = $7$d89Lzn8swsAMQSAtgaWVdNGfEQQotJH48D4TSUEDHnvcMIwt6LWJ2A==

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
cluster_label = cluster1
mode = manager

```

#### Peer Node --- outputs.conf

```
[general]
serverName = idx-daya-2
pass4SymmKey = $7$XENHUAEVyViggLGGfR6LYA4qJpUtBFYNBXcbtfmUt3Tjt3vhQ4NAuQ==

[sslConfig]
sslPassword = $7$BGebc1aQ41zGYIcFBJP+bXxMocT4s53OuT+dJFY7SpniK+fyXVmA4Q==

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

[replication_port://8080]

[clustering]
master_uri = <cluster_master_ip>:8089
mode = peer

```

### GUI Mode

![1](https://user-images.githubusercontent.com/80450749/219063135-fa9b5198-6c04-407b-8692-65a6ed417ad4.png)

![image](https://user-images.githubusercontent.com/80450749/219062310-9bf0222a-8620-4005-bd7c-0d159e24f115.png)

![image](https://user-images.githubusercontent.com/80450749/219062382-1437179f-18b3-499c-8891-71611802dd8a.png)

![image](https://user-images.githubusercontent.com/80450749/219062433-e82bd606-071a-4361-b4f3-8dbe027aeac8.png)

![image](https://user-images.githubusercontent.com/80450749/219062515-0fc0ec83-b802-4ea2-8bc4-85a41f8ee8d7.png)
