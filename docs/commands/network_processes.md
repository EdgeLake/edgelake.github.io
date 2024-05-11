---
layout: default
title: Northbound Services
parent: Commands
nav_order: 5
---
# Interacting with the network
Users and Applications interact with the network to query data or issue native commands using the CLI or via REST.
Data is streamed to the network using a varaiety of methods summarized below.

# Query data and issue commands

Users and applications connect to the network by issuing queries and commands to a single node in the network. This node serves as a
gateway to the network.    

Queries and commands issued to a node can be processed locally, or by peers (target nodes) in the network.  
When a SQL query is issued, the target nodes are determined dynamically and transparently by the database referenced 
in the query info and the table name in the SQL command. Alternatively users can specify the target nodes.  

The target nodes for commands (which are not SQL) are specified by the user or the calling application.     

Specifying the target nodes can be done by listing their IPs and Ports, or by a query to the metadata.  
Queries to the metadata can leverage domain info represented in the metadata policies. 
Example are: all nodes deployed in a region, and all nodes supporting machines from a specified vendor.    
Note that users can represent their domain knowledge in the metadata policies and leverage this info to identify target nodes.  
The EdgeLake Metadata APIs are open allowing to update and query metadata information as needed, and the metadata can be used to identify target nodes.

## Issuing queries and commands to the network

Commands can be delivered in one of the following ways:
* **On the node's CLI**. If the command is prefixed with **run client (target nodes)** the node serves as a client to the network and the 
command will be issued on the target nodes specified in the prefix. Otherwise, the command is executed on the local node.
  details ate available in the [TCP Messages Section](https://github.com/AnyLog-co/documentation/blob/master/network%20processing.md#the-tcp-messages).
* **Using the Remote CLI** (via REST). This is a graphical web based interactive remote CLI tool that issues queries and commands to a selected node in the network.  
  If the **Network** button is selected on the Remote CLI, the selected node (specified in the **connect info** field) serves as a gateway to the network, and 
  the target nodes can be specified by IPs and Ports, or through a query to the metadata, or with SQL, by the network protocol.  
  If the **Network** button is not selected, the command or query is executed on the node specified in the **connect info** field. Details on the Remote CLI
  are available in the [Remote CLI](https://github.com/AnyLog-co/documentation/blob/master/northbound%20connectors/remote_cli.md) section.
* **Using REST calls**. 
    * Note, users can see the structure of REST requests by specifying the command on the Remote CLI and 
      selecting the **Code** option.
    * Examples of REST calls to a network from Python, Postman, Grafana, Power BI, and Google tools are available
      [here](https://github.com/AnyLog-co/documentation/tree/master/northbound%20connectors).
  
Notes:
* To support calls from the Node's CLI, the TCP service needs to be enabled. 
  Details are available in the [TCP Service](backgound_services.md#run-tcp-server).
* To support the REST API, the REST service needs to be enabled on the node that serves as the network bridge.
  Details are available in the [REST Service](backgound_services.md#run-rest-server) section.
  
  
# Streaming data to the EdgeLake Network

Users stream their data into Operator Nodes. These nodes are configured to host the data and operate as follows:
* Data streams are identified by their source and their assigned logical database and table.
* The logical database identifies the physical database that hosts the table's data. 
  See details [here](data_management.md#associate-a-physical-database-to-a-logical-database).
* If the table exists (published as a policy on the shared metadata), the data will be hosted in the table.
* If the table doesn't exist, a schema is created based on the streaming data and published on the metadata.
* Optionally, users defile a **Mapping Policy** to instruct a schema and the mapping rules.
* Additional logic on the streaming data can be added by rules in one of the following manners:
    * Specifying rules in the **Mapping Policy**.
      Details are available in the [Mapping Data](https://github.com/AnyLog-co/documentation/blob/master/mapping%20data%20to%20tables.md#mapping-data) section.
    * Specifying rules with the node's **Rule Engine**.
      Details are available in the [Alerts and Monitoring](https://github.com/AnyLog-co/documentation/blob/master/alerts%20and%20monitoring.md#alerts-and-monitoring) section.
    

## Southbound connectors

A detailed description on how data is added to nodes in the network is available [here](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md).

Users can transfer data to nodes in the network using one of the following methods:

* [Using REST](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#data-transfer-using-a-rest-api)
* [Subscribing to a Nessaage Broker](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#subscribing-to-a-third-party-message-broker)
* [Configuring the EdgeLake node as a Message Broker](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#configuring-the-anylog-node-as-a-message-broker)
* [Using Kafka](https://github.com/AnyLog-co/documentation/blob/master/using%20kafka.md)
* [Using Syslog](https://github.com/AnyLog-co/documentation/blob/master/using%20syslog.md).
* [Using gRPC](https://github.com/AnyLog-co/documentation/blob/master/using%20grpc.md).
* [Using Node-Red](https://github.com/AnyLog-co/documentation/blob/master/node_red.md).



