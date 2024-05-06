---
layout: default
parent: Southbound Examples
title: Telegraf
nav_order: 1
---
# Telegraf 

Created by InfluxDB, [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) is the open source server agent to help you collect metrics from your stacks, sensors and systems.

## Configuring EdgeLake

EdgeLake / AnyLog is able to accept data from _Telegraf_ via REST POST or its message broker using a generic [mapping 
policy](generic_mapping_policy).  

1. Create a mapping policy to accept data  - notice that excpet for `timestamp`,  all other columns will   
<pre class="code-frame"><code class="language-anylog"># create policy 
policy_id = telegraf-mapping
topic_name = telegraf-data
default_dbms = new_company 

&lt;new_policy = {"mapping" : {
        "id" : !policy_id,
        "dbms" : !default_dbms,
        "table" : "bring [metrics][*][name] _ [metrics][*][tags][name]:[metrics][*][tags][host]",
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

# publish policy 
blockchain insert where policy=!new_policy and local=true and master=!ledger_conn
</code></pre>

2. Enable a message client to accept the data from Telegraf. 
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
</code></pre>
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
1. Create a configurations file for REST 
<pre class="code-frame"><code class="language-shell">telegraf --input-filter cpu:mem:net:swap  --output-filter http config > telegraf.conf</code></pre>

2. The following parameters under `[[outputs.http]]` for `telegraf.conf` 
* url - REST connection information  
* method - set as POST 
* data_format - set as JSON
* Update headers information under `[outputs.http.headers]`  -- notice the topic value is the same as the topic in 
`run msg client`

Sample configurations 
<pre class="code-frame"><code class="language-config">...
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
...
</code></pre>

3. Start Telegraf 
<pre class="code-frame"><code class="language-shell">telegraf -config /home/edgelake/influx-telegraf/telegraf.conf</code></pre>


### Configuring MQTT 
1. Create a configurations file for REST 
<pre class="code-frame"><code class="language-shell">telegraf --input-filter cpu:mem:net:swap  --output-filter mqtt config > telegraf.conf</code></pre>

2. The following parameters under `[[outputs.mqtt]]` for `telegraf.conf` 
* servers - Message broker connection information
* topic - specify the MQTT topic, should be the same as the topic used in `run mesg client`.
* bath - should be set _true_
* data_format - set as JSON

Sample configurations 
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
  ## MQTT outputs send metrics to this topic format:
  ## <!-- {{ .TopicPrefix }}/{{ .Hostname }}/{{ .PluginName }}/{{ .Tag "tag_key" }} --> 
  ## (e.g. prefix/web01.example.com/mem/some_tag_value)
  ## Each path segment accepts either a template placeholder, an environment variable, or a tag key
  ## of the form <!-- `{{.Tag "tag_key_name"}}` -->. Empty path elements as well as special MQTT characters
  ## (such as `+` or `#`) are invalid to form the topic name and will lead to an error.
  ## In case a tag is missing in the metric, that path segment omitted for the final topic.
  topic = "telegraf-broker"
  
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
</code></pre>

3. Start Telegraf 
<pre class="code-frame"><code class="language-shell">telegraf -config /home/edgelake/influx-telegraf/telegraf.conf</code></pre>

