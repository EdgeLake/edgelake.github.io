---
layout: default
parent: Southbound
title: Telegraf
nav_order: 2
---
# Telegraf 

Created by InfluxDB, [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) is the open source server agent to collect metrics from stacks, sensors and systems.

## Configuring EdgeLake

EdgeLake can be configured to service _Telegraf_ via REST POST or as a message broker.  
On _Telegraf_, the output is configured to be in JSON, and when data is streamed to an EdgeLake node,
a mapping policy (like the example policy in this document) transforms the JSON readings to the EdgeLake target structure.

<ol start="1">
<li>Create a mapping policy to accept data  - notice that except for <code class="language-anylog">timestamp</code>,  all other source attributes remain unchanged. 
<pre class="code-frame"><code class="language-anylog"># create policy 
policy_id = telegraf-mapping
topic_name = telegraf-data
default_dbms = new_company 

&lt;new_policy = {"mapping" : {
        "id" : !policy_id,
        "dbms" : !default_dbms,
        "table" : "bring [name] _ [tags][name]:[tags][host]",
        "readings": "metrics",
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

# Publish Policy 
blockchain insert where policy=!new_policy and local=true and master=!ledger_conn</code></pre></li>

<br/>
<b>Disclaimer</b>: In the Telegraf configurations, you'll need to extract the content from <i>metrics</i> using 
<code>json_string_fields=["metrics"]</code> parameter. Farther details can be found <a href="https://docs.influxdata.com/telegraf/v1/data_formats/input/json/" target="_blank">here</a>. 
<br/> 

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
)&gt;
</code></pre></li></ol>

## Configuring Telegraf

At its core, _Telegraf_ returns a list of JSONs (shown below). This data can be published into EdgeLake via _REST_ POST 
or EdgeLake's local (MQTT) message broker. For this example, we'll be using their _cpu_, _mem_, _net_ and _swap_ 
input filters.  

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
    "name":"swap","tags":{"host":"Oris-Mac-mini.local"},"timestamp":1715018940
  },
  {"fields":{"bytes_recv":0,"bytes_sent":80,"drop_in":0,"drop_out":0,"err_in":0,"err_out":0,"packets_recv":0,"packets_sent":1,"speed":-1},
    "name":"net",
    "tags":{"host":"Oris-Mac-mini.local","interface":"utun3"},
    "timestamp":1715018940
  }
]}
</code></pre>

### Configuring REST 
<ol start="1">
<li>Create a configurations file for REST 
<pre class="code-frame"><code class="language-shell">telegraf --input-filter cpu:mem:net:swap  --output-filter http config > telegraf.conf</code></pre>
</li>

<li>The following parameters under `[[outputs.http]]` for `telegraf.conf`
    <ul style="padding-left: 20px;">
        <li>user - REST connection information</li> 
        <li>method - set as POST</li>
        <li>data_format - set as JSON</li>
        <li>Update headers information under <code class="language-config">[outputs.http.headers]</code> -- notice the topic value is the same as the topic in <code class="language-config">run msg client</code></li>
    </ul> 
<b>Sample Configurations</b>
<pre class="code-frame"><code class="language-shell">...
# A plugin that can transmit metrics over HTTP
[[outputs.http]]
  ## URL is the address to send metrics to
  url = "http://10.0.0.228:32149"
  
  ## Timeout for HTTP message
  # timeout = "5s"

  ## HTTP method, one of: "POST" or "PUT" or "PATCH"
  method = "POST"
  
  ...
  
  ## Data format to output.
  ## Each data format has it's own unique set of configuration options, read
  ## more about them here:
  ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
  data_format = "json"
  
  ...
  
  ## Additional HTTP headers
  # [outputs.http.headers]
  #   ## Should be set manually to "application/json" for json data_format
  #   Content-Type = "text/plain; charset=utf-8"
  [outputs.http.headers]
    command = "data"
    topic = "telegraf-data"
    User-Agent = "AnyLog/1.23"
    Content-Type = "text/plain"
...</code></pre></li>

<li>Start Telegraf
<pre class="code-frame"><code class="language-shell">telegraf -config /home/edgelake/influx-telegraf/telegraf.conf</code></pre>
</li></ol>

## Configuring EdgeLake

### Configuring the Message Broker Service

[Message broker service](../commands/backgound_services.md#message-broker-services) configures an EdgeLake service to act 
as a _MQTT_ or _Kafka_ message broker, and storing the accepted message into the respected operator. Enabling a message 
broker can be done via a configuration policy or the following command.  

<pre class="code-frame"><code class="language-anylog">&lt;run message broker where
    external_ip=!external_ip and external_port=!anylog_broker_port and
    internal_ip=!ip and internal_port=!anylog_broker_port and
    bind=!broker_bind and threads=!broker_threads&gt;
</code></pre>

The following steps are done on _Telegraf_ side. 
<ol start="1">
<li>Create a configurations file for REST 
<pre class="code-frame"><code class="language-shell">telegraf --input-filter cpu:mem:net:swap  --output-filter mqtt config > telegraf.conf</code></pre>
</li>

<li>The following parameters under <code class="language-config">[[outputs.mqtt]]</code> for <code>telegraf.conf</code> 
    <ul style="padding-left: 20px;">
        <li>servers - Message broker connection information</li>
        <li>topic - specify the MQTT topic, should be the same as the topic used in <code>run msg client</code></li>
        <li>bath - should be set <i>true</i></li>
        <li>data_format - set as JSON</li>
    </ul>
<b>Sample configurations</b> 
<pre class="code-frame"><code class="language-config">...
[[outputs.mqtt]]
  ## MQTT Brokers
  ## The list of brokers should only include the hostname or IP address and the
  ## port to the broker. This should follow the format `[{scheme}://]{host}:{port}`. For
  ## example, `localhost:1883` or `mqtt://localhost:1883`.
  ## Scheme can be any of the following: tcp://, mqtt://, tls://, mqtts://
  ## non-TLS and TLS servers can not be mix-and-matched.
  servers = ["10.0.0.78:7850", ] # or ["mqtts://tls.example.com:1883"]
  
  ...
  ## MQTT Topic for Producer Messages
  ## In case a tag is missing in the metric, that path segment omitted for the final topic.
  topic = "telegraf-data"
  
  ...
  
  ## When true, metrics will be sent in one MQTT message per flush. Otherwise,
  ## metrics are written one metric per MQTT message.
  ## DEPRECATED: Use layout option instead
  batch = true
  
  ...
  
  ## Each data format has its own unique set of configuration options, read
  ## more about them here:
  ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
  data_format = "json"
</code></pre></li>

<li>Start Telegraf
<pre class="code-frame"><code class="language-shell">telegraf -config /home/edgelake/influx-telegraf/telegraf.conf</code></pre>
</li></ol>