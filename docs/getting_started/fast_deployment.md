---
layout: default
parent: Getting Started
title: Fast Deployment
nav_order: 2
---

# Fast Deployment of the Test Network

This document lists the deployment steps to bring a network of 4 nodes (master, query and 2 operators nodes) and a remote CLI.    
A detailed description of every step is available in the [Session II](Session%20II%20(Deployment).md) Deployment document.

## Requirements 
* 2 machines - either physical or virtual
  * **Machine A** - deployed with Master, Query, Operator and a remote CLI.
  * **Machine B** - deployed with the second Operator. 
* <a href="https://docs.docker.com/engine/install/" target="_blank">Docker</a>
* <a href="https://www.gnu.org/software/make/manual/make.html target="_blank">Makefile</a>

## Steps
<ol start="0">
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
            <td>32048</td>
            <td>32049</td>
            <td></td>
        </tr>
        <tr>
            <td>Operator</td>
            <td>32148</td>
            <td>32149</td>
            <td>32150</td>
        </tr>
        <tr>
            <td>Query</td>
            <td>32348</td>
            <td>32349</td>
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
    <b>Validate Node is working</b> 
    <li>Attach into master node
        <pre class="code-frame"><code class="language-shell">make attach EDGELAKE_TYPE=master</code></pre>
    </li>
    <li>Execute <code class="language-anylog">test node</code> to validate everything is working properly 
        <pre class="code-frame"><code class="language-shell">EL edgelake-master +> test node 

Test TCP
[************************************************************]

EL anylog-master +> 
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
**Note**: The TCP connection information (in the exampl - `45.79.74.39:32048` will be used as the LEDGER_CONN for the 
other nodes. 


### Operator Node(s)
The following steps can be used for both operator nodes, any differences would are specified in the correlated step. 
<ol start="1">
    <li>cd into docker-compose directory</li>
    <li>Update the params in <a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_operator.env" target="_blank">docker_makefile/edgelake_operator.env</a>
        <ul style="padding-left: 20px;">Key Params:
            <li>NODE_NAME - each operator should have unique value</li>
            <li>COMPANY_NAME</li>
            <li>LEDGER_CONN - should be set to the TCP connection for Master Node</li>
            <li>CLUSTER_NAME - each operator should have unique value</li>
            <li>DEFAULT_DBMS - should be the same on both operators</li>
            <li>(Optional) ENABLE_MQTT</li>
            <li>MSG_DBMS - should be set to the same value as DEFAULT_DBMS</li>
            <li>If you run multiple operators on the same machine, make sure they each have unique port values</li>
        </ul>
    </li>
    <li> Start Node
        <pre class="code-frame"><code class="language-shell">make up EDGELAKE_TYPE=operator</code></pre>
    </li>
    <b>Validate Node is working</b> 
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
</li>
    <li>Detach from CLI - <code class="language-shell">ctrl-d</code></li>
</ol>

### Query Node(s) 
<ol start="1">
    <li>cd into docker-compose directory</li>
    <li>Update the params in <a href="https://github.com/EdgeLake/docker-compose/blob/main/docker_makefile/edgelake_query.env" target="_blank">docker_makefile/edgelake_query.env</a>
        <ul style="padding-left: 20px;">Key Params:
            <li>NODE_NAME - each operator should have unique value</li>
            <li>COMPANY_NAME</li>
            <li>LEDGER_CONN - should be set to the TCP connection for Master Node</li>
        </ul>
    </li>
    <li> Start Node
        <pre class="code-frame"><code class="language-shell">make up EDGELAKE_TYPE=query</code></pre>
    </li>
    <b>Validate Node is working</b> 
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
23.239.12.151:32348  |query    |anylog-query                 |  +   |
</li>
    <li>Detach from CLI - <code class="language-shell">ctrl-d</code></li>
</ol>




Test the network by issuing the command: **test network** on the AnyLog CLI.  
* With the first Master - Three nodes (a Master, a Query and an Operator node) are identified).
* With the second Master - Four nodes (a Master, a Query and 2 Operators) are identified.

Note: In this training session, the operators are configured to pull data from a 3rd party broker. Issue the command 
```get streaming``` to see the data stream to the node (from the external broker). 

#### Detach

Using the keys: **ctrl+d**

## Example commands and queries on the Query Node

Note: In this training, when an operator node is initiated, it is configured to subscribe to data that is published on 
a 3rd party broker. It can take up to a minute before data is available on the node and the tables hosting the data are created.

#### View the list of tables

```get virtual tables```

#### View columns in a table
Replace [dbms name] with the name given to DEFAULT_DBMS in the config file.

```get columns where dbms = [dbms name] and table = lightout1 ```

#### View data distribution (for each table)

```get data nodes```

#### Example queries
Replace [dbms name] with the name given to DEFAULT_DBMS in the config file.

```shell
run client () sql [dbms name] format=table "select count(*) from lightout1"
run client () sql [dbms name] format=table "select timestamp, value from lightout1 limit 20"
```

## Deploy the remote CLI

#### Enter the Remote CLI folder
 ```shell
cd deployments/training/remote-cli
```
#### Start the Remote CLI
```shell
docker-compose up -d
```

#### Open a browser with the following URL
```
http://[The IP of the Node]:31800
```
for example:
```
http://198.74.50.131:31800
```
