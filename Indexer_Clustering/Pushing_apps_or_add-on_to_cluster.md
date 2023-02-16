# Pushing App or Add-ons to Indexer Cluster Memebers

<ul>
  <li>SSH to Cluster Master in the environment and download the add-on on to the cluster master.</li>
  <li>Untar the add-on file into <b>/opt/splunk/etc/master-apps/_cluster/local</b> directory.</li>
  <li>Navigate to <b>/opt/splunk/bin</b> and Execute the following command.</li>
  <b>./splunk apply cluster-bundle --answer-yes</b>.
</ul>

![image](https://user-images.githubusercontent.com/80450749/219408682-27ecdd31-628e-4d67-b9e8-1421b0d7bfa3.png)

<ul>
  
####  Note: You will see that the app has been pushed to all the peer nodes.
  
  <li>We can verify the same by executing the following command
    <b>./splunk show cluster-bundle-status</b></li>
  <li>You can also navigate to the /opt/splunk/etc/slave-apps/_cluster/local and see the add-on.</li>
</ul>

![image](https://user-images.githubusercontent.com/80450749/219410288-e7c5fb7c-80f2-427c-9114-57b690230be1.png)

