# Background services

## Connect to the EdgeLake Network

Connecting to an EdgeLake Network requires 2 services:
1. **run tcp server** - A listener service for incoming messages.
2. ** run blockchain sync** - A service that continuously synchronizes the metadata 

### run tcp server

**Usage:**
<pre><code>
run tcp server where external_ip = [ip] and external_port = [port] and internal_ip = [local_ip] and internal_port = [local_port] and bind = [true/false] and threads = [threads count]
</code></pre>

**Explanation:**

Set a TCP server in a listening mode on the specified IP and port.  
The first pair of IP and Port that are used by a listener process to receive messages from members of the network.  
The second pair of IP and Port are optional, to indicate the IP and Port that are accessible from a local network.  
threads - an optional parameter for the number of workers threads that process requests which are sent to the provided IP and Port. The default value is 6.  

**Examples:**

run tcp server where external_ip = !ip and external_port = !port  and threads = 3  
run tcp server where external_ip = !external_ip and external_port = 7850 and internal_ip = !ip and internal_port = 7850 and threads = 6  

**Details**

[run tcp server](https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#blockchain-synchronizer)


### run blockchain sync

<pre><code>
run blockchain sync [options]
</code></pre>
        

Explanation:
        Repeatadly update the local copy of the blockchain
        Options:
        source - The source of the metadata (blockchain or a Master Node).
        dest - The destination of the blockchain data such as a file (a local file) or a DBMS (a local DBMS).
        connection - The connection information that is needed to retrieve the data. For a Master, the IP and Port of the master node.
        time - The frequency of updates.

Examples:
        run blockchain sync where source = master and time = 3 seconds and dest = file and dest = dbms and connection = !ip_port
        run blockchain sync where source = blockchain and time = !sync_time and dest = file and platform = ethereum





 get blobs archiver
 get consumer
 get distributor
 get operator
 get publisher
 get rest server info
 get synchronizer
 run blobs archiver
 run data consumer
 run data distributor
 run grpc client
 run kafka consumer
 run message broker
 run msg client
 run operator
 run publisher
 run rest server
 run scheduler
 run smtp client
 run streamer
 run tcp server
 set data distribution
