---
layout: default
parent: Southbound
title: Telegraf
nav_order: 2
---
# Telegraf 

Created by InfluxDB, <a href="https://www.influxdata.com/time-series-platform/telegraf/" target="_blank">Telegraf</a> is an open-source agent to collect metrics from stacks, sensors and systems.

This document is based on <a href="https://www.influxdata.com/blog/telegraf-1-31-release-notes/" target="_blank">Telegraf 1.31.1</a>.

* [Requirements](#requirements)
* [Configure Telegraf - REST](#rest)
* [Configure Telegraf - Message Broker](#message-broker)
* [Configure EdgeLake](#configure-edgelake)
* 
 
## Requirements
1. [EdgeLake](../../training/quick_start/)
2. <a href="https://docs.influxdata.com/telegraf/v1/install/" target="_blank">Telegraf</a>

## Configure Telegraf
EdgeLake can accept data from _Telegraf_ that's in serialized list <a href="https://docs.influxdata.com/telegraf/v1/data_formats/input/json/" target="_blank">JSON format</a>, either via a [message broker](#message-broker) or [REST (POST)](#rest). 

The examples below is using machine monitoring as data inputs (_cpu_, _mem_, _net_ and _swap_), but the same logic  can 
be applied for any type of data input.

Note, data coming via JSON, seats inside a key called _metrics_ (as shown below). The configurations below for **both**
REST and MQTT extract the list of JSONs from within the _metrics_ key, thus sending only the associated list.

<b>Sample Data Generated</b>
<pre class="code-frame"><code class="language-json">{"metrics":[
  {
    "fields":{"active":7080853504,"available":7166590976,"available_percent":41.715049743652344,"free":415137792,"inactive":6751453184,"total":17179869184,"used":10013278208,"used_percent":58.284950256347656,"wired":1292861440},
    "name":"mem",
    "tags":{"host":"Oris-Mac-mini.local"},
    "timestamp":1715018940
  },
  {
    "fields":{"usage_guest":0,"usage_guest_nice":0,"usage_idle":89.91935483869311,"usage_iowait":0,"usage_irq":0,"usage_nice":0,"usage_softirq":0,"usage_steal":0,"usage_system":2.7217741935480912,"usage_user":7.358870967749625},
    "name":"cpu",
    "tags":{"cpu":"cpu0","host":"Oris-Mac-mini.local"},
    "timestamp":1715018940
  },
  {
    "fields":{"free":0,"total":0,"used":0,"used_percent":0},
    "name":"swap",
    "tags":{"host":"Oris-Mac-mini.local"},
    "timestamp":1715018940
  },
  {
    "fields":{"bytes_recv":0,"bytes_sent":80,"drop_in":0,"drop_out":0,"err_in":0,"err_out":0,"packets_recv":0,"packets_sent":1,"speed":-1},
    "name":"net",
    "tags":{"host":"Oris-Mac-mini.local","interface":"utun3"},
    "timestamp":1715018940
  }
]}</code></pre>

### REST
<ol start="1">
<li>Create a configurations file for REST 
<pre class="code-frame"><code class="language-shell">telegraf --input-filter cpu:mem:net:swap  --output-filter http config > telegraf.conf</code></pre>
</li>
<li>Update <code class="language-config">[[outputs.http]]</code> section in configuration file
    <ul>
        <li>URL</li>
        <li>method - POST</li>
        <li>data_format - JSON</li>
        <li>header information</li>
        <ul>
            <li>command - data</li>
            <li>topic - topic name</li>
            <li>User-Agent - AnyLog/1.23</li>
            <li>Content-Type - text/plain</li>
        </ul>
    </ul>
<pre class="code-frame"><code class="language-config">[[outputs.http]]
  url = "http://198.74.50.131:32149"
  method = "POST"
  data_format = "json"
  [outputs.http.headers]
    command = "data"
    topic = "telegraf-data"
    User-Agent = "AnyLog/1.23"
    Content-Type = "text/plain"
</code></pre>
</li>
<li>Start Telegraf
<pre class="code-frame"><code class="language-shell">telegraf --config telegraf.conf &gt; /dev/null 2&gt;&1 & </code></pre>
</li>
</ol>

### Message Broker
The following example uses MQTT output configuration; however, EdgeLake's message broker client also accepts data from 
Kafka. 

<ol start="1">
<li>Create a configurations file for MQTT 
<pre class="code-frame"><code class="language-shell">telegraf --input-filter cpu:mem:net:swap  --output-filter mqtt config > telegraf.conf</code></pre>
</li>
<li>Update <code class="language-config">[[outputs.mqtt]]</code> section in configuration file
    <ul>
        <li>servers - MQTT message broker connection information</li>
        <li>method - POST</li>
        <li>topic - topic name</li>
        <li>layout - non-batch</li>
        <li>data_format - json</li>
    </ul>
<pre class="code-frame"><code class="language-config">[[outputs.mqtt]]
    servers = ["198.74.50.131:32150"]
    topic = "telegraf-data"
    layout = "non-batch"
    data_format = "json"
</code></pre>
</li>
<li>Start Telegraf
<pre class="code-frame"><code class="language-shell">telegraf --config telegraf.conf &gt; /dev/null 2&gt;&1 & </code></pre>
</li>
</ol>

## Configure EdgeLake

EdgeLake requires a mapping policy for data coming in via REST POST or the message broker. The mapping policy transforms 
the JSON readings to the EdgeLake target structure. For _Telegraf_, EdgeLake allows mapping in a generic format where users
do not need to know the associated columns being generated. 

The following steps can be executed using <a href="https://github.com/EdgeLake/deployment-scripts/blob/main/demo-scripts/telegraf.al" target="_blank">telegraf.al</a>
script, which exists as part of the deployment scripts by default. 

<ol start="0">
<li>If using message client to accept data, make sure EdgeLake's Message Broker is running
<pre class="code-frame"><code class="language-anylog">&lt;run message broker where
    external_ip=!external_ip and external_port=!anylog_broker_port and
    internal_ip=!ip and internal_port=!anylog_broker_port and
    bind=!broker_bind and threads=!broker_threads&gt;</code></pre>
</li>
<li>Create a mapping policy to accept data - notice that except for <code>timestamp</code>, all other source attributes remain unchanged.
<pre class="code-frame"><code class="language-anylog">policy_id = telegraf-mapping
topic_name=telegraf-data

&lt;new_policy = {"mapping" : {
        "id" : !policy_id,
        "dbms" : !default_dbms,
        "table" : "bring [name] _ [tags][name]:[tags][host]",
        "schema" : {
                "timestamp" : {
                    "type" : "timestamp",
                    "default": "now()",
                    "bring" : "[timestamp]",
                    "apply" :  "epoch_to_datetime"
                },
                "*" : {
                    "type": "*",
                    "bring": ["fields", "tags"]
                }
         }
   }
}&gt;

blockchain insert where policy=!new_policy and local=true and master=!ledger_conn</code></pre>
</li>
<li>Enable a message client to accept the data from Telegraf.
<pre class="code-frame"><code class="language-anylog"># REST message client 
&lt;run msg client where broker=rest and user-agent=anylog and log=false and topic=(
    name=!topic_name and
    policy=!policy_id
)&gt;

# MQTT broker message client
&lt;run msg client where broker=local and log=false and topic=(
    name=!topic_name and
    policy=!policy_id
)&gt;</code></pre>
</li>
</ol>

## Generated Data 

   
