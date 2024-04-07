# Metadata commands

The metadata commands are agnostic to the metadata platform used. When an EdgeLake network is deployed, users can 
select a blockchain platform or a master node as their metadata storage, The metadata commands operate indistinguishably 
on the platform used.

Note: The metadata commands start with the keyword blockchain, regardless if the metadata platform used.

## Blockchain Seed
The **blockchain seed** command pulls a copy of the metadata from a peer node. When a node is properly configured,
the [run synchronizer](backgound_services.md#run-blockchain-sync) command pulls the updated version of the metadata continuously.  
The **blockchain seed** command is used to support a node that is not configured with the synchronizer process.  

**Usage**:
<pre>
    <code>
blockchain seed from [ip:port]
    </code>
</pre>

**Explanation**:  Pull the metadata from a source node.

**Examples**:
<pre>
    <code>
blockchain seed from 73.202.142.172:7848
    </code>
</pre>

**Details**: [Retrieve the Metadata from a source node](https://github.com/AnyLog-co/documentation/blob/master/blockchain%20commands.md#retrieving-the-metadata-from-a-source-node)

## Add a policy to the metadata

**Usage**:
<pre>
    <code>
blockchain insert where policy = [policy] and blockchain = [platform] and local = [true/false] and master = [IP:Port]
    </code>
</pre>

Identify the metadata platform by including one of these 2 values: 
* blockchain - the blockchain platform to use
* master - the ip and port of the master node.

**Explanation**:  Add a JSON policy to the specified blockchain platform.

**Examples**:
<pre>
    <code>
blockchain insert where policy = !policy and local = true and master = !master_node
blockchain insert where policy = !policy and local = true and blockchain = ethereum
    </code>
</pre>

**Details**: [Blockchain Insert Command](https://github.com/AnyLog-co/documentation/blob/master/blockchain%20commands.md#the-blockchain-insert-command)

## Connect to a blockchain platform
The **blockchain connect** and **blockchain set account info** commands are used to connect to the blockchain platform. 
Ignore these commands if a master node is used.

### Blockchain Connect
**Usage**:
<pre>
    <code>
blockchain connect to [platform] where provider = [provider] and [connection params]
    </code>
</pre>

**Explanation**: Connect to the blockchain platform using the connection params.

**Examples**:
<pre>
    <code>
blockchain connect to ethereum where provider = https://rinkeby.infura.io/v3/... and contract = 0x3899bED... and private_key = a4caa21209188 ... and public_key = 0x982AF5e15... and gas_read = 3000000 and gas_write = 4000000
    </code>
</pre>

**Details**: [Using Ethereum as a Global Metadata Platform](https://github.com/AnyLog-co/documentation/blob/master/using%20ethereum.md#using-ethereum-as-a-global-metadata-platform).

### Blockchain set Account Info

**Usage**:
<pre>
    <code>
blockchain set account info where platform = [platform name] and [platform parameters]
    </code>
</pre>

**Explanation**: Associate account parameters with the blockchain platform.

**Examples**:
<pre>
    <code>
blockchain set account info where platform = ethereum and private_key = !private_key and public_key = !public_key and chain_id = 11155111
    </code>
</pre>

**Details**: [Using Ethereum as a Global Metadata Platform](https://github.com/AnyLog-co/documentation/blob/master/using%20ethereum.md#using-ethereum-as-a-global-metadata-platform).

## Enable a master Node
If a master node is used, prepare a database table called **ledger** to host a local copy of the ledger using the 
**blockchain create table** command.

### blockchain create table

**Usage**:
<pre>
    <code>
blockchain create table
    </code>
</pre>

**Explanation**: Create the 'ledger' table on the local **blockchain** DBMS.    
Note: Associate a physical database (like PostgreSQL) to the logical DBMS (**blockchain**) prior to creating the 
ledger table. A physical database is associated to a logical database using the [connect dbms](data_management.md#associate-a-physical-database-to-a-logical-database) command.

**Examples**:
<pre>
    <code>
blockchain create table
    </code>
</pre>







blockchain delete local file
blockchain delete policy where id = [policy id] and master = [IP:Port] and local =[true/false]
blockchain deploy contract where platform = [platform name] and public_key = [public key]
blockchain drop by host [ip]
blockchain drop policy where id = [policy id]
blockchain drop policy [policy]
blockchain drop table
blockchain get [policy type] [where] [attribute name value pairs] [bring] [bring command variables]
blockchain insert where policy = [policy] and blockchain = [platform] and local = [true/false] and master = [IP:Port]
blockchain load metadata
blockchain prepare policy [policy]
blockchain pull to [json | sql | stdout] [file name]
blockchain push [policy]
blockchain query metadata
blockchain read [policy type] [where] [attribute name value pairs] [bring] [bring command variables]
blockchain reload metadata
blockchain replace policy [policy id] with [new policy]
blockchain set account info where platform = [platform name] and [platform parameters]
blockchain state where platform = [platform name]
blockchain switch network where master = [IP:Port]
blockchain test
blockchain test cluster
blockchain update dbms [path and file name] [ignore message]
