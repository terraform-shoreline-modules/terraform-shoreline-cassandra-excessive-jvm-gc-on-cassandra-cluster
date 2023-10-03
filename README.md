
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Excessive JVM GC on Cassandra Cluster
---

This incident type refers to a problem where the Java Virtual Machine (JVM) running on a Cassandra cluster is experiencing an excessive amount of garbage collection (GC) events. GC is a process where the JVM frees up memory by removing objects that are no longer in use. Excessive GC can lead to performance degradation and even system crashes.

### Parameters
```shell
export PID="PLACEHOLDER"

export PATH_TO_CASSANDRA_LOG_FILE="PLACEHOLDER"

export PATH_TO_CASSANDRA_INSTALLATION_DIRECTORY="PLACEHOLDER"

export NEW_HEAP_SIZE_IN_GB="PLACEHOLDER"

export NEW_HEAP_SIZE="PLACEHOLDER"
```

## Debug

### Check if Cassandra is running
```shell
sudo service cassandra status
```

### Check Cassandra's logs for GC events
```shell
sudo tail -f /var/log/cassandra/system.log | grep GC
```

### Check the heap size and usage of the JVM
```shell
sudo jstat -gcutil ${PID}
```

### Check the overall CPU and memory usage of the server
```shell
top
```

### Check the disk usage and I/O operations of the server
```shell
iostat
```

### Check the network traffic of the server
```shell
iftop
```

### The Cassandra cluster may be running on hardware that does not meet the minimum requirements for the workload, resulting in insufficient memory resources and increased GC frequency.
```shell


#!/bin/bash



# Check the available memory on the system

total_memory=$(free -m | awk 'NR==2{print $2}')

used_memory=$(free -m | awk 'NR==2{print $3}')

free_memory=$(free -m | awk 'NR==2{print $4}')



echo "Total Memory: $total_memory MB"

echo "Used Memory: $used_memory MB"

echo "Free Memory: $free_memory MB"



# Check the Cassandra process memory usage

cassandra_pid=$(pgrep -f "org.apache.cassandra.service.CassandraDaemon")

cassandra_mem=$(pmap -x $cassandra_pid | tail -n 1 | awk '{print $3}')



echo "Cassandra Memory Usage: $cassandra_mem KB"



# Check the Cassandra system logs for any out-of-memory errors

log_file=${PATH_TO_CASSANDRA_LOG_FILE}

if grep -q "Out of memory" $log_file; then

  echo "Cassandra Out of Memory Error Detected!"

fi


```

## Repair

### Adjust JVM heap size: Increasing the heap size of the JVM running on the Cassandra cluster can help reduce the frequency of GC events. This can be done by configuring the JVM parameters.
```shell


#!/bin/bash



# Set the path to the Cassandra installation directory

CASSANDRA_HOME=${PATH_TO_CASSANDRA_INSTALLATION_DIRECTORY}



# Set the new heap size value (in GB)

NEW_HEAP_SIZE=${NEW_HEAP_SIZE_IN_GB}



# Set the path to the Cassandra configuration file

CASSANDRA_CONFIG_FILE=$CASSANDRA_HOME/conf/cassandra-env.sh



# Update the JVM heap size in the Cassandra configuration file

sed -i "s/-Xmx[0-9]*G/-Xmx${NEW_HEAP_SIZE}G/" $CASSANDRA_CONFIG_FILE



# Restart the Cassandra service to apply the new JVM heap size

sudo service cassandra restart


```