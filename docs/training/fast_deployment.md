---
layout: default
parent: Quick Start
title: Fast Deployment
nav_order: 2
---

# Fast Deployment of the Test Network

This document lists the steps to deploy a network of 4 nodes (master, query and 2 operators nodes).

A detailed description of every step is available in the [Session II](Session%20II%20(Deployment).md) Deployment document.

## Requirements 
* 2 machines - either physical or virtual.
  * **Machine A** - deployed with Master, Query, Operator and a remote CLI.
  * **Machine B** - deployed with the second Operator. 
* <a href="https://docs.docker.com/engine/install/" target="_blank">Docker</a>
* <a href="https://www.gnu.org/software/make/manual/make.html" target="_blank">Makefile</a>

## Steps
<ol start="1">
    <li>On both machines - Clone EdgeLake
        <pre class="code-frame"><code class="language-shell">cd $HOME
git clone https://github.com/EdgeLake/docker-compose</code></pre>
    </li>
    <li>Make sure ports are open and accessible
    <table>Default Ports
        <tr>
            <td></td>
            <td style="text-align: center; font-weight: bold">TCP</td>
            <td style="text-align: center; font-weight: bold">REST</td>
            <td style="text-align: center; font-weight: bold">Message Broker (Optional)</td>
        </tr>
        <tr>
            <td>Master</td>
            <td style="text-align: right">32048</td>
            <td style="text-align: right">32049</td>
            <td></td>
        </tr>
        <tr>
            <td>Operator</td>
            <td style="text-align: right">32148</td>
            <td style="text-align: right">32149</td>
            <td style="text-align: right">32150</td>
        </tr>
        <tr>
            <td>Query</td>
            <td style="text-align: right">32348</td>
            <td style="text-align: right">32349</td>
            <td></td>
        </tr>
    </table>
    </li>
</ol>

### Master Node
<ol start="1">
    <li>cd into docker-compose directory</li>
    <li>Update the params in <a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_master.env" target="_blank">docker_makefile/edgelake_master.env</a> 
        <ul style="padding-left: 20px;">Key Params:
            <li>NODE_NAME</li>
            <li>COMPANY_NAME</li>
        </ul>
    </li>
    <li> Start Node
        <pre class="code-frame"><code class="language-shell">make up EDGELAKE_TYPE=master</code></pre>
    </li>
    <p><b>Validate that the Master Node is properly configured</b></p>
    <li>Attach into master node
        <pre class="code-frame"><code class="language-shell">make attach EDGELAKE_TYPE=master</code></pre>
    </li>
    <li>Execute <code class="language-anylog">test node</code> to validate basic node configuration
        <pre class="code-frame"><code class="language-shell">EL edgelake-master +> test node 

Test TCP
[************************************************************]
 
Test REST
[************************************************************]

Test                                      Status                                                                
-----------------------------------------|-----------------------------------------------------------------------|
Metadata Version                         |02a3d84c0017bbaea01a19780734d801                                       |
Metadata Test                            |Pass                                                                   |
TCP test using 45.79.74.39:32048         |[From Node 45.79.74.39:32048] edgelake-master@45.79.74.39:32048 running|
REST test using http://45.79.74.39:32049 |edgelake-master@45.79.74.39:32048 running                              |
</code></pre>
</li>
<li>Detach from CLI - <code class="language-shell">ctrl-d</code></li>
</ol>
**Note**: The TCP IP and Port (in the example - `45.79.74.39:32048`) is used as the Network Identifier, which will be referenced 
by all members nodes that are assigned to this (test) network.   

This IP and Port is assigned to the attribute called LEDGER_CONN on each peer node. 

