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

### Machine A - Master Node
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
    <br/>
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




#### Start the node

```docker-compose up -d```

#### Attach & test

```docker attach --detach-keys=ctrl-d anylog-master``` (and hit the Enter key)

* Test the network by issuing the command: **test network** on the AnyLog CLI (One node - the Master, is identified).

* Copy the Network ID (the IP and Port of the master) - use the command: ```get connections``` to view the IP and Port info.
    This network ID is added to the configuration of the member nodes to make them members of the network associated with this master.  
    Example:
    ```
    AL anylog-master +> get connections
    
    Type      External Address    Internal Address    Bind Address  
    ---------|-------------------|-------------------|-------------|
    TCP      |198.74.50.131:32048|198.74.50.131:32048|0.0.0.0:32048|
    REST     |198.74.50.131:32049|198.74.50.131:32049|0.0.0.0:32049|
    Messaging|Not declared       |Not declared       |Not declared |
    ```
    The Network ID in the example above is identified by TCP/External-Address and is: ```198.74.50.131:32048```.  
    This ID is added to each participating node to make it a member of the same network.

#### Detach

Using the keys: **ctrl+d**

## Deploy the Query node

#### Update the configs

In the folder ```cd deployments/training/anylog-query``` update the ```anylog_configs.env``` file as follows:
* LICENSE_KEY with the AnyLog License Key (if different than the default).
* NODE_NAME is set to anylog-query
* COMPANY_NAME with your company name.
* LEDGER_CONN with the Network ID - the IP and Port of the Master Node (for example: LEDGER_CONN=198.74.50.131:32048).

#### Start the node

```docker-compose up -d```

#### Attach & test

```docker attach --detach-keys=ctrl-d anylog-query``` (and hit the Enter key)

Test the network by issuing the command: **test network** on the AnyLog CLI (Two nodes - a Master and a Query node are identified).

#### Detach

Using the keys: **ctrl+d**

## Deploy the Operator nodes (one node on each physical machine)

In the folder ```cd deployments/training/anylog-operator``` update the ```anylog_configs.env``` file as follows:
* LICENSE_KEY with the AnyLog License Key (if different than the default).
* COMPANY_NAME with your company name.
* LEDGER_CONN with the Network ID - the IP and Port of the Master Node (for example: LEDGER_CONN=198.74.50.131:32048).
* NODE_NAME - currently showing **anylog-operator**, change to be unique (and anylog can be replaced with your company name):
    - for operator 1: **anylog-operator_1**
    - for operator 2: **anylog-operator_2**
* CLUSTER_NAME - currently showing **new-company-cluster**. change to your company name (the example below is 
using anylog for new-company) and a unique prefix like the example below:
    - for operator 1: **anylog-cluster_1**
    - for operator 2: **anylog-cluster_2**
* DEFAULT_DBMS - a logical database name for test data. Use the same name on both operators (or use the default name - **test**).    
        
#### Start the node

```docker-compose up -d```

#### Attach & test

```docker attach --detach-keys=ctrl-d anylog-operator```  (and hit the Enter key)

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
