---
layout: default
parent: Getting Started
title: Session I
nav_order: 2
---
# The Basic Guided Tour

### Suggeted Readings
* [Getting Started](..%2Fgetting_started.md)
* [Prerequisite](prerequisite.md)

## Basic EdgeLake commands

The basic AnyLog commands demonstrated in the Onboarding session:

<ul>
    <li><b>Help commands</b> - See details in <a href="https://github.com/AnyLog-co/documentation/blob/master/getting%20started.md#the-help-command" target="blank">the help command section</a>
        <pre class="code-frame"><code class="language-anylog">help
help index
help index streaming
help run kafka consumer</code></pre></li>
    <li><b>Log Events</b> - Logs that track events - logs examples: <code class="language-anylog">event log</code>, 
<code class="language-anylog">error log</code>, <code class="language-anylog">rest log</code>, 
<code class="language-anylog">query log</code> (needs to be enabled).
    <pre class="code-frame"><code class="language-anylog">get event log
get error log</code></pre>
</li>
    <li><b>Node Name</b> - The name on the CLI prompt can be set by the user to identify the node when multiple CLIs are used.
    <pre class="code-frame"><code class="language-anylog">node_name = generic
# The assignment above makes the CLI prompt appear as:
EL generic >
</code></pre>
</li>
    <li><b>Local Directories</b> - The local dictionary maps local values (like paths names and IPs) to unified names that can 
be shared across nodes. Farther Details
    <ul>
        <li><a href="https://github.com/AnyLog-co/documentation/blob/master/dictionary.md#the-local-dictionary" target="_blank">Local Dictionary Section</a></li>
        <li><a href="..%2Fgetting_started.md/#nodes-directory-structure">Getting Started - Directors Section</a></li>
    </ul>
    <pre class="code-frame"><code class="language-anylog">get dictionary
abc = 123
!abc
!blockchain_file
get env var
$HOME

# Use the local dictionary to see the local folders' setup:
get dictionary _dir
</code></pre>
</li>
</ul>


## Communication Services

Each node can offer 3 types of communication services:

| Service Name   | Service Type |
| ------------- | ------------- |
| TCP  | A service allowing the node to send and receive messages from peer nodes using the AnyLog Network Protocol |
| REST  | A service allowing the node communicate with 3rd parties applications and data sources using REST |
| Messaging  | A message broker service allowing data sources and 3rd parties applications to publish data on the node |

## Node Configuration

<ul>
    <li>Enable the TCP and REST services and view existing connections:
<pre class="code-frame"><code class="language-anylog"># command returns no connection
get connections

run tcp server where internal_ip = !ip and internal_port = 20048 and external_ip = !external_ip and external_port = 20048 and bind = false and threads = 6
run rest server where internal_ip = !ip and internal_port = 20049 and external_ip = !external_ip and external_port = 20049 and bind = false

# command returns the details of each communication service
get connections   
</code></pre></li>
    <li>Enable message queue
<pre class="code-frame"><code class="language-anylog">set echo queue on
echo this is a test message
get echo queue
</code></pre>
</li>
    <li>Test node configuration - A node can validate proper configurations using the **test node** command.
<pre class="code-frame"><code class="language-anylog">test node</code></pre>
Details are available <a href="https://github.com/AnyLog-co/documentation/blob/master/test%20commands.md#test-node" target="_blank">here</a>.
</li>
    <li>Connecting to a DBMS - Supported databases: <i>PostgreSQL</i> for larger nodes and <i>SQLite</i> for smaller nodes or data in RAM
        <ul>2 system databases:    
            <li>system_query - orchestrate query results</li>
            <li>almgm - tracks data ingestion and Manage HA</li>
        </ul>
        <pre class="code-frame"><code class="language-anylog">connect dbms system_query where type = sqlite and memory = true # Used for local processing
get databases
</code></pre></li>
</ul>

## Metadata
A node in the network interacts with 2 layers of metadata:
* With a local metadata layer. The local metadata layer includes the local databases, tables and views that are used by the node to organize the data locally such that the data is unified with data on peer nodes and is accessible to permitted members of the network.
* With a global metadata layer shared by all the members of the network.

Details are available in <a href="https://github.com/AnyLog-co/documentation/blob/master//metadata%20management.md#managing-metadata" target="_blank">Managing Metadata</a> 
and <a href="https://github.com/AnyLog-co/documentation/blob/master/blockchain%20commands.md#blockchain-commands" target="_blank">Blockchain Commands</a>

<ul>
    <li>Copy the metadata from a peer node in the network. See details <a href="https://github.com/AnyLog-co/documentation/blob/master/blockchain%20commands.md#blockchain-commands" target="_blank">here</a>
    <pre class="code-frame"><code class="language-anylog">blockchain seed from [ip:port]</code></pre>
<b>Note</b>: the proper way to provide the metadata to a node is to enable the <b>blockchain synchronizer</b> service on the node.  
This process will update the node continuously with updates to the metadata. Details are available <a href="https://github.com/AnyLog-co/documentation/blob/master/background%20processes.md#blockchain-synchronizer" target="_blank">here</a>.</li>
<br/>
<br/>
    <li>Examples of metadata commands
    <pre class="code-frame"><code class="language-anylog">blockchain get *
blockchain get operator

blockchain get operator bring.table [operator][name] [operator][city] [operator][ip]  [operator][port] 
blockchain get operator where [city] = toronto  bring.table [operator][name] [operator][city] [operator][ip]  [operator][port] 

blockchain get operator where [city] = toronto  bring [operator][ip] : [operator][port] separator = ,

blockchain get operator where [city] = toronto  bring.ip_port
</code></pre></li>
</ul>



