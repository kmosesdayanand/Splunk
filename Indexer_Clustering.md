# Indexer Clustering

##There are three ways of doing Clustering.

<ul>
  <li>CLI Mode.</li>
  <li>.conf Mode.</li>
  <li>GUI Mode.</li>
</ul>

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

Master Node ---- server.conf

```

[clustering]
mode = manager
cluster_label = 043BF050-32CF-4649-A70D-B0E79F4B8EE3

[indexer_discovery]
pass4SymmKey = $7$r/lE0vgDzH6qaj8oJYcOd4fFWKq7ajx7gmRRBGb/wvdw91JzZfnlp+0mG/XO
polling_rate = 10
indexerWeightByDiskCapacity = true![image](https://user-images.githubusercontent.com/80450749/219061552-6d6f08b3-7488-4501-88b0-a1fe1e2813d8.png)

```

Peer Node --- outputs.conf

```

[replication_port://8080]
[clustering]
master_uri = https://10.160.0.14:8089
mode = peer

```

### GUI Mode

![1](https://user-images.githubusercontent.com/80450749/219063135-fa9b5198-6c04-407b-8692-65a6ed417ad4.png)


![image](https://user-images.githubusercontent.com/80450749/219062310-9bf0222a-8620-4005-bd7c-0d159e24f115.png)


![image](https://user-images.githubusercontent.com/80450749/219062382-1437179f-18b3-499c-8891-71611802dd8a.png)


![image](https://user-images.githubusercontent.com/80450749/219062433-e82bd606-071a-4361-b4f3-8dbe027aeac8.png)


![image](https://user-images.githubusercontent.com/80450749/219062515-0fc0ec83-b802-4ea2-8bc4-85a41f8ee8d7.png)

