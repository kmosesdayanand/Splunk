# App Bundle Push

## Scenario 1:

In this scenario we will push the bundle to peers from cluster master(indexer)

In order to push a bundle you need to create a bundle

A bundle can be any conf file you create in local directory or an app you want to install.

In my test case I am trying to push a app to peers which I installed in my indexer master

This app location is in **/opt/splunk/etc/apps/Splunk\_TA\_xxxxxx**

So in order to push the bundle we need to place the app in **/opt/splunk/etc/manager-apps/\_cluster/local**

So copy the file to the location and execute the following command

```
/opt/splunk/bin/splunk apply cluster-bundle --answer-yes
  
```

This command is used to push the bundle to the peers

You can also check the status of the bundle distribution using

```
/opt/splunk/bin/splunk show cluster-bundle-status

```

Note : the configuration that you apply on cluster master will be replicated on the peer nodes as well and you cannot change them.

In case of conf files it is highly recommended not to edit any file on search peers(slave indexes)

### Bundle Push

![image](https://user-images.githubusercontent.com/80450749/216530091-067091e5-3e37-4340-98d3-a98de3e3d531.png)

### Status Check

![image](https://user-images.githubusercontent.com/80450749/216530145-116930b1-f37f-4963-b70b-0d188cc672cf.png)

## Scenario 2

In this scenario we will turn of one of the peers and try to test whether the master is able to send the bundle to slave or not.

&#x20;

<figure><img src="https://user-images.githubusercontent.com/80450749/216530435-e8ed5351-38e7-4b46-b95a-15d86fa046c9.png" alt=""><figcaption></figcaption></figure>

In **figure 1** the cluster master sent heart beat signal to the idx-4 peer to check whether it is online or not then after certain period of time the cluster master disowned or decommissioned the indexer.

<figure><img src="https://user-images.githubusercontent.com/80450749/216531278-60a69d6f-eb5a-4d02-af97-a4e3635d820d.png" alt=""><figcaption></figcaption></figure>

&#x20;In **figure 2** the idx-4 has been added back after starting the machine and idx-4 has checked itself with other peers by using bundle checksum and found that it is using old bundle so, it downloaded the new bundle.

<figure><img src="https://user-images.githubusercontent.com/80450749/216530639-c297e382-b68d-431b-accd-aee2e3118a92.png" alt=""><figcaption></figcaption></figure>

&#x20;In **figure 3** you will see the bundle is successful. Similar message which you will see when idx-4 updates its bundle.
