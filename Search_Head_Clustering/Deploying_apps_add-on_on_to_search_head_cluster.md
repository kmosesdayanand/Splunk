# Deploying Apps or add-on on to Search Head Cluster.

<ul>

  <li>SSH to Deployer in the enironment and download the add-on on to the Deployer.</li>
  <li>Untar the file and move to /opt/splunk/etc/shcluster/apps, execute the following command.</li>
  
  ```
/opt/splunk/bin/splunk apply shcluster-bundle -target https://<any sh cluster member>:8089 -auth <username>:<password>
  
  ```
 </ul>
 
 ![image](https://user-images.githubusercontent.com/80450749/219419515-18181324-48ed-4f5d-a83c-f2f499c34df8.png)

<ul>  

  <li>You will receive a success message after bundle is pushed successfully.</li>
  <li>We can verify it by running the following command on any of the search head peers.</li>
  <b>/opt/splunk/bin/splunk show shcluster-status</b>
</ul>

![image](https://user-images.githubusercontent.com/80450749/219420110-14189fbe-daed-4b33-9d09-613beb141a54.png)


