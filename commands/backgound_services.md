# Background services

**Table of content:**

[list the background services and their status](#list-the-background-services-and-their-status)    
[Connect to the EdgeLake Network](#connect-to-the-edgelake-network)  
[The local data storage service](#the-local-data-storage-service)  
[REST Services](#rest-services)
[The message broker services](#message-broker-services)
[Subscribe to a 3rd party broker](#subscribe-to-a-3rd-party-broker)


## list the background services and their status

**Usage**:
<pre>
    <code>
get processes [where format = json]
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

**Details:** [Synchronier Status](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#synchronizer-status).

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

**Details:** [Operator Process](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#operator-process).


### get operator

**Usage:**
<pre>
    <code>
get operator [options] [where format = json]
    </code>
</pre>

**Explanation:**

Return information on the Operator processes and configuration.

**Examples:**
<pre>
    <code>
get operator
get operator inserts
get operator summary
get operator config
get operator summary where format = json
    </code>
</pre>

**details:** [get operator](https://github.com/AnyLog-co/documentation/blob/master/monitoring%20calls.md#get-operator)

## REST Services
Enable and monitor a service that receives commands and data via REST from 3rd parties applications and data sources.

* Enable the service: [run rest server](#run-rest-server)
* Monitor the REST service:
    * [get rest server info]
    * [get rest calls]
    * [get rest pool]

###  run rest server
**Usage:**
<pre>
    <code>
 run rest server where external_ip = [external_ip ip] and external_port = [external port] and internal_ip = [internal ip] and internal_port = [internal port] and timeout = [timeout]
 and ssl = [true/false] and bind = [true/false]
   </code>
</pre>

**Explanation:**

Enable a REST server in a listening mode on the specified ip and port.
* The IP and Ports associate the service with external and internal IPs and Ports.
* [timeout] - Max wait time in seconds. A 0 value means no wait limit, and the default value is 20 seconds. A timeout returns an error message to the calling application. 
* If ssl is set to True, connection is using HTTPS.
* If bind is **true**, only the specified IP is allowed (with 2 IPs, the external is ignored).

Examples:
<pre>
    <code>
run rest server where internal_ip = !ip and internal_port = 7849 and timeout = 0 and threads = 6 and ssl = true
    </code>
</pre>


**Details:** [Rest Requests](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#rest-requests)


### get rest server info
Provide configuration information of the REST server.

### get rest calls
Statistics on the REST calls.

### get rest pool
Status of REST threads.

## message broker services
Enable and monitor a service that operates as a message broker, allowing to publish data on the EdgeLake Node.

### run message broker
**Usage:**
<pre>
    <code>
run message broker where external_ip = [ip] and external_port = [port] and internal_ip = [local_ip] and internal_port = [local_port] and bind = [true/false] and threads = [threads count]
    </code>
</pre>

**Explanation:**  Set a message broker in a listening mode on the specified IP and port. **Threads count** represents the number of threads supporting the service.

**Examples:**
<pre>
    <code>
run message broker where external_ip = !ip and external_port = !port  and threads = 3
run message broker where external_ip = !external_ip and external_port = 7850 and internal_ip = !ip and internal_port = 7850 and threads = 6
    </code>
</pre>

**Details:** [Message Broker SErvices]( https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#message-broker)

### get local broker
Statistics on the local broker (if the data is published to the IP and Port of the node's message broker server).

## Subscribe to a 3rd party broker

Retrieve data from a 3rd party broker and monitor the streaming process.

### run msg client
The command subscribes to a 3rd party broker. It includes options to map the source data (the data on the broker) to a destination format.
The mapping can be done using command variables, or by associating a mapping policy (from the metadata). See details below and with 
the details link.

**Usage:**
<pre>
    <code>
run msg client where broker = [url] and port = [port] and user = [user] and password = [password] and topic = (name = [topic name] and dbms = [dbms name] and table = [table name] and [participating columns info])
</pre>

**Explanation:**  

**Examples:**
<pre>
    <code>
run msg client where broker = "driver.cloudmqtt.com" and port = 18975 and user = mqwdtklv and password = uRimssLO4dIo and topic = (name = test and dbms = "bring [metadata][company]
" and table = "bring [metadata][machine_name] _ [metadata][serial_number]" and column.timestamp.timestamp = "bring [ts]" and column.value.int = "bring [value]")


    </code>
</pre>

**Details:** [Message Broker SErvices]( https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#message-broker)





 get blobs archiver
 run blobs archiver
 run grpc client
 run kafka consumer
 run msg client
 run scheduler
 run smtp client
 run streamer
 set data distribution
