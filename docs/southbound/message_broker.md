---
layout: default
title: Message Broker
parent: Southbound
nav_order: 1
---
# Message Broker

EdgeLake has built-in ability to act as both broker and client for message protocols such as _MQTT_ and [_Kafka_](kafka.html). 

the ability is separated into 3 type of configurations for a given node:
<ul>
    <li><a href="#subscribing-to-a-third-party-broker">External Broker</a> - Subscribe to a third-party MQTT or Kafka broker</li>
    <li><a href="#configuring-an-anylog-node-as-a-message-broker">Message Broker</a> - receiving published data from a client using standard APIs like MQTT.</li>
    <li><a href="#anylog-as-a-broker-receiving-rest-commands">REST as Message Broker</a> - receiving REST commands and mapping the data to the needed schema based on the provided topic.</li>
</ul>

In all cases, user are able to do the following:
<ul>
    <li>Users can subscribe and retrieve data from one or more topics in a  broker.</li>
    <li>Users can publish data to a topic in a broker.</li>
</ul>

## Subscribing to a third-party broker
<p align="justified">This process initiates a client that subscribes to a list of topics registered on a broker. When a 
new message is added to the broker and associated with the subscribed topic, the broker will push the message to the 
EdgeLake instance. 

On the EdgeLake instance, messages are mapped to JSON structures and aggregated to files that are treated  according to 
the configuration of the node. For example, the data can be ingested to a local database or send to a different node. 
The message data on the AnyLog instance is treated as <b>streaming data</b>, this process is explained at 
<a href="https://github.com/AnyLog-co/documentation/blob/master/adding%20data.md#file-mode-and-streaming-mode" target="_blank">File Mode and Streaming Mode</a></pre>

### The Command Structure
<p align="justified">The command <code class="language-javascript">run msg client where ...</code> enables the message
client process to accept data from the local message broker and / or an third-party message broker. 

The subscription details of each topic are enclosed in the parenthesis and include 3 types of parameters:</pre> 
<ol start="1">
    <ul>
        <li>Connection Params - providing the information that allows to connect to the broker</li>
        <li>Config Params - Configuration parameters that apply to all messages regardless of the subscribed topic.</li>
        <li>Topic Params - Include the topic name and the rules of how to map the message such that it can be processed by the AnyLog node.</li>
    </ul>
</ol>

<pre class="code-frame"><code class="language-anylog">&lt;run msg client where
    broker=[Connection URL] and
    port=[Connection Port] and
    user=[Username if set] and 
    password=[Password associated with user] and
    log=[true/false] and 
    topic=(
        name=[Topic name] and
        dbms=[Database to store data in] and 
        table=[Logical table name] and
        column.timestamap.timestamp=[Timestamp key in JSON / now()]
        { other values }
    )&gt;</code></pre>

<h3>Connection Params</h3>

To connect to a broker, the broker URL is mandatory, and the rest depends on the type of broker, and the way the broker is configured.

<table>
    <tr>
        <th>Option</th>
        <th>Details</th>
    </tr>
    <tr>
        <td>broker</td>
        <td>The url or IP of the broker</td>
    </tr>
    <tr>
        <td>port</td>
        <td>The port of the broker. The default value is 1883</td>
    </tr>
    <tr>
        <td>user</td>
        <td>The name of the authorized user</td>
    </tr>
    <tr>
        <td>password</td>
        <td>The password associated with the user</td>
    </tr>
</table>

<h3> Configuration & Topic Params </h3>

<table>
    <tr>
        <th>Option</th>
        <th>Details</th>
        <th>Command Structure</th>
        <th>Comments</th>
    </tr>
    <tr>
        <td>log</td>
        <td>A true/false value to output the broker log messages.</td>
    </tr>
    <tr>
        <td>name</td>
        <td>The topic name to which the process subscribes</td>
    </tr>
    <tr>
        <td>dbms</td>
        <td>The logical database that contains the topic's data or a bring command to extract the dbms name.</td>
        <td><code class="language-anylog">dbms=value</code> <br/><br/> <code class="language-anylog">dbms="bring [JSON key name]"</code></td>
        <td>Uppercase letters are replaced to lowercase and space is replaced by underscore</td>
    </tr>
    <tr>
        <td>log</td>
        <td>A true/false value to output the broker log messages.</td>
    </tr>
    <tr>
        <td>table</td>
        <td>The name of the table to contain the data or a <code>bring</code> command to extract the table name</td>
        <td><code class="language-anylog">table=value</code> <br/><br/> <code class="language-anylog">table="bring [JSON key name]"</code></td>
    </tr>
    <tr>
        <td>column.timestamp.timestamp</td>
        <td>Same as column.name.type, but specifically for <i>timestamp</i> column</td>
        <td><code class="language-anylog">column.timestamp.timestamp=now()</code> <br/><br/> <code class="language-anylog">column.timestamp.timestamp="bring [JSON key name]"</code></td>
    </tr>
    <tr>
        <td>column.name.type</td>
        <td>The column name and column type that is associated with the data extracted from the message. The column is associated with the bring command that details the rule to extract the column data. Alternatively, users can define column as follows: <code class="language-anylog">column.value=(type=[Value type] and value="bring [key name]")</code></td>
        <td><code class="language-anylog">column.column name].[data_type] = "bring [JSON key name]"</code> <br/><br/> <code class="language-anylog">column.column name] = (type=[data_type] and value="bring [JSON key name]")</code></td>
        <td>Supported types: str, float, int and bool</td>
    </tr>
</table>

<h3>Sample MQTT Call</h3>

The following example receives timestamp / value data from AnyLog's running <i>MQTT</i> dummy data generator

<pre class="code-frame"><code class="language-anylog">&lt;run msg client where broker=139.144.46.246 and port=1883 and user=1883 and password=mqtt4AnyLog! and log=false and topic=(
    name=anylog-demo and
    dbms="bring [dbms]" and
    table="bring [table]" and
    column.timestamp.timestamp="bring [timestamp]" and
    column.value=(type=float and value="bring [value]")
)&gt;</code></pre>

<h3>Other Components of MQTT  / Message Client</h3>

**QoS - Quality of Service**: Technologies that work on a network to control traffic and ensure the performance of critical applications with limited network capacity
<ol start="1">
    <ul>
        <li> <b>QoS 0</b>: No guarantee of delivery. The recipient does not acknowledge receipt of the message. The value serves as the default value.</li>
        <li> <b>QoS 1</b>: Guarantees that a message is delivered at least one time to the receiver, but the same message may be delivered multiple times.</li>
        <li> <b>QoS 2</b>: The highest level of service. Guarantees that each message is received only once by the client.</li>
    </ul>
</ol>

The _QoS_ value can be set as part of either the topic information and/or the broker sending the data into EdgeLake. 

**What is <code class="language-anylog">bring</code> command**: 

The <code class="language-anylog">bring</code> command is an EdgeLake command that extracts data  from a JSON structure. 
The message data is structured in JSON and the _bring_ command is applied to the message to retrieve the needed data. 
The bring command is used in the same way it is being used in the blockchain commands. The command usage is explained at: 
<a href="https://github.com/AnyLog-co/documentation/blob/master/json%20data%20transformation.md#json-data-transformation" target="_blaank">JSON Data Transformation</a>>


## Configuring an AnyLog node as a message broker


## AnyLog as a broker receiving REST commands 
