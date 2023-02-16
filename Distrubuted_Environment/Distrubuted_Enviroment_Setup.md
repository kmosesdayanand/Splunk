# Distrubuted Environment Setup

## Indexer Cluster

1. Install Splunk Enterprise Edition on 3 instances.
2. Do the following configuration in 1st instance(Cluster Master).
3. Edit **server.conf**.

```
	[general]
	serverName = cm
	pass4SymmKey = splunk1234
	
	[lmpool:auto_generated_pool_download-trial]
	description = auto_generated_pool_download-trial
	quota = MAX
	slaves = *
	stack_id = download-trial
	
	[lmpool:auto_generated_pool_forwarder]
	description = auto_generated_pool_forwarder
	quota = MAX
	slaves = *
	stack_id = forwarder
	
	[lmpool:auto_generated_pool_free]
	description = auto_generated_pool_free
	quota = MAX
	slaves = *
	stack_id = free
	
	[clustering]
	cluster_label = test
	mode = master
	replication_factor = 2

```

4. Save server.conf.
5. Restart Splunk.
6. Now SSH to 2nd instance.
7. Edit **inputs.conf**.

```
[splunktcp://9997]
connection_host = ip

```
8. Save inputs.conf.
9. Edit **server.conf**.

```
	[general]
	serverName = idx-1
	pass4SymmKey = splunk1234
	
	[lmpool:auto_generated_pool_download-trial]
	description = auto_generated_pool_download-trial
	quota = MAX
	slaves = *
	stack_id = download-trial
	
	[lmpool:auto_generated_pool_forwarder]
	description = auto_generated_pool_forwarder
	quota = MAX
	slaves = *
	stack_id = forwarder
	
	[lmpool:auto_generated_pool_free]
	description = auto_generated_pool_free
	quota = MAX
	slaves = *
	stack_id = free
	
	[replication_port://8080]
	
	[clustering]
	master_uri = https://<clustermaster_ip>:8089
	mode = slave
	
	[license]
	master_uri = https://<license_master_ip>:8089

```

10. Save  server.conf.
11. Do the same in the 3rd instance as you did for 2nd instance.

## Search Head Clustering

1. Install Splunk Enterprise Edition on 4 instances.
2. Perform the following configuration on 1st instance (Deployer).
3. Edit **server.conf**.

```
[general]
serverName = deployer
pass4SymmKey = splunk1234

[lmpool:auto_generated_pool_download-trial]
description = auto_generated_pool_download-trial
quota = MAX
slaves = *
stack_id = download-trial

[lmpool:auto_generated_pool_forwarder]
description = auto_generated_pool_forwarder
quota = MAX
slaves = *
stack_id = forwarder

[lmpool:auto_generated_pool_free]
description = auto_generated_pool_free
quota = MAX
slaves = *
stack_id = free


[shclustering]
pass4SymmKey = splunk1234
shcluster_label = shcluster1

```

4. Save the server.conf.
5. Restart Splunk.
6. Now move to 2nd instance(search head member).
7. Edit **collections.conf**.

```
	[SamlIdpCerts]
	disabled = false
	
	[SSLCertificates]
	disabled = false
	
	[JsonWebTokensV1]
	disabled = false
  
```

	
9. Save collections.conf.
10. Edit **server.conf**.

```

	[general]
	serverName = sh-1
	pass4SymmKey = splunk1234
	
	[lmpool:auto_generated_pool_download-trial]
	description = auto_generated_pool_download-trial
	quota = MAX
	slaves = *
	stack_id = download-trial
	
	[lmpool:auto_generated_pool_forwarder]
	description = auto_generated_pool_forwarder
	quota = MAX
	slaves = *
	stack_id = forwarder
	
	[lmpool:auto_generated_pool_free]
	description = auto_generated_pool_free
	quota = MAX
	slaves = *
	stack_id = free
	
	[replication_port://34567]
	
	[shclustering]
	conf_deploy_fetch_url = https://<deployer_ip>:8089
	disabled = 0
	mgmt_uri = https://<your_current_instance_ip> :8089
	 #the ip of the machine you are editing this on.
	pass4SymmKey = splunk1234
	shcluster_label = shcluster1
	id = <GUID of the Deployer>
	
	# This stanza is only when you are adding this search head cluster to indexer cluster.
	[clustering]
	manager_uri = https://<indexer_cluster_master>:8089   
	mode = searchhead

```

11. Save server.conf.
12. Do the same for 3rd and 4th machines as well.

## Deployment Server


1. Install Splunk Enterprise Edition on your machine.
2. Edit **serverclass.conf**.
	
```  

	[serverClass:uf_and_hf:app:Splunk_TA_nix]
	restartSplunkWeb = 0
	restartSplunkd = 0
	stateOnClient = enabled
	
	[serverClass:uf_and_hf]
	whitelist.0 = <ip_of_the_forwarder
	whitelist.1 = <ip_of_the_forwarder>

```

3. Save serverclass.conf.
4. Edit **server.conf**
	
```
 
	[general]
	serverName = deployment-server
	pass4SymmKey = splunk1234
	[lmpool:auto_generated_pool_download-trial]
	description = auto_generated_pool_download-trial
	quota = MAX
	slaves = *
	stack_id = download-trial
	
	[lmpool:auto_generated_pool_forwarder]
	description = auto_generated_pool_forwarder
	quota = MAX
	slaves = *
	stack_id = forwarder
	
	[lmpool:auto_generated_pool_free]
	description = auto_generated_pool_free
	quota = MAX
	slaves = *
	stack_id = free

```

5. Save server.conf and restart splunk.


