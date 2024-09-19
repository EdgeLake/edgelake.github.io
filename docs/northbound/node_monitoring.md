---
layout: default
title: Monitoring
parent: Commands
nav_order: 6
---
# Monitoring
Nodes in the network can collect and monitor information on data and state. The collected information can be retrieved 
from the node, or collected in a database or send to an aggregator node where data from multiple nodes is aggregated and 
available to query.

<ul>
    <li>Data ingested to local databases and data volumes in the tables.</li>
    <li>Performance of Queries</li>
    <li>Physical Machine Utilization</li>
</ul>

## Monitoring Commands

<h3>Data Monitoring</h3>
An operator nodes stores data coming from different devices, and often times partitioned based on the needs of the user.
One of the ways to monitor said data is by looking at things like row count and how much data is flowing in. 

<ul>
    <li>View tables in databases, and the number of rows in each table.</li>
<pre class="code-frame"><code class="language-anylog">get rows count where dbms = [dbms name] and table = [table name] and format = [table | json] and group = [partition/table]</code></pre>
    <li>View ingestion of data by an Operator node</li>
<pre class="code-frame"><code class="language-anylog"># General command
get operator
# Operator statistics
get operator stat format = [table | json]</code></pre> 
    <li>Lists the Operator nodes in the network and the tables supported on each node</li>
<pre class="code-frame"><code class="language-anylog">get data nodes where format=[table | json]</code></pre>
    <li>The streaming buffers status</li>
<pre class="code-frame"><code class="language-anylog">get streaming where format=[table | json]</code></pre>
</ul>

<h3>Query Performance</h3>
Similar to monitor data coming in, users can also monitor the performance of queries. This is done by 2 commands: 
<ul>
    <li>Status of query threads assigned.</li>
<pre class="code-frame"><code class="language-anylog">get query pool</code></pre>
    <li>Statistics on queries execution time</li>
<pre class="code-frame"><code class="language-anylog">get queries time where format=[table | json]</code></pre>
</ul>

<h3>Node Monitoring</h3>



<pre class="code-frame"><code class="language-json">{
    'node name' : 'anylog-query@172.232.20.156:32348',
    'status' : 'Active',
    'operational time' : '00:00:00',
    'processing time' : '00:00:00',
    'elapsed time' : '00:00:30',
    'new rows' : 0,
    'total rows' : 0,
    'new errors' : 0,
    'total errors' : 0,
    'avg. rows/sec' : 0.0,
    'timestamp' : '2024-09-19 15:34:50.112695',
    'Free space %' : 65.43,
    'CPU %' : 1.1,
    'Packets Recv' : 205093,
    'Packets Sent' : 201552,
    'Network Error' : 0
}</code></pre>


## Monitoring Node Health 

## Setting Up Monitoring Data
The monitoring data is executed using a <a href="../commands/backgound_services.md#the-scheduler-services>scheduled process</a>
The steps for this process automatically as a policy be run using 
<a href="https://github.com/AnyLog-co/deployment-scripts/blob/main/demo-scripts/monitoring_policy.al" target="_blank">monitoring policy</a>.
<pre class="code-frame"><code class="language-anylog">process deployment-scripts/demo-scripts/monitoring_policy.al</code></pre> 

### Steps
<ul>
    <li>Get List of query ndoes to store data in</li>
<pre class="code-frame"><code class="language-anylog">monitoring_ips = blockchain get query bring.ip_port</code></pre>
    <li></li>
</ul>

