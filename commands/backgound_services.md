# Background services

**Table of content:**

[list the background services and their status](#list-the-background-services-and-their-status)    
[Connect to the EdgeLake Network](#connect-to-the-edgelake-network)  
[The local data storage service](#the-local-data-storage-service)  


## list the background services and their status

**Usage**:
<pre>
    <code>
get processes
    </code>
</pre>

**Explanation**: List the background processes and their status.

**Details:** [The "get processes" command](https://github.com/AnyLog-co/documentation/blob/master/monitoring%20nodes.md#the-get-processes-command)


## Connect to the EdgeLake Network

Connecting to an EdgeLake Network requires 2 services:
1. [run tcp server](#run-tcp-server) - A listener service for incoming messages.
2. [run blockchain sync](#run-blockchain-sync) - A service that continuously synchronizes the metadata.

Monitoring the services' status:
1. [get connections](#get-connections) - Return the node's connection information.
2. [get synchronizer](#get-synchronizer) - Return the metadata synchronization information.


### run tcp server
**Usage**:
<pre>
    <code>
run tcp server where external_ip = [ip] and external_port = [port] and internal_ip = [local_ip] and internal_port = [local_port] and bind = [true/false] and threads = [threads count]
    </code>
</pre>

**Explanation**: Set a TCP server in a listening mode on the specified IP and port.

* The first pair of IP and Port that are used by a listener process to receive messages from members of the network.
* The second pair of IP and Port are optional, to indicate the IP and Port that are accessible from a local network.
* _threads_ - an optional parameter for the number of workers threads that process requests which are sent to the provided IP and Port. The default value is 6.

**Examples**:
<pre>
    <code>
run tcp server where external_ip = !ip and external_port = !port  and threads = 3

run tcp server where external_ip = !external_ip and external_port = 7850 and internal_ip = !ip and internal_port = 7850 and threads = 6
    </code>
</pre>

**Details**: [run tcp server](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#blockchain-synchronizer)

### get connections
**Usage**:
<pre>
    <code>
get connections
    </code>
</pre>

**Explanation:**

Return the node's connection information including the TCP service information.

### run blockchain sync
**Usage**:
<pre>
    <code>
run blockchain sync [options]
    </code>
</pre>
        

**Explanation:**  
Repeatedly update the local copy of the blockchain

**Options:**   
* source - The source of the metadata (blockchain or a Master Node). 
* dest - The destination of the blockchain data such as a file (a local file) or a DBMS (a local DBMS).
* connection - The connection information that is needed to retrieve the data. For a Master, the IP and Port of the master node.
* time - The frequency of updates.

**Examples:**  
<pre>
    <code>
run blockchain sync where source = master and time = 3 seconds and dest = file and dest = dbms and connection = !ip_port
run blockchain sync where source = blockchain and time = !sync_time and dest = file and platform = ethereum
    </code>
</pre>


### get synchronizer
**Usage**:
<pre>
    <code>
get synchronizer
    </code>
</pre>

**Explanation:**

Return the synchronizer status.

**details:** [Synchronier Status](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#synchronizer-status).

## The local data storage service

### run operator

A service that captures the data streams, identifies or creates schemas and ingest the data into a local database.

**Usage**:
<pre>
    <code>
run operator where [option] = [value] and [option] = [value] ...
    </code>
</pre>

**Explanation:**

Monitors new data added to the watch directory and load the new data to a local database

**Options:**

* policy - The ID of the operator policy.
* compress_json - True/False to enable/disable compression of the JSON file.
* compress_sql - True/False to enable/disable compression of the SQL file.
* archive_json - True moves the JSON file to the 'archive' dir if processing is successful. The file deleted if archive_sql is false.
* archive_sql -  True moves the SQL file to the 'archive' dir if processing is successful. The file deleted if archive_sql is false.
* limit_tables - A list of comma separated names within brackets listing the table names to process.
* craete_table - A True value creates a table if the table doesn't exist.
* master_node - The IP and Port of a Master Node (if a master node is used).
* update_tsd_info - True/False to update a summary table (tsd_info table in almgm dbms) with status of files ingeste

**Examples:**  
<pre>
    <code>
run operator where create_table = true and update_tsd_info = true and archive_json = true and distributor = true and master_node = !master_node and policy = !operator_policy  and threads = 3
run operator where create_table = true and update_tsd_info = true and archive_json = true and distributor = true and blockchain = ethereum and policy = !operator_policy  and threads = 3
    </code>
</pre>

**details:** [Operator Process](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#operator-process).


### get operator



 get blobs archiver
 get rest server info
 run blobs archiver
 run grpc client
 run kafka consumer
 run message broker
 run msg client
 run rest server
 run scheduler
 run smtp client
 run streamer
 run tcp server
 set data distribution
