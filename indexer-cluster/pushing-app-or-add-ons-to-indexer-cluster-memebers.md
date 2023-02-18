# Pushing App or Add-ons to Indexer Cluster Memebers

* SSH to Cluster Master in the environment and download the add-on on to the cluster master.
* Untar the add-on file into /opt/splunk/etc/master-apps/\_cluster/local directory.
* Navigate to /opt/splunk/bin and Execute the following command.
* ./splunk apply cluster-bundle --answer-yes.

![image](https://user-images.githubusercontent.com/80450749/219408682-27ecdd31-628e-4d67-b9e8-1421b0d7bfa3.png)

* **Note: You will see that the app has been pushed to all the peer nodes.**
* We can verify the same by executing the following command ./splunk show cluster-bundle-status
* You can also navigate to the /opt/splunk/etc/slave-apps/\_cluster/local and see the add-on.

![image](https://user-images.githubusercontent.com/80450749/219410288-e7c5fb7c-80f2-427c-9114-57b690230be1.png)
