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

10. Save server.conf.
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

## License Master

### Install a license for a distributed deployment

1. Install a license
2. If you install a Dev/Test license over an Enterprise license, it replaces the Enterprise license.
3. Install a license for a distributed deployment
4. To install a license for a distributed deployment of Splunk Enterprise:
5. Choose an instance to function as the license manager, if you have not already done so. See Configure a license manager.
6. On the license manager, navigate to Settings > Licensing.
7. Click Add license.
8. Do one of the following:
   1. Click Choose file and browse for your license file and select it, or
   2. Click copy & paste the license XML directly... and paste the text of your license file into the provided field.
9. Click Install.
10. If this is the first Enterprise license that you are installing on the license manager, you must restart Splunk Enterprise.

#### Configuration for License Peers

11. Now Go to **License Peer**.
12. Log into Splunk Web and navigate to Settings > Licensing.
13. Click Change to Peer.
14. Switch the radio button from Designate this Splunk instance as the license server to Designate a different Splunk instance as the license server.
15. Specify the license manager. You must provide an IP address or a hostname, and include the management port. The default management port is 8089.
16. Click Save. Restart Splunk Enterprise services.

### Install a license for a standalone instance

To install a license for a standalone instance of Splunk Enterprise:

1. On the instance, navigate to Settings > Licensing.
2. Click Add license.
3. Do one of the following:
   1. Click Choose file and browse for your license file and select it, or
   2. Click copy & paste the license XML directly... and paste the text of your license file into the provided field.
4. Click Install.
5. If this is the first Enterprise license that you are installing on the instance, you must restart Splunk Enterprise. Add a note to a license file. Once an Enterprise license is installed, you can add a note or other text to your license file:
6. Navigate to Settings > Licensing.
7. Under Licenses, click Notes.
8. In the Notes field, add a note or other text.
9. Click Save.

> The Notes field is only available for licenses installed in an Enterprise license group.

![image](https://user-images.githubusercontent.com/80450749/219441080-82997a07-1e41-4321-b402-32f082bd2199.png)

![image](https://user-images.githubusercontent.com/80450749/219441116-9f429a3f-deca-41b0-89c1-c6c90617e101.png)

![image](https://user-images.githubusercontent.com/80450749/219441161-ece81de4-3a0c-4321-8b0f-87f361f2be8b.png)
