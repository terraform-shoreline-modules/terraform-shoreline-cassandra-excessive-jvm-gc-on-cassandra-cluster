

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