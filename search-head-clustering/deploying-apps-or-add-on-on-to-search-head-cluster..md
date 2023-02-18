# Deploying Apps or add-on on to Search Head Cluster.

* SSH to Deployer in the enironment and download the add-on on to the Deployer.
* Untar the file and move to /opt/splunk/etc/shcluster/apps, execute the following command.
* ```
  /opt/splunk/bin/splunk apply shcluster-bundle -target https://<any sh cluster member>:8089 -auth <username>:<password>

  ```

![image](https://user-images.githubusercontent.com/80450749/219419515-18181324-48ed-4f5d-a83c-f2f499c34df8.png)

* You will receive a success message after bundle is pushed successfully.
* We can verify it by running the following command on any of the search head peers.
* /opt/splunk/bin/splunk show shcluster-status

![image](https://user-images.githubusercontent.com/80450749/219420110-14189fbe-daed-4b33-9d09-613beb141a54.png)