### Operator Node(s)
The following configuration steps can be used for each deployed operator. 
<ol start="1">
    <li>cd into docker-compose directory</li>
    <li>Update the params in <a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_operator.env" target="_blank">docker_makefile/edgelake_operator.env</a>
        <ul style="padding-left: 20px;">Key Params:
            <li>NODE_NAME - each operator should have unique value</li>
            <li>COMPANY_NAME</li>
            <li>LEDGER_CONN - should be set to the TCP connection of the Master Node (the value 45.79.74.39:32048 using the Master Node deployment example above)</li>
            <li>CLUSTER_NAME - each operator should have unique cluster name</li>
            <li>DEFAULT_DBMS - should be the same on both operators</li>
            <li>ENABLE_MQTT - true value allows to publish data on the node as if the node is an MQTT broker</li>
            <li>MSG_DBMS - should be set to the same value as DEFAULT_DBMS</li>
            <li><b>Note: to deploy multiple operators on the same machine, make sure each operator is configured with unique port values</b></li>
        </ul>
    </li>
    <li> Start Node
        <pre class="code-frame"><code class="language-shell">make up EDGELAKE_TYPE=operator</code></pre>
    </li>
    <p><b>Validate that the Operator Node is properly configured</b></p> 
    <li>Attach into operator node
        <pre class="code-frame"><code class="language-shell">make attach EDGELAKE_TYPE=operator</code></pre>
    </li>
    <li>Execute <code class="language-anylog">test network</code> to validate you're able to communicate with the nodes in the network
        <pre class="code-frame"><code class="language-shell">EL edgelake-operator +> test network  
                                                                                         
Test Network
[****************************************************************]
 
Address               Node Type Node Name                     Status 
---------------------|---------|-----------------------------|------|
35.225.182.15:32148  |operator |edgelake-operator            |  +   |
45.79.74.39:32048    |master   |edgelake-master              |  +   |
</code></pre>
</li>
    <li>Detach from CLI - <code class="language-shell">ctrl-d</code></li>
</ol>

### Query Node(s) 
<ol start="1">
    <li>cd into docker-compose directory</li>
    <li>Update the params in <a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_query.env" target="_blank">docker_makefile/edgelake_query.env</a>
        <ul style="padding-left: 20px;">Key Params:
            <li>NODE_NAME - each query node should have unique value</li>
            <li>COMPANY_NAME</li>
            <li>LEDGER_CONN - should be set to the TCP connection of the Master Node</li>
        </ul>
    </li>
    <li> Start Node
        <pre class="code-frame"><code class="language-shell">make up EDGELAKE_TYPE=query</code></pre>
    </li>
    <p><b>Validate that the Query Node is properly configured</b></p>
    <li>Attach into query node
        <pre class="code-frame"><code class="language-shell">make attach EDGELAKE_TYPE=query</code></pre>
    </li>
    <li>Execute <code class="language-anylog">test network</code> to validate you're able to communicate with the nodes in the network
        <pre class="code-frame"><code class="language-shell">EL edgelake-query +> test network  
                                                                                         
Test Network
[****************************************************************]
 
Address               Node Type Node Name                     Status 
---------------------|---------|-----------------------------|------|
35.225.182.15:32148  |operator |edgelake-operator            |  +   |
45.79.74.39:32048    |master   |edgelake-master              |  +   |
23.239.12.151:32348  |query    |edgelake-query               |  +   |
</code></pre></li>
    <li>Detach from CLI - <code class="language-shell">ctrl-d</code></li>
</ol>

## Commands & Queries

<ul><b>Operator Commands</b> 
    <li>To see the data streams on a node
        <pre class="code-frame"><code class="language-anylog">get streaming</code></pre>
    </li>
    <li>View the list of tables
        <pre class="code-frame"><code class="language-anylog">get virtual tables</code></pre>
    </li>
    <li>View columns in a table - Replace [dbms name] with the name given to DEFAULT_DBMS in the config file. 
        <pre class="code-frame"><code class="language-anylog">get columns where dbms=[dbms name] and table = rand_data</code></pre>
    </li>
    <li>View data distribution (for each table)
        <pre class="code-frame"><code class="language-anylog">get data nodes</code></pre>
    </li>
<b>Sample Queries</b> - Replace [dbms name] with the name given to DEFAULT_DBMS in the config file.
    <li>Get Row Count
        <pre class="code-frame"><code class="language-anylog">run client () sql [dbms name] format=table "select count(*) from rand_data"</code></pre>
    </li>
    <li>View timestamp and value
        <pre class="code-frame"><code class="language-anylog">run client () sql [dbms name] format=table "select timeestamp, value from rand_data"</code></pre>
    </li>
</ul>