# Null Queue

### props.conf

```
[rsa:securid:syslog] #sourcetype
TRANSFORMS-RSA-nullqueue = syslog-nullqueue, syslog-indexqueue

# syslog-nullqueue and syslog-indexqueue are the custom filters we created for the sourcetype.
```

### transforms.conf

```
[syslog-nullqueue] # To send the logs to nullqueue
REGEX =  . # all the logs will be sent to nullqueue
DEST_KEY = queue
FORMAT  = nullQueue

[syslog-indexqueue] # To index data
REGEX = audit.admin.com.rsa #  all the logs which contain audit.admin.com.rsa  will be sent to index
DEST_KEY = queue
FORMAT  = indexQueue
```
