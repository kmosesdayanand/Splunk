
# Multi-Site Clustering
sudo su

cd /opt

yum install wget -y && wget -O splunk-9.0.4.1-419ad9369127-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.0.4.1/linux/splunk-9.0.4.1-419ad9369127-Linux-x86_64.tgz"

tar -xvzf splunk-9.0.4.1-419ad9369127-Linux-x86_64.tgz

/opt/splunk/bin/splunk enable boot-start

/opt/splunk/bin/splunk start

/opt/splunk/bin/splunk restart

Manager Node 

/opt/splunk/bin/splunk edit cluster-config -mode manager -multisite true -available_sites site1,site2 -site site1 -site_replication_factor origin:2,total:3 -site_search_factor origin:1,total:2

Peer Nodes

/opt/splunk/bin/splunk edit cluster-config -mode peer -site site1 -manager_uri https://10.158.0.2:8089 -replication_port 9887

/opt/splunk/bin/splunk edit cluster-config -mode peer -site site2 -manager_uri  https://10.158.0.2:8089 -replication_port 9887 

Search Heads

/opt/splunk/bin/splunk edit cluster-config -mode searchhead -site site1 -manager_uri https://10.158.0.2:8089

/opt/splunk/bin/splunk edit cluster-config -mode searchhead -site site2 -manager_uri https://10.158.0.2:8089
