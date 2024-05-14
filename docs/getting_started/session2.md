---
layout: default
parent: Quick Start
title: Session II
nav_order: 4
---
# Deployment of the Test Network

This document describes how to deploy and configure an AnyLog/EdgeLake Network. This guided session provides directions to:
Deploy an  AnyLog/EdgeLake Network consisting of 4 nodes (2 operators, 1 query, 1 master).

When an EdgeLake node is deployed, the software packages needs to be organized on the node with proper configurations.  
Each EdgeLake Node is using the same software stack, however, the nodes in the network are assigned to different roles, 
and these roles are determined by the configurations.    

The main roles are summarized in the table below:

<table>
    <tr>
        <td style="text-align: center"><b>Node Type</b></td>
        <td style="text-align: center"><b>Functionality</b></td>
    </tr>
    <tr>
        <td><a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_master.env" target="_blank">Master</a></td>
        <td>A node that manages the shared metadata (if a blockchain platform is used, this node is redundant)</td>
    </tr>
    <tr>
        <td><a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_operator.env" target="_blank">Operator</a></td>
        <td>A node that hosts the data. In this session, users deploy 2 Operator nodes</td>
    </tr>
    <tr>
        <td><a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_query.env" target="_blank">Query</a></td>
        <td>A node that coordinates the query process</td>
    </tr>
</table>

Additional information on the types of nodes is in the [Getting Started](../getting_started.md) document.

The roles are determined by configuration commands which are processed by each node at startup and enable services 
offered by the node. The same node may be assigned to multiple roles - there are no restrictions on the services that 
can be offered by a node.

Since configuration is "command based", it is simple to change configurations, and even dynamically (using the CLI),
by disabling a service or enabling a service using the proper commands.  

In this training, users will be using the default configuration file, and make some modifications to support their
proprietary settings.

### This session includes 4 sections:
1. [Prerequisites & Support Software](#prerequisites--support-software)
2. Machine Configurations
3. Deploy EdgeLake 
4. Test & Query EdgeLake

## Prerequisites & Support Software
### Prerequisites 
Prior to this session, users are required to prepare:
<ul>
    <li>4 machines (virtual or physical) to host the EdgeLake nodes, as follows:
        <ul style="padding-left: 20px">
            <li>Linux, Windows or MacOSX environment with Docker / docker-compose installed</li>
            <li>A minimum of 512MB of RAM</li>
            <li>A minimum of 10GB of disk space</li>
        </ul>
    </li>
    <li>1 Machine (physical or virtual) for applications that interact with the network (i.e. Grafana), as follows
        <ul style="padding-left: 20px">
            <li>Linux, Windows or MacOSX environment</li>
            <li>A minimum of 256MB of RAM</li>
            <li>A minimum of 10GB of disk space</li>
        </ul>
    </li>
    <li>Each node accessible by IP and Port (remove firewalls restrictions)</li>
</ul>

**Note 1**: The prerequisites for a customer deployment are available [here](prerequisite.md).

**Note 2** We recommend deploying an overlay network, such as <a herf="https://github.com/AnyLog-co/documentation/blob/master/deployments/Networking%20&%20Security/nebula.md" target="_blank"> nebula</a>.
 * It provides a mechanism to maintain static IPs.
 * It provides the mechanisms to address firewalls limitations.
 * It isoltates the network addressing security considerations. 

**Note 3** If an overlay network is not used in the training, remove firewalls restrictions to allow for nodes to 
communicate with peers and with 3rd parties applications.


### Support Software

The following table summarizes the commonly used packages deployed with EdgeLake.
<table>
    <tr>
        <td style="text-align: center"><b>Software</b></td>
        <td style="text-align: center"><b>Functionality</b></td>
    </tr>
    <tr>
        <td><a href="../northbound/remote_cli.md">Remote-CLI</a></td>
        <td>A web based interface to the network</td>
    </tr>
    <tr>
        <td><a href="https://www.postgresql.org/" target="_blank">PostgresSQL</a></td>
        <td>SQL-based local database</td>
    </tr>
    <tr>
        <td><a href="https://www.mongodb.com/" target="_blank">MongoDB</a></td>
        <td>Local database for unstructured data</td>
    </tr>
    <tr>
        <td>Northbound Visualization Tool
            <ul>
                <li><a href="../northbound/Grafana.md">Grafana</a></li>
                <li><a href="../northbound/PowerBI.md">PowerBI</a></li>
            </ul>
        <td>BI tool for visualization of the data</td>
    </tr>
    <tr>
        <td>Southbound Data Generators
            <ul>
                <li><a href="../southbound/edgex.md">EdgeX</a></li>
                <li><a href="../southbound/fledge.md">FLEDGE</a></li>
                <li><a href="../southbound/node_red.md">Node-RED</a></li>
            </ul>
        </td>
        <td>A connector to PLCs and sensors</td>
    </tr>
</table>

#### In this session, users will use the following packages:
* Local database is SQLite (and is available by default without a dedicated install).
* Remote CLI - deployed with the Query Node.
* Grafana, on a dedicated node, as an example for an application interacting with the network data.


