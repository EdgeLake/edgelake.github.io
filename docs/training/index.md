---
layout: default
title: Training
nav_order: 7
has_children: true
---

# Training Overview
This document and the referenced documents explain the deployment and configuration of an EdgeLake test network.

EdgeLake is deployed using _Docker_ as a pre-configured software package.
To address dynamic and ad-hoc needs, each EdgeLake node provides an interactive environment allowing to dynamically change 
configurations and issue commands and queries. In addition, the interactive environment is extended to send requests and 
inspect responses remotely via REST. Users can use tools like [_cURL_](https://curl.se/) or [Postman](../northbound/using_postman.md) 
as well as a [Remote-CLI](../northbound/remote_cli.md) which is an EdgeLake web based application allowing intuitive and 
simple GUI to interact with nodes in the AnyLog Network.

The training reviews the basic operations with EdgeLake nodes and guides users to manage, monitor and query nodes, metadata and data. This training demonstrates how to make changes to the default configurations to satisfy proprietary processes, data connectors, and specific/domain requirements.

Prerequisites for AnyLog Nodes are detailed [here](prerequisites.md).

**Note**: For the training sessions, remove firewalls restrictions and assign each node to a static IP.


## Training Architecture 

<div style="text-align: center;"><b>The test network deployed is shown in the following diagram</b></div>

<div class="image-frame"><img src="../../../imgs/deployment_diagram.png" /></div>

In the test network, data will be transferred to the 2 Operator Nodes, and a query that is processed on the Query Node 
will be satisfied as if the entire data set is hosted locally (as if the 2 Operators are a single machine).

**Note 1**: The table of content to the AnyLog documentation is available in the README Section

**Note 2**: In this training, some configurations are packaged with the software deployed, and some configurations are 
done using the EdgeLake command-line.

In a customer deployment, all configurations are pre-packaged, and associated to a node by one (or more) of these processes:

<ol start="1">
    <li>By maintaining configuration commands in a local file that is associated to a node</li>
    <li>By dynamically creating a configuration file (for the node) during the Docker deployment.</li>
    <li>By maintaining configuration commands in policies stored in the shared metadata and associating a configuration policy to a node.</li>
</ol>

**Note 3**: Advanced users can review the [Network Setup](https://github.com/AnyLog-co/documentation/blob/master/examples/Secure%20Network.md) Document to deploy a test network using the EdgeLake CLI without pre-packaged configuration.







