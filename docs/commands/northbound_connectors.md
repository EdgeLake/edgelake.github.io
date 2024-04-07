# Connect to the network

Users and applications connect to the network by issuing commands to a single node in the network. This node serves as a
gateway to the network.    
Commands issued to a node can be processed locally, or by peers (target nodes) in the network.  
When a SQL query is issued, the target nodes can be determined dynamically and transparently by the database referenced 
in the query info and the table name in the SQL command. Alternatively users can specify the target nodes.        
The target nodes for commands which are not SQL are specified by the user ot the calling application.     
Specifying the target nodes can be done by listing their IPs and Ports, or by a query to the metadata. 
Examples are: all nodes deployed in a region. Or all nodes supporting machines from a specified vendor.    
The metadata is organized by policies and users can include in the metadata any information of importance. In the context
of identifying target nodes, the metadata API allows to query the policies to determine target nodes.

## Issuing commands to the network

Commands can be delivered in one of the following ways:
* On the node CLI. If the command is prefixed with **run client (target nodes)** the node serves as a client to the network and the 
command will be issued on the target nodes specified in the prefix. Otherwise the command is executed on the local node.
  details ate available in the [TCP Messages Section](https://github.com/AnyLog-co/documentation/blob/master/network%20processing.md#the-tcp-messages).
  

  
  