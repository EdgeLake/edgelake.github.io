# Background services

## Connect to the EdgeLake Network

Connecting to an EdgeLake Network requires 2 services:
1. A listener service for incoming messages enables by the **run tcp server** command.
2. A service that continuously synchronizes the metadata. 

### run tcp server

Usage:
        run tcp server where external_ip = [ip] and external_port = [port] and internal_ip = [local_ip] and internal_port = [local_port] and bind = [true/false] and threads = [threads count]

Explanation:
        Set a TCP server in a listening mode on the specified IP and port.
        The first pair of IP and Port that are used by a listener process to receive messages from members of the network.
        The second pair of IP and Port are optional, to indicate the IP and Port that are accessible from a local network.
        threads - an optional parameter for the number of workers threads that process requests which are sent to the provided IP and Port. The default value is 6.

Examples:
        run tcp server where external_ip = !ip and external_port = !port  and threads = 3
        run tcp server where external_ip = !external_ip and external_port = 7850 and internal_ip = !ip and internal_port = 7850 and threads = 6






 get blobs archiver
 get consumer
 get distributor
 get operator
 get publisher
 get rest server info
 get synchronizer
 run blobs archiver
 run blockchain sync
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
