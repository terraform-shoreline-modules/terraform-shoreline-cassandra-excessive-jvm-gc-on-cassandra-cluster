

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