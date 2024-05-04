---
layout: default
parent: Southbound Examples
title: Telegraf
nav_order: 3
---
# Telegraf 

Created by InfluxDB, [Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) is the open source server 
agent to help you collect metrics from your stacks, sensors and systems.

## Configuring EdgeLake

EdgeLake / AnyLog is able to accept data from _Telegraf_ via REST POST or its message broker using a generic [mapping 
policy](generic_mapping_policy).  

1. Create a mapping policy to accept data  - notice that excpet for `timestamp`,  all other columns will   
```anylog
# create policy 
policy_id = telegraf-mapping
topic_name = telegraf-data
default_dbms = new_company 

<new_policy = {"mapping" : {
        "id" : !policy_id,
        "dbms" : !default_dbms,
        "table" : "telegraf_data",
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
}>

# publish policy 
blockchain insert where policy=!new_policy and local=true and master=!ledger_conn
```

2. Enable a message client to accept the data from Telegraf. 
```anylog
# REST message client 
<run msg client where broker=rest and user-agent=anylog and log=false and topic=(
    name=!topic_name and
    policy=!policy_id
)>

# MQTT broker message client
<run msg client where broker=local and log=false and topic=(
    name=!topic_name and
    policy=!policy_id
)>

```

## Configuring Telegraf

At its core, _Telegraf_ returns a list of JSONs (shown below). This data can be published into EdgeLake via _REST_ POST 
or EdgeLake's local (MQTT) message broker. For this example, we'll be using their _cpu_, _mem_, _net_ and _swap_ 
input filters.  

```json
{"metrics":[
  {
    "fields": {
      "usage_guest":0,"usage_guest_nice":0,"usage_idle":90.42338709680185,"usage_iowait":0,"usage_irq":0,
      "usage_nice":0,"usage_softirq":0,"usage_steal":0,"usage_system":2.520161290323024,"usage_user":7.0564516129026345
    }
  },
  "name": "cpu",
  "tags": {"cpu":"cpu0","host":"Oris-Mac-mini.local"},
  "timestamp": 1714855140
}]
```

### Configuring REST 
1. Create a configurations file for REST 
```shell
telegraf --input-filter cpu:mem:net:swap  --output-filter http config > telegraf.conf
```

2. The following parameters under `[[outputs.http]]` for `telegraf.conf` 
* url - REST connection information  
* method - set as POST 
* data_format - set as JSON
* Update headers information under `[outputs.http.headers]`  -- notice the topic value is the same as the topic in 
`run msg client`

Sample configurations 
```configuration
...
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
```

3. Start Telegraf 
```shell
telegraf -config /home/edgelake/influx-telegraf/telegraf.conf
```



### Configuring MQTT 
1. Create a configurations file for REST 
```shell
telegraf --input-filter cpu:mem:net:swap  --output-filter mqtt config > telegraf.conf
```

2. The following parameters under `[[outputs.mqtt]]` for `telegraf.conf` 
* servers - Message broker connection information
* topic - specify the MQTT topic, should be the same as the topic used in `run mesg client`.
* bath - should be set _true_
* data_format - set as JSON

Sample configurations 
```configuration
...
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
  ## {{ .TopicPrefix }}/{{ .Hostname }}/{{ .PluginName }}/{{ .Tag "tag_key" }}
  ## (e.g. prefix/web01.example.com/mem/some_tag_value)
  ## Each path segment accepts either a template placeholder, an environment variable, or a tag key
  ## of the form `{{.Tag "tag_key_name"}}`. Empty path elements as well as special MQTT characters
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
```

3. Start Telegraf 
```shell
telegraf -config /home/edgelake/influx-telegraf/telegraf.conf
```

