# Connect to the network

Users and applications connect to the network by issuing commands to a single node in the network. This node serves as a
gateway to the network.    

Commands issued to a node can be processed locally, or by peers (target nodes) in the network.  
When a SQL query is issued, the target nodes are determined dynamically and transparently by the database referenced 
in the query info and the table name in the SQL command. Alternatively users can specify the target nodes.  

The target nodes for commands which are not SQL are specified by the user ot the calling application.     
Specifying the target nodes can be done by listing their IPs and Ports, or by a query to the metadata. 
Examples are: all nodes deployed in a region. Or all nodes supporting machines from a specified vendor.    

The metadata is organized by policies and users can include in the metadata any information of importance. In the context
of identifying target nodes, the metadata API allows to query the policies to determine target nodes.

## Issuing commands to the network

Commands can be delivered in one of the following ways:
* On the node CLI. If the command is prefixed with **run client (target nodes)** the node serves as a client to the network and the 
command will be issued on the target nodes specified in the prefix. Otherwise, the command is executed on the local node.
  details ate available in the [TCP Messages Section](https://github.com/AnyLog-co/documentation/blob/master/network%20processing.md#the-tcp-messages).
* Using the Remote CLI (via REST). This is a graphical web based interactive remote CLI tool that issues queries and commands to a selected node in the network.
  If the **Network** button is selected on the Remote CLI, the selected node (**connect info** field) serves as a gateway to the network, and 
  the target nodes can be specified by IPs and Ports, or through a query to the metadata, or with SQL, by the network protocol.
  If the **Network** button is not selected, the command or query is executed on the selected node. Details on the Remote CLI
  are available in the [Remote CLI](https://github.com/AnyLog-co/documentation/blob/master/northbound%20connectors/remote_cli.md) section.
* Using REST calls. 
    * Note, users can see the structure of REST requests by specifying the command on the Remote CLI and 
      selecting the **Code** option.
    * Examples of REST calls to a network from Python, Postman, Grafana, Power BI, and Google tools are available
      [here](https://github.com/AnyLog-co/documentation/tree/master/northbound%20connectors).
  
Note: To support the REST API, the REST service needs to be enabled on the node that serves as the network bridge.
Detais are available in the [REST Service](backgound_services.md#run-rest-server) section.
  
  