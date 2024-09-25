---
layout: default
title: Network Health
parent: Southbound
nav_order: 8
---
# Monitoring Network State
One of the features EdgeLake offers is the ability to monitor the status of machines across the network from a centralized 
location, including system logs and node insights such as CPU and memory utilization, treating them as if they were IoT 
or other device data. 

The (basic) configuration files have a section called monitoring, by enabling these configurations an operator node will 
accept both syslog and monitoring data automatically, while other nodes will automatically begin to send monitoring data.

<pre class="code-frame"><code class="language-dotenv">#--- Monitoring ---
# Whether to monitor the node or not
MONITOR_NODES=true
# Store monitoring in Operator node(s)
STORE_MONITORING=true
# For operator, accept syslog data from local & other nodes
STORE_MONITORING=true</code></pre>

<h3>Node Monitoring</h3> 
[Monitoring section](../northbound/node_monitoring.html) discusses the general monitoring capabilities and sending data 
on query node (enabled by default). However, users may also be interested to archive / query node monitoring insight; 
for this users can execute the [stream command](../northbound/node_monitoring.html#Archive-Data). When deploying 
automatically or through the deplyoment scripts, the following steps occur: 
<pre class="code-frame"><code class="language-anylog">process !anylog_path/deployment-scripts/demo-scripts/monitoring_policy.al</code></pre>

**Steps**: 
<ol start="1"> 
    <li>Create a new policy with a pre-defined table name monitoring.node_insight</li>
    <li>Connect to monitoring database</li>
    <li>Based on policy create table node_insight in monitoring</li>
    <li>Based on policy create table node_insight in monitoring</li>
<pre class="code-frame"><code class="language-sql">CREATE TABLE IF NOT EXISTS node_insight(
    row_id INTEGER PRIMARY KEY AUTOINCREMENT,
    insert_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tsd_name CHAR(3),
    tsd_id INT,
    node_name varchar,
    status varchar,
    operational_time TIME NOT NULL DEFAULT '00:00:00',
    processing_time TIME NOT NULL DEFAULT '00:00:00',
    elapsed_time TIME NOT NULL DEFAULT '00:00:00',
    new_rows INT,
    total_rows INT,
    new_errors INT,
    total_errors INT,
    avg_rows_sec FLOAT,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    free_space_percent FLOAT,
    cpu_percent FLOAT,
    packets_recv INT,
    packets_sent INT,
    network_error INT
);
CREATE INDEX node_insight_timestamp_index ON node_insight(timestamp);
CREATE INDEX node_insight_tsd_index ON node_insight(tsd_name, tsd_id);
CREATE INDEX node_insight_insert_timestamp_index ON node_insight(insert_timestamp);
CREATE INDEX node_insight_node_name_index ON node_insight(node_name);</code></pre>
    <li>Set 12 hour partitons and keep a record of the last 3 partitions</li>
    <li>Run policy based node insight schedule policy</li>
</ol>

<h3>Syslog</h3>
The <a href="https://github.com/AnyLog-co/deployment-scripts/blob/main/demo-scripts/syslog.al" target=_blank>syslog script</a> is
a component of the deployment process that allows to gather syslog and stores it into an operator node. 

Before running the EdgeLake script, enable rsyslog configurations to send data into operator node. this step should be 
done on every machine that's sending data into EdgeLake. 

<pre class="code-frame"><code class="language-config">template(name="MyCustomTemplate" type="string" string="<%PRI%>%TIMESTAMP% %HOSTNAME% %syslogtag% %msg%\n")
$IncludeConfig /etc/rsyslog.d/*.conf
*.* ?remote-incoming-logs
*.* action(type="omfwd" target="[Operator IP]" port="[Operator Message Broker]" protocol="tcp" template="MyCustomTemplate")</code></pre>

On the node that's accepting syslog insights, run the following script to automatically accepting data into said operator. 

<pre class="code-frame"><code class="language-anylog">process !anylog_path/deployment-scripts/demo-scripts/syslog.al</code></pre>

**Steps**
<ol start="0">
    <li>Start Message broker if not already running</li>
    <li>Create a new policy with a pre-defined table named monitoring.syslog</li>
    <li>Connect database monitoring in sqlite</li>
    <li>Based on policy create table syslog in monitoring</li>
<pre class="code-frame"><code class="language-sql">CREATE TABLE IF NOT EXISTS syslog(
    row_id SERIAL PRIMARY KEY,
    insert_timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    tsd_name CHAR(3),
    tsd_id INT,
    source_ip cidr,
    priority int,
    timestamp timestamp not null default now(),
    hostname varchar,
    tag varchar,
    message varchar
);
CREATE INDEX syslog_timestamp_index ON syslog(timestamp);
CREATE INDEX syslog_tsd_index ON syslog(tsd_name, tsd_id);
CREATE INDEX syslog_insert_timestamp_index ON syslog(insert_timestamp);
CREATE INDEX syslog_source_ip_index ON syslog(source_ip);</code></pre>
    <li>Set 12 hour partitons and keep a record of the last 3 partitions</li>
    <li>Run message rule to accept syslog data. When accepting data from multiple syslogs, make sure each node has a unique name</li>
<pre class="code-frame"><code class="language-anylog">&lt;set msg rule [RULE_NAME] if
   ip = !ip
then
   dbms = monitoring  and
   table = syslog and
   extend = ip and
   syslog = true&gt;</code></pre>
</ol>













 