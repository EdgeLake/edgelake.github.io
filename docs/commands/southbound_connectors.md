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
    * Specifying rules with the node's **Rule Engine**.
    

## Southbound connectors

A detailed description on how data is added to nodes in the network is available [here](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md).

Users can transfer data to nodes in the network using one of the following methods:

* [Using REST](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#data-transfer-using-a-rest-api)
* [Subscribing to a Nessaage Broker](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#subscribing-to-a-third-party-message-broker)
* [Configuring the EdgeLake node as a Message Broker](https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#configuring-the-anylog-node-as-a-message-broker)
* [Using Kafka](https://github.com/AnyLog-co/documentation/blob/master/using%20kafka.md)
* [Using Syslog](https://github.com/AnyLog-co/documentation/blob/master/using%20syslog.md).
* [Using gRPC](https://github.com/AnyLog-co/documentation/blob/master/using%20grpc.md).



